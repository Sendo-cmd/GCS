local GameLoad = nil
local PlaceId = {
	12886143095,18583778121,12900046592
}
for _, id in ipairs(PlaceId) do
    if game.PlaceId == id then
        GameLoad = "Reroll"
        break
    end
end

local var,err = pcall(function ()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/GCS/main/" .. GameLoad .. ".lua"))()
end)

if var == false  then
    print("Error : " .. err)
end
