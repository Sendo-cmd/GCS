game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Auto Next"] = true,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		},
		["Ignore Act"] = {
			["[Shibuya Station] Act4"] = true,
			["[Shibuya Station] Act3"] = true,
			["[Shibuya Station] Act5"] = true,
			["[Shibuya Station] Act1"] = true,
			["[Shibuya Station] Act6"] = true,
			["[Shibuya Station] Act2"] = true
		}
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
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 22
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Vote Start"] = true,
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Planning Ahead"] = 15,
				["Fisticuffs"] = 25,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Uncommon Loot"] = 22,
				["Immunity"] = 11,
				["Revitalize"] = 6,
				["Harvest"] = 17,
				["Precise Attack"] = 13,
				["Range"] = 18,
				["No Trait No Problem"] = 23,
				["Drowsy"] = 8,
				["Cooldown"] = 19,
				["Exterminator"] = 28,
				["King's Burden"] = 27,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Regen"] = 7,
				["Lifeline"] = 29,
				["Press It"] = 14,
				["Quake"] = 9,
				["Shielded"] = 5,
				["Slayer"] = 16,
				["Money Surge"] = 26
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Ant Island"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Cavern"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Spirit Society"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Planet Namak"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Middle Position"] = {
			["Shibuya Aftermath"] = "-94.77557373046875, 316.1539306640625, -34.29759216308594",
			["Spirit Society"] = "201.20594787597656, -0.03500000014901161, 657.1648559570312",
			["Planet Namak"] = "540.7099609375, 2.062572717666626, -365.3252258300781",
			["Underground Church"] = "191.08030700683594, 0.30062153935432434, 112.90398406982422",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281"
		},
		["Focus on Farm"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Claimer"] = {
		["Auto Claim Collection Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden