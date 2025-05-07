repeat wait() until game:IsLoaded()

local plr = game:GetService("Players").LocalPlayer
local Characters = workspace:WaitForChild("Characters")

local function ConnectToPrompt(c)
    if not c:GetAttribute("connect_1") and c.Name ~= plr.Name then
        c.ChildAdded:Connect(function(v)
            if v.Name == "CidStunPrompt" then
                task.wait(.1)
                -- v.MaxActivationDistance = 999999
                plr.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                fireproximityprompt(v)
                print(c.Name)
            end
        end)
        c:SetAttribute("connect_1",true)
    end
end

for i,v in pairs(Characters:GetChildren()) do
    ConnectToPrompt(v)
end
Characters.ChildAdded:Connect(function(v)
    ConnectToPrompt(v)
end)
print("Executed")