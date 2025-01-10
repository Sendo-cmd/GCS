game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Game Finished"] = {
		["Auto Return Lobby"] = true,
		["Auto Replay"] = true
	},
	["Joiner Cooldown"] = 20,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Ignore Upgrade"] = {
			["6"] = true
		},
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Virtual Dungeon"] = "103.89673614501953, 37.418487548828125, 10.653985977172852"
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Present"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Challenge Joiner"] = {
		["Auto Join"] = true,
		["Teleport Lobby new Challenge"] = true,
		["Reward"] = {
			["Star Fruit (Pink)"] = true,
			["Star Fruit (Red)"] = true,
			["Star Fruit (Rainbow)"] = true,
			["Star Fruit (Green)"] = true,
			["Star Fruit (Blue)"] = true,
			["Star Fruit"] = true
		},
		["World"] = {
			["Navy Bay"] = true,
			["Mountain Temple"] = true,
			["Snowy Kingdom"] = true,
			["Virtual Dungeon"] = true,
			["Sand Village"] = true,
			["Fiend City"] = true,
			["Rain Village"] = true,
			["Magic Hills"] = true,
			["Spirit World"] = true,
			["Snowy Town"] = true,
			["Magic Town"] = true,
			["Fabled Kingdom"] = true,
			["Ruined City"] = true,
			["Walled City"] = true,
			["Dungeon Throne"] = true,
			["Alien Spaceship"] = true,
			["Ant Kingdom"] = true,
			["Puppet Island"] = true,
			["Space Center"] = true,
			["Haunted Academy"] = true,
			["Planet Greenie"] = true
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["World Joiner"] = {
		["Act"] = "Infinite",
		["Enable"] = true,
		["World"] = "Planet Greenie"
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Smart Auto Ability"] = {
			["Wind Dragon"] = true,
			["Supreme Being (Sovereign)"] = true,
			["Time Wizard (Chronos)"] = true,
			["Lulu (Emperor)"] = true,
			["Commander"] = true,
			["Delinquent"] = true,
			["Usurper (Founder)"] = true,
			["Fiery Commander (Hellfire)"] = true,
			["JIO (Over Heaven)"] = true,
			["Shadowgirl (Time Traveller)"] = true,
			["Illusionist (Final)"] = true,
			["Trickster (Release)"] = true,
			["Elfy (Sylph)"] = true,
			["Menace (Terror)"] = true,
			["Priest (Heaven)"] = true
		},
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Vote Start"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden