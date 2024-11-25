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
		["Disable Swim"] = true
	},
	["Auto Fish"] = {
		["Fish Location"] = {
			["Manual"] = true,
			["Zone"] = "Forsaken Shores",
			["Height"] = 10,
			["Postion"] = "-2767.40137, 218.448456, 1706.4574, 0.923110366, -0.0047447714, 0.384505719, 4.14838632e-06, 0.999924064, 0.0123290857, -0.384534955, -0.0113794589, 0.92304033"
		},
		["Cast Threshold"] = 95,
		["Enable"] = true,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["AutoSave"] = true,
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
	["Auto Merlin"] = {
		["Lucky"] = true
	},
	["Auto Treasure Map"] = true,
	["Auto Aurora Totem"] = {
		["Use Sundial if Day"] = true,
		["Enable"] = true
	},
	["Performance Failsafe"] = {
		["Rejoin Timer"] = {
			["Minute"] = 60
		}
	}
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden