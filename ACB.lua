local GameLoad = nil
local PlaceId = {
	12886143095,18583778121,12900046592
}
if game.PlaceId == 6299805723 then
    GameLoad = "Banana"
elseif game.PlaceId == 6299805723 then
    GameLoad = "Reroll"    
end    

local var,err = pcall(function ()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/test/main/" .. GameLoad .. ".lua"))()
end)

if var == false  then
    print("Error : " .. err)
end
