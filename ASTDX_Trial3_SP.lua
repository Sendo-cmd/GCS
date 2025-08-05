game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Macro Equipper"] = {
			["Enable"] = false
		},
		["Team Equipper"] = {
			["Enable"] = false,
			["Auto Join Team"] = {
				["Daily Challenge Joiner"] = 0,
				["Challenge Joiner"] = 0,
				["Infinite Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Story Joiner"] = 0,
				["Trial Joiner"] = 0,
				["Dungeon Joiner"] = 0
			}
		}
	},
	["Misc"] = {
		["Auto Basic Capsule"] = false,
		["Auto Summer Firework"] = false,
		["Auto Royal Drops"] = false
	},
	["Story Joiner"] = {
		["Hard Mode"] = false,
		["Auto Join"] = false,
		["Auto Open Story Loot"] = false
	},
	["Joiner Cooldown"] = 0,
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
			["Place and Upgrade"] = false,
			["Enable"] = false,
			["Focus on Farm"] = false,
			["Upgrade Method"] = "Hotbar left to right (until Max)",
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			}
		},
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = false,
		["Place Order"] = {
			["1"] = 1,
			["3"] = 3,
			["2"] = 2,
			["5"] = 5,
			["4"] = 4,
			["6"] = 6
		},
		["Place Wave"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		}
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
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
		["Max Void Bag Action"] = "Do nothing",
		["Auto Join"] = false,
		["Auto Open Void Bag"] = false
	},
	["Raid Joiner"] = {
		["Find Team"] = false,
		["Strategist Mode"] = false,
		["Auto Join"] = false,
		["Element"] = {
			["Blue"] = true,
			["Green"] = true,
			["Red"] = true,
			["Orange"] = true,
			["Purple"] = true
		}
	},
	["Macros"] = {
		["Auto Equip"] = true,
		["Macro"] = "Tsp",
		["Ignore Macro Timing"] = true,
		["Macro Retry Limit"] = 0,
		["Play"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = false
	},
	["Dungeon Joiner"] = {
		["Auto Open Dungeon Loot"] = false,
		["Teleport Lobby Dungeon spawned"] = false,
		["Auto Join"] = false,
		["Instant Teleport Lobby Dungeon spawned"] = false
	},
	["Trial Joiner"] = {
		["Stage"] = "Trial 3",
		["Strategist Mode"] = false,
		["Auto Join"] = true,
		["Arc"] = "Arc 2"
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Challenge Joiner"] = {
		["Expert Mode"] = false,
		["Auto Join"] = false,
		["Modifier"] = {
			["Flying Enemies"] = true,
			["Juggernaut Enemies"] = true,
			["Unsellable"] = true,
			["High Cost"] = true,
			["Random Units"] = true,
			["Single Placement"] = true
		},
		["Teleport Lobby new Challenge"] = false,
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
			["Skill Orb I (Green)"] = 0,
			["Stat Dice"] = 0,
			["Skill Orb I (Orange)"] = 0,
			["Skill Orb II (Red)"] = 0,
			["Trait Burner"] = 0,
			["Skill Orb I (Pure)"] = 0,
			["Ghost II (Rainbow)"] = 0,
			["Skill Orb II (Purple)"] = 0
		},
		["Stage"] = {
			["Giant Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Innovation Island"] = true,
			["City of York"] = true,
			["Hidden Storm Village"] = true
		},
		["Reward"] = {
			["Bounded Cube"] = false,
			["Skill Orb I (Purple)"] = false,
			["Skill Orb II (Orange)"] = false,
			["Ghost I (Rainbow)"] = false,
			["Skill Orb I (Blue)"] = false,
			["Skill Orb II (Green)"] = false,
			["Skill Orb II (Pure)"] = false,
			["Ghost III (Rainbow)"] = false,
			["Skill Orb II (Blue)"] = false,
			["Skill Orb I (Red)"] = false,
			["Skill Orb I (Green)"] = false,
			["Stat Dice"] = false,
			["Skill Orb I (Orange)"] = false,
			["Skill Orb II (Red)"] = false,
			["Trait Burner"] = false,
			["Skill Orb I (Pure)"] = false,
			["Ghost II (Rainbow)"] = false,
			["Skill Orb II (Purple)"] = false
		}
	},
	["Transform"] = {
		["Auto Transform Ghost Egg"] = {
			["Enable"] = false,
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Red"] = true,
				["Orange"] = true,
				["Purple"] = true
			}
		},
		["Auto Transform Skill Orb Pure"] = {
			["Enable"] = false,
			["Transform Color"] = {
				["Blue"] = true,
				["Green"] = true,
				["Red"] = true,
				["Orange"] = true,
				["Purple"] = true
			}
		},
		["Auto Transform EXP"] = false,
		["Auto Transform Ghost Rainbow"] = false
	},
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Binding Vow of Vitality"] = 1,
				["Tsuku & Yomii"] = 2,
				["Arise"] = 3,
				["Red Spirit"] = 8,
				["Revert to Null"] = 4,
				["Binding Vow of Haste"] = 6,
				["Thunder Step"] = 9,
				["Binding Vow of Aegis"] = 7,
				["Sixth Sense"] = 10
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
		["Auto Teleport to Enemies"] = false,
		["Teleport Priority"] = "First",
		["Auto Vote Start"] = false,
		["Auto Infinite Buff"] = {
			["Xero"] = false,
			["King Kaoe"] = false,
			["Onwin"] = false
		},
		["Auto Skip Wave"] = {
			["Enable"] = false,
			["Stop at Wave"] = 0
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = false,
				["Wave"] = 1
			},
			["Auto Sell Unit"] = {
				["Enable"] = false,
				["Wave"] = 1
			}
		},
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 2
		}
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = false,
		["Expert Mode"] = false
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Black Screen"] = false,
		["Boost FPS"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden