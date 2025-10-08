repeat task.wait(30) until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")





local plr = game:GetService("Players").LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = {
    ["Duration"] = 2.5, -- Instant 1.5 - Normal 2.5 , Slow Depend on Fish
    ["Method"] = "Normal", -- "Instant" , "Normal" , "Slow"
}

for i,v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v,"power") then
        task.spawn(function()
            while task.wait() do
                rawset(v,"power",math.random(950,1000)/10)
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
            task.wait(.15)
            Shake(v1)
        end
    end)
    while v.Parent do task.wait()

    end
    ConnectTo1:Disconnect()
end
local function Reeling(v)
    if v then
        if Settings["Method"] == "Instant" then
            local t1 = tick() + 1.5
            while v.Parent do task.wait()
                if tick() >= t1 then
                    ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,true)
                    t1 = tick() + .1
                end
            end
        elseif Settings["Method"] == "Normal" then
            local t1 = tick() + 3.5
            while v.Parent do task.wait()
                plr.PlayerGui.reel.bar.playerbar.Size = UDim2.fromScale(1, 1)
                if tick() >= t1 then
                    ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,true)
                    t1 = tick() + .1
                end
            end 
        elseif Settings["Method"] == "Slow" then
            while v.Parent do task.wait()
                plr.PlayerGui.reel.bar.playerbar.Size = UDim2.fromScale(1, 1)
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
task.spawn(function()
    while task.wait(3) do
        pcall(function ()
           BypassTeleport(CFrame.new(-3614.44507, 134.806122, 554.73114, -0.162437394, 6.45406928e-08, 0.986718833, -1.02886357e-08, 1, -6.71031586e-08, -0.986718833, -2.10520543e-08, -0.162437394))
        end)
    end
end)
while task.wait() do
    print(plr.Character , not plr.Character:GetAttribute("Fishing") , not plr.Character:GetAttribute("Reeling"))
    if plr.Character and not plr.Character:GetAttribute("Fishing") and plr.Character:FindFirstChildWhichIsA("Tool") then
        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
        VirtualInputManager:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1) task.wait(.1)
        VirtualInputManager:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
    end
end