local GameLoad = nil
local PlaceId = {}
if game.PlaceId == 16146832113 then
    GameLoad = "autodeleta"
end
local var,err = pcall(function ()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/GCS/main/" .. GameLoad .. ".lua"))()
end)

if var == false  then
    print("Error : " .. err)
end
