game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Team Equipper"] = {
			["Auto Join Team"] = {
				["Trial Joiner"] = 0,
				["Challenge Joiner"] = 0,
				["Infinite Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Story Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Dungeon Joiner"] = 0
			},
			["Enable"] = false
		},
		["Macro Equipper"] = {
			["Enable"] = false
		}
	},
	["Transform"] = {
		["Auto Transform Ghost Rainbow"] = false,
		["Auto Transform Ghost Egg"] = {
			["Enable"] = false,
			["Transform Color"] = {
				["Blue"] = false,
				["Green"] = false,
				["Purple"] = false,
				["Orange"] = false,
				["Red"] = false
			}
		},
		["Auto Transform EXP"] = true,
		["Auto Transform Skill Orb Pure"] = {
			["Enable"] = false,
			["Transform Color"] = {
				["Blue"] = false,
				["Green"] = false,
				["Purple"] = false,
				["Orange"] = false,
				["Red"] = false
			}
		}
	},
	["Story Joiner"] = {
		["Hard Mode"] = false,
		["Auto Join"] = false,
		["Auto Open Story Loot"] = false
	},
	["Dungeon Joiner"] = {
		["Instant Teleport Lobby Dungeon spawned"] = false,
		["Teleport Lobby Dungeon spawned"] = false,
		["Auto Join"] = false,
		["Auto Open Dungeon Loot"] = false
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = true,
		["Auto Next"] = false,
		["Return Lobby Failsafe"] = false,
		["Auto Replay"] = true,
		["Return Lobby Defeat Count"] = 0
	},
	["Webhook"] = {
		["Match Finished"] = false
	},
	["Infinite Joiner"] = {
		["Classic Mode"] = false,
		["Auto Join"] = true,
		["Max Void Bag Action"] = "Loose game - Auto Open Void Bag can open while in game",
		["Auto Open Void Bag"] = true
	},
	["Raid Joiner"] = {
		["Auto Join"] = false,
		["Strategist Mode"] = false,
		["Find Team"] = false,
		["Element"] = {
			["Blue"] = true,
			["Green"] = true,
			["Purple"] = true,
			["Orange"] = true,
			["Red"] = true
		}
	},
	["Macros"] = {
		["Auto Equip"] = false,
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Challenge Macro"] = {
			["Giant Island"] = "GokuCh5",
			["City of Voldstandig"] = "GokuCh2",
			["Future City (Ruins)"] = "GokuCh4",
			["Innovation Island"] = "GokuCh",
			["Hidden Storm Village"] = "GokuCh3"
		},
		["Macro"] = "GokuInf",
		["No Ignore Sell Timing"] = true,
		["Play"] = false
	},
	["Trial Joiner"] = {
		["Auto Join"] = false,
		["Strategist Mode"] = false
	},
	["Joiner Cooldown"] = 0,
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = false
	},
	["Challenge Joiner"] = {
		["Expert Mode"] = true,
		["Auto Join"] = true,
		["Modifier"] = {
			["Flying Enemies"] = true,
			["Juggernaut Enemies"] = true,
			["Unsellable"] = true,
			["High Cost"] = false,
			["Random Units"] = false,
			["Single Placement"] = false
		},
		["Reward"] = {
			["Bounded Cube"] = false,
			["Skill Orb I (Purple)"] = false,
			["Skill Orb II (Orange)"] = false,
			["Ghost I (Rainbow)"] = true,
			["Skill Orb I (Blue)"] = false,
			["Skill Orb II (Green)"] = false,
			["Skill Orb II (Pure)"] = false,
			["Ghost III (Rainbow)"] = true,
			["Skill Orb II (Blue)"] = false,
			["Skill Orb I (Red)"] = false,
			["Skill Orb I (Green)"] = false,
			["Stat Dice"] = false,
			["Skill Orb I (Orange)"] = false,
			["Skill Orb II (Red)"] = false,
			["Trait Burner"] = true,
			["Skill Orb I (Pure)"] = false,
			["Ghost II (Rainbow)"] = true,
			["Skill Orb II (Purple)"] = false
		},
		["Reward Priority"] = {
			["Bounded Cube"] = 0,
			["Skill Orb I (Purple)"] = 0,
			["Skill Orb II (Orange)"] = 0,
			["Ghost I (Rainbow)"] = 0,
			["Skill Orb I (Blue)"] = 0,
			["Skill Orb II (Green)"] = 0,
			["Skill Orb II (Pure)"] = 0,
			["Ghost III (Rainbow)"] = 0,
			["Skill Orb II (Blue)"] = 0,
			["Skill Orb I (Red)"] = 0,
			["Ghost II (Rainbow)"] = 0,
			["Stat Dice"] = 0,
			["Skill Orb I (Orange)"] = 0,
			["Skill Orb II (Red)"] = 0,
			["Skill Orb I (Pure)"] = 0,
			["Trait Burner"] = 0,
			["Skill Orb I (Green)"] = 0,
			["Skill Orb II (Purple)"] = 0
		},
		["Stage"] = {
			["Innovation Island"] = true,
			["Shadow Tournament"] = true,
			["Future City (Ruins)"] = true,
			["Giant Island"] = true,
			["City of Voldstandig"] = true,
			["City of York"] = true,
			["Hidden Storm Village"] = true
		},
		["Teleport Lobby new Challenge"] = true
	},
	["Misc"] = {
		["Auto Basic Capsule"] = false,
		["Auto Summer Firework"] = false,
		["Auto Royal Drops"] = false
	},
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Enable"] = false,
			["Prioritize"] = {
				["Thunder Step"] = 5,
				["Tsuku & Yomii"] = 2,
				["Arise"] = 3,
				["Red Spirit"] = 8,
				["Revert to Null"] = 4,
				["Binding Vow of Haste"] = 6,
				["Binding Vow of Vitality"] = 1,
				["Binding Vow of Aegis"] = 7,
				["Sixth Sense"] = 9
			},
			["Amount"] = {
				["Thunder Step"] = 0,
				["Tsuku & Yomii"] = 0,
				["Arise"] = 0,
				["Red Spirit"] = 0,
				["Revert to Null"] = 0,
				["Binding Vow of Haste"] = 0,
				["Binding Vow of Vitality"] = 0,
				["Binding Vow of Aegis"] = 0,
				["Sixth Sense"] = 0
			}
		},
		["Auto Teleport to Enemies"] = false,
		["Teleport Priority"] = "First",
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = true,
				["Wave"] = 15
			},
			["Auto Sell Unit"] = {
				["Enable"] = false,
				["Wave"] = 1
			}
		},
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop at Wave"] = 0
		},
		["Auto Infinite Buff"] = {
			["Xero"] = false,
			["King Kaoe"] = false,
			["Onwin"] = false
		},
		["Auto Vote Start"] = false,
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 2
		}
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = true,
		["Expert Mode"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = {
			["Upgrade Order"] = {
				["1"] = 1,
				["3"] = 3,
				["2"] = 2,
				["5"] = 5,
				["4"] = 4,
				["6"] = 6
			},
			["Upgrade Method"] = "Randomize",
			["Enable"] = true,
			["Focus on Farm"] = false,
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			},
			["Place and Upgrade"] = false
		},
		["Place Wave"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Slot Position"] = {
			["City of Voldstandig"] = {
				["1"] = "71.24491119384766, 47.85552978515625, -63.3255615234375",
				["3"] = "96.1864013671875, 47.85552978515625, -49.31040573120117",
				["2"] = "65.80626678466797, 47.85552978515625, -48.08441925048828"
			},
			["City of York"] = {
				["1"] = "51.1607551574707, 37.43605041503906, 176.0936279296875",
				["3"] = "36.14110565185547, 38.03605270385742, 163.88778686523438",
				["2"] = "22.2163028717041, 42.93605041503906, 107.40767669677734"
			},
			["Giant Island"] = {
				["1"] = "5.908024311065674, 0.9230000972747803, -642.15380859375",
				["3"] = "-14.327132225036621, 0.9230000972747803, -608.6400146484375",
				["2"] = "18.39122772216797, 0.9230000972747803, -626.4512939453125"
			},
			["Innovation Island"] = {
				["1"] = "-113.25743103027344, 2.9135429859161377, -51.63191604614258",
				["3"] = "-109.16082763671875, 2.9135429859161377, -95.34555053710938",
				["2"] = "-74.1626968383789, 2.9135429859161377, -33.46575164794922"
			},
			["Future City (Ruins)"] = {
				["1"] = "-221.18836975097656, 423.873779296875, -91.61482238769531",
				["3"] = "-233.45761108398438, 423.873779296875, -180.6953125",
				["2"] = "-225.9675750732422, 423.873779296875, -143.8316650390625"
			},
			["Hidden Storm Village"] = {
				["1"] = "138.65740966796875, 54.87458419799805, 51.45439910888672",
				["3"] = "-1.6957201957702637, 54.87458419799805, -26.740365982055664",
				["2"] = "-65.47711944580078, 54.87458419799805, -73.66567993164062"
			}
		},
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = -1,
			["4"] = -1,
			["6"] = -1
		},
		["Place Order"] = {
			["1"] = 1,
			["3"] = 3,
			["2"] = 2,
			["5"] = 5,
			["4"] = 4,
			["6"] = 6
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" 
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(1)until Joebiden