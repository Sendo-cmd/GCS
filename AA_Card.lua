repeat  task.wait(10) until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Priority = {
    ["+ New Path"] = 100,
    ["+ Double Attack"] = 99,
    ["+ Double Range"] = 96,
    ["+ Range I"] = 98,
    ["+ Range II"] = 91,
    ["+ Range III"] = 86,
    ["+ Cooldown I"] = 93,
    ["+ Cooldown II"] = 89,
    ["+ Cooldown III"] = 83,
    ["+ Attack I"] = 97,
    ["+ Attack II"] = 90,
    ["+ Attack III"] = 84,
    ["+ Random Blessings I"] = 76,
    ["+ Random Blessings II"] = 88,
    ["+ Random Blessings III"] = 85,
    ["+ Boss Damage I"] = 92,
    ["+ Boss Damage II"] = 87,
    ["+ Boss Damage III"] = 77,
    ["+ Yen I"] = 88,
    ["+ Yen II"] = 81,
    ["+ Yen III"] = 78,
    ["+ Active Cooldown I"] = 82,
    ["+ Active Cooldown II"] = 79,
    ["+ Active Cooldown III"] = 80,
    ["+ Enemy Health I"] = 95,
    ["+ Enemy Health II"] = 12,
    ["+ Enemy Health III"] = 13,
    ["+ Explosive Deaths I"] = 94,
    ["+ Explosive Deaths II"] = 14,
    ["+ Explosive Deaths III"] = 15,
    ["+ Enemy Regen I"] = 11,
    ["+ Enemy Regen II"] = 10,
    ["+ Enemy Regen III"] = 9,
    ["+ Enemy Shield I"] = 8,
    ["+ Enemy Shield II"] = 7,
    ["+ Enemy Shield III"] = 6,
    ["+ Enemy Speed I"] = 5,
    ["+ Enemy Speed II"] = 4,
    ["+ Enemy Speed III"] = 3,
    ["+ Random Curses I"] = 2,
    ["+ Random Curses II"] = 1,
    ["+ Random Curses III"] = 0,
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