Games = {
    [12886143095] = {
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaDoAll.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueRoll.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/KaTrueSummon.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALL.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS_Reroll.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Reroll.lua",
    },
    [16146832113] = {
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM2.lua",
        [3] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IGRIS.lua",
        [4] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_NARUTO.lua",
        [5] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_Obita.lua",
        [6] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_CHAIN.lua",
    },
    [18138547215] = {
        [1] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/Banana.lua",
        [2] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ACB_Card.lua",
    }
}

Accounts = {
    ["FireBlackDevilZ"] = {
        5,
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
        1,
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
    ["puggtopro"] = {
        8,
    },
    ["MakarlokXD"] = {
        1,
    },
    ["Demonx_Hunt"] = {
        2,
    },
    ["Etaa_xm"] = {
        3,
    },
    ["iPram0"] = {
        9,
    },
    ["dmhcheer5774"] = {
        9,
    },

}

repeat task.wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local Scripts = Games[game.gameId]
for i,v in pairs(Accounts[plr.Name]) do
    print(i, v)
    local ScriptUrl = Scripts[v];
    print(ScriptUrl)

    local Functions = loadstring(game:HttpGet(ScriptUrl))

    task.spawn(Functions)
end
