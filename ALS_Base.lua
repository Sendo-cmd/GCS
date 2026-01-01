getgenv().Config = {
	["Misc"] = {
		["Redeem Code"] = true,
		["Auto Spooky Bingo"] = true
	},
	["Webhook"] = {
		["Match Finished"] = true
	},
	["Auto Join Setting"] = {
		["Joiner Priority"] = {
			["Final Expedition Joiner"] = 10,
			["Infinity Castle Joiner"] = 8,
			["Legend Stage Joiner"] = 2,
			["Story Joiner"] = 1,
			["Dungeon Joiner"] = 4,
			["Siege Joiner"] = 6,
			["Boss Rush Joiner"] = 7,
			["Elemental Cavern Joiner"] = 12,
			["Survival Joiner"] = 5,
			["Event Joiner"] = 11,
			["Raid Joiner"] = 3,
			["Tournament Joiner"] = 9
		},
		["Joiner Cooldown"] = 0
	},
	["Game Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Next"] = false,
		["Return Lobby Failsafe"] = false,
		["Auto Replay"] = true,
		["Seamless Stage"] = {
			["Enable"] = false,
			["Amount"] = 0
		}
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = false
	},
	["Joiner"] = {
		["Final Expedition Joiner"] = {
			["Enable"] = false,
			["Hard Mode"] = false
		},
		["Infinity Castle Joiner"] = {
			["Enable"] = false,
			["Hard Mode"] = false
		},
		["Legend Stage Joiner"] = {
			["Enable"] = false
		},
		["Story Joiner"] = {
			["Enable"] = false,
			["Nightmare Mode"] = false
		},
		["Dungeon Joiner"] = {
			["Enable"] = false
		},
		["Siege Joiner"] = {
			["Enable"] = false
		},
		["Boss Rush Joiner"] = {
			["Enable"] = false
		},
		["Elemental Cavern Joiner"] = {
			["Enable"] = false
		},
		["Survival Joiner"] = {
			["Enable"] = false
		},
		["Event Joiner"] = {
			["Enable"] = true,
			["Event"] = "Halloween P2"
		},
		["Raid Joiner"] = {
			["Enable"] = false
		},
		["Tournament Joiner"] = {
			["Enable"] = false,
			["Traitless Mode"] = false
		}
	},
	["Secure"] = {
		["Walk Around"] = true
	},
	["Performance"] = {
		["Boost FPS"] = true,
		["Black Screen"] = false
	},
	["Gameplay"] = {
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop at Wave"] = 0
		},
		["Auto Restart"] = {
			["Enable"] = true,
			["Wave"] = 27
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = false,
				["Wave"] = 1
			},
			["Auto Sell Unit"] = {
				["Enable"] = false,
				["Wave"] = 1
			}
		}
	},
	["Macros"] = {
		["Play"] = true,
		["Macro Retry Limit"] = 0,
		["Macro"] = "Halloween2",
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	}
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH" 
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(1)until Joebiden
