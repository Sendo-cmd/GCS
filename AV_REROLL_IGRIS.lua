game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = {
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348626582306847/C_Dung.json?ex=66ed9503&is=66ec4383&hm=4ec7c9ce1268084f96a55c8041bcdc1359d6ced1493d3d53cd8241a78bd3577e&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627085889637/C_Namke.json?ex=66ed9503&is=66ec4383&hm=cbeac83d890a10dc4879a6296f6a277fcfbaa74397d9799061c56b5cb9273495&",
    "https://cdn.discordapp.com/attachments/1286348626259611658/1286348627437944842/C_Sand.json?ex=66ed9503&is=66ec4383&hm=74799a89b3a7546e98b0fde9e29fa9593836ed9f28bea03b54f17b671630ca74&",
    "https://cdn.discordapp.com/attachments/1284223982782119967/1285088790662086706/LSDD3_SonjE.json?ex=66ecf433&is=66eba2b3&hm=d859b10afe306444f397c583a4038bfff7a1591abb794c2f2afdcd678bf95128&",
}
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 5,
	["Legend Stage Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Double Dungeon",
		["Act"] = "Act3"
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Joiner Cooldown"] = 5,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = true,
		["URL"] = "https://discord.com/api/webhooks/1285656259604774912/2m06zwdD_zylzlJ6iZ7F167cgEd8Vbg8leUk1obYgKVjXMctXsaxPIoB2FTpmkntDGnj"
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Planet Namak"] = "C_Namke",
			["Double Dungeon"] = "C_Namke",
			["Sand Village"] = "C_Sand"
		},
		["Macro"] = "GEM",
		["Play"] = true,
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
			["Exploding"] = true,
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
