game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["No Ignore Sell Timing"] = true
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Cash Out Floor"] = 5,
		["Intensity"] = 200,
		["First Team"] = 1
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Double Dungeon"] = {
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 0
		},
		["Auto Sell"] = {
			["Wave"] = 22
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["Martial Island"] = {
			["Auto Join God Portal"] = true
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
			["Cavern"] = "Middle",
			["Sand Village"] = "Middle",
			["Shining Castle"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Edge of Heaven"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Ant Island"] = "Middle",
			["Martial Island"] = "Middle",
			["Ruined City"] = "Middle",
			["Planet Namak"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Kuinshi Palace"] = "Middle"
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
			["Planet Namak"] = "-214.81019592285156, 4.474977493286133, 99.4848861694336",
			["Edge of Heaven"] = "-39.13007354736328, 147.29444885253906, -186.71127319335938",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Land of the Gods"] = "-158.46160888671875, 1.2214683294296265, 119.30146026611328"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Blood-Red Chamber"] = 2,
			["Sand Village"] = 2,
			["Shining Castle"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Edge of Heaven"] = 2,
			["Ant Island"] = 2,
			["Planet Namak"] = 2,
			["Shibuya Aftermath"] = 2,
			["Martial Island"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Cavern"] = 2
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
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
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
	["Spring Portal Joiner"] = {
		["Buy if out of Portal"] = true,
		["Tier Cap"] = 10,
		["Auto Next"] = true,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Land of the Gods"] = 1,
				["Planet Namak"] = 3,
				["Edge of Heaven"] = 2
			}
		},
		["Ignore Act"] = {
			["[Land of the Gods] Act2"] = true,
			["[Land of the Gods] Act3"] = true,
			["[Land of the Gods] Act1"] = true
		}
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden