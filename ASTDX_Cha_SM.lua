game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
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
	["Secure"] = {
		["Random Offset"] = true
	},
	["Challenge Joiner"] = {
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
			["Skill Orb I (Purple)"] = true,
			["Skill Orb II (Orange)"] = true,
			["Ghost I (Rainbow)"] = true,
			["Skill Orb I (Blue)"] = true,
			["Skill Orb II (Green)"] = true,
			["Skill Orb II (Red)"] = true,
			["Ghost III (Rainbow)"] = true,
			["Skill Orb II (Blue)"] = true,
			["Skill Orb I (Red)"] = true,
			["Skill Orb I (Green)"] = true,
			["Stat Dice"] = false,
			["Skill Orb I (Orange)"] = true,
			["Skill Orb II (Pure)"] = true,
			["Skill Orb I (Pure)"] = true,
			["Trait Burner"] = true,
			["Ghost II (Rainbow)"] = true,
			["Skill Orb II (Purple)"] = true
		},
		["Stage"] = {
			["Giant Island"] = true,
			["City of Voldstandig"] = true,
			["Future City (Ruins)"] = true,
			["Innovation Island"] = true,
			["Hidden Storm Village"] = true
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Innovation Island"] = "SMCh",
			["Future City (Ruins)"] = "SMCh4",
			["City of Voldstandig"] = "SMCh2",
			["Giant Island"] = "SMCh5",
			["Hidden Storm Village"] = "SMCh3"
		},
		["Macro"] = "SMInf",
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Play"] = true,
		["Ignore Macro Timing"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Prioritize"] = {
				["Binding Vow of Vitality"] = 1,
				["Tsuku & Yomii"] = 2,
				["Revert to Null"] = 4,
				["Binding Vow of Aegis"] = 7,
				["Arise"] = 3,
				["Binding Vow of Haste"] = 6,
				["Thunder Step"] = 5,
				["Red Spirit"] = 8,
				["Sixth Sense"] = 9
			},
			["Amount"] = {
				["Binding Vow of Vitality"] = 0,
				["Tsuku & Yomii"] = 0,
				["Revert to Null"] = 0,
				["Binding Vow of Aegis"] = 0,
				["Arise"] = 0,
				["Binding Vow of Haste"] = 0,
				["Thunder Step"] = 0,
				["Red Spirit"] = 0,
				["Sixth Sense"] = 0
			}
		},
		["Auto Vote Start"] = true,
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
		["Auto Replay"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden