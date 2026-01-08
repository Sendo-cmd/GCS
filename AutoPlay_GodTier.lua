--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                    🎮 GOD-TIER AUTO PLAY SYSTEM v1.0                         ║
    ║══════════════════════════════════════════════════════════════════════════════║
    ║  🗺️ Volumetric Map Hashing (3D Voxel Grid)                                   ║
    ║  🔮 Temporal Predictive Engine (Future Position Prediction)                  ║
    ║  💸 ROI-Based Economy Manager (Smart Farm Upgrade)                           ║
    ║  ⚔️ Combat Orchestrator (Buff/Debuff Sync)                                   ║
    ║  🛡️ Guardian Protocol (Anti-Leak Emergency)                                  ║
    ║  📡 Direct Packet Injection (Network-Level Speed)                            ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]]

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

--═══════════════════════════════════════════════════════════════════════════════
-- 📦 SERVICES & MODULES
--═══════════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUD = PlayerGui:WaitForChild("HUD", 10)

-- Wait for game to fully load
repeat task.wait(0.5) until workspace:FindFirstChild("Map")
repeat task.wait(0.5) until ReplicatedStorage:FindFirstChild("Networking")

--═══════════════════════════════════════════════════════════════════════════════
-- 🔧 CONFIGURATION
--═══════════════════════════════════════════════════════════════════════════════
local CONFIG = {
    -- Voxel Grid Settings
    VOXEL_SIZE = 1,                    -- ขนาด Voxel (Studs)
    PATH_RESOLUTION = 0.5,             -- ความละเอียดการจำลอง Path
    LOS_CACHE_ENABLED = true,          -- เปิด Line-of-Sight Pre-Bake
    
    -- Temporal Prediction Settings
    PLACE_ANIMATION_TIME = 0.5,        -- เวลา Animation วาง Unit
    DEFAULT_ATTACK_WINDUP = 0.3,       -- เวลาก่อนยิง
    PREDICTION_LOOKAHEAD = 1.0,        -- ทำนายล่วงหน้ากี่วินาที
    
    -- Economy Settings
    FARM_PRIORITY = true,              -- ให้ความสำคัญกับ Farm Units
    ROI_THRESHOLD = 3.0,               -- ROI ต่ำสุดที่ยอมรับ
    WAVE_END_RESERVE_TIME = 10,        -- เวลาก่อนจบ Wave ที่เริ่มอั้นเงิน
    
    -- Guardian Settings
    DANGER_THRESHOLD = 0.7,            -- ค่า Leak Probability ที่เริ่ม PANIC
    EMERGENCY_THRESHOLD = 0.9,         -- ค่าที่เริ่ม Last Resort
    
    -- Network Settings
    LATENCY_COMPENSATION = true,       -- เปิดการชดเชย Ping
    HEARTBEAT_RATE = 1/60,             -- อัตรา Update (60 FPS)
    
    -- Debug
    DEBUG_MODE = true,  -- เปิดไว้เพื่อ debug
    VERBOSE_LOG = false,
}

--═══════════════════════════════════════════════════════════════════════════════
-- 📊 GLOBAL STATE
--═══════════════════════════════════════════════════════════════════════════════
local GlobalState = {
    -- Game State
    CurrentWave = 0,
    MaxWave = 0,
    Money = 0,
    IsMatchStarted = false,
    IsMatchEnded = false,
    
    -- System State
    Mode = "SAFE",                     -- SAFE / DANGER / PANIC
    LastUpdate = 0,
    Ping = 0,
    
    -- Cached Data
    VoxelGrid = {},
    HeatMap = {},
    LOSCache = {},
    PlacementSpots = {},
    
    -- Active Entities
    Enemies = {},
    Units = {},
    FarmUnits = {},
    BuffUnits = {},
    
    -- Prediction Cache
    PredictedPositions = {},
}

--═══════════════════════════════════════════════════════════════════════════════
-- 🔌 MODULE LOADER & DIRECT DATA ACCESS
--═══════════════════════════════════════════════════════════════════════════════
local Modules = {}
local Remotes = {}

-- Load Remote Events (ตาม decompiled code: ReplicatedStorage.Networking)
local Networking = ReplicatedStorage:FindFirstChild("Networking")
if Networking then
    Remotes.UnitEvent = Networking:FindFirstChild("UnitEvent")
    Remotes.GameEvent = Networking:FindFirstChild("GameEvent")
    Remotes.AbilityEvent = Networking:FindFirstChild("AbilityEvent")
    Remotes.SkipWaveEvent = Networking:FindFirstChild("SkipWaveEvent")
end

local function SafeRequire(path)
    local success, result = pcall(function()
        return require(path)
    end)
    if success then
        return result
    else
        if CONFIG.VERBOSE_LOG then
            warn("[SafeRequire] Failed:", tostring(path))
        end
        return nil
    end
end

-- Try to get modules from gethsfenv/getfenv (executor environment)
local function TryGetModuleFromEnv()
    pcall(function()
        -- Some executors expose loaded modules through getgc or debug
        if getgc then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if v._ActiveUnits then
                        Modules.ClientUnitHandler = v
                    end
                    if v._ActiveEnemies then
                        Modules.ClientEnemyHandler = v
                    end
                    if v.GetYen and type(v.GetYen) == "function" then
                        Modules.PlayerYenHandler = v
                    end
                end
            end
        end
    end)
end

-- Load Game Modules (ตาม AV_System.lua ที่ทำงานได้)
local function LoadModules()
    -- Method 0: Try getgc (executor feature)
    TryGetModuleFromEnv()
    
    -- Method 1: Direct require from StarterPlayer.Modules (วิธีที่ AV_System ใช้!)
    pcall(function()
        local StarterPlayerModules = StarterPlayer:FindFirstChild("Modules")
        if StarterPlayerModules then
            local Gameplay = StarterPlayerModules:FindFirstChild("Gameplay")
            if Gameplay then
                -- ClientEnemyHandler
                local CEH = Gameplay:FindFirstChild("ClientEnemyHandler")
                if CEH and not Modules.ClientEnemyHandler then
                    Modules.ClientEnemyHandler = SafeRequire(CEH)
                end
                
                -- PlayerYenHandler
                local PYH = Gameplay:FindFirstChild("PlayerYenHandler")
                if PYH and not Modules.PlayerYenHandler then
                    Modules.PlayerYenHandler = SafeRequire(PYH)
                end
                
                -- Units folder
                local Units = Gameplay:FindFirstChild("Units")
                if Units then
                    local CUH = Units:FindFirstChild("ClientUnitHandler")
                    if CUH and not Modules.ClientUnitHandler then
                        Modules.ClientUnitHandler = SafeRequire(CUH)
                    end
                end
            end
            
            -- Interface/Loader/HUD/Units
            local Interface = StarterPlayerModules:FindFirstChild("Interface")
            if Interface then
                local Loader = Interface:FindFirstChild("Loader")
                if Loader then
                    local HUD = Loader:FindFirstChild("HUD")
                    if HUD then
                        local UnitsHUD = HUD:FindFirstChild("Units")
                        if UnitsHUD then
                            Modules.UnitsHUD = SafeRequire(UnitsHUD)
                        end
                    end
                end
            end
        end
    end)
    
    -- Method 2: ReplicatedStorage modules
    pcall(function()
        local repMods = ReplicatedStorage:FindFirstChild("Modules")
        if repMods then
            for _, descendant in pairs(repMods:GetDescendants()) do
                if descendant:IsA("ModuleScript") then
                    if descendant.Name == "MultiplierHandler" then
                        Modules.MultiplierHandler = SafeRequire(descendant)
                    elseif descendant.Name == "GameHandler" and not Modules.GameHandler then
                        Modules.GameHandler = SafeRequire(descendant)
                    end
                end
            end
        end
    end)
end

LoadModules()

-- Alternative: Get units directly from workspace
local function GetUnitsFromWorkspace()
    local units = {}
    local unitsFolder = workspace:FindFirstChild("Units")
    if unitsFolder then
        for _, unitModel in pairs(unitsFolder:GetChildren()) do
            if unitModel:IsA("Model") then
                units[unitModel.Name] = {
                    Model = unitModel,
                    Name = unitModel.Name,
                    Position = unitModel.PrimaryPart and unitModel.PrimaryPart.Position or Vector3.new(),
                    Player = LocalPlayer, -- Assume owned by local player for now
                }
            end
        end
    end
    return units
end

-- Fallback: Direct access to _ActiveUnits and _ActiveEnemies
local function GetActiveUnits()
    if Modules.ClientUnitHandler and Modules.ClientUnitHandler._ActiveUnits then
        return Modules.ClientUnitHandler._ActiveUnits
    end
    return GetUnitsFromWorkspace()
end

local function GetActiveEnemies()
    -- Try module first
    if Modules.ClientEnemyHandler then
        local activeEnemies = Modules.ClientEnemyHandler._ActiveEnemies
        if activeEnemies then
            return activeEnemies
        end
    end
    -- Fallback: Get from workspace Entities
    local enemies = {}
    local entitiesFolder = workspace:FindFirstChild("Entities")
    if entitiesFolder then
        for _, enemy in pairs(entitiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                enemies[enemy.Name] = {
                    Model = enemy,
                    Name = enemy.Name,
                    Position = enemy.PrimaryPart and enemy.PrimaryPart.Position or Vector3.new(),
                }
            end
        end
    end
    return enemies
end

local function GetYen()
    -- Method 1: Try module
    if Modules.PlayerYenHandler then
        if typeof(Modules.PlayerYenHandler.GetYen) == "function" then
            local success, yen = pcall(function()
                return Modules.PlayerYenHandler:GetYen()
            end)
            if success and yen then return yen end
        end
        
        -- Try _Yen or Yen property directly
        if Modules.PlayerYenHandler._Yen then
            return Modules.PlayerYenHandler._Yen
        end
        if Modules.PlayerYenHandler.Yen then
            return Modules.PlayerYenHandler.Yen
        end
    end
    
    -- Method 2: Read from HUD (เกมแสดงเงินบน UI)
    local success, yen = pcall(function()
        local hud = PlayerGui:FindFirstChild("HUD")
        if hud then
            -- Try common yen display locations
            local yenFrame = hud:FindFirstChild("Yen") or hud:FindFirstChild("Money") or hud:FindFirstChild("Currency")
            if yenFrame then
                local label = yenFrame:FindFirstChildOfClass("TextLabel") or yenFrame:FindFirstChild("Amount")
                if label and label:IsA("TextLabel") then
                    local text = label.Text:gsub(",", ""):gsub("¥", ""):gsub("%$", "")
                    return tonumber(text) or 0
                end
            end
            
            -- Try finding any label with ¥ symbol
            for _, desc in pairs(hud:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text:find("¥") then
                    local text = desc.Text:gsub(",", ""):gsub("¥", ""):gsub("%s", "")
                    local num = text:match("%d+")
                    if num then 
                        return tonumber(num) 
                    end
                end
            end
        end
        return 0
    end)
    
    return success and yen or 0
end

--═══════════════════════════════════════════════════════════════════════════════
-- 📡 SECTION 6: DIRECT PACKET INJECTION (ใช้ Remotes ที่หาได้)
--═══════════════════════════════════════════════════════════════════════════════
local PacketSystem = {}

function PacketSystem:Init()
    self.LastPingCheck = tick()
    self.PingHistory = {}
    
    -- Use pre-loaded Remotes
    self.UnitEvent = Remotes.UnitEvent
    self.GameEvent = Remotes.GameEvent
    self.AbilityEvent = Remotes.AbilityEvent
    self.SkipWaveEvent = Remotes.SkipWaveEvent
    
    -- Debug: Print found remotes
    if CONFIG.DEBUG_MODE then
        print("[GodTier] Remotes loaded:")
        print("  UnitEvent:", self.UnitEvent and "✓" or "✗")
        print("  GameEvent:", self.GameEvent and "✓" or "✗")
        print("  AbilityEvent:", self.AbilityEvent and "✓" or "✗")
        print("  SkipWaveEvent:", self.SkipWaveEvent and "✓" or "✗")
    end
    
    -- Ping Measurement Loop
    task.spawn(function()
        while true do
            self:MeasurePing()
            task.wait(1)
        end
    end)
end

function PacketSystem:MeasurePing()
    pcall(function()
        -- Use Stats service for ping estimation
        local stats = game:GetService("Stats")
        local network = stats:FindFirstChild("Network")
        if network then
            local ping = network:FindFirstChild("ServerStatsItem")
            if ping then
                GlobalState.Ping = ping:GetValue() / 1000 -- Convert to seconds
            end
        end
    end)
    
    -- Fallback: estimate from heartbeat
    if GlobalState.Ping == 0 then
        GlobalState.Ping = 0.05 -- Default 50ms
    end
end

-- ส่ง Unit Placement (ตาม decom: UnitEvent:FireServer("Render", {...}))
function PacketSystem:PlaceUnit(unitName, unitId, position, rotation, fromGUID)
    if not self.UnitEvent then 
        warn("[GodTier] UnitEvent not found!")
        return false 
    end
    
    local data = {unitName, unitId, position, rotation % 360, fromGUID or nil}
    local options = fromGUID and {FromUnitGUID = fromGUID} or nil
    
    pcall(function()
        self.UnitEvent:FireServer("Render", data, options)
    end)
    return true
end

-- ส่ง Upgrade Unit
function PacketSystem:UpgradeUnit(unitGUID)
    if not self.UnitEvent then return false end
    pcall(function()
        self.UnitEvent:FireServer("Upgrade", unitGUID)
    end)
    return true
end

-- เปลี่ยน Priority
function PacketSystem:ChangePriority(unitGUID, priority)
    if not self.UnitEvent then return false end
    pcall(function()
        self.UnitEvent:FireServer("ChangePriority", unitGUID, priority)
    end)
    return true
end

-- ใช้ Ability
function PacketSystem:UseAbility(unitGUID, abilityName)
    if not self.AbilityEvent then return false end
    pcall(function()
        self.AbilityEvent:FireServer("Activate", unitGUID, abilityName)
    end)
    return true
end

-- Skip Wave
function PacketSystem:SkipWave()
    if not self.SkipWaveEvent then return false end
    pcall(function()
        self.SkipWaveEvent:FireServer("Skip")
    end)
    return true
end

function PacketSystem:GetLatencyCompensation()
    if CONFIG.LATENCY_COMPENSATION then
        return GlobalState.Ping
    end
    return 0
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🗺️ SECTION 1: VOLUMETRIC MAP HASHING (3D Voxel System)
--═══════════════════════════════════════════════════════════════════════════════
local VoxelSystem = {}

function VoxelSystem:Init()
    self.Grid = {}
    self.PathNodes = {}
    self.HeatMap = {}
    self.LOSCache = {}
    self.BestSpots = {}
end

-- แปลงตำแหน่ง World เป็น Voxel Index
function VoxelSystem:WorldToVoxel(position)
    local size = CONFIG.VOXEL_SIZE
    return Vector3.new(
        math.floor(position.X / size),
        math.floor(position.Y / size),
        math.floor(position.Z / size)
    )
end

-- แปลง Voxel Index กลับเป็น World Position
function VoxelSystem:VoxelToWorld(voxelIndex)
    local size = CONFIG.VOXEL_SIZE
    return Vector3.new(
        voxelIndex.X * size + size/2,
        voxelIndex.Y * size + size/2,
        voxelIndex.Z * size + size/2
    )
end

-- สร้าง Hash Key สำหรับ Voxel
function VoxelSystem:GetVoxelKey(voxelIndex)
    return string.format("%d,%d,%d", voxelIndex.X, voxelIndex.Y, voxelIndex.Z)
end

-- สแกนแมพและสร้าง Voxel Grid
function VoxelSystem:ScanMap()
    self.Grid = {}
    
    -- หา Path Nodes จากเกม
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            local pathFolder = map:FindFirstChild("Path") or map:FindFirstChild("Paths")
            if pathFolder then
                for _, node in pairs(pathFolder:GetChildren()) do
                    if node:IsA("BasePart") then
                        table.insert(self.PathNodes, {
                            Position = node.Position,
                            Index = tonumber(node.Name) or #self.PathNodes + 1
                        })
                    end
                end
                -- Sort by index
                table.sort(self.PathNodes, function(a, b)
                    return a.Index < b.Index
                end)
            end
        end
    end)
end

-- จำลองศัตรูเดินผ่าน Path และสร้าง Time-Occupancy Heatmap
function VoxelSystem:SimulatePath(enemySpeed)
    self.HeatMap = {}
    enemySpeed = enemySpeed or 10 -- Default speed
    
    for i = 1, #self.PathNodes - 1 do
        local startNode = self.PathNodes[i]
        local endNode = self.PathNodes[i + 1]
        local distance = (endNode.Position - startNode.Position).Magnitude
        local travelTime = distance / enemySpeed
        
        -- Interpolate positions along path
        local steps = math.max(1, math.floor(distance / CONFIG.PATH_RESOLUTION))
        local timePerStep = travelTime / steps
        
        for step = 0, steps do
            local t = step / steps
            local pos = startNode.Position:Lerp(endNode.Position, t)
            local voxelKey = self:GetVoxelKey(self:WorldToVoxel(pos))
            
            self.HeatMap[voxelKey] = (self.HeatMap[voxelKey] or 0) + timePerStep
        end
    end
end

-- Pre-bake Line-of-Sight จากทุกจุดวางที่เป็นไปได้
function VoxelSystem:BakeLOS(placementSpots)
    if not CONFIG.LOS_CACHE_ENABLED then return end
    
    self.LOSCache = {}
    
    for _, spot in pairs(placementSpots) do
        local spotKey = self:GetVoxelKey(self:WorldToVoxel(spot.Position))
        self.LOSCache[spotKey] = {}
        
        -- Check LOS to all path nodes
        for _, node in pairs(self.PathNodes) do
            local origin = spot.Position + Vector3.new(0, 2, 0) -- Eye height
            local target = node.Position
            local direction = (target - origin).Unit
            local distance = (target - origin).Magnitude
            
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
            
            local result = Workspace:Raycast(origin, direction * distance, rayParams)
            local hasLOS = result == nil or (target - origin).Magnitude < distance
            
            local nodeKey = self:GetVoxelKey(self:WorldToVoxel(node.Position))
            self.LOSCache[spotKey][nodeKey] = hasLOS
        end
    end
end

-- คำนวณ Damage Potential ของแต่ละจุดวาง
function VoxelSystem:CalculateDamagePotential(spotPosition, unitRange, unitDPS)
    local potential = 0
    local spotVoxel = self:WorldToVoxel(spotPosition)
    
    for voxelKey, occupancyTime in pairs(self.HeatMap) do
        -- Parse voxel key
        local x, y, z = voxelKey:match("([^,]+),([^,]+),([^,]+)")
        local voxelPos = self:VoxelToWorld(Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
        
        -- Check if in range
        local distance = (voxelPos - spotPosition).Magnitude
        if distance <= unitRange then
            -- Check LOS
            local spotKey = self:GetVoxelKey(spotVoxel)
            if not self.LOSCache[spotKey] or self.LOSCache[spotKey][voxelKey] ~= false then
                potential = potential + (unitDPS * occupancyTime)
            end
        end
    end
    
    return potential
end

-- หาจุดวางที่ดีที่สุด
function VoxelSystem:GetBestPlacementSpot(unitData, placementSpots)
    local bestSpot = nil
    local bestPotential = 0
    
    local range = unitData.Range or 20
    local dps = unitData.DPS or 100
    
    for _, spot in pairs(placementSpots) do
        local potential = self:CalculateDamagePotential(spot.Position, range, dps)
        if potential > bestPotential then
            bestPotential = potential
            bestSpot = spot
        end
    end
    
    return bestSpot, bestPotential
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🔮 SECTION 2: TEMPORAL PREDICTIVE ENGINE
--═══════════════════════════════════════════════════════════════════════════════
local PredictionEngine = {}

function PredictionEngine:Init()
    self.EnemyVelocities = {}
    self.LastPositions = {}
    self.PredictionCache = {}
end

-- อัพเดท Velocity Vector ของศัตรู
function PredictionEngine:UpdateVelocity(enemyId, currentPosition)
    local lastData = self.LastPositions[enemyId]
    local currentTime = tick()
    
    if lastData then
        local dt = currentTime - lastData.Time
        if dt > 0 then
            local velocity = (currentPosition - lastData.Position) / dt
            self.EnemyVelocities[enemyId] = {
                Velocity = velocity,
                Speed = velocity.Magnitude,
                Direction = velocity.Unit,
            }
        end
    end
    
    self.LastPositions[enemyId] = {
        Position = currentPosition,
        Time = currentTime,
    }
end

-- ทำนายตำแหน่งศัตรูในอนาคต
function PredictionEngine:PredictPosition(enemyId, deltaTime)
    local velocityData = self.EnemyVelocities[enemyId]
    local lastPos = self.LastPositions[enemyId]
    
    if not velocityData or not lastPos then
        return nil
    end
    
    -- Linear prediction
    local predictedPos = lastPos.Position + velocityData.Velocity * deltaTime
    
    -- TODO: Add path-aware prediction (follow path nodes)
    
    return predictedPos
end

-- เช็คว่าถ้าวาง Unit ตอนนี้ จะยิงทันไหม
function PredictionEngine:CanHitAfterPlacement(enemyId, unitPosition, unitRange, attackWindup)
    local totalDelay = CONFIG.PLACE_ANIMATION_TIME + (attackWindup or CONFIG.DEFAULT_ATTACK_WINDUP)
    totalDelay = totalDelay + PacketSystem:GetLatencyCompensation()
    
    local predictedPos = self:PredictPosition(enemyId, totalDelay)
    if not predictedPos then
        return true -- ถ้าไม่มีข้อมูล ให้ลองวางไปก่อน
    end
    
    local distance = (predictedPos - unitPosition).Magnitude
    return distance <= unitRange
end

-- หาศัตรูที่จะอยู่ในระยะนานที่สุด
function PredictionEngine:GetBestTarget(enemies, unitPosition, unitRange)
    local bestEnemy = nil
    local longestTime = 0
    
    for enemyId, enemy in pairs(enemies) do
        local velocityData = self.EnemyVelocities[enemyId]
        if velocityData and velocityData.Speed > 0 then
            -- คำนวณว่าศัตรูจะอยู่ในระยะอีกกี่วินาที
            local currentDist = (enemy.Position - unitPosition).Magnitude
            if currentDist <= unitRange then
                -- Moving towards or away?
                local toUnit = (unitPosition - enemy.Position).Unit
                local dotProduct = velocityData.Direction:Dot(toUnit)
                
                local timeInRange
                if dotProduct < 0 then
                    -- Moving away
                    local distToExit = unitRange - currentDist
                    timeInRange = distToExit / velocityData.Speed
                else
                    -- Moving towards center, then will exit
                    timeInRange = (unitRange + currentDist) / velocityData.Speed
                end
                
                if timeInRange > longestTime then
                    longestTime = timeInRange
                    bestEnemy = enemy
                end
            end
        end
    end
    
    return bestEnemy, longestTime
end

--═══════════════════════════════════════════════════════════════════════════════
-- 💸 SECTION 3: ROI-BASED ECONOMY MANAGER
--═══════════════════════════════════════════════════════════════════════════════
local EconomyManager = {}

function EconomyManager:Init()
    self.FarmUnits = {}
    self.UpgradeQueue = {}
    self.ReservedMoney = 0
    self.LastWaveEndCheck = 0
end

-- หา Farm Units ทั้งหมดในสนาม (ใช้ structure จาก decompiled code)
function EconomyManager:FindFarmUnits(units)
    self.FarmUnits = {}
    
    for unitId, unit in pairs(units) do
        -- Check if owned by local player
        if unit.Player and unit.Player == LocalPlayer then
            if unit.Data then
                -- Check for UnitType = "Farm" (จาก decompiled code)
                local isFarm = unit.Data.UnitType == "Farm"
                -- Check for Economy tag
                local isEconomy = unit.Data.Tags and table.find(unit.Data.Tags, "Economy")
                -- Check if has income stat
                local hasIncome = unit.Income and unit.Income > 0
                
                if isFarm or isEconomy or hasIncome then
                    local currentLevel = unit.Data.CurrentUpgrade or 1
                    local maxLevel = unit.Data.Upgrades and #unit.Data.Upgrades or 1
                    
                    table.insert(self.FarmUnits, {
                        Id = unitId,  -- UniqueIdentifier
                        Unit = unit,
                        CurrentLevel = currentLevel,
                        MaxLevel = maxLevel,
                        CanUpgrade = currentLevel < maxLevel,
                    })
                end
            end
        end
    end
    
    if CONFIG.VERBOSE_LOG and #self.FarmUnits > 0 then
        print("[EconomyManager] Found", #self.FarmUnits, "farm units")
    end
end

-- คำนวณ Income ที่ได้จากการอัพเกรด
function EconomyManager:GetUpgradeIncome(unit)
    if not unit.Data or not unit.Data.Upgrades then
        return 0
    end
    
    local currentLevel = unit.Data.CurrentUpgrade or 1
    local nextLevel = currentLevel + 1
    
    if nextLevel > #unit.Data.Upgrades then
        return 0 -- Max level
    end
    
    local currentIncome = unit.Data.Upgrades[currentLevel].Income or 0
    local nextIncome = unit.Data.Upgrades[nextLevel].Income or 0
    
    return nextIncome - currentIncome
end

-- คำนวณราคาอัพเกรด
function EconomyManager:GetUpgradeCost(unit)
    if not unit.Data or not unit.Data.Upgrades then
        return math.huge
    end
    
    local currentLevel = unit.Data.CurrentUpgrade or 1
    local nextLevel = currentLevel + 1
    
    if nextLevel > #unit.Data.Upgrades then
        return math.huge -- Can't upgrade
    end
    
    return unit.Data.Upgrades[nextLevel].Cost or math.huge
end

-- คำนวณ Cost Per Yen (ROI)
function EconomyManager:CalculateROI(unit)
    local cost = self:GetUpgradeCost(unit)
    local incomeGain = self:GetUpgradeIncome(unit)
    
    if incomeGain <= 0 then
        return math.huge -- Not a farm upgrade
    end
    
    return cost / incomeGain -- Lower is better
end

-- หา Farm Unit ที่คุ้มที่สุดในการอัพเกรด
function EconomyManager:GetBestFarmUpgrade()
    local bestUnit = nil
    local bestROI = math.huge
    
    for _, farmData in pairs(self.FarmUnits) do
        local roi = self:CalculateROI(farmData.Unit)
        if roi < bestROI and roi < CONFIG.ROI_THRESHOLD then
            bestROI = roi
            bestUnit = farmData
        end
    end
    
    return bestUnit, bestROI
end

-- ตรวจสอบว่าควรอั้นเงินไว้หรือไม่
function EconomyManager:ShouldReserveMoney(currentWave, maxWave, timeUntilWaveEnd)
    if timeUntilWaveEnd < CONFIG.WAVE_END_RESERVE_TIME then
        -- ใกล้จบ Wave แล้ว อั้นเงินไว้วางตัวใหม่
        return true
    end
    
    return false
end

-- ตัดสินใจการใช้เงิน
function EconomyManager:DecideSpending(money, units, currentWave, timeUntilWaveEnd)
    self:FindFarmUnits(units)
    
    -- Check if should reserve money
    if self:ShouldReserveMoney(currentWave, GlobalState.MaxWave, timeUntilWaveEnd) then
        self.ReservedMoney = money * 0.5 -- Reserve 50%
    else
        self.ReservedMoney = 0
    end
    
    local availableMoney = money - self.ReservedMoney
    
    -- Priority 1: Upgrade existing farm units
    if CONFIG.FARM_PRIORITY and #self.FarmUnits > 0 then
        local bestFarm, roi = self:GetBestFarmUpgrade()
        if bestFarm then
            local cost = self:GetUpgradeCost(bestFarm.Unit)
            if cost <= availableMoney then
                return {
                    Action = "UPGRADE",
                    Target = bestFarm,
                    Cost = cost,
                    ROI = roi,
                }
            end
        end
    end
    
    -- Priority 2: Place new unit
    -- (จะถูก handle โดย Combat Orchestrator)
    return {
        Action = "PLACE_OR_COMBAT",
        AvailableMoney = availableMoney,
    }
end

--═══════════════════════════════════════════════════════════════════════════════
-- ⚔️ SECTION 4: COMBAT ORCHESTRATOR
--═══════════════════════════════════════════════════════════════════════════════
local CombatOrchestrator = {}

function CombatOrchestrator:Init()
    self.BuffUnits = {}
    self.DebuffUnits = {}
    self.SkillCooldowns = {}
    self.TargetOverrides = {}
    self.EnemyDebuffs = {}
end

-- หา Unit ที่มี Buff/Debuff (ใช้ structure จาก decompiled code)
function CombatOrchestrator:CategorizeUnits(units)
    self.BuffUnits = {}
    self.DebuffUnits = {}
    self.DPSUnits = {}
    
    for unitId, unit in pairs(units) do
        -- Check if owned by local player
        if unit.Player and unit.Player == LocalPlayer then
            if unit.Data then
                local unitType = unit.Data.UnitType
                local tags = unit.Data.Tags or {}
                
                -- Buffer/Support units
                if unitType == "Support" or table.find(tags, "Buffer") or table.find(tags, "Support") then
                    table.insert(self.BuffUnits, {
                        Id = unitId, 
                        Unit = unit,
                        AbilityName = self:GetAbilityName(unit)
                    })
                -- Debuffer units (Slow, Burn, etc)
                elseif table.find(tags, "Slow") or table.find(tags, "Burn") or table.find(tags, "Debuffer") then
                    table.insert(self.DebuffUnits, {
                        Id = unitId, 
                        Unit = unit,
                        AbilityName = self:GetAbilityName(unit)
                    })
                -- DPS units (not Farm)
                elseif unitType ~= "Farm" then
                    table.insert(self.DPSUnits, {
                        Id = unitId, 
                        Unit = unit,
                        AbilityName = self:GetAbilityName(unit)
                    })
                end
            end
        end
    end
end

-- Get ability name from unit
function CombatOrchestrator:GetAbilityName(unit)
    if unit.ActiveAbilities and #unit.ActiveAbilities > 0 then
        return unit.ActiveAbilities[1]
    end
    return nil
end

-- เช็ค Cooldown ของ Buff Unit
function CombatOrchestrator:GetBuffCooldown(unitId)
    local cd = self.SkillCooldowns[unitId]
    if cd and tick() < cd then
        return cd - tick()
    end
    return 0
end

-- ซิงค์การกดสกิล Buff กับ DPS Units
function CombatOrchestrator:SyncBuffActivation(buffUnits, dpsUnits)
    local readyBuffs = {}
    local readyDPS = {}
    
    -- หา Buff ที่พร้อมใช้
    for _, buffData in pairs(buffUnits) do
        if self:GetBuffCooldown(buffData.Id) <= 0 then
            table.insert(readyBuffs, buffData)
        end
    end
    
    -- หา DPS ที่พร้อมใช้สกิล
    for _, dpsData in pairs(dpsUnits) do
        if self:GetBuffCooldown(dpsData.Id) <= 0 then
            table.insert(readyDPS, dpsData)
        end
    end
    
    -- ถ้ามี Buff และ DPS พร้อม ให้กดพร้อมกัน
    if #readyBuffs > 0 and #readyDPS > 0 then
        return {
            Buffs = readyBuffs,
            DPS = readyDPS,
            ShouldSync = true,
        }
    end
    
    return nil
end

-- จัดการ Debuff Stacking
function CombatOrchestrator:ManageDebuffs(enemies, debuffUnits)
    local targetAssignments = {}
    
    for _, enemy in pairs(enemies) do
        local enemyId = enemy.UniqueIdentifier or tostring(enemy)
        local currentDebuffs = self.EnemyDebuffs[enemyId] or {}
        
        -- หา Debuff ที่ยังไม่ติด
        local neededDebuffs = {}
        for _, debuffUnit in pairs(debuffUnits) do
            local debuffType = debuffUnit.Unit.Data.DebuffType or "Unknown"
            if not currentDebuffs[debuffType] then
                table.insert(neededDebuffs, debuffType)
            end
        end
        
        -- Assign debuff units to enemies that need them
        if #neededDebuffs > 0 then
            targetAssignments[enemyId] = {
                Enemy = enemy,
                NeededDebuffs = neededDebuffs,
            }
        end
    end
    
    return targetAssignments
end

-- ระบบ Sell & Reposition (Juggling)
function CombatOrchestrator:ShouldJuggle(unit, bossPosition, bossDirection)
    if not unit or not bossPosition then return false end
    
    local unitPos = unit.Position
    local unitRange = unit.Data and unit.Data.Range or 20
    
    -- บอสออกจากระยะแล้ว
    local distance = (bossPosition - unitPos).Magnitude
    if distance > unitRange * 1.2 then -- 20% buffer
        -- คำนวณตำแหน่งใหม่ที่บอสจะไป
        local predictedPos = bossPosition + bossDirection * unitRange * 0.5
        
        return {
            ShouldJuggle = true,
            SellUnit = unit,
            NewPosition = predictedPos,
        }
    end
    
    return {ShouldJuggle = false}
end

-- กำหนด Priority ตาม Wave Type
function CombatOrchestrator:GetWavePriority(isBossWave, isLeakWarning, isAoE)
    if isBossWave then
        return "Strongest"
    elseif isLeakWarning then
        return "First"
    elseif isAoE then
        return "Closest" -- หรือจุดที่ศัตรูกระจุกตัวมากสุด
    end
    
    return "First" -- Default
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🛡️ SECTION 5: GUARDIAN PROTOCOL
--═══════════════════════════════════════════════════════════════════════════════
local GuardianProtocol = {}

function GuardianProtocol:Init()
    self.LeakProbabilities = {}
    self.EmergencyMode = false
    self.LastEmergencyAction = 0
end

-- คำนวณ Time To Kill
function GuardianProtocol:CalculateTTK(enemyHP, teamDPS)
    if teamDPS <= 0 then
        return math.huge
    end
    return enemyHP / teamDPS
end

-- คำนวณ Time To Base
function GuardianProtocol:CalculateTTB(enemy, pathNodes)
    if not enemy.CurrentNode or not enemy.Speed then
        return math.huge
    end
    
    local distanceToEnd = enemy.CurrentNode.DistanceToEnd or 0
    local speed = enemy.Speed or 10
    
    return distanceToEnd / speed
end

-- คำนวณ DPS รวมของทีมที่ยิงถึง
function GuardianProtocol:CalculateTeamDPS(units, targetPosition, targetRange)
    local totalDPS = 0
    
    for _, unit in pairs(units) do
        local unitPos = unit.Position
        local unitRange = unit.Data and unit.Data.Range or 20
        local unitDPS = unit.Data and unit.Data.DPS or 0
        
        local distance = (targetPosition - unitPos).Magnitude
        if distance <= unitRange then
            -- Check LOS
            local hasLOS = true -- TODO: Use VoxelSystem.LOSCache
            if hasLOS then
                totalDPS = totalDPS + unitDPS
            end
        end
    end
    
    return totalDPS
end

-- คำนวณ Leak Probability ของศัตรู
function GuardianProtocol:CalculateLeakProbability(enemy, units, pathNodes)
    local enemyHP = enemy.Data and enemy.Data.Health or 0
    local teamDPS = self:CalculateTeamDPS(units, enemy.Position, 100)
    
    local ttk = self:CalculateTTK(enemyHP, teamDPS)
    local ttb = self:CalculateTTB(enemy, pathNodes)
    
    if ttb <= 0 then
        return 1.0 -- Already at base
    end
    
    -- Probability = TTK / TTB (higher = more likely to leak)
    local probability = math.clamp(ttk / ttb, 0, 1)
    
    self.LeakProbabilities[enemy.UniqueIdentifier or tostring(enemy)] = probability
    
    return probability
end

-- วิเคราะห์อันตรายทั้งหมด
function GuardianProtocol:AnalyzeDanger(enemies, units, pathNodes)
    local maxProbability = 0
    local dangerousEnemy = nil
    
    for _, enemy in pairs(enemies) do
        local prob = self:CalculateLeakProbability(enemy, units, pathNodes)
        if prob > maxProbability then
            maxProbability = prob
            dangerousEnemy = enemy
        end
    end
    
    -- Determine mode
    if maxProbability >= CONFIG.EMERGENCY_THRESHOLD then
        GlobalState.Mode = "PANIC"
        self.EmergencyMode = true
    elseif maxProbability >= CONFIG.DANGER_THRESHOLD then
        GlobalState.Mode = "DANGER"
        self.EmergencyMode = false
    else
        GlobalState.Mode = "SAFE"
        self.EmergencyMode = false
    end
    
    return {
        MaxProbability = maxProbability,
        DangerousEnemy = dangerousEnemy,
        Mode = GlobalState.Mode,
    }
end

-- Emergency Actions
function GuardianProtocol:ExecuteEmergencyActions(dangerousEnemy, units, farmUnits)
    local actions = {}
    
    -- Target Snipe: เปลี่ยนเป้า Unit ทุกตัวให้เล็งตัวที่จะหลุด
    table.insert(actions, {
        Type = "TARGET_SNIPE",
        Target = dangerousEnemy,
        Priority = "First",
    })
    
    if self.EmergencyMode then
        -- Last Resort: ขายฟาร์มทิ้งทั้งหมด
        for _, farm in pairs(farmUnits) do
            table.insert(actions, {
                Type = "SELL",
                Target = farm,
                Reason = "EMERGENCY_LIQUIDATION",
            })
        end
        
        -- Spam วางตัวดาเมจที่หน้าฐาน
        table.insert(actions, {
            Type = "SUICIDE_SQUAD",
            Position = dangerousEnemy.Position,
        })
    end
    
    return actions
end

-- Body Block (ถ้าเกมมี Collision)
function GuardianProtocol:GetBodyBlockPosition(enemy)
    -- วาง Unit ขวางทาง
    local enemyPos = enemy.Position
    local direction = enemy.Direction or Vector3.new(0, 0, -1)
    
    -- วางหน้าศัตรู
    return enemyPos + direction * 2
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🎮 MASTER WORKFLOW (Main Loop)
--═══════════════════════════════════════════════════════════════════════════════
local MasterController = {}

function MasterController:Init()
    -- Initialize all systems
    PacketSystem:Init()
    VoxelSystem:Init()
    PredictionEngine:Init()
    EconomyManager:Init()
    CombatOrchestrator:Init()
    GuardianProtocol:Init()
    
    -- Initial map scan
    VoxelSystem:ScanMap()
    VoxelSystem:SimulatePath()
    
    if CONFIG.DEBUG_MODE then
        print("[GodTier] All systems initialized!")
    end
end

-- ดึงข้อมูลสถานะเกม
function MasterController:UpdateWorldState()
    -- Update Wave Info
    pcall(function()
        local hud = PlayerGui:FindFirstChild("HUD")
        if hud then
            local map = hud:FindFirstChild("Map")
            if map then
                local wavesAmount = map:FindFirstChild("WavesAmount")
                if wavesAmount then
                    local text = wavesAmount.Text
                    local current, max = text:match("(%d+)/(%d+)")
                    GlobalState.CurrentWave = tonumber(current) or 0
                    GlobalState.MaxWave = tonumber(max) or 0
                end
            end
        end
    end)
    
    -- Update Money (ใช้ GetYen function)
    GlobalState.Money = GetYen()
    
    -- Update Enemies (ใช้ GetActiveEnemies function)
    GlobalState.Enemies = GetActiveEnemies()
    
    -- Update Units (ใช้ GetActiveUnits function)
    GlobalState.Units = GetActiveUnits()
    
    -- Update enemy velocities for prediction
    for enemyId, enemy in pairs(GlobalState.Enemies) do
        if enemy.Position then
            PredictionEngine:UpdateVelocity(enemyId, enemy.Position)
        end
    end
    
    -- Check Game State
    if Modules.GameHandler then
        pcall(function()
            GlobalState.IsMatchStarted = Modules.GameHandler.IsMatchStarted or false
        end)
    end
end

-- Main Heartbeat Loop
function MasterController:Heartbeat()
    -- Step 1: Update World State
    self:UpdateWorldState()
    
    -- Step 2: Danger Analysis (Guardian Protocol)
    local dangerAnalysis = GuardianProtocol:AnalyzeDanger(
        GlobalState.Enemies, 
        GlobalState.Units, 
        VoxelSystem.PathNodes
    )
    
    -- Step 3: Mode-Based Decision
    if GlobalState.Mode == "PANIC" then
        -- EMERGENCY: Skip economy, go straight to combat
        local emergencyActions = GuardianProtocol:ExecuteEmergencyActions(
            dangerAnalysis.DangerousEnemy,
            GlobalState.Units,
            EconomyManager.FarmUnits
        )
        
        for _, action in pairs(emergencyActions) do
            self:ExecuteAction(action)
        end
        
        return -- Exit early
    end
    
    -- Step 4: Economy Cycle (Safe Mode)
    if GlobalState.Mode == "SAFE" or GlobalState.Mode == "DANGER" then
        local economyDecision = EconomyManager:DecideSpending(
            GlobalState.Money,
            GlobalState.Units,
            GlobalState.CurrentWave,
            0 -- TODO: Calculate time until wave end
        )
        
        if economyDecision.Action == "UPGRADE" then
            self:ExecuteUpgrade(economyDecision.Target, economyDecision.Cost)
            return -- One action per frame for speed
        end
    end
    
    -- Step 5: Combat Cycle
    CombatOrchestrator:CategorizeUnits(GlobalState.Units)
    
    -- Check buff sync opportunity
    local syncData = CombatOrchestrator:SyncBuffActivation(
        CombatOrchestrator.BuffUnits,
        GlobalState.Units
    )
    if syncData and syncData.ShouldSync then
        self:ExecuteBuffSync(syncData)
    end
    
    -- Step 6: Targeting
    local isBossWave = GlobalState.CurrentWave == GlobalState.MaxWave
    local priority = CombatOrchestrator:GetWavePriority(
        isBossWave,
        GlobalState.Mode == "DANGER",
        false -- TODO: Detect AoE units
    )
    
    self:UpdateTargeting(priority)
    
    -- Step 7: Lifecycle Check
    self:CheckLifecycle()
end

-- Execute Unit Upgrade
function MasterController:ExecuteUpgrade(target, cost)
    if not target or not target.Unit then return end
    
    -- ใช้ Direct Packet Injection
    local success = PacketSystem:UpgradeUnit(target.Id)
    
    if CONFIG.DEBUG_MODE then
        print(string.format("[GodTier] Upgrading unit %s for %d (ROI: %.2f)", 
            target.Id, cost, EconomyManager:CalculateROI(target.Unit)))
    end
end

-- Execute Buff Sync
function MasterController:ExecuteBuffSync(syncData)
    -- Activate all buffs first
    for _, buffData in pairs(syncData.Buffs) do
        PacketSystem:UseAbility(buffData.Id, buffData.AbilityName or "Skill")
        CombatOrchestrator.SkillCooldowns[buffData.Id] = tick() + 10 -- Assume 10s CD
    end
    
    -- Then activate DPS skills
    for _, dpsData in pairs(syncData.DPS) do
        PacketSystem:UseAbility(dpsData.Id, dpsData.AbilityName or "Skill")
        CombatOrchestrator.SkillCooldowns[dpsData.Id] = tick() + 10
    end
    
    if CONFIG.DEBUG_MODE then
        print(string.format("[GodTier] Synced %d buffs with %d DPS skills", 
            #syncData.Buffs, #syncData.DPS))
    end
end

-- Execute Emergency Action
function MasterController:ExecuteAction(action)
    if action.Type == "TARGET_SNIPE" then
        -- Change all units to target dangerous enemy
        for unitId, unitData in pairs(GetActiveUnits()) do
            if unitData.Player == LocalPlayer then
                PacketSystem:ChangePriority(unitId, "First")
            end
        end
        
    elseif action.Type == "SELL" then
        -- ยังไม่มี Sell remote ใน decom ที่อ่านได้
        if CONFIG.DEBUG_MODE then
            warn("[GodTier] Sell action not implemented")
        end
        
    elseif action.Type == "SUICIDE_SQUAD" then
        -- Spam place units at position
        if CONFIG.DEBUG_MODE then
            print("[GodTier] SUICIDE SQUAD activated at", action.Position)
        end
    end
end

-- Update Targeting
function MasterController:UpdateTargeting(priority)
    for unitId, unitData in pairs(GetActiveUnits()) do
        if unitData.Player == LocalPlayer then
            PacketSystem:ChangePriority(unitId, priority)
        end
    end
end

-- Check Lifecycle
function MasterController:CheckLifecycle()
    -- Check match ended
    pcall(function()
        local hud = PlayerGui:FindFirstChild("HUD")
        if hud then
            local endScreen = hud:FindFirstChild("MatchEnded") or hud:FindFirstChild("GameOver")
            if endScreen and endScreen.Visible then
                GlobalState.IsMatchEnded = true
                self:OnMatchEnd()
            end
        end
    end)
    
    -- Check vote skip
    pcall(function()
        local hud = PlayerGui:FindFirstChild("HUD")
        if hud then
            local voteSkip = hud:FindFirstChild("VoteSkip") or hud:FindFirstChild("SkipWave")
            if voteSkip and voteSkip.Visible then
                PacketSystem:SkipWave()
            end
        end
    end)
end

-- Match End Handler
function MasterController:OnMatchEnd()
    if CONFIG.DEBUG_MODE then
        print("[GodTier] Match ended. Attempting replay...")
    end
end

-- Start the system
function MasterController:Start()
    self:Init()
    
    -- Reload modules (in case they weren't loaded at startup)
    LoadModules()
    
    -- Debug print modules loaded
    print("═══════════════════════════════════════════════════")
    print("    🎮 GOD-TIER AUTO PLAY SYSTEM v1.2             ")
    print("═══════════════════════════════════════════════════")
    print("📦 Modules Status:")
    print("  ClientEnemyHandler:", Modules.ClientEnemyHandler and "✅ Loaded" or "❌ Not Found")
    print("  ClientUnitHandler:", Modules.ClientUnitHandler and "✅ Loaded" or "❌ Not Found")
    print("  PlayerYenHandler:", Modules.PlayerYenHandler and "✅ Loaded" or "❌ Not Found")
    print("  MultiplierHandler:", Modules.MultiplierHandler and "✅ Loaded" or "❌ Not Found")
    print("  UnitsHUD:", Modules.UnitsHUD and "✅ Loaded" or "❌ Not Found")
    print("")
    print("📡 Remotes Status:")
    print("  UnitEvent:", Remotes.UnitEvent and "✅ Found" or "❌ Not Found")
    print("  GameEvent:", Remotes.GameEvent and "✅ Found" or "❌ Not Found")
    print("  AbilityEvent:", Remotes.AbilityEvent and "✅ Found" or "❌ Not Found")
    print("  SkipWaveEvent:", Remotes.SkipWaveEvent and "✅ Found" or "❌ Not Found")
    
    -- Test data access
    print("")
    print("📊 Data Test:")
    local testUnits = GetActiveUnits()
    local testEnemies = GetActiveEnemies()
    local testYen = GetYen()
    local unitCount, enemyCount = 0, 0
    for _ in pairs(testUnits) do unitCount = unitCount + 1 end
    for _ in pairs(testEnemies) do enemyCount = enemyCount + 1 end
    print("  Units in game:", unitCount)
    print("  Enemies in game:", enemyCount)
    print("  Current Yen:", testYen)
    print("═══════════════════════════════════════════════════")
    
    -- Status update interval
    local lastStatusPrint = 0
    
    -- Main loop
    RunService.Heartbeat:Connect(function(deltaTime)
        if not GlobalState.IsMatchEnded then
            local success, err = pcall(function()
                self:Heartbeat()
            end)
            
            if not success and CONFIG.DEBUG_MODE then
                warn("[GodTier] Heartbeat error:", err)
            end
            
            -- Print status every 10 seconds when in debug mode
            if CONFIG.DEBUG_MODE and (tick() - lastStatusPrint) > 10 then
                lastStatusPrint = tick()
                local enemyCount = 0
                local unitCount = 0
                for _ in pairs(GlobalState.Enemies) do enemyCount = enemyCount + 1 end
                for _ in pairs(GlobalState.Units) do unitCount = unitCount + 1 end
                
                print(string.format("[GodTier Status] Wave: %d/%d | Money: %d | Enemies: %d | Units: %d | Mode: %s",
                    GlobalState.CurrentWave, GlobalState.MaxWave,
                    GlobalState.Money, enemyCount, unitCount, GlobalState.Mode))
            end
        end
    end)
    
    print("")
    print("  🗺️ Volumetric Map Hashing: ✅")
    print("  🔮 Temporal Prediction: ✅")
    print("  💸 ROI Economy Manager: ✅")
    print("  ⚔️ Combat Orchestrator: ✅")
    print("  🛡️ Guardian Protocol: ✅")
    print("  📡 Packet Injection: ✅")
    print("═══════════════════════════════════════════════════")
    print("    🎮 SYSTEM ACTIVATED! Running on Heartbeat...  ")
    print("═══════════════════════════════════════════════════")
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🚀 INITIALIZE
--═══════════════════════════════════════════════════════════════════════════════

-- Simple Auto Upgrade Loop - ใช้ ClientUnitHandler._ActiveUnits (เหมือน AV_System)
local function SimpleAutoUpgrade()
    print("[SimpleAutoUpgrade] Starting...")
    
    while true do
        task.wait(0.5)
        
        local success, err = pcall(function()
            local money = GetYen()
            if money <= 0 then return end
            
            -- Method 1: ใช้ ClientUnitHandler._ActiveUnits (ถ้ามี)
            if Modules.ClientUnitHandler and Modules.ClientUnitHandler._ActiveUnits then
                for unitGUID, unitData in pairs(Modules.ClientUnitHandler._ActiveUnits) do
                    if unitData.Player == LocalPlayer then
                        -- Check if can upgrade
                        local currentLevel = unitData.Data and unitData.Data.CurrentUpgrade or 1
                        local upgrades = unitData.Data and unitData.Data.Upgrades
                        
                        if upgrades and currentLevel < #upgrades then
                            local nextUpgrade = upgrades[currentLevel + 1]
                            local cost = nextUpgrade and nextUpgrade.Cost or 0
                            
                            if cost > 0 and money >= cost then
                                PacketSystem:UpgradeUnit(unitGUID)
                                
                                if CONFIG.VERBOSE_LOG then
                                    print(string.format("[SimpleUpgrade] Upgraded %s (Lv%d->%d) for $%d", 
                                        unitData.Name or "Unit", currentLevel, currentLevel+1, cost))
                                end
                                
                                task.wait(0.15)
                                return -- One upgrade per cycle
                            end
                        end
                    end
                end
            else
                -- Fallback: หา Units จาก workspace โดยตรง
                local unitsFolder = workspace:FindFirstChild("Units")
                if not unitsFolder then return end
                
                for _, unitModel in pairs(unitsFolder:GetChildren()) do
                    if unitModel:IsA("Model") then
                        local unitGUID = unitModel.Name
                        
                        if money > 100 then
                            PacketSystem:UpgradeUnit(unitGUID)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end)
        
        if not success and CONFIG.VERBOSE_LOG then
            warn("[SimpleAutoUpgrade] Error:", err)
        end
    end
end

-- Auto Skip Wave
local function AutoSkipWave()
    print("[AutoSkipWave] Starting...")
    
    while true do
        task.wait(2) -- ทุก 2 วินาที
        
        pcall(function()
            if Remotes.SkipWaveEvent then
                Remotes.SkipWaveEvent:FireServer("Skip")
            end
        end)
    end
end

-- Auto Place Units
local PlacedPositions = {}
local PlacedCount = {}

local function FindPlaceablePosition()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    
    local placements = map:FindFirstChild("UnitPlacements") 
        or map:FindFirstChild("Placements")
        or map:FindFirstChild("PlacementArea")
    
    if placements then
        for _, part in pairs(placements:GetDescendants()) do
            if part:IsA("BasePart") then
                local pos = part.Position + Vector3.new(0, 1, 0)
                
                -- Check if not already used
                local tooClose = false
                for _, usedPos in ipairs(PlacedPositions) do
                    if (pos - usedPos).Magnitude < 3 then
                        tooClose = true
                        break
                    end
                end
                
                if not tooClose then
                    return pos
                end
            end
        end
    end
    
    return nil
end

local function AutoPlaceUnits()
    print("[AutoPlace] Starting...")
    
    while true do
        task.wait(1)
        
        pcall(function()
            -- Get equipped units from HUD
            if not Modules.UnitsHUD then 
                print("[AutoPlace] UnitsHUD not loaded")
                return 
            end
            
            if not Modules.UnitsHUD._Cache then 
                print("[AutoPlace] _Cache not found")
                return 
            end
            
            local money = GetYen()
            print(string.format("[AutoPlace] Money: %d¥", money))
            
            if money < 50 then 
                print("[AutoPlace] Not enough money")
                return 
            end
            
            -- Count equipped units
            local equippedCount = 0
            for slot, data in pairs(Modules.UnitsHUD._Cache) do
                if data and data ~= "None" and type(data) == "table" then
                    equippedCount = equippedCount + 1
                end
            end
            print(string.format("[AutoPlace] Equipped units: %d", equippedCount))
            
            for slot, data in pairs(Modules.UnitsHUD._Cache) do
                if data and data ~= "None" and type(data) == "table" then
                    local unitData = data.Data or data
                    local unitName = unitData.Name or data.Name or "Unknown"
                    local unitID = unitData.ID or unitData.Identifier or slot
                    local unitCost = unitData.Cost or unitData.Price or 0
                    
                    local count = PlacedCount[unitName] or 0
                    
                    print(string.format("[AutoPlace] Checking %s: Cost=%d, Placed=%d/5", unitName, unitCost, count))
                    
                    -- Check conditions
                    if count < 5 and money >= unitCost then
                        local position = FindPlaceablePosition()
                        
                        if position then
                            print(string.format("[AutoPlace] Placing %s at %s", unitName, tostring(position)))
                            
                            local unitsBefore = 0
                            for _ in pairs(GetActiveUnits()) do unitsBefore = unitsBefore + 1 end
                            
                            pcall(function()
                                Remotes.UnitEvent:FireServer("Render", {
                                    unitName,
                                    unitID,
                                    position,
                                    0
                                })
                            end)
                            
                            task.wait(0.5)
                            
                            local unitsAfter = 0
                            for _ in pairs(GetActiveUnits()) do unitsAfter = unitsAfter + 1 end
                            
                            if unitsAfter > unitsBefore then
                                table.insert(PlacedPositions, position)
                                PlacedCount[unitName] = count + 1
                                print(string.format("✅ Placed %s (%d/5)", unitName, PlacedCount[unitName]))
                                break
                            else
                                print(string.format("⚠️ Failed to place %s (Units: %d -> %d)", unitName, unitsBefore, unitsAfter))
                            end
                        else
                            print("[AutoPlace] No valid position found")
                        end
                    end
                end
            end
        end)
    end
end

-- Auto Use Ability (กดสกิลอัตโนมัติ)
local function AutoUseAbility()
    print("[AutoUseAbility] Starting...")
    
    while true do
        task.wait(1)
        
        pcall(function()
            local unitsFolder = workspace:FindFirstChild("Units")
            if not unitsFolder then return end
            
            for _, unitModel in pairs(unitsFolder:GetChildren()) do
                if unitModel:IsA("Model") then
                    local unitGUID = unitModel.Name
                    -- ลองกดสกิลต่างๆ (server จะ validate)
                    if Remotes.AbilityEvent then
                        Remotes.AbilityEvent:FireServer("Activate", unitGUID)
                    end
                end
            end
        end)
    end
end

task.spawn(function()
    -- Wait for game to fully load
    task.wait(3)
    
    print("[GodTier] Starting all systems...")
    
    -- Start MasterController (complex logic)
    pcall(function()
        MasterController:Start()
    end)
    
    -- Start Simple Systems (these should work regardless of modules)
    task.spawn(SimpleAutoUpgrade)
    task.spawn(AutoSkipWave)
    task.spawn(AutoPlaceUnits)
    task.spawn(AutoUseAbility)
    
    print("[GodTier] All background tasks started!")
end)

-- Export for external access
return {
    GlobalState = GlobalState,
    Config = CONFIG,
    PacketSystem = PacketSystem,
    VoxelSystem = VoxelSystem,
    PredictionEngine = PredictionEngine,
    EconomyManager = EconomyManager,
    CombatOrchestrator = CombatOrchestrator,
    GuardianProtocol = GuardianProtocol,
    MasterController = MasterController,
    
    -- Helper functions for external use
    GetActiveUnits = GetActiveUnits,
    GetActiveEnemies = GetActiveEnemies,
    GetYen = GetYen,
    Remotes = Remotes,
}
