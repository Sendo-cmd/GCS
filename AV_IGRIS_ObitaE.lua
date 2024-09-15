game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().RedeemAllCode = true
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1284223982782119967/1284223985843703953/LSDD3_ObitaE.json?ex=66e7d489&is=66e68309&hm=fcd9d4440c1ad74830bed03774883bd356b7aa19c13944072975dae23d5e5afa&"
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
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Daily Reward"] = true
	},
	["Macros"] = {
		["Macro"] = "LSDD3_ObitaE",
		["Play"] = true
	}
}
getgenv().Key = "fea5659703eded62fbca784788b7d649aeceeba2a21feade2469968922c6eb1e"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
