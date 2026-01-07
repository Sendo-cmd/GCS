-- AV_AutoPlay.lua
-- ระบบ Auto Play อัจฉริยะสำหรับ AV (Anime Vanguards)
-- ใช้ระบบ Internal ของเกม + เสริมความสามารถ

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ===== LOAD GAME MODULES =====
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Gameplay = Modules:WaitForChild("Gameplay")

-- Load required modules
local UnitsHUD, ClientUnitHandler, UnitPlacementHandler, PlacementValidationHandler, EnemyPathHandler, PathMathHandler, ClientGameStateHandler, PlayerYenHandler

local function LoadModules()
    pcall(function()
        UnitsHUD = require(StarterPlayer.Modules.Interface.Loader.HUD.Units)
    end)
    pcall(function()
        ClientUnitHandler = require(StarterPlayer.Modules.Gameplay.Units.ClientUnitHandler)
    end)
    pcall(function()
        UnitPlacementHandler = require(StarterPlayer.Modules.Gameplay.Units.UnitPlacementHandler)
    end)
    pcall(function()
        PlacementValidationHandler = require(ReplicatedStorage.Modules.Gameplay.PlacementValidationHandler)
    end)
    pcall(function()
        EnemyPathHandler = require(ReplicatedStorage.Modules.Shared.EnemyPathHandler)
    end)
    pcall(function()
        PathMathHandler = require(ReplicatedStorage.Modules.Shared.PathMathHandler)
    end)
    pcall(function()
        ClientGameStateHandler = require(ReplicatedStorage.Modules.Gameplay.ClientGameStateHandler)
    end)
    pcall(function()
        PlayerYenHandler = require(StarterPlayer.Modules.Gameplay.PlayerYenHandler)
    end)
end

LoadModules()

-- ===== SETTINGS =====
local Settings = {
    -- ระบบหลัก
    ["Enabled"] = true,
    ["Debug"] = true,
    
    -- ===== AUTO START =====
    ["Auto Start"] = true, -- เริ่มเกมอัตโนมัติ (Vote Skip)
    ["Auto Vote Skip"] = true, -- กด Vote Skip อัตโนมัติ
    
    -- ===== AUTO EQUIP CHARM (Hollowseph) =====
    ["Auto Equip Charm"] = true, -- Equip Charm อัตโนมัติ
    ["Charm Priority"] = { -- ลำดับความสำคัญของ Charm ที่จะ Equip (จาก CharmData)
        "HonedNail",           -- Greatly increases Damage (2 slots)
        "NailmastersWill",     -- Greatly lowering SPA (2 slots)
        "SigilOfReach",        -- Greatly extends Range (2 slots)
        "ShamanRelic",         -- Greatly empowers spell Damage (2 slots)
        "FuryOfTheForsaken",   -- Doubles Damage but -10% per other unit (2 slots)
        "VoidGivenClaw",       -- Sibling Summon health +30% (1 slot)
        "SigilOfFocus",        -- 20% Soul cost reduction (1 slot)
        "BarbsOfSpite",        -- Thorns damage nearby enemies (1 slot)
    },
    ["Max Charm Slots"] = 6, -- จำนวน slot สูงสุดที่จะใช้
    
    -- การวาง Units
    ["Auto Place"] = true,
    ["Place Priority"] = {1, 2, 3, 4, 5, 6}, -- ลำดับ Hotbar ที่จะวาง (รวมช่อง 6 ด้วย)
    ["Reserve Slot 6"] = false, -- ปกติวางช่อง 6 ได้ จะ reserve เมื่อเจอ Enemy นอกพื้นที่
    ["Min Yen Reserve"] = 0, -- เงินขั้นต่ำที่ต้องเก็บไว้ (0 = วางได้เลย)
    ["Place Cooldown"] = 0.5, -- รอกี่วินาทีระหว่างการวางแต่ละครั้ง (ลดเหลือ 0.5 วินาที)
    
    -- การอัพเกรด
    ["Auto Upgrade"] = true,
    ["Upgrade Priority"] = "Oldest", -- Oldest, Newest, Cheapest, MostExpensive
    ["Max Upgrade Level"] = 10, -- อัพเกรดสูงสุดถึงเลเวลนี้
    
    -- Auto Skill
    ["Auto Skill"] = true,
    
    -- Enemy นอกพื้นที่
    ["Auto Handle Outside Enemy"] = true,
    ["Outside Enemy Slot"] = 6, -- ช่องที่ใช้สำหรับ Enemy นอกพื้นที่
    ["Sell After Kill"] = true, -- ขาย Unit หลังจากฆ่า Enemy นอกพื้นที่เสร็จ
    
    -- ===== BOSS HUNTER (workspace.Entities) =====
    ["Boss Hunter Enabled"] = true, -- เปิดระบบ Boss Hunter
    ["Boss Hunter Units"] = 4, -- จำนวน Unit ที่จะวางตี Boss (4 ตัว)
    ["Boss Hunter Sell After Kill"] = true, -- ขาย Unit หลังจากฆ่า Boss เสร็จ
    
    -- ระยะห่าง
    ["Unit Spacing"] = 4, -- ระยะห่างระหว่าง Units (ลดลงเพื่อให้หาตำแหน่งได้มากขึ้น)
    ["Unit Range"] = 25, -- ระยะยิงของ Unit (สำหรับคำนวณตำแหน่ง)
    ["Path Calculation"] = "Smart", -- Smart, Random, Fixed
}

-- ===== CHARM DATA (Hollowseph Charms) =====
local CharmData = {
    ["HonedNail"] = {
        ["Name"] = "Honed Nail",
        ["Effect"] = "Sharpened weapon of a kingdom past.\n\nGreatly increases Damage.",
        ["SlotCost"] = 2
    },
    ["NailmastersWill"] = {
        ["Name"] = "Nailmaster's Will",
        ["Effect"] = "A fragmented blade, with a lingering spirit of a powerful Nailmaster within.\n\nIt helps perfect your nail arts, greatly lowering SPA.",
        ["SlotCost"] = 2
    },
    ["SigilOfReach"] = {
        ["Name"] = "Sigil of Reach",
        ["Effect"] = "A rune of the Pale Monarch's craft.\n\nIts imprint greatly extends Range.",
        ["SlotCost"] = 2
    },
    ["FuryOfTheForsaken"] = {
        ["Name"] = "Fury of The Forsaken",
        ["Effect"] = "Forsaken by kin, the Vessel's rage festers in solitude.\n\n The Vessel doubles its Damage, but loses 10% for every other unit placed.",
        ["SlotCost"] = 2
    },
    ["VoidGivenClaw"] = {
        ["Name"] = "Void Given Claw",
        ["Effect"] = "Channel the Void's chaotic energy into weaponry.\n\nSibling Summon health increased by 30%.",
        ["SlotCost"] = 1
    },
    ["SigilOfFocus"] = {
        ["Name"] = "Sigil of Focus",
        ["Effect"] = "A forbidden rune of lost Weaver craft.\n\nGrants 20% Soul cost reduction to all spells.",
        ["SlotCost"] = 1
    },
    ["ShamanRelic"] = {
        ["Name"] = "Shaman Relic",
        ["Effect"] = "A relic of the first shamans, who sought communion with the Void. Its spiral hums with ancient resonance.\n\nGreatly empowers the Damage of spells.",
        ["SlotCost"] = 2
    },
    ["BarbsOfSpite"] = {
        ["Name"] = "Barbs of Spite",
        ["Effect"] = "Thorns once found in the White Palace, now steeped in bitterness.\n\nThey lash out on to any who tread too close.",
        ["SlotCost"] = 1
    }
}

-- ===== SERVICES & MODULES =====
local Networking = ReplicatedStorage:WaitForChild("Networking")
local UnitEvent = Networking:WaitForChild("UnitEvent")
local AbilityEvent = Networking:WaitForChild("AbilityEvent")

-- Remote Events จากเกม
local AutoPlayEvent = Networking:FindFirstChild("AutoPlayEvent")
local RequestMiscPlacement = Networking:FindFirstChild("RequestMiscPlacement")

-- ===== WAVE TRACKER (จาก UI โดยตรง) =====
local TrackedWave = 0
local TrackedTotalWaves = 0

-- ฟังก์ชันดึง Wave จาก UI โดยตรง (PlayerGui.HUD.Map.WavesAmount)
local function GetWaveFromUI()
    local currentWave = 0
    local totalWaves = 0
    
    pcall(function()
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            -- วิธี 1: หาจาก HUD.Map.WavesAmount (ตรงที่สุด)
            local HUD = playerGui:FindFirstChild("HUD")
            if HUD then
                local Map = HUD:FindFirstChild("Map")
                if Map then
                    local WavesAmount = Map:FindFirstChild("WavesAmount")
                    if WavesAmount then
                        local text = ""
                        
                        -- ถ้าเป็น TextLabel ให้อ่าน Text
                        if WavesAmount:IsA("TextLabel") then
                            text = WavesAmount.Text or ""
                        end
                        
                        -- ถ้า text มี RichText tags ให้ strip ออก
                        -- รูปแบบ: <stroke ...><font ...>3</font></stroke><stroke ...><font ...>/15</font></stroke>
                        local cleanText = text:gsub("<[^>]+>", "") -- ลบ tags ทั้งหมด
                        
                        -- Debug (แสดงครั้งแรกเท่านั้น)
                        if cleanText ~= "" and TrackedTotalWaves == 0 then
                            print("[AutoPlay] Wave Raw:", text:sub(1, 100))
                            print("[AutoPlay] Wave Clean:", cleanText)
                        end
                        
                        -- Parse "3/15" จาก clean text
                        local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                        if cur and total then
                            currentWave = tonumber(cur) or 0
                            totalWaves = tonumber(total) or 0
                        end
                        
                        -- ถ้ายังหาไม่เจอ ลองหา pattern อื่น
                        if totalWaves == 0 then
                            -- หา total จาก text ที่อาจมีหลาย / เช่น "3/3/15" หรือ "33/15"
                            local allNumbers = {}
                            for num in cleanText:gmatch("(%d+)") do
                                table.insert(allNumbers, tonumber(num))
                            end
                            if #allNumbers >= 2 then
                                currentWave = allNumbers[1] or 0
                                totalWaves = allNumbers[#allNumbers] or 0 -- ใช้ตัวสุดท้าย
                            end
                        end
                    end
                end
            end
            
            -- วิธี 2: Fallback หาจาก descendants ถ้ายังไม่เจอ
            if totalWaves == 0 then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextLabel") then
                        local text = gui.Text or ""
                        local cleanText = text:gsub("<[^>]+>", "")
                        local cur, total = cleanText:match("(%d+)%s*/%s*(%d+)")
                        if cur and total then
                            local parsedTotal = tonumber(total)
                            local parsedCur = tonumber(cur)
                            if parsedTotal and parsedTotal > 0 and parsedTotal < 100 then
                                currentWave = parsedCur or 0
                                totalWaves = parsedTotal
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return currentWave, totalWaves
end

-- อัพเดท Wave ทุก loop
local function UpdateWaveFromUI()
    local cur, total = GetWaveFromUI()
    if cur > 0 then TrackedWave = cur end
    if total > 0 then TrackedTotalWaves = total end
end

-- ยังคง listen InterfaceEvent เป็น fallback
pcall(function()
    local InterfaceEvent = Networking:FindFirstChild("InterfaceEvent")
    if InterfaceEvent then
        InterfaceEvent.OnClientEvent:Connect(function(eventType, data)
            if eventType == "Wave" and data then
                if data.Waves then
                    TrackedWave = data.Waves
                end
                -- อัพเดทจาก UI ด้วย
                UpdateWaveFromUI()
            end
        end)
    end
end)

-- ===== SKIP WAVE / AUTO START EVENTS =====
local SkipWaveEvent = Networking:FindFirstChild("SkipWaveEvent")

-- หลายวิธีในการหา Start Event
local StartMatchEvent = nil
local ReadyEvent = nil
pcall(function()
    -- หา Start Match Event
    StartMatchEvent = Networking:FindFirstChild("StartMatchEvent") 
        or Networking:FindFirstChild("StartMatch")
        or Networking:FindFirstChild("StartGame")
        or Networking:FindFirstChild("BeginMatch")
    
    -- หา Ready Event
    ReadyEvent = Networking:FindFirstChild("ReadyEvent")
        or Networking:FindFirstChild("PlayerReady")
        or Networking:FindFirstChild("Ready")
end)

-- ===== CHARM SYSTEM EVENTS (Hollowseph) =====
-- พยายามหาหลายครั้งเพราะอาจยังโหลดไม่เสร็จ
local Units9 = nil
local EquipHollowsephCharm = nil
local UnequipHollowsephCharm = nil
local GetHollowsephData = nil
local HollowsephDataChanged = nil

local function InitCharmEvents()
    print("[AutoPlay] ====== INIT CHARM EVENTS ======")
    
    -- หา Units folder
    local unitsFolder = Networking:FindFirstChild("Units")
    if not unitsFolder then
        print("[AutoPlay] Units not found, waiting...")
        unitsFolder = Networking:WaitForChild("Units", 10)
    end
    
    if unitsFolder then
        print("[AutoPlay] Units folder found, children:")
        for _, child in ipairs(unitsFolder:GetChildren()) do
            print("  - ", child.Name, " (", child.ClassName, ")")
        end
        
        Units9 = unitsFolder:FindFirstChild("Update 9.0")
        if not Units9 then
            print("[AutoPlay] Update 9.0 not found, waiting...")
            Units9 = unitsFolder:WaitForChild("Update 9.0", 10)
        end
        
        if Units9 then
            print("[AutoPlay] Update 9.0 found, children:")
            for _, child in ipairs(Units9:GetChildren()) do
                print("  - ", child.Name, " (", child.ClassName, ")")
            end
            
            -- หา Charm Events
            EquipHollowsephCharm = Units9:FindFirstChild("EquipHollowsephCharm")
            UnequipHollowsephCharm = Units9:FindFirstChild("UnequipHollowsephCharm")
            GetHollowsephData = Units9:FindFirstChild("GetHollowsephData")
            HollowsephDataChanged = Units9:FindFirstChild("HollowsephDataChanged")
            
            -- ถ้าหาไม่เจอ ลองหาชื่อคล้ายๆ
            if not EquipHollowsephCharm then
                for _, child in ipairs(Units9:GetChildren()) do
                    if child.Name:lower():find("equip") and child.Name:lower():find("charm") then
                        EquipHollowsephCharm = child
                        print("[AutoPlay] Found alternative EquipCharm:", child.Name)
                        break
                    end
                end
            end
            
            if not UnequipHollowsephCharm then
                for _, child in ipairs(Units9:GetChildren()) do
                    if child.Name:lower():find("unequip") and child.Name:lower():find("charm") then
                        UnequipHollowsephCharm = child
                        print("[AutoPlay] Found alternative UnequipCharm:", child.Name)
                        break
                    end
                end
            end
            
            if not GetHollowsephData then
                for _, child in ipairs(Units9:GetChildren()) do
                    if child.Name:lower():find("hollowseph") and child.Name:lower():find("data") then
                        GetHollowsephData = child
                        print("[AutoPlay] Found alternative GetData:", child.Name)
                        break
                    end
                end
            end
        else
            print("[AutoPlay] ERROR: Update 9.0 folder not found!")
        end
    else
        print("[AutoPlay] ERROR: Units folder not found!")
    end
    
    print("[AutoPlay] ====== CHARM EVENTS RESULT ======")
    print("  Units9:", Units9 and Units9.Name or "NOT FOUND")
    print("  EquipHollowsephCharm:", EquipHollowsephCharm and EquipHollowsephCharm.Name or "NOT FOUND")
    print("  UnequipHollowsephCharm:", UnequipHollowsephCharm and UnequipHollowsephCharm.Name or "NOT FOUND")
    print("  GetHollowsephData:", GetHollowsephData and GetHollowsephData.Name or "NOT FOUND")
    print("  HollowsephDataChanged:", HollowsephDataChanged and HollowsephDataChanged.Name or "NOT FOUND")
    print("[AutoPlay] ================================")
end

-- Init Events ทันที
InitCharmEvents()

-- ===== GAME HANDLER (สำหรับเช็ค Match State) =====
local GameHandler = nil
pcall(function()
    GameHandler = require(ReplicatedStorage.Modules.Gameplay.GameHandler)
end)

-- ===== DATA STORAGE =====
local ActiveUnits = {} -- Units ที่วางไว้
local PlacedPositions = {} -- ตำแหน่งที่วางไว้แล้ว
local OutsideEnemyUnit = nil -- Unit ที่ใช้ตี Enemy นอกพื้นที่
local HasOutsideEnemyThisMap = false -- เจอ Enemy นอกพื้นที่ในแมพนี้หรือยัง
local LastPlaceTime = 0
local LastUpgradeTime = 0

-- ===== MAX WAVE TRACKING =====
local DetectedMaxWave = 0 -- Max Wave ที่ตรวจจับได้จาก UI
local HighestWaveSeen = 0 -- Wave สูงสุดที่เคยเห็นในด่านนี้
local WaveStableCount = 0 -- นับว่า wave ค้างอยู่กี่ครั้ง (ถ้าค้างนาน = อาจเป็น max)
local LastWaveForStableCheck = 0 -- wave ล่าสุดที่ใช้เช็ค stable

-- ===== FORWARD DECLARATIONS =====
local AutoEquipCharms -- Forward declaration
local GetHollowsephDataFromServer -- Forward declaration

-- ===== AUTO START / SKIP WAVE DATA =====
local SkipWaveActive = false
local LastVoteSkipTime = 0
local MatchStarted = false
local MatchEnded = false

-- ===== CHARM SYSTEM DATA =====
local HollowsephData = nil -- ข้อมูล Charm ปัจจุบันจาก server
local EquippedCharms = {} -- Charms ที่ equip อยู่
local LastCharmEquipTime = 0
local CharmSystemInitialized = false
local LastSkillTime = 0
local CurrentYen = 0 -- เงินปัจจุบัน (track จาก PlayerYenHandler)
local SlotPlaceCount = {} -- จำนวน unit ที่วางไว้แต่ละ slot {[slot] = count}
local IncomeSlots = {} -- slot ที่เป็น Income unit
local EnemyProgressMax = 0 -- enemy ที่ไปได้ไกลที่สุด (เป็น % ของ path)

-- ===== UNIT PASSIVES ANALYSIS DATABASE =====
-- ระบบวิเคราะห์ Passives ของ Unit แบบละเอียด (ไม่รวม Income)
-- สำหรับตัดสินใจ Placement และ Upgrade ให้เหมาะสมกับสถานการณ์
-- อิงจาก PassiveDescriptionHandler ของเกมจริง

local UnitPassivesCache = {} -- Cache ข้อมูล passives ของแต่ละ unit

-- ===== PASSIVE KEYWORDS จาก PassiveKeywordHandler =====
-- Keywords เหล่านี้จะถูกตรวจจับจาก Description ของ Passives
local PassiveKeywords = {
    -- Damage Over Time (DoT)
    Burn = {"burn", "burning", "burned", "intense burn", "fire", "flame", "ignite"},
    Bleed = {"bleed", "bleeding", "bled", "rupture", "ruptured", "cleave", "blood loss"},
    Frostburn = {"frostburn"},
    
    -- Control / CC
    Stun = {"stun", "stuns", "stunned", "stunning"},
    Slow = {"slow", "slowed", "slowing", "slows"},
    Freeze = {"freeze", "frozen"},
    Repulse = {"repulse", "repulsing", "repulsed"}, -- Knockback
    Bubble = {"bubble", "bubbled"},
    Tethered = {"tethered"},
    
    -- Special Effects
    Nullify = {"nullify", "nullified"}, -- ลบ buff
    Diseased = {"diseased"},
    
    -- Triggers
    OnKill = {"on kill"},
    OnAttack = {"on attack"},
    OnHit = {"on hit"},
    OnPlacement = {"on placement", "on deploy"},
    OnTakedown = {"on takedown", "on kill assist", "on assist"},
    
    -- Special
    Calamity = {"calamity"},
    Wanted = {"wanted"},
    Conduit = {"conduit"},
    
    -- Immunity
    StatusImmune = {"status effect immune"},
    DebuffImmune = {"debuff immune"},
}

-- ===== ENEMY TYPES ที่ต้องจัดการ =====
local EnemyTypeCounters = {
    -- Fast enemies = ต้องใช้ Slow, Stun, Freeze
    Fast = {"Slow", "Stun", "Freeze", "Repulse", "Bubble", "Tethered"},
    -- Tank enemies = ต้องใช้ DPS สูง, Bleed, Burn
    Tank = {"DPS", "Bleed", "Burn", "Frostburn"},
    -- Boss = ต้องใช้ทุกอย่าง
    Boss = {"DPS", "Slow", "Bleed", "Burn", "Stun", "OnKill"},
    -- Swarm (ฝูง) = AoE, Multi-hit
    Swarm = {"AoE", "MultiHit", "Cleave"},
    -- Lifesteal/Regen = ต้องใช้ BLEED เท่านั้น!
    Regen = {"Bleed"},
}

-- ===== FUNCTION: Parse Description Text หา Keywords =====
local function ParsePassiveDescription(description)
    if not description or type(description) ~= "string" then
        return {}
    end
    
    local descLower = description:lower()
    local foundKeywords = {}
    
    for category, keywords in pairs(PassiveKeywords) do
        for _, keyword in ipairs(keywords) do
            if descLower:find(keyword, 1, true) then -- plain text search
                foundKeywords[category] = true
                break
            end
        end
    end
    
    -- ===== Extra Detection: Numbers in Description =====
    -- หา % เพื่อดู slow amount, damage bonus, etc.
    local percentages = {}
    for num in descLower:gmatch("(%d+)%%") do
        table.insert(percentages, tonumber(num))
    end
    if #percentages > 0 then
        foundKeywords._Percentages = percentages
    end
    
    -- หา seconds เพื่อดู duration
    local durations = {}
    for num in descLower:gmatch("(%d+%.?%d*) ?seconds?") do
        table.insert(durations, tonumber(num))
    end
    for num in descLower:gmatch("(%d+%.?%d*)s") do
        table.insert(durations, tonumber(num))
    end
    if #durations > 0 then
        foundKeywords._Durations = durations
    end
    
    return foundKeywords
end

-- ===== FUNCTION: วิเคราะห์ Passives ของ Unit =====
local function AnalyzeUnitPassives(unitData, unitName)
    local passives = {
        -- Basic Stats
        DPS = 0,
        Range = 0,
        SPA = 1,
        HitCount = 1,
        
        -- DoT Effects
        HasBurn = false,
        HasBleed = false,
        HasFrostburn = false,
        
        -- Control / CC
        HasSlow = false,
        HasStun = false,
        HasFreeze = false,
        HasRepulse = false, -- Knockback
        HasBubble = false,
        HasTethered = false,
        
        -- Special
        HasNullify = false,
        HasDiseased = false,
        HasCalamity = false,
        HasWanted = false,
        HasConduit = false,
        
        -- Triggers
        HasOnKill = false,
        HasOnAttack = false,
        HasOnHit = false,
        HasOnPlacement = false,
        
        -- AoE / Multi
        IsAoE = false,
        IsMultiHit = false,
        HasCleave = false,
        
        -- Immunities
        IsStatusImmune = false,
        IsDebuffImmune = false,
        
        -- Raw Passive Data
        PassivesList = {},
        
        -- Scores
        TotalScore = 0,
        ControlScore = 0,
        DamageScore = 0,
        SpecialScore = 0,
    }
    
    if not unitData then return passives end
    
    -- ===== Step 1: Parse Basic Stats =====
    local baseDamage = unitData.Damage or unitData.BaseDamage or unitData.Dmg or 10
    local spa = unitData.SPA or unitData.AttackSpeed or unitData.Speed or 1
    local range = unitData.Range or unitData.AttackRange or 25
    local hitCount = unitData.HitCount or unitData.Hits or 1
    
    passives.Range = range
    passives.SPA = spa
    passives.HitCount = hitCount
    passives.DPS = (baseDamage * hitCount) / math.max(spa, 0.1)
    
    -- ===== Step 2: Parse Passives Table (จาก format เกมจริง) =====
    -- Passives = { {Name = "...", Description = "...", UpgradeRequired = n}, ... }
    local passivesTable = unitData.Passives or {}
    
    for _, passive in pairs(passivesTable) do
        if type(passive) == "table" then
            local passiveName = passive.Name or ""
            local passiveDesc = passive.Description or ""
            
            -- เก็บข้อมูล passive ดิบ
            table.insert(passives.PassivesList, {
                Name = passiveName,
                Description = passiveDesc,
                UpgradeRequired = passive.UpgradeRequired
            })
            
            -- Parse keywords จาก Description
            local keywords = ParsePassiveDescription(passiveDesc)
            
            -- Map keywords to passives
            if keywords.Burn then passives.HasBurn = true end
            if keywords.Bleed then passives.HasBleed = true; passives.HasCleave = true end
            if keywords.Frostburn then passives.HasFrostburn = true; passives.HasBurn = true end
            
            if keywords.Stun then passives.HasStun = true end
            if keywords.Slow then passives.HasSlow = true end
            if keywords.Freeze then passives.HasFreeze = true end
            if keywords.Repulse then passives.HasRepulse = true end
            if keywords.Bubble then passives.HasBubble = true end
            if keywords.Tethered then passives.HasTethered = true end
            
            if keywords.Nullify then passives.HasNullify = true end
            if keywords.Diseased then passives.HasDiseased = true end
            if keywords.Calamity then passives.HasCalamity = true end
            if keywords.Wanted then passives.HasWanted = true end
            if keywords.Conduit then passives.HasConduit = true end
            
            if keywords.OnKill then passives.HasOnKill = true end
            if keywords.OnAttack then passives.HasOnAttack = true end
            if keywords.OnHit then passives.HasOnHit = true end
            if keywords.OnPlacement then passives.HasOnPlacement = true end
            
            if keywords.StatusImmune then passives.IsStatusImmune = true end
            if keywords.DebuffImmune then passives.IsDebuffImmune = true end
            
            -- Check for AoE keywords in name/desc
            local nameLower = passiveName:lower()
            local descLower = passiveDesc:lower()
            
            if nameLower:find("aoe") or descLower:find("area") or descLower:find("splash") or 
               descLower:find("enemies nearby") or descLower:find("all enemies") or
               descLower:find("explosion") or descLower:find("blast") then
                passives.IsAoE = true
            end
            
            -- Check for Multi-hit
            if nameLower:find("multi") or descLower:find("multi") or 
               descLower:find("rapid") or descLower:find("barrage") or
               descLower:find("flurry") or descLower:find("chain") then
                passives.IsMultiHit = true
            end
        end
    end
    
    -- ===== Step 3: เช็คจาก UnitType / Tags =====
    if unitData.UnitType then
        local typeLower = tostring(unitData.UnitType):lower()
        if typeLower:find("aoe") or typeLower:find("splash") then passives.IsAoE = true end
        if typeLower:find("support") then passives.HasBuff = true end
    end
    
    if unitData.Tags then
        for _, tag in pairs(unitData.Tags) do
            if type(tag) == "string" then
                local tagLower = tag:lower()
                if tagLower:find("burn") or tagLower:find("fire") then passives.HasBurn = true end
                if tagLower:find("bleed") then passives.HasBleed = true end
                if tagLower:find("slow") or tagLower:find("frost") then passives.HasSlow = true end
                if tagLower:find("stun") then passives.HasStun = true end
                if tagLower:find("aoe") or tagLower:find("splash") then passives.IsAoE = true end
            end
        end
    end
    
    -- ===== Step 4: Infer from Hit Count =====
    if hitCount > 1 then
        passives.IsMultiHit = true
    end
    
    -- ===== Step 5: Calculate Scores =====
    -- Damage Score
    passives.DamageScore = passives.DPS
    if passives.HasBurn then passives.DamageScore = passives.DamageScore + 30 end
    if passives.HasBleed then passives.DamageScore = passives.DamageScore + 30 end
    if passives.HasFrostburn then passives.DamageScore = passives.DamageScore + 40 end
    if passives.HasOnKill then passives.DamageScore = passives.DamageScore + 20 end
    if passives.HasOnAttack then passives.DamageScore = passives.DamageScore + 15 end
    
    -- Control Score (สำหรับ Fast enemies)
    passives.ControlScore = 0
    if passives.HasSlow then passives.ControlScore = passives.ControlScore + 50 end
    if passives.HasStun then passives.ControlScore = passives.ControlScore + 80 end
    if passives.HasFreeze then passives.ControlScore = passives.ControlScore + 100 end
    if passives.HasRepulse then passives.ControlScore = passives.ControlScore + 40 end
    if passives.HasBubble then passives.ControlScore = passives.ControlScore + 60 end
    if passives.HasTethered then passives.ControlScore = passives.ControlScore + 50 end
    
    -- Special Score (สำหรับ AoE และ Swarm)
    passives.SpecialScore = 0
    if passives.IsAoE then passives.SpecialScore = passives.SpecialScore + 60 end
    if passives.IsMultiHit then passives.SpecialScore = passives.SpecialScore + 40 end
    if passives.HasCleave then passives.SpecialScore = passives.SpecialScore + 50 end
    if passives.HasNullify then passives.SpecialScore = passives.SpecialScore + 30 end
    if passives.HasCalamity then passives.SpecialScore = passives.SpecialScore + 100 end
    
    -- Total Score
    passives.TotalScore = passives.DamageScore + passives.ControlScore + passives.SpecialScore
    
    return passives
end

-- ===== FUNCTION: Get Cached Unit Passives =====
local function GetUnitPassives(unitData, unitName)
    local cacheKey = unitName or "unknown"
    
    if not UnitPassivesCache[cacheKey] then
        UnitPassivesCache[cacheKey] = AnalyzeUnitPassives(unitData, unitName)
    end
    
    return UnitPassivesCache[cacheKey]
end

-- ===== FUNCTION: คำนวณว่า Unit นี้เหมาะกับ Enemy Type ไหน =====
local function GetUnitEffectivenessForEnemyType(passives, enemyType)
    local effectiveness = 0
    local counters = EnemyTypeCounters[enemyType] or {}
    
    for _, counter in ipairs(counters) do
        if counter == "DPS" and passives.DPS > 50 then
            effectiveness = effectiveness + 20
        end
        if counter == "Slow" and passives.HasSlow then
            effectiveness = effectiveness + 50
        end
        if counter == "Stun" and passives.HasStun then
            effectiveness = effectiveness + 80
        end
        if counter == "Freeze" and passives.HasFreeze then
            effectiveness = effectiveness + 100
        end
        if counter == "Repulse" and passives.HasRepulse then
            effectiveness = effectiveness + 40
        end
        if counter == "Bubble" and passives.HasBubble then
            effectiveness = effectiveness + 60
        end
        if counter == "Tethered" and passives.HasTethered then
            effectiveness = effectiveness + 50
        end
        if counter == "Bleed" and passives.HasBleed then
            effectiveness = effectiveness + 30
        end
        if counter == "Burn" and passives.HasBurn then
            effectiveness = effectiveness + 30
        end
        if counter == "Frostburn" and passives.HasFrostburn then
            effectiveness = effectiveness + 40
        end
        if counter == "AoE" and passives.IsAoE then
            effectiveness = effectiveness + 60
        end
        if counter == "MultiHit" and passives.IsMultiHit then
            effectiveness = effectiveness + 40
        end
        if counter == "Cleave" and passives.HasCleave then
            effectiveness = effectiveness + 50
        end
        if counter == "Nullify" and passives.HasNullify then
            effectiveness = effectiveness + 30
        end
        if counter == "OnKill" and passives.HasOnKill then
            effectiveness = effectiveness + 20
        end
    end
    
    return effectiveness
end

-- NOTE: DetectEnemyTypes moved after GetEnemies function (line ~1200)

-- ===== UTILITY FUNCTIONS =====
local function DebugPrint(...)
    if Settings["Debug"] then
        print("[AutoPlay]", ...)
    end
end

-- Initialize Yen tracking from PlayerYenHandler
local function InitYenTracking()
    if PlayerYenHandler then
        -- Subscribe to OnYenChanged event
        pcall(function()
            if PlayerYenHandler.OnYenChanged then
                PlayerYenHandler.OnYenChanged:Connect(function(newYen)
                    CurrentYen = newYen
                    DebugPrint("Yen updated:", CurrentYen)
                end)
                DebugPrint("Subscribed to PlayerYenHandler.OnYenChanged")
            end
            
            -- Get initial Yen
            if PlayerYenHandler.GetYen then
                CurrentYen = PlayerYenHandler.GetYen() or 0
            end
        end)
    end
end

local function GetYen()
    -- วิธีที่ 0: ใช้ CurrentYen ที่ track ไว้จาก PlayerYenHandler.OnYenChanged
    if CurrentYen and CurrentYen > 0 then
        return CurrentYen
    end
    
    -- วิธีที่ 1: ใช้ PlayerYenHandler (เกม AV ใช้ module นี้)
    if PlayerYenHandler then
        local yen = nil
        pcall(function()
            if PlayerYenHandler.GetYen then
                yen = PlayerYenHandler:GetYen()
            elseif PlayerYenHandler.Yen then
                yen = PlayerYenHandler.Yen
            elseif PlayerYenHandler._Yen then
                yen = PlayerYenHandler._Yen
            end
        end)
        if yen and yen > 0 then
            CurrentYen = yen
            return yen
        end
    end
    
    -- วิธีที่ 2: หาจาก HUD โดยตรง
    local HUD = PlayerGui:FindFirstChild("HUD")
    if HUD then
        -- หาจาก Yen frame โดยเฉพาะ
        local YenFrame = HUD:FindFirstChild("Yen") or HUD:FindFirstChild("Money") or HUD:FindFirstChild("Currency")
        if YenFrame then
            for _, child in pairs(YenFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    local text = child.Text
                    if text and type(text) == "string" and text:len() > 0 then
                        local numStr = text:gsub(",", ""):gsub("¥", ""):gsub("%$", ""):match("([%d]+)")
                        if numStr then
                            local num = tonumber(numStr)
                            if num and num >= 0 then
                                return num
                            end
                        end
                    end
                end
            end
        end
        
        -- หาจาก Hotbar ที่แสดง Yen (ดูจาก screenshot มันอยู่ตรงกลาง)
        local Hotbar = PlayerGui:FindFirstChild("Hotbar")
        if Hotbar then
            for _, child in pairs(Hotbar:GetDescendants()) do
                if child:IsA("TextLabel") then
                    local text = child.Text
                    if text and type(text) == "string" then
                        if text:find("¥") then
                            local numStr = text:gsub(",", ""):gsub("¥", ""):match("([%d]+)")
                            if numStr then
                                local num = tonumber(numStr)
                                if num and num >= 0 then
                                    return num
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- หาจาก descendants ทั้งหมดของ HUD ที่มี "¥"
        for _, child in pairs(HUD:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local text = child.Text
                if text and type(text) == "string" then
                    if text:find("¥") then
                        local numStr = text:gsub(",", ""):gsub("¥", ""):match("([%d]+)")
                        if numStr then
                            local num = tonumber(numStr)
                            if num and num >= 0 then
                                return num
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- วิธีที่ 3: ใช้ ClientGameStateHandler ของเกม
    if ClientGameStateHandler then
        local state = nil
        pcall(function()
            state = ClientGameStateHandler:GetPlayerState(plr)
        end)
        if state and state.Yen then
            return state.Yen
        end
    end
    
    return 0
end

-- Cache สำหรับ Hotbar Units
local HotbarCache = nil
local HotbarCacheTime = 0
local HotbarCacheDuration = 1 -- cache 1 วินาที

local function GetHotbarUnits()
    -- ใช้ cache ถ้ายังไม่หมดอายุ
    if HotbarCache and (tick() - HotbarCacheTime) < HotbarCacheDuration then
        return HotbarCache
    end
    
    local units = {}
    
    -- ลองใช้ UnitsHUD ก่อน
    if UnitsHUD and UnitsHUD._Cache then
        local count = 0
        for i, v in pairs(UnitsHUD._Cache) do
            if v ~= "None" and v ~= nil then
                local unitData = v.Data or v
                local price = 0
                
                -- หา price หลายวิธี
                if unitData.Cost then
                    price = unitData.Cost
                elseif unitData.Price then
                    price = unitData.Price
                elseif v.Cost then
                    price = v.Cost
                end
                
                -- ===== เช็คว่าเป็น Income Unit หรือไม่ =====
                local isIncome = false
                local incomeAmount = 0
                
                -- ===== วิธี 1: เช็คจาก Abilities (สำคัญที่สุด) =====
                if unitData.Abilities then
                    for abilityName, ability in pairs(unitData.Abilities) do
                        -- เช็คชื่อ key
                        if type(abilityName) == "string" then
                            local keyLower = abilityName:lower()
                            if keyLower:find("income") or keyLower:find("money") or keyLower:find("yen") or keyLower:find("cash") or keyLower:find("farm") or keyLower:find("earn") then
                                isIncome = true
                            end
                        end
                        
                        if type(ability) == "table" then
                            -- เช็ค Type
                            if ability.Type then
                                local typeLower = tostring(ability.Type):lower()
                                if typeLower:find("income") or typeLower:find("money") or typeLower:find("farm") then
                                    isIncome = true
                                    incomeAmount = ability.Amount or ability.Value or ability.Income or 0
                                end
                            end
                            
                            -- เช็ค Name
                            if ability.Name then
                                local nameLower = tostring(ability.Name):lower()
                                if nameLower:find("income") or nameLower:find("money") or nameLower:find("yen") or nameLower:find("cash") or nameLower:find("farm") or nameLower:find("earn") then
                                    isIncome = true
                                end
                            end
                            
                            -- เช็ค Income field โดยตรง
                            if ability.Income then
                                isIncome = true
                                incomeAmount = ability.Income
                            end
                        end
                    end
                end
                
                -- ===== วิธี 2: เช็คจาก field Income โดยตรง =====
                if unitData.Income then
                    isIncome = true
                    incomeAmount = unitData.Income
                end
                
                -- ===== วิธี 3: เช็คจาก PassiveIncome หรือ IncomePerWave =====
                if unitData.PassiveIncome or unitData.IncomePerWave or unitData.MoneyPerWave then
                    isIncome = true
                    incomeAmount = unitData.PassiveIncome or unitData.IncomePerWave or unitData.MoneyPerWave or 0
                end
                
                -- ===== วิธี 4: เช็คจาก Stats =====
                if unitData.Stats then
                    for statName, statVal in pairs(unitData.Stats) do
                        if type(statName) == "string" then
                            local statLower = statName:lower()
                            if statLower:find("income") or statLower:find("money") or statLower:find("earn") then
                                isIncome = true
                            end
                        end
                    end
                end
                
                -- ===== วิธี 5: เช็คจาก Tags =====
                if unitData.Tags then
                    for _, tag in pairs(unitData.Tags) do
                        if type(tag) == "string" then
                            local tagLower = tag:lower()
                            if tagLower:find("income") or tagLower:find("farm") or tagLower:find("money") then
                                isIncome = true
                            end
                        end
                    end
                end
                
                -- ===== วิธี 6: เช็คจาก Category/Type =====
                if unitData.Category then
                    local catLower = tostring(unitData.Category):lower()
                    if catLower:find("income") or catLower:find("farm") or catLower:find("support") then
                        isIncome = true
                    end
                end
                
                if unitData.UnitType then
                    local typeLower = tostring(unitData.UnitType):lower()
                    if typeLower:find("income") or typeLower:find("farm") then
                        isIncome = true
                    end
                end
                
                -- หา ID ของ unit
                local unitID = unitData.ID or unitData.Identifier or v.Identifier or i
                
                units[i] = {
                    Slot = i,
                    Name = unitData.Name or v.Name or "Unknown",
                    ID = unitID,
                    Price = price,
                    Data = unitData,
                    Available = true,
                    IsIncome = isIncome,
                    IncomeAmount = incomeAmount
                }
                count = count + 1
            end
        end
        if count > 0 then
            -- บันทึก cache
            HotbarCache = units
            HotbarCacheTime = tick()
            return units
        end
    end
    
    -- Fallback: ใช้ PlayerGui.Hotbar
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if Hotbar and Hotbar:FindFirstChild("Main") and Hotbar.Main:FindFirstChild("Units") then
        for i = 1, 6 do
            local slot = Hotbar.Main.Units:FindFirstChild(tostring(i))
            if slot and slot:FindFirstChild("Button") then
                local unitName = slot:GetAttribute("UnitName") or slot.Name
                local price = slot:GetAttribute("Price") or 0
                units[i] = {
                    Slot = i,
                    Name = unitName,
                    Price = price,
                    Available = slot.Button.Visible
                }
            end
        end
    end
    
    -- บันทึก cache
    HotbarCache = units
    HotbarCacheTime = tick()
    
    return units
end

-- เช็คว่าสามารถซื้อ Unit ได้หรือไม่จาก Hotbar UI (แม่นยำกว่าเช็คเงินเอง)
local function CanAffordSlot(slot)
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return false end
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then return false end
    
    local Units = Main:FindFirstChild("Units")
    if not Units then return false end
    
    local slotFrame = Units:FindFirstChild(tostring(slot))
    if not slotFrame then return false end
    
    -- เช็คจาก Attribute CanAfford หรือจากสี/Transparency ของปุ่ม
    local canAfford = slotFrame:GetAttribute("CanAfford")
    if canAfford ~= nil then
        return canAfford == true
    end
    
    -- เช็คจาก Button - ถ้าปุ่มจางหรือสีเทา = ซื้อไม่ได้
    local button = slotFrame:FindFirstChild("Button") or slotFrame:FindFirstChild("Frame")
    if button then
        -- ถ้า Visible = false = ไม่มี unit ในช่องนี้
        if button:IsA("GuiButton") and not button.Visible then
            return false
        end
        
        -- เช็ค BackgroundTransparency - ถ้าจาง = ซื้อไม่ได้
        if button.BackgroundTransparency and button.BackgroundTransparency > 0.5 then
            return false
        end
    end
    
    -- Fallback: เช็คจากเงิน
    local units = GetHotbarUnits()
    local unit = units[slot]
    if unit and unit.Price then
        local yen = GetYen()
        return yen >= unit.Price
    end
    
    return false
end

-- เช็คว่า slot วางครบ limit หรือยัง (เช่น "You can only place 6 of this unit!")
local function GetSlotLimit(slot)
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return 99, 0 end -- ไม่มี limit
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then return 99, 0 end
    
    local Units = Main:FindFirstChild("Units")
    if not Units then return 99, 0 end
    
    local slotFrame = Units:FindFirstChild(tostring(slot))
    if not slotFrame then return 99, 0 end
    
    -- หา TextLabel ที่แสดง x/y format (เช่น "0/33" หรือ "3/6")
    for _, child in pairs(slotFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local text = child.Text
            if text and type(text) == "string" then
                local current, max = text:match("(%d+)/(%d+)")
                if current and max then
                    return tonumber(max), tonumber(current)
                end
            end
        end
    end
    
    -- ลองหาจาก Attribute
    local limit = slotFrame:GetAttribute("PlacementLimit") or slotFrame:GetAttribute("Limit")
    local placed = slotFrame:GetAttribute("PlacedCount") or slotFrame:GetAttribute("Placed") or 0
    if limit then
        return limit, placed
    end
    
    return 99, SlotPlaceCount[slot] or 0 -- ไม่พบ = ไม่มี limit
end

-- เช็คว่า slot นี้เป็น Income unit หรือไม่
local function IsIncomeSlot(slot)
    -- ===== วิธี 1: เช็คจาก cache ก่อน =====
    if IncomeSlots[slot] ~= nil then
        return IncomeSlots[slot]
    end
    
    -- ===== วิธี 2: เช็คจาก UnitData (แม่นยำที่สุด) =====
    local hotbar = GetHotbarUnits()
    local unit = hotbar[slot]
    if unit and unit.IsIncome then
        IncomeSlots[slot] = true
        DebugPrint("พบ Income Unit จาก UnitData ที่ slot", slot, ":", unit.Name)
        return true
    end
    
    -- ===== วิธี 3: เช็คจาก UI =====
    local Hotbar = PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then 
        IncomeSlots[slot] = false
        return false 
    end
    
    local Main = Hotbar:FindFirstChild("Main")
    if not Main then 
        IncomeSlots[slot] = false
        return false 
    end
    
    local Units = Main:FindFirstChild("Units")
    if not Units then 
        IncomeSlots[slot] = false
        return false 
    end
    
    local slotFrame = Units:FindFirstChild(tostring(slot))
    if not slotFrame then 
        IncomeSlots[slot] = false
        return false 
    end
    
    -- หา "INCOME" หรือ "$" หรือ "¥" ใน slot
    for _, child in pairs(slotFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local text = child.Text
            if text and type(text) == "string" then
                local textUpper = text:upper()
                if textUpper:find("INCOME") or text:find("%$") or textUpper:find("MONEY") or textUpper:find("FARM") then
                    IncomeSlots[slot] = true
                    DebugPrint("พบ Income Unit จาก UI ที่ slot", slot)
                    return true
                end
            end
        end
    end
    
    IncomeSlots[slot] = false
    return false
end

-- เช็คว่า slot ยังวางได้อีกหรือไม่ (ยังไม่ถึง limit)
local function CanPlaceSlot(slot)
    local limit, current = GetSlotLimit(slot)
    if current >= limit then
        return false
    end
    return true
end

-- สรุปสถานะ slot ทั้งหมด (เหมือน AutoPlay_Smart)
local function GetSlotsSummary()
    local hotbar = GetHotbarUnits()
    local summary = {
        income = {placed = 0, limit = 0, slots = {}},
        dps = {placed = 0, limit = 0, slots = {}},
        total = {placed = 0, limit = 0}
    }
    
    for slot, unit in pairs(hotbar) do
        local limit, current = GetSlotLimit(slot)
        local isIncome = unit.IsIncome or IsIncomeSlot(slot)
        
        if isIncome then
            summary.income.placed = summary.income.placed + current
            summary.income.limit = summary.income.limit + limit
            table.insert(summary.income.slots, {slot = slot, name = unit.Name, current = current, limit = limit})
        else
            summary.dps.placed = summary.dps.placed + current
            summary.dps.limit = summary.dps.limit + limit
            table.insert(summary.dps.slots, {slot = slot, name = unit.Name, current = current, limit = limit})
        end
        
        summary.total.placed = summary.total.placed + current
        summary.total.limit = summary.total.limit + limit
    end
    
    return summary
end

local function GetActiveUnits()
    local units = {}
    
    -- ลองใช้ ClientUnitHandler ก่อน
    if ClientUnitHandler and ClientUnitHandler._ActiveUnits then
        for guid, unitData in pairs(ClientUnitHandler._ActiveUnits) do
            if unitData.Player == plr then
                table.insert(units, {
                    Model = unitData.Model,
                    Name = unitData.Name or guid,
                    Position = unitData.Model and unitData.Model:FindFirstChild("HumanoidRootPart") and unitData.Model.HumanoidRootPart.Position,
                    GUID = guid,
                    Data = unitData
                })
            end
        end
        if #units > 0 then
            return units
        end
    end
    
    -- Fallback: ใช้ workspace.Units
    if workspace:FindFirstChild("Units") then
        for _, unit in pairs(workspace.Units:GetChildren()) do
            if unit:IsA("Model") and unit:FindFirstChild("HumanoidRootPart") then
                local owner = unit:GetAttribute("Owner") or unit:GetAttribute("Player")
                if owner == plr.Name or owner == plr.UserId then
                    table.insert(units, {
                        Model = unit,
                        Name = unit.Name,
                        Position = unit.HumanoidRootPart.Position,
                        GUID = unit.Name,
                        Data = {
                            UnitType = unit:GetAttribute("UnitType"),
                            IsIncome = unit:GetAttribute("IsIncome"),
                            CurrentUpgrade = unit:GetAttribute("CurrentUpgrade") or unit:GetAttribute("Level")
                        }
                    })
                end
            end
        end
    end
    return units
end

local function GetEnemies()
    local enemies = {}
    
    -- ===== วิธี 0: ClientEnemyHandler (วิธีที่ดีที่สุด!) =====
    if ClientEnemyHandler then
        pcall(function()
            -- ลอง _ActiveEnemies ก่อน
            if ClientEnemyHandler._ActiveEnemies then
                for _, enemy in pairs(ClientEnemyHandler._ActiveEnemies) do
                    local pos = nil
                    if enemy.Position then
                        pos = enemy.Position
                    elseif enemy.Model then
                        local hrp = enemy.Model:FindFirstChild("HumanoidRootPart") or enemy.Model.PrimaryPart
                        if hrp then pos = hrp.Position end
                    end
                    
                    if pos then
                        table.insert(enemies, {
                            Model = enemy.Model,
                            Name = enemy.Name or (enemy.Model and enemy.Model.Name) or "Enemy",
                            Position = pos,
                            Health = enemy.Health or enemy.CurrentHealth or 100,
                            MaxHealth = enemy.MaxHealth or 100,
                            Progress = enemy.Progress or enemy.Alpha or 0,
                            UniqueIdentifier = enemy.UniqueIdentifier,
                            CurrentNode = enemy.CurrentNode,
                            IsBoss = enemy.IsBoss or (enemy.Name and enemy.Name:lower():find("boss")),
                        })
                    end
                end
            end
            
            -- ลอง GetEnemiesInRange ถ้ามี
            if #enemies == 0 and ClientEnemyHandler.GetEnemiesInRange then
                local inRange = ClientEnemyHandler:GetEnemiesInRange(Vector3.new(0, 0, 0), 10000)
                if inRange then
                    for _, enemy in pairs(inRange) do
                        if enemy.Position then
                            table.insert(enemies, {
                                Model = enemy.Model,
                                Name = enemy.Name or "Enemy",
                                Position = enemy.Position,
                                Health = enemy.Health or 100,
                                MaxHealth = enemy.MaxHealth or 100,
                            })
                        end
                    end
                end
            end
        end)
    end
    
    -- ===== วิธี 1: หาจาก workspace.Entities (ที่ AV ใช้!) =====
    if #enemies == 0 and workspace:FindFirstChild("Entities") then
        for _, entity in pairs(workspace.Entities:GetChildren()) do
            if entity:IsA("Model") then
                -- เช็คว่าเป็น Enemy ไม่ใช่ Unit
                local isEnemy = entity.Name:lower():find("goblin") or entity.Name:lower():find("wolf") or
                               entity.Name:lower():find("lizard") or entity.Name:lower():find("enemy") or
                               entity.Name:lower():find("boss") or entity.Name:lower():find("demon") or
                               entity.Name:lower():find("titan") or entity.Name:lower():find("king")
                
                if isEnemy or not entity:GetAttribute("IsUnit") then
                    local hrp = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Root") or entity.PrimaryPart
                    if hrp then
                        local humanoid = entity:FindFirstChildOfClass("Humanoid")
                        table.insert(enemies, {
                            Model = entity,
                            Name = entity.Name,
                            Position = hrp.Position,
                            Health = humanoid and humanoid.Health or 100,
                            MaxHealth = humanoid and humanoid.MaxHealth or 100
                        })
                    end
                end
            end
        end
    end
    
    -- ===== วิธี 2: หาจาก workspace.Enemies =====
    if #enemies == 0 and workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") then
                local hrp = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Root") or enemy.PrimaryPart
                if hrp then
                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                    table.insert(enemies, {
                        Model = enemy,
                        Name = enemy.Name,
                        Position = hrp.Position,
                        Health = humanoid and humanoid.Health or 100,
                        MaxHealth = humanoid and humanoid.MaxHealth or 100
                    })
                end
            end
        end
    end
    
    -- ===== วิธี 3: หาจาก workspace.Map.Enemies =====
    if #enemies == 0 then
        local Map = workspace:FindFirstChild("Map")
        if Map then
            local enemiesFolder = Map:FindFirstChild("Enemies") or Map:FindFirstChild("Enemy") or Map:FindFirstChild("Mobs")
            if enemiesFolder then
                for _, enemy in pairs(enemiesFolder:GetChildren()) do
                    if enemy:IsA("Model") then
                        local hrp = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Root") or enemy.PrimaryPart
                        if hrp then
                            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                            table.insert(enemies, {
                                Model = enemy,
                                Name = enemy.Name,
                                Position = hrp.Position,
                                Health = humanoid and humanoid.Health or 100,
                                MaxHealth = humanoid and humanoid.MaxHealth or 100
                            })
                        end
                    end
                end
            end
        end
    end
    
    return enemies
end

-- ===== FUNCTION: วิเคราะห์ Enemy ปัจจุบันว่าเป็นประเภทไหน =====
local function DetectEnemyTypes()
    local enemies = GetEnemies()
    local detected = {
        Fast = false,
        Tank = false,
        Boss = false,
        Swarm = false,
        Regen = false,
        Flying = false,
    }
    
    local enemyCount = #enemies
    
    -- ถ้ามี enemy >= 8 ตัว = Swarm
    if enemyCount >= 8 then
        detected.Swarm = true
    end
    
    for _, enemy in pairs(enemies) do
        local name = (enemy.Name or ""):lower()
        local hp = enemy.Health or enemy.HP or 100
        local maxHP = enemy.MaxHealth or hp
        
        -- Fast enemies
        if name:find("fast") or name:find("sprint") or name:find("speed") or name:find("runner") or
           name:find("lycan") or name:find("wolf") or name:find("goblin") then
            detected.Fast = true
        end
        
        -- Tank/Boss enemies
        if maxHP > 5000 or name:find("boss") or name:find("elite") or name:find("champion") or
           name:find("giant") or name:find("golem") then
            detected.Boss = true
            detected.Tank = true
        elseif maxHP > 1000 or name:find("tank") or name:find("armor") then
            detected.Tank = true
        end
        
        -- Regen/Lifesteal enemies
        if name:find("regen") or name:find("heal") or name:find("leech") or name:find("vampire") or
           name:find("drain") then
            detected.Regen = true
        end
        
        -- Flying enemies
        if name:find("fly") or name:find("bird") or name:find("dragon") or name:find("bat") or
           name:find("wing") then
            detected.Flying = true
        end
    end
    
    return detected, enemyCount
end

local function GetMapPath()
    local path = {}
    
    -- ===== วิธีที่ 1: ใช้ EnemyPathHandler ของเกม (วิธีที่ถูกต้องที่สุด) =====
    if EnemyPathHandler and EnemyPathHandler.Nodes then
        for nodeName, node in pairs(EnemyPathHandler.Nodes) do
            if node.Position then
                table.insert(path, {
                    Position = node.Position,
                    Index = node.Index or 0,
                    Node = node
                })
            end
        end
        if #path > 0 then
            -- Sort by index
            table.sort(path, function(a, b)
                return (a.Index or 0) < (b.Index or 0)
            end)
            -- Return just positions
            local positions = {}
            for _, p in ipairs(path) do
                table.insert(positions, p.Position)
            end
            return positions
        end
    end
    
    -- ===== วิธีที่ 2: หาจาก workspace =====
    local pathFolders = {
        workspace:FindFirstChild("Path"),
        workspace:FindFirstChild("Paths"),
        workspace:FindFirstChild("WayPoints"),
        workspace:FindFirstChild("Waypoints"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Path"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Paths"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WayPoints"),
    }
    
    for _, pathFolder in pairs(pathFolders) do
        if pathFolder then
            for _, node in pairs(pathFolder:GetChildren()) do
                if node:IsA("BasePart") then
                    table.insert(path, node.Position)
                elseif node:IsA("Attachment") then
                    table.insert(path, node.WorldPosition)
                end
            end
            if #path > 0 then
                DebugPrint("พบ Path:", #path, "nodes จาก", pathFolder.Name)
                break
            end
        end
    end
    
    -- Sort by name/order
    if #path > 0 then
        table.sort(path, function(a, b)
            return a.Magnitude < b.Magnitude
        end)
    end
    return path
end

local function GetPlaceablePositions()
    local positions = {}
    local spacing = Settings["Unit Spacing"]
    
    -- ===== วิธีที่ 1: หาจาก workspace.Map.PlacementAreas (AV ใช้วิธีนี้) =====
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local PlacementAreas = Map:FindFirstChild("PlacementAreas")
        if PlacementAreas then
            DebugPrint("พบ PlacementAreas folder, จำนวน children:", #PlacementAreas:GetDescendants())
            for _, area in pairs(PlacementAreas:GetDescendants()) do
                if area:IsA("BasePart") then
                    local size = area.Size
                    local cf = area.CFrame
                    
                    DebugPrint("พบ Area:", area.Name, "Size:", size, "Position:", cf.Position)
                    
                    -- สร้างตำแหน่งบน area โดยคำนึงถึง rotation
                    -- เพิ่ม spacing เพื่อให้ห่างขอบมากขึ้น
                    local edgeMargin = math.max(spacing, 2)
                    for x = -size.X/2 + edgeMargin, size.X/2 - edgeMargin, spacing do
                        for z = -size.Z/2 + edgeMargin, size.Z/2 - edgeMargin, spacing do
                            local localPos = Vector3.new(x, 0.5, z)
                            local worldPos = cf:PointToWorldSpace(localPos)
                            
                            -- เช็คว่าตำแหน่งนี้ถูกใช้ไปแล้วหรือยัง
                            local occupied = false
                            for _, placedPos in pairs(PlacedPositions) do
                                if (placedPos - worldPos).Magnitude < spacing then
                                    occupied = true
                                    break
                                end
                            end
                            
                            -- เช็คกับ Units ที่วางอยู่แล้ว
                            if not occupied then
                                local activeUnits = GetActiveUnits()
                                for _, unit in pairs(activeUnits) do
                                    if unit.Position and (unit.Position - worldPos).Magnitude < spacing then
                                        occupied = true
                                        break
                                    end
                                end
                            end
                            
                            if not occupied then
                                table.insert(positions, worldPos)
                            end
                        end
                    end
                end
            end
            if #positions > 0 then
                DebugPrint("พบ Placeable จาก Map.PlacementAreas:", #positions, "positions")
                return positions
            else
                DebugPrint("❌ PlacementAreas มี แต่สร้าง positions ไม่ได้")
            end
        else
            DebugPrint("❌ ไม่พบ PlacementAreas ใน Map")
        end
    else
        DebugPrint("❌ ไม่พบ Map ใน workspace")
    end
    
    -- ===== วิธีที่ 2: หาจาก CollectionService =====
    local taggedAreas = {}
    pcall(function()
        taggedAreas = CollectionService:GetTagged("PlacementArea")
    end)
    
    for _, area in pairs(taggedAreas) do
        if area:IsA("BasePart") then
            local size = area.Size
            local cf = area.CFrame
            
            for x = -size.X/2 + spacing, size.X/2 - spacing, spacing do
                for z = -size.Z/2 + spacing, size.Z/2 - spacing, spacing do
                    local localPos = Vector3.new(x, size.Y/2 + 0.5, z)
                    local worldPos = cf:PointToWorldSpace(localPos)
                    
                    local occupied = false
                    for _, placedPos in pairs(PlacedPositions) do
                        if (placedPos - worldPos).Magnitude < spacing then
                            occupied = true
                            break
                        end
                    end
                    
                    if not occupied then
                        table.insert(positions, worldPos)
                    end
                end
            end
        end
    end
    
    if #positions > 0 then
        DebugPrint("พบ Placeable จาก CollectionService:", #positions, "positions")
        return positions
    end
    
    -- ===== วิธีที่ 3: Fallback - หาจากตำแหน่งรอบๆ path =====
    local path = GetMapPath()
    if #path > 0 then
        for _, pathPos in pairs(path) do
            for offset = -10, 10, 5 do
                local pos1 = pathPos + Vector3.new(offset, 2, 0)
                local pos2 = pathPos + Vector3.new(0, 2, offset)
                
                -- เช็คว่าไม่อยู่บน path โดยตรง
                local onPath = false
                for _, p in pairs(path) do
                    if (p - pos1).Magnitude < 3 then onPath = true break end
                end
                if not onPath then table.insert(positions, pos1) end
                
                onPath = false
                for _, p in pairs(path) do
                    if (p - pos2).Magnitude < 3 then onPath = true break end
                end
                if not onPath then table.insert(positions, pos2) end
            end
        end
    end
    
    return positions
end

-- หาตำแหน่งวาง Income Unit (ที่ไหนก็ได้ ห่าง path เพื่อไม่บัง DPS)
-- ===== เหมือน AutoPlay_Smart: วางห่าง path 10-35 studs =====
local function GetIncomePosition()
    local path = GetMapPath()
    local positions = GetPlaceablePositions()
    local activeUnits = GetActiveUnits()
    
    if #positions == 0 then
        return nil
    end
    
    local bestPos = nil
    local bestScore = -math.huge
    local bestDist = 0
    
    -- ===== SETTINGS: Income ต้องห่าง path =====
    local MIN_DIST_FROM_PATH = 10  -- ขั้นต่ำห่าง path 10 studs
    local MAX_DIST_FROM_PATH = 40  -- สูงสุดห่าง path 40 studs
    local IDEAL_DIST_FROM_PATH = 20 -- ระยะในอุดมคติ 20 studs
    
    for _, pos in pairs(positions) do
        local score = 0
        
        -- 1. หาระยะจาก path ที่ใกล้ที่สุด
        local closestDist = math.huge
        
        if #path > 0 then
            for _, node in pairs(path) do
                local dist = (pos - node).Magnitude
                if dist < closestDist then
                    closestDist = dist
                end
            end
        else
            -- ถ้าไม่มี path ให้หาระยะจาก DPS Units แทน
            for _, unit in pairs(activeUnits) do
                if unit.Position and not IsIncomeUnit(unit.Name, unit.Data) then
                    local dist = (pos - unit.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                    end
                end
            end
            if closestDist == math.huge then
                closestDist = 100 -- ถ้าไม่มี unit ก็ให้ score สูง
            end
        end
        
        -- ===== SCORE: ต้องอยู่ในระยะที่กำหนด =====
        if closestDist < MIN_DIST_FROM_PATH then
            -- ใกล้ path เกินไป! ไม่ดีสำหรับ Income
            score = -1000
        elseif closestDist > MAX_DIST_FROM_PATH then
            -- ไกลเกินไป อาจวางไม่ได้
            score = -500
        else
            -- ===== ในระยะที่ดี: ยิ่งใกล้ IDEAL ยิ่งดี =====
            local distFromIdeal = math.abs(closestDist - IDEAL_DIST_FROM_PATH)
            score = 100 - distFromIdeal * 3  -- 100 ถ้า perfect, ลดลงตามระยะ
            
            -- Bonus ถ้าห่าง path มากๆ (ใน range)
            score = score + closestDist * 2
        end
        
        -- 2. ห่าง Unit อื่นที่วางไว้แล้ว (ลด score ถ้าใกล้เกินไป)
        for _, unit in pairs(activeUnits) do
            if unit.Position then
                local distToUnit = (pos - unit.Position).Magnitude
                if distToUnit < 5 then
                    score = score - 200 -- ใกล้เกินไป
                elseif distToUnit < 10 then
                    score = score - 50
                end
            end
        end
        
        -- 3. ห่างตำแหน่งที่เคยวาง Income อื่น
        for _, placedPos in pairs(PlacedPositions) do
            local distToPlaced = (pos - placedPos).Magnitude
            if distToPlaced < 6 then
                score = score - 150 -- Income ไม่ควรอยู่ติดกัน
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
            bestDist = closestDist
        end
    end
    
    if bestPos then
        DebugPrint(string.format("💰 Income Position: ห่าง path %.1f studs (ideal: %d)", bestDist, IDEAL_DIST_FROM_PATH))
    end
    
    return bestPos
end

local function GetBestPlacementPosition(unitRange, gamePhase)
    local path = GetMapPath()
    local positions = GetPlaceablePositions()
    gamePhase = gamePhase or "early" -- "early" หรือ "late"
    
    if #path == 0 then
        return nil
    end
    
    if #positions == 0 then
        return nil
    end
    
    local bestPos = nil
    local bestScore = -math.huge
    local activeUnits = GetActiveUnits()
    
    -- คำนวณ path sections
    local earlyEnd = math.floor(#path * 0.4) -- 0-40% = early
    local midStart = math.floor(#path * 0.3)
    local midEnd = math.floor(#path * 0.7) -- 30-70% = mid
    local lateStart = math.floor(#path * 0.6) -- 60-100% = late
    
    -- ===== NEW: หามุมโค้งของ path (ที่วางแล้วยิงได้ทั้ง 2 ทาง) =====
    local corners = {}
    for i = 2, #path - 1 do
        local prev = path[i-1]
        local curr = path[i]
        local next = path[i+1]
        
        local dir1 = Vector3.new(curr.X - prev.X, 0, curr.Z - prev.Z)
        local dir2 = Vector3.new(next.X - curr.X, 0, next.Z - curr.Z)
        
        if dir1.Magnitude > 0.1 and dir2.Magnitude > 0.1 then
            dir1 = dir1.Unit
            dir2 = dir2.Unit
            local dot = math.clamp(dir1.X * dir2.X + dir1.Z * dir2.Z, -1, 1)
            local angle = math.deg(math.acos(dot))
            
            if angle >= 30 then  -- มุมเกิน 30° = มุมโค้ง (ยิงได้ทั้ง 2 ทาง!)
                -- คำนวณทิศทางด้านนอกมุม
                local outward = -(dir1 + dir2)
                if outward.Magnitude > 0.1 then
                    outward = outward.Unit
                end
                
                table.insert(corners, {
                    Position = curr,
                    Index = i,
                    Angle = angle,
                    OutwardDir = outward,
                })
            end
        end
    end
    
    -- ===== NEW: หาทางขนาน (path 2 เส้นใกล้กัน) =====
    local parallelSpots = {}
    for i = 1, #path do
        for j = i + 3, #path do  -- ต้องห่างกันอย่างน้อย 3 nodes
            local dist = (path[i] - path[j]).Magnitude
            if dist <= unitRange * 0.8 and dist >= 5 then  -- ใกล้พอที่จะยิงทั้ง 2 เส้น
                -- หาจุดกลางระหว่าง 2 path
                local midPoint = (path[i] + path[j]) / 2
                table.insert(parallelSpots, {
                    Position = midPoint,
                    PathIndex1 = i,
                    PathIndex2 = j,
                    Distance = dist,
                })
            end
        end
    end
    
    DebugPrint(string.format("📐 พบมุมโค้ง: %d จุด | ทางขนาน: %d จุด", #corners, #parallelSpots))
    
    -- ===== PRE-CALCULATE: หาว่า path ส่วนไหนยังไม่มี Unit ครอบคลุม =====
    -- เพื่อกระจาย Unit ให้ตีโดนทุกทาง
    local pathCoverageByUnit = {} -- [pathIndex] = {unitGUID, ...}
    local uncoveredPathSegments = {} -- path indexes ที่ยังไม่มี unit ครอบคลุม
    
    for i = 1, #path do
        pathCoverageByUnit[i] = {}
        uncoveredPathSegments[i] = true -- assume uncovered first
    end
    
    -- วิเคราะห์ว่า Unit ที่วางแล้วครอบคลุม path ส่วนไหน
    for _, unit in pairs(activeUnits) do
        if unit.Position then
            local unitPos = unit.Position
            -- สมมติ unit range = 25 (หรือดึงจาก data ถ้ามี)
            local activeUnitRange = 25
            if unit.Data and unit.Data.Range then
                activeUnitRange = unit.Data.Range
            end
            
            for i, pathNode in ipairs(path) do
                local dist = (unitPos - pathNode).Magnitude
                if dist <= activeUnitRange then
                    table.insert(pathCoverageByUnit[i], unit.GUID or unit.Name)
                    uncoveredPathSegments[i] = false
                end
            end
        end
    end
    
    -- นับ path ที่ยังไม่มีใครครอบคลุม
    local uncoveredCount = 0
    local firstUncoveredIndex = nil
    for i, uncovered in pairs(uncoveredPathSegments) do
        if uncovered then
            uncoveredCount = uncoveredCount + 1
            if not firstUncoveredIndex or i < firstUncoveredIndex then
                firstUncoveredIndex = i
            end
        end
    end
    
    DebugPrint("📍 Path Coverage Analysis: Uncovered =", uncoveredCount, "/ Total =", #path)
    
    -- ===== คำนวณแบบอัจฉริยะเหมือนคนเล่น =====
    for _, pos in pairs(positions) do
        local score = 0
        
        -- หา node ที่ใกล้ที่สุดเพื่อดูว่าอยู่ส่วนไหนของ path
        local closestNodeIndex = 1
        local closestDist = math.huge
        for i, node in ipairs(path) do
            local dist = (pos - node).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestNodeIndex = i
            end
        end
        
        -- 1. เช็คว่าใกล้ path พอหรือไม่ (ต้องอยู่ในระยะยิง)
        if closestDist > unitRange then
            score = score - 1000 -- ไกลเกินไป
        else
            -- ใกล้ path แต่ไม่ติดเกินไป = ดี
            if closestDist >= 3 and closestDist <= unitRange * 0.6 then
                score = score + (unitRange - closestDist) * 3
            elseif closestDist < 3 then
                score = score + (unitRange - closestDist) * 0.5 -- ใกล้เกินไป
            else
                score = score + (unitRange - closestDist)
            end
        end
        
        -- ===== 2. PRIORITY: ครอบคลุม Path ที่ยังไม่มีใคร! =====
        -- นับว่าตำแหน่งนี้ครอบคลุม path ที่ยังไม่มี unit กี่ส่วน
        local newCoverageCount = 0
        local newCoverageBonus = 0
        for i, pathNode in ipairs(path) do
            local dist = (pos - pathNode).Magnitude
            if dist <= unitRange then
                if uncoveredPathSegments[i] then
                    newCoverageCount = newCoverageCount + 1
                    -- Bonus สูงมากถ้าครอบคลุม path ที่ยังว่าง!
                    newCoverageBonus = newCoverageBonus + 50
                else
                    -- ครอบคลุมซ้ำ = bonus น้อย (แต่ไม่ติดลบ)
                    newCoverageBonus = newCoverageBonus + 5
                end
            end
        end
        
        -- ถ้ามี path ที่ยังไม่มีใคร และตำแหน่งนี้ครอบคลุมได้ = สำคัญมาก!
        if uncoveredCount > 0 and newCoverageCount > 0 then
            score = score + newCoverageBonus * 2 -- Double bonus!
        else
            score = score + newCoverageBonus
        end
        
        -- ===== 2.5 NEW: BONUS มุมโค้ง (ยิงได้ทั้ง 2 ทาง!) =====
        for _, corner in ipairs(corners) do
            local distToCorner = (pos - corner.Position).Magnitude
            if distToCorner <= unitRange then
                -- HUGE Bonus ถ้าอยู่ในระยะยิงมุมโค้ง!
                local cornerBonus = corner.Angle * 3  -- มุมมากยิ่งดี
                score = score + cornerBonus
                
                -- Bonus พิเศษถ้าอยู่ด้านนอกมุม (ยิงได้ดีที่สุด)
                if corner.OutwardDir.Magnitude > 0.1 then
                    local dirToPos = (pos - corner.Position)
                    if dirToPos.Magnitude > 0.1 then
                        dirToPos = dirToPos.Unit
                        local alignment = dirToPos:Dot(corner.OutwardDir)
                        if alignment > 0.3 then
                            score = score + alignment * 100 -- อยู่ด้านนอกมุม = Perfect!
                        end
                    end
                end
            end
        end
        
        -- ===== 2.6 NEW: BONUS ทางขนาน (ยิงได้ทั้ง 2 เส้นพร้อมกัน!) =====
        for _, parallel in ipairs(parallelSpots) do
            local distToParallel = (pos - parallel.Position).Magnitude
            if distToParallel <= unitRange * 0.5 then
                -- ใกล้จุดกลางของทางขนาน = ยิงได้ทั้ง 2 เส้น!
                local parallelBonus = 150 - distToParallel * 2
                score = score + math.max(0, parallelBonus)
            end
        end
        
        -- 3. ให้ bonus ตาม game phase
        if gamePhase == "early" then
            -- Early game: เน้นวางต้นแมพ (node index ต่ำๆ)
            if closestNodeIndex <= earlyEnd then
                score = score + 50 -- Bonus วางต้นแมพ
            elseif closestNodeIndex <= midEnd then
                score = score + 20 -- Mid ก็โอเค
            else
                score = score - 30 -- ท้ายแมพลด score
            end
        elseif gamePhase == "late" then
            -- Late game: เน้นวางท้ายแมพ
            if closestNodeIndex >= lateStart then
                score = score + 50 -- Bonus วางท้ายแมพ
            elseif closestNodeIndex >= midStart then
                score = score + 20 -- Mid ก็โอเค
            else
                score = score - 20 -- ต้นแมพลด score (แต่ไม่มากเท่า)
            end
        elseif gamePhase == "spread" then
            -- ===== SPREAD MODE: กระจาย Units ให้ครอบคลุมทุกทาง =====
            -- ให้ bonus สูงมากถ้าอยู่ใกล้ path ที่ยังไม่มี unit
            if firstUncoveredIndex then
                local distToUncovered = math.abs(closestNodeIndex - firstUncoveredIndex)
                if distToUncovered <= 3 then
                    score = score + 200 -- ใกล้ส่วนที่ยังว่างมาก!
                elseif distToUncovered <= 6 then
                    score = score + 100
                end
            end
        end
        
        -- 4. ===== ADVANCED CIRCULAR RANGE ANALYSIS =====
        -- วิเคราะห์ว่า path ผ่านวงกลมของ unit ในมุมไหนบ้าง และผ่านนานแค่ไหน
        -- แบ่งวงกลมเป็น 24 ส่วน (ทุก 15 องศา) เพื่อความละเอียด
        local angleSegments = 24
        local coveredAngles = {}
        local angleHitCount = {} -- นับว่าแต่ละมุมมี path nodes กี่ตัว
        local nodesInRange = 0
        local totalPathCoverage = 0
        
        for i = 1, angleSegments do
            coveredAngles[i] = false
            angleHitCount[i] = 0
        end
        
        -- ===== คำนวณ Path Segments ที่อยู่ในวงกลม =====
        local pathSegmentsInCircle = 0
        local totalPathLengthInCircle = 0
        
        for i = 1, #path - 1 do
            local nodeA = path[i]
            local nodeB = path[i + 1]
            
            local distA = (pos - nodeA).Magnitude
            local distB = (pos - nodeB).Magnitude
            
            -- เช็คว่า segment นี้อยู่ในหรือผ่านวงกลมหรือไม่
            local aInRange = distA <= unitRange
            local bInRange = distB <= unitRange
            
            if aInRange or bInRange then
                pathSegmentsInCircle = pathSegmentsInCircle + 1
                
                -- คำนวณความยาว segment ที่อยู่ในวงกลม
                local segmentLength = (nodeB - nodeA).Magnitude
                if aInRange and bInRange then
                    totalPathLengthInCircle = totalPathLengthInCircle + segmentLength
                else
                    totalPathLengthInCircle = totalPathLengthInCircle + segmentLength * 0.5
                end
                
                -- หามุมของ segment
                local midPoint = (nodeA + nodeB) / 2
                local dx = midPoint.X - pos.X
                local dz = midPoint.Z - pos.Z
                local angle = math.atan2(dz, dx)
                if angle < 0 then angle = angle + (2 * math.pi) end
                
                local segmentIndex = math.floor(angle / (2 * math.pi / angleSegments)) + 1
                if segmentIndex > angleSegments then segmentIndex = angleSegments end
                
                coveredAngles[segmentIndex] = true
                angleHitCount[segmentIndex] = angleHitCount[segmentIndex] + 1
            end
        end
        
        -- วิเคราะห์ path nodes ที่อยู่ในระยะ
        for _, pathNode in pairs(path) do
            local dist = (pos - pathNode).Magnitude
            if dist <= unitRange then
                nodesInRange = nodesInRange + 1
                
                local dx = pathNode.X - pos.X
                local dz = pathNode.Z - pos.Z
                local angle = math.atan2(dz, dx)
                if angle < 0 then angle = angle + (2 * math.pi) end
                
                local segmentIndex = math.floor(angle / (2 * math.pi / angleSegments)) + 1
                if segmentIndex > angleSegments then segmentIndex = angleSegments end
                
                coveredAngles[segmentIndex] = true
                angleHitCount[segmentIndex] = angleHitCount[segmentIndex] + 1
                
                local rangeRatio = dist / unitRange
                if rangeRatio >= 0.3 and rangeRatio <= 0.8 then
                    totalPathCoverage = totalPathCoverage + 3
                elseif rangeRatio > 0.8 then
                    totalPathCoverage = totalPathCoverage + 1
                else
                    totalPathCoverage = totalPathCoverage + 2
                end
            end
        end
        
        -- นับจำนวนมุมที่ครอบคลุม
        local coveredAngleCount = 0
        local maxHitsInSingleAngle = 0
        for i = 1, angleSegments do
            if coveredAngles[i] then
                coveredAngleCount = coveredAngleCount + 1
            end
            if angleHitCount[i] > maxHitsInSingleAngle then
                maxHitsInSingleAngle = angleHitCount[i]
            end
        end
        
        -- ===== คำนวณ "Continuous Coverage" =====
        local maxContinuousAngles = 0
        local currentContinuous = 0
        for i = 1, angleSegments * 2 do
            local idx = ((i - 1) % angleSegments) + 1
            if coveredAngles[idx] then
                currentContinuous = currentContinuous + 1
                if currentContinuous > maxContinuousAngles then
                    maxContinuousAngles = currentContinuous
                end
            else
                currentContinuous = 0
            end
        end
        
        -- ===== SCORING =====
        if nodesInRange >= 3 then
            score = score + nodesInRange * 4
        end
        
        score = score + totalPathLengthInCircle * 3
        
        if coveredAngleCount >= 12 then
            score = score + coveredAngleCount * 10
        elseif coveredAngleCount >= 8 then
            score = score + coveredAngleCount * 7
        elseif coveredAngleCount >= 4 then
            score = score + coveredAngleCount * 4
        else
            score = score + coveredAngleCount * 2
        end
        
        if maxContinuousAngles >= 8 then
            score = score + 100
        elseif maxContinuousAngles >= 5 then
            score = score + 60
        elseif maxContinuousAngles >= 3 then
            score = score + 30
        end
        
        score = score + totalPathCoverage * 2
        
        -- ===== ANALYZE PATH ENTRY/EXIT =====
        local entryExitPoints = 0
        local wasInRange = false
        for i, pathNode in ipairs(path) do
            local dist = (pos - pathNode).Magnitude
            local isInRange = dist <= unitRange
            
            if isInRange ~= wasInRange then
                entryExitPoints = entryExitPoints + 1
                wasInRange = isInRange
            end
        end
        
        if entryExitPoints >= 6 then
            score = score + 120
        elseif entryExitPoints >= 4 then
            score = score + 80
        elseif entryExitPoints >= 2 then
            score = score + 40
        end
        
        -- 5. BONUS ถ้าใกล้ Unit ที่วางไว้แล้ว แต่ไม่ซ้อนกัน
        local hasNearbyUnit = false
        local tooClose = false
        for _, unit in pairs(activeUnits) do
            if unit.Position then
                local distToUnit = (pos - unit.Position).Magnitude
                if distToUnit < 5 then
                    tooClose = true
                    score = score - 100
                elseif distToUnit >= 5 and distToUnit <= 15 then
                    score = score + 60 -- ลดลงเพื่อให้กระจายมากขึ้น
                    hasNearbyUnit = true
                elseif distToUnit > 15 and distToUnit <= 25 then
                    score = score + 30
                    hasNearbyUnit = true
                end
            end
        end
        
        -- ถ้ามี units อยู่แล้ว และตำแหน่งนี้ไกล → ให้ bonus ถ้าครอบคลุม path ใหม่
        if not hasNearbyUnit and #activeUnits > 0 then
            if newCoverageCount > 0 then
                -- ครอบคลุม path ใหม่ แม้จะไกลจากกลุ่ม = ดี!
                score = score + 30
            else
                score = score - 30 -- ไกลและไม่ได้ครอบคลุมอะไรใหม่
            end
        end
        
        -- 5. ลด score ถ้าตำแหน่งนี้เคยวางแล้ว
        for _, placedPos in pairs(PlacedPositions) do
            local distToPlaced = (pos - placedPos).Magnitude
            if distToPlaced < 5 then
                score = score - 200 -- ตำแหน่งซ้ำลด score มาก
            elseif distToPlaced < 10 then
                score = score - 30
            end
        end
        
        -- 6. Bonus สำหรับทางโค้ง
        for i = 2, #path - 1 do
            local prev = path[i-1]
            local curr = path[i]
            local next = path[i+1]
            
            local dir1 = (curr - prev).Unit
            local dir2 = (next - curr).Unit
            local angle = math.acos(math.clamp(dir1:Dot(dir2), -1, 1))
            
            if angle > math.rad(30) then
                local distToCurve = (pos - curr).Magnitude
                if distToCurve < unitRange then
                    score = score + (unitRange - distToCurve) * 2
                end
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestPos = pos
        end
    end
    
    return bestPos
end

-- ===== UNIT ACTIONS =====
local function CanPlaceAtPosition(unitName, position)
    -- ใช้ PlacementValidationHandler ของเกมเพื่อเช็คว่าวางได้หรือไม่
    if PlacementValidationHandler and PlacementValidationHandler.CanFitUnit then
        local canPlace = false
        pcall(function()
            canPlace = PlacementValidationHandler:CanFitUnit({
                UnitName = unitName,
                UnitPosition = position + Vector3.new(0, 1, 0),
                Units = ClientUnitHandler and ClientUnitHandler._ActiveUnits or {}
            })
        end)
        return canPlace
    end
    return true -- ถ้าไม่มี validation handler ให้ลองวางเลย
end

local function GetValidPlacementPosition(unitName, preferredPosition)
    -- หาตำแหน่งที่วางได้จริง โดยใช้ PathMathHandler
    if PathMathHandler and PathMathHandler.GetClosestPathPointInRange then
        local closestPoint, closestNode = nil, nil
        pcall(function()
            closestPoint, closestNode = PathMathHandler:GetClosestPathPointInRange(
                preferredPosition, 
                10000, 
                function(node) return true end
            )
        end)
        if closestPoint then
            -- หาตำแหน่งข้างๆ path ที่วางได้
            local offsets = {
                Vector3.new(5, 0, 0),
                Vector3.new(-5, 0, 0),
                Vector3.new(0, 0, 5),
                Vector3.new(0, 0, -5),
                Vector3.new(7, 0, 0),
                Vector3.new(-7, 0, 0),
                Vector3.new(0, 0, 7),
                Vector3.new(0, 0, -7),
            }
            for _, offset in ipairs(offsets) do
                local testPos = closestPoint + offset
                if CanPlaceAtPosition(unitName, testPos) then
                    return testPos
                end
            end
        end
    end
    
    -- ถ้าไม่ได้ ลองใช้ตำแหน่งที่ให้มา
    if CanPlaceAtPosition(unitName, preferredPosition) then
        return preferredPosition
    end
    
    return nil
end

local function PlaceUnit(slot, position)
    if not position then
        return false
    end
    
    local hotbar = GetHotbarUnits()
    local unit = hotbar[slot]
    if not unit then
        return false
    end
    
    -- ===== เช็ค cooldown ก่อน =====
    if tick() - LastPlaceTime < Settings["Place Cooldown"] then
        return false
    end
    
    -- ===== เช็คเงินจริงจาก UI ก่อนวาง =====
    local actualYen = GetYen()
    local unitPrice = unit.Price or 0
    if unitPrice > 0 and actualYen < unitPrice then
        -- ไม่มีเงินพอ ไม่ทำอะไร รอเช็ครอบหน้า
        return false
    end
    
    -- หาตำแหน่งที่วางได้จริง
    local validPosition = GetValidPlacementPosition(unit.Name, position)
    if not validPosition then
        validPosition = position
    end
    
    -- ส่งคำสั่งวาง (ต้องส่ง: Name, ID, Position, Rotation)
    local success = false
    local unitID = unit.ID or (unit.Data and unit.Data.ID) or (unit.Data and unit.Data.Identifier) or slot
    
    local ok, err = pcall(function()
        UnitEvent:FireServer("Render", {
            unit.Name,      -- ชื่อ unit
            unitID,         -- ID ของ unit (ไม่ใช่ slot)
            validPosition,  -- ตำแหน่ง
            0               -- rotation
        })
    end)
    
    if ok then
        success = true
        table.insert(PlacedPositions, validPosition)
        LastPlaceTime = tick()
        -- อัพเดท CurrentYen จากค่าจริง - ราคาที่ใช้
        CurrentYen = actualYen - unitPrice
    end
    
    return success
end

local function UpgradeUnit(unitGUID)
    -- เช็ค cooldown ก่อน upgrade
    if tick() - LastUpgradeTime < 0.5 then
        return false
    end
    
    local args = {
        "Upgrade",
        unitGUID
    }
    
    local success = pcall(function()
        UnitEvent:FireServer(unpack(args))
    end)
    
    if success then
        LastUpgradeTime = tick()
    end
    
    return success
end

-- Sell cooldown tracking
local LastSellTime = 0

local function SellUnit(unitGUID)
    -- เช็ค cooldown ก่อน sell
    if tick() - LastSellTime < 0.5 then
        return false
    end
    
    print("[AutoPlay] 💰 SELL:", unitGUID)
    
    local args = {
        "Sell",
        unitGUID
    }
    
    local success = pcall(function()
        UnitEvent:FireServer(unpack(args))
    end)
    
    if success then
        LastSellTime = tick()
    end
    
    return success
end

local function GetUnitUpgradeLevel(unitGUID)
    local upgradeInterface = PlayerGui:FindFirstChild("UpgradeInterfaces")
    if upgradeInterface then
        local unitUI = upgradeInterface:FindFirstChild(unitGUID)
        if unitUI and unitUI:FindFirstChild("UpgradeLevels") then
            local count = 0
            for _, child in pairs(unitUI.UpgradeLevels:GetChildren()) do
                if child:IsA("Frame") or child:IsA("ImageLabel") then
                    count = count + 1
                end
            end
            return count
        end
    end
    return 1
end

local function GetUpgradeableUnits()
    local units = GetActiveUnits()
    local upgradeable = {}
    
    for _, unit in pairs(units) do
        local level = GetUnitUpgradeLevel(unit.GUID)
        if level < Settings["Max Upgrade Level"] then
            -- สร้าง Data object ที่มี CurrentUpgrade
            local unitData = unit.Data or {}
            unitData.CurrentUpgrade = level -- ใส่ level ที่ได้จาก UI!
            
            table.insert(upgradeable, {
                GUID = unit.GUID,
                Name = unit.Name,
                Level = level,
                Position = unit.Position,
                Data = unitData,
                Income = unit.Income or 0
            })
        end
    end
    
    -- Sort ตาม priority
    if Settings["Upgrade Priority"] == "Oldest" then
        -- Already in order
    elseif Settings["Upgrade Priority"] == "Newest" then
        local reversed = {}
        for i = #upgradeable, 1, -1 do
            table.insert(reversed, upgradeable[i])
        end
        upgradeable = reversed
    elseif Settings["Upgrade Priority"] == "Cheapest" then
        table.sort(upgradeable, function(a, b)
            return a.Level < b.Level
        end)
    elseif Settings["Upgrade Priority"] == "MostExpensive" then
        table.sort(upgradeable, function(a, b)
            return a.Level > b.Level
        end)
    end
    
    return upgradeable
end

-- ===== GET UPGRADE COST (from AutoPlay_Smart) =====
local function GetUpgradeCost(unit)
    if not unit then return math.huge end
    
    local data = unit.Data
    if not data then return math.huge end
    
    -- หา current level
    local currentLevel = 0
    if unit.CurrentUpgrade then
        currentLevel = unit.CurrentUpgrade
    elseif unit.Level then
        currentLevel = unit.Level
    elseif data.CurrentUpgrade then
        currentLevel = data.CurrentUpgrade
    elseif data.Data and data.Data.CurrentUpgrade then
        currentLevel = data.Data.CurrentUpgrade
    end
    
    -- หา upgrades table
    local upgrades = nil
    if data.Upgrades then
        upgrades = data.Upgrades
    elseif data.Data and data.Data.Upgrades then
        upgrades = data.Data.Upgrades
    end
    
    if upgrades then
        -- ลองหา upgrade ถัดไป
        local nextUpgrade = upgrades[currentLevel + 1]
        if nextUpgrade then
            if type(nextUpgrade) == "table" then
                return nextUpgrade.Cost or nextUpgrade.Price or math.huge
            elseif type(nextUpgrade) == "number" then
                return nextUpgrade
            end
        end
    end
    
    -- ลองหาจาก UpgradeCost field
    if data.UpgradeCost then
        if type(data.UpgradeCost) == "table" then
            return data.UpgradeCost[currentLevel + 1] or math.huge
        elseif type(data.UpgradeCost) == "number" then
            return data.UpgradeCost
        end
    end
    
    -- Fallback: ประมาณราคาจาก level (base * 1.5^level)
    local basePrice = data.Price or 100
    local estimatedCost = math.floor(basePrice * math.pow(1.5, currentLevel))
    return estimatedCost
end

-- ===== GET STRONGEST UNIT (from AutoPlay_Smart) =====
local function GetStrongestUnit(units)
    local best = nil
    local bestScore = -math.huge
    
    for _, unit in pairs(units) do
        local score = 0
        local data = unit.Data and (unit.Data.Data or unit.Data) or {}
        
        -- Score based on Damage
        score = score + (data.Damage or 0) * 10
        
        -- Score based on current upgrade level
        local level = unit.CurrentUpgrade or unit.Level or 0
        score = score + level * 50
        
        -- Bonus for DPS units
        if data.UnitType ~= "Farm" and not data.IsIncome then
            score = score + 100
        end
        
        if score > bestScore then
            bestScore = score
            best = unit
        end
    end
    
    return best
end

-- ===== AUTO SKILL SYSTEM =====
-- Remote Events สำหรับ Auto Skill
local AutoAbilityEvent = nil
local CastHollowsephSpell = nil
local UseAbilityEvent = nil
pcall(function()
    AutoAbilityEvent = Networking:WaitForChild("ClientListeners", 5)
    if AutoAbilityEvent then
        AutoAbilityEvent = AutoAbilityEvent:WaitForChild("Units", 5)
        if AutoAbilityEvent then
            AutoAbilityEvent = AutoAbilityEvent:FindFirstChild("AutoAbilityEvent")
        end
    end
    
    -- หา UseAbility Event
    local unitsFolder = Networking:FindFirstChild("Units")
    if unitsFolder then
        UseAbilityEvent = unitsFolder:FindFirstChild("UseAbility")
    end
    
    -- Hollowseph Spell Event
    local units9 = Networking:FindFirstChild("Units")
    if units9 then
        local update9 = units9:FindFirstChild("Update 9.0")
        if update9 then
            CastHollowsephSpell = update9:FindFirstChild("CastHollowsephSpell")
        end
    end
end)

-- ===== WAVE DETECTION =====
local function GetCurrentWave()
    -- อัพเดทจาก UI ก่อน
    UpdateWaveFromUI()
    
    -- ใช้ค่าจาก UI Tracker
    if TrackedWave > 0 then
        return TrackedWave
    end
    
    local wave = 0
    
    pcall(function()
        -- วิธี 1: หาจาก HUD.Map.WavesAmount โดยตรง
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local HUD = playerGui:FindFirstChild("HUD")
            if HUD then
                local Map = HUD:FindFirstChild("Map")
                if Map then
                    local WavesAmount = Map:FindFirstChild("WavesAmount")
                    if WavesAmount and WavesAmount:IsA("TextLabel") then
                        local text = WavesAmount.Text or ""
                        local cur, _ = text:match("(%d+)%s*/%s*(%d+)")
                        if cur then
                            wave = tonumber(cur) or 0
                        end
                    end
                end
            end
        end
        
        -- วิธี 2: หาจาก ClientGameStateHandler
        if wave == 0 and ClientGameStateHandler then
            local state = nil
            pcall(function()
                state = ClientGameStateHandler:GetCurrentState()
            end)
            if state and state.Wave then
                wave = state.Wave
            end
        end
        
        -- วิธี 3: หาจาก descendants ถ้ายังไม่เจอ
        if wave == 0 then
            local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextLabel") then
                        local name = gui.Name:lower()
                        local text = gui.Text or ""
                        -- หาจากชื่อที่มี wave
                        if name:find("wave") then
                            local waveNum = text:match("(%d+)")
                            if waveNum then
                                wave = tonumber(waveNum) or 0
                                break
                            end
                        end
                        -- หาจาก text pattern เช่น "Wave 5/15"
                        local waveMatch = text:match("[Ww]ave%s*(%d+)")
                        if waveMatch then
                            wave = tonumber(waveMatch) or 0
                            break
                        end
                    end
                end
            end
        end
        
        -- วิธี 4: หาจาก ReplicatedStorage
        if wave == 0 then
            local gameData = ReplicatedStorage:FindFirstChild("GameData") or 
                            ReplicatedStorage:FindFirstChild("MatchData") or
                            ReplicatedStorage:FindFirstChild("GameState")
            if gameData then
                local waveValue = gameData:FindFirstChild("Wave") or gameData:FindFirstChild("CurrentWave")
                if waveValue then
                    if waveValue:IsA("IntValue") or waveValue:IsA("NumberValue") then
                        wave = waveValue.Value
                    elseif waveValue:IsA("StringValue") then
                        wave = tonumber(waveValue.Value) or 0
                    end
                end
            end
        end
    end)
    
    return wave
end

local function GetTotalWaves()
    -- อัพเดทจาก UI ก่อน
    UpdateWaveFromUI()
    
    -- ใช้ค่าจาก UI Tracker
    if TrackedTotalWaves > 0 then
        return TrackedTotalWaves
    end
    
    local total = 0
    
    pcall(function()
        -- วิธี 1: หาจาก HUD.Map.WavesAmount โดยตรง
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local HUD = playerGui:FindFirstChild("HUD")
            if HUD then
                local Map = HUD:FindFirstChild("Map")
                if Map then
                    local WavesAmount = Map:FindFirstChild("WavesAmount")
                    if WavesAmount and WavesAmount:IsA("TextLabel") then
                        local text = WavesAmount.Text or ""
                        local _, totalWaves = text:match("(%d+)%s*/%s*(%d+)")
                        if totalWaves then
                            total = tonumber(totalWaves) or 0
                        end
                    end
                end
            end
        end
        
        -- วิธี 2: หาจาก ClientGameStateHandler
        if total == 0 and ClientGameStateHandler then
            local state = nil
            pcall(function()
                state = ClientGameStateHandler:GetCurrentState()
            end)
            if state and state.TotalWaves and state.TotalWaves < 100 then
                total = state.TotalWaves
            elseif state and state.MaxWave and state.MaxWave < 100 then
                total = state.MaxWave
            end
        end
    end)
    
    -- ถ้าหาจาก UI/State ได้ ให้เก็บไว้
    if total > 0 then
        DetectedMaxWave = total
        TrackedTotalWaves = total
    end
    
    -- ถ้าหาไม่ได้ ให้ใช้ค่าที่เคย detect ได้
    if total == 0 and DetectedMaxWave > 0 then
        total = DetectedMaxWave
    end
    
    return total
end

-- อัพเดท Highest Wave ที่เคยเห็น (เรียกทุก loop)
local function UpdateHighestWaveSeen()
    local currentWave = GetCurrentWave()
    if currentWave > HighestWaveSeen then
        HighestWaveSeen = currentWave
        WaveStableCount = 0 -- reset เพราะ wave เพิ่ม
    elseif currentWave == HighestWaveSeen and currentWave > 0 then
        -- Wave ไม่เพิ่ม นับว่า stable
        if currentWave ~= LastWaveForStableCheck then
            LastWaveForStableCheck = currentWave
            WaveStableCount = 0
        end
        WaveStableCount = WaveStableCount + 1
    end
end

-- เช็คว่าเป็น Final Wave จริงหรือไม่
local function IsFinalWave()
    -- อัพเดทจาก UI ก่อน
    UpdateWaveFromUI()
    
    local currentWave = GetCurrentWave()
    local totalWaves = GetTotalWaves()
    
    -- ต้องรู้ totalWaves และ currentWave ทั้งคู่
    if totalWaves <= 0 or currentWave <= 0 then
        return false, nil
    end
    
    -- ต้องเป็น wave สุดท้ายเท่านั้น (currentWave == totalWaves)
    if currentWave >= totalWaves then
        return true, "UI: " .. currentWave .. "/" .. totalWaves
    end
    
    return false, nil
end

-- ===== SMART SKILL ANALYSIS =====
local SkillsEnabled = {} -- เก็บว่า Unit ไหนเปิด Skill อะไรไว้แล้ว
local LastSkillUseTime = {} -- เก็บเวลาที่ใช้ Skill ล่าสุด
local SkillCooldowns = {} -- เก็บ cooldown ของแต่ละ skill

-- ===== DetectBoss (ต้องประกาศก่อน AnalyzeSkillSituation) =====
local function DetectBoss()
    local enemies = GetEnemies()
    for _, enemy in pairs(enemies) do
        -- เช็คจากชื่อหรือ attribute
        if enemy.Name then
            local name = enemy.Name:lower()
            if name:find("boss") or name:find("elite") or name:find("champion") or name:find("mini") then
                return true
            end
        end
        -- เช็คจาก MaxHealth (Boss มักมี HP สูง)
        if enemy.MaxHealth and enemy.MaxHealth > 5000 then
            return true
        end
    end
    return false
end

-- ===== วิเคราะห์สถานการณ์สำหรับใช้ Skill =====
local function AnalyzeSkillSituation()
    local wave = GetCurrentWave()
    local totalWaves = GetTotalWaves()
    local enemies = GetEnemies()
    local enemyCount = #enemies
    local bossDetected = DetectBoss()
    
    -- คำนวณ threat level
    local threatLevel = 0
    local reason = ""
    
    -- 1. Boss = threat สูงสุด
    if bossDetected then
        threatLevel = 5
        reason = "🔥 BOSS DETECTED!"
    end
    
    -- 2. Enemy Progress สูง = อันตราย
    if EnemyProgressMax > 0.7 then
        threatLevel = math.max(threatLevel, 4)
        reason = "⚠️ Enemy near base (" .. math.floor(EnemyProgressMax * 100) .. "%)"
    elseif EnemyProgressMax > 0.5 then
        threatLevel = math.max(threatLevel, 3)
        reason = "⚡ Enemy advancing (" .. math.floor(EnemyProgressMax * 100) .. "%)"
    end
    
    -- 3. Enemy เยอะมาก = Swarm
    if enemyCount >= 10 then
        threatLevel = math.max(threatLevel, 4)
        reason = "🌊 SWARM! (" .. enemyCount .. " enemies)"
    elseif enemyCount >= 5 then
        threatLevel = math.max(threatLevel, 2)
        reason = "Multiple enemies (" .. enemyCount .. ")"
    end
    
    -- 4. Wave ใกล้จบ = ใช้หมด
    if totalWaves > 0 and (totalWaves - wave) <= 2 then
        threatLevel = math.max(threatLevel, 4)
        reason = "🏁 Final waves!"
    end
    
    -- 5. Boss wave ใกล้ๆ (wave 10, 20, 30 หรือ สุดท้าย)
    local nearBoss = false
    local bossWaves = {10, 20, 30, totalWaves}
    for _, bw in ipairs(bossWaves) do
        if wave >= bw - 1 and wave <= bw then
            nearBoss = true
            if threatLevel < 3 then
                reason = "⏳ Boss wave soon (wave " .. bw .. ")"
            end
            break
        end
    end
    
    -- ถ้าไม่มี threat เลย = ใช้ไปเลย (ไม่ต้องเก็บ)
    if threatLevel == 0 and enemyCount > 0 then
        threatLevel = 1
        reason = "⚡ Normal combat (wave " .. wave .. ")"
    end
    
    return {
        Wave = wave,
        TotalWaves = totalWaves,
        EnemyCount = enemyCount,
        BossDetected = bossDetected,
        NearBoss = nearBoss,
        ThreatLevel = threatLevel,
        Reason = reason,
        Progress = EnemyProgressMax
    }
end

local function ShouldUseSkill(unit, abilityName, situation)
    -- ===== ระบบ Auto Skill ที่คิดก่อนใช้ =====
    -- วิเคราะห์จาก: จำนวน enemy, boss, สถานการณ์อันตราย, wave ใกล้จบ
    
    local currentWave = situation.Wave or 0
    local totalWaves = situation.TotalWaves or 0
    local enemyCount = situation.EnemyCount or 0
    local bossDetected = situation.BossDetected
    local threatLevel = situation.ThreatLevel or 0
    local progress = situation.Progress or 0
    
    -- ===== กรณีใช้ทันที =====
    
    -- 1. Boss มาแล้ว = ใช้ทันที!
    if bossDetected then
        return true, "🔥 BOSS DETECTED! USE NOW!"
    end
    
    -- 2. Enemy ใกล้ฐาน (progress > 70%) = ใช้ทันที!
    if progress > 0.7 then
        return true, "⚠️ EMERGENCY! Enemy at " .. math.floor(progress * 100) .. "%"
    end
    
    -- 3. Threat level สูง (>= 4) = ใช้ทันที!
    if threatLevel >= 4 then
        return true, "🔥 HIGH THREAT! Level " .. threatLevel
    end
    
    -- 4. Wave สุดท้าย = ใช้หมด!
    if totalWaves > 0 and currentWave >= totalWaves then
        return true, "🏁 FINAL WAVE! USE ALL!"
    end
    
    -- 5. Wave ใกล้จบ (เหลือ 2 wave) = ใช้ได้
    if totalWaves > 0 and (totalWaves - currentWave) <= 2 then
        return true, "🏁 Near final wave!"
    end
    
    -- ===== กรณีรอก่อน (ประหยัด) =====
    
    -- 1. ไม่มี Enemy เลย = ไม่ต้องใช้
    if enemyCount == 0 then
        return false, "⏳ No enemies"
    end
    
    -- 2. Threat ต่ำ + ไม่ใช่ wave สุดท้าย = ประหยัดไว้
    if threatLevel <= 1 and enemyCount < 5 then
        return false, "⏳ Low threat, saving skill"
    end
    
    -- 3. ใกล้ Boss wave (wave 10, 20, 30) แต่ยังไม่เจอ Boss = เก็บไว้
    local nearBossWave = false
    local bossWaves = {10, 20, 30, totalWaves}
    for _, bw in ipairs(bossWaves) do
        if bw > 0 and currentWave >= bw - 2 and currentWave < bw then
            nearBossWave = true
            break
        end
    end
    
    if nearBossWave and threatLevel < 3 then
        return false, "⏳ Saving for Boss wave"
    end
    
    -- ===== กรณีปกติ = ใช้ได้ถ้า enemy >= 3 หรือ threat >= 2 =====
    if enemyCount >= 3 or threatLevel >= 2 then
        return true, "⚔️ Multiple enemies (" .. enemyCount .. ")"
    end
    
    -- Default: ประหยัดไว้
    return false, "⏳ Saving skill"
end

local function EnableAutoSkill(unitGUID, abilityName)
    if not AutoAbilityEvent then
        DebugPrint("❌ ไม่พบ AutoAbilityEvent")
        return false
    end
    
    local success = false
    pcall(function()
        AutoAbilityEvent:FireServer(unitGUID, abilityName, true)
        DebugPrint("✅ เปิด Auto Skill:", abilityName, "สำหรับ", unitGUID)
        success = true
    end)
    
    return success
end

local function UseHollowsephSpell(unitGUID, spellName)
    if not CastHollowsephSpell then
        DebugPrint("❌ ไม่พบ CastHollowsephSpell")
        return false
    end
    
    local success = false
    pcall(function()
        CastHollowsephSpell:FireServer(unitGUID, spellName)
        DebugPrint("✅ ใช้ Spell:", spellName, "สำหรับ", unitGUID)
        success = true
    end)
    
    return success
end

-- ===== ใช้ Skill ผ่าน GUI โดยตรง =====
local function UseSkillViaGUI(unitGUID, abilityButton)
    -- คลิกปุ่ม Ability โดยตรง
    local success = false
    pcall(function()
        -- หา Activate button
        local activateBtn = abilityButton:FindFirstChild("Activate") or abilityButton:FindFirstChild("Use")
        if activateBtn then
            -- Fire click event
            if activateBtn:IsA("TextButton") or activateBtn:IsA("ImageButton") then
                -- ลอง fire MouseButton1Click
                for _, conn in pairs(getconnections(activateBtn.MouseButton1Click)) do
                    conn:Fire()
                    success = true
                end
            end
        end
    end)
    return success
end

local function CheckAndEnableAutoSkills()
    local units = GetActiveUnits()
    local situation = AnalyzeSkillSituation()
    
    print("[AutoPlay] 🎯 Skill Analysis:")
    print("  Wave:", situation.Wave, "/", situation.TotalWaves)
    print("  Enemies:", situation.EnemyCount)
    print("  Boss:", situation.BossDetected)
    print("  Threat:", situation.ThreatLevel, "- " .. situation.Reason)
    print("  Progress:", math.floor(situation.Progress * 100) .. "%")
    
    local skillsUsed = 0
    
    for _, unit in pairs(units) do
        local unitGUID = unit.GUID
        local unitKey = unitGUID or unit.Name or "unknown"
        
        if not SkillsEnabled[unitKey] then
            SkillsEnabled[unitKey] = {}
        end
        
        -- ===== หา Unit Passive Button ใน GUI =====
        local upgradeInterface = PlayerGui:FindFirstChild("UpgradeInterfaces")
        if upgradeInterface then
            -- หา UI ของ Unit นี้
            for _, unitUI in pairs(upgradeInterface:GetChildren()) do
                if unitUI:IsA("Frame") or unitUI:IsA("CanvasGroup") then
                    -- หาปุ่ม Unit Passive
                    local passiveBtn = nil
                    for _, desc in pairs(unitUI:GetDescendants()) do
                        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                            local btnText = ""
                            local textLabel = desc:FindFirstChild("Text") or desc:FindFirstChildOfClass("TextLabel")
                            if textLabel then
                                btnText = textLabel.Text or ""
                            elseif desc:IsA("TextButton") then
                                btnText = desc.Text or ""
                            end
                            
                            if btnText:lower():find("passive") or btnText:lower():find("ability") or 
                               btnText:lower():find("skill") or btnText:lower():find("spell") then
                                passiveBtn = desc
                                break
                            end
                        end
                    end
                    
                    if passiveBtn then
                        local abilityName = passiveBtn.Name or "Passive"
                        local shouldUse, reason = ShouldUseSkill(unit, abilityName, situation)
                        
                        if shouldUse and not SkillsEnabled[unitKey][abilityName] then
                            print("[AutoPlay] ⚡ Using Skill:", abilityName, "for", unit.Name or unitKey)
                            print("  Reason:", reason)
                            
                            -- ลองเปิด Auto ก่อน
                            if EnableAutoSkill(unitGUID, abilityName) then
                                SkillsEnabled[unitKey][abilityName] = true
                                skillsUsed = skillsUsed + 1
                            end
                        end
                    end
                end
            end
        end
        
        -- ===== ลองเปิด Auto ผ่าน AutoAbilityEvent โดยตรง =====
        -- เปิดทุก ability ที่หาเจอใน Unit Data
        if unit.Data then
            -- ลองชื่อ ability ทั่วไป
            local commonAbilities = {"Passive", "Ability", "Skill", "Spell", "Special", "Ultimate", "Active"}
            for _, abilityName in ipairs(commonAbilities) do
                if not SkillsEnabled[unitKey][abilityName] then
                    local shouldUse, reason = ShouldUseSkill(unit, abilityName, situation)
                    if shouldUse then
                        if EnableAutoSkill(unitGUID, abilityName) then
                            SkillsEnabled[unitKey][abilityName] = true
                            skillsUsed = skillsUsed + 1
                            print("[AutoPlay] ⚡ Enabled:", abilityName, "| Reason:", reason)
                        end
                    end
                end
            end
            
            -- ถ้ามี Abilities ใน Data
            if unit.Data.Abilities then
                for abilityName, _ in pairs(unit.Data.Abilities) do
                    if not SkillsEnabled[unitKey][abilityName] then
                        local shouldUse, reason = ShouldUseSkill(unit, abilityName, situation)
                        if shouldUse then
                            if EnableAutoSkill(unitGUID, abilityName) then
                                SkillsEnabled[unitKey][abilityName] = true
                                skillsUsed = skillsUsed + 1
                                print("[AutoPlay] ⚡ Enabled:", abilityName, "| Reason:", reason)
                            end
                        end
                    end
                end
            end
        end
    end
    
    if skillsUsed > 0 then
        print("[AutoPlay] ✅ Enabled", skillsUsed, "skills this check")
    end
end

-- ===== RESET SKILLS TRACKING ON NEW MATCH =====
local function ResetSkillsTracking()
    SkillsEnabled = {}
    LastSkillUseTime = {}
    print("[AutoPlay] Skills tracking reset")
end

-- ===== OUTSIDE ENEMY SYSTEM =====
-- ===== SMART ENEMY OUTSIDE HANDLER =====
-- วิเคราะห์ 6 ช่อง (ไม่รวมตัวเงิน) เลือก DMG กลางๆ จากช่อง 4-6
-- ถ้ามี Stun เหลือช่องสลับ, ขายตัวเงินตอน Max Wave

local OutsideEnemySlotRotation = {} -- เก็บ slots ที่ใช้ได้สำหรับ Outside Enemy
local OutsideEnemyCurrentSlot = nil -- slot ปัจจุบันที่ใช้
local OutsideEnemyLastSwapTime = 0
local OutsideEnemyHandling = false -- กำลังจัดการ Enemy Outside อยู่
local IncomeUnitsSoldAtMaxWave = false -- ขายตัวเงินแล้วหรือยัง

-- ===== BOSS HUNTER SYSTEM (workspace.Entities) =====
local BossHunterActive = false -- กำลังล่า Boss อยู่
local BossHunterTarget = nil -- Boss ที่กำลังโจมตี
local BossHunterUnits = {} -- Units ที่วางไว้ตี Boss {GUID, PlacedAt}
local BossHunterLastCheck = 0 -- เวลาล่าสุดที่ check

-- ตรวจสอบว่า Unit มี Stun หรือไม่ (จากชื่อหรือ Data)
local function UnitHasStun(unitName, unitData)
    local stunKeywords = {"stun", "freeze", "slow", "snare", "root", "paralyze", "hold"}
    local nameLower = unitName:lower()
    
    for _, keyword in ipairs(stunKeywords) do
        if nameLower:find(keyword) then
            return true
        end
    end
    
    -- เช็คจาก Data ถ้ามี
    if unitData then
        if unitData.Abilities then
            for _, ability in pairs(unitData.Abilities) do
                local abilityName = (ability.Name or ""):lower()
                for _, keyword in ipairs(stunKeywords) do
                    if abilityName:find(keyword) then
                        return true
                    end
                end
            end
        end
    end
    
    return false
end

-- ตรวจสอบว่าเป็น Income Unit หรือไม่
local function IsIncomeUnit(unitName, unitData)
    if unitData then
        if unitData.UnitType == "Farm" then return true end
        if unitData.IsIncome then return true end
    end
    
    local nameLower = (unitName or ""):lower()
    -- ===== เพิ่ม keyword สำหรับ Income ของเกม AV =====
    local incomePatterns = {
        "income", "farm", "money", "bank", "gold", "coin", "passive", "sprint", "enlist",
        "takaroda", "takaro", "merchant", "trader", "yen", "cash"
    }
    for _, pattern in ipairs(incomePatterns) do
        if nameLower:find(pattern) then
            return true
        end
    end
    
    return false
end

-- วิเคราะห์ 6 ช่องเพื่อเลือก Unit สำหรับ Enemy Outside
local function AnalyzeHotbarForOutsideEnemy()
    local hotbar = GetHotbarUnits()
    local availableSlots = {}
    local stunSlots = {}
    local incomeSlots = {}
    local dpsSlots = {}
    
    -- วิเคราะห์ทุกช่อง
    for slot = 1, 6 do
        local unit = hotbar[slot]
        if unit then
            local isIncome = IsIncomeUnit(unit.Name, unit.Data)
            local hasStun = UnitHasStun(unit.Name, unit.Data)
            
            if isIncome then
                table.insert(incomeSlots, slot)
            elseif hasStun then
                table.insert(stunSlots, slot)
            else
                table.insert(dpsSlots, slot)
            end
        end
    end
    
    -- ===== กฎการเลือก Slot =====
    -- 1. ช่อง 1-3 = มักเป็น: ตัวเงิน 2 ตัว + DMG แรงสุด 1 ตัว
    -- 2. ช่อง 4-6 = DMG กลางๆ ใช้ตี Enemy Outside ได้
    -- 3. ถ้ามี Stun = เหลือช่อง 1 ช่องไว้สลับ
    
    -- ลำดับความสำคัญ: ช่อง 4, 5, 6 (ไม่รวม Income และไม่รวม Slot ที่ DMG สูงสุด)
    local preferredSlots = {4, 5, 6}
    
    for _, slot in ipairs(preferredSlots) do
        local unit = hotbar[slot]
        if unit then
            local isIncome = IsIncomeUnit(unit.Name, unit.Data)
            if not isIncome then
                table.insert(availableSlots, slot)
            end
        end
    end
    
    -- ถ้าไม่มีจาก 4-6 ก็ลองหาจาก 1-3 (ยกเว้น Income และ DMG สูงสุด)
    if #availableSlots == 0 then
        for slot = 1, 3 do
            local unit = hotbar[slot]
            if unit then
                local isIncome = IsIncomeUnit(unit.Name, unit.Data)
                if not isIncome then
                    -- ไม่เอาช่องแรกที่เป็น DPS (น่าจะ DMG สูงสุด)
                    local isFirstDPS = (#dpsSlots > 0 and dpsSlots[1] == slot)
                    if not isFirstDPS then
                        table.insert(availableSlots, slot)
                    end
                end
            end
        end
    end
    
    -- ถ้ามี Stun units เหลือช่อง 1 ช่องไว้สลับ
    local hasStunUnits = #stunSlots > 0
    local rotationSlots = {}
    
    if hasStunUnits and #availableSlots >= 2 then
        -- สลับระหว่าง 2 ช่อง
        rotationSlots = {availableSlots[1], availableSlots[2]}
    elseif #availableSlots >= 1 then
        rotationSlots = {availableSlots[1]}
    end
    
    return rotationSlots, incomeSlots, stunSlots, dpsSlots
end

local function IsEnemyOutsideRange()
    local enemies = GetEnemies()
    local units = GetActiveUnits()
    
    for _, enemy in pairs(enemies) do
        local inRange = false
        for _, unit in pairs(units) do
            if unit.Position and enemy.Position then
                local dist = (enemy.Position - unit.Position).Magnitude
                if dist < 50 then -- ระยะตี default
                    inRange = true
                    break
                end
            end
        end
        if not inRange then
            return true, enemy
        end
    end
    return false, nil
end

-- ===== SMART HANDLE OUTSIDE ENEMY =====
local function HandleOutsideEnemy()
    if not Settings["Auto Handle Outside Enemy"] then return end
    
    local hasOutside, enemy = IsEnemyOutsideRange()
    local currentTime = tick()
    
    if hasOutside and enemy then
        -- เจอ Enemy นอกพื้นที่!
        OutsideEnemyHandling = true
        HasOutsideEnemyThisMap = true
        
        -- ===== ขายยูนิตช่อง 5 และ 6 ก่อน =====
        if not OutsideEnemyUnit then
            local hotbar = GetHotbarUnits()
            local activeUnits = GetActiveUnits()
            
            -- หายูนิตที่วางอยู่ในช่อง 5, 6 แล้วขาย
            for _, unit in pairs(activeUnits) do
                -- ข้ามตัวเงิน ไม่ขาย
                local isIncome = IsIncomeUnit(unit.Name, unit.Data)
                if not isIncome then
                    -- ขายเพื่อเอาเงินไปวางใหม่
                    local shouldSell = false
                    
                    -- เช็คว่าเป็นยูนิตที่ไม่อยู่ใกล้ enemy
                    if unit.Position and enemy.Position then
                        local dist = (unit.Position - enemy.Position).Magnitude
                        if dist > 30 then -- ไกลกว่า 30 studs
                            shouldSell = true
                        end
                    end
                    
                    if shouldSell then
                        print("[AutoPlay] 🔄 ขายยูนิต", unit.Name, "เพื่อเอาเงินวางใกล้ Enemy นอกพื้นที่")
                        SellUnit(unit.GUID)
                    end
                end
            end
        end
        
        -- ===== วางยูนิตใต้ Enemy โดยตรง =====
        if not OutsideEnemyUnit then
            local hotbar = GetHotbarUnits()
            
            -- หา slot ที่มียูนิตและซื้อได้
            local slotToUse = nil
            local yen = GetYen()
            
            -- ลองช่อง 5, 6 ก่อน แล้วค่อยช่องอื่น
            local prioritySlots = {5, 6, 4, 3, 2, 1}
            for _, slot in ipairs(prioritySlots) do
                local unit = hotbar[slot]
                if unit and unit.Price and yen >= unit.Price then
                    -- ข้าม Income
                    local isIncome = unit.IsIncome or IsIncomeSlot(slot)
                    if not isIncome then
                        slotToUse = slot
                        break
                    end
                end
            end
            
            if slotToUse then
                -- วางใต้ enemy โดยตรง (ไม่สน path)
                local pos = enemy.Position + Vector3.new(0, 0, 0)
                
                print("[AutoPlay] ⚔️ วางยูนิตช่อง", slotToUse, "ใต้ Enemy:", enemy.Name, "ตำแหน่ง:", pos)
                
                local placed = PlaceUnit(slotToUse, pos)
                if placed then
                    OutsideEnemyUnit = {
                        PlacedAt = currentTime,
                        TargetEnemy = enemy.Name,
                        Slot = slotToUse,
                        Position = pos
                    }
                end
            end
        end
    else
        -- ===== Enemy นอกพื้นที่หมดแล้ว → ขายยูนิตที่วางไว้ =====
        if OutsideEnemyUnit and Settings["Sell After Kill"] then
            local activeUnits = GetActiveUnits()
            
            -- หายูนิตที่วางไว้ตรงตำแหน่งนั้นแล้วขาย
            for _, unit in pairs(activeUnits) do
                if unit.Position and OutsideEnemyUnit.Position then
                    local dist = (unit.Position - OutsideEnemyUnit.Position).Magnitude
                    if dist < 5 then
                        -- ข้ามตัวเงิน ไม่ขาย
                        local isIncome = IsIncomeUnit(unit.Name, unit.Data)
                        if not isIncome then
                            print("[AutoPlay] 💰 ขายยูนิตที่วางไว้ตี Enemy นอกพื้นที่:", unit.Name)
                            SellUnit(unit.GUID)
                        end
                    end
                end
            end
            
            OutsideEnemyUnit = nil
            OutsideEnemyHandling = false
            return
        end
        
        OutsideEnemyHandling = false
    end
end

-- ===== BOSS HUNTER SYSTEM (workspace.Entities) =====
-- ตรวจหา Boss พิเศษใน workspace.Entities เช่น God Statue
-- God Statue = หุ่นเสาที่ต้องตีก่อน ไม่งั้นตี Boss ไม่ได้!
local BossHunterDebugPrinted = false
local function FindEntityBoss()
    local success, entities = pcall(function()
        return workspace:FindFirstChild("Entities")
    end)
    
    if not success or not entities then
        return nil
    end
    
    -- Debug: แสดง Entities ทั้งหมด (ครั้งแรกเท่านั้น)
    if not BossHunterDebugPrinted then
        BossHunterDebugPrinted = true
        print("[BossHunter] 📋 Entities ในแมพ:")
        for _, ent in pairs(entities:GetChildren()) do
            print("  -", ent.Name, "| Class:", ent.ClassName)
        end
    end
    
    -- ===== Keywords สำหรับ Entity ที่ต้องตี =====
    local targetKeywords = {
        "god", "statue", "godstatue", "god_statue",
        "pillar", "crystal", "core", "totem", "idol",
        "shrine", "obelisk", "monolith", "seal"
    }
    
    for _, entity in pairs(entities:GetChildren()) do
        -- เช็คว่าเป็น Model ที่มี Humanoid หรือ HealthBar
        if entity:IsA("Model") then
            local humanoid = entity:FindFirstChildOfClass("Humanoid")
            local healthBar = entity:FindFirstChild("HealthBar") or entity:FindFirstChild("Health")
            local billboardGui = entity:FindFirstChildOfClass("BillboardGui")
            local primaryPart = entity.PrimaryPart or entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChildWhichIsA("BasePart")
            
            -- ดึงข้อมูล health จาก Humanoid หรือ Attribute
            local currentHealth = 0
            local maxHealth = 1
            
            if humanoid then
                currentHealth = humanoid.Health
                maxHealth = humanoid.MaxHealth
            else
                -- ลองหาจาก Attribute
                currentHealth = entity:GetAttribute("Health") or entity:GetAttribute("CurrentHealth") or 0
                maxHealth = entity:GetAttribute("MaxHealth") or 1
            end
            
            -- หาจาก BillboardGui (health bar อยู่ใน BillboardGui)
            if currentHealth == 0 and billboardGui then
                for _, child in pairs(billboardGui:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        local text = child.Text or ""
                        -- รูปแบบ: "2,352 | 2/4" หรือ "2352/5000"
                        local hp = text:match("^([%d,]+)")
                        if hp then
                            currentHealth = tonumber((hp:gsub(",", ""))) or 0
                            maxHealth = currentHealth + 1000 -- ประมาณ
                        end
                        local hp2, maxHp2 = text:match("([%d,]+)%s*/%s*([%d,]+)")
                        if hp2 and maxHp2 then
                            currentHealth = tonumber((hp2:gsub(",", ""))) or 0
                            maxHealth = tonumber((maxHp2:gsub(",", ""))) or 1
                        end
                    end
                end
            end
            
            -- หาจาก UI HealthBar
            if currentHealth == 0 and healthBar then
                for _, child in pairs(healthBar:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        local text = child.Text or ""
                        local hp, maxHp = text:match("([%d,]+)%s*/%s*([%d,]+)")
                        if hp and maxHp then
                            currentHealth = tonumber((hp:gsub(",", ""))) or 0
                            maxHealth = tonumber((maxHp:gsub(",", ""))) or 1
                            break
                        end
                    end
                end
            end
            
            if (humanoid or healthBar or currentHealth > 0) and primaryPart then
                -- เช็คว่าเป็น target ที่ต้องตีหรือเปล่า
                local entityNameLower = entity.Name:lower()
                local isTarget = false
                
                for _, keyword in ipairs(targetKeywords) do
                    if entityNameLower:find(keyword) then
                        isTarget = true
                        break
                    end
                end
                
                -- ถ้ามี health > 0 และเป็น target (หรือมี health bar/BillboardGui แสดงว่าต้องตี)
                if currentHealth > 0 and (isTarget or healthBar or billboardGui) then
                    print("[BossHunter] 🎯 พบ Entity:", entity.Name, "HP:", currentHealth, "/", maxHealth)
                    return {
                        Model = entity,
                        Name = entity.Name,
                        Position = primaryPart.Position,
                        Health = currentHealth,
                        MaxHealth = maxHealth,
                        GUID = entity.Name -- ใช้ชื่อเป็น identifier
                    }
                end
                
                -- ถ้าไม่มี health แต่มี primaryPart และเป็น target → ลองส่งกลับมา (อาจต้องตี)
                if isTarget and primaryPart and currentHealth == 0 then
                    -- ลองเช็คจาก Children ทั้งหมดหา health
                    for _, desc in pairs(entity:GetDescendants()) do
                        if desc:IsA("NumberValue") and (desc.Name:lower():find("health") or desc.Name:lower():find("hp")) then
                            currentHealth = desc.Value or 0
                            if currentHealth > 0 then
                                print("[BossHunter] 🎯 พบ Entity (จาก NumberValue):", entity.Name, "HP:", currentHealth)
                                return {
                                    Model = entity,
                                    Name = entity.Name,
                                    Position = primaryPart.Position,
                                    Health = currentHealth,
                                    MaxHealth = currentHealth + 1000,
                                    GUID = entity.Name
                                }
                            end
                        end
                    end
                    
                    -- ถ้ายังไม่เจอ health แต่เป็น target → ส่งกลับด้วย health = 9999 (assume ว่ามี HP)
                    print("[BossHunter] 🎯 พบ Entity (ไม่รู้ HP แต่เป็น target):", entity.Name)
                    return {
                        Model = entity,
                        Name = entity.Name,
                        Position = primaryPart.Position,
                        Health = 9999,
                        MaxHealth = 9999,
                        GUID = entity.Name
                    }
                end
            end
        end
    end
    
    return nil
end

-- หาตำแหน่งรอบๆ Boss สำหรับวาง Unit
local function GetBossPlacementPositions(bossPosition, count)
    local positions = {}
    local radius = 10 -- ระยะห่างจาก Boss
    
    for i = 1, count do
        local angle = (i - 1) * (2 * math.pi / count)
        local x = bossPosition.X + math.cos(angle) * radius
        local z = bossPosition.Z + math.sin(angle) * radius
        local y = bossPosition.Y + 2
        
        table.insert(positions, Vector3.new(x, y, z))
    end
    
    return positions
end

-- Handle Boss Hunter
local function HandleBossHunter()
    if not Settings["Boss Hunter Enabled"] then return end
    
    local currentTime = tick()
    
    -- Check ทุก 1 วินาที
    if currentTime - BossHunterLastCheck < 1 then return end
    BossHunterLastCheck = currentTime
    
    local boss = FindEntityBoss()
    
    if boss then
        -- มี Boss!
        if not BossHunterActive then
            BossHunterActive = true
            BossHunterTarget = boss
            BossHunterUnits = {}
            DebugPrint("🎯 พบ Boss:", boss.Name, "HP:", math.floor(boss.Health), "/", math.floor(boss.MaxHealth))
            print("[BossHunter] 🎯 พบ Boss:", boss.Name, "- กำลังวาง", Settings["Boss Hunter Units"], "ตัวโจมตี!")
        end
        
        -- วาง Unit ถ้ายังไม่ครบ
        local unitsNeeded = Settings["Boss Hunter Units"]
        local unitsPlaced = #BossHunterUnits
        
        if unitsPlaced < unitsNeeded then
            local positions = GetBossPlacementPositions(boss.Position, unitsNeeded)
            
            -- เลือก slot ที่จะใช้ (DPS สูงสุด จากช่อง 4-6)
            local slotsToUse = {4, 5, 6, 1, 2, 3} -- ลำดับความสำคัญ
            
            for i = unitsPlaced + 1, unitsNeeded do
                local pos = positions[i]
                if pos then
                    -- ลองวางแต่ละ slot
                    for _, slot in ipairs(slotsToUse) do
                        local placed = PlaceUnit(slot, pos)
                        if placed then
                            table.insert(BossHunterUnits, {
                                Slot = slot,
                                PlacedAt = currentTime,
                                Position = pos
                            })
                            DebugPrint("⚔️ วาง Unit ช่อง", slot, "ตี Boss ตัวที่", #BossHunterUnits)
                            break
                        end
                    end
                end
                task.wait(0.5) -- รอระหว่างวาง
            end
        end
    else
        -- ไม่มี Boss แล้ว
        if BossHunterActive then
            -- Boss ตายแล้ว! ขาย Units
            if Settings["Boss Hunter Sell After Kill"] and #BossHunterUnits > 0 then
                DebugPrint("✅ Boss ตายแล้ว! กำลังขาย", #BossHunterUnits, "Units...")
                print("[BossHunter] ✅ Boss ถูกกำจัดแล้ว! กำลังขาย Units...")
                
                task.wait(1) -- รอให้ reward เข้า
                
                -- ขาย Units ที่วางไว้ (ห้ามขายตัวเงิน!)
                local units = GetActiveUnits()
                local soldCount = 0
                
                for _, bossUnit in ipairs(BossHunterUnits) do
                    -- หา Unit ที่ใกล้ตำแหน่งที่วางไว้
                    for _, unit in pairs(units) do
                        if unit.Position then
                            local distance = (unit.Position - bossUnit.Position).Magnitude
                            if distance < 5 then
                                -- ⚠️ ห้ามขายตัวเงิน!
                                local isIncome = IsIncomeUnit(unit.Name, unit.Data)
                                if isIncome then
                                    DebugPrint("⚠️ ไม่ขายตัวเงิน (BossHunter):", unit.Name)
                                else
                                    SellUnit(unit.GUID)
                                    soldCount = soldCount + 1
                                    DebugPrint("💰 ขาย Unit:", unit.Name)
                                end
                                break
                            end
                        end
                    end
                end
                
                print("[BossHunter] 💰 ขายแล้ว", soldCount, "ตัว")
            end
            
            -- Reset
            BossHunterActive = false
            BossHunterTarget = nil
            BossHunterUnits = {}
        end
    end
end

-- ===== AUTO SELL INCOME AT MAX WAVE =====
-- ขายตัวเงินเฉพาะ Wave สุดท้ายจริงๆ (ตรวจจับ auto จาก UI + game state)
local function CheckAndSellIncomeAtMaxWave()
    if IncomeUnitsSoldAtMaxWave then return end -- ขายไปแล้ว
    
    -- อัพเดทจาก UI
    UpdateWaveFromUI()
    
    local currentWave = GetCurrentWave()
    local totalWaves = GetTotalWaves()
    
    -- ต้องรู้ทั้ง currentWave และ totalWaves
    if totalWaves <= 0 or currentWave <= 0 then
        return
    end
    
    -- ===== ขายได้เฉพาะตอน currentWave == totalWaves เท่านั้น =====
    if currentWave < totalWaves then
        return
    end
    
    print("[AutoPlay] 🏁 Wave สุดท้าย! (" .. currentWave .. "/" .. totalWaves .. ")")
    print("[AutoPlay] 🏁 กำลังขายตัวเงิน...")
    
    local units = GetActiveUnits()
    local incomeUnitsSold = 0
    
    for _, unit in pairs(units) do
        local isIncome = IsIncomeUnit(unit.Name, unit.Data)
        if isIncome then
            SellUnit(unit.GUID)
            incomeUnitsSold = incomeUnitsSold + 1
            print("[AutoPlay] 💰 ขายตัวเงิน:", unit.Name)
        end
    end
    
    IncomeUnitsSoldAtMaxWave = true
    
    if incomeUnitsSold > 0 then
        print("[AutoPlay] 🏁 ขายตัวเงินรวม", incomeUnitsSold, "ตัว เพื่อเอาเงินไปวาง/อัพเกรด")
    end
end

-- ===== AUTO RECOVER AFTER EMERGENCY =====
local function AutoRecoverAfterEmergency()
    -- ถ้าเพิ่งจัดการ Enemy Outside เสร็จ ให้วิเคราะห์ว่าควรทำอะไรต่อ
    if not OutsideEnemyHandling and OutsideEnemyUnit == nil and HasOutsideEnemyThisMap then
        local yen = GetYen()
        local units = GetActiveUnits()
        local hotbar = GetHotbarUnits()
        
        -- คำนวณว่าควรวางตัวใหม่หรืออัพเกรด
        local cheapestUnitPrice = math.huge
        for slot = 1, 6 do
            local unit = hotbar[slot]
            if unit and unit.Price then
                if unit.Price < cheapestUnitPrice then
                    cheapestUnitPrice = unit.Price
                end
            end
        end
        
        -- นับว่ามี Unit กี่ตัวในแมพ
        local unitCount = 0
        for _ in pairs(units) do
            unitCount = unitCount + 1
        end
        
        -- ===== วิเคราะห์สถานการณ์ =====
        -- ถ้ามีเงินพอวาง และ Unit น้อย → วางตัวใหม่
        -- ถ้า Unit เยอะพอแล้ว → อัพเกรด
        
        if yen >= cheapestUnitPrice and unitCount < 10 then
            DebugPrint("🔄 หลัง Emergency: มีเงินพอ ไปวางตัวใหม่")
            -- Main loop จะจัดการวางให้
        elseif unitCount >= 3 then
            DebugPrint("🔄 หลัง Emergency: มี Unit พอแล้ว ไปอัพเกรด")
            -- Main loop จะจัดการอัพเกรดให้
        end
    end
end

-- ===== AUTO START / VOTE SKIP SYSTEM =====
local function AutoVoteSkip()
    if not Settings["Auto Vote Skip"] then return end
    
    local currentTime = tick()
    if currentTime - LastVoteSkipTime < 2 then return end -- Cooldown 2 วินาที
    
    -- วิธี 1: ใช้ SkipWaveEvent
    if SkipWaveEvent then
        pcall(function()
            SkipWaveEvent:FireServer("Skip")
            LastVoteSkipTime = currentTime
            DebugPrint("🚀 Vote Skip via SkipWaveEvent!")
        end)
    end
end

-- ===== AUTO START GAME =====
local function TryStartGame()
    if not Settings["Auto Start"] then return false end
    
    local success = false
    print("[AutoPlay] 🎮 TryStartGame called!")
    
    -- ===== วิธี 1: ใช้ SkipWaveEvent (วิธีหลัก) =====
    pcall(function()
        local SkipEvent = ReplicatedStorage:WaitForChild("Networking", 5):WaitForChild("SkipWaveEvent", 5)
        if SkipEvent then
            SkipEvent:FireServer("Skip")
            print("[AutoPlay] 🎮 Start via SkipWaveEvent:FireServer('Skip')!")
            success = true
        end
    end)
    
    if success then
        return true
    end
    
    -- ===== วิธี 2: หา Start/Ready Button ในทุก GUI =====
    pcall(function()
        local guisToSearch = {
            PlayerGui:FindFirstChild("LobbyHUD"),
            PlayerGui:FindFirstChild("Lobby"),
            PlayerGui:FindFirstChild("MainHUD"),
            PlayerGui:FindFirstChild("HUD"),
            PlayerGui:FindFirstChild("MainMenu"),
            PlayerGui:FindFirstChild("Menu"),
            PlayerGui:FindFirstChild("Game"),
            PlayerGui:FindFirstChild("GameHUD")
        }
        
        for _, gui in pairs(guisToSearch) do
            if gui and not success then
                for _, desc in pairs(gui:GetDescendants()) do
                    if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and not success then
                        local name = desc.Name:lower()
                        local text = ""
                        if desc:IsA("TextButton") then
                            text = (desc.Text or ""):lower()
                        end
                        
                        -- หาปุ่ม Start/Ready/Begin/Play
                        local isStartButton = name:find("start") or name:find("ready") or name:find("begin") or name:find("play")
                        local isStartText = text:find("start") or text:find("ready") or text:find("begin") or text:find("play")
                        
                        if (isStartButton or isStartText) and desc.Visible then
                            print("[AutoPlay] 🎮 พบ Start Button:", desc:GetFullName())
                            
                            -- ลอง click หลายวิธี
                            local clicked = false
                            
                            -- วิธี 1: ใช้ getconnections (สำหรับ exploits)
                            pcall(function()
                                if getconnections then
                                    for _, conn in pairs(getconnections(desc.MouseButton1Click)) do
                                        conn:Fire()
                                        clicked = true
                                    end
                                    for _, conn in pairs(getconnections(desc.Activated)) do
                                        conn:Fire()
                                        clicked = true
                                    end
                                end
                            end)
                            
                            -- วิธี 2: VirtualInputManager
                            pcall(function()
                                if not clicked then
                                    local vim = game:GetService("VirtualInputManager")
                                    local pos = desc.AbsolutePosition
                                    local size = desc.AbsoluteSize
                                    local centerX = pos.X + size.X / 2
                                    local centerY = pos.Y + size.Y / 2
                                    vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                                    task.wait(0.05)
                                    vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                                    clicked = true
                                end
                            end)
                            
                            -- วิธี 3: Fire events ตรงๆ
                            pcall(function()
                                if desc.MouseButton1Click then
                                    desc.MouseButton1Click:Fire()
                                end
                            end)
                            
                            pcall(function()
                                if desc.Activated then
                                    desc.Activated:Fire()
                                end
                            end)
                            
                            success = true
                            print("[AutoPlay] ✅ Clicked Start Button:", desc.Name)
                            break
                        end
                    end
                end
            end
        end
    end)
    
    -- ===== วิธี 3: ใช้ StartMatchEvent =====
    if not success and StartMatchEvent then
        pcall(function()
            StartMatchEvent:FireServer()
            print("[AutoPlay] 🎮 Start via StartMatchEvent!")
            success = true
        end)
    end
    
    -- ===== วิธี 3: ใช้ ReadyEvent =====
    if not success and ReadyEvent then
        pcall(function()
            ReadyEvent:FireServer(true)
            print("[AutoPlay] 🎮 Ready via ReadyEvent!")
            success = true
        end)
    end
    
    -- ===== วิธี 4: หา Remote Event อื่นๆ ที่เกี่ยวกับ Start =====
    if not success then
        pcall(function()
            local Networking = ReplicatedStorage:FindFirstChild("Networking")
            if Networking then
                for _, event in pairs(Networking:GetDescendants()) do
                    if event:IsA("RemoteEvent") then
                        local eventName = event.Name:lower()
                        if eventName:find("start") or eventName:find("ready") or eventName:find("begin") then
                            print("[AutoPlay] 🎮 Found potential start event:", event.Name)
                            event:FireServer()
                            success = true
                            break
                        end
                    end
                end
            end
        end)
    end
    
    if success then
        print("[AutoPlay] ✅ Game start initiated!")
    else
        print("[AutoPlay] ⚠️ Could not find way to start game")
    end
    
    return success
end

local function InitAutoStart()
    if not Settings["Auto Start"] then return end
    
    DebugPrint("🚀 Initializing Auto Start...")
    DebugPrint("  SkipWaveEvent:", SkipWaveEvent and "Found" or "Not found")
    DebugPrint("  StartMatchEvent:", StartMatchEvent and "Found" or "Not found")
    DebugPrint("  ReadyEvent:", ReadyEvent and "Found" or "Not found")
    
    -- รับ Event จาก SkipWaveEvent
    if SkipWaveEvent then
        -- บอก server ว่าเราโหลดเสร็จแล้ว
        pcall(function()
            SkipWaveEvent:FireServer("Loaded")
            DebugPrint("✅ ส่ง Loaded ไปยัง SkipWaveEvent")
        end)
        
        SkipWaveEvent.OnClientEvent:Connect(function(action, data)
            if action == "Show" then
                -- มี Vote Skip popup แสดง
                SkipWaveActive = true
                DebugPrint("🚀 Skip Wave popup แสดง")
                
                -- ===== ก่อน Vote Skip ต้อง Equip Charm ก่อน! =====
                if Settings["Auto Equip Charm"] and not MatchStarted then
                    DebugPrint("💎 Equip Charms ก่อน Vote Skip...")
                    HollowsephData = GetHollowsephDataFromServer()
                    if HollowsephData then
                        AutoEquipCharms()
                        task.wait(1) -- รอให้ Charm equip เสร็จ
                    end
                end
                
                -- แล้วค่อย Vote Skip
                task.wait(0.5)
                AutoVoteSkip()
            elseif action == "Update" then
                -- Update จำนวนคนที่ vote
                if SkipWaveActive then
                    DebugPrint("📊 Vote Update:", data and data.SkippedPlayers or "?", "/", data and data.MaxPlayers or "?")
                end
            elseif action == "Close" then
                -- ปิด Vote Skip popup
                SkipWaveActive = false
                DebugPrint("✅ Skip Wave เสร็จสิ้น")
            end
        end)
    end
    
    -- Loop เพื่อ Auto Start และ Equip Charm เมื่ออยู่ใน Lobby
    task.spawn(function()
        local lastCharmEquipAttempt = 0
        
        while Settings["Auto Start"] do
            task.wait(3) -- เช็คทุก 3 วินาที
            
            -- เช็คว่ายังไม่ได้เริ่มเกม
            if not MatchStarted and not MatchEnded then
                local currentTime = tick()
                
                -- ===== STEP 1: Equip Charm ก่อน (ทุก 10 วินาที) =====
                local charmEquipped = false
                if Settings["Auto Equip Charm"] and currentTime - lastCharmEquipAttempt > 10 then
                    lastCharmEquipAttempt = currentTime
                    print("[AutoPlay] 💎 STEP 1: Checking and equipping Charms before Start...")
                    DebugPrint("💎 เช็คและ Equip Charms...")
                    
                    HollowsephData = GetHollowsephDataFromServer()
                    if HollowsephData then
                        -- คำนวณ usedSlots จาก equipped charms จริง
                        local usedSlots = 0
                        local equippedCharms = HollowsephData.EquippedCharms or {}
                        for charmId, _ in pairs(equippedCharms) do
                            local charmData = CharmData[charmId]
                            usedSlots = usedSlots + (charmData and charmData.SlotCost or 1)
                        end
                        local maxSlots = HollowsephData.MaxCharmSlots or HollowsephData.MaxNotches or Settings["Max Charm Slots"]
                        
                        print("[AutoPlay] 💎 Current Charm slots:", usedSlots, "/", maxSlots)
                        
                        if usedSlots < maxSlots then
                            print("[AutoPlay] 💎 Equipping charms now...")
                            AutoEquipCharms()
                            charmEquipped = true
                            print("[AutoPlay] 💎 Waiting 2 seconds for charm equip to complete...")
                            task.wait(2) -- รอให้ equip เสร็จก่อนไป STEP 2
                        else
                            print("[AutoPlay] 💎 Charm slots full:", usedSlots, "/", maxSlots)
                            DebugPrint("💎 Charm slots เต็มแล้ว:", usedSlots, "/", maxSlots)
                        end
                    end
                end
                
                -- ===== STEP 2: ลอง Start Game =====
                print("[AutoPlay] 🎮 STEP 2: Trying to start game...")
                TryStartGame()
            end
        end
    end)
    
    DebugPrint("✅ Auto Start/Vote Skip initialized")
end

-- ===== AUTO EQUIP CHARM SYSTEM (Hollowseph) =====
GetHollowsephDataFromServer = function()
    if not GetHollowsephData then
        print("[AutoPlay] ERROR: GetHollowsephData is nil!")
        DebugPrint("❌ ไม่พบ GetHollowsephData event")
        return nil
    end
    
    local data = nil
    local success = false
    
    -- วิธี 1: ใช้ InvokeServer ถ้าเป็น RemoteFunction
    if GetHollowsephData:IsA("RemoteFunction") then
        pcall(function()
            data = GetHollowsephData:InvokeServer()
            success = true
        end)
        if success and data then
            print("[AutoPlay] ✅ Got charm data via InvokeServer")
            return data
        end
    end
    
    -- วิธี 2: ใช้ FireServer + Wait พร้อม timeout
    pcall(function()
        GetHollowsephData:FireServer()
        
        -- รอ response พร้อม timeout 3 วินาที
        local startTime = tick()
        local connection
        local received = false
        
        connection = GetHollowsephData.OnClientEvent:Connect(function(receivedData)
            data = receivedData
            received = true
            if connection then
                connection:Disconnect()
            end
        end)
        
        -- รอจนกว่าจะได้รับหรือ timeout
        while not received and (tick() - startTime) < 3 do
            task.wait(0.1)
        end
        
        if not received and connection then
            connection:Disconnect()
        end
        
        success = received
    end)
    
    if success and data then
        print("[AutoPlay] ✅ Got charm data via FireServer+Wait")
        return data
    end
    
    -- วิธี 3: หาจาก HollowsephDataChanged event
    if HollowsephDataChanged then
        pcall(function()
            local connection
            local received = false
            local startTime = tick()
            
            connection = HollowsephDataChanged.OnClientEvent:Connect(function(receivedData)
                data = receivedData
                received = true
                if connection then
                    connection:Disconnect()
                end
            end)
            
            -- รอ 2 วินาที
            while not received and (tick() - startTime) < 2 do
                task.wait(0.1)
            end
            
            if not received and connection then
                connection:Disconnect()
            end
            
            success = received
        end)
        
        if success and data then
            print("[AutoPlay] ✅ Got charm data via HollowsephDataChanged")
            return data
        end
    end
    
    -- วิธี 4: สร้าง mock data ถ้าหาไม่เจอ (เพื่อให้ระบบทำงานต่อได้)
    print("[AutoPlay] ⚠️ Creating mock charm data for testing...")
    data = {
        AvailableCharms = {
            ["HonedNail"] = true,
            ["NailmastersWill"] = true,
            ["SigilOfReach"] = true,
            ["ShamanRelic"] = true,
            ["SigilOfFocus"] = true,
            ["VoidGivenClaw"] = true,
            ["BarbsOfSpite"] = true,
            ["FuryOfTheForsaken"] = true
        },
        EquippedCharms = {},
        MaxCharmSlots = Settings["Max Charm Slots"],
        MaxNotches = Settings["Max Charm Slots"]
    }
    
    return data
end

local function EquipCharm(charmId)
    print("[AutoPlay] EquipCharm called for:", charmId)
    
    if not EquipHollowsephCharm then
        print("[AutoPlay] ERROR: EquipHollowsephCharm event is nil!")
        DebugPrint("❌ ไม่พบ EquipHollowsephCharm event")
        return false
    end
    
    local currentTime = tick()
    if currentTime - LastCharmEquipTime < 0.3 then 
        print("[AutoPlay] Cooldown - waiting...")
        task.wait(0.3)
    end
    
    local success = false
    local errorMsg = nil
    local ok, err = pcall(function()
        print("[AutoPlay] Firing EquipHollowsephCharm:FireServer(", charmId, ")")
        EquipHollowsephCharm:FireServer(charmId)
        LastCharmEquipTime = tick()
        success = true
    end)
    
    if not ok then
        print("[AutoPlay] ERROR equipping charm:", err)
        errorMsg = err
    else
        print("[AutoPlay] ✅ Charm equip request sent:", charmId)
        DebugPrint("✅ Equip Charm:", charmId)
    end
    
    return success
end

local function UnequipCharm(charmId)
    print("[AutoPlay] UnequipCharm called for:", charmId)
    
    if not UnequipHollowsephCharm then
        print("[AutoPlay] ERROR: UnequipHollowsephCharm event is nil!")
        DebugPrint("❌ ไม่พบ UnequipHollowsephCharm event")
        return false
    end
    
    local success = false
    local ok, err = pcall(function()
        print("[AutoPlay] Firing UnequipHollowsephCharm:FireServer(", charmId, ")")
        UnequipHollowsephCharm:FireServer(charmId)
        success = true
    end)
    
    if not ok then
        print("[AutoPlay] ERROR unequipping charm:", err)
    else
        print("[AutoPlay] ✅ Charm unequip request sent:", charmId)
        DebugPrint("🔄 Unequip Charm:", charmId)
    end
    
    return success
end

-- Unequip ทุก Charm แล้ววิเคราะห์ใหม่
local function UnequipAllCharmsAndReanalyze()
    print("[AutoPlay] ====== UNEQUIP ALL & REANALYZE ======")
    DebugPrint("🔄 Unequip ทุก Charm เพื่อวิเคราะห์ใหม่...")
    
    -- ดึงข้อมูลใหม่
    print("[AutoPlay] Getting current charm data...")
    HollowsephData = GetHollowsephDataFromServer()
    if not HollowsephData then
        print("[AutoPlay] ERROR: Cannot get charm data!")
        DebugPrint("❌ ไม่สามารถดึงข้อมูล Charm")
        return
    end
    
    -- Unequip ทุกตัวที่มี
    if HollowsephData.EquippedCharms then
        local count = 0
        for charmId, _ in pairs(HollowsephData.EquippedCharms) do
            count = count + 1
        end
        print("[AutoPlay] Found", count, "equipped charms to unequip")
        
        for charmId, _ in pairs(HollowsephData.EquippedCharms) do
            print("[AutoPlay] Unequipping:", charmId)
            UnequipCharm(charmId)
            task.wait(0.3)
        end
    else
        print("[AutoPlay] No equipped charms found")
    end
    
    -- รอให้ server อัพเดท
    print("[AutoPlay] Waiting for server to update...")
    task.wait(1)
    
    -- ดึงข้อมูลใหม่และ Equip ตามการวิเคราะห์
    print("[AutoPlay] Getting fresh charm data for re-analysis...")
    HollowsephData = GetHollowsephDataFromServer()
    print("[AutoPlay] Calling AutoEquipCharms with fresh analysis...")
    AutoEquipCharms()
    print("[AutoPlay] ====== REANALYZE COMPLETE ======")
end

AutoEquipCharms = function()
    if not Settings["Auto Equip Charm"] then return end
    
    -- เช็คว่า Match เริ่มหรือยัง (ถ้าเริ่มแล้ว equip ไม่ได้)
    if GameHandler and GameHandler.IsMatchStarted then
        DebugPrint("⚠️ Match เริ่มแล้ว - ไม่สามารถ Equip Charm")
        return
    end
    
    -- ดึงข้อมูล Charm ปัจจุบัน (ดึงใหม่ทุกครั้ง)
    print("[AutoPlay] Getting fresh charm data...")
    HollowsephData = GetHollowsephDataFromServer()
    
    if not HollowsephData then
        print("[AutoPlay] ERROR: Cannot get charm data!")
        DebugPrint("❌ ไม่สามารถดึงข้อมูล Charm")
        return
    end
    
    local availableCharms = HollowsephData.AvailableCharms or {}
    local equippedCharms = HollowsephData.EquippedCharms or {}
    
    -- ===== คำนวณ slots ที่ใช้ไปจาก equipped charms จริง =====
    local usedSlots = 0
    for charmId, _ in pairs(equippedCharms) do
        local charmData = CharmData[charmId]
        if charmData then
            usedSlots = usedSlots + charmData.SlotCost
        else
            usedSlots = usedSlots + 1 -- default 1 slot
        end
    end
    
    -- ===== ดึง max slots จาก server หรือคำนวณจาก available =====
    local maxSlots = HollowsephData.MaxCharmSlots or HollowsephData.MaxNotches or HollowsephData.Notches or 0
    
    -- ถ้า server ไม่ส่ง max slots มา ให้ลองหาจาก player data
    if maxSlots == 0 then
        pcall(function()
            local playerData = ReplicatedStorage:FindFirstChild("PlayerData")
            if playerData then
                local myData = playerData:FindFirstChild(plr.Name) or playerData:FindFirstChild(tostring(plr.UserId))
                if myData then
                    local charmsData = myData:FindFirstChild("Charms") or myData:FindFirstChild("Hollowseph")
                    if charmsData then
                        local maxNotches = charmsData:FindFirstChild("MaxNotches") or charmsData:FindFirstChild("Notches")
                        if maxNotches then
                            maxSlots = maxNotches.Value
                        end
                    end
                end
            end
        end)
    end
    
    -- ถ้ายังไม่ได้ ใช้ค่า Settings
    if maxSlots == 0 then
        maxSlots = Settings["Max Charm Slots"]
    end
    
    print("[AutoPlay] 💎 Charm Slots:", usedSlots, "/", maxSlots)
    print("[AutoPlay] 💎 Equipped Charms:")
    for charmId, _ in pairs(equippedCharms) do
        print("  -", charmId)
    end
    print("[AutoPlay] 💎 Available Charms:")
    for charmId, _ in pairs(availableCharms) do
        print("  -", charmId)
    end
    
    DebugPrint("💎 Charm slots:", usedSlots, "/", maxSlots)
    
    -- ===== วิเคราะห์ Units ที่มีใน Hotbar เพื่อเลือก Charm ที่เหมาะสม =====
    local hotbar = GetHotbarUnits()
    if not hotbar then
        hotbar = {}
        DebugPrint("⚠️ ไม่พบ Hotbar Units - ใช้ Default Priority")
    end
    
    local analyzedPriority = {}
    
    -- วิเคราะห์ว่ามี Unit ประเภทไหนบ้าง
    local hasMeleeUnit = false
    local hasRangedUnit = false
    local hasSpellUnit = false
    local hasSummonUnit = false
    local hasIncomeUnit = false
    
    for slot, unit in pairs(hotbar) do
        if unit and unit.Data then
            local unitData = unit.Data
            local unitName = (unit.Name or ""):lower()
            
            -- เช็คประเภท Unit
            if unitData.AttackType then
                local attackType = tostring(unitData.AttackType):lower()
                if attackType:find("melee") or attackType:find("nail") then
                    hasMeleeUnit = true
                elseif attackType:find("range") or attackType:find("projectile") then
                    hasRangedUnit = true
                elseif attackType:find("spell") or attackType:find("magic") then
                    hasSpellUnit = true
                end
            end
            
            -- เช็คจากชื่อ
            if unitName:find("summon") or unitName:find("sibling") or unitName:find("void") then
                hasSummonUnit = true
            end
            
            if unit.IsIncome then
                hasIncomeUnit = true
            end
            
            -- เช็คจาก Abilities
            if unitData.Abilities then
                for abilityName, ability in pairs(unitData.Abilities) do
                    local abilityNameLower = tostring(abilityName):lower()
                    if abilityNameLower:find("spell") or abilityNameLower:find("void") then
                        hasSpellUnit = true
                    end
                    if abilityNameLower:find("summon") or abilityNameLower:find("sibling") then
                        hasSummonUnit = true
                    end
                end
            end
        end
    end
    
    DebugPrint("💎 Unit Analysis:")
    DebugPrint("  - Melee:", hasMeleeUnit)
    DebugPrint("  - Ranged:", hasRangedUnit)
    DebugPrint("  - Spell:", hasSpellUnit)
    DebugPrint("  - Summon:", hasSummonUnit)
    DebugPrint("  - Income:", hasIncomeUnit)
    
    -- ===== สร้าง Priority ใหม่ตาม Units ที่มี =====
    -- ถ้าเป็น Solo (ไม่มี Unit อื่น) ให้ใช้ FuryOfTheForsaken
    local isLikelySolo = false
    local unitCount = 0
    for _ in pairs(hotbar) do unitCount = unitCount + 1 end
    if unitCount == 1 then
        isLikelySolo = true
        DebugPrint("💎 ตรวจพบ Solo Mode - แนะนำ FuryOfTheForsaken")
    end
    
    -- สร้าง analyzed priority
    if isLikelySolo then
        -- Solo: FuryOfTheForsaken เป็นอันดับ 1 (doubles damage)
        analyzedPriority = {"FuryOfTheForsaken", "HonedNail", "NailmastersWill", "SigilOfReach", "ShamanRelic", "VoidGivenClaw", "SigilOfFocus", "BarbsOfSpite"}
    elseif hasSpellUnit then
        -- มี Spell Unit: เน้น ShamanRelic และ SigilOfFocus
        analyzedPriority = {"ShamanRelic", "SigilOfFocus", "HonedNail", "NailmastersWill", "SigilOfReach", "VoidGivenClaw", "BarbsOfSpite", "FuryOfTheForsaken"}
    elseif hasSummonUnit then
        -- มี Summon Unit: เน้น VoidGivenClaw
        analyzedPriority = {"VoidGivenClaw", "HonedNail", "NailmastersWill", "SigilOfReach", "ShamanRelic", "SigilOfFocus", "BarbsOfSpite", "FuryOfTheForsaken"}
    elseif hasMeleeUnit then
        -- มี Melee Unit: เน้น HonedNail และ NailmastersWill
        analyzedPriority = {"HonedNail", "NailmastersWill", "SigilOfReach", "BarbsOfSpite", "ShamanRelic", "VoidGivenClaw", "SigilOfFocus", "FuryOfTheForsaken"}
    elseif hasRangedUnit then
        -- มี Ranged Unit: เน้น SigilOfReach
        analyzedPriority = {"SigilOfReach", "HonedNail", "NailmastersWill", "ShamanRelic", "VoidGivenClaw", "SigilOfFocus", "BarbsOfSpite", "FuryOfTheForsaken"}
    else
        -- Default: ใช้ Settings
        analyzedPriority = Settings["Charm Priority"]
    end
    
    DebugPrint("💎 Analyzed Charm Priority:", table.concat(analyzedPriority, ", "))
    
    print("[AutoPlay] 💎 Equipping charms based on analysis...")
    print("[AutoPlay] 💎 Priority:", table.concat(analyzedPriority, ", "))
    
    -- ===== Equip Charm ตามลำดับที่วิเคราะห์แล้ว =====
    local charmsEquipped = 0
    local remainingSlots = maxSlots - usedSlots
    
    print("[AutoPlay] 💎 Starting equip loop | Remaining slots:", remainingSlots)
    
    -- ===== PASS 1: Equip charms ตามลำดับ priority =====
    for _, charmId in ipairs(analyzedPriority) do
        if remainingSlots <= 0 then
            print("[AutoPlay] 💎 No more slots available, stopping")
            break
        end
        
        -- เช็คว่า Charm นี้พร้อมใช้หรือไม่
        if availableCharms[charmId] then
            -- เช็คว่า Equip ไว้แล้วหรือยัง
            if not equippedCharms[charmId] then
                -- เช็คว่ามี slot พอหรือไม่
                local charmData = CharmData[charmId]
                local slotCost = charmData and charmData.SlotCost or 1
                
                print("[AutoPlay] 💎 Checking:", charmId, "| Cost:", slotCost, "| Remaining:", remainingSlots)
                
                if slotCost <= remainingSlots then
                    print("[AutoPlay] 💎 Equipping:", charmId)
                    DebugPrint("💎 พยายาม Equip:", charmId, "cost:", slotCost)
                    if EquipCharm(charmId) then
                        usedSlots = usedSlots + slotCost
                        remainingSlots = remainingSlots - slotCost
                        equippedCharms[charmId] = true
                        charmsEquipped = charmsEquipped + 1
                        print("[AutoPlay] ✅ Equipped:", charmId, "| Slots now:", usedSlots, "/", maxSlots, "| Remaining:", remainingSlots)
                        task.wait(0.5) -- รอ 0.5 วินาทีก่อน equip ตัวถัดไป
                    else
                        print("[AutoPlay] ⚠️ Failed to equip:", charmId)
                    end
                else
                    -- Charm นี้ใช้ slot มากเกินไป ลองตัวถัดไปที่อาจใช้ slot น้อยกว่า
                    print("[AutoPlay] 💎 Skipping (too expensive):", charmId, "| Need:", slotCost, "| Have:", remainingSlots)
                    -- ไม่ break เพราะอาจมี charm อื่นที่ใช้ slot น้อยกว่า
                end
            else
                print("[AutoPlay] 💎", charmId, "already equipped, skipping")
                DebugPrint("💎", charmId, "Equipped แล้ว")
            end
        else
            -- Charm ไม่ available (ยังไม่ปลดล็อค)
            print("[AutoPlay] 💎", charmId, "not available, skipping")
        end
    end
    
    -- ===== PASS 2: ถ้ายังมี slot เหลือ ลองหา 1-slot charms ที่ยังไม่ได้ equip =====
    if remainingSlots >= 1 then
        print("[AutoPlay] 💎 PASS 2: Looking for 1-slot charms to fill remaining", remainingSlots, "slots")
        local oneSlotCharms = {"VoidGivenClaw", "SigilOfFocus", "BarbsOfSpite"}
        
        for _, charmId in ipairs(oneSlotCharms) do
            if remainingSlots <= 0 then break end
            
            if availableCharms[charmId] and not equippedCharms[charmId] then
                local charmData = CharmData[charmId]
                local slotCost = charmData and charmData.SlotCost or 1
                
                if slotCost <= remainingSlots then
                    print("[AutoPlay] 💎 PASS 2: Equipping 1-slot charm:", charmId)
                    if EquipCharm(charmId) then
                        usedSlots = usedSlots + slotCost
                        remainingSlots = remainingSlots - slotCost
                        equippedCharms[charmId] = true
                        charmsEquipped = charmsEquipped + 1
                        print("[AutoPlay] ✅ PASS 2: Equipped:", charmId, "| Remaining:", remainingSlots)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
    
    print("[AutoPlay] ====== CHARM EQUIP COMPLETE ======")
    print("[AutoPlay] 💎 Total Equipped:", charmsEquipped, "charms")
    print("[AutoPlay] 💎 Slots Used:", usedSlots, "/", maxSlots)
    DebugPrint("💎 Auto Equip เสร็จสิ้น - ใช้", usedSlots, "/", maxSlots, "slots")
end

local function InitCharmSystem()
    print("[AutoPlay] InitCharmSystem called!")
    print("[AutoPlay] Auto Equip Charm setting:", Settings["Auto Equip Charm"])
    
    if not Settings["Auto Equip Charm"] then 
        print("[AutoPlay] Auto Equip Charm is disabled, skipping")
        return 
    end
    
    if not GetHollowsephData then
        print("[AutoPlay] ERROR: GetHollowsephData is nil!")
        DebugPrint("❌ ไม่พบ Charm system events")
        return
    end
    
    print("[AutoPlay] Starting Charm system initialization...")
    
    -- ดึงข้อมูล Charm เริ่มต้น
    task.spawn(function()
        print("[AutoPlay] Waiting 2 seconds before getting charm data...")
        task.wait(2) -- รอ 2 วินาทีให้ระบบโหลด
        
        print("[AutoPlay] Calling GetHollowsephDataFromServer...")
        HollowsephData = GetHollowsephDataFromServer()
        
        print("[AutoPlay] HollowsephData received:", HollowsephData and "YES" or "NO/NIL")
        
        if HollowsephData then
            print("[AutoPlay] ✅ Charm system loaded successfully!")
            DebugPrint("✅ Charm system loaded")
            
            -- แสดง Available Charms
            if HollowsephData.AvailableCharms then
                print("[AutoPlay] Available Charms:")
                for charmId, _ in pairs(HollowsephData.AvailableCharms) do
                    print("  - ", charmId)
                    DebugPrint("  -", charmId)
                end
            else
                print("[AutoPlay] WARNING: AvailableCharms is nil or empty!")
            end
            
            -- แสดง Equipped Charms
            if HollowsephData.EquippedCharms then
                print("[AutoPlay] Currently Equipped Charms:")
                for charmId, _ in pairs(HollowsephData.EquippedCharms) do
                    print("  - ", charmId)
                end
            end
            
            -- แสดง Max Slots
            print("[AutoPlay] Max Charm Slots:", HollowsephData.MaxSlots or "unknown")
            
            -- Auto Equip Charm
            print("[AutoPlay] Calling AutoEquipCharms...")
            AutoEquipCharms()
        else
            print("[AutoPlay] ERROR: Failed to get charm data from server!")
        end
    end)
    
    -- รับ Event เมื่อ Charm data เปลี่ยน
    if HollowsephDataChanged then
        HollowsephDataChanged.OnClientEvent:Connect(function(action, data)
            DebugPrint("💎 Charm data changed:", action, data)
            if action == "CharmEquipped" or action == "CharmUnequipped" then
                -- อัพเดท local data
                HollowsephData = GetHollowsephDataFromServer()
            end
        end)
    end
    
    -- เมื่อ Match restart ให้ Unequip ทั้งหมดแล้ว Re-analyze Charm ใหม่
    if GameHandler then
        pcall(function()
            if GameHandler.MatchRestarted then
                GameHandler.MatchRestarted:Connect(function()
                    print("[AutoPlay] 🔄 Match Restarted detected!")
                    DebugPrint("🔄 Match Restarted - Re-analyze & Re-equip Charms")
                    MatchStarted = false
                    MatchEnded = false
                    
                    task.spawn(function()
                        task.wait(1)
                        -- Unequip ทั้งหมดก่อนเพื่อวิเคราะห์ใหม่
                        print("[AutoPlay] Unequipping all charms for re-analysis...")
                        UnequipAllCharmsAndReanalyze()
                    end)
                end)
            end
            
            if GameHandler.MatchStarted then
                GameHandler.MatchStarted:Connect(function()
                    print("[AutoPlay] 🎮 Match Started!")
                    DebugPrint("🎮 Match Started")
                    MatchStarted = true
                end)
            end
            
            if GameHandler.MatchEnded then
                GameHandler.MatchEnded:Connect(function()
                    print("[AutoPlay] 🏁 Match Ended!")
                    DebugPrint("🏁 Match Ended")
                    MatchEnded = true
                    MatchStarted = false
                end)
            end
        end)
    else
        print("[AutoPlay] WARNING: GameHandler not found, using alternative detection")
    end
    
    CharmSystemInitialized = true
    DebugPrint("✅ Charm system initialized")
end

-- ===== RESET ON NEW MAP =====
local function ResetForNewMap()
    print("[AutoPlay] 🔄 ResetForNewMap called!")
    PlacedPositions = {}
    OutsideEnemyUnit = nil
    HasOutsideEnemyThisMap = false
    Settings["Reserve Slot 6"] = false -- รีเซ็ตกลับไปวางช่อง 6 ได้ปกติ
    MatchStarted = false
    MatchEnded = false
    
    -- Reset Wave Tracking
    TrackedWave = 0
    TrackedTotalWaves = 0
    
    -- Reset Smart Enemy Outside Handler variables
    OutsideEnemySlotRotation = {}
    OutsideEnemyCurrentSlot = nil
    OutsideEnemyLastSwapTime = 0
    OutsideEnemyHandling = false
    IncomeUnitsSoldAtMaxWave = false
    
    -- Reset Max Wave Tracking
    DetectedMaxWave = 0
    HighestWaveSeen = 0
    WaveStableCount = 0
    LastWaveForStableCheck = 0
    
    -- Reset Boss Hunter variables
    BossHunterActive = false
    BossHunterTarget = nil
    BossHunterUnits = {}
    BossHunterLastCheck = 0
    BossHunterDebugPrinted = false -- Reset debug print flag
    
    DebugPrint("รีเซ็ตสำหรับแมพใหม่ - ช่อง 6 วางได้ปกติ")
    
    -- Re-analyze และ Re-equip Charms หลังจาก Reset
    if Settings["Auto Equip Charm"] then
        task.spawn(function()
            task.wait(2)
            print("[AutoPlay] Re-analyzing Charms for new map...")
            UnequipAllCharmsAndReanalyze()
        end)
    end
end

-- ===== MAIN LOOP =====
local function AutoPlayLoop()
    local loopCount = 0
    local lastDebugTime = 0
    local earlyGameUnits = {} -- เก็บ unit ที่วางช่วง early (ไว้ขายย้ายทีหลัง)
    local incomeFullyUpgraded = false -- Income อัพเกรดครบหรือยัง
    local earlyDPSPlaced = 0 -- จำนวน DPS ที่วางช่วงแรก (จำกัด 2 ตัว)
    local maxEarlyDPS = 2 -- จำกัด DPS ช่วงแรก: 1 ปกติ + 1 ดักหลุด
    
    -- Initialize Yen tracking at start
    InitYenTracking()
    
    while Settings["Enabled"] do
        task.wait(0.5)
        loopCount = loopCount + 1
        
        -- Update Wave from UI every loop
        UpdateWaveFromUI()
        
        -- ===== อัพเดท Yen จริงทุกรอบ =====
        CurrentYen = GetYen()
        
        local currentTime = tick()
        local path = GetMapPath()
        local hotbar = GetHotbarUnits()
        local enemies = GetEnemies()
        local activeUnits = GetActiveUnits()
        
        -- Debug ทุก 10 วินาที
        if currentTime - lastDebugTime > 10 then
            DebugPrint("Loop", loopCount, "| Yen:", CurrentYen, "| Units:", #activeUnits, "| EnemyProgress:", math.floor(EnemyProgressMax * 100) .. "%")
            lastDebugTime = currentTime
        end
        
        -- ===== Track Enemy Progress =====
        local currentMaxProgress = 0
        for _, enemy in pairs(enemies) do
            if enemy.Position and #path > 0 then
                local closestNodeIndex = 1
                local closestDist = math.huge
                for i, node in ipairs(path) do
                    local dist = (enemy.Position - node).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestNodeIndex = i
                    end
                end
                local progress = closestNodeIndex / #path
                if progress > currentMaxProgress then
                    currentMaxProgress = progress
                end
                if progress > EnemyProgressMax then
                    EnemyProgressMax = progress
                end
            end
        end
        
        -- ===== PRIORITY SYSTEM =====
        -- Priority 1: ถ้า Enemy หลุดจากระยะ Units ทั้งหมด และใกล้บ้าน → วางตัวแก้สถานการณ์ทันที!
        -- Priority 2: วาง Income ให้ครบ limit + อัพเกรดครบ
        -- Priority 3: วาง DPS ปกติ
        -- Priority 4: ขายตัว early game ที่ไม่ได้อยู่ตำแหน่งดี แล้วย้าย
        
        -- ===== คำนวณว่า Enemy หลุดจากระยะ Units หรือยัง =====
        local enemyEscapedFromUnits = false
        local furthestEnemyOutOfRange = nil
        
        for _, enemy in pairs(enemies) do
            if enemy.Position then
                local isInRangeOfAnyUnit = false
                
                -- เช็คว่า Enemy อยู่ในระยะของ Unit ไหนบ้าง
                for _, unit in pairs(activeUnits) do
                    if unit.Position then
                        local distToEnemy = (unit.Position - enemy.Position).Magnitude
                        local unitRange = unit.Range or 20 -- default range 20
                        if distToEnemy <= unitRange + 5 then -- +5 เผื่อ buffer
                            isInRangeOfAnyUnit = true
                            break
                        end
                    end
                end
                
                -- ถ้า Enemy ไม่อยู่ในระยะ Unit ใดเลย
                if not isInRangeOfAnyUnit and #activeUnits > 0 then
                    enemyEscapedFromUnits = true
                    furthestEnemyOutOfRange = enemy
                end
            end
        end
        
        -- Emergency เมื่อ: Enemy > 80% path AND หลุดจากระยะ Units ทั้งหมด
        local emergencyMode = currentMaxProgress > 0.8 and #enemies > 0 and enemyEscapedFromUnits
        
        if emergencyMode then
            print("[AutoPlay] 🚨 EMERGENCY! Progress:", math.floor(currentMaxProgress * 100) .. "%")
        end
        
        -- 1. จัดการ Enemy นอกพื้นที่
        HandleOutsideEnemy()
        
        -- 1.1 Boss Hunter (workspace.Entities)
        HandleBossHunter()
        
        -- 1.5 ขายตัวเงินเมื่อถึง Max Wave
        CheckAndSellIncomeAtMaxWave()
        
        -- 1.6 Auto recover หลังจัดการ Enemy Outside เสร็จ
        AutoRecoverAfterEmergency()
        
        -- ===== สรุปสถานะ Slot (เหมือน AutoPlay_Smart) =====
        local summary = GetSlotsSummary()
        local actualYen = GetYen()
        
        -- ===== LOG แบบ AutoPlay_Smart (ทุก 5 วินาที) =====
        if loopCount % 10 == 1 then
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print(string.format("[AutoPlay] 💰 Yen: %d | Wave: %d/%d | Units: %d | Enemies: %d", 
                actualYen, TrackedWave, TrackedTotalWaves, #activeUnits, #enemies))
            print(string.format("[AutoPlay] 📊 Income: %d/%d | DPS: %d/%d | Progress: %d%%", 
                summary.income.placed, summary.income.limit,
                summary.dps.placed, summary.dps.limit,
                math.floor(currentMaxProgress * 100)))
            
            -- แสดงรายละเอียด slot
            for _, slotInfo in ipairs(summary.income.slots) do
                print(string.format("[AutoPlay]    💰 Slot %d: %s (%d/%d)", 
                    slotInfo.slot, slotInfo.name, slotInfo.current, slotInfo.limit))
            end
            for _, slotInfo in ipairs(summary.dps.slots) do
                print(string.format("[AutoPlay]    ⚔️ Slot %d: %s (%d/%d)", 
                    slotInfo.slot, slotInfo.name, slotInfo.current, slotInfo.limit))
            end
            
            -- แสดง Decision Status
            local decisionStatus = {}
            if emergencyMode then
                table.insert(decisionStatus, "🚨 EMERGENCY")
            end
            if incomeFullyUpgraded then
                table.insert(decisionStatus, "💰 Income MAX")
            else
                table.insert(decisionStatus, "💰 Income PENDING")
            end
            if TrackedWave >= TrackedTotalWaves and TrackedTotalWaves > 0 then
                table.insert(decisionStatus, "🏁 MAX WAVE")
            end
            if #enemies == 0 then
                table.insert(decisionStatus, "👻 No Enemies (Auto Skill OFF)")
            end
            if #decisionStatus > 0 then
                print(string.format("[AutoPlay] 🎯 Status: %s", table.concat(decisionStatus, " | ")))
            end
        end
        
        -- ===== คำนวณสถานะ Income =====
        local incomeSlots = {} -- Income slots ที่ยังวางได้
        local allIncomeMaxed = true -- Income ทั้งหมด max level หรือยัง
        
        local hotbarCount = 0
        for slot, unit in pairs(hotbar) do
            hotbarCount = hotbarCount + 1
            local isIncome = unit.IsIncome or IsIncomeSlot(slot)
            local canPlace = CanPlaceSlot(slot)
            
            if isIncome and canPlace then
                table.insert(incomeSlots, {slot = slot, unit = unit})
            end
        end
        
        -- เช็คว่า Income ที่วางแล้วอัพ max หรือยัง
        local activeUnitsForIncome = GetActiveUnits()
        for _, unit in pairs(activeUnitsForIncome) do
            local isIncome = false
            if unit.Data then
                if unit.Data.UnitType == "Farm" or unit.Data.IsIncome then isIncome = true end
            end
            if unit.Name then
                local nameLower = unit.Name:lower()
                if nameLower:find("income") or nameLower:find("farm") or nameLower:find("takaroda") or
                   nameLower:find("takaro") or nameLower:find("merchant") or nameLower:find("bank") then
                    isIncome = true
                end
            end
            if isIncome then
                local lvl = (unit.Data and unit.Data.CurrentUpgrade) or unit.Level or 1
                if lvl < Settings["Max Upgrade Level"] then
                    allIncomeMaxed = false
                    break
                end
            end
        end
        
        -- ถ้ายังมี Income วางได้ = ยังไม่ max
        if #incomeSlots > 0 then
            allIncomeMaxed = false
        end
        
        -- ===== FIX: ถ้าไม่มี Income เลย (ทั้งใน hotbar และที่วางไว้) = ถือว่าพร้อมวาง DPS =====
        local hasAnyIncomeUnit = #incomeSlots > 0
        for _, unit in pairs(activeUnitsForIncome) do
            local isIncome = false
            if unit.Data then
                if unit.Data.UnitType == "Farm" or unit.Data.IsIncome then isIncome = true end
            end
            if unit.Name then
                local nameLower = unit.Name:lower()
                if nameLower:find("income") or nameLower:find("farm") or nameLower:find("takaroda") or
                   nameLower:find("takaro") or nameLower:find("merchant") or nameLower:find("bank") then
                    isIncome = true
                end
            end
            if isIncome then
                hasAnyIncomeUnit = true
                break
            end
        end
        
        -- ถ้าไม่มี Income เลย = ถือว่า Income พร้อมแล้ว
        if not hasAnyIncomeUnit then
            allIncomeMaxed = true
        end
        
        -- Update flag
        if allIncomeMaxed and not incomeFullyUpgraded then
            incomeFullyUpgraded = true
            if hasAnyIncomeUnit then
                print("[AutoPlay] ✅ Income MAX แล้ว! เริ่มวาง DPS")
            else
                print("[AutoPlay] ✅ ไม่มี Income - วาง DPS ได้เลย")
            end
        end
        
        -- 2. ===== AUTO PLACE UNITS =====
        if Settings["Auto Place"] and currentTime - LastPlaceTime >= Settings["Place Cooldown"] then
            local slotToPlace = nil
            local isIncomePlace = false
            local placePhase = "early"
            
            -- ===== เช็คว่าเป็นเริ่มเกมหรือยัง (ยังไม่มีตัววางเลย) =====
            local isGameStart = #activeUnits == 0
            
            -- ===== STEP 1: วาง Income ก่อนเสมอ (ถ้ายังไม่ครบ) =====
            local incomeAffordable = false
            if #incomeSlots > 0 then
                for _, incomeData in ipairs(incomeSlots) do
                    local slot = incomeData.slot
                    local unit = incomeData.unit
                    local price = unit.Price or 0
                    local limit, current = GetSlotLimit(slot)
                    
                    -- เช็ค limit ก่อนวาง
                    if current >= limit then
                        -- slot นี้เต็มแล้ว ข้าม
                        continue
                    end
                    
                    if actualYen >= price then
                        slotToPlace = slot
                        isIncomePlace = true
                        incomeAffordable = true
                        print(string.format("[AutoPlay] 💰 วาง Income: %s (Slot %d, %d/%d) | ¥%d", 
                            unit.Name, slot, current, limit, price))
                        break
                    end
                end
            end
            
            -- ===== STEP 2: วาง DPS =====
            if not slotToPlace then
                local canPlaceDPS = isGameStart or incomeFullyUpgraded or emergencyMode or (not incomeAffordable and #incomeSlots > 0)
                
                -- ถ้ายังไม่มี DPS เลย = วางได้เลย (Early DPS)
                local hasAnyDPS = false
                for _, unit in pairs(activeUnits) do
                    local isIncome = false
                    if unit.Data then
                        if unit.Data.UnitType == "Farm" or unit.Data.IsIncome then isIncome = true end
                    end
                    if unit.Name then
                        local nameLower = unit.Name:lower()
                        if nameLower:find("income") or nameLower:find("farm") or nameLower:find("takaroda") then
                            isIncome = true
                        end
                    end
                    if not isIncome then
                        hasAnyDPS = true
                        break
                    end
                end
                
                -- ถ้ายังไม่มี DPS เลย = วางได้เลย (ไม่ต้องรอ Income max)
                if not hasAnyDPS then
                    canPlaceDPS = true
                end
                
                if canPlaceDPS then
                    for _, slot in ipairs(Settings["Place Priority"]) do
                        if Settings["Reserve Slot 6"] and slot == 6 then continue end
                        local unit = hotbar[slot]
                        if unit and not unit.IsIncome and not IsIncomeSlot(slot) then
                            local limit, current = GetSlotLimit(slot)
                            
                            -- เช็ค limit ก่อนวาง
                            if current >= limit then
                                -- slot นี้เต็มแล้ว ข้าม
                                continue
                            end
                            
                            local price = unit.Price or 0
                            if actualYen >= price then
                                slotToPlace = slot
                                placePhase = emergencyMode and "late" or "early"
                                print(string.format("[AutoPlay] ⚔️ วาง DPS: %s (Slot %d, %d/%d) | ¥%d", 
                                    unit.Name, slot, current, limit, price))
                                break
                            end
                        end
                    end
                end
            end
            
            -- ===== ทำการวาง =====
            if slotToPlace then
                local unit = hotbar[slotToPlace]
                local bestPos
                
                if isIncomePlace then
                    bestPos = GetIncomePosition()
                else
                    bestPos = GetBestPlacementPosition(Settings["Unit Range"], placePhase)
                end
                
                if bestPos then
                    if PlaceUnit(slotToPlace, bestPos) then
                        local limit, current = GetSlotLimit(slotToPlace)
                        print(string.format("[AutoPlay] ✅ วางสำเร็จ: %s | ตอนนี้ %d/%d", 
                            unit.Name, current + 1, limit))
                        LastPlaceTime = currentTime
                        SlotPlaceCount[slotToPlace] = (SlotPlaceCount[slotToPlace] or 0) + 1
                        
                        if not isIncomePlace then
                            earlyDPSPlaced = earlyDPSPlaced + 1
                        end
                    else
                        print(string.format("[AutoPlay] ❌ วางไม่สำเร็จ: %s", unit.Name))
                    end
                else
                    print(string.format("[AutoPlay] ❌ ไม่พบตำแหน่งวาง: %s", unit.Name))
                end
            end
        end
        
        -- 3. ===== AUTO UPGRADE =====
        if Settings["Auto Upgrade"] and currentTime - LastUpgradeTime > 0.5 then
            local upgradeable = GetUpgradeableUnits()
            
            -- เช็คว่าวางครบทุก slot หรือยัง
            local allUnitsPlaced = true
            local hotbarForCheck = GetHotbarUnits()
            for slot, unit in pairs(hotbarForCheck) do
                if CanPlaceSlot(slot) then
                    allUnitsPlaced = false
                    break
                end
            end
            
            if #upgradeable > 0 then
                local target = nil
                local upgradeReason = ""
                
                -- แยก Income และ DPS
                local incomeUnits = {}
                local dpsUnits = {}
                
                for _, unit in pairs(upgradeable) do
                    local isIncome = false
                    if unit.Data then
                        if unit.Data.UnitType == "Farm" or unit.Data.IsIncome then isIncome = true end
                    end
                    if unit.Name then
                        local nameLower = unit.Name:lower()
                        if nameLower:find("income") or nameLower:find("farm") or nameLower:find("takaroda") or
                           nameLower:find("takaro") or nameLower:find("merchant") or nameLower:find("bank") then
                            isIncome = true
                        end
                    end
                    
                    local lvl = (unit.Data and unit.Data.CurrentUpgrade) or unit.Level or 1
                    
                    if isIncome then
                        if lvl < Settings["Max Upgrade Level"] then
                            table.insert(incomeUnits, unit)
                        end
                    else
                        if lvl < Settings["Max Upgrade Level"] then
                            table.insert(dpsUnits, unit)
                        end
                    end
                end
                
                -- ===== PRIORITY 1: อัพ Income ทุกตัวที่มีเงินพอ! =====
                if #incomeUnits > 0 then
                    -- เรียงตาม level จากต่ำไปสูง
                    table.sort(incomeUnits, function(a, b)
                        local lvlA = (a.Data and a.Data.CurrentUpgrade) or a.Level or 1
                        local lvlB = (b.Data and b.Data.CurrentUpgrade) or b.Level or 1
                        return lvlA < lvlB
                    end)
                    
                    local incomeUpgraded = 0
                    local currentYenCheck = GetYen()
                    
                    for _, incomeUnit in ipairs(incomeUnits) do
                        local upgradeCost = GetUpgradeCost(incomeUnit)
                        if currentYenCheck >= upgradeCost and incomeUnit.GUID then
                            local lvl = (incomeUnit.Data and incomeUnit.Data.CurrentUpgrade) or incomeUnit.Level or 1
                            print(string.format("[AutoPlay] ⬆️💰 อัพ Income: %s (Lv%d) | Cost: %d | Yen: %d", 
                                incomeUnit.Name, lvl, upgradeCost, currentYenCheck))
                            if UpgradeUnit(incomeUnit.GUID) then
                                currentYenCheck = currentYenCheck - upgradeCost
                                CurrentYen = currentYenCheck
                                incomeUpgraded = incomeUpgraded + 1
                                LastUpgradeTime = currentTime
                            end
                            task.wait(0.1) -- รอเล็กน้อยระหว่างอัพแต่ละตัว
                        end
                    end
                    
                    if incomeUpgraded > 0 then
                        print(string.format("[AutoPlay] ✅ อัพ Income %d ตัว", incomeUpgraded))
                        target = nil -- ไม่ต้องอัพอีกแล้ว รอบนี้จบ
                    else
                        -- ถ้าเงินไม่พอซักตัว ให้หา Income ที่ถูกที่สุด
                        for _, unit in ipairs(incomeUnits) do
                            local cost = GetUpgradeCost(unit)
                            local lvl = (unit.Data and unit.Data.CurrentUpgrade) or unit.Level or 1
                            target = unit
                            upgradeReason = string.format("💰 INCOME (Lv%d, need %d¥)", lvl, cost)
                            break
                        end
                    end
                end
                
                -- ===== PRIORITY 2: อัพ DPS (หลัง Income max แล้ว) =====
                if not target and incomeFullyUpgraded and #dpsUnits > 0 then
                    -- หา DPS ตัวแรงที่สุดแทน level ต่ำสุด (from AutoPlay_Smart)
                    local strongest = GetStrongestUnit(dpsUnits)
                    if strongest then
                        target = strongest
                        local lvl = (target.Data and target.Data.CurrentUpgrade) or target.Level or 1
                        upgradeReason = "⚔️ DPS STRONGEST (Lv" .. lvl .. ")"
                    end
                end
                
                -- ===== PRIORITY 3: ถ้าวางครบแล้ว อัพ DPS ต่อไปเรื่อยๆ =====
                if not target and allUnitsPlaced and #dpsUnits > 0 then
                    local strongest = GetStrongestUnit(dpsUnits)
                    if strongest then
                        target = strongest
                        local lvl = (target.Data and target.Data.CurrentUpgrade) or target.Level or 1
                        upgradeReason = "⚔️ DPS FOCUS (Lv" .. lvl .. ")"
                    end
                end
                
                -- ===== ทำการอัพเกรด =====
                if target and target.GUID then
                    local upgradeCost = GetUpgradeCost(target)
                    -- เช็ค Yen จริงจาก UI ก่อน upgrade
                    local actualYen = GetYen()
                    if actualYen >= upgradeCost then
                        print("[AutoPlay] ⬆️ อัพเกรด:", target.Name, upgradeReason, "| Cost:", upgradeCost, "| Yen:", actualYen)
                        if UpgradeUnit(target.GUID) then
                            LastUpgradeTime = currentTime
                            CurrentYen = actualYen - upgradeCost
                        end
                    else
                        -- เงินไม่พอ ไม่ทำอะไร รอเช็ครอบหน้า
                        DebugPrint("💸 เงินไม่พอ upgrade:", target.Name, "Need:", upgradeCost, "Have:", actualYen)
                    end
                end
            end
        end
        
        -- 4. ขายตัว Early Game ที่ไม่ได้อยู่ตำแหน่งดี (หลังผ่าน early game)
        if #earlyGameUnits > 0 and EnemyProgressMax > 0.4 then
            -- หา unit ที่วางช่วง early ที่อยู่ไกล path เกินไป
            for i, earlyUnit in ipairs(earlyGameUnits) do
                -- หา active unit ที่ตรงกับตำแหน่ง
                for _, activeUnit in pairs(activeUnits) do
                    if activeUnit.Position and (activeUnit.Position - earlyUnit.Position).Magnitude < 3 then
                        -- เช็คว่าตำแหน่งนี้ดีพอหรือเปล่า
                        local closestDist = math.huge
                        for _, node in pairs(path) do
                            local dist = (activeUnit.Position - node).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                            end
                        end
                        
                        -- ถ้าไกลเกิน 15 studs จาก path = ตำแหน่งไม่ดี
                        -- ⚠️ ห้ามขายตัวเงิน! ตัวเงินวางไกลโดยตั้งใจ
                        if closestDist > 15 then
                            local isIncome = IsIncomeUnit(activeUnit.Name, activeUnit.Data)
                            if isIncome then
                                DebugPrint("⚠️ ไม่ขายตัวเงิน:", activeUnit.Name, "(ไกล path แต่เป็น income)")
                                -- ลบออกจาก earlyGameUnits เฉยๆ ไม่ขาย
                                table.remove(earlyGameUnits, i)
                                break
                            else
                                DebugPrint("ขายตัว early game ที่ตำแหน่งไม่ดี:", activeUnit.Name, "dist:", math.floor(closestDist))
                                SellUnit(activeUnit.GUID)
                                table.remove(earlyGameUnits, i)
                                break
                            end
                        end
                        break
                    end
                end
            end
        end
        
        -- 5. Auto Skill Units
        if Settings["Auto Skill"] and currentTime - LastSkillTime > 5 then
            CheckAndEnableAutoSkills()
            LastSkillTime = currentTime
        end
        
        -- 6. ขายตัว Early Game ที่ไม่ได้อยู่ตำแหน่งดี (หลังผ่าน early game)
        if #earlyGameUnits > 0 and EnemyProgressMax > 0.4 then
            -- หา unit ที่วางช่วง early ที่อยู่ไกล path เกินไป
            for i, earlyUnit in ipairs(earlyGameUnits) do
                -- หา active unit ที่ตรงกับตำแหน่ง
                for _, activeUnit in pairs(activeUnits) do
                    if activeUnit.Position and (activeUnit.Position - earlyUnit.Position).Magnitude < 3 then
                        -- เช็คว่าตำแหน่งนี้ดีพอหรือเปล่า
                        local closestDist = math.huge
                        for _, node in pairs(path) do
                            local dist = (activeUnit.Position - node).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                            end
                        end
                        
                        -- ถ้าไกลเกิน 15 studs จาก path = ตำแหน่งไม่ดีwa
                        -- ⚠️ ห้ามขายตัวเงิน! ตัวเงินวางไกลโดยตั้งใจ
                        if closestDist > 15 then
                            local isIncome = IsIncomeUnit(activeUnit.Name, activeUnit.Data)
                            if isIncome then
                                DebugPrint("⚠️ ไม่ขายตัวเงิน:", activeUnit.Name, "(ไกล path แต่เป็น income)")
                                -- ลบออกจาก earlyGameUnits เฉยๆ ไม่ขาย
                                table.remove(earlyGameUnits, i)
                                break
                            else
                                DebugPrint("ขายตัว early game ที่ตำแหน่งไม่ดี:", activeUnit.Name, "dist:", math.floor(closestDist))
                                SellUnit(activeUnit.GUID)
                                table.remove(earlyGameUnits, i)
                                break
                            end
                        end
                    end
                end
            end
        end
        
        -- 5. Auto Skill (check ทุก 2 วินาที)
        if Settings["Auto Skill"] and currentTime - LastSkillTime > 2 then
            CheckAndEnableAutoSkills()
            LastSkillTime = currentTime
        end
    end
end

-- ===== SMART PLACEMENT CALCULATOR =====
local function CalculateOptimalPlacements(unitData)
    local path = GetMapPath()
    local placements = {}
    
    -- วิเคราะห์ path และหาจุดที่ดีที่สุด
    local segments = {}
    for i = 1, #path - 1 do
        local start = path[i]
        local finish = path[i + 1]
        local direction = (finish - start).Unit
        local length = (finish - start).Magnitude
        
        table.insert(segments, {
            Start = start,
            End = finish,
            Direction = direction,
            Length = length,
            Index = i
        })
    end
    
    -- หาจุดที่ cover หลาย segment
    for _, segment in pairs(segments) do
        local midpoint = (segment.Start + segment.End) / 2
        
        -- หาตำแหน่งวางที่ใกล้ที่สุด
        local positions = GetPlaceablePositions()
        local bestPos = nil
        local bestDist = math.huge
        
        for _, pos in pairs(positions) do
            local dist = (pos - midpoint).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestPos = pos
            end
        end
        
        if bestPos then
            table.insert(placements, {
                Position = bestPos,
                CoverageScore = segment.Length,
                SegmentIndex = segment.Index
            })
        end
    end
    
    -- Sort by coverage score
    table.sort(placements, function(a, b)
        return a.CoverageScore > b.CoverageScore
    end)
    
    return placements
end

-- ===== MONEY MANAGEMENT =====
local function CalculateMinReserve()
    local hotbar = GetHotbarUnits()
    local slot6Unit = hotbar[6]
    
    if slot6Unit and Settings["Reserve Slot 6"] then
        -- เก็บเงินไว้พอวาง Unit ช่อง 6
        return slot6Unit.Price + 100
    end
    
    return Settings["Min Yen Reserve"]
end

local function ShouldPlaceUnit(unitPrice)
    local yen = GetYen()
    local reserve = CalculateMinReserve()
    
    return yen >= unitPrice + reserve
end

-- ===== INITIALIZATION =====
print("========================================")
print("[AV AutoPlay] กำลังโหลด...")
print("[AV AutoPlay] Settings:")
print("  - Auto Start:", Settings["Auto Start"])
print("  - Auto Vote Skip:", Settings["Auto Vote Skip"])
print("  - Auto Equip Charm:", Settings["Auto Equip Charm"])
print("  - Auto Place:", Settings["Auto Place"])
print("  - Auto Upgrade:", Settings["Auto Upgrade"])
print("  - Auto Skill:", Settings["Auto Skill"])
print("  - Auto Handle Outside Enemy:", Settings["Auto Handle Outside Enemy"])
print("========================================")

-- รอให้เกมโหลดเสร็จ
print("[AutoPlay] Waiting 5 seconds for game to load...")
task.wait(5)
print("[AutoPlay] Wait complete, initializing systems...")

-- Initialize Charm System FIRST (ต้อง equip charm ก่อน start)
print("[AutoPlay] Calling InitCharmSystem...")
InitCharmSystem()

-- รอให้ Charm System ทำงานเสร็จก่อน Auto Start
print("[AutoPlay] Waiting for Charm System to complete...")
task.wait(5) -- รอ charm equip/unequip เสร็จ
print("[AutoPlay] Charm wait complete!")

-- Initialize Auto Start System AFTER charms are equipped
print("[AutoPlay] Calling InitAutoStart...")
InitAutoStart()
print("[AutoPlay] All systems initialized!")

-- Track unit placement success
local lastUnitCount = 0
if workspace:FindFirstChild("Units") then
    lastUnitCount = #workspace.Units:GetChildren()
    
    workspace.Units.ChildAdded:Connect(function(unit)
        DebugPrint("✅ Unit วางสำเร็จ:", unit.Name)
        lastUnitCount = #workspace.Units:GetChildren()
        
        -- รีเซ็ต waiting state เมื่อวางสำเร็จ
        WaitingForYen = false
        WaitingForYenAmount = 0
    end)
    
    workspace.Units.ChildRemoved:Connect(function(unit)
        lastUnitCount = #workspace.Units:GetChildren()
        -- รีเซ็ต PlacedPositions เมื่อขาย Unit (เพื่อให้วางตำแหน่งนั้นได้อีก)
        -- ไม่ต้องทำอะไร เพราะเราใช้ score system
    end)
end

-- เริ่ม Auto Play Loop
task.spawn(AutoPlayLoop)

-- ===== COMMANDS =====
_G.AutoPlay = {
    Settings = Settings,
    
    Enable = function()
        Settings["Enabled"] = true
        print("[AutoPlay] เปิดใช้งาน")
    end,
    
    Disable = function()
        Settings["Enabled"] = false
        print("[AutoPlay] ปิดใช้งาน")
    end,
    
    Toggle = function()
        Settings["Enabled"] = not Settings["Enabled"]
        print("[AutoPlay]", Settings["Enabled"] and "เปิดใช้งาน" or "ปิดใช้งาน")
    end,
    
    -- ใช้ Auto Play ในตัวของเกม
    UseGameAutoPlay = function()
        if AutoPlayEvent then
            AutoPlayEvent:FireServer("Toggle")
            print("[AutoPlay] ส่ง Toggle ไปยัง AutoPlayEvent ของเกม")
        else
            print("[AutoPlay] ไม่พบ AutoPlayEvent")
        end
    end,
    
    -- ใช้ Auto Play ในตัวของเกมพร้อมเลือกตำแหน่ง
    UseGameAutoPlayWithPosition = function()
        if AutoPlayEvent then
            AutoPlayEvent:FireServer("ToggleWithPosition")
            print("[AutoPlay] ส่ง ToggleWithPosition ไปยัง AutoPlayEvent ของเกม")
        else
            print("[AutoPlay] ไม่พบ AutoPlayEvent")
        end
    end,
    
    SetDebug = function(value)
        Settings["Debug"] = value
        print("[AutoPlay] Debug:", value)
    end,
    
    ResetMap = function()
        ResetForNewMap()
        print("[AutoPlay] รีเซ็ตสำหรับแมพใหม่")
    end,
    
    GetStatus = function()
        print("========================================")
        print("[AutoPlay Status]")
        print("  Enabled:", Settings["Enabled"])
        print("  Yen:", GetYen())
        print("  Units Placed:", #GetActiveUnits())
        print("  Reserve Slot 6:", Settings["Reserve Slot 6"])
        print("  Has Outside Enemy This Map:", HasOutsideEnemyThisMap)
        print("  Last Place:", tick() - LastPlaceTime, "s ago")
        print("  Last Upgrade:", tick() - LastUpgradeTime, "s ago")
        print("  AutoPlayEvent:", AutoPlayEvent and "Found" or "Not found")
        print("  -- Auto Start --")
        print("  Auto Start:", Settings["Auto Start"])
        print("  Auto Vote Skip:", Settings["Auto Vote Skip"])
        print("  Skip Wave Active:", SkipWaveActive)
        print("  SkipWaveEvent:", SkipWaveEvent and "Found" or "Not found")
        print("  StartMatchEvent:", StartMatchEvent and "Found" or "Not found")
        print("  ReadyEvent:", ReadyEvent and "Found" or "Not found")
        print("  -- Charm System --")
        print("  Auto Equip Charm:", Settings["Auto Equip Charm"])
        print("  Charm System Initialized:", CharmSystemInitialized)
        print("  EquipHollowsephCharm:", EquipHollowsephCharm and "Found" or "Not found")
        print("  Match Started:", MatchStarted)
        print("  Match Ended:", MatchEnded)
        print("========================================")
    end,
    
    -- ===== AUTO START COMMANDS =====
    VoteSkip = function()
        AutoVoteSkip()
        print("[AutoPlay] Vote Skip!")
    end,
    
    StartGame = function()
        local success = TryStartGame()
        print("[AutoPlay] Start Game:", success and "Success!" or "Failed")
    end,
    
    ToggleAutoStart = function()
        Settings["Auto Start"] = not Settings["Auto Start"]
        Settings["Auto Vote Skip"] = Settings["Auto Start"]
        print("[AutoPlay] Auto Start:", Settings["Auto Start"])
    end,
    
    -- Debug Auto Start - แสดงปุ่มที่หาเจอ
    DebugAutoStart = function()
        print("========================================")
        print("[AutoPlay] Debug Auto Start")
        print("  SkipWaveEvent:", SkipWaveEvent and "Found" or "Not found")
        print("  StartMatchEvent:", StartMatchEvent and "Found" or "Not found")
        print("  ReadyEvent:", ReadyEvent and "Found" or "Not found")
        
        -- หา buttons ใน PlayerGui
        print("  Buttons in PlayerGui:")
        for _, gui in pairs(PlayerGui:GetChildren()) do
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                    local name = desc.Name:lower()
                    local text = ""
                    if desc:IsA("TextButton") then
                        text = (desc.Text or ""):lower()
                    end
                    
                    if name:find("start") or name:find("ready") or name:find("begin") or name:find("skip") or
                       text:find("start") or text:find("ready") or text:find("begin") or text:find("skip") then
                        print("    -", gui.Name .. "/" .. desc:GetFullName():gsub(gui:GetFullName() .. ".", ""))
                        print("      Visible:", desc.Visible, "Active:", desc.Active)
                    end
                end
            end
        end
        
        -- หา Events ใน Networking
        print("  Events in Networking:")
        for _, child in pairs(Networking:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                if name:find("start") or name:find("ready") or name:find("skip") or name:find("begin") or name:find("vote") then
                    print("    -", child:GetFullName():gsub(Networking:GetFullName() .. ".", ""), "(" .. child.ClassName .. ")")
                end
            end
        end
        print("========================================")
    end,
    
    -- ===== CHARM COMMANDS =====
    EquipCharms = function()
        HollowsephData = GetHollowsephDataFromServer()
        AutoEquipCharms()
        print("[AutoPlay] Equip Charms!")
    end,
    
    UnequipAllCharms = function()
        if not HollowsephData then
            HollowsephData = GetHollowsephDataFromServer()
        end
        if HollowsephData and HollowsephData.EquippedCharms then
            for charmId, _ in pairs(HollowsephData.EquippedCharms) do
                UnequipCharm(charmId)
                task.wait(0.5)
            end
            print("[AutoPlay] Unequipped all charms!")
        end
    end,
    
    ToggleAutoCharm = function()
        Settings["Auto Equip Charm"] = not Settings["Auto Equip Charm"]
        print("[AutoPlay] Auto Equip Charm:", Settings["Auto Equip Charm"])
    end,
    
    GetCharmStatus = function()
        print("========================================")
        print("[AutoPlay Charm Status]")
        HollowsephData = GetHollowsephDataFromServer()
        if HollowsephData then
            print("  Used Slots:", HollowsephData.UsedCharmSlots or 0, "/", HollowsephData.MaxCharmSlots or 6)
            print("  Available Charms:")
            for charmId, charmData in pairs(HollowsephData.AvailableCharms or {}) do
                local equipped = HollowsephData.EquippedCharms and HollowsephData.EquippedCharms[charmId]
                local charmInfo = CharmData[charmId]
                local slotCost = charmInfo and charmInfo.SlotCost or 1
                -- เช็ค SlotCost จาก server data ด้วย
                if charmData and type(charmData) == "table" and charmData.SlotCost then
                    slotCost = charmData.SlotCost
                end
                print("    -", charmId, "(" .. slotCost .. " notches)", equipped and "✅ EQUIPPED" or "")
            end
            print("  Equipped Charms:")
            for charmId, _ in pairs(HollowsephData.EquippedCharms or {}) do
                print("    - ✅", charmId)
            end
        else
            print("  ❌ ไม่สามารถดึงข้อมูล Charm")
        end
        print("========================================")
    end,
    
    -- ===== NEW: Reanalyze และ Equip ใหม่ =====
    ReanalyzeCharms = function()
        print("[AutoPlay] 🔄 Reanalyze และ Equip Charms ใหม่...")
        UnequipAllCharmsAndReanalyze()
        print("[AutoPlay] ✅ เสร็จสิ้น!")
    end,
    
    -- Equip Charm เฉพาะตัว
    EquipSingleCharm = function(charmId)
        if charmId then
            local success = EquipCharm(charmId)
            print("[AutoPlay] Equip", charmId, ":", success and "Success!" or "Failed")
        else
            print("[AutoPlay] Usage: EquipSingleCharm('CharmId')")
            print("[AutoPlay] Available: HonedNail, NailmastersWill, SigilOfReach, FuryOfTheForsaken, VoidGivenClaw, SigilOfFocus, ShamanRelic, BarbsOfSpite")
        end
    end,
    
    -- Unequip Charm เฉพาะตัว
    UnequipSingleCharm = function(charmId)
        if charmId then
            local success = UnequipCharm(charmId)
            print("[AutoPlay] Unequip", charmId, ":", success and "Success!" or "Failed")
        else
            print("[AutoPlay] Usage: UnequipSingleCharm('CharmId')")
        end
    end,
    
    SetCharmPriority = function(priorityList)
        if type(priorityList) == "table" then
            Settings["Charm Priority"] = priorityList
            print("[AutoPlay] Charm Priority updated!")
        else
            print("[AutoPlay] Error: priorityList must be a table")
        end
    end,
    
    -- ===== SKILL COMMANDS =====
    ToggleAutoSkill = function()
        Settings["Auto Skill"] = not Settings["Auto Skill"]
        print("[AutoPlay] Auto Skill:", Settings["Auto Skill"])
    end,
    
    EnableAutoSkills = function()
        CheckAndEnableAutoSkills()
        print("[AutoPlay] Enabled Auto Skills for all units!")
    end,
    
    UseSpell = function(unitGUID, spellName)
        if unitGUID and spellName then
            local success = UseHollowsephSpell(unitGUID, spellName)
            print("[AutoPlay] Use Spell:", success and "Success!" or "Failed")
        else
            print("[AutoPlay] Usage: UseSpell(unitGUID, spellName)")
        end
    end,
    
    DebugSkills = function()
        print("========================================")
        print("[AutoPlay] Debug Skills")
        print("  AutoAbilityEvent:", AutoAbilityEvent and "Found" or "Not found")
        print("  CastHollowsephSpell:", CastHollowsephSpell and "Found" or "Not found")
        
        local units = GetActiveUnits()
        print("  Active Units:", #units)
        
        for _, unit in pairs(units) do
            print("    - GUID:", unit.GUID)
            print("      Name:", unit.Name)
            
            -- หา Abilities
            if unit.Data and unit.Data.Abilities then
                print("      Abilities:")
                for abilityName, abilityData in pairs(unit.Data.Abilities) do
                    local canAuto = "?"
                    if type(abilityData) == "table" then
                        canAuto = abilityData.CanAutoUse and "Yes" or "No"
                    end
                    print("        -", abilityName, "(CanAuto:", canAuto, ")")
                end
            end
        end
        
        -- หา UpgradeInterfaces
        local upgradeInterface = PlayerGui:FindFirstChild("UpgradeInterfaces")
        if upgradeInterface then
            print("  UpgradeInterfaces children:", #upgradeInterface:GetChildren())
            for _, child in pairs(upgradeInterface:GetChildren()) do
                if child:IsA("Frame") or child:IsA("ScreenGui") then
                    print("    -", child.Name)
                    local buttons = child:FindFirstChild("Buttons")
                    if buttons then
                        print("      Buttons:")
                        for _, btn in pairs(buttons:GetChildren()) do
                            if btn.Name:find("Ability") then
                                print("        -", btn.Name)
                            end
                        end
                    end
                end
            end
        else
            print("  UpgradeInterfaces: Not found")
        end
        print("========================================")
    end,
    
    -- Debug function เพื่อดูว่าหาอะไรได้บ้าง
    Debug = function()
        print("========================================")
        print("[AutoPlay Debug]")
        
        -- Check modules
        print("Modules:")
        print("  UnitsHUD:", UnitsHUD and "Loaded" or "Not loaded")
        print("  ClientUnitHandler:", ClientUnitHandler and "Loaded" or "Not loaded")
        print("  UnitPlacementHandler:", UnitPlacementHandler and "Loaded" or "Not loaded")
        print("  PlacementValidationHandler:", PlacementValidationHandler and "Loaded" or "Not loaded")
        print("  EnemyPathHandler:", EnemyPathHandler and "Loaded" or "Not loaded")
        print("  PathMathHandler:", PathMathHandler and "Loaded" or "Not loaded")
        
        -- Check Remote Events
        print("Remote Events:")
        print("  AutoPlayEvent:", AutoPlayEvent and "Found" or "Not found")
        print("  RequestMiscPlacement:", RequestMiscPlacement and "Found" or "Not found")
        
        -- Check EnemyPathHandler Nodes
        if EnemyPathHandler and EnemyPathHandler.Nodes then
            local nodeCount = 0
            for _ in pairs(EnemyPathHandler.Nodes) do
                nodeCount = nodeCount + 1
            end
            print("  EnemyPathHandler.Nodes:", nodeCount, "nodes")
        end
        
        -- Check hotbar
        local hotbar = GetHotbarUnits()
        print("Hotbar Units:")
        for slot, unit in pairs(hotbar) do
            print("  Slot", slot, ":", unit.Name, "Price:", unit.Price)
        end
        
        -- Check Yen structure
        print("Yen Debug:")
        print("  GetYen():", GetYen())
        local HUD = PlayerGui:FindFirstChild("HUD")
        if HUD then
            print("  HUD found")
            local Yen = HUD:FindFirstChild("Yen")
            if Yen then
                print("  HUD.Yen found")
                for _, child in pairs(Yen:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        print("    -", child.Name, child.ClassName, "Text:", child.Text)
                    end
                end
            else
                print("  HUD.Yen NOT found")
            end
            
            -- แสดงทุก TextLabel ที่มี ¥ หรือตัวเลข
            print("  All ¥ TextLabels in HUD:")
            for _, child in pairs(HUD:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    local text = child.Text
                    if text and (text:find("¥") or text:match("%d%d%d")) then
                        print("    -", child:GetFullName(), "=", text)
                    end
                end
            end
        else
            print("  HUD NOT found")
        end
        
        -- Check path
        local path = GetMapPath()
        print("Map Path:", #path, "nodes")
        if #path > 0 then
            print("  First node:", path[1])
            print("  Last node:", path[#path])
        end
        
        -- Check placeable positions
        local positions = GetPlaceablePositions()
        print("Placeable Positions:", #positions)
        
        -- Check active units
        local units = GetActiveUnits()
        print("Active Units:", #units)
        for _, u in pairs(units) do
            print("  -", u.Name, "at", u.Position)
        end
        
        -- Check enemies
        local enemies = GetEnemies()
        print("Enemies:", #enemies)
        
        -- Check workspace structure
        print("Workspace structure:")
        print("  workspace.Units:", workspace:FindFirstChild("Units") and "Found" or "Not found")
        print("  workspace.Enemies:", workspace:FindFirstChild("Enemies") and "Found" or "Not found")
        print("  workspace.Map:", workspace:FindFirstChild("Map") and "Found" or "Not found")
        
        -- แสดง children ของ workspace ที่น่าสนใจ
        print("  workspace children:")
        for _, child in pairs(workspace:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                local childCount = #child:GetChildren()
                if childCount > 0 then
                    print("    -", child.Name, "(" .. child.ClassName .. ")", "children:", childCount)
                end
            end
        end
        
        -- แสดง Map children ถ้ามี
        if workspace:FindFirstChild("Map") then
            print("  Map children:")
            for _, child in pairs(workspace.Map:GetChildren()) do
                print("    -", child.Name, "(" .. child.ClassName .. ")")
            end
        end
        
        -- Check UnitPlacementHandler
        print("UnitPlacementHandler Debug:")
        if UnitPlacementHandler then
            for k, v in pairs(UnitPlacementHandler) do
                local vType = typeof(v)
                if vType == "table" then
                    print("  ", k, "= table with", #v or 0, "items")
                elseif vType == "function" then
                    print("  ", k, "= function")
                else
                    print("  ", k, "=", tostring(v):sub(1, 50))
                end
            end
        else
            print("  NOT LOADED")
        end
        
        print("========================================")
    end,
    
    -- ทดสอบวาง Unit
    TestPlace = function(slot, x, y, z)
        slot = slot or 1
        local pos = Vector3.new(x or 0, y or 5, z or 0)
        print("[AutoPlay] Testing place Unit slot", slot, "at", pos)
        PlaceUnit(slot, pos)
    end,
    
    -- ทดสอบหาตำแหน่งจาก Path
    TestFindPosition = function()
        local path = GetMapPath()
        print("[AutoPlay] Path nodes:", #path)
        if #path > 0 then
            local midIndex = math.floor(#path / 2)
            local midPos = path[midIndex]
            print("[AutoPlay] Mid path position:", midPos)
            
            -- ลองหาตำแหน่ง valid
            local hotbar = GetHotbarUnits()
            for slot, unit in pairs(hotbar) do
                local validPos = GetValidPlacementPosition(unit.Name, midPos + Vector3.new(5, 0, 0))
                print("[AutoPlay] Valid position for slot", slot, ":", validPos)
                break
            end
        end
    end,
    
    -- Debug UnitData เพื่อดูว่ามี field อะไรบ้าง
    DebugUnitData = function()
        print("========================================")
        print("[AutoPlay] Debug UnitData from UnitsHUD")
        
        if not UnitsHUD or not UnitsHUD._Cache then
            print("❌ ไม่พบ UnitsHUD._Cache")
            return
        end
        
        for slot, v in pairs(UnitsHUD._Cache) do
            if v ~= "None" and v ~= nil then
                print("")
                print("=== Slot", slot, "===")
                local unitData = v.Data or v
                
                -- Print all fields
                local function printTable(tbl, indent)
                    indent = indent or ""
                    if type(tbl) ~= "table" then
                        print(indent, tostring(tbl))
                        return
                    end
                    for k, val in pairs(tbl) do
                        local valType = type(val)
                        if valType == "table" then
                            print(indent, k, "= {")
                            if k == "Abilities" or k == "Tags" or k == "Stats" then
                                for k2, v2 in pairs(val) do
                                    if type(v2) == "table" then
                                        print(indent .. "  ", k2, "= {")
                                        for k3, v3 in pairs(v2) do
                                            print(indent .. "    ", k3, "=", tostring(v3))
                                        end
                                        print(indent .. "  ", "}")
                                    else
                                        print(indent .. "  ", k2, "=", tostring(v2))
                                    end
                                end
                            end
                            print(indent, "}")
                        elseif valType == "function" then
                            print(indent, k, "= [function]")
                        else
                            print(indent, k, "=", tostring(val))
                        end
                    end
                end
                
                printTable(unitData, "  ")
            end
        end
        
        print("========================================")
    end,
    
    -- Debug placement areas
    DebugAreas = function()
        print("========================================")
        print("[AutoPlay] Debug Placement Areas")
        
        local Map = workspace:FindFirstChild("Map")
        if not Map then
            print("❌ ไม่พบ workspace.Map")
            return
        end
        
        print("✅ พบ Map, children:")
        for _, child in pairs(Map:GetChildren()) do
            print("  -", child.Name, "(" .. child.ClassName .. ")", "#children:", #child:GetChildren())
        end
        
        local PlacementAreas = Map:FindFirstChild("PlacementAreas")
        if not PlacementAreas then
            print("❌ ไม่พบ Map.PlacementAreas")
            -- ลองหาชื่ออื่น
            for _, child in pairs(Map:GetChildren()) do
                if child.Name:lower():find("place") or child.Name:lower():find("area") then
                    print("  ลองใช้:", child.Name)
                end
            end
            return
        end
        
        print("✅ พบ PlacementAreas, descendants:")
        local baseParts = 0
        for _, area in pairs(PlacementAreas:GetDescendants()) do
            if area:IsA("BasePart") then
                baseParts = baseParts + 1
                print("  ✅ BasePart:", area.Name)
                print("      Size:", area.Size)
                print("      Position:", area.CFrame.Position)
                print("      Transparency:", area.Transparency)
                print("      CanCollide:", area.CanCollide)
            end
        end
        
        if baseParts == 0 then
            print("❌ ไม่พบ BasePart ใน PlacementAreas")
            print("  Children:")
            for _, child in pairs(PlacementAreas:GetChildren()) do
                print("    -", child.Name, "(" .. child.ClassName .. ")")
            end
        end
        
        print("========================================")
    end,
    
    -- วางที่ตำแหน่งกลาง path โดยตรง
    TestPlaceNearPath = function(slot)
        slot = slot or 1
        local path = GetMapPath()
        if #path == 0 then
            print("❌ ไม่พบ path")
            return
        end
        
        -- หาจุดกลาง path
        local midIndex = math.floor(#path / 2)
        local midPos = path[midIndex]
        
        -- ลองวางที่ offset 8 studs จาก path
        local testPos = midPos + Vector3.new(8, 2, 0)
        print("วางทดสอบที่:", testPos)
        PlaceUnit(slot, testPos)
    end
}

print("[AV AutoPlay] โหลดเสร็จสิ้น!")
print("[AV AutoPlay] === MAIN COMMANDS ===")
print("[AV AutoPlay] _G.AutoPlay.Toggle() - เปิด/ปิด AutoPlay")
print("[AV AutoPlay] _G.AutoPlay.GetStatus() - ดูสถานะทั้งหมด")
print("[AV AutoPlay] _G.AutoPlay.Debug() - ดู Debug info")
print("[AV AutoPlay] === AUTO START ===")
print("[AV AutoPlay] _G.AutoPlay.VoteSkip() - Vote Skip ทันที")
print("[AV AutoPlay] _G.AutoPlay.ToggleAutoStart() - เปิด/ปิด Auto Start")
print("[AV AutoPlay] === CHARM SYSTEM ===")
print("[AV AutoPlay] _G.AutoPlay.EquipCharms() - Equip Charms (วิเคราะห์อัตโนมัติ)")
print("[AV AutoPlay] _G.AutoPlay.ReanalyzeCharms() - Unequip ทั้งหมด แล้ววิเคราะห์ใหม่")
print("[AV AutoPlay] _G.AutoPlay.EquipSingleCharm('CharmId') - Equip Charm เฉพาะตัว")
print("[AV AutoPlay] _G.AutoPlay.UnequipSingleCharm('CharmId') - Unequip Charm เฉพาะตัว")
print("[AV AutoPlay] _G.AutoPlay.GetCharmStatus() - ดูสถานะ Charm")
print("[AV AutoPlay] _G.AutoPlay.ToggleAutoCharm() - เปิด/ปิด Auto Equip Charm")
