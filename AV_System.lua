repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
task.spawn(function()
setfpscap(10)
local function AntiAFK()
    local StarterPlayer = game:GetService('StarterPlayer')
    local Modules = StarterPlayer:WaitForChild('Modules')
    if game.PlaceId == 16146832113 then
        local Miscellaneous = Modules:WaitForChild('Miscellaneous')
        local AFKChamberClient = Miscellaneous:WaitForChild('AFKChamberClient')
        local Func = require(AFKChamberClient)['_Init']
        task.spawn(function()
            while true do
                setupvalue(Func, 2, 99999999999999999)
                task.wait()
            end
        end)
        print('Anti Time Chamber')
    end
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
    task.spawn(function()
        while true do
            Press('Space')
            task.wait(1000)
        end
    end)
end

local function AutoCloseUpdateLog()
    -- Only run in main lobby, not in stages (to allow replay)
    if game.PlaceId ~= 16146832113 then
        return
    end
    
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local function destroyUpdateLog()
        pcall(function()
            local Main = PlayerGui:FindFirstChild("Main")
            if Main then
                for _, child in pairs(Main:GetDescendants()) do
                    if child.Name == "UpdateLog" or child.Name == "UpdateLogFrame" then
                        child.Visible = false
                        child:Destroy()
                    end
                end
            end
            local UpdateLogGui = PlayerGui:FindFirstChild("UpdateLog")
            if UpdateLogGui then
                UpdateLogGui.Enabled = false
                UpdateLogGui:Destroy()
            end
        end)
    end
    
    task.delay(0.5, destroyUpdateLog)
    task.delay(1, destroyUpdateLog)
    task.delay(2, destroyUpdateLog)
    
    PlayerGui.DescendantAdded:Connect(function(descendant)
        if string.find(descendant.Name:lower(), "update") then
            task.wait(0.1)
            destroyUpdateLog()
        end
    end)
end

task.spawn(AutoCloseUpdateLog)

function _G.CHALLENGE_CHECKCD()
    
    local PATH_CDTIME = game.Players.LocalPlayer.Name .. '_CDTIME'
    if game.PlaceId == 16146832113 then
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local StarterPlayer = game:GetService('StarterPlayer')
        local Modules_R = ReplicatedStorage:WaitForChild("Modules")
        local Modules_S = StarterPlayer:WaitForChild("Modules")

        local ChallengesData = require(Modules_R:WaitForChild("Data"):WaitForChild("Challenges"):WaitForChild("ChallengesData"))
        local ChallengesAttemptsHandler = require(Modules_S:WaitForChild("Gameplay"):WaitForChild("Challenges"):WaitForChild("ChallengesAttemptsHandler"))
        
        local function Checkings()
            print("Load")
            local IsBreak = false
            local Closest = math.huge
            task.wait(.2)
            for i, v in pairs(ChallengesData.GetChallengeTypes()) do
                for i1, v1 in pairs(ChallengesData.GetChallengesOfType(v)) do
                    local Type = v1.Type
                    local Name = v1.Name
                    local Seed = ChallengesAttemptsHandler.GetChallengeSeed(Type)
                    print(Type,Seed)
                    
                    if not Type or not Seed or not Name then
                        IsBreak = true
                        task.wait(1)
                        Checkings()
                        return false
                    end
                    if ChallengesData.GetChallengeRewards(Name)['Currencies'] and ChallengesData.GetChallengeRewards(Name)['Currencies']['TraitRerolls'] then
                    else
                        continue;
                    end
                    ChallengesData.GetChallengeSeed(Name)
                    local Reset = ChallengesData.GetNextReset(Type, Seed) or 0
                    print(Reset)
                    if Reset < Closest then
                        Closest = Reset
                    end
                end
                if IsBreak then
                    return false
                end
            end
            if not IsBreak then
               writefile(PATH_CDTIME, tostring(Closest + os.time() + 20))
            end
        end
        Checkings()
    else
        local Time_ = isfile(PATH_CDTIME) and tonumber(readfile(PATH_CDTIME)) or 0
        if os.time() > Time_ then
            return true
        end
    end
    return false
end
function _G.BOSS_BOUNTY()
    local index = game.PlaceId == 16146832113 and "Bounty" or "Bounties"
    local bounty = require(game:GetService('StarterPlayer').Modules.Gameplay[index].PlayerBountyDataHandler)

    if bounty.GetData()["BountiesLeft"] > 0 then
        return true
    end
    return false
end
function _G.GET_BOSSRUSH()
    local bossrush = require(game:GetService("ReplicatedStorage").Modules.Shared.BossRushDataHandler)
    return bossrush.GetCurrentBossEvent()
end
task.spawn(AntiAFK)
task.spawn(_G.CHALLENGE_CHECKCD)
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end

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

local plr = game.Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local Inventory = {}

local Settings ={
    ["Select Mode"] = "Portal", -- Portal , Dungeon , Story , Legend Stage , Raid , Challenge , Boss Event , World Line , Bounty , AFK , Summer , Odyssey , Fall Regular , Fall Infinite , Guitar King
    ["Auto Next"] = false,
    ["Auto Retry"] = false,
    ["Auto Back Lobby"] = false,
    ["Auto Join AFK"] = false,
    ["Auto Join Rift"] = false,
    ["Auto Join Bounty"] = false,
    ["Auto Join Boss Event"] = false,
    ["Auto Join Challenge"] = false,
    ["Auto Join World Destroyer"] = false,

    ["Auto Stun"] = false,
    ["Auto Priority"] = false,
    ["Priority"] = "First", 
    ["Party Mode"] = false,

    ["Auto Modifier"] = false,
    ["Restart Modifier"] = false,
    ["Select Modifier"] = {"Sphere Finder", "Champions", "Money Surge"},
    ["Modifier Priority"] = {
        ["Money Surge"] = 100,
        ["Harvest"] = 99,
        ["Uncommon Loot"] = 98,
        ["Common Loot"] = 97,
        ["Damage"] = 96,
        ["Range"] = 95,
        ["Press It"] = 94,
        ["Cooldown"] = 93,
        ["Slayer"] = 92,
        ["Immunity"] = 91,
        ["Champions"] = 90,
        ["Revitalize"] = 89,
        ["Sphere Finder"] = 87,
        ["Tyrant Destroyer"] = 86,
        ["Tyrant Arrives"] = 86,
        ["Wild Card"] = 33,
        ["Evolution"] = 32,
        ["Unit Draw"] = 31,
        ["Nighttime"] = 30,
        ["Exploding"] = 4,
        ["Planning Ahead"] = 1,
        ["High Class"] = 1,
        ["Lifeline"] = 1,
        ["Exterminator"] = 1,
        ["Shielded"] = 1,
        ["Strong"] = 1,
        ["Thrice"] = 1,
        ["Warding off Evil"] = 1,
        ["Quake"] = 1,
        ["Fast"] = 1,
        ["Dodge"] = 1,
        ["Fisticuffs"] = 1,
        ["Precise Attack"] = 1,
        ["No Trait No Problem"] = 1,
        ["Drowsy"] = 1,
        ["King's Burden"] = 1,
        ["Regen"] = 1,
    },
    ["Priority Multi"] = {
        ["Enabled"] = false,
        ["1"] = "First",
        ["2"] = "First",
        ["3"] = "First",
        ["4"] = "First",
        ["5"] = "First",
        ["6"] = "First",
    },
    ["Odyssey Settings"] = {
        ["Limiteless"] = false
    },
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
    ["e206ec24-dfbf-4157-a380-9afabe115c29"] = function()
        Settings["Select Mode"] = "Portal"
        Settings["Portal Settings"] = {
        ["ID"] = 280, -- 113 Love , 87 Winter , 190 Spring , 280 Fall Portal
        ["Tier Cap"] = 10,
        ["Method"] = "Highest", -- Highest , Lowest
        ["Ignore Stage"] = {},
        ["Ignore Modify"] = {},
    }
    end,
    ["c62223a2-17f9-4078-bbc0-bb45c484558f"] = function()
        Settings["Select Mode"] = "Portal"
        Settings["Portal Settings"] = {
        ["ID"] = 280, -- 113 Love , 87 Winter , 190 Spring , 280 Fall Portal
        ["Tier Cap"] = 10,
        ["Method"] = "Highest", -- Highest , Lowest
        ["Ignore Stage"] = {},
        ["Ignore Modify"] = {},
    }
    end,
    ["d92fceaa-8d18-4dc9-980f-452db4573ad9"] = function()
        Settings["Select Mode"] = "Portal"
        Settings["Portal Settings"] = {
        ["ID"] = 280, -- 113 Love , 87 Winter , 190 Spring , 280 Fall Portal
        ["Tier Cap"] = 10,
        ["Method"] = "Highest", -- Highest , Lowest
        ["Ignore Stage"] = {},
        ["Ignore Modify"] = {},
    }
    end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Portal"
    --     Settings["Portal Settings"] = {
    --     ["ID"] = 280, -- 113 Love , 87 Winter , 190 Spring , 280 Fall Portal
    --     ["Tier Cap"] = 10,
    --     ["Method"] = "Highest", -- Highest , Lowest
    --     ["Ignore Stage"] = {},
    --     ["Ignore Modify"] = {},
    -- }
    -- end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Fall Regular"
    -- end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Fall Regular"
    -- end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Fall Regular"
    -- end,
    ["fc7a340c-7c98-4da6-84aa-a7e3ce4790c1"] = function()
        Settings["Select Mode"] = "Fall Infinite"
        Settings["Auto Retry"] = true
    end,
    ["d551991a-b8ec-4fe5-96f5-2fe6418a3e9a"] = function()
        Settings["Select Mode"] = "Fall Infinite"
        Settings["Auto Retry"] = true
    end,
    ["ffa517b2-7f99-47a8-aadc-d7662b96eb60"] = function()
        Settings["Select Mode"] = "Fall Infinite"
        Settings["Auto Retry"] = true
    end,
    ["c869c464-6864-4eb7-a98f-f78f3448b71c"] = function()
        Settings["Select Mode"] = "Fall Infinite"
        Settings["Auto Retry"] = true
    end,
    ["d88ae3d8-3e47-4de0-b18c-ee598fb2bb83"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
            ["Difficulty"] = "Nightmare",
            ["Act"] = "Act5",
            ["StageType"] = "Dungeon",
            ["Stage"] = "Anniversary Dungeon",
            ["FriendsOnly"] = false
        }
    end,
    ["c3795c09-07c3-4b30-ba13-067deb00b9dc"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["659d38ba-bfed-4d48-93b0-b015e19fad58"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["e99f1149-1c90-4997-a99c-87e9dd812fe9"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["ce0355ef-7f25-42b7-8f4a-14a47c257ff8"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["42b71690-3363-46bd-b933-046241c9a2cc"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["bc3274e0-17fd-4cc3-b4e2-55323a734993"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["983626d0-e545-4bb2-9623-fad3c4899f81"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["a0805ded-393d-46c5-9d9f-aa532e6f726b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act9",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["636ecf68-cfb2-400b-93c0-3e217d011e8a"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act9",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["b74918bc-c060-4b9f-8caa-1323bbccdf4b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act9",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["b6e76418-6470-434e-badc-cb5ce7b18edb"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act9",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["45e506d7-344e-4166-8d3f-4520ecee34be"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["f7dd88f0-da60-451b-b428-2f195157ba8a"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["10805d4e-6a8c-47d7-aa8a-3a58e4ffbc31"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["3d06a519-5378-4045-8a51-bd814c9efd7a"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["a0c76c61-a989-4853-bf2f-c690ca0a24c3"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["ab455b4f-e2a7-4b18-bb7c-447ea0211401"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Retry"] = true
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act7",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Anniversary Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    ["c11bff94-13e6-45ec-a0ca-d1b19b2964ee"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
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
        Settings["Auto Retry"] = true
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
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["29fe5885-c673-46cf-9ba4-a7f42c2ba0b0"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["efdc7d4b-1346-49d3-8823-4865ac02b6ae"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["36846b45-8b1c-46a8-9edc-7e5ae2a32d05"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
    end,
    ["8fedc8ce-3263-4821-b3d0-e4162a532588"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
    end,
    ["87b27182-43d5-4266-9705-86ffa192adb0"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
    end,
    ["fed48f27-35a3-47a7-b937-5a4dc59c6d28"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Story",
        ["Stage"] = "Edge of Heaven",
        ["FriendsOnly"] = false
    }
    end,
    ["785409b0-02f9-4bb8-8ad8-b383b59f6f54"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
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
        Settings["Auto Retry"] = true
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
        Settings["Auto Retry"] = true
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
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Shibuya Station",
        ["FriendsOnly"] = false
    }
    end,
    ["68cd687d-0760-4550-a7d6-482f3c2ca9df"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Shibuya Station",
        ["FriendsOnly"] = false
    }
    end,
    ["427f560e-b78e-4ec9-b711-d451b0312306"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "Ruined City",
        ["FriendsOnly"] = false
    }
    end,
    ["d8b5cc8c-effd-4521-9db9-04fb460cd225"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
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
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "Ruined City",
        ["FriendsOnly"] = false
    }
    end,
    ["a88f58e7-c086-4f90-95a2-898b2d2e813a"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act2",
        ["StageType"] = "Raid",
        ["Stage"] = "Ruined City",
        ["FriendsOnly"] = false
    }
    end,
    ["dfa9b68a-95d7-4227-b118-702cf45061c7"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "HAPPY Factory",
        ["FriendsOnly"] = false
    }
    end,
    ["98744617-780b-4c3f-adea-12f450e0b33c"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "HAPPY Factory",
        ["FriendsOnly"] = false
    }
    end,
    ["415f5afe-810d-4a42-aed9-5c29995f2e31"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "HAPPY Factory",
        ["FriendsOnly"] = false
    }
    end,
    ["dbda7a23-f9ac-487f-9a8d-beeebfba0475"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "HAPPY Factory",
        ["FriendsOnly"] = false
    }
    end,
    ["16cb01f5-7b68-47ed-b116-c63d5f453e1a"] = function()
        Settings["Auto Stun"] = true
        Settings["Select Mode"] = "Raid"
        Settings["Auto Retry"] = true
        Settings["Priority Multi"] = {
            ["Enabled"] = true,
            ["1"] = "Bosses",
            ["2"] = "First",
            ["3"] = "Bosses",
            ["4"] = "Closest",
            ["5"] = "First",
            ["6"] = "First",
        }
        Settings["Raid Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Raid",
        ["Stage"] = "HAPPY Factory",
        ["FriendsOnly"] = false
    }
    end,
    ["e4ed794a-8569-4da6-976d-829ac43f423f"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Money Surge"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "AntIsland",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Ant Island",
        ["FriendsOnly"] = false
    }
    end,
    ["cfbb32d7-64cb-4135-b1e3-1992e1800d07"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Money Surge"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "AntIsland",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Ant Island",
        ["FriendsOnly"] = false
    }
    end,
    ["e1a0c37a-c004-4ff3-a064-2b7d55703c3e"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Money Surge"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "AntIsland",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Ant Island",
        ["FriendsOnly"] = false
    }
    end,
    ["b752455d-18d7-4bb3-bd67-70269790500f"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Money Surge"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "AntIsland",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Ant Island",
        ["FriendsOnly"] = false
    }
    end,
    ["2e2a5d02-4d63-43a5-8b9a-6e7902581cfd"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Sphere Finder"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["960de970-ba26-4184-8d97-561ae8511e4b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Sphere Finder"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["24cbfd35-8df6-4fc7-8c0f-5e9c4b921013"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Sphere Finder"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["0495121f-a579-4068-9494-4a1ac477613b"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Sphere Finder"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["fb02fc4d-29d3-4158-b6f1-6a7d8fa3a2f5"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Tyrant Arrives"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["4c3e1a8b-02fd-42e7-9905-e44a073e3bbc"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Tyrant Arrives"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["3f91fbcb-c0de-4251-8a27-df651f9933aa"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Tyrant Arrives"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["f96ab092-314a-484b-a098-59209edccb0a"] = function()
        Settings["Select Mode"] = "Dungeon"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Tyrant Arrives"}
        Settings["Auto Retry"] = true
        Settings["Modifier Priority"] = {
            ["Money Surge"] = 100,
            ["Harvest"] = 99,
            ["Uncommon Loot"] = 98,
            ["Common Loot"] = 97,
            ["Damage"] = 96,
            ["Range"] = 95,
            ["Press It"] = 94,
            ["Cooldown"] = 93,
            ["Slayer"] = 92,
            ["Immunity"] = 91,
            ["Champions"] = 90,
            ["Revitalize"] = 89,
            ["Sphere Finder"] = 87,
            ["Tyrant Destroyer"] = 86,
            ["Tyrant Arrives"] = 86,
            ["Wild Card"] = 33,
            ["Evolution"] = 32,
            ["Unit Draw"] = 31,
            ["Nighttime"] = 30,
            ["Exploding"] = 4,
            ["Planning Ahead"] = 0,
            ["High Class"] = 0,
            ["Lifeline"] = 0,
            ["Exterminator"] = 0,
            ["Shielded"] = 0,
            ["Strong"] = 0,
            ["Thrice"] = 0,
            ["Warding off Evil"] = 0,
            ["Quake"] = 0,
            ["Fast"] = 0,
            ["Dodge"] = 0,
            ["Fisticuffs"] = 0,
            ["Precise Attack"] = 0,
            ["No Trait No Problem"] = 0,
            ["Drowsy"] = 0,
            ["King's Burden"] = 0,
            ["Regen"] = 0,
        }
        Settings["Dungeon Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "FrozenVolcano",
        ["StageType"] = "Dungeon",
        ["Stage"] = "Frozen Volcano",
        ["FriendsOnly"] = false
    }
    end,
    ["4de82cf7-17ae-43ba-bf30-3a2048917a8f"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Legend Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act1",
        ["StageType"] = "LegendStage",
        ["Stage"] = "Double Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Legend Stage"
    --     Settings["Legend Settings"] = {
    --     ["Difficulty"] = "Nightmare",
    --     ["Act"] = "Act3",
    --     ["StageType"] = "LegendStage",
    --     ["Stage"] = "Double Dungeon",
    --     ["FriendsOnly"] = false
    -- }
    -- end,
    ["c040bd90-d939-4f0c-b65d-1e0ace06a434"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Legend Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act3",
        ["StageType"] = "LegendStage",
        ["Stage"] = "Double Dungeon",
        ["FriendsOnly"] = false
    }
    end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Legend Stage"
    --     Settings["Legend Settings"] = {
    --     ["Difficulty"] = "Nightmare",
    --     ["Act"] = "Act3",
    --     ["StageType"] = "LegendStage",
    --     ["Stage"] = "Kuinshi Palace",
    --     ["FriendsOnly"] = false
    -- }
    -- end,
    ["e7403190-850c-49e5-b2b0-b4949e477c47"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Legend Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act3",
        ["StageType"] = "LegendStage",
        ["Stage"] = "Kuinshi Palace",
        ["FriendsOnly"] = false
    }
    end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Legend Stage"
    --     Settings["Legend Settings"] = {
    --     ["Difficulty"] = "Nightmare",
    --     ["Act"] = "Act3",
    --     ["StageType"] = "LegendStage",
    --     ["Stage"] = "Land of the Gods",
    --     ["FriendsOnly"] = false
    -- }
    -- end,
    ["12b453cd-7435-425e-977e-1ae97f04cc23"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Legend Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act3",
        ["StageType"] = "LegendStage",
        ["Stage"] = "Land of the Gods",
        ["FriendsOnly"] = false
    }
    end,
    ["6eef0b60-b61d-47d1-aba5-22d6fea4cb8f"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Legend Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Act3",
        ["StageType"] = "LegendStage",
        ["Stage"] = "Crystal Chapel",
        ["FriendsOnly"] = false
    }
    end,
    ["89901139-d4b5-4555-8913-4900d176546c"] = function()
        Settings["Select Mode"] = "Legend Stage"
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
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
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["bc0fca7b-dde2-47a6-a50b-793d8782999b"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["edbd1859-f374-4735-87c7-2b0487808665"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["c480797f-3035-4b1f-99a3-d77181f338bf"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["39ce32e2-c34c-4479-8a52-5715e8645944"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["63c63616-134c-4450-a5d6-a73c7d44d537"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["5852f3ef-a949-4df5-931b-66ac0ac84625"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["d85e3e85-0893-4972-a145-d6ba42bac512"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["03237ef-99e7-4a53-b61a-1ac9ca8dee60"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["503237ef-99e7-4a53-b61a-1ac9ca8dee60"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["2a77cde0-0bab-4880-a01e-8bbe4b76956e"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
        Settings["Auto Retry"] = true
        Settings["Auto Next"] = true
    end,
    ["df999032-bd9e-4933-bba1-a037997ce505"] = function()
       Settings["Auto Join Challenge"] = true
       Settings["Auto Join Bounty"] = true
       Settings["Auto Modifier"] = true
       Settings["Restart Modifier"] = true
       Settings["Select Modifier"] = {"Exploding"}
       Settings["Auto Retry"] = true
       Settings["Auto Next"] = true
    end,
    ["143f6820-6e5e-4f6e-b3f9-3de3e9586271"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Auto Retry"] = true
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["abb151e9-5e2a-40d3-91fe-7da3ee03f1aa"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Auto Retry"] = true
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["5a815e6f-7024-4e6e-9d30-50cda9a765bd"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Auto Retry"] = true
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["66ace527-415a-4b1f-a512-9f3429f67067"] = function()
        Settings["Select Mode"] = "Boss Event"
        Settings["Auto Retry"] = true
        Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,

    ["a551241f-b981-4b84-8b61-ce5ac449b9f0"] = function()
        Settings["Auto Join Rift"] = true
        Settings["Auto Back Lobby"] = true
    end,
    ["7d2c7a5f-81c8-4bc2-9ceb-2015ac73f103"] = function()
        Settings["Auto Join Rift"] = true
        Settings["Auto Back Lobby"] = true
    end,
    ["878aba1c-4163-43a6-9f6d-ef8827f6b582"] = function()
        Settings["Auto Join Rift"] = true
        Settings["Auto Back Lobby"] = true
    end,
    ["73bcfb57-5d0f-499b-bd6c-3e601ef9917c"] = function()
        Settings["Auto Join Rift"] = true
        Settings["Auto Back Lobby"] = true
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
        Settings["Auto Next"] = true
        Settings["Auto Retry"] = true
    end,
    ["562e53d5-22c8-4337-a5bc-c36df924524b"] = function()
        Settings["Select Mode"] = "World Line"
        Settings["Auto Next"] = true
        Settings["Auto Retry"] = true
    end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Odyssey"
    --     Settings["Odyssey Settings"] = {
    --     ["Limiteless"] = false
    -- }
    -- end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Odyssey"
    --     Settings["Odyssey Settings"] = {
    --     ["Limiteless"] = false
    -- }
    -- end,
    -- [""] = function()
    --     Settings["Select Mode"] = "Odyssey"
    --     Settings["Odyssey Settings"] = {
    --     ["Limiteless"] = false
    -- }
    -- end,
    ["0a0f6982-c75c-4a9b-bbae-1da2a3f99666"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["e7afcb6e-2418-4dfe-8eda-8339bd920012"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
        ["Difficulty"] = "Normal",
        ["Act"] = "Act1",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["d9faa15c-d5c6-4b52-a918-8e1ad1940841"] = function()
        Settings["Select Mode"] = "Guitar King"
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
    print("Host")
    return false
end
local Auto_Configs = true
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Utilities = Modules:WaitForChild("Utilities")
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitsData = require(Modules.Data.Entities.Units)
local ItemsData = require(Modules.Data.ItemsData)
local TableUtils = require(Utilities.TableUtils)
local InventoryEvent = game:GetService("StarterPlayer"):FindFirstChild("OwnedItemsHandler",true) or game:GetService("ReplicatedStorage").Networking:WaitForChild("InventoryEvent",2)

local function GetTemporalRiftItem()
    local items = {}
    local success, err = pcall(function()
        if InventoryEvent and InventoryEvent.Name == "OwnedItemsHandler" then
            local OwnedItemsHandler = require(InventoryEvent)
            if OwnedItemsHandler and OwnedItemsHandler.GetOwnedItems then
                local ownedItems = OwnedItemsHandler.GetOwnedItems()
                if ownedItems then
                    for itemGUID, itemData in pairs(ownedItems) do
                        if itemData and itemData["Name"] == "Temporal Rift" then
                            table.insert(items, {
                                GUID = itemGUID,
                                Name = itemData["Name"],
                                Amount = itemData["Amount"] or 1
                            })
                        end
                    end
                end
            end
        end
    end)
    if not success then
        warn("[GetTemporalRiftItem] Error:", err)
    end
    return items
end

local function HasTemporalRiftItem()
    local items = GetTemporalRiftItem()
    if #items > 0 then
        local totalAmount = 0
        for _, item in ipairs(items) do
            totalAmount = totalAmount + (item.Amount or 1)
        end
        return true, totalAmount, items[1].GUID
    end
    return false, 0, nil
end

local function UseTemporalRiftItem(stage)
    stage = stage or "Warlord"
    local items = GetTemporalRiftItem()
    if #items == 0 then
        warn("[UseTemporalRiftItem] No Temporal Rift item found")
        return false
    end
    
    local itemGUID = items[1].GUID
    print("[UseTemporalRiftItem] Using item GUID:", itemGUID, "Stage:", stage)
    
    local success, err = pcall(function()
        local ItemUseEvent = game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Items"):WaitForChild("ItemUseEvent")
        ItemUseEvent:FireServer(itemGUID)
        task.wait(0.5)
        
        local TemporalRiftEvent = game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("TemporalRiftEvent")
        TemporalRiftEvent:FireServer("Activate", {
            StageType = "Rift",
            Stage = stage
        })
    end)
    
    if not success then
        warn("[UseTemporalRiftItem] Error:", err)
        return false
    end
    
    return true
end

local function GetData()
    local SkinTable = {}
    local FamiliarTable = {}
    local Inventory = {}
    local EquippedUnits = {}
    local Units = {}
    local Battlepass = 0

 
    local FamiliarsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedFamiliarsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("FamiliarsDataHandler",true)
    local SkinsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedSkinsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("SkinDataHandler",true)
    local UnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true)
    local EquippedUnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true) 
    local BattlepassHandler = game:GetService("StarterPlayer"):FindFirstChild("BattlepassHandler",true) and require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler):GetPlayerData() or function() return 0 end

    

    local ReqFamiliarsHandler = require(FamiliarsHandler)
    local ReqSkins = require(SkinsHandler)

    local ItemHandler = nil
    local FamiliarHandler = nil
    local SkinHandler = nil
    local UnitHandler = nil
    local EquippedUnitsHandler = nil

    print(InventoryEvent.Name)
    if InventoryEvent.Name == "OwnedItemsHandler" then
        ItemHandler = function()
            local Inventory_ = {}
            for i,v in pairs(require(InventoryEvent).GetItems()) do
                if v then 
                    local call,err = pcall(function()
                        Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory_[i]["ID"] = v["ID"]
                        Inventory_[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            return Inventory_
        end
    elseif InventoryEvent.Name == "InventoryEvent" then
        local Inventory_ = {}
        InventoryEvent.OnClientEvent:Connect(function(a,b)
            if a == "UpdateAll" then
                for i,v in pairs(b) do
                    if v then 
                        local call,err = pcall(function()
                            Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                            Inventory_[i]["ID"] = v["ID"]
                            Inventory_[i]["AMOUNT"] = v["Amount"]
                        end) 
                    end
                end
            end
        end)
        task.wait(1.5)
        InventoryEvent:FireServer("OwnedItems")
        ItemHandler = function()
            return Inventory_
        end
    end
    if FamiliarsHandler.Name == "OwnedFamiliarsHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetOwnedFamiliars
    elseif FamiliarsHandler.Name == "FamiliarsDataHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetFamiliarsData
    end
    if SkinsHandler.Name == "OwnedSkinsHandler" then
        SkinHandler = ReqSkins.GetOwnedSkins
    elseif SkinsHandler.Name == "SkinDataHandler" then
        SkinHandler = ReqSkins.GetPlayerSkins
    end
    
    UnitHandler = function()
        local Units_ = {}
        for i, v in pairs(require(UnitsModule).GetUnits()) do
            if not v.UnitData then continue end
            Units_[i] = TableUtils.DeepCopy(v) 
            Units_[i].Name = v.UnitData.Name

            Units_[i].UnitData = nil
        end
        return Units_
    end
    EquippedUnitsHandler = function()
        local EquippedUnits_ = {}
        local units = UnitHandler()
        local Handler = nil
        for i,v in pairs(require(EquippedUnitsModule).GetEquippedUnits()) do
            if v == "None" then continue end
            print(i,v)
            local v1 = units[v]
            EquippedUnits_[v1.UniqueIdentifier] = TableUtils.DeepCopy(v1)

            EquippedUnits_[v1.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v1.Identifier).Name
        end
        return EquippedUnits_
    end


    Battlepass =  BattlepassHandler
    Units = UnitHandler()
    EquippedUnits = EquippedUnitsHandler()
    FamiliarTable = FamiliarHandler()
    Inventory = ItemHandler()
    SkinTable = SkinHandler()

    local PlayerData = plr:GetAttributes()

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
        -- Auto Select Items จาก selected_items (รองรับ Act, Stage, และ items)
        if OrderData["selected_items"] then
            local Insert = {}
            local SelectedAct = nil
            local SelectedStage = nil
            for _, v in pairs(OrderData["selected_items"]) do
                -- เช็คว่ามี act field หรือไม่ (format: {name="Double Dungeon", act="Act 3"})
                if v.act then
                    SelectedAct = v.act
                end
                if v.name then
                    -- ถ้ามี act field แยก = name คือ Stage
                    if v.act then
                        SelectedStage = v.name
                    -- ถ้าไม่มี act field = เช็คว่า name เป็น Act หรือไม่
                    elseif v.name:match("^Act%s*%d+$") or v.name:match("^Act%d+$") or v.name == "Infinite" then
                        SelectedAct = v.name
                    elseif v.type == "stage" or v.type == "Stage" then
                        SelectedStage = v.name
                    else
                        table.insert(Insert, v.name)
                    end
                end
            end
            -- Apply Act และ Stage ไปยัง Settings ที่เกี่ยวข้อง (ใช้ค่าอื่นจาก Changes[product_id])
            if SelectedAct then
                if Settings["Story Settings"] then Settings["Story Settings"]["Act"] = SelectedAct end
                if Settings["Dungeon Settings"] then Settings["Dungeon Settings"]["Act"] = SelectedAct end
                if Settings["Legend Settings"] then Settings["Legend Settings"]["Act"] = SelectedAct end
                if Settings["Raid Settings"] then Settings["Raid Settings"]["Act"] = SelectedAct end
                -- print("[Auto_Config] Selected Act:", SelectedAct)
            end
            if SelectedStage then
                if Settings["Story Settings"] then Settings["Story Settings"]["Stage"] = SelectedStage end
                if Settings["Dungeon Settings"] then Settings["Dungeon Settings"]["Stage"] = SelectedStage end
                if Settings["Legend Settings"] then Settings["Legend Settings"]["Stage"] = SelectedStage end
                if Settings["Raid Settings"] then Settings["Raid Settings"]["Stage"] = SelectedStage end
                -- print("[Auto_Config] Selected Stage:", SelectedStage)
            end
            if #Insert > 0 then
                Settings["Select Items"] = Insert
                print("[Auto_Config] Selected items:", table.concat(Insert, ", "))
            end
        end
        -- Background task เพื่ออัพเดท selected_items อย่างต่อเนื่อง
        task.spawn(function()
            while true do
                pcall(function()
                    local UpdatedOrderData = Fetch_data()
                    if UpdatedOrderData and UpdatedOrderData["selected_items"] then
                        local NewInsert = {}
                        for _, v in pairs(UpdatedOrderData["selected_items"]) do
                            if v.name then
                                table.insert(NewInsert, v.name)
                            end
                        end
                        if #NewInsert > 0 then
                            local hasChanged = false
                            local currentItems = Settings["Select Items"] or {}
                            if #NewInsert ~= #currentItems then
                                hasChanged = true
                            else
                                for i, name in ipairs(NewInsert) do
                                    if currentItems[i] ~= name then
                                        hasChanged = true
                                        break
                                    end
                                end
                            end
                            if hasChanged then
                                Settings["Select Items"] = NewInsert
                                print("[Auto_Config] Updated selected_items:", table.concat(NewInsert, ", "))
                            end
                        end
                    end
                end)
                task.wait(10)
            end
        end)
        if Settings["Select Mode"] == "AFK" then
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("AFKEvent"):FireServer()
            local Product = OrderData["product"]
            task.spawn(function()
                while true do
                    local freshOrderData = Fetch_data()
                    if freshOrderData then
                        if Product["condition"]["type"] == "hour" then
                            if tonumber(freshOrderData["progress_value"]) >= (tonumber(freshOrderData["target_value"])/60/60) then
                                if _G.Leave_Party then _G.Leave_Party() end
                                Post(PathWay .. "finished", CreateBody())
                                print("[Progress] AFK hour completed!")
                                break
                            end
                        end
                    end
                    task.wait(60)
                end
            end)
            return false
        end

        if OrderData["want_carry"] then
            Settings["Party Mode"] = true
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
                print(tonumber(OrderData["progress_value"]) , Goal , tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) , tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60))
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                   if _G.Leave_Party then _G.Leave_Party() end
                   Post(PathWay .. "finished", CreateBody())
                end
            elseif Product["condition"]["type"] == "level" then
                print(tonumber(OrderData["progress_value"]) , Goal)
                if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
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
        -- Background Progress Checker - เช็ค progress อย่างต่อเนื่องเพื่อให้แน่ใจว่าจบงาน
        task.spawn(function()
            while true do
                task.wait(30) -- เช็คทุก 30 วินาที
                local freshOrderData = Fetch_data()
                if freshOrderData and freshOrderData["product"] then
                    local Product = freshOrderData["product"]
                    local conditionType = Product["condition"]["type"]
                    local progressValue = tonumber(freshOrderData["progress_value"]) or 0
                    local targetValue = tonumber(freshOrderData["target_value"]) or 1
                    
                    local isCompleted = false
                    if conditionType == "hour" then
                        isCompleted = progressValue >= (targetValue/60/60)
                    else
                        isCompleted = progressValue >= targetValue
                    end
                    
                    if isCompleted then
                        print("[Progress Checker] Task completed! Type:", conditionType, "Progress:", progressValue, "/", targetValue)
                        if _G.Leave_Party then _G.Leave_Party() end
                        Post(PathWay .. "finished", CreateBody())
                        break
                    end
                end
            end
        end)
        
        if game.PlaceId == 16146832113 then
        else
            ConnectToEnd = Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                Auto_Config()
                ConnectToEnd:Disconnect()
            end)
        end
    end
end
-- for i,v in pairs(GetData()) do
--     print(i,v)
    
-- end
Auto_Config()
if Settings["Party Mode"] then
    print("Member")
    return false
end
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

    task.spawn(function()
        task.wait(10)
        if game.PlaceId == 16146832113 then
            warn("Hello 2")
            local function GetItem(ID)
                local Items = {}
                for i,v in pairs(require(InventoryEvent).GetItems()) do
                    print(v["ID"])
                    if v["ID"] == ID then
                        Items[i] = v
                    end
                end
                return Items
            end
            print(Settings["Auto Join Challenge"])
            if Settings["Auto Join Challenge"] then
                local ReplicatedStorage = game:GetService('ReplicatedStorage')
                local StarterPlayer = game:GetService('StarterPlayer')
                local Modules_R = ReplicatedStorage:WaitForChild("Modules")
                local Modules_S = StarterPlayer:WaitForChild("Modules")

                local ChallengesData = require(Modules_R:WaitForChild("Data"):WaitForChild("Challenges"):WaitForChild("ChallengesData"))
                local ChallengesAttemptsHandler = require(Modules_S:WaitForChild("Gameplay"):WaitForChild("Challenges"):WaitForChild("ChallengesAttemptsHandler"))

                task.spawn(function()
                    while true do
                        for i, v in pairs(ChallengesData.GetChallengeTypes()) do
                            for i1, v1 in pairs(ChallengesData.GetChallengesOfType(v)) do
                                local Type = v1.Type
                                local Name = v1.Name
                                local Seed = ChallengesAttemptsHandler.GetChallengeSeed(Type)
                                if not Type or not Seed or not Name then
                                    continue;
                                end
                                if ChallengesData.GetChallengeRewards(Name)['Currencies'] and ChallengesData.GetChallengeRewards(Name)['Currencies']['TraitRerolls'] then
                                else
                                    continue;
                                end
                                ChallengesData.GetChallengeSeed(Name)
                                local Reset = ChallengesData.GetNextReset(Type, Seed) or 0
                                if Reset == 0 then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("ChallengesEvent"):FireServer("StartChallenge",Name)
                                    task.wait(2.5)
                                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniLobbyInterface") then
                                        local args = {
                                            [1] = "StartMatch"
                                        }
                                        
                                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                                    end
                                end
                            end
                        end
                        task.wait(10)
                    end
                end)
                task.wait(5)
            end
            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniLobbyInterface") then
                task.wait(10)
            end
            print("Out",Settings["Auto Join Rift"])
            if Settings["Auto Join Rift"] then
                task.spawn(function()
                    local hasUsedItem = false
                    local lastItemUseTime = 0
                    
                    while true do
                        if workspace:GetAttribute("IsRiftOpen") then
                            local Rift = require(game:GetService("StarterPlayer").Modules.Gameplay.Rifts.RiftsDataHandler)
                            local GUID = nil
                            
                            if Settings["Party Mode"] and _G.Party_Host then
                                for i,v in pairs(Rift.GetRifts()) do
                                    if v and not v["Teleporting"] and v["Players"] then
                                        for _, playerName in pairs(v["Players"]) do
                                            if playerName == _G.Party_Host then
                                                GUID = v["GUID"]
                                                break
                                            end
                                        end
                                        if GUID then break end
                                    end
                                end
                            else
                                for i,v in pairs(Rift.GetRifts()) do
                                    if v and not v["Teleporting"] then
                                        GUID = v["GUID"]
                                        break
                                    end
                                end
                            end
                            
                            if GUID then
                                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                                    "Join",
                                    GUID
                                )
                                hasUsedItem = false -- รีเซ็ตเมื่อเข้า Rift สำเร็จ
                                task.wait(5)
                            else
                                task.wait(3)
                            end
                        else
                            -- ไม่มี Rift เปิดอยู่ → ใช้ Temporal Rift item เปิดเอง
                            if not hasUsedItem or (os.time() - lastItemUseTime) > 60 then
                                local hasRift, amount = HasTemporalRiftItem()
                                
                                if hasRift then
                                    print("[Auto Join Rift] No rift open - Using Temporal Rift item (", amount, "remaining)")
                                    local success = UseTemporalRiftItem("Warlord")
                                    if success then
                                        print("[Auto Join Rift] Temporal Rift activated")
                                        hasUsedItem = true
                                        lastItemUseTime = os.time()
                                    else
                                        warn("[Auto Join Rift] Failed to use Temporal Rift")
                                    end
                                    task.wait(3)
                                else
                                    -- ไม่มีไอเทม → รอ Rift จากคนอื่น
                                    task.wait(5)
                                end
                            else
                                task.wait(3)
                            end
                        end
                    end
                end)
            end
            if Settings["Auto Join World Destroyer"] then
                task.spawn(function()
                    while true do
                        game:GetService("ReplicatedStorage").Networking.WorldDestroyer.JoinMatch:FireServer("Teleport")

                        task.wait(10)
                    end
                end)
            end
            local LoadBounty = false
            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MiniLobbyInterface") then
                task.wait(10)
            end
            task.spawn(function()
                print("In 1", Settings["Auto Join Bounty"])
                while Settings["Auto Join Bounty"] do task.wait()
                    print("W")
                    local PlayerBountyDataHandler = require(game:GetService('StarterPlayer').Modules.Gameplay.Bounty.PlayerBountyDataHandler)
                    local BountyData = require(game:GetService('ReplicatedStorage').Modules.Data.BountyData)
                    local Created = BountyData.GetBountyFromSeed(PlayerBountyDataHandler.GetData()["BountySeed"])
                    
                    print("C")
                    if PlayerBountyDataHandler.GetData()["BountiesLeft"] > 0 then
                        print("D")
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
                        print("E")
                        task.wait(2)
                        print("F")
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        print("G")
                    end
                    task.wait(5)
                    LoadBounty = true
                end
                print("Out 1", Settings["Auto Join Bounty"])
                LoadBounty = true
            end)
            repeat task.wait()  print("Loop") until LoadBounty
            print("Loop 1")
            task.wait(6)
            print(Settings["Select Mode"])
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
                            _G.GET_BOSSRUSH(),
                            Settings_["Difficulty"]
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("BossEvent"):WaitForChild("BossEvent"):FireServer(unpack(args))
                    task.wait(4)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
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
                        if v["ExtraData"] and Ignore(v["ExtraData"]["Modifiers"] or {},Settings_["Ignore Modify"]) and Settings_["Tier Cap"] >= v["ExtraData"]["Tier"] then
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
                while true do task.wait(.3)
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
            elseif Settings["Select Mode"] == "Summer" then
                game:GetService("ReplicatedStorage").Networking.Summer.SummerLTMEvent:FireServer("Create")
                task.wait(2)
                local args = {
                    [1] = "StartMatch"
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            elseif Settings["Select Mode"] == "Fall Regular" then
                game:GetService("ReplicatedStorage").Networking.Fall.FallLTMEvent:FireServer("Create")
                task.wait(2)
                local args = {
                   [1] = "StartMatch"
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            elseif Settings["Select Mode"] == "Fall Infinite" then
                game:GetService("ReplicatedStorage").Networking.Fall.FallLTMEvent:FireServer("Create","Infinite")
                task.wait(2)
                local args = {
                   [1] = "StartMatch"
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
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
            elseif Settings["Select Mode"] == "Odyssey" then
                local OdysseySettings = Settings["Odyssey Settings"]
                if OdysseySettings["Limiteless"] then
                    game:GetService("ReplicatedStorage").Networking.Odyssey.OdysseyEvent:FireServer("Play","Journey")
                    task.wait(1)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                else
                    game:GetService("ReplicatedStorage").Networking.Odyssey.OdysseyEvent:FireServer("Play","Limitless")
                    task.wait(1)
                    local args = {
                        [1] = "StartMatch"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
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
            elseif Settings["Select Mode"] == "Guitar King" then
                local StarterPlayer = game:GetService("StarterPlayer")
                local PlayerGui = plr:WaitForChild("PlayerGui")
                
                local GuitarMinigameModule = StarterPlayer:WaitForChild("Modules")
                    :WaitForChild("Interface")
                    :WaitForChild("Loader")
                    :WaitForChild("Events")
                    :WaitForChild("JamSessionHandler")
                    :WaitForChild("GuitarMinigame")
                
                local JamSessionHandler = require(StarterPlayer.Modules.Interface.Loader.Events.JamSessionHandler)
                local GuitarMinigame = require(GuitarMinigameModule)
                local ScoreHandler = require(GuitarMinigameModule:WaitForChild("ScoreHandler"))
                
                -- Remote สำหรับส่ง score ไป server
                local JamSessionEvents = game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Events"):WaitForChild("JamSession")
                local UpdateScoreRemote = JamSessionEvents:WaitForChild("UpdateScore")
                
                -- Songs and Difficulties
                local GK_SONGS = {"Skele King's Theme", "Vanguards!", "Selfish Intentions"}
                local GK_DIFFICULTIES = {"Easy", "Medium", "Hard", "Expert"}
                local gkSongIndex = 1
                local gkDiffIndex = 1
                
                -- ===== SCORE TRACKING =====
                local TARGET_SCORE = 100000
                local hasEndedCurrentSong = false
                local hitCount = 0
                
                -- ฟังก์ชันปิด GUI Guitar
                local function closeGuitarUI()
                    pcall(function()
                        if GuitarMinigame.Close then
                            GuitarMinigame.Close()
                        end
                        if JamSessionHandler.CloseGui then
                            JamSessionHandler.CloseGui()
                        end
                        for _, gui in pairs(PlayerGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                if gui.Name == "GuitarMinigame" or string.find(gui.Name:lower(), "guitar") or string.find(gui.Name:lower(), "jam") then
                                    gui:Destroy()
                                    print("[Guitar King] Destroyed GUI:", gui.Name)
                                end
                            end
                        end
                    end)
                end
                
                -- ฟังก์ชันไปเพลงถัดไป
                local function goToNextSong()
                    gkDiffIndex = gkDiffIndex + 1
                    if gkDiffIndex > #GK_DIFFICULTIES then
                        gkDiffIndex = 1
                        gkSongIndex = gkSongIndex + 1
                        if gkSongIndex > #GK_SONGS then
                            gkSongIndex = 1
                            print("[Guitar King] All 12 songs completed! Checking progress...")
                            
                            task.spawn(function()
                                while true do
                                    task.wait(5)
                                    local success, newOrderData = pcall(function()
                                        return Fetch_data()
                                    end)
                                    
                                    if success and newOrderData then
                                        local Product = newOrderData["product"]
                                        local progress = tonumber(newOrderData["progress_value"]) or 0
                                        local target = tonumber(newOrderData["target_value"]) or 1
                                        print("[Guitar King] Progress:", progress, "/", target)
                                        
                                        if Product and Product["condition"] and Product["condition"]["type"] == "character" then
                                            if progress >= target then
                                                print("[Guitar King] Target reached!")
                                                if _G.Leave_Party then _G.Leave_Party() end
                                                Post(PathWay .. "finished", CreateBody())
                                                task.delay(3, Auto_Config)
                                                return
                                            end
                                        end
                                    end
                                end
                            end)
                            return false
                        end
                    end
                    return true
                end
                
                -- ฟังก์ชันเล่นเพลง
                local function playNextGuitarSong()
                    hasEndedCurrentSong = false
                    hitCount = 0
                    
                    local song = GK_SONGS[gkSongIndex]
                    local diff = GK_DIFFICULTIES[gkDiffIndex]
                    print("[Guitar King] Playing:", song, "-", diff)
                    
                    pcall(function()
                        JamSessionHandler.StartMinigame(song, diff)
                    end)
                end
                
                -- ฟังก์ชัน Force End - ส่ง score ก่อนปิด!
                local function tryForceEnd()
                    if hasEndedCurrentSong then return end
                    
                    local score = 0
                    pcall(function()
                        if ScoreHandler.GetCurrentScore then
                            score = ScoreHandler.GetCurrentScore() or 0
                        end
                    end)
                    
                    hitCount = hitCount + 1
                    if hitCount % 100 == 0 then
                        print("[Guitar King] Hits:", hitCount, "Score:", score)
                    end
                    
                    if score >= TARGET_SCORE then
                        hasEndedCurrentSong = true
                        
                        local song = GK_SONGS[gkSongIndex]
                        local diff = GK_DIFFICULTIES[gkDiffIndex]
                        
                        print("[Guitar King] SCORE", score, ">= 100k! Sending...")
                        
                        -- ส่ง score ไป server โดยตรง ก่อนปิด minigame!
                        pcall(function()
                            UpdateScoreRemote:FireServer(song, diff, score)
                        end)
                        
                        -- ปิดทันที ไม่ต้องรอนาน
                        task.delay(0.1, function()
                            pcall(function()
                                if GuitarMinigame.Cleanup then
                                    GuitarMinigame.Cleanup(false)
                                end
                            end)
                            
                            task.delay(0.1, function()
                                closeGuitarUI()
                                
                                task.delay(0.3, function()
                                    if goToNextSong() then
                                        playNextGuitarSong()
                                    end
                                end)
                            end)
                        end)
                    end
                end
                
                -- ===== AUTO-HIT + CHECK SCORE =====
                local originalHitNote = ScoreHandler.HitNote
                local originalMissNote = ScoreHandler.MissNote
                
                if originalHitNote then
                    ScoreHandler.HitNote = function(isPerfect, ...)
                        local result = originalHitNote(true, ...)
                        tryForceEnd()
                        return result
                    end
                end
                
                if originalMissNote then
                    ScoreHandler.MissNote = function(...)
                        if originalHitNote then
                            local result = originalHitNote(true)
                            tryForceEnd()
                            return result
                        end
                        return
                    end
                end
                
                -- Auto-hit: Hook PullNote
                local originalPullNote = GuitarMinigame.PullNote
                if originalPullNote then
                    GuitarMinigame.PullNote = function(...)
                        local note = originalPullNote(...)
                        if note and originalHitNote then
                            task.delay(0.05, function()
                                pcall(function()
                                    originalHitNote(true)
                                    tryForceEnd()
                                end)
                            end)
                        end
                        return note
                    end
                end
                
                -- ===== ULTRA FAST AUTO-HIT LOOP =====
                task.spawn(function()
                    while Settings["Select Mode"] == "Guitar King" do
                        pcall(function()
                            local isActive = GuitarMinigame._isActive or GuitarMinigame.Active or false
                            if type(GuitarMinigame.IsActive) == "function" then
                                isActive = GuitarMinigame.IsActive()
                            end
                            
                            if isActive and originalHitNote then
                                -- SPAM HIT 50 ครั้งต่อ loop!
                                for i = 1, 50 do
                                    originalHitNote(true)
                                end
                                tryForceEnd()
                            end
                        end)
                        task.wait() -- เร็วที่สุด (1 frame)
                    end
                end)
                
                -- MinigameEnded สำหรับกรณีจบเพลงปกติ
                GuitarMinigame.MinigameEnded:Connect(function(score)
                    print("[Guitar King] Song ended! Score:", score or 0)
                    if hasEndedCurrentSong then return end
                    
                    hasEndedCurrentSong = true
                    task.delay(0.2, function()
                        if goToNextSong() then
                            playNextGuitarSong()
                        end
                    end)
                end)
                
                -- Start first song
                print("[Guitar King] Starting first song...")
                playNextGuitarSong()
            end
        else
            local plr = game:GetService("Players").LocalPlayer
            local Networking = game:GetService("ReplicatedStorage"):WaitForChild("Networking")
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
                        Networking.TeleportEvent:FireServer("Lobby")
                        end
                    end
                    task.wait(30)
                end
            end) 
            if Settings["Auto Priority"] or Settings["Priority Multi"] then
                local Setting = Settings["Priority Multi"]
                local function Priority(Model,ChangePriority)
                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("UnitEvent"):FireServer(unpack({
                        "ChangePriority",
                        Model.Name,
                        ChangePriority
                    }))
                end
                if Setting["Enabled"] then
                    local UnitsHUD = require(game:GetService('StarterPlayer').Modules.Interface.Loader.HUD.Units)
                    local ClientUnitHandler = require(game:GetService('StarterPlayer').Modules.Gameplay.Units.ClientUnitHandler)
                    local ConvertUnitToNumber = {}
                    for i, v in pairs(UnitsHUD._Cache) do
                        if v == 'None' then
                            continue
                        end
                        ConvertUnitToNumber[v['Data']['Name']] = i
                    end
                    for i, v in pairs(ClientUnitHandler['_ActiveUnits']) do
                        if v['Player'] == game.Players.LocalPlayer then
                            local Index = ConvertUnitToNumber[v['Name']]
                            Priority(v["Model"],Setting[tostring(Index)]) 
                        end
                    end
                    workspace.Units.ChildAdded:Connect(function(v)
                        for i, v in pairs(ClientUnitHandler['_ActiveUnits']) do
                            if v['Player'] == game.Players.LocalPlayer then
                                local Index = ConvertUnitToNumber[v['Name']]
                                Priority(v["Model"],Setting[tostring(Index)]) 
                            end
                        end
                    end)
                elseif Settings["Auto Priority"] then
                    
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
            end
            if Settings["Auto Stun"] then
                repeat wait() until game:IsLoaded()
                
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
            -- Auto Modifier System (New - Based on AV_AutoModifier)
            if Settings["Auto Modifier"] then
                local plr = game:GetService("Players").LocalPlayer
                local lastChoice = nil
                local isChoosing = false
                local chosenModifiers = {}
                local currentWave = 0

                local function ChooseModifier(modifierName)
                    pcall(function()
                        Networking.ModifierEvent:FireServer("Choose", modifierName)
                    end)
                end

                local function VoteRestart()
                    pcall(function()
                        Networking.MatchRestartSettingEvent:FireServer("Vote")
                    end)
                end

                local function GetAvailableModifiers()
                    local available = {}
                    pcall(function()
                        local ModifiersGui = plr.PlayerGui:FindFirstChild("Modifiers")
                        if ModifiersGui then
                            local ModifiersFrame = ModifiersGui:FindFirstChild("Modifiers")
                            if ModifiersFrame then
                                local MainFrame = ModifiersFrame:FindFirstChild("Main")
                                if MainFrame and MainFrame.Visible then
                                    for _, child in pairs(MainFrame:GetChildren()) do
                                        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") or child:IsA("TextLabel") then
                                            if child.Visible then
                                                table.insert(available, child.Name)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    return available
                end

                local function GetBestModifier(availableModifiers)
                    local bestModifier = nil
                    local highestPriority = -999
                    
                    for _, modName in ipairs(availableModifiers) do
                        local priority = Settings["Modifier Priority"][modName] or 0
                        if priority > highestPriority then
                            highestPriority = priority
                            bestModifier = modName
                        end
                    end
                    
                    return bestModifier
                end

                local function HasChosenRequiredModifier()
                    for _, required in ipairs(Settings["Select Modifier"]) do
                        for _, chosen in ipairs(chosenModifiers) do
                            if string.lower(chosen) == string.lower(required) then
                                return true
                            end
                        end
                    end
                    return false
                end

                -- Wave Tracker
                local InterfaceEvent = Networking:WaitForChild("InterfaceEvent")
                InterfaceEvent.OnClientEvent:Connect(function(eventType, data)
                    if eventType == "Wave" and data and data.Waves then
                        currentWave = data.Waves
                        -- print("[Auto Modifier] Wave:", currentWave)
                        
                        if currentWave == 0 then
                            chosenModifiers = {}
                            lastChoice = nil
                        end
                        
                        if Settings["Restart Modifier"] and currentWave >= 1 then
                            if not HasChosenRequiredModifier() then
                                -- print("[Auto Modifier] Required modifier not found, voting restart...")
                                VoteRestart()
                            end
                        end
                    end
                end)

                -- Main Loop
                task.spawn(function()
                    while task.wait(0.5) do
                        if isChoosing then continue end
                        
                        local availableModifiers = GetAvailableModifiers()
                        if #availableModifiers == 0 then 
                            lastChoice = nil
                            continue 
                        end
                        
                        local bestModifier = GetBestModifier(availableModifiers)
                        
                        if bestModifier and bestModifier ~= lastChoice then
                            isChoosing = true
                            -- print("[Auto Modifier] Choosing:", bestModifier)
                            ChooseModifier(bestModifier)
                            lastChoice = bestModifier
                            table.insert(chosenModifiers, bestModifier)
                            task.wait(0.5)
                            isChoosing = false
                        end
                    end
                end)
                print("[Auto Modifier] Loaded!")
            end
            
            -- ⭐⭐⭐ รอจนกว่าจะเจอ EndScreen ก่อน
            if Networking:FindFirstChild("EndScreen") and Networking.EndScreen:FindFirstChild("ShowEndScreenEvent") then
                Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                    print("[EndScreen] 📺 Detected! Status:", Results and Results.Status or "Unknown")
                
                -- ⭐⭐⭐ SHARED FUNCTIONS
                local function isEndScreenVisible()
                    local EndScreenGui = plr.PlayerGui:FindFirstChild("EndScreen")
                    if EndScreenGui then
                        local Holder = EndScreenGui:FindFirstChild("Holder")
                        if Holder and Holder.Visible then
                            return true
                        end
                        if EndScreenGui.Enabled ~= false then
                            return true
                        end
                    end
                    return false
                end
                
                local function getVoteEvent()
                    if Networking.EndScreen:FindFirstChild("VoteEvent") then
                        return Networking.EndScreen.VoteEvent
                    elseif Networking:FindFirstChild("VoteEvent") then
                        return Networking.VoteEvent
                    end
                    return nil
                end
                
                -- ⭐⭐⭐ AUTO RETRY (เหมือน AutoPlayBase.lua)
                if Settings["Auto Retry"] then
                    task.spawn(function()
                        local VoteEvent = getVoteEvent()
                        if VoteEvent then
                            task.wait(2)
                            pcall(function()
                                VoteEvent:FireServer("Retry")
                                print("[Auto Retry] 🔄 Voted Retry")
                            end)
                            task.wait(3)
                            if isEndScreenVisible() then
                                pcall(function()
                                    VoteEvent:FireServer("Retry")
                                    print("[Auto Retry] 🔄 Voted Retry (2nd attempt)")
                                end)
                            end
                        else
                            warn("[Auto Retry] ⚠️ VoteEvent not found")
                        end
                    end)
                end
                
                -- ⭐⭐⭐ AUTO NEXT
                if Settings["Auto Next"] then
                    task.spawn(function()
                        local VoteEvent = getVoteEvent()
                        if VoteEvent then
                            task.wait(2)
                            local voteAttempts = 0
                            local maxAttempts = 3
                            
                            while Settings["Auto Next"] and isEndScreenVisible() and voteAttempts < maxAttempts do
                                pcall(function()
                                    VoteEvent:FireServer("Next")
                                    print("[Auto Next] ➡️ Voted Next (attempt " .. (voteAttempts + 1) .. ")")
                                end)
                                voteAttempts = voteAttempts + 1
                                task.wait(5)
                            end
                        else
                            warn("[Auto Next] ⚠️ VoteEvent not found")
                        end
                    end)
                end
                
                -- ⭐⭐⭐ AUTO BACK LOBBY
                if Settings["Auto Back Lobby"] then
                    task.spawn(function()
                        task.wait(3)
                        if isEndScreenVisible() then
                            pcall(function()
                                Networking.TeleportEvent:FireServer("Lobby")
                                print("[Auto Back Lobby] 🏠 Teleporting to Lobby")
                            end)
                        end
                    end)
                end
                
                -- Legacy Challenge/Bounty handling
                task.wait(2)
                if Results['StageType'] == "Challenge" then
                    Networking.TeleportEvent:FireServer("Lobby")
                elseif _G.CHALLENGE_CHECKCD() and Settings["Auto Join Challenge"] then
                    Networking.TeleportEvent:FireServer("Lobby")
                elseif Settings["Auto Join Bounty"]  and task.wait(.5) and _G.BOSS_BOUNTY() and plr.PlayerGui:FindFirstChild("EndScreen") then
                    if plr.PlayerGui.EndScreen.Holder.Buttons:FindFirstChild("Bounty") and plr.PlayerGui.EndScreen.Holder.Buttons.Bounty["Visible"] then

                    else
                        Networking.TeleportEvent:FireServer("Lobby")
                    end
                end
                end)
                print("[EndScreen] ✅ ShowEndScreenEvent connected!")
            else
                warn("[EndScreen] ⚠️ EndScreen or ShowEndScreenEvent not found - Auto Retry/Next/BackLobby disabled")
            end
        end
    end)
end)