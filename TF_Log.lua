

repeat task.wait(30) until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local Client = Players.LocalPlayer

local Inventory = require(ReplicatedStorage.Controllers.UIController.Inventory)
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)
local Ores = require(ReplicatedStorage.Shared.Data.Ore)
local PlayerController = Knit.GetController("PlayerController")
-- Folder
print("Loading..") 

local Url = "https://api.championshop.date"
local List = {
    "Gold",
    "Level",
    "Exp",
    "CurrentIsland",
    "Race",
}
task.wait(1.5)
local names = {"K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dd", "Ud", "Dd", "Td", "Qad", "Qid", 
	"Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg"}
local pows = {}
for i = 1, #names do table.insert(pows, 1000^i) end

local function formatNumber(x)
	local ab = math.abs(x)
	if ab < 1000 then return tostring(x) end 
	local p = math.min(math.floor(math.log10(ab)/3), #names)
	local num = math.floor(ab/pows[p]*100)/100
	return num*math.sign(x)..names[p]
end

local function convertToField(index,value)
    return {
        ["name"] = tostring(index),
        ["value"] = tonumber(value) or 0
    }
end
local function convertToField_(table_)
    local Field = {}
    for i,v in pairs(table_) do
        Field[#Field + 1] = convertToField(i, v)
    end
    return Field
end
local function GetSomeCurrency(tr)
    local Data = PlayerController["Replica"]["Data"]
    local Field = {}
    for i,v in pairs(Data) do
        if table.find(List,i) then
            -- ถ้าไม่ใช่ tr ให้ดึงเฉพาะ Gold และ Exp (สำหรับ currency)
            if not tr and i ~= "Gold" and i ~= "Exp" then
                continue
            end
            Field[i] = v
        end
    end
    return Field
end
local function CreateBody(...)
    local Data = request({
        ["Url"] = Url .. "/api/v1/shop/orders/" .. Client.Name,
        ["Method"] = "GET",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
    })
    print(Data["Success"])
    local Order_Data = HttpService:JSONDecode(Data["Body"])["data"]
    local body = {
        ["order_id"] = Order_Data[1]["id"],
    }
    local array = {...}
    for i,v in pairs(array) do
        for i1,v1 in pairs(v) do
            body[i1] = v1
        end
    end
    return body
end
local function SendTo(Url,...)
    warn("Hi")
    local response = request({
        ["Url"] = Url,
        ["Method"] = "POST",
        ["Headers"] = {
            ["content-type"] = "application/json",
            ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
        },
        ["Body"] = HttpService:JSONEncode(CreateBody(...))
    })
    for i,v in pairs(response) do
        warn(i,v)
    end 
    return response
end

local function GetAllData()
    local Data = PlayerController["Replica"]["Data"]
    local LocalData_ = GetSomeCurrency(true)
    
    -- ดึงชื่อจาก workspace.Rocks (ดึงชื่อ Rock จาก Model ข้างใน)
    local RockNames = {}
    pcall(function()
        local Rocks = workspace:FindFirstChild("Rocks")
        if Rocks then
            for _, folder in pairs(Rocks:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, rockContainer in pairs(folder:GetChildren()) do
                        -- ดึงชื่อ Rock จาก Model ข้างใน
                        for _, rockModel in pairs(rockContainer:GetChildren()) do
                            if rockModel:IsA("Model") then
                                local rockName = rockModel.Name
                                if not table.find(RockNames, rockName) then
                                    table.insert(RockNames, rockName)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- ดึงชื่อจาก workspace.Living (Mobs) - เอาเลขและชื่อซ้ำออก
    local MobNames = {}
    pcall(function()
        local Living = workspace:FindFirstChild("Living")
        if Living then
            for _, mob in pairs(Living:GetChildren()) do
                if mob:IsA("Model") then
                    -- เอาเลขท้ายชื่อออก (เช่น "Zombie 1" -> "Zombie")
                    local mobName = mob.Name:gsub("%s*%d+$", "")
                    if mobName ~= "" and not table.find(MobNames, mobName) then
                        table.insert(MobNames, mobName)
                    end
                end
            end
        end
    end)
    
    -- ดึงชื่อ NPC จาก workspace.Proximity (เฉพาะที่มี Model และ Humanoid)
    local NPCNames = {}
    pcall(function()
        local Proximity = workspace:FindFirstChild("Proximity")
        if Proximity then
            for _, npc in pairs(Proximity:GetChildren()) do
                -- ข้าม object ที่ไม่ใช่ NPC
                local skipNames = {"Forge", "CreateParty", "Anvil", "Furnace", "Workbench", "Portal", "Door", "Gate", "Chest", "Crate"}
                local isSkip = false
                for _, skipName in pairs(skipNames) do
                    if string.find(npc.Name, skipName) then
                        isSkip = true
                        break
                    end
                end
                
                -- เช็คว่าเป็น NPC จริง (มี Model หรือ Humanoid)
                if not isSkip then
                    local isNPC = false
                    if npc:IsA("Model") then
                        -- เช็คว่ามี Humanoid หรือ HumanoidRootPart
                        if npc:FindFirstChildOfClass("Humanoid") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc:FindFirstChild("Head") then
                            isNPC = true
                        end
                    end
                    
                    if isNPC and not table.find(NPCNames, npc.Name) then
                        table.insert(NPCNames, npc.Name)
                    end
                end
            end
        end
    end)
    
    return {
        ["Inventory"] = Data["Inventory"],
        ["PlayerData"] = LocalData_,
        ["Username"] = Client.Name,
        ["Pickaxe"] = Data["Equipped"]["Pickaxe"]["Name"],
        ["Rocks"] = RockNames,
        ["Mobs"] = MobNames,
        ["NPCs"] = NPCNames
    }
end

local Data = GetAllData()
local StartLevel = Data["PlayerData"]["Level"]
local StartGold = Data["PlayerData"]["Gold"] or 0
SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})

task.spawn(function ()
    local Ores = {}
    PlayerController.Replica:OnWrite("GiveItem", function(t, v)
        if type(t) == "string" then
            Ores[#Ores + 1] = {
                ["Name"] = t,
                ["Value"] = v,
            }
        elseif type(t) == "table" and t["Name"] then
            Ores[#Ores + 1] = {
                ["Name"] = t["Name"],
                ["Value"] = t["Amount"] or t["Value"] or v or 1,
            }
        end
    end)
    while true do task.wait()
        -- print(#Fishs)
        if #Ores >= 10 then
            local Data = GetAllData()
            local ConvertOres = {}
            local LastConvertOres = {}
            
            for i,v in pairs(Ores) do
                if ConvertOres[v["Name"]] then
                    ConvertOres[v["Name"]] = ConvertOres[v["Name"]] + v["Value"]
                else
                    ConvertOres[v["Name"]] = v["Value"]
                end
            end
            for i,v in pairs(ConvertOres) do
                LastConvertOres[#LastConvertOres + 1] = convertToField(i,v)
            end
            if Data["PlayerData"]["Level"]  ~=  StartLevel then
                LastConvertOres[#LastConvertOres + 1] = convertToField("Level",1)
                StartLevel = Data["PlayerData"]["Level"]
            end

            local CurrentGold = Data["PlayerData"]["Gold"] or 0
            if CurrentGold > StartGold then
                local GoldGained = CurrentGold - StartGold
                LastConvertOres[#LastConvertOres + 1] = convertToField("Gold", GoldGained)
                StartGold = CurrentGold
            end

            -- เพิ่ม Quest Completed logs จาก _G.CompletedQuestsLog
            if _G.CompletedQuestsLog and #_G.CompletedQuestsLog > 0 then
                local QuestCounts = {}
                for _, quest in pairs(_G.CompletedQuestsLog) do
                    local npcName = quest.NPC or "Unknown"
                    if QuestCounts[npcName] then
                        QuestCounts[npcName] = QuestCounts[npcName] + 1
                    else
                        QuestCounts[npcName] = 1
                    end
                end
                for npcName, count in pairs(QuestCounts) do
                    LastConvertOres[#LastConvertOres + 1] = convertToField(npcName .. " Complete", count)
                end
                -- Clear the log after sending
                _G.CompletedQuestsLog = {}
            end

            local StageInfo = {
                ["win"] = true,
                ["map"] = {
                    ["name"] = Data["PlayerData"]["CurrentIsland"],
                    ["chapter"] = tostring(Data["PlayerData"]["Race"]),
                    ["wave"] = "0",
                    ["mode"] = tostring(Data["PlayerData"]["Level"]),
                    ["difficulty"] = tostring(Data["Pickaxe"]),
                },
            }
            SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = LastConvertOres},{["state"] = StageInfo},{["time"] = 120},{["Data"] = Data},{["currency"] = convertToField_(GetSomeCurrency())})
            SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = Data})
            Ores = {} 
        end
    end
end)

-- GetSomeCurrency()