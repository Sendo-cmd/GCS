

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local Client = Players.LocalPlayer
-- Folder
local ReplicateService =  require(ReplicatedStorage:FindFirstChild("ReplicateService",true))


local Url = "https://api.championshop.date"
local List = {
    "Coin",
    "BattlePasses",
    "Exps",
}
local Lists = {
    ["BattlePasses"] = "Level",
    ["Exps"] = {"Level","Exp"},
}
task.wait(1.5)


local function convertToField(index,value)
    return {
        ["name"] = index,
        ["value"] = value or 1
    }
end
local function convertToField_(table_)
    local Field = {}
    for i,v in pairs(table_) do
        Field[#Field + 1] = convertToField(i,v)
    end
    return Field
end
local function GetSomeCurrency()
    local Field = {}
    for i,v in pairs(ReplicateService.GetData()) do
        if table.find(List,i) then
            -- local NewVal = type(v.Value) == "number" and formatNumber(v.Value)
            local value = v
            if type(v) == "table" then
                -- print(i,v)
                -- print(i,v[Lists[i]],Lists[i])
                if type(Lists[i]) == "table" then
                    -- warn(i,v)
                    for i1,v1 in pairs(v) do
                        if table.find(Lists[i],i1) then
                            Field[i1] = v1
                        end
                    end
                    continue;
                else
                    value = v[Lists[i]]
                end
               
            end
            Field[i] = value
        end
    end
    return Field
end
local function CreateBody(...)
    local Data = request({
        ["Url"] = Url .. "/api/v1/shop/orders/" .. Client.Name,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    print(Data["Success"])
    local Order_Data = HttpService:JSONDecode(Data["Body"])["data"]
    local body = {
        ["order_id"] = Order_Data[1]["id"],
    }
    local array = {...}
    for i,v in pairs(array) do
        for i1,v1 in pairs(v) do
            body[i1] = v1
        end
    end
    return body
end
local function SendTo(Url,...)
    warn("Hi")
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
    -- setclipboard(HttpService:JSONEncode(CreateBody(...)))
    for i,v in pairs(response) do
        warn(i,v)
    end 
    return response
end
local ReplicateService =  require(game.ReplicatedStorage:FindFirstChild("ReplicateService",true))

local function GetAllData()
    return ReplicateService.GetData()
end

local Data = GetAllData()
SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})

task.spawn(function ()
    
    local gamestart = workspace:GetAttribute("gamestart") or 0
    repeat task.wait() until workspace:GetAttribute("gameend")
    local timetaken = (workspace:GetAttribute("gameend") or workspace:GetServerTimeNow()) - gamestart
    
    local function Send(val,data)
        local StageInfo = {
            ["win"] = val,
            ["map"] = {
                ["name"] = tostring(workspace:GetAttribute("Mapname")),
                ["chapter"] = "0",
                ["wave"] = "0",
                ["mode"] = tostring(workspace:GetAttribute("Mode")),
                ["difficulty"] = tostring(workspace:GetAttribute("Gamemode")),
            },
        }
        setclipboard({["logs"] = val and data or {}},{["state"] = StageInfo},{["time"] = timetaken},{["Data"] = Data},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = val and data or {}},{["state"] = StageInfo},{["time"] = timetaken},{["Data"] = Data},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
    end
    if Client:GetAttribute("escaped") then
        local drop = {}
        for i,v in pairs(HttpService:JSONDecode(Client:GetAttribute("drops"))) do
            drop = convertToField(i,v)
        end
        Send(true,drop)
    else
        Send(false)
    end
end)

-- GetSomeCurrency()