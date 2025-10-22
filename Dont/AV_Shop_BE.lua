local Accounts = {
    ["RiceBing"] = {
        ["Blood-Red Commander"] = 1,
        ["TraitRerolls"] = 50,
        ["Blue Essence Stone"] = 10,
        ["Red Essence Stone"] = 10,
        ["Purple Essence Stone"] = 10,
        ["Pink Essence Stone"] = 10,
        ["Stat Chip"] = 10,
        ["Green Essence Stone"] = 20,
        ["Rainbow Essence Stone"] = 10,
        ["Super Stat Chip"] = 10
    },
    ["narutoez441"] = {
        ["Blood-Red Commander"] = 1,
        ["TraitRerolls"] = 50,
        ["Blue Essence Stone"] = 10,
        ["Red Essence Stone"] = 10,
        ["Purple Essence Stone"] = 10,
        ["Pink Essence Stone"] = 10,
        ["Stat Chip"] = 10,
        ["Green Essence Stone"] = 20,
        ["Rainbow Essence Stone"] = 10,
        ["Super Stat Chip"] = 10
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

local BossEventShop = game:GetService("ReplicatedStorage").Networking.BossEvent.BossEventShop
local UpdateItemQuantity = game:GetService("ReplicatedStorage").Networking.BossEvent.UpdateItemQuantity
local BossEventShopData = require(Modules.Data.BossEvent.BossEventShopData)

UpdateItemQuantity:FireServer()
local Quantity = UpdateItemQuantity.OnClientEvent:Wait()
if getgenv().BossEventUpdateQuantity then getgenv().BossEventUpdateQuantity:Disconnect() end
getgenv().BossEventUpdateQuantity = UpdateItemQuantity.OnClientEvent:Connect(function(Table)
    Quantity = Table
end)

local ShopData = BossEventShopData:GetAllShopData()
for i,v in pairs(Quantity["IgrosEvent"].ShopData) do
    local Item = Account[i]
    local ItemData = ShopData[i]
    local MaxQuantity = ItemData.MaxQuantity
    
    local CommanderTokens = plr:GetAttribute("CommanderTokens")
    if Item and Item > 0 and v > 0 then
        local Bought = MaxQuantity - v
        while Bought < Item and CommanderTokens >= ItemData["Price"] do
            BossEventShop:FireServer("Purchase", i)
            wait(1)
            CommanderTokens = plr:GetAttribute("CommanderTokens")
            Bought += 1
        end
    end
end