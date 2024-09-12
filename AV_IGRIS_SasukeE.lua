game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283522078879907960/LSDD3_SasukeE.json?ex=66e34c96&is=66e1fb16&hm=b18bea2261ba84d4ede4ac059329cb195b131064ec3dc97e6484e2921338591d&"
getgenv().Config = {
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["AutoSave"] = true,
	["Macros"] = {
		["Macro"] = "LSDD3_SasukeE",
		["Ignore Macro Timing"] = true,
		["Play"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	}
}
getgenv().Key = "eaaca5965fa2de2d5b74fb1affa8288d0b209a77547a926b8fe7e0fc60d08af0"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
