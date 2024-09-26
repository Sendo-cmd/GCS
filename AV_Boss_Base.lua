game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1288974637686067282/1288974637803241552/Boss_Base.json?ex=66f722ad&is=66f5d12d&hm=e9ae1230b52aa28a4efed2afac71f5685fa7ce9e174446a40a351db4bf403a02&"
getgenv().Config = {
	["Joiner Cooldown"] = 10,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Boss Event Joiner"] = {
		["Auto Join"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true,
			["FPS Cap"] = 10
		}
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true
	},
	["Macros"] = {
		["Ignore Macro Timing"] = true,
		["Macro"] = "Boss_Base",
		["Play"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
