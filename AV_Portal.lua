game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
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
	["Spring Portal Joiner"] = {
		["Buy if out of Portal"] = true,
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Land of the Gods"] = 1,
				["Planet Namak"] = 3,
				["Edge of Heaven"] = 2
			}
		},
		["Ignore Act"] = {
			["[Land of the Gods] Act2"] = true,
			["[Land of the Gods] Act3"] = true,
			["[Land of the Gods] Act1"] = true
		}
	},
	-- ["Winter Portal Joiner"] = {
	-- 	["Buy if out of Portal"] = true,
	-- 	["Tier Cap"] = 10,
	-- 	["Auto Next"] = true,
	-- 	["Portal Reward Picker"] = {
	-- 		["Enable"] = true,
	-- 		["Prioritize"] = {
	-- 			["Shibuya Aftermath"] = 2,
	-- 			["Spider Forest"] = 1,
	-- 			["Planet Namak"] = 3
	-- 		}
	-- 	},
	-- 	["Auto Delete Spider Forest Portal"] = true
	-- },
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 22
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 20
		},
		["Auto Vote Start"] = true,
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Modifier"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["King's Burden"] = 27,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Slayer"] = 16,
				["Immunity"] = 11,
				["Fisticuffs"] = 25,
				["Harvest"] = 17,
				["Planning Ahead"] = 15,
				["Drowsy"] = 8,
				["Quake"] = 9,
				["Lifeline"] = 29,
				["Range"] = 18,
				["Regen"] = 7,
				["Exterminator"] = 28,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["Cooldown"] = 19,
				["Precise Attack"] = 13,
				["Press It"] = 14,
				["No Trait No Problem"] = 23,
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
				["King's Burden"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Immunity"] = 0,
				["Fisticuffs"] = 0,
				["Harvest"] = 0,
				["Planning Ahead"] = 0,
				["Drowsy"] = 0,
				["Quake"] = 0,
				["Lifeline"] = 0,
				["Range"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Precise Attack"] = 0,
				["Press It"] = 0,
				["No Trait No Problem"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Spirit Society"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Cavern"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Ant Island"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Planet Namak"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Shibuya Aftermath"] = "-94.77557373046875, 316.1539306640625, -34.29759216308594",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Planet Namak"] = "540.7099609375, 2.062572717666626, -365.3252258300781",
			["Land of the Gods"] = "-158.46160888671875, 1.2214683294296265, 119.30146026611328",
			["Edge of Heaven"] = "-39.13007354736328, 147.29444885253906, -186.71127319335938"
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["AutoExecute"] = true
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB]
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden