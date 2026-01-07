--[[
    AutoPlay_Smart.lua
    ระบบ Auto Play อัจฉริยะ v2.0
    
    โครงสร้างหลัก:
    1. ตรวจสอบ Yen (เงิน) ก่อนทุกการกระทำ
    2. ตัดสินใจว่า วาง / อัพเกรด / ขาย
    3. แยก Logic ตามประเภท Unit (Economy / Damage / Buff)
    4. ประเมินสถานการณ์จาก Wave + Enemy Progress
]]

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ===== AUTO CONFIGURATION (Hard-coded) =====
local ENABLED = true
local DEBUG = true
local ACTION_COOLDOWN = 0.5        -- วินาทีระหว่าง Action
local UNIT_SPACING = 4             -- ระยะห่างระหว่าง Unit
local PATH_MARGIN = 10             -- ระยะห่างจาก Path (Income)
-- MAX_UPGRADE_LEVEL ถูกลบออก - ใช้ GetMaxUpgradeLevel(unit) หาจาก Unit Data อัตโนมัติ
local VOTE_SKIP_COOLDOWN = 2       -- Cooldown Vote Skip
local AUTO_START_INTERVAL = 3      -- เช็ค Auto Start ทุกกี่วินาที
local EMERGENCY_SELL_DELAY = 3     -- ขาย Emergency Units หลังเคลียร์ (วินาที)
local EMERGENCY_DELAY = 2          -- รอกี่วินาทีก่อนเริ่ม Emergency Mode
local MAX_EMERGENCY_UNITS = 2      -- วางได้สูงสุด 1-2 ตัวใน Emergency Mode

-- ===== UNIT CLASSIFICATION =====
-- ประเภทของ Unit (Economy / Damage / Buff)
local UnitType = {
    ECONOMY = "Economy",    -- ตัวเงิน (Income)
    DAMAGE = "Damage",      -- ตัวดาเมจ
    BUFF = "Buff",          -- ตัวบัพ
    UNKNOWN = "Unknown"
}

-- ===== LOAD MODULES =====
local UnitsHUD, ClientUnitHandler, UnitPlacementHandler, PlacementValidationHandler
local EnemyPathHandler, PathMathHandler, ClientGameStateHandler, PlayerYenHandler
local ClientEnemyHandler

local function LoadModules()
    pcall(function() UnitsHUD = require(StarterPlayer.Modules.Interface.Loader.HUD.Units) end)
    pcall(function() ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler) end)
    pcall(function() UnitPlacementHandler = require(StarterPlayer.Modules.Gameplay.Units.UnitPlacementHandler) end)
    pcall(function() PlacementValidationHandler = require(ReplicatedStorage.Modules.Gameplay.PlacementValidationHandler) end)
    pcall(function() EnemyPathHandler = require(ReplicatedStorage.Modules.Shared.EnemyPathHandler) end)
    pcall(function() PathMathHandler = require(ReplicatedStorage.Modules.Shared.PathMathHandler) end)
    pcall(function() ClientGameStateHandler = require(ReplicatedStorage.Modules.Gameplay.ClientGameStateHandler) end)
    pcall(function() PlayerYenHandler = require(StarterPlayer.Modules.Gameplay.PlayerYenHandler) end)
    pcall(function() ClientEnemyHandler = require(StarterPlayer.Modules.Gameplay.Enemies.ClientEnemyHandler) end)
end

LoadModules()

-- ===== NETWORKING =====
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitEvent = Networking:WaitForChild("UnitEvent")
local AbilityEvent = Networking:WaitForChild("AbilityEvent")

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

-- ===== STATE VARIABLES =====
local CurrentYen = 0
local CurrentWave = 0
local MaxWave = 0
local IsEmergency = false
local LastActionTime = 0

-- Match State
local MatchStarted = false
local MatchEnded = false
local SkipWaveActive = false
local LastVoteSkipTime = 0

-- Unit Tracking
local PlacedUnits = {}           -- {GUID = UnitData}
local PlacedEconomyUnits = {}    -- {GUID = UnitData}
local PlacedDamageUnits = {}     -- {GUID = UnitData}
local PlacedBuffUnits = {}       -- {GUID = UnitData}
local PlacedPositions = {}       -- {Position}

-- Emergency Tracking
local EmergencyUnits = {}        -- {GUID = true} - Units ที่วางตอน Emergency
local LastEmergencyTime = 0      -- Track เวลาที่ Emergency เริ่ม
local EmergencyStartTime = 0     -- เวลาที่ Enemy ถึง 60% ครั้งแรก
local EmergencyActivated = false -- ว่าได้วาง Emergency units แล้วหรือยัง

-- Slot Tracking
local SlotPlaceCount = {}        -- {[slot] = count}
local SlotLimits = {}            -- {[slot] = {limit, current}}
local IncomeSlots = {}           -- {[slot] = true/false}
local BuffSlots = {}             -- {[slot] = true/false}

-- Placement Queue (เพื่อวางให้ครบทุกตัว)
local PlacementQueue = {}        -- {slot, unitType, priority}
local AllSlotsPlaced = {}        -- {[slot] = true} ถ้าวางครบ limit แล้ว

-- ===== UTILITY FUNCTIONS =====
local function DebugPrint(...)
    if DEBUG then
        print("[AutoPlay Smart]", ...)
    end
end

local function WaitForCooldown()
    local now = tick()
    if now - LastActionTime < ACTION_COOLDOWN then
        task.wait(ACTION_COOLDOWN - (now - LastActionTime))
    end
    LastActionTime = tick()
end

-- ===== SECTION 1: YEN SYSTEM (Anti-Spam Protection) =====
-- เช็คเงินก่อนทุก Action เพื่อป้องกัน spam

local function GetYen()
    -- วิธีที่ 1: ใช้ ClientGameStateHandler
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
    
    -- วิธีที่ 2: ใช้ PlayerYenHandler
    if PlayerYenHandler and PlayerYenHandler.GetYen then
        local yen = PlayerYenHandler.GetYen()
        if yen then
            CurrentYen = yen
            return yen
        end
    end
    
    -- วิธีที่ 3: หาจาก HUD
    local HUD = PlayerGui:FindFirstChild("HUD")
    if HUD then
        local YenFrame = HUD:FindFirstChild("Yen") or HUD:FindFirstChild("Hotbar")
        if YenFrame then
            for _, child in pairs(YenFrame:GetDescendants()) do
                if child:IsA("TextLabel") then
                    local text = child.Text
                    if text and type(text) == "string" then
                        local numStr = text:gsub(",", ""):match("(%d+)")
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

local function CanAfford(cost)
    local yen = GetYen()
    return yen >= cost
end

local function InitYenTracking()
    if PlayerYenHandler and PlayerYenHandler.OnYenChanged then
        pcall(function()
            PlayerYenHandler.OnYenChanged:Connect(function(newYen)
                CurrentYen = newYen
                DebugPrint("💰 Yen updated:", CurrentYen)
            end)
        end)
    end
    
    -- Initial yen
    GetYen()
    DebugPrint("💰 Initial Yen:", CurrentYen)
end

-- ===== SECTION 2: WAVE SYSTEM =====
-- อ่าน Wave จาก UI

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
                    local cleanText = text:gsub("<[^>]+>", "") -- Strip rich text tags
                    
                    local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                    if cur and total then
                        currentWave = tonumber(cur) or 0
                        totalWaves = tonumber(total) or 0
                    end
                end
            end
        end
    end)
    
    if currentWave > 0 then CurrentWave = currentWave end
    if totalWaves > 0 then MaxWave = totalWaves end
    
    return currentWave, totalWaves
end

local function IsMaxWave()
    GetWaveFromUI()
    return MaxWave > 0 and CurrentWave >= MaxWave
end

-- ===== SECTION 3: PATH SYSTEM =====
-- หา Path และคำนวณ Coverage

local PathCache = nil
local PathCacheTime = 0

local function GetMapPath()
    -- Use cache if fresh
    if PathCache and (tick() - PathCacheTime) < 5 then
        return PathCache
    end
    
    local path = {}
    
    -- วิธีที่ 1: EnemyPathHandler
    if EnemyPathHandler and EnemyPathHandler.Nodes then
        for _, node in pairs(EnemyPathHandler.Nodes) do
            if node.Position then
                table.insert(path, {
                    Position = node.Position,
                    Index = node.Index or 0,
                    DistanceToEnd = node.DistanceToEnd or 0
                })
            end
        end
        if #path > 0 then
            table.sort(path, function(a, b) return a.Index < b.Index end)
        end
    end
    
    -- วิธีที่ 2: workspace.Path
    if #path == 0 then
        local pathFolders = {
            workspace:FindFirstChild("Path"),
            workspace:FindFirstChild("Paths"),
            workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Path"),
        }
        
        for _, folder in pairs(pathFolders) do
            if folder then
                local nodes = {}
                for _, child in pairs(folder:GetChildren()) do
                    if child:IsA("BasePart") then
                        table.insert(nodes, {
                            Position = child.Position,
                            Index = tonumber(child.Name) or 0
                        })
                    end
                end
                table.sort(nodes, function(a, b) return a.Index < b.Index end)
                path = nodes
                break
            end
        end
    end
    
    PathCache = path
    PathCacheTime = tick()
    return path
end

-- หา EnemyBase (จุดเริ่มต้นของ enemy - ตรงข้าม Player)
local function GetEnemyBase()
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local Bases = Map:FindFirstChild("Bases")
        if Bases then
            local enemyBase = Bases:FindFirstChild("EnemyBase")
            if enemyBase then
                if enemyBase:IsA("BasePart") then
                    return enemyBase.Position
                elseif enemyBase:IsA("Model") then
                    local primary = enemyBase.PrimaryPart or enemyBase:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        return primary.Position
                    end
                end
            end
        end
    end
    
    -- Fallback: ใช้จุดแรกของ path (Enemy spawn point)
    local path = GetMapPath()
    if #path > 0 then
        return path[1].Position
    end
    
    return nil
end

-- หา PlayerBase (ฐานของผู้เล่นที่ต้องป้องกัน - จุดสุดท้ายของ path)
local function GetPlayerBase()
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local Bases = Map:FindFirstChild("Bases")
        if Bases then
            local playerBase = Bases:FindFirstChild("PlayerBase") or Bases:FindFirstChild("Base")
            if playerBase then
                if playerBase:IsA("BasePart") then
                    return playerBase.Position
                elseif playerBase:IsA("Model") then
                    local primary = playerBase.PrimaryPart or playerBase:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        return primary.Position
                    end
                end
            end
        end
    end
    
    -- Fallback: ใช้จุดสุดท้ายของ path (Player Base = จุดที่ Enemy พยายามจะเข้า)
    local path = GetMapPath()
    if #path > 0 then
        return path[#path].Position
    end
    
    return nil
end

-- คำนวณระยะ Path ที่สั้นที่สุดจากตำแหน่ง
local function GetDistanceToPath(position)
    local path = GetMapPath()
    local minDist = math.huge
    
    for _, node in ipairs(path) do
        local dist = (position - node.Position).Magnitude
        if dist < minDist then
            minDist = dist
        end
    end
    
    return minDist
end

-- ===== SECTION 4: ENEMY PROGRESS =====
-- วิเคราะห์ว่า Enemy เดินไปถึงไหนแล้ว (เป็น %)

local function GetEnemies()
    local enemies = {}
    
    -- วิธีที่ 1: ใช้ ClientEnemyHandler._ActiveEnemies (จาก source code ของเกม)
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
                if enemy and enemy.Position then
                    table.insert(enemies, {
                        Model = enemy.Model,
                        Position = enemy.Position,
                        Name = enemy.Name or "Enemy",
                        UniqueIdentifier = enemy.UniqueIdentifier or id,
                        CurrentNode = enemy.CurrentNode,
                        Alpha = enemy.Alpha,
                        Data = enemy.Data
                    })
                end
            end
            
            if #enemies > 0 then
                return enemies
            end
        end
    end
    
    -- วิธีที่ 2: หาจาก workspace.Entities (ที่เกมวาง enemy)
    if workspace:FindFirstChild("Entities") then
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
    end
    
    return enemies
end

-- หา enemy ที่อยู่หน้าสุด (ไปไกลที่สุดใน path)
local function GetLeadingEnemy()
    local enemies = GetEnemies()
    local path = GetMapPath()
    
    if #enemies == 0 or #path == 0 then
        return nil, 0
    end
    
    local leadingEnemy = nil
    local maxProgress = 0
    local leadingPathIndex = 1
    
    for _, enemy in pairs(enemies) do
        local closestIndex = 1
        local closestDist = math.huge
        
        for i, node in ipairs(path) do
            local dist = (enemy.Position - node.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestIndex = i
            end
        end
        
        local progress = (closestIndex / #path) * 100
        if progress > maxProgress then
            maxProgress = progress
            leadingEnemy = enemy
            leadingPathIndex = closestIndex
        end
    end
    
    return leadingEnemy, leadingPathIndex, maxProgress
end

-- หาตำแหน่งข้างหน้า enemy (สำหรับ Emergency Placement)
local function GetPositionAheadOfEnemy(pathIndex, stepsAhead)
    local path = GetMapPath()
    stepsAhead = stepsAhead or 3
    
    local targetIndex = math.min(pathIndex + stepsAhead, #path)
    if path[targetIndex] then
        return path[targetIndex].Position
    end
    
    return nil
end

local function GetEnemyProgress()
    local enemies = GetEnemies()
    local path = GetMapPath()
    
    if #enemies == 0 then
        return 0
    end
    
    local maxProgress = 0
    
    -- หา enemy ที่ไปได้ไกลที่สุด
    for _, enemy in pairs(enemies) do
        local progress = 0
        
        -- วิธีที่ 1: ใช้ CurrentNode.DistanceToStart จาก enemy data ของเกม
        if enemy.CurrentNode and enemy.CurrentNode.DistanceToStart then
            -- DistanceToStart คือระยะที่เดินมาแล้ว + Alpha
            local distWalked = (enemy.CurrentNode.DistanceToStart or 0) + (enemy.Alpha or 0)
            -- หา total distance จาก path
            local totalDist = 0
            if #path > 0 and path[#path].DistanceToStart then
                totalDist = path[#path].DistanceToStart
            else
                -- คำนวณเอง
                for i = 2, #path do
                    totalDist = totalDist + (path[i].Position - path[i-1].Position).Magnitude
                end
            end
            if totalDist > 0 then
                progress = (distWalked / totalDist) * 100
            end
        else
            -- วิธีที่ 2: หา path node ที่ใกล้ enemy ที่สุด
            if #path > 0 then
                local closestIndex = 1
                local closestDist = math.huge
                
                for i, node in ipairs(path) do
                    local nodePos = node.Position or node
                    if typeof(nodePos) == "Vector3" then
                        local dist = (enemy.Position - nodePos).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestIndex = i
                        end
                    end
                end
                
                progress = (closestIndex / #path) * 100
            end
        end
        
        if progress > maxProgress then
            maxProgress = progress
        end
    end
    
    return maxProgress
end

local function CheckEmergency()
    local enemies = GetEnemies()
    local progress = GetEnemyProgress()
    
    -- Emergency = enemy progress >= 60%
    local wasEmergency = IsEmergency
    IsEmergency = progress >= 60
    
    -- ถ้าเพิ่งเข้า Emergency Mode ครั้งแรก
    if IsEmergency and not wasEmergency then
        EmergencyStartTime = tick()
        EmergencyActivated = false
        DebugPrint("🚨 EMERGENCY MODE TRIGGERED! เริ่มนับถอยหลัง", EMERGENCY_DELAY, "วินาที...")
    end
    
    -- ถ้าออกจาก Emergency
    if not IsEmergency and wasEmergency then
        DebugPrint("✅ Emergency Mode สิ้นสุด")
        EmergencyStartTime = 0
        EmergencyActivated = false
    end
    
    if IsEmergency then
        DebugPrint("🚨 EMERGENCY! Enemy Progress:", math.floor(progress), "%")
    end
    
    return IsEmergency
end

-- ===== SECTION 5: UNIT CLASSIFICATION =====
-- แยกประเภท Unit (Economy / Damage / Buff)

local function ClassifyUnit(unitData)
    if not unitData then return UnitType.UNKNOWN end
    
    -- ===== ECONOMY UNIT (ตัวเงิน) =====
    -- เช็คหลายวิธี
    
    -- 1. Field โดยตรง
    if unitData.Income or unitData.PassiveIncome or unitData.IncomePerWave then
        return UnitType.ECONOMY
    end
    
    -- 2. เช็คจาก Abilities
    if unitData.Abilities then
        for name, ability in pairs(unitData.Abilities) do
            if type(name) == "string" then
                local nameLower = name:lower()
                if nameLower:find("income") or nameLower:find("money") or nameLower:find("farm") then
                    return UnitType.ECONOMY
                end
            end
            if type(ability) == "table" then
                if ability.Type and tostring(ability.Type):lower():find("income") then
                    return UnitType.ECONOMY
                end
                if ability.Income then
                    return UnitType.ECONOMY
                end
            end
        end
    end
    
    -- 3. เช็คจาก Tags
    if unitData.Tags then
        for _, tag in pairs(unitData.Tags) do
            local tagLower = tostring(tag):lower()
            if tagLower:find("income") or tagLower:find("farm") or tagLower:find("money") then
                return UnitType.ECONOMY
            end
        end
    end
    
    -- 4. เช็คจาก UnitType/Category
    if unitData.UnitType then
        local typeLower = tostring(unitData.UnitType):lower()
        if typeLower:find("income") or typeLower:find("farm") then
            return UnitType.ECONOMY
        end
    end
    
    -- ===== BUFF UNIT (ตัวบัพ) =====
    
    -- 1. เช็คจาก Abilities
    if unitData.Abilities then
        for name, ability in pairs(unitData.Abilities) do
            if type(name) == "string" then
                local nameLower = name:lower()
                if nameLower:find("buff") or nameLower:find("aura") or nameLower:find("boost") or
                   nameLower:find("support") or nameLower:find("enhance") then
                    return UnitType.BUFF
                end
            end
            if type(ability) == "table" and ability.Type then
                local typeLower = tostring(ability.Type):lower()
                if typeLower:find("buff") or typeLower:find("aura") or typeLower:find("support") then
                    return UnitType.BUFF
                end
            end
        end
    end
    
    -- 2. เช็คจาก UnitType
    if unitData.UnitType then
        local typeLower = tostring(unitData.UnitType):lower()
        if typeLower:find("support") or typeLower:find("buff") then
            return UnitType.BUFF
        end
    end
    
    -- 3. เช็คว่าไม่มี Damage = น่าจะเป็น Support
    if unitData.Damage == nil or unitData.Damage == 0 then
        if unitData.Range and unitData.Range > 0 then
            -- มี Range แต่ไม่มี Damage = Support
            return UnitType.BUFF
        end
    end
    
    -- ===== DEFAULT = DAMAGE UNIT =====
    return UnitType.DAMAGE
end

-- ===== SECTION 6: HOTBAR & PLACEMENT =====

local function GetHotbarUnits()
    local units = {}
    
    if UnitsHUD and UnitsHUD._Cache then
        for slot, v in pairs(UnitsHUD._Cache) do
            if v ~= "None" and v ~= nil then
                local unitData = v.Data or v
                local price = unitData.Cost or unitData.Price or v.Cost or 0
                local unitType = ClassifyUnit(unitData)
                
                -- หา Range จาก unit data โดยตรง
                local range = unitData.Range 
                    or unitData.AttackRange 
                    or (unitData.Stats and unitData.Stats.Range)
                    or (unitData.BaseStats and unitData.BaseStats.Range)
                
                units[slot] = {
                    Slot = slot,
                    Name = unitData.Name or v.Name or "Unknown",
                    ID = unitData.ID or unitData.Identifier or slot,
                    Price = price,
                    Range = range,  -- เก็บ Range จาก unit (nil ถ้าไม่มี)
                    Data = unitData,
                    Type = unitType,
                    IsIncome = (unitType == UnitType.ECONOMY),
                    IsBuff = (unitType == UnitType.BUFF),
                    IsDamage = (unitType == UnitType.DAMAGE),
                }
            end
        end
    end
    
    return units
end

local function GetSlotLimit(slot)
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return 99, 0 end
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then return 99, 0 end
    
    local Units = Main:FindFirstChild("Units")
    if not Units then return 99, 0 end
    
    local slotFrame = Units:FindFirstChild(tostring(slot))
    if not slotFrame then return 99, 0 end
    
    -- หา x/y format จาก TextLabel ที่ชื่อ Amount หรือ Count หรือ Limit
    local foundLimit = nil
    local foundCurrent = nil
    
    -- ===== วิธี 1: หาจาก child ที่มีชื่อเกี่ยวกับ Amount/Count/Limit =====
    local priorityNames = {"Amount", "Count", "Limit", "Placed", "Units", "Quantity"}
    for _, priorityName in ipairs(priorityNames) do
        local child = slotFrame:FindFirstChild(priorityName, true)
        if child and child:IsA("TextLabel") then
            local text = child.Text
            if text then
                local cleanText = text:gsub("<[^>]+>", ""):gsub("%s+", "")
                local current, max = cleanText:match("(%d+)/(%d+)")
                if current and max then
                    foundCurrent = tonumber(current)
                    foundLimit = tonumber(max)
                    if foundLimit and foundLimit > 0 and foundLimit <= 50 then
                        SlotLimits[slot] = {limit = foundLimit, current = foundCurrent}
                        return foundLimit, foundCurrent
                    end
                end
            end
        end
    end
    
    -- ===== วิธี 2: หา TextLabel ที่มี text เป็น x/y แบบเจาะจง =====
    local candidates = {}
    for _, child in pairs(slotFrame:GetDescendants()) do
        if child:IsA("TextLabel") then
            local text = child.Text
            if text then
                local cleanText = text:gsub("<[^>]+>", ""):gsub("%s+", "")
                local current, max = cleanText:match("^(%d+)/(%d+)$")
                if current and max then
                    local parsedCurrent = tonumber(current)
                    local parsedMax = tonumber(max)
                    
                    -- เก็บทุกตัวที่หาเจอ พร้อม priority
                    if parsedMax and parsedMax > 0 and parsedMax <= 50 then
                        local priority = 0
                        local name = child.Name:lower()
                        
                        -- ให้ priority สูงกับชื่อที่เกี่ยวข้อง
                        if name:find("amount") or name:find("count") or name:find("limit") or name:find("placed") then
                            priority = 100
                        elseif name:find("unit") then
                            priority = 50
                        end
                        
                        -- Priority ต่ำกับตัวที่ดูเหมือน level หรือ wave
                        if name:find("level") or name:find("lv") or name:find("wave") then
                            priority = -100
                        end
                        
                        table.insert(candidates, {
                            current = parsedCurrent,
                            limit = parsedMax,
                            name = child.Name,
                            priority = priority
                        })
                    end
                end
            end
        end
    end
    
    -- เลือกตัวที่ priority สูงสุด
    if #candidates > 0 then
        table.sort(candidates, function(a, b) return a.priority > b.priority end)
        local best = candidates[1]
        foundLimit = best.limit
        foundCurrent = best.current
        SlotLimits[slot] = {limit = foundLimit, current = foundCurrent}
        return foundLimit, foundCurrent
    end
    
    -- ===== วิธี 3: ใช้ SlotPlaceCount ที่เราติดตามเอง =====
    local trackedCount = SlotPlaceCount[slot] or 0
    return 99, trackedCount
end

-- อัพเดท Slot Limits ทั้งหมด
local function UpdateAllSlotLimits()
    local hotbar = GetHotbarUnits()
    for slot, _ in pairs(hotbar) do
        local limit, current = GetSlotLimit(slot)
        SlotLimits[slot] = {limit = limit, current = current}
        
        -- เช็คว่าวางครบ limit หรือยัง
        if current >= limit then
            AllSlotsPlaced[slot] = true
        else
            AllSlotsPlaced[slot] = false
        end
    end
end

-- เช็คว่ายังมี slot ที่ยังวางได้อยู่หรือไม่
local function HasAvailableSlots()
    local hotbar = GetHotbarUnits()
    for slot, unit in pairs(hotbar) do
        if CanPlaceSlot(slot) and CanAfford(unit.Price) then
            return true
        end
    end
    return false
end

-- หา slot ถัดไปที่ยังวางได้ (ตาม priority)
local function GetNextPlaceableSlot(unitTypeFilter)
    local hotbar = GetHotbarUnits()
    UpdateAllSlotLimits()
    
    -- สร้าง list ของ slots ที่ยังวางได้
    local availableSlots = {}
    
    for slot, unit in pairs(hotbar) do
        -- กรองตาม unitType ถ้าระบุ
        local typeMatch = true
        if unitTypeFilter then
            typeMatch = (unit.Type == unitTypeFilter)
        end
        
        if typeMatch and not AllSlotsPlaced[slot] then
            local limit, current = GetSlotLimit(slot)
            local remaining = limit - current
            
            if remaining > 0 and CanAfford(unit.Price) then
                table.insert(availableSlots, {
                    slot = slot,
                    unit = unit,
                    remaining = remaining,
                    limit = limit,
                    current = current,
                    price = unit.Price
                })
            end
        end
    end
    
    -- Sort โดย: ตัวที่ยังวางได้น้อยกว่า = วางก่อน (เพื่อให้วางครบทุกตัว)
    table.sort(availableSlots, function(a, b)
        -- Priority 1: วางตัวที่เหลือน้อยก่อน (เพื่อให้ครบ limit)
        if a.remaining ~= b.remaining then
            return a.remaining < b.remaining
        end
        -- Priority 2: ถ้าเหลือเท่ากัน ให้วางตัวถูกกว่า
        return a.price < b.price
    end)
    
    if #availableSlots > 0 then
        return availableSlots[1].slot, availableSlots[1].unit, availableSlots[1].remaining
    end
    
    return nil, nil, 0
end

-- หา Economy Slot ที่ยังวางได้
local function GetNextEconomySlot()
    return GetNextPlaceableSlot(UnitType.ECONOMY)
end

-- หา Damage Slot ที่ยังวางได้
local function GetNextDamageSlot()
    return GetNextPlaceableSlot(UnitType.DAMAGE)
end

-- หา Buff Slot ที่ยังวางได้
local function GetNextBuffSlot()
    return GetNextPlaceableSlot(UnitType.BUFF)
end

-- เช็คว่าวาง Economy ครบ limit ทุก slot หรือยัง
local function AllEconomySlotsFull()
    local hotbar = GetHotbarUnits()
    for slot, unit in pairs(hotbar) do
        if unit.IsIncome then
            if not AllSlotsPlaced[slot] then
                local limit, current = GetSlotLimit(slot)
                if current < limit then
                    return false
                end
            end
        end
    end
    return true
end

-- เช็คว่าวาง Damage ครบ limit ทุก slot หรือยัง
local function AllDamageSlotsFull()
    local hotbar = GetHotbarUnits()
    for slot, unit in pairs(hotbar) do
        if unit.IsDamage then
            if not AllSlotsPlaced[slot] then
                local limit, current = GetSlotLimit(slot)
                if current < limit then
                    return false
                end
            end
        end
    end
    return true
end

-- เช็คว่าวาง Buff ครบ limit ทุก slot หรือยัง
local function AllBuffSlotsFull()
    local hotbar = GetHotbarUnits()
    for slot, unit in pairs(hotbar) do
        if unit.IsBuff then
            if not AllSlotsPlaced[slot] then
                local limit, current = GetSlotLimit(slot)
                if current < limit then
                    return false
                end
            end
        end
    end
    return true
end

-- สรุปสถานะ slot ทั้งหมด
local function GetSlotsSummary()
    local hotbar = GetHotbarUnits()
    local summary = {
        economy = {total = 0, placed = 0, limit = 0},
        damage = {total = 0, placed = 0, limit = 0},
        buff = {total = 0, placed = 0, limit = 0}
    }
    
    for slot, unit in pairs(hotbar) do
        local limit, current = GetSlotLimit(slot)
        
        if unit.IsIncome then
            summary.economy.total = summary.economy.total + 1
            summary.economy.placed = summary.economy.placed + current
            summary.economy.limit = summary.economy.limit + limit
        elseif unit.IsBuff then
            summary.buff.total = summary.buff.total + 1
            summary.buff.placed = summary.buff.placed + current
            summary.buff.limit = summary.buff.limit + limit
        else
            summary.damage.total = summary.damage.total + 1
            summary.damage.placed = summary.damage.placed + current
            summary.damage.limit = summary.damage.limit + limit
        end
    end
    
    return summary
end

local function CanPlaceSlot(slot)
    local limit, current = GetSlotLimit(slot)
    return current < limit
end

-- ===== SECTION 7: PLACEMENT POSITIONS =====

-- ตรวจสอบว่าตำแหน่งถูกใช้แล้วหรือยัง (เช็คจาก Unit จริงๆ)
local function IsPositionOccupied(position, minDistance)
    minDistance = minDistance or UNIT_SPACING
    
    -- เช็คจาก PlacedPositions ที่เราติดตามไว้
    for _, placedPos in pairs(PlacedPositions) do
        if (placedPos - position).Magnitude < minDistance then
            return true
        end
    end
    
    -- เช็คจาก ClientUnitHandler (Unit จริงในเกม)
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for _, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Model then
                local hrp = unitData.Model:FindFirstChild("HumanoidRootPart") or unitData.Model.PrimaryPart
                if hrp then
                    if (hrp.Position - position).Magnitude < minDistance then
                        return true
                    end
                end
            end
        end
    end
    
    return false
end

local function GetPlaceablePositions()
    local positions = {}
    local spacing = UNIT_SPACING
    
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
                            
                            -- เช็คว่าถูกใช้แล้วหรือยัง (เช็คจาก Unit จริง)
                            if not IsPositionOccupied(worldPos, spacing) then
                                table.insert(positions, worldPos)
                            end
                        end
                    end
                end
            end
        else
            DebugPrint("⚠️ ไม่พบ PlacementAreas ใน Map")
        end
    else
        DebugPrint("⚠️ ไม่พบ Map ใน workspace")
    end
    
    -- ===== FALLBACK: หาจาก CollectionService =====
    if #positions == 0 then
        DebugPrint("🔍 ลองหาจาก CollectionService...")
        pcall(function()
            local tagged = CollectionService:GetTagged("PlacementArea")
            for _, area in pairs(tagged) do
                if area:IsA("BasePart") then
                    local size = area.Size
                    local cf = area.CFrame
                    local edgeMargin = math.max(spacing, 2)
                    
                    for x = -size.X/2 + edgeMargin, size.X/2 - edgeMargin, spacing do
                        for z = -size.Z/2 + edgeMargin, size.Z/2 - edgeMargin, spacing do
                            local localPos = Vector3.new(x, 0.5, z)
                            local worldPos = cf:PointToWorldSpace(localPos)
                            table.insert(positions, worldPos)
                        end
                    end
                end
            end
        end)
    end
    
    -- ===== FALLBACK 2: ใช้ UnitPlacementHandler ของเกม =====
    if #positions == 0 and UnitPlacementHandler then
        DebugPrint("🔍 ลองใช้ UnitPlacementHandler...")
        pcall(function()
            if UnitPlacementHandler.GetValidPositions then
                local validPos = UnitPlacementHandler:GetValidPositions()
                if validPos then
                    for _, pos in pairs(validPos) do
                        table.insert(positions, pos)
                    end
                end
            end
        end)
    end
    
    -- ===== FALLBACK 3: หาจาก PathMathHandler (ตำแหน่งใกล้ path) =====
    if #positions == 0 and PathMathHandler then
        DebugPrint("🔍 ลองใช้ PathMathHandler...")
        pcall(function()
            if PathMathHandler.GetClosestPathPointInRange then
                -- หา path point หลายจุด
                local testPositions = {
                    Vector3.new(0, 5, 0),
                    Vector3.new(50, 5, 50),
                    Vector3.new(-50, 5, 50),
                    Vector3.new(50, 5, -50),
                    Vector3.new(-50, 5, -50),
                }
                
                for _, testPos in ipairs(testPositions) do
                    local closestPoint = PathMathHandler:GetClosestPathPointInRange(testPos, 10000)
                    if closestPoint then
                        -- สร้างตำแหน่งรอบๆ path
                        local offsets = {
                            Vector3.new(8, 0, 0),
                            Vector3.new(-8, 0, 0),
                            Vector3.new(0, 0, 8),
                            Vector3.new(0, 0, -8),
                            Vector3.new(12, 0, 0),
                            Vector3.new(-12, 0, 0),
                            Vector3.new(0, 0, 12),
                            Vector3.new(0, 0, -12),
                        }
                        for _, offset in ipairs(offsets) do
                            local newPos = closestPoint + offset
                            table.insert(positions, newPos)
                        end
                    end
                end
            end
        end)
    end
    
    DebugPrint("📍 พบ Placeable Positions:", #positions)
    return positions
end

-- ===== PLACEMENT VALIDATION =====
local function CanPlaceAtPosition(unitName, position)
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
    return true -- ถ้าไม่มี validation handler ให้ลองวางเลย
end

local function GetValidPlacementPosition(unitName, preferredPosition)
    if not preferredPosition then return nil end
    
    -- ลองตำแหน่งที่ต้องการก่อน
    if CanPlaceAtPosition(unitName, preferredPosition) then
        return preferredPosition
    end
    
    -- ถ้าวางไม่ได้ ลองหาตำแหน่งใกล้ๆ
    local offsets = {
        Vector3.new(4, 0, 0),
        Vector3.new(-4, 0, 0),
        Vector3.new(0, 0, 4),
        Vector3.new(0, 0, -4),
        Vector3.new(4, 0, 4),
        Vector3.new(-4, 0, 4),
        Vector3.new(4, 0, -4),
        Vector3.new(-4, 0, -4),
    }
    
    for _, offset in ipairs(offsets) do
        local testPos = preferredPosition + offset
        if CanPlaceAtPosition(unitName, testPos) then
            return testPos
        end
    end
    
    return nil
end

-- ===== PLACEMENT LOGIC ตาม UNIT TYPE =====

-- 3.1 วางตัวเงิน: หา position ที่ไกล path มากที่สุด
local function GetEconomyPosition()
    local positions = GetPlaceablePositions()
    if #positions == 0 then 
        DebugPrint("❌ ไม่พบ Placeable Positions!")
        return nil 
    end
    
    local bestPos = nil
    local bestScore = -math.huge
    local maxDistFromPath = 30  -- จำกัดระยะไม่ให้ไกลเกินไป
    local minDistFromPath = 8   -- ระยะขั้นต่ำจาก path
    
    for _, pos in pairs(positions) do
        local distToPath = GetDistanceToPath(pos)
        
        -- Economy ควรอยู่ห่างจาก path พอประมาณ (8-30 studs)
        if distToPath >= minDistFromPath and distToPath <= maxDistFromPath then
            local score = distToPath  -- ยิ่งไกล (ในขอบเขต) ยิ่งดี
            
            if score > bestScore then
                bestScore = score
                bestPos = pos
            end
        end
    end
    
    -- ถ้าไม่เจอในขอบเขต ให้หาตัวที่ใกล้ที่สุดที่ยังอยู่ในระยะ
    if not bestPos then
        local minDist = math.huge
        for _, pos in pairs(positions) do
            local distToPath = GetDistanceToPath(pos)
            if distToPath >= minDistFromPath and distToPath < minDist then
                minDist = distToPath
                bestPos = pos
            end
        end
    end
    
    -- Fallback: หาตำแหน่งใดก็ได้ที่ว่าง
    if not bestPos and #positions > 0 then
        bestPos = positions[1]
    end
    
    if bestPos then
        local dist = GetDistanceToPath(bestPos)
        DebugPrint("💰 Economy Position: ห่าง path", math.floor(dist), "studs")
    end
    
    return bestPos
end

-- 3.2 วางตัวดาเมจ: เน้นมุมโค้ง + ใกล้ EnemyBase + ยิงได้หลายทิศทาง
local function GetDamagePosition(unitRange)
    local positions = GetPlaceablePositions()
    if #positions == 0 then 
        DebugPrint("❌ ไม่พบ PlaceablePositions!")
        return nil 
    end
    
    unitRange = unitRange or 25
    local path = GetMapPath()
    
    if #path == 0 then
        DebugPrint("❌ ไม่พบ Path!")
        return positions[1]
    end
    
    DebugPrint(string.format("⚔️ หา Normal Damage Position | Range: %.1f", unitRange))
    
    -- ===== หามุมโค้งของ path (2D detection - XZ plane) =====
    local corners = {}
    
    for i = 2, #path - 1 do
        local prev = path[i-1].Position
        local curr = path[i].Position
        local next = path[i+1].Position
        
        local dir1 = (curr - prev).Unit
        local dir2 = (next - curr).Unit
        
        -- คำนวณมุม
        local dotProduct = dir1:Dot(dir2)
        local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
        
        -- ถ้ามีมุมโค้ง (>= 20 degrees)
        if angle >= 20 then
            -- Cross product แบบ 2D (XZ plane) เพื่อหาทิศทาง
            local cross = dir1.X * dir2.Z - dir1.Z * dir2.X
            
            table.insert(corners, {
                Position = curr,
                Angle = angle,
                PathIndex = i,
                IsLeftTurn = cross > 0,
                IsRightTurn = cross < 0
            })
        end
    end
    
    DebugPrint(string.format("📍 พบมุมโค้ง: %d มุม", #corners))
    
    local bestPos = nil
    local bestScore = -math.huge
    
    -- ===== ประเมินแต่ละตำแหน่ง (Scoring: Paths + Time + Corners) =====
    for _, pos in pairs(positions) do
        local distToPath = GetDistanceToPath(pos)
        
        -- เช็คว่าอยู่ในระยะยิง
        if distToPath <= unitRange then
            -- ===== 1. นับ Path Nodes ที่ยิงได้ (PathsHit) =====
            local pathsHit = 0
            for _, node in ipairs(path) do
                if (pos - node.Position).Magnitude <= unitRange then
                    pathsHit = pathsHit + 1
                end
            end
            
            -- ===== 2. คำนวณ TimeInRange =====
            local enemySpeed = 10
            local timeInRange = (pathsHit * 3) / enemySpeed
            
            -- Hard Stop ที่ 0.5s (ยืดหยุ่น)
            if timeInRange >= 0.5 then
                -- ===== 3. Corner Bonus (Left Turn = Inside Corner ดีกว่า) =====
                local cornerBonus = 0
                local nearCornerCount = 0
                
                for _, corner in ipairs(corners) do
                    local distToCorner = (pos - corner.Position).Magnitude
                    if distToCorner <= unitRange then
                        nearCornerCount = nearCornerCount + 1
                        if corner.IsLeftTurn then
                            cornerBonus = cornerBonus + 200  -- Left Turn (Inside)
                        else
                            cornerBonus = cornerBonus + 100  -- Right Turn (Outside)
                        end
                    end
                end
                
                -- ===== คำนวณ PlacementScore (ไม่มี Base Penalty) =====
                local score = (pathsHit * 200) + (timeInRange * 100) + cornerBonus
                
                if nearCornerCount > 0 then
                    DebugPrint(string.format("📊 Score: %.0f | Paths: %d | Time: %.1fs | Corners: %d", 
                        score, pathsHit, timeInRange, nearCornerCount))
                end
                
                if score > bestScore then
                    bestScore = score
                    bestPos = pos
                end
            end
        end
    end
    
    if bestPos then
        DebugPrint(string.format("✅ Normal Damage Position | Score: %.0f", bestScore))
    else
        DebugPrint("⚠️ ไม่พบตำแหน่ง Damage ที่ผ่าน Hard Stop (0.5s)")
        bestPos = positions[1]  -- fallback
    end
    
    return bestPos
end

-- 3.2.1 WAVE-BASED PLACEMENT SYSTEM - ระบบวางแบบอัตโนมัติตาม Wave/MaxWave
-- ใช EnemyBase (จุดเกิดของ enemy) แทน PlayerBase เพื่อวางยูนิตตามกลยุทธ์

local function GetWaveBasedDamagePosition(unitRange)
    unitRange = unitRange or 25
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    local path = GetMapPath()
    if #path == 0 then
        return #positions > 0 and positions[1] or nil
    end
    
    -- อ่านข้อมูล Wave ปัจจุบัน
    GetWaveFromUI()
    local currentWave = CurrentWave
    local maxWave = MaxWave
    
    DebugPrint(string.format("=== WAVE-BASED PLACEMENT | Wave: %d/%d ===", currentWave, maxWave))
    DebugPrint(string.format("[WAVE] Range: %.1f | Total Positions: %d", unitRange, #positions))
    
    -- หา EnemyBase (จุดเกิดของ enemy = จุดแรกของ path)
    local enemyBase = GetEnemyBase()
    if not enemyBase then
        DebugPrint("[WAVE] EnemyBase not found, using first path node")
        enemyBase = path[1].Position
    else
        DebugPrint(string.format("[WAVE] EnemyBase: %.1f, %.1f, %.1f", enemyBase.X, enemyBase.Y, enemyBase.Z))
    end
    
    -- คำนวณ Wave Progress (0.0 - 1.0)
    local waveProgress = 0.5 -- Default: middle strategy
    if maxWave > 0 and currentWave > 0 then
        waveProgress = currentWave / maxWave
    end
    
    DebugPrint(string.format("[WAVE] Progress: %.1f%% (%d/%d)", waveProgress * 100, currentWave, maxWave))
    
    -- ===== PHASE 1: Early Waves (0-40%) - โจมตีที่ EnemyBase (Front-load) =====
    -- วาง unit ใกล้จุดเกิด enemy เพื่อฆ่าตั้งแต่ต้นทาง
    local frontPathPercent = 0.4  -- 40% แรกของ path
    
    -- ===== PHASE 2: Mid Waves (40-70%) - กระจายตาม Path (Mid Coverage) =====
    local midPathStart = 0.2
    local midPathEnd = 0.8
    
    -- ===== PHASE 3: Late Waves (70-100%) - ป้องกันท้าย + PlayerBase (Defense) =====
    local latePathPercent = 0.7  -- 70% ท้ายของ path
    
    -- เลือกกลยุทธ์ตาม Wave Progress
    local targetNodes = {}
    local strategyName = ""
    
    if waveProgress <= 0.4 then
        -- Early Phase: โฟกัส Front (EnemyBase + 40% แรก)
        strategyName = "FRONT LOAD (Early)"
        local endIndex = math.max(1, math.floor(#path * frontPathPercent))
        for i = 1, endIndex do
            table.insert(targetNodes, {
                Position = path[i].Position,
                PathIndex = i,
                DistFromBase = (path[i].Position - enemyBase).Magnitude,
                Priority = 3 - (i / endIndex)  -- ยิ่งใกล้ EnemyBase priority สูง
            })
        end
        
    elseif waveProgress <= 0.7 then
        -- Mid Phase: กระจาย Coverage (20-80%)
        strategyName = "MID COVERAGE"
        local startIndex = math.max(1, math.floor(#path * midPathStart))
        local endIndex = math.min(#path, math.floor(#path * midPathEnd))
        for i = startIndex, endIndex do
            table.insert(targetNodes, {
                Position = path[i].Position,
                PathIndex = i,
                DistFromBase = (path[i].Position - enemyBase).Magnitude,
                Priority = 2  -- ความสำคัญปานกลาง
            })
        end
        
    else
        -- Late Phase: ป้องกันท้าย (70% ท้าย + PlayerBase)
        strategyName = "DEFENSE MODE (Late)"
        local playerBase = GetPlayerBase()
        local startIndex = math.max(1, math.floor(#path * latePathPercent))
        for i = startIndex, #path do
            local distFromPlayer = playerBase and (path[i].Position - playerBase).Magnitude or 0
            table.insert(targetNodes, {
                Position = path[i].Position,
                PathIndex = i,
                DistFromBase = distFromPlayer,  -- ใช้ระยะห่างจาก PlayerBase ในโหมดนี้
                Priority = 3 + (#path - i) / #path  -- ยิ่งใกล้ PlayerBase priority สูง
            })
        end
    end
    
    DebugPrint(string.format("[WAVE] Strategy: %s | Target Nodes: %d", strategyName, #targetNodes))
    
    -- เรียงตาม Priority
    table.sort(targetNodes, function(a, b) return a.Priority > b.Priority end)
    
    local bestPos = nil
    local bestScore = -math.huge
    local bestDistToBase = math.huge
    
    -- ===== ประเมินตำแหน่ง =====
    for _, pos in pairs(positions) do
        local distToPath = GetDistanceToPath(pos)
        if distToPath <= unitRange then
            local distToEnemyBase = (pos - enemyBase).Magnitude
            
            -- นับ Target Nodes ที่ยิงได้
            local nodesHit = 0
            local prioritySum = 0
            for _, node in ipairs(targetNodes) do
                if (pos - node.Position).Magnitude <= unitRange then
                    nodesHit = nodesHit + 1
                    prioritySum = prioritySum + node.Priority
                end
            end
            
            -- ===== คำนวณ Score (แตกต่างตาม Phase) =====
            local score = 0
            
            if waveProgress <= 0.4 then
                -- Early: เน้นใกล้ EnemyBase + Nodes Hit
                local baseBonus = math.max(0, 3000 - (distToEnemyBase * 15))  -- ยิ่งใกล้ EnemyBase ยิ่งดี
                local nodesBonus = nodesHit * 600
                local priorityBonus = prioritySum * 100
                score = baseBonus + nodesBonus + priorityBonus
                
            elseif waveProgress <= 0.7 then
                -- Mid: เน้น Coverage + Balanced
                local coverageBonus = nodesHit * 500
                local balanceBonus = prioritySum * 150
                local pathProximity = math.max(0, 1000 - (distToPath * 30))  -- ใกล้ path พอดี
                score = coverageBonus + balanceBonus + pathProximity
                
            else
                -- Late: เน้นป้องกันท้าย + PlayerBase
                local playerBase = GetPlayerBase()
                local distToPlayer = playerBase and (pos - playerBase).Magnitude or 0
                local defenseBonus = math.max(0, 3500 - (distToPlayer * 20))  -- ยิ่งใกล้ PlayerBase ยิ่งดี
                local lateNodesBonus = nodesHit * 700
                local latePathPenalty = distToPath * 15  -- ต้องไม่ไกล path มาก
                score = defenseBonus + lateNodesBonus - latePathPenalty
            end
            
            DebugPrint(string.format("  [Score] Pos[%.1f,%.1f] Dist=%.1f Nodes=%d Priority=%.1f Score=%.0f", 
                pos.X, pos.Z, distToEnemyBase, nodesHit, prioritySum, score))
            
            if score > bestScore then
                bestScore = score
                bestPos = pos
                bestDistToBase = distToEnemyBase
            end
        end
    end
    
    if bestPos then
        DebugPrint(string.format("[WAVE BEST] %s | Dist=%.1f | Score=%.0f | Pos: %.1f,%.1f,%.1f", 
            strategyName, bestDistToBase, bestScore, bestPos.X, bestPos.Y, bestPos.Z))
    else
        -- Fallback: ใช้ Normal Damage Position
        DebugPrint("[WAVE] No optimal position, using fallback")
        bestPos = positions[1]
    end
    
    return bestPos
end
local function GetBuffPosition(buffRange)
    local positions = GetPlaceablePositions()
    if #positions == 0 then return nil end
    
    buffRange = buffRange or 20
    local bestPos = nil
    local bestScore = -math.huge
    
    -- รวบรวม Unit ทั้งหมดที่วางแล้ว
    local allUnits = {}
    for _, unit in pairs(PlacedEconomyUnits) do table.insert(allUnits, unit) end
    for _, unit in pairs(PlacedDamageUnits) do table.insert(allUnits, unit) end
    
    if #allUnits == 0 then
        -- ถ้ายังไม่มี Unit ให้วางใกล้ path แทน
        return GetDamagePosition(buffRange)
    end
    
    for _, pos in pairs(positions) do
        local score = 0
        
        -- นับ Unit ที่อยู่ในระยะบัพ
        for _, unit in pairs(allUnits) do
            if unit.Position then
                local dist = (pos - unit.Position).Magnitude
                if dist <= buffRange then
                    score = score + 100
                    -- Bonus ถ้าบัพโดนตัวเงิน
                    if unit.Type == UnitType.ECONOMY then
                        score = score + 50
                    end
                end
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
        end
    end
    
    if bestPos then
        DebugPrint("🛡️ Buff Position: Score", bestScore)
    end
    
    return bestPos
end

-- ===== SECTION 8: ACTIVE UNITS =====

-- เช็คว่า Unit ขายได้หรือไม่
local function CheckIfSellable(unitData)
    if not unitData then return true end
    
    local data = unitData.Data or unitData
    
    -- เช็คจาก field โดยตรง
    if data.CanSell == false then return false end
    if data.Sellable == false then return false end
    if data.Unsellable == true then return false end
    
    -- เช็คจาก Tags
    if data.Tags then
        for _, tag in pairs(data.Tags) do
            local tagLower = tostring(tag):lower()
            if tagLower:find("unsellable") or tagLower:find("nosell") then
                return false
            end
        end
    end
    
    -- เช็คจาก Sell field
    if data.Sell then
        local sellValue = tostring(data.Sell):lower()
        if sellValue == "unsellable" or sellValue == "false" or sellValue == "0" then
            return false
        end
    end
    
    return true
end

local function GetActiveUnits()
    local units = {}
    
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == plr then
                local pos = nil
                if unitData.Model and unitData.Model:FindFirstChild("HumanoidRootPart") then
                    pos = unitData.Model.HumanoidRootPart.Position
                end
                
                local unitType = ClassifyUnit(unitData.Data or unitData)
                local canSell = CheckIfSellable(unitData)
                
                -- หา CurrentUpgrade จากหลายที่
                local currentUpgrade = 0
                if unitData.CurrentUpgrade then
                    currentUpgrade = unitData.CurrentUpgrade
                elseif unitData.Data and unitData.Data.CurrentUpgrade then
                    currentUpgrade = unitData.Data.CurrentUpgrade
                elseif unitData.Data and unitData.Data.Data and unitData.Data.Data.CurrentUpgrade then
                    currentUpgrade = unitData.Data.Data.CurrentUpgrade
                end
                
                units[guid] = {
                    GUID = guid,
                    Model = unitData.Model,
                    Name = unitData.Name or guid,
                    Position = pos,
                    Data = unitData,
                    Type = unitType,
                    CurrentUpgrade = currentUpgrade,
                    CanUpgrade = true, -- จะเช็คภายหลัง
                    CanSell = canSell,
                }
            end
        end
    end
    
    return units
end

local function UpdatePlacedUnits()
    PlacedUnits = GetActiveUnits()
    PlacedEconomyUnits = {}
    PlacedDamageUnits = {}
    PlacedBuffUnits = {}
    
    for guid, unit in pairs(PlacedUnits) do
        if unit.Type == UnitType.ECONOMY then
            PlacedEconomyUnits[guid] = unit
        elseif unit.Type == UnitType.BUFF then
            PlacedBuffUnits[guid] = unit
        else
            PlacedDamageUnits[guid] = unit
        end
    end
    
    -- นับจำนวนจริงจาก table
    local economyCount = 0
    for _ in pairs(PlacedEconomyUnits) do economyCount = economyCount + 1 end
    
    local damageCount = 0
    for _ in pairs(PlacedDamageUnits) do damageCount = damageCount + 1 end
    
    local buffCount = 0
    for _ in pairs(PlacedBuffUnits) do buffCount = buffCount + 1 end
    
    DebugPrint(string.format("📊 Units: Economy %d | Damage %d | Buff %d", 
        economyCount, damageCount, buffCount))
end

-- ===== SECTION 9: PLACE UNIT =====

-- หาตำแหน่งวางที่ห่างจากตำแหน่งเดิมออกไป
local function FindAlternativePosition(originalPosition, unitName, attempts)
    attempts = attempts or 10
    local spacing = UNIT_SPACING
    
    -- ลองหาตำแหน่งที่ห่างออกไปเรื่อยๆ
    for attempt = 1, attempts do
        local distance = spacing * attempt
        local angles = {0, 45, 90, 135, 180, 225, 270, 315}
        
        for _, angle in ipairs(angles) do
            local rad = math.rad(angle)
            local offset = Vector3.new(math.cos(rad) * distance, 0, math.sin(rad) * distance)
            local testPos = originalPosition + offset
            
            if not IsPositionOccupied(testPos, spacing) then
                if CanPlaceAtPosition(unitName, testPos) then
                    return testPos
                end
            end
        end
    end
    
    return nil
end

local function PlaceUnit(slot, position)
    if not slot or not position then return false end
    
    local hotbar = GetHotbarUnits()
    local unit = hotbar[slot]
    if not unit then 
        DebugPrint("❌ ไม่พบ Unit ใน slot", slot)
        return false 
    end
    
    -- ===== ANTI-SPAM: เช็คเงินก่อน =====
    if not CanAfford(unit.Price) then
        DebugPrint("❌ เงินไม่พอ:", GetYen(), "<", unit.Price)
        return false
    end
    
    -- เช็ค slot limit
    if not CanPlaceSlot(slot) then
        DebugPrint("❌ Slot", slot, "ครบ limit แล้ว")
        return false
    end
    
    -- ===== FIND VALID POSITION =====
    local validPosition = nil
    
    -- ลอง 1: ใช้ตำแหน่งที่ส่งมา
    if not IsPositionOccupied(position, UNIT_SPACING) then
        validPosition = GetValidPlacementPosition(unit.Name, position)
    end
    
    -- ลอง 2: หาตำแหน่งใหม่ที่ห่างออกไป
    if not validPosition then
        DebugPrint("🔄 ตำแหน่งเดิมไม่ว่าง หาตำแหน่งใหม่...")
        validPosition = FindAlternativePosition(position, unit.Name, 15)
    end
    
    -- ลอง 3: หาจาก Placeable Positions ที่ว่างอยู่
    if not validPosition then
        DebugPrint("🔄 หาตำแหน่งจาก PlaceablePositions...")
        local positions = GetPlaceablePositions()
        for _, pos in ipairs(positions) do
            if CanPlaceAtPosition(unit.Name, pos) then
                validPosition = pos
                break
            end
        end
    end
    
    if not validPosition then
        DebugPrint("❌ ไม่พบตำแหน่งวางที่ว่าง!")
        return false
    end
    
    WaitForCooldown()
    
    -- หา Unit ID ที่ถูกต้อง
    local unitID = unit.ID or (unit.Data and unit.Data.ID) or (unit.Data and unit.Data.Identifier) or slot
    
    -- จำนวน Unit ก่อนวาง
    local unitCountBefore = 0
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, data in pairs(ClientUnitHandler._ActiveUnits) do
            if data.Player == plr then
                unitCountBefore = unitCountBefore + 1
            end
        end
    end
    
    DebugPrint("🎯 กำลังวาง", unit.Name, "| ID:", unitID, "| at", validPosition)
    
    -- Fire place event - ใช้ format "Render" ตาม AV_AutoPlay.lua
    local fireSuccess = false
    pcall(function()
        UnitEvent:FireServer("Render", {
            unit.Name,      -- ชื่อ unit
            unitID,         -- ID ของ unit
            validPosition,  -- ตำแหน่ง
            0               -- rotation
        })
        fireSuccess = true
    end)
    
    if not fireSuccess then
        DebugPrint("❌ FireServer ล้มเหลว!")
        return false
    end
    
    -- เก็บ GUID ที่มีอยู่ก่อนวาง (ไม่ต้องนับซ้ำ - ใช้ unitCountBefore ที่นับไว้แล้ว)
    local guidsBefore = {}
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, data in pairs(ClientUnitHandler._ActiveUnits) do
            if data.Player == plr then
                guidsBefore[guid] = true
            end
        end
    end
    
    -- รอสักครู่แล้วเช็คว่าวางจริงหรือไม่
    task.wait(0.3)
    
    local unitCountAfter = 0
    local newUnitGUID = nil
    
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, data in pairs(ClientUnitHandler._ActiveUnits) do
            if data.Player == plr then
                unitCountAfter = unitCountAfter + 1
                -- หา GUID ใหม่ที่ไม่อยู่ใน guidsBefore
                if not guidsBefore[guid] then
                    newUnitGUID = guid
                end
            end
        end
    end
    
    DebugPrint(string.format("🔢 Unit Count: Before=%d, After=%d, NewGUID=%s", 
        unitCountBefore, unitCountAfter, tostring(newUnitGUID)))
    
    local actuallyPlaced = unitCountAfter > unitCountBefore
    
    if actuallyPlaced then
        -- Track placement
        table.insert(PlacedPositions, validPosition)
        SlotPlaceCount[slot] = (SlotPlaceCount[slot] or 0) + 1
        DebugPrint("✅ วาง", unit.Name, "ที่ slot", slot, "สำเร็จ! (Units:", unitCountAfter, ")")
        
        -- Return GUID สำหรับ tracking
        return true, newUnitGUID
    else
        DebugPrint("⚠️ FireServer สำเร็จ แต่ Unit ไม่ถูกวาง - อาจตำแหน่งไม่ valid")
        return false, nil
    end
end

-- ===== SECTION 10: UPGRADE LOGIC =====

local function GetUpgradeCost(unit)
    if not unit then return math.huge end
    
    local data = unit.Data
    if not data then return math.huge end
    
    -- หา current level
    local currentLevel = 0
    if unit.CurrentUpgrade then
        currentLevel = unit.CurrentUpgrade
    elseif data.CurrentUpgrade then
        currentLevel = data.CurrentUpgrade
    elseif data.Data and data.Data.CurrentUpgrade then
        currentLevel = data.Data.CurrentUpgrade
    end
    
    -- หา upgrades table
    local upgrades = nil
    if data.Upgrades then
        upgrades = data.Upgrades
    elseif data.Data and data.Data.Upgrades then
        upgrades = data.Data.Upgrades
    end
    
    if upgrades then
        -- ลองหา upgrade ถัดไป
        local nextUpgrade = upgrades[currentLevel + 1]
        if nextUpgrade then
            if type(nextUpgrade) == "table" then
                return nextUpgrade.Cost or nextUpgrade.Price or math.huge
            elseif type(nextUpgrade) == "number" then
                return nextUpgrade
            end
        end
    end
    
    -- ลองหาจาก UpgradeCost field
    if data.UpgradeCost then
        if type(data.UpgradeCost) == "table" then
            return data.UpgradeCost[currentLevel + 1] or math.huge
        elseif type(data.UpgradeCost) == "number" then
            return data.UpgradeCost
        end
    end
    
    return math.huge
end

local function GetMaxUpgradeLevel(unit)
    -- ค่า Default สำหรับกรณีหาไม่ได้
    local DEFAULT_MAX_LEVEL = 15  -- ค่า Default สูงพอที่จะครอบคลุม Unit ส่วนใหญ่
    
    if not unit then return DEFAULT_MAX_LEVEL end
    
    local data = unit.Data
    if not data then return DEFAULT_MAX_LEVEL end
    
    -- หา upgrades table
    local upgrades = nil
    if data.Upgrades then
        upgrades = data.Upgrades
    elseif data.Data and data.Data.Upgrades then
        upgrades = data.Data.Upgrades
    end
    
    -- ถ้ามี Upgrades array → นับจำนวน
    if upgrades and type(upgrades) == "table" then
        local maxLevel = 0
        for level, _ in pairs(upgrades) do
            if type(level) == "number" and level > maxLevel then
                maxLevel = level
            end
        end
        if maxLevel > 0 then
            return maxLevel
        end
    end
    
    -- Fallback: ใช้ค่า Default
    return DEFAULT_MAX_LEVEL
end

local function GetStrongestUnit(units)
    local best = nil
    local bestScore = -math.huge
    
    for _, unit in pairs(units) do
        local score = 0
        local data = unit.Data and (unit.Data.Data or unit.Data) or {}
        
        -- Score based on Damage
        score = score + (data.Damage or 0) * 10
        
        -- Score based on current upgrade level
        score = score + (unit.CurrentUpgrade or 0) * 50
        
        if score > bestScore then
            bestScore = score
            best = unit
        end
    end
    
    return best
end

local function UpgradeUnit(unit)
    if not unit or not unit.GUID then return false end
    
    local cost = GetUpgradeCost(unit)
    
    -- ===== ANTI-SPAM: เช็คเงินก่อน =====
    if not CanAfford(cost) then
        DebugPrint("❌ เงินไม่พอ upgrade:", GetYen(), "<", cost)
        return false
    end
    
    -- เช็ค max level (ใช้ GetMaxUpgradeLevel แทน MAX_UPGRADE_LEVEL)
    local maxLevel = GetMaxUpgradeLevel(unit)
    if unit.CurrentUpgrade >= maxLevel then
        DebugPrint(string.format("❌ ถึง max level แล้ว (%d/%d)", unit.CurrentUpgrade, maxLevel))
        return false
    end
    
    WaitForCooldown()
    
    local success = false
    pcall(function()
        -- ใช้ format ตาม AV_AutoPlay.lua: "Upgrade", GUID
        UnitEvent:FireServer("Upgrade", unit.GUID)
        success = true
    end)
    
    if success then
        DebugPrint("⬆️ Upgrade", unit.Name)
    end
    
    return success
end

-- ===== SECTION 11: SELL LOGIC =====

local function SellUnit(unit)
    if not unit or not unit.GUID then return false end
    
    -- เช็คว่าขายได้หรือไม่
    if not unit.CanSell then
        DebugPrint("❌ Unit นี้ขายไม่ได้:", unit.Name)
        return false
    end
    
    WaitForCooldown()
    
    local success = false
    pcall(function()
        -- ใช้ format ตาม AV_AutoPlay.lua: "Sell", GUID
        UnitEvent:FireServer("Sell", unit.GUID)
        success = true
    end)
    
    if success then
        DebugPrint("💸 ขาย", unit.Name)
        
        -- ลบออกจาก Tracking
        PlacedUnits[unit.GUID] = nil
        PlacedEconomyUnits[unit.GUID] = nil
        PlacedDamageUnits[unit.GUID] = nil
        PlacedBuffUnits[unit.GUID] = nil
        EmergencyUnits[unit.GUID] = nil  -- ลบออกจาก Emergency tracking ด้วย
    end
    
    return success
end

-- ขายตัวเงินทั้งหมดเมื่อถึง Max Wave
local function SellAllEconomyUnits()
    if not IsMaxWave() then return end
    
    DebugPrint("🏁 Max Wave! กำลังขายตัวเงินทั้งหมด...")
    
    UpdatePlacedUnits()
    
    local soldCount = 0
    for _, unit in pairs(PlacedEconomyUnits) do
        if unit.CanSell then
            if SellUnit(unit) then
                soldCount = soldCount + 1
            end
        end
    end
    
    DebugPrint("💸 ขายตัวเงินแล้ว", soldCount, "ตัว")
end

-- ===== SECTION 12: MAIN DECISION LOGIC =====

local function DecideAction()
    UpdatePlacedUnits()
    UpdateAllSlotLimits()
    GetWaveFromUI()
    CheckEmergency()
    
    local hotbar = GetHotbarUnits()
    local yen = GetYen()
    local summary = GetSlotsSummary()
    
    -- Debug: แสดงสถานะ (ลด log ซ้ำ)
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    DebugPrint(string.format("💰 Yen: %d | Wave: %d/%d", yen, CurrentWave, MaxWave))
    DebugPrint(string.format("📊 Economy: %d/%d | Damage: %d/%d | Buff: %d/%d", 
        summary.economy.placed, summary.economy.limit,
        summary.damage.placed, summary.damage.limit,
        summary.buff.placed, summary.buff.limit
    ))
    
    -- ===== CHECK: ถึง Max Wave หรือยัง =====
    if IsMaxWave() then
        DebugPrint("🏁 MAX WAVE! ขายตัวเงิน + อัพเกรด Damage")
        
        -- ขายตัวเงินทั้งหมด
        SellAllEconomyUnits()
        
        -- อัพเกรด Damage ตัวที่แรงที่สุด (ไม่วางตัวใหม่)
        local strongest = GetStrongestUnit(PlacedDamageUnits)
        if strongest then
            local cost = GetUpgradeCost(strongest)
            if CanAfford(cost) then
                DebugPrint("⚔️ Max Wave - อัพเกรด:", strongest.Name)
                UpgradeUnit(strongest)
            end
        end
        return  -- ไม่ทำอะไรต่อ (ไม่วางตัวใหม่)
    end
    
    -- ===== CHECK: มีเงินพอหรือไม่ =====
    if yen <= 0 then
        DebugPrint("⏳ รอเงิน...")
        return
    end
    
    -- ===== PRIORITY 1: วางตัวเงินก่อน (จนกว่าจะครบ limit) =====
    local economyFull = AllEconomySlotsFull()
    
    if not economyFull then
        local slot, unit, remaining = GetNextEconomySlot()
        
        if slot and unit then
            if CanAfford(unit.Price) then
                DebugPrint(string.format("💰 พยายามวาง Economy: %s (slot %d, เหลือ %d)", unit.Name, slot, remaining))
                local pos = GetEconomyPosition()
                
                if pos then
                    if PlaceUnit(slot, pos) then
                        DebugPrint("✅ วาง Economy สำเร็จ!")
                        return
                    end
                else
                    DebugPrint("❌ ไม่พบตำแหน่งวาง Economy!")
                end
            else
                DebugPrint("⏳ รอเงินสำหรับ Economy:", unit.Price)
                return  -- รอเงิน ไม่ทำอะไรต่อ
            end
        end
    end
    
    -- ===== CHECK: ขาย Emergency Units หลังเคลียร์ =====
    if not IsEmergency and LastEmergencyTime > 0 and EmergencyActivated then
        local timeSinceEmergency = tick() - LastEmergencyTime
        if timeSinceEmergency > EMERGENCY_SELL_DELAY then
            -- ขาย Emergency units ทั้งหมด
            local soldCount = 0
            for guid, _ in pairs(EmergencyUnits) do
                local unit = PlacedUnits[guid]
                if unit and unit.CanSell then
                    DebugPrint("🗑️ ขาย Emergency Unit:", unit.Name)
                    SellUnit(unit)
                    soldCount = soldCount + 1
                end
            end
            if soldCount > 0 then
                DebugPrint(string.format("🗑️ ขาย Emergency Units: %d ตัว", soldCount))
            end
            LastEmergencyTime = 0
            EmergencyActivated = false
            table.clear(EmergencyUnits)
        end
    end
    
    -- ===== PRIORITY 2: อัพเกรดตัวเงินให้เต็มทุกตัว (ถ้าวางครบแล้ว) =====
    if economyFull then
        -- อัพเกรด Economy ทุกตัวที่ยังไม่เต็ม
        local allEconomyMaxed = true
        for _, unit in pairs(PlacedEconomyUnits) do
            local maxLevel = GetMaxUpgradeLevel(unit)
            if unit.CurrentUpgrade < maxLevel then
                allEconomyMaxed = false
                local cost = GetUpgradeCost(unit)
                if cost < math.huge and CanAfford(cost) then
                    DebugPrint(string.format("💰 อัพเกรด Economy: %s [%d/%d] | Cost: %d", 
                        unit.Name, unit.CurrentUpgrade, maxLevel, cost))
                    if UpgradeUnit(unit) then
                        return  -- อัพเกรดทีละตัว
                    end
                end
            end
        end
        
        if allEconomyMaxed then
            DebugPrint("✅ Economy units ทั้งหมดอัพเกรดเต็มแล้ว!")
        end
    end
    
    -- ===== PRIORITY 3: วางตัวดาเมจ (หลัง Economy อัพเกรดเต็มทุกตัว หรือ Emergency) =====
    local damageFull = AllDamageSlotsFull()
    
    -- เช็คว่า Economy ทุกตัวอัพเกรดเต็มหรือยัง
    local allEconomyMaxed = true
    local economyUpgradeStatus = {}
    
    for guid, unit in pairs(PlacedEconomyUnits) do
        local currentLevel = unit.CurrentUpgrade or 0
        local maxLevel = GetMaxUpgradeLevel(unit)
        table.insert(economyUpgradeStatus, string.format("%s: %d/%d", 
            unit.Name or "Unknown", currentLevel, maxLevel))
        
        if currentLevel < maxLevel then
            allEconomyMaxed = false
        end
    end
    
    DebugPrint(string.format("💰 Economy Upgrade Status: %s", table.concat(economyUpgradeStatus, " | ")))
    DebugPrint(string.format("✅ All Economy Maxed: %s", tostring(allEconomyMaxed)))
    
    -- Emergency Mode: วางแค่ 1-2 ตัว หลังรอ EMERGENCY_DELAY วินาที (ใช้ GetEmergencyDamagePosition)
    if IsEmergency and not EmergencyActivated then
        local timeSinceEmergency = tick() - EmergencyStartTime
        if timeSinceEmergency >= EMERGENCY_DELAY then
            -- นับจำนวน Emergency Units ที่วางแล้ว
            local emergencyCount = 0
            for _ in pairs(EmergencyUnits) do emergencyCount = emergencyCount + 1 end
            
            DebugPrint(string.format("🚨 Emergency Count: %d / %d", emergencyCount, MAX_EMERGENCY_UNITS))
            
            if emergencyCount < MAX_EMERGENCY_UNITS then
                local slot, unit, remaining = GetNextDamageSlot()
                if slot and unit and CanAfford(unit.Price) then
                    local unitRange = unit.Range or 20
                    DebugPrint(string.format("🚨 WAVE-BASED EMERGENCY! วาง Damage %d/%d: %s (Range: %.1f) [Wave: %d/%d]", 
                        emergencyCount + 1, MAX_EMERGENCY_UNITS, unit.Name, unitRange, CurrentWave, MaxWave))
                    
                    -- ใช้ Wave-Based Position (ปรับกลยุทธ์ตาม Wave ปัจจุบัน: Early=EnemyBase, Mid=Coverage, Late=PlayerBase)
                    local pos = GetWaveBasedDamagePosition(unitRange)
                    if pos then
                        DebugPrint(string.format("🚨 Wave-Based Emergency Position: %.1f, %.1f, %.1f [Wave %.0f%%]", 
                            pos.X, pos.Y, pos.Z, (CurrentWave / math.max(MaxWave, 1)) * 100))
                        local success, newGUID = PlaceUnit(slot, pos)
                        DebugPrint(string.format("🔍 PlaceUnit Result: success=%s, newGUID=%s", tostring(success), tostring(newGUID)))
                        
                        if success then
                            if newGUID then
                                EmergencyUnits[newGUID] = true
                                DebugPrint(string.format("✅ Track Emergency GUID: %s", tostring(newGUID)))
                            else
                                DebugPrint("⚠️ WARNING: PlaceUnit success แต่ไม่มี GUID!")
                            end
                            
                            LastEmergencyTime = tick()
                            
                            -- เช็คอีกครั้งว่าครบหรือยัง
                            local newCount = 0
                            for guid in pairs(EmergencyUnits) do 
                                newCount = newCount + 1
                                DebugPrint(string.format("  📌 Emergency Unit: %s", tostring(guid)))
                            end
                            
                            DebugPrint(string.format("🚨 Emergency Count Updated: %d / %d", newCount, MAX_EMERGENCY_UNITS))
                            
                            if newCount >= MAX_EMERGENCY_UNITS then
                                EmergencyActivated = true
                                DebugPrint(string.format("✅ วาง Emergency Units ครบ %d ตัวแล้ว! กลับสู่โหมดปกติ", newCount))
                            end
                            return
                        else
                            DebugPrint("❌ วาง Emergency ไม่สำเร็จ")
                        end
                    else
                        DebugPrint("❌ ไม่พบตำแหน่ง Emergency!")
                    end
                else
                    DebugPrint("⏳ รอเงินสำหรับ Emergency")
                end
            else
                EmergencyActivated = true
                DebugPrint(string.format("✅ Emergency Units ครบ %d ตัวแล้ว", emergencyCount))
            end
        else
            DebugPrint(string.format("⏳ รอ Emergency Mode... (%.1fs / %.1fs)", 
                timeSinceEmergency, EMERGENCY_DELAY))
        end
    end
    
    -- Normal Mode: วาง Damage ปกติ (หลัง Economy ครบ + อัพเกรดเต็มทุกตัว) - ใช้ Scoring System
    -- ถ้า EmergencyActivated = true แสดงว่าผ่าน Emergency แล้ว สามารถวางปกติได้
    local canPlaceNormalDamage = not damageFull and economyFull and allEconomyMaxed and (not IsEmergency or EmergencyActivated)
    
    DebugPrint(string.format("🔍 Normal Damage Check: damageFull=%s, economyFull=%s, allMaxed=%s, IsEmergency=%s, EmergencyActivated=%s, CanPlace=%s",
        tostring(damageFull), tostring(economyFull), tostring(allEconomyMaxed), 
        tostring(IsEmergency), tostring(EmergencyActivated), tostring(canPlaceNormalDamage)))
    
    if canPlaceNormalDamage then
        local slot, unit, remaining = GetNextDamageSlot()
        
        DebugPrint(string.format("🔍 GetNextDamageSlot: slot=%s, unit=%s, remaining=%s", 
            tostring(slot), unit and unit.Name or "nil", tostring(remaining)))
        
        if slot and unit then
            DebugPrint(string.format("💰 Yen Check: Have=%d, Need=%d, CanAfford=%s", 
                GetYen(), unit.Price, tostring(CanAfford(unit.Price))))
            
            if CanAfford(unit.Price) then
                local unitRange = unit.Range or 20
                DebugPrint(string.format("⚔️ [NORMAL MODE] วาง Damage: %s (slot %d, range %.1f, เหลือ %d)", 
                    unit.Name, slot, unitRange, remaining))
                
                -- ใช้ Normal Damage Position (Scoring: Paths + Time + Corners - ไม่เกี่ยว Base)
                DebugPrint("🔍 กำลังหาตำแหน่ง Normal Damage...")
                local pos = GetDamagePosition(unitRange)
                
                DebugPrint(string.format("🔍 GetDamagePosition Result: pos=%s", tostring(pos)))
                
                if pos then
                    DebugPrint(string.format("⚔️ Normal Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
                    local success, newGUID = PlaceUnit(slot, pos)
                    if success then
                        DebugPrint("✅ วาง Damage (Normal Mode) สำเร็จ!")
                        return
                    end
                else
                    DebugPrint("❌ ไม่พบตำแหน่งวาง Damage!")
                end
            else
                DebugPrint("⏳ รอเงินสำหรับ Damage:", unit.Price)
            end
        end
    end
    
    -- ===== PRIORITY 4: อัพเกรดตัวดาเมจ (หลังอัพเกรด Economy เต็มแล้ว) =====
    if economyFull and damageFull then
        local strongest = GetStrongestUnit(PlacedDamageUnits)
        if strongest then
            local cost = GetUpgradeCost(strongest)
            if CanAfford(cost) then
                if UpgradeUnit(strongest) then
                    DebugPrint("⚔️ อัพเกรด Damage:", strongest.Name)
                    return
                end
            end
        end
    end
    
    -- ===== PRIORITY 5: วางตัวบัพ (จนกว่าจะครบ limit) =====
    if not AllBuffSlotsFull() then
        local slot, unit, remaining = GetNextBuffSlot()
        if slot and unit and CanAfford(unit.Price) then
            local pos = GetBuffPosition(unit.Data and unit.Data.Range or 20)
            if pos then
                DebugPrint(string.format("🛡️ วาง Buff slot %d (เหลือ %d)", slot, remaining))
                if PlaceUnit(slot, pos) then
                    return
                end
            end
        end
    end
    
    -- ===== PRIORITY 6: อัพเกรดตัวบัพ =====
    for _, unit in pairs(PlacedBuffUnits) do
        local cost = GetUpgradeCost(unit)
        if CanAfford(cost) then
            if UpgradeUnit(unit) then
                return
            end
        end
    end
    
    -- ===== PRIORITY 7: ถ้าวางครบหมดแล้ว ให้อัพเกรด Damage ต่อ =====
    if AllEconomySlotsFull() and AllDamageSlotsFull() and AllBuffSlotsFull() then
        DebugPrint("✅ วางครบทุก slot แล้ว! เน้นอัพเกรด...")
        
        -- อัพเกรดตัวดาเมจที่แรงที่สุดต่อ
        local strongest = GetStrongestUnit(PlacedDamageUnits)
        if strongest then
            local cost = GetUpgradeCost(strongest)
            if CanAfford(cost) then
                UpgradeUnit(strongest)
            end
        end
    end
end

-- ===== SECTION 13: AUTO START / VOTE SKIP SYSTEM =====

local function AutoVoteSkip()
    -- Vote Skip เปิดอยู่ตลอด
    
    local currentTime = tick()
    if currentTime - LastVoteSkipTime < VOTE_SKIP_COOLDOWN then return end
    
    -- วิธี 1: ใช้ SkipWaveEvent
    if SkipWaveEvent then
        pcall(function()
            SkipWaveEvent:FireServer("Skip")
            LastVoteSkipTime = currentTime
            DebugPrint("🚀 Vote Skip via SkipWaveEvent!")
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
                        DebugPrint("🚀 พบ Skip Button:", desc.Name)
                        
                        -- ลองคลิก
                        pcall(function()
                            if getconnections then
                                for _, conn in pairs(getconnections(desc.MouseButton1Click)) do
                                    conn:Fire()
                                end
                                for _, conn in pairs(getconnections(desc.Activated)) do
                                    conn:Fire()
                                end
                            end
                        end)
                        
                        pcall(function()
                            local vim = game:GetService("VirtualInputManager")
                            local pos = desc.AbsolutePosition
                            local size = desc.AbsoluteSize
                            local centerX = pos.X + size.X / 2
                            local centerY = pos.Y + size.Y / 2
                            vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
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
    -- Auto Start เปิดอยู่ตลอด
    
    local success = false
    DebugPrint("🎮 TryStartGame called!")
    
    -- ===== วิธี 1: ใช้ SkipWaveEvent =====
    pcall(function()
        if SkipWaveEvent then
            SkipWaveEvent:FireServer("Skip")
            DebugPrint("🎮 Start via SkipWaveEvent!")
            success = true
        end
    end)
    
    if success then return true end
    
    -- ===== วิธี 2: หา Start/Ready Button =====
    pcall(function()
        local guisToSearch = {
            PlayerGui:FindFirstChild("LobbyHUD"),
            PlayerGui:FindFirstChild("Lobby"),
            PlayerGui:FindFirstChild("MainHUD"),
            PlayerGui:FindFirstChild("HUD"),
            PlayerGui:FindFirstChild("MainMenu"),
            PlayerGui:FindFirstChild("Menu"),
            PlayerGui:FindFirstChild("Game"),
            PlayerGui:FindFirstChild("GameHUD")
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
                        
                        local isStartButton = name:find("start") or name:find("ready") or name:find("begin") or name:find("play")
                        local isStartText = text:find("start") or text:find("ready") or text:find("begin") or text:find("play")
                        
                        if (isStartButton or isStartText) and desc.Visible then
                            DebugPrint("🎮 พบ Start Button:", desc.Name)
                            
                            pcall(function()
                                if getconnections then
                                    for _, conn in pairs(getconnections(desc.MouseButton1Click)) do
                                        conn:Fire()
                                    end
                                    for _, conn in pairs(getconnections(desc.Activated)) do
                                        conn:Fire()
                                    end
                                end
                            end)
                            
                            pcall(function()
                                local vim = game:GetService("VirtualInputManager")
                                local pos = desc.AbsolutePosition
                                local size = desc.AbsoluteSize
                                local centerX = pos.X + size.X / 2
                                local centerY = pos.Y + size.Y / 2
                                vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                                task.wait(0.05)
                                vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                            end)
                            
                            success = true
                            DebugPrint("✅ Clicked Start Button:", desc.Name)
                            break
                        end
                    end
                end
            end
        end
    end)
    
    -- ===== วิธี 3: ใช้ StartMatchEvent =====
    if not success and StartMatchEvent then
        pcall(function()
            StartMatchEvent:FireServer()
            DebugPrint("🎮 Start via StartMatchEvent!")
            success = true
        end)
    end
    
    -- ===== วิธี 4: ใช้ ReadyEvent =====
    if not success and ReadyEvent then
        pcall(function()
            ReadyEvent:FireServer(true)
            DebugPrint("🎮 Ready via ReadyEvent!")
            success = true
        end)
    end
    
    -- ===== วิธี 5: หา Remote Event อื่นๆ =====
    if not success then
        pcall(function()
            for _, event in pairs(Networking:GetDescendants()) do
                if event:IsA("RemoteEvent") then
                    local eventName = event.Name:lower()
                    if eventName:find("start") or eventName:find("ready") or eventName:find("begin") then
                        DebugPrint("🎮 Found start event:", event.Name)
                        event:FireServer()
                        success = true
                        break
                    end
                end
            end
        end)
    end
    
    if success then
        DebugPrint("✅ Game start initiated!")
    else
        DebugPrint("⚠️ Could not find way to start game")
    end
    
    return success
end

local function InitAutoStart()
    -- Auto Start & Vote Skip เปิดอยู่ตลอดเวลา
    
    DebugPrint("🚀 Initializing Auto Start / Vote Skip...")
    DebugPrint("  SkipWaveEvent:", SkipWaveEvent and "Found" or "Not found")
    DebugPrint("  StartMatchEvent:", StartMatchEvent and "Found" or "Not found")
    DebugPrint("  ReadyEvent:", ReadyEvent and "Found" or "Not found")
    
    -- รับ Event จาก SkipWaveEvent
    if SkipWaveEvent then
        pcall(function()
            SkipWaveEvent:FireServer("Loaded")
            DebugPrint("✅ ส่ง Loaded ไปยัง SkipWaveEvent")
        end)
        
        SkipWaveEvent.OnClientEvent:Connect(function(action, data)
            if action == "Show" then
                SkipWaveActive = true
                DebugPrint("🚀 Skip Wave popup แสดง")
                task.wait(0.5)
                AutoVoteSkip()
            elseif action == "Update" then
                if SkipWaveActive then
                    DebugPrint("📊 Vote Update:", data and data.SkippedPlayers or "?", "/", data and data.MaxPlayers or "?")
                end
            elseif action == "Close" then
                SkipWaveActive = false
                MatchStarted = true
                DebugPrint("✅ Skip Wave เสร็จสิ้น - Match Started!")
            elseif action == "MatchEnded" or action == "GameOver" then
                MatchStarted = false
                MatchEnded = true
                DebugPrint("🏁 Match Ended!")
            end
        end)
    end
    
    -- Auto Start Loop
    task.spawn(function()
        while true do  -- ทำงานตลอด
            task.wait(AUTO_START_INTERVAL)
            
            if not MatchStarted and not MatchEnded then
                TryStartGame()
            end
            
            -- Reset MatchEnded หลังจากสักพัก (เพื่อให้ join เกมใหม่ได้)
            if MatchEnded then
                task.wait(5)
                MatchEnded = false
                DebugPrint("🔄 Reset MatchEnded - พร้อมเริ่มเกมใหม่")
            end
        end
    end)
end

-- ===== SECTION 14: MAIN LOOP =====

local function MainLoop()
    DebugPrint("🎮 AutoPlay Smart เริ่มทำงาน!")
    InitYenTracking()
    InitAutoStart()
    
    while ENABLED do
        pcall(function()
            DecideAction()
        end)
        
        task.wait(ACTION_COOLDOWN)
    end
end

-- ===== START =====
task.spawn(MainLoop)

-- ===== RETURN MODULE =====
return {
    -- Constants
    DEBUG = DEBUG,
    ACTION_COOLDOWN = ACTION_COOLDOWN,
    UNIT_SPACING = UNIT_SPACING,
    -- MAX_UPGRADE_LEVEL ถูกลบออก - ใช้ GetMaxUpgradeLevel(unit) แทน
    
    UnitType = UnitType,
    
    -- Functions
    GetYen = GetYen,
    GetWaveFromUI = GetWaveFromUI,
    IsMaxWave = IsMaxWave,
    GetEnemyProgress = GetEnemyProgress,
    CheckEmergency = CheckEmergency,
    
    -- Manual Actions
    PlaceUnit = PlaceUnit,
    UpgradeUnit = UpgradeUnit,
    SellUnit = SellUnit,
    SellAllEconomyUnits = SellAllEconomyUnits,
    
    -- Utilities
    GetHotbarUnits = GetHotbarUnits,
    GetActiveUnits = GetActiveUnits,
    GetMapPath = GetMapPath,
    
    -- Slot Management (NEW)
    GetSlotLimit = GetSlotLimit,
    CanPlaceSlot = CanPlaceSlot,
    UpdateAllSlotLimits = UpdateAllSlotLimits,
    HasAvailableSlots = HasAvailableSlots,
    GetNextPlaceableSlot = GetNextPlaceableSlot,
    GetNextEconomySlot = GetNextEconomySlot,
    GetNextDamageSlot = GetNextDamageSlot,
    GetNextBuffSlot = GetNextBuffSlot,
    AllEconomySlotsFull = AllEconomySlotsFull,
    AllDamageSlotsFull = AllDamageSlotsFull,
    AllBuffSlotsFull = AllBuffSlotsFull,
    GetSlotsSummary = GetSlotsSummary,
    
    -- Auto Start / Vote Skip
    AutoVoteSkip = AutoVoteSkip,
    TryStartGame = TryStartGame,
    InitAutoStart = InitAutoStart,
    
    -- State
    SlotLimits = SlotLimits,
    AllSlotsPlaced = AllSlotsPlaced,
    PlacedUnits = PlacedUnits,
    PlacedEconomyUnits = PlacedEconomyUnits,
    PlacedDamageUnits = PlacedDamageUnits,
    PlacedBuffUnits = PlacedBuffUnits,
    EmergencyUnits = EmergencyUnits,      -- NEW: Emergency Units tracking
    LastEmergencyTime = LastEmergencyTime, -- NEW: Emergency Timer
    MatchStarted = MatchStarted,
    MatchEnded = MatchEnded,
    SkipWaveActive = SkipWaveActive,
    
    -- Control
    Start = MainLoop,
    Stop = function() ENABLED = false end,
    Enable = function() ENABLED = true end,
    Disable = function() ENABLED = false end,
}
