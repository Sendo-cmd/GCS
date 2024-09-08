local GameLoad = nil
local PlaceId = {
	12886143095, 18583778121, 12900046592
}

-- Check if game.PlaceId is in the PlaceId table
for _, id in ipairs(PlaceId) do
    if game.PlaceId == id then
        GameLoad = "Reroll"
        break
    end
end

-- Attempt to load the script from the URL only if GameLoad is set
if GameLoad then
    local var, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sendo-cmd/GCS/main/" .. GameLoad .. ".lua"))()
    end)

    if not var then
        print("Error: " .. err)
    end
else
    print("Error: GameLoad is nil, PlaceId not found.")
end
