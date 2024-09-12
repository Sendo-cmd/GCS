game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1282979017955217428/ObitaEvo.json?ex=66e152d2&is=66e00152&hm=11053f94869d57ee97aca37f289e0052a789fd8300028922dc8123ad73c37c00&"
getgenv().Config = {
	["AutoSave"] = true,
	["Webhook"] = {
		["Stage Finished"] = false,
		["URL"] = "https://discord.com/api/webhooks/1016102161689612338/sjdnR-tIozI-JO_gFSy9nZ7G2PV51hJdH7jn4sK4chO7sM4Ab5igib97uQZ6azN1WyX2"
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Sand Village",
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
	["Macros"] = {
		["Macro"] = "ObitaEvo",
		["Play"] = true,
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	}
}
getgenv().Key = "eaaca5965fa2de2d5b74fb1affa8288d0b209a77547a926b8fe7e0fc60d08af0"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
