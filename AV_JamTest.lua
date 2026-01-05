-- AV_JamTest.lua - ทดสอบระบบ Auto Jam / Guitar King

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ===== SETTINGS =====
local Settings = {
    ["Target Score"] = 100000,  -- คะแนนเป้าหมาย (100k)
    ["Auto Hit"] = true,        -- เปิด auto hit
    ["Debug"] = true,           -- แสดง debug message
}

-- ===== MODULES =====
local GuitarMinigameModule = StarterPlayer:WaitForChild("Modules")
    :WaitForChild("Interface")
    :WaitForChild("Loader")
    :WaitForChild("Events")
    :WaitForChild("JamSessionHandler")
    :WaitForChild("GuitarMinigame")

local JamSessionHandler = require(StarterPlayer.Modules.Interface.Loader.Events.JamSessionHandler)
local GuitarMinigame = require(GuitarMinigameModule)
local ScoreHandler = require(GuitarMinigameModule:WaitForChild("ScoreHandler"))

-- Remote สำหรับส่ง score ไป server
local JamSessionEvents = ReplicatedStorage:WaitForChild("Networking"):WaitForChild("Events"):WaitForChild("JamSession")
local UpdateScoreRemote = JamSessionEvents:WaitForChild("UpdateScore")

-- ===== SONGS =====
local GK_SONGS = {"Skele King's Theme", "Vanguards!", "Selfish Intentions"}
local GK_DIFFICULTIES = {"Easy", "Medium", "Hard", "Expert"}
local gkSongIndex = 1
local gkDiffIndex = 1

-- ===== TRACKING =====
local hasEndedCurrentSong = false
local hitCount = 0
local totalSongsPlayed = 0

-- ===== HELPER FUNCTIONS =====
local function Log(...)
    if Settings["Debug"] then
        print("[Jam Test]", ...)
    end
end

local function GetCurrentScore()
    local score = 0
    pcall(function()
        if ScoreHandler.GetCurrentScore then
            score = ScoreHandler.GetCurrentScore() or 0
        end
    end)
    return score
end

local function IsMinigameActive()
    local isActive = false
    pcall(function()
        isActive = GuitarMinigame._isActive or GuitarMinigame.Active or false
        if type(GuitarMinigame.IsActive) == "function" then
            isActive = GuitarMinigame.IsActive()
        end
    end)
    return isActive
end

-- ===== CLOSE GUITAR UI =====
local function CloseGuitarUI()
    pcall(function()
        if GuitarMinigame.Close then
            GuitarMinigame.Close()
        end
        if JamSessionHandler.CloseGui then
            JamSessionHandler.CloseGui()
        end
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                if gui.Name == "GuitarMinigame" or string.find(gui.Name:lower(), "guitar") or string.find(gui.Name:lower(), "jam") then
                    gui:Destroy()
                    Log("Destroyed GUI:", gui.Name)
                end
            end
        end
    end)
end

-- ===== NEXT SONG =====
local function GoToNextSong()
    gkDiffIndex = gkDiffIndex + 1
    if gkDiffIndex > #GK_DIFFICULTIES then
        gkDiffIndex = 1
        gkSongIndex = gkSongIndex + 1
        if gkSongIndex > #GK_SONGS then
            gkSongIndex = 1
            Log("=== All 12 songs completed! ===")
            Log("Total songs played:", totalSongsPlayed)
            return false
        end
    end
    return true
end

-- ===== PLAY SONG =====
local function PlayNextSong()
    hasEndedCurrentSong = false
    hitCount = 0
    totalSongsPlayed = totalSongsPlayed + 1
    
    local song = GK_SONGS[gkSongIndex]
    local diff = GK_DIFFICULTIES[gkDiffIndex]
    
    Log("=================================")
    Log("Playing Song #" .. totalSongsPlayed)
    Log("Song:", song)
    Log("Difficulty:", diff)
    Log("=================================")
    
    local success, err = pcall(function()
        JamSessionHandler.StartMinigame(song, diff)
    end)
    
    if not success then
        Log("ERROR starting minigame:", err)
    end
end

-- ===== FORCE END =====
local function TryForceEnd()
    if hasEndedCurrentSong then return end
    
    local score = GetCurrentScore()
    hitCount = hitCount + 1
    
    if hitCount % 100 == 0 then
        Log("Hits:", hitCount, "| Score:", score)
    end
    
    if score >= Settings["Target Score"] then
        hasEndedCurrentSong = true
        
        local song = GK_SONGS[gkSongIndex]
        local diff = GK_DIFFICULTIES[gkDiffIndex]
        
        Log("✓ SCORE", score, ">= TARGET!")
        Log("Sending score to server:", song, diff, score)
        
        -- ส่ง score ไป server โดยตรง ก่อนปิด minigame!
        pcall(function()
            UpdateScoreRemote:FireServer(song, diff, score)
            Log("✓ Score sent to server!")
        end)
        
        -- รอให้ส่งเสร็จก่อน
        task.delay(1, function()
            Log("Cleaning up...")
            
            -- Cleanup minigame
            pcall(function()
                if GuitarMinigame.Cleanup then
                    GuitarMinigame.Cleanup(false) -- false = ไม่ fire MinigameEnded อีก
                end
            end)
            
            task.delay(0.5, function()
                pcall(function()
                    if GuitarMinigame.Close then
                        GuitarMinigame.Close()
                    end
                end)
                CloseGuitarUI()
                
                task.delay(1.5, function()
                    if GoToNextSong() then
                        PlayNextSong()
                    else
                        Log("=== FINISHED ALL SONGS ===")
                    end
                end)
            end)
        end)
    end
end

-- ===== HOOK SCORE HANDLER =====
local originalHitNote = ScoreHandler.HitNote
local originalMissNote = ScoreHandler.MissNote

if originalHitNote then
    Log("✓ Hooked HitNote")
    ScoreHandler.HitNote = function(isPerfect, ...)
        local result = originalHitNote(true, ...)
        TryForceEnd()
        return result
    end
else
    Log("✗ HitNote not found!")
end

if originalMissNote then
    Log("✓ Hooked MissNote (convert to hit)")
    ScoreHandler.MissNote = function(...)
        if originalHitNote then
            local result = originalHitNote(true)
            TryForceEnd()
            return result
        end
    end
else
    Log("✗ MissNote not found!")
end

-- ===== HOOK PULL NOTE =====
local originalPullNote = GuitarMinigame.PullNote
if originalPullNote then
    Log("✓ Hooked PullNote")
    GuitarMinigame.PullNote = function(...)
        local note = originalPullNote(...)
        if note and originalHitNote then
            task.delay(0.05, function()
                pcall(function()
                    originalHitNote(true)
                    TryForceEnd()
                end)
            end)
        end
        return note
    end
else
    Log("✗ PullNote not found!")
end

-- ===== FAST AUTO-HIT LOOP =====
task.spawn(function()
    Log("✓ Started Auto-Hit Loop")
    while Settings["Auto Hit"] do
        task.wait(0.02) -- 20ms
        pcall(function()
            if IsMinigameActive() and originalHitNote then
                for i = 1, 3 do
                    originalHitNote(true)
                end
                TryForceEnd()
            end
        end)
    end
end)

-- ===== MINIGAME ENDED EVENT =====
if GuitarMinigame.MinigameEnded then
    Log("✓ Connected MinigameEnded")
    GuitarMinigame.MinigameEnded:Connect(function(score)
        Log("Song ended normally! Score:", score or 0)
        if hasEndedCurrentSong then return end
        
        hasEndedCurrentSong = true
        task.delay(1, function()
            if GoToNextSong() then
                PlayNextSong()
            else
                Log("=== FINISHED ALL SONGS ===")
            end
        end)
    end)
else
    Log("✗ MinigameEnded event not found!")
end

-- ===== DIAGNOSTIC FUNCTIONS =====
local function TestModules()
    print("\n========== MODULE TEST ==========")
    print("JamSessionHandler:", JamSessionHandler and "✓ Loaded" or "✗ Not found")
    print("GuitarMinigame:", GuitarMinigame and "✓ Loaded" or "✗ Not found")
    print("ScoreHandler:", ScoreHandler and "✓ Loaded" or "✗ Not found")
    
    print("\n--- JamSessionHandler Functions ---")
    if JamSessionHandler then
        for k, v in pairs(JamSessionHandler) do
            print("  ", k, ":", type(v))
        end
    end
    
    print("\n--- GuitarMinigame Functions ---")
    if GuitarMinigame then
        for k, v in pairs(GuitarMinigame) do
            print("  ", k, ":", type(v))
        end
    end
    
    print("\n--- ScoreHandler Functions ---")
    if ScoreHandler then
        for k, v in pairs(ScoreHandler) do
            print("  ", k, ":", type(v))
        end
    end
    print("==================================\n")
end

-- ค้นหา Remote Events ที่เกี่ยวกับ Jam/Guitar
local function FindJamRemotes()
    print("\n========== FINDING JAM REMOTES ==========")
    
    local Networking = ReplicatedStorage:FindFirstChild("Networking")
    if Networking then
        print("--- Networking Children ---")
        for _, child in pairs(Networking:GetChildren()) do
            local name = child.Name:lower()
            if string.find(name, "jam") or string.find(name, "guitar") or string.find(name, "music") or string.find(name, "score") or string.find(name, "minigame") then
                print("  ✓", child.Name, ":", child.ClassName)
            end
        end
    end
    
    -- หาใน ReplicatedStorage ทั้งหมด
    print("\n--- All RemoteEvents/Functions with keywords ---")
    for _, desc in pairs(ReplicatedStorage:GetDescendants()) do
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
            local name = desc.Name:lower()
            if string.find(name, "jam") or string.find(name, "guitar") or string.find(name, "score") or string.find(name, "music") or string.find(name, "minigame") or string.find(name, "event") then
                print("  ", desc.Name, ":", desc.ClassName, "| Path:", desc:GetFullName())
            end
        end
    end
    print("==========================================\n")
end

local function TestStatus()
    print("\n========== STATUS ==========")
    print("Is Minigame Active:", IsMinigameActive())
    print("Current Score:", GetCurrentScore())
    print("Hit Count:", hitCount)
    print("Songs Played:", totalSongsPlayed)
    print("Current Song:", GK_SONGS[gkSongIndex])
    print("Current Difficulty:", GK_DIFFICULTIES[gkDiffIndex])
    print("Has Ended Current:", hasEndedCurrentSong)
    print("=============================\n")
end

-- ===== MENU =====
print("\n")
print("╔════════════════════════════════════╗")
print("║    AV_JamTest - Guitar King Test   ║")
print("╠════════════════════════════════════╣")
print("║ TestModules()   - ดู modules       ║")
print("║ TestStatus()    - ดู status        ║")
print("║ FindJamRemotes()- หา remotes       ║")
print("║ PlayNextSong()  - เล่นเพลงถัดไป     ║")
print("║ CloseGuitarUI() - ปิด UI           ║")
print("╠════════════════════════════════════╣")
print("║ Settings[\"Auto Hit\"] = true/false  ║")
print("║ Settings[\"Target Score\"] = 100000  ║")
print("╚════════════════════════════════════╝")
print("\n")

-- Run diagnostic
TestModules()
FindJamRemotes()

-- Start first song
print("=== Starting in 3 seconds... ===")
task.wait(3)
PlayNextSong()
