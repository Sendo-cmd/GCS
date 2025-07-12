local Endpoint = "https://raw.githubusercontent.com/test-macro/AA_Marco/main/"
local Profiles = {
    "SMInf.json",
    "DWInf.json",
    "GokuInf.json",
    "GokuCh.json",
    "GokuCh2.json",
    "GokuCh3.json",
    "GokuCh4.json",
    "DWCh.json",
    "DWCh2.json",
    "DWCh3.json",
    "DWCh4.json",
    "StoryGV.json",
    "Tdw.json",
    "DgDw.json",
}

repeat task.wait(1) until game:IsLoaded()

local PATH = "Nousigi Hub/Macro/AllStarTowerDefenseX"

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
