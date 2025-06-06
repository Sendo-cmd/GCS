game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Play"] = true,
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true,
		["Macro"] = "Sokora2",
		["Joiner Macro Equipper"] = {
			["Enable"] = true
		}
	},
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Auto Next"] = false,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			},
			["Enable"] = false
		}
	},
	["Winter Portal Joiner"] = {
		["Buy if out of Portal"] = false,
		["Tier Cap"] = 10,
		["Auto Next"] = false,
		["Auto Join"] = false,
		["Ignore Act"] = {
			["[Planet Namak] Act3"] = false,
			["[Shibuya Aftermath] Act2"] = false,
			["[Planet Namak] Act6"] = false,
			["[Planet Namak] Act1"] = false,
			["[Spider Forest] Act3"] = false,
			["[Planet Namak] Act5"] = false,
			["[Spider Forest] Act1"] = false,
			["[Planet Namak] Act4"] = false,
			["[Planet Namak] Act2"] = false,
			["[Spider Forest] Act4"] = false,
			["[Shibuya Aftermath] Act3"] = false,
			["[Shibuya Aftermath] Act1"] = false,
			["[Spider Forest] Act2"] = false
		},
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			},
			["Enable"] = false
		},
		["Ignore Modifier"] = {
			["Strong"] = false,
			["Drowsy"] = false,
			["Regen"] = false,
			["Fast"] = false,
			["Revitalize"] = false,
			["Champions"] = false,
			["Exploding"] = false,
			["Dodge"] = false,
			["Immunity"] = false,
			["Shielded"] = false,
			["Quake"] = false,
			["Thrice"] = false
		},
		["Auto Delete Spider Forest Portal"] = false
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Saber Event"] = {
			["Servant"] = "Berserker",
			["Auto Select Servant"] = true
		},
		["Auto Vote Start"] = true,
		["Auto Restart"] = {
			["Enable"] = false,
			["Wave"] = 1
		},
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = false,
		["Auto Sell Farm"] = {
			["Enable"] = false,
			["Wave"] = 1
		}
	},
	["Misc"] = {
		["Right Click Teleport"] = false,
		["Right Click Move"] = false,
		["Redeem Code"] = true,
		["Max Camera Zoom"] = 40
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Next"] = false,
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Teleport Lobby if Player"] = false
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = false,
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
		}
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Battle Pass"] = false,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Boss Event Joiner"] = {
		["Elite Mode"] = false,
		["Auto Join"] = true,
		["Stage"] = "SaberEvent"
	}
}
getgenv().Key = "PkaqtHwDxdKOeNHlsbAJXeFpOCYXbCQB" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH]
repeat wait(4)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden