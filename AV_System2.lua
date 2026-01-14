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
local Use_API = true -- เปิด/ปิด API (ถ้าปิดจะใช้ auto config จาก Changes table แทน)

local request = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or request
if not request then
    request = function(options)
        return {Success = false, Body = "{}"}
    end
    warn("[AV_System2] No HTTP request function found!")
end

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
        "edbd1859-f374-4735-87c7-2b0487808665",
        "c480797f-3035-4b1f-99a3-d77181f338bf",
    },
    ["Super Reroll"] = {
        "39ce32e2-c34c-4479-8a52-5715e8645944",
        "63c63616-134c-4450-a5d6-a73c7d44d537",
        "5852f3ef-a949-4df5-931b-66ac0ac84625",
        "d85e3e85-0893-4972-a145-d6ba42bac512",
        "503237ef-99e7-4a53-b61a-1ac9ca8dee60",
        "2a77cde0-0bab-4880-a01e-8bbe4b76956e",
        "df999032-bd9e-4933-bba1-a037997ce505",
    },
    ["Igros"] = {
        "c040bd90-d939-4f0c-b65d-1e0ace06a434",
        "c4ca5b41-f68f-4e7b-a8e7-8b2ee7284d08",
        "5a2a67e9-7407-4437-bc2e-c332135cec53",
    },
    ["Boss Event"] = {
        "143f6820-6e5e-4f6e-b3f9-3de3e9586271",
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
        "427f560e-b78e-4ec9-b711-d451b0312306",
        "d8b5cc8c-effd-4521-9db9-04fb460cd225",
        "30a613fb-29c9-4b88-b18b-1b4231a5468d",
        "dfa9b68a-95d7-4227-b118-702cf45061c7",
    },
    ["Lfelt"] = {
        "fed48f27-35a3-47a7-b937-5a4dc59c6d28",
        "785409b0-02f9-4bb8-8ad8-b383b59f6f54",
        "bc1be299-c561-4a41-964a-a055f8a8e436",
        "1c58db6a-b5d1-4d8d-8195-75aad0403c90",
    },
    ["Red Key"] = {
        "e4ed794a-8569-4da6-976d-829ac43f423f",
        "cfbb32d7-64cb-4135-b1e3-1992e1800d07",
        "e1a0c37a-c004-4ff3-a064-2b7d55703c3e",
        "b752455d-18d7-4bb3-bd67-70269790500f",
    },
    ["Yomomata"] = {
        "e7403190-850c-49e5-b2b0-b4949e477c47",
        "139a8d72-0bfb-478b-98e4-5dd152f01206",
        "7d480a51-e6df-45e7-b0f8-9e34966ecc7e",
    },
    ["Remote"] = {
        "2e2a5d02-4d63-43a5-8b9a-6e7902581cfd",
        "960de970-ba26-4184-8d97-561ae8511e4b",
        "24cbfd35-8df6-4fc7-8c0f-5e9c4b921013",
        "0495121f-a579-4068-9494-4a1ac477613b",
        "fb02fc4d-29d3-4158-b6f1-6a7d8fa3a2f5",
        "4c3e1a8b-02fd-42e7-9905-e44a073e3bbc",
        "3f91fbcb-c0de-4251-8a27-df651f9933aa",
        "f96ab092-314a-484b-a098-59209edccb0a",
    },
    -- ["Spring Portal"] = {
    --     "2e2a5d02-4d63-43a5-8b9a-6e7902581cfd",
    --     "960de970-ba26-4184-8d97-561ae8511e4b",
    --     "24cbfd35-8df6-4fc7-8c0f-5e9c4b921013",
    --     "0495121f-a579-4068-9494-4a1ac477613b",
    --     "6ace8ed9-915e-474a-af43-39328ea80a4f",
    --     "1e3dd6cd-e3d2-4dae-810f-911df0ab4806",
    --     "abc198e7-cdfc-497d-83d6-a5c9f88f3c22",
    --     "69d6b35d-0dc0-46d5-96c6-be037b876cdd",
    -- },
    ["Arin"] = {
        "6eef0b60-b61d-47d1-aba5-22d6fea4cb8f",
        "89901139-d4b5-4555-8913-4900d176546c",
        "7b29fe07-6313-48cb-a095-3680d4758ab6",
        "1e07ff1f-ab45-466b-8b36-ae0ff8b43198",
    },
    ["Summer Portal"] = {
        "e206ec24-dfbf-4157-a380-9afabe115c29",
        "c62223a2-17f9-4078-bbc0-bb45c484558f",
        "d92fceaa-8d18-4dc9-980f-452db4573ad9",
    },
    ["Summer Inf"] = {
        "ffa517b2-7f99-47a8-aadc-d7662b96eb60",
        "c869c464-6864-4eb7-a98f-f78f3448b71c",
        "fc7a340c-7c98-4da6-84aa-a7e3ce4790c1",
        "d551991a-b8ec-4fe5-96f5-2fe6418a3e9a",
    },
    ["Anniversary"] = {
        "c3795c09-07c3-4b30-ba13-067deb00b9dc",
        "659d38ba-bfed-4d48-93b0-b015e19fad58",
        "e99f1149-1c90-4997-a99c-87e9dd812fe9",
        "ce0355ef-7f25-42b7-8f4a-14a47c257ff8",
        "42b71690-3363-46bd-b933-046241c9a2cc",
        "bc3274e0-17fd-4cc3-b4e2-55323a734993",
        "983626d0-e545-4bb2-9623-fad3c4899f81",
    },
    ["Test"] = {
        "d88ae3d8-3e47-4de0-b18c-ee598fb2bb83",
    },
}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

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
        ["Method"] = "POST",
        ["Headers"] = {
            ["x-http-method-override"] = "DELETE",
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4",
        },
    })
    return response
end
local function GetCache(OrderId)
    local Cache = Get(Api .. MainSettings["Path_Cache"] .. "/" .. OrderId)
    if not Cache["Success"] then
        return false
    end
    local Data = DecBody(Cache)
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
local Settings ={

    ["Select Mode"] = "Portal", -- Portal , Dungeon , Story , Legend Stage , Raid , Challenge , Boss Event , World Line , Bounty , AFK , Summer , Odyssey
    ["Auto Join Rift"] = false,
    ["Auto Join Bounty"] = false,
    ["Auto Join Boss Event"] = false,
    ["Auto Join Challenge"] = false,

    ["Auto Stun"] = false,
    ["Auto Priority"] = false,
    ["Priority"] = "First", 
    ["Party Mode"] = false,

    -- Auto Modifier Settings
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
    end,
    ["d551991a-b8ec-4fe5-96f5-2fe6418a3e9a"] = function()
        Settings["Select Mode"] = "Fall Infinite"
    end,
    ["ffa517b2-7f99-47a8-aadc-d7662b96eb60"] = function()
        Settings["Select Mode"] = "Fall Infinite"
    end,
    ["c869c464-6864-4eb7-a98f-f78f3448b71c"] = function()
        Settings["Select Mode"] = "Fall Infinite"
    end,
    ["d88ae3d8-3e47-4de0-b18c-ee598fb2bb83"] = function()
        Settings["Select Mode"] = "Dungeon"
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
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["29fe5885-c673-46cf-9ba4-a7f42c2ba0b0"] = function()
        Settings["Select Mode"] = "Story"
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
        Settings["Story Settings"] = {
        ["Difficulty"] = "Nightmare",
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Planet Namak",
        ["FriendsOnly"] = false
    }
    end,
    ["fed48f27-35a3-47a7-b937-5a4dc59c6d28"] = function()
        Settings["Select Mode"] = "Story"
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
        ["Act"] = "Infinite",
        ["StageType"] = "Story",
        ["Stage"] = "Shibuya Station",
        ["FriendsOnly"] = false
    }
    end,
    ["68cd687d-0760-4550-a7d6-482f3c2ca9df"] = function()
        Settings["Select Mode"] = "Story"
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
    end,
    ["bc0fca7b-dde2-47a6-a50b-793d8782999b"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["edbd1859-f374-4735-87c7-2b0487808665"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["c480797f-3035-4b1f-99a3-d77181f338bf"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["39ce32e2-c34c-4479-8a52-5715e8645944"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["63c63616-134c-4450-a5d6-a73c7d44d537"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["5852f3ef-a949-4df5-931b-66ac0ac84625"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["d85e3e85-0893-4972-a145-d6ba42bac512"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["03237ef-99e7-4a53-b61a-1ac9ca8dee60"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["503237ef-99e7-4a53-b61a-1ac9ca8dee60"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["2a77cde0-0bab-4880-a01e-8bbe4b76956e"] = function()
        Settings["Auto Join Challenge"] = true
        Settings["Auto Join Bounty"] = true
        Settings["Auto Modifier"] = true
        Settings["Restart Modifier"] = true
        Settings["Select Modifier"] = {"Exploding"}
    end,
    ["df999032-bd9e-4933-bba1-a037997ce505"] = function()
       Settings["Auto Join Challenge"] = true
       Settings["Auto Join Bounty"] = true
       Settings["Auto Modifier"] = true
       Settings["Restart Modifier"] = true
       Settings["Select Modifier"] = {"Exploding"}
    end,
    ["143f6820-6e5e-4f6e-b3f9-3de3e9586271"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["abb151e9-5e2a-40d3-91fe-7da3ee03f1aa"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["5a815e6f-7024-4e6e-9d30-50cda9a765bd"] = function()
       Settings["Select Mode"] = "Boss Event"
       Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
    }
    end,
    ["66ace527-415a-4b1f-a512-9f3429f67067"] = function()
        Settings["Select Mode"] = "Boss Event"
        Settings["Boss Event Settings"] = {
        ["Difficulty"] = "Normal",
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
        Settings["Auto Next"] = true
    end,
    ["562e53d5-22c8-4337-a5bc-c36df924524b"] = function()
        Settings["Select Mode"] = "World Line"
        Settings["Auto Next"] = true
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Utilities = Modules:WaitForChild("Utilities")
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitsData = require(Modules.Data.Entities.Units)
local ItemsData = require(Modules.Data.ItemsData)
local TableUtils = require(Utilities.TableUtils)

local InventoryEvent = game:GetService("StarterPlayer"):FindFirstChild("OwnedItemsHandler",true) or game:GetService("ReplicatedStorage").Networking:WaitForChild("InventoryEvent",2)

local function GetData()
    local SkinTable = {}
    local FamiliarTable = {}
    local Inventory = {}
    local EquippedUnits = {}
    local Units = {}
    local Battlepass = 0

    local plr = game:GetService("Players").LocalPlayer
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
local function Register_Room(myproduct,player)
    if IsGame == "AV" then
        local Networking = ReplicatedStorage:WaitForChild("Networking")
        if Changes[myproduct] then
            Changes[myproduct]()
            print("Configs has Changed ")
        end 
        local Inventory = GetData()["Inventory"]

        -- All Modules
        local StagesData = LoadModule(game:GetService("ReplicatedStorage").Modules.Data.StagesData)
        -- All Functions
        local function GetItem(ID)
            Inventory = require(InventoryEvent).GetItems()
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
            task.wait(.3)
        end
        local function IndexToDisplay(arg)
            return StagesData["Story"][arg]["StageData"]["Name"]
        end
        local WaitTime = 30
        print("A")
        if Settings["Auto Join Challenge"] then
            local Modules_R = ReplicatedStorage:WaitForChild("Modules")
            local Modules_S = StarterPlayer:WaitForChild("Modules")

            local ChallengesData = require(Modules_R:WaitForChild("Data"):WaitForChild("Challenges"):WaitForChild("ChallengesData"))
            local ChallengesAttemptsHandler = require(Modules_S:WaitForChild("Gameplay"):WaitForChild("Challenges"):WaitForChild("ChallengesAttemptsHandler"))

            for i, v in pairs(ChallengesData.GetChallengeTypes()) do
                for i1, v1 in pairs(ChallengesData.GetChallengesOfType(v)) do
                    local Type = v1.Type
                    local Name = v1.Name
                    if ChallengesData.GetChallengeRewards(Name)['Currencies'] and ChallengesData.GetChallengeRewards(Name)['Currencies']['TraitRerolls'] then
                        local Seed = ChallengesAttemptsHandler.GetChallengeSeed(Type)
                        ChallengesData.GetChallengeSeed(Name)
                        local Reset = ChallengesData.GetNextReset(Type, Seed)
                        if Reset == 0 then
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("ChallengesEvent"):FireServer("StartChallenge",Name)
                            task.wait(2)
                            for i = 1,2 do 
                                for i,v in pairs(player) do task.wait(2.5)
                                    Invite(v)
                                end 
                            end 
                            local args = {
                                [1] = "StartMatch"
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                        end
                    end
                end
            end
        end
        print("AB")
        if Settings["Auto Join Bounty"] then
            task.spawn(function()
                while true do
                    local PlayerBountyDataHandler = require(game:GetService('StarterPlayer').Modules.Gameplay.Bounty.PlayerBountyDataHandler)
                    local BountyData = require(game:GetService('ReplicatedStorage').Modules.Data.BountyData)
                    local Created = BountyData.GetBountyFromSeed(PlayerBountyDataHandler.GetData()["BountySeed"])
                    
                    
                    if PlayerBountyDataHandler.GetData()["BountiesLeft"] > 0 then
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
                        for i = 1,2 do 
                            for i,v in pairs(player) do task.wait(2.5)
                                Invite(v)
                            end 
                        end 
                        task.wait(2)
                        local args = {
                            [1] = "StartMatch"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
                    end
                    task.wait(5)
                end
            end)
            task.wait(6)
        end
        print("ABC")
        if Settings["Auto Join Rift"] and workspace:GetAttribute("IsRiftOpen") then
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
            for i,v in pairs(player) do task.wait(1)
                Invite(v)
            end
        end
        print(Settings["Select Mode"])
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
                    if v["ExtraData"] and Ignore(v["ExtraData"]["Modifiers"] or {},Settings_["Ignore Modify"]) and Settings_["Tier Cap"] >= v["ExtraData"]["Tier"] then
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
            local Portal = PortalSettings(GetItem(Settings_["ID"]))
            if Portal then
                print("Have a Portal")
                local args = {
                    [1] = "ActivatePortal",
                    [2] = Portal
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(unpack(args))
                task.wait(3)
            else
                print("Dont have portal",Settings_["ID"])
            end
        elseif Settings["Select Mode"] == "Story" then
            local StorySettings = Settings["Story Settings"]
            StorySettings["Stage"] = DisplayToIndexStory(StorySettings["Stage"])
            local args = {
                [1] = "AddMatch",
                [2] = StorySettings
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            task.wait(5)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    print(i,v)
                    Invite(v)
                end 
            end
            task.wait(5)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
        elseif Settings["Select Mode"] == "Summer" then
            game:GetService("ReplicatedStorage").Networking.Summer.SummerLTMEvent:FireServer("Create")
            task.wait(2)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    Invite(v)
                end 
            end 
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
        elseif Settings["Select Mode"] == "Odyssey" then
            local OdysseySettings = Settings["Odyssey Settings"]
            if OdysseySettings["Limiteless"] then
                game:GetService("ReplicatedStorage").Networking.Odyssey.OdysseyEvent:FireServer("Play","Journey")
                for i = 1,2 do 
                    for i,v in pairs(player) do task.wait(2.5)
                        Invite(v)
                    end 
                end 
                local args = {
                    [1] = "StartMatch"
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            else
                game:GetService("ReplicatedStorage").Networking.Odyssey.OdysseyEvent:FireServer("Play","Limitless")
                for i = 1,2 do 
                    for i,v in pairs(player) do task.wait(2.5)
                        Invite(v)
                    end 
                end 
                local args = {
                    [1] = "StartMatch"
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            end
        elseif Settings["Select Mode"] == "Dungeon" then
            local DungeonSettings = Settings["Dungeon Settings"]
            DungeonSettings["Stage"] = DisplayToIndexDungeon(DungeonSettings["Stage"])
            local args = {
                [1] = "AddMatch",
                [2] = DungeonSettings
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            task.wait(5)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    print(i,v)
                    Invite(v)
                end 
            end 
            task.wait(5)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))  
        elseif Settings["Select Mode"] == "Legend Stage" then
            local LegendSettings = Settings["Legend Settings"]
            LegendSettings["Stage"] = DisplayToIndexLegend(LegendSettings["Stage"])
            local args = {
                [1] = "AddMatch",
                [2] = LegendSettings
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            task.wait(5)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    print(i,v)
                    Invite(v)
                end 
            end
            task.wait(5)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
        elseif Settings["Select Mode"] == "Raid" then
            local RaidSettings = Settings["Raid Settings"]
            RaidSettings["Stage"] = DisplayToIndexRaid(RaidSettings["Stage"])
            local args = {
                [1] = "AddMatch",
                [2] = RaidSettings
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
            task.wait(5)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    print(i,v)
                    Invite(v)
                end 
            end
            task.wait(5)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
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
-- for _, v in ipairs(getgc(true)) do
--     if type(v) == "table" and rawget(v, "LoadData") then
--         print(v)
--     end
-- end
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
            task.spawn(function()
                local cache_key = Username
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                local Waiting_Time = os.time() + 150
                local Attempt = 0
                local Current_Party = nil
                local Last_Message_1 = nil
                local Last_Message_2 = nil
                --[[
                    Secret Key Example
                    "orderid_cache_1"
                ]]
                local Counting = {}
                function All_Players_Activated()
                    if type(Current_Party) == "table" then else return false end
                    for i,v in pairs(Current_Party) do
                        if Counting[v] and os.time() > Counting[v] then
                            return false
                        end
                        if not Counting[v] then
                            return false
                        end
                    end
                    return true
                end
                function All_Players_Game()
                    if type(Current_Party) == "table" then else return false end
                    for i,v in pairs(Current_Party) do
                        if not game:GetService("Players"):FindFirstChild(v) then
                            return false
                        end
                    end
                    return true
                end
                function GetParty(cache)
                    if type(cache) ~= "table" then
                        return {}
                    end
                     if type(cache["party_member"]) ~= "table" then
                        return {}
                    end
                    local CParty = table.clone(cache["party_member"])
                    local Insert = {}
                    for i,v in pairs(CParty) do
                        table.insert(Insert,v["name"])
                    end
                    return Insert
                end
                TextChatService.OnIncomingMessage = function(message)
                    local sender = message.TextSource
                    local player = (sender and game.Players:GetPlayerByUserId(sender.UserId) or nil)
                    if player then
                        Counting[tostring(player.Name)] = os.time() + 20
                        print("Add Time To ", player.Name)
                    end
                end
                -- อัพเดท Counting จาก Players ที่อยู่ในเกมโดยตรง (ไม่ต้องรอ chat)
                task.spawn(function()
                    while true do
                        task.wait(3)
                        -- เช็ค party members ที่อยู่ในเกม และอัพเดท Counting
                        if Current_Party and type(Current_Party) == "table" then
                            for _, memberName in pairs(Current_Party) do
                                if Players:FindFirstChild(memberName) then
                                    -- Member อยู่ในเกม - อัพเดท Counting
                                    Counting[memberName] = os.time() + 30
                                    print("[Auto Counting] Member in game:", memberName)
                                end
                            end
                        end
                    end
                end)
                while true do task.wait(1)
                    local cache = GetCache(cache_key)
                    if cache then
                        print(os.time() , cache["last_online"])
                        if os.time() > cache["last_online"] then
                            DelCache(Username)
                            print("Delete Cache")
                            task.wait(2.5)
                        else
                            Attempt = Attempt + 1
                            if Attempt > 5 then
                                UpdateCache(Username,{["last_online"] = os.time() + 200})
                                Attempt = 0
                            end
                            -- Accept 
                            local message = GetCache(Username .. "-message")
                            if message and Last_Message_1 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                                print(message)
                                local old_party = table.clone(cache["party_member"])
                                if LenT(old_party) < 3 then
                                    local success = true
                                    local path = nil
                                    local lowest = math.huge
                                    for i,v in pairs(cache["party_member"]) do
                                        if v["join_time"] < lowest then
                                            path = v["product_id"]
                                            lowest = v["join_time"]
                                        end
                                    end
                                    if path then
                                        local Product_Type_1,Product_Type_2 = nil,nil
                                        for i,v in pairs(Order_Type) do
                                            if table.find(v,path) then
                                                Product_Type_1 = i
                                            end
                                            if table.find(v,cache["current_play"]) then
                                                Product_Type_2 = i
                                            end
                                        end
                                        print(Product_Type_1,Product_Type_2,cache["current_play"])
                                        if Product_Type_1 == Product_Type_2 then
                                            local cache = GetCache(message["order"])
                                            if cache then
                                                old_party[message["order"]] = {
                                                    ["join_time"] = os.time(),
                                                    ["product_id"] = cache["product_id"],
                                                    ["name"] = cache["name"],
                                                } 
                                                UpdateCache(Username,{["party_member"] = old_party})
                                                UpdateCache(message["order"],{["party"] = Username})
                                            else
                                                 print("Cannot Get Cache 1")
                                            end
                                        else
                                            print("Mismatch")
                                            task.wait(3)
                                            success = false
                                        end
                                    else
                                        local cache = GetCache(message["order"])
                                        if cache then
                                            old_party[message["order"]] = {
                                                ["join_time"] = os.time(),
                                                ["product_id"] = cache["product_id"],
                                                ["name"] = cache["name"],
                                            } 
                                            UpdateCache(Username,{["party_member"] = old_party})
                                            UpdateCache(message["order"],{["party"] = Username})
                                            cache = GetCache(cache_key)
                                            path = nil
                                            lowest = math.huge
                                            for i,v in pairs(cache["party_member"]) do
                                                if v["join_time"] < lowest then
                                                    path = v["product_id"]
                                                    lowest = v["join_time"]
                                                end
                                            end
                                        else
                                            print("Cannot Get Cache 2")
                                        end
                                        print("No Product")
                                    end
                                    if path and success then
                                        UpdateCache(Username,{["current_play"] = path}) 
                                    elseif not path then
                                        UpdateCache(Username,{["current_play"] = ""}) 
                                    end
                                    if success then
                                        Waiting_Time = Waiting_Time + 125
                                    end
                                end
                                Last_Message_1 = message["message-id"]
                                task.wait(3)
                            end
                            -- Remove
                            local message = GetCache(Username .. "-message-2")
                            if message and Last_Message_2 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                                local old_party = table.clone(cache["party_member"])
                                if old_party[message["order"]] then
                                    old_party[message["order"]] = nil
                                    UpdateCache(Username,{["party_member"] = old_party})
                                    UpdateCache(message["order"],{["party"] = ""})
                                    Current_Party = GetParty(cache)
                                    local cache = GetCache(Username)
                                    local path = nil
                                    local lowest = math.huge
                                    for i,v in pairs(cache["party_member"]) do
                                        if v["join_time"] < lowest then
                                            path = v["product_id"]
                                            lowest = v["join_time"]
                                        end
                                    end
                                    if path then
                                        UpdateCache(Username,{["current_play"] = path}) 
                                    else
                                        UpdateCache(Username,{["current_play"] = ""}) 
                                    end
                                    Waiting_Time = Waiting_Time + 75
                                end
                                Last_Message_2 = message["message-id"]
                                task.wait(3)
                            end
                            cache = GetCache(cache_key)
                            if cache then
                                Current_Party = GetParty(cache)
                            else
                                print("cannot get cache 3")
                            end
                            if not Current_Party or #Current_Party <= 0 then
                                -- Host Auto Config: ถ้าไม่มี want_carry และไม่มี party member ให้เข้าเล่น auto config ได้
                                if Use_API then
                                    local hostData = Fetch_data()
                                    if hostData and hostData["product_id"] then
                                        local hasWantCarry = false
                                        -- ตรวจสอบว่ามีใครกด want_carry หรือไม่
                                        for _, orderType in pairs(Order_Type) do
                                            for _, prodId in pairs(orderType) do
                                                local otherCache = GetCache(prodId .. "_cache_1")
                                                if otherCache and otherCache["party"] == Username then
                                                    hasWantCarry = true
                                                    break
                                                end
                                            end
                                            if hasWantCarry then break end
                                        end
                                        
                                        if not hasWantCarry then
                                            -- ไม่มี want_carry - เข้าเล่น auto config เลย (ไม่ต้องรอ member)
                                            print("[Host Auto Config] No member request - starting auto config for:", hostData["product_id"])
                                            -- Set current_play ก่อนเข้าเล่น เพื่อให้ member หาเจอ
                                            UpdateCache(Username, {["current_play"] = hostData["product_id"]})
                                            -- Auto Select Items จาก selected_items (รองรับ Act, Stage, และ items)
                                            if hostData["selected_items"] then
                                                local Insert = {}
                                                local SelectedAct = nil
                                                local SelectedStage = nil
                                                for _, v in pairs(hostData["selected_items"]) do
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
                                                -- Apply Act และ Stage (ใช้ค่าอื่นจาก Changes[product_id])
                                                if SelectedAct then
                                                    if Settings["Story Settings"] then Settings["Story Settings"]["Act"] = SelectedAct end
                                                    if Settings["Dungeon Settings"] then Settings["Dungeon Settings"]["Act"] = SelectedAct end
                                                    if Settings["Legend Settings"] then Settings["Legend Settings"]["Act"] = SelectedAct end
                                                    if Settings["Raid Settings"] then Settings["Raid Settings"]["Act"] = SelectedAct end
                                                    -- print("[Host Auto Config] Selected Act:", SelectedAct)
                                                end
                                                if SelectedStage then
                                                    if Settings["Story Settings"] then Settings["Story Settings"]["Stage"] = SelectedStage end
                                                    if Settings["Dungeon Settings"] then Settings["Dungeon Settings"]["Stage"] = SelectedStage end
                                                    if Settings["Legend Settings"] then Settings["Legend Settings"]["Stage"] = SelectedStage end
                                                    if Settings["Raid Settings"] then Settings["Raid Settings"]["Stage"] = SelectedStage end
                                                    -- print("[Host Auto Config] Selected Stage:", SelectedStage)
                                                end
                                                if #Insert > 0 then
                                                    Settings["Select Items"] = Insert
                                                    print("[Host Auto Config] Selected items:", table.concat(Insert, ", "))
                                                end
                                            end
                                            -- เรียก Register_Room เพื่อเข้าเล่นจริง (ไม่มี party member)
                                            local p, c = pcall(function()
                                                Register_Room(hostData["product_id"], {})
                                            end)
                                            if not p then
                                                print("[Host Auto Config] Error:", c)
                                            end
                                        else
                                            -- มีคนกด want_carry - รอรับ member
                                            Waiting_Time = os.time() + 150
                                            print("[Host] มีคน want_carry - รอรับ member")
                                            print("Add Time To Waiting Time")
                                        end
                                    else
                                        Waiting_Time = os.time() + 150
                                        print("Add Time To Waiting Time - No host data")
                                    end
                                else
                                    Waiting_Time = os.time() + 150
                                    print("Add Time To Waiting Time - API disabled")
                                end
                            else
                                print(#Current_Party)
                                if os.time() > Waiting_Time then
                                    if All_Players_Activated() and All_Players_Game() then
                                        local Product = nil
                                        local lowest = math.huge
                                        for i,v in pairs(cache["party_member"]) do
                                            if v["join_time"] < lowest then
                                                Product = v["product_id"]
                                                lowest = v["join_time"]
                                            end
                                        end
                                        print("[Host] All members activated and in game - starting room with product:", Product)
                                        local p,c = pcall(function()
                                            Register_Room(Product,Current_Party)
                                        end)
                                        if not p then
                                            print("[Host] Register_Room Error:", c)
                                        end
                                    else
                                        print("Waiting for members - Activated:", All_Players_Activated(), "InGame:", All_Players_Game())
                                    end
                                else
                                    print("Waiting...",Waiting_Time - os.time())
                                end
                            end
                        end
                    else
                        SendCache(
                                {
                                    ["index"] = Username
                                },
                                {
                                    ["value"] = {
                                        ["last_online"] = os.time() + 400,
                                        ["current_play"] = "",
                                        ["party_member"] = {},
                                }
                            }
                        )
                        task.wait(5)
                    end
                end
            end)
        else
            task.spawn(function()
                task.wait(math.random(5,10))
                local data = Fetch_data() 
                if not data or not data["want_carry"] then print("No Data") return false end
                local productid = data["product_id"]
                local orderid = data["id"]
                local cache_key = orderid .. "_cache_1"
                
                local cache_1 = {}
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                --[[
                    Secret Key Example
                    "orderid_cache_1"
                ]]
                local AttemptToAlready = 0
                Networking.Invites.InviteBannerEvent.OnClientEvent:Connect(function(type_,value_)
                    print(cache_1["party"],value_["InvitedBy"])
                    if type_ == "Create" and tostring(value_["InvitedBy"]) == cache_1["party"] then
                        print("Accept") task.wait(1)
                        Networking:WaitForChild("Invites"):WaitForChild("InviteEvent"):FireServer(
                            "AcceptInvite",
                            value_["GUID"]
                        )
                    end
                end)
                Networking.Portals.PortalReplicationEvent.OnClientEvent:Connect(function(index,value)
                    print(cache_1["party"],value["Owner"])
                    if index == "Replicate" and tostring(value["Owner"]) == cache_1["party"] then
                        task.wait(1)
                        Networking:WaitForChild("Portals"):WaitForChild("PortalEvent"):FireServer(
                            "JoinPortal",
                            value["GUID"]
                        )
                    end
                end)
                _G.Leave_Party = function()
                    local cache_ = GetCache(cache_key)
                    if cache_ then
                        while #cache_["party"] > 3 do 
                            SendCache(
                                {
                                    ["index"] = cache_["party"] .. "-message-2"
                                },
                                {
                                    ["value"] = {
                                        ["order"] = orderid .. "_cache",
                                        ["message-id"] = HttpService:GenerateGUID(false),
                                        ["join"] = os.time() + 10,
                                    },
                                }
                            )
                            task.wait(3)
                            cache_ = GetCache(cache_key)
                        end
                    end
                end
                while true do task.wait(1)
                    local cache = GetCache(cache_key)
                    if not cache then
                        SendCache(
                            {
                                ["index"] = cache_key
                            },
                            {
                                ["value"] = {
                                    ["name"] = Username,
                                    ["product_id"] = productid,
                                    ["party"] = "",
                            }
                        }
                    )
                    else
                        cache_1 = table.clone(cache)
                        if #cache["party"] > 1 then
                            local party = GetCache(cache["party"])
                            if not party then
                                UpdateCache(cache_key,{["party"] = ""})
                                warn("Not Found Party")
                                task.wait(2)
                            elseif not party["party_member"] or not party["party_member"][cache_key] then
                                UpdateCache(cache_key,{["party"] = ""})
                                warn("Not Found My Name In Party")
                                task.wait(2)
                            elseif os.time() > party["last_online"] then
                                UpdateCache(cache_key,{["party"] = ""})
                                warn("Not Active")
                                task.wait(2)
                            else
                                if Players:FindFirstChild(cache["party"]) then
                                    channel:SendAsync(math.random(1,100)) 
                                    warn("Host is Online!!")
                                else
                                    -- Host ไม่อยู่ในเกมเดียวกัน - reset party และหา Host ใหม่
                                    warn("Host is Offline - resetting party to find new host")
                                    UpdateCache(cache_key, {["party"] = ""})
                                end
                                task.wait(3)
                            end
                        else
                            warn("Find Party")
                            for i, v in pairs(DecBody(GetKai)) do
                                local kai_cache = GetCache(v["username"])
                                if kai_cache then
                                    if os.time() > kai_cache["last_online"] then
                                        print("Skip Time")
                                        continue;
                                    end
                                    if LenT(kai_cache["party_member"]) >= 3 then
                                         print("Full Party")
                                        continue;
                                    end
                                    local kaiproduct = kai_cache["current_play"]
                                    -- เช็ค Order Type ถ้า Host มี current_play
                                    if kaiproduct and #kaiproduct > 10 then
                                        local Product_Type_1,Product_Type_2 = nil,nil
                                        for i,v in pairs(Order_Type) do
                                            if table.find(v,kaiproduct) then
                                                Product_Type_1 = i
                                            end
                                            if table.find(v,productid) then
                                                Product_Type_2 = i
                                            end
                                        end
                                        print(Product_Type_1,Product_Type_2)
                                        if Product_Type_1 ~= Product_Type_2 then
                                            continue;
                                        end
                                    end
                                    -- ส่ง request ไป Host ได้เลย (ทั้งใน lobby และในด่าน)
                                    print("[Member] Sending request to Host:", v["username"])
                                    SendCache(
                                        {
                                            ["index"] = v["username"] .. "-message"
                                        },
                                        {
                                            ["value"] = {
                                                ["order"] = cache_key,
                                                ["message-id"] = HttpService:GenerateGUID(false),
                                                ["join"] = os.time() + 60, -- เพิ่มเวลาให้ Host มีเวลารับ request
                                            },
                                        }
                                    )
                                    AttemptToAlready = 0
                                    break -- ส่งแค่ Host คนเดียวแล้ว break
                                end
                            end
                            GetKai = Get(Api .. MainSettings["Path_Kai"])
                            AttemptToAlready = AttemptToAlready + 1
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    else
        print("MEOWWWW")
        if IsKai then
            -- สร้าง/อัพเดท cache สำหรับ Host ในด่าน (ถ้ายังไม่มี)
            local cache = GetCache(Username)
            if not cache then
                print("[Host In Stage] Creating cache...")
                SendCache(
                    {
                        ["index"] = Username
                    },
                    {
                        ["value"] = {
                            ["last_online"] = os.time() + 400,
                            ["current_play"] = "",
                            ["party_member"] = {},
                        }
                    }
                )
                task.wait(2)
                cache = GetCache(Username)
            end
            if cache then
                print("[Host In Stage] Cache exists, current_play:", cache["current_play"])
                if Changes[cache["current_play"]] then
                    Changes[cache["current_play"]]()
                    print("Configs has Changed ",cache["current_play"])
                end
            end
            local Last_Message_1 = nil
            local Last_Message_2 = nil
            -- Auto Accept Party + เช็ค member request และออกด่านมาสร้างตี้
            task.spawn(function()
                print("[Host In Stage] Starting message check loop...")
                 while true do task.wait(3)
                    local cache = GetCache(Username)
                    print("[Host In Stage] Loop running - cache:", cache and "exists" or "nil")
                    if not cache then
                        print("[Host In Stage] No cache, skipping...")
                        continue
                    end
                    -- Accept 
                    local message = GetCache(Username .. "-message")
                    print("[Host In Stage] Checking message:", message and "found" or "nil", "Last:", Last_Message_1)
                    if message then
                        print("[Host In Stage] Message details - id:", message["message-id"], "join:", message["join"], "now:", os.time())
                    end
                    if message and Last_Message_1 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                        print("[Host In Stage] Member request received:", message)
                            -- รับ member เข้า party ก่อน
                            local old_party = table.clone(cache["party_member"])
                            if LenT(old_party) < 3 then
                                local success = true
                                local path = nil
                                local lowest = math.huge
                                for i,v in pairs(cache["party_member"]) do
                                    if v["join_time"] < lowest then
                                        path = v["product_id"]
                                        lowest = v["join_time"]
                                    end
                                end
                                if path then
                                    local Product_Type_1,Product_Type_2 = nil,nil
                                    for i,v in pairs(Order_Type) do
                                        if table.find(v,path) then
                                            Product_Type_1 = i
                                        end
                                        if table.find(v,cache["current_play"]) then
                                            Product_Type_2 = i
                                        end
                                    end
                                    print(Product_Type_1,Product_Type_2,cache["current_play"])
                                    if Product_Type_1 == Product_Type_2 then
                                        local cache = GetCache(message["order"])
                                        if cache then
                                            old_party[message["order"]] = {
                                                ["join_time"] = os.time(),
                                                ["product_id"] = cache["product_id"],
                                                ["name"] = cache["name"],
                                            } 
                                            UpdateCache(Username,{["party_member"] = old_party})
                                            UpdateCache(message["order"],{["party"] = Username})
                                        else
                                                print("Cannot Get Cache 1")
                                        end
                                    else
                                        print("Mismatch")
                                        task.wait(3)
                                        success = false
                                    end
                                else
                                    local cache = GetCache(message["order"])
                                    if cache then
                                        old_party[message["order"]] = {
                                            ["join_time"] = os.time(),
                                            ["product_id"] = cache["product_id"],
                                            ["name"] = cache["name"],
                                        } 
                                        UpdateCache(Username,{["party_member"] = old_party})
                                        UpdateCache(message["order"],{["party"] = Username})
                                        cache = GetCache(cache_key)
                                        path = nil
                                        lowest = math.huge
                                        for i,v in pairs(cache["party_member"]) do
                                            if v["join_time"] < lowest then
                                                path = v["product_id"]
                                                lowest = v["join_time"]
                                            end
                                        end
                                    else
                                        print("Cannot Get Cache 2")
                                    end
                                    print("No Product")
                                end
                                if path and success then
                                    UpdateCache(Username,{["current_play"] = path}) 
                                elseif not path then
                                    UpdateCache(Username,{["current_play"] = ""}) 
                                end
                                -- ออกด่านไปสร้างตี้ให้ member
                                if success then
                                    print("[Host In Stage] Member accepted! Leaving stage to create party...")
                                    task.wait(1)
                                    game:Shutdown()
                                end
                            end
                            Last_Message_1 = message["message-id"]
                            task.wait(3)
                        -- Remove
                        local message = GetCache(Username .. "-message-2")
                        if message and Last_Message_2 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                            local old_party = table.clone(cache["party_member"])
                            if old_party[message["order"]] then
                                old_party[message["order"]] = nil
                                UpdateCache(Username,{["party_member"] = old_party})
                                UpdateCache(message["order"],{["party"] = ""})
                                Current_Party = GetParty(cache)
                                local cache = GetCache(Username)
                                local path = nil
                                local lowest = math.huge
                                for i,v in pairs(cache["party_member"]) do
                                    if v["join_time"] < lowest then
                                        path = v["product_id"]
                                        lowest = v["join_time"]
                                    end
                                end
                                if path then
                                    UpdateCache(Username,{["current_play"] = path}) 
                                else
                                    UpdateCache(Username,{["current_play"] = ""}) 
                                end
                            end
                            Last_Message_2 = message["message-id"]
                            task.wait(3)
                        end
                    end
                end
            end)
            task.spawn(function()
                while task.wait(10) do
                    UpdateCache(Username,{["last_online"] = os.time() + 250})
                end
            end)
            
            -- Check If End Game And Not Found A Player
            Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                local cache = GetCache(Username)
                if #Players:GetChildren() ~= LenT(cache["party_member"]) + 1 then
                    print("Party Member Request")
                    task.wait(2)
                    -- game:shutdown()
                elseif Results['StageType'] == "Challenge" then
                    print("It's Challenge")
                    task.wait(2)
                    -- game:shutdown()
                elseif _G.CHALLENGE_CHECKCD() and Settings["Auto Join Challenge"] then
                    print("Challenge CD")
                    task.wait(2)
                    -- game:shutdown()
                elseif Settings["Auto Join Bounty"] and task.wait(.5) and _G.BOSS_BOUNTY() and plr.PlayerGui:FindFirstChild("EndScreen") then
                    print("Bounty")
                    task.wait(2)
                    print(plr.PlayerGui.EndScreen.Holder.Buttons:FindFirstChild("Bounty") , plr.PlayerGui.EndScreen.Holder.Buttons.Bounty["Visible"])
                    if plr.PlayerGui.EndScreen.Holder.Buttons:FindFirstChild("Bounty") and plr.PlayerGui.EndScreen.Holder.Buttons.Bounty["Visible"] then
                        print("Can play")
                    else
                        -- game:shutdown()
                    end
                end
            end)
            -- Check If No Player In Lobby 
            task.wait(30)
            local cache = GetCache(Username)
            if #Players:GetChildren() ~= LenT(cache["party_member"]) + 1 then
                -- game:shutdown()
            end
            task.spawn(function()
                while task.wait(1) do
                    if #Players:GetChildren() <= 1 then
                        -- game:shutdown()
                    end
                end
            end)
            print("EIEIEIEIEI",Settings["Auto Priority"] , Settings["Priority Multi"] and Settings["Priority Multi"]["Enabled"])
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
                else
                    
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
                local Characters = workspace:WaitForChild("Characters")

                local function ConnectToPrompt(c)
                    if not c:GetAttribute("connect_1") and c.Name ~= plr.Name then
                        -- เช็ค Prompt ที่มีอยู่แล้วทันที
                        local existingPrompt = c:FindFirstChild("CidStunPrompt")
                        if existingPrompt then
                            task.spawn(function()
                                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("HumanoidRootPart") then
                                    plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                                    task.wait(0.3)
                                    fireproximityprompt(existingPrompt)
                                    print("[Auto Stun]", c.Name, "(existing)")
                                end
                            end)
                        end
                        -- รอ Prompt ใหม่
                        c.ChildAdded:Connect(function(v)
                            if v.Name == "CidStunPrompt" then
                                task.spawn(function()
                                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("HumanoidRootPart") then
                                        plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                                        task.wait(0.3)
                                        fireproximityprompt(v)
                                        print("[Auto Stun]", c.Name)
                                    end
                                end)
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
                print("[Auto Stun] Executed (Host)")
            end
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
                pcall(function()
                    local InterfaceEvent = Networking:WaitForChild("InterfaceEvent")
                    InterfaceEvent.OnClientEvent:Connect(function(eventType, data)
                        if eventType == "Wave" and data and data.Waves then
                            currentWave = data.Waves
                            
                            if currentWave == 0 then
                                chosenModifiers = {}
                                lastChoice = nil
                            end
                            
                            if Settings["Restart Modifier"] and currentWave >= 1 then
                                if not HasChosenRequiredModifier() then
                                    print("[Auto Modifier Host] Required modifier not found, voting restart...")
                                    VoteRestart()
                                end
                            end
                        end
                    end)
                end)

                -- Main Loop
                task.spawn(function()
                    while task.wait(0.3) do
                        if isChoosing then continue end
                        
                        local availableModifiers = GetAvailableModifiers()
                        if #availableModifiers == 0 then 
                            lastChoice = nil
                            continue 
                        end
                        
                        local bestModifier = GetBestModifier(availableModifiers)
                        
                        if bestModifier and bestModifier ~= lastChoice then
                            isChoosing = true
                            print("[Auto Modifier Host] Choosing:", bestModifier)
                            ChooseModifier(bestModifier)
                            lastChoice = bestModifier
                            table.insert(chosenModifiers, bestModifier)
                            task.wait(0.5)
                            isChoosing = false
                        end
                    end
                end)
            end
        else
            
            local data = Fetch_data() 
            if not data["want_carry"] then return false end
            local orderid = data["id"]
            local cache_key = orderid .. "_cache_1"
            local cache = GetCache(cache_key)
            local host = cache["party"]
            local cache__ = GetCache(host)
            if Changes[cache__["current_play"]] then
                Changes[cache__["current_play"]]()
                print("Configs has Changed ",cache__["current_play"])
            end 
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
            print("EIEIEIEIEI",Settings["Auto Priority"] , Settings["Priority Multi"] and Settings["Priority Multi"]["Enabled"])
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
                local Characters = workspace:WaitForChild("Characters")

                local function ConnectToPrompt(c)
                    if not c:GetAttribute("connect_1") and c.Name ~= plr.Name then
                        -- เช็ค Prompt ที่มีอยู่แล้วทันที
                        local existingPrompt = c:FindFirstChild("CidStunPrompt")
                        if existingPrompt then
                            task.spawn(function()
                                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("HumanoidRootPart") then
                                    plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                                    task.wait(0.3)
                                    fireproximityprompt(existingPrompt)
                                    print("[Auto Stun]", c.Name, "(existing)")
                                end
                            end)
                        end
                        -- รอ Prompt ใหม่
                        c.ChildAdded:Connect(function(v)
                            if v.Name == "CidStunPrompt" then
                                task.spawn(function()
                                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("HumanoidRootPart") then
                                        plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                                        task.wait(0.3)
                                        fireproximityprompt(v)
                                        print("[Auto Stun]", c.Name)
                                    end
                                end)
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
                print("[Auto Stun] Executed (Member)")
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
        end
    end
end