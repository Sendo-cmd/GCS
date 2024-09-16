Games = {
    [4509896324] = { --Anime-Last-Stand
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaDoAll.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueRoll.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueSummon.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALL.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Reroll.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Reroll.lua",
    },
    [5578556129] = { --Anime-Vanguards
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM2.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Chain.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ChainE.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Naruto.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_NarutoE.lua",
        [7] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Obita.lua",
        [8] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_ObitaE.lua",
        [9] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sasuke.lua",
        [10] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SasukeE.lua",
        [11] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sonj.lua",
        [12] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_SonjE.lua",
        [13] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Sonj2.lua",
        [14] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_Vegeta.lua",
        [15] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_VegetaE.lua",
        [16] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_LD.lua",
        [17] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_DD_ACT1.lua",
        [18] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_DD_ACT12.lua",
        [19] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_DD_ACT2.lua",
        [20] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_SV_ACT1.lua",
        [21] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_SV_ACT2.lua",
        [22] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_SV_ACT3.lua",

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
        12,
    },
    ["ASKINGZ12_43"] = {
        1,
    },
    ["Nelida5865"] = {
        1,
        2,
    },
    ["zxasd2519k"] = {
        8,
    },
    ["xdyrdgyrdfg"] = {
        12,
    },
    ["Thai_WilYuLaw"] = {
        12,
    },
    ["MaxiroKiriteo"] = {
        11,
    },
    ["Somrum11"] = {
        1,
    },
    ["Dxw2pz"] = {
        4,
        5,
        6,
    },
    ["mbhl67679"] = {
        1,
        2,
    },
    ["maser080"] = {
        1,
    },
    ["OcP9XrO"] = {
        1,
        2,
    },
    ["Puggtopro"] = {
        3,
    },
    ["Realboomisgod"] = {
        1,
    },
    ["Demonx_Hunt"] = {
        14,
    },
    ["Etaa_xm"] = {
        1,
    },
    ["teeks2354k"] = {
        11,
    },
    ["OTeMoKungO"] = {
        11,
    },
    ["FPS1000zH25"] = {
        16,
    },
    ["EAzxc013"] = {
        11,
    },
    ["Gailuck_0062"] = {
        1,
    },
    ["Nx_BlackLazy"] = {
        6,
    },
    ["fonaujang191"] = {
        8,
    },
    ["goddam_002"] = {
        1,
    },
    ["offj_0383"] = {
        12,
    },
    ["PunnSoCool"] = {
        1,
    },
    ["wexd45"] = {
        11,
    },
    ["Mongkuyraikrub"] = {
        1,
        2,
    },
    ["fin_0014"] = {
        12,
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
