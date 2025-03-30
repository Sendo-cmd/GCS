game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Dungeon Joiner"] = {
		["Stage"] = "Ant Island",
		["Auto Join"] = true,
		["Act"] = "AntIsland"
	},
	["Macros"] = {
		["Macro"] = "DungAntKing4",
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
				["Lifeline"] = false,
				["Exterminator"] = false,
				["No Trait No Problem"] = false,
				["Warding off Evil"] = false,
				["Fisticuffs"] = false,
				["King's Burden"] = false,
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 1,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 79,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Uncommon Loot"] = 97,
				["Immunity"] = 80,
				["Planning Ahead"] = 0,
				["Harvest"] = 99,
				["Precise Attack"] = 0,
				["Range"] = 95,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 93,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 94,
				["Common Loot"] = 96,
				["King's Burden"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 98,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 92,
				["Money Surge"] = 100
			},
			["Amount"] = {
				["Strong"] = 2,
				["Thrice"] = 1,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 1,
				["Revitalize"] = 1,
				["Fisticuffs"] = 0,
				["Exploding"] = 3,
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
				["Regen"] = 1,
				["Drowsy"] = 1,
				["Press It"] = 4,
				["Quake"] = 1,
				["Shielded"] = 1,
				["Slayer"] = 0,
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
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden


