game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Play"] = true,
		["Macro"] = "DungBoost3",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Macro Retry Limit"] = 0,
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Ant Island"] = {
			["Walk To Ant Tunnel"] = true,
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
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 1,
				["Dodge"] = 0,
				["Slayer"] = 94,
				["Immunity"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 99,
				["Champions"] = 0,
				["Cooldown"] = 95,
				["Drowsy"] = 96,
				["Lifeline"] = 0,
				["Range"] = 98,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 97,
				["Common Loot"] = 92,
				["Exterminator"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 93,
				["Money Surge"] = 100
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 3,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 3,
				["Dodge"] = 3,
				["Slayer"] = 0,
				["Immunity"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Champions"] = 0,
				["Cooldown"] = 3,
				["Drowsy"] = 3,
				["Lifeline"] = 0,
				["Range"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Exterminator"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 1
			}
		}
	},
	["Misc"] = {
		["Right Click Teleport"] = false,
		["Right Click Move"] = false,
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
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
				["Strong"] = 89,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 90,
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
			["Enable"] = true,
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
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Next"] = false,
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Secure"] = {
		["Random Offset"] = false,
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