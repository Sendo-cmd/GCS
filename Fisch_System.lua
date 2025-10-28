repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
-- local VIM = game:GetService('VirtualInputManager')
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
    -- local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
    -- VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
    -- VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
end 

local plr = game:GetService("Players").LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Custom
local Reeling_ = false
local ThrowBait = function ()
    print("Nothing")
end
local FishCount = 0
local BreakFish = 0
local PleaseChange = false
local Settings = {
    ["Duration"] = 1, -- Instant 1.5 - Normal 2.5 , Slow Depend on Fish
    ["Shake Delay"] = 0, -- For Config
    ["Method"] = "Instant", -- "Instant" , "Normal" , "Slow" , "Config" , "Legit"
    ["Legit Configs"] = {
        ["progress"] = 65, -- 65% of progress bar
        ["shake"] = .25, 
    }
}
-- local Settings = {
--     ["Duration"] = 2.5, -- Instant 1.5 - Normal 2.5 , Slow Depend on Fish
--     ["Shake Delay"] = 0.133, -- For Config
--     ["Method"] = "Legit", -- "Instant" , "Normal" , "Slow" , "Config" , "Legit"
--     ["Legit Configs"] = {
--         ["progress"] = 65, -- 65% of progress bar
--         ["shake"] = .25, 
--     }
-- }

-- for i,v in pairs(getgc(true)) do
--     if type(v) == "table" and rawget(v,"power") then
--         task.spawn(function()
--             while task.wait() do
--                 -- if PleaseChange then
--                      rawset(v,"power",FishCount >= 3 and math.random(500,700)/10 or math.random(900,1000)/10)
--                 -- end
--             end
--         end)
--     end
-- end 
-- for i,v in pairs(getgc(true)) do
--     if type(v) == 'function' and getinfo(v) and getinfo(v).short_src:match("rod/client") then
--         local constants = getconstants(v)
--         if constants[3] == "ClientCutsceneRunning"then
--             replaceclosure(v,function(v74)
--                 if v74.UserInputType == Enum.UserInputType.MouseButton1 or v74 == "Bypass" then
--                     print("Bypass")
--                     local args = {
--                         math.random(800,1000)/10,
--                         1
--                     }
--                     game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):WaitForChild("events"):WaitForChild("castAsync"):InvokeServer(unpack(args))
--                 end
--             end)    
--             ThrowBait = v
--         end
--         if constants[11] == "startingcast" then
--             print("Bypass #1")
--         end
--     end
-- end

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
        GuiService.SelectedCoreObject = obj task.wait(.45)
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
local function Reeling(v)
    if v then
        Reeling_ = true
        task.wait(.35)
        local randomreel = true
        if BreakFish >= 10 then
            task.wait(1)
            v.bar.playerbar.Size = UDim2.fromScale(0, 0)
            BreakFish = 0
        else
            if Settings["Method"] == "Instant" then
                local t1 = tick() + 2
                while v.Parent do task.wait(.1)
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                    if tick() >= t1 then
                        -- ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                        t1 = tick() + .5
                    end
                end
                -- Reeling_ = false
                -- for i,v in pairs(getgc(true)) do
                --     if type(v) == 'table' and rawget(v,"progress") then
                --         task.delay(.001,function ()
                --             local Stopped =false
                --             while not Stopped do task.wait()
                --                 if rawget(v,"ready") then
                --                     ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel) task.wait(.25)
                --                     Stopped = true
                --                 end
                --             end
                --         end)
                --         print(i,v)
                --     end
                -- end
            elseif Settings["Method"] == "Normal" then
                local t1 = tick() + 2.5
                while v.Parent do task.wait(.1)
                    v.bar.playerbar.Size = UDim2.fromScale(1, 1)
                    if tick() >= t1 then
                        ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,randomreel)
                        t1 = tick() + .5
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
        -- Reeling(v)
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
            if DistanceWithoutY(plr.Character.HumanoidRootPart.Position,Vector3.new(1375.06812, -603.640137, 2340.38184)) >= 1.5 then
                BypassTeleport(CFrame.new(1375.06812, -603.640137, 2340.38184, 0.928720474, 5.22775885e-08, -0.370780617, -3.27635945e-08, 1, 5.89280162e-08, 0.370780617, -4.25795506e-08, 0.928720474))
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
    if plr.Character and plr.Character:FindFirstChildWhichIsA("Tool") then
        if plr.Character:GetAttribute("Fishing") then
            -- print("In #1")
        elseif plr.PlayerGui:FindFirstChild("shakeui") then
            -- print("In #2")
        elseif plr.PlayerGui:FindFirstChild("reel") then
            -- print("In #3")
        else
            -- print("Hehe")
            local args = {
                math.random(900,1000)/10,
                1
            }
            game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):WaitForChild("events"):WaitForChild("castAsync"):InvokeServer(unpack(args))
        end
        
        task.wait(1.5)
    end
end