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
        ['Enabled'] = true,
        ['Units'] = {
            'Gojo (Unmasked)',
            'Garou',
            'Tatsumaki',
            'RengokuEvo',
            'Guts',
        },
    },
    RollTechniques = {
        ['Enabled'] = true,
        ['Unit'] = {
            'Gojo (Unmasked)',
            'Garou',
            'Tatsumaki',
            'RengokuEvo',
            'Guts',
        },
        ['Index'] = {
            'Glitched',
            'Overlord',
            'Avatar',
        },
    },
    Webhook = {
        ['Enabled'] = true,
        ['Url'] = 'https://discord.com/api/webhooks/1279853480009531403/pJdRwtMYdY3N2vwuzwJzuJ7tDusxT3c5Wzp4lhC9gc67bsvvw4lw3gXoTtNGD7lSisWp',
    },
};
getgenv().key = '4487198d-1f05-43ac-9196-c99fe70e687d'
loadstring(game:HttpGet('https://raw.githubusercontent.com/Xenon-Trash/Loader/main/Loader.lua'))()
