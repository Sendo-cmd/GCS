local Url = "https://api.championshop.date"
local Auto_Configs = true
local IsTest = false
local MainSettings = {
    ["Path"] = "/api/v1/shop/orders/",
    ["Path_Cache"] = "/api/v1/shop/orders/cache/",
    ["Path_Kai"] = "/api/v1/shop/accountskai/",
}
-- local Settings = {
--     ["Farm Settings"] = {
--         ["Offset"] = CFrame.new(0,-5,0),
--         ["Camera Viewer"] = false,
--         ["Auto Skill"] = true,
--     },
--     ["Select Mode"] = "Normal",
--     ["Normal Room Settings"] = {
--         ["Select Difficulty"] = "Normal", -- Normal , Nightmare
--         ["Select Map"] = "Shogun Castle",
--         ["Select Mode"] = "Raid", -- Campaign , Raid
--     },
-- }
-- local Settings = {
--     ["Farm Settings"] = {
--         ["Offset"] = CFrame.new(0,-5,0),
--         ["Camera Viewer"] = false,
--         ["Auto Skill"] = true,
--     },
--     ["Select Mode"] = "Normal",
--     ["Normal Room Settings"] = {
--         ["Select Difficulty"] = "Nightmare", -- Normal , Nightmare
--         ["Select Map"] = "Island",
--         ["Select Mode"] = "Campaign", -- Campaign , Raid
--     },
-- }
local Settings = {
    ["Farm Settings"] = {
        ["Offset"] = CFrame.new(0,-5,0),
        ["Camera Viewer"] = false,
        ["Auto Skill"] = true,
    },
    ["Select Mode"] = "Normal",
    ["Normal Room Settings"] = {
        ["Select Difficulty"] = "Normal", -- Normal , Nightmare
        ["Select Map"] = "City",
        ["Select Mode"] = "Payload", -- Campaign , Raid
    },
}
local Changes = {
    ["5cb79005-75bd-4488-a38e-248be54326f5"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["6f405b16-3153-4fec-946d-f9bf9427fdff"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["ae780025-8baa-4344-8697-073bba2849bc"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["d68720e0-2c37-42e0-a796-d2707166e461"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["423fdbdb-a645-432d-abe9-3af912068fce"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["fbc6bc9b-9d6c-4c0d-85f4-124c48a3688a"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["2684ff9b-e717-46f9-9bb9-f7e41e3f8b4a"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["14c809ea-0369-421d-89c6-60cd7af5de8e"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["6061c064-0d35-4f8d-8ab7-502e01fded20"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["447f6ef9-40ea-45e3-a6c5-c07563fc4ae3"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["1295b8db-959b-4426-8af6-f1263f8d6216	"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["6d347435-c0b1-4c33-aac6-6eb1e8a264c7"] = function()
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Nightmare",
            ["Select Map"] = "Island",
            ["Select Mode"] = "Campaign",
        }
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
    end,
    ["64dfd949-3f2f-4ec0-b519-57185b9a64ae"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "Shogun Castle",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["f7d88ab0-6302-4a61-a5d0-fa59d5570ae7"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "Shogun Castle",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["e1328886-da89-45c8-8d20-d1586b6bfe8b"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "Shogun Castle",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["fe344d0c-29e2-483a-b47a-5e8910d8ea01"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "ReaperTrial",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["ae7733f-ee3b-4a2d-a380-4e6829123dc7"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "ReaperTrial",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["7b082a2e-0df5-4039-9116-f3bd50581b27"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "ReaperTrial",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["34b5794b-95e0-4aa5-93dd-9b19fb3fa5c1"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "ReaperTrial",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
    ["11ea8126-a38b-45aa-97d5-a1d1a413125a	"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = false,
            ["Auto Skill"] = true,
        }
        Settings["Select Mode"] = "Normal"
        Settings["Normal Room Settings"] = {
            ["Select Difficulty"] = "Normal", -- Normal , Nightmare
            ["Select Map"] = "ReaperTrial",
            ["Select Mode"] = "Raid", -- Campaign , Raid
        }
    end,
}
local Dodges = {
    -- ["rbxassetid://92458311611550"] = 50, -- chef
    ["rbxassetid://128397076452919"] = 1.5, -- bomber
    ["rbxassetid://89583666176634"] = 1, -- vam
    ["rbxassetid://94540545977068"] = 1.5, -- toxic
}
local GameType = {
    ["Shogun Castle"] = "Raid",
    ["ReaperTrial"] = "Raid",
    ["City"] = "Payload"
}

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedFirst = game:GetService("ReplicatedFirst")


task.wait(1)
repeat task.wait() until getrenv()["shared"]["loaded"] or ReplicatedFirst:FindFirstChild("Loading")

local Client = Players.LocalPlayer


local function sendkey(key,dur)
    VirtualInputManager:SendKeyEvent(true,key,false,game) task.wait(dur)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end
local function clicking(path)
    game:GetService("GuiService").SelectedCoreObject = path task.wait(0.1)
    sendkey("Return",.01) task.wait(0.1)
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

_G.IMDONE =true
local function Get(Url)
    local Data = request({
        ["Url"] = Url,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    return Data
end
local function Fetch_data()
    local Data = Get(Url ..MainSettings["Path"] .. Username)
    if not Data["Success"] then
        return false
    end
    local Order_Data = HttpService:JSONDecode(Data["Body"])
    return Order_Data["data"][1]
end
if not Fetch_data() and not IsTest then
    Client:Kick("Cannot Get Data")
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
local function Auto_Config(id)
    if Auto_Configs and not IsTest then
        local OrderData = Fetch_data()
        if OrderData then
            Key = OrderData["id"]
        else
            print("Cannot Fetch Data")
            return false;
        end
        if id then
            if Changes[id] then
                Changes[id]()
                print("Changed Configs")
            end 
            return false
        else
            print(OrderData["product_id"],Changes[OrderData["product_id"]])
            if Changes[OrderData["product_id"]] then
                Changes[OrderData["product_id"]]()
                print("Changed Configs")
            end 
        end
        if OrderData["want_carry"] then
            Settings["Party Mode"] = true
        end
        local Product = OrderData["product"]
        local Goal = Product["condition"]["value"]
        if Product["condition"]["type"] == "level" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(Url..MainSettings["Path"] .. "finished")
            end
        elseif Product["condition"]["type"] == "character" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(Url..MainSettings["Path"] .. "finished")
            end
        elseif Product["condition"]["type"] == "items" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(Url..MainSettings["Path"] .. "finished")
            end
        elseif Product["condition"]["type"] == "hour" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                Post(Url..MainSettings["Path"] .. "finished")
            end
        elseif Product["condition"]["type"] == "round" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(Url..MainSettings["Path"] .. "finished")
            end
        end
    end
end

Auto_Config()

if getrenv()["shared"]["loaded"] then
    local Setting = Settings[Settings["Select Mode"] .." Room Settings"]
    while true do task.wait()
        if Client.PlayerGui.GUI.StartPlaceRedo.Visible then
            print(Setting)
            local Content = Client.PlayerGui.GUI.StartPlaceRedo.Content.iContent
            clicking(Content.options.buttons.friendonly) task.wait(.1)
            clicking(Content.options.buttons.choosemodes)
            for i,v in pairs(Content["upmodes"]:GetChildren()) do
                if v:IsA("TextButton") and v:FindFirstChild("TextLabel") and v["Visible"] and v["TextLabel"]["Text"] == Setting["Select Mode"] then
                        warn(i,v) 
                    clicking(v)
                end
            end
            clicking(Content.options.buttons.choosemap) task.wait(.05)
            for i,v in pairs(Content["maps"]:GetChildren()) do
                if v:IsA("TextButton") and v:FindFirstChild("TextLabel") and v["Visible"] and v["TextLabel"]["Text"] == Setting["Select Map"] then
                    clicking(v)
                end
            end
            clicking(Content.options.buttons.choosediffs) task.wait(.05)
            for i,v in pairs(Content["modes"]:GetChildren()) do
                if v:IsA("TextButton") and v:FindFirstChild("TextLabel") and v["Visible"] and v["TextLabel"]["Text"] == Setting["Select Difficulty"] then
                    clicking(v)
                end
            end
            
            for i = 1,6 do
                clicking(Content.options.playerselect.F.l) 
            end
            clicking(Content.Button)
            task.wait(10)
        else
            for i,v in pairs(workspace.Match:GetChildren()) do
                if v.Name == "Part" and v.MatchBoard.InfoLabel.Text == "Start Here" then
                    Client.Character.HumanoidRootPart.CFrame = v.CFrame
                    firetouchinterest(Client.Character.HumanoidRootPart,v,true)
                end
            end
        end
    end
else
    print("H")
    local Doors = Workspace:FindFirstChild("Doors",true)
    local Rooms = Workspace:FindFirstChild("Rooms",true)
    local Enemy = nil
    local CanSkill = true
    local DodgeTicks = tick()
    local GameStats = ReplicatedStorage:WaitForChild("gameStats")
    local LevelObject = GameStats:WaitForChild("LevelObject")
    local GameCore = ReplicatedFirst:WaitForChild("GameCore")
    local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")
    local Entities = require(GameCore.Shared.EntitySimulation)
   
    local L_1 = Instance.new("BodyVelocity")
    L_1.Name = "Body"
    L_1.Parent = Client.Character.HumanoidRootPart 
    L_1.MaxForce=Vector3.new(1000000000,1000000000,1000000000)
    L_1.Velocity=Vector3.new(0,0,0) 
    game:GetService("Players").LocalPlayer.PlayerGui.MainScreen.DeathScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        task.wait(7.5)
        game:GetService("ReplicatedStorage").external.Packets.voteReplay:FireServer()
    end)
    game:GetService("Players").LocalPlayer.PlayerGui.MainScreen_Sibling.EndScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        task.wait(7.5)
        game:GetService("ReplicatedStorage").external.Packets.voteReplay:FireServer()
    end)
    local function GetCharacter()
        return Client.Character or (Client.CharacterAdded:Wait() and Client.Character)
    end
    for i,v in pairs(Doors.Parent:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = .9
        end
    end
    if Workspace:FindFirstChild("IdleRoom",true) then
        print("H1")
        local IdleRoom = Workspace:FindFirstChild("IdleRoom",true)
        task.spawn(function ()                                             
            while true do task.wait()
                local p,c = pcall(function ()
                    local Character = GetCharacter()
                    if #Entities["entities"] <= 0 then
                        Character.HumanoidRootPart.CFrame = IdleRoom:FindFirstChild("C2",true).CFrame task.wait(1)
                        Character.HumanoidRootPart.CFrame = IdleRoom:FindFirstChild("C2",true).CFrame * CFrame.new(0,50,0)
                    else
                        for i,v in pairs(Entities["entities"]) do
                            while v["health"] > 0 and v["model"] do task.wait()
                                Enemy = v
                                Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,2)
                            end
                            Enemy = nil
                        end
                    end  
                end)
                if not p then
                end
            end
        end)
    elseif GameType[LevelObject.Value.Name] == "Payload" then
        print("H2")
        local PauseToTakeItem = false
        local Pickup = false
        local BreakToKill = tick() + 10
        local BreakToKill_ = false
        local Base = Workspace:FindFirstChild("BASE",true)

        local function NearestPipe()
            for i,v in pairs(workspace.Props:GetChildren()) do
                if v.Name == "Pipe" and (v:GetPivot().Position - Base:GetPivot().Position).Magnitude < 25 then
                    return v
                end
            end 
            return false
        end
        task.spawn(function ()                                             
            while true do task.wait(.2)
               local p,c = pcall(function ()
                    local Character = GetCharacter()
                    if workspace.Terrain:FindFirstChild("Wheel") then
                        Enemy = nil
                        PauseToTakeItem = true
                        local Wheel = workspace.Terrain.Wheel
                        while Wheel.Parent do
                            if not Pickup and not BreakToKill_ then
                                Character.HumanoidRootPart.CFrame = Wheel:GetPivot()
                                if Wheel:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                    local Prompt = Wheel:FindFirstChildWhichIsA("ProximityPrompt",true)
                                    Prompt.GamepadKeyCode = Enum.KeyCode.E
                                    Prompt.RequiresLineOfSight = false
                                    Prompt.MaxActivationDistance = 150
                                    Prompt.HoldDuration = 0
                                    print(Prompt)
                                    sendkey("E",.01)
                                end
                            end
                            task.wait()
                        end
                    elseif NearestPipe() then
                        local Pipe = NearestPipe()
                        PauseToTakeItem = true
                        while Pipe.Parent do task.wait()
                            if not Pickup and not BreakToKill_ then
                                Character.HumanoidRootPart.CFrame = Pipe:GetPivot()
                                Enemy = true
                            else
                                Enemy = nil
                            end
                        end
                        Enemy = nil
                    else
                        Enemy = nil
                        PauseToTakeItem = false
                    end
               end)
                if not p then
                    print(p,c)
                end
            end
        end)
        task.spawn(function ()                                             
            while true do task.wait()
               local p,c = pcall(function ()
                    if Client.PlayerGui.Plyload.BUFF.Visible then
                        task.wait(1)
                        for i,v in pairs(Client.PlayerGui.Plyload.BUFF.Items:GetChildren()) do
                            if v:IsA("TextButton") and v.Name:match("Strength") then
                                clicking(v)
                                return false
                            end
                        end
                        task.wait(1)
                        if Client.PlayerGui.Plyload.BUFF.Visible then
                            for i,v in pairs(Client.PlayerGui.Plyload.BUFF.Items:GetChildren()) do
                                if v:IsA("TextButton") then
                                    clicking(v)
                                    return false
                                end
                            end
                        end
                       
                    end
               end)
                if not p then
                end
            end
        end)
        task.spawn(function ()                                             
            while true do task.wait()
               local p,c = pcall(function ()
                    if tick() >= BreakToKill or Client.PlayerGui.Plyload.BUFF.Visible then
                        print("Killing Mob")
                        local Character = GetCharacter()
                        local KillMob = tick() + 10 
                        BreakToKill_ = true
                        for i,v in pairs(Entities["entities"]) do
                            while v["health"] > 0 and v["model"] and KillMob > tick() do task.wait()
                                if not Pickup then
                                    _G.Attacks()
                                    Character.HumanoidRootPart.CFrame = v["model"].HumanoidRootPart.CFrame * CFrame.new(0,0,2.5)
                                end
                            end
                        end
                        print("Stop Kill Mob")
                        BreakToKill_ = false
                        BreakToKill = tick() + 15
                    end
               end)
                if not p then
                end
            end
        end)
        
        task.spawn(function ()      
            local realfolder = nil     
            while not realfolder do task.wait(.2)
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name == "Items" and v:FindFirstChildWhichIsA("MeshPart") then
                        realfolder = v
                        break;
                    end
                end
            end
            while true do task.wait()
                local p,c = pcall(function ()
                    local Character = GetCharacter()
                    for i,v in pairs(realfolder:GetChildren()) do
                        if v:IsA("MeshPart") then
                            Pickup = true
                            Character.HumanoidRootPart.CFrame = v.PickupHitbox.CFrame task.wait(.1)
                            Pickup = false
                        end
                    end
                end)
            end
        end)
        task.spawn(function ()                                             
            while true do task.wait()
                local p,c = pcall(function ()
                    if not PauseToTakeItem and not BreakToKill_ and not Pickup then
                        local Character = GetCharacter()
                        Character.HumanoidRootPart.CFrame = Base:GetPivot()
                    end
                end)
            end
        end)
    else
        print("H3")
        local PauseToTakeItem = false
        local function Checker()
            repeat task.wait() until not Client.PlayerGui.LoadingMapGUI.Enabled
            PauseToTakeItem = true
            for i,v in pairs(workspace.DropItems:GetChildren()) do task.wait(.12)
                if v:FindFirstChild("PointLight") and v.PointLight.Color == Color3.fromRGB(255, 236, 28) then
                    while v.Parent do task.wait(.1)
                        Client.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,-5.5,.8)    
                    end
                end
            end 
            for i,v in pairs(Entities["entities"]) do
                if v["attackRange"] > 5 then
                    if v["model"] then
                        local Connection = {}
                        Connection[#Connection + 1] = v["model"]:GetPropertyChangedSignal("Parent"):Connect(function ()
                            if not v or not v["model"] or not v["model"]["Parent"] or v["model"]["Parent"] == nil then
                                for i1,v1 in pairs(Connection) do
                                    v1:Disconnect()
                                end
                            end
                        end)
                        Connection[#Connection + 1] = v["model"]["AnimationController"]["AnimationPlayed"]:Connect(function(track)
                            if Dodges[tostring(track.Animation.AnimationId)] then
                                print(Dodges[tostring(track.Animation.AnimationId)])
                                DodgeTicks = tick() + Dodges[tostring(track.Animation.AnimationId)]
                            end
                        end)
                    end
                end
            end
            task.wait(.1)
            GetCharacter().HumanoidRootPart.CFrame *= CFrame.new(0,100,0)
            for i,v in pairs(Doors:GetChildren()) do
                game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\b\001"),{v}) task.wait(.8)
            end
            task.wait(1)
            PauseToTakeItem = false
        end
        -- GetCharacter().HumanoidRootPart.CFrame *= CFrame.new(0,100,0)
        game:GetService("ReplicatedStorage").gameStats:GetAttributeChangedSignal("levelName"):Connect(Checker)
        Checker()
        task.spawn(function ()                                             
            while true do task.wait()
               local p,c = pcall(function ()
                    if not PauseToTakeItem then
                        local Character = GetCharacter()
                        for i,v in pairs(Entities["entities"]) do
                            while v["health"] > 0 and v["model"] do task.wait()
                                if v["data"]["abilityData"] == "Boomie" then
                                    Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,1)
                                    task.wait(.5)
                                    Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,50,60)
                                    task.wait(1)
                                else
                                    if tick() > DodgeTicks then
                                        Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,1)
                                        -- print("D")
                                        Enemy = v
                                    else
                                        Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,50,60)
                                        print("D1")
                                        Enemy = nil
                                    end
                                end
                               
                            end
                            Enemy = nil
                        end
                    else
                        Enemy = nil
                    end
               end)
                if not p then
                end
            end
        end)
    end
    task.spawn(function()
        local attacks = {
            [1] = "\t\006\001",
            [2] = "\t\004\001",
            [3] = "\t\a\001",
            [4] = "\t\t\001"
        }
        local skills = {
            [1] = "\t\002\001",
            [2] = "\t\005\001",
            [3] = "\t\001\001",
            [4] = "\t\b\001",
        }

        local insertforWP = {}
        local insertforSkill = {}
        local WeaponModule = function(name)
            return require(GameCore.Shared.AbilityService.CombatData[name])
        end
        local function GetWeapon(parent)
            if not parent then return false end
            local Tool = parent:FindFirstChildWhichIsA("Tool")
            if Tool then
                return Tool
            end
            return nil
        end
        local function GetAttackCD(weapon)
            local WP = insertforWP[weapon.Name]
            for i,v in pairs(attacks) do
                -- print(i,WP[tostring(i)])
                if workspace:GetServerTimeNow() >=  (weapon:GetAttribute("lastActivated"..tostring(WP[tostring(i)][2])) or 0) + 2 then
                    return buffer.fromstring(v)
                end
            end
            return false
        end
        local function GetSkillCD(weapon)
            for i,v in pairs(insertforSkill[weapon.Name]) do
                if workspace:GetServerTimeNow() >= (weapon:GetAttribute("lastActivated"..tostring(v[2])) or 0) + v[3] then
                    -- warn(v[1])
                    return buffer.fromstring(skills[tonumber(v[1])])
                end
            end
            return false
        end
        local function GetPerkCD(char)
            local Perk = false
            local At = char:GetAttribute("perkMeter")
            if At then
                if At >= char:GetAttribute("maxPerkMeter") then
                    Perk = true
                end
            elseif workspace:GetServerTimeNow() >= (char:GetAttribute("lastPerk") + char:GetAttribute("perkCooldown")) then
                Perk = true
            end
            return not char:GetAttribute("perkActiveUntil") and Perk
        end
        local function GetUlt(weapon)
            local Can_Attack = nil
            if weapon:GetAttribute("AwakenMeter") >= weapon:GetAttribute("MaxAwakenMeter") then
                Can_Attack = true
            end
            return Can_Attack
        end
        function _G.Attacks()
            local Character = GetCharacter()
            local CurrentWeapon = GetWeapon(Character)
            local GetAttack = GetAttackCD(CurrentWeapon)
            if GetAttack then
                ByteNetReliable:FireServer(GetAttack,{workspace:GetServerTimeNow()}) 
            end
        end
        -- Insert DATA
        local Character = GetCharacter()
        local Backpack = Client.Backpack

        local WeaponTool = {
            GetWeapon(Character),
            GetWeapon(Backpack)
        }
        for i,v in pairs(WeaponTool) do
            local data = WeaponModule(v.Name)
            for i1,v1 in pairs(data["abilityIndexes"]) do
                if v1:find("l") then
                    if not insertforWP[v.Name] then
                        insertforWP[v.Name] = {}
                    end
                    if attacks[tonumber(v1:match("%d+"))] then
                        insertforWP[v.Name][v1:match("%d+")] = {
                            [1] = v1:match("%d+"),
                            [2] = tonumber(i1),
                            [3] = .87
                        }
                    end
                end
                if v1:find("sp") and v1:find("%d+") then
                    if not insertforSkill[v.Name] then
                        insertforSkill[v.Name] = {}
                    end

                    if skills[tonumber(v1:match("%d+"))] then
                        if tonumber(v1:match("%d+")) == 4 and tonumber(v:GetAttribute("MasteryLevel")) < 100 then
                            continue;
                        end
                        insertforSkill[v.Name][v1:match("%d+")] = {
                            [1] = v1:match("%d+"),
                            [2] = tonumber(i1),
                            [3] = data["abilities"][v1]["cooldown"],
                        }
                    end
                end
            end
        end
        task.spawn(function ()
            local LastUsedSkill = tick()
            while true do 
                pcall(function()
                    if Enemy then
                        local Character = GetCharacter()
                        local CurrentWeapon = GetWeapon(Character)
                        local GetAttack = GetAttackCD(CurrentWeapon)
                        local GetSkill = GetSkillCD(CurrentWeapon)
                        local GetPassiveSkill = GetPerkCD(Character)
                        local GetUlt = GetUlt(CurrentWeapon)
                        if GetUlt then
                            ByteNetReliable:FireServer(buffer.fromstring("\t\003\001"),{workspace:GetServerTimeNow()}) 
                            -- warn("Ult")
                        elseif GetPassiveSkill then
                            -- warn("Pass")
                            ByteNetReliable:FireServer(buffer.fromstring("\014"))
                        elseif tick() >= LastUsedSkill and GetSkill and CanSkill then
                            -- warn("Skill",GetSkill)
                            ByteNetReliable:FireServer(GetSkill,{workspace:GetServerTimeNow()}) 
                        elseif GetAttack then
                            -- warn("Atk",GetAttack)
                            ByteNetReliable:FireServer(GetAttack,{workspace:GetServerTimeNow()}) 
                        else
                            -- print("Nothing")
                        end
                    end
                end)
                task.wait()
            end
        end)
    end)
end




