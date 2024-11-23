local Endpoint = "https://raw.githubusercontent.com/test-macro/marco/main/"
local Profiles = {
    "Igris_Base.json",
    "Raid_Base.json",
    "IgrisMon.json",
    "Boss_BaseS.json",
    "Boss_BaseS2.json",
    "Boss_Base.json",
    "Boss_Base_GS.json",
    "Boss_Base_Son.json",
    "Dung_Base.json"
    "Igris_SonjE.json",
    "Igris_SonjEV.json",
    "Igris_SonjEV2.json",
    "Igris_SonjEV3.json",
    "Igris_SonjEMon.json",
    "Igris_Base.json",
    "Igris_ChainE.json",
    "Igris_Chain.json",
    "Raid_Igris.json",
    "Raid_Akazo.json",
    "Raid_Renguko.json",
    "Raid_Monarch_Igris.json",
    "Raid_Monarch_Song.json",
};

repeat task.wait(1) until game:IsLoaded()

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