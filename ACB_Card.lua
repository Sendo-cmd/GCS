repeat task.wait(20) until game:IsLoaded()

ACBCardNotification = {
    ["Chance"] = 100000,
    ["Webhook"] = {
        ["chopperaob"] = "https://discord.com/api/webhooks/1293176845331726366/zP0nPfmTJn9Eg84aJL-bZX1QZF9TxvxezgFyDzi6Ssw_6s3LcVvPZWbUrWWvF0VA-ZKA",
        ["nowgodzz"] = "https://discord.com/api/webhooks/1293278164839039110/ifQL1F72pahjJvtddInKUzwTi1xXSToCTvAhk2qa4gfYOD_F4zZDOqt_ldqjhpiiInYD",
        ["a_454za"] = "https://discord.com/api/webhooks/1293369551169392722/l1NenfC_LkZmGCNAGhxwAZHeAcarDER7NLuRL-90c16E8-d5bqXZgt1bx8F1whrYdwSD",
        ["HamieKung"] = "https://discord.com/api/webhooks/1294550491816005684/oDTWEjkXSLnogJzsAtxT-490Wlp18vv_JxR83QKxYSylq8ereAQ3TTMxYPD3y7GX0rZc",
        ["MaxzTv"] = "https://discord.com/api/webhooks/1294587330337706048/m18BMlWXbW92n_dhhJUrWnF0_RPF70scfVHXDcga1iBQWAvWzRVc0g6eNDUxZakNHlv8",
        ["Miksaza1"] = "https://discord.com/api/webhooks/1296453433909579818/08NN5Fp0PwPuNKlEwmBPoFDTwR6Bm3JAZgIzRHqPhjZ4DlcODeKEvKsnd2KbP7eamgvy",
    }
}

local Setting = ACBCardNotification

local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer
local CardInfo;
local HelpfulModule;

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

print("Modules Loaded ACB")

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

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClientEffects").OnClientEvent:Connect(function(...)
    local args = {...}

    HelpfulModule = require(Modules.HelpfulModule)

    CardInfo = require(Modules.CardInfo).CardInfo

    if args[1] == "OpenQuickPack" then
        local CardChance = args[2].CardChance
        local CardName = args[2].CardName
        local Rarity = args[2].CardRarity

        if CardChance >= Setting["Chance"] then

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

            print("Sent Webhook")
        end
    end
end)

print("Loaded")
