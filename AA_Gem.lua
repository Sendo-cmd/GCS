game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Game Finished"] = {
		["Auto Replay"] = true,
		["Auto Next"] = true
	},
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Middle Position"] = {
			["Frozen Abyss"] = "397.4182434082031, 45.9230842590332, 371.3970642089844",
			["Planet Greenie"] = "-2930.51611328125, 91.80620574951172, -734.8823852539062"
		},
		["Upgrade Method"] = "Randomize"
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Macro"] = "HTestLow",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Level Milestone"] = true,
		["Auto Claim Quest"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 20
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden