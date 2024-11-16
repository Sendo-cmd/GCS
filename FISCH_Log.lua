repeat wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    ["Cooldown"] = 240
}

local plr = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerstats = ReplicatedStorage:WaitForChild("playerstats")
local HttpService = game:GetService("HttpService")
local Insert_To = {}
local Last_Send_Data = tick()
local Index = 0
local FishCahce = {}
local Fishs = {}
for i,v in pairs(playerstats[plr.Name].Inventory:GetChildren()) do
    table.insert(FishCahce,v.Name)
end
game:GetService("ReplicatedStorage").events.anno_catch.OnClientEvent:Connect(function(b)
    Fishs[tostring(Index)] = b
    Index = Index + 1
end)

spawn(function ()
    while true do task.wait()
        if tick() >= Last_Send_Data then
            for i,v in pairs(game:GetService("ReplicatedStorage").world:GetChildren()) do
                Insert_To[v.Name] = v.Value
            end
            local FishCahce = {}
            for i,v in pairs(playerstats[plr.Name].Inventory:GetChildren()) do
                FishCahce[v.Name] = {
                    ["Stack"] = v.Stack.Value,
                    ["Name"] = v.Value,
                }
            end
                
            Index = 0
            Fishs = {} 
            
            local response = request({
                ["Url"] = "http://champions.thddns.net:3031/log-fisch",
                ["Method"] = "POST",
                ["Headers"] = {
                    ["content-type"] = "application/json"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["Method"] = "Update",
                    ["Server_Data"] = Insert_To,
                    ["Username"] = plr.Name,
                    ["Gold"] = plr.leaderstats["C$"].Value,
                    ["Level"] = plr.leaderstats["Level"].Value,
                    ["Bait"] = playerstats[plr.Name].Stats.bait.Value,
                    ["Rod"] = playerstats[plr.Name].Stats.rod.Value,
                    ["Fishs"] = Fishs,
                    ["All_Fish"] = FishCahce,
                    ["GuildId"] = "467359347744309248",
                    ["DataKey"] = "GamingChampionShopAPI",
                })
            })
            Last_Send_Data = tick() + Settings["Cooldown"]
        end
    end
end)