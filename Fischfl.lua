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
			["Delay"] = 1
		}
	},
	["Character"] = {
		["Disable Swim"] = true,
		["Water Walk"] = true
	},
	["Auto Buy Rod"] = {
		["Enable"] = true,
		["Rod"] = "Rapid Rod"
	},
	["Performance"] = {
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Fish Location"] = {
			["Postion"] = "-1068.05383, -354.774658, -3108.94263, -0.573466957, -0.000531586353, 0.81922853, -3.90871173e-05, 0.999999821, 0.000621525047, -0.819228709, 0.00032440279, -0.573466837",
			["Auto"] = true,
			["Zone"] = "Desolate Deep",
			["Height"] = 20
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 90,
		["Enable"] = true,
		["Fail Chance"] = 5
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
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden