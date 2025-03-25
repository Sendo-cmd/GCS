local Endpoint = "https://raw.githubusercontent.com/test-macro/marco/main/"
local Profiles = {
    "DungAntIS.json",
    "DungBoost3.json",
    "DungBoost3V2.json",
    "DungBoost3V3.json",
    "DungAntKing.json",
    "DungAntKing2.json",
    "DungAntKing3.json",
    "Saber.json",
    "Saber2.json",
    "SaberClear.json",
    "Sokora.json",
    "Sokora2.json",
    "SonjVC_Igris.json",
    "SonjVCH_Igris.json",
    "YomomataCh.json",
    "YomomataG.json",
    "YomomataV.json",
    "YomomataR.json",
    "KeyGilgamesh.json",
    "BEIgris.json",
    "BEIgris2.json",
    "BEIgris3.json",
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