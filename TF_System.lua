local Settings = {
    ["Farm Mode"] = "Mob",
    ["Select Mobs"] = {"Skeleton Rogue"},
    ["Select Rocks"] = {"Pebble"},
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
        Settings["Ignore Forge Rarity"] = {
            "Legendary",
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
        Settings["Ignore Forge Rarity"] = {
            "Legendary",
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
        Settings["Ignore Forge Rarity"] = {
            "Legendary",
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
    end,
    ["0f7ac08a-4267-44d7-a235-6fd0ae26e723"] = function()
        Settings["Farm Mode"] = "Mob"
        Settings["Select Mobs"] = {"Zombie"}
    end,
    ["00f8cd69-bfbe-4dce-9289-ed01082bc60f"] = function()
        Settings["Farm Mode"] = "Mob"
        Settings["Select Mobs"] = {"Zombie"}
    end,
}
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
        -- ปิด UI DailyLogin
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
        end
        local Product = OrderData["product"]
        local Goal = Product["condition"]["value"]
        if Product["condition"]["type"] == "level" then
            if tonumber(OrderData["progress_value"]) >= (tonumber(OrderData["targaet_value"])) then
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
end

Auto_Config()

local Plr = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local DailyLogin = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("DailyLogin"))

-- ลองเช็คว่ามี function อะไรบ้าง
for k, v in pairs(DailyLogin) do
    print(k, typeof(v))
end

-- ถ้ามี Close
if DailyLogin.Close then
    DailyLogin.Close()
end

local Inventory = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("UIController"):WaitForChild("Inventory"))
local Knit = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"))
local Ores = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Ore"))


local PlayerController = Knit.GetController("PlayerController")
local ChangeSequence = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("ChangeSequence")
local InsertEquipments = {}
for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
    table.insert(InsertEquipments,v["GUID"])
end

local HasTalkedToMarbles = false

PlayerController.Replica:OnWrite("GiveItem", function(t, v)
    print(t,v)
    if type(t) == "table" then
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer( "SellConfirm",
        {
            Basket = {
                [t["GUID"]] = true,
            }
        })
    end
end)
local function GetOre(Name)
    for i,v in pairs(Ores) do
        if v["Name"] == Name then
            return v
        end 
    end
    return false
end
local function GetRecipe()
    local Repipe = {}
    local Count = 0
    local HowMany = 0
    for i,v in pairs(PlayerController.Replica.Data.Inventory) do
        local Ore = GetOre(i)
        
        if Ore and not table.find(Settings["Ignore Forge Rarity"],Ore["Rarity"]) then
            Repipe[i] = v
            Count = Count + v
            HowMany = HowMany + 1
            if HowMany >= 4 then
                break;
            end
        end
    end
    if Count < 3 then
        return false
    else
        return Repipe
    end
end
local function getnearest(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    for _,v in pairs(workspace.Rocks:GetChildren()) do
        if v:IsA("Folder") then
            for i1,v1 in pairs(v:GetChildren()) do
                local Model = v1:FindFirstChildWhichIsA("Model")
                if Model and Model:GetAttribute("Health") > 0 and table.find(Settings["Select Rocks"],Model.Name) then
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
    return path
end

local function getNearestMob(P_Char)
    local path = nil
    local dis = math.huge
    local p_pos = P_Char["HumanoidRootPart"]["Position"]
    
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

local function AttackMob()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Weapon")
    end)
end

local function Forge(Recipe)
    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("StartForge"):InvokeServer(workspace:WaitForChild("Proximity"):WaitForChild("Forge"))
    ChangeSequence:InvokeServer("Melt",
        {
            FastForge = true,
            ItemType = "Weapon"
        }
    )
    task.wait(1)
    local Melt = ChangeSequence:InvokeServer("Melt",
        {
            FastForge = true,
            ItemType = "Weapon",
            Ores = Recipe
        }
    )
    task.wait(Melt["MinigameData"]["RequiredTime"])
    local Pour = ChangeSequence:InvokeServer( "Pour",
        {
            ClientTime = workspace:GetServerTimeNow()
        }
    )
    task.wait(Pour["MinigameData"]["RequiredTime"])
    local Hammer = ChangeSequence:InvokeServer("Hammer",{ClientTime = workspace:GetServerTimeNow()})
    task.wait(Hammer["MinigameData"]["RequiredTime"])
    task.spawn(function()
        ChangeSequence:InvokeServer("Water",{ClientTime = workspace:GetServerTimeNow() })
    end)
    task.wait(1)
    ChangeSequence:InvokeServer("Showcase",{})
    task.wait(.5)
    ChangeSequence:InvokeServer("OreSelect",{})
    pcall(require(game:GetService("ReplicatedStorage").Controllers.UIController.Forge).Close)
    print("Finish")
end

local function TalkToMarbles()
    if HasTalkedToMarbles then return end
    
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
            -- วาร์ปไปตรงๆ แทน Tween เพื่อความแน่นอน
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(marblesPos + Vector3.new(0, 0, 5))
            print("วาร์ปไปหา Marbles เรียบร้อย")
            task.wait(0.5)
        end
        
        task.wait(0.3)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(marbles)
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.5)
        HasTalkedToMarbles = true
        print("Talked to Marbles")
    end)
end

local function SellEquipments()
    for i, v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
        task.wait(0.5)
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
            -- วาร์ปไปหา NPC
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(greedyPos + Vector3.new(0, 0, 5))
            print("วาร์ปไปหา Greedy Cey เรียบร้อย")
            task.wait(0.5)
        end
        
        task.wait(0.3)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(greedyCey)
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RE"):WaitForChild("DialogueEvent"):FireServer("Opened")
        task.wait(0.5)
        print("Talked to Greedy Cey")
    end)
end

-- Function ขาย Ore ทั้งหมดที่ไม่อยู่ใน Ignore list และไม่ถูก Favorite
local function SellOres()
    local PlayerInventory = PlayerController.Replica.Data.Inventory
    local Basket = {}
    local SoldCount = 0
    
    for OreName, Amount in pairs(PlayerInventory) do
        if type(Amount) == "number" and Amount > 0 then
            local OreData = GetOre(OreName)
            if OreData and ShouldSellOre(OreData["Rarity"]) then
                if not IsFavorited(OreName) then
                    Basket[OreName] = Amount
                    SoldCount = SoldCount + Amount
                    print(string.format("จะขาย Ore: %s x%d", OreName, Amount))
                else
                    print(string.format("⭐ ข้าม (Favorite): %s x%d", OreName, Amount))
                end
            end
        end
    end
    
    if SoldCount > 0 then
        -- คุยกับ Greedy Cey ก่อนขาย
        print("กำลังคุยกับ Greedy Cey...")
        TalkToGreedyCey()
        task.wait(0.5)
        
        print(string.format("กำลังขาย Ore รวม: %d ชิ้น", SoldCount))
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                Basket = Basket
            })
        end)
        print("ขาย Ore เสร็จสิ้น")
    else
        print("ไม่มี Ore ที่ต้องขาย")
    end
end

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
    HasTalkedToMarbles = false
    task.wait(2)
end

task.spawn(function()
    while true do task.wait(0.1)
        local success, err = pcall(function()
            if not IsAlive() then
                WaitForRespawn()
                return
            end
            
            local Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            if Settings["Farm Mode"] == "Mob" then
                local Mob = getNearestMob(Char)
                local LastAttack = 0
                local LastTween = nil
                
                if Mob then
                    print("Found Mob:", Mob.Name)
                    local MobHumanoid = Mob:FindFirstChildOfClass("Humanoid")
                    local MobHRP = Mob:FindFirstChild("HumanoidRootPart") or Mob:FindFirstChild("Torso") or Mob.PrimaryPart
                    
                    while MobHumanoid and MobHRP and MobHumanoid.Health > 0 do
                        task.wait(0.05)
                        
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
                    task.wait(1)
                end
                
            elseif Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() then
                local Rock = getnearest(Char)
                local LastAttack = 0
                local LastTween = nil
                if Rock then
                    local Position = Rock:GetAttribute("OriginalCFrame").Position
                    while Rock:GetAttribute("Health") > 0 and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() do 
                        task.wait(0.1)
                        
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
                                pcall(function()
                                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToolActivated"):InvokeServer("Pickaxe")
                                end)
                                LastAttack = tick() + .2
                            end
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                Char.HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0,0,2))
                            end
                        else
                            if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                                LastTween = TweenService:Create(Char.HumanoidRootPart,TweenInfo.new(Magnitude/80,Enum.EasingStyle.Linear),{CFrame = CFrame.new(Position)})
                                LastTween:Play()
                            end
                        end
                    end
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
                        print("Forge done, talking to Marbles...")
                        TalkToMarbles()
                        task.wait(0.5)
                        
                        print("Selling equipments...")
                        SellEquipments()
                        task.wait(0.5)
                        
                        print("Selling ores...")
                        SellOres()
                    end
                else
                    if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                        local ForgeTween = TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(Magnitude/80, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)})
                        ForgeTween:Play()
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