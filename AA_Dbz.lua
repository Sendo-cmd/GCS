game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["AutoSave"] = true,
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Joiner Cooldown"] = 0,
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Macros"] = {
		["Macro"] = "dbz",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true,
		["Play"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden