game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Joiner Cooldown"] = 0,
	["AutoExecute"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Boss Event Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "IgrosEvent"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true,
        ["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 4
		}
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Place and Upgrade"] = false,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Cavern"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
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
			["6"] = 0
		},
		["Middle Position"] = {
			["Blood-Red Chamber"] = "1.5541236400604248, -0.2512565851211548, -20.021881103515625"
		},
		["Focus on Farm"] = true,
		["Place Gap"] = {
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Blood-Red Chamber"] = 2,
			["Ant Island"] = 2,
			["Shibuya Station"] = 2,
			["Double Dungeon"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Cavern"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Planet Namak"] = 2
		}
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Gold Buyer"] = {
		["Enable"] = true,
		["Item"] = {
			["Crystal"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true,
			["Senzu Bean"] = true,
			["Pink Essence Stone"] = true,
			["Ramen"] = true,
			["Green Essence Stone"] = true,
			["Rainbow Essence Stone"] = true,
			["Super Stat Chip"] = true,
			["Stat Chip"] = true
		}
	},		
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true
	},
	["Macros"] = {
		["Macro"] = "BEIgris3",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden

