game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 65,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Infinite",
		["Stage"] = "Planet Namak"
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 4
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Upgrade Method"] = "Nearest from Middle Position (until Max)",
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Middle Position"] = {
			["Planet Namak"] = "134.9243927001953, 7.105718612670898, 112.10484313964844"
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Gold Buyer"] = {
		["Enable"] = true,
		["Item"] = {
			["Crystal"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true,
			["Senzu Bean"] = true,
			["Pink Essence Stone"] = true,
			["Ramen"] = true,
			["Green Essence Stone"] = true,
			["Rainbow Essence Stone"] = true,
			["Super Stat Chip"] = true,
			["Stat Chip"] = true
		}
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true
		}	
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(3)until Joebiden