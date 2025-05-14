game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Joiner Cooldown"] = 0,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Act1",
		["Stage"] = "Planet Namak"
	},
	["Macros"] = {
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
	},
	["Love Portal Joiner"] = {
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		},
		["Tier Cap"] = 10
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Intensity"] = 200,
		["First Team"] = 1,
		["Cash Out Floor"] = 5
	},
	["Winter Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Shibuya Aftermath"] = 2,
				["Spider Forest"] = 1,
				["Planet Namak"] = 3
			}
		}
	},
	["Claimer"] = {
		["Auto Claim Milestone"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
		["Shibuya Station"] = {
			["Upgrade Amount"] = 0,
			["Auto Mohato"] = true,
			["Leave Extra Money"] = 2000,
			["Mohato Unit"] = {
				["Cu Chulainn (Child of Light)"] = true,
				["Saber (Alternate)"] = true,
				["Smith John"] = true,
				["Gazelle (Zombie)"] = true,
				["Boockleo (Evil)"] = true,
				["Roku (Angel)"] = true,
				["Ichiga (True Release)"] = true,
				["Karem (Chilled)"] = true,
				["Song Jinwu (Monarch)"] = true,
				["Sosuke (Hebi)"] = true,
				["Ichiga (Savior)"] = true,
				["Tuji (Sorcerer Killer)"] = true,
				["Roku (Super 3)"] = true,
				["Haruka Rin"] = true,
				["Saber (King of Knights)"] = true,
				["Legendary Super Brolzi"] = true,
				["Akazo (Destructive)"] = true,
				["Noruto (Six Tails)"] = true,
				["Lilia and Berserker"] = true,
				["Archer (Counter Spirit)"] = true,
				["Dave (Cyber Psycho)"] = true,
				["Saber (Black Tyrant)"] = true,
				["Tengon (Flashiness)"] = true,
				["Isdead (Romantic)"] = true,
				["Alocard (Vampire King)"] = true,
				["Medusa (Gorgon)"] = true,
				["Roku (Dark)"] = true,
				["Ultimate Rohan"] = true,
				["Zion (Burdelyon)"] = true,
				["Noruto (Sage)"] = true,
				["Julias (Eisplosion)"] = true,
				["Yuruicha (Raijin)"] = true,
				["Bootonks (Evil)"] = true,
				["Todu (Unleashed)"] = true,
				["Clatakiri (Mochi)"] = true,
				["Emmie (Ice Witch)"] = true,
				["Johnni (Infinite Spin)"] = true,
				["Ishtar (Divinity)"] = true,
				["Kempache (Feral)"] = true,
				["Oryo (Antithesis)"] = true,
				["Luce (Hacker)"] = true,
				["Song Jinwu and Igros"] = true,
				["Super Vogito"] = true,
				["Vogita Super (Awakened)"] = true,
				["Bomberetta (Zombie)"] = true,
				["Giro (Ball Breaker)"] = true,
				["Hercool and Mr Boo"] = true,
				["Medea (Witch of Betrayal)"] = true,
				["Choy Jong En (Guild Leader)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Sokora (Angra Mainyu)"] = true,
				["Regnaw (Rage)"] = true,
				["Jag-o (Volcanic)"] = true,
				["Yehowach (Almighty)"] = true,
				["Gujo (Infinity)"] = true,
				["Chaso (Blood Curse)"] = true,
				["Diogo (Alternate)"] = true,
				["Sosuke (Storm)"] = true,
				["Igros (Elite Knight)"] = true,
				["Eizan (Aura)"] = true,
				["Divalo (Requiem)"] = true,
				["Cha-In (Blade Dancer)"] = true,
				["Valentine (Love Train)"] = true,
				["Vogita (Angel)"] = true,
				["Boo (Evil)"] = true,
				["Totsero (Zombie)"] = true,
				["Valentine (AU)"] = true,
				["Dawntay (Jackpot)"] = true,
				["Rogita (Super 4)"] = true,
				["Saber (A.W.E.)"] = true,
				["Super Boo (Evil)"] = true,
				["Rom and Ran (Fanatic)"] = true,
				["Dodara (Explosive)"] = true,
				["Yomomata (Captain)"] = true,
				["Obita (Awakened)"] = true,
				["Renguko (Purgatory)"] = true,
				["Foboko (Hellish)"] = true,
				["Rom and Ran"] = true,
				["Deruta (Hunt)"] = true,
				["Soburo (Contract)"] = true,
				["Pweeny (Boxer)"] = true,
				["Kid Boo (Evil)"] = true,
				["Friran (Teacher)"] = true,
				["Gilgamesh (King of Heroes)"] = true,
				["Lord of Shadows"] = true,
				["Kiskae (Scientist)"] = true,
				["Rogita (Super 4) (Clone)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Vigil (Power)"] = true,
				["Okorun (Turbo)"] = true,
				["Orehimi (Faith)"] = true,
				["Vigil (Doppelganger)"] = true,
				["Boohon (Evil)"] = true
			}
		},
		["Double Dungeon"] = {
			["Auto Statue"] = true,
			["Statue Unit"] = {
				["Cu Chulainn (Child of Light)"] = true,
				["Saber (Alternate)"] = true,
				["Smith John"] = true,
				["Gazelle (Zombie)"] = true,
				["Boockleo (Evil)"] = true,
				["Roku (Angel)"] = true,
				["Ichiga (True Release)"] = true,
				["Karem (Chilled)"] = true,
				["Song Jinwu (Monarch)"] = true,
				["Sosuke (Hebi)"] = true,
				["Ichiga (Savior)"] = true,
				["Tuji (Sorcerer Killer)"] = true,
				["Roku (Super 3)"] = true,
				["Haruka Rin"] = true,
				["Saber (King of Knights)"] = true,
				["Legendary Super Brolzi"] = true,
				["Akazo (Destructive)"] = true,
				["Noruto (Six Tails)"] = true,
				["Lilia and Berserker"] = true,
				["Archer (Counter Spirit)"] = true,
				["Dave (Cyber Psycho)"] = true,
				["Saber (Black Tyrant)"] = true,
				["Tengon (Flashiness)"] = true,
				["Isdead (Romantic)"] = true,
				["Alocard (Vampire King)"] = true,
				["Medusa (Gorgon)"] = true,
				["Roku (Dark)"] = true,
				["Ultimate Rohan"] = true,
				["Zion (Burdelyon)"] = true,
				["Noruto (Sage)"] = true,
				["Julias (Eisplosion)"] = true,
				["Yuruicha (Raijin)"] = true,
				["Bootonks (Evil)"] = true,
				["Todu (Unleashed)"] = true,
				["Clatakiri (Mochi)"] = true,
				["Emmie (Ice Witch)"] = true,
				["Johnni (Infinite Spin)"] = true,
				["Ishtar (Divinity)"] = true,
				["Kempache (Feral)"] = true,
				["Oryo (Antithesis)"] = true,
				["Luce (Hacker)"] = true,
				["Song Jinwu and Igros"] = true,
				["Super Vogito"] = true,
				["Vogita Super (Awakened)"] = true,
				["Bomberetta (Zombie)"] = true,
				["Giro (Ball Breaker)"] = true,
				["Hercool and Mr Boo"] = true,
				["Medea (Witch of Betrayal)"] = true,
				["Choy Jong En (Guild Leader)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Sokora (Angra Mainyu)"] = true,
				["Regnaw (Rage)"] = true,
				["Jag-o (Volcanic)"] = true,
				["Yehowach (Almighty)"] = true,
				["Gujo (Infinity)"] = true,
				["Chaso (Blood Curse)"] = true,
				["Diogo (Alternate)"] = true,
				["Sosuke (Storm)"] = true,
				["Igros (Elite Knight)"] = true,
				["Eizan (Aura)"] = true,
				["Divalo (Requiem)"] = true,
				["Cha-In (Blade Dancer)"] = true,
				["Valentine (Love Train)"] = true,
				["Vogita (Angel)"] = true,
				["Boo (Evil)"] = true,
				["Totsero (Zombie)"] = true,
				["Valentine (AU)"] = true,
				["Dawntay (Jackpot)"] = true,
				["Rogita (Super 4)"] = true,
				["Saber (A.W.E.)"] = true,
				["Super Boo (Evil)"] = true,
				["Rom and Ran (Fanatic)"] = true,
				["Dodara (Explosive)"] = true,
				["Yomomata (Captain)"] = true,
				["Obita (Awakened)"] = true,
				["Renguko (Purgatory)"] = true,
				["Foboko (Hellish)"] = true,
				["Rom and Ran"] = true,
				["Deruta (Hunt)"] = true,
				["Soburo (Contract)"] = true,
				["Pweeny (Boxer)"] = true,
				["Kid Boo (Evil)"] = true,
				["Friran (Teacher)"] = true,
				["Gilgamesh (King of Heroes)"] = true,
				["Lord of Shadows"] = true,
				["Kiskae (Scientist)"] = true,
				["Rogita (Super 4) (Clone)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Vigil (Power)"] = true,
				["Okorun (Turbo)"] = true,
				["Orehimi (Faith)"] = true,
				["Vigil (Doppelganger)"] = true,
				["Boohon (Evil)"] = true
			},
			["Leave Extra Money"] = 2000,
			["Upgrade Amount"] = 0
		},
		["Auto Sell"] = {
			["Wave"] = 1
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Wave"] = 1
			}
		},
		["Ruined City"] = {
			["Use Mount to Travel"] = true
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Enable"] = true,
				["Shadow"] = "Belu"
			}
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Restart"] = {
			["Wave"] = 1
		},
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Use Ability"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		}
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = true
	},
	["Misc"] = {
		["Max Camera Zoom"] = 40
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Modifier"] = {
				["Immunity"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 99,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 100,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			},
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["Drowsy"] = 0,
				["Lifeline"] = 0,
				["King's Burden"] = 0,
				["Regen"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["No Trait No Problem"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = true,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = true,
		["Replay Amount"] = 0,
		["Return Lobby Failsafe"] = true,
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Crafter"] = {
		["Essence Stone"] = {
			["Pink Essence Stone"] = true,
			["Blue Essence Stone"] = true,
			["Red Essence Stone"] = true,
			["Yellow Essence Stone"] = true,
			["Purple Essence Stone"] = true
		},
		["Essence Stone Limit"] = {
			["Pink Essence Stone"] = 50,
			["Blue Essence Stone"] = 50,
			["Red Essence Stone"] = 50,
			["Yellow Essence Stone"] = 50,
			["Purple Essence Stone"] = 50
		}
	},
	["Failsafe"] = {
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = true
	},
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Weekly Challenge Joiner"] = {
		["Auto Join"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = -1
		},
		["Enable"] = true,
		["Upgrade Method"] = "Hotbar left to right (until Max)",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Planet Namak"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Martial Island"] = "Middle",
			["Ruined City"] = "Middle",
			["Ant Island"] = "Middle",
			["Cavern"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Blood-Red Chamber"] = "Middle"
		},
		["Upgrade Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		},
		["Focus on Farm"] = true,
		["Middle Position"] = {
			["Shibuya Aftermath"] = "223.9261474609375, 514.7516479492188, 60.541473388671875",
			["Double Dungeon"] = "-268.2764892578125, 0.10069097578525543, -119.23352813720703",
			["Planet Namak"] = "501.3750915527344, 2.062572717666626, -334.1931457519531",
			["Kuinshi Palace"] = "395.2952880859375, 268.38262939453125, 114.03340148925781",
			["Golden Castle"] = "-100.51405334472656, -0.16030120849609375, -210.62820434570312",
			["Spider Forest"] = "-324.47222900390625, 1644.5369873046875, -319.5542297363281",
			["Land of the Gods"] = "-158.61436462402344, 1.2214683294296265, 120.46851348876953"
		},
		["Place Gap"] = {
			["Double Dungeon"] = 2,
			["Cavern"] = 2,
			["Sand Village"] = 2,
			["Shibuya Aftermath"] = 2,
			["Mountain Shrine (Natural)"] = 2,
			["Kuinshi Palace"] = 2,
			["Land of the Gods"] = 2,
			["Golden Castle"] = 2,
			["Spirit Society"] = 2,
			["Tracks at the Edge of the World"] = 2,
			["Shibuya Station"] = 2,
			["Ruined City"] = 2,
			["Ant Island"] = 2,
			["Planet Namak"] = 2,
			["Martial Island"] = 2,
			["Underground Church"] = 2,
			["Spider Forest"] = 2,
			["Blood-Red Chamber"] = 2
		}
	},
	["Regular Challenge Joiner"] = {
		["Teleport Lobby new Challenge"] = true,
		["Auto Join"] = true,
		["Reward"] = "Trait Reroll Challenge"
	},
	["AutoExecute"] = true
}
getgenv().Key = "ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH"
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(5)until Joebiden
