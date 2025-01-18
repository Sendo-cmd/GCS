game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Summoner"] = {
		["Exchange Legacy Gem"] = 0
	},
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Macro"] = ""
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Auto Fuse Vego-Carrot Anchor"] = "Vego",
		["Enable"] = true,
		["Placement Type"] = {
			["Otherwordly Plane"] = "Middle Position",
			["Frozen Abyss"] = "Middle Position",
			["Virtual Dungeon"] = "Middle Position",
			["Fiend City"] = "Middle Position",
			["Magic Hills"] = "Middle Position",
			["Sky Aircraft"] = "Middle Position",
			["Snowy Town"] = "Middle Position",
			["Alien Spaceship (Underwater)"] = "Middle Position",
			["Fabled Kingdom"] = "Middle Position",
			["Ruined City"] = "Middle Position",
			["Nightmare Train"] = "Middle Position",
			["Alien Spaceship (Final)"] = "Middle Position",
			["Power Contest"] = "Middle Position",
			["Ruined City (Midnight)"] = "Middle Position",
			["Mountain Temple"] = "Middle Position",
			["Anniversary Island"] = "Middle Position",
			["Fabled Kingdom (Cube)"] = "Middle Position",
			["Puppet Island (Threads)"] = "Middle Position",
			["Magic Town"] = "Middle Position",
			["Haunted Academy (Summer)"] = "Middle Position",
			["Alien Spaceship"] = "Middle Position",
			["Storm Hideout"] = "Middle Position",
			["Walled City"] = "Middle Position",
			["Planet Greenie (Haunted)"] = "Middle Position",
			["Navy Bay"] = "Middle Position",
			["Snowy Kingdom"] = "Middle Position",
			["Virtual Dungeon (Bosses)"] = "Middle Position",
			["Sand Village"] = "Middle Position",
			["Ant Kingdom (Summer)"] = "Middle Position",
			["Rain Village"] = "Middle Position",
			["Fabled Kingdom (Summer)"] = "Middle Position",
			["Planet Greenie (Frozen)"] = "Middle Position",
			["Spirit World"] = "Middle Position",
			["Magic Town (Snow)"] = "Middle Position",
			["Sacred Planet"] = "Middle Position",
			["Cursed Festival"] = "Middle Position",
			["Space Center (New Moon)"] = "Middle Position",
			["Storm Hideout (Final)"] = "Middle Position",
			["Puppet Island"] = "Middle Position",
			["Haunted Academy (Frozen)"] = "Middle Position",
			["Future City"] = "Middle Position",
			["Sand Village (Snow)"] = "Middle Position",
			["Planet Greenie (Summer)"] = "Middle Position",
			["Spirit Invasion"] = "Middle Position",
			["Future City (Tyrant's Invasion)"] = "Middle Position",
			["Haunted Mansion"] = "Middle Position",
			["Hellish City"] = "Middle Position",
			["Strange Town"] = "Middle Position",
			["Space Center"] = "Middle Position",
			["Magic Hills (Demonic)"] = "Middle Position",
			["Haunted Academy"] = "Middle Position",
			["Dungeon Throne"] = "Middle Position",
			["Magic Hills (Elf Invasion)"] = "Middle Position",
			["Wish City"] = "Middle Position",
			["Fabled Kingdom (Generals)"] = "Middle Position",
			["Strange Town (Haunted)"] = "Middle Position",
			["Fiend City (Winter)"] = "Middle Position",
			["Magic Town (Haunted)"] = "Middle Position",
			["Frozen Abyss (Six Realms)"] = "Middle Position",
			["Puppet Island (Summer)"] = "Middle Position",
			["Walled City (Midnight)"] = "Middle Position",
			["Navy Bay (Midnight)"] = "Middle Position",
			["Ruined City (The Menace)"] = "Middle Position",
			["Ant Kingdom"] = "Middle Position",
			["Walled City (Summer)"] = "Middle Position",
			["Walled City (Winter)"] = "Middle Position",
			["Spirit Town"] = "Middle Position",
			["Planet Greenie"] = "Middle Position"
		},
		["Focus on Farm"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Middle Position"] = {
			["Frozen Abyss"] = "397.51739501953125, 45.9230842590332, 371.7861633300781"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Distance Threshold"] = {
			["Otherwordly Plane"] = 15,
			["Frozen Abyss"] = 5,
			["Virtual Dungeon"] = 15,
			["Fiend City"] = 15,
			["Magic Hills"] = 15,
			["Sky Aircraft"] = 15,
			["Snowy Town"] = 15,
			["Alien Spaceship (Underwater)"] = 15,
			["Fabled Kingdom"] = 15,
			["Ruined City"] = 15,
			["Nightmare Train"] = 15,
			["Alien Spaceship (Final)"] = 15,
			["Strange Town (Haunted)"] = 15,
			["Ruined City (The Menace)"] = 15,
			["Haunted Academy"] = 15,
			["Anniversary Island"] = 15,
			["Fabled Kingdom (Cube)"] = 15,
			["Puppet Island (Threads)"] = 15,
			["Magic Town"] = 15,
			["Haunted Academy (Summer)"] = 15,
			["Alien Spaceship"] = 15,
			["Storm Hideout"] = 15,
			["Walled City"] = 15,
			["Planet Greenie (Haunted)"] = 15,
			["Navy Bay"] = 15,
			["Snowy Kingdom"] = 15,
			["Hellish City"] = 15,
			["Sand Village"] = 15,
			["Ant Kingdom (Summer)"] = 15,
			["Rain Village"] = 15,
			["Fabled Kingdom (Summer)"] = 15,
			["Planet Greenie (Frozen)"] = 15,
			["Spirit World"] = 15,
			["Magic Town (Snow)"] = 15,
			["Sacred Planet"] = 15,
			["Walled City (Midnight)"] = 15,
			["Space Center (New Moon)"] = 15,
			["Storm Hideout (Final)"] = 15,
			["Puppet Island"] = 15,
			["Haunted Academy (Frozen)"] = 15,
			["Future City"] = 15,
			["Sand Village (Snow)"] = 15,
			["Planet Greenie (Summer)"] = 15,
			["Spirit Invasion"] = 15,
			["Future City (Tyrant's Invasion)"] = 15,
			["Haunted Mansion"] = 15,
			["Virtual Dungeon (Bosses)"] = 15,
			["Strange Town"] = 15,
			["Space Center"] = 15,
			["Magic Hills (Demonic)"] = 15,
			["Ruined City (Midnight)"] = 15,
			["Dungeon Throne"] = 15,
			["Magic Hills (Elf Invasion)"] = 15,
			["Wish City"] = 15,
			["Fabled Kingdom (Generals)"] = 15,
			["Power Contest"] = 15,
			["Fiend City (Winter)"] = 15,
			["Magic Town (Haunted)"] = 15,
			["Frozen Abyss (Six Realms)"] = 15,
			["Puppet Island (Summer)"] = 15,
			["Cursed Festival"] = 15,
			["Navy Bay (Midnight)"] = 15,
			["Mountain Temple"] = 15,
			["Ant Kingdom"] = 15,
			["Walled City (Summer)"] = 15,
			["Walled City (Winter)"] = 15,
			["Spirit Town"] = 15,
			["Planet Greenie"] = 15
		},
		["Place Gap"] = {
			["Frozen Abyss"] = 1.4
		}
	},
	["Holiday Hunt Joiner"] = {
		["Auto Join"] = true,
		["Join Solo"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Present"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Smart Auto Ability"] = {
			["Wind Dragon"] = true,
			["Elfy (Sylph)"] = true,
			["Supreme Being (Sovereign)"] = true,
			["Time Wizard (Chronos)"] = true,
			["Menace (Terror)"] = true,
			["Commander"] = true,
			["Delinquent"] = true,
			["Usurper (Founder)"] = true,
			["Fiery Commander (Hellfire)"] = true,
			["JIO (Over Heaven)"] = true,
			["Shadowgirl (Time Traveller)"] = true,
			["Illusionist (Final)"] = true,
			["Trickster (Release)"] = true,
			["Lulu (Emperor)"] = true,
			["Infinite buff rotation delay"] = 15.9,
			["Priest (Heaven)"] = true
		},
		["Auto Leave"] = {
			["Wave"] = 1
		},
		["Auto Vote Start"] = true,
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Boss Damage III"] = 75,
				["Enemy Health III"] = 70,
				["New Path"] = 100,
				["Yen II"] = 40,
				["Attack III"] = 36,
				["Enemy Speed II"] = 1,
				["Gain 2 Random Effects Tier 2"] = 88,
				["Range III"] = 39,
				["Cooldown I"] = 93,
				["Active Cooldown III"] = 79,
				["Explosive Deaths III"] = 21,
				["Cooldown II"] = 89,
				["Explosive Deaths II"] = 20,
				["Yen III"] = 41,
				["Enemy Speed III"] = 0,
				["Enemy Speed I"] = 2,
				["Active Cooldown II"] = 87,
				["Gain 2 Random Effects Tier 1"] = 96,
				["Active Cooldown I"] = 92,
				["Range II"] = 91,
				["Enemy Shield II"] = 4,
				["Gain 2 Random Curses Tier 1"] = 9,
				["Enemy Health II"] = 80,
				["Yen I"] = 86,
				["Boss Damage II"] = 87,
				["Double Attack"] = 99,
				["Explosive Deaths I"] = 94,
				["Gain 2 Random Curses Tier 3"] = 8,
				["Enemy Shield I"] = 5,
				["Enemy Health I"] = 95,
				["Gain 2 Random Effects Tier 3"] = 15,
				["Enemy Regen I"] = 10,
				["Enemy Shield III"] = 3,
				["Boss Damage I"] = 78,
				["Cooldown III"] = 9,
				["Enemy Regen III"] = 11,
				["Gain 2 Random Curses Tier 2"] = 7,
				["Attack II"] = 90,
				["Enemy Regen II"] = 12,
				["Attack I"] = 97,
				["Range I"] = 98
			},
			["Amount"] = {
				["Boss Damage III"] = 0,
				["Enemy Health III"] = 0,
				["New Path"] = 0,
				["Yen II"] = 1,
				["Attack I"] = 0,
				["Enemy Speed II"] = 1,
				["Gain 2 Random Effects Tier 2"] = 0,
				["Range I"] = 0,
				["Cooldown I"] = 0,
				["Active Cooldown III"] = 0,
				["Explosive Deaths III"] = 0,
				["Cooldown II"] = 0,
				["Explosive Deaths II"] = 0,
				["Yen III"] = 1,
				["Enemy Speed III"] = 1,
				["Enemy Speed I"] = 1,
				["Active Cooldown II"] = 0,
				["Gain 2 Random Effects Tier 1"] = 0,
				["Active Cooldown I"] = 0,
				["Enemy Regen II"] = 1,
				["Enemy Shield II"] = 0,
				["Gain 2 Random Curses Tier 1"] = 1,
				["Enemy Health II"] = 0,
				["Yen I"] = 1,
				["Boss Damage II"] = 0,
				["Double Attack"] = 0,
				["Enemy Shield I"] = 1,
				["Gain 2 Random Curses Tier 3"] = 1,
				["Enemy Health I"] = 0,
				["Gain 2 Random Effects Tier 3"] = 0,
				["Explosive Deaths I"] = 0,
				["Enemy Regen I"] = 2,
				["Enemy Shield III"] = 0,
				["Boss Damage I"] = 0,
				["Cooldown III"] = 0,
				["Enemy Regen III"] = 1,
				["Gain 2 Random Curses Tier 2"] = 1,
				["Attack II"] = 0,
				["Range II"] = 0,
				["Attack III"] = 0,
				["Range III"] = 0
			}
		},
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 50
		}
	},
	["Joiner Cooldown"] = 0
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(7)until Joebiden