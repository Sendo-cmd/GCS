-- AV_AutoPlay_v2.lua
-- ระบบ Auto Play อัจฉริยะ - ออกแบบตามโครงสร้างที่กำหนด
-- Version 2.0 - Refactored with Clean Architecture

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

--[[
================================================================================
                            📋 STRUCTURE OVERVIEW
================================================================================
1. Core Flow (Main Loop)
   - ทำได้แค่ 1 action ต่อรอบ
   - ห้าม spam วาง / spam อัพเกรด

2. Unit Classification
   - Economy Unit (ตัวเงิน) - Priority 1
   - Damage Unit (ตัวดาเมจ) - Priority 2  
   - Buff Unit (ตัวบัพ) - Priority 3

3. Placement Logic
   - Economy: ไกลจาก path
   - Damage: ใกล้ path, inside corner
   - Buff: ครอบคลุม Unit มากที่สุด

4. Upgrade Logic
   - Economy First → Emergency Check → Damage
   
5. Sell Logic
   - ขายเฉพาะ Economy Unit เมื่อถึง Max Wave

6. Anti-Spam Protection
   - เช็คเงินก่อนทุก Action

7. Enemy Mode
   - วาง Damage Unit ใกล้ Enemy Base
================================================================================
]]

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

--[[
================================================================================
                           🛠️ UTILITY FUNCTIONS (Early Declaration)
================================================================================
]]

-- ประกาศ DebugPrint ก่อนเพื่อให้ LoadModules ใช้ได้
local Settings = {Debug = true}  -- ประกาศ Settings.Debug ก่อน
local function DebugPrint(...)
    if Settings.Debug then
        print("[AutoPlay v2]", ...)
    end
end

-- ===== GAME MODULES =====
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Gameplay = Modules:WaitForChild("Gameplay")
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitEvent = Networking:WaitForChild("UnitEvent")

-- ===== GAME EVENTS FOR AUTO START / VOTE SKIP =====
local SkipWaveEvent = nil
local GameEvent = nil

-- โหลด Events หลังจากที่ Networking พร้อม
task.spawn(function()
    SkipWaveEvent = Networking:WaitForChild("SkipWaveEvent", 10)
    GameEvent = Networking:FindFirstChild("GameEvent")
    if SkipWaveEvent then
        DebugPrint("✅ พบ SkipWaveEvent")
    end
end)

-- Load Game Modules
local ClientUnitHandler, PlacementValidationHandler, EnemyPathHandler, PathMathHandler, PlayerYenHandler
local UnitsData  -- ข้อมูล Unit จากเกม (สำหรับเช็ค IsIncome)
local UnitsHUD   -- ข้อมูล Hotbar Units จากเกม

local function LoadModules()
    pcall(function()
        ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler)
    end)
    pcall(function()
        PlacementValidationHandler = require(ReplicatedStorage.Modules.Gameplay.PlacementValidationHandler)
    end)
    pcall(function()
        EnemyPathHandler = require(ReplicatedStorage.Modules.Shared.EnemyPathHandler)
    end)
    pcall(function()
        PathMathHandler = require(ReplicatedStorage.Modules.Shared.PathMathHandler)
    end)
    pcall(function()
        PlayerYenHandler = require(StarterPlayer.Modules.Gameplay.PlayerYenHandler)
    end)
    -- โหลด Units Data (สำหรับเช็ค IsIncome)
    pcall(function()
        UnitsData = require(ReplicatedStorage.Modules.Data.Entities.Units)
    end)
    -- โหลด UnitsHUD (สำหรับดึง Hotbar)
    pcall(function()
        UnitsHUD = require(StarterPlayer.Modules.Interface.Loader.HUD.Units)
    end)
end
LoadModules()

--[[
================================================================================
                              ⚙️ SETTINGS
================================================================================
]]

Settings.Enabled = true
Settings.Debug = true

-- ===== AUTO START / VOTE SKIP =====
Settings.AutoStart = true           -- เริ่มเกมอัตโนมัติ
Settings.AutoVoteSkip = true        -- กด Vote Skip อัตโนมัติ
Settings.VoteSkipCooldown = 2       -- Cooldown ระหว่าง Vote Skip (วินาที)

-- Timing (Hard Rule: ทำได้แค่ 1 action ต่อรอบ)
Settings.ActionCooldown = 0.8      -- รอกี่วินาทีระหว่าง Action
Settings.MainLoopInterval = 0.5    -- Tick interval ของ main loop

-- การวาง
Settings.AutoPlace = true
Settings.PlacePriority = {1, 2, 3, 4, 5, 6}  -- ลำดับ slot
Settings.UnitSpacing = 4           -- ระยะห่างระหว่าง Units

-- การอัพเกรด
Settings.AutoUpgrade = true
Settings.MaxUpgradeLevel = 10

-- Emergency (กรณีฉุกเฉิน)
Settings.EmergencyThreshold = 60   -- % progress ที่ถือว่าฉุกเฉิน

-- Enemy Mode (กันบ้านแตก / บอส)
Settings.EnemyModeEnabled = true
Settings.EnemyModeUnits = 2        -- จำนวน Unit ที่จะวางใกล้ Enemy Base

-- Placement Settings
Settings.EconomyMinDistFromPath = 15  -- ระยะขั้นต่ำจาก path สำหรับ Economy
Settings.DamageMinTimeInRange = 1     -- Hard Stop: TimeInRange ขั้นต่ำ (วินาที)

-- Path Analysis
Settings.InsideCornerBonus = 150
Settings.OutsideCornerPenalty = 100
Settings.MultiPathBonus = 200

--[[
================================================================================
                           📊 DATA STORAGE
================================================================================
]]

local State = {
    -- Wave Tracking
    CurrentWave = 0,
    MaxWave = 0,
    
    -- Yen Tracking
    CurrentYen = 0,
    
    -- Action Tracking (Hard Rule: ทำได้แค่ 1 action ต่อรอบ)
    LastActionTime = 0,
    LastActionType = nil,  -- "place", "upgrade", "sell"
    
    -- Unit Tracking
    PlacedPositions = {},
    ActiveUnits = {},
    
    -- Slot Tracking
    SlotPlaceCount = {},  -- {[slot] = count}
    
    -- Emergency State
    IsEmergency = false,
    EnemyProgressMax = 0,
    
    -- Economy Unit Sold (for Max Wave)
    EconomySold = false,
    
    -- Auto Start / Vote Skip
    LastVoteSkipTime = 0,
    MatchStarted = false,
    
    -- Path Cache
    CachedPath = nil,
    CachedCorners = nil,
    LastPathUpdate = 0,
}

-- Unit Classification Cache
local UnitClassification = {
    Economy = {},  -- {slot = true, ...}
    Damage = {},
    Buff = {},
}

--[[
================================================================================
                           🛠️ UTILITY FUNCTIONS
================================================================================
]]

-- Hard Rule: ทำได้แค่ 1 action ต่อรอบ
local function CanDoAction()
    return tick() - State.LastActionTime >= Settings.ActionCooldown
end

local function RecordAction(actionType)
    State.LastActionTime = tick()
    State.LastActionType = actionType
    DebugPrint("✅ Action recorded:", actionType)
end

--[[
================================================================================
                        💰 YEN SYSTEM (Anti-Spam Protection)
================================================================================
Rule: ก่อนทุก Action ต้องเช็คเงินก่อน
      ถ้า yen < cost → ห้ามวาง, ห้ามอัพเกรด, wait, recheck
]]

local function GetYen()
    -- วิธี 1: ใช้ PlayerYenHandler
    if PlayerYenHandler and PlayerYenHandler.GetYen then
        local yen = PlayerYenHandler.GetYen()
        if yen then
            State.CurrentYen = yen
            return yen
        end
    end
    
    -- วิธี 2: อ่านจาก UI
    local yen = 0
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            for _, child in pairs(HUD:GetDescendants()) do
                if child:IsA("TextLabel") then
                    local text = child.Text or ""
                    -- หา pattern เงิน เช่น "¥ 1,234" หรือ "1234"
                    local yenMatch = text:match("¥%s*([%d,]+)") or text:match("([%d,]+)%s*¥")
                    if yenMatch then
                        local cleanYen = yenMatch:gsub(",", "")
                        yen = tonumber(cleanYen) or 0
                        if yen > 0 then break end
                    end
                end
            end
        end
    end)
    
    State.CurrentYen = yen
    return yen
end

-- Hard Rule: ห้าม spam
local function CanAfford(cost)
    local yen = GetYen()
    if yen < cost then
        return false
    end
    return true
end

--[[
================================================================================
                        📊 WAVE TRACKING SYSTEM
================================================================================
- หา maxWave จากข้อมูล map (ไม่ hardcode)
- รองรับรูปแบบ เช่น 15/15, 30/30
]]

local function GetWaveFromUI()
    local currentWave = 0
    local totalWaves = 0
    
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            local Map = HUD:FindFirstChild("Map")
            if Map then
                local WavesAmount = Map:FindFirstChild("WavesAmount")
                if WavesAmount and WavesAmount:IsA("TextLabel") then
                    local text = WavesAmount.Text or ""
                    -- ลบ RichText tags
                    local cleanText = text:gsub("<[^>]+>", "")
                    
                    -- Parse "3/15" format
                    local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                    if cur and total then
                        currentWave = tonumber(cur) or 0
                        totalWaves = tonumber(total) or 0
                    end
                end
            end
        end
        
        -- Fallback: หาจาก descendants
        if totalWaves == 0 then
            local HUD = PlayerGui:FindFirstChild("HUD")
            if HUD then
                for _, gui in pairs(HUD:GetDescendants()) do
                    if gui:IsA("TextLabel") then
                        local text = gui.Text or ""
                        local cleanText = text:gsub("<[^>]+>", "")
                        local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                        if cur and total then
                            local parsedTotal = tonumber(total)
                            if parsedTotal and parsedTotal > 0 and parsedTotal < 100 then
                                currentWave = tonumber(cur) or 0
                                totalWaves = parsedTotal
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return currentWave, totalWaves
end

local function UpdateWaveTracking()
    local cur, total = GetWaveFromUI()
    if cur > 0 then State.CurrentWave = cur end
    if total > 0 then State.MaxWave = total end
end

local function IsMaxWave()
    return State.MaxWave > 0 and State.CurrentWave >= State.MaxWave
end

--[[
================================================================================
                        🎮 HOTBAR & UNIT DATA
================================================================================
]]

local function GetHotbarUnits()
    local units = {}
    
    -- ===== วิธี 1: ใช้ UnitsHUD._Cache (ถ้ามี) =====
    if UnitsHUD and UnitsHUD._Cache then
        pcall(function()
            for slot, v in pairs(UnitsHUD._Cache) do
                if v ~= "None" and v ~= nil then
                    local unitData = v.Data or v
                    local price = unitData.Cost or unitData.Price or v.Cost or 0
                    
                    -- หา Range จาก unit data โดยตรง
                    local range = unitData.Range 
                        or unitData.AttackRange 
                        or (unitData.Stats and unitData.Stats.Range)
                        or (unitData.BaseStats and unitData.BaseStats.Range)
                        or 25
                    
                    units[slot] = {
                        Slot = slot,
                        Name = unitData.Name or v.Name or "Unknown",
                        ID = unitData.ID or unitData.Identifier or slot,
                        Price = price,
                        Range = range,
                        
                        -- เก็บข้อมูลเพิ่มเติมสำหรับ Classification
                        Income = unitData.Income,
                        PassiveIncome = unitData.PassiveIncome,
                        IncomePerWave = unitData.IncomePerWave,
                        Abilities = unitData.Abilities,
                        Tags = unitData.Tags,
                        UnitType = unitData.UnitType,
                        Damage = unitData.Damage,
                    }
                    DebugPrint(string.format("📦 Slot %d: %s | Price=%d | Range=%d", 
                        slot, units[slot].Name, units[slot].Price, units[slot].Range))
                end
            end
        end)
        
        if next(units) then
            DebugPrint("✅ ดึง Hotbar จาก UnitsHUD._Cache สำเร็จ:", #units, "units")
            return units
        end
    end
    
    -- ===== วิธี 2: อ่านจาก UI แล้วหาข้อมูลจาก UnitsData =====
    DebugPrint("⚠️ UnitsHUD._Cache ไม่พร้อม, ใช้ UI + UnitsData")
    
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then 
        DebugPrint("❌ ไม่พบ Hotbar")
        return units 
    end
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then 
        DebugPrint("❌ ไม่พบ Hotbar.Main")
        return units 
    end
    
    local UnitsFrame = Main:FindFirstChild("Units")
    if not UnitsFrame then 
        DebugPrint("❌ ไม่พบ Hotbar.Main.Units")
        return units 
    end
    
    -- อ่านชื่อ Unit จาก UI
    for slot = 1, 6 do
        local slotFrame = UnitsFrame:FindFirstChild(tostring(slot))
        if slotFrame and slotFrame.Visible then
            local unitName = nil
            
            -- หาชื่อจาก TextLabel
            for _, child in pairs(slotFrame:GetDescendants()) do
                if child:IsA("TextLabel") then
                    local childName = child.Name:lower()
                    if childName:find("name") or childName == "unitname" then
                        if child.Text and child.Text ~= "" then
                            unitName = child.Text
                            break
                        end
                    end
                end
            end
            
            if unitName then
                -- ดึงข้อมูลจาก UnitsData
                local unitData = nil
                if UnitsData then
                    pcall(function()
                        -- ลองหาแบบต่างๆ
                        if UnitsData.RetrieveUnitData then
                            unitData = UnitsData:RetrieveUnitData(unitName)
                        elseif UnitsData.GetUnitData then
                            unitData = UnitsData:GetUnitData(unitName)
                        elseif UnitsData[unitName] then
                            unitData = UnitsData[unitName]
                        else
                            -- ลองหาแบบ loop
                            for name, data in pairs(UnitsData) do
                                if type(data) == "table" and name == unitName then
                                    unitData = data
                                    break
                                end
                            end
                        end
                    end)
                end
                
                -- สร้าง unit object
                units[slot] = {
                    Slot = slot,
                    Name = unitName,
                    Price = (unitData and unitData.Price) or 0,
                    ID = slot,
                    Range = (unitData and unitData.Range) or 25,
                    
                    -- เก็บข้อมูลสำหรับ Classification
                    Income = unitData and unitData.Income,
                    PassiveIncome = unitData and unitData.PassiveIncome,
                    IncomePerWave = unitData and unitData.IncomePerWave,
                    Abilities = unitData and unitData.Abilities,
                    Tags = unitData and unitData.Tags,
                    UnitType = unitData and unitData.UnitType,
                    Damage = unitData and unitData.Damage,
                }
                
                DebugPrint(string.format("📦 Slot %d: %s | FromUnitsData=%s", 
                    slot, unitName, tostring(unitData ~= nil)))
            end
        end
    end
    
    return units
end

-- เช็ค slot limit
local function GetSlotLimit(slot)
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return 99, 0 end
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then return 99, 0 end
    
    local Units = Main:FindFirstChild("Units")
    if not Units then return 99, 0 end
    
    local slotFrame = Units:FindFirstChild(tostring(slot))
    if not slotFrame then return 99, 0 end
    
    for _, child in pairs(slotFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local text = child.Text
            if text and type(text) == "string" then
                local current, max = text:match("(%d+)/(%d+)")
                if current and max then
                    return tonumber(max), tonumber(current)
                end
            end
        end
    end
    
    return 99, State.SlotPlaceCount[slot] or 0
end

local function CanPlaceSlot(slot)
    local limit, current = GetSlotLimit(slot)
    return current < limit
end

--[[
================================================================================
                    🔍 UNIT CLASSIFICATION SYSTEM
================================================================================
ประเภท Unit:
1. Economy Unit (ตัวเงิน) - Priority 1 (สูงสุด)
2. Damage Unit (ตัวดาเมจ) - Priority 2
3. Buff Unit (ตัวบัพ) - Priority 3 (ต่ำสุด)

ใช้หลายวิธีเช็ค: Fields, Abilities, Tags, UnitType, ชื่อ
]]

local function ClassifyUnit(unitData)
    if not unitData then return "Damage" end
    
    local name = unitData.Name or ""
    local nameLower = name:lower()
    
    -- ===== วิธี 1: เช็คจาก Field โดยตรง (Income, PassiveIncome, IncomePerWave) =====
    if unitData.Income or unitData.PassiveIncome or unitData.IncomePerWave then
        DebugPrint("💰 พบ Income Unit จาก Field:", name)
        return "Economy"
    end
    
    -- ===== วิธี 2: เช็คจาก Abilities =====
    if unitData.Abilities then
        for abilityName, ability in pairs(unitData.Abilities) do
            if type(abilityName) == "string" then
                local abilityLower = abilityName:lower()
                -- เช็ค Economy
                if abilityLower:find("income") or abilityLower:find("money") or abilityLower:find("farm") then
                    DebugPrint("💰 พบ Income Unit จาก Ability:", name)
                    return "Economy"
                end
                -- เช็ค Buff
                if abilityLower:find("buff") or abilityLower:find("aura") or abilityLower:find("boost") or
                   abilityLower:find("support") or abilityLower:find("enhance") then
                    DebugPrint("🛡️ พบ Buff Unit จาก Ability:", name)
                    return "Buff"
                end
            end
            
            if type(ability) == "table" then
                -- เช็ค Economy Ability
                if ability.Type and tostring(ability.Type):lower():find("income") then
                    DebugPrint("💰 พบ Income Unit จาก Ability.Type:", name)
                    return "Economy"
                end
                if ability.Income then
                    DebugPrint("💰 พบ Income Unit จาก Ability.Income:", name)
                    return "Economy"
                end
                -- เช็ค Buff Ability
                if ability.Type then
                    local typeLower = tostring(ability.Type):lower()
                    if typeLower:find("buff") or typeLower:find("aura") or typeLower:find("support") then
                        DebugPrint("🛡️ พบ Buff Unit จาก Ability.Type:", name)
                        return "Buff"
                    end
                end
            end
        end
    end
    
    -- ===== วิธี 3: เช็คจาก Tags =====
    if unitData.Tags then
        for _, tag in pairs(unitData.Tags) do
            local tagLower = tostring(tag):lower()
            -- เช็ค Economy
            if tagLower:find("income") or tagLower:find("farm") or tagLower:find("money") then
                DebugPrint("💰 พบ Income Unit จาก Tag:", name)
                return "Economy"
            end
        end
    end
    
    -- ===== วิธี 4: เช็คจาก UnitType =====
    if unitData.UnitType then
        local typeLower = tostring(unitData.UnitType):lower()
        -- เช็ค Economy
        if typeLower:find("income") or typeLower:find("farm") then
            DebugPrint("💰 พบ Income Unit จาก UnitType:", name)
            return "Economy"
        end
        -- เช็ค Buff
        if typeLower:find("support") or typeLower:find("buff") then
            DebugPrint("🛡️ พบ Buff Unit จาก UnitType:", name)
            return "Buff"
        end
    end
    
    -- ===== วิธี 5: เช็คว่าไม่มี Damage = Support =====
    if unitData.Damage == nil or unitData.Damage == 0 then
        if unitData.Range and unitData.Range > 0 then
            DebugPrint("🛡️ พบ Buff Unit (ไม่มี Damage แต่มี Range):", name)
            return "Buff"
        end
    end
    
    -- ===== วิธี 6: เช็คจาก unitData.IsIncome / IsBuff (ที่ตั้งไว้แล้ว) =====
    if unitData.IsIncome == true then 
        DebugPrint("💰 พบ Income Unit จาก unitData.IsIncome:", name)
        return "Economy" 
    end
    
    if unitData.IsBuff == true then 
        DebugPrint("🛡️ พบ Buff Unit จาก unitData.IsBuff:", name)
        return "Buff" 
    end
    
    -- ===== วิธี 7: เช็คจากชื่อ (Fallback) =====
    local economyKeywords = {
        "income", "money", "farm", "bank", "coin", "gold", "yen", "cash", 
        "fortune", "treasure", "moneybag", "investor", "merchant"
    }
    for _, keyword in ipairs(economyKeywords) do
        if nameLower:find(keyword) then 
            DebugPrint("💰 พบ Income Unit จากชื่อ:", name)
            return "Economy" 
        end
    end
    
    local buffKeywords = {
        "buff", "support", "boost", "aura", "heal", "shield", 
        "enhance", "empower", "blessing", "bless"
    }
    for _, keyword in ipairs(buffKeywords) do
        if nameLower:find(keyword) then 
            DebugPrint("🛡️ พบ Buff Unit จากชื่อ:", name)
            return "Buff" 
        end
    end
    
    -- ===== Default = Damage =====
    return "Damage"
end

local function UpdateUnitClassification()
    UnitClassification = {Economy = {}, Damage = {}, Buff = {}}
    
    local hotbar = GetHotbarUnits()
    
    DebugPrint("=== เริ่ม UpdateUnitClassification ===")
    local hotbarCount = 0
    for _ in pairs(hotbar) do hotbarCount = hotbarCount + 1 end
    DebugPrint("📊 พบ Units ใน Hotbar:", hotbarCount)
    
    for slot, unitData in pairs(hotbar) do
        DebugPrint(string.format("🔍 Slot %d: %s | IsIncome=%s | IsBuff=%s", 
            slot, unitData.Name or "Unknown", 
            tostring(unitData.IsIncome), tostring(unitData.IsBuff)))
        
        local unitType = ClassifyUnit(unitData)
        UnitClassification[unitType][slot] = true
        DebugPrint(string.format("📋 Classified slot %d as %s - %s", slot, unitType, unitData.Name))
    end
    
    -- แสดงสรุป
    local economyCount = 0
    local damageCount = 0
    local buffCount = 0
    for _ in pairs(UnitClassification.Economy) do economyCount = economyCount + 1 end
    for _ in pairs(UnitClassification.Damage) do damageCount = damageCount + 1 end
    for _ in pairs(UnitClassification.Buff) do buffCount = buffCount + 1 end
    
    DebugPrint(string.format("📊 Classification Summary: Economy=%d, Damage=%d, Buff=%d", 
        economyCount, damageCount, buffCount))
    DebugPrint("=== สิ้นสุด UpdateUnitClassification ===")
end

local function IsEconomySlot(slot)
    return UnitClassification.Economy[slot] == true
end

local function IsDamageSlot(slot)
    return UnitClassification.Damage[slot] == true
end

local function IsBuffSlot(slot)
    return UnitClassification.Buff[slot] == true
end

local function HasEconomyUnit()
    for slot, _ in pairs(UnitClassification.Economy) do
        return true
    end
    return false
end

--[[
================================================================================
                        🗺️ PATH & PLACEMENT SYSTEM
================================================================================
]]

local function GetMapPath()
    -- Use cache if available and recent
    if State.CachedPath and tick() - State.LastPathUpdate < 5 then
        return State.CachedPath
    end
    
    local path = {}
    
    -- วิธี 1: ใช้ EnemyPathHandler
    if EnemyPathHandler and EnemyPathHandler.Nodes then
        for nodeName, node in pairs(EnemyPathHandler.Nodes) do
            if node.Position then
                table.insert(path, {
                    Position = node.Position,
                    Index = node.Index or 0,
                })
            end
        end
        if #path > 0 then
            table.sort(path, function(a, b)
                return (a.Index or 0) < (b.Index or 0)
            end)
            local positions = {}
            for _, p in ipairs(path) do
                table.insert(positions, p.Position)
            end
            State.CachedPath = positions
            State.LastPathUpdate = tick()
            return positions
        end
    end
    
    -- วิธี 2: หาจาก workspace
    local pathFolders = {
        workspace:FindFirstChild("Path"),
        workspace:FindFirstChild("Paths"),
        workspace:FindFirstChild("WayPoints"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Path"),
    }
    
    for _, pathFolder in pairs(pathFolders) do
        if pathFolder then
            for _, node in pairs(pathFolder:GetChildren()) do
                if node:IsA("BasePart") then
                    table.insert(path, node.Position)
                elseif node:IsA("Attachment") then
                    table.insert(path, node.WorldPosition)
                end
            end
            if #path > 0 then break end
        end
    end
    
    State.CachedPath = path
    State.LastPathUpdate = tick()
    return path
end

-- หาตำแหน่งที่วางได้ทั้งหมด
local function GetPlaceablePositions()
    local positions = {}
    local spacing = Settings.UnitSpacing
    
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
                            for _, placedPos in pairs(State.PlacedPositions) do
                                if (placedPos - worldPos).Magnitude < spacing then
                                    occupied = true
                                    break
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
    
    return positions
end

-- คำนวณระยะจาก path ที่ใกล้ที่สุด
local function GetDistanceFromPath(position)
    local path = GetMapPath()
    if #path == 0 then return math.huge end
    
    local closestDist = math.huge
    for _, node in pairs(path) do
        local dist = (position - node).Magnitude
        if dist < closestDist then
            closestDist = dist
        end
    end
    return closestDist
end

-- หามุมโค้งของ path (Inside Corner)
local function GetPathCorners()
    if State.CachedCorners and tick() - State.LastPathUpdate < 5 then
        return State.CachedCorners
    end
    
    local path = GetMapPath()
    local corners = {}
    
    for i = 2, #path - 1 do
        local prev = path[i-1]
        local curr = path[i]
        local nextNode = path[i+1]
        
        local dir1 = Vector3.new(curr.X - prev.X, 0, curr.Z - prev.Z)
        local dir2 = Vector3.new(nextNode.X - curr.X, 0, nextNode.Z - curr.Z)
        
        if dir1.Magnitude > 0.1 and dir2.Magnitude > 0.1 then
            dir1 = dir1.Unit
            dir2 = dir2.Unit
            local dot = math.clamp(dir1.X * dir2.X + dir1.Z * dir2.Z, -1, 1)
            local angle = math.deg(math.acos(dot))
            
            if angle >= 30 then
                -- คำนวณทิศทาง Inside (ด้านใน)
                local insideDir = (dir1 + dir2)
                if insideDir.Magnitude > 0.1 then
                    insideDir = insideDir.Unit
                end
                
                table.insert(corners, {
                    Position = curr,
                    Index = i,
                    Angle = angle,
                    InsideDir = insideDir,
                })
            end
        end
    end
    
    State.CachedCorners = corners
    return corners
end

-- คำนวณ Time In Range (เวลาที่ enemy อยู่ในระยะยิง)
local function CalculateTimeInRange(position, unitRange)
    local path = GetMapPath()
    if #path == 0 then return 0 end
    
    local timeInRange = 0
    local enemySpeed = 10  -- สมมติ enemy เดิน 10 studs/sec
    
    for i = 1, #path - 1 do
        local p1 = path[i]
        local p2 = path[i + 1]
        local segmentLength = (p2 - p1).Magnitude
        
        -- เช็คว่า segment นี้อยู่ในระยะยิงหรือไม่
        local dist1 = (position - p1).Magnitude
        local dist2 = (position - p2).Magnitude
        
        if dist1 <= unitRange or dist2 <= unitRange then
            -- ประมาณว่า segment นี้อยู่ในระยะ
            local coverage = math.min(1, unitRange / math.max(dist1, dist2, 1))
            timeInRange = timeInRange + (segmentLength * coverage / enemySpeed)
        end
    end
    
    return timeInRange
end

-- นับว่าตำแหน่งนี้ยิงโดน path กี่เส้น
local function CountPathsHit(position, unitRange)
    local path = GetMapPath()
    if #path == 0 then return 0 end
    
    local pathsHit = 0
    local lastHitIndex = -100
    
    for i, node in ipairs(path) do
        local dist = (position - node).Magnitude
        if dist <= unitRange then
            -- ถ้าห่างจาก hit ล่าสุดเกิน 5 nodes = นับเป็น path ใหม่
            if i - lastHitIndex > 5 then
                pathsHit = pathsHit + 1
            end
            lastHitIndex = i
        end
    end
    
    return pathsHit
end

--[[
================================================================================
                    📍 PLACEMENT LOGIC - Economy Unit
================================================================================
หน้าที่: เพิ่ม Yen ให้ระบบ
Priority: สูงสุด (อันดับ 1)

การวาง Economy Unit:
- ต้องวางก่อน Unit ทุกประเภท
- วาง "นอก path" เท่านั้น
- เลือกตำแหน่งที่ระยะห่างจาก path มากที่สุด
- ตัวเงินไม่ต้องยิง → ไม่จำเป็นต้องใกล้ path
]]

local function GetBestEconomyPosition()
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    local bestPos = nil
    local bestDist = 0
    local MIN_DIST = Settings.EconomyMinDistFromPath  -- ระยะขั้นต่ำจาก path
    
    for _, pos in pairs(positions) do
        local distFromPath = GetDistanceFromPath(pos)
        
        -- Logic: เลือกตำแหน่งที่ห่างจาก path มากที่สุด
        if distFromPath >= MIN_DIST and distFromPath > bestDist then
            bestDist = distFromPath
            bestPos = pos
        end
    end
    
    -- ถ้าไม่เจอที่ห่างพอ ให้หาที่ห่างที่สุดเท่าที่มี
    if not bestPos then
        for _, pos in pairs(positions) do
            local distFromPath = GetDistanceFromPath(pos)
            if distFromPath > bestDist then
                bestDist = distFromPath
                bestPos = pos
            end
        end
    end
    
    if bestPos then
        DebugPrint(string.format("💰 Economy Position: ห่าง path %.1f studs", bestDist))
    end
    
    return bestPos
end

--[[
================================================================================
                    📍 PLACEMENT LOGIC - Damage Unit
================================================================================
หน้าที่: โจมตี Enemy
Priority: รองจาก Economy Unit (อันดับ 2)

การวาง Damage Unit:
- วางหลัง Economy Unit เสมอ
- วางใกล้ path
- ห้ามวาง outside corner (มุมแหลมด้านนอก)

ตำแหน่งที่เหมาะสมต้อง:
- ยิงโดน path มากกว่า 1 เส้น (ถ้ามี)
- ครอบคลุม path ได้มากที่สุด
- อยู่ในตำแหน่งที่ enemy อยู่ใน range นาน
- อยู่ใกล้ Enemy Base ได้ (เพื่อกันบ้านแตก / บอส)

PlacementScore = (NumberOfPathsHit * 200) + (TimeInRange * 100) + InsideCornerBonus

Hard Stop: ถ้า TimeInRange < 1 วินาที → ห้ามวาง
]]

local function GetBestDamagePosition(unitRange)
    unitRange = unitRange or 25
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    local path = GetMapPath()
    if #path == 0 then return nil end
    
    local corners = GetPathCorners()
    local bestPos = nil
    local bestScore = -math.huge
    
    local MIN_TIME_IN_RANGE = Settings.DamageMinTimeInRange  -- Hard Stop
    
    for _, pos in pairs(positions) do
        local timeInRange = CalculateTimeInRange(pos, unitRange)
        
        -- Hard Stop: ถ้า TimeInRange < 1 วินาที → ห้ามวาง
        if timeInRange < MIN_TIME_IN_RANGE then
            continue
        end
        
        local pathsHit = CountPathsHit(pos, unitRange)
        local distFromPath = GetDistanceFromPath(pos)
        
        -- เช็คว่าอยู่ในระยะยิงหรือไม่
        if distFromPath > unitRange then
            continue
        end
        
        -- ===== คำนวณ Score =====
        -- PlacementScore = (NumberOfPathsHit * 200) + (TimeInRange * 100) + InsideCornerBonus
        local score = 0
        score = score + (pathsHit * Settings.MultiPathBonus)
        score = score + (timeInRange * 100)
        
        -- Inside Corner Bonus / Outside Corner Penalty
        for _, corner in pairs(corners) do
            local distToCorner = (pos - corner.Position).Magnitude
            if distToCorner <= unitRange then
                -- เช็คว่าอยู่ด้าน inside หรือไม่
                local dirToPos = (pos - corner.Position)
                if dirToPos.Magnitude > 0.1 then
                    dirToPos = dirToPos.Unit
                    local dot = corner.InsideDir.X * dirToPos.X + corner.InsideDir.Z * dirToPos.Z
                    if dot > 0 then  -- อยู่ด้าน inside
                        score = score + Settings.InsideCornerBonus
                    else
                        score = score - Settings.OutsideCornerPenalty  -- ห้ามวาง outside corner
                    end
                end
            end
        end
        
        -- ลด score ถ้าใกล้ Unit ที่วางแล้ว
        for _, placedPos in pairs(State.PlacedPositions) do
            local distToPlaced = (pos - placedPos).Magnitude
            if distToPlaced < 5 then
                score = score - 200
            elseif distToPlaced < 10 then
                score = score - 50
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
        end
    end
    
    if bestPos then
        local timeInRange = CalculateTimeInRange(bestPos, unitRange)
        local pathsHit = CountPathsHit(bestPos, unitRange)
        DebugPrint(string.format("⚔️ Damage Position: Score=%.0f, TimeInRange=%.1fs, PathsHit=%d", 
            bestScore, timeInRange, pathsHit))
    end
    
    return bestPos
end

--[[
================================================================================
                    📍 PLACEMENT LOGIC - Buff Unit
================================================================================
หน้าที่: บัพ Unit อื่น
Priority: ต่ำสุด (อันดับ 3)

การวาง Buff Unit:
- วางหลังสุด
- ต้องอยู่ในระยะบัพที่ครอบคลุม Economy Unit, Damage Unit, และ Unit สำคัญทั้งหมด

Logic: เลือกตำแหน่งที่ Buff Coverage สูงสุด
]]

local function GetActiveUnits()
    local units = {}
    
    -- ใช้ ClientUnitHandler
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == plr then
                table.insert(units, {
                    Model = unitData.Model,
                    Name = unitData.Name or guid,
                    Position = unitData.Model and unitData.Model:FindFirstChild("HumanoidRootPart") 
                        and unitData.Model.HumanoidRootPart.Position,
                    GUID = guid,
                    Data = unitData,
                })
            end
        end
        if #units > 0 then return units end
    end
    
    -- Fallback: workspace.Units
    if workspace:FindFirstChild("Units") then
        for _, unit in pairs(workspace.Units:GetChildren()) do
            if unit:IsA("Model") and unit:FindFirstChild("HumanoidRootPart") then
                local owner = unit:GetAttribute("Owner") or unit:GetAttribute("Player")
                if owner == plr.Name or owner == plr.UserId then
                    table.insert(units, {
                        Model = unit,
                        Name = unit.Name,
                        Position = unit.HumanoidRootPart.Position,
                        GUID = unit.Name,
                        Data = {
                            CurrentUpgrade = unit:GetAttribute("CurrentUpgrade") or unit:GetAttribute("Level"),
                            IsIncome = unit:GetAttribute("IsIncome"),
                        },
                    })
                end
            end
        end
    end
    
    return units
end

local function GetBestBuffPosition(buffRange)
    buffRange = buffRange or 20
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    local activeUnits = GetActiveUnits()
    if #activeUnits == 0 then return nil end
    
    local bestPos = nil
    local bestCoverage = 0
    
    for _, pos in pairs(positions) do
        local coverage = 0
        
        -- นับ Unit ที่อยู่ในระยะบัพ
        for _, unit in pairs(activeUnits) do
            if unit.Position then
                local dist = (pos - unit.Position).Magnitude
                if dist <= buffRange then
                    coverage = coverage + 1
                end
            end
        end
        
        -- เลือกตำแหน่งที่ Buff Coverage สูงสุด
        if coverage > bestCoverage then
            bestCoverage = coverage
            bestPos = pos
        end
    end
    
    if bestPos then
        DebugPrint(string.format("🛡️ Buff Position: Coverage = %d units", bestCoverage))
    end
    
    return bestPos
end

--[[
================================================================================
                        📍 ENEMY MODE (กันบ้านแตก / บอส)
================================================================================
หลักการ: ไม่ใช่โหมดดักไกล แต่เป็นโหมด "ตีทันที"

Enemy Mode Placement Logic:
- ตรวจสอบ Enemy Base (จุดเกิดศัตรู)
- วาง Damage Unit 1–2 ตัว
- วางใกล้ Enemy ที่กำลังจะออก
- ไม่วางไกลเกินไป

เป้าหมาย:
- ยิงโดนมอน
- ยิงบอสทันที
- ลดเวลาที่ enemy เดินโดยไม่โดนโจมตี
]]

local function GetEnemyBasePosition()
    local path = GetMapPath()
    if #path == 0 then return nil end
    
    -- Enemy Base = จุดแรกของ path (จุดเกิด enemy)
    return path[1]
end

local function GetEnemyModePosition()
    local enemyBase = GetEnemyBasePosition()
    if not enemyBase then return nil end
    
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    local bestPos = nil
    local bestDist = math.huge
    
    for _, pos in pairs(positions) do
        local dist = (pos - enemyBase).Magnitude
        -- ต้องใกล้ Enemy Base แต่ไม่ติดจนเกินไป (5-30 studs)
        if dist >= 5 and dist <= 30 and dist < bestDist then
            bestDist = dist
            bestPos = pos
        end
    end
    
    if bestPos then
        DebugPrint(string.format("🎯 Enemy Mode Position: ห่าง Enemy Base %.1f studs", bestDist))
    end
    
    return bestPos
end

--[[
================================================================================
                        🔄 UPGRADE LOGIC
================================================================================
กรณี: มี Economy Unit ในทีม
- ลำดับปกติ: วาง Economy Unit ให้ครบ → อัพเกรด Economy Unit เป็นหลัก

ระบบตรวจสอบฉุกเฉิน (Emergency Check):
- คำนวณ Enemy Progress จาก path ทั้งหมด
- if enemyProgress >= 60%:
    - หยุดอัพเกรด Economy ชั่วคราว
    - วาง Damage Unit เพิ่ม หรืออัพ Damage Unit 1 ขั้น
- หลังจากสถานการณ์ดีขึ้น: กลับไปอัพ Economy Unit ต่อ

กรณี: ไม่มี Economy Unit ในทีม
- วาง Damage Unit
- อัพเกรด Damage Unit ที่แรงที่สุดเสมอ

นิยามคำว่า "แรงที่สุด":
DamageScore = DPS * TimeInRange
เลือก Unit ที่ DamageScore สูงสุด
]]

local function GetEnemies()
    local enemies = {}
    
    -- วิธี 1: workspace.Entities
    if workspace:FindFirstChild("Entities") then
        for _, entity in pairs(workspace.Entities:GetChildren()) do
            if entity:IsA("Model") then
                local hrp = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
                if hrp then
                    local humanoid = entity:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        table.insert(enemies, {
                            Model = entity,
                            Name = entity.Name,
                            Position = hrp.Position,
                            Health = humanoid.Health,
                            MaxHealth = humanoid.MaxHealth,
                        })
                    end
                end
            end
        end
    end
    
    return enemies
end

-- คำนวณ Enemy Progress (% path ที่ enemy เดินไปแล้ว)
local function CalculateEnemyProgress()
    local enemies = GetEnemies()
    local path = GetMapPath()
    if #enemies == 0 or #path == 0 then return 0 end
    
    local maxProgress = 0
    local pathLength = 0
    
    -- คำนวณความยาว path ทั้งหมด
    for i = 1, #path - 1 do
        pathLength = pathLength + (path[i+1] - path[i]).Magnitude
    end
    
    if pathLength == 0 then return 0 end
    
    for _, enemy in pairs(enemies) do
        -- หาว่า enemy อยู่ตรงไหนของ path
        local closestDist = math.huge
        local closestIndex = 1
        
        for i, node in ipairs(path) do
            local dist = (enemy.Position - node).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestIndex = i
            end
        end
        
        -- คำนวณ progress เป็น %
        local distanceTraveled = 0
        for i = 1, closestIndex - 1 do
            distanceTraveled = distanceTraveled + (path[i+1] - path[i]).Magnitude
        end
        
        local progress = (distanceTraveled / pathLength) * 100
        if progress > maxProgress then
            maxProgress = progress
        end
    end
    
    State.EnemyProgressMax = maxProgress
    return maxProgress
end

local function IsEmergency()
    local progress = CalculateEnemyProgress()
    State.IsEmergency = progress >= Settings.EmergencyThreshold
    
    if State.IsEmergency then
        DebugPrint(string.format("⚠️ EMERGENCY! Enemy Progress: %.1f%%", progress))
    end
    
    return State.IsEmergency
end

-- หา Unit ที่ควรอัพเกรด
local function GetBestUnitToUpgrade()
    local activeUnits = GetActiveUnits()
    if #activeUnits == 0 then return nil, nil end
    
    local hasEconomyUnit = HasEconomyUnit()
    local bestEconomyUnit = nil
    local bestEconomyLevel = math.huge
    
    local bestDamageUnit = nil
    local bestDamageScore = 0
    
    for _, unit in pairs(activeUnits) do
        local isIncome = unit.Data and unit.Data.IsIncome
        local currentLevel = unit.Data and unit.Data.CurrentUpgrade or 0
        
        -- ข้าม unit ที่ถึง max level แล้ว
        if currentLevel >= Settings.MaxUpgradeLevel then
            continue
        end
        
        if isIncome then
            -- Economy Unit: เลือกที่ level ต่ำสุด (อัพทีละ 1 ขั้น)
            if currentLevel < bestEconomyLevel then
                bestEconomyLevel = currentLevel
                bestEconomyUnit = unit
            end
        else
            -- Damage Unit: คำนวณ DamageScore = DPS * TimeInRange
            local unitRange = 25
            if unit.Data and unit.Data.Range then
                unitRange = unit.Data.Range
            end
            
            local timeInRange = 0
            if unit.Position then
                timeInRange = CalculateTimeInRange(unit.Position, unitRange)
            end
            
            local dps = 100  -- สมมติ DPS พื้นฐาน
            if unit.Data and unit.Data.DPS then
                dps = unit.Data.DPS
            end
            
            -- DamageScore = DPS * TimeInRange
            local damageScore = dps * timeInRange
            if damageScore > bestDamageScore then
                bestDamageScore = damageScore
                bestDamageUnit = unit
            end
        end
    end
    
    -- ===== ตัดสินใจว่าจะอัพ Unit ไหน =====
    -- ถ้ามี Economy Unit ในทีม และไม่ใช่ Emergency → อัพ Economy
    if hasEconomyUnit and not IsEmergency() then
        if bestEconomyUnit then
            return bestEconomyUnit, "Economy"
        end
    end
    
    -- ไม่งั้น → อัพ Damage ที่แรงที่สุด (DamageScore สูงสุด)
    if bestDamageUnit then
        return bestDamageUnit, "Damage"
    end
    
    return nil, nil
end

--[[
================================================================================
                        💸 SELL LOGIC
================================================================================
- ขายเฉพาะ Economy Unit เท่านั้น
- ขายเมื่อถึง Max Wave ของด่าน
- ถ้าบางตัวขายไม่ได้ → ข้าม

Logic:
if currentWave == maxWave:
    sell all sellable Economy Units
]]

local function SellAllEconomyUnits()
    if State.EconomySold then return false end
    
    local activeUnits = GetActiveUnits()
    local soldCount = 0
    
    for _, unit in pairs(activeUnits) do
        local isIncome = unit.Data and unit.Data.IsIncome
        if isIncome and unit.GUID then
            DebugPrint("💰 ขาย Economy Unit:", unit.Name, unit.GUID)
            
            local success = pcall(function()
                UnitEvent:FireServer("Sell", unit.GUID)
            end)
            
            if success then
                soldCount = soldCount + 1
                task.wait(0.3)  -- รอระหว่างการขาย
            end
            -- ถ้าขายไม่ได้ → ข้าม (ไม่ retry)
        end
    end
    
    if soldCount > 0 then
        State.EconomySold = true
        DebugPrint("💰 ขาย Economy Unit ทั้งหมด:", soldCount, "ตัว")
        RecordAction("sell")
        return true
    end
    
    return false
end

--[[
================================================================================
                        🎮 UNIT ACTIONS
================================================================================
Hard Rule: ทำได้แค่ 1 action ต่อรอบ
]]

local function PlaceUnit(slot, position)
    if not position then return false end
    if not CanDoAction() then return false end
    
    local hotbar = GetHotbarUnits()
    local unit = hotbar[slot]
    if not unit then return false end
    
    -- ===== Anti-Spam: เช็คเงินก่อนวาง =====
    if not CanAfford(unit.Price) then
        return false
    end
    
    -- ส่งคำสั่งวาง
    local success = pcall(function()
        UnitEvent:FireServer("Render", {
            unit.Name,
            unit.ID,
            position,
            0  -- rotation
        })
    end)
    
    if success then
        table.insert(State.PlacedPositions, position)
        State.SlotPlaceCount[slot] = (State.SlotPlaceCount[slot] or 0) + 1
        RecordAction("place")
        DebugPrint("📍 วาง Unit:", unit.Name, "ที่ slot", slot)
        return true
    end
    
    return false
end

local function UpgradeUnit(unit)
    if not unit or not unit.GUID then return false end
    if not CanDoAction() then return false end
    
    -- TODO: เช็คราคา upgrade ก่อนอัพ (ถ้ามีข้อมูล)
    
    local success = pcall(function()
        UnitEvent:FireServer("Upgrade", unit.GUID)
    end)
    
    if success then
        RecordAction("upgrade")
        DebugPrint("⬆️ อัพเกรด:", unit.Name)
        return true
    end
    
    return false
end

--[[
================================================================================
                        🔄 MAIN DECISION LOGIC
================================================================================
ลำดับการทำงานหลัก (Main Loop):
ทุก ๆ Tick / Interval:
1. ตรวจสอบ Yen (เงิน) ก่อนทุกการกระทำ
2. ประเมินสถานการณ์จาก:
   - Wave ปัจจุบัน
   - Enemy Progress (% path ที่ enemy เดินไปแล้ว)
3. ตัดสินใจ Action:
   - วาง (Place)
   - อัพเกรด (Upgrade)
   - ขาย (Sell)
4. แยก Logic ตามประเภท Unit
5. หลังทำ Action 1 อย่าง → Wait → Recheck

Hard Rule:
- ทำได้แค่ 1 action ต่อรอบ
- ห้าม spam วาง / spam อัพเกรด
]]

local function DecideAction()
    -- ===== STEP 1: ตรวจสอบ Yen ก่อนทุกการกระทำ =====
    local yen = GetYen()
    
    -- ===== STEP 2: ประเมินสถานการณ์ =====
    UpdateWaveTracking()
    UpdateUnitClassification()
    local isEmergency = IsEmergency()
    
    DebugPrint(string.format("📊 Wave: %d/%d | Yen: %d | Emergency: %s", 
        State.CurrentWave, State.MaxWave, yen, tostring(isEmergency)))
    
    -- ===== STEP 3: เช็คว่าถึง Max Wave หรือยัง → ขาย Economy =====
    if IsMaxWave() and not State.EconomySold then
        DebugPrint("🏁 ถึง Max Wave แล้ว - ขาย Economy Units")
        if SellAllEconomyUnits() then
            return "sell_economy"
        end
    end
    
    -- ===== STEP 4: ตัดสินใจ Place vs Upgrade =====
    local hotbar = GetHotbarUnits()
    
    -- หา slot ที่วางได้ตาม Priority
    local economySlots = {}
    local damageSlots = {}
    local buffSlots = {}
    
    for _, slot in ipairs(Settings.PlacePriority) do
        local unit = hotbar[slot]
        if unit and unit.CanPlace and CanPlaceSlot(slot) and CanAfford(unit.Price) then
            if IsEconomySlot(slot) then
                table.insert(economySlots, slot)
            elseif IsBuffSlot(slot) then
                table.insert(buffSlots, slot)
            else
                table.insert(damageSlots, slot)
            end
        end
    end
    
    -- ===== Priority 1: วาง Economy Unit ก่อน (ถ้าไม่ Emergency) =====
    if #economySlots > 0 and not isEmergency then
        local slot = economySlots[1]
        local pos = GetBestEconomyPosition()
        if pos then
            if PlaceUnit(slot, pos) then
                return "place_economy"
            end
        end
    end
    
    -- ===== Priority 2: วาง Damage Unit =====
    if #damageSlots > 0 then
        local slot = damageSlots[1]
        local unit = hotbar[slot]
        local pos
        
        -- ถ้า Emergency หรือ Max Wave → ใช้ Enemy Mode
        if isEmergency or IsMaxWave() then
            pos = GetEnemyModePosition()
        else
            pos = GetBestDamagePosition(unit.Range)
        end
        
        if pos then
            if PlaceUnit(slot, pos) then
                return "place_damage"
            end
        end
    end
    
    -- ===== Priority 3: วาง Buff Unit (วางหลังสุด) =====
    if #buffSlots > 0 then
        local slot = buffSlots[1]
        local pos = GetBestBuffPosition()
        if pos then
            if PlaceUnit(slot, pos) then
                return "place_buff"
            end
        end
    end
    
    -- ===== ถ้าไม่มี slot วาง → พิจารณา Upgrade =====
    if Settings.AutoUpgrade then
        local unitToUpgrade, upgradeType = GetBestUnitToUpgrade()
        if unitToUpgrade then
            if UpgradeUnit(unitToUpgrade) then
                return "upgrade_" .. (upgradeType or "unknown")
            end
        end
    end
    
    return "wait"
end

--[[
================================================================================
                        🎬 AUTO START / VOTE SKIP SYSTEM
================================================================================
- Auto Start: เริ่มเกมอัตโนมัติ
- Vote Skip: กด Skip Wave อัตโนมัติ
]]

-- ตรวจสอบว่าอยู่ใน match หรือยัง
local function IsInMatch()
    -- เช็คจาก HUD
    local HUD = PlayerGui:FindFirstChild("HUD")
    if HUD and HUD.Enabled then
        return true
    end
    
    -- เช็คจาก Wave
    if State.CurrentWave > 0 or State.MaxWave > 0 then
        return true
    end
    
    return false
end

-- ตรวจสอบว่ามี Skip Button หรือไม่
local function FindSkipButton()
    local skipButton = nil
    
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            -- หา Skip / Vote Skip button
            for _, child in pairs(HUD:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("ImageButton") then
                    local name = child.Name:lower()
                    local text = ""
                    if child:IsA("TextButton") then
                        text = (child.Text or ""):lower()
                    end
                    
                    if name:find("skip") or name:find("vote") or text:find("skip") or text:find("vote") then
                        if child.Visible then
                            skipButton = child
                            break
                        end
                    end
                end
            end
        end
    end)
    
    return skipButton
end

-- ตรวจสอบว่ามี Start Button หรือไม่
local function FindStartButton()
    local startButton = nil
    
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            for _, child in pairs(HUD:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("ImageButton") then
                    local name = child.Name:lower()
                    local text = ""
                    if child:IsA("TextButton") then
                        text = (child.Text or ""):lower()
                    end
                    
                    if name:find("start") or name:find("ready") or name:find("begin") or
                       text:find("start") or text:find("ready") or text:find("begin") then
                        if child.Visible then
                            startButton = child
                            break
                        end
                    end
                end
            end
        end
    end)
    
    return startButton
end

-- กด Vote Skip
local function DoVoteSkip()
    if not Settings.AutoVoteSkip then return false end
    if not IsInMatch() then return false end
    
    -- เช็ค cooldown
    if tick() - State.LastVoteSkipTime < Settings.VoteSkipCooldown then
        return false
    end
    
    -- วิธี 1: ใช้ SkipWaveEvent แบบเดียวกับเกม
    if SkipWaveEvent then
        local success, err = pcall(function()
            SkipWaveEvent:FireServer("Skip")  -- ต้องส่ง "Skip" เป็น argument
        end)
        if success then
            State.LastVoteSkipTime = tick()
            DebugPrint("⏩ Vote Skip (Event)")
            return true
        else
            warn("❌ SkipWaveEvent Error:", err)
        end
    end
    
    -- วิธี 2: กดปุ่ม Skip
    local skipButton = FindSkipButton()
    if skipButton then
        pcall(function()
            -- Fire click events
            if skipButton.Activated then
                skipButton.Activated:Fire()
            end
            if skipButton.MouseButton1Click then
                skipButton.MouseButton1Click:Fire()
            end
        end)
        State.LastVoteSkipTime = tick()
        DebugPrint("⏩ Vote Skip (Button)")
        return true
    end
    
    return false
end

-- กด Start
local function DoAutoStart()
    if not Settings.AutoStart then return false end
    if State.MatchStarted then return false end
    
    -- วิธี 1: ใช้ GameEvent
    if GameEvent then
        pcall(function()
            GameEvent:FireServer("Ready")
            GameEvent:FireServer("Start")
        end)
        DebugPrint("🎬 Auto Start (Event)")
    end
    
    -- วิธี 2: กดปุ่ม Start
    local startButton = FindStartButton()
    if startButton then
        pcall(function()
            if startButton.Activated then
                startButton.Activated:Fire()
            end
            if startButton.MouseButton1Click then
                startButton.MouseButton1Click:Fire()
            end
        end)
        DebugPrint("🎬 Auto Start (Button)")
    end
    
    return true
end

-- Auto Start / Vote Skip Loop
local AutoStartConnection = nil

local function StartAutoStartLoop()
    if AutoStartConnection then
        AutoStartConnection:Disconnect()
    end
    
    AutoStartConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Enabled then return end
        
        -- Auto Start
        if Settings.AutoStart and not State.MatchStarted then
            if IsInMatch() then
                State.MatchStarted = true
            else
                DoAutoStart()
            end
        end
        
        -- Vote Skip (ทำทุก wave)
        if Settings.AutoVoteSkip and IsInMatch() then
            DoVoteSkip()
        end
    end)
end

local function StopAutoStartLoop()
    if AutoStartConnection then
        AutoStartConnection:Disconnect()
        AutoStartConnection = nil
    end
end

--[[
================================================================================
                           🔄 MAIN LOOP
================================================================================
]]

local MainLoopConnection = nil
local LastDecisionTime = 0

local function StartMainLoop()
    if MainLoopConnection then
        MainLoopConnection:Disconnect()
    end
    
    DebugPrint("🚀 เริ่ม AutoPlay v2 Main Loop")
    DebugPrint("📋 Settings:", 
        "ActionCooldown =", Settings.ActionCooldown,
        "EmergencyThreshold =", Settings.EmergencyThreshold .. "%")
    
    MainLoopConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Enabled then return end
        
        -- รอ cooldown ระหว่าง action (Hard Rule)
        if not CanDoAction() then return end
        
        -- Throttle decision making
        if tick() - LastDecisionTime < Settings.MainLoopInterval then return end
        LastDecisionTime = tick()
        
        -- ตัดสินใจ action
        local action = DecideAction()
        
        if action ~= "wait" then
            DebugPrint("✅ Completed Action:", action)
        end
    end)
end

local function StopMainLoop()
    if MainLoopConnection then
        MainLoopConnection:Disconnect()
        MainLoopConnection = nil
        DebugPrint("🛑 หยุด AutoPlay v2 Main Loop")
    end
end

-- Reset state when map changes
local function ResetState()
    State.CurrentWave = 0
    State.MaxWave = 0
    State.PlacedPositions = {}
    State.SlotPlaceCount = {}
    State.EconomySold = false
    State.IsEmergency = false
    State.EnemyProgressMax = 0
    State.CachedPath = nil
    State.CachedCorners = nil
    State.LastVoteSkipTime = 0
    State.MatchStarted = false
    
    UnitClassification = {Economy = {}, Damage = {}, Buff = {}}
    
    DebugPrint("🔄 Reset State")
end

--[[
================================================================================
                           📋 PUBLIC API
================================================================================
]]

local AutoPlayV2 = {
    Settings = Settings,
    State = State,
    
    -- Control
    Start = function()
        StartMainLoop()
        StartAutoStartLoop()
    end,
    Stop = function()
        StopMainLoop()
        StopAutoStartLoop()
    end,
    Reset = ResetState,
    
    -- Manual getters
    GetYen = GetYen,
    GetWave = function() return State.CurrentWave, State.MaxWave end,
    GetEnemyProgress = CalculateEnemyProgress,
    IsEmergency = IsEmergency,
    IsMaxWave = IsMaxWave,
    
    -- Classification
    ClassifyUnit = ClassifyUnit,
    UpdateClassification = UpdateUnitClassification,
    HasEconomyUnit = HasEconomyUnit,
    
    -- Auto Start / Vote Skip
    DoVoteSkip = DoVoteSkip,
    DoAutoStart = DoAutoStart,
    
    -- Placement helpers
    GetBestEconomyPosition = GetBestEconomyPosition,
    GetBestDamagePosition = GetBestDamagePosition,
    GetBestBuffPosition = GetBestBuffPosition,
    GetEnemyModePosition = GetEnemyModePosition,
    
    -- Path analysis
    GetMapPath = GetMapPath,
    GetPathCorners = GetPathCorners,
    CalculateTimeInRange = CalculateTimeInRange,
    CountPathsHit = CountPathsHit,
    
    -- Debug
    Debug = function(enabled)
        Settings.Debug = enabled
    end,
    
    -- Version
    Version = "2.1",
}

-- Auto Start ทั้ง 2 loops
if Settings.Enabled then
    task.delay(2, function()
        DebugPrint("🎬 Starting AutoPlay v2...")
        DebugPrint("📋 Auto Start:", Settings.AutoStart and "ON" or "OFF")
        DebugPrint("📋 Auto Vote Skip:", Settings.AutoVoteSkip and "ON" or "OFF")
        
        StartMainLoop()
        StartAutoStartLoop()
    end)
end

-- Export
getgenv().AutoPlayV2 = AutoPlayV2

DebugPrint("📦 AutoPlay v2 Loaded - Version", AutoPlayV2.Version)

return AutoPlayV2
