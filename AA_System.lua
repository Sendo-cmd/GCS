--[[


[Story Mode]
Planet Greenie
Walled City
Snowy Town
Sand Village
Navy Bay
Fiend City
Spirit World
Ant Kingdom
Magic Town
Haunted Academy
Magic Hills
Space Center
Alien Spaceship
Fabled Kingdom
Ruined City
Puppet Island
Virtual Dungeon
Snowy Kingdom
Dungeon Throne
Mountain Temple
Rain Village

[Raid Mode]
Strange Town
Nightmare Train
Sacred Planet
Ruined City (The Menace)
Walled City
Future City (Tyrant's Invasion)
Navy's Ford (Buddha)
Sand Village
Future City
Cursed Festival
Storm Hideout

[Legend Stage]
Fabled Kingdom (Generals)
Spirit Invasion
Dungeon Throne
Space Center
Rain Village
Virtual Dungeon (Bosses)
Magic Hills (Elf Invasion)
Ruined City (Midnight)

]]


_G.User = {
    ["FireBlackDevilZ"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["paopqo780"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["okillua006"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["puggtopro"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["opoppoky"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["Naiza080947"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
}
local Settings = {
    ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite
    
    ["Select Map"] = "Planet Greenie",
    ["Select Level"] = 1, -- Story & Legend Stage & Raid
    ["Hard"] = false, -- Story 
}
local plr = game.Players.LocalPlayer
if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end
CheckRoom = function()
    for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == tostring(game.Players.LocalPlayer.Name) then
                    return {true,v.Name}
                end
            end
        end
    end
    return {false}
end
CheckRoomRaid = function()
    for i, v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == tostring(game.Players.LocalPlayer.Name) then
                    return {true,v.Name}
                end
            end
        end
    end
    return {false}
end
function Room()
    for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == 'nil' then
                    return v.Name
                end
            end
        end
    end
end
function RoomRaid()
    for i, v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == 'nil' then
                    return v.Name
                end
            end
        end
    end
end
function JoinConvert(args)
	for i,v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Worlds)) do
		if v.name == args then
			return v
		end
	end
end
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
spawn(function ()
	while true do
        pcall(function ()
            if game.PlaceId == 8304191830  then
                if Settings["Select Mode"] == 'Story'then
                    if CheckRoom()[1] == true then
                        if TeleportRoom then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,Settings["Hard"] and "Hard" or "Normal")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                    else
                        OldCframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Infinite'then
                    if CheckRoom ()[1] == true then
                        if TeleportRoom then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])['infinite']['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                        Next_(2)
                    else
                        OldCframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Legend Stage'then
                    if CheckRoom ()[1] == true then
                        if TeleportRoom then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])["levels"][Settings["Select Level"]]['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                        Next_(2)
                    else
                        OldCframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Raid'then
                    if CheckRoomRaid()[1] == true then
                        if TeleportRoom then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoomRaid()[2], JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoomRaid()[2])
                        Next_(2)
                    else
                        OldCframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(RoomRaid())
                    end
                end
            end
        end)
		wait()
	end
end)