

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
repeat task.wait() until getrenv()["shared"]["loaded"] or  game:GetService("ReplicatedFirst"):FindFirstChild("Loading")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService('VirtualInputManager')

local function SendKey(key,dur)
    VirtualInputManager:SendKeyEvent(true,key,false,game) task.wait(dur)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end
local function clicking(path)
    game:GetService("GuiService").SelectedCoreObject = path task.wait(0.1)
    SendKey("Return",.01) task.wait(0.1)
end
if game:GetService("ReplicatedFirst"):FindFirstChild("Loading") then
    local function checker()
        print(game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LOADING"))
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LOADING") then
            local LOADING =  game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LOADING")
            if LOADING:FindFirstChildWhichIsA("TextButton",true) then
                clicking(LOADING:FindFirstChildWhichIsA("TextButton",true))
            end
            return not LOADING.Enabled
        end
        return true
    end
    repeat task.wait() until checker()
end

local Client = Players.LocalPlayer
-- Folder
local ReplicateService =  require(ReplicatedStorage:FindFirstChild("ReplicateService",true))


local Url = "https://api.championshop.date"
-- local List = {
--     "Coin",
--     "BattlePasses",
--     "Exps",
-- }
-- local Lists = {
--     ["BattlePasses"] = "Level",
--     ["Exps"] = {"Level","Exp"},
-- }
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
    local Data = ReplicateService.GetData()
    local Field = {
        ["BattlePass Level"] = Data["BattlePasses"]["Level"],
        ["Level"] = Data["Exps"]["Level"],
        ["Exp"] = Data["Exps"]["Exp"],
        ["Coin"] = Data["Coin"],
    } 
    
    
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
        -- warn(i,v)
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
    local Tool_ = Client.Character:FindFirstChildWhichIsA("Tool")
    local MasteryLevel_ = Tool_:GetAttribute("MasteryLevel") or 1
    local MasteryExp_ = Tool_:GetAttribute("MasteryExp") or 0
    local EarnedMas = 0
    local EarnedLev = 0
    
    Tool_:GetAttributeChangedSignal("MasteryLevel"):Connect(function()
        local MasteryLevel = Tool_:GetAttribute("MasteryLevel") or 1
        if MasteryLevel_ ~= MasteryLevel then
            EarnedLev = EarnedLev + 1
            MasteryLevel_ = MasteryLevel
        end
    end)
    Tool_:GetAttributeChangedSignal("MasteryExp"):Connect(function()
        local MasteryExp = Tool_:GetAttribute("MasteryExp") or 0
        if MasteryExp_ ~= MasteryExp then
            local minus = (MasteryExp - MasteryExp_)
            local Earned = minus < 0 and MasteryExp or minus
            EarnedMas = EarnedMas + Earned
            MasteryExp_ = MasteryExp
        end
    end)

    local LevelP_ = GetSomeCurrency()["Level"]
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
        -- setclipboard(HttpService:JSONEncode({["logs"] = val and data or {}},{["state"] = StageInfo},{["time"] = timetaken},{["Data"] = Data},{["currency"] = convertToField_(GetSomeCurrency())}))
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = val and data or {}},{["state"] = StageInfo},{["time"] = math.floor(timetaken)},{["Data"] = Data},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
    end
    if Client:GetAttribute("escaped") then
        local drop = {}   
        local LevelP = GetSomeCurrency()["Level"]
        for i,v in pairs(HttpService:JSONDecode(Client:GetAttribute("drops"))) do
            if type(i) == "string" and i:find("item_") then
                local s = i:gsub("item_","")
                drop[#drop + 1] = convertToField(s,v)
            else
                drop[#drop + 1] = convertToField(i,v)
            end
        end
        for i,v in pairs(HttpService:JSONDecode(Client:GetAttribute("stats"))) do
            if table.find({"cash","exp"},i) then
                 drop[#drop + 1] = convertToField(i,math.floor(v))
            end
        end
        drop[#drop + 1] = convertToField("Mastery",EarnedMas)
        if EarnedLev >= 1 then
            drop[#drop + 1] = convertToField("Level Mastery",EarnedLev)
        end
        if LevelP_ ~= LevelP then
            drop[#drop + 1] = convertToField("Level",1)
        end
        Send(true,drop)
    else
        print("Died")
        Send(false)
    end
end)

-- GetSomeCurrency()