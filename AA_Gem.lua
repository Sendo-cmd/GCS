game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Placement Type"] = {
			["Otherwordly Plane"] = "Slot Position",
			["Frozen Abyss"] = "Slot Position",
			["Strange Town"] = "Slot Position",
			["Fiend City"] = "Slot Position",
			["Magic Hills"] = "Slot Position",
			["Sky Aircraft"] = "Slot Position",
			["Snowy Town"] = "Slot Position",
			["Alien Spaceship (Underwater)"] = "Slot Position",
			["Fabled Kingdom"] = "Slot Position",
			["Ruined City"] = "Slot Position",
			["Nightmare Train"] = "Slot Position",
			["Alien Spaceship (Final)"] = "Slot Position",
			["Strange Town (Haunted)"] = "Slot Position",
			["Ruined City (Midnight)"] = "Slot Position",
			["Haunted Academy"] = "Slot Position",
			["Anniversary Island"] = "Slot Position",
			["Fabled Kingdom (Cube)"] = "Slot Position",
			["Puppet Island (Threads)"] = "Slot Position",
			["Magic Town"] = "Slot Position",
			["Haunted Academy (Summer)"] = "Slot Position",
			["Alien Spaceship"] = "Slot Position",
			["Storm Hideout"] = "Slot Position",
			["Walled City"] = "Slot Position",
			["Planet Greenie (Haunted)"] = "Slot Position",
			["Navy Bay"] = "Slot Position",
			["Snowy Kingdom"] = "Slot Position",
			["Virtual Dungeon (Bosses)"] = "Slot Position",
			["Sand Village"] = "Slot Position",
			["Ant Kingdom (Summer)"] = "Slot Position",
			["Rain Village"] = "Slot Position",
			["Fabled Kingdom (Summer)"] = "Slot Position",
			["Planet Greenie (Frozen)"] = "Slot Position",
			["Spirit World"] = "Slot Position",
			["Magic Town (Snow)"] = "Slot Position",
			["Sacred Planet"] = "Slot Position",
			["Walled City (Midnight)"] = "Slot Position",
			["Space Center (New Moon)"] = "Slot Position",
			["Storm Hideout (Final)"] = "Slot Position",
			["Haunted Mansion"] = "Slot Position",
			["Haunted Academy (Frozen)"] = "Slot Position",
			["Navy Bay (Midnight)"] = "Slot Position",
			["Sand Village (Snow)"] = "Slot Position",
			["Future City"] = "Slot Position",
			["Spirit Invasion"] = "Slot Position",
			["Future City (Tyrant's Invasion)"] = "Slot Position",
			["Frozen Abyss (Six Realms)"] = "Slot Position",
			["Hellish City"] = "Slot Position",
			["Virtual Dungeon"] = "Middle Position",
			["Fabled Kingdom (Generals)"] = "Slot Position",
			["Magic Hills (Demonic)"] = "Slot Position",
			["Space Center"] = "Slot Position",
			["Mountain Temple"] = "Slot Position",
			["Magic Hills (Elf Invasion)"] = "Slot Position",
			["Wish City"] = "Slot Position",
			["Ruined City (The Menace)"] = "Slot Position",
			["Puppet Island"] = "Slot Position",
			["Fiend City (Winter)"] = "Slot Position",
			["Dungeon Throne"] = "Slot Position",
			["Magic Town (Haunted)"] = "Slot Position",
			["Puppet Island (Summer)"] = "Slot Position",
			["Cursed Festival"] = "Slot Position",
			["Power Contest"] = "Slot Position",
			["Walled City (Summer)"] = "Slot Position",
			["Ant Kingdom"] = "Slot Position",
			["Planet Greenie (Summer)"] = "Slot Position",
			["Walled City (Winter)"] = "Slot Position",
			["Spirit Town"] = "Slot Position",
			["Planet Greenie"] = "Slot Position"
		},
		["Enable"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Auto Fuse Vego-Carrot Anchor"] = "Vego",
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Virtual Dungeon"] = "103.89673614501953, 37.418487548828125, 10.653985977172852"
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Macro"] = "",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
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
		["Auto Claim Level Milestone"] = true,
		["Auto Claim Present"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 25
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden