game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223982782119967/1284224056157274237/LSDD3_Sonj2.json?ex=66e5da5a&is=66e488da&hm=a55fc6cbf71c588ec594827631cbf2163a2631f184168d1c2b7be227cc6fe7d8&"
getgenv().Config = {
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["AutoSave"] = true,
	["Macros"] = {
		["Macro"] = "LSDD3LD",
		["Play"] = true,
		["Walk Around"] = true
	},
	["Auto Skip Wave"] = true,
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
	}
}
getgenv().Key = "a7d5f4649b92e5bbc5833146793b40c220c845c8487fc9b643ae5d4f3cc679c4"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
