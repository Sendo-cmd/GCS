game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 10,
	["Stage Joiner"] = {
		["Act"] = "Act1",
		["Stage"] = "Planet Namak",
		["Auto Join"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 5
		}
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},		
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = false,
		["URL"] = ""
	},
	["HalfHourly Challenge Joiner"] = {
		["Ignore Act"] = {
			["[Double Dungeon] Act6"] = true
		},
		["Auto Join"] = true,
		["Ignore Difficulty"] = {
			["Revitalize"] = true,
			["Exploding"] = false,
			["Fast"] = true
		},
		["Teleport Lobby new Challenge"] = true,
		["Reward"] = {
			["TraitRerolls"] = true
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Planet Namak"] = "New_ChaNamek",
			["Double Dungeon"] = "New_ChaDD",
			["Sand Village"] = "New_ChaSand"
		},
		["Macro"] = "GEM",
		["Play"] = true,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
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
	["Crafter"] = {
		["Teleport Lobby full Essence"] = true,
		["Enable"] = true,
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 10,
			["Blue Essence Stone"] = 10,
			["Red Essence Stone"] = 10,
			["Yellow Essence Stone"] = 10,
			["Purple Essence Stone"] = 10
		}
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 1
		}
	},
	["Daily Challenge Joiner"] = {
		["Ignore Difficulty"] = {
			["Revitalize"] = true,
			["Exploding"] = false,
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
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
