game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroUnit = true
getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223982782119967/1284224056157274237/LSDD3_Sonj2.json?ex=66e7d49a&is=66e6831a&hm=61e96e5d820b026862203a4936d4803aab2ae87dcd5a192753f1146a311fca42&"
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
		["Play"] = true,
		["Walk Around"] = true
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	getgenv().Config = {
	["AutoSave"] = true,
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Macros"] = {
		["Macro"] = "LSDD3_Sonj",
		["Play"] = true,
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Sell"] = {
			["Wave"] = 1
		}
	},
	["Webhook"] = {
		["Stage Finished"] = true,
		["URL"] = "https://discord.com/api/webhooks/1016102161689612338/sjdnR-tIozI-JO_gFSy9nZ7G2PV51hJdH7jn4sK4chO7sM4Ab5igib97uQZ6azN1WyX2"
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true
	}
}
getgenv().Key = "fea5659703eded62fbca784788b7d649aeceeba2a21feade2469968922c6eb1e"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
