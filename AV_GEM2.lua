game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223416110415964/1285110553257447536/GEM2.json?ex=66ee59f8&is=66ed0878&hm=7010e6d4bd3a47b40c7e26915aa52c1f6945a6253be6a65d42ba2cc355c34716&"
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
	["Webhook"] = {
		["Stage Finished"] = true,
		["URL"] = "https://discord.com/api/webhooks/1285656259604774912/2m06zwdD_zylzlJ6iZ7F167cgEd8Vbg8leUk1obYgKVjXMctXsaxPIoB2FTpmkntDGnj"
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
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
