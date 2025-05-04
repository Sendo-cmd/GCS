game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Legend Stage Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		}
	},
	["Love Portal Joiner"] = {
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		},
		["Tier Cap"] = 10
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Winter Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		}
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Double Dungeon"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["Martial Island"] = {
			["Auto Join God Portal"] = true,
			["Collect Rotara Earring"] = true
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Shadow"] = "Bear"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Auto Vote Start"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
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
		["Restart Modifier"] = {
			["Enable"] = false,
			["Modifier"] = {
				["Immunity"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 98,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 100,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 99,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			},
			["Enable"] = true,
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
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
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
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Martial Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Cavern"] = "Middle",
			["Ant Island"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Blood-Red Chamber"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Martial Island"] = "-487.8406066894531, 136.8050537109375, -454.28057861328125",
			["Land of the Gods"] = "-158.46160888671875, 1.2214683294296265, 119.30146026611328"
		},
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
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Blood-Red Chamber"] = 2,
			["Planet Namak"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Martial Island"] = 2
		}
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = true,
		["Auto Next"] = true,
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
	["Performance"] = {
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Joiner Cooldown"] = 0,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Land of the Gods",
		["Auto Join"] = false,
		["Act"] = "Act1"
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden