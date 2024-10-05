game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().ImportMacro = ""
getgenv().Config = {
	["Joiner Cooldown"] = 10,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Upgrade Method"] = "Nearest from Middle Position (until Max)",
		["Place Cap"] = {
			["1"] = 3,
			["3"] = 0,
			["2"] = 3,
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
			["Pink Essence Stone"] = 10,
			["Blue Essence Stone"] = 10,
			["Red Essence Stone"] = 10,
			["Yellow Essence Stone"] = 10,
			["Purple Essence Stone"] = 10
		}
	},
	["Webhook"] = {
		["URL"] = ""
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
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 5
		}
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
