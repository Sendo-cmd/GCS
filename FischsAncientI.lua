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
		["Fish Location"] = {
			["Enable"] = true,
			["Postion"] = "-1068.05383, -354.774658, -3108.94263, -0.573466957, -0.000531586353, 0.81922853, -3.90871173e-05, 0.999999821, 0.000621525047, -0.819228709, 0.00032440279, -0.573466837",
			["Auto"] = true,
			["Zone"] = "Ancient Isle Pond",
			["Height"] = 10
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
getgenv().Key = "k517c79e9160307a9b87210d"
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(1)until Joebiden
