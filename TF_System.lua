local Settings = {
    ["Farm Mode"] = "Mob",  -- "Mob", "Rock", "Quest"
    ["Select Mobs"] = {"Yeti", "Diamond Spider", "Prismarine Spider"},
    ["Select Rocks"] = {"Basalt Core", "Basalt Rock"},
    ["Select Quest"] = "",  -- ใส่ชื่อ NPC หรือ Special Quest เช่น "Greedy Cey", "Prismatic Pickaxe", "Dragon Head Pickaxe"
    ["Use Potions"] = true,  -- เปิด/ปิดใช้ Potion อัตโนมัติ
    ["Ignore Forge Rarity"] = {
        "Mythic",
        "Relic",
        "Exotic",
        "Divine",
        "Unobtainable",
    },
    ["Ignore Ore Rarity"] = {
        "Mythic",
        "Relic",
        "Exotic",
        "Divine",
        "Unobtainable",
    },
}

local Url = "https://api.championshop.date"
local Auto_Configs = true
local IsTest = false
local MainSettings = {
    ["Path"] = "/api/v1/shop/orders/",
    ["Path_Cache"] = "/api/v1/shop/orders/cache/",
    ["Path_Kai"] = "/api/v1/shop/accountskai/",
}

local Changes = {
    ["865c696c-6751-4a38-a1c0-f64bd1d6dbee"] = function()
        Settings["Farm Mode"] = "Rock"
        Settings["Select Rocks"] = {"Pebble"}
        Settings["Use Potions"] = true
        Settings["Ignore Forge Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
        Settings["Ignore Ore Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
    end,
    ["648b89ea-cddf-4a95-9c9a-3ee57e70a369"] = function()
        Settings["Farm Mode"] = "Rock"
        Settings["Select Rocks"] = {"Pebble"}
        Settings["Use Potions"] = true
        Settings["Ignore Forge Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
        Settings["Ignore Ore Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
    end,
    ["764ccf8c-78dd-4701-b529-2dc3ea6446cc"] = function()
        Settings["Farm Mode"] = "Rock"
        Settings["Select Rocks"] = {"Pebble"}
        Settings["Use Potions"] = true
        Settings["Ignore Forge Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
        Settings["Ignore Ore Rarity"] = {
            "Mythic",
            "Relic",
            "Exotic",
            "Divine",
            "Unobtainable",
        }
    end,
    ["3a1fae3e-1efe-4df9-88c5-af1b36077692"] = function()
        Settings["Farm Mode"] = "Mob"
        Settings["Select Mobs"] = {"Zombie"}
        Settings["Use Potions"] = true
    end,
    ["0f7ac08a-4267-44d7-a235-6fd0ae26e723"] = function()
        Settings["Farm Mode"] = "Mob"
        Settings["Select Mobs"] = {"Zombie"}
        Settings["Use Potions"] = true
    end,
    ["00f8cd69-bfbe-4dce-9289-ed01082bc60f"] = function()
        Settings["Farm Mode"] = "Mob"
        Settings["Select Mobs"] = {"Zombie"}
        Settings["Use Potions"] = true
    end,
    ["a218ed37-e05b-427c-9a00-cb878ad09039"] = function()
        Settings["Farm Mode"] = "Quest"
        Settings["Select Quest"] = ""
        Settings["Use Potions"] = true
    end,
}

-- Rarity Ranking Table (สูงกว่า = ดีกว่า)
local RarityRank = {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Epic"] = 4,
    ["Legendary"] = 5,
    ["Mythic"] = 6,
    ["Relic"] = 7,
    ["Exotic"] = 8,
    ["Divine"] = 9,
    ["Unobtainable"] = 10,
}

-- Function หา Rarity Rank (ถ้าไม่รู้จักให้ return 0)
local function GetRarityRank(rarity)
    return RarityRank[rarity] or 0
end

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

repeat
    task.wait(15)
until getrenv()._G.ClientIsReady
_G.IMDONE = true
task.wait(2)

task.spawn(function()
    pcall(function()
        local ClaimRemote = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DailyLoginService"):WaitForChild("RF"):WaitForChild("Claim")
        for i = 1, 7 do
            pcall(function()
                ClaimRemote:InvokeServer(i)
            end)
            task.wait(0.3)
        end
        task.wait(0.5)
        pcall(function()
            local DailyLoginUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DailyLogin")
            if DailyLoginUI then
                DailyLoginUI:Destroy()
            end
        end)
    end)
end)

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    while true do
        task.wait(30)
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Client = Players.LocalPlayer

local function Get(Url)
    local Data = request({
        ["Url"] = Url,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    return Data
end
local function Fetch_data()
    local Data = Get(Url ..MainSettings["Path"] .. Client.Name)
    if not Data["Success"] then
        return false
    end
    local Order_Data = HttpService:JSONDecode(Data["Body"])
    return Order_Data["data"][1]
end
if not Fetch_data() and not IsTest then
    Client:Kick("Cannot Get Data")
end
local function DecBody(body)
    return HttpService:JSONDecode(body["Body"])["data"]
end
local function CreateBody(...)
    local Order_Data = Fetch_data()
    local body = {
        ["order_id"] = Order_Data["id"],
    }
    local array = {...}
    for i,v in pairs(array) do
        for i1,v1 in pairs(v) do
            body[i1] = v1
        end
    end
    return body
end
local function Post(Url,...)
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
    return response
end
local function Auto_Config(id)
    if Auto_Configs and not IsTest then
        local OrderData = Fetch_data()
        if OrderData then
            Key = OrderData["id"]
        else
            print("Cannot Fetch Data")
            return false;
        end
        if id then
            if Changes[id] then
                Changes[id]()
                print("Changed Configs")
            end 
            return false
        else
            print(OrderData["product_id"],Changes[OrderData["product_id"]])
            if Changes[OrderData["product_id"]] then
                Changes[OrderData["product_id"]]()
                print("Changed Configs")
            end 
        end
        local Insert = {}
        for i,v in pairs(OrderData["selected_items"]) do
            print(v.name)
            table.insert(Insert,v.name)
        end
        if #Insert > 0 then
            Settings["Select Rocks"] = Insert
            Settings["Select Mobs"] = Insert
            Settings["Select Quest"] = Insert
        end
        
        task.spawn(function()
            while true do
                pcall(function()
                    local UpdatedOrderData = Fetch_data()
                    if UpdatedOrderData and UpdatedOrderData["selected_items"] then
                        local NewInsert = {}
                        for i,v in pairs(UpdatedOrderData["selected_items"]) do
                            table.insert(NewInsert, v.name)
                        end
                        if #NewInsert > 0 then
                            -- เช็คว่ามีการเปลี่ยนแปลงหรือไม่
                            local hasChanged = false
                            if #NewInsert ~= #Settings["Select Rocks"] then
                                hasChanged = true
                            else
                                for i, name in ipairs(NewInsert) do
                                    if Settings["Select Rocks"][i] ~= name then
                                        hasChanged = true
                                        break
                                    end
                                end
                            end
                            
                            if hasChanged then
                                Settings["Select Rocks"] = NewInsert
                                Settings["Select Mobs"] = NewInsert
                                print("[Auto_Config] Updated selected_items:", table.concat(NewInsert, ", "))
                            end
                        end
                    end
                end)
                task.wait(10) -- เช็คทุก 10 วินาที (ปรับได้ตามต้องการ)
            end
        end)
        
        task.spawn(function()
            while true do
                pcall(function()
                    local OrderData = Fetch_data()
                    if OrderData then
                        local Product = OrderData["product"]
                        local Goal = Product["condition"]["value"]
                        if Product["condition"]["type"] == "level" then
                            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                                Post(Url..MainSettings["Path"] .. "finished")
                            end
                        elseif Product["condition"]["type"] == "character" then
                            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                                Post(Url..MainSettings["Path"] .. "finished")
                            end
                        elseif Product["condition"]["type"] == "items" then
                            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                                Post(Url..MainSettings["Path"] .. "finished")
                            end
                        elseif Product["condition"]["type"] == "hour" then
                            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])/60/60) then
                                Post(Url..MainSettings["Path"] .. "finished")
                            end
                        elseif Product["condition"]["type"] == "round" then
                            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["target_value"])) then
                                Post(Url..MainSettings["Path"] .. "finished")
                            end
                        end
                    end
                end)
                task.wait(30)
            end
        end)
    end
end

Auto_Config()

local Plr = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local _ok, _res = pcall(function()
    return require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("DailyLogin"))
end)
local DailyLogin = nil
if _ok then
    DailyLogin = _res
else
    warn("[TF_System] Failed to require DailyLogin:", _res)
end

if DailyLogin then
    for k, v in pairs(DailyLogin) do
        print(k, typeof(v))
    end

    -- ถ้ามี Close ให้เรียกแบบ pcall เพื่อกัน error จากการทำงานภายใน
    if type(DailyLogin.Close) == "function" then
        pcall(function()
            DailyLogin.Close()
        end)
    end
end

local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))
local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local Ores = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Ore"))


local PlayerController = Knit.GetController("PlayerController")
local PlayerService = Knit.GetService("PlayerService")
local ChangeSequence = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("ChangeSequence")

-- ===== TWEEN SPEED CONFIG =====
local TWEEN_SPEED = 100  -- studs/วินาที (ลดจาก 150 เพื่อหลีก Anti-TP)

-- ===== ANTI-EXPLOIT BYPASS =====
-- หา PlayerController ที่มี Replica.Data
local function BypassAntiExploit()
    pcall(function()
        -- ใช้แค่ BypassTime เท่านั้น ไม่ยุ่งกับ AntiTP
        if PlayerController and PlayerController.Replica and PlayerController.Replica.Data then
            if PlayerController.Replica.Data.SessionData and PlayerController.Replica.Data.SessionData.AntiExploit then
                PlayerController.Replica.Data.SessionData.AntiExploit.BypassTime = time()
            end
        end
    end)
end

-- ฟังก์ชันเดินทีละนิด (Step Teleport) เพื่อหลีก AntiExploit
local function StepTeleport(targetPos, stepSize)
    stepSize = stepSize or 20  -- ขยับทีละ 20 studs
    local character = Client.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local startPos = hrp.Position
    local direction = (targetPos - startPos).Unit
    local distance = (targetPos - startPos).Magnitude
    local steps = math.ceil(distance / stepSize)
    
    for i = 1, steps do
        if not character or not character.Parent then return false end
        hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        
        local nextPos
        if i == steps then
            nextPos = targetPos
        else
            nextPos = startPos + direction * (stepSize * i)
        end
        
        BypassAntiExploit()
        hrp.CFrame = CFrame.new(nextPos)
        task.wait(0.03)  -- รอสั้นๆ ระหว่างแต่ละ step
    end
    
    return true
end

-- ฟังก์ชัน Tween แบบ Safe (bypass ตลอดทาง)
local function SafeTween(targetCFrame, speed)
    local character = Client.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    speed = speed or TWEEN_SPEED
    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    local tweenTime = distance / speed
    
    -- Bypass ก่อนเริ่ม Tween
    BypassAntiExploit()
    
    local tween = TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    
    -- Bypass ตลอดเวลาที่ Tween
    local bypassConnection
    bypassConnection = game:GetService("RunService").Heartbeat:Connect(function()
        BypassAntiExploit()
    end)
    
    tween:Play()
    tween.Completed:Wait()
    
    -- หยุด bypass
    if bypassConnection then
        bypassConnection:Disconnect()
    end
    
    -- Bypass อีกครั้งหลัง Tween เสร็จ
    BypassAntiExploit()
    
    return true
end

-- Wrapper function สำหรับ teleport แบบ safe
local function SafeTeleport(targetCFrame)
    local character = Client.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    BypassAntiExploit()
    task.wait(0.05)  -- รอให้ bypass มีผล
    hrp.CFrame = targetCFrame
    BypassAntiExploit()  -- bypass อีกครั้งหลัง teleport
    return true
end

-- ===== REMOTES =====
local ToolActivated = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated")
local DialogueRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue")
local DialogueEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent")
local RunCommand = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand")
local PurchaseRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Purchase")
local PartyActivate = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PartyService"):WaitForChild("RF"):WaitForChild("Activate")
local ProximityFunctionals = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Functionals")

-- ===== QUEST DATA =====
local QuestData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Quests"))

-- ===== QUEST COMPLETION TRACKING =====
_G.CompletedQuestsLog = _G.CompletedQuestsLog or {}  -- เก็บ Quest ที่เสร็จแล้วสำหรับ TF_Log

local InsertEquipments = {}
for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
    table.insert(InsertEquipments,v["GUID"])
end

local HasTalkedToMarbles = false
local HasTalkedToGreedyCey = false

-- ===== SAFE HEIGHT FOR MOB FARM =====
local SafeHeightOffset = 0
local MAX_SAFE_HEIGHT = 5

PlayerController.Replica:OnWrite("GiveItem", function(t, v)
    print(t,v)
    if type(t) == "table" then
        task.wait(2)
        RunCommand:InvokeServer("SellConfirm", {
            Basket = {
                [t["GUID"]] = true,
            }
        })
    end
end)
local function GetOre(Name)
    -- ลองหาจาก Name ก่อน
    for i, v in pairs(Ores) do
        if v["Name"] == Name then
            return v
        end
    end
    -- ลองหาจาก key (ID)
    if Ores[Name] then
        return Ores[Name]
    end
    return false
end

local function GetRecipe()
    local Recipe = {}
    local Count = 0
    local HowMany = 0
    
    -- เก็บแร่ที่ใช้ได้ทั้งหมดพร้อมจำนวน
    local availableOres = {}
    for oreName, oreAmount in pairs(PlayerController.Replica.Data.Inventory) do
        if type(oreAmount) == "number" and oreAmount > 0 then
            local Ore = GetOre(oreName)
            if Ore then
                local rarity = Ore["Rarity"]
                -- เช็คว่าไม่อยู่ใน Ignore list
                if not table.find(Settings["Ignore Forge Rarity"], rarity) then
                    table.insert(availableOres, {
                        name = oreName,
                        amount = oreAmount,
                        rarity = rarity
                    })
                    -- print("[Forge] Found ore:", oreName, "x", oreAmount, "[", rarity, "]")
                else
                    -- print("[Forge] Ignored ore:", oreName, "x", oreAmount, "[", rarity, "] - in ignore list")
                end
            else
                -- Debug: แสดง item ที่ไม่พบใน Ore data
                -- if oreName ~= "Equipments" and oreName ~= "FavoritedItems" then
                --     print("[Forge] Unknown item:", oreName, "x", oreAmount, "- not in Ore data")
                -- end
            end
        end
    end
    
    -- เรียงตามจำนวนมากไปน้อย (ใช้แร่ที่มีมากก่อน)
    table.sort(availableOres, function(a, b)
        return a.amount > b.amount
    end)
    
    -- เลือกแร่มากสุด 4 ชนิด
    for _, oreData in ipairs(availableOres) do
        if HowMany >= 4 then break end
        
        Recipe[oreData.name] = oreData.amount
        Count = Count + oreData.amount
        HowMany = HowMany + 1
        -- print("[Forge] Selected:", oreData.name, "x", oreData.amount)
    end
    
    -- print("[Forge] Total:", Count, "ores from", HowMany, "types")
    
    -- ต้องมีแร่อย่างน้อย 3 ชิ้น
    if Count < 3 then
        return false
    else
        return Recipe
    end
end
local function getnearest(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    local maxDist = _G_MaxTeleportDistance or 9999 -- จำกัดระยะ
    
    -- ใช้ GetDescendants เพื่อหาหินทุก level ของ subfolder
    for _, v in pairs(workspace.Rocks:GetDescendants()) do
        -- ใช้ exact match (ชื่อต้องตรงเป๊ะ) เพื่อไม่ให้ตีหินมั่ว
        if v:IsA("Model") and v:GetAttribute("Health") and v:GetAttribute("Health") > 0 and table.find(Settings["Select Rocks"], v.Name) then
            local Pos = v:GetAttribute("OriginalCFrame")
            if Pos then
                local EqPos = (Pos.Position - p_pos).Magnitude
                -- เช็คว่าอยู่ในระยะที่อนุญาต
                if EqPos <= maxDist and dis > EqPos then
                    path = v
                    dis = EqPos
                end
            end
        end
    end
    
    if path then
        print("[getnearest] พบหิน:", path.Name, "ระยะ:", math.floor(dis), "studs (max:", maxDist, ")")
    end
    return path
end

-- ตำแหน่งหลบ mob (Safe Zone) - ปรับตามแมพ
local SafeZonePosition = Vector3.new(0, 1000, 0)

-- ===== WORLD DATA SYSTEM =====
-- ใช้ Pattern Matching จากชื่อ Rock/Mob/NPC เพื่อหาโลกที่ถูกต้อง
-- ข้อมูลจาก forgewiki.org (อัพเดทอัตโนมัติตาม pattern)

-- Pattern สำหรับแต่ละโลก (จาก Wiki)
local WorldPatterns = {
    ["Frostspire Expanse"] = {
        rocks = {"icy", "ice crystal", "floating crystal"},
        mobs = {"spider", "yeti", "orc", "golem", "bjorn", "santa", "prismarine", "diamond"},
        npcs = {"bjorn", "santa"}
    },
    ["Forgotten Kingdom"] = {
        rocks = {"red crystal", "heart of the island"},
        mobs = {"goblin", "wo long", "aida", "zesty"},
        npcs = {"zesty", "aida", "wo long"}
    },
    ["Stonewake's Cross"] = {
        rocks = {"pebble", "rock", "boulder", "lucky", "basalt", "volcanic", "crystal"},
        mobs = {"zombie", "skeleton", "bomber", "reaper", "slime", "miner fred"},
        npcs = {"marbles", "fred", "merchant"}
    }
}

-- ฟังก์ชันหาโลกจากชื่อ item
local function GetWorldFromName(itemName, itemType)
    local lowerName = string.lower(itemName)
    
    -- เช็ค Frostspire Expanse ก่อน (เพราะมี pattern เฉพาะเจาะจง)
    for _, pattern in ipairs(WorldPatterns["Frostspire Expanse"][itemType] or {}) do
        if lowerName:match(pattern) then
            return "Frostspire Expanse"
        end
    end
    
    -- เช็ค Forgotten Kingdom
    for _, pattern in ipairs(WorldPatterns["Forgotten Kingdom"][itemType] or {}) do
        if lowerName:match(pattern) then
            return "Forgotten Kingdom"
        end
    end
    
    -- Default: Stonewake's Cross
    return "Stonewake's Cross"
end

-- ดึงข้อมูล Rocks จาก Game โดยตรง (Scan workspace)
local function FetchRocksFromWiki()
    local rocksData = {
        ["Stonewake's Cross"] = {},
        ["Forgotten Kingdom"] = {},
        ["Frostspire Expanse"] = {}
    }
    
    -- Scan จาก workspace.Rocks
    local Rocks = workspace:FindFirstChild("Rocks")
    if Rocks then
        for _, rock in pairs(Rocks:GetDescendants()) do
            if rock:IsA("Model") and rock:GetAttribute("Health") then
                local world = GetWorldFromName(rock.Name, "rocks")
                if not table.find(rocksData[world], rock.Name) then
                    table.insert(rocksData[world], rock.Name)
                end
            end
        end
    end
    
    -- ถ้าไม่มี rock ในแมพ ใช้ default list
    local totalRocks = #rocksData["Stonewake's Cross"] + #rocksData["Forgotten Kingdom"] + #rocksData["Frostspire Expanse"]
    if totalRocks == 0 then
        -- Default rocks จาก Wiki
        rocksData["Stonewake's Cross"] = {"Pebble", "Rock", "Boulder", "Lucky Block", "Basalt Rock", "Basalt Core", "Basalt Vein", "Volcanic Rock", "Crystals"}
        rocksData["Forgotten Kingdom"] = {"Small Red Crystal", "Medium Red Crystal", "Large Red Crystal", "Heart Of The Island"}
        rocksData["Frostspire Expanse"] = {"Icy Pebble", "Icy Rock", "Icy Boulder", "Small Ice Crystal", "Medium Ice Crystal", "Large Ice Crystal", "Floating Crystal"}
    end
    
    print("[World Data] Rocks loaded:", 
        #rocksData["Stonewake's Cross"], "Stonewake's Cross,",
        #rocksData["Forgotten Kingdom"], "Forgotten Kingdom,",
        #rocksData["Frostspire Expanse"], "Frostspire Expanse")
    
    return rocksData
end

-- ดึงข้อมูล Enemies จาก Game โดยตรง (Scan workspace)
local function FetchMobsFromWiki()
    local mobsData = {
        ["Stonewake's Cross"] = {},
        ["Forgotten Kingdom"] = {},
        ["Frostspire Expanse"] = {}
    }
    
    -- Scan จาก workspace.Living
    local Living = workspace:FindFirstChild("Living")
    if Living then
        for _, mob in pairs(Living:GetChildren()) do
            if mob:IsA("Model") then
                local world = GetWorldFromName(mob.Name, "mobs")
                if not table.find(mobsData[world], mob.Name) then
                    table.insert(mobsData[world], mob.Name)
                end
            end
        end
    end
    
    -- ถ้าไม่มี mob ในแมพ ใช้ default list
    local totalMobs = #mobsData["Stonewake's Cross"] + #mobsData["Forgotten Kingdom"] + #mobsData["Frostspire Expanse"]
    if totalMobs == 0 then
        -- Default mobs จาก Wiki
        mobsData["Stonewake's Cross"] = {"Zombie", "Skeleton", "Bomber", "Reaper", "Slime", "Miner Fred"}
        mobsData["Forgotten Kingdom"] = {"Goblin", "Wo Long", "Aida", "Zesty"}
        mobsData["Frostspire Expanse"] = {"Spider", "Yeti", "Orc", "Golem", "Prismarine Spider", "Diamond Spider"}
    end
    
    print("[World Data] Mobs loaded:", 
        #mobsData["Stonewake's Cross"], "Stonewake's Cross,",
        #mobsData["Forgotten Kingdom"], "Forgotten Kingdom,",
        #mobsData["Frostspire Expanse"], "Frostspire Expanse")
    
    return mobsData
end

-- ดึงข้อมูล NPCs จาก Game โดยตรง (Scan workspace)
local function FetchNPCsFromWiki()
    local npcsData = {
        ["Stonewake's Cross"] = {},
        ["Forgotten Kingdom"] = {},
        ["Frostspire Expanse"] = {}
    }
    
    -- Scan จาก workspace.NPCs หรือ workspace.Proximity
    local NPCs = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Proximity")
    if NPCs then
        for _, npc in pairs(NPCs:GetDescendants()) do
            if npc:IsA("Model") or (npc:IsA("BasePart") and npc:FindFirstChild("ProximityPrompt")) then
                local world = GetWorldFromName(npc.Name, "npcs")
                if not table.find(npcsData[world], npc.Name) then
                    table.insert(npcsData[world], npc.Name)
                end
            end
        end
    end
    
    -- ถ้าไม่มี NPC ในแมพ ใช้ default list
    local totalNPCs = #npcsData["Stonewake's Cross"] + #npcsData["Forgotten Kingdom"] + #npcsData["Frostspire Expanse"]
    if totalNPCs == 0 then
        -- Default NPCs จาก Wiki
        npcsData["Stonewake's Cross"] = {"Marbles", "Miner Fred", "Merchant", "Greedy Cey"}
        npcsData["Forgotten Kingdom"] = {"Zesty", "Aida", "Wo Long"}
        npcsData["Frostspire Expanse"] = {"Bjorn", "Santa"}
    end
    
    print("[World Data] NPCs loaded:", 
        #npcsData["Stonewake's Cross"], "Stonewake's Cross,",
        #npcsData["Forgotten Kingdom"], "Forgotten Kingdom,",
        #npcsData["Frostspire Expanse"], "Frostspire Expanse")
    
    return npcsData
end

-- Auto Detect โลกจากชื่อ Rock (ใช้ข้อมูลจาก Wiki API)
local function GetRockWorld(rockName)
    local rocksData = FetchRocksFromWiki()
    
    -- เช็คแต่ละโลก
    for world, rocks in pairs(rocksData) do
        for _, rock in ipairs(rocks) do
            if rock == rockName or string.lower(rock) == string.lower(rockName) then
                return world
            end
        end
    end
    
    -- Fallback: ใช้ pattern matching ถ้าไม่เจอใน API
    local lowerName = string.lower(rockName)
    if lowerName:match("icy") or lowerName:match("ice") or lowerName:match("frost") or lowerName:match("floating") then
        return "Frostspire Expanse"
    elseif lowerName:match("red crystal") or lowerName:match("heart of the island") then
        return "Forgotten Kingdom"
    elseif lowerName:match("basalt") or lowerName:match("volcanic") or lowerName:match("pebble") or lowerName:match("boulder") or lowerName:match("lucky") then
        return "Stonewake's Cross"
    end
    
    return "Stonewake's Cross"
end

-- Auto Detect โลกจากชื่อ Mob (ใช้ข้อมูลจาก Wiki API)
local function GetMobWorld(mobName)
    local mobsData = FetchMobsFromWiki()
    
    -- เช็คแต่ละโลก
    for world, mobs in pairs(mobsData) do
        for _, mob in ipairs(mobs) do
            if mob == mobName or string.lower(mob) == string.lower(mobName) then
                return world
            end
        end
    end
    
    -- Fallback: ใช้ pattern matching
    local lowerName = string.lower(mobName)
    if lowerName:match("spider") or lowerName:match("yeti") or lowerName:match("orc") or lowerName:match("golem") then
        return "Frostspire Expanse"
    elseif lowerName:match("goblin") then
        return "Forgotten Kingdom"
    end
    
    return "Stonewake's Cross"
end

-- Auto Detect โลกจากชื่อ NPC (ใช้ข้อมูลจาก Wiki API)
local function GetNPCWorld(npcName)
    local npcsData = FetchNPCsFromWiki()
    
    -- เช็คแต่ละโลก
    for world, npcs in pairs(npcsData) do
        for _, npc in ipairs(npcs) do
            if npc == npcName or string.lower(npc) == string.lower(npcName) then
                return world
            end
        end
    end
    
    return "Stonewake's Cross"
end

-- ===== AUTO SCAN ROCKS IN MAP =====
local function ScanRocksInMap()
    local rocksByWorld = {}
    local Rocks = workspace:FindFirstChild("Rocks")
    if not Rocks then return rocksByWorld end
    
    for _, rock in pairs(Rocks:GetDescendants()) do
        if rock:IsA("Model") and rock:GetAttribute("Health") then
            local world = GetRockWorld(rock.Name)
            if not rocksByWorld[world] then
                rocksByWorld[world] = {}
            end
            if not table.find(rocksByWorld[world], rock.Name) then
                table.insert(rocksByWorld[world], rock.Name)
            end
        end
    end
    
    return rocksByWorld
end

-- ===== AUTO SCAN MOBS IN MAP =====
local function ScanMobsInMap()
    local mobsByWorld = {}
    local Living = workspace:FindFirstChild("Living")
    if not Living then return mobsByWorld end
    
    for _, mob in pairs(Living:GetChildren()) do
        if mob:IsA("Model") then
            local world = GetMobWorld(mob.Name)
            if not mobsByWorld[world] then
                mobsByWorld[world] = {}
            end
            if not table.find(mobsByWorld[world], mob.Name) then
                table.insert(mobsByWorld[world], mob.Name)
            end
        end
    end
    
    return mobsByWorld
end

-- ===== AUTO DETECT REQUIRED WORLD =====
local function GetRequiredWorldForRock()
    if not Settings["Select Rocks"] or #Settings["Select Rocks"] == 0 then
        return nil
    end
    return GetRockWorld(Settings["Select Rocks"][1])
end

local function GetRequiredWorldForMob()
    if not Settings["Select Mobs"] or #Settings["Select Mobs"] == 0 then
        return nil
    end
    return GetMobWorld(Settings["Select Mobs"][1])
end

-- Preload Wiki Data เมื่อ script เริ่มทำงาน
task.spawn(function()
    print("[Wiki API] Preloading data from forgewiki.org...")
    pcall(FetchRocksFromWiki)
    pcall(FetchMobsFromWiki)
    pcall(FetchNPCsFromWiki)
    print("[Wiki API] Preload complete!")
end)

-- ฟังก์ชันตรวจสอบโลกปัจจุบันจากเกมจริง
local function GetCurrentWorld()
    -- ใช้ PlayerController.Replica.Data.World โดยตรง (วิธีที่แม่นยำที่สุด)
    local currentWorld = nil
    
    pcall(function()
        if PlayerController and PlayerController.Replica and PlayerController.Replica.Data then
            currentWorld = PlayerController.Replica.Data.World
        end
    end)
    
    if currentWorld then
        return currentWorld
    end
    
    -- Fallback: ถ้าไม่มีข้อมูลจาก PlayerController ให้ return nil
    print("[World] ไม่สามารถตรวจสอบโลกปัจจุบันจาก PlayerController")
    return nil
end

local _G_LastWorldTeleport = 0 -- cooldown สำหรับ TeleportToWorld
local _G_CurrentWorld = nil -- เก็บโลกปัจจุบัน (ไม่มี default - ให้อยู่โลกปัจจุบันเป็นหลัก)
local _G_LockedTarget = nil -- เป้าหมายที่ล็อคไว้ (Rock/Mob)
local _G_LastTargetTime = 0 -- เวลาที่ล็อคเป้าหมายล่าสุด
local _G_LastWorldCheck = 0 -- เวลาที่เช็คโลกล่าสุด

-- Remote สำหรับ Portal
local PortalService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PortalService"):WaitForChild("RF"):WaitForChild("TeleportToIsland")

-- สุ่มหาตำแหน่งวาง Portal ที่เหมาะสม (ไม่โดนบล็อก)
local function FindRandomPlacePosition()
    local Char = Plr.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = Char.HumanoidRootPart
    local basePos = hrp.Position
    
    -- สุ่มตำแหน่งรอบๆ ผู้เล่น
    local angles = {0, 45, 90, 135, 180, 225, 270, 315}
    local distances = {5, 8, 10, 15}
    
    for _, dist in ipairs(distances) do
        for _, angle in ipairs(angles) do
            local rad = math.rad(angle)
            local offsetX = math.cos(rad) * dist
            local offsetZ = math.sin(rad) * dist
            local testPos = Vector3.new(basePos.X + offsetX, basePos.Y, basePos.Z + offsetZ)
            
            -- ทดสอบว่าตำแหน่งนี้ว่างหรือไม่ (Raycast ลงพื้น)
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {Char}
            
            local rayResult = workspace:Raycast(testPos + Vector3.new(0, 5, 0), Vector3.new(0, -10, 0), rayParams)
            if rayResult then
                -- มีพื้นรองรับ
                return CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
            end
        end
    end
    
    -- Fallback: ใช้ตำแหน่งผู้เล่นปัจจุบัน
    return hrp.CFrame
end

local function TeleportToWorld(worldName)
    print("[World] TeleportToWorld เริ่มทำงาน - ต้องการไป:", worldName)
    
    -- ถ้ายังอยู่ใน cooldown ให้รอ
    local cooldownRemaining = _G_LastWorldTeleport - tick()
    if cooldownRemaining > 0 then 
        print("[World] รอ cooldown อีก", math.ceil(cooldownRemaining), "วินาที")
        return false 
    end
    
    -- ถ้ายังอยู่ใน respawn cooldown ห้ามวาร์ป
    if _G_RespawnCooldown and tick() < _G_RespawnCooldown then
        print("[World] ยังอยู่ใน respawn cooldown ห้ามวาร์ป")
        return false
    end
    
    local Char = Plr.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then 
        print("[World] ไม่พบ Character")
        return false 
    end
    
    print("[World] ผ่านการเช็คทั้งหมด - เริ่มวาร์ปไป:", worldName)
    
    -- Bypass AntiExploit
    BypassAntiExploit()
    
    -- Step 1: สุ่มหาตำแหน่งวาง Portal
    local placePos = FindRandomPlacePosition()
    if placePos then
        print("[World] Step 1: สุ่มตำแหน่งวาง Portal:", placePos.Position)
        BypassAntiExploit()
        Char.HumanoidRootPart.CFrame = placePos
        task.wait(0.5)
    end
    
    -- Step 2: วาง PortalTool
    print("[World] Step 2: วาง PortalTool...")
    local placeSuccess, placeError = pcall(function()
        ToolActivated:InvokeServer("PortalTool")
    end)
    print("[World] PortalTool InvokeServer:", placeSuccess and "สำเร็จ" or ("ล้มเหลว: " .. tostring(placeError)))
    task.wait(2)
    
    -- Step 3: หา Portal ที่วางไว้ใน workspace.Debris
    local portal = nil
    local Debris = workspace:FindFirstChild("Debris")
    if Debris then
        print("[World] Step 3: หา Portal ใน Debris...")
        for _, obj in pairs(Debris:GetDescendants()) do
            local objName = string.lower(obj.Name)
            if objName:match("portal") or objName:match("theforge") then
                portal = obj
                print("[World] พบ Portal:", obj.Name, obj.ClassName)
                break
            end
        end
    end
    
    if not portal then
        print("[World] ไม่พบใน Debris - ลองหาใน workspace...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "PortalTheForge" or obj.Name:match("Portal") then
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    portal = obj
                    print("[World] พบ Portal ใน workspace:", obj.Name)
                    break
                end
            end
        end
    end
    
    -- Step 4: วาร์ปไปที่ Portal และ Interact
    if portal then
        local portalPos
        if portal:IsA("Model") then
            portalPos = portal:GetPivot().Position
        elseif portal:IsA("BasePart") then
            portalPos = portal.Position
        end
        
        if portalPos then
            print("[World] Step 4: วาร์ปไปที่ Portal ตำแหน่ง:", portalPos)
            BypassAntiExploit()
            Char.HumanoidRootPart.CFrame = CFrame.new(portalPos)
            task.wait(0.5)
            
            -- หา ProximityPrompt ใน Portal แล้ว trigger
            local prompt = portal:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                print("[World] Step 4b: พบ ProximityPrompt - triggering...")
                fireproximityprompt(prompt)
                task.wait(1)
            else
                -- ลอง Interact ด้วย ProximityFunctionals
                print("[World] Step 4b: Interact กับ Portal...")
                pcall(function()
                    ProximityFunctionals:InvokeServer(portal)
                end)
                task.wait(0.5)
                
                -- ลอง Dialogue ด้วย
                pcall(function()
                    DialogueRemote:InvokeServer(portal)
                end)
                task.wait(0.5)
            end
        end
    else
        print("[World] ไม่พบ Portal - ข้ามไปใช้ TeleportToIsland โดยตรง")
    end
    
    -- Step 5: ใช้ TeleportToIsland เพื่อวาร์ปไปแมพที่ต้องการ
    print("[World] Step 5: TeleportToIsland ->", worldName)
    local success, teleportError = pcall(function()
        PortalService:InvokeServer(worldName)
    end)
    print("[World] TeleportToIsland InvokeServer:", success and "สำเร็จ" or ("ล้มเหลว: " .. tostring(teleportError)))
    
    -- รอและเช็คว่าวาร์ปสำเร็จหรือไม่
    task.wait(3)
    
    if success then
        _G_CurrentWorld = worldName
        _G_LastWorldTeleport = tick() + 15
        print("[World] วาร์ปสำเร็จไป:", worldName)
        task.wait(5) -- รอให้วาร์ปเสร็จ (เพิ่มเวลารอ)
        return true
    else
        print("[World] วาร์ปล้มเหลว:", worldName)
        _G_LastWorldTeleport = tick() + 10
        return false
    end
end

local function GoToSafeZone()
    local Char = Plr.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    
    print("[Farm] ไม่มีหินตาม list ที่ตีได้ในแมพ - ไปยืนหลบ mob")
    
    local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(SafeZonePosition)
    })
    tween:Play()
    tween.Completed:Wait()
    print("[Farm] ยืนหลบ mob รอหินเกิดใหม่...")
    task.wait(3)
end

local function getNearestMob(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    local maxDist = _G_MaxTeleportDistance or 9999 -- จำกัดระยะ
    
    local Living = workspace:FindFirstChild("Living")
    if not Living then return nil end
    
    for _, mob in pairs(Living:GetChildren()) do
        if mob:IsA("Model") then
            local Humanoid = mob:FindFirstChildOfClass("Humanoid")
            local HRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
            
            if Humanoid and HRP and Humanoid.Health > 0 then
                local canFarm = false
                
                if #Settings["Select Mobs"] == 0 then
                    canFarm = true
                else
                    for _, targetName in pairs(Settings["Select Mobs"]) do
                        if string.sub(mob.Name, 1, #targetName) == targetName then
                            canFarm = true
                            break
                        end
                    end
                end
                
                if canFarm then
                    local EqPos = (HRP.Position - p_pos).Magnitude
                    -- เช็คว่าอยู่ในระยะที่อนุญาต
                    if EqPos <= maxDist and dis > EqPos then
                        path = mob
                        dis = EqPos
                    end
                end
            end
        end
    end
    
    if path then
        print("[getNearestMob] พบ:", path.Name, "ระยะ:", math.floor(dis), "studs (max:", maxDist, ")")
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

-- ===== POTION SYSTEM =====
-- Potion Buff Tracking
local PotionBuffs = {
    Health = { lastUsed = 0, duration = 3 },        -- Health Potion (3 วินาที - เช็คบ่อย)
    Damage = { lastUsed = 0, duration = 60 },       -- Damage Potion (1 นาที)
    Miner = { lastUsed = 0, duration = 300 },       -- Miner Potion (5 นาที)
    Luck = { lastUsed = 0, duration = 300 },        -- Luck Potion (5 นาที)
}

-- Potion Names ที่ใช้กับ ToolActivated และ Purchase
local PotionNames = {
    Health = "HealthPotion2",      -- Health Potion II
    Damage = "AttackDamagePotion1",      -- Damage Potion I
    Miner = "MinerPotion1",        -- Miner Potion I
    Luck = "LuckPotion1",          -- Luck Potion I
}

-- Potion Stack Limit (รวมทุกชนิด)
local POTION_STACK_LIMIT = 16

-- จำนวน Potion ที่ต้องการมีเป้าหมาย (Target)
-- ⚠️ รวมกันต้องไม่เกิน POTION_STACK_LIMIT (16)
local PotionTargetAmount = {
    Health = 6,  -- ต้องการมี Health Potion 6 ขวดเสมอ
    Damage = 4,  -- ต้องการมี Damage Potion 4 ขวดเสมอ
    Miner = 3,   -- ต้องการมี Miner Potion 3 ขวดเสมอ
    Luck = 3,    -- ต้องการมี Luck Potion 3 ขวดเสมอ
}
-- Total Target = 6 + 4 + 3 + 3 = 16 ✅

-- เช็คว่า Target รวมกันไม่เกิน Max Limit
local function ValidatePotionTargets()
    local totalTarget = 0
    for potionType, target in pairs(PotionTargetAmount) do
        totalTarget = totalTarget + target
    end
    
    if totalTarget > POTION_STACK_LIMIT then
        warn("[Potion] ⚠️ WARNING: Total Target (" .. totalTarget .. ") เกิน Max Limit (" .. POTION_STACK_LIMIT .. ")!")
        warn("[Potion] กำลังปรับ Target อัตโนมัติ...")
        
        -- ปรับลด Target ตามสัดส่วน
        local ratio = POTION_STACK_LIMIT / totalTarget
        for potionType, target in pairs(PotionTargetAmount) do
            local newTarget = math.floor(target * ratio)
            if newTarget < 1 then newTarget = 1 end
            PotionTargetAmount[potionType] = newTarget
            print("[Potion] ปรับ", potionType, ":", target, "->", newTarget)
        end
        
        -- คำนวนใหม่หลังปรับ
        totalTarget = 0
        for _, target in pairs(PotionTargetAmount) do
            totalTarget = totalTarget + target
        end
    end
    
    print("[Potion] ✅ Total Target:", totalTarget, "/", POTION_STACK_LIMIT)
    return true
end

-- Map potion names to display names in world
local PotionDisplayNames = {
    ["HealthPotion2"] = "Health Potion II",
    ["AttackDamagePotion1"] = "Damage Potion I",
    ["MinerPotion1"] = "Miner Potion I",
    ["LuckPotion1"] = "Luck Potion I",
}

-- เฉพาะ Potion ที่เราใช้ (4 ชนิด)
local OurPotionNames = {
    "HealthPotion2",
    "AttackDamagePotion1",
    "MinerPotion1",
    "LuckPotion1",
}

local function GetPotionCount(potionName)
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data then return 0 end
    
    -- ลอง Inventory.Misc ก่อน (array of tables)
    local invMisc = replica.Data.Inventory and replica.Data.Inventory.Misc
    if invMisc then
        for _, item in pairs(invMisc) do
            if type(item) == "table" and item.Name == potionName then
                return item.Quantity or 1
            end
        end
    end
    
    -- ลอง Data.Misc (key-value)
    local dataMisc = replica.Data.Misc
    if dataMisc and dataMisc[potionName] then
        return dataMisc[potionName]
    end
    
    return 0
end

local function GetTotalPotionCount()
    -- นับเฉพาะ 4 Potion ที่เราใช้
    local total = 0
    for _, potionName in ipairs(OurPotionNames) do
        total = total + GetPotionCount(potionName)
    end
    return total
end

local function GetAvailablePotionSlots()
    return POTION_STACK_LIMIT - GetTotalPotionCount()
end

-- คำนวนจำนวน Potion ที่ต้องซื้อเพิ่ม (Auto Calculate)
local function CalculatePotionToBuy(potionType)
    local potionName = PotionNames[potionType]
    local targetAmount = PotionTargetAmount[potionType] or 5
    local currentAmount = GetPotionCount(potionName)
    local availableSlots = GetAvailablePotionSlots()
    
    -- ถ้ามีเกิน/เท่ากับ target แล้ว ไม่ต้องซื้อ
    if currentAmount >= targetAmount then
        return 0
    end
    
    -- คำนวนจำนวนที่ต้องซื้อเติม
    local needToBuy = targetAmount - currentAmount
    
    -- จำกัดตาม slot ที่ว่าง
    local actualBuy = math.min(needToBuy, availableSlots)
    
    print("[Potion] 📊", potionType, "- มี:", currentAmount, "| เป้า:", targetAmount, "| ต้องซื้อ:", needToBuy, "| ซื้อได้:", actualBuy, "(slot ว่าง", availableSlots, ")")
    
    return actualBuy
end

-- แสดงสถานะ Potion ทั้งหมด
local function PrintPotionStatus()
    print("========== POTION STATUS ==========")
    for potionType, potionName in pairs(PotionNames) do
        local current = GetPotionCount(potionName)
        local target = PotionTargetAmount[potionType] or 5
        local status = current >= target and "✅" or "⚠️"
        print(status, potionType, ":", current, "/", target)
    end
    print("Total:", GetTotalPotionCount(), "/", POTION_STACK_LIMIT)
    print("====================================")
end

-- เรียก Validate ตอนเริ่มต้น
ValidatePotionTargets()

local function FindPotionInWorld(potionName)
    local displayName = PotionDisplayNames[potionName] or potionName
    
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name
        if name == potionName or name == displayName or 
           string.find(name:lower(), potionName:lower()) or
           string.find(name:lower(), displayName:lower()) then
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if obj:IsA("Model") and obj.PrimaryPart then
                    return obj.PrimaryPart
                elseif obj:IsA("Model") then
                    return obj:FindFirstChildWhichIsA("BasePart")
                else
                    return obj
                end
            end
        end
    end
    return nil
end

local function BuyPotion(potionName, amount)
    amount = amount or 1
    
    local Char = Plr.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then 
        print("[Potion] ไม่มีตัวละคร - ยกเลิกการซื้อ")
        return false 
    end
    
    -- Check available slots
    local availableSlots = GetAvailablePotionSlots()
    if availableSlots <= 0 then
        print("[Potion] Inventory เต็ม! (", GetTotalPotionCount(), "/", POTION_STACK_LIMIT, ")")
        return false
    end
    
    -- Limit amount to available slots
    local actualAmount = math.min(amount, availableSlots)
    if actualAmount < amount then
        print("[Potion] ปรับจำนวนเป็น", actualAmount, "ขวด (เหลือที่ว่าง", availableSlots, ")")
    end
    
    -- Find Potion in world
    local potionPart = FindPotionInWorld(potionName)
    if not potionPart then
        print("[Potion] ❌ ไม่พบ", potionName, "ใน world!")
        return false
    end
    
    local potionPos = potionPart.Position
    local targetPos = potionPos + Vector3.new(0, 0, 2)
    local dist = (Char.HumanoidRootPart.Position - targetPos).Magnitude
    local maxDist = _G_MaxTeleportDistance or 9999
    
    -- เช็คระยะก่อนวาร์ป
    if dist > maxDist then
        print("[Potion] ⚠️ ร้าน Potion อยู่ไกลเกินไป (", math.floor(dist), "studs) - ข้ามไปก่อน")
        return false
    end
    
    print("[Potion] ✓ พบ", potionName, "ระยะ", math.floor(dist), "studs - กำลังวาร์ปไปซื้อ...")
    
    -- ใช้ Tween เสมอถ้าระยะ > 20 studs
    if dist > 20 then
        print("[Potion] ระยะ", math.floor(dist), "studs - ใช้ Tween")
        local tweenSpeed = (dist/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
        BypassAntiExploit()
        local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
    else
        BypassAntiExploit()
        Char.HumanoidRootPart.CFrame = CFrame.new(targetPos, potionPos)
    end
    task.wait(0.3)
    
    -- Buy via Remote
    local countBefore = GetPotionCount(potionName)
    print("[Potion] 🛒 กำลังซื้อ", potionName, "x", actualAmount, "... (มี", countBefore, "อยู่แล้ว, รวม", GetTotalPotionCount(), "/", POTION_STACK_LIMIT, ")")
    
    for i = 1, actualAmount do
        pcall(function()
            PurchaseRemote:InvokeServer(potionName, 1)
        end)
        task.wait(0.3)
    end
    
    task.wait(0.3)
    local countAfter = GetPotionCount(potionName)
    
    local bought = countAfter - countBefore
    if bought > 0 then
        print("[Potion] ✅ ซื้อ", potionName, "x", bought, "สำเร็จ! (รวม", GetTotalPotionCount(), "/", POTION_STACK_LIMIT, ")")
    else
        print("[Potion] ⚠️ ซื้อ", potionName, "ไม่สำเร็จ! (อาจหมด หรือ เงินไม่พอ)")
    end
    
    return bought > 0
end

local function UsePotion(potionType)
    if not Settings["Use Potions"] then return false end
    
    local buff = PotionBuffs[potionType]
    local potionName = PotionNames[potionType]
    
    if not buff or not potionName then return false end
    
    -- เช็คว่า buff หมดหรือยัง
    local currentTime = tick()
    if currentTime - buff.lastUsed < buff.duration then
        return false -- buff ยังอยู่
    end
    
    -- เช็คว่ามี Potion หรือไม่
    local potionCount = GetPotionCount(potionName)
    
    -- ถ้ามี Potion อยู่แล้ว ใช้เลย
    if potionCount > 0 then
        local success = pcall(function()
            ToolActivated:InvokeServer(potionName)
        end)
        
        if success then
            buff.lastUsed = currentTime
            print("[Potion] ใช้", potionType, "Potion สำเร็จ! (เหลือ", potionCount - 1, ")")
            return true
        end
        return false
    end
    
    -- ไม่มี Potion ต้องซื้อ - คำนวนอัตโนมัติ
    print("[Potion] ไม่มี", potionType, "Potion! กำลังคำนวนและซื้อ...")
    
    -- คำนวนจำนวนที่ต้องซื้อ (Auto Calculate)
    local buyAmount = CalculatePotionToBuy(potionType)
    
    if buyAmount <= 0 then
        print("[Potion] ❌ ไม่สามารถซื้อ", potionType, "ได้ (inventory เต็มหรือมีพอแล้ว)")
        buff.lastUsed = currentTime - buff.duration + 30
        return false
    end
    
    print("[Potion] 🛒 คำนวนแล้ว - จะซื้อ", potionType, "x", buyAmount, "ขวด")
    
    local buySuccess = BuyPotion(potionName, buyAmount)
    
    if not buySuccess then
        print("[Potion] ซื้อ", potionType, "Potion ไม่สำเร็จ! (อาจหมด หรือ มีปัญหา)")
        if potionType == "Health" then
            -- Health Potion สำคัญ ลองใหม่เร็วๆ (5 วินาที)
            buff.lastUsed = currentTime - buff.duration + 5
        else
            -- Potion อื่นๆ หยุดพยายาม 60 วินาที
            buff.lastUsed = currentTime - buff.duration + 60
        end
        return false
    end
    
    task.wait(1)
    potionCount = GetPotionCount(potionName)
    
    if potionCount <= 0 then
        print("[Potion] ⚠️ ซื้อแล้วแต่ยังไม่มี Potion! (อาจมีดีเลย์)")
        task.wait(1) -- รอเพิ่ม
        potionCount = GetPotionCount(potionName)
        
        if potionCount <= 0 then
            print("[Potion] ยังไม่มี Potion จริงๆ - หยุดพยายาม")
            if potionType == "Health" then
                buff.lastUsed = currentTime - buff.duration + 5
            else
                buff.lastUsed = currentTime - buff.duration + 60
            end
            return false
        end
    end
    
    -- ใช้ Potion
    print("[Potion] กำลังใช้", potionType, "Potion (มี", potionCount, "ขวด)")
    local success = pcall(function()
        ToolActivated:InvokeServer(potionName)
    end)
    
    if success then
        buff.lastUsed = currentTime
        print("[Potion] ✓ ซื้อและใช้", potionType, "Potion สำเร็จ! (เหลือ", potionCount - 1, ")")
        return true
    else
        print("[Potion] ✗ ใช้ Potion ล้มเหลว!")
    end
    
    return false
end

local function UsePotionsForMode(mode)
    if not Settings["Use Potions"] then return end
    
    -- Health Potion: ใช้เมื่อเลือดลดลงต่ำกว่า 95% (ตรวจสอบบ่อยๆ)
    local Char = Plr.Character
    if Char then
        local Humanoid = Char:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.Health < Humanoid.MaxHealth * 0.55 then
            UsePotion("Health")
        end
    end
    
    if mode == "Rock" then
        -- Rock Mode: Miner + Luck
        UsePotion("Miner")
        UsePotion("Luck")
    elseif mode == "Mob" then
        -- Mob Mode: Damage + Health (สำคัญมากในโหมดนี้!)
        UsePotion("Damage")
    elseif mode == "Quest" then
        -- Quest Mode: ใช้ทั้งหมดตามความจำเป็น
        UsePotion("Damage")
        UsePotion("Miner")
        UsePotion("Luck")
    end
end

-- ===== QUEST SYSTEM FUNCTIONS =====
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

local function GetActiveQuestInfo()
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

local function GetCurrentObjective(questInfo)
    if not questInfo then return nil end
    
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return nil end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return nil end
    
    local progressTable = freshProgress.Progress
    if not progressTable then return nil end
    
    for i, objData in ipairs(progressTable) do
        if objData and type(objData) == "table" then
            local currentProgress = objData.currentProgress or 0
            local requiredAmount = objData.requiredAmount or 1
            local objType = objData.questType or objData.Type or objData.type or "Unknown"
            local objTarget = objData.target or objData.Target or "Unknown"
            
            if currentProgress < requiredAmount then
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

local function GetAllIncompleteObjectives(questInfo)
    if not questInfo then return {} end
    
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return {} end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return {} end
    
    local progressTable = freshProgress.Progress
    if not progressTable then return {} end
    
    local incomplete = {}
    
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

local function IsQuestAllObjectivesComplete(questInfo)
    if not questInfo then return false end
    
    local replica = PlayerController and PlayerController.Replica
    if not replica or not replica.Data or not replica.Data.Quests then return false end
    
    local freshProgress = replica.Data.Quests[questInfo.Id]
    if not freshProgress then return false end
    
    local progressTable = freshProgress.Progress
    if not progressTable then return false end
    
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

local function GetQuestNPC(questId, questTemplate)
    if questTemplate and questTemplate.Npc then
        return questTemplate.Npc
    end
    
    if questId then
        local npcName = questId:match("^(%a+%s*%a*)")
        if npcName then
            npcName = npcName:gsub("%s*%d+$", "")
            return npcName
        end
        return questId
    end
    
    return nil
end

-- ===== TALK TO NPC (Quest) =====
local function TalkToQuestNPC(npcName)
    local success, err = pcall(function()
        local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild(npcName)
        if not npc then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == npcName and (obj:IsA("Model") or obj:IsA("BasePart")) then
                    npc = obj
                    break
                end
            end
        end
        if not npc then 
            print("[Quest] NPC not found:", npcName)
            return 
        end
        
        local npcPos = GetNPCPosition(npc)
        
        if npcPos and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = npcPos + Vector3.new(0, 0, 5)
            local dist = (Plr.Character.HumanoidRootPart.Position - targetPos).Magnitude
            local tweenSpeed = (dist/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
            
            -- ใช้ Tween ถ้าระยะ > 20 studs
            if dist > 20 then
                BypassAntiExploit()
                local tween = TweenService:Create(Plr.Character.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Wait()
            else
                BypassAntiExploit()
                Plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
            task.wait(0.5)
        end
        
        -- เก็บ Quest ID เดิม
        local originalQuestId = nil
        local originalQuest = GetActiveQuestInfo()
        if originalQuest then
            originalQuestId = originalQuest.Id
        end
        
        -- เริ่มบทสนทนา
        print("[Quest] Opening dialogue with", npcName)
        DialogueRemote:InvokeServer(npc)
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
            print("[Quest] DialogueUI not found!")
            return
        end
        
        -- ฟังก์ชันหาปุ่มที่ต้องกด
        local function findTargetButton()
            local responseBillboard = dialogueUI:FindFirstChild("ResponseBillboard")
            if not responseBillboard then return nil, nil end
            
            local list = responseBillboard:FindFirstChild("List")
            if not list then return nil, nil end
            
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
            
            table.sort(options, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
            
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
        
        -- วน loop กดเลือก
        local maxAttempts = 30
        local questTurnedIn = false
        local noOptionsCount = 0
        
        for attempt = 1, maxAttempts do
            local currentQuest = GetActiveQuestInfo()
            if not currentQuest then
                print("[Quest] ✓ Quest turned in! (no quest)")
                questTurnedIn = true
                break
            elseif originalQuestId and currentQuest.Id ~= originalQuestId then
                print("[Quest] ✓ Quest changed! New:", currentQuest.Id)
                questTurnedIn = true
                break
            end
            
            local dUI = PlayerGui:FindFirstChild("DialogueUI")
            if not dUI or not dUI.Enabled then
                noOptionsCount = noOptionsCount + 1
                if noOptionsCount >= 3 then
                    break
                end
                DialogueRemote:InvokeServer(npc)
                task.wait(1)
                continue
            end
            
            local targetButton, optionIndex = findTargetButton()
            
            if targetButton then
                noOptionsCount = 0
                print("[Quest] Clicking option", optionIndex)
                clickButton(targetButton)
                task.wait(0.5)
                
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
                    
                    DialogueEvent:FireServer("Next")
                    task.wait(0.3)
                end
                
                if questTurnedIn then break end
            else
                noOptionsCount = noOptionsCount + 1
                if noOptionsCount >= 5 then
                    break
                end
                DialogueEvent:FireServer("Next")
                task.wait(0.4)
            end
        end
        
        DialogueEvent:FireServer("Closed")
        task.wait(0.3)
        
        if questTurnedIn then
            print("[Quest] ✓ Done!", npcName)
            -- บันทึกว่า Quest นี้เสร็จแล้ว สำหรับ TF_Log
            table.insert(_G.CompletedQuestsLog, {
                NPC = npcName,
                QuestId = originalQuestId,
                Time = tick()
            })
        end
    end)
    
    if not success then
        warn("[Quest] ERROR:", err)
    end
end

-- ===== PURCHASE FUNCTION =====
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

-- ===== ICEBERG FARMING (สำหรับ Prismatic Pickaxe Quest) =====
local function FarmIceberg()
    print("[Mono7] เริ่มตี Iceberg...")
    
    local icebergFolder = workspace:FindFirstChild("Rocks") and workspace.Rocks:FindFirstChild("Iceberg")
    if not icebergFolder then
        print("[Mono7] ไม่เจอ Iceberg folder!")
        return false
    end
    
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
    
    while iceberg:GetAttribute("Health") > 0 do
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
                BypassAntiExploit()
                Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 0.765))
            end
        else
            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                BypassAntiExploit()
                local tweenSpeed = (Magnitude/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                LastTween:Play()
            end
        end
    end
    
    print("[Mono7] ✓ Iceberg ถูกทำลาย!")
    return true
end

-- ===== PRISMATIC PICKAXE SPECIAL QUEST (Mono 7) =====
local function HandlePrismaticPickaxeQuest()
    print("[Mono7] ========================================")
    print("[Mono7] เริ่ม Prismatic Pickaxe Special Quest")
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
        return PurchaseItem("Prismatic pickaxe", 1)
    end
    
    if tryPurchase() then
        print("[Mono7] ✓ ซื้อ Prismatic Pickaxe สำเร็จ!")
        table.insert(_G.CompletedQuestsLog, {
            NPC = "Prismatic Pickaxe",
            QuestId = "Mono7_PrismaticPickaxe",
            Time = tick()
        })
        return true
    end
    
    -- ถ้าซื้อไม่ได้ -> ฟาร์ม mob
    print("[Mono7] เงินไม่พอ! ต้องฟาร์ม mob ก่อน...")
    
    while true do
        print("[Mono7] กำลังฟาร์ม mob...")
        
        for i = 1, 20 do
            if not IsAlive() then
                WaitForRespawn()
            end
            
            if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
                -- ไปขาย
                break
            end
            
            local Char = Plr.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local Mob = getNearestMob(Char)
                if Mob then
                    -- ใช้ระบบฟาร์ม Mob แบบใหม่
                    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                    
                    if MobHumanoid and MobHRP and MobHumanoid.Health > 0 then
                        local MobPosition = MobHRP.Position
                        local MobSize = Mob:GetExtentsSize()
                        local BaseHeight = MobSize.Y / 2 + 2
                        local SafePosition = MobPosition + Vector3.new(0, BaseHeight + SafeHeightOffset, 0)
                        
                        BypassAntiExploit()
                        Char.HumanoidRootPart.CFrame = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
                        
                        for j = 1, 10 do
                            AttackMob()
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        
        -- ไปขายแล้วกลับมาลองซื้อ
        if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
            -- Forge และขาย
            local Position = workspace.Proximity.Forge.Position
            local Char = Plr.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                tween:Play()
                tween.Completed:Wait()
            end
            
            local CanForge = true
            while CanForge do
                task.wait()
                if not IsAlive() then break end
                local Recipe = GetRecipe()
                if Recipe then
                    Forge(Recipe)
                else
                    CanForge = false
                end
            end
            
            TalkToMarbles()
            task.wait(0.5)
            SellEquipments()
            task.wait(0.5)
            TalkToGreedyCey()
            task.wait(0.5)
            SellOres()
        end
        
        task.wait(1)
        
        -- ลองซื้ออีกครั้ง
        print("[Mono7] ลองซื้อ Prismatic Pickaxe อีกครั้ง...")
        if tryPurchase() then
            print("[Mono7] ✓ ซื้อ Prismatic Pickaxe สำเร็จ!")
            table.insert(_G.CompletedQuestsLog, {
                NPC = "Prismatic Pickaxe",
                QuestId = "Mono7_PrismaticPickaxe",
                Time = tick()
            })
            return true
        end
        
        print("[Mono7] ยังเงินไม่พอ ฟาร์มต่อ...")
    end
    
    return false
end

-- ===== DRAGON HEAD PICKAXE SPECIAL QUEST =====
-- ขั้นตอน: Raven quest (ถึง Raven 2) -> Red Cave key -> เปิด Red Cave -> Auron -> Mjelatkhan -> Morveth -> ซื้อ Dragon Head Pickaxe
local function HandleDragonHeadPickaxeQuest()
    print("[DragonHead] ========================================")
    print("[DragonHead] เริ่ม Dragon Head Pickaxe Special Quest")
    print("[DragonHead] ========================================")
    
    local Char = Plr.Character
    
    -- ฟังก์ชันเช็คว่ามี item หรือยัง
    local function hasItem(itemName)
        local replica = PlayerController and PlayerController.Replica
        if not replica or not replica.Data or not replica.Data.Inventory then return false end
        
        for _, item in pairs(replica.Data.Inventory) do
            if type(item) == "table" and item.Name then
                if string.find(string.lower(item.Name), string.lower(itemName)) then
                    return true
                end
            elseif type(item) == "string" then
                if string.find(string.lower(item), string.lower(itemName)) then
                    return true
                end
            end
        end
        return false
    end
    
    -- ฟังก์ชันเช็คว่าเปิด Red Cave แล้วหรือยัง
    local function isRedCaveOpened()
        -- เช็คจาก PlayerController.Replica.Data หรือ workspace
        local replica = PlayerController and PlayerController.Replica
        if replica and replica.Data then
            -- เช็คจาก UnlockedAreas หรือ similar
            if replica.Data.UnlockedAreas then
                for _, area in pairs(replica.Data.UnlockedAreas) do
                    if string.find(string.lower(tostring(area)), "red cave") then
                        return true
                    end
                end
            end
            -- เช็คจาก CompletedQuests
            if replica.Data.CompletedQuests then
                for questId, _ in pairs(replica.Data.CompletedQuests) do
                    if string.find(string.lower(tostring(questId)), "raven") and 
                       (string.find(tostring(questId), "3") or string.find(tostring(questId), "2")) then
                        return true
                    end
                end
            end
        end
        return false
    end
    
    -- ฟังก์ชันเช็คว่าทำ Raven quest ถึงไหนแล้ว
    local function getRavenProgress()
        local replica = PlayerController and PlayerController.Replica
        if not replica or not replica.Data then return 0 end
        
        -- เช็คจาก CompletedQuests
        local completedQuests = replica.Data.CompletedQuests or {}
        local ravenLevel = 0
        
        for questId, _ in pairs(completedQuests) do
            local qId = string.lower(tostring(questId))
            if string.find(qId, "raven") then
                -- หาตัวเลขหลัง raven
                local num = qId:match("raven%s*(%d)")
                if num then
                    local n = tonumber(num)
                    if n and n > ravenLevel then
                        ravenLevel = n
                    end
                elseif not qId:match("%d") then
                    -- Raven 1 (ไม่มีเลข)
                    if ravenLevel < 1 then ravenLevel = 1 end
                end
            end
        end
        
        return ravenLevel
    end
    
    -- ฟังก์ชันหา NPC ใน workspace
    local function findNPC(npcName)
        -- ค้นหาใน workspace.Proximity หรือ workspace.NPCs
        local searchFolders = {
            workspace:FindFirstChild("Proximity"),
            workspace:FindFirstChild("NPCs"),
            workspace:FindFirstChild("NPC"),
            workspace
        }
        
        for _, folder in pairs(searchFolders) do
            if folder then
                for _, child in pairs(folder:GetDescendants()) do
                    if child.Name and string.find(string.lower(child.Name), string.lower(npcName)) then
                        if child:IsA("Model") or child:IsA("BasePart") then
                            return child
                        end
                    end
                end
            end
        end
        return nil
    end
    
    -- ฟังก์ชันไปหา NPC และคุย
    local function goToAndTalkNPC(npcName)
        print("[DragonHead] ไปหา", npcName)
        
        local npc = findNPC(npcName)
        if not npc then
            print("[DragonHead] ไม่พบ NPC:", npcName)
            return false
        end
        
        local npcPos
        if npc:IsA("Model") then
            if npc.PrimaryPart then
                npcPos = npc.PrimaryPart.Position
            elseif npc:FindFirstChild("HumanoidRootPart") then
                npcPos = npc.HumanoidRootPart.Position
            elseif npc:FindFirstChild("Torso") then
                npcPos = npc.Torso.Position
            else
                local part = npc:FindFirstChildWhichIsA("BasePart")
                if part then npcPos = part.Position end
            end
        elseif npc:IsA("BasePart") then
            npcPos = npc.Position
        end
        
        if not npcPos then
            print("[DragonHead] ไม่พบตำแหน่ง NPC:", npcName)
            return false
        end
        
        -- วาร์ปไปหา NPC
        Char = Plr.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            local tween = TweenService:Create(
                Char.HumanoidRootPart, 
                TweenInfo.new(2, Enum.EasingStyle.Linear), 
                {CFrame = CFrame.new(npcPos + Vector3.new(0, 0, 3))}
            )
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.5)
        end
        
        -- คุยกับ NPC
        TalkToQuestNPC(npcName)
        task.wait(1)
        
        return true
    end
    
    -- ฟังก์ชันเปิด Red Cave
    local function openRedCave()
        print("[DragonHead] ไปเปิด Red Cave (Heart Door)...")
        
        -- เช็คว่าเปิด Red Cave แล้วหรือยัง
        local replica = PlayerController and PlayerController.Replica
        if replica and replica.Data then
            local miscDialogues = replica.Data.MiscDialogues
            if miscDialogues and miscDialogues.UnlockedRedCaveDoor then
                print("[DragonHead] ✓ Red Cave เปิดแล้ว!")
                return true
            end
        end
        
        -- หา Heart Door ใน workspace.Assets
        local heartDoor = nil
        local assets = workspace:FindFirstChild("Assets")
        if assets then
            heartDoor = assets:FindFirstChild("Heart Door")
        end
        
        if not heartDoor then
            print("[DragonHead] ไม่พบ Heart Door ใน Assets! ลองหาทั่วไป...")
            for _, child in pairs(workspace:GetDescendants()) do
                if child.Name == "Heart Door" then
                    heartDoor = child
                    break
                end
            end
        end
        
        if heartDoor then
            print("[DragonHead] พบ Heart Door!")
            
            local pos
            if heartDoor:IsA("Model") then
                pos = heartDoor:GetPivot().Position
            elseif heartDoor:IsA("BasePart") then
                pos = heartDoor.Position
            end
            
            if pos then
                Char = Plr.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    BypassAntiExploit()
                    Char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 0, 3))
                    task.wait(1)
                    
                    -- ใช้ Key เปิด Red Cave Door (ตามโค้ด decompile)
                    pcall(function()
                        replica:Write("RemoveMiscItem", "RedCaveKey", 1)
                    end)
                    task.wait(1)
                end
            end
            
            print("[DragonHead] ✓ เปิด Heart Door สำเร็จ!")
        else
            print("[DragonHead] ไม่พบ Heart Door!")
        end
        
        return true
    end
    
    -- ฟังก์ชันฟาร์มและขาย
    local function farmAndSell()
        print("[DragonHead] ฟาร์มเงิน...")
        
        for i = 1, 30 do
            if not IsAlive() then WaitForRespawn() end
            
            if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
                break
            end
            
            Char = Plr.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local Mob = getNearestMob(Char)
                if Mob then
                    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                    
                    if MobHumanoid and MobHRP and MobHumanoid.Health > 0 then
                        local MobPosition = MobHRP.Position
                        local MobSize = Mob:GetExtentsSize()
                        local BaseHeight = MobSize.Y / 2 + 2
                        local SafePosition = MobPosition + Vector3.new(0, BaseHeight + SafeHeightOffset, 0)
                        
                        BypassAntiExploit()
                        Char.HumanoidRootPart.CFrame = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
                        
                        for j = 1, 10 do
                            AttackMob()
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        
        -- Forge และขาย
        if Inventory:CalculateTotal("Stash") >= Inventory:GetBagCapacity() then
            local Position = workspace.Proximity.Forge.Position
            Char = Plr.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                tween:Play()
                tween.Completed:Wait()
            end
            
            local CanForge = true
            while CanForge do
                task.wait()
                if not IsAlive() then break end
                local Recipe = GetRecipe()
                if Recipe then
                    Forge(Recipe)
                else
                    CanForge = false
                end
            end
            
            TalkToMarbles()
            task.wait(0.5)
            SellEquipments()
            task.wait(0.5)
            TalkToGreedyCey()
            task.wait(0.5)
            SellOres()
        end
    end
    
    -- ===== เริ่มขั้นตอน =====
    
    -- เช็คว่า Raven 3 แล้วหรือยัง (ข้ามได้เลย)
    local ravenProgress = getRavenProgress()
    print("[DragonHead] Raven Progress:", ravenProgress)
    
    if ravenProgress >= 3 or isRedCaveOpened() then
        print("[DragonHead] ✓ Raven 3 หรือเปิด Red Cave แล้ว! ข้ามไปขั้นตอนคุย NPC")
    else
        -- ขั้นตอน 1: ทำ Raven quest ถึง Raven 2
        print("[DragonHead] ขั้นตอน 1: ทำ Raven quest")
        
        while ravenProgress < 2 do
            print("[DragonHead] Raven Progress:", ravenProgress, "- ต้องทำถึง 2")
            
            -- ไปหา Raven
            goToAndTalkNPC("Raven")
            task.wait(2)
            
            -- เช็ค Quest
            local questInfo = GetActiveQuestInfo()
            if questInfo then
                local questId = string.lower(tostring(questInfo.Id))
                if string.find(questId, "raven") then
                    print("[DragonHead] กำลังทำ Raven quest:", questInfo.Id)
                    
                    -- Process Quest objectives
                    while true do
                        if not IsAlive() then WaitForRespawn() end
                        
                        questInfo = GetActiveQuestInfo()
                        if not questInfo then break end
                        
                        if IsQuestAllObjectivesComplete(questInfo) then
                            -- ส่ง Quest
                            goToAndTalkNPC("Raven")
                            task.wait(1)
                            break
                        end
                        
                        local objective = GetCurrentObjective(questInfo)
                        if not objective then break end
                        
                        local objType = objective.Objective.Type
                        local objTarget = objective.Objective.Target
                        
                        if objType == "Kill" then
                            -- ฟาร์ม Mob
                            Char = Plr.Character
                            if Char then
                                local Mob = getNearestMob(Char)
                                if Mob then
                                    FarmMobImproved(Mob)
                                end
                            end
                        elseif objType == "Mine" then
                            -- ขุดหิน
                            Char = Plr.Character
                            if Char then
                                local Rock = getnearest(Char)
                                if Rock then
                                    local Position = Rock:GetAttribute("OriginalCFrame") and Rock:GetAttribute("OriginalCFrame").Position or Rock:GetPivot().Position
                                    while Rock and Rock:GetAttribute("Health") and Rock:GetAttribute("Health") > 0 do
                                        task.wait(0.1)
                                        if not IsAlive() then break end
                                        Char = Plr.Character
                                        if not Char or not Char:FindFirstChild("HumanoidRootPart") then break end
                                        BypassAntiExploit()
                                        Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 0.75))
                                        AttackRock()
                                    end
                                end
                            end
                        elseif objType == "Talk" then
                            goToAndTalkNPC(objTarget)
                        else
                            task.wait(1)
                        end
                        
                        task.wait(0.1)
                    end
                end
            else
                -- ไม่มี Quest - รับ Quest ใหม่
                goToAndTalkNPC("Raven")
                task.wait(1)
            end
            
            ravenProgress = getRavenProgress()
            task.wait(1)
        end
        
        print("[DragonHead] ✓ Raven 2 เสร็จ! ได้ Red Cave key")
        
        -- ขั้นตอน 2: เปิด Red Cave
        print("[DragonHead] ขั้นตอน 2: เปิด Red Cave")
        openRedCave()
        task.wait(2)
    end
    
    -- ขั้นตอน 3: คุยกับ Auron -> Mjelatkhan -> Morveth
    print("[DragonHead] ขั้นตอน 3: คุย NPCs (Auron -> Mjelatkhan -> Morveth)")
    
    local npcsToTalk = {"Auron", "Mjelatkhan", "Morveth"}
    
    for _, npcName in ipairs(npcsToTalk) do
        print("[DragonHead] คุยกับ", npcName)
        goToAndTalkNPC(npcName)
        task.wait(2)
    end
    
    -- ขั้นตอน 4: ซื้อ Dragon Head Pickaxe
    print("[DragonHead] ขั้นตอน 4: ซื้อ Dragon Head Pickaxe")
    
    local function tryPurchaseDragonHead()
        return PurchaseItem("Dragon Head Pickaxe", 1)
    end
    
    if tryPurchaseDragonHead() then
        print("[DragonHead] ✓ ซื้อ Dragon Head Pickaxe สำเร็จ!")
        table.insert(_G.CompletedQuestsLog, {
            NPC = "Dragon Head Pickaxe",
            QuestId = "DragonHead_Pickaxe",
            Time = tick()
        })
        return true
    end
    
    -- ถ้าซื้อไม่ได้ -> ฟาร์มเงิน
    print("[DragonHead] เงินไม่พอ! ต้องฟาร์มก่อน...")
    
    while true do
        farmAndSell()
        task.wait(1)
        
        print("[DragonHead] ลองซื้อ Dragon Head Pickaxe อีกครั้ง...")
        if tryPurchaseDragonHead() then
            print("[DragonHead] ✓ ซื้อ Dragon Head Pickaxe สำเร็จ!")
            table.insert(_G.CompletedQuestsLog, {
                NPC = "Dragon Head Pickaxe",
                QuestId = "DragonHead_Pickaxe",
                Time = tick()
            })
            return true
        end
        
        print("[DragonHead] ยังเงินไม่พอ ฟาร์มต่อ...")
    end
    
    return false
end

-- ===== GOLEM DOOR OPENER (สำหรับ Mob Farm) =====
local _G_GolemDoorOpened = false  -- ติดตามว่าเปิดประตู Golem แล้วหรือยัง

local function OpenGolemDoor()
    if _G_GolemDoorOpened then
        return true  -- เปิดแล้ว ไม่ต้องเปิดซ้ำ
    end
    
    print("[Golem] ========================================")
    print("[Golem] กำลังเปิดประตู Golem Dungeon...")
    print("[Golem] ========================================")
    
    -- หาประตู CreateParty
    local CreateParty = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("CreateParty")
    if not CreateParty then
        print("[Golem] ไม่พบประตู CreateParty!")
        return false
    end
    
    -- หาตำแหน่งประตู
    local doorPos
    if CreateParty:IsA("Model") then
        doorPos = CreateParty:GetPivot().Position
    elseif CreateParty:IsA("BasePart") then
        doorPos = CreateParty.Position
    else
        local part = CreateParty:FindFirstChildWhichIsA("BasePart")
        if part then
            doorPos = part.Position
        end
    end
    
    if not doorPos then
        print("[Golem] ไม่พบตำแหน่งประตู!")
        return false
    end
    
    local targetPos = doorPos + Vector3.new(0, 0, 3)
    
    -- ใช้ Tween ธรรมชาติแทนการวาร์ป
    print("[Golem] กำลังเดินไปที่ประตู...")
    local Char = Plr.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local dist = (Char.HumanoidRootPart.Position - targetPos).Magnitude
        local tweenSpeed = dist / TWEEN_SPEED
        
        BypassAntiExploit()
        local tween = TweenService:Create(
            Char.HumanoidRootPart, 
            TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), 
            {CFrame = CFrame.new(targetPos)}
        )
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.3)
    end
    
    -- Activate Party
    print("[Golem] Activate Party...")
    pcall(function()
        PartyActivate:InvokeServer()
    end)
    task.wait(0.5)
    
    -- Interact กับประตู CreateParty
    print("[Golem] เปิดประตู...")
    pcall(function()
        ProximityFunctionals:InvokeServer(CreateParty)
    end)
    task.wait(0.5)
    
    _G_GolemDoorOpened = true
    print("[Golem] ✓ เปิดประตู Golem Dungeon สำเร็จ!")
    return true
end

-- ฟังก์ชันเช็คว่าเลือก Golem หรือไม่
local function IsGolemSelected()
    if Settings["Select Mobs"] then
        for _, mobName in pairs(Settings["Select Mobs"]) do
            if string.find(string.lower(mobName), "golem") then
                return true
            end
        end
    end
    return false
end

-- ===== GOLEM DUNGEON SPECIAL QUEST =====
local function HandleGolemQuest()
    print("[Golem] ========================================")
    print("[Golem] เริ่มเข้า Golem Dungeon")
    print("[Golem] ========================================")
    
    local Char = Plr.Character
    
    -- ขั้นตอน 1: Activate Party
    print("[Golem] ขั้นตอน 1: Activate Party")
    pcall(function()
        PartyActivate:InvokeServer()
    end)
    task.wait(1)
    
    -- ขั้นตอน 2: Create Party
    print("[Golem] ขั้นตอน 2: Create Party")
    local CreateParty = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("CreateParty")
    if CreateParty then
        pcall(function()
            ProximityFunctionals:InvokeServer(CreateParty)
        end)
        task.wait(1)
        
        -- เรียกอีกครั้งเพื่อความแน่นอน
        pcall(function()
            ProximityFunctionals:InvokeServer(CreateParty)
        end)
        task.wait(1)
    else
        print("[Golem] ไม่พบ CreateParty!")
    end
    
    -- ขั้นตอน 3: หา Golem entrance และเข้า
    print("[Golem] ขั้นตอน 3: เข้า Golem Dungeon")
    
    local golemEntrance = nil
    
    -- ค้นหา Golem entrance
    for _, child in pairs(workspace:GetDescendants()) do
        if child.Name and string.find(string.lower(child.Name), "golem") then
            if child:IsA("Model") or child:IsA("BasePart") then
                golemEntrance = child
                break
            end
        end
    end
    
    -- ลองหาใน Proximity
    if not golemEntrance then
        local proximity = workspace:FindFirstChild("Proximity")
        if proximity then
            for _, child in pairs(proximity:GetDescendants()) do
                if child.Name and string.find(string.lower(child.Name), "golem") then
                    golemEntrance = child
                    break
                end
            end
        end
    end
    
    if golemEntrance then
        print("[Golem] พบ Golem entrance:", golemEntrance.Name)
        
        local pos
        if golemEntrance:IsA("Model") then
            pos = golemEntrance:GetPivot().Position
        elseif golemEntrance:IsA("BasePart") then
            pos = golemEntrance.Position
        end
        
        if pos then
            Char = Plr.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                -- วาร์ปไป Golem
                local tween = TweenService:Create(
                    Char.HumanoidRootPart, 
                    TweenInfo.new(2, Enum.EasingStyle.Linear), 
                    {CFrame = CFrame.new(pos + Vector3.new(0, 0, 3))}
                )
                tween:Play()
                tween.Completed:Wait()
                task.wait(0.5)
                
                -- Interact กับ Golem entrance
                pcall(function()
                    ProximityFunctionals:InvokeServer(golemEntrance)
                end)
                task.wait(1)
                
                pcall(function()
                    DialogueRemote:InvokeServer(golemEntrance)
                end)
                task.wait(1)
            end
        end
    else
        print("[Golem] ไม่พบ Golem entrance!")
    end
    
    print("[Golem] ✓ เข้า Golem Dungeon เสร็จ!")
    table.insert(_G.CompletedQuestsLog, {
        NPC = "Golem",
        QuestId = "Golem_Dungeon",
        Time = tick()
    })
    
    return true
end

-- Forward declaration for FarmMobImproved (จะถูก define ทีหลัง)
local FarmMobImproved

-- ===== PROCESS QUEST (Main Quest Handler) =====
-- ===== SPECIAL QUEST LIST =====
local SpecialQuests = {
    ["prismatic pickaxe"] = HandlePrismaticPickaxeQuest,
    ["dragon head pickaxe"] = HandleDragonHeadPickaxeQuest,
    ["golem"] = HandleGolemQuest,
}

local function ProcessQuest()
    local questNPCName = Settings["Select Quest"]
    
    -- ถ้าไม่มี Quest ที่เลือก
    if not questNPCName or questNPCName == "" then
        print("[Quest] กรุณาตั้งค่า Settings[\"Select Quest\"] ก่อน!")
        task.wait(3)
        return
    end
    
    -- เช็คว่าเป็น Special Quest หรือไม่
    local lowerQuestName = string.lower(questNPCName)
    if SpecialQuests[lowerQuestName] then
        print("[Quest] Starting Special Quest:", questNPCName)
        SpecialQuests[lowerQuestName]()
        return
    end
    
    -- ถ้าไม่ใช่ Special Quest -> ทำ Quest ปกติ
    -- เช็คว่ามี Quest อยู่หรือไม่
    local questInfo = GetActiveQuestInfo()
    
    if not questInfo then
        -- ไม่มี Quest -> ไปรับ Quest ใหม่
        print("[Quest] ไม่มี Quest! ไปรับ Quest จาก", questNPCName)
        TalkToQuestNPC(questNPCName)
        task.wait(1)
        return
    end
    
    -- มี Quest อยู่ -> เช็คว่าทำเสร็จหรือยัง
    if IsQuestAllObjectivesComplete(questInfo) then
        print("[Quest] ✓ Quest ครบแล้ว! ไปส่ง Quest")
        TalkToQuestNPC(questNPCName)
        task.wait(1)
        return
    end
    
    -- ยังทำไม่เสร็จ -> หา Objective ที่ยังไม่เสร็จ
    local objective = GetCurrentObjective(questInfo)
    
    if not objective then
        print("[Quest] ไม่มี Objective!")
        task.wait(1)
        return
    end
    
    local objectiveType = objective[1]
    local targetName = objective[2]
    local currentProgress = objective[3]
    local requiredAmount = objective[4]
    
    print("[Quest] Processing:", objectiveType, "-", targetName, currentProgress .. "/" .. requiredAmount)
    
    -- เช็คว่า objective เกี่ยวกับ Golem หรือไม่ (ต้องเปิด Dungeon ก่อน)
    local lowerTarget = string.lower(targetName)
    if string.find(lowerTarget, "golem") then
        print("[Quest] Objective เกี่ยวกับ Golem - ต้องเปิด Dungeon ก่อน!")
        HandleGolemQuest()
        task.wait(2)
    end
    
    if objectiveType == "Kill" then
        -- ฟาร์ม Mob
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        -- หา Mob ที่ต้องการ
        local function findTargetMob()
            local closestDist = math.huge
            local closestMob = nil
            
            for _, mobFolder in pairs(workspace:GetChildren()) do
                if mobFolder:IsA("Folder") and mobFolder.Name == "Enemies" then
                    for _, mob in pairs(mobFolder:GetChildren()) do
                        if mob:IsA("Model") then
                            local mobHumanoid = mob:FindFirstChildOfClass("Humanoid")
                            local mobHRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                            
                            if mobHumanoid and mobHRP and mobHumanoid.Health > 0 then
                                -- เช็คชื่อ
                                if string.find(string.lower(mob.Name), string.lower(targetName)) or 
                                   string.find(string.lower(targetName), string.lower(mob.Name)) then
                                    local dist = (Char.HumanoidRootPart.Position - mobHRP.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestMob = mob
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- ถ้าหา Mob ตามชื่อไม่เจอ ก็ตี Mob ที่ใกล้ที่สุด
            if not closestMob then
                closestMob = getNearestMob(Char)
            end
            
            return closestMob
        end
        
        local mob = findTargetMob()
        if mob then
            FarmMobImproved(mob)
        else
            print("[Quest] ไม่พบ Mob:", targetName)
            task.wait(1)
        end
        
    elseif objectiveType == "Mine" then
        -- ขุดหิน
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        local Rock = getnearest(Char)
        if Rock then
            local LastAttack = 0
            local LastTween = nil
            local Position = Rock:GetAttribute("OriginalCFrame") and Rock:GetAttribute("OriginalCFrame").Position or Rock:GetPivot().Position
            
            while Rock and Rock:GetAttribute("Health") and Rock:GetAttribute("Health") > 0 do
                task.wait(0.1)
                
                if not IsAlive() then
                    if LastTween then LastTween:Cancel() end
                    return
                end
                
                -- เช็ค Quest progress
                local checkQuest = GetActiveQuestInfo()
                if checkQuest then
                    local checkObj = GetCurrentObjective(checkQuest)
                    if not checkObj or checkObj[1] ~= "Mine" then
                        break
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
                        BypassAntiExploit()
                        Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 0, 0.75))
                    end
                else
                    if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                        BypassAntiExploit()
                        local tweenSpeed = (Magnitude/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                        LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                        LastTween:Play()
                    end
                end
            end
        else
            print("[Quest] ไม่เจอหินที่จะขุด!")
            task.wait(1)
        end
        
    elseif objectiveType == "Forge" then
        -- Forge Equipment
        print("[Quest] Forging...")
        
        local Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        local Position = workspace.Proximity.Forge.Position
        local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
        tween:Play()
        tween.Completed:Wait()
        
        local Recipe = GetRecipe()
        if Recipe then
            Forge(Recipe)
        else
            print("[Quest] ไม่มี Recipe!")
            -- ต้องไปขุดแร่
            task.wait(1)
        end
        
    elseif objectiveType == "Talk" then
        -- คุยกับ NPC
        print("[Quest] Talking to NPC:", targetName)
        TalkToQuestNPC(targetName)
        task.wait(1)
        
    elseif objectiveType == "Sell" then
        -- ขาย Equipment
        print("[Quest] Selling equipment...")
        
        TalkToMarbles()
        task.wait(0.5)
        SellEquipments()
        task.wait(0.5)
        TalkToGreedyCey()
        task.wait(0.5)
        SellOres()
        
    else
        print("[Quest] Unknown objective type:", objectiveType)
        task.wait(1)
    end
end

-- ===== IMPROVED MOB FARM (ลอยตี นอนตี เหมือน TF_AutoQuest) =====
FarmMobImproved = function(Mob)
    if not Mob then return end
    if not IsAlive() then return end
    
    local Char = Plr.Character
    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
    
    if not MobHumanoid or not MobHRP or MobHumanoid.Health <= 0 then return end
    
    local LastHP = Char:FindFirstChildOfClass("Humanoid").Health
    local HitCount = 0
    local CheckTime = tick()
    local LastTweenTime = 0
    local FarmTween = nil
    local IsNearMob = false
    local LastDamageCheck = tick()
    local MobLastHP = MobHumanoid.Health
    
    print("[Farm] Found Mob:", Mob.Name)
    
    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 do
        task.wait(0.05)
        
        if not IsAlive() then
            if FarmTween then FarmTween:Cancel() end
            return
        end
        
        -- เช็ค Mob ยังอยู่ไหม
        if not Mob or not Mob.Parent then break end
        MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
        if not MobHRP then break end
        MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
        if not MobHumanoid or MobHumanoid.Health <= 0 then break end
        
        Char = Plr.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        local MyHumanoid = Char:FindFirstChildOfClass("Humanoid")
        if not MyHumanoid then return end
        
        -- ตรวจสอบว่าโดนตีหรือไม่
        local CurrentHP = MyHumanoid.Health
        if CurrentHP < LastHP then
            HitCount = HitCount + 1
            SafeHeightOffset = SafeHeightOffset + 1.5
            print("[Farm] โดนตี! เพิ่มระยะเป็น +", string.format("%.1f", SafeHeightOffset), "studs")
            CheckTime = tick()
        end
        LastHP = CurrentHP
        
        -- เช็คว่าตีโดน mob หรือไม่ (mob HP ลดลง)
        local CurrentMobHP = MobHumanoid.Health
        if CurrentMobHP < MobLastHP then
            -- ตีโดน! รีเซ็ตเวลา
            LastDamageCheck = tick()
        elseif tick() - LastDamageCheck > 1 and IsNearMob then
            -- ตีไม่โดน 1 วินาที! ลดระยะทันที
            SafeHeightOffset = math.max(0, SafeHeightOffset - 1)
            print("[Farm] ตีไม่โดน! ลดระยะเป็น +", string.format("%.1f", SafeHeightOffset), "studs")
            LastDamageCheck = tick()
        end
        MobLastHP = CurrentMobHP
        
        -- ถ้าไม่โดนตี 2 วินาที ลองลดระยะเร็วขึ้น
        if tick() - CheckTime > 2 then
            if HitCount == 0 and SafeHeightOffset > 0 then
                SafeHeightOffset = math.max(0, SafeHeightOffset - 1)
                print("[Farm] ไม่โดนตี ลดระยะเป็น +", string.format("%.1f", SafeHeightOffset), "studs")
            end
            HitCount = 0
            CheckTime = tick()
        end
        if CurrentHP < LastHP then
            HitCount = HitCount + 1
            SafeHeightOffset = math.min(SafeHeightOffset + 0.5, MAX_SAFE_HEIGHT)
            print("[Farm] โดนตี! เพิ่มระยะเป็น +", string.format("%.1f", SafeHeightOffset), "studs")
        end
        LastHP = CurrentHP
        
        -- ถ้าไม่โดนตี 5 วินาที ลองลดระยะ
        if tick() - CheckTime > 5 then
            if HitCount == 0 and SafeHeightOffset > 0 then
                SafeHeightOffset = math.max(0, SafeHeightOffset - 0.2)
                print("[Farm] ไม่โดนตี ลดระยะ:", string.format("%.1f", SafeHeightOffset))
            end
            HitCount = 0
            CheckTime = tick()
        end
        
        local MobPosition = MobHRP.Position
        local MyPosition = Char.HumanoidRootPart.Position
        
        local MobSize = Mob:GetExtentsSize()
        local BaseHeight = MobSize.Y / 2 + 2
        
        local SafePosition = MobPosition + Vector3.new(0, BaseHeight + SafeHeightOffset, 0)
        local DistToSafe = (MyPosition - SafePosition).Magnitude
        
        -- ปิด AutoRotate เพื่อให้นอนค้าง
        if MyHumanoid then
            MyHumanoid.AutoRotate = false
        end
        
        -- ท่านอน (หันหน้าลง)
        local LyingCFrame = CFrame.new(SafePosition) * CFrame.Angles(-math.rad(90), 0, 0)
        
        if DistToSafe > 50 then
            -- อยู่ไกลมาก: ใช้ Tween
            IsNearMob = false
            if tick() - LastTweenTime > 0.5 then
                LastTweenTime = tick()
                if FarmTween then FarmTween:Cancel() end
                local tweenTime = DistToSafe / TWEEN_SPEED
                BypassAntiExploit()
                FarmTween = TweenService:Create(
                    Char.HumanoidRootPart, 
                    TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), 
                    {CFrame = LyingCFrame}
                )
                FarmTween:Play()
            end
            BypassAntiExploit()
            Char.HumanoidRootPart.CFrame = CFrame.new(Char.HumanoidRootPart.Position) * CFrame.Angles(-math.rad(90), 0, 0)
        elseif DistToSafe > 15 then
            -- อยู่ใกล้พอสมควร
            IsNearMob = false
            if tick() - LastTweenTime > 0.3 then
                LastTweenTime = tick()
                if FarmTween then FarmTween:Cancel() end
                local tweenTime = DistToSafe / TWEEN_SPEED
                BypassAntiExploit()
                FarmTween = TweenService:Create(
                    Char.HumanoidRootPart, 
                    TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), 
                    {CFrame = LyingCFrame}
                )
                FarmTween:Play()
            end
            BypassAntiExploit()
            Char.HumanoidRootPart.CFrame = CFrame.new(Char.HumanoidRootPart.Position) * CFrame.Angles(-math.rad(90), 0, 0)
        else
            -- อยู่ใกล้แล้ว
            IsNearMob = true
            if FarmTween then FarmTween:Cancel() FarmTween = nil end
            if Char:FindFirstChild("HumanoidRootPart") then
                BypassAntiExploit()
                Char.HumanoidRootPart.CFrame = LyingCFrame
            end
        end
        
        -- โจมตีเมื่ออยู่ในระยะ
        if IsNearMob or DistToSafe < 20 then
            for i = 1, 10 do
                coroutine.wrap(function()
                    pcall(function() AttackMob() end)
                end)()
            end
        end
    end
    
    -- เปิด AutoRotate กลับ
    pcall(function()
        if Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid") then
            Plr.Character:FindFirstChildOfClass("Humanoid").AutoRotate = true
        end
    end)
    
    if FarmTween then FarmTween:Cancel() FarmTween = nil end
end

local _G_ForgeItemType = "Weapon"  -- สลับระหว่าง "Weapon" / "Armor"

local function Forge(Recipe)
    -- วาปไป Forge ก่อน
    local Char = Plr.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local ForgePos = workspace.Proximity.Forge.Position
        local distance = (Char.HumanoidRootPart.Position - ForgePos).Magnitude
        
        if distance > 10 then
            -- ใช้ Tween เสมอถ้าระยะไกล
            if distance > 30 then
                print("[Forge] ระยะ", math.floor(distance), "studs - ใช้ Tween")
                local tweenSpeed = (distance/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                BypassAntiExploit()
                local tween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(ForgePos)})
                tween:Play()
                tween.Completed:Wait()
            else
                BypassAntiExploit()
                Char.HumanoidRootPart.CFrame = CFrame.new(ForgePos)
            end
            task.wait(0.3)
        end
    end
    
    -- สลับ ItemType ทุกครั้งที่ Forge
    local currentItemType = _G_ForgeItemType
    if _G_ForgeItemType == "Weapon" then
        _G_ForgeItemType = "Armor"
    else
        _G_ForgeItemType = "Weapon"
    end
    
    print("[Forge] 🔨 กำลัง Forge:", currentItemType)
    
    local success, err = pcall(function()
        -- Start Forge
        local StartForge = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("StartForge")
        StartForge:InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Forge"))
        task.wait(0.3)
        
        -- Melt (Init + ใส่แร่รวมกัน)
        local Melt = nil
        for attempt = 1, 5 do
            local ok, result = pcall(function()
                return ChangeSequence:InvokeServer("Melt", {
                    FastForge = true,
                    ItemType = currentItemType,  -- ใช้ Weapon หรือ Armor
                    Ores = Recipe
                })
            end)
            
            if ok and result and type(result) == "table" and result["MinigameData"] and result["MinigameData"]["RequiredTime"] then
                Melt = result
                break
            end
            task.wait(0.2)
        end
        
        if not Melt then
            error("Melt failed")
        end
        
        task.wait(Melt["MinigameData"]["RequiredTime"])
        
        -- Pour
        local Pour = ChangeSequence:InvokeServer("Pour", {
            ClientTime = workspace:GetServerTimeNow()
        })
        if Pour and Pour["MinigameData"] and Pour["MinigameData"]["RequiredTime"] then
            task.wait(Pour["MinigameData"]["RequiredTime"])
        end
        
        -- Hammer
        local Hammer = ChangeSequence:InvokeServer("Hammer", {
            ClientTime = workspace:GetServerTimeNow()
        })
        if Hammer and Hammer["MinigameData"] and Hammer["MinigameData"]["RequiredTime"] then
            task.wait(Hammer["MinigameData"]["RequiredTime"])
        end
        
        -- Water (spawn)
        task.spawn(function()
            pcall(function()
                ChangeSequence:InvokeServer("Water", {
                    ClientTime = workspace:GetServerTimeNow()
                })
            end)
        end)
        task.wait(0.5)
        
        -- Showcase
        pcall(function() ChangeSequence:InvokeServer("Showcase", {}) end)
        task.wait(0.3)
        
        -- OreSelect (กลับหน้าเลือกแร่)
        pcall(function() ChangeSequence:InvokeServer("OreSelect", {}) end)
        
        -- Close UI
        pcall(require(game:GetService("ReplicatedStorage").Controllers.UIController.Forge).Close)
    end)
    
    if success then
        print("[Forge] ✅ Forge สำเร็จ!")
    else
        warn("[Forge] ❌ Forge ล้มเหลว:", err)
    end
end

local function TalkToMarbles()
    pcall(function()
        local marbles = workspace:WaitForChild("Proximity"):WaitForChild("Marbles")
        local marblesPos
        
        -- หาตำแหน่ง NPC
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
            local targetPos = marblesPos + Vector3.new(0, 0, 5)
            local dist = (Plr.Character.HumanoidRootPart.Position - targetPos).Magnitude
            local maxDist = _G_MaxTeleportDistance or 9999
            
            -- เช็คระยะก่อนวาร์ป
            if dist > maxDist then
                print("[TalkToMarbles] ⚠️ NPC อยู่ไกลเกินไป (", math.floor(dist), "studs) - ข้ามไปก่อน")
                return
            end
            
            -- ใช้ Tween เสมอถ้าระยะ > 20 studs
            if dist > 20 then
                print("[TalkToMarbles] ระยะ", math.floor(dist), "studs - ใช้ Tween")
                local tweenSpeed = (dist/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                BypassAntiExploit()
                local tween = TweenService:Create(Plr.Character.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Wait()
            else
                BypassAntiExploit()
                Plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
            task.wait(0.5)
        end
        
        task.wait(0.3)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(marbles)
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.5)
        print("[TF_System] Talked to Marbles")
    end)
end

-- Function ขาย Equipment พร้อมคุยกับ NPC Marbles
local function SellEquipmentsWithNPC()
    -- คุยกับ Marbles ก่อน
    TalkToMarbles()
    task.wait(0.5)
    
    -- ขาย Equipments
    for i, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        task.wait(0.3)
        if v["GUID"] and not table.find(InsertEquipments, v["GUID"]) then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                    Basket = {
                        [v["GUID"]] = true,
                    }
                })
                print("Sold Equipment:", v["GUID"])
            end)
        end
    end
end

-- Function ขาย Equipment (ไม่คุยกับ NPC - ใช้เมื่อคุยแล้ว)
local function SellEquipments()
    for i, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        task.wait(0.3)
        if v["GUID"] and not table.find(InsertEquipments, v["GUID"]) then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                    Basket = {
                        [v["GUID"]] = true,
                    }
                })
                print("Sold Equipment:", v["GUID"])
            end)
        end
    end
end

-- Function เช็คว่า Ore Rarity นี้ควรขายหรือไม่
local function ShouldSellOre(Rarity)
    return not table.find(Settings["Ignore Ore Rarity"], Rarity)
end

-- Function เช็คว่า Item ถูก Favorite หรือไม่
local function IsFavorited(ItemName)
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local FavoritedItems = PlayerInventory.FavoritedItems
    
    if FavoritedItems and type(FavoritedItems) == "table" then
        return FavoritedItems[ItemName] == true or table.find(FavoritedItems, ItemName) ~= nil
    end
    return false
end

-- Function คุยกับ NPC Greedy Cey สำหรับขาย Ore
local function TalkToGreedyCey()
    pcall(function()
        local greedyCey = workspace:WaitForChild("Proximity"):WaitForChild("Greedy Cey")
        local greedyPos
        
        -- หาตำแหน่ง NPC
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
            local targetPos = greedyPos + Vector3.new(0, 0, 5)
            local dist = (Plr.Character.HumanoidRootPart.Position - targetPos).Magnitude
            local maxDist = _G_MaxTeleportDistance or 9999
            
            -- เช็คระยะก่อนวาร์ป
            if dist > maxDist then
                print("[TalkToGreedyCey] ⚠️ NPC อยู่ไกลเกินไป (", math.floor(dist), "studs) - ข้ามไปก่อน")
                return
            end
            
            -- ใช้ Tween เสมอถ้าระยะ > 20 studs
            if dist > 20 then
                print("[TalkToGreedyCey] ระยะ", math.floor(dist), "studs - ใช้ Tween")
                local tweenSpeed = (dist/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                BypassAntiExploit()
                local tween = TweenService:Create(Plr.Character.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Wait()
            else
                BypassAntiExploit()
                Plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
            task.wait(0.5)
        end
        
        task.wait(0.3)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(greedyCey)
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.5)
        print("[TF_System] Talked to Greedy Cey")
    end)
end

-- Function ขาย Ore แบบ Dynamic - หาของดีที่สุดแล้วขายทุกอันที่ต่ำกว่า
local function SellOres()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local Basket = {}
    local SoldCount = 0
    local HighestRarity = 0
    local HighestRarityName = "None"
    local AllOres = {}
    
    print("[SellOres] Scanning inventory for best rarity...")
    
    -- Step 1: หา Rarity สูงสุดใน Inventory ก่อน
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData then
                local rarity = OreData["Rarity"]
                local rank = GetRarityRank(rarity)
                
                -- เก็บข้อมูล Ore ไว้ใช้ตอน Step 2
                table.insert(AllOres, {
                    Name = OreName,
                    Amount = Amount,
                    Rarity = rarity,
                    Rank = rank
                })
                
                -- อัพเดท Highest Rarity
                if rank > HighestRarity then
                    HighestRarity = rank
                    HighestRarityName = rarity
                end
            end
        end
    end
    
    print("[SellOres] 🏆 Best rarity found:", HighestRarityName, "(Rank:", HighestRarity, ")")
    
    -- Step 2: ขายทุกอันที่ต่ำกว่า Rarity สูงสุด (เก็บเฉพาะของดีที่สุด)
    for _, OreInfo in ipairs(AllOres) do
        if OreInfo.Rank < HighestRarity then
            -- Rarity ต่ำกว่า = ขาย
            if not IsFavorited(OreInfo.Name) then
                Basket[OreInfo.Name] = OreInfo.Amount
                SoldCount = SoldCount + OreInfo.Amount
                print("[SellOres] 💰 Will sell:", OreInfo.Name, "x", OreInfo.Amount, "[", OreInfo.Rarity, "] - Lower than best")
            else
                print("[SellOres] ⭐ Skipped (favorited):", OreInfo.Name)
            end
        else
            -- Rarity เท่ากับสูงสุด = เก็บไว้
            print("[SellOres] 🔒 Keep:", OreInfo.Name, "x", OreInfo.Amount, "[", OreInfo.Rarity, "] - Best rarity!")
        end
    end
    
    print("[SellOres] 📊 Total to sell:", SoldCount, "ores | Keeping:", HighestRarityName, "ores")
    
    if SoldCount > 0 then
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                Basket = Basket
            })
            print("[SellOres] Sold!")
        end)
    else
        print("[SellOres] Nothing to sell")
    end
end

local _G_RespawnCooldown = 0 -- cooldown หลังฟื้น
local _G_CurrentTweens = {} -- เก็บ Tweens ที่กำลังทำงาน
local _G_TweenSpeedMultiplier = 1 -- ตัวคูณความเร็ว Tween (ปกติ = 1, หลังตาย = 0.3-0.5)
local _G_MaxTeleportDistance = 9999 -- ระยะสูงสุดที่อนุญาตให้วาร์ป (หลังตายจะลดลง)

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

local function CancelAllTweens()
    for _, tween in pairs(_G_CurrentTweens) do
        pcall(function()
            if tween then
                tween:Cancel()
            end
        end)
    end
    _G_CurrentTweens = {}
end

local function WaitForRespawn()
    print("[Respawn] ⏳ รอฟื้น...")
    
    -- ยกเลิก Tweens ทั้งหมดที่กำลังทำงาน
    CancelAllTweens()
    
    -- รอให้ฟื้นและตัวละครโหลดเสร็จสมบูรณ์
    while not IsAlive() do
        task.wait(0.5)
    end
    
    -- รอให้ Character โหลดเสร็จ 100%
    local Char = Plr.Character
    while not Char or not Char:FindFirstChild("HumanoidRootPart") or not Char:FindFirstChildOfClass("Humanoid") do
        task.wait(0.3)
        Char = Plr.Character
    end
    
    -- รอให้ HumanoidRootPart มี CFrame ที่ถูกต้อง (ไม่ใช่ 0,0,0)
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    while HRP and (HRP.Position - Vector3.new(0,0,0)).Magnitude < 10 do
        task.wait(0.3)
        HRP = Char:FindFirstChild("HumanoidRootPart")
    end
    
    -- บันทึกตำแหน่ง spawn
    local spawnPosition = HRP and HRP.Position or Vector3.new(0, 0, 0)
    print("[Respawn] ✅ ฟื้นแล้ว ที่ตำแหน่ง:", spawnPosition)
    
    -- รอให้นานมากขึ้น เพื่อให้ระบบเกมเสถียรสมบูรณ์
    print("[Respawn] ⏳ รอให้เกมเสถียร 5 วินาที...")
    task.wait(5)
    
    HasTalkedToMarbles = false
    HasTalkedToGreedyCey = false
    -- ไม่ต้องรีเซ็ต _G_CurrentWorld เพราะจะเช็คจากเกมจริง
    _G_TweenSpeedMultiplier = 0.3 -- ลดความเร็ว Tween ลง 70% หลังตาย
    _G_MaxTeleportDistance = 100 -- จำกัดระยะวาร์ปเป็น 100 studs หลังตาย
    _G_LockedTarget = nil -- เคลียร์เป้าหมายล็อค
    _G_LastTargetTime = 0
    
    print("[Respawn] ⚠️ จำกัดระยะวาร์ปเป็น 100 studs ชั่วคราว")
    
    -- ไม่ซื้อ Potion ทันที - ให้ฟาร์มใกล้ๆ ก่อน
    print("[Respawn] 🎯 พร้อมฟาร์ม - จะหา Rock/Mob ใกล้ๆ ก่อน")
    
    -- ซื้อ Potion ตามโหมด (ซื้อเต็มที่!)
    if Settings["Use Potions"] then
        -- ซื้อ Health Potion ก่อนเสมอ (สำคัญที่สุด!)
        print("[Respawn] ซื้อ Health Potion...")
        UsePotion("Health")
        task.wait(1)
        
        if Settings["Farm Mode"] == "Rock" then
            print("[Respawn] ซื้อ Miner + Luck Potion...")
            UsePotion("Miner")
            task.wait(1)
            UsePotion("Luck")
        elseif Settings["Farm Mode"] == "Mob" then
            print("[Respawn] ซื้อ Damage Potion...")
            UsePotion("Damage")
            task.wait(1)
            -- ซื้อ Health เพิ่มเพื่อให้มีเยอะพอ
            UsePotion("Health")
        elseif Settings["Farm Mode"] == "Quest" then
            print("[Respawn] ซื้อ Damage + Miner + Luck Potion...")
            UsePotion("Damage")
            task.wait(1)
            UsePotion("Miner")
            task.wait(1)
            UsePotion("Luck")
        end
    end
    
    print("[Respawn] ✅ พร้อมฟาร์มต่อ!")
    task.wait(2) -- รออีกนิดก่อนกลับไปลูปหลัก
    _G_RespawnCooldown = tick() + 8 -- ห้ามทำงานอื่น 8 วินาทีหลังฟื้น
    
    -- ค่อยๆ เพิ่มระยะวาร์ปกลับมาปกติ
    task.spawn(function()
        task.wait(10)
        _G_MaxTeleportDistance = 300
        print("[Respawn] 📍 เพิ่มระยะวาร์ปเป็น 300 studs")
        
        task.wait(10)
        _G_MaxTeleportDistance = 9999
        _G_TweenSpeedMultiplier = 1
        print("[Respawn] 🚀 ระยะวาร์ปและความเร็วกลับมาปกติแล้ว")
    end)
end

local _G_IsProcessing = false -- ป้องกันการทำงานซ้อน

task.spawn(function()
    while true do 
        task.wait(0.2) -- เพิ่มจาก 0.1 เป็น 0.2
        
        -- ถ้ากำลังประมวลผลอยู่ ข้าม
        if _G_IsProcessing then continue end
        
        local success, err = pcall(function()
            if not IsAlive() then
                _G_IsProcessing = true
                WaitForRespawn()
                _G_IsProcessing = false
                return
            end
            
            -- ถ้ายังอยู่ใน cooldown หลังฟื้น ให้รอก่อน
            if tick() < _G_RespawnCooldown then
                return
            end
            
            local Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            -- ใช้ Potion ตามโหมดที่ฟาร์ม
            UsePotionsForMode(Settings["Farm Mode"])
            
            if Settings["Farm Mode"] == "Quest" then
                -- Quest Mode
                ProcessQuest()
                
            elseif Settings["Farm Mode"] == "Mob" then
                -- เช็คว่ามี Mob ที่เลือกในแมพหรือไม่
                local foundMobInMap = false
                if Settings["Select Mobs"] and #Settings["Select Mobs"] > 0 then
                    local Living = workspace:FindFirstChild("Living")
                    if Living then
                        for _, mob in pairs(Living:GetChildren()) do
                            if mob:IsA("Model") then
                                for _, targetMobName in pairs(Settings["Select Mobs"]) do
                                    if string.find(mob.Name, targetMobName) then
                                        foundMobInMap = true
                                        break
                                    end
                                end
                                if foundMobInMap then break end
                            end
                        end
                    end
                end
                
                -- ถ้าไม่มี Mob ในแมพ และยังไม่ได้เช็คโลกใน 30 วินาที ให้ลองวาร์ป
                if not foundMobInMap and Settings["Select Mobs"] and #Settings["Select Mobs"] > 0 and tick() > _G_LastWorldCheck then
                    local targetMobName = Settings["Select Mobs"][1]
                    local requiredWorld = GetMobWorld(targetMobName)
                    local actualCurrentWorld = GetCurrentWorld()
                    
                    print("[Mob] ไม่พบ", targetMobName, "ในแมพ")
                    print("[Mob] โลกปัจจุบัน:", actualCurrentWorld or "ไม่ทราบ")
                    print("[Mob] โลกที่ต้องการ:", requiredWorld)
                    
                    -- ถ้าไม่รู้โลกปัจจุบัน หรืออยู่โลกผิด ให้วาร์ป
                    if not actualCurrentWorld or requiredWorld ~= actualCurrentWorld then
                        print("[Mob] ลองวาร์ปไป:", requiredWorld)
                        local success = TeleportToWorld(requiredWorld)
                        
                        -- ตั้ง cooldown ไม่ว่าจะสำเร็จหรือไม่
                        if success then
                            _G_LastWorldCheck = tick() + 30 -- ห้ามเช็คอีก 30 วินาที
                            task.wait(3) -- รอให้วาร์ปเสร็จ
                        else
                            _G_LastWorldCheck = tick() + 20 -- ถ้าล้มเหลว รออีก 20 วินาที (เพิ่มจาก 10)
                            print("[Mob] ⚠️ วาร์ปล้มเหลว รออีก 20 วินาที")
                        end
                        return -- ให้รอบนี้จบ ไม่ฟาร์ม
                    else
                        -- อยู่โลกถูกแล้ว แต่ไม่มี Mob อาจจะยังไม่ spawn
                        _G_LastWorldCheck = tick() + 15
                        print("[Mob] อยู่โลกถูกแล้ว รอ Mob spawn...")
                    end
                elseif not foundMobInMap then
                    -- ไม่มี Mob แต่ยังอยู่ใน cooldown
                    -- ไม่ต้องพิมพ์ log เพราะจะ spam
                    task.wait(2) -- รออีก 2 วินาที
                end
                
                -- ถ้าเลือก Golem ต้องเปิดประตูก่อน
                if IsGolemSelected() and not _G_GolemDoorOpened then
                    print("[Mob] ตรวจพบ Golem ใน Select Mobs - กำลังเปิดประตู...")
                    OpenGolemDoor()
                    task.wait(1)
                end
                
                local Mob = getNearestMob(Char)
                local LastAttack = 0
                local LastTween = nil
                local LastHP = Char:FindFirstChildOfClass("Humanoid").Health
                local HitCount = 0
                local CheckTime = tick()
                
                if Mob then
                    print("Found Mob:", Mob.Name)
                    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                    
                    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 do
                        task.wait(0.1) -- เพิ่มจาก 0.05 เป็น 0.1
                        
                        if not IsAlive() then
                            if LastTween then LastTween:Cancel() end
                            return
                        end
                        
                        Char = Plr.Character
                        if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        
                        local MyHumanoid = Char:FindFirstChildOfClass("Humanoid")
                        if not MyHumanoid then return end
                        
                        -- ตรวจสอบว่าโดนตีหรือไม่ (HP ลดลง)
                        local CurrentHP = MyHumanoid.Health
                        if CurrentHP < LastHP then
                            HitCount = HitCount + 1
                            -- โดนตี! เพิ่มระยะห่าง
                            _G.SafeHeightOffset = (_G.SafeHeightOffset or 2) + 1
                            print("[Farm] โดนตี! เพิ่มระยะเป็น +", _G.SafeHeightOffset, "studs")
                            CheckTime = tick() -- รีเซ็ตเวลา
                        end
                        LastHP = CurrentHP
                        
                        -- ถ้าไม่โดนตี 2 วินาที และ offset > 2 ลองลดลงเร็วขึ้น
                        if tick() - CheckTime > 2 then
                            if HitCount == 0 and (_G.SafeHeightOffset or 2) > 2 then
                                _G.SafeHeightOffset = math.max(2, _G.SafeHeightOffset - 1)
                                print("[Farm] ไม่โดนตี ลดระยะเป็น +", _G.SafeHeightOffset, "studs")
                            end
                            HitCount = 0
                            CheckTime = tick()
                        end
                        
                        -- เช็ค Mob ยังอยู่ไหม
                        if not Mob or not Mob.Parent then break end
                        
                        MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                        if not MobHRP then break end
                        
                        MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                        if not MobHumanoid or MobHumanoid.Health <= 0 then break end
                        
                        local MobPosition = MobHRP.Position
                        local MyPosition = Char.HumanoidRootPart.Position
                        -- เช็คระยะ XZ เท่านั้น (ไม่รวมแกน Y) เพื่อให้ทำงานตอนลอยอยู่ข้างบน
                        local MagnitudeXZ = (Vector3.new(MyPosition.X, 0, MyPosition.Z) - Vector3.new(MobPosition.X, 0, MobPosition.Z)).Magnitude
                        
                        local MobSize = Mob:GetExtentsSize()
                        local MobHeight = MobSize.Y
                        
                        -- ท่านอนใต้ดิน (อยู่ใต้ Mob แล้วตีขึ้นมา)
                        local SafePosition = MobPosition - Vector3.new(0, MobHeight/2 + (_G.SafeHeightOffset or 2), 0)
                        
                        if MagnitudeXZ < 20 then
                            if LastTween then
                                LastTween:Cancel()
                            end
                            task.delay(.01, function()
                                if tick() > LastAttack and IsAlive() then
                                    AttackMob()
                                    LastAttack = tick() + 0.15 -- เพิ่มจาก 0.1 เป็น 0.15
                                end
                            end)
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                BypassAntiExploit()
                                -- ท่านอนหงาย (หันหน้าขึ้น) เพื่อตี Mob ที่อยู่ข้างบน
                                Char.HumanoidRootPart.CFrame = CFrame.new(SafePosition) * CFrame.Angles(math.rad(90), 0, 0)
                            end
                        else
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                -- ใช้ TweenSpeedMultiplier เพื่อควบคุมความเร็ว
                                local tweenSpeed = (MagnitudeXZ/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                                
                                -- ถ้า Tween เร็วเกินไป (< 0.5 วินาที) ให้ปรับให้ช้าลง
                                if tweenSpeed < 0.5 then
                                    tweenSpeed = 0.5
                                end
                                
                                BypassAntiExploit()
                                task.wait(0.05) -- delay เล็กน้อยก่อน Tween
                                -- Tween ไป Mob พร้อมท่านอนหงาย (อยู่ใต้ Mob)
                                LastTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(SafePosition) * CFrame.Angles(math.rad(90), 0, 0)})
                                LastTween:Play()
                                table.insert(_G_CurrentTweens, LastTween) -- เก็บ reference
                            end
                        end
                    end
                else
                    print("[Mob] ไม่พบมอนสเตอร์ที่อยู่ใน list รอหา...")
                    task.wait(2) -- เพิ่มเวลารอ
                end
                
            elseif Settings["Farm Mode"] == "Rock" and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() then
                -- เช็คว่ามีหินที่เลือกในแมพหรือไม่
                local foundRockInMap = false
                if Settings["Select Rocks"] and #Settings["Select Rocks"] > 0 then
                    local Rocks = workspace:FindFirstChild("Rocks")
                    if Rocks then
                        for _, rock in pairs(Rocks:GetDescendants()) do
                            -- ใช้ exact match (ชื่อต้องตรงเป๊ะ) เพื่อไม่ให้ตีหินมั่ว
                            if rock:IsA("Model") and rock:GetAttribute("Health") and table.find(Settings["Select Rocks"], rock.Name) then
                                foundRockInMap = true
                                break
                            end
                        end
                    end
                end
                
                -- ถ้าไม่มีหินในแมพ และยังไม่ได้เช็คโลกใน 30 วินาที ให้ลองวาร์ป
                if not foundRockInMap and Settings["Select Rocks"] and #Settings["Select Rocks"] > 0 and tick() > _G_LastWorldCheck then
                    local targetRockName = Settings["Select Rocks"][1]
                    local requiredWorld = GetRockWorld(targetRockName)
                    local actualCurrentWorld = GetCurrentWorld()
                    
                    print("[Rock] ไม่พบ", targetRockName, "ในแมพ")
                    print("[Rock] โลกปัจจุบัน:", actualCurrentWorld or "ไม่ทราบ")
                    print("[Rock] โลกที่ต้องการ:", requiredWorld)
                    
                    -- ถ้าไม่รู้โลกปัจจุบัน หรืออยู่โลกผิด ให้วาร์ป
                    if not actualCurrentWorld or requiredWorld ~= actualCurrentWorld then
                        print("[Rock] ลองวาร์ปไป:", requiredWorld)
                        local success = TeleportToWorld(requiredWorld)
                        
                        -- ตั้ง cooldown ไม่ว่าจะสำเร็จหรือไม่
                        if success then
                            _G_LastWorldCheck = tick() + 30 -- ห้ามเช็คอีก 30 วินาที
                            task.wait(3) -- รอให้วาร์ปเสร็จ
                        else
                            _G_LastWorldCheck = tick() + 20 -- ถ้าล้มเหลว รออีก 20 วินาที (เพิ่มจาก 10)
                            print("[Rock] ⚠️ วาร์ปล้มเหลว รออีก 20 วินาที")
                        end
                        return -- ให้รอบนี้จบ ไม่ฟาร์ม
                    else
                        -- อยู่โลกถูกแล้ว แต่ไม่มีหิน อาจจะยังไม่ spawn
                        _G_LastWorldCheck = tick() + 15
                        print("[Rock] อยู่โลกถูกแล้ว รอหิน spawn...")
                    end
                elseif not foundRockInMap then
                    -- ไม่มีหิน แต่ยังอยู่ใน cooldown
                    -- ไม่ต้องพิมพ์ log เพราะจะ spam
                    task.wait(2) -- รออีก 2 วินาที
                end
                
                -- ใช้เป้าหมายที่ล็อคไว้ถ้ายังใช้ได้
                local Rock = nil
                if _G_LockedTarget and _G_LockedTarget.Parent and _G_LockedTarget:GetAttribute("Health") and _G_LockedTarget:GetAttribute("Health") > 0 then
                    Rock = _G_LockedTarget
                else
                    Rock = getnearest(Char)
                    if Rock then
                        _G_LockedTarget = Rock
                        _G_LastTargetTime = tick()
                        print("[Rock] ล็อคเป้าหมายใหม่:", Rock.Name)
                    end
                end
                
                local LastAttack = 0
                local LastTween = nil
                if Rock then
                    _G_IsProcessing = true -- ล็อคไม่ให้ลูปซ้อน
                    local Position = Rock:GetAttribute("OriginalCFrame").Position
                    while Rock and Rock.Parent and Rock:GetAttribute("Health") and Rock:GetAttribute("Health") > 0 and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() do 
                        task.wait(0.15) -- เพิ่มจาก 0.1 เป็น 0.15
                        
                        if not IsAlive() then 
                            if LastTween then LastTween:Cancel() end
                            _G_IsProcessing = false
                            return
                        end
                        
                        Char = Plr.Character
                        if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        
                        local MyPosition = Char.HumanoidRootPart.Position
                        -- เช็คระยะ XZ เท่านั้น (ไม่รวมแกน Y) เพื่อให้ทำงานตอนลอยอยู่ข้างบน
                        local MagnitudeXZ = (Vector3.new(MyPosition.X, 0, MyPosition.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude
                        
                        if MagnitudeXZ < 15 then
                            if LastTween then
                                LastTween:Cancel()
                            end
                            if tick() > LastAttack and IsAlive() then
                                pcall(function()
                                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Pickaxe")
                                end)
                                LastAttack = tick() + .25 -- เพิ่มจาก 0.2 เป็น 0.25
                            end
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                BypassAntiExploit()
                                Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0,0,0.75))
                            end
                        else
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                -- ใช้ TweenSpeedMultiplier เพื่อควบคุมความเร็ว
                                local tweenSpeed = (MagnitudeXZ/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                                
                                -- ถ้า Tween เร็วเกินไป (< 0.5 วินาที) ให้ปรับให้ช้าลง
                                if tweenSpeed < 0.5 then
                                    tweenSpeed = 0.5
                                end
                                
                                BypassAntiExploit()
                                task.wait(0.05) -- delay เล็กน้อยก่อน Tween
                                LastTween = TweenService:Create(Char.HumanoidRootPart,TweenInfo.new(tweenSpeed,Enum.EasingStyle.Linear),{CFrame = CFrame.new(Position)})
                                LastTween:Play()
                                table.insert(_G_CurrentTweens, LastTween) -- เก็บ reference
                            end
                        end
                    end
                    
                    -- หินหมด เคลียร์ล็อค
                    _G_LockedTarget = nil
                    _G_IsProcessing = false
                else
                    -- ไม่มีหินตาม list ที่ตีได้ในแมพ - รอหินเกิดใหม่
                    print("[Rock] ไม่พบหินที่อยู่ใน list รอหา...")
                    task.wait(2)
                end
            else
                if not IsAlive() then return end
                
                local CanForge = true
                local Position = workspace.Proximity.Forge.Position
                
                Char = Plr.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local Magnitude = (Char.HumanoidRootPart.Position - Position).Magnitude
                if Magnitude < 5 then
                    Char.HumanoidRootPart.CFrame = CFrame.new(Position)
                    
                    local ForgeCount = 0
                    
                    while CanForge do 
                        task.wait()
                        if not IsAlive() then return end
                        
                        local Recipe = GetRecipe()
                        if Recipe then
                            print("Forging")
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
                        
                        -- Reset flags หลังขายเสร็จ เพื่อให้รอบหน้าคุยใหม่ได้
                        HasTalkedToMarbles = false
                        HasTalkedToGreedyCey = false
                    end
                else
                    if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                        -- ใช้ TweenSpeedMultiplier เพื่อควบคุมความเร็ว
                        local tweenSpeed = (Magnitude/TWEEN_SPEED) / (_G_TweenSpeedMultiplier or 1)
                        local ForgeTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                        ForgeTween:Play()
                        table.insert(_G_CurrentTweens, ForgeTween) -- เก็บ reference
                    end
                end
            end
        end)
    end
end)
if _G.Stepped then
    _G.Stepped:Disconnect()
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