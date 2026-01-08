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

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
    DEBUG_MODE = false,
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
-- 🔌 MODULE LOADER
--═══════════════════════════════════════════════════════════════════════════════
local Modules = {}

local function SafeRequire(path)
    local success, result = pcall(function()
        return require(path)
    end)
    if success then
        return result
    else
        if CONFIG.DEBUG_MODE then
            warn("[SafeRequire] Failed to load:", path, result)
        end
        return nil
    end
end

-- Load Game Modules
pcall(function()
    Modules.ClientEnemyHandler = SafeRequire(StarterPlayer.Modules.Gameplay.ClientEnemyHandler)
    Modules.ClientUnitHandler = SafeRequire(StarterPlayer.Modules.Gameplay.ClientUnitHandler)
    Modules.MultiplierHandler = SafeRequire(ReplicatedStorage.Modules.Shared.MultiplierHandler)
    Modules.PriorityHandler = SafeRequire(ReplicatedStorage.Modules.Gameplay.Units.PriorityHandler)
    Modules.GameHandler = SafeRequire(StarterPlayer.Modules.Gameplay.GameHandler)
end)

--═══════════════════════════════════════════════════════════════════════════════
-- 📡 SECTION 6: DIRECT PACKET INJECTION
--═══════════════════════════════════════════════════════════════════════════════
local PacketSystem = {}

function PacketSystem:Init()
    self.Remotes = {}
    self.LastPingCheck = tick()
    self.PingHistory = {}
    
    -- Find Remote Events
    pcall(function()
        local networking = ReplicatedStorage:FindFirstChild("Networking")
        if networking then
            for _, child in pairs(networking:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    self.Remotes[child.Name] = child
                end
            end
        end
    end)
    
    -- Ping Measurement Loop
    task.spawn(function()
        while true do
            self:MeasurePing()
            task.wait(1)
        end
    end)
end

function PacketSystem:MeasurePing()
    local start = tick()
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

function PacketSystem:Fire(remoteName, ...)
    local remote = self.Remotes[remoteName]
    if remote then
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
            return true
        elseif remote:IsA("RemoteFunction") then
            return remote:InvokeServer(...)
        end
    end
    return false
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

-- หา Farm Units ทั้งหมดในสนาม
function EconomyManager:FindFarmUnits(units)
    self.FarmUnits = {}
    
    for unitId, unit in pairs(units) do
        if unit.Data then
            -- Check for Economy tag
            local isEconomy = unit.Data.Tags and table.find(unit.Data.Tags, "Economy")
            -- Check for income generation
            local hasIncome = unit.Data.Upgrades and self:GetUpgradeIncome(unit) > 0
            
            if isEconomy or hasIncome then
                table.insert(self.FarmUnits, {
                    Id = unitId,
                    Unit = unit,
                    CurrentLevel = unit.Data.CurrentUpgrade or 1,
                    MaxLevel = unit.Data.Upgrades and #unit.Data.Upgrades or 1,
                })
            end
        end
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

-- หา Unit ที่มี Buff/Debuff
function CombatOrchestrator:CategorizeUnits(units)
    self.BuffUnits = {}
    self.DebuffUnits = {}
    
    for unitId, unit in pairs(units) do
        if unit.Data and unit.Data.Tags then
            if table.find(unit.Data.Tags, "Buffer") or table.find(unit.Data.Tags, "Support") then
                table.insert(self.BuffUnits, {Id = unitId, Unit = unit})
            end
            if table.find(unit.Data.Tags, "Slow") or table.find(unit.Data.Tags, "Burn") or 
               table.find(unit.Data.Tags, "Debuffer") then
                table.insert(self.DebuffUnits, {Id = unitId, Unit = unit})
            end
        end
    end
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
    
    -- Update Money
    pcall(function()
        if Modules.GameHandler then
            local gameData = Modules.GameHandler:GetGameData()
            GlobalState.Money = gameData.Money or 0
        end
    end)
    
    -- Update Enemies
    pcall(function()
        if Modules.ClientEnemyHandler then
            GlobalState.Enemies = Modules.ClientEnemyHandler._ActiveEnemies or {}
        end
    end)
    
    -- Update Units
    pcall(function()
        if Modules.ClientUnitHandler then
            GlobalState.Units = Modules.ClientUnitHandler._Units or {}
        end
    end)
    
    -- Update enemy velocities for prediction
    for enemyId, enemy in pairs(GlobalState.Enemies) do
        if enemy.Position then
            PredictionEngine:UpdateVelocity(enemyId, enemy.Position)
        end
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
    local success = PacketSystem:Fire("Upgrade", target.Id)
    
    if CONFIG.DEBUG_MODE then
        print(string.format("[GodTier] Upgrading unit %s for %d (ROI: %.2f)", 
            target.Id, cost, EconomyManager:CalculateROI(target.Unit)))
    end
end

-- Execute Buff Sync
function MasterController:ExecuteBuffSync(syncData)
    -- Activate all buffs first
    for _, buffData in pairs(syncData.Buffs) do
        PacketSystem:Fire("Skill", buffData.Id)
        CombatOrchestrator.SkillCooldowns[buffData.Id] = tick() + 10 -- Assume 10s CD
    end
    
    -- Then activate DPS skills
    for _, dpsData in pairs(syncData.DPS) do
        PacketSystem:Fire("Skill", dpsData.Id)
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
        PacketSystem:Fire("Priority", "First") -- Force First priority
        
    elseif action.Type == "SELL" then
        PacketSystem:Fire("Sell", action.Target.Id)
        
    elseif action.Type == "SUICIDE_SQUAD" then
        -- Spam place units at position
        -- TODO: Implement unit placement
        if CONFIG.DEBUG_MODE then
            print("[GodTier] SUICIDE SQUAD activated at", action.Position)
        end
    end
end

-- Update Targeting
function MasterController:UpdateTargeting(priority)
    PacketSystem:Fire("Priority", priority)
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
            local voteSkip = hud:FindFirstChild("VoteSkip")
            if voteSkip and voteSkip.Visible then
                PacketSystem:Fire("VoteSkip")
            end
        end
    end)
end

-- Match End Handler
function MasterController:OnMatchEnd()
    if CONFIG.DEBUG_MODE then
        print("[GodTier] Match ended. Attempting replay...")
    end
    
    -- Fire replay event
    PacketSystem:Fire("Replay")
end

-- Start the system
function MasterController:Start()
    self:Init()
    
    -- Main loop
    RunService.Heartbeat:Connect(function(deltaTime)
        if not GlobalState.IsMatchEnded then
            local success, err = pcall(function()
                self:Heartbeat()
            end)
            
            if not success and CONFIG.DEBUG_MODE then
                warn("[GodTier] Heartbeat error:", err)
            end
        end
    end)
    
    print("═══════════════════════════════════════════════════")
    print("    🎮 GOD-TIER AUTO PLAY SYSTEM ACTIVATED! 🎮    ")
    print("═══════════════════════════════════════════════════")
    print("  🗺️ Volumetric Map Hashing: ✅")
    print("  🔮 Temporal Prediction: ✅")
    print("  💸 ROI Economy Manager: ✅")
    print("  ⚔️ Combat Orchestrator: ✅")
    print("  🛡️ Guardian Protocol: ✅")
    print("  📡 Packet Injection: ✅")
    print("═══════════════════════════════════════════════════")
end

--═══════════════════════════════════════════════════════════════════════════════
-- 🚀 INITIALIZE
--═══════════════════════════════════════════════════════════════════════════════
task.spawn(function()
    -- Wait for game to fully load
    task.wait(2)
    MasterController:Start()
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
}
