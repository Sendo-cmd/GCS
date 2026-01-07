-- TF_Quest.lua
-- Auto Quest System

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
local EnhanceUI = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("EnhanceUI"))
local RuneUI = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("RuneUI"))

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

local function TweenTo(Position, Speed)
    Speed = Speed or 80
    if not IsAlive() then return end
    local Char = Plr.Character
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local dist = (HRP.Position - Position).Magnitude
    local tweenTime = math.max(dist / Speed, 0.5)
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
    tween:Play()
    tween.Completed:Wait()
end

-- FinishQuest - ส่งคำสั่งจบ Quest
local function FinishQuest()
    local result = nil
    pcall(function()
        result = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("FinishQuest")
    end)
    return result
end

-- CheckQuestOther - เช็ค Quest อื่นๆ (เมื่อมาถึงแมพแล้ว)
local function CheckQuestOther()
    local result = nil
    pcall(function()
        result = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("CheckQuestOther")
    end)
    return result
end

-- AcceptQuest - รับ Quest ถัดไป
local function AcceptQuest()
    local result = nil
    pcall(function()
        result = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("AcceptQuest")
    end)
    return result
end

-- ContinueQuest - กด Continue / ข้ามบทสนทนา
local function ContinueQuest()
    local result = nil
    pcall(function()
        result = DialogueService:WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("Continue")
    end)
    return result
end

-- วาง Portal Tool
local function PlacePortal()
    pcall(function()
        ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("PortalTool")
    end)
end

-- ดึงชื่อแมพปัจจุบัน
local function GetCurrentIsland()
    local result = nil
    pcall(function()
        -- ลองหาจาก PlayerController หรือ attribute
        if PlayerController and PlayerController.Replica and PlayerController.Replica.Data then
            result = PlayerController.Replica.Data.CurrentIsland or PlayerController.Replica.Data.Island
        end
    end)
    
    -- ถ้าไม่เจอ ลองหาจาก LocalPlayer attribute
    if not result then
        pcall(function()
            result = Plr:GetAttribute("CurrentIsland") or Plr:GetAttribute("Island")
        end)
    end
    
    return result
end

-- Teleport ไปยัง Island (ถ้ายังไม่อยู่)
local function TeleportToIsland(islandName)
    print("Checking island:", islandName)
    
    -- เช็คว่าอยู่แมพนั้นแล้วหรือยัง
    local currentIsland = GetCurrentIsland()
    if currentIsland then
        local current = currentIsland:lower():gsub("%s+", "")
        local target = islandName:lower():gsub("%s+", "")
        if current:find(target) or target:find(current) or current == target then
            print("Already on island:", currentIsland)
            -- เรียก CheckQuestOther เพื่อ progress quest
            CheckQuestOther()
            return true
        end
    end
    
    print("Teleporting to:", islandName)
    local result = nil
    pcall(function()
        result = PortalService:WaitForChild("RF"):WaitForChild("TeleportToIsland"):InvokeServer(islandName)
    end)
    task.wait(3) -- รอโหลดแมพ
    
    -- เรียก CheckQuestOther หลัง teleport
    CheckQuestOther()
    
    return result
end

-- ===== QUEST FUNCTIONS =====

-- อ่าน Quest จาก UI
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

-- แยกประเภท Quest จาก Text
local function ParseQuestText(text)
    local originalText = text
    text = text:lower()
    
    -- Talk to NPC (ดึงชื่อจาก original text เพื่อรักษา case)
    if text:find("talk to") or text:find("speak to") or text:find("visit") then
        -- ใช้ pattern ที่จับได้ดีกว่า
        local npcName = originalText:match("[Tt]alk to ([^:]+)") or originalText:match("[Ss]peak to ([^:]+)") or originalText:match("[Vv]isit ([^:]+)")
        if npcName then
            -- ลบ progress เช่น "0/1" และ whitespace
            npcName = npcName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1")
            -- ลบ "-" ข้างหน้า
            npcName = npcName:gsub("^%s*%-%s*", "")
            return "talk", npcName
        end
    end
    
    -- Help NPC (เช่น "Help captain to save the town")
    if text:find("help") then
        -- หาชื่อ NPC หลังคำว่า help
        local npcName = originalText:match("[Hh]elp ([%w%s]+) to") or originalText:match("[Hh]elp ([%w]+)")
        if npcName then
            npcName = npcName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1")
            return "talk", npcName
        end
    end
    
    -- Enhance/Upgrade item (ต้องเช็คก่อน mine)
    if text:find("enhance") or text:find("upgrade") then
        -- หา target level เช่น "+3" หรือ "to 3"
        local targetLevel = text:match("%+(%d+)") or text:match("to %+?(%d+)")
        if targetLevel then
            return "enhance", tonumber(targetLevel)
        end
        return "enhance", 1 -- default +1
    end
    
    -- Mine/Collect rocks
    if text:find("mine") or (text:find("collect") and (text:find("ore") or text:find("rock") or text:find("stone"))) then
        local rockName = text:match("mine (%w+)") or text:match("collect (%w+)")
        local amount = text:match("(%d+)") or "1"
        return "mine", rockName, tonumber(amount)
    end
    
    -- Kill mobs
    if text:find("kill") or text:find("defeat") or text:find("slay") then
        local mobName = text:match("kill (%w+)") or text:match("defeat (%w+)") or text:match("slay (%w+)")
        local amount = text:match("(%d+)") or "1"
        return "kill", mobName, tonumber(amount)
    end
    
    -- Buy/Purchase
    if text:find("buy") or text:find("purchase") or text:find("get a") then
        local itemName = text:match("buy (.+)") or text:match("purchase (.+)") or text:match("get a (.+)")
        if itemName then
            itemName = itemName:gsub("%d+/%d+", ""):gsub("^%s*(.-)%s*$", "%1")
            return "buy", itemName
        end
    end
    
    -- Forge/Craft
    if text:find("forge") or text:find("craft") then
        local itemType = text:match("forge a (%w+)") or text:match("craft a (%w+)")
        return "forge", itemType
    end
    
    -- Travel/Go to island
    if text:find("travel to") or text:find("go to") or text:find("head to") or text:find("visit the") then
        local islandName = originalText:match("[Tt]ravel to ([^:]+)") or originalText:match("[Gg]o to ([^:]+)") or originalText:match("[Hh]ead to ([^:]+)") or originalText:match("[Vv]isit the ([^:]+)")
        if islandName then
            islandName = islandName:gsub("%s*%d+/%d+%s*", ""):gsub("^%s*(.-)%s*$", "%1")
            return "travel", islandName
        end
    end
    
    return "unknown", text
end

-- ===== ACTION FUNCTIONS =====

-- รายชื่อ NPC กับแมพที่อยู่
local NPC_LOCATIONS = {
    -- Starter Island
    ["sensei moro"] = "Starter Island",
    ["moro"] = "Starter Island",
    ["blacksmith"] = "Starter Island",
    ["merchant"] = "Starter Island",
    ["greedy cey"] = "Starter Island",
    ["cey"] = "Starter Island",
    ["marbles"] = "Starter Island",
    
    -- Forgotten Kingdom
    ["forgotten knight"] = "Forgotten Kingdom",
    ["knight"] = "Forgotten Kingdom",
    ["old sage"] = "Forgotten Kingdom",
    ["sage"] = "Forgotten Kingdom",
    ["captain"] = "Forgotten Kingdom",
    
    -- เพิ่ม NPC อื่นๆ ตามต้องการ
}

-- รายชื่อ Mob กับแมพที่อยู่
local MOB_LOCATIONS = {
    -- Starter Island
    ["slime"] = "Starter Island",
    ["goblin"] = "Starter Island",
    ["wolf"] = "Starter Island",
    ["bandit"] = "Starter Island",
    
    -- Forgotten Kingdom
    ["skeleton"] = "Forgotten Kingdom",
    ["zombie"] = "Forgotten Kingdom",
    ["ghost"] = "Forgotten Kingdom",
    ["knight"] = "Forgotten Kingdom",
    ["dark knight"] = "Forgotten Kingdom",
    ["undead"] = "Forgotten Kingdom",
    
    -- เพิ่ม Mob อื่นๆ ตามต้องการ
}

-- รายชื่อ Rock/Ore กับแมพที่อยู่
local ROCK_LOCATIONS = {
    -- Starter Island
    ["stone"] = "Starter Island",
    ["copper"] = "Starter Island",
    ["iron"] = "Starter Island",
    ["coal"] = "Starter Island",
    
    -- Forgotten Kingdom
    ["gold"] = "Forgotten Kingdom",
    ["silver"] = "Forgotten Kingdom",
    ["mythril"] = "Forgotten Kingdom",
    ["adamantite"] = "Forgotten Kingdom",
    
    -- เพิ่ม Rock อื่นๆ ตามต้องการ
}

-- หาแมพที่ NPC อยู่
local function GetNPCIsland(npcName)
    if not npcName then return nil end
    local searchName = npcName:lower():gsub("%s+", "")
    for npc, island in pairs(NPC_LOCATIONS) do
        local cleanNpc = npc:lower():gsub("%s+", "")
        if cleanNpc:find(searchName) or searchName:find(cleanNpc) then
            return island
        end
    end
    return nil
end

-- หาแมพที่ Mob อยู่
local function GetMobIsland(mobName)
    if not mobName then return nil end
    local searchName = mobName:lower():gsub("%s+", "")
    for mob, island in pairs(MOB_LOCATIONS) do
        local cleanMob = mob:lower():gsub("%s+", "")
        if cleanMob:find(searchName) or searchName:find(cleanMob) then
            return island
        end
    end
    return nil
end

-- หาแมพที่ Rock อยู่
local function GetRockIsland(rockName)
    if not rockName then return nil end
    local searchName = rockName:lower():gsub("%s+", "")
    for rock, island in pairs(ROCK_LOCATIONS) do
        local cleanRock = rock:lower():gsub("%s+", "")
        if cleanRock:find(searchName) or searchName:find(cleanRock) then
            return island
        end
    end
    return nil
end

-- เช็คและ Teleport ไปแมพถ้าจำเป็น
local function EnsureOnIsland(islandName)
    if not islandName then return false end
    
    local currentIsland = GetCurrentIsland()
    if currentIsland then
        local current = currentIsland:lower():gsub("%s+", "")
        local target = islandName:lower():gsub("%s+", "")
        if current:find(target) or target:find(current) or current == target then
            print("Already on island:", currentIsland)
            return true
        end
    end
    
    print("Teleporting to:", islandName)
    TeleportToIsland(islandName)
    task.wait(3)
    return true
end

-- คุยกับ NPC
local function TalkToNPC(npcName)
    print("Looking for NPC:", npcName)
    
    local npc = nil
    local searchName = npcName:lower():gsub("%s+", "") -- ลบ space ออกสำหรับเปรียบเทียบ
    
    -- Function เปรียบเทียบชื่อ
    local function matchName(name)
        local cleanName = name:lower():gsub("%s+", "")
        -- เช็คแบบ contains หรือ exact match
        return cleanName:find(searchName) or searchName:find(cleanName) or cleanName == searchName
    end
    
    -- หา NPC จาก workspace.Proximity
    pcall(function()
        local Proximity = workspace:FindFirstChild("Proximity")
        if Proximity then
            for _, child in pairs(Proximity:GetChildren()) do
                if matchName(child.Name) then
                    npc = child
                    print("Found in Proximity:", child.Name)
                    break
                end
            end
        end
    end)
    
    -- หา NPC จาก workspace.NPCs
    if not npc then
        pcall(function()
            local NPCs = workspace:FindFirstChild("NPCs")
            if NPCs then
                for _, child in pairs(NPCs:GetChildren()) do
                    if matchName(child.Name) then
                        npc = child
                        print("Found in NPCs:", child.Name)
                        break
                    end
                end
            end
        end)
    end
    
    -- หา NPC จาก workspace โดยตรง (recursive)
    if not npc then
        pcall(function()
            for _, child in pairs(workspace:GetDescendants()) do
                if child:IsA("Model") and matchName(child.Name) then
                    -- เช็คว่าเป็น NPC (มี Humanoid)
                    if child:FindFirstChildOfClass("Humanoid") or child:FindFirstChild("HumanoidRootPart") then
                        npc = child
                        print("Found in workspace:", child.Name)
                        break
                    end
                end
            end
        end)
    end
    
    -- ลองหาแบบ partial match ถ้ายังไม่เจอ
    if not npc then
        pcall(function()
            local words = {}
            for word in npcName:gmatch("%S+") do
                table.insert(words, word:lower())
            end
            
            local Proximity = workspace:FindFirstChild("Proximity")
            if Proximity then
                for _, child in pairs(Proximity:GetChildren()) do
                    local childNameLower = child.Name:lower()
                    for _, word in pairs(words) do
                        if childNameLower:find(word) then
                            npc = child
                            print("Found by partial match:", child.Name)
                            break
                        end
                    end
                    if npc then break end
                end
            end
        end)
    end
    
    if not npc then
        print("NPC not found in current island:", npcName)
        
        -- ลอง teleport ไปแมพที่ NPC อยู่
        local npcIsland = GetNPCIsland(npcName)
        local currentIsland = GetCurrentIsland()
        
        if npcIsland then
            print("NPC", npcName, "should be in:", npcIsland)
            
            -- เช็คว่าอยู่แมพนั้นแล้วหรือยัง
            local shouldTeleport = true
            if currentIsland then
                local current = currentIsland:lower():gsub("%s+", "")
                local target = npcIsland:lower():gsub("%s+", "")
                if current:find(target) or target:find(current) then
                    shouldTeleport = false
                    print("Already on the correct island")
                end
            end
            
            if shouldTeleport then
                print("Teleporting to:", npcIsland)
                TeleportToIsland(npcIsland)
                task.wait(3)
                
                -- หา NPC อีกครั้งหลัง teleport
                return TalkToNPC(npcName)
            end
        end
        
        -- แสดง NPC ทั้งหมดใน Proximity
        pcall(function()
            print("=== NPCs in Proximity ===")
            local Proximity = workspace:FindFirstChild("Proximity")
            if Proximity then
                for _, child in pairs(Proximity:GetChildren()) do
                    print("-", child.Name)
                end
            end
            print("========================")
        end)
        return false
    end
    
    -- หาตำแหน่ง NPC
    local npcPos
    if npc.PrimaryPart then
        npcPos = npc.PrimaryPart.Position
    elseif npc:FindFirstChild("HumanoidRootPart") then
        npcPos = npc.HumanoidRootPart.Position
    else
        local part = npc:FindFirstChildWhichIsA("BasePart")
        if part then npcPos = part.Position end
    end
    
    if not npcPos then
        print("Cannot find NPC position")
        return false
    end
    
    -- ไปหา NPC
    print("Going to NPC:", npc.Name)
    TweenTo(npcPos)
    task.wait(0.5)
    
    -- วาง Portal ก่อนคุย (เผื่อต้องกลับมา)
    PlacePortal()
    task.wait(0.3)
    
    -- คุยกับ NPC
    pcall(function()
        ProximityService:WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(npc)
        task.wait(0.3)
        DialogueService:WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
    end)
    
    task.wait(0.5)
    
    -- ส่ง FinishQuest เพื่อจบ quest
    FinishQuest()
    task.wait(0.3)
    
    -- ลองรับ Quest ถัดไป
    AcceptQuest()
    task.wait(0.3)
    ContinueQuest()
    
    print("Talked to NPC:", npc.Name)
    task.wait(1)
    return true
end

-- ขุดหิน
local function MineRock(rockName, amount)
    print("Mining:", rockName, "x", amount)
    
    -- เช็คและ teleport ไปแมพที่มี Rock นี้
    local rockIsland = GetRockIsland(rockName)
    if rockIsland then
        EnsureOnIsland(rockIsland)
    end
    
    local function getNearest()
        local path = nil
        local dis = math.huge
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return nil end
        local p_pos = Char.HumanoidRootPart.Position
        
        for _, v in pairs(workspace.Rocks:GetChildren()) do
            if v:IsA("Folder") then
                for _, v1 in pairs(v:GetChildren()) do
                    local Model = v1:FindFirstChildWhichIsA("Model")
                    if Model and Model:GetAttribute("Health") > 0 then
                        local modelName = Model.Name:lower()
                        if not rockName or modelName:find(rockName:lower()) then
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
    
    local mined = 0
    while mined < amount do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        local rock = getNearest()
        if rock then
            local Position = rock:GetAttribute("OriginalCFrame").Position
            local LastAttack = 0
            
            while rock:GetAttribute("Health") > 0 do
                task.wait(0.1)
                if not IsAlive() then break end
                
                local Char = Plr.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") then break end
                
                local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
                if Magnitude < 15 then
                    if tick() > LastAttack then
                        pcall(function()
                            ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Pickaxe")
                        end)
                        LastAttack = tick() + 0.2
                    end
                    Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 2))
                else
                    TweenTo(Position)
                end
            end
            mined = mined + 1
            print("Mined:", mined, "/", amount)
        else
            task.wait(1)
        end
    end
    
    return true
end

-- ฆ่า Mob
local function KillMob(mobName, amount)
    print("Killing:", mobName, "x", amount)
    
    -- เช็คและ teleport ไปแมพที่มี Mob นี้
    local mobIsland = GetMobIsland(mobName)
    if mobIsland then
        EnsureOnIsland(mobIsland)
    end
    
    local function getNearest()
        local path = nil
        local dis = math.huge
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return nil end
        local p_pos = Char.HumanoidRootPart.Position
        
        local Living = workspace:FindFirstChild("Living")
        if not Living then return nil end
        
        for _, mob in pairs(Living:GetChildren()) do
            if mob:IsA("Model") then
                local Humanoid = mob:FindFirstChildOfClass("Humanoid")
                local HRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                
                if Humanoid and HRP and Humanoid.Health > 0 then
                    local modelName = mob.Name:lower()
                    if not mobName or modelName:find(mobName:lower()) then
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
    
    local killed = 0
    while killed < amount do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        local mob = getNearest()
        if mob then
            local MobHumanoid = mob:FindFirstChildOfClass("Humanoid")
            local LastAttack = 0
            
            while MobHumanoid and MobHumanoid.Health > 0 do
                task.wait(0.05)
                if not IsAlive() then break end
                
                local Char = Plr.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") then break end
                
                local MobHRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                if not MobHRP then break end
                
                local MobPosition = MobHRP.Position
                local FloatHeight = 6
                local SafePosition = MobPosition + Vector3.new(0, FloatHeight, 0)
                
                local Magnitude = (Char.HumanoidRootPart.Position - MobPosition).Magnitude
                
                if Magnitude < 25 then
                    if tick() > LastAttack then
                        pcall(function()
                            ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Weapon")
                        end)
                        LastAttack = tick() + 0.2
                    end
                    Char.HumanoidRootPart.CFrame = CFrame.new(SafePosition)
                else
                    TweenTo(MobPosition)
                end
            end
            killed = killed + 1
            print("Killed:", killed, "/", amount)
        else
            task.wait(1)
        end
    end
    
    return true
end

-- ซื้อของ
local function BuyItem(itemName)
    print("Buying:", itemName)
    
    -- แปลงชื่อ item ให้ตรงกับระบบ
    local purchaseItems = {
        ["pickaxe"] = "Iron Pickaxe",
        ["iron pickaxe"] = "Iron Pickaxe",
        ["wooden pickaxe"] = "Wooden Pickaxe",
        ["stone pickaxe"] = "Stone Pickaxe",
        ["sword"] = "Iron Sword",
        ["iron sword"] = "Iron Sword",
    }
    
    local actualItem = purchaseItems[itemName:lower()] or itemName
    
    pcall(function()
        ProximityService:WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(actualItem, 1)
    end)
    
    print("Bought:", actualItem)
    task.wait(1)
    return true
end

-- ===== FORGE FUNCTIONS =====

-- หา Ore จากชื่อ
local function GetOre(Name)
    for i, v in pairs(Ores) do
        if v["Name"] == Name then
            return v
        end
    end
    return false
end

-- หา Recipe สำหรับ Forge
local function GetRecipe()
    local Recipe = {}
    local Count = 0
    local HowMany = 0
    local IgnoreRarity = {"Legendary", "Mythic", "Relic", "Exotic", "Divine", "Unobtainable"}
    
    for i, v in pairs(PlayerController.Replica.Data.Inventory) do
        local Ore = GetOre(i)
        if Ore and not table.find(IgnoreRarity, Ore["Rarity"]) then
            Recipe[i] = v
            Count = Count + v
            HowMany = HowMany + 1
            if HowMany >= 4 then
                break
            end
        end
    end
    
    if Count < 3 then
        return false
    else
        return Recipe
    end
end

-- Forge item
local function ForgeItem(itemType)
    itemType = itemType or "Weapon"
    print("Forging:", itemType)
    
    -- ไปที่ Forge
    local ForgePos = workspace.Proximity.Forge.Position
    TweenTo(ForgePos)
    task.wait(0.5)
    
    if not IsAlive() then return false end
    
    local Char = Plr.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        Char.HumanoidRootPart.CFrame = CFrame.new(ForgePos)
    end
    
    local Recipe = GetRecipe()
    if not Recipe then
        print("Not enough ores to forge")
        return false
    end
    
    pcall(function()
        ForgeService:WaitForChild("RF"):WaitForChild("StartForge"):InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Forge"))
        ChangeSequence:InvokeServer("Melt", {
            FastForge = true,
            ItemType = itemType
        })
        task.wait(1)
        
        local Melt = ChangeSequence:InvokeServer("Melt", {
            FastForge = true,
            ItemType = itemType,
            Ores = Recipe
        })
        task.wait(Melt["MinigameData"]["RequiredTime"])
        
        local Pour = ChangeSequence:InvokeServer("Pour", {
            ClientTime = workspace:GetServerTimeNow()
        })
        task.wait(Pour["MinigameData"]["RequiredTime"])
        
        local Hammer = ChangeSequence:InvokeServer("Hammer", {
            ClientTime = workspace:GetServerTimeNow()
        })
        task.wait(Hammer["MinigameData"]["RequiredTime"])
        
        task.spawn(function()
            ChangeSequence:InvokeServer("Water", {
                ClientTime = workspace:GetServerTimeNow()
            })
        end)
        task.wait(1)
        
        ChangeSequence:InvokeServer("Showcase", {})
        task.wait(0.5)
        ChangeSequence:InvokeServer("OreSelect", {})
        
        pcall(require(ReplicatedStorage.Controllers.UIController.Forge).Close)
    end)
    
    print("Forged:", itemType)
    task.wait(1)
    return true
end

-- ขุดหินจนเต็มแล้ว Forge
local function MineAndForge(rockName, itemType)
    itemType = itemType or "Weapon"
    print("Mining rocks then forging:", itemType)
    
    -- ขุดหินจนเต็ม
    while Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        local function getNearest()
            local path = nil
            local dis = math.huge
            local Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then return nil end
            local p_pos = Char.HumanoidRootPart.Position
            
            for _, v in pairs(workspace.Rocks:GetChildren()) do
                if v:IsA("Folder") then
                    for _, v1 in pairs(v:GetChildren()) do
                        local Model = v1:FindFirstChildWhichIsA("Model")
                        if Model and Model:GetAttribute("Health") > 0 then
                            local modelName = Model.Name:lower()
                            if not rockName or modelName:find(rockName:lower()) then
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
        
        local rock = getNearest()
        if rock then
            local Position = rock:GetAttribute("OriginalCFrame").Position
            local LastAttack = 0
            
            while rock:GetAttribute("Health") > 0 and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() do
                task.wait(0.1)
                if not IsAlive() then break end
                
                local Char = Plr.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") then break end
                
                local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
                if Magnitude < 15 then
                    if tick() > LastAttack then
                        pcall(function()
                            ToolService:WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Pickaxe")
                        end)
                        LastAttack = tick() + 0.2
                    end
                    Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 2))
                else
                    TweenTo(Position)
                end
            end
        else
            task.wait(1)
        end
    end
    
    -- Forge
    return ForgeItem(itemType)
end

-- ===== ENHANCE FUNCTIONS =====

-- หา Equipment จาก GUID
local function FindEquipmentByGUID(guid)
    local result = nil
    pcall(function()
        result = EnhanceService:WaitForChild("RF"):WaitForChild("FindEquipmentByGUID"):InvokeServer(guid)
    end)
    return result
end

-- ดู Requirements สำหรับ Upgrade
local function GetUpgradeRequirements(equipment)
    local result = nil
    pcall(function()
        result = EnhanceService:WaitForChild("RF"):WaitForChild("GetUpgradeRequirements"):InvokeServer(equipment)
    end)
    return result
end

-- ดู Success Chance
local function CalculateSuccessChance(equipment)
    local result = nil
    pcall(function()
        result = EnhanceService:WaitForChild("RF"):WaitForChild("CalculateSuccessChance"):InvokeServer(equipment)
    end)
    return result
end

-- Enhance Equipment
local function EnhanceEquipment(guid)
    local result = nil
    pcall(function()
        result = EnhanceService:WaitForChild("RF"):WaitForChild("EnhanceEquipment"):InvokeServer(guid)
    end)
    return result
end

-- Auto Enhance ทุก Equipment ที่มี
local function AutoEnhance(minSuccessChance)
    minSuccessChance = minSuccessChance or 50 -- ขั้นต่ำ 50% success chance
    print("=== Auto Enhance Started ===")
    print("Min Success Chance:", minSuccessChance .. "%")
    
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    if not Equipments then
        print("No equipments found")
        return
    end
    
    local enhanced = 0
    local failed = 0
    
    for i, equipment in pairs(Equipments) do
        if equipment and equipment.GUID then
            print("")
            print("--- Equipment:", equipment.Type or "Unknown", "---")
            print("GUID:", equipment.GUID)
            print("Current Upgrade:", equipment.Upgrade or 0)
            print("Quality:", equipment.Quality or 0)
            
            -- เช็ค success chance
            local successChance = CalculateSuccessChance(equipment)
            print("Success Chance:", successChance and (successChance .. "%") or "Unknown")
            
            if successChance and successChance >= minSuccessChance then
                -- ดู requirements
                local requirements = GetUpgradeRequirements(equipment)
                if requirements then
                    print("Requirements:", requirements)
                end
                
                -- Enhance
                print("Enhancing...")
                local result = EnhanceEquipment(equipment.GUID)
                if result then
                    print("Enhance SUCCESS!")
                    enhanced = enhanced + 1
                else
                    print("Enhance FAILED!")
                    failed = failed + 1
                end
                task.wait(0.5)
            else
                print("Skipped (low success chance)")
            end
        end
    end
    
    print("")
    print("=== Auto Enhance Completed ===")
    print("Enhanced:", enhanced)
    print("Failed:", failed)
end

-- Auto Enhance จนถึง level ที่ต้องการ
local function EnhanceToLevel(guid, targetLevel, minSuccessChance)
    minSuccessChance = minSuccessChance or 30
    print("=== Enhance to Level", targetLevel, "===")
    
    local equipment = FindEquipmentByGUID(guid)
    if not equipment then
        -- หาจาก inventory
        local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
        for _, eq in pairs(Equipments) do
            if eq.GUID == guid then
                equipment = eq
                break
            end
        end
    end
    
    if not equipment then
        print("Equipment not found:", guid)
        return false
    end
    
    local currentLevel = equipment.Upgrade or 0
    print("Current Level:", currentLevel)
    print("Target Level:", targetLevel)
    
    while currentLevel < targetLevel do
        local successChance = CalculateSuccessChance(equipment)
        print("Success Chance:", successChance and (successChance .. "%") or "Unknown")
        
        if successChance and successChance < minSuccessChance then
            print("Success chance too low, stopping")
            break
        end
        
        print("Enhancing from +", currentLevel, "to +", currentLevel + 1)
        local result = EnhanceEquipment(guid)
        
        if result then
            currentLevel = currentLevel + 1
            print("SUCCESS! Now at +", currentLevel)
        else
            print("FAILED! Still at +", currentLevel)
        end
        
        task.wait(0.5)
        
        -- อัพเดต equipment data
        equipment = FindEquipmentByGUID(guid)
        if equipment then
            currentLevel = equipment.Upgrade or currentLevel
        end
    end
    
    print("=== Enhance Complete ===")
    print("Final Level: +", currentLevel)
    return currentLevel >= targetLevel
end

-- แสดง Equipment ทั้งหมด
local function ShowEquipments()
    print("=== Equipments ===")
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    if not Equipments then
        print("No equipments found")
        return
    end
    
    for i, eq in pairs(Equipments) do
        if eq then
            local successChance = CalculateSuccessChance(eq)
            print(string.format("[%d] %s +%d | Quality: %.1f%% | GUID: %s | Success: %s",
                i,
                eq.Type or "Unknown",
                eq.Upgrade or 0,
                eq.Quality or 0,
                eq.GUID or "N/A",
                successChance and (successChance .. "%") or "N/A"
            ))
        end
    end
    print("==================")
end

-- Enhance ไอเทมใดก็ได้ถึง Level ที่ต้องการ (สำหรับ Quest)
local function AutoEnhanceForQuest(targetLevel)
    targetLevel = targetLevel or 1
    print("=== Auto Enhance For Quest - Target: +", targetLevel, "===")
    
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    if not Equipments then
        print("No equipments found")
        return false
    end
    
    -- เช็คว่ามีไอเทมที่ถึง target แล้วหรือยัง
    for _, eq in pairs(Equipments) do
        if eq and (eq.Upgrade or 0) >= targetLevel then
            print("Already have equipment at +", eq.Upgrade or 0)
            return true
        end
    end
    
    -- หาไอเทมที่ใกล้ target ที่สุด
    local bestEquipment = nil
    local bestLevel = -1
    
    for _, eq in pairs(Equipments) do
        if eq then
            local level = eq.Upgrade or 0
            if level < targetLevel and level > bestLevel then
                bestEquipment = eq
                bestLevel = level
            end
        end
    end
    
    if not bestEquipment then
        print("No equipment available to enhance")
        -- ลอง Forge อันใหม่
        print("Trying to forge new equipment...")
        ForgeItem("Weapon")
        task.wait(1)
        
        -- หาใหม่
        Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
        for _, eq in pairs(Equipments) do
            if eq then
                local level = eq.Upgrade or 0
                if level < targetLevel then
                    bestEquipment = eq
                    break
                end
            end
        end
        
        if not bestEquipment then
            print("Still no equipment to enhance")
            return false
        end
    end
    
    print("Selected equipment:", bestEquipment.Type or "Unknown", "| +", bestEquipment.Upgrade or 0)
    print("GUID:", bestEquipment.GUID)
    
    -- Enhance ถึง target level
    return EnhanceToLevel(bestEquipment.GUID, targetLevel, 10)
end

-- ===== RUNE FUNCTIONS =====

-- ดูราคา Attach Rune
local function GetRuneAttachPrice(equipmentGUID, runeGUID)
    local result = nil
    pcall(function()
        result = RuneService:WaitForChild("RF"):WaitForChild("GetPriceInfo"):InvokeServer(equipmentGUID, runeGUID, "Attach")
    end)
    return result
end

-- Attach Rune ไปที่ Equipment
local function AttachRune(equipmentGUID, runeGUID)
    local result = nil
    pcall(function()
        result = RuneService:WaitForChild("RF"):WaitForChild("PurchaseAttach"):InvokeServer(equipmentGUID, runeGUID)
    end)
    return result
end

-- ดู Runes ทั้งหมด
local function GetAllRunes()
    local Runes = PlayerController.Replica.Data.Inventory["Runes"]
    return Runes or {}
end

-- แสดง Runes ทั้งหมด
local function ShowRunes()
    print("=== Runes ===")
    local Runes = GetAllRunes()
    if not Runes or next(Runes) == nil then
        print("No runes found")
        return
    end
    
    for i, rune in pairs(Runes) do
        if rune then
            print(string.format("[%d] %s | Tier: %s | GUID: %s | Attached: %s",
                i,
                rune.Name or "Unknown",
                rune.Tier or "?",
                rune.GUID or "N/A",
                rune.AttachedTo and "Yes" or "No"
            ))
        end
    end
    print("=============")
end

-- Auto Attach Rune - ใส่ Rune ที่ยังไม่ได้ใส่ไปยัง Equipment
local function AutoAttachRune()
    print("=== Auto Attach Rune ===")
    
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    local Runes = GetAllRunes()
    
    if not Equipments or next(Equipments) == nil then
        print("No equipments found")
        return false
    end
    
    if not Runes or next(Runes) == nil then
        print("No runes found")
        return false
    end
    
    local attached = 0
    
    -- หา Rune ที่ยังไม่ได้ Attach
    for _, rune in pairs(Runes) do
        if rune and rune.GUID and not rune.AttachedTo then
            print("Found unattached rune:", rune.Name or "Unknown")
            
            -- หา Equipment ที่จะใส่ Rune
            for _, equipment in pairs(Equipments) do
                if equipment and equipment.GUID then
                    print("Trying to attach to:", equipment.Type or "Unknown", "| GUID:", equipment.GUID)
                    
                    -- ดูราคา
                    local priceInfo = GetRuneAttachPrice(equipment.GUID, rune.GUID)
                    if priceInfo then
                        print("Price Info:", priceInfo)
                    end
                    
                    -- Attach
                    local result = AttachRune(equipment.GUID, rune.GUID)
                    if result then
                        print("SUCCESS! Attached rune to equipment")
                        attached = attached + 1
                        break -- ไป Rune ถัดไป
                    else
                        print("Failed to attach")
                    end
                    
                    task.wait(0.3)
                end
            end
        end
    end
    
    print("=== Auto Attach Complete ===")
    print("Total Attached:", attached)
    return attached > 0
end

-- Attach Rune ไปที่ Equipment ที่เลือก
local function AttachRuneToEquipment(runeGUID, equipmentGUID)
    print("=== Attaching Rune ===")
    print("Rune GUID:", runeGUID)
    print("Equipment GUID:", equipmentGUID)
    
    -- ดูราคา
    local priceInfo = GetRuneAttachPrice(equipmentGUID, runeGUID)
    if priceInfo then
        print("Price Info:", priceInfo)
    end
    
    -- Attach
    local result = AttachRune(equipmentGUID, runeGUID)
    if result then
        print("SUCCESS! Rune attached")
        return true
    else
        print("FAILED to attach rune")
        return false
    end
end

-- ===== MAIN QUEST LOOP =====

local function ProcessQuest(questText)
    local questType, arg1, arg2 = ParseQuestText(questText)
    
    print("Quest Type:", questType, "| Arg1:", arg1, "| Arg2:", arg2)
    
    if questType == "talk" then
        return TalkToNPC(arg1)
    elseif questType == "mine" then
        return MineRock(arg1, arg2 or 1)
    elseif questType == "kill" then
        return KillMob(arg1, arg2 or 1)
    elseif questType == "buy" then
        return BuyItem(arg1)
    elseif questType == "forge" then
        return ForgeItem(arg1 or "Weapon")
    elseif questType == "enhance" then
        return AutoEnhanceForQuest(arg1 or 1)
    elseif questType == "travel" then
        return TeleportToIsland(arg1)
    else
        print("Unknown quest type:", questText)
        return false
    end
end

local function AutoQuest()
    print("=== Auto Quest Started ===")
    
    while true do
        task.wait(1)
        
        if not IsAlive() then
            WaitForRespawn()
        end
        
        local quests = GetCurrentQuests()
        
        if #quests == 0 then
            print("No quests found, waiting...")
            task.wait(3)
        else
            for _, quest in pairs(quests) do
                print("Processing Quest:", quest.Text)
                local success = ProcessQuest(quest.Text)
                if success then
                    print("Quest completed!")
                    task.wait(2)
                    break -- รีเช็ค quest ใหม่
                end
            end
        end
    end
end

-- ===== EXPORTS =====

_G.AutoQuest = AutoQuest
_G.GetCurrentQuests = GetCurrentQuests
_G.TalkToNPC = TalkToNPC
_G.MineRock = MineRock
_G.KillMob = KillMob
_G.BuyItem = BuyItem
_G.ForgeItem = ForgeItem
_G.MineAndForge = MineAndForge
_G.AutoEnhance = AutoEnhance
_G.AutoEnhanceForQuest = AutoEnhanceForQuest
_G.EnhanceToLevel = EnhanceToLevel
_G.EnhanceEquipment = EnhanceEquipment
_G.ShowEquipments = ShowEquipments
_G.ShowRunes = ShowRunes
_G.AutoAttachRune = AutoAttachRune
_G.AttachRuneToEquipment = AttachRuneToEquipment
_G.TeleportToIsland = TeleportToIsland
_G.PlacePortal = PlacePortal
_G.FinishQuest = FinishQuest
_G.CheckQuestOther = CheckQuestOther
_G.GetCurrentIsland = GetCurrentIsland
_G.GetNPCIsland = GetNPCIsland
_G.GetMobIsland = GetMobIsland
_G.GetRockIsland = GetRockIsland
_G.EnsureOnIsland = EnsureOnIsland
_G.AcceptQuest = AcceptQuest
_G.ContinueQuest = ContinueQuest
_G.NPC_LOCATIONS = NPC_LOCATIONS
_G.MOB_LOCATIONS = MOB_LOCATIONS
_G.ROCK_LOCATIONS = ROCK_LOCATIONS

print("TF_Quest Script Loaded!")
print("Commands:")
print("  _G.AutoQuest() - เริ่ม Auto Quest")
print("  _G.GetCurrentQuests() - ดู Quest ปัจจุบัน")
print("  _G.TalkToNPC('name') - คุยกับ NPC")
print("  _G.MineRock('name', amount) - ขุดหิน")
print("  _G.KillMob('name', amount) - ฆ่า Mob")
print("  _G.BuyItem('name') - ซื้อของ")
print("  _G.ForgeItem('Weapon' or 'Armor') - Forge item")
print("  _G.MineAndForge('rock', 'Weapon') - ขุดหินจนเต็มแล้ว Forge")
print("  _G.AutoEnhance(50) - Auto Enhance ทุกอัน (min 50% success)")
print("  _G.EnhanceToLevel('GUID', 5, 30) - Enhance ถึง +5 (min 30% success)")
print("  _G.ShowEquipments() - แสดง Equipment ทั้งหมด")
print("  _G.ShowRunes() - แสดง Runes ทั้งหมด")
print("  _G.AutoAttachRune() - Auto Attach Runes ไปยัง Equipment")
print("  _G.AttachRuneToEquipment('runeGUID', 'equipGUID') - Attach Rune เฉพาะ")
print("  _G.TeleportToIsland('name') - Teleport ไปแมพ")
print("  _G.PlacePortal() - วาง Portal")
print("  _G.FinishQuest() - ส่งคำสั่งจบ Quest")
print("  _G.AcceptQuest() - รับ Quest ถัดไป")
print("  _G.ContinueQuest() - กด Continue บทสนทนา")
print("  _G.CheckQuestOther() - เช็ค Quest อื่นๆ (มาถึงแมพแล้ว)")
print("  _G.GetCurrentIsland() - ดูแมพปัจจุบัน")
print("  _G.GetNPCIsland('name') - ดูว่า NPC อยู่แมพไหน")
print("  _G.GetMobIsland('name') - ดูว่า Mob อยู่แมพไหน")
print("  _G.GetRockIsland('name') - ดูว่า Rock อยู่แมพไหน")
print("  _G.NPC_LOCATIONS - ตารางที่อยู่ NPC")
print("  _G.MOB_LOCATIONS - ตารางที่อยู่ Mob")
print("  _G.ROCK_LOCATIONS - ตารางที่อยู่ Rock")
print("")

-- แสดง Quest ปัจจุบัน
local quests = GetCurrentQuests()
print("=== Current Quests ===")
for _, q in pairs(quests) do
    print("-", q.Text)
end
print("======================")

-- เริ่ม Auto Quest ทันที
task.spawn(function()
    AutoQuest()
end)
