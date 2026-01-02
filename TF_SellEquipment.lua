-- TF_SellEquipment.lua
-- Script สำหรับขาย Equipment พร้อมคุยกับ NPC Marbles

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Plr = Players.LocalPlayer

-- รอให้เกมพร้อม
repeat
    task.wait(5)
until game:GetService("ReplicatedStorage"):FindFirstChild("Shared")

local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local PlayerController = Knit.GetController("PlayerController")

-- Settings - Equipment ที่ไม่ต้องการขาย (ใส่ชื่อ หรือ Rarity)
local Settings = {
    ["Ignore Equipment Names"] = {}, -- ใส่ชื่อ Equipment ที่ไม่ต้องการขาย
    ["Ignore Equipment Rarity"] = {
        "Mythic",
        "Relic", 
        "Exotic",
        "Divine",
        "Unobtainable",
    },
}

-- Function หาตำแหน่ง NPC
local function GetNPCPosition(npc)
    if npc:IsA("BasePart") then
        return npc.Position
    elseif npc.PrimaryPart then
        return npc.PrimaryPart.Position
    elseif npc:FindFirstChild("HumanoidRootPart") then
        return npc.HumanoidRootPart.Position
    elseif npc:FindFirstChild("Torso") then
        return npc.Torso.Position
    else
        local part = npc:FindFirstChildWhichIsA("BasePart")
        if part then 
            return part.Position 
        else
            return npc:GetPivot().Position
        end
    end
end

-- Function เช็คว่ายังมีชีวิตอยู่ไหม
local function IsAlive()
    local Char = Plr.Character
    if not Char then return false end
    local Humanoid = Char:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return false end
    if Humanoid.Health <= 0 then return false end
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    return true
end

-- Function วาร์ปไปหา NPC
local function TeleportToNPC(npcName)
    local success = false
    pcall(function()
        local npc = workspace:WaitForChild("Proximity"):WaitForChild(npcName)
        local npcPos = GetNPCPosition(npc)
        
        if npcPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(npcPos + Vector3.new(0, 0, 5))
            task.wait(0.5)
        end
        
        task.wait(0.3)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(npc)
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.5)
        success = true
    end)
    return success
end

-- Function เช็คว่าควรขาย Equipment นี้หรือไม่
local function ShouldSellEquipment(equipData)
    -- เช็คชื่อ
    if equipData["Name"] and table.find(Settings["Ignore Equipment Names"], equipData["Name"]) then
        return false
    end
    -- เช็ค Rarity
    if equipData["Rarity"] and table.find(Settings["Ignore Equipment Rarity"], equipData["Rarity"]) then
        return false
    end
    return true
end

-- Function ขาย Equipment ทั้งหมด
local function SellAllEquipments()
    local soldCount = 0
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    
    print("[SellEquipment] Found", #Equipments, "equipments in inventory")
    
    for i, v in pairs(Equipments) do
        if v["GUID"] then
            print("[SellEquipment] Checking:", v["Name"] or "Unknown", "| GUID:", v["GUID"], "| Rarity:", v["Rarity"] or "Unknown")
            
            if ShouldSellEquipment(v) then
                task.wait(0.5)
                local sellSuccess = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                        Basket = {
                            [v["GUID"]] = true,
                        }
                    })
                end)
                
                if sellSuccess then
                    print("[SellEquipment] Sold:", v["Name"] or v["GUID"])
                    soldCount = soldCount + 1
                else
                    warn("[SellEquipment] Failed to sell:", v["Name"] or v["GUID"])
                end
            else
                print("[SellEquipment] Skipped (protected):", v["Name"] or v["GUID"])
            end
        end
    end
    return soldCount
end

-- Function หลัก: คุยกับ NPC Marbles แล้วขาย Equipment
local function SellEquipmentsWithNPC()
    if not IsAlive() then
        warn("[SellEquipment] Player is not alive!")
        return false
    end
    
    print("[SellEquipment] Teleporting to Marbles...")
    local talked = TeleportToNPC("Marbles")
    
    if talked then
        task.wait(1) -- รอ NPC dialogue เปิด
        print("[SellEquipment] Selling equipments...")
        local sold = SellAllEquipments()
        print("[SellEquipment] Sold", sold, "equipments!")
        return true
    else
        warn("[SellEquipment] Failed to talk to Marbles!")
        return false
    end
end

-- ============================================
-- Auto Sell Loop (เปิด/ปิดได้)
-- ============================================
local AutoSellEnabled = false
local AutoSellInterval = 60 -- วินาที

-- เริ่ม Auto Sell
local function StartAutoSell()
    AutoSellEnabled = true
    task.spawn(function()
        while AutoSellEnabled do
            task.wait(AutoSellInterval)
            if IsAlive() then
                local equipCount = 0
                for i, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
                    if v["GUID"] and ShouldSellEquipment(v) then
                        equipCount = equipCount + 1
                    end
                end
                
                if equipCount > 0 then
                    print("[SellEquipment] Auto selling", equipCount, "equipments...")
                    SellEquipmentsWithNPC()
                end
            end
        end
    end)
    print("[SellEquipment] Auto Sell started! Interval:", AutoSellInterval, "seconds")
end

-- หยุด Auto Sell
local function StopAutoSell()
    AutoSellEnabled = false
    print("[SellEquipment] Auto Sell stopped!")
end

-- ============================================
-- Export Functions
-- ============================================
_G.SellEquipment = {
    Sell = SellEquipmentsWithNPC,
    SellOnly = SellAllEquipments,
    TalkToMarbles = function() return TeleportToNPC("Marbles") end,
    StartAutoSell = StartAutoSell,
    StopAutoSell = StopAutoSell,
    SetInterval = function(seconds) AutoSellInterval = seconds end,
}

print("[SellEquipment] Script loaded!")
print("  - _G.SellEquipment.Sell() = ขายพร้อมคุยกับ NPC")
print("  - _G.SellEquipment.SellOnly() = ขายอย่างเดียว")
print("  - _G.SellEquipment.TalkToMarbles() = คุยกับ Marbles")
print("  - _G.SellEquipment.StartAutoSell() = เริ่ม Auto Sell")
print("  - _G.SellEquipment.StopAutoSell() = หยุด Auto Sell")
