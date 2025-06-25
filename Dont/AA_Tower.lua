game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoExecute"] = true,
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
		["Middle Position"] = {
			["Navy Bay"] = "-2587.32421875, 25.210872650146484, -70.11207580566406",
			["Haunted Academy"] = "365.7239074707031, 125.39739990234375, -100.41999816894531",
			["Sand Village"] = "-865.1871948242188, 25.065471649169922, 268.7599182128906",
			["Fiend City"] = "-2985.3056640625, 58.58513259887695, -47.337257385253906",
			["Rain Village"] = "-84.45005798339844, 4.287006378173828, -13.089836120605469",
			["Puppet Island"] = "24.743732452392578, 2.5999999046325684, -168.9140625",
			["Spirit World"] = "-167.17176818847656, 132.66307067871094, -720.1920166015625",
			["Snowy Town"] = "-2880.7568359375, 34.34697723388672, -130.48460388183594",
			["Magic Town"] = "-630.3657836914062, 6.750755786895752, -815.572998046875",
			["Sacred Planet"] = "-147.88999938964844, 109.94538116455078, 54.260860443115234",
			["Walled City"] = "-3008.836181640625, 33.741798400878906, -689.51318359375",
			["Ruined City"] = "-57.5133056640625, -13.246763229370117, 6.500391483306885",
			["Space Center"] = "-92.60690307617188, 14.903413772583008, -577.234130859375",
			["Alien Spaceship"] = "-327.80615234375, 361.2119445800781, 1428.6864013671875",
			["Ant Kingdom"] = "-137.79991149902344, 23.012638092041016, 3002.900390625",
			["Magic Hills"] = "-112.47105407714844, 1.233101487159729, -45.09272003173828",
			["Frozen Abyss"] = "397.4182434082031, 45.9230842590332, 371.3970642089844",
			["Fabled Kingdom"] = "-99.55257415771484, 212.96109008789062, -207.9711151123047",
			["Planet Greenie"] = "-2938.004150390625, 91.80620574951172, -727.7630615234375"
		},
		["Focus on Farm"] = true
	},
	["Macros"] = {
		["Macro"] = "",
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Infinity Mansion Joiner"] = {
		["Auto Join"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
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
	}
}
getgenv().Key = "PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden