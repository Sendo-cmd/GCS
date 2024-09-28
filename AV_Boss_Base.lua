game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1288974637686067282/1289145930292920320/Boss_Base.json?ex=66f913b4&is=66f7c234&hm=33f92d748bd8729988e98796af64343387325cad50c4de66bbef709354a22385&"
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
		["Random Offset"] = true,
		["Ignore Macro Timing"] = true,
		["Macro"] = "Boss_Base",
		["Play"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
