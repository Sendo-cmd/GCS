game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66f82103&is=66f6cf83&hm=a7eed8cb2efa76ad8531d0d559b6d5ac758ed71aa7caff768405cba7ca3bf3f9&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286574002604867676/C_Dung.json?ex=66f84a29&is=66f6f8a9&hm=6fbccf3221fca8badddedf29d64fd6edbbbaebfc2b029e5c40cd07dc599a03dc&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286932039211421736/C_Namke.json?ex=66f8461c&is=66f6f49c&hm=67490f8b3d905a95e7b504b81b55561915112be74b4694054f89272a5ecea7f0&",
    "https://cdn.discordapp.com/attachments/1284223416110415964/1284223416244895775/GEM.json?ex=66f84ec2&is=66f6fd42&hm=c44647d6103eb6eee8cd272b8effb7285484029f0d2d4d9b6578614666de5c3e&",
}
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
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 7
		}
	},	
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = false,
		["URL"] = "https://discord.com/api/webhooks/1285656259604774912/2m06zwdD_zylzlJ6iZ7F167cgEd8Vbg8leUk1obYgKVjXMctXsaxPIoB2FTpmkntDGnj"
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
	["Secure"] = {
		["Walk Around"] = true
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Planet Namak"] = "C_Namke",
			["Double Dungeon"] = "C_Dung",
			["Sand Village"] = "C_Sand"
		},
		["Macro"] = "GEM",
		["Play"] = true,
		["Random Offset"] = true,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Achievement"] = true
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
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
