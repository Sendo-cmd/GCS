repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("spawn_units")
game:GetService("Players").LocalPlayer.PlayerGui.spawn_units:WaitForChild("Lives")
local plr = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
if game.PlaceId == 8304191830  then
    local response = request({
        ["Url"] = "https://api.championshop.date/log-aa",
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json"
        },
        ["Body"] = HttpService:JSONEncode({
            ["Method"] = "Update",
            ["Place"] = "Lobby",
            ["Username"] = plr.Name,
            ["session"] = game:GetService("HttpService"):JSONEncode(require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]),
            ["Gold"] = plr._stats.gold_amount.Value,
            ["Gem"] =  plr._stats.gem_amount.Value,
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
        local response = request({
            ["Url"] = "https://api.championshop.date/log-aa",
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] = "Update",
                ["Place"] = "Game",
                ["Username"] = plr.Name,
                ["session"] = game:GetService("HttpService"):JSONEncode(require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]),
                ["Gold"] = plr._stats.gold_amount.Value,
                ["Gem"] =  plr._stats.gem_amount.Value,
                ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                ["Rewards"] = game:GetService("HttpService"):JSONEncode(g),
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
            })
        })
    end)
 
    for i,v in pairs(response) do
        print(i,v)
    end
end