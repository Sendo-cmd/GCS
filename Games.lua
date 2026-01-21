Games = {
    [5578556129] = { --Anime-Vanguards
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/logs_av.lua",
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_System.lua",
        ["System2"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_System2.lua",
        ["Base"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_AutoPlay.lua",
    },
    [4509896324] = { --Anime-Last-Stand
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Log.lua",
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Base.lua",
    },
    [6884266247] = { --Anime Rangers X
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ARX_Log.lua",
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ARX_System.lua",
    },
    [5750914919] = { --Fisch
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Fisch_System.lua",
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Fisch_Log.lua",
    },
    [7750955984] = { --Hz
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/HZ_System.lua",
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/HZ_Log.lua",
    },
    [7671049560] = { --TF
        ["System"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/TF_System.lua",
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/TF_Log.lua",
    },
}
Accounts = {}

-- Define request function for HTTP calls (executor compatibility)
local request = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
if not request then
    request = function() return {Success = false, Body = "{}"} end
end

repeat task.wait(1) until game:IsLoaded(2)

local plr = game.Players.LocalPlayer
local Scripts = Games[game.gameId]
local Loaded = false
local Timer = 0
local ScriptLists = nil

local BaseScripts = {
    ["5578556129"] = { "Log", "Base", "System", "System2" },
    -- ["6057699512"] = { "Marco", "Tsp" },
    ["5750914919"] = { "Log", "System" },
    ["6884266247"] = { "Log", "System" },
    ["4509896324"] = { "System" },
    ["7750955984"] = { "Log", "System" },
    ["7671049560"] = { "Log", "System" },
}

for i, v in pairs(Accounts) do
    if i == plr.Name or i:lower() == plr.Name:lower() then
        ScriptLists = v
        break
    end
end

if not ScriptLists then
    ScriptLists = BaseScripts[tostring(game.gameId)] or {}
end

local isGuitarKingLobby = false
if game.PlaceId == 16146832113 then
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local response = request({
            ["Url"] = "https://api.championshop.date/api/v1/shop/orders/" .. plr.Name,
            ["Method"] = "GET",
            ["Headers"] = {
                ["content-type"] = "application/json",
                ["x-api-key"] = "953a582c-fca0-47bb-8a4c-a9d28d0871d4"
            },
        })
        if response and response["Body"] then
            local data = HttpService:JSONDecode(response["Body"])["data"]
            if data and data[1] then
                local productId = data[1]["product_id"]
                if productId == "d9faa15c-d5c6-4b52-a918-8e1ad1940841" then
                    isGuitarKingLobby = true
                    print("[Games] Guitar King order detected at Lobby - skipping some scripts")
                end
            end
        end
    end)
end

for i, v in pairs(ScriptLists) do
    -- ถ้าเป็น Guitar King ที่ Lobby ให้ข้าม Base (script ที่ลบปุ่ม)
    if isGuitarKingLobby and v == "Base" then
        print("[Games] Skipping Base script for Guitar King")
        continue
    end
    
    local ScriptUrl = Scripts[v]

    print(ScriptUrl)
    local ok, Functions = pcall(loadstring, game:HttpGet(ScriptUrl))

    if ok then
        Timer, Loaded = tick(), false
        task.spawn(function()
            Functions()
            Loaded = true
        end)

        repeat task.wait() until Loaded or (tick() - Timer) > 2
    end
end

