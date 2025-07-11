game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Infinite Joiner"] = {
		["Auto Join"] = true,
		["Max Void Bag Action"] = "Loose game - Auto Open Void Bag can open while in game",
		["Auto Open Void Bag"] = true
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Random Offset"] = true
	},
	["Challenge Joiner"] = {
		["Auto Join"] = true,
		["Modifier"] = {
			["Flying Enemies"] = true,
			["Juggernaut Enemies"] = true,
			["Unsellable"] = true,
			["High Cost"] = true,
			["Random Units"] = true,
			["Single Placement"] = true
		},
		["Teleport Lobby new Challenge"] = true,
		["Stage"] = {
			["Innovation Island"] = true,
			["City of Voldstandig"] = true,
			["Future City (Ruins)"] = true,
			["Hidden Storm Village"] = true
		},
		["Reward"] = {
			["Bounded Cube"] = true,
			["Skill Orb I (Purple)"] = true,
			["Skill Orb II (Orange)"] = true,
			["Ghost I (Rainbow)"] = true,
			["Skill Orb I (Blue)"] = true,
			["Skill Orb II (Green)"] = true,
			["Skill Orb II (Pure)"] = true,
			["Ghost III (Rainbow)"] = true,
			["Skill Orb II (Blue)"] = true,
			["Skill Orb I (Red)"] = true,
			["Ghost II (Rainbow)"] = true,
			["Stat Dice"] = true,
			["Skill Orb I (Orange)"] = true,
			["Skill Orb II (Red)"] = true,
			["Skill Orb I (Pure)"] = true,
			["Trait Burner"] = true,
			["Skill Orb I (Green)"] = true,
			["Skill Orb II (Purple)"] = true
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Innovation Island"] = "GokuCh",
			["City of Voldstandig"] = "GokuCh2",
			["Hidden Storm Village"] = "GokuCh3"
		},
		["No Ignore Sell Timing"] = true,
		["Macro"] = "GokuInf",
		["Ignore Macro Timing"] = true,
		["Play"] = true,
		["Macro Retry Limit"] = 0
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