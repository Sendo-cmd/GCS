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
				["Legendary"] = true,
				["Event"] = true,
				["Mythical"] = true
			}
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Fish Location"] = {
			["Postion"] = "-1827.72595, -140.391846, -3431.39282, 0.379164636, -0.00860293955, 0.925289154, 1.90935641e-08, 0.999956667, 0.00929721631, -0.925329149, -0.00352513604, 0.379148275",
			["Manual"] = true,
			["Height"] = -50
		},
		["Cast Threshold"] = 95,
		["Enable"] = true,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Auto Bait"] = {
		["Buy"] = true,
		["Equip Random"] = true
	},
	["Character"] = {
		["Water Walk"] = false,
		["Disable Swim"] = true
	},
	["Auto Buy Rod"] = {
		["Enable"] = true,
		["Rod"] = "Reinforced Rod"
	},
	["Auto Merlin"] = {
		["Lucky"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Minute"] = 240
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden