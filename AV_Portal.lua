game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		}
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Intensity"] = 200,
		["First Team"] = 1,
		["Cash Out Floor"] = 5
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Martial Island"] = {
			["Auto Join God Portal"] = true
		},
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Double Dungeon"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Wave"] = 22
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
		["Edge of Heaven"] = {
			["Auto Join Lfelt Portal"] = true
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
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
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Edge of Heaven"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Ruined City"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Martial Island"] = "Middle",
			["Cavern"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Shining Castle"] = "Middle"
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
			["Edge of Heaven"] = "-39.13007354736328, 147.29444885253906, -186.71127319335938",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Land of the Gods"] = "-158.46160888671875, 1.2214683294296265, 119.30146026611328"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Cavern"] = 2,
			["Sand Village"] = 2,
			["Shining Castle"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Edge of Heaven"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Blood-Red Chamber"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Planet Namak"] = 2,
			["Martial Island"] = 2,
			["Shibuya Aftermath"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Kuinshi Palace"] = 2
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
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true
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
				["Precise Attack"] = 13,
				["Range"] = 18,
				["No Trait No Problem"] = 23,
				["Drowsy"] = 8,
				["Cooldown"] = 19,
				["Exterminator"] = 28,
				["Regen"] = 7,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["King's Burden"] = 27,
				["Lifeline"] = 29,
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
				["Precise Attack"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Spring Portal Joiner"] = {
		["Ignore Act"] = {
			["[Land of the Gods] Act2"] = true,
			["[Land of the Gods] Act3"] = true,
			["[Land of the Gods] Act1"] = true
		},
		["Auto Next"] = true,
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Land of the Gods"] = 1,
				["Planet Namak"] = 3,
				["Edge of Heaven"] = 2
			},
			["Pick Slime Portal"] = true,
			["Enable"] = true
		}
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden