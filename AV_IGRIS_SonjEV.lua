game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Joiner Cooldown"] = 10,
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
			["FPS"] = 5
		}
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},		
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = false,
		["URL"] = ""
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
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
	["Macros"] = {
		["Macro"] = "Igris_SonjEV",
		["Play"] = true,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
