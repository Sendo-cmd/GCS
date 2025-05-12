-- Variables
local plr = game.Players.LocalPlayer
local url = "https://api.championshop.date/log-arx"
local VisualEvent = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Remote = ReplicatedStorage:WaitForChild("Remote")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Server = Remote:WaitForChild("Server")
local Client = Remote:WaitForChild("Client")
local Data = ReplicatedStorage.Player_Data[plr.Name]
local LocalData = Data:WaitForChild("Data")
local Collection = Data:WaitForChild("Collection")
local UnitData = require(Shared.Info.Units)

if not Workspace:FindFirstChild("WayPoint") then
    local Units = {}
    local Items = {}
    local EquippedUnits = {}
    local PStats = {}
    local PDatas = {}
    for i,v in pairs(Data.Stats:GetChildren()) do
        PStats[v.Name] = v.Value
    end
    for i,v in pairs(Data.Items:GetChildren()) do
        Items[v.Name] = v["Amount"]["Value"]
    end
    for i,v in pairs(LocalData:GetChildren()) do
        PDatas[v.Name] = v.Value
    end
    for i,v in pairs(Collection:GetChildren()) do
        local CutShiny = v.Name:match("Shiny") and v.Name:split(":")[1] or v.Name
        local U_LocalData = UnitData[CutShiny]
        print(U_LocalData,UnitData,UnitData[v.Name],v.Name)
        Units[v["Tag"].Value] = {
            ["Unit"] = U_LocalData["DisplayName"],
            ["Rarity"] = U_LocalData["Rarity"],
            ["Level"] = v["Level"].Value,
            ["Exp"] = v["Exp"].Value,
            ["Trait 1"] = v["PrimaryTrait"].Value,
            ["Trait 2"] = v["SecondaryTrait"].Value,
            ["Potential"] = {
                ["DMG"] = v["DamagePotential"].Value,
                ["CD"] = v["AttackCooldownPotential"].Value,
                ["HP"] = v["HealthPotential"].Value,
                ["RNG"] = v["RangePotential"].Value,
                ["SPD"] = v["SpeedPotential"].Value
            },
        }
    end
    for i = 1,6 do 
        local UnitLoadout = LocalData["UnitLoadout" .. i].Value 
        if #UnitLoadout > 2 then
            EquippedUnits["UnitLoadout" .. i] = Units[UnitLoadout]
        end 
    end
    print("AA")
    local response = request({
        ["Url"] = url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json"
        },
        ["Body"] = HttpService:JSONEncode({
            ["Event"] = "Lobby",
            ["Method"] = "Update",
            ["Units"] = Units,
            ["EquippedUnits"] = EquippedUnits,
            ["Items"] = Items,
            ["Stats"] = PStats,
            ["Username"] = plr.Name,
            ["PlayerData"] = PDatas,
            ["GuildId"] = "467359347744309248",
            ["DataKey"] = "GamingChampionShopAPI",
        })
    })
else
    local Units = {}
    local Items = {}
    local EquippedUnits = {}
    local PStats = {}
    local PDatas = {}
    for i,v in pairs(Data.Stats:GetChildren()) do
        PStats[v.Name] = v.Value
    end
    for i,v in pairs(Data.Items:GetChildren()) do
        Items[v.Name] = v["Amount"]["Value"]
    end
    for i,v in pairs(LocalData:GetChildren()) do
        PDatas[v.Name] = v.Value
    end
    for i,v in pairs(Collection:GetChildren()) do
        local CutShiny = v.Name:match("Shiny") and v.Name:split(":")[1] or v.Name
        local U_LocalData = UnitData[CutShiny]
        print(U_LocalData,UnitData,UnitData[v.Name],v.Name)
        Units[v["Tag"].Value] = {
            ["Unit"] = U_LocalData["DisplayName"],
            ["Rarity"] = U_LocalData["Rarity"],
            ["Level"] = v["Level"].Value,
            ["Exp"] = v["Exp"].Value,
            ["Trait 1"] = v["PrimaryTrait"].Value,
            ["Trait 2"] = v["SecondaryTrait"].Value,
            ["Potential"] = {
                ["DMG"] = v["DamagePotential"].Value,
                ["CD"] = v["AttackCooldownPotential"].Value,
                ["HP"] = v["HealthPotential"].Value,
                ["RNG"] = v["RangePotential"].Value,
                ["SPD"] = v["SpeedPotential"].Value
            },
        }
    end
    for i = 1,6 do 
        local UnitLoadout = LocalData["UnitLoadout" .. i].Value 
        if #UnitLoadout > 2 then
            EquippedUnits["UnitLoadout" .. i] = Units[UnitLoadout]
        end 
    end
    local WinOrLose = "Losed"
    game:GetService("ReplicatedStorage").Remote.Client.UI.GameEndedUI.OnClientEvent:Connect(function(Type,Value)
        if Type == "Rewards - Items" then
             local response = request({
                ["Url"] = url,
                ["Method"] = "POST",
                ["Headers"] = {
                    ["content-type"] = "application/json"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["Event"] = "Playing",
                    ["WinOrLose"] = WinOrLose,
                    ["Method"] = "Update",
                    ["Rewards"] = Value,
                    ["Units"] = Units,
                    ["EquippedUnits"] = EquippedUnits,
                    ["Items"] = Items,
                    ["Stats"] = PStats,
                    ["Username"] = plr.Name,
                    ["PlayerData"] = PDatas,
                    ["GuildId"] = "467359347744309248",
                    ["DataKey"] = "GamingChampionShopAPI",
                })
            })
        elseif Type == "GameEnded_TextAnimation" then
            WinOrLose = Value
        end 
    end)
end

