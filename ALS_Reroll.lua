repeat task.wait(5) until game:IsLoaded()
-- Setting
TechniqueNotificaition = {
    ["Index"] = {
        "Overlord",
        "Avatar",
        "Glitched",
    },
    ["Tags"] = {
        ["MeVeryNoobza"] = "815806616468717610",
        ["Dxw2pz"] = "1153497403534614528"
    },
    ["Webhook"] = {
        ["MeVeryNoobza"] = "https://discord.com/api/webhooks/1281507869987962930/WSK1OvwSAXUMSDjD0To-yVzYRtFk4lJh_1N9QTOduQCOg86qh4Uw2HyYm0po3wJCg0le",
        ["Dxw2pz"] = "https://discord.com/api/webhooks/1281507869987962930/WSK1OvwSAXUMSDjD0To-yVzYRtFk4lJh_1N9QTOduQCOg86qh4Uw2HyYm0po3wJCg0le",
    }
}

local Setting = TechniqueNotificaition

local plr = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local QuirksUI = plr.PlayerGui:WaitForChild("QuirksUI")
local Selection = QuirksUI.BG.Content.Selection

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

print("Modules Loaded Reroll")

local UnitNames = require(Modules.UnitNames)

function GetAvatarThumbnail(userId)
    local apiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=720x720&format=Png&isCircular=false"
    
    local success, response = pcall(function()
        return game:HttpGet(apiUrl)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        
        if data and data.data and data.data[1] and data.data[1].imageUrl then
            return data.data[1].imageUrl
        end
    end

    return nil
end

function RGBtoInt(color)
    local rh = string.format("%02x", color.R*255)
    local gh = string.format("%02x", color.G*255)
    local bh = string.format("%02x", color.B*255)
    local hex = "0x"..rh..gh..bh
    
    return tonumber(hex)
end

function Update()
    local success, err = pcall(function()
        local Unit = Selection:GetAttribute("Unit")
        local Quirk = Selection:GetAttribute("Quirk")
        local UnitName = UnitNames[Unit]
        
        if Quirk == nil or not table.find(Setting["Index"], Quirk) then return end

        local DiscordID = Setting["Tag"][plr.Name]

        local data = {
            ["content"] = `<@{DiscordID}>`,
            ["embeds"] = {
                {
                    ["title"] = "Anime Last Stands",
                    ["description"] = `__**Account - ข้อมูลบัญชีคุณ**__\n<:Icons:1047821411110105088>Username: ||{plr.DisplayName == plr.Name and plr.Name or plr.DisplayName} {plr.DisplayName == plr.Name and "" or ""}||\n<:RerollShardCB:1276036995155628094>Quirk: {Quirk}\n\n__**Unit - ยูนิต**__\n<:icon_ReplyContinue3b:1151211485998100560> {UnitName} [{Unit}]`,
                    ["thumbnail"] = {
                        url = GetAvatarThumbnail(plr.UserId)
                    },
                    ["color"] = RGBtoInt(Color3.fromRGB(255, 255, 255)),
                    ["image"] = {
                        ["url"] = "https://media.discordapp.net/attachments/774011709358080021/1267843051997630535/hpfk2.1.png?ex=66dbb29a&is=66da611a&hm=6085a6699c2f332eca878e6fc64167c3c1065708c0ed32401e675a3eee11f9a1&=&format=webp&quality=lossless&width=490&height=488",
                    },
                    ["author"] = {
                        ["name"] = " Gaming Champion Shop ",
                        ["icon_url"] = "https://media.discordapp.net/attachments/774011709358080021/1267843051997630535/hpfk2.1.png?ex=66dbb29a&is=66da611a&hm=6085a6699c2f332eca878e6fc64167c3c1065708c0ed32401e675a3eee11f9a1&=&format=webp&quality=lossless&width=490&height=488"
                    },
                    ["footer"] = {
                        ["text"] = "Gaming Champion Shop ",
                         ["icon_url"] = "https://media.discordapp.net/attachments/774011709358080021/1267843051997630535/hpfk2.1.png?ex=66dbb29a&is=66da611a&hm=6085a6699c2f332eca878e6fc64167c3c1065708c0ed32401e675a3eee11f9a1&=&format=webp&quality=lossless&width=490&height=488"
                    },     
                    ["timestamp"] = DateTime.now():ToIsoDate()
                }
            },
        }

        local response = request({
            ["Url"] = Setting["Webhook"][plr.Name],
            ["Method"] = "POST",
            ["Body"] = game.HttpService:JSONEncode(data),
            ["Headers"] = {
                ["content-type"] = "application/json"
            }
        })
    end)

    if not success then
        print(err)
    end
end

if Selection:GetAttribute("UnitID") then
    QuirkConnect = Selection:GetAttributeChangedSignal("Quirk"):Connect(Update)
end

game:GetService("ReplicatedStorage").Remotes.Quirks.Finish.OnClientEvent:Connect(function(...)
    local UnitID, CurrentQuirk = ...

    if QuirkConnect then QuirkConnect:Disconnect() end

    repeat task.wait() until UnitID == Selection:GetAttribute("UnitID")

    QuirkConnect = Selection:GetAttributeChangedSignal("Quirk"):Connect(Update)
end)
