getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283341385994600480/chap1.json?ex=66e2a44d&is=66e152cd&hm=53d42b4547346882367dbe698bfc1f6c950a19766f1c5fbdf823efeb07e009f4&"
getgenv().Config = {
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Act"] = "Act1",
		["Stage"] = "Planet Namak",
		["Auto Join"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Macros"] = {
		["Macro"] = "chap1",
		["Play"] = true,
		["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "991de35c3d962501b5befd2a8d6428b3a245c052ff43f2d37d44bffec7154938"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
