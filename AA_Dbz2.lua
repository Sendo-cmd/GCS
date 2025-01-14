game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Joiner Cooldown"] = 0,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Ignore Upgrade"] = {
			["6"] = true
		},
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Middle Position"] = {
			["Sacred Planet"] = "-147.89646911621094, 109.84346008300781, 53.93146514892578"
		},
		["Focus on Farm"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Smart Auto Ability"] = {
			["Wind Dragon"] = true
		},
		["Auto Skip Wave"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(7)until Joebiden