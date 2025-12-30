local Settings = {
    ["Select Rocks"] = {"Pebble"},
    ["Ignore Forge Rarity"] = {
        "Legendary",
        "Mythic",
        "Relic",
        "Exotic",
        "Divine",
        "Unobtainable",
    }
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
        end
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
end

Auto_Config()

local Plr = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Inventory = require(ReplicatedStorage.Controllers.UIController.Inventory)
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)
local Ores = require(ReplicatedStorage.Shared.Data.Ore)


local PlayerController = Knit.GetController("PlayerController")
local ChangeSequence = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("ChangeSequence")
local InsertEquipments = {}
for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do
    table.insert(InsertEquipments,v["GUID"])
end
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
    print("Finish Forging")
    
    task.wait(2) -- รอนานขึ้นให้ไอเทมเข้า Inventory
    
    -- ขาย Equipment ทั้งหมดที่ไม่ใช่ของเดิม
    local Equipments = PlayerController.Replica.Data.Inventory["Equipments"]
    print("Total Equipments:", #Equipments)
    
    -- รวม GUID ทั้งหมดที่จะขาย
    local SellBasket = {}
    for i,v in pairs(Equipments) do
        print("Checking Equipment:", i, v["GUID"], "In Original:", table.find(InsertEquipments, v["GUID"]))
        if v["GUID"] and not table.find(InsertEquipments, v["GUID"]) then
            SellBasket[v["GUID"]] = true
            print("Added to basket:", v["GUID"])
        end
    end
    
    -- ขายทีเดียวทั้ง Basket
    if next(SellBasket) then
        print("Selling basket...")
        
        -- ลองวิธีที่ 1: SellConfirm
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("SellConfirm", {
                Basket = SellBasket
            })
        end)
        task.wait(1)
        
        -- ลองวิธีที่ 2: Sell
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer("Sell", {
                Basket = SellBasket
            })
        end)
        task.wait(1)
        
        -- ลองวิธีที่ 3: InventoryService
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("SellItems"):InvokeServer(SellBasket)
        end)
        
        print("Sell commands sent")
    else
        print("Nothing to sell")
    end
    print("Finish Selling")
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
    print("Player died, waiting for respawn...")
    while not IsAlive() do
        task.wait(0.5)
    end
    task.wait(2) -- รอให้ตัวละครพร้อมหลังฟื้น
    print("Player respawned, resuming mining...")
end

task.spawn(function()
    while true do task.wait(0.1)
        local success, err = pcall(function()
            -- ตรวจสอบว่าตัวละครยังมีชีวิตอยู่หรือไม่
            if not IsAlive() then
                WaitForRespawn()
                return
            end
            
            local Char = Plr.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            if Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() then
                local Rock = getnearest(Char)
                local LastAttack = 0
                local LastTween = nil
                if Rock then
                    local Position = Rock:GetAttribute("OriginalCFrame").Position
                    while Rock:GetAttribute("Health") > 0 and Inventory:CalculateTotal("Stash") < Inventory:GetBagCapacity() do 
                        task.wait(0.1)
                        
                        -- เช็คทุก loop ว่ายังมีชีวิตอยู่
                        if not IsAlive() then 
                            if LastTween then LastTween:Cancel() end
                            return -- ออกจาก function ทันที
                        end
                        
                        -- ดึง Char ใหม่ทุกครั้งเพื่อป้องกัน reference เก่า
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
                    for i,v in pairs(PlayerController.Replica.Data.Inventory["Equipments"]) do task.wait(1)
                        if v["GUID"] and not table.find(InsertEquipments,v["GUID"]) then
                            task.spawn(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("RunCommand"):InvokeServer( "SellConfirm",
                                {
                                    Basket = {
                                        [v["GUID"]] = true,
                                    }
                                })
                            end)
                        end
                    end
                    while CanForge do task.wait()
                        if not IsAlive() then return end
                        print("Here")
                        local Recipe = GetRecipe()
                         print(Recipe)
                        if Recipe then
                            Forge(Recipe)
                        else
                            CanForge = false
                        end
                    end
                else
                    if IsAlive() and Char:FindFirstChild("HumanoidRootPart") then
                        local ForgeTween = TweenService:Create(Char.HumanoidRootPart,TweenInfo.new(Magnitude/80,Enum.EasingStyle.Linear),{CFrame = CFrame.new(Position)})
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
    if not IsAlive() then return end -- ไม่ทำอะไรถ้าตาย
    
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