repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
--[[
Map
Sand Village
Double Dungeon
Planet Namak
Shibuya Station
Underground Church
Spirit Society
]]


--[[
 
local response = request({
    ["Url"] = "https://api.championshop.date/party-aa",
    ["Method"] = "POST",
    ["Headers"] = {
        ["content-type"] = "application/json"
    },
    ["Body"] = game:GetService("HttpService"):JSONEncode({
        ["index"] = "XD",
        ["value"] = {
            ["data"] = "Hello World",
            ["os"] = tick()
        },
    })
})
print(game:HttpGet("https://api.championshop.date/party-aa/XD"))
]]
_G.User = {
    ["GCshop2"] = {
        ["Select Mode"] = "Portal", -- Portal
        ["Party Mode"] = true,
        ["Party Member"] = {
            "Kreovx",
            "1mpSs7K27A2TeZ",
            "Theppartarn"
        },
        ["Portal Settings"] = {
            ["ID"] = 113, -- 113 Love , 87 Winter
            ["Tier Cap"] = 10,
            ["Method"] = "Highest", -- Highest , Lowest
            ["Ignore Stage"] = {"Shibuya Station"},
            ["Ignore Modify"] = {},
        },
    },
    ["Kreovx"] = {
        ["Party Mode"] = true,
    },
    ["Theppartarn"] = {
        ["Party Mode"] = true,
    },
    ["1mpSs7K27A2TeZ"] = {
        ["Party Mode"] = true,
    },
    ["Lucinda2471"] = {
        ["Select Mode"] = "Portal", -- Portal
        ["Party Mode"] = true,
        ["Party Member"] = {
            "ball77071",
            "rain4834",
            "MarioNo1111"
        },
        ["Portal Settings"] = {
            ["ID"] = 87, -- 113 Love , 87 Winter
            ["Tier Cap"] = 10,
            ["Method"] = "Highest", -- Highest , Lowest
            ["Ignore Stage"] = {},
            ["Ignore Modify"] = {},
        },
    },
    ["ball77071"] = {
        ["Party Mode"] = true,
    },
    ["rain4834"] = {
        ["Party Mode"] = true,
    },
    ["MarioNo1111"] = {
        ["Party Mode"] = true,
    },
    ["4N3hHaKS62eZH1"] = {
        ["Select Mode"] = "Portal", -- Portal
        ["Party Mode"] = true,
        ["Party Member"] = {
            "I97Iwnqlm1sy60"
        },
        ["Portal Settings"] = {
            ["ID"] = 113, -- 113 Love , 87 Winter
            ["Tier Cap"] = 10,
            ["Method"] = "Highest", -- Highest , Lowest
            ["Ignore Stage"] = {"Shibuya Station"},
            ["Ignore Modify"] = {},
        },
    },
    ["I97Iwnqlm1sy60"] = {
        ["Party Mode"] = true,
    },
    ["petezero0"] = {
        ["Party Mode"] = true,
    },
    ["Arscontia"] = {
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
-- local Key = "Onio_#@@421"
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
warn(Settings["Party Member"],plr.Name,_G.User[plr.Name])
game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
task.spawn(function()
    task.wait(2)
    if game.PlaceId == 16146832113 then     
        if Settings["Party Mode"]  then
            print("Im here 2")
            if not Settings["Party Member"]  then
                print("Im here 3")
                -- TextChatService.OnIncomingMessage = function(message)
                --     if message.Text:match(Key) then
                --         local Split = message.Text:split("|")
                --         if Split[3] == plr.Name and Split[2] == "Join" then
                --             if Split[4] == "Portal" then
                --                 game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                --                     "JoinPortal",
                --                     Split[5]
                --                 )
                --             end
                --         end
                --     end
                -- end
                while task.wait(5) do
                    local requestTo = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.championshop.date/party-aa/" .. game.Players.LocalPlayer.Name))
                    local ost = requestTo["status"] == "success" and requestTo["value"]["os"] or 0
                    -- warn(requestTo["status"] , requestTo["value"])
                    -- warn(ost)
                    -- warn(requestTo["status"] == "success" and requestTo["value"]["data"])
                    -- warn(tostring(requestTo["status"]) == "success" , requestTo["value"] , requestTo["value"]["os"] >= tick())
                    if tostring(requestTo["status"]) == "success" and requestTo["value"] and tonumber(requestTo["value"]["os"]) >= os.time() then
                        warn("Join")
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                            "JoinPortal",
                            requestTo["value"]["data"]
                        )
                    end
                end
                
            else
                print("Im here 4")
                local UUID = nil
                game:GetService("ReplicatedStorage").Networking.Portals.PortalReplicationEvent.OnClientEvent:Connect(function(index,value)
                    if index == "Replicate" and tostring(value["Owner"]) == plr.Name then
                        UUID = value["GUID"]
                    end
                end)
                task.spawn(function()
                    while task.wait() do
                        if UUID then
                            for i,v in pairs(Settings["Party Member"]) do
                                local response = request({
                                    ["Url"] = "https://api.championshop.date/party-aa",
                                    ["Method"] = "POST",
                                    ["Headers"] = {
                                        ["content-type"] = "application/json"
                                    },
                                    ["Body"] = game:GetService("HttpService"):JSONEncode({
                                        ["index"] = v,
                                        ["value"] = {
                                            ["data"] = UUID,
                                            ["os"] = os.time() + 120
                                        },
                                    })
                                })
                                -- RBXGeneral:SendAsync(table.concat({Key,"Join",plr.Name,"Portal",UUID},"|")) 
                            end
                            task.wait(10)
                        end
                    end
                end)
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
        print("Im here 1")
        function AllPlayerInGame()
            print(Settings["Party Member"])
            for i,v in pairs(Settings["Party Member"]) do
                if not game:GetService("Players"):FindFirstChild(v) then
                    return false
                end
            end
            return true
        end
        if Settings["Select Mode"] == "Portal" then
            local Settings_ = Settings["Portal Settings"]
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
                    
                    if not table.find(Settings_["Ignore Stage"],IndexToDisplay(v["ExtraData"]["Stage"]["Stage"])) and Ignore(v["ExtraData"]["Modifiers"],Settings_["Ignore Modify"]) and Settings_["Tier Cap"] >= v["ExtraData"]["Tier"] then
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
                if AllPlayerInGame() then
                    Next_(200)
                    if AllPlayerInGame() then 
                        local Portal = PortalSettings(GetItem(Settings_["ID"]))
                        if Portal then
                            local args = {
                                [1] = "ActivatePortal",
                                [2] = Portal
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(unpack(args))
                        end
                    end
                end
                task.wait(2)
            end
        end
    else

    end    
end)