game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		}
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Macro"] = "Saber",
		["Play"] = true,
		["No Ignore Sell Timing"] = true
		["Joiner Macro Equipper"] = {
			["Enable"] = true
		}
	},
	["AutoExecute"] = true,
	["Match Finished"] = {
		["Auto Replay"] = true,
		["Replay Amount"] = 0
	},
	["Boss Event Joiner"] = {
		["Auto Join"] = true,
		["Stage"] = "SaberEvent"
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["AutoSave"] = true,
	["Gameplay"] = {
		["Saber Event"] = {
			["Servant"] = "Berserker",
			["Auto Select Servant"] = true
		},
		["Auto Use Ability"] = true,
		["Auto Skip Wave"] = true,
		["Auto Restart"] = {
			["Enable"] = true,
			["Wave"] = 16
		},
		["Auto Sell Farm"] = {
			["Wave"] = 1
		}
	}
}
getgenv().Key = "swxqHzWiWRRSVkZqanyraHCEYNggPiBx" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , swxqHzWiWRRSVkZqanyraHCEYNggPiBx]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden