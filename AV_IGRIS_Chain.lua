game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223982782119967/1285712991941038110/LSDD3_Chain.json?ex=66f08b08&is=66ef3988&hm=61a724219c41c7f25edbed93b87039c17d7bf13969ee459da27288b51352577a&"
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
	["Joiner Cooldown"] = 5,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Webhook"] = {
		["Stage Finished"] = false,
		["URL"] = "https://discord.com/api/webhooks/1285656259604774912/2m06zwdD_zylzlJ6iZ7F167cgEd8Vbg8leUk1obYgKVjXMctXsaxPIoB2FTpmkntDGnj"
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Macros"] = {
		["Macro"] = "LSDD3_Chain",
		["Play"] = true,
		["Walk Around"] = true,
		["Ignore Macro Timing"] = false
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
