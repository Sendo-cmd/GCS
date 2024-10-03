game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = ""
getgenv().Config = {
	["Joiner Cooldown"] = 10,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Infinite",
		["Stage"] = "Planet Namak"
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Upgrade Method"] = "Randomize",
		["Place Cap"] = {
			["1"] = 3,
			["3"] = 0,
			["2"] = 3,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Middle Position"] = {
			["Planet Namak"] = "134.9243927001953, 7.105718612670898, 112.10484313964844"
		}
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["URL"] = ""
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Macro"] = "",
		["Ignore Macro Timing"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 5
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden