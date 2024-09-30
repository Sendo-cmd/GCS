local Endpoint = "https://raw.githubusercontent.com/test-macro/marco/main/"
local Profiles = {
    "C_Sand.json",
    "C_Dung.json",
    "C_Namke.json",
    "GEM.json",
    "GEM2.json",
    "GEM3.json",
    "LSDD3_SonjE.json",
    "Raid_Igris.json",
    "Boss_Base.json",
    "Boss_Base_Son.json",
    "Raid_Monarch_Igris.json",
    "Raid_Monarch_Song.json",
    "LSDD3_ChainE.json",
    "LSDD3_Chain2.json",
    "LSDD3_Chain.json",
    "Raid_Base.json",
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
