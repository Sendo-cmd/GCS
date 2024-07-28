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
   ["rbxassetid://14829421074"] = "2",
   
   ["rbxassetid://17857715386"] = "3",
   ["rbxassetid://17857715953"] = "4",
   ["rbxassetid://15326775749"] = "5",
   ["rbxassetid://18357091928"] = "6",
   ["rbxassetid://15590409028"] = "7",
   ["rbxassetid://15326775499"] = "8",
   ["rbxassetid://14823355121"] = "9",
   ["rbxassetid://17756740875"] = "10",
   ["rbxassetid://14823356966"] = "11",
   ["rbxassetid://14823356857"] = "12",
   ["rbxassetid://14823356738"] = "13",
   ["rbxassetid://14823356616"] = "14",
   
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

local function GetEventItemList()
    local ItemList = {}
    for _, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.Items.ItemList:GetChildren() do
        if v.ClassName == "Frame" then
            local itemImage = v:FindFirstChild("ItemFrame"):FindFirstChild("ItemImage")
            local itemAmount = v:FindFirstChild("ItemFrame"):FindFirstChild("ItemAmount")
            
            -- ตรวจสอบการมีอยู่ของ ItemImage และ ItemAmount
            if itemImage and itemAmount then
                local imageId = itemImage.Image
                local itemAmountText = itemAmount.Text
                
                -- ตรวจสอบว่า imageId มีการแมพใน Emoji หรือไม่
                local emojiItem = Emoji[imageId] or ""
                
                table.insert(ItemList, {
                    ItemImages = emojiItem,
                    ItemAmounts = itemAmountText
                })
            end
        end
    end
    return ItemList
end

local itemList = GetEventItemList()
for _, items in ipairs(itemList) do
    print(items.ItemImages .. "" .. items.ItemAmounts)
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

local function GetEventQuestTask()
    local QuestTasks = {}  -- ลิสต์สำหรับเก็บค่าที่พบ
    
    -- ตรวจสอบใน DailyTasks.Main
    for _, v in pairs(game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks.Main:GetChildren()) do
        if v.ClassName == "Frame" then
            -- ตรวจสอบและพิมพ์ค่า Text
            local title = v:FindFirstChild("Title")
            local progress = v:FindFirstChild("Progress")
            local refreshTimer = v:FindFirstChild("RefreshTimer")

            if title and title:IsA("TextLabel") then
                table.insert(QuestTasks, title.Text)
            end
            if progress and progress:IsA("TextLabel") then
                table.insert(QuestTasks,  progress.Text)
            end
            if refreshTimer and refreshTimer:IsA("TextLabel") then
                table.insert(QuestTasks, refreshTimer.Text)
            end
        end
    end

    -- ตรวจสอบใน DailyTasks.Main.Dailies
    local dailies = game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.DailyTasks.Main.Dailies
    for _, v in pairs(dailies:GetChildren()) do
        if v.ClassName == "Frame" then
            -- ตรวจสอบและดึงค่า Text จาก DescriptionLabel, QuestTitle, EXPLabel
            local descriptionLabel = v:FindFirstChild("DescriptionLabel")
            local questTitle = v:FindFirstChild("QuestTitle")
            local expLabel = v:FindFirstChild("EXPLabel")
            
            if descriptionLabel and descriptionLabel:IsA("TextLabel") then
                table.insert(QuestTasks, descriptionLabel.Text)
            end
            
            if questTitle and questTitle:IsA("TextLabel") then
                table.insert(QuestTasks, questTitle.Text)
            end
            
            if expLabel and expLabel:IsA("TextLabel") then
                table.insert(QuestTasks, expLabel.Text)
            end
        end
    end

    -- ตรวจสอบถ้าไม่พบค่าใดๆ
    if #QuestTasks == 0 then
        table.insert(QuestTasks, "No tasks found")
    end
    
    return QuestTasks
end

-- ทดสอบการดึงค่าของเควส
local results = GetEventQuestTask()
for _, result in ipairs(results) do
    print(result)
end

local function DisableDPSDisplay()
    local dpsDisplay = game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.SidePanel.Currencies:FindFirstChild("DPSDisplay")
    if dpsDisplay then
        dpsDisplay.Visible = false
    end
end

local function GetEventCoinsAll()
    local CoinsAll = ""
    local gui = game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.HUD.SidePanel.Currencies
    
    -- ปิด DPSDisplay
    DisableDPSDisplay()

    for _, v in gui:GetChildren() do
        if v.ClassName == "Frame" then
            local balance = v:FindFirstChild("Balance")
            if balance and balance:IsA("TextLabel") then
                -- พิมพ์ชื่อของ Frame และค่า Text ของ Balance
                print(v.Name .. ": " .. balance.Text)
            end
        end
    end
    return CoinsAll
end

print(GetEventCoinsAll())

local function GetEventSeasonPass()
    local SeasonPass = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.SeasonPass.Pass.Extra:GetChildren() do
        if v.ClassName == "Frame" then
            print(v.LevelValue.Text .." Xp ".. v.XPValue.Text)
        end
    end
    return SeasonPass
end

print(GetEventSeasonPass())

local function GetEventQuest()
    local Quest = ""
    for i, v in game:GetService("Players").GCshopSeventeen.PlayerGui.MainGui.Windows.QuestSelector.Main.QuestList:GetChildren() do
        if v.ClassName == "Frame" then
            print(v)
        end
    end
    return Quest
end

print(GetEventQuest())