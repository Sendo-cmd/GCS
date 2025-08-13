task.spawn(function()
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
    local Order_Type = {
        ["Challenge"] = {
            "44013587-aa9e-4ca9-8c5a-8503fb61779b",
            "bc0fca7b-dde2-47a6-a50b-793d8782999b",
            "39ce32e2-c34c-4479-8a52-5715e8645944",
        },
        ["Super Reroll"] = {
            "edbd1859-f374-4735-87c7-2b0487808665",
            "c480797f-3035-4b1f-99a3-d77181f338bf",
            "63c63616-134c-4450-a5d6-a73c7d44d537",
        },
        ["Igros"] = {
            "c040bd90-d939-4f0c-b65d-1e0ace06a434",
            "c4ca5b41-f68f-4e7b-a8e7-8b2ee7284d08",
            "5a2a67e9-7407-4437-bc2e-c332135cec53",
        },
        ["Boss Event"] = {
            "abb151e9-5e2a-40d3-91fe-7da3ee03f1aa",
            "5a815e6f-7024-4e6e-9d30-50cda9a765bd",
            "66ace527-415a-4b1f-a512-9f3429f67067",
        },
        ["Boo"] = {
            "12b453cd-7435-425e-977e-1ae97f04cc23",
            "9d07aae3-76ca-4976-a29c-9f6ece183ade",
            "ef2bf1de-f30f-46aa-98bb-4a34635a2ed8",
        },
        ["Delusional Boy"] = {
            "d8b5cc8c-effd-4521-9db9-04fb460cd225",
            "30a613fb-29c9-4b88-b18b-1b4231a5468d",
            "dfa9b68a-95d7-4227-b118-702cf45061c7",
        },
        ["Lfelt"] = {
            "785409b0-02f9-4bb8-8ad8-b383b59f6f54",
            "bc1be299-c561-4a41-964a-a055f8a8e436",
            "1c58db6a-b5d1-4d8d-8195-75aad0403c90",
        },
        ["Red Key"] = {
            "cfbb32d7-64cb-4135-b1e3-1992e1800d07",
            "e1a0c37a-c004-4ff3-a064-2b7d55703c3e",
            "b752455d-18d7-4bb3-bd67-70269790500f",
        },
        ["Yomomata"] = {
            "e7403190-850c-49e5-b2b0-b4949e477c47",
            "139a8d72-0bfb-478b-98e4-5dd152f01206",
            "7d480a51-e6df-45e7-b0f8-9e34966ecc7e",
        },
        ["Spring Portal"] = {
            "960de970-ba26-4184-8d97-561ae8511e4b",
            "24cbfd35-8df6-4fc7-8c0f-5e9c4b921013",
            "0495121f-a579-4068-9494-4a1ac477613b",
            "6ace8ed9-915e-474a-af43-39328ea80a4f",
        },
        ["Arin"] = {
            "89901139-d4b5-4555-8913-4900d176546c",
            "7b29fe07-6313-48cb-a095-3680d4758ab6",
            "1e07ff1f-ab45-466b-8b36-ae0ff8b43198",
        },
        ["Summer Portal"] = {
            "c62223a2-17f9-4078-bbc0-bb45c484558f",
            "d92fceaa-8d18-4dc9-980f-452db4573ad9",
            "ffa517b2-7f99-47a8-aadc-d7662b96eb60",
        },
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
    local function LenT(var)
        local counting = 0
        for i,v in pairs(var) do
            counting = counting + 1
        end 
        return counting
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
        if not Data["Success"] then
            return false
        end
        local Order_Data = HttpService:JSONDecode(Data["Body"])
        return Order_Data["data"][1]
    end
    if not Fetch_data() then
        Client:Kick("Cannot Get Data")
    end
    local function DecBody(body)
        return HttpService:JSONDecode(body["Body"])["data"]
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
    local function SendCache(...)
        return Post(Api .. MainSettings["Path_Cache"],...)
    end
    local function DelCache(OrderId)
        local response = request({
            ["Url"] = Api .. MainSettings["Path_Cache"] .. "/" .. OrderId,
            ["Method"] = "DELETE",
            ["Headers"] = {
                ["content-type"] = "application/json",
                ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
            },
        })
        return response
    end
    local function GetCache(OrderId)
         print(OrderId)
        local Cache = Get(Api .. MainSettings["Path_Cache"] .. "/" .. OrderId)
        local Data = DecBody(Cache)
        
        if not Cache["Success"] then
            print("False")
            return false
        end
        return Data
    end
    local function UpdateCache(OrderId,...)
        local args = {...}
        local data = GetCache(OrderId)

        if not data then warn("Cannot Update") return false end
        for i,v in pairs(args) do
            for i1,v1 in pairs(v) do
                print(i1,v1)
                data[i1] = v1
            end
        end
        warn("Update Cache")
        return SendCache({
            ["index"] = OrderId
        },
        {
            ["value"] = data,
        })
    end
    local function AllPlayerInGame(data)
        for i,v in pairs(data) do
            if not game:GetService("Players"):FindFirstChild(i) then
                return false
            end
        end
        return true
    end
    local function Register_Room(myproduct,player,func)
        if IsGame == "AV" then
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
                ["6ace8ed9-915e-474a-af43-39328ea80a4f"] = function()
                    Settings["Select Mode"] = "Portal"
                    Settings["Portal Settings"] = {
                    ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
                    ["Tier Cap"] = 10,
                    ["Method"] = "Highest", -- Highest , Lowest
                    ["Ignore Stage"] = {},
                    ["Ignore Modify"] = {},
                }
                end,
                ["c62223a2-17f9-4078-bbc0-bb45c484558f"] = function()
                    Settings["Select Mode"] = "Portal"
                    Settings["Portal Settings"] = {
                    ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
                    ["Tier Cap"] = 10,
                    ["Method"] = "Highest", -- Highest , Lowest
                    ["Ignore Stage"] = {},
                    ["Ignore Modify"] = {},
                }
                end,
                ["d92fceaa-8d18-4dc9-980f-452db4573ad9"] = function()
                    Settings["Select Mode"] = "Portal"
                    Settings["Portal Settings"] = {
                    ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
                    ["Tier Cap"] = 10,
                    ["Method"] = "Highest", -- Highest , Lowest
                    ["Ignore Stage"] = {},
                    ["Ignore Modify"] = {},
                }
                end,
                ["ffa517b2-7f99-47a8-aadc-d7662b96eb60"] = function()
                    Settings["Select Mode"] = "Portal"
                    Settings["Portal Settings"] = {
                    ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
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
                ["29fe5885-c673-46cf-9ba4-a7f42c2ba0b0"] = function()
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
                ["5852f3ef-a949-4df5-931b-66ac0ac84625"] = function()
                    Settings["Auto Join Challenge"] = true
                    Settings["Auto Join Bounty"] = false
                    Settings["Select Mode"] = "Story"
                    Settings["Story Settings"] = {
                    ["Difficulty"] = "Normal",
                    ["Act"] = "infinite",
                    ["StageType"] = "Story",
                    ["Stage"] = "Planet Namak",
                    ["FriendsOnly"] = false
                }
                end,
                ["723de53d-cedd-4972-a6e5-6c44bf8699e9"] = function()
                    Settings["Select Mode"] = "AFK"
                end,
                ["79183580-1d86-4c97-b3c5-5ac9aac1c755"] = function()
                    Settings["Select Mode"] = "AFK"
                end,
                ["562e53d5-22c8-4337-a5bc-c36df924524b"] = function()
                    Settings["Select Mode"] = "World Line"
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
            local function Invite(plr)
                local args = {
                    "Invite",
                    {
                       Players:WaitForChild(plr),
                        {
                            Difficulty = "Normal",
                            StageType = "Story",
                            Stage = "Stage1",
                            Act = "Act1"
                        }
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Invites"):WaitForChild("InviteEvent"):FireServer(unpack(args))
            end
            local function IndexToDisplay(arg)
                return StagesData["Story"][arg]["StageData"]["Name"]
            end
            local WaitTime = 30
            if Settings["Auto Join Rift"] and workspace:GetAttribute("IsRiftOpen") then
                while true do
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then 
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
                            task.wait(2)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                            
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
                        if Ignore(v["ExtraData"]["Modifiers"],Settings_["Ignore Modify"]) and Settings_["Tier Cap"] >= v["ExtraData"]["Tier"] then
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
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then
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
                            task.wait(2)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                        end
                    end
                    task.wait(2)
                end
            elseif Settings["Select Mode"] == "Story" then
                while true do
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then 
                            local StorySettings = Settings["Story Settings"]
                            StorySettings["Stage"] = DisplayToIndexStory(StorySettings["Stage"])
                            local args = {
                                [1] = "AddMatch",
                                [2] = StorySettings
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                            task.wait(5)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                            task.wait(5)
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
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then 
                            local DungeonSettings = Settings["Dungeon Settings"]
                            DungeonSettings["Stage"] = DisplayToIndexDungeon(DungeonSettings["Stage"])
                            local args = {
                                [1] = "AddMatch",
                                [2] = DungeonSettings
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                            task.wait(5)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                            task.wait(5)
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
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then 
                            local LegendSettings = Settings["Legend Settings"]
                            LegendSettings["Stage"] = DisplayToIndexLegend(LegendSettings["Stage"])
                            local args = {
                                [1] = "AddMatch",
                                [2] = LegendSettings
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                            task.wait(5)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                            task.wait(5)
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
                    if AllPlayerInGame(player) and func() then
                        Next_(WaitTime)
                        if AllPlayerInGame(player) and func() then 
                            local RaidSettings = Settings["Raid Settings"]
                            RaidSettings["Stage"] = DisplayToIndexRaid(RaidSettings["Stage"])
                            local args = {
                                [1] = "AddMatch",
                                [2] = RaidSettings
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                            task.wait(5)
                            for i,v in pairs(player) do
                                Invite(i)
                            end
                            task.wait(5)
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
    if GetKai["Success"] then
        for i, v in pairs(DecBody(GetKai)) do
            if v["username"] == Username then
                IsKai = true
            end 
        end
    end
    if ID[game.GameId][1] == "AV" then

        local Networking = ReplicatedStorage:WaitForChild("Networking")

        local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
        local Modules = ReplicatedStorage:WaitForChild("Modules")

        local SettingsHandler = require(PlayerModules.Gameplay.SettingsHandler)
        local StagesData = require(Modules.Data.StagesData)
        local UnitsData = require(Modules.Data.Entities.Units)
        local ItemsData = require(Modules.Data.ItemsData)
        repeat task.wait() until SettingsHandler.SettingsLoaded
        if game.PlaceId == local_data[2] then
            if IsKai then
                task.wait(math.random(10,15))
                -- Register Self
                local cache = GetCache(Username)
                if cache then
                    -- This is check if kai disconnect for 200s 
                    if os.time() > cache["last_online"] then
                        DelCache(Username)
                    end
                end
                while not GetCache(Username) do 
                    SendCache(
                            {
                                ["index"] = Username
                            },
                            {
                                ["value"] = {
                                    ["last_online"] = os.time() + 200,
                                    ["current_play"] = "",
                                    ["party_member"] = {},
                            }
                        }
                    )
                    task.wait(5)
                end 

                local Attempt = 0
                local Last_Message = nil
                local Current_Party = GetCache(Username)["party_member"]
                -- Auto Accept Party
                task.spawn(function()
                    while task.wait(1) do
                        local message = GetCache(Username .. "-message")
                        if message and Last_Message ~= message["message-id"] then
                            local cache = GetCache(Username)
                            local old_party = table.clone(cache["party_member"])
                            if LenT(old_party) < 3 then
                                local cache = GetCache(message["order"])
                                old_party[message["order"]] = {
                                    ["join_time"] = os.time(),
                                    ["product_id"] = cache["product_id"],
                                    ["name"] = cache["name"],
                                } 
                                UpdateCache(Username,{["party_member"] = old_party})
                                UpdateCache(message["order"],{["party"] = Username})
                                Current_Party[cache["name"]] = false
                            end
                            Last_Message = message["message-id"]
                            task.wait(3)
                        end
                        Attempt = Attempt + 1
                        if Attempt > 5 then
                            UpdateCache(Username,{["last_online"] = os.time() + 200})
                            Attempt = 0
                        end
                    end
                end) 
                
                -- Auto Clear Party
                task.spawn(function()
                    while task.wait(1) do
                        local message = GetCache(Username .. "-message-2")
                        if message and Last_Message ~= message["message-id"] then
                            local cache = GetCache(Username)
                            local old_party = table.clone(cache["party_member"])
                            if old_party[message["order"]] then
                                old_party[message["order"]] = nil
                                UpdateCache(Username,{["party_member"] = old_party})
                                UpdateCache(message["order"],{["party"] = ""})
                                Current_Party[cache["name"]] = nil
                            end
                            Last_Message = message["message-id"]
                            task.wait(3)
                        end
                    end
                end)
                
                -- Get Product 
                local Product = nil
                while not Product do 
                    local cache = GetCache(Username)
                    local path = nil
                    local lowest = math.huge
                    for i,v in pairs(cache["party_member"]) do
                        if v["join_time"] < lowest then
                            path = v["product_id"]
                            lowest = v["join_time"]
                        end
                    end
                    Product = path
                    task.wait(2)
                end 
                UpdateCache(Username,{["current_play"] = Product}) 
                local Counting = {} 
                for i,v in pairs(Current_Party) do
                    Counting[v["name"]] = false
                end
                Networking.Invites.InviteBannerEvent.OnClientEvent:Connect(function(type_,value_)
                    if type_ == "Create" and value_["InvitedBy"] then
                        Counting[value_["InvitedBy"]] = true
                    end
                end)
                Players.PlayerRemoving:Connect(function(v)
                    if Counting[v["Name"]] then
                        Counting[v["Name"]] = false
                    end
                end)
                local function IsItTrue()
                    for i,v in pairs(Counting) do
                        if not v then
                            return false
                        end
                    end
                    return true
                end
                while not IsItTrue() or not AllPlayerInGame(Counting) do print(IsItTrue() , AllPlayerInGame(Counting)) task.wait(1) end
                print("Register_Room")
                Register_Room(Product,Counting,IsItTrue)
            else
                task.wait(math.random(5,10))
                local data = Fetch_data() 
                local productid = data["product_id"]
                local orderid = data["id"]
                if not data["want_carry"] then return false end
                -- Register Self
                while not GetCache(orderid .. "_cache") do 
                    SendCache(
                            {
                                ["index"] = orderid .. "_cache"
                            },
                            {
                                ["value"] = {
                                    ["name"] = Username,
                                    ["product_id"] = productid,
                                    ["party"] = "",
                            }
                        }
                    )
                    task.wait(5)
                end 
                task.wait(1.5)
                if not GetCache(orderid .. "_cache") then
                    print("No Cache")
                    return false
                end
                -- Find Party
                while true do 
                    local cache = GetCache(orderid .. "_cache")
                    print(cache)
                    if #cache["party"] > 2 then
                        print("In The Party")
                        break;
                    end
                    for i, v in pairs(DecBody(GetKai)) do
                        local kai_cache = GetCache(v["username"])
                        if kai_cache then
                            if os.time() > kai_cache["last_online"] then
                                continue;
                            end
                            if #kai_cache["party_member"] >= 3 then
                                continue;
                            end
                            local kaiproduct = kai_cache["current_play"]
                            if #kaiproduct > 10 then
                                local Product_Type_1,Product_Type_2 = nil,nil
                                for i,v in pairs(Order_Type) do
                                    if table.find(v,kaiproduct) then
                                        Product_Type_1 = i
                                    end
                                    if table.find(v,productid) then
                                        Product_Type_2 = i
                                    end
                                end
                                if Product_Type_1 ~= Product_Type_2 then
                                    continue;
                                end
                                for i = 1,5 do
                                    SendCache(
                                        {
                                            ["index"] = v["username"] .. "-message"
                                        },
                                        {
                                            ["value"] = {
                                                ["order"] = orderid .. "_cache",
                                                ["message-id"] = HttpService:GenerateGUID(false)
                                            },
                                        }
                                    )
                                    task.wait(5)
                                    local cache = GetCache(orderid .. "_cache")
                                    if #cache["party"] > 2 then
                                        print("In The Party")
                                        break;
                                    end
                                end
                                local cache = GetCache(orderid .. "_cache")
                                if #cache["party"] > 2 then
                                    print("In The Party")
                                    break;
                                end
                            else
                                for i = 1,5 do
                                    SendCache(
                                        {
                                            ["index"] = v["username"] .. "-message"
                                        },
                                        {
                                            ["value"] = {
                                                ["order"] = orderid .. "_cache",
                                                ["message-id"] = HttpService:GenerateGUID(false)
                                            },
                                        }
                                    )
                                    task.wait(5)
                                    local cache = GetCache(orderid .. "_cache")
                                    if #cache["party"] > 2 then
                                        print("In The Party")
                                        break;
                                    end
                                end
                                local cache = GetCache(orderid .. "_cache")
                                if #cache["party"] > 2 then
                                    print("In The Party")
                                    break;
                                end
                            end
                        end
                    end
                    task.wait(5)
                end 
                local cache = GetCache(orderid .. "_cache")
                if #cache["party"] <= 3 then
                    print("Where The Fuck Your Party")
                    return;
                end
                -- Waiting Party
                _G.Leave_Party = function()
                    local cache_ = GetCache(orderid .. "_cache")
                    if cache_ then
                        while #cache_["party"] > 3 do 
                            SendCache(
                                {
                                    ["index"] = cache_["party"] .. "-message-2"
                                },
                                {
                                    ["value"] = {
                                        ["order"] = orderid .. "_cache",
                                        ["message-id"] = HttpService:GenerateGUID(false)
                                    },
                                }
                            )
                            task.wait(3)
                            cache_ = GetCache(orderid .. "_cache")
                        end
                    end
                end
                local cache_ = GetCache(orderid .. "_cache")
                task.spawn(function()
                    while true do
                        local cache = GetCache(cache_["party"])
                        if os.time() > cache["last_online"] then
                            
                        else
                            local args = {
                                "Invite",
                                {
                                    Players:WaitForChild(cache_["party"]),
                                    {Difficulty = "Normal",StageType = "Story",Stage = "Stage1",Act = "Act1"}
                                }
                            }
                            Networking:WaitForChild("Invites"):WaitForChild("InviteEvent"):FireServer(unpack(args))
                            print("Host is Online!!\nLast Online : ",os.time() - (cache["last_online"] - 200))
                        end
                        task.wait(5)
                    end
                end)
                task.wait(3)
                Networking.Invites.InviteBannerEvent.OnClientEvent:Connect(function(type_,value_)
                    if type_ == "Create" and value_["InvitedBy"] == cache_["party"] then
                        local args = {
                            "AcceptInvite",
                            value_["GUID"]
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Invites"):WaitForChild("InviteEvent"):FireServer(unpack(args))

                    end
                end)
            end
        else
            if IsKai then
                local Attempt = 0
                local Last_Message = nil
                -- Auto Accept Party
               task.spawn(function()
                    while task.wait(1) do
                        local message = GetCache(Username .. "-message")
                        if message and Last_Message ~= message["message-id"] then
                            local cache = GetCache(Username)
                            local old_party = table.clone(cache["party_member"])
                            if LenT(old_party) < 3 then
                                local cache = GetCache(message["order"])
                                old_party[message["order"]] = {
                                    ["join_time"] = os.time(),
                                    ["product_id"] = cache["product_id"],
                                    ["name"] = cache["name"],
                                }
                                UpdateCache(Username,{["party_member"] = old_party})
                                UpdateCache(message["order"],{["party"] = Username})
                            end
                            Last_Message = message["message-id"]
                            task.wait(3)
                        end
                        Attempt = Attempt + 1
                        if Attempt > 5 then
                            UpdateCache(Username,{["last_online"] = os.time() + 200})
                            Attempt = 0
                        end
                    end
                end)
                -- Auto Clear Party
                task.spawn(function()
                    while task.wait(1) do
                        local message = GetCache(Username .. "-message-2")
                        if message and Last_Message ~= message["message-id"] then
                            local cache = GetCache(Username)
                            local old_party = table.clone(cache["party_member"])
                            if old_party[message["order"]] then
                                old_party[message["order"]] = nil
                                UpdateCache(Username,{["party_member"] = old_party})
                                UpdateCache(message["order"],{["party"] = ""})
                            end
                            Last_Message = message["message-id"]
                            task.wait(3)
                        end
                    end
                end)
                -- Check If End Game And Not Found A Player
                Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                    local cache = GetCache(Username)
                    if #Players:GetChildren() ~= LenT(cache["party_member"]) + 1 then

                        game:shutdown()
                    end
                end)
                -- Check If No Player In Lobby 
                task.wait(30)
                task.spawn(function()
                    while task.wait(1) do
                        if #Players:GetChildren() <= 1 then
                            game:shutdown()
                        end
                    end
                end)
            else
                local cache = GetCache(Username)
                local host = cache["party"]
                -- Check If No Host In Lobby 
                task.wait(30)
                task.spawn(function()
                    while task.wait(1) do
                        if not Players:FindFirstChild(host) then
                            print("Not Found a Host")
                            game:shutdown()
                        else
                            print("Host stay at same lobby")
                        end
                    end
                end)
            end
        end
    end 
end)
