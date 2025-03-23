repeat  task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
--[[
Map
Sand Village
Double Dungeon
Planet Namak
Shibuya Station
Underground Church
Spirit Society
]]

_G.User = {
    ["natthakit587"] = {

        ["Select Mode"] = "Portal", -- Portal

        ["Party Mode"] = false,
        ["Party Member"] = {
            "Xx_e1ainaxX",
            "KageMonarchz",
            "jarnmosx01",
        },
    },
    ["Nuikk24"] = {

        ["Select Mode"] = "Portal", -- Portal

        ["Party Mode"] = false,
        ["Party Member"] = {
            "AMERICAMENTIONEDRAHH",
            "anakin_av139",
            "Samueltitiala",
        },
    },
    ["anakin_av139"] = {
        ["Party Mode"] = true,
    },
    ["AMERICAMENTIONEDRAHH"] = {
        ["Party Mode"] = true,
    },
    ["Samueltitiala"] = {
        ["Party Mode"] = true,
    },
    ["KageMonarchz"] = {
        ["Party Mode"] = true,
    },
    ["Xx_e1ainaxX"] = {
        ["Party Mode"] = true,
    },
    ["jarnmosx01"] = {
        ["Party Mode"] = true,
    },
}
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
-- All Modules
local StagesData = LoadModule(game:GetService("ReplicatedStorage").Modules.Data.StagesData)


-- All Functions
local function IndexToDisplay(arg)
    return StagesData["Story"][arg]["StageData"]["Name"]
end
-- All Variables
local Key = "Onio_#@@421"
local plr = game.Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local RBXGeneral = TextChatService.TextChannels.RBXGeneral
local Inventory = {}
game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(value)
    Inventory = value
end)
local Settings ={

    ["Select Mode"] = "Portal", -- Portal

    ["Party Mode"] = false,
    ["Portal Settings"] = {
        ["ID"] = 113, -- 113 Love , 87 Winter
        ["Tier Cap"] = 10,
        ["Method"] = "Highest", -- Highest , Lowest
        ["Ignore Stage"] = {},
        ["Ignore Modify"] = {},
    },
}

if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end
game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
task.spawn(function()
    task.wait(2)
    if game.PlaceId == 16146832113 then
        
        if Settings["Party Mode"]  then
            if not Settings["Party Member"]  then
                TextChatService.OnIncomingMessage = function(message)
                    if message.Text:match(Key) then
                        local Split = message.Text:split("|")
                        if Split[3] == plr.Name and Split[2] == "Join" then
                            if Split[4] == "Portal" then
                                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                                    "JoinPortal",
                                    Split[5]
                                )
                            end
                        end
                    end
                end
                while task.wait(5) do
                    RBXGeneral:SendAsync(table.concat({Key,"Request Join",plr.Name},"|")) 
                end
            else
                local PartyMember = {}
                local UUID = ""
                game:GetService("ReplicatedStorage").Networking.Portals.PortalReplicationEvent.OnClientEvent:Connect(function(index,value)
                    if index == "Replicate" then
                        UUID = value["GUID"]
                        for i,v in pairs(PartyMember) do
                            RBXGeneral:SendAsync(table.concat({Key,"Join",plr.Name,"Portal",UUID},"|")) 
                        end
                    end
                end)
                TextChatService.OnIncomingMessage = function(message)
                    if message.Text:match(Key) then
                        local Split = message.Text:split("|")
                        if Split[2] == "Request Join" and table.find(Settings["Party Mode"],Split[3]) and not table.find(PartyMember,plr.Name) then
                            table.insert(PartyMember,plr.Name)
                        end
                    end
                end
                repeat
                    task.wait()
                until #PartyMember >= Settings["Party Member"]
            end
        end
        local function GetItem(ID)
            game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
            local Items = {}
            for i,v in pairs(Inventory) do
                if v["ID"] == ID then
                    Items[i] = v
                end
            end
            return Items
        end
        if Settings["Select Mode"] == "Portal" then
            local Settings = Settings["Portal Settings"]
            local function Ignore(tab1,tab2)
                for i,v in pairs(tab1) do
                    if table.find(tab2,v) then
                        return false
                    end 
                end
                return true
            end
            local function PortalSettings(tabl)
                local AllPortal = {}
                for i,v in pairs(tabl) do
                    
                    if not table.find(Settings["Ignore Stage"],IndexToDisplay(v["ExtraData"]["Stage"]["Stage"])) and Ignore(v["ExtraData"]["Modifiers"],Settings["Ignore Modify"]) and Settings["Tier Cap"] >= v["ExtraData"]["Tier"] then
                        AllPortal[#AllPortal + 1] = {
                            [1] = i,
                            [2] = v["ExtraData"]["Tier"]
                        }
                        
                    end
                end
                table.sort(AllPortal, function(a, b)
                    return a[2] > b[2]
                end)
                return AllPortal[1][1] or false
            end
            print("Im here")
            while true do
                local Portal = PortalSettings(GetItem(Settings["ID"]))
                if Portal then
                    local args = {
                        [1] = "ActivatePortal",
                        [2] = Portal
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(unpack(args))
                end
                task.wait(2)
            end
        end
    end    
end)
