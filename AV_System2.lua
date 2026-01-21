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
    ["Fall Portal"] = {
        "e206ec24-dfbf-4157-a380-9afabe115c29",
        "c62223a2-17f9-4078-bbc0-bb45c484558f",
        "d92fceaa-8d18-4dc9-980f-452db4573ad9",
    },
    ["Fall Inf"] = {
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
    ["Rift"] = {
        "a551241f-b981-4b84-8b61-ce5ac449b9f0",
        "7d2c7a5f-81c8-4bc2-9ceb-2015ac73f103",
        "878aba1c-4163-43a6-9f6d-ef8827f6b582",
        "73bcfb57-5d0f-499b-bd6c-3e601ef9917c",
    },
    ["World Destroyer"] = {
        "36846b45-8b1c-46a8-9edc-7e5ae2a32d05",
        "8fedc8ce-3263-4821-b3d0-e4162a532588",
    },
    ["Pink Villain"] = {
        "98744617-780b-4c3f-adea-12f450e0b33c",
        "415f5afe-810d-4a42-aed9-5c29995f2e31",
        "dbda7a23-f9ac-487f-9a8d-beeebfba0475",
        "16cb01f5-7b68-47ed-b116-c63d5f453e1a",
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
    ["Auto Next"] = false,
    ["Auto Retry"] = false,
    ["Auto Back Lobby"] = false,
    ["Auto Join Rift"] = false,
    ["Auto Join Bounty"] = false,
    ["Auto Join Boss Event"] = false,
    ["Auto Join Challenge"] = false,
    ["Auto Join World Destroyer"] = false,

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
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
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
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
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
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
        }
    end,
    ["36846b45-8b1c-46a8-9edc-7e5ae2a32d05"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
        }
    end,
    ["8fedc8ce-3263-4821-b3d0-e4162a532588"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
        }
    end,
    ["87b27182-43d5-4266-9705-86ffa192adb0"] = function()
        Settings["Auto Join World Destroyer"] = true
        Settings["Auto Retry"] = true
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
        }
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
            ["Stage"] = "Planet Namak",
            ["FriendsOnly"] = false
        }
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
        }
    end,
    ["68cd687d-0760-4550-a7d6-482f3c2ca9df"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Auto Retry"] = true
        Settings["Story Settings"] = {
            ["Difficulty"] = "Nightmare",
            ["Act"] = "Infinite",
            ["StageType"] = "Story",
            ["Stage"] = "Planet Namak",
            ["FriendsOnly"] = false
        }
        Settings["Auto Restart"] = {
            ["Enable"] = true,
            ["Wave"] = 20, 
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

-- Helper function สำหรับเช็คไอเทม Temporal Rift (ใช้ได้ทั้ง host และ member)
local function GetTemporalRiftItem()
    local items = {}
    local success, err = pcall(function()
        -- หา OwnedItemsHandler โดยตรง
        local OwnedItemsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedItemsHandler", true)
        if OwnedItemsHandler then
            local inventoryItems = require(OwnedItemsHandler).GetItems()
            for i, v in pairs(inventoryItems) do
                if v["ID"] == 172 then -- 393 = Temporal Rift ID
                    items[i] = v
                    print("[GetTemporalRiftItem] Found item:", i, "Amount:", v["Amount"])
                end
            end
        else
            warn("[GetTemporalRiftItem] OwnedItemsHandler not found")
        end
    end)
    if not success then
        warn("[GetTemporalRiftItem] Error:", err)
    end
    return items
end

local function HasTemporalRiftItem()
    local items = GetTemporalRiftItem()
    for itemGUID, itemData in pairs(items or {}) do
        if itemData and itemData["Amount"] and itemData["Amount"] > 0 then
            return true, itemData["Amount"], itemGUID
        end
    end
    return false, 0, nil
end

-- Function สำหรับใช้ไอเทม Temporal Rift อย่างถูกต้อง
local function UseTemporalRiftItem(stage)
    stage = stage or "Warlord"
    local hasRift, amount, itemGUID = HasTemporalRiftItem()
    
    if not hasRift or not itemGUID then
        warn("[UseTemporalRiftItem] No Temporal Rift item found")
        return false
    end
    
    print("[UseTemporalRiftItem] Using item GUID:", itemGUID, "for stage:", stage, "Amount:", amount)
    
    local Networking = game:GetService("ReplicatedStorage"):WaitForChild("Networking")
    local success = true
    
    -- Step 1: เรียก ItemUseEvent ก่อน (บอก server ว่าจะใช้ไอเทม)
    pcall(function()
        local ItemUseEvent = Networking:FindFirstChild("ItemUseEvent")
        if ItemUseEvent then
            ItemUseEvent:FireServer("Use", itemGUID)
            print("[UseTemporalRiftItem] ItemUseEvent fired")
        end
    end)
    
    task.wait(0.5) -- รอให้ server process
    
    -- Step 2: เรียก TemporalRiftEvent เพื่อเปิด Rift
    pcall(function()
        local TemporalRiftEvent = Networking:FindFirstChild("TemporalRiftEvent")
        if TemporalRiftEvent then
            TemporalRiftEvent:FireServer("Activate", {
                ["StageType"] = "Rift",
                ["Stage"] = stage
            })
            print("[UseTemporalRiftItem] TemporalRiftEvent fired for", stage)
        else
            warn("[UseTemporalRiftItem] TemporalRiftEvent not found")
            success = false
        end
    end)
    
    return success
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
        
        -- Function ดึง MaxPlayers จากด่าน (auto จากเกม)
        local function GetMaxPlayersFromStage(stageType, stage, act)
            local maxPlayers = 3 -- default
            local success, result = pcall(function()
                local StagesDataModule = require(game:GetService("ReplicatedStorage").Modules.Data.StagesData)
                if StagesDataModule and StagesDataModule.GetActData then
                    local actData = StagesDataModule:GetActData(stageType, stage, act)
                    if actData and actData.MaxPlayers then
                        return actData.MaxPlayers
                    end
                end
                -- Fallback: ลองดูจาก StagesData table โดยตรง
                if StagesDataModule and StagesDataModule[stageType] then
                    local stageData = StagesDataModule[stageType][stage]
                    if stageData and stageData.Acts and stageData.Acts[act] then
                        local actInfo = stageData.Acts[act]
                        if actInfo.MaxPlayers then
                            return actInfo.MaxPlayers
                        end
                    end
                end
                return nil
            end)
            
            if success and result then
                maxPlayers = result
            end
            
            print("[GetMaxPlayersFromStage]", stageType, stage, act, "-> MaxPlayers:", maxPlayers)
            return maxPlayers
        end
        
        -- Function รอให้ members เข้าห้องก่อนเริ่ม (เรียกก่อน StartMatch)
        local function WaitForMembersReady(membersList)
            if membersList and #membersList > 0 then
                print("[WaitForMembersReady] Waiting for", #membersList, "members to join lobby...")
                local maxWait = 60 -- รอสูงสุด 60 วินาที
                local waitStart = os.time()
                
                -- Function เช็ค Players จาก MiniLobbyInterface (แม่นยำ 100%)
                local function GetPlayersInMiniLobby()
                    local success, result = pcall(function()
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 5)
                        if not PlayerGui then return nil end
                        
                        local MiniLobby = PlayerGui:FindFirstChild("MiniLobbyInterface")
                        if MiniLobby then
                            local Holder = MiniLobby:FindFirstChild("Holder")
                            if Holder then
                                local PlayersSection = Holder:FindFirstChild("Players")
                                if PlayersSection then
                                    local List = PlayersSection:FindFirstChild("List")
                                    if List then
                                        local players = {}
                                        for _, frame in pairs(List:GetChildren()) do
                                            -- PlayerFrame มี Name = UserId
                                            if frame:IsA("Frame") and tonumber(frame.Name) then
                                                -- หา Username จาก UserId
                                                local userId = tonumber(frame.Name)
                                                local player = Players:GetPlayerByUserId(userId)
                                                if player then
                                                    table.insert(players, player.Name)
                                                end
                                            end
                                        end
                                        return players
                                    end
                                end
                            end
                        end
                        return nil
                    end)
                    
                    if success and result then
                        return result
                    end
                    return nil
                end
                
                while (os.time() - waitStart) < maxWait do
                    -- วิธีหลัก: เช็คจาก MiniLobbyInterface (แม่นยำ 100%)
                    local lobbyPlayers = GetPlayersInMiniLobby()
                    
                    if lobbyPlayers then
                        print("[WaitForMembersReady] MiniLobbyInterface players:", table.concat(lobbyPlayers, ", "))
                        
                        -- นับ members ที่อยู่ใน lobby
                        local membersInLobby = 0
                        for _, memberName in ipairs(membersList) do
                            for _, lobbyPlayer in ipairs(lobbyPlayers) do
                                if lobbyPlayer == memberName then
                                    membersInLobby = membersInLobby + 1
                                    break
                                end
                            end
                        end
                        
                        print("[WaitForMembersReady] Members in lobby:", membersInLobby, "/", #membersList)
                        
                        if membersInLobby >= #membersList then
                            print("[WaitForMembersReady] All", #membersList, "members in MiniLobby! Starting...")
                            task.wait(2) -- รอเพิ่มอีก 2 วินาทีก่อนเริ่ม
                            return true
                        end
                    else
                        -- MiniLobbyInterface ยังไม่เปิด - รอต่อ
                        print("[WaitForMembersReady] MiniLobbyInterface not found, waiting...")
                    end
                    
                    task.wait(3)
                end
                
                -- Timeout - เช็คว่ามี member อยู่ในเกมบ้างไหม
                local membersInGame = 0
                for _, memberName in ipairs(membersList) do
                    if Players:FindFirstChild(memberName) then
                        membersInGame = membersInGame + 1
                    end
                end
                
                if membersInGame >= #membersList then
                    print("[WaitForMembersReady] Timeout but all members in game! Starting...")
                    task.wait(2)
                    return true
                else
                    print("[WaitForMembersReady] Timeout! Only", membersInGame, "/", #membersList, "members - Starting anyway...")
                    return false
                end
            end
            return true -- ไม่มี member ก็เริ่มเลย
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
                            WaitForMembersReady(player)
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
                        WaitForMembersReady(player)
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
        if Settings["Auto Join Rift"] then
            task.spawn(function()
                local hasUsedItem = false
                local lastItemUseTime = 0
                
                while true do
                    if workspace:GetAttribute("IsRiftOpen") then
                        local Rift = require(game:GetService("StarterPlayer").Modules.Gameplay.Rifts.RiftsDataHandler)
                        local GUID = nil
                        for i,v in pairs(Rift.GetRifts()) do
                            if v and not v["Teleporting"] then
                                GUID = v["GUID"]
                                print("[Host Auto Join Rift] Selected rift:", GUID)
                                break
                            end
                        end
                        
                        if GUID then
                            -- เช็คว่ามี rift_join_time ที่ตั้งโดย member หรือไม่
                            local joinTime = nil
                            if player and #player > 0 then
                                for _, memberName in ipairs(player) do
                                    local memberCache = GetCache(memberName)
                                    if memberCache and memberCache["rift_join_time"] then
                                        joinTime = memberCache["rift_join_time"]
                                        print("[Host Auto Join Rift] Found shared join time from member:", joinTime)
                                        break
                                    end
                                end
                            end
                            
                            -- ถ้ามี join time ร่วมกัน ให้รอจนกว่าจะถึงเวลา
                            if joinTime and os.time() < joinTime then
                                print("[Host Auto Join Rift] Waiting for synchronized entry with member...")
                                while os.time() < joinTime do
                                    local timeLeft = joinTime - os.time()
                                    print("[Host Auto Join Rift] Countdown:", timeLeft, "seconds")
                                    task.wait(1)
                                end
                                print("[Host Auto Join Rift] Time's up! Entering together with Member...")
                            end
                            
                            print("[Host Auto Join Rift] Joining rift:", GUID)
                            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                                "Join",
                                GUID
                            )
                            
                            -- ลบ rift_join_time ออกจาก cache หลังเข้าแล้ว
                            if player and #player > 0 then
                                for _, memberName in ipairs(player) do
                                    local memberCache = GetCache(memberName)
                                    if memberCache and memberCache["rift_join_time"] then
                                        UpdateCache(memberName, {["rift_join_time"] = nil})
                                    end
                                end
                            end
                            
                            hasUsedItem = false -- รีเซ็ตเมื่อเข้า Rift สำเร็จ
                            task.wait(5)
                        else
                            task.wait(3)
                        end
                    else
                        -- ไม่มี Rift เปิดอยู่
                        -- เช็คว่ามี member เปิด Rift ไว้แล้วหรือไม่ (รอสักครู่แล้วเช็คอีกครั้ง)
                        task.wait(2)
                        
                        -- เช็คอีกครั้งหลังรอ - ถ้ามี Rift เปิดแล้ว = member เปิดไว้ ข้ามการใช้ไอเทม
                        if workspace:GetAttribute("IsRiftOpen") then
                            print("[Host Auto Join Rift] Rift already opened (by member) - skipping item use")
                        else
                            -- ยังไม่มี Rift → Host ใช้ไอเทม Temporal Rift
                            if not hasUsedItem or (os.time() - lastItemUseTime) > 30 then
                                local hasRift, amount = HasTemporalRiftItem()
                                
                                if hasRift then
                                    print("[Host Auto Join Rift] Using Temporal Rift item (", amount, "remaining)")
                                    
                                    local success = UseTemporalRiftItem("Warlord")
                                    if success then
                                        print("[Host Auto Join Rift] Temporal Rift activated for Warlord")
                                        hasUsedItem = true
                                        lastItemUseTime = os.time()
                                    else
                                        warn("[Host Auto Join Rift] Failed to use Temporal Rift")
                                    end
                                    
                                    task.wait(3) -- รอให้ Rift เปิด
                                else
                                    warn("[Host Auto Join Rift] No Temporal Rift item found")
                                    task.wait(5) -- รอนานขึ้นถ้าไม่มีไอเทม
                                end
                            end
                        end
                        task.wait(2)
                    end
                end
            end)
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
            WaitForMembersReady(player)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
        elseif Settings["Select Mode"] == "Summer" then
            game:GetService("ReplicatedStorage").Networking.Summer.SummerLTMEvent:FireServer("Create")
            task.wait(2)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    print(i,v)
                    Invite(v)
                end 
            end 
            WaitForMembersReady(player)
            local args = {
                [1] = "StartMatch"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
        elseif Settings["Select Mode"] == "Fall Regular" then
            game:GetService("ReplicatedStorage").Networking.Fall.FallLTMEvent:FireServer("Create")
            task.wait(2)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    Invite(v)
                end 
            end 
            WaitForMembersReady(player)
            local args = {
                [1] = "StartMatch"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("LobbyEvent"):FireServer(unpack(args))
        elseif Settings["Select Mode"] == "Fall Infinite" then
            game:GetService("ReplicatedStorage").Networking.Fall.FallLTMEvent:FireServer("Create","Infinite")
            task.wait(2)
            for i = 1,2 do 
                for i,v in pairs(player) do task.wait(2.5)
                    Invite(v)
                end 
            end 
            WaitForMembersReady(player)
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
                WaitForMembersReady(player)
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
                WaitForMembersReady(player)
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
            WaitForMembersReady(player)
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
            WaitForMembersReady(player)
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
            WaitForMembersReady(player)
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
                    local CParty = cache["party_member"] and table.clone(cache["party_member"]) or {}
                    local Insert = {}
                    for i,v in pairs(CParty) do
                        if v and v["name"] then
                            table.insert(Insert, v["name"])
                        end
                    end
                    return Insert
                end
                
                -- Cache สำหรับเก็บ MaxPlayers ที่ดึงมาแล้ว (ไม่ต้องดึงซ้ำ)
                local MaxPlayersCache = {}
                local StagesDataModule = nil
                
                -- โหลด StagesData ครั้งเดียวตอนเริ่ม (ไม่ block main loop)
                task.spawn(function()
                    pcall(function()
                        StagesDataModule = require(game:GetService("ReplicatedStorage").Modules.Data.StagesData)
                        print("[MaxPlayers] StagesData loaded successfully")
                    end)
                end)
                
                -- Function ดึง MaxPlayers จาก StagesData โดยอัตโนมัติ
                function GetMaxPlayersForProduct(product_id)
                    if not product_id then return 3 end -- default
                    
                    -- เช็ค cache ก่อน
                    if MaxPlayersCache[product_id] then
                        return MaxPlayersCache[product_id]
                    end
                    
                    -- หา Order_Type จาก product_id
                    local orderType = nil
                    for orderName, orderIds in pairs(Order_Type) do
                        if table.find(orderIds, product_id) then
                            orderType = orderName
                            break
                        end
                    end
                    
                    -- Default values ตาม mode (fallback)
                    local defaultMap = {
                        ["Story"] = 4,
                        ["Legend Stage"] = 4,
                        ["Dungeon"] = 4,
                        ["Raid"] = 4,
                        ["Rift"] = 6,
                        ["Portal"] = 4,
                        ["Odyssey"] = 4,
                        ["Summer"] = 4,
                        ["Fall Regular"] = 4,
                        ["Fall Infinite"] = 4,
                        ["Challenge"] = 4,
                        ["Bounty"] = 4,
                        ["Boss Event"] = 4,
                        ["World Destroyer"] = 4,
                    }
                    
                    local maxPlayers = defaultMap[orderType] or 4
                    
                    -- ลองดึงจาก StagesData ถ้าโหลดเสร็จแล้ว (ไม่ block ถ้ายังไม่เสร็จ)
                    if StagesDataModule then
                        local success, result = pcall(function()
                            -- แปลง orderType เป็น StageType
                            local stageTypeMap = {
                                ["Story"] = "Story",
                                ["Legend Stage"] = "LegendStage", 
                                ["Dungeon"] = "Dungeon",
                                ["Raid"] = "Raid",
                                ["Rift"] = "Rift",
                                ["Portal"] = "Story",
                                ["Odyssey"] = "Odyssey",
                                ["Summer"] = "Summer",
                                ["Fall Regular"] = "Fall",
                                ["Fall Infinite"] = "Fall",
                                ["Challenge"] = "Story",
                                ["Bounty"] = "Story",
                            }
                            
                            local stageType = stageTypeMap[orderType] or "Story"
                            
                            -- ดึงจาก StagesData
                            if StagesDataModule[stageType] then
                                for _, stageData in pairs(StagesDataModule[stageType]) do
                                    if stageData and stageData.Acts then
                                        for _, actData in pairs(stageData.Acts) do
                                            if actData and actData.MaxPlayers then
                                                return actData.MaxPlayers
                                            end
                                        end
                                    end
                                end
                            end
                            return nil
                        end)
                        
                        if success and result then
                            maxPlayers = result
                        end
                    end
                    
                    -- MaxPlayers = รวม Host แล้ว ดังนั้น member ที่รับได้ = MaxPlayers - 1
                    local maxMembers = maxPlayers - 1
                    
                    -- Cache ผลลัพธ์
                    MaxPlayersCache[product_id] = maxMembers
                    
                    print("[GetMaxPlayersForProduct] Product:", product_id, "-> OrderType:", orderType, "-> MaxPlayers:", maxPlayers, "-> MaxMembers:", maxMembers)
                    return maxMembers
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
                            -- เช็คว่ามี party_member อยู่หรือไม่
                            if cache["party_member"] and LenT(cache["party_member"]) > 0 then
                                -- เช็คว่า member ที่ค้างอยู่ยังมี cache อยู่หรือไม่
                                local active_members = {}
                                local has_active_member = false
                                
                                for member_name, _ in pairs(cache["party_member"]) do
                                    local member_cache = GetCache(member_name)
                                    if member_cache and member_cache["last_online"] and os.time() <= member_cache["last_online"] then
                                        -- Member ยังมี cache และยังไม่หมดอายุ
                                        active_members[member_name] = true
                                        has_active_member = true
                                        print("[Host] Member", member_name, "still active")
                                    else
                                        -- Member หมดอายุหรือไม่มี cache แล้ว
                                        print("[Host] Member", member_name, "is offline - removing from party")
                                    end
                                end
                                
                                if has_active_member then
                                    -- มี member ที่ยังอยู่จริงๆ → extend last_online และอัพเดท party_member
                                    UpdateCache(Username, {
                                        ["last_online"] = os.time() + 200,
                                        ["party_member"] = active_members
                                    })
                                    print("[Host] Has active members - extending last_online")
                                else
                                    -- ไม่มี member ที่ active → ลบ cache
                                    DelCache(Username)
                                    print("[Host] No active members - Delete Cache")
                                end
                            else
                                -- ไม่มี party_member → ลบ cache
                                DelCache(Username)
                                print("[Host] No party members - Delete Cache")
                            end
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
                                print("[Host Lobby] New request from:", message["order"])
                                local member_cache = GetCache(message["order"])
                                if not member_cache or not member_cache["product_id"] then
                                    print("[Host Lobby] Cannot get member cache - rejecting")
                                    SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                else
                                    local old_party = cache["party_member"] and table.clone(cache["party_member"]) or {}
                                    
                                    -- เช็คว่า member นี้อยู่ใน party แล้วหรือยัง (ป้องกันซ้ำ)
                                    if old_party[message["order"]] then
                                        print("[Host Lobby] Member already in party - skipping:", message["order"])
                                        SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                    else
                                        -- ดึง MaxPlayers ตาม product_id (auto detect จาก mode)
                                        local maxMembers = GetMaxPlayersForProduct(member_cache["product_id"])
                                        
                                        -- เช็คว่า party เต็มหรือไม่
                                        if LenT(old_party) >= maxMembers then
                                            print("[Host Lobby] Party full (", LenT(old_party), "/", maxMembers, ") - rejecting")
                                            SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                        elseif LenT(old_party) == 0 then
                                            -- Party ว่าง - รับ member คนแรกได้เลย (ไม่ต้องเช็ค order_type)
                                            print("[Host Lobby] Party empty - Accepting first member:", member_cache["name"])
                                            old_party[message["order"]] = {
                                                ["join_time"] = os.time(),
                                                ["product_id"] = member_cache["product_id"],
                                                ["name"] = member_cache["name"],
                                            }
                                            UpdateCache(Username, {["party_member"] = old_party})
                                            UpdateCache(message["order"], {["party"] = Username, ["pending_host"] = ""})
                                            UpdateCache(Username, {["current_play"] = member_cache["product_id"]})
                                            Waiting_Time = os.time() + 180
                                            print("[Host Lobby] Member accepted - current_play set to:", member_cache["product_id"])
                                        else
                                            -- มี member อยู่แล้ว - เช็ค order_type กับ member คนแรก
                                            print("[Host Lobby] Party has members:", LenT(old_party), "- checking order_type")
                                            local first_member_product_id = nil
                                            local lowest = math.huge
                                            for i,v in pairs(old_party) do
                                                if v["join_time"] < lowest then
                                                    first_member_product_id = v["product_id"]
                                                    lowest = v["join_time"]
                                                end
                                            end
                                            
                                            print("[Host Lobby] First member product_id:", first_member_product_id)
                                            print("[Host Lobby] New member product_id:", member_cache["product_id"])
                                            
                                            -- หา order_type ของ member ใหม่และ member คนแรก
                                            local Type_NewMember, Type_FirstMember = nil, nil
                                            for orderName, orderIds in pairs(Order_Type) do
                                                if table.find(orderIds, member_cache["product_id"]) then
                                                    Type_NewMember = orderName
                                                end
                                                if table.find(orderIds, first_member_product_id) then
                                                    Type_FirstMember = orderName
                                                end
                                            end
                                            
                                            print("[Host Lobby] New member type:", Type_NewMember, "First member type:", Type_FirstMember)
                                            
                                            -- ถ้า product_id ต่างกัน และ (หา type ไม่เจอ หรือ type ไม่ตรงกัน) → reject
                                            local shouldReject = false
                                            if member_cache["product_id"] ~= first_member_product_id then
                                                -- product_id ต่างกัน - ต้องเช็ค order_type
                                                if not Type_NewMember or not Type_FirstMember then
                                                    -- หา order_type ไม่เจอ - reject เพราะไม่รู้ว่าตรงกันไหม
                                                    print("[Host Lobby] Cannot determine order_type - rejecting")
                                                    shouldReject = true
                                                elseif Type_NewMember ~= Type_FirstMember then
                                                    -- order_type ไม่ตรงกัน
                                                    print("[Host Lobby] Order type mismatch - rejecting")
                                                    shouldReject = true
                                                end
                                            end
                                        
                                            if shouldReject then
                                                -- Order type ไม่ตรง - reject และบอกให้ไปหา host ใหม่
                                                print("[Host Lobby] Order type mismatch - rejecting")
                                                SendCache(
                                                    {["index"] = message["order"] .. "-reject"},
                                                    {["value"] = {
                                                        ["rejected_by"] = Username,
                                                        ["reason"] = "Different Order_Type",
                                                        ["message-id"] = HttpService:GenerateGUID(false),
                                                        ["expire"] = os.time() + 30,
                                                    }}
                                                )
                                                SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                            else
                                                -- Order type ตรงกัน - รับเลย
                                                print("[Host Lobby] Order type match - accepting:", member_cache["name"])
                                                old_party[message["order"]] = {
                                                    ["join_time"] = os.time(),
                                                    ["product_id"] = member_cache["product_id"],
                                                    ["name"] = member_cache["name"],
                                                }
                                                UpdateCache(Username, {["party_member"] = old_party})
                                                UpdateCache(message["order"], {["party"] = Username, ["pending_host"] = ""})
                                                Waiting_Time = os.time() + 125
                                                print("[Host Lobby] Member accepted")
                                            end
                                        end
                                    end
                                end
                                Last_Message_1 = message["message-id"]
                                task.wait(3)
                            end
                            -- Remove
                            local message = GetCache(Username .. "-message-2")
                            if message and Last_Message_2 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                                local old_party = cache["party_member"] and table.clone(cache["party_member"]) or {}
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
                                            -- Set host_id (Host's own product) - ไม่ใช่ current_play เพราะนั่นสำหรับ party system
                                            UpdateCache(Username, {["host_id"] = hostData["product_id"]})
                                            
                                            -- เช็คว่าเป็น Rift หรือไม่
                                            local isRiftProduct = table.find(Order_Type["Rift"] or {}, hostData["product_id"]) ~= nil
                                            if isRiftProduct then
                                                -- Rift: ใช้ระบบ Auto Join Rift สำหรับทุก stage
                                                print("[Host Auto Config] RIFT order - enabling Auto Join Rift")
                                                Settings["Auto Join Rift"] = true
                                                -- ไม่ต้อง Register_Room เพราะ Auto Join Rift จะจัดการให้
                                            else
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
                                                    end
                                                    if SelectedStage then
                                                        if Settings["Story Settings"] then Settings["Story Settings"]["Stage"] = SelectedStage end
                                                        if Settings["Dungeon Settings"] then Settings["Dungeon Settings"]["Stage"] = SelectedStage end
                                                        if Settings["Legend Settings"] then Settings["Legend Settings"]["Stage"] = SelectedStage end
                                                        if Settings["Raid Settings"] then Settings["Raid Settings"]["Stage"] = SelectedStage end
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
                                    -- เช็คว่า member ทุกคนเข้าเกมและ active แล้วหรือยัง
                                    local allActivated = All_Players_Activated()
                                    local allInGame = All_Players_Game()
                                    
                                    if allActivated and allInGame then
                                        local Product = nil
                                        local lowest = math.huge
                                        for i,v in pairs(cache["party_member"]) do
                                            if v["join_time"] < lowest then
                                                Product = v["product_id"]
                                                lowest = v["join_time"]
                                            end
                                        end
                                        
                                        -- เช็คว่าเป็น Rift หรือไม่
                                        local isRiftProduct = table.find(Order_Type["Rift"] or {}, Product) ~= nil
                                        if isRiftProduct then
                                            -- Rift: เรียก Register_Room เพื่อเปิด Auto Join Rift loop
                                            print("[Host] RIFT order - starting Register_Room for Rift")
                                            local p,c = pcall(function()
                                                Register_Room(Product, Current_Party)
                                            end)
                                            if not p then
                                                print("[Host] Register_Room Error:", c)
                                            end
                                        else
                                            print("[Host] All members activated and in game - starting room with product:", Product)
                                            local p,c = pcall(function()
                                                Register_Room(Product,Current_Party)
                                            end)
                                            if not p then
                                                print("[Host] Register_Room Error:", c)
                                            end
                                        end
                                    else
                                        -- หมดเวลาแล้ว แต่ member ยังไม่พร้อม
                                        print("[Host] Timeout but members not ready - Activated:", allActivated, "InGame:", allInGame)
                                        
                                        -- เช็คแต่ละ member
                                        for i, memberName in pairs(Current_Party) do
                                            local inGame = game:GetService("Players"):FindFirstChild(memberName) ~= nil
                                            local activated = Counting[memberName] and os.time() <= Counting[memberName]
                                            print("[Host] Member", memberName, "- InGame:", inGame, "Activated:", activated)
                                        end
                                        
                                        -- ต่อเวลาอีก 30 วินาที
                                        Waiting_Time = os.time() + 30
                                        print("[Host] Extended waiting time by 30 seconds")
                                    end
                                else
                                    print("Waiting...",Waiting_Time - os.time())
                                end
                            end
                        end
                    else
                        -- ดึง host_id จาก API
                        local hostData = Fetch_data()
                        local hostProductId = hostData and hostData["product_id"] or ""
                        -- เช็คว่า host มี Temporal Rift item หรือไม่
                        local hostHasRiftItem = HasTemporalRiftItem()
                        SendCache(
                                {
                                    ["index"] = Username
                                },
                                {
                                    ["value"] = {
                                        ["last_online"] = os.time() + 400,
                                        ["host_id"] = hostProductId, -- Host's own product_id (ไม่เกี่ยวกับ party)
                                        ["current_play"] = "",       -- Party system (Member's product_id)
                                        ["party_member"] = {},
                                        ["has_rift_item"] = hostHasRiftItem, -- ให้ member รู้ว่า host มีไอเทม Rift หรือไม่
                                }
                            }
                        )
                        task.wait(5)
                    end
                end
            end)
        else
            task.spawn(function()
                -- รอให้เกมโหลดเสร็จก่อน
                print("[Member Loading] Waiting for game to load...")
                task.wait(math.random(10,15))
                print("[Member Loading] Game loaded, starting...")
                local data = Fetch_data() 
                if not data or not data["want_carry"] then print("No Data") return false end
                local productid = data["product_id"]
                local orderid = data["id"]
                local cache_key = orderid .. "_cache_1"
                
                -- เช็คว่าเป็น Rift order_type หรือไม่ → เปิด Auto Join Rift
                local isRiftOrder = table.find(Order_Type["Rift"] or {}, productid) ~= nil
                if isRiftOrder then
                    -- Rift: เปิด Auto Join Rift สำหรับทุก stage (รวม Warlord)
                    print("[Member] RIFT order - Will start Auto Join Rift after finding party")
                    
                    -- Member ต้องรอจนกว่าจะมี party และ host อยู่ในเกมก่อน
                    task.spawn(function()
                        local hasUsedItem = false
                        local lastItemUseTime = 0
                        local waitingForHostStartTime = 0
                        local checkedHostItem = false
                        local hostHasItem = nil -- nil = ยังไม่เช็ค, true = มี, false = ไม่มี
                        local riftLoopStarted = false
                        local WAIT_TIME = 180 -- รอ 60 วินาทีก่อนเข้า Rift พร้อม Host
                        local waitCompleted = false
                        
                        while true do
                            -- เช็คว่ามี party และ host อยู่ในเกมหรือยัง
                            local myCache = GetCache(cache_key)
                            local hasParty = myCache and myCache["party"] and #myCache["party"] > 1
                            local hostInGame = hasParty and game:GetService("Players"):FindFirstChild(myCache["party"])
                            
                            if not hasParty then
                                -- ยังไม่มี party = รอ (ไม่ทำอะไร)
                                if riftLoopStarted then
                                    print("[Member Auto Join Rift] Lost party - pausing...")
                                    riftLoopStarted = false
                                    hasUsedItem = false
                                    checkedHostItem = false
                                    hostHasItem = nil
                                    waitingForHostStartTime = 0
                                    waitCompleted = false
                                end
                                task.wait(3)
                            elseif not hostInGame then
                                -- มี party แต่ host ยังไม่อยู่ในเกม = รอ host มา
                                print("[Member Auto Join Rift] Waiting for host to join game...")
                                checkedHostItem = false
                                hostHasItem = nil
                                waitingForHostStartTime = 0
                                waitCompleted = false
                                task.wait(3)
                            else
                                -- มี party และ host อยู่ในเกมแล้ว
                                if not riftLoopStarted then
                                    print("[Member Auto Join Rift] Party found, host in game - Checking host item...")
                                    riftLoopStarted = true
                                end
                                
                                -- เช็คว่า Host มีไอเทมหรือไม่ (เช็คครั้งเดียว)
                                if not checkedHostItem then
                                    local hostCache = GetCache(myCache["party"])
                                    if hostCache then
                                        hostHasItem = hostCache["has_rift_item"] ~= false
                                        checkedHostItem = true
                                        print("[Member Auto Join Rift] Host has rift item:", hostHasItem)
                                        
                                        if hostHasItem then
                                            -- Host มีไอเทม → เริ่มนับเวลารอ
                                            waitingForHostStartTime = os.time()
                                            print("[Member Auto Join Rift] Host has item - Starting wait timer (", WAIT_TIME, "s)")
                                        else
                                            -- Host ไม่มีไอเทม → Member ต้องใช้เอง (ไม่ต้องรอ)
                                            print("[Member Auto Join Rift] Host has NO item - Member will use own item immediately")
                                            waitCompleted = true -- ข้ามการรอ
                                        end
                                    else
                                        task.wait(2)
                                    end
                                end
                                
                                -- ถ้ายังไม่ได้เช็ค Host item = รอ
                                if not checkedHostItem then
                                    task.wait(2)
                                else
                                    -- เช็คว่ารอครบเวลาหรือยัง (ถ้า Host มีไอเทม)
                                    if hostHasItem and not waitCompleted then
                                        local waitingTime = os.time() - waitingForHostStartTime
                                        if waitingTime < WAIT_TIME then
                                            -- ยังรอไม่ครบ = รอต่อ
                                            print("[Member Auto Join Rift] Waiting for host... (", waitingTime, "/", WAIT_TIME, "s)")
                                            task.wait(5)
                                        else
                                            -- รอครบแล้ว
                                            print("[Member Auto Join Rift] Wait completed! Ready to join with host")
                                            waitCompleted = true
                                        end
                                    end
                                    
                                    -- ถ้ารอครบแล้ว หรือ Host ไม่มีไอเทม = เริ่มทำงาน
                                    if waitCompleted then
                                        -- ไม่มี Rift เปิดอยู่ และ Host ไม่มีไอเทม → Member ใช้ไอเทมเปิดเอง
                                        if not workspace:GetAttribute("IsRiftOpen") and not hostHasItem then
                                            if not hasUsedItem or (os.time() - lastItemUseTime) > 60 then
                                                local hasRift, amount = HasTemporalRiftItem()
                                                
                                                if hasRift then
                                                    print("[Member Auto Join Rift] Using Temporal Rift item (", amount, "remaining)")
                                                    local success = UseTemporalRiftItem("Warlord")
                                                    if success then
                                                        print("[Member Auto Join Rift] Temporal Rift activated - Waiting for Host to return...")
                                                        hasUsedItem = true
                                                        lastItemUseTime = os.time()
                                                        
                                                        -- ตั้งเวลาเข้า Rift ร่วมกัน (5 วินาทีจากตอนนี้)
                                                        local joinTime = os.time() + 5
                                                        UpdateCache(LocalPlayer.Name, {["rift_join_time"] = joinTime})
                                                        print("[Member Auto Join Rift] Set shared join time:", joinTime)
                                                    else
                                                        warn("[Member Auto Join Rift] Failed to use Temporal Rift")
                                                    end
                                                    task.wait(3)
                                                else
                                                    warn("[Member Auto Join Rift] No Temporal Rift item found")
                                                    task.wait(10)
                                                end
                                            end
                                        -- มี Rift เปิดอยู่แล้ว → เช็คว่า Host กลับมาหรือยัง
                                        elseif workspace:GetAttribute("IsRiftOpen") then
                                            local myCache = GetCache(cache_key)
                                            local hostName = myCache and myCache["party"]
                                            local hostInGame = hostName and game:GetService("Players"):FindFirstChild(hostName)
                                            
                                            if hostInGame then
                                                -- Host กลับมาในเกมแล้ว → รอสักครู่แล้ว join ด้วยกัน
                                                print("[Member Auto Join Rift] Host is back! Waiting a moment before joining together...")
                                                task.wait(3) -- รอ Host เตรียมตัว
                                                
                                                local Rift = require(game:GetService("StarterPlayer").Modules.Gameplay.Rifts.RiftsDataHandler)
                                                local GUID = nil
                                                for i,v in pairs(Rift.GetRifts()) do
                                                    if v and not v["Teleporting"] then
                                                        GUID = v["GUID"]
                                                        print("[Member Auto Join Rift] Selected rift:", GUID)
                                                        break
                                                    end
                                                end
                                                
                                                if GUID then
                                                    print("[Member Auto Join Rift] Joining rift with Host:", GUID)
                                                    game:GetService("ReplicatedStorage"):WaitForChild("Networking"):WaitForChild("Rifts"):WaitForChild("RiftsEvent"):FireServer( 
                                                        "Join",
                                                        GUID
                                                    )
                                                    hasUsedItem = false
                                                    checkedHostItem = false
                                                    hostHasItem = nil
                                                    waitCompleted = false
                                                    waitingForHostStartTime = 0
                                                    task.wait(5)
                                                else
                                                    task.wait(3)
                                                end
                                            else
                                                -- Host ยังไม่กลับมา → รอต่อ
                                                print("[Member Auto Join Rift] Rift opened - Waiting for Host to return before joining...")
                                                task.wait(3)
                                            end
                                        else
                                            -- Host มีไอเทม → รอ Host เปิด Rift
                                            if hostHasItem then
                                                print("[Member Auto Join Rift] Waiting for host to open Rift...")
                                            end
                                            task.wait(3)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
                
                local cache_1 = {}
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                --[[
                    Secret Key Example
                    "orderid_cache_1"
                ]]
                local rejected_hosts = {} -- เก็บ list ของ host ที่ reject แล้ว จะไม่ส่ง request ซ้ำ
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
                print("[Member] Loop started, cache_key:", cache_key)
                while true do task.wait(1)
                    local cache = GetCache(cache_key)
                    if not cache then
                        print("[Member] Creating cache...")
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
                                -- Host offline - แต่ถ้ามีชื่อเราใน party_member แสดงว่า Host กำลังมารับ
                                if party["party_member"] and party["party_member"][cache_key] then
                                    -- เช็ค timeout - ถ้ารอนานเกิน 120 วินาที ให้รีเซ็ต party หา Host ใหม่
                                    local myJoinTime = party["party_member"][cache_key]["join_time"] or 0
                                    local waitingTime = os.time() - myJoinTime
                                    
                                    if waitingTime > 240 then
                                        -- รอนานเกินไป - รีเซ็ต party หา Host ใหม่
                                        warn("[Member] Timeout waiting for Host (" .. waitingTime .. "s) - finding new Host...")
                                        UpdateCache(cache_key, {["party"] = ""})
                                        task.wait(2)
                                    else
                                        -- ยังไม่ timeout - รอต่อ
                                        warn("Host offline but accepted - waiting for Host to come... (" .. waitingTime .. "s)")
                                        task.wait(5)
                                    end
                                else
                                    -- Host offline จริงๆ และไม่มีชื่อเรา - ลบ party
                                    UpdateCache(cache_key,{["party"] = ""})
                                    warn("Not Active")
                                    task.wait(2)
                                end
                            else
                                if Players:FindFirstChild(cache["party"]) then
                                    channel:SendAsync(math.random(1,100)) 
                                    warn("Host is Online!!")
                                    -- Set Party_Host สำหรับ Auto Join Rift
                                    _G.Party_Host = cache["party"]
                                    print("[Member] Set Party_Host:", _G.Party_Host)
                                    -- Rift: Portal จะถูก Join อัตโนมัติผ่าน PortalReplicationEvent listener ที่มีอยู่แล้ว
                                else
                                    -- Host ไม่อยู่ในเกมเดียวกัน - เช็คว่า Host ยังมีชื่อเราใน party_member หรือไม่
                                    -- ถ้ามีแสดงว่า Host กำลังออกมารับ ให้รอ
                                    if party["party_member"] and party["party_member"][cache_key] then
                                        task.wait(5)
                                    else
                                        -- เช็ค reject message ก่อน
                                        local rejectMsg = GetCache(cache_key .. "-reject")
                                        if rejectMsg and rejectMsg["expire"] and rejectMsg["expire"] >= os.time() then
                                            print("[Member] Rejected by:", rejectMsg["rejected_by"], "Reason:", rejectMsg["reason"])
                                            -- เพิ่ม host ที่ reject เข้า list
                                            if rejectMsg["rejected_by"] and not table.find(rejected_hosts, rejectMsg["rejected_by"]) then
                                                table.insert(rejected_hosts, rejectMsg["rejected_by"])
                                                print("[Member] Added to rejected_hosts:", rejectMsg["rejected_by"])
                                            end
                                            -- ลบ pending_host และ reject message
                                            UpdateCache(cache_key, {["pending_host"] = ""})
                                            DelCache(cache_key .. "-reject")
                                            print("[Member] Finding new host after rejection...")
                                            task.wait(2)
                                        elseif cache["pending_host"] and #cache["pending_host"] > 1 then
                                            -- มี pending_host แล้ว - รอ Host คนนั้นตอบกลับ
                                            local pendingHost = cache["pending_host"]
                                            local pendingTimestamp = cache["pending_timestamp"] or 0
                                            local hostCache = GetCache(pendingHost)
                                            
                                            -- เช็ค timeout (120 วินาที แต่ถ้า Host รับแล้วไม่มี timeout)
                                            local isAccepted = hostCache and hostCache["party_member"] and hostCache["party_member"][cache_key]
                                            local timeoutDuration = isAccepted and math.huge or 240
                                            
                                            if os.time() > pendingTimestamp + timeoutDuration then
                                                print("[Member] Timeout waiting for host:", pendingHost, "- finding new host...")
                                                UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                                task.wait(2)
                                            elseif isAccepted then
                                                -- Host รับแล้ว! 
                                                print("[Member] Host accepted! Updating party to:", pendingHost)
                                                UpdateCache(cache_key, {["party"] = pendingHost, ["pending_host"] = "", ["pending_timestamp"] = 0})
                                                -- รอให้ cache อัพเดทก่อนวนรอบใหม่
                                                task.wait(10)
                                            elseif not hostCache then
                                                -- Host cache หาย - reset และหาใหม่
                                                print("[Member] Pending host cache missing, finding new host...")
                                                UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                            elseif os.time() > hostCache["last_online"] then
                                                -- Host offline - เช็คว่ายังมีชื่อเราใน party_member หรือไม่
                                                if hostCache["party_member"] and hostCache["party_member"][cache_key] then
                                                    -- Host รับแล้วแต่ offline (กำลัง shutdown มารับ) - รอต่อ
                                                    print("[Member] Host offline but accepted (coming to pick up) - waiting...")
                                                else
                                                    -- Host offline จริงๆ ไม่มีชื่อเรา - หาใหม่
                                                    print("[Member] Pending host offline (not accepted), finding new host...")
                                                    UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                                end
                                            else
                                                print("[Member] Waiting for host:", pendingHost, "elapsed:", os.time() - pendingTimestamp, "s")
                                            end
                                            task.wait(5)
                                        else
                                            warn("Find Party")
                                            local kaiData = DecBody(GetKai)
                                            print("[Member] GetKai count:", kaiData and #kaiData or 0)
                                            local currentPendingHost = cache["pending_host"] or ""
                                            local availableHosts = {}
                                            for i, v in pairs(kaiData or {}) do
                                                local hostUsername = v["username"]
                                                print("[Member] Checking host:", hostUsername)
                                                if hostUsername == Username then 
                                                    print("[Member] Skip - same as self")
                                                    continue 
                                                end
                                                
                                                if hostUsername == currentPendingHost and #currentPendingHost > 1 then
                                                    print("[Member] Skip - already pending with:", hostUsername)
                                                    continue
                                                end
                                                
                                                -- เช็คว่า host นี้เคย reject แล้วหรือยัง
                                                if table.find(rejected_hosts, hostUsername) then
                                                    print("[Member] Skip - previously rejected by:", hostUsername)
                                                    continue
                                                end
                                                
                                                local kai_cache = GetCache(hostUsername)
                                                if not kai_cache then 
                                                    print("[Member] Skip - no cache for:", hostUsername)
                                                    continue 
                                                end
                                                print("[Member] Host cache:", hostUsername, "last_online:", kai_cache["last_online"], "now:", os.time())
                                                if os.time() > kai_cache["last_online"] then 
                                                    print("[Member] Skip - offline:", hostUsername)
                                                    continue 
                                                end
                                                if LenT(kai_cache["party_member"]) >= 3 then 
                                                    print("[Member] Skip - party full:", hostUsername)
                                                    continue 
                                                end
                                                
                                                -- เช็ค current_play ของ Host
                                                local kaiproduct = kai_cache["current_play"] or ""
                                                
                                                if #kaiproduct > 10 then
                                                    -- Host มี current_play แล้ว (party มี member) → เช็ค order_type กับ current_play
                                                    local myOrderType, hostOrderType = nil, nil
                                                    for orderName, orderIds in pairs(Order_Type) do
                                                        if table.find(orderIds, productid) then
                                                            myOrderType = orderName
                                                        end
                                                        if table.find(orderIds, kaiproduct) then
                                                            hostOrderType = orderName
                                                        end
                                                    end
                                                    print("[Member]", hostUsername, "Check current_play - My:", myOrderType, "Host:", hostOrderType)
                                                    
                                                    -- ถ้าหา order_type ไม่เจอ หรือ order_type ไม่ตรงกัน → skip
                                                    if not myOrderType or not hostOrderType then
                                                        print("[Member] Skip - cannot determine order_type")
                                                        continue
                                                    elseif myOrderType ~= hostOrderType then
                                                        print("[Member] Skip - order_type mismatch (current_play)")
                                                        continue
                                                    end
                                                    
                                                    -- order_type ตรงกัน → เพิ่มใน availableHosts
                                                    print("[Member] Host OK (has current_play, same order_type):", hostUsername)
                                                    table.insert(availableHosts, {username = hostUsername, hasCurrentPlay = true})
                                                else
                                                    -- Host ยังไม่มี current_play → request ได้เลย (Host จะเช็ค order_type เอง)
                                                    print("[Member] Host OK (no current_play):", hostUsername)
                                                    table.insert(availableHosts, {username = hostUsername, hasCurrentPlay = false})
                                                end
                                            end
                                            
                                            print("[Member] Available hosts:", #availableHosts)
                                            if #availableHosts > 0 then
                                                math.randomseed(os.time() + tick())
                                                local selected = availableHosts[math.random(1, #availableHosts)]
                                                local selectedHost = selected.username
                                                print("[Member] Request to:", selectedHost, "hasCurrentPlay:", selected.hasCurrentPlay)
                                                -- อัพเดท pending_host ก่อนส่ง request เพื่อป้องกันการส่งซ้ำ
                                                UpdateCache(cache_key, {["pending_host"] = selectedHost, ["pending_timestamp"] = os.time()})
                                                print("[Member] Set pending_host:", selectedHost, "at:", os.time())
                                                SendCache(
                                                    {
                                                        ["index"] = selectedHost .. "-message"
                                                    },
                                                    {
                                                        ["value"] = {
                                                            ["order"] = cache_key,
                                                            ["message-id"] = HttpService:GenerateGUID(false),
                                                            ["join"] = os.time() + 120,
                                                        },
                                                    }
                                                )
                                                print("[Member] Request sent, waiting for response...")
                                                -- รอให้ Host ตอบกลับ
                                                task.wait(15)
                                            else
                                                print("[Member] No available hosts found - waiting before retry...")
                                                task.wait(5)
                                            end
                                            GetKai = Get(Api .. MainSettings["Path_Kai"])
                                        end
                                    end
                                end
                            end
                            task.wait(5)
                        else
                            -- ไม่มี party - หา Host ใหม่
                            local rejectMsg = GetCache(cache_key .. "-reject")
                            if rejectMsg and rejectMsg["expire"] and rejectMsg["expire"] >= os.time() then
                                print("[Member] Rejected by:", rejectMsg["rejected_by"], "Reason:", rejectMsg["reason"])
                                -- เพิ่ม host ที่ reject เข้า list
                                if rejectMsg["rejected_by"] and not table.find(rejected_hosts, rejectMsg["rejected_by"]) then
                                    table.insert(rejected_hosts, rejectMsg["rejected_by"])
                                    print("[Member] Added to rejected_hosts:", rejectMsg["rejected_by"])
                                end
                                UpdateCache(cache_key, {["pending_host"] = ""})
                                DelCache(cache_key .. "-reject")
                                print("[Member] Finding new host after rejection...")
                                task.wait(2)
                            elseif cache["pending_host"] and #cache["pending_host"] > 1 then
                                -- มี pending_host - รอ Host คนนั้นตอบกลับ
                                local pendingHost = cache["pending_host"]
                                local pendingTimestamp = cache["pending_timestamp"] or 0
                                local hostCache = GetCache(pendingHost)
                                
                                local isAccepted = hostCache and hostCache["party_member"] and hostCache["party_member"][cache_key]
                                local timeoutDuration = isAccepted and math.huge or 240
                                
                                if os.time() > pendingTimestamp + timeoutDuration then
                                    print("[Member] Timeout waiting for host:", pendingHost, "- finding new host...")
                                    UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                    task.wait(2)
                                elseif isAccepted then
                                    print("[Member] Host accepted! Updating party to:", pendingHost)
                                    UpdateCache(cache_key, {["party"] = pendingHost, ["pending_host"] = "", ["pending_timestamp"] = 0})
                                    task.wait(10)
                                elseif not hostCache then
                                    print("[Member] Pending host cache missing, finding new host...")
                                    UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                elseif os.time() > hostCache["last_online"] then
                                    if hostCache["party_member"] and hostCache["party_member"][cache_key] then
                                        print("[Member] Host offline but accepted (coming to pick up) - waiting...")
                                    else
                                        print("[Member] Pending host offline (not accepted), finding new host...")
                                        UpdateCache(cache_key, {["pending_host"] = "", ["pending_timestamp"] = 0})
                                    end
                                else
                                    print("[Member] Waiting for host:", pendingHost, "elapsed:", os.time() - pendingTimestamp, "s")
                                end
                                task.wait(5)
                            else
                                -- ไม่มี party และไม่มี pending_host - หา Host ใหม่
                                warn("[Member] No party - Finding host...")
                                local kaiData = DecBody(GetKai)
                                print("[Member] GetKai count:", kaiData and #kaiData or 0)
                                local currentPendingHost = cache["pending_host"] or ""
                                local availableHosts = {}
                                for i, v in pairs(kaiData or {}) do
                                    local hostUsername = v["username"]
                                    if hostUsername == Username then continue end
                                    
                                    if hostUsername == currentPendingHost and #currentPendingHost > 1 then
                                        print("[Member] Skip - already pending with:", hostUsername)
                                        continue
                                    end
                                    
                                    -- เช็คว่า host นี้เคย reject แล้วหรือยัง
                                    if table.find(rejected_hosts, hostUsername) then
                                        print("[Member] Skip - previously rejected by:", hostUsername)
                                        continue
                                    end
                                    
                                    local kai_cache = GetCache(hostUsername)
                                    if not kai_cache then continue end
                                    if os.time() > kai_cache["last_online"] then continue end
                                    if LenT(kai_cache["party_member"]) >= 3 then continue end
                                    
                                    -- เช็ค current_play ของ Host (เหมือนระบบเก่า)
                                    local kaiproduct = kai_cache["current_play"] or ""
                                    if #kaiproduct > 10 then
                                        -- Host มี current_play แล้ว → เช็ค order_type
                                        local myOrderType, hostOrderType = nil, nil
                                        for orderName, orderIds in pairs(Order_Type) do
                                            if table.find(orderIds, productid) then
                                                myOrderType = orderName
                                            end
                                            if table.find(orderIds, kaiproduct) then
                                                hostOrderType = orderName
                                            end
                                        end
                                        print("[Member]", hostUsername, "Product Type:", myOrderType, hostOrderType)
                                        
                                        if myOrderType and hostOrderType and myOrderType ~= hostOrderType then
                                            print("[Member] Skip - order_type mismatch")
                                            continue
                                        end
                                        
                                        print("[Member] Host OK (has current_play):", hostUsername)
                                        table.insert(availableHosts, {username = hostUsername, hasCurrentPlay = true})
                                    else
                                        -- Host ยังไม่มี current_play → request ได้เลย
                                        print("[Member] Host OK (no current_play):", hostUsername)
                                        table.insert(availableHosts, {username = hostUsername, hasCurrentPlay = false})
                                    end
                                end
                                
                                print("[Member] Available hosts:", #availableHosts)
                                if #availableHosts > 0 then
                                    -- Priority: เลือก Host ที่มี current_play (order_type ตรงกัน) ก่อน
                                    local hostsWithCurrentPlay = {}
                                    local hostsWithoutCurrentPlay = {}
                                    
                                    for _, host in ipairs(availableHosts) do
                                        if host.hasCurrentPlay then
                                            table.insert(hostsWithCurrentPlay, host)
                                        else
                                            table.insert(hostsWithoutCurrentPlay, host)
                                        end
                                    end
                                    
                                    local selected = nil
                                    math.randomseed(os.time() + tick())
                                    
                                    if #hostsWithCurrentPlay > 0 then
                                        -- มี Host ที่มี current_play ตรงกัน → เลือกจากกลุ่มนี้ก่อน
                                        selected = hostsWithCurrentPlay[math.random(1, #hostsWithCurrentPlay)]
                                        print("[Member] Prioritizing host with matching current_play")
                                    else
                                        -- ไม่มี Host ที่มี current_play → เลือกจาก Host ที่ว่าง
                                        selected = hostsWithoutCurrentPlay[math.random(1, #hostsWithoutCurrentPlay)]
                                        print("[Member] No host with current_play, selecting from empty hosts")
                                    end
                                    
                                    local selectedHost = selected.username
                                    print("[Member] Request to:", selectedHost, "hasCurrentPlay:", selected.hasCurrentPlay)
                                    UpdateCache(cache_key, {["pending_host"] = selectedHost, ["pending_timestamp"] = os.time()})
                                    SendCache(
                                        {["index"] = selectedHost .. "-message"},
                                        {["value"] = {
                                            ["order"] = cache_key,
                                            ["message-id"] = HttpService:GenerateGUID(false),
                                            ["join"] = os.time() + 120,
                                        }}
                                    )
                                    print("[Member] Request sent, waiting for response...")
                                    task.wait(15)
                                else
                                    print("[Member] No available hosts found - waiting before retry...")
                                    task.wait(5)
                                end
                                GetKai = Get(Api .. MainSettings["Path_Kai"])
                            end
                            task.wait(5)
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    else
        print("MEOWWWW")
        -- รอให้เกมโหลดเสร็จก่อน
        print("[Loading] Waiting for game to load...")
        task.wait(10)
        print("[Loading] Game loaded, starting...")
        if IsKai then
            -- ดึง product_id จาก API เพื่อให้ Member หาเจอ
            local hostData = Fetch_data()
            local hostProductId = hostData and hostData["product_id"] or ""
            print("[Host In Stage] Product ID from API:", hostProductId)
            
            -- สร้าง/อัพเดท cache สำหรับ Host ในด่าน
            local cache = GetCache(Username)
            if not cache then
                print("[Host In Stage] Creating cache with host_id:", hostProductId)
                SendCache(
                    {
                        ["index"] = Username
                    },
                    {
                        ["value"] = {
                            ["last_online"] = os.time() + 400,
                            ["host_id"] = hostProductId,  -- Host's own product_id
                            ["current_play"] = "",        -- Party system (Member's product_id)
                            ["party_member"] = {},
                        }
                    }
                )
                task.wait(2)
                cache = GetCache(Username)
            else
                -- อัพเดท host_id ถ้ายังไม่ได้ set
                if cache["host_id"] == "" or cache["host_id"] == nil then
                    print("[Host In Stage] Updating host_id to:", hostProductId)
                    UpdateCache(Username, {["host_id"] = hostProductId})
                end
            end
            if cache then
                local hostId = cache["host_id"] or hostProductId
                print("[Host In Stage] Cache exists, host_id:", hostId)
                if Changes[hostId] then
                    Changes[hostId]()
                    print("Configs has Changed ", hostId)
                end
            end
            local Last_Message_1 = nil
            local Last_Message_2 = nil
            local Current_Party_Stage = {}
            local Waiting_Time_Stage = os.time() + 60
            
            -- ฟังก์ชันเช็คว่า party members อยู่ในเกมหรือไม่
            local function GetPartyInGame(partyMembers)
                local inGame = {}
                for orderKey, memberData in pairs(partyMembers or {}) do
                    local memberName = memberData["name"]
                    if memberName and Players:FindFirstChild(memberName) then
                        table.insert(inGame, memberName)
                    end
                end
                return inGame
            end
            
            -- Auto Accept Party + เช็ค member request (ทำงานทั้งในด่านและ lobby)
            task.spawn(function()
                print("[Host In Stage] Loop Started")
                while true do task.wait(3)
                    local cache = GetCache(Username)
                    if not cache then print("[Host In Stage] No cache") continue end
                    
                    -- อัพเดท last_online เพื่อไม่ให้ cache หมดอายุ
                    UpdateCache(Username, {["last_online"] = os.time() + 200})
                    
                    -- อัพเดท Current_Party_Stage
                    Current_Party_Stage = GetPartyInGame(cache["party_member"])
                    
                    -- Accept member request
                    local message = GetCache(Username .. "-message")
                    print("[Host In Stage] Checking message - has message:", message ~= nil, "Last_Message_1:", Last_Message_1)
                    if message then
                        print("[Host In Stage] Message details - message-id:", message["message-id"], "join:", message["join"], "now:", os.time())
                    end
                    if message and Last_Message_1 ~= message["message-id"] and message["join"] and message["join"] >= os.time() then
                        print("[Host In Stage] New message from:", message["order"], "valid until:", message["join"], "now:", os.time())
                        Last_Message_1 = message["message-id"]
                        
                        local memberCache = GetCache(message["order"])
                        if memberCache and memberCache["product_id"] then
                            local old_party = cache["party_member"] and table.clone(cache["party_member"]) or {}
                            
                            -- เช็คว่า party เต็มหรือไม่
                            if LenT(old_party) >= 3 then
                                print("[Host In Stage] Party full - rejecting")
                                SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                            else
                                -- เช็ค current_play (party's product) - ไม่ใช่ host_id
                                local currentPlay = cache["current_play"] or ""
                                local shouldAccept = true
                                
                                if #currentPlay > 10 then
                                    -- มี current_play แล้ว (party มี member) → เช็ค order_type
                                    local Type_NewMember, Type_CurrentPlay = nil, nil
                                    for orderName, orderIds in pairs(Order_Type) do
                                        if table.find(orderIds, memberCache["product_id"]) then
                                            Type_NewMember = orderName
                                        end
                                        if table.find(orderIds, currentPlay) then
                                            Type_CurrentPlay = orderName
                                        end
                                    end
                                    
                                    print("[Host In Stage] Member type:", Type_NewMember, "Party type:", Type_CurrentPlay, "(current_play)")
                                    
                                    if memberCache["product_id"] ~= currentPlay then
                                        if Type_NewMember and Type_CurrentPlay and Type_NewMember ~= Type_CurrentPlay then
                                            print("[Host In Stage] Order type mismatch - rejecting")
                                            shouldAccept = false
                                            SendCache(
                                                {["index"] = message["order"] .. "-reject"},
                                                {["value"] = {
                                                    ["rejected_by"] = Username,
                                                    ["reason"] = "Different Order_Type",
                                                    ["message-id"] = HttpService:GenerateGUID(false),
                                                    ["expire"] = os.time() + 30,
                                                }}
                                            )
                                            SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                        end
                                    end
                                else
                                    -- ยังไม่มี current_play (party ว่าง) → รับได้เลย
                                    print("[Host In Stage] No current_play - accepting any member")
                                end
                                
                                if shouldAccept then
                                    print("[Host In Stage] Accepting member:", memberCache["name"], "product_id:", memberCache["product_id"])
                                    old_party[message["order"]] = {
                                        ["join_time"] = os.time(),
                                        ["product_id"] = memberCache["product_id"],
                                        ["name"] = memberCache["name"],
                                    }
                                    UpdateCache(Username, {["party_member"] = old_party})
                                    UpdateCache(message["order"], {["party"] = Username, ["pending_host"] = ""})
                                    -- Set current_play เป็น product_id ของ member คนแรก (ถ้ายังไม่มี)
                                    if #currentPlay < 10 then
                                        UpdateCache(Username, {["current_play"] = memberCache["product_id"]})
                                    end
                                    SendCache({["index"] = Username .. "-message"}, {["value"] = {["join"] = 0}})
                                    print("[Host In Stage] Member accepted")
                                    
                                    -- เช็คว่า member อยู่ในเกมเดียวกันหรือไม่
                                    local memberName = memberCache["name"]
                                    if memberName and Players:FindFirstChild(memberName) then
                                        print("[Host In Stage] Member already in game - continue playing")
                                        Waiting_Time_Stage = os.time() + 60
                                    else
                                        print("[Host In Stage] Member not in game - shutting down to pick up")
                                        -- อัพเดท last_online ก่อน shutdown เพื่อไม่ให้ cache ถูกลบ
                                        UpdateCache(Username, {["last_online"] = os.time() + 450})
                                        task.wait(3)
                                        game:Shutdown()
                                    end
                                end
                            end
                        end
                        task.wait(3)
                    end
                    
                    -- เช็คว่า party members ยังอยู่ในเกมหรือไม่ (ถ้าหลุดไป ให้ shutdown)
                    local partyMembers = cache["party_member"] or {}
                    local partyCount = LenT(partyMembers)
                    if partyCount > 0 then
                        local inGameCount = #Current_Party_Stage
                        if inGameCount < partyCount then
                            -- มี member หลุดไป - shutdown เพื่อออกไปรับ
                            print("[Host In Stage] Member disconnected! In game:", inGameCount, "Expected:", partyCount)
                            -- อัพเดท last_online ก่อน shutdown เพื่อไม่ให้ cache ถูกลบ
                            UpdateCache(Username, {["last_online"] = os.time() + 450})
                            task.wait(3)
                            game:Shutdown()
                        end
                    end
                    
                    -- Remove member request
                    local message2 = GetCache(Username .. "-message-2")
                    if message2 and Last_Message_2 ~= message2["message-id"] and message2["join"] and message2["join"] >= os.time() then
                        local old_party = cache["party_member"] and table.clone(cache["party_member"]) or {}
                        if old_party[message2["order"]] then
                            old_party[message2["order"]] = nil
                            UpdateCache(Username, {["party_member"] = old_party})
                            UpdateCache(message2["order"], {["party"] = ""})
                            -- อัพเดท current_play
                            local path = nil
                            local lowest = math.huge
                            for i, v in pairs(old_party) do
                                if v["join_time"] < lowest then
                                    path = v["product_id"]
                                    lowest = v["join_time"]
                                end
                            end
                            if path then
                                UpdateCache(Username, {["current_play"] = path})
                            else
                                UpdateCache(Username, {["current_play"] = ""})
                            end
                        end
                        Last_Message_2 = message2["message-id"]
                        task.wait(3)
                    end
                end
            end)
            task.spawn(function()
                while task.wait(10) do
                    UpdateCache(Username,{["last_online"] = os.time() + 250})
                end
            end)
            
            -- Check If End Game And Not Found A Player
            if Networking:FindFirstChild("EndScreen") and Networking.EndScreen:FindFirstChild("ShowEndScreenEvent") then
                Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                    -- print("[EndScreen] 📺 Detected! Status:", Results and Results.Status or "Unknown")
                    
                    if Settings["Auto Retry"] then
                        task.spawn(function()
                            local AutoReplayState = {
                                LastVoteTime = 0,
                                VoteCooldown = 3,
                                Enabled = true,
                                VoteEvent = nil
                            }
                            
                            pcall(function()
                                AutoReplayState.VoteEvent = ReplicatedStorage:FindFirstChild("Networking")
                                    and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
                                    and ReplicatedStorage.Networking.EndScreen:FindFirstChild("VoteEvent")
                            end)
                            
                            local function AutoVoteReplay()
                                if not AutoReplayState.Enabled then return end
                                if not AutoReplayState.VoteEvent then return end
                                
                                local now = tick()
                                if now - AutoReplayState.LastVoteTime < AutoReplayState.VoteCooldown then return end
                                AutoReplayState.LastVoteTime = now
                                
                                pcall(function()
                                    AutoReplayState.VoteEvent:FireServer("Retry")
                                    print("[AutoReplay] 🔄 Voted Retry via VoteEvent")
                                end)
                            end
                            
                            _G.AutoReplay_ExecuteVote = AutoVoteReplay
                            
                            pcall(function()
                                local ShowEndScreenEvent = ReplicatedStorage:FindFirstChild("Networking")
                                    and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
                                    and ReplicatedStorage.Networking.EndScreen:FindFirstChild("ShowEndScreenEvent")
                                
                                if ShowEndScreenEvent then
                                    ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
                                        -- print("[AutoReplay] � EndScreen detected! Status:", Results and Results.Status or "Unknown")
                                        task.delay(2, AutoVoteReplay)
                                        task.delay(5, AutoVoteReplay)
                                    end)
                                    print("[AutoReplay] ✅ ShowEndScreenEvent connected!")
                                else
                                    warn("[AutoReplay] ⚠️ ShowEndScreenEvent not found")
                                end
                            end)
                        end)
                    end
                    
                    if Settings["Auto Next"] then
                        task.spawn(function()
                            local AutoNextState = {
                                LastVoteTime = 0,
                                VoteCooldown = 3,
                                VoteEvent = nil
                            }
                            
                            pcall(function()
                                AutoNextState.VoteEvent = ReplicatedStorage:FindFirstChild("Networking")
                                    and ReplicatedStorage.Networking:FindFirstChild("EndScreen")
                                    and ReplicatedStorage.Networking.EndScreen:FindFirstChild("VoteEvent")
                            end)
                            
                            local function AutoVoteNext()
                                if not AutoNextState.VoteEvent then return end
                                
                                local now = tick()
                                if now - AutoNextState.LastVoteTime < AutoNextState.VoteCooldown then return end
                                AutoNextState.LastVoteTime = now
                                
                                pcall(function()
                                    AutoNextState.VoteEvent:FireServer("Next")
                                    print("[Auto Next] ➡️ Voted Next")
                                end)
                            end
                            
                            -- Auto vote ตอนเจอ EndScreen
                            task.delay(2, AutoVoteNext)
                            task.delay(5, AutoVoteNext)
                            task.delay(8, AutoVoteNext)
                        end)
                    end
                    
                    if Settings["Auto Back Lobby"] then
                        task.spawn(function()
                            local function isEndScreenVisible()
                                local EndScreenGui = plr.PlayerGui:FindFirstChild("EndScreen")
                                if not EndScreenGui then return false end
                                
                                local Holder = EndScreenGui:FindFirstChild("Holder")
                                if Holder and Holder.Visible then return true end
                                if EndScreenGui.Enabled ~= false then return true end
                                
                                return false
                            end
                            
                            task.delay(2, function()
                                for attempt = 1, 3 do
                                    task.wait(2)
                                    if isEndScreenVisible() then
                                        pcall(function()
                                            Networking.TeleportEvent:FireServer("Lobby")
                                            print("[Auto Back Lobby] 🏠 Teleported to Lobby (attempt " .. attempt .. ")")
                                        end)
                                    end
                                end
                            end)
                        end)
                    end
                    
                    -- Legacy party/challenge handling
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
                -- print("[EndScreen] ✅ ShowEndScreenEvent connected!")
            else
                -- warn("[EndScreen] ⚠️ EndScreen or ShowEndScreenEvent not found - Auto Retry/Next/BackLobby disabled")
            end
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
                local InterfaceEvent = Networking:WaitForChild("InterfaceEvent")
                local autoRestartTriggered = false
                
                InterfaceEvent.OnClientEvent:Connect(function(eventType, data)
                    if eventType == "Wave" and data and data.Waves then
                        currentWave = data.Waves
                        -- print("[Auto Modifier] Wave:", currentWave)
                        
                        if currentWave == 0 then
                            chosenModifiers = {}
                            lastChoice = nil
                            autoRestartTriggered = false  -- Reset flag เมื่อเกมใหม่
                        end
                        
                        -- ⭐ Auto Restart แบบ Wave
                        if Settings["Auto Restart"] and Settings["Auto Restart"]["Enable"] and not autoRestartTriggered then
                            local restartWave = Settings["Auto Restart"]["Wave"] or 1
                            if currentWave >= restartWave and currentWave > 0 then
                                print(string.format("[Auto Restart] Wave %d reached (target: %d) - Voting restart...", currentWave, restartWave))
                                VoteRestart()
                                autoRestartTriggered = true
                            end
                        end
                        
                        -- Restart Modifier (เช็ค modifier)
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
