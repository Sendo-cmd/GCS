game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Play"] = false,
	},
	["Gameplay"] = {
		["Double Dungeon"] = {
			["Auto Statue"] = true,
			["Statue Unit"] = "Chaso (Blood Curse)",
			["Upgrade Amount"] = 1
		},
		["Shibuya Station"] = {
			["Mohato Unit"] = "Chaso (Blood Curse)",
			["Auto Mohato"] = true,
			["Upgrade Amount"] = 0
		}
		["Auto Sell"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = false,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Skip Wave"] = true,
		["Auto Restart"] = {
			["Enable"] = false,
			["Wave"] = 1
		}
	},
	["Misc"] = {
		["Right Click Teleport"] = false,
		["Right Click Move"] = false,
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Worldline Joiner"] = {
		["Auto Join"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = false,
			["Modifier"] = {
				["No Trait No Problem"] = false,
				["King's Burden"] = false,
				["Lifeline"] = false,
				["Fisticuffs"] = false,
				["Warding off Evil"] = false,
				["Exterminator"] = false,
				["Money Surge"] = false
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Immunity"] = 11,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Slayer"] = 16,
				["Fisticuffs"] = 25,
				["Planning Ahead"] = 15,
				["Harvest"] = 17,
				["Quake"] = 9,
				["Range"] = 18,
				["Lifeline"] = 29,
				["No Trait No Problem"] = 23,
				["King's Burden"] = 27,
				["Regen"] = 7,
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
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
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
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Replay"] = true,
		["Auto Next"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place and Upgrade"] = false,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = -1,
			["4"] = -1,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Randomize",
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
			["Golden Castle"] = "-99.95283508300781, -0.16030120849609375, -209.19700622558594",
			["Double Dungeon"] = "-281.06927490234375, 0.10069097578525543, -115.02333068847656",
			["Kuinshi Palace"] = "392.0209045410156, 268.38262939453125, 117.99325561523438",
			["Shibuya Station"] = "-767.7849731445312, 9.356081008911133, -117.69595336914062",
			["Planet Namak"] = "535.2527465820312, 2.062572717666626, -368.2378845214844"
		},
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
			["Double Dungeon"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Tracks at the Edge of the World"] = 2
		}
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden