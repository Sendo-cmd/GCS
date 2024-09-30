local Endpoint = "https://raw.githubusercontent.com/test-macro/marco/main/"
local Profiles = {
    "C_Sand.json",
    "C_Dung.json",
};

local PATH = "Nousigi Hub/Macro/AnimeVanguards";

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
