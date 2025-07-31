game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Gold Buyer"] = {
		["Enable"] = true,
		["Item"] = {
			["Crystal"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true,
			["Senzu Bean"] = true,
			["Pink Essence Stone"] = true,
			["Ramen"] = true,
			["Green Essence Stone"] = true,
			["Rainbow Essence Stone"] = true,
			["Super Stat Chip"] = true,
			["Stat Chip"] = true
		}
	},
	["Stage Joiner"] = {
		["Stage"] = "Double Dungeon"
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Legend Stage Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["No Ignore Sell Timing"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act1"
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
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell Farm"] = {
			["Wave"] = 1
		},
		["Double Dungeon"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Bear"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Shibuya Station"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		}
	},
	["Misc"] = {
		["Max Camera Zoom"] = 40
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true
		},
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Replay Amount"] = 0,
		["Auto Replay"] = true
	},
	["Crafter"] = {
		["Enable"] = true,
		["Teleport Lobby full Essence"] = true,
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 25,
			["Blue Essence Stone"] = 25,
			["Red Essence Stone"] = 25,
			["Yellow Essence Stone"] = 25,
			["Purple Essence Stone"] = 25
		}
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
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
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
			["Martial Island"] = "Middle",
			["Ruined City"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Cavern"] = "Middle",
			["Planet Namak"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Ant Island"] = "Middle"
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
			["Double Dungeon"] = "-275.28289794921875, 0.10069097578525543, -118.52613830566406"
		},
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Cavern"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Blood-Red Chamber"] = 2,
			["Planet Namak"] = 2,
			["Martial Island"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Tracks at the Edge of the World"] = 2
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Joiner Cooldown"] = 0,
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Modifier"] = {
				["King's Burden"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 100,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Immunity"] = 99,
				["Revitalize"] = 97,
				["Harvest"] = 0,
				["Champions"] = 98,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Range"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Quake"] = 96,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 3,
				["Thrice"] = 3,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Slayer"] = 0,
				["Immunity"] = 1,
				["Revitalize"] = 3,
				["Harvest"] = 0,
				["Champions"] = 1,
				["Cooldown"] = 3,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 3,
				["Range"] = 0,
				["Regen"] = 3,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Quake"] = 3,
				["Shielded"] = 3,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
			}
		}
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden


