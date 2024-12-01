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
		["Enable"] = true,
		["Fish Location"] = {
			["Postion"] = "-1829.55151, -140.718445, -3430.51538, 0.729890466, -0.00714960601, 0.683526635, 9.23482091e-09, 0.999945223, 0.0104593569, -0.683564007, -0.00763413589, 0.729850531",
			["Manual"] = true,
			["Height"] = -50
		},
		["Enable"] = true,
		["Perfect Chance"] = 90,
		["Cast Threshold"] = 95,
		["Fail Chance"] = 5
	},
	["Auto Bait"] = {
		["Equip Random"] = true
	},
	["Character"] = {
		["Disable Swim"] = true
	},
	["Auto Buy Rod"] = {
		["Enable"] = true,
		["Rod"] = "	Reinforced Rod"
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Minute"] = 240
		},
		["Ping Freeze"] = false,
		["Auto Rejoin"] = false
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
