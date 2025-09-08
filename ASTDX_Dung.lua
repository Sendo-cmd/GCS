game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
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
	["Misc"] = {
		["Auto Basic Capsule"] = true
	},
	["Joiner Cooldown"] = 0,
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
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
	["Macros"] = {
		["Dungeon Macro"] = {
			["Dungeon"] = "DgDw"
		},
		["Macro Retry Limit"] = 0,
		["Macro"] = "DWInf",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Dungeon Joiner"] = {
		["Teleport Lobby Dungeon spawned"] = true,
		["Auto Join"] = true,
		["Auto Open Dungeon Loot"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = false
	},
	["Challenge Joiner"] = {
		["Modifier"] = {
			["Flying Enemies"] = true,
			["Juggernaut Enemies"] = true,
			["Unsellable"] = true,
			["High Cost"] = true,
			["Random Units"] = true,
			["Single Placement"] = true
		},
		["Stage"] = {
			["Innovation Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Giant Island"] = true,
			["Hidden Storm Village"] = true
		}
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
				["Revert to Null"] = 4,
				["Binding Vow of Aegis"] = 7,
				["Arise"] = 3,
				["Binding Vow of Haste"] = 6,
				["Binding Vow of Vitality"] = 1,
				["Red Spirit"] = 8,
				["Sixth Sense"] = 9
			},
			["Amount"] = {
				["Thunder Step"] = 0,
				["Tsuku & Yomii"] = 0,
				["Revert to Null"] = 0,
				["Binding Vow of Aegis"] = 0,
				["Arise"] = 0,
				["Binding Vow of Haste"] = 0,
				["Binding Vow of Vitality"] = 0,
				["Red Spirit"] = 0,
				["Sixth Sense"] = 0
			}
		},
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop at Wave"] = 0
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Wave"] = 1
			},
			["Auto Sell Unit"] = {
				["Wave"] = 15
			}
		},
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 2
		}
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
		["Slot Position"] = {
			["Dungeon"] = {
				["1"] = "1119.8858642578125, 65.97705841064453, -277.6719055175781",
				["3"] = "1013.2261352539062, 70.27705383300781, -63.452396392822266",
				["2"] = "987.7051391601562, 68.8770523071289, -247.6083984375"
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
		},
		["Enable"] = true,
		["Place Wave"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" 
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(1)until Joebiden