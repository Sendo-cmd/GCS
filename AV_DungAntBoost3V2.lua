game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Play"] = true,
		["Macro"] = "DungBoost3V2",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Macro Retry Limit"] = 0,
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
		},
		["Saber Event"] = {
			["Auto Select Servant"] = false,
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Restart"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Auto Modifier"] = {
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
			["Enable"] = true,
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
				["Slayer"] = 0,
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
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Modifier"] = {
				["Lifeline"] = false,
				["Exterminator"] = false,
				["No Trait No Problem"] = false,
				["Fisticuffs"] = false,
				["Warding off Evil"] = false,
				["King's Burden"] = false,
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
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
			["Enable"] = true,
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
				["Slayer"] = 0,
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
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
		}
	},
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden