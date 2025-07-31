local All_Key = {
    ["AV"] = "Party-AV-1",
    ["AA"] = "Party-AA",
    ["ASTD X"] = "Party-ASTDX"
}
local ID = {
    [5578556129] = {
        [1] = "AV",
        [2] = 16146832113,
    },
}
repeat task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Api = "https://api.championshop.date" -- ใส่ API ตรงนี้
local local_data = ID[game.GameId]; if not local_data then game:GetService("Players").LocalPlayer:Kick("Not Support Yet") end
local IsGame = local_data[1]
local MainSettings = {
    ["Path_Cache"] = "/api/v1/shop/orders/cache",
    ["Path_Kai"] = "/api/v1/shop/accountskai",
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local Client = Players.LocalPlayer
local Username = Client.Name
-- Unity
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
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
local function Get(Api)
    local Data = request({
        ["Url"] = Api,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    return Data
end
local function Fetch_data()
    local Data = Get(Api .. "/api/v1/shop/orders/" .. Username)
    local Order_Data = HttpService:JSONDecode(Data["Body"])["data"]
    print(Order_Data,Order_Data[1])
    return Order_Data[1]
end
local function CreateBody(...)
    local body = {}
    local array = {...}
    for i,v in pairs(array) do
        for i1,v1 in pairs(v) do
            body[i1] = v1
        end
    end
    return body
end
local function Post(Url,...)
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
    return response
end
local function Delete(Url,...)
    local response = request({
        ["Url"] = Url,
        ["Method"] = "DELETE",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    return response
end
local function GetCache(Id)
    return Get(Api .. MainSettings["Path_Cache"] .. "/" .. Id)
end
local function SendUUID(player,get_type,data)
    for i,v in pairs(player) do
        Post(Api .. MainSettings["Path_Cache"],{["index"] = v},{["value"] = {
            ["type"] = get_type,
            ["data"] = data,
            ["os"] = os.time() + 120
        }})
    end
end
local function Join(get_type,get_data)
    if IsGame == "AV" then
        local data_ = get_data
        local Networking = ReplicatedStorage:WaitForChild("Networking")
        if get_type == "Portal" then
            Networking:WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                "JoinPortal",
                data_
            )
        elseif get_type == "Normal" then
            Networking:WaitForChild("LobbyEvent"):FireServer( 
                "JoinMatch",
                data_
            )
        elseif get_type == "Rift" then
            Networking:WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                "Join",
                data_
            )
        end
    end
end 
local function GetPartyMember(data)
    local insert = {}
    for i,v in pairs(data) do
        table.insert(insert,i)
    end
    return insert
end
local function AllPlayerInGame(data)
    for i,v in pairs(data) do
        if not game:GetService("Players"):FindFirstChild(v) then
            return false
        end
    end
    return true
end
local function Register_Room(myproduct,player)
    if IsGame == "AV" then
        print(myproduct)
        local player_ = GetPartyMember(player)
        local player = player_
        local Networking = ReplicatedStorage:WaitForChild("Networking")
        local Settings = {
            ["Select Mode"] = "Portal", -- Portal , Dungeon , Story , Legend Stage , Raid , Challenge , Boss Event , World Line , Bounty
            ["Auto Join Rift"] = false,
            ["Auto Join Bounty"] = false,
            ["Auto Join Boss Event"] = false,
            ["Auto Join Challenge"] = false,

            ["Auto Stun"] = true,
            ["Auto Priority"] = false,
            ["Priority"] = "Closest", 
            ["Party Mode"] = false,

            ["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            },
            ["Raid Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "Raid",
                ["Stage"] = "Spider Forest",
                ["FriendsOnly"] = false
            },
            ["Legend Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Sand Village",
                ["FriendsOnly"] = false
            },
            ["Dungeon Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "Dungeon",
                ["Stage"] = "Mountain Shrine (Natural)",
                ["FriendsOnly"] = false
            },
            ["Boss Event Settings"] = {
                ["Difficulty"] = "Normal",
                ["Stage"] = "RumblingEvent",
            },
            ["Portal Settings"] = {
                ["ID"] = 113, -- 113 Love , 87 Winter
                ["Tier Cap"] = 10,
                ["Method"] = "Highest", -- Highest , Lowest
                ["Ignore Stage"] = {},
                ["Ignore Modify"] = {},
            },
        }
        local Changes = {
            ["960de970-ba26-4184-8d97-561ae8511e4b"] = function()
                Settings["Select Mode"] = "Portal"
                Settings["Portal Settings"] = {
                ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
                ["Tier Cap"] = 10,
                ["Method"] = "Highest", -- Highest , Lowest
                ["Ignore Stage"] = {},
                ["Ignore Modify"] = {},
            }
            end,
            ["24cbfd35-8df6-4fc7-8c0f-5e9c4b921013"] = function()
                Settings["Select Mode"] = "Portal"
                Settings["Portal Settings"] = {
                ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
                ["Tier Cap"] = 10,
                ["Method"] = "Highest", -- Highest , Lowest
                ["Ignore Stage"] = {},
                ["Ignore Modify"] = {},
            }
            end,
            ["0495121f-a579-4068-9494-4a1ac477613b"] = function()
                Settings["Select Mode"] = "Portal"
                Settings["Portal Settings"] = {
                ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
                ["Tier Cap"] = 10,
                ["Method"] = "Highest", -- Highest , Lowest
                ["Ignore Stage"] = {},
                ["Ignore Modify"] = {},
            }
            end,
            ["c11bff94-13e6-45ec-a0ca-d1b19b2964ee"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["3c18df46-db36-4cd4-93b2-9f03926fdadb"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["8d9c0691-0f1d-4a88-b361-d2140e622e82"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["785409b0-02f9-4bb8-8ad8-b383b59f6f54"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Edge of Heaven",
                ["FriendsOnly"] = false
            }
            end,
            ["bc1be299-c561-4a41-964a-a055f8a8e436"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Edge of Heaven",
                ["FriendsOnly"] = false
            }
            end,
            ["1c58db6a-b5d1-4d8d-8195-75aad0403c90"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "Act1",
                ["StageType"] = "Story",
                ["Stage"] = "Edge of Heaven",
                ["FriendsOnly"] = false
            }
            end,
            ["5e334be7-56c9-4bfa-96e1-4856755b3f23"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Shibuya Station",
                ["FriendsOnly"] = false
            }
            end,
            ["68cd687d-0760-4550-a7d6-482f3c2ca9df"] = function()
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Shibuya Station",
                ["FriendsOnly"] = false
            }
            end,
            ["d8b5cc8c-effd-4521-9db9-04fb460cd225"] = function()
                Settings["Auto Stun"] = true
                Settings["Select Mode"] = "Raid"
                Settings["Raid Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "Raid",
                ["Stage"] = "Ruined City",
                ["FriendsOnly"] = false
            }
            end,
            ["30a613fb-29c9-4b88-b18b-1b4231a5468d"] = function()
                Settings["Auto Stun"] = true
                Settings["Select Mode"] = "Raid"
                Settings["Raid Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "Raid",
                ["Stage"] = "Ruined City",
                ["FriendsOnly"] = false
            }
            end,
            ["dfa9b68a-95d7-4227-b118-702cf45061c7"] = function()
                Settings["Auto Stun"] = true
                Settings["Select Mode"] = "Raid"
                Settings["Raid Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "Raid",
                ["Stage"] = "Ruined City",
                ["FriendsOnly"] = false
            }
            end,
            ["cfbb32d7-64cb-4135-b1e3-1992e1800d07"] = function()
                Settings["Select Mode"] = "Dungeon"
                Settings["Dungeon Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "AntIsland",
                ["StageType"] = "Dungeon",
                ["Stage"] = "Ant Island",
                ["FriendsOnly"] = false
            }
            end,
            ["e1a0c37a-c004-4ff3-a064-2b7d55703c3e"] = function()
                Settings["Select Mode"] = "Dungeon"
                Settings["Dungeon Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "AntIsland",
                ["StageType"] = "Dungeon",
                ["Stage"] = "Ant Island",
                ["FriendsOnly"] = false
            }
            end,
            ["b752455d-18d7-4bb3-bd67-70269790500f"] = function()
                Settings["Select Mode"] = "Dungeon"
                Settings["Dungeon Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "AntIsland",
                ["StageType"] = "Dungeon",
                ["Stage"] = "Ant Island",
                ["FriendsOnly"] = false
            }
            end,
            ["4de82cf7-17ae-43ba-bf30-3a2048917a8f"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Double Dungeon",
                ["FriendsOnly"] = false
            }
            end,
            ["ba6f3c6d-c503-4fe4-b06f-0326776ba349"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act1",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Double Dungeon",
                ["FriendsOnly"] = false
            }
            end,
            ["c040bd90-d939-4f0c-b65d-1e0ace06a434"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Double Dungeon",
                ["FriendsOnly"] = false
            }
            end,
            ["c4ca5b41-f68f-4e7b-a8e7-8b2ee7284d08"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Double Dungeon",
                ["FriendsOnly"] = false
            }
            end,
            ["5a2a67e9-7407-4437-bc2e-c332135cec53"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Double Dungeon",
                ["FriendsOnly"] = false
            }
            end,
            ["e7403190-850c-49e5-b2b0-b4949e477c47"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Kuinshi Palace",
                ["FriendsOnly"] = false
            }
            end,
            ["139a8d72-0bfb-478b-98e4-5dd152f01206"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Kuinshi Palace",
                ["FriendsOnly"] = false
            }
            end,
            ["7d480a51-e6df-45e7-b0f8-9e34966ecc7e"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Kuinshi Palace",
                ["FriendsOnly"] = false
            }
            end,
            ["12b453cd-7435-425e-977e-1ae97f04cc23"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Land of the Gods",
                ["FriendsOnly"] = false
            }
            end,
            ["9d07aae3-76ca-4976-a29c-9f6ece183ade"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Land of the Gods",
                ["FriendsOnly"] = false
            }
            end,
            ["ef2bf1de-f30f-46aa-98bb-4a34635a2ed8"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Land of the Gods",
                ["FriendsOnly"] = false
            }
            end,
            ["89901139-d4b5-4555-8913-4900d176546c"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Crystal Chapel",
                ["FriendsOnly"] = false
            }
            end,
            ["7b29fe07-6313-48cb-a095-3680d4758ab6"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Crystal Chapel",
                ["FriendsOnly"] = false
            }
            end,
            ["1e07ff1f-ab45-466b-8b36-ae0ff8b43198"] = function()
                Settings["Select Mode"] = "Legend Stage"
                Settings["Legend Settings"] = {
                ["Difficulty"] = "Nightmare",
                ["Act"] = "Act3",
                ["StageType"] = "LegendStage",
                ["Stage"] = "Crystal Chapel",
                ["FriendsOnly"] = false
            }
            end,
            ["44013587-aa9e-4ca9-8c5a-8503fb61779b"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["bc0fca7b-dde2-47a6-a50b-793d8782999b"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["39ce32e2-c34c-4479-8a52-5715e8645944"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["edbd1859-f374-4735-87c7-2b0487808665"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Auto Join Bounty"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["c480797f-3035-4b1f-99a3-d77181f338bf"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Auto Join Bounty"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["63c63616-134c-4450-a5d6-a73c7d44d537"] = function()
                Settings["Auto Join Challenge"] = true
                Settings["Auto Join Bounty"] = true
                Settings["Select Mode"] = "Story"
                Settings["Story Settings"] = {
                ["Difficulty"] = "Normal",
                ["Act"] = "infinite",
                ["StageType"] = "Story",
                ["Stage"] = "Planet Namak",
                ["FriendsOnly"] = false
            }
            end,
            ["562e53d5-22c8-4337-a5bc-c36df924524b"] = function()
                Settings["Select Mode"] == "World Line"
            end,
        }
        if Changes[myproduct] then
            Changes[myproduct]()
            print("Configs has Changed ")
        end 
        local Inventory = {}
        game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(value)
            Inventory = value
        end)
        game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
        -- All Modules
        local StagesData = LoadModule(game:GetService("ReplicatedStorage").Modules.Data.StagesData)
        -- All Functions
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
        local function DisplayToIndexStory(arg)
            for i,v in pairs(StagesData["Story"]) do
                if v["StageData"]["Name"] == arg then
                    return i
                end
            end 
            return ""
        end
        local function DisplayToIndexLegend(arg)
            for i,v in pairs(StagesData["LegendStage"]) do
                if v["StageData"]["Name"] == arg then
                    return i
                end
            end 
            return ""
        end
        local function DisplayToIndexDungeon(arg)
            for i,v in pairs(StagesData["Dungeon"]) do
                if v["StageData"]["Name"] == arg then
                    return i
                end
            end 
            return ""
        end
        local function DisplayToIndexRaid(arg)
            for i,v in pairs(StagesData["Raid"]) do
                if v["StageData"]["Name"] == arg then
                    return i
                end
            end 
            return ""
        end
        local function IndexToDisplay(arg)
            return StagesData["Story"][arg]["StageData"]["Name"]
        end
        Networking.Portals.PortalReplicationEvent.OnClientEvent:Connect(function(index,value)
            if index == "Replicate" and tostring(value["Owner"]) == Username then
                SendUUID(player,"Portal",value["GUID"])
            end
        end)
        Networking.MatchReplicationEvent.OnClientEvent:Connect(function(index,value)
            if index == "AddMatch" and tostring(value["Host"]) == Username then
                SendUUID(player,"Normal",value["GUID"])
            end
        end)
        local WaitTime = 120
        if Settings["Auto Join Rift"] and workspace:GetAttribute("IsRiftOpen") then
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then 
                        task.wait(math.random(2,10))
                        local Rift = require(game:GetService("StarterPlayer").Modules.Gameplay.Rifts.RiftsDataHandler)
                        local GUID = nil
                        for i,v in pairs(Rift.GetRifts()) do
                            if not v["Teleporting"] then
                                GUID = v["GUID"]
                            end
                        end
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                            "Join",
                            GUID
                        )
                        SendUUID(player,"Rift",GUID)
                    end
                end
                task.wait(2)
            end
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
                if AllPortal[1] then
                    table.sort(AllPortal, function(a, b)
                        return a[2] > b[2]
                    end)
                end
                return AllPortal[1] and AllPortal[1][1] or false
            end
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then
                        for i = 1,10 do task.wait(.2) 
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
                end
                task.wait(2)
            end
        elseif Settings["Select Mode"] == "Story" then
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then 
                        local StorySettings = Settings["Story Settings"]
                        StorySettings["Stage"] = DisplayToIndexStory(StorySettings["Stage"])
                        local args = {
                            [1] = "AddMatch",
                            [2] = StorySettings
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        task.wait(10)
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    end
                end
                task.wait(2)
            end
        elseif Settings["Select Mode"] == "Dungeon" then
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then 
                        local DungeonSettings = Settings["Dungeon Settings"]
                        DungeonSettings["Stage"] = DisplayToIndexDungeon(DungeonSettings["Stage"])
                        local args = {
                            [1] = "AddMatch",
                            [2] = DungeonSettings
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        task.wait(10)
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    end
                end
                task.wait(2)
            end
        elseif Settings["Select Mode"] == "Legend Stage" then
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then 
                        local LegendSettings = Settings["Legend Settings"]
                        LegendSettings["Stage"] = DisplayToIndexLegend(LegendSettings["Stage"])
                        local args = {
                            [1] = "AddMatch",
                            [2] = LegendSettings
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        task.wait(10)
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    end
                end
                task.wait(2)
            end
        elseif Settings["Select Mode"] == "Raid" then
            while true do
                if AllPlayerInGame(player) then
                    Next_(WaitTime)
                    if AllPlayerInGame(player) then 
                        local RaidSettings = Settings["Raid Settings"]
                        RaidSettings["Stage"] = DisplayToIndexRaid(RaidSettings["Stage"])
                        local args = {
                            [1] = "AddMatch",
                            [2] = RaidSettings
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        task.wait(10)
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    end
                end
                task.wait(2)
            end
        end
    end
end

-- Check Am I Kai
local GetKai = Get(Api .. MainSettings["Path_Kai"])
local IsKai = false
if GetKai['Success'] then
    local Body = HttpService:JSONDecode(GetKai['Body'])
    for i, v in pairs(Body["data"]) do
        if v['username'] == Username then
            IsKai = true
        end 
    end
end
if game.PlaceId == local_data[2] then
    if IsKai then
        print("Im Host")
        task.spawn(function()
            print("Im Host 1")
            local Looping = true
            while Looping do
                 print("Im Host 2")
                --pcall(function()
                    local get_my_order = GetCache(All_Key[IsGame] .. "-" .. Username)
                    local order_body = HttpService:JSONDecode(get_my_order["Body"])
                    local get_my_product = HttpService:JSONDecode(GetKai['Body'])
                    print(All_Key[IsGame] .. "-" .. Username,Username,get_my_order['Success'])
                    if get_my_order['Success'] then
                        local counting = 0
                        local myproducttofarm = nil
                        for i,v in pairs(order_body["data"]) do
                            counting = counting + 1
                            if v["2"] then
                                myproducttofarm = v["2"]
                            end 
                        end
                        print(counting,myproducttofarm)
                        if counting >= 1 and myproducttofarm then
                            Register_Room(myproducttofarm,order_body["data"])
                            Looping = false
                            print("Breaking Loop!!!!!!!!!!!!!!!!!")
                        end
                    else
                        print("No Party Host")
                    end
                --end)
                task.wait(10)
            end
        end) 
    else
        print("Im User")
        local data = Fetch_data() if not data["want_carry"] then return false end
        local myproduct = data["product_id"]
        local order_id = data["id"]
        local all_kai = Get(Api .. MainSettings["Path_Kai"] .. "/search?product_id=" .. myproduct)
        local body_kai = HttpService:JSONDecode(all_kai['Body'])

        local function is_in_party()
            return GetCache(order_id .. "_party")['Success']
        end
        if is_in_party() then
            local Cache_1 = HttpService:JSONDecode(GetCache(order_id .. "_party")['Body'])
            local splitOwner = Cache_1["data"]["join"]:split("-")
            local OwnerName = splitOwner[#splitOwner]
            if Get(Api .. MainSettings["Path_Kai"] .. "/search?username=" .. OwnerName) then
                Delete(Api .. MainSettings["Path_Cache"] .. "/" .. order_id .. "_party")
                Delete(Api .. MainSettings["Path_Cache"] .. "/" .. Cache_1["data"]["join"])
            end
        end
        print(is_in_party(),order_id .. "_party")
        while not is_in_party() do
             print("No Party")
            local IsContinue = false
            all_kai = Get(Api .. MainSettings["Path_Kai"] .. "/search?product_id=" .. myproduct)
             print("User",all_kai,all_kai['Success'],myproduct)

            if all_kai['Success'] then
                body_kai = HttpService:JSONDecode(all_kai['Body'])
                
                for i,v in pairs(body_kai['data']) do
                    local counting = 0
                    local Cache_ = GetCache(All_Key[IsGame] .. "-" .. v["username"])

                    if not Cache_["Success"] then
                        Post(Api .. MainSettings["Path_Cache"],{["index"] = All_Key[IsGame] .. "-" ..  v["username"]},{["value"] = {
                            [Username] = {["1"] = order_id,["2"] = myproduct},
                        }})
                        Post(Api .. MainSettings["Path_Cache"],{["index"] = order_id .. "_party"},{["value"] = {
                            ["join"] = All_Key[IsGame] .. "-" ..  v["username"],
                        }})
                        IsContinue = true
                        break;
                    else
                        local Cache = HttpService:JSONDecode(Cache_["Body"]) 
                        local NewTable = table.clone(Cache['data'])
                        for i,v in pairs(Cache['data']) do
                            counting = counting + 1
                        end
                        if counting < 4 then
                            NewTable[Username] = {["1"] = order_id}
                            Post(Api .. MainSettings["Path_Cache"],{["index"] = All_Key[IsGame] .. "-" ..  v["username"]},{["value"] = NewTable})
                            Post(Api .. MainSettings["Path_Cache"],{["index"] = order_id .. "_party"},{["value"] = {
                                ["join"] = All_Key[IsGame] .. "-" ..  v["username"],
                            }})
                            IsContinue = true
                            break;
                        else
                            continue;
                        end
                    end
                end
            end
           
            if IsContinue then
                break;
            end 
            task.wait(10)
        end
        print("Im in the party")
        task.wait(3)
        task.spawn(function()
            while task.wait(2) do
                --pcall(function()
                    local get_my_room = GetCache(Username)
                     print(get_my_room["Success"])
                    if get_my_room["Success"] then
                        local val = HttpService:JSONDecode(get_my_room["Body"])["data"]

                        if tonumber(val["os"]) >= os.time() then
                            Join(val["type"],val["data"])
                        end
                    end
                --end)
            end
        end) 
    end 
else
    print(":P")
end
