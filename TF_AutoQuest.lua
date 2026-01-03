-- TF_AutoQuest.lua
-- Auto All System: Quest + Farm + Forge + Sell + NPC + Anti-AFK
-- ใชระบบ Farm จาก TF_System.lua

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

repeat
    task.wait(15)
until getrenv()._G.ClientIsReady

task.wait(2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local Plr = Players.LocalPlayer
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Knit = require(Shared:WaitForChild("Packages"):WaitForChild("Knit"))

-- Rarity ทจะไมขาย/forge (เกบไว)
local ProtectedRarity = {
    ["Mythic"] = true,
    ["Relic"] = true,
    ["Exotic"] = true,
    ["Divine"] = true,
    ["Unobtainable"] = true,
    ["Legendary"] = true,
}

local PlayerController = Knit.GetController("PlayerController")
local QuestData = require(Shared:WaitForChild("Data"):WaitForChild("Quests"))
local Ores = require(Shared:WaitForChild("Data"):WaitForChild("Ore"))
local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))

local LoopEnabled = true
local CurrentFarmMode = "Rock"  -- จะถกเปลยนอตโนมตตาม Quest
local CurrentTarget = nil       -- ชอ mob/rock ทตองการจาก Quest

-- Remotes
local ToolActivated = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated")
local StartForge = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("StartForge")
local ChangeSequence = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("ChangeSequence")
local DialogueRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue")
local DialogueEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent")
local RunCommand = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand")

-- เกบ Equipment ทมตอนเรม (ไมขาย)
local InsertEquipments = {}
for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
    table.insert(InsertEquipments, v["GUID"])
end

-- ===== MOB SEARCH TIMEOUT SYSTEM =====
local MobNotFoundStartTime = nil  -- เวลาที่เริ่มหา mob ไม่เจอ
local CurrentQuestNPC = nil       -- ชื่อ NPC เจ้าของ Quest ปัจจุบัน
local MOB_TIMEOUT = 15            -- วินาที ถ้าหา mob ไม่เจอนานกว่านี้จะกลับไปหา NPC
local LastMobSearchLog = 0        -- ป้องกัน spam log

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

local function GetOre(Name)
    for i,v in pairs(Ores) do
        if v["Name"] == Name then
            return v
        end 
    end
    return false
end

local function ShouldProtect(rarity)
    return ProtectedRarity[rarity] or false
end

local function GetReplica()
    return PlayerController and PlayerController.Replica
end

local function GetPlayerData()
    local replica = GetReplica()
    return replica and replica.Data
end

local function GetQuests()
    local data = GetPlayerData()
    return data and data.Quests
end

-- ===== FARM FUNCTIONS (จาก TF_System.lua) =====
local function getNearest(P_Char, targetName)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    for _,v in pairs(workspace.Rocks:GetChildren()) do
        if v:IsA("Folder") then
            for i1,v1 in pairs(v:GetChildren()) do
                local Model = v1:FindFirstChildWhichIsA("Model")
                if Model and Model:GetAttribute("Health") > 0 then
                    -- ถาม targetName ให filter ถาไมมใหเอาทกกอน
                    local canFarm = false
                    if targetName and targetName ~= "" then
                        if string.find(Model.Name:lower(), targetName:lower()) then
                            canFarm = true
                        end
                    else
                        canFarm = true
                    end
                    
                    if canFarm then
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

local function getNearestMob(P_Char, targetName)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    
    local Living = workspace:FindFirstChild("Living")
    if not Living then 
        print("[Debug] workspace.Living ไม่มี!")
        return nil 
    end
    
    local mobCount = 0
    local foundMobs = {}
    
    for _, mob in pairs(Living:GetChildren()) do
        if mob:IsA("Model") then
            local Humanoid = mob:FindFirstChildOfClass("Humanoid")
            local HRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
            
            if Humanoid and HRP and Humanoid.Health > 0 then
                mobCount = mobCount + 1
                
                -- เก็บชื่อ mob ที่เจอ (สำหรับ debug)
                if not foundMobs[mob.Name] then
                    foundMobs[mob.Name] = 0
                end
                foundMobs[mob.Name] = foundMobs[mob.Name] + 1
                
                local canFarm = false
                
                -- ถาม targetName ให filter ถาไมมใหเอาทกตว
                if targetName and targetName ~= "" then
                    if string.sub(mob.Name, 1, #targetName) == targetName then
                        canFarm = true
                    end
                else
                    canFarm = true
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
    
    -- Debug: แสดง mob ทั้งหมดที่เจอถ้าหา target ไม่เจอ
    if not path and targetName and targetName ~= "" then
        if tick() - (LastMobSearchLog or 0) > 5 then
            print("[Debug] ======= MOB ในพื้นที่ =======")
            print("[Debug] รวม", mobCount, "ตัว")
            for name, count in pairs(foundMobs) do
                print("[Debug]  -", name, "x", count)
            end
            print("[Debug] กำลังหา:", targetName)
            print("[Debug] ================================")
        end
    end
    
    return path
end

local function AttackMob()
    pcall(function()
        ToolActivated:InvokeServer("Weapon")
    end)
end

local function AttackRock()
    pcall(function()
        ToolActivated:InvokeServer("Pickaxe")
    end)
end

-- ===== FORGE FUNCTIONS (จาก TF_System.lua) =====
local function GetRecipe()
    local Recipe = {}
    local Count = 0
    local HowMany = 0
    for i,v in pairs(PlayerController.Replica.Data.Inventory) do
        local Ore = GetOre(i)
        if Ore and not ShouldProtect(Ore["Rarity"]) then
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

local function Forge(Recipe)
    StartForge:InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Forge"))
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
    print("[Forge] Finished")
end

-- ===== NPC FUNCTIONS (จาก TF_System.lua) =====
local function TalkToMarbles()
    pcall(function()
        local marbles = workspace:WaitForChild("Proximity"):WaitForChild("Marbles")
        local marblesPos
        
        if marbles:IsA("BasePart") then
            marblesPos = marbles.Position
        elseif marbles.PrimaryPart then
            marblesPos = marbles.PrimaryPart.Position
        elseif marbles:FindFirstChild("HumanoidRootPart") then
            marblesPos = marbles.HumanoidRootPart.Position
        else
            local part = marbles:FindFirstChildWhichIsA("BasePart")
            if part then 
                marblesPos = part.Position 
            else
                marblesPos = marbles:GetPivot().Position
            end
        end
        
        if marblesPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(marblesPos + Vector3.new(0, 0, 5))
            task.wait(0.5)
        end
        
        task.wait(0.3)
        DialogueRemote:InvokeServer(marbles)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.5)
        print("[NPC] Talked to Marbles")
    end)
end

local function TalkToGreedyCey()
    pcall(function()
        local greedyCey = workspace:WaitForChild("Proximity"):WaitForChild("Greedy Cey")
        local greedyPos
        
        if greedyCey:IsA("BasePart") then
            greedyPos = greedyCey.Position
        elseif greedyCey.PrimaryPart then
            greedyPos = greedyCey.PrimaryPart.Position
        elseif greedyCey:FindFirstChild("HumanoidRootPart") then
            greedyPos = greedyCey.HumanoidRootPart.Position
        else
            local part = greedyCey:FindFirstChildWhichIsA("BasePart")
            if part then 
                greedyPos = part.Position 
            else
                greedyPos = greedyCey:GetPivot().Position
            end
        end
        
        if greedyPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(greedyPos + Vector3.new(0, 0, 5))
            task.wait(0.5)
        end
        
        task.wait(0.3)
        DialogueRemote:InvokeServer(greedyCey)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.5)
        print("[NPC] Talked to Greedy Cey")
    end)
end

local function TalkToNPC(npcName)
    pcall(function()
        local npc = workspace:WaitForChild("Proximity"):FindFirstChild(npcName)
        if not npc then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == npcName and (obj:IsA("Model") or obj:IsA("BasePart")) then
                    npc = obj
                    break
                end
            end
        end
        if not npc then return end
        
        local npcPos
        if npc:IsA("BasePart") then
            npcPos = npc.Position
        elseif npc:FindFirstChild("HumanoidRootPart") then
            npcPos = npc.HumanoidRootPart.Position
        elseif npc.PrimaryPart then
            npcPos = npc.PrimaryPart.Position
        else
            local part = npc:FindFirstChildWhichIsA("BasePart")
            if part then npcPos = part.Position end
        end
        
        if npcPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(npcPos + Vector3.new(0, 0, 5))
            task.wait(0.5)
        end
        
        DialogueRemote:InvokeServer(npc)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.5)
        
        for i = 1, 10 do
            pcall(function()
                DialogueEvent:FireServer("Next")
            end)
            task.wait(0.2)
        end
        print("[NPC] Talked to", npcName)
    end)
end

-- ===== SELL FUNCTIONS =====
local function SellEquipments()
    for i, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        task.wait(0.3)
        if v["GUID"] and not table.find(InsertEquipments, v["GUID"]) then
            pcall(function()
                RunCommand:InvokeServer("SellConfirm", {
                    Basket = {
                        [v["GUID"]] = true,
                    }
                })
            end)
        end
    end
end

local function SellOres()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local Basket = {}
    local SoldCount = 0
    
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData and not ShouldProtect(OreData["Rarity"]) then
                Basket[OreName] = Amount
                SoldCount = SoldCount + Amount
            end
        end
    end
    
    if SoldCount > 0 then
        pcall(function()
            RunCommand:InvokeServer("SellConfirm", {
                Basket = Basket
            })
        end)
        print("[Sell] Sold", SoldCount, "ores")
    end
end

-- ===== QUEST FUNCTIONS =====
local function GetActiveQuestInfo()
    -- ดึง quest data สดๆ จาก PlayerController ทุกครั้ง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data then return nil end
    local quests = replica.Data.Quests
    if not quests then return nil end
    
    for questId, questProgress in pairs(quests) do
        local questTemplate = QuestData[questId]
        if questTemplate then
            return {
                Id = questId,
                Template = questTemplate,
                Progress = questProgress
            }
        end
    end
    return nil
end

-- หา objectives ที่ยังไม่เสร็จทั้งหมด (สำหรับ Quest ที่มีหลาย objectives พร้อมกัน)
local function GetAllIncompleteObjectives(questInfo)
    if not questInfo then return {} end
    
    -- ดึง progress สดๆ ใหม่ทุกครั้ง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return {} end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return {} end
    
    -- Progress อยู่ใน freshProgress.Progress[i] และเป็น table { currentProgress, requiredAmount }
    local progressTable = freshProgress.Progress
    if not progressTable then return {} end
    
    local objectives = questInfo.Template.Objectives
    local incomplete = {}
    
    for i, objective in ipairs(objectives) do
        local objData = progressTable[i]
        local currentProgress = 0
        local requiredAmount = objective.Amount or 1
        
        if objData and type(objData) == "table" then
            currentProgress = objData.currentProgress or 0
            requiredAmount = objData.requiredAmount or requiredAmount
        elseif objData and type(objData) == "number" then
            currentProgress = objData
        end
        
        if currentProgress < requiredAmount then
            table.insert(incomplete, {
                Index = i,
                Objective = objective,
                Current = currentProgress,
                Required = requiredAmount
            })
        end
    end
    return incomplete
end

local function GetCurrentObjective(questInfo)
    if not questInfo then return nil end
    
    -- ดึง progress สดๆ ใหม่ทุกครั้ง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return nil end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return nil end
    
    -- Progress อยู่ใน freshProgress.Progress[i] และเป็น table { currentProgress, requiredAmount }
    local progressTable = freshProgress.Progress
    if not progressTable then return nil end
    
    local objectives = questInfo.Template.Objectives
    for i, objective in ipairs(objectives) do
        local objData = progressTable[i]
        local currentProgress = 0
        local requiredAmount = objective.Amount or 1
        
        if objData and type(objData) == "table" then
            currentProgress = objData.currentProgress or 0
            requiredAmount = objData.requiredAmount or requiredAmount
        elseif objData and type(objData) == "number" then
            currentProgress = objData
        end
        
        if currentProgress < requiredAmount then
            return {
                Index = i,
                Objective = objective,
                Current = currentProgress,
                Required = requiredAmount
            }
        end
    end
    return nil
end

-- ===== MAIN FARM LOOP (ปรับระยะอัตโนมัติตามการโดนตี) =====
local SafeHeightOffset = 2  -- เริ่มต้น +2 studs เหนือ mob

local function FarmMob(targetName)
    if not IsAlive() then return "alive_fail" end
    
    local Char = Plr.Character
    local Mob = getNearestMob(Char, targetName)
    local LastAttack = 0
    local LastTween = nil
    
    -- ถ้าไม่เจอ mob ให้แจ้งและเริ่มนับ timeout
    if not Mob then
        -- เริ่มนับเวลาหา mob ไม่เจอ
        if MobNotFoundStartTime == nil then
            MobNotFoundStartTime = tick()
            print("[Farm] ไม่เจอ mob:", targetName or "any", "- เริ่มนับ timeout...")
        end
        
        -- เช็ค timeout
        local elapsed = tick() - MobNotFoundStartTime
        if elapsed > MOB_TIMEOUT then
            print("[Farm] ❌ Timeout! หา mob ไม่เจอ", MOB_TIMEOUT, "วินาที - กลับไปหา NPC")
            MobNotFoundStartTime = nil  -- reset
            return "timeout"
        end
        
        if tick() - LastMobSearchLog > 3 then
            LastMobSearchLog = tick()
            print("[Farm] รอ mob spawn... (", string.format("%.1f", elapsed), "/", MOB_TIMEOUT, "s)")
        end
        task.wait(0.5)
        return "not_found"
    end
    
    -- เจอ mob แล้ว reset timeout
    MobNotFoundStartTime = nil
    
    local LastHP = Char:FindFirstChildOfClass("Humanoid").Health
    local HitCount = 0
    local CheckTime = tick()
    
    print("[Farm] Attacking:", Mob.Name)
    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
    
    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 and LoopEnabled do
        task.wait(0.05)
        
        if not IsAlive() then
            if LastTween then LastTween:Cancel() end
            return
        end
        
        Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        local MyHumanoid = Char:FindFirstChildOfClass("Humanoid")
        if not MyHumanoid then return end
        
        -- ตรวจสอบว่าโดนตีหรือไม่ (HP ลดลง)
        local CurrentHP = MyHumanoid.Health
        if CurrentHP < LastHP then
            HitCount = HitCount + 1
            -- โดนตี! เพิ่มระยะห่าง
            SafeHeightOffset = SafeHeightOffset + 1
            print("[Farm] โดนตี! เพิ่มระยะเป็น +", SafeHeightOffset, "studs")
        end
        LastHP = CurrentHP
        
        -- ถ้าไม่โดนตี 5 วินาที และ offset > 2 ลองลดลง
        if tick() - CheckTime > 5 then
            if HitCount == 0 and SafeHeightOffset > 2 then
                SafeHeightOffset = SafeHeightOffset - 0.5
                print("[Farm] ไม่โดนตี ลดระยะเป็น +", SafeHeightOffset, "studs")
            end
            HitCount = 0
            CheckTime = tick()
        end
        
        if not Mob or not Mob.Parent then break end
        
        MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
        if not MobHRP then break end
        
        MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
        if not MobHumanoid or MobHumanoid.Health <= 0 then break end
        
        local MobPosition = MobHRP.Position
        local MobSize = Mob:GetExtentsSize()
        local MobHeight = MobSize.Y
        local MyPosition = Char.HumanoidRootPart.Position
        local Magnitude = (MyPosition - MobPosition).Magnitude
        
        -- ตำแหน่งที่ปลอดภัย: ใช้ SafeHeightOffset ที่ปรับอัตโนมัติ
        local SafePosition = MobPosition + Vector3.new(0, MobHeight/2 + SafeHeightOffset, 0)
        
        -- ระยะโจมตี
        local AttackRange = 20
        
        if Magnitude < AttackRange then
            if LastTween then LastTween:Cancel() end
            task.delay(0.01, function()
                if tick() > LastAttack and IsAlive() then
                    AttackMob()
                    LastAttack = tick() + 0.1
                end
            end)
            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                -- นอนราบ หัวชี้ลง (อยู่เหนือ mob)
                Char.HumanoidRootPart.CFrame = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
            end
        else
            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(MobPosition)})
                LastTween:Play()
            end
        end
    end
    return true
end

local function FarmRock(targetName)
    if not IsAlive() then return end
    
    local Char = Plr.Character
    local Rock = getNearest(Char, targetName)
    local LastAttack = 0
    local LastTween = nil
    
    if Rock then
        print("[Farm] Found Rock:", Rock.Name)
        local Position = Rock:GetAttribute("OriginalCFrame").Position
        
        while Rock:GetAttribute("Health") > 0 and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() and LoopEnabled do
            task.wait(0.1)
            
            if not IsAlive() then
                if LastTween then LastTween:Cancel() end
                return
            end
            
            Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
            
            local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
            
            if Magnitude < 15 then
                if LastTween then LastTween:Cancel() end
                if tick() > LastAttack and IsAlive() then
                    AttackRock()
                    LastAttack = tick() + 0.2
                end
                if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                    Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 0.75))
                end
            else
                if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                    LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                    LastTween:Play()
                end
            end
        end
        return true
    end
    return false
end

local function DoForgeAndSell()
    if not IsAlive() then return end
    
    local Char = Plr.Character
    local Position = workspace.Proximity.Forge.Position
    local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
    
    if Magnitude < 5 then
        Char.HumanoidRootPart.CFrame = CFrame.new(Position)
        
        local ForgeCount = 0
        local CanForge = true
        
        while CanForge and LoopEnabled do
            task.wait()
            if not IsAlive() then return end
            
            local Recipe = GetRecipe()
            if Recipe then
                print("[Forge] Forging...")
                Forge(Recipe)
                ForgeCount = ForgeCount + 1
            else
                CanForge = false
            end
        end
        
        if ForgeCount > 0 then
            TalkToMarbles()
            task.wait(0.5)
            SellEquipments()
            task.wait(0.5)
            TalkToGreedyCey()
            task.wait(0.5)
            SellOres()
        end
    else
        if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
            local ForgeTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
            ForgeTween:Play()
            ForgeTween.Completed:Wait()
        end
    end
end

-- ===== QUEST OBJECTIVE PROCESSORS =====
local function ProcessTalkObjective(objective)
    local npcName = objective.Objective.Target
    if npcName then
        print("[Quest] Talk to:", npcName)
        TalkToNPC(npcName)
        task.wait(1)
    end
end

-- ฟาร์ม Kill objectives ทั้งหมดพร้อมกัน (สำหรับ Quest ที่มีหลาย Kill objectives)
local function ProcessAllKillObjectives(questInfo)
    if not questInfo then return end
    
    -- เก็บ NPC เจ้าของ Quest (ดึงจาก questId เช่น "Captain Rowan 4" -> "Captain Rowan")
    local questId = questInfo.Id or ""
    CurrentQuestNPC = questId:match("^(.-)%s*%d*$") or questId
    print("[Quest] NPC เจ้าของ Quest:", CurrentQuestNPC)
    
    -- รวบรวม mob ทั้งหมดที่ต้องฆ่า
    local allTargets = {}
    local incompleteObjectives = GetAllIncompleteObjectives(questInfo)
    
    for _, obj in ipairs(incompleteObjectives) do
        if obj.Objective.Type == "Kill" then
            local target = obj.Objective.Target
            if target then
                table.insert(allTargets, target)
            end
        end
    end
    
    if #allTargets == 0 then return end
    
    print("[Quest] ===============================")
    print("[Quest] Farming all Kill targets:")
    for _, t in ipairs(allTargets) do
        print("[Quest]  -", t)
    end
    print("[Quest] ===============================")
    
    CurrentFarmMode = "Mob"
    local lastProgressLog = 0
    MobNotFoundStartTime = nil  -- reset timeout
    
    -- ฟาร์มจนกว่าจะครบทุก objectives
    while LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        -- เช็คกระเป๋าเต็ม
        if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
            DoForgeAndSell()
        end
        
        -- หา mob ที่ใกล้ที่สุดจาก targets ทั้งหมด
        local Char = Plr.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            local closestMob = nil
            local closestDist = math.huge
            
            for _, targetName in ipairs(allTargets) do
                local mob = getNearestMob(Char, targetName)
                if mob then
                    local hrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                    if hrp then
                        local dist = (Char.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < closestDist then
                            closestMob = mob
                            closestDist = dist
                        end
                    end
                end
            end
            
            if closestMob then
                -- เจอ mob แล้ว reset timeout
                MobNotFoundStartTime = nil
                -- ฟาร์ม mob ที่ใกล้ที่สุด
                FarmMob(closestMob.Name)
            else
                -- ไม่เจอ mob - เช็ค timeout
                if MobNotFoundStartTime == nil then
                    MobNotFoundStartTime = tick()
                    print("[Quest] ไม่เจอ mob target ใดๆ - เริ่มนับ timeout...")
                end
                
                local elapsed = tick() - MobNotFoundStartTime
                if elapsed > MOB_TIMEOUT then
                    -- Timeout! กลับไปหา NPC
                    print("[Quest] ❌ Timeout! หา mob ไม่เจอ", MOB_TIMEOUT, "วินาที")
                    print("[Quest] 🔄 กลับไปหา NPC:", CurrentQuestNPC)
                    MobNotFoundStartTime = nil
                    
                    if CurrentQuestNPC and CurrentQuestNPC ~= "" then
                        TalkToNPC(CurrentQuestNPC)
                        task.wait(1)
                    end
                    break  -- ออกจาก loop เพื่อให้ main loop เช็ค quest ใหม่
                end
                
                if tick() - lastProgressLog > 3 then
                    lastProgressLog = tick()
                    print("[Quest] รอ mob spawn... (", string.format("%.1f", elapsed), "/", MOB_TIMEOUT, "s)")
                end
                task.wait(0.5)
            end
        end
        
        -- อัพเดท progress และเช็คว่าครบหรือยัง
        local newQuestInfo = GetActiveQuestInfo()
        if newQuestInfo then
            local stillIncomplete = GetAllIncompleteObjectives(newQuestInfo)
            local hasKillLeft = false
            
            -- แสดง progress ทุก 3 วินาที
            if tick() - lastProgressLog > 3 then
                lastProgressLog = tick()
                print("[Quest] -------- Progress --------")
                for _, obj in ipairs(stillIncomplete) do
                    if obj.Objective.Type == "Kill" then
                        hasKillLeft = true
                        print("[Quest]", obj.Objective.Target, ":", obj.Current, "/", obj.Required)
                    end
                end
                if not hasKillLeft then
                    print("[Quest] All Kill objectives completed!")
                end
                print("[Quest] -----------------------------")
            else
                for _, obj in ipairs(stillIncomplete) do
                    if obj.Objective.Type == "Kill" then
                        hasKillLeft = true
                        break
                    end
                end
            end
            
            if not hasKillLeft then
                print("[Quest] ✓ All Kill objectives completed!")
                break
            end
        else
            break
        end
        
        task.wait(0.1)
    end
end

local function ProcessKillObjective(objective)
    local mobName = objective.Objective.Target
    if mobName then
        print("[Quest] Kill:", mobName, "(", objective.Current, "/", objective.Required, ")")
        CurrentFarmMode = "Mob"
        CurrentTarget = mobName
        MobNotFoundStartTime = nil  -- reset timeout
        
        while objective.Current < objective.Required and LoopEnabled do
            if not IsAlive() then
                WaitForRespawn()
            end
            
            -- เช็คกระเป๋าเต็ม
            if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
                DoForgeAndSell()
            end
            
            local result = FarmMob(mobName)
            
            -- เช็ค timeout - กลับไปหา NPC
            if result == "timeout" then
                print("[Quest] 🔄 กลับไปหา NPC:", CurrentQuestNPC)
                if CurrentQuestNPC and CurrentQuestNPC ~= "" then
                    TalkToNPC(CurrentQuestNPC)
                    task.wait(1)
                end
                break  -- ออกจาก loop เพื่อให้ main loop เช็ค quest ใหม่
            end
            
            -- อัพเดท progress
            local questInfo = GetActiveQuestInfo()
            if questInfo then
                local newObj = GetCurrentObjective(questInfo)
                if newObj and newObj.Index == objective.Index then
                    objective.Current = newObj.Current
                else
                    break
                end
            else
                break
            end
            task.wait(0.1)
        end
    end
end

local function ProcessMineObjective(objective)
    local rockName = objective.Objective.Target
    if rockName then
        print("[Quest] Mine:", rockName, "(", objective.Current, "/", objective.Required, ")")
        CurrentFarmMode = "Rock"
        CurrentTarget = rockName
        
        while objective.Current < objective.Required and LoopEnabled do
            if not IsAlive() then
                WaitForRespawn()
            end
            
            -- เชคกระเปาเตม
            if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
                DoForgeAndSell()
            end
            
            FarmRock(rockName)
            
            -- อพเดท progress
            local questInfo = GetActiveQuestInfo()
            if questInfo then
                local newObj = GetCurrentObjective(questInfo)
                if newObj and newObj.Index == objective.Index then
                    objective.Current = newObj.Current
                else
                    break
                end
            else
                break
            end
            task.wait(0.1)
        end
    end
end

local function ProcessForgeObjective(objective)
    print("[Quest] Forge:", objective.Current, "/", objective.Required)
    
    while objective.Current < objective.Required and LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        if Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() then
            FarmRock(nil)
        else
            DoForgeAndSell()
        end
        
        local questInfo = GetActiveQuestInfo()
        if questInfo then
            local newObj = GetCurrentObjective(questInfo)
            if newObj and newObj.Index == objective.Index then
                objective.Current = newObj.Current
            else
                break
            end
        else
            break
        end
        task.wait(0.1)
    end
end

local function ProcessEquipObjective(objective)
    print("[Quest] Equip item")
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    if PlayerInventory and PlayerInventory["Equipments"] then
        for i, v in pairs(PlayerInventory["Equipments"]) do
            if v["GUID"] then
                pcall(function()
                    ToolActivated:InvokeServer("Equip", v["GUID"])
                end)
                task.wait(0.5)
                break
            end
        end
    end
end

local function ProcessCollectObjective(objective)
    local itemName = objective.Objective.Target
    print("[Quest] Collect:", itemName)
    
    while objective.Current < objective.Required and LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
            DoForgeAndSell()
        end
        
        FarmRock(nil)
        
        local questInfo = GetActiveQuestInfo()
        if questInfo then
            local newObj = GetCurrentObjective(questInfo)
            if newObj and newObj.Index == objective.Index then
                objective.Current = newObj.Current
            else
                break
            end
        else
            break
        end
        task.wait(0.1)
    end
end

local function ProcessUIObjective(objective)
    print("[Quest] UI:", objective.Objective.Target or "Unknown")
    task.wait(1)
end

local function ProcessObjective(objectiveInfo, questInfo)
    if not objectiveInfo then return end
    local objType = objectiveInfo.Objective.Type
    
    -- เก็บ NPC เจ้าของ Quest (ดึงจาก questId เช่น "Captain Rowan 4" -> "Captain Rowan")
    if questInfo and questInfo.Id then
        local questId = questInfo.Id or ""
        CurrentQuestNPC = questId:match("^(.-)%s*%d*$") or questId
    end
    
    if objType == "Talk" then
        ProcessTalkObjective(objectiveInfo)
    elseif objType == "Kill" then
        -- ใช้ ProcessAllKillObjectives เพื่อฟาร์มทุก Kill objectives พร้อมกัน
        ProcessAllKillObjectives(questInfo)
    elseif objType == "Mine" then
        ProcessMineObjective(objectiveInfo)
    elseif objType == "Forge" then
        ProcessForgeObjective(objectiveInfo)
    elseif objType == "Equip" then
        ProcessEquipObjective(objectiveInfo)
    elseif objType == "Collect" then
        ProcessCollectObjective(objectiveInfo)
    elseif objType == "UI" then
        ProcessUIObjective(objectiveInfo)
    else
        print("[Quest] Unknown type:", objType)
        task.wait(1)
    end
end

-- ===== MAIN LOOP =====
local function MainLoop()
    while LoopEnabled do
        local success, err = pcall(function()
            if not IsAlive() then
                WaitForRespawn()
                return
            end
            
            local questInfo = GetActiveQuestInfo()
            
            if questInfo then
                print("[System] Active Quest:", questInfo.Id)
                local objective = GetCurrentObjective(questInfo)
                if objective then
                    ProcessObjective(objective, questInfo)
                else
                    print("[System] Quest completed, checking next...")
                    task.wait(2)
                end
            else
                -- ไม่มี Quest = ฟาร์มหินอัตโนมัติ
                print("[System] No quest, auto farming...")
                
                if Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() then
                    FarmRock(nil)
                else
                    DoForgeAndSell()
                end
            end
        end)
        
        if not success then
            warn("[System] Error:", err)
        end
        
        task.wait(0.1)
    end
end

-- ===== ANTI-AFK =====
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- ===== NO COLLISION (เหมือน TF_System.lua ทุกประการ) =====
if _G.Stepped then
    _G.Stepped:Disconnect()
end
if _G.RenderStepped then
    _G.RenderStepped:Disconnect()
end

_G.Stepped = game:GetService("RunService").Stepped:Connect(function()
    if not IsAlive() then return end
    
    pcall(function()
        if not Plr.Character.HumanoidRootPart:FindFirstChild("Body") then
            local L_1 = Instance.new("BodyVelocity")
            L_1.Name = "Body"
            L_1.Parent = Plr.Character.HumanoidRootPart 
            L_1.MaxForce=Vector3.new(1000000000,1000000000,1000000000)
            L_1.Velocity=Vector3.new(0,0,0) 
        end
    end)
    
    pcall(function ()
        local character = Plr.Character
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end)

-- ===== AUTO SELL NEW EQUIPMENT =====
PlayerController.Replica:OnWrite("GiveItem", function(t, v)
    if type(t) == "table" then
        task.wait(2)
        pcall(function()
            RunCommand:InvokeServer("SellConfirm", {
                Basket = {
                    [t["GUID"]] = true,
                }
            })
        end)
    end
end)

-- ===== START =====
print("========================================")
print("   TF_AutoQuest - Auto Everything")
print("   Farm system from TF_System.lua")
print("========================================")
print("[System] Starting...")
task.wait(1)
print("[System] Running Main Loop...")
MainLoop()
