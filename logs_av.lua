
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
local Url = "https://api.championshop.date"
local List = {
    "IcedTea",
    "Flowers",
    "Gold",
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

local TableUtils = require(Utilities.TableUtils)

local function GetData()
    local SkinTable = {}
    local FamiliarTable = {}
    local Inventory = {}
    local EquippedUnits = {}
    local Units = {}
    local Battlepass = 0
    local Val_1,Val_2,Val_3 = false,false,false

    if game.PlaceId == 16146832113 then
        local ItemsData = require(Modules.Data.ItemsData)
        local UnitWindowHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.UnitWindowHandler)
        local BattlepassHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler)
        
        for i,v in pairs(UnitWindowHandler.EquippedUnits) do
            if i == "None" then continue end

            EquippedUnits[i] = TableUtils.DeepCopy(UnitWindowHandler._Cache[i])
            EquippedUnits[i].Name = EquippedUnits[i].UnitData.Name

            EquippedUnits[i].UnitData = nil
        end

        for i,v in pairs(UnitWindowHandler._Cache) do
            if not v.UnitData then continue end
            Units[i] = TableUtils.DeepCopy(v)
            Units[i].Name = v.UnitData.Name

            Units[i].UnitData = nil
        end
        game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(val)
            Inventory = {}
            for i,v in pairs(val) do
                if v then 
                    local call,err = pcall(function()
                        Inventory[i] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory[i]["ID"] = v["ID"]
                        Inventory[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            Val_1 = true
            print("Inventory Updated",os.time())
        end)
        game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent.OnClientEvent:Connect(function(val)
            FamiliarTable = val
            Val_2 = true
        end)
        game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent.OnClientEvent:Connect(function(val)
            SkinTable = val
            Val_3 = true
        end)
        Battlepass =  BattlepassHandler:GetPlayerData()
    else
        local UnitsHUD = require(game:GetService("StarterPlayer").Modules.Interface.Loader.HUD.Units)
        local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
        local UnitWindowHandler = require(game:GetService('StarterPlayer').Modules.Interface.Loader.Windows.UnitWindowHandler)
        for i, v in pairs(UnitWindowHandler["_Cache"]) do
            if not v.UnitData then continue end
            Units[i] = TableUtils.DeepCopy(v) 
            Units[i].Name = v.UnitData.Name

            Units[i].UnitData = nil
        end
        for i,v in pairs(UnitsHUD._Cache) do
            if v == "None" then continue end
            EquippedUnits[v.UniqueIdentifier] = TableUtils.DeepCopy(v)

            EquippedUnits[v.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v.Identifier).Name
        end
        
        local Inventory = {}
        game:GetService("ReplicatedStorage").Networking.InventoryEvent.OnClientEvent:Connect(function(val,val1)
            Inventory = {}
            for i,v in pairs(val1) do
                print(os.time(),i,v)
                if v then 
                    local call,err = pcall(function()
                        Inventory[i]["NAME"] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory[i]["ID"] = v["ID"]
                        Inventory[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            Val_1 = true
            print("Inventory Updated",os.time())
        end)
        game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent.OnClientEvent:Connect(function(val)
            FamiliarTable = val
            Val_2 = true
            print("Family Updated",os.time())
        end)
        game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent.OnClientEvent:Connect(function(val)
            SkinTable = val
            Val_3 = true
            print("Skin Updated",os.time())
        end)

    end
    local PlayerData = plr:GetAttributes()
    

    repeat 
        -- print("Stucking")
        if game.PlaceId == 16146832113 then
            game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer()
            game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
            game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()
        else
            game:GetService("ReplicatedStorage").Networking.InventoryEvent:FireServer()
            game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
            game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()
        end
        
        print(Val_3 , Val_2 , Val_1)
        task.wait(1) 
    until Val_3 and Val_2 and Val_1

    return {
        ["Units"] = Units,
        ["Skins"] = SkinTable,
        ["Familiars"] = FamiliarTable,
        ["Inventory"] = Inventory,
        ["Username"] = plr.Name,
        ["Battlepass"] = Battlepass,
        ["PlayerData"] = PlayerData,
        ["EquippedUnits"] = EquippedUnits,
    }
end
if IsMain then
    local Data = GetData()
    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
elseif IsMatch then
    warn("IN Match")
    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
    local BattlepassText = require(game:GetService("StarterPlayer").Modules.Visuals.Misc.Texts.BattlepassText)
    Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
        warn("SendTo 1")
        local ConvertResult = {}
        local StageInfo = {}
        local Times = 0
        local Data = GetData()
        local BattlePassXp = 0
        local BPPlay = BattlepassText.Play
        BattlepassText.Play = function(self, data)
            BattlePassXp += data[1]
            return BPPlay(self, data)
        end
         warn("SendTo 2")
        if BattlePassXp > 0 and Results.Rewards then
            Results.Rewards["Pass Xp"] = { ["Amount"] = BattlePassXp }
        end
        for i,v in pairs(Results["Rewards"]) do
            if v["Amount"] then
                ConvertResult[#ConvertResult + 1] = convertToField(i,v["Amount"])
                continue;
            end
            for i1,v1 in pairs(v) do
                ConvertResult[#ConvertResult + 1] = convertToField(i1,v1["Amount"])
            end
        end
         warn("SendTo 3")
        -- Create StageInfo
        if Results["Status"] == "Finished" then
            Times = Results["TimeTaken"]
            StageInfo["win"] = true
        else
            StageInfo["win"] = false
        end
         print("SendTo 4")
        if not StageInfo["map"] then
           
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
        print("SendTo 5")
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = Times},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
    end)
    warn("IN Match 1")
     local Data = GetData()
    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
    warn("IN Match 2")
end

