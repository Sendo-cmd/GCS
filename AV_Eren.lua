game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Team Equipper"] = {
			["Auto Join Team"] = {
				["Boss Event Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Limitless Odyssey Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		}
	},
	["AutoSave"] = true,
	["Macros"] = {
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Boss Event Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Intensity"] = 200,
		["Cash Out Floor"] = 5,
		["First Team"] = 1
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Auto Use Ability"] = true,
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
		["Ruined City"] = {
			["Use Mount to Travel"] = true
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Steel"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Shibuya Station"] = {
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 0
		}
	},
	["Misc"] = {
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 1,
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
			["Shining Castle"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
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
			["Ant Island"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Middle Position"] = {
			["Shibuya Aftermath"] = "-94.77557373046875, 316.1539306640625, -34.29759216308594",
			["Edge of Heaven"] = "-39.13007354736328, 147.29444885253906, -186.71127319335938",
			["Crystal Chapel"] = "-536.501220703125, 30.782445907592773, -39.956817626953125",
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
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Edge of Heaven"] = 2,
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
	["AutoExecute"] = true,
	["Legend Stage Joiner"] = {
		["Stage"] = "Crystal Chapel",
		["Act"] = "Act3"
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 3
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true
	},
	["Limitless Odyssey Joiner"] = {
		["Leave Floor"] = 1,
		["Intensity"] = 25
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Joiner Cooldown"] = 0,
	["Modifier"] = {
		["Restart Modifier"] = {
			["Modifier"] = {
				["Immunity"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 97,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 100,
				["Immunity"] = 0,
				["Exploding"] = 98,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
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