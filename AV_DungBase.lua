game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
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
	["Dungeon Joiner"] = {
		["Stage"] = "Mountain Shrine (Natural)",
		["Auto Join"] = true,
		["Act"] = "OccultHunt"
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
		["Occult Hunt"] = {
			["Collect Talisman"] = true,
			["Use Talisman on Crab"] = true
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Modifier"] = {
			["Restart Unmatch"] = {
				["Enable"] = true,
				["Modifier"] = "King's Burden"
			},
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Precise Attack"] = 13,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Immunity"] = 11,
				["Fisticuffs"] = 25,
				["Harvest"] = 17,
				["Uncommon Loot"] = 98,
				["Champions"] = 12,
				["No Trait No Problem"] = 58,
				["Drowsy"] = 8,
				["Cooldown"] = 19,
				["King's Burden"] = 100,
				["Regen"] = 7,
				["Damage"] = 97,
				["Common Loot"] = 96,
				["Range"] = 94,
				["Quake"] = 9,
				["Press It"] = 93,
				["Planning Ahead"] = 15,
				["Shielded"] = 5,
				["Slayer"] = 95,
				["Money Surge"] = 99
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 0,
				["Uncommon Loot"] = 0,
				["Champions"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Range"] = 0,
				["Quake"] = 0,
				["Press It"] = 0,
				["Planning Ahead"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
