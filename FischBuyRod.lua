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
			["Postion"] = "-1068.05383, -354.774658, -3108.94263, -0.573466957, -0.000531586353, 0.81922853, -3.90871173e-05, 0.999999821, 0.000621525047, -0.819228709, 0.00032440279, -0.573466837",
			["Auto"] = true,
			["Zone"] = "Forsaken Shores",
			["Height"] = 10
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
		["Rod"] = "Trident Rod"
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
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden