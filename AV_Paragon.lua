game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Double Dungeon"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Middle Position"] = {
			["Planet Namak"] = "540.7809448242188, 2.062572717666626, -365.7040710449219"
		},
		["Focus on Farm"] = true
	},
	["AutoExecute"] = true,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Paragon",
		["Stage"] = "Planet Namak"
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = true,
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Winter Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		}
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
			["Prioritize"] = {
				["Strong"] = 97,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 100,
				["Fast"] = 1,
				["Revitalize"] = 98,
				["Exploding"] = 96,
				["Dodge"] = 79,
				["Immunity"] = 99,
				["Fisticuffs"] = 25,
				["Harvest"] = 17,
				["Uncommon Loot"] = 22,
				["Precise Attack"] = 13,
				["Drowsy"] = 80,
				["No Trait No Problem"] = 23,
				["Cooldown"] = 19,
				["Regen"] = 95,
				["King's Burden"] = 27,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Range"] = 18,
				["Quake"] = 2,
				["Press It"] = 14,
				["Planning Ahead"] = 15,
				["Shielded"] = 94,
				["Slayer"] = 16,
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
				["Uncommon Loot"] = 0,
				["Precise Attack"] = 0,
				["Drowsy"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Quake"] = 0,
				["Press It"] = 0,
				["Planning Ahead"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Vote Start"] = true,
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden