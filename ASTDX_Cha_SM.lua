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
		["Auto Join"] = true,
		["Max Void Bag Action"] = "Loose game - Auto Open Void Bag can open while in game",
		["Auto Open Void Bag"] = true
	},
	["Secure"] = {
		["Random Offset"] = true
	},
	["Challenge Joiner"] = {
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
			["Innovation Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Giant Island"] = true,
			["Hidden Storm Village"] = true
		},
		["Teleport Lobby new Challenge"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Giant Island"] = "SMCh5",
			["City of Voldstandig"] = "SMCh2",
			["Future City (Ruins)"] = "SMCh4",
			["Innovation Island"] = "SMCh",
			["Hidden Storm Village"] = "SMCh3"
		},
		["Macro Retry Limit"] = 0,
		["Macro"] = "SMInf",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true,
		["Play"] = true
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
				["Wave"] = 1
			}
		},
		["Game Speed"] = {
			["Enable"] = true,
			["Speed"] = 2
		}
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden