repeat task.wait() until game:IsLoaded()

getgenv().Config = {
    Accounts = {
        { ID = 1189955017, script = 4 },
        { ID = 1189955017, script = 5 },
        { ID = 73027822, script = 1 },
        { ID = 378220996, script = 4 },
        { ID = 5527417984, script = 4 },
        { ID = 3949119393, script = 4 },
        { ID = 3949119393, script = 6 },
        { ID = 1504427791, script = 4 },
        { ID = 2504537777, script = 4 },
        { ID = 2504537777, script = 7 },
        { ID = 5176905367, script = 4 }
    },
    Scripts = { 
        -- Please make it a raw link 
        ["Script 0"] = "https://raw.githubusercontent.com/Sendo-cmd/test/main/Reroll.lua",
        ["Script 1"] = "https://raw.githubusercontent.com/Sendo-cmd/test/main/KaDoAll.lua",
        ["Script 2"] = "https://raw.githubusercontent.com/Sendo-cmd/test/main/KaTrueRoll.lua",
        ["Script 3"] = "https://raw.githubusercontent.com/Sendo-cmd/test/main/KaTrueSummon.lua",
        ["Script 4"] = "https://raw.githubusercontent.com/Sendo-cmd/test/main/ALL.lua",
        ["Script 5"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ALS_Reroll.lua",
        ["Script 6"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ALS_Reroll2.lua",
        ["Script 7"] = "https://raw.githubusercontent.com/Sendo-cmd/aaa/main/ALS_Reroll3.lua",
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/test/main/MultiUserExecute.lua"))()
