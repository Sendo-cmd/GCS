local Endpoint = "https://raw.githubusercontent.com/test-macro/ALS_Marco/main/"
local Profiles = {
    "Ikatsuq.json",
    "FireBlackDevilZ.json",
}

repeat task.wait(1) until game:IsLoaded()

local PATH = "Xenon Hub Anime Last Stand/User"

-- Process

if not isfolder(PATH) then
    local path = ""
    for i, v in pairs(PATH:split("/")) do
        path = path .. v .. "/"
        makefolder(path)
    end
end

local HttpService = game:GetService("HttpService")

for _, Name in pairs(Profiles) do
    local Profile_Data = game:HttpGet(Endpoint .. Name)
    
    local success, JSON = pcall(function()
        return HttpService:JSONDecode(Profile_Data)
    end)

    if success then
        writefile(PATH .. "/" .. Name, Profile_Data)
    else
        warn("Failed to decode JSON for profile: " .. Name)
    end
end
