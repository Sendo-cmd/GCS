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
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Challenge Macro"] = {
			["Giant Island"] = "GokuCh5",
			["City of Voldstandig"] = "GokuCh2",
			["Future City (Ruins)"] = "GokuCh4",
			["Innovation Island"] = "GokuCh",
			["Hidden Storm Village"] = "GokuCh3"
		},
		["Macro"] = "GokuInf",
		["Macro Retry Limit"] = 0,
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
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Challenge Joiner"] = {
		["Expert Mode"] = true,
		["Auto Join"] = true,
		["Modifier"] = {
			["Flying Enemies"] = true,
			["Juggernaut Enemies"] = true,
			["Unsellable"] = true
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
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Innovation Island"] = true,
			["Hidden Storm Village"] = true,
			["Giant Island"] = true
		},
		["Teleport Lobby new Challenge"] = true
	},
	["Transform"] = {
		["Auto Transform Ghost Egg"] = {
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Purple"] = true,
				["Orange"] = true,
				["Red"] = true
			}
		},
		["Auto Transform Skill Orb Pure"] = {
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Purple"] = true,
				["Orange"] = true,
				["Red"] = true
			}
		}
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
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
			["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
			["Enable"] = true,
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			}
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
			["City of Voldstandig"] = {
				["1"] = "69.22769165039062, 47.85552978515625, -55.9107666015625",
				["3"] = "110.21363830566406, 47.85552978515625, -88.68482971191406",
				["2"] = "66.7347412109375, 47.85552978515625, -50.512611389160156"
			},
			["Hidden Storm Village"] = {
				["1"] = "137.67323303222656, 54.87458419799805, 34.188438415527344",
				["3"] = "101.83866119384766, 54.87458419799805, 34.68025207519531",
				["2"] = "6.603416442871094, 54.87458419799805, -24.393348693847656"
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
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden
