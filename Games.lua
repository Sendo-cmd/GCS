Games = {
    [4509896324] = { --Anime-Last-Stand
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaDoAll.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueRoll.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueSummon.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALL.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Reroll.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Reroll.lua",
        [7] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_X.lua",
    },
    [5578556129] = { --Anime-Vanguards
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM2.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM3.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Chain.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ChainE.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Naruto.lua",
        [7] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_NarutoE.lua",
        [8] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Obita.lua",
        [9] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ObitaE.lua",
        [10] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sasuke.lua",
        [11] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SasukeE.lua",
        [12] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sonj.lua",
        [13] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjE.lua",
        [14] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Chain2.lua",
        [15] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Vegeta.lua",
        [16] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_VegetaE.lua",
        [17] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_LD.lua",
        [18] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_REROLL_GEM.lua",
        [19] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_REROLL_IGRIS.lua",
        [20] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Monarch.lua",
        [21] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Solar.lua",
        [22] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Rengoku_Ten.lua",
        [99] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Log.lua",

    },
    [6149138290] = { --Anime-Card-Battle
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Banana.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ACB_Card.lua",
    }
}

Accounts = {
    ["FireBlackDevilZ"] = {
        1,
        2,
        4,
    },
    ["Champandbank147"] = {
        26,
        99,
    },
    ["Nelida5865"] = {
        1,
        2,
    },
    ["xdyrdgyrdfg"] = {
        22,
        99,
    },
    ["maser080"] = {
        21,
        99,
    },
    ["Puggtopro"] = {
        1,
        99,
    },
    ["Etaa_xm"] = {
        1,
        99,
    },
    ["OTeMoKungO"] = {
        11,
        99,
    },
    ["Nx_BlackLazy"] = {
        6,
        99,
    },
    ["aamlop1"] = {
        19,
        99,
    },
    ["Mynamefirstzz"] = {
        14,
        99,
    },
    ["B1za12345"] = {
        13,
        99,
    },
    ["UMH_x7"] = {
        1,
        99,
    },
    ["djgodzz55"] = {
        13,
        99,
    },
    ["Krv_kai43"] = {
        2,
        99,
    },
    ["FalconWave21"] = {
        1,
        99,
    },
    ["comme009"] = {
        1,
        99,
    },
    ["SoulMossBats"] = {
        14,
        99,
    },
    ["1accox"] = {
        1,
        99,
    },
    ["RiceBing"] = {
        3,
        99,
    },

}

repeat task.wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local Scripts = Games[game.gameId]
for i,v in pairs(Accounts[plr.Name]) do
    local ScriptUrl = Scripts[v];

    local Functions = loadstring(game:HttpGet(ScriptUrl))

    task.spawn(Functions)
end
