
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
local Url = "https://api.championshop.date"
local List = {
    "Gems"
}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

repeat task.wait(10) until not plr:GetAttribute("Loading")

local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
local Modules = ReplicatedStorage:WaitForChild("Modules")


task.wait(1.5)
local IsTimeChamber = game.PlaceId == 18219125606
local function convertToField(index,value)
    return {
        ["name"] = index,
        ["value"] = value
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
    for i,v in pairs(plr:GetAttributes()) do
        if table.find(List,i) then
            print(i,v)
            Field[i] = v
        end
    end
    return Field
end
local function CreateBody(...)
    local Data = request({
        ["Url"] = Url .. "/api/v1/shop/orders/" .. plr.Name,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
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
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
   
    return response
end
if IsTimeChamber then
    print("Time Chamber")
    local PlayerData = plr:GetAttributes()
    local function Send()
        local response = request({
            ["Url"] = url,
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] = "Update-AFK",
                ["Time Chamber"] = true,
                ["Username"] = plr.Name,
                ["PlayerData"] = PlayerData,
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
            })
        })
    end
    
    Send()
    game:GetService("Players").LocalPlayer:GetAttributeChangedSignal("GemsEarned"):Connect(function()
        Send()
    end)
    return false
end
local Networking = ReplicatedStorage:WaitForChild("Networking")

local SettingsHandler = require(PlayerModules.Gameplay.SettingsHandler)
local StagesData = require(Modules.Data.StagesData)
local UnitsData = require(Modules.Data.Entities.Units)
local ItemsData = require(Modules.Data.ItemsData)
repeat task.wait() until SettingsHandler.SettingsLoaded

local IsMain = workspace:FindFirstChild("MainLobby")
local IsMatch = plr:FindFirstChild("StageInfo")

local Utilities = Modules:WaitForChild("Utilities")

local Shared = Modules:WaitForChild("Shared")

local MultiplierHandler = require(Shared.MultiplierHandler)

local NumberUtils = require(Utilities.NumberUtils)
local TableUtils = require(Utilities.TableUtils)


if IsMain then
   
elseif IsMatch then
    local UnitsHUD = require(game:GetService("StarterPlayer").Modules.Interface.Loader.HUD.Units)
    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
    local BattlepassText = require(game:GetService("StarterPlayer").Modules.Visuals.Misc.Texts.BattlepassText)

    Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
        local ConvertResult = {}
        local StageInfo = {}
        local SkinTable = {}
        local FamiliarTable = {}
        local Inventory = {}
        local EquippedUnits = {}
        local Units = {}

        for i,v in pairs(UnitsHUD._Cache) do
            if not v.UnitData then continue end

            if not Units[v.UnitData.Rarity] then Units[v.UnitData.Rarity] = {} end

            Units[v.UnitData.Rarity][i] = TableUtils.DeepCopy(v)
            Units[v.UnitData.Rarity][i].Name = Units[v.UnitData.Rarity][i].UnitData.Name

            Units[v.UnitData.Rarity][i].UnitData = nil
        end
    
        for i,v in pairs(UnitsHUD._Cache) do
            if v == "None" then continue end
            EquippedUnits[v.UniqueIdentifier] = TableUtils.DeepCopy(v)

            EquippedUnits[v.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v.Identifier).Name
        end

        game:GetService("ReplicatedStorage").Networking.InventoryEvent.OnClientEvent:Connect(function(val,val1)
            Inventory = {}
            for i,v in pairs(val1) do
                if v then 
                    pcall(function()
                        Inventory[i]["NAME"] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory[i]["ID"] = v["ID"]
                        Inventory[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            print("Inventory Updated",os.time())
        end)
        game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent.OnClientEvent:Connect(function(val)
            FamiliarTable = val
            print("Family Updated",os.time())
        end)
        game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent.OnClientEvent:Connect(function(val)
            SkinTable = val
            print("Skin Updated",os.time())
        end)
        local Times = 0
        for i,v in pairs(Results["Rewards"]) do
            if v["Amount"] then
                ConvertResult[#ConvertResult + 1] = convertToField(i,v["Amount"])
                continue;
            end
            for i1,v1 in pairs(v) do
                ConvertResult[#ConvertResult + 1] = convertToField(i1,v1["Amount"])
            end
        end
        -- Create StageInfo
        if Results["Status"] == "Finished" then
            Times = Results["TimeTaken"]
            StageInfo["win"] = true
        else
            StageInfo["win"] = false
        end
        if not StageInfo["map"] then
            local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
            local GameData = GameHandler.GameData
        
            StageInfo["map"] = {
                ["name"] = Results["StageName"],
                ["chapter"] = Results["Act"],
                ["wave"] = Results["WavesCompleted"],
                ["mode"] = Results["StageType"],
                ["difficulty"] = Results["Difficulty"],
            }
            local bool,err = pcall(function()
                StageInfo["map"]["name"] = StagesData:GetStageData(GameData.StageType, GameData.Stage).Name
            end)
        end
        print("SendTo")
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = Times},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = FamiliarTable,["Skin"] = SkinTable,["Inventory"] = Inventory,["EquippedUnits"] = EquippedUnits,["Units"] = Units}})
    end)
end

