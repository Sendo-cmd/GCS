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
-- ABILITY SYSTEM LOADER
-- ══════════════════════════════════════════════════════════════════════════════
-- ⭐ แก้ URL นี้ให้เป็น GitHub Raw URL ของคุณ
local ABILITY_SYSTEM_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/AbilitySystem.lua"

-- โหลด AbilitySystem (สั้นๆ ง่ายๆ)
task.spawn(function()
    task.wait(1)
    if _G.AbilitySystem then return end -- มีอยู่แล้ว
    
    print("[AutoPlay] 📦 Loading AbilitySystem...")
    
    -- ลอง GitHub
    pcall(function()
        local code = game:HttpGet(ABILITY_SYSTEM_URL)
        if code then loadstring(code)() end
    end)
    
    -- ลอง Local File (ถ้า GitHub ไม่ได้)
    if not _G.AbilitySystem then
        pcall(function() loadfile("AbilitySystem.lua")() end)
    end
    
    print("[AutoPlay] " .. (_G.AbilitySystem and "✅ Ready!" or "⚠️ Failed - Abilities disabled"))
end)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ===== MODULES =====
local Modules = ReplicatedStorage:WaitForChild("Modules")
local StagesData = require(Modules.Data.StagesData)

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
local IsBuffUnit, GetMapPath, GetTotalPathDistance

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
    
    -- ⭐⭐⭐ FIX: เช็คว่าเกมเริ่มแล้วหรือยัง (inline เพื่อไม่ต้องเรียก GetWaveFromUI)
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
    
    if not CurrentWave or CurrentWave == 0 then
        EmergencyMode.Active = false
        return false
    end
    
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
        -- ⭐⭐⭐ Reset upgrade count เมื่อเริ่ม Emergency ใหม่
        EmergencyUpgradeCount = {}
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
local GetWaveFromUI, GetGamePhase  -- ⭐ เพิ่ม forward declaration

-- Emergency Upgrade State
local LastEmergencyUpgradeTime = 0
local EMERGENCY_UPGRADE_COOLDOWN = 2

-- ⭐⭐⭐ Track Emergency Upgrade Count (ห้ามอัพเกิน 2 ขั้นถ้าไม่ขาย)
local EmergencyUpgradeCount = {}  -- EmergencyUpgradeCount[GUID] = จำนวนขั้นที่อัพใน Emergency
local MAX_EMERGENCY_UPGRADES = 2  -- อัพได้สูงสุด 2 ขั้นต่อ unit ใน Emergency

local function UpgradeUnitsEmergency()
    -- ใช้ทั้ง 2 ระบบ Emergency: EmergencyMode.Active หรือ IsEmergency
    if not EmergencyMode.Active and not IsEmergency then return false end
    
    -- ⭐⭐⭐ FROZEN PORT: ใช้ระบบ upgrade เฉพาะ (ไม่ใช้ function นี้)
    if _G.APState and _G.APState.IsFrozenPort then
        return false  -- ข้าม - Frozen Port มี logic อัพเกรดเฉพาะอยู่แล้ว
    end
    
    local now = tick()
    -- ⭐⭐⭐ ลด cooldown เป็น 0.3 วินาที เพื่อให้อัพได้เร็วขึ้นใน Emergency
    if now - LastEmergencyUpgradeTime < 0.3 then
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
                
                -- ⭐⭐⭐ เช็คว่าอัพใน Emergency ไปกี่ขั้นแล้ว
                local emergencyUpgrades = EmergencyUpgradeCount[guid] or 0
                local canUpgradeMore = emergencyUpgrades < MAX_EMERGENCY_UPGRADES
                
                if currentLevel < maxLevel and cost < math.huge and canUpgradeMore then
                    table.insert(damageUnits, {
                        Unit = unit,
                        GUID = guid,
                        Name = unit.Name,
                        Level = currentLevel,
                        MaxLevel = maxLevel,
                        Cost = cost,
                        EmergencyUpgrades = emergencyUpgrades
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
    
    -- ⭐⭐⭐ Emergency: อัพหลายตัวต่อรอบ (ถ้ามีเงินพอ) แต่ไม่เกิน 2 ขั้นต่อ unit
    local yen = GetYen and GetYen() or 0
    local upgradedCount = 0
    local MAX_UPGRADES_PER_TICK = 3  -- อัพได้สูงสุด 3 ตัวต่อรอบ
    
    for _, unitData in ipairs(damageUnits) do
        if upgradedCount >= MAX_UPGRADES_PER_TICK then break end
        
        -- ⭐⭐⭐ เช็คว่ายังอัพได้อีกไหม (ไม่เกิน 2 ขั้น)
        local emergencyUpgrades = EmergencyUpgradeCount[unitData.GUID] or 0
        if emergencyUpgrades >= MAX_EMERGENCY_UPGRADES then
            -- ข้าม unit นี้ - อัพครบ 2 ขั้นแล้ว
            continue
        end
        
        if yen >= unitData.Cost then
            local success = UpgradeUnit and UpgradeUnit(unitData.Unit)
            if success then
                yen = yen - unitData.Cost  -- ลดเงินที่ใช้ไป
                upgradedCount = upgradedCount + 1
                
                -- ⭐⭐⭐ Track การอัพใน Emergency
                EmergencyUpgradeCount[unitData.GUID] = (EmergencyUpgradeCount[unitData.GUID] or 0) + 1
                
                print(string.format("[Emergency] ⬆️ %s (%d→%d) [EmergencyUpgrade: %d/%d]", 
                    unitData.Name, unitData.Level, unitData.Level + 1,
                    EmergencyUpgradeCount[unitData.GUID], MAX_EMERGENCY_UPGRADES))
            end
        end
    end
    
    if upgradedCount > 0 then
        LastEmergencyUpgradeTime = now
        return true
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

-- ===== 🔴 FROZEN PORT PLACEMENT SYSTEM (ไม่ hardcode) =====
local FrozenPortUsedPositions = {}
local FrozenPortAutoPlaceUsedPositions = {}

-- ===== ⛔ FROZEN PORT EXCLUDED ZONES (ห้ามวางเด็ดขาด!) =====
-- พิกัดจากภาพ: เส้นสีดำคือบริเวณที่ห้ามวาง
-- รูปแบบ: {Center = Vector3, Radius = number} หรือ {Min = Vector3, Max = Vector3}
local FrozenPortExcludedZones = {
    -- ⛔ Zone 1: มุมบนซ้าย (ใกล้ตึกสีฟ้า)
    {Center = Vector3.new(-120, 0, -80), Radius = 25},
    
    -- ⛔ Zone 2: พื้นที่ด้านซ้ายบน (เส้นทแยงมุม)
    {Center = Vector3.new(-90, 0, -50), Radius = 20},
    {Center = Vector3.new(-60, 0, -30), Radius = 18},
    
    -- ⛔ Zone 3: พื้นที่กลาง-ซ้าย (ใกล้เรือ)
    {Center = Vector3.new(-70, 0, 20), Radius = 22},
    {Center = Vector3.new(-100, 0, 50), Radius = 20},
    
    -- ⛔ Zone 4: มุมล่างซ้าย (ใกล้เรือดำ)
    {Center = Vector3.new(-110, 0, 90), Radius = 25},
    {Center = Vector3.new(-80, 0, 110), Radius = 20},
    
    -- ⛔ Zone 5: พื้นที่กลาง-ล่าง
    {Center = Vector3.new(-30, 0, 80), Radius = 18},
    {Center = Vector3.new(0, 0, 100), Radius = 20},
    
    -- ⛔ Zone 6: พื้นที่กลาง (ใกล้ path หลัก)
    {Center = Vector3.new(-20, 0, 30), Radius = 15},
    {Center = Vector3.new(10, 0, 50), Radius = 15},
    
    -- ⛔ Zone 7: พื้นที่ด้านขวา-บน
    {Center = Vector3.new(80, 0, -60), Radius = 22},
    {Center = Vector3.new(110, 0, -30), Radius = 20},
    
    -- ⛔ Zone 8: พื้นที่ขวา-กลาง (ใกล้เรือส้ม)
    {Center = Vector3.new(100, 0, 20), Radius = 25},
    {Center = Vector3.new(120, 0, 60), Radius = 22},
    
    -- ⛔ Zone 9: มุมขวาล่าง
    {Center = Vector3.new(130, 0, 100), Radius = 25},
    {Center = Vector3.new(100, 0, 120), Radius = 20},
    
    -- ⛔ Zone 10: เส้นทแยงขวาบน-ล่าง
    {Center = Vector3.new(60, 0, -40), Radius = 18},
    {Center = Vector3.new(40, 0, -20), Radius = 15},
    
    -- ⛔ Zone 11: พื้นที่รอบ Base (มุมขวาสุด)
    {Center = Vector3.new(140, 0, 80), Radius = 20},
}

-- ⛔ ฟังก์ชันเช็คว่าตำแหน่งอยู่ใน Excluded Zone หรือไม่
local function IsInFrozenPortExcludedZone(pos)
    if not _G.APState or not _G.APState.IsFrozenPort then
        return false  -- ไม่ใช่ Frozen Port → ไม่เช็ค
    end
    
    for _, zone in ipairs(FrozenPortExcludedZones) do
        if zone.Center and zone.Radius then
            -- วงกลม
            local dist2D = math.sqrt((pos.X - zone.Center.X)^2 + (pos.Z - zone.Center.Z)^2)
            if dist2D <= zone.Radius then
                return true
            end
        elseif zone.Min and zone.Max then
            -- สี่เหลี่ยม
            if pos.X >= zone.Min.X and pos.X <= zone.Max.X and
               pos.Z >= zone.Min.Z and pos.Z <= zone.Max.Z then
                return true
            end
        end
    end
    
    return false
end

-- ฟังก์ชันเช็คว่าตำแหน่งอยู่บนเส้นทางศัตรูหรือไม่ (ห้ามวาง)
-- ⛔ รวมการเช็ค Excluded Zone ด้วย!
local function IsOnEnemyPath(pos, path, minDistance)
    -- ⛔ เช็ค Excluded Zone ก่อน!
    if IsInFrozenPortExcludedZone(pos) then
        return true  -- ห้ามวาง!
    end
    
    minDistance = minDistance or 8  -- ห่างจากเส้นทางอย่างน้อย 8 studs
    
    for i = 1, #path - 1 do
        local p1 = path[i]
        local p2 = path[i + 1]
        
        -- คำนวณระยะจากจุดไปยังเส้นตรง
        local lineVec = p2 - p1
        local lineLen = lineVec.Magnitude
        if lineLen > 0 then
            local lineDir = lineVec / lineLen
            local toPos = pos - p1
            local projection = toPos:Dot(lineDir)
            projection = math.max(0, math.min(lineLen, projection))
            local closestPoint = p1 + lineDir * projection
            local dist = (pos - closestPoint).Magnitude
            
            if dist < minDistance then
                return true
            end
        end
    end
    
    return false
end

-- หา U-Turn corners จาก path (มุม >= 60 องศา)
local function FindUTurnCorners(path, minAngle)
    minAngle = minAngle or 60
    local corners = {}
    
    for i = 2, #path - 1 do
        local prev = path[i - 1]
        local curr = path[i]
        local next = path[i + 1]
        
        local dir1 = (curr - prev).Unit
        local dir2 = (next - curr).Unit
        
        local dot = dir1:Dot(dir2)
        dot = math.max(-1, math.min(1, dot))
        local angle = math.deg(math.acos(dot))
        
        if angle >= minAngle then
            -- หาทิศทางออกจากโค้ง (perpendicular)
            local avgDir = (dir1 + dir2).Unit
            local outwardDir = Vector3.new(-avgDir.Z, 0, avgDir.X)  -- perpendicular
            
            table.insert(corners, {
                Position = curr,
                Index = i,
                Angle = angle,
                OutwardDir = outwardDir,
                InwardDir = -outwardDir
            })
        end
    end
    
    return corners
end

-- คำนวณ coverage score (กี่จุดของ path อยู่ใน range)
local function CalculateCoverageScore(pos, path, unitRange)
    local score = 0
    local coveredSegments = 0
    
    for i = 1, #path - 1 do
        local p1 = path[i]
        local p2 = path[i + 1]
        local midPoint = (p1 + p2) / 2
        
        local dist = (pos - midPoint).Magnitude
        if dist <= unitRange then
            -- ยิ่งใกล้ยิ่งได้คะแนนมาก
            score = score + (unitRange - dist) / unitRange
            coveredSegments = coveredSegments + 1
        end
    end
    
    return score, coveredSegments
end

-- หาตำแหน่ง Emergency ที่ดีที่สุด (สีส้ม - U-turn centers)
local function GetFrozenPortEmergencyPosition(unitRange)
    local path = GetMapPath()
    if not path or #path < 5 then return nil end
    
    local corners = FindUTurnCorners(path, 50)
    if #corners == 0 then return nil end
    
    local candidates = {}
    
    for _, corner in ipairs(corners) do
        -- ลองหลายตำแหน่งรอบ corner
        for dist = 10, unitRange * 0.8, 5 do
            for _, dir in ipairs({corner.OutwardDir, corner.InwardDir}) do
                local testPos = corner.Position + dir * dist
                
                -- เช็คว่าไม่อยู่บนเส้นทาง
                if not IsOnEnemyPath(testPos, path, 10) then
                    local score, covered = CalculateCoverageScore(testPos, path, unitRange)
                    
                    -- เช็คว่ายังไม่ได้ใช้
                    local isUsed = false
                    for _, usedPos in ipairs(FrozenPortUsedPositions) do
                        if (testPos - usedPos).Magnitude < 15 then
                            isUsed = true
                            break
                        end
                    end
                    
                    if not isUsed and covered >= 2 then
                        table.insert(candidates, {
                            pos = testPos,
                            score = score,
                            covered = covered,
                            cornerAngle = corner.Angle
                        })
                    end
                end
            end
        end
    end
    
    -- เรียงตาม score สูงสุด
    table.sort(candidates, function(a, b) return a.score > b.score end)
    
    if #candidates > 0 then
        local best = candidates[1]
        table.insert(FrozenPortUsedPositions, best.pos)
        return best.pos
    end
    
    return nil
end

-- หาตำแหน่ง Auto Place ที่ดีที่สุด (สีแดง - high coverage areas)
local function GetFrozenPortAutoPlacePosition(unitRange, phase)
    local path = GetMapPath()
    if not path or #path < 5 then return nil end
    
    -- กำหนดส่วนของ path ตาม phase
    local startIdx, endIdx
    if phase == "early" then
        startIdx = 1
        endIdx = math.floor(#path * 0.4)
    elseif phase == "mid" then
        startIdx = math.floor(#path * 0.3)
        endIdx = math.floor(#path * 0.7)
    else -- late
        startIdx = math.floor(#path * 0.5)
        endIdx = #path
    end
    
    local candidates = {}
    
    -- สร้าง grid รอบ path segment
    for i = startIdx, endIdx - 1 do
        local p1 = path[i]
        local p2 = path[i + 1]
        local midPoint = (p1 + p2) / 2
        local segmentDir = (p2 - p1).Unit
        local perpDir = Vector3.new(-segmentDir.Z, 0, segmentDir.X)
        
        -- ลองหลายตำแหน่ง perpendicular กับ path
        for dist = 12, unitRange * 0.7, 6 do
            for _, sign in ipairs({1, -1}) do
                local testPos = midPoint + perpDir * dist * sign
                
                if not IsOnEnemyPath(testPos, path, 10) then
                    local score, covered = CalculateCoverageScore(testPos, path, unitRange)
                    
                    -- เช็คว่ายังไม่ได้ใช้
                    local isUsed = false
                    for _, usedPos in ipairs(FrozenPortAutoPlaceUsedPositions) do
                        if (testPos - usedPos).Magnitude < 12 then
                            isUsed = true
                            break
                        end
                    end
                    
                    if not isUsed and covered >= 1 then
                        table.insert(candidates, {
                            pos = testPos,
                            score = score,
                            covered = covered,
                            pathIndex = i
                        })
                    end
                end
            end
        end
    end
    
    -- เรียงตาม score สูงสุด
    table.sort(candidates, function(a, b) return a.score > b.score end)
    
    if #candidates > 0 then
        local best = candidates[1]
        table.insert(FrozenPortAutoPlaceUsedPositions, best.pos)
        return best.pos
    end
    
    return nil
end

-- รีเซ็ต Frozen Port positions
local function ResetFrozenPortPositions()
    FrozenPortUsedPositions = {}
    FrozenPortAutoPlaceUsedPositions = {}
end

-- Wrapper สำหรับ Emergency Mode (backward compatible)
local function GetFrozenPortUCenterPosition(unitRange)
    return GetFrozenPortEmergencyPosition(unitRange)
end

-- ===== หาตำแหน่งวางดักหน้าศัตรู (INTERCEPT) =====
-- ⭐⭐⭐ FIX: วางดักหน้าศัตรู (ตามทิศทางที่เดิน) ไม่ใช่วางรอบๆ
-- 🔥 Frozen Port: วางที่ U-Center เท่านั้น (จุดสีแดง) → แยกไปเช็คใน AutoPlaceLoop แล้ว
local function GetEmergencyPlacementPosition(unitRange, unitName, unitData)
    -- ⭐ ฟังก์ชันนี้ใช้สำหรับด่านอื่นๆ (ไม่ใช่ Frozen Port)
    -- Frozen Port จะใช้ GetBestPlacementPosition โดยตรง
    
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
_G.APState.LastStageKey = ""
_G.APState.LastEmergencyState = false
_G.APState.IsFrozenPort = false
-- ⭐ ใช้ _G.APState โดยตรง (ไม่ใช้ local copy)

local function CheckEmergency()
    local progress = GetEnemyProgress()
    local now = tick()
    
    local wasEmergency = IsEmergency
    
    -- ⭐⭐⭐ FIX: ใช้ workspace:GetAttribute("AliveEnemies") แทนการอ่าน UI
    local workspaceEnemies = workspace:GetAttribute("AliveEnemies") or 0
    local waveReadSuccess = false
    local waveReadError = nil
    
    -- อ่าน Wave จาก UI (สำหรับ log เท่านั้น)
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if not HUD then
            return
        end
        
        local Map = HUD:FindFirstChild("Map")
        if not Map then
            return
        end
        
        local WavesAmount = Map:FindFirstChild("WavesAmount")
        if not WavesAmount or not WavesAmount:IsA("TextLabel") then
            return
        end
        
        local text = WavesAmount.Text or ""
        local cleanText = text:gsub("<[^>]+>", "")
        
        -- ⭐⭐⭐ FIX: รองรับทั้ง "1/10" และ "1/∞" (Infinity mode)
        -- Pattern 1: ตัวเลข/ตัวเลข (เช่น 5/10)
        local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
        
        if cur and total then
            CurrentWave = tonumber(cur) or 0
            MaxWave = tonumber(total) or 0
            waveReadSuccess = true
        else
            -- Pattern 2: ตัวเลข/∞ หรือ ตัวเลข/infinity (Infinity mode)
            cur = cleanText:match("(%d+)%s*/%s*[∞∾]")  -- ∞ หรือ ∾
            if not cur then
                cur = cleanText:match("(%d+)%s*/%s*inf")  -- infinity
            end
            if not cur then
                -- Pattern 3: แค่ตัวเลขตัวแรก
                cur = cleanText:match("(%d+)")
            end
            
            if cur then
                CurrentWave = tonumber(cur) or 0
                MaxWave = 999  -- Infinity mode = ไม่มี max
                waveReadSuccess = true
            end
        end
    end)
    
    -- ⭐⭐⭐ เช็คว่าเกมเริ่มแล้ว = มี AliveEnemies > 0 จาก workspace attribute
    local gameStarted = workspaceEnemies > 0
    
    -- ⭐⭐⭐ FIX: เช็คว่ามี enemy จริงๆ ก่อน (ใช้ workspace attribute)
    local filteredEnemies = GetEnemies()
    local hasRealEnemies = workspaceEnemies > 0  -- ใช้ attribute จาก workspace
    
    -- ⭐⭐⭐ เช็คว่าเป็น Frozen Port หรือไม่
    local isFrozenPort = false
    -- ⭐⭐⭐ NEW: เช็คว่าเป็น Imprisoned Island Act3 Rift หรือไม่
    local isImprisonedIslandRift = false
    local stageName = "Unknown"
    local stageType = "Unknown"
    local stage = "Unknown"
    local act = "Unknown"
    
    pcall(function()
        if not GameHandler or not GameHandler.GameData then return end
        
        local GameData = GameHandler.GameData
        
        -- ดึงข้อมูลจาก GameData โดยตรง
        stageType = GameData.StageType or "Unknown"
        
        -- ⭐ ใช้ StagesData เพื่อดึง Stage และ Act ที่ถูกต้อง (รองรับ WorldDestroyer)
        if StagesData then
            local currentStage = StagesData:GetCurrentStage(GameData)
            local currentAct = StagesData:GetCurrentAct(GameData)
            
            -- GetCurrentStage อาจคืน table หรือ string
            if type(currentStage) == "table" then
                stage = currentStage.Stage or currentStage.Name or GameData.Stage or "Unknown"
            elseif type(currentStage) == "string" then
                stage = currentStage
            else
                stage = GameData.Stage or "Unknown"
            end
            
            -- GetCurrentAct อาจคืน table หรือ string
            if type(currentAct) == "table" then
                act = currentAct.Act or currentAct.Name or GameData.Act or "Unknown"
            elseif type(currentAct) == "string" then
                act = currentAct
            else
                act = GameData.Act or "Unknown"
            end
        else
            stage = GameData.Stage or "Unknown"
            act = GameData.Act or "Unknown"
        end
        
        -- ⭐ เช็ค Frozen Port ตามเงื่อนไข:
        
        -- 1. WorldDestroyer Mode: ทุกครั้ง (ใช้ Frozen Port map = Story Stage11 Infinite)
        if stageType == "WorldDestroyer" then
            isFrozenPort = true
            stageName = "Frozen Port (WorldDestroyer)"
        end
        
        -- 2. Story Mode: Stage11 Act6 หรือ Infinite (Frozen Port)
        if stageType == "Story" and stage == "Stage11" and (act == "Infinite") then
            isFrozenPort = true
            stageName = "Frozen Port (Story)"
        end
        
        -- 3. LTM Mode: Fall Infinite (ใช้ Frozen Port map)
        if stageType == "LTM" and stage == "Fall" and act == "Infinite" then
            isFrozenPort = true
            stageName = "Frozen Port (LTM Fall)"
        end
        
        -- ⭐⭐⭐ NEW: 4. Imprisoned Island Rift/Legend Mode
        -- Stage3 = Imprisoned Island, Act3 = Act3, Rift mode
        local stageStr = tostring(stage):lower()
        local actStr = tostring(act):lower()
        
        -- 🔍 DEBUG: แสดงค่าที่ได้รับ
        -- print(string.format("[StageDetect] 🔍 stageType=%s | stage=%s | stageStr=%s | act=%s | actStr=%s", 
        --     tostring(stageType), tostring(stage), stageStr, tostring(act), actStr))
        
        -- Rift Mode
        if stageType == "Rift" and (stageStr:find("stage11") or stageStr:find("imprisoned")) and (actStr:find("3") or actStr:find("act3")) then
            isImprisonedIslandRift = true
            stageName = "Imprisoned Island Act3 (Rift)"
            -- print("[StageDetect] ✅ Matched: Rift Mode Act3")
        end
        
        -- Alternative check: Stage3 หรือ Imprisoned Island โดยตรง (Rift)
        if stageType == "Rift" and (stageStr:find("imprisoned") or stageStr == "stage11") then
            isImprisonedIslandRift = true
            stageName = "Imprisoned Island (Rift)"
            -- print("[StageDetect] ✅ Matched: Rift Mode")
        end

        -- ⭐⭐⭐ Legend Stage Mode (รองรับทุก act)
        if stageType == "LegendStage" and (stageStr:find("imprisoned") or stageStr:find("stage11") or stageStr == "11") then
            isImprisonedIslandRift = true
            stageName = "Imprisoned Island (Legend Stage)"
            -- print("[StageDetect] ✅ Matched: Legend Stage - Imprisoned Island!")
        end
        
        -- ⭐ เช็คจากชื่อ stage โดยตรง (fallback)
        if not isImprisonedIslandRift then
            local checkStage = tostring(stage):lower()
            local checkType = tostring(stageType):lower()
            if checkStage:find("imprisoned") or checkStage:find("island") then
                if checkType:find("legend") or checkType:find("rift") then
                    isImprisonedIslandRift = true
                    stageName = "Imprisoned Island (Auto-Detect)"
                    print("[StageDetect] ✅ Matched: Auto-Detect Imprisoned Island!")
                end
            end
        end
    end)
    
    -- DEBUG: แสดงข้อมูลด่านเฉพาะเมื่อเปลี่ยนแปลง (ไม่ spam)
    local stageKey = string.format("%s_%s_%s_%s_%s", tostring(stageType), tostring(stage), tostring(act), tostring(isFrozenPort), tostring(isImprisonedIslandRift))
    if _G.APState.LastStageKey ~= stageKey then
        _G.APState.LastStageKey = stageKey
        DebugPrint("====== STAGE INFO ======")
        DebugPrint(string.format("MODE: %s | STAGE: %s | ACT: %s", tostring(stageType), tostring(stage), tostring(act)))
        DebugPrint(string.format("MAP: %s | FROZEN PORT: %s | IMPRISONED RIFT: %s", tostring(stageName), tostring(isFrozenPort), tostring(isImprisonedIslandRift)))
        if isFrozenPort then
            if stageType == "WorldDestroyer" then
                DebugPrint(">>> WorldDestroyer Mode - Emergency ENABLED!")
            elseif stageType == "Story" then
                DebugPrint(">>> Story Stage11 Frozen Port - Emergency ENABLED!")
            elseif stageType == "LTM" then
                DebugPrint(">>> LTM Fall Frozen Port - Emergency ENABLED!")
            end
        elseif isImprisonedIslandRift then
            DebugPrint(">>> Imprisoned Island Act3 Rift - Lich King only on WHITE ZONE!")
        else
            DebugPrint(">>> Normal Mode - Emergency ENABLED for all maps!")
        end
        DebugPrint("========================")
    end
    
    -- ⭐ เซ็ต global state สำหรับ Auto Place ใช้
    _G.APState.IsFrozenPort = isFrozenPort
    _G.APState.IsImprisonedIslandRift = isImprisonedIslandRift
    
    -- ⭐⭐⭐ FIX: Emergency Mode ทำงานทุก mode (ไม่ใช่เฉพาะ Frozen Port)
    if gameStarted and hasRealEnemies then
        -- ⭐ Emergency threshold แตกต่างตาม map type:
        -- - Imprisoned Island Rift: progress >= 45% (เริ่มเร็วกว่า)
        -- - อื่นๆ: progress >= 60%
        local emergencyThreshold = 60
        if isImprisonedIslandRift then
            emergencyThreshold = 45
        end
        
        IsEmergency = progress >= emergencyThreshold
        
        -- Debug log เมื่อเปลี่ยนสถานะ (เฉพาะครั้งแรก)
        if IsEmergency and not wasEmergency then
            local mapType = isFrozenPort and "Frozen Port" or (isImprisonedIslandRift and "Imprisoned Rift" or "Normal")
            DebugPrint(string.format("🔥 [EMERGENCY] ACTIVATED! (%s | Enemies: %d | Progress: %.1f%% >= %d%%)", mapType, workspaceEnemies, progress, emergencyThreshold))
        end
    else
        IsEmergency = false  -- เกมยังไม่เริ่ม หรือไม่มี enemy = ไม่ emergency
    end
    
    -- Log เฉพาะเมื่อ Emergency state เปลี่ยน
    if IsEmergency and not wasEmergency then
        EmergencyStartTime = tick()
        local emergencyThreshold = isImprisonedIslandRift and 45 or 60
        DebugPrint(string.format("[EMERGENCY] ACTIVATED! Progress: %.1f%% >= %d%%", progress, emergencyThreshold))
    end
    
    if not IsEmergency and wasEmergency then
        DebugPrint(string.format("[EMERGENCY] DEACTIVATED! Progress: %.1f%%", progress))
    end
    
    -- ⭐⭐⭐ IMPRISONED ISLAND RIFT: ขาย Lich King (Ruler) เมื่อ progress < 15% เพื่อย้ายตำแหน่ง
    -- ⚠️ FIX: progress < 15 (ไม่ใช่ < 20) เพราะ progress เป็น 0-100
    if isImprisonedIslandRift and progress < 15 then
        local activeUnits = GetActiveUnits()
        if activeUnits then
            for _, unit in pairs(activeUnits) do
                local unitNameLower = (unit.Name or ""):lower()
                local isLichKingRuler = unitNameLower:find("lich") and unitNameLower:find("ruler")
                local isSummonUnit = IsPassiveSummonUnit and IsPassiveSummonUnit(unit.Name, unit.Data or {})
                
                -- ⭐ ขายเฉพาะ Lich King (Ruler) ที่ไม่ใช่ Summon unit
                if isLichKingRuler and not isSummonUnit then
                    print(string.format("[ImprisonedRift] 🔄 Progress < 15%% → ขาย %s เพื่อย้ายตำแหน่ง", unit.Name))
                    SellUnit(unit)
                    -- ลบออกจาก tracking tables ถ้ามี
                    if unit.GUID then
                        EmergencyUnits[unit.GUID] = nil
                        ClearEnemyUnits[unit.GUID] = nil
                    end
                end
            end
        end
    end
    
    -- ขาย Emergency Units เมื่อ progress < 30% หรือไม่มี enemy
    if next(EmergencyUnits) then
        local shouldSell = (not hasRealEnemies) or (progress < 30)
        
        if shouldSell then
            local soldCount = 0
            
            local guidsToSell = {}
            for guid, _ in pairs(EmergencyUnits) do
                table.insert(guidsToSell, guid)
            end
            
            for _, guid in ipairs(guidsToSell) do
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    local emergencyUnit = ClientUnitHandler._ActiveUnits[guid]
                    if emergencyUnit then
                        local unitWrapper = {
                            GUID = guid,
                            Name = emergencyUnit.Name,
                            CanSell = true
                        }
                        if SellUnit(unitWrapper) then
                            soldCount = soldCount + 1
                            EmergencyUnits[guid] = nil
                        end
                    else
                        EmergencyUnits[guid] = nil
                    end
                end
            end
            
            if soldCount > 0 then
                local sellReason = not hasRealEnemies and "No Enemy" or string.format("Progress %.1f%%", progress)
                DebugPrint(string.format("[EMERGENCY] Sold %d units (%s)", soldCount, sellReason))
                ResetFrozenPortPositions()
                EmergencyActivated = false
            end
        end
        -- ถ้า progress >= 30% และมี enemy → ไม่ขาย (รอจนกว่าจะปลอดภัย)
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
    
    -- 🎯 Reset Ability System (ถ้ามี AbilitySystem.lua โหลดอยู่)
    if _G.AbilitySystem and _G.AbilitySystem.ResetState then
        pcall(function() _G.AbilitySystem.ResetState() end)
    end
    
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
        _G.NumberPad.InputSequence = {}
        _G.NumberPad.CodeAccepted = false
        _G.NumberPad.LastCheck = 0
        _G.NumberPad.LastBossKey = ""
    end
    
    DebugPrint("✅ ResetGameState() complete - All data cleared")
end

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

-- ⭐ Initialize _G.APClear if not exists
if not _G.APClear then
    _G.APClear = {
        ClearEnemyUnits = {},
        ClearEnemySoldForEnemy = {},
        ClearEnemySlotFullLogged = {},
        ClearEnemyFoundDamageLogged = {},
        ClearEnemyPlacedCount = {},
        StaticEnemySpawnWave = {},
        StaticEnemySpawnPos = {},
        MohatoHealthData = {},
        LastStaticEnemyCount = 0,
        LastStaticEnemyCheck = 0
    }
end

-- Local references for performance
local ClearEnemySoldForEnemy = _G.APClear.ClearEnemySoldForEnemy
local ClearEnemyNoMoreSellable = false
local ClearEnemySlotFullLogged = _G.APClear.ClearEnemySlotFullLogged
local ClearEnemyFoundDamageLogged = _G.APClear.ClearEnemyFoundDamageLogged
local ClearEnemyPlacedCount = _G.APClear.ClearEnemyPlacedCount
local StaticEnemySpawnWave = _G.APClear.StaticEnemySpawnWave
local StaticEnemySpawnPos = _G.APClear.StaticEnemySpawnPos
local MohatoHealthData = _G.APClear.MohatoHealthData
local StaticEnemyLastState = {}

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
                        
                        -- ⭐⭐⭐ NEW: ใช้ Unit Range จริง เพื่อให้แน่ใจว่าตีถึง
                        local unitRange = GetUnitRange(cheapestUnit.Data) or 18
                        
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
                            
                            -- ⭐⭐⭐ FIX: เช็คว่าวางได้จริง + ตี enemy ได้
                            if CanPlaceAtPosition(cheapestUnit.Name, testPos) then
                                -- เช็คว่าตี enemy ได้จริง (distance <= unitRange)
                                if distance <= unitRange then
                                    table.insert(validPositions, {
                                        position = testPos,
                                        distance = distance
                                    })
                                    
                                    -- เลือกตำแหน่งที่ใกล้ที่สุด (แต่ต้องตีถึง)
                                    if distance < bestDistance then
                                        bestPos = testPos
                                        bestDistance = distance
                                    end
                                else
                                    DebugPrint(string.format("⚠️ ตำแหน่ง (%.1f, %.1f) ไกลเกิน range: %.1f > %d", 
                                        testPos.X, testPos.Z, distance, unitRange))
                                end
                            end
                        end
                        
                        -- ⭐ Log เฉพาะเมื่อพบตำแหน่งหรือล้มเหลว (ไม่ spam)
                        if #validPositions > 0 then
                            DebugPrint(string.format("✅ พบ %d ตำแหน่งว่าง รอบ %s (ID: %d) | ใกล้ที่สุด: %.1f studs (Range: %d) → ตำแหน่งวาง: %.1f, %.1f, %.1f", 
                                #validPositions, staticEnemy.Name, correctEntityIdNumber, bestDistance, unitRange,
                                bestPos.X, bestPos.Y, bestPos.Z))
                        else
                            DebugPrint(string.format("⚠️ ไม่พบตำแหน่งว่างที่ตีถึง → ใช้ตำแหน่ง Enemy โดยตรง: %.1f, %.1f, %.1f (Range: %d)", 
                                targetPos.X, targetPos.Y, targetPos.Z, unitRange))
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
                            
                            -- ⛔ เช็ค Excluded Zone ก่อน!
                            if not IsInFrozenPortExcludedZone(testPos) then
                            
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
                            end -- ⛔ end Excluded Zone check
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
    
    -- ⭐ Frozen Port: ใช้ระบบเฉพาะ
    if _G.APState and _G.APState.IsFrozenPort then
        local frozenPos = GetFrozenPortAutoPlacePosition(unitRange, gamePhase)
        if frozenPos then
            return frozenPos
        end
        -- ถ้าไม่เจอตำแหน่ง Frozen Port → ใช้ระบบปกติ
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
        
        -- ⭐⭐⭐ STRICT FILTER: ถ้าตีไม่ได้ node ใดเลย → ข้ามตำแหน่งนี้!
        if nodesInRange < 1 then
            -- ตำแหน่งนี้อยู่นอก range ของ path ทั้งหมด → ไม่พิจารณา
            score = -99999  -- ให้คะแนนต่ำสุดเพื่อไม่เลือก
        else
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
        end
        
        -- ===== 🎯 BONUS ใกล้ Base/จุดจบ (สำคัญมาก!) =====
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

-- ===== RANGE VERIFICATION FUNCTION =====
-- ⭐⭐⭐ NEW: ตรวจสอบว่าตำแหน่งนี้สามารถตี path ได้จริงหรือไม่
local function VerifyPositionInRange(position, unitRange, minPathNodesRequired)
    if not position or not unitRange then
        return false, 0
    end
    
    minPathNodesRequired = minPathNodesRequired or 1  -- ต้องตีได้อย่างน้อย 1 node
    
    local path = GetMapPath()
    if not path or #path == 0 then
        return true, 0  -- ไม่มี path = อนุญาต (fallback)
    end
    
    local nodesInRange = 0
    local closestDist = math.huge
    
    for _, node in ipairs(path) do
        local dist = (position - node).Magnitude
        if dist < closestDist then
            closestDist = dist
        end
        if dist <= unitRange then
            nodesInRange = nodesInRange + 1
        end
    end
    
    local isValid = nodesInRange >= minPathNodesRequired
    
    if not isValid then
        DebugPrint(string.format("❌ Position (%.1f, %.1f) OUT OF RANGE! nodesInRange=%d (need %d), closestDist=%.1f, range=%.1f", 
            position.X, position.Z, nodesInRange, minPathNodesRequired, closestDist, unitRange))
    end
    
    return isValid, nodesInRange
end

-- ⭐⭐⭐ NEW: หาตำแหน่งที่ดีที่สุดโดยบังคับให้ตีถึง path แน่นอน
local function GetVerifiedPlacementPosition(unitRange, gamePhase, unitName, unitData, minNodesRequired)
    minNodesRequired = minNodesRequired or 3  -- ต้องตีได้อย่างน้อย 3 nodes
    
    -- เรียก GetBestPlacementPosition ปกติก่อน
    local bestPos = GetBestPlacementPosition(unitRange, gamePhase, unitName, unitData)
    
    if bestPos then
        local isValid, nodesInRange = VerifyPositionInRange(bestPos, unitRange, minNodesRequired)
        if isValid then
            return bestPos, nodesInRange
        end
        
        -- ถ้าตำแหน่งไม่ valid → ลองหาตำแหน่งใกล้ๆ ที่ valid
        DebugPrint(string.format("⚠️ BestPos ตีไม่ถึง! กำลังหาตำแหน่งใกล้ๆ ที่ valid..."))
        
        local path = GetMapPath()
        if path and #path > 0 then
            -- หาตำแหน่งใกล้ path nodes โดยตรง
            local safeDistance = unitRange * 0.7  -- วางห่างจาก path 70% ของ range
            local candidates = {}
            
            for i, node in ipairs(path) do
                -- ทดสอบหลายมุมรอบๆ node
                for angle = 0, math.pi * 2, math.pi / 6 do  -- 12 ทิศทาง
                    local offsetX = math.cos(angle) * safeDistance
                    local offsetZ = math.sin(angle) * safeDistance
                    local testPos = node + Vector3.new(offsetX, 0, offsetZ)
                    
                    if CanPlaceAtPosition(unitName, testPos) then
                        local valid, nodes = VerifyPositionInRange(testPos, unitRange, minNodesRequired)
                        if valid then
                            table.insert(candidates, {
                                Position = testPos,
                                NodesInRange = nodes,
                                PathIndex = i
                            })
                        end
                    end
                end
            end
            
            if #candidates > 0 then
                -- เลือกตำแหน่งที่ครอบคลุม path มากที่สุด และใกล้ base (path index สูง)
                table.sort(candidates, function(a, b)
                    -- Priority: NodesInRange สูง + PathIndex สูง (ใกล้ base)
                    local scoreA = a.NodesInRange * 10 + a.PathIndex
                    local scoreB = b.NodesInRange * 10 + b.PathIndex
                    return scoreA > scoreB
                end)
                
                local finalPos = candidates[1].Position
                DebugPrint(string.format("✅ พบตำแหน่ง Verified! (%.1f, %.1f) nodes=%d", 
                    finalPos.X, finalPos.Z, candidates[1].NodesInRange))
                return finalPos, candidates[1].NodesInRange
            end
        end
    end
    
    -- Fallback: คืน bestPos ถึงแม้จะไม่ valid (ดีกว่าไม่วาง)
    if bestPos then
        DebugPrint(string.format("⚠️ Fallback: ใช้ตำแหน่งเดิม (%.1f, %.1f) แม้ไม่ verified", bestPos.X, bestPos.Z))
    end
    return bestPos, 0
end

-- ===== PLACEMENT VALIDATION =====
CanPlaceAtPosition = function(unitName, position)
    -- ⛔ เช็ค Excluded Zone ก่อน! (Frozen Port)
    if IsInFrozenPortExcludedZone(position) then
        DebugPrint(string.format("⛔ ห้ามวาง! ตำแหน่ง (%.1f, %.1f) อยู่ใน Excluded Zone", position.X, position.Z))
        return false
    end
    
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
    
    -- ⭐⭐⭐ EXCEPTION: Iscanur ที่ Wave 1 ข้ามการเช็คเงิน (Auto Burn ทำให้เงินเป็น 0)
    local isIscanur = unit.Name and unit.Name:lower():find("iscanur")
    local isWave1 = CurrentWave == 1
    local skipMoneyCheck = isIscanur and isWave1
    
    if not skipMoneyCheck and unit.Price > 0 and yen < unit.Price then
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
        
        -- ⭐⭐⭐ Reset Emergency upgrade count เมื่อขาย unit
        EmergencyUpgradeCount[unit.GUID] = nil
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
        if not GameHandler or not GameHandler.GameData then return end
        
        local GameData = GameHandler.GameData
        
        -- ใช้ StagesData:GetCurrentStage() เหมือน decompiled code
        local success, stageData = pcall(function()
            return StagesData:GetCurrentStage(GameData)
        end)
        
        if success and stageData then
            -- GetCurrentStage() คืน table ที่มี .Name property
            if stageData.Name then
                stageName = stageData.Name
            elseif stageData.StageName then
                stageName = stageData.StageName
            end
        end
    end)
    
    return stageName
end

-- ===== GET STAGE INFO (แบบเต็ม - เหมือน logs_av.lua ทุกอย่าง) =====
local function GetCurrentStageInfo()
    local stageInfo = {
        ["name"] = "Unknown",
        ["chapter"] = "Unknown",
        ["wave"] = "0",
        ["mode"] = "Unknown",
        ["difficulty"] = "Unknown"
    }
    
    pcall(function()
        if not GameHandler or not GameHandler.GameData then return end
        
        local GameData = GameHandler.GameData
        
        -- 1. ดึงข้อมูลพื้นฐานจาก GameData
        stageInfo["mode"] = GameData.StageType or "Unknown"
        stageInfo["difficulty"] = GameData.Difficulty or "Unknown"
        
        -- 2. Chapter: ใช้ StagesData:GetCurrentAct() เหมือน decompiled code
        local actSuccess, actData = pcall(function()
            return StagesData:GetCurrentAct(GameData)
        end)
        
        if actSuccess and actData then
            -- GetCurrentAct() คืน object ที่มี .StageType, .Stage, .Act
            if GameData.StageType == "Worldline" and GameData.WorldlineRoom then
                stageInfo["chapter"] = "Floor " .. tostring(GameData.WorldlineRoom)
            elseif GameData.PortalData and GameData.PortalData.Tier then
                stageInfo["chapter"] = "Tier " .. tostring(GameData.PortalData.Tier)
            elseif actData.Act then
                stageInfo["chapter"] = tostring(actData.Act)
            end
        end
        
        -- 3. Wave: อ่านจาก UI (HUD.Map.WavesAmount)
        pcall(function()
            if not PlayerGui then return end
            local HUD = PlayerGui:FindFirstChild("HUD")
            if HUD then
                local Map = HUD:FindFirstChild("Map")
                if Map then
                    local WavesAmount = Map:FindFirstChild("WavesAmount")
                    if WavesAmount and WavesAmount:IsA("TextLabel") then
                        local text = WavesAmount.Text or ""
                        -- ลบ HTML tags และ whitespace
                        local cleanText = text:gsub("<[^>]+>", ""):gsub("%s+", "")
                        if cleanText ~= "" then
                            stageInfo["wave"] = cleanText
                        end
                    end
                end
            end
        end)
        
        -- 4. Name: ใช้ GetCurrentStageName() (ใช้ GetCurrentStage() ภายใน)
        local stageName = GetCurrentStageName()
        if stageName and stageName ~= "Unknown" and stageName ~= "" then
            stageInfo["name"] = stageName
        end
    end)
    
    return stageInfo
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

-- ===== 👑 LICH KING WHITE ZONE (Imprisoned Island Act3 Rift) =====
-- จากรูป: พื้นที่สีม่วง/ชมพู = พื้นที่ตรงกลางแผนที่ (Purple Zone)
-- Lich King (Ruler) จะวางได้เฉพาะในโซนนี้เท่านั้น (เฉพาะ Rift Mode)
local LichKingPurpleZone = {
    Center = nil,  -- จุดศูนย์กลางของ Purple Zone
    Positions = {},  -- ตำแหน่งที่ valid สำหรับ Lich King
    Calculated = false,  -- เคยคำนวณแล้วหรือยัง
}

-- ⭐⭐⭐ คำนวณ Purple Zone (พื้นที่สีน้ำเงินลายตาราง) สำหรับ Rift Mode
-- ⚠️ เฉพาะ Lich King เท่านั้น! Unit อื่นใช้ระบบปกติ
local function CalculateLichKingPurpleZone()
    local positions = {}
    
    local Map = workspace:FindFirstChild("Map")
    if not Map then 
        return positions 
    end
    
    -- ⭐⭐⭐ IMPRISONED ISLAND RIFT: ใช้พิกัดที่กำหนดไว้ (ตรงร่มชมพู/พื้นสีน้ำเงิน)
    -- พิกัด: X=114.67, Y=248.68, Z=366.06 (Lich King Rift Position)
    local fixedCenter = Vector3.new(114.66655731201172, 248.6777801513672, 366.060791015625)
    
    -- สร้างตำแหน่งรอบๆ จุดนี้ (ใกล้มาก 3-15 studs)
    local spacing = 5
    local minRadius = 3
    local maxRadius = 15
    
    for x = -maxRadius, maxRadius, spacing do
        for z = -maxRadius, maxRadius, spacing do
            local dist = (x*x + z*z)^0.5
            if dist >= minRadius and dist <= maxRadius then
                local gridPos = Vector3.new(fixedCenter.X + x, fixedCenter.Y, fixedCenter.Z + z)
                table.insert(positions, gridPos)
            end
        end
    end
    
    -- เพิ่มจุดกลางด้วย (ตรงร่มพอดี)
    table.insert(positions, 1, fixedCenter)
    
    if #positions > 0 then
        LichKingPurpleZone.Center = fixedCenter
        LichKingPurpleZone.Positions = positions
        LichKingPurpleZone.Calculated = true
        
        if not _G.LichKingZoneLogged then
            _G.LichKingZoneLogged = true
            print(string.format("[LichKing] 👑 Purple Zone: Fixed position (%.0f, %.0f, %.0f) - %d positions", 
                fixedCenter.X, fixedCenter.Y, fixedCenter.Z, #positions))
        end
    end
    
    return positions
end

-- หาตำแหน่งสำหรับ Lich King (Ruler) ใน Purple Zone
-- ⭐⭐⭐ SIMPLE: ใช้จุดที่กำหนดเป็นศูนย์กลาง ถ้าวางไม่ได้ค่อยขยับ
local function GetLichKingPurpleZonePosition(unitRange)
    local activeUnits = GetActiveUnits()
    
    -- ⭐⭐⭐ จุดศูนย์กลางสำหรับ Lich King (Imprisoned Island Rift)
    local fixedCenter = Vector3.new(114.66655731201172, 248.6777801513672, 366.060791015625)
    
    -- ⭐ เช็คว่ามี unit อยู่ที่ตำแหน่งนี้หรือไม่
    local function isOccupied(pos)
        for _, unit in pairs(activeUnits) do
            if unit.Position and (unit.Position - pos).Magnitude < 5 then
                return true
            end
        end
        return false
    end
    
    -- ⭐ ลองจุดศูนย์กลางก่อน
    if not isOccupied(fixedCenter) then
        print(string.format("[LichKing] 👑 วางตรงจุดศูนย์กลาง: (%.1f, %.1f, %.1f)", fixedCenter.X, fixedCenter.Y, fixedCenter.Z))
        return fixedCenter
    end
    
    -- ⭐ ถ้าจุดกลางเต็ม → ขยับรอบๆ (ระยะ 1-15 studs)
    local offsets = {}
    for radius = 1, 15 do
        table.insert(offsets, {radius, 0})
        table.insert(offsets, {-radius, 0})
        table.insert(offsets, {0, radius})
        table.insert(offsets, {0, -radius})
        table.insert(offsets, {radius, radius})
        table.insert(offsets, {-radius, radius})
        table.insert(offsets, {radius, -radius})
        table.insert(offsets, {-radius, -radius})
    end
    
    for _, offset in ipairs(offsets) do
        local pos = Vector3.new(fixedCenter.X + offset[1], fixedCenter.Y, fixedCenter.Z + offset[2])
        
        if not isOccupied(pos) then
            print(string.format("[LichKing] 👑 ขยับ +(%d, %d): (%.1f, %.1f, %.1f)", 
                offset[1], offset[2], pos.X, pos.Y, pos.Z))
            return pos
        end
    end
    
    -- Fallback: คืนจุดศูนย์กลาง
    print("[LichKing] ⚠️ ทุกตำแหน่งเต็ม → ใช้จุดศูนย์กลาง")
    return fixedCenter
end

-- เช็คว่าเป็น Lich King (Ruler) หรือไม่
local function IsLichKingRuler(unitName)
    if not unitName then return false end
    local nameLower = unitName:lower()
    return nameLower:find("lich") and nameLower:find("ruler")
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
            
            -- ⛔ เช็ค Excluded Zone ก่อน!
            if IsInFrozenPortExcludedZone(testPos) then
                -- ข้าม ตำแหน่งนี้ห้ามวาง
            else
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
                
                -- ⭐⭐⭐ EXCEPTION: Iscanur ที่ Wave 1 ข้ามการเช็คเงิน (Auto Burn ทำให้เงินเป็น 0)
                local isIscanur = unit.Name and unit.Name:lower():find("iscanur")
                local isWave1 = CurrentWave == 1
                local skipMoneyCheck = isIscanur and isWave1
                
                local status = string.format("Slot%d:%s(%d/%d,Y%d/%d,%s%s)", 
                    slotNum, unit.Name, current, limit, yen, unit.Price, 
                    canPlace and "✓" or "✗",
                    skipMoneyCheck and "(W1)" or "")
                table.insert(logData, status)
                
                -- ⭐ ถ้าเป็น Iscanur + Wave 1 → ข้ามการเช็คเงิน
                if canPlace and (skipMoneyCheck or yen >= unit.Price) then
                    if skipMoneyCheck then
                        -- ⭐ หาราคาจริงจาก UnitObject (หลัง Auto Burn)
                        local realPrice = unit.Price
                        if unit.UnitObject and unit.UnitObject.Cost then
                            realPrice = unit.UnitObject.Cost
                        end
                    end
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
    print("[FORCED] 🎮 AUTO PLAY SYSTEM STARTED!")
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
            local oldIsEmergency = IsEmergency
            CheckEmergency()
            
            -- 🔍 DEBUG: แสดงสถานะ Emergency Mode ทุกครั้ง (ทุก 2 วินาที)
            if not _G.LastEmergencyDebugLog then _G.LastEmergencyDebugLog = 0 end
            if tick() - _G.LastEmergencyDebugLog >= 2 then
                _G.LastEmergencyDebugLog = tick()
                print(string.format("[DEBUG] 🔥 IsEmergency: %s | CurrentWave: %d | MaxWave: %d", 
                    tostring(IsEmergency), CurrentWave or 0, MaxWave or 0))
            end
            
            -- ⬆️ อัพเกรด 1 ขั้นเมื่อ Emergency (ทั้ง 2 ระบบ)
            if IsEmergency or EmergencyMode.Active then
                UpgradeUnitsEmergency()
            end
            
            -- 🎯 AUTO ABILITY: ใช้ระบบจาก AbilitySystem.lua
            if _G.AbilitySystem and _G.AbilitySystem.AutoUseAbilitiesV3 then
                pcall(function()
                    _G.AbilitySystem.AutoUseAbilitiesV3()
                end)
            end
            
            -- 🔢 AUTO NUMBER PAD: รหัสอัตโนมัติ (Happy Factory)
            pcall(RunAutoNumberPad)
            
            -- 🔄 AUTO REPLAY: Vote Replay อัตโนมัติ
            pcall(AutoVoteReplay)
            
            -- 🌀 AUTO PORTAL: เลือก Portal อัตโนมัติ
            pcall(AutoSelectPortal)
            
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
            
            -- ===== EMERGENCY MODE: วางตัว + อัพเกรด (แยกระบบตาม Map Type) =====
            if IsEmergency then
                -- ✅ นับจำนวน Emergency Units จาก table โดยตรง
                local emergencyCount = 0
                for _ in pairs(EmergencyUnits) do
                    emergencyCount = emergencyCount + 1
                end
                
                -- ⭐⭐⭐ แยกระบบตาม Map Type
                local isFrozenPortMap = _G.APState and _G.APState.IsFrozenPort
                local isImprisonedRiftMap = _G.APState and _G.APState.IsImprisonedIslandRift
                
                -- ⭐⭐⭐ LIMIT: จำนวน Emergency Units ต่างกันตาม map
                local maxEmergencyUnits = 2
                
                -- ⭐ Log แสดง Map Type ที่ถูกต้อง
                local mapTypeName = "Normal"
                if isImprisonedRiftMap then
                    mapTypeName = "Imprisoned Island (Purple Zone)"
                elseif isFrozenPortMap then
                    mapTypeName = "Frozen Port (U-Center)"
                end
                
                DebugPrint(string.format("🚨 Emergency Mode: มี %d/%d ตัว (%s)", 
                    emergencyCount, maxEmergencyUnits, mapTypeName))
                
                -- ✅ ถ้าวางครบ 2 ตัวแล้ว → ตรวจสอบว่าจะอัพเกรดหรือไม่
                if emergencyCount >= maxEmergencyUnits then
                    DebugPrint("✅ Emergency Units ครบ 2 ตัวแล้ว")
                    
                    -- ⭐⭐⭐ แยกระบบ Upgrade ตาม Map Type:
                    -- FROZEN PORT: อัพเกรด 2 ขั้น (เหมือนเดิม)
                    -- RIFT + NORMAL: ไม่อัพเกรด → ใช้ระบบปกติ
                    if isFrozenPortMap then
                        -- ❄️ FROZEN PORT: อัพเกรด Emergency Units คนละ 2 ขั้น
                        DebugPrint("❄️ Frozen Port: อัพเกรด Emergency Units 2 ขั้น")
                        local upgradeCount = 0
                        local activeUnits = GetActiveUnits()
                        
                        for guid, _ in pairs(EmergencyUnits) do
                            for _, unit in pairs(activeUnits) do
                                if unit.GUID == guid then
                                    -- ⭐⭐⭐ ใช้ EmergencyUpgradeCount tracking เหมือนกันทุก map
                                    local currentUpgrades = EmergencyUpgradeCount[guid] or 0
                                    if currentUpgrades >= MAX_EMERGENCY_UPGRADES then
                                        -- ⭐⭐⭐ อัพครบ 2 ขั้นแล้ว → ข้าม
                                        DebugPrint(string.format("⏹️ %s อัพครบ %d ขั้นแล้ว (ห้ามอัพเพิ่ม)", unit.Name, MAX_EMERGENCY_UPGRADES))
                                        break
                                    end
                                    
                                    local currentLevel = GetCurrentUpgradeLevel(unit) or 0
                                    local maxLevel = GetMaxUpgradeLevel(unit) or 10
                                    local remainingUpgrades = MAX_EMERGENCY_UPGRADES - currentUpgrades
                                    local targetLevel = math.min(currentLevel + remainingUpgrades, maxLevel)
                                    
                                    -- อัพเกรดทีละขั้นจน ถึง targetLevel
                                    while (GetCurrentUpgradeLevel(unit) or 0) < targetLevel do
                                        local cost = GetUpgradeCost(unit)
                                        if yen >= cost then
                                            if UpgradeUnit(unit) then
                                                upgradeCount = upgradeCount + 1
                                                yen = yen - cost
                                                
                                                -- ⭐⭐⭐ Track Emergency Upgrade
                                                EmergencyUpgradeCount[guid] = (EmergencyUpgradeCount[guid] or 0) + 1
                                                
                                                DebugPrint(string.format("⬆️ อัพเกรด Emergency: %s (Lv %d → %d) [%d/%d]", 
                                                    unit.Name, GetCurrentUpgradeLevel(unit) - 1, GetCurrentUpgradeLevel(unit),
                                                    EmergencyUpgradeCount[guid], MAX_EMERGENCY_UPGRADES))
                                                task.wait(0.1)
                                            else
                                                break
                                            end
                                        else
                                            DebugPrint(string.format("💸 เงินไม่พอ อัพเกรด %s (ต้องการ %d)", unit.Name, cost))
                                            break
                                        end
                                    end
                                    break
                                end
                            end
                        end
                        
                        if upgradeCount > 0 then
                            DebugPrint(string.format("Upgraded Emergency Units: %d times", upgradeCount))
                        end
                    else
                        -- 🏝️ RIFT / 🗺️ NORMAL: อัพเกรด Emergency Units คนละ 2 ขั้น (เหมือน Frozen Port)
                        local mapName = isImprisonedRiftMap and "Imprisoned Rift" or "Normal Map"
                        DebugPrint(string.format("🔧 %s: อัพเกรด Emergency Units 2 ขั้น", mapName))
                        
                        local upgradeCount = 0
                        local activeUnits = GetActiveUnits()
                        
                        for guid, _ in pairs(EmergencyUnits) do
                            for _, unit in pairs(activeUnits) do
                                if unit.GUID == guid then
                                    -- ⭐⭐⭐ ใช้ EmergencyUpgradeCount tracking
                                    local currentUpgrades = EmergencyUpgradeCount[guid] or 0
                                    if currentUpgrades >= MAX_EMERGENCY_UPGRADES then
                                        DebugPrint(string.format("⏹️ %s อัพครบ %d ขั้นแล้ว", unit.Name, MAX_EMERGENCY_UPGRADES))
                                        break
                                    end
                                    
                                    local currentLevel = GetCurrentUpgradeLevel(unit) or 0
                                    local maxLevel = GetMaxUpgradeLevel(unit) or 10
                                    local remainingUpgrades = MAX_EMERGENCY_UPGRADES - currentUpgrades
                                    local targetLevel = math.min(currentLevel + remainingUpgrades, maxLevel)
                                    
                                    while (GetCurrentUpgradeLevel(unit) or 0) < targetLevel do
                                        local cost = GetUpgradeCost(unit)
                                        if yen >= cost then
                                            if UpgradeUnit(unit) then
                                                upgradeCount = upgradeCount + 1
                                                yen = yen - cost
                                                EmergencyUpgradeCount[guid] = (EmergencyUpgradeCount[guid] or 0) + 1
                                                DebugPrint(string.format("⬆️ Emergency Upgrade: %s (Lv %d → %d) [%d/%d]", 
                                                    unit.Name, GetCurrentUpgradeLevel(unit) - 1, GetCurrentUpgradeLevel(unit),
                                                    EmergencyUpgradeCount[guid], MAX_EMERGENCY_UPGRADES))
                                                task.wait(0.1)
                                            else
                                                break
                                            end
                                        else
                                            DebugPrint(string.format("💸 เงินไม่พอ อัพเกรด %s (ต้องการ %d)", unit.Name, cost))
                                            break
                                        end
                                    end
                                    break
                                end
                            end
                        end
                        
                        if upgradeCount > 0 then
                            DebugPrint(string.format("Upgraded Emergency Units: %d times", upgradeCount))
                        end
                    end
                    
                    -- ⭐⭐⭐ วางครบแล้ว → ปิด Emergency Mode เพื่อให้ระบบปกติทำงาน (อัพเกรดตัวเงิน)
                    EmergencyActivated = true
                    IsEmergency = false  -- ⭐⭐⭐ FIX: ปิด Emergency ทันทีเมื่อวางครบ!
                    
                else
                    -- ยังวางไม่ครบ 2 ตัว → วางเพิ่ม
                    local timeSinceEmergency = tick() - EmergencyStartTime
                    
                    if timeSinceEmergency >= 2 then  -- รอ 2 วินาที
                        local slot, unit = GetCheapestDamageSlotNoLimit()
                        
                        if slot and unit and yen >= unit.Price then
                            local unitRange = GetUnitRange(unit.Data)
                            local pos = nil
                            
                            -- ⭐⭐⭐ EMERGENCY PLACEMENT: แยกระบบตาม Map Type
                            local unitName = unit.Name or ""
                            local isLichKingRuler = unitName:lower():find("lich") and unitName:lower():find("ruler")
                            
                            -- ⭐⭐⭐ IMPRISONED ISLAND RIFT
                            if isImprisonedRiftMap then
                                if isLichKingRuler then
                                    -- ⭐ Lich King เท่านั้น → ใช้ Purple Zone (พิกัดที่กำหนด)
                                    print(string.format("[EMERGENCY] 🏝️ Imprisoned Island - วาง %s ที่ Purple Zone", unitName))
                                    pos = GetLichKingPurpleZonePosition(unitRange)
                                    if not pos then
                                        pos = GetBestPlacementPosition(unitRange, "late", unit.Name, unit.Data)
                                    end
                                else
                                    -- ⭐ Unit อื่น → ใช้ Emergency Position (ดักทาง) เหมือน Normal Mode
                                    print(string.format("[EMERGENCY] 🏝️ Imprisoned Island - วาง %s ดักทาง", unitName))
                                    pos = GetEmergencyPlacementPosition(unitRange, unit.Name, unit.Data)
                                    if not pos then
                                        pos = GetBestPlacementPosition(unitRange, "late", unit.Name, unit.Data)
                                    end
                                end
                            elseif isFrozenPortMap then
                                -- Frozen Port → วางที่ U-Center
                                pos = GetEmergencyPlacementPosition(unitRange, unit.Name, unit.Data)
                                if not pos then
                                    pos = GetBestPlacementPosition(unitRange, "late", unit.Name, unit.Data)
                                end
                            else
                                -- Normal Map → ใช้ Emergency Position
                                pos = GetEmergencyPlacementPosition(unitRange, unit.Name, unit.Data)
                                if not pos then
                                    pos = GetBestPlacementPosition(unitRange, "late", unit.Name, unit.Data)
                                end
                            end
                            
                            -- วาง Unit
                            if pos then
                                local success, newGUID = PlaceUnit(slot, pos)
                                if success and newGUID then
                                    EmergencyUnits[newGUID] = true
                                    LastEmergencyTime = tick()
                                    DebugPrint(string.format("[EMERGENCY] Placed: %s (#%d) at %s", unit.Name, emergencyCount + 1, mapTypeName))
                                end
                            else
                                print(string.format("[EMERGENCY] ⚠️ ไม่พบตำแหน่งวาง %s", unitName))
                            end
                        end
                    end
                end
            end
            
            -- ===== ⭐⭐⭐ LEGENDS STAGE SPECIAL: Burning Spirit Tree / Golden Castle =====
            -- ด่านเหล่านี้ตัวเงินวางไม่ได้ → บังคับหาตำแหน่งพิเศษ!
            local isLegendStageIncomeIssue = false
            local legendStageName = ""
            local currentStageName = ""
            local currentStageMode = ""
            local currentStageAct = ""
            
            pcall(function()
                currentStageName = GetCurrentStageName() or ""
                local stageNameLower = currentStageName:lower()
                
                -- ดึง Mode และ Act จาก GameHandler
                if GameHandler and GameHandler.GameData then
                    currentStageMode = GameHandler.GameData.StageType or GameHandler.GameData.Mode or "Unknown"
                    currentStageAct = tostring(GameHandler.GameData.Act or GameHandler.GameData.Chapter or "Unknown")
                end
                
                -- ⭐⭐⭐ DETECTION 1: ชื่อด่าน
                if stageNameLower:find("burning") or stageNameLower:find("spirit") or stageNameLower:find("tree") then
                    isLegendStageIncomeIssue = true
                    legendStageName = "Burning Spirit Tree"
                elseif stageNameLower:find("golden") or stageNameLower:find("castle") then
                    isLegendStageIncomeIssue = true
                    legendStageName = "Golden Castle"
                -- ⭐⭐⭐ DETECTION 2: Anniversary Dungeon + Act 7 = Golden Castle
                elseif stageNameLower:find("anniversary") and currentStageAct == "Act2" then
                    isLegendStageIncomeIssue = true
                    legendStageName = "Golden Castle (Anniversary Act2)"
                -- ⭐⭐⭐ DETECTION 3: Anniversary Dungeon + Act 2 = Burning Spirit Tree
                elseif stageNameLower:find("anniversary") and currentStageAct == "Act7" then
                    isLegendStageIncomeIssue = true
                    legendStageName = "Burning Spirit Tree (Anniversary Act7)"
                -- ⭐⭐⭐ DETECTION 4: Dungeon Mode + Act7/Act2
                elseif currentStageMode == "Dungeon" then
                    if currentStageAct == "Act7" or currentStageAct == "7" then
                        isLegendStageIncomeIssue = true
                        legendStageName = "Golden Castle (Dungeon Act7)"
                    elseif currentStageAct == "Act2" or currentStageAct == "2" then
                        isLegendStageIncomeIssue = true
                        legendStageName = "Burning Spirit Tree (Dungeon Act7)"
                    end
                end
            end)
            
            -- ⭐⭐⭐ DEBUG: แสดงข้อมูลด่านทุก 5 วินาที
            if not _G.LastStageDebugLog then _G.LastStageDebugLog = 0 end
            if tick() - _G.LastStageDebugLog >= 5 then
                _G.LastStageDebugLog = tick()
                print(string.format("[STAGE DEBUG] 📍 Name: '%s' | Mode: '%s' | Act: '%s' | isLegendStageIncomeIssue: %s | hasAnyIncomeUnit: %s", 
                    currentStageName, currentStageMode, currentStageAct, 
                    tostring(isLegendStageIncomeIssue), tostring(hasAnyIncomeUnit)))
            end
            
            -- ⭐⭐⭐ SPECIAL INCOME PLACEMENT สำหรับ Burning Spirit Tree / Golden Castle
            if isLegendStageIncomeIssue and hasAnyIncomeUnit and not MaxWaveSellTriggered then
                -- ⭐⭐⭐ หา Economy Unit โดยตรงจาก Hotbar (ไม่ใช้ GetNextEconomySlot)
                local ecoSlot = nil
                local ecoUnit = nil
                local hotbar = GetHotbarUnits()
                
                if hotbar then
                    for slotNum = 1, 6 do
                        local unit = hotbar[slotNum]
                        if unit then
                            local isEconomy = unit.IsIncome or (unit.Data and IsIncomeUnit(unit.Name, unit.Data))
                            if isEconomy then
                                local yen = GetYen()
                                local price = unit.Price or 0
                                if yen >= price then
                                    ecoSlot = slotNum
                                    ecoUnit = unit
                                    break
                                end
                            end
                        end
                    end
                end
                
                if ecoSlot and ecoUnit then
                    local placed = false
                    
                    -- ⭐⭐⭐ รวบรวม SpawnLocation ทั้งหมด และเลือกที่ไกล path + ไม่ทับ unit อื่น
                    pcall(function()
                        local Map = workspace:FindFirstChild("Map")
                        if Map then
                            local path = GetMapPath()
                            local activeUnits = GetActiveUnits()
                            local allSpawnLocations = {}
                            
                            -- รวบรวม SpawnLocation ทั้งหมด
                            for _, child in ipairs(Map:GetChildren()) do
                                if child:IsA("SpawnLocation") then
                                    table.insert(allSpawnLocations, child)
                                end
                            end
                            
                            -- หาใน descendants ด้วย
                            for _, spawn in ipairs(Map:GetDescendants()) do
                                if spawn:IsA("SpawnLocation") then
                                    local found = false
                                    for _, existing in ipairs(allSpawnLocations) do
                                        if existing == spawn then found = true break end
                                    end
                                    if not found then
                                        table.insert(allSpawnLocations, spawn)
                                    end
                                end
                            end
                            
                            -- ⭐⭐⭐ คำนวณระยะห่างจาก path และ unit อื่น
                            local spawnWithDistance = {}
                            for _, spawn in ipairs(allSpawnLocations) do
                                local spawnPos = spawn.Position
                                local minDistToPath = math.huge
                                local minDistToUnit = math.huge
                                
                                -- หาระยะที่ใกล้ path ที่สุด
                                if path and #path > 0 then
                                    for _, node in ipairs(path) do
                                        local dist = (Vector3.new(spawnPos.X, 0, spawnPos.Z) - Vector3.new(node.X, 0, node.Z)).Magnitude
                                        if dist < minDistToPath then
                                            minDistToPath = dist
                                        end
                                    end
                                else
                                    minDistToPath = 100
                                end
                                
                                -- ⭐⭐⭐ หาระยะที่ใกล้ unit อื่นที่สุด (ต้องไม่ทับ!)
                                for _, unit in pairs(activeUnits) do
                                    if unit.Position then
                                        local dist = (Vector3.new(spawnPos.X, 0, spawnPos.Z) - Vector3.new(unit.Position.X, 0, unit.Position.Z)).Magnitude
                                        if dist < minDistToUnit then
                                            minDistToUnit = dist
                                        end
                                    end
                                end
                                
                                -- ⭐⭐⭐ ต้องไม่ทับ unit อื่น (> 3 studs - ใกล้กันมาก!)
                                if minDistToUnit > 3 then
                                    table.insert(spawnWithDistance, {
                                        Spawn = spawn,
                                        Position = spawnPos,
                                        DistToPath = minDistToPath,
                                        DistToUnit = minDistToUnit
                                    })
                                end
                            end
                            
                            -- ⭐⭐⭐ เรียงตาม: ไกล path + ใกล้ unit อื่นมากที่สุด (วางเกาะกัน!)
                            table.sort(spawnWithDistance, function(a, b)
                                if a.DistToPath > 10 and b.DistToPath > 10 then
                                    return a.DistToUnit < b.DistToUnit
                                end
                                return a.DistToPath > b.DistToPath
                            end)
                            
                            -- วางที่ตำแหน่งที่ดีที่สุด (ไกล path + ใกล้ unit อื่น)
                            for _, data in ipairs(spawnWithDistance) do
                                local testPos = data.Position + Vector3.new(0, 2, 0)
                                
                                local timeSinceLastPlace = tick() - LastPlaceTime
                                if timeSinceLastPlace < 1.0 then
                                    break
                                end
                                
                                local unitID = ecoUnit.ID or (ecoUnit.Data and ecoUnit.Data.ID) or ecoSlot
                                local numericID = unitID
                                if type(unitID) == "string" and tonumber(unitID) then
                                    numericID = tonumber(unitID)
                                end
                                
                                local fireSuccess = pcall(function()
                                    UnitEvent:FireServer("Render", {
                                        ecoUnit.Name,
                                        numericID,
                                        testPos,
                                        0
                                    }, {
                                        SlotIndex = ecoSlot
                                    })
                                end)
                                
                                if fireSuccess then
                                    LastPlaceTime = tick()
                                    placed = true
                                    break
                                end
                            end
                        end
                    end)
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
                -- 🔥 ClearEnemy Mode ไม่บล็อก Auto Place! (ทำงานพร้อมกัน)
                -- ⭐ FIX: ไม่ต้องเช็ค EmergencyUnits เพราะมันเก็บ track units ไว้ขายทีหลัง
                local canPlaceNormal = not IsEmergency  -- ⭐ เช็คแค่ IsEmergency (ไม่เช็ค EmergencyActivated)
                
                -- ⭐⭐⭐ FIX: MaxWaveSellTriggered ห้ามวาง Economy เท่านั้น ไม่ห้ามวาง Damage!
                -- ย้ายการเช็ค MaxWaveSellTriggered ไปไว้เฉพาะส่วนวาง Economy
                
                -- Debug: แสดงสถานะ canPlaceNormal (ปิด log เพื่อลด spam)
                _G.LastCanPlaceNormal = canPlaceNormal
                
                if canPlaceNormal then
                    local hasEconomyInHotbar = hasAnyIncomeUnit and HasEconomyUnitInHotbar()  -- ⭐ ใช้ flag
                    local activeUnits = GetActiveUnits()
                
                    -- ===== STEP 1: วางตัวเงินก่อน (⭐ เฉพาะเมื่อมีตัวเงิน + ไม่ใช่ MaxWave) =====
                    -- ⭐⭐⭐ FIX: ข้ามทั้งหมดถ้าไม่มีตัวเงิน
                    -- ⭐⭐⭐ EXCEPTION: Iscanur วางได้ทันทีตั้งแต่ Wave 1
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
                    -- ⭐⭐⭐ EXCEPTION: Iscanur วางได้ทันทีตั้งแต่ Wave 1
                    local hasEcoInHotbar = hasAnyIncomeUnit and HasEconomyUnitInHotbar() or false
                    local shouldPlaceDamage = (not hasEcoInHotbar) or (not economyNeedsUpgrade)
                    
                    -- ⭐ เช็คว่ามี Iscanur ใน Hotbar หรือไม่
                    local hasIscanurInHotbar = false
                    local hotbar = GetHotbarUnits()
                    if hotbar then
                        for _, unit in pairs(hotbar) do
                            if unit and unit.Name and unit.Name:lower():find("iscanur") then
                                hasIscanurInHotbar = true
                                break
                            end
                        end
                    end
                    
                    -- ⭐ ถ้ามี Iscanur + Wave 1 → อนุญาตให้วาง Damage ทันที (ข้าม slot limit)
                    if hasIscanurInHotbar and CurrentWave == 1 then
                        shouldPlaceDamage = true
                    end
                    
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
                            
                            -- ⭐⭐⭐ LICH KING PURPLE ZONE: ถ้าเป็น Imprisoned Island Rift → ใช้ Purple Zone เท่านั้น!
                            -- เช็คทั้ง stage name และ APState
                            local stageName = GetCurrentStageName() or ""
                            local isImprisonedRift = (stageName:lower():find("imprisoned") and stageName:lower():find("island")) or
                                                     (_G.APState and _G.APState.IsImprisonedIslandRift)
                            
                            if isLichKingRuler and isImprisonedRift then
                                print(string.format("[LichKing] 👑 Imprisoned Island Rift - ใช้ Purple Zone สำหรับ %s", unitName))
                                pos = GetLichKingPurpleZonePosition(unitRange)
                                if pos then
                                    print(string.format("[LichKing] ✅ Purple Zone position: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
                                else
                                    print("[LichKing] ⚠️ ไม่พบตำแหน่งว่างใน Purple Zone!")
                                end
                            elseif placeAtFront then
                                -- วิเคราะห์ก่อนวาง (สำหรับด่านอื่นๆ)
                                print(string.format("[Analysis] 🔍 %s - วางหน้าประตู (Range: %d)", unitName, unitRange))
                                pos = GetBestFrontPosition(unitRange)
                                if pos then
                                    print(string.format("[Analysis] ✅ พบตำแหน่งหน้าประตู: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
                                end
                            end
                            
                            -- Fallback: ใช้ตำแหน่งปกติถ้าไม่เจอ front position
                            -- ⚠️ สำหรับ Lich King ใน Imprisoned Island Rift: ไม่ใช้ fallback (ต้อง White Zone เท่านั้น!)
                            if not pos and not (isLichKingRuler and _G.APState and _G.APState.IsImprisonedIslandRift) then
                                -- ⭐⭐⭐ FIX: ใช้ GetVerifiedPlacementPosition เพื่อให้แน่ใจว่าตีถึง path
                                pos = GetVerifiedPlacementPosition(unitRange, GetGamePhase(), dmgUnit.Name, dmgUnit.Data, 3)
                            end
                            
                            -- ⭐⭐⭐ FINAL CHECK: ตรวจสอบว่า position ที่ได้ตี path ได้จริง
                            if pos then
                                local isValid, nodesInRange = VerifyPositionInRange(pos, unitRange, 1)
                                if isValid then
                                    DebugPrint(string.format("⚔️ วาง Damage: %s (slot %d) | Range=%d | NodesHit=%d", 
                                        dmgUnit.Name, dmgSlot, unitRange, nodesInRange))
                                    PlaceUnit(dmgSlot, pos)
                                else
                                    DebugPrint(string.format("❌ ยกเลิกวาง %s - ตำแหน่งไม่ถึง path (range=%d)", dmgUnit.Name, unitRange))
                                end
                            end
                        end
                    end
                
                -- ===== Auto Upgrade Damage/Buff (หลังจากตัวเงินอัพ MAX แล้ว) =====
                -- ⚠️ NOTE: Lich King จะอัพเกรดหลังตัวเงิน MAX เท่านั้น (อยู่ใน allEconomyMaxed)
                -- แยกประเภท Units (ข้าม Emergency Units + ClearEnemy Units)
                local allEconomyMaxed = true
                local hasAnyEconomyUnit = false  -- ⭐ เพิ่มเช็คว่ามี economy unit หรือไม่
                for _, unit in pairs(activeUnits) do
                    if unit.Data and IsIncomeUnit(unit.Name, unit.Data) then
                        hasAnyEconomyUnit = true
                        -- ⭐ ใช้ฟังก์ชันจาก Decom
                        if not IsUnitMaxed(unit) then
                            allEconomyMaxed = false
                            break
                        end
                    end
                end
                
                    -- ⭐⭐⭐ FIX: ถ้าไม่มี economy unit เลย → ถือว่า allEconomyMaxed = true
                    if not hasAnyEconomyUnit then
                        allEconomyMaxed = true
                    end
                
                    -- อัพเกรด Damage/Buff เฉพาะเมื่อตัวเงินอัพ MAX แล้ว (หรือไม่มี economy unit)
                    if allEconomyMaxed then
                        local damageUnits = {}
                        local buffUnits = {}
                        local summonUnits = {}  -- ⭐ เพิ่ม Summon Units
                        
                        for _, unit in pairs(activeUnits) do
                            local unitData = unit.Data or {}
                            -- ⭐⭐⭐ FIX: ไม่ข้าม Emergency Units แล้ว! ให้อัพเกรดได้ปกติ
                            -- เพราะ Emergency Mode เปลี่ยนบ่อย และไม่ควร block upgrade
                            local skipEmergency = false
                            -- ⭐⭐⭐ REMOVED: ไม่ skip emergency units อีกแล้ว
                            -- if IsEmergency and EmergencyUnits[unit.GUID] and not IsPassiveSummonUnit(unit.Name, unitData) then
                            --     skipEmergency = true
                            -- end
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
                        
                        -- ⭐⭐⭐ PRIORITY 0: Force Upgrade Lich King (Ruler) ก่อนเสมอ จนกว่าจะ MAX!
                        -- Income MAX แล้ว → Lich King จะถูก upgrade ก่อน Damage ตัวอื่น
                        -- ⚠️ ใช้ SOLO UPGRADE สำหรับ Lich King (ไม่ใช่ multi-upgrade)
                        -- ⚠️ ถ้าไม่มี Lich King ในทีม → ข้ามไปใช้ Multi-Upgrade ปกติเลย
                        local lichKingMaxed = true
                        local lichKingUnit = nil
                        local hasLichKing = false  -- ⭐ เพิ่มตัวแปรเช็คว่ามี Lich King หรือไม่
                        
                        for _, unit in pairs(damageUnits) do
                            local unitNameLower = (unit.Name or ""):lower()
                            local isLichKingRuler = unitNameLower:find("lich") and unitNameLower:find("ruler")
                            if isLichKingRuler then
                                hasLichKing = true  -- ⭐ พบ Lich King ในทีม
                                lichKingUnit = unit
                                if not IsUnitMaxed(unit) then
                                    lichKingMaxed = false
                                    -- ⭐ SOLO UPGRADE: อัพแค่ 1 ครั้งต่อ loop (ไม่ multi-upgrade)
                                    local cost = GetUpgradeCost(unit)
                                    if cost < math.huge and GetYen() >= cost then
                                        local currentLevel = GetCurrentUpgradeLevel(unit)
                                        local maxLevel = GetMaxUpgradeLevel(unit)
                                        print(string.format("[SoloUpgrade] 👑 Lich King (Ruler) (%d/%d) [ค่าใช้จ่าย: %d]", currentLevel, maxLevel, cost))
                                        UpgradeUnit(unit)
                                        -- ⚠️ ไม่ต้อง task.wait เพราะ solo upgrade
                                    end
                                else
                                    print("[SoloUpgrade] ✅ Lich King (Ruler) MAX แล้ว!")
                                end
                                break  -- หา Lich King ตัวแรกเจอก็พอ
                            end
                        end
                        
                        -- ⭐⭐⭐ ถ้าไม่มี Lich King → ข้ามไป Multi-Upgrade ปกติเลย
                        -- ⭐ ถ้ามี Lich King แต่ยังไม่ MAX → ไม่อัพ Damage ตัวอื่น (รอ Lich King MAX ก่อน)
                        -- ⭐ ถ้า Lich King MAX แล้ว → กลับไปใช้ Multi-upgrade ตามปกติ
                        
                        -- ⭐⭐⭐ DEBUG: แสดงจำนวน units ที่พบ
                        if #damageUnits > 0 or hasLichKing then
                            -- DebugPrint(string.format("[Upgrade] DamageUnits: %d, HasLichKing: %s, LichKingMaxed: %s", 
                            --     #damageUnits, tostring(hasLichKing), tostring(lichKingMaxed)))
                        end
                        
                        if (not hasLichKing or lichKingMaxed) and #damageUnits > 0 then
                            -- 🔥 Multi-upgrade Damage units แบบปกติ
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
                        end  -- ปิด if lichKingMaxed
                        
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

-- ===== AUTO REPLAY SYSTEM (ISOLATED SCOPE) =====
-- _G.AutoReplay_ExecuteVote = nil

-- task.spawn(function()
--     local AutoReplayState = {
--         LastVoteTime = 0,
--         VoteCooldown = 3,
--         Enabled = true,
--         VoteEvent = nil
--     }
    
--     pcall(function()
--         AutoReplayState.VoteEvent = ReplicatedStorage:FindFirstChild("Networking")
--             and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
--             and ReplicatedStorage.Networking.EndScreen:FindFirstChild("VoteEvent")
--     end)
    
--     local function AutoVoteReplay()
--         if not AutoReplayState.Enabled then return end
--         if not AutoReplayState.VoteEvent then return end
        
--         local now = tick()
--         if now - AutoReplayState.LastVoteTime < AutoReplayState.VoteCooldown then return end
--         AutoReplayState.LastVoteTime = now
        
--         pcall(function()
--             AutoReplayState.VoteEvent:FireServer("Retry")
--             print("[AutoReplay] 🔄 Voted Retry via VoteEvent")
--         end)
--     end
    
--     _G.AutoReplay_ExecuteVote = AutoVoteReplay
    
--     pcall(function()
--         local ShowEndScreenEvent = ReplicatedStorage:FindFirstChild("Networking")
--             and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
--             and ReplicatedStorage.Networking.EndScreen:FindFirstChild("ShowEndScreenEvent")
        
--         if ShowEndScreenEvent then
--             ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
--                 print("[AutoReplay] 📺 EndScreen detected! Status:", Results and Results.Status or "Unknown")
--                 task.delay(2, AutoVoteReplay)
--                 task.delay(5, AutoVoteReplay)
--             end)
--             print("[AutoReplay] ✅ ShowEndScreenEvent connected!")
--         end
--     end)
-- end)

-- local function AutoVoteReplay()
--     if _G.AutoReplay_ExecuteVote then
--         _G.AutoReplay_ExecuteVote()
--     end
-- end

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

-- ⭐⭐⭐ GLOBAL EXPORTS สำหรับ AbilitySystem.lua (Caloric Stone Sync)
_G.GetBestPlacementPosition = GetBestPlacementPosition
_G.GetVerifiedPlacementPosition = GetVerifiedPlacementPosition
_G.VerifyPositionInRange = VerifyPositionInRange
_G.GetUnitRange = GetUnitRange
_G.GetMapPath = GetMapPath
_G.GetActiveUnits = GetActiveUnits
_G.CanPlaceAtPosition = CanPlaceAtPosition
_G.GetGamePhase = GetGamePhase
_G.GetYen = GetYen

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
    GetVerifiedPlacementPosition = GetVerifiedPlacementPosition,  -- ⭐ NEW: ตำแหน่งที่ verified แล้ว
    VerifyPositionInRange = VerifyPositionInRange,                 -- ⭐ NEW: เช็คว่าตีถึง path
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