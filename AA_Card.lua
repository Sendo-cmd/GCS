repeat  task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Priority = {
    ["+ Range I"] = 99,
    ["- Cooldown I"] = 98,
    ["+ Attack I"] = 97,
    ["+ Range II"] = 96,
    ["- Cooldown II"] = 95,
    ["+ Attack II"] = 94,
    ["- Cooldown III"] = 92,
    ["+ Attack III"] = 91,
    ["+ New Path"] = 90,
    ["+ Gain 2 Random Effects Tier 1"] = 89,
    ["+ Gain 2 Random Effects Tier 2"] = 88,
    ["+ Gain 2 Random Effects Tier 3"] = 87,
    ["+ Boss Damage I"] = 86,
    ["+ Boss Damage II"] = 85,
    ["+ Boss Damage III"] = 84,
    ["+ Yen I"] = 83,
    ["+ Yen II"] = 82,
    ["+ Yen III"] = 81,
    ["+ Enemy Health I"] = 80,
    ["+ Enemy Health II"] = 79,
    ["+ Enemy Health III"] = 78,
    ["+ Explosive Deaths I"] = 77,
    ["+ Explosive Deaths II"] = 76,
    ["+ Explosive Deaths III"] = 75,
    ["+ Enemy Regen I"] = 74,
    ["+ Enemy Regen II"] = 73,
    ["+ Enemy Regen III"] = 72,
    ["+ Enemy Shield I"] = 23,
    ["+ Enemy Shield II"] = 22,
    ["+ Enemy Shield III"] = 21,
    ["+ Enemy Speed I"] = 20,
    ["+ Enemy Speed II"] = 19,
    ["+ Enemy Speed III"] = 18,
    ["+ Gain 2 Random Effects Tier 1"] = 17,
    ["+ Gain 2 Random Effects Tier 2"] = 16,
    ["+ Gain 2 Random Effects Tier 3"] = 15,
}
local Tick = function(sec)
    local n = tick() + sec
    repeat wait() until tick() >= n
end
local Roguelike = workspace:WaitForChild("_DATA"):WaitForChild("Roguelike"):WaitForChild("WaitingForRoguelikeChoice")
if Roguelike then
    Roguelike.Changed:Connect(function(v)
        if v then
            Tick(1)
            local GetBest = 0
            local Path = nil
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.RoguelikeSelect.Main.Main.Items:GetChildren()) do
                if v:IsA("Frame") then 
                    local conti = math.random(1,99)
                    if (Priority[v.bg.Main.Title.TextLabel.Text] or conti) > GetBest then
                        GetBest = Priority[v.bg.Main.Title.TextLabel.Text] or conti
                        Path = v
                    end
                end
            end
            for i1,v1 in pairs(getconnections(Path.Button["Activated"])) do
                v1.Function()
            end
            for i1,v1 in pairs(getconnections(Path.Confirm["Activated"])) do
                v1.Function()
            end
        end
    end)
end