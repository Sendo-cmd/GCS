game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().Config = {
	["AutoExecute"] = true,
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
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["AutoSave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Kuinshi Palace",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 98,
				["Immunity"] = 100,
				["Exploding"] = 97,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 96,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 99,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Uncommon Loot"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Cooldown"] = 3,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 3,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 1
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Skip Wave"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Spirit Society"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Golden Castle"] = "-100.30915832519531, -0.16030120849609375, -208.8596954345703",
			["Spirit Society"] = "194.29483032226562, -0.03500000014901161, 618.197021484375",
			["Double Dungeon"] = "-286.22698974609375, 0.10069097578525543, -113.49510192871094",
			["Kuinshi Palace"] = "391.5438232421875, 268.38262939453125, 121.27950286865234",
			["Tracks at the Edge of the World"] = "1042.94287109375, 143.2725830078125, -748.5692749023438",
			["Underground Church"] = "207.26434326171875, 0.30062153935432434, 112.39350891113281",
			["Shibuya Station"] = "-764.1687622070312, 9.356081008911133, -94.26324462890625",
			["Shibuya Aftermath"] = "224.20382690429688, 514.7516479492188, 60.891056060791016"
		}
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden

