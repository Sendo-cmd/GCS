game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286574002604867676/C_Dung.json?ex=66ee66e9&is=66ed1569&hm=c2b875923992bad4cca013652fbf393e49ec5a415d8f1e2410889b52beeb6ded&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627085889637/C_Namke.json?ex=66ee3dc3&is=66ecec43&hm=c5dc0fbc3d7c4a536d3ae8b186812703da6a98fe37ed7c710317435dc4c58c86&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66ee3dc3&is=66ecec43&hm=17f6cf3ba1dc4a5e493d20576e7d66a2f9659935b8a0e77a7c7ce3eb1b8ee04c&",
    "https://cdn.discordapp.com/attachments/1284223982782119967/1285088790662086706/LSDD3_SonjE.json?ex=66ee45b3&is=66ecf433&hm=82929868f63ca18c87b33603a07db12c08026f63559db37242cfbfb2754ac814&",
}
getgenv().Config = {
	["Joiner Cooldown"] = 5,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = true,
		["URL"] = "https://discord.com/api/webhooks/1285656259604774912/2m06zwdD_zylzlJ6iZ7F167cgEd8Vbg8leUk1obYgKVjXMctXsaxPIoB2FTpmkntDGnj"
	},
	["HalfHourly Challenge Joiner"] = {
		["Ignore Act"] = {
			["[Double Dungeon] Act6"] = true
		},
		["Auto Join"] = true,
		["Ignore Difficulty"] = {
			["Revitalize"] = true,
			["Fast"] = true
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
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true,
			["Pink Essence Stone"] = true,
			["Stat Chip"] = true,
			["Green Essence Stone"] = true,
			["TraitRerolls"] = true,
			["Super Stat Chip"] = true,
			["Rainbow Essence Stone"] = true
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
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
