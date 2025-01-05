game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Randomize",
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Walled City (Midnight)"] = "-2975.684326171875, 33.741798400878906, -692.74560546875",
			["Strange Town (Haunted)"] = "-594.7011108398438, 32.403968811035156, -133.05189514160156",
			["Planet Greenie (Haunted)"] = "-2936.037109375, 91.80620574951172, -721.120849609375",
			["Navy Bay (Midnight)"] = "-2587.32421875, 25.210872650146484, -70.11207580566406",
			["Magic Town (Haunted)"] = "-627.0025024414062, 6.752476215362549, -807.8677978515625"
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Accept Daily Mission"] = true,
		["Auto Claim Level Milestone"] = true,
		["Auto Claim Present"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
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
			}
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden