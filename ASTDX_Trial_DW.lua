game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Infinite Joiner"] = {
		["Max Void Bag Action"] = "Do nothing"
	},
	["Trial Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Trial 1"
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
			["Innovation Island"] = true,
			["Future City (Ruins)"] = true,
			["City of Voldstandig"] = true,
			["Hidden Storm Village"] = true
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Macro"] = "Tdw",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true,
		["Play"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Delete Enemies"] = true,
		["Boost FPS"] = true
	},
	["Gameplay"] = {
		["Auto Card"] = {
			["Prioritize"] = {
				["Thunder Step"] = 4,
				["Tsuku & Yomii"] = 0,
				["Arise"] = 0,
				["Red Spirit"] = 5,
				["Revert to Null"] = 0,
				["Binding Vow of Haste"] = 0,
				["Binding Vow of Vitality"] = 0,
				["Binding Vow of Aegis"] = 0,
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
	["Failsafe"] = {
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden