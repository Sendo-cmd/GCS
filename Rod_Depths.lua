repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local loading = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("loading")

while loading and loading.Enabled do task.wait()
    if loading.Enabled and loading.loading.skip.Visible then
        local skip = loading.loading.skip
        skip.AnchorPoint = Vector2.new(.5,.5)
        skip.Position = UDim2.fromScale(.5,.5)
        skip.Size = UDim2.fromScale(9999,9999)
        print("Skip")
    end
    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
end 
print("loading")
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("assetsloaded") and game:GetService("Players").LocalPlayer.assetsloaded.Value
print("assetsloaded")

local AutoShake = true
local ShakeUI = false
local InstantFish = true

local Settings = {
    ["Rod Quest"] = "New Rod",
    ["Bestiary"] = {"Vertigo"},
    ["Method"] = "Instant", -- Hold , Instant
    ["Fish Count"] = 30,
    ["Failed Every"] = 50,
    ["Auto Sell"] = true,
}

local Configs = {
    ["Vertigo"] = {
        ["Type"] = "Special",
        ["Ignore"] = {"Isonade"},
        ["Function"] = function()
            return workspace.zones.fishing:FindFirstChild("Isonade")
        end,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-116.287933, -773.175171, 1249.52307, 0.980790615, 6.64242452e-06, -0.195063397, 2.62815725e-08, 1, 3.41847881e-05, 0.195063397, -3.35332479e-05, 0.980790615),
        ["Cage Spot"] = true,
        ["Cage"] = {
            [1] = CFrame.new(-110.5623779296875, -732.562744140625, 1208.9698486328125, -0.12402346730232239, 0, 0.9922792911529541, 0, 1, -0, -0.9922792911529541, 0, -0.12402346730232239),
            [2] = CFrame.new(-109.78691101074219, -733.1256713867188, 1212.3621826171875, -0.679056704044342, 0, 0.7340858578681946, 0, 1, -0, -0.7340859174728394, 0, -0.6790566444396973),
            [3] = CFrame.new(-105.93616485595703, -733.5018920898438, 1214.2637939453125, -0.974246084690094, 0, 0.22548745572566986, 0, 1.0000001192092896, -0, -0.22548742592334747, 0, -0.9742462038993835),
            [4] = CFrame.new(-103.19263458251953, -733.5380859375, 1213.36376953125, -0.8581687211990356, -0, -0.513367772102356, -0, 1.0000001192092896, -0, 0.5133677124977112, 0, -0.8581688404083252),
            [5] = CFrame.new(-99.75703430175781, -733.891357421875, 1211.136962890625, -0.5101168751716614, -0, -0.8601050972938538, -0, 1, -0, 0.8601050972938538, 0, -0.5101168751716614),
            [6] = CFrame.new(-100.2508544921875, -733.4586181640625, 1210.013427734375, 0.5531145930290222, 0, -0.8331052660942078, -0, 1, -0, 0.8331051468849182, 0, 0.553114652633667),
            [7] = CFrame.new(-103.97340393066406, -732.5985717773438, 1204.934814453125, 0.6484333872795105, 0, -0.7612714171409607, -0, 1, -0, 0.7612714171409607, 0, 0.6484333872795105),
            [8] = CFrame.new(-107.40616607666016, -732.9832153320312, 1203.1317138671875, 0.9486802816390991, 0, -0.3162369132041931, -0, 1, -0, 0.3162369132041931, 0, 0.9486802816390991),
            [9] = CFrame.new(-110.78844451904297, -733.8175048828125, 1202.7626953125, 0.9632145762443542, 0, 0.2687336206436157, -0, 1, -0, -0.2687336206436157, 0, 0.9632145762443542),
            [10] = CFrame.new(-112.4709243774414, -734.2554321289062, 1204.0234375, 0.4012398421764374, 0, 0.9159730672836304, -0, 1.0000001192092896, -0, -0.9159730672836304, 0, 0.4012398421764374),
            [11] = CFrame.new(-81.1644515991211, -736.7918701171875, 1210.705078125, 0.9761608839035034, 0, -0.21704840660095215, -0, 1.0000001192092896, -0, 0.21704840660095215, 0, 0.9761608839035034),
            [12] = CFrame.new(-83.14614868164062, -736.7919921875, 1209.240966796875, 0.8059407472610474, 0, 0.5919962525367737, -0, 1, -0, -0.5919962525367737, 0, 0.8059407472610474),
            [13] = CFrame.new(-83.56304168701172, -736.7918701171875, 1210.1138916015625, -0.9063321948051453, 0, 0.42256593704223633, 0, 1, -0, -0.42256593704223633, 0, -0.9063321948051453),
            [14] = CFrame.new(-81.23065948486328, -736.7918701171875, 1210.6605224609375, -0.8521823883056641, -0, -0.5232449769973755, -0, 1.0000001192092896, -0, 0.5232449769973755, 0, -0.8521823883056641),
            [15] = CFrame.new(-73.25164794921875, -736.7919311523438, 1201.5289306640625, 0.6956862807273865, 0, 0.7183458209037781, -0, 1.0000001192092896, -0, -0.7183458209037781, 0, 0.6956862807273865),
            [16] = CFrame.new(-70.86898040771484, -736.7919921875, 1203.6920166015625, 0.9611135125160217, 0, -0.2761538028717041, -0, 1.0000001192092896, -0, 0.2761538028717041, 0, 0.9611135125160217),
            [17] = CFrame.new(-113.95768737792969, -733.5438232421875, 1170.3140869140625, -0.6145231127738953, -0, -0.7888988256454468, -0, 1, -0, 0.7888989448547363, 0, -0.6145230531692505),
            [18] = CFrame.new(-114.95075988769531, -731.8487548828125, 1175.0860595703125, -0.9306821227073669, -0, -0.3658289611339569, -0, 1, -0, 0.3658289611339569, 0, -0.9306821227073669),
            [19] = CFrame.new(-116.61880493164062, -733.59619140625, 1171.90966796875, -0.8340017795562744, 0, 0.5517617464065552, 0, 1.0000001192092896, -0, -0.5517616868019104, 0, -0.834001898765564),
            [20] = CFrame.new(-120.38595581054688, -732.205322265625, 1162.775146484375, 0.9989672303199768, 0, -0.045438118278980255, -0, 1.0000001192092896, -0, 0.045438118278980255, 0, 0.9989672303199768),
            [21] = CFrame.new(-116.91490936279297, -734.92578125, 1168.0013427734375, 0.9061365723609924, 0, -0.4229852855205536, -0, 1, -0, 0.4229852855205536, 0, 0.9061365723609924),
            [22] = CFrame.new(-120.2018051147461, -737.4240112304688, 1170.3963623046875, -0.3728030323982239, 0, 0.9279105067253113, 0, 1.0000001192092896, -0, -0.9279106259346008, 0, -0.3728030025959015),
            [23] = CFrame.new(-144.14918518066406, -736.40478515625, 1217.0267333984375, -0.0274659376591444, 0, 0.9996228218078613, 0, 1.0000001192092896, -0, -0.9996228218078613, 0, -0.0274659376591444),
            [24] = CFrame.new(-146.18077087402344, -736.40478515625, 1213.4029541015625, 0.505372166633606, 0, 0.862901508808136, -0, 1.0000001192092896, -0, -0.8629016280174255, 0, 0.5053721070289612),
            [25] = CFrame.new(-144.7253875732422, -736.40478515625, 1211.187255859375, 0.9694129228591919, 0, 0.2454356700181961, -0, 1.0000001192092896, -0, -0.2454356700181961, 0, 0.9694129228591919),
            [26] = CFrame.new(-141.35733032226562, -736.40478515625, 1211.7459716796875, 0.8939444422721863, 0, -0.4481777548789978, -0, 1, -0, 0.448177695274353, 0, 0.8939445614814758),
            [27] = CFrame.new(-139.35604858398438, -736.40478515625, 1214.426025390625, 0.30298134684562683, 0, -0.952996551990509, -0, 1.0000001192092896, -0, 0.952996551990509, 0, 0.30298134684562683),
            [28] = CFrame.new(-140.22352600097656, -736.40478515625, 1219.599853515625, -0.0554201602935791, -0, -0.9984631538391113, -0, 1.0000001192092896, -0, 0.9984631538391113, 0, -0.0554201602935791),
            [29] = CFrame.new(-143.25035095214844, -736.40478515625, 1218.958984375, -0.8360427021980286, 0, 0.5486645102500916, 0, 1.0000001192092896, -0, -0.5486645102500916, 0, -0.8360427021980286),
            [30] = CFrame.new(-129.03115844726562, -736.990478515625, 1228.9423828125, 0.893092691898346, 0, -0.44987285137176514, -0, 1.0000001192092896, -0, 0.44987285137176514, 0, 0.893092691898346),
            [31] = CFrame.new(-128.02806091308594, -736.8638305664062, 1231.3905029296875, 0.24572426080703735, 0, -0.9693397879600525, -0, 1, -0, 0.9693397879600525, 0, 0.24572426080703735),
            [32] = CFrame.new(-128.61270141601562, -736.8638305664062, 1234.47216796875, -0.4665537476539612, -0, -0.8844928741455078, -0, 1, -0, 0.8844928741455078, 0, -0.4665537476539612),
            [33] = CFrame.new(-135.14398193359375, -736.8638305664062, 1238.017578125, -0.9986636638641357, 0, 0.05168185010552406, 0, 1.0000001192092896, -0, -0.05168185010552406, 0, -0.9986636638641357),
            [34] = CFrame.new(-138.67279052734375, -736.8638305664062, 1236.4794921875, -0.768333911895752, 0, 0.6400493383407593, 0, 1.0000001192092896, -0, -0.6400493383407593, 0, -0.768333911895752),
            [35] = CFrame.new(-140.38934326171875, -736.8638305664062, 1233.4818115234375, -0.20752058923244476, 0, 0.9782307147979736, 0, 1.0000001192092896, -0, -0.9782307147979736, 0, -0.20752058923244476),
            [36] = CFrame.new(-125.43831634521484, -736.9212646484375, 1248.4293212890625, 0.3768247663974762, 0, -0.9262846112251282, -0, 1.0000001192092896, -0, 0.9262846112251282, 0, 0.3768247663974762),
            [37] = CFrame.new(-124.46349334716797, -736.92138671875, 1250.3046875, -0.559307873249054, -0, -0.8289600610733032, -0, 1.0000001192092896, -0, 0.8289600610733032, 0, -0.559307873249054),
            [38] = CFrame.new(-127.56007385253906, -736.92138671875, 1251.4783935546875, -0.9756894111633301, -0, -0.21915782988071442, -0, 1.0000001192092896, -0, 0.21915780007839203, 0, -0.9756895303726196),
            [39] = CFrame.new(-128.81842041015625, -736.92138671875, 1252.2315673828125, -0.6508994698524475, 0, 0.7591639757156372, 0, 1, -0, -0.7591639757156372, 0, -0.6508994698524475),
            [40] = CFrame.new(-107.07771301269531, -731.931640625, 1274.520751953125, -0.009521489031612873, 0, 0.9999547004699707, 0, 1.0000001192092896, -0, -0.9999547004699707, 0, -0.009521489031612873),
            [41] = CFrame.new(-106.46041870117188, -731.931640625, 1268.187255859375, 0.27514633536338806, 0, 0.9614022970199585, -0, 1, -0, -0.961402416229248, 0, 0.2751463055610657),
            [42] = CFrame.new(-104.91275024414062, -731.931640625, 1267.408447265625, 0.9796304702758789, 0, 0.20080898702144623, -0, 1.0000001192092896, -0, -0.20080898702144623, 0, 0.9796304702758789),
            [43] = CFrame.new(-98.34042358398438, -731.931640625, 1266.2940673828125, 0.999908447265625, 0, 0.01353495940566063, -0, 1.0000001192092896, -0, -0.01353495940566063, 0, 0.999908447265625),
        },
    },
    
    ["The Depths"] = {
        ["Type"] = "Normal",
        ["Cage Spot"] = false,
        ["Ignore"] = {},
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(950.88324, -760.072144, 1455.11475, -0.983053923, 2.03034887e-08, 0.183316663, -3.68314823e-09, 1, -1.30507615e-07, -0.183316663, -1.28971209e-07, -0.983053923),
        ["Cage"] = {
        },
    },
    ["Brine Pool"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-1818.9519, -142.693146, -3379.55469, -0.697945058, 1.45717285e-10, 0.716151297, 1.34353018e-08, 1, 1.28902728e-08, -0.716151297, 1.86184117e-08, -0.697945058),
        ["Cage"] = {
        },
    },
    ["Spot"] = {
        ["Cage"] = CFrame.new(473.422729, 150.500015, 233.171906, 0.561099231, -4.96632468e-09, -0.827748537, 2.4843454e-09, 1, -4.31575531e-09, 0.827748537, 3.65153796e-10, 0.561099231),
        ["ReSize"] = CFrame.new(452.998932, 150.501007, 210.530563, 0.998719037, -6.43949605e-08, -0.0505997166, 6.92212652e-08, 1, 9.36296374e-08, 0.0505997166, -9.70122755e-08, 0.998719037),
        ["Sell"] = CFrame.new(466.057648, 151.002014, 221.655106, -0.99920857, 5.27215533e-08, -0.0397778861, 5.37141354e-08, 1, -2.38843398e-08, 0.0397778861, -2.60020716e-08, -0.99920857),
        ["Money"] = CFrame.new(950.88324, -785.072144, 1455.11475, -0.983053923, 2.03034887e-08, 0.183316663, -3.68314823e-09, 1, -1.30507615e-07, -0.183316663, -1.28971209e-07, -0.983053923),
        ["Abyssal"] = CFrame.new(1205.94592, -716.603271, 1316.79919, -0.747035146, -1.32305598e-08, -0.664784491, -5.45847234e-09, 1, -1.37682044e-08, 0.664784491, -6.65662503e-09, -0.747035146),
        ["Hexed"] = CFrame.new(1053.6366, -633.240051, 1319.92493, -0.0151671488, 2.11938804e-08, -0.999884963, -3.35075723e-09, 1, 2.12471463e-08, 0.999884963, 3.67263042e-09, -0.0151671488),
        ["Rod Of The Depths"] = CFrame.new(1704.98462, -902.526978, 1444.8667, -0.955516875, 6.92898183e-09, 0.294936389, 2.08239772e-08, 1, 4.39711094e-08, -0.294936389, 4.81568883e-08, -0.955516875),
        ["DepthGate"] = CFrame.new(13.6440973, -706.123718, 1224.80481, 0.209638149, -7.89109365e-08, -0.977779031, -9.93821736e-09, 1, -8.28350437e-08, 0.977779031, 2.70827663e-08, 0.209638149),
        ["Merlin"] = CFrame.new(-926.218628, 223.699966, -999.468018, -0.59410423, 3.34793846e-08, 0.804388106, -6.07307555e-08, 1, -8.64754028e-08, -0.804388106, -1.00226501e-07, -0.59410423),
    }
}
coroutine.resume(coroutine.create(function()
    while wait() do
        pcall(function() 
            game:GetService("VirtualInputManager"):SendKeyEvent(true,"W",false,game) task.wait(.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false,"W",false,game)
            wait(1000)
        end)
    end
end))
local StopFarm_ = {}

local time = tick()
local mt = getrawmetatable(game)
local plr = game:GetService("Players").LocalPlayer
local fishs = require(ReplicatedStorage.modules.library.fish)
local function Check_Cage()
    local total = 0 
    for i,v in pairs(workspace.active:GetChildren()) do
        if v.Name == plr.Name then
            total = total + 1
        end
    end
    return total
end
local function Magnitude(Pos1,Pos2)
    local pos1,pos2 = Pos1.Position,Pos2.Position
    local Vec1,Vec2 = Vector3.new(pos1.x,0,pos1.z),Vector3.new(pos2.x,0,pos2.z)
    return (Vec1 - Vec2).Magnitude
end
game:GetService'Players'.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
local KRNLONAIR = Instance.new("BodyVelocity")
KRNLONAIR.Parent = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
KRNLONAIR.Name = "KRNLONAIR"
KRNLONAIR.MaxForce = Vector3.new(100000,100000,100000)
KRNLONAIR.Velocity = Vector3.new(0,0,0)
local function Shake(obj)
    if obj:FindFirstChild("UICorner") then
        obj["UICorner"]:Destroy()
    end
    obj.BackgroundTransparency = 1
    obj.ImageTransparency = 1
    if obj:FindFirstChild("title") then
        obj:FindFirstChild("title"):Destroy()
    end
    
    local UIScale = obj:FindFirstChild("UIScale") or  Instance.new("UIScale",obj)
    UIScale.Scale = 1000
    repeat task.wait()
        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
    until not obj.Parent
end
local function ConnectToReel(v)
    if plr.PlayerGui:FindFirstChild("reel") then
        time = tick() + 2
        if Settings["Method"] == "Instant" then
            repeat wait() 
                ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,true)
            until not plr.PlayerGui:FindFirstChild("reel")
        else
            plr.PlayerGui.reel.bar.playerbar.Size = UDim2.fromScale(1, 1)
        end
    end
end
local function ConnectToShake(v)
    local safezone = v:WaitForChild("safezone")
    local v1 = safezone:WaitForChild("button")
    Shake(v1)
    local ConnectTo1 = safezone.ChildAdded:Connect(function(v1)
        if v1:IsA("ImageButton") then
            Shake(v1)
        end
    end)
    repeat
        task.wait()
        time = tick() + 1.5
    until not plr.PlayerGui:FindFirstChild(v.Name)
    ConnectTo1:Disconnect()
end
local function TalkNpc(npc)
    plr.CameraMode = Enum.CameraMode.LockFirstPerson
    local Npc = workspace.world.npcs:FindFirstChild(npc)
    local Prompt = Npc:FindFirstChildWhichIsA("ProximityPrompt",true)
    workspace.Camera.CFrame = CFrame.lookAt(workspace.Camera.CFrame.Position,Npc.HumanoidRootPart.Position + Vector3.new(0,0,0))
    Prompt.GamepadKeyCode = Enum.KeyCode.E
    game:service('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
    game:service('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
end
local FishCount = 0
local SellTheFish = false
spawn(function()
    if not Settings["Auto Sell"] then return end
    while true do task.wait()
        local val,err = pcall(function()
            if FishCount >= Settings["Fish Count"] then
                SellTheFish = true
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end
                task.wait(.3)
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end 
                if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                    
                else
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                end
                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Sell"].Position).Magnitude >= 10  then
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                else
                    if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                        local tick1 = tick() + 5
                        repeat task.wait() 
                            TalkNpc("Marc Merchant")
                            local Sell = Npc:FindFirstChild("sellall",true)
                            Sell:InvokeServer()
                        until tick() >= tick1
                        FishCount = 0
                    end
                end
            else
                SellTheFish = false
            end
        end)
        if not val then
            print("Sell : ",err)
        end
    end
end)
spawn(function()
    while true do task.wait()
        local val,err = pcall(function()
            local tuck = tick() + 1.5
            local Tool = plr.Character:FindFirstChildWhichIsA("Tool")
            if Tool and Tool:FindFirstChild("rod/client") then
                repeat
                    task.wait()
                until tick() >= tuck
                Tool["rod/client"].Enabled = false
            end
        end)
        if not val then
            print(err)
        end
    end
end)
game:GetService("ReplicatedStorage").events.anno_catch.OnClientEvent:Connect(function(b)
    FishCount = FishCount + 1
end)
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "shakeui" then
        ConnectToShake(v)
    end
end
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "reel" then
        ConnectToReel(v)
    end
end
local connect1 = plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "shakeui" then
        ConnectToShake(v)
    end
end)
local connect2 = plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "reel" then
        ConnectToReel(v)
    end
end)

-- Auto Book
local function Book(fish,justfarm)
    local Config = Configs[fish]
    local total = justfarm and {"1","2"} or {}
    local cur_ = {}
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    local AutoFish = false
    local Place = tick()
    local Position = Config["Spot"]
    local Crab = false
    local Stage = false
    local Cahce = false
    local Take_Cage = false
    local function IsStage()
        local break1 = false
        for i,v in pairs(total) do
            if table.find(Config["Ignore"],v) then
                continue;
            end
            if not table.find(cur_,v)  then
                break1 = true
            end
        end
        if break1 then
            Stage = false
        else  
            Stage = true
        end
    end
    local function IsPosition()
        if justfarm then
            return Configs["Spot"]["Money"]
        elseif Config["Type"] == "Special" then
            if not Stage then
                return Config["Spot"]
            else  
                local Isonade = Config["Function"]()
                return Isonade and Isonade.CFrame * CFrame.new(0,100,25) or Configs["Spot"]["Money"] 
            end
        else
            return Config["Spot"]
        end
    end
    local connect4,connect5,connect3
    if not justfarm then
        print("BOOK FARMING",justfarm)
        for i,v in pairs(fishs) do
            if type(v) == "table" and v["From"] == fish then
               table.insert(total,i)
            end
        end
        connect4 = workspace.zones.fishing.ChildAdded:Connect(function(v)
            IsStage()
            Position = IsPosition()
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
        end)
        connect5 = workspace.zones.fishing.ChildRemoved:Connect(function(v)
            IsStage()
            Position = IsPosition()
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
        end)
        for i,v in pairs(playerstats.Bestiary:GetChildren()) do
            if table.find(total,v.Name) then
                table.insert(cur_,v.Name)
                IsStage()
                Position = IsPosition()
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
            end
        end
        connect3 = playerstats.Bestiary.ChildAdded:Connect(function(v)
            if table.find(total,v.Name) and not table.find(cur_,v.Name) then
                table.insert(cur_,v.Name)
                IsStage()
                Position = IsPosition()
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
            end
        end)
    end
    

    
  
    plr.Character.HumanoidRootPart.CFrame = Config["Spot"]
    local tick1 = tick() + 5
    repeat task.wait() until tick() >= tick1
    spawn(function()
        if not Config["Cage Spot"] or justfarm then return end
        local function GetCageVal()
            for i,v in pairs(playerstats.Inventory:GetChildren()) do
                if v.Value == "Crab Cage"  then
                    return v["Stack"].Value
                end
            end
            return 0 
        end
        while true do task.wait()
            pcall(function()
                if SellTheFish then
                    return
                end
                if tick() >= Place then
                    if Check_Cage() < 5 and not Stage then
                        if GetCageVal() < 5 then
                            if playerstats.Stats.coins.Value >= 225 then
                                Crab = true
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end
                                task.wait(.3)
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end 
                                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Cage"].Position).Magnitude >= 5  then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Cage"]
                                else
                                    local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                                    if not prompt then
                                        fireproximityprompt(workspace.world.interactables["Crab Cage"]:FindFirstChild("purchaserompt",true)) 
                                    else
                                        prompt.amount.Text = "5"
                                        prompt.confirm.AnchorPoint = Vector2.new(.5,.5)
                                        prompt.confirm.Position = UDim2.fromScale(.5,.5)
                                        prompt.confirm.Size = UDim2.fromScale(999,999)

                                        task.wait(.2)
                                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                                    end
                                end
                            end
                        else
                            for i,v in pairs(Config["Cage"]) do 
                                local tick1 = tick() + .2
                                print(v)
                                if Check_Cage()  >= 5 then
                                    break
                                end
                                plr.Character.HumanoidRootPart.CFrame = v
                                repeat
                                    task.wait()
                                until tick() >= tick1
                                plr.Backpack:FindFirstChild("Crab Cage").Deploy:FireServer(v)
                                local tick1 = tick() + .2
                                repeat
                                    task.wait()
                                until tick() >= tick1
                            end
                            if Check_Cage() >= 5 then
                                Place = tick() + 300
                            end
                        end
                    else
                        if not Stage then
                            Crab = true
                            if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                return
                            end
                            task.wait(.3)
                            if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                return
                            end 
                            for _ = 1,3 do task.wait()
                                for i,v in pairs(workspace.active:GetChildren()) do
                                    if v.Name == plr.Name then
                                        local tick1 = tick() + 2
                                        repeat wait()
                                            plr.Character.HumanoidRootPart.CFrame = v:GetPivot() task.wait(.2)
                                        until not v or v.Parent == nil or v:FindFirstChildWhichIsA("ProximityPrompt",true) or tick() >= tick1
                                        
                                        if v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                            fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true)) 
                                        else
                                            v:Destroy()
                                        end
                                    end
                                end
                            end
                            if Check_Cage() >= 1 then
                                Place = tick() + 300
                            end
                        else
                            if Cahce then
                                print("Cahce")
                                Crab = true
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end
                                task.wait(.3)
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end 
                                for _ = 1,3 do task.wait()
                                    for i,v in pairs(workspace.active:GetChildren()) do
                                        if v.Name == plr.Name then
                                            local tick1 = tick() + 2
                                            repeat wait()
                                                plr.Character.HumanoidRootPart.CFrame = v:GetPivot() task.wait(.2)
                                            until not v or v.Parent == nil or v:FindFirstChildWhichIsA("ProximityPrompt",true) or tick() >= tick1
                                            
                                            if v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                                fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true)) 
                                            else
                                                v:Destroy()
                                            end
                                        end
                                    end
                                end 
                                if Check_Cage() <= 0 then
                                    Take_Cage = true
                                    Place = tick() + 9999999
                                end
                            end
                            if Check_Cage() >= 1 then
                                plr.Character.HumanoidRootPart.CFrame = Config["Spot"]
                                Cahce = true
                                Place = tick() + 300
                            end
                        end
                    end
                else
                    if Crab then
                        Crab = false
                    end
                end
            end)
        end
    end)
    task.wait(3)
    while #cur_ < #total or (Cahce and not Take_Cage) do task.wait()
        if justfarm and StopFarm_[justfarm] then
            cur_ = {"1","2","3"}
        end
        pcall(function()
            if plr.Character and not Crab and not SellTheFish then
                if tick() >= time then
                    -- time = tick() + .5
                    if game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt") then
                        local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                        prompt.deny.AnchorPoint = Vector2.new(.5,.5)
                        prompt.deny.Position = UDim2.fromScale(.5,.5)
                        prompt.deny.Size = UDim2.fromScale(999,999)
                        task.wait(.2)
                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                    elseif Magnitude(plr.Character.HumanoidRootPart.CFrame,Position) >= 5 then
                        plr.Character.HumanoidRootPart.CFrame = Position + Vector3.new(0,0,0)
                        print("Teleport")
                    elseif not plr.Character:FindFirstChild(playerstats.Stats.rod.Value) then
                        
                        time = tick() + 1.75
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,"One",false,plr.Character.HumanoidRootPart) task.wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"One",false,plr.Character.HumanoidRootPart)
                        -- plr.Character[playerstats.Stats.rod.Value]["rod/client"].Enabled = false
                        -- print(plr.Character[playerstats.Stats.rod.Value]["rod/client"].Enabled)
                    elseif not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                        time = tick() + 2.3
                        if not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                            -- plr.Character.HumanoidRootPart.Anchored = false
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.reset:FireServer()
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.cast:FireServer(100,1)
                        end
                    end
                end
            end
        end)
    end
    if connect3 then
        connect3:Disconnect()
    end
    if connect4 then
        connect4:Disconnect()
    end
    if connect5 then
        connect5:Disconnect()
    end
    print("Finish")
end
local function Enchant()
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    local Hexed,Abyssal = false,false
    for i,v in pairs(playerstats.Inventory:GetChildren()) do
        if v.Value == "Enchant Relic" and v:FindFirstChild("Mutation") then
            if v.Mutation.Value == "Hexed" then
                Hexed = true
            end
            if v.Mutation.Value == "Abyssal" then
                Abyssal = true
            end
        end
    end
    return not Hexed and "Hexed" or not Abyssal and "Abyssal" or "Fully"
end


if Settings["Rod Quest"] == "New Rod" then
    Book("Vertigo")
    local function GetEnchants()
        local playerstats = ReplicatedStorage["playerstats"][plr.Name]
        local Enchants = {}
        local Total = 0
        for i,v in pairs(playerstats.Inventory:GetChildren()) do
            if v.Value == "Enchant Relic" then
                Enchants[v] = {
                    ["Mutation"] = v:FindFirstChild("Mutation") and v.Mutation.Value or "None",
                    ["Stack"] = v.Stack and v.Stack.Value or 1
                }
                if v:FindFirstChild("Mutation") and (v.Mutation.Value == "Hexed" or v.Mutation.Value == "Abyssal") then
                    continue;
                end
                
            end
        end
        for i,v in pairs(Enchants) do
            Total = Total + v["Stack"]
        end
        return Enchants , Total
    end
    local function GetEnchant()
        local Enchants__ = GetEnchants()
        
        for i,v in pairs(Enchants__) do
            print(i,v,v["Mutation"])
            if v["Mutation"] == "None" then
                return i
            end
        end
        for i,v in pairs(Enchants__) do
            if v["Mutation"] ~= "Hexed" or v["Mutation"] ~= "Abyssal" then
                return i
            end
        end
        return "None"
    end
    local function GetItemFromGUI(obj)
        for i,v in pairs(plr.PlayerGui.hud.safezone.backpack.inventory.scroll.safezone:GetChildren()) do
           if v:IsA("ImageButton") and v:FindFirstChild("item") and v.item.Value == obj then
                for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                    for i1,v1 in pairs(getconnections(v[v2])) do
                        v1.Function()
                    end
                end
           end
        end
    end
    local EnchantReady = false
    local Abyssal,Hexed = false,false
    local Door = false
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    
    while not playerstats.Rods:FindFirstChild("Rod Of The Depths") do task.wait()
        local var,err = pcall(function()
            if playerstats["Inventory"] then
                if not EnchantReady then
                    print("In EnchantReady")
                    if playerstats.Stats.coins.Value >= 300000 then
                        local val,total = GetEnchants()
                        if total < 7 then
                            print("Relic")
                            repeat task.wait()
                                val,total = GetEnchants()
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Merlin"]) >= 10 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Merlin"]
                                else
                                    if workspace.world.npcs:FindFirstChild("Merlin") then
                                        TalkNpc("Marc Merchant")
                                        spawn(function()
                                            pcall(function()
                                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power"):InvokeServer()
                                            end)
                                        end)
                                    end
                                end
                            until total >= 7
                        end
                        if not plr.PlayerGui.hud.safezone.backpack.inventory.Visible then
                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                for i1,v1 in pairs(getconnections(plr.PlayerGui.hud.safezone.backpack.Open[v2])) do
                                    v1.Function()
                                end
                            end
                        end
                        plr.PlayerGui.hud.safezone.backpack.inventory.Visible = false
                        while Enchant() ~= "Fully" and playerstats.Stats.coins.Value > 449 do task.wait()
                            local Enchant_ = GetEnchant()
                           
                            
                            if Enchant_ ~= "None" then
                                repeat task.wait(.1)
                                    if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["ReSize"]) >= 5 then
                                        plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["ReSize"]
                                    else
                                        TalkNpc("Appraiser")
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            GetItemFromGUI(Enchant_)
                                        end
                                        spawn(function()
                                            pcall(function()
                                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
                                            end)
                                        end)
                                    end
                                until not Enchant_.Parent or Enchant() == "Fully" or playerstats.Stats.coins.Value < 450
                            else
                                print("BREAK")
                                break
                            end
                        end
                        print("Out The Loop 1")
                        plr.PlayerGui.hud.safezone.backpack.inventory.Visible = true
                        if Enchant() == "Fully" then
                            EnchantReady = true
                        end
                        if plr.PlayerGui.hud.safezone.backpack.inventory.Visible then
                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                for i1,v1 in pairs(getconnections(plr.PlayerGui.hud.safezone.backpack.Open[v2])) do
                                    v1.Function()
                                end
                            end
                        end
                        -- Buy Enchant And Find Abyssal , Hexed
                    else
                        local os1 = os.time()
                        StopFarm_[os1] = false
                        spawn(function() 
                            Book("The Depths",os1) 
                        end)
                        repeat task.wait() 
                            print(playerstats.Stats.coins.Value ,playerstats.Stats.coins.Value >= 750000)
                        until playerstats.Stats.coins.Value >= 300000
                        print("OutLoop Enchant")
                        StopFarm_[os1] = true
                    end
                    print("Out EnchantReady")
                else
                    print("In Rod")
                    if playerstats.Stats.coins.Value >= 750000 then
                        if not Door then
                            if game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/GetDoorState"):InvokeServer("TheDepthsGate") then
                                Door = true
                            else
                                if workspace.world.npcs:FindFirstChild("Custos") then
                                    if not plr.PlayerGui:FindFirstChild("options") then
                                        
                                        if (plr.Character.HumanoidRootPart.Position - workspace.world.npcs:FindFirstChild("Custos").HumanoidRootPart.Position).Magnitude < 5 then
                                            TalkNpc("Custos")
                                        else
                                            plr.Character.HumanoidRootPart.CFrame = workspace.world.npcs:FindFirstChild("Custos") * CFrame.new(0,0,-3)
                                        end

                                    else
                                        if not plr.Character:FindFirstChild("The Depths Key" ) then
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "The Depths Key" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        end
                                        repeat
                                            task.wait(.2)
                                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                                for i1,v1 in pairs(getconnections(plr.PlayerGui.options.safezone["1option"].button[v2])) do
                                                    v1.Function()
                                                end
                                            end
                                        until not plr.PlayerGui:FindFirstChild("options")
                                    end
                                else
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["DepthGate"]
                                end
                               
                               
                               
                            end
                             -- Open The Door ...
                        elseif not Abyssal or not Hexed then
                            if not Hexed then
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Hexed"]) >= 7 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Hexed"]
                                else
                                    if not workspace:FindFirstChild("Hexed") then return end
                                    if not workspace.Hexed:FindFirstChildWhichIsA("Model") then
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            print("Enchant Relic")
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "Enchant Relic" and v:FindFirstChild("link") and v.link.Value:FindFirstChild("Mutation") and v.link.Value.Mutation.Value == "Hexed" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            print(obj)
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        else
                                            print("Here")
                                            fireproximityprompt(workspace.Hexed.Root.Prompt) 
                                            plr.Character.Humanoid:UnequipTools()
                                        end
                                    else
                                        Hexed = true
                                    end
                                end
                            elseif not Abyssal then
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Abyssal"]) >= 7 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Abyssal"]
                                else
                                    if not workspace:FindFirstChild("Abyssal") then return end
                                    if not workspace.Abyssal:FindFirstChildWhichIsA("Model") then
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "Enchant Relic" and v:FindFirstChild("link") and v.link.Value:FindFirstChild("Mutation") and v.link.Value.Mutation.Value == "Abyssal" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        else
                                            fireproximityprompt(workspace.Abyssal.Root.Prompt) 
                                            plr.Character.Humanoid:UnequipTools()
                                        end
                                    else
                                        Abyssal = true
                                    end
                                end
                            end
                            -- Put Enchant To ...
                        else
                            if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Rod Of The Depths"].Position).Magnitude >= 5  then
                                plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Rod Of The Depths"]
                            else
                                local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                                if not prompt then
                                    fireproximityprompt(workspace.world.interactables["Rod Of The Depths"]:FindFirstChild("purchaserompt",true)) 
                                else
                                    prompt.confirm.AnchorPoint = Vector2.new(.5,.5)
                                    prompt.confirm.Position = UDim2.fromScale(.5,.5)
                                    prompt.confirm.Size = UDim2.fromScale(999,999)
    
                                    task.wait(.2)
                                    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                                    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                                    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                                end
                            end
                             -- Go To Buy Rod ...
                        end
                    else
                        local os1 = os.time()
                        StopFarm_[os1] = false
                        spawn(function() 
                            Book("The Depths",os1) 
                        end)
                        repeat task.wait()
                            print(playerstats.Stats.coins.Value ,playerstats.Stats.coins.Value >= 750000)
                        until playerstats.Stats.coins.Value >= 750000 or playerstats.Rods:FindFirstChild("Rod Of The Depths")
                        print("The Depths")
                        StopFarm_[os1] = true
                    end
                    print("Out Rod")
                end
            end
        end)
        if not var then
            print("Rod Of The Depth",err)
        end
    end
else
    for i,v in pairs(Settings["Bestiary"]) do
        Book(v)
    end
end

