repeat task.wait() until game:IsLoaded()
getgenv().Config = {
	["Inventory"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Rarity"] = {
				["Legendary"] = true,
				["Mythical"] = true
			},
			["Delay"] = 2
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Enable"] = true,
		["Shark Event"] = {
			["Great Hammerhead Shark"] = true,
			["Whale Shark"] = true,
			["The Depths - Serpent"] = true,
			["Great White Shark"] = true
		},
		["Fish Location"] = {
			["Auto"] = true,
			["Zone"] = "The Depths",
			["Height"] = 10,
			["Postion"] = "-91.2283249, -751.813477, 1205.03418, 0.898936927, 0.00505644642, -0.43804878, 3.53068188e-08, 0.999933362, 0.0115424749, 0.438077956, -0.0103759198, 0.898877084"
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Character"] = {
		["Disable Swim"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Auto Aurora Totem"] = {
		["Use Sundial if Day"] = true,
		["Enable"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Minute"] = 60
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden