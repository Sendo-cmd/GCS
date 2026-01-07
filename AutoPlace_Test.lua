--[[
════════════════════════════════════════════════════════════════
    🏆 ULTIMATE AUTO PLACEMENT - STANDALONE VERSION
    Script เดียวจบ สำหรับทดสอบระบบ
    ไม่ต้องมี Integration Script
════════════════════════════════════════════════════════════════
--]]

-- ════════════════════════════════════════════════════════════════
--  ⚙️ CONFIGURATION
-- ════════════════════════════════════════════════════════════════

local Config = {
    -- Kill Zone Layers (% ของ path จาก EnemyBase)
    KILL_ZONES = {
        {name = "Spawn Kill", start = 0, finish = 0.15, weight = 10},
        {name = "Early Zone", start = 0.10, finish = 0.30, weight = 8},
        {name = "Mid Front", start = 0.25, finish = 0.45, weight = 6},
        {name = "Mid Back", start = 0.40, finish = 0.60, weight = 5},
        {name = "Late Defense", start = 0.55, finish = 0.75, weight = 7},
        {name = "Last Stand", start = 0.70, finish = 0.90, weight = 9}
    },
    
    CHOKE_ANGLE_THRESHOLD = 45,
    CHOKE_BONUS = 500,
    MIN_PATH_COVERAGE = 3,
    OVERLAP_BONUS = 300,
    MIN_DISTANCE_FROM_BASE = 8,
    GRID_SIZE = 3,
    
    DEBUG = true,
    PLACE_COOLDOWN = 3  -- วางทุก 3 วินาที
}

-- ════════════════════════════════════════════════════════════════
--  🎮 GAME SERVICES
-- ════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════
--  💾 GLOBAL STATE
-- ════════════════════════════════════════════════════════════════

local PlacedUnits = {}
local CurrentWave = 0
local MaxWave = 0

-- ════════════════════════════════════════════════════════════════
--  🔧 UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════

local function DebugPrint(...)
    if Config.DEBUG then
        print("[ULTIMATE]", ...)
    end
end

local function GetMap()
    -- ลองหาใน workspace ทุกแบบ
    local map = Workspace:FindFirstChild("Map")
    if not map then
        -- ลองหาใน game.Workspace
        map = game.Workspace:FindFirstChild("Map")
    end
    if not map then
        -- ลองหาแบบ case-insensitive
        for _, child in pairs(Workspace:GetChildren()) do
            if child.Name:lower():match("map") then
                map = child
                break
            end
        end
    end
    return map
end

local function GetPath()
    local map = GetMap()
    if not map then 
        warn("❌ Map not found in Workspace!")
        return nil 
    end
    
    -- ลองหา Path folder
    local pathFolder = map:FindFirstChild("Path") or map:FindFirstChild("path") or map:FindFirstChild("Paths")
    
    if not pathFolder then
        warn("❌ Path folder not found in Map!")
        -- ลองหา nodes โดยตรง
        local nodes = {}
        for _, child in pairs(map:GetChildren()) do
            if child:IsA("BasePart") and tonumber(child.Name) then
                table.insert(nodes, child)
            end
        end
        
        if #nodes > 0 then
            table.sort(nodes, function(a, b)
                return tonumber(a.Name) < tonumber(b.Name)
            end)
            return nodes
        end
        
        return nil
    end
    
    local nodes = {}
    for _, node in pairs(pathFolder:GetChildren()) do
        if node:IsA("BasePart") then
            table.insert(nodes, node)
        end
    end
    
    if #nodes == 0 then
        warn("❌ No path nodes found!")
        return nil
    end
    
    table.sort(nodes, function(a, b)
        local aNum = tonumber(a.Name)
        local bNum = tonumber(b.Name)
        if aNum and bNum then
            return aNum < bNum
        end
        return a.Name < b.Name
    end)
    
    DebugPrint(string.format("✅ Found %d path nodes", #nodes))
    return nodes
end

local function GetEnemyBase()
    local path = GetPath()
    if not path or #path == 0 then return nil end
    return path[1].Position
end

local function GetPlayerBase()
    local path = GetPath()
    if not path or #path == 0 then return nil end
    return path[#path].Position
end

local function UpdateWaveInfo()
    local success, result = pcall(function()
        local wavesUI = LocalPlayer.PlayerGui:FindFirstChild("HUD")
        if wavesUI then
            wavesUI = wavesUI:FindFirstChild("Map")
            if wavesUI then
                wavesUI = wavesUI:FindFirstChild("WavesAmount")
                if wavesUI and wavesUI:IsA("TextLabel") then
                    local text = wavesUI.Text:gsub("<[^>]+>", "")
                    local current, max = text:match("(%d+)%s*/%s*(%d+)")
                    if current and max then
                        CurrentWave = tonumber(current)
                        MaxWave = tonumber(max)
                        return true
                    end
                end
            end
        end
        return false
    end)
end

-- ════════════════════════════════════════════════════════════════
--  🎯 PATH ANALYSIS
-- ════════════════════════════════════════════════════════════════

local function CalculateAngle(p1, p2, p3)
    local v1 = (p1 - p2).Unit
    local v2 = (p3 - p2).Unit
    local dot = v1:Dot(v2)
    dot = math.clamp(dot, -1, 1)
    return math.deg(math.acos(dot))
end

local function FindChokePoints(path)
    if not path or #path < 3 then return {} end
    
    local chokePoints = {}
    for i = 2, #path - 1 do
        local angle = CalculateAngle(
            path[i-1].Position,
            path[i].Position,
            path[i+1].Position
        )
        
        if angle < Config.CHOKE_ANGLE_THRESHOLD then
            local sharpness = (Config.CHOKE_ANGLE_THRESHOLD - angle) / Config.CHOKE_ANGLE_THRESHOLD
            table.insert(chokePoints, {
                position = path[i].Position,
                nodeIndex = i,
                angle = angle,
                sharpness = sharpness
            })
            DebugPrint(string.format("🎯 Choke #%d: Angle=%.1f°", i, angle))
        end
    end
    
    return chokePoints
end

-- ════════════════════════════════════════════════════════════════
--  📊 SCORING HELPERS
-- ════════════════════════════════════════════════════════════════

local function IsPositionTaken(pos, minDistance)
    minDistance = minDistance or Config.GRID_SIZE
    for _, placedPos in ipairs(PlacedUnits) do
        if (pos - placedPos).Magnitude < minDistance then
            return true
        end
    end
    return false
end

local function CountPathNodesInRange(pos, range, path)
    local count = 0
    for _, node in ipairs(path) do
        if (pos - node.Position).Magnitude <= range then
            count = count + 1
        end
    end
    return count
end

local function CountOverlappingUnits(pos, range)
    local count = 0
    for _, placedPos in ipairs(PlacedUnits) do
        if (pos - placedPos).Magnitude <= range * 2 then
            count = count + 1
        end
    end
    return count
end

local function GetDistanceToNearestChoke(pos, chokePoints)
    if not chokePoints or #chokePoints == 0 then return 999999, nil end
    
    local minDist = 999999
    local nearestChoke = nil
    
    for _, choke in ipairs(chokePoints) do
        local dist = (pos - choke.position).Magnitude
        if dist < minDist then
            minDist = dist
            nearestChoke = choke
        end
    end
    
    return minDist, nearestChoke
end

-- ════════════════════════════════════════════════════════════════
--  🏆 MAIN PLACEMENT ALGORITHM
-- ════════════════════════════════════════════════════════════════

local function GetUltimatePlacement(unitRange)
    unitRange = unitRange or 20
    
    local path = GetPath()
    if not path or #path < 3 then
        DebugPrint("❌ Invalid path!")
        return nil
    end
    
    local enemyBase = GetEnemyBase()
    local playerBase = GetPlayerBase()
    
    UpdateWaveInfo()
    local waveProgress = MaxWave > 0 and (CurrentWave / MaxWave) or 0
    
    DebugPrint(string.format("🎯 Wave: %d/%d (%.0f%%) | Range: %d", 
        CurrentWave, MaxWave, waveProgress * 100, unitRange))
    
    local chokePoints = FindChokePoints(path)
    
    -- Adaptive Kill Zones
    local activeZones = {}
    for _, zone in ipairs(Config.KILL_ZONES) do
        local adaptiveWeight = zone.weight
        
        if waveProgress < 0.3 then
            if zone.name == "Spawn Kill" or zone.name == "Early Zone" then
                adaptiveWeight = adaptiveWeight * 2
            end
        elseif waveProgress < 0.7 then
            if zone.name:match("Mid") then
                adaptiveWeight = adaptiveWeight * 1.5
            end
        else
            if zone.name == "Last Stand" or zone.name == "Late Defense" then
                adaptiveWeight = adaptiveWeight * 2.5
            end
        end
        
        table.insert(activeZones, {
            name = zone.name,
            start = zone.start,
            finish = zone.finish,
            weight = adaptiveWeight
        })
    end
    
    -- Scan positions
    local candidates = {}
    local scanRadius = unitRange * 1.5
    
    for i = 1, #path do
        local nodePos = path[i].Position
        
        for x = -scanRadius, scanRadius, Config.GRID_SIZE do
            for z = -scanRadius, scanRadius, Config.GRID_SIZE do
                local testPos = nodePos + Vector3.new(x, 0, z)
                local isValid = true
                
                -- Basic checks
                local distToPlayer = (testPos - playerBase).Magnitude
                if distToPlayer < Config.MIN_DISTANCE_FROM_BASE then
                    isValid = false
                end
                
                if isValid and IsPositionTaken(testPos, Config.GRID_SIZE) then
                    isValid = false
                end
                
                if isValid then
                    local score = 0
                    
                    -- 1. Path Coverage
                    local nodesInRange = CountPathNodesInRange(testPos, unitRange, path)
                    if nodesInRange < Config.MIN_PATH_COVERAGE then
                        isValid = false
                    else
                        score = score + (nodesInRange * 200)
                    end
                    
                    if isValid then
                        -- 2. Kill Zone Score
                        local pathPercent = (i - 1) / (#path - 1)
                        for _, zone in ipairs(activeZones) do
                            if pathPercent >= zone.start and pathPercent <= zone.finish then
                                score = score + (zone.weight * 100)
                            end
                        end
                        
                        -- 3. Choke Point Bonus
                        local distToChoke, nearestChoke = GetDistanceToNearestChoke(testPos, chokePoints)
                        if distToChoke < unitRange and nearestChoke then
                            score = score + (Config.CHOKE_BONUS * nearestChoke.sharpness)
                        end
                        
                        -- 4. DPS Overlap
                        local overlaps = CountOverlappingUnits(testPos, unitRange)
                        score = score + (overlaps * Config.OVERLAP_BONUS)
                        
                        -- 5. Distance to Enemy Base
                        local distToEnemy = (testPos - enemyBase).Magnitude
                        score = score + (1000 - distToEnemy * 2)
                        
                        -- 6. Wave-Adaptive
                        if waveProgress < 0.3 then
                            score = score + (2000 - distToEnemy * 5)
                        elseif waveProgress > 0.7 then
                            score = score + (1500 - distToPlayer * 3)
                        end
                        
                        table.insert(candidates, {
                            position = testPos,
                            score = score,
                            nodesInRange = nodesInRange,
                            distToEnemy = distToEnemy,
                            distToPlayer = distToPlayer,
                            overlaps = overlaps
                        })
                    end
                end
            end
        end
    end
    
    if #candidates == 0 then
        DebugPrint("❌ No valid positions found!")
        return nil
    end
    
    table.sort(candidates, function(a, b) return a.score > b.score end)
    
    local best = candidates[1]
    
    -- Debug output แบบกระชับ
    DebugPrint(string.format("✅ Best: Score=%.0f | Coverage=%d | Overlaps=%d | Spawn=%.0f | Base=%.0f", 
        best.score, best.nodesInRange, best.overlaps, best.distToEnemy, best.distToPlayer))
    
    table.insert(PlacedUnits, best.position)
    
    return best.position
end

-- ════════════════════════════════════════════════════════════════
--  🎮 GAME INTEGRATION
-- ════════════════════════════════════════════════════════════════

-- ฟังก์ชันดึงข้อมูล Units ที่มี
local function GetPlayerUnits()
    local success, units = pcall(function()
        -- ดึงจาก PlayerGui > Hotbar > Main > Units
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if not playerGui then return {} end
        
        local hotbar = playerGui:FindFirstChild("Hotbar")
        if not hotbar then return {} end
        
        local main = hotbar:FindFirstChild("Main")
        if not main then return {} end
        
        local unitsFrame = main:FindFirstChild("Units")
        if not unitsFrame then return {} end
        
        local availableUnits = {}
        
        -- วนลูปหา slot 1-6
        for i = 1, 6 do
            local slot = unitsFrame:FindFirstChild(tostring(i))
            if slot then
                local unitTemplate = slot:FindFirstChild("UnitTemplate")
                if unitTemplate then
                    -- มียูนิตใน slot นี้
                    local unitData = {
                        Slot = i,
                        Name = "Unknown",  -- TODO: ดึงชื่อจริงจาก UI
                        ID = 0,
                        Data = {
                            Upgrades = {
                                { Range = 25 }  -- Default
                            }
                        }
                    }
                    table.insert(availableUnits, unitData)
                end
            end
        end
        
        return availableUnits
    end)
    return success and units or {}
end

-- ฟังก์ชันดึง Slot ว่าง (slot ที่มียูนิต)
local function GetEmptySlot()
    local units = GetPlayerUnits()
    if units and #units > 0 then
        -- คืน slot แรกที่มียูนิต
        return units[1]
    end
    return nil
end

-- ฟังก์ชันเช็คเงิน
local function GetYen()
    local success, yen = pcall(function()
        local yenUI = LocalPlayer.PlayerGui:FindFirstChild("HUD")
        if yenUI then
            yenUI = yenUI:FindFirstChild("Yen")
            if yenUI and yenUI:FindFirstChild("Amount") then
                local text = yenUI.Amount.Text:gsub(",", "")
                return tonumber(text) or 0
            end
        end
        return 0
    end)
    return success and yen or 0
end

-- ฟังก์ชัน Place Unit จริง
local function PlaceUnitInGame(position, unitSlot, rotation)
    local success, result = pcall(function()
        -- หา RemoteEvent ที่ใช้วางตัว (ตาม decompiled code)
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Networking")
        if not remotes then
            warn("❌ ไม่พบ Networking folder!")
            return false
        end
        
        -- ใช้ UnitEvent:FireServer("Render", {...})
        local unitEvent = remotes:FindFirstChild("UnitEvent")
        if not unitEvent then
            warn("❌ ไม่พบ UnitEvent!")
            return false
        end
        
        -- ดึงข้อมูลยูนิตจาก slot
        if not unitSlot then
            warn("❌ ไม่ระบุ slot!")
            return false
        end
        
        -- สร้าง placement data ตามรูปแบบของเกม
        -- Format: {UnitName, UnitID, Position, Rotation, ExtraData}
        local placementData = {
            unitSlot.Name,           -- ชื่อยูนิต
            unitSlot.ID,             -- ID ของยูนิต
            position,                 -- ตำแหน่ง Vector3
            rotation or 0,            -- มุมหมุน (default 0)
            nil                       -- Extra data (ถ้ามี)
        }
        
        DebugPrint("📡 Placing unit:", unitSlot.Name, "at", position)
        unitEvent:FireServer("Render", placementData, nil)
        
        return true
    end)
    
    if not success then
        warn("❌ Place failed:", result)
    end
    
    return success and result
end

-- ════════════════════════════════════════════════════════════════
--  🤖 AUTO PLACEMENT SYSTEM
-- ════════════════════════════════════════════════════════════════

local AutoPlacementActive = false
local PlacementQueue = {}

local function StartAutoPlacement()
    if AutoPlacementActive then
        print("⚠️ Auto Placement กำลังทำงานอยู่แล้ว!")
        return
    end
    
    AutoPlacementActive = true
    print("═══════════════════════════════════════════")
    print("🤖 AUTO PLACEMENT เริ่มทำงาน!")
    print("═══════════════════════════════════════════\n")
    
    local lastPlaceTime = 0
    local placeCount = 0
    
    local connection = RunService.Heartbeat:Connect(function()
        if not AutoPlacementActive then
            return
        end
        
        local currentTime = tick()
        if currentTime - lastPlaceTime < Config.PLACE_COOLDOWN then
            return
        end
        
        -- ดึงข้อมูลยูนิตจาก Hotbar
        local unitSlot = GetEmptySlot()
        if not unitSlot then
            DebugPrint("⚠️ ไม่มี slot ว่าง")
            return
        end
        
        local units = GetPlayerUnits()
        if not units or #units == 0 then
            DebugPrint("⚠️ ไม่มียูนิตในกระเป๋า")
            return
        end
        
        -- เลือกยูนิตตัวแรกที่ใช้ได้
        local selectedUnit = units[1]
        if not selectedUnit then
            return
        end
        
        -- ดึง range ของยูนิต
        local unitRange = 25  -- Default
        if selectedUnit.Data and selectedUnit.Data.Upgrades then
            local upgrade = selectedUnit.Data.Upgrades[1]
            if upgrade and upgrade.Range then
                unitRange = upgrade.Range
            end
        end
        
        -- หาตำแหน่งที่ดีที่สุด
        local position = GetUltimatePlacement(unitRange)
        
        if position then
            -- วางยูนิตจริง
            local placed = PlaceUnitInGame(position, selectedUnit, 0)
            
            if placed then
                placeCount = placeCount + 1
                print(string.format("✅ [#%d] วางสำเร็จ: %s ที่ %.1f, %.1f, %.1f", 
                    placeCount, selectedUnit.Name, position.X, position.Y, position.Z))
                
                lastPlaceTime = currentTime
            else
                warn(string.format("❌ วางไม่สำเร็จที่: %.1f, %.1f, %.1f", 
                    position.X, position.Y, position.Z))
            end
        else
            DebugPrint("❌ หาตำแหน่งไม่ได้")
        end
    end)
    
    -- เก็บ connection ไว้ปิดทีหลัง
    _G.AutoPlacementConnection = connection
end

local function StopAutoPlacement()
    AutoPlacementActive = false
    if _G.AutoPlacementConnection then
        _G.AutoPlacementConnection:Disconnect()
        _G.AutoPlacementConnection = nil
    end
    print("\n═══════════════════════════════════════════")
    print("🛑 AUTO PLACEMENT หยุดทำงาน")
    print("═══════════════════════════════════════════\n")
end

-- ════════════════════════════════════════════════════════════════
--  🎮 TESTING FUNCTIONS
-- ════════════════════════════════════════════════════════════════

local function TestPlacement()
    print("\n════════════════════════════════════════")
    print("🧪 TESTING ULTIMATE PLACEMENT SYSTEM")
    print("════════════════════════════════════════\n")
    
    -- Reset
    PlacedUnits = {}
    
    -- เช็ค Map ก่อน
    local path = GetPath()
    if not path then
        warn("❌ ไม่พบ Path! กรุณาเข้าเกมให้โหลด Map เสร็จก่อน")
        return
    end
    
    print(string.format("✅ พบ Path: %d nodes\n", #path))
    
    -- Test 1: Single placement
    print("Test 1: วางตัวเดียว (Range 25)")
    local pos1 = GetUltimatePlacement(25)
    if pos1 then
        print(string.format("✅ Position: %.1f, %.1f, %.1f\n", pos1.X, pos1.Y, pos1.Z))
    else
        print("❌ Failed!\n")
    end
    
    -- Test 2: Multiple placements
    print("Test 2: วาง 5 ตัว")
    for i = 1, 5 do
        local pos = GetUltimatePlacement(20 + i*2)
        if pos then
            print(string.format("✅ Unit %d: %.1f, %.1f, %.1f", i, pos.X, pos.Y, pos.Z))
        else
            print(string.format("❌ Unit %d: Failed!", i))
        end
        wait(0.1)
    end
    
    print("\n════════════════════════════════════════")
    print(string.format("📊 Total Placed: %d units", #PlacedUnits))
    print("════════════════════════════════════════\n")
end

local function ResetPlacement()
    PlacedUnits = {}
    CurrentWave = 0
    MaxWave = 0
    print("🧹 Placement data reset!")
end

-- ════════════════════════════════════════════════════════════════
--  🤖 AUTO LOOP - ลบออก (ใช้ StartAutoPlacement แทน)
-- ════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════
--  🚀 MAIN EXECUTION - AUTO START
-- ════════════════════════════════════════════════════════════════

print("\n════════════════════════════════════════")
print("🏆 ULTIMATE AUTO PLACEMENT")
print("🚀 กำลังเริ่มต้นระบบ...")
print("════════════════════════════════════════\n")

-- รอให้ Map โหลดเสร็จ
local function WaitForMap()
    print("⏳ รอ Map โหลด...")
    local attempts = 0
    local maxAttempts = 30  -- รอ 30 วินาที
    
    while attempts < maxAttempts do
        local map = GetMap()
        if map then
            local path = GetPath()
            if path and #path > 0 then
                print(string.format("✅ พบ Map: %s", map.Name))
                print(string.format("✅ พบ Path: %d nodes", #path))
                return true
            end
        end
        
        attempts = attempts + 1
        wait(1)
    end
    
    warn("❌ รอ Map เกิน 30 วินาที!")
    warn("💡 กรุณาเข้าเกมให้โหลดเสร็จก่อน แล้วรัน script ใหม่")
    return false
end

-- เริ่มระบบอัตโนมัติ
task.spawn(function()
    wait(2)  -- รอให้เกมโหลดเล็กน้อย
    
    if WaitForMap() then
        print("\n🎮 ระบบพร้อมใช้งาน!")
        print("════════════════════════════════════════")
        print("⚙️ การตั้งค่า:")
        print(string.format("   • วางทุก: %d วินาที", Config.PLACE_COOLDOWN))
        print(string.format("   • Grid Size: %d", Config.GRID_SIZE))
        print(string.format("   • Coverage: %d nodes", Config.MIN_PATH_COVERAGE))
        print("════════════════════════════════════════")
        print("📝 คำสั่ง:")
        print("   StopAutoPlacement()  - หยุด")
        print("   StartAutoPlacement() - เริ่มใหม่")
        print("   Config.DEBUG = false - ปิด debug")
        print("════════════════════════════════════════\n")
        
        -- เริ่ม Auto ทันที
        print("🤖 เริ่ม Auto Placement ใน 3 วินาที...\n")
        wait(3)
        StartAutoPlacement()
    end
end)
