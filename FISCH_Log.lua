
repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer
local tloading = tick() + 5
local loading
repeat task.wait()
    loading = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("loading")
until tick() >= tloading or loading

while loading and loading.Enabled do task.wait()
    if loading.Enabled and loading.loading.skip.Visible then
        local skip = loading.loading.skip
        skip.AnchorPoint = Vector2.new(.5,.5)
        skip.Position = UDim2.fromScale(.5,.5)
        skip.Size = UDim2.fromScale(9999,9999)
        print("Skip")
    end
    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
end 
print("loading")
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("assetsloaded") and game:GetService("Players").LocalPlayer.assetsloaded.Value
print("assetsloaded")
local Settings = {
    ["Cooldown"] = 240,
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
            local Rod_All = {}
            local FishCahce = {}
            for i,v in pairs(playerstats[plr.Name].Inventory:GetChildren()) do
                if not table.find(Settings["Item List"],v.Value) then
                    continue;
                end
                local ID = v.Value
                if v:FindFirstChild("Mutation") and not table.find(Settings["Ignore Mutation"],v.Mutation.Value) then
                    ID = ID .. "_" .. v.Mutation.Value
                end
                if v:FindFirstChild("Stack") then
                    if not FishCahce[ID] then
                        FishCahce[ID] = 0
                    end
                    FishCahce[ID] = FishCahce[ID] + v.Stack.Value
                else
                    FishCahce[ID] = 1
                end
            end
            for i,v in pairs(playerstats[plr.Name].Rods:GetChildren()) do
                table.insert(Rod_All,v.Name)
            end
            Index = 0
            local tick1 = tick() + math.random(1,40)
            repeat task.wait() until tick() >= tick1
       
            local response = request({
                ["Url"] = "https://api.championshop.date/log-fisch",
                ["Method"] = "POST",
                ["Headers"] = {
                    ["content-type"] = "application/json"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["Method"] = "Update",
                    ["Server_Data"] = Insert_To,
                    ["Username"] = plr.Name,
                    ["Gold"] = playerstats[plr.Name].Stats.coins.Value,
                    ["Level"] = playerstats[plr.Name].Stats.level.Value,
                    ["Bait"] = playerstats[plr.Name].Stats.bait.Value,
                    ["Rod"] = playerstats[plr.Name].Stats.rod.Value,
                    ["All_Rod"] = Rod_All,
                    ["Area"] = plr.Character and plr.Character.zone.Value.Name or "Died",
                    ["Fishs"] = Fishs,
                    ["All_Item"] = FishCahce,
                    ["GuildId"] = "467359347744309248",
                    ["DataKey"] = "GamingChampionShopAPI",
                })
            })
            Fishs = {} 
            Last_Send_Data = tick() + Settings["Cooldown"]
        end
    end
end)