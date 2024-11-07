repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Inventory"] = {
		["Auto Favourite"] = {
			["Weight"] = 1000,
			["Enable"] = true
		},
		["Auto Sell"] = {
			["Enable"] = true,
			["Delay"] = 1
		}
	},
	["AutoSave"] = true,
	["Webhook"] = {
		["Mention"] = "338993710278639626",
		["Fish Catched"] = {
			["Enable"] = true,
			["Minimum Weight"] = 20000,
			["Rarity"] = {
				["Event"] = true,
				["Divine"] = true,
				["Legendary"] = true,
				["Mythical"] = true,
				["Relic"] = true
			}
		},
		["URL"] = "https://discord.com/api/webhooks/1016102161689612338/sjdnR-tIozI-JO_gFSy9nZ7G2PV51hJdH7jn4sK4chO7sM4Ab5igib97uQZ6azN1WyX2"
	},
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
	["Auto Bait"] = {
		["Equip Random"] = true
	},
	["Character"] = {
		["Disable Swim"] = true,
		["Water Walk"] = true
	},
	["Performance"] = {
		["Boost FPS"] = true
	},
	["Auto Merlin"] = {
		["Lucky"] = true,
		["Power"] = true
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