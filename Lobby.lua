SECONDS=300;

local a=task.wait;repeat a(1)until game:IsLoaded()and game.Players.LocalPlayer and game.Players.LocalPlayer.PlayerGui;a(SECONDS)local b=game.PlaceId;local c=game:GetService('Players')local d=game:GetService('TeleportService')local e=game.Players.LocalPlayer;if not e.PlayerGui:FindFirstChild('Anime Vanguards')and b~=16146832113 then d:Teleport(16146832113)end
