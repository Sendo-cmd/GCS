game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
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
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Vote Start"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 30
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 90,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 4,
				["Dodge"] = 0,
				["Uncommon Loot"] = 98,
				["Immunity"] = 91,
				["Revitalize"] = 0,
				["Harvest"] = 99,
				["Precise Attack"] = 0,
				["Range"] = 96,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 93,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 95,
				["Common Loot"] = 97,
				["Regen"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 94,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 92,
				["Money Surge"] = 100
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 1,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 1,
				["Planning Ahead"] = 0,
				["Immunity"] = 1,
				["Exploding"] = 3,
				["Dodge"] = 1,
				["Slayer"] = 4,
				["Fisticuffs"] = 0,
				["Revitalize"] = 1,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 1,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 3,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
			}
		}
	},
	["Performance"] = {
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Randomize",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Cavern"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Planet Namak"] = "Middle"
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
			["Ant Island"] = "-16.99512481689453, 164.8186492919922, -45.40901184082031"
		},
		["Place Gap"] = {
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Blood-Red Chamber"] = 2,
			["Ant Island"] = 2.4,
			["Shibuya Station"] = 2,
			["Double Dungeon"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Cavern"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Planet Namak"] = 2
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Claimer"] = {
		["Auto Claim Collection Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Battle Pass"] = true
	},
	["Dungeon Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Ant Island",
		["Act"] = "AntIsland"
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
