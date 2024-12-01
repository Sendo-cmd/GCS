getgenv().Config = {
	["Inventory"] = {
		["Auto Favourite"] = {
			["Weight"] = 1000,
			["Enable"] = true,
			["Unfavourite if unmatch"] = true
		},
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
	["Character"] = {
		["Disable Swim"] = true
	},
	["Auto Fish"] = {
		["Enable"] = true,
		["Shark Event"] = {
			["Great Hammerhead Shark"] = true,
			["Whale Shark"] = true,
			["The Depths - Serpent"] = true,
			["Great White Shark"] = true
		},
		["Fish Location"] = {
			["Height"] = 20,
			["Auto"] = true,
			["Zone"] = "Ancient Isle Waterfall"
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 50,
		["Fail Chance"] = 0
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
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
