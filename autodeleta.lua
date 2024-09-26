local filesToDelete = {
    "Nousigi Hub/Macro/AnimeVanguards/LSDD3_SonjE2.json", 
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Alocard.json",
    "Nousigi Hub/Macro/AnimeVanguards/LSDD3_Sonj.json",
    "Nousigi Hub/Macro/AnimeVanguards/LSDD3_SonjE.json",
    "Nousigi Hub/Macro/AnimeVanguards/C_Namke.json",
    "Nousigi Hub/Macro/AnimeVanguards/C_Dung.json",
    "Nousigi Hub/Macro/AnimeVanguards/C_Sand.json",
    "Nousigi Hub/Macro/AnimeVanguards/GEM3.json",
    "Nousigi Hub/Macro/AnimeVanguards/GEM2.json",
    "Nousigi Hub/Macro/AnimeVanguards/GEM.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Ten.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Monarch_Ten.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Monarch_Song.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Monarch_Igris.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Igris.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Base.json",
    "Nousigi Hub/Macro/AnimeVanguards/Raid_Solar_Vogita.json",
}

for _, file in ipairs(filesToDelete) do
    delfile(file)
end
