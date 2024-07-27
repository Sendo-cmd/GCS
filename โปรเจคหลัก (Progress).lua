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
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.SidePanel.Currencies (Show Coins all)
-- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.SeasonPass.Pass (Pass)  
   -- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.SeasonPass.Pass.Header (HearderPass)
   -- game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.SeasonPass.Pass.Extra (LevelPass)

local Emoji = { --แอด emoji
    ["rbxassetid://14839716736"] = "<:Blessed:1237372494281965580>",
    ["rbxassetid://14839716996"] = "<:BlackHole:1237372491496820736>",
    ["rbxassetid://14839723806"] = "Qooe",
    ["rbxassetid://14829421074"] = "Pood",
}

local function GetEventPetlist()
    local Petlist = {}
    for _, v in ipairs(game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Pets.PetList:GetChildren()) do
        if v.ClassName == "Frame" then
            local passive1Image = v.PetFrame.LeftSideFrame["Passive_1"].PassiveImage.Image
            local passive2Image = v.PetFrame.LeftSideFrame["Passive_2"].PassiveImage.Image
            local petName = v.PetFrame.PetName.NameText.Text

            -- ตรวจสอบว่า passive1Image และ passive2Image มีการแมปใน Emoji หรือไม่
            local emoji1 = Emoji[passive1Image] or ""
            local emoji2 = Emoji[passive2Image] or ""

            table.insert(Petlist, {
                Passive1Image = emoji1,
                Passive2Image = emoji2,
                PetName = petName
            })
        end
    end
    return Petlist
end

local petList = GetEventPetlist()
for _, pet in ipairs(petList) do
    print(pet.Passive1Image .. "" .. pet.Passive2Image .. " " .. pet.PetName)
end

local function GetEventBoost()
    local Boost = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.MultFrames.Multipliers.Multipliers:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.MultName.Text .." ".. v.MultValue.Text)
        end
    end
    return Boost
end

print(GetEventBoost())

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

local function GetEventQuestTask()
    local QuestTask = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks.Main:GetChildren() do
        if v.ClassName == "Frame" then
            print("Daily Tasks" .." ".. v.RefreshTimer.Text)
        end
    end
    return QuestTask
end

print(GetEventQuestTask())

local function GetEventCoinsAll()
    local CoinsAll = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.SidePanel.Currencies:GetChildren() do
        if v.ClassName == "Frame" then
            print(v)
        end
    end
    return CoinsAll
end

print(GetEventCoinsAll())

local function GetEventSeasonPass() --ยังหาค่าไม่เจอ
    local SeasonPass = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.SeasonPass.Pass:GetChildren() do
        if v.ClassName == "Frame" then
            print(v)
        end
    end
    return SeasonPass
end

print(GetEventSeasonPass())