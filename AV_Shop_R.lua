local Accounts = {
    ["paopaoforgame"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
        ["TraitRerolls"] = 25
    },
    ["RiceBing"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
        ["TraitRerolls"] = 25
    },
    ["TONKAORIKI_NEW"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
        ["TraitRerolls"] = 25
    },
    ["GoodxABA"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
        ["TraitRerolls"] = 25
    },
    ["Xeonerct"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
        ["TraitRerolls"] = 25
    },
    ["M_Darknesss"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["Fortune Catalyst (Slayer)"] = 100,
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
if getgenv().RaidsUpdateQuantity then getgenv().RaidsUpdateQuantity:Disconnect() end
getgenv().RaidsUpdateQuantity = UpdateItemQuantity.OnClientEvent:Connect(function(Table)
    Quantity = Table
end)

local ShopData = RaidShopData:GetAllShopDataFromRaid("Stage1")
for i,v in pairs(Quantity["Stage1"].ShopData) do
    local Item = Account[i]
    local ItemData = ShopData[i]
    local MaxQuantity = ItemData.MaxQuantity
    
    local RedWebs = plr:GetAttribute("RedWebs")
    if Item and Item > 0 and v > 0 then
        local Bought = MaxQuantity - v
        while Bought < Item and RedWebs >= ItemData["Price"] do
            RaidsShopEvent:FireServer("Purchase", { "Stage1", i })
            wait(0.1)
            RedWebs = plr:GetAttribute("RedWebs")
            Bought += 1
        end
    end
end