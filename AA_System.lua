repeat  task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ApiUrl = "https://api.championshop.date/log-aa"

local InsertItem = require(game:GetService("ReplicatedStorage").src.Data.Items)
local ItemsForSaleEvent = require(game:GetService("ReplicatedStorage").src.Data.ItemsForSaleEvent)

--[[
Can Evo
Stringy
Elfy
Tamiki
Gene (Adult)
Fox Ninja (Demon Cloak)
Fairy Ruler
Kyko
Jackal
Smoka
Gamer Girl
Takamu
Morbid
Bodybuilder
Gunslinger
Waterfist
Siren
Frost Navy
Crush
Pirate King
Prayer Master
Flamefeather
Hubris (Day)
Carrot
Juozu
Magma
Eccentric Researcher
Ghost Lady
Elize
Gazu
Lucifer
Packy
Ghosty
Black Dog
Wratho
Doll
Elf Spirit
Cyborg (Overdrive)
Ant
Supreme Being
Hammerhead
Dark Mage
Lunar Hare
Illusionist (Betrayal)
Priest
Cream
Berserker
Honey
Hubris (Night)
Shizo
Fiery Commander
Lyla
Donut
Verdant Hero (String)
Scarlet Slayer
Tiger
Whitehair
Haze
Rebel
Itukoda
Mirror Ninja
Captain (Timeskip)
Void Spear
Paragon
Hex
Shade Sorceror
Thunder Maid
Aquatic Mage
InHuman
Hammer Giantess
Saka
Menace
Faker
Millie
Weather Girl
Cowardly
Cherub
Dragonslayer
Gravity Navy
Alien King
Joykid (Bounce)
Blaze Frost
Icy Dragon
Supersound
Crimson Thief
Paradox
Cold Mage
Black Blade
Chance
Cotton
Bunny
Delinquent (Serious)
Flame Hero
Infinity Mage
Blood
Illusionist (Fusion)
Gamer
Mangaka
Sword Queen
Vego
Iceclaw (Rebirth)
Mochi
Crystal Rose
Operator (Heart)
Skeleton
Puppet Girl
Gravity Mage
Lex
Reliable Student
Bubblegum
Lulu
Mimic Sorceror
Usurper
Dreamer
Golden King
Sepsis
Magic Disbeliever
Akemy
Crusader
Explosion Hero (Bang)
Iron Knight
Ratio
Griffin
Experiment X (Imperfect)
Umbra
Vego (Mage)
Agony (Path)
Idol
Enlightened
Fox Ninja (Sage)
Spearer
Toad Sensei
Brawler
Eta
Lightning God
Carrot (Super III)
Experiment X (Semi-Perfect)
Gas
Death Ninja
Fiend Girl
Dracula
Dolphin
Saki
Ghost-kun
Spirit Reaper (Dusk)
Connor
Ashborn
Wasp
Priest (New Moon)
Killer (Whirlwind)
Psychic Princess
Green Alien (Fusion)
Experiment X (Perfect)
Flower Ninja
Sharkfin
Lilia
Spirit Sniper
Mazara
Player
Izo (Black Fire)
Magic Girl
Trickster
Calm Killer
Shinobi (Hood)
Karma
Cat Guard
Elf Mage
Hermy
Blade Beast
Illusionist (Chrysalis)
Virtual Samurai
Skeleton Knight
Catgirl
Falcon
Sea God
Chunks
Dragon Knight
Golden Navy
Shinobi (Awakened)
Riony
Jelly
Weather
Origami
Illusionist
Ariva
Time Wizard
Vego (Super)
Silver Slayer
Bloodcry
Shadowgirl
Curse
Skater
Idol
Ice Queen
White Snake
Tango (Score)
Gene
Martial Demon
Spirit Archer
Tarata
Golden Tyrant
Prime Force
Jose (Shining Gem)
Red Scar
Shrimp
Bro
]]



--[[


[Story Mode]
Planet Greenie
Walled City
Snowy Town
Sand Village
Navy Bay
Fiend City
Spirit World
Ant Kingdom
Magic Town
Haunted Academy
Magic Hills
Space Center
Alien Spaceship
Fabled Kingdom
Ruined City
Puppet Island
Virtual Dungeon
Snowy Kingdom
Dungeon Throne
Mountain Temple
Rain Village

[Raid Mode]
Strange Town
Nightmare Train
Sacred Planet
Ruined City (The Menace)
Walled City
Future City (Tyrant's Invasion)
Navy's Ford (Buddha)
Sand Village
Future City
Cursed Festival
Storm Hideout

[Legend Stage]
Fabled Kingdom (Generals)
Spirit Invasion
Dungeon Throne
Space Center
Rain Village
Virtual Dungeon (Bosses)
Magic Hills (Elf Invasion)
Ruined City (Midnight)

[Event]
Haunted Academy
Frozen Abyss
Strange Town (Haunted)
]]



_G.User = {
    ["FireBlackDevilZ"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
        ["Party Mode"] = true,
        ["Party Member"] = {
            "jamess1280",
        },

    },
    ["SHIFUGOD"] = {
        ["Select Mode"] = "Raid", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town", 
        ["Select Level"] = "2", 
        ["Hard"] = false,
    },
    ["paopqo780"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["okillua006"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Puggtopro"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
        ["Auto Join"] = false, -- Story 
    },
    ["opoppoky"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["Naiza080947"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["TONKAORIKI_NEW"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["noop_45670"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false, -- Story
    },
    ["Lookmoo1987"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Kirito_VIJ"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["DDYUFCiSRHT"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Punpungoaway"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["ArutanKatsuki"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["TawanNoob1"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["okillua006"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["lwntrueman"] = {
        ["Party Mode"] = true, 
    },
    ["Nongneuftawchin"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Leokung_XD"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["just_testLOL"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["bombayzaza1234"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["maser080"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["04B38"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["caretone38"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["xx0073zx"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["runtz_32868"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["AASN_1"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["skdbsnxb"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Packky02"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["wooiy12"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["namnam12327"] = {
        ["Select Mode"] = "Raid", 
    
        ["Select Map"] = "Sacred Planet", 
        ["Select Level"] = "3", 
        ["Hard"] = false,
    },
    ["SugarSnow_17627"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["caretone38"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Bestganeryoutube"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["TPLshop_135148"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["yukilito001"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Thailand_chin"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["xdyrdgyrdfg"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["CGGG_TYUL2"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["FormatDataNumber"] = {
        ["Party Mode"] = true,
    },
    ["Etaa_xm"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["marutkord"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["wavenakub121"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["marutkord"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["supakitdunk"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Tokina_aaaaa"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["yuojkfgh"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["PeeVongzaTV"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["LM3FLO25"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["XDcggza4"] = {
        ["Party Mode"] = true,
    },
    ["HD111222"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["D_Dk05"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["momsans08"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Newbiethreepoint00"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["Du_ZraX05"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["noinual"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["BQT_OIM"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Wakoji4516"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["NoOneCareDisnameXD"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["jiwzanis"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["Saitamasankundes"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["trexefxtd"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["king_one248"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["phawadon014"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["sjsjsjsjgghd"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["KUNGNING"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
        ["Evo"] = {"Dark Mage"},
    },
    ["FormatDataNumber448"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
        ["Evo"] = {"Dreamer"},
    },
    ["pokpong4123"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["UOUSDFZF"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Vana_Ungkap"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
        ["Evo"] = {"Iceclaw (Rebirth)"},
    },
    ["igushi3"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["XDGGZTheGod"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["ifuyubf06"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["NayNaHeee"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["loremm382"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["torzasool"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["wavenakub121"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["sunprite23"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Senpai_DaisukiX2"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Katoy_2007"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["PerfectBoyz_VX"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["sonza567"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Radgoh_261"] = {
        ["Select Mode"] = "Raid", 
    
        ["Select Map"] = "Sacred Planet", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
    },
    ["2kgetmoneytoez"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["wakoji4516"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town (Haunted)",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["tomishop_25"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["pupu4582zxc"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["pocyuiou77"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["xiptid"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["MiNiKaiYungShop287"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["SB_Cr0w"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["bankuiok1"] = {
        ["Party Mode"] = true,
    },
    ["nuttaputlnw"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["YTJTP_Jittiphatn"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["MKFEOEF55"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["zwontop_KCFAQ"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Atitipost"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town (Haunted)",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["S_saihaa"] = {
        ["Select Mode"] = "Raid", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Sacred Planet", 
        ["Select Level"] = "3", 
        ["Hard"] = false,
    },
    ["nanemilk90"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Xwohogi_thailand"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["picoloveanime"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["May_SD232"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["zazatyuk"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town (Haunted)",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["pifcbvjj"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Sowldd96"] = {
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["sunprite23"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["RIXIEEDID"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite , Event
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = "1", -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["Demonjom2"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["euakungchannel"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town (Haunted)",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["underhorror"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["jim0021zx"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["bbcommasterb"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["micyk12345"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["HP_GTR"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Kemjud999"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["efv1z"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["gelatiExcotic_681"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["S78ONG"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["ZGG962"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["PrechaNewBie27Point"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["faeikgame"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["SDEgFGtxuid"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["SugarSnow_84782"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
        ["Auto Join"] = false,
    },
    ["as_01999"] = {
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Rami_AlKindi23"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["LDtwo_03"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["Embeberr1043"] = {
        ["Party Mode"] = true,
    },
    ["jamess1280"] = {
        ["Party Mode"] = true,
    },

}

local Settings = {
    ["Auto Join"] = true,
    ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
    ["Select Map"] = "Planet Greenie",
    ["Select Level"] = "1", -- Story & Legend Stage & Raid
    ["Hard"] = false, -- Story 
    ["Evo"] = false,
    ["Party Mode"] = false,
    ["Ignore"] = {
        -- "tank_enemies",
        -- "fast_enemies",
        -- "short_range",
        "godspeed_enemies",
        -- "regen_enemies",
        -- "short_range_2",
        -- "flying_enemies",
        "burst_enemies",
        -- "shield_enemies",
        "triple_cost",
        -- "mini_range",
        -- "double_cost",
        -- "armored_enemies",
        -- "hyper_shield_enemies",
        -- "hyper_regen_enemies",
    },
    ["Merchant"] = {
        "StarFruit",
        "StarFruitEpic",
        "StarFruitGreen",
        "StarFruitRed",
        "StarFruitPink",
        "StarFruitBlue",
    }
}

local plr = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local Character = plr.Character or plr.CharacterAdded:Wait()
if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end
local IgnoreInf = {
    ["item"] = "map",
}
local function SendWebhook(evo)
    local plr = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    local Current = "silver_christmas"

    local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
    local collection_profile_data = session["collection"]["collection_profile_data"]
    local profile_data = session["profile_data"]
    local battlepass_data = profile_data["battlepass_data"][Current]
    local equipped_units = collection_profile_data["equipped_units"]
    local owner = collection_profile_data["owned_units"]
    local Function = require(game.ReplicatedStorage.src.Loader).load_core_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "TraitServiceCore")["calculate_stat_rank"]

    local Battleplass = require(game:GetService("ReplicatedStorage").src.Data.BattlePass)
    local Units = require(game:GetService("ReplicatedStorage").src.Data.Units)

    local CalcLevel = function() end 
    for i,v in pairs(getgc()) do
        if type(v) == "function" and getinfo(v).name == "calculate_level" then
            CalcLevel = v
        end
    end
    for i,v in pairs(owner) do
        v["Display"] = Units[v["unit_id"]]["name"]
        v["TraitDisplay"] = {}
        v["Level"] = CalcLevel(v["unit_id"],v["xp"])
        for i1,v1 in pairs(v["trait_stats"]) do
            local f = Function(v["unit_id"],v,i1,v1)
            v["TraitDisplay"][i1] = f
        end
    end
    -- setclipboard(HttpService:JSONEncode(owner))
    local function BattleLevel()
        local CurrentLevel = 0
        for i = 1,Battleplass[Current]["total_tiers"] do
            local Data = Battleplass[Current]["tiers"][tostring(i)]
            if battlepass_data["xp"] > Data["xp_required"] then
                CurrentLevel = i
            else
                break
            end
        end
        return CurrentLevel
    end

    local function Equipped_Display()
        local Display = {}
        for i,v in pairs(equipped_units) do
            table.insert(Display,owner[v])
        end
        return Display
    end
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("spawn_units"):WaitForChild("Lives")
    if evo then
        local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
        local response = request({
            ["Url"] = ApiUrl,
            ["Method"] = "POST",
            ["Headers"] = {
                ["content-type"] = "application/json"
            },
            ["Body"] = HttpService:JSONEncode({
                ["Method"] = "Update",
                ["Place"] = "Lobby",
                ["Username"] = plr.Name,
                ["inventory"] = session["inventory"]["inventory_profile_data"],
                ["Evo"] = evo,
                ["equipped_units"] = Equipped_Display(),
                ["battle_level"] = BattleLevel(),
                ["allunit"] = owner,
                ["Gold"] = plr._stats.gold_amount.Value,
                ["Gem"] =  plr._stats.gem_amount.Value,
                ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                ["GuildId"] = "467359347744309248",
                ["DataKey"] = "GamingChampionShopAPI",
            })
        })
        for i,v in pairs(response) do
            print(i,v)
        end
    else
        if game.PlaceId == 8304191830  then
            local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
            local response = request({
                ["Url"] = ApiUrl,
                ["Method"] = "POST",
                ["Headers"] = {
                    ["content-type"] = "application/json"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["Method"] = "Update",
                    ["Place"] = "Lobby",
                    ["Username"] = plr.Name,
                    ["inventory"] = session["inventory"]["inventory_profile_data"],
                    ["equipped_units"] = Equipped_Display(),
                    ["battle_level"] = BattleLevel(),
                    ["allunit"] = owner,
                    ["Gold"] = plr._stats.gold_amount.Value,
                    ["Gem"] =  plr._stats.gem_amount.Value,
                    ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                    ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                    ["GuildId"] = "467359347744309248",
                    ["DataKey"] = "GamingChampionShopAPI",
                })
            })
            for i,v in pairs(response) do
                print(i,v)
            end
        else
            game:GetService("ReplicatedStorage").endpoints.server_to_client.game_finished.OnClientEvent:Connect(function(g)
                local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
                local response = request({
                    ["Url"] = ApiUrl,
                    ["Method"] = "POST",
                    ["Headers"] = {
                        ["content-type"] = "application/json"
                    },
                    ["Body"] = HttpService:JSONEncode({
                        ["Method"] = "Update",
                        ["Place"] = "Game",
                        ["Username"] = plr.Name,
                        ["inventory"] = session["inventory"]["inventory_profile_data"],
                        ["equipped_units"] = Equipped_Display(),
                        ["battle_level"] = BattleLevel(),
                        ["allunit"] = owner,
                        ["Gold"] = plr._stats.gold_amount.Value,
                        ["Gem"] =  plr._stats.gem_amount.Value,
                        ["HolidayStars"] = plr._stats._resourceHolidayStars.Value,
                        ["Level"] = game.Players.LocalPlayer.PlayerGui["spawn_units"].Lives.Main.Desc.Level.Text:split('Level ')[2],
                        ["Rewards"] = g,
                        ["MapInfo"] = workspace._MAP_CONFIG.GetLevelData:InvokeServer(),
                        ["GuildId"] = "467359347744309248",
                        ["DataKey"] = "GamingChampionShopAPI",
                    })
                })
                for i,v in pairs(response) do
                    print(i,v)
                end
            end)
        end
    end
    
end

local function GetRoom(Type)
    if Type == "Challenge" then
        for i, v in pairs(workspace._CHALLENGES.Challenges:GetChildren()) do
            if v:IsA('Model') and v["Active"].Value == false then
                return v
            end
        end
    elseif Type == "Raid" then
        for i, v in pairs(workspace._RAID.Raid:GetChildren()) do
            if v:IsA('Model') and v["Active"].Value == false then
                return v
            end
        end
    elseif Type == "_lobbytemplate_event3" or Type == "_lobbytemplate_event4"then
        for i, v in pairs(workspace._EVENT_CHALLENGES.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == Type and v["Active"].Value == false then
                return v
            end
        end
    else
        for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
            if v:IsA('Model') and v["Owner"].Value == nil then
                return v
            end
        end
    end
   
    return false
end
function JoinConvert(args)
    return require(game:GetService("ReplicatedStorage").src.Data.Worlds)[args]["infinite"]["id"]
end
function RaidConvert(arg)
    for i,v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Worlds)) do
        if v.name == arg then 
            return v["levels"]["1"]["id"]
        end
    end
end
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
local socket 
if Settings["Party Mode"]  then
    if game.PlaceId == 8304191830 then
        if Settings["Party Mode"] and not Settings["Party Member"] then
            wait(math.random(2,14))
        end
        socket = WebSocket.connect("wss://api.championshop.date/websocket")
       
        local function Pcheck(name)
            for i,v in pairs(game:GetService("Players"):GetChildren()) do
                if v.Name == name then
                    return true
                end
            end
            return false
        end
        function AllPlayerInGame()
            for i,v in pairs(Settings["Party Member"]) do
                if not game:GetService("Players"):FindFirstChild(v) then
                    return false
                end
            end
            return true
        end
       function CheckPlayerInRoom(Path,List)
            if Settings["Party Member"] then
                table.insert(List,plr.Name)
            end
            for i,v in pairs(Path["Players"]:GetChildren()) do
                if not table.find(List,tostring(v.Value)) then
                    print("False")
                    return false
                end
            end
            print("True")
            return true
        end
        local function JoinConvert(args)
            for i,v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Worlds)) do
                if v.name == args then
                    return v
                end
            end
        end
        local function GetRoom(Type)
            if Type == "Challenge" then
                for i, v in pairs(workspace._CHALLENGES.Challenges:GetChildren()) do
                    if v:IsA('Model') and v["Active"].Value == false then
                        return v
                    end
                end
            elseif Type == "Raid" then
                for i, v in pairs(workspace._RAID.Raid:GetChildren()) do
                    if v:IsA('Model') and v["Active"].Value == false then
                        return v
                    end
                end
            elseif Type == "_lobbytemplate_event3" or Type == "_lobbytemplate_event4"then
                for i, v in pairs(workspace._EVENT_CHALLENGES.Lobbies:GetChildren()) do
                    if v:IsA('Model') and v.Name == Type and v["Active"].Value == false then
                        return v
                    end
                end
            else
                for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
                    if v:IsA('Model') and v["Owner"].Value == nil then
                        return v
                    end
                end
            end
           
            return false
        end
        if Settings["Party Member"] then
            -- Host configs
            socket.OnMessage:Connect(function(msg)
                local data = HttpService:JSONDecode(msg)
                if data[1] == "Member" and table.find(Settings["Party Member"],data[2]) and not game:GetService("Players"):FindFirstChild(data[2]) then
                    Next_(2)
                    socket:Send(HttpService:JSONEncode({"Leader","Teleport",game.Players.LocalPlayer.Name, game.JobId}))
                end
            end) 
            -- For Host
        else
            -- Member configs
            socket.OnMessage:Connect(function(msg)
                local data = HttpService:JSONDecode(msg)
                if data[1] == "Leader" then
                    if data[2] == "Teleport" then
                        game:GetService("StarterGui"):SetCore("SendNotification",{
                            Title = "Teleporting", 
                            Text = "Leader By" .. data[3], 
                            Icon = "rbxassetid://1234567890" 
                        })
                        Next_(2)
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data[4], game.Players.LocalPlayer)
                    elseif data[2] == "Join" and data[3] == game.Players.LocalPlayer.Name then
                        print("Try To Join Room")
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(data[4])
                    end
                end
            end) 
            -- For Member
            spawn(function()
                while true do task.wait()
                    print("Send To Host")
                    local data = HttpService:JSONEncode({"Member",game.Players.LocalPlayer.Name})
                    socket:Send(data)
                    Next_(10)
                end    
            end)
            return false
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Waiting 20 Sec To Check Party", 
            Text = "Hope we will stay here", 
            Icon = "rbxassetid://1234567890" 
        })
        Next_(20)
        spawn(function()
            while true do wait()
                if Settings["Party Member"] then
                    if #Settings["Party Member"] + 1 ~= #game:GetService("Players"):GetChildren() then
                        for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Finished.Next.Activated)) do
                            v.Function()
                        end  
                    end
                else
                    local GetData = workspace._MAP_CONFIG.GetLevelData:InvokeServer()
                    if GetData["_number_of_lobby_players"] ~= #game:GetService("Players"):GetChildren() then
                        for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Finished.Next.Activated)) do
                            v.Function()
                        end  
                    end
                end
                Next_(30)
            end
        end)
        
    end
end



if Settings["Evo"] and game.PlaceId == 8304191830  then
    -- can craft > normal > star
    local Units = require(game:GetService("ReplicatedStorage").src.Data.Units)
    local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
    local RaidShop = game:GetService("ReplicatedStorage").endpoints.client_to_server.request_current_raidshop_shop:InvokeServer()
    local profile_data = session["profile_data"]
    local collection_profile_data = session["collection"]["collection_profile_data"]
    local getloadout = profile_data["loadouts_v2"]
    local farmfruit = getloadout["1"] and getloadout["1"]["saved_equipped"] or {}
    local farmkill = getloadout["2"] and getloadout["2"]["saved_equipped"] or {}
    local evounit = getloadout["3"] and getloadout["3"]["saved_equipped"] or {}
    local IsRaid = false
    local CoinToIsland = {}
    for i,v in pairs(RaidShop) do
        local cost = v["item_cost"]
        if cost and cost["item_id"] and not CoinToIsland[cost["item_id"]] then
            CoinToIsland[cost["item_id"]] = v["category"]
        end
    end
   
    
    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer("4")
    
    -- print(evounit)
    local Fruits = {
        "StarFruit",
        "StarFruitEpic",
        "StarFruitGreen",
        "StarFruitRed",
        "StarFruitPink",
        "StarFruitBlue",
    }
    for i,v in pairs(Settings["Merchant"]) do
        game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_travelling_merchant_item:InvokeServer(v)
    end
    local function Resources()
        return session["profile_data"]["resources"]
    end
    local function any_crafting(id)
        if InsertItem[id] and InsertItem[id]["crafting_recipe"] then
            return InsertItem[id]["crafting_recipe"]
        end
        return false
    end

    local function CheckInventory(id)
        for i,v in pairs(session["collection"]["collection_profile_data"]["owned_units"]) do
            if v["unit_id"] == id then
                return true
            end
        end
        return false
    end
    local function CheckItemValue(id)
        return session["inventory"]["inventory_profile_data"]["normal_items"][id] or 0
    end
    local function ReadyToCraft(crafting_recipe)
        for i,v in pairs(crafting_recipe) do
            if CheckItemValue(i) < v then
                return i
            end
        end
        return nil
    end
    local function CheckIgnoreChallenge(id)
        return table.find(Settings["Ignore"],id) or false
    end
    local function UnlockThisMap(id)
        return session["profile_data"]["level_data"]["completed_story_levels"][id] or false
    end
    local function GetMap(id)
        local Module = nil
        local GetWorld = nil
        local b = {}
        for i,v in pairs(game:GetService("ReplicatedStorage").src.Data.Items:GetChildren()) do
            if v:IsA("ModuleScript") then
                b[v.Name] = require(v)
            end
        end
        for i,v in pairs(b) do
            for i1,v1 in pairs(v) do
                if i1 == id then
                    Module = i
                end
            end
        end
        for i,v in pairs(b[Module]) do
            if v["xp_world"] then
                GetWorld = v["xp_world"]
                break
            end  
        end
        return GetWorld
    end
    local ItemToFind = nil
    local UUID = nil
    for i = 1,6,1 do

        UUID = evounit[tostring(i)]
        local ID = collection_profile_data["owned_units"][evounit[tostring(i)]]
        if not ID then
            continue;
        end
        print(ID)
        local UnitData = Units[ID["unit_id"]]
        if type(UnitData) == "table" then
            -- if CheckInventory(UnitData["evolve"]["evolve_unit"]) then
            --     -- Sent Notification to api
            --     print("Already Have Skip!")
            --     continue;
            -- end
            -- FindCrafting First
            for i = 1,2 do task.wait()
                for i1,v1 in pairs(UnitData["evolve"]["normal"]["item_requirement"]) do
                    if CheckItemValue(v1["item_id"]) < v1["amount"] then
                        local recipe = any_crafting(v1["item_id"])
                        if recipe then
                            while CheckItemValue(v1["item_id"]) < v1["amount"] do task.wait()
                                ItemToFind = ReadyToCraft(recipe)
                                if ItemToFind then
                                    break
                                end
                                print("Craft",v1["item_id"])
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("craft_item"):InvokeServer(v1["item_id"],"craft_evolve_items_ui")
                            end
                            if ItemToFind then
                                break
                            end                    
                        end
                    end
                end
            end
            if ItemToFind then
                break                
            end
            for i = 1,2 do task.wait()
                for i1,v1 in pairs(UnitData["evolve"]["normal"]["item_requirement"]) do
                    if CheckItemValue(v1["item_id"]) < v1["amount"] then
                        local SaleEvent = ItemsForSaleEvent[v1["item_id"]]
                        local InRaidShop = RaidShop[v1["item_id"]]
                        if InRaidShop then
                            local Resource_ = InRaidShop["item_cost"]
                            if CheckItemValue(Resource_["item_id"]) >= Resource_["amount"] then
                                while CheckItemValue(Resource_["item_id"]) >= Resource_["amount"] and CheckItemValue(v1["item_id"]) < v1["amount"] do 
                                    local args = {
                                        [1] = v1["item_id"],
                                        [2] = "1"
                                    }
                                    
                                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("buy_raidshop_shop_item"):InvokeServer(unpack(args)) 
                                    -- print(v1["item_id"],"1")
                                    task.wait()
                                end
                            else
                                IsRaid = true
                                ItemToFind = v1["category"]
                                break
                            end
                        elseif SaleEvent then
                            local Resource_ = SaleEvent["resource_cost"]["id"] 
                            if Resources()[Resource_] >= SaleEvent["resource_cost"]["amount"] then
                                while Resources()[Resource_] >= SaleEvent["resource_cost"]["amount"] and CheckItemValue(v1["item_id"]) < v1["amount"] do 
                                    local args = {
                                        [1] = v1["item_id"],
                                        [2] = "event",
                                        [3] = Resource_ == "Candies" and "event_shop2" or  "event_shop",
                                        [4] = "1"
                                    }
                                    
                                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("buy_item_generic"):InvokeServer(unpack(args))
                                end
                            else
                                ItemToFind = v1["item_id"]
                                break
                            end
                        elseif CoinToIsland[v1["item_id"]] then
                            ItemToFind = CoinToIsland[v1["item_id"]]
                            break
                        else
                            ItemToFind = v1["item_id"]
                            break
                        end
                    end
                end
            end
            if ItemToFind then
                break                
            end
          
            print(ItemToFind,"Here2")
            if not ItemToFind then
                -- print(ID["uuid"],ID["total_takedowns"])
                if UnitData["evolve"]["normal"]["_takedown_requirement"] and UnitData["evolve"]["normal"]["_takedown_requirement"] > (ID["total_takedowns"] or 0) then
                    ItemToFind = "Kill"
                    local args = {
                        [1] = "2"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
                    
                    break
                end
                local args = {
                    [1] = UUID
                }
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("evolve_unit"):InvokeServer(unpack(args))
                
                SendWebhook(UnitData["name"])

               
                -- Sent Notification to api
            end
        end
    end

    
    print(ItemToFind,"Out")
    local ChallengeData = nil
    if ItemToFind then
        local RoomId = ""
        if IsRaid then
            RoomId = RaidConvert(ItemToFind)
        elseif ItemToFind == "Kill" then
            RoomId = "Kill"
        elseif table.find(Fruits,ItemToFind) then
            RoomId = "Challenge"
            ChallengeData = game:GetService("ReplicatedStorage").endpoints.client_to_server.get_normal_challenge:InvokeServer()
        else
            if ItemsForSaleEvent[ItemToFind] then
                local cost = ItemsForSaleEvent[ItemToFind]["resource_cost"]
                if cost["id"] == "Candies" then
                    RoomId = "_lobbytemplate_event3"
                elseif cost["id"] == "HolidayStars" then
                    RoomId = "_lobbytemplate_event4"
                end
            else
                RoomId = IgnoreInf[ItemToFind] or JoinConvert(GetMap(ItemToFind))
            end
        end 
        -- Auto Equip
        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("unequip_all"):InvokeServer()
        if RoomId == "Kill" then
            for i,v in pairs(farmkill) do task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("equip_unit"):InvokeServer(v)
                Next_(.8)
            end
            Next_(.8)
            task.wait()
            print("kill",UUID)
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("equip_unit"):InvokeServer(UUID)
        else
            for i,v in pairs(farmfruit) do task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("equip_unit"):InvokeServer(v)
                Next_(.8)
            end
        end
        SendWebhook()
        if not Settings["Auto Join"] then
            return
        end
        local TeleportRoom = true
        local OldCframe = CFrame.new()
        while true do task.wait(.1)
            if Settings["Party Mode"] and Settings["Party Member"]  then
                if AllPlayerInGame() then
                    Next_(75)
                    print("Found All Players")
                    if AllPlayerInGame() then 
                        if IsRaid then
                            local Room = GetRoom("Raid")
                            repeat task.wait(.5)
                                if #Room["Players"]:GetChildren() == 0 then
                                    print("Join Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                    print("Settings Room")
                                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(Room.Name,RoomId,false,"Hard")
                                elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                    print("Found All Member In Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                    for i,v in pairs(Settings["Party Member"]) do
                                        if not Room["Players"]:FindFirstChild(v) then
                                            print("Leader Send To",v)
                                            socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                        end
                                    end
                                    Next_(3)
                                end
                            until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        elseif RoomId == "Challenge" then
                            if UnlockThisMap(ChallengeData["current_level_id"]) and not CheckIgnoreChallenge(ChallengeData["current_challenge"]) then
                                local Room = GetRoom(RoomId)
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                        print("Settings Room")
                                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(Room.Name,RoomId,false,"Hard")
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            else
                                ChallengeData = game:GetService("ReplicatedStorage").endpoints.client_to_server.get_normal_challenge:InvokeServer()
                            end
                        elseif RoomId == "_lobbytemplate_event3" or RoomId == "_lobbytemplate_event4" then
                            local Room = GetRoom(RoomId)
                            repeat task.wait(.5)
                                if #Room["Players"]:GetChildren() == 0 then
                                    print("Join Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                    print("Settings Room")
                                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(Room.Name,RoomId,false,"Hard")
                                elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                    print("Found All Member In Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                    for i,v in pairs(Settings["Party Member"]) do
                                        if not Room["Players"]:FindFirstChild(v) then
                                            print("Leader Send To",v)
                                            socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                        end
                                    end
                                    Next_(3)
                                end
                            until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        else
                            local Room = GetRoom(RoomId)
                            repeat task.wait(.5)
                                if #Room["Players"]:GetChildren() == 0 then
                                    print("Join Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                    print("Settings Room")
                                    if RoomId == "Kill" then
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert("naruto"),false,"Hard")
                                    else
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, RoomId,false,"Hard")
                                    end
                                elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                    print("Found All Member In Room")
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                    for i,v in pairs(Settings["Party Member"]) do
                                        if not Room["Players"]:FindFirstChild(v) then
                                            print("Leader Send To",v)
                                            socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                        end
                                    end
                                    Next_(3)
                                end
                            until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        end
                    end
                end 
            else
                if IsRaid then
                    local Room = GetRoom("Raid")
                    if Room then
                        local t = tick() + 10
                        repeat task.wait()
                            if Room["Owner"].Value then
                                if TeleportRoom then
                                    Character.HumanoidRootPart.CFrame = OldCframe
                                    Next_(.2)
                                    TeleportRoom = false
                                end
                                if RoomId == "Kill" then
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert("naruto"),true,"Hard")
                                else
                                    local args = {
                                        [1] = Room.Name,
                                        [2] = RoomId,
                                        [3] = true,
                                        [4] = "Hard"
                                    }
                                    
                                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(unpack(args))
    
                                    
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, RoomId,true,"Hard")
                                end
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                OldCframe = Character.HumanoidRootPart.CFrame
                                    TeleportRoom = true
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until tick() >= t or (Room["Owner"].Value and tostring(Room["Owner"].Value) ~= game.Players.LocalPlayer.Name) or (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) > 1 
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        TeleportRoom = true
                    end
    
                elseif RoomId == "Challenge" then
                    if UnlockThisMap(ChallengeData["current_level_id"]) and not CheckIgnoreChallenge(ChallengeData["current_challenge"]) then
                        local Room = GetRoom(RoomId)
                        if Room then
                            local t = tick() + 60
                            repeat task.wait()
                                if (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) == 1 then
                                    if TeleportRoom then
                                        Character.HumanoidRootPart.CFrame = OldCframe
                                        Next_(.2)
                                        TeleportRoom = false
                                    end
                                else
                                    OldCframe = Character.HumanoidRootPart.CFrame
                                    TeleportRoom = true
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                end
                            until tick() >= t or (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) > 1 
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            TeleportRoom = true
                        end
                    else
                        ChallengeData = game:GetService("ReplicatedStorage").endpoints.client_to_server.get_normal_challenge:InvokeServer()
                        Next_(25)
                    end
                elseif RoomId == "_lobbytemplate_event3" or RoomId == "_lobbytemplate_event4" then
                    local Room = GetRoom(RoomId)
                    if Room then
                        local t = tick() + 60
                        repeat task.wait()
                            if (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) == 1 then
                                if TeleportRoom then
                                    Character.HumanoidRootPart.CFrame = OldCframe
                                    Next_(.2)
                                    TeleportRoom = false
                                end
                            else
                                OldCframe = Character.HumanoidRootPart.CFrame
                                TeleportRoom = true
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until tick() >= t or (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) > 1 
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        TeleportRoom = true
                    end
                else
                    local Room = GetRoom(RoomId)
                    if Room then
                        local t = tick() + 10
                        repeat task.wait()
                            if Room["Owner"].Value then
                                if TeleportRoom then
                                    Character.HumanoidRootPart.CFrame = OldCframe
                                    Next_(.2)
                                    TeleportRoom = false
                                end
                                if RoomId == "Kill" then
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert("naruto"),true,"Hard")
                                else
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, RoomId,true,"Hard")
                                end
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                OldCframe = Character.HumanoidRootPart.CFrame
                                    TeleportRoom = true
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until tick() >= t or (Room["Owner"].Value and tostring(Room["Owner"].Value) ~= game.Players.LocalPlayer.Name) or (tonumber(Room.Door.Surface.Status.Players.Text:split("/")[1]) or 0) > 1 
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                        TeleportRoom = true
                    end
                end
            end
           
        end
    end
    return false
end

-- Normal Auto Join
if game.PlaceId == 8304191830 then
local function GetRoom()
    local Rooms = {}
    for i,v in pairs(workspace._LOBBIES.Story:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Players") and #v["Players"]:GetChildren() == 0 then
            table.insert(Rooms,v)
        end
    end
    return Rooms[math.random(1,#Rooms)]
end
local function GetRaidRoom()
    local Rooms = {}
    for i,v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Players") and #v["Players"]:GetChildren() == 0 then
            table.insert(Rooms,v)
        end
    end
    return Rooms[math.random(1,#Rooms)]
end

function EventRoom()
    
    if Settings["Select Map"] == "Haunted Academy" then
        for i, v in pairs(workspace._DUNGEONS.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == "_lobbytemplate_event222" and #v["Players"]:GetChildren() == 0 then
                return v
            end
        end
    elseif Settings["Select Map"] == "Frozen Abyss" then
        for i, v in pairs(workspace._EVENT_CHALLENGES.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == "_lobbytemplate_event3" and #v["Players"]:GetChildren() == 0 then
                return v
            end
        end
    elseif Settings["Select Map"] == "Strange Town (Haunted)" or "Plantet Greenie (Haunted)" or "Navy Bay (Midnight)" or "Walled City (Midnight)" or "Magic Town (Haunted)" then
        for i, v in pairs(workspace._EVENT_CHALLENGES.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == "_lobbytemplate_event4" and tostring(v["Owner"]["Value"]) == "nil" then
                return v
            end
        end
    end
    
    return false
end
function JoinConvert(args)
	for i,v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Worlds)) do
		if v.name == args then
			return v
		end
	end
end
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end

SendWebhook()
if not Settings["Auto Join"] then
    return
end
spawn(function ()
	while true do
        local val,err = pcall(function ()
            if game.PlaceId == 8304191830  then
                if Settings["Party Mode"] and Settings["Party Member"]  then
                    if AllPlayerInGame() then
                        Next_(75)
                        print("Found All Players")
                        if AllPlayerInGame() then 
                            if Settings["Select Mode"] == 'Story'then
                                local Room = GetRoom()
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                        print("Settings Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],false,Settings["Hard"] and "Hard" or "Normal")
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)                   
                            elseif Settings["Select Mode"] == 'Infinite'then
                                local Room = GetRoom()
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                        print("Settings Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['infinite']['id'],false,"Hard")
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            elseif Settings["Select Mode"] == 'Legend Stage'then
                                local Room = GetRoom()
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                        print("Settings Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])["levels"][Settings["Select Level"]]['id'],false,"Hard")
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            elseif Settings["Select Mode"] == 'Raid'then
                                local Room = GetRaidRoom()
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == 1 and Room.World.Value == "" then
                                        print("Settings Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],false,"Hard")
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            elseif Settings["Select Mode"] == 'Event'then
                                local Room = EventRoom()
                                repeat task.wait(.5)
                                    if #Room["Players"]:GetChildren() == 0 then
                                        print("Join Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() == #Settings["Party Member"] + 1 and CheckPlayerInRoom(Room,Settings["Party Member"]) then
                                        print("Found All Member In Room")
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                    elseif #Room["Players"]:GetChildren() ~= #Settings["Party Member"]  + 1 then
                                        for i,v in pairs(Settings["Party Member"]) do
                                            if not Room["Players"]:FindFirstChild(v) then
                                                print("Leader Send To",v)
                                                socket:Send(HttpService:JSONEncode({"Leader","Join",v,Room.Name}))
                                            end
                                        end
                                        Next_(3)
                                    end
                                until not CheckPlayerInRoom(Room,Settings["Party Member"]) or not AllPlayerInGame()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                            end
                        end
                    end
                else
                    if Settings["Select Mode"] == 'Story'then
                        local Room = GetRoom()
                        repeat task.wait()
                            if #Room["Players"]:GetChildren() == 1 then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,Settings["Hard"] and "Hard" or "Normal")
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until #Room["Players"]:GetChildren() > 1
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                    elseif Settings["Select Mode"] == 'Infinite'then
                        local Room = GetRoom()
                        repeat task.wait()
                            if #Room["Players"]:GetChildren() == 1 then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['infinite']['id'],true,"Hard")
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until #Room["Players"]:GetChildren() > 1
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                    elseif Settings["Select Mode"] == 'Legend Stage'then
                        local Room = GetRoom()
                        repeat task.wait()
                            if #Room["Players"]:GetChildren() == 1 then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])["levels"][Settings["Select Level"]]['id'],true,"Hard")
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until #Room["Players"]:GetChildren() > 1
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                    elseif Settings["Select Mode"] == 'Raid'then
                        local Room = GetRaidRoom()
                        repeat task.wait()
                            if #Room["Players"]:GetChildren() == 1 then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(Room.Name, JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,"Hard")
                                Next_(.2)
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(Room.Name)
                                Next_(5)
                            else
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until #Room["Players"]:GetChildren() > 1
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(Room.Name)
                    elseif Settings["Select Mode"] == 'Event'then
                        local Room = EventRoom()
                        repeat task.wait()
                            if #Room["Players"]:GetChildren() == 0 then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room.Name)
                            end
                        until #Room["Players"]:GetChildren() > 1
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(RoomA.Name)
                    end
                end
               
            end
        end)
        if not val then
            print(err)
        end
		task.wait()
	end
end)
else
    SendWebhook()
    local Priority = {
        ["+ New Path"] = 100,
        ["+ Double Attack"] = 99,
        ["+ Double Range"] = 98,
        ["+ Range I"] = 97,
        ["+ Range II"] = 91,
        ["+ Range III"] = 86,
        ["+ Cooldown I"] = 93,
        ["+ Cooldown II"] = 89,
        ["+ Cooldown III"] = 83,
        ["+ Attack I"] = 96,
        ["+ Attack II"] = 90,
        ["+ Attack III"] = 84,
        ["+ Random Blessings I"] = 76,
        ["+ Random Blessings II"] = 88,
        ["+ Random Blessings III"] = 85,
        ["+ Boss Damage I"] = 92,
        ["+ Boss Damage II"] = 87,
        ["+ Boss Damage III"] = 77,
        ["+ Yen I"] = 88,
        ["+ Yen II"] = 81,
        ["+ Yen III"] = 78,
        ["+ Active Cooldown I"] = 82,
        ["+ Active Cooldown II"] = 79,
        ["+ Active Cooldown III"] = 80,
        ["+ Enemy Health I"] = 95,
        ["+ Enemy Health II"] = 12,
        ["+ Enemy Health III"] = 13,
        ["+ Explosive Deaths I"] = 94,
        ["+ Explosive Deaths II"] = 14,
        ["+ Explosive Deaths III"] = 15,
        ["+ Enemy Regen I"] = 11,
        ["+ Enemy Regen II"] = 10,
        ["+ Enemy Regen III"] = 9,
        ["+ Enemy Shield I"] = 8,
        ["+ Enemy Shield II"] = 7,
        ["+ Enemy Shield III"] = 6,
        ["+ Enemy Speed I"] = 5,
        ["+ Enemy Speed II"] = 4,
        ["+ Enemy Speed III"] = 3,
        ["+ Random Curses I"] = 2,
        ["+ Random Curses II"] = 1,
        ["+ Random Curses III"] = 0,
    }
    local Tick = function(sec)
        local n = tick() + sec
        repeat wait() until tick() >= n
    end
    local Roguelike = workspace:WaitForChild("_DATA"):WaitForChild("Roguelike"):WaitForChild("WaitingForRoguelikeChoice")
    if Roguelike then
        Roguelike.Changed:Connect(function(v)
            if v then
                Tick(1)
                local GetBest = 0
                local Path = nil
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.RoguelikeSelect.Main.Main.Items:GetChildren()) do
                    if v:IsA("Frame") then 
                        local conti = math.random(1,99)
                        if (Priority[v.bg.Main.Title.TextLabel.Text] or conti) > GetBest then
                            GetBest = Priority[v.bg.Main.Title.TextLabel.Text] or conti
                            Path = v
                        end
                    end
                end
                for i1,v1 in pairs(getconnections(Path.Button["Activated"])) do
                    v1.Function()
                end
                for i1,v1 in pairs(getconnections(Path.Confirm["Activated"])) do
                    v1.Function()
                end
            end
        end)
    end
end
