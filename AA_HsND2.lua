game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Game Finished"] = {
		["Auto Replay"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Auto Next"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true
	},
	["Macros"] = {
		["Macro"] = "hsnd2",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Play"] = true
	},
	["AutoSave"] = true
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden