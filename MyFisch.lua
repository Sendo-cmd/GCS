repeat task.wait() until game:IsLoaded()
getgenv().Config = {
	["Inventory"] = {
		["Auto Sell"] = {
			["Enable"] = true,
			["Rarity"] = {
				["Legendary"] = true,
				["Mythical"] = true
			},
			["Delay"] = 2
		}
	},
	["AutoSave"] = true,
	["Auto Fish"] = {
		["Enable"] = true,
		["Shark Event"] = {
			["Great Hammerhead Shark"] = true,
			["Whale Shark"] = true,
			["The Depths - Serpent"] = true,
			["Great White Shark"] = true
		},
		["Fish Location"] = {
			["Postion"] = "991.571472, -736.508057, 1468.57776, -0.925201833, -0.0035395748, 0.379458755, 3.99578646e-08, 0.999956429, 0.00932770688, -0.379475236, 0.00862997305, -0.9251616",
			["Manual"] = true,
			["Height"] = -50
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 5
	},
	["Character"] = {
		["Disable Swim"] = true
	},
	["Performance"] = {
		["Fullbright"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true
	},
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
getgenv().Key = "sZoENIPLYqhElsjhrFywrbFsAGeUzAdm"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden