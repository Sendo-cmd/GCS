repeat task.wait() until game:IsLoaded()

getgenv().Config = {
    Accounts = {
        { ID = 1194518892, script = 1 },
        { ID = 1591965908, script = 2 },
        { ID = 5473666340, script = 3 },
        { ID = 868913579, script = 4 },
        { ID = 7155984741, script = 5 },
        { ID = 1, script = 6 },
        { ID = 2, script = 7 }

    },
    Scripts = { 
        -- Please make it a raw link 
        ["Script 1"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card.lua",
        ["Script 2"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card2.lua",
        ["Script 3"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card3.lua",
        ["Script 4"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card4.lua",
        ["Script 5"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card5.lua",
        ["Script 6"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card6.lua",
        ["Script 7"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ACB_Card7.lua",
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/test/main/MultiUserExecute.lua"))()
