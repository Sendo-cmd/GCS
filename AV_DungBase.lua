game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro"] = "",
		["Ignore Macro Timing"] = true,
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
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 1,
			["3"] = 1,
			["2"] = 1,
			["5"] = 1,
			["4"] = 1,
			["6"] = 1
		},
		["Enable"] = true,
		["Middle Position"] = {
			["Mountain Shrine (Natural)"] = "340.6167297363281, 8.040106773376465, -93.39224243164062"
		},
		["Upgrade Method"] = "Randomize"
	},
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Gameplay"] = {
		["Occult Hunt"] = {
			["Collect Talisman"] = true,
			["Walk To Talisman"] = true,
			["Use Talisman on Crab"] = true,
			["Restart Unmatch"] = {
				["Enable"] = true,
				["Modifier"] = "King's Burden"
			}
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 96,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 1,
				["Revitalize"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 2,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 100,
				["Uncommon Loot"] = 99,
				["Champions"] = 98,
				["Drowsy"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 89,
				["Regen"] = 0,
				["King's Burden"] = 80,
				["Damage"] = 90,
				["Common Loot"] = 97,
				["Range"] = 91,
				["Quake"] = 0,
				["Press It"] = 93,
				["Planning Ahead"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 92,
				["Money Surge"] = 0
			},
			["Amount"] = {
				["Strong"] = 6,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Precise Attack"] = 0,
				["Fast"] = 1,
				["Revitalize"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 1,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 10,
				["Uncommon Loot"] = 2,
				["Champions"] = 4,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["Cooldown"] = 2,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Damage"] = 4,
				["Common Loot"] = 2,
				["Range"] = 2,
				["Quake"] = 0,
				["Press It"] = 1,
				["Planning Ahead"] = 1,
				["Shielded"] = 0,
				["Slayer"] = 1,
				["Money Surge"] = 0
			}
		}
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden