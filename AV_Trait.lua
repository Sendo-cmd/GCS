game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Act1",
		["Stage"] = "Planet Namak"
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["AutoSave"] = true,
	["HalfHourly Challenge Joiner"] = {
		["Ignore Act"] = {
			["[Double Dungeon] Act6"] = true
		},
		["Auto Join"] = true,
		["Teleport Lobby new Challenge"] = true,
		["Reward"] = {
			["TraitRerolls"] = true
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 4
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place and Upgrade"] = false,
		["Enable"] = true,
		["Middle Position"] = {
			["Planet Namak"] = "79.00111389160156, 7.105718612670898, 122.80880737304688",
			["Shibuya Station"] = "-764.9132080078125, 9.356081008911133, -119.7239990234375",
			["Double Dungeon"] = "-278.3384094238281, 0.10069097578525543, -92.76183319091797",
			["Sand Village"] = "58.4763298034668, 9.966852188110352, -26.314233779907227"
		},
		["Upgrade Method"] = "Nearest from Middle Position (until Max)"
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 29,
				["Thrice"] = 4,
				["Regen"] = 28,
				["Fast"] = 0,
				["Revitalize"] = 6,
				["Drowsy"] = 20,
				["Exploding"] = 2,
				["Dodge"] = 1,
				["Quake"] = 3,
				["Immunity"] = 26,
				["Shielded"] = 25,
				["Champions"] = 30
			}
		}
	},
	["Daily Challenge Joiner"] = {
		["Ignore Modifier"] = {
			["Exploding"] = true,
			["Thrice"] = true,
			["Fast"] = true
		},
		["Ignore Act"] = {
			["[Double Dungeon] Act6"] = true
		},
		["Auto Join"] = true,
		["Reward"] = {
			["TraitRerolls"] = true
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden