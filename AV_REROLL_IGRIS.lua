game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66f82103&is=66f6cf83&hm=a7eed8cb2efa76ad8531d0d559b6d5ac758ed71aa7caff768405cba7ca3bf3f9&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286574002604867676/C_Dung.json?ex=66f84a29&is=66f6f8a9&hm=6fbccf3221fca8badddedf29d64fd6edbbbaebfc2b029e5c40cd07dc599a03dc&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286932039211421736/C_Namke.json?ex=66f8461c&is=66f6f49c&hm=67490f8b3d905a95e7b504b81b55561915112be74b4694054f89272a5ecea7f0&",
    "https://cdn.discordapp.com/attachments/1284223982782119967/1288833410051342417/LSDD3_SonjE.json?ex=66f747e6&is=66f5f666&hm=51739b1899eccb0d1cb52b3e17a9697e4a4cad3d76a896ed621261fadb8da67d&",
}
getgenv().Config = {
	["Joiner Cooldown"] = 10,
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
			["Fast"] = false
		},
		["Teleport Lobby new Challenge"] = true,
		["Reward"] = {
			["TraitRerolls"] = true
		}
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
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
			["Fast"] = true
		},
		["Ignore Act"] = {
			["[Double Dungeon] Act6"] = true
		},
		["Auto Join"] = true,
		["Reward"] = {
			["TraitRerolls"] = true
		}
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Planet Namak"] = "New_ChaNamek",
			["Double Dungeon"] = "New_ChaDD",
			["Sand Village"] = "New_ChaSand"
		},
		["Macro"] = "DDLS_Base",
		["Play"] = true,
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden
