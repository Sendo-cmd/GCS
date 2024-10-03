local Accounts = {
    ["USERNAME"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 20,
        ["TraitRerolls"] = 25
    },
    ["USERNAME"] = {
        ["Slayer's Cape"] = 0,
        ["Nichirin Cleavers"] = 0,
        ["Demon Beads"] = 0,
        ["Fortune Catalyst (Slayer)"] = 0,
        ["TraitRerolls"] = 25
    },
    ["USERNAME"] = {
        ["Slayer's Cape"] = 0,
        ["Nichirin Cleavers"] = 0,
        ["Demon Beads"] = 0,
        ["Fortune Catalyst (Slayer)"] = 0,
        ["TraitRerolls"] = 25
    },
    ["USERNAME"] = {
        ["Slayer's Cape"] = 0,
        ["Nichirin Cleavers"] = 0,
        ["Demon Beads"] = 0,
        ["Fortune Catalyst (Slayer)"] = 0,
        ["TraitRerolls"] = 25
    },["USERNAME"] = {
        ["Slayer's Cape"] = 0,
        ["Nichirin Cleavers"] = 0,
        ["Demon Beads"] = 0,
        ["Fortune Catalyst (Slayer)"] = 0,
        ["TraitRerolls"] = 25
    }
}

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")

local plr = Players.LocalPlayer

repeat task.wait() until not plr:GetAttribute("Loading")

local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

local Account = nil
for i,v in pairs(Accounts) do
    if i == plr.Name or i:lower() == plr.Name then
        Account = v
    end
end

local RaidsShopEvent = game:GetService("ReplicatedStorage").Networking.Raids.RaidsShopEvent
local UpdateItemQuantity = game:GetService("ReplicatedStorage").Networking.Raids.UpdateItemQuantity
local RaidShopData = require(Modules.Data.Raids.RaidShopData)

UpdateItemQuantity:FireServer()
local Quantity = UpdateItemQuantity.OnClientEvent:Wait()
if getgenv().UpdateQuantity then getgenv().UpdateQuantity:Disconnect() end
getgenv().UpdateQuantity = UpdateItemQuantity.OnClientEvent:Connect(function(Table)
    Quantity = Table
end)

local ShopData = RaidShopData:GetAllShopDataFromRaid("Stage1")
for i,v in pairs(Quantity["Stage1"].ShopData) do
    local Item = Account[i]
    local ItemData = ShopData[i]
    
    local RedWebs = plr:GetAttribute("RedWebs")
    if Item and Item > 0 and v > 0 and RedWebs >= ItemData["Price"] then
        for Num = 1, Item do
            RaidsShopEvent:FireServer("Purchase", { "Stage1", i })
            wait(0.1)
        end
    end
end