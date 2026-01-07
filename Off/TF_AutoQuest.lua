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

-- ใช้ getrenv().require แทน require ปกติ เพื่อโหลด LocalScript module
local InventoryModule = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory")
local Inventory

-- วิธี 1: getrenv().require
local success, result = pcall(function()
    return getrenv().require(InventoryModule)
end)
if success and result then
    Inventory = result
    print("[Init] Inventory loaded via getrenv().require")
end

-- วิธี 2: หาจาก getgc
if not Inventory then
    pcall(function()
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                if rawget(obj, "CalculateTotal") and rawget(obj, "GetBagCapacity") then
                    Inventory = obj
                    print("[Init] Inventory found via getgc (CalculateTotal)")
                    break
                end
            end
        end
    end)
end

-- วิธี 3: หาจาก Knit Controller
if not Inventory then
    pcall(function()
        local UIController = Knit.GetController("UIController")
        if UIController and UIController.Inventory then
            Inventory = UIController.Inventory
            print("[Init] Inventory found via Knit UIController")
        end
    end)
end

-- วิธี 4: สร้าง fallback functions ถ้าหาไม่เจอ
if not Inventory then
    print("[Init] WARNING: Inventory not found, using fallback functions")
    Inventory = {
        CalculateTotal = function(self, stashType)
            -- นับ items ใน inventory
            local total = 0
            pcall(function()
                local inv = PlayerController.Replica.Data.Inventory
                for name, amount in pairs(inv) do
                    if type(amount) == "number" then
                        total = total + amount
                    end
                end
            end)
            return total
        end,
        GetBagCapacity = function(self)
            -- Default bag capacity
            return 100
        end
    }
end

-- ===== SAFE INVENTORY WRAPPER =====
-- สร้าง wrapper functions ที่ปลอดภัย ป้องกัน error
local function SafeCalculateTotal(stashType)
    local result = 0
    
    -- วิธีที่ 1: ใช้ Inventory module
    local ok1 = pcall(function()
        if Inventory and type(Inventory.CalculateTotal) == "function" then
            result = Inventory:CalculateTotal(stashType) or 0
        end
    end)
    
    -- วิธีที่ 2: นับจาก PlayerController โดยตรง (backup)
    if result == 0 then
        pcall(function()
            local PlayerInventory = PlayerController.Replica.Data.Inventory
            local count = 0
            
            -- นับ Ore
            for itemName, amount in pairs(PlayerInventory) do
                if type(amount) == "number" and amount > 0 then
                    count = count + amount
                end
            end
            
            -- นับ Equipment
            if PlayerInventory["Equipments"] then
                count = count + #PlayerInventory["Equipments"]
            end
            
            -- นับ Rune
            if PlayerInventory["Runes"] then
                count = count + #PlayerInventory["Runes"]
            end
            
            result = count
        end)
    end
    
    if type(result) ~= "number" then
        result = 0
    end
    
    return result
end

local function SafeGetBagCapacity()
    local result = 100  -- default
    
    -- วิธีที่ 1: ใช้ Inventory module
    pcall(function()
        if Inventory and type(Inventory.GetBagCapacity) == "function" then
            result = Inventory:GetBagCapacity() or 100
        end
    end)
    
    -- วิธีที่ 2: ดึงจาก PlayerController (backup)
    if result == 100 then
        pcall(function()
            local bagCap = PlayerController.Replica.Data.BagCapacity
            if bagCap and type(bagCap) == "number" then
                result = bagCap
            end
        end)
    end
    
    if type(result) ~= "number" then
        result = 100
    end
    
    return result
end

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
local TeleportToIsland = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PortalService"):WaitForChild("RF"):WaitForChild("TeleportToIsland")
local PurchaseRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Purchase")

-- ===== SPECIAL QUEST CONFIG =====
-- Mono 7 Quest: ตี Iceberg -> ซื้อ Prismatic Pickaxe
local PRISMATIC_PICKAXE_PRICE = 0  -- ราคา Prismatic Pickaxe (ต้องหาจากเกม)
local MONO7_QUEST_ID = "Mono 7"    -- Quest ID ที่ต้องตี Iceberg

-- ===== ISLAND/WORLD DATA =====
-- รายชื่อโลกทั้งหมด และ NPC/Quest/Mobs/Ores ที่อยู่ในแต่ละโลก
-- อ้างอิงจาก https://forgewiki.org/wiki/Ores
-- ชื่อโลกต้องตรงกับที่ใช้ใน TeleportToIsland:InvokeServer()
local IslandData = {
    -- โลกแรก - Pebble, Rock, Boulder
    ["Stonewake's Cross"] = {
        NPCs = {"Marbles", "Greedy Cey", "Hollis"},
        Quests = {"The Basics of Mining", "Hollis", "Basics"},
        Mobs = {"Slime", "Skeleton", "Zombie", "Bomber", "Skeleton Rogue", "Axe Skeleton", "Deathaxe Skeleton"},
        Ores = {
            "Stone", "Sand Stone", "Copper", "Iron", "Tin", "Silver", "Gold",
            "Mushroomite", "Platinum", "Bananite", "Cardboardite", "Aite", "Poopite",
            "Grass"
        },
        Rocks = {"Pebble", "Rock", "Boulder"}
    },
    
    -- Forgotten Kingdom - Basalt Rock, Basalt Core, Basalt Vein, Volcanic Rock
    ["Forgotten Kingdom"] = {
        NPCs = {"Captain Rowan", "Blacksmith"},
        Quests = {"Captain Rowan", "CaptainRowanQuest", "CaptainRowanQuestFinal"},
        Mobs = {
            "Blazing Slime", "Reaper", "Elite Deathaxe Skeleton", "Elite Skeleton Rogue",
            "Blight Pyromancer", "Dark Knight"
        },
        Ores = {
            "Cobalt", "Titanium", "Lapis Lazuli", "Boneite", "Volcanic Rock",
            "Quartz", "Amethyst", "Topaz", "Diamond", "Dark Boneite", "Sapphire",
            "Cuprite", "Obsidian", "Emerald", "Ruby", "Rivalite", "Slimite",
            "Uranium", "Mythril", "Eye Ore", "Fireite", "Magmaite", "Lightite",
            "Demonite", "Darkryte"
        },
        Rocks = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"}
    },
    
    -- Goblin Cave
    ["Goblin Cave"] = {
        NPCs = {},
        Quests = {},
        Mobs = {"Goblin"},
        Ores = {
            "Orange Crystal Ore", "Magenta Crystal Ore", "Green Crystal Ore",
            "Crimson Crystal Ore", "Blue Crystal Ore", "Rainbow Crystal Ore", "Arcane Crystal Ore"
        },
        Rocks = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"}
    },
    
    -- Frostspire Expanse - Icy Pebble, Icy Rock, Icy Boulder, Ice Crystals
    ["Frostspire Expanse"] = {
        NPCs = {"Ice Guardian"},
        Quests = {"Ice Guardian"},
        Mobs = {"Frost Giant", "Ice Elemental", "Prismarine Spider", "Yeti", "Golem"},
        Ores = {
            "Tungsten Ore", "Sulfur Ore", "Pumice Ore", "Graphite Ore", "Aetherit Ore",
            "Scheelite Ore", "Larimar Ore", "Neurotite Ore", "Frost Fossil Ore",
            "Tide Carve Ore", "Velchire Ore", "Sanctis Ore", "Snowite Ore", "Iceite Ore",
            "Mistvein Ore", "Lgarite Ore", "Voidfractal Ore", "Moltenfrost Ore",
            "Crimsonite Ore", "Malachite Ore", "Aqujade Ore", "Cryptex Ore", "Galestor Ore",
            "Voidstar Ore", "Etherealite Ore", "Suryafal Ore", "Heavenite", "Gargantuan Ore",
            "Mosasaursit", "Prismatic Heart", "Yeti Heart", "Golem Heart"
        },
        Rocks = {"Icy Pebble", "Icy Rock", "Icy Boulder", "Small Ice Crystal", "Medium Ice Crystal", "Large Ice Crystal", "Floating Crystal", "Iceburg"}
    },
    
    -- The Peak - Red Crystals
    ["The Peak"] = {
        NPCs = {},
        Quests = {},
        Mobs = {},
        Ores = {
            "Frogite", "Moon Stone", "Gulabite", "Coinite", "Duranite", "Evil Eye",
            "Stolen Heart", "Heart of The Island"
        },
        Rocks = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal", "Heart Of The Island Crystal"}
    },
    
    -- Raven Cave
    ["Raven Cave"] = {
        NPCs = {},
        Quests = {},
        Mobs = {},
        Ores = {},
        Rocks = {}
    }
}

-- ป้องกัน spam log สำหรับ Portal
local LastPortalLog = 0

-- ===== ORE TO ROCK MAPPING =====
-- Quest objective อาจให้ชื่อ Ore (เช่น "Stone") แต่ใน workspace.Rocks ชื่อคือ Rock (เช่น "Pebble")
-- Mapping นี้บอกว่า Ore ไหน drop จาก Rock ไหน
local OreToRockMapping = {
    -- Stonewake's Cross (Pebble, Rock, Boulder drop พวกนี้)
    ["Stone"] = {"Pebble"},
    ["Sand Stone"] = {"Pebble", "Rock", "Boulder"},
    ["Copper"] = {"Pebble", "Rock"},
    ["Iron"] = {"Pebble", "Rock", "Boulder"},
    ["Tin"] = {"Pebble", "Rock", "Boulder"},
    ["Silver"] = {"Pebble", "Rock", "Boulder"},
    ["Gold"] = {"Pebble", "Rock", "Boulder"},
    ["Platinum"] = {"Pebble", "Rock", "Boulder"},
    ["Mushroomite"] = {"Pebble", "Rock", "Boulder"},
    ["Bananite"] = {"Pebble", "Rock", "Boulder"},
    ["Cardboardite"] = {"Pebble", "Rock", "Boulder"},
    ["Aite"] = {"Pebble", "Rock", "Boulder"},
    ["Poopite"] = {"Pebble", "Rock", "Boulder"},
    ["Grass"] = {"Pebble", "Rock", "Boulder"},
    
    -- Forgotten Kingdom (Basalt Rock, Basalt Core, Basalt Vein, Volcanic Rock)
    ["Cobalt"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Titanium"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Lapis Lazuli"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Boneite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Quartz"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Amethyst"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Topaz"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Diamond"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Dark Boneite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Sapphire"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Cuprite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Obsidian"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Emerald"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Ruby"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Rivalite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Slimite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Uranium"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Mythril"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Eye Ore"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Fireite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Magmaite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Lightite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Demonite"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    ["Darkryte"] = {"Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock"},
    
    -- Goblin Cave (Crystals)
    ["Orange Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Magenta Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Green Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Crimson Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Blue Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Rainbow Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    ["Arcane Crystal Ore"] = {"Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Light Crystal"},
    
    -- Frostspire Expanse (Icy Rocks, Ice Crystals)
    ["Tungsten Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder", "Small Ice Crystal", "Medium Ice Crystal", "Large Ice Crystal"},
    ["Sulfur Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder"},
    ["Pumice Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder"},
    ["Graphite Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder"},
    ["Snowite Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder"},
    ["Iceite Ore"] = {"Icy Pebble", "Icy Rock", "Icy Boulder"},
    
    -- The Peak (Red Crystals)
    ["Frogite"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Moon Stone"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Gulabite"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Coinite"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Duranite"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Evil Eye"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
    ["Stolen Heart"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal"},
}

-- หาโลกปัจจุบันจาก PlaceId หรือ workspace
local function GetCurrentIsland()
    -- วิธีที่ 1: เช็คจาก workspace.Island
    local island = workspace:FindFirstChild("Island")
    if island and island:GetAttribute("Name") then
        local name = island:GetAttribute("Name")
        return name
    end
    
    -- วิธีที่ 2: เช็คจาก PlayerController
    local playerIsland = nil
    pcall(function()
        local data = PlayerController.Replica.Data
        if data and data.CurrentIsland then
            playerIsland = data.CurrentIsland
        end
    end)
    if playerIsland then
        return playerIsland
    end
    
    -- วิธีที่ 3: เช็คจาก Rock (แม่นยำที่สุด!)
    local rocks = workspace:FindFirstChild("Rocks")
    if rocks then
        for _, folder in pairs(rocks:GetChildren()) do
            if folder:IsA("Folder") then
                for _, rockChild in pairs(folder:GetChildren()) do
                    local model = rockChild:FindFirstChildWhichIsA("Model")
                    if model and model:GetAttribute("Health") and model:GetAttribute("Health") > 0 then
                        local rockName = model.Name:lower()
                        -- เช็คตาม Rock type (ชัดเจน)
                        if string.find(rockName, "basalt") or string.find(rockName, "volcanic") then
                            return "Forgotten Kingdom"
                        elseif string.find(rockName, "icy") or string.find(rockName, "iceberg") or string.find(rockName, "ice crystal") then
                            return "Frostspire Expanse"
                        elseif string.find(rockName, "red crystal") then
                            return "The Peak"
                        elseif string.find(rockName, "crystal") then
                            return "Goblin Cave"
                        elseif string.find(rockName, "pebble") or string.find(rockName, "boulder") or rockName == "rock" then
                            return "Stonewake's Cross"
                        end
                    end
                end
            end
        end
    end
    
    -- วิธีที่ 4: เช็คจาก NPC เฉพาะโลก (NPC ที่ไม่ซ้ำกัน)
    local proximity = workspace:FindFirstChild("Proximity")
    if proximity then
        -- Captain Rowan มีแค่โลก 2
        if proximity:FindFirstChild("Captain Rowan") then
            return "Forgotten Kingdom"
        end
        -- Ice Guardian มีแค่โลก 3
        if proximity:FindFirstChild("Ice Guardian") then
            return "Frostspire Expanse"
        end
        -- Hollis มีแค่โลก 1
        if proximity:FindFirstChild("Hollis") then
            return "Stonewake's Cross"
        end
    end
    
    -- Default
    return "Stonewake's Cross"
end

-- หาโลกที่ Quest/NPC อยู่
local function GetIslandForQuest(questId, npcName)
    -- เช็คจาก Quest ID
    if questId then
        for islandName, islandInfo in pairs(IslandData) do
            for _, questPattern in ipairs(islandInfo.Quests) do
                if string.find(questId, questPattern) then
                    return islandName
                end
            end
        end
    end
    
    -- เช็คจาก NPC Name
    if npcName then
        for islandName, islandInfo in pairs(IslandData) do
            for _, npc in ipairs(islandInfo.NPCs) do
                if string.find(npcName, npc) or string.find(npc, npcName) then
                    return islandName
                end
            end
        end
    end
    
    return nil
end

-- หาโลกที่ Mob อยู่
local function GetIslandForMob(mobName)
    if not mobName then return nil end
    
    for islandName, islandInfo in pairs(IslandData) do
        for _, mob in ipairs(islandInfo.Mobs) do
            if string.find(mobName:lower(), mob:lower()) or string.find(mob:lower(), mobName:lower()) then
                return islandName
            end
        end
    end
    
    return nil
end

-- หาโลกที่ Ore/Item อยู่ (เช็คชื่อตรงๆ เท่านั้น!)
local function GetIslandForOre(oreName)
    if not oreName then return nil end
    
    local oreNameLower = oreName:lower()
    
    -- เช็คชื่อตรงๆ เท่านั้น (exact match only)
    for islandName, islandInfo in pairs(IslandData) do
        for _, ore in ipairs(islandInfo.Ores) do
            if ore:lower() == oreNameLower then
                print("[Island] GetIslandForOre:", oreName, "->", islandName)
                return islandName
            end
        end
    end
    
    print("[Island] GetIslandForOre:", oreName, "-> ไม่เจอ")
    return nil
end

-- Teleport ไปยังโลกที่ต้องการ
local function TeleportToWorld(targetIsland)
    local currentIsland = GetCurrentIsland()
    
    if currentIsland == targetIsland then
        print("[Portal] อยู่โลก", targetIsland, "อยู่แล้ว")
        return true
    end
    
    print("[Portal] ============================")
    print("[Portal] กำลังย้ายจาก:", currentIsland)
    print("[Portal] ไปยัง:", targetIsland)
    print("[Portal] ============================")
    
    local success, result = pcall(function()
        return TeleportToIsland:InvokeServer(targetIsland)
    end)
    
    if success then
        print("[Portal] ส่งคำขอ teleport สำเร็จ!")
        -- รอให้ teleport เสร็จ
        task.wait(5)
        
        -- รอจน character พร้อม
        repeat
            task.wait(0.5)
        until Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
        
        task.wait(2)  -- รอเพิ่มให้โลกโหลดเสร็จ
        print("[Portal] Teleport สำเร็จ!")
        return true
    else
        print("[Portal] Teleport ล้มเหลว:", result)
        return false
    end
end

-- เช็คและ Teleport ถ้า Quest/NPC อยู่คนละโลก
local function EnsureCorrectIsland(questId, npcName, targetName)
    local currentIsland = GetCurrentIsland()
    local targetIsland = nil
    
    print("[Island] ===== EnsureCorrectIsland =====")
    print("[Island] questId:", questId or "nil")
    print("[Island] npcName:", npcName or "nil")
    print("[Island] targetName:", targetName or "nil")
    print("[Island] currentIsland:", currentIsland)
    
    -- ลองหาโลกจาก Quest ID ก่อน
    if questId then
        targetIsland = GetIslandForQuest(questId, nil)
        if targetIsland then
            print("[Island] เจอโลกจาก questId:", targetIsland)
        end
    end
    
    -- ถ้าไม่เจอ ลองจาก NPC
    if not targetIsland and npcName then
        targetIsland = GetIslandForQuest(nil, npcName)
        if targetIsland then
            print("[Island] เจอโลกจาก npcName:", targetIsland)
        end
    end
    
    -- ถ้าไม่เจอ ลองจาก Mob
    if not targetIsland and targetName then
        targetIsland = GetIslandForMob(targetName)
        if targetIsland then
            print("[Island] เจอโลกจาก mob:", targetIsland)
        end
    end
    
    -- ถ้าไม่เจอ ลองจาก Ore/Item
    if not targetIsland and targetName then
        targetIsland = GetIslandForOre(targetName)
        if targetIsland then
            print("[Island] เจอโลกจาก ore:", targetIsland)
        end
    end
    
    print("[Island] targetIsland:", targetIsland or "nil")
    print("[Island] ================================")
    
    -- ถ้าไม่รู้ว่า target อยู่โลกไหน -> ข้ามไปเลย ไม่ทำอะไร
    if not targetIsland then
        print("[Island] ไม่รู้ว่า target อยู่โลกไหน -> ข้าม")
        return true
    end
    
    -- ถ้าอยู่โลกเดียวกันแล้ว -> ข้ามไปเลย ไม่ต้องวาป
    if currentIsland == targetIsland then
        print("[Island] อยู่โลกเดียวกันแล้ว -> ข้าม")
        return true
    end
    
    -- อยู่คนละโลก -> Teleport
    print("[Portal] Quest/NPC/Mob/Ore อยู่โลก:", targetIsland, "แต่เราอยู่:", currentIsland)
    return TeleportToWorld(targetIsland)
end

-- หา DialogueBindable สำหรับส่ง event ภายใน
local DialogueBindable = ReplicatedStorage:FindFirstChild("DialogueBindable", true)

-- เกบ Equipment ทมตอนเรม (ไมขาย)
local InsertEquipments = {}
for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
    table.insert(InsertEquipments, v["GUID"])
end

-- ===== MOB SEARCH TIMEOUT SYSTEM =====
local MobNotFoundStartTime = nil  -- เวลาที่เริ่มหา mob ไม่เจอ
local CurrentQuestNPC = nil       -- ชื่อ NPC เจ้าของ Quest ปัจจุบัน
local MOB_TIMEOUT = 60            -- วินาที รอ mob spawn นานขึ้น (60 วินาที)
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
    task.wait(3)  -- รอนานขึ้นหลังตาย ป้องกัน TP เร็วไป
end

-- ===== BASE MOVEMENT FUNCTION =====
local CurrentTween = nil

local function TweenToPosition(targetPosition, speed, onArrive)
    if not IsAlive() then return false end
    
    local Char = Plr.Character
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    
    speed = speed or 80
    local distance = (HRP.Position - targetPosition).Magnitude
    
    -- ถ้าใกล้พอแล้ว
    if distance < 5 then
        if onArrive then onArrive() end
        return true
    end
    
    -- Cancel tween เก่า
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    local tweenTime = distance / speed
    CurrentTween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(targetPosition)
    })
    CurrentTween:Play()
    
    -- รอจนถึงหรือ timeout
    local startTime = tick()
    local maxTime = tweenTime + 2
    
    while CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
        task.wait(0.1)
        if not IsAlive() then
            CurrentTween:Cancel()
            return false
        end
        if tick() - startTime > maxTime then
            CurrentTween:Cancel()
            break
        end
    end
    
    if onArrive then onArrive() end
    return true
end

local function TweenToPositionAndWait(targetPosition, speed)
    return TweenToPosition(targetPosition, speed)
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

-- ===== PLAYER MONEY/CURRENCY FUNCTIONS =====
local function GetPlayerMoney()
    local money = 0
    pcall(function()
        local data = PlayerController.Replica.Data
        if data then
            -- ลองหาหลายที่ที่เป็นไปได้
            money = data.Money or data.Coins or data.Gold or data.Currency or 0
        end
    end)
    return money
end

-- ===== PURCHASE FUNCTIONS =====
local function PurchaseItem(itemName, quantity)
    quantity = quantity or 1
    local success, result = pcall(function()
        return PurchaseRemote:InvokeServer(itemName, quantity)
    end)
    
    if success then
        print("[Purchase] ✓ ซื้อ", itemName, "x", quantity, "สำเร็จ!")
        return true
    else
        print("[Purchase] ✗ ซื้อ", itemName, "ล้มเหลว:", result)
        return false
    end
end

-- ===== ICEBERG FARMING (สำหรับ Mono 7) =====
local function FarmIceberg()
    print("[Mono7] เริ่มตี Iceberg...")
    
    local icebergFolder = workspace:FindFirstChild("Rocks") and workspace.Rocks:FindFirstChild("Iceberg")
    if not icebergFolder then
        print("[Mono7] ไม่เจอ Iceberg folder!")
        return false
    end
    
    -- หา Iceberg ที่มี Health > 0
    local function findIceberg()
        for _, child in pairs(icebergFolder:GetChildren()) do
            local model = child:FindFirstChildWhichIsA("Model")
            if model and model:GetAttribute("Health") and model:GetAttribute("Health") > 0 then
                return model
            end
        end
        return nil
    end
    
    local iceberg = findIceberg()
    if not iceberg then
        print("[Mono7] ไม่มี Iceberg ที่ตีได้!")
        return false
    end
    
    print("[Mono7] พบ Iceberg! Health:", iceberg:GetAttribute("Health"))
    
    local LastAttack = 0
    local LastTween = nil
    local Position = iceberg:GetAttribute("OriginalCFrame") and iceberg:GetAttribute("OriginalCFrame").Position or iceberg:GetPivot().Position
    
    while iceberg:GetAttribute("Health") > 0 and LoopEnabled do
        task.wait(0.1)
        
        if not IsAlive() then
            if LastTween then LastTween:Cancel() end
            WaitForRespawn()
            iceberg = findIceberg()
            if not iceberg then break end
            Position = iceberg:GetAttribute("OriginalCFrame") and iceberg:GetAttribute("OriginalCFrame").Position or iceberg:GetPivot().Position
        end
        
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then continue end
        
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
    
    print("[Mono7] ✓ Iceberg ถูกทำลาย!")
    return true
end

-- ===== MONO 7 SPECIAL QUEST HANDLER =====
local function HandleMono7Quest()
    print("[Mono7] ========================================")
    print("[Mono7] เริ่ม Mono 7 Special Quest Handler")
    print("[Mono7] ========================================")
    
    -- ขั้นตอน 1: ตี Iceberg
    print("[Mono7] ขั้นตอน 1: ตี Iceberg")
    local icebergSuccess = FarmIceberg()
    
    if not icebergSuccess then
        print("[Mono7] ตี Iceberg ไม่สำเร็จ!")
        return false
    end
    
    -- ขั้นตอน 2: ซื้อ Prismatic Pickaxe
    print("[Mono7] ขั้นตอน 2: ซื้อ Prismatic Pickaxe")
    
    local function tryPurchase()
        local success = PurchaseItem("Prismatic pickaxe", 1)
        return success
    end
    
    -- ลองซื้อครั้งแรก
    if tryPurchase() then
        print("[Mono7] ✓ ซื้อ Prismatic Pickaxe สำเร็จ!")
        return true
    end
    
    -- ถ้าซื้อไม่ได้ (เงินไม่พอ) -> ฟาร์ม mob
    print("[Mono7] เงินไม่พอ! ต้องฟาร์ม mob ก่อน...")
    
    while LoopEnabled do
        -- ฟาร์ม mob ทุกตัว
        print("[Mono7] กำลังฟาร์ม mob...")
        
        for i = 1, 20 do  -- ฟาร์ม 20 รอบ แล้วลองซื้ออีกครั้ง
            if not IsAlive() then
                WaitForRespawn()
            end
            
            if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                DoForgeAndSell()
            end
            
            -- ฟาร์ม mob ใดก็ได้
            FarmMob(nil)
            task.wait(0.1)
        end
        
        -- ขาย items ก่อน
        DoForgeAndSell()
        task.wait(1)
        
        -- ลองซื้ออีกครั้ง
        print("[Mono7] ลองซื้อ Prismatic Pickaxe อีกครั้ง...")
        if tryPurchase() then
            print("[Mono7] ✓ ซื้อ Prismatic Pickaxe สำเร็จ!")
            return true
        end
        
        print("[Mono7] ยังเงินไม่พอ ฟาร์มต่อ...")
    end
    
    return false
end

-- ===== FARM FUNCTIONS (จาก TF_System.lua) =====
-- หา Rock ที่ใกล้ที่สุด (รองรับทั้งชื่อ Rock และชื่อ Ore)
local function getNearest(P_Char, targetName)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    
    -- หา MinePower ของ Pickaxe ที่ equip อยู่
    local minePower = GetEquippedPickaxeMinePower()
    
    -- ถ้า targetName เป็นชื่อ Ore ให้หา Rock ที่ drop Ore นั้น
    local rockNames = {}
    local hasMapping = false
    if targetName and targetName ~= "" then
        if OreToRockMapping[targetName] then
            -- targetName เป็นชื่อ Ore -> หา Rock ที่ drop Ore นี้
            rockNames = OreToRockMapping[targetName]
            hasMapping = true
            print("[Farm] หา Rock ที่ drop:", targetName, "-> Rocks:", table.concat(rockNames, ", "))
        else
            -- targetName อาจเป็นชื่อ Rock อยู่แล้ว หรือ Ore ที่ไม่มี mapping
            rockNames = {targetName}
            print("[Farm] ไม่มี mapping สำหรับ:", targetName, "-> ลองหา Rock ชื่อเดียวกัน")
        end
    end
    
    -- เก็บ Rock ที่ใกล้ที่สุดทั้ง match และ fallback (ทุกก้อน)
    local fallbackPath = nil
    local fallbackDis = math.huge
    local skippedTooHard = 0
    
    for _,v in pairs(workspace.Rocks:GetChildren()) do
        if v:IsA("Folder") then
            for i1,v1 in pairs(v:GetChildren()) do
                local Model = v1:FindFirstChildWhichIsA("Model")
                if Model and Model:GetAttribute("Health") > 0 then
                    local rockHealth = Model:GetAttribute("Health")
                    local estimatedTime = EstimateMiningTime(rockHealth, minePower)
                    
                    -- ข้าม Rock ที่ยากเกินไป
                    if estimatedTime > ROCK_MINING_TIMEOUT then
                        skippedTooHard = skippedTooHard + 1
                    else
                        local Pos = Model:GetAttribute("OriginalCFrame").Position
                        local EqPos = (Pos - p_pos).Magnitude
                        
                        -- เก็บ fallback (Rock ใดก็ได้ที่ใกล้ที่สุดและขุดได้)
                        if fallbackDis > EqPos then
                            fallbackPath = Model
                            fallbackDis = EqPos
                        end
                        
                        local canFarm = false
                        
                        if #rockNames > 0 then
                            -- เช็คว่า Rock นี้ตรงกับ rockNames หรือไม่
                            for _, rockName in ipairs(rockNames) do
                                if string.find(Model.Name:lower(), rockName:lower()) then
                                    canFarm = true
                                    break
                                end
                            end
                        else
                            -- ไม่ได้ระบุ target ให้ฟาร์มทุกก้อน
                            canFarm = true
                        end
                        
                        if canFarm then
                            if dis > EqPos then
                                path = Model
                                dis = EqPos
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Debug: แสดงถ้าข้าม Rock ที่ยากเกินไป
    if skippedTooHard > 0 and tick() - (LastMobSearchLog or 0) > 10 then
        print("[Farm] ⚠️ ข้าม", skippedTooHard, "Rock ที่ยากเกินไป (MinePower:", minePower, ")")
    end
    
    -- ถ้าหาไม่เจอ Rock ที่ match ให้ใช้ fallback (ฟาร์มทุกก้อนเพื่อหา Ore)
    if not path and fallbackPath and targetName and targetName ~= "" then
        print("[Farm] ไม่เจอ Rock ที่ match กับ:", targetName, "-> ฟาร์ม Rock ทั้งหมดแทน:", fallbackPath.Name)
        path = fallbackPath
    end
    
    if not path and targetName and targetName ~= "" then
        -- Debug: แสดง Rock ทั้งหมดที่มีใน workspace
        if tick() - (LastMobSearchLog or 0) > 10 then
            LastMobSearchLog = tick()
            print("[Debug] ======= ROCKS ในพื้นที่ =======")
            local rockCount = 0
            local foundRocks = {}
            for _,v in pairs(workspace.Rocks:GetChildren()) do
                if v:IsA("Folder") then
                    for i1,v1 in pairs(v:GetChildren()) do
                        local Model = v1:FindFirstChildWhichIsA("Model")
                        if Model and Model:GetAttribute("Health") > 0 then
                            rockCount = rockCount + 1
                            if not foundRocks[Model.Name] then
                                foundRocks[Model.Name] = 0
                            end
                            foundRocks[Model.Name] = foundRocks[Model.Name] + 1
                        end
                    end
                end
            end
            print("[Debug] รวม", rockCount, "ก้อน")
            for name, count in pairs(foundRocks) do
                print("[Debug]  -", name, "x", count)
            end
            print("[Debug] กำลังหา:", targetName)
            if OreToRockMapping[targetName] then
                print("[Debug] -> ต้องหา Rock:", table.concat(OreToRockMapping[targetName], ", "))
            end
            print("[Debug] ================================")
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

-- ===== PICKAXE POWER CHECK =====
-- หา MinePower ของ Pickaxe ที่ equip อยู่
local function GetEquippedPickaxeMinePower()
    local minePower = 1  -- default
    
    pcall(function()
        local equipped = PlayerController.Replica.Data.Equipped
        if not equipped or not equipped.Pickaxe then return end
        
        local pickaxeGUID = equipped.Pickaxe
        local inventory = PlayerController.Replica.Data.Inventory["Equipments"]
        
        -- หา Pickaxe ใน inventory
        for _, equip in pairs(inventory) do
            if equip.GUID == pickaxeGUID then
                -- MinePower มาจาก Quality + Upgrade + Rune bonus
                local basePower = equip.Quality or 1
                local upgrade = equip.Upgrade or 0
                
                -- คำนวณ MinePower (ประมาณ)
                minePower = basePower + (upgrade * 2)
                
                -- ถ้ามี Rune ที่ให้ MinePower
                if equip.Rune and equip.Rune.Traits then
                    for _, trait in pairs(equip.Rune.Traits) do
                        if type(trait) == "table" and trait.MinePower then
                            minePower = minePower + trait.MinePower
                        end
                    end
                end
                
                break
            end
        end
    end)
    
    return minePower
end

-- ประมาณเวลาที่ต้องใช้ขุด Rock (วินาที)
local function EstimateMiningTime(rockHealth, minePower)
    if minePower <= 0 then minePower = 1 end
    -- สมมติว่าตี ~5 ครั้งต่อวินาที
    local hitsPerSecond = 5
    local damagePerSecond = minePower * hitsPerSecond
    local estimatedTime = rockHealth / damagePerSecond
    return estimatedTime
end

-- ค่า timeout สำหรับขุด Rock (วินาที)
local ROCK_MINING_TIMEOUT = 30  -- ถ้าขุดนานกว่า 30 วินาที ให้ข้าม
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

-- ===== NPC FUNCTIONS (ใช้ Tween เหมือน Mob/Rock) =====
local function GetNPCPosition(npc)
    if not npc then return nil end
    
    if npc:IsA("BasePart") then
        return npc.Position
    elseif npc:FindFirstChild("HumanoidRootPart") then
        return npc.HumanoidRootPart.Position
    elseif npc.PrimaryPart then
        return npc.PrimaryPart.Position
    else
        local part = npc:FindFirstChildWhichIsA("BasePart")
        if part then 
            return part.Position 
        else
            return npc:GetPivot().Position
        end
    end
end

local function TalkToMarbles()
    pcall(function()
        local marbles = workspace:WaitForChild("Proximity"):WaitForChild("Marbles")
        local marblesPos = GetNPCPosition(marbles)
        
        if marblesPos then
            local targetPos = marblesPos + Vector3.new(0, 0, 5)
            TweenToPositionAndWait(targetPos, 80)
            task.wait(0.3)
        end
        
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
        local greedyPos = GetNPCPosition(greedyCey)
        
        if greedyPos then
            local targetPos = greedyPos + Vector3.new(0, 0, 5)
            TweenToPositionAndWait(targetPos, 80)
            task.wait(0.3)
        end
        
        DialogueRemote:InvokeServer(greedyCey)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.5)
        print("[NPC] Talked to Greedy Cey")
    end)
end

-- ===== QUEST INFO FUNCTIONS (ต้องอยู่ก่อน TalkToNPC) =====
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

local function TalkToNPC(npcName, isSellNPC)
    local success, err = pcall(function()
        local npc = workspace:WaitForChild("Proximity"):FindFirstChild(npcName)
        if not npc then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == npcName and (obj:IsA("Model") or obj:IsA("BasePart")) then
                    npc = obj
                    break
                end
            end
        end
        if not npc then 
            print("[NPC] Not found:", npcName)
            return 
        end
        
        local npcPos = GetNPCPosition(npc)
        
        if npcPos then
            local targetPos = npcPos + Vector3.new(0, 0, 5)
            TweenToPositionAndWait(targetPos, 80)
            task.wait(0.5)
        end
        
        -- ถ้าเป็น Sell NPC -> แค่เปิด dialogue แล้วจบ (ไม่กดเลือก list)
        if isSellNPC then
            print("[NPC] Sell NPC - just open dialogue:", npcName)
            pcall(function()
                DialogueRemote:InvokeServer(npc)
            end)
            task.wait(0.5)
            pcall(function()
                DialogueEvent:FireServer("Opened")
            end)
            task.wait(0.3)
            return
        end
        
        -- ===== Quest NPC - กดเลือก list จนจบ =====
        
        -- เก็บ Quest ID เดิมเพื่อเช็คว่า turn in สำเร็จหรือยัง
        local originalQuestId = nil
        local originalQuest = GetActiveQuestInfo()
        if originalQuest then
            originalQuestId = originalQuest.Id
        end
        print("[NPC] Original Quest ID:", originalQuestId)
        
        -- เริ่มบทสนทนา
        print("[NPC] Opening dialogue with", npcName)
        pcall(function()
            DialogueRemote:InvokeServer(npc)
        end)
        task.wait(1.5)
        
        -- รอให้ DialogueUI โหลด
        local PlayerGui = Plr:FindFirstChild("PlayerGui")
        local dialogueUI = nil
        for i = 1, 30 do
            dialogueUI = PlayerGui and PlayerGui:FindFirstChild("DialogueUI")
            if dialogueUI and dialogueUI.Enabled then
                break
            end
            task.wait(0.1)
        end
        
        if not dialogueUI then
            print("[NPC] DialogueUI not found!")
            return
        end
        
        -- ฟังก์ชันหาปุ่มที่ต้องกด
        local function findTargetButton()
            -- Path: DialogueUI.ResponseBillboard.List.Response.Button
            local responseBillboard = dialogueUI:FindFirstChild("ResponseBillboard")
            if not responseBillboard then 
                return nil, nil 
            end
            
            local list = responseBillboard:FindFirstChild("List")
            if not list then 
                return nil, nil 
            end
            
            -- รวบรวมตัวเลือกทั้งหมดจาก List
            local options = {}
            for _, frame in pairs(list:GetChildren()) do
                if frame:IsA("Frame") and frame.Visible then
                    local button = frame:FindFirstChild("Button")
                    if button and button:IsA("TextButton") and button.Text ~= "" then
                        local layoutOrder = frame.LayoutOrder or 0
                        table.insert(options, {
                            Frame = frame,
                            Button = button,
                            Text = button.Text,
                            LayoutOrder = layoutOrder
                        })
                    end
                end
            end
            
            -- เรียงตาม LayoutOrder
            table.sort(options, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
            
            if #options > 0 then
                print("[NPC] Found", #options, "dialogue options")
            end
            
            -- หาตัวเลือกที่ต้องการ (priority)
            for i, opt in ipairs(options) do
                local lowerText = opt.Text:lower()
                if string.find(lowerText, "finished") or 
                   string.find(lowerText, "i've finished") or
                   string.find(lowerText, "ready to serve") or
                   string.find(lowerText, "completed") or
                   string.find(lowerText, "done") then
                    return opt.Button, i
                end
            end
            
            -- ถ้าไม่เจอ เลือกตัวแรก
            if #options > 0 then
                return options[1].Button, 1
            end
            
            return nil, nil
        end
        
        -- ฟังก์ชันกดปุ่ม
        local function clickButton(button)
            if not button or not button.Parent then return false end
            
            local vim = game:GetService("VirtualInputManager")
            local guiInset = game:GetService("GuiService"):GetGuiInset()
            local pos = button.AbsolutePosition
            local size = button.AbsoluteSize
            local centerX = pos.X + size.X / 2
            local centerY = pos.Y + size.Y / 2 + guiInset.Y
            
            pcall(function()
                vim:SendMouseMoveEvent(centerX, centerY, game, false)
                task.wait(0.1)
                vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                task.wait(0.05)
                vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
            end)
            
            return true
        end
        
        -- วน loop กดเลือกจนกว่า Quest จะเสร็จหรือไม่มี option
        local maxAttempts = 30
        local questTurnedIn = false
        local noOptionsCount = 0
        
        for attempt = 1, maxAttempts do
            -- เช็คว่า Quest เปลี่ยนหรือหายไปแล้วหรือยัง
            local currentQuest = GetActiveQuestInfo()
            if not currentQuest then
                print("[NPC] ✓ Quest turned in! (no quest)")
                questTurnedIn = true
                break
            elseif originalQuestId and currentQuest.Id ~= originalQuestId then
                print("[NPC] ✓ Quest changed! New:", currentQuest.Id)
                questTurnedIn = true
                break
            end
            
            -- เช็คว่า dialogue ยังเปิดอยู่หรือไม่
            local dUI = PlayerGui:FindFirstChild("DialogueUI")
            if not dUI or not dUI.Enabled then
                print("[NPC] Dialogue closed")
                noOptionsCount = noOptionsCount + 1
                if noOptionsCount >= 3 then
                    break
                end
                -- ลองเปิดใหม่
                pcall(function()
                    DialogueRemote:InvokeServer(npc)
                end)
                task.wait(1)
                continue
            end
            
            -- หาปุ่มที่ต้องกด
            local targetButton, optionIndex = findTargetButton()
            
            if targetButton then
                noOptionsCount = 0
                print("[NPC] Clicking option", optionIndex)
                clickButton(targetButton)
                task.wait(0.5)
                
                -- กด Next หลายครั้ง
                for i = 1, 5 do
                    local checkQuest = GetActiveQuestInfo()
                    if not checkQuest or (originalQuestId and checkQuest.Id ~= originalQuestId) then
                        questTurnedIn = true
                        break
                    end
                    
                    local checkUI = PlayerGui:FindFirstChild("DialogueUI")
                    if not checkUI or not checkUI.Enabled then
                        break
                    end
                    
                    pcall(function()
                        DialogueEvent:FireServer("Next")
                    end)
                    task.wait(0.3)
                end
                
                if questTurnedIn then break end
            else
                -- ไม่มีตัวเลือก ลองกด Next
                noOptionsCount = noOptionsCount + 1
                if noOptionsCount >= 5 then
                    print("[NPC] No more options, stopping")
                    break
                end
                pcall(function()
                    DialogueEvent:FireServer("Next")
                end)
                task.wait(0.4)
            end
        end
        
        -- ปิดบทสนทนา
        pcall(function()
            DialogueEvent:FireServer("Closed")
        end)
        task.wait(0.3)
        
        if questTurnedIn then
            print("[NPC] ✓ Done!", npcName)
        else
            print("[NPC] Dialogue finished for", npcName)
        end
    end)
    
    if not success then
        warn("[NPC] ERROR:", err)
    end
end

-- ===== SELL FUNCTIONS =====

-- Rarity Priority (สูงกว่า = ดีกว่า)
local RarityPriority = {
    ["Unobtainable"] = 100,
    ["Divine"] = 90,
    ["Exotic"] = 80,
    ["Relic"] = 70,
    ["Mythic"] = 60,
    ["Legendary"] = 50,
    ["Epic"] = 40,
    ["Rare"] = 30,
    ["Uncommon"] = 20,
    ["Common"] = 10,
}

-- หา Equipment ที่ดีที่สุดแต่ละประเภท (ข้าม item ที่ equip อยู่)
local function GetBestEquipments()
    local best = {
        Weapon = nil,
        Armor = nil,
        Pickaxe = nil,
    }
    local bestScore = {
        Weapon = 0,
        Armor = 0,
        Pickaxe = 0,
    }
    
    -- หา GUID ของ item ที่ equip อยู่
    local equippedGUIDs = {}
    pcall(function()
        local equipped = PlayerController.Replica.Data.Equipped
        if equipped then
            for slot, guid in pairs(equipped) do
                if guid then
                    equippedGUIDs[guid] = true
                end
            end
        end
    end)
    
    local Equipments = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Equipments"))
    
    for _, equip in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        if equip and equip.Type and equip.GUID then
            -- ข้ามถ้าเป็น item ที่ equip อยู่
            if not equippedGUIDs[equip.GUID] then
                local itemType = Equipments:GetItemType(equip.Type)
                local score = 0
                
                -- คำนวณ score จาก Quality + Upgrade + Rarity
                if equip.Quality then
                    score = score + equip.Quality
                end
                if equip.Upgrade then
                    score = score + (equip.Upgrade * 10)
                end
                if equip.Ores then
                    -- หา Ore ที่ดีที่สุดใน item
                    for oreName, _ in pairs(equip.Ores) do
                        local oreData = GetOre(oreName)
                        if oreData and oreData.Rarity then
                            local rarityScore = RarityPriority[oreData.Rarity] or 0
                            score = score + rarityScore
                        end
                    end
                end
                
                if itemType == "Weapon" and score > bestScore.Weapon then
                    bestScore.Weapon = score
                    best.Weapon = equip.GUID
                elseif itemType == "Armor" and score > bestScore.Armor then
                    bestScore.Armor = score
                    best.Armor = equip.GUID
                elseif itemType == "Pickaxe" and score > bestScore.Pickaxe then
                    bestScore.Pickaxe = score
                    best.Pickaxe = equip.GUID
                end
            end
        end
    end
    
    return best
end

-- หา Rune ที่ดีที่สุด
local function GetBestRune()
    local bestRune = nil
    local bestTier = 0
    
    for _, item in pairs(PlayerController.Replica.Data.Inventory["Misc"] or {}) do
        if item.GUID and item.Id then
            -- เช็คว่าเป็น Rune หรือไม่
            local itemType = _G.ItemTypes and _G.ItemTypes[item.Id]
            if itemType and itemType[1] == "Rune" then
                -- Rune มี Tier - tier สูงกว่า = ดีกว่า
                local tier = 1
                -- หา tier จาก Id (เช่น "FireRune_T3" -> tier 3)
                local tierMatch = item.Id:match("T(%d+)")
                if tierMatch then
                    tier = tonumber(tierMatch) or 1
                end
                
                if tier > bestTier then
                    bestTier = tier
                    bestRune = item.GUID
                end
            end
        end
    end
    
    return bestRune
end

-- ขาย Equipment ทั้งหมด ยกเว้นตัวที่ดีที่สุด (ขายทีเดียวทั้งหมด, ข้าม item ที่ equip อยู่)
local function SellEquipmentsExceptBest()
    local best = GetBestEquipments()
    local soldCount = 0
    local basket = {}
    
    -- หา GUID ของ item ที่ equip อยู่
    local equippedGUIDs = {}
    pcall(function()
        local equipped = PlayerController.Replica.Data.Equipped
        if equipped then
            for slot, guid in pairs(equipped) do
                if guid then
                    equippedGUIDs[guid] = true
                end
            end
        end
    end)
    
    print("[Sell] === Equipment Sale ===")
    print("[Sell] Best Weapon GUID:", best.Weapon or "none")
    print("[Sell] Best Armor GUID:", best.Armor or "none")
    print("[Sell] Best Pickaxe GUID:", best.Pickaxe or "none")
    
    for _, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        if v["GUID"] then
            -- ข้ามถ้าเป็น item ที่ equip อยู่
            local isEquipped = equippedGUIDs[v.GUID]
            local isBest = (v.GUID == best.Weapon) or (v.GUID == best.Armor) or (v.GUID == best.Pickaxe)
            local isOriginal = table.find(InsertEquipments, v["GUID"])
            
            if isEquipped then
                print("[Sell] SKIP (equipped):", v.Id or v.GUID)
            elseif isBest then
                print("[Sell] KEEP (best):", v.Id or v.GUID)
            elseif isOriginal then
                print("[Sell] KEEP (original):", v.Id or v.GUID)
            else
                -- เพิ่มเข้า basket เพื่อขายทีเดียว
                basket[v["GUID"]] = true
                soldCount = soldCount + 1
                print("[Sell] SELL:", v.Id or v.GUID)
            end
        end
    end
    
    -- ขายทั้งหมดในครั้งเดียว
    if soldCount > 0 then
        pcall(function()
            RunCommand:InvokeServer("SellConfirm", {
                Basket = basket
            })
        end)
        print("[Sell] ✓ Sold", soldCount, "equipments (kept best + equipped)")
    else
        print("[Sell] No equipment to sell")
    end
end

-- ===== RUNE TRAIT SYSTEM =====
-- ค่า Max สูงสุดของแต่ละ Trait (ถ้าได้ค่านี้ = Perfect)
local TRAIT_MAX_VALUES = {
    -- WEAPON TRAITS (เป็น decimal 0-1)
    ["AttackSpeed"] = 0.18,
    ["Lethality"] = 0.15,
    ["CriticalChance"] = 0.15,
    ["CriticalDamage"] = 0.15,
    ["Fracture"] = 0.20,
    
    -- ARMOR TRAITS
    ["Endurance"] = 0.10,
    ["Surge"] = 0.11,
    ["Vitality"] = 0.10,
    ["Swiftness"] = 0.10,
    ["Phase"] = 0.11,
    ["Stride"] = 0.15,
    ["Thorn"] = 0.09,
    
    -- SHIELD RUNE
    ["Shield"] = 1.0,           -- ShieldPercentage max
    ["ShieldPercentage"] = 1.0,
    ["ShieldChance"] = 0.5,     -- 50% chance
    ["MoveSpeed"] = 1.0,
    
    -- PICKAXE RUNE
    ["MinePower"] = 5,
    ["ExtraMineDrop"] = 1.0,    -- MineDropChance
    ["MineDropChance"] = 1.0,
    ["MineDropCount"] = 3,
}

-- คำนวณ "คะแนน" ของ Rune จาก Traits ทั้งหมด
local function CalculateRuneScore(rune)
    if not rune or not rune.Traits then return 0 end
    
    local totalScore = 0
    local traitCount = 0
    
    for _, trait in pairs(rune.Traits) do
        if type(trait) == "table" then
            local traitId = trait.Id or ""
            local tier = trait.Tier or 1
            
            -- หาค่า stat หลักของ trait นี้
            local bestStatValue = 0
            local bestStatMax = 1
            
            for statName, statValue in pairs(trait) do
                if statName ~= "Id" and statName ~= "Tier" and type(statValue) == "number" then
                    local maxValue = TRAIT_MAX_VALUES[statName] or TRAIT_MAX_VALUES[traitId] or 1
                    local percentage = statValue / maxValue
                    if percentage > bestStatValue / bestStatMax then
                        bestStatValue = statValue
                        bestStatMax = maxValue
                    end
                end
            end
            
            -- คะแนน = (ค่าที่ได้ / ค่า Max) * 100 * Tier
            local score = (bestStatValue / bestStatMax) * 100 * tier
            totalScore = totalScore + score
            traitCount = traitCount + 1
        end
    end
    
    return totalScore, traitCount
end

-- เช็คว่า Rune มี Trait ที่ Perfect (= Max) หรือไม่
local function HasPerfectTrait(rune)
    if not rune or not rune.Traits then return false end
    
    for _, trait in pairs(rune.Traits) do
        if type(trait) == "table" then
            for statName, statValue in pairs(trait) do
                if statName ~= "Id" and statName ~= "Tier" and type(statValue) == "number" then
                    local maxValue = TRAIT_MAX_VALUES[statName]
                    if maxValue and statValue >= maxValue * 0.95 then  -- 95% ขึ้นไป = Perfect
                        return true, statName, statValue, maxValue
                    end
                end
            end
        end
    end
    
    return false
end

-- หา Rune ที่ดีที่สุดของแต่ละประเภท
local function GetBestRunesByType()
    local bestRunes = {}  -- {RuneType = {GUID, Score}}
    
    for _, item in pairs(PlayerController.Replica.Data.Inventory["Misc"] or {}) do
        if item.GUID and item.Id and item.Traits then
            -- เช็คว่าเป็น Rune (มี _T ในชื่อ เช่น Pickaxe_T1, Shield_T1)
            if string.find(item.Id, "_T") then
                local runeType = string.match(item.Id, "^(.-)_T") or item.Id
                local score, traitCount = CalculateRuneScore(item)
                local isPerfect = HasPerfectTrait(item)
                
                -- ถ้า Perfect ให้ bonus score มหาศาล
                if isPerfect then
                    score = score + 10000
                end
                
                if not bestRunes[runeType] or score > bestRunes[runeType].Score then
                    bestRunes[runeType] = {
                        GUID = item.GUID,
                        Score = score,
                        Id = item.Id,
                        IsPerfect = isPerfect
                    }
                end
            end
        end
    end
    
    return bestRunes
end

-- ขาย Rune ที่ต่ำกว่าตัวที่ดีที่สุดของแต่ละประเภท (ขายทีเดียวทั้งหมด)
local function SellRunesExceptBest()
    print("[Sell] === เริ่มขาย Rune (เก็บตัวดีที่สุดของแต่ละประเภท) ===")
    
    -- หา Rune ที่ดีที่สุดของแต่ละประเภท
    local bestRunes = GetBestRunesByType()
    
    -- แสดง Rune ที่จะเก็บ
    print("[Sell] Rune ที่จะเก็บ:")
    for runeType, data in pairs(bestRunes) do
        local perfectText = data.IsPerfect and " ⭐PERFECT!" or ""
        print("  - " .. runeType .. ": " .. data.Id .. " (Score: " .. math.floor(data.Score) .. ")" .. perfectText)
    end
    
    -- รวบรวม Rune ที่จะขายเข้า basket
    local soldCount = 0
    local keptCount = 0
    local basket = {}
    
    for _, item in pairs(PlayerController.Replica.Data.Inventory["Misc"] or {}) do
        if item.GUID and item.Id and item.Traits then
            if string.find(item.Id, "_T") then
                local runeType = string.match(item.Id, "^(.-)_T") or item.Id
                local bestData = bestRunes[runeType]
                
                -- ถ้าไม่ใช่ตัวที่ดีที่สุด -> เพิ่มเข้า basket
                if bestData and item.GUID ~= bestData.GUID then
                    basket[item.GUID] = true
                    soldCount = soldCount + 1
                    print("[Sell] SELL Rune: " .. item.Id .. " (Score: " .. math.floor(CalculateRuneScore(item)) .. ")")
                else
                    keptCount = keptCount + 1
                    print("[Sell] KEEP Rune: " .. item.Id .. " (best)")
                end
            end
        end
    end
    
    -- ขายทั้งหมดในครั้งเดียว
    if soldCount > 0 then
        pcall(function()
            RunCommand:InvokeServer("SellConfirm", {
                Basket = basket
            })
        end)
    end
    
    print("[Sell] === สรุป Rune: ขาย " .. soldCount .. " ชิ้น, เก็บ " .. keptCount .. " ชิ้น ===")
end

-- ขาย Equipment ทั้งหมด (ยกเว้นตอนเริ่ม) - แบบเดิม
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
    local SoldTypes = 0
    
    print("[Sell] === เริ่มขาย Ore ===")
    
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData then
                if not ShouldProtect(OreData["Rarity"]) then
                    Basket[OreName] = Amount
                    SoldCount = SoldCount + Amount
                    SoldTypes = SoldTypes + 1
                    print("[Sell] SELL Ore:", OreName, "x", Amount)
                else
                    print("[Sell] KEEP Ore (protected):", OreName, "x", Amount)
                end
            end
        end
    end
    
    if SoldCount > 0 then
        pcall(function()
            RunCommand:InvokeServer("SellConfirm", {
                Basket = Basket
            })
        end)
        print("[Sell] ✓ Sold", SoldCount, "ores (" .. SoldTypes .. " types)")
    else
        print("[Sell] No ore to sell")
    end
end

-- ===== TALK TO NPC FOR SELLING (ใช้ Tween ไม่ใช่ teleport ตรง) =====
local function TalkToMarbles()
    pcall(function()
        local marbles = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Marbles")
        if not marbles then 
            print("[Sell] ไม่เจอ Marbles!")
            return 
        end
        
        local marblesPos
        if marbles:IsA("BasePart") then
            marblesPos = marbles.Position
        elseif marbles.PrimaryPart then
            marblesPos = marbles.PrimaryPart.Position
        elseif marbles:FindFirstChild("HumanoidRootPart") then
            marblesPos = marbles.HumanoidRootPart.Position
        elseif marbles:FindFirstChild("Torso") then
            marblesPos = marbles.Torso.Position
        else
            local part = marbles:FindFirstChildWhichIsA("BasePart")
            if part then 
                marblesPos = part.Position 
            else
                marblesPos = marbles:GetPivot().Position
            end
        end
        
        if marblesPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            -- ใช้ Tween แทน teleport ตรง
            local targetPos = marblesPos + Vector3.new(0, 0, 3)
            TweenToPositionAndWait(targetPos, 80)
            task.wait(0.3)
        end
        
        DialogueRemote:InvokeServer(marbles)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.3)
        print("[Sell] Talked to Marbles")
    end)
end

local function TalkToGreedyCey()
    pcall(function()
        local greedyCey = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Greedy Cey")
        if not greedyCey then 
            print("[Sell] ไม่เจอ Greedy Cey!")
            return 
        end
        
        local greedyPos
        if greedyCey:IsA("BasePart") then
            greedyPos = greedyCey.Position
        elseif greedyCey.PrimaryPart then
            greedyPos = greedyCey.PrimaryPart.Position
        elseif greedyCey:FindFirstChild("HumanoidRootPart") then
            greedyPos = greedyCey.HumanoidRootPart.Position
        elseif greedyCey:FindFirstChild("Torso") then
            greedyPos = greedyCey.Torso.Position
        else
            local part = greedyCey:FindFirstChildWhichIsA("BasePart")
            if part then 
                greedyPos = part.Position 
            else
                greedyPos = greedyCey:GetPivot().Position
            end
        end
        
        if greedyPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            -- ใช้ Tween แทน teleport ตรง
            local targetPos = greedyPos + Vector3.new(0, 0, 3)
            TweenToPositionAndWait(targetPos, 80)
            task.wait(0.3)
        end
        
        DialogueRemote:InvokeServer(greedyCey)
        task.wait(0.2)
        DialogueEvent:FireServer("Opened")
        task.wait(0.3)
        print("[Sell] Talked to Greedy Cey")
    end)
end

-- ===== SMART SELL (เมื่อกระเป๋าเต็ม) =====
local function SmartSell()
    print("[SmartSell] เริ่มขายอัจฉริยะ...")
    
    -- 1. คุยกับ NPC Marbles (แบบ TF_System)
    TalkToMarbles()
    task.wait(0.5)
    
    -- 2. ขาย Rune ยกเว้นตัวที่ดีที่สุด
    SellRunesExceptBest()
    task.wait(0.5)
    
    -- 3. ขาย Equipment ยกเว้นตัวที่ดีที่สุด
    SellEquipmentsExceptBest()
    task.wait(0.5)
    
    -- 4. คุยกับ NPC Greedy Cey (แบบ TF_System)
    TalkToGreedyCey()
    task.wait(0.5)
    
    -- 5. ขาย Ore
    SellOres()
    task.wait(0.5)
    
    print("[SmartSell] เสร็จสิ้น!")
end

-- ===== QUEST FUNCTIONS =====

-- ดึงชื่อ NPC จาก Quest Template หรือจาก Quest ID
local function GetQuestNPC(questId, questTemplate)
    -- 1. ถ้า Template มี Npc field ให้ใช้เลย
    if questTemplate and questTemplate.Npc then
        return questTemplate.Npc
    end
    
    -- 2. ถ้าไม่มี ให้ดึงจากชื่อ Quest (เช่น "Captain Rowan 4" -> "Captain Rowan")
    if questId then
        -- ตัดตัวเลขท้ายออก
        local npcName = questId:match("^(.-)%s*%d*$")
        if npcName and npcName ~= "" then
            return npcName
        end
        return questId
    end
    
    return nil
end

-- ตรวจสอบว่า Quest เสร็จทุก objectives หรือยัง (แต่ยังไม่ได้ turn in)
local function IsQuestAllObjectivesComplete(questInfo)
    if not questInfo then return false end
    
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return false end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return false end
    
    local progressTable = freshProgress.Progress
    if not progressTable then return false end
    
    -- อ่านจาก progressTable โดยตรง
    for _, objData in ipairs(progressTable) do
        if objData and type(objData) == "table" then
            local currentProgress = objData.currentProgress or 0
            local requiredAmount = objData.requiredAmount or 1
            
            if currentProgress < requiredAmount then
                return false
            end
        end
    end
    
    return true
end

local function GetActiveQuestInfo()
    -- ดึง quest data สดๆ จาก PlayerController ทุกครั้ง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data then 
        print("[Debug] GetActiveQuestInfo: No replica or data")
        return nil 
    end
    local quests = replica.Data.Quests
    if not quests then 
        print("[Debug] GetActiveQuestInfo: No quests table")
        return nil 
    end
    
    -- Debug: แสดง quests ทั้งหมดที่มี
    local questCount = 0
    for questId, questProgress in pairs(quests) do
        questCount = questCount + 1
        local questTemplate = QuestData[questId]
        
        -- สร้าง template จาก Progress data เสมอ (เพราะมีข้อมูลครบกว่า)
        local objectives = {}
        if questProgress and questProgress.Progress then
            for i, objData in ipairs(questProgress.Progress) do
                if objData and type(objData) == "table" then
                    table.insert(objectives, {
                        Type = objData.questType or objData.Type or "Unknown",
                        Target = objData.target or objData.Target or "Unknown",
                        Amount = objData.requiredAmount or 1
                    })
                end
            end
        end
        
        -- ใช้ template จาก QuestData ถ้ามี แต่เพิ่ม Objectives จาก Progress
        local finalTemplate = questTemplate or {}
        if #objectives > 0 then
            finalTemplate.Objectives = objectives
        end
        
        -- ลองดึง NPC จากชื่อ Quest ถ้าไม่มี
        if not finalTemplate.Npc then
            local npcName = questId:match("^(.-)%s*%d*$")
            if npcName and npcName ~= "" then
                -- ตัด "Quest" หรือ "Final" ออกถ้ามี
                npcName = npcName:gsub("Quest$", ""):gsub("Final$", "")
                npcName = npcName:match("^%s*(.-)%s*$") -- trim
                finalTemplate.Npc = npcName
            end
        end
        
        return {
            Id = questId,
            Template = finalTemplate,
            Progress = questProgress
        }
    end
    
    if questCount > 0 then
        print("[Debug] GetActiveQuestInfo: มี", questCount, "quests แต่ไม่เจอ template ที่ตรงกัน")
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
    
    -- Progress อยู่ใน freshProgress.Progress[i]
    local progressTable = freshProgress.Progress
    if not progressTable then return {} end
    
    local incomplete = {}
    
    -- อ่านจาก progressTable โดยตรง (ใช้ questType และ target)
    for i, objData in ipairs(progressTable) do
        if objData and type(objData) == "table" then
            local currentProgress = objData.currentProgress or 0
            local requiredAmount = objData.requiredAmount or 1
            local objType = objData.questType or objData.Type or objData.type or "Unknown"
            local objTarget = objData.target or objData.Target or "Unknown"
            
            if currentProgress < requiredAmount then
                table.insert(incomplete, {
                    Index = i,
                    Objective = {
                        Type = objType,
                        Target = objTarget,
                        Amount = requiredAmount
                    },
                    Current = currentProgress,
                    Required = requiredAmount
                })
            end
        end
    end
    
    return incomplete
end

-- เช็คว่า Quest มี Kill objectives หรือไม่
local function QuestHasKillObjectives(questInfo)
    if not questInfo then return false end
    
    -- ดูจาก Progress โดยตรง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return false end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress or not freshProgress.Progress then return false end
    
    for _, objData in ipairs(freshProgress.Progress) do
        if objData and type(objData) == "table" then
            local objType = objData.questType or objData.Type or objData.type
            if objType == "Kill" then
                return true
            end
        end
    end
    
    return false
end

-- เช็คว่า Quest มีเฉพาะ Bring objectives เท่านั้น (ไม่มี Kill)
local function QuestHasOnlyBringObjectives(questInfo)
    if not questInfo then return false end
    
    -- ดูจาก Progress โดยตรง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return false end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress or not freshProgress.Progress then return false end
    
    local hasBring = false
    for _, objData in ipairs(freshProgress.Progress) do
        if objData and type(objData) == "table" then
            local objType = objData.questType or objData.Type or objData.type
            if objType == "Kill" then
                return false
            end
            if objType == "Bring" then
                hasBring = true
            end
        end
    end
    
    return hasBring
end

local function GetCurrentObjective(questInfo)
    if not questInfo then return nil end
    
    -- ดึง progress สดๆ ใหม่ทุกครั้ง
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return nil end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return nil end
    
    -- Progress อยู่ใน freshProgress.Progress[i]
    local progressTable = freshProgress.Progress
    if not progressTable then return nil end
    
    -- อ่านจาก progressTable โดยตรง (มีข้อมูลครบกว่า)
    for i, objData in ipairs(progressTable) do
        if objData and type(objData) == "table" then
            local currentProgress = objData.currentProgress or 0
            local requiredAmount = objData.requiredAmount or 1
            -- ใช้ questType (จาก decompiled code) หรือ Type
            local objType = objData.questType or objData.Type or objData.type or "Unknown"
            -- ใช้ target (lowercase จาก decompiled code)
            local objTarget = objData.target or objData.Target or "Unknown"
            
            if currentProgress < requiredAmount then
                print("[Quest] Objective", i, ":", objType, objTarget, currentProgress, "/", requiredAmount)
                return {
                    Index = i,
                    Objective = {
                        Type = objType,
                        Target = objTarget,
                        Amount = requiredAmount
                    },
                    Current = currentProgress,
                    Required = requiredAmount
                }
            end
        end
    end
    
    return nil
end

-- ===== MAIN FARM LOOP (ปรับระยะอัตโนมัติตามการโดนตี) =====
local SafeHeightOffset = 0  -- offset เพิ่มเติมจาก base
local MAX_SAFE_HEIGHT = 5   -- ไม่เพิ่ม offset เกิน 5 studs
local RunService = game:GetService("RunService")
local FarmTween = nil       -- Tween สำหรับเคลื่อนที่หา mob

local function FarmMob(targetName)
    if not IsAlive() then return "alive_fail" end
    
    local Char = Plr.Character
    local Mob = getNearestMob(Char, targetName)
    
    if not Mob then
        if tick() - LastMobSearchLog > 5 then
            LastMobSearchLog = tick()
            print("[Farm] รอ mob spawn:", targetName or "any")
        end
        task.wait(1)
        return "not_found"
    end
    
    MobNotFoundStartTime = nil
    
    local MyHumanoid = Char:FindFirstChildOfClass("Humanoid")
    if not MyHumanoid then return end
    
    -- ===== ปิด AutoRotate เพื่อให้นอนค้าง =====
    MyHumanoid.AutoRotate = false
    
    local LastHP = MyHumanoid.Health
    local HitCount = 0
    local CheckTime = tick()
    local LastTweenTime = 0
    local IsNearMob = false  -- อยู่ใกล้ mob แล้วหรือยัง
    
    print("[Farm] Attacking:", Mob.Name)
    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
    local LastBagCheckLog = 0
    
    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 and LoopEnabled do
        -- ===== เช็คกระเป๋าเต็ม =====
        local CurrentBag = SafeCalculateTotal("Stash")
        local MaxBag = SafeGetBagCapacity()
        
        -- Debug log ทุก 3 วินาที
        if tick() - LastBagCheckLog > 3 then
            LastBagCheckLog = tick()
            print("[Bag] " .. CurrentBag .. "/" .. MaxBag)
        end
        
        if CurrentBag >= MaxBag then
            print("[Farm] กระเป๋าเต็ม! (" .. CurrentBag .. "/" .. MaxBag .. ") หยุดฟาร์มไปขายก่อน")
            if FarmTween then FarmTween:Cancel() end
            return "bag_full"
        end
        
        if not IsAlive() then 
            if FarmTween then FarmTween:Cancel() end
            return 
        end
        
        Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        local MyHumanoid = Char:FindFirstChildOfClass("Humanoid")
        if not MyHumanoid then return end
        
        if not Mob or not Mob.Parent then break end
        
        MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
        if not MobHRP then break end
        
        MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
        if not MobHumanoid or MobHumanoid.Health <= 0 then break end
        
        local MobPosition = MobHRP.Position
        
        -- คำนวณความสูง mob จาก Model (รวมทั้งตัว)
        local MobSize = Mob:GetExtentsSize()
        local MobHeight = MobSize.Y

        local BaseHeight = 5  -- อยู่เหนือ mob 2.7 studs (ไม่โดนตี)
        local MyPosition = Char.HumanoidRootPart.Position
        local HorizontalDist = ((Vector3.new(MyPosition.X, 0, MyPosition.Z) - Vector3.new(MobPosition.X, 0, MobPosition.Z))).Magnitude
        
        -- ตรวจสอบว่าโดนตีหรือไม่
        local CurrentHP = MyHumanoid.Health
        if CurrentHP < LastHP then
            if HorizontalDist < 25 and SafeHeightOffset < MAX_SAFE_HEIGHT then
                HitCount = HitCount + 1
                SafeHeightOffset = SafeHeightOffset + 0.5
                print("[Farm] โดนตี! ระยะ:", string.format("%.1f", BaseHeight), "+", string.format("%.1f", SafeHeightOffset))
            end
        end
        LastHP = CurrentHP
        
        -- ถ้าไม่โดนตี 5 วินาที ลดลง
        if tick() - CheckTime > 5 then
            if HitCount == 0 and SafeHeightOffset > 0 then
                SafeHeightOffset = math.max(0, SafeHeightOffset - 0.2)
                print("[Farm] ไม่โดนตี ลดระยะ:", string.format("%.1f", BaseHeight), "+", string.format("%.1f", SafeHeightOffset))
            end
            HitCount = 0
            CheckTime = tick()
        end
        
        -- ตำแหน่งปลอดภัย: MobHeight + 2 + offset (อยู่เหนือ mob)
        local SafePosition = MobPosition + Vector3.new(0, BaseHeight + SafeHeightOffset, 0)
        local DistToSafe = (MyPosition - SafePosition).Magnitude
        
        -- ===== ปิด AutoRotate ทุก frame เพื่อให้นอนค้าง =====
        if MyHumanoid then
            MyHumanoid.AutoRotate = false
        end
        
        -- ===== ท่านอน (หันหน้าลง) =====
        local LyingCFrame = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
        
        -- ===== ระบบเคลื่อนที่แบบ Anti-Cheat Friendly =====
        if DistToSafe > 50 then
            -- อยู่ไกลมาก: ใช้ Tween เดินทางไป (ดูเป็นธรรมชาติ)
            IsNearMob = false
            if tick() - LastTweenTime > 0.5 then
                LastTweenTime = tick()
                if FarmTween then FarmTween:Cancel() end
                local tweenTime = DistToSafe / 80  -- speed 80
                FarmTween = TweenService:Create(
                    Char.HumanoidRootPart, 
                    TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), 
                    {CFrame = LyingCFrame}
                )
                FarmTween:Play()
            end
            -- บังคับท่านอนระหว่าง Tween
            Char.HumanoidRootPart.CFrame = CFrame.new(Char.HumanoidRootPart.Position) * CFrame.Angles(-math.rad(90), 0, 0)
        elseif DistToSafe > 15 then
            -- อยู่ใกล้พอสมควร: ใช้ Tween สั้นๆ
            IsNearMob = false
            if tick() - LastTweenTime > 0.3 then
                LastTweenTime = tick()
                if FarmTween then FarmTween:Cancel() end
                local tweenTime = DistToSafe / 80  -- speed 80
                FarmTween = TweenService:Create(
                    Char.HumanoidRootPart, 
                    TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), 
                    {CFrame = LyingCFrame}
                )
                FarmTween:Play()
            end
            -- บังคับท่านอนระหว่าง Tween
            Char.HumanoidRootPart.CFrame = CFrame.new(Char.HumanoidRootPart.Position) * CFrame.Angles(-math.rad(90), 0, 0)
        else
            -- อยู่ใกล้แล้ว: ใช้ CFrame ตรงๆ
            IsNearMob = true
            if FarmTween then FarmTween:Cancel() FarmTween = nil end
            
            -- ล็อคท่านอนทุก frame
            if Char:FindFirstChild("HumanoidRootPart") then
                Char.HumanoidRootPart.CFrame = LyingCFrame
            end
        end
        
        -- ===== โจมตีเมื่ออยู่ในระยะ (เร็วมาก) =====
        if IsNearMob or DistToSafe < 20 then
            for i = 1, 10 do
                coroutine.wrap(function()
                    pcall(function() ToolActivated:InvokeServer("Weapon") end)
                end)()
            end
        end
        
        -- Loop เร็วมาก
        task.wait(0.05)
    end
    
    -- ===== เปิด AutoRotate กลับเมื่อจบ =====
    pcall(function()
        if Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid") then
            Plr.Character:FindFirstChildOfClass("Humanoid").AutoRotate = true
        end
    end)
    
    if FarmTween then FarmTween:Cancel() FarmTween = nil end
    return true
end

local function FarmRock(targetName)
    if not IsAlive() then return end
    
    local Char = Plr.Character
    local Rock = getNearest(Char, targetName)
    local LastAttack = 0
    local LastTween = nil
    
    if Rock then
        local rockHealth = Rock:GetAttribute("Health") or 0
        local minePower = GetEquippedPickaxeMinePower()
        local estimatedTime = EstimateMiningTime(rockHealth, minePower)
        
        print("[Farm] Found Rock:", Rock.Name, "| Health:", rockHealth, "| MinePower:", minePower, "| Est.Time:", string.format("%.1f", estimatedTime), "s")
        
        -- ถ้าประมาณเวลาขุดนานเกินไป -> ข้าม Rock นี้
        if estimatedTime > ROCK_MINING_TIMEOUT then
            print("[Farm] ⚠️ Rock นี้ใช้เวลาขุดนานเกินไป! (" .. string.format("%.1f", estimatedTime) .. "s > " .. ROCK_MINING_TIMEOUT .. "s)")
            print("[Farm] ⚠️ MinePower (" .. minePower .. ") ต่ำเกินไปสำหรับ Rock Health (" .. rockHealth .. ")")
            print("[Farm] -> ข้าม Rock นี้ไปหาอันอื่น")
            return "skip_too_hard"
        end
        
        local Position = Rock:GetAttribute("OriginalCFrame").Position
        local miningStartTime = tick()
        local lastHealthCheck = rockHealth
        local noProgressCount = 0
        
        while Rock:GetAttribute("Health") > 0 and SafeCalculateTotal("Stash") < SafeGetBagCapacity() and LoopEnabled do
            task.wait(0.1)
            
            if not IsAlive() then
                if LastTween then LastTween:Cancel() end
                return
            end
            
            -- เช็ค timeout ขณะขุด
            local miningDuration = tick() - miningStartTime
            if miningDuration > ROCK_MINING_TIMEOUT then
                print("[Farm] ⚠️ Mining timeout! ขุดมา", string.format("%.1f", miningDuration), "s แล้ว -> ข้าม")
                if LastTween then LastTween:Cancel() end
                return "timeout"
            end
            
            -- เช็คว่า Health ลดลงหรือไม่ (ทุกๆ 3 วินาที)
            if miningDuration > 3 then
                local currentHealth = Rock:GetAttribute("Health") or 0
                if currentHealth >= lastHealthCheck then
                    noProgressCount = noProgressCount + 1
                    if noProgressCount >= 3 then
                        print("[Farm] ⚠️ ไม่มี progress! Health ไม่ลด -> ข้าม Rock นี้")
                        if LastTween then LastTween:Cancel() end
                        return "no_progress"
                    end
                else
                    noProgressCount = 0
                    lastHealthCheck = currentHealth
                end
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
        
        local totalTime = tick() - miningStartTime
        print("[Farm] ✓ Rock destroyed in", string.format("%.1f", totalTime), "s")
        return true
    end
    return false
end

local function DoForgeAndSell()
    if not IsAlive() then return end
    
    local Char = Plr.Character
    local Position = workspace.Proximity.Forge.Position
    
    -- ใช้ Tween ไปหา Forge
    TweenToPositionAndWait(Position, 80)
    task.wait(0.3)
    
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
    
    print("[Sell] Forged", ForgeCount, "items, now selling...")
    
    -- ขายเสมอ (ไม่ว่าจะ Forge ได้หรือไม่)
    TalkToMarbles()
    task.wait(0.5)
    SmartSell()
    task.wait(0.5)
    TalkToGreedyCey()
    task.wait(0.5)
    SellOres()
    task.wait(0.3)
    
    print("[Sell] Done selling!")
end

-- ===== QUEST OBJECTIVE PROCESSORS =====
local function ProcessTalkObjective(objective)
    local npcName = objective.Objective.Target
    if npcName then
        print("[Quest] Talk to:", npcName)
        -- เช็คว่า NPC อยู่โลกเดียวกันหรือไม่
        EnsureCorrectIsland(nil, npcName, nil)
        TalkToNPC(npcName)
        task.wait(1)
    end
end

-- ===== MULTI-OBJECTIVE PROCESSING =====
-- ทำ Quest ที่มีหลาย objectives พร้อมกัน (Kill + Mine + Forge)
local function ProcessMultiObjectives(questInfo)
    if not questInfo then return end
    
    local originalQuestId = questInfo.Id
    print("[Multi] ========================================")
    print("[Multi] เริ่มทำ Quest หลาย objectives:", originalQuestId)
    
    -- รวบรวม objectives ที่ยังไม่เสร็จทั้งหมด
    local function getIncomplete()
        local qi = GetActiveQuestInfo()
        if not qi or qi.Id ~= originalQuestId then return {} end
        return GetAllIncompleteObjectives(qi)
    end
    
    local lastLogTime = 0
    
    while LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        -- เช็คว่า Quest เปลี่ยนหรือไม่
        local currentQuest = GetActiveQuestInfo()
        if not currentQuest or currentQuest.Id ~= originalQuestId then
            print("[Multi] Quest เปลี่ยน/เสร็จแล้ว!")
            break
        end
        
        -- รวบรวม objectives ที่ยังไม่เสร็จ
        local incompleteObjs = getIncomplete()
        if #incompleteObjs == 0 then
            print("[Multi] ✓ ทุก objectives เสร็จแล้ว!")
            break
        end
        
        -- แยก objectives ตาม type
        local killObjs = {}
        local mineObjs = {}
        local forgeObjs = {}
        local bringObjs = {}
        local otherObjs = {}
        
        for _, obj in ipairs(incompleteObjs) do
            local objType = obj.Objective.Type
            if objType == "Kill" then
                table.insert(killObjs, obj)
            elseif objType == "Mine" then
                table.insert(mineObjs, obj)
            elseif objType == "Forge" then
                table.insert(forgeObjs, obj)
            elseif objType == "Bring" then
                table.insert(bringObjs, obj)
            else
                table.insert(otherObjs, obj)
            end
        end
        
        -- Log progress ทุกๆ 5 วินาที
        if tick() - lastLogTime > 5 then
            lastLogTime = tick()
            print("[Multi] === Progress ===")
            print("[Multi] Kill:", #killObjs, "| Mine:", #mineObjs, "| Forge:", #forgeObjs, "| Bring:", #bringObjs, "| Other:", #otherObjs)
        end
        
        -- เช็คกระเป๋าเต็ม
        if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
            -- ถ้ามี Forge objective -> forge ก่อนขาย
            if #forgeObjs > 0 then
                local recipe = GetRecipe()
                if recipe then
                    print("[Multi] กระเป๋าเต็ม + มี Forge objective -> Forge ก่อน!")
                    local forgePos = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
                    if forgePos then
                        TweenToPositionAndWait(forgePos.Position, 80)
                        task.wait(0.3)
                    end
                    Forge(recipe)
                    task.wait(0.5)
                    continue
                end
            end
            -- ไม่มี Forge หรือ forge ไม่ได้ -> ขาย
            DoForgeAndSell()
            continue
        end
        
        -- ===== ลำดับการทำ =====
        -- 1. ถ้ามี Kill objectives -> ฟาร์ม mob (จะได้ item สำหรับ Bring ด้วย)
        if #killObjs > 0 then
            -- หา mob targets ทั้งหมด
            local mobTargets = {}
            for _, ko in ipairs(killObjs) do
                if ko.Objective.Target then
                    table.insert(mobTargets, ko.Objective.Target)
                end
            end
            
            if #mobTargets > 0 then
                -- หา mob ที่ใกล้ที่สุดจาก targets ทั้งหมด
                local Char = Plr.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    local closestMob = nil
                    local closestDist = math.huge
                    
                    for _, targetName in ipairs(mobTargets) do
                        local mob = getNearestMob(Char, targetName)
                        if mob then
                            local hrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                            if hrp then
                                local dist = (Char.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestMob = mob
                                end
                            end
                        end
                    end
                    
                    if closestMob then
                        FarmMob(closestMob.Name)
                    end
                end
            end
            task.wait(0.1)
            continue
        end
        
        -- 2. ถ้ามี Mine objectives -> ฟาร์ม rock
        if #mineObjs > 0 then
            -- หา ore targets ทั้งหมด
            local oreTargets = {}
            for _, mo in ipairs(mineObjs) do
                if mo.Objective.Target then
                    table.insert(oreTargets, mo.Objective.Target)
                end
            end
            
            if #oreTargets > 0 then
                -- ใช้ ore ตัวแรก
                local targetOre = oreTargets[1]
                EnsureCorrectIsland(nil, nil, targetOre)
                FarmRock(targetOre)
            else
                FarmRock(nil)
            end
            task.wait(0.1)
            continue
        end
        
        -- 3. ถ้ามี Forge objectives -> forge (แต่ต้องมี ore ก่อน!)
        if #forgeObjs > 0 then
            local recipe = GetRecipe()
            if recipe then
                -- มี ore พอ -> ไป Forge
                print("[Multi] มี ore พอ -> Forging for quest...")
                local forgePos = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
                if forgePos then
                    TweenToPositionAndWait(forgePos.Position, 80)
                    task.wait(0.3)
                end
                Forge(recipe)
                task.wait(0.5)
            else
                -- ไม่มี ore พอ -> ต้องฟาร์ม rock ก่อน!
                if tick() - lastLogTime > 5 then
                    lastLogTime = tick()
                    print("[Multi] ไม่มี ore พอ forge -> ต้องฟาร์ม rock ก่อน!")
                end
                
                -- เช็คกระเป๋าเต็มก่อนฟาร์ม
                if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                    print("[Multi] กระเป๋าเต็มแต่ไม่มี ore ที่ forge ได้ -> ขายก่อน")
                    SmartSell()
                else
                    -- ฟาร์ม rock อะไรก็ได้
                    FarmRock(nil)
                end
            end
            task.wait(0.1)
            continue
        end
        
        -- 4. ถ้ามี Bring objectives -> ไปส่ง NPC
        if #bringObjs > 0 then
            local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
            if npcName then
                print("[Multi] มี Bring objective -> ไปคุย NPC:", npcName)
                TalkToNPC(npcName)
                task.wait(1)
            end
            continue
        end
        
        -- 5. ถ้ามี Other objectives -> process ทีละอัน
        if #otherObjs > 0 then
            local obj = otherObjs[1]
            ProcessObjective(obj, questInfo)
            continue
        end
        
        task.wait(0.1)
    end
    
    -- ทุก objectives เสร็จแล้ว -> ไปคุย NPC เพื่อ turn in
    local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
    if npcName then
        print("[Multi] ✓ ไปคุย NPC:", npcName, "เพื่อส่ง Quest...")
        TalkToNPC(npcName)
        task.wait(1)
    end
    
    print("[Multi] ========================================")
end

-- ฟาร์ม Kill objectives ทั้งหมดพร้อมกัน (สำหรับ Quest ที่มีหลาย Kill objectives)
local function ProcessAllKillObjectives(questInfo)
    if not questInfo then return end
    
    -- เก็บ Quest ID เดิมไว้ตรวจสอบว่า Quest เปลี่ยนหรือไม่
    local originalQuestId = questInfo.Id
    print("[Quest] เริ่มทำ Quest ID:", originalQuestId)
    
    -- เก็บ NPC เจ้าของ Quest (ใช้ฟังก์ชัน GetQuestNPC ที่รองรับทั้ง Template.Npc และดึงจากชื่อ Quest)
    CurrentQuestNPC = GetQuestNPC(questInfo.Id, questInfo.Template)
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
    
    -- เช็คว่า mob อยู่โลกเดียวกันหรือไม่ (ใช้ target ตัวแรก)
    if allTargets[1] then
        print("[Quest] เช็คโลกสำหรับ mob:", allTargets[1])
        EnsureCorrectIsland(questInfo.Id, CurrentQuestNPC, allTargets[1])
    end
    
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
        if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
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
                -- เจอ mob แล้ว
                local farmResult = FarmMob(closestMob.Name)
                if farmResult == "bag_full" then
                    print("[Quest] กระเป๋าเต็ม! ไปขายก่อน...")
                    SmartSell()
                end
            else
                -- ไม่เจอ mob - รอต่อไป (ไม่ไปหา NPC)
                if tick() - lastProgressLog > 5 then
                    lastProgressLog = tick()
                    print("[Quest] รอ mob spawn...")
                end
                task.wait(1)
            end
        end
        
        -- อัพเดท progress และเช็คว่าครบหรือยัง
        local newQuestInfo = GetActiveQuestInfo()
        if newQuestInfo then
            -- เช็คว่า Quest เปลี่ยนหรือไม่
            if newQuestInfo.Id ~= originalQuestId then
                print("[Quest] ⚠ Quest เปลี่ยนแล้ว! เดิม:", originalQuestId, "ใหม่:", newQuestInfo.Id)
                print("[Quest] ไปทำ Quest ถัดไป...")
                break
            end
            
            local stillIncomplete = GetAllIncompleteObjectives(newQuestInfo)
            local hasKillLeft = false
            
            -- อัพเดท allTargets ใหม่จาก objectives ที่ยังไม่ครบ
            allTargets = {}
            for _, obj in ipairs(stillIncomplete) do
                if obj.Objective.Type == "Kill" then
                    hasKillLeft = true
                    table.insert(allTargets, obj.Objective.Target)
                end
            end
            
            -- แสดง progress ทุก 3 วินาที
            if tick() - lastProgressLog > 3 then
                lastProgressLog = tick()
                print("[Quest] -------- Progress --------")
                for _, obj in ipairs(stillIncomplete) do
                    if obj.Objective.Type == "Kill" then
                        print("[Quest]", obj.Objective.Target, ":", obj.Current, "/", obj.Required)
                    end
                end
                if not hasKillLeft then
                    print("[Quest] All Kill objectives completed!")
                end
                print("[Quest] -----------------------------")
            end
            
            if not hasKillLeft then
                print("[Quest] ✓ All Kill objectives completed!")
                
                -- เช็คว่า Quest ทุก objectives ครบแล้วหรือยัง (รวม Bring ด้วย)
                if IsQuestAllObjectivesComplete(questInfo) then
                    -- ไปคุย NPC เจ้าของ Quest เพื่อ turn in
                    local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
                    if npcName then
                        print("[Quest] ✓ Quest ครบทุก objectives! ไปคุย NPC:", npcName, "เพื่อส่ง Quest...")
                        TalkToNPC(npcName)
                        task.wait(1)
                    end
                else
                    print("[Quest] ยังมี objectives อื่นที่ยังไม่เสร็จ (เช่น Bring)")
                end
                
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
            if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                DoForgeAndSell()
            end
            
            local result = FarmMob(mobName)
            if result == "bag_full" then
                print("[Quest] กระเป๋าเต็ม! ไปขายก่อน...")
                SmartSell()
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
    local oreName = objective.Objective.Target
    if oreName then
        print("[Quest] Mine:", oreName, "(", objective.Current, "/", objective.Required, ")")
        
        -- เช็คว่า Ore อยู่โลกเดียวกันหรือไม่
        EnsureCorrectIsland(nil, nil, oreName)
        
        CurrentFarmMode = "Rock"
        CurrentTarget = oreName
        
        local lastLogTime = 0
        
        while objective.Current < objective.Required and LoopEnabled do
            if not IsAlive() then
                WaitForRespawn()
            end
            
            -- เชคกระเปาเตม
            if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                DoForgeAndSell()
            end
            
            local foundRock = FarmRock(oreName)
            
            if not foundRock then
                -- ไม่เจอ Rock -> รอสักครู่แล้วลองใหม่
                if tick() - lastLogTime > 5 then
                    lastLogTime = tick()
                    print("[Quest] รอ Rock spawn สำหรับ:", oreName)
                end
                task.wait(1)
            end
            
            -- อพเดท progress
            local questInfo = GetActiveQuestInfo()
            if questInfo then
                local newObj = GetCurrentObjective(questInfo)
                if newObj and newObj.Index == objective.Index then
                    objective.Current = newObj.Current
                    if tick() - lastLogTime > 3 then
                        lastLogTime = tick()
                        print("[Quest] Progress:", oreName, objective.Current, "/", objective.Required)
                    end
                else
                    break
                end
            else
                break
            end
            task.wait(0.1)
        end
        
        if objective.Current >= objective.Required then
            print("[Quest] ✓ Mine objective completed:", oreName)
        end
    end
end

local function ProcessForgeObjective(objective)
    print("[Quest] Forge:", objective.Current, "/", objective.Required)
    
    local lastLogTime = 0
    
    while objective.Current < objective.Required and LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        -- เช็คว่ามี ore พอ forge หรือไม่
        local recipe = GetRecipe()
        
        if recipe then
            -- มี ore พอ -> forge เลย
            print("[Quest] Forging... (", objective.Current + 1, "/", objective.Required, ")")
            
            -- ไปหา Forge
            local forgePos = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
            if forgePos then
                TweenToPositionAndWait(forgePos.Position, 80)
                task.wait(0.3)
            end
            
            Forge(recipe)
            task.wait(0.5)
        else
            -- ไม่มี ore พอ -> ฟาร์ม rock
            if tick() - lastLogTime > 5 then
                lastLogTime = tick()
                print("[Quest] ไม่มี ore พอ forge -> ฟาร์ม rock...")
            end
            
            if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                -- กระเป๋าเต็มแต่ไม่มี recipe -> ขาย ore ที่ protected
                print("[Quest] กระเป๋าเต็มแต่ไม่มี ore ที่ forge ได้ -> ขายก่อน...")
                SmartSell()
            else
                FarmRock(nil)
            end
        end
        
        -- อัพเดท progress
        local questInfo = GetActiveQuestInfo()
        if questInfo then
            local newObj = GetCurrentObjective(questInfo)
            if newObj and newObj.Index == objective.Index then
                objective.Current = newObj.Current
                if tick() - lastLogTime > 3 then
                    lastLogTime = tick()
                    print("[Quest] Forge Progress:", objective.Current, "/", objective.Required)
                end
            else
                break
            end
        else
            break
        end
        task.wait(0.1)
    end
    
    if objective.Current >= objective.Required then
        print("[Quest] ✓ Forge objective completed!")
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

-- ===== INVENTORY CHECK FUNCTIONS =====
-- เช็คจำนวน item ในกระเป๋า (รองรับ Essence, Materials, และ items อื่นๆ)
local function GetItemCount(itemName)
    local count = 0
    pcall(function()
        local playerData = PlayerController.Replica.Data.Inventory
        if not playerData then return end
        
        -- 1. เช็คใน root Inventory (ores, materials)
        if playerData[itemName] then
            count = count + (type(playerData[itemName]) == "number" and playerData[itemName] or 0)
        end
        
        -- 2. เช็คใน Essences (ถ้ามี)
        if playerData["Essences"] then
            for name, amount in pairs(playerData["Essences"]) do
                if string.find(name:lower(), itemName:lower()) or string.find(itemName:lower(), name:lower()) then
                    count = count + (type(amount) == "number" and amount or 0)
                end
            end
        end
        
        -- 3. เช็คใน Materials (ถ้ามี)
        if playerData["Materials"] then
            for name, amount in pairs(playerData["Materials"]) do
                if string.find(name:lower(), itemName:lower()) or string.find(itemName:lower(), name:lower()) then
                    count = count + (type(amount) == "number" and amount or 0)
                end
            end
        end
        
        -- 4. เช็คแบบ partial match ใน root
        if count == 0 then
            for name, amount in pairs(playerData) do
                if type(amount) == "number" then
                    if string.find(name:lower(), itemName:lower()) or string.find(itemName:lower(), name:lower()) then
                        count = count + amount
                    end
                end
            end
        end
    end)
    return count
end

-- ดึง Inventory ทั้งหมด (สำหรับ debug)
local function PrintInventory()
    pcall(function()
        local playerData = PlayerController.Replica.Data.Inventory
        if not playerData then 
            print("[Inventory] No data")
            return 
        end
        
        print("[Inventory] ======= Contents =======")
        for name, value in pairs(playerData) do
            if type(value) == "number" then
                print("[Inventory]", name, ":", value)
            elseif type(value) == "table" then
                print("[Inventory]", name, ": (table)")
                for subName, subValue in pairs(value) do
                    if type(subValue) == "number" then
                        print("[Inventory]   -", subName, ":", subValue)
                    end
                end
            end
        end
        print("[Inventory] ==========================")
    end)
end

local function ProcessCollectObjective(objective)
    local itemName = objective.Objective.Target
    print("[Quest] Collect:", itemName)
    
    -- เช็คว่า Item/Ore อยู่โลกเดียวกันหรือไม่
    EnsureCorrectIsland(nil, nil, itemName)
    
    while objective.Current < objective.Required and LoopEnabled do
        if not IsAlive() then
            WaitForRespawn()
        end
        
        if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
            DoForgeAndSell()
        end
        
        -- ฟาร์มหินที่ตรงกับ item ถ้าเป็น Ore
        local oreIsland = GetIslandForOre(itemName)
        if oreIsland then
            FarmRock(itemName)  -- ฟาร์มหินที่ตรงกับชื่อ
        else
            FarmRock(nil)  -- ฟาร์มหินอะไรก็ได้
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

-- ===== BRING OBJECTIVE (นำ item มาให้ NPC) =====
local function ProcessBringObjective(objective, questInfo)
    local itemName = objective.Objective.Target
    local required = objective.Required
    
    print("[Quest] ======= BRING OBJECTIVE =======")
    print("[Quest] Item:", itemName)
    print("[Quest] Required:", required)
    
    -- เช็คว่า Quest นี้มี Kill objectives ด้วยหรือไม่
    local hasKillInQuest = QuestHasKillObjectives(questInfo)
    local isBringOnly = QuestHasOnlyBringObjectives(questInfo)
    
    print("[Quest] Quest มี Kill objectives:", hasKillInQuest and "ใช่" or "ไม่")
    print("[Quest] Quest มีแค่ Bring:", isBringOnly and "ใช่" or "ไม่")
    
    -- เช็คจำนวนในกระเป๋า
    local currentCount = GetItemCount(itemName)
    print("[Quest] Current in inventory:", currentCount)
    
    -- Debug: แสดง inventory ทั้งหมด (ถ้าหาไม่เจอ)
    if currentCount == 0 then
        PrintInventory()
    end
    
    -- ถ้ามีครบแล้ว -> ไปคุย NPC เพื่อ turn in
    if currentCount >= required then
        print("[Quest] ✓ มี", itemName, "ครบแล้ว! (", currentCount, "/", required, ")")
        print("[Quest] ไปคุย NPC เพื่อส่งมอบ...")
        
        local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
        if npcName then
            TalkToNPC(npcName)
            task.wait(1)
        end
    else
        -- ยังไม่ครบ
        print("[Quest] ✗ ยังไม่ครบ! ต้องการอีก", required - currentCount, "ชิ้น")
        
        -- ถ้า Quest มีแค่ Bring เท่านั้น (ไม่มี Kill) -> ฆ่า mob ทุกตัวได้
        if isBringOnly then
            print("[Quest] Quest มีแค่ Bring -> ฆ่า mob ทุกตัวเพื่อหา item...")
            
            local lastCheck = 0
            while currentCount < required and LoopEnabled do
                if not IsAlive() then
                    WaitForRespawn()
                end
                
                -- เช็คกระเป๋าเต็ม
                if SafeCalculateTotal("Stash") >= SafeGetBagCapacity() then
                    DoForgeAndSell()
                end
                
                -- ฆ่า mob ทุกตัว (ไม่ระบุ target)
                local result = FarmMob(nil)
                if result == "bag_full" then
                    print("[Quest] กระเป๋าเต็ม! ไปขายก่อน...")
                    SmartSell()
                end
                
                -- อัพเดทจำนวน item ทุก 3 วินาที
                if tick() - lastCheck > 3 then
                    lastCheck = tick()
                    currentCount = GetItemCount(itemName)
                    print("[Quest] Item:", itemName, ":", currentCount, "/", required)
                    
                    -- เช็คว่า Quest progress อัพเดทหรือยัง
                    local newQuestInfo = GetActiveQuestInfo()
                    if not newQuestInfo or newQuestInfo.Id ~= questInfo.Id then
                        print("[Quest] Quest เปลี่ยนแล้ว!")
                        break
                    end
                end
                
                task.wait(0.1)
            end
            
            -- ถ้าครบแล้ว ไปคุย NPC
            if currentCount >= required then
                print("[Quest] ✓ Item ครบแล้ว! ไปคุย NPC...")
                local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
                if npcName then
                    TalkToNPC(npcName)
                    task.wait(1)
                end
            end
        else
            -- Quest มี Kill + Bring -> item ควรได้จาก Kill แล้ว ไปส่ง NPC เลย
            print("[Quest] Quest มี Kill + Bring -> ไปคุย NPC เพื่อส่งมอบ (item ได้จาก Kill แล้ว)")
            
            local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
            if npcName then
                TalkToNPC(npcName)
                task.wait(1)
            end
        end
    end
    
    print("[Quest] ================================")
end

local function ProcessUIObjective(objective)
    print("[Quest] UI:", objective.Objective.Target or "Unknown")
    task.wait(1)
end

-- เช็คว่า Quest มีหลาย objective types หรือไม่ (Kill + Mine, Kill + Forge, etc.)
local function QuestHasMultipleObjectiveTypes(questInfo)
    if not questInfo then return false end
    
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return false end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress or not freshProgress.Progress then return false end
    
    local types = {}
    for _, objData in ipairs(freshProgress.Progress) do
        if objData and type(objData) == "table" then
            local objType = objData.questType or objData.Type or objData.type
            if objType and objType ~= "Talk" then  -- ไม่นับ Talk
                types[objType] = true
            end
        end
    end
    
    -- นับจำนวน types
    local count = 0
    for _ in pairs(types) do
        count = count + 1
    end
    
    return count > 1
end

-- เช็คว่า Quest เป็น Mono 7 หรือไม่
local function IsMono7Quest(questInfo)
    if not questInfo then return false end
    return string.find(questInfo.Id:lower(), "mono") and string.find(questInfo.Id, "7")
end

local function ProcessObjective(objectiveInfo, questInfo)
    if not objectiveInfo then return end
    local objType = objectiveInfo.Objective.Type
    
    -- เก็บ NPC เจ้าของ Quest (ใช้ฟังก์ชัน GetQuestNPC ที่รองรับทั้ง Template.Npc และดึงจากชื่อ Quest)
    if questInfo then
        CurrentQuestNPC = GetQuestNPC(questInfo.Id, questInfo.Template)
        -- เช็คว่า Quest อยู่โลกเดียวกันหรือไม่
        EnsureCorrectIsland(questInfo.Id, CurrentQuestNPC, objectiveInfo.Objective.Target)
    end
    
    -- ===== SPECIAL QUEST: Mono 7 =====
    if IsMono7Quest(questInfo) then
        print("[Quest] ★★★ MONO 7 SPECIAL QUEST ★★★")
        HandleMono7Quest()
        return
    end
    
    -- ===== MULTI-OBJECTIVE QUEST (Kill + Mine + Forge) =====
    if QuestHasMultipleObjectiveTypes(questInfo) then
        print("[Quest] Quest มีหลาย objective types -> ใช้ Multi-Objective Processing")
        ProcessMultiObjectives(questInfo)
        return
    end
    
    print("[Quest] Processing objective type:", objType)
    
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
    elseif objType == "Bring" then
        -- Bring = นำ item จากกระเป๋ามาให้ NPC
        ProcessBringObjective(objectiveInfo, questInfo)
    elseif objType == "UI" then
        ProcessUIObjective(objectiveInfo)
    elseif objType == "Extra" then
        -- Extra = objective พิเศษ เช่น reward หรือ bonus
        -- ไปคุย NPC เพื่อรับ/ส่ง
        print("[Quest] Extra objective - ไปคุย NPC เพื่อ turn in...")
        local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
        if npcName then
            print("[Quest] ไปคุย NPC:", npcName)
            TalkToNPC(npcName)
            task.wait(1)
        else
            print("[Quest] ไม่เจอ NPC สำหรับ Extra objective")
            task.wait(2)
        end
    else
        print("[Quest] Unknown type:", objType)
        -- ถ้าไม่รู้จัก type ไปคุย NPC เจ้าของ Quest
        local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
        if npcName then
            print("[Quest] Unknown type - ไปคุย NPC:", npcName)
            TalkToNPC(npcName)
            task.wait(1)
        else
            -- ถ้าไม่รู้จัก type แต่มี Target ลองเช็คว่าเป็น item ในกระเป๋าหรือไม่
            if objectiveInfo.Objective.Target then
                local itemCount = GetItemCount(objectiveInfo.Objective.Target)
                if itemCount > 0 then
                    print("[Quest] Found item in inventory:", objectiveInfo.Objective.Target, "x", itemCount)
                    print("[Quest] Treating as Bring objective...")
                    ProcessBringObjective(objectiveInfo, questInfo)
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
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
                    -- Quest เสร็จทุก objectives แล้ว -> กลับไปคุยกับ NPC เพื่อ turn in
                    print("[System] Quest completed, talking to NPC to turn in...")
                    
                    local npcName = GetQuestNPC(questInfo.Id, questInfo.Template)
                    if npcName then
                        print("[System] Going to NPC:", npcName)
                        TalkToNPC(npcName)
                        task.wait(1)
                    else
                        print("[System] Cannot find NPC for quest:", questInfo.Id)
                        task.wait(2)
                    end
                end
            else
                -- ไม่มี Quest = ลองไปคุย NPC ที่มี Quest Available
                print("[System] No quest, checking for available quests...")
                
                -- หา NPC ที่มี Quest ใหม่ให้
                local foundQuest = false
                for questId, questTemplate in pairs(QuestData) do
                    -- ข้าม Quest ที่ทำไปแล้ว
                    local completedQuests = PlayerController.Replica.Data.CompletedQuests or {}
                    local cooldownQuests = PlayerController.Replica.Data.CooldownQuests or {}
                    
                    if not completedQuests[questId] and not cooldownQuests[questId] then
                        local npcName = GetQuestNPC(questId, questTemplate)
                        if npcName then
                            -- ตรวจสอบว่า NPC นี้อยู่ใน workspace.Proximity หรือไม่
                            local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild(npcName)
                            if npc then
                                print("[System] Found available quest NPC:", npcName)
                                TalkToNPC(npcName)
                                task.wait(1)
                                foundQuest = true
                                break
                            end
                        end
                    end
                end
                
                -- ถ้าไม่เจอ Quest ใหม่ ให้ฟาร์มหิน
                if not foundQuest then
                    if SafeCalculateTotal("Stash") < SafeGetBagCapacity() then
                        FarmRock(nil)
                    else
                        DoForgeAndSell()
                    end
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
