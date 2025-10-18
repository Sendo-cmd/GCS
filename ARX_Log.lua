
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local Client = Players.LocalPlayer
-- Folder
local Remote = ReplicatedStorage:WaitForChild("Remote")
local Values = ReplicatedStorage:WaitForChild("Values")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Info = Shared:WaitForChild("Info")
local All_Players = ReplicatedStorage:WaitForChild("Player_Data")
local UnitData = require(Shared.Info.Units)

local Player = All_Players:WaitForChild(Client.Name,5)
local LocalData = Player:WaitForChild("Data")
local Collection = Player:WaitForChild("Collection")

if game.GameId ~= 6884266247 then return warn("Doesn't match ID") end
repeat task.wait() until Client:GetAttribute("ClientLoaded")
print("Loading..") 



local Url = "https://api.championshop.date"
local List = {
    "BattlepassLevel",
    "Gold",
    "Gem",
    "Level",
    "Magic Flower",
    "Raid Currency"
}
task.wait(1.5)

local url = "https://api.championshop.date/logs"


local function convertToField(index,value)
    return {
        ["name"] = index,
        ["value"] = value or 1
    }
end
local function convertToField_(table_)
    local Field = {}
    for i,v in pairs(table_) do
        Field[#Field + 1] = convertToField(i,v)
    end
    return Field
end
local function GetSomeCurrency()
    local Field = {}
    for i,v in pairs(LocalData:GetChildren()) do
        if table.find(List,v.Name) then
            print(v.Name,v.Value)
            Field[v.Name] = v.Value
        end
    end
    return Field
end
local function CreateBody(...)
    local Data = request({
        ["Url"] = Url .. "/api/v1/shop/orders/" .. Client.Name,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    print(Data["Success"])
    local Order_Data = HttpService:JSONDecode(Data["Body"])["data"]
    local body = {
        ["order_id"] = Order_Data[1]["id"],
    }
    local array = {...}
    for i,v in pairs(array) do
        for i1,v1 in pairs(v) do
            body[i1] = v1
        end
    end
    return body
end
local function SendTo(Url,...)
    warn("Hi")
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
    for i,v in pairs(response) do
        warn(i,v)
    end 
    return response
end
local function GetAllData()
    local LocalData_ = GetSomeCurrency()
    local Units = {}
    local Inventory = {}
    local EquippedUnits = {}
    for i,v in pairs(Player.Items:GetChildren()) do
        Inventory[v.Tag.Value] = {
            ["ID"] = v.Name,
            ["AMOUNT"] = v["Amount"]["Value"],
        } 
    end
    for i,v in pairs(Collection:GetChildren()) do
        local CutShiny = v.Name:match("Shiny") and v.Name:split(":")[1] or v.Name
        local U_LocalData = UnitData[CutShiny]
        print(U_LocalData,UnitData,UnitData[v.Name],v.Name)
        Units[v["Tag"].Value] = {
            ["Name"] = U_LocalData["DisplayName"],
            ["Rarity"] = U_LocalData["Rarity"],
            ["Level"] = v["Level"].Value,
            ["Exp"] = v["Exp"].Value,
            ["Shiny"] = v.Name:match("Shiny") and true or false,
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
    return {
        ["Units"] = Units,
        ["Inventory"] = Inventory,
        ["Username"] = Client.Name,
        ["Battlepass"] = LocalData_["BattlepassLevel"],
        ["PlayerData"] = LocalData_,
        ["EquippedUnits"] = EquippedUnits,
    }
end
-- setclipboard(HttpService:JSONEncode(GetAllData()))
if not Workspace:FindFirstChild("WayPoint") then
    local Data = GetAllData()
    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
else
    local Sending = false
    local WinOrLose = false
    local Rewards = {}
    local Times = 0
    game:GetService("ReplicatedStorage").Remote.Client.UI.GameEndedUI.OnClientEvent:Connect(function(Type,Value)
        if Type == "Rewards - Items" then
            Rewards = {}
            Rewards = Value
            Sending = true
        elseif Type == "GameEnded_TextAnimation" then
            WinOrLose = Value ~= "Defeat" and true or false
            if not Sending then
                Sending = true
                task.delay(1.5,function()
                    
                    Sending = false
                    local RewardsUI = Client.PlayerGui:WaitForChild("RewardsUI"):WaitForChild("Main"):WaitForChild("LeftSide")
                    local ConvertResult = {}
                    local StageInfo = {
                        ["win"] = WinOrLose,
                        ["map"] = {
                            ["name"] = RewardsUI["World"]["Text"],
                            ["chapter"] = RewardsUI["Chapter"]["Text"],
                            ["wave"] = "",
                            ["mode"] = RewardsUI["Mode"]["Text"],
                            ["difficulty"] = RewardsUI["Difficulty"]["Text"],
                        },
                    }
                    local Data = GetAllData()
                    
                    for i,v in pairs(Rewards) do
                        ConvertResult[#ConvertResult + 1] = convertToField(v.Name,v.Amount.Value)
                    end
                    -- setclipboard({["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = Times},{["currency"] = convertToField_(GetSomeCurrency())})
                    SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = Times},{["currency"] = convertToField_(GetSomeCurrency())})
                    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
                end)
            end
        elseif Type == "Update - EndedScreen" then
            Times = Value
            Times = 0
        end 
       
    end)
end 
-- GetSomeCurrency()