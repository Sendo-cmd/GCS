game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
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
		["Random Offset"] = true,
		["Walk Around"] = false
	},
	["Claimer"] = {
		["Auto Claim Daily Rewards"] = true,
		["Auto Claim Tasks"] = false
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
			["City of Voldstandig"] = true,
			["Future City (Ruins)"] = true,
			["Hidden Storm Village"] = true
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Play"] = false,
		["Macro"] = "DWInf"
	},
	["Auto Play"] = {
		["Enable"] = true,
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
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
			["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		}
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
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden