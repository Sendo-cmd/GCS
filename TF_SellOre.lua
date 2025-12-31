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
local InventoryService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService")
local RunCommand = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand")
local FavoriteItem = InventoryService:WaitForChild("RF"):WaitForChild("FavoriteItem")

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

-- Function เช็คว่า Item ถูก Favorite หรือไม่
local function IsFavorited(ItemName)
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local FavoritedItems = PlayerInventory.FavoritedItems
    
    if FavoritedItems and type(FavoritedItems) == "table" then
        return FavoritedItems[ItemName] == true or table.find(FavoritedItems, ItemName) ~= nil
    end
    return false
end

-- Function คุยกับ NPC Greedy Cey (ครั้งเดียว)
local function TalkToNPC()
    if HasTalkedToNPC then return end
    
    pcall(function()
        -- หา NPC Greedy Cey จาก workspace.Proximity
        local NPC = workspace:WaitForChild("Proximity"):FindFirstChild("Greedy Cey")
        
        -- วาร์ปไปหา NPC ถ้าเจอ
        if NPC then
            local NPCPosition = NPC:FindFirstChild("HumanoidRootPart") and NPC.HumanoidRootPart.Position
                or NPC:FindFirstChild("Torso") and NPC.Torso.Position
                or NPC:IsA("BasePart") and NPC.Position
                or NPC:GetPivot().Position
            
            if NPCPosition then
                local Character = Plr.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = CFrame.new(NPCPosition + Vector3.new(0, 0, 5))
                    print("วาร์ปไปหา NPC เรียบร้อย")
                    task.wait(0.5)
                end
            end
        end
        
        -- คุยกับ Greedy Cey
        ProximityService:WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Greedy Cey"))
        task.wait(0.3)
        DialogueService:WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.3)
        HasTalkedToNPC = true
        print("คุยกับ NPC เรียบร้อย")
    end)
end

-- Function ขาย Ore ทั้งหมดที่ไม่อยู่ใน Ignore list และไม่ถูก Favorite
local function SellOres()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local SoldCount = 0
    local Basket = {}
    local SkippedFavorites = {}
    
    print("=== เริ่มขาย Ore ===")
    print("Rarity ที่จะไม่ขาย:", table.concat(Settings["Ignore Ore Rarity"], ", "))
    print("ไอเทมที่ถูก Favorite จะไม่ถูกขาย")
    print("")
    
    -- วนหา Ore ใน Inventory แล้วใส่ Basket
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData and ShouldSell(OreData["Rarity"]) then
                -- เช็คว่า Item ถูก Favorite หรือไม่
                if IsFavorited(OreName) then
                    print(string.format("⭐ ข้าม (Favorite): %s (Rarity: %s) x%d", OreName, OreData["Rarity"], Amount))
                    table.insert(SkippedFavorites, OreName)
                else
                    print(string.format("พบ: %s (Rarity: %s) x%d", OreName, OreData["Rarity"], Amount))
                    Basket[OreName] = Amount
                    SoldCount = SoldCount + Amount
                end
            end
        end
    end
    
    if SoldCount == 0 then
        print("ไม่มี Ore ที่ต้องขาย")
        if #SkippedFavorites > 0 then
            print(string.format("ข้ามไอเทม Favorite: %d รายการ", #SkippedFavorites))
        end
        return
    end
    
    print("")
    print(string.format("รวม Ore ที่จะขาย: %d ชิ้น", SoldCount))
    if #SkippedFavorites > 0 then
        print(string.format("ข้ามไอเทม Favorite: %d รายการ", #SkippedFavorites))
    end
    
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
                local isFav = IsFavorited(OreName)
                local shouldSell = ShouldSell(OreData["Rarity"]) and not isFav
                local status = ""
                if isFav then
                    status = "[⭐ Favorite]"
                elseif shouldSell then
                    status = "[จะขาย]"
                else
                    status = "[เก็บไว้]"
                end
                print(string.format("%s %s (Rarity: %s) x%d", status, OreName, OreData["Rarity"], Amount))
            end
        end
    end
    print("========================")
end

-- Function Favorite Item
local function SetFavorite(ItemName)
    pcall(function()
        FavoriteItem:InvokeServer(ItemName)
        print(string.format("⭐ Favorite: %s", ItemName))
    end)
end

-- Function แสดง Favorited Items
local function ShowFavorites()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local FavoritedItems = PlayerInventory.FavoritedItems
    
    print("=== Favorited Items ===")
    if FavoritedItems and type(FavoritedItems) == "table" then
        for ItemName, Value in pairs(FavoritedItems) do
            if Value == true or type(Value) ~= "boolean" then
                print(string.format("⭐ %s", tostring(ItemName)))
            end
        end
    else
        print("ไม่มีไอเทมที่ Favorite")
    end
    print("========================")
end

-- เริ่มทำงาน
print("TF_SellOre Script Loaded!")
print("Commands:")
print("  _G.SellOres() - ขาย Ore ทั้งหมด (ยกเว้น Legendary ขึ้นไป และ Favorite Items)")
print("  _G.ShowInventory() - แสดง Ore ใน Inventory")
print("  _G.SetFavorite('ItemName') - Favorite/Unfavorite ไอเทม")
print("  _G.ShowFavorites() - แสดงไอเทมที่ Favorite")
print("")

-- Export functions
_G.SellOres = SellOres
_G.ShowInventory = ShowInventory
_G.SetFavorite = SetFavorite
_G.ShowFavorites = ShowFavorites

-- แสดง Inventory ก่อน
ShowInventory()
SellOres()