-- TF_Test.lua - ทดสอบระบบต่างๆ ใน The Forge

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Plr = Players.LocalPlayer

-- ===== SETTINGS =====
local Settings = {
    ["Select Rocks"] = {"Pebble"},  -- เปลี่ยนชื่อหินที่ต้องการฟาร์ม
    ["Auto Farm"] = true,
}

-- ===== SETUP =====
local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local PlayerController = Knit.GetController("PlayerController")
local Ores = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Ore"))
local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))

-- Remotes
local ToolActivated = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated")

-- ===== HELPER FUNCTIONS =====
local function IsAlive()
    local Char = Plr.Character
    if not Char then return false end
    local Humanoid = Char:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return false end
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    return true
end

local function GetNearestRock()
    if not IsAlive() then return nil end
    local Char = Plr.Character
    local HRP = Char.HumanoidRootPart
    local p_pos = HRP.Position
    
    local nearest = nil
    local nearestDis = math.huge
    
    for _, folder in pairs(workspace.Rocks:GetChildren()) do
        if folder:IsA("Folder") then
            for _, child in pairs(folder:GetChildren()) do
                local Model = child:FindFirstChildWhichIsA("Model")
                if Model and Model:GetAttribute("Health") and Model:GetAttribute("Health") > 0 then
                    if table.find(Settings["Select Rocks"], Model.Name) then
                        local OriginalCFrame = Model:GetAttribute("OriginalCFrame")
                        if OriginalCFrame then
                            local Pos = OriginalCFrame.Position
                            local dis = (Pos - p_pos).Magnitude
                            if dis < nearestDis then
                                nearest = Model
                                nearestDis = dis
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local function AttackRock()
    pcall(function()
        ToolActivated:InvokeServer("Pickaxe")
    end)
end

-- ===== AUTO FARM ROCK =====
local function AutoFarmRock()
    print("\n========== AUTO FARM ROCK ==========")
    print("Target Rocks:", table.concat(Settings["Select Rocks"], ", "))
    print("=====================================\n")
    
    while Settings["Auto Farm"] do
        task.wait(0.1)
        
        if not IsAlive() then
            print("[Farm] รอ respawn...")
            repeat task.wait(0.5) until IsAlive()
            task.wait(2)
        end
        
        -- เช็ค inventory เต็มหรือยัง
        if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
            print("[Farm] กระเป๋าเต็ม! หยุดฟาร์ม")
            break
        end
        
        local Rock = GetNearestRock()
        
        if Rock then
            local Position = Rock:GetAttribute("OriginalCFrame").Position
            local LastAttack = 0
            local LastTween = nil
            
            print("[Farm] พบ:", Rock.Name, "| HP:", Rock:GetAttribute("Health"))
            
            while Rock and Rock.Parent and Rock:GetAttribute("Health") and Rock:GetAttribute("Health") > 0 do
                task.wait(0.1)
                
                if not IsAlive() then break end
                if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then break end
                
                local Char = Plr.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") then break end
                
                local HRP = Char.HumanoidRootPart
                local Magnitude = (HRP.Position - Position).Magnitude
                
                if Magnitude < 15 then
                    -- ใกล้พอ - ตี
                    if LastTween then LastTween:Cancel() end
                    
                    if tick() > LastAttack then
                        AttackRock()
                        LastAttack = tick() + 0.2
                    end
                    
                    -- ยืนใกล้หิน
                    HRP.CFrame = CFrame.new(Position + Vector3.new(0, 0, 0.75))
                else
                    -- ไกล - เดินไป
                    if LastTween then LastTween:Cancel() end
                    LastTween = TweenService:Create(HRP, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                    LastTween:Play()
                end
            end
        else
            print("[Farm] ไม่พบหิน:", table.concat(Settings["Select Rocks"], ", "))
            task.wait(1)
        end
    end
    
    print("[Farm] หยุดฟาร์มแล้ว")
end

-- ===== TEST FUNCTIONS =====

-- ทดสอบดู Ore Data ทั้งหมด
local function TestOreData()
    print("\n========== ORE DATA ==========")
    for id, ore in pairs(Ores) do
        print(string.format("ID: %s | Name: %s | Rarity: %s", 
            tostring(id), 
            tostring(ore.Name), 
            tostring(ore.Rarity)
        ))
    end
    print("===============================\n")
end

-- ทดสอบดู Inventory
local function TestInventory()
    print("\n========== INVENTORY ==========")
    local inv = PlayerController.Replica.Data.Inventory
    for itemName, amount in pairs(inv) do
        if type(amount) == "number" and amount > 0 then
            print(string.format("%s: x%d", tostring(itemName), amount))
        end
    end
    print("================================\n")
end

-- ทดสอบจับคู่ Inventory กับ Ore Data
local function TestInventoryWithOreData()
    print("\n========== INVENTORY + ORE RARITY ==========")
    local inv = PlayerController.Replica.Data.Inventory
    
    local function GetOre(Name)
        for i, v in pairs(Ores) do
            if v["Name"] == Name then
                return v
            end 
        end
        return nil
    end
    
    local matched = {}
    local unmatched = {}
    
    for itemName, amount in pairs(inv) do
        if type(amount) == "number" and amount > 0 then
            local ore = GetOre(itemName)
            if ore then
                table.insert(matched, {
                    name = itemName,
                    amount = amount,
                    rarity = ore.Rarity
                })
            else
                table.insert(unmatched, {
                    name = itemName,
                    amount = amount
                })
            end
        end
    end
    
    -- เรียงตามจำนวน
    table.sort(matched, function(a, b) return a.amount > b.amount end)
    
    print("--- MATCHED (พบใน Ore Data) ---")
    for _, item in ipairs(matched) do
        print(string.format("  %s: x%d [%s]", item.name, item.amount, item.rarity))
    end
    
    print("\n--- UNMATCHED (ไม่พบใน Ore Data) ---")
    for _, item in ipairs(unmatched) do
        print(string.format("  %s: x%d", item.name, item.amount))
    end
    
    print("=============================================\n")
end

-- ทดสอบ GetRecipe
local function TestGetRecipe()
    print("\n========== TEST GET RECIPE ==========")
    
    local IgnoreRarity = {
        "Mythic",
        "Relic", 
        "Exotic",
        "Divine",
        "Unobtainable",
    }
    
    local function GetOre(Name)
        for i, v in pairs(Ores) do
            if v["Name"] == Name then
                return v
            end 
        end
        return nil
    end
    
    local availableOres = {}
    for oreName, oreAmount in pairs(PlayerController.Replica.Data.Inventory) do
        if type(oreAmount) == "number" and oreAmount > 0 then
            local Ore = GetOre(oreName)
            if Ore then
                local rarity = Ore["Rarity"]
                local ignored = table.find(IgnoreRarity, rarity)
                print(string.format("  %s: x%d [%s] %s", 
                    oreName, oreAmount, rarity,
                    ignored and "❌ IGNORED" or "✓ OK"
                ))
                if not ignored then
                    table.insert(availableOres, {
                        name = oreName,
                        amount = oreAmount,
                        rarity = rarity
                    })
                end
            end
        end
    end
    
    table.sort(availableOres, function(a, b)
        return a.amount > b.amount
    end)
    
    print("\n--- RECIPE (Top 4) ---")
    local Recipe = {}
    local Count = 0
    for i, oreData in ipairs(availableOres) do
        if i > 4 then break end
        Recipe[oreData.name] = oreData.amount
        Count = Count + oreData.amount
        print(string.format("  %d. %s: x%d [%s]", i, oreData.name, oreData.amount, oreData.rarity))
    end
    
    print(string.format("\nTotal: %d pieces", Count))
    print(Count >= 3 and "✓ CAN FORGE" or "❌ NOT ENOUGH (need 3+)")
    print("======================================\n")
end

-- ทดสอบดู Rarity ที่มีทั้งหมดใน Ore Data
local function TestAllRarities()
    print("\n========== ALL RARITIES IN ORE DATA ==========")
    local rarities = {}
    for id, ore in pairs(Ores) do
        if ore.Rarity then
            rarities[ore.Rarity] = (rarities[ore.Rarity] or 0) + 1
        end
    end
    
    for rarity, count in pairs(rarities) do
        print(string.format("  %s: %d ores", rarity, count))
    end
    print("===============================================\n")
end

-- ทดสอบดู Potion ใน Misc
local function TestPotions()
    print("\n========== POTIONS (Misc) ==========")
    local misc = PlayerController.Replica.Data.Misc
    if misc then
        for itemName, amount in pairs(misc) do
            if type(amount) == "number" then
                print(string.format("  %s: x%d", tostring(itemName), amount))
            end
        end
    else
        print("  No Misc data found")
    end
    print("=====================================\n")
end

-- ===== MENU =====
print("\n")
print("╔════════════════════════════════════╗")
print("║     TF_Test - Testing Script       ║")
print("╠════════════════════════════════════╣")
print("║ 1. TestOreData()                   ║")
print("║ 2. TestInventory()                 ║")
print("║ 3. TestInventoryWithOreData()      ║")
print("║ 4. TestGetRecipe()                 ║")
print("║ 5. TestAllRarities()               ║")
print("║ 6. TestPotions()                   ║")
print("║ 7. AutoFarmRock()                  ║")
print("╠════════════════════════════════════╣")
print("║ Settings[\"Select Rocks\"] = {...}   ║")
print("║ Settings[\"Auto Farm\"] = true/false ║")
print("╚════════════════════════════════════╝")
print("\n")

-- รันทดสอบอัตโนมัติ
print("=== AUTO RUN TESTS ===\n")

TestAllRarities()
task.wait(0.5)

TestInventoryWithOreData()
task.wait(0.5)

TestGetRecipe()
task.wait(0.5)

TestPotions()

print("\n=== TESTS COMPLETE ===")

-- เริ่ม Auto Farm (uncomment เพื่อเปิดใช้)
-- AutoFarmRock()
