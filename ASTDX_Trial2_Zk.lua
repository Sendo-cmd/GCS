game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
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
	["Infinite Joiner"] = {
		["Max Void Bag Action"] = "Do nothing"
	},
	["Trial Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Trial 2"
	},
	["Secure"] = {
		["Random Offset"] = true
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
			["Giant Island"] = true,
			["City of Voldstandig"] = true,
			["Future City (Ruins)"] = true,
			["Innovation Island"] = true,
			["Hidden Storm Village"] = true
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Macro"] = "Tzk",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true,
		["Play"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = {
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			},
			["Upgrade Method"] = "Hotbar left to right (until Max)"
		},
		["Place Limit"] = {
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
		["Place Wave"] = {
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
			["Enable"] = true,
			["Prioritize"] = {
				["Binding Vow of Vitality"] = 1,
				["Tsuku & Yomii"] = 2,
				["Arise"] = 3,
				["Red Spirit"] = 9,
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
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop at Wave"] = 0
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Wave"] = 1
			},
			["Auto Sell Unit"] = {
				["Wave"] = 1
			}
		},
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 3
		}
	},
	["Match Finished"] = {
		["Return Lobby Failsafe"] = true,
		["Auto Replay"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden