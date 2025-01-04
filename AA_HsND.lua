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
			["Frozen Abyss"] = "397.4182434082031, 45.9230842590332, 371.3970642089844"
		}
	},
	["Macros"] = {
		["Macro"] = "HTestLow",
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
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
		["Auto Claim Quest"] = true,
		["Auto Claim Level Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 20
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden