game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Team Equipper"] = {
			["Auto Join Team"] = {
				["Challenge Joiner"] = 0,
				["Infinite Joiner"] = 0,
				["Trial Joiner"] = 0,
				["Story Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Dungeon Joiner"] = 0
			}
		}
	},
	["Transform"] = {
		["Auto Transform Skill Orb Pure"] = {
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Purple"] = true,
				["Orange"] = true,
				["Red"] = true
			}
		},
		["Auto Transform Ghost Rainbow"] = true,
		["Auto Transform EXP"] = true,
		["Auto Transform Ghost Egg"] = {
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Purple"] = true,
				["Orange"] = true,
				["Red"] = true
			}
		}
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Innovation Island"] = "GokuCh",
			["Future City (Ruins)"] = "GokuCh4",
			["City of Voldstandig"] = "GokuCh2",
			["Giant Island"] = "GokuCh5",
			["Hidden Storm Village"] = "GokuCh3"
		},
		["Macro Retry Limit"] = 0,
		["Macro"] = "GokuInf",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = true,
		["Auto Replay"] = true
	},
	["Infinite Joiner"] = {
		["Auto Join"] = true,
		["Max Void Bag Action"] = "Loose game - Auto Open Void Bag can open while in game",
		["Auto Open Void Bag"] = true
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
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			},
			["Enable"] = true,
			["Upgrade Method"] = "Randomize"
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
			["Innovation Island"] = {
				["1"] = "-113.25743103027344, 2.9135429859161377, -51.63191604614258",
				["3"] = "-109.16082763671875, 2.9135429859161377, -95.34555053710938",
				["2"] = "-74.1626968383789, 2.9135429859161377, -33.46575164794922"
			},
			["Giant Island"] = {
				["1"] = "5.908024311065674, 0.9230000972747803, -642.15380859375",
				["3"] = "-14.327132225036621, 0.9230000972747803, -608.6400146484375",
				["2"] = "18.39122772216797, 0.9230000972747803, -626.4512939453125"
			},
			["City of Voldstandig"] = {
				["1"] = "71.24491119384766, 47.85552978515625, -63.3255615234375",
				["3"] = "96.1864013671875, 47.85552978515625, -49.31040573120117",
				["2"] = "65.80626678466797, 47.85552978515625, -48.08441925048828"
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
			["4"] = 1,
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
	},
	["Joiner Cooldown"] = 0,
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Random Offset"] = true
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
			["Skill Orb I (Purple)"] = true,
			["Skill Orb II (Orange)"] = true,
			["Ghost I (Rainbow)"] = true,
			["Skill Orb I (Blue)"] = true,
			["Skill Orb II (Green)"] = true,
			["Skill Orb II (Pure)"] = true,
			["Ghost III (Rainbow)"] = true,
			["Skill Orb II (Blue)"] = true,
			["Skill Orb I (Red)"] = true,
			["Skill Orb I (Green)"] = true,
			["Skill Orb I (Orange)"] = true,
			["Skill Orb II (Red)"] = true,
			["Trait Burner"] = true,
			["Skill Orb I (Pure)"] = true,
			["Ghost II (Rainbow)"] = true,
			["Skill Orb II (Purple)"] = true
		},
		["Stage"] = {
			["Giant Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Innovation Island"] = true,
			["Hidden Storm Village"] = true
		},
		["Teleport Lobby new Challenge"] = true
	},
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Prioritize"] = {
				["Binding Vow of Vitality"] = 1,
				["Tsuku & Yomii"] = 2,
				["Arise"] = 3,
				["Red Spirit"] = 8,
				["Revert to Null"] = 4,
				["Binding Vow of Haste"] = 6,
				["Thunder Step"] = 5,
				["Binding Vow of Aegis"] = 7,
				["Sixth Sense"] = 9
			},
			["Amount"] = {
				["Binding Vow of Vitality"] = 0,
				["Tsuku & Yomii"] = 0,
				["Arise"] = 0,
				["Red Spirit"] = 0,
				["Revert to Null"] = 0,
				["Binding Vow of Haste"] = 0,
				["Thunder Step"] = 0,
				["Binding Vow of Aegis"] = 0,
				["Sixth Sense"] = 0
			}
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = true,
				["Wave"] = 15
			},
			["Auto Sell Unit"] = {
				["Wave"] = 1
			}
		},
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop at Wave"] = 0
		},
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 2
		}
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = true,
		["Expert Mode"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden