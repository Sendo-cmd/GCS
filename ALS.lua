local function tableFind(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

local GameLoad = nil
local PlaceId = {
	12886143095,18583778121,12900046592
}
if table.find(PlaceId, game.PlaceId) then
    GameLoad = "Kaitunlist"
elseif table.find(PlaceId,game.PlaceId) then
    GameLoad = "Reroll"    
end    

local var,err = pcall(function ()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/test/main/" .. GameLoad .. ".lua"))()
end)

if var == false  then
    print("Error : " .. err)
end
