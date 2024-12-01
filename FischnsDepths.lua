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
			["Delay"] = 5
		}
	},
	["Character"] = {
		["Disable Swim"] = true,
		["Water Walk"] = false
	},
	["Auto Buy Rod"] = {
		["Enable"] = false,
		["Rod"] = "Rapid Rod"
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Enable"] = true,
		["Fish Location"] = {
			["Postion"] = "991.571472, -736.508057, 1468.57776, -0.925201833, -0.0035395748, 0.379458755, 3.99578646e-08, 0.999956429, 0.00932770688, -0.379475236, 0.00862997305, -0.9251616",
			["Manual"] = true,
			["Height"] = -50
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 0
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
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
