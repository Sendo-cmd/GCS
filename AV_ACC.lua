getgenv().Config = {
    Accounts = {
        { ID = 5176905367, script = 2 },
        { ID = 73027822, script = 1 },
        { ID = 4291006444, script = 3 },
        { ID = 0, script = 4 },
        { ID = 0, script = 4 },
        { ID = 0, script = 4 },
        { ID = 0, script = 4 }
    },
    Scripts = { 
        -- Please make it a raw link 
        ["Script 1"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM.lua",
        ["Script 2"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_GEM2.lua",
        ["Script 3"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/AV_IRGOS.lua",
        ["Script 4"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/",
        ["Script 5"] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/",
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/test/main/MultiUserExecute.lua"))()
