game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Auto Join"] = true,
		["Act"] = "Act1",
		["Stage"] = "Planet Namak"
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Boss Event Joiner"] = 0,
				["Raid Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		},
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
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Auto Use Ability"] = true,
		["Double Dungeon"] = {
			["Auto Statue"] = true,
			["Statue Unit"] = {
				["Cu Chulainn (Child of Light)"] = true,
				["Saber (Alternate)"] = true,
				["Smith John"] = true,
				["Gazelle (Zombie)"] = true,
				["Boockleo (Evil)"] = true,
				["Roku (Angel)"] = true,
				["Karem (Chilled)"] = true,
				["Song Jinwu (Monarch)"] = true,
				["Regnaw (Rage)"] = true,
				["Ichiga (Savior)"] = true,
				["Tuji (Sorcerer Killer)"] = true,
				["Roku (Super 3)"] = true,
				["Haruka Rin"] = true,
				["Legendary Super Brolzi"] = true,
				["Akazo (Destructive)"] = true,
				["Ultimate Rohan"] = true,
				["Lilia and Berserker"] = true,
				["Johnni (Infinite Spin)"] = true,
				["Dave (Cyber Psycho)"] = true,
				["Saber (Black Tyrant)"] = true,
				["Yuruicha (Raijin)"] = true,
				["Ishtar (Divinity)"] = true,
				["Isdead (Romantic)"] = true,
				["Alocard (Vampire King)"] = true,
				["Medusa (Gorgon)"] = true,
				["Roku (Dark)"] = true,
				["Rogita (Super 4)"] = true,
				["Valentine (AU)"] = true,
				["Vigil (Doppelganger)"] = true,
				["Deruta (Hunt)"] = true,
				["Okorun (Turbo)"] = true,
				["Pweeny (Boxer)"] = true,
				["Zion (Burdelyon)"] = true,
				["Julias (Eisplosion)"] = true,
				["Gilgamesh (King of Heroes)"] = true,
				["Divalo (Requiem)"] = true,
				["Bootonks (Evil)"] = true,
				["Todu (Unleashed)"] = true,
				["Rogita (Super 4) (Clone)"] = true,
				["Lord of Shadows"] = true,
				["Emmie (Ice Witch)"] = true,
				["Tengon (Flashiness)"] = true,
				["Archer (Counter Spirit)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Noruto (Sage)"] = true,
				["Luce (Hacker)"] = true,
				["Noruto (Six Tails)"] = true,
				["Bomberetta (Zombie)"] = true,
				["Friran (Teacher)"] = true,
				["Hercool and Mr Boo"] = true,
				["Medea (Witch of Betrayal)"] = true,
				["Saber (King of Knights)"] = true,
				["Choy Jong En (Guild Leader)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Oryo (Antithesis)"] = true,
				["Sokora (Angra Mainyu)"] = true,
				["Sosuke (Hebi)"] = true,
				["Vogita Super (Awakened)"] = true,
				["Kempache (Feral)"] = true,
				["Ichiga (True Release)"] = true,
				["Orehimi (Faith)"] = true,
				["Yehowach (Almighty)"] = true,
				["Gujo (Infinity)"] = true,
				["Obita (Awakened)"] = true,
				["Chaso (Blood Curse)"] = true,
				["Igros (Elite Knight)"] = true,
				["Eizan (Aura)"] = true,
				["Sosuke (Storm)"] = true,
				["Clatakiri (Mochi)"] = true,
				["Super Boo (Evil)"] = true,
				["Rom and Ran (Fanatic)"] = true,
				["Cha-In (Blade Dancer)"] = true,
				["Diogo (Alternate)"] = true,
				["Vogita (Angel)"] = true,
				["Saber (A.W.E.)"] = true,
				["Boo (Evil)"] = true,
				["Totsero (Zombie)"] = true,
				["Valentine (Love Train)"] = true,
				["Dodara (Explosive)"] = true,
				["Yomomata (Captain)"] = true,
				["Renguko (Purgatory)"] = true,
				["Foboko (Hellish)"] = true,
				["Rom and Ran"] = true,
				["Soburo (Contract)"] = true,
				["Giro (Ball Breaker)"] = true,
				["Kid Boo (Evil)"] = true,
				["Super Vogito"] = true,
				["Kiskae (Scientist)"] = true,
				["Dawntay (Jackpot)"] = true,
				["Jag-o (Volcanic)"] = true,
				["Vigil (Power)"] = true,
				["Boohon (Evil)"] = true
			},
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 2
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
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = true,
				["Wave"] = 15
			},
			["Auto Sell Unit"] = {
				["Enable"] = false,
				["Wave"] = 1
			}
		},
		["Shibuya Station"] = {
			["Mohato Unit"] = {
				["Cu Chulainn (Child of Light)"] = true,
				["Saber (Alternate)"] = true,
				["Smith John"] = true,
				["Gazelle (Zombie)"] = true,
				["Boockleo (Evil)"] = true,
				["Roku (Angel)"] = true,
				["Karem (Chilled)"] = true,
				["Song Jinwu (Monarch)"] = true,
				["Regnaw (Rage)"] = true,
				["Ichiga (Savior)"] = true,
				["Tuji (Sorcerer Killer)"] = true,
				["Roku (Super 3)"] = true,
				["Haruka Rin"] = true,
				["Legendary Super Brolzi"] = true,
				["Akazo (Destructive)"] = true,
				["Ultimate Rohan"] = true,
				["Lilia and Berserker"] = true,
				["Johnni (Infinite Spin)"] = true,
				["Dave (Cyber Psycho)"] = true,
				["Saber (Black Tyrant)"] = true,
				["Yuruicha (Raijin)"] = true,
				["Ishtar (Divinity)"] = true,
				["Isdead (Romantic)"] = true,
				["Alocard (Vampire King)"] = true,
				["Medusa (Gorgon)"] = true,
				["Roku (Dark)"] = true,
				["Rogita (Super 4)"] = true,
				["Valentine (AU)"] = true,
				["Vigil (Doppelganger)"] = true,
				["Deruta (Hunt)"] = true,
				["Okorun (Turbo)"] = true,
				["Pweeny (Boxer)"] = true,
				["Zion (Burdelyon)"] = true,
				["Julias (Eisplosion)"] = true,
				["Gilgamesh (King of Heroes)"] = true,
				["Divalo (Requiem)"] = true,
				["Bootonks (Evil)"] = true,
				["Todu (Unleashed)"] = true,
				["Rogita (Super 4) (Clone)"] = true,
				["Lord of Shadows"] = true,
				["Emmie (Ice Witch)"] = true,
				["Tengon (Flashiness)"] = true,
				["Archer (Counter Spirit)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Noruto (Sage)"] = true,
				["Luce (Hacker)"] = true,
				["Noruto (Six Tails)"] = true,
				["Bomberetta (Zombie)"] = true,
				["Friran (Teacher)"] = true,
				["Hercool and Mr Boo"] = true,
				["Medea (Witch of Betrayal)"] = true,
				["Saber (King of Knights)"] = true,
				["Choy Jong En (Guild Leader)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Oryo (Antithesis)"] = true,
				["Sokora (Angra Mainyu)"] = true,
				["Sosuke (Hebi)"] = true,
				["Vogita Super (Awakened)"] = true,
				["Kempache (Feral)"] = true,
				["Ichiga (True Release)"] = true,
				["Orehimi (Faith)"] = true,
				["Yehowach (Almighty)"] = true,
				["Gujo (Infinity)"] = true,
				["Obita (Awakened)"] = true,
				["Chaso (Blood Curse)"] = true,
				["Igros (Elite Knight)"] = true,
				["Eizan (Aura)"] = true,
				["Sosuke (Storm)"] = true,
				["Clatakiri (Mochi)"] = true,
				["Super Boo (Evil)"] = true,
				["Rom and Ran (Fanatic)"] = true,
				["Cha-In (Blade Dancer)"] = true,
				["Diogo (Alternate)"] = true,
				["Vogita (Angel)"] = true,
				["Saber (A.W.E.)"] = true,
				["Boo (Evil)"] = true,
				["Totsero (Zombie)"] = true,
				["Valentine (Love Train)"] = true,
				["Dodara (Explosive)"] = true,
				["Yomomata (Captain)"] = true,
				["Renguko (Purgatory)"] = true,
				["Foboko (Hellish)"] = true,
				["Rom and Ran"] = true,
				["Soburo (Contract)"] = true,
				["Giro (Ball Breaker)"] = true,
				["Kid Boo (Evil)"] = true,
				["Super Vogito"] = true,
				["Kiskae (Scientist)"] = true,
				["Dawntay (Jackpot)"] = true,
				["Jag-o (Volcanic)"] = true,
				["Vigil (Power)"] = true,
				["Boohon (Evil)"] = true
			},
			["Auto Mohato"] = true,
			["Leave Extra Money"] = 2000,
			["Upgrade Amount"] = 0
		}
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = true
	},
	["Misc"] = {
		["Max Camera Zoom"] = 40
	},
	["Regular Challenge Joiner"] = {
		["Teleport Lobby new Challenge"] = true,
		["Auto Join"] = true,
		["Reward"] = "Trait Reroll Challenge"
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Auto Next"] = false,
		["Replay Amount"] = 0,
		["Return Lobby Failsafe"] = false,
		["Auto Return Lobby"] = false,
		["Auto Replay"] = true
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
	["Unit Feeder"] = {
		["Feed Level"] = 60
	},
	["Claimer"] = {
		["Auto Claim Quest"] = true,
		["Auto Claim Collection Milestone"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Milestone"] = true
	},
	["Auto Play"] = {
		["Auto Upgrade"] = {
			["Upgrade Order"] = {
				["1"] = 1,
				["3"] = 3,
				["2"] = 2,
				["5"] = 4,
				["4"] = 5,
				["6"] = 6
			},
			["Place and Upgrade"] = false,
			["Enable"] = true,
			["Focus on Farm"] = true,
			["Upgrade Method"] = "Customize upgrade order (Set below)",
			["Upgrade Limit"] = {
				["1"] = 0,
				["3"] = 0,
				["2"] = 0,
				["5"] = 0,
				["4"] = 0,
				["6"] = 0
			}
		},
		["Place Limit"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 1,
			["4"] = 1,
			["6"] = -1
		},
		["Enable"] = true,
		["Slot Position"] = {
			["Planet Namak (Spring)"] = {
				["1"] = "-179.81578063964844, 4.474977493286133, 79.28062438964844",
				["3"] = "-217.59719848632812, 4.474977493286133, 99.31828308105469",
				["2"] = "-179.81578063964844, 4.474977493286133, 79.28062438964844",
				["5"] = "-232.0775604248047, 4.474977493286133, 81.67100524902344",
				["4"] = "-195.3408203125, 4.474977493286133, 103.27470397949219"
			},
			["Double Dungeon"] = {
				["1"] = "-306.7845153808594, 0.10069097578525543, -133.49029541015625",
				["3"] = "-289.0335998535156, 0.10069097578525543, -119.9604263305664",
				["2"] = "-306.7845153808594, 0.10069097578525543, -133.49029541015625",
				["5"] = "-267.29034423828125, 0.10069097578525543, -117.80968475341797",
				["4"] = "-273.69866943359375, 0.10069097578525543, -131.36167907714844"
			},
			["Sand Village"] = {
				["1"] = "-215.588623046875, 180.48907470703125, -187.5686492919922",
				["3"] = "-262.0871887207031, 180.48907470703125, -182.75393676757812",
				["2"] = "-215.588623046875, 180.48907470703125, -187.5686492919922",
				["5"] = "-241.6250762939453, 180.48907470703125, -201.41159057617188",
				["4"] = "-241.6250762939453, 180.48907470703125, -201.41159057617188"
			},
			["Shining Castle"] = {
				["1"] = "8.990348815917969, 177.0242919921875, 94.46527862548828",
				["3"] = "30.23691177368164, 177.0242919921875, 93.9733657836914",
				["2"] = "8.990348815917969, 177.0242919921875, 94.46527862548828",
				["5"] = "34.03142166137695, 177.0242919921875, 94.1288070678711",
				["4"] = "30.236909866333008, 177.0242919921875, 93.9733657836914",
				["6"] = "24.314983367919922, 177.0242919921875, 94.10115814208984"
			},
			["Edge of Heaven"] = {
				["1"] = "-74.88941955566406, 147.29444885253906, -191.43138122558594",
				["3"] = "-37.48008728027344, 147.29444885253906, -187.0044708251953",
				["2"] = "-74.88941955566406, 147.29444885253906, -191.43138122558594",
				["5"] = "-40.70954132080078, 147.29444885253906, -163.8956298828125",
				["4"] = "-13.697235107421875, 147.29444885253906, -143.526611328125"
			},
			["Sun Temple"] = {
				["1"] = "-287.7659606933594, 17, -43.65013885498047",
				["3"] = "-272.98138427734375, 17, -21.578874588012695",
				["2"] = "-287.7659606933594, 17, -43.65013885498047",
				["5"] = "-250.30592346191406, 17, -20.356889724731445",
				["4"] = "-250.30592346191406, 17, -20.356889724731445"
			},
			["Land of the Gods"] = {
				["1"] = "-169.4282684326172, 1.2214683294296265, 172.20565795898438",
				["3"] = "-155.06321716308594, 1.2214683294296265, 139.90821838378906",
				["2"] = "-149.18563842773438, 1.2214683294296265, 119.05625915527344",
				["5"] = "-162.2090301513672, 1.2214683294296265, 190.0772705078125",
				["4"] = "-155.2731475830078, 1.2214683294296265, 139.9318389892578"
			},
			["Golden Castle"] = {
				["1"] = "-100.731201171875, -0.16030120849609375, -198.10171508789062",
				["3"] = "-100.68292999267578, -0.16030120849609375, -210.46243286132812",
				["2"] = "-100.731201171875, -0.16030120849609375, -198.10171508789062",
				["5"] = "-100.4898452758789, -0.16030120849609375, -217.75653076171875",
				["4"] = "-99.88970947265625, -0.16030120849609375, -164.28475952148438"
			},
			["Lebereo Raid"] = {
				["1"] = "131.16702270507812, 35.98725509643555, -362.08734130859375",
				["3"] = "131.42922973632812, 35.98725509643555, -317.7830810546875",
				["2"] = "131.16702270507812, 35.98725509643555, -362.08734130859375",
				["5"] = "127.52284240722656, 35.98725509643555, -297.4350891113281",
				["4"] = "127.52284240722656, 35.98725509643555, -297.4350891113281"
			},
			["Spirit Society"] = {
				["1"] = "184.03179931640625, -0.5, 626.1082763671875",
				["3"] = "199.83782958984375, -0.5, 656.2951049804688",
				["2"] = "184.03179931640625, -0.5, 626.1082763671875",
				["5"] = "196.43746948242188, -0.5, 616.7059326171875",
				["4"] = "196.43746948242188, -0.5, 616.7059326171875"
			},
			["Ant Island"] = {
				["1"] = "-25.97937774658203, 164.8186492919922, -79.39936828613281",
				["3"] = "-14.003511428833008, 164.8186492919922, -41.966617584228516",
				["2"] = "-25.97937774658203, 164.8186492919922, -79.39936828613281",
				["5"] = "-20.072811126708984, 164.8186492919922, -47.63435745239258",
				["4"] = "-13.39875316619873, 164.8186492919922, -47.81821060180664",
				["6"] = "-19.72206687927246, 164.8186492919922, -38.968353271484375"
			},
			["Martial Island"] = {
				["1"] = "-391.77728271484375, 136.8050537109375, -426.04345703125",
				["3"] = "-492.3119812011719, 136.8050537109375, -453.4399719238281",
				["2"] = "-391.77728271484375, 136.8050537109375, -426.04345703125",
				["5"] = "-373.097412109375, 136.8050537109375, -451.88714599609375",
				["4"] = "-373.097412109375, 136.8050537109375, -451.88714599609375"
			},
			["Ruined City"] = {
				["1"] = "1034.4703369140625, 6.927220821380615, -261.97369384765625",
				["3"] = "1014.772705078125, 6.927220821380615, -281.2123718261719",
				["2"] = "1034.4703369140625, 6.927220821380615, -261.97369384765625",
				["5"] = "1064.725830078125, 6.927220821380615, -280.1171875",
				["4"] = "1064.725830078125, 6.927220821380615, -280.1171875"
			},
			["Tracks at the Edge of the World"] = {
				["1"] = "1052.6724853515625, 143.2725830078125, -782.9486694335938",
				["3"] = "1041.09912109375, 143.2725830078125, -756.412353515625",
				["2"] = "1052.6724853515625, 143.2725830078125, -782.9486694335938",
				["5"] = "1075.2176513671875, 143.2725830078125, -761.3186645507812",
				["4"] = "1075.2176513671875, 143.2725830078125, -761.3186645507812"
			},
			["Shibuya Station"] = {
				["1"] = "-790.9635620117188, 9.356081008911133, -105.29301452636719",
				["3"] = "-769.8818969726562, 9.356081008911133, -118.41202545166016",
				["2"] = "-790.9635620117188, 9.356081008911133, -105.29301452636719",
				["5"] = "-765.84130859375, 9.356081008911133, -77.7351303100586",
				["4"] = "-768.3870239257812, 9.356081008911133, -75.20946502685547"
			},
			["Kuinshi Palace"] = {
				["1"] = "435.494140625, 268.38262939453125, 126.87104034423828",
				["3"] = "377.77899169921875, 268.38262939453125, 111.85942840576172",
				["2"] = "435.494140625, 268.38262939453125, 126.87104034423828",
				["5"] = "391.6142272949219, 268.38262939453125, 116.22864532470703",
				["4"] = "391.6142272949219, 268.38262939453125, 116.2286376953125"
			},
			["Planet Namak"] = {
				["1"] = "500.27032470703125, 2.062572717666626, -315.8484802246094",
				["3"] = "475.77581787109375, 2.062572717666626, -328.9787292480469",
				["2"] = "500.27032470703125, 2.062572717666626, -315.8484802246094",
				["5"] = "456.77398681640625, 2.062572717666626, -335.5212707519531",
				["4"] = "444.7925720214844, 2.062572717666626, -340.7905578613281"
			},
			["Crystal Chapel"] = {
				["1"] = "-528.9197998046875, 30, -58.566925048828125",
				["3"] = "-530.8161010742188, 30, -35.4738883972168",
				["2"] = "-528.9197998046875, 30, -58.566925048828125",
				["5"] = "-511.5249938964844, 30, -36.377960205078125",
				["4"] = "-530.8161010742188, 30, -35.4738883972168"
			},
			["Underground Church"] = {
				["1"] = "154.14126586914062, 0.30062153935432434, 81.40592956542969",
				["3"] = "194.0290069580078, 0.30062153935432434, 109.4067611694336",
				["2"] = "154.14126586914062, 0.30062153935432434, 81.40592956542969",
				["5"] = "205.50332641601562, 0.30062153935432434, 101.16437530517578",
				["4"] = "205.50332641601562, 0.30062153935432434, 101.16437530517578"
			},
			["Spider Forest"] = {
				["1"] = "-333.88629150390625, 1644.5369873046875, -298.0063171386719",
				["3"] = "-299.0950927734375, 1644.5369873046875, -372.88946533203125",
				["2"] = "-333.88629150390625, 1644.5369873046875, -298.0063171386719",
				["5"] = "-299.0950927734375, 1644.5369873046875, -372.88946533203125",
				["4"] = "-299.0950927734375, 1644.5369873046875, -372.88946533203125",
				["6"] = "-299.0950927734375, 1644.5369873046875, -372.88946533203125"
			},
			["Shibuya Aftermath"] = {
				["1"] = "210.99525451660156, 514.7516479492188, 75.6123275756836",
				["3"] = "223.87945556640625, 514.7516479492188, 60.87996292114258",
				["2"] = "210.99525451660156, 514.7516479492188, 75.6123275756836",
				["5"] = "195.07896423339844, 514.7516479492188, 43.59787368774414",
				["4"] = "195.07896423339844, 514.7516479492188, 43.59787368774414"
			}
		},
		["Place Order"] = {
			["1"] = 1,
			["3"] = 3,
			["2"] = 2,
			["5"] = 5,
			["4"] = 4,
			["6"] = 6
		},
		["Place Wave"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = 0,
			["6"] = 0
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["FPS"] = 5
		}
	},
	["Weekly Challenge Joiner"] = {
		["Auto Join"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Joiner Cooldown"] = 0,
	["Modifier"] = {
		["Restart Modifier"] = {
			["Modifier"] = {
				["Immunity"] = true
			}
		},
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 1,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 99,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 100,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			},
			["Enable"] = true,
			["Amount"] = {
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Champions"] = 0,
				["Fast"] = 0,
				["Planning Ahead"] = 0,
				["Immunity"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Slayer"] = 0,
				["Fisticuffs"] = 0,
				["Revitalize"] = 0,
				["Harvest"] = 0,
				["Quake"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Regen"] = 0,
				["King's Burden"] = 0,
				["Exterminator"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Cooldown"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 0,
				["Precise Attack"] = 0,
				["Shielded"] = 0,
				["Uncommon Loot"] = 0,
				["Money Surge"] = 0
			}
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden