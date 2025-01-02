game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
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
		["Auto Claim Level Milestone"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
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
			["Prioritize"] = {
				["Boss Damage III"] = 18,
				["Enemy Health III"] = 30,
				["New Path"] = 34,
				["Yen II"] = 14,
				["Attack III"] = 3,
				["Enemy Speed II"] = 26,
				["Gain 2 Random Effects Tier 2"] = 20,
				["Range I"] = 4,
				["Cooldown I"] = 7,
				["Active Cooldown III"] = 12,
				["Explosive Deaths III"] = 37,
				["Cooldown II"] = 8,
				["Enemy Shield I"] = 22,
				["Yen III"] = 15,
				["Enemy Speed III"] = 27,
				["Enemy Speed I"] = 25,
				["Active Cooldown II"] = 11,
				["Gain 2 Random Effects Tier 1"] = 19,
				["Active Cooldown I"] = 10,
				["Enemy Regen II"] = 32,
				["Enemy Shield II"] = 23,
				["Gain 2 Random Curses Tier 1"] = 38,
				["Enemy Regen III"] = 33,
				["Yen I"] = 13,
				["Boss Damage II"] = 17,
				["Boss Damage I"] = 16,
				["Gain 2 Random Curses Tier 3"] = 40,
				["Gain 2 Random Effects Tier 3"] = 21,
				["Enemy Health I"] = 28,
				["Attack II"] = 2,
				["Explosive Deaths II"] = 36,
				["Enemy Shield III"] = 24,
				["Attack I"] = 1,
				["Cooldown III"] = 9,
				["Enemy Regen I"] = 31,
				["Gain 2 Random Curses Tier 2"] = 39,
				["Explosive Deaths I"] = 35,
				["Range II"] = 5,
				["Enemy Health II"] = 29,
				["Range III"] = 6
			}
		}
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro"] = "hsnd2",
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Play"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden