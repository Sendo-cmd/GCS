repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local tloading = tick() + 5
local loading
repeat task.wait()
    loading = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("loading")
until tick() >= tloading or loading

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

local plr = game:GetService("Players").LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishCount = 0
local BreakFish = 0
local PleaseChange = false
local Settings = {
    ["Duration"] = 2.5, -- Instant 1.5 - Normal 2.5 , Slow Depend on Fish
    ["Shake Delay"] = 0.133, -- For Config
    ["Method"] = "Legit", -- "Instant" , "Normal" , "Slow" , "Config" , "Legit"
    ["Legit Configs"] = {
        ["progress"] = 65, -- 65% of progress bar
        ["shake"] = .25, 
    }
}

for i,v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v,"power") then
        task.spawn(function()
            while task.wait() do
                if PleaseChange then
                     rawset(v,"power",FishCount >= 3 and math.random(500,700)/10 or math.random(900,1000)/10)
                end
            end
        end)
    end
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
    while obj.Parent do task.wait(.01)
        GuiService.SelectedCoreObject = obj
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
local function DistanceWithoutY(vec1,vec2)
    local Vect1 = Vector3.new(vec1.x,0,vec1.z)
    local Vect2 = Vector3.new(vec2.x,0,vec2.z)
    return (Vect1 - Vect2).Magnitude
end
local function Reeling(v)
    if v then
        print(BreakFish)
        local randomreel = math.random(1,5) == 1
        if BreakFish >= 10 then
            task.wait(1)
            ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(10,false)
        else
            if Settings["Method"] == "Instant" then
                local t1 = tick() + 1.5
                while v.Parent do task.wait(.1)
                    if tick() >= t1 then
                        ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                        t1 = tick() + .1
                    end
                end
            elseif Settings["Method"] == "Normal" then
                local t1 = tick() + 2.5
                while v.Parent do task.wait(.1)
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                    if tick() >= t1 then
                        ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                        t1 = tick() + .1
                    end
                end 
            elseif Settings["Method"] == "Legit" then
                while v.Parent do task.wait(.1)
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                    if v.bar.progress.bar.Size.X.Scale >= Settings["Legit Configs"]["progress"]/100 then
                        ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                    end
                end 
            elseif Settings["Method"] == "Config" then
               local t1 = tick() + Settings["Duration"]
                while v.Parent do task.wait(.1)
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                    if tick() >= t1 then
                        ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                        t1 = tick() + .1
                    end
                end 
            elseif Settings["Method"] == "Slow" then
                while v.Parent do task.wait()
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                end
            end
        end
    end
end

plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "shakeui" then
        Shaking(v)
    end
end)
plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "reel" then
        Reeling(v)
    end
end)
game:GetService("ReplicatedStorage").events.anno_catch.OnClientEvent:Connect(function(b)
    FishCount = FishCount + 1
    BreakFish = BreakFish + 1
end)
task.spawn(function()
    while task.wait() do
        pcall(function ()
            if DistanceWithoutY(plr.Character.HumanoidRootPart.Position,Vector3.new(359.832642, 133.873108, 230.474777)) >= 5 then
                BypassTeleport(CFrame.new(359.832642, 133.873108, 230.474777, -0.00131273316, -4.51925433e-12, 0.999999166, 3.2915657e-13, 1, 4.51969018e-12, -0.999999166, 3.35089432e-13, -0.00131273316))
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

while task.wait() do
    if plr.Character and not plr.Character:GetAttribute("Fishing") and plr.Character:FindFirstChildWhichIsA("Tool") then
        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
        VirtualInputManager:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1) task.wait(.1)
        VirtualInputManager:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
    end
end