game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game:GetService("RunService"):Set3dRenderingEnabled(false)

getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1283374076768948334/NarutoEvoCh.json?ex=66e2c2bf&is=66e1713f&hm=4ced0843f6f07d70efb330657dbbe5249157518271b100b5ee155ab98381ea24&"
getgenv().Config = {
	["Legend Stage Joiner"] = {
		["Stage"] = "Sand Village",
		["Auto Join"] = true,
		["Act"] = "Act1"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["Macro"] = "NarutoEvoCh",
		["Play"] = true
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
	},
	["Auto Skip Wave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	}
}
getgenv().Key = "f8c7bbe45c7e83156da82c462c877eceb9fe818f3765b22d0763da346311a3e5"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
