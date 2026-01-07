wave/maxwave
game:GetService("Players").LocalPlayer.PlayerGui.HUD.Map.WavesAmount

GameHandler
local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = v1.Modules
local v4 = require(v3.Packages.FastSignal.Deferred)
require(v3.Data.StagesData.Types)
local v5 = v1.Networking
local v_u_6 = v5.GameEvent
local _ = v5.Event
local v_u_7 = {
    ["GameData"] = {},
    ["IsGameLoaded"] = false,
    ["IsMatchStarted"] = false,
    ["GameLoaded"] = v4.new(),
    ["MatchStarted"] = v4.new(),
    ["MatchRestarted"] = v4.new(),
    ["MatchEnded"] = v4.new(),
    ["MatchId"] = 0
}
task.spawn(function()
    if not v_u_2:IsServer() then
        local v_u_8 = v_u_7.GameData
        v_u_6:FireServer()
        v_u_6.OnClientEvent:Connect(function(p9)
            if p9 == "MatchStarted" then
                v_u_7.IsMatchStarted = true
                v_u_7.MatchStarted:Fire()
                return
            elseif p9 == "GameRestarted" then
                v_u_7.IsMatchStarted = false
                v_u_7.MatchRestarted:Fire()
                return
            elseif p9 == "MatchEnded" then
                v_u_7.IsMatchStarted = false
                v_u_7.MatchEnded:Fire()
            else
                local v10 = v_u_7
                v10.MatchId = v10.MatchId + 1
                for v11, v12 in p9 do
                    v_u_8[v11] = v12
                end
                v_u_7.IsGameLoaded = true
                v_u_7.GameLoaded:Fire()
            end
        end)
    end
end)
function v_u_7.Run(p13, p14)
    local v15 = v_u_7:GetGameData()
    local v16 = p13.StageType
    local v17 = p13.Stage
    local v18 = p13.Act
    local v19 = p13.IsPortal
    local v20 = p13.IsWorldlines
    local v21 = p13.IsChallenge
    local v22 = p13.IsOdyssey
    local v23 = v15.StageType
    local v24 = v15.Stage
    local v25 = v15.Act
    if v20 and v15.WorldlineRoom then
        return p14()
    end
    if v21 and v15.ChallengeType then
        return p14()
    end
    if v22 and v15.OdysseyLevel then
        return p14()
    end
    if v19 and v15.PortalData then
        return p14()
    end
    local v26 = not v16 or v16 == v23
    local v27 = not v17 or v17 == v24
    if v18 and (typeof(v18) == "string" and v18 == v25) then
        v18 = true
    elseif v18 then
        if typeof(v18) == "table" then
            v18 = table.find(v18, v25)
        else
            v18 = false
        end
    end
    if v26 and (v27 and v18) then
        return p14()
    end
end
function v_u_7.GetGameData(_)
    if not v_u_7.IsGameLoaded then
        v_u_7.GameLoaded:Wait()
    end
    return v_u_7.GameData
end
return v_u_7

HitboxHandler
local v1 = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("HttpService")
game:GetService("Players")
local v5 = game:GetService("ServerScriptService")
local v_u_6 = v_u_3:IsServer()
local v_u_7
if v_u_6 then
    v_u_7 = require(v5.Modules.Gameplay.Enemies.EnemyHandler)
else
    v_u_7 = nil
end
local v_u_8
if v_u_3:IsClient() then
    v_u_8 = require(v2.Modules.Gameplay.ClientEnemyHandler)
else
    v_u_8 = nil
end
local v_u_9
if v_u_6 then
    v_u_9 = require(v5.Modules.Gameplay.GameStateHandler)
else
    v_u_9 = nil
end
local v_u_10 = require(v1.Modules.Shared.MultiplierHandler)
local v_u_11 = not v_u_6 and {} or require(v5.Modules.Gameplay.Units.UnitHandler.Constants)
require(v1.Modules.Debug.Gizmo)
local v_u_12 = require(v1.Modules.Packages.FastSignal.Deferred)
require(v1.Modules.Data.EnemyDiameterData)
local v_u_13 = require(script.HitboxDebugHandler)
local v_u_14 = {
    ["_Cache"] = {},
    ["_Types"] = {}
}
task.spawn(function()
    task.spawn(function()
        for _, v15 in script.Types:GetChildren() do
            if not v15:IsA("ModuleScript") or v_u_14._Types[v15.Name] then
                return
            end
            v_u_14._Types[v15.Name] = require(v15)
        end
    end)
end)
function v_u_14.GetEnemiesInRange(p16)
    local v17 = p16.CirclePosition * Vector3.new(1, 0, 1)
    local v18 = p16.IsInverted == true
    local v19 = {}
    local v20 = {}
    for v21, v22 in p16.Enemies do
        if v22.Data.Type ~= "UnitSummon" and (p16.IgnorePredictedKiller or (not v22.Data.PredictedKiller or v22.Data.PredictedKiller == p16.UnitGUID)) and (not p16.GameStateId or v22.GameStateId == p16.GameStateId) then
            local v23 = v22.Position * Vector3.new(1, 0, 1)
            local v24 = p16.CircleDiameter
            local v25 = v22.Diameter
            if (v17 - v23).Magnitude <= (v24 + v25) / 2 ~= v18 then
                v19[v21] = v22
                table.insert(v20, v21)
            end
        end
    end
    return v19, v20
end
function v_u_14.CoreHitbox(p26, p27, p28)
    local v29 = p26.UnitObject
    local v30 = v29 and v29.ForcedAOEType or p26.Type
    if p26.ForceAOE then
        v30 = p26.Type
    end
    if v30 ~= "Circle" and not v_u_14._Types[v30] then
        warn((("Invalid hitbox type \'%*\'"):format(v30)))
        return {}, nil
    end
    local v31 = p26.OriginOverride or v29.Position
    local v32 = p26.MaxTargets or -1
    local v33 = v29 and v29.ForcedCircleRadius or p26.CircleRadius
    local v34 = p26.Offset
    local v35 = p26.Size
    if p26.ForceAOE then
        v35 = p26.Size
    end
    local v36 = v29 and v29.Player or p26.Player
    local v37 = v29 and (v29.Name or "NoUnit") or "NoUnit"
    local v38 = v29 and (v29.UniqueIdentifier or "PlayerHitbox") or "PlayerHitbox"
    local v39
    if v29 then
        v39 = v29.Data or nil
    else
        v39 = nil
    end
    local v40 = v39 and v39.Upgrades[v39.CurrentUpgrade] or nil
    local v41
    if v29 then
        v41 = v_u_10:GetMultipliedStatistic(v29, "Range", v40) or nil
    else
        v41 = nil
    end
    if v40 then
        v32 = v40.MaxTargets or v32
        v34 = v34 or v40.AOEOffset
        v35 = v35 or (v29.ForcedAOESize or v40.AOESize)
        local _ = v40.InvertedRange == true
    end
    local v42 = v34 or 0
    if v35 then
        v35 = v35 * v_u_10:GetAOESizeMultiplier(v29)
    end
    local v43 = p26.LockonTargetData.Position * Vector3.new(1, 0, 1)
    local v44 = (v31 - v43).Magnitude
    if v_u_11.INF_RANGE_UNITS[v37] then
        local v45 = v44 * 2 + 2
        v41 = math.max(v45, v41)
    elseif p26.UnitRangeOverride then
        v41 = p26.UnitRangeOverride
    end
    local v46 = v30 ~= "Stadium" and 0 or (v31 * Vector3.new(1, 0, 1) - v43).Magnitude
    local v47 = v30 == "Splash" and 100000 or v46
    local v48 = v_u_9:GetPlayerState(v36).Id
    local v49
    if v30 == "Circle" then
        local v50
        v50, v49 = v_u_14.GetEnemiesInRange({
            ["CirclePosition"] = v43,
            ["Enemies"] = p27,
            ["CircleDiameter"] = v35,
            ["IsInverted"] = false,
            ["UnitGUID"] = v38,
            ["GameStateId"] = v48,
            ["IgnorePredictedKiller"] = p26.IgnorePredictedKiller
        })
        local v51 = {
            ["Size"] = v35,
            ["Position"] = v43,
            ["Offset"] = v42,
            ["UnitPosition"] = v31 * Vector3.new(1, 0, 1),
            ["Targets"] = v50,
            ["MaxTargets"] = v32,
            ["UnitRange"] = v41
        }
        v_u_13.Run(v51, v30, v49, v31.Y, v38)
    else
        local v52 = v41 + v47 * 2
        if v30 == "Line" then
            v52 = math.max(v41, v35) + v47 * 2
        end
        local v53 = v_u_14.GetEnemiesInRange({
            ["CirclePosition"] = v31,
            ["Enemies"] = p27,
            ["CircleDiameter"] = v52,
            ["IsInverted"] = false,
            ["UnitGUID"] = v38,
            ["GameStateId"] = v48,
            ["IgnorePredictedKiller"] = p26.IgnorePredictedKiller
        })
        local v54 = {
            ["Size"] = v35,
            ["Position"] = v43,
            ["Offset"] = v42,
            ["UnitPosition"] = v31 * Vector3.new(1, 0, 1),
            ["Targets"] = v53,
            ["MaxTargets"] = v32,
            ["UnitRange"] = v41,
            ["CircleRadius"] = v33
        }
        v49 = v_u_14._Types[v30](v54)
        v_u_13.Run(v54, v30, v49, v31.Y, v38)
    end
    local v55 = {}
    if v49 and #v49 > 0 then
        for _, v56 in ipairs(v49) do
            if not p28[v56] then
                if v32 ~= -1 and v32 <= #v55 then
                    break
                end
                table.insert(v55, v56)
            end
        end
        for _, v57 in ipairs(v55) do
            p28[v57] = true
        end
    end
    return v55, v49
end
function v_u_14.Start(p_u_58, p_u_59)
    local v60 = p_u_58.UnitObject
    local v_u_61 = v_u_4:GenerateGUID(false)
    local v62 = v60.Data
    local v63 = v62.Upgrades[v62.CurrentUpgrade]
    local v_u_64 = v60.UniqueIdentifier
    local v65 = p_u_58.MaxTargets or (v63 and v63.MaxTargets or -1)
    local v_u_66 = p_u_58.Rate or nil
    local v_u_67 = p_u_58.Lifetime or 0
    local v_u_68 = v_u_6 and v_u_7._ActiveEnemies or v_u_8._ActiveEnemies
    local v_u_69 = v65 == -1 and {} or (table.create(v65) or {})
    local v_u_70 = v_u_12.new()
    local v_u_71 = os.clock()
    local v_u_72 = 0
    if v_u_14._Types[p_u_58.Type] or v60 and v60.ForcedAOEType then
        if not v_u_14._Cache[v_u_64] then
            v_u_14._Cache[v_u_64] = {}
        end
        v_u_14._Cache[v_u_64][v_u_61] = true
        local v_u_73 = nil
        v_u_73 = v_u_3.Heartbeat:Connect(function(p74)
            v_u_72 = v_u_72 + p74
            if v_u_14._Cache[v_u_64] and v_u_14._Cache[v_u_64][v_u_61] then
                local v75, v76 = v_u_14.CoreHitbox(p_u_58, v_u_68, v_u_69)
                if v75 and #v75 > 0 then
                    v_u_70:Fire(v75)
                    if p_u_59 then
                        p_u_59(v76)
                    end
                end
                if v_u_66 and v_u_66 <= v_u_72 then
                    v_u_72 = 0
                    table.clear(v_u_69)
                end
                if v_u_67 > 0 and v_u_67 <= os.clock() - v_u_71 then
                    v_u_73:Disconnect()
                    v_u_70:DisconnectAll()
                    if v_u_14._Cache[v_u_64] then
                        v_u_14._Cache[v_u_64][v_u_61] = nil
                    end
                    return
                elseif v_u_67 == 0 then
                    v_u_73:Disconnect()
                    v_u_70:DisconnectAll()
                    if v_u_14._Cache[v_u_64] then
                        v_u_14._Cache[v_u_64][v_u_61] = nil
                    end
                end
            else
                v_u_73:Disconnect()
                v_u_70:DisconnectAll()
                if v_u_14._Cache[v_u_64] then
                    v_u_14._Cache[v_u_64][v_u_61] = nil
                end
                return
            end
        end)
        return {
            ["Identifier"] = v_u_61,
            ["OnHit"] = v_u_70,
            ["Disconnect"] = function()
                v_u_73:Disconnect()
                v_u_70:DisconnectAll()
                if v_u_14._Cache[v_u_64] then
                    v_u_14._Cache[v_u_64][v_u_61] = nil
                end
            end
        }
    end
end
function v_u_14.Collect(p77)
    local v78 = p77.UnitObject
    local v79 = p77.MaxTargets or -1
    if v78 then
        v78 = v78.Data
    end
    if v78 then
        v78 = v78.Upgrades[v78.CurrentUpgrade]
    end
    if v78 then
        v79 = v78.MaxTargets or v79
    end
    local v80 = v79 == -1 and {} or (table.create(v79) or {})
    local v81 = v_u_7._ActiveEnemies
    local v82, _ = v_u_14.CoreHitbox(p77, v81, v80)
    return v82 or {}
end
function v_u_14.Call(p_u_83, p_u_84)
    return function(...)
        local v85 = v_u_14.Collect(p_u_83)
        if v85 and next(v85) then
            p_u_84(v85, ...)
        end
    end
end
function v_u_14.RemoveUnitHitboxes(_, p86)
    if v_u_14._Cache[p86] then
        v_u_14._Cache[p86] = nil
    end
end
return v_u_14


PriorityHandler
local v_u_1 = {
    "First",
    "Closest",
    "Last",
    "Strongest",
    "Weakest",
    "Bosses"
}
local function v_u_9(p2)
    local v3 = (1 / 0)
    local v4 = nil
    for _, v5 in p2 do
        local v6 = v5.CurrentNode
        local v7 = v5.Alpha
        local v8 = v6.DistanceToEnd - (v6.DistanceToNextNode or 0) * v7
        if v8 < v3 then
            v4 = v5
            v3 = v8
        end
    end
    return v4
end
local v_u_49 = {
    ["_Priorities"] = {
        ["First"] = v_u_9,
        ["Closest"] = function(p10, p11)
            local v12 = nil
            local v13 = nil
            for _, v14 in p10 do
                local v15 = (p11 - v14.Position).Magnitude
                if not v12 or v15 < v13 then
                    v13 = v15
                    v12 = v14
                end
            end
            return v12
        end,
        ["Last"] = function(p16)
            local v17 = nil
            local v18 = nil
            local v19 = nil
            for _, v20 in p16 do
                local v21 = v20.CurrentNode
                local v22 = v20.Alpha
                if not v20.Data.IsStatic then
                    if v17 and v21 >= v17 then
                        if v21 == v17 and v22 < v18 then
                            v19 = v20
                            v18 = v22
                        end
                    else
                        v19 = v20
                        v18 = v22
                        v17 = v21
                    end
                end
            end
            return v19
        end,
        ["Strongest"] = function(p23)
            local v24 = nil
            local v25 = 0
            for _, v26 in p23 do
                local v27 = v26.Data.Health + (v26.Data.SecondaryHealth or 0)
                if not v24 or v25 < v27 then
                    v25 = v27
                    v24 = v26
                end
            end
            return v24 or v_u_9(p23)
        end,
        ["Weakest"] = function(p28)
            local v29 = nil
            local v30 = (1 / 0)
            for _, v31 in p28 do
                local v32 = v31.Data.Health
                if not v29 or v32 < v30 then
                    v30 = v32
                    v29 = v31
                end
            end
            return v29 or v_u_9(p28)
        end,
        ["Bosses"] = function(p33)
            local v34 = nil
            for _, v35 in p33 do
                if v35.Data.Type == "Boss" then
                    v34 = v35
                    break
                end
            end
            return v34 or v_u_9(p33)
        end
    },
    ["FilterEnemies"] = function(_, p36, p37)
        if p37 then
            if p37 then
                p37 = string.find(p37, "The Falcon")
            end
            if p37 then
                for v38, v39 in p36 do
                    if v39.SpawnedBy == "FalconDomain" then
                        p36[v38] = nil
                    end
                end
            end
        end
    end,
    ["GetEnemyFromPriority"] = function(_, p40, p41, p42, p43)
        if not (p40 and p41) then
            error((("Invalid arguments passed to GetEnemyFromPriority - %*, %*"):format(p40, p41)))
        end
        local v44 = v_u_49._Priorities[p41]
        local v45 = ("No priority callback for %* exists"):format(p41)
        assert(v44, v45)
        v_u_49:FilterEnemies(p40, p43)
        return v_u_49._Priorities[p41](p40, p42)
    end,
    ["GetPriorityFromId"] = function(_, p46)
        local v47 = v_u_1[p46]
        local v48 = ("Invalid priority id \'%*\'"):format(p46)
        assert(v47, v48)
        return v47
    end
}
return v_u_49
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("RunService")
local v3 = game:GetService("ServerScriptService")
local v4 = game:GetService("StarterPlayer")
local v_u_5 = require(script.Parent.HitboxHandler)
local v_u_6 = require(v1.Modules.Debug.Gizmo)
local v_u_7
if v2:IsServer() then
    v_u_7 = require(v3.Modules.Gameplay.Enemies.EnemyHandler)
else
    v_u_7 = nil
end
local v_u_8
if v2:IsClient() then
    v_u_8 = require(v4.Modules.Gameplay.ClientEnemyHandler)
else
    v_u_8 = nil
end
local v_u_9 = require(v1.Modules.Data.EnemyDiameterData)
local v_u_10 = {
    ["DEBUG"] = false
}
local function v_u_20(p11, p12, p13, p14)
    local v15 = p14 / 2
    local v16 = p11.X - p13.X
    local v17 = math.abs(v16)
    local v18 = p11.Z - p13.Z
    local v19 = math.abs(v18)
    if v15.X + p12 < v17 then
        return false
    elseif v15.Z + p12 < v19 then
        return false
    else
        return v17 <= v15.X and true or (v19 <= v15.Z and true or (v17 - v15.X) ^ 2 + (v19 - v15.Z) ^ 2 <= p12 ^ 2)
    end
end
local function v_u_31(p21, p22, p23, p24, p25)
    local v26 = CFrame.lookAt(p23:Lerp(p24, 0.5), p24)
    local v27 = (p23 - p24).Magnitude
    local v28 = v26:PointToObjectSpace(p21)
    local v29 = v28.X
    local v30 = v28.Z
    return v_u_20(Vector3.new(v29, 0, v30), p22, Vector3.new(0, 0, 0), (Vector3.new(p25, 0, v27)))
end
local function v_u_52(p32, p33, p34, p35, p36, p37, p38)
    local v39 = (p34 - p32) * Vector3.new(1, 0, 1)
    local v40 = v39.Magnitude
    if p38 < v40 then
        return nil, nil
    end
    local v41 = v39.Unit
    local v42 = p33:Dot(v41)
    local v43 = math.acos(v42)
    local v44 = p33:Cross(v41).Y
    local v45 = v43 * math.sign(v44)
    local v46 = p35 / 2
    if v46 < math.abs(v45) then
        return nil, nil
    end
    local v47 = (v45 + v46) / p35 * p36
    local v48 = math.floor(v47) + 1
    local v49 = math.clamp(v48, 1, p36)
    local v50 = v40 / p38 * p37
    local v51 = math.floor(v50) + 1
    return v49, math.clamp(v51, 1, p37), v40
end
function v_u_10.Cone(p53, p54)
    local v55 = p53.Distance / 2
    local v56 = p53.Rows
    local v57 = p53.Position * Vector3.new(1, 0, 1)
    local v58 = (p53.TargetPosition * Vector3.new(1, 0, 1) - v57).Unit
    local v59 = p53.Size
    local v60 = math.rad(v59)
    local v61 = {}
    local v62 = {}
    for v63 = 1, v56 do
        v61[v63] = (1 / 0)
    end
    local v64 = v_u_5.GetEnemiesInRange({
        ["CirclePosition"] = v57,
        ["Enemies"] = (v_u_7 or v_u_8)._ActiveEnemies,
        ["CircleDiameter"] = v55 * 2,
        ["IsInverted"] = false,
        ["GameStateId"] = p53.GameStateId
    })
    for v65, v66 in next, v64 do
        local _, v67, v68 = v_u_52(v57, v58, v66.Position * Vector3.new(1, 0, 1), v60, 1, v56, v55)
        if v67 and v68 < v61[v67] then
            v62[v67] = v65
            v61[v67] = v68
        end
    end
    local v69 = {}
    for v70 = 1, v56 do
        if v62[v70] then
            local v71 = v62[v70]
            table.insert(v69, v71)
        end
    end
    if v_u_10.DEBUG then
        local v72 = Color3.new(1, 0.5, 0)
        local v73 = Color3.new(0, 1, 0)
        local v74 = Color3.new(0.5, 0.5, 1)
        v_u_6:DrawCircle(v57, v55, 5, v72)
        local v75 = v60 / 2
        for v76 = 0, 1 do
            local v77 = -v75 + v76 * (v60 / 1)
            v_u_6:DrawLine(v57, v57 + (CFrame.lookAt(Vector3.new(0, 0, 0), v58) * CFrame.Angles(0, v77, 0)).LookVector * v55, 5, v74)
        end
        for v78 = 1, v56 do
            v_u_6:DrawCircle(v57, v55 * (v78 / v56), 5, Color3.new(0.3, 0.3, 1))
        end
        for v79, v80 in next, v64 do
            local v81 = v80.Position * Vector3.new(1, 0, 1)
            local v82 = v_u_9(v80.Name) / 2
            local v83 = v_u_6
            local v84 = 5
            local v85
            if table.find(v69, v79) ~= nil then
                v85 = v73
            else
                v85 = Color3.new(1, 0, 0)
            end
            v83:DrawSphere(v81, v82, v84, v85)
        end
    end
    if p54 and next(v69) then
        task.spawn(p54, v69, v62)
    end
    return v69, v62
end
function v_u_10.Line(p86, p87)
    local v88 = p86.Distance
    local v89 = p86.Rows
    local v90 = p86.Size
    local v91 = p86.Position
    local v92 = p86.TargetPosition
    local v93 = p86.GameStateId
    local v94 = (v92 - v91).Unit
    local v95 = v91 + v94 * (v88 / 2)
    local v96 = v90 / 2 / v89
    local v97 = CFrame.lookAt(v91 * Vector3.new(1, 0, 1), v92 * Vector3.new(1, 0, 1))
    local v98 = v_u_5.GetEnemiesInRange({
        ["CirclePosition"] = v91,
        ["Enemies"] = (v_u_7 or v_u_8)._ActiveEnemies,
        ["CircleDiameter"] = v88,
        ["IsInverted"] = false,
        ["GameStateId"] = v93
    })
    local v99 = {}
    local v100 = {}
    for v101, v102 in next, v98 do
        local v103 = v102.Position * Vector3.new(1, 0, 1)
        local v104 = v_u_9(v102.Name)
        if v_u_31(v102.Position, v104, v91, v95, v90) then
            local v105 = v97:PointToObjectSpace(v103).X / v96
            local v106 = math.round(v105)
            local v107 = v99[v106] or (1 / 0)
            local v108 = (v103 - v91).Magnitude
            if v107 >= v108 then
                v99[v106] = v108
                table.insert(v100, v101)
            end
        end
    end
    if v_u_10.DEBUG then
        local v109 = Color3.new(0, 0.5, 1)
        local v110 = Color3.new(0, 1, 0)
        local v111 = Color3.new(0.5, 0.5, 1)
        local v112 = v90 / 2
        local v113 = (v97 * CFrame.new(-v112, 0, 0)).Position
        local v114 = (v97 * CFrame.new(v112, 0, 0)).Position
        local v115 = v91 + v94 * v88
        local v116 = v91 + (v113 - v91).Unit * v112
        local v117 = v91 + (v114 - v91).Unit * v112
        local v118 = v115 + (v113 - v91).Unit * v112
        local v119 = v115 + (v114 - v91).Unit * v112
        v_u_6:DrawLine(v91, v115, 5, v109)
        v_u_6:DrawLine(v116, v118, 5, v109)
        v_u_6:DrawLine(v117, v119, 5, v109)
        v_u_6:DrawLine(v116, v117, 5, v109)
        v_u_6:DrawLine(v118, v119, 5, v109)
        for v120 = 1, v89 - 1 do
            local v121 = -v112 + v90 / v89 * v120
            local v122 = (v97 * CFrame.new(v121, 0, 0)).Position
            v_u_6:DrawLine(v91 + (v122 - v91).Unit * math.abs(v121), v115 + (v122 - v91).Unit * math.abs(v121), 5, v111)
        end
        for v123, v124 in next, v98 do
            local v125 = v124.Position * Vector3.new(1, 0, 1)
            local v126 = v_u_9(v124.Name) / 2
            local v127 = false
            for _, v128 in v100 do
                if v128 == v123 then
                    v127 = true
                    break
                end
            end
            local v129 = v_u_6
            local v130 = 5
            local v131
            if v127 then
                v131 = v110
            else
                v131 = Color3.new(1, 0, 0)
            end
            v129:DrawSphere(v125, v126, v130, v131)
        end
    end
    if p87 and next(v100) then
        task.spawn(p87, v100, v99)
    end
    return v100, v99
end
return v_u_10

Boss

local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
game:GetService("TweenService")
local v_u_3 = v1.LocalPlayer:WaitForChild("PlayerGui")
local v_u_4 = require(v2.Modules.Packages.Spring)
local v_u_5 = require(v2.Modules.Utilities.TextUtils)
require(v2.Modules.Interface.InterfaceUtils)
local v_u_6 = v2.Networking.BossAlertEvent
local v_u_7 = {}
local v_u_8 = nil
function v_u_7.CreateInterface(p9)
    local v10 = p9 or {}
    if not v_u_8 then
        local v11 = v10.Text or "A huge threat is approaching..."
        local v12 = UDim2.fromOffset(1200, 250)
        local v13 = script.BossAlert:Clone()
        local v14 = v13.Holder
        local v15 = v14.Main
        v14.UIScale.Scale = 0
        v14.Size = UDim2.fromOffset(0, 250)
        v_u_5.AnimateText(v15.TextMiddle.Label, v11, 0.05)
        v13.Enabled = true
        v13.Parent = v_u_3
        v_u_8 = v13
        v_u_4.target(v14.UIScale, 0.7, 4, {
            ["Scale"] = 1.1
        })
        v_u_4.target(v14, 0.7, 3.5, {
            ["Size"] = v12
        })
        task.wait(7)
        v_u_4.target(v14, 0.7, 3.5, {
            ["Size"] = UDim2.fromOffset(0, 250)
        })
        task.wait(0.5)
        v13:Destroy()
    end
end
task.spawn(function()
    v_u_6.OnClientEvent:Connect(v_u_7.CreateInterface)
end)
return v_u_7

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = v1.Networking.ClientListeners.Bosses.BossAttackEvent
local v_u_4 = require(v1.Modules.Utilities.EffectUtils)
require(script.Types)
local v_u_5 = require(v2.Modules.Gameplay.ClientEnemyHandler)
local v_u_7 = {
    ["Cache"] = {},
    ["_PreInit"] = function()
        for _, v6 in script.Callbacks:GetDescendants() do
            if v6:IsA("ModuleScript") and (not v_u_7.Cache[v6.Name] and v6.Name ~= "TEMPLATE") then
                v_u_7.Cache[v6.Name] = require(v6)
            end
        end
    end
}
task.spawn(function()
    v_u_3.OnClientEvent:Connect(function(p8)
        v_u_7:Start(p8)
    end)
end)
function v_u_7.Start(_, p9)
    local v10 = p9[1]
    local v11 = p9[2]
    local v12 = p9[3]
    if v10 and v11 then
        local v13 = v_u_5:GetEnemyData(v11)
        if v13 then
            local v14 = v_u_7.Cache[v10]
            if v14 then
                v14:Attack({
                    ["Identifier"] = v11,
                    ["Units"] = v12,
                    ["EnemyObject"] = v13,
                    ["ExtraData"] = p9[4]
                })
            end
        end
    else
        return
    end
end
v_u_5.EnemyDespawned:Connect(function(p15)
    local v16 = v_u_4:GetThreads(p15)
    if v16 then
        for _, v17 in v16 do
            if coroutine.status(v17) == "suspended" then
                task.cancel(v17)
            end
        end
        v_u_4:ClearThreads(p15)
    end
    v_u_4:ClearUnitVFX(p15)
end)
return v_u_7

Enemy
local v_u_1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("TweenService")
require(v2.Modules.Packages.FastSignal)
local v_u_4 = require(v2.Modules.ClientReplicationHandler)
local v_u_5 = { -4, 4 }
local v_u_6 = {
    ["Shield"] = Color3.fromRGB(0, 162, 232),
    ["ArmoredLife"] = Color3.fromRGB(232, 179, 18)
}
task.spawn(function()
    local v_u_7 = v_u_1.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Map"):WaitForChild("Health")
    local v_u_8 = v_u_7:WaitForChild("Bar")
    local v_u_9 = v_u_7:WaitForChild("BaseHealth")
    local v_u_10 = nil
    local v_u_11 = nil
    local v_u_12 = Color3.fromRGB(21, 222, 51)
    local v_u_13 = nil
    v_u_4.RequestInitData("HealthStocks")
    v_u_4.OnReplicate("HealthStocks"):Connect(function(p14, p15)
        if p15 == "None" then
            if v_u_11 then
                local v16 = v_u_9
                local v17 = v_u_11.OverrideName
                v16.Text = ("%* Stocks: %*/%*"):format(string.gsub(v17 or "", "(%l)([%u%d])", "%1 %2"), v_u_11.Current, v_u_11.Max)
            else
                if p14 then
                    v_u_13 = p14
                end
                v_u_9.Text = ("Stocks: %*/%*"):format(p14 or v_u_13, 3)
            end
            if not v_u_11 then
                v_u_8.Size = UDim2.fromScale(p14 / 3, 1)
                return
            end
        elseif p15 == "Update" then
            if not v_u_11 then
                v_u_8.BackgroundColor3 = Color3.fromRGB(222, 40, 43)
                v_u_7.Rotation = v_u_5[math.random(#v_u_5)]
                v_u_3:Create(v_u_7, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    ["Rotation"] = 0
                }):Play()
                local v18 = {
                    ["BackgroundColor3"] = v_u_12
                }
                v_u_3:Create(v_u_8, TweenInfo.new(0.235, Enum.EasingStyle.Back, Enum.EasingDirection.Out), v18):Play()
                v_u_3:Create(v_u_8, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ["Size"] = UDim2.fromScale(p14 / 3, 1)
                }):Play()
            end
            if v_u_11 then
                local v19 = v_u_9
                local v20 = v_u_11.OverrideName
                v19.Text = ("%* Stocks: %*/%*"):format(string.gsub(v20 or "", "(%l)([%u%d])", "%1 %2"), v_u_11.Current, v_u_11.Max)
                return
            end
            if p14 then
                v_u_13 = p14
            end
            v_u_9.Text = ("Stocks: %*/%*"):format(p14 or v_u_13, 3)
        end
    end)
    local function v_u_22(p21)
        if not v_u_10 then
            v_u_8.Visible = false
            v_u_10 = v_u_8:Clone()
            v_u_10.Name = ("%*Bar"):format(p21.OverrideName)
            v_u_10.ZIndex = v_u_8.ZIndex + 1
            v_u_10.Size = UDim2.fromScale(p21.Current / p21.Max, 1)
            v_u_10.BackgroundColor3 = v_u_6[p21.OverrideName] or Color3.new(1, 1, 1)
            v_u_10.Visible = true
            v_u_10.Parent = v_u_7
            return v_u_10
        end
    end
    v_u_4.OnReplicate("HealthStocksOverride"):Connect(function(p23, p24)
        local _ = p23.OverrideName
        local v25 = p23.Current
        local v26 = p23.Max
        if not v_u_10 then
            v_u_22(p23)
        end
        v_u_11 = p23
        if p24 == "Update" then
            v_u_3:Create(v_u_10, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Size"] = UDim2.fromScale(v25 / v26, 1)
            }):Play()
        end
        if p24 == "Remove" or v25 <= 0 then
            if v_u_10 then
                v_u_10:Destroy()
                v_u_10 = nil
            end
            v_u_11 = nil
            v_u_8.BackgroundColor3 = v_u_12
            v_u_8.Visible = true
            if v_u_13 then
                v_u_8.Size = UDim2.fromScale(v_u_13 / 3, 1)
            end
            v_u_4.RequestInitData("HealthStocks")
        end
        if v_u_11 then
            local v27 = v_u_9
            local v28 = v_u_11.OverrideName
            v27.Text = ("%* Stocks: %*/%*"):format(string.gsub(v28 or "", "(%l)([%u%d])", "%1 %2"), v_u_11.Current, v_u_11.Max)
        else
            v_u_9.Text = ("Stocks: %*/%*"):format(v_u_13, 3)
        end
    end)
end)
return {}

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = require(v2.Modules.Gameplay.ClientEnemyHandler)
local v_u_4 = require(v1.Modules.Gameplay.GameHandler)
local v_u_5 = {
    ["NONE"] = Color3.new(0.45, 0.45, 0.45),
    ["UNKNOWN"] = Color3.new(),
    ["Passion"] = Color3.fromHex("ffb7d8"),
    ["Fire"] = Color3.fromHex("ff9f2a"),
    ["Water"] = Color3.fromHex("1d5aff"),
    ["Nature"] = Color3.fromHex("00ff73"),
    ["Spark"] = Color3.fromHex("03ebfe"),
    ["Holy"] = Color3.fromHex("fffea8"),
    ["Curse"] = Color3.fromHex("580087"),
    ["Unbound"] = Color3.fromHex("bf0010"),
    ["Blast"] = Color3.fromHex("f0f0f0"),
    ["Cosmic"] = Color3.fromHex("b373ff")
}
local v_u_26 = {
    ["GetColorForElements"] = function(_, p6)
        if not (p6 and p6[1]) then
            return v_u_5.NONE
        end
        if table.find(p6, "Unknown") then
            return v_u_5.UNKNOWN
        end
        local v7 = Color3.new()
        local v8 = 0
        for _, v9 in next, p6 do
            local v10 = v_u_5[v9] or warn((("No color for element %*!?!?!?"):format(v9)))
            if v10 then
                v8 = v8 + 1
                v7 = v7:Lerp(v10, 1 / v8)
            end
        end
        return v7
    end,
    ["_Init"] = function(_)
        v_u_3.EnemySpawned:Connect(function(p11)
            if p11.Name == "Elemental" then
                local v12 = v_u_4.GameData.PortalData
                local v13
                if v12 then
                    v13 = v12.Elements
                else
                    v13 = v12
                end
                if v12 then
                    v12 = v12.DebuffedElements
                end
                local v14 = p11.Data.Elements and p11.Data.Elements[1] and p11.Data.Elements
                if v14 then
                    v12 = v14
                elseif v13 and v13[1] then
                    v12 = v13 or v12
                end
                local v15 = p11.Model
                local v16 = v_u_26:GetColorForElements(v12)
                local v17 = next
                local v18, v19 = v15:GetChildren()
                for _, v20 in v17, v18, v19 do
                    if v20:IsA("BasePart") and v20.Transparency ~= 1 then
                        v20.Color = v16
                    end
                end
                if v12 and table.find(v12, "Unknown") then
                    local v21 = next
                    local v22, v23 = v15.Meshes:GetChildren()
                    for _, v24 in v21, v22, v23 do
                        local v25 = v24:FindFirstChildWhichIsA("SurfaceAppearance")
                        if v25 then
                            v25:Destroy()
                        end
                        v24.Color = Color3.new(1, 0, 0)
                        v24.Material = Enum.Material.Neon
                    end
                end
            end
        end)
    end
}
return v_u_26
game:GetService("ReplicatedStorage")
local v1 = game:GetService("StarterPlayer")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("ReplicatedStorage")
local v_u_4 = require(v3.Modules.Shared.AnimationHandler)
local v5 = require(v1.Modules.Gameplay.ClientEnemyHandler)
require(v3.Modules.Data.Units.HorsegirlRacingData)
local v_u_6 = {
    ["Cache"] = {},
    ["CallbackCache"] = {}
}
local v_u_7 = {
    ["Alien Cadet"] = true,
    ["Fast Puppet"] = true,
    ["Argon"] = true,
    ["Ghoul"] = true,
    ["Masked Ghoul"] = true
}
local v_u_8 = {
    ["God Statue"] = 0.25,
    ["Turbo Spirit Crab"] = 0.25,
    ["The Founder, Arin"] = 1,
    ["Goat"] = 1,
    ["Shield Statue"] = 0.65,
    ["Dragon Fang Beast"] = 2,
    ["Red Ant"] = 1.35,
    ["Nuclear Giant"] = 0.25,
    ["Nuclear Giant (B)"] = 0.25,
    ["Nuclear Giant (S)"] = 0.25,
    ["Wheel Skeleton"] = -1
}
local v_u_9 = {
    ["Blood-Red Commander, Igros"] = 1,
    ["Apostle 1"] = 3,
    ["Apostle 2"] = 3
}
local function v_u_11()
    for _, v10 in script:GetDescendants() do
        if v10:IsA("ModuleScript") and not v_u_6.CallbackCache[v10.Name] then
            v_u_6.CallbackCache[v10.Name] = require(v10)
        end
    end
end
local v_u_12 = {}
task.spawn(function()
    v_u_11()
    local v_u_13 = 0
    v_u_2.Heartbeat:Connect(function()
        debug.profilebegin((("Animate %* enemies"):format(v_u_13)))
        v_u_13 = 0
        for _, v_u_14 in v_u_12 do
            v_u_13 = v_u_13 + 1
            local v15 = v_u_14.EnemyData
            local v16 = v15.Data
            local v17 = v15.Name
            local v18 = v16.Class
            local _ = v16.Mutators
            local v19 = v16.Speed or 1
            local v20 = v_u_7[v17] or v19 >= 2.5
            local v21 = v19 == 0 and "Idle" or (v18 == "Flying" and "Fly" or (v20 and "Run" or "Walk"))
            local v22 = v_u_14.AnimationInstance.LoadedAnimations[v21]
            if v22 and v22 ~= v_u_14.CurrentAnimation then
                if v_u_14.CurrentAnimation then
                    v_u_14.CurrentAnimation:Stop(0)
                end
                v_u_14.IsPlaying = v22.IsPlaying
                v_u_14.CurrentAnimation = v22
                v22.Stopped:Once(function()
                    local v23 = v_u_14.CurrentAnimation
                    v_u_14.IsPlaying = v23 and v23.IsPlaying or false
                end)
            end
            local v24 = v_u_14.IsPlaying
            if v19 == 0 or (v24 or not v22) then
                if v19 == 0 then
                    if v22 then
                        if not v24 then
                            v22:Play(0)
                            v_u_14.IsPlaying = true
                            v_u_14.CurrentAnimation = v22
                        end
                    elseif v24 and v_u_14.CurrentAnimation then
                        v_u_14.CurrentAnimation:Stop(0)
                        v_u_14.CurrentAnimation = nil
                        v_u_14.IsPlaying = false
                    end
                end
            else
                local v25 = v_u_8[v17] or 0.525
                local v26 = v21 == "Run" and (v_u_9[v17] or 0.6) or false
                v22:Play(0)
                v22:AdjustSpeed(v26 or v25)
                v_u_14.IsPlaying = true
                v_u_14.CurrentAnimation = v22
                local v27 = v15.Model
                if v_u_6.CallbackCache[v17] then
                    v_u_6.CallbackCache[v17](v27)
                end
            end
        end
        debug.profileend()
    end)
end)
v5.EnemySpawned:Connect(function(p28)
    local _ = p28.Model.Name
    v_u_12[p28.UniqueIdentifier] = {
        ["EnemyData"] = p28,
        ["CurrentAnimation"] = nil,
        ["IsPlaying"] = false,
        ["AnimationInstance"] = v_u_4.new(p28.Model)
    }
end)
v5.EnemyDespawned:Connect(function(p29)
    v_u_12[p29.UniqueIdentifier] = nil
end)
v5.EnemyModelChanged:Connect(function(p30, _)
    v_u_12[p30.UniqueIdentifier].AnimationInstance = v_u_4.new(p30.Model)
end)
function v_u_6.PlayEnemiesAnimation(_, p31, p32, p33)
    if p33 then
        p33 = p33.FinishBeforePlaying
    end
    for _, v34 in ipairs(p31) do
        local v35 = v_u_4:GetAnimation(v34, p32)
        if not (p33 and (v35 and v35.IsPlaying)) and v35 then
            v35:Play(0)
        end
    end
end
function v_u_6.PlayEnemyIdle(_, p36)
    local v37 = v_u_4.new(p36).LoadedAnimations.Idle
    if not v37 then
        return nil
    end
    v37:Play(0)
    v37.Looped = true
    return v37
end
return v_u_6
game:GetService("Players")
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = require(v1.Modules.Packages.BoatTween)
local v_u_5 = require(v2.Modules.Gameplay.ClientEnemyHandler)
local v_u_6 = require(v2.Modules.Interface.Loader.HUD.BossHealth)
local v_u_7 = v1.Networking.BreakGaugeEvent
local v_u_8 = {}
local v_u_9 = {
    ["Sukono, King of Curses"] = script.SukonoGauge
}
local v_u_10 = {}
local function v_u_20(p_u_11)
    local v12 = v_u_4
    local v13 = p_u_11.UIGradient
    local v14 = {
        ["Time"] = 0.07,
        ["EasingStyle"] = "Back",
        ["EasingDirection"] = "Out",
        ["StepType"] = "Heartbeat",
        ["Goal"] = {
            ["Color"] = script.DamagedColor.Color
        }
    }
    local v_u_15 = v12:Create(v13, v14)
    v_u_15:Play()
    v_u_15.Completed:Connect(function()
        v_u_15:Destroy()
    end)
    task.delay(0.07, function()
        local v16 = v_u_4
        local v17 = p_u_11.UIGradient
        local v18 = {
            ["Time"] = 0.07,
            ["EasingStyle"] = "Back",
            ["EasingDirection"] = "Out",
            ["StepType"] = "Heartbeat",
            ["Goal"] = {
                ["Color"] = script.DefaultColor.Color
            }
        }
        local v_u_19 = v16:Create(v17, v18)
        v_u_19:Play()
        v_u_19.Completed:Connect(function()
            v_u_19:Destroy()
        end)
    end)
end
local v_u_21 = TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_22 = TweenInfo.new(0.225, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_23 = { -7, 7 }
local function v_u_30(p24, p25)
    local v26 = tostring(p24)
    if p25 == nil then
        p25 = false
    end
    local v27 = v_u_8[v26]
    assert(v27, "No bar dude!")
    local _ = v27.Value
    local _ = v27.MaxValue
    local v28 = v27.Alpha
    local v29 = v27.Frame.Progress
    if p25 then
        v29.Rotation = v_u_23[math.random(#v_u_23)]
        v_u_3:Create(v29, v_u_22, {
            ["Rotation"] = 0
        }):Play()
        v_u_20(v29)
    end
    v_u_3:Create(v29, v_u_21, {
        ["Size"] = UDim2.fromScale(v28 / 1, 1)
    }):Play()
end
local function v_u_42(p31, p32)
    local v33 = tonumber(p31)
    local v34 = tostring(v33)
    local v35 = p32.Value
    local v36 = p32.MaxValue
    local v37 = v_u_5._ActiveEnemies[v33]
    if v37 then
        if v37 and v_u_10[v33] then
            v_u_10[v34] = nil
        end
        print("hello bro? come ond ude")
        local v38 = v37.Data.Name
        local v39 = v_u_6.GetHealthBar(v33)
        assert(v39, "No health bar, dude!")
        local v40 = v39:FindFirstChild("Holder")
        local v41 = (v_u_9[v38] or script.BreakGauge):Clone()
        v41.Parent = v40 or v39
        v_u_8[v34] = {
            ["Value"] = v35,
            ["MaxValue"] = v36,
            ["Alpha"] = 1,
            ["Frame"] = v41
        }
        v_u_30(v33)
    else
        v_u_10[v34] = p32
    end
end
task.spawn(function()
    v_u_7.OnClientEvent:Connect(function(p43, p44, p45)
        if p43 == "Add" then
            v_u_42(p44, p45)
            return
        elseif p43 == "Update" then
            local v46 = tostring(p44)
            local v47 = ({
                ["Alpha"] = p45
            }).Alpha
            local v48 = v_u_8[v46]
            if v48 then
                v48.Alpha = v47
            end
            v_u_30(p44, true)
        elseif p43 == "Remove" then
            local v49 = tostring(p44)
            local v50 = v_u_8[v49]
            if v50 then
                v50.Frame:Destroy()
                v_u_8[v49] = nil
            end
        end
    end)
    v_u_6.HealthBarAdded:Connect(function(p51)
        local v52 = tostring(p51)
        local v53 = v_u_10[v52]
        if v53 then
            v_u_42(v52, v53)
        end
    end)
end)
return {}
game:GetService("Players")
game:GetService("ReplicatedStorage")
local v1 = game:GetService("StarterPlayer")
local v_u_2 = require(v1.Modules.Gameplay.ClientEnemyHandler)
require(v1.Modules.Gameplay.ClientEnemyHandler.Events)
local v_u_3 = {}
local v4 = {}
for _, v5 in script:GetDescendants() do
    if v5:IsA("ModuleScript") then
        v_u_3[v5.Name] = require(v5)
    end
end
local v_u_6 = { "Friezo", "Deidara", "God Statue" }
function v4.Init()
    v_u_2.EnemyDespawned:Connect(function(p7)
        local v8 = p7.Data.Type
        local v9 = p7.Name
        local v10 = p7.Model
        local v11 = v_u_3[v9]
        if v11 then
            task.spawn(v11.Start, v11, p7)
            return
        elseif table.find(v_u_6, v9) then
            v10.Parent = nil
            return
        elseif v8 and v8 == "Boss" then
            v_u_3.Bosses:Start(p7)
        end
    end)
end
task.spawn(v4.Init)
return v4
local v_u_1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("StarterPlayer")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("UserInputService")
local v_u_6 = workspace.CurrentCamera
local v_u_7 = require(v2.Modules.Utilities.NumberUtils)
local v_u_8 = require(v3.Modules.Gameplay.ClientEnemyHandler)
require(v2.Modules.Debug.Gizmo)
local v_u_9 = RaycastParams.new()
v_u_9.FilterType = Enum.RaycastFilterType.Include
v_u_9.FilterDescendantsInstances = { workspace.Entities }
local v_u_10 = script.BillboardGui
local v_u_11 = v_u_10.Holder.Speed.Label
local v_u_12 = nil
local function v_u_13()
    v_u_12 = nil
    if v_u_10.Enabled then
        v_u_10.Enabled = false
    end
end
local function v_u_18(p14)
    local v15 = p14.Name
    local v16 = tonumber(v15)
    local v17 = v_u_8._ActiveEnemies[v16]
    if not v17 then
        return v_u_13()
    end
    v_u_11.Text = v_u_7:TruncateNumber(v17.Data.Speed, 2)
    if v_u_12 ~= v16 then
        v_u_12 = v16
        v_u_10.Adornee = p14:FindFirstChild("Head") or p14.PrimaryPart
        v_u_10.Enabled = true
    end
end
task.spawn(function()
    if game.PlaceId == 121358414838610 then
        v_u_10.Enabled = false
        v_u_10.Parent = v_u_1.LocalPlayer.PlayerGui
        v_u_10.Name = "EnemyHoverInfo"
        v_u_4.Heartbeat:Connect(function(_)
            local v19 = v_u_5:GetMouseLocation()
            local v20 = v_u_6:ViewportPointToRay(v19.X, v19.Y)
            local v21 = workspace:Raycast(v20.Origin, v20.Direction * 1000, v_u_9)
            local v22 = v21 and v21.Instance:FindFirstAncestorOfClass("Model")
            if v22 then
                return v_u_18(v22)
            end
            v_u_12 = nil
            if v_u_10.Enabled then
                v_u_10.Enabled = false
            end
        end)
    end
end)
return {}
local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = require(v_u_1.Modules.Utilities.SerDesUtils)
local v_u_4 = require(v_u_1.Modules.Data.Entities.Enemies)
local v_u_5 = require(v_u_1.Modules.Shared.EnemyPathHandler)
require(v2.Modules.Gameplay.ClientEnemyHandler.Types)
local v_u_6 = require(v_u_1.Modules.Gameplay.ClientGameStateHandler)
local v_u_7 = require(v_u_1.Modules.Shared.CollisionHandler)
local v_u_8 = {}
local function v_u_17(p9, p10)
    local v11 = p10.Value
    local v12 = 0
    local v13 = 0
    while true do
        if buffer.len(p9) <= v11 then
            error("Buffer underflow during VLQ decoding")
        end
        local v14 = buffer.readu8(p9, v11)
        v11 = v11 + 1
        local v15 = bit32.band(v14, 127)
        local v16 = bit32.lshift(v15, v12)
        v13 = bit32.bor(v13, v16)
        v12 = v12 + 7
        if bit32.band(v14, 128) == 0 then
            p10.Value = v11
            return v13
        end
    end
end
v_u_8.DecodeVLQ = v_u_17
function v_u_8.ReadEnemyType(p18)
    local v19 = {
        ["Value"] = 0
    }
    v_u_17(p18, v19)
    return v_u_4:RetrieveEnemyDataById((v_u_17(p18, v19))).Type
end
function v_u_8.IsEnemyStatic(p20)
    local v21 = {
        ["Value"] = 0
    }
    v_u_17(p20, v21)
    return v_u_4:RetrieveEnemyDataById((v_u_17(p20, v21))).IsStatic
end
function v_u_8.ReadStaticEnemyData(p22)
    local v23 = {
        ["Value"] = 0
    }
    return v_u_17(p22, v23), v_u_17(p22, v23), v_u_17(p22, v23), v_u_17(p22, v23)
end
function v_u_8.ReadEnemyData(p24)
    local v25 = {
        ["Value"] = 0
    }
    local v26 = v_u_17(p24, v25)
    local v27 = v_u_17(p24, v25)
    local v28 = v_u_17(p24, v25)
    local v29 = v_u_17(p24, v25)
    local v30 = v25.Value
    local v31 = buffer.readf64(p24, v30)
    v25.Value = v25.Value + 8
    return v26, v27, v28, v29, v31
end
function v_u_8.ReadSpeedData(p32, p33)
    local v34 = v_u_17(p32, p33)
    local v35 = p33.Value
    local v36 = buffer.readf64(p32, v35)
    p33.Value = p33.Value + 8
    return v34, v36
end
function v_u_8.ReadPositionData(p37, p38)
    local v39 = v_u_17(p37, p38)
    local v40 = p38.Value
    local v41 = buffer.readu8(p37, v40)
    p38.Value = p38.Value + 1
    local v42 = p38.Value
    local v43 = buffer.readu8(p37, v42)
    p38.Value = p38.Value + 1
    local v44 = p38.Value
    local v45 = buffer.readu16(p37, v44)
    p38.Value = p38.Value + 2
    local v46 = v45 / 65536
    return v39, v_u_5.Nodes[("%*-%*"):format(v41, v43)], v46
end
function v_u_8.ReadEnemySpawnData(p47, p48, p49)
    local v50 = v_u_8.ReadEnemyType(p48.A)
    local v51 = nil
    local v52 = nil
    local v53, v54, v55, v56
    if v_u_8.IsEnemyStatic(p48.A) or p48.F then
        v52 = p48.F
        v53, v54, v55, v56 = v_u_8.ReadStaticEnemyData(p48.A)
    else
        v53, v54, v55, v56, v51 = v_u_8.ReadEnemyData(p48.A)
    end
    if p49(v53) then
        return nil, nil
    end
    local v57 = p48.B
    local v58 = p48.E
    local v59 = p48.BP
    local v60 = p48.EW or {}
    local v61 = p48.OD
    local v62 = p48.DN
    local v63 = p48.OM
    local v64 = p48.OHO
    local v65
    if type(v63) == "string" then
        v65 = v_u_1.Assets.Models.PlayerEnemies:FindFirstChild(v63)
        if v65 then
            v_u_7:SetCollisionGroup(v65, "Entities", true)
            v65:ScaleTo(0.5)
        else
            v65 = v63
        end
    else
        v65 = v63
    end
    local v66 = p48.ST
    local v67 = p48.SB
    local v68 = p48.GS or v_u_6.DefaultState.Id
    local v69 = p48.PS == true and true or nil
    local v70, v71
    if p48.C then
        local v72 = p48.C
        v70 = buffer.readu32(v72, 0)
        local v73 = p48.C
        v71 = buffer.readu32(v73, 4)
    else
        v70 = nil
        v71 = nil
    end
    local v74
    if p48.D then
        local v75 = p48.D
        v74 = buffer.readu8(v75, 0)
    else
        v74 = nil
    end
    local v76 = 1
    local v77 = v50 == "UnitSummon" and (v_u_5.MaxNodes or 0) or 0
    local v78
    if p48.G then
        local v79 = p48.G
        v78 = buffer.readu16(v79, 0) / 65535
        v77 = buffer.readu8(v79, 2)
        if buffer.len(v79) > 3 then
            v76 = buffer.readu8(v79, 3)
        end
    else
        v78 = 0
    end
    return {
        ["Index"] = v53,
        ["Id"] = v54,
        ["Health"] = v55,
        ["MaxHealth"] = v56,
        ["SpawnedAtServerTime"] = p47,
        ["Speed"] = v51 or 0,
        ["PredictedKiller"] = p48.PK or nil,
        ["Mutators"] = v57,
        ["Modifiers"] = v58,
        ["BattlepassEnemy"] = v59,
        ["SecondaryHealth"] = v70,
        ["SecondaryMaxHealth"] = v71,
        ["Shields"] = v74,
        ["Elements"] = v60,
        ["CurrentNode"] = v77,
        ["IndexGroup"] = v76,
        ["Alpha"] = v78,
        ["EnemyCFrame"] = v52,
        ["DisplayName"] = v62,
        ["OverrideModel"] = v65,
        ["OverrideHeightOffset"] = v64,
        ["SummonType"] = v66,
        ["GameStateId"] = v68,
        ["PlayerSpawn"] = v69,
        ["SpawnedBy"] = v67
    }, v61
end
function v_u_8.ReadHealthBuffer(p80, p81)
    local v82 = {
        ["EnemyId"] = v_u_17(p80, p81)
    }
    local v83 = p81.Value
    local v84 = buffer.readu8(p80, v83)
    p81.Value = p81.Value + 1
    local v85, v86, v87 = v_u_3.PopBool(v84)
    if v85 then
        v82.Health = v_u_17(p80, p81)
        v82.MaxHealth = v_u_17(p80, p81)
    end
    if v86 then
        v82.SecondaryHealth = v_u_17(p80, p81)
        v82.SecondaryMaxHealth = v_u_17(p80, p81)
    end
    if v87 then
        local v88 = p81.Value
        v82.Shields = buffer.readu8(p80, v88)
        p81.Value = p81.Value + 1
    end
    return v82
end
return v_u_8
game:GetService("Players")
game:GetService("ReplicatedStorage")
local v1 = game:GetService("StarterPlayer")
game:GetService("RunService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = require(v1.Modules.Gameplay.ClientEnemyHandler)
local v_u_4 = require(v1.Modules.Visuals.Misc.StatusEffects)
local v_u_5 = require(v1.Modules.Gameplay.SettingsHandler)
local v_u_6 = require(v2.Modules.Data.Entities.DebuffsData)
local v_u_7 = v2.Networking.EnemyStatusEvent
local v8 = v2.Assets.Interfaces.StatusEffects
local v9 = v2.Assets.Misc.Interfaces.Enemies.EnemyGui
local v10 = v2.Assets.Misc.Interfaces.Enemies.EnemyGui_Simplified
local v_u_11 = {}
for _, v12 in v8:GetChildren() do
    v_u_11[v12.Name] = v12
    for _, v13 in { v9.Status, v10.Status } do
        local v14 = v12:Clone()
        v14.Visible = false
        v14.Parent = v13
    end
end
local v15 = {}
local v_u_16 = {}
local v_u_17 = {}
local v_u_18 = {}
local v_u_19 = Color3.fromRGB(165, 165, 165)
local v_u_20 = Color3.fromRGB(255, 255, 255)
local function v_u_30(p21, p22)
    local v23 = v_u_3.GetEnemyGui(p21, 2)
    if v23 and v23.Parent then
        if not v_u_17[p21] then
            v_u_17[p21] = {}
        end
        local v24 = v_u_17[p21]
        if v24[p22] then
            v24[p22] = v24[p22] + 1
        else
            v24[p22] = 1
        end
        local v25 = v_u_16[p21]
        if not v25 then
            v25 = {}
            v_u_16[p21] = v25
        end
        local v26 = v25[p22]
        if v26 and v26.RemoveDisplayThread then
            v26.ImageLabel.ImageColor3 = v_u_20
            task.cancel(v26.RemoveDisplayThread)
            v26.RemoveDisplayThread = nil
        end
        if v26 then
            return
        elseif ({
            ["Silenced"] = true
        })[p22] then
            return
        elseif v_u_11[p22] then
            local v27 = v23.Status
            for _, v28 in v27:GetChildren() do
                if v28:IsA("ImageLabel") and v28.Visible then
                    v25[v28.Name] = {
                        ["ImageLabel"] = v28
                    }
                end
            end
            if not v_u_5:GetSetting("DisableEnemyTags") then
                v27.Visible = true
            end
            local v29 = v27[p22]
            v29.ImageColor3 = v_u_20
            v29.Visible = true
            v25[p22] = {
                ["ImageLabel"] = v29,
                ["RemoveDisplayThread"] = nil
            }
            if not v_u_18[p21] then
                v_u_18[p21] = v27
            end
        else
            warn((("Missing icon for %*"):format(p22)))
        end
    else
        return
    end
end
local function v_u_45(p_u_31, p_u_32, p33)
    local v_u_34 = v_u_16[p_u_31]
    local v_u_35 = v_u_18[p_u_31]
    if v_u_34 and v_u_35 then
        local v36 = v_u_17[p_u_31]
        local v37 = false
        if v36 and v36[p_u_32] then
            local v38 = v36[p_u_32] - (p33 or 1)
            v36[p_u_32] = math.max(0, v38)
            v37 = v36[p_u_32] == 0 and true or v37
        end
        local v_u_39 = v_u_34[p_u_32]
        if v_u_39 and v37 then
            task.spawn(function()
                local v40 = v_u_6.DebuffCategories[p_u_32]
                local v41 = v_u_6.DebuffImmunityCooldowns[p_u_32] or 0
                local v42 = v_u_6.CategoryLockoutDurations[v40] or 0
                local v43 = math.max(v41, v42)
                local v_u_44 = v_u_39.ImageLabel
                if v43 > 0 then
                    v_u_44.ImageColor3 = v_u_19
                    v_u_39.RemoveDisplayThread = task.delay(v43, function()
                        v_u_34[p_u_32] = nil
                        v_u_44.Visible = false
                        if next(v_u_34) == nil then
                            v_u_18[p_u_31] = nil
                            v_u_35.Visible = false
                        end
                        v_u_39.RemoveDisplayThread = nil
                    end)
                else
                    v_u_34[p_u_32] = nil
                    v_u_44.Visible = false
                    if next(v_u_34) == nil then
                        v_u_18[p_u_31] = nil
                        v_u_35.Visible = false
                    end
                end
            end)
        end
        return v37
    end
end
v_u_3.EnemyDespawned:Connect(function(p46)
    v_u_16[p46.UniqueIdentifier] = nil
end)
v_u_5.OnSettingUpdate:Connect(function(p47, p48)
    if p47 == "DisableEnemyTags" then
        for _, v49 in v_u_18 do
            v49.Visible = not p48
        end
    end
end)
local function v_u_54(p50)
    local v51 = {}
    for v52 = 1, buffer.len(p50) // 2 do
        local v53 = (v52 - 1) * 2
        v51[v52] = buffer.readu16(p50, v53)
    end
    return v51
end
local function v_u_62(p55, p56, p57, p58)
    local v59 = p58 and script.TagCallbacks:FindFirstChild(p58)
    if v59 then
        v59 = require(script.TagCallbacks[p58])
    end
    if v59 then
        v59 = v59[p55]
    end
    if v59 then
        for _, v60 in p57 do
            local v61 = v_u_3._ActiveEnemies[tonumber(v60)]
            if v61 and v61.Model then
                v59(v61.Model, p56)
            end
        end
    else
        v_u_4:Play(p55, p57, p56)
    end
end
function v15.Init()
    v_u_7.OnClientEvent:Connect(function(p63, p64, p65)
        debug.profilebegin("update enemy statuses")
        local v66 = workspace:GetServerTimeNow() - p64
        if p63 == "Add" then
            for _, v67 in p65 do
                local v68 = v67[1]
                local v69 = v67[2]
                local v70 = v67[3]
                if v70 then
                    v70 = v67[3] - v66
                end
                local v71 = v67[5]
                if not v70 or v70 > 0.08333333333333333 then
                    local v72 = v_u_54(v69)
                    for _, v73 in v72 do
                        v_u_30(v73, v68)
                    end
                    v_u_62(v68, v70, v72, v71)
                end
            end
        elseif p63 == "Remove" then
            for _, v74 in p65 do
                local v75 = v74[1]
                local v76 = v_u_54(v74[2])
                local v77 = v74[4]
                local v78 = {}
                for _, v79 in v76 do
                    if v_u_45(v79, v75, v77) then
                        table.insert(v78, v79)
                    end
                end
                v_u_4:Remove(v75, v78)
            end
        end
        debug.profileend()
    end)
end
task.spawn(v15.Init)
return v15
local v1 = game:GetService("StarterPlayer")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("ReplicatedStorage")
local v4 = game:GetService("Players")
local v5 = v3.Modules
local v_u_6 = v3.Assets
local v_u_7 = require(v1.Modules.Gameplay.SettingsHandler)
local v_u_8 = require(v5.Utilities.NumberUtils)
local v_u_9 = require(v5.Data.ModifierIcons)
local v_u_10 = require(v1.Modules.Interface.Loader.HUD.BossHealth)
require(v1.Modules.Gameplay.ClientEnemyHandler.Types)
local v_u_11 = require(v3.Modules.Gameplay.ClientGameStateHandler)
local v_u_12 = require(script.HealthBarEffectHandler)
local v_u_13 = require(script.EnemyElementsHandler)
local v_u_14 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_15 = workspace.CurrentCamera
local v_u_16 = v4.LocalPlayer
local v_u_17 = {
    ["Queue"] = {},
    ["ForceSimplified"] = false,
    ["EnemyTagsDisabled"] = v_u_7:GetSetting("DisableEnemyTags"),
    ["RenderedEnemies"] = {}
}
local v_u_18 = {
    ["Nuclear Giant"] = -10,
    ["Nuclear Giant (B)"] = 0,
    ["Nuclear Giant (S)"] = 0,
    ["Wall"] = 5,
    ["Goat"] = 5,
    ["Greater Undead"] = 2
}
function v_u_17.AddEnemyLabels(p19)
    if p19.PlayerSpawn or p19.GameStateId == v_u_11:GetPlayerState(v_u_16).Id then
        local v20 = p19.Model
        local v21 = p19.Data.Mutators
        local v22 = p19.Data.Modifiers
        local v23 = p19.Data.DisplayName
        local v24 = p19.Name
        local v25 = p19.Type
        local v26 = v20:GetExtentsSize()
        local v27 = 0.1 + v26.Magnitude / 10
        local v28 = math.max(v27, 1)
        local v29 = v26.Y / 2 + v28 + (v20:GetAttribute("UIOffset") or 0)
        local v30 = Vector3.new(0, v29, 0)
        local v31 = v25 == "Boss"
        local v32 = v_u_18[p19.Name] or v_u_18[v23]
        if v32 then
            v30 = v30 + Vector3.new(0, v32, 0)
        end
        local v33 = v_u_6.Misc.Interfaces.Enemies.EnemyGui:Clone()
        local v34 = v_u_6.Misc.Interfaces.Enemies.EnemyGui_Simplified:Clone()
        for _, v35 in { v33, v34 } do
            v35.StudsOffset = v30 - (v35 == v34 and Vector3.new(0, 1.75, 0) or Vector3.new(0, 0, 0))
            local v36 = v35.Size
            local v37 = math.min(v28, 1)
            v35.Size = UDim2.new(v36.X.Scale * v37, v36.X.Offset * v37, v36.Y.Scale * v37, v36.Y.Offset * v37)
            v35.Adornee = v20:FindFirstChild("Head") or v20:FindFirstChildOfClass("Part")
            v35.BossIcon.Visible = v31
        end
        v33.EnemyName.Text = v23 or v24
        if v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified then
            v34.Enabled = not v_u_17.EnemyTagsDisabled
            v33.Enabled = false
        else
            v34.Enabled = false
            v33.Enabled = not v_u_17.EnemyTagsDisabled
        end
        v33.Parent = v20
        v34.Parent = v20
        local v38 = v33.Modifiers
        if v21 then
            v38.Visible = true
            for _, v39 in v21 do
                local v40 = v_u_9[v39.Name]
                if v40 then
                    if v39.Name then
                        if not v38:FindFirstChild(v39.Name) then
                            local v41 = script.ModifierFrame:Clone()
                            v41.Name = v39.Name
                            v41.Icon.Image = v40
                            v41.Parent = v38
                        end
                    end
                end
            end
        end
        local v42 = v34.Modifiers
        if v21 then
            v42.Visible = true
            for _, v43 in v21 do
                local v44 = v_u_9[v43.Name]
                if v44 then
                    if v43.Name then
                        if not v42:FindFirstChild(v43.Name) then
                            local v45 = script.ModifierFrame:Clone()
                            v45.Name = v43.Name
                            v45.Icon.Image = v44
                            v45.Parent = v42
                        end
                    end
                end
            end
        end
        local v46 = v33.Modifiers
        if v22 then
            v46.Visible = true
            for _, v47 in v22 do
                local v48 = v_u_9[v47.Name]
                if v48 then
                    if v47.Name then
                        if not v46:FindFirstChild(v47.Name) then
                            local v49 = script.ModifierFrame:Clone()
                            v49.Name = v47.Name
                            v49.Icon.Image = v48
                            v49.Parent = v46
                        end
                    end
                end
            end
        end
        if v25 == "UnitSummon" then
            for _, v50 in { v33, v34 } do
                v50.HealthBar.Health.ImageColor3 = Color3.fromRGB(0, 255, 51)
            end
        end
        if v31 then
            v33.EnemyName.TextColor3 = Color3.fromRGB(215, 62, 65)
        end
        if p19 then
            p19.EnemyGui = v33
            p19.SimplifiedEnemyGui = v34
            v_u_13.CreateElementFrames(p19.Data.Elements, v33)
        else
            warn("NO ENEMY", debug.traceback())
        end
    else
        return
    end
end
function v_u_17.AddGuiData(p51)
    local v52 = p51.EnemyGui
    if v52 then
        local v53 = p51.SimplifiedEnemyGui
        local v54 = {}
        for _, v55 in v52.Modifiers:GetChildren() do
            if v55:IsA("ImageLabel") then
                table.insert(v54, v55)
            end
        end
        local v56 = v52.HealthBar
        local v57 = v56.Background
        local v58 = v56.YellowHealth
        local v59 = v56.Health
        local v60 = v56.Count
        local v61 = v56.Lines
        local v62 = v53.HealthBar
        p51.RenderData = {
            ["EnemyGui"] = v52,
            ["HasModifiers"] = #v54 > 0,
            ["Health"] = {
                ["Visible"] = true,
                ["Label"] = v60
            },
            ["Lines"] = {
                ["Visible"] = true,
                ["Label"] = v61
            },
            ["Name"] = {
                ["Visible"] = true,
                ["Label"] = v52:FindFirstChild("EnemyName")
            },
            ["Modifiers"] = {
                ["Visible"] = true,
                ["Labels"] = v54
            },
            ["CachedGui"] = {
                ["Gui"] = v52,
                ["MainFrame"] = v56,
                ["MainBackground"] = v57,
                ["YellowHealth"] = v58,
                ["Health"] = v59,
                ["Count"] = v60,
                ["Lines"] = v61,
                ["ModifiersFrame"] = {
                    ["Visible"] = true,
                    ["Label"] = v52.Modifiers
                }
            },
            ["SimplifiedCachedGui"] = {
                ["Gui"] = v53,
                ["MainFrame"] = v62,
                ["MainBackground"] = v62.Background,
                ["YellowHealth"] = v62.YellowHealth,
                ["Health"] = v62.Health,
                ["ModifiersFrame"] = {
                    ["Visible"] = true,
                    ["Label"] = v53.Modifiers
                }
            }
        }
    end
end
function v_u_17.UpdateHealthBar(p63, _, p64, p65, p66, p67)
    if p63.RenderData then
        if p64 and p65 then
            if p66 == "Boss" then
                v_u_10:UpdateBar(p63, p67, p64, p65)
            end
            p63.RenderData._PendingUpdateData = {
                ["Health"] = p64,
                ["MaxHealth"] = p65,
                ["EnemyType"] = p66,
                ["HealthType"] = p67
            }
            if v_u_17.EnemyTagsDisabled then
                return
            else
                local v68 = p63.Data.SecondaryHealth or 0
                local v69 = (v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified) and "SimplifiedEnemyGui" or "EnemyGui"
                if p63[v69].Enabled then
                    local v70 = v69 == "EnemyGui" and p63.RenderData.CachedGui or p63.RenderData.SimplifiedCachedGui
                    local v71 = p67 == "Secondary" and v70.YellowHealth or v70.Health
                    local v72 = p64 / p65
                    local v73 = UDim2.fromScale(v72, 1)
                    if v68 <= 0 and p67 == "Secondary" then
                        if v71.Visible then
                            v71.Visible = false
                        end
                    elseif p67 == "Secondary" then
                        v71.Visible = true
                    end
                    if v70.MainBackground then
                        v70.MainBackground.Visible = v72 < 1
                    end
                    if v69 == "EnemyGui" then
                        v70.Count.Text = ("%*/%*"):format(v_u_8:AbbreviateNumber(p64), (v_u_8:AbbreviateNumber(p65)))
                        local v74 = v71.Size
                        v_u_12.AddHealthBarEffect(v70.MainFrame, v71, v74, v73)
                    end
                    v_u_2:Create(v71, v_u_14, {
                        ["Size"] = v73
                    }):Play()
                end
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_84()
    local v75 = v_u_17.EnemyTagsDisabled
    local v76 = v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified
    v_u_17.EnemyTagsDisabled = v_u_7:GetSetting("DisableEnemyTags")
    local v77 = not v_u_17.EnemyTagsDisabled
    local v78
    if v77 then
        v78 = v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified
    else
        v78 = v77
    end
    local v79
    if v77 then
        local v80 = v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified
        v79 = not v80
    else
        v79 = v77
    end
    for _, v81 in v_u_17.RenderedEnemies do
        if v81.RenderData then
            if v81.SimplifiedEnemyGui then
                v81.SimplifiedEnemyGui.Enabled = v78
            end
            if v81.EnemyGui then
                v81.EnemyGui.Enabled = v79
            end
            local v82 = v75 ~= v_u_17.EnemyTagsDisabled and true or v76 ~= (v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified)
            if v81.RenderData._PendingUpdateData and (v82 and v77) then
                local v83 = v81.RenderData._PendingUpdateData
                v_u_17.UpdateHealthBar(v81, v81.Model, v83.Health, v83.MaxHealth, v83.EnemyType, v83.HealthType)
            end
        end
    end
end
v_u_84()
v_u_7.OnSettingUpdate:Connect(function(p85, _)
    if p85 == "SimplifiedEnemyGui" or p85 == "DisableEnemyTags" then
        v_u_84()
    end
end)
function v_u_17.RenderEnemies(p86, p87)
    if not v_u_17.EnemyTagsDisabled then
        local v88 = p87 <= 250 and 1 or (p87 - 250) / 100 + 1
        local v89 = v_u_15.CFrame.Position
        local v90 = v_u_7:GetSetting("SimplifiedEnemyGui") or v_u_17.ForceSimplified
        local v91 = v90 and "SimplifiedCachedGui" or "CachedGui"
        for _, v92 in p86 do
            local v93 = v92.RenderData
            if v93 then
                local v94 = v93[v91]
                local v95 = v94.Gui
                local v96 = (v92.Position - v89).Magnitude * v88
                if v96 < 90 then
                    if not v90 then
                        local v97 = v93.Name
                        local v98 = v97.Label
                        if v97.Visible ~= true then
                            v97.Visible = true
                            v98.Parent = v95
                        end
                    end
                    if v96 < 38 then
                        if not v90 then
                            local v99 = v93.Health
                            local v100 = v94.MainFrame
                            local v101 = v99.Label
                            if v99.Visible ~= true then
                                v99.Visible = true
                                v101.Parent = v100
                            end
                            local v102 = v93.Lines
                            local v103 = v96 < 25
                            local v104 = v94.MainFrame
                            local v105 = v102.Label
                            if v102.Visible ~= v103 then
                                v102.Visible = v103
                                if not v103 then
                                    v104 = nil
                                end
                                v105.Parent = v104
                            end
                        end
                        if v93.HasModifiers then
                            local v106 = v94.ModifiersFrame
                            local v107 = v96 < 28
                            local v108 = v106.Label
                            if v106.Visible ~= v107 then
                                v106.Visible = v107
                                if not v107 then
                                    v95 = nil
                                end
                                v108.Parent = v95
                            end
                        end
                    else
                        if not v90 then
                            local v109 = v93.Lines
                            local _ = v94.MainFrame
                            local v110 = v109.Label
                            if v109.Visible ~= false then
                                v109.Visible = false
                                v110.Parent = nil
                            end
                            local v111 = v93.Health
                            local _ = v94.MainFrame
                            local v112 = v111.Label
                            if v111.Visible ~= false then
                                v111.Visible = false
                                v112.Parent = nil
                            end
                        end
                        if v93.HasModifiers then
                            local v113 = v94.ModifiersFrame
                            local v114 = v113.Label
                            if v113.Visible ~= false then
                                v113.Visible = false
                                v114.Parent = nil
                            end
                        end
                    end
                else
                    if not v90 then
                        local v115 = v93.Name
                        local v116 = v115.Label
                        if v115.Visible ~= false then
                            v115.Visible = false
                            v116.Parent = nil
                        end
                        local v117 = v93.Health
                        local _ = v94.MainFrame
                        local v118 = v117.Label
                        if v117.Visible ~= false then
                            v117.Visible = false
                            v118.Parent = nil
                        end
                        local v119 = v93.Lines
                        local _ = v94.MainFrame
                        local v120 = v119.Label
                        if v119.Visible ~= false then
                            v119.Visible = false
                            v120.Parent = nil
                        end
                    end
                    if v93.HasModifiers then
                        local v121 = v94.ModifiersFrame
                        local v122 = v121.Label
                        if v121.Visible ~= false then
                            v121.Visible = false
                            v122.Parent = nil
                        end
                    end
                end
            end
        end
        v_u_17.RenderedEnemies = p86
        if p87 > 500 then
            if not v_u_17.ForceSimplified then
                v_u_17.ForceSimplified = true
                v_u_84()
                return
            end
        elseif v_u_17.ForceSimplified then
            v_u_17.ForceSimplified = false
            v_u_84()
        end
    end
end
return v_u_17
game:GetService("ReplicatedStorage")
local v1 = game:GetService("StarterPlayer")
local v_u_2 = game:GetService("Players")
local v_u_3 = game:GetService("Debris")
local v_u_4 = game:GetService("RunService")
local v5 = game:GetService("ReplicatedStorage")
local v6 = v5.Modules
local v_u_7 = require(v6.Data.Entities.Enemies)
local v_u_8 = require(v6.Data.EnemyDiameterData)
local v_u_9 = require(v6.Shared.EffectsHandler)
local v_u_10 = require(v6.Shared.AnimationHandler)
local v_u_11 = require(v6.Shared.SoundHandler)
local v_u_12 = require(v6.Shared.EnemyPathHandler)
local v13 = require(v5.Modules.Shared.DebugToggleHandler)
local v_u_14 = v13.CreateDebugPrint("clientEnemy")
local v_u_15 = require(v5.Modules.Gameplay.GameHandler)
local v_u_16 = require(v5.Modules.Shared.CollisionHandler)
local v_u_17 = require(v1.Modules.Gameplay.Units.ClientUnitHandler.Callbacks)
local v_u_18 = require(v1.Modules.Gameplay.Enemies.EnemyNetworkingHandler)
local v_u_19 = require(v6.Debug.Gizmo)
local v_u_20 = v1.Modules.Gameplay.ClientTransformHandler
local v_u_21 = require(v6.Utilities.TableUtils)
require(v6.Utilities.SerDesUtils)
local v_u_22 = require(script.EnemyEffectsHandler)
local v_u_23 = require(script.ShieldHandler)
local v24 = require(script.Events)
local v_u_25 = require(v1.Modules.Interface.Loader.HUD.BossHealth)
local v_u_26 = require(v1.Modules.Gameplay.ClientEnemyGuiHandler)
require(script.Types)
local v_u_27 = require(v5.Modules.Data.Units.HorsegirlRacingData)
local v_u_28 = v5.Networking
local v_u_29 = require(script.ActiveEnemies)
local v_u_30 = {
    ["_ActiveEnemies"] = v_u_29,
    ["AlreadyDeadEnemies"] = {},
    ["_EnemyShields"] = {},
    ["ENEMY_PRIORITY_DEBUG"] = false,
    ["DEBUG_IGNORE_UPDATE"] = false,
    ["EnemySpawned"] = v24.EnemySpawned,
    ["EnemyDespawned"] = v24.EnemyDespawned,
    ["EnemyModelChanged"] = v24.EnemyModelChanged,
    ["EnemyHealthChanged"] = v24.EnemyHealthChanged
}
v13.Bind("enemyPositions", function(p31)
    v_u_30.ENEMY_HITBOX_DEBUG = p31
end)
local v_u_32 = v_u_18.DecodeVLQ
local v_u_33 = {}
for _, v34 in script.OnSpawnedCallbacks:GetChildren() do
    v_u_33[v34.Name] = require(v34)
end
local v_u_35 = {}
function v_u_30.GetSortedEnemies(p36)
    return v_u_35[p36] or {}
end
local v_u_37 = {}
function v_u_30.HideEnemyModel(_, p_u_38)
    local v_u_39 = v_u_37[p_u_38]
    local v_u_40 = false
    if v_u_39 then
        v_u_39.HiddenCount = v_u_39.HiddenCount + 1
    elseif not v_u_39 then
        v_u_39 = {
            ["HiddenCount"] = 1,
            ["TransparencyValues"] = {}
        }
        for _, v41 in p_u_38:GetDescendants() do
            if v41:IsA("BasePart") or v41:IsA("Decal") then
                v41.LocalTransparencyModifier = 1
            end
        end
    end
    return function()
        if not v_u_40 then
            v_u_40 = true
            local v42 = v_u_39
            v42.HiddenCount = v42.HiddenCount - 1
            if v_u_39.HiddenCount == 0 then
                for _, v43 in p_u_38:GetDescendants() do
                    if v43:IsA("BasePart") or v43:IsA("Decal") then
                        v43.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end
end
function v_u_30.Init()
    if not v_u_12.IsLoaded then
        v_u_12.Loaded:Wait()
    end
    v_u_28.ClientListeners.Enemies.EnemySpawn.OnClientEvent:Connect(function(p44, p45)
        local function v47(p46)
            if not v_u_30.AlreadyDeadEnemies[p46] then
                return false
            end
            v_u_30.AlreadyDeadEnemies[p46] = nil
            return true
        end
        for _, v48 in p45 do
            local v49, v50 = v_u_18.ReadEnemySpawnData(p44, v48, v47)
            if v49 then
                task.spawn(v_u_30.SpawnEnemy, v49, v50)
            end
        end
    end)
    v_u_28.ClientListeners.Enemies.RemoveEnemy.OnClientEvent:Connect(function(p51)
        local v52 = buffer.readu16(p51, 0)
        v_u_30.RemoveEnemy(v52)
    end)
    v_u_28.ClientListeners.Enemies.RemoveAllEnemies.OnClientEvent:Connect(function()
        v_u_30.RemoveAllEnemies()
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemySpeed.OnClientEvent:Connect(function(p53, p54)
        local v55 = {
            ["Value"] = 0
        }
        while v55.Value < buffer.len(p54) do
            v_u_32(p54, v55)
            local _ = v55.Value
            local v56, v57 = v_u_18.ReadSpeedData(p54, v55)
            v_u_30.UpdateEnemySpeed(v56, p53, v57)
        end
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemyPosition.OnClientEvent:Connect(function(p58, p59)
        local v60 = {
            ["Value"] = 0
        }
        while v60.Value < buffer.len(p59) do
            v_u_32(p59, v60)
            local _ = v60.Value
            local v61, v62, v63 = v_u_18.ReadPositionData(p59, v60)
            v_u_30.UpdateEnemyPosition(v61, p58, v62, v63)
        end
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemyHealth.OnClientEvent:Connect(function(_, p64)
        local v65 = {
            ["Value"] = 0
        }
        while v65.Value < buffer.len(p64) do
            v_u_32(p64, v65)
            local _ = v65.Value
            local v66 = v_u_18.ReadHealthBuffer(p64, v65)
            v_u_30.UpdateEnemyHealth(v66)
        end
    end)
    local v_u_67 = v_u_30._ActiveEnemies
    local v_u_68 = 0
    local function v114(p69)
        if workspace:GetAttribute("GAME_FROZEN") then
            return
        end
        debug.profilebegin("Update enemies")
        debug.profilebegin("check enemies")
        local v70 = 0
        for _, v71 in v_u_35 do
            table.clear(v71)
        end
        for v72, v73 in v_u_67 do
            local v74 = v73.Data
            if not v74.IsStatic then
                if v74.Health < 1 then
                    v_u_30.RemoveEnemy(v72, true)
                else
                    local v75 = v74.Speed
                    local v76 = v75 < 0
                    local v77 = v73.CurrentNode
                    local v78
                    if v76 then
                        v78 = v77.GetPrevious(v73.PathSeed)
                    else
                        v78 = v77.GetNext(v73.PathSeed)
                    end
                    if v78 then
                        local v79 = 1.45 * v75
                        local v80 = math.abs(v79) * p69
                        while v80 > 0 do
                            local v81 = v73.CurrentNode.Position
                            local v82 = v78.Position
                            local v83 = (v81 - v82).Magnitude
                            if v83 <= 0 then
                                v73.CurrentNode = v78
                                v73.Alpha = 0
                                v73.Position = v82
                                if v76 then
                                    v78 = v73.CurrentNode.GetPrevious(v73.PathSeed)
                                else
                                    v78 = v73.CurrentNode.GetNext(v73.PathSeed)
                                end
                                if not v78 then
                                    break
                                end
                            else
                                local v84 = v80 / v83
                                local v85 = v73.Alpha + v84
                                if v85 < 0.9999 then
                                    v73.Alpha = v85
                                    v73.Position = v81:Lerp(v82, v73.Alpha)
                                    v80 = 0
                                else
                                    v80 = v80 - v83 * (0.9999 - v73.Alpha)
                                    v73.CurrentNode = v78
                                    v73.Alpha = 0
                                    v73.Position = v82
                                    if v76 then
                                        v78 = v73.CurrentNode.GetPrevious(v73.PathSeed)
                                    else
                                        v78 = v73.CurrentNode.GetNext(v73.PathSeed)
                                    end
                                    if not v78 then
                                        break
                                    end
                                end
                            end
                        end
                        v70 = v70 + 1
                        if v74.Type ~= "UnitSummon" then
                            v_u_35[v73.GameStateId] = v_u_35[v73.GameStateId] or {}
                            local v86 = v_u_35[v73.GameStateId]
                            local v87 = { (v73.CurrentNode.DistanceToStart or 0) + v73.Alpha, v73 }
                            table.insert(v86, v87)
                        end
                        if v_u_30.ENEMY_HITBOX_DEBUG then
                            v_u_19:DrawCircle(v73.Position, v73.Diameter / 2, p69, Color3.new(0, 0.65, 1))
                        end
                    elseif not v76 or v74.Type == "UnitSummon" then
                        v_u_30.RemoveEnemy(v72, true)
                    end
                end
            end
        end
        debug.profileend()
        debug.profilebegin((("Sort %* enemies"):format(v70)))
        for _, v88 in v_u_35 do
            table.sort(v88, function(p89, p90)
                return p89[1] > p90[1]
            end)
        end
        debug.profileend()
        if v_u_4:IsStudio() and v_u_30.ENEMY_PRIORITY_DEBUG then
            for _, v91 in v_u_35 do
                if #v91 ~= 0 then
                    local v92 = v91[1][2]
                    v_u_19:DrawCircle(v92.Position, v92.Diameter / 2, p69, Color3.new(0, 0.65, 1))
                    local v93 = v91[#v91][2]
                    v_u_19:DrawCircle(v93.Position, v93.Diameter / 2, p69, Color3.new(1, 0.65, 0))
                end
            end
        end
        debug.profilebegin((("render %* enemies"):format(v70)))
        local v94 = table.create(v70)
        local v95 = table.create(v70)
        for _, v96 in v_u_67 do
            local v97 = v96.Data
            if not (v97.IsStatic or v96._PausePositioning) then
                local v98 = v96.CurrentNode
                local v99 = v97.Speed
                local v100
                if v99 < 0 then
                    v100 = v98.GetPrevious(v96.PathSeed)
                else
                    v100 = v98.GetNext(v96.PathSeed)
                end
                if v100 then
                    local v101 = v96.Position
                    local v102 = CFrame.Angles
                    local v103 = v97.CustomAngle or 0
                    local v104 = v102(0, math.rad(v103), 0)
                    local v105 = v96.HeightOffset - v98.HeightOffset
                    local v106 = CFrame.lookAt(v101, v100.Position + Vector3.new(0, 0.0001, 0)) * v104 + v105
                    if not v96.CanRotate then
                        v106 = CFrame.new(v101) * v104 * (v96.RotationAngle or CFrame.identity).Rotation + v105
                    end
                    local v107 = v96.RenderCFrame
                    if v96.CanRotate or v96.Name ~= "Friran" then
                        if v96.Name == "The Founder, Arin" and v107 then
                            local v108 = CFrame.new(v101)
                            local v109 = v106 * CFrame.Angles(0, 3.141592653589793, 0)
                            local v110 = p69 * 2 * math.abs(v99)
                            v106 = v108 * v107:Lerp(v109, (math.min(1, v110))).Rotation - Vector3.new(0, 20, 0) + v105
                        elseif v107 then
                            local v111 = CFrame.new(v101)
                            local v112 = p69 * 2 * math.abs(v99)
                            v106 = v111 * v107:Lerp(v106, (math.min(1, v112))).Rotation + v105
                        end
                    else
                        v106 = (v96.RenderCFrame or CFrame.identity).Rotation + v101
                    end
                    if not v96.PrimaryPart then
                        warn((("Enemy %* has no PrimaryPart"):format(v96.Name)))
                    end
                    local v113 = v96.PrimaryPart
                    table.insert(v94, v113)
                    table.insert(v95, v106)
                    v96.RenderCFrame = v106
                end
            end
        end
        debug.profileend()
        workspace:BulkMoveTo(v94, v95, Enum.BulkMoveMode.FireCFrameChanged)
        v_u_26.RenderEnemies(v_u_67, #v95)
        debug.profileend()
        v_u_68 = v70
    end
    v_u_4.Heartbeat:Connect(v114)
end
function v_u_30.UpdateEnemySpeed(p115, p116, p117)
    local v118 = v_u_30._ActiveEnemies[p115]
    if v118 then
        local v119 = v118.Data
        local v120 = v119.Speed < 0
        local v121 = p117 < 0
        local v122 = v118.CurrentNode
        if not v120 and v121 or v120 and not v121 then
            v118.Alpha = 1 - v118.Alpha
            if v121 then
                local v123 = v122.GetNext(v118.PathSeed)
                if v123 then
                    v122 = v123
                else
                    v118.Alpha = 1
                end
            else
                local v124 = v122.GetPrevious(v118.PathSeed)
                if v124 then
                    v122 = v124
                else
                    v118.Alpha = 0
                end
            end
        end
        v118.CurrentNode = v122
        local v125 = v121 and v122.GetPrevious(v118.PathSeed) or v122.GetNext(v118.PathSeed)
        if v125 then
            local v126 = workspace:GetServerTimeNow() - p116
            local v127 = (v122.Position - v125.Position).Magnitude
            local v128 = (p117 - v119.Speed) * v126 / v127
            local v129 = math.abs(v128)
            v118.Alpha = v118.Alpha + v129
        end
        v118.CurrentNode = v122
        v119.Speed = p117
    end
end
function v_u_30.UpdateEnemyPosition(p130, p131, p132, p133)
    local v134 = v_u_30._ActiveEnemies[p130]
    if v134 then
        local v135 = v134.Data
        local v136 = workspace:GetServerTimeNow() - p131
        v134.CurrentNode = p132
        v134.Alpha = p133
        local v137 = v135.Speed < 0
        local v138 = v137 and p132.GetPrevious(v134.PathSeed) or p132.GetNext(v134.PathSeed)
        if v138 then
            local v139 = (p132.Position - v138.Position).Magnitude
            local v140 = v135.Speed
            local v141 = math.abs(v140) * v136 / v139
            local v142 = v135.Speed == 0 and 0 or v141
            if v137 then
                local v143 = v134.Alpha - v142
                v134.Alpha = math.max(0, v143)
                while v134.Alpha <= 0 and v134.CurrentNode.GetPrevious(v134.PathSeed) do
                    v134.CurrentNode = v134.CurrentNode.GetPrevious(v134.PathSeed)
                    v134.Alpha = 1 + v134.Alpha
                    local v144 = v134.CurrentNode.GetPrevious(v134.PathSeed)
                    if not v144 then
                        v134.Alpha = 0
                        return
                    end
                    local v145 = (v134.CurrentNode.Position - v144.Position).Magnitude
                    local v146 = v134.Alpha * v145
                    local _ = math.abs(v146) / v145
                end
            else
                local v147 = v134.Alpha + v142
                v134.Alpha = math.min(1, v147)
                while v134.Alpha >= 1 and v134.CurrentNode.GetNext(v134.PathSeed) do
                    v134.CurrentNode = v134.CurrentNode.GetNext(v134.PathSeed)
                    v134.Alpha = v134.Alpha - 1
                    local v148 = v134.CurrentNode.GetNext(v134.PathSeed)
                    if not v148 then
                        v134.Alpha = 1
                        return
                    end
                    local v149 = (v134.CurrentNode.Position - v148.Position).Magnitude
                    local v150 = v134.Alpha * v149
                    local _ = math.abs(v150) / v149
                end
            end
        end
    else
        return
    end
end
function v_u_30.GetEnemy(p151)
    return v_u_29[p151]
end
local v_u_152 = v_u_30._ActiveEnemies
local v_u_153 = v_u_26.UpdateHealthBar
local v_u_154 = v_u_26.AddEnemyLabels
local function v_u_169(p155, p156)
    local v157 = p155.Model
    if p156.EnemyCFrame then
        v157:PivotTo(p156.EnemyCFrame)
    else
        local _ = p155.Data
        local v158 = p155.CurrentNode
        local v159 = p156.Speed < 0
        local _ = p156.Speed == 0
        local v160
        if v159 then
            v160 = v158.GetPrevious(p155.PathSeed)
        else
            v160 = v158.GetNext(p155.PathSeed)
        end
        local v161 = ("No NextNode found for %*-%*"):format(v158.IndexGroup, v158.Index)
        assert(v160, v161)
        local v162 = p156.Alpha
        local v163 = p156.Speed
        local v164 = workspace:GetServerTimeNow() - p156.SpawnedAtServerTime
        local v165 = (v160.Position - v158.Position).Magnitude
        local v166 = v163 * v164 / v165
        local v167 = v158.Position:Lerp(v160.Position, v162 + v166)
        local v168 = CFrame.new(0, v157:GetExtentsSize().Y / 2, 0)
        v157:PivotTo(CFrame.lookAt(v167, v160.Position) * v168)
        p155.Position = v157:GetPivot().Position
    end
end
local v_u_170 = {
    ["Mutators"] = {
        ["Strong"] = "Strong",
        ["Sturdy"] = "Sturdy",
        ["Resilient"] = "Resilient",
        ["Challenger"] = "Challenger",
        ["Energy Drain"] = "Energy Drain"
    },
    ["Modifiers"] = {
        ["Regen"] = "Regen",
        ["Thrice"] = "Thrice"
    }
}
local function v_u_176(p171, p172, p173)
    if p171 then
        for _, v174 in p171 do
            local v175 = v_u_170.Mutators[v174] or v_u_170.Modifiers[v174]
            if v175 then
                v_u_22:PlayEffect(v175, p172, p173)
            end
        end
    end
end
local v_u_177 = { "Smith John", "Lord of Shadows" }
local v_u_178 = require(v5.Modules.Data.CurrencyData)
function v_u_30.UpdateEnemyModel(p179, p180, p181)
    local v182 = {}
    local v183 = {}
    local v184 = p179.UniqueIdentifier
    local v185 = p179.Model
    local v186 = p179.Data.Mutators
    local v187 = p179.Data.Modifiers
    local v188 = p179.BattlepassEnemy
    local v189 = p179.Data.DisplayName
    local v190 = p179.SummonType
    if p179.Type == "UnitSummon" and v190 then
        v_u_22:PlayEffect(("%*Summon"):format(v190), v185)
    end
    if not p179.IsStatic or table.find(v_u_177, p179.Name) then
        local v191 = p179.Name
        local v192 = p179.PreviousType
        local v193 = p179.Type == "UnitSummon" and v192 and v192 or p179.Type
        if not (v185:FindFirstChildOfClass("Humanoid") or v185:FindFirstChildOfClass("AnimationController")) then
            local v194 = Instance.new("AnimationController")
            v194.Parent = v185
            Instance.new("Animator").Parent = v194
        end
        local v195 = v193 == "Boss" and "Bosses" or "Enemies"
        if p181 then
            v191 = p181.Name
        end
        local v196 = v191 == "Thunder (You)" and "Thunder" or (v_u_27.UnitSpecializations[v189] and "Horsegirl" or v191)
        v_u_10:LoadAnimations(v185, "Enemies", "Default")
        v_u_10:LoadAnimations(v185, v195, v196)
    end
    local v197 = v_u_152[v184]
    if p180 == nil or not p180 then
        v_u_154(v197)
        v_u_26.AddGuiData(v197)
    end
    if v186 then
        for _, v198 in v186 do
            if not v183[v198] then
                v183[v198] = true
                table.insert(v182, v198)
            end
        end
    end
    if v187 then
        for _, v199 in v187 do
            if not v183[v199] then
                v183[v199] = true
                table.insert(v182, v199)
            end
        end
    end
    v_u_176(v182, v185, v197.EnemyGui)
    if v188 and (not p179.IsStatic and p179.Type ~= "UnitSummon") then
        local v200 = v_u_30._ActiveEnemies[v184]
        local v201
        if v200 then
            v201 = v200.EnemyGui
        else
            v201 = v200
        end
        if v200 and v201 then
            local v202 = v201.Status
            v202.Visible = true
            local v203 = script.BattlepassIcon:Clone()
            v203.Image = v_u_178:GetCurrencyDataFromName("Pass XP").Image
            v203.Parent = v202
        end
    end
    local v204 = v197.Data.OverrideHeightOffset
    if v204 then
        v197.HeightOffset = Vector3.new(0, v204, 0)
    else
        local v205 = v185:GetExtentsSize().Y / 2 + (v185:GetAttribute("Offset") or 0)
        v197.HeightOffset = Vector3.new(0, v205, 0)
    end
end
function v_u_30.UpdateEnemyStats(p206)
    local v207 = p206.Data
    local v208 = v207.Type
    if v208 == "Boss" and not v_u_25:DoesBarExist(p206.UniqueIdentifier) then
        local v209 = v207.DisplayName or p206.Name
        local v210 = v209 == v_u_2.LocalPlayer.DisplayName and "You" or v209
        v_u_25:AddBar({
            ["ID"] = p206.UniqueIdentifier,
            ["Name"] = p206.Name,
            ["DisplayName"] = v210,
            ["Model"] = p206.Model
        })
    end
    local v211 = p206.Model
    v_u_153(p206, v211, v207.Health, v207.MaxHealth, v208, "Main")
    local v212 = v207.SecondaryHealth
    if v212 then
        v_u_153(p206, v211, v212, v207.SecondaryMaxHealth, v208, "Secondary")
    end
    local v213 = v207.Shields
    if v213 then
        v_u_23:AddEnemy(v211, v213)
        v_u_23:UpdateEnemy(v211, v213)
    end
    p206.HasAttacks = v_u_20:FindFirstChild(p206.Name, true)
end
local function v_u_218(p214, p215)
    for v216, v217 in p215 do
        if v216 == "Type" then
            p214.PreviousType = p214.Type
            ::l5::
            p214[v216] = v217
        else
            if v216 ~= "SummonedBy" or (typeof(v217) ~= "table" or not v217.UniqueIdentifier) then
                goto l5
            end
            p214[v216] = v_u_17.GetActiveUnits()[v217.UniqueIdentifier]
        end
    end
end
function v_u_30.SpawnEnemy(p219, p220)
    local v221 = p219.Index
    local v222 = p219.Id
    local v223 = p219.BattlepassEnemy
    local v224 = v_u_21.DeepCopy(v_u_7:RetrieveEnemyDataById(v222))
    if p220 then
        v_u_218(v224, p220)
    end
    if v224.SpawnDelay then
        local v225 = v_u_15.MatchId
        local v226 = workspace:GetServerTimeNow() - p219.SpawnedAtServerTime
        task.wait(v224.SpawnDelay - v226)
        if v225 ~= v_u_15.MatchId then
            return
        end
        p219.SpawnedAtServerTime = p219.SpawnedAtServerTime + v224.SpawnDelay
    end
    local v227 = v_u_152[v221] == nil
    local v228 = ("Enemy with id %* already exists!"):format(v221)
    assert(v227, v228)
    local v229 = p219.OverrideModel
    local v230
    if v224.Name == "Friran" then
        local v231 = v_u_17.GetUnitModelFromGUID(p220.SummonedBy.UniqueIdentifier) or v224.Model
        v_u_14((("Friran spawning. Using unit model: %*"):format(v231)))
        v230 = v231:Clone()
        if v230:FindFirstChild("HandleR") then
            v230:FindFirstChild("HandleR"):Destroy()
        end
    else
        v_u_14((("Spawning enemy %* (%*). OverrideModel: %*"):format(v224.Name, v221, v229 or "none")))
        v230 = v229 and v229:Clone() or v224.Model:Clone()
    end
    v230.Name = tostring(v221)
    local v232 = p219.Mutators
    local v233 = p219.Modifiers
    local v234 = v224.Type
    local v235 = v230.PrimaryPart
    if not v224.IsStatic then
        local v236 = ("enemy \'%*\' has no primary part"):format((v224.Model:GetFullName()))
        assert(v235, v236)
    end
    (v230:FindFirstChild("HumanoidRootPart") or v230.PrimaryPart).CanQuery = true
    local v237 = v_u_12.Nodes[("%*-%*"):format(p219.IndexGroup or 1, p219.CurrentNode)]
    local v238 = {
        ["Data"] = {
            ["Type"] = v234,
            ["Class"] = v224.Class,
            ["Health"] = p219.Health,
            ["MaxHealth"] = p219.MaxHealth,
            ["PredictedKiller"] = p219.PredictedKiller,
            ["CustomAngle"] = v224.CustomAngle,
            ["SecondaryHealth"] = p219.SecondaryHealth,
            ["SecondaryMaxHealth"] = p219.SecondaryMaxHealth,
            ["Shields"] = p219.Shields,
            ["Elements"] = p219.Elements,
            ["Speed"] = p219.Speed,
            ["Mutators"] = v232,
            ["Modifiers"] = v233,
            ["IsStatic"] = v224.IsStatic,
            ["DisplayName"] = p219.DisplayName,
            ["OverrideModel"] = p219.OverrideModel,
            ["OverrideHeightOffset"] = p219.OverrideHeightOffset
        },
        ["ID"] = v224.ID,
        ["Name"] = v224.Name,
        ["UniqueIdentifier"] = v221,
        ["PathSeed"] = v221,
        ["GameStateId"] = p219.GameStateId,
        ["PlayerSpawn"] = p219.PlayerSpawn,
        ["Type"] = v224.Type,
        ["Model"] = v230,
        ["Diameter"] = v_u_8(v224.Name),
        ["PrimaryPart"] = v235,
        ["HeightOffset"] = Vector3.new(0, 0, 0),
        ["Position"] = Vector3.new(0, 0, 0),
        ["CurrentNode"] = v237,
        ["Alpha"] = p219.Alpha,
        ["CanRotate"] = true,
        ["BattlepassEnemy"] = v223,
        ["HasAttacks"] = false,
        ["RenderData"] = nil,
        ["SummonType"] = p219.SummonType,
        ["SpawnedBy"] = p219.SpawnedBy,
        ["PreviousType"] = v224.PreviousType
    }
    if v230:HasTag("EnemyCollision") then
        v_u_16:SetCollisionGroup(v230, "Entities", true)
    end
    v_u_169(v238, p219)
    v230.Parent = workspace.Entities
    v_u_152[v221] = v238
    local v239 = table.find({ "CidRaidTower" }, v238.Name) ~= nil
    v_u_30.UpdateEnemyModel(v238, v239, v229)
    v_u_30.UpdateEnemyStats(v238)
    v_u_9:PlayEffect("EnemySpawn", {
        ["Position"] = v238.Position,
        ["Scale"] = v230:GetScale()
    })
    v238.Position = v230:GetPivot().Position
    v_u_30.EnemySpawned:Fire(v238)
    local v240 = v238.Data.DisplayName
    local v241 = v240 or v238.Name
    local v242 = v_u_33[v240 and v_u_27.UnitSpecializations[v240] and "Horsegirl" or v241]
    if v242 then
        v242(v238, v230)
    end
end
v_u_30.ReadHealthBuffer = v_u_18.ReadHealthBuffer
function v_u_30.UpdateEnemyHealth(p243)
    local v244 = p243.EnemyId
    local v245 = v_u_30._ActiveEnemies[v244]
    if v245 and not v_u_30.AlreadyDeadEnemies[v244] then
        local v246 = v245.Data
        if p243.Health then
            if p243.Health > v246.Health then
                v_u_9:PlayEffect("EnemyHealthGain", {
                    ["EnemyGUID"] = v244,
                    ["Amount"] = p243.Health - v246.Health
                })
            end
            v_u_153(v245, v245.Model, p243.Health, p243.MaxHealth, v246.Type, "Main")
            v246.Health = p243.Health
            v246.MaxHealth = p243.MaxHealth
            v_u_30.EnemyHealthChanged:Fire(v245)
        end
        if p243.SecondaryHealth then
            v_u_153(v245, v245.Model, p243.SecondaryHealth, p243.SecondaryMaxHealth, v246.Type, "Secondary")
            if p243.SecondaryHealth == 0 then
                v_u_153(v245, v245.Model, v246.Health, v246.MaxHealth, v246.Type, "Main")
            else
                v246.SecondaryHealth = p243.SecondaryHealth
                v246.SecondaryMaxHealth = p243.SecondaryMaxHealth
            end
        end
        if p243.Shields then
            v_u_23:UpdateEnemy(v245.Model, p243.Shields)
            v246.Shields = p243.Shields
        end
    end
end
v_u_28.ClientListeners.Enemies.UpdateEnemyPredictedKiller.OnClientEvent:Connect(function(p247)
    local v248 = buffer.readu16(p247, 0)
    local v249 = buffer.readu8(p247, 2) == 1
    local v250 = v_u_30._ActiveEnemies[v248]
    if v250 then
        v250.Data.PredictedKiller = v249 or nil
    end
end)
function v_u_30.GetActiveEnemies(_)
    return v_u_30._ActiveEnemies
end
function v_u_30.GetEnemyData(_, p251)
    return v_u_30._ActiveEnemies[p251]
end
local v_u_252 = {
    ["Shinobi Puppet"] = "DismantlePuppet",
    ["Hirko"] = "HirkoDisappear"
}
function v_u_30.RemoveEnemy(p_u_253, p254)
    v_u_30.AlreadyDeadEnemies[p_u_253] = true
    task.delay(0.1, function()
        v_u_30.AlreadyDeadEnemies[p_u_253] = nil
    end)
    if v_u_152[p_u_253] then
        local v255 = v_u_152[p_u_253]
        local v256 = v255.Model
        local v257 = v_u_7:RetrieveEnemyDataByName(v255.Name)
        if v257.Name == "Berserker" then
            v256:Destroy()
            v_u_152[p_u_253] = nil
            return
        end
        v_u_30.EnemyDespawned:Fire(v255)
        if p254 or v257.Name == "Berserker" then
            v_u_152[p_u_253] = nil
        else
            task.delay(0.15, function()
                v_u_30.AlreadyDeadEnemies[p_u_253] = nil
                v_u_152[p_u_253] = nil
            end)
        end
        local v258 = v257.Name
        local v259
        if v257 then
            v259 = v257.Type or nil
        else
            v259 = nil
        end
        local v260 = v257.DespawnDelay or (v259 == "Boss" and 2.5 or nil)
        v_u_10:RemoveEntity(v256)
        local v261 = v256:GetPivot().Position
        v_u_23:RemoveEnemy(v256)
        local v262 = v_u_252[v258]
        if v262 then
            v_u_9:PlayEffect(v262, {
                ["Model"] = v256
            })
        end
        v_u_11:Play({ "General", "Enemies" }, "DeathSound", {
            ["Destroy"] = true,
            ["Position"] = v261
        })
        v_u_9:PlayEffect(5, {
            ["Model"] = v256,
            ["Position"] = v261
        })
        if v260 then
            v_u_3:AddItem(v256, v260)
        else
            v256.Parent = nil
            v_u_3:AddItem(v256, 0.5)
        end
        if v259 == "Boss" then
            v_u_25:RemoveBar(p_u_253)
        end
        if v255.EnemyGui then
            v255.EnemyGui:Destroy()
            v255.RenderData = nil
        end
    end
end
function v_u_30.RemoveAllEnemies()
    v_u_25:RemoveAllBars()
    for v263, v264 in v_u_152 do
        local v265 = v264.Model
        local v266 = v_u_7:RetrieveEnemyDataByName(v264.Name)
        local v267 = v266 and v266.Type or nil
        v_u_10:RemoveEntity(v265)
        v_u_23:RemoveEnemy(v265)
        if v267 == "Boss" then
            v_u_25:RemoveBar(v263)
        end
        v265:Destroy()
        v_u_30.EnemyDespawned:Fire(v264)
    end
    table.clear(v_u_152)
end
function v_u_30.GetEnemyGui(p268, p269)
    local v270 = tonumber(p268)
    local v271 = v_u_152[v270]
    if v271 then
        v271 = v271.EnemyGui
    end
    if p269 then
        local v272 = 0
        while not v271 do
            v271 = v_u_152[v270]
            if v271 then
                v271 = v271.EnemyGui
            end
            v272 = v272 + task.wait()
            if p269 <= v272 then
                break
            end
        end
    end
    return v271
end
task.spawn(v_u_30.Init)
return v_u_30


Units
local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("StarterPlayer")
local v3 = game:GetService("Players")
local v_u_4 = game:GetService("RunService")
local v_u_5 = require(v1.Modules.Data.Entities.EntityIDHandler)
local v_u_6 = require(v1.Modules.Utilities.EffectUtils)
local v_u_7 = require(v1.Modules.Shared.SoundHandler)
local v_u_8 = v1.Modules.Shared.SoundHandler.SoundData.Units
local v_u_9 = require(v_u_2.Modules.Gameplay.ClientEnemyHandler)
local v_u_10 = require(v_u_2.Modules.Gameplay.Units.ClientUnitHandler)
local v_u_11 = require(v_u_2.Modules.Gameplay.SettingsHandler)
local v_u_12 = require(v1.Modules.Shared.UnitAnimator)
local v_u_13 = v1.Networking
local v_u_14 = v3.LocalPlayer
local v_u_15 = {}
for _, v16 in v_u_2.Modules.Visuals.Units:GetDescendants() do
    if v16:IsA("ModuleScript") and not v_u_15[v16.Name] then
        v_u_15[v16.Name] = require(v16)
    end
end
local v_u_17 = workspace.Visuals
local v18 = {}
local v_u_19 = {}
local v_u_20 = {}
local v_u_21 = require(v_u_2.Modules.Visuals.Units.DEFAULT_ATTACKS)
local v_u_22 = 0
local v_u_23 = {}
local function v_u_55(p24, p25)
    if workspace:GetAttribute("GAME_FROZEN") then
        return
    else
        local v_u_26 = p24[1]
        local v_u_27 = p24[2]
        local v_u_28 = p24[3]
        local v29 = p24[4]
        local v30 = p24[5]
        local _ = p24[6]
        local v_u_31 = p25 and p25 == "NoEnemy" and true or false
        local v_u_32 = v_u_15[tostring(v_u_26)] or v_u_21
        local v33 = v_u_10._ActiveUnits
        local v34 = v_u_9:GetActiveEnemies()
        local v_u_35 = v33[v_u_27]
        if v_u_35 then
            if v_u_11:GetSetting("PlacedUnitsVisibility") == "User" and v_u_35.Player ~= v_u_14 then
                return
            elseif v_u_11:GetSetting("DisableVisualEffects") then
                return
            else
                local v_u_36 = v_u_35.Model
                if v_u_36:GetAttribute("NoAttackVfx") then
                    return
                else
                    local v37 = v34[v29]
                    local v_u_38
                    if v37 then
                        v_u_38 = v37.UniqueIdentifier
                    else
                        v_u_38 = v37
                    end
                    local v_u_39 = v37 and v37.Model or nil
                    local v_u_40 = v_u_5:IsUnitEvolved(v_u_35.Data.Name)
                    local v_u_41 = v_u_35.UniqueIdentifier
                    if v_u_36 then
                        if v_u_39 or v_u_31 then
                            local v_u_42 = v_u_31 and v30 == nil and Vector3.new(0, 0, 0) or v30
                            local v43 = {
                                ["Position"] = v_u_42,
                                ["CFrame"] = CFrame.new(v_u_42)
                            }
                            local v_u_44 = v_u_31 and {
                                ["HumanoidRootPart"] = v43,
                                ["PrimaryPart"] = v43,
                                ["Head"] = {
                                    ["Position"] = v_u_42 + Vector3.new(0, 1, 0),
                                    ["CFrame"] = CFrame.new(v_u_42 + Vector3.new(0, 1, 0))
                                }
                            } or v_u_31
                            if v_u_32 and v_u_32.Attacks[v_u_28] then
                                local v45 = v_u_35.UniqueIdentifier
                                local v_u_46 = v_u_10:PauseUnitRotation(v45)
                                if not v_u_23[v45] then
                                    v_u_23[v45] = {}
                                end
                                local v_u_47 = v_u_32.Attacks[v_u_28]
                                local v_u_48 = v_u_22 + 1
                                v_u_22 = v_u_48
                                v_u_23[v45][v_u_48] = v_u_46
                                if not v_u_31 then
                                    v_u_10:LookAt(v_u_27, v_u_42)
                                end
                                if not v_u_19[v_u_41] then
                                    v_u_19[v_u_41] = {}
                                end
                                if v_u_19[v_u_41][v_u_48] then
                                    return warn((("Already issued attack %* for %* - this is likely a bug"):format(v_u_48, v_u_41)))
                                end
                                v_u_35.IsAttacking = true
                                v_u_19[v_u_41][v_u_48] = task.spawn(function()
                                    local v49 = v_u_38
                                    v_u_35.TargetEnemy = tostring(v49)
                                    local v50 = {
                                        ["UnitObject"] = v_u_35,
                                        ["UnitName"] = v_u_27,
                                        ["UnitModel"] = v_u_36,
                                        ["EnemyModel"] = v_u_39 or v_u_44,
                                        ["EnemyIdentifier"] = v_u_38,
                                        ["AttackType"] = v_u_28,
                                        ["EnemyPosition"] = v_u_42,
                                        ["IsEvolved"] = v_u_40
                                    }
                                    v_u_20[v_u_41] = v50
                                    if v_u_32.AutoSfx then
                                        local v51 = ({
                                            ["First Giant"] = "Giant Queen",
                                            ["Hollowseph (Pure)"] = "Hollowseph"
                                        })[v_u_26] or v_u_26
                                        local v52 = v_u_8:FindFirstChild(v51, true)
                                        if v52 then
                                            local v53 = v_u_28
                                            local v54 = v_u_7:Play({ "Units", v52.Parent.Name, v51 }, tonumber(v53) and ("Skill%*"):format(v_u_28) or v_u_28, {
                                                ["Parent"] = v_u_36.PrimaryPart,
                                                ["Destroy"] = true
                                            })
                                            if v54 then
                                                v50.AttackSound = v54
                                            end
                                        else
                                            warn("AutoSfx failed, sound module not found")
                                        end
                                    end
                                    os.clock()
                                    v_u_47(v50)
                                    v_u_19[v_u_41][v_u_48] = nil
                                    v_u_20[v_u_41] = nil
                                    v_u_35.IsAttacking = false
                                    v_u_35.TargetEnemy = nil
                                    v_u_6.OnCancelCallbacks[v_u_41] = nil
                                    v_u_46()
                                    v_u_23[v_u_48] = nil
                                    if not v_u_31 then
                                        v_u_10:UpdateIndicatorCFrame(v_u_35, v_u_35.CFrameValue.Value + Vector3.new(0, -1, 0), CFrame.new(v_u_42) * v_u_35.CFrameValue.Value.Rotation)
                                    end
                                end)
                            end
                        else
                            v_u_4:IsStudio()
                        end
                    else
                        return warn((("Couldn\'t retrieve entity model for %*"):format(v_u_27)))
                    end
                end
            end
        else
            return
        end
    end
end
local function v_u_61(p56)
    local v57 = v_u_6:GetThreads(p56)
    if v57 then
        for _, v58 in v57 do
            if coroutine.status(v58) == "suspended" then
                task.cancel(v58)
            end
        end
        v_u_6:ClearThreads(p56)
    end
    v_u_6:ClearUnitVFX(p56)
    local v59 = v_u_19[p56.UniqueIdentifier]
    if v59 then
        for _, v60 in v59 do
            if coroutine.status(v60) == "suspended" then
                task.cancel(v60)
            end
        end
        v_u_19[p56.UniqueIdentifier] = nil
        v_u_20[p56.UniqueIdentifier] = nil
    end
end
local function v_u_74(p62)
    local v63 = p62[2]
    local v64 = p62[3]
    local v65 = v_u_10._ActiveUnits[v63]
    if v65 then
        local v66 = v_u_20[v63]
        if v66 and v66.AttackSound then
            v66.AttackSound:Destroy()
            v66.AttackSound = nil
        end
        v_u_61(v65)
        for _, v67 in v_u_23[v63] or {} do
            v67()
        end
        v_u_23[v63] = nil
        local v68 = v65.Model
        if v64 then
            v64 = v64.StopAnimations == false
        end
        if not v64 then
            v_u_12:StopAnimations(v68, { "Idle", "Stun" })
        end
        for _, v69 in v_u_17:GetChildren() do
            if v69.Name == v63 then
                v69:Destroy()
            end
        end
        for _, v70 in v68:GetDescendants() do
            if not v70:GetAttribute("SafeFromAttackCancel") and (v70:IsA("Sound") and v70.IsPlaying) then
                v70:Destroy()
            end
        end
        local v71 = v_u_15
        local v72 = v65.Name
        local v73 = v71[tostring(v72)]
        if v73 and v73.Cancel then
            v73:Cancel({
                ["UnitModel"] = v68
            })
        end
    end
end
local function v_u_77(p75)
    for _, v76 in v_u_2.Modules.Visuals.Units:GetDescendants() do
        if v76:IsA("ModuleScript") and (v76.Name ~= "Template" and v76.Name == p75) then
            return v76:GetChildren()
        end
    end
    return nil
end
function v18.GetAttackAssets(p78)
    return v_u_77(p78) or nil
end
task.spawn(function()
    v_u_13.AttackEvent.OnClientEvent:Connect(function(p79, p80)
        if p79 == "Attack" then
            v_u_55(p80)
            return
        elseif p79 == "AttackNoEnemy" then
            v_u_55(p80, "NoEnemy")
            return
        elseif p79 == "Cancel" then
            v_u_74(p80)
        elseif p79 == "Redirect" then
            local v81 = p80[1]
            local v82 = p80[2]
            local v83 = p80[3]
            local v84 = v_u_20[v81]
            if not v84 then
                return
            end
            local v85 = v_u_9:GetActiveEnemies()[v82]
            local v86
            if v85 then
                v86 = v85.UniqueIdentifier
            else
                v86 = v85
            end
            v84.EnemyModel = v85 and v85.Model or nil
            v84.EnemyIdentifier = v86
            v84.EnemyPosition = v83
        end
    end)
    v_u_10.UnitRemoved:Connect(function(p87)
        v_u_61(p87)
    end)
end)
return v18
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = require(v1.Modules.ClientReplicationHandler)
local v4 = require(v1.Modules.Packages.FastSignal)
local v_u_5 = require(v2.Modules.Gameplay.Units.ClientUnitHandler)
local v_u_6 = {
    ["UnitPropertyChanged"] = v4.new(),
    ["UnitPropertyRemoved"] = v4.new()
}
task.spawn(function()
    v_u_3.OnReplicate("UnitProperty"):Connect(function(p7, p8)
        local v9 = p7[1]
        local v10 = p7[2]
        local v11 = p7[3]
        if p8 == "Remove" then
            local v12 = v_u_5._ActiveUnits[v9]
            assert(v12, "No unit object?")
            v12[v10] = nil
            v_u_6.UnitPropertyRemoved:Fire(v9, v10)
            return
        else
            warn((("Update Key %* Value %*"):format(v10, v11)))
            local v13 = v_u_5._ActiveUnits[v9]
            assert(v13, "No unit object?")
            if not v13[v10] or v13[v10] ~= v11 then
                v13[v10] = v11
                v_u_6.UnitPropertyChanged:Fire(v9, v10, v11)
            end
        end
    end)
end)
return v_u_6
local v_u_1 = workspace.CurrentCamera
local v2 = game:GetService("Players")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("UserInputService")
local v_u_6 = game:GetService("Debris")
local v_u_7 = game:GetService("ReplicatedStorage")
local v8 = game:GetService("StarterPlayer")
local v_u_9 = TweenInfo.new(0.275, Enum.EasingStyle.Linear)
local v_u_10 = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
local v_u_11 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_12 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_13 = TweenInfo.new(0.535, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
local v_u_14 = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local v_u_15 = require(v_u_7.Modules.Data.SkinsData)
local v_u_16 = require(v_u_7.Modules.Utilities.GetBoundingBox)
local v_u_17 = require(v_u_7.Modules.Shared.EffectsHandler)
local v_u_18 = require(v_u_7.Modules.Data.GlobalMatchSettings)
local v_u_19 = require(v_u_7.Modules.Gameplay.GameHandler)
local v_u_20 = require(v_u_7.Modules.Shared.MultiplierHandler)
local v_u_21 = require(v_u_7.Modules.Shared.UnitAnimator)
local v_u_22 = require(v_u_7.Modules.Shared.CollisionHandler)
local v_u_23 = require(v_u_7.Modules.Gameplay.IndicatorHandler)
local v_u_24 = require(v_u_7.Modules.Gameplay.PriorityHandler)
local v_u_25 = require(v_u_7.Modules.UnitCollisionHandler)
local v_u_26 = require(v_u_7.Modules.Gameplay.HitboxHandler)
local v_u_27 = require(v8.Modules.Gameplay.ClientEnemyHandler)
local v28 = require(script.Callbacks)
local v_u_29 = require(v8.Modules.Gameplay.ClientAbilityHandler)
local v_u_30 = require(v_u_7.Modules.Gameplay.ClientGameStateHandler)
local v_u_31 = require(v8.Modules.Gameplay.PassiveInfoHandler)
local v_u_32 = require(v8.Modules.Gameplay.Units.UnitHideHandler)
local v_u_33 = require(v_u_7.Modules.Visuals.TraitEffects)
local v_u_34 = require(v8.Modules.Visuals.UnitBoundaryVisualizer)
local v_u_35 = require(v8.Modules.Gameplay.Units.UnitRangeDisplayHandler)
local v_u_36 = require(v_u_7.Modules.Packages.Spring)
local v_u_37 = require(v8.Modules.Gameplay.SettingsHandler)
local v_u_38 = require(v8.Modules.Gameplay.Familiars.FamiliarsFollowHandler)
local v_u_39 = require(v8.Modules.Gameplay.Units.UnitPlacementHandler.QuickPlacementHandler)
local v_u_40 = require(v8.Modules.Interface.Loader.ConsoleTooltipHandler)
local v_u_41 = require(v_u_7.Modules.Shared.DebugToggleHandler).CreateDebugPrint("clientUnitHandler")
local v_u_42 = require(script.Events)
require(script.Types)
local v43 = v_u_7.Networking
local v_u_44 = v43.UnitEvent
local v_u_45 = v43.ClientListeners.Units.AutoAbilityEvent
local v_u_46 = v43.Units.RemoveUnitSellValue
local v_u_47 = v43.Units.OverrideUnitPrice
local v48 = workspace:WaitForChild("Map")
local v_u_49 = workspace.UnitVisuals.UnitCircles
local v_u_50 = RaycastParams.new()
v_u_50.FilterType = Enum.RaycastFilterType.Include
v_u_50.FilterDescendantsInstances = { v48 }
local v_u_51 = RaycastParams.new()
v_u_51.FilterType = Enum.RaycastFilterType.Include
v_u_51.FilterDescendantsInstances = { workspace.Units, workspace.UnitHitboxes }
local v_u_52 = v2.LocalPlayer
local v_u_53 = v_u_52:WaitForChild("PlayerGui")
local v_u_54 = {
    "First",
    "Closest",
    "Last",
    "Strongest",
    "Weakest",
    "Bosses"
}
local v_u_55 = {
    ["Rogita (Super 4) (Clone)"] = true,
    ["Valentine (AU)"] = true,
    ["Vigil (Doppelganger)"] = true
}
local v_u_56 = {
    ["_ActiveUnits"] = {},
    ["_ActiveHitboxes"] = {},
    ["StunnedUnits"] = {},
    ["GlobalUpgradeCost"] = nil,
    ["CurrentlySelectedUnit"] = nil,
    ["LastClickedUnit"] = nil,
    ["IsPlacingUnit"] = false,
    ["LastClickTime"] = 0,
    ["OnUnitPlaced"] = v_u_42.OnUnitPlaced,
    ["OnUnitSelected"] = v_u_42.OnUnitSelected,
    ["OnUnitDeselected"] = v_u_42.OnUnitDeselected,
    ["ClickedOnUnit"] = v_u_42.ClickedOnUnit,
    ["OnUnitUpgraded"] = v_u_42.OnUnitUpgraded,
    ["OnUnitPriorityChanged"] = v_u_42.OnUnitPriorityChanged,
    ["OnUnitStatChanged"] = v_u_42.OnUnitStatChanged,
    ["OnUnitSellValueRemoved"] = v_u_42.OnUnitSellValueRemoved,
    ["UnitRemoved"] = v_u_42.UnitRemoved,
    ["CanSelectUnits"] = true
}
local v_u_57 = {
    ["Highlights"] = {},
    ["RangeModels"] = {},
    ["Interfaces"] = {},
    ["TargetIndicators"] = {},
    ["Connections"] = {}
}
function v_u_56.GetUnitCircleColor(p58)
    local v59 = p58.Player
    local v60 = p58.UnitType
    local v61 = v59.Name == v_u_52.Name
    local v62 = p58.Data.CurrentUpgrade >= #p58.Data.Upgrades
    local v63
    if v61 and (v60 and v60 == "Farm") then
        v63 = ColorSequence.new(Color3.fromRGB(255, 195, 55))
    elseif v61 and v62 then
        v63 = ColorSequence.new(Color3.fromRGB(164, 89, 255))
    elseif v61 then
        v63 = ColorSequence.new(Color3.fromRGB(56, 255, 106))
    else
        v63 = ColorSequence.new(Color3.fromRGB(47, 172, 255))
    end
    if v61 and (v60 and v60 == "Farm") then
        return v63, Color3.fromRGB(355, 537, 147)
    elseif v61 and v62 then
        return v63, Color3.fromRGB(392.5, 230, 637.5)
    elseif v61 then
        return v63, Color3.fromRGB(435, 700, 150)
    else
        return v63, Color3.fromRGB(182, 465, 892)
    end
end
local function v_u_69(p64)
    local v65 = v_u_49:FindFirstChild(p64.UniqueIdentifier)
    local v66
    if v65 then
        v66 = v65:FindFirstChild("Image")
    else
        v66 = v65
    end
    local v67, v68 = v_u_56.GetUnitCircleColor(p64)
    if v65 and (v66 and v66.Color3 ~= Color3.fromRGB(255, 255, 255)) then
        v65.Attachment.Gradient.Color = v67
        if v66 then
            v66.Color3 = v68
        end
    end
end
local v_u_70 = {
    ["Conqueror vs Invulnerable"] = true,
    ["Rideon vs Samuel"] = true,
    ["Rideon vs Samuel (Duel)"] = true
}
local function v_u_76(p71, p72)
    local v_u_73 = v_u_56._ActiveUnits[p71]
    if v_u_73 then
        v_u_17:PlayEffect(1, {
            ["UnitModel"] = v_u_73.Model
        })
        v_u_17:PlayEffect(3, {
            ["Upgrade"] = p72.Data.CurrentUpgrade - 1,
            ["UnitModel"] = v_u_73.Model
        })
        v_u_73.Damage = p72.Damage
        v_u_73.SPA = p72.SPA
        v_u_73.Range = p72.Range
        if p72.ActiveAbilities then
            v_u_73.ActiveAbilities = p72.ActiveAbilities
            for _, v74 in v_u_73.ActiveAbilities do
                v_u_29.AddUnitAbility(v_u_73.UniqueIdentifier, v74)
            end
        end
        if p72.Income then
            v_u_73.Income = p72.Income
        end
        if p72.CriticalChance then
            v_u_73.CriticalChance = p72.CriticalChance
        end
        v_u_73.Data = p72.Data
        if v_u_56.CurrentlySelectedUnit == v_u_73.UniqueIdentifier and v_u_73.Player == v_u_52 then
            v_u_35:ShowNextUpgradeRange(v_u_73, {
                ["RangeProfile"] = "White"
            })
        end
        local v_u_75 = script.UpgradeCallbacks:FindFirstChild(v_u_73.Name)
        if v_u_75 then
            task.spawn(function()
                require(v_u_75)(v_u_73.Model, v_u_73.Level, v_u_73.Data.CurrentAttack, v_u_73.Data)
            end)
        end
        if not v_u_70[v_u_73.Name] then
            v_u_21:StopAnimations(v_u_73.Model)
            v_u_21:PlayIdleAnimation(v_u_73.Model, v_u_73.Data)
        end
        v_u_56.OnUnitUpgraded:Fire(v_u_73)
        v_u_69(v_u_73)
    end
end
function v_u_56.UpdateRangeModels(_, p77, p78)
    for _, v79 in v_u_57.RangeModels do
        if v79.Name == "RangePart" then
            if p78 then
                v_u_36.target(v79, 0.75, 2.5, {
                    ["Size"] = Vector3.new(p77, 0.3, p77)
                })
            else
                v_u_36.target(v79, 0.385, 3, {
                    ["Size"] = Vector3.new(p77, 0.3, p77)
                })
            end
        end
    end
end
local v_u_80 = {}
local v_u_81 = {}
local v_u_82 = {}
function v_u_56.PauseUnitRotation(_, p83)
    local v_u_84 = v_u_56._ActiveUnits[p83]
    v_u_84.RotationPauseCount = (v_u_84.RotationPauseCount or 0) + 1
    local v85 = v_u_84.RotateTween
    if v85 then
        v85:Cancel()
        v85:Destroy()
        v_u_84.RotateTween = nil
    end
    local v86 = v_u_84.Model
    if v86 then
        v86 = v_u_84.Model.PrimaryPart
    end
    if v86 then
        v86 = table.find(v_u_80, v86)
    end
    if v86 then
        table.remove(v_u_80, v86)
        table.remove(v_u_81, v86)
    end
    local v_u_87 = false
    return function()
        if not v_u_87 then
            v_u_87 = true
            local v88 = v_u_84
            v88.RotationPauseCount = v88.RotationPauseCount - 1
        end
    end
end
local v_u_89 = CFrame.identity
local function v_u_96(p90)
    local v91 = v_u_19:GetGameData()
    if not v91 or v91.Stage ~= "VanguardsVsSkeletons" then
        return nil
    end
    local v92 = require(v_u_7.Modules.Shared.EnemyPathHandler)
    local v93 = p90.Position.X
    local v94 = v92.NumIndexGroups
    for v95 = 1, math.min(4, v94) do
        if v92.Nodes[("%*-0"):format(v95)].Position.X - v93 < 1 then
            return v95
        end
    end
    error("Failed to retrieve UnitLane")
end
local function v_u_106(p97, p98)
    local v99 = p97.Lane or v_u_96(p97)
    local v100 = (1 / 0)
    local v101 = nil
    for _, v102 in p98 do
        if v102.CurrentNode.IndexGroup == v99 then
            local v103 = v102.CurrentNode
            local v104 = v102.Alpha
            local v105 = v103.DistanceToEnd - (v103.DistanceToNextNode or 0) * v104
            if v105 < v100 then
                v101 = v102
                v100 = v105
            end
        end
    end
    return v101
end
local function v_u_122(p107)
    if v_u_57.TargetIndicators[1] then
        print("removing target indicator 1")
        v_u_23:RemoveIndicator(v_u_57.TargetIndicators[1])
        table.clear(v_u_57.TargetIndicators)
    end
    local v108 = p107.Model
    local v109 = p107.Data.Upgrades[p107.Data.CurrentUpgrade]
    local v110 = v_u_20:GetMultipliedStatistic(p107, "Range", v109)
    local v111 = p107.Position.Y
    local v112 = v_u_23
    local v113 = {
        ["UnitModel"] = v108,
        ["UnitData"] = {
            ["Range"] = v110,
            ["AOEType"] = p107.AOEType or v109.AOEType,
            ["AOESize"] = p107.AOESize or v109.AOESize,
            ["CircleRadius"] = p107.CircleRadius or v109.CircleRadius,
            ["AOEOffset"] = p107.AOEOffset or v109.AOEOffset,
            ["UnitType"] = p107.Data.UnitType
        }
    }
    local v114 = p107.Position.X
    local v115 = p107.Position.Z
    v113.Position = Vector3.new(v114, v111, v115)
    v113.CFrame = CFrame.new(p107.Position.X, v111, p107.Position.Z) * v108:GetPivot().Rotation
    local v116 = p107.LookAt and p107.LookAt.Rotation
    if not v116 then
        local v117 = CFrame.new(0, 0, 0)
        local v118 = CFrame.Angles
        local v119 = p107.Rotation
        v116 = v117 * v118(0, math.rad(v119), 0)
    end
    v113.LookAt = v116
    local v120 = v112:CreateTargetIndicator(v113)
    if v120 then
        local v121 = v_u_57.TargetIndicators
        table.insert(v121, v120)
    end
end
local v_u_123 = {}
function v_u_56.GetUnitPriceOverride(_, p124)
    return v_u_123[p124]
end
function v28.GetActiveUnits()
    return v_u_56._ActiveUnits
end
function v28.GetUnitPriceOverride(p125)
    return v_u_56:GetUnitPriceOverride(p125)
end
v_u_19.MatchRestarted:Connect(function()
    table.clear(v_u_123)
    v_u_42.UnitPriceOverrideChanged:Fire()
end)
function v_u_56.Init()
    local v126 = v_u_19:GetGameData()
    if v126.Stage and v126.Stage == "VanguardsVsSkeletons" then
        v_u_4.Heartbeat:Connect(function(p127)
            workspace:BulkMoveTo(v_u_80, v_u_81, Enum.BulkMoveMode.FireCFrameChanged)
            table.clear(v_u_80)
            table.clear(v_u_81)
            local v128 = {}
            local v129 = {}
            local v130 = 0
            local v131 = v_u_89
            local v132 = CFrame.Angles
            local v133 = 90 * p127
            v_u_89 = v131 * v132(0, math.rad(v133), 0)
            for v134, v135 in v_u_82 do
                v130 = v130 + 1
                v128[v130] = v134
                v129[v130] = v135 * v_u_89
            end
            workspace:BulkMoveTo(v128, v129, Enum.BulkMoveMode.FireCFrameChanged)
            for _, v136 in v_u_56._ActiveUnits do
                local v137 = v136.CFrameValue
                local v138 = v136.Position
                local _ = v_u_54[v136.Data.Priority]
                local v139 = v_u_56:GetEnemiesInRange(v136)
                if next(v139) ~= nil then
                    local v140 = v_u_106(v136, v139)
                    if v140 then
                        local v141 = v140.Position.X
                        local v142 = v138.Y
                        local v143 = v140.Position.Z
                        local v144 = Vector3.new(v141, v142, v143)
                        local v145 = CFrame.lookAt(v138, v144)
                        local v146 = v136.TargetEnemy
                        if not v146 or v146 == v140.UniqueIdentifier then
                            v_u_56:UpdateIndicatorCFrame(v136, v145 + Vector3.new(0, -1, 0), CFrame.new(v144) * v145.Rotation)
                        end
                        v136.TrackedEnemy = v140
                        if (v136.RotationPauseCount or 0) <= 0 and not v_u_56.StunnedUnits[v136.UniqueIdentifier] then
                            v136.LookAt = v145
                            v136.RotateTween = v_u_3:Create(v137, v_u_9, {
                                ["Value"] = v145
                            })
                            v136.RotateTween:Play()
                        end
                    else
                        v136.TrackedEnemy = nil
                    end
                end
            end
        end)
    else
        v_u_4.Heartbeat:Connect(function(p147)
            debug.profilebegin("Move units")
            workspace:BulkMoveTo(v_u_80, v_u_81, Enum.BulkMoveMode.FireCFrameChanged)
            table.clear(v_u_80)
            table.clear(v_u_81)
            debug.profileend()
            debug.profilebegin("Move unit circles")
            local v148 = {}
            local v149 = {}
            local v150 = 0
            local v151 = v_u_89
            local v152 = CFrame.Angles
            local v153 = 90 * p147
            v_u_89 = v151 * v152(0, math.rad(v153), 0)
            for v154, v155 in v_u_82 do
                v150 = v150 + 1
                v148[v150] = v154
                v149[v150] = v155 * v_u_89
            end
            workspace:BulkMoveTo(v148, v149, Enum.BulkMoveMode.FireCFrameChanged)
            debug.profileend()
            for _, v156 in v_u_56._ActiveUnits do
                local v157 = v156.CFrameValue
                local v158 = v156.Position
                if v156.Data.UnitType ~= "Farm" then
                    local v159 = v_u_54[v156.Data.Priority]
                    local v160
                    if v159 == "First" or v159 == "Last" then
                        v160 = v_u_56:GetFirstEnemy(v156)
                        ::l10::
                        if v160 then
                            local v161 = v160.Position.X
                            local v162 = v158.Y
                            local v163 = v160.Position.Z
                            local v164 = Vector3.new(v161, v162, v163)
                            local v165 = CFrame.lookAt(v158, v164)
                            local v166 = v156.TargetEnemy
                            if not v166 or v166 == v160.UniqueIdentifier then
                                v_u_56:UpdateIndicatorCFrame(v156, v165 + Vector3.new(0, -1, 0), CFrame.new(v164) * v165.Rotation)
                            end
                            v156.TrackedEnemy = v160
                            if (v156.RotationPauseCount or 0) <= 0 and not v_u_56.StunnedUnits[v156.UniqueIdentifier] then
                                v156.LookAt = v165
                                v156.RotateTween = v_u_3:Create(v157, v_u_9, {
                                    ["Value"] = v165
                                })
                                v156.RotateTween:Play()
                            end
                        else
                            v156.TrackedEnemy = nil
                        end
                    else
                        local v167 = v_u_56:GetEnemiesInRange(v156)
                        if next(v167) ~= nil then
                            v160 = v_u_24:GetEnemyFromPriority(v167, v159, v158, v156.Name)
                            goto l10
                        end
                    end
                end
            end
        end)
    end
    v_u_44.OnClientEvent:Connect(function(p168, p169, p170, p171)
        v_u_41((("Received event: %*"):format(p168)))
        if p168 == "Render" then
            v_u_56:RenderUnit(p169)
            return
        elseif p168 == "Remove" then
            v_u_56:RemoveUnit(p169)
            return
        elseif p168 == "Upgrade" then
            v_u_76(p169, p170)
            return
        elseif p168 == "ChangePriority" then
            local v172 = v_u_56._ActiveUnits
            local v173 = v172[p169]
            if v173 then
                v172[p169].Data = p170.Data
            end
            v_u_56.OnUnitPriorityChanged:Fire(v173)
        elseif p168 == "UpdateAOEType" then
            local v174 = v_u_56._ActiveUnits[p169]
            v174.AOEType = p170
            if v_u_56.CurrentlySelectedUnit == v174.UniqueIdentifier then
                v_u_122(v174)
                return
            end
        elseif p168 == "ChangePosition" then
            local v175 = p169.UnitGUID
            local v176 = v_u_56._ActiveUnits[v175]
            local v177 = v_u_41
            local v178 = "ChangePosition for %*"
            local v179
            if v176 then
                v179 = v176.Name or v175
            else
                v179 = v175
            end
            v177((v178:format(v179)))
            if v176 and v_u_56.CurrentlySelectedUnit == v175 then
                v_u_122(v176)
                return
            end
        elseif p168 == "ChangeData" then
            local v180 = v_u_56._ActiveUnits[p169]
            local v181 = v_u_41
            local v182 = "ChangeData for %*: %* = %*"
            if v180 then
                p169 = v180.Name or p169
            end
            v181((v182:format(p169, p170, p171)))
            if v180 then
                v180.Data[p170] = p171
                if p170 == "Position" and v_u_56.CurrentlySelectedUnit == v180.UniqueIdentifier then
                    v_u_122(v180)
                    return
                end
            end
        else
            if p168 == "UpdateInterface" then
                local v183 = v_u_56._ActiveUnits[p169]
                v_u_56.OnUnitStatChanged:Fire(v183)
                return
            end
            if p168 == "SetGlobalUpgradeCost" then
                v_u_56.GlobalUpgradeCost = p169
            end
        end
    end)
    v_u_44:FireServer("RenderAll")
    v_u_45.OnClientEvent:Connect(function(p184, p185, p186)
        local v187 = v_u_56._ActiveUnits[p184]
        assert(v187, "Unit not found")
        local v188 = v187.ActiveAbilities
        assert(v188, "Fix this, this table should always exist")
        if p186 then
            local v189 = v187.AutoUseAbilities
            table.insert(v189, p185)
        else
            local v190 = table.find(v187.AutoUseAbilities, p185)
            table.remove(v187.AutoUseAbilities, v190)
        end
    end)
    v_u_40.BackedEvent:Connect(function()
        if v_u_56.CurrentlySelectedUnit then
            v_u_56:DeselectUnit(v_u_56.CurrentlySelectedUnit)
        end
    end)
    v_u_32.UnitHidden:Connect(function(p191)
        local v192 = v_u_56._ActiveUnits[p191]
        if v192 then
            for _, v193 in v192.ActiveAbilities do
                v_u_29.RemoveUnitAbility(v192, v193)
            end
        end
    end)
    v_u_46.OnClientEvent:Connect(function(p194)
        local v195 = v_u_56._ActiveUnits[p194]
        if v195 then
            v195.NoSellValue = true
            v_u_56.OnUnitSellValueRemoved:Fire(v195)
        end
    end)
    v_u_47.OnClientEvent:Connect(function(p196, p197)
        v_u_123[p196] = p197 or nil
        v_u_42.UnitPriceOverrideChanged:Fire()
    end)
end
function v_u_56.GetUnitModelFromGUID(_, p198, p199)
    local v200 = v_u_56._ActiveUnits[p198]
    if v200 then
        return p199 and v200.Data.Model or v200.Model
    else
        return warn((("No unit found with GUID: %* in ActiveUnits!"):format(p198)))
    end
end
function v28.GetUnitModelFromGUID(...)
    return v_u_56:GetUnitModelFromGUID(...)
end
local function v_u_203(p201)
    local v202 = p201:IsA("Model") and p201 and p201 or p201:FindFirstAncestorOfClass("Model")
    if v202.Parent then
        if v202 and (v202.Parent and v202.Parent.Name == "Units") then
            return v202
        else
            return v_u_203(v202.Parent)
        end
    else
        return
    end
end
function v_u_56.SelectUnit(_, p204, p205, p206)
    local v207 = v_u_5:GetMouseLocation()
    if v_u_56.IsPlacingUnit then
        return
    else
        local v208 = v_u_1:ViewportPointToRay(v207.X, v207.Y)
        local v209 = workspace:Raycast(v208.Origin, v208.Direction * 250, v_u_51)
        local v210
        if v209 then
            v210 = v209.Instance
        else
            v210 = v209
        end
        if v210 and v210.Parent.Name == "UnitHitboxes" then
            v210 = v_u_56:GetUnitModelFromGUID(v210.Name)
        end
        if v209 or p204 then
            if not p204 then
                p204 = v210:IsA("Model") and v210 and v210 or v210:FindFirstAncestorOfClass("Model")
                if p204.Parent then
                    if not p204 or (not p204.Parent or p204.Parent.Name ~= "Units") then
                        p204 = v_u_203(p204.Parent)
                    end
                else
                    p204 = nil
                end
            end
            if p204 then
                local v211 = v_u_56._ActiveUnits[p204.Name]
                if v211 then
                    local v212 = v211.Model
                    if v211.Player.Name == v_u_52.Name or not p205 then
                        v_u_56.ClickedOnUnit:Fire(p204.Name, v211)
                        if v_u_56.CanSelectUnits then
                            local v213 = v211.Data.UnitType
                            local v214 = v_u_20:GetMultipliedStatistic(v211, "Range")
                            if v_u_56.CurrentlySelectedUnit and (p204 and p204.Name == v_u_56.CurrentlySelectedUnit) or p204.Name ~= v_u_56.CurrentlySelectedUnit then
                                v_u_56:DeselectUnit(v_u_56.CurrentlySelectedUnit)
                                v_u_56.CurrentlySelectedUnit = p204.Name
                            end
                            if not v_u_56.CurrentlySelectedUnit then
                                v_u_56.CurrentlySelectedUnit = p204.Name
                            end
                            v_u_56.OnUnitSelected:Fire(v_u_56.CurrentlySelectedUnit, v211)
                            local v215 = v_u_49:FindFirstChild(v_u_56.CurrentlySelectedUnit)
                            if v215 then
                                v215.Attachment.Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                                local v216 = v215:FindFirstChild("Image")
                                if v216 then
                                    v216.Color3 = Color3.fromRGB(500, 500, 500)
                                end
                            end
                            if #v_u_57.Highlights == 0 then
                                local v217 = Color3.fromRGB(201, 245, 255)
                                local v218 = Instance.new("Highlight")
                                v218.OutlineColor = v217
                                v218.FillColor = v217
                                v218.FillTransparency = 1
                                v218.OutlineTransparency = 0.15
                                v218.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                v218.Parent = v212
                                if v212:FindFirstChild("HoverFocus") then
                                    v218.Parent = v212.HoverFocus.Value or v212
                                end
                                v_u_3:Create(v218, v_u_13, {
                                    ["FillTransparency"] = 0.35
                                }):Play()
                                local v219 = v_u_57.Highlights
                                table.insert(v219, v218)
                            end
                            workspace:Raycast(v211.Position, v212.PrimaryPart.CFrame.UpVector * -10, v_u_50)
                            local v220 = v_u_7.Assets.Models.Misc.RangePart:Clone()
                            v220.Position = v215.Position + Vector3.new(0, 0.25, 0)
                            v220.Size = Vector3.new(0, 0, 0)
                            v220.Parent = workspace.UnitVisuals
                            v_u_36.target(v220, 0.385, 3, {
                                ["Size"] = Vector3.new(v214, 0.3, v214)
                            })
                            v_u_3:Create(v220, v_u_14, {
                                ["Orientation"] = v220.Orientation + Vector3.new(0, 360, 0)
                            }):Play()
                            local v221 = v_u_57.RangeModels
                            table.insert(v221, v220)
                            v_u_34:ShowBoundary(p204.Name)
                            if #v_u_57.TargetIndicators == 0 and v213 ~= "Farm" then
                                v_u_122(v211)
                            end
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            if p206 ~= "ScreenTouch" then
                v_u_56:DeselectUnit(v_u_56.CurrentlySelectedUnit)
            end
            return
        end
    end
end
function v_u_56.DeselectUnit(_, p222, p223)
    if p223 and v_u_57.Highlights[1] then
        v_u_57.Highlights[1]:Destroy()
        table.clear(v_u_57.Highlights)
    end
    if p222 then
        local v224 = v_u_56._ActiveUnits[p222]
        local v225 = v_u_49:FindFirstChild(v_u_56.CurrentlySelectedUnit or "nothing lol")
        if p222 and p222 == v_u_56.CurrentlySelectedUnit then
            v_u_56.CurrentlySelectedUnit = nil
        end
        if v225 then
            if v224 then
                local v226, v227 = v_u_56.GetUnitCircleColor(v224)
                v225.Attachment.Gradient.Color = v226
                local v228 = v225:FindFirstChild("Image")
                if v228 then
                    v228.Color3 = v227
                end
            end
            v_u_34:HideBoundary(p222)
        end
        if v_u_57.Highlights[1] then
            v_u_57.Highlights[1]:Destroy()
            table.clear(v_u_57.Highlights)
        end
        for _, v229 in v_u_57.Interfaces do
            v229:Destroy()
        end
        table.clear(v_u_57.Interfaces)
        if v_u_57.TargetIndicators[1] then
            v_u_23:RemoveIndicator(v_u_57.TargetIndicators[1])
            table.clear(v_u_57.TargetIndicators)
        end
        if #v_u_57.RangeModels > 0 then
            for _, v230 in v_u_57.RangeModels do
                v230:Destroy()
            end
            table.clear(v_u_57.RangeModels)
        end
        v_u_35:HideRange()
        v_u_56.OnUnitDeselected:Fire(v224)
    end
end
function v28.DeselectUnit(p231, p232)
    return v_u_56:DeselectUnit(p231, p232)
end
function v_u_56.RefreshSelectedUnitAOE(_)
    local v233 = v_u_56.CurrentlySelectedUnit
    if v233 then
        if v_u_56._ActiveUnits[v233] then
            v_u_34:HideBoundary(v233)
            v_u_34:ShowBoundary(v233)
        end
    else
        return
    end
end
local v_u_234 = nil
v_u_19.MatchEnded:Connect(function()
    if v_u_234 ~= nil then
        v_u_56:CancelSpectate()
    end
end)
local v_u_235 = {}
function v_u_56.KillPlacementThread(_, p236)
    if v_u_235[p236] then
        task.cancel(v_u_235[p236].Thread)
        v_u_235[p236].RemoveAttribute()
        v_u_235[p236] = nil
    end
end
function v_u_56.RemoveUnit(_, p237)
    local v238 = v_u_56._ActiveUnits
    local v239 = v238[p237]
    if v_u_56.CurrentlySelectedUnit == p237 then
        v_u_56:DeselectUnit(v_u_56.CurrentlySelectedUnit)
    end
    if v239 then
        local v240 = v239.Position
        v_u_56:KillPlacementThread(p237)
        for _, v241 in v239.ActiveAbilities do
            v_u_29.RemoveUnitAbility(v239, v241)
        end
        v_u_17:RemoveUnitFromCache(p237)
        if v239.ExtraModels then
            for _, v242 in v239.ExtraModels do
                v242:Destroy()
            end
        end
        if v239.Connections then
            for _, v243 in v239.Connections do
                v243:Disconnect()
            end
        end
        if v239.Hitbox then
            table.remove(v_u_56._ActiveHitboxes, table.find(v_u_56._ActiveHitboxes, v239.Hitbox))
            v239.Hitbox:Destroy()
        end
        if v239.Boundary then
            v_u_34:RemoveUnitBoundary(p237)
        end
        if v239.Model then
            v239.Model:Destroy()
        end
        if v239.CFrameValue then
            v239.CFrameValue:Destroy()
        end
        if v_u_234 == p237 then
            v_u_56:CancelSpectate()
        end
        v_u_17:PlayEffect("UnitRemoved", {
            ["Position"] = v240
        })
        v238[p237] = nil
        v_u_56.UnitRemoved:Fire(v239)
    end
end
local v_u_244 = {
    ["Lfelt"] = CFrame.new(0, 0.6, 0),
    ["The Smith (Forged)"] = CFrame.new(0, 0.2, 0),
    ["The Struggler (Rampage)"] = CFrame.new(0, 0.5, 0),
    ["Vogita Super"] = CFrame.new(0, 0.2, 0)
}
function v_u_56.RenderUnit(_, p245)
    local v_u_246 = v_u_56._ActiveUnits
    local v247 = v_u_56._ActiveHitboxes
    local v248 = p245.Player
    local v_u_249 = p245.UniqueIdentifier
    local v250 = p245.Name
    local v251 = p245.Position
    local v252 = p245.Rotation
    local v253 = p245.Shiny
    local v254 = p245.SkinName
    local v255 = p245.Data
    local v256 = v255.UnitType
    local v257 = v248.Name == v_u_52.Name
    local v258 = CFrame.new(v251) * CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(v252), 0)
    if v_u_244[v250] then
        v258 = v258 * v_u_244[v250]
    end
    if v_u_246[v_u_249] then
        return
    end
    local v259 = v_u_15.GetModel(p245)
    if not v259 then
        warn((("No unit model found for %*"):format(p245.Name)))
        v259 = v_u_7.Assets.Models.Units._TEMPLATE
    end
    v_u_16(v259)
    local v260 = (v255.Hitbox * Vector3.new(0, 1, 0) / 2).Y
    local v_u_261 = v259:Clone()
    local v_u_262 = v_u_261:GetScale()
    local v263 = v_u_261:Clone()
    v263:ScaleTo(v_u_262)
    local v264 = v263:GetExtentsSize().Y / 2 - v263.PrimaryPart.Size.Y / 2
    v263:Destroy()
    v_u_261.Name = v_u_249
    v_u_261:SetAttribute("BaseUnitCFrame", v258)
    v_u_261:PivotTo(v258)
    v_u_261.Parent = workspace.Units
    v_u_25:SetUnitCollisions(v_u_261)
    v_u_25:DisableHumanoidStates(v_u_261)
    v_u_22:SetCollisionGroup(v_u_261, "Units", true)
    local v265 = Instance.new("NumberValue")
    v265.Value = 0.01
    v_u_3:Create(v265, v_u_12, {
        ["Value"] = v_u_262
    }):Play()
    v_u_6:AddItem(v265, v_u_12.Time)
    local v_u_267 = v265.Changed:Connect(function(p266)
        v_u_261:ScaleTo(p266)
    end)
    v265.Destroying:Once(function()
        v_u_261:ScaleTo(v_u_262)
    end)
    v_u_261.Destroying:Once(function()
        v_u_267:Disconnect()
    end)
    if v254 then
        local v268 = string.split(v254, "_")
        local v269
        if v268 then
            v269 = v268[2] or v254
        else
            v269 = v254
        end
        v_u_261:SetAttribute("SkinName", v269)
    end
    v_u_21:PlayIdleAnimation(v_u_261, v255)
    v_u_17:PlayEffect(1, {
        ["UnitModel"] = v_u_261
    })
    if v256 == "Farm" or v256 == "Support" then
        local v_u_270 = v_u_7.Assets.Misc.Interfaces.Units[("%*Indicator"):format(v256)]:Clone()
        v_u_270.Adornee = v_u_261.PrimaryPart
        v_u_270.Parent = workspace.UnitVisuals
        v_u_261.PrimaryPart.Destroying:Once(function()
            v_u_270:Destroy()
        end)
    end
    local v_u_271 = v_u_7.Assets.Models.Misc.UnitCircle:Clone()
    local v272
    if v257 and (v256 and v256 == "Farm") then
        v272 = Color3.fromRGB(355, 537, 147)
    elseif v257 then
        v272 = Color3.fromRGB(435, 700, 150)
    else
        v272 = Color3.fromRGB(182, 465, 892)
    end
    local v273
    if v257 and (v256 and v256 == "Farm") then
        v273 = ColorSequence.new(Color3.fromRGB(255, 195, 55))
    elseif v257 then
        v273 = v_u_271.Attachment.Gradient.Color
    else
        v273 = ColorSequence.new(Color3.fromRGB(47, 172, 255))
    end
    v_u_271.Name = v_u_249
    local v274 = v_u_271:FindFirstChild("Image")
    if v274 then
        v274.Color3 = v272
    end
    local v275 = v258.Position.Y - (v264 + v_u_262 / 1.65)
    local v276 = RaycastParams.new()
    v276.FilterType = Enum.RaycastFilterType.Include
    v276.FilterDescendantsInstances = { workspace.Map }
    local v277 = workspace:Raycast(v258.Position + Vector3.new(0, 5, 0), Vector3.new(0, -50, 0), v276)
    if v277 then
        v275 = v277.Position.Y + 0.05
    end
    local v278 = v258.Position.X
    local v279 = v258.Position.Z
    local v280 = Vector3.new(v278, v275, v279)
    v_u_271.Attachment.Gradient.Color = v273
    v_u_271.Size = Vector3.new(0, 0, 0)
    v_u_271.Position = v280
    v_u_261:SetAttribute("BasePosition", v_u_271.Position)
    v_u_271.Parent = v_u_49
    v_u_3:Create(v_u_271, v_u_11, {
        ["Size"] = Vector3.new(2.85, 0.05, 2.85)
    }):Play()
    v_u_82[v_u_271] = CFrame.new(v_u_261:GetAttribute("BasePosition")) * v_u_271.CFrame.Rotation
    v_u_271.Destroying:Once(function()
        v_u_82[v_u_271] = nil
    end)
    v_u_261:GetAttributeChangedSignal("BasePosition"):Connect(function()
        local v281 = v_u_49:FindFirstChild(v_u_56.CurrentlySelectedUnit or "")
        if v_u_261.Name == v_u_56.CurrentlySelectedUnit and (workspace.UnitVisuals:FindFirstChild("RangePart") and v281) then
            workspace.UnitVisuals.RangePart.Position = v_u_261:GetAttribute("BasePosition")
            local v282 = workspace:FindFirstChild("Circle")
            if v282 then
                v282.Position = v_u_261:GetAttribute("BasePosition")
            end
        end
        v_u_82[v_u_271] = CFrame.new(v_u_261:GetAttribute("BasePosition")) * v_u_271.CFrame.Rotation
    end)
    local v_u_283 = Instance.new("CFrameValue")
    v_u_283.Value = v258
    v_u_261.Destroying:Once(function()
        v_u_283:Destroy()
    end)
    local v284 = Instance.new("Part")
    v284.Name = v_u_249
    v284.Anchored = true
    v284.CastShadow = false
    v284.CanCollide = false
    v284.CanTouch = false
    v284.Orientation = Vector3.new(0, 0, -90)
    v284.Position = v251
    v284.Size = v255.Hitbox
    v284.Transparency = 1
    v284.Shape = Enum.PartType.Cylinder
    v284.Parent = workspace.UnitHitboxes
    table.insert(v247, v284)
    for v285, v286 in {
        [Vector3.new(2.625, 4.8125, 2.625)] = { "Iscanur (Pride)" },
        [Vector3.new(3.75, 6.875, 3.75)] = {
            "Arin",
            "Arin (Rumbling)",
            "Zak",
            "Zak (Ape Giant)",
            "Riner",
            "Riner (Reinforced Giant)"
        }
    } do
        if table.find(v286, v250) then
            v284.Size = v285
        end
    end
    local v287 = v_u_7.Assets.Models.Misc.Boundary:Clone()
    local v288 = v255.Hitbox.X
    local v289 = v255.Hitbox.Z
    v287.Size = Vector3.new(v288, 0.05, v289)
    v287.CFrame = v258 * CFrame.new(0, -v260 + 0.1, 0)
    local v290 = p245.Trait
    if not table.find({
        "Iscanur (Pride)",
        "Arin",
        "Arin (Rumbling)",
        "Zak",
        "Zak (Ape Giant)",
        "Riner",
        "Riner (Reinforced Giant)"
    }, v250) then
        v_u_33:PlayTraitEffect(v290.Name, v_u_261)
    end
    local v291 = p245.Statistics
    local v292 = p245.ForceCannotSelectOnPlacement
    local v_u_293 = {
        ["UniqueIdentifier"] = v_u_249,
        ["Player"] = v248,
        ["Name"] = p245.Name,
        ["Model"] = v_u_261,
        ["ExtraModels"] = { v_u_271 },
        ["Position"] = p245.Position,
        ["Rotation"] = p245.Rotation,
        ["Data"] = v255,
        ["Hitbox"] = v284,
        ["Boundary"] = v287,
        ["Trait"] = p245.Trait,
        ["Ascensions"] = p245.Ascensions,
        ["Statistics"] = v291,
        ["Familiar"] = p245.Familiar,
        ["SkinName"] = v254,
        ["ActiveAbilities"] = {},
        ["AutoUseAbilities"] = {},
        ["Shiny"] = v253,
        ["SerialID"] = p245.SerialID,
        ["Level"] = p245.Level,
        ["Damage"] = p245.Damage,
        ["SPA"] = p245.SPA,
        ["Range"] = p245.Range,
        ["Income"] = p245.Income,
        ["Offset"] = CFrame.identity,
        ["CriticalChance"] = p245.CriticalChance,
        ["CFrameValue"] = v_u_283,
        ["Connections"] = {},
        ["BuffMultipliers"] = {},
        ["Multipliers"] = table.clone(v_u_20.UNIT_MULTIPLIERS),
        ["canRotate"] = true,
        ["Lane"] = v_u_96({
            ["Position"] = p245.Position
        })
    }
    if not v_u_246[v_u_249] then
        v_u_246[v_u_249] = v_u_293
    end
    local v294 = v255.ActiveAbility or v255.Upgrades[1].ActiveAbility
    local v295 = v294 and type(v294) ~= "table" and { v294 } or v294
    if v295 then
        for _, v296 in v295 do
            local v297 = v_u_293.ActiveAbilities
            table.insert(v297, v296)
            v_u_29.AddUnitAbility(v_u_249, v296)
        end
    end
    if p245.Familiar and v_u_18.CanUseFamiliar(p245.Familiar.Name) then
        v_u_38.CreateFamiliar(v_u_249, p245.Familiar.Name, v_u_261)
    end
    local v_u_298 = script.UpgradeCallbacks:FindFirstChild(v_u_246[v_u_249].Name)
    if v_u_298 then
        task.spawn(function()
            require(v_u_298)(v_u_246[v_u_249].Model, v_u_246[v_u_249].Level, v_u_246[v_u_249].Data.CurrentAttack, v_u_246[v_u_249].Data)
        end)
    end
    v_u_56.OnUnitPlaced:Fire(v248, v_u_246[v_u_249])
    v_u_34:AddToCache(v_u_249, v287)
    local v_u_299 = v_u_261.PrimaryPart
    local v305 = v_u_283.Changed:Connect(function(p300)
        if (v_u_293.RotationPauseCount or 0) <= 0 then
            local v301 = p300 * v_u_246[v_u_249].Offset
            local v302 = v_u_80
            local v303 = v_u_299
            table.insert(v302, v303)
            local v304 = v_u_81
            table.insert(v304, v301)
        end
    end)
    local v306 = v_u_246[v_u_249].Connections
    table.insert(v306, v305)
    local v307 = v_u_293.Name
    local v308
    if v_u_39.IsQuickPlacing() or not v_u_37:GetSetting("SelectUnitOnPlacement") then
        v308 = false
    else
        v308 = not v_u_55[v307]
    end
    if v308 and not v292 then
        v_u_56:SelectUnit(v_u_261, true, "UnitPlaced")
    end
    local v_u_309 = script.PlacementCallbacks:FindFirstChild(v250)
    for _, v310 in { "Arin", "Riner", "Zak" } do
        if v250:find(v310) then
            v_u_309 = script.PlacementCallbacks["Giant Form"]
            break
        end
    end
    if v250:find("Thunder") then
        v_u_309 = script.PlacementCallbacks.Thunder
    elseif v250:find("Rideon vs Samuel") then
        v_u_309 = script.PlacementCallbacks.Rideon
    elseif v250:find("Black Hole") then
        v_u_309 = script.PlacementCallbacks.BlackHoleWeapons
    end
    if v_u_309 then
        v_u_235[v_u_249] = {
            ["Thread"] = task.spawn(function()
                v_u_293.Model:SetAttribute("InPlacementCallback", true)
                require(v_u_309)(v_u_261, v_u_246[v_u_249], v_u_249)
                v_u_235[v_u_249] = nil
                v_u_293.Model:SetAttribute("InPlacementCallback", nil)
            end),
            ["RemoveAttribute"] = function()
                v_u_293.Model:SetAttribute("InPlacementCallback", nil)
            end
        }
    end
end
function v_u_56.GetAllPlacedUnits(_)
    local v311 = {}
    for v312, v313 in v_u_56._ActiveUnits do
        if v313.Player == v_u_52 then
            v311[v312] = v313
        end
    end
    return v311
end
local v_u_314 = require(v8.Modules.Gameplay.Spectate.SpectateModeHandler)
function v_u_56.Spectate(_, p315)
    local v316 = v_u_53.HUD
    local v317 = v_u_53.Hotbar
    local v318 = v_u_53.Spectate
    local v319 = v_u_56._ActiveUnits[p315]
    assert(v319, "No unit?")
    local v320 = v_u_56:GetUnitModelFromGUID(p315)
    local v321
    if v320 then
        v321 = v320:FindFirstChild("Head") or v320.PrimaryPart
    else
        v321 = v320
    end
    if v320 then
        v_u_314.Cancel()
        v_u_52.CameraMaxZoomDistance = 25
        v_u_52.CameraMinZoomDistance = 0.4
        v_u_1.CameraSubject = v321
        v_u_1.Focus = v321.CFrame
        v317.Enabled = false
        v316.Enabled = false
        v318.Enabled = true
        v_u_234 = p315
        v_u_314.Start(v319)
        v318.Spectate.Leave.Button.Activated:Once(function()
            v_u_56:CancelSpectate()
        end)
    end
end
function v_u_56.CancelSpectate(_)
    local v322 = v_u_52.Character or v_u_52.CharacterAdded:Wait()
    local v323 = v_u_53.HUD
    local v324 = v_u_53.Hotbar
    local v325 = v_u_53:WaitForChild("Spectate")
    v_u_314.Cancel()
    v_u_52.CameraMaxZoomDistance = 40
    v_u_52.CameraMinZoomDistance = 0.5
    v_u_1.CameraSubject = v322.Humanoid
    v324.Enabled = true
    v323.Enabled = true
    v325.Enabled = false
    v_u_234 = nil
end
function v_u_56.LookAt(_, p326, p327)
    local v328 = v_u_56._ActiveUnits[p326]
    local v329
    if v328 then
        v329 = v328.Position
    else
        v329 = v328
    end
    if v328 then
        local v330 = p327.X
        local v331 = v329.Y
        local v332 = p327.Z
        local v333 = Vector3.new(v330, v331, v332)
        local v334 = CFrame.lookAt(v329, v333)
        v_u_3:Create(v328.CFrameValue, v_u_10, {
            ["Value"] = v334
        }):Play()
        local v335 = CFrame.lookAt(v329, v333)
        v_u_56:UpdateIndicatorCFrame(v328, v335, CFrame.new(v333) * v335.Rotation)
        v328.Model:PivotTo(v334)
    end
end
function v_u_56.GetFirstEnemy(_, p336)
    local v337 = v_u_54[p336.Data.Priority]
    local v338 = p336.Position * Vector3.new(1, 0, 1)
    debug.profilebegin("GetUnitRange")
    local v339 = v_u_20:GetMultipliedStatistic(p336, "Range")
    debug.profileend()
    local v340 = p336.Data.CurrentUpgrade
    local v341 = p336.Data.Upgrades[v340].InvertedRange == true
    debug.profilebegin("sort enemies")
    local v342 = v_u_27.GetSortedEnemies(v_u_30:GetPlayerState(p336.Player).Id)
    debug.profileend()
    debug.profilebegin("filter enemies")
    local v343 = {}
    for _, v344 in v342 do
        local v345 = v344[2]
        local v346 = v345.UniqueIdentifier
        v343[tostring(v346)] = v345
    end
    v_u_24:FilterEnemies(v343, p336.Name)
    debug.profileend()
    if v337 == "Last" then
        for v347 = #v342, 1, -1 do
            local v348 = v342[v347][2]
            local v349 = v348.UniqueIdentifier
            if v343[tostring(v349)] then
                local v350 = v348.Position * Vector3.new(1, 0, 1)
                local v351 = v348.Diameter
                if (v338 - v350).Magnitude <= (v339 + v351) / 2 ~= v341 then
                    return v348
                end
            end
        end
    else
        for _, v352 in ipairs(v342) do
            local v353 = v352[2]
            local v354 = v353.UniqueIdentifier
            if v343[tostring(v354)] then
                local v355 = v353.Position * Vector3.new(1, 0, 1)
                local v356 = v353.Diameter
                if (v338 - v355).Magnitude <= (v339 + v356) / 2 ~= v341 then
                    return v353
                end
            end
        end
    end
    return nil
end
function v_u_56.GetEnemiesInRange(_, p357)
    local v358 = p357.Data.CurrentUpgrade
    local v359 = p357.Data.Upgrades[v358]
    local v360 = v_u_20:GetMultipliedStatistic(p357, "Range", v359)
    return v_u_26.GetEnemiesInRange({
        ["CirclePosition"] = p357.Position,
        ["Enemies"] = v_u_27._ActiveEnemies,
        ["CircleDiameter"] = v360,
        ["IsInverted"] = v359.InvertedRange == true,
        ["UnitGUID"] = p357.UniqueIdentifier,
        ["GameStateId"] = v_u_30:GetPlayerState(p357.Player).Id
    })
end
function v_u_56.UpdateIndicatorCFrame(_, p361, p362, p363)
    if v_u_57.TargetIndicators[1] then
        if v_u_56.CurrentlySelectedUnit and v_u_56.CurrentlySelectedUnit == p361.UniqueIdentifier then
            v_u_23:UpdateIndicatorCFrame(p361, v_u_57.TargetIndicators[1], p362, p363 - Vector3.new(0, 1, 0))
        end
    else
        return
    end
end
function v_u_56.GetExistingIndciator(_)
    return v_u_57.TargetIndicators[1]
end
function v_u_56.GetUpgradePriceMultiplier(p364, p365)
    local v366 = p364.Data
    if not v366.Upgrades[p365] then
        return 9000000000
    end
    if p365 == 1 then
        return v366.Price
    end
    local v367 = v_u_56.GlobalUpgradeCost or v366.Upgrades[p365].Price
    local v368 = v_u_18.GetUpgradePriceMultiplier(v366.Name)
    local v369 = v_u_31.GetKeyData(p364.UniqueIdentifier, "UpgradePriceMultiplier") or 1
    return v367 * (1 + (v368 - 1) + (v369 - 1))
end
function v_u_56.GetUnitsInRange(p370, p371, p372, p373)
    if p373 then
        p373 = p373.PlayerOnly
    end
    local v374 = {}
    local v375 = false
    for v376, v377 in v_u_56._ActiveUnits do
        local v378 = v377.Player
        local v379 = v377.Position
        if not p373 or v378 == v_u_52 then
            local v380 = v379 * Vector3.new(1, 0, 1)
            p371 = p371 * Vector3.new(1, 0, 1)
            local v381
            if v376 == p370 then
                v381 = false
            else
                v381 = (v380 - p371).Magnitude <= p372
            end
            if v381 then
                v374[v376] = v377
                v375 = true
            end
        end
    end
    if v375 then
        return v374
    else
        return nil
    end
end
task.spawn(v_u_56.Init)
return v_u_56
local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Data.Entities.Units)
local v3 = require(v1.Modules.Packages.FastSignal)
local v_u_4 = require(v1.Modules.ClientReplicationHandler)
local _ = v1.Networking.Units.UnitWindowEvent
local v_u_5 = {
    ["Initialized"] = false,
    ["UnitAdded"] = v3.new(),
    ["UnitUpdated"] = v3.new(),
    ["UnitsEquippedUpdated"] = v3.new(),
    ["UnitTraitUpdated"] = v3.new(),
    ["UnitRemoved"] = v3.new()
}
local v_u_6 = {}
local v_u_7 = {}
function v_u_5.OnInitialized(p8)
    if not v_u_5.Initialized then
        repeat
            task.wait()
        until v_u_5.Initialized
    end
    p8()
end
local function v_u_15(p9, p10)
    local v11 = v_u_6[p9]
    local v12 = v11 and v11.Trait or {
        ["Name"] = ""
    }
    local v13 = p10.Trait
    local v14 = v13.Name and v12.Name
    if v14 then
        v14 = v13.Name ~= v12.Name
    end
    if not v14 and v13 == v12 then
        return false
    end
    v_u_5.UnitTraitUpdated:Fire(p9, v13, v12)
    return true
end
task.spawn(function()
    v_u_4.RequestInitData("OwnedUnits")
    v_u_4.OnReplicate("OwnedUnits"):Connect(function(p16)
        local v17 = p16.Key
        if v17 == "ReplicateUnits" then
            local v18 = p16.OwnedUnits or p16.UnitsToReplicate
            local v19 = p16.EquippedUnits
            if v18 then
                for v20, v21 in v18 do
                    v21.UnitData = v_u_2:GetUnitDataFromID(v21.Identifier)
                    v_u_6[v20] = v21
                    if v_u_5.Initialized then
                        v_u_5.UnitAdded:Fire(v21)
                    end
                end
            end
            if v19 then
                v_u_7 = table.clone(v19)
                v_u_5.UnitsEquippedUpdated:Fire()
            end
            if v_u_5.Initialized == false then
                v_u_5.Initialized = true
                return
            end
        else
            if v17 == "UpdateUnit" then
                local v22 = p16.UnitGUID
                local v23 = p16.Unit
                v23.UnitData = v_u_2:GetUnitDataFromID(v23.Identifier)
                local v24 = v_u_15(v22, v23)
                v_u_6[v22] = v23
                v_u_5.UnitUpdated:Fire(v22, v24)
                return
            end
            if v17 == "AddUnit" then
                local v25 = p16.UnitGUID
                local v26 = p16.Unit
                local v27 = v_u_2:GetUnitDataFromID(v26.Identifier)
                if not v_u_6[v25] then
                    v26.UnitData = v27
                    v_u_6[v25] = v26
                    v_u_5.UnitAdded:Fire(v25)
                end
            end
            if v17 == "RemoveUnit" then
                local v28 = p16.UnitGUID
                v_u_6[v28] = nil
                v_u_5.UnitRemoved:Fire(v28)
            end
        end
    end)
end)
function v_u_5.GetOwnedUnits()
    if not v_u_5.Initialized then
        repeat
            task.wait()
        until v_u_5.Initialized
    end
    return v_u_6
end
function v_u_5.GetEquippedUnits()
    if not v_u_5.Initialized then
        repeat
            task.wait()
        until v_u_5.Initialized
    end
    return v_u_7
end
function v_u_5.GetUnits()
    if not v_u_5.Initialized then
        repeat
            task.wait()
        until v_u_5.Initialized
    end
    local v29 = table.clone(v_u_6)
    for v30, v31 in v29 do
        local v32 = v_u_2:GetUnitDataFromID(v31.Identifier)
        v29[v30].Data = v32
    end
    return v29
end
function v_u_5.GetUnitObject(p33)
    if not v_u_5.Initialized then
        repeat
            task.wait()
        until v_u_5.Initialized
    end
    return v_u_6[p33]
end
function v_u_5.IsEquipped(p34)
    return table.find(v_u_7, p34) ~= nil
end
return v_u_5
local v_u_1 = workspace.CurrentCamera
local v2 = game:GetService("Players")
game:GetService("StarterPlayer")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("TweenService")
local v_u_5 = game:GetService("UserInputService")
game:GetService("Debris")
local v_u_6 = game:GetService("GuiService")
local v_u_7 = game:GetService("ReplicatedStorage")
local v8 = game:GetService("StarterPlayer")
local v_u_9 = TweenInfo.new(0.325, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_10 = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local v_u_11 = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local v_u_12 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_13 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenInfo.new(0.02, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_14 = TweenInfo.new(0.535, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_15 = Vector2.new(0, 0)
local v_u_16 = require(v_u_7.Modules.Data.Entities.Units)
local v_u_17 = require(v_u_7.Modules.Data.SkinsData)
local v_u_18 = require(v8.Modules.Interface.Loader.Misc.PopupHandler)
local v_u_19 = require(v_u_7.Modules.UnitCollisionHandler)
local v_u_20 = require(v_u_7.Modules.Shared.UnitAnimator)
local v_u_21 = require(v_u_7.Modules.Shared.MultiplierHandler)
local v_u_22 = require(v_u_7.Modules.Shared.CollisionHandler)
local v_u_23 = require(v_u_7.Modules.Gameplay.PlacementValidationHandler)
local v_u_24 = require(v_u_7.Modules.Gameplay.ClientGameStateHandler)
local v_u_25 = require(v8.Modules.Gameplay.Units.BurnUnitsHandler)
local v_u_26 = require(script.PathHighlightHandler)
require(v8.Modules.Interface.Loader.Visuals.UnitScalerHandler)
local v_u_27 = require(script.QuickPlacementHandler)
local v_u_28 = require(v8.Modules.Gameplay.MiscPlacementHandler)
local v_u_29 = require(v_u_7.Modules.Shared.SoundHandler)
require(v_u_7.Modules.Data.GlobalMatchSettings)
require(v8.Modules.Interface.Loader)
local v_u_30 = require(v8.Modules.Interface.InterfaceHandler)
local v_u_31 = require(v8.Modules.Interface.Loader.HUD.Units)
local v_u_32 = require(script.Events)
local v_u_33 = require(v8.Modules.Gameplay.PlayerYenHandler)
local v_u_34 = require(v8.Modules.Gameplay.Units.ClientUnitHandler)
local v_u_35 = require(v_u_7.Modules.Data.Entities.EntityIDHandler)
require(v_u_7.Modules.Utilities.NumberUtils)
local v_u_36 = require(v_u_7.Modules.Utilities.GetBoundingBox)
local v_u_37 = require(v8.Modules.Miscellaneous.UnitHoverHandler)
local v_u_38 = require(v8.Modules.Interface.Loader.ConsoleInputHandler)
local v_u_39 = require(v_u_7.Modules.Packages.Spring)
require(v_u_7.Modules.Debug.Gizmo)
local v_u_40 = require(v8.Modules.Interface.Loader.Notifications)
local v_u_41 = require(v_u_7.Modules.Visuals.TraitEffects)
local v_u_42 = require(v8.Modules.Interface.Loader.HUD.Yen)
require(v8.Modules.Visuals.UnitBoundaryVisualizer)
local v_u_43 = require(v_u_7.Modules.Gameplay.IndicatorHandler)
local v_u_44 = require(v8.Modules.Gameplay.Units.UnitRangeDisplayHandler)
local v_u_45 = require(v8.Modules.Gameplay.SettingsHandler)
local v46 = require(v_u_7.Modules.Packages.FastSignal.Deferred)
local v_u_47 = require(v8.Modules.Interface.Loader.WindowHandler)
require(v_u_7.Modules.Gameplay.GameHandler)
local v_u_48 = require(v8.Modules.Gameplay.Keybinds.KeybindsDataHandler)
local v49 = v_u_7.Networking
local v_u_50 = v49.UnitEvent
local v_u_51 = v49.AbilityEvent
local v_u_52 = v2.LocalPlayer
local v_u_53 = v_u_52:WaitForChild("PlayerGui")
v_u_52:GetMouse()
local _ = v_u_7.Assets.Models.Units
local v54 = workspace:WaitForChild("Map")
local v_u_55 = RaycastParams.new()
v_u_55.FilterType = Enum.RaycastFilterType.Include
v_u_55.FilterDescendantsInstances = { v54 }
local v56 = RaycastParams.new()
v56.FilterType = Enum.RaycastFilterType.Include
v56.FilterDescendantsInstances = { workspace.Ignore, v54 }
local v_u_57 = RaycastParams.new()
v_u_57.FilterType = Enum.RaycastFilterType.Include
v_u_57.FilterDescendantsInstances = { workspace.Units, workspace.UnitHitboxes }
local v_u_58 = (v_u_52.Character or v_u_52.CharacterAdded:Wait()):WaitForChild("Humanoid")
local v_u_59 = v_u_58.WalkSpeed
local v_u_60 = v_u_58.JumpPower
local v_u_61 = workspace.UnitVisuals.UnitCircles
local v_u_62 = {
    ["IsChoosingUnit"] = false,
    ["SandboxPlacement"] = false,
    ["CurrentUnitObject"] = nil,
    ["UnitHoverEnter"] = v46.new(),
    ["UnitHoverLeave"] = v46.new(),
    ["_CurrentActiveUnit"] = {
        ["Name"] = "",
        ["UnitPosition"] = Vector3.new(),
        ["SmoothRotationValue"] = 0,
        ["RotationValue"] = 0,
        ["RangeModels"] = {},
        ["TargetIndicators"] = {},
        ["PlacementUI"] = nil,
        ["Preview"] = nil
    }
}
local function v_u_64(p63)
    if p63 and not (p63:IsA("Model") and p63) then
        p63 = p63:FindFirstAncestorOfClass("Model")
    end
    if p63 and (p63.Parent and p63.Parent.Name == "Units") then
        return p63
    end
    if p63 then
        return v_u_64(p63.Parent)
    end
end
TweenInfo.new(0.175, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function v_u_70(p65)
    local v66 = {
        p65.Place,
        p65.Rotate,
        p65.Cancel,
        p65.QuickPlace
    }
    for v67 = 1, #v66 do
        v66[v67].Main.Position = UDim2.fromScale(-0.5, 0.5)
    end
    for v68 = 1, #v66 do
        if not p65.Parent then
            return
        end
        local v69 = v66[v68].Main
        v_u_39.target(v69, 0.65, 4, {
            ["Position"] = UDim2.fromScale(0.5, 0.5)
        })
        task.wait(0.035)
    end
end
local v_u_71 = {}
local function v_u_80(p72)
    local v73 = v_u_34._ActiveUnits[p72.Name]
    if v_u_52:GetAttribute("FreecamEnabled") then
        return
    elseif v73 then
        local v74 = v73.Player.Name == v_u_52.Name
        local v75 = Instance.new("Highlight")
        v75.FillTransparency = 1
        v75.OutlineTransparency = 1
        v75.FillColor = Color3.fromRGB(255, 255, 255)
        v75.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v75.Parent = p72
        v_u_4:Create(v75, v_u_13, {
            ["FillTransparency"] = 0.25,
            ["OutlineTransparency"] = 0
        }):Play()
        local v76 = v_u_71
        table.insert(v76, v75)
        if v74 and v_u_34.CurrentlySelectedUnit ~= p72.Name then
            local v77 = v_u_61:FindFirstChild(p72.Name)
            local v78 = Color3.fromRGB(760, 637, 185)
            local v79 = v77:FindFirstChild("Image")
            if v79 then
                v79.Color3 = v78
            end
        end
    end
end
local v_u_81 = UDim2.fromOffset(21, 0)
function v_u_62.Init()
    local v_u_82 = v_u_53:WaitForChild("HUD"):WaitForChild("Absolute")
    local v_u_83 = nil
    local function v_u_89()
        local v84 = v_u_83
        if v84 then
            v84 = v_u_34._ActiveUnits[v_u_83.Name]
        end
        if v84 then
            local v85 = v84.Player.Name == v_u_52.Name
            v_u_62.UnitHoverLeave:Fire(v_u_83.Name, v_u_83)
            local v86 = v85 and v_u_61:FindFirstChild(v_u_83.Name)
            if v86 then
                local _, v87 = v_u_34.GetUnitCircleColor(v_u_34._ActiveUnits[v_u_83.Name])
                local v88 = v86:FindFirstChild("Image")
                if v88 then
                    v88.Color3 = v87
                end
            end
            v_u_83 = nil
            if #v_u_71 > 0 then
                v_u_71[1]:Destroy()
                table.clear(v_u_71)
            end
            v_u_37.DestroyPreview()
        end
    end
    v_u_3.Heartbeat:Connect(function()
        local v90 = v_u_5:GetMouseLocation() - v_u_82.AbsolutePosition - v_u_15
        local v91 = UDim2.fromOffset(v90.X, v90.Y) + v_u_81
        if v_u_34.IsPlacingUnit and v_u_62.PlacementUI then
            v_u_62.PlacementUI.Position = v91
            return
        else
            if #v_u_71 < 1 and (v_u_83 and not v_u_52:GetAttribute("FreecamEnabled")) then
                v_u_80(v_u_83)
            end
            if not v_u_37.ActivePreview and v_u_83 then
                v_u_37:CreatePreview(v_u_34._ActiveUnits[v_u_83.Name], v91)
            end
            v_u_37.UpdatePosition(v91)
            if v_u_34.CanSelectUnits then
                local v92 = v_u_5:GetMouseLocation()
                local v93 = v_u_1:ViewportPointToRay(v92.X, v92.Y)
                local v94 = workspace:Raycast(v93.Origin, v93.Direction * 2000, v_u_57)
                local v95
                if v94 then
                    v95 = v94.Instance
                else
                    v95 = v94
                end
                if v94 and v95.Parent.Name == "UnitHitboxes" then
                    v95 = v_u_34:GetUnitModelFromGUID(v95.Name)
                end
                if v94 and v_u_34.CanSelectUnits then
                    if v95 and not (v95:IsA("Model") and v95) then
                        v95 = v95:FindFirstAncestorOfClass("Model")
                    end
                    if not v95 or (not v95.Parent or v95.Parent.Name ~= "Units") then
                        if v95 then
                            v95 = v_u_64(v95.Parent)
                        else
                            v95 = nil
                        end
                    end
                    if not v_u_83 or v95 and v95.Name ~= v_u_83.Name then
                        v_u_89()
                        v_u_83 = v95
                        v_u_62.UnitHoverEnter:Fire(v95)
                    end
                else
                    v_u_89()
                end
            else
                return
            end
        end
    end)
    v_u_50.OnClientEvent:Connect(function(p96, p97, p98, p99)
        if p96 == "RequestPlacement" then
            local v100 = v_u_35:GetIDFromName("Unit", p97)
            local v101 = v_u_16:GetUnitByName(p97)
            local v102 = {
                ["Identifier"] = v100,
                ["Shiny"] = p98,
                ["Trait"] = {
                    ["Name"] = "None"
                },
                ["Level"] = 1,
                ["Data"] = v101
            }
            v_u_62.Start(nil, v102, p99)
        end
    end)
    v_u_47.OpenedWindow:Connect(function(p103)
        if p103 == "Units" then
            v_u_62:Cancel()
            v_u_62.IsChoosingUnit = true
        end
    end)
    v_u_47.ClosedWindow:Connect(function(p104)
        if p104 == "Units" then
            v_u_62.IsChoosingUnit = false
        end
    end)
end
local v_u_105 = nil
local v_u_106 = false
local function v_u_107()
    if v_u_5:GetLastInputType() == Enum.UserInputType.Touch or v_u_38.IsPlayerUsingConsole() then
        v_u_38.RemoveSelected()
        if not v_u_38.IsPlayerUsingConsole() then
            v_u_105 = workspace.CurrentCamera.CameraType
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        end
        v_u_59 = v_u_58.WalkSpeed
        v_u_60 = v_u_58.JumpPower
        v_u_58.JumpPower = 0
        if not v_u_38.IsPlayerUsingConsole() then
            v_u_58.WalkSpeed = 0
            v_u_6.TouchControlsEnabled = false
        end
        v_u_38.EnableGamepadCursor(nil)
        v_u_106 = true
        v_u_30:ToggleMobileButtons(false)
    end
end
local function v_u_108()
    if v_u_5:GetLastInputType() == Enum.UserInputType.Touch or v_u_38.IsPlayerUsingConsole() then
        if v_u_105 then
            workspace.CurrentCamera.CameraType = v_u_105
            v_u_105 = nil
        end
        v_u_58.JumpPower = v_u_60
        if not v_u_38.IsPlayerUsingConsole() then
            v_u_58.WalkSpeed = v_u_59
            v_u_6.TouchControlsEnabled = true
        end
        v_u_106 = false
        v_u_38.DisableGamepadCursor()
        v_u_30:ToggleMobileButtons(true)
    end
end
local v_u_109 = false
local function v111(p110)
    if p110.KeyCode == Enum.KeyCode.Thumbstick2 then
        if v_u_106 then
            if v_u_109 and p110.Position.Magnitude <= 0.1 then
                v_u_109 = false
                v_u_38.EnableGamepadCursor(nil)
                return
            end
            if not v_u_109 and p110.Position.Magnitude > 0.1 then
                v_u_109 = true
                v_u_38.DisableGamepadCursor()
            end
        end
    end
end
v_u_5.InputChanged:Connect(v111)
local v_u_112 = nil
local v_u_113 = nil
function v_u_62.Start(p114, p115, p116)
    local v117 = v_u_62._CurrentActiveUnit
    if v_u_112 then
        return
    elseif p114 and v_u_31._Cache[p114] == "None" then
        return
    elseif v_u_62.IsChoosingUnit then
        return v_u_40:CreateNotification({
            ["Name"] = "Failure",
            ["Text"] = "You can\'t place down units while choosing."
        })
    elseif p114 and v_u_25:IsSlotBurnt(p114) then
        return v_u_18:ShowPopup("BaseCancelFrame", "This slot is burnt, it cannot be used!")
    elseif v_u_28.IsPlacing() and not v_u_28.IsOnlySelecting() then
        return v_u_40:CreateNotification({
            ["Name"] = "Failure",
            ["Text"] = "You can\'t place down units while misc. placing!"
        })
    else
        if p115 and not p115.Statistics then
            p115.Statistics = {
                ["Damage"] = {
                    ["Percentage"] = 100
                },
                ["SPA"] = {
                    ["Percentage"] = 100
                },
                ["Range"] = {
                    ["Percentage"] = 0
                },
                ["CriticalChance"] = {
                    ["Percentage"] = 100
                },
                ["Income"] = {
                    ["Percentage"] = 100
                }
            }
        end
        v_u_112 = task.delay(0.1, function()
            v_u_112 = nil
        end)
        local v118 = v_u_53:WaitForChild("HUD"):WaitForChild("Absolute")
        local v119 = typeof(p115) == "table" and p115 and p115 or (p114 and (v_u_31._Cache[p114] or {}) or {})
        local v120 = v119.Identifier
        local v121 = v119.Trait
        local _ = v119.Shiny
        local v122 = v_u_16:GetUnitDataFromID(v120) or {}
        local v_u_123
        if v122 then
            v_u_123 = v_u_17.GetModel(v119)
        else
            v_u_123 = v122
        end
        local _ = v122.Name
        local _ = v122.UnitType
        local v124 = v122.Upgrades
        if v124 then
            v124 = v124[1]
        end
        if p115 then
            p115 = p115.RangeOverride
        end
        if not p115 then
            if v122 then
                p115 = v_u_21:GetMultipliedStatistic(v119, "Range", v124)
            else
                p115 = v122
            end
        end
        local v125 = Color3.fromRGB(201, 245, 255)
        local v126 = {}
        if v_u_123 and v_u_62._CurrentActiveUnit.Name == v_u_123.Name then
            v_u_62:Cancel()
        else
            if v_u_123 and (v_u_62._CurrentActiveUnit.Name ~= "" and v_u_62._CurrentActiveUnit.Name ~= v_u_123.Name) then
                v_u_62:Cancel()
            end
            v_u_34:DeselectUnit(v_u_34.CurrentlySelectedUnit)
            v_u_37:DestroyPreview()
            v_u_107()
            if p114 then
                v_u_31:Select(p114)
            end
            v_u_34.IsPlacingUnit = true
            v_u_27.IsPlayerPlacing = true
            v_u_27.StartQuickPlacement()
            v_u_32.UnitPlacementStarted:Fire()
            if v_u_123 then
                v_u_123 = v_u_123:Clone()
            end
            if not v_u_123 then
                v_u_123 = Instance.new("Model")
                v_u_123:ScaleTo(0.43)
                local v127 = Instance.new("Part")
                v127.Anchored = true
                v127.CanCollide = false
                v127.Transparency = 1
                v127.Parent = v_u_123
                v127.Name = "HumanoidRootPart"
                v_u_123.PrimaryPart = v127
            end
            local _ = v122.Hitbox.Y / 2
            local v128 = v_u_123:GetScale()
            v_u_123:ScaleTo(0.01)
            v_u_123.Parent = workspace.Camera
            v_u_19:SetUnitCollisions(v_u_123)
            v_u_19:DisableHumanoidStates(v_u_123)
            v_u_22:SetCollisionGroup(v_u_123, "Units", true)
            local v_u_129 = Instance.new("NumberValue")
            v_u_129.Value = 0.01
            v_u_39.target(v_u_129, 0.385, 3, {
                ["Value"] = v128
            })
            v_u_129.Changed:Connect(function(p130)
                if not v_u_123.Parent then
                    v_u_129:Destroy()
                end
                v_u_123:ScaleTo(p130)
            end)
            v_u_123.Destroying:Once(function()
                v_u_129:Destroy()
            end)
            if v_u_123 then
                v_u_20:PlayIdleAnimation(v_u_123, v122)
            end
            local v131 = v_u_5:GetLastInputType()
            local v132 = v_u_5:GetMouseLocation() - v118.AbsolutePosition - v_u_15
            if v131 ~= Enum.UserInputType.Touch then
                local v133 = v_u_7.Assets.Interfaces.PlacementFrame:Clone()
                v133.Rotate.Main.Keybind.Label.Text = v_u_48.GetBind("Rotate").Name
                v133.Cancel.Main.Keybind.Label.Text = v_u_48.GetBind("CancelPlacement").Name
                v133.Position = UDim2.fromScale(v132.X, v132.Y) + v_u_81
                v133.Parent = v118
                task.defer(v_u_70, v133)
                v_u_62.PlacementUI = v133
            end
            local v134 = v_u_123
            if v134:FindFirstChild("HoverFocus") then
                v134 = v134.HoverFocus.Value or v134
                print("tried to hover focus", v134)
            end
            local v135 = Instance.new("Highlight")
            v135.OutlineColor = v125
            v135.FillColor = v125
            v135.FillTransparency = 0.475
            v135.OutlineTransparency = 0.15
            v135.Parent = v134
            v_u_4:Create(v135, v_u_14, {
                ["FillTransparency"] = 0.15
            }):Play()
            local v136 = v_u_7.Assets.Models.Misc.RangePart:Clone()
            local v137 = p115 / 1.5
            local v138 = p115 / 1.5
            v136.Size = Vector3.new(v137, 0.3, v138)
            v136.Parent = workspace.UnitVisuals
            v_u_39.target(v136, 0.385, 3, {
                ["Size"] = Vector3.new(p115, 0.3, p115)
            })
            v_u_4:Create(v136, v_u_11, {
                ["Orientation"] = v136.Orientation + Vector3.new(0, 360, 0)
            }):Play()
            table.insert(v126, v136)
            local v139 = v_u_7.Assets.Models.Misc.UnitCircle:Clone()
            v139.Size = Vector3.new(0, 0, 0)
            local v140 = v139:FindFirstChild("Image")
            if v140 then
                v140.Color3 = Color3.fromRGB(182, 465, 892)
            end
            v139.Attachment.Gradient.Color = ColorSequence.new(Color3.fromRGB(47, 172, 255))
            v139.Parent = workspace.UnitVisuals
            v_u_4:Create(v139, v_u_9, {
                ["Size"] = Vector3.new(2.85, 0.05, 2.85)
            }):Play()
            v_u_4:Create(v139, v_u_10, {
                ["Orientation"] = v139.Orientation + Vector3.new(0, 360, 0)
            }):Play()
            table.insert(v126, v139)
            v117.RangeModels = v126
            if v120 and v117.Name == "" then
                v117.Name = v_u_123.Name
                v117.UnitData = {
                    ["Data"] = v122
                }
                v117.Model = v_u_123
                v117.RangeModels = v126
                v117.FromUnitGUID = p116
            end
            v_u_62:Update(v_u_123, {
                ["SelectedUnitID"] = v120
            })
            if v121 and v121.Name ~= "None" then
                v_u_41:PlayTraitEffect(v121.Name, v_u_123, {
                    ["DelayTime"] = v_u_12.Time / 1.85
                })
            end
            if v_u_45:GetSetting("ShowMaxRangeOnPlacement") == true then
                v_u_44:ShowMaxUpgradeRange(v119, v122, v_u_123, Vector3.new(0, 0, 0), {
                    ["RangeProfile"] = "White"
                })
            end
            v_u_113 = v_u_43:CreateTargetIndicator({
                ["UnitModel"] = v_u_123,
                ["UnitData"] = {
                    ["Range"] = p115,
                    ["AOEType"] = v124.AOEType or "Circle",
                    ["AOESize"] = v124.AOESize,
                    ["CircleRadius"] = v124.CircleRadius,
                    ["AOEOffset"] = v124.AOEOffset or 0,
                    ["UnitType"] = v122.UnitType
                },
                ["Position"] = Vector3.new(0, 0, 0),
                ["CFrame"] = CFrame.identity
            })
            v_u_26.AddHighlight()
        end
    end
end
local v_u_141 = v_u_33:GetYen() or 0
v_u_33.OnYenChanged:Connect(function(p142)
    v_u_141 = p142
end)
local function v_u_147()
    local v143 = v_u_24:GetPlayerState(v_u_52).Id
    local v144 = {}
    for v145, v146 in v_u_34._ActiveUnits do
        if v143 == v_u_24:GetPlayerState(v146.Player).Id then
            v144[v145] = v146
        end
    end
    return v144
end
local _ = CFrame.identity
local v_u_148 = require(script.MouseMovementHandler)
function v_u_62.Update(_, p_u_149, p150)
    if p_u_149 then
        if p150.SelectedUnitID then
            local v151 = v_u_62._CurrentActiveUnit
            local v_u_152 = v_u_16:GetUnitDataFromID(p150.SelectedUnitID)
            if string.find(v_u_152.Name, "Ishtar") then
                v_u_152 = v_u_16:GetUnitDataFromID(v_u_35:GetIDFromName("Unit", "Gilgamesh (King of Heroes)"))
            end
            local v_u_153 = p_u_149.PrimaryPart
            local v_u_154 = v151.RangeModels
            local v_u_155 = v_u_36(v_u_152.Model, v_u_153.CFrame).Y / 2
            local v_u_156 = true
            local v_u_157 = v_u_153.CFrame
            local v_u_158 = v_u_157.Position
            local v_u_159 = CFrame.identity
            local v_u_160 = os.clock()
            v_u_148.IsActive = true
            v_u_148.UpdateMouseLocation()
            v_u_3:BindToRenderStep("UnitPlacement", Enum.RenderPriority.Camera.Value, function()
                local v161 = os.clock()
                local v162 = v161 - v_u_160
                v_u_160 = v161
                local v163 = v_u_148.GetMouseLocation(v_u_38.IsPlayerUsingConsole() and "UnitPlacement" or nil)
                local v164 = v_u_1:ViewportPointToRay(v163.X, v163.Y)
                local v165 = workspace:Raycast(v164.Origin, v164.Direction * 2000, v_u_55)
                if v165 then
                    local v166 = CFrame.new(v165.Position.X, v165.Position.Y, v165.Position.Z)
                    local v167 = v_u_33:CanAffordUnit(v_u_152)
                    local v168 = v_u_152.Name
                    local v169 = v166.Position
                    local v170 = v_u_152.CustomPlacementHeight
                    local v171, v172 = v_u_23:CanFitUnit({
                        ["UnitName"] = v168,
                        ["UnitPosition"] = v169,
                        ["Units"] = v_u_147(),
                        ["CustomPlacementHeight"] = v170
                    })
                    v_u_62._CurrentActiveUnit.UnitPosition = v166.Position
                    if v171 then
                        v166 = CFrame.new(v172)
                    end
                    local v173 = v_u_155
                    local v174 = v166 + Vector3.new(0, v173, 0)
                    v_u_62:RecolorRangeModels(v_u_154, p_u_149, v167 and v171)
                    local v175 = v_u_62._CurrentActiveUnit.SmoothRotationValue
                    local v176 = v174 * CFrame.Angles(0, math.rad(v175), 0)
                    if v_u_156 then
                        v_u_157 = v176
                    else
                        local v177 = 30 * v162
                        v_u_157 = v_u_157:Lerp(v176, (math.clamp(v177, 0, 1)))
                    end
                    local v178 = v_u_157.Position - v_u_158
                    local v179 = v178.Magnitude
                    local v180 = v179 > 0 and (v178.Unit * (v179 * 75) or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)
                    local v181 = v180.X
                    local v182 = math.clamp(v181, -20, 20)
                    local v183 = v180.Z
                    local v184 = math.clamp(v183, -20, 20)
                    if v179 > 0 then
                        v_u_159 = v_u_159:Lerp(CFrame.Angles(math.rad(v184), math.rad(v182), 0), 0.11499999999999999)
                    else
                        v_u_159 = v_u_159:Lerp(CFrame.identity, 0.11499999999999999)
                    end
                    local v185 = v_u_157 * v_u_159
                    local v186 = v_u_44
                    local v187 = -v_u_155
                    v186:UpdateRangePositions(v185 * Vector3.new(0, v187, 0))
                    if v_u_113 then
                        v_u_43:UpdateUnitCFrame(v_u_113, v185, p_u_149)
                    end
                    for _, v188 in v_u_154 do
                        local v189 = -v_u_155
                        v188.Position = v185 * Vector3.new(0, v189, 0) + Vector3.new(0, 0.25, 0)
                    end
                    v_u_153.CFrame = v185 * CFrame.new(0, v_u_152.CustomPlacementHeight or 0, 0)
                    v_u_158 = v_u_157.Position
                end
            end)
            task.delay(0.2, function()
                v_u_156 = false
            end)
        end
    else
        return
    end
end
local v_u_190 = {}
function v_u_62.Rotate(_)
    local v_u_191 = v_u_62._CurrentActiveUnit
    if v_u_191.Name ~= "" and v_u_191.Model ~= "" then
        if v_u_190[1] then
            v_u_190[1]:Disconnect()
        end
        local v192 = v_u_191.NumberValue or Instance.new("NumberValue")
        if v192.Value == 0 then
            v192.Value = v_u_191.RotationValue
        end
        v_u_191.NumberValue = v192
        v_u_191.RotationValue = v_u_191.RotationValue + 90
        v_u_39.target(v192, 0.475, 2.7, {
            ["Value"] = v_u_191.RotationValue
        })
        local v193 = v_u_190
        local v194 = v192.Changed
        table.insert(v193, v194:Connect(function(p195)
            v_u_191.SmoothRotationValue = p195
        end))
    end
end
function v_u_62.Cancel(_)
    v_u_108()
    v_u_30:TweenOpenMultiple({ "Hotbar", "SideButtons", "Info" })
    local v196 = v_u_62._CurrentActiveUnit
    v_u_34.IsPlacingUnit = false
    v_u_148.IsActive = false
    v_u_27.IsPlayerPlacing = false
    v_u_27.StopQuickPlacement()
    v_u_32.UnitPlacementEnded:Fire()
    v_u_31:DeselectAll()
    if v196.Model and v196.Model.ClassName == "Model" then
        v196.Model:Destroy()
        v196.Model = nil
    end
    if v_u_62.PlacementUI then
        v_u_62.PlacementUI:Destroy()
        v_u_62.PlacementUI = nil
    end
    v_u_3:UnbindFromRenderStep("UnitPlacement")
    if v196.NumberValue then
        v196.NumberValue:Destroy()
        v196.NumberValue = nil
    end
    v_u_62.SandboxPlacement = false
    v_u_62.CurrentUnitObject = nil
    if v196.RangeModels then
        for _, v197 in ipairs(v196.RangeModels) do
            v197:Destroy()
        end
        table.clear(v196.RangeModels)
    end
    if v_u_113 then
        v_u_43:RemoveIndicator(v_u_113)
        v_u_113 = nil
    end
    v196.Name = ""
    v196.RotationValue = 0
    v196.SmoothRotationValue = 0
    v196.UnitPosition = Vector3.new()
    v_u_44:HideRange()
    v_u_26.RemoveHighlight()
end
function v_u_62.PlaceUnit(_)
    local v198 = v_u_62._CurrentActiveUnit
    if v198.Name == "" then
        return
    else
        local v199 = v198.UnitPosition
        local v200 = v198.UnitData.Data
        local v201 = v200.Name
        local v202 = v198.UnitData.Data.CustomPlacementHeight
        local v203, _ = v_u_23:CanFitUnit({
            ["UnitName"] = v201,
            ["UnitPosition"] = v199,
            ["Units"] = v_u_147(),
            ["CustomPlacementHeight"] = v202
        })
        local v204 = v_u_33:CanAffordUnit(v200)
        if v203 then
            if v204 then
                v_u_108()
                local v205 = v_u_62.SandboxPlacement
                if v205 then
                    v205 = v_u_62.CurrentUnitObject
                end
                local v206 = v_u_62._CurrentActiveUnit
                local v207 = {
                    v206.UnitData.Data.Name,
                    v206.UnitData.Data.ID,
                    v206.UnitPosition,
                    v206.RotationValue % 360,
                    v205 or nil
                }
                if v198.NumberValue then
                    v198.NumberValue:Destroy()
                    v198.NumberValue = nil
                end
                local v208 = v_u_27.IsQuickPlacing()
                local v209 = v198.FromUnitGUID and {
                    ["FromUnitGUID"] = v198.FromUnitGUID
                } or nil
                if v207 then
                    v_u_50:FireServer("Render", v207, v209)
                    if v200.Name == "Valentine (AU)" and v208 then
                        local v210 = v198.FromUnitGUID
                        if not v210 then
                            for v211, v212 in v_u_34._ActiveUnits do
                                if v212.Name == "Valentine (Love Train)" and v212.Player == v_u_52 then
                                    v210 = v211
                                end
                            end
                        end
                        if v210 then
                            v_u_31:DeselectAll()
                            v_u_62:Cancel()
                            v_u_51:FireServer("Activate", v210, "This is Another Me...")
                        end
                    end
                    if not v208 then
                        v_u_62:Cancel()
                    end
                end
                if not v208 then
                    v_u_31:DeselectAll()
                end
            else
                v_u_42.NotEnoughYenAnimation()
            end
        else
            v_u_40:CreateNotification({
                ["Name"] = "Failure",
                ["Text"] = "You can\'t place this unit here!"
            })
            v_u_29:PlayLocalSound({ "General", "Miscellaneous" }, "ActionFailed", {
                ["Destroy"] = true
            })
            return
        end
    end
end
function v_u_62.RecolorRangeModels(_, p213, p214, p215)
    if p213 and #p213 > 0 then
        local v216 = p215 and Color3.fromRGB(201, 245, 255) or Color3.fromRGB(255, 134, 136)
        local v217 = p215 and Color3.fromRGB(41, 144, 255) or Color3.fromRGB(255, 34, 38)
        local v218 = p214:FindFirstChildOfClass("Highlight")
        if v218 then
            v218.FillColor = v216
            v218.OutlineColor = v216
        end
        for _, v219 in ipairs(p213) do
            if v219.Name == "RangePart" then
                v219.Main.Circle.BackgroundColor3 = v217
                v219.Main.BrokenCircle.ImageColor3 = v217
            end
            v219.Color = v217
        end
    end
end
task.spawn(v_u_62.Init)
v_u_48.KeybindsUpdated:Connect(function()
    local v220 = v_u_62.PlacementUI
    if v220 then
        v220.Rotate.Main.Keybind.Label.Text = v_u_48.GetBind("Rotate").Name
        v220.Cancel.Main.Keybind.Label.Text = v_u_48.GetBind("CancelPlacement").Name
    end
end)
return v_u_62
game:GetService("Lighting")
local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v_u_3 = require(script.Parent.ClientUnitHandler)
local v_u_4 = require(v2.Modules.Utilities.EffectUtils)
local _ = v1.LocalPlayer
local v_u_5 = {
    ["Rogita (Super)"] = { 0, 4, 8 },
    ["Lord Friezo (Emperor)"] = { 0, 5 },
    ["Eizan_Soultracer"] = { 0, 12 }
}
local v_u_34 = {
    ["GetForm"] = function(p6)
        local v7 = p6.Data.CurrentUpgrade
        local v8 = v_u_5[p6.Name] or v_u_5[p6.SkinName or (p6.Skin or "N/A")]
        if v8 then
            print("Found form upgrades data for", p6.Name, p6.SkinName, p6.Skin)
            local v9 = #v8
            for v10 = 1, v9 do
                if v7 < v8[v10] then
                    return v10 - 1
                end
            end
            return v9
        end
    end,
    ["SetForm"] = function(p11, p12)
        local v13 = p12 or v_u_34.GetForm(p11)
        if v13 then
            local v14 = p11.Model
            local v15 = next
            local v16, v17 = v14:GetChildren()
            for _, v18 in v15, v16, v17 do
                local v19 = v18.Name
                local v20 = string.sub(v19, -1, -1)
                local v21 = tonumber(v20)
                if v21 then
                    local v22 = v21 == v13
                    v_u_4:ToggleParticle(v18, v22)
                    v_u_4:ToggleBeam(v18, v22)
                    local v23 = next
                    local v24, v25 = v18:GetDescendants()
                    for _, v26 in v23, v24, v25 do
                        if v26:IsA("BasePart") or v26:IsA("Decal") then
                            if v26:GetAttribute("AlwaysTransparent") then
                                v26.Transparency = 1
                            else
                                v26.Transparency = v22 and 0 or 1
                            end
                        end
                    end
                end
            end
            local v27 = next
            local v28, v29 = v14.Head:GetChildren()
            for _, v30 in v27, v28, v29 do
                local v31 = v30.Name
                local v32 = string.sub(v31, -1, -1)
                local v33 = tonumber(v32)
                if v33 then
                    v30.Transparency = v33 == v13 and 0 or 1
                end
            end
        end
    end
}
task.spawn(function()
    for _, v35 in next, v_u_3._ActiveUnits do
        v_u_34.SetForm(v35)
    end
    v_u_3.OnUnitUpgraded:Connect(function(p36)
        local _ = p36.Data.CurrentUpgrade
        v_u_34.SetForm(p36)
    end)
end)
return v_u_34
game:GetService("Players")
local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = require(v_u_1.Modules.Shared.MultiplierHandler)
local v_u_4 = TweenInfo.new(0.235, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_5 = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local v_u_6 = {}
local v_u_7 = {}
function v_u_6.ShowUpgradeRange(_, p8, p9, p10)
    local v11 = p8.Model
    local v12 = p8.Position
    local v13 = p8.Data or p8.UnitData
    local v14 = v13.CurrentUpgrade
    local v15 = v13.Upgrades
    if v15 then
        local v16 = v15[v14]
        local v17 = v15[p10]
        if v17 and v16 then
            local v18 = v_u_3:GetMultipliedStatistic(p8, "Range", v16)
            local v19 = v_u_3:GetMultipliedStatistic(p8, "Range", v17)
            if v18 == v19 then
                v_u_6:HideRange()
            else
                v_u_6:ShowRange(v11, v12, v19, p9)
            end
        else
            return v_u_6:HideRange()
        end
    else
        return warn("No unit upgrades!")
    end
end
function v_u_6.ShowNextUpgradeRange(_, p20, p21)
    local v22 = p20.Model
    local v23 = p20.Position
    local v24 = p20.Data or p20.UnitData
    local v25 = v24.CurrentUpgrade
    local v26 = v24.Upgrades
    if v25 and v26 then
        local v27 = v26[v25]
        local v28 = v26[v25 + 1]
        if v28 and v27 then
            local v29 = v_u_3:GetMultipliedStatistic(p20, "Range", v27)
            local v30 = v_u_3:GetMultipliedStatistic(p20, "Range", v28)
            if v29 == v30 then
                v_u_6:HideRange()
            else
                v_u_6:ShowRange(v22, v23, v30, p21)
            end
        else
            return v_u_6:HideRange()
        end
    else
        return
    end
end
function v_u_6.ShowMaxUpgradeRange(_, p31, p32, p33, p34, p35)
    local v36 = p33 or p31.Model
    local v37 = p34 or p31.Position
    local v38 = (p32 or p31.Data).Upgrades
    local v39 = v38[#v38]
    if not v39 then
        return v_u_6:HideRange()
    end
    local v40 = v_u_3:GetMultipliedStatistic(p31, "Range", v39)
    if v40 then
        v_u_6:ShowRange(v36, v37, v40, p35)
    end
end
function v_u_6.UpdateRangePositions(_, p41)
    for _, v42 in v_u_7 do
        v42.Position = p41
    end
end
local v_u_43 = {
    ["DarkBlue"] = {
        ["CircleTransparency"] = 0.75,
        ["OuterCircleTransparency"] = 0.385,
        ["CircleColor"] = Color3.fromRGB(3, 54, 104),
        ["OuterColor"] = Color3.fromRGB(3, 54, 104)
    },
    ["White"] = {
        ["CircleTransparency"] = 0.975,
        ["OuterCircleTransparency"] = 0.915,
        ["CircleColor"] = Color3.fromRGB(255, 255, 255),
        ["OuterColor"] = Color3.fromRGB(255, 255, 255)
    }
}
function v_u_6.ShowRange(_, p44, p45, p46, p47)
    v_u_6:HideRange()
    local v48 = v_u_43[p47 and p47.RangeProfile or "DarkBlue"]
    local v49 = p44.Name
    local v50 = workspace.UnitVisuals.UnitCircles:FindFirstChild(v49)
    local v51 = v_u_1.Assets.Models.Misc.RangePart:Clone()
    if v50 then
        v51.Position = v50.Position + Vector3.new(0, 0.25, 0)
    else
        local v52 = p44.PrimaryPart.Size.Y / 2
        local v53 = p45 + Vector3.new(0, v52, 0)
        local v54 = p44:GetExtentsSize().Y / 2
        v51.Position = v53 - Vector3.new(0, v54, 0)
    end
    v51.Main.Circle.BackgroundTransparency = v48.CircleTransparency
    v51.Main.BrokenCircle.ImageTransparency = v48.OuterCircleTransparency
    v51.Main.Circle.BackgroundColor3 = v48.CircleColor
    v51.Main.BrokenCircle.ImageColor3 = v48.OuterColor
    local v55 = p46 / 1.15
    local v56 = p46 / 1.15
    v51.Size = Vector3.new(v55, 0.09, v56)
    v51.Parent = workspace.UnitVisuals
    v_u_2:Create(v51, v_u_5, {
        ["Orientation"] = v51.Orientation + Vector3.new(0, 360, 0)
    }):Play()
    local v57 = v_u_7
    table.insert(v57, v51)
    v_u_2:Create(v51, v_u_4, {
        ["Size"] = Vector3.new(p46, 0.1, p46)
    }):Play()
end
function v_u_6.HideRange(_)
    for _, v58 in v_u_7 do
        v58:Destroy()
    end
    table.clear(v_u_7)
end
return v_u_6
local v1 = game:GetService("Players")
game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
game:GetService("UserInputService")
local v_u_3 = game:GetService("Debris")
local v4 = game:GetService("ReplicatedStorage")
v1.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UpgradeInterfaces")
local v_u_5 = require(v4.Modules.Packages.Spring)
require(v4.Modules.Packages.FastSignal.Deferred)
local v_u_6 = require(v2.Modules.Gameplay.Units.ClientUnitHandler)
local v_u_7 = require(v2.Modules.Gameplay.Units.UnitHideHandler)
local v_u_8 = require(v2.Modules.Gameplay.Units.ClientUnitDataHandler)
local v9 = v4.Networking
local v_u_10 = v9.ClientListeners.Units.AutoAbilityEvent
local v_u_11 = v9.Units.UpdateUnitElements
local v_u_12 = require(script.Managers.UICreationManager)
local v_u_13 = require(script.Managers.DisplaysManager)
local v_u_14 = require(script.Managers.InputManager)
local v_u_15 = require(script.Managers.ButtonsManager)
local v_u_16 = require(script.Managers.AbilitiesManager)
require(script.UpgradeInterfaceData)
require(v4.Modules.Data.Entities.Units)
local v_u_17 = require(v2.Modules.Gameplay.Keybinds.KeybindsDataHandler)
local v18 = require(script.Events)
local v_u_19 = {
    ["UpgradeInterfaceShown"] = v18.UpgradeInterfaceShown,
    ["UpgradeInterfaceHidden"] = v18.UpgradeInterfaceHidden
}
local v_u_20 = {}
local v_u_21 = nil
local v_u_22 = nil
local v_u_23 = nil
local v_u_24 = {}
local function v_u_27(p25)
    if v_u_21 and (not p25 or v_u_22 == p25.UniqueIdentifier) then
        v_u_19.UpgradeInterfaceHidden:Fire()
        v_u_5.target(v_u_21, 0.55, 5, {
            ["Position"] = v_u_21.Position - UDim2.fromScale(0.4, 0)
        })
        v_u_3:AddItem(v_u_21, 0.4)
        v_u_21 = nil
        v_u_22 = nil
        v_u_23 = nil
        for _, v26 in v_u_20 do
            v26:Disconnect()
        end
        table.clear(v_u_20)
        table.clear(v_u_24)
    end
end
local function v_u_32(p28)
    v_u_22 = p28.UniqueIdentifier
    v_u_21 = v_u_12.CreateUpgradeInterface(p28)
    v_u_21.Keybinds.Upgrade.Keybind.Label.Text = v_u_17.GetBind("Upgrade").Name
    v_u_19.UpgradeInterfaceShown:Fire(v_u_21, p28.Data or p28.UnitData, p28)
    for _, v29 in v_u_20 do
        v29:Disconnect()
    end
    table.clear(v_u_20)
    v_u_13.UpdateAllDisplays(p28, v_u_21, v_u_20)
    v_u_15.SetupAllButtons(p28, v_u_21, v_u_20, v_u_24)
    v_u_16.HandleAbilities(p28, v_u_21)
    v_u_23 = v_u_12.GetActiveTemplate()
    local v30 = v_u_14.SetupUnitInputs(p28, v_u_22, v_u_21, v_u_24)
    local v31 = v_u_20
    table.insert(v31, v30)
end
function v_u_19.HandleUpgrade(p33)
    return v_u_15.HandleUpgrade(p33)
end
function v_u_19.CloseInterface()
    return v_u_27(nil)
end
function v_u_19.GetInterface()
    return v_u_21
end
v_u_19.GetUpgradePrice = v_u_15.GetUpgradePrice
task.spawn(function()
    v_u_6.OnUnitSelected:Connect(function(_, p34)
        v_u_32(p34)
    end)
    v_u_6.OnUnitUpgraded:Connect(function(p35)
        if v_u_22 == p35.UniqueIdentifier then
            v_u_13.HandleUpgradeDisplay(p35, v_u_21, "Upgrade")
        end
    end)
    v_u_6.OnUnitPriorityChanged:Connect(function(p36)
        if v_u_22 == p36.UniqueIdentifier then
            v_u_13.HandleUnitPriorityLabel(p36, v_u_21)
        end
    end)
    v_u_6.OnUnitStatChanged:Connect(function(p37)
        if v_u_22 == p37.UniqueIdentifier then
            v_u_13.HandleUpgradeDisplay(p37, v_u_21, "Upgrade")
        end
    end)
    v_u_6.OnUnitSellValueRemoved:Connect(function(p38)
        if v_u_22 == p38.UniqueIdentifier then
            v_u_13.HandleUpgradeDisplay(p38, v_u_21)
        end
    end)
    v_u_6.OnUnitDeselected:Connect(function(p39)
        v_u_27(p39)
    end)
    v_u_7.UnitHidden:Connect(function(p40)
        if v_u_22 == p40 then
            v_u_27()
        end
    end)
    v_u_10.OnClientEvent:Connect(function(p41, p42, p43)
        if v_u_22 == p41 then
            v_u_16.AnimateAutoAbilitySlider(p42, p43, v_u_21)
        end
    end)
    v_u_8.UnitPropertyChanged:Connect(function(p44, _, _)
        if v_u_22 == p44 then
            local v45 = v_u_6._ActiveUnits[p44]
            assert(v45, "No unit object!")
            v_u_13.HandleUpgradeDisplay(v45, v_u_21)
        end
    end)
    v_u_11.OnClientEvent:Connect(function(p46, p47)
        local v48 = v_u_6._ActiveUnits[p46]
        if not v48 then
            warn("UpdateUnitElements failed, unit not found!")
            return
        end
        local v49 = false
        for _, v50 in p47 do
            if typeof(v50) == "table" and v50.Name == "Position" then
                v49 = true
                local v51 = v50.Value
                v48.Position = v51
                if v48.CFrameValue then
                    local v52 = v48.CFrameValue
                    local v53 = CFrame.new(v51)
                    if not v48.Rotation then
                        ::l9::
                        v56 = CFrame.identity
                        goto l10
                    end
                    local v54 = CFrame.Angles
                    local v55 = v48.Rotation
                    local v56 = v54(0, math.rad(v55), 0)
                    if not v56 then
                        goto l9
                    end
                    ::l10::
                    v52.Value = v53 * v56
                end
            end
        end
        if not v49 then
            v48.Data.Elements = p47
            v_u_12.CreateElementFrames(v48, v_u_21)
        end
    end)
    v_u_17.KeybindsUpdated:Connect(function()
        if v_u_21 then
            v_u_21.Keybinds.Upgrade.Keybind.Label.Text = v_u_17.GetBind("Upgrade").Name
        end
    end)
end)
return v_u_19
game:GetService("Players")
local v1 = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
game:GetService("RunService")
require(v1.Modules.ClientReplicationHandler)
local v_u_2 = require(v1.Modules.Packages.FastSignal)
local v_u_3 = v1.Networking.ClientListeners.PassiveInfoEvent
local v4 = {}
local v_u_5 = {}
local function v_u_11(p6, p7, p8)
    local v9 = v_u_5[p6]
    if not v9 then
        local v10 = {
            ["Keys"] = {
                [p7] = p8 or 0
            },
            ["Listeners"] = {}
        }
        v_u_5[p6] = v10
        return v_u_5[p6]
    end
    if not v9.Keys[p7] then
        v9.Keys[p7] = p8 or 0
        return v9
    end
end
function v4.AwaitInitialization(p12)
    repeat
        task.wait(0.016666666666666666)
    until v_u_5[p12]
end
function v4.GetKeyData(p13, p14)
    local v15 = v_u_5[p13]
    if v15 then
        return v15.Keys[p14]
    end
end
function v4.GetDataChangedSignal(p16, p17)
    local v18 = v_u_5[p16]
    if v18 then
        local v19 = v18.Listeners
        if v19[p17] then
            return v19[p17]
        end
        v19[p17] = v_u_2.new()
        return v19[p17]
    end
end
task.spawn(function()
    v_u_3.OnClientEvent:Connect(function(p20, p21)
        if p20 == "Add" then
            v_u_11(table.unpack(p21))
        elseif p20 == "Remove" then
            local v22 = table.unpack(p21)
            local v23 = v_u_5[v22]
            if v23 then
                local v24 = v23.Listeners
                for _, v25 in v24 do
                    v25:Destroy()
                end
                table.clear(v24)
                v_u_5[v22] = nil
                return
            end
        elseif p20 == "Update" then
            local v26, v27, v28 = table.unpack(p21)
            local v29 = v_u_5[v26] or v_u_11(v26, v27)
            local v30 = v29.Keys
            local v31 = v29.Listeners
            if v30 and v30[v27] then
                local v32 = v31[v27]
                v30[v27] = v28
                if v32 then
                    v32:Fire(v28)
                end
            end
        end
    end)
end)
return v4
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("StarterPlayer")
local v_u_3 = v1.Networking.EnemyArmor
local v_u_4 = require(script.Parent.ClientEnemyHandler)
local v_u_5 = require(v2.Modules.Gameplay.SettingsHandler)
local v_u_6 = {
    [0] = Vector2.zero,
    [1] = Vector2.new(341, 0),
    [2] = Vector2.new(682, 0),
    [3] = Vector2.new(0, 341),
    [4] = Vector2.new(341, 341),
    [5] = Vector2.new(682, 341),
    [6] = Vector2.new(0, 682),
    [7] = Vector2.new(341, 682),
    [8] = Vector2.new(682, 682)
}
local v_u_7 = {}
local v_u_8 = true
local function v_u_13(p9, p10)
    local v11 = os.clock()
    local v12 = p9()
    while not v12 and os.clock() - v11 < p10 do
        task.wait()
        v12 = p9()
    end
    return v12
end
task.spawn(function()
    v_u_8 = not v_u_5:GetSetting("DisableEnemyTags")
    v_u_5.OnSettingUpdate:Connect(function(p14, p15)
        if p14 == "DisableEnemyTags" then
            v_u_8 = not p15
            for _, v16 in v_u_7 do
                if v16 and v16.Parent then
                    v16.Enabled = v_u_8
                end
            end
        end
    end)
    v_u_3.OnClientEvent:Connect(function(p17)
        for v18 = 0, buffer.len(p17) / 40 - 1 do
            local v19 = v18 * 40
            local v_u_20 = buffer.readu32(p17, v19)
            local v21 = v19 + 32
            local v_u_22 = buffer.readu8(p17, v21)
            task.spawn(function()
                local v_u_23 = v_u_13(function()
                    return v_u_4.GetEnemy(v_u_20)
                end, 5)
                if v_u_23 then
                    local v_u_24 = v_u_13(function()
                        return v_u_23.Model
                    end, 5)
                    if v_u_24 then
                        if v_u_13(function()
                            return v_u_24:IsDescendantOf(workspace) and v_u_24 or nil
                        end, 5) then
                            local v25 = v_u_24:FindFirstChild("ArmoredIcon")
                            if not v25 then
                                v25 = script.ArmoredIcon:Clone()
                                v25.Adornee = v_u_24
                                v25.Parent = v_u_24
                                v_u_7[v_u_20] = v25
                            end
                            if v_u_22 == 0 then
                                v25:Destroy()
                                v_u_7[v_u_20] = nil
                            else
                                v25.Armored.ImageRectOffset = v_u_6[v_u_22] or Vector2.zero
                                v25.Enabled = v_u_8
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    return
                end
            end)
        end
    end)
end)
return {}


Auto Start
local SkipEvent = ReplicatedStorage:WaitForChild("Networking", 5):WaitForChild("SkipWaveEvent", 5)
        if SkipEvent then
            SkipEvent:FireServer("Skip")

Vote
local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("Debris")
local v_u_5 = game:GetService("UserInputService")
local v_u_6 = game:GetService("RunService")
local v_u_7 = game:GetService("GuiService")
local v_u_8 = v1.LocalPlayer
local v_u_9 = v_u_8:WaitForChild("PlayerGui")
local v_u_10 = v2.Networking.SkipWaveEvent
local v_u_11 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_12 = nil
local v_u_13 = false
local v_u_14 = nil
local v_u_15 = nil
local function v_u_16()
    if v_u_15 then
        v_u_15:Disconnect()
        v_u_15 = nil
    end
end
local function v_u_28()
    if not v_u_15 then
        local v17 = v_u_7:GetGuiInset()
        local v18 = v_u_5:GetMouseLocation() - v17
        local v19 = v_u_12.Holder
        local v20 = v19.AbsoluteSize
        local v21 = v19.AbsolutePosition
        local v22 = v21 + v20 / 2
        local v_u_23 = v18.Y - v21.Y
        local v_u_24 = v18.X - v22.X
        v_u_15 = v_u_6.Heartbeat:Connect(function()
            if not v_u_12 then
                return v_u_16()
            end
            local v25 = v_u_5:GetMouseLocation()
            local v26 = v_u_12.Holder
            local v27 = UDim2.fromOffset(v25.X - v_u_24, v25.Y - v_u_23)
            v26.Position = v26.Position:Lerp(v27, 0.3)
            v_u_14 = v27
        end)
    end
end
v_u_5.InputEnded:Connect(function(p29)
    if (p29.UserInputType == Enum.UserInputType.MouseButton1 or p29.UserInputType == Enum.UserInputType.Touch) and v_u_15 then
        v_u_15:Disconnect()
        v_u_15 = nil
    end
end)
local function v_u_30()
    if v_u_12 then
        v_u_3:Create(v_u_12.Holder, v_u_11, {
            ["Position"] = v_u_12.Holder.Position + UDim2.fromScale(0, -0.5)
        }):Play()
        v_u_4:AddItem(v_u_12, v_u_11.Time)
        v_u_12 = nil
    end
end
local function v_u_49(p31)
    if v_u_8:GetAttribute("Loading") then
        v_u_8:GetAttributeChangedSignal("Loading"):Wait()
    end
    if not v_u_12 and v_u_13 then
        local v32 = p31.StartTime
        local v33 = p31.SkippedPlayers
        local v34 = p31.MaxPlayers
        local v35 = p31.Context
        local v_u_36 = script.SkipWave:Clone()
        local v37 = v_u_36.Holder
        if v_u_14 then
            v37.Position = v_u_14
        end
        local v38 = v37.PlayersVoted
        local v_u_39 = v37.Timer
        local v40 = v37.Position
        v38.Text = ("%*/%*"):format(v33, v34)
        v37.Position = v37.Position + UDim2.fromScale(0, -0.07)
        v_u_36.Parent = v_u_9
        v_u_12 = v_u_36
        if v35 and v35 == "Skip" then
            v37.Description.Text = "Vote skip:"
        end
        v_u_3:Create(v37, v_u_11, {
            ["Position"] = v40
        }):Play()
        local v41 = workspace:GetServerTimeNow() - v32
        local v42 = (v35 == "Skip" and 30 or 60) - v41
        local v_u_43 = math.ceil(v42)
        local function v_u_45(p44)
            v_u_39.Text = ("Time Left: %*"):format(p44)
        end
        task.spawn(function()
            for v46 = v_u_43, 1, -1 do
                if not v_u_36.Parent then
                    break
                end
                v_u_45(v46)
                task.wait(1)
            end
        end)
        v37.Yes.Button.Activated:Connect(function()
            v_u_10:FireServer("Skip")
        end)
        local v_u_48 = v_u_5.InputBegan:Connect(function(p47)
            if p47.KeyCode == Enum.KeyCode.ButtonL2 then
                v_u_10:FireServer("Skip")
            end
        end)
        v37.Destroying:Once(function()
            v_u_48:Disconnect()
        end)
        v37.DragButton.MouseButton1Down:Connect(v_u_28)
    end
end
task.spawn(function()
    v_u_10:FireServer("Loaded")
    v_u_10.OnClientEvent:Connect(function(p50, p51)
        if p50 == "Show" then
            v_u_13 = true
            v_u_49(p51)
            return
        elseif p50 == "Update" then
            if v_u_12 then
                local v52 = p51.SkippedPlayers
                local v53 = p51.MaxPlayers
                v_u_12.Holder.PlayersVoted.Text = ("%*/%*"):format(v52, v53)
            end
        else
            if p50 == "Close" then
                v_u_13 = false
                v_u_30()
            end
            return
        end
    end)
end)
return {}

Yen
local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("StarterPlayer")
local v_u_4 = game:GetService("TweenService")
game:GetService("Debris")
local v_u_5 = game:GetService("CollectionService")
local v6 = v1.LocalPlayer:WaitForChild("PlayerGui")
v6:WaitForChild("HUD")
local v_u_7 = v6:WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Yen")
local v_u_8 = require(v2.Modules.Packages.BoatTween)
local v_u_9 = require(v3.Modules.Gameplay.PlayerYenHandler)
local v_u_10 = TweenInfo.new(0.165, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_11 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_12 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local _ = v2.Networking
local v_u_13 = {}
local v_u_14 = Instance.new("IntValue")
v_u_14.Value = 0
function v_u_13.NotEnoughYenAnimation()
    local v15 = v_u_8
    local v16 = v_u_7.UIGradient
    local v17 = {
        ["Time"] = 0.115,
        ["EasingStyle"] = "EntranceExpressive",
        ["EasingDirection"] = "Out",
        ["StepType"] = "Heartbeat",
        ["Goal"] = {
            ["Color"] = v_u_7.NotEnoughYen.Color
        }
    }
    v15:Create(v16, v17):Play()
    task.delay(0.115, function()
        local v18 = v_u_8
        local v19 = v_u_7.UIGradient
        local v20 = {
            ["Time"] = 0.115,
            ["EasingStyle"] = "EntranceExpressive",
            ["EasingDirection"] = "Out",
            ["StepType"] = "Heartbeat",
            ["Goal"] = {
                ["Color"] = v_u_7.GoldGradient.Color
            }
        }
        v18:Create(v19, v20):Play()
    end)
end
function v_u_13.UpdateYenText(p21)
    v_u_7.Text = p21
    local v22 = next
    local v23, v24 = v_u_5:GetTagged("YenDisplay")
    for _, v25 in v22, v23, v24 do
        v25.Text = p21
    end
end
task.spawn(function()
    local v_u_26 = v_u_7.Size
    v_u_9.OnYenChanged:Connect(function(p27)
        v_u_4:Create(v_u_14, v_u_10, {
            ["Value"] = p27
        }):Play()
    end)
    local v28 = v_u_13.UpdateYenText
    local v29 = v_u_14.Value
    v28((("%*\194\165"):format((tostring(v29):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")))))
    v_u_14.Changed:Connect(function(p30)
        v_u_13.UpdateYenText((("%*\194\165"):format((tostring(p30):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")))))
        task.defer(function()
            v_u_4:Create(v_u_7, v_u_11, {
                ["Size"] = UDim2.fromScale(v_u_26.X.Scale * 1.15, v_u_26.Y.Scale * 1.15)
            }):Play()
            task.wait(0.11)
            v_u_4:Create(v_u_7, v_u_12, {
                ["Size"] = v_u_26
            }):Play()
        end)
    end)
end)
return v_u_13

Wave
local v_u_1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("StarterPlayer")
local v_u_4 = game:GetService("TweenService")
local v_u_5 = game:GetService("TextService")
local v_u_6 = require(v2.Modules.Gameplay.GameHandler)
local v_u_7 = require(v3.Modules.Interface.Loader.HUD.BossHealth)
local v_u_8 = require(v2.Modules.Data.StagesData)
local v_u_9 = v2.Networking.InterfaceEvent
local v_u_10 = {
    ["CurrentWave"] = 1
}
local function v_u_14(p11, p12)
    local v13 = v_u_5:GetTextSize(p12, p11.TextSize, p11.Font, Vector2.new(9000000000, p11.Size.Y.Offset)).X
    return UDim2.new(p11.Size.X.Scale, v13, p11.Size.Y.Scale, p11.Size.Y.Offset)
end
local function v_u_19()
    if not v_u_6.IsGameLoaded then
        v_u_6.GameLoaded:Wait()
    end
    local v15 = v_u_6.GameData
    local v16 = v_u_8:GetCurrentAct(v15)
    assert(v16, "No act data for some reason?")
    if v15.PortalData then
        return 20
    end
    if v15.StageType == "Rift" then
        return 20
    end
    if v15.StageType == "ElementalTowers" then
        return 20
    end
    local v17 = v16.TotalWaves
    if v17 then
        return v17 >= 999 and "\226\136\158" or v17
    end
    local v18 = v16.WaveData
    assert(v18, "No wave data? why?")
    return #v18
end
task.spawn(function()
    local v20 = v_u_1.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Map")
    local v_u_21 = v20.Timer
    v20:WaitForChild("Waves")
    local v_u_22 = v20:WaitForChild("WavesAmount")
    v_u_22.TextWrapped = false
    v_u_9:FireServer("SetWave")
    v_u_9.OnClientEvent:Connect(function(p23, p24)
        if p23 == "Wave" then
            if p24.Waves == 0 then
                v_u_7:RemoveAllBars()
            end
            local v25 = v_u_19()
            local v26 = p24.Waves
            local v27 = tostring(v25)
            local v28 = string.format("<stroke color=\"#000000\" thickness=\"2\" transparency=\"0.0\"><font transparency=\"0\">%d</font></stroke><stroke color=\"#000000\" thickness=\"2\" transparency=\"0.45\"><font transparency=\"0.45\">/%s</font></stroke>", v26, v27)
            v_u_22.Text = v28
            v_u_10.CurrentWave = p24.Waves
            v_u_22.Size = v_u_14(v_u_22, v28)
            v_u_22.TextColor3 = Color3.fromRGB(235, 65, 67)
            task.spawn(function()
                v_u_4:Create(v_u_22, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    ["TextColor3"] = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)
        elseif p23 == "Timer" then
            local v_u_29 = os.clock()
            v_u_21.Visible = true
            task.defer(function()
                while os.clock() - v_u_29 < 5 do
                    local v30 = os.clock() - v_u_29
                    v_u_21.Text = 5 - math.floor(v30)
                    v_u_21.TextColor3 = Color3.fromRGB(235, 65, 67)
                    task.spawn(function()
                        v_u_4:Create(v_u_21, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ["Size"] = UDim2.fromScale(0.05, 0.465)
                        }):Play()
                        task.wait(0.095)
                        v_u_4:Create(v_u_21, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            ["Size"] = UDim2.fromScale(0.05, 0.342),
                            ["TextColor3"] = Color3.fromRGB(255, 255, 255)
                        }):Play()
                    end)
                    task.wait(1)
                end
                v_u_21.Visible = false
            end)
        end
    end)
end)
return v_u_10

Units
local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("Debris")
local v6 = game:GetService("GuiService")
local v_u_7 = game:GetService("UserInputService")
local v8 = game:GetService("StarterPlayer")
local v_u_9 = v1.LocalPlayer
local v10 = v_u_9:WaitForChild("PlayerGui")
v10:WaitForChild("HoverFrames", 30)
local v11 = v10:WaitForChild("Hotbar", 30)
v10:WaitForChild("HUD", 30)
local v_u_12 = v11:WaitForChild("Main", 30):WaitForChild("Units", 30)
local v_u_13 = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local function v14(...) end
v14("loaded 1")
local v_u_15 = require(v2.Modules.Data.TraitsData)
local v_u_16 = require(v2.Modules.Data.Entities.Units)
local v_u_17 = require(v2.Modules.Data.UnitGroupData)
require(v2.Modules.Data.RarityColors)
local v_u_18 = require(v2.Modules.Data.GlobalMatchSettings)
v14("loaded 2")
require(v2.Modules.UnitCollisionHandler)
require(v2.Modules.Shared.MultiplierHandler)
require(v2.Modules.Shared.ModelCacheHandler)
v14("loaded 3")
local v_u_19 = require(v8.Modules.Gameplay.PlayerYenHandler)
local v_u_20 = require(v2.Modules.Interface.CreateUnitTemplate)
require(v2.Modules.Utilities.NumberUtils)
local v_u_21 = require(v2.Modules.Interface.InterfaceUtils)
require(v2.Modules.Utilities.TableUtils)
local v_u_22 = require(v2.Modules.Shared.SoundHandler)
local v_u_23 = require(v8.Modules.Gameplay.Units.ClientUnitHandler.Events)
local v_u_24 = require(v8.Modules.Gameplay.Units.ClientUnitHandler.Callbacks)
require(v2.Modules.Visuals.TraitEffects)
local v25 = require(v2.Modules.Packages.FastSignal.Deferred)
local v_u_26 = require(v8.Modules.Interface.Loader.Utilities.Flipbook)
local v_u_27 = require(v8.Modules.Interface.Loader.Notifications)
require(v8.Modules.Visuals.ButtonClickEffects)
local v_u_28 = require(v8.Modules.Miscellaneous.UnitInfoHoverHandler)
local v_u_29 = require(v8.Modules.Miscellaneous.HoverHandler)
v14("loaded 4")
local v30 = v2.Networking
local v_u_31 = v30.RequestUnitEvent
local _ = v30.Units.EquipEvent
local v_u_32 = v30.UnitEvent
local v_u_33 = v30.ClientListeners.UnitHotbarEvent
local v_u_34 = TweenInfo.new(0.425, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true, 0.1)
TweenInfo.new(0.275, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_35 = TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
CFrame.new(-36.7856674, 6.11902905, -49.4699669, -0.998965502, -0.00142396393, 0.0454521887, -1.16415308e-10, 0.999509633, 0.0313134678, -0.0454744846, 0.0312810726, -0.998475671)
v6:GetGuiInset()
local v_u_36 = {
    ["_Cache"] = {},
    ["FrameData"] = {},
    ["PlacedUnits"] = {},
    ["CurrentPreview"] = nil,
    ["FlickerEffects"] = {
        ["NumberValue"] = nil,
        ["ActiveTween"] = nil
    },
    ["UnitHotbarChanged"] = v25.new(),
    ["UnitsLoaded"] = v25.new()
}
local function v_u_43(p37)
    local v_u_38 = p37.UnitTemplate.Holder:FindFirstChildOfClass("UIGradient")
    local v39 = Instance.new("NumberValue")
    v39.Value = 0
    local v40 = v_u_3:Create(v39, v_u_34, {
        ["Value"] = 1
    })
    v40:Play()
    v_u_36.FlickerEffects.NumberValue = v39
    v_u_36.FlickerEffects.ActiveTween = v40
    v39.Changed:Connect(function(p41)
        v_u_38.Transparency = NumberSequence.new(p41)
    end)
    local v42 = script.Stroke:Clone()
    v42.Size = UDim2.fromScale(1.01, 1.01)
    v42.UIStroke.Thickness = 1.75
    v42.Parent = p37
end
local function v_u_47(p44)
    local v45 = p44.UnitTemplate.Holder:FindFirstChildOfClass("UIGradient")
    if v_u_36.FlickerEffects.ActiveTween then
        v_u_36.FlickerEffects.ActiveTween:Pause()
        v_u_36.FlickerEffects.ActiveTween = nil
    end
    if v_u_36.FlickerEffects.NumberValue then
        v_u_36.FlickerEffects.NumberValue:Destroy()
        v_u_36.FlickerEffects.NumberValue = nil
    end
    if v45 then
        v45.Transparency = NumberSequence.new(0)
    end
    local v46 = p44:FindFirstChild("Stroke")
    if v46 then
        v_u_3:Create(v46.UIStroke, v_u_35, {
            ["Transparency"] = 1
        }):Play()
        v_u_5:AddItem(v46, 0.125)
    end
end
local v_u_48 = {}
local v_u_49 = {}
local v_u_50 = {}
local v_u_51 = TweenInfo.new(0.285, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v_u_52 = {}
local function v_u_62()
    for v53 = 1, 6 do
        local v54 = v_u_12:FindFirstChild(v53)
        local v55 = v_u_36._Cache[v53]
        if v55 ~= "None" and v55 ~= nil then
            local v56 = v55.UniqueIdentifier
            local v57 = v55.Data or print("No data for", v55)
            local _ = v57.Price
            local v58 = v_u_52[v56]
            local v59 = v57.UnitType == "Farm" and v_u_18:GetSettings().FarmPlacementException and true or v_u_18.CanUseElement(v57.Elements)
            if v59 then
                v59 = v_u_19:CanAffordUnit(v57)
            end
            if v59 and v58 then
                v58:Destroy()
                v_u_52[v56] = nil
                local v60 = script.FlashFrame:Clone()
                v60.BackgroundTransparency = 0.5
                v60.ZIndex = 9999
                v60.Parent = v54
                v_u_3:Create(v60, v_u_51, {
                    ["BackgroundTransparency"] = 1
                }):Play()
            elseif not (v59 or v58) then
                local v61 = script.Overlay:Clone()
                v61.ZIndex = 999
                v61.Parent = v54
                v_u_52[v56] = v61
            end
        end
    end
end
local v_u_63 = nil
local v_u_64 = nil
local function v_u_72()
    for _, v_u_65 in v_u_12:GetChildren() do
        if v_u_65:IsA("Frame") then
            local function v70()
                local v66 = v_u_65.Name
                local v67 = tonumber(v66)
                local v68 = v_u_36._Cache[v67]
                if v68 == nil or v68 == "None" then
                    return
                else
                    local v69 = v_u_16:GetUnitDataFromID(v68.Identifier)
                    if v69 then
                        local _ = v69.Rarity
                    end
                    if v69 then
                        v_u_28.CreateHoverFrame(v_u_65, v68)
                        v_u_63 = v_u_65
                    end
                end
            end
            local function v71()
                v_u_28.Destroy(v_u_65, true)
                v_u_63 = nil
            end
            v_u_65.MouseEnter:Connect(v70)
            v_u_65.SelectionGained:Connect(v70)
            v_u_65.MouseLeave:Connect(v71)
            v_u_65.SelectionLost:Connect(v71)
        end
    end
end
local v_u_73 = TweenInfo.new(0.135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function v_u_78(p74)
    local v_u_75 = p74.Holder.Main.UnitImage
    local v_u_76 = UDim2.fromScale(v_u_75.Size.X.Scale * 1.09, v_u_75.Size.Y.Scale * 1.09)
    local v_u_77 = v_u_75.Size
    p74.MouseEnter:Connect(function()
        v_u_3:Create(v_u_75, v_u_73, {
            ["Size"] = v_u_76
        }):Play()
    end)
    p74.SelectionGained:Connect(function()
        v_u_3:Create(v_u_75, v_u_73, {
            ["Size"] = v_u_76
        }):Play()
    end)
    p74.MouseLeave:Connect(function()
        v_u_3:Create(v_u_75, v_u_73, {
            ["Size"] = v_u_77
        }):Play()
    end)
    p74.SelectionLost:Connect(function()
        v_u_3:Create(v_u_75, v_u_73, {
            ["Size"] = v_u_77
        }):Play()
    end)
end
local v_u_79 = {}
local function v_u_101(p80, p81)
    p81 = p81
    if p81 then
        local v82 = p81.UniqueIdentifier
    end
    p81 = p81
    local v83
    if p81 then
        v83 = p81.Identifier
    else
        v83 = p81
    end
    local v84 = v_u_12[tostring(p80)]
    local v85 = v84:FindFirstChild("UnitTemplate")
    if v85 then
        v85:Destroy()
    end
    local v_u_86 = p81 or "None"
    if v_u_86 == "None" then
        v_u_36.FrameData[p80] = nil
    else
        local v_u_87 = v_u_16:GetUnitDataFromID(v83).Name
        local v88 = v_u_18:GetSettings().TraitsEnabled and (v_u_86.Trait or "None") or "None"
        local v89 = v_u_86.Shiny
        local v90 = v_u_20
        local v91 = {}
        local v92 = {
            ["Name"] = v_u_87,
            ["Level"] = v_u_86.Level
        }
        local v93
        if (v88 or "None") == "None" then
            v93 = nil
        else
            v93 = v88.Name or nil
        end
        v92.Trait = v93
        v92.Skin = v_u_86.Skin
        v92.Shiny = v89
        v92.SerialID = v_u_86.SerialID
        v92.UnitObject = v_u_86
        v91.UnitData = v92
        v91.FrameData = {
            ["Size"] = UDim2.fromScale(1, 1),
            ["Parent"] = v84
        }
        v91.ExtraData = {
            ["ShowPrice"] = true,
            ["IncludeButton"] = false
        }
        local v94 = v90:Create(v91)
        v94.Name = "UnitTemplate"
        v_u_78(v94)
        local v100 = {
            ["Identifier"] = v82,
            ["Frame"] = v94,
            ["Name"] = v_u_87,
            ["Unit"] = v_u_86,
            ["GetMaxPlacements"] = function()
                local v95 = v_u_86
                local v96 = v_u_87
                local v97 = v_u_18.GetUnitTrait(v96 or v95.Name)
                local v98 = nil
                if typeof(v97) ~= "table" then
                    v97 = v97 and {
                        ["Name"] = v97,
                        ["Index"] = nil
                    } or v98
                end
                local v99 = v97 or v95.Trait
                return v99 ~= "None" and v99.Name == "Monarch" and 1 or (v_u_17.GetUnitGroupBuffs(v_u_87, "MaxPlacements") or v_u_18.GetUnitPlacementCap(v_u_87, v_u_9))
            end
        }
        v_u_36.FrameData[p80] = v100
        v_u_36.UnitHotbarChanged:Fire()
        v_u_79[v82] = v94
    end
end
function v_u_36.LoadUnits(_, p102)
    for _, v103 in v_u_12:GetChildren() do
        local v104 = v103:FindFirstChild("UnitTemplate")
        if v104 then
            v104.Parent = nil
            v104:Destroy()
        end
    end
    for v105 = 1, 6 do
        v_u_101(v105, v_u_36._Cache[p102[v105]] or p102[v105])
    end
end
local v_u_106 = {}
local function v_u_110(p107)
    for _, v108 in v_u_12:GetChildren() do
        if v108:FindFirstChild("UnitTemplate") then
            if v108:IsA("Frame") then
                if not v_u_106[v108] then
                    if v108 ~= p107 then
                        local v109 = script.SelectionOverlay:Clone()
                        v109.Parent = v108
                        v_u_106[v108] = v109
                    end
                end
            end
        end
    end
end
function v_u_36.Update(_, p111)
    local v112 = v_u_36.FrameData[p111]
    local v113 = v_u_12[tostring(p111)]
    if v113:FindFirstChild("UnitTemplate") then
        local v114 = v113.UnitTemplate.Holder.Main
        local v115 = v_u_36.PlacedUnits[v112.Name]
        local v116 = v115 and #v_u_36.PlacedUnits[v112.Name] or v115
        if v112 then
            v112 = v112.GetMaxPlacements()
        end
        local v117 = v114.MaxPlacement
        v117.Text = ("%*/%*"):format(v116 or 0, v112)
        if v116 and v112 <= v116 then
            v117.TextColor3 = Color3.fromRGB(226, 36, 39)
        else
            v117.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        return
    end
end
function v_u_36.UpdateAll(_)
    v_u_36:Update(1)
    v_u_36:Update(2)
    v_u_36:Update(3)
    v_u_36:Update(4)
    v_u_36:Update(5)
    v_u_36:Update(6)
end
function v_u_36.Select(_, p_u_118)
    v_u_36:DeselectAll()
    if v_u_36._Cache[p_u_118] and v_u_36._Cache[p_u_118] ~= "None" then
        if table.find(v_u_50, p_u_118) then
            return v_u_27:CreateNotification({
                ["Name"] = "Failure",
                ["Text"] = "Please wait before selecting this unit again!"
            })
        else
            local v119 = v_u_12:FindFirstChild((tostring(p_u_118)))
            if v119:FindFirstChild("UnitTemplate") then
                local v120 = v119.UnitTemplate.Holder.Main
                local v121 = v120.UnitImage
                local v_u_122 = v119:FindFirstChildOfClass("UIScale")
                local v123 = v_u_36.FrameData[p_u_118]
                local _ = v_u_16:GetUnitDataFromID(v_u_36._Cache[p_u_118].Identifier).Rarity
                if v_u_36.PlacedUnits[v123.Name] then
                    local _ = #v_u_36.PlacedUnits[v123.Name]
                end
                if v123 then
                    v123.GetMaxPlacements()
                end
                local v124 = v120.MaxPlacement
                local v125 = v_u_36._Cache[p_u_118]
                if v125 and v_u_7:GetLastInputType() ~= Enum.UserInputType.Touch then
                    v_u_28.CreateHoverFrame(v119, v125, true)
                    v_u_64 = v119
                end
                local v126 = v120.LevelFrame.Level
                local v127 = v120.LevelFrame.LevelText
                v_u_43(v119)
                v126.Visible = false
                v127.Visible = false
                local v128 = script.SelectionFrame:Clone()
                v128.BackgroundTransparency = 1
                v128.Parent = v120
                v_u_3:Create(v128, v_u_34, {
                    ["BackgroundTransparency"] = 0.4
                }):Play()
                v124.Visible = true
                v_u_36:Update(p_u_118)
                v_u_3:Create(v121, v_u_73, {
                    ["Size"] = UDim2.fromScale(v121.Size.X.Scale * 1.158125, v121.Size.Y.Scale * 1.158125)
                }):Play()
                if v120 then
                    task.spawn(function()
                        v_u_3:Create(v_u_122, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ["Scale"] = 0.7
                        }):Play()
                        task.wait(0.09)
                        v_u_3:Create(v_u_122, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            ["Scale"] = 1.1
                        }):Play()
                    end)
                end
                v_u_110(v119)
                v_u_22:PlayLocalSound({ "General", "Miscellaneous" }, "ButtonPress", {
                    ["Destroy"] = true
                })
                local v129 = v_u_50
                table.insert(v129, p_u_118)
                task.delay(0.25, function()
                    local v130 = table.find(v_u_50, p_u_118)
                    table.remove(v_u_50, v130)
                end)
            end
        end
    else
        return
    end
end
function v_u_36.DeselectAll(_)
    if v_u_63 then
        v_u_28.Destroy(v_u_63)
        v_u_63 = nil
    end
    if v_u_64 then
        v_u_28.Destroy(v_u_64)
        v_u_64 = nil
    end
    for _, v131 in v_u_48 do
        v131:Destroy()
    end
    table.clear(v_u_48)
    table.clear(v_u_49)
    for _, v132 in v_u_106 do
        v132:Destroy()
    end
    table.clear(v_u_106)
    for v133 = 1, 6 do
        local v134 = v_u_12:FindFirstChild(v133)
        local v135 = v134:FindFirstChild("UnitTemplate")
        if v135 then
            local v136 = v135.Holder.Main
            local v137 = v136.UnitImage
            if v136 then
                v_u_47(v134)
                local v138 = v136.MaxPlacement
                local v139 = v136.LevelFrame.Level
                local v140 = v136.LevelFrame.LevelText
                if v_u_36._Cache[v133] ~= "None" then
                    v139.Visible = true
                    v140.Visible = true
                end
                if v138 then
                    v138.Visible = false
                end
                v_u_3:Create(v137, v_u_73, {
                    ["Size"] = UDim2.fromScale(1.16, 1.15)
                }):Play()
                local v141 = v136:FindFirstChild("SelectionFrame")
                if v136 and v141 then
                    v_u_3:Create(v141, v_u_13, {
                        ["BackgroundTransparency"] = 1
                    }):Play()
                    v_u_5:AddItem(v141, v_u_13.Time)
                end
            end
        end
    end
end
local function v_u_149(p142)
    local v143 = p142[1]
    local v144 = p142[2]
    for _, v145 in v_u_36.FrameData do
        if v145.Identifier == v143 then
            local v146 = v145.Frame
            v_u_20:UpdateUnitLevel(v146, v144)
            local v147 = script.Ring:Clone()
            v147.Parent = v146
            v_u_26:PlayFlipbook({
                ["ImageLabel"] = v147,
                ["Framerate"] = 30,
                ["TileResolution"] = Vector2.new(256, 256)
            })
        end
    end
    for _, v148 in v_u_36._Cache do
        if v148.UniqueIdentifier == v143 then
            v148.Level = v144
        end
    end
end
local function v_u_154(p150)
    for _, v151 in p150 do
        if v151 and v151 ~= "None" then
            local v152 = v151.Identifier
            local v153 = v_u_16:GetUnitDataFromID(v152)
            if v153 then
                v151.Data = v153
            else
                warn("no unit data", v152)
            end
        end
    end
end
local function v_u_168(p155, p156, p157)
    local v158 = v_u_79[p155.Identifier]
    if v158 then
        local v159 = p156.Name
        local v160 = p156.Rarity
        local v161 = p155.Unit
        local v162 = v158:FindFirstChild("TraitIcon")
        if p157 == nil then
            p157 = not v161.Trait and "None" or v161.Trait.Name
        end
        if v162 then
            v162:Destroy()
        end
        if p157 ~= "None" then
            local v163
            if typeof(p157) == "table" then
                v163 = typeof(p157) == "string" and p157 and p157 or ("%* %*"):format(p157.Name, (string.rep("I", p157.Index)))
            else
                v163 = typeof(p157) == "string" and p157 and p157 or p157.Name
            end
            local v164 = v_u_20.GetTraitIcon(p157)
            v164.Parent = v158
            local v165, v166 = v_u_15.FormatBuff(p157)
            v_u_29.CreateHoverFrame(v164, {
                ["HeaderColor"] = v164:FindFirstChildOfClass("UIGradient"),
                ["Header"] = v163,
                ["Description"] = v165,
                ["RawDescription"] = v166
            })
            if v160 == "Vanguard" then
                local v167 = v_u_21.GetRarityGradient(v159) or v_u_21.GetRarityGradient(v160)
                v_u_21.ApplyGradient(v164, v167)
            end
        end
    end
end
task.spawn(function()
    v_u_31:FireServer()
    local v_u_169 = nil
    v_u_4.Heartbeat:Connect(function()
        if v_u_169 then
            local v170 = v_u_169
            v_u_169 = nil
            table.clear(v_u_36._Cache)
            table.clear(v_u_36.PlacedUnits)
            table.clear(v_u_36.FrameData)
            v_u_36._Cache = v170
            v_u_154(v170)
            v_u_36:LoadUnits(v170)
            v_u_36.UnitsLoaded:Fire(v_u_36._Cache)
            for _, v171 in v_u_52 do
                v171:Destroy()
            end
            table.clear(v_u_52)
            v_u_62()
        end
    end)
    v_u_31.OnClientEvent:Connect(function(p172, p173, p174)
        if p172 == "ReplicateUnits" then
            v_u_169 = p173
        elseif p172 == "ReplicateOneUnit" then
            p174.Data = v_u_16:GetUnitDataFromID(p174.Identifier)
            v_u_36._Cache[p173] = p174
            v_u_101(p173, p174)
        end
    end)
    v_u_32.OnClientEvent:Connect(function(p175, p176)
        if p175 == "ReplicatePlacedUnits" then
            v_u_36.PlacedUnits = p176
        end
    end)
    v_u_33.OnClientEvent:Connect(function(p177, p178)
        if p177 == "UpdateLevel" then
            v_u_149(p178)
        elseif p177 == "UpdatePotential" then
            for _, v179 in p178 do
                local v180 = v179[1]
                local v181 = v179[2]
                local v182 = v179[3]
                for _, v183 in v_u_36._Cache do
                    if v183.UniqueIdentifier == v180 then
                        v183.Takedowns = v181
                        v183.Worthiness = v182
                    end
                end
            end
        end
    end)
    v_u_19.OnYenChanged:Connect(function()
        v_u_62()
    end)
    v_u_18.SettingsUpdated:Connect(function()
        local v184 = v_u_18:GetSettings()
        for _, v185 in v_u_36.FrameData do
            local v186 = v185.Frame:FindFirstChild("TraitIcon")
            if v186 then
                v186.Visible = v184.TraitsEnabled
            end
        end
        for v187, v188 in v_u_36.FrameData do
            local v189 = v188.Frame
            local v190 = v188.Unit
            if v189 then
                local v191 = v_u_16:GetUnitDataFromID(v190.Identifier)
                local v192 = v_u_18.GetUnitTrait(v191.Name)
                if v192 then
                    v_u_168(v188, v191, v192)
                end
                local v193 = v_u_20
                local v194 = v191.Name
                local v195 = v191.Price
                v193:UpdatePrice(v189, v_u_18.GetUpgradePriceMultiplier(v194) * v195)
            else
                v_u_36.FrameData[v187] = nil
            end
        end
        v_u_62()
    end)
    v_u_23.UnitPriceOverrideChanged:Connect(function()
        v_u_62()
        for _, v196 in v_u_36.FrameData do
            local v197 = v196.Frame
            local v198 = v196.Unit
            if v197 then
                local v199 = v_u_16:GetUnitDataFromID(v198.Identifier)
                local v200 = v199.Name
                local v201 = v_u_24.GetUnitPriceOverride(v200)
                local v202 = v199.Price
                v_u_20:UpdatePrice(v197, v201 or v_u_18.GetUpgradePriceMultiplier(v200) * v202)
            end
        end
    end)
    v_u_72()
    v_u_62()
    v_u_23.OnUnitPlaced:Connect(function(p203, _)
        if p203 == v_u_9 then
            v_u_36:UpdateAll()
        end
    end)
    v_u_32.OnClientEvent:Connect(function()
        v_u_36:UpdateAll()
    end)
end)
return v_u_36


Enemy
game:GetService("ReplicatedStorage")
local v1 = game:GetService("StarterPlayer")
local v_u_2 = game:GetService("Players")
local v_u_3 = game:GetService("Debris")
local v_u_4 = game:GetService("RunService")
local v5 = game:GetService("ReplicatedStorage")
local v6 = v5.Modules
local v_u_7 = require(v6.Data.Entities.Enemies)
local v_u_8 = require(v6.Data.EnemyDiameterData)
local v_u_9 = require(v6.Shared.EffectsHandler)
local v_u_10 = require(v6.Shared.AnimationHandler)
local v_u_11 = require(v6.Shared.SoundHandler)
local v_u_12 = require(v6.Shared.EnemyPathHandler)
local v13 = require(v5.Modules.Shared.DebugToggleHandler)
local v_u_14 = v13.CreateDebugPrint("clientEnemy")
local v_u_15 = require(v5.Modules.Gameplay.GameHandler)
local v_u_16 = require(v5.Modules.Shared.CollisionHandler)
local v_u_17 = require(v1.Modules.Gameplay.Units.ClientUnitHandler.Callbacks)
local v_u_18 = require(v1.Modules.Gameplay.Enemies.EnemyNetworkingHandler)
local v_u_19 = require(v6.Debug.Gizmo)
local v_u_20 = v1.Modules.Gameplay.ClientTransformHandler
local v_u_21 = require(v6.Utilities.TableUtils)
require(v6.Utilities.SerDesUtils)
local v_u_22 = require(script.EnemyEffectsHandler)
local v_u_23 = require(script.ShieldHandler)
local v24 = require(script.Events)
local v_u_25 = require(v1.Modules.Interface.Loader.HUD.BossHealth)
local v_u_26 = require(v1.Modules.Gameplay.ClientEnemyGuiHandler)
require(script.Types)
local v_u_27 = require(v5.Modules.Data.Units.HorsegirlRacingData)
local v_u_28 = v5.Networking
local v_u_29 = require(script.ActiveEnemies)
local v_u_30 = {
    ["_ActiveEnemies"] = v_u_29,
    ["AlreadyDeadEnemies"] = {},
    ["_EnemyShields"] = {},
    ["ENEMY_PRIORITY_DEBUG"] = false,
    ["DEBUG_IGNORE_UPDATE"] = false,
    ["EnemySpawned"] = v24.EnemySpawned,
    ["EnemyDespawned"] = v24.EnemyDespawned,
    ["EnemyModelChanged"] = v24.EnemyModelChanged,
    ["EnemyHealthChanged"] = v24.EnemyHealthChanged
}
v13.Bind("enemyPositions", function(p31)
    v_u_30.ENEMY_HITBOX_DEBUG = p31
end)
local v_u_32 = v_u_18.DecodeVLQ
local v_u_33 = {}
for _, v34 in script.OnSpawnedCallbacks:GetChildren() do
    v_u_33[v34.Name] = require(v34)
end
local v_u_35 = {}
function v_u_30.GetSortedEnemies(p36)
    return v_u_35[p36] or {}
end
local v_u_37 = {}
function v_u_30.HideEnemyModel(_, p_u_38)
    local v_u_39 = v_u_37[p_u_38]
    local v_u_40 = false
    if v_u_39 then
        v_u_39.HiddenCount = v_u_39.HiddenCount + 1
    elseif not v_u_39 then
        v_u_39 = {
            ["HiddenCount"] = 1,
            ["TransparencyValues"] = {}
        }
        for _, v41 in p_u_38:GetDescendants() do
            if v41:IsA("BasePart") or v41:IsA("Decal") then
                v41.LocalTransparencyModifier = 1
            end
        end
    end
    return function()
        if not v_u_40 then
            v_u_40 = true
            local v42 = v_u_39
            v42.HiddenCount = v42.HiddenCount - 1
            if v_u_39.HiddenCount == 0 then
                for _, v43 in p_u_38:GetDescendants() do
                    if v43:IsA("BasePart") or v43:IsA("Decal") then
                        v43.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end
end
function v_u_30.Init()
    if not v_u_12.IsLoaded then
        v_u_12.Loaded:Wait()
    end
    v_u_28.ClientListeners.Enemies.EnemySpawn.OnClientEvent:Connect(function(p44, p45)
        local function v47(p46)
            if not v_u_30.AlreadyDeadEnemies[p46] then
                return false
            end
            v_u_30.AlreadyDeadEnemies[p46] = nil
            return true
        end
        for _, v48 in p45 do
            local v49, v50 = v_u_18.ReadEnemySpawnData(p44, v48, v47)
            if v49 then
                task.spawn(v_u_30.SpawnEnemy, v49, v50)
            end
        end
    end)
    v_u_28.ClientListeners.Enemies.RemoveEnemy.OnClientEvent:Connect(function(p51)
        local v52 = buffer.readu16(p51, 0)
        v_u_30.RemoveEnemy(v52)
    end)
    v_u_28.ClientListeners.Enemies.RemoveAllEnemies.OnClientEvent:Connect(function()
        v_u_30.RemoveAllEnemies()
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemySpeed.OnClientEvent:Connect(function(p53, p54)
        local v55 = {
            ["Value"] = 0
        }
        while v55.Value < buffer.len(p54) do
            v_u_32(p54, v55)
            local _ = v55.Value
            local v56, v57 = v_u_18.ReadSpeedData(p54, v55)
            v_u_30.UpdateEnemySpeed(v56, p53, v57)
        end
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemyPosition.OnClientEvent:Connect(function(p58, p59)
        local v60 = {
            ["Value"] = 0
        }
        while v60.Value < buffer.len(p59) do
            v_u_32(p59, v60)
            local _ = v60.Value
            local v61, v62, v63 = v_u_18.ReadPositionData(p59, v60)
            v_u_30.UpdateEnemyPosition(v61, p58, v62, v63)
        end
    end)
    v_u_28.ClientListeners.Enemies.UpdateEnemyHealth.OnClientEvent:Connect(function(_, p64)
        local v65 = {
            ["Value"] = 0
        }
        while v65.Value < buffer.len(p64) do
            v_u_32(p64, v65)
            local _ = v65.Value
            local v66 = v_u_18.ReadHealthBuffer(p64, v65)
            v_u_30.UpdateEnemyHealth(v66)
        end
    end)
    local v_u_67 = v_u_30._ActiveEnemies
    local v_u_68 = 0
    local function v114(p69)
        if workspace:GetAttribute("GAME_FROZEN") then
            return
        end
        debug.profilebegin("Update enemies")
        debug.profilebegin("check enemies")
        local v70 = 0
        for _, v71 in v_u_35 do
            table.clear(v71)
        end
        for v72, v73 in v_u_67 do
            local v74 = v73.Data
            if not v74.IsStatic then
                if v74.Health < 1 then
                    v_u_30.RemoveEnemy(v72, true)
                else
                    local v75 = v74.Speed
                    local v76 = v75 < 0
                    local v77 = v73.CurrentNode
                    local v78
                    if v76 then
                        v78 = v77.GetPrevious(v73.PathSeed)
                    else
                        v78 = v77.GetNext(v73.PathSeed)
                    end
                    if v78 then
                        local v79 = 1.45 * v75
                        local v80 = math.abs(v79) * p69
                        while v80 > 0 do
                            local v81 = v73.CurrentNode.Position
                            local v82 = v78.Position
                            local v83 = (v81 - v82).Magnitude
                            if v83 <= 0 then
                                v73.CurrentNode = v78
                                v73.Alpha = 0
                                v73.Position = v82
                                if v76 then
                                    v78 = v73.CurrentNode.GetPrevious(v73.PathSeed)
                                else
                                    v78 = v73.CurrentNode.GetNext(v73.PathSeed)
                                end
                                if not v78 then
                                    break
                                end
                            else
                                local v84 = v80 / v83
                                local v85 = v73.Alpha + v84
                                if v85 < 0.9999 then
                                    v73.Alpha = v85
                                    v73.Position = v81:Lerp(v82, v73.Alpha)
                                    v80 = 0
                                else
                                    v80 = v80 - v83 * (0.9999 - v73.Alpha)
                                    v73.CurrentNode = v78
                                    v73.Alpha = 0
                                    v73.Position = v82
                                    if v76 then
                                        v78 = v73.CurrentNode.GetPrevious(v73.PathSeed)
                                    else
                                        v78 = v73.CurrentNode.GetNext(v73.PathSeed)
                                    end
                                    if not v78 then
                                        break
                                    end
                                end
                            end
                        end
                        v70 = v70 + 1
                        if v74.Type ~= "UnitSummon" then
                            v_u_35[v73.GameStateId] = v_u_35[v73.GameStateId] or {}
                            local v86 = v_u_35[v73.GameStateId]
                            local v87 = { (v73.CurrentNode.DistanceToStart or 0) + v73.Alpha, v73 }
                            table.insert(v86, v87)
                        end
                        if v_u_30.ENEMY_HITBOX_DEBUG then
                            v_u_19:DrawCircle(v73.Position, v73.Diameter / 2, p69, Color3.new(0, 0.65, 1))
                        end
                    elseif not v76 or v74.Type == "UnitSummon" then
                        v_u_30.RemoveEnemy(v72, true)
                    end
                end
            end
        end
        debug.profileend()
        debug.profilebegin((("Sort %* enemies"):format(v70)))
        for _, v88 in v_u_35 do
            table.sort(v88, function(p89, p90)
                return p89[1] > p90[1]
            end)
        end
        debug.profileend()
        if v_u_4:IsStudio() and v_u_30.ENEMY_PRIORITY_DEBUG then
            for _, v91 in v_u_35 do
                if #v91 ~= 0 then
                    local v92 = v91[1][2]
                    v_u_19:DrawCircle(v92.Position, v92.Diameter / 2, p69, Color3.new(0, 0.65, 1))
                    local v93 = v91[#v91][2]
                    v_u_19:DrawCircle(v93.Position, v93.Diameter / 2, p69, Color3.new(1, 0.65, 0))
                end
            end
        end
        debug.profilebegin((("render %* enemies"):format(v70)))
        local v94 = table.create(v70)
        local v95 = table.create(v70)
        for _, v96 in v_u_67 do
            local v97 = v96.Data
            if not (v97.IsStatic or v96._PausePositioning) then
                local v98 = v96.CurrentNode
                local v99 = v97.Speed
                local v100
                if v99 < 0 then
                    v100 = v98.GetPrevious(v96.PathSeed)
                else
                    v100 = v98.GetNext(v96.PathSeed)
                end
                if v100 then
                    local v101 = v96.Position
                    local v102 = CFrame.Angles
                    local v103 = v97.CustomAngle or 0
                    local v104 = v102(0, math.rad(v103), 0)
                    local v105 = v96.HeightOffset - v98.HeightOffset
                    local v106 = CFrame.lookAt(v101, v100.Position + Vector3.new(0, 0.0001, 0)) * v104 + v105
                    if not v96.CanRotate then
                        v106 = CFrame.new(v101) * v104 * (v96.RotationAngle or CFrame.identity).Rotation + v105
                    end
                    local v107 = v96.RenderCFrame
                    if v96.CanRotate or v96.Name ~= "Friran" then
                        if v96.Name == "The Founder, Arin" and v107 then
                            local v108 = CFrame.new(v101)
                            local v109 = v106 * CFrame.Angles(0, 3.141592653589793, 0)
                            local v110 = p69 * 2 * math.abs(v99)
                            v106 = v108 * v107:Lerp(v109, (math.min(1, v110))).Rotation - Vector3.new(0, 20, 0) + v105
                        elseif v107 then
                            local v111 = CFrame.new(v101)
                            local v112 = p69 * 2 * math.abs(v99)
                            v106 = v111 * v107:Lerp(v106, (math.min(1, v112))).Rotation + v105
                        end
                    else
                        v106 = (v96.RenderCFrame or CFrame.identity).Rotation + v101
                    end
                    if not v96.PrimaryPart then
                        warn((("Enemy %* has no PrimaryPart"):format(v96.Name)))
                    end
                    local v113 = v96.PrimaryPart
                    table.insert(v94, v113)
                    table.insert(v95, v106)
                    v96.RenderCFrame = v106
                end
            end
        end
        debug.profileend()
        workspace:BulkMoveTo(v94, v95, Enum.BulkMoveMode.FireCFrameChanged)
        v_u_26.RenderEnemies(v_u_67, #v95)
        debug.profileend()
        v_u_68 = v70
    end
    v_u_4.Heartbeat:Connect(v114)
end
function v_u_30.UpdateEnemySpeed(p115, p116, p117)
    local v118 = v_u_30._ActiveEnemies[p115]
    if v118 then
        local v119 = v118.Data
        local v120 = v119.Speed < 0
        local v121 = p117 < 0
        local v122 = v118.CurrentNode
        if not v120 and v121 or v120 and not v121 then
            v118.Alpha = 1 - v118.Alpha
            if v121 then
                local v123 = v122.GetNext(v118.PathSeed)
                if v123 then
                    v122 = v123
                else
                    v118.Alpha = 1
                end
            else
                local v124 = v122.GetPrevious(v118.PathSeed)
                if v124 then
                    v122 = v124
                else
                    v118.Alpha = 0
                end
            end
        end
        v118.CurrentNode = v122
        local v125 = v121 and v122.GetPrevious(v118.PathSeed) or v122.GetNext(v118.PathSeed)
        if v125 then
            local v126 = workspace:GetServerTimeNow() - p116
            local v127 = (v122.Position - v125.Position).Magnitude
            local v128 = (p117 - v119.Speed) * v126 / v127
            local v129 = math.abs(v128)
            v118.Alpha = v118.Alpha + v129
        end
        v118.CurrentNode = v122
        v119.Speed = p117
    end
end
function v_u_30.UpdateEnemyPosition(p130, p131, p132, p133)
    local v134 = v_u_30._ActiveEnemies[p130]
    if v134 then
        local v135 = v134.Data
        local v136 = workspace:GetServerTimeNow() - p131
        v134.CurrentNode = p132
        v134.Alpha = p133
        local v137 = v135.Speed < 0
        local v138 = v137 and p132.GetPrevious(v134.PathSeed) or p132.GetNext(v134.PathSeed)
        if v138 then
            local v139 = (p132.Position - v138.Position).Magnitude
            local v140 = v135.Speed
            local v141 = math.abs(v140) * v136 / v139
            local v142 = v135.Speed == 0 and 0 or v141
            if v137 then
                local v143 = v134.Alpha - v142
                v134.Alpha = math.max(0, v143)
                while v134.Alpha <= 0 and v134.CurrentNode.GetPrevious(v134.PathSeed) do
                    v134.CurrentNode = v134.CurrentNode.GetPrevious(v134.PathSeed)
                    v134.Alpha = 1 + v134.Alpha
                    local v144 = v134.CurrentNode.GetPrevious(v134.PathSeed)
                    if not v144 then
                        v134.Alpha = 0
                        return
                    end
                    local v145 = (v134.CurrentNode.Position - v144.Position).Magnitude
                    local v146 = v134.Alpha * v145
                    local _ = math.abs(v146) / v145
                end
            else
                local v147 = v134.Alpha + v142
                v134.Alpha = math.min(1, v147)
                while v134.Alpha >= 1 and v134.CurrentNode.GetNext(v134.PathSeed) do
                    v134.CurrentNode = v134.CurrentNode.GetNext(v134.PathSeed)
                    v134.Alpha = v134.Alpha - 1
                    local v148 = v134.CurrentNode.GetNext(v134.PathSeed)
                    if not v148 then
                        v134.Alpha = 1
                        return
                    end
                    local v149 = (v134.CurrentNode.Position - v148.Position).Magnitude
                    local v150 = v134.Alpha * v149
                    local _ = math.abs(v150) / v149
                end
            end
        end
    else
        return
    end
end
function v_u_30.GetEnemy(p151)
    return v_u_29[p151]
end
local v_u_152 = v_u_30._ActiveEnemies
local v_u_153 = v_u_26.UpdateHealthBar
local v_u_154 = v_u_26.AddEnemyLabels
local function v_u_169(p155, p156)
    local v157 = p155.Model
    if p156.EnemyCFrame then
        v157:PivotTo(p156.EnemyCFrame)
    else
        local _ = p155.Data
        local v158 = p155.CurrentNode
        local v159 = p156.Speed < 0
        local _ = p156.Speed == 0
        local v160
        if v159 then
            v160 = v158.GetPrevious(p155.PathSeed)
        else
            v160 = v158.GetNext(p155.PathSeed)
        end
        local v161 = ("No NextNode found for %*-%*"):format(v158.IndexGroup, v158.Index)
        assert(v160, v161)
        local v162 = p156.Alpha
        local v163 = p156.Speed
        local v164 = workspace:GetServerTimeNow() - p156.SpawnedAtServerTime
        local v165 = (v160.Position - v158.Position).Magnitude
        local v166 = v163 * v164 / v165
        local v167 = v158.Position:Lerp(v160.Position, v162 + v166)
        local v168 = CFrame.new(0, v157:GetExtentsSize().Y / 2, 0)
        v157:PivotTo(CFrame.lookAt(v167, v160.Position) * v168)
        p155.Position = v157:GetPivot().Position
    end
end
local v_u_170 = {
    ["Mutators"] = {
        ["Strong"] = "Strong",
        ["Sturdy"] = "Sturdy",
        ["Resilient"] = "Resilient",
        ["Challenger"] = "Challenger",
        ["Energy Drain"] = "Energy Drain"
    },
    ["Modifiers"] = {
        ["Regen"] = "Regen",
        ["Thrice"] = "Thrice"
    }
}
local function v_u_176(p171, p172, p173)
    if p171 then
        for _, v174 in p171 do
            local v175 = v_u_170.Mutators[v174] or v_u_170.Modifiers[v174]
            if v175 then
                v_u_22:PlayEffect(v175, p172, p173)
            end
        end
    end
end
local v_u_177 = { "Smith John", "Lord of Shadows" }
local v_u_178 = require(v5.Modules.Data.CurrencyData)
function v_u_30.UpdateEnemyModel(p179, p180, p181)
    local v182 = {}
    local v183 = {}
    local v184 = p179.UniqueIdentifier
    local v185 = p179.Model
    local v186 = p179.Data.Mutators
    local v187 = p179.Data.Modifiers
    local v188 = p179.BattlepassEnemy
    local v189 = p179.Data.DisplayName
    local v190 = p179.SummonType
    if p179.Type == "UnitSummon" and v190 then
        v_u_22:PlayEffect(("%*Summon"):format(v190), v185)
    end
    if not p179.IsStatic or table.find(v_u_177, p179.Name) then
        local v191 = p179.Name
        local v192 = p179.PreviousType
        local v193 = p179.Type == "UnitSummon" and v192 and v192 or p179.Type
        if not (v185:FindFirstChildOfClass("Humanoid") or v185:FindFirstChildOfClass("AnimationController")) then
            local v194 = Instance.new("AnimationController")
            v194.Parent = v185
            Instance.new("Animator").Parent = v194
        end
        local v195 = v193 == "Boss" and "Bosses" or "Enemies"
        if p181 then
            v191 = p181.Name
        end
        local v196 = v191 == "Thunder (You)" and "Thunder" or (v_u_27.UnitSpecializations[v189] and "Horsegirl" or v191)
        v_u_10:LoadAnimations(v185, "Enemies", "Default")
        v_u_10:LoadAnimations(v185, v195, v196)
    end
    local v197 = v_u_152[v184]
    if p180 == nil or not p180 then
        v_u_154(v197)
        v_u_26.AddGuiData(v197)
    end
    if v186 then
        for _, v198 in v186 do
            if not v183[v198] then
                v183[v198] = true
                table.insert(v182, v198)
            end
        end
    end
    if v187 then
        for _, v199 in v187 do
            if not v183[v199] then
                v183[v199] = true
                table.insert(v182, v199)
            end
        end
    end
    v_u_176(v182, v185, v197.EnemyGui)
    if v188 and (not p179.IsStatic and p179.Type ~= "UnitSummon") then
        local v200 = v_u_30._ActiveEnemies[v184]
        local v201
        if v200 then
            v201 = v200.EnemyGui
        else
            v201 = v200
        end
        if v200 and v201 then
            local v202 = v201.Status
            v202.Visible = true
            local v203 = script.BattlepassIcon:Clone()
            v203.Image = v_u_178:GetCurrencyDataFromName("Pass XP").Image
            v203.Parent = v202
        end
    end
    local v204 = v197.Data.OverrideHeightOffset
    if v204 then
        v197.HeightOffset = Vector3.new(0, v204, 0)
    else
        local v205 = v185:GetExtentsSize().Y / 2 + (v185:GetAttribute("Offset") or 0)
        v197.HeightOffset = Vector3.new(0, v205, 0)
    end
end
function v_u_30.UpdateEnemyStats(p206)
    local v207 = p206.Data
    local v208 = v207.Type
    if v208 == "Boss" and not v_u_25:DoesBarExist(p206.UniqueIdentifier) then
        local v209 = v207.DisplayName or p206.Name
        local v210 = v209 == v_u_2.LocalPlayer.DisplayName and "You" or v209
        v_u_25:AddBar({
            ["ID"] = p206.UniqueIdentifier,
            ["Name"] = p206.Name,
            ["DisplayName"] = v210,
            ["Model"] = p206.Model
        })
    end
    local v211 = p206.Model
    v_u_153(p206, v211, v207.Health, v207.MaxHealth, v208, "Main")
    local v212 = v207.SecondaryHealth
    if v212 then
        v_u_153(p206, v211, v212, v207.SecondaryMaxHealth, v208, "Secondary")
    end
    local v213 = v207.Shields
    if v213 then
        v_u_23:AddEnemy(v211, v213)
        v_u_23:UpdateEnemy(v211, v213)
    end
    p206.HasAttacks = v_u_20:FindFirstChild(p206.Name, true)
end
local function v_u_218(p214, p215)
    for v216, v217 in p215 do
        if v216 == "Type" then
            p214.PreviousType = p214.Type
            ::l5::
            p214[v216] = v217
        else
            if v216 ~= "SummonedBy" or (typeof(v217) ~= "table" or not v217.UniqueIdentifier) then
                goto l5
            end
            p214[v216] = v_u_17.GetActiveUnits()[v217.UniqueIdentifier]
        end
    end
end
function v_u_30.SpawnEnemy(p219, p220)
    local v221 = p219.Index
    local v222 = p219.Id
    local v223 = p219.BattlepassEnemy
    local v224 = v_u_21.DeepCopy(v_u_7:RetrieveEnemyDataById(v222))
    if p220 then
        v_u_218(v224, p220)
    end
    if v224.SpawnDelay then
        local v225 = v_u_15.MatchId
        local v226 = workspace:GetServerTimeNow() - p219.SpawnedAtServerTime
        task.wait(v224.SpawnDelay - v226)
        if v225 ~= v_u_15.MatchId then
            return
        end
        p219.SpawnedAtServerTime = p219.SpawnedAtServerTime + v224.SpawnDelay
    end
    local v227 = v_u_152[v221] == nil
    local v228 = ("Enemy with id %* already exists!"):format(v221)
    assert(v227, v228)
    local v229 = p219.OverrideModel
    local v230
    if v224.Name == "Friran" then
        local v231 = v_u_17.GetUnitModelFromGUID(p220.SummonedBy.UniqueIdentifier) or v224.Model
        v_u_14((("Friran spawning. Using unit model: %*"):format(v231)))
        v230 = v231:Clone()
        if v230:FindFirstChild("HandleR") then
            v230:FindFirstChild("HandleR"):Destroy()
        end
    else
        v_u_14((("Spawning enemy %* (%*). OverrideModel: %*"):format(v224.Name, v221, v229 or "none")))
        v230 = v229 and v229:Clone() or v224.Model:Clone()
    end
    v230.Name = tostring(v221)
    local v232 = p219.Mutators
    local v233 = p219.Modifiers
    local v234 = v224.Type
    local v235 = v230.PrimaryPart
    if not v224.IsStatic then
        local v236 = ("enemy \'%*\' has no primary part"):format((v224.Model:GetFullName()))
        assert(v235, v236)
    end
    (v230:FindFirstChild("HumanoidRootPart") or v230.PrimaryPart).CanQuery = true
    local v237 = v_u_12.Nodes[("%*-%*"):format(p219.IndexGroup or 1, p219.CurrentNode)]
    local v238 = {
        ["Data"] = {
            ["Type"] = v234,
            ["Class"] = v224.Class,
            ["Health"] = p219.Health,
            ["MaxHealth"] = p219.MaxHealth,
            ["PredictedKiller"] = p219.PredictedKiller,
            ["CustomAngle"] = v224.CustomAngle,
            ["SecondaryHealth"] = p219.SecondaryHealth,
            ["SecondaryMaxHealth"] = p219.SecondaryMaxHealth,
            ["Shields"] = p219.Shields,
            ["Elements"] = p219.Elements,
            ["Speed"] = p219.Speed,
            ["Mutators"] = v232,
            ["Modifiers"] = v233,
            ["IsStatic"] = v224.IsStatic,
            ["DisplayName"] = p219.DisplayName,
            ["OverrideModel"] = p219.OverrideModel,
            ["OverrideHeightOffset"] = p219.OverrideHeightOffset
        },
        ["ID"] = v224.ID,
        ["Name"] = v224.Name,
        ["UniqueIdentifier"] = v221,
        ["PathSeed"] = v221,
        ["GameStateId"] = p219.GameStateId,
        ["PlayerSpawn"] = p219.PlayerSpawn,
        ["Type"] = v224.Type,
        ["Model"] = v230,
        ["Diameter"] = v_u_8(v224.Name),
        ["PrimaryPart"] = v235,
        ["HeightOffset"] = Vector3.new(0, 0, 0),
        ["Position"] = Vector3.new(0, 0, 0),
        ["CurrentNode"] = v237,
        ["Alpha"] = p219.Alpha,
        ["CanRotate"] = true,
        ["BattlepassEnemy"] = v223,
        ["HasAttacks"] = false,
        ["RenderData"] = nil,
        ["SummonType"] = p219.SummonType,
        ["SpawnedBy"] = p219.SpawnedBy,
        ["PreviousType"] = v224.PreviousType
    }
    if v230:HasTag("EnemyCollision") then
        v_u_16:SetCollisionGroup(v230, "Entities", true)
    end
    v_u_169(v238, p219)
    v230.Parent = workspace.Entities
    v_u_152[v221] = v238
    local v239 = table.find({ "CidRaidTower" }, v238.Name) ~= nil
    v_u_30.UpdateEnemyModel(v238, v239, v229)
    v_u_30.UpdateEnemyStats(v238)
    v_u_9:PlayEffect("EnemySpawn", {
        ["Position"] = v238.Position,
        ["Scale"] = v230:GetScale()
    })
    v238.Position = v230:GetPivot().Position
    v_u_30.EnemySpawned:Fire(v238)
    local v240 = v238.Data.DisplayName
    local v241 = v240 or v238.Name
    local v242 = v_u_33[v240 and v_u_27.UnitSpecializations[v240] and "Horsegirl" or v241]
    if v242 then
        v242(v238, v230)
    end
end
v_u_30.ReadHealthBuffer = v_u_18.ReadHealthBuffer
function v_u_30.UpdateEnemyHealth(p243)
    local v244 = p243.EnemyId
    local v245 = v_u_30._ActiveEnemies[v244]
    if v245 and not v_u_30.AlreadyDeadEnemies[v244] then
        local v246 = v245.Data
        if p243.Health then
            if p243.Health > v246.Health then
                v_u_9:PlayEffect("EnemyHealthGain", {
                    ["EnemyGUID"] = v244,
                    ["Amount"] = p243.Health - v246.Health
                })
            end
            v_u_153(v245, v245.Model, p243.Health, p243.MaxHealth, v246.Type, "Main")
            v246.Health = p243.Health
            v246.MaxHealth = p243.MaxHealth
            v_u_30.EnemyHealthChanged:Fire(v245)
        end
        if p243.SecondaryHealth then
            v_u_153(v245, v245.Model, p243.SecondaryHealth, p243.SecondaryMaxHealth, v246.Type, "Secondary")
            if p243.SecondaryHealth == 0 then
                v_u_153(v245, v245.Model, v246.Health, v246.MaxHealth, v246.Type, "Main")
            else
                v246.SecondaryHealth = p243.SecondaryHealth
                v246.SecondaryMaxHealth = p243.SecondaryMaxHealth
            end
        end
        if p243.Shields then
            v_u_23:UpdateEnemy(v245.Model, p243.Shields)
            v246.Shields = p243.Shields
        end
    end
end
v_u_28.ClientListeners.Enemies.UpdateEnemyPredictedKiller.OnClientEvent:Connect(function(p247)
    local v248 = buffer.readu16(p247, 0)
    local v249 = buffer.readu8(p247, 2) == 1
    local v250 = v_u_30._ActiveEnemies[v248]
    if v250 then
        v250.Data.PredictedKiller = v249 or nil
    end
end)
function v_u_30.GetActiveEnemies(_)
    return v_u_30._ActiveEnemies
end
function v_u_30.GetEnemyData(_, p251)
    return v_u_30._ActiveEnemies[p251]
end
local v_u_252 = {
    ["Shinobi Puppet"] = "DismantlePuppet",
    ["Hirko"] = "HirkoDisappear"
}
function v_u_30.RemoveEnemy(p_u_253, p254)
    v_u_30.AlreadyDeadEnemies[p_u_253] = true
    task.delay(0.1, function()
        v_u_30.AlreadyDeadEnemies[p_u_253] = nil
    end)
    if v_u_152[p_u_253] then
        local v255 = v_u_152[p_u_253]
        local v256 = v255.Model
        local v257 = v_u_7:RetrieveEnemyDataByName(v255.Name)
        if v257.Name == "Berserker" then
            v256:Destroy()
            v_u_152[p_u_253] = nil
            return
        end
        v_u_30.EnemyDespawned:Fire(v255)
        if p254 or v257.Name == "Berserker" then
            v_u_152[p_u_253] = nil
        else
            task.delay(0.15, function()
                v_u_30.AlreadyDeadEnemies[p_u_253] = nil
                v_u_152[p_u_253] = nil
            end)
        end
        local v258 = v257.Name
        local v259
        if v257 then
            v259 = v257.Type or nil
        else
            v259 = nil
        end
        local v260 = v257.DespawnDelay or (v259 == "Boss" and 2.5 or nil)
        v_u_10:RemoveEntity(v256)
        local v261 = v256:GetPivot().Position
        v_u_23:RemoveEnemy(v256)
        local v262 = v_u_252[v258]
        if v262 then
            v_u_9:PlayEffect(v262, {
                ["Model"] = v256
            })
        end
        v_u_11:Play({ "General", "Enemies" }, "DeathSound", {
            ["Destroy"] = true,
            ["Position"] = v261
        })
        v_u_9:PlayEffect(5, {
            ["Model"] = v256,
            ["Position"] = v261
        })
        if v260 then
            v_u_3:AddItem(v256, v260)
        else
            v256.Parent = nil
            v_u_3:AddItem(v256, 0.5)
        end
        if v259 == "Boss" then
            v_u_25:RemoveBar(p_u_253)
        end
        if v255.EnemyGui then
            v255.EnemyGui:Destroy()
            v255.RenderData = nil
        end
    end
end
function v_u_30.RemoveAllEnemies()
    v_u_25:RemoveAllBars()
    for v263, v264 in v_u_152 do
        local v265 = v264.Model
        local v266 = v_u_7:RetrieveEnemyDataByName(v264.Name)
        local v267 = v266 and v266.Type or nil
        v_u_10:RemoveEntity(v265)
        v_u_23:RemoveEnemy(v265)
        if v267 == "Boss" then
            v_u_25:RemoveBar(v263)
        end
        v265:Destroy()
        v_u_30.EnemyDespawned:Fire(v264)
    end
    table.clear(v_u_152)
end
function v_u_30.GetEnemyGui(p268, p269)
    local v270 = tonumber(p268)
    local v271 = v_u_152[v270]
    if v271 then
        v271 = v271.EnemyGui
    end
    if p269 then
        local v272 = 0
        while not v271 do
            v271 = v_u_152[v270]
            if v271 then
                v271 = v271.EnemyGui
            end
            v272 = v272 + task.wait()
            if p269 <= v272 then
                break
            end
        end
    end
    return v271
end
task.spawn(v_u_30.Init)
return v_u_30
