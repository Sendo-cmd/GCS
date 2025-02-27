setfpscap(7)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true,
        ["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 4
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Middle Position"] = {
			["Double Dungeon"] = "-285.634033203125, 0.10069097578525543, -119.06967163085938",
			["Planet Namak"] = "76.93323516845703, 7.105718612670898, 124.72885131835938",
			["Shibuya Station"] = "-766.3342895507812, 9.356081008911133, -119.06056213378906",
			["Spider Forest"] = "-301.991455078125, 1644.5369873046875, -373.0265808105469",
			["Sand Village"] = "34.26637268066406, 9.966852188110352, 4.0714216232299805"
		},
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)"
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = false
	},		
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Raid Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Spider Forest",
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
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
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Macros"] = {
		["Play"] = false,
		["Macro"] = "Raid_Base",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden