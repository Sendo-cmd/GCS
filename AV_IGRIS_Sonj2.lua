game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283539579713884190/LSDD3_Sonj2.json?ex=66e35ce2&is=66e20b62&hm=f7bc6785c2b0e8f136e1427a4934e0f0a5ec97a24504a6687eafe82628d5bd25&"
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
		["Macro"] = "LSDD3_Sonj2",
		["Play"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	}
}
getgenv().Key = "eaaca5965fa2de2d5b74fb1affa8288d0b209a77547a926b8fe7e0fc60d08af0"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
