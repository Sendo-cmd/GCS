
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui
local Url = "https://api.championshop.date"
local List = {
    "Level",
    "Gold",
    "Gems",
    "TraitRerolls",
}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

repeat task.wait(10) until not plr:GetAttribute("Loading")

local PlayerModules = game:GetService("StarterPlayer"):WaitForChild("Modules")
local Modules = ReplicatedStorage:WaitForChild("Modules")


task.wait(1.5)
local IsTimeChamber = game.PlaceId == 18219125606

local url = "https://api.championshop.date/logs"
print(game.PlaceId)

local function convertToField(index,value)
    return {
        ["name"] = index,
        ["value"] = value or 1
    }
end
local function convertToField_(table_)
    local Field = {}
    for i,v in pairs(table_) do
        Field[#Field + 1] = convertToField(i,v)
    end
    return Field
end
local function GetSomeCurrency()
    local Field = {}
    for i,v in pairs(plr:GetAttributes()) do
        if table.find(List,i) then
            -- print(i,v)
            Field[i] = v
        end
    end
    return Field
end
local function CreateBody(...)
    local Data = request({
        ["Url"] = Url .. "/api/v1/shop/orders/" .. plr.Name,
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
        -- warn(i,v)
    end 
    return response
end
if IsTimeChamber then
    print("Time Chamber")
    SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = convertToField_(GetSomeCurrency())},{["state"] = {
                ["map"] = {
                        ["name"] = "AFK Time Chamber",
                        ["chapter"] = "AFK",
                        ["wave"] = "0",
                        ["mode"] = "AFK",
                        ["difficulty"] = "AFK"
                        },
                ["win"] = true,
            }},{["time"] = 0},{["currency"] = convertToField_(GetSomeCurrency())})
    while true do
        task.wait(200)
         SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = convertToField_(GetSomeCurrency())},{["state"] = {
                ["map"] = {
                        ["name"] = "AFK Time Chamber",
                        ["chapter"] = "AFK",
                        ["wave"] = "0",
                        ["mode"] = "AFK",
                        ["difficulty"] = "AFK"
                        },
                ["win"] = true,
            }},{["time"] = 200},{["currency"] = convertToField_(GetSomeCurrency())})
    end
    
    return false
end

local JamSessionSongs = {"Skele King's Theme", "Vanguards!", "Selfish Intentions"}
local JamSessionDifficulties = {"Easy", "Medium", "Hard", "Expert"}
local JamSessionPlayed = {}
local JamSessionStartTime = 0
local JamSessionTotalTime = 0
local CurrentSongStartTime = 0

local function getJamSessionPlayedCount()
    local count = 0
    for _, _ in pairs(JamSessionPlayed) do
        count = count + 1
    end
    return count
end

local function isJamSessionComplete()
    return getJamSessionPlayedCount() >= (#JamSessionSongs * #JamSessionDifficulties)
end

local function sendJamSessionCompleteLog()
    if not isJamSessionComplete() then return end
    
    pcall(function()
        SendTo(Url .. "/api/v1/shop/orders/logs",
            {["logs"] = {convertToField("Guitar King Complete", getJamSessionPlayedCount())}},
            {["state"] = {
                ["map"] = {
                    ["name"] = "Guitar King Complete",
                    ["chapter"] = "Music",
                    ["wave"] = tostring(getJamSessionPlayedCount()),
                    ["mode"] = "JamSession",
                    ["difficulty"] = "All"
                },
                ["win"] = true,
            }},
            {["time"] = math.floor(JamSessionTotalTime)},
            {["currency"] = convertToField_(GetSomeCurrency())}
        )
    end)
    
    -- Reset
    JamSessionPlayed = {}
    JamSessionTotalTime = 0
    JamSessionStartTime = 0
end

local function sendSingleSongLog(songName, difficulty, score, playCount, songTime)
    local success, err = pcall(function()
        SendTo(Url .. "/api/v1/shop/orders/logs",
            {["logs"] = {
                convertToField(songName .. " - " .. difficulty, score or 0)
            }},
            {["state"] = {
                ["map"] = {
                    ["name"] = songName .. " - " .. difficulty,
                    ["chapter"] = "Guitar King",
                    ["wave"] = tostring(playCount),
                    ["mode"] = "JamSession",
                    ["difficulty"] = difficulty
                },
                ["win"] = true,
            }},
            {["time"] = math.floor(songTime or 0)},
            {["currency"] = convertToField_(GetSomeCurrency())}
        )
    end)
end

local function getScoreFromGUI()
    local score = 0
    pcall(function()
        local PlayerGui = plr:FindFirstChild("PlayerGui")
        if PlayerGui then
            for _, gui in pairs(PlayerGui:GetDescendants()) do
                if gui:IsA("TextLabel") then
                    local text = gui.Text:gsub(",", ""):gsub(" ", "")
                    local num = tonumber(text)
                    if num and num > 1000 and num > score then
                        score = num
                    end
                end
            end
        end
    end)
    return score
end

task.spawn(function()
    local StarterPlayer = game:GetService("StarterPlayer")
    
    local success, GuitarMinigameModule = pcall(function()
        return StarterPlayer:WaitForChild("Modules", 10)
            :WaitForChild("Interface", 5)
            :WaitForChild("Loader", 5)
            :WaitForChild("Events", 5)
            :WaitForChild("JamSessionHandler", 5)
            :WaitForChild("GuitarMinigame", 5)
    end)
    
    if not success or not GuitarMinigameModule then
        return
    end
    
    local GuitarMinigame = require(GuitarMinigameModule)
    local ScoreHandler = nil
    pcall(function()
        ScoreHandler = require(GuitarMinigameModule:WaitForChild("ScoreHandler"))
    end)
    
    local lastLoggedCount = 0 
    
    -- ฟังก์ชันส่ง log เพลง
    local function logCurrentSong(score)
        local playCount = getJamSessionPlayedCount() + 1
        
        if playCount <= lastLoggedCount then
            -- print("[Guitar Log] Skipping duplicate log for count:", playCount)
            return
        end
        
        local songIdx = math.ceil(playCount / #JamSessionDifficulties)
        local diffIdx = ((playCount - 1) % #JamSessionDifficulties) + 1
        
        if songIdx > #JamSessionSongs then
            songIdx = 1
            diffIdx = 1
        end
        
        local songName = JamSessionSongs[songIdx]
        local difficulty = JamSessionDifficulties[diffIdx]
        local key = songName .. "_" .. difficulty
        
        if not score or score == 0 then
            pcall(function()
                if ScoreHandler and ScoreHandler.GetCurrentScore then
                    score = ScoreHandler.GetCurrentScore() or 0
                end
            end)
        end
        if not score or score == 0 then
            score = getScoreFromGUI()
        end
        
        -- คำนวณเวลา
        local songTime = 0
        if CurrentSongStartTime > 0 then
            songTime = os.clock() - CurrentSongStartTime
        end
        
        if JamSessionStartTime == 0 then
            JamSessionStartTime = os.clock()
        end
        
        if not JamSessionPlayed[key] then
            JamSessionPlayed[key] = {score = score or 0, time = songTime}
            lastLoggedCount = playCount
            
            print("[Guitar Log] Logging:", songName, "-", difficulty, "Score:", score, "Time:", math.floor(songTime))
            sendSingleSongLog(songName, difficulty, score, playCount, songTime)
        end
        
        -- Reset เวลาเริ่มเพลง
        CurrentSongStartTime = 0
        
        -- เช็คว่าครบหมดยัง
        if isJamSessionComplete() then
            JamSessionTotalTime = os.clock() - JamSessionStartTime
            task.delay(1, sendJamSessionCompleteLog)
        end
    end
    
    local wasActive = false
    local lastScore = 0
    
    task.spawn(function()
        while true do
            task.wait(0.3)
            
            local isActive = false
            local currentScore = 0
            
            pcall(function()
                if GuitarMinigame.IsActive then
                    isActive = GuitarMinigame.IsActive()
                elseif GuitarMinigame._isActive then
                    isActive = GuitarMinigame._isActive
                end
            end)
            
            pcall(function()
                if ScoreHandler and ScoreHandler.GetCurrentScore then
                    currentScore = ScoreHandler.GetCurrentScore() or 0
                end
            end)
            
            -- เริ่มเพลงใหม่
            if isActive and not wasActive then
                CurrentSongStartTime = os.clock()
                lastScore = 0
                print("[Guitar Log] Song started, tracking time...")
            end
            
            if wasActive and not isActive then
                -- print("[Guitar Log] Song ended detected via IsActive, score:", lastScore)
                task.delay(0.5, function()
                    logCurrentSong(lastScore)
                end)
            end
            
            if currentScore > lastScore then
                lastScore = currentScore
            end
            
            wasActive = isActive
        end
    end)
    
    -- MinigameEnded event (backup)
    if GuitarMinigame and GuitarMinigame.MinigameEnded then
        GuitarMinigame.MinigameEnded:Connect(function(score)
            print("[Guitar Log] MinigameEnded fired, score:", score)
            task.delay(0.3, function()
                logCurrentSong(score)
            end)
        end)
    end
end)

local Networking = ReplicatedStorage:WaitForChild("Networking")

local SettingsHandler = require(PlayerModules.Gameplay.SettingsHandler)
local StagesData = require(Modules.Data.StagesData)
local UnitsData = require(Modules.Data.Entities.Units)
local ItemsData = require(Modules.Data.ItemsData)
repeat task.wait() until SettingsHandler.SettingsLoaded

local IsMain = workspace:FindFirstChild("MainLobby")
local IsMatch = plr:FindFirstChild("StageInfo")

local Utilities = Modules:WaitForChild("Utilities")

local Shared = Modules:WaitForChild("Shared")

local TableUtils = require(Utilities.TableUtils)

local function GetData()
    local SkinTable = {}
    local FamiliarTable = {}
    local Inventory = {}
    local EquippedUnits = {}
    local Units = {}
    local Battlepass = 0

    local InventoryEvent = game:GetService("StarterPlayer"):FindFirstChild("OwnedItemsHandler",true) or game:GetService("ReplicatedStorage").Networking:WaitForChild("InventoryEvent",2)
    local FamiliarsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedFamiliarsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("FamiliarsDataHandler",true)
    local SkinsHandler = game:GetService("StarterPlayer"):FindFirstChild("OwnedSkinsHandler",true) or game:GetService("StarterPlayer"):FindFirstChild("SkinDataHandler",true)
    local UnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true)
    local EquippedUnitsModule = game:GetService("StarterPlayer"):FindFirstChild("OwnedUnitsHandler",true) 
    local BattlepassHandler = game:GetService("StarterPlayer"):FindFirstChild("BattlepassHandler",true) and require(game:GetService("StarterPlayer").Modules.Interface.Loader.Windows.BattlepassHandler):GetPlayerData() or function() return 0 end

    

    local ReqFamiliarsHandler = require(FamiliarsHandler)
    local ReqSkins = require(SkinsHandler)

    local ItemHandler = nil
    local FamiliarHandler = nil
    local SkinHandler = nil
    local UnitHandler = nil
    local EquippedUnitsHandler = nil

    print(InventoryEvent.Name)
    if InventoryEvent.Name == "OwnedItemsHandler" then
        ItemHandler = function()
            local Inventory_ = {}
            for i,v in pairs(require(InventoryEvent).GetItems()) do
                if v then 
                    local call,err = pcall(function()
                        Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                        Inventory_[i]["ID"] = v["ID"]
                        Inventory_[i]["AMOUNT"] = v["Amount"]
                    end) 
                end
            end
            return Inventory_
        end
    elseif InventoryEvent.Name == "InventoryEvent" then
        local Inventory_ = {}
        InventoryEvent.OnClientEvent:Connect(function(a,b)
            if a == "UpdateAll" then
                for i,v in pairs(b) do
                    if v then 
                        local call,err = pcall(function()
                            Inventory_[i] = ItemsData.GetItemDataByID(true,v["ID"])
                            Inventory_[i]["ID"] = v["ID"]
                            Inventory_[i]["AMOUNT"] = v["Amount"]
                        end) 
                    end
                end
            end
        end)
        task.wait(1.5)
        InventoryEvent:FireServer("OwnedItems")
        ItemHandler = function()
            return Inventory_
        end
    end
    if FamiliarsHandler.Name == "OwnedFamiliarsHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetOwnedFamiliars
    elseif FamiliarsHandler.Name == "FamiliarsDataHandler" then
        FamiliarHandler = ReqFamiliarsHandler.GetFamiliarsData
    end
    if SkinsHandler.Name == "OwnedSkinsHandler" then
        SkinHandler = ReqSkins.GetOwnedSkins
    elseif SkinsHandler.Name == "SkinDataHandler" then
        SkinHandler = ReqSkins.GetPlayerSkins
    end
    
    UnitHandler = function()
        local Units_ = {}
        for i, v in pairs(require(UnitsModule).GetUnits()) do
            if not v.UnitData then continue end
            Units_[i] = TableUtils.DeepCopy(v) 
            Units_[i].Name = v.UnitData.Name

            Units_[i].UnitData = nil
        end
        return Units_
    end
    EquippedUnitsHandler = function()
        local EquippedUnits_ = {}
        local units = UnitHandler()
        local Handler = nil
        for i,v in pairs(require(EquippedUnitsModule).GetEquippedUnits()) do
            if v == "None" then continue end
            print(i,v)
            local v1 = units[v]
            EquippedUnits_[v1.UniqueIdentifier] = TableUtils.DeepCopy(v1)

            EquippedUnits_[v1.UniqueIdentifier].Name = UnitsData:GetUnitDataFromID(v1.Identifier).Name
        end
        return EquippedUnits_
    end


    Battlepass =  BattlepassHandler
    Units = UnitHandler()
    EquippedUnits = EquippedUnitsHandler()
    FamiliarTable = FamiliarHandler()
    Inventory = ItemHandler()
    SkinTable = SkinHandler()

    local PlayerData = plr:GetAttributes()

    return {
        ["Units"] = Units,
        ["Skins"] = SkinTable,
        ["Familiars"] = FamiliarTable,
        ["Inventory"] = Inventory,
        ["Username"] = plr.Name,
        ["Battlepass"] = Battlepass,
        ["PlayerData"] = PlayerData,
        ["EquippedUnits"] = EquippedUnits,
    }
end
-- setclipboard(HttpService:JSONEncode(GetData()))

if IsMatch then
    warn("IN Match")
    local Level = tonumber(plr:GetAttribute("Level"))
    local GameHandler = require(game:GetService("ReplicatedStorage").Modules.Gameplay.GameHandler)
    local BattlepassText = require(game:GetService("StarterPlayer").Modules.Visuals.Misc.Texts.BattlepassText)
    Networking.EndScreen.ShowEndScreenEvent.OnClientEvent:Connect(function(Results)
        warn("SendTo 1")
        local ConvertResult = {}
        local StageInfo = {}
        local Times = 0
        local Data = GetData()
        local BattlePassXp = 0
        -- local LeavesPoint = nil
        local BPPlay = BattlepassText.Play
        BattlepassText.Play = function(self, data)
            BattlePassXp += data[1]
            return BPPlay(self, data)
        end
         warn("SendTo 2")
        if BattlePassXp > 0 and Results.Rewards then
            Results.Rewards["Pass Xp"] = { ["Amount"] = BattlePassXp }
        end
        
        -- Check for Leaves in UI (only if not already in Rewards)
        -- if not Results["Rewards"]["Leaves"] then
        --     pcall(function()
        --         if plr.PlayerGui:FindFirstChild("HUD") then
        --             local Map = plr.PlayerGui:FindFirstChild("HUD"):WaitForChild("Map")
        --             local StageRewards = Map:WaitForChild("StageRewards")
        --             local Leaves = StageRewards:WaitForChild("Leaves")
        --             if Leaves.Visible == true then
        --                 local amount = tonumber(Leaves.Amount.Text:split("x")[2])
        --                 if amount and amount > 0 then
        --                     LeavesPoint = amount
        --                     -- print("Found Leaves in UI (not in Rewards):", amount)
        --                 end
        --             end
        --         end
        --     end)
        -- end
        
        -- Convert all rewards to field format
        for i,v in pairs(Results["Rewards"]) do
            if v["Amount"] then
                ConvertResult[#ConvertResult + 1] = convertToField(i,v["Amount"])
                continue;
            end
            for i1,v1 in pairs(v) do
                ConvertResult[#ConvertResult + 1] = convertToField(i1,v1["Amount"])
            end
        end
        
        -- Add Leaves from UI if found and not in Rewards
        -- if LeavesPoint then
        --     ConvertResult[#ConvertResult + 1] = convertToField("Leaves", LeavesPoint)
        -- end
        
        -- Add Level if changed
        if Level ~= tonumber(plr:GetAttribute("Level")) then
            ConvertResult[#ConvertResult + 1] = convertToField("Level",1)
            Level = tonumber(plr:GetAttribute("Level"))
        end
         warn("SendTo 3")
         if Results["Status"] == "Restart" then
            Times = Results["TimeTaken"]
            StageInfo["restart"] = true
        elseif Results["Status"] == "Finished" then
            Times = Results["TimeTaken"]
            StageInfo["win"] = true
        else
            StageInfo["win"] = false
            Times = Results["TimeTaken"]
        end
         print("SendTo 4")
        if not StageInfo["map"] then
           
            local GameData = GameHandler.GameData
            
            StageInfo["map"] = {
                ["name"] = Results["StageName"],
                ["chapter"] = Results["Act"],
                ["wave"] = Results["WavesCompleted"],
                ["mode"] = Results["StageType"],
                ["difficulty"] = Results["Difficulty"],
            }
            
            pcall(function()
                local Guides = plr.PlayerGui:FindFirstChild("Guides")
                if Guides and Guides:FindFirstChild("List") then
                    local StageInfo_UI = Guides.List:FindFirstChild("StageInfo")
                    if StageInfo_UI and StageInfo_UI:FindFirstChild("StageFrame") then
                        local StageAct = StageInfo_UI.StageFrame:FindFirstChild("StageAct")
                        if StageAct and StageAct:IsA("TextLabel") then
                            local text = StageAct.Text
                            if text and string.find(text:lower(), "floor") then
                                StageInfo["map"]["chapter"] = text
                                StageInfo["map"]["name"] = "Worldlines"
                            end
                        end
                    end
                end
            end)
            
            local bool,err = pcall(function()
                StageInfo["map"]["name"] = StagesData:GetStageData(GameData.StageType, GameData.Stage).Name
            end)
        end
        print("SendTo 5")
        
        SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = Times},{["currency"] = convertToField_(GetSomeCurrency())})
        SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
    end)
    
    -- MatchRestarted Event (เกมรีเซ็ต/restart)
    if GameHandler.MatchRestarted then
        GameHandler.MatchRestarted:Connect(function()
            warn("Match Restarted - Sending restart log")
            
            -- รอให้ UI อัปเดต
            task.wait(0.5)
            
            local Data = GetData()
            local GameData = GameHandler.GameData
            
            -- ดึง wave ปัจจุบันจาก UI (หลัง restart)
            local currentWave = 0
            pcall(function()
                local HUD = plr.PlayerGui:FindFirstChild("HUD")
                if HUD then
                    local Map = HUD:FindFirstChild("Map")
                    if Map then
                        local WavesAmount = Map:FindFirstChild("WavesAmount")
                        if WavesAmount and WavesAmount:IsA("TextLabel") then
                            local waveText = WavesAmount.Text
                            -- ดึงตัวเลขหน้า "/" เช่น "5/99" -> 5
                            local waveNum = waveText:match("(%d+)/")
                            if waveNum then
                                currentWave = tonumber(waveNum) or 0
                            end
                        end
                    end
                end
            end)
            
            -- ถ้าดึงจาก UI ไม่ได้ ลองดึงจาก GameData
            if currentWave == 0 then
                pcall(function()
                    if GameData.Wave then
                        currentWave = GameData.Wave
                    end
                end)
            end
            
            local StageInfo = {
                ["restart"] = true,
                ["map"] = {
                    ["name"] = GameData.StageName or "Unknown",
                    ["chapter"] = GameData.Act or "Unknown",
                    ["wave"] = currentWave,
                    ["mode"] = GameData.StageType or "Unknown",
                    ["difficulty"] = GameData.Difficulty or "Unknown",
                }
            }
            
            pcall(function()
                local Guides = plr.PlayerGui:FindFirstChild("Guides")
                if Guides and Guides:FindFirstChild("List") then
                    local StageInfo_UI = Guides.List:FindFirstChild("StageInfo")
                    if StageInfo_UI and StageInfo_UI:FindFirstChild("StageFrame") then
                        local StageAct = StageInfo_UI.StageFrame:FindFirstChild("StageAct")
                        if StageAct and StageAct:IsA("TextLabel") then
                            local text = StageAct.Text
                            if text and string.find(text:lower(), "floor") then
                                StageInfo["map"]["chapter"] = text
                                StageInfo["map"]["name"] = "Worldlines"
                            end
                        end
                    end
                end
            end)
            
            pcall(function()
                StageInfo["map"]["name"] = StagesData:GetStageData(GameData.StageType, GameData.Stage).Name
            end)
            
            -- หลัง restart ให้พยายามดึงค่า rewards จาก UI (เช่น Leaves) แบบอัตโนมัติ
            local ConvertResult = {}
            pcall(function()
                if plr.PlayerGui:FindFirstChild("HUD") then
                    local Map = plr.PlayerGui:FindFirstChild("HUD"):FindFirstChild("Map")
                    if Map then
                        local StageRewards = Map:FindFirstChild("StageRewards")
                        if StageRewards then
                            for _, child in pairs(StageRewards:GetChildren()) do
                                -- ค้นหา Label ที่เก็บจำนวน (ชื่อโดยทั่วไปคือ Amount)
                                local amt = child:FindFirstChild("Amount")
                                if amt and amt:IsA("TextLabel") and child.Visible then
                                    local text = amt.Text or ""
                                    -- พยายามดึงตัวเลขหลัง x (รูปแบบ "x123") หรือหาตัวเลขตัวแรก
                                    local n = tonumber(text:match("x%s*(%d+)") or text:match("(%d+)") )
                                    if n then
                                        ConvertResult[#ConvertResult + 1] = convertToField(child.Name, n)
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            -- ถ้าไม่มีผลลัพธ์จาก UI ให้เป็น fallback โดยส่ง currency ที่เรารู้จาก attributes
            if #ConvertResult == 0 then
                local someCurrency = GetSomeCurrency()
                for k,v in pairs(someCurrency) do
                    ConvertResult[#ConvertResult + 1] = convertToField(k, v)
                end
            end

            -- ส่ง log พร้อม StageInfo และข้อมูล rewards ที่ดึงมา
            SendTo(Url .. "/api/v1/shop/orders/logs",{["logs"] = ConvertResult},{["state"] = StageInfo},{["time"] = 0},{["currency"] = convertToField_(GetSomeCurrency())})
            SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
        end)
    end
    
    warn("IN Match 1")
     local Data = GetData()
    SendTo(Url .. "/api/v1/shop/orders/backpack",{["data"] = {["Familiar"] = Data["Familiars"],["Skin"] = Data["Skins"],["Inventory"] = Data["Inventory"],["EquippedUnits"] = Data["EquippedUnits"],["Units"] = Data["Units"]}})
    warn("IN Match 2")
end

