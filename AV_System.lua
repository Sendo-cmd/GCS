repeat task.wait() until game:IsLoaded()
task.spawn(function()
    local IsLoading = false
    while not IsLoading do
        for i, v in pairs(getgc(true)) do
            if
                type(v) == 'table'
                and rawget(v, 'HandleLoadingScreen')
                and rawget(v, 'FinishedLoading')
            then
                rawset(v, 'HandleLoadingScreen', function() end)
                rawget(v, 'FinishedLoading'):Fire()
                rawset(v, 'IsFinishedLoading', true)

                require(
                    game:GetService('ReplicatedFirst').BlackScreen.BlackScreenHandler
                ).Close()
                IsLoading = true
            end
        end
        task.wait(1)
    end
end)

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
coroutine.resume(coroutine.create(function()
    local function Press(args)
        game:GetService('VirtualInputManager'):SendKeyEvent(
            true,
            args,
            false,
            game.Players.LocalPlayer.Character.HumanoidRootPart
        )
        wait()
        game:GetService('VirtualInputManager'):SendKeyEvent(
            false,
            args,
            false,
            game.Players.LocalPlayer.Character.HumanoidRootPart
        )
    end
    while wait() do
        pcall(function()
            Press('Space')
            wait(1000)
        end)
    end
end))
--[[
Portal 
Sand Village
Double Dungeon
Planet Namak
Shibuya Station
Underground Church
Spirit Society
]]

--[[
Story Stage Map
Planet Namak
Spirit Society
Martial Island
Underground Church
Sand Village
Shibuya Station
Double Dungeon
Lebereo Raid
]]

--[[
Legend Stage Map
Sand Village
Kuinshi Palace
Land of the Gods
Golden Castle
Shibuya Aftermath
Double Dungeon
Crystal Chapel
]]

--[[
Dungeon Map
Mountain Shrine (Natural)
Ant Island
]]

--[[
Raid Map
Spider Forest
Tracks at the Edge of the World
Ruined City
]]

_G.User = {}

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

local function Len(tab)
    local count = 0
    for i,v in pairs(tab) do
        count = count + 1
    end
    return count
end


-- All Variables
-- local Key = "Onio_#@@421"
local plr = game.Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local Inventory = {}

local Settings ={

    ["Select Mode"] = "Portal", -- Portal , Dungeon , Story , Legend Stage , Raid , Challenge , Boss Event , World Line , Bounty , AFK
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
    -- ถ้าต้องการสร้าง configs แบบไหนให้ order ก็เปลี่ยนแปลงเหมือนใส่ config ธรรมดาได้เลย สร้างครั้งนึงแล้วเหมือนกันทุก order
    -- ["2e2a5d02-4d63-43a5-8b9a-6e7902581cfd"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["960de970-ba26-4184-8d97-561ae8511e4b"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["24cbfd35-8df6-4fc7-8c0f-5e9c4b921013"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["0495121f-a579-4068-9494-4a1ac477613b"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["6ace8ed9-915e-474a-af43-39328ea80a4f"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["1e3dd6cd-e3d2-4dae-810f-911df0ab4806"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["abc198e7-cdfc-497d-83d6-a5c9f88f3c22"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["69d6b35d-0dc0-46d5-96c6-be037b876cdd"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["e206ec24-dfbf-4157-a380-9afabe115c29"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["c62223a2-17f9-4078-bbc0-bb45c484558f"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["d92fceaa-8d18-4dc9-980f-452db4573ad9"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["ffa517b2-7f99-47a8-aadc-d7662b96eb60"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["c869c464-6864-4eb7-a98f-f78f3448b71c"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["fc7a340c-7c98-4da6-84aa-a7e3ce4790c1"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- ["d551991a-b8ec-4fe5-96f5-2fe6418a3e9a"] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 215, -- 113 Love , 87 Winter , 190 Spring
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
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
        Settings["Auto Priority"] = true
        Settings["Priority"] = "Bosses"
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
        Settings["Auto Priority"] = true
        Settings["Priority"] = "Bosses"
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
        Settings["Auto Priority"] = true
        Settings["Priority"] = "Bosses"
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "Ruined City",
        ["FriendsOnly"] = false
    }
    end,
    ["e4ed794a-8569-4da6-976d-829ac43f423f"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "AntIsland",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Ant Island",
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
    ["2e2a5d02-4d63-43a5-8b9a-6e7902581cfd"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["960de970-ba26-4184-8d97-561ae8511e4b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["24cbfd35-8df6-4fc7-8c0f-5e9c4b921013"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["0495121f-a579-4068-9494-4a1ac477613b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
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
    ["d85e3e85-0893-4972-a145-d6ba42bac512"] = function()
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
    ["03237ef-99e7-4a53-b61a-1ac9ca8dee60"] = function()
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
    ["2a77cde0-0bab-4880-a01e-8bbe4b76956e"] = function()
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
    ["df999032-bd9e-4933-bba1-a037997ce505"] = function()
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
    ["abb151e9-5e2a-40d3-91fe-7da3ee03f1aa"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
        ["Stage"] = "SaberEvent",
    }
    end,
    ["5a815e6f-7024-4e6e-9d30-50cda9a765bd"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
        ["Stage"] = "SaberEvent",
    }
    end,
    ["66ace527-415a-4b1f-a512-9f3429f67067"] = function()
        Settings["Select Mode"] = "Boss Event"
        Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
        ["Stage"] = "SaberEvent",
    }
    end,

    ["a551241f-b981-4b84-8b61-ce5ac449b9f0"] = function()
        Settings["Auto Join Rift"] = true
    end,
    ["2b9574ad-1cbe-48dd-bf50-1ee864adf464"] = function()
        Settings["Select Mode"] = "AFK"
    end,
    ["723de53d-cedd-4972-a6e5-6c44bf8699e9"] = function()
        Settings["Select Mode"] = "AFK"
    end,
    ["79183580-1d86-4c97-b3c5-5ac9aac1c755"] = function()
        Settings["Select Mode"] = "AFK"
    end,
    ["1c335fe4-5fb6-4894-9c3e-83216bc419a9"] = function()
        Settings["Select Mode"] = "World Line"
    end,
    ["562e53d5-22c8-4337-a5bc-c36df924524b"] = function()
        Settings["Select Mode"] = "World Line"
    end,
}
if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end

-- Auto Configs
local Api = "https://api.championshop.date/" -- Api ใส่ / ลงท้ายด้วย เช่น www.google.com/
local Key = "NO_ORDER" 
local PathWay = Api .. "api/v1/shop/orders/"  -- ที่ผมเข้าใจคือ orders คือจุดกระจาย order ตัวอื่นๆ 
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
    local Data = Get(PathWay .. plr.Name)
    -- print(Data["Body"])
    local Order_Data = HttpService:JSONDecode(Data["Body"])["data"]
    return Order_Data[1]
end
local function CreateBody(...)
    local Order_Data = Fetch_data()
    local body = {
        ["order_id"] = Order_Data["id"],
    }
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
local function Post_(Url,data)
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(data)
    })
   
    return response
end
local function GetCache(Id)
    return Get(Api .. "/api/v1/shop/orders/cache/" .. Id)
end
local function is_in_party(order_id)
    local data = GetCache(order_id .. "_party")
    return data['Success'] , HttpService:JSONDecode(data)
end
local function DecBody(body)
    return HttpService:JSONDecode(body["Body"])["data"]
end
local GetKai = Get(Api .. "api/v1/shop/accountskai")
local IsKai = false
if GetKai["Success"] then
    for i, v in pairs(DecBody(GetKai)) do
        if v["username"] == plr.Name then
            IsKai = true
        end 
    end
end
if IsKai then
    return false
end
local Auto_Configs = true
local function Auto_Config()
    if Auto_Configs then
        local OrderData = Fetch_data()
        if OrderData then
            Key = OrderData["id"]
        else
            print("Cannot Fetch Data")
            return false;
        end
        local ConnectToEnd 
        local Order = Get(PathWay .. "cache/" .. Key)
        if Changes[OrderData["product_id"]] then
            Changes[OrderData["product_id"]]()
            print("Changed Configs")
        end 
        if Settings["Select Mode"] == "AFK" then
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("AFKEvent"):FireServer()
            local Product = OrderData["product"]
            task.spawn(function()
                while true do
                    if Product["condition"]["type"] == "hour" then
                        if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                            Post(PathWay .. "finished", CreateBody())
                        end
                    end
                    task.wait(200)
                end
            end)
            return false
        end

        if OrderData["want_carry"] then
            Settings["Party Mode"] = true
        end
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local Modules = ReplicatedStorage:WaitForChild("Modules")
        local Utilities = Modules:WaitForChild("Utilities")
        local Networking = ReplicatedStorage:WaitForChild("Networking")
        local UnitsData = require(Modules.Data.Entities.Units)
        local function GetData()
            local SkinTable = {}
            local FamiliarTable = {}
            local Inventory = {}
            local EquippedUnits = {}
            local Units = {}
            local Battlepass = 0
            local Val_1,Val_2,Val_3 = false,false,false

            local NumberUtils = require(Utilities.NumberUtils)
            local TableUtils = require(Utilities.TableUtils)
            if game.PlaceId == 16146832113 then
              
                local ItemsData = require(Modules.Data.ItemsData)
                local UnitWindowHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.UnitWindowHandler)
                local BattlepassHandler = require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler)
                
                for i,v in pairs(UnitWindowHandler.EquippedUnits) do
                    if i == "None" then continue end

                    EquippedUnits[i] = TableUtils.DeepCopy(UnitWindowHandler._Cache[i])
                    EquippedUnits[i].Name = EquippedUnits[i].UnitData.Name

                    EquippedUnits[i].UnitData = nil
                end

                

                for i,v in pairs(UnitWindowHandler._Cache) do
                    if not v.UnitData then continue end
                    Units[i] = v.UnitData.Name
                end
                game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(val)
                    Inventory = {}
                    for i,v in pairs(val) do
                        if v then 
                            local call,err = pcall(function()
                                Inventory[i] = ItemsData.GetItemDataByID(true,v["ID"])
                                Inventory[i]["ID"] = v["ID"]
                                Inventory[i]["AMOUNT"] = v["Amount"]
                            end) 
                        end
                    end
                    Val_1 = true
                    print("Inventory Updated",os.time())
                end)
                game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent.OnClientEvent:Connect(function(val)
                    FamiliarTable = val
                    Val_2 = true
                end)
                game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent.OnClientEvent:Connect(function(val)
                    SkinTable = val
                    Val_3 = true
                end)
                Battlepass =  BattlepassHandler:GetPlayerData()
            else
                local UnitsHUD = require(game:GetService("StarterPlayer").Modules.Interface.Loader.HUD.Units)
                local UnitWindowHandler = require(game:GetService('StarterPlayer').Modules.Interface.Loader.Windows.UnitWindowHandler)
                for i, v in pairs(UnitWindowHandler["_Cache"]) do
                    if not v.UnitData then continue end
                    Units[i] = v.UnitData.Name
                end
                for i,v in pairs(UnitsHUD._Cache) do
                    if v == "None" then continue end
                    EquippedUnits[v.UniqueIdentifier] = TableUtils.DeepCopy(v)

                    EquippedUnits[v.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v.Identifier).Name
                end
                local Inventory = {}
                game:GetService("ReplicatedStorage").Networking.InventoryEvent.OnClientEvent:Connect(function(val,val1)
                    Inventory = {}
                    for i,v in pairs(val1) do
                        print(os.time(),i,v)
                        if v then 
                            local call,err = pcall(function()
                                Inventory[i]["NAME"] = ItemsData.GetItemDataByID(true,v["ID"])
                                Inventory[i]["ID"] = v["ID"]
                                Inventory[i]["AMOUNT"] = v["Amount"]
                            end) 
                        end
                    end
                    Val_1 = true
                    print("Inventory Updated",os.time())
                end)
                game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent.OnClientEvent:Connect(function(val)
                    FamiliarTable = val
                     Val_2 = true
                    print("Family Updated",os.time())
                end)
                game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent.OnClientEvent:Connect(function(val)
                    SkinTable = val
                    Val_3 = true
                    print("Skin Updated",os.time())
                end)

            end
            local PlayerData = plr:GetAttributes()
            
        
            repeat 
                -- print("Stucking")
                if game.PlaceId == 16146832113 then
                    game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer()
                    game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
                    game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()
                else
                    game:GetService("ReplicatedStorage").Networking.InventoryEvent:FireServer()
                    game:GetService("ReplicatedStorage").Networking.Familiars.RequestFamiliarsEvent:FireServer()
                    game:GetService("ReplicatedStorage").Networking.Skins.RequestSkinsEvent:FireServer()
                end
               
                -- print(Val_3 , Val_2 , Val_1)
                task.wait(1) 
            until Val_3 and Val_2 and Val_1

            return {
                ["Units"] = Units,
                ["Skins"] = SkinTable,
                ["Familiars"] = FamiliarTable,
                ["Inventory"] = Inventory,
                ["Username"] = plr.Name,
                ["Battlepass"] = Battlepass,
                ["PlayerData"] = PlayerData,
                ["EquippedUnits"] = EquippedUnits,
            }
        end
        -- Post_Data_FirstTime ส่วนนี้จะทำการเก็บ data มา 1 ครั้งก่อนเริ่ม ถ้าสมมุติจบงานแล้ว ยังเจออยู่อาจจะทำให้มีปัญหาได้
        -- ผมใส่เป็น cache เลยถ้ามันไม่เจอให้สร้าง
        if not Order["Success"] then
            Post_(PathWay .. "cache",{
                ["index"] = Key,
                ["value"] = GetData()
            })
        else 
            local Data = GetData()
            local OldData = HttpService:JSONDecode(Order["Body"])['data']
            local Product = OrderData["product"]
            local Goal = Product["condition"]["value"]
            
            local function GetUnit(path,name)
                local InsertUnits = {}
                for i,v in pairs(path) do
                    if v.UnitData == name then
                        table.insert(InsertUnits,i)
                    end
                end
                return #InsertUnits
            end
            local function GetItem(path,name)
                local InsertItems = {}
                for i,v in pairs(path) do
                    if v.NAME == name then
                        table.insert(InsertItems,i)
                    end
                end
                return #InsertItems
            end 
            local function MatchProdunct(type_)
                local Win,Time = 0,0
                for i,v in pairs(OrderData["match_history"]) do
                    if tostring(v["win"]) == "true" then
                        Win = Win + 1
                        if v["time"] then
                            Time = v["time"] + Time
                        end
                    end
                   
                end

                return type_ == "win" and Win or Time
            end
            print(Product["condition"]["type"],tonumber(OrderData["progress_value"]),tonumber(OrderData["target_value"]))
            if Product["condition"]["type"] == "Gems" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                    if _G.Leave_Party then _G.Leave_Party() end
                    Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "Coins" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                   if _G.Leave_Party then _G.Leave_Party() end
                   Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "character" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                   if _G.Leave_Party then _G.Leave_Party() end
                    Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "items" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                    if _G.Leave_Party then _G.Leave_Party() end
                    Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "hour" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                   if _G.Leave_Party then _G.Leave_Party() end
                   Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "round" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                    if _G.Leave_Party then _G.Leave_Party() end
                     Post(PathWay .. "finished", CreateBody())
                end
            end
        end
            -- Post(PathWay .. "finished", {
            --     ["order_id"] = P_Key,
            -- })
        -- finished 
        if game.PlaceId == 16146832113 then
        else
            ConnectToEnd = Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                Auto_Config()
                ConnectToEnd:Disconnect()
            end)
        end
    end
end

Auto_Config()

-- All Modules
local StagesData = LoadModule(game:GetService("ReplicatedStorage").Modules.Data.StagesData)


-- All Functions
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
if game.PlaceId == 16146832113 then
    game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(value)
        Inventory = value
    end)
    game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
end
task.spawn(function()
    task.wait(10)
    if game.PlaceId == 16146832113 then
        if Settings["Party Mode"] then
            return false
        end 
        local ChallengesData = require(game:GetService('ReplicatedStorage').Modules.Data.Challenges.ChallengesData)
        local TraitChallenge = {}
        game:GetService('ReplicatedStorage').Networking.ClientReplicationEvent.OnClientEvent:Connect(function(type_,value_)
            if type_ == "ChallengeData" and #TraitChallenge == 0 then 
                for i,v in pairs(value_) do
                    if ChallengesData.GetChallengeRewards(i)['Currencies'] and ChallengesData.GetChallengeRewards(i)['Currencies']['TraitRerolls'] then
                        table.insert(TraitChallenge,i)
                    end
                end 
            end 
        end)
        task.wait(1)
        game:GetService('ReplicatedStorage').Networking.ClientReplicationEvent:FireServer('ChallengeData')
        task.wait(1)
        if Settings["Party Mode"] then
          
        else
            warn("Hello 2")
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
            print(Settings["Auto Join Challenge"])
            if Settings["Auto Join Challenge"] then
                for i,v in pairs(TraitChallenge) do
                    print(i,v)
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("ChallengesEvent"):FireServer("StartChallenge",v)
                    task.wait(5)
                end
            end
            if Settings["Auto Join Rift"] and workspace:GetAttribute("IsRiftOpen") then
                while true do
                    local Rift = require(game:GetService("StarterPlayer").Modules.Gameplay.Rifts.RiftsDataHandler)
                    local GUID = nil
                    for i,v in pairs(Rift.GetRifts()) do
                        if Len(v["Players"]) and not v["Teleporting"] then
                            GUID = v["GUID"]
                        end
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                        "Join",
                        GUID
                    )
                    task.wait(2)
                end
            end
            if Settings["Auto Join Bounty"] then
                local PlayerBountyDataHandler = require(game:GetService('StarterPlayer').Modules.Gameplay.Bounty.PlayerBountyDataHandler)
                local BountyData = require(game:GetService('ReplicatedStorage').Modules.Data.BountyData)
                local Created = BountyData.GetBountyFromSeed(PlayerBountyDataHandler.GetData()["BountySeed"])

                local args = {
                    "AddMatch",
                    {
                        Difficulty = "Nightmare",
                        Act = Created["Act"],
                        StageType = Created["StageType"],
                        Stage = Created["Stage"],
                        FriendsOnly = true
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                task.wait(2)
                local args = {
                    [1] = "StartMatch"
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                task.wait(10)
            end
            if Settings["Select Mode"] == "World Line" then
                while true do
                    game:GetService("ReplicatedStorage").Networking.WorldlinesEvent:FireServer("Teleport","Traits")
                    task.wait(10)
                end
            elseif Settings["Select Mode"] == "Boss Event" then
                local Settings_ = Settings["Boss Event Settings"]
                while true do
                    local args = {
                        "Start",
                        {
                            Settings_["Stage"],
                            Settings_["Difficulty"]
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("BossEvent"):WaitForChild("BossEvent"):FireServer(unpack(args))
                    task.wait(15)
                end
                
            elseif Settings["Select Mode"] == "Portal" then
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
                        if  Ignore(v["ExtraData"]["Modifiers"],Settings_["Ignore Modify"]) and Settings_["Tier Cap"] >= v["ExtraData"]["Tier"] then
                            AllPortal[#AllPortal + 1] = {
                                [1] = i,
                                [2] = v["ExtraData"]["Tier"]
                            }
                            
                        end
                    end
                    table.sort(AllPortal, function(a, b)
                        return a[2] > b[2]
                    end)
                    return AllPortal[1] and AllPortal[1][1] or false
                end
                while true do
                    local Portal = PortalSettings(GetItem(Settings_["ID"]))
                    print(Portal)
                    if Portal then
                        local args = {
                            [1] = "ActivatePortal",
                            [2] = Portal
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(unpack(args))
                        task.wait(10)
                    end
                end
            elseif Settings["Select Mode"] == "Story" then
                while true do
                    local StorySettings = Settings["Story Settings"]
                    StorySettings["Stage"] = DisplayToIndexStory(StorySettings["Stage"])
                    local args = {
                        [1] = "AddMatch",
                        [2] = StorySettings
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(2)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(10)
                end
            elseif Settings["Select Mode"] == "Dungeon" then
                while true do
                    local DungeonSettings = Settings["Dungeon Settings"]
                    DungeonSettings["Stage"] = DisplayToIndexDungeon(DungeonSettings["Stage"])
                    local args = {
                        [1] = "AddMatch",
                        [2] = DungeonSettings
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(2)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(10)
                end
            elseif Settings["Select Mode"] == "Legend Stage" then
                while true do
                    local LegendSettings = Settings["Legend Settings"]
                    LegendSettings["Stage"] = DisplayToIndexLegend(LegendSettings["Stage"])
                    local args = {
                        [1] = "AddMatch",
                        [2] = LegendSettings
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(2)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(10)
                end
            elseif Settings["Select Mode"] == "Raid" then
                while true do
                    local RaidSettings = Settings["Raid Settings"]
                    RaidSettings["Stage"] = DisplayToIndexRaid(RaidSettings["Stage"])
                    local args = {
                        [1] = "AddMatch",
                        [2] = RaidSettings
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(2)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    task.wait(10)
                end
            end
        end
    else
        task.spawn(function()
            while task.wait() do
                if not Settings["Auto Join Rift"] then return end
                local currentTime = os.date("!*t", os.time() ) 
                local hour = currentTime.hour
                local minute = currentTime.min
                local Tables = {0,3,6,9,12,15,18,21,24}
                if table.find(Tables, hour) and minute < 11 then
                    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
                    local GameData = GameHandler.GameData

                    if GameData.StageType ~= "Rift" and GameData.StageType ~= "Rifts" then
                        game:GetService("ReplicatedStorage").Networking.TeleportEvent:FireServer("Lobby")
                    end
                end
                task.wait(30)
            end
        end) 
        if Settings["Auto Priority"] then
            local function Priority(Model,ChangePriority)
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("UnitEvent"):FireServer(unpack({
                    "ChangePriority",
                    Model.Name,
                    ChangePriority
                }))
            end
            for i,v in pairs(workspace.Units:GetChildren()) do
                if v:IsA("Model") then
                    Priority(v,Settings["Priority"])
                end
            end
            workspace.Units.ChildAdded:Connect(function(v)
                v:WaitForChild("HumanoidRootPart")
                task.wait(1)
                Priority(v,Settings["Priority"])
            end)
        end
        if Settings["Auto Stun"] then
            repeat wait() until game:IsLoaded()
            local plr = game:GetService("Players").LocalPlayer
            local Characters = workspace:WaitForChild("Characters")

            local function ConnectToPrompt(c)
                if not c:GetAttribute("connect_1") and c.Name ~= plr.Name then
                    c.ChildAdded:Connect(function(v)
                        if v.Name == "CidStunPrompt" then
                            plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                            task.wait(.5)
                            fireproximityprompt(v)
                            print(c.Name)
                        end
                    end)
                    c:SetAttribute("connect_1",true)
                end
            end

            for i,v in pairs(Characters:GetChildren()) do
                ConnectToPrompt(v)
            end
            Characters.ChildAdded:Connect(function(v)
                ConnectToPrompt(v)
            end)
            print("Executed")
        end
        
    end    
end)