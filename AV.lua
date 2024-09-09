getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/1282640420446404608/1282640862320263291/chap1.json?ex=66e017e3&is=66dec663&hm=e46ac10427e9a6d9e066418a698c66fdef55201b9aa89c6208a910c91a20ca48&"
getgenv().Config = {
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Act"] = "Act1",
		["Stage"] = "Planet Namak",
		["Auto Join"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Sand Village",
		["Act"] = "Act3"
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	},
	["Macros"] = {
		["Macro"] = "chap1",
		["Play"] = true,
		["Ignore Macro Timing"] = true
	}
}
getgenv().Key = "abfc3740a466190850e6bd048c08c76a81df3d2cdd80c373a9c137c1ad7c6481"
loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()
