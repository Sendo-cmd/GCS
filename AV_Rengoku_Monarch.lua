game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1287719591354826847/1287719591430197311/Raid_Monarch_Igris.json?ex=66f7d7d3&is=66f68653&hm=f2cc6181fa1d790186bb39f4d132f97832d72eb150704284d1a2b0701ab4e4b3&"
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 10,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true,
			["FPS Cap"] = 10
		}
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Raid Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "Spider Forest",
		["Act"] = "Act4"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 1
		}
	},
	["Macros"] = {
		["Play"] = true,
		["Macro"] = "Raid_Monarch_Igris",
		["Random Offset"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
