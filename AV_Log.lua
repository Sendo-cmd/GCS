--
local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

repeat task.wait() until not plr:GetAttribute("Loading")

local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
local Modules = ReplicatedStorage:WaitForChild("Modules")

local Networking = ReplicatedStorage:WaitForChild("Networking")

local SettingsHandler = require(PlayerModules.Gameplay.SettingsHandler)
local StagesData = require(Modules.Data.StagesData)
local UnitsData = require(Modules.Data.Entities.Units)

repeat task.wait() until SettingsHandler.SettingsLoaded

local IsMain = workspace:FindFirstChild("MainLobby")
local IsMatch = plr:FindFirstChild("StageInfo")

local Utilities = Modules:WaitForChild("Utilities")

local Shared = Modules:WaitForChild("Shared")

local MultiplierHandler = require(Shared.MultiplierHandler)

local NumberUtils = require(Utilities.NumberUtils)
local TableUtils = require(Utilities.TableUtils)

local IsMain = workspace:FindFirstChild("MainLobby")
local IsMatch = plr:FindFirstChild("StageInfo")

local url = "http://champions.thddns.net:3031/logs"

if IsMain then
    local UnitWindowHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.UnitWindowHandler)
    local InventoryHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.InventoryHandler)
    local BattlepassHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler)

    repeat task.wait() until UnitWindowHandler.AreUnitsLoaded;

    local EquippedUnits = {}

    for i,v in pairs(UnitWindowHandler.EquippedUnits) do
        if i == "None" then continue end

        EquippedUnits[i] = TableUtils.DeepCopy(UnitWindowHandler._Cache[i])
        EquippedUnits[i].Name = EquippedUnits[i].UnitData.Name

        EquippedUnits[i].UnitData = nil
    end

    local PlayerData = {
        ["Gold"] = plr:GetAttribute("Gold"),
        ["Gems"] = plr:GetAttribute("Gems"),
        ["TraitRerolls"] = plr:GetAttribute("TraitRerolls"),
    }

    local response = request({
        ["Url"] = url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json"
        },
        ["Body"] = HttpService:JSONEncode({
            ["Method"] = "Update",
            ["Units"] = EquippedUnits,
            ["Items"] = InventoryHandler:GetInventory(),
            ["Username"] = plr.Name,
            ["Battlepass"] = BattlepassHandler:GetPlayerData(),
            ["PlayerData"] = PlayerData
        })
    })
elseif IsMatch then
    local UnitsHUD = require(game:GetService("StarterPlayer").Modules.Interface.Loader.HUD.Units)
    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
    local BattlepassText = require(game:GetService("StarterPlayer").Modules.Visuals.Misc.Texts.BattlepassText)

    local BattlePassXp = 0
    local BPPlay = BattlepassText.Play
    BattlepassText.Play = function(self, data)
        BattlePassXp += data[1]
        return BPPlay(self, data)
    end

    Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
        local EquippedUnits = {}
        for i,v in pairs(UnitsHUD._Cache) do
            if v == "None" then continue end
            EquippedUnits[v.UniqueIdentifier] = TableUtils.DeepCopy(v)

            EquippedUnits[v.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v.Identifier).Name
        end
        
        local GameData = GameHandler.GameData
        
        pcall(function()
            Results["StageName"] = StagesData:GetStageData(GameData.StageType, GameData.Stage).Name
        end)
        
        if BattlePassXp > 0 then
            Results.Rewards["Pass Xp"] = { ["Amount"] = BattlePassXp }
        end

        local PlayerData = {
            ["Gold"] = plr:GetAttribute("Gold"),
            ["Gems"] = plr:GetAttribute("Gems"),
            ["TraitRerolls"] = plr:GetAttribute("TraitRerolls"),
        }
        
        local response = request({
            ["Url"] = url,
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] = "MatchEnd",
                ["Units"] = EquippedUnits,
                ["Results"] = Results,
                ["Username"] = plr.Name,
                ["PlayerData"] = PlayerData
            })
        })
    end)
    
    Networking.EndScreen.HideEndScreenEvent.OnClientEvent:Connect(function()
        BattlePassXp = 0
    end)
end
