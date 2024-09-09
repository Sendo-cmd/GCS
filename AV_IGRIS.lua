
getgenv().EquipMacroTroop = true
getgenv().ImportMacro = "https://cdn.discordapp.com/attachments/774011709358080021/1282774939019116564/Igrisfarm.json?ex=66e094c2&is=66df4342&hm=97836621c54317e28a76d96b51b9b6419d2db910b971f3d6259060dda1e054ea&"
getgenv().Config = {
	["Macros"] = {
		["Macro"] = "Igrisfarm",
		["Play"] = true
	},
	["AutoSave"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
	},
	["Auto Skip Wave"] = true,
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = true
	}
}
getgenv().Key = "abfc3740a466190850e6bd048c08c76a81df3d2cdd80c373a9c137c1ad7c6481"
repeat wait()spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
