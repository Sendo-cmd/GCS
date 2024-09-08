repeat task.wait(20) until game:IsLoaded()

ACBCardNotification = {
    ["Chance"] = 500000,
    ["Webhook"] = {
        ["Monooliaa_TH"] = "https://discord.com/api/webhooks/1279971994846101555/ANeo5MkMXZaJ8-0vxYEme5VDhGJhV1Lucs-8w7JfCYJ0FNWojec5K6_IWgq9mIDdPK55",
        ["Krv_kai43"] = "https://discord.com/api/webhooks/1281841266216276039/_nRzrWKIVEvuqRS9pp0MMHxKCcQCxCaStOlGu0_uhOHMdNUHAiqfc1YrsV7cuaN66rl8",
        ["Puggtopro"] = "https://discord.com/api/webhooks/1281991050835263520/IAgXcVnYeuRc0_DK_PpXZZbz3VinaVqnQ6ZLUCwAat2x79-0U1jyRVk45BG9slx-qcno",
        ["mbhl67679"] = "https://discord.com/api/webhooks/1282049202985373756/BJ1exJVnT7ve45-WxIhVW9ZtPwtCMAJ0pklZH2P2Vq4VPWhZRoZSnJwVfEcLXW-ED4d7",
        ["Nelida5865"] = "https://discord.com/api/webhooks/1282367730988613726/ZgvFAVVTjJ1UlQDN_pUfzTzKmZmZZqPY3DylZ6pgOKdHuQTWDXcb3Q_yrEWX7wzOObFM",
    }
}

local Setting = ACBCardNotification

local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

print("Modules Loaded ACB")

local HelpfulModule = require(Modules.HelpfulModule)

local CardInfo = require(Modules.CardInfo).CardInfo
local CardEffects = require(Modules.CardEffects)

function GetCardImage(Card)
    local AssetId = CardInfo[Card].Image:match("%d+")
    local url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. AssetId .. "&returnPolicy=PlaceHolder&size=700x700&format=Png&isCircular=false"
    local response = game:HttpGetAsync(url)
    local data = HttpService:JSONDecode(response)
    return data.data[1] and data.data[1].imageUrl or nil
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

function RGBtoInt(r, g, b)
    local a = a or 255
    
    local rh = string.format("%02x", r)
    local gh = string.format("%02x", g)
    local bh = string.format("%02x", b)
    
    local hex = "0x" .. rh .. gh .. bh

    return tonumber(hex)
end

local RarityColor = {
    Normal = {59, 59, 59},
    Gold = {255, 252, 71},
    Rainbow = {78, 40, 248},
    Universal = {50, 255, 215}
}

game:GetService("ReplicatedStorage").Remotes.ClientEffects.OnClientEvent:Connect(function(...)
    local args = {...}
    if args[1] == "OpenQuickPack" then
        local CardChance = args[2].CardChance
        local CardName = args[2].CardName
        local Rarity = args[2].CardRarity

        if CardChance < Setting["Chance"] then return end;

        local Stats = HelpfulModule.CalculateStats(CardName, Rarity)
        local Info = CardInfo[CardName]

        local data = {
            ["username"] = "Gaming Champion Shop",
            ["avatar_url"] = "https://media.discordapp.net/attachments/774011709358080021/1267843051997630535/hpfk2.1.png?ex=66dc5b5a&is=66db09da&hm=b1ccca5bd7c854a11e5ad76e4c4506bc0be8b215d718df30a399fe5e0e2495b0&=&format=webp&quality=lossless&width=490&height=488",
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "Anime Card Battle",
                    ["description"] = `Username: ||{plr.Name}||\n**Rolled Card**\nCard: {CardName} [{Rarity}]\n(1 in {HelpfulModule.FormatNumber(CardChance)})\nHealth: {Stats.Health}\nDamage: {Stats.Damage}\n` .. 'Description:```yaml\n' .. Info.Description .. '```',
                    ["thumbnail"] = {
                        url = GetAvatarThumbnail(plr.UserId)
                    },
                    ["color"] = RGBtoInt(unpack(RarityColor[Rarity])),
                    ["image"] = {
                        ["url"] = GetCardImage(CardName),
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
    end
end)
