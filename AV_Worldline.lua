game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Worldline Joiner"] = {
		["Auto Join"] = true
	},
	["AutoSave"] = true,
	["Macros"] = {
		["Macro"] = "GCW",
		["Ignore Macro Timing"] = true,
		["Macro Retry Limit"] = 0,
		["Play"] = true,
		["Worldline Macro"] = {
			["Shibuya Aftermath"] = "SAW",
			["Double Dungeon"] = "DDW",
			["Planet Namak"] = "NW",
			["Shibuya Station"] = "SSW",
			["Underground Church"] = "UCW",
			["Kuinshi Palace"] = "KPW",
			["Golden Castle"] = "GCW"
		},
		["No Ignore Sell Timing"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Auto Next"] = true,
		["Replay Amount"] = 0
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
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
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
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Immunity"] = 11,
				["Fisticuffs"] = 25,
				["Harvest"] = 17,
				["Slayer"] = 16,
				["Precise Attack"] = 13,
				["Planning Ahead"] = 15,
				["No Trait No Problem"] = 23,
				["Cooldown"] = 19,
				["Quake"] = 9,
				["King's Burden"] = 27,
				["Range"] = 18,
				["Common Loot"] = 21,
				["Damage"] = 20,
				["Regen"] = 7,
				["Press It"] = 14,
				["Drowsy"] = 8,
				["Shielded"] = 5,
				["Uncommon Loot"] = 22,
				["Money Surge"] = 26
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 0,
				["Slayer"] = 0,
				["Precise Attack"] = 0,
				["Planning Ahead"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Quake"] = 0,
				["King's Burden"] = 0,
				["Range"] = 0,
				["Common Loot"] = 0,
				["Damage"] = 0,
				["Regen"] = 0,
				["Press It"] = 0,
				["Drowsy"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Wave"] = 1
		},
		["Auto Vote Start"] = true,
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden