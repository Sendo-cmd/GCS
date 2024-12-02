-- Island
--[[

Vertigo
The Depths
Brine Pool
Desolate Deep
]]

-- Rod
--[[
Aurora
Trident Rod
Rod Of The Depth
]]

_G.User = {
    ["SKYLOL4ND"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = true,
        ["Spot"] = "Vertigo",
    },
    ["mooqill_945775"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["CGGGG098L"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Forsaken Shores",
    },
	["Himura_150266"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["ivysosad7"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["qpsSXxqp"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["RockMeepBats"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "The Depths",
    },
	["KunaiZLeaf"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["Noslots56"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Brine Pool",
    },
	["supakitdunk"] = {
        ["Rod Quest"] = "", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = true,
        ["WorldEvent"] = false,
        ["Spot"] = "Ancient IsIe",
    },
	["nine639085"] = {
        ["Rod Quest"] = "Rod Of The Depth", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = false,
        ["WorldEvent"] = false,
        ["Spot"] = "",
    },
	["didbdknend"] = {
        ["Rod Quest"] = "Trident Rod", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = false,
        ["WorldEvent"] = false,
        ["Spot"] = "Desolate Deep",
    },
    ["GCshopfour"] = {
        ["Rod Quest"] = "Trident Rod", 
        ["Bestiary"] = {},
        ["Auto Buy Luck"] = false,
        ["WorldEvent"] = false,
        ["Spot"] = "",
    },
}





repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer
local tloading = tick() + 5
local loading
repeat task.wait()
    loading = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("loading")
until tick() >= tloading or loading

while loading and loading.Enabled do task.wait()
    if loading.Enabled and loading.loading.skip.Visible then
        local skip = loading.loading.skip
        skip.AnchorPoint = Vector2.new(.5,.5)
        skip.Position = UDim2.fromScale(.5,.5)
        skip.Size = UDim2.fromScale(9999,9999)
        print("Skip")
    end
    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
end 
print("loading")
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("assetsloaded") and game:GetService("Players").LocalPlayer.assetsloaded.Value
print("assetsloaded")

local AutoShake = true
local ShakeUI = false
local InstantFish = true

local Settings = {
    ["Rod Quest"] = "", -- Aurora , Trident , Rod Of The Depth
    ["Bestiary"] = {},
    ["Method"] = "Instant", -- Hold , Instant
    ["WorldEvent"] = true,
    ["Auto Buy Luck"] = true,
    ["Fish Count"] = 20,
    ["Failed Every"] = 50,
    ["Auto Sell"] = true,
    ["Spot"] = "",
}

for i,v in pairs(_G.User[plr.Name]) do
    Settings[i] = v
end
local Configs = {
    ["Vertigo"] = {
        ["Type"] = "Special",
        ["Ignore"] = {"Isonade"},
        ["Function"] = function()
            return workspace.zones.fishing:FindFirstChild("Isonade")
        end,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-116.287933, -773.175171, 1249.52307, 0.980790615, 6.64242452e-06, -0.195063397, 2.62815725e-08, 1, 3.41847881e-05, 0.195063397, -3.35332479e-05, 0.980790615),
        ["Cage Spot"] = true,
        ["Cage"] = {
            [1] = CFrame.new(-110.5623779296875, -732.562744140625, 1208.9698486328125, -0.12402346730232239, 0, 0.9922792911529541, 0, 1, -0, -0.9922792911529541, 0, -0.12402346730232239),
            [2] = CFrame.new(-109.78691101074219, -733.1256713867188, 1212.3621826171875, -0.679056704044342, 0, 0.7340858578681946, 0, 1, -0, -0.7340859174728394, 0, -0.6790566444396973),
            [3] = CFrame.new(-105.93616485595703, -733.5018920898438, 1214.2637939453125, -0.974246084690094, 0, 0.22548745572566986, 0, 1.0000001192092896, -0, -0.22548742592334747, 0, -0.9742462038993835),
            [4] = CFrame.new(-103.19263458251953, -733.5380859375, 1213.36376953125, -0.8581687211990356, -0, -0.513367772102356, -0, 1.0000001192092896, -0, 0.5133677124977112, 0, -0.8581688404083252),
            [5] = CFrame.new(-99.75703430175781, -733.891357421875, 1211.136962890625, -0.5101168751716614, -0, -0.8601050972938538, -0, 1, -0, 0.8601050972938538, 0, -0.5101168751716614),
            [6] = CFrame.new(-100.2508544921875, -733.4586181640625, 1210.013427734375, 0.5531145930290222, 0, -0.8331052660942078, -0, 1, -0, 0.8331051468849182, 0, 0.553114652633667),
            [7] = CFrame.new(-103.97340393066406, -732.5985717773438, 1204.934814453125, 0.6484333872795105, 0, -0.7612714171409607, -0, 1, -0, 0.7612714171409607, 0, 0.6484333872795105),
            [8] = CFrame.new(-107.40616607666016, -732.9832153320312, 1203.1317138671875, 0.9486802816390991, 0, -0.3162369132041931, -0, 1, -0, 0.3162369132041931, 0, 0.9486802816390991),
            [9] = CFrame.new(-110.78844451904297, -733.8175048828125, 1202.7626953125, 0.9632145762443542, 0, 0.2687336206436157, -0, 1, -0, -0.2687336206436157, 0, 0.9632145762443542),
            [10] = CFrame.new(-112.4709243774414, -734.2554321289062, 1204.0234375, 0.4012398421764374, 0, 0.9159730672836304, -0, 1.0000001192092896, -0, -0.9159730672836304, 0, 0.4012398421764374),
            [11] = CFrame.new(-81.1644515991211, -736.7918701171875, 1210.705078125, 0.9761608839035034, 0, -0.21704840660095215, -0, 1.0000001192092896, -0, 0.21704840660095215, 0, 0.9761608839035034),
            [12] = CFrame.new(-83.14614868164062, -736.7919921875, 1209.240966796875, 0.8059407472610474, 0, 0.5919962525367737, -0, 1, -0, -0.5919962525367737, 0, 0.8059407472610474),
            [13] = CFrame.new(-83.56304168701172, -736.7918701171875, 1210.1138916015625, -0.9063321948051453, 0, 0.42256593704223633, 0, 1, -0, -0.42256593704223633, 0, -0.9063321948051453),
            [14] = CFrame.new(-81.23065948486328, -736.7918701171875, 1210.6605224609375, -0.8521823883056641, -0, -0.5232449769973755, -0, 1.0000001192092896, -0, 0.5232449769973755, 0, -0.8521823883056641),
            [15] = CFrame.new(-73.25164794921875, -736.7919311523438, 1201.5289306640625, 0.6956862807273865, 0, 0.7183458209037781, -0, 1.0000001192092896, -0, -0.7183458209037781, 0, 0.6956862807273865),
            [16] = CFrame.new(-70.86898040771484, -736.7919921875, 1203.6920166015625, 0.9611135125160217, 0, -0.2761538028717041, -0, 1.0000001192092896, -0, 0.2761538028717041, 0, 0.9611135125160217),
            [17] = CFrame.new(-113.95768737792969, -733.5438232421875, 1170.3140869140625, -0.6145231127738953, -0, -0.7888988256454468, -0, 1, -0, 0.7888989448547363, 0, -0.6145230531692505),
            [18] = CFrame.new(-114.95075988769531, -731.8487548828125, 1175.0860595703125, -0.9306821227073669, -0, -0.3658289611339569, -0, 1, -0, 0.3658289611339569, 0, -0.9306821227073669),
            [19] = CFrame.new(-116.61880493164062, -733.59619140625, 1171.90966796875, -0.8340017795562744, 0, 0.5517617464065552, 0, 1.0000001192092896, -0, -0.5517616868019104, 0, -0.834001898765564),
            [20] = CFrame.new(-120.38595581054688, -732.205322265625, 1162.775146484375, 0.9989672303199768, 0, -0.045438118278980255, -0, 1.0000001192092896, -0, 0.045438118278980255, 0, 0.9989672303199768),
            [21] = CFrame.new(-116.91490936279297, -734.92578125, 1168.0013427734375, 0.9061365723609924, 0, -0.4229852855205536, -0, 1, -0, 0.4229852855205536, 0, 0.9061365723609924),
            [22] = CFrame.new(-120.2018051147461, -737.4240112304688, 1170.3963623046875, -0.3728030323982239, 0, 0.9279105067253113, 0, 1.0000001192092896, -0, -0.9279106259346008, 0, -0.3728030025959015),
            [23] = CFrame.new(-144.14918518066406, -736.40478515625, 1217.0267333984375, -0.0274659376591444, 0, 0.9996228218078613, 0, 1.0000001192092896, -0, -0.9996228218078613, 0, -0.0274659376591444),
            [24] = CFrame.new(-146.18077087402344, -736.40478515625, 1213.4029541015625, 0.505372166633606, 0, 0.862901508808136, -0, 1.0000001192092896, -0, -0.8629016280174255, 0, 0.5053721070289612),
            [25] = CFrame.new(-144.7253875732422, -736.40478515625, 1211.187255859375, 0.9694129228591919, 0, 0.2454356700181961, -0, 1.0000001192092896, -0, -0.2454356700181961, 0, 0.9694129228591919),
            [26] = CFrame.new(-141.35733032226562, -736.40478515625, 1211.7459716796875, 0.8939444422721863, 0, -0.4481777548789978, -0, 1, -0, 0.448177695274353, 0, 0.8939445614814758),
            [27] = CFrame.new(-139.35604858398438, -736.40478515625, 1214.426025390625, 0.30298134684562683, 0, -0.952996551990509, -0, 1.0000001192092896, -0, 0.952996551990509, 0, 0.30298134684562683),
            [28] = CFrame.new(-140.22352600097656, -736.40478515625, 1219.599853515625, -0.0554201602935791, -0, -0.9984631538391113, -0, 1.0000001192092896, -0, 0.9984631538391113, 0, -0.0554201602935791),
            [29] = CFrame.new(-143.25035095214844, -736.40478515625, 1218.958984375, -0.8360427021980286, 0, 0.5486645102500916, 0, 1.0000001192092896, -0, -0.5486645102500916, 0, -0.8360427021980286),
            [30] = CFrame.new(-129.03115844726562, -736.990478515625, 1228.9423828125, 0.893092691898346, 0, -0.44987285137176514, -0, 1.0000001192092896, -0, 0.44987285137176514, 0, 0.893092691898346),
            [31] = CFrame.new(-128.02806091308594, -736.8638305664062, 1231.3905029296875, 0.24572426080703735, 0, -0.9693397879600525, -0, 1, -0, 0.9693397879600525, 0, 0.24572426080703735),
            [32] = CFrame.new(-128.61270141601562, -736.8638305664062, 1234.47216796875, -0.4665537476539612, -0, -0.8844928741455078, -0, 1, -0, 0.8844928741455078, 0, -0.4665537476539612),
            [33] = CFrame.new(-135.14398193359375, -736.8638305664062, 1238.017578125, -0.9986636638641357, 0, 0.05168185010552406, 0, 1.0000001192092896, -0, -0.05168185010552406, 0, -0.9986636638641357),
            [34] = CFrame.new(-138.67279052734375, -736.8638305664062, 1236.4794921875, -0.768333911895752, 0, 0.6400493383407593, 0, 1.0000001192092896, -0, -0.6400493383407593, 0, -0.768333911895752),
            [35] = CFrame.new(-140.38934326171875, -736.8638305664062, 1233.4818115234375, -0.20752058923244476, 0, 0.9782307147979736, 0, 1.0000001192092896, -0, -0.9782307147979736, 0, -0.20752058923244476),
            [36] = CFrame.new(-125.43831634521484, -736.9212646484375, 1248.4293212890625, 0.3768247663974762, 0, -0.9262846112251282, -0, 1.0000001192092896, -0, 0.9262846112251282, 0, 0.3768247663974762),
            [37] = CFrame.new(-124.46349334716797, -736.92138671875, 1250.3046875, -0.559307873249054, -0, -0.8289600610733032, -0, 1.0000001192092896, -0, 0.8289600610733032, 0, -0.559307873249054),
            [38] = CFrame.new(-127.56007385253906, -736.92138671875, 1251.4783935546875, -0.9756894111633301, -0, -0.21915782988071442, -0, 1.0000001192092896, -0, 0.21915780007839203, 0, -0.9756895303726196),
            [39] = CFrame.new(-128.81842041015625, -736.92138671875, 1252.2315673828125, -0.6508994698524475, 0, 0.7591639757156372, 0, 1, -0, -0.7591639757156372, 0, -0.6508994698524475),
            [40] = CFrame.new(-107.07771301269531, -731.931640625, 1274.520751953125, -0.009521489031612873, 0, 0.9999547004699707, 0, 1.0000001192092896, -0, -0.9999547004699707, 0, -0.009521489031612873),
            [41] = CFrame.new(-106.46041870117188, -731.931640625, 1268.187255859375, 0.27514633536338806, 0, 0.9614022970199585, -0, 1, -0, -0.961402416229248, 0, 0.2751463055610657),
            [42] = CFrame.new(-104.91275024414062, -731.931640625, 1267.408447265625, 0.9796304702758789, 0, 0.20080898702144623, -0, 1.0000001192092896, -0, -0.20080898702144623, 0, 0.9796304702758789),
            [43] = CFrame.new(-98.34042358398438, -731.931640625, 1266.2940673828125, 0.999908447265625, 0, 0.01353495940566063, -0, 1.0000001192092896, -0, -0.01353495940566063, 0, 0.999908447265625),
        },
    },
    ["Ancient IsIe"] = {
        ["Type"] = "Normal",
        ["Cage Spot"] = false,
        ["Ignore"] = {},
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(5859.06494, 104.494919, 412.9646, 0.501003683, -5.7265559e-05, 0.865445137, -1.65918436e-07, 1, 6.62649545e-05, -0.865445137, -3.33425814e-05, 0.501003683),
        ["Cage"] = {
        },
    },
	["Forsaken Shores"] = {
        ["Type"] = "Normal",
        ["Cage Spot"] = false,
        ["Ignore"] = {},
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-2688.07202, 156.49649, 1757.56653, 0.673388839, -4.00082135e-05, 0.739288509, 2.68067168e-07, 1, 5.38730164e-05, -0.739288509, -3.60793092e-05, 0.673388839),
        ["Cage"] = {
        },
    },
    ["The Depths"] = {
        ["Type"] = "Normal",
        ["Cage Spot"] = false,
        ["Ignore"] = {},
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(950.88324, -760.072144, 1455.11475, -0.983053923, 2.03034887e-08, 0.183316663, -3.68314823e-09, 1, -1.30507615e-07, -0.183316663, -1.28971209e-07, -0.983053923),
        ["Cage"] = {
        },
    },
    ["Brine Pool"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-1831.57166, -142.693146, -3430.53662, 0.12380068, -9.88392159e-08, 0.992307127, -1.63987268e-09, 1, 9.9810066e-08, -0.992307127, -1.39838106e-08, 0.12380068),
        ["Cage"] = {
        },
    },
	["The Sunstone"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(5793.5234375, 129.99000549316406, 397.7882385253906, 0.7848547101020813, 0, -0.6196799278259277, -0, 1.0000001192092896, -0, 0.6196799278259277, 0, 0.7848547101020813),
        ["Cage"] = {
        },
    },
	["MooseWood"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(314.335144, 108.450478, 266.987305, 0.0372193605, -2.77505774e-06, 0.999307096, 8.12589604e-08, 1, 2.77395543e-06, -0.999307096, -2.20421885e-08, 0.0372193605),
        ["Cage"] = {
        },
    },
	["Snowcap Island"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(2856.61206, 110.609444, 2627.62231, -0.966820002, -8.82622544e-07, 0.255458504, 2.90028055e-07, 1, 4.55270583e-06, -0.255458504, 4.47573757e-06, -0.966820002),
        ["Cage"] = {
        },
    },
	["Roslit Bay"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-1526.93994, 112.73819, 592.267212, 0.999723256, 1.76769584e-06, -0.0235235505, -2.11808739e-07, 1, 6.61441663e-05, 0.0235235505, -6.61208833e-05, 0.999723256),
        ["Cage"] = {
        },
    },
	["Statue of Sovereignty"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(57.6169548, 118.076836, -1007.81873, -0.744127989, -9.30150145e-06, -0.668037057, -8.0894722e-08, 1, -1.38335226e-05, 0.668037057, -1.02398708e-05, -0.744127989),
        ["Cage"] = {
        },
    },
	["The Arch"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(992.88324, 99.3194733, -1223.65796, -0.910250425, -2.91566653e-06, -0.414058149, 1.7392216e-07, 1, -7.4240279e-06, 0.414058149, -6.8297386e-06, -0.910250425),
        ["Cage"] = {
        },
    },
	["Terrapin Island"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-63.4014778, 114.499252, 1993.83252, -0.944896638, 4.57896613e-06, -0.327368826, -8.64592238e-08, 1, 1.4236728e-05, 0.327368826, 1.34805405e-05, -0.944896638),
        ["Cage"] = {
        },
    },
	["Earmark Island"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(),
        ["Cage"] = {
        },
    },
	["Mushgrove Swamp"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(2490.48682, 116.819595, -723.146484, -0.132600114, 9.9487379e-06, 0.991169631, 1.20419905e-08, 1, -1.00357611e-05, -0.991169631, -1.31880745e-06, -0.132600114),
        ["Cage"] = {
        },
    },
	["Roslit Volcano"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = false,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-1928.39136, 151.841339, 325.43335, 0.980352521, 1.31087319e-08, 0.197253615, -3.33541261e-09, 1, -4.98791977e-08, -0.197253615, 4.82412723e-08, 0.980352521),
        ["Cage"] = {
        },
    },
    ["Desolate Deep"] = {
        ["Type"] = "Normal",
        ["Ignore"] = {},
        ["Cage Spot"] = true,
        ["Cage Limit"] = 5,
        ["Spot"] = CFrame.new(-1498.17114, -260.660095, -2863.77563),
        ["Cage"] = {
            [1] = CFrame.new(-1640.432373046875, -231.07330322265625, -2878.90283203125, 0.14111372828483582, 0, 0.9899933934211731, -0, 1, -0, -0.9899933934211731, 0, 0.14111372828483582),
            [2] = CFrame.new(-1639.7362060546875, -231.073486328125, -2884.483154296875, 0.30591830611228943, 0, 0.9520577788352966, -0, 1, -0, -0.9520577788352966, 0, 0.30591830611228943),
            [3] = CFrame.new(-1637.574951171875, -231.072509765625, -2890.10009765625, 0.3901297450065613, 0, 0.920759916305542, -0, 1, -0, -0.920759916305542, 0, 0.3901297450065613),
            [4] = CFrame.new(-1635.16845703125, -231.07301330566406, -2894.06298828125, 0.6813260912895203, 0, 0.73198002576828, -0, 1, -0, -0.7319800853729248, 0, 0.6813260316848755),
            [5] = CFrame.new(-1630.8963623046875, -231.07203674316406, -2898.502685546875, 0.8667744398117065, 0, 0.49870049953460693, -0, 1.0000001192092896, -0, -0.49870049953460693, 0, 0.8667744398117065),
            [6] = CFrame.new(-1625.6534423828125, -231.07373046875, -2900.565185546875, 0.9384785890579224, 0, 0.3453376591205597, -0, 1.0000001192092896, -0, -0.3453376591205597, 0, 0.9384785890579224),
            [7] = CFrame.new(-1622.0379638671875, -231.0752410888672, -2902.20068359375, 0.9907766580581665, 0, -0.13550542294979095, -0, 1.0000001192092896, -0, 0.13550542294979095, 0, 0.9907766580581665),
            [8] = CFrame.new(-1616.26513671875, -231.0748291015625, -2900.42138671875, 0.9649692177772522, 0, -0.2623632252216339, -0, 1, -0, 0.2623632252216339, 0, 0.9649692177772522),
            [9] = CFrame.new(-1610.093017578125, -231.0753936767578, -2898.991455078125, 0.9375675916671753, 0, -0.34780335426330566, -0, 1, -0, 0.34780338406562805, 0, 0.9375674724578857),
            [10] = CFrame.new(-1602.0850830078125, -231.07598876953125, -2897.44384765625, 0.9809358716011047, 0, -0.19433175027370453, -0, 1, -0, 0.19433175027370453, 0, 0.9809358716011047),
            [11] = CFrame.new(-1595.0457763671875, -235.12220764160156, -2899.494384765625, 0.9809358716011047, 0, -0.19433175027370453, -0, 1, -0, 0.19433175027370453, 0, 0.9809358716011047),
            [12] = CFrame.new(-1588.02734375, -235.1234588623047, -2901.4501953125, 0.9789763689041138, 0, -0.20397375524044037, -0, 1, -0, 0.20397375524044037, 0, 0.9789763689041138),
            [13] = CFrame.new(-1581.585205078125, -235.1239013671875, -2900.20263671875, 0.9768857359886169, 0, -0.21376241743564606, -0, 1.0000001192092896, -0, 0.21376241743564606, 0, 0.9768857359886169),
            [14] = CFrame.new(-1575.14111328125, -235.1242218017578, -2899.141357421875, 0.9768857359886169, 0, -0.21376241743564606, -0, 1.0000001192092896, -0, 0.21376241743564606, 0, 0.9768857359886169),
            [15] = CFrame.new(-1568.0150146484375, -235.1244659423828, -2897.462158203125, 0.9768857359886169, 0, -0.21376241743564606, -0, 1.0000001192092896, -0, 0.21376241743564606, 0, 0.9768857359886169),
            [16] = CFrame.new(-1563.735595703125, -235.1245574951172, -2894.217529296875, 0.8606007099151611, 0, -0.5092803239822388, -0, 1, -0, 0.5092803239822388, 0, 0.8606007099151611),
            [17] = CFrame.new(-1557.283935546875, -235.123046875, -2889.208984375, 0.9305168390274048, 0, -0.36624908447265625, -0, 1, -0, 0.36624908447265625, 0, 0.9305168390274048),
            [18] = CFrame.new(-1550.5177001953125, -234.70245361328125, -2885.85986328125, 0.9567581415176392, 0, -0.29088473320007324, -0, 1.0000001192092896, -0, 0.29088473320007324, 0, 0.9567581415176392),
            [19] = CFrame.new(-1543.899658203125, -234.7067108154297, -2882.92919921875, 0.9567241668701172, 0, -0.2909964621067047, -0, 1, -0, 0.2909964621067047, 0, 0.9567241668701172),
            [20] = CFrame.new(-1537.464599609375, -234.71026611328125, -2881.787353515625, 0.941066324710846, 0, -0.33822235465049744, -0, 1.0000001192092896, -0, 0.3382223844528198, 0, 0.9410662055015564),
            [21] = CFrame.new(-1531.46337890625, -234.70556640625, -2879.51123046875, 0.9304336905479431, 0, -0.36646050214767456, -0, 1.0000001192092896, -0, 0.36646050214767456, 0, 0.9304336905479431),
            [22] = CFrame.new(-1525.3125, -234.71176147460938, -2877.323486328125, 0.9267749190330505, 0, -0.37561729550361633, -0, 1.0000001192092896, -0, 0.37561729550361633, 0, 0.9267749190330505),
            [23] = CFrame.new(-1519.61328125, -234.7176513671875, -2875.06103515625, 0.8847540020942688, 0, -0.4660583436489105, -0, 1, -0, 0.4660583436489105, 0, 0.8847540020942688),
            [24] = CFrame.new(-1515.8604736328125, -234.7168731689453, -2871.29345703125, 0.7356827855110168, 0, -0.6773262619972229, -0, 1, -0, 0.6773262619972229, 0, 0.7356827855110168),
            [25] = CFrame.new(-1511.1446533203125, -234.716796875, -2866.70703125, 0.7289735674858093, 0, -0.6845418214797974, -0, 1, -0, 0.6845418214797974, 0, 0.7289735674858093),
            [26] = CFrame.new(-1506.31103515625, -234.71676635742188, -2861.99267578125, 0.7289735674858093, 0, -0.6845418214797974, -0, 1, -0, 0.6845418214797974, 0, 0.7289735674858093),
            [27] = CFrame.new(-1501.7220458984375, -234.71826171875, -2857.613525390625, 0.700976550579071, 0, -0.7131844162940979, -0, 1.0000001192092896, -0, 0.7131844162940979, 0, 0.700976550579071),
            [28] = CFrame.new(-1500.088134765625, -234.71734619140625, -2852.35888671875, 0.45996081829071045, 0, -0.8879392147064209, -0, 1, -0, 0.8879392147064209, 0, 0.45996081829071045),
            [29] = CFrame.new(-1496.9095458984375, -234.7154541015625, -2846.854736328125, 0.42406797409057617, 0, -0.905630350112915, -0, 1.0000001192092896, -0, 0.9056304693222046, 0, 0.4240679144859314),
            [30] = CFrame.new(-1496.343505859375, -234.7186737060547, -2842.031005859375, 0.05907979980111122, 0, -0.9982532858848572, -0, 1, -0, 0.9982532858848572, 0, 0.05907979980111122),
            [31] = CFrame.new(-1496.1448974609375, -234.71029663085938, -2835.436279296875, 0.019041839987039566, 0, -0.9998186826705933, -0, 1, -0, 0.9998186826705933, 0, 0.019041839987039566),
            [32] = CFrame.new(-1496.2677001953125, -234.71099853515625, -2829.065185546875, -0.04052867740392685, -0, -0.999178409576416, -0, 1, -0, 0.999178409576416, 0, -0.04052867740392685),
            [33] = CFrame.new(-1500.0474853515625, -234.7106170654297, -2824.791259765625, -0.4431559145450592, -0, -0.89644455909729, -0, 1, -0, 0.89644455909729, 0, -0.4431559145450592),
            [34] = CFrame.new(-1503.3951416015625, -234.71078491210938, -2819.181640625, -0.4609798789024353, -0, -0.8874106407165527, -0, 1.0000001192092896, -0, 0.8874106407165527, 0, -0.4609798789024353),
            [35] = CFrame.new(-1504.0621337890625, -233.7147216796875, -2809.643310546875, -0.22240717709064484, -0, -0.974953830242157, -0, 1, -0, 0.9749539494514465, 0, -0.22240714728832245),
            [36] = CFrame.new(-1500.44091796875, -233.71739196777344, -2796.759765625, 0.4289572238922119, 0, -0.9033248424530029, -0, 1, -0, 0.9033248424530029, 0, 0.4289572238922119),
            [37] = CFrame.new(-1497.6759033203125, -233.71803283691406, -2792.9306640625, 0.09423305839300156, 0, -0.9955501556396484, -0, 1.0000001192092896, -0, 0.995550274848938, 0, 0.09423304349184036),
            [38] = CFrame.new(-1497.417724609375, -233.71798706054688, -2786.595703125, 0.01464865356683731, 0, -0.9998927116394043, -0, 1, -0, 0.9998927116394043, 0, 0.01464865356683731),
            [39] = CFrame.new(-1497.5908203125, -233.7180633544922, -2780.237060546875, -0.015136832371354103, -0, -0.9998854398727417, -0, 1, -0, 0.9998854398727417, 0, -0.015136832371354103),
            [40] = CFrame.new(-1498.7174072265625, -233.718505859375, -2776.23779296875, -0.46044543385505676, -0, -0.8876879811286926, -0, 1, -0, 0.8876879811286926, 0, -0.46044543385505676),
        },
    },

    
    ["Spot"] = {
        ["Cage"] = CFrame.new(473.422729, 150.500015, 233.171906, 0.561099231, -4.96632468e-09, -0.827748537, 2.4843454e-09, 1, -4.31575531e-09, 0.827748537, 3.65153796e-10, 0.561099231),
        ["ReSize"] = CFrame.new(452.998932, 150.501007, 210.530563, 0.998719037, -6.43949605e-08, -0.0505997166, 6.92212652e-08, 1, 9.36296374e-08, 0.0505997166, -9.70122755e-08, 0.998719037),
        ["Sell"] = CFrame.new(466.057648, 151.002014, 221.655106, -0.99920857, 5.27215533e-08, -0.0397778861, 5.37141354e-08, 1, -2.38843398e-08, 0.0397778861, -2.60020716e-08, -0.99920857),
        ["Money"] = CFrame.new(950.88324, -785.072144, 1455.11475, -0.983053923, 2.03034887e-08, 0.183316663, -3.68314823e-09, 1, -1.30507615e-07, -0.183316663, -1.28971209e-07, -0.983053923),
        ["Abyssal"] = CFrame.new(1205.94592, -716.603271, 1316.79919, -0.747035146, -1.32305598e-08, -0.664784491, -5.45847234e-09, 1, -1.37682044e-08, 0.664784491, -6.65662503e-09, -0.747035146),
        ["Hexed"] = CFrame.new(1053.6366, -633.240051, 1319.92493, -0.0151671488, 2.11938804e-08, -0.999884963, -3.35075723e-09, 1, 2.12471463e-08, 0.999884963, 3.67263042e-09, -0.0151671488),
        ["Rod Of The Depths"] = CFrame.new(1704.98462, -902.526978, 1444.8667, -0.955516875, 6.92898183e-09, 0.294936389, 2.08239772e-08, 1, 4.39711094e-08, -0.294936389, 4.81568883e-08, -0.955516875),
        ["DepthGate"] = CFrame.new(13.6440973, -706.123718, 1224.80481, 0.209638149, -7.89109365e-08, -0.977779031, -9.93821736e-09, 1, -8.28350437e-08, 0.977779031, 2.70827663e-08, 0.209638149),
        ["Merlin"] = CFrame.new(-926.218628, 223.699966, -999.468018, -0.59410423, 3.34793846e-08, 0.804388106, -6.07307555e-08, 1, -8.64754028e-08, -0.804388106, -1.00226501e-07, -0.59410423),
        ["Trident Rod"] = CFrame.new(-1482.61572, -225.986481, -2199.30786, -0.840630472, 8.83173645e-10, 0.541609049, -1.92019201e-08, 1, -3.14339168e-08, -0.541609049, -3.68242432e-08, -0.840630472),
    }
}
coroutine.resume(coroutine.create(function()
    while wait() do
        pcall(function() 
            game:GetService("VirtualInputManager"):SendKeyEvent(true,"W",false,game) task.wait(.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false,"W",false,game)
            wait(1000)
        end)
    end
end))
local StopFarm_ = {}

local time = tick()
local mt = getrawmetatable(game)
local plr = game:GetService("Players").LocalPlayer
local fishs = require(ReplicatedStorage.modules.library.fish)
local function Check_Cage()
    local total = 0 
    for i,v in pairs(workspace.active:GetChildren()) do
        if v.Name == plr.Name then
            total = total + 1
        end
    end
    return total
end
local function Magnitude(Pos1,Pos2)
    local pos1,pos2 = Pos1.Position,Pos2.Position
    local Vec1,Vec2 = Vector3.new(pos1.x,0,pos1.z),Vector3.new(pos2.x,0,pos2.z)
    return (Vec1 - Vec2).Magnitude
end
game:GetService'Players'.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
local KRNLONAIR = Instance.new("BodyVelocity")
KRNLONAIR.Parent = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
KRNLONAIR.Name = "KRNLONAIR"
KRNLONAIR.MaxForce = Vector3.new(100000,100000,100000)
KRNLONAIR.Velocity = Vector3.new(0,0,0)
local function Shake(obj)
    if obj:FindFirstChild("UICorner") then
        obj["UICorner"]:Destroy()
    end
    obj.BackgroundTransparency = 1
    obj.ImageTransparency = 1
    if obj:FindFirstChild("title") then
        obj:FindFirstChild("title"):Destroy()
    end
    
    local UIScale = obj:FindFirstChild("UIScale") or  Instance.new("UIScale",obj)
    UIScale.Scale = 1000
    repeat task.wait()
        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
    until not obj.Parent
end
local function ConnectToReel(v)
    if plr.PlayerGui:FindFirstChild("reel") then
        time = tick() + 2
        if Settings["Method"] == "Instant" then
            repeat wait() 
                ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100,true)
            until not plr.PlayerGui:FindFirstChild("reel")
        else
            plr.PlayerGui.reel.bar.playerbar.Size = UDim2.fromScale(1, 1)
        end
    end
end
local function ConnectToShake(v)
    local safezone = v:WaitForChild("safezone")
    local v1 = safezone:WaitForChild("button")
    Shake(v1)
    local ConnectTo1 = safezone.ChildAdded:Connect(function(v1)
        if v1:IsA("ImageButton") then
            Shake(v1)
        end
    end)
    repeat
        task.wait()
        time = tick() + 1.5
    until not plr.PlayerGui:FindFirstChild(v.Name)
    ConnectTo1:Disconnect()
end
local function TalkNpc(npc)
    plr.CameraMode = Enum.CameraMode.LockFirstPerson
    local Npc = workspace.world.npcs:FindFirstChild(npc)
    local Prompt = Npc:FindFirstChildWhichIsA("ProximityPrompt",true)
    workspace.Camera.CFrame = CFrame.lookAt(workspace.Camera.CFrame.Position,Npc.HumanoidRootPart.Position + Vector3.new(0,0,0))
    Prompt.GamepadKeyCode = Enum.KeyCode.E
    Prompt.RequiresLineOfSight = false
    Prompt.MaxActivationDistance = 50
    game:service('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
    game:service('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
end
local FishCount = 0
local SellTheFish = false
spawn(function()
    if not Settings["Auto Sell"] then return end
    while true do task.wait()
        local val,err = pcall(function()
            if FishCount >= Settings["Fish Count"] then
                SellTheFish = true
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end
                task.wait(.3)
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end 
                if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                    
                else
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                end
                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Sell"].Position).Magnitude >= 10  then
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                else
                    if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                        local tick1 = tick() + 5
                        local tick2 = tick() + .2
                        print("loopin")
                        repeat task.wait() 
                            if tick() >= tick2 then
                                if plr.PlayerGui:FindFirstChild("options") then
                                    for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                        for i1,v1 in pairs(getconnections(plr.PlayerGui.options.safezone["1option"].button[v2])) do
                                            v1.Function()
                                        end
                                    end
                                else
                                    TalkNpc("Marc Merchant")
                                end
                                task.delay(.001,function ()
                                    local Sell = workspace.world.npcs:FindFirstChild("Marc Merchant"):FindFirstChild("sellall",true)
                                    Sell:InvokeServer()
                                end)
                                print("IN")
                                tick2 = tick() + .2
                            end
                        until tick() >= tick1
                        print("loopout")
                        local tick1 = tick() + 2
                        repeat task.wait() 
                           
                        until tick() >= tick1
                        FishCount = 0
                    end
                end
            else
                SellTheFish = false
            end
        end)
        if not val then
            print("Sell : ",err)
        end
    end
end)
local BuyingLuck = false

spawn(function()
    if not Settings["Auto Buy Luck"] then return end
    local tick1 = tick()
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    local function LuckyC()
        for i,v in pairs(plr.PlayerGui.hud.safezone.statuses:GetChildren()) do
            if v:IsA("Frame") and v.icon.Image == "rbxassetid://18198637843" then
                return true
            end
        end
        return false
    end
    while true do task.wait()
        local val,err = pcall(function()
            if tick1 >= tick() then return end
            print("LuckyC")
            if not LuckyC() and playerstats.Stats.coins.Value >= 5000 then
               
                BuyingLuck = true
                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Merlin"]) >= 10 then
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Merlin"]
                else
                    if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                        return
                    end
                    task.wait(.3)
                    if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                        return
                    end 
                    if SellTheFish then
                        return
                    end
                    if workspace.world.npcs:FindFirstChild("Merlin") then
                        TalkNpc("Merlin")
                        spawn(function()
                            pcall(function()
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("luck"):InvokeServer()
                            end)
                        end)
                    end
                end
            else
                tick1 = tick() + 2
                BuyingLuck = false
            end
        end)
        if not val then
            print("Sell : ",err)
        end
    end
end)
spawn(function()
    if not Settings["Auto Sell"] then return end
    while true do task.wait()
        local val,err = pcall(function()
            if FishCount >= Settings["Fish Count"] then
                SellTheFish = true
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end
                task.wait(.3)
                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                    return
                end 
                if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                    
                else
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                end
                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Sell"].Position).Magnitude >= 10  then
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Sell"]
                else
                    if workspace.world.npcs:FindFirstChild("Marc Merchant") then
                        local tick1 = tick() + 5
                       
                        repeat task.wait() 
                            if plr.PlayerGui:FindFirstChild("options") then
                                for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                    for i1,v1 in pairs(getconnections(plr.PlayerGui.options.safezone["1option"].button[v2])) do
                                        v1.Function()
                                    end
                                end
                            else
                                TalkNpc("Marc Merchant")
                            end
                            spawn(function()
                                pcall(function ()
                                    local Sell = workspace.world.npcs:FindFirstChild("Marc Merchant"):FindFirstChild("sellall",true)
                                    Sell:InvokeServer()
                                end)
                            end)
                        until tick() >= tick1
                        FishCount = 0
                    end
                end
            else
                SellTheFish = false
            end
        end)
        if not val then
            print("Sell : ",err)
        end
    end
end)
spawn(function()
    while true do task.wait()
        local val,err = pcall(function()
            local tuck = tick() + 1.5
            local Tool = plr.Character:FindFirstChildWhichIsA("Tool")
            if Tool and Tool:FindFirstChild("rod/client") then
                repeat
                    task.wait()
                until tick() >= tuck
                Tool["rod/client"].Enabled = false
            end
        end)
        if not val then
            print(err)
        end
    end
end)
game:GetService("ReplicatedStorage").events.anno_catch.OnClientEvent:Connect(function(b)
    FishCount = FishCount + 1
end)
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "shakeui" then
        ConnectToShake(v)
    end
end
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "reel" then
        ConnectToReel(v)
    end
end
local connect1 = plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "shakeui" then
        ConnectToShake(v)
    end
end)
local connect2 = plr.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "reel" then
        ConnectToReel(v)
    end
end)

-- Auto Book
local function Book(fish,justfarm)
    local Config = Configs[fish]
    local total = justfarm and {"1","2"} or {}
    local cur_ = {}
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    local AutoFish = false
    local Place = tick()
    local Position = Config["Spot"]
    local Crab = false
    local Stage = false
    local Cahce = false
    local Take_Cage = false
    local function IsStage()
        local break1 = false
        for i,v in pairs(total) do
            if table.find(Config["Ignore"],v) then
                continue;
            end
            if not table.find(cur_,v)  then
                break1 = true
            end
        end
        if break1 then
            Stage = false
        else  
            Stage = true
        end
    end
    local function IsPosition()
        if justfarm then
            return Configs["Spot"]["Money"]
        elseif Config["Type"] == "Special" then
            if not Stage then
                return Config["Spot"]
            else  
                local Isonade = Config["Function"]()
                return Isonade and Isonade.CFrame * CFrame.new(0,60,25) or Configs["Spot"]["Money"] 
            end
        else
            return Config["Spot"]
        end
    end
    local connect4,connect5,connect3
    if not justfarm then
        print("BOOK FARMING",justfarm)
        for i,v in pairs(fishs) do
            if type(v) == "table" and v["From"] == fish then
               table.insert(total,i)
            end
        end
        connect4 = workspace.zones.fishing.ChildAdded:Connect(function(v)
            IsStage()
            Position = IsPosition()
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
        end)
        connect5 = workspace.zones.fishing.ChildRemoved:Connect(function(v)
            IsStage()
            Position = IsPosition()
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
        end)
        for i,v in pairs(playerstats.Bestiary:GetChildren()) do
            if table.find(total,v.Name) then
                table.insert(cur_,v.Name)
                IsStage()
                Position = IsPosition()
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
            end
        end
        connect3 = playerstats.Bestiary.ChildAdded:Connect(function(v)
            if table.find(total,v.Name) and not table.find(cur_,v.Name) then
                table.insert(cur_,v.Name)
                IsStage()
                Position = IsPosition()
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("bestiarycomplete"):FireServer(fish)
            end
        end)
    end
    

    
  
    plr.Character.HumanoidRootPart.CFrame = Config["Spot"]
    local tick1 = tick() + 5
    repeat task.wait() until tick() >= tick1
    spawn(function()
        if not Config["Cage Spot"] or justfarm then return end
        local function GetCageVal()
            for i,v in pairs(playerstats.Inventory:GetChildren()) do
                if v.Value == "Crab Cage"  then
                    return v["Stack"].Value
                end
            end
            return 0 
        end
        while true do task.wait()
            pcall(function()
                if SellTheFish or BuyingLuck then
                    return
                end
                if tick() >= Place then
                    if Check_Cage() < Config["Cage Limit"] and not Stage then
                        if GetCageVal() < Config["Cage Limit"] then
                            if playerstats.Stats.coins.Value >= 225 then
                                Crab = true
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end
                                task.wait(.3)
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end 
                                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Cage"].Position).Magnitude >= 5  then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Cage"]
                                else
                                    local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                                    if not prompt then
                                        fireproximityprompt(workspace.world.interactables["Crab Cage"]:FindFirstChild("purchaserompt",true)) 
                                    else
                                        prompt.amount.Text = "5"
                                        prompt.confirm.AnchorPoint = Vector2.new(.5,.5)
                                        prompt.confirm.Position = UDim2.fromScale(.5,.5)
                                        prompt.confirm.Size = UDim2.fromScale(999,999)

                                        task.wait(.2)
                                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                                    end
                                end
                            end
                        else
                            for i,v in pairs(Config["Cage"]) do 
                                local tick1 = tick() + .2
                                print(v)
                                if Check_Cage() >= Config["Cage Limit"] then
                                    break
                                end
                                plr.Character.HumanoidRootPart.CFrame = v
                                repeat
                                    task.wait()
                                until tick() >= tick1
                                plr.Backpack:FindFirstChild("Crab Cage").Deploy:FireServer(v)
                                local tick1 = tick() + .2
                                repeat
                                    task.wait()
                                until tick() >= tick1
                            end
                            if Check_Cage() >= 5 then
                                Place = tick() + 300
                            end
                        end
                    else
                        if not Stage then
                            Crab = true
                            if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                return
                            end
                            task.wait(.3)
                            if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                return
                            end 
                            for _ = 1,3 do task.wait()
                                for i,v in pairs(workspace.active:GetChildren()) do
                                    if v.Name == plr.Name then
                                        local tick1 = tick() + 2
                                        repeat wait()
                                            plr.Character.HumanoidRootPart.CFrame = v:GetPivot() task.wait(.2)
                                        until not v or v.Parent == nil or v:FindFirstChildWhichIsA("ProximityPrompt",true) or tick() >= tick1
                                        
                                        if v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                            fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true)) 
                                        else
                                            v:Destroy()
                                        end
                                    end
                                end
                            end
                            if Check_Cage() >= 1 then
                                Place = tick() + 300
                            end
                        else
                            if Cahce then
                                print("Cahce")
                                Crab = true
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end
                                task.wait(.3)
                                if plr.PlayerGui:FindFirstChild("shakeui") or plr.PlayerGui:FindFirstChild("reel") then
                                    return
                                end 
                                for _ = 1,3 do task.wait()
                                    for i,v in pairs(workspace.active:GetChildren()) do
                                        if v.Name == plr.Name then
                                            local tick1 = tick() + 2
                                            repeat wait()
                                                plr.Character.HumanoidRootPart.CFrame = v:GetPivot() task.wait(.2)
                                            until not v or v.Parent == nil or v:FindFirstChildWhichIsA("ProximityPrompt",true) or tick() >= tick1
                                            
                                            if v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                                fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true)) 
                                            else
                                                v:Destroy()
                                            end
                                        end
                                    end
                                end 
                                if Check_Cage() <= 0 then
                                    Take_Cage = true
                                    Place = tick() + 9999999
                                end
                            end
                            if Check_Cage() >= 1 then
                                plr.Character.HumanoidRootPart.CFrame = Config["Spot"]
                                Cahce = true
                                Place = tick() + 300
                            end
                        end
                    end
                else
                    if Crab then
                        Crab = false
                    end
                end
            end)
        end
    end)
    task.wait(3)
    while #cur_ < #total or (Cahce and not Take_Cage) do task.wait()
        if justfarm and StopFarm_[justfarm] then
            cur_ = {"1","2","3"}
        end
        pcall(function()
           
            if plr.Character and not Crab and not SellTheFish and not BuyingLuck then
                if tick() >= time then
                    -- time = tick() + .5
                    if game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt") then
                        local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                        prompt.deny.AnchorPoint = Vector2.new(.5,.5)
                        prompt.deny.Position = UDim2.fromScale(.5,.5)
                        prompt.deny.Size = UDim2.fromScale(999,999)
                        task.wait(.2)
                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                    elseif Magnitude(plr.Character.HumanoidRootPart.CFrame,Position) >= 5 and not SellTheFish then
                        plr.Character.HumanoidRootPart.CFrame = Position + Vector3.new(0,0,0)
                        print("Teleport")
                    elseif not plr.Character:FindFirstChild(playerstats.Stats.rod.Value) then
                        
                        time = tick() + 1.75
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,"One",false,plr.Character.HumanoidRootPart) task.wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"One",false,plr.Character.HumanoidRootPart)
                        -- plr.Character[playerstats.Stats.rod.Value]["rod/client"].Enabled = false
                        -- print(plr.Character[playerstats.Stats.rod.Value]["rod/client"].Enabled)
                    elseif not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                        time = tick() + 2.3
                        if not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                            -- plr.Character.HumanoidRootPart.Anchored = false
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.reset:FireServer()
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.cast:FireServer(100,1)
                        end
                    end
                end
            end
        end)
    end
    if connect3 then
        connect3:Disconnect()
    end
    if connect4 then
        connect4:Disconnect()
    end
    if connect5 then
        connect5:Disconnect()
    end
    print("Finish")
end
local function Enchant()
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    local Hexed,Abyssal = false,false
    for i,v in pairs(playerstats.Inventory:GetChildren()) do
        if v.Value == "Enchant Relic" and v:FindFirstChild("Mutation") then
            if v.Mutation.Value == "Hexed" then
                Hexed = true
            end
            if v.Mutation.Value == "Abyssal" then
                Abyssal = true
            end
        end
    end
    return not Hexed and "Hexed" or not Abyssal and "Abyssal" or "Fully"
end


if Settings["Rod Quest"] == "Rod Of The Depth" then
    Book("Vertigo")
    local function GetEnchants()
        local playerstats = ReplicatedStorage["playerstats"][plr.Name]
        local Enchants = {}
        local Total = 0
        for i,v in pairs(playerstats.Inventory:GetChildren()) do
            if v.Value == "Enchant Relic" then
                Enchants[v] = {
                    ["Mutation"] = v:FindFirstChild("Mutation") and v.Mutation.Value or "None",
                    ["Stack"] = v.Stack and v.Stack.Value or 1
                }
                if v:FindFirstChild("Mutation") and (v.Mutation.Value == "Hexed" or v.Mutation.Value == "Abyssal") then
                    continue;
                end
                
            end
        end
        for i,v in pairs(Enchants) do
            Total = Total + v["Stack"]
        end
        return Enchants , Total
    end
    local function GetEnchant()
        local Enchants__ = GetEnchants()
        
        for i,v in pairs(Enchants__) do
            if v["Mutation"] == "None" then
                return i
            end
        end
        for i,v in pairs(Enchants__) do
            if v["Mutation"] ~= "Hexed" or v["Mutation"] ~= "Abyssal" then
                return i
            end
        end
        return "None"
    end
    local function GetItemFromGUI(obj)
        for i,v in pairs(plr.PlayerGui.hud.safezone.backpack.inventory.scroll.safezone:GetChildren()) do
           if v:IsA("ImageButton") and v:FindFirstChild("item") and v.item.Value == obj then
                for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                    for i1,v1 in pairs(getconnections(v[v2])) do
                        v1.Function()
                    end
                end
           end
        end
    end
    local EnchantReady = false
    local Abyssal,Hexed = false,false
    local Door = false
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    
    while not playerstats.Rods:FindFirstChild("Rod Of The Depths") do task.wait()
        local var,err = pcall(function()
            if playerstats["Inventory"] then
                if not EnchantReady then
                    print("In EnchantReady")
                    if playerstats.Stats.coins.Value >= 300000 then
                        local val,total = GetEnchants()
                        if total < 7 then
                            print("Relic")
                            repeat task.wait()
                                val,total = GetEnchants()
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Merlin"]) >= 10 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Merlin"]
                                else
                                    if workspace.world.npcs:FindFirstChild("Merlin") then
                                        TalkNpc("Merlin")
                                        spawn(function()
                                            pcall(function()
                                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power"):InvokeServer()
                                            end)
                                        end)
                                    end
                                end
                            until total >= 7
                        end
                        if not plr.PlayerGui.hud.safezone.backpack.inventory.Visible then
                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                for i1,v1 in pairs(getconnections(plr.PlayerGui.hud.safezone.backpack.Open[v2])) do
                                    v1.Function()
                                end
                            end
                        end
                        plr.PlayerGui.hud.safezone.backpack.inventory.Visible = false
                        while Enchant() ~= "Fully" and playerstats.Stats.coins.Value > 449 do task.wait()
                            local Enchant_ = GetEnchant()
                           
                            
                            if Enchant_ ~= "None" then
                                repeat task.wait(.1)
                                    if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["ReSize"]) >= 5 then
                                        plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["ReSize"]
                                    else
                                        TalkNpc("Appraiser")
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            GetItemFromGUI(Enchant_)
                                        end
                                        task.delay(.001,function ()
                                            workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
                                        end)
                                    end
                                until not Enchant_.Parent or Enchant() == "Fully" or playerstats.Stats.coins.Value < 450
                            else
                                print("BREAK")
                                break
                            end
                        end
                        print("Out The Loop 1")
                        plr.PlayerGui.hud.safezone.backpack.inventory.Visible = true
                        if Enchant() == "Fully" then
                            EnchantReady = true
                        end
                        if plr.PlayerGui.hud.safezone.backpack.inventory.Visible then
                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                for i1,v1 in pairs(getconnections(plr.PlayerGui.hud.safezone.backpack.Open[v2])) do
                                    v1.Function()
                                end
                            end
                        end
                        -- Buy Enchant And Find Abyssal , Hexed
                    else
                        local os1 = os.time()
                        StopFarm_[os1] = false
                        spawn(function() 
                            Book("The Depths",os1) 
                        end)
                        repeat task.wait() 
                            print(playerstats.Stats.coins.Value ,playerstats.Stats.coins.Value >= 750000)
                        until playerstats.Stats.coins.Value >= 300000
                        print("OutLoop Enchant")
                        StopFarm_[os1] = true
                    end
                    print("Out EnchantReady")
                else
                    print("In Rod")
                    if playerstats.Stats.coins.Value >= 750000 then
                        if not Door then
                            if game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/GetDoorState"):InvokeServer("TheDepthsGate") then
                                Door = true
                            else
                                if workspace.world.npcs:FindFirstChild("Custos") then
                                    if not plr.PlayerGui:FindFirstChild("options") then
                                        if (plr.Character.HumanoidRootPart.Position - workspace.world.npcs:FindFirstChild("Custos").HumanoidRootPart.Position).Magnitude < 5 then
                                            TalkNpc("Custos")
                                        else
                                            plr.Character.HumanoidRootPart.CFrame = workspace.world.npcs:FindFirstChild("Custos").HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                                        end
                                    else
                                        if not plr.Character:FindFirstChild("The Depths Key" ) then
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "The Depths Key" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        end
                                        repeat
                                            task.wait(.2)
                                            for i2,v2 in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                                for i1,v1 in pairs(getconnections(plr.PlayerGui.options.safezone["1option"].button[v2])) do
                                                    v1.Function()
                                                end
                                            end
                                        until not plr.PlayerGui:FindFirstChild("options")
                                    end
                                else
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["DepthGate"]
                                end
                               
                               
                               
                            end
                             -- Open The Door ...
                        elseif not Abyssal or not Hexed then
                            if not Hexed then
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Hexed"]) >= 7 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Hexed"]
                                else
                                    if not workspace:FindFirstChild("Hexed") then return end
                                    if not workspace.Hexed:FindFirstChildWhichIsA("Model") then
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            print("Enchant Relic")
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "Enchant Relic" and v:FindFirstChild("link") and v.link.Value:FindFirstChild("Mutation") and v.link.Value.Mutation.Value == "Hexed" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            print(obj)
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        else
                                            print("Here")
                                            fireproximityprompt(workspace.Hexed.Root.Prompt) 
                                            plr.Character.Humanoid:UnequipTools()
                                        end
                                    else
                                        Hexed = true
                                    end
                                end
                            elseif not Abyssal then
                                if Magnitude(plr.Character.HumanoidRootPart.CFrame,Configs["Spot"]["Abyssal"]) >= 7 then
                                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Abyssal"]
                                else
                                    if not workspace:FindFirstChild("Abyssal") then return end
                                    if not workspace.Abyssal:FindFirstChildWhichIsA("Model") then
                                        if not plr.Character:FindFirstChild("Enchant Relic") then
                                            local obj = nil
                                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                                if v:IsA("Tool") and v.Name == "Enchant Relic" and v:FindFirstChild("link") and v.link.Value:FindFirstChild("Mutation") and v.link.Value.Mutation.Value == "Abyssal" then
                                                    if not obj then
                                                        obj = v
                                                    end
                                                end
                                            end
                                            if obj then
                                                plr.Character.Humanoid:EquipTool(obj)
                                            end
                                        else
                                            fireproximityprompt(workspace.Abyssal.Root.Prompt) 
                                            plr.Character.Humanoid:UnequipTools()
                                        end
                                    else
                                        Abyssal = true
                                    end
                                end
                            end
                            -- Put Enchant To ...
                        else
                            if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Rod Of The Depths"].Position).Magnitude >= 5  then
                                plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Rod Of The Depths"]
                            else
                                local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                                if not prompt then
                                    fireproximityprompt(workspace.world.interactables["Rod Of The Depths"]:FindFirstChild("purchaserompt",true)) 
                                else
                                    prompt.confirm.AnchorPoint = Vector2.new(.5,.5)
                                    prompt.confirm.Position = UDim2.fromScale(.5,.5)
                                    prompt.confirm.Size = UDim2.fromScale(999,999)
    
                                    task.wait(.2)
                                    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                                    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                                    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                                end
                            end
                             -- Go To Buy Rod ...
                        end
                    else
                        local os1 = os.time()
                        StopFarm_[os1] = false
                        spawn(function() 
                            Book("The Depths",os1) 
                        end)
                        repeat task.wait()
                            
                        until playerstats.Stats.coins.Value >= 750000 or playerstats.Rods:FindFirstChild("Rod Of The Depths")
                        print("The Depths")
                        StopFarm_[os1] = true
                    end
                    print("Out Rod")
                end
            end
        end)
        if not var then
            print("Rod Of The Depth",err)
        end
    end
elseif Settings["Rod Quest"] == "Trident Rod" then
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
    Book("Desolate Deep")
    while not playerstats.Rods:FindFirstChild("Trident Rod") do task.wait()
        local var,err = pcall(function()
            if playerstats.Stats.coins.Value >= 150000 then
                if (plr.Character.HumanoidRootPart.Position - Configs["Spot"]["Trident Rod"].Position).Magnitude >= 5  then
                    plr.Character.HumanoidRootPart.CFrame = Configs["Spot"]["Trident Rod"]
                else
                    local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                    if not prompt then
                        fireproximityprompt(workspace.world.interactables["Trident Rod"]:FindFirstChild("purchaserompt",true)) 
                    else
                        prompt.confirm.AnchorPoint = Vector2.new(.5,.5)
                        prompt.confirm.Position = UDim2.fromScale(.5,.5)
                        prompt.confirm.Size = UDim2.fromScale(999,999)

                        task.wait(.2)
                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                    end
                end
            else
                local os1 = os.time()
                StopFarm_[os1] = false
                spawn(function() 
                    Book("The Depths",os1) 
                end)
                repeat task.wait()

                until playerstats.Stats.coins.Value >= 150000 or playerstats.Rods:FindFirstChild("Rod Of The Depths")
                print("The Depths")
                StopFarm_[os1] = true
            end
        end)
        if not var then
            print("Trident",err)
        end
    end
elseif Settings["Rod Quest"] == "" and #Settings["Bestiary"] <= 0 then
    local playerstats = ReplicatedStorage["playerstats"][plr.Name]
   
    local function IsPosition()
        if Settings["WorldEvent"] then
            if workspace.zones.fishing:FindFirstChild("Great Hammerhead Shark") then
                return workspace.zones.fishing:FindFirstChild("Great Hammerhead Shark").CFrame
            elseif workspace.zones.fishing:FindFirstChild("Great White Shark") then
                return workspace.zones.fishing:FindFirstChild("Great White Shark").CFrame
            elseif workspace.zones.fishing:FindFirstChild("Whale Shark") then
                return  workspace.zones.fishing:FindFirstChild("Whale Shark").CFrame
            end
            return Configs[Settings["Spot"]]["Spot"] or Configs["Spot"]["Money"]   
        else
            return Configs[Settings["Spot"]]["Spot"] or  Configs["Spot"]["Money"]   
        end
    end
    local Position = IsPosition()  
    workspace.zones.fishing.ChildAdded:Connect(function()
        Position = IsPosition()
    end)
    workspace.zones.fishing.ChildRemoved:Connect(function()
        Position = IsPosition()
    end)
    while true do task.wait()
        local var,err = pcall(function()
            if plr.Character and not SellTheFish and not BuyingLuck then
                print("AUTO FARM")
                if tick() >= time then
                    if game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt") then
                        local prompt = game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt")
                        prompt.deny.AnchorPoint = Vector2.new(.5,.5)
                        prompt.deny.Position = UDim2.fromScale(.5,.5)
                        prompt.deny.Size = UDim2.fromScale(999,999)
                        task.wait(.2)
                        local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
                        VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
                    elseif Magnitude(plr.Character.HumanoidRootPart.CFrame,Position) >= 5 and not SellTheFish and not BuyingLuck  then
                        plr.Character.HumanoidRootPart.CFrame = Position + Vector3.new(0,0,0)
                        print("Teleport")
                    elseif not plr.Character:FindFirstChild(playerstats.Stats.rod.Value) then
                        time = tick() + 1.75
                        game:GetService("VirtualInputManager"):SendKeyEvent(true,"One",false,plr.Character.HumanoidRootPart) task.wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"One",false,plr.Character.HumanoidRootPart)
                    elseif not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                        time = tick() + 2.3
                        if not plr.PlayerGui:FindFirstChild("shakeui") and not plr.PlayerGui:FindFirstChild("reel") then
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.reset:FireServer()
                            plr.Character:FindFirstChild(playerstats.Stats.rod.Value).events.cast:FireServer(100,1)
                        end
                    end
                end
            end
        end)
    end
else
    for i,v in pairs(Settings["Bestiary"]) do
        Book(v)
    end
end

