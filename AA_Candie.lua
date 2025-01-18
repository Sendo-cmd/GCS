game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Nearest from Middle Position (until Max)",
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
				["Boss Damage III"] = 83,
				["Enemy Health III"] = 40,
				["New Path"] = 100,
				["Yen II"] = 35,
				["Attack III"] = 95,
				["Enemy Speed II"] = 1,
				["Gain 2 Random Effects Tier 2"] = 91,
				["Range III"] = 98,
				["Cooldown I"] = 87,
				["Active Cooldown III"] = 86,
				["Explosive Deaths III"] = 78,
				["Cooldown II"] = 38,
				["Explosive Deaths II"] = 77,
				["Yen III"] = 36,
				["Enemy Speed III"] = 3,
				["Enemy Speed I"] = 0,
				["Active Cooldown II"] = 85,
				["Gain 2 Random Effects Tier 1"] = 90,
				["Active Cooldown I"] = 84,
				["Range II"] = 97,
				["Enemy Shield II"] = 8,
				["Gain 2 Random Curses Tier 1"] = 4,
				["Enemy Health II"] = 39,
				["Yen I"] = 34,
				["Boss Damage II"] = 82,
				["Double Attack"] = 99,
				["Explosive Deaths I"] = 76,
				["Gain 2 Random Curses Tier 3"] = 6,
				["Enemy Shield I"] = 7,
				["Enemy Health I"] = 80,
				["Gain 2 Random Effects Tier 3"] = 92,
				["Enemy Regen I"] = 33,
				["Enemy Shield III"] = 9,
				["Boss Damage I"] = 81,
				["Cooldown III"] = 89,
				["Enemy Regen III"] = 2,
				["Gain 2 Random Curses Tier 2"] = 5,
				["Attack II"] = 94,
				["Enemy Regen II"] = 32,
				["Attack I"] = 93,
				["Range I"] = 96
			},
			["Amount"] = {
				["Boss Damage III"] = 0,
				["Enemy Health III"] = 0,
				["New Path"] = 0,
				["Yen II"] = 1,
				["Attack III"] = 0,
				["Enemy Speed II"] = 1,
				["Gain 2 Random Effects Tier 2"] = 0,
				["Range III"] = 0,
				["Cooldown I"] = 0,
				["Active Cooldown III"] = 0,
				["Explosive Deaths III"] = 3,
				["Cooldown II"] = 0,
				["Explosive Deaths II"] = 3,
				["Yen III"] = 1,
				["Enemy Speed III"] = 1,
				["Enemy Speed I"] = 1,
				["Active Cooldown II"] = 0,
				["Gain 2 Random Effects Tier 1"] = 0,
				["Active Cooldown I"] = 0,
				["Range II"] = 0,
				["Enemy Shield II"] = 1,
				["Gain 2 Random Curses Tier 1"] = 1,
				["Enemy Health II"] = 0,
				["Yen I"] = 1,
				["Boss Damage II"] = 0,
				["Double Attack"] = 0,
				["Enemy Shield I"] = 1,
				["Gain 2 Random Curses Tier 3"] = 1,
				["Explosive Deaths I"] = 3,
				["Enemy Health I"] = 0,
				["Gain 2 Random Effects Tier 3"] = 0,
				["Enemy Regen I"] = 1,
				["Enemy Shield III"] = 1,
				["Boss Damage I"] = 0,
				["Cooldown III"] = 0,
				["Enemy Regen III"] = 1,
				["Gain 2 Random Curses Tier 2"] = 1,
				["Attack II"] = 0,
				["Enemy Regen II"] = 1,
				["Attack I"] = 0,
				["Range I"] = 0
			}
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden