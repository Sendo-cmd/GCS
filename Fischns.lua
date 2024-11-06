repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Inventory"] = {
		["Auto Favourite"] = {
			["Enable"] = true,
			["Weight"] = 1000
		},
		["Auto Sell"] = {
			["Enable"] = false,
			["Delay"] = 1
		}
	},
	["AutoSave"] = true,
	["Performance"] = {
		["Boost FPS"] = true
	},
	["Character"] = {
		["Disable Swim"] = true,
		["Water Walk"] = true
	},
	["Auto Fish"] = {
		["Fish Location"] = {
			["Auto"] = true,
			["Zone"] = "Desolate Deep",
			["Height"] = 20,
			["Postion"] = "-1068.05383, -354.774658, -3108.94263, -0.573466957, -0.000531586353, 0.81922853, -3.90871173e-05, 0.999999821, 0.000621525047, -0.819228709, 0.00032440279, -0.573466837"
		},
		["Enable"] = true,
		["Perfect Chance"] = 90,
		["Cast Threshold"] = 95,
		["Fail Chance"] = 5
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