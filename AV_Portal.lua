game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Auto Join"] = true,
		["Ignore Act"] = {
			["[Spider Forest] Act2"] = true,
			["[Spider Forest] Act3"] = true,
			["[Spider Forest] Act1"] = true,
			["[Spider Forest] Act4"] = true
		},
		["Ignore Modifier"] = {
			["Thrice"] = true,
			["Fast"] = true
		},
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		},
		["Auto Delete Spider Forest Portal"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Focus on Farm"] = true
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = true
	},
	["AutoSave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Boss Event Joiner"] = {
		["Stage"] = "IgrosEvent"
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		},
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
