game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1287719591354826847/1288123994054201364/Raid_Alocard.json?ex=66f40a74&is=66f2b8f4&hm=61786006cb75d3ec1a01634f9882739b35deb233c765d0699670572a17a883fb&"
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 10,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = {
			["Enable"] = true,
			["FPS Cap"] = 20
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
		["Macro"] = "Raid_Alocard",
		["Ignore Macro Timing"] = false,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(7)until Joebiden
