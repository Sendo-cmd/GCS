repeat task.wait() until game:IsLoaded()

_G.Scripts = {
    [18138547215] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ACB2.lua",
    [12886143095] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS2.lua",
    [18583778121] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS2.lua",
    [12900046592] = "https://raw.githubusercontent.com/Sendo-cmd/GCS/main/ALS2.lua",
}

if not _G.Override then
    _G.Override = {}
end
for i,v in pairs(_G.Override) do
    _G.Scripts[i] = v
end

if not _G.dont then
    loadstring(game:HttpGet(_G.Scripts[game.PlaceId]))()
end