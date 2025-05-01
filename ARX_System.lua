repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("LoadingDataUI",3)
if game.GameId ~= 6884266247 then return warn("Doesn't match ID") end
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui["LoadingDataUI"].Enabled
print("Loading..") task.wait(5)
_G.User = {
    ["SHIFUGOD"] = {
        ["Select End Method"] = "VoteNext",
        ["Select Mode"] = "Story", -- Story , Ranger
        ["Story Settings"] = {
            ["World"] = "Voocha Village",
            ["Difficulty"] = "Normal", -- Normal , Hard , Nightmare
            ["Level"] = "10",
            ["Friend Only"] = true,
        },
        ["Ranger Settings"] = {
            ["World"] = "Green Planet",
            ["Level"] = "1",
            ["Friend Only"] = true,
        },
    }
}
--[[
Map
Voocha Village
Green Planet
Demon Forest
Leaf Village
Z City
Cursed Town
Easter Egg
]]


-- Service
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

-- Unity
local function LoadModule(path)
    local Tick = tick() + 5
    local Module = nil
    repeat 
        pcall(function()
            Module = require(path) 
        end)  
        task.wait(.25)
    until Module or tick() >= Tick
    print(path.Name,Module and "Found" or "Not Found","Module [SKYHUB]")
    return Module or {}
end

-- Modules
local Worlds = LoadModule(game:GetService("ReplicatedStorage").Shared.Info.GameWorld.World)
-- Variables
local plr = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild("Remote")
local Server = Remote:WaitForChild("Server")
local Client = Remote:WaitForChild("Client")
local MapIndexs = {}
local Character = plr.Character or plr.CharacterAdded:Wait()

local Settings = {
    ["Auto Play"] = {
        ["Enabled"] = true,
    },
    ["Select Mode"] = "Story", -- Story , Ranger
 
    ["Party Mode"] = false,

    ["Select End Method"] = "VoteRetry", -- VoteRetry , VoteNext , VotePlaying

    ["Story Settings"] = {
        ["World"] = "Voocha Village",
        ["Difficulty"] = "Normal", -- Normal , Hard , Nightmare
        ["Level"] = "1",
        ["Friend Only"] = true,
    },
    ["Ranger Settings"] = {
        ["World"] = "Voocha Village",
        ["Difficulty"] = "Normal", -- Normal , Hard , Nightmare
        ["Level"] = "1",
        ["Friend Only"] = true,
    },
}

if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end
-- Call Function Sections
for i,v in pairs(Worlds) do
    MapIndexs[v.Name] = i
end
-- Function Sections
local function Get_Story(val,val1)
    return MapIndexs[val] .. "_Chapter" .. val1 
end 
local function Get_Ranger(val,val1)
    return MapIndexs[val] .. "_RangerStage" .. val1 
end
local function Event(...)
    Server:WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(...)
end
local function Deploy(...)
    Server:WaitForChild("Units"):WaitForChild("Deployment"):FireServer(...)
end
local function UseVote(path,...)
    Server:WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild(path):FireServer(...)
end
-- Script Sections 

-- In-Game
if Workspace:FindFirstChild("WayPoint") then
    
    local Setting = Settings["Auto Play"]
    if Setting["Enabled"] then
        task.spawn(function()
            while true do
                if plr.PlayerGui.RewardsUI.Enabled then
                    UseVote(Settings)
                end
                task.wait(1)
            end
        end)

        local function AutoPlay()
            local Enabled = true
            local GameCF = LoadModule(game:GetService("ReplicatedStorage").Shared.GAMEPLAY_CONFIG)
            local Data = ReplicatedStorage.Player_Data[plr.Name]
            local LocalData = Data:WaitForChild("Data")
            local Collection = Data:WaitForChild("Collection")
            local LastGetPath = tick()
            local LastPath = #workspace.WayPoint:GetChildren()
            local LastPlace = tick()
            local OneTimePlace = false
            local FirstTime = false
            local YenMax = false
            local function GetTag(Id)
                for i,v in pairs(Collection:GetChildren()) do
                    if v:FindFirstChild("Tag") and v.Tag.Value == Id then
                        return v
                    end
                end 
                return false
            end
            local function GetNearestPath(Id)
                if tick() >= LastGetPath then
                    local Near = 9999999
                    for i,v in pairs(workspace.Agent.EnemyT:GetChildren()) do
                        if v["Info"]:FindFirstChild("Node") and tonumber(v["Info"].Node.Value) < Near  then
                            Near = tonumber(v["Info"].Node.Value)
                        end
                    end 
                    LastPath = Near
                    return Near
                end
                return LastPath
            end
            local function PlaceAccess()
                if YenMax and tick() >= LastPlace then
                    LastPlace = tick() + 10
                    return true
                end
                return false 
            end 
            local GameEndedUI = Client:WaitForChild("UI"):WaitForChild("GameEndedUI").OnClientEvent:Connect(function()
                Enabled = false
            end) 
            UseVote("VotePlaying") task.wait(.2)
            task.spawn(function()
                while Enabled do 
                    if YenMax then 
                        for i,v in pairs(plr.UnitsFolder:GetChildren()) do
                            Server:WaitForChild("Units"):WaitForChild("Upgrade"):FireServer(v)
                        end
                    end 
                    task.wait(1)
                end
            end)
            while Enabled do
                if not workspace.Agent.UnitT:FindFirstChildWhichIsA("Part") or GetNearestPath() < LastPath/2 or PlaceAccess() or OneTimePlace then
                    for i = 1,6 do 
                        local UnitLoadout = LocalData["UnitLoadout" .. i].Value 
                        if #UnitLoadout > 2 then
                            local GetPath = GetTag(UnitLoadout)
                            Deploy(GetPath) task.wait(.2)
                        end 
                    end
                    if OneTimePlace then
                        OneTimePlace = false
                    end 
                    if not FirstTime then
                        print("Upgrade")
                        task.delay(2.5,function()
                            for i,v in pairs(plr.UnitsFolder:GetChildren()) do
                                print(i,v)
                                Server:WaitForChild("Units"):WaitForChild("Upgrade"):FireServer(v) task.wait(.2)
                            end
                        end) 
                        task.delay(14,function()
                            OneTimePlace = true
                        end) 
                        FirstTime = true
                    end
                elseif GameCF.ingame_stats.YenMax > plr.YenMaxUpgrade.Value then
                    Server:WaitForChild("Gameplay"):WaitForChild("StatsManager"):FireServer("MaximumYen") 
                    task.delay(.25,function()
                        if GameCF.ingame_stats.YenMax <= plr.YenMaxUpgrade.Value then
                            YenMax = true
                        end
                    end)
                end
                task.wait(.2)
            end
            GameEndedUI:Disconnect()
            task.wait(2.5)
            AutoPlay()
        end
        AutoPlay()
    end

    -- Deploy()
    return false 
end
-- No Party
if not Settings["Party Mode"] then
    if Settings["Select Mode"] == "Story" then
        local Setting = Settings[Settings["Select Mode"] .. " Settings"]
        Event("Create") task.wait(.2)
        if Setting["Friend Only"] then
            Event("Change-FriendOnly") task.wait(.2)
        end
        Event("Change-World",{World = MapIndexs[Setting["World"]]}) task.wait(.2)
        Event("Change-Chapter",{Chapter = Get_Story(Setting["World"],Setting["Level"])}) task.wait(.2)
        Event("Change-Difficulty",{Difficulty = Setting["Difficulty"]}) task.wait(.2)
        Event("Submit") task.wait(.2)
    elseif Settings["Select Mode"] == "Ranger" then
        local Setting = Settings[Settings["Select Mode"] .. " Settings"]
        Event("Create") task.wait(.2)
        if Setting["Friend Only"] then
            Event("Change-FriendOnly") task.wait(.2)
        end
        Event("Change-Mode",{Mode = "Ranger Stage"}) task.wait(.2)
        Event("Change-World",{World = MapIndexs[Setting["World"]]}) task.wait(.2)
        Event("Change-Chapter",{Chapter = Get_Ranger(Setting["World"],Setting["Level"])}) task.wait(.2)
        Event("Submit") task.wait(.2)
    end
    Event("Start")
end

