game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["No Ignore Sell Timing"] = true
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Intensity"] = 200,
		["Cash Out Floor"] = 5,
		["First Team"] = 1
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Double Dungeon"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Wave"] = 15
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["Shibuya Station"] = {
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 0
		},
		["Ruined City"] = {
			["Use Mount to Travel"] = true
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Bear"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		}
	},
	["Misc"] = {
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["Champions"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 99,
				["Fast"] = 1,
				["Planning Ahead"] = 15,
				["Immunity"] = 98,
				["Exploding"] = 0,
				["Dodge"] = 10,
				["Slayer"] = 16,
				["Fisticuffs"] = 25,
				["Revitalize"] = 95,
				["Harvest"] = 17,
				["Quake"] = 9,
				["Range"] = 18,
				["Lifeline"] = 29,
				["No Trait No Problem"] = 23,
				["Regen"] = 7,
				["King's Burden"] = 27,
				["Exterminator"] = 28,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Cooldown"] = 19,
				["Drowsy"] = 8,
				["Press It"] = 14,
				["Precise Attack"] = 13,
				["Shielded"] = 5,
				["Uncommon Loot"] = 22,
				["Money Surge"] = 26
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 1,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Planet Namak (Spring)"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Outer Walls"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Shining Castle"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Ruined City"] = "Middle",
			["Lebereo Raid"] = "Middle",
			["Edge of Heaven"] = "Middle",
			["Martial Island"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Cavern"] = "Middle",
			["Crystal Chapel"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 8,
			["6"] = -1
		},
		["Middle Position"] = {
			["Shibuya Aftermath"] = "-94.77557373046875, 316.1539306640625, -34.29759216308594",
			["Edge of Heaven"] = "-39.13007354736328, 147.29444885253906, -186.71127319335938",
			["Crystal Chapel"] = "-556.1941528320312, 30.782445907592773, -40.25992965698242",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Land of the Gods"] = "-158.46160888671875, 1.2214683294296265, 119.30146026611328"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Planet Namak (Spring)"] = 2,
			["Double Dungeon"] = 2,
			["Blood-Red Chamber"] = 2,
			["Outer Walls"] = 2,
			["Sand Village"] = 2,
			["Shining Castle"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Edge of Heaven"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Kuinshi Palace"] = 2,
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Lebereo Raid"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Cavern"] = 2,
			["Martial Island"] = 2,
			["Planet Namak"] = 2,
			["Crystal Chapel"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Shibuya Aftermath"] = 2
		}
	},
	["Match Finished"] = {
		["Replay Amount"] = 0,
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Crafter"] = {
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
	["Joiner Cooldown"] = 0,
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Spring Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Edge of Heaven"] = 1,
				["Planet Namak"] = 20,
				["Land of the Gods"] = 1
			},
			["Enable"] = true
		},
		["Auto Next"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden