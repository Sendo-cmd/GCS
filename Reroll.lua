repeat task.wait(5) until game:IsLoaded()

RerollsNotificationEvery = {
    ["Minutes"] = 240, -- นาที
    ["Webhook"] = "https://discord.com/api/webhooks/1281507869987962930/WSK1OvwSAXUMSDjD0To-yVzYRtFk4lJh_1N9QTOduQCOg86qh4Uw2HyYm0po3wJCg0le"
}

local Setting = RerollsNotificationEvery

local plr = game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")

local cooldown = isfile("RerollCheck.txt") and readfile("RerollCheck.txt") or 0

cooldown = tonumber(cooldown) or 0

print("Modules Loaded RerollsNotificationEvery")

function RGBtoInt(r, g, b)
    local a = a or 255
    
    local rh = string.format("%02x", r)
    local gh = string.format("%02x", g)
    local bh = string.format("%02x", b)
    
    local hex = "0x" .. rh .. gh .. bh

    return tonumber(hex)
end

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

task.spawn(function()
    while true do
        local success, err = pcall(function()
            if cooldown - tick() < 0 then

                plrData = game.ReplicatedStorage.Remotes.GetPlayerData:InvokeServer()
                
                local data = {
                    ["content"] = "",
                    ["embeds"] = {
                        {
                            ["title"] = "Anime Last Stands",
                            ["description"] = `<:Icons:1047821411110105088>Username: ||{plr.Name}||\n Total Technique: {plrData.Rerolls}<:RerollShardPack:1279804156412166155>`,
                            ["thumbnail"] = {
                                url = GetAvatarThumbnail(plr.UserId)
                            },
                            ["color"] = RGBtoInt(255, 255, 255),
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
                    ["Url"] = Setting["Webhook"],
                    ["Method"] = "POST",
                    ["Body"] = game.HttpService:JSONEncode(data),
                    ["Headers"] = {
                        ["content-type"] = "application/json"
                    }
                })

                if response.StatusCode < 300 then
                    cooldown = tick() + Setting["Minutes"] * 60
                    writefile("RerollCheck.txt", tostring(cooldown))
                end
            end
        end)

        if not success then
            print("error:", err)
        end
        wait()
    end
end)
