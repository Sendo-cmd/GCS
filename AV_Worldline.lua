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
	["Gameplay"] = {
		["Double Dungeon"] = {
			["Auto Statue"] = true,
			["Statue Unit"] = "Tuji (Sorcerer Killer)",
			["Leave Extra Money"] = 0,
			["Upgrade Amount"] = 1
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Shibuya Station"] = {
			["Mohato Unit"] = "Tuji (Sorcerer Killer)",
			["Auto Mohato"] = true,
			["Leave Extra Money"] = 0,
			["Upgrade Amount"] = 2
		}
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Worldline Joiner"] = {
		["Auto Join"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Modifier"] = {
				["Immunity"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Immunity"] = 11,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Slayer"] = 16,
				["Fisticuffs"] = 25,
				["Planning Ahead"] = 15,
				["Harvest"] = 17,
				["Quake"] = 9,
				["Range"] = 18,
				["No Trait No Problem"] = 23,
				["Drowsy"] = 8,
				["King's Burden"] = 27,
				["Regen"] = 7,
				["Exterminator"] = 28,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Cooldown"] = 19,
				["Lifeline"] = 29,
				["Press It"] = 14,
				["Precise Attack"] = 13,
				["Shielded"] = 5,
				["Uncommon Loot"] = 22,
				["Money Surge"] = 26
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = -1,
			["4"] = -1,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Martial Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Cavern"] = "Middle",
			["Ant Island"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Blood-Red Chamber"] = "Middle"
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
			["Golden Castle"] = "-99.95283508300781, -0.16030120849609375, -209.19700622558594",
			["Double Dungeon"] = "-281.06927490234375, 0.10069097578525543, -115.02333068847656",
			["Kuinshi Palace"] = "392.0209045410156, 268.38262939453125, 117.99325561523438",
			["Shibuya Station"] = "-767.7849731445312, 9.356081008911133, -117.69595336914062",
			["Planet Namak"] = "535.2527465820312, 2.062572717666626, -368.2378845214844"
		},
		["Focus on Farm"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = true,
		["Replay Amount"] = 0,
		["Auto Replay"] = true
	},
	["AutoExecute"] = true,
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden