game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().EquipMacroUnit = true
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
			["Innovation Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Hidden Storm Village"] = true,
			["Giant Island"] = false,
		},
		["Teleport Lobby new Challenge"] = true
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
		["Auto Vote Start"] = false,
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
	},
	["Auto Play"] = {
		["Auto Upgrade"] = {
			["Enable"] = true,
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
			["City of Voldstandig"] = {
				["1"] = "69.22769165039062, 47.85552978515625, -55.9107666015625",
				["3"] = "110.21363830566406, 47.85552978515625, -88.68482971191406",
				["2"] = "66.7347412109375, 47.85552978515625, -50.512611389160156"
			},
			["Innovation Island"] = {
				["1"] = "-113.25743103027344, 2.9135429859161377, -51.63191604614258",
				["3"] = "-109.16082763671875, 2.9135429859161377, -95.34555053710938",
				["2"] = "-74.1626968383789, 2.9135429859161377, -33.46575164794922"
			}
		},
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = -1,
			["4"] = -1,
			["6"] = -1
		}
	},
	["Macros"] = {
		["Challenge Macro"] = {
			["Innovation Island"] = "GokuCh",
			["City of Voldstandig"] = "GokuCh2",
			["Hidden Storm Village"] = "GokuCh3",
			["Future City (Ruins)"] = "GokuCh4",
			["Giant Island"] = "GokuCh5",
		},
		["Macro Retry Limit"] = 0,
		["Macro"] = "GokuInf",
		["Play"] = false,
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden
