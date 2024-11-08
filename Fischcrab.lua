repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Inventory"] = {
		["Auto Favourite"] = {
			["Special Attribute"] = true,
			["Rarity"] = {
				["Mythical"] = true,
				["Event"] = true,
				["Relic"] = true,
				["Divine"] = true
			},
			["Weight"] = 1000,
			["Enable"] = true
		},
		["Auto Sell"] = {
			["Enable"] = true,
			["Delay"] = 1
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Fish Location"] = {
			["Height"] = -50
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Auto Merlin"] = {
		["Lucky"] = true
	},
	["Auto Cage"] = {
		["Buy Amount"] = 500,
		["Deploy Position"] = "-1672.18347, -212.710266, -2827.35254, 0.354278117, -0.0112234224, 0.93507266, 6.11512263e-08, 0.999927938, 0.0120019, -0.935140014, -0.00425193226, 0.354252607",
		["Check Delay"] = 1,
		["Enable"] = true,
		["Only Deploy if no Cage"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Rejoin Timer"] = {
			["Enable"] = true,
			["Minute"] = 60
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden