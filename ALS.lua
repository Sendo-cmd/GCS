local GameLoad = nil
local PlaceId = {
	12886143095,18583778121,12900046592
}
if tableFind(PlaceId, game.PlaceId) then
    GameLoad = "Kaitunlists"
elseif tableFind(PlaceId, game.PlaceId) then
    GameLoad = "Kaitunlist"	
elseif tableFind(PlaceId, game.PlaceId) then
    GameLoad = "Reroll"
end

local var,err = pcall(function ()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/GCS/main/" .. GameLoad .. ".lua"))()
end)

if var == false  then
    print("Error : " .. err)
end
