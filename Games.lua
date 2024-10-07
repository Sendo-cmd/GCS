Games = {
    [5578556129] = { --Anime-Vanguards
        ["BaseB"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Boss_Base.lua",
        ["BIgrisSon"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Boss_Base_IgrisSon.lua",
        ["BaseGem"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM.lua",
        ["Gem2"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM2.lua",
        ["Gem3"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM3.lua",
        ["BaseGemInf"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEMINF.lua",
        ["BaseIG"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Base.lua",
        ["BaseR"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Base.lua",
        ["RIgris"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Igris.lua",
        ["RRengoku"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Renguko.lua",
        ["RAkazo"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Akazo.lua",
        ["RMon"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Monarch.lua",
        ["BaseRGem"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_REROLL_GEM.lua",
        ["BaseRIG"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_REROLL_IGRIS.lua",
        ["LC"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Chain.lua",
        ["LCE"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ChainE.lua",
        ["LCEV"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ChainEV.lua",
        ["LS"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sonj.lua",
        ["LSE"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjE.lua",
        ["LSEV"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjEV.lua",
        ["LSEV2"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjEV2.lua",
        ["LSEM"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjEMon.lua",
        ["ESSE"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Essence.lua",
        ["Marco"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Marco.lua",
        ["Log"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Log.lua",
        ["AutoBuyR"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Shop_R.lua",
        ["AutoBuyBE"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Shop_BE.lua",
    },
    [4509896324] = { --Anime-Last-Stand
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Reroll.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Reroll.lua",
    },
    [6149138290] = { --Anime-Card-Battle
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Banana.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ACB_Card.lua",
    }
}
Accounts = {
    ["Champandbank147"] = {
        "Log",
        "Marco",
        "ESSE",
    },
    ["RiceBing"] = {
        "Log",
        "Marco",
        "AutoBuyBE",
        "BIgrisSon",
    },
    ["Nachosmayo"] = {
        "Log",
        "Marco",
        "AutoBuyR",
        "BaseR",
    },
    ["maser080"] = {
        "Log",
        "Marco",
        "AutoBuyR",
        "BaseR",
    },
    ["teerathornmoon"] = {
        "Log",
        "Marco",
        "AutoBuyR",
        "BaseR",
    },
    ["narutoez441"] = {
        "Log",
        "Marco",
        "AutoBuyBE",
        "BIgrisSon",
    },

}

repeat task.wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local Scripts = Games[game.gameId]
local Loaded = false
local Timer = 0
local ScriptLists = nil
for i,v in pairs(Accounts) do
    if i == plr.Name or i:lower() == plr.Name:lower() then
        ScriptLists = v
    end
end
for i,v in pairs(ScriptLists) do
    local ScriptUrl = Scripts[v];

    local ok, Functions = pcall(loadstring, game:HttpGet(ScriptUrl))

    if ok then
        Timer, Loaded = tick(), false
        task.spawn(function()
            Functions()
            Loaded = true
        end)

        repeat task.wait() until Loaded or (Timer - tick()) > 10
    end
end