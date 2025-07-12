game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Macro Equipper"] = {
			["Enable"] = true
		},
		["Team Equipper"] = {
			["Enable"] = true,
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
	["Dungeon Joiner"] = {
		["Teleport Lobby Dungeon spawned"] = true,
		["Auto Join"] = true,
		["Instant Teleport Lobby Dungeon spawned"] = true
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
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Innovation Island"] = true,
			["Hidden Storm Village"] = true
		}
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
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
		["Return Lobby Failsafe"] = true,
		["Auto Replay"] = true
	},
	["Macros"] = {
		["Dungeon Macro"] = {
			["Dungeon"] = "DgDw"
		},
		["No Ignore Sell Timing"] = true,
		["Macro"] = "DWInf",
		["Ignore Macro Timing"] = true,
		["Play"] = true,
		["Macro Retry Limit"] = 0
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden