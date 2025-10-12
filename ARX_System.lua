--[[
Map
Voocha Village
Green Planet
Demon Forest
Leaf Village
Z City
Cursed Town
Easter Egg
Ghoul City
]]
local Api = "https://api.championshop.date/" -- Api ใส่ / ลงท้ายด้วย เช่น www.google.com/
local Key = "NO_ORDER" 
local PathWay = Api .. "api/v1/shop/orders/"  -- ที่ผมเข้าใจคือ orders คือจุดกระจาย order ตัวอื่นๆ 
local ID = {
    [72829404259339] = {
        [1] = "ARX",
        [2] = 1,
    },
}
local Settings = {
    ["Auto Play"] = {
        ["Enabled"] = true,
    },
    ["Select Mode"] = "Event", -- Story , Event , Challenge
    ["Ranger Enabled"] = false,
    ["Party Mode"] = false,

    ["Select End Method"] = "VoteRetry", -- VoteRetry , VoteNext , VotePlaying

    ["Story Settings"] = {
        ["World"] = "Voocha Village",
        ["Difficulty"] = "Normal", -- Normal , Hard , Nightmare
        ["Level"] = "1",
        ["Friend Only"] = true,
    },
    ["Ranger Settings"] = {
        ["World"] = {
            ["Voocha Village"] = {
                [1] = "1",
                [2] = "2",
                [3] = "3",
            },
            ["Green Planet"] = {
                [1] = "1",
                [2] = "2",
                [3] = "3",
            },
            ["Demon Forest"] = {
                [1] = "1",
                [2] = "2",
                [3] = "3",
            },
            ["Leaf Village"] = {
                [1] = "1",
                [2] = "2",
                [3] = "3",
            },
            ["Z City"] = {
                [1] = "1",
                [2] = "2",
                [3] = "3",
            },
        },
        ["Friend Only"] = true,
    },
}

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if game.GameId ~= 6884266247 then return warn("Doesn't match ID") end
repeat task.wait() until game:GetService("Players").LocalPlayer:GetAttribute("ClientLoaded")
print("Loading..") task.wait(5)

local Api = "https://api.championshop.date" -- ใส่ API ตรงนี้
local local_data = ID[game.GameId]; if not local_data then game:GetService("Players").LocalPlayer:Kick("Not Support Yet") end
local IsGame = local_data[1]
local MainSettings = {
    ["Path_Cache"] = "/api/v1/shop/orders/cache",
    ["Path_Kai"] = "/api/v1/shop/accountskai",
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
local Changes = {
    ["1b3ffdad-7ccc-431e-90da-ad62040eb2a3"] = function()
        Settings["Select Mode"] = "Story"
        Settings["Story Settings"] = {
        ["World"] = "Voocha Village",
        ["Difficulty"] = "Nightmare", -- Normal , Hard , Nightmare
        ["Level"] = "10",
        ["Friend Only"] = false,
    },
    end,
}
local Order_Type = {
    ["Gems"] = {
        "1b3ffdad-7ccc-431e-90da-ad62040eb2a3",
    },
}
local function Register_Room(myproduct,player)
    
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
for _, v in ipairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "LoadData") then
        print(v)
    end
end
-- Modules
local Worlds = LoadModule(game:GetService("ReplicatedStorage").Shared.Info.GameWorld.World)
-- Variables

local VisualEvent = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remote = ReplicatedStorage:WaitForChild("Remote")
local Values = ReplicatedStorage:WaitForChild("Values")
local Server = Remote:WaitForChild("Server")
local Client = Remote:WaitForChild("Client")
local plr = game.Players.LocalPlayer
local Data = ReplicatedStorage.Player_Data[plr.Name]
local LocalData = Data:WaitForChild("Data")
local Collection = Data:WaitForChild("Collection")
local MapIndexs = {}
local Character = plr.Character or plr.CharacterAdded:Wait()


local Client = Players.LocalPlayer
local Username = Client.Name

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
local function Reverse_ID(id)
    return id:split("_")[1]
end
local function IsRangerCD()
    if Settings["Ranger Enabled"] then
        local Setting = Settings["Ranger Settings"]
        for i,v in pairs(Setting["World"]) do
            -- print(i,v)
            for i1,v1 in pairs(v) do
                print(Data["RangerStage"],i,v1)
                if not Data["RangerStage"]:FindFirstChild(Get_Ranger(i,v1)) then
                    return Get_Ranger(i,v1)
                end
            end 
        end
    end
    return false
end
-- Script Sections 
local Auto_Configs = true
local RangerIsCD = IsRangerCD()
local CurrentIs = RangerIsCD and "Ranger Stage" or Settings["Select Mode"] 
local function Join(party)
    if not Settings["Party Mode"] then
        if Settings["Ranger Enabled"] and RangerIsCD then
            -- print(RangerIsCD)
            local Setting = Settings["Ranger Settings"]
            Event("Create") task.wait(.2)
            if Setting["Friend Only"] then
                Event("Change-FriendOnly") task.wait(.2)
            end

            Event("Change-Mode",{Mode = "Ranger Stage"}) task.wait(.2)
            Event("Change-World",{World = Reverse_ID(RangerIsCD)}) task.wait(.2)
            Event("Change-Chapter",{Chapter = RangerIsCD}) task.wait(.2)
            Event("Submit") task.wait(.2)
            if party then
                task.wait(6)
            end
            Event("Start") task.wait(10)
        end
        if Settings["Select Mode"] == "Story" then
            local Setting = Settings[Settings["Select Mode"] .. " Settings"]
            Event("Create") task.wait(.2)
            if Setting["Friend Only"] then
                Event("Change-FriendOnly") task.wait(.2)
            end
            Event("Change-World",{World = MapIndexs[Setting["World"]]}) task.wait(.2)
            Event("Change-Chapter",{Chapter = Get_Story(Setting["World"],Setting["Level"])}) task.wait(.2)
            Event("Change-Difficulty",{Difficulty = Setting["Difficulty"]}) task.wait(.2)
            Event("Submit") 
        elseif Settings["Select Mode"] == "Event" then
            Event("Easter-Event")
           
        elseif Settings["Select Mode"] == "Challenge" then
            Event("Create",{CreateChallengeRoom = true})
        end
        if party then
            task.wait(6)
        end
        Event("Start")
    end
end 
local function Auto_Config(id)
    if Auto_Configs then
        if id then
            if Changes[id] then
                Changes[id]()
                print("Changed Configs")
            end 
            return false
        end
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
        if OrderData["want_carry"] then
            Settings["Party Mode"] = true
        end
        if not Order["Success"] then
            Post_(PathWay .. "cache",{
                ["index"] = Key,
                ["value"] = GetData()
            })
        else 
             local Product = OrderData["product"]
            local Goal = Product["condition"]["value"]
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
       
    end
end


if not Workspace:FindFirstChild("WayPoint")then
    if IsKai then
        local cache_key = Username
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
                        Waiting_Time = os.time() + 150
                        print("Add Time To Waiting Time")
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
                                local p,c = pcall(function()
                                    Auto_Config(Product)
                                    Join(Product)
                                end)
                            else
                                print("Not Found Member",All_Players_Activated() , All_Players_Game())
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
    else
        Auto_Config()
        if Settings["Party Mode"] then
            task.spawn(function()
                task.wait(math.random(5,10))
                local data = Fetch_data() 
                if not data or not data["want_carry"] then print("No Data") return false end
                local productid = data["product_id"]
                local orderid = data["id"]
                local cache_key = orderid .. "_cache_2"
                
                local cache_1 = {}
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                --[[
                    Secret Key Example
                    "orderid_cache_1"
                ]]
                local AttemptToAlready = 0
                game:GetService("ReplicatedStorage").PlayRoom.ChildAdded:Connect(function(v)
                    if v.Name == cache_1["party"] then
                        local args = {
                            "Join-Room",
                            {
                                Room = v
                            }
                        }
                        Server:WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))
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
                                    warn("Host is Offline But Not Longer :D")
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
                                        print(Product_Type_1,Product_Type_2)
                                        if Product_Type_1 ~= Product_Type_2 then
                                            continue;
                                        end
                                        SendCache(
                                            {
                                                ["index"] = v["username"] .. "-message"
                                            },
                                            {
                                                ["value"] = {
                                                    ["order"] = cache_key,
                                                    ["message-id"] = HttpService:GenerateGUID(false),
                                                    ["join"] = os.time() + 10,
                                                },
                                            }
                                        )
                                        AttemptToAlready = 0
                                    else
                                        print("Request To Make Party",AttemptToAlready)
                                        if AttemptToAlready < 5 then continue; end
                                        print("Create Party",AttemptToAlready)
                                        SendCache(
                                            {
                                                ["index"] = v["username"] .. "-message"
                                            },
                                            {
                                                ["value"] = {
                                                    ["order"] = cache_key,
                                                    ["message-id"] = HttpService:GenerateGUID(false),
                                                    ["join"] = os.time() + 10,
                                                },
                                            }
                                        )
                                        AttemptToAlready = 0
                                    end
                                end
                            end
                            GetKai = Get(Api .. MainSettings["Path_Kai"])
                            AttemptToAlready = AttemptToAlready + 1
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            local Setting = Settings["Auto Play"]
            if Setting["Enabled"] then
                task.spawn(function()
                    while true do
                        print( plr.PlayerGui.RewardsUI.Enabled,"End Method Debug")
                        if plr.PlayerGui.RewardsUI.Enabled then
                            
                            UseVote(Settings["Select End Method"])
                        end
                        task.wait(1)
                    end
                end)
                task.spawn(function()
                    while true do
                        if plr.PlayerGui.Visual:FindFirstChild("Showcase_Units") then
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, true, game, 1) task.wait()
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, false, game, 1)
                        end
                        task.wait(1)
                    end
                end)
                local function AutoPlay()
                    RangerIsCD = IsRangerCD()
                    print(RangerIsCD ,Values.Game.Level.Value)
                    if RangerIsCD and RangerIsCD ~= Values.Game.Level.Value then
                        Join()
                        print("Join Debug 1")
                    elseif Values.Game.Gamemode.Value ~= CurrentIs then
                        print(Values.Game.Gamemode.Value,CurrentIs)
                        Join()
                        print("Join Debug 2")
                    end
                    print("Join Debug 3")
                    
                    local Enabled = true
                    local GameCF = LoadModule(game:GetService("ReplicatedStorage").Shared.GAMEPLAY_CONFIG)
                
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
                        if not workspace.Agent.UnitT:FindFirstChildWhichIsA("Part") or GetNearestPath() < math.floor(LastPath/2) or PlaceAccess() or OneTimePlace then
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
                print("Auto Play")
                AutoPlay()
            end
        end
    end
else
    if IsKai then
        local cache = GetCache(Username)
        if Changes[cache["product_id"]] then
            Changes[cache["product_id"]]()
            print("Configs has Changed ")
        end 
        local Last_Message_1 = nil
        local Last_Message_2 = nil
        -- Auto Accept Party
        task.spawn(function()
                while true do task.wait(1)
                local cache = GetCache(Username)
                if cache then
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
        Client:WaitForChild("UI"):WaitForChild("GameEndedUI").OnClientEvent:Connect(function()
            local cache = GetCache(Username)
            if #Players:GetChildren() ~= LenT(cache["party_member"]) + 1 then
                print("Party Member Request")
                task.wait(2)
                game:shutdown()
            end
        end)
        -- Check If No Player In Lobby 
        task.wait(30)
        local cache = GetCache(Username)
        if #Players:GetChildren() ~= LenT(cache["party_member"]) + 1 then
            game:shutdown()
        end
        task.spawn(function()
            while task.wait(1) do
                if #Players:GetChildren() <= 1 then
                    game:shutdown()
                end
            end
        end)
        local Setting = Settings["Auto Play"]
        if Setting["Enabled"] then
            task.spawn(function()
                while true do
                    print( plr.PlayerGui.RewardsUI.Enabled,"End Method Debug")
                    if plr.PlayerGui.RewardsUI.Enabled then
                        
                        UseVote(Settings["Select End Method"])
                    end
                    task.wait(1)
                end
            end)
            task.spawn(function()
                while true do
                    if plr.PlayerGui.Visual:FindFirstChild("Showcase_Units") then
                        VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, true, game, 1) task.wait()
                        VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, false, game, 1)
                    end
                    task.wait(1)
                end
            end)
            local function AutoPlay()
                RangerIsCD = IsRangerCD()
                print(RangerIsCD ,Values.Game.Level.Value)
                if RangerIsCD and RangerIsCD ~= Values.Game.Level.Value then
                    Join()
                    print("Join Debug 1")
                elseif Values.Game.Gamemode.Value ~= CurrentIs then
                    print(Values.Game.Gamemode.Value,CurrentIs)
                    Join()
                    print("Join Debug 2")
                end
                print("Join Debug 3")
                
                local Enabled = true
                local GameCF = LoadModule(game:GetService("ReplicatedStorage").Shared.GAMEPLAY_CONFIG)
            
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
                    if not workspace.Agent.UnitT:FindFirstChildWhichIsA("Part") or GetNearestPath() < math.floor(LastPath/2) or PlaceAccess() or OneTimePlace then
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
            print("Auto Play")
            AutoPlay()
        end
    else
        Auto_Config()
        if Settings["Party Mode"] then
            local Setting = Settings["Auto Play"]
            if Setting["Enabled"] then
                task.spawn(function()
                    while true do
                        print( plr.PlayerGui.RewardsUI.Enabled,"End Method Debug")
                        if plr.PlayerGui.RewardsUI.Enabled then
                            
                            UseVote(Settings["Select End Method"])
                        end
                        task.wait(1)
                    end
                end)
                task.spawn(function()
                    while true do
                        if plr.PlayerGui.Visual:FindFirstChild("Showcase_Units") then
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, true, game, 1) task.wait()
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, false, game, 1)
                        end
                        task.wait(1)
                    end
                end)
                local function AutoPlay()
                    RangerIsCD = IsRangerCD()
                    print(RangerIsCD ,Values.Game.Level.Value)
                    if RangerIsCD and RangerIsCD ~= Values.Game.Level.Value then
                        Join()
                        print("Join Debug 1")
                    elseif Values.Game.Gamemode.Value ~= CurrentIs then
                        print(Values.Game.Gamemode.Value,CurrentIs)
                        Join()
                        print("Join Debug 2")
                    end
                    print("Join Debug 3")
                    
                    local Enabled = true
                    local GameCF = LoadModule(game:GetService("ReplicatedStorage").Shared.GAMEPLAY_CONFIG)
                
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
                        if not workspace.Agent.UnitT:FindFirstChildWhichIsA("Part") or GetNearestPath() < math.floor(LastPath/2) or PlaceAccess() or OneTimePlace then
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
                print("Auto Play")
                AutoPlay()
            end
        else
            local Setting = Settings["Auto Play"]
            if Setting["Enabled"] then
                task.spawn(function()
                    while true do
                        print( plr.PlayerGui.RewardsUI.Enabled,"End Method Debug")
                        if plr.PlayerGui.RewardsUI.Enabled then
                            
                            UseVote(Settings["Select End Method"])
                        end
                        task.wait(1)
                    end
                end)
                task.spawn(function()
                    while true do
                        if plr.PlayerGui.Visual:FindFirstChild("Showcase_Units") then
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, true, game, 1) task.wait()
                            VisualEvent:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2), 0, false, game, 1)
                        end
                        task.wait(1)
                    end
                end)
                local function AutoPlay()
                    RangerIsCD = IsRangerCD()
                    print(RangerIsCD ,Values.Game.Level.Value)
                    if RangerIsCD and RangerIsCD ~= Values.Game.Level.Value then
                        Join()
                        print("Join Debug 1")
                    elseif Values.Game.Gamemode.Value ~= CurrentIs then
                        print(Values.Game.Gamemode.Value,CurrentIs)
                        Join()
                        print("Join Debug 2")
                    end
                    print("Join Debug 3")
                    
                    local Enabled = true
                    local GameCF = LoadModule(game:GetService("ReplicatedStorage").Shared.GAMEPLAY_CONFIG)
                
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
                        if not workspace.Agent.UnitT:FindFirstChildWhichIsA("Part") or GetNearestPath() < math.floor(LastPath/2) or PlaceAccess() or OneTimePlace then
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
                print("Auto Play")
                AutoPlay()
            end
        end
    end
end


