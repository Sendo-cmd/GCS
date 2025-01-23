repeat  task.wait(40) until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")



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
        ["Evo"] = {"Dark Mage"},
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
    ["puggtopro"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story 
    },
    ["opoppoky"] = {
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
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
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
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
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Strange Town (Haunted)",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
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
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
    },
    ["FormatDataNumber63"] = {
        ["Select Mode"] = "Event", 
    
        ["Select Map"] = "Frozen Abyss", 
        ["Select Level"] = "1", 
        ["Hard"] = false,
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
        ["Select Mode"] = "Infinite", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Planet Greenie",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
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
        ["Select Mode"] = "Event", -- Raid , Legend Stage , Infinite
    
        ["Select Map"] = "Frozen Abyss",
        ["Select Level"] = 1, -- Story & Legend Stage & Raid
        ["Hard"] = false, -- Story
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
        ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
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

}

local Settings = {
    ["Select Mode"] = "Story", -- Raid , Legend Stage , Infinite , Event
    
    ["Select Map"] = "Planet Greenie",
    ["Select Level"] = "1", -- Story & Legend Stage & Raid
    ["Hard"] = false, -- Story 
    ["Evo"] = {""},
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
local Character = plr.Character or plr.CharacterAdded:Wait()
if _G.User[plr.Name] then
    for i,v in pairs(_G.User[plr.Name]) do
        Settings[i] = v
    end
end
local IgnoreInf = {
    ["item"] = "map",
}
local function GetRoom(Type)
    if Type == "Challenge" then
        for i, v in pairs(workspace._CHALLENGES.Challenges:GetChildren()) do
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
local function Next_(var)
    local duration = tick() + var
    repeat task.wait() until tick() >= duration
end
if #Settings["Evo"] >= 1 then
    -- can craft > normal > star
    local Units = require(game:GetService("ReplicatedStorage").src.Data.Units)
    local session = require(game.ReplicatedStorage.src.Loader).load_client_service(game:GetService("Players").LocalPlayer.PlayerScripts.main, "UnitCollectionServiceClient")["session"]
    local RaidShop = game:GetService("ReplicatedStorage").endpoints.client_to_server.request_current_raidshop_shop:InvokeServer()

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
    local function ConvertDisplayToTable(Display)
        for i,v in pairs(Units) do
            if v.name == Display then
                return v
            end
        end
        return "Not Found"
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
    for i,v in pairs(Settings["Evo"]) do
        local UnitData = ConvertDisplayToTable(v)
        if type(UnitData) == "table" then
            if CheckInventory(UnitData["evolve"]["evolve_unit"]) then
                -- Sent Notification to api
                print("Already Have Skip!")
                continue;
            end
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
            for i1,v1 in pairs(UnitData["evolve"]["normal"]["item_requirement"]) do
                if CheckItemValue(v1["item_id"]) < v1["amount"] then
                    local SaleEvent = ItemsForSaleEvent[v1["item_id"]]
                    local InRaidShop = RaidShop[v1["item_id"]]
                    if SaleEvent then
                        local Resource_ = SaleEvent["resource_cost"]["id"] 
                        if Resources()[Resource_] >= SaleEvent["resource_cost"]["amount"] then
                            local args = {
                                [1] = v1["item_id"],
                                [2] = "event",
                                [3] = Resource_ == "Candies" and "event_shop2" or  "event_shop",
                                [4] = "1"
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("buy_item_generic"):InvokeServer(unpack(args))
                            
                        else
                            ItemToFind = v1["item_id"]
                        end
                    else
                        ItemToFind = v1["item_id"]
                        break
                    end
                end
            end
            print(ItemToFind,"Here2")
            if not ItemToFind then
                local ID = nil
                for i,v in pairs(session["collection"]["collection_profile_data"]["owned_units"]) do
                    if v["unit_id"] == UnitData["id"] and v["_locked"] then
                        ID = v
                        break;
                    end
                end
                if not ID then
                    for i,v in pairs(session["collection"]["collection_profile_data"]["owned_units"]) do
                        if v["unit_id"] == UnitData["id"] then
                            ID = v
                            break;
                        end
                    end
                end
                -- print(ID["uuid"],ID["total_takedowns"])
                if UnitData["evolve"]["normal"]["_takedown_requirement"] and UnitData["evolve"]["normal"]["_takedown_requirement"] > (ID["total_takedowns"] or 0) then
                    ItemToFind = "Kill"
                    local args = {
                        [1] = "2"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("switch_team_loadout"):InvokeServer(unpack(args))
                    
                    break
                end
                -- local args = {
                --     [1] = ID["uuid"],
                --     [2] = false
                -- }
                
                -- game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("lock_unlock_unit"):InvokeServer(unpack(args))
                
                local args = {
                    [1] = ID["uuid"]
                }
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("evolve_unit"):InvokeServer(unpack(args))
               
                -- Sent Notification to api
            end
        end
    end
    
    print(ItemToFind,"Out")
    local ChallengeData = nil
    if ItemToFind then
        local RoomId = ""
        if ItemToFind == "Kill" then
            RoomId = "Kill"
        elseif table.find(Fruits,ItemToFind) then
            RoomId = "Challenge"
            ChallengeData = game:GetService("ReplicatedStorage").endpoints.client_to_server.get_normal_challenge:InvokeServer()
        else
            if ItemsForSaleEvent[ItemToFind] then
                local cost = temsForSaleEvent[ItemToFind]["resource_cost"]
                if cost["id"] == "Candies" then
                    RoomId = "_lobbytemplate_event3"
                elseif cost["id"] == "HolidayStars" then
                    RoomId = "_lobbytemplate_event4"
                end
            else
                RoomId = IgnoreInf[ItemToFind] or JoinConvert(GetMap(ItemToFind))
            end
        end 
        print(RoomId)
        local TeleportRoom = true
        local OldCframe = CFrame.new()
        while true do task.wait(.1)
            if RoomId == "Challenge" then
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
    return false
end

-- Normal Auto Join


CheckRoom = function()
    for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == tostring(game.Players.LocalPlayer.Name) then
                    return v.Name
                end
            end
        end
    end
    return false
end
CheckRoomRaid = function()
    for i, v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == tostring(game.Players.LocalPlayer.Name) then
                    return {true,v.Name}
                end
            end
        end
    end
    return {false}
end
function Room()
    for i, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == 'nil' then
                    return v.Name
                end
            end
        end
    end
end
function RoomRaid()
    for i, v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
        if v:IsA('Model') then
            for i1, v1 in pairs(v:GetChildren()) do
                if v1.Name == 'Owner' and tostring(v1.Value) == 'nil' then
                    return v.Name
                end
            end
        end
    end
end
function EventRoom()
    if Settings["Select Map"] == "Haunted Academy" then
        for i, v in pairs(workspace._DUNGEONS.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == "_lobbytemplate_event222" and tostring(v["Owner"]["Value"]) == "nil" then
                return v
            end
        end
    elseif Settings["Select Map"] == "Frozen Abyss" then
        for i, v in pairs(workspace._EVENT_CHALLENGES.Lobbies:GetChildren()) do
            if v:IsA('Model') and v.Name == "_lobbytemplate_event3" and tostring(v["Owner"]["Value"]) == "nil" then
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
spawn(function ()
	while true do
        local val,err = pcall(function ()
            if game.PlaceId == 8304191830  then
                if Settings["Select Mode"] == 'Story'then
                    if CheckRoom()[1] == true then
                        if TeleportRoom then
                            Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,Settings["Hard"] and "Hard" or "Normal")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                        Next_(5)
                    else
                        OldCframe = Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Infinite'then
                    if CheckRoom ()[1] == true then
                        if TeleportRoom then
                            Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])['infinite']['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                        Next_(5)
                    else
                        OldCframe = Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Legend Stage'then
                    if CheckRoom ()[1] == true then
                        if TeleportRoom then
                            Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoom()[2], JoinConvert(Settings["Select Map"])["levels"][Settings["Select Level"]]['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoom()[2])
                        Next_(5)
                    else
                        OldCframe = Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(Room())
                    end
                elseif Settings["Select Mode"] == 'Raid'then
                    if CheckRoomRaid()[1] == true then
                        if TeleportRoom then
                            Character.HumanoidRootPart.CFrame = OldCframe
                            Next_(.2)
                            TeleportRoom = false
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(CheckRoomRaid()[2], JoinConvert(Settings["Select Map"])['levels'][Settings["Select Level"]]['id'],true,"Hard")
                        Next_(.2)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(CheckRoomRaid()[2])
                        Next_(5)
                    else
                        OldCframe = Character.HumanoidRootPart.CFrame
                        TeleportRoom = true
                        Next_(.1)
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(RoomRaid())
                    end
                elseif Settings["Select Mode"] == 'Event'then
                    local RoomA = EventRoom()
                    print(RoomA)
                    if RoomA then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(RoomA.Name)
                        while tonumber(RoomA.Door.Surface.Status.Players.Text:split("/")[1]) > 1 or tonumber(RoomA.Door.Surface.Status.Players.Text:split("/")[1]) == 0 do

                        end
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_leave_lobby"):InvokeServer(RoomA.Name)
                    else 
                        Next_(2)
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