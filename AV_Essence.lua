game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 65,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true,
		["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Upgrade Method"] = "Nearest from Middle Position (until Max)",
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Enable"] = true,
		["Middle Position"] = {
			["Double Dungeon"] = "-273.57171630859375, 0.10069097578525543, -119.12034606933594"
		}
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Crafter"] = {
		["Teleport Lobby full Essence"] = true,
		["Enable"] = true,
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 25,
			["Blue Essence Stone"] = 25,
			["Red Essence Stone"] = 25,
			["Yellow Essence Stone"] = 25,
			["Purple Essence Stone"] = 35
		}
	},
	["Macros"] = {
		["Macro"] = "",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
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
	["Legend Stage Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Double Dungeon",
		["Act"] = "Act1"
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 4
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
