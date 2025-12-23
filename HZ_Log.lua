

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
repeat task.wait() until _G.IMDONE

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local Client = Players.LocalPlayer
-- Folder
local ReplicateService =  require(ReplicatedStorage:FindFirstChild("ReplicateService",true))

local function sendkey(key,dur)
    VirtualInputManager:SendKeyEvent(true,key,false,game) task.wait(dur)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end

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
        ["BP Level"] = Data["BattlePasses"]["Level"],
        ["Level"] = Data["Exps"]["Level"],
        ["Joker Coin"] = Data["Currency"]["RaidCoin4"],
        ["Coin"] = Data["Coin"],
        ["Payload"] = Data["Currency"]["Payload"],
        ["Skill Point"] = Data["Currency"]["SkillPoint"],
        ["Pet Coin"] = Data["Currency"]["PetCoin"],
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
--[[
local Tool_ = nil
local MasteryLevel_ = 1
local MasteryExp_ = 0
local EarnedMas = 0
local EarnedLev = 0
local function settools(Tool_)
    print(Tool_)
    MasteryLevel_ = Tool_:GetAttribute("MasteryLevel") or 1
    MasteryExp_ = Tool_:GetAttribute("MasteryExp") or 0
    EarnedMas = 0
    EarnedLev = 0

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
end

task.spawn(function()
    while task.wait() do
        if Tool_ ~= Client.Character:FindFirstChildWhichIsA("Tool") then
            Tool_ = Client.Character:FindFirstChildWhichIsA("Tool")
            settools(Tool_)
        end
        task.wait(1)
    end
end)
]]
task.spawn(function ()
    local function GetCharacter()
        return Client.Character or (Client.CharacterAdded:Wait() and Client.Character)
    end
    task.spawn(function()
        while true do 
            if GetCharacter() then
                if Client.Character:FindFirstChildWhichIsA("Tool") then
                    if Client.Character:FindFirstChildWhichIsA("Tool").Name ~= Data["Weapons"][Data["selectedSlot"]["Weapons"]]["WeaponName"] then
                        sendkey("One",.1) task.wait(.4)
                    else
                        Client.Character:FindFirstChildWhichIsA("Tool"):SetAttribute("EIEI",true)
                    end
                else
                    sendkey("One",.1)
                    task.wait(1)
                end
             
            end
            task.wait(.5)
        end
    end)
    repeat task.wait() until GetCharacter() and Client.Character:FindFirstChildWhichIsA("Tool")
    local Tool_ = Client.Character:FindFirstChildWhichIsA("Tool")
    local MasteryLevel_ = Tool_:GetAttribute("MasteryLevel") or 1
    local MasteryExp_ = Tool_:GetAttribute("MasteryExp") or 0
    local EarnedMas = 0
    local EarnedLev = 0
   
    
    task.wait(.5)
   
   
    
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
                ["chapter"] = Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") and Client.Character:FindFirstChildWhichIsA("Tool").Name or Tool_ and Tool_.Name or "None",
                ["wave"] = Client.Character and Client.Character:FindFirstChildWhichIsA("Tool") and Client.Character:FindFirstChildWhichIsA("Tool"):GetAttribute("MasteryLevel") or Tool_ and Tool_:GetAttribute("MasteryLevel") or "1",
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