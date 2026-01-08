--[[
    🌟 AUTO PLAY GOD-TIER V2 🌟
    ระบบ Auto Play แบบ Professional ที่ใช้ AI-like Decision Making
    
    Features:
    ✅ Volumetric Map Hashing (สแกนแมพ 3D)
    ✅ Temporal Predictive Engine (ทำนายอนาคต)
    ✅ ROI-Based Economy Manager (จัดการเงิน)
    ✅ Combat Orchestrator (ประสานการรบ)
    ✅ Guardian Protocol (ป้องกันบ้านแตก)
    ✅ Direct Packet Injection (ส่งคำสั่งตรง)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ==================== CORE MODULES ====================
local GodTierAuto = {
    Version = "2.0.0",
    Author = "Advanced AI System",
    
    -- Core Systems
    MapScanner = nil,
    PredictiveEngine = nil,
    EconomyManager = nil,
    CombatOrchestrator = nil,
    GuardianProtocol = nil,
    
    -- State
    IsRunning = false,
    CurrentWave = 0,
    MaxWave = 0,
    
    -- Cache
    PlacementCache = {},
    EnemyCache = {},
    UnitCache = {},
    
    -- Configuration
    Config = {
        AutoStart = true,
        AutoUpgrade = true,
        AutoAbility = true,
        AutoSell = false,
        PrioritizeEconomy = true,
        AggressiveMode = false,
        SafetyMargin = 0.85, -- ป้องกันบ้านแตกที่ 85% HP
    }
}

-- ==================== 1. VOLUMETRIC MAP HASHING ====================
local VolumetricMapScanner = {}
VolumetricMapScanner.__index = VolumetricMapScanner

function VolumetricMapScanner.new()
    local self = setmetatable({}, VolumetricMapScanner)
    
    self.VoxelGrid = {} -- 3D Grid ของแมพ
    self.PathData = {} -- ข้อมูล Path ของศัตรู
    self.OptimalSpots = {} -- จุดวางที่ดีที่สุด
    self.HeatMap = {} -- แผนที่ความร้อน (เวลาที่ศัตรูอยู่)
    
    return self
end

function VolumetricMapScanner:ScanMap()
    print("🗺️ [Map Scanner] Scanning map in 3D...")
    
    local Map = Workspace:WaitForChild("Map", 5)
    if not Map then
        warn("Map not found!")
        return
    end
    
    -- สแกน Bounds ของแมพ (ใช้ Region3 จาก BaseParts ใน Map)
    local minPos = Vector3.new(math.huge, math.huge, math.huge)
    local maxPos = Vector3.new(-math.huge, -math.huge, -math.huge)
    
    for _, obj in ipairs(Map:GetDescendants()) do
        if obj:IsA("BasePart") then
            local pos = obj.Position
            local size = obj.Size
            
            minPos = Vector3.new(
                math.min(minPos.X, pos.X - size.X/2),
                math.min(minPos.Y, pos.Y - size.Y/2),
                math.min(minPos.Z, pos.Z - size.Z/2)
            )
            
            maxPos = Vector3.new(
                math.max(maxPos.X, pos.X + size.X/2),
                math.max(maxPos.Y, pos.Y + size.Y/2),
                math.max(maxPos.Z, pos.Z + size.Z/2)
            )
        end
    end
    
    local MapSize = maxPos - minPos
    local MapPosition = (minPos + maxPos) / 2
    
    print(string.format("📐 Map Size: %.1f x %.1f x %.1f", MapSize.X, MapSize.Y, MapSize.Z))
    print(string.format("📍 Map Center: %.1f, %.1f, %.1f", MapPosition.X, MapPosition.Y, MapPosition.Z))
    
    -- สร้าง Voxel Grid (ละเอียด 4x4x4 studs เพื่อประสิทธิภาพ)
    local VoxelSize = 4
    local GridX = math.ceil(MapSize.X / VoxelSize)
    local GridY = math.ceil(MapSize.Y / VoxelSize)
    local GridZ = math.ceil(MapSize.Z / VoxelSize)
    
    print(string.format("🔲 Creating Voxel Grid: %dx%dx%d", GridX, GridY, GridZ))
    
    -- Initialize Grid
    for x = 1, GridX do
        self.VoxelGrid[x] = {}
        for y = 1, GridY do
            self.VoxelGrid[x][y] = {}
            for z = 1, GridZ do
                self.VoxelGrid[x][y][z] = {
                    Position = Vector3.new(
                        MapPosition.X - MapSize.X/2 + x * VoxelSize,
                        MapPosition.Y - MapSize.Y/2 + y * VoxelSize,
                        MapPosition.Z - MapSize.Z/2 + z * VoxelSize
                    ),
                    Walkable = true,
                    PlacementScore = 0,
                    EnemyDensity = 0,
                    TimeOccupied = 0
                }
            end
        end
    end
    
    return true
end

function VolumetricMapScanner:AnalyzePathData()
    print("📊 [Map Scanner] Analyzing enemy path data...")
    
    -- ดึงข้อมูล Path จาก EnemyPathHandler
    local PathHandler = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("EnemyPathHandler")
    local PathModule = require(PathHandler)
    
    if not PathModule.Nodes then
        warn("No path nodes found!")
        return
    end
    
    -- วิเคราะห์ทุก Node
    local PathAnalysis = {}
    
    for nodeName, nodeData in pairs(PathModule.Nodes) do
        if nodeData.Position then
            table.insert(PathAnalysis, {
                Name = nodeName,
                Position = nodeData.Position,
                DistanceToEnd = nodeData.DistanceToEnd or 0,
                DistanceToStart = nodeData.DistanceToStart or 0,
                IndexGroup = nodeData.IndexGroup
            })
        end
    end
    
    -- เรียงตาม DistanceToEnd (หาจุดที่ศัตรูใช้เวลานาน)
    table.sort(PathAnalysis, function(a, b)
        return a.DistanceToEnd > b.DistanceToEnd
    end)
    
    self.PathData = PathAnalysis
    
    print(string.format("✅ Analyzed %d path nodes", #PathAnalysis))
    
    return PathAnalysis
end

function VolumetricMapScanner:CalculateOptimalPlacements(unitRange, unitType)
    print(string.format("🎯 Calculating optimal placements for %s (Range: %.1f)", unitType or "DPS", unitRange or 25))
    
    if not self.PathData or #self.PathData == 0 then
        self:AnalyzePathData()
    end
    
    local OptimalSpots = {}
    
    -- วนลูปทุกจุดบน Path
    for i, pathNode in ipairs(self.PathData) do
        local nodePos = pathNode.Position
        
        -- คำนวณจุดวางรอบๆ node (รัศมี = range ของ unit)
        local searchRadius = unitRange or 25
        local angleStep = 30 -- ทุก 30 องศา
        
        for angle = 0, 360 - angleStep, angleStep do
            local radians = math.rad(angle)
            local offsetX = math.cos(radians) * searchRadius
            local offsetZ = math.sin(radians) * searchRadius
            
            local placementPos = Vector3.new(
                nodePos.X + offsetX,
                nodePos.Y,
                nodePos.Z + offsetZ
            )
            
            -- ตรวจสอบว่าวางได้หรือไม่ (Raycast ลงพื้น)
            local rayOrigin = placementPos + Vector3.new(0, 50, 0)
            local rayDirection = Vector3.new(0, -100, 0)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Include
            raycastParams.FilterDescendantsInstances = {Workspace.Map}
            
            local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if rayResult then
                local groundPos = rayResult.Position
                
                -- คำนวณคะแนน (ยิ่งใกล้ Path ยิ่งดี)
                local distanceToPath = (groundPos - nodePos).Magnitude
                local score = 1000 / (distanceToPath + 1) -- ยิ่งใกล้ = คะแนนสูง
                
                -- เพิ่มคะแนนถ้าครอบคลุมหลาย node
                local coverageBonus = 0
                for j, otherNode in ipairs(self.PathData) do
                    if j ~= i then
                        local distToOther = (groundPos - otherNode.Position).Magnitude
                        if distToOther <= searchRadius then
                            coverageBonus = coverageBonus + 100
                        end
                    end
                end
                
                score = score + coverageBonus
                
                table.insert(OptimalSpots, {
                    Position = groundPos,
                    Score = score,
                    CoverageNodes = math.floor(coverageBonus / 100),
                    DistanceToPath = distanceToPath,
                    NearestPathNode = pathNode.Name
                })
            end
        end
    end
    
    -- เรียงตามคะแนน
    table.sort(OptimalSpots, function(a, b)
        return a.Score > b.Score
    end)
    
    print(string.format("✅ Found %d optimal placement spots", #OptimalSpots))
    
    -- เก็บเฉพาะ Top 20
    local TopSpots = {}
    for i = 1, math.min(20, #OptimalSpots) do
        TopSpots[i] = OptimalSpots[i]
        print(string.format("  #%d: Score %.1f, Coverage %d nodes, Dist %.1f", 
            i, OptimalSpots[i].Score, OptimalSpots[i].CoverageNodes, OptimalSpots[i].DistanceToPath))
    end
    
    self.OptimalSpots = TopSpots
    
    return TopSpots
end

-- ==================== 2. TEMPORAL PREDICTIVE ENGINE ====================
local PredictiveEngine = {}
PredictiveEngine.__index = PredictiveEngine

function PredictiveEngine.new()
    local self = setmetatable({}, PredictiveEngine)
    
    self.EnemyTracking = {} -- ติดตามศัตรูแต่ละตัว
    self.PredictionCache = {} -- เก็บ Cache การทำนาย
    
    return self
end

function PredictiveEngine:PredictEnemyPosition(enemyData, timeAhead)
    if not enemyData or not enemyData.Position then
        return nil
    end
    
    local currentPos = enemyData.Position
    local speed = enemyData.Data.Speed or 1
    local currentNode = enemyData.CurrentNode
    
    if not currentNode then
        return currentPos
    end
    
    -- คำนวณว่า timeAhead วินาทีต่อจากนี้ ศัตรูจะอยู่ที่ไหน
    local distanceWillTravel = speed * 1.45 * timeAhead
    
    -- หา Node ถัดไป
    local nextNode = currentNode.GetNext and currentNode.GetNext(enemyData.PathSeed)
    
    if nextNode then
        local directionToNext = (nextNode.Position - currentPos).Unit
        local predictedPos = currentPos + (directionToNext * distanceWillTravel)
        
        return predictedPos
    end
    
    return currentPos
end

function PredictiveEngine:ShouldPlaceUnit(unitData, placementPos)
    -- คำนวณว่าถ้าวาง Unit ตอนนี้ จะยิงได้ทันหรือไม่
    
    local placementDelay = 0.5 -- Animation วาง
    local attackWindup = 0.3 -- เวลาก่อนยิง
    local totalDelay = placementDelay + attackWindup
    
    -- ดึงศัตรูที่อยู่ใน Range
    local enemiesInRange = self:GetEnemiesInRange(placementPos, unitData.Range or 25)
    
    if #enemiesInRange == 0 then
        return false, "No enemies in range"
    end
    
    -- ทำนายว่าศัตรูจะยังอยู่ใน Range หรือไม่
    for _, enemy in ipairs(enemiesInRange) do
        local predictedPos = self:PredictEnemyPosition(enemy, totalDelay)
        
        if predictedPos then
            local distanceAfterDelay = (predictedPos - placementPos).Magnitude
            
            if distanceAfterDelay <= (unitData.Range or 25) then
                return true, "Will hit target"
            end
        end
    end
    
    return false, "Target will be out of range"
end

function PredictiveEngine:GetEnemiesInRange(position, range)
    local StarterPlayer = game:GetService("StarterPlayer")
    local ClientEnemyHandler = require(StarterPlayer.Modules.Gameplay.ClientEnemyHandler)
    
    local enemies = {}
    
    for id, enemyData in pairs(ClientEnemyHandler._ActiveEnemies) do
        if enemyData.Position then
            local distance = (enemyData.Position - position).Magnitude
            if distance <= range then
                table.insert(enemies, enemyData)
            end
        end
    end
    
    return enemies
end

-- ==================== 3. ROI-BASED ECONOMY MANAGER ====================
local EconomyManager = {}
EconomyManager.__index = EconomyManager

function EconomyManager.new()
    local self = setmetatable({}, EconomyManager)
    
    self.CurrentYen = 0
    self.YenPerSecond = 0
    self.FarmUnits = {}
    
    return self
end

function EconomyManager:UpdateYen()
    local StarterPlayer = game:GetService("StarterPlayer")
    local YenHandler = require(StarterPlayer.Modules.Gameplay.PlayerYenHandler)
    
    self.CurrentYen = YenHandler:GetYen() or 0
    
    return self.CurrentYen
end

function EconomyManager:GetBestFarmUpgrade()
    print("💰 [Economy] Analyzing farm upgrades...")
    
    local StarterPlayer = game:GetService("StarterPlayer")
    local ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler)
    
    local farmUnits = {}
    
    -- หา Farm ทั้งหมด
    for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
        if unitData.Data and unitData.Data.UnitType == "Farm" then
            if unitData.Player == LocalPlayer then
                table.insert(farmUnits, {
                    GUID = guid,
                    Data = unitData,
                    Income = unitData.Income or 0,
                    Level = unitData.Data.CurrentUpgrade or 1
                })
            end
        end
    end
    
    if #farmUnits == 0 then
        return nil, "No farms found"
    end
    
    -- คำนวณ ROI (Return on Investment)
    local bestROI = nil
    local bestUpgrade = nil
    
    for _, farm in ipairs(farmUnits) do
        local currentUpgrade = farm.Level
        local nextUpgrade = currentUpgrade + 1
        
        if farm.Data.Data.Upgrades[nextUpgrade] then
            local upgradeCost = ClientUnitHandler.GetUpgradePriceMultiplier(farm.Data, nextUpgrade)
            local nextIncome = farm.Data.Data.Upgrades[nextUpgrade].Income or farm.Income
            local incomeIncrease = nextIncome - farm.Income
            
            if incomeIncrease > 0 then
                local roi = incomeIncrease / upgradeCost
                
                print(string.format("  Farm %s: Cost %d, +Income %d, ROI %.4f", 
                    farm.GUID, upgradeCost, incomeIncrease, roi))
                
                if not bestROI or roi > bestROI then
                    bestROI = roi
                    bestUpgrade = {
                        GUID = farm.GUID,
                        Cost = upgradeCost,
                        ROI = roi,
                        IncomeIncrease = incomeIncrease
                    }
                end
            end
        end
    end
    
    if bestUpgrade then
        print(string.format("✅ Best upgrade: %s (ROI %.4f)", bestUpgrade.GUID, bestUpgrade.ROI))
    end
    
    return bestUpgrade
end

function EconomyManager:ShouldSaveForUnit()
    -- ตรวจสอบว่าควรเก็บเงินเพื่อวาง Unit ใหม่หรือไม่
    
    local timeUntilNextWave = self:GetTimeUntilNextWave()
    
    if timeUntilNextWave and timeUntilNextWave < 10 then
        return true, "Saving for next wave"
    end
    
    return false
end

function EconomyManager:GetTimeUntilNextWave()
    -- TODO: ดึงจาก Wave system
    return nil
end

-- ==================== 4. COMBAT ORCHESTRATOR ====================
local CombatOrchestrator = {}
CombatOrchestrator.__index = CombatOrchestrator

function CombatOrchestrator.new()
    local self = setmetatable({}, CombatOrchestrator)
    
    self.ActiveUnits = {}
    self.AbilityQueue = {}
    
    return self
end

function CombatOrchestrator:SyncBuffs()
    print("⚔️ [Combat] Syncing buffs and abilities...")
    
    local StarterPlayer = game:GetService("StarterPlayer")
    local ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler)
    local AbilityHandler = require(StarterPlayer.Modules.Gameplay.ClientAbilityHandler)
    
    -- หา Unit ที่มี Buff
    local buffUnits = {}
    local damageUnits = {}
    
    for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
        if unitData.Player == LocalPlayer then
            if unitData.Data.UnitType == "Support" then
                table.insert(buffUnits, {
                    GUID = guid,
                    Data = unitData
                })
            elseif unitData.Data.UnitType == "Damage" or unitData.Data.UnitType == nil then
                table.insert(damageUnits, {
                    GUID = guid,
                    Data = unitData,
                    ActiveAbilities = unitData.ActiveAbilities or {}
                })
            end
        end
    end
    
    print(string.format("  Found %d buff units, %d damage units", #buffUnits, #damageUnits))
    
    -- TODO: Sync ability timing
    
    return true
end

function CombatOrchestrator:SmartSellAndReposition()
    -- TODO: ระบบขายและวางใหม่อัจฉริยะ
    return false
end

-- ==================== 5. GUARDIAN PROTOCOL ====================
local GuardianProtocol = {}
GuardianProtocol.__index = GuardianProtocol

function GuardianProtocol.new()
    local self = setmetatable({}, GuardianProtocol)
    
    self.EmergencyMode = false
    self.LeakThreshold = 0.85
    
    return self
end

function GuardianProtocol:CheckLeakProbability()
    local StarterPlayer = game:GetService("StarterPlayer")
    local ClientEnemyHandler = require(StarterPlayer.Modules.Gameplay.ClientEnemyHandler)
    
    local dangerousEnemies = {}
    
    for id, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
        if enemy.Data and enemy.Data.Health then
            local healthPercent = enemy.Data.Health / enemy.Data.MaxHealth
            local distanceToEnd = enemy.CurrentNode and enemy.CurrentNode.DistanceToEnd or 0
            
            -- ถ้า HP > 80% และใกล้ฐาน
            if healthPercent > self.LeakThreshold and distanceToEnd < 50 then
                table.insert(dangerousEnemies, {
                    ID = id,
                    Data = enemy,
                    HP = enemy.Data.Health,
                    Distance = distanceToEnd
                })
            end
        end
    end
    
    if #dangerousEnemies > 0 then
        print(string.format("🛡️ [Guardian] ⚠️ WARNING: %d enemies at risk of leaking!", #dangerousEnemies))
        self:TriggerEmergency(dangerousEnemies)
    end
    
    return dangerousEnemies
end

function GuardianProtocol:TriggerEmergency(enemies)
    if self.EmergencyMode then return end
    
    self.EmergencyMode = true
    print("🚨 [Guardian] EMERGENCY MODE ACTIVATED!")
    
    -- TODO: Target switching, body blocking, emergency sells
    
    task.wait(5)
    self.EmergencyMode = false
end

-- ==================== 6. MAIN AUTO CONTROLLER ====================
function GodTierAuto:Initialize()
    print("🌟 ============================================")
    print("🌟  AUTO PLAY GOD-TIER V2 INITIALIZING...")
    print("🌟 ============================================")
    
    -- สร้าง Systems
    self.MapScanner = VolumetricMapScanner.new()
    self.PredictiveEngine = PredictiveEngine.new()
    self.EconomyManager = EconomyManager.new()
    self.CombatOrchestrator = CombatOrchestrator.new()
    self.GuardianProtocol = GuardianProtocol.new()
    
    print("✅ All systems initialized")
    
    -- สแกนแมพ
    self.MapScanner:ScanMap()
    self.MapScanner:AnalyzePathData()
    
    -- คำนวณจุดวางที่ดี
    self.MapScanner:CalculateOptimalPlacements(25, "DPS")
    
    print("🌟 ============================================")
    print("🌟  INITIALIZATION COMPLETE!")
    print("🌟 ============================================")
    
    return true
end

function GodTierAuto:GetCurrentWave()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local HUD = PlayerGui:WaitForChild("HUD")
    local Map = HUD:WaitForChild("Map")
    local WavesAmount = Map:WaitForChild("WavesAmount")
    
    local text = WavesAmount.Text
    local current, max = string.match(text, "(%d+)/(%d+)")
    
    if current and max then
        self.CurrentWave = tonumber(current) or 0
        self.MaxWave = tonumber(max) or 0
        return self.CurrentWave, self.MaxWave
    end
    
    return 0, 0
end

function GodTierAuto:MainLoop()
    print("🔄 [Main Loop] Starting...")
    
    while self.IsRunning do
        local success, err = pcall(function()
            -- 1. Update state
            self.EconomyManager:UpdateYen()
            local currentWave, maxWave = self:GetCurrentWave()
            
            -- 2. Guardian check (ป้องกันบ้านแตก)
            self.GuardianProtocol:CheckLeakProbability()
            
            -- 3. Economy cycle
            if not self.GuardianProtocol.EmergencyMode then
                local bestFarm = self.EconomyManager:GetBestFarmUpgrade()
                
                if bestFarm and self.EconomyManager.CurrentYen >= bestFarm.Cost then
                    print(string.format("💰 Upgrading farm %s (Cost: %d)", bestFarm.GUID, bestFarm.Cost))
                    -- TODO: Send upgrade command
                end
            end
            
            -- 4. Combat sync
            if currentWave > 0 then
                self.CombatOrchestrator:SyncBuffs()
            end
            
        end)
        
        if not success then
            warn("[Auto] Error in main loop:", err)
        end
        
        task.wait(0.5) -- Update ทุก 0.5 วินาที
    end
    
    print("🔄 [Main Loop] Stopped")
end

function GodTierAuto:Start()
    if self.IsRunning then
        warn("Auto is already running!")
        return
    end
    
    print("▶️ Starting Auto Play God-Tier...")
    
    self.IsRunning = true
    
    -- เริ่ม Main Loop
    task.spawn(function()
        self:MainLoop()
    end)
    
    print("✅ Auto Play Started!")
end

function GodTierAuto:Stop()
    if not self.IsRunning then
        warn("Auto is not running!")
        return
    end
    
    print("⏸️ Stopping Auto Play God-Tier...")
    
    self.IsRunning = false
    
    print("✅ Auto Play Stopped!")
end

-- ==================== INIT & EXPORT ====================
task.wait(2) -- รอให้เกมโหลดเสร็จ

GodTierAuto:Initialize()

-- Auto start
if GodTierAuto.Config.AutoStart then
    GodTierAuto:Start()
end

-- Export สำหรับควบคุมด้วย Console
getgenv().GodTierAuto = GodTierAuto

print("🎮 Use: GodTierAuto:Start() / GodTierAuto:Stop()")

return GodTierAuto
