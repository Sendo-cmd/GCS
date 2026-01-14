--[[
    AutoPlace_Test.lua
    ระบบ Auto Place แยกจาก AV_AutoPlay สำหรับทดสอบ
    
    Features:
    - Auto Place Damage Units อัตโนมัติ
    - ใช้ระบบ Placement จาก AV_AutoPlay (รองรับการวางนอกพื้นที่)
    - วิเคราะห์มุมโค้ง, Path Coverage, ทางขนาน
    - ปรับกลยุทธ์ตาม game phase (early/mid/late)
]]

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO REDEEM / CLAIM SYSTEM (loaded first to avoid local register limit)
-- ══════════════════════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(3)
    _G.AutoSystems = {Enabled = true, LastCodeRedeemTime = 0, LastAutoClaimRun = 0, RedeemedCodes = {}, FETCHED_CODES = {}, LastCodeFetchTime = 0}
    
    local Net = game:GetService("ReplicatedStorage"):WaitForChild("Networking", 10)
    if Net then
        pcall(function() _G.AutoSystems.CodesEvent = Net:FindFirstChild("CodesEvent") end)
        pcall(function() _G.AutoSystems.BattlepassEvent = Net:FindFirstChild("BattlepassEvent") end)
        pcall(function() _G.AutoSystems.DailyRewardEvent = Net:FindFirstChild("DailyRewardEvent") end)
        pcall(function() _G.AutoSystems.QuestEvent = Net:FindFirstChild("QuestEvent") or Net:FindFirstChild("Quests") end)
        pcall(function() _G.AutoSystems.NewPlayerRewardEvent = Net:FindFirstChild("NewPlayerRewardEvent") end)
        pcall(function() _G.AutoSystems.ReturningPlayerRewardEvent = Net:FindFirstChild("ReturningPlayerRewardEvent") end)
        pcall(function() _G.AutoSystems.APiratesWelcomeEvent = Net:FindFirstChild("APiratesWelcomeEvent") end)
    end
    
    _G.AutoSystems.IsInLobby = function()
        return (workspace:FindFirstChild("MainLobby") ~= nil) or (workspace:FindFirstChild("Map") == nil)
    end
    
    _G.AutoSystems.HttpGet = function(url)
        local ok, res = pcall(function()
            if syn and syn.request then return syn.request({Url=url,Method="GET"}).Body
            elseif request then return request({Url=url,Method="GET"}).Body
            elseif http_request then return http_request({Url=url,Method="GET"}).Body
            elseif game.HttpGet then return game:HttpGet(url) end
        end)
        return ok and res or nil
    end
    
    _G.AutoSystems.FetchCodes = function()
        if tick() - _G.AutoSystems.LastCodeFetchTime < 300 and #_G.AutoSystems.FETCHED_CODES > 0 then return _G.AutoSystems.FETCHED_CODES end
        pcall(function()
            local html = _G.AutoSystems.HttpGet("https://animevanguards.fandom.com/wiki/Codes")
            if html and #html > 100 then
                local codes = {}
                for code in html:gmatch('<code[^>]*>([^<]+)</code>') do
                    if code and #code > 2 and #code < 50 then table.insert(codes, code) end
                end
                if #codes > 0 then _G.AutoSystems.FETCHED_CODES = codes; _G.AutoSystems.LastCodeFetchTime = tick(); print("[AutoRedeem] Fetched "..#codes.." codes") end
            end
        end)
        return _G.AutoSystems.FETCHED_CODES
    end
    
    _G.AutoRedeem = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() or not _G.AutoSystems.CodesEvent then return end
        if tick() - _G.AutoSystems.LastCodeRedeemTime < 60 then return end
        _G.AutoSystems.LastCodeRedeemTime = tick()
        for _, code in ipairs(_G.AutoSystems.FetchCodes()) do
            if not _G.AutoSystems.RedeemedCodes[code] then
                pcall(function() _G.AutoSystems.CodesEvent:FireServer(code) end)
                _G.AutoSystems.RedeemedCodes[code] = true
                print("[AutoRedeem] "..code)
                task.wait(0.5)
            end
        end
    end
    
    _G.AutoBattlepass = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() or not _G.AutoSystems.BattlepassEvent then return end
        pcall(function() _G.AutoSystems.BattlepassEvent:FireServer("ClaimAll") end)
        for t = 1, 50 do
            pcall(function() _G.AutoSystems.BattlepassEvent:FireServer("Claim", {tostring(t), "Normal"}) end)
            pcall(function() _G.AutoSystems.BattlepassEvent:FireServer("Claim", {tostring(t), "Premium"}) end)
        end
        print("[AutoBattlepass] Done")
    end
    
    _G.AutoDaily = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() or not _G.AutoSystems.DailyRewardEvent then return end
        pcall(function() _G.AutoSystems.DailyRewardEvent:FireServer("Request") end)
        task.wait(0.3)
        for _, rt in ipairs({"Special", "Fall"}) do
            for d = 1, 28 do pcall(function() _G.AutoSystems.DailyRewardEvent:FireServer("Claim", {rt, d}) end) end
        end
        print("[AutoDaily] Done")
    end
    
    _G.AutoSpecial = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() then return end
        if _G.AutoSystems.NewPlayerRewardEvent then for d = 1, 7 do pcall(function() _G.AutoSystems.NewPlayerRewardEvent:FireServer("Claim", d) end) end end
        if _G.AutoSystems.ReturningPlayerRewardEvent then for d = 1, 7 do pcall(function() _G.AutoSystems.ReturningPlayerRewardEvent:FireServer("Claim", d) end) end end
        if _G.AutoSystems.APiratesWelcomeEvent then for d = 1, 7 do pcall(function() _G.AutoSystems.APiratesWelcomeEvent:FireServer("Claim", d) end) end end
    end
    
    _G.AutoQuest = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() then return end
        local Net = game:GetService("ReplicatedStorage"):FindFirstChild("Networking")
        if not Net then return end
        
        -- Try multiple quest events
        local questEvents = {"QuestEvent", "Quests", "QuestsEvent", "Quest"}
        for _, evName in ipairs(questEvents) do
            local ev = Net:FindFirstChild(evName)
            if ev then
                -- Try different claim methods
                pcall(function() ev:FireServer("ClaimAll") end)
                pcall(function() ev:FireServer("Claim", "All") end)
                pcall(function() ev:FireServer("ClaimAllRewards") end)
                
                -- Try claim by type
                for _, qt in ipairs({"Daily", "Weekly", "Infinite", "Event", "Special"}) do
                    pcall(function() ev:FireServer("Claim", qt) end)
                    pcall(function() ev:FireServer("ClaimReward", qt) end)
                    pcall(function() ev:FireServer(qt, "Claim") end)
                end
                
                -- Try claim by index (1-10 quests per type)
                for _, qt in ipairs({"Daily", "Weekly", "Infinite"}) do
                    for i = 1, 10 do
                        pcall(function() ev:FireServer("Claim", qt, i) end)
                        pcall(function() ev:FireServer("Claim", {qt, i}) end)
                        pcall(function() ev:FireServer("ClaimQuest", qt, i) end)
                    end
                end
            end
        end
        print("[AutoQuest] Done - tried all methods")
    end
    
    _G.RefreshCodes = function() _G.AutoSystems.LastCodeFetchTime = 0; _G.AutoSystems.FETCHED_CODES = {}; return _G.AutoSystems.FetchCodes() end
    
    -- Individual cooldowns (seconds)
    _G.AutoSystems.Cooldowns = {
        Redeem = 300,      -- 5 min
        Battlepass = 600,  -- 10 min  
        Daily = 600,       -- 10 min
        Special = 600,     -- 10 min
        Quest = 300,       -- 5 min
    }
    _G.AutoSystems.LastRun = {Redeem = 0, Battlepass = 0, Daily = 0, Special = 0, Quest = 0}
    
    _G.AutoClaim = function()
        if not _G.AutoSystems.Enabled or not _G.AutoSystems.IsInLobby() then return end
        local now = tick()
        local ran = {}
        
        if now - _G.AutoSystems.LastRun.Redeem >= _G.AutoSystems.Cooldowns.Redeem then
            _G.AutoSystems.LastRun.Redeem = now; pcall(_G.AutoRedeem); table.insert(ran, "Redeem")
        end
        if now - _G.AutoSystems.LastRun.Battlepass >= _G.AutoSystems.Cooldowns.Battlepass then
            _G.AutoSystems.LastRun.Battlepass = now; pcall(_G.AutoBattlepass); table.insert(ran, "Battlepass")
        end
        if now - _G.AutoSystems.LastRun.Daily >= _G.AutoSystems.Cooldowns.Daily then
            _G.AutoSystems.LastRun.Daily = now; pcall(_G.AutoDaily); table.insert(ran, "Daily")
        end
        if now - _G.AutoSystems.LastRun.Special >= _G.AutoSystems.Cooldowns.Special then
            _G.AutoSystems.LastRun.Special = now; pcall(_G.AutoSpecial); table.insert(ran, "Special")
        end
        if now - _G.AutoSystems.LastRun.Quest >= _G.AutoSystems.Cooldowns.Quest then
            _G.AutoSystems.LastRun.Quest = now; pcall(_G.AutoQuest); table.insert(ran, "Quest")
        end
        
        if #ran > 0 then print("[AutoSystems] Ran: " .. table.concat(ran, ", ")) end
    end
    
    -- Force run all (bypass cooldowns)
    _G.AutoClaimAll = function()
        if not _G.AutoSystems.IsInLobby() then print("[AutoSystems] Not in lobby"); return end
        print("[AutoSystems] Force running all...")
        _G.AutoSystems.LastRun = {Redeem = 0, Battlepass = 0, Daily = 0, Special = 0, Quest = 0}
        pcall(_G.AutoRedeem); pcall(_G.AutoBattlepass); pcall(_G.AutoDaily); pcall(_G.AutoSpecial); pcall(_G.AutoQuest)
        print("[AutoSystems] Complete")
    end
    
    print("[AutoSystems] ✅ Loaded! IsInLobby=" .. tostring(_G.AutoSystems.IsInLobby()))
    print("[AutoSystems] Commands: _G.AutoClaim(), _G.AutoClaimAll(), _G.AutoRedeem(), _G.RefreshCodes()")
    
    -- Initial run if in lobby
    if _G.AutoSystems.IsInLobby() then
        task.wait(2)
        print("[AutoSystems] 🚀 Starting auto systems in lobby...")
        pcall(_G.AutoClaimAll)
    end
    
    -- Smart loop - checks every 30 seconds, runs only what's ready
    while true do
        task.wait(30)
        if _G.AutoSystems.Enabled and _G.AutoSystems.IsInLobby() then
            pcall(_G.AutoClaim)
        end
    end
end)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ===== CONFIGURATION (ไม่ใช้ Settings แล้ว - หาข้อมูลจาก UnitsData) =====
local ENABLED = true
local DEBUG = true

-- ===== UNIT CLASSIFICATION =====
local UnitType = {
    ECONOMY = "Economy",
    DAMAGE = "Damage",
    BUFF = "Buff",
    UNKNOWN = "Unknown"
}

-- ===== LOAD MODULES =====
local UnitsHUD, ClientUnitHandler, UnitPlacementHandler, PlacementValidationHandler
local EnemyPathHandler, PathMathHandler, ClientGameStateHandler, PlayerYenHandler
local GlobalMatchSettings, UnitsData, UnitsModule, MohatoHealthEvent, EntityIDHandler, OwnedUnitsHandler

-- ⭐⭐⭐ FORWARD DECLARATIONS (รวมเป็น 1 บรรทัดเพื่อลด register) ⭐⭐⭐
local GetEnemies, GetActiveUnits, GetFrontmostEnemy, IsBossEnemy, IsIncomeUnit
local IsBuffUnit, GetMapPath, GetTotalPathDistance, GetCurrentWaveForSkill

local function LoadModules()
    local success, err
    
    success, err = pcall(function() UnitsHUD = require(StarterPlayer.Modules.Interface.Loader.HUD.Units) end)
    -- if not success then print("[AutoPlace] ❌ UnitsHUD load failed:", err) end
    
    -- ⭐ UnitsModule = UnitsHUD (เพื่อใช้ _Cache)
    if success and UnitsHUD then
        UnitsModule = UnitsHUD
    end
    
    pcall(function() ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler) end)
    pcall(function() UnitPlacementHandler = require(StarterPlayer.Modules.Gameplay.Units.UnitPlacementHandler) end)
    pcall(function() PlacementValidationHandler = require(ReplicatedStorage.Modules.Gameplay.PlacementValidationHandler) end)
    pcall(function() EnemyPathHandler = require(ReplicatedStorage.Modules.Shared.EnemyPathHandler) end)
    pcall(function() PathMathHandler = require(ReplicatedStorage.Modules.Shared.PathMathHandler) end)
    pcall(function() ClientGameStateHandler = require(ReplicatedStorage.Modules.Gameplay.ClientGameStateHandler) end)
    pcall(function() PlayerYenHandler = require(StarterPlayer.Modules.Gameplay.PlayerYenHandler) end)
    
    -- ⭐ โหลด GlobalMatchSettings (สำหรับ GetUnitTrait, GetUnitPlacementCap)
    pcall(function()
        GlobalMatchSettings = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Data"):FindFirstChild("GlobalMatchSettings"))
    end)
    
    -- ⭐ โหลด UnitsData (ต้องใช้ Modules.Data.Entities.Units ตาม Decom.lua line 6450)
    pcall(function()
        UnitsData = require(ReplicatedStorage.Modules.Data.Entities.Units)
    end)
    
    -- ⭐ โหลด UnitGroupData (สำหรับ GetUnitGroupBuffs - MaxPlacements)
    pcall(function()
        UnitGroupData = require(ReplicatedStorage.Modules.Data.UnitGroupData)
    end)
    
    -- ⭐⭐⭐ NEW: โหลด EntityIDHandler (ตาม Decom.lua - สำหรับ GetIDFromName)
    pcall(function()
        EntityIDHandler = require(ReplicatedStorage.Modules.Data.Entities.EntityIDHandler)
    end)
    
    -- ⭐⭐⭐ NEW: โหลด OwnedUnitsHandler (ตาม Decom.lua line 4735 - สำหรับกระเป๋า/bag)
    pcall(function()
        OwnedUnitsHandler = require(StarterPlayer.Modules.Gameplay.Units.OwnedUnitsHandler)
    end)
    
    -- ⭐⭐⭐ NEW: โหลด MohatoHealthEvent (ตาม Decom.lua line 9803)
    pcall(function()
        MohatoHealthEvent = Networking:FindFirstChild("ClientListeners")
            and Networking.ClientListeners:FindFirstChild("HealthBar")
            and Networking.ClientListeners.HealthBar:FindFirstChild("MohatoHealthEvent")
    end)
    
    -- 🔍 FORCED LOG: แสดงว่าโหลด modules สำเร็จหรือไม่
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("[FORCED] 📦 Core Modules Status:")
    print(string.format("[FORCED]   UnitsHUD: %s", UnitsHUD and "✅" or "❌"))
    print(string.format("[FORCED]   ClientUnitHandler: %s", ClientUnitHandler and "✅" or "❌"))
    print(string.format("[FORCED]   UnitsData: %s", UnitsData and "✅" or "❌"))
    print(string.format("[FORCED]   EntityIDHandler: %s", EntityIDHandler and "✅" or "❌"))
    print(string.format("[FORCED]   OwnedUnitsHandler: %s", OwnedUnitsHandler and "✅" or "❌"))
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

LoadModules()

-- ===== NETWORKING =====
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitEvent = Networking:WaitForChild("UnitEvent")

-- ===== MATCH CONTROL (ตรวจจับเกมจบ/รีเซ็ต) =====
local MatchControl = nil
pcall(function()
    MatchControl = require(ReplicatedStorage:FindFirstChild("Networking"):FindFirstChild("MatchControl"))
end)

-- ===== GAME HANDLER (สำหรับ GetUnitPlacementCap) =====
local GameHandler = nil
pcall(function()
    GameHandler = require(ReplicatedStorage.Modules.Gameplay.GameHandler)
end)

local function GetGameHandler()
    return GameHandler
end

-- ===== EMERGENCY MODE STATE =====
local EmergencyMode = {
    Active = false,
    LastCheck = 0,
    CHECK_INTERVAL = 1.0,  -- เช็คทุก 1 วินาที
    StunUnitsPlaced = 0,
    LastPlacementAttempt = 0,
    PLACEMENT_COOLDOWN = 0.5  -- รอ 0.5 วินาทีระหว่างการวาง
}

-- หา Stun units
local function GetStunUnits()
    if not UnitInventory then return {} end
    
    local stunUnits = {}
    local stunUnitNames = {
        "Igros",
        "Vessel",
        "Boros",
        "Friezo",
        "Doby",
        -- เพิ่ม units ที่มี stun/freeze/slow
    }
    
    for _, unitData in pairs(UnitInventory) do
        if unitData and unitData.Name then
            for _, stunName in ipairs(stunUnitNames) do
                if unitData.Name:find(stunName) then
                    table.insert(stunUnits, unitData)
                    break
                end
            end
        end
    end
    
    -- เรียงตาม Level (สูง -> ต่ำ)
    table.sort(stunUnits, function(a, b)
        return (a.Level or 0) > (b.Level or 0)
    end)
    
    return stunUnits
end

-- เช็คว่าควร activate Emergency Mode หรือไม่
local function ShouldActivateEmergencyMode()
    local now = tick()
    if now - EmergencyMode.LastCheck < EmergencyMode.CHECK_INTERVAL then
        return EmergencyMode.Active
    end
    
    EmergencyMode.LastCheck = now
    
    -- เช็ค enemy ใกล้เป้าหมาย
    if not GetEnemies then return false end  -- ⭐ FIX: เช็คว่าฟังก์ชันถูก define แล้ว
    local enemies = GetEnemies()
    if not enemies then 
        -- ⭐ ถ้าไม่มี enemy → หยุด Emergency Mode
        EmergencyMode.Active = false
        return false
    end
    
    local criticalEnemies = 0
    local totalEnemies = 0
    local CRITICAL_DISTANCE = 15  -- ระยะวิกฤต
    
    for _, enemy in pairs(enemies) do
        if enemy then
            totalEnemies = totalEnemies + 1
            if enemy.DistanceFromEnd and enemy.DistanceFromEnd <= CRITICAL_DISTANCE then
                criticalEnemies = criticalEnemies + 1
            end
        end
    end
    
    -- ⭐⭐⭐ FIX: ถ้าไม่มี enemy เลย หรือไม่มี enemy ใกล้เป้าหมาย → หยุด Emergency Mode
    if totalEnemies == 0 or criticalEnemies == 0 then
        if EmergencyMode.Active then
            DebugPrint("✅ Emergency Mode STOPPED - No enemies near goal")
        end
        EmergencyMode.Active = false
        return false
    end
    
    -- ถ้ามี enemy 3+ ตัวใกล้เป้าหมาย = Emergency!
    local shouldActivate = (criticalEnemies >= 3)
    
    -- ⭐ Log เมื่อสถานะเปลี่ยน
    if shouldActivate and not EmergencyMode.Active then
        DebugPrint(string.format("🚨 EMERGENCY MODE ACTIVATED: %d enemies near goal!", criticalEnemies))
    elseif not shouldActivate and EmergencyMode.Active then
        DebugPrint("✅ Emergency Mode DEACTIVATED - situation improved")
    end
    
    EmergencyMode.Active = shouldActivate
    return EmergencyMode.Active
end

-- วาง Stun units (Emergency Mode)
local function PlaceStunUnitsEmergency()
    if not EmergencyMode.Active then return 0 end
    
    local now = tick()
    if now - EmergencyMode.LastPlacementAttempt < EmergencyMode.PLACEMENT_COOLDOWN then
        return 0  -- รอ cooldown
    end
    
    EmergencyMode.LastPlacementAttempt = now
    
    local stunUnits = GetStunUnits()
    if #stunUnits == 0 then
        DebugPrint("🚨 Emergency: No stun units available")
        return 0
    end
    
    local targetCount = math.random(7, 12)  -- วาง 7-12 ตัว
    local placedCount = 0
    
    -- หา enemy ที่ใกล้เป้าหมายที่สุด
    if not GetEnemies then return 0 end  -- ⭐ FIX: เช็คว่าฟังก์ชันถูก define แล้ว
    local enemies = GetEnemies()
    local nearestEnemy = nil
    local minDistance = math.huge
    
    for _, enemy in pairs(enemies) do
        if enemy and enemy.DistanceFromEnd and enemy.Position then
            if enemy.DistanceFromEnd < minDistance then
                minDistance = enemy.DistanceFromEnd
                nearestEnemy = enemy
            end
        end
    end
    
    if not nearestEnemy then
        DebugPrint("🚨 Emergency: No enemy found")
        return 0
    end
    
    DebugPrint(string.format("🚨 Emergency: Placing %d stun units (7-12 studs away from enemy)", targetCount))
    
    -- วาง stun units ห่างจาก enemy 7-12 studs
    for i, unitData in ipairs(stunUnits) do
        if placedCount >= targetCount then
            break
        end
        
        -- คำนวณตำแหน่งที่ห่างจาก enemy 7-12 studs
        local enemyPos = nearestEnemy.Position
        local distance = math.random(7, 12)  -- ระยะสุ่ม 7-12 studs
        local angle = math.random() * math.pi * 2  -- มุมสุ่ม
        
        -- คำนวณตำแหน่งใหม่
        local offsetX = math.cos(angle) * distance
        local offsetZ = math.sin(angle) * distance
        local targetPos = Vector3.new(
            enemyPos.X + offsetX,
            enemyPos.Y,
            enemyPos.Z + offsetZ
        )
        
        -- พยายามวาง
        local placeSuccess = PlaceUnit(unitData.Name, targetPos)
        if placeSuccess then
            placedCount = placedCount + 1
            DebugPrint(string.format("   🛡️ Stun: %s (%.1f studs from enemy, Lvl: %d)", 
                unitData.Name, 
                distance,
                unitData.Level or 0
            ))
            task.wait(0.05)
        else
            -- ถ้าวางไม่ได้ ลองตำแหน่งอื่น
            task.wait(0.1)
        end
    end
    
    EmergencyMode.StunUnitsPlaced = EmergencyMode.StunUnitsPlaced + placedCount
    DebugPrint(string.format("🚨 Emergency: Placed %d/%d stun units (Total: %d)", 
        placedCount, 
        targetCount,
        EmergencyMode.StunUnitsPlaced
    ))
    
    return placedCount
end

-- ===== SKIP WAVE / AUTO START EVENTS =====
local SkipWaveEvent = Networking:FindFirstChild("SkipWaveEvent")
local StartMatchEvent = nil
local ReadyEvent = nil

pcall(function()
    StartMatchEvent = Networking:FindFirstChild("StartMatchEvent") 
        or Networking:FindFirstChild("StartMatch")
        or Networking:FindFirstChild("StartGame")
        or Networking:FindFirstChild("BeginMatch")
    
    ReadyEvent = Networking:FindFirstChild("ReadyEvent")
        or Networking:FindFirstChild("PlayerReady")
        or Networking:FindFirstChild("Ready")
end)

-- ===== STATE (ใช้ _G เพื่อลด local register) =====
_G.APState = {
    PlacedPositions = {},
    UsedUCenters = {},
    CachedUCenters = {},
    LastPlaceTime = 0,
    LastUpgradeTime = 0,
    CurrentYen = 0,
    IsEmergency = false,
    EmergencyUnits = {},
    EmergencyStartTime = 0,
    EmergencyActivated = false,
    LastEmergencyTime = 0,
    ClearEnemyUnits = {},
    ProcessedStaticEnemies = {},
    LastVoteSkipTime = 0,
    LastVoteSkipLog = 0,
    MaxWaveSellTriggered = false,
    LastGameState = "Unknown",
    PreviousWave = 0,
    LastLoggedYen = -1,
    LastLoggedWave = -1,
    LastLoggedPhase = "",
    LastLoggedEmergency = false,
    LastLoggedClearEnemyBlock = false,
    LastStartLog = 0,
    LastEmergencyUpgradeTime = 0,
    EMERGENCY_UPGRADE_COOLDOWN = 2,
}

-- Shortcuts (ใช้ local reference เพื่อความเร็ว)
local PlacedPositions = _G.APState.PlacedPositions
local UsedUCenters = _G.APState.UsedUCenters
local CachedUCenters = _G.APState.CachedUCenters
local LastPlaceTime = 0
local LastUpgradeTime = 0
local CurrentYen = 0
local IsEmergency = false
local EmergencyUnits = _G.APState.EmergencyUnits
local EmergencyStartTime = 0
local EmergencyActivated = false
local LastEmergencyTime = 0
local CaloricCloneUnits = {}  -- ⭐ Track Caloric Stone cloned units (ห้ามอัพเกรด)
local ClearEnemyUnits = _G.APState.ClearEnemyUnits
local ProcessedStaticEnemies = _G.APState.ProcessedStaticEnemies
local MaxWaveSellTriggered = false
local PreviousWave = 0

-- ===== FORWARD DECLARATIONS =====
local GetHotbarUnits, GetYen, GetUpgradeCost, UpgradeUnit, PlaceUnit, SellUnit
local GetActiveUnits, IsIncomeUnit, IsBuffUnit, GetCheapestDamageSlot
local GetSlotLimit, CanPlaceAtPosition, GetCheapestDamageSlotNoLimit
local SetPriority, GetBestPlacementPosition, GetCurrentUpgradeLevel, GetMaxUpgradeLevel

-- Emergency Upgrade State
local LastEmergencyUpgradeTime = 0
local EMERGENCY_UPGRADE_COOLDOWN = 2

local function UpgradeUnitsEmergency()
    -- ใช้ทั้ง 2 ระบบ Emergency: EmergencyMode.Active หรือ IsEmergency
    if not EmergencyMode.Active and not IsEmergency then return false end
    
    local now = tick()
    if now - LastEmergencyUpgradeTime < EMERGENCY_UPGRADE_COOLDOWN then
        return false
    end
    
    -- หา damage units ที่วางอยู่
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then
        return false
    end
    
    local damageUnits = {}
    for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
        if unit and unit.Name then
            local isIncome = IsIncomeUnit and IsIncomeUnit(unit.Name, unit.Data or {})
            local isBuff = IsBuffUnit and IsBuffUnit(unit.Name, unit.Data or {})
            
            if not isIncome and not isBuff then
                local currentLevel = GetCurrentUpgradeLevel and GetCurrentUpgradeLevel(unit) or 0
                local maxLevel = GetMaxUpgradeLevel and GetMaxUpgradeLevel(unit) or 10
                local cost = GetUpgradeCost and GetUpgradeCost(unit) or math.huge
                
                if currentLevel < maxLevel and cost < math.huge then
                    table.insert(damageUnits, {
                        Unit = unit,
                        GUID = guid,
                        Name = unit.Name,
                        Level = currentLevel,
                        MaxLevel = maxLevel,
                        Cost = cost
                    })
                end
            end
        end
    end
    
    if #damageUnits == 0 then
        return false
    end
    
    -- เรียงตาม level ต่ำสุดก่อน (อัพตัวที่ยังไม่แรง)
    table.sort(damageUnits, function(a, b)
        return a.Level < b.Level
    end)
    
    -- อัพเกรด 1 ตัวที่ afford ได้
    local yen = GetYen and GetYen() or 0
    for _, unitData in ipairs(damageUnits) do
        if yen >= unitData.Cost then
            local success = UpgradeUnit and UpgradeUnit(unitData.Unit)
            if success then
                LastEmergencyUpgradeTime = now
                print(string.format("[Emergency] ⬆️ %s (%d→%d)", 
                    unitData.Name, unitData.Level, unitData.Level + 1))
                return true
            end
        end
    end
    
    return false
end

-- ===== UTILITY =====
local function DebugPrint(...)
    if DEBUG then
        -- 🔥 แสดงเฉพาะ Emergency Mode logs เท่านั้น
        local msg = table.concat({...}, " ")
        local isEmergencyLog = msg:find("Emergency") or msg:find("EMERGENCY") or msg:find("🚨")
        local isClearEnemyLog = msg:find("ClearEnemy") or msg:find("Static") or msg:find("💸")
        
        -- แสดงเฉพาะ Emergency และ ClearEnemy logs
        if isEmergencyLog or isClearEnemyLog then
            print("[AutoPlace]", ...)
        end
    end
end

-- ===== YEN SYSTEM =====
GetYen = function()
    -- วิธี 1: PlayerYenHandler
    if PlayerYenHandler then
        local yen = nil
        pcall(function()
            if PlayerYenHandler.GetYen then
                yen = PlayerYenHandler:GetYen()
            elseif PlayerYenHandler.Yen then
                yen = PlayerYenHandler.Yen
            end
        end)
        if yen and yen > 0 then
            CurrentYen = yen
            return yen
        end
    end
    
    -- วิธี 2: ClientGameStateHandler
    if ClientGameStateHandler then
        local state = nil
        pcall(function()
            state = ClientGameStateHandler:GetPlayerState(plr)
        end)
        if state and state.Yen then
            CurrentYen = state.Yen
            return state.Yen
        end
    end
    
    -- วิธี 3: HUD
    local HUD = PlayerGui:FindFirstChild("HUD")
    if HUD then
        for _, child in pairs(HUD:GetDescendants()) do
            if child:IsA("TextLabel") then
                local text = child.Text
                if text and type(text) == "string" then
                    if text:find("¥") then
                        local numStr = text:gsub(",", ""):gsub("¥", ""):match("([%d]+)")
                        if numStr then
                            local num = tonumber(numStr)
                            if num and num >= 0 then
                                CurrentYen = num
                                return num
                            end
                        end
                    end
                end
            end
        end
    end
    
    return CurrentYen
end

-- ===== WAVE SYSTEM =====
local CurrentWave = 0
local MaxWave = 0

local function GetWaveFromUI()
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            local Map = HUD:FindFirstChild("Map")
            if Map then
                local WavesAmount = Map:FindFirstChild("WavesAmount")
                if WavesAmount and WavesAmount:IsA("TextLabel") then
                    local text = WavesAmount.Text or ""
                    local cleanText = text:gsub("<[^>]+>", "")
                    local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                    if cur and total then
                        CurrentWave = tonumber(cur) or 0
                        MaxWave = tonumber(total) or 0
                    end
                end
            end
        end
    end)
    return CurrentWave, MaxWave
end

local function GetGamePhase()
    GetWaveFromUI()
    if MaxWave <= 0 then return "early" end
    
    local progress = CurrentWave / MaxWave
    if progress > 0.7 then return "late"
    elseif progress > 0.4 then return "mid"
    else return "early" end
end

-- ===== PATH SYSTEM =====
local PathCache = nil
local PathCacheTime = 0

GetMapPath = function()
    if PathCache and (tick() - PathCacheTime) < 5 then
        return PathCache
    end
    
    local path = {}
    
    -- วิธี 1: EnemyPathHandler
    if EnemyPathHandler and EnemyPathHandler.Nodes then
        for _, node in pairs(EnemyPathHandler.Nodes) do
            if node.Position then
                table.insert(path, node.Position)
            end
        end
    end
    
    -- วิธี 2: workspace
    if #path == 0 then
        local pathFolders = {
            workspace:FindFirstChild("Path"),
            workspace:FindFirstChild("Paths"),
            workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Path"),
            workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Paths"),
        }
        
        for _, folder in pairs(pathFolders) do
            if folder then
                for _, node in pairs(folder:GetChildren()) do
                    if node:IsA("BasePart") then
                        table.insert(path, node.Position)
                    end
                end
                if #path > 0 then break end
            end
        end
    end
    
    PathCache = path
    PathCacheTime = tick()
    return path
end

-- หา Max DistanceToStart จาก EnemyPathHandler.Nodes (ระยะทางรวมของ path)
local TotalPathDistanceCache = nil
local TotalPathDistanceCacheTime = 0
GetTotalPathDistance = function()
    if TotalPathDistanceCache and (tick() - TotalPathDistanceCacheTime) < 10 then
        return TotalPathDistanceCache
    end
    
    local maxDist = 0
    if EnemyPathHandler and EnemyPathHandler.Nodes then
        for _, node in pairs(EnemyPathHandler.Nodes) do
            if node.DistanceToStart and node.DistanceToStart > maxDist then
                maxDist = node.DistanceToStart
            end
        end
    end
    
    TotalPathDistanceCache = maxDist
    TotalPathDistanceCacheTime = tick()
    return maxDist
end

-- ===== UNIT CLASSIFICATION (จาก Decom.lua) =====
-- จาก Decom: UnitType == "Farm" = ตัวเงิน
-- จาก Decom: UnitType == "Support" = Buff

IsIncomeUnit = function(unitName, unitData)
    -- ⭐ จาก Decom: UnitType == "Farm"
    if unitData then
        if unitData.UnitType == "Farm" then return true end
        if unitData.IsIncome then return true end
        if unitData.Income then return true end
    end
    
    -- Fallback: เช็คจากชื่อ
    local nameLower = (unitName or ""):lower()
    local incomePatterns = {"income", "farm", "money", "bank", "gold", "yen", "cash", "sprintwagon", "sprint", "wagon"}
    for _, pattern in ipairs(incomePatterns) do
        if nameLower:find(pattern) then return true end
    end
    
    return false
end

IsBuffUnit = function(unitName, unitData)
    -- ⭐ จาก Decom: UnitType == "Support"
    if unitData then
        if unitData.UnitType == "Support" then return true end
    end
    
    -- Fallback: เช็คจาก Abilities
    if unitData and unitData.Abilities then
        for name, _ in pairs(unitData.Abilities) do
            if type(name) == "string" then
                local nameLower = name:lower()
                if nameLower:find("buff") or nameLower:find("aura") or nameLower:find("support") then
                    return true
                end
            end
        end
    end
    
    -- Fallback: เช็คจากชื่อ
    local nameLower = (unitName or ""):lower()
    if nameLower:find("buff") or nameLower:find("support") or nameLower:find("aura") then
        return true
    end
    
    return false
end

-- ===== หา Unit ที่มี Passive ต้องตี Enemy ก่อนถึง Summon (เช่น Wonderous You) =====
local function IsPassiveSummonUnit(unitName, unitData)
    if not unitData then return false end
    
    -- ✅ เช็คจาก Passive.Name
    if unitData.Passive and unitData.Passive.Name then
        local passiveName = unitData.Passive.Name
        
        -- ⭐ รายชื่อ Passive ที่ต้องใกล้/ตี Enemy ก่อนถึง Summon
        local requiresEnemyPassives = {
            "Wonderous You",     -- เดินเข้าหา Enemy → Calamity damage (ต้องใกล้ Enemy)
            "SummonOnAttack",    -- Summon เมื่อตี (ตัวอย่าง)
            "SummonOnKill",      -- Summon เมื่อฆ่า (ตัวอย่าง)
            "SummonAfterDamage", -- Summon หลังจากดาเมจ (ตัวอย่าง)
            -- ⭐ เพิ่มชื่อ Passive อื่นๆ ที่พบว่าต้องมี Enemy ก่อนถึงทำงาน
        }
        
        for _, passive in ipairs(requiresEnemyPassives) do
            if passiveName == passive then
                -- Log เฉพาะครั้งแรกที่พบ
                if not _G["PassiveUnit_" .. unitName] then
                    _G["PassiveUnit_" .. unitName] = true
                end
                return true
            end
        end
    end
    
    -- ✅ เช็คจาก Description (ถ้ามีคำว่า "summon" หรือ "calamity")
    if unitData.Description then
        local desc = unitData.Description:lower()
        if desc:find("summon") or desc:find("calamity") then
            if not _G["PassiveDescUnit_" .. unitName] then
                _G["PassiveDescUnit_" .. unitName] = true
            end
            -- return true  -- ⚠️ เปิด comment ถ้าต้องการบล็อก unit ที่มี description แบบนี้
        end
    end
    
    return false
end

-- ⭐ เช็คว่ายูนิตมี Trait จำกัดจำนวนหรือไม่ (แบบ Auto หาจาก GlobalMatchSettings.GetUnitTrait)
local GlobalMatchSettings = nil
local function GetGlobalMatchSettings()
    if GlobalMatchSettings then return GlobalMatchSettings end
    
    local success, result = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Modules = ReplicatedStorage:FindFirstChild("Modules")
        if Modules then
            local Data = Modules:FindFirstChild("Data")
            if Data then
                local GMS = Data:FindFirstChild("GlobalMatchSettings")
                if GMS then
                    return require(GMS)
                end
            end
        end
    end)
    
    if success and result then
        GlobalMatchSettings = result
        -- Test trait silently - logs removed for cleaner output
    end
    
    return GlobalMatchSettings
end

-- ⭐⭐⭐ ฟังก์ชันเช็ค Unit Placement Limit (ตาม Decom.lua line 6692-6703)
local function GetUnitPlacementLimit(unitName, unitData)
    if not unitName then 
        return math.huge 
    end
    
    local trait = nil
    local GMS = GetGlobalMatchSettings()
    
    -- 🔍 Step 1: หา Trait จาก GlobalMatchSettings.GetUnitTrait() (ตาม Decom.lua line 6697)
    if GMS and GMS.GetUnitTrait then
        local success, result = pcall(function()
            return GMS.GetUnitTrait(unitName)  -- function call ธรรมดา ไม่ใช่ method
        end)
        
        if success and result and result ~= "None" then
            if type(result) ~= "table" then
                trait = { Name = result, Index = nil }
            else
                trait = result
            end
        end
    end
    
    -- 🔍 Step 2: Fallback to unitData (UnitObject จาก _Cache) ที่มี .Trait โดยตรง
    -- ตาม Decom.lua line 6702: v99 = v97 or v95.Trait (v95 = UnitObject)
    if (not trait or not trait.Name) and unitData then
        local unitTrait = nil
        
        -- ⭐ กรณี unitData.Trait มีค่า (UnitObject โดยตรง)
        if unitData.Trait ~= nil and unitData.Trait ~= "None" then
            unitTrait = unitData.Trait
        end
        
        if unitTrait then
            -- Trait อาจเป็น table { Name = "Monarch", Index = nil } หรือ string "Monarch"
            if type(unitTrait) == "table" then
                trait = unitTrait
            elseif type(unitTrait) == "string" then
                trait = { Name = unitTrait, Index = nil }
            end
        end
    end
    
    -- 🔍 Step 3: ยังไม่มี trait → ลอง UnitsData:GetUnitByName()
    if (not trait or not trait.Name) and UnitsData and UnitsData.GetUnitByName then
        local success, unitInfo = pcall(function()
            return UnitsData:GetUnitByName(unitName)
        end)
        
        if success and unitInfo and unitInfo.Trait and unitInfo.Trait ~= "None" then
            local unitTrait = unitInfo.Trait
            if type(unitTrait) == "table" then
                trait = unitTrait
            elseif type(unitTrait) == "string" then
                trait = { Name = unitTrait, Index = nil }
            end
        end
    end
    
    -- 👑 CRITICAL: ถ้า Trait เป็น "Monarch" → return 1 ทันที (ตาม Decom.lua line 6703)
    if trait and trait.Name == "Monarch" then
        return 1
    end
    
    -- 📊 Step 4: เช็ค UnitGroupBuffs MaxPlacements (ตาม Decom.lua line 6703)
    if UnitGroupData and UnitGroupData.GetUnitGroupBuffs then
        local success, maxPlacements = pcall(function()
            return UnitGroupData.GetUnitGroupBuffs(unitName, "MaxPlacements")
        end)
        
        if success and maxPlacements and type(maxPlacements) == "number" then
            return maxPlacements
        end
    end
    
    -- ⭐ ถ้า Trait เป็น "Unique" → ดู Max หรือ default 1
    if trait and trait.Name == "Unique" then
        local limit = trait.Max or 1
        return limit
    end
    
    -- 🏷️ Default: ไม่จำกัด
    return math.huge
end

-- ⭐ นับจำนวนยูนิตชนิดนี้ที่วางไปแล้ว
local function CountPlacedUnits(unitName)
    local count = 0
    if not GetActiveUnits then return 0 end  -- ⭐ FIX: เช็คว่าฟังก์ชันถูก define แล้ว
    local activeUnits = GetActiveUnits()
    
    for _, unit in pairs(activeUnits) do
        if unit.Name == unitName then
            count = count + 1
        end
    end
    
    return count
end

-- ⭐ เช็คว่ายังวางยูนิตนี้ได้อีกไหม
local function CanPlaceMoreUnits(unitName, unitData)
    local limit = GetUnitPlacementLimit(unitName, unitData)
    local placed = CountPlacedUnits(unitName)
    
    if placed >= limit then
        return false
    end
    
    return true
end

-- ===== ENEMY SYSTEM =====
local ClientEnemyHandler = nil
pcall(function()
    -- Path ที่ถูกต้องจาก Decom.lua: StarterPlayer.Modules.Gameplay.ClientEnemyHandler
    ClientEnemyHandler = require(StarterPlayer.Modules.Gameplay.ClientEnemyHandler)
end)

GetEnemies = function()
    local enemies = {}
    
    -- วิธี 1: ClientEnemyHandler._ActiveEnemies (ตาม AutoPlay_Smart.lua)
    if ClientEnemyHandler then
        local activeEnemies = nil
        
        pcall(function()
            -- ลองหลายวิธี
            if ClientEnemyHandler._ActiveEnemies then
                activeEnemies = ClientEnemyHandler._ActiveEnemies
            elseif ClientEnemyHandler.GetActiveEnemies then
                activeEnemies = ClientEnemyHandler:GetActiveEnemies()
            end
        end)
        
        if activeEnemies then
            for id, enemy in pairs(activeEnemies) do
                -- ⭐⭐⭐ CRITICAL: กรอง Enemy ที่ spawn จาก Units (Summon/Passive) ออกทั้งหมด
                -- เพื่อให้ Emergency Mode ไม่นับ Summon และทำงานได้ถูกต้อง
                -- ใช้การเช็คจาก ClientEnemyHandler (Decom.lua) เท่านั้น - ไม่ใช้ชื่อ!
                local isRealEnemy = true
                local filterReason = nil
                
                -- 🔥🔥🔥 METHOD 1: เช็ค enemy.Type == "UnitSummon" (จาก Decom line 2723)
                if enemy.Type == "UnitSummon" then
                    isRealEnemy = false
                    filterReason = "Type=UnitSummon"
                end
                
                -- 🔥🔥🔥 METHOD 2: เช็ค enemy.SpawnedBy (มี UniqueIdentifier ของ Unit)
                -- จาก Decom line 2856: ["SpawnedBy"] = p219.SpawnedBy
                if enemy.SpawnedBy and type(enemy.SpawnedBy) == "table" and enemy.SpawnedBy.UniqueIdentifier then
                    isRealEnemy = false
                    filterReason = "SpawnedBy Unit (ID: " .. tostring(enemy.SpawnedBy.UniqueIdentifier) .. ")"
                end
                
                -- 🔥🔥🔥 METHOD 3: เช็ค enemy.SummonType
                -- จาก Decom line 2855: ["SummonType"] = p219.SummonType
                if enemy.SummonType then
                    isRealEnemy = false
                    filterReason = "Has SummonType: " .. tostring(enemy.SummonType)
                end
                
                -- 🔥 METHOD 4: เช็ค enemy.Data ด้วย (backup)
                if enemy.Data then
                    -- เช็ค Data.SummonedBy
                    if enemy.Data.SummonedBy and type(enemy.Data.SummonedBy) == "table" and enemy.Data.SummonedBy.UniqueIdentifier then
                        isRealEnemy = false
                        filterReason = "Data.SummonedBy Unit"
                    end
                    
                    -- เช็ค Type ใน Data (ไม่ใช่ชื่อ)
                    if enemy.Data.Type == "UnitSummon" then
                        isRealEnemy = false
                        filterReason = "Data.Type=UnitSummon"
                    end
                    
                    -- เช็ค flags อื่นๆ
                    if enemy.Data.IsSummon == true then
                        isRealEnemy = false
                        filterReason = "Data.IsSummon=true"
                    end
                    
                    if enemy.Data.Owner or enemy.Data.Summoner then
                        isRealEnemy = false
                        filterReason = "Data.Owner/Summoner"
                    end
                    
                    if enemy.Data.SpawnedByUnit or enemy.Data.IsSpawnedByUnit then
                        isRealEnemy = false
                        filterReason = "Data.SpawnedByUnit"
                    end
                    
                    if enemy.Data.IsTemporary or enemy.Data.Temporary then
                        isRealEnemy = false
                        filterReason = "Data.Temporary"
                    end
                    
                    if enemy.Data.IsPlayerSummon or enemy.Data.PlayerSummon then
                        isRealEnemy = false
                        filterReason = "Data.PlayerSummon"
                    end
                    
                    if enemy.Data.IsFriendly or enemy.Data.Friendly then
                        isRealEnemy = false
                        filterReason = "Data.Friendly"
                    end
                end
                
                -- METHOD 5: เช็ค properties ข้างนอก Data
                if enemy.Owner or enemy.Summoner or enemy.IsSummon then
                    isRealEnemy = false
                    filterReason = "Has Owner/Summoner/IsSummon property"
                end
                
                if enemy.Player then
                    isRealEnemy = false
                    filterReason = "Has Player property"
                end
                
                -- เช็ค enemy.Position โดยตรง (ไม่ใช่ enemy.Model.PrimaryPart.Position)
                if enemy and enemy.Position and isRealEnemy then
                    table.insert(enemies, {
                        Model = enemy.Model,
                        Position = enemy.Position,  -- ใช้ enemy.Position โดยตรง
                        Name = enemy.Name or "Enemy",
                        UniqueIdentifier = enemy.UniqueIdentifier or id,
                        EntityId = tostring(enemy.UniqueIdentifier or id),
                        Health = enemy.Health or 0,
                        MaxHealth = enemy.MaxHealth or 0,
                        CurrentNode = enemy.CurrentNode,
                        Alpha = enemy.Alpha,
                        Data = enemy.Data
                    })
                elseif enemy and enemy.Position and not isRealEnemy then
                    -- ⭐⭐⭐ DEBUG: บันทึก enemy ที่ถูกกรองออก (Summon)
                    if not _G.FilteredSummonsThisCycle then _G.FilteredSummonsThisCycle = {} end
                    
                    -- เก็บข้อมูล summon ที่กรองในรอบนี้
                    table.insert(_G.FilteredSummonsThisCycle, {
                        name = enemy.Name or "Unknown",
                        reason = filterReason or "Unknown",
                        type = enemy.Type,
                        summonType = enemy.SummonType
                    })
                end
            end
            
            -- 🔥🔥🔥 Log Summary ทุก 10 วินาที (ไม่ spam)
            if not _G.LastSummonSummaryLog then _G.LastSummonSummaryLog = 0 end
            local now = tick()
            if now - _G.LastSummonSummaryLog >= 10 then
                if _G.FilteredSummonsThisCycle and #_G.FilteredSummonsThisCycle > 0 then
                    -- สรุป summons ที่กรอง
                    local summary = {}
                    for _, filtered in ipairs(_G.FilteredSummonsThisCycle) do
                        local key = filtered.name or "Unknown"
                        if not summary[key] then
                            summary[key] = {
                                count = 0, 
                                reason = filtered.reason,
                                type = filtered.type,
                                summonType = filtered.summonType
                            }
                        end
                        summary[key].count = summary[key].count + 1
                    end
                    
                    DebugPrint("🚫 [FILTER SUMMARY] สรุป Summons ที่กรองออกในรอบ 10 วินาทีนี้:")
                    for name, data in pairs(summary) do
                        local typeInfo = ""
                        if data.type then
                            typeInfo = string.format(" | Type: %s", data.type)
                        end
                        if data.summonType then
                            typeInfo = typeInfo .. string.format(" | SummonType: %s", data.summonType)
                        end
                        
                        DebugPrint(string.format("   🔹 %s: %d ตัว | เหตุผล: %s%s", 
                            name, data.count, data.reason, typeInfo))
                    end
                    DebugPrint(string.format("   📊 Total Summons Filtered: %d", #_G.FilteredSummonsThisCycle))
                end
                
                _G.LastSummonSummaryLog = now
                _G.FilteredSummonsThisCycle = {}  -- Reset
            end
            
            -- ถ้าเจอ enemies แล้ว return เลย
            if #enemies > 0 then
                return enemies
            end
        end
    end
    
    -- วิธี 2: หาจาก workspace.Entities (fallback)
    if #enemies == 0 and workspace:FindFirstChild("Entities") then
        pcall(function()
            for _, entity in pairs(workspace.Entities:GetChildren()) do
                if entity:IsA("Model") then
                    local hrp = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
                    if hrp then
                        table.insert(enemies, {
                            Model = entity,
                            Position = hrp.Position,
                            Name = entity.Name
                        })
                    end
                end
            end
        end)
    end
    
    return enemies
end

local function GetEnemyProgress()
    local success, result = pcall(function()
        -- ⭐⭐⭐ CRITICAL: ใช้ GetEnemies() ที่กรอง Summon ออกแล้ว
        local enemies = GetEnemies()
        
        if #enemies == 0 then return 0 end
        
        -- ใช้ TotalPathDistance จาก EnemyPathHandler.Nodes โดยตรง
        local totalDist = GetTotalPathDistance()
        if totalDist <= 0 then return 0 end
        
        local maxProgress = 0
        
        for _, enemy in pairs(enemies) do
            local distWalked = 0
            
            -- ใช้ CurrentNode.DistanceToStart + Alpha (แม่นยำที่สุด)
            if enemy.CurrentNode and enemy.CurrentNode.DistanceToStart then
                distWalked = (enemy.CurrentNode.DistanceToStart or 0) + (enemy.Alpha or 0)
            end
            
            if distWalked > 0 then
                local progress = (distWalked / totalDist) * 100
                -- ⭐⭐⭐ FIX: จำกัด progress ไม่เกิน 100%
                progress = math.min(progress, 100)
                
                if progress > maxProgress then
                    maxProgress = progress
                end
            end
        end
        
        return maxProgress
    end)
    
    if not success then
        return 0
    end
    
    -- ⭐⭐⭐ FIX: จำกัด result ไม่เกิน 100% (safety check)
    return math.min(result or 0, 100)
end

-- ===== หาศัตรูข้างหน้าสุด (progress สูงสุด) =====
GetFrontmostEnemy = function()
    local enemies = GetEnemies()
    if #enemies == 0 then return nil end
    
    local frontEnemy = nil
    local maxDist = 0
    
    for _, enemy in pairs(enemies) do
        if enemy.CurrentNode and enemy.CurrentNode.DistanceToStart then
            local distWalked = (enemy.CurrentNode.DistanceToStart or 0) + (enemy.Alpha or 0)
            if distWalked > maxDist then
                maxDist = distWalked
                frontEnemy = enemy
            end
        end
    end
    
    -- ⭐⭐⭐ FIX: อัพเดทตำแหน่งล่าสุดจาก Model.HumanoidRootPart
    if frontEnemy and ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
        for _, activeEnemy in pairs(ClientEnemyHandler._ActiveEnemies) do
            if activeEnemy and tostring(activeEnemy.UniqueIdentifier) == tostring(frontEnemy.EntityId) then
                -- ดึงตำแหน่งล่าสุดจาก Model
                if activeEnemy.Model and activeEnemy.Model:FindFirstChild("HumanoidRootPart") then
                    frontEnemy.Position = activeEnemy.Model.HumanoidRootPart.Position
                elseif activeEnemy.Model and activeEnemy.Model:FindFirstChild("Torso") then
                    frontEnemy.Position = activeEnemy.Model.Torso.Position
                elseif activeEnemy.Position then
                    frontEnemy.Position = activeEnemy.Position
                end
                break
            end
        end
    end
    
    return frontEnemy, maxDist
end

-- ===== หาตำแหน่งวางใกล้ EnemyBase (สำหรับ Summon Unit ใน Emergency) =====
-- ⭐ FIX: วางใกล้ EnemyBase แทน Spawn เพื่อให้ Summon ทำงานได้ดีกว่า
local function GetSummonUnitPlacementPosition(unitRange, unitName, unitData)
    local path = GetMapPath()
    
    if #path == 0 then
        return nil
    end
    
    local enemyBase = path[#path]  -- 🔴 จุดสุดท้าย (EnemyBase)
    
    -- ===== สร้าง grid รอบ EnemyBase =====
    local candidates = {}
    local gridSize = 4  -- 4 studs spacing
    local minDist = 8   -- ห่างจาก EnemyBase อย่างน้อย 8 studs
    local maxDist = unitRange or 25  -- ไม่เกิน range ของ unit
    
    for angle = 0, 360, 15 do
        for dist = minDist, maxDist, gridSize do
            local rad = math.rad(angle)
            local offset = Vector3.new(
                math.cos(rad) * dist,
                0,
                math.sin(rad) * dist
            )
            local pos = enemyBase + offset
            
            table.insert(candidates, {
                pos = pos,
                dist = dist,
                angle = angle
            })
        end
    end
    
    -- เรียงจากใกล้ EnemyBase ที่สุด
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    
    -- คืนตำแหน่งใกล้ที่สุด
    if #candidates > 0 then
        local best = candidates[1]
        return best.pos
    end
    
    return nil
end

-- ===== หาตำแหน่งวางดักหน้าศัตรู (INTERCEPT) =====
-- ⭐⭐⭐ FIX: วางดักหน้าศัตรู (ตามทิศทางที่เดิน) ไม่ใช่วางรอบๆ
local function GetEmergencyPlacementPosition(unitRange, unitName, unitData)
    local frontEnemy, frontDist = GetFrontmostEnemy()
    
    if not frontEnemy or not frontEnemy.Position then
        return nil
    end
    
    -- ดึงตำแหน่งล่าสุดจาก Model
    local enemyPos = frontEnemy.Position
    local enemyModel = nil
    
    if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
        for _, activeEnemy in pairs(ClientEnemyHandler._ActiveEnemies) do
            if activeEnemy then
                local match = false
                if activeEnemy.UniqueIdentifier and frontEnemy.EntityId then
                    match = (tostring(activeEnemy.UniqueIdentifier) == tostring(frontEnemy.EntityId))
                elseif activeEnemy.Position and (activeEnemy.Position - enemyPos).Magnitude < 5 then
                    match = true
                end
                
                if match then
                    enemyModel = activeEnemy.Model
                    if activeEnemy.Model and activeEnemy.Model:FindFirstChild("HumanoidRootPart") then
                        enemyPos = activeEnemy.Model.HumanoidRootPart.Position
                    elseif activeEnemy.Position then
                        enemyPos = activeEnemy.Position
                    end
                    break
                end
            end
        end
    end
    
    -- ⭐⭐⭐ คำนวณทิศทางที่ศัตรูกำลังเดิน (จาก LookVector ของ Model)
    local moveDirection = Vector3.new(0, 0, -1)  -- Default: เดินไปข้างหน้า
    
    if enemyModel then
        local rootPart = enemyModel:FindFirstChild("HumanoidRootPart") or enemyModel:FindFirstChild("Torso")
        if rootPart then
            -- ใช้ LookVector เป็นทิศทางเดิน
            moveDirection = rootPart.CFrame.LookVector
            moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit  -- ละ Y
        end
    end
    
    -- ⭐⭐⭐ คำนวณระยะดักหน้า (ตาม unit attack speed)
    local interceptDistance = unitRange * 0.6  -- ระยะปกติ
    
    -- ถ้า unit ตีช้า → วางไกลขึ้น (ให้มีเวลาตี)
    if unitData then
        local attackSpeed = unitData.Cooldown or unitData.SPA or 1
        if attackSpeed > 1.5 then
            -- Unit ตีช้า → วางไกลขึ้น (ระยะปานกลาง)
            interceptDistance = unitRange * 0.8
            DebugPrint(string.format("🎯 [Intercept] %s ตีช้า (%.1fs) → วางไกลขึ้น", unitName or "Unit", attackSpeed))
        end
    end
    
    -- ⭐⭐⭐ ตำแหน่งดักหน้า = ตำแหน่งศัตรู + (ทิศทางเดิน * ระยะดักหน้า)
    local interceptPos = enemyPos + (moveDirection * interceptDistance)
    
    -- ปรับ Y ให้เท่ากับพื้น
    interceptPos = Vector3.new(interceptPos.X, enemyPos.Y, interceptPos.Z)
    
    DebugPrint(string.format("🎯 [Intercept] วางดักหน้าศัตรู: (%.1f, %.1f, %.1f) ระยะ %.1f studs", 
        interceptPos.X, interceptPos.Y, interceptPos.Z, interceptDistance))
    
    return interceptPos
end

_G.APState.LastEmergencyCheckLog = 0
local LastEmergencyCheckLog = _G.APState.LastEmergencyCheckLog

local function CheckEmergency()
    local progress = GetEnemyProgress()
    
    -- Debug: แสดง progress ทุก 10 วินาที (แม้ progress = 0)
    local now = tick()
    if now - LastEmergencyCheckLog >= 10 then
        -- ⭐⭐⭐ CRITICAL: นับ enemies ที่กรอง Summon ออกแล้ว (จาก GetEnemies)
        -- GetEnemies() = Real Enemies เท่านั้น (ไม่รวม Summon)
        local filteredEnemies = GetEnemies()  -- ⭐⭐⭐ ไม่รวม Summon
        local enemyCount = #filteredEnemies
        local emergencyCount = 0
        local clearEnemyCount = 0
        
        -- นับ Total Enemies ใน _ActiveEnemies (รวมทั้ง Real Enemies + Summons)
        local totalActiveEnemies = 0
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _ in pairs(ClientEnemyHandler._ActiveEnemies) do
                totalActiveEnemies = totalActiveEnemies + 1
            end
        end
        
        -- ✅ นับทั้ง Emergency และ ClearEnemy Units
        for _ in pairs(EmergencyUnits) do
            emergencyCount = emergencyCount + 1
        end
        for _ in pairs(ClearEnemyUnits) do
            clearEnemyCount = clearEnemyCount + 1
        end
        
        -- ⭐⭐⭐ คำนวณ Summon Count = Total - Real Enemies
        local summonCount = totalActiveEnemies - enemyCount
        
        -- ⭐⭐⭐ Log พร้อมข้อมูลชัดเจน
        DebugPrint(string.format("📊 [CHECK] Progress: %.1f%% | Real Enemies: %d | Summons: %d (กรองออก) | Emergency: %d | ClearEnemy: %d | Threshold: 60%%", 
            progress, enemyCount, summonCount, emergencyCount, clearEnemyCount))
        
        -- ⭐⭐⭐ ยืนยันว่า Progress คำนวณจาก Real Enemies เท่านั้น
        if summonCount > 0 then
            DebugPrint(string.format("✅ [SUMMON FILTER] ระบบกรอง Summon %d ตัวออกจากการคำนวณ Progress (Total: %d - Real: %d = Summons: %d)", 
                summonCount, totalActiveEnemies, enemyCount, summonCount))
            
            -- ⭐⭐⭐ ดึงรายละเอียด Summons ที่ถูกกรอง (จาก _G.FilteredSummonsThisCycle)
            if _G.FilteredSummonsThisCycle and #_G.FilteredSummonsThisCycle > 0 then
                local summary = {}
                for _, filtered in ipairs(_G.FilteredSummonsThisCycle) do
                    local key = filtered.name or "Unknown"
                    if not summary[key] then
                        summary[key] = {count = 0, reason = filtered.reason}
                    end
                    summary[key].count = summary[key].count + 1
                end
                
                if next(summary) then
                    DebugPrint("   📝 รายละเอียด Summons ที่กรอง:")
                    for name, data in pairs(summary) do
                        DebugPrint(string.format("      - %s: %d ตัว (%s)", name, data.count, data.reason))
                    end
                end
            end
        end
        
        LastEmergencyCheckLog = now
    end
    
    local wasEmergency = IsEmergency
    
    -- ⭐⭐⭐ FIX: ถ้าวาง Emergency units ครบแล้ว (EmergencyActivated = true) → ไม่เข้า Emergency Mode อีก
    -- จนกว่า progress จะลงต่ำกว่า 30% แล้วขาย units ไป
    if not EmergencyActivated then
        IsEmergency = progress >= 60  -- 60% threshold
    end
    
    -- ถ้าเพิ่งเข้า Emergency Mode ครั้งแรก
    if IsEmergency and not wasEmergency then
        EmergencyStartTime = tick()
        EmergencyActivated = false
        DebugPrint(string.format("🚨 EMERGENCY MODE ACTIVATED! Progress: %.1f%%", progress))
    end
    
    -- ✅ FIX: ขาย Emergency Units เฉพาะเมื่อ progress < 30% (ปลอดภัยแล้ว)
    if next(EmergencyUnits) and progress < 30 then
        DebugPrint(string.format("💸💸💸 [EMERGENCY SELL] Progress ต่ำ (%.1f%% < 30%%) → กำลังขาย Emergency Units", progress))
        local soldCount = 0
        local failedCount = 0
        
        -- สร้าง list ของ GUIDs เพื่อไม่ให้ปัญหาขณะ iterate
        local guidsToSell = {}
        for guid, _ in pairs(EmergencyUnits) do
            table.insert(guidsToSell, guid)
        end
        
        for _, guid in ipairs(guidsToSell) do
            -- ค้นหา unit จาก ActiveUnits
            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                local emergencyUnit = ClientUnitHandler._ActiveUnits[guid]
                if emergencyUnit then
                    local unitWrapper = {
                        GUID = guid,
                        Name = emergencyUnit.Name,
                        CanSell = true
                    }
                    
                    DebugPrint(string.format("💸 พยายามขาย Emergency Unit: %s (GUID: %s)", emergencyUnit.Name, tostring(guid)))
                    
                    -- ลองขาย
                    local sellSuccess = SellUnit(unitWrapper)
                    if sellSuccess then
                        soldCount = soldCount + 1
                        EmergencyUnits[guid] = nil  -- ลบทันทีเมื่อขายสำเร็จ
                        DebugPrint(string.format("✅✅✅ ขาย Emergency Unit สำเร็จ: %s", emergencyUnit.Name))
                    else
                        failedCount = failedCount + 1
                        DebugPrint(string.format("❌ ขาย Emergency Unit ล้มเหลว: %s", emergencyUnit.Name))
                    end
                else
                    -- Unit ไม่อยู่ใน ActiveUnits แล้ว (ถูกขายไปแล้ว?)
                    EmergencyUnits[guid] = nil
                    DebugPrint(string.format("⚠️ Emergency Unit ไม่พบใน ActiveUnits (GUID: %s) - ลบออกจาก table", tostring(guid)))
                end
            end
        end
        
        -- สรุปผล + ✅ รีเซ็ต Emergency Mode ให้วางตัวปกติได้
        if soldCount > 0 then
            DebugPrint(string.format("🎯🎯🎯 ขาย Emergency Units สำเร็จ %d ตัว (ล้มเหลว %d ตัว) - Progress: %.1f%%", soldCount, failedCount, progress))
            
            -- ✅ รีเซ็ตเพื่อให้วางตัวปกติได้
            EmergencyActivated = false
            IsEmergency = false
            EmergencyStartTime = 0
        else
            DebugPrint(string.format("❌❌❌ ไม่สามารถขาย Emergency Units ได้เลย! (มี %d ตัว ใน table)", failedCount))
        end
    end
    
    -- ถ้าออกจาก Emergency Mode → Reset flag เพื่อให้วางใหม่ได้
    if not IsEmergency and wasEmergency then
        EmergencyStartTime = 0
        EmergencyActivated = false
        -- ⚠️ ไม่ลบ EmergencyUnits ที่นี่ เพราะยังต้องรอให้ progress < 30% ถึงขาย
    end
    
    return IsEmergency
end

-- ===== RESET SYSTEM (รีเซ็ตหลังจบด่าน/เริ่มใหม่) =====
local function ResetGameState()
    DebugPrint("🔄 ResetGameState() called - Clearing all tracking data")
    
    -- Reset Emergency Mode
    IsEmergency = false
    EmergencyUnits = {}
    EmergencyStartTime = 0
    EmergencyActivated = false
    LastEmergencyTime = 0
    
    -- Reset ClearEnemy Mode
    ClearEnemyUnits = {}
    ClearEnemySoldForEnemy = {}  -- ✅ รีเซ็ตการติดตาม
    ClearEnemyNoMoreSellable = false  -- ✅ รีเซ็ต global flag
    ClearEnemySlotFullLogged = {}  -- ✅ รีเซ็ต log tracking
    ClearEnemyFoundDamageLogged = {}  -- ✅ รีเซ็ต log tracking
    ClearEnemyPlacedCount = {}  -- ✅ รีเซ็ต placed count
    StaticEnemySpawnWave = {}  -- ✅ รีเซ็ต spawn wave tracking
    MohatoHealthData = {}  -- ⭐⭐⭐ รีเซ็ต Mohato Health Data จาก Event
    ProcessedStaticEnemies = {}
    
    -- 🎯 Reset Auto Skill V3
    AutoSkillEnabled = {}       -- รีเซ็ต Auto Skill tracking
    AbilityLastUsed = {}        -- รีเซ็ต Ability cooldown tracking
    AbilityUsedOnce = {}        -- รีเซ็ต One-time ability tracking
    AbilityAnalysisCache = {}   -- รีเซ็ต Ability analysis cache
    _G.APSkill.WorldItemUsedThisMatch = false  -- ⭐⭐⭐ รีเซ็ต World Item usage (1 per match)
    LastAutoSkillCheck = 0      -- ⏱️ รีเซ็ต throttle timer
    KoguroAutoEnabled = {}      -- 🔄 รีเซ็ต Koguro Auto Status
    
    -- 🎯 Reload special ability events (กรณี reconnect)
    task.delay(1, function()
        LoadSpecialAbilityEvents()
    end)
    
    -- Reset Global Position Tracking
    if _G.StaticEnemyLastPosition then _G.StaticEnemyLastPosition = {} end
    
    -- Reset Wave Sell
    MaxWaveSellTriggered = false
    
    -- Reset Placement
    PlacedPositions = {}
    UsedUCenters = {}
    CachedUCenters = {}
    
    -- Reset Log State
    LastLoggedYen = -1
    LastLoggedWave = -1
    LastLoggedPhase = ""
    LastLoggedEmergency = false
    
    -- Reset Previous Wave (สำหรับ replay detection)
    PreviousWave = 0
    
    -- Reset NumberPad (สำหรับ Imprisoned Island)
    if _G.NumberPad then
        _G.NumberPad.BossWaves = {}
        _G.NumberPad.CodeAccepted = false
        _G.NumberPad.LastWaveText = ""
        _G.NumberPad.MapLogged = false
        _G.NumberPad.LastDebug = 0
    end
    
    DebugPrint("✅ ResetGameState() complete - All data cleared (including Auto Skill)")
end

-- ===== CLEAR ENEMY MODE (IsStatic Only - ใช้ _G เพื่อลด register) =====
_G.APClear = {
    ClearEnemyUnits = {},
    ClearEnemySoldForEnemy = {},
    ClearEnemyNoMoreSellable = false,
    ClearEnemySlotFullLogged = {},
    ClearEnemyFoundDamageLogged = {},
    ClearEnemyPlacedCount = {},
    CLEAR_ENEMY_MAX_UNITS = 1,
    LastClearEnemyLog = 0,
    StaticEnemySpawnWave = {},
    StaticEnemySpawnPos = {},
    MohatoHealthData = {},
}
local ClearEnemyUnits = _G.APClear.ClearEnemyUnits
local ClearEnemySoldForEnemy = _G.APClear.ClearEnemySoldForEnemy
local ClearEnemyNoMoreSellable = false
local ClearEnemySlotFullLogged = _G.APClear.ClearEnemySlotFullLogged
local ClearEnemyFoundDamageLogged = _G.APClear.ClearEnemyFoundDamageLogged
local ClearEnemyPlacedCount = _G.APClear.ClearEnemyPlacedCount
local CLEAR_ENEMY_MAX_UNITS = 1
local StaticEnemySpawnWave = _G.APClear.StaticEnemySpawnWave
local StaticEnemySpawnPos = _G.APClear.StaticEnemySpawnPos
local MohatoHealthData = _G.APClear.MohatoHealthData

-- 🔥 NEW: เก็บ state เก่าเพื่อเปรียบเทียบการเปลี่ยนแปลง
local StaticEnemyLastState = {}  -- {EntityId = {WavesElapsed, Position, IsVulnerable}}

-- ⭐⭐⭐ NEW: Setup MohatoHealthEvent Listener (ตาม Decom.lua line 9876-9897)
local function SetupMohatoHealthListener()
    if not MohatoHealthEvent then
        DebugPrint("⚠️ MohatoHealthEvent not found - using manual wave calculation")
        return
    end
    
    -- ฟัง event จาก server (ตาม Decom.lua line 9876)
    MohatoHealthEvent.OnClientEvent:Connect(function(action, data)
        if action == "Add" then
            -- เมื่อ Mohato Clone spawn (ใช้ WavesNeeded จาก server)
            local guid = tostring(data.GUID)
            MohatoHealthData[guid] = {
                WavesElapsed = data.WavesElapsed or 0,
                WavesNeeded = data.WavesNeeded or 3,  -- ค่า default ถ้า server ไม่ส่ง
                GUID = data.GUID
            }
            DebugPrint(string.format("✅ Mohato Clone spawned (GUID: %s) - Waves: %d/%d", 
                guid, data.WavesElapsed or 0, data.WavesNeeded or 3))
                
        elseif action == "Update" then
            -- เมื่อ Mohato Clone อัพเดท waves
            local guid = tostring(data.GUID)
            if MohatoHealthData[guid] then
                MohatoHealthData[guid].WavesElapsed = data.WavesElapsed or 0
                MohatoHealthData[guid].WavesNeeded = data.WavesNeeded or MohatoHealthData[guid].WavesNeeded
                
                -- Log เมื่อครบ waves
                local needed = MohatoHealthData[guid].WavesNeeded
                if data.WavesElapsed >= needed then
                    DebugPrint(string.format("🔥 Mohato Clone VULNERABLE! (GUID: %s) Waves: %d/%d", 
                        guid, data.WavesElapsed, needed))
                end
            end
            
        elseif action == "Remove" then
            -- เมื่อ Mohato Clone ตาย/หาย
            local guid = tostring(data.GUID)
            if MohatoHealthData[guid] then
                MohatoHealthData[guid] = nil
                DebugPrint(string.format("💀 Mohato Clone removed (GUID: %s)", guid))
            end
        end
    end)
    
    DebugPrint("✅ MohatoHealthEvent listener setup complete")
end

-- เรียกใช้ setup listener
task.spawn(SetupMohatoHealthListener)

-- 🔥 ฟังก์ชันใหม่: หาตำแหน่งจริงของ Mohato Clone โดยเช็ค ID สูงสุด (= ตัวล่าสุด)
-- คืนค่า: {position = Vector3, id = number, enemy = table} หรือ nil
local function GetRealMohatoPosition(enemyName)
    DebugPrint(string.format("🔍 [GetRealMohatoPosition] เริ่มค้นหา '%s'...", enemyName))
    
    if not ClientEnemyHandler then
        DebugPrint("❌ [GetRealMohatoPosition] ClientEnemyHandler = nil")
        return nil
    end
    
    if not ClientEnemyHandler._ActiveEnemies then
        DebugPrint("❌ [GetRealMohatoPosition] _ActiveEnemies = nil")
        return nil
    end
    
    DebugPrint(string.format("✅ [GetRealMohatoPosition] ClientEnemyHandler พร้อม, เริ่ม scan..."))
    
    -- 📊 หา Mohato ทั้งหมดใน _ActiveEnemies และเก็บ ID + Position
    local mohatoList = {}  -- {{id = number, position = Vector3, enemy = enemy}}
    
    pcall(function()
        for uniqueId, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
            -- 🔍 เช็คชื่อ enemy ตรงไหม
            local nameMatch = (enemy.Name == enemyName)
            
            -- 🔍 เช็ค IsStatic
            local isStatic = false
            if enemy.Data and enemy.Data.IsStatic then
                isStatic = true
            end
            
            if nameMatch and isStatic then
                local position = nil
                local positionSource = "unknown"
                
                -- ⭐⭐⭐ CRITICAL FIX: ใช้ Model.PrimaryPart.CFrame.Position สำหรับ real-time position
                -- Mohato Clone จะ teleport ดังนั้นต้องใช้ Model position แบบ real-time
                
                -- วิธีที่ 1: Model.PrimaryPart.CFrame.Position (real-time - ดีที่สุด!)
                if enemy.Model and enemy.Model.PrimaryPart then
                    local ok, cframe = pcall(function()
                        return enemy.Model.PrimaryPart.CFrame
                    end)
                    if ok and cframe then
                        position = cframe.Position
                        positionSource = "Model.PrimaryPart.CFrame"
                    end
                end
                
                -- วิธีที่ 2: Model:GetPivot().Position
                if not position and enemy.Model and enemy.Model.Parent then
                    local ok, pivot = pcall(function()
                        return enemy.Model:GetPivot()
                    end)
                    if ok and pivot then
                        position = pivot.Position
                        positionSource = "Model:GetPivot()"
                    end
                end
                
                -- วิธีที่ 3: HumanoidRootPart.CFrame.Position
                if not position and enemy.Model then
                    local hrp = enemy.Model:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Parent then
                        local ok, cframe = pcall(function()
                            return hrp.CFrame
                        end)
                        if ok and cframe then
                            position = cframe.Position
                            positionSource = "HumanoidRootPart.CFrame"
                        end
                    end
                end
                
                -- วิธีที่ 4: PrimaryPart.Position (fallback)
                if not position and enemy.PrimaryPart then
                    local ok, pos = pcall(function()
                        return enemy.PrimaryPart.Position
                    end)
                    if ok and pos then
                        position = pos
                        positionSource = "PrimaryPart.Position"
                    end
                end
                
                -- วิธีที่ 5: enemy.Position (อาจ stale - ใช้เป็น last resort)
                if not position and enemy.Position then
                    position = enemy.Position
                    positionSource = "enemy.Position (stale)"
                end
                
                if position then
                    table.insert(mohatoList, {
                        id = uniqueId,
                        position = position,
                        enemy = enemy,
                        name = enemy.Name,
                        source = positionSource
                    })
                    
                    -- 🔍 DEBUG: Log แต่ละตัวที่เจอ พร้อม source
                    DebugPrint(string.format("🔍 พบ %s ID: %d ที่ (%.1f, %.1f, %.1f) [%s]", 
                        enemy.Name, uniqueId, position.X, position.Y, position.Z, positionSource))
                end
            end
        end
    end)
    
    -- 🔍 หา ID ที่สูงที่สุด (= ตัวล่าสุด/จริง)
    if #mohatoList == 0 then
        DebugPrint(string.format("⚠️ [ID CHECK] ไม่พบ %s ใน _ActiveEnemies!", enemyName))
        return nil
    end
    
    -- Sort by ID (สูงสุดก่อน)
    table.sort(mohatoList, function(a, b) return a.id > b.id end)
    
    local latest = mohatoList[1]  -- ID สูงสุด
    
    -- 🔍 DEBUG: แสดง ID ทั้งหมด
    local allIds = {}
    for _, data in ipairs(mohatoList) do
        table.insert(allIds, string.format("%d(%.0f,%.0f,%.0f)", 
            data.id, data.position.X, data.position.Y, data.position.Z))
    end
    
    DebugPrint(string.format("🎯 [ID CHECK] พบ %s %d ตัว: [%s] | เลือก ID สูงสุด: %d → %.1f, %.1f, %.1f", 
        enemyName, #mohatoList, table.concat(allIds, ", "),
        latest.id, latest.position.X, latest.position.Y, latest.position.Z))
    
    -- คืนค่าทั้ง position, id, และ enemy object
    return {
        position = latest.position,
        id = latest.id,
        enemy = latest.enemy
    }
end

-- ⭐ Cache สำหรับป้องกัน log spam (ใช้ _G)
_G.APClear.LastStaticEnemyCount = 0
_G.APClear.LastStaticEnemyCheck = 0

local function CheckClearEnemyMode()
    -- ✅ FIX: เช็คจาก ClientEnemyHandler._ActiveEnemies[id].Data.IsStatic = true เท่านั้น
    -- ไม่เช็ค BossIcon เพราะจะไปจับ enemy ธรรมดาที่เดินตาม path
    
    if not workspace:FindFirstChild("Entities") then
        -- ถ้าไม่มี Entities → ขาย ClearEnemy Units ทั้งหมด
        if next(ClearEnemyUnits) then
            local soldCount = 0
            for guid, _ in pairs(ClearEnemyUnits) do
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    local clearUnit = ClientUnitHandler._ActiveUnits[guid]
                    if clearUnit then
                        local unitWrapper = {
                            GUID = guid,
                            Name = clearUnit.Name,
                            CanSell = true
                        }
                        
                        if SellUnit(unitWrapper) then
                            soldCount = soldCount + 1
                            DebugPrint(string.format("💸 ขาย ClearEnemy Unit: %s", clearUnit.Name))
                        end
                    end
                end
            end
            
            if soldCount > 0 then
                ClearEnemyUnits = {}
                ClearEnemySoldForEnemy = {}  -- ✅ รีเซ็ตการติดตาม
                ClearEnemyNoMoreSellable = false  -- ✅ รีเซ็ต global flag
                ClearEnemySlotFullLogged = {}  -- ✅ รีเซ็ต log tracking
                ClearEnemyFoundDamageLogged = {}  -- ✅ รีเซ็ต log tracking
                ClearEnemyPlacedCount = {}  -- ✅ รีเซ็ต placed count
                StaticEnemySpawnWave = {}  -- ✅ รีเซ็ต spawn wave
                DebugPrint(string.format("✅ เคลียร์ ClearEnemy Units ทั้งหมด %d ตัว", soldCount))
            end
        end
        return
    end
    
    -- หา Static Enemy จาก ClientEnemyHandler (IsStatic = true เท่านั้น)
    local staticEnemies = {}
    
    -- ⭐⭐⭐ CRITICAL FIX: สำหรับ Mohato Clone ที่ teleport ไปตำแหน่งใหม่
    -- Mohato Clone จะถูก spawn ใหม่ทุกครั้งที่ย้าย (ได้ ID ใหม่)
    -- ดังนั้นเราต้องเลือกเฉพาะตัวที่มี ID สูงสุด (ตัวล่าสุด = ตัวจริง)
    local mohatoByName = {}  -- {enemyName = {maxId = number, enemy = enemy}}
    
    if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
        pcall(function()
            -- ขั้นตอน 1: หา Mohato Clone ทั้งหมด และเก็บเฉพาะตัวที่ ID สูงสุดต่อชื่อ
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.Data and enemy.Data.IsStatic then
                    local enemyName = enemy.Name or "StaticEnemy"
                    local entityIdNumber = enemy.UniqueIdentifier or 0
                    
                    -- เช็คว่าเป็น Mohato หรือไม่
                    local isMohato = enemyName:find("Mohato") ~= nil
                    
                    if isMohato then
                        -- สำหรับ Mohato: เก็บเฉพาะตัวที่ ID สูงสุด (ตัวล่าสุด)
                        if not mohatoByName[enemyName] or entityIdNumber > mohatoByName[enemyName].maxId then
                            mohatoByName[enemyName] = {
                                maxId = entityIdNumber,
                                enemy = enemy
                            }
                        end
                    end
                end
            end
            
            -- ขั้นตอน 2: ประมวลผล Static Enemy ทั้งหมด
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.Data and enemy.Data.IsStatic then
                    local enemyName = enemy.Name or "StaticEnemy"
                    local entityIdNumber = enemy.UniqueIdentifier or 0
                    local entityId = tostring(entityIdNumber)
                    
                    -- เช็คว่าเป็น Mohato หรือไม่
                    local isMohato = enemyName:find("Mohato") ~= nil
                    
                    -- ⭐ สำหรับ Mohato: ข้ามถ้าไม่ใช่ตัวที่ ID สูงสุด
                    local shouldSkip = false
                    if isMohato then
                        local bestMohato = mohatoByName[enemyName]
                        if bestMohato and entityIdNumber ~= bestMohato.maxId then
                            -- นี่คือ Mohato Clone ตัวเก่า (ID ต่ำกว่า) → ข้าม!
                            DebugPrint(string.format("⏭️ ข้าม %s ID %d (มี ID สูงกว่า: %d)", 
                                enemyName, entityIdNumber, bestMohato.maxId))
                            shouldSkip = true
                        end
                    end
                    
                    if not shouldSkip then
                    -- ⭐⭐⭐ CRITICAL FIX: เก็บทั้ง number (สำหรับ _ActiveEnemies) และ string (สำหรับ tracking)
                    
                    -- 🔥 เช็คว่า Enemy ยังอยู่จริงหรือวาร์ปไปแล้ว
                    local isStillActive = false
                    if enemy.Model and enemy.Model.Parent then
                        -- Model ยังอยู่ใน workspace = ยังอยู่จริง
                        isStillActive = true
                    elseif enemy.Position then
                        -- ถ้าไม่มี Model แต่มี Position (อาจซ่อน Model) = ยังอยู่
                        isStillActive = true
                    end
                    
                    if not isStillActive then
                        -- 🗑️ Enemy วาร์ปไปแล้ว ลบออกจาก tracking
                        if _G.StaticEnemyLastPosition then
                            _G.StaticEnemyLastPosition[entityId] = nil
                        end
                        if MohatoHealthData[entityId] then
                            MohatoHealthData[entityId] = nil
                        end
                        DebugPrint(string.format("🗑️ %s วาร์ปไปแล้ว → ลบออกจาก tracking", enemy.Name or "StaticEnemy"))
                        -- ข้ามไป ไม่เพิ่มใน staticEnemies
                        -- continue to next enemy
                    else
                    
                    -- เช็คซ้ำว่ามีอยู่แล้วหรือยัง
                    local exists = false
                    for _, existing in pairs(staticEnemies) do
                        if existing.EntityId == entityId then
                            exists = true
                            break
                        end
                    end
                    
                    if not exists then
                        -- ⭐ เก็บ Health ด้วย
                        local health = enemy.Health or enemy.Data.Health or 0
                        local maxHealth = enemy.MaxHealth or enemy.Data.MaxHealth or enemy.Data.Health or 1
                        
                        -- ⭐⭐⭐ NEW: เช็คว่า Vulnerable โดยใช้ MohatoHealthEvent (ตาม Decom.lua)
                        local isVulnerable = true  -- default: ตีได้
                        local wavesElapsed = 0
                        local wavesNeeded = 3  -- default fallback
                        
                        -- ⭐ ใช้ global CurrentWave ที่อัพเดทจาก GetWaveFromUI()
                        GetWaveFromUI()  -- อัพเดท CurrentWave
                        local currentWave = CurrentWave
                        
                        -- ⭐ ถ้าเป็น Mohato Clone → เช็คจาก MohatoHealthEvent หรือ manual calculation
                        local enemyName = enemy.Name or ""
                        if enemyName:find("Mohato") then
                            local guid = tostring(enemy.UniqueIdentifier)
                            
                            -- 🔥 Priority 1: ใช้ข้อมูลจาก MohatoHealthEvent (ถูกต้องที่สุด - มา WavesNeeded จาก server)
                            if MohatoHealthData[guid] then
                                wavesElapsed = MohatoHealthData[guid].WavesElapsed or 0
                                wavesNeeded = MohatoHealthData[guid].WavesNeeded or 3  -- ใช้จาก server
                                isVulnerable = (wavesElapsed >= wavesNeeded)
                                
                                DebugPrint(string.format("📊 [EVENT] Mohato %s: Waves %d/%d → %s", 
                                    guid, wavesElapsed, wavesNeeded, 
                                    isVulnerable and "✅ VULNERABLE" or "⏸️ WAITING"))
                            else
                                -- 🔄 Fallback: Manual calculation (ถ้า event ยังไม่มา - ใช้ 3 เป็น default)
                                wavesNeeded = 3  -- fallback default
                                if not StaticEnemySpawnWave[entityId] then
                                    StaticEnemySpawnWave[entityId] = currentWave
                                    DebugPrint(string.format("📝 [MANUAL] Mohato spawn ที่ Wave %d (รอถึง Wave %d)", 
                                        currentWave, currentWave + wavesNeeded))
                                end
                                
                                local spawnWave = StaticEnemySpawnWave[entityId]
                                wavesElapsed = currentWave - spawnWave
                                
                                -- ⭐ FIX: ถ้า wavesElapsed < 0 แปลว่า spawn wave ผิด → แก้เป็น current
                                if wavesElapsed < 0 then
                                    StaticEnemySpawnWave[entityId] = currentWave
                                    wavesElapsed = 0
                                end
                                
                                isVulnerable = (wavesElapsed >= wavesNeeded)
                                
                                DebugPrint(string.format("📊 [MANUAL] Mohato spawn Wave %d, current %d → elapsed %d/%d → %s", 
                                    spawnWave, currentWave, wavesElapsed, wavesNeeded,
                                    isVulnerable and "✅ VULNERABLE" or "⏸️ WAITING"))
                            end
                        end
                        
                        -- ⭐⭐⭐ CRITICAL: อัพเดทตำแหน่ง Static Enemy แบบ Real-time
                        -- ขั้นตอน:
                        -- 1) ใช้ Model:GetPivot().Position (แม่นยำที่สุด)
                        -- 2) ถ้าไม่มี ให้ fallback ไปที่ HumanoidRootPart/Torso/PrimaryPart
                        -- 3) ถ้ายังไม่มี ให้ใช้ enemy.Position (ถ้ามี)
                        -- 4) ถ้าตำแหน่งเท่ากับ spawn position (spawn ของ enemy) ให้ลองหา offset รอบๆ (skip spawn)
                        local realTimePos = nil

                        -- วิธีที่ 1: ใช้ Model:GetPivot().Position (แม่นยำที่สุด!)
                        if enemy.Model and enemy.Model.Parent then
                            local ok, pos = pcall(function()
                                return enemy.Model:GetPivot().Position
                            end)
                            if ok and pos then
                                realTimePos = pos
                                enemy.Position = pos -- update back to enemy object
                            end
                        end

                        -- วิธีที่ 2: Fallback ถ้า GetPivot ล้มเหลว
                        if not realTimePos and enemy.Model and enemy.Model.Parent then
                            if enemy.Model:FindFirstChild("HumanoidRootPart") then
                                realTimePos = enemy.Model.HumanoidRootPart.Position
                            elseif enemy.Model:FindFirstChild("Torso") then
                                realTimePos = enemy.Model.Torso.Position
                            elseif enemy.Model.PrimaryPart then
                                realTimePos = enemy.Model.PrimaryPart.Position
                            end
                        end

                        -- วิธีที่ 3: ใช้ enemy.Position ถ้ามี
                        if not realTimePos and enemy.Position and typeof(enemy.Position) == "Vector3" then
                            realTimePos = enemy.Position
                        end

                        -- ถ้ายังไม่มีตำแหน่งเลย -> ข้าม
                        if not realTimePos then
                            DebugPrint(string.format("⚠️ %s ไม่มีตำแหน่ง → ข้าม", enemy.Name or "StaticEnemy"))
                            -- continue to next enemy
                        else
                            -- ⭐ Detect spawn position: ถ้ายังไม่มี spawn pos เก็บไว้
                            if not StaticEnemySpawnPos then StaticEnemySpawnPos = {} end
                            if not StaticEnemySpawnPos[entityId] then
                                StaticEnemySpawnPos[entityId] = realTimePos
                            end

                            -- ⭐ ถ้าตอนนี้ตำแหน่งเท่ากับ spawn position (ระยะห่างเล็กน้อย) -> ลองหา offset รอบๆ
                            local spawnPos = StaticEnemySpawnPos[entityId]
                            if spawnPos and (realTimePos - spawnPos).Magnitude < 0.5 then
                                -- ลอง sample offsets รอบๆ เพื่อหา position ใหม่ (spiral / small grid)
                                local found = nil
                                local offsets = {
                                    Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1),
                                    Vector3.new(2,0,0), Vector3.new(-2,0,0), Vector3.new(0,0,2), Vector3.new(0,0,-2),
                                    Vector3.new(3,0,0), Vector3.new(-3,0,0), Vector3.new(0,0,3), Vector3.new(0,0,-3)
                                }
                                for _, off in ipairs(offsets) do
                                    local candidate = spawnPos + off
                                    -- raycast down to find ground Y if possible
                                    local rayOrigin = candidate + Vector3.new(0,10,0)
                                    local rayDir = Vector3.new(0,-50,0)
                                    local ok, hit = pcall(function()
                                        return workspace:Raycast(rayOrigin, rayDir)
                                    end)
                                    if ok and hit and hit.Position then
                                        candidate = Vector3.new(candidate.X, hit.Position.Y, candidate.Z)
                                    end
                                    -- Accept candidate if it's meaningfully different from spawn
                                    if (candidate - spawnPos).Magnitude > 0.9 then
                                        found = candidate
                                        break
                                    end
                                end
                                if found then
                                    realTimePos = found
                                    enemy.Position = found
                                    DebugPrint(string.format("🔁 %s: ใช้ตำแหน่งสำรองแทน spawn (%.1f, %.1f, %.1f)", enemy.Name or "StaticEnemy", found.X, found.Y, found.Z))
                                end
                            end
                        end
                        
                        -- 🔥 เก็บตำแหน่งล่าสุดไว้ tracking (อัพเดทตลอด)
                        if not _G.StaticEnemyLastPosition then _G.StaticEnemyLastPosition = {} end
                        _G.StaticEnemyLastPosition[entityId] = realTimePos
                        
                        table.insert(staticEnemies, {
                            EntityId = entityId,            -- ⭐ string สำหรับ tracking
                            EntityIdNumber = entityIdNumber, -- ⭐⭐⭐ number สำหรับ _ActiveEnemies lookup!
                            Position = realTimePos,  -- ⭐ ใช้ real-time position แทน enemy.Position
                            Name = enemy.Name or "StaticEnemy",
                            Model = enemy.Model,
                            Health = health,
                            MaxHealth = maxHealth,
                            WavesElapsed = wavesElapsed,
                            WavesNeeded = wavesNeeded,
                            CurrentWave = currentWave,
                            SpawnWave = StaticEnemySpawnWave[entityId] or currentWave,
                            IsVulnerable = isVulnerable  -- true = ตีได้, false = ต้องรอ waves
                        })
                        
                        -- ✅ Log เฉพาะเมื่อมีการเปลี่ยนแปลง (Waves หรือ Vulnerable status)
                        local lastState = StaticEnemyLastState[entityId]
                        local hasChanged = false
                        
                        if not lastState then
                            -- ครั้งแรก = มีการเปลี่ยนแปลง
                            hasChanged = true
                        else
                            -- เช็คว่ามีอะไรเปลี่ยนหรือไม่
                            if lastState.WavesElapsed ~= wavesElapsed or 
                               lastState.IsVulnerable ~= isVulnerable then
                                hasChanged = true
                            end
                        end
                        
                        if hasChanged then
                            -- อัพเดท state ใหม่
                            StaticEnemyLastState[entityId] = {
                                WavesElapsed = wavesElapsed,
                                Position = realTimePos,
                                IsVulnerable = isVulnerable
                            }
                            
                            -- Log การเปลี่ยนแปลง
                            local statusText
                            local statusIcon
                            if isVulnerable then
                                statusText = "✅ พร้อมโจมตี"
                                statusIcon = "✅"
                            else
                                local targetWave = (StaticEnemySpawnWave[entityId] or currentWave) + wavesNeeded
                                statusText = string.format("⏸️ รอ Wave %d (%d/%d)", targetWave, wavesElapsed, wavesNeeded)
                                statusIcon = "⏸️"
                            end
                            
                            DebugPrint(string.format("� %s UPDATE: %s ที่ %.1f, %.1f, %.1f (HP: %.0f/%.0f) | %s", 
                                statusIcon,
                                enemy.Name or "Unknown", 
                                realTimePos.X, 
                                realTimePos.Y, 
                                realTimePos.Z,
                                health,
                                maxHealth,
                                statusText))
                        end
                    end  -- end if not exists
                    end  -- end else (isStillActive)
                    end  -- end if not shouldSkip
                end  -- end if enemy.Data.IsStatic
            end  -- end for loop
        end)  -- end pcall
    end
    
    -- ⭐ NEW: เช็คว่า Static Enemy ที่มี ClearEnemy Units ยังมีชีวิตอยู่หรือไม่
    -- ถ้าตายแล้ว → ขาย ClearEnemy Units ที่วางไว้สำหรับ enemy นั้น
    if next(ClearEnemyUnits) then
        -- หา EntityId ของ Static Enemies ที่ยังมีชีวิต
        local aliveStaticEnemyIds = {}
        for _, staticEnemy in pairs(staticEnemies) do
            aliveStaticEnemyIds[staticEnemy.EntityId] = true
        end
        
        -- ขาย units ที่วางไว้สำหรับ Static Enemy ที่ตายแล้ว
        local unitsToSell = {}
        for guid, enemyId in pairs(ClearEnemyUnits) do
            if not aliveStaticEnemyIds[enemyId] then
                table.insert(unitsToSell, {GUID = guid, EnemyId = enemyId})
            end
        end
        
        if #unitsToSell > 0 then
            local soldCount = 0
            for _, unitInfo in pairs(unitsToSell) do
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    local clearUnit = ClientUnitHandler._ActiveUnits[unitInfo.GUID]
                    if clearUnit then
                        local unitWrapper = {
                            GUID = unitInfo.GUID,
                            Name = clearUnit.Name,
                            CanSell = true
                        }
                        
                        if SellUnit(unitWrapper) then
                            soldCount = soldCount + 1
                            DebugPrint(string.format("💸 ขาย ClearEnemy Unit: %s (Static Enemy ตายแล้ว)", clearUnit.Name))
                        end
                    end
                end
                ClearEnemyUnits[unitInfo.GUID] = nil
                -- รีเซ็ต count สำหรับ enemy ที่ตาย
                ClearEnemyPlacedCount[unitInfo.EnemyId] = nil
                StaticEnemySpawnWave[unitInfo.EnemyId] = nil
                ClearEnemySlotFullLogged[unitInfo.EnemyId .. "_max"] = nil
                ClearEnemySlotFullLogged[unitInfo.EnemyId .. "_notready"] = nil
            end
            
            if soldCount > 0 then
                DebugPrint(string.format("✅ ขาย ClearEnemy Units %d ตัว (Static Enemy ตายแล้ว)", soldCount))
            end
        end
    end
    
    -- ถ้ามี Static Enemy → วาง 1 ตัวต่อ 1 enemy
    local currentTime = tick()
    local lastCount = _G.APClear.LastStaticEnemyCount or 0
    local lastCheck = _G.APClear.LastStaticEnemyCheck or 0
    local countChanged = (#staticEnemies ~= lastCount)
    local timeElapsed = (currentTime - lastCheck) > 5  -- Log ทุก 5 วินาที
    
    if countChanged then
        -- Log เฉพาะเมื่อจำนวนเปลี่ยน (ไม่ใช่ทุก 5 วินาที)
        _G.APClear.LastStaticEnemyCount = #staticEnemies
        _G.APClear.LastStaticEnemyCheck = currentTime
    end
    
    if #staticEnemies > 0 then
        for _, staticEnemy in pairs(staticEnemies) do
            local skipThisEnemy = false  -- ⭐ Flag สำหรับข้าม enemy นี้
            
            -- ⭐ เช็คว่าวาง units ครบ limit สำหรับ enemy นี้แล้วหรือยัง
            local placedCount = ClearEnemyPlacedCount[staticEnemy.EntityId] or 0
            if placedCount >= CLEAR_ENEMY_MAX_UNITS then
                skipThisEnemy = true
                -- Log แค่ครั้งแรก
                if not ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_max"] then
                    DebugPrint(string.format("⏹️ ClearEnemy: วางครบ %d ตัวแล้วสำหรับ %s → ข้าม", 
                        CLEAR_ENEMY_MAX_UNITS, staticEnemy.Name))
                    ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_max"] = true
                end
            end
            
            -- ⭐ เช็คว่า enemy พร้อมให้โจมตีหรือยัง (IsVulnerable = Waves ครบ)
            if not skipThisEnemy and not staticEnemy.IsVulnerable then
                skipThisEnemy = true
                -- Log แค่ครั้งแรก (ใช้ key แยก)
                if not ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_notready"] then
                    local targetWave = (staticEnemy.SpawnWave or 0) + (staticEnemy.WavesNeeded or 3)
                    local waitMsg = string.format("รอ Wave %d (ปัจจุบัน: %d, ผ่านแล้ว: %d/%d)", 
                        targetWave, staticEnemy.CurrentWave or 0, staticEnemy.WavesElapsed or 0, staticEnemy.WavesNeeded or 3)
                    DebugPrint(string.format("⏸️ ClearEnemy: %s ยังไม่พร้อมโจมตี (%s)", 
                        staticEnemy.Name, waitMsg))
                    ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_notready"] = true
                end
            end
            
            -- ⭐⭐⭐ FIX: เมื่อ enemy พร้อมโจมตีแล้ว → clear flag, log, และ RESET skipThisEnemy!
            if staticEnemy.IsVulnerable then
                -- ✅ Clear log flag เมื่อพร้อมโจมตี
                if ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_notready"] then
                    ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_notready"] = nil
                    DebugPrint(string.format("✅ ClearEnemy: %s พร้อมโจมตีแล้ว! (Wave %d ครบแล้ว) → พยายามวาง", 
                        staticEnemy.Name, staticEnemy.CurrentWave or 0))
                end
                
                -- ✅ ถ้าเคยข้ามเพราะ "ยังไม่พร้อม" → RESET skipThisEnemy เพื่อให้ลองวางได้
                if skipThisEnemy and (ClearEnemySlotFullLogged[staticEnemy.EntityId .. "_max"] == nil) then
                    skipThisEnemy = false
                    DebugPrint(string.format("🔄 RESET skipThisEnemy: %s (เปลี่ยนจากไม่พร้อม → พร้อม)", staticEnemy.Name))
                end
            end
            
            if not skipThisEnemy then
                -- ✅✅✅ FIX: หา damage unit ที่ราคาใกล้เงินที่มีที่สุด (affordable)
                local hotbar = GetHotbarUnits()
                local cheapestSlot = nil
                local cheapestUnit = nil
                local cheapestBasePrice = math.huge
                local slotIsFull = false
                
                -- ⭐ รวบรวม Damage units ทั้งหมดพร้อมราคา
                local damageUnits = {}
                
                for slot, unit in pairs(hotbar) do
                    local isEconomy = IsIncomeUnit and IsIncomeUnit(unit.Name, unit.Data or {})
                    local isBuff = IsBuffUnit and IsBuffUnit(unit.Name, unit.Data or {})
                    local isDamage = not isEconomy and not isBuff
                    
                    if isDamage then
                        local basePrice = unit.Price
                        
                        if UnitsData and UnitsData[unit.Name] then
                            basePrice = UnitsData[unit.Name].Price or UnitsData[unit.Name].Cost or basePrice
                        elseif unit.Data and (unit.Data.Price or unit.Data.Cost) then
                            basePrice = unit.Data.Price or unit.Data.Cost
                        end
                        
                        -- ⭐ เช็ค Trait limit
                        local canPlaceMore = CanPlaceMoreUnits(unit.Name, unit.UnitObject)
                        
                        if canPlaceMore then
                            table.insert(damageUnits, {
                                slot = slot,
                                unit = unit,
                                price = basePrice
                            })
                        end
                    end
                end
                
                -- ⭐ Sort by price (ถูกสุดก่อน)
                table.sort(damageUnits, function(a, b) return a.price < b.price end)
                
                -- 🔥 สำรองเงินไว้สำหรับ Auto Place ปกติ
                local RESERVE_YEN = 500
                local currentYen = GetYen()
                local availableYen = math.max(0, currentYen - RESERVE_YEN)
                
                -- ⭐ หาตัวที่ affordable (มีเงินพอ) หรือถูกที่สุด
                local affordableUnit = nil
                local cheapestOverall = nil
                
                for _, data in ipairs(damageUnits) do
                    -- เก็บตัวถูกสุด (สำหรับกรณีต้องขาย)
                    if not cheapestOverall then
                        cheapestOverall = data
                    end
                    
                    -- 🔥 หาตัวที่ affordable (ใช้ availableYen แทน currentYen)
                    if not affordableUnit and availableYen >= data.price then
                        -- เช็ค slot limit ด้วย
                        local limit, current = GetSlotLimit(data.slot)
                        if current < limit then
                            affordableUnit = data
                        end
                    end
                end
                
                -- ⭐ ใช้ affordable ก่อน ถ้าไม่มีค่อยใช้ cheapest (ต้องขาย)
                if affordableUnit then
                    cheapestSlot = affordableUnit.slot
                    cheapestUnit = affordableUnit.unit
                    cheapestBasePrice = affordableUnit.price
                elseif cheapestOverall then
                    cheapestSlot = cheapestOverall.slot
                    cheapestUnit = cheapestOverall.unit
                    cheapestBasePrice = cheapestOverall.price
                end
                
                -- ⭐⭐⭐ ถ้าไม่พบ Damage Unit เลยใน Hotbar → ข้าม
                if not cheapestUnit then
                    if not ClearEnemyFoundDamageLogged[staticEnemy.EntityId] then
                        DebugPrint("⚠️ ClearEnemy: ไม่พบ Damage Unit ใน Hotbar (Trait limit หมด)")
                        ClearEnemyFoundDamageLogged[staticEnemy.EntityId] = "none"
                    end
                    skipThisEnemy = true
                else
                    -- ⭐ Log ทุกครั้งเมื่อหา unit ได้ (เพื่อเช็คว่า slot เปลี่ยนหรือไม่)
                    local affordable = (availableYen >= cheapestBasePrice) and "✓" or "✗"
                    local limit, current = GetSlotLimit(cheapestSlot)
                    
                    -- ⭐⭐⭐ FIX: Log ทุกครั้งเพื่อเห็นการเปลี่ยน slot
                    local lastLoggedSlot = ClearEnemyFoundDamageLogged[staticEnemy.EntityId]
                    local currentSlotInfo = string.format("Slot%d:%s", cheapestSlot, cheapestUnit.Name)
                    
                    if lastLoggedSlot ~= currentSlotInfo then
                        DebugPrint(string.format("✅ ClearEnemy: เลือก %s (slot %d, ราคา %d, เงินมี %d, ใช้ได้ %d %s, %d/%d)", 
                            cheapestUnit.Name, cheapestSlot, cheapestBasePrice, currentYen, availableYen, affordable, current, limit))
                        ClearEnemyFoundDamageLogged[staticEnemy.EntityId] = currentSlotInfo
                    end
                end
                
                DebugPrint("🔥 [TEST] ก่อนถึง CRITICAL log")
                
                -- 🔍🔍🔍 CRITICAL DEBUG: Log OUTSIDE the if block
                DebugPrint(string.format("🔍🔍🔍 [CRITICAL] After unit selection - skipThisEnemy=%s, cheapestUnit=%s", 
                    tostring(skipThisEnemy), cheapestUnit and cheapestUnit.Name or "nil"))
                
                -- ⭐ Step 2: เช็ค slot limit ว่าวางได้หรือไม่
                if not skipThisEnemy then
                    local limit, current = GetSlotLimit(cheapestSlot)
                    if current >= limit then
                        slotIsFull = true
                        
                        -- ✅ FIX: ถ้า slot เต็มและขายไม่ได้แล้ว → skip ทันที (ไม่ต้อง log ซ้ำ)
                        local hasSoldForThisEnemy = ClearEnemySoldForEnemy[staticEnemy.EntityId] or false
                        if ClearEnemyNoMoreSellable or hasSoldForThisEnemy then
                            -- ✅ ถ้าวางไม่ครบ LIMIT แต่ slot เต็ม → ไม่ log แล้ว ให้รอ slot ว่าง
                            local alreadyPlaced = ClearEnemyPlacedCount[staticEnemy.EntityId] or 0
                            if alreadyPlaced < CLEAR_ENEMY_MAX_UNITS then
                                -- ไม่ log เพื่อลด spam - จะลองใหม่ในรอบถัดไป
                            else
                                -- Log แค่ครั้งแรกต่อ enemy
                                if not ClearEnemySlotFullLogged[staticEnemy.EntityId] then
                                    DebugPrint(string.format("🔒 ClearEnemy: Slot %d เต็ม (%d/%d) - ไม่มีตัวให้ขาย → ข้าม", cheapestSlot, current, limit))
                                    ClearEnemySlotFullLogged[staticEnemy.EntityId] = true
                                end
                            end
                            skipThisEnemy = true
                        else
                            DebugPrint(string.format("🔒 ClearEnemy: Slot %d เต็ม (%d/%d) → ต้องขายก่อน", cheapestSlot, current, limit))
                        end
                    else
                        -- ✅ Slot ว่าง → reset flag เพื่อให้วางตัวต่อได้
                        if ClearEnemySlotFullLogged[staticEnemy.EntityId] then
                            ClearEnemySlotFullLogged[staticEnemy.EntityId] = nil
                            DebugPrint(string.format("🔓 ClearEnemy: Slot %d ว่างแล้ว (%d/%d) → พยายามวางต่อ", cheapestSlot, current, limit))
                        end
                    end
                end
                
                -- 🔍🔍🔍 DEBUG: Log ก่อนเข้า if not skipThisEnemy
                DebugPrint(string.format("🔍 [BEFORE-BLOCK] skipThisEnemy=%s สำหรับ %s (ID: %s)", 
                    tostring(skipThisEnemy), staticEnemy.Name, staticEnemy.EntityId))
                
                if not skipThisEnemy then
                    DebugPrint(string.format("🔍 [INSIDE-BLOCK] เข้า if not skipThisEnemy แล้ว สำหรับ %s", staticEnemy.Name))
                    
                    -- ⭐ NEW: เช็คว่าขายไปแล้วหรือยัง (ขายแค่ครั้งเดียวต่อ Static Enemy)
                    local hasSoldForThisEnemy = ClearEnemySoldForEnemy[staticEnemy.EntityId] or false
                    
                    -- ⭐ วาง unit ถ้า: มีเงินพอ + slot ไม่เต็ม
                    local canPlace = true
                    local needSell = false
                    local sellReason = ""
                    
                    -- 🔥 สำรองเงินไว้สำหรับ Auto Place ปกติ (อย่าให้ ClearEnemy ใช้หมด!)
                    local RESERVE_YEN = 500  -- สำรองเงินไว้ 500 สำหรับวาง units ปกติ
                    local currentYen = GetYen()
                    local availableYen = math.max(0, currentYen - RESERVE_YEN)
                    
                    -- ⭐ ถ้าเลือก affordableUnit ได้ = มีเงินพอ + slot ว่าง แล้ว
                    -- ถ้าเลือก cheapestOverall = ต้องขายหรือรอเงิน
                    local isAffordable = (availableYen >= cheapestBasePrice)  -- 🔥 ใช้ availableYen แทน GetYen()
                    local limit, current = GetSlotLimit(cheapestSlot)
                    local slotHasSpace = (current < limit)
                    
                    if not isAffordable then
                        needSell = true
                        sellReason = string.format("💰 เงินไม่พอ (มี %d, ต้องการ %d, สำรอง %d)", currentYen, cheapestBasePrice, RESERVE_YEN)
                        canPlace = false
                    elseif not slotHasSpace then
                        needSell = true
                        sellReason = string.format("🔒 Slot %d เต็ม (%d/%d)", cheapestSlot, current, limit)
                        canPlace = false
                    end
                    
                    -- ✅ FIX: ถ้าต้องขาย แต่ขายไปแล้ว → ข้าม Static Enemy นี้
                    if needSell and hasSoldForThisEnemy then
                        skipThisEnemy = true
                    end
                    
                    -- ✅ FIX: ขายแค่ครั้งเดียวต่อ Static Enemy
                    if not skipThisEnemy and needSell and not hasSoldForThisEnemy then
                        
                        local activeUnits = GetActiveUnits()
                        local sellableUnits = {}
                        
                        -- ⭐ FIX: เหตุผลที่ต้องขาย (slotFull vs noMoney)
                        local slotFullSell = not slotHasSpace
                        local cheapestUnitName = cheapestUnit.Name
                        
                        -- ถ้า Slot เต็ม → ขายเฉพาะตัวที่ชื่อเดียวกัน (รวมถึง ClearEnemy Unit เก่า)
                        -- ถ้าเงินไม่พอ → ขาย Damage ตัวถูกสุดได้ (ไม่รวม ClearEnemy)
                        local sellSameTypeOnly = slotFullSell
                        
                        DebugPrint(sellReason .. " → ขาย 2 ตัวถูกสุดเพื่อ ClearEnemy" .. (sellSameTypeOnly and " (ขายเฉพาะ " .. cheapestUnitName .. ")" or ""))
                        
                        for _, unit in pairs(activeUnits) do
                            if unit.CanSell ~= false then
                                local isClearEnemy = ClearEnemyUnits[unit.GUID] ~= nil
                                local isEmergencyUnit = EmergencyUnits[unit.GUID] ~= nil  -- ⭐ เช็คว่าเป็น Emergency Unit
                                local isEconomy = IsIncomeUnit(unit.Name, unit.Data or {})
                                local isBuff = IsBuffUnit(unit.Name, unit.Data or {})
                                local isDamage = not isEconomy and not isBuff
                                
                                -- ⭐⭐⭐ CRITICAL FIX: ไม่ขาย Emergency Units เด็ดขาด!
                                if isEmergencyUnit then
                                    -- ไม่ขาย Emergency Units ไม่ว่ากรณีใดๆ
                                elseif isDamage then
                                    local canSellThis = false
                                    if sellSameTypeOnly then
                                        -- Slot เต็ม: ขายเฉพาะตัวที่ชื่อเดียวกัน (แต่ไม่ใช่ Emergency!)
                                        canSellThis = (unit.Name == cheapestUnitName) and not isEmergencyUnit
                                    else
                                        -- เงินไม่พอ: ขาย Damage ตัวใดก็ได้ (ไม่รวม ClearEnemy และ Emergency)
                                        canSellThis = not isClearEnemy and not isEmergencyUnit
                                    end
                                    
                                    if canSellThis then
                                        local basePrice = 0
                                        if UnitsData and UnitsData[unit.Name] then
                                            basePrice = UnitsData[unit.Name].Price or UnitsData[unit.Name].Cost or 0
                                        elseif unit.Data then
                                            basePrice = unit.Data.Price or unit.Data.Cost or 0
                                        end
                                        
                                        -- ⭐ ใช้ upgrade level เป็นตัวตัดสิน (อัพเกรดต่ำสุดก่อน)
                                        local upgradeLevel = unit.Upgrade or 1
                                        local sellValue = basePrice * 0.7
                                        table.insert(sellableUnits, {
                                            unit = unit, 
                                            value = sellValue, 
                                            basePrice = basePrice,
                                            upgradeLevel = upgradeLevel,
                                            isClearEnemy = isClearEnemy
                                        })
                                    end
                                end
                            end
                        end
                        
                        -- ⭐ FIX: Sort by upgrade level first (ต่ำสุดก่อน), then by isClearEnemy (non-ClearEnemy ก่อน)
                        table.sort(sellableUnits, function(a, b)
                            -- ขายตัวที่ไม่ใช่ ClearEnemy ก่อน
                            if a.isClearEnemy ~= b.isClearEnemy then
                                return not a.isClearEnemy
                            end
                            -- ถ้าเป็น ClearEnemy เหมือนกัน → ขายตัวที่อัพเกรดต่ำก่อน
                            if a.upgradeLevel ~= b.upgradeLevel then
                                return a.upgradeLevel < b.upgradeLevel
                            end
                            -- ถ้า upgrade เท่ากัน → ขายตัวถูกกว่า
                            return a.basePrice < b.basePrice
                        end)
                        
                        -- ⭐ FIX: ถ้าไม่มีตัวให้ขาย → ข้าม + set global flag
                        if #sellableUnits == 0 then
                            if sellSameTypeOnly then
                                DebugPrint("⚠️ ClearEnemy: ไม่มีตัวให้ขาย (same type only) → รอเงินเพิ่ม")
                            else
                                DebugPrint(string.format("⚠️ ClearEnemy: ไม่มีตัวให้ขาย (ต้องการ %d มี %d) → รอเงินเพิ่ม", cheapestBasePrice, GetYen()))
                            end
                            -- ⭐ ไม่ set ClearEnemySoldForEnemy เพื่อให้ลองใหม่ได้เมื่อมีเงินพอ
                            skipThisEnemy = true
                        end
                        
                        if not skipThisEnemy then
                            -- ขาย 1 ตัวแรก (เพื่อให้ slot ว่าง 1 ตัว)
                            local soldCount = 0
                            for i = 1, math.min(1, #sellableUnits) do
                                local unitInfo = sellableUnits[i]
                                if SellUnit(unitInfo.unit) then
                                    soldCount = soldCount + 1
                                    -- ⭐ ลบออกจาก ClearEnemyUnits ถ้าเคยเป็น
                                    if unitInfo.isClearEnemy then
                                        ClearEnemyUnits[unitInfo.unit.GUID] = nil
                                        DebugPrint(string.format("💸 ขาย ClearEnemy เก่า: %s Lv.%d (มูลค่า %.0f) → เปิด slot ใหม่", 
                                            unitInfo.unit.Name, unitInfo.upgradeLevel, unitInfo.value))
                                    else
                                        DebugPrint(string.format("💸 ขายเพื่อ ClearEnemy: %s Lv.%d (มูลค่า %.0f)", 
                                            unitInfo.unit.Name, unitInfo.upgradeLevel, unitInfo.value))
                                    end
                                end
                            end
                            
                            if soldCount > 0 then
                                ClearEnemySoldForEnemy[staticEnemy.EntityId] = true
                                DebugPrint(string.format("✅ ขายแล้ว %d ตัว (เงินใหม่: %d)", soldCount, GetYen()))
                                task.wait(0.3)
                                
                                -- ⭐ หลังจากขายแล้ว ลองวางทันที
                                if GetYen() >= cheapestBasePrice then
                                    local limit, current = GetSlotLimit(cheapestSlot)
                                    if current < limit then
                                        canPlace = true
                                        needSell = false
                                    end
                                end
                            end
                            
                            -- ถ้ายังวางไม่ได้ → ข้าม
                            if needSell then
                                skipThisEnemy = true
                            end
                        end
                    end
                    
                    -- ⭐ ลองวาง unit ถ้ามีเงินพอและ slot ว่าง
                    DebugPrint(string.format("🔍 [PRE-CHECK] skipThisEnemy=%s, canPlace=%s สำหรับ %s", 
                        tostring(skipThisEnemy), tostring(canPlace), staticEnemy.Name))
                    
                    if not skipThisEnemy and canPlace then
                        DebugPrint(string.format("🔍 [PLACEMENT-START] เข้า placement block แล้ว!"))
                        -- 🔥 NEW: ใช้ GetRealMohatoPosition เพื่อหา ID และตำแหน่งที่ถูกต้อง
                        DebugPrint(string.format("🔍 [START] เริ่มหาตำแหน่งสำหรับ %s...", staticEnemy.Name))
                        
                        local mohatoData = GetRealMohatoPosition(staticEnemy.Name)
                        local targetPos = nil
                        local correctEntityId = staticEnemy.EntityId
                        local correctEntityIdNumber = staticEnemy.EntityIdNumber
                        local positionSource = "UNKNOWN"
                        
                        if mohatoData then
                            -- ใช้ข้อมูลจาก ID สูงสุด
                            targetPos = mohatoData.position
                            correctEntityIdNumber = mohatoData.id
                            correctEntityId = tostring(mohatoData.id)
                            positionSource = "GetRealMohatoPosition (ID สูงสุด)"
                            
                            -- 🔥 อัพเดท staticEnemy ให้ตรงกับ Mohato ตัวจริง
                            staticEnemy.EntityId = correctEntityId
                            staticEnemy.EntityIdNumber = correctEntityIdNumber
                            
                            -- 🔍 DEBUG: Log ตำแหน่งที่จะใช้วาง
                            DebugPrint(string.format("🎯 [POSITION] จะวางที่: %.1f, %.1f, %.1f (จาก %s, ID: %d)", 
                                targetPos.X, targetPos.Y, targetPos.Z, positionSource, correctEntityIdNumber))
                        else
                            DebugPrint(string.format("⚠️ [FALLBACK] GetRealMohatoPosition() คืนค่า nil → ใช้ fallback"))
                            
                            -- Fallback: ใช้ activeEnemy.Position ถ้า scan ไม่เจอ
                            if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
                                local activeEnemy = ClientEnemyHandler._ActiveEnemies[staticEnemy.EntityIdNumber]
                                if activeEnemy and activeEnemy.Position then
                                    targetPos = activeEnemy.Position
                                    positionSource = "activeEnemy.Position (fallback)"
                                    DebugPrint(string.format("⚠️ [FALLBACK] ใช้ตำแหน่งจาก activeEnemy: %.1f, %.1f, %.1f (ID: %d)", 
                                        targetPos.X, targetPos.Y, targetPos.Z, staticEnemy.EntityIdNumber))
                                else
                                    DebugPrint(string.format("❌ [FALLBACK] ไม่พบ activeEnemy สำหรับ ID: %d", staticEnemy.EntityIdNumber))
                                end
                            else
                                DebugPrint("❌ [FALLBACK] ClientEnemyHandler ไม่พร้อม")
                            end
                        end
                        
                        if not targetPos then
                            -- Log เฉพาะครั้งแรก
                            if not ClearEnemySlotFullLogged[correctEntityId .. "_nopos"] then
                                DebugPrint(string.format("⚠️ ไม่พบตำแหน่งสำหรับ %s (ID: %s) → ข้าม", 
                                    staticEnemy.Name, correctEntityId))
                                ClearEnemySlotFullLogged[correctEntityId .. "_nopos"] = true
                            end
                            skipThisEnemy = true
                        end
                        
                        if not skipThisEnemy then
                        -- ⭐⭐⭐ Lich King (Ruler) → วางหน้าประตูเสมอ (ClearEnemy mode)
                        local isLichKingRuler = cheapestUnit.Name:lower():find("lich") and cheapestUnit.Name:lower():find("ruler")
                        if isLichKingRuler then
                            local unitRange = GetUnitRange(cheapestUnit.Data) or 25
                            local frontPos = GetBestFrontPosition(unitRange)
                            if frontPos then
                                print(string.format("[ClearEnemy] 👑 Lich King (Ruler) → วางหน้าประตู"))
                                local success = PlaceUnit(cheapestSlot, frontPos)
                                if success then
                                    DebugPrint(string.format("✅ วาง Lich King (Ruler) หน้าประตูสำเร็จ!"))
                                    ClearEnemyPlacedCount[correctEntityId] = (ClearEnemyPlacedCount[correctEntityId] or 0) + 1
                                    task.wait(0.3)
                                    local activeUnits = GetActiveUnits()
                                    for _, unit in pairs(activeUnits) do
                                        if unit.Name == cheapestUnit.Name and unit.Position and (unit.Position - frontPos).Magnitude < 10 then
                                            if not ClearEnemyUnits[unit.GUID] then
                                                ClearEnemyUnits[unit.GUID] = correctEntityId
                                                break
                                            end
                                        end
                                    end
                                end
                                -- ข้ามการวางรอบ enemy (ใช้ front position แล้ว)
                                skipThisEnemy = true
                            end
                        end
                        end
                        
                        if not skipThisEnemy then
                        -- ⭐⭐⭐ FIX: หาตำแหน่งว่างรอบๆ enemy ที่ตีโดน 100%
                        -- ทดสอบหลายตำแหน่งรอบๆ enemy (12 ตำแหน่ง + ระยะต่างๆ)
                        local testOffsets = {
                            -- ระยะ 5 studs (ปกติ)
                            {x = 0, z = -5},   -- หน้า
                            {x = 0, z = 5},    -- หลัง
                            {x = -5, z = 0},   -- ซ้าย
                            {x = 5, z = 0},    -- ขวา
                            {x = -4, z = -4},  -- มุมซ้ายหน้า
                            {x = 4, z = -4},   -- มุมขวาหน้า
                            {x = -4, z = 4},   -- มุมซ้ายหลัง
                            {x = 4, z = 4},    -- มุมขวาหลัง
                            -- ระยะ 3 studs (ใกล้ขึ้น - ตีโดนแน่นอน)
                            {x = 0, z = -3},   -- ใกล้หน้า
                            {x = 0, z = 3},    -- ใกล้หลัง
                            {x = -3, z = 0},   -- ใกล้ซ้าย
                            {x = 3, z = 0},    -- ใกล้ขวา
                            -- ระยะ 7 studs (ไกลขึ้น - สำรอง)
                            {x = 0, z = -7},
                            {x = 0, z = 7},
                            {x = -7, z = 0},
                            {x = 7, z = 0},
                        }
                        
                        local bestPos = nil
                        local bestDistance = math.huge
                        local validPositions = {}
                        
                        -- ทดสอบแต่ละตำแหน่ง
                        for _, offset in ipairs(testOffsets) do
                            local testPos = targetPos + Vector3.new(offset.x, 0, offset.z)
                            local distance = (testPos - targetPos).Magnitude
                            
                            -- ⭐⭐⭐ เช็คว่าวางได้จริงหรือไม่
                            if CanPlaceAtPosition(cheapestUnit.Name, testPos) then
                                table.insert(validPositions, {
                                    position = testPos,
                                    distance = distance
                                })
                                
                                -- เลือกตำแหน่งที่ใกล้ที่สุด
                                if distance < bestDistance then
                                    bestPos = testPos
                                    bestDistance = distance
                                end
                            end
                        end
                        
                        -- ⭐ Log เฉพาะเมื่อพบตำแหน่งหรือล้มเหลว (ไม่ spam)
                        if #validPositions > 0 then
                            DebugPrint(string.format("✅ พบ %d ตำแหน่งว่าง รอบ %s (ID: %d) | ใกล้ที่สุด: %.1f studs → ตำแหน่งวาง: %.1f, %.1f, %.1f", 
                                #validPositions, staticEnemy.Name, correctEntityIdNumber, bestDistance,
                                bestPos.X, bestPos.Y, bestPos.Z))
                        else
                            DebugPrint(string.format("⚠️ ไม่พบตำแหน่งว่าง → ใช้ตำแหน่ง Enemy โดยตรง: %.1f, %.1f, %.1f", 
                                targetPos.X, targetPos.Y, targetPos.Z))
                        end
                        
                        -- ถ้าไม่เจอตำแหน่งเลย → ใช้ตำแหน่ง enemy โดยตรง (fallback)
                        if not bestPos then
                            bestPos = targetPos
                        end
                        
                        local success = PlaceUnit(cheapestSlot, bestPos)
                        if success then
                            DebugPrint(string.format("✅ วาง %s สำเร็จสำหรับ %s (ID: %d)!", 
                                cheapestUnit.Name, staticEnemy.Name, correctEntityIdNumber))
                            
                            -- ⭐⭐⭐ FIX: อัพเดท count ทันทีหลังวาง (ก่อนรอ) - ใช้ correctEntityId
                            ClearEnemyPlacedCount[correctEntityId] = (ClearEnemyPlacedCount[correctEntityId] or 0) + 1
                            local currentPlacedCount = ClearEnemyPlacedCount[correctEntityId]
                            DebugPrint(string.format("🎯 บันทึก ClearEnemy #%d/%d: %s สำหรับ %s (ID: %d)", 
                                currentPlacedCount, CLEAR_ENEMY_MAX_UNITS, cheapestUnit.Name, staticEnemy.Name, correctEntityIdNumber))
                            
                            task.wait(0.3)
                            local activeUnits = GetActiveUnits()
                            local placed = false
                            
                            -- ⭐⭐⭐ FIX: หาเฉพาะตัวที่ชื่อตรงกับ cheapestUnit.Name + ตำแหน่งใกล้ + ไม่เคยบันทึกแล้ว
                            for _, unit in pairs(activeUnits) do
                                local isMatch = (unit.Name == cheapestUnit.Name)  -- ✅ ชื่อตรง
                                local isNearby = unit.Position and (unit.Position - bestPos).Magnitude < 5  -- ✅ ใกล้ตำแหน่งที่วาง
                                local notTracked = not ClearEnemyUnits[unit.GUID]  -- ✅ ไม่เคยบันทึกแล้ว
                                
                                if isMatch and isNearby and notTracked then
                                    ClearEnemyUnits[unit.GUID] = correctEntityId  -- ใช้ ID ที่ถูกต้อง
                                    
                                    -- ⭐⭐⭐ FIX: ตั้ง Priority เป็น "Closest" สำหรับ ClearEnemy Units (ตาม Decom.lua)
                                    task.wait(0.1)  -- รอให้ unit spawn เสร็จ
                                    
                                    local prioritySuccess = SetPriority(unit, "Closest")
                                    if prioritySuccess then
                                        DebugPrint(string.format("🎯 [ClearEnemy] Priority: %s → Closest (Target ID: %d)", 
                                            unit.Name, correctEntityIdNumber))
                                    else
                                        DebugPrint(string.format("⚠️ [ClearEnemy] ไม่สามารถตั้ง Priority: %s", unit.Name))
                                    end
                                    
                                    -- ⭐⭐⭐ FIX: อัพเกรด unit ที่วาง + Log อัพเดท
                                    task.wait(0.1)
                                    
                                    -- เช็ค level ก่อนอัพเกรด
                                    local beforeLevel = GetCurrentUpgradeLevel(unit)
                                    local maxLevel = GetMaxUpgradeLevel(unit)
                                    
                                    local cost = GetUpgradeCost(unit)
                                    if cost < math.huge and GetYen() >= cost then
                                        local success = UpgradeUnit(unit)
                                        if success then
                                            -- ⭐ อัพเดท level หลังอัพเกรด
                                            task.wait(0.1)
                                            local afterLevel = GetCurrentUpgradeLevel(unit)
                                            
                                            DebugPrint(string.format("⬆️ อัพเกรด ClearEnemy: %s [Lv.%d → Lv.%d/%d] (Cost: %d)", 
                                                unit.Name, beforeLevel, afterLevel, maxLevel, cost))
                                        else
                                            DebugPrint(string.format("❌ อัพเกรดล้มเหลว: %s (Cost: %d, Yen: %d)", 
                                                unit.Name, cost, GetYen()))
                                        end
                                    else
                                        DebugPrint(string.format("💰 ไม่มีเงินอัพเกรด: %s (ต้องการ: %d, มี: %d)", 
                                            unit.Name, cost, GetYen()))
                                    end
                                    
                                    placed = true
                                    break
                                end
                            end
                            
                            if not placed then
                                DebugPrint(string.format("⚠️ ไม่พบ %s ที่ตำแหน่ง (%.1f, %.1f, %.1f) ในระยะ 5 studs", 
                                    cheapestUnit.Name, bestPos.X, bestPos.Y, bestPos.Z))
                            end
                            
                            -- ⭐ วางสำเร็จแล้ว → reset flag เพื่อให้ขายต่อได้สำหรับ enemy ตัวอื่น
                            ClearEnemySoldForEnemy[staticEnemy.EntityId] = nil
                            ClearEnemySlotFullLogged[staticEnemy.EntityId] = nil
                            ClearEnemyFoundDamageLogged[staticEnemy.EntityId] = nil
                            
                            -- ⭐⭐⭐ FIX: วางครบ LIMIT แล้ว → break ออกจาก loop ทันที
                            local currentPlaced = ClearEnemyPlacedCount[staticEnemy.EntityId] or 0
                            if currentPlaced >= CLEAR_ENEMY_MAX_UNITS then
                                DebugPrint(string.format("✅ วางครบ %d/%d ตัวแล้วสำหรับ %s → หยุดวาง", 
                                    currentPlaced, CLEAR_ENEMY_MAX_UNITS, staticEnemy.Name))
                                break  -- ⭐ ออกจาก for staticEnemy loop
                            end
                        else
                            DebugPrint(string.format("❌ วาง %s ล้มเหลว!", cheapestUnit.Name))
                            -- ⭐ วางล้มเหลว → reset flag เพื่อให้ลองขายใหม่ได้
                            ClearEnemySoldForEnemy[staticEnemy.EntityId] = nil
                            ClearEnemyFoundDamageLogged[staticEnemy.EntityId] = nil
                        end
                        end  -- end if not skipThisEnemy (inner)
                    end
                end  -- end if not skipThisEnemy (outer)
            end  -- end if not alreadyPlaced
        end  -- end for staticEnemy
        
        -- ⭐⭐⭐ FIX: เช็คว่า Static Enemy ไหนตายแล้ว (Health = 0 จริงๆ)
        -- ขายเฉพาะ ClearEnemy Unit ที่วางเพื่อ enemy ตัวนั้น
        local guidsToRemove = {}  -- ⭐⭐ เก็บ GUID ที่จะลบ (ไม่ลบขณะ iterate)
        
        for guid, enemyId in pairs(ClearEnemyUnits) do
            local enemyDead = false  -- ⭐⭐⭐ FIX: Default = false (ยังไม่ตาย)
            local enemyFound = false
            local currentHealth = 0
            local currentMaxHealth = 0
            
            -- เช็คว่า enemy ยังมีอยู่ไหม
            if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
                for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                    if enemy and tostring(enemy.UniqueIdentifier) == enemyId then
                        enemyFound = true
                        -- Enemy ยังอยู่ → เช็ค HP
                        currentHealth = enemy.Health or (enemy.Data and enemy.Data.Health) or 0
                        currentMaxHealth = enemy.MaxHealth or (enemy.Data and enemy.Data.MaxHealth) or 1
                        
                        -- ⭐⭐⭐ FIX: ตายจริงๆ เมื่อ Health <= 0 เท่านั้น
                        if currentHealth <= 0 then
                            enemyDead = true
                        else
                            enemyDead = false
                        end
                        break
                    end
                end
            end
            
            -- ⭐⭐⭐ FIX: ถ้าไม่เจอ enemy ใน _ActiveEnemies แปลว่าหายไป (ตายแล้ว)
            if not enemyFound then
                enemyDead = true
                -- Log เฉพาะครั้งแรก (ป้องกัน spam)
                if not _G.LoggedEnemyNotFound then _G.LoggedEnemyNotFound = {} end
                if not _G.LoggedEnemyNotFound[enemyId] then
                    DebugPrint(string.format("🔍 ClearEnemy Check: Enemy ID %s ไม่เจอใน _ActiveEnemies → ตายแล้ว", enemyId))
                    _G.LoggedEnemyNotFound[enemyId] = true
                end
            else
                -- Log เฉพาะเมื่อ HP เปลี่ยนแปลงอย่างมีนัยสำคัญ (ลด spam)
                local lastHP = _G.LastEnemyHP or {}
                local hpKey = enemyId .. "_hp"
                local lastValue = lastHP[hpKey] or currentHealth
                local hpChanged = math.abs(currentHealth - lastValue) > (currentMaxHealth * 0.1)  -- เปลี่ยน > 10%
                
                if hpChanged or enemyDead then
                    DebugPrint(string.format("🔍 ClearEnemy Check: Enemy ID %s มี HP = %.0f/%.0f (ตาย: %s)", 
                        enemyId, currentHealth, currentMaxHealth, tostring(enemyDead)))
                    lastHP[hpKey] = currentHealth
                    _G.LastEnemyHP = lastHP
                end
            end
            
            -- ถ้า enemy ตายแล้ว (HP = 0 หรือหายไปจาก _ActiveEnemies) → ขาย unit นั้น
            if enemyDead then
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    local clearUnit = ClientUnitHandler._ActiveUnits[guid]
                    if clearUnit then
                        local unitWrapper = {
                            GUID = guid,
                            Name = clearUnit.Name,
                            CanSell = true
                        }
                        
                        if SellUnit(unitWrapper) then
                            DebugPrint(string.format("💀 Static Enemy ตาย (HP: %.0f/%.0f) → ขาย ClearEnemy Unit: %s", 
                                currentHealth, currentMaxHealth, clearUnit.Name))
                            table.insert(guidsToRemove, guid)  -- ⭐⭐ บันทึกว่าจะลบ
                            
                            -- ⭐ ลบ tracking flags
                            if ClearEnemySoldForEnemy then ClearEnemySoldForEnemy[enemyId] = nil end
                            if ClearEnemySlotFullLogged then ClearEnemySlotFullLogged[enemyId] = nil end
                            if ClearEnemyFoundDamageLogged then ClearEnemyFoundDamageLogged[enemyId] = nil end
                        end
                    else
                        -- Unit หายไปแล้ว → บันทึกว่าจะลบ
                        table.insert(guidsToRemove, guid)
                    end
                end
            end
        end
        
        -- ⭐⭐ ลบ GUID ทั้งหมดที่บันทึกไว้ (หลังจาก loop เสร็จ)
        for _, guid in ipairs(guidsToRemove) do
            ClearEnemyUnits[guid] = nil
        end
    else
        -- ✅ ไม่มี Static Enemy แล้ว → ขาย ClearEnemy Units ทั้งหมด + รีเซ็ตการติดตาม
        if next(ClearEnemyUnits) then
            local soldCount = 0
            for guid, _ in pairs(ClearEnemyUnits) do
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    local clearUnit = ClientUnitHandler._ActiveUnits[guid]
                    if clearUnit then
                        local unitWrapper = {
                            GUID = guid,
                            Name = clearUnit.Name,
                            CanSell = true
                        }
                        
                        if SellUnit(unitWrapper) then
                            soldCount = soldCount + 1
                            DebugPrint(string.format("💸 ขาย ClearEnemy Unit: %s", clearUnit.Name))
                        end
                    end
                end
            end
            
            if soldCount > 0 then
                ClearEnemyUnits = {}
                ClearEnemySoldForEnemy = {}  -- ✅ รีเซ็ตการติดตาม
                ClearEnemyNoMoreSellable = false  -- ✅ รีเซ็ต global flag
                ClearEnemySlotFullLogged = {}  -- ✅ รีเซ็ต log tracking
                ClearEnemyFoundDamageLogged = {}  -- ✅ รีเซ็ต log tracking
                DebugPrint(string.format("✅ Static Enemy หมดแล้ว - ขาย ClearEnemy Units %d ตัว", soldCount))
            end
        end
    end
end

-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                 AUTO SKILL SYSTEM V6.0 (INTEGRATED)                    ║
-- ║  ระบบใช้ Ability อัตโนมัติ - 100% Data-Driven (NO HARDCODE!)          ║
-- ║  รวมเข้ากับ AutoPlace_Test_fixed.lua                                   ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- ===== AUTO SKILL MODULES =====
local ActiveAbilityData = nil
local AbilityEvent = nil
local UnitsData = nil  -- สำหรับดึงข้อมูล DPS จริง

local function LoadAutoSkillModules()
    -- โหลด ActiveAbilityData (สำหรับวิเคราะห์ ability)
    pcall(function()
        ActiveAbilityData = require(ReplicatedStorage.Modules.Data.ActiveAbilityData)
    end)
    
    -- โหลด Units Data (สำหรับดึง DPS/Stats จริง)
    pcall(function()
        UnitsData = require(ReplicatedStorage.Modules.Data.Entities.Units)
    end)
    
    -- โหลด AbilityEvent (สำหรับกด ability)
    print("[FORCED] 🔧 Loading AbilityEvent...")
    AbilityEvent = Networking:FindFirstChild("AbilityEvent")
    print(string.format("[FORCED]   → AbilityEvent: %s", AbilityEvent and "✅ Found" or "❌ NIL"))
end

LoadAutoSkillModules()

-- ===== PLACEMENT ZONE ANALYSIS =====
local PlacementZoneCache = {}
local StageAnalysisCache = {}

-- ⭐⭐⭐ CHECK: เช็คว่าเป็น Normal Mode หรือไม่ (ไม่ใช่ Challenge/Odyssey/Worldlines)
local function IsNormalMode()
    -- เช็คจาก workspace attributes
    local isChallenge = workspace:GetAttribute("IsChallenge") or false
    local isOdyssey = workspace:GetAttribute("IsOdyssey") or false
    local isWorldlines = workspace:GetAttribute("IsWorldlines") or false
    local isPortal = workspace:GetAttribute("IsPortal") or false
    
    -- ถ้าไม่ใช่ mode พิเศษใดๆ = Normal Mode
    return not isChallenge and not isOdyssey and not isWorldlines and not isPortal
end

-- วิเคราะห์ประเภทของด่าน
local function AnalyzeStageType()
    if StageAnalysisCache.Type then
        return StageAnalysisCache.Type
    end
    
    GetWaveFromUI()
    
    local stageInfo = {
        Type = "Normal",  -- Normal, Boss, Raid, Challenge, Story
        MaxWave = MaxWave or 50,
        HasBoss = false,
        IsLongStage = false,
        IsShortStage = false,
        RequiresRepulse = false,
        RequiresDPS = true,
        IsNormalMode = IsNormalMode()  -- ⭐ เพิ่ม flag
    }
    
    -- เช็คจาก MaxWave
    if stageInfo.MaxWave >= 50 then
        stageInfo.IsLongStage = true
    elseif stageInfo.MaxWave <= 30 then
        stageInfo.IsShortStage = true
    end
    
    -- เช็ค Boss Stage (จากชื่อด่านหรือ enemy)
    local enemies = GetEnemies and GetEnemies() or nil
    if enemies and IsBossEnemy then
        for _, enemy in pairs(enemies) do
            if IsBossEnemy(enemy) then
                stageInfo.HasBoss = true
                stageInfo.Type = "Boss"
                break
            end
        end
    end
    
    -- Cache ไว้
    StageAnalysisCache.Type = stageInfo.Type
    StageAnalysisCache.Info = stageInfo
    
    DebugPrint(string.format("🗺️ Stage Analysis: Type=%s, MaxWave=%d, Boss=%s", 
        stageInfo.Type, 
        stageInfo.MaxWave,
        tostring(stageInfo.HasBoss)
    ))
    
    return stageInfo
end

-- หา DPS จริงจาก Units Data (ไม่ใช้ Rarity)
local function GetUnitRealDPS(unitName, unitLevel)
    if not UnitsData then return 0 end
    
    local unitData = nil
    pcall(function()
        unitData = UnitsData:RetrieveUnitData(unitName)
    end)
    
    if not unitData then return 0 end
    
    -- คำนวณ DPS จริง
    local baseDPS = unitData.Damage or 0
    local attackSpeed = unitData.Cooldown or 1
    local actualDPS = baseDPS / attackSpeed
    
    -- เพิ่ม level scaling
    local levelMultiplier = 1 + ((unitLevel or 1) * 0.05)
    local finalDPS = actualDPS * levelMultiplier
    
    return finalDPS
end

-- ตรวจสอบว่า unit เป็น Repulse หรือไม่
local function IsRepulseUnit(unitName)
    if not UnitsData then return false end
    
    local repulseUnits = {
        "Friezo",
        "Doby",
        -- เพิ่ม units อื่นที่มี Repulse/Knockback
    }
    
    for _, repulseName in ipairs(repulseUnits) do
        if unitName:find(repulseName) then
            return true
        end
    end
    
    -- เช็คจาก data
    local unitData = nil
    pcall(function()
        unitData = UnitsData:RetrieveUnitData(unitName)
    end)
    
    if unitData and unitData.Abilities then
        for _, ability in ipairs(unitData.Abilities) do
            if ability:find("Repulse") or ability:find("Knockback") or ability:find("Push") then
                return true
            end
        end
    end
    
    return false
end

-- วิเคราะห์ placement zones
local function AnalyzePlacementZones()
    if PlacementZoneCache.Analyzed then
        return PlacementZoneCache
    end
    
    local zones = {
        Repulse = {},      -- สีฟ้าเข้ม (Dark Blue)
        Forbidden = {},    -- สีส้ม (Orange)
        Normal = {},       -- สีขาว (White)
        DPS = {}          -- สีแดง (Red)
    }
    
    -- TODO: ดึงข้อมูล placement zones จากแผนที่
    -- ตอนนี้ใช้ FindBestPlacementPosition() แทน
    
    PlacementZoneCache = zones
    PlacementZoneCache.Analyzed = true
    
    return zones
end

-- ===== AUTO SKILL STATE =====
local AutoSkillEnabled = {}       -- {GUID = true} - Units ที่เปิด Auto Skill แล้ว
_G.APSkill = {
    AbilityLastUsed = {},
    AbilityUsedOnce = {},
    AbilityAnalysisCache = {},
    LastAutoSkillCheck = 0,
    AUTO_SKILL_CHECK_INTERVAL = 0.1,
    WorldItemUsedThisMatch = false,
}
local AbilityLastUsed = _G.APSkill.AbilityLastUsed
local AbilityUsedOnce = _G.APSkill.AbilityUsedOnce
local AbilityAnalysisCache = _G.APSkill.AbilityAnalysisCache
local LastAutoSkillCheck = 0
local AUTO_SKILL_CHECK_INTERVAL = 0.1

-- ===== WAVE CHECKING (สำหรับ MinWave) =====
GetCurrentWaveForSkill = function()
    GetWaveFromUI()
    return CurrentWave
end

-- ===== ABILITY ANALYSIS (100% DATA-DRIVEN) =====
--[[
    วิเคราะห์ ability จาก ActiveAbilityData โดยอัตโนมัติ
    คืนค่า:
    {
        Name = string,
        Cooldown = number,
        IsOneTime = boolean,      -- ใช้ได้ครั้งเดียวต่อด่าน
        IsBossOnly = boolean,     -- ใช้กับ Boss เท่านั้น
        MinWave = number,         -- ต้องถึง wave นี้ถึงใช้ได้
        NeedsTarget = boolean,    -- ต้อง target หรือไม่
        Type = string,            -- "Damage", "Buff", "Summon", "Utility", etc.
    }
]]
local function AnalyzeAbility(abilityName)
    -- เช็ค cache ก่อน
    if AbilityAnalysisCache[abilityName] then
        return AbilityAnalysisCache[abilityName]
    end
    
    local abilityInfo = {
        Name = abilityName,
        Cooldown = 3,           -- ⏱️ Default 3 วินาที (เพิ่มจาก 1 เป็น 3 เพื่อป้องกัน spam)
        IsOneTime = false,
        IsBossOnly = false,
        MinWave = 0,
        NeedsTarget = false,
        Type = "Unknown",
        -- ⭐ NEW: Placement-related fields (auto-detected)
        NeedsPlacement = false,     -- ต้องเลือกตำแหน่งวาง (เช่น Instant Teleportation)
        NeedsUnitSelection = false, -- ต้องเลือก unit เป้าหมาย (เช่น Caloric Stone)
        PlacementRange = 30,        -- Range สำหรับหาตำแหน่ง
        SelectionContext = nil,     -- Context สำหรับ selection (SelectUnit, EquipForgeWeapon, etc.)
    }
    
    
    -- ดึงข้อมูลจาก ActiveAbilityData
    if ActiveAbilityData and ActiveAbilityData.GetActiveAbilityDataFromName then
        local success, data = pcall(function()
            return ActiveAbilityData:GetActiveAbilityDataFromName(abilityName)
        end)
        
        if success and data then
            -- Cooldown (ใช้อย่างน้อย 2 วินาที เพื่อป้องกัน spam)
            if data.Cooldown then
                abilityInfo.Cooldown = math.max(data.Cooldown, 2)
            end
            
            -- IsOneTime (ใช้ได้ครั้งเดียว)
            if data.OneTime or data.IsOneTime or data.SingleUse then
                abilityInfo.IsOneTime = true
            end
            
            -- IsBossOnly
            if data.BossOnly or data.Boss or data.RequiresBoss then
                abilityInfo.IsBossOnly = true
            end
            
            -- MinWave
            if data.MinWave or data.WaveRequirement then
                abilityInfo.MinWave = data.MinWave or data.WaveRequirement
            end
            
            -- NeedsTarget
            if data.NeedsTarget or data.RequiresTarget or data.TargetRequired then
                abilityInfo.NeedsTarget = true
            end
            
            -- Type (วิเคราะห์จาก Description หรือ Tags)
            if data.Type then
                abilityInfo.Type = data.Type
            elseif data.Description then
                local desc = data.Description:lower()
                if desc:find("damage") or desc:find("attack") or desc:find("deals") then
                    abilityInfo.Type = "Damage"
                elseif desc:find("buff") or desc:find("increase") or desc:find("boost") then
                    abilityInfo.Type = "Buff"
                elseif desc:find("summon") or desc:find("spawn") or desc:find("arise") then
                    abilityInfo.Type = "Summon"
                elseif desc:find("heal") or desc:find("restore") then
                    abilityInfo.Type = "Heal"
                elseif desc:find("stun") or desc:find("slow") or desc:find("freeze") then
                    abilityInfo.Type = "CC"
                else
                    abilityInfo.Type = "Utility"
                end
            end
            
            -- ⭐ NEW: ตรวจสอบ Placement Requirements จาก data
            if data.NeedsPlacement or data.RequiresPlacement or data.NeedsPosition then
                abilityInfo.NeedsPlacement = true
            end
            if data.NeedsUnitSelection or data.RequiresUnitSelection or data.SelectUnit then
                abilityInfo.NeedsUnitSelection = true
            end
            if data.PlacementRange or data.Range then
                abilityInfo.PlacementRange = data.PlacementRange or data.Range
            end
            if data.SelectionContext then
                abilityInfo.SelectionContext = data.SelectionContext
            end
        end
    end
    
    -- ⭐ AUTO-DETECT: ตรวจสอบจากชื่อ ability เพื่อระบุ placement requirements
    local abilityLower = abilityName:lower()
    
    -- Abilities ที่ต้อง PLACEMENT (วางตำแหน่ง)
    local placementKeywords = {
        "teleport", "warp", "blink", "portal",          -- Teleport abilities
        "spawn", "summon", "arise", "army",             -- Summon abilities
        "clone", "duplicate", "copy",                   -- Clone abilities
        "place", "deploy", "position",                  -- Placement abilities
        "dimension", "zone", "area"                     -- Zone creation
    }
    
    for _, keyword in ipairs(placementKeywords) do
        if abilityLower:find(keyword) then
            abilityInfo.NeedsPlacement = true
            break
        end
    end
    
    -- Abilities ที่ต้อง UNIT SELECTION (เลือก unit เป้าหมาย)
    local selectionKeywords = {
        "buff", "enhance", "empower",                   -- Buff abilities
        "transfer", "give", "grant",                    -- Transfer abilities
        "equip", "forge", "masterwork", "craft",        -- Equipment abilities
        "caloric", "stone"                              -- Caloric Stone specific
    }
    
    for _, keyword in ipairs(selectionKeywords) do
        if abilityLower:find(keyword) then
            abilityInfo.NeedsUnitSelection = true
            break
        end
    end
    
    -- ⭐⭐⭐ FULLY AUTOMATIC - ไม่ต้อง hardcode ability names
    -- ใช้ default cooldown = 1.0s สำหรับทุก ability (เร็วขึ้น)
    -- ระบบจะ detect placement/selection จาก keywords อัตโนมัติ (ด้านบน)
    if not abilityInfo.Cooldown or abilityInfo.Cooldown > 1.0 then
        abilityInfo.Cooldown = 1.0  -- Default cooldown for all abilities (เร็วขึ้น)
    end
    abilityInfo.IsAutoAbility = true  -- ทุก ability เป็น auto
    
    -- Cache ผลลัพธ์
    AbilityAnalysisCache[abilityName] = abilityInfo
    
    
    -- 📊 Log เฉพาะครั้งแรกที่วิเคราะห์ (cache miss)
    if DEBUG then
        DebugPrint(string.format("📊 [Ability] %s: CD=%.1fs, OneTime=%s, MinWave=%d",
            abilityName,
            abilityInfo.Cooldown,
            tostring(abilityInfo.IsOneTime),
            abilityInfo.MinWave
        ))
    end
    
    return abilityInfo
end

-- ===== ABILITY USAGE CONDITIONS =====
local function CanUseAbility(unit, abilityName, abilityInfo)
    local guid = unit.UniqueIdentifier or unit.GUID
    local abilityKey = guid .. "_" .. abilityName
    local unitName = unit.Name or ""
    
    
    -- 0. เช็คเงื่อนไขพิเศษตามชื่อ ability (จาก wiki/decom)
    
    -- Koguro Dimensions: Toggle ability
    if unitName:find("Koguro") and abilityName:find("Dimension") then
        return true, "OK"
    end
    
    -- Arcane Knowledge (Lich): ไม่มีเงื่อนไข wave หรือ boss
    if unitName:find("Lich") and abilityName:find("Arcane Knowledge") then
        return true, "OK"
    end
    
    -- The Goal of All Life is Death (Lich): Starting Uses = 1 (OneTime)
    -- ไม่ต้องเช็ค wave - ใช้ได้ทันที แต่ต้องมี Boss หรือ Critical Wave
    if abilityName:find("The Goal of All Life is Death") then
        -- เช็คว่าใช้ไปแล้วหรือยัง
        if AbilityUsedOnce[abilityKey] then
            return false, "Already used (Starting Uses = 1)"
        end
        
        -- OneTime ability ควรใช้กับ Boss หรือ Critical Situation
        local enemies = GetEnemies and GetEnemies() or {}
        local hasBoss = false
        local currentWave = GetCurrentWaveForSkill()
        local isCriticalWave = (currentWave >= 45)  -- Wave 45+ = Critical
        
        -- ⭐ FIX: เช็คว่า IsBossEnemy ถูก define แล้ว
        if IsBossEnemy then
            for _, enemy in pairs(enemies) do
                if IsBossEnemy(enemy) then
                    hasBoss = true
                    break
                end
            end
        end
        
        if not hasBoss and not isCriticalWave then
            return false, "Wait for Boss or Critical Wave (45+)"
        end
    end
    
    -- Reality Rewrite: OneTime ability - ใช้ได้ทันทีเมื่อมี enemy (ไม่ต้องรอ Boss)
    if abilityName:find("Reality Rewrite") then
        if AbilityUsedOnce[abilityKey] then
            return false, "Already used (OneTime)"
        end
        
        -- ⭐ FIX: ใช้ได้ทันทีเมื่อมี enemy (ไม่ต้องรอ Boss หรือ Critical Wave)
        local enemies = GetEnemies and GetEnemies() or {}
        if #enemies == 0 then
            return false, "No enemies found"
        end
        
    end
    
    -- World Items: ต้องมี items ในคลัง
    if abilityName:find("World Item") then
        -- ไม่สามารถเช็คได้จาก client - ให้เกมเช็คเอง
        -- แต่ต้องมี cooldown ไม่ให้ spam
    end
    
    -- Horsegirl Racing: ต้องมี Actions เหลืออยู่
    if unitName:find("Horsegirl") and abilityName:find("Racing") then
        if unit.HorsegirlActions and unit.HorsegirlActions <= 0 then
            return false, "No actions left"
        end
    end
    
    -- Reality Rewrite: OneTime ability
    if abilityName:find("Reality Rewrite") then
        if AbilityUsedOnce[abilityKey] then
            return false, "Already used (OneTime)"
        end
    end
    
    -- ⭐⭐⭐ God Arrives: ใช้ตอนกลางๆเกม (ไม่ใช่ช่วงแรก)
    -- ช่วงแรก: Equip ธาตุ (Arcane Knowledge) เท่านั้น
    -- ช่วงกลาง-ท้าย: ใช้ God Arrives ตาม cooldown
    if abilityName:find("God Arrives") then
        local currentWave, maxWave = GetWaveFromUI()
        local waveProgress = 0
        if maxWave and maxWave > 0 then
            waveProgress = (currentWave or 0) / maxWave
        end
        
        -- ⭐ ใช้ได้เมื่อ wave > 20% (กลางๆเกม)
        if waveProgress < 0.2 then
            return false, "God Arrives - รอช่วงกลางเกม (wave > 20%)"
        end
    end
    
    -- 1. เช็ค OneTime (ใช้ไปแล้วหรือยัง)
    if abilityInfo.IsOneTime and AbilityUsedOnce[abilityKey] then
        return false, "Already used (OneTime)"
    end
    
    -- ⭐⭐⭐ FIX: OneTime abilities ต้องใช้กับ Boss เท่านั้น
    -- ยกเว้น Reality Rewrite ที่ใช้ได้ทันที
    if abilityInfo.IsOneTime and not abilityName:find("Reality Rewrite") then
        local enemies = GetEnemies and GetEnemies() or {}
        local hasBoss = false
        
        if IsBossEnemy then
            for _, enemy in pairs(enemies) do
                if IsBossEnemy(enemy) then
                    hasBoss = true
                    break
                end
            end
        end
        
        if not hasBoss then
            return false, "OneTime ability - Wait for Boss"
        end
    end
    
    -- 2. เช็ค Cooldown (ไม่มี buffer - ใช้ cooldown จริงเท่านั้น)
    local lastUsed = AbilityLastUsed[abilityKey] or 0
    local elapsed = tick() - lastUsed
    local effectiveCooldown = abilityInfo.Cooldown  -- ⭐ ไม่มี buffer
    if elapsed < effectiveCooldown then
        return false, string.format("Cooldown (%.1fs left)", effectiveCooldown - elapsed)
    end
    
    -- ⭐⭐⭐ SKIP: ไม่เช็ค MinWave และ BossOnly - ให้ทุก ability ทำงานทันที
    -- เฉพาะ ability ที่ระบุไว้ชัดเจนเท่านั้นที่จะเช็ค (เช่น God Arrives ด้านบน)
    
    -- ✅ ผ่านทุกเงื่อนไข
    return true, "OK"
end

-- ===== SPECIAL ABILITY HANDLERS (ใช้ _G เพื่อลด register) =====
_G.APEvents = {
    KoguroDimensionEvent = nil,
    HorsegirlRacingEvent = nil,
    WorldItemEvent = nil,
    CaloricStoneEvent = nil,
    NumberPadEvent = nil,
    LichSpellsEvent = nil,
    RealityRewriteEvent = nil,
    LichData = nil,
    UnitElementsData = nil,
    RealityRewriteData = nil,
}
local KoguroDimensionEvent, HorsegirlRacingEvent, WorldItemEvent, CaloricStoneEvent, NumberPadEvent
local LichSpellsEvent, RealityRewriteEvent, LichData, UnitElementsData, RealityRewriteData

-- Track states (รวมใน _G เพื่อลด register)
_G.APEvents.KoguroAutoEnabled = {}
_G.APEvents.LastSelectedSpells = {}
_G.APEvents.AutoSwapEnabled = {}
_G.APEvents.AUTO_SWAP_UNITS = {
    ["Roku (Super 3)"] = {SwapTo = "Vogita (Angel)", AttributeName = "AutoSwap_Roku"},
    ["Vogita (Angel)"] = {SwapTo = "Roku (Super 3)", AttributeName = "AutoSwap_Roku"},
    ["Smith John"] = {SwapTo = "Lord of Shadows", AttributeName = "AutoSwap_Cid"},
    ["Lord of Shadows"] = {SwapTo = "Smith John", AttributeName = "AutoSwap_Cid"},
}
local KoguroAutoEnabled = _G.APEvents.KoguroAutoEnabled
local LastSelectedSpells = _G.APEvents.LastSelectedSpells
local AUTO_SWAP_UNITS = _G.APEvents.AUTO_SWAP_UNITS
local AutoSwapEnabled = _G.APEvents.AutoSwapEnabled

local function LoadSpecialAbilityEvents()
    -- Koguro Dimensions (Koguro_DomainEvent ตาม decom)
    local koguroSuccess, koguroErr = pcall(function()
        print("[FORCED] 🔧 Loading Koguro Domain Event...")
        KoguroDimensionEvent = Networking.Units["Update 6.5"].Koguro_DomainEvent
        print(string.format("[FORCED]   → KoguroDimensionEvent: %s", KoguroDimensionEvent and "✅ Found" or "❌ NIL"))
        
        -- Listen for Auto Status changes (ตาม decom)
        if KoguroDimensionEvent then
            KoguroDimensionEvent.OnClientEvent:Connect(function(action, ...)
                print(string.format("[FORCED] 🔔 Koguro Event: action=%s", tostring(action)))
                
                if action == "SetAutoEnabled" then
                    local args = {...}
                    local autoEnabled = args[1]  -- autoEnabled is first arg after action
                    print(string.format("[FORCED]   → Auto Enabled: %s", tostring(autoEnabled)))
                    -- Note: decom ไม่มี guid parameter - auto applies to current Koguro
                end
            end)
        end
    end)
    
    if not koguroSuccess then
        print(string.format("[FORCED]   → ❌ Koguro loading failed: %s", tostring(koguroErr)))
    end
    
    -- Horsegirl Racing
    pcall(function()
        HorsegirlRacingEvent = Networking.Units["Update 9.5"].AutoUpgradeHorsegirl
    end)
    
    -- ⭐⭐⭐ NEW: Horsegirl Selection Event (สำหรับเลือก Horsegirl ใน GUI)
    local HorsegirlSelectEvent = nil
    pcall(function()
        HorsegirlSelectEvent = Networking.Units["Update 9.5"].SelectHorsegirl or
                              Networking.Units.SelectHorsegirl or
                              Networking.ClientListeners.Units.HorsegirlSelect
    end)
    
    -- ⭐⭐⭐ NEW: Auto Swap Events (Roku/Vogita, Smith John/Lord of Shadows)
    local RequestSwapEvent = nil
    local ToggleAutoSwapEvent = nil
    pcall(function()
        RequestSwapEvent = Networking.Passives.RequestSwap
        ToggleAutoSwapEvent = Networking.Passives.ToggleAutoSwapEvent
        print(string.format("[FORCED]   → RequestSwapEvent: %s", RequestSwapEvent and "✅ Found" or "❌ NIL"))
        print(string.format("[FORCED]   → ToggleAutoSwapEvent: %s", ToggleAutoSwapEvent and "✅ Found" or "❌ NIL"))
    end)
    
    -- ⭐ Store globally for use in other functions
    _G.HorsegirlSelectEvent = HorsegirlSelectEvent
    _G.RequestSwapEvent = RequestSwapEvent
    _G.ToggleAutoSwapEvent = ToggleAutoSwapEvent
    
    -- ⭐⭐⭐ NEW: AutoAbility Event (สำหรับ ToggleAuto)
    local AutoAbilityEvent = nil
    pcall(function()
        AutoAbilityEvent = Networking.ClientListeners.Units.AutoAbilityEvent or
                          Networking.Units.AutoAbilityEvent
        print(string.format("[FORCED]   → AutoAbilityEvent: %s", AutoAbilityEvent and "✅ Found" or "❌ NIL"))
    end)
    _G.AutoAbilityEvent = AutoAbilityEvent
    
    -- World Items
    pcall(function()
        WorldItemEvent = Networking.Units["Update 9.5"].UseWorldItem
    end)
    
    -- Caloric Stone (แยกจาก World Items)
    pcall(function()
        CaloricStoneEvent = Networking.Units["Update 9.5"].CaloricStone or
                           Networking.Units.CaloricStone
    end)
    
    -- ⭐⭐⭐ NumberPad Event (สำหรับ Imprisoned Island)
    pcall(function()
        NumberPadEvent = Networking.StageMechanics.NumberPad
        print(string.format("[FORCED]   → NumberPadEvent: %s", NumberPadEvent and "✅ Found" or "❌ NIL"))
    end)
    
    -- ⭐⭐⭐ Auto Replay/Next Event (EndScreen.VoteEvent)
    pcall(function()
        _G.VoteEvent = Networking.EndScreen.VoteEvent
        print(string.format("[FORCED]   → VoteEvent: %s", _G.VoteEvent and "✅ Found" or "❌ NIL"))
    end)
    
    -- ⭐⭐⭐ Portal Play Event (สำหรับ Auto Portal)
    pcall(function()
        _G.PortalPlayEvent = Networking.PortalPlayEvent
        print(string.format("[FORCED]   → PortalPlayEvent: %s", _G.PortalPlayEvent and "✅ Found" or "❌ NIL"))
    end)
    
    -- ⭐⭐⭐ Teleport Event (สำหรับ Leave/Lobby)
    pcall(function()
        _G.TeleportEvent = Networking.TeleportEvent
        print(string.format("[FORCED]   → TeleportEvent: %s", _G.TeleportEvent and "✅ Found" or "❌ NIL"))
    end)
    
    -- Lich Spells (Arcane Knowledge) - Element Selection
    local lichSuccess, lichErr = pcall(function()
        print("[FORCED] 🔧 Loading Lich Spells...")
        LichSpellsEvent = Networking.Units["Update 9.5"].ConfirmLichSpells
        print(string.format("[FORCED]   → LichSpellsEvent: %s", LichSpellsEvent and "✅ Found" or "❌ NIL"))
        
        LichData = require(ReplicatedStorage.Modules.Data.Units.LichData)
        print(string.format("[FORCED]   → LichData: %s", LichData and "✅ Loaded" or "❌ NIL"))
        
        UnitElementsData = require(ReplicatedStorage.Modules.Data.Entities.UnitElementsData)
        print(string.format("[FORCED]   → UnitElementsData: %s", UnitElementsData and "✅ Loaded" or "❌ NIL"))
    end)
    
    if not lichSuccess then
        print(string.format("[FORCED]   → ❌ Lich loading failed: %s", tostring(lichErr)))
    end
    
    -- Reality Rewrite (ตาม decom)
    local rewriteSuccess, rewriteErr = pcall(function()
        print("[FORCED] 🔧 Loading Reality Rewrite...")
        RealityRewriteEvent = Networking.Units["Update 9.0"].RealityRewrite
        print(string.format("[FORCED]   → RealityRewriteEvent: %s", RealityRewriteEvent and "✅ Found" or "❌ NIL"))
        
        RealityRewriteData = require(ReplicatedStorage.Modules.Data.Units.RealityRewriteData)
        print(string.format("[FORCED]   → RealityRewriteData: %s", RealityRewriteData and "✅ Loaded" or "❌ NIL"))
        
        -- Log available statuses
        if RealityRewriteData and RealityRewriteData.Statuses then
            local statusList = {}
            for statusName, _ in pairs(RealityRewriteData.Statuses) do
                table.insert(statusList, statusName)
            end
            print(string.format("[FORCED]   → Available Statuses: %s", table.concat(statusList, ", ")))
        end
    end)
    
    if not rewriteSuccess then
        print(string.format("[FORCED]   → ❌ Reality Rewrite loading failed: %s", tostring(rewriteErr)))
    end
    
    -- 🔍 FORCED LOG: แสดงว่าโหลด events สำเร็จหรือไม่
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("[FORCED] 🔧 Special Ability Events Status:")
    print(string.format("[FORCED]   AbilityEvent (Main): %s", AbilityEvent and "✅" or "❌"))
    print(string.format("[FORCED]   Koguro: %s", KoguroDimensionEvent and "✅" or "❌"))
    print(string.format("[FORCED]   Horsegirl: %s", HorsegirlRacingEvent and "✅" or "❌"))
    print(string.format("[FORCED]   World Items: %s", WorldItemEvent and "✅" or "❌"))
    print(string.format("[FORCED]   Caloric Stone: %s", CaloricStoneEvent and "✅" or "❌"))
    print(string.format("[FORCED]   Lich Spells: %s", LichSpellsEvent and "✅" or "❌"))
    print(string.format("[FORCED]   LichData: %s", LichData and "✅" or "❌"))
    print(string.format("[FORCED]   UnitElementsData: %s", UnitElementsData and "✅" or "❌"))
    print(string.format("[FORCED]   Reality Rewrite: %s", RealityRewriteEvent and "✅" or "❌"))
    print(string.format("[FORCED]   RealityRewriteData: %s", RealityRewriteData and "✅" or "❌"))
    print(string.format("[FORCED]   VoteEvent (Replay): %s", _G.VoteEvent and "✅" or "❌"))
    print(string.format("[FORCED]   PortalPlayEvent: %s", _G.PortalPlayEvent and "✅" or "❌"))
    print(string.format("[FORCED]   TeleportEvent: %s", _G.TeleportEvent and "✅" or "❌"))
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

LoadSpecialAbilityEvents()

-- ===== ENEMY ANALYSIS FOR REALITY REWRITE =====
-- Fallback status list (ถ้า RealityRewriteData ไม่โหลด)
local REALITY_REWRITE_STATUSES = {
    "Burn",      -- DoT (30% for 8s)
    "Bleed",     -- DoT (30% for 8s)
    "Scorched",  -- 10 seconds
    "Freeze",    -- 2 seconds
    "Slow",      -- 50% for 10 seconds
    "Stun",      -- 2 seconds
    "Rupture",   -- Permanent
    "Wounded",   -- 10 seconds
    "Bubbled"    -- Permanent
}

local function AnalyzeEnemiesForStatus()
    -- วิเคราะห์ enemies ทั้งหมดเพื่อเลือก status ที่เหมาะสม
    -- รวมถึง passives, abilities, และ immunities ของ enemy
    local enemies = GetEnemies and GetEnemies() or {}
    if not enemies or #enemies == 0 then
        DebugPrint("🌈 [Reality Rewrite] No enemies found, using default: Burn")
        return "Burn"  -- Default
    end
    
    local analysis = {
        totalEnemies = 0,
        fastEnemies = 0,      -- Speed > 16
        tankEnemies = 0,       -- Health > 10000
        flyingEnemies = 0,     -- IsFlying
        slowEnemies = 0,       -- Speed < 10
        totalHealth = 0,
        avgSpeed = 0,
        avgHealth = 0,
        hasBoss = false,
        enemyCount = {
            fast = 0,
            tank = 0,
            flying = 0,
            slow = 0
        },
        -- ⭐ NEW: วิเคราะห์ passives/abilities/immunities ของ enemy
        immunities = {},       -- สิ่งที่ enemy immune
        weaknesses = {},       -- สิ่งที่ enemy อ่อนแอ
        currentStatuses = {},  -- status ที่ enemy มีอยู่แล้ว
        hasSlowImmunity = false,
        hasStunImmunity = false,
        hasBurnImmunity = false,
        hasFreezeImmunity = false,
        hasBleedImmunity = false,
        hasRegen = false,      -- enemy มี regeneration
        hasShield = false,     -- enemy มี shield/barrier
        hasHighArmor = false   -- enemy มี armor สูง
    }
    
    -- วิเคราะห์แต่ละ enemy (รวม passives/abilities/immunities)
    for _, enemy in pairs(enemies) do
        if enemy and enemy ~= "None" then
            analysis.totalEnemies = analysis.totalEnemies + 1
            
            -- Health Analysis
            local health = 0
            if enemy.Health then
                health = enemy.Health
            elseif enemy.MaxHealth then
                health = enemy.MaxHealth
            elseif enemy.Humanoid and enemy.Humanoid.Health then
                health = enemy.Humanoid.Health
            end
            
            analysis.totalHealth = analysis.totalHealth + health
            if health > 10000 then
                analysis.tankEnemies = analysis.tankEnemies + 1
            end
            
            -- Speed Analysis
            local speed = 0
            if enemy.Speed then
                speed = enemy.Speed
            elseif enemy.Humanoid and enemy.Humanoid.WalkSpeed then
                speed = enemy.Humanoid.WalkSpeed
            elseif enemy.Model and enemy.Model:FindFirstChild("Humanoid") then
                speed = enemy.Model.Humanoid.WalkSpeed or 0
            end
            
            analysis.avgSpeed = analysis.avgSpeed + speed
            
            if speed > 16 then
                analysis.fastEnemies = analysis.fastEnemies + 1
            elseif speed < 10 and speed > 0 then
                analysis.slowEnemies = analysis.slowEnemies + 1
            end
            
            -- Flying/Airborne
            if enemy.IsFlying then
                analysis.flyingEnemies = analysis.flyingEnemies + 1
            elseif enemy.Model then
                if enemy.Model:FindFirstChild("Flying") or enemy.Model:FindFirstChild("Airborne") then
                    analysis.flyingEnemies = analysis.flyingEnemies + 1
                end
            end
            
            -- Boss Check
            if IsBossEnemy and IsBossEnemy(enemy) then
                analysis.hasBoss = true
            end
            
            -- ⭐⭐⭐ NEW: วิเคราะห์ Passives/Abilities/Immunities ของ enemy ⭐⭐⭐
            local enemyData = enemy.Data or enemy
            local enemyName = enemy.Name or enemyData.Name or ""
            
            -- 1. ตรวจสอบ Mutators (passives พิเศษของ enemy)
            if enemyData.Mutators then
                for _, mutator in pairs(enemyData.Mutators) do
                    local mutatorName = type(mutator) == "string" and mutator or (mutator.Name or "")
                    local mutatorLower = string.lower(mutatorName)
                    
                    -- ตรวจหา immunities
                    if mutatorLower:find("slow") and mutatorLower:find("immun") then
                        analysis.hasSlowImmunity = true
                        analysis.immunities["Slow"] = true
                    end
                    if mutatorLower:find("stun") and mutatorLower:find("immun") then
                        analysis.hasStunImmunity = true
                        analysis.immunities["Stun"] = true
                    end
                    if mutatorLower:find("burn") and mutatorLower:find("immun") then
                        analysis.hasBurnImmunity = true
                        analysis.immunities["Burn"] = true
                    end
                    if mutatorLower:find("freeze") and mutatorLower:find("immun") then
                        analysis.hasFreezeImmunity = true
                        analysis.immunities["Freeze"] = true
                    end
                    if mutatorLower:find("bleed") and mutatorLower:find("immun") then
                        analysis.hasBleedImmunity = true
                        analysis.immunities["Bleed"] = true
                    end
                    
                    -- ตรวจหา regen/heal
                    if mutatorLower:find("regen") or mutatorLower:find("heal") then
                        analysis.hasRegen = true
                    end
                    
                    -- ตรวจหา shield/barrier
                    if mutatorLower:find("shield") or mutatorLower:find("barrier") or mutatorLower:find("protect") then
                        analysis.hasShield = true
                    end
                    
                    -- ตรวจหา armor
                    if mutatorLower:find("armor") or mutatorLower:find("defence") or mutatorLower:find("defense") then
                        analysis.hasHighArmor = true
                    end
                end
            end
            
            -- 2. ตรวจสอบ Modifiers (bonuses ของ enemy)
            if enemyData.Modifiers then
                for _, modifier in pairs(enemyData.Modifiers) do
                    local modName = type(modifier) == "string" and modifier or (modifier.Name or "")
                    local modLower = string.lower(modName)
                    
                    if modLower:find("immun") then
                        -- ดึงชื่อ status ที่ immune
                        if modLower:find("slow") then analysis.hasSlowImmunity = true end
                        if modLower:find("stun") then analysis.hasStunImmunity = true end
                        if modLower:find("burn") or modLower:find("fire") then analysis.hasBurnImmunity = true end
                        if modLower:find("freeze") or modLower:find("ice") then analysis.hasFreezeImmunity = true end
                        if modLower:find("bleed") then analysis.hasBleedImmunity = true end
                    end
                end
            end
            
            -- 3. ตรวจสอบ Attributes ของ enemy model
            if enemy.Model then
                local model = enemy.Model
                
                -- Check attributes
                if model:GetAttribute("SlowImmune") then analysis.hasSlowImmunity = true end
                if model:GetAttribute("StunImmune") then analysis.hasStunImmunity = true end
                if model:GetAttribute("BurnImmune") then analysis.hasBurnImmunity = true end
                if model:GetAttribute("FreezeImmune") then analysis.hasFreezeImmunity = true end
                if model:GetAttribute("BleedImmune") then analysis.hasBleedImmunity = true end
                if model:GetAttribute("HasRegen") then analysis.hasRegen = true end
                if model:GetAttribute("HasShield") then analysis.hasShield = true end
            end
            
            -- 4. ตรวจสอบ CurrentStatuses ที่ enemy มีอยู่แล้ว
            if enemyData.Statuses then
                for statusName, _ in pairs(enemyData.Statuses) do
                    analysis.currentStatuses[statusName] = (analysis.currentStatuses[statusName] or 0) + 1
                end
            end
            if enemy.StatusEffects then
                for _, status in pairs(enemy.StatusEffects) do
                    local statusName = type(status) == "string" and status or (status.Name or "")
                    analysis.currentStatuses[statusName] = (analysis.currentStatuses[statusName] or 0) + 1
                end
            end
            
            -- 5. ตรวจจากชื่อ enemy (บาง enemy มี immunity ตามชื่อ)
            local nameLower = string.lower(enemyName)
            if nameLower:find("fire") or nameLower:find("flame") or nameLower:find("inferno") then
                analysis.hasBurnImmunity = true  -- Fire enemies are usually burn immune
            end
            if nameLower:find("ice") or nameLower:find("frost") or nameLower:find("frozen") then
                analysis.hasFreezeImmunity = true  -- Ice enemies are usually freeze immune
            end
            if nameLower:find("speed") or nameLower:find("swift") then
                analysis.hasSlowImmunity = true  -- Speed enemies might resist slow
            end
        end
    end
    
    -- คำนวณค่าเฉลี่ย
    if analysis.totalEnemies > 0 then
        analysis.avgSpeed = analysis.avgSpeed / analysis.totalEnemies
        analysis.avgHealth = analysis.totalHealth / analysis.totalEnemies
    end
    
    -- เลือก status ตามลำดับความสำคัญ (พิจารณา immunities ด้วย!)
    local selectedStatus = "Burn"  -- Default
    local reason = "Default"
    local priority = 0
    
    -- Helper function: ตรวจสอบว่า status นี้ไม่ถูก immune
    local function isStatusEffective(statusName)
        if statusName == "Slow" and analysis.hasSlowImmunity then return false end
        if statusName == "Stun" and analysis.hasStunImmunity then return false end
        if statusName == "Burn" and analysis.hasBurnImmunity then return false end
        if statusName == "Freeze" and analysis.hasFreezeImmunity then return false end
        if statusName == "Bleed" and analysis.hasBleedImmunity then return false end
        return true
    end
    
    -- Helper function: เลือก status alternative ถ้าตัวแรกถูก immune
    local function getEffectiveStatus(preferredStatus, alternativeList)
        if isStatusEffective(preferredStatus) then
            return preferredStatus
        end
        for _, alt in ipairs(alternativeList) do
            if isStatusEffective(alt) then
                return alt
            end
        end
        return preferredStatus  -- ใช้ตัวเดิมถ้าไม่มีตัวเลือก
    end
    
    -- แสดงข้อมูล enemies
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    DebugPrint(string.format("🌈 [Analysis] Total: %d enemies | Fast: %d | Tank: %d | Flying: %d | Boss: %s", 
        analysis.totalEnemies,
        analysis.fastEnemies,
        analysis.tankEnemies,
        analysis.flyingEnemies,
        tostring(analysis.hasBoss)
    ))
    DebugPrint(string.format("🌈 [Analysis] Avg Speed: %.1f | Avg HP: %.0f", 
        analysis.avgSpeed, analysis.avgHealth))
    
    -- แสดง immunities ที่ตรวจพบ
    local immuneList = {}
    if analysis.hasSlowImmunity then table.insert(immuneList, "Slow") end
    if analysis.hasStunImmunity then table.insert(immuneList, "Stun") end
    if analysis.hasBurnImmunity then table.insert(immuneList, "Burn") end
    if analysis.hasFreezeImmunity then table.insert(immuneList, "Freeze") end
    if analysis.hasBleedImmunity then table.insert(immuneList, "Bleed") end
    
    if #immuneList > 0 then
        DebugPrint(string.format("🌈 [Immunities] ⚠️ Enemy immune to: %s", table.concat(immuneList, ", ")))
    end
    
    if analysis.hasRegen then
        DebugPrint("🌈 [Passive] ⚠️ Enemy has Regeneration - prioritize DoT")
    end
    if analysis.hasShield then
        DebugPrint("🌈 [Passive] ⚠️ Enemy has Shield/Barrier")
    end
    
    -- ⭐ NEW Priority: Enemy has Regeneration → ใช้ Burn/Bleed (DoT) เพื่อ counter heal
    if analysis.hasRegen and priority < 11 then
        if isStatusEffective("Burn") then
            selectedStatus = "Burn"
            reason = "Counter enemy Regeneration with DoT"
            priority = 11
        elseif isStatusEffective("Bleed") then
            selectedStatus = "Bleed"
            reason = "Counter enemy Regeneration with DoT"
            priority = 11
        end
    end
    
    -- Priority 10: Boss → Rupture (Permanent debuff) หรือ alternative
    if analysis.hasBoss and priority < 10 then
        selectedStatus = getEffectiveStatus("Rupture", {"Burn", "Bleed", "Freeze"})
        reason = "Boss detected - " .. (selectedStatus == "Rupture" and "Permanent damage" or "Alternative (Rupture immune)")
        priority = 10
    end
    
    -- Priority 9: Fast enemies (>60%) → Slow/Freeze (ถ้าไม่ immune)
    if priority < 9 and analysis.fastEnemies > (analysis.totalEnemies * 0.6) then
        local preferredCC = analysis.avgSpeed > 20 and "Freeze" or "Slow"
        selectedStatus = getEffectiveStatus(preferredCC, {"Freeze", "Slow", "Stun"})
        reason = string.format("Fast enemies: %d/%d (%.1f speed) - %s%s", 
            analysis.fastEnemies, analysis.totalEnemies, analysis.avgSpeed,
            selectedStatus,
            not isStatusEffective(preferredCC) and " (alternative)" or "")
        priority = 9
    end
    
    -- Priority 8: Tank enemies (>50%) → Burn/Bleed (DoT)
    if priority < 8 and analysis.tankEnemies > (analysis.totalEnemies * 0.5) then
        selectedStatus = getEffectiveStatus("Burn", {"Bleed", "Rupture"})
        reason = string.format("Tank enemies: %d/%d (%.0f avg HP) - DoT%s", 
            analysis.tankEnemies, analysis.totalEnemies, analysis.avgHealth,
            not isStatusEffective("Burn") and " (alternative)" or "")
        priority = 8
    end
    
    -- Priority 7: Flying enemies (>40%) → Stun หรือ alternative
    if priority < 7 and analysis.flyingEnemies > (analysis.totalEnemies * 0.4) then
        selectedStatus = getEffectiveStatus("Stun", {"Freeze", "Slow"})
        reason = string.format("Flying enemies: %d/%d - %s%s", 
            analysis.flyingEnemies, analysis.totalEnemies,
            selectedStatus,
            not isStatusEffective("Stun") and " (alternative)" or "")
        priority = 7
    end
    
    -- Priority 6: Very high average speed → Freeze/Slow
    if priority < 6 and analysis.avgSpeed > 18 then
        selectedStatus = getEffectiveStatus("Freeze", {"Slow", "Stun"})
        reason = string.format("High avg speed: %.1f - %s", analysis.avgSpeed, selectedStatus)
        priority = 6
    end
    
    -- Priority 5: High health enemies → Burn/Bleed
    if priority < 5 and analysis.avgHealth > 8000 then
        selectedStatus = getEffectiveStatus("Burn", {"Bleed", "Rupture"})
        reason = string.format("High HP enemies: %.0f avg - DoT", analysis.avgHealth)
        priority = 5
    end
    
    -- Priority 0: Default → หา status ที่ไม่ถูก immune
    if priority == 0 then
        -- ลำดับ default: Burn > Bleed > Freeze > Slow > Stun > Rupture
        local defaultOrder = {"Burn", "Bleed", "Freeze", "Slow", "Stun", "Rupture"}
        for _, status in ipairs(defaultOrder) do
            if isStatusEffective(status) then
                selectedStatus = status
                break
            end
        end
        reason = "General purpose (considering immunities)"
    end
    
    -- แสดงผลการเลือก
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    DebugPrint(string.format("🌈 ✅ เลือก: %s (Priority: %d)", selectedStatus, priority))
    DebugPrint(string.format("🌈 📝 เหตุผล: %s", reason))
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    return selectedStatus
end

-- ===== USE ABILITY (Smart Detection) =====
local function UseAbilityV3(unit, abilityName, abilityInfo)
    local guid = unit.UniqueIdentifier or unit.GUID
    local abilityKey = guid .. "_" .. abilityName
    local unitName = unit.Name or ""
    local success = false
    local err = nil
    
    -- 🎯 Smart Detection
    
    -- 1. Reality Rewrite
    if abilityName:find("Reality Rewrite") then
        if not RealityRewriteEvent then return false end
        
        local selectedStatus = "Burn"
        local analyzeSuccess, analyzeResult = pcall(function()
            return AnalyzeEnemiesForStatus()
        end)
        
        if analyzeSuccess and analyzeResult then
            selectedStatus = analyzeResult
        end
        
        -- ตรวจสอบว่า status นี้มีใน RealityRewriteData หรือไม่
        local validStatus = selectedStatus
        if RealityRewriteData and RealityRewriteData.Statuses then
            if not RealityRewriteData.Statuses[selectedStatus] then
                -- Status ไม่มี → หา status ที่มีแทน
                local fallbackPriority = {"Burn", "Slow", "Freeze", "Stun", "Rupture"}
                for _, fallback in ipairs(fallbackPriority) do
                    if RealityRewriteData.Statuses[fallback] then
                        validStatus = fallback
                        break
                    end
                end
            end
        else
            -- ไม่มี RealityRewriteData → ใช้ fallback list
            if not table.find(REALITY_REWRITE_STATUSES, selectedStatus) then
                validStatus = "Burn"  -- Default fallback
            end
        end
        
        -- Fire event (ตาม decom: FireServer(guid, statusName))
        success, err = pcall(function()
            RealityRewriteEvent:FireServer(guid, validStatus)
        end)
        
        if success then
            AbilityUsedOnce[abilityKey] = true  -- OneTime ability
        end
    
    -- 2. The Goal of All Life is Death (Lich) - Starting Uses = 1
    elseif abilityName:find("The Goal of All Life is Death") then
        -- ใช้ AbilityEvent ปกติ
        if AbilityEvent then
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityUsedOnce[abilityKey] = true  -- Starting Uses = 1
                DebugPrint("💀 The Goal of All Life is Death activated")
            end
        end
    
    -- 3. God Arrives - ใช้ตาม cooldown (10 วินาที) ไม่มีเงื่อนไข
    elseif abilityName:find("God Arrives") then
        if not AbilityEvent then return false end
        
        success, err = pcall(function()
            AbilityEvent:FireServer("Activate", guid, abilityName)
        end)
        
        if success then
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("[Ability] ⚡ God Arrives activated! (cooldown: 10s)"))
        end
    
    -- 4. Koguro Dimensions (ToggleAuto)
    elseif unitName:find("Koguro") and abilityName:find("Dimension") then
        if not KoguroDimensionEvent then return false end
        
        success, err = pcall(function()
            KoguroDimensionEvent:FireServer("ToggleAuto", guid)
        end)
    
    -- 5. Arcane Knowledge (Lich) - Element Selection
    elseif unitName:find("Lich") and abilityName:find("Arcane Knowledge") then
        if not LichSpellsEvent then return false end
        
        -- 🔮 วิเคราะห์ธาตุที่ unlock แล้ว (ตาม decom)
        local function GetUnlockedElements()
            local elementCounts = {}
            
            -- นับธาตุจาก Units._Cache (ตาม decom)
            if UnitsModule and UnitsModule._Cache then
                DebugPrint(string.format("🔮 [Cache Check] Found %d units in cache", 
                    (function()
                        local count = 0
                        for _ in pairs(UnitsModule._Cache) do count = count + 1 end
                        return count
                    end)()
                ))
                
                for _, cacheData in pairs(UnitsModule._Cache) do
                    if cacheData ~= "None" then
                        -- ดึง UnitData จาก Identifier
                        local unitData = nil
                        if UnitsData and cacheData.Identifier then
                            local success, result = pcall(function()
                                return UnitsData:GetUnitDataFromID(cacheData.Identifier)
                            end)
                            if success then
                                unitData = result
                            end
                        end
                        
                        -- นับธาตุจาก unit
                        if unitData and unitData.Elements then
                            for _, element in ipairs(unitData.Elements) do
                                elementCounts[element] = (elementCounts[element] or 0) + 1
                            end
                        end
                    end
                end
            else
                DebugPrint("🔮 [Cache Check] UnitsModule._Cache not found!")
            end
            
            -- เพิ่ม Unknown ให้ทุกธาตุ (ตาม decom)
            if elementCounts.Unknown then
                DebugPrint("🔮 [Unknown Boost] Adding +1 to all elements")
                for elem in pairs(elementCounts) do
                    elementCounts[elem] = elementCounts[elem] + 1
                end
            end
            
            -- แสดงรายการธาตุ
            local elementList = {}
            for elem, count in pairs(elementCounts) do
                table.insert(elementList, string.format("%s(%d)", elem, count))
            end
            table.sort(elementList)
            
            DebugPrint(string.format("🔮 [Elements] Unlocked: %s", 
                #elementList > 0 and table.concat(elementList, ", ") or "None"
            ))
            
            return elementCounts
        end
        
        -- เลือกธาตุที่ดีที่สุดตามสถานการณ์
        local unlockedElements = GetUnlockedElements()
        local selectedElement = "Elementless"  -- Default
        
        -- เลือกธาตุตามเงื่อนไข (ธาตุที่มีมากที่สุด)
        local maxCount = 0
        local bestElement = "Elementless"
        
        for element, count in pairs(unlockedElements) do
            if element ~= "Unknown" and count > maxCount then
                maxCount = count
                bestElement = element
            end
        end
        
        -- ถ้าหาธาตุได้ ให้ใช้
        if maxCount > 0 then
            selectedElement = bestElement
        end
        
        DebugPrint(string.format("🔮 [Element Selection] Selected: %s (Count: %d)", 
            selectedElement,
            maxCount
        ))
        
        -- ดึง spell ที่เหมาะสมกับธาตุที่เลือก (ต้อง unlock แล้ว!)
        local selectedSpells = {}
        
        if LichData and LichData.Spells then
            local spellCount = 0
            for _ in pairs(LichData.Spells) do
                spellCount = spellCount + 1
            end
            DebugPrint(string.format("🔮 [LichData] Found %d spells", spellCount))
            DebugPrint(string.format("🔮 [Spell Check] Checking spells for element: %s", selectedElement))
            
            -- หา spells ที่ตรงกับธาตุ (เช็คทุก spell)
            for spellId, spellData in pairs(LichData.Spells) do
                local spellName = spellData.Name or spellId
                local requirements = spellData.Requirements or {}
                
                -- นับจำนวน requirements
                local reqCount = 0
                for elem, count in pairs(requirements) do
                    reqCount = reqCount + 1
                    DebugPrint(string.format("🔮     [%s] Requires: %d %s", spellName, count, elem))
                end
                
                -- เช็คว่า spell นี้ใช้ได้กับธาตุที่เลือกหรือไม่
                local canUse = false
                
                if selectedElement == "Elementless" and reqCount == 0 then
                    -- Elementless spells (no requirements)
                    canUse = true
                    DebugPrint(string.format("🔮   ✅ %s (Elementless - No requirements)", spellName))
                elseif requirements[selectedElement] then
                    -- ต้องเช็คว่าปลดล็อคแล้ว (มีธาตุพอ)
                    local requiredCount = requirements[selectedElement]
                    local actualCount = unlockedElements[selectedElement] or 0
                    
                    if actualCount >= requiredCount then
                        canUse = true
                        DebugPrint(string.format("🔮   ✅ %s (Req: %d %s, Has: %d)", 
                            spellName, 
                            requiredCount, 
                            selectedElement,
                            actualCount
                        ))
                    else
                        DebugPrint(string.format("🔮   ❌ %s (Req: %d %s, Has: %d - LOCKED)", 
                            spellName, 
                            requiredCount, 
                            selectedElement,
                            actualCount
                        ))
                    end
                else
                    -- Spell ต้องการธาตุอื่น
                    DebugPrint(string.format("🔮   ⏭️ %s (Wrong element)", spellName))
                end
                
                if canUse then
                    -- ❗ ต้องส่ง spell ID (number) ไม่ใช่ name! (ตาม decom)
                    table.insert(selectedSpells, {
                        id = spellId,
                        name = spellName
                    })
                end
            end
        else
            DebugPrint("🔮 [ERROR] LichData or LichData.Spells not found!")
            if not LichData then
                DebugPrint("🔮   → LichData is nil")
            elseif not LichData.Spells then
                DebugPrint("🔮   → LichData.Spells is nil")
            end
        end
        
        -- ถ้าไม่มี spell ให้หา Elementless spells
        if #selectedSpells == 0 then
            DebugPrint("🔮 [Fallback] No spells for selected element, trying Elementless...")
            
            -- หา Elementless spells (requirements = empty)
            if LichData and LichData.Spells then
                for spellId, spellData in pairs(LichData.Spells) do
                    local requirements = spellData.Requirements or {}
                    local reqCount = 0
                    for _ in pairs(requirements) do
                        reqCount = reqCount + 1
                    end
                    
                    if reqCount == 0 then
                        table.insert(selectedSpells, {
                            id = spellId,
                            name = spellData.Name or spellId
                        })
                        DebugPrint(string.format("🔮   → Found Elementless: %s", spellData.Name))
                    end
                end
            end
            
            selectedElement = "Elementless"
        end
        
        -- ⭐⭐⭐ CRITICAL FIX: เลือก spell ตามจำนวน slot ที่ปลดล็อคได้
        -- ตาม decom_Ability.lua: ถ้า spell locked (ธาตุไม่พอ) → ใส่แค่ 1 slot เดิม
        -- ถ้า 3 slot เป็นธาตุเดียวกัน = ปลดล็อคครบ
        local maxSpells = (LichData and LichData.MAX_SPELL_COUNT) or 4  -- Default 4 (ตาม decom)
        local finalSpells = {}
        local finalSpellNames = {}
        local usedSpellIds = {}  -- ⭐ ป้องกันใส่ spell ซ้ำ
        
        -- ⭐⭐⭐ CRITICAL: นับจำนวน slot ที่ปลดล็อคได้ตามธาตุ
        local unlockedSlots = 0
        local elementCount = unlockedElements[selectedElement] or 0
        
        if selectedElement == "Elementless" then
            -- Elementless = ปลดล็อคทุก slot
            unlockedSlots = maxSpells
            DebugPrint("🔮 [Slots] Elementless → All slots unlocked")
        else
            -- ธาตุอื่น = จำนวน slot ตามจำนวนธาตุที่มี (max = maxSpells)
            unlockedSlots = math.min(elementCount, maxSpells)
            DebugPrint(string.format("🔮 [Slots] %s: %d units → %d slots unlocked", 
                selectedElement, elementCount, unlockedSlots))
        end
        
        -- ⭐ ถ้าไม่มี slot ปลดล็อค → ใช้แค่ 1 slot (Undead Control)
        if unlockedSlots <= 0 then
            unlockedSlots = 1
            DebugPrint("🔮 [Slots] No unlocked slots → Use 1 slot only (Elementless)")
        end
        
        -- ⭐ SLOT 1: เลือก spell แรกที่ใช้ได้
        local firstSpell = nil
        if #selectedSpells > 0 then
            firstSpell = selectedSpells[1]
            DebugPrint(string.format("🔮 [Slot 1] เลือก: %s (ID: %d)", firstSpell.name, firstSpell.id))
        else
            firstSpell = {id = 1, name = "Undead Control"}
            DebugPrint("🔮 [Slot 1] ไม่มี spell ปลดล็อค → ใช้ Undead Control (default)")
        end
        
        table.insert(finalSpells, firstSpell.id)
        table.insert(finalSpellNames, firstSpell.name)
        usedSpellIds[firstSpell.id] = true
        
        -- ⭐ SLOT 2-N: เลือก spells ที่เหลือ (ไม่ซ้ำกัน!)
        local spellIndex = 2
        for i = 2, unlockedSlots do
            local addedSpell = false
            
            -- หา spell ที่ยังไม่ได้ใช้
            while spellIndex <= #selectedSpells do
                local spell = selectedSpells[spellIndex]
                spellIndex = spellIndex + 1
                
                if not usedSpellIds[spell.id] then
                    table.insert(finalSpells, spell.id)
                    table.insert(finalSpellNames, spell.name)
                    usedSpellIds[spell.id] = true
                    addedSpell = true
                    break
                end
            end
            
            -- ถ้าไม่มี spell ใหม่ → หยุด (ไม่เติม filler ซ้ำ)
            if not addedSpell then
                DebugPrint(string.format("🔮 [Slot %d] No more unique spells → Stop filling", i))
                break
            end
        end
        
        DebugPrint(string.format("🔮 [Final] %d spells selected (max unlocked: %d)", #finalSpells, unlockedSlots))
        
        DebugPrint(string.format("🔮 [Final Selection] %d/%d spells selected:", #finalSpells, maxSpells))
        for i, spellName in ipairs(finalSpellNames) do
            DebugPrint(string.format("   Slot %d: %s (ID: %d)", i, spellName, finalSpells[i]))
        end
        
        -- เช็คว่า spell ที่จะเลือกเหมือนกับที่เลือกไว้แล้วหรือไม่
        local lastSpells = LastSelectedSpells[guid] or {}
        local isSameSpells = #lastSpells == #finalSpells
        
        if isSameSpells then
            -- เช็คแต่ละ spell ว่าเหมือนกันหรือไม่
            for i = 1, #finalSpells do
                if finalSpells[i] ~= lastSpells[i] then
                    isSameSpells = false
                    break
                end
            end
        end
        
        if isSameSpells then
            return false  -- ไม่ส่ง event ซ้ำ
        end
        
        -- Fire event
        
        success, err = pcall(function()
            LichSpellsEvent:FireServer(finalSpells)  -- ❗ ส่ง array เดียว ไม่มี guid! (ตาม decom)
        end)
        
        if success then
            LastSelectedSpells[guid] = finalSpells
            AbilityLastUsed[abilityKey] = tick()
            -- Log เฉพาะเมื่อเปลี่ยน spell สำเร็จ
            print(string.format("[Skill] 🔮 Lich Spells: %s", table.concat(finalSpellNames, ", ")))
        end
    
    -- 6. Horsegirl Racing (AutoUpgradeHorsegirl) - Auto select horse + close GUI
    elseif unitName:find("Horsegirl") and (abilityName:find("Racing") or abilityName:find("Auto Upgrade")) and HorsegirlRacingEvent then
        success, err = pcall(function()
            HorsegirlRacingEvent:FireServer(guid)
        end)
        
        if success then
            
            -- ⭐ Auto-select Horsegirl จาก GUI (รอ GUI เปิด)
            task.spawn(function()
                task.wait(0.3)  -- รอ GUI เปิด
                
                local playerGui = plr:FindFirstChild("PlayerGui")
                if playerGui then
                    -- หา Horsegirl Racing GUI
                    local racingGui = playerGui:FindFirstChild("HorsegirlRacing") or
                                     playerGui:FindFirstChild("Horsegirl Racing") or
                                     playerGui:FindFirstChild("HorsegirlSelect")
                    
                    if not racingGui then
                        -- ค้นหาใน descendants
                        for _, gui in pairs(playerGui:GetDescendants()) do
                            if gui:IsA("ScreenGui") and gui.Name:find("Horsegirl") then
                                racingGui = gui
                                break
                            end
                        end
                    end
                    
                    if racingGui and racingGui.Enabled then
                        
                        -- ⭐ เลือก Horsegirl ตัวแรก (CONCERT = Speed, AU BOAT = Damage, SCIENTIST = Crit, JOY = Cost)
                        -- เลือก Damage (AU BOAT) หรือ Crit (SCIENTIST) เป็น default
                        local preferredOrder = {"AU BOAT", "SCIENTIST", "CONCERT", "JOY", "Damage", "Crit", "Speed", "Cost"}
                        local selectedButton = nil
                        
                        for _, horseName in ipairs(preferredOrder) do
                            for _, btn in pairs(racingGui:GetDescendants()) do
                                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                                    local btnText = btn.Text or btn.Name or ""
                                    local parentText = btn.Parent and (btn.Parent.Name or "") or ""
                                    
                                    if btnText:find(horseName) or parentText:find(horseName) or 
                                       btn.Name:find(horseName) or btn.Name == "Choose" then
                                        selectedButton = btn
                                        print(string.format("[FORCED]   → Found button: %s", btn.Name))
                                        break
                                    end
                                end
                            end
                            if selectedButton then break end
                        end
                        
                        -- ถ้าไม่เจอตาม preferredOrder → เลือกปุ่ม Choose แรกที่เจอ
                        if not selectedButton then
                            for _, btn in pairs(racingGui:GetDescendants()) do
                                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and 
                                   (btn.Name == "Choose" or btn.Text == "Choose") then
                                    selectedButton = btn
                                    break
                                end
                            end
                        end
                        
                        if selectedButton then
                            print(string.format("[FORCED]   → Auto-selecting: %s", selectedButton.Name))
                            
                            -- กดปุ่ม
                            pcall(function()
                                -- ลอง fire Activated event
                                if selectedButton.Activated then
                                    selectedButton.Activated:Fire()
                                end
                            end)
                            
                            pcall(function()
                                -- ลอง MouseButton1Click
                                if selectedButton.MouseButton1Click then
                                    selectedButton.MouseButton1Click:Fire()
                                end
                            end)
                            
                            task.wait(0.2)
                            
                            -- ปิด GUI
                            pcall(function()
                                racingGui.Enabled = false
                            end)
                        end
                    end
                end
            end)
        end
    
    -- 7. GENERIC PLACEMENT ABILITY HANDLER
    elseif abilityInfo and abilityInfo.NeedsPlacement then
        
        -- หาตำแหน่งดีที่สุดสำหรับวาง
        local unitRange = abilityInfo.PlacementRange or 30
        local targetPos = nil
        
        -- หาตำแหน่งจาก unit.Model ก่อน
        if unit and unit.Model then
            local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
            if hrp then
                local offset = 15
                local angle = math.random() * math.pi * 2
                targetPos = hrp.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
                print(string.format("[FORCED]   → Using HumanoidRootPart + offset: (%.1f, %.1f, %.1f)", targetPos.X, targetPos.Y, targetPos.Z))
            end
        end
        
        -- Fallback: GetBestPlacementPosition
        if not targetPos then
            targetPos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit and unit.Data)
        end
        
        -- Fallback: frontmost enemy
        if not targetPos then
            local frontEnemy = GetFrontmostEnemy()
            if frontEnemy and frontEnemy.Position then
                local offset = 12
                local angle = math.random() * math.pi * 2
                targetPos = frontEnemy.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
            end
        end
        
        -- Last fallback
        if not targetPos then
            targetPos = Vector3.new(0, 10, 0)
        end
        
        print(string.format("[FORCED]   → Final position: (%.1f, %.1f, %.1f)", targetPos.X, targetPos.Y, targetPos.Z))
        
        -- ⭐⭐⭐ ตาม Decom: แยกประเภท ability
        local abilityLower = abilityName:lower()
        
        -- 🔴 TYPE 1: TELEPORT abilities (Rogita, etc.) - ใช้ RequestMiscPlacement
        if abilityLower:find("teleport") or abilityLower:find("instant") then
            print("[FORCED]   → TYPE: TELEPORT ability - using RequestMiscPlacement")
            
            -- ⭐⭐⭐ FIX: หาตำแหน่งไกลจากตำแหน่งปัจจุบัน (ไม่ใช่ตำแหน่งเดิม!)
            local teleportPos = nil
            local currentPos = nil
            
            -- หาตำแหน่งปัจจุบันของ unit
            if unit and unit.Model then
                local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    currentPos = hrp.Position
                end
            end
            
            -- ⭐ หาตำแหน่งไกลจากตำแหน่งปัจจุบัน (50 studs ขึ้นไป)
            if currentPos then
                -- หาตำแหน่งใกล้ศัตรูหน้าสุด
                local frontEnemy = GetFrontmostEnemy and GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    -- เทเลพอร์ตไปใกล้ศัตรู (offset 10 studs)
                    local dirToEnemy = (frontEnemy.Position - currentPos).Unit
                    teleportPos = frontEnemy.Position - dirToEnemy * 10
                    teleportPos = Vector3.new(teleportPos.X, currentPos.Y, teleportPos.Z)
                    print(string.format("[FORCED]   → Teleport target: near front enemy at (%.1f, %.1f, %.1f)", 
                        teleportPos.X, teleportPos.Y, teleportPos.Z))
                else
                    -- Fallback: เทเลพอร์ตไป 50 studs ในทิศทางสุ่ม
                    local angle = math.random() * math.pi * 2
                    teleportPos = currentPos + Vector3.new(math.cos(angle) * 50, 0, math.sin(angle) * 50)
                    print(string.format("[FORCED]   → Teleport target: 50 studs away at (%.1f, %.1f, %.1f)", 
                        teleportPos.X, teleportPos.Y, teleportPos.Z))
                end
            else
                teleportPos = targetPos  -- Fallback ใช้ targetPos เดิม
            end
            
            print(string.format("[FORCED]   → Current pos: %s, Teleport to: (%.1f, %.1f, %.1f)", 
                currentPos and string.format("(%.1f, %.1f, %.1f)", currentPos.X, currentPos.Y, currentPos.Z) or "unknown",
                teleportPos.X, teleportPos.Y, teleportPos.Z))
            
            local RequestMiscPlacement = nil
            pcall(function()
                RequestMiscPlacement = game:GetService("ReplicatedStorage").Networking.RequestMiscPlacement
            end)
            
            if RequestMiscPlacement then
                success, err = pcall(function()
                    RequestMiscPlacement:FireServer(guid, teleportPos)
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[FORCED]   → ✅ Teleported to (%.1f, %.1f, %.1f)!", teleportPos.X, teleportPos.Y, teleportPos.Z))
                else
                    print(string.format("[FORCED]   → ❌ RequestMiscPlacement failed: %s", tostring(err)))
                end
            else
                print("[FORCED]   → ❌ RequestMiscPlacement not found!")
            end
            
        -- 🟢 TYPE 2: SPAWN ALIEN abilities (Emperor's Army) - spawn Alien Cadet ONLY
        elseif abilityLower:find("emperor") or abilityLower:find("army") then
            print("[FORCED]   → TYPE: SPAWN ALIEN ability - spawning Alien Cadet ONLY")
            
            -- ⭐⭐⭐ FIX: วาง Alien Cadet เท่านั้น (ตามรูป 3 ที่ user ให้มา)
            local alienCadetID = nil
            
            -- หา ID จาก EntityIDHandler
            if EntityIDHandler and EntityIDHandler.GetIDFromName then
                local getSuccess, getResult = pcall(function()
                    return EntityIDHandler:GetIDFromName("Unit", "Alien Cadet")
                end)
                if getSuccess and getResult then
                    alienCadetID = getResult
                    print(string.format("[FORCED]   → Found Alien Cadet ID: %s", tostring(alienCadetID)))
                else
                    print(string.format("[FORCED]   → Failed to get Alien Cadet ID: %s", tostring(getResult)))
                end
            end
            
            -- ⭐⭐⭐ FIX: เช็ค Max Limit ก่อนวาง
            local alienLimit = 3  -- Alien Cadet limit = 3 (ตามรูป: "If 3 are placed")
            local currentAlienCount = 0
            
            -- นับจำนวน Alien Cadet ที่วางแล้ว
            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                for _, unitData in pairs(ClientUnitHandler._ActiveUnits) do
                    if unitData.Name and unitData.Name:find("Alien Cadet") then
                        currentAlienCount = currentAlienCount + 1
                    end
                end
            end
            
            print(string.format("[FORCED]   → Alien Cadet count: %d/%d", currentAlienCount, alienLimit))
            
            if currentAlienCount >= alienLimit then
                print("[FORCED]   → ⚠️ Alien Cadet limit reached! Skipping spawn.")
            elseif UnitEvent and alienCadetID then
                success, err = pcall(function()
                    UnitEvent:FireServer("Render", 
                        {"Alien Cadet", alienCadetID, targetPos, 0, nil},
                        {FromUnitGUID = guid}
                    )
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[FORCED]   → ✅ Alien Cadet spawned at (%.1f, %.1f, %.1f)!", targetPos.X, targetPos.Y, targetPos.Z))
                else
                    print(string.format("[FORCED]   → ❌ Alien spawn failed: %s", tostring(err)))
                end
            elseif not alienCadetID then
                -- ⭐⭐⭐ FALLBACK: ใช้ AbilityEvent
                print("[FORCED]   → No Alien Cadet ID, using AbilityEvent fallback...")
                if AbilityEvent then
                    success, err = pcall(function()
                        AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                    end)
                    if success then
                        AbilityLastUsed[abilityKey] = tick()
                        print("[FORCED]   → ✅ AbilityEvent fallback successful!")
                    end
                end
            else
                print("[FORCED]   → ❌ UnitEvent not available!")
            end
            
        -- 🔵 TYPE 3: CLONE abilities (Monkey King's Fur, Valentine) - ใช้ GetBestPlacementPosition เหมือน Normal mode
        elseif abilityLower:find("fur") or abilityLower:find("clone") or abilityLower:find("another me") then
            print("[FORCED]   → TYPE: CLONE ability - using GetBestPlacementPosition (Normal mode style)")
            
            -- ⭐⭐⭐ FIX: ใช้ GetBestPlacementPosition เหมือน Normal mode
            local clonePos = nil
            
            -- Priority 1: GetBestPlacementPosition (U-center system เหมือน Normal mode)
            pcall(function()
                clonePos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit and unit.Data)
            end)
            
            -- Priority 2: ใกล้ศัตรูหน้าสุด
            if not clonePos then
                local frontEnemy = GetFrontmostEnemy and GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    local offset = 12
                    local angle = math.random() * math.pi * 2
                    clonePos = frontEnemy.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
                end
            end
            
            -- Priority 3: ใกล้ unit เจ้าของ
            if not clonePos and unit and unit.Model then
                local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local offset = 10
                    local angle = math.random() * math.pi * 2
                    clonePos = hrp.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
                end
            end
            
            -- Fallback
            if not clonePos then
                clonePos = targetPos
            end
            
            if AbilityEvent then
                print(string.format("[FORCED]   → Clone position: (%.1f, %.1f, %.1f)", clonePos.X, clonePos.Y, clonePos.Z))
                
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, clonePos)
                end)
                
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[FORCED]   → ✅ %s clone placed!", abilityName))
                else
                    print(string.format("[FORCED]   → ❌ AbilityEvent failed: %s", tostring(err)))
                end
            else
                print("[FORCED]   → ❌ AbilityEvent not available!")
            end
            
        -- 🟡 TYPE 4: DEFAULT - ใช้ AbilityEvent
        else
            print("[FORCED]   → TYPE: DEFAULT - using AbilityEvent")
            if AbilityEvent then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[FORCED]   → ✅ %s activated!", abilityName))
                else
                    print(string.format("[FORCED]   → ❌ AbilityEvent failed: %s", tostring(err)))
                end
            else
                print("[FORCED]   → ❌ AbilityEvent not available!")
            end
        end
    
    -- 8. World Items (Caloric Stone, Ouroboros)
    elseif abilityName:find("World Item") or abilityName:find("Caloric") or abilityName:find("Ouroboros") then
        -- World Item ใช้ได้ 1 ครั้งต่อ match
        if _G.APSkill.WorldItemUsedThisMatch then
            print("[Skill] ⚠️ World Item ใช้ไปแล้วใน match นี้")
            return false
        end
        
        local itemToUse = nil
        local stageInfo = AnalyzeStageType()
        GetWaveFromUI()
        local isMaxWave = (CurrentWave >= MaxWave - 1)
        
        print(string.format("[Skill] 🔍 World Item Check: CaloricStoneEvent=%s, Wave=%d/%d", 
            tostring(CaloricStoneEvent ~= nil), CurrentWave, MaxWave))
        
        -- ⭐⭐⭐ CRITICAL: ถ้า Emergency mode กำลังวางตัวอยู่ → รอให้วางครบก่อนค่อยใช้ Caloric Stone
        -- ⭐ FIX: เช็คแค่ IsEmergency และ EmergencyActivated - ไม่ต้องเช็ค EmergencyUnits เพราะมันเก็บไว้ track
        if IsEmergency and not EmergencyActivated then
            print("[Skill] ⏸️ World Item - รอ Emergency mode เสร็จก่อน...")
            return false
        end
        
        -- Caloric Stone - ใช้หลัง Wave 1 เพื่อให้วางได้ทุกตัว
        -- ⭐⭐⭐ FIX: รอ Wave > 1 ก่อนใช้ Caloric Stone (Lich King Ruler)
        if CurrentWave < 2 then
            print("[Skill] ⏸️ World Item - รอ Wave 2+ ก่อน...")
            return false
        end
        
        if CaloricStoneEvent then
            
            local damageUnits = {}
            
            -- ⭐⭐⭐ FIX: เช็คแค่ใน HOTBAR (กระเป๋า) เท่านั้น - ไม่ใช้ placed units
            if OwnedUnitsHandler and OwnedUnitsHandler.GetOwnedUnits then
                local ownedUnits = nil
                pcall(function()
                    ownedUnits = OwnedUnitsHandler:GetOwnedUnits()
                end)
                
                if ownedUnits then
                    for unitGUID, unitEntry in pairs(ownedUnits) do
                        local identifier = unitEntry.Identifier
                        local uniqueId = unitEntry.UniqueIdentifier or unitGUID
                        local unitData = unitEntry.UnitData or unitEntry
                        local unitName = unitData and unitData.Name or ""
                        
                        if unitName ~= "" then
                            local isLich = unitName:lower():find("lich") or unitName:lower():find("ruler")
                            local isIncome = IsIncomeUnit and IsIncomeUnit(unitName, unitData or {})
                            local isBuff = IsBuffUnit and IsBuffUnit(unitName, unitData or {})
                            local isDamage = not isLich and not isIncome and not isBuff
                            
                            if isDamage then
                                local realDPS = 0
                                local lookupData = unitData
                                
                                if lookupData and lookupData.Upgrades then
                                    local upgradeLevel = lookupData.CurrentUpgrade or 1
                                    local upgradeData = lookupData.Upgrades[upgradeLevel]
                                    if upgradeData then
                                        local baseDamage = upgradeData.Damage or upgradeData.ATK or 0
                                        local cooldown = upgradeData.Cooldown or upgradeData.SPA or 1
                                        if baseDamage > 0 and cooldown > 0 then
                                            realDPS = baseDamage / cooldown
                                        end
                                    end
                                end
                                
                                if realDPS == 0 then
                                    realDPS = lookupData.Priority or lookupData.Price or 0
                                end
                                
                                table.insert(damageUnits, {
                                    Slot = unitGUID,
                                    Name = unitName,
                                    DPS = realDPS,
                                    Data = unitData,
                                    Identifier = identifier,
                                    UniqueIdentifier = uniqueId,
                                    GUID = unitGUID,
                                    Source = "Bag"
                                })
                            end
                        end
                    end
                end
            end
            
            
            -- เรียงจาก DPS สูงไปต่ำ
            table.sort(damageUnits, function(a, b)
                return a.DPS > b.DPS
            end)
            
            if #damageUnits > 0 then
                local bestUnit = damageUnits[1]
                
                -- ⭐⭐⭐ FIX: เช็คเงินก่อนเลือก Unit
                local unitPrice = 0
                pcall(function()
                    if bestUnit.Data and bestUnit.Data.Price then
                        unitPrice = bestUnit.Data.Price
                    elseif bestUnit.Data and bestUnit.Data.Upgrades and bestUnit.Data.Upgrades[1] then
                        unitPrice = bestUnit.Data.Upgrades[1].Cost or 0
                    end
                end)
                
                local currentYen = GetYen()
                if unitPrice > 0 and currentYen < unitPrice then
                    print(string.format("[Skill] ⏸️ Caloric Stone - เงินไม่พอ (มี %d, ต้องการ %d) - รอเงิน...", currentYen, unitPrice))
                    return false
                end
                
                local targetIdentifier = bestUnit.UniqueIdentifier or bestUnit.Identifier or bestUnit.ID
                
                success, err = pcall(function()
                    CaloricStoneEvent:FireServer(targetIdentifier, guid)
                end)
                
                if success then
                    print(string.format("[Skill] 💊 Caloric Stone → %s (กำลังวาง clone...)", bestUnit.Name))
                    
                    -- ⭐⭐⭐ Auto Placement: ใช้ format เหมือน PlaceUnit ปกติ
                    -- แต่ใช้ FromUnitGUID แทน SlotIndex
                    task.spawn(function()
                        task.wait(0.3)
                        
                        -- หา numeric ID ของ unit (เหมือน PlaceUnit ปกติ)
                        local unitName = bestUnit.Name
                        local numericID = bestUnit.Identifier or bestUnit.ID
                        
                        -- แปลง ID เป็นตัวเลขถ้าจำเป็น
                        if type(numericID) == "string" and UnitsData then
                            pcall(function()
                                local unitInfo = UnitsData:GetUnitDataFromID(numericID)
                                if unitInfo and unitInfo.Directory then
                                    numericID = unitInfo.Directory
                                end
                            end)
                        end
                        if type(numericID) == "string" and tonumber(numericID) then
                            numericID = tonumber(numericID)
                        end
                        
                        -- ⭐⭐⭐ FIX: ใช้ระบบวางปกติ (U-center) แทนการ offset จาก unit
                        local targetPos = nil
                        local unitRange = 25  -- Default range
                        
                        -- ดึง Range จาก unit data ถ้ามี
                        pcall(function()
                            if bestUnit.Data and bestUnit.Data.Range then
                                unitRange = bestUnit.Data.Range
                            end
                        end)
                        
                        -- ⭐⭐⭐ PRIORITY: Caloric Stone Clone → วางหน้าประตูเสมอ (ทุกด่าน)
                        print(string.format("[Analysis] 🔍 Caloric Clone: %s - วางหน้าประตู (Range: %d)", unitName, unitRange))
                        pcall(function()
                            targetPos = GetBestFrontPosition(unitRange)
                            if targetPos then
                                print(string.format("[Analysis] ✅ Caloric Clone พบตำแหน่งหน้าประตู: (%.1f, %.1f, %.1f)", 
                                    targetPos.X, targetPos.Y, targetPos.Z))
                            end
                        end)
                        
                        -- ⭐ Fallback วิธี 1: ใช้ GetBestPlacementPosition (U-center system)
                        if not targetPos then
                            pcall(function()
                                targetPos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, bestUnit.Data)
                            end)
                        end
                        
                        -- ⭐ วิธี 2: Fallback หา U-center โดยตรง
                        if not targetPos then
                            pcall(function()
                                local uCenters = CachedUCenters
                                if uCenters and #uCenters > 0 then
                                    for _, center in ipairs(uCenters) do
                                        if not UsedUCenters[tostring(center)] then
                                            targetPos = center
                                            break
                                        end
                                    end
                                end
                            end)
                        end
                        
                        -- ⭐ วิธี 3: Fallback ใช้ตำแหน่งใกล้ unit ที่มีอยู่
                        if not targetPos then
                            pcall(function()
                                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                                    for unitGuid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                                        if unit.Position then
                                            local isEmergencyUnit = EmergencyUnits and EmergencyUnits[unitGuid]
                                            if not isEmergencyUnit then
                                                targetPos = unit.Position + Vector3.new(4, 0, 0)
                                                break
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                        
                        if not targetPos then
                            print("[Skill] ⚠️ Caloric Clone - ไม่พบตำแหน่งวาง")
                            return
                        end
                        
                        -- ⭐ Fire Render event ตาม format ของ PlaceUnit ปกติ
                        -- แต่ใช้ FromUnitGUID แทน SlotIndex
                        local renderSuccess = false
                        pcall(function()
                            if UnitEvent then
                                UnitEvent:FireServer("Render", {
                                    unitName,      -- [1] Name
                                    numericID,     -- [2] ID (numeric)
                                    targetPos,     -- [3] Position
                                    0              -- [4] Rotation
                                }, {
                                    FromUnitGUID = guid  -- ⭐ ใช้ FromUnitGUID แทน SlotIndex
                                })
                                renderSuccess = true
                            end
                        end)
                        
                        if renderSuccess then
                            print(string.format("[Skill] ✅ Caloric Clone วางที่ (%.1f, %.1f, %.1f)", 
                                targetPos.X, targetPos.Y, targetPos.Z))
                            
                            -- ⭐⭐⭐ FIX: Verify placement - รอจนกว่า unit จะปรากฏในแมพ
                            local cloneFound = false
                            local maxRetries = 10
                            local retryDelay = 0.5
                            
                            for retry = 1, maxRetries do
                                task.wait(retryDelay)
                                
                                pcall(function()
                                    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                                        for unitGuid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                                            if unit.Name == unitName and unit.Position then
                                                local dist = (unit.Position - targetPos).Magnitude
                                                if dist < 10 then
                                                    CaloricCloneUnits[unitGuid] = true
                                                    cloneFound = true
                                                    print(string.format("[Skill] 📌 Caloric Clone ปรากฏแล้ว: %s (retry #%d)", unitName, retry))
                                                end
                                            end
                                        end
                                    end
                                end)
                                
                                if cloneFound then break end
                                
                                -- ⭐ Retry placement ถ้ายังไม่เจอ
                                if retry < maxRetries and not cloneFound then
                                    print(string.format("[Skill] ⏳ Caloric Clone ยังไม่เจอ - retry #%d...", retry))
                                    pcall(function()
                                        if UnitEvent then
                                            UnitEvent:FireServer("Render", {
                                                unitName, numericID, targetPos, 0
                                            }, { FromUnitGUID = guid })
                                        end
                                    end)
                                end
                            end
                            
                            -- ⭐ Set flag เฉพาะเมื่อเจอ clone จริง
                            if cloneFound then
                                _G.APSkill.WorldItemUsedThisMatch = true
                                print("[Skill] ✅ Caloric Clone placement verified!")
                            else
                                print("[Skill] ⚠️ Caloric Clone - ไม่พบ unit หลังจาก retry ครบ")
                            end
                        else
                            print("[Skill] ⚠️ Caloric Clone - Render failed")
                        end
                    end)
                end
            end
            
            itemToUse = "Caloric Stone"
        
        -- Ouroboros: ใช้เฉพาะด่านที่มี >= 50 waves + ถึง max wave
        elseif isMaxWave and stageInfo.MaxWave >= 50 and WorldItemEvent then
            itemToUse = "Ouroboros"
            
            success, err = pcall(function()
                WorldItemEvent:FireServer(guid, itemToUse)
            end)
            
            if success then
                print(string.format("[Skill] 🔴 Ouroboros (%d/%d)", CurrentWave, MaxWave))
            end
        else
            return false
        end
    
    -- 9. Default: ใช้ AbilityEvent (Activate)
    elseif AbilityEvent then
        success, err = pcall(function()
            AbilityEvent:FireServer("Activate", guid, abilityName)
        end)
    else
        return false
    end
    
    if success then
        -- อัพเดท tracking
        AbilityLastUsed[abilityKey] = tick()
        if abilityInfo.IsOneTime then
            AbilityUsedOnce[abilityKey] = true
        end
        
        -- ✅ Log สั้นๆ (แสดงเสมอ)
        print(string.format("[Skill] ✅ %s → %s", unitName, abilityName))
        return true
    else
        return false
    end
end

-- ===== AUTO USE ABILITIES (MAIN LOOP) =====
local MAX_ABILITIES_PER_CHECK = 5  -- ⏱️ ใช้ได้สูงสุด 5 abilities ต่อรอบเช็ค

local function AutoUseAbilitiesV3()
    -- ⏱️ Throttle
    local now = tick()
    if now - LastAutoSkillCheck < AUTO_SKILL_CHECK_INTERVAL then
        return 0
    end
    LastAutoSkillCheck = now
    
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then
        return 0
    end
    
    local totalUnits = 0
    for _ in pairs(ClientUnitHandler._ActiveUnits) do
        totalUnits = totalUnits + 1
    end
    
    if totalUnits == 0 then
        return 0
    end
    
    local abilitiesUsed = 0
    local abilitiesChecked = 0
    
    -- วนลูปทุก units
    for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
        if abilitiesUsed >= MAX_ABILITIES_PER_CHECK then break end
        if not unit then continue end
        
        -- ⭐⭐⭐ FIX: เช็ค Ownership สำหรับ Multiplayer - ใช้เฉพาะ unit ของตัวเอง
        local isMyUnit = true
        pcall(function()
            local ownerUserId = unit.OwnerUserId or unit.OwnerId or unit.UserId
            if ownerUserId and ownerUserId ~= plr.UserId then
                isMyUnit = false
            end
            -- เช็คจาก PlayerName หรือ Owner
            local ownerName = unit.OwnerName or unit.PlayerName or unit.Owner
            if ownerName and ownerName ~= plr.Name then
                isMyUnit = false
            end
        end)
        
        if not isMyUnit then continue end  -- ข้าม unit ของคนอื่น
        
        local unitName = unit.Name or "Unknown"
        local abilities = unit.ActiveAbilities or unit.Abilities or {}
        
        if #abilities == 0 then continue end
        
        -- วนลูปทุก abilities
        for abilityIndex, abilityData in ipairs(abilities) do
            if abilitiesUsed >= MAX_ABILITIES_PER_CHECK then break end
            
            -- ดึงชื่อ ability
            local abilityName = nil
            if type(abilityData) == "string" then
                abilityName = abilityData
            elseif type(abilityData) == "table" then
                abilityName = abilityData.Name or abilityData.AbilityName or abilityData.name or abilityData.DisplayName
            end
            
            if not abilityName or abilityName == "" then continue end
            if abilityName:find("Passive") or abilityName:find("PASSIVE") then continue end
            
            abilitiesChecked = abilitiesChecked + 1
            
            local abilityInfo = AnalyzeAbility(abilityName)
            local canUse, reason = CanUseAbility(unit, abilityName, abilityInfo)
            
            if canUse then
                local success = UseAbilityV3(unit, abilityName, abilityInfo)
                
                if success then
                    abilitiesUsed = abilitiesUsed + 1
                    task.wait(0.1)
                end
            end
        end
    end
    
    return abilitiesUsed
end

-- ===== AUTO NUMBER PAD (สำหรับ Imprisoned Island) =====
-- กรองจากเกมเท่านั้น - เก็บ wave ที่ boss spawn (สีเขียว #83f2ae)
_G.NumberPad = {
    BossWaves = {},
    LastCheck = 0,
    CodeAccepted = false,
    LastWaveText = "",
    MapLogged = false,
    LastDebug = 0,
}

-- ฟังก์ชันเช็คสีเขียวจาก WavesAmount UI
local function CheckBossWaveFromUI()
    local success, result = pcall(function()
        local wavesAmount = plr.PlayerGui.HUD.Map.WavesAmount
        if wavesAmount and wavesAmount.Text then
            return wavesAmount.Text
        end
        return nil
    end)
    return success and result or nil
end

-- ฟังก์ชันดึง wave number จาก text (เช่น "<stroke...>7</font>..." → 7)
local function ExtractWaveNumber(text)
    if not text then return nil end
    -- หา pattern: <font transparency="0">NUMBER</font>
    local wave = text:match('<font transparency="0">(%d+)</font>')
    if wave then
        return tonumber(wave)
    end
    return nil
end

local function AutoNumberPad()
    if _G.NumberPad.CodeAccepted then return end
    if not NumberPadEvent then return end
    
    -- เช็คว่ามี NumberPadInteract หรือไม่
    local hasNumberPad = false
    pcall(function()
        local map = workspace:FindFirstChild("Map")
        if map then
            local models = map:FindFirstChild("Models")
            if models then
                hasNumberPad = models:FindFirstChild("NumberPadInteract") ~= nil
            end
        end
        
        if not _G.NumberPad.MapLogged then
            print(string.format("[NumberPad] 📍 HasNumberPad: %s", tostring(hasNumberPad)))
            _G.NumberPad.MapLogged = true
        end
    end)
    
    if not hasNumberPad then return end
    
    local now = tick()
    
    -- เช็ค UI ทุก 0.2 วินาที (เร็วขึ้นเพื่อไม่พลาด)
    if now - _G.NumberPad.LastCheck < 0.2 then return end
    _G.NumberPad.LastCheck = now
    
    -- ⭐ สแกนหา boss waves ทั้งหมดจาก UI (ดึงทุกตัวที่เป็นสีเขียว)
    pcall(function()
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.RichText then
                local text = gui.Text or ""
                -- เช็คว่าเป็นสีเขียว (Boss wave)
                if text:find("#83f2ae") then
                    -- ดึงทุก wave number จาก text
                    for waveStr in text:gmatch('<font transparency="0">(%d+)</font>') do
                        local waveNum = tonumber(waveStr)
                        if waveNum and not table.find(_G.NumberPad.BossWaves, waveNum) then
                            table.insert(_G.NumberPad.BossWaves, waveNum)
                            table.sort(_G.NumberPad.BossWaves)
                            print(string.format("[NumberPad] 🟢 Boss Wave: %d (รวม %d waves)", waveNum, #_G.NumberPad.BossWaves))
                        end
                    end
                end
            end
        end
    end)
    
    -- Debug: แสดงสถานะทุก 10 วินาที
    if not _G.NumberPad.LastDebug or now - _G.NumberPad.LastDebug > 10 then
        print(string.format("[NumberPad] 📊 Boss Waves: %s (%d/4)", 
            #_G.NumberPad.BossWaves > 0 and table.concat(_G.NumberPad.BossWaves, ", ") or "ยังไม่มี",
            #_G.NumberPad.BossWaves))
        _G.NumberPad.LastDebug = now
    end
    
    -- ถ้าได้ครบ 4 ตัวแล้ว → ส่งรหัส
    if #_G.NumberPad.BossWaves >= 4 then
        local code = {}
        for i = 1, 4 do
            table.insert(code, _G.NumberPad.BossWaves[i] % 10)
        end
        
        local codeStr = table.concat(code, "")
        print(string.format("[NumberPad] 🔢 ส่งรหัส: %s (จาก Boss Waves: %s)", codeStr, table.concat(_G.NumberPad.BossWaves, ", ")))
        
        pcall(function()
            NumberPadEvent:FireServer("InputCode", code)
        end)
        
        task.wait(1)
    end
end

-- Listen for NumberPad response
pcall(function()
    if NumberPadEvent then
        NumberPadEvent.OnClientEvent:Connect(function(action, ...)
            if action == "CodeAccepted" then
                _G.NumberPad.CodeAccepted = true
                print("[NumberPad] ✅ รหัสถูกต้อง!")
            elseif action == "CodeRejected" then
                print(string.format("[NumberPad] ❌ รหัสผิด - Boss Waves: %s", table.concat(_G.NumberPad.BossWaves, ", ")))
            end
        end)
    end
end)

-- ===== AUTO REPLAY SYSTEM =====
_G.AutoReplay = {
    LastVote = 0,
    VoteCooldown = 1,
}

local function AutoVoteReplay_Legacy()
    if not _G.VoteEvent then return end
    local now = tick()
    if now - _G.AutoReplay.LastVote < _G.AutoReplay.VoteCooldown then return end
    _G.AutoReplay.LastVote = now
    pcall(function()
        _G.VoteEvent:FireServer("Retry")
        print("[AutoReplay] 🔄 Voted for Replay/Retry")
    end)
end

-- ===== AUTO PORTAL SYSTEM =====
_G.AutoPortal = {
    LastAction = 0,
    ActionCooldown = 2,
}

-- ฟังก์ชันเลือก Portal อัตโนมัติ (เลือกตัวที่ดีที่สุด)
local function AutoSelectPortal()
    if not _G.PortalPlayEvent then return end
    
    local now = tick()
    if now - _G.AutoPortal.LastAction < _G.AutoPortal.ActionCooldown then return end
    
    -- เช็คว่ามี Portal Data หรือไม่
    local hasPortalData = false
    local portalGUID = nil
    
    pcall(function()
        local GameHandler = require(ReplicatedStorage.Modules.Gameplay.GameHandler)
        if GameHandler and GameHandler.GameData and GameHandler.GameData.PortalData then
            hasPortalData = true
            
            -- หา Portal ที่ดีที่สุดจาก PortalStorageHandler
            local PortalStorage = require(ReplicatedStorage.Modules.Gameplay.Portals.PortalStorageHandler)
            if PortalStorage and PortalStorage.GetPortals then
                local portals = PortalStorage.GetPortals()
                if portals then
                    -- เลือก Portal แรกที่เจอ (หรือสามารถปรับให้เลือกตาม Rarity)
                    for guid, portal in pairs(portals) do
                        portalGUID = guid
                        break
                    end
                end
            end
        end
    end)
    
    if hasPortalData and portalGUID then
        _G.AutoPortal.LastAction = now
        pcall(function()
            _G.PortalPlayEvent:FireServer("Select", portalGUID)
            print(string.format("[AutoPortal] 🌀 Selected Portal: %s", tostring(portalGUID)))
        end)
    end
end

-- ===== LEGACY FUNCTIONS (เก็บไว้เพื่อ compatibility) =====
local function EnableAutoSkill()
    -- ไม่ต้องทำอะไร - ใช้ AutoUseAbilitiesV3() แทน
end

-- ===== AUTO SKILL V2 (OLD - เก็บไว้เพื่อ fallback) =====
local function GetAbilityType(abilityData)
    if not abilityData then return "Unknown", 0, false end
    
    -- 🔍 อ่านข้อมูลจาก ability data จริง
    local abilityName = abilityData.Name or ""
    local abilityType = abilityData.Type or ""  -- ประเภท ability
    local requiresTarget = abilityData.RequiresTarget or abilityData.NeedsTarget or false
    local cooldown = abilityData.Cooldown or abilityData.CooldownTime or 5
    local maxUses = abilityData.MaxUses or abilityData.Uses or math.huge
    local instant = abilityData.Instant or abilityData.AutoCast or false
    
    -- 🎯 วิเคราะห์ประเภทจาก data
    -- Priority 1: เช็คจาก Type property
    if abilityType == "Ultimate" or abilityType == "Special" then
        return "OneTime", cooldown, requiresTarget
    elseif abilityType == "Targeted" or abilityType == "Placement" then
        return "Target", cooldown, true
    elseif abilityType == "Instant" or abilityType == "Buff" or abilityType == "AutoCast" then
        return "AutoCast", cooldown, false
    end
    
    -- Priority 2: เช็คจาก MaxUses
    if maxUses == 1 then
        return "OneTime", cooldown, requiresTarget
    end
    
    -- Priority 3: เช็คจาก RequiresTarget
    if requiresTarget then
        return "Target", cooldown, true
    end
    
    -- Priority 4: เช็คจาก Instant flag
    if instant then
        return "AutoCast", cooldown, false
    end
    
    -- Default: ถือว่าเป็น AutoCast (ใช้ได้ทันที)
    return "AutoCast", cooldown, false
end

IsBossEnemy = function(enemy)
    if not enemy then return false end
    
    -- เช็คจาก Data.IsBoss
    if enemy.Data and enemy.Data.IsBoss == true then return true end
    
    -- เช็คจากชื่อ
    local enemyName = enemy.Name or ""
    if enemyName:find("Boss") or enemyName:find("boss") or enemyName:find("BOSS") then 
        return true 
    end
    
    -- เช็คจาก HP (Boss มี HP > 10000)
    local maxHP = enemy.MaxHealth or enemy.Health or 0
    if maxHP > 10000 then return true end
    
    return false
end

local function UseAbilityV2(unit, abilityData, targetPosition)
    if not unit or not abilityData then return false end
    
    local networking = ReplicatedStorage:FindFirstChild("Networking")
    if not networking then return false end
    
    local unitEvent = networking:FindFirstChild("UnitEvent")
    if not unitEvent then return false end
    
    -- Fire ability ไป server
    local success = pcall(function()
        if targetPosition then
            unitEvent:FireServer("UseAbility", unit.UniqueIdentifier, abilityData, targetPosition)
        else
            unitEvent:FireServer("UseAbility", unit.UniqueIdentifier, abilityData)
        end
    end)
    
    return success
end

local function AutoUseAbilities()
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then return end
    
    local currentTime = tick()
    local skillsUsed = 0
    
    for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
        if unit.ActiveAbilities and #unit.ActiveAbilities > 0 then
            for _, abilityData in ipairs(unit.ActiveAbilities) do
                -- อ่านข้อมูลจาก ability data
                local abilityName = abilityData.Name or tostring(abilityData)
                local abilityKey = guid .. "_" .. abilityName
                
                -- เช็คว่าเคยใช้ไปแล้วหรือยัง (one-time)
                local shouldSkip = AbilityUsedOnce[abilityKey] == true
                
                if not shouldSkip then
                    -- เช็ค cooldown
                    local lastUsedTime = AbilityLastUsed[abilityKey] or 0
                    local abilityType, cooldown, requiresTarget = GetAbilityType(abilityData)
                    
                    if currentTime - lastUsedTime >= cooldown then
                        -- ใช้ ability ตามประเภท
                        if abilityType == "OneTime" then
                            -- ใช้เฉพาะกับ Boss
                            local enemies = GetEnemies()
                            for _, enemy in ipairs(enemies) do
                                if IsBossEnemy(enemy) then
                                    local targetPos = enemy.Position or (enemy.Model and enemy.Model:GetPivot().Position)
                                    if targetPos then
                                        local success = UseAbilityV2(unit, abilityData, requiresTarget and targetPos or nil)
                                        if success then
                                            AbilityUsedOnce[abilityKey] = true
                                            AbilityLastUsed[abilityKey] = currentTime
                                            skillsUsed = skillsUsed + 1
                                            DebugPrint(string.format("💥 [Boss Skill] %s → %s (Type: %s)", 
                                                abilityName, enemy.Name, abilityData.Type or "Unknown"))
                                        end
                                        break
                                    end
                                end
                            end
                            
                        elseif abilityType == "Target" then
                            -- ใช้กับ enemy ที่แข็งแรงที่สุด
                            local enemies = GetEnemies()
                            if #enemies > 0 then
                                local strongestEnemy = nil
                                local maxHealth = 0
                                for _, enemy in ipairs(enemies) do
                                    local hp = enemy.Health or enemy.MaxHealth or 0
                                    if hp > maxHealth then
                                        maxHealth = hp
                                        strongestEnemy = enemy
                                    end
                                end
                                if strongestEnemy then
                                    local targetPos = strongestEnemy.Position or (strongestEnemy.Model and strongestEnemy.Model:GetPivot().Position)
                                    if targetPos then
                                        local success = UseAbilityV2(unit, abilityData, targetPos)
                                        if success then
                                            AbilityLastUsed[abilityKey] = currentTime
                                            skillsUsed = skillsUsed + 1
                                            DebugPrint(string.format("🎯 [Target Skill] %s → %s (Type: %s, CD: %.1fs)", 
                                                abilityName, strongestEnemy.Name, abilityData.Type or "Unknown", cooldown))
                                        end
                                    end
                                end
                            end
                            
                        elseif abilityType == "AutoCast" then
                            -- ใช้ได้ทันที (ไม่ต้องระบุ target)
                            local success = UseAbilityV2(unit, abilityData, nil)
                            if success then
                                AbilityLastUsed[abilityKey] = currentTime
                                skillsUsed = skillsUsed + 1
                                DebugPrint(string.format("⚡ [Auto Skill] %s (Unit: %s, Type: %s, CD: %.1fs)", 
                                    abilityName, unit.Name, abilityData.Type or "Unknown", cooldown))
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ===== HOTBAR SYSTEM =====
local function GetUnitRange(unitData)
    -- ===== ดึงระยะยิงจาก UnitData เท่านั้น (ไม่ print log เพื่อลด spam) =====
    if not unitData then 
        return nil 
    end
    
    local range = nil
    
    -- ===== Priority 1: Base Range (ระยะพื้นฐานก่อนอัพเกรด) =====
    if unitData.BaseRange then
        range = unitData.BaseRange
    elseif unitData.Base and unitData.Base.Range then
        range = unitData.Base.Range
    end
    
    -- ===== Priority 2: Level 0/1 Range จาก Upgrades =====
    if not range and unitData.Upgrades then
        local firstUpgrade = unitData.Upgrades[0] or unitData.Upgrades[1] or unitData.Upgrades["0"] or unitData.Upgrades["1"]
        if firstUpgrade then
            if firstUpgrade.Range then
                range = firstUpgrade.Range
            elseif firstUpgrade.Stats and firstUpgrade.Stats.Range then
                range = firstUpgrade.Stats.Range
            end
        end
    end
    
    -- ===== Priority 3: Range ปกติ =====
    if not range then
        if unitData.Range then
            range = unitData.Range
        elseif unitData.AttackRange then
            range = unitData.AttackRange
        end
    end
    
    -- ===== Priority 4: จาก Stats =====
    if not range and unitData.Stats then
        if unitData.Stats.Range then
            range = unitData.Stats.Range
        elseif unitData.Stats.AttackRange then
            range = unitData.Stats.AttackRange
        elseif unitData.Stats.BaseRange then
            range = unitData.Stats.BaseRange
        end
    end
    
    -- ===== Priority 5: ค้นหาใน nested data =====
    if not range then
        for key, value in pairs(unitData) do
            if type(key) == "string" and key:lower():find("range") and type(value) == "number" then
                range = value
                break
            end
        end
    end
    
    -- ไม่ print log เพื่อลด spam
    return range
end

GetHotbarUnits = function()
    local units = {}
    
    if UnitsHUD and UnitsHUD._Cache then
        for i, v in pairs(UnitsHUD._Cache) do
            if v ~= "None" and v ~= nil then
                local unitData = v.Data or v
                local price = unitData.Cost or unitData.Price or v.Cost or 0
                local isIncome = IsIncomeUnit(unitData.Name or v.Name, unitData)
                local isBuff = IsBuffUnit(unitData.Name or v.Name, unitData)
                local unitRange = GetUnitRange(unitData)
                
                units[i] = {
                    Slot = i,
                    Name = unitData.Name or v.Name or "Unknown",
                    ID = unitData.ID or unitData.Identifier or i,
                    Price = price,
                    Range = unitRange,  -- เพิ่ม Range
                    Data = unitData,
                    UnitObject = v,  -- ⭐ เก็บ UnitObject ตัวเต็ม (มี .Trait อยู่ในนี้!)
                    IsIncome = isIncome,
                    IsBuff = isBuff,
                    IsDamage = not isIncome and not isBuff,
                }
            end
        end
    end
    
    return units
end

GetSlotLimit = function(slot)
    -- หาข้อมูล unit จาก hotbar
    local hotbar = GetHotbarUnits()
    local unit = hotbar[slot]
    
    if not unit then 
        return 99, 0 
    end
    
    -- ⭐ หา Max Limit จาก GlobalMatchSettings
    local maxLimit = 99
    if GlobalMatchSettings and GlobalMatchSettings.GetUnitPlacementCap then
        local success, result = pcall(function()
            return GlobalMatchSettings.GetUnitPlacementCap(unit.Name, plr)
        end)
        if success and result then
            maxLimit = result
        end
    end
    
    -- นับจำนวนที่วางแล้วจาก ActiveUnits
    local currentCount = 0
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == plr then
                local unitName = unitData.Name or ""
                -- เทียบชื่อ unit ให้ตรงกับ slot
                if unitName == unit.Name or unitName == unit.ID then
                    currentCount = currentCount + 1
                end
            end
        end
    end
    
    return maxLimit, currentCount
end

local function CanPlaceSlot(slot)
    local limit, current = GetSlotLimit(slot)
    return current < limit
end

-- ===== ACTIVE UNITS (จาก Decom.lua) =====
-- จาก Decom: ClientUnitHandler._ActiveUnits[guid] = unit data
-- จาก Decom: unit.Data.CurrentUpgrade = level ปัจจุบัน
-- จาก Decom: unit.Data.UnitType = "Farm" / "Support" / อื่นๆ

GetActiveUnits = function()
    local units = {}
    
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == plr then
                local pos = nil
                if unitData.Model and unitData.Model:FindFirstChild("HumanoidRootPart") then
                    pos = unitData.Model.HumanoidRootPart.Position
                end
                
                -- ⭐ จาก Decom: unitData.Data.CurrentUpgrade คือ level ปัจจุบัน
                -- โครงสร้าง: unitData มี .Data ซึ่งมี .CurrentUpgrade และ .Upgrades
                
                table.insert(units, {
                    GUID = guid,
                    Name = unitData.Name or guid,
                    Position = pos,
                    Data = unitData.Data or unitData,  -- ⭐ ใช้ unitData.Data ตาม Decom
                    Model = unitData.Model,
                    CanSell = unitData.CanSell ~= false
                })
            end
        end
    end
    
    return units
end

-- ===== PRIORITY SYSTEM =====
-- ⭐⭐⭐ ฟังก์ชันสำหรับตั้ง Priority ของ Unit
-- Priority modes: "First", "Closest", "Last", "Strongest", "Weakest", "Bosses"
SetPriority = function(unit, priorityMode)
    if not unit then
        DebugPrint("⚠️ SetPriority: ไม่มี unit")
        return false
    end
    
    if not priorityMode then
        DebugPrint("⚠️ SetPriority: ไม่มี priorityMode")
        return false
    end
    
    -- ⭐⭐⭐ FIX: ใช้ Model.Name แทน GUID (ตาม screenshot ที่ user ให้มา)
    -- FireServer("ChangePriority", Model.Name, ChangePriority)
    local success = false
    pcall(function()
        if unit.Model and unit.Model.Name then
            -- ใช้ UnitEvent:FireServer แบบเดียวกับ screenshot
            UnitEvent:FireServer(
                "ChangePriority",
                unit.Model.Name,  -- ⭐ ใช้ Model.Name แทน GUID
                priorityMode      -- ⭐ ส่ง Priority Mode โดยตรง (string)
            )
            
            success = true
            DebugPrint(string.format("✅ SetPriority: %s (Model: %s) → %s", 
                unit.Name, unit.Model.Name, priorityMode))
        else
            DebugPrint(string.format("⚠️ SetPriority: ไม่พบ Model.Name สำหรับ %s", unit.Name or "Unknown"))
        end
    end)
    
    return success
end

-- ===== PLACEABLE POSITIONS =====
local function GetPlaceablePositions()
    local positions = {}
    local spacing = 4  -- Hard-coded spacing
    
    -- วิธี 1: PlacementAreas
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local PlacementAreas = Map:FindFirstChild("PlacementAreas")
        if PlacementAreas then
            for _, area in pairs(PlacementAreas:GetDescendants()) do
                if area:IsA("BasePart") then
                    local size = area.Size
                    local cf = area.CFrame
                    local edgeMargin = math.max(spacing, 2)
                    
                    for x = -size.X/2 + edgeMargin, size.X/2 - edgeMargin, spacing do
                        for z = -size.Z/2 + edgeMargin, size.Z/2 - edgeMargin, spacing do
                            local localPos = Vector3.new(x, 0.5, z)
                            local worldPos = cf:PointToWorldSpace(localPos)
                            
                            -- เช็คว่าถูกใช้แล้วหรือยัง
                            local occupied = false
                            for _, placedPos in pairs(PlacedPositions) do
                                if (placedPos - worldPos).Magnitude < spacing then
                                    occupied = true
                                    break
                                end
                            end
                            
                            -- เช็คกับ Units ที่วางอยู่แล้ว
                            if not occupied then
                                local activeUnits = GetActiveUnits()
                                for _, unit in pairs(activeUnits) do
                                    if unit.Position and (unit.Position - worldPos).Magnitude < spacing then
                                        occupied = true
                                        break
                                    end
                                end
                            end
                            
                            if not occupied then
                                table.insert(positions, worldPos)
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- วิธี 2: CollectionService
    if #positions == 0 then
        pcall(function()
            local taggedAreas = CollectionService:GetTagged("PlacementArea")
            for _, area in pairs(taggedAreas) do
                if area:IsA("BasePart") then
                    local size = area.Size
                    local cf = area.CFrame
                    
                    for x = -size.X/2 + spacing, size.X/2 - spacing, spacing do
                        for z = -size.Z/2 + spacing, size.Z/2 - spacing, spacing do
                            local localPos = Vector3.new(x, size.Y/2 + 0.5, z)
                            local worldPos = cf:PointToWorldSpace(localPos)
                            table.insert(positions, worldPos)
                        end
                    end
                end
            end
        end)
    end
    
    -- วิธี 3: Fallback - รอบๆ path
    if #positions == 0 then
        local path = GetMapPath()
        if #path > 0 then
            for _, pathPos in pairs(path) do
                for offset = -10, 10, 5 do
                    local pos1 = pathPos + Vector3.new(offset, 2, 0)
                    local pos2 = pathPos + Vector3.new(0, 2, offset)
                    
                    local onPath = false
                    for _, p in pairs(path) do
                        if (p - pos1).Magnitude < 3 then onPath = true break end
                    end
                    if not onPath then table.insert(positions, pos1) end
                    
                    onPath = false
                    for _, p in pairs(path) do
                        if (p - pos2).Magnitude < 3 then onPath = true break end
                    end
                    if not onPath then table.insert(positions, pos2) end
                end
            end
        end
    end
    
    -- ไม่ print log เพื่อลด spam (เคยมี:)
    if #positions == 0 then
    end
    return positions
end

-- ===== คำนวณ U-Shape Centers (แยกออกมาเพื่อ cache) =====
local function CalculateUShapeCenters(path, unitRange)
    local corners = {}
    
    -- หามุมโค้ง (เก็บทิศทางด้านใน)
    for i = 2, #path - 1 do
        local prev = path[i-1]
        local curr = path[i]
        local next = path[i+1]
        
        local dir1 = Vector3.new(curr.X - prev.X, 0, curr.Z - prev.Z)
        local dir2 = Vector3.new(next.X - curr.X, 0, next.Z - curr.Z)
        
        if dir1.Magnitude > 0.1 and dir2.Magnitude > 0.1 then
            dir1 = dir1.Unit
            dir2 = dir2.Unit
            local dot = math.clamp(dir1.X * dir2.X + dir1.Z * dir2.Z, -1, 1)
            local angle = math.deg(math.acos(dot))
            
            if angle >= 30 then
                local outward = -(dir1 + dir2)
                if outward.Magnitude > 0.1 then outward = outward.Unit end
                local inward = -outward
                
                table.insert(corners, {
                    Position = curr,
                    Index = i,
                    Angle = angle,
                    OutwardDir = outward,
                    InwardDir = inward,
                })
            end
        end
    end
    
    -- หาจุดศูนย์กลางของ U-Shape
    local uShapeCenters = {}
    
    local function LineLineIntersection(p1, d1, p2, d2)
        local dx = p2.X - p1.X
        local dz = p2.Z - p1.Z
        local cross = d1.X * d2.Z - d1.Z * d2.X
        
        if math.abs(cross) < 0.001 then
            return (p1 + p2) / 2, false
        end
        
        local t1 = (dx * d2.Z - dz * d2.X) / cross
        local intersection = Vector3.new(
            p1.X + t1 * d1.X,
            (p1.Y + p2.Y) / 2,
            p1.Z + t1 * d1.Z
        )
        
        return intersection, t1 > 0
    end
    
    for i = 1, #corners do
        for j = i + 1, #corners do
            local corner1 = corners[i]
            local corner2 = corners[j]
            local distBetweenCorners = (corner1.Position - corner2.Position).Magnitude
            
            if distBetweenCorners <= unitRange * 2.5 and distBetweenCorners >= 8 then
                local centerPoint, isValid = LineLineIntersection(
                    corner1.Position, corner1.InwardDir,
                    corner2.Position, corner2.InwardDir
                )
                
                local dist1 = (centerPoint - corner1.Position).Magnitude
                local dist2 = (centerPoint - corner2.Position).Magnitude
                
                if dist1 <= unitRange * 1.5 and dist2 <= unitRange * 1.5 and dist1 >= 3 and dist2 >= 3 then
                    local onPath = false
                    for _, node in ipairs(path) do
                        if (centerPoint - node).Magnitude < 4 then
                            onPath = true
                            break
                        end
                    end
                    
                    if not onPath then
                        local distDiff = math.abs(dist1 - dist2)
                        local score = 100 + (corner1.Angle + corner2.Angle)
                        
                        if distDiff < 3 then
                            score = score + (300 - distDiff * 50)
                        end
                        if dist1 <= unitRange and dist2 <= unitRange then
                            score = score + 400
                        end
                        
                        local inwardAlign = corner1.InwardDir:Dot(corner2.InwardDir)
                        if inwardAlign < 0 then
                            score = score + math.abs(inwardAlign) * 200
                        end
                        
                        table.insert(uShapeCenters, {
                            Position = centerPoint,
                            Corner1 = corner1,
                            Corner2 = corner2,
                            Distance = distBetweenCorners,
                            DistToCorner1 = dist1,
                            DistToCorner2 = dist2,
                            DistDiff = distDiff,
                            Score = score,
                            Used = false,  -- เพิ่ม flag ว่าใช้แล้วหรือยัง
                        })
                    end
                end
            end
        end
    end
    
    -- เรียงตาม score และลบ duplicates
    table.sort(uShapeCenters, function(a, b) return a.Score > b.Score end)
    
    local filtered = {}
    for _, center in ipairs(uShapeCenters) do
        local isDuplicate = false
        for _, existing in ipairs(filtered) do
            if (center.Position - existing.Position).Magnitude < 8 then
                isDuplicate = true
                break
            end
        end
        if not isDuplicate then
            table.insert(filtered, center)
        end
    end
    
    return filtered, corners
end

-- ===== 🟠 คำนวณ Optimal Zones (จุดส้ม - พื้นที่ว่างระหว่าง Path) =====
-- ตามรูปที่วาด: หา pocket spaces ระหว่าง Path segments
local function CalculateOptimalZones(path, unitRange)
    local optimalZones = {}
    
    if #path < 4 then return optimalZones end
    
    local spawnPoint = path[1]
    local basePoint = path[#path]
    
    -- ===== วิธีการหา Optimal Zones =====
    -- 1. หา "พื้นที่ว่าง" ระหว่าง Path segments ที่ไม่ใช่ Path โดยตรง
    -- 2. ตรวจสอบว่าห่างจาก Path nodes 8-30 studs
    -- 3. ยิงถึง Path อย่างน้อย 2 nodes
    
    -- วิธี 1: หาจากมุมโค้ง (Corners)
    for i = 2, #path - 2 do
        local prev = path[i-1]
        local curr = path[i]
        local next = path[i+1]
        local next2 = path[i+2]
        
        -- คำนวณทิศทางการเลี้ยว
        local dir1 = (curr - prev)
        local dir2 = (next - curr)
        
        if dir1.Magnitude > 0.1 and dir2.Magnitude > 0.1 then
            dir1 = dir1.Unit
            dir2 = dir2.Unit
            
            -- เช็คว่ามีมุมโค้งหรือไม่
            local dot = dir1:Dot(dir2)
            local angle = math.deg(math.acos(math.clamp(dot, -1, 1)))
            
            if angle >= 30 then  -- มุมโค้ง >= 30 องศา
                -- หาจุดศูนย์กลางระหว่าง curr และ next
                local midPoint = (curr + next) / 2
                
                -- หา perpendicular direction (ตั้งฉากกับ Path)
                local avgDir = (dir1 + dir2).Unit
                local perpDir = Vector3.new(-avgDir.Z, 0, avgDir.X)  -- Rotate 90 degrees
                
                if perpDir.Magnitude > 0.1 then
                    perpDir = perpDir.Unit
                    
                    -- ทดลอง 2 ทิศทาง (ซ้าย-ขวาของ Path)
                    for _, side in ipairs({1, -1}) do
                        local testDir = perpDir * side
                        
                        -- ทดลองระยะต่างๆ ออกจาก Path
                        for offset = 10, 25, 5 do
                            local testPos = midPoint + testDir * offset
                            
                            -- เช็คว่าห่างจาก Path node อื่นๆ
                            local minDistToPath = math.huge
                            local nodesInRange = 0
                            
                            for j, node in ipairs(path) do
                                local dist = (testPos - node).Magnitude
                                minDistToPath = math.min(minDistToPath, dist)
                                
                                if dist <= unitRange then
                                    nodesInRange = nodesInRange + 1
                                end
                            end
                            
                            -- ⭐ Optimal Zone ต้อง:
                            -- 1. ห่างจาก Path 8-30 studs (ไม่ใกล้เกินไป ไม่ไกลเกินไป)
                            -- 2. ยิงถึง Path อย่างน้อย 2-3 nodes
                            -- 3. ไม่ใกล้ Spawn/Base มากเกินไป
                            local distToSpawn = (testPos - spawnPoint).Magnitude
                            local distToBase = (testPos - basePoint).Magnitude
                            
                            if minDistToPath >= 8 and minDistToPath <= 30 and 
                               nodesInRange >= 2 and
                               distToSpawn > 15 and distToBase > 15 then
                                
                                -- คำนวณ score
                                local score = 0
                                score = score + nodesInRange * 100  -- ยิงได้เยอะ = ดี
                                score = score - minDistToPath * 2   -- ไม่ไกลเกินไป
                                score = score + (angle / 90) * 50   -- มุมโค้งมาก = ดี
                                
                                table.insert(optimalZones, {
                                    Position = testPos,
                                    PathIndex = i,
                                    NodesInRange = nodesInRange,
                                    DistToPath = minDistToPath,
                                    Angle = angle,
                                    Score = score,
                                    Used = false
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- วิธี 2: หาพื้นที่ระหว่าง parallel segments (สำหรับ zigzag path)
    -- เช็ค path segments ที่ขนานกัน
    for i = 1, #path - 3 do
        for j = i + 2, #path - 1 do
            local seg1Start = path[i]
            local seg1End = path[i+1]
            local seg2Start = path[j]
            local seg2End = path[j+1]
            
            -- ระยะระหว่าง 2 segments
            local midSeg1 = (seg1Start + seg1End) / 2
            local midSeg2 = (seg2Start + seg2End) / 2
            local distBetween = (midSeg1 - midSeg2).Magnitude
            
            -- ถ้า segments ใกล้กัน (15-40 studs) = มี pocket space
            if distBetween >= 15 and distBetween <= 40 then
                local pocketCenter = (midSeg1 + midSeg2) / 2
                
                -- เช็คว่าห่างจาก Path nodes
                local minDistToPath = math.huge
                local nodesInRange = 0
                
                for _, node in ipairs(path) do
                    local dist = (pocketCenter - node).Magnitude
                    minDistToPath = math.min(minDistToPath, dist)
                    
                    if dist <= unitRange then
                        nodesInRange = nodesInRange + 1
                    end
                end
                
                if minDistToPath >= 8 and minDistToPath <= 25 and nodesInRange >= 2 then
                    local score = nodesInRange * 100 - minDistToPath * 2
                    
                    table.insert(optimalZones, {
                        Position = pocketCenter,
                        PathIndex = i,
                        NodesInRange = nodesInRange,
                        DistToPath = minDistToPath,
                        Angle = 0,
                        Score = score,
                        Used = false
                    })
                end
            end
        end
    end
    
    -- ลบ duplicate positions (ใกล้กัน < 8 studs)
    local uniqueZones = {}
    for _, zone in ipairs(optimalZones) do
        local isDuplicate = false
        for _, existing in ipairs(uniqueZones) do
            if (zone.Position - existing.Position).Magnitude < 8 then
                -- เก็บตัวที่ score สูงกว่า
                if zone.Score > existing.Score then
                    existing.Position = zone.Position
                    existing.Score = zone.Score
                    existing.NodesInRange = zone.NodesInRange
                end
                isDuplicate = true
                break
            end
        end
        
        if not isDuplicate then
            table.insert(uniqueZones, zone)
        end
    end
    
    -- Sort by score (สูงสุดก่อน)
    table.sort(uniqueZones, function(a, b)
        return a.Score > b.Score
    end)
    
    DebugPrint(string.format("🟠 Optimal Zones พบ: %d จุด", #uniqueZones))
    for i = 1, math.min(3, #uniqueZones) do
        local zone = uniqueZones[i]
        DebugPrint(string.format("   #%d: (%.1f, %.1f) | dist=%.1f, nodes=%d, score=%.0f", 
            i, zone.Position.X, zone.Position.Z, zone.DistToPath, zone.NodesInRange, zone.Score))
    end
    
    return uniqueZones
end

-- ===== คำนวณ Circular/Loop Path Center (จุดศูนย์กลางของแมพ - พื้นที่ว่างนอก path) =====
local function CalculateCircularCenters(path, unitRange)
    local circularCenters = {}
    
    if #path < 4 then return circularCenters end
    
    -- ===== หา Spawn (Green) และ Base (Red) =====
    local spawnPoint = path[1]        -- จุดเริ่มต้น (สีเขียว)
    local basePoint = path[#path]     -- จุดจบ (สีแดง)
    
    DebugPrint(string.format("🟢 Spawn: (%.1f, %.1f)", spawnPoint.X, spawnPoint.Z))
    DebugPrint(string.format("🔴 Base: (%.1f, %.1f)", basePoint.X, basePoint.Z))
    
    -- ===== คำนวณ Bounding Box ของ path =====
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    local totalX, totalY, totalZ = 0, 0, 0
    
    for i, node in ipairs(path) do
        totalX = totalX + node.X
        totalY = totalY + node.Y
        totalZ = totalZ + node.Z
        
        minX = math.min(minX, node.X)
        minY = math.min(minY, node.Y)
        minZ = math.min(minZ, node.Z)
        maxX = math.max(maxX, node.X)
        maxY = math.max(maxY, node.Y)
        maxZ = math.max(maxZ, node.Z)
    end
    
    -- ขนาดของแมพ
    local mapWidth = maxX - minX
    local mapHeight = maxZ - minZ
    local avgY = totalY / #path
    
    DebugPrint(string.format("📐 ขนาดแมพ: %.1f x %.1f", mapWidth, mapHeight))
    
    -- ===== ฟังก์ชันตรวจสอบ =====
    local function IsOnPath(point, threshold)
        threshold = threshold or 4
        for _, node in ipairs(path) do
            if (Vector3.new(point.X, avgY, point.Z) - node).Magnitude < threshold then
                return true
            end
        end
        return false
    end
    
    local function GetMinDistToPath(point)
        local minDist = math.huge
        for _, node in ipairs(path) do
            local dist = (Vector3.new(point.X, avgY, point.Z) - node).Magnitude
            minDist = math.min(minDist, dist)
        end
        return minDist
    end
    
    local function CountNodesInRange(point, range)
        local count = 0
        for _, node in ipairs(path) do
            if (Vector3.new(point.X, avgY, point.Z) - node).Magnitude <= range then
                count = count + 1
            end
        end
        return count
    end
    
    -- ===== ฟังก์ชันคำนวณ "ความคุ้มค่า" ของตำแหน่ง =====
    local function CalculateValueScore(point, range)
        local score = 0
        local nodesInRange = 0
        local directionsHit = {top = false, bottom = false, left = false, right = false}
        
        for _, node in ipairs(path) do
            local dist = (Vector3.new(point.X, avgY, point.Z) - node).Magnitude
            if dist <= range then
                nodesInRange = nodesInRange + 1
                
                -- เช็คทิศทาง
                local dx = node.X - point.X
                local dz = node.Z - point.Z
                if dz > 2 then directionsHit.top = true end
                if dz < -2 then directionsHit.bottom = true end
                if dx > 2 then directionsHit.right = true end
                if dx < -2 then directionsHit.left = true end
            end
        end
        
        -- นับจำนวนทิศทางที่ยิงได้
        local dirCount = 0
        for _, hit in pairs(directionsHit) do
            if hit then dirCount = dirCount + 1 end
        end
        
        -- คะแนนพื้นฐาน = จำนวน nodes ที่ยิงได้
        score = nodesInRange * 50
        
        -- Bonus ถ้ายิงได้หลายทิศ
        if dirCount >= 4 then
            score = score + 400
        elseif dirCount >= 3 then
            score = score + 250
        elseif dirCount >= 2 then
            score = score + 100
        end
        
        -- ===== � BONUS ใกล้ Base/จุดจบ (สำคัญมาก!) =====
        local distToBase = (Vector3.new(point.X, avgY, point.Z) - basePoint).Magnitude
        if distToBase <= range * 1.5 then
            score = score + 600 - distToBase * 3  -- ใกล้ Base มาก = Bonus สูง
        elseif distToBase <= range * 3 then
            score = score + 300 - distToBase      -- ใกล้ Base = Bonus กลาง
        end
        
        return score, nodesInRange, dirCount
    end
    
    -- ===== วิธี 0: หาจุดใกล้ Base/จุดจบ ที่ดีที่สุด (Priority สูงสุด!) =====
    -- สร้าง grid รอบๆ Base เพื่อหาจุดที่ดีที่สุด
    local baseGridStep = 5
    local baseSearchRadius = unitRange * 2
    
    for dx = -baseSearchRadius, baseSearchRadius, baseGridStep do
        for dz = -baseSearchRadius, baseSearchRadius, baseGridStep do
            local testPoint = Vector3.new(basePoint.X + dx, avgY, basePoint.Z + dz)
            
            if not IsOnPath(testPoint, 4) then
                local minDist = GetMinDistToPath(testPoint)
                
                if minDist <= unitRange and minDist >= 3 then
                    local score, nodes, dirs = CalculateValueScore(testPoint, unitRange)
                    
                    if nodes >= 2 then
                        local distToBase = (testPoint - basePoint).Magnitude
                        
                        -- Bonus พิเศษสำหรับใกล้ Base
                        score = score + 500 - distToBase * 3
                        
                        table.insert(circularCenters, {
                            Position = testPoint,
                            AvgDistance = minDist,
                            NodesInRange = nodes,
                            DirectionsHit = dirs,
                            DistToBase = distToBase,
                            Score = score,
                            Used = false,
                            Type = "near_base",
                        })
                    end
                end
            end
        end
    end
    
    DebugPrint(string.format("� หาจุดใกล้ Base: พบ %d จุด", #circularCenters))
    local midSpawnBase = Vector3.new(
        (spawnPoint.X + basePoint.X) / 2,
        avgY,
        (spawnPoint.Z + basePoint.Z) / 2
    )
    
    if not IsOnPath(midSpawnBase, 5) then
        local minDist = GetMinDistToPath(midSpawnBase)
        if minDist <= unitRange then
            local score, nodes, dirs = CalculateValueScore(midSpawnBase, unitRange)
            if nodes >= 2 then
                table.insert(circularCenters, {
                    Position = midSpawnBase,
                    AvgDistance = minDist,
                    NodesInRange = nodes,
                    DirectionsHit = dirs,
                    Score = score + 200, -- Bonus เพราะอยู่กลางแมพ
                    Used = false,
                    Type = "mid_spawn_base",
                })
                DebugPrint(string.format("✅ Mid Spawn-Base: nodes=%d, dirs=%d, score=%.0f", nodes, dirs, score + 200))
            end
        end
    end
    
    -- ===== วิธี 2: Centroid ของ path ทั้งหมด =====
    local centroid = Vector3.new(totalX / #path, avgY, totalZ / #path)
    
    if not IsOnPath(centroid, 5) and (centroid - midSpawnBase).Magnitude > 5 then
        local minDist = GetMinDistToPath(centroid)
        if minDist <= unitRange then
            local score, nodes, dirs = CalculateValueScore(centroid, unitRange)
            if nodes >= 2 then
                table.insert(circularCenters, {
                    Position = centroid,
                    AvgDistance = minDist,
                    NodesInRange = nodes,
                    DirectionsHit = dirs,
                    Score = score + 150,
                    Used = false,
                    Type = "centroid",
                })
                DebugPrint(string.format("✅ Centroid: nodes=%d, dirs=%d, score=%.0f", nodes, dirs, score + 150))
            end
        end
    end
    
    -- ===== วิธี 3: Bounding Box Center =====
    local bboxCenter = Vector3.new((minX + maxX) / 2, avgY, (minZ + maxZ) / 2)
    
    if not IsOnPath(bboxCenter, 5) then
        local minDist = GetMinDistToPath(bboxCenter)
        if minDist <= unitRange then
            local score, nodes, dirs = CalculateValueScore(bboxCenter, unitRange)
            if nodes >= 2 then
                local isDuplicate = false
                for _, existing in ipairs(circularCenters) do
                    if (bboxCenter - existing.Position).Magnitude < 8 then
                        isDuplicate = true
                        break
                    end
                end
                if not isDuplicate then
                    table.insert(circularCenters, {
                        Position = bboxCenter,
                        AvgDistance = minDist,
                        NodesInRange = nodes,
                        DirectionsHit = dirs,
                        Score = score + 100,
                        Used = false,
                        Type = "bbox_center",
                    })
                    DebugPrint(string.format("✅ BBox Center: nodes=%d, dirs=%d, score=%.0f", nodes, dirs, score + 100))
                end
            end
        end
    end
    
    -- ===== วิธี 4: Grid Search หาจุดที่ดีที่สุด =====
    local gridStep = math.max(5, math.min(mapWidth, mapHeight) / 10)
    
    for x = minX - unitRange/2, maxX + unitRange/2, gridStep do
        for z = minZ - unitRange/2, maxZ + unitRange/2, gridStep do
            local gridPoint = Vector3.new(x, avgY, z)
            
            if not IsOnPath(gridPoint, 4) then
                local minDist = GetMinDistToPath(gridPoint)
                
                -- ต้องอยู่ในระยะยิงและไม่ใกล้เกินไป
                if minDist <= unitRange and minDist >= 3 then
                    local score, nodes, dirs = CalculateValueScore(gridPoint, unitRange)
                    
                    -- จุดที่ดีต้องมี nodes หลายตัวหรือยิงได้หลายทิศ
                    if nodes >= 3 or (nodes >= 2 and dirs >= 2) then
                        local isDuplicate = false
                        for _, existing in ipairs(circularCenters) do
                            if (gridPoint - existing.Position).Magnitude < gridStep then
                                isDuplicate = true
                                break
                            end
                        end
                        
                        if not isDuplicate then
                            table.insert(circularCenters, {
                                Position = gridPoint,
                                AvgDistance = minDist,
                                NodesInRange = nodes,
                                DirectionsHit = dirs,
                                Score = score,
                                Used = false,
                                Type = "grid",
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- ===== วิธี 5: หาจุดที่อยู่ใกล้ path และยิงได้หลาย nodes =====
    for i = 2, #path - 1 do
        local node = path[i]
        local prevNode = path[i - 1]
        local nextNode = path[i + 1]
        
        -- หาทิศทางตั้งฉากกับ path
        local pathDir = (nextNode - prevNode).Unit
        local perpDir = Vector3.new(-pathDir.Z, 0, pathDir.X)
        
        -- ลองวางทั้ง 2 ฝั่งของ path
        for _, mult in ipairs({1, -1}) do
            local offset = unitRange * 0.6
            local testPoint = Vector3.new(
                node.X + perpDir.X * offset * mult,
                avgY,
                node.Z + perpDir.Z * offset * mult
            )
            
            if not IsOnPath(testPoint, 4) then
                local minDist = GetMinDistToPath(testPoint)
                if minDist <= unitRange and minDist >= 3 then
                    local score, nodes, dirs = CalculateValueScore(testPoint, unitRange)
                    
                    if nodes >= 4 then
                        local isDuplicate = false
                        for _, existing in ipairs(circularCenters) do
                            if (testPoint - existing.Position).Magnitude < 8 then
                                isDuplicate = true
                                break
                            end
                        end
                        
                        if not isDuplicate then
                            table.insert(circularCenters, {
                                Position = testPoint,
                                AvgDistance = minDist,
                                NodesInRange = nodes,
                                DirectionsHit = dirs,
                                Score = score + 50,
                                Used = false,
                                Type = "path_adjacent",
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- ===== เรียงตาม Score (เน้นใกล้ Spawn และ nodes มาก) =====
    table.sort(circularCenters, function(a, b) 
        -- Priority 1: ประเภท near_base มาก่อน (ใกล้จุดจบ)
        if a.Type == "near_base" and b.Type ~= "near_base" then
            return true
        elseif a.Type ~= "near_base" and b.Type == "near_base" then
            return false
        end
        
        -- Priority 2: เรียงตาม Score (รวม bonus ใกล้ base แล้ว)
        return a.Score > b.Score
    end)
    
    -- ===== ลบ Duplicates และเก็บแค่ตัวดีที่สุด =====
    local filtered = {}
    for _, center in ipairs(circularCenters) do
        local isDuplicate = false
        for _, existing in ipairs(filtered) do
            if (center.Position - existing.Position).Magnitude < 8 then
                isDuplicate = true
                break
            end
        end
        if not isDuplicate then
            table.insert(filtered, center)
            local distBase = center.DistToBase or (center.Position - basePoint).Magnitude
            if #filtered <= 5 then
                DebugPrint(string.format("🎯 #%d: %s | nodes=%d, dirs=%d, distBase=%.0f, score=%.0f", 
                    #filtered, center.Type, center.NodesInRange, center.DirectionsHit or 0, distBase, center.Score))
            end
        end
    end
    
    DebugPrint(string.format("📊 พบตำแหน่งที่ดี %d จุด (เน้นใกล้ Base/จุดจบ)", #filtered))
    
    return filtered
end

-- ===== หา U-Center ที่ยังไม่ได้ใช้และเหมาะกับ unit range =====
local function GetAvailableUCenter(uShapeCenters, unitRange)
    for _, uCenter in ipairs(uShapeCenters) do
        if not uCenter.Used then
            -- เช็คว่า unit range นี้ยิงถึงทั้ง 2 ฝั่งหรือไม่ (ต้องตีถึงแน่นอน!)
            if uCenter.DistToCorner1 <= unitRange * 0.9 and uCenter.DistToCorner2 <= unitRange * 0.9 then
                return uCenter
            end
        end
    end
    return nil
end

-- ===== หาตำแหน่งสำหรับ Income Unit (แยกออกจาก Path) =====
local function GetIncomePosition(positions, path, activeUnits)
    local bestPos = nil
    local bestScore = -math.huge
    
    for _, pos in pairs(positions) do
        local score = 0
        
        -- หาระยะห่างจาก Path (ยิ่งไกลยิ่งดี!)
        local minDistToPath = math.huge
        for _, node in ipairs(path) do
            local dist = (pos - node).Magnitude
            minDistToPath = math.min(minDistToPath, dist)
        end
        
        -- ===== Bonus ไกลจาก Path =====
        if minDistToPath >= 30 then
            score = score + 500  -- ไกลมาก = ดีมาก!
        elseif minDistToPath >= 20 then
            score = score + 300
        elseif minDistToPath >= 15 then
            score = score + 150
        elseif minDistToPath >= 10 then
            score = score + 50
        else
            score = score - minDistToPath * 10  -- ใกล้ path = ลดคะแนน
        end
        
        -- ===== อยู่ห่างจาก Units อื่นหน่อย (ไม่ต้องติดกัน) =====
        for _, unit in pairs(activeUnits) do
            if unit.Position then
                local distToUnit = (pos - unit.Position).Magnitude
                if distToUnit < 8 then
                    score = score - 100  -- ใกล้เกินไป
                elseif distToUnit >= 8 and distToUnit <= 15 then
                    score = score + 50   -- ห่างพอดี
                end
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
        end
    end
    
    if bestPos then
        local minDist = math.huge
        for _, node in ipairs(path) do
            minDist = math.min(minDist, (bestPos - node).Magnitude)
        end
        DebugPrint(string.format("✅ Income Position: (%.1f, %.1f) | DistFromPath: %.0f", 
            bestPos.X, bestPos.Z, minDist))
    end
    
    return bestPos
end

-- ===== หา U-Center ที่ยังไม่ได้ใช้และเหมาะกับ unit range (เดิม) =====
local function GetAvailableUCenter(uShapeCenters, unitRange)
    for _, uCenter in ipairs(uShapeCenters) do
        if not uCenter.Used then
            -- เช็คว่า unit range นี้ยิงถึงทั้ง 2 ฝั่งหรือไม่
            if uCenter.DistToCorner1 <= unitRange and uCenter.DistToCorner2 <= unitRange then
                return uCenter
            end
        end
    end
    return nil
end

-- ===== BEST PLACEMENT POSITION =====
GetBestPlacementPosition = function(unitRange, gamePhase, unitName, unitData)
    -- ต้องมี unitRange จาก UnitData ถึงจะทำงาน
    if not unitRange then
        return nil
    end
    
    local path = GetMapPath()
    local positions = GetPlaceablePositions()
    gamePhase = gamePhase or "early"
    
    -- คำนวณ Safe Range ตาม Base Range
    local safeRange
    if unitRange <= 15 then
        safeRange = unitRange * 1.2  -- Range น้อย +20%
    elseif unitRange <= 25 then
        safeRange = unitRange * 1.15  -- Range กลาง +15%
    elseif unitRange <= 35 then
        safeRange = unitRange * 1.1   -- Range ปกติ +10%
    else
        safeRange = unitRange * 1.05  -- Range สูง +5%
    end
    
    DebugPrint(string.format("🔍 %s | Base=%.1f | Safe=%.1f (+%.0f%%)", 
        unitName or "Unknown", unitRange, safeRange, ((safeRange/unitRange - 1) * 100)))
    
    if #path == 0 then
        return #positions > 0 and positions[1] or nil
    end
    
    -- ===== เช็คว่าเป็น Income Unit หรือไม่ =====
    if IsIncomeUnit(unitName, unitData) then
        local activeUnits = GetActiveUnits()
        return GetIncomePosition(positions, path, activeUnits)
    end
    
    local bestPos = nil
    local bestScore = -math.huge
    local activeUnits = GetActiveUnits()
    
    -- ===== กำหนด Spawn Point (จุดเริ่มต้น) =====
    local spawnPoint = path[1]  -- 🟢 สีเขียว = จุดเริ่มต้น
    local basePoint = path[#path]  -- 🔴 สีแดง = จุดจบ
    
    DebugPrint(string.format("🟢 Spawn: (%.1f, %.1f) | 🔴 Base: (%.1f, %.1f)", 
        spawnPoint.X, spawnPoint.Z, basePoint.X, basePoint.Z))
    
    -- ===== หา "กลุ่มศูนย์กลาง" - ตำแหน่งที่มี Units วางอยู่แล้ว =====
    local groupCenter = nil
    local unitsPlaced = 0
    
    -- คำนวณจุดศูนย์กลางของ Units ที่วางแล้ว
    local totalX, totalY, totalZ = 0, 0, 0
    for _, unit in pairs(activeUnits) do
        if unit.Position then
            totalX = totalX + unit.Position.X
            totalY = totalY + unit.Position.Y
            totalZ = totalZ + unit.Position.Z
            unitsPlaced = unitsPlaced + 1
        end
    end
    
    -- รวม PlacedPositions ด้วย
    for _, placedPos in pairs(PlacedPositions) do
        totalX = totalX + placedPos.X
        totalY = totalY + placedPos.Y
        totalZ = totalZ + placedPos.Z
        unitsPlaced = unitsPlaced + 1
    end
    
    if unitsPlaced > 0 then
        groupCenter = Vector3.new(totalX / unitsPlaced, totalY / unitsPlaced, totalZ / unitsPlaced)
        DebugPrint(string.format("👥 Group Center: (%.1f, %.1f) | Units: %d", 
            groupCenter.X, groupCenter.Z, unitsPlaced))
    end
    
    -- Path sections (เน้นช่วงท้าย - ใกล้ Base)
    local earlyEnd = math.floor(#path * 0.5)
    local midStart = math.floor(#path * 0.3)
    local midEnd = math.floor(#path * 0.7)
    local lateStart = math.floor(#path * 0.6)
    
    -- ===== 🟠 คำนวณ Optimal Zones (จุดส้ม - พื้นที่เหมาะสม) =====
    local optimalZones = CalculateOptimalZones(path, unitRange)
    
    -- ===== คำนวณ U-Shape Centers (ใช้ Base Range เพื่อให้ตีถึงแน่นอน) =====
    local uShapeCenters, corners
    
    -- เช็คว่า cache ยังใช้ได้หรือไม่ (path เดิม)
    if #CachedUCenters > 0 then
        uShapeCenters = CachedUCenters
        corners = {}
        else
        uShapeCenters, corners = CalculateUShapeCenters(path, unitRange)
        CachedUCenters = uShapeCenters
        end
    
    -- ===== คำนวณ Circular Centers (จุดศูนย์กลางของ path วงกลม) =====
    local circularCenters = CalculateCircularCenters(path, unitRange)
    
    if #circularCenters > 0 then
        DebugPrint(string.format("⭕ Circular Centers พบ: %d | Best: avgDist=%.1f, nodes=%d, score=%.0f", 
            #circularCenters, 
            circularCenters[1].AvgDistance, 
            circularCenters[1].NodesInRange, 
            circularCenters[1].Score))
    end
    
    -- ===== Priority 0: หา Circular Center ที่ดีที่สุด (ถ้ามี) =====
    -- Circular center มี priority สูงสุดเพราะยิงได้รอบทิศทาง
    for _, circCenter in ipairs(circularCenters) do
        if not circCenter.Used and circCenter.AvgDistance <= unitRange then
            -- เช็คว่าตำแหน่งนี้ยังว่างอยู่หรือไม่
            local isOccupied = false
            for _, unit in pairs(activeUnits) do
                if unit.Position and (unit.Position - circCenter.Position).Magnitude < 5 then
                    isOccupied = true
                    break
                end
            end
            
            for _, placedPos in pairs(PlacedPositions) do
                if (placedPos - circCenter.Position).Magnitude < 5 then
                    isOccupied = true
                    break
                end
            end
            
            if not isOccupied then
                circCenter.Used = true
                table.insert(UsedUCenters, circCenter.Position)
                
                DebugPrint(string.format("⭕⭐ ใช้ CIRCULAR CENTER! (%.1f, %.1f) | avgDist=%.1f, nodes=%d | range=%.1f", 
                    circCenter.Position.X, circCenter.Position.Z, 
                    circCenter.AvgDistance, circCenter.NodesInRange, unitRange))
                
                return circCenter.Position
            end
        end
    end
    
    -- ===== Priority 0.5: 🟠 หา Optimal Zones (จุดส้ม - พื้นที่เหมาะสม) =====
    -- ใช้หลัง Circular แต่ก่อน U-Center
    for _, optZone in ipairs(optimalZones) do
        if not optZone.Used then
            -- เช็คว่าตำแหน่งนี้ยังว่างอยู่หรือไม่
            local isOccupied = false
            for _, unit in pairs(activeUnits) do
                if unit.Position and (unit.Position - optZone.Position).Magnitude < 5 then
                    isOccupied = true
                    break
                end
            end
            
            for _, placedPos in pairs(PlacedPositions) do
                if (placedPos - optZone.Position).Magnitude < 5 then
                    isOccupied = true
                    break
                end
            end
            
            if not isOccupied then
                optZone.Used = true
                
                DebugPrint(string.format("🟠⭐ ใช้ OPTIMAL ZONE! (%.1f, %.1f) | dist=%.1f, nodes=%d | range=%.1f", 
                    optZone.Position.X, optZone.Position.Z, 
                    optZone.DistToPath, optZone.NodesInRange, unitRange))
                
                return optZone.Position
            end
        end
    end
    
    -- ===== Priority 1: หา U-Center ที่ยังไม่ได้ใช้และเหมาะกับ unit range นี้ =====
    local availableUCenter = GetAvailableUCenter(uShapeCenters, unitRange)
    
    if availableUCenter then
        -- เช็คว่าตำแหน่งนี้ยังว่างอยู่หรือไม่
        local isOccupied = false
        for _, unit in pairs(activeUnits) do
            if unit.Position and (unit.Position - availableUCenter.Position).Magnitude < 5 then
                isOccupied = true
                break
            end
        end
        
        for _, placedPos in pairs(PlacedPositions) do
            if (placedPos - availableUCenter.Position).Magnitude < 5 then
                isOccupied = true
                break
            end
        end
        
        if not isOccupied then
            -- Mark as used
            availableUCenter.Used = true
            table.insert(UsedUCenters, availableUCenter.Position)
            
            DebugPrint(string.format("⭐⭐ ใช้ U-CENTER! (%.1f, %.1f) | dist1=%.1f, dist2=%.1f | range=%.1f", 
                availableUCenter.Position.X, availableUCenter.Position.Z, 
                availableUCenter.DistToCorner1, availableUCenter.DistToCorner2, unitRange))
            
            return availableUCenter.Position
        else
            end
    end
    
    -- ===== ถ้าไม่มี Circular/U-Center ว่าง ให้หาตำแหน่งปกติ =====
    DebugPrint(string.format("📐 U-Centers: %d | Circular: %d | Available: %d", 
        #uShapeCenters, #circularCenters,
        (#uShapeCenters + #circularCenters) - #UsedUCenters))
    
    -- หาทางขนาน
    local parallelSpots = {}
    for i = 1, #path do
        for j = i + 3, #path do
            local dist = (path[i] - path[j]).Magnitude
            if dist <= unitRange * 0.8 and dist >= 5 then
                local midPoint = (path[i] + path[j]) / 2
                table.insert(parallelSpots, {
                    Position = midPoint,
                    PathIndex1 = i,
                    PathIndex2 = j,
                    Distance = dist,
                })
            end
        end
    end
    
    -- เพิ่ม Circular Centers เข้าไปใน positions (priority สูงสุด)
    for _, circCenter in ipairs(circularCenters) do
        if not circCenter.Used then
            local exists = false
            for _, pos in ipairs(positions) do
                if (pos - circCenter.Position).Magnitude < 3 then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(positions, 1, circCenter.Position)
            end
        end
    end
    
    -- เพิ่ม U-Centers ที่ยังไม่ได้ใช้เข้าไปใน positions
    for _, uCenter in ipairs(uShapeCenters) do
        if not uCenter.Used then
            local exists = false
            for _, pos in ipairs(positions) do
                if (pos - uCenter.Position).Magnitude < 3 then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(positions, 1, uCenter.Position)
            end
        end
    end

    -- Path Coverage Analysis
    local uncoveredPathSegments = {}
    for i = 1, #path do
        uncoveredPathSegments[i] = true
    end
    
    for _, unit in pairs(activeUnits) do
        if unit.Position then
            for i, pathNode in ipairs(path) do
                if (unit.Position - pathNode).Magnitude <= unitRange then
                    uncoveredPathSegments[i] = false
                end
            end
        end
    end
    
    local uncoveredCount = 0
    local firstUncoveredIndex = nil
    for i, uncovered in pairs(uncoveredPathSegments) do
        if uncovered then
            uncoveredCount = uncoveredCount + 1
            if not firstUncoveredIndex or i < firstUncoveredIndex then
                firstUncoveredIndex = i
            end
        end
    end
    
    DebugPrint(string.format("📍 Path Coverage: Uncovered=%d / Total=%d", uncoveredCount, #path))
    
    -- ===== ฟังก์ชันคำนวณความคุ้มค่าของตำแหน่ง =====
    local function CalculatePositionValue(pos, range)
        local nodesInRange = 0
        local directions = {top = false, bottom = false, left = false, right = false}
        
        for _, node in ipairs(path) do
            local dist = (pos - node).Magnitude
            if dist <= range then
                nodesInRange = nodesInRange + 1
                
                -- เช็คทิศทาง
                local dx = node.X - pos.X
                local dz = node.Z - pos.Z
                if dz > 3 then directions.top = true end
                if dz < -3 then directions.bottom = true end
                if dx > 3 then directions.right = true end
                if dx < -3 then directions.left = true end
            end
        end
        
        local dirCount = 0
        for _, hit in pairs(directions) do
            if hit then dirCount = dirCount + 1 end
        end
        
        return nodesInRange, dirCount
    end
    
    -- ประเมินตำแหน่ง
    for _, pos in pairs(positions) do
        local score = 0
        
        -- ===== คำนวณความคุ้มค่าก่อน =====
        local nodesInRange, directionsHit = CalculatePositionValue(pos, unitRange)
        
        -- ===== BONUS สำหรับความคุ้มค่า =====
        -- ยิ่งยิงได้หลาย nodes ยิ่งคุ้ม
        score = score + nodesInRange * 60
        
        -- ยิ่งยิงได้หลายทิศทางยิ่งคุ้ม
        if directionsHit >= 4 then
            score = score + 400
        elseif directionsHit >= 3 then
            score = score + 250
        elseif directionsHit >= 2 then
            score = score + 120
        end
        
        -- ===== � BONUS ใกล้ Base/จุดจบ (สำคัญมาก!) =====
        local distToBase = (pos - basePoint).Magnitude
        
        -- ยิ่งใกล้ Base ยิ่งดี - ให้คะแนนสูงมาก!
        if distToBase <= unitRange * 2 then
            score = score + 800 - distToBase * 5  -- ใกล้มาก = +800
        elseif distToBase <= unitRange * 4 then
            score = score + 500 - distToBase * 2  -- ใกล้ = +500
        elseif distToBase <= unitRange * 6 then
            score = score + 200 - distToBase     -- กลาง = +200
        else
            score = score - distToBase * 0.5     -- ไกล = ลบคะแนน
        end
        
        -- ===== 👥 BONUS วางติดๆ กัน (ใกล้ Units ที่วางแล้วมากๆ) =====
        if groupCenter then
            local distToGroup = (pos - groupCenter).Magnitude
            
            -- ===== ยิ่งใกล้ศูนย์กลางกลุ่มยิ่งดี! =====
            if distToGroup >= 3 and distToGroup <= 8 then
                score = score + 500  -- ติดกลุ่มพอดี!
            elseif distToGroup > 8 and distToGroup <= 12 then
                score = score + 350  -- ใกล้กลุ่มมาก
            elseif distToGroup > 12 and distToGroup <= 18 then
                score = score + 150  -- ใกล้กลุ่ม
            elseif distToGroup > 18 and distToGroup <= 25 then
                score = score - 100  -- เริ่มไกล
            elseif distToGroup > 25 then
                score = score - 300  -- ไกลจากกลุ่มมาก = ลดคะแนนมาก!
            elseif distToGroup < 3 then
                score = score - 150  -- ใกล้เกินไป = ซ้อนกัน
            end
        end
        
        -- หา node ใกล้ที่สุด
        local closestNodeIndex = 1
        local closestDist = math.huge
        for i, node in ipairs(path) do
            local dist = (pos - node).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestNodeIndex = i
            end
        end
        
        -- ===== 1. เช็คว่าอยู่ในระยะยิงและตีถึงแน่นอน =====
        -- ปรับ Safe Range ตาม Base Range เพื่อให้ตีได้ 25-30% ของ path
        local safeRange
        
        if unitRange <= 15 then
            -- Range น้อย (≤15) = ใช้ 100% + bonus 20%
            safeRange = unitRange * 1.2
        elseif unitRange <= 25 then
            -- Range กลาง (16-25) = ใช้ 100% + bonus 15%
            safeRange = unitRange * 1.15
        elseif unitRange <= 35 then
            -- Range ปกติ (26-35) = ใช้ 100% + bonus 10%
            safeRange = unitRange * 1.1
        else
            -- Range สูง (>35) = ใช้ 100% + bonus 5%
            safeRange = unitRange * 1.05
        end
        
        if closestDist > unitRange * 1.3 then
            -- ไกลเกินไป = ตีไม่ถึงแน่นอน!
            score = score - 2000
        elseif closestDist > safeRange then
            -- ไกลหน่อย = ตีได้น้อย
            score = score - 500
        else
            -- อยู่ในระยะ = ตีถึงได้ดี!
            if closestDist >= 4 and closestDist <= safeRange * 0.8 then
                score = score + (safeRange - closestDist) * 4
            elseif closestDist < 4 then
                score = score + (safeRange - closestDist) * 0.5
            else
                score = score + (safeRange - closestDist) * 2
            end
        end
        
        -- ===== 🎯 BONUS อยู่ใกล้ช่วงท้ายของ Path (ใกล้ Base) =====
        -- ยิ่ง index สูง (ใกล้ Base) ยิ่งดี
        if closestNodeIndex >= lateStart then
            local lateBonus = (closestNodeIndex - lateStart) * 10
            score = score + lateBonus + 200  -- ใกล้ Base มาก
        elseif closestNodeIndex >= midStart then
            score = score + 100  -- กลางๆ
        else
            score = score - 50  -- ช่วงต้น = ลดคะแนน
        end
        
        -- 2. Path Coverage Bonus (ใช้ safe range เพื่อให้ตีถึงดี)
        local newCoverageCount = 0
        local newCoverageBonus = 0
        for i, pathNode in ipairs(path) do
            local dist = (pos - pathNode).Magnitude
            -- ใช้ safe range (Base Range + bonus)
            if dist <= safeRange then
                if uncoveredPathSegments[i] then
                    newCoverageCount = newCoverageCount + 1
                    newCoverageBonus = newCoverageBonus + 50  -- เพิ่ม bonus เพราะตีถึงแน่นอน
                else
                    newCoverageBonus = newCoverageBonus + 5
                end
            end
        end
        
        if uncoveredCount > 0 and newCoverageCount > 0 then
            score = score + newCoverageBonus * 2  -- เพิ่มเป็น 2 เท่า
        else
            score = score + newCoverageBonus
        end
        
        -- 3. Corner Bonus (ใช้ safe range)
        for _, corner in ipairs(corners) do
            local distToCorner = (pos - corner.Position).Magnitude
            if distToCorner <= safeRange then
                local cornerBonus = corner.Angle * 5  -- เพิ่ม bonus มุม
                score = score + cornerBonus
                
                if corner.OutwardDir.Magnitude > 0.1 then
                    local dirToPos = (pos - corner.Position)
                    if dirToPos.Magnitude > 0.1 then
                        dirToPos = dirToPos.Unit
                        local alignment = dirToPos:Dot(corner.OutwardDir)
                        if alignment > 0.3 then
                            score = score + alignment * 150  -- เพิ่ม bonus
                        end
                    end
                end
            end
        end
        
        -- 4. Parallel Bonus
        for _, parallel in ipairs(parallelSpots) do
            local distToParallel = (pos - parallel.Position).Magnitude
            if distToParallel <= unitRange * 0.5 then
                local parallelBonus = 150 - distToParallel * 2
                score = score + math.max(0, parallelBonus)
            end
        end
        
        -- 4.3 Circular Center Bonus (จุดศูนย์กลางของ path วงกลม)
        -- ให้คะแนนสูงสุดเพราะยิงได้รอบทิศทาง
        for _, circCenter in ipairs(circularCenters) do
            if not circCenter.Used then
                local distToCircCenter = (pos - circCenter.Position).Magnitude
                
                if distToCircCenter <= 8 then  -- อยู่ใกล้ศูนย์กลางมาก
                    -- Bonus สูงมาก!
                    local circBonus = 1000 - distToCircCenter * 80
                    
                    -- นับ path nodes ที่ตำแหน่งนี้ยิงถึง
                    local nodesHit = 0
                    for _, node in ipairs(path) do
                        if (pos - node).Magnitude <= unitRange then
                            nodesHit = nodesHit + 1
                        end
                    end
                    
                    -- ยิ่งยิงได้มาก nodes ยิ่งดี
                    circBonus = circBonus + nodesHit * 30
                    
                    DebugPrint(string.format("⭕ Circular bonus: +%.0f (nodes=%d)", circBonus, nodesHit))
                    score = score + math.max(0, circBonus)
                elseif distToCircCenter <= unitRange * 0.5 then
                    local circBonus = 400 - distToCircCenter * 10
                    score = score + math.max(0, circBonus)
                end
            end
        end
        
        -- 4.5 U-Shape Center Bonus (ศูนย์กลางของตัว U - จุดตัดจากมุมใน)
        -- ให้คะแนนสูงมากถ้าตำแหน่งอยู่ใกล้จุดศูนย์กลาง U-Shape
        for _, uShape in ipairs(uShapeCenters) do
            -- ใช้ตำแหน่งจุดตัดที่คำนวณได้
            local targetCenter = uShape.Position
            local distToUCenter = (pos - targetCenter).Magnitude
            
            if distToUCenter <= 8 then  -- อยู่ใกล้จุดศูนย์กลางมาก
                -- ยิ่งใกล้ศูนย์กลางยิ่งดี - Bonus สูงมาก!
                local uBonus = 800 - distToUCenter * 50
                
                -- เช็คระยะห่างจาก path ทั้ง 2 ฝั่ง
                local dist1 = (pos - uShape.Corner1.Position).Magnitude
                local dist2 = (pos - uShape.Corner2.Position).Magnitude
                
                if dist1 <= unitRange and dist2 <= unitRange then
                    -- ===== Bonus พิเศษ: ห่างจากทั้ง 2 ฝั่งเท่าๆ กัน (ศูนย์กลางที่แท้จริง) =====
                    local distDiff = math.abs(dist1 - dist2)
                    if distDiff < 3 then
                        -- อยู่ตรงกลางพอดี! ให้ Bonus สูงสุด
                        local centerBonus = 600 - distDiff * 100
                        uBonus = uBonus + centerBonus
                        DebugPrint(string.format("⭐⭐ U-CENTER! dist1=%.1f, dist2=%.1f, diff=%.1f", dist1, dist2, distDiff))
                    elseif distDiff < 5 then
                        uBonus = uBonus + 400
                        DebugPrint(string.format("⭐ ใกล้ศูนย์กลาง U! dist1=%.1f, dist2=%.1f, diff=%.1f", dist1, dist2, distDiff))
                    else
                        uBonus = uBonus + 200
                        DebugPrint(string.format("🎯 ยิงได้ 2 ฝั่ง U! dist1=%.1f, dist2=%.1f", dist1, dist2))
                    end
                elseif dist1 <= unitRange or dist2 <= unitRange then
                    uBonus = uBonus + 50
                end
                
                -- เพิ่มคะแนนตาม U-Shape score
                uBonus = uBonus + uShape.Score * 0.5
                
                score = score + math.max(0, uBonus)
            elseif distToUCenter <= unitRange * 0.6 then
                -- อยู่ไกลจากศูนย์กลางหน่อย แต่ยังใกล้
                local uBonus = 300 - distToUCenter * 5
                
                local dist1 = (pos - uShape.Corner1.Position).Magnitude
                local dist2 = (pos - uShape.Corner2.Position).Magnitude
                
                if dist1 <= unitRange and dist2 <= unitRange then
                    uBonus = uBonus + 150
                end
                
                score = score + math.max(0, uBonus)
            end
        end
        
        -- 5. Game Phase Bonus (เน้นช่วงท้าย - ใกล้ Base)
        -- ยิ่ง index สูง (ใกล้ Base) ยิ่งดี
        if closestNodeIndex >= lateStart then
            local lateBonus = (closestNodeIndex - lateStart) * 10
            score = score + lateBonus + 200  -- ใกล้ Base มาก
        elseif closestNodeIndex >= midStart then
            score = score + 100  -- กลางๆ
        else
            score = score - 50  -- ช่วงต้น = ลดคะแนน
        end
        
        -- 6. ห่างจาก Unit ที่วางแล้ว (เน้นติดกันเฉพาะตัวเดียวกัน!)
        local nearbyUnitsCount = 0
        local nearbySameUnitsCount = 0  -- นับ Units ตัวเดียวกัน
        local closestUnitDist = math.huge
        local closestSameUnitDist = math.huge
        
        for _, unit in pairs(activeUnits) do
            if unit.Position then
                local distToUnit = (pos - unit.Position).Magnitude
                closestUnitDist = math.min(closestUnitDist, distToUnit)
                
                -- เช็คว่าเป็น Unit ตัวเดียวกันหรือไม่
                local isSameUnit = (unit.Name == unitName)
                
                if distToUnit < 3 then
                    -- ซ้อนกัน
                    score = score - 300
                elseif distToUnit >= 3 and distToUnit <= 6 then
                    -- ===== ติดกันพอดี! =====
                    if isSameUnit then
                        -- ตัวเดียวกัน = Bonus สูงมาก!
                        nearbySameUnitsCount = nearbySameUnitsCount + 1
                        score = score + 500
                    else
                        -- คนละตัว = Bonus น้อย
                        nearbyUnitsCount = nearbyUnitsCount + 1
                        score = score + 100
                    end
                elseif distToUnit > 6 and distToUnit <= 10 then
                    if isSameUnit then
                        nearbySameUnitsCount = nearbySameUnitsCount + 1
                        score = score + 300
                    else
                        nearbyUnitsCount = nearbyUnitsCount + 1
                        score = score + 80
                    end
                elseif distToUnit > 10 and distToUnit <= 15 then
                    if isSameUnit then
                        score = score + 100
                    else
                        score = score + 30
                    end
                elseif distToUnit > 20 then
                    -- ไกลเกินไป
                    if isSameUnit then
                        score = score - 150  -- ตัวเดียวกันต้องอยู่ด้วยกัน!
                    else
                        score = score - 50
                    end
                end
                
                if isSameUnit then
                    closestSameUnitDist = math.min(closestSameUnitDist, distToUnit)
                end
            end
        end
        
        -- Bonus พิเศษถ้าอยู่ติดกับ Units ตัวเดียวกันหลายตัว
        if nearbySameUnitsCount >= 3 then
            score = score + 600  -- อยู่กลางกลุ่มตัวเดียวกัน!
        elseif nearbySameUnitsCount >= 2 then
            score = score + 400
        elseif nearbySameUnitsCount >= 1 then
            score = score + 200
        end
        
        -- Bonus ถ้าอยู่ติดหลาย units (รวม)
        if nearbyUnitsCount + nearbySameUnitsCount >= 3 then
            score = score + 200  -- อยู่กลางกลุ่ม
        elseif nearbyUnitsCount + nearbySameUnitsCount >= 2 then
            score = score + 100
        end
        
        -- 7. ห่างจากตำแหน่งที่เคยวาง (เน้นอยู่ติดๆ กัน!)
        local nearbyPlacedCount = 0
        for _, placedPos in pairs(PlacedPositions) do
            local distToPlaced = (pos - placedPos).Magnitude
            if distToPlaced < 3 then
                score = score - 300  -- ซ้อนกัน
            elseif distToPlaced >= 3 and distToPlaced <= 6 then
                -- ===== ติดกันพอดี! =====
                nearbyPlacedCount = nearbyPlacedCount + 1
                score = score + 250
            elseif distToPlaced > 6 and distToPlaced <= 10 then
                nearbyPlacedCount = nearbyPlacedCount + 1
                score = score + 100
            elseif distToPlaced > 20 then
                score = score - 80  -- ไกลเกินไป
            end
        end
        
        -- Bonus ถ้าอยู่ติดกับตำแหน่งที่เคยวาง
        if nearbyPlacedCount >= 2 then
            score = score + 200
        elseif nearbyPlacedCount >= 1 then
            score = score + 100
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
            
            -- Debug: แสดงเหตุผลที่เลือกตำแหน่งนี้
            if DEBUG then
                local nodesHit, dirsHit = CalculatePositionValue(pos, unitRange)
                local distBase = (pos - basePoint).Magnitude
                
                -- นับ Units ตัวเดียวกันที่ใกล้ๆ
                local sameNearby = 0
                for _, unit in pairs(activeUnits) do
                    if unit.Position and unit.Name == unitName then
                        local dist = (pos - unit.Position).Magnitude
                        if dist <= 10 then
                            sameNearby = sameNearby + 1
                        end
                    end
                end
                
                DebugPrint(string.format("📊 ตำแหน่งใหม่ดีกว่า: (%.1f, %.1f) | nodes=%d, same=%d, score=%.0f", 
                    pos.X, pos.Z, nodesHit, sameNearby, score))
            end
        end
    end
    
    if bestPos then
        local nodesHit, dirsHit = CalculatePositionValue(bestPos, unitRange)
        local distBase = (bestPos - basePoint).Magnitude
        local distGroup = groupCenter and (bestPos - groupCenter).Magnitude or 0
        
        -- คำนวณ Safe Range
        local safeRange
        if unitRange <= 15 then
            safeRange = unitRange * 1.2
        elseif unitRange <= 25 then
            safeRange = unitRange * 1.15
        elseif unitRange <= 35 then
            safeRange = unitRange * 1.1
        else
            safeRange = unitRange * 1.05
        end
        
        -- นับ path nodes ที่อยู่ใน safe range
        local nodesInSafeRange = 0
        for _, node in ipairs(path) do
            if (bestPos - node).Magnitude <= safeRange then
                nodesInSafeRange = nodesInSafeRange + 1
            end
        end
        local coveragePercent = (nodesInSafeRange / #path) * 100
        
        -- นับ Units ตัวเดียวกันที่ใกล้ๆ
        local sameNearby = 0
        for _, unit in pairs(activeUnits) do
            if unit.Position and unit.Name == unitName then
                local dist = (bestPos - unit.Position).Magnitude
                if dist <= 10 then
                    sameNearby = sameNearby + 1
                end
            end
        end
        
        DebugPrint(string.format("✅ Best: (%.1f, %.1f) | Coverage: %.1f%% (%d/%d) | Same: %d | DistBase: %.0f", 
            bestPos.X, bestPos.Z, coveragePercent, nodesInSafeRange, #path, sameNearby, distBase))
    else
        bestPos = #positions > 0 and positions[1] or nil
        end
    
    return bestPos
end

-- ===== PLACEMENT VALIDATION =====
CanPlaceAtPosition = function(unitName, position)
    if PlacementValidationHandler and PlacementValidationHandler.CanFitUnit then
        local canPlace = false
        pcall(function()
            canPlace = PlacementValidationHandler:CanFitUnit({
                UnitName = unitName,
                UnitPosition = position + Vector3.new(0, 1, 0),
                Units = ClientUnitHandler and ClientUnitHandler._ActiveUnits or {}
            })
        end)
        return canPlace
    end
    return true
end

-- ===== PLACE UNIT =====
PlaceUnit = function(slot, position)
    if not position then 
        return false 
    end
    
    local hotbar = GetHotbarUnits()
    if not hotbar then
        return false
    end
    
    local unit = hotbar[slot]
    if not unit then 
        return false 
    end
    
    -- เช็ค cooldown (เพิ่มเป็น 1.0 วินาทีเพื่อให้ unit spawn และหา GUID ได้)
    local timeSinceLastPlace = tick() - LastPlaceTime
    if timeSinceLastPlace < 1.0 then
        -- Debug: log เฉพาะเมื่อครั้งแรกที่โดน cooldown block (ลด spam)
        if not _G.LastCooldownBlock or (tick() - _G.LastCooldownBlock) > 2 then
            DebugPrint(string.format("⏱️ Cooldown: รอ %.1f วินาทีก่อนวางตัวถัดไป", 1.0 - timeSinceLastPlace))
            _G.LastCooldownBlock = tick()
        end
        return false
    end
    
    -- เช็คเงิน
    local yen = GetYen()
    if unit.Price > 0 and yen < unit.Price then
        return false
    end
    
    -- เช็ค slot limit
    if not CanPlaceSlot(slot) then
        local limit, current = GetSlotLimit(slot)
        DebugPrint(string.format("⚠️ ไม่สามารถวาง %s - ถึงขีดจำกัดแล้ว (%d/%d)", unit.Name, current, limit))
        return false
    end
    
    local validPosition = position
    local canPlaceOriginal = CanPlaceAtPosition(unit.Name, position)
    
    if not canPlaceOriginal then
        -- Debug: log เมื่อตำแหน่งถูกใช้แล้ว
        if not _G.LastPositionOccupied or (tick() - _G.LastPositionOccupied) > 2 then
            DebugPrint(string.format("⚠️ ตำแหน่ง (%.1f, %.1f, %.1f) ถูกใช้แล้ว - กำลังหาตำแหน่งใกล้ๆ", 
                position.X, position.Y, position.Z))
            _G.LastPositionOccupied = tick()
        end
        
        -- ลองหาตำแหน่งใกล้ๆ
        local offsets = {
            Vector3.new(4, 0, 0), Vector3.new(-4, 0, 0),
            Vector3.new(0, 0, 4), Vector3.new(0, 0, -4),
        }
        local foundAlternative = false
        for _, offset in ipairs(offsets) do
            local testPos = position + offset
            if CanPlaceAtPosition(unit.Name, testPos) then
                validPosition = testPos
                foundAlternative = true
                DebugPrint(string.format("✅ พบตำแหน่งใหม่: (%.1f, %.1f, %.1f)", 
                    testPos.X, testPos.Y, testPos.Z))
                break
            end
        end
        
        if not foundAlternative then
            return false
        end
    end
    
    local unitID = unit.ID or (unit.Data and unit.Data.ID) or slot
    
    DebugPrint(string.format("🎯 วาง %s (slot %d) ที่ %.1f, %.1f, %.1f", 
        unit.Name, slot, validPosition.X, validPosition.Y, validPosition.Z))
    
    -- ⭐ แปลง ID เป็นตัวเลข (ตาม Remote format)
    local numericID = unitID
    if type(unitID) == "string" and tonumber(unitID) then
        numericID = tonumber(unitID)
    elseif type(unitID) == "string" and UnitsData then
        pcall(function()
            local unitInfo = UnitsData:GetUnitDataFromID(unitID)
            if unitInfo and unitInfo.Directory then
                numericID = unitInfo.Directory
            end
        end)
    end
    
    local success = false
    local success_pcall = pcall(function()
        -- ⭐ Format ตาม Remote Spy: ("Render", {data}, {SlotIndex})
        UnitEvent:FireServer("Render", {
            unit.Name,      -- [1] Name
            numericID,      -- [2] ID (ตัวเลข เช่น 13)
            validPosition,  -- [3] Position
            0               -- [4] Rotation
        }, {
            SlotIndex = slot  -- ⭐ parameter ที่ 3
        })
        success = true
    end)
    
    if success then
        table.insert(PlacedPositions, validPosition)
        LastPlaceTime = tick()
        CurrentYen = yen - unit.Price
        
        -- ✅ Reset ClearEnemy flag เมื่อวาง unit ใหม่ (อาจมีตัวให้ขายได้อีก)
        if ClearEnemyNoMoreSellable then
            ClearEnemyNoMoreSellable = false
            ClearEnemySlotFullLogged = {}
            ClearEnemyFoundDamageLogged = {}
        end
        
        -- รอให้เกม spawn unit แล้วหา GUID จริง
        task.wait(0.5)
        local realGUID = nil
        
        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
            for guid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                if activeUnit.Position then
                    local dist = (activeUnit.Position - validPosition).Magnitude
                    if dist < 5 and activeUnit.Name == unit.Name then
                        realGUID = guid
                        DebugPrint(string.format("🔍 พบ Real GUID: %s สำหรับ %s", guid, unit.Name))
                        break
                    end
                end
            end
        end
        
        if not realGUID then
            DebugPrint(string.format("⚠️ ไม่พบ Real GUID สำหรับ %s ที่ (%.1f, %.1f, %.1f)", unit.Name, validPosition.X, validPosition.Y, validPosition.Z))
        end
        
        return true, realGUID
    else
        return false, nil
    end
end

-- ===== UPGRADE SYSTEM (จาก Decom.lua) =====
-- จาก Decom:
-- - ClientUnitHandler._ActiveUnits[guid] = unit object
-- - unit.Data.CurrentUpgrade = level ปัจจุบัน
-- - unit.Data.Upgrades = array ของ upgrade
-- - unit.Data.Upgrades[level].Price = ราคา upgrade
-- - #unit.Data.Upgrades = max level

-- ⭐ Helper: หา UnitData จาก UnitsHUD โดยใช้ชื่อ unit (สำหรับ Upgrades)
local function GetUnitDataFromHUD(unitName)
    if not UnitsHUD or not UnitsHUD._Cache then return nil end
    for _, v in pairs(UnitsHUD._Cache) do
        if v and v ~= "None" then
            local unitData = v.Data or v
            if unitData.Name == unitName or v.Name == unitName then
                return unitData
            end
        end
    end
    return nil
end

-- ⭐ Helper: ดึง unit.Data จาก ClientUnitHandler โดยใช้ GUID
local function GetUnitDataFromActiveUnits(guid)
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then return nil end
    local unit = ClientUnitHandler._ActiveUnits[guid]
    if unit then
        return unit.Data  -- ⭐ จาก Decom: unit.Data มี CurrentUpgrade, Upgrades
    end
    return nil
end

-- หา Upgrade Cost (ตาม Decom: Upgrades[level].Price)
GetUpgradeCost = function(unit)
    if not unit then return math.huge end
    
    -- ⭐ ดึง unit.Data จาก ClientUnitHandler (real-time)
    local data = GetUnitDataFromActiveUnits(unit.GUID)
    if not data then
        data = unit.Data
    end
    
    if not data then return math.huge end
    
    -- ⭐ จาก Decom: data.CurrentUpgrade คือ level ปัจจุบัน
    local currentLevel = data.CurrentUpgrade or 0
    
    -- ⭐ จาก Decom: data.Upgrades คือ array ของ upgrade
    local upgrades = data.Upgrades
    
    -- ถ้าไม่มี Upgrades ใน Data → ลองหาจาก UnitsHUD
    if not upgrades then
        local hudData = GetUnitDataFromHUD(unit.Name)
        if hudData then
            upgrades = hudData.Upgrades
        end
    end
    
    if not upgrades then
        return math.huge
    end
    
    -- ⭐ จาก Decom: Upgrades[nextLevel].Price คือ cost
    local nextLevel = currentLevel + 1
    local nextUpgrade = upgrades[nextLevel]
    
    if nextUpgrade and type(nextUpgrade) == "table" then
        local cost = nextUpgrade.Price or nextUpgrade.Cost
        if cost then
            return cost
        end
    end
    
    -- ถ้าหาไม่เจอ = อัพเต็มแล้ว
    return math.huge
end

-- หา Max Upgrade Level (ตาม Decom: #data.Upgrades)
GetMaxUpgradeLevel = function(unit)
    if not unit then return 0 end
    
    -- ⭐ ดึง unit.Data จาก ClientUnitHandler (real-time)
    local data = GetUnitDataFromActiveUnits(unit.GUID)
    if not data then
        data = unit.Data
    end
    
    if not data then return 0 end
    
    -- ⭐ จาก Decom: #data.Upgrades คือ max level
    local upgrades = data.Upgrades
    
    -- ถ้าไม่มี Upgrades ใน Data → ลองหาจาก UnitsHUD
    if not upgrades then
        local hudData = GetUnitDataFromHUD(unit.Name)
        if hudData then
            upgrades = hudData.Upgrades
        end
    end
    
    if upgrades and type(upgrades) == "table" then
        return #upgrades  -- จาก Decom: #data.Upgrades
    end
    
    return 0
end

-- หา Current Upgrade Level (ตาม Decom: data.CurrentUpgrade)
GetCurrentUpgradeLevel = function(unit)
    if not unit then return 0 end
    
    -- ⭐ ดึง unit.Data จาก ClientUnitHandler (real-time)
    local data = GetUnitDataFromActiveUnits(unit.GUID)
    if not data then
        data = unit.Data
    end
    
    if not data then return 0 end
    
    -- ⭐ จาก Decom: data.CurrentUpgrade คือ level ปัจจุบัน
    return data.CurrentUpgrade or 0
end

-- เช็คว่า Unit อัพ MAX แล้วหรือยัง (ตาม Decom: CurrentUpgrade >= #Upgrades)
local function IsUnitMaxed(unit)
    local currentLevel = GetCurrentUpgradeLevel(unit)
    local maxLevel = GetMaxUpgradeLevel(unit)
    return currentLevel >= maxLevel
end

-- หา Unit ที่แรงที่สุด (ใช้ Base Damage จาก Decom.lua)
local function GetStrongestUnit(units)
    local best = nil
    local bestDamage = -math.huge
    
    for _, unit in pairs(units) do
        -- ⭐ ดึง Base Damage จาก Decom.lua (UnitDataHandler)
        local baseDamage = 0
        
        -- เช็คจาก UnitDataHandler ก่อน
        if UnitDataHandler and UnitDataHandler.UnitData and UnitDataHandler.UnitData[unit.Name] then
            local unitInfo = UnitDataHandler.UnitData[unit.Name]
            baseDamage = unitInfo.Damage or 0
        end
        
        -- ถ้าไม่เจอ ลองเช็คจาก ClientUnitHandler
        if baseDamage == 0 then
            local data = GetUnitDataFromActiveUnits(unit.GUID)
            if data then
                baseDamage = data.Damage or 0
            end
        end
        
        -- ถ้ายังไม่เจอ ใช้จาก unit.Data
        if baseDamage == 0 and unit.Data then
            baseDamage = unit.Data.Damage or 0
        end
        
        if baseDamage > bestDamage then
            bestDamage = baseDamage
            best = unit
        end
    end
    
    return best
end

-- Upgrade Unit (ระบบจาก Decom)
UpgradeUnit = function(unit)
    if not unit or not unit.GUID then return false end
    
    -- เช็ค cooldown
    if tick() - LastUpgradeTime < 0.5 then return false end
    
    -- ⭐ ใช้ฟังก์ชันจาก Decom
    local currentLevel = GetCurrentUpgradeLevel(unit)
    local maxLevel = GetMaxUpgradeLevel(unit)
    
    -- เช็ค max level (ตาม Decom: CurrentUpgrade >= #Upgrades)
    if currentLevel >= maxLevel then
        DebugPrint(string.format("✅ %s อัพ MAX แล้ว (%d/%d)", unit.Name, currentLevel, maxLevel))
        return false
    end
    
    local cost = GetUpgradeCost(unit)
    
    -- ⭐ เช็คว่า cost valid หรือไม่ (ไม่ใช่ math.huge)
    if cost >= math.huge then
        DebugPrint(string.format("❌ ไม่พบ Upgrade cost สำหรับ %s", unit.Name or "Unknown"))
        return false
    end
    
    -- เช็คเงิน
    local yen = GetYen()
    if yen < cost then
        return false
    end
    
    local success = false
    pcall(function()
        UnitEvent:FireServer("Upgrade", unit.GUID)
        success = true
    end)
    
    if success then
        LastUpgradeTime = tick()
        CurrentYen = yen - cost
        DebugPrint(string.format("⬆️ Upgrade %s [%d→%d] Cost: %d", 
            unit.Name or "Unknown", currentLevel, currentLevel + 1, cost))
    end
    
    return success
end

-- ===== SELL UNIT =====
SellUnit = function(unit)
    if not unit or not unit.GUID then return false end
    
    -- ⭐⭐⭐ NEVER SELL: Lich King (Ruler) - ทุกด่าน
    local unitName = unit.Name or ""
    local isLichKingRuler = unitName:lower():find("lich") and unitName:lower():find("ruler")
    if isLichKingRuler then
        return false
    end
    
    -- เช็คว่าขายได้หรือไม่
    if not unit.CanSell then
        return false
    end
    
    -- Cooldown
    if tick() - LastPlaceTime < 0.5 then  -- 0.5 วินาที
        return false
    end
    
    local success = false
    pcall(function()
        UnitEvent:FireServer("Sell", unit.GUID)
        success = true
    end)
    
    if success then
        LastPlaceTime = tick()
        
        -- ลบออกจาก Emergency tracking
        EmergencyUnits[unit.GUID] = nil
    end
    
    return success
end

-- ===== SELL ALL MONEY UNITS (Max Wave) =====
local HasSoldMoneyUnits = false  -- ป้องกันไม่ให้ขายซ้ำ

local function SellAllMoneyUnits()
    local activeUnits = GetActiveUnits()
    local soldCount = 0
    local unsellableCount = 0
    
    -- ⭐ รวบรวม units ที่ต้องขายก่อน (เพื่อหลีกเลี่ยงปัญหา pairs ขณะลบ)
    local unitsToSell = {}
    
    for _, unit in pairs(activeUnits) do
        -- ✅ FIX: เช็คว่าเป็นตัวเงินจริงๆ (IsIncomeUnit) หรือ ClearEnemy Unit
        -- ⭐ FIX: ใช้ unit.Data or {} เพื่อป้องกัน nil
        local isEconomy = IsIncomeUnit(unit.Name, unit.Data or {})
        local isClearEnemy = ClearEnemyUnits[unit.GUID] ~= nil
        
        -- ขายทั้งตัวเงินและ ClearEnemy Units
        if isEconomy or isClearEnemy then
            -- ⚠️ เช็คว่าขายได้หรือไม่ (CanSell)
            if unit.CanSell ~= false then
                table.insert(unitsToSell, {
                    unit = unit,
                    isClearEnemy = isClearEnemy,
                    isEconomy = isEconomy
                })
            else
                unsellableCount = unsellableCount + 1
            end
        end
    end
    
    DebugPrint(string.format("📋 พบ %d units ที่ต้องขาย (Economy + ClearEnemy)", #unitsToSell))
    
    -- ⭐ ขายทีละตัว
    for _, info in ipairs(unitsToSell) do
        local unit = info.unit
        local unitWrapper = {
            GUID = unit.GUID,
            Name = unit.Name,
            CanSell = true
        }
        
        if SellUnit(unitWrapper) then
            soldCount = soldCount + 1
            if info.isClearEnemy then
                DebugPrint(string.format("💸 ขาย ClearEnemy Unit: %s", unit.Name))
                ClearEnemyUnits[unit.GUID] = nil
            else
                DebugPrint(string.format("💸 ขายตัวเงิน %s", unit.Name))
            end
        else
            DebugPrint(string.format("❌ ขายไม่สำเร็จ: %s (GUID=%s)", unit.Name, unit.GUID or "nil"))
        end
        
        -- ⭐ FIX: รอ 0.55 วินาที (มากกว่า cooldown 0.5 วินาที)
        task.wait(0.55)
    end
    
    if soldCount > 0 then
        DebugPrint(string.format("🏆 MAX WAVE! ขายทุกอย่างที่เกี่ยวกับตัวเงิน %d ตัว (ข้าม %d UNSELLABLE)", soldCount, unsellableCount))
        -- รีเซ็ตการติดตาม ClearEnemy
        ClearEnemyUnits = {}
        ClearEnemySoldForEnemy = {}
        ClearEnemyNoMoreSellable = false  -- ✅ รีเซ็ต global flag
        ClearEnemySlotFullLogged = {}  -- ✅ รีเซ็ต log tracking
        ClearEnemyFoundDamageLogged = {}  -- ✅ รีเซ็ต log tracking
    else
        DebugPrint(string.format("⚠️ ไม่ได้ขายอะไรเลย (พบ %d ตัว, UNSELLABLE %d ตัว)", #unitsToSell, unsellableCount))
    end
end

-- ===== GET NEXT ECONOMY SLOT =====
_G.APState.LastLoggedEconomySlot = {slot = -1, current = -1, price = -1, yen = -1}

local function GetNextEconomySlot()
    local hotbar = GetHotbarUnits()
    local placePriority = {1, 2, 3, 4, 5, 6}  -- Hard-coded priority
    
    -- Debug: แสดงจำนวน units ใน hotbar
    local hotbarCount = 0
    for _ in pairs(hotbar) do hotbarCount = hotbarCount + 1 end
    
    if hotbarCount == 0 then
        return nil, nil
    end
    
    for _, slotNum in ipairs(placePriority) do
        local unit = hotbar[slotNum]
        if unit then
            -- เช็คจาก flag หรือ UnitData
            local isEconomy = unit.IsIncome or (unit.Data and IsIncomeUnit(unit.Name, unit.Data))
            
            if isEconomy then
                -- ⭐⭐⭐ เช็ค Trait limit (ส่ง UnitObject ที่มี .Trait)
                local canPlaceMore = CanPlaceMoreUnits(unit.Name, unit.UnitObject)
                
                local limit, current = GetSlotLimit(slotNum)
                local canPlace = current < limit
                local yen = GetYen()
                local hasEnoughMoney = yen >= unit.Price
                
                -- Debug log เฉพาะเมื่อมีการเปลี่ยนแปลง
                local lastLog = _G.APState.LastLoggedEconomySlot or {slot = -1, current = -1, price = -1, yen = -1}
                if lastLog.slot ~= slotNum or 
                   lastLog.current ~= current or 
                   lastLog.price ~= unit.Price or 
                   math.abs((lastLog.yen or 0) - yen) > 50 then
                    DebugPrint(string.format("💵 Economy Slot %d: %s | %d/%d | Price: %d | Yen: %d | CanPlace: %s | TraitLimit: %s", 
                        slotNum, unit.Name, current, limit, unit.Price, yen, tostring(canPlace and hasEnoughMoney), tostring(canPlaceMore)))
                    _G.APState.LastLoggedEconomySlot = {slot = slotNum, current = current, price = unit.Price, yen = yen}
                end
                
                if canPlace and hasEnoughMoney and canPlaceMore then
                    return slotNum, unit
                end
            end
        end
    end
    
    return nil, nil
end

-- ===== GET STAGE/MAP NAME =====
local function GetCurrentStageName()
    local stageName = "Unknown"
    pcall(function()
        -- วิธี 1: จาก workspace.Map.Name
        if workspace:FindFirstChild("Map") then
            stageName = workspace.Map.Name
        end
        -- วิธี 2: จาก Attribute
        if stageName == "Unknown" or stageName == "Map" then
            local attr = workspace:GetAttribute("StageName") or workspace:GetAttribute("MapName")
            if attr then stageName = attr end
        end
        -- วิธี 3: จาก ReplicatedStorage.GameData
        if stageName == "Unknown" or stageName == "Map" then
            local gameData = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
            if gameData then
                local stageVal = gameData:FindFirstChild("StageName") or gameData:FindFirstChild("Stage")
                if stageVal and stageVal:IsA("StringValue") then
                    stageName = stageVal.Value
                end
            end
        end
    end)
    return stageName
end

-- ===== GET GATE/ENTRANCE POSITION (จุดเริ่มต้น path - หน้าประตู) =====
local function GetGatePosition()
    local path = GetMapPath()
    if path and #path > 0 then
        return path[1]  -- จุดเริ่มต้น = หน้าประตู (สีเขียว)
    end
    return nil
end

-- ===== GET IMPRISONED ISLAND SPECIFIC POSITION =====
-- ⭐ ตำแหน่งเฉพาะสำหรับ Imprisoned Island (ตามรูปที่ user ให้มา)
local function GetImprisonedIslandPosition()
    local path = GetMapPath()
    if not path or #path < 3 then return nil end
    
    -- ⭐ Imprisoned Island: วางใกล้จุดเริ่มต้น path แต่อยู่ข้างทาง (ไม่กีดขวาง)
    -- ดูจากรูป: วางใกล้ bridge/ramp area ที่เป็นสีดำ
    local gatePos = path[1]
    local secondPoint = path[2]
    local thirdPoint = path[3]
    
    -- คำนวณทิศทางของ path
    local pathDir = (secondPoint - gatePos).Unit
    
    -- วางข้างทาง (perpendicular to path direction)
    local sideOffset = Vector3.new(-pathDir.Z, 0, pathDir.X) * 8  -- 8 studs ข้างทาง
    local forwardOffset = pathDir * 10  -- 10 studs หน้าประตู
    
    local targetPos = gatePos + forwardOffset + sideOffset
    
    print(string.format("[ImprisonedIsland] 🏝️ Specific position: (%.1f, %.1f, %.1f)", 
        targetPos.X, targetPos.Y, targetPos.Z))
    
    return targetPos
end

-- ===== GET BEST FRONT POSITION (ใกล้ประตูที่สุด) =====
local function GetBestFrontPosition(unitRange, forceImprisonedIsland)
    -- ⭐⭐⭐ Imprisoned Island: ใช้ตำแหน่งเฉพาะ
    local stageName = GetCurrentStageName()
    local isImprisonedIsland = stageName:lower():find("imprisoned") or stageName:lower():find("island")
    
    if isImprisonedIsland or forceImprisonedIsland then
        local specificPos = GetImprisonedIslandPosition()
        if specificPos then
            return specificPos
        end
    end
    
    local gatePos = GetGatePosition()
    if not gatePos then return nil end
    
    local path = GetMapPath()
    if not path or #path < 2 then return nil end
    
    -- หาตำแหน่งที่ดีที่สุดใกล้ประตู (ใน range ของ unit)
    local bestPos = nil
    local bestDist = math.huge
    local minDistFromGate = 5  -- ห่างจากประตูอย่างน้อย 5 studs
    local maxDistFromGate = unitRange or 25
    
    -- สร้าง grid รอบประตู
    for angle = 0, 360, 20 do
        for dist = minDistFromGate, maxDistFromGate, 5 do
            local rad = math.rad(angle)
            local offset = Vector3.new(
                math.cos(rad) * dist,
                0,
                math.sin(rad) * dist
            )
            local testPos = gatePos + offset
            
            -- เช็คว่าอยู่ใน path ไหม (ใกล้ path)
            local nearPath = false
            for _, pathPoint in ipairs(path) do
                if (testPos - pathPoint).Magnitude < 15 then
                    nearPath = true
                    break
                end
            end
            
            if nearPath then
                local distFromGate = (testPos - gatePos).Magnitude
                if distFromGate < bestDist and distFromGate >= minDistFromGate then
                    bestPos = testPos
                    bestDist = distFromGate
                end
            end
        end
    end
    
    return bestPos
end

-- ===== GET NEXT DAMAGE SLOT =====
_G.APState._LastDamageSlotCheck = ""
local function GetNextDamageSlot()
    local hotbar = GetHotbarUnits()
    local placePriority = {1, 2, 3, 4, 5, 6}  -- Hard-coded priority
    
    local logData = {}
    
    -- ⭐ NOTE: ไม่ force place Lich King ก่อน แค่ย้ายตำแหน่งไปหน้าประตูเท่านั้น
    -- (ตำแหน่งจะถูกจัดการในส่วน placement)
    
    -- ⭐ Normal priority: วาง damage units ตามลำดับปกติ
    for _, slotNum in ipairs(placePriority) do
        local unit = hotbar[slotNum]
        if unit then
            -- ข้าม Economy units
            local isEconomy = unit.IsIncome or (unit.Data and IsIncomeUnit(unit.Name, unit.Data))
            local isBuff = unit.IsBuff or (unit.Data and IsBuffUnit(unit.Name, unit.Data))
            local isDamage = not isEconomy and not isBuff
            
            -- ⭐⭐⭐ ข้าม Unit ที่มี Passive ต้องตี Enemy ก่อน
            local isPassiveSummon = unit.Data and IsPassiveSummonUnit(unit.Name, unit.Data)
            
            -- ⭐⭐⭐ เช็คว่ายังวางได้อีกไหม (Trait limit - ส่ง UnitObject)
            local canPlaceMore = CanPlaceMoreUnits(unit.Name, unit.UnitObject)
            
            if isDamage and not isPassiveSummon and canPlaceMore then
                local limit, current = GetSlotLimit(slotNum)
                local canPlace = current < limit
                local yen = GetYen()
                
                local status = string.format("Slot%d:%s(%d/%d,Y%d/%d,%s)", 
                    slotNum, unit.Name, current, limit, yen, unit.Price, canPlace and "✓" or "✗")
                table.insert(logData, status)
                
                if canPlace and yen >= unit.Price then
                    return slotNum, unit
                end
            elseif isPassiveSummon then
                -- Log ว่าข้าม Passive Summon Unit
                table.insert(logData, string.format("Slot%d:%s(🚫Passive)", slotNum, unit.Name))
            elseif not canPlaceMore then
                -- Log ว่าถึง limit แล้ว
                table.insert(logData, string.format("Slot%d:%s(🚫MaxLimit)", slotNum, unit.Name))
            end
        end
    end
    
    -- Log เฉพาะเมื่อมีการเปลี่ยนแปลง
    local logStr = table.concat(logData, " | ")
    if logStr ~= _LastDamageSlotCheck and #logData > 0 then
        _LastDamageSlotCheck = logStr
    end
    
    return nil, nil
end

-- ===== GET CHEAPEST DAMAGE SLOT (สำหรับ Normal Mode - check limit) =====
local function GetCheapestDamageSlot()
    local hotbar = GetHotbarUnits()
    local yen = GetYen()
    local cheapestSlot = nil
    local cheapestUnit = nil
    local cheapestPrice = math.huge
    
    for slotNum = 1, 6 do
        local unit = hotbar[slotNum]
        if unit then
            -- ข้าม Economy units
            local isEconomy = unit.IsIncome or (unit.Data and IsIncomeUnit(unit.Name, unit.Data))
            local isBuff = unit.IsBuff or (unit.Data and IsBuffUnit(unit.Name, unit.Data))
            local isDamage = not isEconomy and not isBuff
            
            -- ⭐ ข้าม Passive Summon Unit
            local isPassiveSummon = unit.Data and IsPassiveSummonUnit(unit.Name, unit.Data)
            
            if isDamage and not isPassiveSummon then
                local limit, current = GetSlotLimit(slotNum)
                local canPlace = current < limit
                
                if canPlace and yen >= unit.Price and unit.Price < cheapestPrice then
                    cheapestSlot = slotNum
                    cheapestUnit = unit
                    cheapestPrice = unit.Price
                end
            end
        end
    end
    
    if cheapestSlot then
        DebugPrint(string.format("💰 พบ Damage ถูกที่สุด: %s (slot %d, ราคา %d)", 
            cheapestUnit.Name, cheapestSlot, cheapestPrice))
    end
    
    return cheapestSlot, cheapestUnit
end

-- ===== เช็คว่ามี Summon Unit ใน Hotbar หรือไม่ =====
local function HasSummonUnitInHotbar()
    local hotbar = GetHotbarUnits()
    
    for slotNum = 1, 6 do
        local unit = hotbar[slotNum]
        if unit and unit.Data then
            if IsPassiveSummonUnit(unit.Name, unit.Data) then
                return true, slotNum, unit
            end
        end
    end
    
    return false, nil, nil
end

-- ===== GET SUMMON UNIT SLOT (สำหรับ Emergency Mode with Summon) =====
local function GetSummonUnitSlot()
    local hotbar = GetHotbarUnits()
    local yen = GetYen()
    
    for slotNum = 1, 6 do
        local unit = hotbar[slotNum]
        if unit and unit.Data then
            local isPassiveSummon = IsPassiveSummonUnit(unit.Name, unit.Data)
            
            -- ⭐⭐⭐ เช็ค Trait limit (ส่ง UnitObject)
            local canPlaceMore = CanPlaceMoreUnits(unit.Name, unit.UnitObject)
            
            if isPassiveSummon and canPlaceMore and yen >= unit.Price then
                local limit, current = GetSlotLimit(slotNum)
                
                -- ⚠️ ไม่ check slot limit - Emergency Mode bypass slot limit แต่เคารพ Trait limit
                DebugPrint(string.format("🎯 พบ Summon Unit: %s (slot %d) | %d/%d | ราคา %d", 
                    unit.Name, slotNum, current, limit, unit.Price))
                return slotNum, unit
            end
        end
    end
    
    return nil, nil
end

-- ===== GET CHEAPEST DAMAGE SLOT NO LIMIT (สำหรับ Emergency Mode - bypass limit) =====
GetCheapestDamageSlotNoLimit = function()
    local hotbar = GetHotbarUnits()
    local yen = GetYen()
    local cheapestSlot = nil
    local cheapestUnit = nil
    local cheapestPrice = math.huge
    
    for slotNum = 1, 6 do
        local unit = hotbar[slotNum]
        if unit then
            local isEconomy = unit.IsIncome or (unit.Data and IsIncomeUnit(unit.Name, unit.Data))
            local isBuff = unit.IsBuff or (unit.Data and IsBuffUnit(unit.Name, unit.Data))
            local isDamage = not isEconomy and not isBuff
            
            -- ⭐ ข้าม Passive Summon Unit (แม้ Emergency ก็ไม่ควรวาง)
            local isPassiveSummon = unit.Data and IsPassiveSummonUnit(unit.Name, unit.Data)
            
            -- ⭐⭐⭐ เช็ค Trait limit (ส่ง UnitObject - แม้เป็น Emergency ก็ต้องเคารพ Trait limit)
            local canPlaceMore = CanPlaceMoreUnits(unit.Name, unit.UnitObject)
            
            -- ⚠️ ไม่ check slot limit - Emergency Mode bypass slot limit แต่ยังเคารพ Trait limit
            if isDamage and not isPassiveSummon and canPlaceMore and yen >= unit.Price and unit.Price < cheapestPrice then
                cheapestSlot = slotNum
                cheapestUnit = unit
                cheapestPrice = unit.Price
            elseif isDamage and not canPlaceMore then
                -- 🚨 Log เฉพาะกรณีที่ถูกบล็อกเพราะ Trait limit
                DebugPrint(string.format("🚫 Emergency BLOCKED: %s ถึง Trait Limit แล้ว!", unit.Name))
            end
        end
    end
    
    if cheapestSlot then
        DebugPrint(string.format("🚨 Emergency พบ Damage: %s (slot %d, ราคา %d)", 
            cheapestUnit.Name, cheapestSlot, cheapestPrice))
    end
    
    return cheapestSlot, cheapestUnit
end

-- ===== CHECK: มีตัวเงินใน Hotbar หรือไม่ =====
local function HasEconomyUnitInHotbar()
    local hotbar = GetHotbarUnits()
    local count = 0
    for _ in pairs(hotbar) do count = count + 1 end
    
    if count == 0 then
        return false
    end
    
    for slot, unit in pairs(hotbar) do
        -- เช็คจาก flag IsIncome หรือจาก UnitData (ไม่ print เพื่อลด spam)
        if unit.IsIncome then
            return true
        end
        -- เช็คจาก UnitData ด้วย
        if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
            return true
        end
    end
    return false
end

-- ===== CHECK: ตัวเงินอัพเกรดเต็มทุกตัวหรือยัง =====
local function AllEconomyUnitsMaxed()
    local activeUnits = GetActiveUnits()
    local hasEconomyUnit = false
    local allMaxed = true
    local economyStatus = {}
    
    for _, unit in pairs(activeUnits) do
        if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
            hasEconomyUnit = true
            -- ⭐ ใช้ฟังก์ชันจาก Decom
            local currentLevel = GetCurrentUpgradeLevel(unit)
            local maxLevel = GetMaxUpgradeLevel(unit)
            
            table.insert(economyStatus, string.format("%s Lv.%d/%d", unit.Name, currentLevel, maxLevel))
            
            if currentLevel < maxLevel then
                allMaxed = false  -- ยังไม่เต็ม
            end
        end
    end
    
    -- Debug: แสดงสถานะทุก 30 วินาที
    local now = tick()
    if now - (AllEconomyUnitsMaxed.lastLog or 0) >= 30 then
        if #economyStatus > 0 then
            DebugPrint(string.format("💰 Economy Status: %s", table.concat(economyStatus, ", ")))
        end
        AllEconomyUnitsMaxed.lastLog = now
    end
    
    -- ถ้าไม่มีตัวเงินในสนามเลย → ไม่ถือว่าเต็ม (ต้องวางก่อน)
    if not hasEconomyUnit then
        return false
    end
    
    return allMaxed  -- เต็มหมดแล้ว
end

-- ===== MAIN AUTO PLACE LOOP =====
local function AutoPlaceLoop()
-- ⭐ ฟัง MatchControl Events (จับเกมจบ/รีเซ็ต)
    if MatchControl then
        -- MatchEnded Event (เกมจบ - ชนะหรือแพ้)
        if MatchControl.MatchEnded then
            MatchControl.MatchEnded:Connect(function()
                DebugPrint("🏁 Match Ended - หยุดระบบทั้งหมด")
                _G.MatchEnded = true  -- ⭐⭐⭐ FLAG: หยุดระบบทั้งหมด
                ResetGameState()
            end)
        end

        if MatchControl.MatchStarted then
            MatchControl.MatchStarted:Connect(function()
                DebugPrint("🏁 Match Started - เริ่มระบบใหม่")
                _G.MatchEnded = false  -- ⭐ เริ่มใหม่
                ResetGameState()
                task.wait(3)  -- รอ 3 วินาทีก่อนเริ่มใหม่
            end)
        end
        
        -- MatchRestarted Event (เกมรีเซ็ต)
        if MatchControl.MatchRestarted then
            MatchControl.MatchRestarted:Connect(function()
                DebugPrint("🔄 Match Restarted - เริ่มระบบใหม่")
                _G.MatchEnded = false  -- ⭐ เริ่มใหม่
                ResetGameState()
            end)
        end
    else
        DebugPrint("⚠️ MatchControl not found")
    end
    
    -- ⭐ รอให้ UnitsHUD._Cache โหลดเสร็จก่อน
    local hotbarReady = false
    for i = 1, 30 do  -- รอสูงสุด 30 วินาที
        task.wait(1)
        if UnitsHUD and UnitsHUD._Cache then
            local count = 0
            for _ in pairs(UnitsHUD._Cache) do count = count + 1 end
            if count > 0 then
                DebugPrint(string.format("✅ Hotbar พร้อม! มี %d units", count))
                hotbarReady = true
                break
            end
        end
    end
    
    if not hotbarReady then
        DebugPrint("⚠️ Hotbar ไม่พร้อมหลังจากรอ 30 วินาที")
    end
    
    -- Reset cache เมื่อเริ่มเกมใหม่
    CachedUCenters = {}
    UsedUCenters = {}
    
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("[FORCED] 🎮 AUTO SKILL SYSTEM V6.2 STARTED!")
    print("[FORCED] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    -- ⭐⭐⭐ GLOBAL FLAG: เช็คว่ามีตัวเงินหรือไม่ (เช็คครั้งเดียวตอนเริ่ม)
    local hasAnyIncomeUnit = false
    local incomeCheckDone = false
    local normalModeLogged = false
    
    while ENABLED do
        -- ⭐⭐⭐ CHECK: MatchEnded - หยุดระบบทั้งหมด
        if _G.MatchEnded then
            task.wait(1)
            continue
        end
        
        -- ⭐⭐⭐ NOTE: Auto Place ทำงานทุกด่าน (ไม่บล็อค Challenge/Odyssey/Worldlines อีกต่อไป)
        local success, err = pcall(function()
            local yen = GetYen()
            local gamePhase = GetGamePhase()
            
            -- ⭐⭐⭐ เช็คว่ามีตัวเงินหรือไม่ (เช็คทุก 30 วินาที)
            if not incomeCheckDone or (tick() % 30 < 0.5) then
                hasAnyIncomeUnit = HasEconomyUnitInHotbar()  -- ⭐ FIX: ใช้ชื่อฟังก์ชันที่ถูกต้อง
                incomeCheckDone = true
            end
            
            -- 🚨 Emergency Mode: ตรวจสอบและวาง Stun units
            if ShouldActivateEmergencyMode() then
                PlaceStunUnitsEmergency()
            end
            
            -- ตรวจสอบ Emergency Mode เดิม (compatibility)
            CheckEmergency()
            
            -- ⬆️ อัพเกรด 1 ขั้นเมื่อ Emergency (ทั้ง 2 ระบบ)
            if IsEmergency or EmergencyMode.Active then
                UpgradeUnitsEmergency()
            end
            
            -- 🎯 AUTO SKILL V3: ใช้ Ability อัตโนมัติ
            AutoUseAbilitiesV3()
            
            -- 🔢 AUTO NUMBER PAD: ลองรหัสอัตโนมัติ (Imprisoned Island)
            pcall(AutoNumberPad)
            
            -- 🔄 AUTO REPLAY: Vote Replay อัตโนมัติ
            pcall(AutoVoteReplay)
            
            -- 🌀 AUTO PORTAL: เลือก Portal อัตโนมัติ
            pcall(AutoSelectPortal)
            
            -- ⭐⭐⭐ NEW: Auto Swap Check (Roku/Vogita, Smith John/Lord of Shadows)
            pcall(function()
                if _G.ToggleAutoSwapEvent and ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    for unitGuid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
                        if unitData and unitData.Name then
                            local swapConfig = AUTO_SWAP_UNITS[unitData.Name]
                            if swapConfig and not AutoSwapEnabled[unitGuid] then
                                -- เปิด Auto Swap สำหรับ unit นี้
                                local attrName = swapConfig.AttributeName
                                local currentState = plr:GetAttribute(attrName)
                                
                                if not currentState then
                                    -- เปิด Auto Swap
                                    pcall(function()
                                        _G.ToggleAutoSwapEvent:FireServer(unitGuid, true)
                                    end)
                                    AutoSwapEnabled[unitGuid] = true
                                    print(string.format("[Swap] ✅ %s Auto Swap", unitData.Name))
                                else
                                    AutoSwapEnabled[unitGuid] = true  -- Already enabled
                                end
                            end
                        end
                    end
                end
            end)
            
            -- ⭐⭐⭐ NEW: Auto Enable ToggleAuto for all units with AUTO ability
            pcall(function()
                if UnitEvent and ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    for unitGuid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
                        if unitData and unitData.Data then
                            -- เช็คว่า unit มี HasAutoAbility หรือไม่
                            local hasAutoAbility = unitData.Data.HasAutoAbility or 
                                                  unitData.Data.AutoAbility or
                                                  unitData.Data.CanToggleAuto
                            
                            -- เช็คว่าเปิด Auto อยู่หรือยัง
                            local autoEnabled = unitData.Data.AutoEnabled or 
                                               unitData.Data.IsAutoEnabled or
                                               unitData.AutoEnabled
                            
                            if hasAutoAbility and not autoEnabled then
                                -- เปิด Auto สำหรับ unit นี้
                                pcall(function()
                                    UnitEvent:FireServer("ToggleAuto", unitGuid)
                                end)
                                print(string.format("[Auto] ✅ %s ToggleAuto เปิด", unitData.Name))
                            end
                        end
                    end
                end
            end)
            
            -- 🔍 ClearEnemy Mode (นอก path เท่านั้น)
            CheckClearEnemyMode()
            
            -- 🏆 เช็ค Max Wave → ขายตัวเงินทั้งหมด (⭐ เฉพาะเมื่อมีตัวเงิน)
            if hasAnyIncomeUnit and CurrentWave > 0 and CurrentWave >= MaxWave and MaxWave > 0 and not MaxWaveSellTriggered then
                DebugPrint(string.format("WAVE MAX REACHED! (%d >= %d) -> SELLING ALL MONEY UNITS!", CurrentWave, MaxWave))
                SellAllMoneyUnits()
                MaxWaveSellTriggered = true
            end
            
            -- ⭐ ตรวจจับ Replay: ถ้า wave ลดลงมาก (เช่น จาก 20 กลับเป็น 1) → เริ่มเกมใหม่
            if PreviousWave > 5 and CurrentWave > 0 and CurrentWave < PreviousWave - 3 then
                DebugPrint(string.format("🔄 REPLAY DETECTED! Wave dropped from %d to %d - Resetting state", PreviousWave, CurrentWave))
                ResetGameState()
            end
            PreviousWave = CurrentWave  -- อัพเดท wave ก่อนหน้า
            
            -- Reset flag เมื่อ Wave กลับเป็น 0 (เกมใหม่)
            if CurrentWave == 0 and MaxWaveSellTriggered then
                MaxWaveSellTriggered = false
            end
            
            -- แสดง log เฉพาะเมื่อมีการเปลี่ยนแปลง
            local yenChanged = (yen ~= LastLoggedYen)
            local waveChanged = (CurrentWave ~= LastLoggedWave)
            local phaseChanged = (gamePhase ~= LastLoggedPhase)
            local emergencyChanged = (IsEmergency ~= LastLoggedEmergency)
            
            if yenChanged or waveChanged or phaseChanged or emergencyChanged then
                DebugPrint(string.format("━━━━━━━━━━━━━━━━━━━━━━━━━━"))
                DebugPrint(string.format("💰 Yen: %d | Wave: %d/%d | Phase: %s%s", 
                    yen, CurrentWave, MaxWave, gamePhase,
                    IsEmergency and " 🚨 EMERGENCY" or ""))
                
                LastLoggedYen = yen
                LastLoggedWave = CurrentWave
                LastLoggedPhase = gamePhase
                LastLoggedEmergency = IsEmergency
            end
            
            -- ===== CHECK: ขาย Emergency Units เมื่อ progress < 30% =====
            local progress = GetEnemyProgress()
            
            -- เช็คว่ามี Emergency Units ไหม
            local emergencyCount = 0
            for _ in pairs(EmergencyUnits) do emergencyCount = emergencyCount + 1 end
            
            if emergencyCount > 0 and progress < 30 and EmergencyActivated then
                local soldCount = 0
                local activeUnits = GetActiveUnits()
                local hasSummon = HasSummonUnitInHotbar()
                
                DebugPrint(string.format("💸 เริ่มขาย Emergency Units (progress=%.1f%%, มี %d ตัว)", progress, emergencyCount))
                
                for guid, _ in pairs(EmergencyUnits) do
                    for _, unit in pairs(activeUnits) do
                        if unit.GUID == guid then
                            -- ⭐⭐⭐ ถ้ามี Summon ใน Hotbar → ไม่ขาย Summon Unit (เก็บไว้อัพเกรด)
                            local isSummonUnit = unit.Data and IsPassiveSummonUnit(unit.Name, unit.Data)
                            
                            if hasSummon and isSummonUnit then
                                DebugPrint(string.format("🎯 เก็บ Summon Unit ไว้: %s (ไม่ขาย)", unit.Name))
                                -- ไม่ขาย แต่ลบออกจาก EmergencyUnits เพื่อให้กลายเป็น unit ปกติ
                                EmergencyUnits[guid] = nil
                            else
                                -- ขาย unit ปกติ
                                if SellUnit(unit) then
                                    soldCount = soldCount + 1
                                    DebugPrint(string.format("💸 ขาย Emergency Unit ตอน progress %.1f%%: %s", progress, unit.Name))
                                end
                            end
                            break
                        end
                    end
                end
                
                if soldCount > 0 or not next(EmergencyUnits) then
                    EmergencyUnits = {}
                    EmergencyActivated = false
                    LastEmergencyTime = 0
                    DebugPrint(string.format("✅ ขาย Emergency Units ครบ %d ตัวแล้ว", soldCount))
                end
            end
            
            -- ===== EMERGENCY MODE: วางแค่ 2 ตัว (LIMIT) =====
            if IsEmergency and not EmergencyActivated then
                -- ✅ FIX: นับจำนวน Emergency Units จาก table โดยตรง (ไม่เช็ค GUID กับ ClientUnitHandler)
                local emergencyCount = 0
                for _ in pairs(EmergencyUnits) do
                    emergencyCount = emergencyCount + 1
                end
                
                -- ⭐ เช็คว่ามี Summon Unit ใน Hotbar หรือไม่
                local hasSummon, summonSlotNum, summonUnitData = HasSummonUnitInHotbar()
                
                if hasSummon then
                    DebugPrint(string.format("🎯 Emergency Mode (Summon Strategy): วางแล้ว %d/1 ตัว", emergencyCount))
                else
                    DebugPrint(string.format("🚨 Emergency Mode (Normal): วางแล้ว %d/2 ตัว", emergencyCount))
                end
                
                -- ⭐ LIMIT: ถ้า hasSummon → วางแค่ 1 ตัว, ไม่มี Summon → วาง 2 ตัว
                local maxEmergencyUnits = hasSummon and 1 or 2
                
                if emergencyCount >= maxEmergencyUnits then
                    DebugPrint(string.format("✅ Emergency Units ครบ %d ตัวแล้ว - หยุดวาง", maxEmergencyUnits))
                    EmergencyActivated = true
                    IsEmergency = false  -- ⭐ Reset เพื่อให้ World Item ทำงานได้
                else
                    local timeSinceEmergency = tick() - EmergencyStartTime
                    if timeSinceEmergency >= 2 then  -- รอ 2 วินาที
                        local slot, unit, pos
                        
                        -- ⭐⭐⭐ ถ้ามี Summon Unit → วาง Summon ใกล้ Spawn
                        if hasSummon then
                            slot, unit = GetSummonUnitSlot()
                            
                            if slot and unit then
                                local unitRange = GetUnitRange(unit.Data) or 25
                                pos = GetSummonUnitPlacementPosition(unitRange, unit.Name, unit.Data)
                                
                                -- Fallback
                                if not pos then
                                    pos = GetBestPlacementPosition(unitRange, "early", unit.Name, unit.Data)
                                end
                            end
                        else
                            -- ⭐ ไม่มี Summon → วางตัวดาเมจปกติใกล้ศัตรู
                            slot, unit = GetCheapestDamageSlotNoLimit()
                            
                            if slot and unit and yen >= unit.Price then
                                local unitRange = GetUnitRange(unit.Data)
                                local unitName = unit.Name or ""
                                
                                -- ⭐⭐⭐ Lich King (Ruler) → วางหน้าประตูเสมอ (ทุก mode)
                                local isLichKingRuler = unitName:lower():find("lich") and unitName:lower():find("ruler")
                                
                                if unitRange then
                                    if isLichKingRuler then
                                        -- Lich King → หน้าประตู
                                        pos = GetBestFrontPosition(unitRange)
                                        print(string.format("[Emergency] 👑 Lich King (Ruler) → วางหน้าประตู"))
                                    else
                                        pos = GetEmergencyPlacementPosition(unitRange, unit.Name, unit.Data)
                                    end
                                    
                                    -- Fallback
                                    if not pos then
                                        pos = GetBestPlacementPosition(unitRange, "late", unit.Name, unit.Data)
                                    end
                                end
                            end
                        end
                        
                        -- วาง Unit
                        if slot and unit and pos then
                            local success, newGUID = PlaceUnit(slot, pos)
                            if success and newGUID then
                                EmergencyUnits[newGUID] = true
                                LastEmergencyTime = tick()
                                emergencyCount = emergencyCount + 1
                                
                                if hasSummon then
                                    DebugPrint(string.format("🎯 วาง Summon Unit: %s (ใกล้ Spawn)", unit.Name))
                                else
                                    DebugPrint(string.format("🚨 วาง Emergency Unit #%d: %s", emergencyCount, unit.Name))
                                end
                            
                                if emergencyCount >= maxEmergencyUnits then
                                    DebugPrint(string.format("✅ Emergency Units ครบ %d ตัวแล้ว!", maxEmergencyUnits))
                                    EmergencyActivated = true
                                    IsEmergency = false  -- ⭐ Reset เพื่อให้ World Item ทำงานได้
                                end
                            else
                                DebugPrint("⚠️ วาง Emergency Unit ไม่สำเร็จ")
                            end
                        else
                            if not slot then
                                DebugPrint("⚠️ Emergency: ไม่มี Damage Unit ให้วาง")
                                EmergencyActivated = true
                            else
                                -- ⭐ มี Unit แต่เงินไม่พอ → รอจนกว่าจะมีเงินพอ (ไม่ข้าม!)
                                DebugPrint(string.format("⏳ Emergency: เงินไม่พอ (มี %d, ต้องการ %d) - รอเงิน...", yen, unit.Price))
                            end
                        end
                    end
                end
            end
            
            -- ===== NORMAL MODE: วางตัวเงินก่อน → อัพเกรดตัวเงินให้ MAX → แล้วค่อยวาง Damage =====
            -- ⚠️ ถ้ามี ClearEnemy Units อยู่ → หยุด Auto Place (ให้ ClearEnemy ทำงานก่อน)
            if next(ClearEnemyUnits) then
                -- มี ClearEnemy Units → ข้าม Normal Placement
                if not LastLoggedClearEnemyBlock then
                    LastLoggedClearEnemyBlock = true
                end
            else
                -- ไม่มี ClearEnemy Units → รีเซ็ต log flag
                if LastLoggedClearEnemyBlock then
                    LastLoggedClearEnemyBlock = false
                end
                
                -- ✅✅✅ FIX: อนุญาตให้วางตัวปกติเฉพาะเมื่อ:
                -- ⭐⭐⭐ FIX: ให้ ClearEnemy Mode ทำงานควบคู่กับ Auto Place ปกติ
                -- canPlaceNormal = true เมื่อ:
                -- 1. ไม่อยู่ใน Emergency Mode (IsEmergency = false) หรือ
                -- 2. อยู่ใน Emergency Mode แต่วางครบแล้ว (EmergencyActivated = true)
                -- 🔥 ClearEnemy Mode ไม่บล็อก Auto Place! (ทำงานพร้อมกัน)
                -- ⭐ FIX: ไม่ต้องเช็ค EmergencyUnits เพราะมันเก็บ track units ไว้ขายทีหลัง
                local canPlaceNormal = (not IsEmergency or EmergencyActivated)
                
                -- ⭐⭐⭐ FIX: MaxWaveSellTriggered ห้ามวาง Economy เท่านั้น ไม่ห้ามวาง Damage!
                -- ย้ายการเช็ค MaxWaveSellTriggered ไปไว้เฉพาะส่วนวาง Economy
                
                -- Debug: แสดงสถานะ canPlaceNormal (ปิด log เพื่อลด spam)
                _G.LastCanPlaceNormal = canPlaceNormal
                
                if canPlaceNormal then
                    local hasEconomyInHotbar = hasAnyIncomeUnit and HasEconomyUnitInHotbar()  -- ⭐ ใช้ flag
                    local activeUnits = GetActiveUnits()
                
                    -- ===== STEP 1: วางตัวเงินก่อน (⭐ เฉพาะเมื่อมีตัวเงิน + ไม่ใช่ MaxWave) =====
                    -- ⭐⭐⭐ FIX: ข้ามทั้งหมดถ้าไม่มีตัวเงิน
                    if hasAnyIncomeUnit and not MaxWaveSellTriggered then
                        local ecoSlot, ecoUnit = GetNextEconomySlot()
                        if ecoSlot and ecoUnit then
                            local positions = GetPlaceablePositions()
                            if #positions > 0 then
                                -- ลองหาตำแหน่งว่างจาก list
                                local placed = false
                                for i, pos in ipairs(positions) do
                                    if i > 20 then break end  -- จำกัดไม่เกิน 20 ตำแหน่ง
                                
                                -- เช็คว่าตำแหน่งนี้ว่างหรือไม่
                                if CanPlaceAtPosition(ecoUnit.Name, pos) then
                                    DebugPrint(string.format("🎯 วาง %s (slot %d) ที่ %.1f, %.1f, %.1f (ตำแหน่ง #%d)", 
                                        ecoUnit.Name, ecoSlot, pos.X, pos.Y, pos.Z, i))
                                    local success = PlaceUnit(ecoSlot, pos)
                                    if success then
                                        placed = true
                                        break
                                    end
                                end
                            end
                            
                            if not placed then
                                DebugPrint(string.format("⚠️ ไม่สามารถวาง %s ได้ (ทดสอบ %d ตำแหน่ง)", ecoUnit.Name, math.min(20, #positions)))
                            end
                        else
                            DebugPrint("⚠️ ไม่พบตำแหน่งที่วางได้")
                        end
                    end
                    end  -- ⭐ END: if not MaxWaveSellTriggered (วาง Economy)
                    
                    -- ===== STEP 2: ถ้าวางตัวเงินครบแล้ว → อัพเกรดตัวเงินให้ MAX ก่อน (Multiple Upgrade) =====
                    local economyNeedsUpgrade = false
                    local economyUpgraded = false
                    
                    -- 🔥 Collect all upgradeable economy units with cost
                    local upgradeableEconomyUnits = {}
                    for _, unit in pairs(activeUnits) do
                        -- ⭐ ข้ามถ้าไม่มีตัวเงิน
                        if not hasAnyIncomeUnit then break end
                        if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
                            local currentLevel = GetCurrentUpgradeLevel(unit)
                            local maxLevel = GetMaxUpgradeLevel(unit)
                            
                            if currentLevel < maxLevel then
                                economyNeedsUpgrade = true
                                local cost = GetUpgradeCost(unit)
                                if cost < math.huge then
                                    table.insert(upgradeableEconomyUnits, {
                                        unit = unit,
                                        cost = cost,
                                        currentLevel = currentLevel
                                    })
                                else
                                    DebugPrint(string.format("⚠️ ไม่มี upgrade cost สำหรับ %s", unit.Name))
                                end
                            end
                        end
                    end
                    
                    -- 🔥 Sort by cost (cheapest first) to distribute upgrades
                    table.sort(upgradeableEconomyUnits, function(a, b)
                        return a.cost < b.cost
                    end)
                    
                    -- 🔥 Upgrade all affordable units (cheapest first)
                    for _, upgradeData in ipairs(upgradeableEconomyUnits) do
                        local unit = upgradeData.unit
                        local cost = upgradeData.cost
                        local currentLevel = upgradeData.currentLevel
                        
                        if GetYen() >= cost then
                            DebugPrint(string.format("⬆️ อัพเกรดตัวเงิน: %s [%d→%d] cost=%d, Yen: %d", 
                                unit.Name, currentLevel, currentLevel+1, cost, GetYen()))
                            
                            local upgradeSuccess = UpgradeUnit(unit)
                            if upgradeSuccess then
                                economyUpgraded = true
                                -- ⭐⭐⭐ FIX: ไม่ต้องรอ - อัพเกรดต่อทันที
                                DebugPrint(string.format("✅ อัพเกรดสำเร็จ: %s", unit.Name))
                            else
                                DebugPrint(string.format("❌ อัพเกรดล้มเหลว: %s", unit.Name))
                            end
                        else
                            -- หยุดเมื่อเงินไม่พอ
                            break
                        end
                    end
                    
                    -- ⭐⭐⭐ FIX: เช็คอีกครั้งหลังอัพเกรด (ไม่ต้องรอ)
                    if economyUpgraded then
                        activeUnits = GetActiveUnits()
                        
                        economyNeedsUpgrade = false  -- รีเซ็ตก่อน
                        local economyStatus = {}
                        
                        for _, unit in pairs(activeUnits) do
                            if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
                                local currentLevel = GetCurrentUpgradeLevel(unit)
                                local maxLevel = GetMaxUpgradeLevel(unit)
                                
                                table.insert(economyStatus, string.format("%s [%d/%d]", unit.Name, currentLevel, maxLevel))
                                
                                if currentLevel < maxLevel then
                                    economyNeedsUpgrade = true
                                end
                            end
                        end
                        
                        DebugPrint(string.format("💰 Economy Status: %s", table.concat(economyStatus, ", ")))
                        DebugPrint(string.format("✅ อัพเกรดตัวเงินเสร็จ → economyNeedsUpgrade=%s", tostring(economyNeedsUpgrade)))
                        
                        -- 🔥🔥🔥 FIX: อัพเกรดตัวเงินทันที (ไม่มี wait - ไม่ spam)
                        if economyNeedsUpgrade then
                            for _, unit in pairs(activeUnits) do
                                if unit.Data and IsIncomeUnit(unit.Name, unit.Data) and not IsUnitMaxed(unit) then
                                    local cost = GetUpgradeCost(unit)
                                    if cost < math.huge and GetYen() >= cost then
                                        UpgradeUnit(unit)
                                        -- ⭐ อัพเกรด 1 ตัวต่อ loop cycle (ไม่ spam)
                                        break
                                    end
                                end
                            end
                            -- อัพเดท economyNeedsUpgrade
                            economyNeedsUpgrade = false
                            for _, unit in pairs(activeUnits) do
                                if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
                                    if GetCurrentUpgradeLevel(unit) < GetMaxUpgradeLevel(unit) then
                                        economyNeedsUpgrade = true
                                        break
                                    end
                                end
                            end
                        end
                    end  -- ⭐ END: if economyUpgraded
                    
                    -- ===== STEP 3: วาง Damage เมื่อ (ไม่มีตัวเงินใน Hotbar) หรือ (ตัวเงินอัพ MAX แล้ว) =====
                    -- ⭐⭐⭐ FIX: ถ้าไม่มีตัวเงิน → วาง Damage ทันที
                    local hasEcoInHotbar = hasAnyIncomeUnit and HasEconomyUnitInHotbar() or false
                    local shouldPlaceDamage = (not hasEcoInHotbar) or (not economyNeedsUpgrade)
                    
                    -- Debug log
                    if not _G.LastShouldPlaceDamage or _G.LastShouldPlaceDamage ~= shouldPlaceDamage then
                        DebugPrint(string.format("🔍 shouldPlaceDamage=%s | hasEcoInHotbar=%s | economyNeedsUpgrade=%s", 
                            tostring(shouldPlaceDamage), tostring(hasEcoInHotbar), tostring(economyNeedsUpgrade)))
                        _G.LastShouldPlaceDamage = shouldPlaceDamage
                    end
                    
                    if shouldPlaceDamage then
                        local dmgSlot, dmgUnit = GetNextDamageSlot()
                        
                        -- ⭐⭐⭐ FIX: เช็คว่า slot ว่างไหม (ป้องกันวางซ้ำ)
                        local hasAvailableSlot = false
                        if dmgSlot and dmgUnit then
                            local limit, current = GetSlotLimit(dmgSlot)
                            if current < limit then
                                hasAvailableSlot = true
                            else
                                -- Slot เต็ม → ไม่วาง แต่อัพเกรดแทน
                                DebugPrint(string.format("⚠️ Damage Slot %d เต็ม (%d/%d) → ข้ามการวาง, อัพเกรดแทน", 
                                    dmgSlot, current, limit))
                            end
                        end
                        
                        -- Debug log
                        if not dmgSlot then
                            -- ไม่มี damage slot
                        elseif not dmgUnit then
                            DebugPrint(string.format("⚠️ GetNextDamageSlot() slot=%d แต่ unit=nil", dmgSlot))
                        end
                        
                        -- ⭐⭐⭐ FIX: วางเฉพาะเมื่อ slot ว่าง!
                        if dmgSlot and dmgUnit and hasAvailableSlot then
                            local unitRange = GetUnitRange(dmgUnit.Data) or 18
                            local pos = nil
                            
                            -- ⭐⭐⭐ Lich King (Ruler) และ Caloric Stone Clone → วางหน้าประตูเสมอ (ทุกด่าน)
                            local unitName = dmgUnit.Name or ""
                            local isLichKingRuler = unitName:lower():find("lich") and unitName:lower():find("ruler")
                            local placeAtFront = dmgUnit.PlaceAtFront or isLichKingRuler
                            
                            if placeAtFront then
                                -- วิเคราะห์ก่อนวาง
                                print(string.format("[Analysis] 🔍 %s - วางหน้าประตู (Range: %d)", unitName, unitRange))
                                pos = GetBestFrontPosition(unitRange)
                                if pos then
                                    print(string.format("[Analysis] ✅ พบตำแหน่งหน้าประตู: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
                                end
                            end
                            
                            -- Fallback: ใช้ตำแหน่งปกติถ้าไม่เจอ front position
                            if not pos then
                                pos = GetBestPlacementPosition(unitRange, GetGamePhase(), dmgUnit.Name, dmgUnit.Data)
                            end
                            
                            if pos then
                                DebugPrint(string.format("⚔️ วาง Damage: %s (slot %d)", dmgUnit.Name, dmgSlot))
                                PlaceUnit(dmgSlot, pos)
                            end
                        else
                            -- ===== STEP 3.5: Slot เต็มหรือไม่มี Damage Slot → อัพเกรดแบบ "1 Unit All-in" =====
                            -- 🔥 อัพเกรดเฉพาะ ClearEnemy Units เท่านั้น!
                            local damageUnits = {}
                            for _, unit in pairs(activeUnits) do
                                local unitData = unit.Data or {}
                                -- เลือกเฉพาะ ClearEnemy Units ที่เป็นตัวดาเมจ (ไม่ใช่ตัวเงิน, ไม่ใช่ buff, ไม่ใช่ Emergency)
                                local isClearEnemyUnit = ClearEnemyUnits[unit.GUID] ~= nil
                                
                                if isClearEnemyUnit and 
                                   not EmergencyUnits[unit.GUID] and 
                                   not IsIncomeUnit(unit.Name, unitData) and 
                                   not IsBuffUnit(unit.Name, unitData) then
                                    table.insert(damageUnits, unit)
                                end
                            end
                            
                            if #damageUnits > 0 then
                                -- 🔥 ClearEnemy Mode: อัพเกรดแค่ 1 ขั้นต่อรอบ (ไม่ loop)
                                local strongest = GetStrongestUnit(damageUnits)
                                
                                if strongest and not IsUnitMaxed(strongest) then
                                    -- อัพเกรดตัวแรงสุด 1 ขั้น
                                    local cost = GetUpgradeCost(strongest)
                                    if cost < math.huge and GetYen() >= cost then
                                        local currentLevel = GetCurrentUpgradeLevel(strongest)
                                        local maxLevel = GetMaxUpgradeLevel(strongest)
                                        DebugPrint(string.format("⬆️ [ClearEnemy] อัพเกรดตัวแรงสุด: %s (%d/%d)", strongest.Name, currentLevel, maxLevel))
                                        UpgradeUnit(strongest)
                                    end
                                elseif strongest and IsUnitMaxed(strongest) then
                                    -- ตัวแรงสุด MAX แล้ว → หาตัวถัดไปที่ยังไม่ MAX
                                    local nextUnit = nil
                                    local lowestLevel = math.huge
                                    
                                    for _, unit in ipairs(damageUnits) do
                                        if unit.GUID ~= strongest.GUID and not IsUnitMaxed(unit) then
                                            local currentLevel = GetCurrentUpgradeLevel(unit)
                                            if currentLevel < lowestLevel then
                                                lowestLevel = currentLevel
                                                nextUnit = unit
                                            end
                                        end
                                    end
                                    
                                    if nextUnit then
                                        local cost = GetUpgradeCost(nextUnit)
                                        if cost < math.huge and GetYen() >= cost then
                                            local currentLevel = GetCurrentUpgradeLevel(nextUnit)
                                            local maxLevel = GetMaxUpgradeLevel(nextUnit)
                                            DebugPrint(string.format("⬆️ [ClearEnemy] อัพเกรดตัวถัดไป: %s (%d/%d)", nextUnit.Name, currentLevel, maxLevel))
                                            UpgradeUnit(nextUnit)
                                        end
                                    end
                                end
                            end
                        end
                    end
                
                    -- ===== Auto Upgrade Damage/Buff (หลังจากตัวเงินอัพ MAX แล้ว) =====
                    -- ⚠️ NOTE: Lich King จะอัพเกรดหลังตัวเงิน MAX เท่านั้น (อยู่ใน allEconomyMaxed)
                    -- แยกประเภท Units (ข้าม Emergency Units + ClearEnemy Units)
                    local allEconomyMaxed = true
                    for _, unit in pairs(activeUnits) do
                        if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
                            -- ⭐ ใช้ฟังก์ชันจาก Decom
                            if not IsUnitMaxed(unit) then
                                allEconomyMaxed = false
                                break
                            end
                        end
                    end
                
                    -- อัพเกรด Damage/Buff เฉพาะเมื่อตัวเงินอัพ MAX แล้ว
                    if allEconomyMaxed then
                        local damageUnits = {}
                        local buffUnits = {}
                        local summonUnits = {}  -- ⭐ เพิ่ม Summon Units
                        
                        for _, unit in pairs(activeUnits) do
                            local unitData = unit.Data or {}
                            -- ⭐ รวม Emergency Units ที่เป็น Summon (ไม่ขายแล้ว)
                            local skipEmergency = EmergencyUnits[unit.GUID] and not IsPassiveSummonUnit(unit.Name, unitData)
                            -- 🔥 ข้าม ClearEnemy Units (ให้ ClearEnemy Mode จัดการเอง)
                            local isClearEnemyUnit = ClearEnemyUnits[unit.GUID] ~= nil
                            -- ⭐⭐⭐ ข้าม Caloric Clone Units (ห้ามอัพเกรด)
                            local isCaloricClone = CaloricCloneUnits[unit.GUID] ~= nil
                            
                            if not skipEmergency and not isClearEnemyUnit and not isCaloricClone and not IsIncomeUnit(unit.Name, unitData) then
                                if IsBuffUnit(unit.Name, unitData) then
                                    table.insert(buffUnits, unit)
                                elseif IsPassiveSummonUnit(unit.Name, unitData) then
                                    table.insert(summonUnits, unit)  -- ⭐ แยก Summon Units
                                else
                                    table.insert(damageUnits, unit)
                                end
                            end
                        end
                        
                        -- ⭐⭐⭐ PRIORITY 0: Force Upgrade Lich King (Ruler) ก่อนเสมอ
                        for _, unit in pairs(damageUnits) do
                            local isLichKingRuler = unit.Name:lower():find("lich") and unit.Name:lower():find("ruler")
                            if isLichKingRuler and not IsUnitMaxed(unit) then
                                local cost = GetUpgradeCost(unit)
                                if cost < math.huge and GetYen() >= cost then
                                    local currentLevel = GetCurrentUpgradeLevel(unit)
                                    local maxLevel = GetMaxUpgradeLevel(unit)
                                    print(string.format("[ForceUpgrade] 👑 Lich King (Ruler) (%d/%d) [ค่าใช้จ่าย: %d]", currentLevel, maxLevel, cost))
                                    UpgradeUnit(unit)
                                    task.wait(0.1)
                                end
                            end
                        end
                        
                        -- 🔥 Priority 1: Upgrade Damage units แบบ "1 Unit All-in" จนกว่าเงินจะหมด
                        if #damageUnits > 0 then
                            local continueUpgrading = true
                            local upgradeCount = 0
                            local maxUpgradesPerLoop = 50  -- ป้องกัน infinite loop
                        
                            while continueUpgrading and upgradeCount < maxUpgradesPerLoop do
                                continueUpgrading = false
                                
                                -- ⭐ เช็คเงินก่อนทุกครั้ง
                                local currentYen = GetYen()
                                if currentYen < 100 then
                                    DebugPrint("⏸️ เงินน้อยเกินไป - หยุด Auto Upgrade Damage")
                                    break
                                end
                                
                                local strongest = GetStrongestUnit(damageUnits)
                                
                                if strongest and not IsUnitMaxed(strongest) then
                                    -- อัพเกรดตัวแรงสุดให้ MAX ก่อน
                                    local cost = GetUpgradeCost(strongest)
                                    if cost < math.huge and GetYen() >= cost then
                                        local currentLevel = GetCurrentUpgradeLevel(strongest)
                                        local maxLevel = GetMaxUpgradeLevel(strongest)
                                        DebugPrint(string.format("⬆️ อัพเกรด Damage: %s (%d/%d) [ค่าใช้จ่าย: %d]", strongest.Name, currentLevel, maxLevel, cost))
                                        UpgradeUnit(strongest)
                                        upgradeCount = upgradeCount + 1
                                        continueUpgrading = true  -- อัพสำเร็จ ลองต่อ
                                        task.wait(0.1)  -- ⭐ รอให้เงินอัพเดท
                                    else
                                        -- เงินไม่พอ หรือ cost error
                                        DebugPrint(string.format("⏸️ เงินไม่พออัพ %s (ต้องการ: %d, มี: %d)", strongest.Name, cost, GetYen()))
                                        break
                                    end
                                elseif strongest and IsUnitMaxed(strongest) then
                                    -- ตัวแรงสุด MAX แล้ว → หาตัวถัดไปที่ยังไม่ MAX
                                    local nextUnit = nil
                                    local lowestLevel = math.huge
                                    
                                    for _, unit in ipairs(damageUnits) do
                                        if unit.GUID ~= strongest.GUID and not IsUnitMaxed(unit) then
                                            local currentLevel = GetCurrentUpgradeLevel(unit)
                                            if currentLevel < lowestLevel then
                                                lowestLevel = currentLevel
                                                nextUnit = unit
                                            end
                                        end
                                    end
                                    
                                    if nextUnit then
                                        local cost = GetUpgradeCost(nextUnit)
                                        if cost < math.huge and GetYen() >= cost then
                                            local currentLevel = GetCurrentUpgradeLevel(nextUnit)
                                            local maxLevel = GetMaxUpgradeLevel(nextUnit)
                                            DebugPrint(string.format("⬆️ อัพเกรด Damage ถัดไป: %s (%d/%d) [ค่าใช้จ่าย: %d]", nextUnit.Name, currentLevel, maxLevel, cost))
                                            UpgradeUnit(nextUnit)
                                            upgradeCount = upgradeCount + 1
                                            continueUpgrading = true  -- อัพสำเร็จ ลองต่อ
                                            task.wait(0.1)  -- ⭐ รอให้เงินอัพเดท
                                        else
                                            DebugPrint(string.format("⏸️ เงินไม่พออัพ %s (ต้องการ: %d, มี: %d)", nextUnit.Name, cost, GetYen()))
                                            break
                                        end
                                    else
                                        -- ไม่มีตัวถัดไปแล้ว (ทุกตัว MAX)
                                        DebugPrint("✅ Damage Units MAX ทั้งหมดแล้ว")
                                        break
                                    end
                                else
                                    -- ไม่มี strongest หรือ error
                                    break
                                end
                            end
                            
                            if upgradeCount >= maxUpgradesPerLoop then
                                DebugPrint(string.format("⚠️ Damage Upgrade ถึงลิมิต (%d ครั้ง)", maxUpgradesPerLoop))
                            end
                        end  -- ปิด while + if #damageUnits
                        
                        -- ⭐⭐⭐ Priority 0: Upgrade Summon Units ก่อน (ถ้ามี)
                        if #summonUnits > 0 then
                            DebugPrint(string.format("🎯 พบ Summon Units: %d ตัว - เริ่มอัพเกรด", #summonUnits))
                            
                            local summonContinue = true
                            local summonUpgradeCount = 0
                            
                            while summonContinue and summonUpgradeCount < 50 do
                                summonContinue = false
                                
                                -- ⭐ เช็คเงินก่อน
                                if GetYen() < 100 then
                                    DebugPrint("⏸️ เงินน้อยเกินไป - หยุด Auto Upgrade Summon")
                                    break
                                end
                                
                                for _, unit in ipairs(summonUnits) do
                                    if not IsUnitMaxed(unit) then
                                        local cost = GetUpgradeCost(unit)
                                        if cost < math.huge and GetYen() >= cost then
                                            local currentLevel = GetCurrentUpgradeLevel(unit)
                                            local maxLevel = GetMaxUpgradeLevel(unit)
                                            DebugPrint(string.format("⬆️ อัพเกรด Summon: %s (%d/%d) [ค่าใช้จ่าย: %d]", unit.Name, currentLevel, maxLevel, cost))
                                            UpgradeUnit(unit)
                                            summonUpgradeCount = summonUpgradeCount + 1
                                            summonContinue = true
                                            task.wait(0.1)
                                            break
                                        else
                                            DebugPrint(string.format("⏸️ เงินไม่พออัพ %s (ต้องการ: %d, มี: %d)", unit.Name, cost, GetYen()))
                                        end
                                    end
                                end
                            end
                            
                            if summonUpgradeCount >= 50 then
                                DebugPrint("⚠️ Summon Upgrade ถึงลิมิต (50 ครั้ง)")
                            elseif summonUpgradeCount == 0 then
                                DebugPrint("✅ Summon Units MAX หรือเงินไม่พอ")
                            end
                        end
                        
                        -- Priority 2: Upgrade Buff units จนกว่าเงินจะหมด
                        local buffContinue = true
                        local buffUpgradeCount = 0
                        while buffContinue and buffUpgradeCount < 50 do
                            buffContinue = false
                            
                            -- ⭐ เช็คเงินก่อน
                            if GetYen() < 100 then
                                DebugPrint("⏸️ เงินน้อยเกินไป - หยุด Auto Upgrade Buff")
                                break
                            end
                            
                            for _, unit in pairs(buffUnits) do
                                if not IsUnitMaxed(unit) then
                                    local cost = GetUpgradeCost(unit)
                                    if cost < math.huge and GetYen() >= cost then
                                        local currentLevel = GetCurrentUpgradeLevel(unit)
                                        local maxLevel = GetMaxUpgradeLevel(unit)
                                        DebugPrint(string.format("⬆️ อัพเกรด Buff: %s (%d/%d) [ค่าใช้จ่าย: %d]", unit.Name, currentLevel, maxLevel, cost))
                                        UpgradeUnit(unit)
                                        buffUpgradeCount = buffUpgradeCount + 1
                                        buffContinue = true
                                        task.wait(0.1)
                                        break  -- อัพแล้วเริ่ม loop ใหม่
                                    else
                                        DebugPrint(string.format("⏸️ เงินไม่พออัพ %s (ต้องการ: %d, มี: %d)", unit.Name, cost, GetYen()))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        if not success then
            print(string.format("[FORCED] ❌ Loop Error: %s", tostring(err)))
        end
        
        -- ⭐⭐⭐ INDEPENDENT AUTO UPGRADE: ทำงานแยกจาก placement logic
        -- รันทุกรอบ ไม่สนใจ ClearEnemy, Emergency, หรือ Skill usage
        pcall(function()
            local activeUnits = GetActiveUnits()
            if not activeUnits then return end
            
            -- 1. Auto Upgrade God (Standless) - ทำงานพร้อม Skill (Independent)
            for _, unit in pairs(activeUnits) do
                local unitName = unit.Name or ""
                local isGodStandless = unitName:lower():find("god") and (unitName:lower():find("standless") or unitName:lower():find("above"))
                if isGodStandless and not IsUnitMaxed(unit) then
                    local cost = GetUpgradeCost(unit)
                    if cost < math.huge and GetYen() >= cost then
                        local currentLevel = GetCurrentUpgradeLevel(unit)
                        local maxLevel = GetMaxUpgradeLevel(unit)
                        print(string.format("[IndependentUpgrade] ⚡ God Standless (%d/%d) [%d yen]", currentLevel, maxLevel, cost))
                        UpgradeUnit(unit)
                        task.wait(0.1)
                    end
                end
            end
            
            -- 2. เช็คตัวเงิน MAX ก่อน
            local allEcoMaxed = true
            for _, unit in pairs(activeUnits) do
                if unit.Data and IsIncomeUnit(unit.Name, unit.Data) and not IsUnitMaxed(unit) then
                    allEcoMaxed = false
                    break
                end
            end
            
            -- 3. Emergency Mode - Auto Upgrade Summon Units (หลังตัวเงิน MAX)
            if allEcoMaxed and (IsEmergency or EmergencyMode.Active) then
                for _, unit in pairs(activeUnits) do
                    local unitData = unit.Data or {}
                    if IsPassiveSummonUnit(unit.Name, unitData) and not IsUnitMaxed(unit) then
                        local cost = GetUpgradeCost(unit)
                        if cost < math.huge and GetYen() >= cost then
                            local currentLevel = GetCurrentUpgradeLevel(unit)
                            local maxLevel = GetMaxUpgradeLevel(unit)
                            print(string.format("[Emergency] 🎯 Summon Upgrade: %s (%d/%d) [%d yen]", unit.Name, currentLevel, maxLevel, cost))
                            UpgradeUnit(unit)
                            task.wait(0.1)
                        end
                    end
                end
            end
            
            -- 4. หลังตัวเงิน MAX → อัพเกรดตัว DMG สูงสุด
            if allEcoMaxed then
                -- หาตัว DMG สูงสุดที่ยังไม่ MAX
                local highestDmgUnit = nil
                local highestDmg = 0
                
                for _, unit in pairs(activeUnits) do
                    local unitData = unit.Data or {}
                    -- ข้ามตัวเงิน, buff, caloric clone
                    if not IsIncomeUnit(unit.Name, unitData) and 
                       not IsBuffUnit(unit.Name, unitData) and 
                       not CaloricCloneUnits[unit.GUID] and
                       not IsUnitMaxed(unit) then
                        -- หา DMG จาก unit data
                        local dmg = unitData.Damage or unitData.DPS or 0
                        if dmg > highestDmg then
                            highestDmg = dmg
                            highestDmgUnit = unit
                        end
                    end
                end
                
                -- อัพเกรดตัว DMG สูงสุด
                if highestDmgUnit then
                    local cost = GetUpgradeCost(highestDmgUnit)
                    if cost < math.huge and GetYen() >= cost then
                        local currentLevel = GetCurrentUpgradeLevel(highestDmgUnit)
                        local maxLevel = GetMaxUpgradeLevel(highestDmgUnit)
                        print(string.format("[IndependentUpgrade] 🔥 Highest DMG: %s (%d/%d) [%d yen]", highestDmgUnit.Name, currentLevel, maxLevel, cost))
                        UpgradeUnit(highestDmgUnit)
                        task.wait(0.1)
                    end
                end
            end
        end)
        
        task.wait(0.5)  -- 0.5 วินาที
    end
end

-- ===== AUTO START & VOTE SKIP SYSTEM =====
local function AutoVoteSkip()
    local currentTime = tick()
    if currentTime - LastVoteSkipTime < 2 then return end  -- 2 วินาที cooldown
    
    -- วิธี 1: ใช้ SkipWaveEvent
    if SkipWaveEvent then
        pcall(function()
            SkipWaveEvent:FireServer("Skip")
            LastVoteSkipTime = currentTime
            -- Log เฉพาะทุก 10 วินาที
            if currentTime - LastVoteSkipLog >= 10 then
                DebugPrint("⏭️ Vote Skip sent")
                LastVoteSkipLog = currentTime
            end
        end)
        return
    end
    
    -- วิธี 2: หาปุ่ม Skip ใน GUI
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            for _, desc in pairs(HUD:GetDescendants()) do
                if (desc:IsA("TextButton") or desc:IsA("ImageButton")) then
                    local name = desc.Name:lower()
                    local text = ""
                    if desc:IsA("TextButton") then
                        text = (desc.Text or ""):lower()
                    end
                    
                    if (name:find("skip") or text:find("skip")) and desc.Visible then
                        -- ลองคลิก
                        pcall(function()
                            if getconnections then
                                for _, conn in pairs(getconnections(desc.MouseButton1Click)) do
                                    conn:Fire()
                                end
                            end
                        end)
                        
                        LastVoteSkipTime = currentTime
                        break
                    end
                end
            end
        end
    end)
end

local function TryStartGame()
    local success = false
    local currentTime = tick()
    
    -- วิธี 1: ใช้ SkipWaveEvent
    pcall(function()
        if SkipWaveEvent then
            SkipWaveEvent:FireServer("Skip")
            -- Log เฉพาะทุก 10 วินาที
            if currentTime - LastStartLog >= 10 then
                DebugPrint("▶️ Trying to start game via SkipWaveEvent")
                LastStartLog = currentTime
            end
            success = true
        end
    end)
    
    if success then return true end
    
    -- วิธี 2: หา Start/Ready Button
    pcall(function()
        local guisToSearch = {
            PlayerGui:FindFirstChild("LobbyHUD"),
            PlayerGui:FindFirstChild("Lobby"),
            PlayerGui:FindFirstChild("MainHUD"),
            PlayerGui:FindFirstChild("HUD"),
        }
        
        for _, gui in pairs(guisToSearch) do
            if gui and not success then
                for _, desc in pairs(gui:GetDescendants()) do
                    if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and not success then
                        local name = desc.Name:lower()
                        local text = ""
                        if desc:IsA("TextButton") then
                            text = (desc.Text or ""):lower()
                        end
                        
                        local isStartButton = name:find("start") or name:find("ready") or name:find("begin")
                        local isStartText = text:find("start") or text:find("ready") or text:find("begin")
                        
                        if (isStartButton or isStartText) and desc.Visible then
                            pcall(function()
                                if getconnections then
                                    for _, conn in pairs(getconnections(desc.MouseButton1Click)) do
                                        conn:Fire()
                                    end
                                end
                            end)
                            
                            success = true
                            break
                        end
                    end
                end
            end
        end
    end)
    
    -- วิธี 3: ใช้ StartMatchEvent
    if not success and StartMatchEvent then
        pcall(function()
            StartMatchEvent:FireServer()
            success = true
        end)
    end
    
    -- วิธี 4: ใช้ ReadyEvent
    if not success and ReadyEvent then
        pcall(function()
            ReadyEvent:FireServer(true)
            success = true
        end)
    end
    
    return success
end

-- ===== START =====
task.spawn(AutoPlaceLoop)

-- Auto Start Loop (inline - ไม่ใช้ local function เพื่อลด register)
task.spawn(function()
    while true do
        task.wait(3)
        if ENABLED then pcall(TryStartGame) end
    end
end)

-- Vote Skip Loop
task.spawn(function()
    while true do
        task.wait(1)
        if ENABLED then pcall(AutoVoteSkip) end
    end
end)

-- ===== AUTO REPLAY SYSTEM =====
-- ⭐ ใช้ ShowEndScreenEvent.OnClientEvent (ตามโค้ดของ user)
local LastReplayVoteTime = 0
local REPLAY_VOTE_COOLDOWN = 3
local AUTO_REPLAY_ENABLED = true
local EndScreenVoteEvent = nil

-- โหลด VoteEvent
pcall(function()
    EndScreenVoteEvent = ReplicatedStorage:FindFirstChild("Networking")
        and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
        and ReplicatedStorage.Networking.EndScreen:FindFirstChild("VoteEvent")
end)

local function AutoVoteReplay()
    if not AUTO_REPLAY_ENABLED then return end
    if not EndScreenVoteEvent then return end
    
    local now = tick()
    if now - LastReplayVoteTime < REPLAY_VOTE_COOLDOWN then return end
    LastReplayVoteTime = now
    
    pcall(function()
        EndScreenVoteEvent:FireServer("Retry")
        print("[AutoReplay] 🔄 Voted Retry via VoteEvent")
    end)
end

-- ⭐ ฟัง ShowEndScreenEvent เพื่อ trigger Auto Replay
pcall(function()
    local ShowEndScreenEvent = ReplicatedStorage:FindFirstChild("Networking")
        and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
        and ReplicatedStorage.Networking.EndScreen:FindFirstChild("ShowEndScreenEvent")
    
    if ShowEndScreenEvent then
        ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
            print("[AutoReplay] 📺 EndScreen detected! Status:", Results and Results.Status or "Unknown")
            -- รอ 2 วินาทีแล้ว Vote Retry
            task.delay(2, function()
                AutoVoteReplay()
            end)
            -- Vote อีกครั้งหลัง 5 วินาที (กรณี vote แรกไม่ผ่าน)
            task.delay(5, function()
                AutoVoteReplay()
            end)
        end)
        print("[AutoReplay] ✅ ShowEndScreenEvent connected!")
    end
end)

-- ===== AUTO ANT SWARM SYSTEM =====
-- ตาม Decom: Auto close tunnel เมื่อเข้าใกล้ Swarm
_G.AntSwarm = {
    Data = {},
    TunnelClosedEvent = nil,
}

pcall(function()
    _G.AntSwarm.TunnelClosedEvent = game:GetService("ReplicatedStorage").Networking.StageMechanics.TunnelClosed
end)

task.spawn(function()
    while true do
        task.wait(0.1)  -- Heartbeat equivalent
        
        if not ENABLED or not _G.AntSwarm.TunnelClosedEvent then
            task.wait(1)
            continue
        end
        
        local character = plr.Character
        local primaryPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if primaryPart then
            local playerPos = primaryPart.Position
            
            -- หา Swarm Parts ใน Map
            pcall(function()
                local mapFolder = workspace:FindFirstChild("Map")
                if mapFolder then
                    for _, child in pairs(mapFolder:GetChildren()) do
                        if child.Name:find("Swarm") or child.Name:find("Tunnel") then
                            local areaHelper = child:FindFirstChild("AreaHelper")
                            if areaHelper and areaHelper.Enabled then
                                local dist = (child.Position - playerPos).Magnitude
                                if dist <= 7 then
                                    -- Close tunnel
                                    pcall(function()
                                        _G.AntSwarm.TunnelClosedEvent:FireServer(child.Name)
                                    end)
                                    areaHelper.Enabled = false
                                    print(string.format("[AntSwarm] 🐜 Closed tunnel: %s", child.Name))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ===== AUTO ROTUNDA CONTROL SYSTEM =====
-- สำหรับ Happy Factory ACT 2 - ป้องกัน Innocents ไม่ให้ตาย + Barrels โดน Boss
_G.Rotunda = {
    Enabled = true,
    State = {
        Rotation = 0,
        Phase = "Evacuation",
        InnocentLane = 1,
        EnemyLane = 2,
        BarrelLane = 1,
        CloneLane = 2,
        RotatorStates = { false, false }
    },
    LastRotate = { 0, 0 },
    RotateCooldown = 0.5,
    Event = nil,
    IsHappyFactory = false,
}

-- Initialize Rotunda Event
pcall(function()
    _G.Rotunda.Event = ReplicatedStorage:FindFirstChild("Networking")
        and ReplicatedStorage.Networking:FindFirstChild("StageMechanics")
        and ReplicatedStorage.Networking.StageMechanics:FindFirstChild("RotundaTrack")
end)

-- Listen for Rotunda state updates
pcall(function()
    if _G.Rotunda.Event then
        _G.Rotunda.Event.OnClientEvent:Connect(function(eventType, ...)
            local args = {...}
            if eventType == "StateSync" then
                local state = args[1]
                if state then
                    _G.Rotunda.State = state
                    _G.Rotunda.State.RotatorStates = state.RotatorStates or { false, false }
                    _G.Rotunda.IsHappyFactory = true
                    print("[Rotunda] 🎡 StateSync - Phase:", state.Phase, "Rotation:", state.Rotation)
                end
            elseif eventType == "WaveStart" then
                local waveData = args[1]
                if waveData then
                    _G.Rotunda.State.Phase = waveData.Phase
                    _G.Rotunda.State.InnocentLane = waveData.InnocentLane
                    _G.Rotunda.State.EnemyLane = waveData.EnemyLane
                    _G.Rotunda.State.BarrelLane = waveData.BarrelLane
                    _G.Rotunda.State.CloneLane = waveData.CloneLane
                    print("[Rotunda] 🎡 WaveStart - Phase:", waveData.Phase)
                end
            elseif eventType == "Rotated" then
                local rotatorNum = args[1]
                local state = args[2]
                if rotatorNum then
                    _G.Rotunda.State.RotatorStates[rotatorNum] = state
                end
            elseif eventType == "PhaseChanged" then
                _G.Rotunda.State.Phase = args[1]
                print("[Rotunda] 🎡 PhaseChanged:", args[1])
            end
        end)
        print("[Rotunda] ✅ Event connected!")
    end
end)

-- ฟังก์ชันหมุน Track
_G.RotateTrack = function(rotatorNum)
    local now = tick()
    if now - _G.Rotunda.LastRotate[rotatorNum] < _G.Rotunda.RotateCooldown then return false end
    
    pcall(function()
        if _G.Rotunda.Event then
            _G.Rotunda.Event:FireServer("Rotate", rotatorNum)
            _G.Rotunda.LastRotate[rotatorNum] = now
            print(string.format("[Rotunda] 🔄 Rotated track %d", rotatorNum))
        end
    end)
    return true
end

-- คำนวณ lane ปัจจุบันจาก rotation (lane 1-4)
_G.GetActualLane = function(baseLane, rotation)
    if not baseLane then return 0 end
    return ((baseLane - 1 + rotation) % 4) + 1
end

-- Auto Rotunda Loop
task.spawn(function()
    while true do
        task.wait(0.3)
        
        if not ENABLED or not _G.Rotunda.Enabled or not _G.Rotunda.IsHappyFactory then
            task.wait(1)
            continue
        end
        
        local state = _G.Rotunda.State
        local rotation = state.Rotation or 0
        
        -- ===== EVACUATION PHASE =====
        -- เป้าหมาย: Innocents (สีเขียว) ต้องไม่เข้า lane 4 (Gate)
        -- ศัตรู (สีแดง) ควรเข้า Gate เพื่อให้ Unit โจมตี
        if state.Phase == "Evacuation" then
            local innocentActualLane = _G.GetActualLane(state.InnocentLane, rotation)
            local enemyActualLane = _G.GetActualLane(state.EnemyLane, rotation)
            
            -- ถ้า Innocents กำลังจะเข้า lane 4 (Gate) ต้องหมุนออก
            if innocentActualLane == 4 then
                -- หมุนให้ Innocent ออกจาก lane 4
                if not state.RotatorStates[1] then
                    _G.RotateTrack(1)
                elseif not state.RotatorStates[2] then
                    _G.RotateTrack(2)
                end
            end
            
            -- ถ้า Enemy ไม่ได้อยู่ lane 4 และ Innocent ปลอดภัย ให้หมุน Enemy ไป lane 4
            if innocentActualLane ~= 4 and enemyActualLane ~= 4 then
                -- หมุนให้ Enemy ไป lane 4
                if state.RotatorStates[1] then
                    _G.RotateTrack(1)
                elseif state.RotatorStates[2] then
                    _G.RotateTrack(2)
                end
            end
            
        -- ===== BOMB PHASE =====
        -- เป้าหมาย: Barrels ต้องไป lane 4 (โดน Boss)
        -- Innocents ยังต้องป้องกันไม่ให้ตาย
        elseif state.Phase == "BombPhase" then
            local barrelActualLane = _G.GetActualLane(state.BarrelLane, rotation)
            local innocentActualLane = state.InnocentLane and _G.GetActualLane(state.InnocentLane, rotation) or 0
            
            -- Priority 1: Innocents ห้ามอยู่ lane 4
            if innocentActualLane == 4 then
                if not state.RotatorStates[1] then
                    _G.RotateTrack(1)
                elseif not state.RotatorStates[2] then
                    _G.RotateTrack(2)
                end
            -- Priority 2: Barrel ต้องไป lane 4
            elseif barrelActualLane ~= 4 then
                -- หมุนให้ Barrel ไป lane 4
                local neededRotation = (4 - state.BarrelLane) % 4
                local currentRotation = rotation % 4
                
                if neededRotation ~= currentRotation then
                    if not state.RotatorStates[1] then
                        _G.RotateTrack(1)
                    elseif not state.RotatorStates[2] then
                        _G.RotateTrack(2)
                    end
                end
            end
            
        -- ===== BOSS PHASE =====
        -- เป้าหมาย: Clone (สีชมพู) ต้องไป lane ที่มี Unit โจมตี
        elseif state.Phase == "BossPhase" then
            local cloneActualLane = _G.GetActualLane(state.CloneLane, rotation)
            
            -- Clone ควรไป lane 4 เพื่อให้ Unit โจมตี
            if cloneActualLane ~= 4 then
                if not state.RotatorStates[1] then
                    _G.RotateTrack(1)
                elseif not state.RotatorStates[2] then
                    _G.RotateTrack(2)
                end
            end
        end
    end
end)

-- ===== RETURN MODULE =====
return {
    -- Configuration
    UnitType = UnitType,
    
    -- Functions
    GetYen = GetYen,
    GetWaveFromUI = GetWaveFromUI,
    GetGamePhase = GetGamePhase,
    GetMapPath = GetMapPath,
    GetHotbarUnits = GetHotbarUnits,
    GetActiveUnits = GetActiveUnits,
    GetPlaceablePositions = GetPlaceablePositions,
    GetBestPlacementPosition = GetBestPlacementPosition,
    GetUnitRange = GetUnitRange,
    CalculateUShapeCenters = CalculateUShapeCenters,
    CalculateCircularCenters = CalculateCircularCenters,
    
    -- Unit Classification
    IsIncomeUnit = IsIncomeUnit,
    IsBuffUnit = IsBuffUnit,
    HasEconomyUnitInHotbar = HasEconomyUnitInHotbar,
    AllEconomyUnitsMaxed = AllEconomyUnitsMaxed,
    
    -- Enemy System
    GetEnemies = GetEnemies,
    GetEnemyProgress = GetEnemyProgress,
    CheckEmergency = CheckEmergency,
    
    -- Actions
    PlaceUnit = PlaceUnit,
    UpgradeUnit = UpgradeUnit,
    SellUnit = SellUnit,
    GetNextEconomySlot = GetNextEconomySlot,
    GetNextDamageSlot = GetNextDamageSlot,
    
    -- Upgrade System
    GetUpgradeCost = GetUpgradeCost,
    GetMaxUpgradeLevel = GetMaxUpgradeLevel,
    GetStrongestUnit = GetStrongestUnit,
    
    -- Auto Start & Vote Skip & Replay
    AutoVoteSkip = AutoVoteSkip,
    TryStartGame = TryStartGame,
    InitAutoStart = InitAutoStart,
    AutoVoteReplay = AutoVoteReplay,
    SetAutoReplay = function(val) AUTO_REPLAY_ENABLED = val end,
    
    -- State
    PlacedPositions = PlacedPositions,
    UsedUCenters = UsedUCenters,
    CachedUCenters = CachedUCenters,
    CurrentWave = CurrentWave,
    MaxWave = MaxWave,
    IsEmergency = function() return IsEmergency end,
    EmergencyUnits = EmergencyUnits,
    
    -- Control
    Enable = function() ENABLED = true end,
    Disable = function() ENABLED = false end,
    SetDebug = function(val) DEBUG = val end,
    
    -- Reset
    ResetCache = function()
        CachedUCenters = {}
        UsedUCenters = {}
        PlacedPositions = {}
    end,
    
    ResetEmergency = function()
        IsEmergency = false
        EmergencyUnits = {}
        EmergencyStartTime = 0
        EmergencyActivated = false
        LastEmergencyTime = 0
    end,
}
