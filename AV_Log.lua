
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
    print("Lobby")
    local UnitWindowHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.UnitWindowHandler)
    local BattlepassHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler)
    local SkinTable = {}
    local Inventory = {}
    local FamiliarTable = {}
    local WorldLine = nil
    game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(val)
        Inventory = {}
        for i,v in pairs(val) do
            Inventory[i] = ItemsData.GetItemDataByID(true,v["ID"])
            Inventory[i]["ID"] = v["ID"]
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
    game:GetService("ReplicatedStorage").Networking.WorldlinesEvent.OnClientEvent:Connect(function(val,val1)
        WorldLine = val1["Season3"]["CurrentRoom"]
    end)
    
    repeat task.wait() until UnitWindowHandler.AreUnitsLoaded;
    game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer()
    game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
    game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()
    game:GetService("ReplicatedStorage").Networking.WorldlinesEvent:FireServer("RetrieveData")
    task.wait(1.5)

    local EquippedUnits = {}

    for i,v in pairs(UnitWindowHandler.EquippedUnits) do
        if i == "None" then continue end

        EquippedUnits[i] = TableUtils.DeepCopy(UnitWindowHandler._Cache[i])
        EquippedUnits[i].Name = EquippedUnits[i].UnitData.Name

        EquippedUnits[i].UnitData = nil
    end

    local Units = {}

    for i,v in pairs(UnitWindowHandler._Cache) do
        if not v.UnitData then continue end

        if not Units[v.UnitData.Rarity] then Units[v.UnitData.Rarity] = {} end

        Units[v.UnitData.Rarity][i] = TableUtils.DeepCopy(v)
        Units[v.UnitData.Rarity][i].Name = Units[v.UnitData.Rarity][i].UnitData.Name

        Units[v.UnitData.Rarity][i].UnitData = nil
    end

    local PlayerData = plr:GetAttributes()

    local VictoryCount = 0
    local calling,err = pcall(function()
        RequestTo = HttpService:JSONDecode(game:HttpGet("https://api.championshop.date/history-av/" .. game.Players.LocalPlayer.Name))
    end) 
    if calling then
        VictoryCount = RequestTo and RequestTo["value"] or 0
    end
    setclipboard(HttpService:JSONEncode({
        ["Method"] = "Update",
        ["WorldLine_Floor"] = WorldLine == nil and "Cannot Get Worldline" or WorldLine,
        ["Units"] = Units,
        ["Skins"] = SkinTable,
        ["Familiars"] = FamiliarTable,
        ["EquippedUnits"] = EquippedUnits,
        ["Inventory"] = Inventory,
        ["WinCounting"] = VictoryCount,
        ["Username"] = plr.Name,
        ["Battlepass"] = BattlepassHandler:GetPlayerData(),
        ["PlayerData"] = PlayerData,
        ["GuildId"] = "467359347744309248",
        ["DataKey"] = "GamingChampionShopAPI",
    }))
    local response = request({
        ["Url"] = url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json"
        },
        ["Body"] = HttpService:JSONEncode({
            ["Method"] = "Update",
            ["WorldLine_Floor"] = WorldLine == nil and "Cannot Get Worldline" or WorldLine,
            ["Units"] = Units,
            ["Skins"] = SkinTable,
            ["Familiars"] = FamiliarTable,
            ["EquippedUnits"] = EquippedUnits,
            ["Inventory"] = Inventory,
            ["WinCounting"] = VictoryCount,
            ["Username"] = plr.Name,
            ["Battlepass"] = BattlepassHandler:GetPlayerData(),
            ["PlayerData"] = PlayerData,
            ["GuildId"] = "467359347744309248",
            ["DataKey"] = "GamingChampionShopAPI",
        })
    })
elseif IsMatch then
    print("Match")
    local UnitsHUD = require(game:GetService("StarterPlayer").Modules.Interface.Loader.HUD.Units)
    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
    local BattlepassText = require(game:GetService("StarterPlayer").Modules.Visuals.Misc.Texts.BattlepassText)

    local SkinTable = {}
    local FamiliarTable = {}
    local Inventory = {}
    local WorldLine = nil
    game:GetService("ReplicatedStorage").Networking.InventoryEvent.OnClientEvent:Connect(function(val,val1)
         Inventory = {}
        for i,v in pairs(val1) do
            Inventory[i] = ItemsData.GetItemDataByID(true,v["ID"])
            Inventory[i]["ID"] = v["ID"]
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

    

    local BattlePassXp = 0
    local BPPlay = BattlepassText.Play
    BattlepassText.Play = function(self, data)
        BattlePassXp += data[1]
        return BPPlay(self, data)
    end
    local function Send(Results)
        print("Debug 1",Results)
        local Results = Results or {}
        local EquippedUnits = {}
        for i,v in pairs(UnitsHUD._Cache) do
            if v == "None" then continue end
            EquippedUnits[v.UniqueIdentifier] = TableUtils.DeepCopy(v)

            EquippedUnits[v.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v.Identifier).Name
        end
        game:GetService("ReplicatedStorage").Networking.InventoryEvent:FireServer()
        game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
        game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()


        task.wait(2)
        local GameData = GameHandler.GameData
        print("Debug 2",Results)
        local bool,err = pcall(function()
            Results["StageName"] = StagesData:GetStageData(GameData.StageType, GameData.Stage).Name
        end)
        if not bool then
            Results["StageName"] = GameData
            WorldLine = GameData["WorldlineRoom"]
        end

        if BattlePassXp > 0 and Results.Rewards then
            Results.Rewards["Pass Xp"] = { ["Amount"] = BattlePassXp }
        end
        local PlayerData = plr:GetAttributes()
        if Results["Status"] == "Finished" then
            task.spawn(function()
                local RequestTo = nil
                local VictoryCount = 0
                local calling,err = pcall(function()
                    RequestTo = HttpService:JSONDecode(game:HttpGet("https://api.championshop.date/history-av/" .. game.Players.LocalPlayer.Name))
                end) 
                if calling then
                    VictoryCount = RequestTo and RequestTo["value"] or 0
                end
                
                local response = request({
                    ["Url"] = "https://api.championshop.date/history-av",
                    ["Method"] = "POST",
                    ["Headers"] = {
                        ["content-type"] = "application/json"
                    },
                    ["Body"] = HttpService:JSONEncode({
                        ["index"] = game.Players.LocalPlayer.Name,
                        ["value"] = VictoryCount + 1,
                    })
                })
            end)
        end
        local VictoryCount = 0
        local calling,err = pcall(function()
            RequestTo = HttpService:JSONDecode(game:HttpGet("https://api.championshop.date/history-av/" .. game.Players.LocalPlayer.Name))
        end) 
        if calling then
            VictoryCount = RequestTo and RequestTo["value"] or 0
        end
       
        setclipboard(HttpService:JSONEncode({
                ["Method"] = Results.Rewards and "MatchEnd" or "FirstTime",
                ["WorldLine_Floor"] = WorldLine == nil and "Cannot Get Worldline" or WorldLine,
                ["Inventory"] = Inventory,
                ["Units"] = EquippedUnits,
                ["Skins"] = SkinTable,
                ["Familiars"] = FamiliarTable,
                ["Results"] = Results,
                ["Username"] = plr.Name,
                ["PlayerData"] = PlayerData,
                ["WinCounting"] = VictoryCount,
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
        }))
        warn("Setclipboard")
        local response = request({
            ["Url"] = url,
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] =  Results.Rewards and "MatchEnd" or "FirstTime",
                ["WorldLine_Floor"] = WorldLine == nil and "Cannot Get Worldline" or WorldLine,
                ["Inventory"] = Inventory,
                ["Units"] = EquippedUnits,
                ["Skins"] = SkinTable,
                ["Familiars"] = FamiliarTable,
                ["Results"] = Results,
                ["Username"] = plr.Name,
                ["PlayerData"] = PlayerData,
                ["WinCounting"] = VictoryCount,
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
            })
        })
        for i,v in pairs(response) do
            warn("Debug",i,v)
        end
    end 
    Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
        Send(Results)
    end)
    Send()
    Networking.EndScreen.HideEndScreenEvent.OnClientEvent:Connect(function()
        BattlePassXp = 0
    end)
end

warn("Executed",os.time())