game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Team Equipper"] = {
			["Auto Join Team"] = {
				["Challenge Joiner"] = 0,
				["Infinite Joiner"] = 0,
				["Story Joiner"] = 0,
				["Trial Joiner"] = 0,
				["Dungeon Joiner"] = 0
			}
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
	["Infinite Joiner"] = {
		["Max Void Bag Action"] = "Do nothing"
	},
	["Trial Joiner"] = {
		["Stage"] = "Trial 2",
		["Auto Join"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
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
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = true
	},
	["Macros"] = {
		["Macro"] = "Tzk",
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Play"] = true,
		["Auto Equip"] = true,
		["Ignore Macro Timing"] = true
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
		["Place Wave"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Place Order"] = {
			["1"] = 1,
			["3"] = 3,
			["2"] = 2,
			["5"] = 5,
			["4"] = 4,
			["6"] = 6
		},
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		}
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Prioritize"] = {
				["Thunder Step"] = 9,
				["Tsuku & Yomii"] = 2,
				["Arise"] = 3,
				["Red Spirit"] = 9,
				["Revert to Null"] = 4,
				["Binding Vow of Haste"] = 6,
				["Binding Vow of Vitality"] = 1,
				["Binding Vow of Aegis"] = 7,
				["Sixth Sense"] = 10
			},
			["Enable"] = true,
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
				["Wave"] = 1
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
	["Match Finished"] = {
		["Return Lobby Failsafe"] = true,
		["Auto Replay"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" 
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(1)until Joebiden