game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Legend Stage Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["No Ignore Sell Timing"] = true
	},
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		}
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Winter Portal Joiner"] = {
		["Buy if out of Portal"] = true,
		["Auto Next"] = true,
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		},
		["Auto Delete Spider Forest Portal"] = true
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Use Ability"] = true,
		["Double Dungeon"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Wave"] = 22
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Bear"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Shibuya Station"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		}
	},
	["Misc"] = {
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Modifier"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Planning Ahead"] = 15,
				["Immunity"] = 11,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Slayer"] = 16,
				["Fisticuffs"] = 25,
				["Revitalize"] = 6,
				["Harvest"] = 17,
				["Quake"] = 9,
				["Precise Attack"] = 13,
				["Range"] = 18,
				["No Trait No Problem"] = 23,
				["Regen"] = 7,
				["King's Burden"] = 27,
				["Exterminator"] = 28,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Cooldown"] = 19,
				["Drowsy"] = 8,
				["Press It"] = 14,
				["Lifeline"] = 29,
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
				["Precise Attack"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 0,
				["Lifeline"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Replay Amount"] = 0
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Boss Event Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "SukonoEvent"
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
			["Blood-Red Chamber"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Ruined City"] = "Middle",
			["Planet Namak"] = "Middle",
			["Cavern"] = "Middle",
			["Martial Island"] = "Middle",
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
			["6"] = -1
		},
		["Middle Position"] = {
			["Shibuya Aftermath"] = "225.404052734375, 514.7516479492188, 59.85028839111328",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Planet Namak"] = "540.7099609375, 2.062572717666626, -365.3252258300781"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Cavern"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Martial Island"] = 2,
			["Ruined City"] = 2,
			["Shibuya Station"] = 2,
			["Planet Namak"] = 2,
			["Blood-Red Chamber"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Ant Island"] = 2
		}
	},
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
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
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
