game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 65,
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
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = false
	},		
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Raid Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Spider Forest",
		["Act"] = "Act4"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
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
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 1
		}
	},
	["Macros"] = {
		["Play"] = true,
		["Macro"] = "Raid_Base",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden
