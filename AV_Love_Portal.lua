game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
	},
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Auto Next"] = true,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		},
		["Ignore Act"] = {
			["[Underground Church] Act5"] = false,
			["[Double Dungeon] Act6"] = false,
			["[Double Dungeon] Act4"] = false,
			["[Underground Church] Act4"] = false,
			["[Shibuya Station] Act4"] = false,
			["[Sand Village] Act1"] = false,
			["[Double Dungeon] Act3"] = false,
			["[Shibuya Station] Act3"] = false,
			["[Spirit Society] Act4"] = false,
			["[Shibuya Station] Act5"] = false,
			["[Double Dungeon] Act1"] = false,
			["[Underground Church] Act1"] = false,
			["[Planet Namak] Act2"] = false,
			["[Underground Church] Act3"] = false,
			["[Underground Church] Act2"] = false,
			["[Shibuya Station] Act1"] = false,
			["[Planet Namak] Act1"] = false,
			["[Double Dungeon] Act2"] = false,
			["[Sand Village] Act6"] = false,
			["[Spirit Society] Act1"] = false,
			["[Sand Village] Act5"] = false,
			["[Spirit Society] Act6"] = false,
			["[Sand Village] Act3"] = false,
			["[Spirit Society] Act5"] = false,
			["[Double Dungeon] Act5"] = false,
			["[Spirit Society] Act2"] = false,
			["[Spirit Society] Act3"] = false,
			["[Sand Village] Act4"] = false,
			["[Shibuya Station] Act6"] = false,
			["[Underground Church] Act6"] = false,
			["[Sand Village] Act2"] = false,
			["[Shibuya Station] Act2"] = false,
			["[Planet Namak] Act5"] = false,
			["[Planet Namak] Act3"] = false,
			["[Planet Namak] Act6"] = false,
			["[Planet Namak] Act4"] = false
		},
		["Ignore Modifier"] = {
			["Strong"] = false,
			["Drowsy"] = false,
			["Regen"] = false,
			["Fast"] = false,
			["Revitalize"] = false,
			["Champions"] = false,
			["Exploding"] = false,
			["Dodge"] = false,
			["Immunity"] = false,
			["Shielded"] = false,
			["Quake"] = false,
			["Thrice"] = false
		}
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Battle Pass"] = false,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 22
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		}
	},
	["Misc"] = {
		["Redeem Code"] = true,
	},
	["Modifier"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Fisticuffs"] = 25,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Uncommon Loot"] = 22,
				["Immunity"] = 11,
				["Planning Ahead"] = 15,
				["Harvest"] = 17,
				["Lifeline"] = 29,
				["Precise Attack"] = 13,
				["Drowsy"] = 8,
				["No Trait No Problem"] = 23,
				["Cooldown"] = 19,
				["Exterminator"] = 28,
				["Regen"] = 7,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["King's Burden"] = 27,
				["Range"] = 18,
				["Press It"] = 14,
				["Quake"] = 9,
				["Shielded"] = 5,
				["Slayer"] = 16,
				["Money Surge"] = 26
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Lifeline"] = 0,
				["Precise Attack"] = 0,
				["Drowsy"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Range"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place and Upgrade"] = false,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 2,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Ant Island"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Spirit Society"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Middle Position"] = {
			["Shibuya Aftermath"] = "-94.77557373046875, 316.1539306640625, -34.29759216308594",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Planet Namak"] = "540.7099609375, 2.062572717666626, -365.3252258300781"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Planet Namak"] = 2,
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Double Dungeon"] = 2
		}
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Next"] = true,
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
		}
	},
	["Raid Joiner"] = {
		["Auto Join"] = false
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Crafter"] = {
		["Teleport Lobby full Essence"] = false,
		["Enable"] = false,
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 50,
			["Blue Essence Stone"] = 50,
			["Red Essence Stone"] = 50,
			["Yellow Essence Stone"] = 50,
			["Purple Essence Stone"] = 50
		}
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoExecute"] = true,
	["Joiner Cooldown"] = 0,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden