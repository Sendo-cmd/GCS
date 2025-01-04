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
		["Upgrade Method"] = "Randomize",
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Planet Greenie"] = "-2930.51611328125, 91.80620574951172, -734.8823852539062"
		}
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
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden