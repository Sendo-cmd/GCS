repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                    ABILITY SYSTEM V3.0 (OPTIMIZED)                    ║
    ║  🎯 ป้องกัน SPAM: ไม่ส่ง FireServer ซ้ำสำหรับ Auto abilities         ║
    ║  ✅ Auto Detection: เช็คสถานะ Auto ก่อนใช้ ability                    ║
    ║  ⏱️ Special Cooldowns: Racing(5s), Auto(10s), Element(15s), Item(30s) ║
    ╚═══════════════════════════════════════════════════════════════════════╝
]]

-- ===== SERVICES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local plr = game:GetService("Players").LocalPlayer

-- ===== GLOBAL REFERENCES =====
_G.APSkill = _G.APSkill or {
    Enabled = true,
    WorldItemUsedThisMatch = false,
    ForcedAbilityMode = false,
    AbilityLastUsed = {},
    AbilityUsedOnce = {},
    -- ⭐ เพิ่ม Cooldown ป้องกัน spam สำหรับ abilities บางตัว
    SpecialCooldowns = {
        ["Racing"] = 5,           -- Horsegirl Racing - 5 วินาที
        ["Auto"] = 10,            -- Auto Toggle abilities - 10 วินาที
        ["Swap"] = 10,            -- Swap abilities - 10 วินาที
        ["Element"] = 15,         -- Lich Element Selection - 15 วินาที
        ["WorldItem"] = 30,       -- World Items - 30 วินาที
    },
    -- ⭐⭐⭐ AUTO-PLACEMENT SYSTEM - เก็บข้อมูล placement ที่รอดำเนินการ
    PendingPlacement = {},
    PlacementHookInstalled = false
}

-- ===== ABILITY TRACKING =====
local AbilityLastUsed = _G.APSkill.AbilityLastUsed
local AbilityUsedOnce = _G.APSkill.AbilityUsedOnce
local CaloricCloneUnits = {}
local LastAutoSkillCheck = 0
local AUTO_SKILL_CHECK_INTERVAL = 0.1  -- เร็วขึ้น!

-- ⭐⭐⭐ LICH SPELL TRACKING (ป้องกัน spam)
local LichSpellLastChange = 0           -- tick() ของครั้งสุดท้ายที่เปลี่ยน spell
local LichSpellLastWave = 0             -- wave ของครั้งสุดท้ายที่เปลี่ยน
local LichSpellCurrentSet = {}          -- spell IDs ที่เลือกอยู่ตอนนี้
local LICH_SPELL_CHANGE_INTERVAL = 3    -- เปลี่ยนได้ทุก 3 waves
local LICH_SPELL_COOLDOWN = 30          -- cooldown 30 วินาที

-- ===== MODULE DEPENDENCIES =====
local ClientUnitHandler, ClientEnemyHandler, UnitEvent, AbilityEvent
local CaloricStoneEvent, WorldItemEvent, EntityIDHandler
local UnitsData, OwnedUnitsHandler, ActiveAbilityData, UnitsModule
local KoguroDimensionEvent, HorsegirlRacingEvent
local LichSpellsEvent, LichData, UnitElementsData
local RealityRewriteEvent, RealityRewriteData, NumberPadEvent
local Networking

-- ⭐⭐⭐ FIX: โหลด Modules ตาม AutoPlayBase copy 2 (StarterPlayer!)
local function LoadModules()
    -- ⭐ แสดง log เฉพาะครั้งแรก
    if not _G.APSkill.ModulesLoaded then
        print("[AbilitySystem] 🔧 Loading Modules...")
    end
    
    -- Core Networking
    pcall(function()
        Networking = ReplicatedStorage:WaitForChild("Networking", 5)
        if Networking then
            -- ⭐⭐⭐ FIX: โหลด UnitEvent แบบเดียวกับ AutoPlayBase copy 2
            UnitEvent = Networking:WaitForChild("UnitEvent", 3)
            
            AbilityEvent = Networking:FindFirstChild("AbilityEvent")
            CaloricStoneEvent = Networking:FindFirstChild("CaloricStoneEvent")
            WorldItemEvent = Networking:FindFirstChild("WorldItemEvent")
        end
    end)
    
    -- ⭐ FIX: ClientUnitHandler จาก StarterPlayer (ตาม Decom.lua & AutoPlayBase copy 2)
    pcall(function()
        ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler)
    end)
    
    -- ClientEnemyHandler
    pcall(function()
        ClientEnemyHandler = require(StarterPlayer.Modules.Gameplay.ClientEnemyHandler)
    end)
    
    -- EntityIDHandler
    pcall(function()
        EntityIDHandler = require(ReplicatedStorage.Modules.Data.Entities.EntityIDHandler)
    end)
    
    -- UnitsData (ตาม AutoPlayBase copy 2)
    pcall(function()
        UnitsData = require(ReplicatedStorage.Modules.Data.Entities.Units)
    end)
    
    -- ActiveAbilityData
    pcall(function()
        ActiveAbilityData = require(ReplicatedStorage.Modules.Data.ActiveAbilityData)
    end)
    
    -- OwnedUnitsHandler
    pcall(function()
        OwnedUnitsHandler = require(StarterPlayer.Modules.Gameplay.Units.OwnedUnitsHandler)
    end)
    
    -- UnitsModule (HUD)
    pcall(function()
        UnitsModule = require(StarterPlayer.Modules.Interface.Loader.HUD.Units)
    end)
    
    -- ⭐ แสดง summary เฉพาะครั้งแรก
    if not _G.APSkill.ModulesLoaded then
        print("[AbilitySystem] ━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(string.format("[AbilitySystem]   ClientUnitHandler: %s", ClientUnitHandler and "✅" or "❌"))
        print(string.format("[AbilitySystem]   ClientEnemyHandler: %s", ClientEnemyHandler and "✅" or "❌"))
        print(string.format("[AbilitySystem]   UnitEvent: %s", UnitEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   AbilityEvent: %s", AbilityEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   EntityIDHandler: %s", EntityIDHandler and "✅" or "❌"))
        print(string.format("[AbilitySystem]   UnitsData: %s", UnitsData and "✅" or "❌"))
        print(string.format("[AbilitySystem]   OwnedUnitsHandler: %s", OwnedUnitsHandler and "✅" or "❌"))
        print(string.format("[AbilitySystem]   ActiveAbilityData: %s", ActiveAbilityData and "✅" or "❌"))
        print("[AbilitySystem] ━━━━━━━━━━━━━━━━━━━━━━━━━━")
        _G.APSkill.ModulesLoaded = true
    end
end

LoadModules()

-- ===== HELPER FUNCTIONS =====
local function GetYen()
    local yen = 0
    
    -- ⭐ วิธี 1: หา Cash จาก HUD
    pcall(function()
        local cashText = plr.PlayerGui.HUD.Cash.CashAmount.Text
        if cashText then
            local cleaned = cashText:gsub("[^0-9]", "")
            yen = tonumber(cleaned) or 0
        end
    end)
    
    if yen > 0 then return yen end
    
    -- ⭐ วิธี 2: หา Yen จาก HUD (อีกชื่อ)
    pcall(function()
        local yenText = plr.PlayerGui.HUD.Yen.Amount.Text
        if yenText then
            local cleaned = yenText:gsub("[^0-9]", "")
            yen = tonumber(cleaned) or 0
        end
    end)
    
    if yen > 0 then return yen end
    
    -- ⭐ วิธี 3: หาจาก _G.GetYen ถ้ามี
    pcall(function()
        if _G.GetYen then
            yen = _G.GetYen() or 0
        end
    end)
    
    if yen > 0 then return yen end
    
    -- ⭐ วิธี 4: หาจาก PlayerYenHandler
    pcall(function()
        local PlayerYenHandler = require(game:GetService("StarterPlayer").Modules.Gameplay.PlayerYenHandler)
        if PlayerYenHandler and PlayerYenHandler.GetYen then
            yen = PlayerYenHandler:GetYen() or 0
        end
    end)
    
    -- ⭐ วิธี 5: ถ้าไม่มีเงินให้คืน infinity (ไม่ block Caloric Stone)
    if yen == 0 then
        -- print("[AbilitySystem] ⚠️ Cannot read Yen, assuming enough money")
        return 999999  -- คืนค่าสูงเพื่อไม่ block
    end
    
    return yen
end

local function GetWaveFromUI()
    local success, current, max = pcall(function()
        local wavesText = plr.PlayerGui.HUD.Map.WavesAmount.Text
        local stripped = wavesText:gsub("<[^>]*>", ""):gsub("&[^;]+;", "")
        
        -- ⭐ FIX: รองรับ infinity (∞) symbol
        local curr, maxWave = stripped:match("(%d+)%s*/%s*(%d+)")
        if not curr then
            -- ลอง match แบบ "Wave X/∞" หรือ "X/∞"
            curr = stripped:match("(%d+)%s*/%s*[∞∝]")
            if curr then
                return tonumber(curr) or 0, 999  -- ∞ = 999
            end
            -- ลอง match เฉพาะตัวเลขแรก
            curr = stripped:match("(%d+)")
            return tonumber(curr) or 0, 999
        end
        return tonumber(curr) or 0, tonumber(maxWave) or 999
    end)
    if success then
        return current, max
    end
    return 0, 999
end

local function GetGamePhase()
    local CurrentWave, MaxWave = GetWaveFromUI()
    if not MaxWave or MaxWave == 0 then return "early" end
    local progress = CurrentWave / MaxWave
    if progress < 0.3 then return "early"
    elseif progress < 0.7 then return "mid"
    else return "late" end
end

local function GetFrontmostEnemy()
    if not ClientEnemyHandler or not ClientEnemyHandler._ActiveEnemies then return nil end
    local closest = nil
    local minDist = math.huge
    pcall(function()
        local gatePos = workspace.Map.Gate.Position
        for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
            if enemy.Position then
                local dist = (enemy.Position - gatePos).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = enemy
                end
            end
        end
    end)
    return closest
end

-- Import placement functions from AutoPlayBase (will be called via _G)
local function GetBestPlacementPosition(range, phase, unitName, unitData)
    if _G.GetBestPlacementPosition then
        return _G.GetBestPlacementPosition(range, phase, unitName, unitData)
    end
    return nil
end

local function GetBestFrontPosition(range)
    if _G.GetBestFrontPosition then
        return _G.GetBestFrontPosition(range)
    end
    return nil
end

local function IsIncomeUnit(name, data)
    if _G.IsIncomeUnit then
        return _G.IsIncomeUnit(name, data)
    end
    return false
end

local function IsBuffUnit(name, data)
    if _G.IsBuffUnit then
        return _G.IsBuffUnit(name, data)
    end
    return false
end

local function IsNormalMode()
    local isChallenge = workspace:GetAttribute("IsChallenge") or false
    local isOdyssey = workspace:GetAttribute("IsOdyssey") or false
    local isWorldlines = workspace:GetAttribute("IsWorldlines") or false
    local isPortal = workspace:GetAttribute("IsPortal") or false
    return not isChallenge and not isOdyssey and not isWorldlines and not isPortal
end

local StageAnalysisCache = {}
local function AnalyzeStageType()
    if StageAnalysisCache.Type then
        return StageAnalysisCache.Type
    end
    
    local CurrentWave, MaxWave = GetWaveFromUI()
    
    local stageInfo = {
        Type = "Normal",
        MaxWave = MaxWave or 50,
        HasBoss = false,
        IsLongStage = false,
        IsShortStage = false,
        RequiresRepulse = false,
        RequiresDPS = true,
        IsNormalMode = IsNormalMode()
    }
    
    if stageInfo.MaxWave >= 50 then
        stageInfo.IsLongStage = true
    elseif stageInfo.MaxWave <= 30 then
        stageInfo.IsShortStage = true
    end
    
    StageAnalysisCache.Type = stageInfo.Type
    StageAnalysisCache.Info = stageInfo
    
    return stageInfo
end

-- ===== LOAD SPECIAL ABILITY EVENTS =====
_G.APEvents = _G.APEvents or {
    KoguroAutoEnabled = {},
    KoguroDomainActive = {},  -- ⭐ NEW: Track ว่า Koguro domain กำลัง active อยู่
    AutoSwapEnabled = {},
    AUTO_SWAP_UNITS = {}  -- ⭐ เปลี่ยนเป็น empty table - จะ auto-detect แทน
}

local KoguroAutoEnabled = _G.APEvents.KoguroAutoEnabled
local KoguroDomainActive = _G.APEvents.KoguroDomainActive
local AUTO_SWAP_UNITS = _G.APEvents.AUTO_SWAP_UNITS
local AutoSwapEnabled = _G.APEvents.AutoSwapEnabled

-- ⭐ Debug: แสดง Events ทั้งหมดที่มีใน Networking
local function DebugNetworkingEvents()
    print("[AbilitySystem] 🔍 Scanning Networking Events...")
    
    pcall(function()
        for _, child in pairs(Networking:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local path = child:GetFullName():gsub("ReplicatedStorage%.Networking%.", "")
                if path:lower():find("teleport") or path:lower():find("placement") or 
                   path:lower():find("misc") or path:lower():find("ability") then
                    print(string.format("[AbilitySystem]   Found: %s (%s)", path, child.ClassName))
                end
            end
        end
    end)
end

local function LoadSpecialAbilityEvents()
    pcall(function()
        KoguroDimensionEvent = Networking.Units["Update 6.5"].Koguro_DomainEvent
        if KoguroDimensionEvent then
            KoguroDimensionEvent.OnClientEvent:Connect(function(action, ...)
                if action == "SetAutoEnabled" then
                    local args = {...}
                    local guid = args[1]
                    local autoEnabled = args[2]
                    
                    if guid and autoEnabled ~= nil then
                        _G.APEvents.KoguroAutoEnabled[guid] = autoEnabled
                        -- ⭐ แสดง log เฉพาะเมื่อมีการเปลี่ยนแปลง
                    end
                end
            end)
        end
    end)
    
    pcall(function()
        HorsegirlRacingEvent = Networking.Units["Update 9.5"].AutoUpgradeHorsegirl
    end)
    
    pcall(function()
        _G.HorsegirlSelectEvent = Networking.Units["Update 9.5"].SelectHorsegirl or
                                  Networking.Units.SelectHorsegirl or
                                  Networking.ClientListeners.Units.HorsegirlSelect
    end)
    
    pcall(function()
        _G.RequestSwapEvent = Networking.Passives.RequestSwap
        _G.ToggleAutoSwapEvent = Networking.Passives.ToggleAutoSwapEvent
    end)
    
    pcall(function()
        _G.AutoAbilityEvent = Networking.ClientListeners.Units.AutoAbilityEvent or
                             Networking.Units.AutoAbilityEvent
        print("[AbilitySystem] 🔧 AutoAbilityEvent loaded:", _G.AutoAbilityEvent and "✅" or "❌")
    end)
    
    pcall(function()
        WorldItemEvent = Networking.Units["Update 9.5"].UseWorldItem
        print("[AbilitySystem] 🔧 WorldItemEvent loaded:", WorldItemEvent and "✅" or "❌")
    end)
    
    pcall(function()
        CaloricStoneEvent = Networking.Units["Update 9.5"].CaloricStone or
                           Networking.Units.CaloricStone
        print("[AbilitySystem] 🔧 CaloricStoneEvent loaded:", CaloricStoneEvent and "✅" or "❌")
    end)
    
    pcall(function()
        _G.CastHollowsephSpellEvent = Networking.Units["Update 9.0"].CastHollowsephSpell
        print("[AbilitySystem] 🔧 CastHollowsephSpellEvent loaded:", _G.CastHollowsephSpellEvent and "✅" or "❌")
    end)
    
    pcall(function()
        _G.VoteEvent = Networking.EndScreen.VoteEvent
    end)
    
    pcall(function()
        _G.PortalPlayEvent = Networking.PortalPlayEvent
    end)
    
    pcall(function()
        _G.TeleportEvent = Networking.TeleportEvent
        print("[AbilitySystem] 🔧 TeleportEvent loaded:", _G.TeleportEvent and "✅" or "❌")
    end)
    
    -- ⭐ เรียก Debug function เพื่อหา Events ที่เกี่ยวข้อง
    if not _G.APSkill.EventsScanned then
        DebugNetworkingEvents()
        _G.APSkill.EventsScanned = true
    end
    
    pcall(function()
        LichSpellsEvent = Networking.Units["Update 9.5"].ConfirmLichSpells
        LichData = require(ReplicatedStorage.Modules.Data.Units.LichData)
        UnitElementsData = require(ReplicatedStorage.Modules.Data.Entities.UnitElementsData)
    end)
    
    pcall(function()
        RealityRewriteEvent = Networking.Units["Update 9.0"].RealityRewrite
        RealityRewriteData = require(ReplicatedStorage.Modules.Data.Units.RealityRewriteData)
    end)
    
    -- NumberPad Event (Happy Factory)
    pcall(function()
        NumberPadEvent = Networking.StageMechanics and Networking.StageMechanics:FindFirstChild("NumberPad")
    end)
    
    -- ⭐ แสดง summary เฉพาะครั้งแรก
    if not _G.APSkill.EventsLoaded then
        print("[AbilitySystem] 🔧 Special Events Loaded")
        print(string.format("[AbilitySystem]   KoguroDimensionEvent: %s", KoguroDimensionEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   LichSpellsEvent: %s", LichSpellsEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   RealityRewriteEvent: %s", RealityRewriteEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   WorldItemEvent: %s", WorldItemEvent and "✅" or "❌"))
        print(string.format("[AbilitySystem]   CaloricStoneEvent: %s", CaloricStoneEvent and "✅" or "❌"))
        _G.APSkill.EventsLoaded = true
    end
end

LoadSpecialAbilityEvents()

-- ===== AUTO-PLACEMENT HOOK SYSTEM =====
--[[
    ⭐⭐⭐ ระบบ Hook สำหรับ Auto-Placement
    ใช้งานร่วมกับ MiscPlacementHandler.StartPlacement() 
    เพื่อ auto-place abilities โดยไม่ต้องให้ผู้เล่นคลิก
    
    Contexts ที่รองรับ:
    - Rogita: Instant Teleportation
    - Friran: Wayward Journey (FriranStart → FriranEnd)
    - Ability: Monkey King Fur, Valentine This is Another Me
    - EquipForgeWeapon: Smith John weapon selection
    - SelectUnit: Master Chef Grand Feast
    - Dabo81: Track placement
    - Berserker: Track placement
]]

local function InstallPlacementHook()
    if _G.APSkill.PlacementHookInstalled then
        return
    end
    
    local RequestMiscPlacement = Networking and Networking:FindFirstChild("RequestMiscPlacement")
    if not RequestMiscPlacement then
        print("[AbilitySystem] ❌ RequestMiscPlacement event not found")
        return
    end
    
    print("[AbilitySystem] 🔧 Installing Auto-Placement Hooks...")
    
    -- ⭐⭐⭐ วิธีที่ง่ายที่สุด: Monitor OnClientEvent และส่ง position โดยตรง!
    -- ไม่ต้อง hook อะไรเลย แค่รอฟังแล้วตอบกลับ
    RequestMiscPlacement.OnClientEvent:Connect(function(config)
        local context = config and config.Context
        local guid = config and config.GUID
        
        print(string.format("[AbilitySystem] 📥 OnClientEvent received - Context: %s, GUID: %s", 
            tostring(context), tostring(guid)))
        
        -- ⭐⭐⭐ DEBUG: แสดงทุก key ใน config
        if config and type(config) == "table" then
            for k, v in pairs(config) do
                print(string.format("[AbilitySystem]   → config.%s = %s", tostring(k), tostring(v)))
            end
        end
        
        -- ตรวจสอบว่ามี PendingPlacement หรือไม่
        local pendingData = nil
        
        -- ⭐⭐⭐ เช็คหลาย context ที่เป็นไปได้
        if context then
            pendingData = _G.APSkill.PendingPlacement[context]
        end
        
        -- ถ้าไม่เจอ context ตรง → ลองหาจาก guid
        if not pendingData and guid then
            for ctx, data in pairs(_G.APSkill.PendingPlacement) do
                if data.GUID == guid then
                    pendingData = data
                    context = ctx
                    break
                end
            end
        end
        
        -- ⭐⭐⭐ ถ้ายังไม่เจอ → ลองใช้ PendingPlacement ตัวแรกที่มี
        if not pendingData then
            for ctx, data in pairs(_G.APSkill.PendingPlacement) do
                if data and data.TargetPos then
                    pendingData = data
                    context = ctx
                    print(string.format("[AbilitySystem] 🔍 Using first available PendingPlacement: %s", ctx))
                    break
                end
            end
        end
        
        if pendingData then
            print(string.format("[AbilitySystem] 🎯 Auto-Placement detected: %s", tostring(context)))
            
            local targetPos = pendingData.TargetPos
            local nextContext = pendingData.NextContext
            local nextPos = pendingData.NextPos
            
            -- ⭐⭐⭐ VALIDATION: ห้ามส่ง Vector3.zero!
            if not targetPos or targetPos == Vector3.new(0, 0, 0) then
                print("[AbilitySystem] ❌ Invalid position (0,0,0)! Aborting placement.")
                _G.APSkill.PendingPlacement[context] = nil
                return
            end
            
            -- ล้าง pending data
            _G.APSkill.PendingPlacement[context] = nil
            
            -- ⭐⭐ สำหรับ Friran: เตรียม placement ครั้งต่อไป
            if nextContext and nextPos then
                print(string.format("[AbilitySystem] 📌 Next placement ready: %s", nextContext))
                _G.APSkill.PendingPlacement[nextContext] = {
                    TargetPos = nextPos,
                    GUID = guid
                }
            end
            
            print(string.format("[AbilitySystem] ✅ Sending position: (%.1f, %.1f, %.1f)", 
                targetPos.X, targetPos.Y, targetPos.Z))
            
            -- ⭐⭐⭐ ส่ง position โดยตรง!
            task.spawn(function()
                task.wait(0.3)  -- รอให้ game setup placement
                
                local sendSuccess, sendError = pcall(function()
                    RequestMiscPlacement:FireServer(guid, targetPos)
                end)
                
                if sendSuccess then
                    print("[AbilitySystem] 📤 Position sent successfully!")
                else
                    print(string.format("[AbilitySystem] ❌ Failed to send: %s", tostring(sendError)))
                end
            end)
        else
            -- Debug info
            print(string.format("[AbilitySystem] ℹ️ No PendingPlacement found for context: %s", tostring(context)))
            
            -- แสดง PendingPlacement ที่มีอยู่
            local count = 0
            for ctx, data in pairs(_G.APSkill.PendingPlacement) do
                count = count + 1
                print(string.format("[AbilitySystem]   → Pending: %s", ctx))
            end
            if count == 0 then
                print("[AbilitySystem]   → No pending placements registered")
            end
        end
    end)
    
    -- ⭐⭐⭐ HOOK 2: UnitEvent สำหรับ Caloric Stone placement
    -- Caloric Stone ใช้ UnitPlacementHandler.Start() ซึ่งรอให้ผู้เล่นคลิก
    -- เราต้อง simulate การคลิกโดยส่ง Render event โดยตรง
    local UnitEvent = Networking:FindFirstChild("UnitEvent")
    if UnitEvent then
        -- Monitor UnitEvent.OnClientEvent สำหรับ placement requests
        UnitEvent.OnClientEvent:Connect(function(action, ...)
            local args = {...}
            print(string.format("[AbilitySystem] 📥 UnitEvent.OnClientEvent - Action: %s", tostring(action)))
            
            -- ถ้ามี Caloric Stone pending → ส่ง Render ทันที
            local caloricData = _G.APSkill.PendingPlacement["CaloricStone"] or _G.APSkill.PendingPlacement["Ability"]
            if caloricData and caloricData.TargetPos then
                print("[AbilitySystem] 🎯 Caloric Stone placement detected via UnitEvent!")
                
                local targetPos = caloricData.TargetPos
                local unitName = caloricData.UnitName
                local sourceGuid = caloricData.GUID
                
                -- ล้าง pending
                _G.APSkill.PendingPlacement["CaloricStone"] = nil
                _G.APSkill.PendingPlacement["Ability"] = nil
                
                task.spawn(function()
                    task.wait(0.5)
                    
                    print(string.format("[AbilitySystem] 📤 Sending Render for %s at (%.1f, %.1f, %.1f)", 
                        tostring(unitName), targetPos.X, targetPos.Y, targetPos.Z))
                    
                    pcall(function()
                        UnitEvent:FireServer("Render", {
                            unitName or "Unknown",
                            0,           -- ID (จะถูก resolve โดย server)
                            targetPos,
                            0            -- Rotation
                        }, {
                            FromUnitGUID = sourceGuid
                        })
                    end)
                    
                    print("[AbilitySystem] ✅ Caloric Clone Render sent!")
                end)
            end
        end)
        print("[AbilitySystem] 📌 Also listening to: UnitEvent.OnClientEvent")
    end
    
    _G.APSkill.PlacementHookInstalled = true
    print("[AbilitySystem] ✅ Auto-Placement Monitor Installed!")
    print("[AbilitySystem] 📌 Listening to: RequestMiscPlacement.OnClientEvent")
end

-- เรียก InstallPlacementHook เมื่อ game loaded และ Networking พร้อม
task.spawn(function()
    -- รอให้ LoadModules เสร็จก่อน
    repeat task.wait(0.5) until Networking ~= nil
    task.wait(1)  -- รอเพิ่มเพื่อให้แน่ใจว่า Networking โหลดเสร็จสมบูรณ์
    
    print("[AbilitySystem] 🔄 Ready to install placement hook...")
    InstallPlacementHook()
end)

-- ===== REALITY REWRITE ENEMY ANALYSIS =====
local REALITY_REWRITE_STATUSES = {
    "Burn", "Bleed", "Scorched", "Freeze", "Slow", "Stun", "Rupture", "Wounded", "Bubbled"
}

local LastEnemyAnalysisTime = 0
local LastEnemyAnalysisResult = "Burn"
local ENEMY_ANALYSIS_COOLDOWN = 2 -- วิเคราะห์ทุก 2 วินาที

local function AnalyzeEnemiesForStatus()
    -- ⭐ Cache result เพื่อลด spam การวิเคราะห์
    local now = tick()
    if now - LastEnemyAnalysisTime < ENEMY_ANALYSIS_COOLDOWN then
        return LastEnemyAnalysisResult
    end
    
    LastEnemyAnalysisTime = now
    local enemies = _G.GetEnemies and _G.GetEnemies() or {}
    if not enemies or #enemies == 0 then
        return "Burn"
    end
    
    local analysis = {
        totalEnemies = 0,
        fastEnemies = 0,
        tankEnemies = 0,
        flyingEnemies = 0,
        avgSpeed = 0,
        avgHealth = 0,
        hasBoss = false,
        hasSlowImmunity = false,
        hasStunImmunity = false,
        hasBurnImmunity = false,
        hasFreezeImmunity = false,
        hasBleedImmunity = false,
        hasRegen = false,
        hasShield = false,
        immunities = {},
        currentStatuses = {}
    }
    
    local totalHealth = 0
    local totalSpeed = 0
    
    for _, enemy in pairs(enemies) do
        if enemy and enemy ~= "None" then
            analysis.totalEnemies = analysis.totalEnemies + 1
            
            local health = enemy.Health or enemy.MaxHealth or 0
            totalHealth = totalHealth + health
            if health > 10000 then
                analysis.tankEnemies = analysis.tankEnemies + 1
            end
            
            local speed = enemy.Speed or 0
            totalSpeed = totalSpeed + speed
            if speed > 16 then
                analysis.fastEnemies = analysis.fastEnemies + 1
            end
            
            if enemy.IsFlying then
                analysis.flyingEnemies = analysis.flyingEnemies + 1
            end
            
            if _G.IsBossEnemy and _G.IsBossEnemy(enemy) then
                analysis.hasBoss = true
            end
            
            local enemyData = enemy.Data or enemy
            if enemyData.Mutators then
                for _, mutator in pairs(enemyData.Mutators) do
                    local mutatorName = type(mutator) == "string" and mutator or (mutator.Name or "")
                    local mutatorLower = string.lower(mutatorName)
                    
                    if mutatorLower:find("slow") and mutatorLower:find("immun") then
                        analysis.hasSlowImmunity = true
                    elseif mutatorLower:find("stun") and mutatorLower:find("immun") then
                        analysis.hasStunImmunity = true
                    elseif mutatorLower:find("burn") and mutatorLower:find("immun") then
                        analysis.hasBurnImmunity = true
                    elseif mutatorLower:find("freeze") and mutatorLower:find("immun") then
                        analysis.hasFreezeImmunity = true
                    elseif mutatorLower:find("bleed") and mutatorLower:find("immun") then
                        analysis.hasBleedImmunity = true
                    elseif mutatorLower:find("regen") or mutatorLower:find("heal") then
                        analysis.hasRegen = true
                    elseif mutatorLower:find("shield") or mutatorLower:find("barrier") then
                        analysis.hasShield = true
                    end
                end
            end
        end
    end
    
    if analysis.totalEnemies > 0 then
        analysis.avgSpeed = totalSpeed / analysis.totalEnemies
        analysis.avgHealth = totalHealth / analysis.totalEnemies
    end
    
    local function isStatusEffective(statusName)
        if statusName == "Slow" and analysis.hasSlowImmunity then return false end
        if statusName == "Stun" and analysis.hasStunImmunity then return false end
        if statusName == "Burn" and analysis.hasBurnImmunity then return false end
        if statusName == "Freeze" and analysis.hasFreezeImmunity then return false end
        if statusName == "Bleed" and analysis.hasBleedImmunity then return false end
        return true
    end
    
    local selectedStatus = "Burn"
    
    if analysis.hasRegen and isStatusEffective("Burn") then
        selectedStatus = "Burn"
    elseif analysis.hasBoss and isStatusEffective("Rupture") then
        selectedStatus = "Rupture"
    elseif analysis.fastEnemies > analysis.totalEnemies * 0.5 and isStatusEffective("Slow") then
        selectedStatus = "Slow"
    elseif analysis.tankEnemies > 0 and isStatusEffective("Burn") then
        selectedStatus = "Burn"
    elseif isStatusEffective("Freeze") then
        selectedStatus = "Freeze"
    end
    
    -- ⭐ บันทึก cache
    LastEnemyAnalysisResult = selectedStatus
    return selectedStatus
end

-- ===== ABILITY ANALYSIS =====
local AbilityAnalysisCache = {}

local function AnalyzeAbility(abilityName)
    -- ⭐ Validate input
    if not abilityName or type(abilityName) ~= "string" or abilityName == "" then
        return {
            Name = "Unknown",
            Cooldown = 1.0,
            IsOneTime = false,
            IsBossOnly = false,
            MinWave = 0,
            NeedsTarget = false,
            Type = "Unknown",
            NeedsPlacement = false,
            NeedsUnitSelection = false,
            PlacementRange = 30,
            SelectionContext = nil,
            IsAutoAbility = true
        }
    end
    
    if AbilityAnalysisCache[abilityName] then
        return AbilityAnalysisCache[abilityName]
    end
    
    local abilityInfo = {
        Name = abilityName,
        Cooldown = 1.0,
        IsOneTime = false,
        IsBossOnly = false,
        MinWave = 0,
        NeedsTarget = false,
        Type = "Unknown",
        NeedsPlacement = false,
        NeedsUnitSelection = false,
        PlacementRange = 30,
        SelectionContext = nil,
        IsAutoAbility = true
    }
    
    if ActiveAbilityData and ActiveAbilityData.GetActiveAbilityDataFromName then
        local success, data = pcall(function()
            return ActiveAbilityData:GetActiveAbilityDataFromName(abilityName)
        end)
        
        if success and data then
            -- ⭐ Validate และใช้ค่า default ถ้า nil
            if data.Cooldown and type(data.Cooldown) == "number" then
                abilityInfo.Cooldown = math.max(data.Cooldown, 1.0)
            end
            if data.OneTime or data.IsOneTime or data.SingleUse then
                abilityInfo.IsOneTime = true
            end
            if data.BossOnly or data.Boss or data.RequiresBoss then
                abilityInfo.IsBossOnly = true
            end
            if data.MinWave or data.WaveRequirement then
                abilityInfo.MinWave = data.MinWave or data.WaveRequirement
            end
            if data.NeedsTarget or data.RequiresTarget or data.TargetRequired then
                abilityInfo.NeedsTarget = true
            end
            if data.NeedsPlacement or data.RequiresPlacement or data.NeedsPosition then
                abilityInfo.NeedsPlacement = true
            end
            if data.NeedsUnitSelection or data.RequiresUnitSelection or data.SelectUnit then
                abilityInfo.NeedsUnitSelection = true
            end
        end
    end
    
    local lower = abilityName:lower()
    
    local placementKeywords = {
        "teleport", "warp", "blink", "portal",
        "spawn", "summon", "arise", "army",
        "clone", "duplicate", "copy",
        "place", "deploy", "position",
        "dimension", "zone", "area"
    }
    
    for _, keyword in ipairs(placementKeywords) do
        if lower:find(keyword) then
            abilityInfo.NeedsPlacement = true
            break
        end
    end
    
    local selectionKeywords = {
        "buff", "enhance", "empower",
        "transfer", "give", "grant",
        "equip", "forge", "masterwork", "craft",
        "caloric", "stone"
    }
    
    for _, keyword in ipairs(selectionKeywords) do
        if lower:find(keyword) then
            abilityInfo.NeedsUnitSelection = true
            break
        end
    end
    
    abilityInfo.IsWorldItem = lower:find("world item") or lower:find("world items") or lower:find("caloric") or lower:find("ouroboros")
    abilityInfo.IsTeleport = lower:find("teleport") or lower:find("instant")
    abilityInfo.IsSpawnAlien = lower:find("emperor") or lower:find("army")
    abilityInfo.IsClone = lower:find("fur") or lower:find("clone") or lower:find("another me")
    abilityInfo.IsHorsegirl = lower:find("horsegirl") or lower:find("horse") or lower:find("racing")
    abilityInfo.IsHollowseph = lower:find("embrace") or lower:find("shade strike") or lower:find("ascending dark") or lower:find("dream nail") or lower:find("void")
    abilityInfo.IsChargeAbility = lower:find("charge") or lower:find("heat") or lower:find("overload") or lower:find("beam")
    abilityInfo.IsMiniGame = lower:find("rock") or lower:find("rhythm") or lower:find("hell is frozen")
    
    AbilityAnalysisCache[abilityName] = abilityInfo
    return abilityInfo
end

-- ===== FORWARD DECLARATIONS FOR AUTO ABILITY UI =====
-- ⭐⭐⭐ ตาม Decom: AutoAbilityEvent:FireServer("Enable", unitGUID, abilityName)

-- เช็คว่า ability มี Auto UI หรือไม่ (จาก ActiveAbilityData)
local function HasAutoUseUI(abilityName)
    if not ActiveAbilityData then return false end
    
    local abilityData = nil
    pcall(function()
        abilityData = ActiveAbilityData:GetActiveAbilityDataFromName(abilityName)
    end)
    
    if not abilityData then return false end
    
    local canAutoUse = abilityData.CanAutoUse
    if canAutoUse == nil then
        return true  -- nil = default = มี
    end
    return canAutoUse == true
end

-- เช็คว่า Auto เปิดอยู่หรือยัง (จาก unit.AutoUseAbilities)
local function IsAutoAbilityEnabled(unit, abilityName)
    if not unit then return false end
    
    local autoUseAbilities = unit.AutoUseAbilities
    if not autoUseAbilities or type(autoUseAbilities) ~= "table" then
        return false
    end
    
    for _, ability in ipairs(autoUseAbilities) do
        if ability == abilityName then
            return true
        end
    end
    
    return false
end

-- เปิด Auto ผ่าน AutoAbilityEvent ของเกม
local function EnableAutoAbilityUI(unit, abilityName)
    local guid = unit.UniqueIdentifier or unit.GUID
    
    if IsAutoAbilityEnabled(unit, abilityName) then
        return true
    end
    
    local AutoAbilityEvent = _G.AutoAbilityEvent
    if not AutoAbilityEvent then
        pcall(function()
            AutoAbilityEvent = Networking.ClientListeners.Units.AutoAbilityEvent
        end)
    end
    
    if AutoAbilityEvent then
        local success, err = pcall(function()
            AutoAbilityEvent:FireServer("Enable", guid, abilityName)
        end)
        
        if success then
            print(string.format("[AbilitySystem] ✅ Auto UI enabled: %s → %s", unit.Name or "Unit", abilityName))
            return true
        end
    end
    
    return false
end

local function CanUseAbility(unit, abilityName, abilityInfo)
    if not unit or not abilityName then
        return false, "Invalid unit or abilityName"
    end
    
    -- สร้าง abilityInfo เปล่าถ้าไม่มี
    abilityInfo = abilityInfo or {}
    
    if not _G.APSkill or (not _G.APSkill.Enabled and not _G.APSkill.ForcedAbilityMode) then
        return false, "APSkill disabled"
    end
    
    local guid = unit.UniqueIdentifier or unit.GUID
    local abilityKey = tostring(guid) .. "_" .. tostring(abilityName)
    local unitName = unit.Name or ""
    
    -- ⭐⭐⭐ AUTO UI CHECK: ถ้า ability มี Auto UI และเปิดอยู่แล้ว → skip
    local hasAutoUI = HasAutoUseUI(abilityName)
    if hasAutoUI and IsAutoAbilityEnabled(unit, abilityName) then
        -- Auto เปิดอยู่แล้ว → update cooldown และ skip
        AbilityLastUsed[abilityKey] = tick()
        return false, "Auto UI already enabled"
    end
    
    -- ⭐⭐⭐ SPECIAL CHECKS (ตาม AutoPlayBase copy 2) ⭐⭐⭐
    
    -- Koguro Dimensions: ⭐⭐⭐ เช็ค Auto ของเกม + Boss Only
    if unitName and unitName:find("Koguro") and abilityName and abilityName:find("Dimension") then
        -- ⭐ เช็คว่าเกมเปิด Auto อยู่แล้วหรือไม่
        local isAutoEnabled = _G.APEvents.KoguroAutoEnabled[guid]
        if isAutoEnabled then
            return false, "Koguro Auto already enabled by game"
        end
        
        -- ⭐ เช็คว่า domain กำลัง active อยู่หรือไม่
        local isDomainActive = _G.APEvents.KoguroDomainActive[guid]
        if isDomainActive then
            return false, "Domain already active"
        end
        
        -- ⭐ Boss Only: เช็คว่ามี Boss อยู่ในระยะหรือไม่
        local hasBossInRange = false
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.IsBoss then
                    hasBossInRange = true
                    break
                end
            end
        end
        
        if not hasBossInRange then
            return false, "Koguro - Wait for Boss"
        end
        
        return true, "OK"
    end
    
    -- Arcane Knowledge (Lich): เปลี่ยนได้ทุก 3 waves หรือ Boss wave
    if unitName and unitName:find("Lich") and abilityName and abilityName:find("Arcane Knowledge") then
        local CurrentWave, MaxWave = GetWaveFromUI()
        local wavesSinceLastChange = CurrentWave - LichSpellLastWave
        local timeSinceLastChange = tick() - LichSpellLastChange
        
        -- เช็คว่ามี Boss หรือไม่
        local hasBoss = false
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.IsBoss then
                    hasBoss = true
                    break
                end
            end
        end
        
        -- อนุญาตเปลี่ยนถ้า: ครั้งแรก, ทุก 3 waves, หรือมี Boss
        local canChange = (LichSpellLastWave == 0) or 
                          (wavesSinceLastChange >= LICH_SPELL_CHANGE_INTERVAL) or 
                          hasBoss
        
        -- เช็ค cooldown ด้วย
        if timeSinceLastChange < LICH_SPELL_COOLDOWN and LichSpellLastChange > 0 then
            canChange = false
        end
        
        if not canChange then
            return false, string.format("Lich Spells: Wait %d more waves (or Boss)", 
                LICH_SPELL_CHANGE_INTERVAL - wavesSinceLastChange)
        end
        
        return true, "OK"
    end
    
    -- The Goal of All Life is Death: OneTime + Boss/CriticalWave
    if abilityName and abilityName:find("The Goal of All Life is Death") then
        if AbilityUsedOnce[abilityKey] then
            -- ⭐ FIX: Update cooldown เพื่อป้องกัน spam logs
            AbilityLastUsed[abilityKey] = tick()
            return false, "Already used (Starting Uses = 1)"
        end
        
        local hasBoss = false
        local CurrentWave, MaxWave = GetWaveFromUI()
        local isCriticalWave = (CurrentWave >= 45)
        
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.IsBoss then
                    hasBoss = true
                    break
                end
            end
        end
        
        if not hasBoss and not isCriticalWave then
            return false, "Wait for Boss or Critical Wave (45+)"
        end
    end
    
    -- Reality Rewrite: OneTime + Need enemies
    if abilityName and abilityName:find("Reality Rewrite") then
        if AbilityUsedOnce[abilityKey] then
            -- ⭐ FIX: Update cooldown เพื่อป้องกัน spam logs
            AbilityLastUsed[abilityKey] = tick()
            return false, "Already used (OneTime)"
        end
        
        local hasEnemies = false
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _ in pairs(ClientEnemyHandler._ActiveEnemies) do
                hasEnemies = true
                break
            end
        end
        
        if not hasEnemies then
            return false, "No enemies found"
        end
    end
    
    -- ⭐⭐⭐ BOSS ONLY ABILITIES: abilities ที่ต้องมี Boss ในระยะ
    -- Beast Explosion, Wrathful Clash, Dimension abilities, Shadow Army, etc.
    local bossOnlyAbilities = {
        "Beast Explosion", "Wrathful Clash", "Dimension", 
        "Arise", "Shadow Army", "Domain", "Ultimate"
    }
    
    local isBossOnlyAbility = false
    for _, keyword in ipairs(bossOnlyAbilities) do
        if abilityName and abilityName:find(keyword) then
            isBossOnlyAbility = true
            break
        end
    end
    
    if isBossOnlyAbility or abilityInfo.IsBossOnly then
        local hasBossInRange = false
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.IsBoss then
                    hasBossInRange = true
                    break
                end
            end
        end
        
        if not hasBossInRange then
            return false, "Boss Only - Wait for Boss"
        end
    end
    
    -- Horsegirl Racing: Need actions
    if unitName and abilityName and unitName:find("Horsegirl") and abilityName:find("Racing") then
        local actions = unit.HorsegirlActions or 0
        if actions <= 0 then
            return false, "No actions left"
        end
    end
    
    -- God Arrives: Wait for mid-game
    if abilityName and abilityName:find("God Arrives") then
        local CurrentWave, MaxWave = GetWaveFromUI()
        local waveProgress = 0
        if MaxWave and MaxWave > 0 then
            waveProgress = (CurrentWave or 0) / MaxWave
        end
        
        if waveProgress < 0.2 then
            return false, "God Arrives - Wait for mid-game (wave > 20%)"
        end
    end
    
    -- ⭐ World Items (Caloric Stone, Ouroboros): เช็คว่าใช้แล้วหรือยัง
    if abilityInfo.IsWorldItem then
        if _G.APSkill and _G.APSkill.WorldItemUsedThisMatch then
            AbilityLastUsed[abilityKey] = tick()  -- Update cooldown to prevent spam
            return false, "World Item already used this match"
        end
        
        if AbilityUsedOnce[abilityKey] then
            AbilityLastUsed[abilityKey] = tick()  -- Update cooldown to prevent spam
            return false, "World Item already used"
        end
        
        -- ⭐⭐⭐ FIX: ไม่ใช้ World Item ตอน Emergency Mode
        local isEmergency = _G.APState and _G.APState.IsEmergency or false
        if isEmergency then
            return false, "World Item - Skip during Emergency Mode"
        end
        
        -- ⭐⭐⭐ FIX: เช็ค Wave 3+
        local CurrentWave, _ = GetWaveFromUI()
        if CurrentWave < 3 then
            return false, "World Item - Wait for Wave 3+"
        end
    end
    
    -- ⭐⭐⭐ GENERAL CHECKS ⭐⭐⭐
    
    -- 1. OneTime check
    if abilityInfo.IsOneTime and AbilityUsedOnce[abilityKey] then
        return false, "Already used (OneTime)"
    end
    
    -- 2. Cooldown check
    local lastUsed = AbilityLastUsed[abilityKey] or 0
    local elapsed = tick() - lastUsed
    local effectiveCooldown = abilityInfo.Cooldown or 1.0
    
    -- Validate cooldown values
    if type(effectiveCooldown) ~= "number" then
        effectiveCooldown = 1.0
    end
    if type(lastUsed) ~= "number" then
        lastUsed = 0
    end
    if type(elapsed) ~= "number" then
        elapsed = 0
    end
    
    -- Special cooldowns (from _G.APSkill.SpecialCooldowns)
    if abilityName and (abilityName:find("Racing") or abilityName:find("Horse")) then
        effectiveCooldown = math.max(effectiveCooldown, _G.APSkill.SpecialCooldowns["Racing"] or 5)
    elseif abilityName and (abilityName:find("Auto") or abilityName:find("Toggle")) then
        effectiveCooldown = math.max(effectiveCooldown, _G.APSkill.SpecialCooldowns["Auto"] or 10)
    elseif abilityName and abilityName:find("Swap") then
        effectiveCooldown = math.max(effectiveCooldown, _G.APSkill.SpecialCooldowns["Swap"] or 10)
    elseif abilityName and (abilityName:find("Arcane") or abilityName:find("Element")) then
        effectiveCooldown = math.max(effectiveCooldown, _G.APSkill.SpecialCooldowns["Element"] or 15)
    elseif abilityInfo.IsWorldItem then
        effectiveCooldown = math.max(effectiveCooldown, _G.APSkill.SpecialCooldowns["WorldItem"] or 30)
    -- ⭐⭐⭐ NEW: Boss Only abilities = cooldown 60 วินาที (ป้องกัน spam)
    elseif abilityName and (abilityName:find("Beast Explosion") or abilityName:find("Wrathful Clash") or 
           abilityName:find("Dimension") or abilityName:find("Domain") or abilityName:find("Ultimate")) then
        effectiveCooldown = math.max(effectiveCooldown, 60)  -- 60 วินาที cooldown
    end
    
    if elapsed < effectiveCooldown then
        return false, string.format("Cooldown (%.1fs left)", effectiveCooldown - elapsed)
    end
    
    return true, "OK"
end

-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                    SPECIAL ABILITY HANDLERS                            ║
-- ║  สำหรับ abilities ที่ต้องใช้ logic พิเศษ                              ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- ===== 1. AUTO BUTTON HANDLER =====
local function HandleAutoButton(unit, abilityName)
    if not unit or not unit.Model then return false end
    
    local plr = game:GetService("Players").LocalPlayer
    local playerGui = plr.PlayerGui
    local unitName = unit.Name or "Unknown"
    
    -- ⭐ หา Auto button ใน PlayerGui (เฉพาะ Unit-related GUI)
    local success, button = pcall(function()
        for _, gui in pairs(playerGui:GetChildren()) do
            -- ⭐⭐⭐ FIX: เช็คเฉพาะ ScreenGui ที่เกี่ยวกับ Unit (ไม่ใช่ทุก GUI!)
            if gui:IsA("ScreenGui") and gui.Enabled then
                local guiName = gui.Name:lower()
                -- ⭐ ข้าม GUI ที่ไม่เกี่ยวข้อง (Sandbox, Enemies, HUD, etc.)
                if guiName:find("sandbox") or guiName:find("enemies") or guiName:find("spawn") 
                   or guiName:find("properties") or guiName:find("hud") or guiName:find("chat") then
                    continue
                end
                
                for _, btn in pairs(gui:GetDescendants()) do
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                        -- ⭐ FIX: ImageButton ไม่มี .Text - เช็คเฉพาะ TextButton
                        local text = ""
                        if btn:IsA("TextButton") then
                            text = (btn.Text or ""):lower()
                        end
                        local name = btn.Name:lower()
                        
                        if text:find("auto") or name:find("auto") then
                            return btn
                        end
                    end
                end
            end
        end
        return nil
    end)
    
    if success and button then
        local clickSuccess = pcall(function()
            if button.Activated then button.Activated:Fire() end
            if button.MouseButton1Click then button.MouseButton1Click:Fire() end
        end)
        
        if clickSuccess then
            print(string.format("[AbilitySystem] ✅ Auto button clicked: %s", unitName))
            return true
        end
    end
    
    return false
end

-- ===== 2. RHYTHM GAME HANDLER (Skele King - King of String) =====
-- ⭐⭐⭐ แค่ return true เมื่อ ability ถูกเรียก - Auto-Hit Loop จะทำงานแยก
local RhythmGameActive = {}

_G.APSkill.KingOfString = _G.APSkill.KingOfString or {
    Enabled = true,
    AutoPlayActive = false,
    LastActivationTime = 0,
    ACTIVATION_COOLDOWN = 30,  -- Cooldown 30 วินาที
}

local function HandleRhythmGame(unit, abilityName)
    local guid = unit.UniqueIdentifier or unit.GUID
    local unitName = unit.Name or "Unknown"
    
    -- ⭐⭐⭐ ถ้าไม่ใช่ Skele King (Rock) → ไม่ทำงาน
    -- "Rock" เป็นส่วนหนึ่งของชื่อ ไม่ใช่ธาตุ!
    local lowerName = unitName:lower()
    if not (lowerName:find("skele") and lowerName:find("king") and lowerName:find("rock")) then
        print("[KingOfString] ❌ Not Skele King (Rock) - skipping:", unitName)
        return false
    end
    
    -- ป้องกัน spam
    if RhythmGameActive[guid] then return true end
    
    -- ⭐ Cooldown check
    local now = tick()
    if now - _G.APSkill.KingOfString.LastActivationTime < _G.APSkill.KingOfString.ACTIVATION_COOLDOWN then
        return true
    end
    
    RhythmGameActive[guid] = true
    _G.APSkill.KingOfString.LastActivationTime = now
    _G.APSkill.KingOfString.AutoPlayActive = true
    print(string.format("[AbilitySystem] 🎸 King of String activated: %s", unitName))
    
    -- ⭐⭐⭐ เปิด GUI ทันที!
    task.spawn(function()
        task.wait(0.5)  -- รอให้ game พร้อม
        
        -- เช็คว่า GUI ยังไม่เปิด
        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        local guitarGui = PlayerGui and PlayerGui:FindFirstChild("GuitarMinigame")
        
        if not guitarGui or not guitarGui.Enabled then
            -- ⭐ หา GuitarMinigame module และเปิด
            if getgc then
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        local hasOpen = rawget(v, "Open")
                        local hasPlayChart = rawget(v, "PlayChart")
                        
                        if hasOpen and type(hasOpen) == "function" and hasPlayChart and type(hasPlayChart) == "function" then
                            pcall(function()
                                v.Open()
                                print("[KingOfString] 🎸 Opened GUI!")
                                
                                task.delay(0.3, function()
                                    pcall(function()
                                        v.PlayChart("Skele King's Theme", "Medium", 2)
                                        print("[KingOfString] 🎸 Playing Skele King's Theme!")
                                    end)
                                end)
                            end)
                            break
                        end
                    end
                end
            end
        end
    end)
    
    -- ⭐⭐⭐ Auto cleanup หลัง 60 วินาที
    task.delay(60, function()
        RhythmGameActive[guid] = nil
        _G.APSkill.KingOfString.AutoPlayActive = false
    end)
    
    return true
end

-- ===== 3. UNIT SELECTION HANDLER (The Smith - Masterwork) =====
local function SelectBestUnitForUpgrade()
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then
        return nil
    end
    
    local bestUnit = nil
    local bestScore = -1
    
    for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
        if unit and unit.Data then
            local currentLevel = unit.Data.CurrentUpgrade or 0
            local maxLevel = #(unit.Data.Upgrades or {})
            
            -- เลือก unit ที่ยังอัพได้และอัพสูงแล้ว
            if currentLevel < maxLevel then
                local score = currentLevel * 100
                
                -- เพิ่ม score ถ้ามี Damage สูง
                if unit.Data.Damage then
                    score = score + (unit.Data.Damage or 0)
                end
                
                -- เพิ่ม score ถ้าใกล้ max
                local percentToMax = currentLevel / math.max(maxLevel, 1)
                score = score + (percentToMax * 1000)
                
                if score > bestScore then
                    bestScore = score
                    bestUnit = unit
                end
            end
        end
    end
    
    return bestUnit
end

-- ===== 4. CHARGE HANDLER (Lizard - Fission) =====
local function HandleCharge(unit, abilityName)
    local plr = game:GetService("Players").LocalPlayer
    local playerGui = plr.PlayerGui
    local unitName = unit and unit.Name or "Unknown"
    
    -- หา Charge button (เฉพาะปุ่มที่มีชื่อ charge/hold)
    for _, gui in pairs(playerGui:GetDescendants()) do
        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
            -- ⭐ FIX: ImageButton ไม่มี .Text - เช็คเฉพาะ TextButton
            local text = ""
            if gui:IsA("TextButton") then
                text = (gui.Text or ""):lower()
            end
            if text:find("charge") or text:find("hold") or gui.Name:lower():find("charge") then
                -- ลด spam log
                task.spawn(function()
                    pcall(function()
                        -- Press down
                        if gui.MouseButton1Down then 
                            gui.MouseButton1Down:Fire() 
                        end
                    end)
                    
                    task.wait(2.0) -- Hold 2 seconds
                    
                    pcall(function()
                        -- Release
                        if gui.MouseButton1Up then 
                            gui.MouseButton1Up:Fire() 
                        end
                    end)
                    
                    print(string.format("[AbilitySystem] ✅ Charged: %s", unitName))
                end)
                
                return true
            end
        end
    end
    
    return false
end

-- ===== AUTO PLACEMENT HANDLERS =====
-- ⭐⭐⭐ ตามภาพที่ให้มา: Instant Teleportation, Monkey King's Fur, Wayward Journey, This is Another Me, The Forge, Masterworks

-- Helper: Select best unit for targeting (prefer DPS units)
local function SelectBestTargetUnit()
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then
        return nil
    end
    
    local bestUnit = nil
    local bestScore = 0
    
    for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
        if unitData and unitData.Name then
            local unitName = unitData.Name
            local currentUpgrade = unitData.Data and unitData.Data.CurrentUpgrade or 0
            
            -- Prioritize DPS units
            local score = currentUpgrade
            
            -- Boost score for known DPS units
            if unitName and (unitName:find("Roku") or unitName:find("Vogita") or 
               unitName:find("Igneel") or unitName:find("Monarch") or
               unitName:find("Sung") or unitName:find("Saber")) then
                score = score + 100
            end
            
            if score > bestScore then
                bestScore = score
                bestUnit = guid
            end
        end
    end
    
    return bestUnit
end

-- Helper: Get frontmost position for placement
local function GetFrontPlacementPosition()
    -- Try to get from _G first (from AutoPlayBase)
    if _G.GetBestFrontPosition then
        local pos = _G.GetBestFrontPosition(10)
        if pos and pos ~= Vector3.new(0, 0, 0) then 
            return pos 
        end
    end
    
    -- Fallback 1: Get frontmost enemy position
    local frontEnemy = GetFrontmostEnemy()
    if frontEnemy then
        local enemyPos = nil
        
        -- Try Model first
        if frontEnemy.Model then
            enemyPos = frontEnemy.Model:GetPivot().Position
        -- Try Position directly
        elseif frontEnemy.Position then
            enemyPos = frontEnemy.Position
        end
        
        if enemyPos then
            -- Place 8-12 studs in front of enemy (towards gate)
            return enemyPos + Vector3.new(0, 0, math.random(8, 12))
        end
    end
    
    -- Fallback 2: Try to find gate position
    local gatePos = nil
    pcall(function()
        if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Gate") then
            gatePos = workspace.Map.Gate.Position
        end
    end)
    
    if gatePos then
        -- Place 20-30 studs away from gate
        return gatePos - Vector3.new(0, 0, math.random(20, 30))
    end
    
    -- Fallback 3: Use map center with random offset
    return Vector3.new(math.random(-10, 10), 10, math.random(-10, 10))
end

-- ===== USE ABILITY V3 (MAIN FUNCTION) =====
local function UseAbilityV3(unit, abilityName, abilityInfo)
    if not unit or not abilityName then 
        return false 
    end
    
    -- สร้าง abilityInfo เปล่าถ้าไม่มี
    abilityInfo = abilityInfo or {}
    
    local guid = unit.UniqueIdentifier or unit.GUID
    local abilityKey = tostring(guid) .. "_" .. tostring(abilityName)
    local unitName = unit.Name or "Unknown"
    
    local success = false
    local err = nil
    
    -- ⭐⭐⭐ AUTO UI FIRST: ถ้า ability มี Auto UI → ใช้ AutoAbilityEvent ของเกมก่อน
    -- ยกเว้น abilities ที่ต้องใช้ logic พิเศษ (Koguro, Lich, Reality Rewrite, etc.)
    local hasAutoUI = HasAutoUseUI(abilityName)
    local isSpecialAbility = (
        (unitName and unitName:find("Koguro")) or
        (unitName and unitName:find("Lich")) or 
        (abilityName and abilityName:find("Reality Rewrite")) or
        (abilityName and abilityName:find("God Arrives")) or
        (abilityName and abilityName:find("World Item")) or
        (abilityName and abilityName:find("Caloric")) or
        (abilityName and abilityName:find("Racing")) or
        (abilityName and abilityName:find("Placement")) or
        (abilityName and abilityName:find("Clone")) or
        (abilityName and abilityName:find("Summon")) or
        (abilityName and abilityName:find("Instant Teleportation")) or
        (abilityName and abilityName:find("Wayward Journey")) or
        (abilityName and abilityName:find("Monkey King")) or
        (abilityName and abilityName:find("Fur")) or
        (abilityName and abilityName:find("Another Me")) or
        (abilityName and abilityName:find("The Forge")) or
        (abilityName and abilityName:find("Masterworks"))
    )
    
    if hasAutoUI and not isSpecialAbility then
        -- ⭐ ใช้ AutoAbilityEvent ของเกม (ไม่ใช้ logic ของเราเอง)
        local autoSuccess = EnableAutoAbilityUI(unit, abilityName)
        if autoSuccess then
            AbilityLastUsed[abilityKey] = tick()
            return true
        end
        -- ถ้าเปิดไม่สำเร็จ → ใช้ logic เดิมด้านล่าง
    end
    
    -- ⭐⭐⭐ HELPER: เช็คว่า unit มี Auto Use Ability UI หรือไม่ (เดิม)
    local function HasAutoUseAbilityUI(unit)
        if not unit or not unit.Model then return false end
        
        local playerGui = plr.PlayerGui
        if not playerGui then return false end
        
        -- หา Unit UI ที่เกี่ยวข้อง
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name:find("Unit") then
                -- หา Auto Use Ability toggle/button
                for _, element in pairs(gui:GetDescendants()) do
                    if element:IsA("TextButton") or element:IsA("ImageButton") then
                        local name = element.Name:lower()
                        -- ⭐ FIX: ImageButton ไม่มี .Text property - เช็คเฉพาะ TextButton
                        local text = ""
                        if element:IsA("TextButton") then
                            text = (element.Text or ""):lower()
                        end
                        if name:find("auto") and (name:find("use") or name:find("ability")) then
                            return true, element
                        end
                        if text ~= "" and text:find("auto") and text:find("ability") then
                            return true, element
                        end
                    end
                end
            end
        end
        
        return false, nil
    end
    
    -- ⭐⭐⭐ HELPER: เปิด Auto Use Ability (คลิกปุ่ม)
    local function EnableAutoUseAbility(unit, abilityName)
        local hasUI, autoButton = HasAutoUseAbilityUI(unit)
        
        if not hasUI then
            -- ไม่มี UI = ใช้แบบเดิม (direct AbilityEvent)
            return false
        end
        
        -- มี UI = ต้องคลิกปุ่มให้เปิด Auto ก่อน
        if autoButton and not autoButton.Enabled then
            pcall(function()
                for _, connection in pairs(getconnections(autoButton.MouseButton1Click)) do
                    connection:Fire()
                end
                for _, connection in pairs(getconnections(autoButton.Activated)) do
                    connection:Fire()
                end
            end)
            print(string.format("[AbilitySystem] 🔘 Enabled Auto Use Ability: %s", unit.Name or "Unit"))
            task.wait(0.2)  -- รอให้ UI อัปเดต
            return true
        end
        
        return false
    end
    
    -- ⭐⭐⭐ SPECIAL HANDLERS (เช็คก่อน default logic) ⭐⭐⭐
    
    -- SONG JINWU AND IGROS - Check unit ability conditions (ต้องเช็คก่อน Auto Button!)
    -- ⭐⭐⭐ FIX: เช็คเงื่อนไข แต่ไม่ return (ให้ flow ต่อไปยัง handlers ข้างล่าง)
    if unitName and (unitName:find("Song Jinwu") or unitName:find("Monarch") or unitName:find("Igros")) then
        -- ⭐ เช็คว่ามีศัตรูหรือไม่ (สำหรับ ability ที่ต้องมีศัตรู)
        if abilityName and (abilityName:find("Arise") or abilityName:find("Shadow") or abilityName:find("Summon")) then
            local hasEnemies = false
            if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
                for _ in pairs(ClientEnemyHandler._ActiveEnemies) do
                    hasEnemies = true
                    break
                end
            end
            
            if not hasEnemies then
                return false, "No enemies found"
            end
        end
        
        -- ⭐ เช็ค Yen สำหรับ Summon abilities
        if abilityName and (abilityName:find("Arise") or abilityName:find("Shadow Army") or abilityName:find("Summon")) then
            -- Summon abilities ต้องเช็คเงิน (ถ้ามี cost ใน data)
            if abilityInfo.Cost and abilityInfo.Cost > 0 then
                local currentYen = GetYen()
                if currentYen < abilityInfo.Cost then
                    return false, string.format("Not enough Yen (%d < %d)", currentYen, abilityInfo.Cost)
                end
            end
        end
        
        -- ⭐ ผ่านเงื่อนไขแล้ว - ปล่อยให้ flow ต่อไปยัง handlers ข้างล่าง (ไม่ return ตรงนี้)
    end
    
    -- SONG JINWU (Monarch) - Separate Auto Attack from Shadow Army
    -- ⭐⭐⭐ FIX: Boss Only + Per Once + ลด spam logs
    if unitName and (unitName:find("Song Jinwu") or unitName:find("Monarch")) and not unitName:find("Igros") then
        if abilityName and (abilityName:find("Auto Attack") or abilityName:find("THE SYSTEM")) then
            -- ⭐⭐⭐ Per Once: เช็คว่าใช้ไปแล้วหรือยัง
            local perOnceKey = guid .. "_" .. abilityName .. "_auto"
            if AbilityUsedOnce[perOnceKey] then
                return false, "Already activated (Per Once)"
            end
            
            -- ⭐ เช็คว่ามี Auto Use Ability UI หรือไม่
            local hasUI, autoButton = HasAutoUseAbilityUI(unit)
            
            if hasUI then
                -- มี UI = เปิด Auto ผ่าน UI
                EnableAutoUseAbility(unit, abilityName)
                AbilityLastUsed[abilityKey] = tick()
                AbilityUsedOnce[perOnceKey] = true
                print(string.format("[AbilitySystem] ✅ %s → Auto Attack ON", unitName))
                return true
            else
                -- ไม่มี UI = ใช้ AbilityEvent ตรงๆ
                if AbilityEvent then
                    success, err = pcall(function()
                        AbilityEvent:FireServer("Activate", guid, abilityName)
                    end)
                    if success then
                        AbilityLastUsed[abilityKey] = tick()
                        AbilityUsedOnce[perOnceKey] = true
                        print(string.format("[AbilitySystem] ✅ %s → Auto Attack ON", unitName))
                    end
                end
                return success
            end
        elseif abilityName and (abilityName:find("Arise") or abilityName:find("Shadow") or abilityName:find("Summon")) then
            -- ⭐⭐⭐ Boss Only: เช็คว่ามี Boss อยู่ในระยะหรือไม่
            local hasBossInRange = false
            local bossPosition = nil
            if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
                for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                    if enemy and enemy.IsBoss then
                        hasBossInRange = true
                        bossPosition = enemy.Position
                        break
                    end
                end
            end
            
            if not hasBossInRange then
                return false, "Boss Only ability - No Boss in range"
            end
            
            -- Arise/Shadow Army = Placement ability - ใช้ตรงตำแหน่ง Boss
            local targetPos = bossPosition or GetBestPlacementPosition(30, GetGamePhase(), unitName, unit.Data)
            if not targetPos then
                local frontEnemy = GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    targetPos = frontEnemy.Position
                end
            end
            
            if targetPos and AbilityEvent then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[AbilitySystem] ✅ %s → Shadow Army (Boss)", unitName))
                end
            end
            return success
        end
    end
    
    -- IGROS (Shadow Soldier) - Separate Auto Attack from Summon
    -- ⭐⭐⭐ FIX: Boss Only + Per Once + ลด spam logs
    if unitName and unitName:find("Igros") then
        if abilityName and (abilityName:find("Auto Attack") or abilityName:find("THE SYSTEM")) then
            -- ⭐⭐⭐ Per Once: เช็คว่าใช้ไปแล้วหรือยัง
            local perOnceKey = guid .. "_" .. abilityName .. "_auto"
            if AbilityUsedOnce[perOnceKey] then
                return false, "Already activated (Per Once)"
            end
            
            -- ⭐ เช็คว่ามี Auto Use Ability UI หรือไม่
            local hasUI, autoButton = HasAutoUseAbilityUI(unit)
            
            if hasUI then
                -- มี UI = เปิด Auto ผ่าน UI
                EnableAutoUseAbility(unit, abilityName)
                AbilityLastUsed[abilityKey] = tick()
                AbilityUsedOnce[perOnceKey] = true
                print(string.format("[AbilitySystem] ✅ %s → Auto Attack ON", unitName))
                return true
            else
                -- ไม่มี UI = ใช้ AbilityEvent ตรงๆ
                if AbilityEvent then
                    success, err = pcall(function()
                        AbilityEvent:FireServer("Activate", guid, abilityName)
                    end)
                    if success then
                        AbilityLastUsed[abilityKey] = tick()
                        AbilityUsedOnce[perOnceKey] = true
                        print(string.format("[AbilitySystem] ✅ %s → Auto Attack ON", unitName))
                    end
                end
                return success
            end
        elseif abilityName and (abilityName:find("Summon") or abilityName:find("Shadow")) then
            -- ⭐⭐⭐ Boss Only: เช็คว่ามี Boss อยู่ในระยะหรือไม่
            local hasBossInRange = false
            local bossPosition = nil
            if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
                for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                    if enemy and enemy.IsBoss then
                        hasBossInRange = true
                        bossPosition = enemy.Position
                        break
                    end
                end
            end
            
            if not hasBossInRange then
                return false, "Boss Only ability - No Boss in range"
            end
            
            -- Summon = Placement ability - ใช้ตรงตำแหน่ง Boss
            local targetPos = bossPosition or GetBestPlacementPosition(25, GetGamePhase(), unitName, unit.Data)
            if not targetPos then
                local frontEnemy = GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    targetPos = frontEnemy.Position
                end
            end
            
            if targetPos and AbilityEvent then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[AbilitySystem] ✅ %s → Shadow Summon (Boss)", unitName))
                end
            end
            return success
        end
    end
    
    -- SKELE KING (ROCK) - King of String (Rhythm Game)
    if unitName:find("Skele King") and (abilityName:find("King of String") or abilityName:find("String")) then
        success = HandleRhythmGame(unit, abilityName)
        if success then
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("[AbilitySystem] ✅ %s → %s (Rhythm Auto)", unitName, abilityName))
        end
        return success
    end
    
    -- THE SMITH (FORGED) - Masterwork (Unit Selection)
    if unitName:find("Smith") and abilityName:find("Masterwork") then
        local targetUnit = SelectBestUnitForUpgrade()
        if targetUnit and AbilityEvent then
            local targetGuid = targetUnit.UniqueIdentifier or targetUnit.GUID
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName, targetGuid)
            end)
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print(string.format("[AbilitySystem] ✅ %s → %s (Target: %s)", unitName, abilityName, targetUnit.Name or "Unit"))
            end
        end
        return success
    end
    
    -- LIZARD (FISSION) - Charge
    if unitName:find("Lizard") and abilityName:find("Charge") then
        success = HandleCharge(unit, abilityName)
        if success then
            AbilityLastUsed[abilityKey] = tick()
        end
        return success
    end
    
    -- AUTO BUTTON ABILITIES (Roku Auto Swap, God Auto, etc.) - แต่ไม่ใช่ "Auto Attack"
    if abilityName:find("Auto") and not abilityName:find("Attack") then
        local autoSuccess = HandleAutoButton(unit, abilityName)
        if autoSuccess then
            AbilityLastUsed[abilityKey] = tick()
            _G.APEvents.AutoSwapEnabled[guid] = true
            return true
        end
    end
    
    -- MONKEY KING (AWAKENED) - Clone Placement (Multiple)
    if (unitName:find("Monkey King") or unitName:find("Awakened")) and abilityName:find("Clone") then
        print(string.format("[AbilitySystem] 🐵 Monkey King Clone Spawning: %s", abilityName))
        
        -- สร้าง 3-5 clones (สุ่ม)
        local cloneCount = math.random(3, 5)
        local successCount = 0
        
        for i = 1, cloneCount do
            local clonePos = nil
            
            -- หาตำแหน่งสุ่มรอบๆ ศัตรู
            local frontEnemy = GetFrontmostEnemy()
            if frontEnemy and frontEnemy.Position then
                local offset = math.random(10, 20)  -- สุ่มระยะ 10-20 studs
                local angle = (math.pi * 2 / cloneCount) * i + math.random() * 0.5  -- กระจายตัวเป็นวงกลม
                clonePos = frontEnemy.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
            else
                -- ถ้าไม่มีศัตรู ใช้ตำแหน่งสุ่มทั่วไป
                clonePos = GetBestPlacementPosition(30, GetGamePhase(), unitName, unit.Data)
            end
            
            if clonePos and AbilityEvent then
                local cloneSuccess, cloneErr = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, clonePos)
                end)
                
                if cloneSuccess then
                    successCount = successCount + 1
                    print(string.format("[AbilitySystem] 🐵 Clone %d/%d placed at (%.1f, %.1f, %.1f)", 
                        i, cloneCount, clonePos.X, clonePos.Y, clonePos.Z))
                end
                
                task.wait(0.1)  -- หน่วงเวลาเล็กน้อยระหว่าง clone
            end
        end
        
        if successCount > 0 then
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("✅ Auto enabled: %s → %s (%d clones)", unitName, abilityName, successCount))
            return true
        end
        return false
    end  -- ปิด if Monkey King
    
    -- 1. REALITY REWRITE
    if abilityName and abilityName:find("Reality Rewrite") then
        print(string.format("[AbilitySystem] 🌈 Reality Rewrite triggered! Event: %s", tostring(RealityRewriteEvent)))
        
        if not RealityRewriteEvent then 
            print("[AbilitySystem] ❌ RealityRewriteEvent is NIL!")
            return false 
        end
        
        local selectedStatus = "Burn"
        local analyzeSuccess, analyzeResult = pcall(function()
            return AnalyzeEnemiesForStatus()
        end)
        
        if analyzeSuccess and analyzeResult then
            selectedStatus = analyzeResult
        end
        
        local validStatus = selectedStatus
        if RealityRewriteData and RealityRewriteData.Statuses then
            if not RealityRewriteData.Statuses[selectedStatus] then
                local fallbackPriority = {"Burn", "Slow", "Freeze", "Stun", "Rupture"}
                for _, fallback in ipairs(fallbackPriority) do
                    if RealityRewriteData.Statuses[fallback] then
                        validStatus = fallback
                        break
                    end
                end
            end
        else
            if not table.find(REALITY_REWRITE_STATUSES, selectedStatus) then
                validStatus = "Burn"
            end
        end
        
        success, err = pcall(function()
            RealityRewriteEvent:FireServer(guid, validStatus)
        end)
        
        if success then
            AbilityUsedOnce[abilityKey] = true
            print(string.format("[AbilitySystem] 🌈 Reality Rewrite → %s", validStatus))
        end
        return success
    end  -- ปิด if Reality Rewrite
    
    -- 2. THE GOAL OF ALL LIFE IS DEATH (Lich)
    if abilityName and abilityName:find("The Goal of All Life is Death") then
        if AbilityEvent then
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityUsedOnce[abilityKey] = true
                print("[AbilitySystem] 💀 The Goal of All Life is Death activated")
            end
        end
        return success
    end  -- ปิด if Lich
    
    -- 3. GOD ARRIVES + STATUS EFFECT SELECTION
    if abilityName and abilityName:find("God Arrives") then
        if not AbilityEvent then return false end
        
        -- ⭐ เลือก Status Effect ก่อน (Burn เป็น default)
        local selectedStatus = "Burn"
        
        -- พยายามวิเคราะห์ศัตรูเพื่อหา status ที่เหมาะสม
        local analyzeSuccess, analyzeResult = pcall(function()
            return AnalyzeEnemiesForStatus()
        end)
        
        if analyzeSuccess and analyzeResult then
            selectedStatus = analyzeResult
        end
        
        -- ⭐⭐⭐ FIX: ป้องกัน error - ใช้ pcall ทั้งหมดและไม่ให้ crash
        local GodStatusEvent = _G.GodStatusEvent
        if not GodStatusEvent then
            pcall(function()
                if Networking and Networking.Units then
                    -- ลองหาจาก folder "God Arrives" (ถ้ามี)
                    local godFolder = Networking.Units:FindFirstChild("God Arrives")
                    if godFolder then
                        GodStatusEvent = godFolder:FindFirstChild("SelectStatus") or
                                       godFolder:FindFirstChild("EquipStatus")
                    end
                    
                    -- ถ้าไม่เจอ ลองหาจาก Units โดยตรง
                    if not GodStatusEvent then
                        GodStatusEvent = Networking.Units:FindFirstChild("SelectGodStatus")
                    end
                end
            end)
        end
        
        -- เลือก status ถ้าหา event เจอ
        if GodStatusEvent then
            pcall(function()
                GodStatusEvent:FireServer(guid, selectedStatus)
            end)
            task.wait(0.1)  -- รอให้เลือก status เสร็จ
            print(string.format("[AbilitySystem] 🔥 God Status: %s", selectedStatus))
        end
        
        -- เปิดใช้ ability
        success, err = pcall(function()
            AbilityEvent:FireServer("Activate", guid, abilityName)
        end)
        
        if success then
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("[AbilitySystem] ⚡ God Arrives → %s", selectedStatus))
        end
        return success
    end  -- ปิด if God Arrives
    
    -- 4. KOGURO DIMENSIONS (Enable Auto + ToggleAuto)
    -- ⭐⭐⭐ FIX: Koguro มี Auto ของเกมอยู่แล้ว - ไม่ต้องกดซ้ำ
    if unitName and unitName:find("Koguro") and abilityName and abilityName:find("Dimension") then
        -- ⭐ เช็คจาก _G.APEvents.KoguroAutoEnabled (เกมจัดการเอง)
        local isAutoEnabled = _G.APEvents.KoguroAutoEnabled[guid]
        
        if isAutoEnabled then
            -- ⭐ Auto เปิดอยู่แล้ว (เกมจัดการ) → skip ไม่ต้องทำอะไร
            AbilityLastUsed[abilityKey] = tick()
            return false
        end
        
        -- ⭐⭐⭐ Boss Only: เช็คว่ามี Boss อยู่ในระยะหรือไม่
        local hasBossInRange = false
        if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
            for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                if enemy and enemy.IsBoss then
                    hasBossInRange = true
                    break
                end
            end
        end
        
        if not hasBossInRange then
            return false  -- ⭐ ไม่มี Boss = ไม่ใช้ (silent, no spam)
        end
        
        -- ⭐⭐⭐ เช็คว่า domain กำลัง active อยู่หรือไม่
        local isDomainActive = _G.APEvents.KoguroDomainActive[guid]
        if isDomainActive then
            -- Domain กำลัง active → skip (ไม่ส่งซ้ำ)
            AbilityLastUsed[abilityKey] = tick()
            return false
        end
        
        -- ⭐ ไม่มี Auto → ใช้ KoguroDimensionEvent เพื่อเปิด Auto
        if not KoguroDimensionEvent then return false end
        
        success, err = pcall(function()
            KoguroDimensionEvent:FireServer("ToggleAuto", guid)
        end)
        
        if success then
            _G.APEvents.KoguroAutoEnabled[guid] = true
            _G.APEvents.KoguroDomainActive[guid] = true
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("[AbilitySystem] ✅ %s → Dimension Auto ON", unitName))
        end
        return success
    end  -- ปิด if Koguro
    
    -- 5. ARCANE KNOWLEDGE (Lich) - Element Selection (เวอร์ชันจาก AutoPlayBase copy 2)
    if unitName and unitName:find("Lich") and abilityName and abilityName:find("Arcane Knowledge") then
        if not LichSpellsEvent then return false end
        
        -- ⭐⭐⭐ CRITICAL: เช็คว่าวาง Lich King แล้วหรือยัง!
        local lichPlaced = false
        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
            for guid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                if activeUnit and activeUnit.Name then
                    local name = activeUnit.Name or ""
                    if name:lower():find("lich") or name:lower():find("ruler") then
                        lichPlaced = true
                        break
                    end
                end
            end
        end
        
        -- ⭐⭐⭐ ถ้ายังไม่ได้วาง Lich King → ไม่ใช้ Ability!
        if not lichPlaced then
            return false, "Lich not placed yet"
        end
        
        -- ⭐⭐⭐ PRIORITY ELEMENTS: Elementless และ Curse เท่านั้น
        local PRIORITY_ELEMENTS = {"Elementless", "Curse"}
        
        -- 🔮 วิเคราะห์ธาตุที่ unlock แล้ว (ตาม decom)
        local function GetUnlockedElements()
            local elementCounts = {}
            
            -- นับธาตุจาก Units._Cache (ตาม decom)
            if UnitsModule and UnitsModule._Cache then
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
            end
            
            -- เพิ่ม Unknown ให้ทุกธาตุ (ตาม decom)
            if elementCounts.Unknown then
                for elem in pairs(elementCounts) do
                    elementCounts[elem] = elementCounts[elem] + 1
                end
            end
            
            return elementCounts
        end
        
        -- เลือกธาตุที่ดีที่สุดตามสถานการณ์
        local unlockedElements = GetUnlockedElements()
        local selectedElement = "Elementless"  -- Default
        local secondaryElement = "Curse"       -- ⭐ Secondary = Curse
        
        -- ⭐⭐⭐ NEW: เลือกเฉพาะ Elementless และ Curse เท่านั้น!
        local hasCurse = (unlockedElements["Curse"] or 0) > 0
        local curseCount = unlockedElements["Curse"] or 0
        
        -- ⭐ Elementless เป็น primary เสมอ
        selectedElement = "Elementless"
        
        -- ⭐ Curse เป็น secondary ถ้าปลดล็อคแล้ว
        if hasCurse then
            secondaryElement = "Curse"
        else
            secondaryElement = nil
        end
        
        -- ดึง spell ที่เหมาะสมกับธาตุที่เลือก (ต้อง unlock แล้ว!)
        -- ⭐⭐⭐ NEW: เลือกเฉพาะ Elementless และ Curse spells เท่านั้น!
        local selectedSpells = {}
        local curseSpells = {}  -- ⭐ เก็บ Curse spells แยก
        
        if LichData and LichData.Spells then
            -- ⭐⭐⭐ NEW: หา spells เฉพาะ Elementless และ Curse เท่านั้น!
            for spellId, spellData in pairs(LichData.Spells) do
                local spellName = spellData.Name or spellId
                local requirements = spellData.Requirements or {}
                
                -- นับ requirements
                local reqCount = 0
                local hasCurseReq = false
                local curseReqLevel = 0
                
                for elem, count in pairs(requirements) do
                    reqCount = reqCount + 1
                    if elem == "Curse" then
                        hasCurseReq = true
                        curseReqLevel = count
                    end
                end
                
                -- ⭐ Elementless: ไม่มี requirement
                if reqCount == 0 then
                    table.insert(selectedSpells, {
                        id = spellId,
                        name = spellName,
                        reqLevel = 0,
                        element = "Elementless"
                    })
                -- ⭐ Curse: ต้องมี Curse requirement และปลดล็อคแล้ว
                elseif hasCurseReq then
                    local curseCount = unlockedElements["Curse"] or 0
                    if curseCount >= curseReqLevel then
                        table.insert(curseSpells, {
                            id = spellId,
                            name = spellName,
                            reqLevel = curseReqLevel,
                            element = "Curse"
                        })
                    end
                end
            end
            
            -- ⭐ เรียง Curse spells ตาม level (สูง → ต่ำ)
            table.sort(curseSpells, function(a, b)
                return a.reqLevel > b.reqLevel
            end)
        end
        
        -- ⭐⭐⭐ NEW: หา spells จากธาตุอื่นๆ สำหรับ Slot 3-4
        local otherElementSpells = {}
        
        if LichData and LichData.Spells then
            for spellId, spellData in pairs(LichData.Spells) do
                local spellName = spellData.Name or spellId
                local requirements = spellData.Requirements or {}
                
                -- เช็คทุกธาตุ (ยกเว้น Curse ที่เก็บแยกแล้ว)
                for elem, reqCount in pairs(requirements) do
                    if elem ~= "Curse" then
                        local actualCount = unlockedElements[elem] or 0
                        if actualCount >= reqCount then
                            table.insert(otherElementSpells, {
                                id = spellId,
                                name = spellName,
                                reqLevel = reqCount,
                                element = elem
                            })
                        end
                    end
                end
            end
            
            -- เรียงตาม level สูง → ต่ำ
            table.sort(otherElementSpells, function(a, b)
                return a.reqLevel > b.reqLevel
            end)
        end
        
        -- ⭐⭐⭐ FINAL SELECTION: Slot 1-2 = Elementless + Curse (ไม่เปลี่ยน), Slot 3-4 = ธาตุอื่น
        local maxSpells = (LichData and LichData.MAX_SPELL_COUNT) or 4
        local finalSpells = {}
        local finalSpellNames = {}
        local usedSpellIds = {}
        
        -- ⭐ SLOT 1: Elementless spell แรก (ไม่เปลี่ยน)
        if #selectedSpells > 0 then
            local spell = selectedSpells[1]
            table.insert(finalSpells, spell.id)
            table.insert(finalSpellNames, spell.name)
            usedSpellIds[spell.id] = true
        else
            -- Fallback: ใช้ Undead Control
            table.insert(finalSpells, 1)
            table.insert(finalSpellNames, "Undead Control")
            usedSpellIds[1] = true
        end
        
        -- ⭐ SLOT 2: Curse spell แรก (ไม่เปลี่ยน)
        if #curseSpells > 0 then
            local spell = curseSpells[1]
            table.insert(finalSpells, spell.id)
            table.insert(finalSpellNames, spell.name)
            usedSpellIds[spell.id] = true
        elseif #selectedSpells > 1 then
            -- ถ้าไม่มี Curse → ใช้ Elementless ตัวที่ 2
            local spell = selectedSpells[2]
            table.insert(finalSpells, spell.id)
            table.insert(finalSpellNames, spell.name)
            usedSpellIds[spell.id] = true
            print(string.format("🔮 [Slot 2 - FIXED] %s (Elementless fallback)", spell.name))
        end
        
        -- ⭐ SLOT 3-4: วิเคราะห์ธาตุอื่นทุก 3 waves (เปลี่ยนได้)
        local slotsRemaining = maxSpells - #finalSpells
        local CurrentWave, _ = GetWaveFromUI()
        
        -- รวม spells ที่เหลือทั้งหมด (เรียงลำดับ: Curse ที่เหลือ → Other Elements → Elementless ที่เหลือ)
        local slot34Candidates = {}
        
        -- เพิ่ม Curse ที่เหลือ
        for i = 2, #curseSpells do
            if not usedSpellIds[curseSpells[i].id] then
                table.insert(slot34Candidates, curseSpells[i])
            end
        end
        
        -- เพิ่ม Other Element spells
        for _, spell in ipairs(otherElementSpells) do
            if not usedSpellIds[spell.id] then
                table.insert(slot34Candidates, spell)
            end
        end
        
        -- เพิ่ม Elementless ที่เหลือ
        for i = 2, #selectedSpells do
            if not usedSpellIds[selectedSpells[i].id] then
                table.insert(slot34Candidates, selectedSpells[i])
            end
        end
        
        -- ⭐⭐⭐ DYNAMIC SELECTION: หมุนเวียน spell ตาม wave (ทุก 3 waves)
        local rotationIndex = math.floor(CurrentWave / LICH_SPELL_CHANGE_INTERVAL) % math.max(1, #slot34Candidates)
        
        -- ใส่ Slot 3-4 (หมุนเวียนตาม wave)
        for i = 1, slotsRemaining do
            local candidateIndex = ((rotationIndex + i - 1) % #slot34Candidates) + 1
            if #slot34Candidates >= candidateIndex then
                local spell = slot34Candidates[candidateIndex]
                if not usedSpellIds[spell.id] then
                    table.insert(finalSpells, spell.id)
                    table.insert(finalSpellNames, spell.name)
                    usedSpellIds[spell.id] = true
                end
            end
        end
        
        -- ⭐⭐⭐ เช็คว่า spells เปลี่ยนจากครั้งก่อนหรือไม่
        local spellsChanged = false
        if #finalSpells ~= #LichSpellCurrentSet then
            spellsChanged = true
        else
            for i, spellId in ipairs(finalSpells) do
                if LichSpellCurrentSet[i] ~= spellId then
                    spellsChanged = true
                    break
                end
            end
        end
        
        -- ⭐ ถ้า spells ไม่เปลี่ยน → ไม่ต้องส่ง (silent)
        if not spellsChanged and #LichSpellCurrentSet > 0 then
            return true  -- ถือว่าสำเร็จ
        end
        
        -- Fire event
        success, err = pcall(function()
            LichSpellsEvent:FireServer(finalSpells)
        end)
        
        if success then
            AbilityLastUsed[abilityKey] = tick()
            
            -- ⭐⭐⭐ Track การเปลี่ยน spell
            LichSpellLastChange = tick()
            local CurrentWave, _ = GetWaveFromUI()
            LichSpellLastWave = CurrentWave
            LichSpellCurrentSet = finalSpells
            
            -- Log เฉพาะเมื่อเปลี่ยน spell สำเร็จ
            print(string.format("[AbilitySystem] 🔮 Lich Spells Changed (Wave %d): %s", 
                CurrentWave, table.concat(finalSpellNames, ", ")))
        end
        return success
    end  -- ปิด if Arcane Knowledge
    
    -- 6. HORSEGIRL RACING + SELECTION (Racing Event)
    -- ⭐⭐⭐ FIX: ลด spam logs
    if abilityInfo.IsHorsegirl then
        if HorsegirlRacingEvent then
            success, err = pcall(function()
                HorsegirlRacingEvent:FireServer(guid)
            end)
            
            if success then
                task.spawn(function()
                    task.wait(0.5)  -- รอให้ GUI โผล่
                    
                    local playerGui = plr.PlayerGui
                    if not playerGui then return end
                    
                    -- หา Racing GUI (ลองหลายชื่อ)
                    local racingGui = nil
                    local possibleNames = {"HorsegirlRacing", "Horsegirl Racing", "HorsegirlSelect", "Racing"}
                    
                    for _, name in ipairs(possibleNames) do
                        racingGui = playerGui:FindFirstChild(name)
                        if racingGui and racingGui.Enabled then
                            break
                        end
                    end
                    
                    -- ถ้าไม่เจอ ค้นหา GUI ที่มี "Horsegirl" ในชื่อ
                    if not racingGui then
                        for _, gui in pairs(playerGui:GetChildren()) do
                            if gui:IsA("ScreenGui") and gui.Enabled and gui.Name:find("Horsegirl") then
                                racingGui = gui
                                break
                            end
                        end
                    end
                    
                    if racingGui and racingGui.Enabled then
                        local preferredOrder = {"AU BOAT", "SCIENTIST", "CONCERT", "JOY", "Damage", "Crit", "Speed", "Cost"}
                        local selectedButton = nil
                        
                        -- หา button ตามลำดับที่ต้องการ
                        for _, horseName in ipairs(preferredOrder) do
                            for _, btn in pairs(racingGui:GetDescendants()) do
                                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                                    -- ⭐ FIX: ImageButton ไม่มี .Text - เช็คเฉพาะ TextButton
                                    local btnText = ""
                                    if btn:IsA("TextButton") then
                                        btnText = (btn.Text or ""):upper()
                                    end
                                    local btnName = (btn.Name or ""):upper()
                                    local parentName = btn.Parent and (btn.Parent.Name or ""):upper() or ""
                                    
                                    if btnText:find(horseName:upper()) or btnName:find(horseName:upper()) or 
                                       parentName:find(horseName:upper()) then
                                        selectedButton = btn
                                        break
                                    end
                                end
                            end
                            if selectedButton then break end
                        end
                        
                        -- ถ้าไม่เจอ หา "Choose" button ทั่วไป
                        if not selectedButton then
                            for _, btn in pairs(racingGui:GetDescendants()) do
                                -- ⭐ FIX: ImageButton ไม่มี .Text - เช็คเฉพาะ TextButton
                                local btnText = ""
                                if btn:IsA("TextButton") then
                                    btnText = (btn.Text or ""):lower()
                                end
                                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and 
                                   ((btn.Name or ""):lower():find("choose") or btnText:find("choose")) then
                                    selectedButton = btn
                                    break
                                end
                            end
                        end
                        
                        -- คลิก button ที่เลือก
                        if selectedButton then
                            pcall(function()
                                for _, connection in pairs(getconnections(selectedButton.MouseButton1Click)) do
                                    connection:Fire()
                                end
                                for _, connection in pairs(getconnections(selectedButton.Activated)) do
                                    connection:Fire()
                                end
                            end)
                            print(string.format("[AbilitySystem] ✅ %s → Horsegirl Racing", unitName))
                            
                            -- ปิด GUI หลัง 0.5 วินาที
                            task.wait(0.5)
                            pcall(function()
                                racingGui.Enabled = false
                            end)
                        end
                    end
                end)
            end
        end
        return success
    end  -- ปิด if Horsegirl
    
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ║          PLACEMENT ABILITIES (AUTO) - ก่อน NeedsPlacement!            ║
    -- ║  ⭐⭐⭐ ย้ายมาไว้ก่อนเพื่อไม่ให้ถูก block โดย section 7              ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    
    -- Helper function สำหรับหาตำแหน่ง (ไม่มีทาง nil)
    local function GetValidPosition(unit, unitRange)
        local targetPos = nil
        
        -- 1. ลอง GetBestPlacementPosition
        if GetBestPlacementPosition then
            local success, result = pcall(function()
                return GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit.Data)
            end)
            if success and result then
                targetPos = result
            end
        end
        
        -- 2. ลอง GetFrontPlacementPosition
        if not targetPos and GetFrontPlacementPosition then
            local success, result = pcall(function()
                return GetFrontPlacementPosition()
            end)
            if success and result then
                targetPos = result
            end
        end
        
        -- 3. Fallback: ใช้ตำแหน่ง unit เอง + offset
        if not targetPos and unit and unit.Model then
            local success, pos = pcall(function()
                return unit.Model:GetPivot().Position
            end)
            if success and pos then
                targetPos = pos + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            end
        end
        
        -- 4. หา enemy ที่หน้าสุด
        if not targetPos then
            local frontEnemy = GetFrontmostEnemy()
            if frontEnemy and frontEnemy.Position then
                targetPos = frontEnemy.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
        
        -- 5. Final fallback: ใช้ตำแหน่งกลาง map
        if not targetPos then
            -- ลองหาตำแหน่งจาก workspace.Map
            local success, mapPos = pcall(function()
                if workspace:FindFirstChild("Map") then
                    local map = workspace.Map
                    if map:FindFirstChild("Path") then
                        local path = map.Path
                        for _, part in pairs(path:GetChildren()) do
                            if part:IsA("BasePart") then
                                return part.Position
                            end
                        end
                    end
                end
                return nil
            end)
            if success and mapPos then
                targetPos = mapPos
            else
                targetPos = Vector3.new(0, 5, 0)
            end
        end
        
        return targetPos
    end
    
    -- Helper function สำหรับส่ง placement (ไม่มี cache)
    local function SendAutoPlacement(context, guid, targetPos, nextContext, nextPos)
        if not targetPos or not targetPos.X or not targetPos.Y or not targetPos.Z then
            print("[AbilitySystem] ❌ Invalid target position!")
            return false
        end
        
        -- Set PendingPlacement
        _G.APSkill.PendingPlacement[context] = {
            TargetPos = targetPos,
            GUID = guid,
            NextContext = nextContext,
            NextPos = nextPos
        }
        
        print(string.format("[AbilitySystem] ✅ Set PendingPlacement for %s", context))
        
        -- Activate ability
        local success, err = pcall(function()
            AbilityEvent:FireServer("Activate", guid, abilityName)
        end)
        
        if success then
            print("[AbilitySystem] ✅ Ability activated")
            
            -- ⭐⭐⭐ ไม่ต้องส่ง position ที่นี่! รอให้ OnClientEvent ทำงานแทน
            -- OnClientEvent จะถูกเรียกเมื่อ game พร้อมรับ placement
            
            AbilityLastUsed[abilityKey] = tick()
            return true
        else
            print(string.format("[AbilitySystem] ❌ Failed: %s", tostring(err)))
            _G.APSkill.PendingPlacement[context] = nil
            return false
        end
    end
    
    -- 1. INSTANT TELEPORTATION (Rogita)
    if abilityName and abilityName:find("Instant Teleportation") then
        print(string.format("[AbilitySystem] 🌀 Instant Teleportation: %s", unitName))
        
        local unitRange = unit.Data.Range or 30
        local targetPos = GetValidPosition(unit, unitRange)
        
        -- พยายามหาตำแหน่งใกล้ศัตรู
        local frontEnemy = GetFrontmostEnemy()
        if frontEnemy and frontEnemy.Position then
            local currentPos = unit.Model:GetPivot().Position
            local dirToEnemy = (frontEnemy.Position - currentPos).Unit
            local distance = math.min(unitRange * 0.5, 15)
            local nearEnemyPos = frontEnemy.Position - dirToEnemy * distance
            targetPos = Vector3.new(nearEnemyPos.X, targetPos.Y, nearEnemyPos.Z)
        end
        
        return SendAutoPlacement("Rogita", guid, targetPos)
    end
    
    -- 2. MONKEY KING'S FUR (Clone) - ส่ง position ตรงๆ!
    if abilityName:find("Fur") and unitName:find("Monkey") then
        print(string.format("[AbilitySystem] 🐵 Monkey King's Fur: %s", unitName))
        
        local clonePos = nil
        local unitRange = unit.Data.Range or 30
        
        -- Priority 1: GetBestPlacementPosition
        if GetBestPlacementPosition then
            clonePos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit.Data)
        end
        
        -- Priority 2: GetFrontPlacementPosition
        if not clonePos or clonePos == Vector3.new(0, 0, 0) then
            clonePos = GetFrontPlacementPosition()
        end
        
        -- Priority 3: GetValidPosition
        if not clonePos or clonePos == Vector3.new(0, 0, 0) then
            clonePos = GetValidPosition(unit, unitRange)
        end
        
        print(string.format("[AbilitySystem] 📍 Clone position: (%.1f, %.1f, %.1f)", 
            clonePos.X, clonePos.Y, clonePos.Z))
        
        -- ⭐⭐⭐ ส่ง position ตรงๆ แบบ TYPE 3: CLONE
        if AbilityEvent and clonePos then
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName, clonePos)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print(string.format("[AbilitySystem] ✅ Monkey King clone placed!"))
                return true
            else
                print(string.format("[AbilitySystem] ❌ Failed: %s", tostring(err)))
            end
        end
        
        return false
    end
    
    -- 3. WAYWARD JOURNEY (Friran) - ส่ง position ตรงๆ! (แค่ start position)
    if abilityName and abilityName:find("Wayward Journey") then
        print(string.format("[AbilitySystem] ✨ Wayward Journey: %s", unitName))
        
        local unitRange = unit.Data.Range or 30
        
        -- ⭐ หาตำแหน่ง start บน Path
        local startPos = nil
        if GetFrontPlacementPosition then
            startPos = GetFrontPlacementPosition()
        end
        if not startPos or startPos == Vector3.new(0, 0, 0) then
            if GetBestPlacementPosition then
                startPos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit.Data)
            end
        end
        if not startPos or startPos == Vector3.new(0, 0, 0) then
            startPos = GetValidPosition(unit, unitRange)
        end
        
        print(string.format("[AbilitySystem] 📍 Start position: (%.1f, %.1f, %.1f)", 
            startPos.X, startPos.Y, startPos.Z))
        
        -- ⭐⭐⭐ Friran ต้องส่ง position ตรงๆ (game จะขอ end position อีกครั้ง)
        if AbilityEvent and startPos then
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName, startPos)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Friran journey started!")
                return true
            else
                print(string.format("[AbilitySystem] ❌ Failed: %s", tostring(err)))
            end
        end
        
        return false
    end
    
    -- 4. THIS IS ANOTHER ME (Valentine) - ส่ง position ตรงๆ!
    if abilityName and (abilityName:find("This is Another Me") or abilityName:find("Another Me")) then
        print(string.format("[AbilitySystem] 💘 Valentine Clone: %s", unitName))
        
        local clonePos = GetFrontPlacementPosition()
        local unitRange = unit.Data.Range or 30
        
        if not clonePos or clonePos == Vector3.new(0, 0, 0) then
            clonePos = GetValidPosition(unit, unitRange)
        end
        
        print(string.format("[AbilitySystem] 📍 Clone position: (%.1f, %.1f, %.1f)", 
            clonePos.X, clonePos.Y, clonePos.Z))
        
        -- ⭐⭐⭐ ส่ง position ตรงๆ แบบ TYPE 3: CLONE
        if AbilityEvent and clonePos then
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName, clonePos)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Valentine clone placed!")
                return true
            else
                print(string.format("[AbilitySystem] ❌ Failed: %s", tostring(err)))
            end
        end
        
        return false
    end
    
    -- 5. SMITH JOHN WEAPONS (EquipForgeWeapon)
    if abilityName and unitName and (abilityName:find("Equip") or abilityName:find("Weapon") or unitName:find("Smith John")) then
        print("[AbilitySystem] Smith John Weapon: " .. unitName)
        
        local unitRange = unit.Data.Range or 30
        local targetPos = GetValidPosition(unit, unitRange)
        
        return SendAutoPlacement("EquipForgeWeapon", guid, targetPos)
    end
    
    -- 6. GRAND FEAST (Master Chef)
    if abilityName:find("Grand Feast") or abilityName:find("Feast") then
        print("[AbilitySystem] Grand Feast: " .. unitName)
        
        local unitRange = unit.Data.Range or 30
        local targetPos = GetValidPosition(unit, unitRange)
        
        return SendAutoPlacement("SelectUnit", guid, targetPos)
    end
    
    -- 7. DABO 81
    if unitName and (unitName:find("Dabo") or unitName:find("81")) then
        print("[AbilitySystem] Dabo 81: " .. unitName)
        
        local unitRange = unit.Data.Range or 30
        local targetPos = GetValidPosition(unit, unitRange)
        
        return SendAutoPlacement("Dabo81", guid, targetPos)
    end
    
    -- 8. BERSERKER
    if unitName and unitName:find("Berserker") then
        print("[AbilitySystem] Berserker: " .. unitName)
        
        local unitRange = unit.Data.Range or 30
        local targetPos = GetValidPosition(unit, unitRange)
        
        return SendAutoPlacement("Berserker", guid, targetPos)
    end
    
    -- 7. PLACEMENT ABILITIES (Teleport, Spawn Alien, Clone, etc.) - OLD SECTION
    -- ⭐⭐⭐ ตอนนี้ Rogita ถูกย้ายขึ้นไปด้านบนแล้ว ไม่โดน block ที่นี่
    if abilityInfo.NeedsPlacement then
        local unitRange = abilityInfo.PlacementRange or 30
        local targetPos = nil
        
        -- ⭐ สุ่มตำแหน่งวาง (Random Placement)
        if unit and unit.Model then
            local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
            if hrp then
                local offset = math.random(10, 25)
                local angle = math.random() * math.pi * 2
                targetPos = hrp.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
            end
        end
        
        if not targetPos then
            targetPos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit and unit.Data)
        end
        
        if not targetPos then
            local frontEnemy = GetFrontmostEnemy()
            if frontEnemy and frontEnemy.Position then
                local offset = math.random(8, 15)
                local angle = math.random() * math.pi * 2
                targetPos = frontEnemy.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
            end
        end
        
        if not targetPos then
            targetPos = Vector3.new(0, 10, 0)
        end
        
        -- ⭐⭐⭐ TYPE CHECKING SYSTEM (IsTeleport, IsSpawnAlien, IsClone, etc.)
        -- Enabled for Emperor's Army and other abilities that need special handling
        
        -- TYPE 1: TELEPORT (Rogita - Instant Teleportation)
        -- ⭐⭐⭐ FIX: เกมจะเปิด placement GUI ให้ player click → เราต้อง auto-click ให้
        if abilityInfo.IsTeleport then
            local teleportPos = nil
            
            -- หา position ของ unit ปัจจุบัน
            local currentPos = nil
            if unit and unit.Model then
                local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
                if hrp then currentPos = hrp.Position end
            end
            
            -- คำนวณตำแหน่ง teleport
            if currentPos then
                local frontEnemy = GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    -- Teleport ไปใกล้ศัตรู (ข้างหน้า 5-15 studs)
                    local dirToEnemy = (frontEnemy.Position - currentPos).Unit
                    local randomOffset = math.random(5, 15)
                    teleportPos = frontEnemy.Position - dirToEnemy * randomOffset
                    -- ใช้ Y เดิม (ไม่ teleport ขึ้น/ลง)
                    teleportPos = Vector3.new(teleportPos.X, currentPos.Y, teleportPos.Z)
                else
                    -- ไม่มีศัตรู → teleport แบบสุ่ม (30-60 studs)
                    local randomDistance = math.random(30, 60)
                    local angle = math.random() * math.pi * 2
                    teleportPos = currentPos + Vector3.new(
                        math.cos(angle) * randomDistance, 
                        0, 
                        math.sin(angle) * randomDistance
                    )
                end
            else
                -- ไม่มี unit position → ใช้ targetPos
                teleportPos = targetPos
            end
            
            -- ⭐⭐⭐ STEP 1: ส่ง AbilityEvent เพื่อ trigger placement GUI
            if AbilityEvent and teleportPos then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName)
                end)
                
                if not success then
                    print(string.format("[AbilitySystem] ❌ Teleport activate failed: %s", tostring(err)))
                    return false
                end
                
                -- ⭐⭐⭐ STEP 2: รอ GUI ปรากฏ แล้ว auto-click ส่ง position
                task.spawn(function()
                    task.wait(0.3)  -- รอ GUI โหลดนานขึ้น
                    
                    -- หา MiscPlacementHandler
                    local MiscPlacementHandler = nil
                    pcall(function()
                        MiscPlacementHandler = require(ReplicatedStorage.Modules.Gameplay.MiscPlacementHandler)
                    end)
                    
                    if MiscPlacementHandler then
                        -- ⭐ วิธีที่ 1: ใช้ Confirm() โดยตรง (bypass GUI)
                        local confirmSuccess = pcall(function()
                            -- หา GUID ของ placement ที่กำลังรอ
                            local placementGUID = nil
                            for guid_key, data in pairs(MiscPlacementHandler._Placements or {}) do
                                if data then
                                    placementGUID = guid_key
                                    break
                                end
                            end
                            
                            if placementGUID and MiscPlacementHandler.Confirm then
                                -- ⭐ ส่ง position พร้อมกับ Confirm
                                MiscPlacementHandler:Confirm(placementGUID, teleportPos)
                                print(string.format("✅ Rogita → %s (Auto placed at %.1f, %.1f, %.1f)", 
                                    abilityName, teleportPos.X, teleportPos.Y, teleportPos.Z))
                            end
                        end)
                        
                        if not confirmSuccess then
                            -- ⭐ วิธีที่ 2: ส่งผ่าน RequestMiscPlacement
                            pcall(function()
                                local RequestMiscPlacement = ReplicatedStorage.Networking:FindFirstChild("RequestMiscPlacement")
                                if RequestMiscPlacement then
                                    RequestMiscPlacement:FireServer(guid, teleportPos)
                                    print(string.format("✅ Rogita → %s (Fallback method)", abilityName))
                                end
                            end)
                        end
                    else
                        print("[AbilitySystem] ⚠️ MiscPlacementHandler not found, using direct send")
                        
                        -- Fallback: ส่งตรงๆ
                        local RequestMiscPlacement = ReplicatedStorage.Networking:FindFirstChild("RequestMiscPlacement")
                        if RequestMiscPlacement then
                            RequestMiscPlacement:FireServer(guid, teleportPos)
                            print(string.format("✅ Rogita → %s (Direct send)", abilityName))
                        end
                    end
                end)
                
                AbilityLastUsed[abilityKey] = tick()
                success = true
            else
                print("[AbilitySystem] ❌ AbilityEvent or teleportPos missing")
                success = false
            end
            
        -- TYPE 2: SPAWN ALIEN (Emperor's Army) - spawn Alien Cadet ONLY
        elseif abilityInfo.IsSpawnAlien then
            print("[AbilitySystem] 🟢 TYPE: SPAWN ALIEN ability - spawning Alien Cadet ONLY")
            
            -- ⭐⭐⭐ FIX: วาง Alien Cadet เท่านั้น (ตามรูป 3 ที่ user ให้มา)
            local alienCadetID = nil
            
            -- หา ID จาก EntityIDHandler
            if EntityIDHandler and EntityIDHandler.GetIDFromName then
                local getSuccess, getResult = pcall(function()
                    return EntityIDHandler:GetIDFromName("Unit", "Alien Cadet")
                end)
                if getSuccess and getResult then
                    alienCadetID = getResult
                    print(string.format("[AbilitySystem]   → Found Alien Cadet ID: %s", tostring(alienCadetID)))
                else
                    print(string.format("[AbilitySystem]   → Failed to get Alien Cadet ID: %s", tostring(getResult)))
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
            
            print(string.format("[AbilitySystem]   → Alien Cadet count: %d/%d", currentAlienCount, alienLimit))
            
            if currentAlienCount >= alienLimit then
                print("[AbilitySystem]   → ⚠️ Alien Cadet limit reached! Skipping spawn.")
            else
                -- ⭐⭐⭐ พยายาม spawn ด้วยวิธีต่างๆ
                local spawned = false
                
                -- วิธีที่ 1: ใช้ UnitEvent (preferred)
                if UnitEvent and alienCadetID then
                    success, err = pcall(function()
                        UnitEvent:FireServer("Render", 
                            {"Alien Cadet", alienCadetID, targetPos, 0, nil},
                            {FromUnitGUID = guid}
                        )
                    end)
                    if success then
                        AbilityLastUsed[abilityKey] = tick()
                        print(string.format("[AbilitySystem]   → ✅ Alien Cadet spawned at (%.1f, %.1f, %.1f)!", targetPos.X, targetPos.Y, targetPos.Z))
                        spawned = true
                    else
                        print(string.format("[AbilitySystem]   → ❌ UnitEvent failed: %s", tostring(err)))
                    end
                end
                
                -- วิธีที่ 2: FALLBACK - ใช้ AbilityEvent
                if not spawned and AbilityEvent then
                    print("[AbilitySystem]   → Trying AbilityEvent fallback...")
                    success, err = pcall(function()
                        AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                    end)
                    if success then
                        AbilityLastUsed[abilityKey] = tick()
                        print("[AbilitySystem]   → ✅ AbilityEvent fallback successful!")
                        spawned = true
                    end
                end
                
                -- ไม่สามารถ spawn ได้เลย - silent (ลด spam)
            end
            
        -- TYPE 3: CLONE
        elseif abilityInfo.IsClone then
            local clonePos = nil
            
            pcall(function()
                clonePos = GetBestPlacementPosition(unitRange, GetGamePhase(), unitName, unit and unit.Data)
            end)
            
            if not clonePos then
                local frontEnemy = GetFrontmostEnemy()
                if frontEnemy and frontEnemy.Position then
                    local offset = math.random(8, 15)
                    local angle = math.random() * math.pi * 2
                    clonePos = frontEnemy.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
                end
            end
            
            if not clonePos and unit and unit.Model then
                local hrp = unit.Model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local offset = math.random(8, 15)
                    local angle = math.random() * math.pi * 2
                    clonePos = hrp.Position + Vector3.new(math.cos(angle) * offset, 0, math.sin(angle) * offset)
                end
            end
            
            if not clonePos then
                clonePos = targetPos
            end
            
            if AbilityEvent then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, clonePos)
                end)
                
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("✅ Auto enabled: %s → %s", unitName, abilityName))
                end
            end
            
        -- TYPE 4: DEFAULT PLACEMENT
        else
            print(string.format("[AbilitySystem] 🎯 Default placement ability: %s", abilityName))
            print(string.format("[AbilitySystem] 📍 Position: (%.1f, %.1f, %.1f)", 
                targetPos.X, targetPos.Y, targetPos.Z))
            
            if AbilityEvent then
                success, err = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName, targetPos)
                end)
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[AbilitySystem] ✅ %s PLACEMENT SUCCESS!", unitName))
                else
                    print(string.format("[AbilitySystem] ❌ Placement failed: %s", tostring(err)))
                end
            else
                print("[AbilitySystem] ❌ AbilityEvent not found")
            end
        end  -- Close TYPE 4
        
        return success
    end  -- ปิด if Placement
    
    -- 8. CHARGE ABILITIES (Lizard Heat Overload, etc.)
    if abilityInfo.IsChargeAbility or (abilityName and abilityName:find("Heat")) or (abilityName and abilityName:find("Overload")) then
        print(string.format("[AbilitySystem] ⚡ Charge Ability: %s", abilityName))
        
        -- หา HeatOverload Event
        local HeatOverloadEvent = nil
        pcall(function()
            HeatOverloadEvent = Networking.Units["Update 9.0"].HeatOverload
        end)
        
        if not HeatOverloadEvent then
            print("[AbilitySystem] ❌ HeatOverloadEvent not found")
            return false
        end
        
        -- Auto Charge และ Shoot
        success, err = pcall(function()
            -- Charge
            HeatOverloadEvent:FireServer("Charge", guid)
            print(string.format("[AbilitySystem] ⚡ Charging: %s", unitName))
            
            -- รอ charge เต็ม (0.5 วินาที = 25% power, 2 วินาที = 100%)
            task.wait(2.5) -- Charge เกือบเต็ม
            
            -- Shoot
            HeatOverloadEvent:FireServer("Shoot", guid)
            print(string.format("[AbilitySystem] 🎯 Shot: %s (100%% power)", unitName))
        end)
        
        if success then
            AbilityLastUsed[abilityKey] = tick()
            return true
        else
            print(string.format("[AbilitySystem] ❌ Charge failed: %s", tostring(err)))
            return false
        end
    end  -- ปิด if Charge
    
    -- 9. MINI GAME ABILITIES (Skele King Rock, etc.)
    if abilityInfo.IsMiniGame or (unitName and unitName:find("Skele")) or (abilityName and abilityName:find("Hell")) then
        print(string.format("[AbilitySystem] 🎮 Mini Game: %s → %s", unitName, abilityName))
        
        -- หา GUI
        local playerGui = plr:FindFirstChild("PlayerGui")
        if not playerGui then return false end
        
        local rhythmGui = playerGui:FindFirstChild("Rhythm")
        if not rhythmGui then
            print("[AbilitySystem] ⚠️ Rhythm GUI not found - trying to activate")
            
            -- ลองเปิด ability ก่อน
            if AbilityEvent then
                pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName)
                end)
                task.wait(0.5)
                rhythmGui = playerGui:FindFirstChild("Rhythm")
            end
        end
        
        if rhythmGui and rhythmGui.Enabled then
            print("[AbilitySystem] 🎮 Playing mini game...")
            
            -- หา keys ที่ต้องกด
            local holder = rhythmGui:FindFirstChild("Holder")
            if not holder or not holder:FindFirstChild("Main") then
                print("[AbilitySystem] ❌ Rhythm GUI structure not found")
                return false
            end
            
            local main = holder.Main
            local keysPressed = 0
            
            -- กด keys ทั้งหมด (A, S, D, F, G)
            local keys = {"A", "S", "D", "F", "G"}
            local UserInputService = game:GetService("UserInputService")
            
            task.spawn(function()
                for i = 1, 20 do -- เล่น 20 รอบ
                    for _, keyName in ipairs(keys) do
                        -- จำลองการกดปุ่ม
                        pcall(function()
                            local key = Enum.KeyCode[keyName]
                            UserInputService.InputBegan:Fire({
                                KeyCode = key,
                                UserInputType = Enum.UserInputType.Keyboard
                            })
                            
                            task.wait(0.05)
                            
                            UserInputService.InputEnded:Fire({
                                KeyCode = key,
                                UserInputType = Enum.UserInputType.Keyboard
                            })
                        end)
                        
                        keysPressed = keysPressed + 1
                        task.wait(0.1)
                    end
                    
                    task.wait(0.2)
                end
                
                print(string.format("[AbilitySystem] ✅ Mini Game completed! (%d keys)", keysPressed))
            end)
            
            AbilityLastUsed[abilityKey] = tick()
            return true
        else
            print("[AbilitySystem] ⚠️ Rhythm GUI not active")
            return false
        end
    end  -- ปิด if MiniGame
    
    -- 10. HOLLOWSEPH VOID SPELLS (Embrace the Void, Shade Strike, Ascending Dark, Dream Nail)
    if unitName and (unitName:find("Hollowseph") or unitName:find("Hollow")) then
        if not _G.CastHollowsephSpellEvent then
            print("[AbilitySystem] ❌ CastHollowsephSpellEvent not found")
            return false
        end
        
        -- ⭐ ดึง Mana และ Cost จาก PlayerGui.Spells
        local playerGui = plr:FindFirstChild("PlayerGui")
        if not playerGui then return false end
        
        local spellsGui = playerGui:FindFirstChild("Spells")
        if not spellsGui then return false end
        
        local mainHolder = spellsGui:FindFirstChild("Holder")
        if not mainHolder then return false end
        
        local main = mainHolder:FindFirstChild("Main")
        if not main then return false end
        
        -- ⭐ หา spell ที่ตรงกับ abilityName
        local spellName = nil
        local spellButton = nil
        local spellCost = 0
        
        -- Map ability name to spell name
        if abilityName and (abilityName:find("Embrace") or abilityName:find("Void")) then
            spellName = "EmbraceTheVoid"
        elseif abilityName and (abilityName:find("Shade") or abilityName:find("Strike")) then
            spellName = "ShadeStrike"
        elseif abilityName and (abilityName:find("Ascending") or abilityName:find("Dark")) then
            spellName = "AscendingDark"
        elseif abilityName and (abilityName:find("Dream") or abilityName:find("Nail")) then
            spellName = "DreamNail"
        end
        
        if not spellName then
            print(string.format("[AbilitySystem] ❌ Unknown Hollowseph spell: %s", abilityName))
            return false
        end
        
        local spellFrame = main:FindFirstChild(spellName)
        if not spellFrame then
            print(string.format("[AbilitySystem] ❌ Spell frame not found: %s", spellName))
            return false
        end
        
        -- ⭐ อ่าน Cost จาก GUI
        local costLabel = spellFrame:FindFirstChild("Cost")
        if costLabel then
            local costText = costLabel:FindFirstChild("Label")
            if costText then
                local costStr = tostring(costText.Text):match("%d+")
                spellCost = tonumber(costStr) or 0
            end
        end
        
        -- ⭐ อ่าน Mana ปัจจุบัน
        local currentMana = 0
        local manaBar = mainHolder:FindFirstChild("Mana")
        if manaBar then
            local manaLabel = manaBar:FindFirstChild("Label")
            if manaLabel then
                local manaText = tostring(manaLabel.Text)
                local currentStr = manaText:match("(%d+)/")
                currentMana = tonumber(currentStr) or 0
            end
        end
        
        -- ⭐ เช็คว่า Mana พอหรือไม่
        if currentMana < spellCost then
            return false, string.format("Not enough Mana (%d < %d)", currentMana, spellCost)
        end
        
        -- ⭐ เช็คว่า spell พร้อมใช้หรือไม่ (ปุ่มไม่ disabled)
        local useFrame = spellFrame:FindFirstChild("Use")
        if useFrame then
            local button = useFrame:FindFirstChild("Button")
            if button and button:FindFirstChild("ImageLabel") then
                local transparency = button.ImageLabel.ImageTransparency
                -- ถ้า transparency > 0.5 แสดงว่า disabled
                if transparency > 0.5 then
                    return false, "Spell on cooldown"
                end
            end
        end
        
        -- ⭐ Cast spell
        success, err = pcall(function()
            _G.CastHollowsephSpellEvent:FireServer(guid, spellName)
        end)
        
        if success then
            AbilityLastUsed[abilityKey] = tick()
            print(string.format("[AbilitySystem] ✅ Auto enabled: %s → %s (Cost: %d Mana)", unitName, spellName, spellCost))
        else
            print(string.format("[AbilitySystem] ❌ Failed to cast %s: %s", spellName, tostring(err)))
        end
        
        return success
    end  -- ปิด if Hollowseph
    
    -- 9. WORLD ITEMS (Caloric Stone, Ouroboros) - ⭐⭐⭐ DISABLED - ใช้ Auto Loop แทน!
    -- Caloric Stone ถูกจัดการโดย Auto Caloric Stone System ด้านล่างแล้ว
    if abilityInfo.IsWorldItem then
        -- ⭐⭐⭐ SKIP - ให้ Auto Loop จัดการแทน
        return false
    end
    
    --[[  ⭐⭐⭐ OLD CODE - DISABLED
    if abilityInfo.IsWorldItem then
        local CurrentWave, MaxWave = GetWaveFromUI()
        
        -- World Item ใช้ได้ 1 ครั้งต่อ match
        if _G.APSkill and _G.APSkill.WorldItemUsedThisMatch then
            return false
        end
        
        -- ⭐⭐⭐ FIX: เช็ค Caloric Stone ใช้ไปแล้วหรือยัง (Per Once)
        local caloricOnceKey = "CaloricStone_Used"
        if AbilityUsedOnce[caloricOnceKey] then
            return false
        end
        
        local isMaxWave = (CurrentWave >= MaxWave - 1)
        
        -- ⭐⭐⭐ FIX: เช็ค Emergency Mode จาก _G.APState (ถ้ามี) - ไม่ใช้ Caloric ตอน Emergency
        local isEmergency = _G.APState and _G.APState.IsEmergency or false
        if isEmergency then
            -- Emergency mode = ไม่ใช้ Caloric Stone (ให้ AutoPlay จัดการ)
            return false
        end
        
        -- Caloric Stone - ใช้หลัง Wave 3
        if CurrentWave < 3 then
            return false
        end
        
        if CaloricStoneEvent then
            local damageUnits = {}
            
            -- ⭐⭐⭐ STEP 1: หา units ที่ equip อยู่ใน Hotbar (6 ตัว) เพื่อกรองออก
            local equippedUnitIds = {}
            if UnitsModule and UnitsModule._Cache then
                for slot, cacheData in pairs(UnitsModule._Cache) do
                    if cacheData and cacheData ~= "None" then
                        local id = cacheData.UniqueIdentifier or cacheData.Identifier or cacheData.ID
                        if id then
                            equippedUnitIds[tostring(id)] = true
                        end
                        -- เก็บชื่อด้วยเพื่อ double-check
                        local name = cacheData.Name or (cacheData.Data and cacheData.Data.Name)
                        if name then
                            equippedUnitIds[name .. "_" .. tostring(slot)] = true
                        end
                    end
                end
            end
            
            -- ⭐⭐⭐ DEBUG: แสดงสถานะ OwnedUnitsHandler
            if not _G.APSkill.CaloricDebugShown then
                print("[AbilitySystem] 🔧 Caloric Stone Debug:")
                print(string.format("  → OwnedUnitsHandler: %s", OwnedUnitsHandler and "✅" or "❌"))
                if OwnedUnitsHandler then
                    print(string.format("  → GetOwnedUnits method: %s", OwnedUnitsHandler.GetOwnedUnits and "✅" or "❌"))
                    print(string.format("  → _OwnedUnits: %s", OwnedUnitsHandler._OwnedUnits and "✅" or "❌"))
                end
                local equipCount = 0
                for _ in pairs(equippedUnitIds) do equipCount = equipCount + 1 end
                print(string.format("  → Equipped units (to exclude): %d", equipCount))
                _G.APSkill.CaloricDebugShown = true
            end
            
            -- ⭐⭐⭐ STEP 2: หา units ทั้งหมดจาก OwnedUnitsHandler
            local ownedUnits = nil
            
            -- วิธี 1: ใช้ GetOwnedUnits()
            if OwnedUnitsHandler and OwnedUnitsHandler.GetOwnedUnits then
                pcall(function()
                    ownedUnits = OwnedUnitsHandler:GetOwnedUnits()
                end)
            end
            
            -- วิธี 2: ใช้ _OwnedUnits โดยตรง
            if not ownedUnits and OwnedUnitsHandler and OwnedUnitsHandler._OwnedUnits then
                ownedUnits = OwnedUnitsHandler._OwnedUnits
            end
            
            -- ⭐⭐⭐ STEP 3: กรองเอาเฉพาะ units ที่ไม่ได้ equip
            if ownedUnits then
                for unitGUID, unitEntry in pairs(ownedUnits) do
                    local identifier = unitEntry.Identifier
                    local uniqueId = unitEntry.UniqueIdentifier or unitGUID
                    local unitData = unitEntry.UnitData or unitEntry
                    local unitName = unitData and unitData.Name or ""
                    
                    -- ⭐⭐⭐ CHECK: ถ้า unit นี้อยู่ใน hotbar แล้ว → ข้าม!
                    local isEquipped = false
                    if equippedUnitIds[tostring(uniqueId)] then
                        isEquipped = true
                    elseif equippedUnitIds[tostring(identifier)] then
                        isEquipped = true
                    end
                    
                    -- ⭐ ถ้า equip แล้ว → ข้าม
                    if isEquipped then
                        -- Skip this unit (it's in hotbar)
                    elseif unitName ~= "" then
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
            
            -- ⭐ ถ้าไม่มี damage units ใน bag = skip
            if #damageUnits == 0 then
                print("[AbilitySystem] ❌ Caloric Stone: No unequipped damage units in bag!")
                return false
            end
            
            -- เรียงจาก DPS สูงไปต่ำ
            table.sort(damageUnits, function(a, b)
                return a.DPS > b.DPS
            end)
            
            -- ⭐⭐⭐ DEBUG: แสดง top 3 หลัง SORT
            if not _G.APSkill.CaloricUnitsDebugShown then
                print(string.format("[AbilitySystem] 🔧 Caloric Stone: Found %d damage units (sorted by DPS)", #damageUnits))
                for i = 1, math.min(3, #damageUnits) do
                    local u = damageUnits[i]
                    print(string.format("  → %d. %s (DPS: %.1f)", i, u.Name, u.DPS))
                end
                _G.APSkill.CaloricUnitsDebugShown = true
            end
            
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
                -- เงินไม่พอ = skip (silent, no spam)
                return false
            end
            
            local targetIdentifier = bestUnit.UniqueIdentifier or bestUnit.Identifier or bestUnit.ID
            
            success, err = pcall(function()
                CaloricStoneEvent:FireServer(targetIdentifier, guid)
            end)
            
            if success then
                print(string.format("[AbilitySystem] ✅ Caloric Stone → %s", bestUnit.Name))
                
                -- ⭐⭐⭐ SET FLAGS IMMEDIATELY - ป้องกัน spam
                _G.APSkill.WorldItemUsedThisMatch = true
                AbilityUsedOnce[caloricOnceKey] = true
                AbilityLastUsed[abilityKey] = tick()
                
                -- ⭐⭐⭐ FIX: รอให้เกมสร้าง unit clone ก่อนแล้วค่อยวาง
                task.spawn(function()
                    -- รอ 1 วินาทีให้เกมสร้าง unit clone เสร็จก่อน
                    task.wait(1.0)
                    
                    local unitName = bestUnit.Name
                    local numericID = bestUnit.Identifier or bestUnit.ID
                    local unitRange = 25
                    
                    pcall(function()
                        if bestUnit.Data and bestUnit.Data.Range then
                            unitRange = bestUnit.Data.Range
                        end
                    end)
                    
                    -- ⭐⭐⭐ FIX: หา clone unit ที่เกมเพิ่งสร้างขึ้นมา
                    local cloneGUID = nil
                    local cloneUnit = nil
                    
                    pcall(function()
                        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                            -- หา unit ที่มีชื่อตรงกับ bestUnit.Name และยังไม่ได้วาง (ไม่มี Position หรือ Position = 0,0,0)
                            for unitGuid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                                if activeUnit and activeUnit.Name == unitName then
                                    -- เช็คว่า unit นี้ยังไม่ได้วางหรือเปล่า
                                    local isNotPlaced = false
                                    
                                    -- วิธี 1: เช็คว่ายังไม่มี Model
                                    if not activeUnit.Model or not activeUnit.Model.Parent then
                                        isNotPlaced = true
                                    end
                                    
                                    -- วิธี 2: เช็คว่า Position เป็น 0,0,0
                                    if not isNotPlaced and activeUnit.Model then
                                        local success, position = pcall(function()
                                            return activeUnit.Model:GetPivot().Position
                                        end)
                                        
                                        if success and position then
                                            local magnitude = position.Magnitude
                                            if magnitude < 1 then  -- Position ใกล้ 0,0,0
                                                isNotPlaced = true
                                            end
                                        end
                                    end
                                    
                                    -- วิธี 3: เช็คว่าเป็น unit ที่เพิ่งถูกสร้างใหม่ (ไม่อยู่ใน CaloricCloneUnits)
                                    if not isNotPlaced and not CaloricCloneUnits[unitGuid] then
                                        isNotPlaced = true
                                    end
                                    
                                    if isNotPlaced then
                                        cloneGUID = unitGuid
                                        cloneUnit = activeUnit
                                        print(string.format("[AbilitySystem] 🎯 Found clone unit: %s (GUID: %s)", unitName, unitGuid))
                                        break
                                    end
                                end
                            end
                        end
                    end)
                    
                    -- ถ้าไม่เจอ clone unit = ลองรอเพิ่มอีก 1 วินาที
                    if not cloneGUID then
                        print("[AbilitySystem] ⏳ Clone not found, waiting 1 more second...")
                        task.wait(1.0)
                        
                        pcall(function()
                            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                                for unitGuid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                                    if activeUnit and activeUnit.Name == unitName and not CaloricCloneUnits[unitGuid] then
                                        cloneGUID = unitGuid
                                        cloneUnit = activeUnit
                                        print(string.format("[AbilitySystem] 🎯 Found clone unit (retry): %s (GUID: %s)", unitName, unitGuid))
                                        break
                                    end
                                end
                            end
                        end)
                    end
                    
                    if not cloneGUID then
                        print("[AbilitySystem] ❌ Caloric Stone: Could not find clone unit to place!")
                        return
                    end
                    
                    local targetPos = nil
                    
                    -- ⭐⭐⭐ PRIORITY 1: ใช้ GetVerifiedPlacementPosition (SYNC กับ Damage Unit!)
                    -- เพื่อให้ Caloric Clone วางที่เดียวกับ Damage Unit
                    pcall(function()
                        if _G.GetVerifiedPlacementPosition then
                            local gamePhase = _G.GetGamePhase and _G.GetGamePhase() or "mid"
                            targetPos = _G.GetVerifiedPlacementPosition(unitRange, gamePhase, unitName, bestUnit.Data, 3)
                            if targetPos then
                                print(string.format("[AbilitySystem] ✅ Caloric Stone: Using VERIFIED position (%.1f, %.1f, %.1f) - SYNC with Damage!",
                                    targetPos.X, targetPos.Y, targetPos.Z))
                            end
                        end
                    end)
                    
                    -- ⭐⭐⭐ PRIORITY 2: ใช้ GetBestPlacementPosition (fallback)
                    if not targetPos then
                        pcall(function()
                            if _G.GetBestPlacementPosition then
                                local gamePhase = _G.GetGamePhase and _G.GetGamePhase() or "mid"
                                targetPos = _G.GetBestPlacementPosition(unitRange, gamePhase, unitName, bestUnit.Data)
                                if targetPos then
                                    print(string.format("[AbilitySystem] ⚠️ Caloric Stone: Using BestPlacement (%.1f, %.1f, %.1f)",
                                        targetPos.X, targetPos.Y, targetPos.Z))
                                end
                            end
                        end)
                    end
                    
                    -- ⭐⭐⭐ PRIORITY 3: หาจาก CachedUCenters
                    if not targetPos then
                        pcall(function()
                            local uCenters = _G.APState and _G.APState.CachedUCenters
                            if uCenters and #uCenters > 0 then
                                targetPos = uCenters[1]
                            end
                        end)
                    end
                    
                    -- ⭐⭐⭐ PRIORITY 4: หาจาก unit ที่วางอยู่แล้ว (ใกล้ๆ กัน) - เลือกเฉพาะตำแหน่งที่ตีถึง path
                    if not targetPos then
                        pcall(function()
                            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                                local path = _G.GetMapPath and _G.GetMapPath() or {}
                                
                                for unitGuid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                                    -- ข้าม clone unit ที่เพิ่งสร้าง
                                    if unitGuid ~= cloneGUID and activeUnit and activeUnit.Model then
                                        local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                                        if hrp then
                                            -- ทดสอบหลายตำแหน่งรอบๆ unit
                                            for i = 1, 8 do
                                                local angle = (i / 8) * math.pi * 2
                                                local offset = math.random(5, 12)
                                                local testPos = hrp.Position + Vector3.new(
                                                    math.cos(angle) * offset,
                                                    0,
                                                    math.sin(angle) * offset
                                                )
                                                
                                                -- เช็คว่าตี path ได้หรือไม่
                                                local nodesInRange = 0
                                                for _, node in ipairs(path) do
                                                    if (testPos - node).Magnitude <= unitRange then
                                                        nodesInRange = nodesInRange + 1
                                                    end
                                                end
                                                
                                                if nodesInRange >= 1 then
                                                    -- เช็คว่าวางได้
                                                    local canPlace = true
                                                    if _G.CanPlaceAtPosition then
                                                        canPlace = _G.CanPlaceAtPosition(unitName, testPos)
                                                    end
                                                    
                                                    if canPlace then
                                                        targetPos = testPos
                                                        print(string.format("[AbilitySystem] ✅ Caloric Stone: Found position near unit (%.1f, %.1f) - nodesInRange=%d",
                                                            testPos.X, testPos.Z, nodesInRange))
                                                        break
                                                    end
                                                end
                                            end
                                            
                                            if targetPos then break end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    -- ⭐⭐⭐ วิธี 4: หาจาก Path nodes
                    if not targetPos then
                        pcall(function()
                            if workspace:FindFirstChild("Map") then
                                local map = workspace.Map
                                -- ลองหา Nodes ก่อน
                                if map:FindFirstChild("Nodes") then
                                    local nodes = map.Nodes:GetChildren()
                                    if #nodes > 0 then
                                        local midNode = nodes[math.floor(#nodes / 2)]
                                        if midNode and midNode:IsA("BasePart") then
                                            targetPos = midNode.Position + Vector3.new(10, 5, 10)
                                        end
                                    end
                                end
                                -- ถ้าไม่มี Nodes ลอง Path
                                if not targetPos and map:FindFirstChild("Path") then
                                    local pathParts = map.Path:GetChildren()
                                    if #pathParts > 0 then
                                        local midPath = pathParts[math.floor(#pathParts / 2)]
                                        if midPath and midPath:IsA("BasePart") then
                                            targetPos = midPath.Position + Vector3.new(10, 5, 10)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    -- ⭐⭐⭐ วิธี 5: หาจาก PlacementZones
                    if not targetPos then
                        pcall(function()
                            if workspace:FindFirstChild("Map") then
                                local map = workspace.Map
                                if map:FindFirstChild("PlacementZones") then
                                    for _, zone in pairs(map.PlacementZones:GetChildren()) do
                                        if zone:IsA("BasePart") then
                                            targetPos = zone.Position + Vector3.new(0, 5, 0)
                                            break
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    -- Final fallback
                    if not targetPos then
                        targetPos = Vector3.new(0, 10, 0)
                        print("[AbilitySystem] ⚠️ Caloric Stone: Using fallback position!")
                    end
                    
                    print(string.format("[AbilitySystem] 🎯 Caloric Stone placing clone %s at: (%.1f, %.1f, %.1f)", 
                        unitName, targetPos.X, targetPos.Y, targetPos.Z))
                    
                    -- ⭐⭐⭐ FIX: ใช้ UnitEvent:FireServer("Place", ...) แทน "Render"
                    -- เพราะ clone unit ถูกสร้างแล้ว แค่ต้องวางเท่านั้น
                    if targetPos and UnitEvent and cloneGUID then
                        local placeSuccess, placeError = pcall(function()
                            -- ลองวิธีที่ 1: ใช้ "Place" กับ GUID ของ clone unit
                            UnitEvent:FireServer("Place", cloneGUID, targetPos, 0)
                        end)
                        
                        if placeSuccess then
                            print(string.format("[AbilitySystem] ✅ Caloric Stone placed %s (GUID: %s) successfully!", 
                                unitName, cloneGUID))
                            
                            -- Track clone unit
                            CaloricCloneUnits[cloneGUID] = true
                        else
                            -- ลองวิธีที่ 2: ใช้ "Render" แบบเดิม
                            print(string.format("[AbilitySystem] ⚠️ Place method failed (%s), trying Render...", tostring(placeError)))
                            
                            local renderSuccess, renderError = pcall(function()
                                UnitEvent:FireServer("Render", {
                                    unitName,      -- [1] Name
                                    numericID,     -- [2] ID (numeric)
                                    targetPos,     -- [3] Position
                                    0              -- [4] Rotation
                                }, { FromUnitGUID = guid })
                            end)
                            
                            if renderSuccess then
                                print(string.format("[AbilitySystem] ✅ Caloric Stone placed %s at (%.1f, %.1f, %.1f) via Render", 
                                    unitName, targetPos.X, targetPos.Y, targetPos.Z))
                                CaloricCloneUnits[cloneGUID] = true
                            else
                                print(string.format("[AbilitySystem] ❌ Both Place and Render failed! Error: %s", tostring(renderError)))
                            end
                        end
                        
                        -- รอแล้ว track position
                        task.wait(1)
                        pcall(function()
                            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                                local placedUnit = ClientUnitHandler._ActiveUnits[cloneGUID]
                                if placedUnit and placedUnit.Model then
                                    local success, position = pcall(function()
                                        return placedUnit.Model:GetPivot().Position
                                    end)
                                    if success and position then
                                        print(string.format("[AbilitySystem] 📍 Clone unit %s position verified: (%.1f, %.1f, %.1f)", 
                                            unitName, position.X, position.Y, position.Z))
                                    end
                                end
                            end
                        end)
                    else
                        print("[AbilitySystem] ❌ Caloric Stone: No targetPos, UnitEvent, or cloneGUID!")
                    end
                end)
                
                return true
            end
        
        -- Ouroboros: ใช้เฉพาะด่านที่มี >= 50 waves + ถึง max wave
        elseif isMaxWave and MaxWave >= 50 and WorldItemEvent then
            success, err = pcall(function()
                WorldItemEvent:FireServer(guid, "Ouroboros")
            end)
            
            if success then
                print(string.format("[AbilitySystem] ✅ Ouroboros (%d/%d)", CurrentWave, MaxWave))
                _G.APSkill.WorldItemUsedThisMatch = true
                return true
            end
        end
        
        return false
    end  -- ปิด if World Items
    ]]
    
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ║                    PLACEMENT ABILITIES (AUTO)                          ║
    -- ║  ตาม decom_Ability.lua: EquipForgeWeapon, Friran, Rogita, Dabo81, etc ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    
    -- 1. INSTANT TELEPORTATION (Rogita) - Auto teleport to frontmost position
    if abilityName and (abilityName:find("Instant Teleportation") or abilityName:find("Rogita")) then
        -- คำนวณตำแหน่ง random เพื่อ test (±20 studs)
        local targetPos = nil
        local useRandomPos = true  -- เปลี่ยนเป็น false เพื่อใช้ตำแหน่งจริง
        
        if useRandomPos then
            local currentPos = unit.Model:GetPivot().Position
            local randomX = math.random(-20, 20)
            local randomZ = math.random(-20, 20)
            targetPos = currentPos + Vector3.new(randomX, 0, randomZ)
        else
            targetPos = GetFrontPlacementPosition()
        end
        
        if targetPos and AbilityEvent then
            -- ⭐⭐⭐ Set PendingPlacement สำหรับ OnClientEvent hook
            _G.APSkill.PendingPlacement["Rogita"] = {
                TargetPos = targetPos,
                GUID = guid
            }
            print("[AbilitySystem] ✅ Set PendingPlacement for Rogita")
            
            -- Activate ability
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                print("[AbilitySystem] ✅ Ability activated")
                
                -- ⭐⭐⭐ ส่ง position โดยตรงทันที (ไม่รอ OnClientEvent)
                task.spawn(function()
                    task.wait(0.3)  -- รอให้ server process
                    
                    local RequestMiscPlacement = ReplicatedStorage and ReplicatedStorage.Networking 
                        and ReplicatedStorage.Networking:FindFirstChild("RequestMiscPlacement")
                    
                    if RequestMiscPlacement then
                        print(string.format("[AbilitySystem] 📤 Sending position directly: (%.1f, %.1f, %.1f)", 
                            targetPos.X, targetPos.Y, targetPos.Z))
                        
                        local sendSuccess, sendErr = pcall(function()
                            RequestMiscPlacement:FireServer(guid, targetPos)
                        end)
                        
                        if sendSuccess then
                            print("[AbilitySystem] ✅ Position sent successfully!")
                        else
                            print(string.format("[AbilitySystem] ❌ Failed to send: %s", tostring(sendErr)))
                        end
                    else
                        print("[AbilitySystem] ❌ RequestMiscPlacement not found!")
                    end
                    
                    -- ล้าง PendingPlacement
                    _G.APSkill.PendingPlacement["Rogita"] = nil
                end)
                
                AbilityLastUsed[abilityKey] = tick()
                return true
            else
                print(string.format("[AbilitySystem] ❌ Failed: %s", tostring(err)))
                _G.APSkill.PendingPlacement["Rogita"] = nil  -- ล้างถ้า error
            end
        end
        
        return false
    end
    
    -- 4. WAYWARD JOURNEY (Friran) - Auto journey along track
    if abilityName and (abilityName:find("Wayward Journey") or abilityName:find("Journey")) then
        print(string.format("[AbilitySystem] 🗺️ Wayward Journey: %s", unitName))
        
        -- หา track points จาก workspace.Map.Path
        local startPoint = nil
        local endPoint = nil
        
        pcall(function()
            local mapPath = workspace:FindFirstChild("Map")
            if mapPath then
                mapPath = mapPath:FindFirstChild("Path")
                if mapPath then
                    local pathPoints = mapPath:GetChildren()
                    if #pathPoints >= 2 then
                        -- เริ่มจุดแรก ไปจุดสุดท้าย
                        startPoint = pathPoints[1].Position
                        endPoint = pathPoints[#pathPoints].Position
                        print(string.format("[AbilitySystem] 📍 Start: (%.1f, %.1f, %.1f)", 
                            startPoint.X, startPoint.Y, startPoint.Z))
                        print(string.format("[AbilitySystem] 📍 End: (%.1f, %.1f, %.1f)", 
                            endPoint.X, endPoint.Y, endPoint.Z))
                    end
                end
            end
        end)
        
        -- ⭐ Fallback: ถ้าหา path ไม่เจอ ใช้ gate position
        if not startPoint or not endPoint then
            print("[AbilitySystem] ⚠️ Path not found, using gate position...")
            pcall(function()
                if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Gate") then
                    local gatePos = workspace.Map.Gate.Position
                    -- Start ห่างจาก gate 50 studs, End ใกล้ gate
                    startPoint = gatePos - Vector3.new(0, 0, 50)
                    endPoint = gatePos - Vector3.new(0, 0, 10)
                end
            end)
        end
        
        if startPoint and endPoint and AbilityEvent then
            -- ⭐⭐ Friran ต้อง placement 2 ครั้ง: FriranStart → FriranEnd
            -- Set PendingPlacement สำหรับ FriranStart ก่อน
            _G.APSkill.PendingPlacement["FriranStart"] = {
                TargetPos = startPoint,
                GUID = guid,
                NextContext = "FriranEnd",  -- บอกว่ามี placement ต่อ
                NextPos = endPoint
            }
            print("[AbilitySystem] ✅ Set PendingPlacement for FriranStart")
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Friran journey will be auto-placed")
                return true
            else
                _G.APSkill.PendingPlacement["FriranStart"] = nil
            end
        end
        
        return false
    end
    
    -- 5. THE FORGE (Smith John) - Auto select best DPS unit to buff
    if abilityName and (abilityName:find("The Forge") or abilityName:find("Forge")) then
        print(string.format("[AbilitySystem] ⚒️ The Forge: %s", unitName))
        
        local targetUnit = SelectBestTargetUnit()
        
        if targetUnit and targetUnit.GUID and AbilityEvent then
            -- ⭐ Set PendingPlacement for "EquipForgeWeapon" context
            _G.APSkill.PendingPlacement["EquipForgeWeapon"] = {
                TargetUnit = targetUnit.GUID,
                GUID = guid,
                WeaponTier = 1  -- Default tier
            }
            print(string.format("[AbilitySystem] ✅ Set PendingPlacement for EquipForgeWeapon: %s", targetUnit.Name))
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ The Forge will auto-select unit")
                return true
            else
                _G.APSkill.PendingPlacement["EquipForgeWeapon"] = nil
            end
        end
        
        return false
    end
    
    -- 6. MASTERWORKS (Smith John) - Auto select best DPS unit for masterwork
    if abilityName and (abilityName:find("Masterworks") or abilityName:find("Masterwork")) then
        print(string.format("[AbilitySystem] ⚔️ Masterworks: %s", unitName))
        
        local targetUnit = SelectBestTargetUnit()
        
        if targetUnit and targetUnit.GUID and AbilityEvent then
            -- ⭐ Set PendingPlacement for "EquipForgeWeapon" context (same as The Forge)
            _G.APSkill.PendingPlacement["EquipForgeWeapon"] = {
                TargetUnit = targetUnit.GUID,
                GUID = guid,
                WeaponTier = 2  -- Masterwork = tier 2
            }
            print(string.format("[AbilitySystem] ✅ Set PendingPlacement for Masterworks: %s", targetUnit.Name))
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Masterworks will auto-select unit")
                return true
            else
                _G.APSkill.PendingPlacement["EquipForgeWeapon"] = nil
            end
        end
        
        return false
    end
    
    -- 7. GRAND FEAST (Master Chef) - REMOVED OLD CODE
    -- ⭐ ตอนนี้ใช้ระบบ PendingPlacement แทน
    if abilityName and (abilityName:find("Grand Feast") or abilityName:find("Feast")) then
        print(string.format("[AbilitySystem] 🍽️ Grand Feast: %s", unitName))
        
        local targetUnit = SelectBestTargetUnit()
        
        if targetUnit and targetUnit.GUID and AbilityEvent then
            -- ⭐ Set PendingPlacement for "SelectUnit" context
            _G.APSkill.PendingPlacement["SelectUnit"] = {
                TargetUnit = targetUnit.GUID,
                GUID = guid,
                Element = "Fire"  -- Default element
            }
            print(string.format("[AbilitySystem] ✅ Set PendingPlacement for SelectUnit: %s", targetUnit.Name))
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Grand Feast will auto-select unit")
                return true
            else
                _G.APSkill.PendingPlacement["SelectUnit"] = nil
            end
        end
        
        return false
    end
    
    -- 8. DABO 81 - Track placement
    if unitName and (unitName:find("Dabo") or unitName:find("81")) then
        print(string.format("[AbilitySystem] 🎯 Dabo 81: %s", unitName))
        
        -- หา track point แรก
        local trackPoint = nil
        pcall(function()
            local mapPath = workspace:FindFirstChild("Map")
            if mapPath then
                mapPath = mapPath:FindFirstChild("Path")
                if mapPath and #mapPath:GetChildren() > 0 then
                    trackPoint = mapPath:GetChildren()[1].Position
                end
            end
        end)
        
        if trackPoint and AbilityEvent then
            -- ⭐ Set PendingPlacement for "Dabo81" context
            _G.APSkill.PendingPlacement["Dabo81"] = {
                TargetPos = trackPoint,
                GUID = guid
            }
            print("[AbilitySystem] ✅ Set PendingPlacement for Dabo81")
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Dabo 81 will be auto-placed")
                return true
            else
                _G.APSkill.PendingPlacement["Dabo81"] = nil
            end
        end
        
        return false
    end
    
    -- 9. BERSERKER - Track placement
    if unitName and unitName:find("Berserker") then
        print(string.format("[AbilitySystem] ⚔️ Berserker: %s", unitName))
        
        -- หา track point แรก
        local trackPoint = nil
        pcall(function()
            local mapPath = workspace:FindFirstChild("Map")
            if mapPath then
                mapPath = mapPath:FindFirstChild("Path")
                if mapPath and #mapPath:GetChildren() > 0 then
                    trackPoint = mapPath:GetChildren()[1].Position
                end
            end
        end)
        
        if trackPoint and AbilityEvent then
            -- ⭐ Set PendingPlacement for "Berserker" context
            _G.APSkill.PendingPlacement["Berserker"] = {
                TargetPos = trackPoint,
                GUID = guid
            }
            print("[AbilitySystem] ✅ Set PendingPlacement for Berserker")
            
            success, err = pcall(function()
                AbilityEvent:FireServer("Activate", guid, abilityName)
            end)
            
            if success then
                AbilityLastUsed[abilityKey] = tick()
                print("[AbilitySystem] ✅ Berserker will be auto-placed")
                return true
            else
                _G.APSkill.PendingPlacement["Berserker"] = nil
            end
        end
        
        return false
    end
    
    -- 10. MASTER CHEF (Element selection) - Auto select Fire element
    if abilityName and (abilityName:find("Master Chef") or abilityName:find("Chef")) then
        print(string.format("[AbilitySystem] 👨‍🍳 Master Chef: %s", unitName))
        
        local targetUnit = SelectBestTargetUnit()
        local selectedElement = "Fire" -- Default to Fire
        
        if targetUnit then
            local MasterChefEvent = nil
            pcall(function()
                if Networking and Networking.Units then
                    local update10 = Networking.Units:FindFirstChild("Update 10.0")
                    if update10 then
                        MasterChefEvent = update10:FindFirstChild("MasterChef")
                    end
                end
            end)
            
            if MasterChefEvent then
                success, err = pcall(function()
                    MasterChefEvent:FireServer(guid, targetUnit, selectedElement)
                end)
                
                if success then
                    AbilityLastUsed[abilityKey] = tick()
                    print(string.format("[AbilitySystem] ✅ Buffed unit with %s element", selectedElement))
                    return true
                end
            end
        end
        
        return false
    end
    
    -- 11. DEFAULT ABILITY (ถ้าไม่ตรง condition ไหนเลย)
    if not AbilityEvent then return false end
    
    success, err = pcall(function()
        AbilityEvent:FireServer("Activate", guid, abilityName)
    end)
    
    if success then
        AbilityLastUsed[abilityKey] = tick()
        if abilityInfo and abilityInfo.IsOneTime then
            AbilityUsedOnce[abilityKey] = true
        end
        print(string.format("[AbilitySystem] ✅ %s → %s", unitName or "Unknown", abilityName or "Unknown"))
    end
    
    return success
end  -- ปิด function UseAbilityV3

-- ===== AUTO USE ABILITIES (MAIN LOOP) =====
local MAX_ABILITIES_PER_CHECK = 5

local function AutoUseAbilitiesV3()
    local now = tick()
    if now - LastAutoSkillCheck < AUTO_SKILL_CHECK_INTERVAL then
        return 0
    end
    LastAutoSkillCheck = now
    
    -- ⭐ ป้องกัน spam - เช็คแบบ silent
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
    
    for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
        if abilitiesUsed >= MAX_ABILITIES_PER_CHECK then break end
        if not unit then continue end
        
        -- Ownership check for Multiplayer
        local isMyUnit = true
        pcall(function()
            local ownerUserId = unit.OwnerUserId or unit.OwnerId or unit.UserId
            if ownerUserId and ownerUserId ~= plr.UserId then
                isMyUnit = false
            end
            local ownerName = unit.OwnerName or unit.PlayerName or unit.Owner
            if ownerName and ownerName ~= plr.Name then
                isMyUnit = false
            end
        end)
        
        if not isMyUnit then continue end
        
        local unitName = unit.Name or "Unknown"
        local abilities = unit.ActiveAbilities or unit.Abilities or {}
        
        -- ⭐ ป้องกัน error จาก abilities ที่เป็น nil หรือ format ผิด
        if type(abilities) ~= "table" then continue end
        if #abilities == 0 then continue end
        
        for abilityIndex, abilityData in ipairs(abilities) do
            if abilitiesUsed >= MAX_ABILITIES_PER_CHECK then break end
            
            -- ⭐ Skip ถ้า abilityData เป็น nil
            if not abilityData then continue end
            
            local abilityName = nil
            if type(abilityData) == "string" then
                abilityName = abilityData
            elseif type(abilityData) == "table" then
                abilityName = abilityData.Name or abilityData.AbilityName or abilityData.name or abilityData.DisplayName
            end
            
            -- ⭐ Skip ถ้าไม่มีชื่อ ability หรือเป็น Passive
            if not abilityName or abilityName == "" then continue end
            if abilityName and (abilityName:find("Passive") or abilityName:find("PASSIVE")) then continue end
            
            -- ⭐ ห่อด้วย pcall เพื่อป้องกัน crash
            local success, result = pcall(function()
                local abilityInfo = AnalyzeAbility(abilityName)
                
                local canUse, reason = CanUseAbility(unit, abilityName, abilityInfo)
                
                -- ⭐ FIX: ไม่แสดง messages (ลด spam logs)
                -- (ลบ debug logs ออก)
                
                if canUse then
                    -- ⭐ FIX: ไม่แสดง "Using:" log เพราะแต่ละ ability จะแสดง "Auto enabled" เอง
                    local abilitySuccess = UseAbilityV3(unit, abilityName, abilityInfo)
                    
                    if abilitySuccess then
                        abilitiesUsed = abilitiesUsed + 1
                        task.wait(0.1)
                    end
                end
                return true
            end)
            
            -- ⭐ ถ้า error แสดงแค่ warning ไม่ให้ crash ทั้งระบบ
            if not success then
                warn(string.format("[AbilitySystem] ⚠️ Error: %s - %s: %s", unitName, abilityName or "Unknown", tostring(result)))
            end
        end
    end
    
    return abilitiesUsed
end

-- ===== AUTO SWAP SYSTEM (Auto-detect + Cooldown) =====
local LastAutoSwapCheck = 0
local AUTO_SWAP_CHECK_INTERVAL = 5  -- เช็คทุก 5 วินาที

local function CheckAutoSwap()
    -- ⭐ Cooldown - ป้องกัน spam
    local now = tick()
    if now - LastAutoSwapCheck < AUTO_SWAP_CHECK_INTERVAL then
        return
    end
    LastAutoSwapCheck = now
    
    -- ⭐ ลองทั้ง 2 วิธี: ToggleAutoSwapEvent และ AutoAbilityEvent
    local swapEvent = _G.ToggleAutoSwapEvent or _G.AutoAbilityEvent
    
    if not swapEvent then 
        if not _G.APEvents.SwapEventWarningShown then
            print("[AutoSwap] ⚠️ No Swap Event found")
            print("  → ToggleAutoSwapEvent:", _G.ToggleAutoSwapEvent and "✅" or "❌")
            print("  → AutoAbilityEvent:", _G.AutoAbilityEvent and "✅" or "❌")
            _G.APEvents.SwapEventWarningShown = true
        end
        return 
    end
    
    if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then return end
    
    local unitsChecked = 0
    local swapUnitsFound = 0
    local swapUnitsEnabled = 0
    
    for unitGuid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
        if unitData and unitData.Name and not AutoSwapEnabled[unitGuid] then
            unitsChecked = unitsChecked + 1
            
            local hasAutoSwap = false
            local autoSwapAbilityName = nil
            local unitName = unitData.Name
            
            -- ⭐⭐⭐ DEBUG: แสดงเฉพาะครั้งแรก
            if not _G.APEvents.SwapDebugShown then
                print(string.format("[AutoSwap] 🔍 Checking: %s", unitName))
                
                -- Debug: แสดง unitData structure
                if unitData.Data then
                    print("  → unitData.Data exists")
                    if unitData.Data.Abilities then
                        print(string.format("  → unitData.Data.Abilities: %d items", #unitData.Data.Abilities))
                    else
                        print("  → unitData.Data.Abilities: nil")
                    end
                else
                    print("  → unitData.Data: nil")
                end
                
                _G.APEvents.SwapDebugShown = true
            end
            
            -- ⭐ วิธีที่ 1: เช็คจาก unitData.Data.Abilities โดยตรง
            if unitData.Data and unitData.Data.Abilities then
                for _, abilityData in pairs(unitData.Data.Abilities) do
                    local abilityName = ""
                    
                    if type(abilityData) == "string" then
                        abilityName = abilityData
                    elseif type(abilityData) == "table" then
                        abilityName = abilityData.Name or abilityData.AbilityName or ""
                    end
                    
                    if abilityName ~= "" and (
                        (abilityName and abilityName:find("Auto") and abilityName:find("Swap")) or
                        (abilityName and abilityName:find("AutoSwap"))
                    ) then
                        hasAutoSwap = true
                        autoSwapAbilityName = abilityName
                        break
                    end
                end
            end
            
            -- ⭐ วิธีที่ 2: ลองใช้ AbilityEvent โดยตรง (ไม่ต้อง detect)
            -- ส่ง request ไปเลย ถ้าไม่มี ability มันก็จะไม่ทำอะไร
            if not hasAutoSwap and AbilityEvent then
                -- ลองเปิด Auto Swap โดยไม่ต้องรู้ว่ามีหรือไม่
                hasAutoSwap = true
                autoSwapAbilityName = "Auto Swap"
            end
            
            -- ⭐ เปิด Auto Swap
            if hasAutoSwap and autoSwapAbilityName then
                swapUnitsFound = swapUnitsFound + 1
                
                local success, err = pcall(function()
                    if _G.ToggleAutoSwapEvent then
                        _G.ToggleAutoSwapEvent:FireServer(unitGuid, true)
                    elseif _G.AutoAbilityEvent then
                        _G.AutoAbilityEvent:FireServer("Enable", unitGuid, autoSwapAbilityName)
                    elseif AbilityEvent then
                        -- ⭐ Fallback: ลองใช้ AbilityEvent
                        AbilityEvent:FireServer("Activate", unitGuid, autoSwapAbilityName)
                    end
                end)
                
                if success then
                    AutoSwapEnabled[unitGuid] = true
                    swapUnitsEnabled = swapUnitsEnabled + 1
                    print(string.format("[AutoSwap] ✅ %s → Sent enable request", unitName))
                else
                    print(string.format("[AutoSwap] ❌ %s: %s", unitName, tostring(err)))
                end
            end
        end
    end
    
    if unitsChecked > 0 then
        print(string.format("[AutoSwap] 📊 Checked: %d units, Found: %d, Enabled: %d", 
            unitsChecked, swapUnitsFound, swapUnitsEnabled))
    end
end

-- ===== MATCH START/END HANDLERS =====
pcall(function()
    local MatchControl = require(ReplicatedStorage.Modules.Gameplay.MatchControl)
    
    MatchControl.MatchStarted:Connect(function()
        _G.APSkill.WorldItemUsedThisMatch = false
        AbilityLastUsed = {}
        AbilityUsedOnce = {}
        CaloricCloneUnits = {}
        -- ⭐ รีเซ็ตสถานะ Auto abilities ทั้งหมด
        _G.APEvents.KoguroAutoEnabled = {}
        _G.APEvents.KoguroDomainActive = {}  -- ⭐ Reset domain tracking
        _G.APEvents.AutoSwapEnabled = {}
        AutoSwapEnabled = _G.APEvents.AutoSwapEnabled  -- ⭐ Update local reference
        -- ⭐ Reset Lich Spell tracking
        LichSpellLastChange = 0
        LichSpellLastWave = 0
        LichSpellCurrentSet = {}
        print("[AbilitySystem] 🎮 Match Started - Reset all tracking")
    end)
    
    MatchControl.MatchEnded:Connect(function()
        -- ⭐ รีเซ็ตสถานะ Auto abilities ทั้งหมด
        _G.APEvents.KoguroAutoEnabled = {}
        _G.APEvents.KoguroDomainActive = {}  -- ⭐ Reset domain tracking
        _G.APEvents.AutoSwapEnabled = {}
        AutoSwapEnabled = _G.APEvents.AutoSwapEnabled  -- ⭐ Update local reference
        -- ⭐ Reset Lich Spell tracking
        LichSpellLastChange = 0
        LichSpellLastWave = 0
        LichSpellCurrentSet = {}
        print("[AbilitySystem] 🏁 Match Ended")
    end)
end)

-- ===== EXPORT MODULE =====
_G.AbilitySystem = {
    Enabled = true,
    AutoUseAbilitiesV3 = AutoUseAbilitiesV3,
    UseAbilityV3 = UseAbilityV3,
    AnalyzeAbility = AnalyzeAbility,
    CanUseAbility = CanUseAbility,
    GetAbilityTracking = function()
        return {
            LastUsed = AbilityLastUsed,
            UsedOnce = AbilityUsedOnce,
            CaloricClones = CaloricCloneUnits,
        }
    end,
    ResetTracking = function()
        AbilityLastUsed = {}
        AbilityUsedOnce = {}
        CaloricCloneUnits = {}
        _G.APSkill.WorldItemUsedThisMatch = false
        -- ⭐ รีเซ็ตสถานะ Auto abilities
        _G.APEvents.KoguroAutoEnabled = {}
        _G.APEvents.KoguroDomainActive = {}  -- ⭐ Reset domain tracking
        _G.APEvents.AutoSwapEnabled = {}
        AutoSwapEnabled = _G.APEvents.AutoSwapEnabled  -- ⭐ Update local reference
        -- ⭐ Reset Lich Spell tracking
        LichSpellLastChange = 0
        LichSpellLastWave = 0
        LichSpellCurrentSet = {}
        print("[AbilitySystem] 🔄 All tracking reset")
    end,
}

-- ⭐ แสดง summary เฉพาะครั้งแรก
if not _G.APSkill.SystemLoaded then
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("[AbilitySystem] ✅ FULLY LOADED!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(string.format("  ClientUnitHandler: %s", ClientUnitHandler and "✅" or "❌"))
    print(string.format("  ClientEnemyHandler: %s", ClientEnemyHandler and "✅" or "❌"))
    print(string.format("  AbilityEvent: %s", AbilityEvent and "✅" or "❌"))
    print(string.format("  UnitsData: %s", UnitsData and "✅" or "❌"))
    print(string.format("  ActiveAbilityData: %s", ActiveAbilityData and "✅" or "❌"))
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    _G.APSkill.SystemLoaded = true
end

-- ===== AUTO ABILITY LOOP (เรียกใช้อัตโนมัติ) =====
task.spawn(function()
    -- รอให้ game พร้อม
    task.wait(3)
    
    print("[AbilitySystem] 🚀 Starting Auto Ability Loop...")
    print(string.format("[AbilitySystem] _G.APSkill.Enabled = %s", tostring(_G.APSkill and _G.APSkill.Enabled)))
    
    while true do
        task.wait(AUTO_SKILL_CHECK_INTERVAL)
        
        if _G.APSkill and _G.APSkill.Enabled then
            -- ⭐ เรียก CheckAutoSwap ก่อนเช็ค abilities
            pcall(CheckAutoSwap)
            
            local success, result = pcall(function()
                return AutoUseAbilitiesV3()
            end)
            
            -- ⭐ แสดง error เท่านั้น (ไม่แสดง success เพื่อลด spam)
            if not success then
                warn("[AbilitySystem] ❌ Error in AutoUseAbilitiesV3:", result)
            end
        else
            -- แสดงเตือนครั้งแรกที่ระบบปิดอยู่
            if not _G.APSkill then
                warn("[AbilitySystem] ⚠️ _G.APSkill is nil!")
                task.wait(10)
            elseif not _G.APSkill.Enabled then
                warn("[AbilitySystem] ⚠️ _G.APSkill.Enabled is false!")
                task.wait(10)
            end
        end
    end
end)

-- ===== KOGURO AUTO KEEPER (เช็คสถานะทุก 10 วินาที - ลด spam) =====
task.spawn(function()
    task.wait(10) -- รอให้เกมโหลดเสร็จก่อน
    
    while true do
        task.wait(10) -- เช็คทุก 10 วินาที (ลดจาก 5 เพื่อป้องกัน spam)
        
        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
            for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                if unit and unit.Name and unit.Name:find("Koguro") then
                    -- เช็คว่ามี Dimension ability หรือไม่
                    local abilities = unit.ActiveAbilities or unit.Abilities or {}
                    local hasDimension = false
                    
                    for _, abilityData in ipairs(abilities) do
                        local abilityName = nil
                        if type(abilityData) == "string" then
                            abilityName = abilityData
                        elseif type(abilityData) == "table" then
                            abilityName = abilityData.Name or abilityData.AbilityName
                        end
                        
                        if abilityName and abilityName:find("Dimension") then
                            hasDimension = true
                            break
                        end
                    end
                    
                    if hasDimension then
                        local isAutoEnabled = _G.APEvents.KoguroAutoEnabled[guid]
                        
                        -- ⭐ เปิด Auto เฉพาะเมื่อยังไม่ได้เปิด (ไม่ spam)
                        if not isAutoEnabled and KoguroDimensionEvent then
                            pcall(function()
                                KoguroDimensionEvent:FireServer("SetAutoEnabled", guid, true)
                                task.wait(0.1)
                                KoguroDimensionEvent:FireServer("ToggleAuto", guid)
                            end)
                            
                            _G.APEvents.KoguroAutoEnabled[guid] = true
                        end
                    end
                end
            end
        end
    end
end)

-- ===== KING OF STRING AUTO-HIT SYSTEM =====
-- ⭐⭐⭐ ใช้ getgc() หา module ที่ถูก require แล้ว!
task.spawn(function()
    task.wait(1)
    
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local ScoreHandler = nil
    local GuitarMinigame = nil
    local originalHitNote = nil
    local originalMissNote = nil
    
    -- ⭐⭐⭐ ฟังก์ชันเช็คว่ามี Skele King (Rock) วางอยู่หรือไม่
    local function hasSkeleKingRock()
        if not ClientUnitHandler or not ClientUnitHandler._ActiveUnits then
            return false
        end
        
        for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
            if unit and unit.Name then
                local unitName = unit.Name:lower()
                -- ⭐⭐⭐ เช็คว่าชื่อมี "skele", "king", และ "rock" ครบ
                if unitName:find("skele") and unitName:find("king") and unitName:find("rock") then
                    return true
                end
            end
        end
        return false
    end
    
    -- ⭐⭐⭐ วิธี 1: ใช้ getgc() หา module ที่ถูก require แล้ว
    local function findModulesFromGC()
        if not getgc then return false end
        
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and not ScoreHandler then
                -- หา ScoreHandler (มี HitNote, MissNote, GetCurrentScore เป็น function)
                local hasHitNote = rawget(v, "HitNote")
                local hasMissNote = rawget(v, "MissNote") 
                local hasGetScore = rawget(v, "GetCurrentScore")
                
                if hasHitNote and type(hasHitNote) == "function" 
                   and hasMissNote and type(hasMissNote) == "function"
                   and hasGetScore and type(hasGetScore) == "function" then
                    ScoreHandler = v
                    print("[KingOfString] ✅ Found ScoreHandler via getgc!")
                end
            end
            
            if type(v) == "table" and not GuitarMinigame then
                -- หา GuitarMinigame (มี Open, Close, PlayChart เป็น function)
                local hasOpen = rawget(v, "Open")
                local hasClose = rawget(v, "Close")
                local hasPlayChart = rawget(v, "PlayChart")
                
                if hasOpen and type(hasOpen) == "function"
                   and hasClose and type(hasClose) == "function"
                   and hasPlayChart and type(hasPlayChart) == "function" then
                    GuitarMinigame = v
                    print("[KingOfString] ✅ Found GuitarMinigame via getgc!")
                end
            end
        end
        
        return ScoreHandler ~= nil
    end
    
    -- ⭐⭐⭐ วิธี 2: ใช้ getsenv() หา module จาก LocalScript
    local function findModulesFromScripts()
        if not getsenv then return false end
        
        local PlayerScripts = plr:FindFirstChild("PlayerScripts")
        if not PlayerScripts then return false end
        
        for _, script in pairs(PlayerScripts:GetDescendants()) do
            if script:IsA("LocalScript") or script:IsA("ModuleScript") then
                pcall(function()
                    local env = getsenv(script)
                    if env then
                        for k, v in pairs(env) do
                            if type(v) == "table" then
                                if v.HitNote and v.MissNote and not ScoreHandler then
                                    ScoreHandler = v
                                    print("[KingOfString] ✅ Found ScoreHandler via getsenv!")
                                end
                            end
                        end
                    end
                end)
            end
        end
        
        return ScoreHandler ~= nil
    end
    
    -- ลองหา modules
    findModulesFromGC()
    if not ScoreHandler then
        findModulesFromScripts()
    end
    
    -- ⭐⭐⭐ ฟังก์ชันเปิด GUI และเล่นเพลง
    local function openGuitarMinigame()
        if not GuitarMinigame then
            findModulesFromGC()
        end
        
        if GuitarMinigame then
            pcall(function()
                -- เปิด GUI
                if GuitarMinigame.Open then
                    GuitarMinigame.Open()
                end
                
                -- เล่นเพลง (รอ GUI พร้อม)
                task.delay(0.3, function()
                    if GuitarMinigame.PlayChart then
                        pcall(function()
                            GuitarMinigame.PlayChart("Skele King's Theme", "Medium", 2)
                            print("[KingOfString] 🎸 Playing Skele King's Theme!")
                        end)
                    end
                end)
            end)
            return true
        end
        return false
    end
    
    -- ⭐⭐⭐ Monitor: เมื่อ ability trigger → เปิด GUI
    task.spawn(function()
        local lastOpenWave = 0
        
        while true do
            task.wait(0.5)
            
            if not _G.APSkill or not _G.APSkill.KingOfString or not _G.APSkill.KingOfString.Enabled then
                continue
            end
            
            -- ⭐⭐⭐ ถ้าไม่มี Skele King (Rock) → ข้าม
            if not hasSkeleKingRock() then
                continue
            end
            
            -- เช็ค Wave ปัจจุบัน
            local CurrentWave = 0
            pcall(function()
                CurrentWave = GetWaveFromUI()
            end)
            
            -- เช็คว่า GUI เปิดอยู่หรือไม่
            local PlayerGui = plr:FindFirstChild("PlayerGui")
            local guitarGui = PlayerGui and PlayerGui:FindFirstChild("GuitarMinigame")
            local isGuiOpen = guitarGui and guitarGui.Enabled
            
            -- ⭐⭐⭐ ถ้า wave เป็น 5, 10, 15... และ GUI ไม่เปิด → เปิด GUI!
            -- King of String เล่นทุก 5 wave
            if CurrentWave > 0 and CurrentWave % 5 == 0 and not isGuiOpen then
                if CurrentWave ~= lastOpenWave then
                    lastOpenWave = CurrentWave
                    
                    print("[KingOfString] 🎸 Wave", CurrentWave, "- Opening GUI...")
                    
                    -- รอ ability trigger แล้วค่อยเปิด
                    task.delay(1, function()
                        -- เช็คอีกครั้งว่า GUI ยังไม่เปิด
                        local pg = plr:FindFirstChild("PlayerGui")
                        local gg = pg and pg:FindFirstChild("GuitarMinigame")
                        if not gg or not gg.Enabled then
                            openGuitarMinigame()
                        end
                    end)
                end
            end
        end
    end)
    
    -- ⭐⭐⭐ Hook ถ้าเจอ ScoreHandler
    if ScoreHandler and ScoreHandler.HitNote then
        originalHitNote = ScoreHandler.HitNote
        originalMissNote = ScoreHandler.MissNote
        
        -- Override MissNote → HitNote
        if originalMissNote then
            rawset(ScoreHandler, "MissNote", function(...)
                if originalHitNote then
                    return originalHitNote(true)
                end
            end)
            print("[KingOfString] ✅ MissNote → HitNote bypass installed!")
        end
        
        -- Override HitNote → always Perfect
        rawset(ScoreHandler, "HitNote", function(isPerfect, ...)
            return originalHitNote(true, ...)
        end)
        print("[KingOfString] ✅ HitNote → always Perfect!")
    else
        print("[KingOfString] ⚠️ ScoreHandler not found - using button press only")
    end
    
    -- ===== AUTO BUTTON PRESS LOOP =====
    task.spawn(function()
        print("[KingOfString] ✅ Auto Button Press loop started!")
        
        while true do
            task.wait()
            
            if not _G.APSkill or not _G.APSkill.KingOfString or not _G.APSkill.KingOfString.Enabled then
                continue
            end
            
            -- ⭐⭐⭐ ถ้าไม่มี Skele King (Rock) → ข้าม
            if not hasSkeleKingRock() then
                continue
            end
            
            pcall(function()
                local PlayerGui = plr:FindFirstChild("PlayerGui")
                if not PlayerGui then return end
                
                local guitarGui = PlayerGui:FindFirstChild("GuitarMinigame")
                if not guitarGui or not guitarGui.Enabled then return end
                
                local page = guitarGui:FindFirstChild("Page")
                if not page then return end
                
                local main = page:FindFirstChild("Main")
                if not main then return end
                
                local bottom = main:FindFirstChild("Bottom")
                if not bottom then return end
                
                -- ⭐⭐⭐ กดทุกปุ่ม (1-5) 
                for i = 1, 5 do
                    local button = bottom:FindFirstChild("Button" .. i)
                    if button then
                        local biggerButton = button:FindFirstChild("BiggerButton")
                        if biggerButton then
                            if getconnections then
                                pcall(function()
                                    for _, conn in pairs(getconnections(biggerButton.MouseButton1Down)) do
                                        conn:Fire()
                                    end
                                end)
                            end
                            if firesignal then
                                pcall(function()
                                    firesignal(biggerButton.MouseButton1Down)
                                end)
                            end
                        end
                    end
                end
                
                -- ⭐⭐⭐ SPAM HitNote ถ้ามี originalHitNote
                if originalHitNote then
                    for i = 1, 50 do
                        pcall(function()
                            originalHitNote(true)
                        end)
                    end
                end
            end)
        end
    end)
    
    -- ⭐⭐⭐ AUTO CLOSE GUI ทุก 5 WAVE เพื่อป้องกันแลค =====
    task.spawn(function()
        local lastCloseWave = 0
        local CLOSE_EVERY_WAVES = 5
        
        print("[KingOfString] ✅ Auto Close GUI every 5 waves started!")
        
        while true do
            task.wait(1)
            
            if not _G.APSkill or not _G.APSkill.KingOfString or not _G.APSkill.KingOfString.Enabled then
                continue
            end
            
            -- ⭐⭐⭐ ถ้าไม่มี Skele King (Rock) → ข้าม
            if not hasSkeleKingRock() then
                continue
            end
            
            -- เช็ค Wave ปัจจุบัน
            local CurrentWave = 0
            pcall(function()
                CurrentWave = GetWaveFromUI()
            end)
            
            -- ปิด GUI ทุก 5 wave
            if CurrentWave > 0 and CurrentWave % CLOSE_EVERY_WAVES == 0 and CurrentWave ~= lastCloseWave then
                lastCloseWave = CurrentWave
                
                pcall(function()
                    local PlayerGui = plr:FindFirstChild("PlayerGui")
                    if PlayerGui then
                        local guitarGui = PlayerGui:FindFirstChild("GuitarMinigame")
                        if guitarGui then
                            -- กดปุ่ม Close
                            local closeBtn = guitarGui:FindFirstChild("Close")
                            if closeBtn then
                                if firesignal then
                                    firesignal(closeBtn.Activated)
                                elseif getconnections then
                                    for _, conn in pairs(getconnections(closeBtn.Activated)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                end
                            end
                            
                            -- ถ้ากดปุ่มไม่ได้ ลอง destroy
                            task.delay(0.5, function()
                                if guitarGui and guitarGui.Parent then
                                    guitarGui:Destroy()
                                    print("[KingOfString] 🔄 Closed GUI at wave", CurrentWave)
                                end
                            end)
                        end
                    end
                end)
                
                -- ลองปิดผ่าน GuitarMinigame module ด้วย
                if GuitarMinigame and GuitarMinigame.Close then
                    pcall(function()
                        GuitarMinigame.Close()
                    end)
                end
                if GuitarMinigame and GuitarMinigame.Cleanup then
                    pcall(function()
                        GuitarMinigame.Cleanup()
                    end)
                end
            end
        end
    end)
    
    -- ⭐⭐⭐ Monitor: ถ้ายังไม่เจอ ลองหาอีกทีเมื่อ GUI เปิด
    task.spawn(function()
        while not ScoreHandler do
            task.wait(1)
            
            local PlayerGui = plr:FindFirstChild("PlayerGui")
            if PlayerGui and PlayerGui:FindFirstChild("GuitarMinigame") then
                -- GUI เปิดแล้ว ลองหา module อีกครั้ง
                if findModulesFromGC() then
                    if ScoreHandler and ScoreHandler.HitNote then
                        originalHitNote = ScoreHandler.HitNote
                        originalMissNote = ScoreHandler.MissNote
                        
                        if originalMissNote then
                            rawset(ScoreHandler, "MissNote", function(...)
                                return originalHitNote(true)
                            end)
                        end
                        rawset(ScoreHandler, "HitNote", function(isPerfect, ...)
                            return originalHitNote(true, ...)
                        end)
                        print("[KingOfString] ✅ Late hook installed!")
                        break
                    end
                end
            end
        end
    end)
end)

-- ===== AUTO CALORIC STONE SYSTEM (แยกจาก Ability Loop) =====
-- ⭐⭐⭐ Caloric Stone ไม่ใช่ ability ของ unit - ต้องเรียกแยกต่างหาก!
task.spawn(function()
    task.wait(5)  -- รอให้ game พร้อม
    
    print("[AbilitySystem] 🔧 Starting Caloric Stone Monitor...")
    
    local CALORIC_CHECK_INTERVAL = 5  -- เช็คทุก 5 วินาที
    local lastCaloricCheck = 0
    
    while true do
        task.wait(CALORIC_CHECK_INTERVAL)
        
        -- Skip ถ้าปิด หรือใช้แล้ว
        if not _G.APSkill or not _G.APSkill.Enabled then continue end
        if _G.APSkill.WorldItemUsedThisMatch then continue end
        if _G.APSkill.CaloricStoneUsed then continue end
        
        -- เช็ค Wave
        local CurrentWave, MaxWave = GetWaveFromUI()
        if CurrentWave < 3 then continue end
        
        -- ⭐⭐⭐ เช็ค Emergency Mode - ไม่ใช้ Caloric ตอน Emergency
        local isEmergency = _G.APState and _G.APState.IsEmergency or false
        if isEmergency then continue end
        
        -- ⭐⭐⭐ CRITICAL: เช็คว่าวาง LICH KING แล้วหรือยัง!
        local hasLichKing = false
        local placedCount = 0
        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
            for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                if unit and unit.Name then
                    placedCount = placedCount + 1
                    -- เช็คว่าเป็น Lich King หรือไม่
                    local unitName = unit.Name or ""
                    if unitName:lower():find("lich") or unitName:lower():find("ruler") then
                        hasLichKing = true
                    end
                end
            end
        end
        
        -- ⭐⭐⭐ DEBUG: แสดงจำนวน unit และ Lich King
        print(string.format("[AbilitySystem] 🔧 Caloric Stone Check: %d units placed, Lich King: %s", 
            placedCount, hasLichKing and "✅" or "❌"))
        
        if not hasLichKing then
            -- ยังไม่ได้วาง Lich King → ข้าม Caloric Stone
            print("[AbilitySystem] ⏸️ Waiting for Lich King to be placed...")
            continue
        end
        
        -- เช็คว่ามี CaloricStoneEvent หรือไม่
        if not CaloricStoneEvent then
            if not _G.APSkill.CaloricEventMissing then
                print("[AbilitySystem] ❌ CaloricStoneEvent not found!")
                _G.APSkill.CaloricEventMissing = true
            end
            continue
        end
        
        -- ⭐⭐⭐ STEP 1: หา units ที่ equip อยู่ใน Hotbar (6 ตัว) เพื่อกรองออก
        local equippedUnitIds = {}
        local equippedUnitNames = {}  -- เพิ่ม: กรองจากชื่อด้วย
        
        if UnitsModule and UnitsModule._Cache then
            for slot, v in pairs(UnitsModule._Cache) do
                if v and v ~= "None" and type(v) == "table" then
                    -- ⭐⭐⭐ FIX: ใช้ pattern เดียวกับ AutoPlayBase: v.Data or v
                    local unitData = v.Data or v
                    local unitName = unitData.Name or v.Name or ""
                    
                    -- เก็บทุก ID ที่เป็นไปได้
                    local id1 = v.UniqueIdentifier or unitData.UniqueIdentifier
                    local id2 = v.Identifier or unitData.Identifier
                    local id3 = v.ID or unitData.ID
                    local id4 = v.GUID
                    
                    if id1 then equippedUnitIds[tostring(id1)] = true end
                    if id2 then equippedUnitIds[tostring(id2)] = true end
                    if id3 then equippedUnitIds[tostring(id3)] = true end
                    if id4 then equippedUnitIds[tostring(id4)] = true end
                    
                    -- ⭐ เก็บชื่อ unit ที่ equip ไว้ด้วย
                    if unitName ~= "" then
                        equippedUnitNames[unitName] = true
                    end
                end
            end
        end
        
        -- DEBUG: แสดง equipped units
        local equippedCount = 0
        for _ in pairs(equippedUnitNames) do equippedCount = equippedCount + 1 end
        print(string.format("[AbilitySystem] 🔧 Caloric Stone: %d units equipped in Hotbar", equippedCount))
        for name, _ in pairs(equippedUnitNames) do
            print(string.format("  → Equipped: %s", name))
        end
        
        -- ⭐⭐⭐ STEP 2: หา units ทั้งหมดจาก OwnedUnitsHandler
        local ownedUnits = nil
        if OwnedUnitsHandler and OwnedUnitsHandler.GetOwnedUnits then
            pcall(function() ownedUnits = OwnedUnitsHandler:GetOwnedUnits() end)
        end
        if not ownedUnits and OwnedUnitsHandler and OwnedUnitsHandler._OwnedUnits then
            ownedUnits = OwnedUnitsHandler._OwnedUnits
        end
        
        if not ownedUnits then
            print("[AbilitySystem] ⚠️ Caloric Stone: No OwnedUnits found")
            continue
        end
        
        -- ⭐⭐⭐ STEP 3: กรองเอาเฉพาะ units ที่ไม่ได้ equip และเป็น DAMAGE UNIT จริงๆ
        local damageUnits = {}
        
        for unitGUID, unitEntry in pairs(ownedUnits) do
            local identifier = unitEntry.Identifier
            local uniqueId = unitEntry.UniqueIdentifier or unitGUID
            local unitData = unitEntry.UnitData or unitEntry
            local unitName = unitData and unitData.Name or ""
            
            -- ⭐⭐⭐ FIXED: Skip ถ้า equip แล้ว (เช็คทั้ง ID และ ชื่อ)
            local isEquipped = false
            if equippedUnitIds[tostring(uniqueId)] then isEquipped = true end
            if equippedUnitIds[tostring(identifier)] then isEquipped = true end
            if equippedUnitIds[tostring(unitGUID)] then isEquipped = true end
            if equippedUnitNames[unitName] then isEquipped = true end  -- เช็คจากชื่อด้วย!
            
            if isEquipped then
                continue
            end
            
            if unitName ~= "" then
                -- ⭐⭐⭐ FIX: ดึงข้อมูล REAL จาก UnitsData:GetUnitDataFromID()
                local lookupData = nil
                pcall(function()
                    if UnitsData and identifier then
                        lookupData = UnitsData:GetUnitDataFromID(identifier)
                    end
                end)
                
                -- ใช้ lookupData ก่อน แล้วค่อย fallback เป็น unitData
                local realUnitData = lookupData or unitData
                
                -- ⭐⭐⭐ เช็ค UnitType โดยตรง - ต้องไม่ใช่ Farm หรือ Support
                local unitType = realUnitData.UnitType or realUnitData.Type or unitData.UnitType or ""
                local isFarm = (unitType == "Farm") or (unitType == "Income")
                local isSupport = (unitType == "Support") or (unitType == "Buff")
                
                -- เช็คจากชื่อด้วย
                local isLich = unitName:lower():find("lich") or unitName:lower():find("ruler")
                local isIncome = isFarm or (IsIncomeUnit and IsIncomeUnit(unitName, realUnitData))
                local isBuff = isSupport or (IsBuffUnit and IsBuffUnit(unitName, realUnitData))
                
                -- ⭐⭐⭐ TRAIT DAMAGE MULTIPLIERS (ตาม Anime Vanguards)
                local TRAIT_MULTIPLIERS = {
                    ["Monarch"] = 2.0,      -- +100% DMG
                    ["Celestial"] = 1.75,   -- +75% DMG
                    ["Ancient"] = 1.5,      -- +50% DMG
                    ["Shiny"] = 1.25,       -- +25% DMG
                    ["Starfall"] = 1.5,     -- +50% DMG
                    ["Prismatic"] = 1.35,   -- +35% DMG
                }
                
                -- ⭐⭐⭐ ดึง Trait จาก unitEntry
                local traitName = nil
                local traitMultiplier = 1.0
                
                pcall(function()
                    local trait = unitEntry.Trait or unitData.Trait
                    if trait and trait ~= "None" then
                        if type(trait) == "table" then
                            traitName = trait.Name
                        elseif type(trait) == "string" then
                            traitName = trait
                        end
                        
                        if traitName and TRAIT_MULTIPLIERS[traitName] then
                            traitMultiplier = TRAIT_MULTIPLIERS[traitName]
                        end
                    end
                end)
                
                -- ⭐⭐⭐ CRITICAL: ดึง Damage จาก MAX LEVEL (Lv.60 = Upgrades สุดท้าย)
                -- เพราะ unit ใน Bag ที่ Lv.60 คือ Max Level แล้ว!
                local baseDamage = 0
                local realDamage = 0
                local realDPS = 0
                local unitLevel = 1
                
                pcall(function()
                    if realUnitData and realUnitData.Upgrades then
                        -- ⭐⭐⭐ FIX: ดึง Level จาก unitEntry หรือใช้ Max Level
                        local maxLevel = #realUnitData.Upgrades
                        
                        -- ลองหา Level จากหลายแหล่ง
                        local foundLevel = unitEntry.Level or unitEntry.CurrentUpgrade 
                            or unitData.Level or unitData.CurrentUpgrade
                            or (unitEntry.UnitData and unitEntry.UnitData.CurrentUpgrade)
                        
                        -- ⭐⭐⭐ CRITICAL: ถ้าไม่เจอ Level → ใช้ MAX LEVEL (Lv.60 ใน Bag)
                        if foundLevel and foundLevel > 0 then
                            unitLevel = foundLevel
                        else
                            unitLevel = maxLevel  -- ใช้ Max Level!
                        end
                        
                        if unitLevel > maxLevel then unitLevel = maxLevel end
                        if unitLevel < 1 then unitLevel = 1 end
                        
                        local upgradeData = realUnitData.Upgrades[unitLevel]
                        if upgradeData then
                            baseDamage = upgradeData.Damage or upgradeData.ATK or upgradeData.DMG or 0
                            -- ⭐⭐⭐ คำนวณ Damage รวม Trait!
                            realDamage = baseDamage * traitMultiplier
                            local cooldown = upgradeData.Cooldown or upgradeData.SPA or 1
                            if realDamage > 0 and cooldown > 0 then
                                realDPS = realDamage / cooldown
                            end
                        end
                    end
                end)
                
                -- ⭐⭐⭐ MUST HAVE: Damage > 0 และ ไม่ใช่ Lich/Income/Buff
                local isDamageUnit = (realDamage > 0) and (not isLich) and (not isIncome) and (not isBuff)
                
                if isDamageUnit and realDPS > 0 then
                    table.insert(damageUnits, {
                        Name = unitName,
                        Level = unitLevel,
                        DPS = realDPS,
                        Damage = realDamage,
                        BaseDamage = baseDamage,
                        Trait = traitName,
                        TraitMultiplier = traitMultiplier,
                        Identifier = identifier,
                        UniqueIdentifier = uniqueId,
                        Data = unitData
                    })
                end
            end
        end
        
        if #damageUnits == 0 then
            print("[AbilitySystem] ⚠️ Caloric Stone: No unequipped damage units (with Damage > 0)")
            continue
        end
        
        -- ⭐⭐⭐ FIX: เรียงจาก DAMAGE สูงไปต่ำ (รวม Trait แล้ว)
        table.sort(damageUnits, function(a, b) return a.Damage > b.Damage end)
        
        -- ⭐⭐⭐ DEBUG: แสดง top 5 หลัง SORT (เรียงตาม Damage + Trait + Level)
        print(string.format("[AbilitySystem] 🔧 Caloric Stone: Found %d REAL damage units (sorted by DAMAGE+TRAIT)", #damageUnits))
        for i = 1, math.min(5, #damageUnits) do
            local u = damageUnits[i]
            local traitStr = u.Trait and string.format(" [%s]", u.Trait) or ""
            print(string.format("  → %d. %s Lv.%d (DMG: %.0f)%s", i, u.Name, u.Level or 1, u.Damage or 0, traitStr))
        end
        
        local bestUnit = damageUnits[1]
        
        local traitInfo = bestUnit.Trait and string.format(" [%s]", bestUnit.Trait) or ""
        print(string.format("[AbilitySystem] 🎯 Selected: %s Lv.%d (DMG: %.0f)%s", bestUnit.Name, bestUnit.Level or 1, bestUnit.Damage or 0, traitInfo))
        
        -- ⭐⭐⭐ STEP 4: ใช้ Caloric Stone!
        local targetIdentifier = bestUnit.UniqueIdentifier or bestUnit.Identifier
        
        -- ต้องหา unit ที่วางอยู่แล้วเป็น source (guid)
        local sourceGuid = nil
        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
            for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                if unit and unit.Name then
                    sourceGuid = guid
                    break
                end
            end
        end
        
        if not sourceGuid then
            print("[AbilitySystem] ⚠️ Caloric Stone: No source unit found")
            continue
        end
        
        -- ⭐⭐⭐ PRE-CALCULATE: หา Lich King position และ bestUnit position!
        local lichKingPos = nil
        local lichKingGUID = nil
        local bestUnitPos = nil  -- ⭐ ตำแหน่งของ bestUnit (วางได้แน่นอน!)
        local bestUnitGUID = nil
        
        pcall(function()
            if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                for unitGuid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                    if activeUnit and activeUnit.Name then
                        local uName = string.lower(tostring(activeUnit.Name))
                        
                        -- หา Lich King
                        if string.find(uName, "lich") or string.find(uName, "ruler") then
                            if activeUnit.Model then
                                local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    lichKingPos = hrp.Position
                                    lichKingGUID = unitGuid
                                end
                            end
                            if not lichKingPos and activeUnit.Position then
                                lichKingPos = activeUnit.Position
                                lichKingGUID = unitGuid
                            end
                        end
                        
                        -- ⭐⭐⭐ หา bestUnit position (ตรงชื่อ!)
                        if activeUnit.Name == bestUnit.Name then
                            if activeUnit.Model then
                                local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    bestUnitPos = hrp.Position
                                    bestUnitGUID = unitGuid
                                end
                            end
                            if not bestUnitPos and activeUnit.Position then
                                bestUnitPos = activeUnit.Position
                                bestUnitGUID = unitGuid
                            end
                        end
                    end
                end
            end
        end)
        
        -- ⭐⭐⭐ FIX: ใช้ lichKingGUID เป็น sourceGuid! (ไม่ใช่ bestUnitGUID)
        -- FromUnitGUID ต้องเป็น Lich King (ตัวที่มี Ability Caloric Stone)
        if lichKingGUID then
            sourceGuid = lichKingGUID
            print(string.format("[AbilitySystem] ✅ Using Lich King GUID: %s", tostring(lichKingGUID)))
        else
            -- Fallback: หา Lich King จาก Active Units
            pcall(function()
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    for unitGuid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                        if activeUnit and activeUnit.Name then
                            local uName = string.lower(tostring(activeUnit.Name))
                            if string.find(uName, "lich") or string.find(uName, "ruler") then
                                sourceGuid = unitGuid
                                print(string.format("[AbilitySystem] ✅ Found Lich King (fallback): %s", tostring(unitGuid)))
                                break
                            end
                        end
                    end
                end
            end)
        end
        
        -- DEBUG
        if lichKingPos then
            print(string.format("[AbilitySystem] 🎯 Found Lich King at (%.1f, %.1f, %.1f)", 
                lichKingPos.X, lichKingPos.Y, lichKingPos.Z))
        else
            print("[AbilitySystem] ⚠️ Lich King position not found!")
        end
        
        if bestUnitPos then
            print(string.format("[AbilitySystem] 🎯 Best Unit (%s) at (%.1f, %.1f, %.1f)", 
                bestUnit.Name, bestUnitPos.X, bestUnitPos.Y, bestUnitPos.Z))
        else
            print("[AbilitySystem] ⚠️ Best Unit position not found, searching all units...")
            -- Fallback: หาจาก Unit ตัวแรก
            pcall(function()
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    for guid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                        if activeUnit and activeUnit.Model then
                            local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                bestUnitPos = hrp.Position
                                print(string.format("[AbilitySystem] 📍 Found fallback position from %s: (%.1f, %.1f, %.1f)", 
                                    activeUnit.Name or "Unit", hrp.Position.X, hrp.Position.Y, hrp.Position.Z))
                                break
                            end
                        end
                    end
                end
            end)
        end
        
        -- คำนวณ targetPos
        local targetPos = nil
        
        -- ⭐⭐⭐ CALORIC STONE: ใช้ตำแหน่ง DAMAGE UNIT โดยตรง (ตี enemy ได้แน่นอน!)
        local unitRange = 25  -- default range
        pcall(function()
            if _G.GetUnitRange and bestUnit.Data then
                unitRange = _G.GetUnitRange(bestUnit.Data) or 25
            end
        end)
        
        -- ⭐⭐⭐ PRIORITY 1: GetBestFrontPosition (หน้าประตู - ตี enemy ได้แน่นอน!)
        pcall(function()
            if _G.GetBestFrontPosition then
                targetPos = _G.GetBestFrontPosition(unitRange)
                if targetPos then
                    print(string.format("[AbilitySystem] ✅ Caloric Stone: Using FRONT position (%.1f, %.1f, %.1f) - Range: %d", 
                        targetPos.X, targetPos.Y, targetPos.Z, unitRange))
                end
            end
        end)
        
        -- ⭐⭐⭐ PRIORITY 2: GetVerifiedPlacementPosition (ตี path ได้)
        if not targetPos then
            pcall(function()
                if _G.GetVerifiedPlacementPosition then
                    local gamePhase = _G.GetGamePhase and _G.GetGamePhase() or "mid"
                    targetPos = _G.GetVerifiedPlacementPosition(unitRange, gamePhase, bestUnit.Name, bestUnit.Data, 3)
                    if targetPos then
                        print(string.format("[AbilitySystem] ✅ Caloric Stone: Using VERIFIED position (%.1f, %.1f, %.1f) - Range: %d", 
                            targetPos.X, targetPos.Y, targetPos.Z, unitRange))
                    end
                end
            end)
        end
        
        -- ⭐⭐⭐ PRIORITY 3: GetBestPlacementPosition (damage position)
        if not targetPos then
            pcall(function()
                if _G.GetBestPlacementPosition then
                    local gamePhase = _G.GetGamePhase and _G.GetGamePhase() or "mid"
                    targetPos = _G.GetBestPlacementPosition(unitRange, gamePhase, bestUnit.Name, bestUnit.Data)
                    if targetPos then
                        print(string.format("[AbilitySystem] ⚠️ Caloric Stone: Using BestPlacement (%.1f, %.1f, %.1f)", 
                            targetPos.X, targetPos.Y, targetPos.Z))
                    end
                end
            end)
        end
        
        -- ⭐⭐⭐ PRIORITY 4: หาตำแหน่งใกล้ Path โดยตรง (ตี enemy ได้!)
        if not targetPos then
            pcall(function()
                if _G.GetMapPath then
                    local path = _G.GetMapPath()
                    if path and #path > 0 then
                        -- เลือก node ที่อยู่กลางๆ path (enemy ผ่านแน่)
                        local midIndex = math.floor(#path * 0.6)  -- 60% ของ path
                        local pathNode = path[midIndex] or path[1]
                        
                        -- วางห่างจาก path 70% ของ range
                        local safeDistance = unitRange * 0.7
                        local angle = math.random() * math.pi * 2
                        targetPos = Vector3.new(
                            pathNode.X + math.cos(angle) * safeDistance,
                            pathNode.Y,
                            pathNode.Z + math.sin(angle) * safeDistance
                        )
                        print(string.format("[AbilitySystem] 📍 Caloric Stone: Using PATH position (%.1f, %.1f, %.1f)", 
                            targetPos.X, targetPos.Y, targetPos.Z))
                    end
                end
            end)
        end
        
        -- ⭐⭐⭐ FINAL FALLBACK: ใช้ตำแหน่งของ Damage Unit ที่มีอยู่
        if not targetPos then
            pcall(function()
                if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                    for guid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                        if activeUnit and activeUnit.Model then
                            local uName = string.lower(tostring(activeUnit.Name or ""))
                            -- หา Damage Unit (ไม่ใช่ Lich King, Income, Buff)
                            local isLich = string.find(uName, "lich") or string.find(uName, "ruler")
                            local isIncome = string.find(uName, "golden") or string.find(uName, "cowboy") or string.find(uName, "executive")
                            local isBuff = string.find(uName, "commander") or string.find(uName, "cyborg")
                            
                            if not isLich and not isIncome and not isBuff then
                                local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    -- ใช้ตำแหน่งเดียวกับ Damage Unit นี้ (offset เล็กน้อย)
                                    local offset = 2
                                    local angle = math.random() * math.pi * 2
                                    targetPos = hrp.Position + Vector3.new(
                                        math.cos(angle) * offset, 0, math.sin(angle) * offset
                                    )
                                    print(string.format("[AbilitySystem] 📍 Caloric Stone: Using DAMAGE UNIT %s position (%.1f, %.1f, %.1f)", 
                                        activeUnit.Name or "Unit", targetPos.X, targetPos.Y, targetPos.Z))
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        -- Fallback สุดท้าย
        if not targetPos then
            targetPos = Vector3.new(0, 10, 0)
            print("[AbilitySystem] ⚠️ Using fallback position (0, 10, 0)")
        end
        
        -- ⭐⭐⭐ CRITICAL: ลงทะเบียน PendingPlacement ก่อน FireServer!
        -- Context ที่ Caloric Stone ใช้ = "CaloricStone" หรือ "Ability"
        _G.APSkill.PendingPlacement["CaloricStone"] = {
            TargetPos = targetPos,
            GUID = sourceGuid,
            UnitName = bestUnit.Name
        }
        _G.APSkill.PendingPlacement["Ability"] = {
            TargetPos = targetPos,
            GUID = sourceGuid,
            UnitName = bestUnit.Name
        }
        
        print(string.format("[AbilitySystem] 📌 Registered PendingPlacement for Caloric Stone at (%.1f, %.1f, %.1f)", 
            targetPos.X, targetPos.Y, targetPos.Z))
        
        local success, err = pcall(function()
            CaloricStoneEvent:FireServer(targetIdentifier, sourceGuid)
        end)
        
        if success then
            print(string.format("[AbilitySystem] ✅ Caloric Stone → %s (DPS: %.1f)", bestUnit.Name, bestUnit.DPS))
            
            -- ⭐⭐⭐ ส่ง Render โดยตรงพร้อม RETRY!
            task.spawn(function()
                task.wait(0.3)
                
                local numericID = bestUnit.Identifier or bestUnit.ID or 0
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
                
                -- ⭐⭐⭐ RETRY LOOP: ลองวางที่ตำแหน่ง targetPos ก่อน แล้วค่อยลองตำแหน่งอื่น
                local maxRetries = 12
                local placed = false
                
                -- ⭐⭐⭐ FIX: ใช้ targetPos ที่คำนวณไว้ก่อน (SYNC กับ Damage Unit!)
                local primaryPos = targetPos  -- ตำแหน่งที่คำนวณไว้แล้ว
                
                -- เก็บตำแหน่งของ Units ทั้งหมดที่ใกล้ Lich King (เป็น fallback)
                local nearbyUnitPositions = {}
                pcall(function()
                    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                        for guid, activeUnit in pairs(ClientUnitHandler._ActiveUnits) do
                            if activeUnit and activeUnit.Model then
                                local hrp = activeUnit.Model:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local dist = lichKingPos and (hrp.Position - lichKingPos).Magnitude or 999
                                    -- เก็บเฉพาะ Unit ที่ใกล้ Lich King (< 30 studs) หรือทุก Unit ถ้าไม่มี Lich King
                                    if dist < 30 or not lichKingPos then
                                        table.insert(nearbyUnitPositions, {
                                            Position = hrp.Position,
                                            Name = activeUnit.Name,
                                            Distance = dist
                                        })
                                    end
                                end
                            end
                        end
                    end
                end)
                
                -- เรียงตามระยะใกล้ Lich King
                table.sort(nearbyUnitPositions, function(a, b) return a.Distance < b.Distance end)
                
                print(string.format("[AbilitySystem] 📍 Primary target: (%.1f, %.1f, %.1f) | Fallback units: %d", 
                    primaryPos.X, primaryPos.Y, primaryPos.Z, #nearbyUnitPositions))
                
                for attempt = 1, maxRetries do
                    if placed then break end
                    
                    -- นับ unit ก่อนวาง
                    local beforeCount = 0
                    pcall(function()
                        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                            for _ in pairs(ClientUnitHandler._ActiveUnits) do
                                beforeCount = beforeCount + 1
                            end
                        end
                    end)
                    
                    local tryPos = nil
                    
                    -- ⭐⭐⭐ FIX: Attempt 1-3 = ใช้ primaryPos (ตำแหน่งที่คำนวณไว้)
                    if attempt <= 3 then
                        local offset = (attempt - 1) * 0.5  -- 0, 0.5, 1.0
                        local angle = (attempt * math.pi / 3)  -- หมุน 60 องศา
                        tryPos = Vector3.new(
                            primaryPos.X + math.cos(angle) * offset,
                            primaryPos.Y,
                            primaryPos.Z + math.sin(angle) * offset
                        )
                        print(string.format("[AbilitySystem] 🎯 Attempt %d: Using PRIMARY position + offset %.1f", attempt, offset))
                    else
                        -- Attempt 4+: ใช้ตำแหน่งของ Unit ใกล้ Lich King
                        local fallbackIdx = attempt - 3
                        local unitIdx = ((fallbackIdx - 1) % math.max(1, #nearbyUnitPositions)) + 1
                        local selectedUnit = nearbyUnitPositions[unitIdx]
                        
                        if selectedUnit then
                            local offset = 0.3 + (math.floor((fallbackIdx - 1) / math.max(1, #nearbyUnitPositions)) * 0.5)
                            local angle = (fallbackIdx * math.pi / 6)
                            tryPos = Vector3.new(
                                selectedUnit.Position.X + math.cos(angle) * offset,
                                selectedUnit.Position.Y,
                                selectedUnit.Position.Z + math.sin(angle) * offset
                            )
                            print(string.format("[AbilitySystem] 🎯 Attempt %d: Using FALLBACK %s + offset %.1f", 
                                attempt, selectedUnit.Name or "Unit", offset))
                        else
                            tryPos = primaryPos
                        end
                    end
                    
                    print(string.format("[AbilitySystem] 🔄 Attempt %d: Trying position (%.1f, %.1f, %.1f)", 
                        attempt, tryPos.X, tryPos.Y, tryPos.Z))
                    
                    -- ส่ง Render
                    pcall(function()
                        UnitEvent:FireServer("Render", {
                            bestUnit.Name,
                            numericID,
                            tryPos,
                            0
                        }, {
                            FromUnitGUID = sourceGuid
                        })
                    end)
                    
                    -- รอแล้วเช็คว่าวางสำเร็จหรือไม่
                    task.wait(0.5)
                    
                    local afterCount = 0
                    pcall(function()
                        if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                            for _ in pairs(ClientUnitHandler._ActiveUnits) do
                                afterCount = afterCount + 1
                            end
                        end
                    end)
                    
                    if afterCount > beforeCount then
                        placed = true
                        print(string.format("[AbilitySystem] ✅ Caloric Clone PLACED at (%.1f, %.1f, %.1f) [attempt %d]", 
                            tryPos.X, tryPos.Y, tryPos.Z, attempt))
                        _G.APSkill.WorldItemUsedThisMatch = true
                        _G.APSkill.CaloricStoneUsed = true
                    else
                        print(string.format("[AbilitySystem] ⚠️ Attempt %d failed, units: %d → %d", 
                            attempt, beforeCount, afterCount))
                    end
                end
                
                if not placed then
                    print("[AbilitySystem] ❌ Caloric Clone placement failed after all attempts!")
                    -- ไม่ set CaloricStoneUsed เพื่อให้ลองใหม่รอบหน้า
                    _G.APSkill.CaloricStoneUsed = false
                end
                
                _G.APSkill.PendingPlacement["CaloricStone"] = nil
                _G.APSkill.PendingPlacement["Ability"] = nil
            end)
        else
            print(string.format("[AbilitySystem] ❌ Caloric Stone failed: %s", tostring(err)))
            -- ล้าง PendingPlacement ถ้า fail
            _G.APSkill.PendingPlacement["CaloricStone"] = nil
            _G.APSkill.PendingPlacement["Ability"] = nil
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- ⭐⭐⭐ WORLD DESTROYER: AUTO CHOOSE TRAIT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
-- Based on TraitsData from Decom.lua
-- Traits: Vigor, Swift, Range, Marksman, Scholar, Blitz, Fortune, Deadeye, Solar, Ethereal, Monarch, Prodigy
-- ⭐⭐⭐ FIX: ต้องกดปุ่ม GUI Card เพื่อเลือก Trait ไม่ใช่ FireServer ตรงๆ

_G.APSkill.WorldDestroyer = _G.APSkill.WorldDestroyer or {
    Enabled = true,
    AutoChooseTrait = true,
    -- Priority: Higher = Better (ดึงจาก TraitsData แบบ dynamic)
    TraitPriority = {
        -- ⭐⭐⭐ Best Traits for Damage Dealers
        ["Monarch"] = 100,      -- +300% Damage, -10% SPA, +5% Range (PlacementLimit: 1)
        ["Ethereal"] = 95,      -- +20% Damage, -20% SPA, +5% Range
        ["Solar"] = 90,         -- +10% Damage, -5% SPA, +25% Range
        ["Deadeye"] = 85,       -- +45% CritChance, +50% CritDamage
        
        -- ⭐⭐ Good Traits
        ["Blitz"] = 80,         -- -20% SPA (Attack Speed)
        ["Vigor"] = 75,         -- +5/10/15% Damage (leveled)
        ["Swift"] = 70,         -- +5/7.5/12.5% SPA (leveled)
        ["Range"] = 65,         -- +5/10/15% Range (leveled)
        ["Marksman"] = 60,      -- +30% Range
        
        -- ⭐ Utility Traits
        ["Prodigy"] = 55,       -- Max Upgrade on Placement
        ["Fortune"] = 50,       -- +20% Income, -10% Cost
        ["Scholar"] = 45,       -- +50% Experience
    },
    LastChooseTime = 0,
    ChooseCooldown = 1.5,
    PendingTraits = nil,
}

task.spawn(function()
    local TraitsData = nil
    local MiscPlacementHandler = nil
    local ChooseTraitEvent = nil
    
    -- โหลด TraitsData
    pcall(function()
        TraitsData = require(ReplicatedStorage.Modules.Data.TraitsData)
    end)
    
    -- โหลด MiscPlacementHandler
    pcall(function()
        MiscPlacementHandler = require(StarterPlayer.Modules.Gameplay.MiscPlacementHandler)
    end)
    
    -- โหลด ChooseTraitEvent
    pcall(function()
        ChooseTraitEvent = ReplicatedStorage.Networking.WorldDestroyer.ChooseTrait
    end)
    
    print("[WorldDestroyer] ✅ Auto Choose Trait system initialized!")
    
    -- ⭐⭐⭐ ฟังก์ชันคำนวณ Priority ของ Trait
    local function CalculateTraitScore(traitName)
        if _G.APSkill.WorldDestroyer.TraitPriority[traitName] then
            return _G.APSkill.WorldDestroyer.TraitPriority[traitName]
        end
        return 30  -- Default score
    end
    
    -- ⭐⭐⭐ ฟังก์ชันหา GUI WorldDestroyer ใน PlayerGui
    local function FindWorldDestroyerGUI()
        local PlayerGui = plr:WaitForChild("PlayerGui", 5)
        if not PlayerGui then return nil end
        
        -- หา WorldDestroyer GUI
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name == "WorldDestroyer" and gui.Enabled then
                return gui
            end
        end
        
        return nil
    end
    
    -- ⭐⭐⭐ ฟังก์ชันหา Cards ใน GUI
    local function FindTraitCards(gui)
        local cards = {}
        
        -- หา Holder.SelectionCards
        local holder = gui:FindFirstChild("Holder")
        if not holder then return cards end
        
        local selectionCards = holder:FindFirstChild("SelectionCards")
        if not selectionCards then return cards end
        
        -- หา Cards ทั้งหมด
        for _, card in ipairs(selectionCards:GetChildren()) do
            if card:IsA("Frame") then
                -- หา Button และ Trait Name
                local button = card:FindFirstChild("Button")
                local main = card:FindFirstChild("Main")
                
                if button and main then
                    local textContainer = main:FindFirstChild("TextContainer")
                    if textContainer then
                        local modifierTitle = textContainer:FindFirstChild("ModifierTitle")
                        if modifierTitle and modifierTitle:IsA("TextLabel") then
                            local traitName = modifierTitle.Text
                            table.insert(cards, {
                                Card = card,
                                Button = button,
                                TraitName = traitName,
                                Score = CalculateTraitScore(traitName)
                            })
                        end
                    end
                end
            end
        end
        
        -- เรียงตาม Score (สูง → ต่ำ)
        table.sort(cards, function(a, b)
            return a.Score > b.Score
        end)
        
        return cards
    end
    
    -- ⭐⭐⭐ ฟังก์ชันคลิกปุ่ม Card
    local function ClickTraitCard(cardData)
        if not cardData or not cardData.Button then return false end
        
        local clicked = false
        
        pcall(function()
            -- ใช้หลายวิธีในการ trigger button
            
            -- วิธี 1: ใช้ getconnections + Fire (ดีที่สุด)
            if getconnections then
                local connections = getconnections(cardData.Button.Activated)
                if connections and #connections > 0 then
                    for _, conn in pairs(connections) do
                        pcall(function() conn:Fire() end)
                    end
                    clicked = true
                end
                
                if not clicked then
                    connections = getconnections(cardData.Button.MouseButton1Click)
                    if connections and #connections > 0 then
                        for _, conn in pairs(connections) do
                            pcall(function() conn:Fire() end)
                        end
                        clicked = true
                    end
                end
            end
            
            -- วิธี 2: Fire Activated event ตรงๆ
            if not clicked and cardData.Button.Activated then
                pcall(function()
                    cardData.Button.Activated:Fire()
                    clicked = true
                end)
            end
            
            -- วิธี 3: Fire MouseButton1Click
            if not clicked and cardData.Button.MouseButton1Click then
                pcall(function()
                    cardData.Button.MouseButton1Click:Fire()
                    clicked = true
                end)
            end
            
            -- วิธี 4: ใช้ firesignal ถ้ามี
            if not clicked and firesignal then
                pcall(function()
                    firesignal(cardData.Button.Activated)
                    clicked = true
                end)
            end
            
            -- วิธี 5: ใช้ VirtualInputManager หรือ fireclick
            if not clicked and fireclick then
                pcall(function()
                    fireclick(cardData.Button)
                    clicked = true
                end)
            end
        end)
        
        return clicked
    end
    
    -- ⭐⭐⭐ MAIN LOOP: ตรวจจับ GUI และ Auto Click
    task.spawn(function()
        while true do
            task.wait(0.5)
            
            if not _G.APSkill.WorldDestroyer.Enabled then
                continue
            end
            
            if not _G.APSkill.WorldDestroyer.AutoChooseTrait then
                continue
            end
            
            -- Cooldown check
            local now = tick()
            if now - _G.APSkill.WorldDestroyer.LastChooseTime < _G.APSkill.WorldDestroyer.ChooseCooldown then
                continue
            end
            
            -- หา WorldDestroyer GUI
            local gui = FindWorldDestroyerGUI()
            if not gui then
                continue
            end
            
            -- หา Cards
            local cards = FindTraitCards(gui)
            if #cards == 0 then
                continue
            end
            
            -- แสดง traits ที่พบ
            local traitNames = {}
            for _, c in ipairs(cards) do
                table.insert(traitNames, string.format("%s(%.0f)", c.TraitName, c.Score))
            end
            print("[WorldDestroyer] 🎯 Found traits:", table.concat(traitNames, ", "))
            
            -- เลือก trait ที่ดีที่สุด (ตัวแรกเพราะเรียงแล้ว)
            local bestCard = cards[1]
            print(string.format("[WorldDestroyer] ⭐ Best trait: %s (score: %.1f)", bestCard.TraitName, bestCard.Score))
            
            -- กดปุ่ม
            local clicked = ClickTraitCard(bestCard)
            
            if clicked then
                _G.APSkill.WorldDestroyer.LastChooseTime = now
                print(string.format("[WorldDestroyer] ✅ Clicked trait card: %s", bestCard.TraitName))
                
                -- ⭐⭐⭐ รอให้ GUI "Select a unit..." ขึ้นมา แล้วคลิก unit ตัวแรก
                task.spawn(function()
                    task.wait(0.5)
                    
                    -- หา unit ที่วางอยู่ตัวแรกที่ยังไม่มี trait
                    local targetUnit = nil
                    local targetGUID = nil
                    
                    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
                        for guid, unit in pairs(ClientUnitHandler._ActiveUnits) do
                            if unit and unit.Name then
                                -- เลือก unit ตัวแรกที่เจอ
                                targetUnit = unit
                                targetGUID = guid
                                break
                            end
                        end
                    end
                    
                    if targetGUID then
                        -- ⭐⭐⭐ วิธี 1: FireServer ตรงๆ
                        if ChooseTraitEvent then
                            pcall(function()
                                ChooseTraitEvent:FireServer(targetGUID, bestCard.TraitName)
                                print(string.format("[WorldDestroyer] ✅ Trait %s assigned to unit %s!", 
                                    bestCard.TraitName, tostring(targetGUID)))
                            end)
                        end
                        
                        -- ⭐⭐⭐ วิธี 2: คลิก unit ใน WorldDestroyer GUI เท่านั้น (ถ้า FireServer ไม่ได้)
                        task.delay(0.3, function()
                            local plr = game:GetService("Players").LocalPlayer
                            local PlayerGui = plr:FindFirstChild("PlayerGui")
                            if not PlayerGui then return end
                            
                            -- ⭐⭐⭐ FIX: หาเฉพาะ WorldDestroyer GUI เท่านั้น (ไม่ใช่ทุก GUI!)
                            local worldDestroyerGui = PlayerGui:FindFirstChild("WorldDestroyer")
                            if not worldDestroyerGui or not worldDestroyerGui:IsA("ScreenGui") or not worldDestroyerGui.Enabled then
                                return
                            end
                            
                            -- หา unit cards/buttons ใน WorldDestroyer GUI เท่านั้น
                            local function findAndClickUnit(parent)
                                for _, child in pairs(parent:GetDescendants()) do
                                    if child:IsA("TextButton") or child:IsA("ImageButton") then
                                        -- คลิกปุ่มแรกที่เจอ (unit selection)
                                        pcall(function()
                                            if getconnections then
                                                local conns = getconnections(child.Activated)
                                                if conns and #conns > 0 then
                                                    for _, conn in pairs(conns) do
                                                        pcall(function() conn:Fire() end)
                                                    end
                                                    print("[WorldDestroyer] ✅ Clicked unit in selection GUI!")
                                                    return true
                                                end
                                            end
                                            
                                            if firesignal then
                                                firesignal(child.Activated)
                                                print("[WorldDestroyer] ✅ Clicked unit in selection GUI!")
                                                return true
                                            end
                                        end)
                                    end
                                end
                                return false
                            end
                            
                            findAndClickUnit(worldDestroyerGui)
                        end)
                    else
                        print("[WorldDestroyer] ⚠️ No active units found to assign trait")
                    end
                end)
            else
                warn("[WorldDestroyer] ❌ Failed to click trait card")
            end
        end
    end)
    
    print("[WorldDestroyer] ✅ Auto Choose Trait loop started!")
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- ⭐⭐⭐ AUTO DIG CHEST SYSTEM (Tempest Pirate / Update 10.0)
-- ═══════════════════════════════════════════════════════════════════════════
-- Based on Decom: ReplicatedStorage.Networking.Units["Update 10.0"].DigChest

_G.APSkill.AutoDigChest = _G.APSkill.AutoDigChest or {
    Enabled = true,
    LastDigTime = 0,
    DigCooldown = 3.5,  -- Cooldown ระหว่าง dig (animation ~3 วินาที)
    TrackedChests = {},  -- เก็บ UnitGUID ของ chest ที่รู้จัก
}

task.spawn(function()
    local DigChestEvent = nil
    
    -- รอจนกว่า DigChest event จะโหลด
    pcall(function()
        local UnitsFolder = ReplicatedStorage:WaitForChild("Networking", 10)
            and ReplicatedStorage.Networking:FindFirstChild("Units")
        
        if UnitsFolder then
            local Update10Folder = UnitsFolder:FindFirstChild("Update 10.0")
            if Update10Folder then
                DigChestEvent = Update10Folder:FindFirstChild("DigChest")
            end
        end
    end)
    
    if not DigChestEvent then
        -- ไม่มี DigChest event, ข้าม
        return
    end
    
    print("[AutoDigChest] ✅ DigChest event found!")
    
    -- ⭐⭐⭐ ฟังก์ชันหา Chest ที่สามารถ dig ได้
    local function FindDiggableChests()
        local chests = {}
        
        -- หา ProximityPrompt ใน workspace.Ignore (ตามที่ AddIcon สร้าง)
        pcall(function()
            local ignoreFolder = workspace:FindFirstChild("Ignore")
            if ignoreFolder then
                for _, obj in ipairs(ignoreFolder:GetChildren()) do
                    if obj:IsA("BasePart") then
                        local prompt = obj:FindFirstChild("ProximityPrompt")
                        local billboard = obj:FindFirstChild("BillboardGui")
                        
                        if prompt and prompt.Enabled and billboard then
                            -- เช็คว่าเป็น Dig Chest
                            local actionText = prompt.ActionText or ""
                            local objectText = prompt.ObjectText or ""
                            
                            if actionText:lower():find("dig") or objectText:lower():find("chest") 
                               or (billboard:FindFirstChild("TextLabel") and billboard.TextLabel.Text:find("Chest")) then
                                table.insert(chests, {
                                    Part = obj,
                                    Prompt = prompt,
                                    Position = obj.Position
                                })
                            end
                        end
                    end
                end
            end
        end)
        
        -- ⭐ ยังหา ProximityPrompt ที่มี "Dig" จากที่อื่นด้วย
        pcall(function()
            for _, prompt in ipairs(game:GetService("CollectionService"):GetTagged("ProximityPrompt") or {}) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local actionText = prompt.ActionText or ""
                    if actionText:lower():find("dig") then
                        local parent = prompt.Parent
                        if parent and parent:IsA("BasePart") then
                            table.insert(chests, {
                                Part = parent,
                                Prompt = prompt,
                                Position = parent.Position
                            })
                        end
                    end
                end
            end
        end)
        
        return chests
    end
    
    -- ⭐⭐⭐ ฟังก์ชัน Dig Chest โดยใช้ Event
    local function DigChest(unitGUID)
        local now = tick()
        if now - _G.APSkill.AutoDigChest.LastDigTime < _G.APSkill.AutoDigChest.DigCooldown then
            return false
        end
        
        local success = pcall(function()
            DigChestEvent:FireServer(unitGUID)
        end)
        
        if success then
            _G.APSkill.AutoDigChest.LastDigTime = now
            print(string.format("[AutoDigChest] ⛏️ Digging chest: %s", tostring(unitGUID)))
            return true
        end
        
        return false
    end
    
    -- ⭐⭐⭐ ฟังก์ชัน Trigger ProximityPrompt
    local function TriggerPrompt(prompt)
        local now = tick()
        if now - _G.APSkill.AutoDigChest.LastDigTime < _G.APSkill.AutoDigChest.DigCooldown then
            return false
        end
        
        local success = pcall(function()
            -- ใช้ fireproximityprompt ถ้ามี
            if fireproximityprompt then
                fireproximityprompt(prompt)
            else
                -- Fallback: trigger manually
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
            end
        end)
        
        if success then
            _G.APSkill.AutoDigChest.LastDigTime = now
            print("[AutoDigChest] ⛏️ Triggered ProximityPrompt!")
            return true
        end
        
        return false
    end
    
    -- ⭐⭐⭐ MAIN LOOP: Auto Dig Chest
    task.spawn(function()
        while true do
            task.wait(1)
            
            if not _G.APSkill.AutoDigChest.Enabled then
                continue
            end
            
            local character = plr.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if not humanoidRootPart then
                continue
            end
            
            -- ⭐⭐⭐ หา Chest Icon ใน workspace.Ignore
            local foundChest = nil
            local chestGUID = nil
            
            pcall(function()
                local ignoreFolder = workspace:FindFirstChild("Ignore")
                if ignoreFolder then
                    for _, obj in ipairs(ignoreFolder:GetChildren()) do
                        if obj:IsA("BasePart") then
                            local prompt = obj:FindFirstChild("ProximityPrompt")
                            local billboard = obj:FindFirstChild("BillboardGui")
                            
                            if prompt and prompt.Enabled and billboard and billboard.Enabled then
                                -- นี่คือ Dig Chest icon!
                                foundChest = obj
                                break
                            end
                        end
                    end
                end
            end)
            
            if foundChest then
                local chestPos = foundChest.Position
                local playerPos = humanoidRootPart.Position
                local distance = (Vector3.new(chestPos.X, 0, chestPos.Z) - Vector3.new(playerPos.X, 0, playerPos.Z)).Magnitude
                
                -- ⭐⭐⭐ ถ้าไกลกว่า 10 studs → วาปไปที่ chest
                if distance > 10 then
                    local teleportPos = chestPos + Vector3.new(0, 3, 0)
                    
                    pcall(function()
                        humanoidRootPart.CFrame = CFrame.new(teleportPos)
                    end)
                    
                    print(string.format("[AutoDigChest] 🚀 Teleported to chest at (%.1f, %.1f, %.1f)", 
                        chestPos.X, chestPos.Y, chestPos.Z))
                    
                    task.wait(0.5)
                end
                
                -- ⭐⭐⭐ Trigger ProximityPrompt
                local prompt = foundChest:FindFirstChild("ProximityPrompt")
                if prompt and prompt.Enabled then
                    local now = tick()
                    if now - _G.APSkill.AutoDigChest.LastDigTime >= _G.APSkill.AutoDigChest.DigCooldown then
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                prompt:InputHoldBegin()
                                task.wait(0.1)
                                prompt:InputHoldEnd()
                            end
                        end)
                        
                        _G.APSkill.AutoDigChest.LastDigTime = now
                        print("[AutoDigChest] ⛏️ Digging chest!")
                    end
                end
            end
        end
    end)
    
    print("[AutoDigChest] ✅ Auto Dig Chest system initialized!")
end)

return _G.AbilitySystem