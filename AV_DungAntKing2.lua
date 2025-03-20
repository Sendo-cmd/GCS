game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["Macros"] = {
		["Macro"] = "DungAntKing3",
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Play"] = true,
		["No Ignore Sell Timing"] = true,
	},
	["Gameplay"] = {
		["Ant Island"] = {
			["Walk To Ant Tunnel"] = false,
			["Auto Plug Ant Tunnel"] = true
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = false,
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
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 11,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 80,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["King's Burden"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 10,
				["Slayer"] = 92,
				["Immunity"] = 79,
				["Fisticuffs"] = 0,
				["Harvest"] = 99,
				["Planning Ahead"] = 0,
				["Drowsy"] = 12,
				["Quake"] = 0,
				["Lifeline"] = 0,
				["Range"] = 95,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 94,
				["Common Loot"] = 97,
				["Cooldown"] = 93,
				["Precise Attack"] = 0,
				["Press It"] = 96,
				["No Trait No Problem"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 98,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 1,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 1,
				["Uncommon Loot"] = 0,
				["Immunity"] = 1,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["Drowsy"] = 2,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = false,
		["Black Screen"] = false,
		["Delete Entities"] = false
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["AutoExecute"] = true,
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Joiner Cooldown"] = 0,
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden