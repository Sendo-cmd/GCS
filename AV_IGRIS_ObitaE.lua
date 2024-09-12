game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283522082113589350/LSDD3_ObitaE.json?ex=66e34c97&is=66e1fb17&hm=291ba74c9ea8b6f465cf1352f15ad4fdeff69125455b19e4d15f5f2b63c020e2&"
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
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true
	},
	["Macros"] = {
		["Macro"] = "LSDD3_ObitaE",
		["Play"] = true
	}
}
getgenv().Key = "eaaca5965fa2de2d5b74fb1affa8288d0b209a77547a926b8fe7e0fc60d08af0"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
