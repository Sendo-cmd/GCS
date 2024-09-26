game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
delfile("Nousigi Hub/Macro")

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286574002604867676/C_Dung.json?ex=66f5a729&is=66f455a9&hm=26148a0bef51db839f54790512dd00f057ad52373426bd77a64819d89e674645&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286932039211421736/C_Namke.json?ex=66f5a31c&is=66f4519c&hm=6b7a078f5070ec33cf46090ce7e7acb381e0b2276b6ca26b1fc50c22026d80d4&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66f57e03&is=66f42c83&hm=963e187ad6a87bf1c92d463b03ecbe0ccc42c75958d3d47c3f126fe92ba46f5a&",
    "https://cdn.discordapp.com/attachments/1284223982782119967/1285088790662086706/LSDD3_SonjE.json?ex=66f585f3&is=66f43473&hm=97d5b990c2fb8a4777e2c0bf5d3cde7298161e3d99ba8ebf813a7cc34d99fb4c&",
}
getgenv().Config = {
	["Joiner Cooldown"] = 10,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true,
			["FPS Cap"] = 10
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
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoSave"] = true,
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
			["Planet Namak"] = "C_Namke",
			["Double Dungeon"] = "C_Dung",
			["Sand Village"] = "C_Sand"
		},
		["Macro"] = "LSDD3_SonjE",
		["Play"] = true,
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
