

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
local PlayersStats = Workspace:WaitForChild("PlayerStats")
local Player_Folder = PlayersStats:WaitForChild(Client.Name)
local Data = Player_Folder:WaitForChild("T"):WaitForChild(Client.Name)

if game.GameId ~= 5750914919 then return warn("Doesn't match ID") end
repeat task.wait() 
    PlayersStats = Workspace:WaitForChild("PlayerStats",3) print(PlayersStats)
    Player_Folder = PlayersStats:WaitForChild(Client.Name,3) print(Player_Folder)
    Data = Player_Folder:WaitForChild("T"):WaitForChild(Client.Name,3) print(Data)
until Data
print("Loading..") 
local Client_= game:GetService("ReplicatedStorage"):WaitForChild("client")
local LegacyControllers = Client_:WaitForChild("legacyControllers")
local DataController = require(LegacyControllers:WaitForChild("DataController"))

local Url = "https://api.championshop.date"
local List = {
    "coins",
    "level",
    "rod",
    "xp",
    "bait",
}
task.wait(1.5)

-- local url = "https://api.championshop.date/logs"
local Settings = {
    ["Cooldown"] = 180,
    ["Item List"] = {
        "Amethyst",
        "Ruby",
        "Opal",
        "Lapis Lazuli",
        "Moonstone",
        "Driftwood",
        "Wood",
        "Magic Thread",
        "Ancient Thread",
        "Lunar Thread",
        "Golden Sea Pearl",
        "Meg's Fang",
        "Meg's Spine",
        "Magic Thread",
        "Ancient Thread",
        "Lunar Thread",
        "Aurora Totem",
        "Eclipse Totem",
        "Meteor Totem",
        "Smokescreen Totem",
        "Sundial Totem",
        "Tempest Totem",
        "Windset Totem",
    },
    ["Ignore Mutation"] = {
        "",
    },
}

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
    for i,v in pairs(Data["Stats"]:GetChildren()) do
        if table.find(List,v.Name) then
            local NewVal = v.Name == "coins" and v
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
    local Rod_All = {}
    local FishCahce = {}
    
    for i,v in pairs(DataController.fetch("Inventory")) do
        local data = v["sub"]
        if not table.find(Settings["Item List"],data["Name"]) then
            continue;
        end
        local ID = data["Name"]
        if data["Mutation"] and not table.find(Settings["Ignore Mutation"],data["Mutation"]) then
            ID = ID .. "_" .. data["Mutation"]
        end
        if not FishCahce[ID] then
            FishCahce[ID] = 0
        end
        FishCahce[ID] = FishCahce[ID] + data["Stack"]
    end

    for i,v in pairs(Data.Rods:GetChildren()) do
        table.insert(Rod_All,v.Name)
    end
    return {
        ["Inventory"] = FishCahce,
        ["Username"] = Client.Name,
        ["PlayerData"] = LocalData_,
        ["All_Rod"] = Rod_All,
    }
end

local Data = GetAllData()
SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})

task.spawn(function ()
    local Fishs = {}
    local Index = 0
    ReplicatedStorage.events.anno_catch.OnClientEvent:Connect(function(b)
        Fishs[tostring(Index)] = b
        Index = Index + 1
    end)
    while true do task.wait(10)
        local Data = GetAllData()
        local Weather = {}
        for i,v in pairs(ReplicatedStorage.world:GetChildren()) do
            Weather[v.Name] = v.Value
        end
        local StageInfo = {
            ["win"] = true,
            ["map"] = {
                ["name"] = (Client.Character and Client.Character:FindFirstChild("zone") and Client.Character.zone.Value.Name) or "Died",
                ["chapter"] = Weather,
                ["wave"] = "1",
                ["mode"] = "None",
                ["difficulty"] = "None",
            },
        }
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = Fishs},{["state"] = StageInfo},{["time"] = 1},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
        Index = 0
        Fishs = {} 
    end
end)

-- GetSomeCurrency()