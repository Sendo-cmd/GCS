repeat  task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ApiUrl = "https://api.championshop.date/log-aa"

local InsertItem = require(game:GetService("ReplicatedStorage").src.Data.Items)
local ItemsForSaleEvent = require(game:GetService("ReplicatedStorage").src.Data.ItemsForSaleEvent)

local function SendWebhook(evo)
    local plr = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    local Current = "lily_february"

    local session 
    repeat task.wait(.1)
        session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
    until session
    local collection_profile_data = session["collection"]["collection_profile_data"]
    local profile_data = session["profile_data"]
    local battlepass_data = profile_data["battlepass_data"][Current]
    local equipped_units = collection_profile_data["equipped_units"]
    local owner = collection_profile_data["owned_units"]
    local Function = require(game.ReplicatedStorage.src.Loader).load_core_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "TraitServiceCore")["calculate_stat_rank"]

    local Battleplass = require(game:GetService("ReplicatedStorage").src.Data.BattlePass)
    local Units = require(game:GetService("ReplicatedStorage").src.Data.Units)

    local CalcLevel = function() end 
    for i,v in pairs(getgc()) do
        if type(v) == "function" and getinfo(v).name == "calculate_level" then
            CalcLevel = v
        end
    end
    for i,v in pairs(owner) do
        v["Display"] = Units[v["unit_id"]]["name"]
        v["TraitDisplay"] = {}
        v["Level"] = CalcLevel(v["unit_id"],v["xp"])
        for i1,v1 in pairs(v["trait_stats"]) do
            local f = Function(v["unit_id"],v,i1,v1)
            v["TraitDisplay"][i1] = f
        end
    end
    -- setclipboard(HttpService:JSONEncode(owner))
    local function BattleLevel()
        local CurrentLevel = 0
        for i = 1,Battleplass[Current]["total_tiers"] do
            local Data = Battleplass[Current]["tiers"][tostring(i)]
            if battlepass_data["xp"] > Data["xp_required"] then
                CurrentLevel = i
            else
                break
            end
        end
        return CurrentLevel
    end

    local function Equipped_Display()
        local Display = {}
        for i,v in pairs(equipped_units) do
            table.insert(Display,owner[v])
        end
        return Display
    end
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("spawn_units"):WaitForChild("Lives")
    if evo then
        local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
        local response = request({
            ["Url"] = ApiUrl,
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] = "Update",
                ["Place"] = "Lobby",
                ["Username"] = plr.Name,
                ["inventory"] = session["inventory"]["inventory_profile_data"],
                ["Evo"] = evo,
                ["equipped_units"] = Equipped_Display(),
                ["battle_level"] = BattleLevel(),
                ["allunit"] = owner,
                ["Gold"] = plr._stats.gold_amount.Value,
                ["Gem"] =  plr._stats.gem_amount.Value,
                ["AprilCoins"] = plr._stats._resourceAprilCoins.Value,
             -- ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
            })
        })
        for i,v in pairs(response) do
            print(i,v)
        end
    else
        if game.PlaceId == 8304191830  then
            local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
            local response = request({
                ["Url"] = ApiUrl,
                ["Method"] = "POST",
                ["Headers"] = {
                    ["content-type"] = "application/json"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["Method"] = "Update",
                    ["Place"] = "Lobby",
                    ["Username"] = plr.Name,
                    ["inventory"] = session["inventory"]["inventory_profile_data"],
                    ["equipped_units"] = Equipped_Display(),
                    ["battle_level"] = BattleLevel(),
                    ["allunit"] = owner,
                    ["Gold"] = plr._stats.gold_amount.Value,
                    ["Gem"] =  plr._stats.gem_amount.Value,
                    ["AprilCoins"] = plr._stats._resourceAprilCoins.Value,
                 -- ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                    ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                    ["GuildId"] = "467359347744309248",
                    ["DataKey"] = "GamingChampionShopAPI",
                })
            })
            for i,v in pairs(response) do
                print(i,v)
            end
        else
            game:GetService("ReplicatedStorage").endpoints.server_to_client.game_finished.OnClientEvent:Connect(function(g)
                local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
                local response = request({
                    ["Url"] = ApiUrl,
                    ["Method"] = "POST",
                    ["Headers"] = {
                        ["content-type"] = "application/json"
                    },
                    ["Body"] = HttpService:JSONEncode({
                        ["Method"] = "Update",
                        ["Place"] = "Game",
                        ["Username"] = plr.Name,
                        ["inventory"] = session["inventory"]["inventory_profile_data"],
                        ["equipped_units"] = Equipped_Display(),
                        ["battle_level"] = BattleLevel(),
                        ["allunit"] = owner,
                        ["Gold"] = plr._stats.gold_amount.Value,
                        ["Gem"] =  plr._stats.gem_amount.Value,
                        ["AprilCoins"] = plr._stats._resourceAprilCoins.Value,
                     -- ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                        ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                        ["Rewards"] = g,
                        ["MapInfo"] = workspace._MAP_CONFIG.GetLevelData:InvokeServer(),
                        ["GuildId"] = "467359347744309248",
                        ["DataKey"] = "GamingChampionShopAPI",
                    })
                })
                for i,v in pairs(response) do
                    print(i,v)
                end
            end)
        end
    end
    
end

SendWebhook()