repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
task.wait(3)
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LOADING")

local Url = "https://api.championshop.date"
local Auto_Configs = true
local IsTest = false
local MainSettings = {
    ["Path"] = "/api/v1/shop/orders/",
    ["Path_Cache"] = "/api/v1/shop/orders/cache/",
    ["Path_Kai"] = "/api/v1/shop/accountskai/",
}
local Settings = {
    ["Farm Settings"] = {
        ["Offset"] = CFrame.new(0,-5,0),
        ["Camera Viewer"] = false,
        ["Auto Skill"] = true,
    },
    ["Select Mode"] = "Normal",
    ["Normal Room Settings"] = {
        ["Select Difficulty"] = "Normal", -- Normal , Nightmare
        ["Select Map"] = "Shogun Castle",
        ["Select Mode"] = "Raid", -- Campaign , Raid
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
            ["Auto Skill"] = true,
        }
    end,
    ["64dfd949-3f2f-4ec0-b519-57185b9a64ae"] = function()
        Settings["Farm Settings"] = {
            ["Offset"] = CFrame.new(0,-5,0),
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
            ["Camera Viewer"] = true,
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
    ["rbxassetid://128397076452919"] = 1, -- bomber
    -- ["rbxassetid://89583666176634"] = 1, -- vam
    ["rbxassetid://94540545977068"] = 1.5, -- toxic
}
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local VirtualInputManager = game:GetService('VirtualInputManager')

local Client = Players.LocalPlayer
local Username = Client.Name


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
                Post(MainSettings["Path"] .. "finished", CreateBody())
            end
        elseif Product["condition"]["type"] == "character" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(MainSettings["Path"] .. "finished", CreateBody())
            end
        elseif Product["condition"]["type"] == "items" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(MainSettings["Path"] .. "finished", CreateBody())
            end
        elseif Product["condition"]["type"] == "hour" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                Post(MainSettings["Path"] .. "finished", CreateBody())
            end
        elseif Product["condition"]["type"] == "round" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                Post(MainSettings["Path"] .. "finished", CreateBody())
            end
        end
    end
end

Auto_Config()


local attacks = {[1] = "\t\006\001",[2] = "\t\004\001",[3] = "\t\a\001",[4] = "\t\t\001"}
local skills = {[1] = "\t\002\001",[2] = "\t\005\001",[3] ="\t\001\001"}
local IsFolder = ReplicatedStorage:FindFirstChild("Client")
local function SendKey(key,dur)
    VirtualInputManager:SendKeyEvent(true,key,false,game) task.wait(dur)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end
local function clicking(path)
    game:GetService("GuiService").SelectedCoreObject = path task.wait(0.1)
    SendKey("Return",.01) task.wait(0.1)
end
if IsFolder then
    local ReplicateService =  require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("ReplicateService"))
    if Settings["Select Mode"] == "Normal" then
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
                clicking(Content.options.buttons.choosemap) task.wait(.1)
                for i,v in pairs(Content["maps"]:GetChildren()) do
                    
                    if v:IsA("TextButton") and v:FindFirstChild("TextLabel") and v["Visible"] and v["TextLabel"]["Text"] == Setting["Select Map"] then
                        warn(i,v)
                        clicking(v)
                    end
                end
                clicking(Content.options.buttons.choosediffs) task.wait(.1)
                for i,v in pairs(Content["modes"]:GetChildren()) do
                    if v:IsA("TextButton") and v:FindFirstChild("TextLabel") and v["Visible"] and v["TextLabel"]["Text"] == Setting["Select Difficulty"] then
                          warn(i,v)
                        clicking(v)
                    end
                end
              
                for i = 1,6 do
                    clicking(Content.options.playerselect.F.l) task.wait()
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
    end
else
    local Countings = 1
    local Doors = Workspace:FindFirstChild("Doors",true)
    local Rooms = Workspace:FindFirstChild("Rooms",true)
    local LevelObject = ReplicatedStorage.gameStats.LevelObject.Value.Name
    local Entities = require(game:GetService("ReplicatedFirst").GameCore.Shared.EntitySimulation)
    local L_1 = Instance.new("BodyVelocity")
    L_1.Name = "Body"
    L_1.Parent = Client.Character.HumanoidRootPart 
    L_1.MaxForce=Vector3.new(1000000000,1000000000,1000000000)
    L_1.Velocity=Vector3.new(0,0,0) 
    -- game:GetService("Players").LocalPlayer.PlayerGui.MainScreen_Sibling.EndScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        
    -- end)
    local function StartOnBoss()
        Countings = Countings + 1
        repeat task.wait() until not Client.PlayerGui.LoadingMapGUI.Enabled
        task.wait(2)
        local Current = Countings
        local CurrentLevel = game:GetService("ReplicatedStorage").gameStats:GetAttribute("levelName")
        local Character = Client.Character

        task.spawn(function()
            if Settings["Farm Settings"]["Offset"] then
                for i,v in pairs(Doors.Parent:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Transparency = .9
                    end
                end
            end
        end)
        print("Boss")
        if LevelObject == "School" then
            local HeliObjective = Rooms:FindFirstChild("HeliObjective",true)
            local RadioObjective = Rooms:FindFirstChild("RadioObjective",true)

            Character.HumanoidRootPart.CFrame = RadioObjective.CFrame task.wait(.1)
            fireproximityprompt(workspace.School.Rooms:FindFirstChild("RadioObjective",true)["ProximityPrompt"])

            --workspace.School.Rooms.RooftopBoss.Chopper
        elseif game:GetService("ReplicatedStorage").OBJECTIVES:FindFirstChild("KILL_BOSS") then
            print("Nothing To do")
        elseif game:GetService("ReplicatedStorage").gameStats.LevelObject.Value.Name == "Shogun Castle" then
             Character.HumanoidRootPart.CFrame = workspace["Shogun Castle"].Rooms.IdleRoom.Building.C2.CFrame
        end
        
        task.spawn(function ()
            local counting__ = 1
            while Current == Countings do task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(attacks[counting__]),{workspace:GetServerTimeNow()}) 
                counting__ = counting__ >= 4 and 1 or counting__ + 1
                task.wait(.1)
            end
        end)
        task.spawn(function ()          
            print("Next 3")                                     
            while Current == Countings do task.wait()
                local p,c = pcall(function ()
                    for i,v in pairs(Entities["entities"]) do
                        while v["health"] > 0 and v["model"] do task.wait()
                            Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,2)
                        end
                    end
                end)
                if not p then
                    print(c)
                end
            end
            print("Next 4")
        end)
        task.spawn(function ()
            task.wait(2)
            local counting__ = 1
            while Current == Countings do 
                for i = 1,6 do task.wait()
                    game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\t\003\001"),{workspace:GetServerTimeNow()}) 
                end 
                task.wait(10)
            end
        end)
        task.spawn(function ()
            task.wait(2)
            local counting__ = 1
            while Current == Countings do 
                for i = 1,4 do task.wait()
                    if Current ~= Countings then
                        continue;
                    end
                game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(skills[counting__]),{workspace:GetServerTimeNow()}) 
                end
                counting__ = counting__ >= 3 and 1 or counting__ + 1 
                task.wait(1)
            end
        end)
    end 
    task.spawn(function ()
        while true do task.wait(1)
            game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\014")) 
        end
    end)
    
    local function Start()                                                                      
        Countings = Countings + 1
        repeat task.wait() until not Client.PlayerGui.LoadingMapGUI.Enabled

        task.wait(2)
        for i,v in pairs(workspace.DropItems:GetChildren()) do task.wait(.05)
            Client.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,-5.5,.8)   
        end 
        task.wait(2)

        local Current = Countings
        local CurrentLevel = game:GetService("ReplicatedStorage").gameStats:GetAttribute("levelName")
        local Character = Client.Character
        task.spawn(function()
            while Current == Countings do
                for i,v in pairs(Doors:GetChildren()) do
                    game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\b\001"),{v}) task.wait(.8)
                end
                task.wait(3)
            end
        end)
        task.spawn(function()
            if Settings["Farm Settings"]["Offset"] then
                for i,v in pairs(Doors.Parent:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Transparency = .9
                    end
                end
            end
        end)
        task.wait(1)
        local finding_range = {}
        local finding_bomber = {}
        local DodgeTicks = tick()
        local bomber_pass = false
        for i,v in pairs(Entities["entities"]) do
            if v["data"]["abilityData"] == "Boomie" then
                table.insert(finding_bomber,v["id"])
            end
            if v["attackRange"] > 5 and not v["data"]["abilityData"] == "Vamies" then
                table.insert(finding_range,v["id"])
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
                        -- print(Dodges[tostring(track.Animation.AnimationId)])
                        if Dodges[tostring(track.Animation.AnimationId)] then
                            print(Dodges[tostring(track.Animation.AnimationId)])
                            DodgeTicks = tick() + Dodges[tostring(track.Animation.AnimationId)]
                        end
                    end)
                end
            end
        end
        task.spawn(function ()
            for i,v in pairs(finding_bomber) do
                local ticks = tick() + .3
                local Attempt = tick() + 5
                local Buggy = 0
                local p,c = pcall(function ()
                    while Entities["entities"][v] and Entities["entities"][v]["health"] > 0 and Entities["entities"][v]["model"] do task.wait()
                        if Entities["entities"][v]["model"] then
                            if Buggy > 3 then
                                break;
                            end
                            if tick() > ticks then
                                Character.HumanoidRootPart.CFrame = CFrame.new(Entities["entities"][v]["model"].HumanoidRootPart.Position) * CFrame.new(0,-50,.8)
                                if tick() > Attempt then
                                    Attempt = tick() + 5
                                    ticks = tick() + .3
                                    Buggy = Buggy + 1
                                end
                            else
                                Character.HumanoidRootPart.CFrame = CFrame.new(Entities["entities"][v]["model"].HumanoidRootPart.Position) * CFrame.new(0,-5.3,.8) 
                            end
                        end
                    end
                end)
                if not p then
                    print(c)
                end
            end
            bomber_pass = true
            local Countings_ = 0
            while Current == Countings and Countings_ < 3 do task.wait()
                local p,c = pcall(function ()
                    for i,v in pairs(Entities["entities"]) do
                        if v["data"]["abilityData"] == "Vamies" then
                            continue;
                        end
                        while v["health"] > 0 and v["model"] do task.wait()
                             if tick() > DodgeTicks then
                                Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,1)
                                print("D")
                            else
                                Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-50,50)
                                print("D1")
                            end
                        end
                    end
                    Countings_ = Countings_ + 1
                end)
                if not p then
                    print(c)
                end
            end
            
            print("Next 3")                                     
            while Current == Countings and Countings_ < 3 do task.wait()
                local p,c = pcall(function ()
                    for i,v in pairs(Entities["entities"]) do
                        while v["health"] > 0 and v["model"] do task.wait()
                            if tick() > DodgeTicks then
                                Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-5,1)
                                print("22")
                            else
                                Character.HumanoidRootPart.CFrame = CFrame.new(v["model"].HumanoidRootPart.Position) * CFrame.new(0,-50,50)
                                print("221")
                            end
                        end
                    end
                    Countings_ = Countings_ + 1
                end)
                if not p then
                    print(c)
                end
            end
            print("Next 4")
        end)
        task.spawn(function ()
            print("Start",CurrentLevel)
            local counting__ = 1
            while Current == Countings do task.wait()
                -- if not Skill_ then
                game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(attacks[counting__]),{workspace:GetServerTimeNow()}) 
                counting__ = counting__ >= 4 and 1 or counting__ + 1
                task.wait(.1)
                -- end
            end
            print("End",CurrentLevel)
        end)    
        task.spawn(function ()
            task.wait(2)
            local counting__ = 1
            repeat task.wait() until bomber_pass
            while Current == Countings do 
                if Current ~= Countings or DodgeTicks > tick() then
                    continue;
                end
                for i = 1,4 do task.wait()
                    game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(skills[counting__]),{workspace:GetServerTimeNow()}) 
                end
                counting__ = counting__ >= 3 and 1 or counting__ + 1 
                task.wait(1)
            end
        end)
        task.wait(2)
        repeat task.wait() until Entities["entities"][1] == nil or Client.PlayerGui.LoadingMapGUI.Enabled
    end
    game:GetService("Players").LocalPlayer.PlayerGui.MainScreen.DeathScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        task.wait(5)
        game:GetService("ReplicatedStorage").external.Packets.backlobby:FireServer()
    end)
    game:GetService("Players").LocalPlayer.PlayerGui.MainScreen_Sibling.EndScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        task.wait(3)
        game:GetService("ReplicatedStorage").external.Packets.voteReplay:FireServer()
    end)
    game:GetService("ReplicatedStorage").gameStats:GetAttributeChangedSignal("levelName"):Connect(Start)
    task.spawn(function ()
        repeat
            task.wait()
        until ReplicatedStorage.OBJECTIVES:FindFirstChild("KILL_BOSS") 
        print("Boss Stages")
         StartOnBoss()
    end)
    if game:GetService("ReplicatedStorage").gameStats.LevelObject.Value.Name == "Shogun Castle" then
        print("Meow")
        StartOnBoss()
        return false
    end
    Start()
end
