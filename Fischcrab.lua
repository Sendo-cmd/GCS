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
			["Height"] = 10
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Character"] = {
		["Disable Swim"] = true,
		["Water Walk"] = true
	},
	["Auto Cage"] = {
		["Buy Amount"] = 1000,
		["Deploy Position"] = "-1496.96936, -233.245621, -2855.18481, 0.791740954, 0.00586142624, -0.610828757, 2.69434973e-12, 0.999953926, 0.00959547795, 0.610856831, -0.00759708602, 0.791704535",
		["Check Delay"] = 2,
		["Enable"] = true,
		["Only Deploy if no Cage"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Enable"] = false,
			["Minute"] = 240
		},
		["Ping Freeze"] = false,
		["Auto Rejoin"] = false
	}
}
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden