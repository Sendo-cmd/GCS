local Accounts = {
    ["Champandbank147"] = {
        ["Slayer's Cape"] = 10,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["TraitRerolls"] = 25,
        ["Fortune Catalyst (Slayer)"] = 100
    },
    ["Nachosmayo"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["TraitRerolls"] = 25,
        ["Fortune Catalyst (Slayer)"] = 100
    },
    ["maser080"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["TraitRerolls"] = 25,
        ["Fortune Catalyst (Slayer)"] = 100
    },
    ["wave125zing"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["TraitRerolls"] = 25,
        ["Fortune Catalyst (Slayer)"] = 100
    },
    ["RiceBing"] = {
        ["Slayer's Cape"] = 1,
        ["Nichirin Cleavers"] = 1,
        ["Demon Beads"] = 1,
        ["TraitRerolls"] = 25,
        ["Fortune Catalyst (Slayer)"] = 100
    }
}

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")

local plr = Players.LocalPlayer

repeat task.wait() until not plr:GetAttribute("Loading")

local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

local IsMain = workspace:FindFirstChild("MainLobby")

if not IsMain then return end

local Account = nil
for i,v in pairs(Accounts) do
    if i == plr.Name or i:lower() == plr.Name:lower() then
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
            wait(1)
            RedWebs = plr:GetAttribute("RedWebs")
            Bought += 1
        end
    end
end