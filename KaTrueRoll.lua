getgenv().Configuration = {
    Enabled = true,
    Delay = 10,
    RedeemCode = {
        ['Enabled'] = true,
        ['Code'] = {
            'SLIME!!',
            'SecretCodeFR',
            'Event!!!',
            'TensuraSlime!',
            'UPDTIME',
            'BPReset!',
        },
    },
    ClaimedQuests = true,
    ClaimedBattlepass = true,
    PlacementDistancePercentage = 60, 
    Summon = {
        ['Enabled'] = false,
        ['Units'] = {
            'RengokuEvo',
        },
    },
    RollTechniques = {
        ['Enabled'] = true,
        ['Unit'] = {
            'Rimuru (Human)',
        },
        ['Index'] = {
            'Glitched',
            'Avatar',
            'Overlord',
        },
    },
    Webhook = {
        ['Enabled'] = false,
        ['Url'] = '',
    },
};
getgenv().key = '4487198d-1f05-43ac-9196-c99fe70e687d'
loadstring(game:HttpGet('https://raw.githubusercontent.com/Xenon-Trash/Loader/main/Loader.lua'))()
