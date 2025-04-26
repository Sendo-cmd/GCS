game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true
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
		["Double Dungeon"] = {
			["Upgrade Amount"] = 2,
			["Statue Unit"] = "Rom and Ran (Fanatic)",
			["Leave Extra Money"] = 5000,
			["Auto Statue"] = true
		},
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Bear"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true,
		["Shibuya Station"] = {
			["Mohato Unit"] = "Rom and Ran (Fanatic)",
			["Upgrade Amount"] = 2,
			["Leave Extra Money"] = 5000,
			["Auto Mohato"] = true
		}
	},
	["Modifier"] = {
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 98,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 100,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 99,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			},
			["Amount"] = {
				["Strong"] = 2,
				["Thrice"] = 1,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 1,
				["Revitalize"] = 1,
				["Immunity"] = 1,
				["Exploding"] = 1,
				["Dodge"] = 1,
				["Slayer"] = 4,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 1,
				["Range"] = 0,
				["Drowsy"] = 1,
				["Lifeline"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 1,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 1,
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
			["5"] = 0,
			["4"] = -1,
			["6"] = 0
		},
		["Enable"] = true,
		["Upgrade Method"] = "Randomize",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Martial Island"] = "Middle",
			["Planet Namak"] = "Middle",
			["Ant Island"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Cavern"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Golden Castle"] = "-100.67581939697266, -0.16030120849609375, -215.53640747070312",
			["Double Dungeon"] = "-274.45904541015625, 0.10069097578525543, -117.80802917480469",
			["Blood-Red Chamber"] = "0.8260197639465332, -0.2512565851211548, -55.03996658325195",
			["Kuinshi Palace"] = "396.4739990234375, 268.38262939453125, 115.33984375",
			["Shibuya Aftermath"] = "225.790771484375, 514.7516479492188, 60.21217727661133",
			["Planet Namak"] = "446.45465087890625, 2.062572717666626, -341.6218566894531",
			["Land of the Gods"] = "-161.33482360839844, 1.2214683294296265, 118.60115051269531"
		}
	},
	["Match Finished"] = {
		["Auto Next"] = true,
		["Replay Amount"] = 0,
		["Return Lobby Failsafe"] = true,
		["Auto Replay"] = true
	},
	["AutoExecute"] = true,
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true,
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Boss Bounties Joiner"] = {
		["Auto Join"] = true
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
