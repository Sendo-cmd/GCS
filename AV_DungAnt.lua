game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
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
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Cash Out Floor"] = 5,
		["Intensity"] = 200,
		["First Team"] = 1
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
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 30
		},
		["Double Dungeon"] = {
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 0
		},
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
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
		["Auto Vote Start"] = true,
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["Auto Skip Wave"] = true,
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Shibuya Station"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		}
	},
	["Misc"] = {
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 90,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 4,
				["Dodge"] = 0,
				["Uncommon Loot"] = 98,
				["Immunity"] = 91,
				["Planning Ahead"] = 0,
				["Harvest"] = 99,
				["Precise Attack"] = 0,
				["Range"] = 96,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Cooldown"] = 93,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 95,
				["Common Loot"] = 97,
				["King's Burden"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 94,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 92,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 1,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 1,
				["Revitalize"] = 1,
				["Immunity"] = 1,
				["Exploding"] = 3,
				["Dodge"] = 1,
				["Slayer"] = 4,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["Drowsy"] = 1,
				["Lifeline"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 3,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
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
			["4"] = 0,
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
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Ruined City"] = "Middle",
			["Planet Namak"] = "Middle",
			["Cavern"] = "Middle",
			["Martial Island"] = "Middle",
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
			["Ant Island"] = "-16.99512481689453, 164.8186492919922, -45.40901184082031"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Blood-Red Chamber"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Ant Island"] = 2.4,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Planet Namak"] = 2,
			["Cavern"] = 2,
			["Martial Island"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Tracks at the Edge of the World"] = 2
		}
	},
	["Match Finished"] = {
		["Replay Amount"] = 0,
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Random Offset"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Act"] = "AntIsland"
	},
	["Crafter"] = {
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 50,
			["Blue Essence Stone"] = 50,
			["Red Essence Stone"] = 50,
			["Yellow Essence Stone"] = 50,
			["Purple Essence Stone"] = 50
		}
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
