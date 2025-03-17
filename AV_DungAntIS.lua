game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro"] = "DungAntIS",
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Play"] = true,
		["No Ignore Sell Timing"] = true,
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
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 1,
				["Dodge"] = 0,
				["Uncommon Loot"] = 93,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 99,
				["Quake"] = 0,
				["Cooldown"] = 95,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 96,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 97,
				["Common Loot"] = 92,
				["Range"] = 98,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 94,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Uncommon Loot"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Cooldown"] = 3,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 3,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 1
			}
		},
		["Ant Island"] = {
			["Walk To Ant Tunnel"] = true,
			["Auto Plug Ant Tunnel"] = true
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Wave"] = 1
		}
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["King's Burden"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Immunity"] = 92,
				["Exploding"] = 90,
				["Dodge"] = 0,
				["Uncommon Loot"] = 94,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 99,
				["Quake"] = 0,
				["Cooldown"] = 96,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 91,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Damage"] = 97,
				["Common Loot"] = 93,
				["Range"] = 98,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 1,
				["Shielded"] = 0,
				["Slayer"] = 95,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 3,
				["Thrice"] = 3,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Revitalize"] = 3,
				["Immunity"] = 1,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Uncommon Loot"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 3,
				["Cooldown"] = 3,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 3,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 3,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["Press It"] = 0,
				["Champions"] = 1,
				["Shielded"] = 3,
				["Slayer"] = 0,
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
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["AutoExecute"] = true
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden


