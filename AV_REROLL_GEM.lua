game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286574002604867676/C_Dung.json?ex=66f3ace9&is=66f25b69&hm=386bc1a60847a704969a4ab2eca9c43dcd26337a6a91f44241d40cdcc3ffdca8&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286932039211421736/C_Namke.json?ex=66f3a8dc&is=66f2575c&hm=ced414b3d19b767ed6a16aa4541d5b97711d43f1b1df4fcb3299d99ff1079d04&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66f383c3&is=66f23243&hm=78653e5f95a16b23ce3167d30fd038acc6c8b36d89543ab2c6fba2cc5e390097&",
    "https://cdn.discordapp.com/attachments/1284223416110415964/1284223416244895775/GEM.json?ex=66f3b182&is=66f26002&hm=10a4b836b35aa25478692511d548c9492d82ebaf10b160cd58d031e6d1862947&",
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
			["Enable"] = true,
			["FPS Cap"] = 20
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
