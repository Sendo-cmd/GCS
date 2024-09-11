SECONDS=300;

local a=task.wait;repeat a(1)until game:IsLoaded()and game.Players.LocalPlayer and game.Players.LocalPlayer.PlayerGui;a(SECONDS)local b=game.PlaceId;local c=game:GetService('Players')local d=game:GetService('TeleportService')local e=game.Players.LocalPlayer;if not e.PlayerGui:FindFirstChild('Anime Last Stand')and b~=12886143095 then d:Teleport(12886143095)end
