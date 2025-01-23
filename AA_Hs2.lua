game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Joiner Cooldown"] = 0,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Level Milestone"] = true,
		["Auto Claim Present"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Attack I"] = 39,
				["Attack II"] = 31,
				["Attack III"] = 30,
				["Cooldown I"] = 38,
				["Cooldown II"] = 29,
				["Cooldown III"] = 28,
				["Range I"] = 40,
				["Range II"] = 27,
				["Range III"] = 26,
				["Boss Damage I"] = 33,
				["Boss Damage II"] = 25,
				["Boss Damage III"] = 24,
				["New Path"] = 34,
				["Yen I"] = 36,
				["Yen II"] = 23,
				["Yen III"] = 22,
				["Active Cooldown I"] = 35,
				["Active Cooldown II"] = 21,
				["Active Cooldown III"] = 20,
				["Gain 2 Random Effects Tier 1"] = 37,
				["Gain 2 Random Effects Tier 2"] = 19,
				["Gain 2 Random Effects Tier 3"] = 18,
				["Enemy Speed I"] = 4,
				["Enemy Speed II"] = 5,
				["Enemy Speed III"] = 6,
				["Enemy Shield I"] = 7,
				["Enemy Shield II"] = 8,
				["Enemy Shield III"] = 9,
				["Enemy Regen I"] = 14,
				["Enemy Regen II"] = 12,
				["Enemy Regen III"] = 11,
				["Gain 2 Random Curses Tier 1"] = 1,
				["Gain 2 Random Curses Tier 2"] = 2,
				["Gain 2 Random Curses Tier 3"] = 3,
				["Enemy Health I"] = 32,
				["Enemy Health II"] = 17,
				["Enemy Health III"] = 16,
				["Explosive Deaths I"] = 15,
				["Explosive Deaths II"] = 10,
				["Explosive Deaths III"] = 13,
			}
		}
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro"] = "hs2",
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Play"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(7)until Joebiden