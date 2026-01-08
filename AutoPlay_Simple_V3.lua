--[[
    🎮 AUTO PLAY SIMPLE V3 🎮
    ระบบ Auto Play ที่ใช้งานได้จริง!
    
    ✅ Auto Skip Wave
    ✅ Auto Upgrade Units
    ✅ Auto Place Units (ถ้ามีเงินพอ)
    ✅ Auto Ability
    
    สร้างจาก Decompiled Code โดยตรง
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== REMOTE EVENTS ====================
local Networking = ReplicatedStorage:WaitForChild("Networking", 10)

-- Skip Wave Event
local SkipWaveEvent = Networking:WaitForChild("SkipWaveEvent", 5)

-- Unit Event (Place, Upgrade, Sell)
local UnitEvent = Networking:WaitForChild("UnitEvent", 5)

-- Ability Event
local AbilityEvent = Networking:WaitForChild("AbilityEvent", 5)

-- ==================== GAME MODULES ====================
local Modules = StarterPlayer:WaitForChild("Modules", 10)
local GameplayModules = Modules:WaitForChild("Gameplay", 5)

-- Client Handlers
local ClientEnemyHandler = nil
local ClientUnitHandler = nil
local PlayerYenHandler = nil

-- Safe require
local function safeRequire(module)
    local success, result = pcall(function()
        return require(module)
    end)
    if success then
        return result
    else
        warn("Failed to require:", module:GetFullName(), result)
        return nil
    end
end

-- Load modules
pcall(function()
    ClientEnemyHandler = safeRequire(GameplayModules:WaitForChild("ClientEnemyHandler", 5))
end)

pcall(function()
    ClientUnitHandler = safeRequire(GameplayModules:WaitForChild("Units"):WaitForChild("ClientUnitHandler", 5))
end)

pcall(function()
    PlayerYenHandler = safeRequire(GameplayModules:WaitForChild("PlayerYenHandler", 5))
end)

-- UnitPlacementHandler สำหรับตรวจสอบตำแหน่งวาง
local UnitPlacementHandler = nil
pcall(function()
    UnitPlacementHandler = safeRequire(GameplayModules:WaitForChild("Units"):WaitForChild("UnitPlacementHandler", 5))
end)

-- GameHandler สำหรับดึง MaxUnitsLimit
local GameHandler = nil
pcall(function()
    GameHandler = safeRequire(GameplayModules:WaitForChild("GameHandler", 5))
end)

-- ClientGameHandler 
local ClientGameHandler = nil
pcall(function()
    ClientGameHandler = safeRequire(GameplayModules:WaitForChild("ClientGameHandler", 5))
end)

-- ==================== HOTBAR UNITS ====================
local RequestUnitEvent = Networking:WaitForChild("RequestUnitEvent", 5)

-- ดึงข้อมูล Units ใน Hotbar
local HotbarUnits = {}
local UnitsData = nil
local HUDUnitsModule = nil

pcall(function()
    local DataModules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data")
    UnitsData = safeRequire(DataModules:WaitForChild("Entities"):WaitForChild("Units"))
end)

-- ลองดึง HUD Units Module
pcall(function()
    local InterfaceModules = StarterPlayer:WaitForChild("Modules"):WaitForChild("Interface"):WaitForChild("Loader")
    local HUDFolder = InterfaceModules:WaitForChild("HUD", 5)
    if HUDFolder then
        local UnitsModule = HUDFolder:FindFirstChild("Units")
        if UnitsModule then
            HUDUnitsModule = safeRequire(UnitsModule)
        end
    end
end)

-- ==================== AUTO PLAY SYSTEM ====================
local AutoPlay = {
    IsRunning = false,
    
    -- Settings
    Config = {
        AutoSkip = true,        -- Auto skip wave
        AutoUpgrade = true,     -- Auto upgrade units
        AutoAbility = true,     -- Auto use abilities
        AutoPlace = true,       -- Auto place units
        UpgradeDelay = 0.3,     -- Delay ระหว่างการอัพเกรด
        SkipDelay = 2,          -- Delay ระหว่างการ skip
        AbilityDelay = 0.5,     -- Delay ระหว่างการใช้ ability
        PlaceDelay = 2,         -- Delay ระหว่างการวาง unit
        -- MaxUnits จะดึงจาก game data อัตโนมัติ
    },
    
    -- State
    LastSkipTime = 0,
    LastUpgradeTime = 0,
    LastAbilityTime = 0,
    LastPlaceTime = 0,
    LastSkippedWave = 0,      -- Wave ล่าสุดที่ skip แล้ว
    PlacedPositions = {},     -- เก็บตำแหน่งที่วางแล้ว
    FailedPositions = {},     -- เก็บตำแหน่งที่วางไม่ได้
    ReachedMaxUnits = false,  -- ถึง limit แล้วหรือยัง
    CachedMaxUnits = nil,     -- Cache ค่า MaxUnits
}

-- ==================== HELPER FUNCTIONS ====================

-- ดึง Yen ปัจจุบัน
function AutoPlay:GetYen()
    if PlayerYenHandler and PlayerYenHandler.GetYen then
        return PlayerYenHandler:GetYen() or 0
    end
    return 0
end

-- ดึง MaxUnitsLimit จาก Game Data
function AutoPlay:GetMaxUnitsLimit()
    -- ถ้ามี cache แล้ว ใช้ cache
    if self.CachedMaxUnits then
        return self.CachedMaxUnits
    end
    
    local maxUnits = 20 -- default fallback
    
    -- วิธีที่ 1: จาก GameHandler
    pcall(function()
        if GameHandler then
            if GameHandler.MaxUnits then
                maxUnits = GameHandler.MaxUnits
            elseif GameHandler.MaxUnitsLimit then
                maxUnits = GameHandler.MaxUnitsLimit
            elseif GameHandler.UnitLimit then
                maxUnits = GameHandler.UnitLimit
            elseif GameHandler._MaxUnits then
                maxUnits = GameHandler._MaxUnits
            elseif GameHandler.GetMaxUnits then
                maxUnits = GameHandler:GetMaxUnits()
            end
        end
    end)
    
    -- วิธีที่ 2: จาก ClientGameHandler
    pcall(function()
        if ClientGameHandler then
            if ClientGameHandler.MaxUnits then
                maxUnits = ClientGameHandler.MaxUnits
            elseif ClientGameHandler.MaxUnitsLimit then
                maxUnits = ClientGameHandler.MaxUnitsLimit
            elseif ClientGameHandler.UnitLimit then
                maxUnits = ClientGameHandler.UnitLimit
            elseif ClientGameHandler._MaxUnits then
                maxUnits = ClientGameHandler._MaxUnits
            elseif ClientGameHandler.GetMaxUnits then
                maxUnits = ClientGameHandler:GetMaxUnits()
            end
        end
    end)
    
    -- วิธีที่ 3: จาก ClientUnitHandler
    pcall(function()
        if ClientUnitHandler then
            if ClientUnitHandler.MaxUnits then
                maxUnits = ClientUnitHandler.MaxUnits
            elseif ClientUnitHandler.MaxUnitsLimit then
                maxUnits = ClientUnitHandler.MaxUnitsLimit
            elseif ClientUnitHandler._MaxUnits then
                maxUnits = ClientUnitHandler._MaxUnits
            elseif ClientUnitHandler.GetMaxUnits then
                maxUnits = ClientUnitHandler:GetMaxUnits()
            end
        end
    end)
    
    -- วิธีที่ 4: จาก HUD
    pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            local Units = HUD:FindFirstChild("Units") or HUD:FindFirstChild("UnitLimit")
            if Units then
                -- หา TextLabel ที่แสดง limit เช่น "5/20"
                for _, child in ipairs(Units:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        local text = child.Text
                        local current, max = text:match("(%d+)/(%d+)")
                        if max then
                            maxUnits = tonumber(max) or maxUnits
                            break
                        end
                    end
                end
            end
        end
    end)
    
    -- วิธีที่ 5: จาก UnitsData
    pcall(function()
        if UnitsData then
            if UnitsData.MaxUnits then
                maxUnits = UnitsData.MaxUnits
            elseif UnitsData.MaxUnitsLimit then
                maxUnits = UnitsData.MaxUnitsLimit
            elseif UnitsData.Limit then
                maxUnits = UnitsData.Limit
            end
        end
    end)
    
    -- Cache ค่าที่ได้
    self.CachedMaxUnits = maxUnits
    
    return maxUnits
end

-- ดึง Units ที่วางอยู่
function AutoPlay:GetMyUnits()
    local units = {}
    
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == LocalPlayer then
                units[guid] = unitData
            end
        end
    end
    
    return units
end

-- นับจำนวน Units ที่วางแล้ว
function AutoPlay:GetMyUnitCount()
    local count = 0
    local units = self:GetMyUnits()
    for _ in pairs(units) do
        count = count + 1
    end
    return count
end

-- ตรวจสอบว่าถึง Max Units หรือยัง
function AutoPlay:CanPlaceMoreUnits()
    local currentCount = self:GetMyUnitCount()
    local maxUnits = self:GetMaxUnitsLimit() -- ดึงจาก game data
    
    if currentCount >= maxUnits then
        if not self.ReachedMaxUnits then
            self.ReachedMaxUnits = true
            print(string.format("🚫 [Auto] Reached max units limit (%d/%d)", currentCount, maxUnits))
        end
        return false
    end
    
    self.ReachedMaxUnits = false
    return true
end

-- ดึง Enemies ทั้งหมด
function AutoPlay:GetEnemies()
    if ClientEnemyHandler and ClientEnemyHandler._ActiveEnemies then
        return ClientEnemyHandler._ActiveEnemies
    end
    return {}
end

-- ดึง Wave ปัจจุบัน
function AutoPlay:GetWave()
    local success, result = pcall(function()
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            local Map = HUD:FindFirstChild("Map")
            if Map then
                local WavesAmount = Map:FindFirstChild("WavesAmount")
                if WavesAmount then
                    local text = WavesAmount.Text
                    -- Parse "1/50" format หรือ HTML format
                    local current = text:match("(%d+)")
                    return tonumber(current) or 0
                end
            end
        end
        return 0
    end)
    
    return success and result or 0
end

-- ==================== AUTO SKIP ====================
function AutoPlay:AutoSkip()
    if not self.Config.AutoSkip then return end
    
    local now = os.clock()
    if now - self.LastSkipTime < self.Config.SkipDelay then return end
    
    -- ตรวจสอบว่า wave เปลี่ยนหรือยัง (ไม่ spam skip)
    local currentWave = self:GetWave()
    self.LastSkippedWave = self.LastSkippedWave or 0
    
    -- ถ้า wave เดิม ไม่ต้อง skip ซ้ำ
    if currentWave == self.LastSkippedWave and currentWave > 0 then
        return
    end
    
    if SkipWaveEvent then
        local success = pcall(function()
            SkipWaveEvent:FireServer("Skip")
        end)
        
        if success then
            self.LastSkipTime = now
            self.LastSkippedWave = currentWave
            print("⏭️ [Auto] Skipped wave!", currentWave)
        end
    end
end

-- ==================== AUTO UPGRADE ====================
function AutoPlay:AutoUpgrade()
    if not self.Config.AutoUpgrade then return end
    
    local now = os.clock()
    if now - self.LastUpgradeTime < self.Config.UpgradeDelay then return end
    
    local yen = self:GetYen()
    local units = self:GetMyUnits()
    
    -- หา Unit ที่ upgrade ได้
    for guid, unitData in pairs(units) do
        if unitData.Data then
            local currentUpgrade = unitData.Data.CurrentUpgrade or 1
            local upgrades = unitData.Data.Upgrades
            
            if upgrades and upgrades[currentUpgrade + 1] then
                local nextUpgrade = upgrades[currentUpgrade + 1]
                local price = nextUpgrade.Price or 0
                
                -- ตรวจสอบว่ามีเงินพอไหม
                if yen >= price then
                    local success = pcall(function()
                        UnitEvent:FireServer("Upgrade", guid)
                    end)
                    
                    if success then
                        self.LastUpgradeTime = now
                        print(string.format("⬆️ [Auto] Upgraded %s (Level %d -> %d) for %d¥", 
                            unitData.Name or "Unit", 
                            currentUpgrade, 
                            currentUpgrade + 1,
                            price
                        ))
                        return -- Upgrade 1 ตัวต่อ loop
                    end
                end
            end
        end
    end
end

-- ==================== AUTO ABILITY ====================
function AutoPlay:AutoAbility()
    if not self.Config.AutoAbility then return end
    
    local now = os.clock()
    if now - self.LastAbilityTime < self.Config.AbilityDelay then return end
    
    local units = self:GetMyUnits()
    local enemies = self:GetEnemies()
    
    -- ถ้าไม่มีศัตรู ไม่ต้องใช้ ability
    local hasEnemies = false
    for _ in pairs(enemies) do
        hasEnemies = true
        break
    end
    
    if not hasEnemies then return end
    
    -- หา Unit ที่มี Ability
    for guid, unitData in pairs(units) do
        if unitData.ActiveAbilities then
            for _, abilityName in ipairs(unitData.ActiveAbilities) do
                local success = pcall(function()
                    AbilityEvent:FireServer("Activate", guid, abilityName)
                end)
                
                if success then
                    self.LastAbilityTime = now
                    print(string.format("✨ [Auto] Used ability '%s' on %s", 
                        abilityName, 
                        unitData.Name or "Unit"
                    ))
                    return -- ใช้ 1 ability ต่อ loop
                end
            end
        end
    end
end

-- ==================== AUTO PLACE ⭐ NEW! ====================
function AutoPlay:GetHotbarUnits()
    -- ดึง Units จาก Hotbar UI และ HUD Module
    local hotbar = {}
    
    -- วิธีที่ 1: ดึงจาก HUD Units Module Cache
    if HUDUnitsModule and HUDUnitsModule._Cache then
        for i = 1, 6 do
            local cached = HUDUnitsModule._Cache[i]
            if cached and cached ~= "None" and cached.Data then
                hotbar[i] = {
                    Slot = i,
                    HasUnit = true,
                    Name = cached.Data.Name,
                    ID = cached.Data.ID,
                    Price = cached.Data.Price or 500,
                    UnitObject = cached
                }
            end
        end
    end
    
    -- วิธีที่ 2: ดึงจาก Hotbar UI โดยตรง
    pcall(function()
        local HotbarUI = PlayerGui:FindFirstChild("Hotbar")
        if HotbarUI then
            local Main = HotbarUI:FindFirstChild("Main")
            if Main then
                local UnitsFrame = Main:FindFirstChild("Units")
                if UnitsFrame then
                    for i = 1, 6 do
                        local slot = UnitsFrame:FindFirstChild(tostring(i))
                        if slot then
                            local unitTemplate = slot:FindFirstChild("UnitTemplate")
                            if unitTemplate and not hotbar[i] then
                                -- ดึง Unit ID จาก UI attribute หรือ ข้อมูลอื่นๆ
                                local unitID = slot:GetAttribute("UnitID") or 
                                               unitTemplate:GetAttribute("UnitID") or
                                               slot:GetAttribute("ID") or i
                                
                                local unitName = slot:GetAttribute("UnitName") or
                                                 unitTemplate:GetAttribute("UnitName") or
                                                 "Unit"..i
                                
                                local price = slot:GetAttribute("Price") or 500
                                
                                hotbar[i] = {
                                    Slot = i,
                                    HasUnit = true,
                                    Name = unitName,
                                    ID = unitID,
                                    Price = price,
                                    Frame = slot
                                }
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- วิธีที่ 3: ถ้ายังไม่มี ลองดึงจาก UnitsData
    if UnitsData then
        pcall(function()
            local allUnits = {}
            
            if UnitsData.GetAllUnits then
                allUnits = UnitsData:GetAllUnits()
            elseif UnitsData._Units then
                allUnits = UnitsData._Units
            elseif type(UnitsData) == "table" then
                allUnits = UnitsData
            end
            
            local slot = 1
            for unitID, unitData in pairs(allUnits) do
                if slot <= 6 and not hotbar[slot] then
                    if unitData and (unitData.Name or unitData.DisplayName) then
                        hotbar[slot] = {
                            Slot = slot,
                            HasUnit = true,
                            Name = unitData.Name or unitData.DisplayName or "Unit",
                            ID = unitID,
                            Price = unitData.Price or unitData.Cost or 500
                        }
                        slot = slot + 1
                    end
                end
            end
        end)
    end
    
    return hotbar
end

function AutoPlay:FindPlacementPosition()
    -- หาตำแหน่งวางบนแมพที่วางได้จริง!
    local Map = workspace:FindFirstChild("Map")
    if not Map then return nil end
    
    local validPositions = {}
    
    -- วิธีที่ 1: หา Placement parts (พื้นที่ที่วางได้)
    pcall(function()
        local function scanForPlacements(parent)
            for _, child in ipairs(parent:GetDescendants()) do
                -- หา Parts ที่มีชื่อเกี่ยวกับ Placement
                if child:IsA("BasePart") then
                    local name = child.Name:lower()
                    if name:find("placement") or name:find("place") or name:find("spawn") or name:find("floor") or name:find("ground") or name:find("platform") then
                        -- เก็บตำแหน่งนี้
                        local pos = child.Position
                        table.insert(validPositions, pos + Vector3.new(0, 1, 0))
                        
                        -- เพิ่มตำแหน่งรอบๆ ด้วย
                        local size = child.Size
                        local gridSize = 4 -- ระยะห่างระหว่าง units
                        
                        for x = -size.X/2 + 2, size.X/2 - 2, gridSize do
                            for z = -size.Z/2 + 2, size.Z/2 - 2, gridSize do
                                local gridPos = pos + Vector3.new(x, 1, z)
                                table.insert(validPositions, gridPos)
                            end
                        end
                    end
                end
            end
        end
        
        scanForPlacements(Map)
    end)
    
    -- วิธีที่ 2: หา Folder ที่ชื่อ Placements
    pcall(function()
        local Placements = Map:FindFirstChild("Placements") or Map:FindFirstChild("PlacementAreas")
        if Placements then
            for _, part in ipairs(Placements:GetDescendants()) do
                if part:IsA("BasePart") then
                    local pos = part.Position
                    table.insert(validPositions, pos + Vector3.new(0, 1, 0))
                    
                    -- Grid scan
                    local size = part.Size
                    for x = -size.X/2 + 2, size.X/2 - 2, 4 do
                        for z = -size.Z/2 + 2, size.Z/2 - 2, 4 do
                            table.insert(validPositions, pos + Vector3.new(x, 1, z))
                        end
                    end
                end
            end
        end
    end)
    
    -- วิธีที่ 3: Scan หา valid floor parts ทั้งหมดใน Map
    if #validPositions == 0 then
        pcall(function()
            for _, part in ipairs(Map:GetDescendants()) do
                if part:IsA("BasePart") and part.Size.Y < 3 then -- Floor มักจะบาง
                    -- ตรวจสอบว่าไม่ใช่ Path หรือ Enemy related
                    local name = part.Name:lower()
                    if not name:find("path") and not name:find("enemy") and not name:find("spawn") and not name:find("end") then
                        if part.CanCollide then
                            local pos = part.Position + Vector3.new(0, 2, 0)
                            table.insert(validPositions, pos)
                        end
                    end
                end
            end
        end)
    end
    
    -- วิธีที่ 4: ถ้ายังไม่มี ใช้ตำแหน่งพื้นฐาน
    if #validPositions == 0 then
        local basePositions = {
            Vector3.new(0, 5, 0),
            Vector3.new(10, 5, 0), Vector3.new(-10, 5, 0),
            Vector3.new(0, 5, 10), Vector3.new(0, 5, -10),
            Vector3.new(20, 5, 20), Vector3.new(-20, 5, 20),
            Vector3.new(20, 5, -20), Vector3.new(-20, 5, -20),
        }
        for _, pos in ipairs(basePositions) do
            table.insert(validPositions, pos)
        end
    end
    
    -- สุ่มเลือกตำแหน่งที่ยังไม่ได้วาง
    local shuffledPositions = {}
    for _, pos in ipairs(validPositions) do
        table.insert(shuffledPositions, {pos = pos, rand = math.random()})
    end
    table.sort(shuffledPositions, function(a, b) return a.rand < b.rand end)
    
    for _, item in ipairs(shuffledPositions) do
        local pos = item.pos
        
        -- ตรวจสอบว่าตำแหน่งนี้วางแล้วหรือยัง
        local alreadyPlaced = false
        for _, placedPos in ipairs(self.PlacedPositions) do
            if (pos - placedPos).Magnitude < 4 then
                alreadyPlaced = true
                break
            end
        end
        
        if not alreadyPlaced then
            return pos
        end
    end
    
    return nil
end

-- ตรวจสอบว่าตำแหน่งนี้วางได้หรือไม่
function AutoPlay:IsValidPlacement(position)
    -- ใช้ UnitPlacementHandler ถ้ามี
    if UnitPlacementHandler then
        local isValid = false
        pcall(function()
            if UnitPlacementHandler.CanPlace then
                isValid = UnitPlacementHandler:CanPlace(position)
            elseif UnitPlacementHandler.CheckPlacement then
                isValid = UnitPlacementHandler:CheckPlacement(position)
            elseif UnitPlacementHandler.IsValidPosition then
                isValid = UnitPlacementHandler:IsValidPosition(position)
            end
        end)
        return isValid
    end
    return true -- ถ้าไม่มี handler ให้ลองวางเลย
end

-- หาตำแหน่งวางหลายๆ จุดแล้วลองทีละจุด
function AutoPlay:GetAllValidPositions()
    local Map = workspace:FindFirstChild("Map")
    if not Map then return {} end
    
    local positions = {}
    
    -- Scan หา Placement parts
    for _, part in ipairs(Map:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            
            -- หา placement areas
            if name:find("placement") or name:find("place") or name:find("tower") then
                local pos = part.Position
                local size = part.Size
                
                -- Grid scan บน part นี้
                local step = 3
                for x = -size.X/2 + 1, size.X/2 - 1, step do
                    for z = -size.Z/2 + 1, size.Z/2 - 1, step do
                        local gridPos = pos + Vector3.new(x, size.Y/2 + 0.5, z)
                        table.insert(positions, gridPos)
                    end
                end
            end
        end
    end
    
    return positions
end

function AutoPlay:AutoPlace()
    if not self.Config.AutoPlace then return end
    
    local now = os.clock()
    if now - self.LastPlaceTime < self.Config.PlaceDelay then return end
    
    -- ตรวจสอบ Max Units Limit ก่อน!
    if not self:CanPlaceMoreUnits() then
        return -- ถึง limit แล้ว ไม่วางเพิ่ม
    end
    
    local yen = self:GetYen()
    if yen < 100 then return end -- ต้องมีเงินอย่างน้อย 100¥
    
    -- ดึง Hotbar Units (ตอนนี้มี Name, ID, Price แล้ว)
    local hotbar = self:GetHotbarUnits()
    
    -- Debug: แสดง hotbar ที่ได้
    local hasUnits = false
    for i, data in pairs(hotbar) do
        if data.HasUnit then
            hasUnits = true
            break
        end
    end
    
    if not hasUnits then
        return
    end
    
    -- ลองวางจาก slot 1-6 (เรียงตามราคาถูกก่อน)
    local sortedSlots = {}
    for slotNum, data in pairs(hotbar) do
        if data.HasUnit then
            table.insert(sortedSlots, {slot = slotNum, data = data})
        end
    end
    table.sort(sortedSlots, function(a, b)
        return (a.data.Price or 9999) < (b.data.Price or 9999)
    end)
    
    -- หา unit ที่จะวาง
    local unitToPlace = nil
    for _, slotInfo in ipairs(sortedSlots) do
        local price = slotInfo.data.Price or 500
        if yen >= price then
            unitToPlace = slotInfo
            break
        end
    end
    
    if not unitToPlace then
        return -- ไม่มีเงินพอ
    end
    
    -- หาหลายตำแหน่งแล้วลองทีละตำแหน่ง
    local allPositions = self:GetAllValidPositions()
    
    -- ถ้าไม่เจอจาก GetAllValidPositions ใช้ FindPlacementPosition
    if #allPositions == 0 then
        local pos = self:FindPlacementPosition()
        if pos then
            table.insert(allPositions, pos)
        end
    end
    
    -- สุ่มลำดับ
    for i = #allPositions, 2, -1 do
        local j = math.random(1, i)
        allPositions[i], allPositions[j] = allPositions[j], allPositions[i]
    end
    
    -- ลองวางในแต่ละตำแหน่ง
    for _, placePosition in ipairs(allPositions) do
        -- ตรวจสอบว่าตำแหน่งนี้วางแล้วหรือยัง
        local alreadyPlaced = false
        for _, placedPos in ipairs(self.PlacedPositions) do
            if (placePosition - placedPos).Magnitude < 3 then
                alreadyPlaced = true
                break
            end
        end
        
        -- ตรวจสอบว่า fail แล้วหรือยัง
        if not alreadyPlaced then
            self.FailedPositions = self.FailedPositions or {}
            for _, failedPos in ipairs(self.FailedPositions) do
                if (placePosition - failedPos).Magnitude < 2 then
                    alreadyPlaced = true
                    break
                end
            end
        end
        
        if not alreadyPlaced then
            local unitInfo = unitToPlace.data
            local slotNum = unitToPlace.slot
            local price = unitInfo.Price or 500
            
            -- ส่งคำสั่งวาง!
            local placeSuccess = pcall(function()
                local unitName = unitInfo.Name or "Unit"
                local unitID = unitInfo.ID or slotNum
                
                UnitEvent:FireServer("Render", {
                    unitName,
                    unitID,
                    placePosition,
                    0,
                    unitInfo.UnitObject
                })
            end)
            
            if placeSuccess then
                self.LastPlaceTime = now
                
                -- รอดูว่า unit ถูกวางจริงหรือไม่
                task.delay(0.5, function()
                    -- ตรวจสอบว่ามี unit ใหม่หรือไม่
                    local newUnits = self:GetMyUnits()
                    local foundNewUnit = false
                    
                    for guid, unitData in pairs(newUnits) do
                        if unitData.Position then
                            local dist = (unitData.Position - placePosition).Magnitude
                            if dist < 5 then
                                foundNewUnit = true
                                break
                            end
                        end
                    end
                    
                    if foundNewUnit then
                        table.insert(self.PlacedPositions, placePosition)
                        print(string.format("✅ [Auto] Successfully placed %s at (%.1f, %.1f, %.1f)", 
                            unitInfo.Name or "Unit",
                            placePosition.X, placePosition.Y, placePosition.Z
                        ))
                    else
                        -- วางไม่สำเร็จ เก็บเป็น failed position
                        self.FailedPositions = self.FailedPositions or {}
                        table.insert(self.FailedPositions, placePosition)
                    end
                end)
                
                print(string.format("🏠 [Auto] Trying to place %s (slot %d) at (%.1f, %.1f, %.1f) for %d¥", 
                    unitInfo.Name or "Unit",
                    slotNum,
                    placePosition.X, placePosition.Y, placePosition.Z,
                    price
                ))
                
                return -- ลองวาง 1 ครั้งต่อ loop
            end
        end
    end
end

-- ==================== MAIN LOOP ====================
function AutoPlay:MainLoop()
    while self.IsRunning do
        local success, err = pcall(function()
            -- ⭐ Auto Place (สำคัญที่สุด!)
            self:AutoPlace()
            
            -- Auto Skip
            self:AutoSkip()
            
            -- Auto Upgrade
            self:AutoUpgrade()
            
            -- Auto Ability
            self:AutoAbility()
        end)
        
        if not success then
            warn("[Auto] Error:", err)
        end
        
        task.wait(0.2) -- Loop ทุก 0.2 วินาที
    end
end

-- ==================== START / STOP ====================
function AutoPlay:Start()
    if self.IsRunning then
        warn("[Auto] Already running!")
        return
    end
    
    print("🎮 ====================================")
    print("🎮  AUTO PLAY SIMPLE V3 STARTED!")
    print("🎮 ====================================")
    print("📋 Config:")
    print("   • Auto Place:", self.Config.AutoPlace)
    print("   • Auto Skip:", self.Config.AutoSkip, "(no spam)")
    print("   • Auto Upgrade:", self.Config.AutoUpgrade)
    print("   • Auto Ability:", self.Config.AutoAbility)
    print("   • Max Units:", self:GetMaxUnitsLimit(), "(from game data)")
    print("🎮 ====================================")
    
    -- Check modules
    print("📦 Modules loaded:")
    print("   • ClientEnemyHandler:", ClientEnemyHandler ~= nil)
    print("   • ClientUnitHandler:", ClientUnitHandler ~= nil)
    print("   • PlayerYenHandler:", PlayerYenHandler ~= nil)
    print("   • GameHandler:", GameHandler ~= nil)
    print("   • SkipWaveEvent:", SkipWaveEvent ~= nil)
    print("   • UnitEvent:", UnitEvent ~= nil)
    print("   • AbilityEvent:", AbilityEvent ~= nil)
    print("🎮 ====================================")
    
    self.IsRunning = true
    
    task.spawn(function()
        self:MainLoop()
    end)
    
    print("✅ Auto Play Started!")
end

function AutoPlay:Stop()
    if not self.IsRunning then
        warn("[Auto] Not running!")
        return
    end
    
    self.IsRunning = false
    print("⏸️ Auto Play Stopped!")
end

-- ==================== TOGGLE FUNCTIONS ====================
function AutoPlay:TogglePlace()
    self.Config.AutoPlace = not self.Config.AutoPlace
    print("🏠 Auto Place:", self.Config.AutoPlace)
end

function AutoPlay:ToggleSkip()
    self.Config.AutoSkip = not self.Config.AutoSkip
    print("⏭️ Auto Skip:", self.Config.AutoSkip)
end

function AutoPlay:ToggleUpgrade()
    self.Config.AutoUpgrade = not self.Config.AutoUpgrade
    print("⬆️ Auto Upgrade:", self.Config.AutoUpgrade)
end

function AutoPlay:ToggleAbility()
    self.Config.AutoAbility = not self.Config.AutoAbility
    print("✨ Auto Ability:", self.Config.AutoAbility)
end

-- Reset cached MaxUnits (บังคับดึงใหม่)
function AutoPlay:RefreshMaxUnits()
    self.CachedMaxUnits = nil
    local maxUnits = self:GetMaxUnitsLimit()
    print(string.format("� Refreshed MaxUnits from game: %d", maxUnits))
end

-- Reset Failed Positions (ถ้าต้องการลองวางใหม่)
function AutoPlay:ResetPositions()
    self.PlacedPositions = {}
    self.FailedPositions = {}
    self.ReachedMaxUnits = false
    self.CachedMaxUnits = nil
    print("🔄 Reset all positions!")
end

-- ==================== DEBUG ====================
function AutoPlay:Debug()
    print("🔍 ====== DEBUG INFO ======")
    print("Yen:", self:GetYen())
    print("Wave:", self:GetWave(), "(Last Skipped:", self.LastSkippedWave, ")")
    
    -- แสดง Unit Count และ Limit (ดึงจาก game data)
    local unitCount = self:GetMyUnitCount()
    local maxUnits = self:GetMaxUnitsLimit()
    print(string.format("My Units: %d/%d %s (from game data)", 
        unitCount, maxUnits, 
        unitCount >= maxUnits and "🚫 MAX!" or "✅"
    ))
    
    local enemies = self:GetEnemies()
    local enemyCount = 0
    for _ in pairs(enemies) do enemyCount = enemyCount + 1 end
    print("Enemies:", enemyCount)
    
    -- แสดง Hotbar Units
    print("📦 Hotbar Units:")
    local hotbar = self:GetHotbarUnits()
    for i = 1, 6 do
        if hotbar[i] and hotbar[i].HasUnit then
            print(string.format("   Slot %d: %s (ID: %s, Price: %d¥)", 
                i, 
                hotbar[i].Name or "Unknown",
                tostring(hotbar[i].ID or "?"),
                hotbar[i].Price or 0
            ))
        else
            print(string.format("   Slot %d: Empty", i))
        end
    end
    
    -- แสดงตำแหน่งที่วางแล้ว
    print("📍 Placed Positions:", #self.PlacedPositions)
    print("❌ Failed Positions:", #(self.FailedPositions or {}))
    
    print("===========================")
end

function AutoPlay:DebugHotbar()
    print("🎯 ====== HOTBAR DEBUG ======")
    
    -- ตรวจสอบ HUD Units Module
    print("HUDUnitsModule:", HUDUnitsModule ~= nil)
    if HUDUnitsModule then
        print("  _Cache:", HUDUnitsModule._Cache ~= nil)
        if HUDUnitsModule._Cache then
            for i, v in pairs(HUDUnitsModule._Cache) do
                print("    Slot", i, ":", type(v), v ~= "None" and "has unit" or "empty")
            end
        end
    end
    
    -- ตรวจสอบ UnitsData
    print("UnitsData:", UnitsData ~= nil)
    if UnitsData then
        local count = 0
        pcall(function()
            if UnitsData.GetAllUnits then
                local all = UnitsData:GetAllUnits()
                for _ in pairs(all) do count = count + 1 end
            elseif UnitsData._Units then
                for _ in pairs(UnitsData._Units) do count = count + 1 end
            end
        end)
        print("  Total Units in Data:", count)
    end
    
    -- ตรวจสอบ Hotbar UI
    print("Hotbar UI:")
    pcall(function()
        local HotbarUI = PlayerGui:FindFirstChild("Hotbar")
        if HotbarUI then
            print("  Found Hotbar UI")
            local Main = HotbarUI:FindFirstChild("Main")
            if Main then
                local Units = Main:FindFirstChild("Units")
                if Units then
                    for i = 1, 6 do
                        local slot = Units:FindFirstChild(tostring(i))
                        if slot then
                            local template = slot:FindFirstChild("UnitTemplate")
                            print("    Slot", i, ":", template and "has template" or "empty")
                        end
                    end
                end
            end
        else
            print("  Hotbar UI not found")
        end
    end)
    
    print("==============================")
end

-- DebugMap: แสดงตำแหน่งที่วางได้
function AutoPlay:DebugMap()
    print("🗺️ ====== MAP DEBUG ======")
    
    local Map = workspace:FindFirstChild("Map")
    if not Map then
        print("❌ Map not found!")
        return
    end
    
    print("✅ Map found:", Map:GetFullName())
    
    -- หา Placement parts
    local placementParts = {}
    for _, part in ipairs(Map:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            if name:find("placement") or name:find("place") or name:find("tower") then
                table.insert(placementParts, part)
            end
        end
    end
    
    print("📍 Placement Parts found:", #placementParts)
    for i, part in ipairs(placementParts) do
        if i <= 10 then -- แสดงแค่ 10 อันแรก
            print(string.format("   %d. %s at (%.1f, %.1f, %.1f) size: (%.1f, %.1f, %.1f)", 
                i, part.Name,
                part.Position.X, part.Position.Y, part.Position.Z,
                part.Size.X, part.Size.Y, part.Size.Z
            ))
        end
    end
    
    -- หาตำแหน่งที่ใช้ได้
    local allPositions = self:GetAllValidPositions()
    print("📍 Valid Positions found:", #allPositions)
    
    -- หาจาก FindPlacementPosition
    local foundPos = self:FindPlacementPosition()
    if foundPos then
        print("📍 FindPlacementPosition:", foundPos.X, foundPos.Y, foundPos.Z)
    else
        print("❌ FindPlacementPosition: No position found")
    end
    
    -- แสดง Failed Positions
    self.FailedPositions = self.FailedPositions or {}
    print("❌ Failed Positions:", #self.FailedPositions)
    
    -- แสดง UnitPlacementHandler
    print("UnitPlacementHandler:", UnitPlacementHandler ~= nil)
    
    print("==============================")
end

-- ==================== INIT ====================
task.wait(2) -- รอให้เกมโหลด

-- Auto start
AutoPlay:Start()

-- Export
getgenv().AutoPlay = AutoPlay

print("🎮 Commands:")
print("   AutoPlay:Start()  - เริ่มระบบ")
print("   AutoPlay:Stop()   - หยุดระบบ")
print("   AutoPlay:Debug()  - แสดงข้อมูล debug (+ MaxUnits from game)")
print("   AutoPlay:DebugHotbar() - ตรวจสอบ Hotbar")
print("   AutoPlay:DebugMap()    - ตรวจสอบ Map และตำแหน่งวาง")
print("   AutoPlay:RefreshMaxUnits() - รีเฟรช MaxUnits จากเกม")
print("   AutoPlay:ResetPositions() - reset ตำแหน่งวาง")
print("   AutoPlay:TogglePlace()   - เปิด/ปิด Auto Place")
print("   AutoPlay:ToggleSkip()    - เปิด/ปิด Auto Skip")
print("   AutoPlay:ToggleUpgrade() - เปิด/ปิด Auto Upgrade")
print("   AutoPlay:ToggleAbility() - เปิด/ปิด Auto Ability")

return AutoPlay
