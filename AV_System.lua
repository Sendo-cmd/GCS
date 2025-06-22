repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
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
Edge of Heaven
]]

--[[
Legend Stage Map
Sand Village
Kuinshi Palace
Land of the Gods
Golden Castle
Shibuya Aftermath
Double Dungeon
Shining Castle
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

_G.User = {
    ["R6W2iU8NY0Yt0y"] = {
        -- ["Select Mode"] = "Dungeon", -- Portal
        -- ["Auto Stun"] = false,
        -- ["Auto Priority"] = false,
        -- ["Priority"] = "Bosses",
        ["Party Mode"] = true,
        -- ["Party Member"] = {
        --     "MonarchJINWO21",
        --     "jojoisrealko",
        -- },
        -- ["Dungeon Settings"] = {
        --     ["Difficulty"] = "Nightmare",
        --     ["Act"] = "AntIsland",
        --     ["StageType"] = "Dungeon",
        --     ["Stage"] = "Ant Island",
        --     ["FriendsOnly"] = false
        -- },
    },
    ["aR8xV9v6JI0FV9"] = {
        ["Auto Join Rift"] = true,
    },
    ["J9O0Eg0cQ03MCV"] = {
        ["Party Mode"] = true,
    },
    ["GCshop2"] = {
        ["Select Mode"] = "Portal", -- Portal
        ["Auto Stun"] = false,
        ["Auto Priority"] = false,
        ["Priority"] = "Bosses",
        ["Party Mode"] = false,
        ["Party Member"] = {
            "GVU257sFK8en2v",
        },
        ["Portal Settings"] = {
            ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
            ["Tier Cap"] = 10,
            ["Method"] = "Highest", -- Highest , Lowest
            ["Ignore Stage"] = {
                "Land of the Gods"
            },
            ["Ignore Modify"] = {},
        },   
    },
    ["NoneFree"] = {
        ["Select Mode"] = "Raid", -- Portal
        ["Auto Stun"] = false,
        ["Auto Priority"] = true,
        ["Priority"] = "Bosses",
        ["Party Mode"] = true,
        ["Party Member"] = {
            "None3",
        },
        ["Raid Settings"] = {
            ["Difficulty"] = "Nightmare",
            ["Act"] = "Act1",
            ["StageType"] = "Raid",
            ["Stage"] = "Ruined City",
            ["FriendsOnly"] = false
        },
    },
    ["344t0sHCdw6oDK"] = {
        ["Party Mode"] = true,
    },
    ["c97m7VvHFTPZ19"] = {
        ["Auto Join Rift"] = true,
    },
    ["Falsoraben712"] = {
        ["Party Mode"] = true,
    },
    ["HN0U173rfP9Rej"] = {
        ["Party Mode"] = true,
    },
    ["s1t4d4vPKqIz61"] = {
        ["Party Mode"] = true,
    },
    ["beastnahee"] = {
        ["Party Mode"] = true,
    },
    ["JapanMovieTH12"] = {
        ["Party Mode"] = true,
    },
    ["canonA624"] = {
        ["Party Mode"] = true,
    },
    ["EliXXLRkF"] = {
        ["Party Mode"] = true,
    },
    ["deenhumyai"] = {
        ["Party Mode"] = true,
    },
    ["Turlizoha3831"] = {
        ["Party Mode"] = true,
    },
    ["Bfkaitun9772"] = {
        ["Party Mode"] = true,
    },
    ["unf0rg1ven_249"] = {
        ["Party Mode"] = true,
    },
    ["Trarockker"] = {
        ["Party Mode"] = true,
    },
    ["s0SoYQ84GXSc12"] = {
        ["Party Mode"] = true,
    },
    ["v0k9Seb9nB6q0P"] = {
        ["Party Mode"] = true,
    },
    ["GVU257sFK8en2v"] = {
        ["Party Mode"] = true,
    },
    ["8F0qejRl63VT7L"] = {
        ["Party Mode"] = true,
    },
    ["a4LbRw0S2O30gi"] = {
        ["Party Mode"] = true,
    },
    ["w42mwpY03FJs3d"] = {
        ["Party Mode"] = true,
    },
    ["J49Mr8EDKF5R5I"] = {
        ["Party Mode"] = true,
    },
    ["O9ctwM68Ix2UG3"] = {
        ["Party Mode"] = true,
    },
    ["8OcN9bx2VN6N2B"] = {
        ["Party Mode"] = true,
    },
    ["n0iM1h7wc3tcM5"] = {
        ["Party Mode"] = true,
    },
    ["fZ7R4D87gVY6WS"] = {
        ["Party Mode"] = true,
    },
    ["I67y3cRp2zG7YU"] = {
        ["Party Mode"] = true,
    },
    ["15F1TxIv5Vz7ml"] = {
        ["Party Mode"] = true,
    },
    ["ls09mFx9AEj56p"] = {
        ["Party Mode"] = true,
    },
    ["47XCD6el66XjzO"] = {
        ["Party Mode"] = true,
    },
    ["1vZ92LnVo3Fu9l"] = {
        ["Party Mode"] = true,
    },
    ["HpEW3m7W65IeF1"] = {
        ["Party Mode"] = true,
    },
    ["1wfj842inPvQ5P"] = {
        ["Party Mode"] = true,
    },
    ["tangdda"] = {
        ["Party Mode"] = true,
    },
    ["DB_KHOON"] = {
        ["Party Mode"] = true,
    },
    ["Flamesiraphat"] = {
        ["Party Mode"] = true,
    },
    ["twelvgir5130"] = {
        ["Party Mode"] = true,
    },
    ["sjdbbzh09"] = {
        ["Party Mode"] = true,
    },
    ["Coknwz"] = {
        ["Party Mode"] = true,
    },
    ["PleumRukNa"] = {
        ["Party Mode"] = true,
    },
    ["EXSTREMz"] = {
        ["Party Mode"] = true,
    },
    ["MazhOG"] = {
        ["Party Mode"] = true,
    },
    ["Nsteam111"] = {
        ["Party Mode"] = true,
    },
    ["Londaruh"] = {
        ["Party Mode"] = true,
    },
    ["WGwOktecgyo"] = {
        ["Party Mode"] = true,
    },
    ["MeanPo01"] = {
        ["Party Mode"] = true,
    },
    ["jojoisrealko"] = {
        ["Party Mode"] = true,
    },
    ["Dbhhceuhceuh"] = {
        ["Select Mode"] = "Story", -- Portal
        ["Auto Stun"] = false,
        ["Auto Priority"] = false,
        ["Priority"] = "Bosses",
        ["Party Mode"] = true,
        ["Party Member"] = {
            "w42mwpY03FJs3d",
            "J49Mr8EDKF5R5I",
        },
        ["Story Settings"] = {
            ["Difficulty"] = "Normal",
            ["Act"] = "Act1",
            ["StageType"] = "Story",
            ["Stage"] = "Edge of Heaven",
            ["FriendsOnly"] = false
        },
    },
    ["OPggripTH"] = {
        ["Select Mode"] = "Raid", -- Portal
        ["Auto Stun"] = false,
        ["Auto Priority"] = true,
        ["Priority"] = "Bosses",
        ["Party Mode"] = true,
        ["Party Member"] = {
            "Wawawa_761",
            "Nainklk",
            "issei123i",
        },
        ["Raid Settings"] = {
            ["Difficulty"] = "Nightmare",
            ["Act"] = "Act1",
            ["StageType"] = "Raid",
            ["Stage"] = "Ruined City",
            ["FriendsOnly"] = false
        },
    },
    ["issei123i"] = {
        ["Party Mode"] = true,
    },
    ["Nainklk"] = {
        ["Party Mode"] = true,
    },
    ["Wawawa_761"] = {
        ["Party Mode"] = true,
    },
    ["bababuty"] = {
        ["Party Mode"] = true,
    },
    ["KsYhgVKd4476"] = {
        ["Party Mode"] = true,
    },
    ["ceeme7777"] = {
        ["Party Mode"] = true,
    },
    ["GoDis_BanG"] = {
        ["Party Mode"] = true,
    },
    ["atomwat123"] = {
        ["Party Mode"] = true,
    },
    ["jm_ep30"] = {
        ["Party Mode"] = true,
    },
    ["Uhdennanji979"] = {
        ["Party Mode"] = true,
    },
    ["TheDarkwolf8333"] = {
        ["Party Mode"] = true,
    },
    ["IQSHOP_1275"] = {
        ["Party Mode"] = true,
    },
    ["Estellburst"] = {
        ["Select Mode"] = "Portal", -- Portal
        ["Auto Stun"] = false,
        ["Auto Priority"] = false,
        ["Priority"] = "Bosses",
        ["Party Mode"] = true,
        ["Party Member"] = {
            "Skyfe0397",
            "canonA624",
            "GVU257sFK8en2v",
        },
        ["Portal Settings"] = {
            ["ID"] = 190, -- 113 Love , 87 Winter , 190 Spring
            ["Tier Cap"] = 10,
            ["Method"] = "Highest", -- Highest , Lowest
            ["Ignore Stage"] = {
                "Land of the Gods"
            },
            ["Ignore Modify"] = {},
        },   
    },
    ["GODZARIO8113"] = {
        ["Party Mode"] = true,
    },
    ["KoopfoolxD2"] = {
        ["Party Mode"] = true,
    },
    ["CaptainMaru863"] = {
        ["Party Mode"] = true,
    },
    ["NANO_SHOP04"] = {
        ["Party Mode"] = true,
    },
    ["CigramGamerTV"] = {
        ["Party Mode"] = true,
    },
    ["scp1774"] = {
        ["Party Mode"] = true,
    },
    ["Skyfe0397"] = {
        ["Party Mode"] = true,
    },
    ["icemateenoobth"] = {
        ["Party Mode"] = true,
    },
    ["surx23"] = {
        ["Party Mode"] = true,
    },
    ["rainbowskythai"] = {
        ["Party Mode"] = true,
    },
    ["GHeirtid"] = {
        ["Party Mode"] = true,
    },
    ["1dayforfirst"] = {
        ["Party Mode"] = true,
    },
    ["tanjiroxfire"] = {
        ["Party Mode"] = true,
    },
    ["MRLUCKY_SKYZA"] = {
        ["Party Mode"] = true,
    },
    ["JanMesu"] = {
        ["Party Mode"] = true,
    },
    ["R3N_Vixtoria3"] = {
        ["Party Mode"] = true,
    },
    ["f1imkungz"] = {
        ["Party Mode"] = true,
    },
    ["Hub6ix04"] = {
        ["Party Mode"] = true,
    },
    ["Chok248"] = {
        ["Party Mode"] = true,
    },
    ["ggkong1412"] = {
        ["Party Mode"] = true,
    },
    ["Bisctm1000"] = {
        ["Party Mode"] = true,
    },
    ["xCrazy_Boyx0"] = {
        ["Party Mode"] = true,
    },
    ["Minarusame"] = {
        ["Party Mode"] = true,
    },
    ["Mangkorn93100"] = {
        ["Party Mode"] = true,
    },
    ["smyfon8"] = {
        ["Party Mode"] = true,
    },
    ["joy006zx"] = {
        ["Party Mode"] = true,
    },
    ["Levid098508"] = {
        ["Party Mode"] = true,
    },
    ["AMERICAMENTIONEDRAHH"] = {
        ["Party Mode"] = true,
    },
    ["2PhuPhu1"] = {
        ["Party Mode"] = true,
    },
    ["BOOMBIGOO"] = {
        ["Party Mode"] = true,
    },
    ["QWQPcZfdXlf"] = {
        ["Party Mode"] = true,
    },
    ["Feasqdx0437"] = {
        ["Party Mode"] = true,
    },
    ["HOdnJWa0347"] = {
        ["Party Mode"] = true,
    },
    ["MonarchJINWO21"] = {
        ["Party Mode"] = true,
    },
    ["shadoTsunami"] = {
        ["Party Mode"] = true,
    },
    ["BeeKak1"] = {
        ["Party Mode"] = true,
    },
    ["Alawihuf8081"] = {
        ["Party Mode"] = true,
    },
    ["Valkor72009"] = {
        ["Party Mode"] = true,
    },
    ["Dwekyphwzxpsg"] = {
        ["Party Mode"] = true,
    },
    ["Rustwhir2660"] = {
        ["Party Mode"] = true,
    },
    ["Brutaroth"] = {
        ["Party Mode"] = true,
    },
    ["Reishthill26675"] = {
        ["Party Mode"] = true,
    },
    ["surasafe"] = {
        ["Party Mode"] = true,
    },
    ["underhorror"] = {
        ["Party Mode"] = true,
    },
    ["saveew"] = {
        ["Party Mode"] = true,
    },
    ["2MILL_XXL"] = {
        ["Party Mode"] = true,
    },
    ["keam093321"] = {
        ["Party Mode"] = true,
    },
    ["anakluwza"] = {
        ["Party Mode"] = true,
    },
    ["RyuzaaaV2"] = {
        ["Party Mode"] = true,
    },
    ["lnwyorn_0823"] = {
        ["Party Mode"] = true,
    },
    ["sans_dee1134"] = {
        ["Party Mode"] = true,
    },
    ["smart961"] = {
        ["Party Mode"] = true,
    },
    ["mewant2die_d"] = {
        ["Party Mode"] = true,
    },
    ["bam87871"] = {
        ["Party Mode"] = true,
    },
    ["x8s0r1y5knI3Ls"] = {
        -- ["Select Mode"] = "Portal", -- Portal
        ["Party Mode"] = true,
        -- ["Party Member"] = {
        --     "XDD155490",
        -- },
        -- ["Portal Settings"] = {
        --     ["ID"] = 87, -- 113 Love , 87 Winter
        --     ["Tier Cap"] = 10,
        --     ["Method"] = "Highest", -- Highest , Lowest
        --     ["Ignore Stage"] = {"Spider Forest"},
        --     ["Ignore Modify"] = {},
        -- },   
    },
    ["KOW7Po"] = {
        ["Party Mode"] = true,
    },
    ["Easyblox_P2CWU"] = {
        ["Party Mode"] = true,
    },
    ["masxteng38"] = {
        ["Party Mode"] = true,
    },
    ["paralfar7347"] = {
        ["Party Mode"] = true,
    },
    ["aocyms"] = {
        ["Party Mode"] = true,
    },
    ["juniorlnw5"] = {
        ["Party Mode"] = true,
    },
    ["OP_autokill"] = {
        ["Party Mode"] = true,
    },
    ["enonef2"] = {
        ["Party Mode"] = true,
    },
    ["gsokem"] = {
        ["Party Mode"] = true,
    },
    ["Etaa_xm"] = {
        ["Party Mode"] = true,
    },
    ["zxzxc666"] = {
        ["Party Mode"] = true,
    },
    ["XDD155490"] = {
        ["Party Mode"] = true,
    },
    ["Taqmgapckpkyl"] = {
        ["Party Mode"] = true,
    },
    ["0621319907fake"] = {
        ["Party Mode"] = true,
    },
    ["Namo1171"] = {
        ["Party Mode"] = true,
    },
    ["Spiryfedje86606"] = {
        ["Party Mode"] = true,
    },
    ["nongmai813"] = {
        ["Party Mode"] = true,
    },
    ["Dukduies"] = {
        ["Party Mode"] = true,
    },
    ["rain4834"] = {
        ["Party Mode"] = true,
    },
    ["TYTAP002"] = {
        ["Party Mode"] = true,
    },
    ["tatoeyaa"] = {
        ["Party Mode"] = true,
    },
    ["XIIqPD"] = {
        ["Party Mode"] = true,
    },
    ["mamekokoe"] = {
        ["Select Mode"] = "Story", -- Portal , Dungeon , Story , Legend Stage , Raid
        ["Party Mode"] = true,
        ["Party Member"] = {
            "Turlizoha3831",
        },
        ["Story Settings"] = {
            ["Difficulty"] = "Normal",
            ["Act"] = "Act1",
            ["StageType"] = "Story",
            ["Stage"] = "Martial Island",
            ["FriendsOnly"] = false
        },
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
local function Len(tab)
    local count = 0
    for i,v in pairs(tab) do
        count = count + 1
    end
    return count
end
local function IndexToDisplay(arg)
    return StagesData["Story"][arg]["StageData"]["Name"]
end

-- All Variables
-- local Key = "Onio_#@@421"
local plr = game.Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local RBXGeneral = TextChatService.TextChannels.RBXGeneral
local Inventory = {}

local Settings ={

    ["Select Mode"] = "Portal", -- Portal , Dungeon , Story , Legend Stage , Raid , Challenge , Boss Event
    ["Auto Join Rift"] = false,
    ["Auto Join Boss Event"] = false,

    ["Auto Stun"] = false,
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
    ["Portal Settings"] = {
        ["ID"] = 113, -- 113 Love , 87 Winter , 190 Spring
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
if game.PlaceId == 16146832113 then
    game:GetService("ReplicatedStorage").Networking.RequestInventory.OnClientEvent:Connect(function(value)
        Inventory = value
    end)
    game:GetService("ReplicatedStorage").Networking.RequestInventory:FireServer("RequestData")
end
task.spawn(function()
    task.wait(2)
    if game.PlaceId == 16146832113 then
        if Settings["Party Mode"]  then
            print("Im here 2")
            if not Settings["Party Member"]  then
                print("Im here 3")
                while task.wait(5) do
                    pcall(function()
                        local requestTo = game:HttpGet("https://api.championshop.date/party-aa/" .. game.Players.LocalPlayer.Name) and game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.championshop.date/party-aa/" .. game.Players.LocalPlayer.Name))
                        local ost = requestTo["status"] == "success" and requestTo["value"]["os"] or 0
                        if tostring(requestTo["status"]) == "success" and requestTo["value"] and tonumber(ost) >= os.time() then
                            warn("Join")
                            if requestTo["value"]["type"] == "Portal" then
                                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                                    "JoinPortal",
                                    requestTo["value"]["data"]
                                )
                            elseif requestTo["value"]["type"] == "Normal" then
                                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer( 
                                    "JoinMatch",
                                    requestTo["value"]["data"]
                                )
                            elseif requestTo["value"]["type"] == "Rift" then
                                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                                    "Join",
                                    requestTo["value"]["data"]
                                )
                            end
                        end
                    end)
                end
            else
                local UUID = nil
                local Type = false
                game:GetService("ReplicatedStorage").Networking.Portals.PortalReplicationEvent.OnClientEvent:Connect(function(index,value)
                    if index == "Replicate" and tostring(value["Owner"]) == plr.Name then
                        Type = true
                        UUID = value["GUID"]
                    end
                end)
                game:GetService("ReplicatedStorage").Networking.MatchReplicationEvent.OnClientEvent:Connect(function(index,value)
                    warn(index,value,tostring(value["Owner"]) == plr.Name)
                    if index == "AddMatch" and tostring(value["Host"]) == plr.Name then
                        Type = false
                        UUID = value["GUID"]
                        print(value)
                    end
                end)
                task.spawn(function()
                    while task.wait() do
                        if UUID then
                            print(UUID)
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
                                            ["type"] = Type and "Portal" or "Normal",
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
        function AllPlayerInGame()
            print(Settings["Party Member"])
            for i,v in pairs(Settings["Party Member"]) do
                if not game:GetService("Players"):FindFirstChild(v) then
                    return false
                end
            end
            return true
        end
        local WaitTime = 120
        if Settings["Auto Join Rift"] and workspace:GetAttribute("IsRiftOpen") then
            while true do
                if AllPlayerInGame() then
                    Next_(WaitTime)
                    if AllPlayerInGame() then 
                        task.wait(math.random(2,10))
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
                                        ["type"] = "Rift",
                                        ["data"] = GUID,
                                        ["os"] = os.time() + 120
                                    },
                                })
                            })
                        end
                    end
                end
                task.wait(2)
            end
        end
        if Settings["Auto Join Boss Event"] then
            
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
            while true do
                if AllPlayerInGame() then
                    Next_(WaitTime)
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
        elseif Settings["Select Mode"] == "Story" then
            while true do
                if AllPlayerInGame() then
                    Next_(WaitTime)
                    if AllPlayerInGame() then 
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
                if AllPlayerInGame() then
                    Next_(WaitTime)
                    if AllPlayerInGame() then 
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
                if AllPlayerInGame() then
                    Next_(WaitTime)
                    if AllPlayerInGame() then 
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
                if AllPlayerInGame() then
                    Next_(WaitTime)
                    if AllPlayerInGame() then 
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
