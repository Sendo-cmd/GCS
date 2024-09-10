getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1282909806738538517/520Namak.txt?ex=66e1125d&is=66dfc0dd&hm=0dce0a5e239e7e733c45c17a6d8d3c200365f93073d60682d35795bfdf80997d&"
getgenv().Config = {
	["Macros"] = {
		["Macro"] = "520Namak",
		["Play"] = true,
		["Ignore Macro Timing"] = true
	},
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Act1",
		["Stage"] = "Planet Namak"
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Sand Village",
		["Act"] = "Act3"
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "991de35c3d962501b5befd2a8d6428b3a245c052ff43f2d37d44bffec7154938"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
