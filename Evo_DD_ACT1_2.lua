getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283537970695114836/Evo_DD_ACT1_2.json?ex=66e35b63&is=66e209e3&hm=4c34d2387961ee8f70862c27187f77037f35389f07caae85393953da6f567ad8&"
getgenv().Config = {
	["AutoSave"] = true,
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act1"
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
		["Macro"] = "Evo_DD_ACT1_2",
		["Play"] = true
	}
}
getgenv().Key = "991de35c3d962501b5befd2a8d6428b3a245c052ff43f2d37d44bffec7154938"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(10)until Joebiden
