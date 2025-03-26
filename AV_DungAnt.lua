game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Saber Event"] = {
			["Auto Select Servant"] = false,
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 30
		},
		["Auto Vote Start"] = true,
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true,
		["Auto Restart"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
		}
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["No Trait No Problem"] = false,
				["King's Burden"] = false,
				["Lifeline"] = false,
				["Fisticuffs"] = false,
				["Warding off Evil"] = false,
				["Exterminator"] = false,
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 92,
				["Fast"] = 0,
				["Revitalize"] = 2,
				["Fisticuffs"] = 0,
				["Exploding"] = 4,
				["Dodge"] = 0,
				["Uncommon Loot"] = 98,
				["Immunity"] = 91,
				["Planning Ahead"] = 0,
				["Harvest"] = 99,
				["Lifeline"] = 0,
				["Precise Attack"] = 0,
				["Drowsy"] = 1,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 94,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 95,
				["Common Loot"] = 97,
				["King's Burden"] = 0,
				["Range"] = 96,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 93,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 3,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 1,
				["Revitalize"] = 3,
				["Immunity"] = 1,
				["Exploding"] = 3,
				["Dodge"] = 1,
				["Slayer"] = 3,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
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
				["Drowsy"] = 3,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
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
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["AutoExecute"] = true,
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
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
			["4"] = 0,
			["6"] = 0
		},
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
			["Double Dungeon"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle"
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
			["Planet Namak"] = 2,
			["Ant Island"] = 2.5,
			["Shibuya Station"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Double Dungeon"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Tracks at the Edge of the World"] = 2
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
