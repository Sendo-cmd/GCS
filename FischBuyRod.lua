repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Inventory"] = {
		["Auto Favourite"] = {
			["Weight"] = 1000,
			["Enable"] = false
		},
		["Auto Sell"] = {
			["Enable"] = true,
			["Delay"] = 1
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Fish Location"] = {
			["Postion"] = "-1068.05383, -354.774658, -3108.94263, -0.573466957, -0.000531586353, 0.81922853, -3.90871173e-05, 0.999999821, 0.000621525047, -0.819228709, 0.00032440279, -0.573466837",
			["Auto"] = true,
			["Zone"] = "Desolate Deep",
			["Height"] = 20
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
		["Disable Swim"] = true,
		["Water Walk"] = true
	},
	["Auto Buy Rod"] = {
		["Enable"] = true,
		["Rod"] = "Kings Rod"
	},
	["Performance"] = {
		["Boost FPS"] = true
	},
	["Auto Merlin"] = {
		["Lucky"] = false,
		["Power"] = false
	},
	["Performance Failsafe"] = {
		["Ping Freeze"] = true,
		["Rejoin Timer"] = {
			["Enable"] = true,
			["Minute"] = 240
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden