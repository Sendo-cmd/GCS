local Endpoint = "https://raw.githubusercontent.com/test-macro/AA_Marco/main/"
local Profiles = {
    "gem.json",
    "hs.json",
    "dbz.json",
}

repeat task.wait(1) until game:IsLoaded()

local PATH = "Nousigi Hub/Macro/AnimeAdventures"

-- Process

if not isfolder(PATH) then
    local path = ""
    for i,v in pairs(PATH:split("/")) do
        path ..= `{v}/`
        makefolder(path)
    end
end

local HttpService = game:GetService("HttpService")

for _, Name in pairs(Profiles) do
    local Profile_Data = game:HttpGet(Endpoint .. Name)

    local success, JSON = pcall(HttpService.JSONDecode, HttpService, Profile_Data)

    if success then
        writefile(`{PATH}/{Name}`, Profile_Data)
    end
end
