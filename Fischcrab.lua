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
		["Buy Amount"] = 1000,
		["Deploy Position"] = "352.752777, 133.371765, 179.832611, 0.939435005, 0.00345680909, -0.342709512, -1.0910771e-07, 0.999949098, 0.0100859497, 0.342726946, -0.00947500113, 0.939387202",
		["Check Delay"] = 10,
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