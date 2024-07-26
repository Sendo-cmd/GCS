-- local ply = game:GetService("Players")
-- print(ply.GCshopSeventeen.PlayerGui.MainGui.HUD.MultFrames.Boosts.EventFrames.Luck.EventText.Text)
-- ply.GCshopSeventeen.PlayerGui.MainGui.HUD.MultFrames.Boosts.EventFrames.Luck.EventText
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Pets.PetList (Pet)
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.MultFrames.Multipliers.Multipliers (Boost)
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Items.ItemList (Inv)
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks (Progress Quest)
  -- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks.Main.Dailies (List Quest)
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.CurrentQuestFrame (Quest)
  -- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.CurrentQuestFrame.TitleFrame (List Quest and Progress)


local Emoji = {
    ["rbxassetid://14839716736"] = "",
    ["rbxassetid://14839716996"] = "",
    ["rbxassetid://1439723806"] = "",
    ["rbxassetid://14829421074"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
    ["rbxassetid://"] = "",
}

local function GetEventBoost()
    local Boost = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.MultFrames.Multipliers.Multipliers:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.ItemFrame.ItemImage.Image .." ".. v.ItemFrame.ItemAmount.Text)
        end
    end
    return Boost
end

print(GetEventBoost())

local function GetEventPetlist()
    local Petlist = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Pets.PetList:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.PetFrame.LeftSideFrame["Passive_1"].PassiveImage.Image .. " ".. v.PetFrame.LeftSideFrame["Passive_2"].PassiveImage.Image .." ".. v.PetFrame.PetName.NameText.Text)
        end
    end
    return Petlist
end

print(GetEventPetlist())

local function GetEventInv()
    local Inv = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Items.ItemList:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.ItemFrame.ItemImage.Image .." ".. v.ItemFrame.ItemAmount.Text)
        end
    end
    return Inv
end

print(GetEventInv())

local function GetEventQuestTask() --หาตัวแปลงไม่เจอ
    local QuestTask = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.RefreshTimer.RefreshTimer.Text .." ".. v.DailyQuota.Progress.Text)
        end
    end
    return QuestTask
end

print(GetEventQuestTask())

