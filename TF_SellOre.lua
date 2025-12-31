-- TF_SellOre.lua
-- Script สำหรับขาย Ore ตั้งแต่ Epic ลงไป

local Settings = {
    -- Rarity ที่จะไม่ขาย (เก็บไว้)
    ["Ignore Ore Rarity"] = {
        "Legendary",
        "Mythic",
        "Relic",
        "Exotic",
        "Divine",
        "Unobtainable",
    },
}

local HasTalkedToNPC = false

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plr = Players.LocalPlayer

repeat
    task.wait(15)
until getrenv()._G.ClientIsReady
task.wait(2)

local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local Ores = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Ore"))
local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))
local PlayerController = Knit.GetController("PlayerController")

local DialogueService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService")
local ProximityService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService")
local RunCommand = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand")

-- Function หา Ore จากชื่อ
local function GetOre(Name)
    for i, v in pairs(Ores) do
        if v["Name"] == Name then
            return v
        end
    end
    return false
end

-- Function เช็คว่า Rarity นี้ควรขายหรือไม่ (ขายถ้าไม่อยู่ใน Ignore list)
local function ShouldSell(Rarity)
    return not table.find(Settings["Ignore Ore Rarity"], Rarity)
end

-- Function คุยกับ NPC Greedy Cey (ครั้งเดียว)
local function TalkToNPC()
    if HasTalkedToNPC then return end
    
    pcall(function()
        -- คุยกับ Greedy Cey
        ProximityService:WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Greedy Cey"))
        task.wait(0.3)
        DialogueService:WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.3)
        HasTalkedToNPC = true
        print("คุยกับ NPC เรียบร้อย")
    end)
end

-- Function ขาย Ore ทั้งหมดที่ไม่อยู่ใน Ignore list
local function SellOres()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local SoldCount = 0
    local Basket = {}
    
    print("=== เริ่มขาย Ore ===")
    print("Rarity ที่จะไม่ขาย:", table.concat(Settings["Ignore Ore Rarity"], ", "))
    print("")
    
    -- วนหา Ore ใน Inventory แล้วใส่ Basket
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData and ShouldSell(OreData["Rarity"]) then
                print(string.format("พบ: %s (Rarity: %s) x%d", OreName, OreData["Rarity"], Amount))
                Basket[OreName] = Amount
                SoldCount = SoldCount + Amount
            end
        end
    end
    
    if SoldCount == 0 then
        print("ไม่มี Ore ที่ต้องขาย")
        return
    end
    
    print("")
    print(string.format("รวม Ore ที่จะขาย: %d ชิ้น", SoldCount))
    
    -- คุยกับ NPC ก่อน (ครั้งแรกเท่านั้น)
    TalkToNPC()
    
    print("กำลังขาย...")
    
    -- ขายด้วย SellConfirm
    pcall(function()
        RunCommand:InvokeServer("SellConfirm", {
            Basket = Basket
        })
    end)
    
    print("")
    print("=== ขายเสร็จสิ้น ===")
end

-- Function แสดง Ore ทั้งหมดใน Inventory
local function ShowInventory()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    
    print("=== Ore ใน Inventory ===")
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData then
                local shouldSell = ShouldSell(OreData["Rarity"]) and "[จะขาย]" or "[เก็บไว้]"
                print(string.format("%s %s (Rarity: %s) x%d", shouldSell, OreName, OreData["Rarity"], Amount))
            end
        end
    end
    print("========================")
end

-- เริ่มทำงาน
print("TF_SellOre Script Loaded!")
print("Commands:")
print("  _G.SellOres() - ขาย Ore ทั้งหมด (ยกเว้น Legendary ขึ้นไป)")
print("  _G.ShowInventory() - แสดง Ore ใน Inventory")
print("")

-- Export functions
_G.SellOres = SellOres
_G.ShowInventory = ShowInventory

-- แสดง Inventory ก่อน
ShowInventory()
