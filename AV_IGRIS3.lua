getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283148946067161219/legendsIGRIS.json?ex=66e1f114&is=66e09f94&hm=3345af99bd65b258d733fa3d66036e701985c3d218a8e3ceeb7a433ca468094c&"
getgenv().Config = {
	["AutoSave"] = true,
	["Legend Stage Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Double Dungeon",
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Macros"] = {
		["Macro"] = "hatdogNoro",
		["Play"] = true,
    ["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "991de35c3d962501b5befd2a8d6428b3a245c052ff43f2d37d44bffec7154938"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(10)until Joebiden
