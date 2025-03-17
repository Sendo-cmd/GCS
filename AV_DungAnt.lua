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
	["Gameplay"] = {
		["Occult Hunt"] = {
			["Restart Unmatch"] = {
				["Enable"] = true,
				["Modifier"] = "Money Surge"
			}
		},
		["Ant Island"] = {
			["Walk To Ant Tunnel"] = true,
			["Auto Plug Ant Tunnel"] = true
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 30
		},
		["Auto Skip Wave"] = true,
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 89,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 91,
				["Dodge"] = 0,
				["Slayer"] = 93,
				["Immunity"] = 92,
				["Revitalize"] = 0,
				["Harvest"] = 99,
				["Champions"] = 88,
				["Cooldown"] = 96,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Range"] = 98,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 97,
				["Common Loot"] = 94,
				["King's Burden"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 95,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 3,
				["Thrice"] = 3,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Slayer"] = 0,
				["Immunity"] = 1,
				["Revitalize"] = 3,
				["Harvest"] = 0,
				["Champions"] = 1,
				["Cooldown"] = 3,
				["Drowsy"] = 3,
				["Lifeline"] = 0,
				["Range"] = 0,
				["Regen"] = 3,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 3,
				["Shielded"] = 3,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
			}
		}
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
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 89,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 91,
				["Dodge"] = 0,
				["Slayer"] = 93,
				["Immunity"] = 92,
				["Revitalize"] = 0,
				["Harvest"] = 99,
				["Champions"] = 88,
				["Cooldown"] = 96,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Range"] = 98,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 97,
				["Common Loot"] = 94,
				["King's Burden"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 95,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 3,
				["Thrice"] = 3,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Slayer"] = 0,
				["Immunity"] = 1,
				["Revitalize"] = 3,
				["Harvest"] = 0,
				["Champions"] = 1,
				["Cooldown"] = 3,
				["Drowsy"] = 3,
				["Lifeline"] = 0,
				["Range"] = 0,
				["Regen"] = 3,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 3,
				["Shielded"] = 3,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
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
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoExecute"] = true,
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Planet Namak"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Double Dungeon"] = "Middle"
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
			["Ant Island"] = "-18.261302947998047, 164.8186492919922, -44.56714630126953"
		},
		["Place Gap"] = {
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Planet Namak"] = 2,
			["Ant Island"] = 2.5,
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
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden