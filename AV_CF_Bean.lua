game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Infinite",
		["Stage"] = "Shibuya Station"
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["No Ignore Sell Timing"] = true,
		["Play"] = true,
		["Macro"] = "CF_Bean",
		["Ignore Macro Timing"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 4
		}
	},
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
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 34
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Middle Position"] = {
			["Shibuya Station"] = "-767.325927734375, 9.356081008911133, -118.07311248779297"
		},
		["Upgrade Method"] = "Nearest from Middle Position (until Max)"
	}
}
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden