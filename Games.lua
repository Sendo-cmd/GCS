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
        [13] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS_LD.lua",
        [14] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_.lua",
        [15] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_EVO_.lua",
        

    },
    [6149138290] = { --Anime-Card-Battle
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Banana.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ACB_Card.lua",
    }
}

Accounts = {
    ["FireBlackDevilZ"] = {
        6,
    },
    ["MeVeryNoobza"] = {
        4,
        5,
        6,
    },
    ["Nelida5865"] = {
        1,
        2,
    },
    ["zxasd2519k"] = {
        14,
    },
    ["xdyrdgyrdfg"] = {
        1,
    },
    ["N2w22"] = {
        1,
    },
    ["xOFubukiOx"] = {
        1,
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
    ["noon2222220000000000"] = {
        1,
    },
    ["OcP9XrO"] = {
        1,
        2,
    },
    ["Puggtopro"] = {
        15,
    },
    ["MakarlokXD"] = {
        1,
    },
    ["Demonx_Hunt"] = {
        1,
    },
    ["Etaa_xm"] = {
        6,
    },
    ["iPram0"] = {
        1,
    },
    ["dmhcheer5774"] = {
        9,
    },
    ["FestaKMT"] = {
        10,
    },
    ["FPS1000zH25"] = {
        15,
    },
    ["EAzxc013"] = {
        13,
    },
    ["Gailuck_0062"] = {
        1,
    },
    ["essono1"] = {
        8,
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
