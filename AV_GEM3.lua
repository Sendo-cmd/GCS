game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223416110415964/1285244706502213632/GEM3.json?ex=66e990e8&is=66e83f68&hm=c6d9bf188c5d4afef8682adf6857422d1d14e1d5d6f92d7a1692e751a1889644&"
getgenv().Config = {
	["Macros"] = {
		["Macro"] = "GEM2",
		["Play"] = true,
		["Ignore Macro Timing"] = true,
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Act1",
		["Stage"] = "Planet Namak"
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "687d6f758d70a598f1b9f30bc8144a808d6cca292f452cf4a96a390da184b926
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
