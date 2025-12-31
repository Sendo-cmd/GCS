local Island = {
    ["General"] = CFrame.new(1375.06812, -603.640137, 2340.38184, 0.928720474, 5.22775885e-08, -0.370780617, -3.27635945e-08, 1, 5.89280162e-08, 0.370780617, -4.25795506e-08, 0.928720474),
}
local Settings = {
    ["Duration"] = 1, -- Instant 1.5 - Normal 2.5 , Slow Depend on Fish
    ["Shake Delay"] = 0.1, -- For Config
    ["Select Island"] = "General",
    ["Method"] = "Instant", -- "Instant" , "Normal" , "Slow" , "Config" , "Legit"
    ["Legit Configs"] = {
        ["progress"] = 65, -- 65% of progress bar
        ["shake"] = .25, 
    }
}
local Changes = {
    ["06cbaf4e-7e20-4ed0-b3d4-71d14315bacb"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["a5749994-eb20-4f3c-9f71-2d89adc90801"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["6fc8af97-d123-4979-afdf-cb4ea553cd9b"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["d8b8cc80-1d7a-485d-874b-874b223d2432"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["f14e5a6f-2ceb-4290-8989-06b4fd23fae3"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["94140562-f986-4a1f-b613-96091c09d34d"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
    ["f663a980-3cb5-4227-96b7-4b8eb5da1803"] = function()
        Settings["Method"] = "Instant"
        Settings["Duration"] = 0.001
        Settings["Select Island"] = "General"
        Settings["Shake Delay"] = 0.1
        Settings["Legit Configs"] = {
        ["progress"] = 15, -- 65% of progress bar
        ["shake"] = .1, 
    }
    end,
}
setfpscap(15)
repeat  task.wait() until game:IsLoaded()
local Api = "https://api.championshop.date" -- ใส่ API ตรงนี้
local Key = "NO_ORDER" 
local PathWay = Api .. "/api/v1/shop/orders/"  -- ที่ผมเข้าใจคือ orders คือจุดกระจาย order ตัวอื่นๆ 
local Reeling_ = false
local FishCount = 0
local BreakFish = 0
local PleaseChange = false

local MainSettings = {
    ["Path_Cache"] = "/api/v1/shop/orders/cache",
    ["Path_Kai"] = "/api/v1/shop/accountskai",
}




game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local tloading = tick() + 5
local loading
repeat task.wait()
    loading = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("loading")
until tick() >= tloading or loading
task.wait(5)
while loading and loading.Parent and loading.Enabled do task.wait()
    if loading.loading.skip.Visible then
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("finishedloading"):FireServer()
        loading:Destroy()
        print("Skip")
    end
    task.wait(1)
end 

local plr = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Custom



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
    local Data = Get(Api .. "/api/v1/shop/orders/" .. plr.Name)
    if not Data["Success"] then
        return false
    end
    local Order_Data = HttpService:JSONDecode(Data["Body"])
    return Order_Data["data"][1]
end
if not Fetch_data() then
    plr:Kick("Cannot Get Data")
end
local function DecBody(body)
    return HttpService:JSONDecode(body["Body"])["data"]
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

local function BypassTeleport(cframe)
    if plr.Character then
        if plr.Character and not plr.Character.HumanoidRootPart:FindFirstChild("Body") then
            local L_1 = Instance.new("BodyVelocity")
            L_1.Name = "Body"
            L_1.Parent = plr.Character.HumanoidRootPart 
            L_1.MaxForce=Vector3.new(1000000000,1000000000,1000000000)
            L_1.Velocity=Vector3.new(0,0,0) 
        end
        plr.Character:PivotTo(cframe) task.wait(.1)
        if plr.Character and plr.Character.HumanoidRootPart:FindFirstChild("Body") then
            plr.Character.HumanoidRootPart["Body"]:Destroy()
        end
    end
end

local function SendKey(key,dur)
    VirtualInputManager:SendKeyEvent(true,key,false,game) task.wait(dur)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end
local function Shake(obj)
    while obj.Parent do task.wait()
        GuiService.SelectedCoreObject = obj task.wait(Settings["Shake Delay"] or 0.1)
        SendKey("Return",.01)
    end
end
local function Shaking(v)
    local safezone = v:WaitForChild("safezone")
    local button = safezone:FindFirstChild("button")
    if button then
        Shake(button)
    end
    local ConnectTo1 = safezone.ChildAdded:Connect(function(v1)
        if v1:IsA("ImageButton") then
            if Settings["Method"] == "Legit" then
                task.wait(Settings["Legit Configs"]["shake"])
            elseif Settings["Method"] == "Config" then
                task.wait(Settings["Shake Delay"])
            end
            Shake(v1)
        end
    end)
    while v.Parent do task.wait()

    end
    ConnectTo1:Disconnect()
end

local function Auto_Config()
    local OrderData = Fetch_data()
    if OrderData then
        Key = OrderData["id"]
    else
        print("Cannot Fetch Data")
        return false;
    end
    local ConnectToEnd 
    if Changes[OrderData["product_id"]] then
        Changes[OrderData["product_id"]]()
        print("Changed Configs")
    end
    task.spawn(function ()
        while true do
            local OrderData = Fetch_data()
            if OrderData then
                local Product = OrderData["product"]
                local Goal = Product["condition"]["value"]
                if Product["condition"]["type"] == "Coins" then
                    print(tonumber(OrderData["progress_value"]) , Goal)
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                        Post(PathWay .. "finished", CreateBody())
                    end
                elseif Product["condition"]["type"] == "hour" then
                    print(tonumber(OrderData["progress_value"]) , Goal ,OrderData["target_value"]/60/60,OrderData["target_value"])
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                        Post(PathWay .. "finished", CreateBody())
                    end
                elseif Product["condition"]["type"] == "level" then
                    print(tonumber(OrderData["progress_value"]), Goal)
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                        Post(Url..MainSettings["Path"] .. "finished")
                    end
                elseif Product["condition"]["type"] == "character" then
                    print(tonumber(OrderData["progress_value"]), Goal)
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                        Post(Url..MainSettings["Path"] .. "finished")
                    end
                elseif Product["condition"]["type"] == "items" then
                    print(tonumber(OrderData["progress_value"]), Goal)
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                        Post(Url..MainSettings["Path"] .. "finished")
                    end
                elseif Product["condition"]["type"] == "round" then
                    print(tonumber(OrderData["progress_value"]) , Goal)
                    if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                        Post(PathWay .. "finished", CreateBody())
                    end
                end
            end
            task.wait(10)
        end
    end)
end
Auto_Config()
local library = require(ReplicatedStorage.shared.modules.library);
for i,v in pairs(library.rods) do
    if type(v) == "table" then
       v["InstantCatch"] = true
    end
end
local function DistanceWithoutY(vec1,vec2)
    local Vect1 = Vector3.new(vec1.x,0,vec1.z)
    local Vect2 = Vector3.new(vec2.x,0,vec2.z)
    return (Vect1 - Vect2).Magnitude
end
plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "shakeui" then
        Shaking(v)
    end
end)
game:GetService("ReplicatedStorage").events.anno_catch.OnClientEvent:Connect(function(b)
    FishCount = FishCount + 1
    if FishCount >= 3 then
        task.delay(3,function()
            FishCount = 0
        end)
    end
    BreakFish = BreakFish + 1
end)
task.spawn(function()
    while task.wait() do
        pcall(function ()
            if DistanceWithoutY(plr.Character.HumanoidRootPart.Position,Island[Settings["Select Island"]].Position) >= 1.5 then
                BypassTeleport(Island[Settings["Select Island"]])
                task.wait(3)
            end 
        end)

    end
end)
task.spawn(function()
    while task.wait(.5) do
        pcall(function ()
            if not plr:GetAttribute("CurrentRod") or not plr.Character:FindFirstChild(plr:GetAttribute("CurrentRod")) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true,"One",false,plr.Character.HumanoidRootPart) task.wait(.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,"One",false,plr.Character.HumanoidRootPart)
                task.wait(1.5)
            end
        end)
    end
end)
_G.IMDONE =true
while task.wait() do
    if plr.Character and plr.Character:FindFirstChildWhichIsA("Tool") then
        if plr.Character:GetAttribute("Fishing") then
            print("In #1")
        elseif plr.PlayerGui:FindFirstChild("shakeui") then
            print("In #2")
        elseif plr.PlayerGui:FindFirstChild("reel") then
            print("In #3")
        else
            print("Hehe")
            task.delay(.01,function()
                local args = {
                    math.random(900,1000)/10,
                    1
                }
                game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):WaitForChild("events"):WaitForChild("castAsync"):InvokeServer(unpack(args))
            end)
        end
        task.wait(1.5)
    end
end