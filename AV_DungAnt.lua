game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Randomize",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Planet Namak"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle"
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
			["Ant Island"] = "-20.361221313476562, 164.8186492919922, -45.29857635498047"
		}
	},
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Auto Next"] = true,
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
		["Auto Rejoin"] = true
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
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 96,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 1,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 2,
				["Slayer"] = 92,
				["Fisticuffs"] = 0,
				["Champions"] = 98,
				["Harvest"] = 100,
				["Planning Ahead"] = 0,
				["Damage"] = 90,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Quake"] = 0,
				["Exterminator"] = 23,
				["Regen"] = 0,
				["Range"] = 91,
				["Common Loot"] = 97,
				["King's Burden"] = 80,
				["Lifeline"] = 24,
				["Press It"] = 93,
				["Cooldown"] = 89,
				["Shielded"] = 0,
				["Uncommon Loot"] = 99,
				["Money Surge"] = 0
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Immunity"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Champions"] = 0,
				["Cooldown"] = 0,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Range"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Exterminator"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		},
		["Ant Island"] = {
			["Walk To Ant Tunnel"] = true,
			["Auto Plug Ant Tunnel"] = true
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Wave"] = 1
		}
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden


