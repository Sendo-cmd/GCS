
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
local Url = "https://api.championshop.date"
local List = {
    "Level",
    "Gold",
    "Gems",
    "TraitRerolls",
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

local url = "https://api.championshop.date/logs"
print(game.PlaceId)

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
            -- print(i,v)
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
        -- warn(i,v)
    end 
    return response
end
if IsTimeChamber then
    print("Time Chamber")
    SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = convertToField_(GetSomeCurrency())},{["state"] = {
                ["map"] = {
                        ["name"] = "AFK Time Chamber",
                        ["chapter"] = "AFK",
                        ["wave"] = "0",
                        ["mode"] = "AFK",
                        ["difficulty"] = "AFK"
                        },
                ["win"] = true,
            }},{["time"] = 0},{["currency"] = convertToField_(GetSomeCurrency())})
    while true do
        task.wait(200)
         SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = convertToField_(GetSomeCurrency())},{["state"] = {
                ["map"] = {
                        ["name"] = "AFK Time Chamber",
                        ["chapter"] = "AFK",
                        ["wave"] = "0",
                        ["mode"] = "AFK",
                        ["difficulty"] = "AFK"
                        },
                ["win"] = true,
            }},{["time"] = 200},{["currency"] = convertToField_(GetSomeCurrency())})
    end
    
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

    local InventoryEvent = game:GetService("StarterPlayer"):FindFirstChild("OwnedItemsHandler",true) or game:GetService("ReplicatedStorage").Networking:WaitForChild("InventoryEvent",2)
    local FamiliarsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedFamiliarsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("FamiliarsDataHandler",true)
    local SkinsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedSkinsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("SkinDataHandler",true)
    local UnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true)
    local EquippedUnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true) 
    local BattlepassHandler = game:GetService("StarterPlayer"):FindFirstChild("BattlepassHandler",true) and require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler):GetPlayerData() or function() return 0 end

    

    local ReqFamiliarsHandler = require(FamiliarsHandler)
    local ReqSkins = require(SkinsHandler)

    local ItemHandler = nil
    local FamiliarHandler = nil
    local SkinHandler = nil
    local UnitHandler = nil
    local EquippedUnitsHandler = nil

    print(InventoryEvent.Name)
    if InventoryEvent.Name == "OwnedItemsHandler" then
        ItemHandler = function()
            local Inventory_ = {}
            for i,v in pairs(require(InventoryEvent).GetItems()) do
                if v then 
                    local call,err = pcall(function()
                        Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory_[i]["ID"] = v["ID"]
                        Inventory_[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            return Inventory_
        end
    elseif InventoryEvent.Name == "InventoryEvent" then
        local Inventory_ = {}
        InventoryEvent.OnClientEvent:Connect(function(a,b)
            if a == "UpdateAll" then
                for i,v in pairs(b) do
                    if v then 
                        local call,err = pcall(function()
                            Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                            Inventory_[i]["ID"] = v["ID"]
                            Inventory_[i]["AMOUNT"] = v["Amount"]
                        end) 
                    end
                end
            end
        end)
        task.wait(1.5)
        InventoryEvent:FireServer("OwnedItems")
        ItemHandler = function()
            return Inventory_
        end
    end
    if FamiliarsHandler.Name == "OwnedFamiliarsHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetOwnedFamiliars
    elseif FamiliarsHandler.Name == "FamiliarsDataHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetFamiliarsData
    end
    if SkinsHandler.Name == "OwnedSkinsHandler" then
        SkinHandler = ReqSkins.GetOwnedSkins
    elseif SkinsHandler.Name == "SkinDataHandler" then
        SkinHandler = ReqSkins.GetPlayerSkins
    end
    
    UnitHandler = function()
        local Units_ = {}
        for i, v in pairs(require(UnitsModule).GetUnits()) do
            if not v.UnitData then continue end
            Units_[i] = TableUtils.DeepCopy(v) 
            Units_[i].Name = v.UnitData.Name

            Units_[i].UnitData = nil
        end
        return Units_
    end
    EquippedUnitsHandler = function()
        local EquippedUnits_ = {}
        local units = UnitHandler()
        local Handler = nil
        for i,v in pairs(require(EquippedUnitsModule).GetEquippedUnits()) do
            if v == "None" then continue end
            print(i,v)
            local v1 = units[v]
            EquippedUnits_[v1.UniqueIdentifier] = TableUtils.DeepCopy(v1)

            EquippedUnits_[v1.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v1.Identifier).Name
        end
        return EquippedUnits_
    end


    Battlepass =  BattlepassHandler
    Units = UnitHandler()
    EquippedUnits = EquippedUnitsHandler()
    FamiliarTable = FamiliarHandler()
    Inventory = ItemHandler()
    SkinTable = SkinHandler()

    local PlayerData = plr:GetAttributes()

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
-- setclipboard(HttpService:JSONEncode(GetData()))
if IsMain then
    local Data = GetData()
    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
elseif IsMatch then
    warn("IN Match")
    local Level = tonumber(plr:GetAttribute("Level"))
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
        if Level ~= tonumber(plr:GetAttribute("Level")) then
            ConvertResult[#ConvertResult + 1] = convertToField("Level",1)
            Level = tonumber(plr:GetAttribute("Level"))
        end
        if plr.PlayerGui:FindFirstChild("HUD") then
            print("Meee")
            local Map = plr.PlayerGui:FindFirstChild("HUD"):WaitForChild("Map")
            local StageRewards = Map:WaitForChild("StageRewards")
            local Leaves = StageRewards:WaitForChild("Leaves")
            print("Leaves",Leaves.Visible)
            if Leaves.Visible == true then
                LeavesPoint = tonumber(Leaves.Amount.Text:split("x")[2])
            end
              print("Leaves",LeavesPoint)
        end
        if LeavesPoint then
            ConvertResult[#ConvertResult + 1] = convertToField("Leaves",LeavesPoint)
        end
         warn("SendTo 3")
        -- Create StageInfo
        if Results["Status"] == "Finished" or Results["Act"] == "Infinite" then
            Times = Results["TimeTaken"]
            StageInfo["win"] = true
        else
            StageInfo["win"] = false
            Times = Results["TimeTaken"]
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

