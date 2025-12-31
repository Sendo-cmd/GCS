-- TF_AutoQuest.lua
-- Auto Quest System (Copy from TF_System.lua farm loop)

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Plr = Players.LocalPlayer

repeat
    task.wait(15)
until getrenv()._G.ClientIsReady
task.wait(2)

-- ===== GLOBAL SETTINGS =====
_G.AutoQuest = true
_G.SelectMobs = {}   -- เซ็ตจาก Quest เช่น {"Goblin", "Slime"}
_G.SelectRocks = {}  -- เซ็ตจาก Quest เช่น {"Stone", "Copper"}
_G.QuestMode = nil   -- "Mob" หรือ "Rock" หรือ nil

-- ===== SERVICES =====
local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local PlayerController = Knit.GetController("PlayerController")
local Ores = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Ore"))
local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))

local ProximityService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService")
local DialogueService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService")
local ToolService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService")
local ForgeService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService")
local EnhanceService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("EnhanceService")
local RuneService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("RuneService")
local PortalService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PortalService")
local ChangeSequence = ForgeService:WaitForChild("RF"):WaitForChild("ChangeSequence")

-- ===== UTILITY FUNCTIONS =====
local function IsAlive()
    local Char = Plr.Character
    if not Char then return false end
    local Humanoid = Char:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return false end
    if Humanoid.Health <= 0 then return false end
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    return true
end

local function WaitForRespawn()
    while not IsAlive() do
        task.wait(0.5)
    end
    task.wait(2)
end

-- ===== FARM FUNCTIONS (Copy from TF_System.lua) =====

-- หา Rock ที่ใกล้ที่สุด (ใช้ contains match)
local function getnearest(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    
    local Rocks = workspace:FindFirstChild("Rocks")
    if not Rocks then
        print("[Quest] Rocks folder not found!")
        return nil
    end
    
    for _,v in pairs(Rocks:GetChildren()) do
        if v:IsA("Folder") then
            for i1,v1 in pairs(v:GetChildren()) do
                local Model = v1:FindFirstChildWhichIsA("Model")
                if Model and Model:GetAttribute("Health") and Model:GetAttribute("Health") > 0 then
                    local rockNameLower = Model.Name:lower()
                    local canMine = false
                    
                    if #_G.SelectRocks == 0 then
                        canMine = true
                    else
                        for _, targetName in pairs(_G.SelectRocks) do
                            local targetLower = targetName:lower()
                            -- ใช้ contains match
                            if rockNameLower:find(targetLower) or targetLower:find(rockNameLower) then
                                canMine = true
                                break
                            end
                        end
                    end
                    
                    if canMine then
                        local Pos = Model:GetAttribute("OriginalCFrame").Position
                        local EqPos = (Pos - p_pos).Magnitude
                        if dis > EqPos then
                            path = Model
                            dis = EqPos
                        end
                    end
                end
            end
        end
    end
    return path
end

-- หา Mob ที่ใกล้ที่สุด (ใช้ contains match)
local function getNearestMob(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    
    local Living = workspace:FindFirstChild("Living")
    if not Living then 
        print("[Quest] Living folder not found!")
        return nil 
    end
    
    for _, mob in pairs(Living:GetChildren()) do
        if mob:IsA("Model") then
            local Humanoid = mob:FindFirstChildOfClass("Humanoid")
            local HRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
            
            if Humanoid and HRP and Humanoid.Health > 0 then
                local canFarm = false
                local mobNameLower = mob.Name:lower()
                
                if #_G.SelectMobs == 0 then
                    canFarm = true
                else
                    for _, targetName in pairs(_G.SelectMobs) do
                        local targetLower = targetName:lower()
                        -- ใช้ contains match แทน exact
                        if mobNameLower:find(targetLower) or targetLower:find(mobNameLower) then
                            canFarm = true
                            break
                        end
                    end
                end
                
                if canFarm then
                    local EqPos = (HRP.Position - p_pos).Magnitude
                    if dis > EqPos then
                        path = mob
                        dis = EqPos
                    end
                end
            end
        end
    end
    return path
end

-- โจมตี Mob
local function AttackMob()
    pcall(function()
        ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Weapon")
    end)
end

-- ขุดหิน
local function MineRock()
    pcall(function()
        ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Pickaxe")
    end)
end

-- ===== FORGE FUNCTION =====
local function Forge(Recipe)
    ForgeService:WaitForChild("RF"):WaitForChild("StartForge"):InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Forge"))
    ChangeSequence:InvokeServer("Melt", {
        FastForge = true,
        ItemType = "Weapon"
    })
    task.wait(1)
    local Melt = ChangeSequence:InvokeServer("Melt", {
        FastForge = true,
        ItemType = "Weapon",
        Ores = Recipe
    })
    task.wait(Melt["MinigameData"]["RequiredTime"])
    local Pour = ChangeSequence:InvokeServer("Pour", {
        ClientTime = workspace:GetServerTimeNow()
    })
    task.wait(Pour["MinigameData"]["RequiredTime"])
    local Hammer = ChangeSequence:InvokeServer("Hammer", {ClientTime = workspace:GetServerTimeNow()})
    task.wait(Hammer["MinigameData"]["RequiredTime"])
    task.spawn(function()
        ChangeSequence:InvokeServer("Water", {ClientTime = workspace:GetServerTimeNow()})
    end)
    task.wait(1)
    ChangeSequence:InvokeServer("Showcase", {})
    task.wait(.5)
    ChangeSequence:InvokeServer("OreSelect", {})
    pcall(require(ReplicatedStorage.Controllers.UIController.Forge).Close)
    print("[Quest] Forge complete")
end

-- ===== DIALOGUE COMMANDS =====
local function RunCommand(cmd)
    local result = nil
    pcall(function()
        result = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer(cmd)
    end)
    return result
end

local function FinishQuest()
    return RunCommand("FinishQuest")
end

local function AcceptQuest()
    return RunCommand("AcceptQuest")
end

local function ContinueQuest()
    return RunCommand("Continue")
end

local function CheckQuestOther()
    return RunCommand("CheckQuestOther")
end

-- ===== ISLAND/TELEPORT =====
local function GetCurrentIsland()
    local result = nil
    pcall(function()
        if PlayerController and PlayerController.Replica and PlayerController.Replica.Data then
            result = PlayerController.Replica.Data.CurrentIsland or PlayerController.Replica.Data.Island
        end
    end)
    if not result then
        pcall(function()
            result = Plr:GetAttribute("CurrentIsland") or Plr:GetAttribute("Island")
        end)
    end
    return result
end

local function TeleportToIsland(islandName)
    print("[Quest] Teleport to:", islandName)
    pcall(function()
        PortalService:WaitForChild("RF"):WaitForChild("TeleportToIsland"):InvokeServer(islandName)
    end)
    task.wait(3)
    CheckQuestOther()
end

-- ===== NPC LOCATIONS =====
local NPC_LOCATIONS = {
    ["sensei moro"] = "Starter Island",
    ["moro"] = "Starter Island",
    ["blacksmith"] = "Starter Island",
    ["merchant"] = "Starter Island",
    ["greedy cey"] = "Starter Island",
    ["cey"] = "Starter Island",
    ["marbles"] = "Starter Island",
    ["captain"] = "Forgotten Kingdom",
    ["forgotten knight"] = "Forgotten Kingdom",
    ["old sage"] = "Forgotten Kingdom",
}

local MOB_LOCATIONS = {
    ["slime"] = "Starter Island",
    ["goblin"] = "Starter Island",
    ["wolf"] = "Starter Island",
    ["bandit"] = "Starter Island",
    ["skeleton"] = "Forgotten Kingdom",
    ["zombie"] = "Forgotten Kingdom",
    ["undead"] = "Forgotten Kingdom",
}

local ROCK_LOCATIONS = {
    ["stone"] = "Starter Island",
    ["copper"] = "Starter Island",
    ["iron"] = "Starter Island",
    ["coal"] = "Starter Island",
    ["gold"] = "Forgotten Kingdom",
    ["silver"] = "Forgotten Kingdom",
}

-- ===== QUEST UI FUNCTIONS =====
local function GetCurrentQuests()
    local quests = {}
    pcall(function()
        local QuestList = Plr.PlayerGui:WaitForChild("Main"):WaitForChild("Screen"):WaitForChild("Quests"):WaitForChild("List")
        for _, questFolder in pairs(QuestList:GetChildren()) do
            if questFolder:IsA("Frame") then
                for _, quest in pairs(questFolder:GetChildren()) do
                    if quest:IsA("Frame") then
                        local textLabel = quest:FindFirstChild("Main") and quest.Main:FindFirstChild("TextLabel")
                        if textLabel then
                            table.insert(quests, {
                                Name = questFolder.Name,
                                Text = textLabel.Text,
                                Frame = quest
                            })
                        end
                    end
                end
            end
        end
    end)
    return quests
end

-- Parse Quest Text
local function ParseQuest(text)
    local originalText = text
    text = text:lower()
    
    -- Talk to NPC
    if text:find("talk to") or text:find("speak to") or text:find("visit") then
        local npcName = originalText:match("[Tt]alk to ([^:]+)") or originalText:match("[Ss]peak to ([^:]+)") or originalText:match("[Vv]isit ([^:]+)")
        if npcName then
            npcName = npcName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1"):gsub("^%s*%-%s*", "")
            return "talk", npcName
        end
    end
    
    -- Help NPC
    if text:find("help") then
        local npcName = originalText:match("[Hh]elp ([%w%s]+) to") or originalText:match("[Hh]elp ([%w]+)")
        if npcName then
            npcName = npcName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1")
            return "talk", npcName
        end
    end
    
    -- Enhance
    if text:find("enhance") or text:find("upgrade") then
        local targetLevel = text:match("%+(%d+)") or text:match("to %+?(%d+)")
        return "enhance", tonumber(targetLevel) or 1
    end
    
    -- Mine
    if text:find("mine") or (text:find("collect") and (text:find("ore") or text:find("rock"))) then
        local rockName = originalText:match("[Mm]ine (%w+)") or originalText:match("[Cc]ollect (%w+)")
        local amount = text:match("(%d+)") or "1"
        return "mine", rockName, tonumber(amount)
    end
    
    -- Kill
    if text:find("kill") or text:find("defeat") or text:find("slay") then
        local mobName = originalText:match("[Kk]ill (%w+)") or originalText:match("[Dd]efeat (%w+)") or originalText:match("[Ss]lay (%w+)")
        -- Handle "undead enemies" pattern
        if text:find("undead") then
            mobName = "Undead"
        end
        local amount = text:match("(%d+)") or "1"
        return "kill", mobName, tonumber(amount)
    end
    
    -- Forge
    if text:find("forge") or text:find("craft") then
        local itemType = originalText:match("[Ff]orge a (%w+)") or originalText:match("[Cc]raft a (%w+)")
        return "forge", itemType
    end
    
    -- Travel
    if text:find("travel to") or text:find("go to") or text:find("head to") then
        local islandName = originalText:match("[Tt]ravel to ([^:]+)") or originalText:match("[Gg]o to ([^:]+)") or originalText:match("[Hh]ead to ([^:]+)")
        if islandName then
            islandName = islandName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1")
            return "travel", islandName
        end
    end
    
    -- Buy
    if text:find("buy") or text:find("purchase") then
        local itemName = originalText:match("[Bb]uy (.+)") or originalText:match("[Pp]urchase (.+)")
        if itemName then
            itemName = itemName:gsub("%d+/%d+", ""):gsub("^%s*(.-)%s*$", "%1")
            return "buy", itemName
        end
    end
    
    return "unknown", text
end

-- ===== TALK TO NPC =====
local function TweenToPosition(position)
    if not IsAlive() then return end
    local Char = Plr.Character
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local dist = (HRP.Position - position).Magnitude
    if dist < 10 then return end
    
    local tweenTime = dist / 80
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
    tween:Play()
    tween.Completed:Wait()
end

local function TalkToNPC(npcName)
    print("[Quest] Talk to NPC:", npcName)
    
    local npc = nil
    local searchName = npcName:lower():gsub("%s+", "")
    
    local function matchName(name)
        local cleanName = name:lower():gsub("%s+", "")
        return cleanName:find(searchName) or searchName:find(cleanName) or cleanName == searchName
    end
    
    -- หาจาก workspace.Proximity
    pcall(function()
        local Proximity = workspace:FindFirstChild("Proximity")
        if Proximity then
            for _, child in pairs(Proximity:GetChildren()) do
                if matchName(child.Name) then
                    npc = child
                    break
                end
            end
        end
    end)
    
    -- หาจาก workspace.NPCs
    if not npc then
        pcall(function()
            local NPCs = workspace:FindFirstChild("NPCs")
            if NPCs then
                for _, child in pairs(NPCs:GetDescendants()) do
                    if child:IsA("Model") and matchName(child.Name) then
                        npc = child
                        break
                    end
                end
            end
        end)
    end
    
    if npc then
        print("[Quest] Found NPC:", npc.Name)
        local npcPos
        if npc:IsA("BasePart") then
            npcPos = npc.Position
        elseif npc.PrimaryPart then
            npcPos = npc.PrimaryPart.Position
        elseif npc:FindFirstChild("HumanoidRootPart") then
            npcPos = npc.HumanoidRootPart.Position
        else
            local part = npc:FindFirstChildWhichIsA("BasePart")
            if part then npcPos = part.Position end
        end
        
        if npcPos then
            TweenToPosition(npcPos + Vector3.new(0, 0, 5))
            task.wait(0.5)
            
            -- Interact with NPC
            pcall(function()
                ProximityService:WaitForChild("RF"):WaitForChild("PromptTriggered"):InvokeServer(npc)
            end)
            task.wait(1)
            
            -- Try dialogue commands
            ContinueQuest()
            task.wait(0.5)
            AcceptQuest()
            task.wait(0.5)
            FinishQuest()
            task.wait(0.5)
        end
        return true
    end
    
    print("[Quest] NPC not found:", npcName)
    return false
end

-- ===== MAIN FARM LOOP (Copy from TF_System.lua) =====
local LastPrintTime = 0
task.spawn(function()
    print("[Quest] Farm Loop Started")
    while true do task.wait(0.1)
        local success, err = pcall(function()
            if not _G.AutoQuest then
                return
            end
            
            if not _G.QuestMode then
                return
            end
            
            -- Debug print ทุก 3 วินาที
            if tick() - LastPrintTime > 3 then
                print("[Quest] Farm Mode:", _G.QuestMode, "| Mobs:", table.concat(_G.SelectMobs, ","), "| Rocks:", table.concat(_G.SelectRocks, ","))
                LastPrintTime = tick()
            end
            
            if not IsAlive() then
                WaitForRespawn()
                return
            end
            
            local Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            if _G.QuestMode == "Mob" then
                local Mob = getNearestMob(Char)
                local LastAttack = 0
                local LastTween = nil
                
                if Mob then
                    print("[Quest] Found Mob:", Mob.Name, "- Moving & Attacking!")
                    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                    
                    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 do
                        task.wait(0.05)
                        
                        if not _G.AutoQuest then
                            if LastTween then LastTween:Cancel() end
                            return
                        end
                        
                        if not IsAlive() then
                            if LastTween then LastTween:Cancel() end
                            return
                        end
                        
                        Char = Plr.Character
                        if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        
                        MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                        if not MobHRP then break end
                        
                        local MobPosition = MobHRP.Position
                        local MyPosition = Char.HumanoidRootPart.Position
                        local Magnitude = (MyPosition - MobPosition).Magnitude
                        
                        local MobHeight = Mob:GetExtentsSize().Y
                        local SafePosition = MobPosition + Vector3.new(0, MobHeight + 2, 0)
                        local LookAtMob = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
                        
                        if Magnitude < 15 then
                            if LastTween then
                                LastTween:Cancel()
                            end
                            if tick() > LastAttack and IsAlive() then
                                AttackMob()
                                LastAttack = tick() + 0.2
                            end
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                Char.HumanoidRootPart.CFrame = LookAtMob
                            end
                        else
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(MobPosition)})
                                LastTween:Play()
                            end
                        end
                    end
                else
                    -- ไม่เจอ Mob - debug ทุก 3 วินาที
                    if tick() - LastPrintTime > 3 then
                        print("[Quest] No Mob found matching:", table.concat(_G.SelectMobs, ", "))
                        local Living = workspace:FindFirstChild("Living")
                        if Living then
                            local mobList = {}
                            for _, m in pairs(Living:GetChildren()) do
                                if m:IsA("Model") then
                                    local h = m:FindFirstChildOfClass("Humanoid")
                                    if h and h.Health > 0 then
                                        table.insert(mobList, m.Name)
                                    end
                                end
                            end
                            if #mobList > 0 then
                                print("[Quest] Available Mobs:", table.concat(mobList, ", "))
                            else
                                print("[Quest] No mobs alive in Living folder")
                            end
                        else
                            print("[Quest] Living folder not found!")
                        end
                    end
                    task.wait(0.5)
                end
                
            elseif _G.QuestMode == "Rock" then
                local Rock = getnearest(Char)
                local LastAttack = 0
                local LastTween = nil
                
                if Rock then
                    print("[Quest] Found Rock:", Rock.Name)
                    local Position = Rock:GetAttribute("OriginalCFrame").Position
                    
                    while Rock:GetAttribute("Health") > 0 do 
                        task.wait(0.1)
                        
                        if not _G.AutoQuest then
                            if LastTween then LastTween:Cancel() end
                            return
                        end
                        
                        if not IsAlive() then 
                            if LastTween then LastTween:Cancel() end
                            return
                        end
                        
                        Char = Plr.Character
                        if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        
                        local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
                        if Magnitude < 15 then
                            if LastTween then
                                LastTween:Cancel()
                            end
                            if tick() > LastAttack and IsAlive() then
                                MineRock()
                                LastAttack = tick() + 0.2
                            end
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 2))
                            end
                        else
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                                LastTween:Play()
                            end
                        end
                    end
                else
                    task.wait(1)
                end
            end
        end)
        
        if not success then
            print("[Quest] Farm Error:", err)
            task.wait(1)
        end
    end
end)

-- ===== PROCESS QUEST =====
local function ProcessQuest(questType, target, amount)
    print("[Quest] Processing:", questType, target, amount)
    
    if questType == "talk" then
        -- หาแมพที่ NPC อยู่แล้ว teleport
        local island = NPC_LOCATIONS[target:lower()] or NPC_LOCATIONS[target:lower():gsub("%s+", "")]
        if island then
            local currentIsland = GetCurrentIsland()
            if currentIsland and currentIsland:lower() ~= island:lower() then
                TeleportToIsland(island)
                task.wait(3)
            end
        end
        TalkToNPC(target)
        
    elseif questType == "kill" then
        -- เซ็ต _G แล้วให้ loop ทำงาน
        _G.SelectMobs = {target}
        _G.QuestMode = "Mob"
        
        -- หาแมพที่ Mob อยู่
        local island = MOB_LOCATIONS[target:lower()] or MOB_LOCATIONS[target:lower():gsub("%s+", "")]
        if island then
            local currentIsland = GetCurrentIsland()
            if currentIsland and currentIsland:lower() ~= island:lower() then
                TeleportToIsland(island)
                task.wait(3)
            end
        end
        
        print("[Quest] Killing:", target, "Amount:", amount)
        -- Loop จะทำงานเอง
        
    elseif questType == "mine" then
        -- เซ็ต _G แล้วให้ loop ทำงาน
        _G.SelectRocks = {target}
        _G.QuestMode = "Rock"
        
        -- หาแมพที่ Rock อยู่
        local island = ROCK_LOCATIONS[target:lower()] or ROCK_LOCATIONS[target:lower():gsub("%s+", "")]
        if island then
            local currentIsland = GetCurrentIsland()
            if currentIsland and currentIsland:lower() ~= island:lower() then
                TeleportToIsland(island)
                task.wait(3)
            end
        end
        
        print("[Quest] Mining:", target, "Amount:", amount)
        -- Loop จะทำงานเอง
        
    elseif questType == "forge" then
        _G.QuestMode = nil  -- หยุด farm
        print("[Quest] Forging:", target)
        -- TODO: Add forge recipe logic
        Forge({})
        
    elseif questType == "enhance" then
        _G.QuestMode = nil  -- หยุด farm
        print("[Quest] Enhancing to +", target)
        -- TODO: Add enhance logic
        
    elseif questType == "travel" then
        _G.QuestMode = nil  -- หยุด farm
        TeleportToIsland(target)
        
    elseif questType == "buy" then
        _G.QuestMode = nil  -- หยุด farm
        print("[Quest] Buying:", target)
        -- TODO: Add buy logic
    end
end

-- ===== MAIN QUEST LOOP =====
task.spawn(function()
    print("[Quest] Quest Loop Started - Waiting for _G.AutoQuest = true")
    while true do task.wait(2)
        if not _G.AutoQuest then
            -- ไม่ต้อง print ซ้ำๆ
        else
            print("[Quest] Checking quests...")
            local success, err = pcall(function()
                -- อ่าน Quest ปัจจุบัน
                local quests = GetCurrentQuests()
                print("[Quest] Found", #quests, "quests")
                
                if #quests > 0 then
                    local quest = quests[1]  -- ทำ Quest แรกก่อน
                    print("[Quest] Current:", quest.Text)
                    
                    -- Parse Quest
                    local questType, target, amount = ParseQuest(quest.Text)
                    print("[Quest] Type:", questType, "Target:", target, "Amount:", amount)
                    
                    -- Process Quest
                    ProcessQuest(questType, target or "", amount or 1)
                else
                    print("[Quest] No quests found")
                    _G.QuestMode = nil
                end
            end)
            
            if not success then
                print("[Quest] Error:", err)
            end
        end
    end
end)

print("[TF_AutoQuest] Loaded!")
