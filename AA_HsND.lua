game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Game Finished"] = {
		["Auto Replay"] = true,
		["Auto Next"] = true
	},
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Ignore Upgrade"] = {
			["6"] = true
		},
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Hill Height"] = {
			["Frozen Abyss"] = 13
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Frozen Abyss"] = "397.54718017578125, 45.9230842590332, 371.5992126464844"
		}
	},
	["Macros"] = {
		["Macro"] = "",
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Level Milestone"] = true,
		["Auto Claim Present"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 50
		},
		["Auto Vote Start"] = true
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Smart Auto Ability"] = {
			["Wind Dragon"] = true,
			["Commander"] = true,
			["Delinquent"] = true,
			["Usurper (Founder)"] = true,
			["Fiery Commander (Hellfire)"] = true,
			["JIO (Over Heaven)"] = true,
			["Shadowgirl (Time Traveller)"] = true,
			["Illusionist (Final)"] = true,
			["Trickster (Release)"] = true,
			["Lulu (Emperor)"] = true,
			["Time Wizard (Chronos)"] = true,
			["Priest (Heaven)"] = true
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
			},
			["Amount"] = {
				["Attack I"] = 0,
				["Attack II"] = 0,
				["Attack III"] = 0,
				["Cooldown I"] = 0,
				["Cooldown II"] = 0,
				["Cooldown III"] = 0,
				["Range I"] = 0,
				["Range II"] = 0,
				["Range III"] = 0,
				["Boss Damage I"] = 0,
				["Boss Damage II"] = 0,
				["Boss Damage III"] = 0,
				["New Path"] = 3,
				["Yen I"] = 1,
				["Yen II"] = 1,
				["Yen III"] = 1,
				["Active Cooldown I"] = 0,
				["Active Cooldown II"] = 0,
				["Active Cooldown III"] = 0,
				["Gain 2 Random Effects Tier 1"] = 0,
				["Gain 2 Random Effects Tier 2"] = 0,
				["Gain 2 Random Effects Tier 3"] = 0,
				["Enemy Speed I"] = 1,
				["Enemy Speed II"] = 1,
				["Enemy Speed III"] = 1,
				["Enemy Shield I"] = 1,
				["Enemy Shield II"] = 1,
				["Enemy Shield III"] = 1,
				["Enemy Regen I"] = 2,
				["Enemy Regen II"] = 2,
				["Enemy Regen III"] = 2,
				["Gain 2 Random Curses Tier 1"] = 1,
				["Gain 2 Random Curses Tier 2"] = 1,
				["Gain 2 Random Curses Tier 3"] = 1,
				["Enemy Health I"] = 6,
				["Enemy Health II"] = 6,
				["Enemy Health III"] = 6,
				["Explosive Deaths I"] = 3,
				["Explosive Deaths II"] = 3,
				["Explosive Deaths III"] = 3,
			}
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden