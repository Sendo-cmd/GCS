game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223416110415964/1285244706502213632/GEM3.json?ex=66ea39a8&is=66e8e828&hm=01ff41855d4b8cec655f46e1e3a281890378102a95ed8fb54b92d6556b9f3d86&"
getgenv().Config = {
	["Macros"] = {
		["Macro"] = "GEM3",
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
	["Joiner Cooldown"] = 5,
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
getgenv().Key = "4702795a7dec1d4a4b620ea7329b215d020f7471b06d76c9082537c60875206b"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
