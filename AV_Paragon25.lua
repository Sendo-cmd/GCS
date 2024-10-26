getgenv().Config = {
	["Joiner Cooldown"] = 60,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Paragon",
		["Stage"] = "Planet Namak"
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true,
		["Macro"] = "PN25_IGSON",
		["Play"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = true,
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 5
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true,
        ["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
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
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Revitalize"] = 3,
				["Exploding"] = 2,
				["Thrice"] = 4,
				["Strong"] = 19,
				["Shielded"] = 8,
				["Regen"] = 20,
				["Fast"] = 0
			}
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden