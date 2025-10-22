game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["Auto Join Equipper"] = {
		["Macro Equipper"] = {
			["Enable"] = false
		},
		["Team Equipper"] = {
			["Enable"] = false
		}
	},
	["AutoSave"] = true,
	["Gold Buyer"] = {
		["Enable"] = false
	},
	["Joiner Cooldown"] = 0,
	["Stage Joiner"] = {
		["Join Highest"] = false,
		["Auto Join"] = false,
		["Nightmare Mode"] = false,
		["Join Lowest Clear"] = false
	},
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["Play"] = false,
		["Auto Equip"] = false,
		["No Ignore Sell Timing"] = true,
		["Joiner Team Equipper"] = {
			["Joiner Team"] = {
				["Raid Joiner"] = 0,
				["Daily Challenge Joiner"] = 0,
				["Legend Stage Joiner"] = 0,
				["Dungeon Joiner"] = 0,
				["Stage Joiner"] = 0,
				["Odyssey Joiner"] = 0,
				["Weekly Challenge Joiner"] = 0,
				["Regular Challenge Joiner"] = 0,
				["Worldline Joiner"] = 0,
				["Winter Portal Joiner"] = 0,
				["Boss Bounties Joiner"] = 0,
				["Boss Event Joiner"] = 0,
				["Spring Portal Joiner"] = 0,
				["Rift Joiner"] = 0
			}
		}
	},
	["Summer Event"] = {
		["Summer Event Joiner"] = {
			["Auto Join"] = false
		}
	},
	["Webhook"] = {
		["Unit Summoned"] = false,
		["Trait Rerolled"] = false,
		["Unit Stat Potential"] = false,
		["Stage Finished"] = false,
		["Stat Potential Rerolled"] = false,
		["Match Restarted"] = false
	},
	["Stat Reroller"] = {
		["Stat Potential"] = 100,
		["Teleport Lobby reach Stat Potential"] = false,
		["Enable"] = false,
		["Type"] = {
			["Damage"] = false,
			["All"] = false,
			["Range"] = false,
			["SPA"] = false
		},
		["Stat"] = {
			["神"] = false,
			["Z+"] = false,
			["S"] = false,
			["Z"] = false
		}
	},
	["Trait Reroller"] = {
		["Enable"] = false
	},
	["Odyssey Joiner"] = {
		["Second Team"] = 2,
		["Intensity"] = 200,
		["Cash Out Floor"] = 5,
		["Auto Join"] = false,
		["First Team"] = 1
	},
	["Summer Portal Joiner"] = {
		["Buy if out of Portal"] = false,
		["Tier Cap"] = 10,
		["Auto Join"] = false,
		["Ignore Modifier"] = {
			["Strong"] = false,
			["Thrice"] = false,
			["Regen"] = false,
			["Fast"] = false,
			["Revitalize"] = false,
			["Drowsy"] = false,
			["Exploding"] = false,
			["Dodge"] = false,
			["Quake"] = false,
			["Shielded"] = false,
			["Immunity"] = false,
			["Champions"] = false
		},
		["Auto Next"] = true,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Ignore Modifier"] = {
				["Strong"] = false,
				["Thrice"] = false,
				["Regen"] = false,
				["Fast"] = true,
				["Revitalize"] = false,
				["Drowsy"] = false,
				["Exploding"] = false,
				["Dodge"] = false,
				["Quake"] = false,
				["Immunity"] = false,
				["Shielded"] = true,
				["Champions"] = false
			}
		}
	},
	["AutoExecute"] = true,
	["Gameplay"] = {
		["Double Dungeon"] = {
			["Upgrade Amount"] = 2,
			["Statue Unit"] = {
				["Tuji (Sorcerer Killer)"] = true,
				["Goblin Killer (Trapper)"] = true,
				["Lilia and Berserker"] = true,
				["Alocard (Vampire King)"] = true,
				["Astolfo (Rider of Black)"] = true,
				["Eizan (Aura)"] = true,
				["Goi"] = true,
				["Byeken (Ronin)"] = true,
				["Dawntay (Jackpot)"] = true,
				["Medusa (Gorgon)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Kempache (Feral)"] = true,
				["Gazelle (Zombie)"] = true,
				["Valentine (Love Train)"] = true,
				["Sukono"] = true,
				["Noruto (Six Tails)"] = true,
				["Ackers (Levy)"] = true,
				["Lfelt (Love)"] = true
			},
			["Leave Extra Money"] = 2000,
			["Auto Statue"] = true
		},
		["Saber Event"] = {
			["Servant"] = "Berserker",
			["Auto Select Servant"] = false
		},
		["Steel Ball Run"] = {
			["Collect Steel Ball"] = false
		},
		["Random Sacrifice Domain"] = {
			["Sell Units on Event"] = false
		},
		["Edge of Heaven"] = {
			["Auto Join Lfelt Portal"] = false,
			["Pause instead of Joining"] = false
		},
		["Auto Skip Wave"] = {
			["Enable"] = true,
			["Stop Skip Stage Type"] = {
				["Odyssey"] = true,
				["Challenge"] = true,
				["Portal"] = true,
				["Worldline"] = true,
				["Legend Stage"] = true,
				["BossEvent"] = true,
				["Dungeon"] = true,
				["Infinite"] = true,
				["Rift"] = true,
				["Story"] = true,
				["Raid"] = true
			},
			["Stop at Wave"] = 0
		},
		["Auto Restart"] = {
			["Enable"] = false,
			["Wave"] = 1,
			["Stage Type"] = {
				["Odyssey"] = true,
				["Challenge"] = true,
				["Portal"] = true,
				["Worldline"] = true,
				["Legend Stage"] = true,
				["BossEvent"] = true,
				["Dungeon"] = true,
				["Infinite"] = true,
				["Rift"] = true,
				["Story"] = true,
				["Raid"] = true
			}
		},
		["Elemental Dimensions"] = {
			["Enable"] = true,
			["Order"] = {
				["Fire"] = 1,
				["Ice"] = 2,
				["Sand"] = 3
			}
		},
		["Auto Sell"] = {
			["Auto Sell Farm"] = {
				["Enable"] = true,
				["Wave"] = 15,
				["Stage Type"] = {
					["Odyssey"] = true,
					["Challenge"] = true,
					["Portal"] = true,
					["Worldline"] = true,
					["Legend Stage"] = true,
					["BossEvent"] = true,
					["Dungeon"] = false,
					["Infinite"] = true,
					["Rift"] = true,
					["Story"] = true,
					["Raid"] = true
				}
			},
			["Auto Sell Unit"] = {
				["Enable"] = false,
				["Wave"] = 1,
				["Stage Type"] = {
					["Odyssey"] = true,
					["Challenge"] = true,
					["Portal"] = true,
					["Worldline"] = true,
					["Legend Stage"] = true,
					["BossEvent"] = true,
					["Dungeon"] = true,
					["Infinite"] = true,
					["Rift"] = true,
					["Story"] = true,
					["Raid"] = true
				}
			}
		},
		["Ant Island"] = {
			["Auto Plug Ant Tunnel"] = true
		},
		["Martial Island"] = {
			["Auto Join God Portal"] = false,
			["Collect Rotara Earring"] = false,
			["Pause instead of Joining"] = false,
			["Restart if no Rotara Earring"] = false
		},
		["Ruined City"] = {
			["Use Mount to Travel"] = true,
			["Active Tower"] = false,
			["Unhandcuff"] = false
		},
		["The System"] = {
			["Auto Shadow"] = {
				["Enable"] = true,
				["Shadow"] = "Belu",
				["Order"] = {
					["Steel"] = 2,
					["Bear"] = 1,
					["Healer"] = 3,
					["Belu"] = 4
				}
			}
		},
		["Burn Units"] = {
			["Enable"] = true,
			["Slots"] = {
				["1"] = true,
				["3"] = true,
				["2"] = true,
				["5"] = true,
				["4"] = true,
				["6"] = true
			},
			["Stage Type"] = {
				["Odyssey"] = false,
				["Challenge"] = false,
				["Portal"] = true,
				["Worldline"] = false,
				["Legend Stage"] = true,
				["BossEvent"] = true,
				["Dungeon"] = false,
				["Infinite"] = true,
				["Rift"] = true,
				["Story"] = true,
				["Raid"] = true
			}
		},
		["Auto Vote Start"] = false,
		["Shibuya Station"] = {
			["Mohato Unit"] = {
				["Tuji (Sorcerer Killer)"] = true,
				["Goblin Killer (Trapper)"] = true,
				["Lilia and Berserker"] = true,
				["Isdead (Romantic)"] = true,
				["Alocard (Vampire King)"] = true,
				["Eizan (Aura)"] = true,
				["Goi"] = true,
				["Byeken (Ronin)"] = true,
				["Medusa (Gorgon)"] = true,
				["Todu (Unleashed)"] = true,
				["Sokora (Angra Mainyu)"] = true,
				["Sosora (Puppeteer)"] = true,
				["Saiko (Spirit Medium)"] = true,
				["Gazelle (Zombie)"] = true,
				["Legendary Super Brolzi"] = true,
				["Ackers (Levy)"] = true,
				["Noruto (Six Tails)"] = true,
				["Valentine (Love Train)"] = true,
				["Astolfo (Rider of Black)"] = true,
				["Lfelt (Love)"] = true
			},
			["Auto Mohato"] = true,
			["Leave Extra Money"] = 2000,
			["Upgrade Amount"] = 2
		},
		["Occult Hunt"] = {
			["Use All Talisman"] = {
				["Enable"] = false,
				["Wave"] = 1
			},
			["Collect Talisman"] = false,
			["Use Talisman on Crab"] = false
		},
		["Auto Use Ability"] = true
	},
	["Daily Challenge Joiner"] = {
		["Auto Join"] = false
	},
	["Misc"] = {
		["Auto Open Gift Boxes"] = false,
		["Right Click Move"] = false,
		["Max Camera Zoom"] = 40,
		["Redeem Code"] = false,
		["Right Click Teleport"] = false,
		["Auto Delete Portal"] = {
			["Summer Portal"] = 500,
			["Enable"] = false,
			["Spring Portal"] = 500
		}
	},
	["Summoner"] = {
		["Teleport Lobby new Banner"] = false,
		["Unselect if Summoned"] = false,
		["Normalize Rarity"] = {
			["Exclusive"] = false,
			["Epic"] = false,
			["Legendary"] = false,
			["Mythic"] = false,
			["Rare"] = false
		},
		["Auto Summon Summer"] = false,
		["Auto Summon Special"] = false,
		["Auto Summon Spring"] = false,
		["Delete Rarity"] = {
			["Exclusive"] = false,
			["Epic"] = false,
			["Legendary"] = false,
			["Mythic"] = false,
			["Rare"] = false
		}
	},
	["Unit Deleter"] = {
		["Enable"] = false,
		["Rarity"] = {
			["Epic"] = false,
			["Legendary"] = false,
			["Rare"] = false
		}
	},
	["Skin Deleter"] = {
		["Enable"] = false
	},
	["Worldline Joiner"] = {
		["Auto Join"] = false
	},
	["Regular Challenge Joiner"] = {
		["Auto Join"] = false,
		["Teleport Lobby new Challenge"] = false
	},
	["Auto Play"] = {
		["Auto Upgrade"] = {
			["Upgrade Order"] = {
				["1"] = 1,
				["3"] = 3,
				["2"] = 2,
				["5"] = 5,
				["4"] = 4,
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
			["Lebereo Raid"] = {
				["1"] = "131.16702270507812, 35.98725509643555, -362.08734130859375",
				["3"] = "131.42922973632812, 35.98725509643555, -317.7830810546875",
				["2"] = "131.16702270507812, 35.98725509643555, -362.08734130859375",
				["5"] = "127.52284240722656, 35.98725509643555, -297.4350891113281",
				["4"] = "127.52284240722656, 35.98725509643555, -297.4350891113281"
			},
			["Burning Spirit Tree"] = {
				["1"] = "207.5626983642578, 0.5131978988647461, -191.70925903320312",
				["3"] = "235.9824981689453, 0.5131978988647461, -215.14682006835938",
				["2"] = "195.8192596435547, 0.5131978988647461, -198.67872619628906",
				["5"] = "244.51007080078125, 0.5131978988647461, -213.92210388183594",
				["4"] = "253.53794860839844, 0.5131978988647461, -217.4495086669922",
				["6"] = "245.15574645996094, 0.5131978988647461, -192.70277404785156"
			},
			["Sand Village"] = {
				["1"] = "-215.588623046875, 180.48907470703125, -187.5686492919922",
				["3"] = "-262.0871887207031, 180.48907470703125, -182.75393676757812",
				["2"] = "-215.588623046875, 180.48907470703125, -187.5686492919922",
				["5"] = "-235.1538848876953, 180.48907470703125, -199.79898071289062",
				["4"] = "-235.1538848876953, 180.48907470703125, -199.79898071289062"
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
			["Hill of Swords"] = {
				["1"] = "30.016399383544922, 116.84236145019531, 102.57625579833984",
				["3"] = "10.967857360839844, 116.84236145019531, 122.07147979736328",
				["2"] = "35.810508728027344, 116.84236145019531, 111.67268371582031",
				["5"] = "0.8885884284973145, 116.84236145019531, 100.81619262695312",
				["4"] = "7.610741138458252, 116.84236145019531, 109.36640930175781",
				["6"] = "-5.704272747039795, 116.84236145019531, 76.40074920654297"
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
			["Shibuya Aftermath"] = {
				["1"] = "210.99525451660156, 514.7516479492188, 75.6123275756836",
				["3"] = "223.87945556640625, 514.7516479492188, 60.87996292114258",
				["2"] = "210.99525451660156, 514.7516479492188, 75.6123275756836",
				["5"] = "195.07896423339844, 514.7516479492188, 43.59787368774414",
				["4"] = "195.07896423339844, 514.7516479492188, 43.59787368774414"
			},
			["Planet Namak"] = {
				["1"] = "500.27032470703125, 2.062572717666626, -315.8484802246094",
				["3"] = "475.77581787109375, 2.062572717666626, -328.9787292480469",
				["2"] = "500.27032470703125, 2.062572717666626, -315.8484802246094",
				["5"] = "456.77398681640625, 2.062572717666626, -335.5212707519531",
				["4"] = "444.7925720214844, 2.062572717666626, -340.7905578613281"
			},
			["Tracks at the Edge of the World"] = {
				["1"] = "1052.6724853515625, 143.2725830078125, -782.9486694335938",
				["3"] = "1041.09912109375, 143.2725830078125, -756.412353515625",
				["2"] = "1052.6724853515625, 143.2725830078125, -782.9486694335938",
				["5"] = "1075.2176513671875, 143.2725830078125, -761.3186645507812",
				["4"] = "1075.2176513671875, 143.2725830078125, -761.3186645507812"
			},
			["Kuinshi Palace"] = {
				["1"] = "435.494140625, 268.38262939453125, 126.87104034423828",
				["3"] = "377.77899169921875, 268.38262939453125, 111.85942840576172",
				["2"] = "435.494140625, 268.38262939453125, 126.87104034423828",
				["5"] = "391.6142272949219, 268.38262939453125, 116.22864532470703",
				["4"] = "391.6142272949219, 268.38262939453125, 116.2286376953125"
			},
			["Shibuya Station"] = {
				["1"] = "-790.9635620117188, 9.356081008911133, -105.29301452636719",
				["3"] = "-769.8818969726562, 9.356081008911133, -118.41202545166016",
				["2"] = "-790.9635620117188, 9.356081008911133, -105.29301452636719",
				["5"] = "-765.84130859375, 9.356081008911133, -77.7351303100586",
				["4"] = "-768.3870239257812, 9.356081008911133, -75.20946502685547"
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
			["Sun Temple"] = {
				["1"] = "-287.7659606933594, 17, -43.65013885498047",
				["3"] = "-272.98138427734375, 17, -21.578874588012695",
				["2"] = "-287.7659606933594, 17, -43.65013885498047",
				["5"] = "-250.30592346191406, 17, -20.356889724731445",
				["4"] = "-250.30592346191406, 17, -20.356889724731445"
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
	["Love Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Portal Reward Picker"] = {
			["Prioritize"] = {
				["Double Dungeon"] = 3,
				["Planet Namak"] = 1,
				["Spirit Society"] = 6,
				["Shibuya Station"] = 4,
				["Underground Church"] = 5,
				["Sand Village"] = 2
			}
		}
	},
	["Match Finished"] = {
		["Auto Return Lobby"] = false,
		["Auto Next"] = true,
		["Replay Amount"] = 0,
		["Return Lobby Failsafe"] = false,
		["Auto Replay"] = true
	},
	["Performance Failsafe"] = {
		["Teleport Lobby FPS below"] = {
			["Enable"] = false,
			["FPS"] = 5
		}
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["Crafter"] = {
		["Teleport Lobby full Essence"] = false,
		["Enable"] = false,
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
	["Legend Stage Joiner"] = {
		["Auto Join"] = false
	},
	["Limitless Odyssey Joiner"] = {
		["Auto Force Skip Wave"] = false,
		["Auto Join"] = false,
		["Force Skip Wave"] = 1,
		["Intensity"] = 25,
		["Leave Floor"] = 1
	},
	["Raid Joiner"] = {
		["Auto Join"] = false
	},
	["Boss Event Joiner"] = {
		["Elite Mode"] = false,
		["Auto Join"] = false,
		["Nightmare Mode"] = false
	},
	["Failsafe"] = {
		["Teleport Lobby if Player"] = false,
		["Disable Auto Teleport AFK Chamber"] = true,
		["Auto Rejoin"] = false
	},
	["Unit Feeder"] = {
		["Auto Feed"] = false,
		["Feed Level"] = 60
	},
	["Weekly Challenge Joiner"] = {
		["Auto Join"] = false
	},
	["Secure"] = {
		["Random Offset"] = true,
		["Walk Around"] = false
	},
	["Boss Bounties Joiner"] = {
		["Auto Join"] = false
	},
	["Dungeon Joiner"] = {
		["Auto Join"] = false,
		["Stage"] = "Ant Island",
		["Act"] = "AntIsland"
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
			["Stage Type"] = {
				["Odyssey"] = false,
				["Challenge"] = false,
				["Portal"] = false,
				["Worldline"] = false,
				["Legend Stage"] = false,
				["BossEvent"] = false,
				["Dungeon"] = true,
				["Infinite"] = false,
				["Rift"] = false,
				["Story"] = false,
				["Raid"] = false
			},
			["Modifier"] = {
				["No Trait No Problem"] = false,
				["Warding off Evil"] = false,
				["Champions"] = true,
				["King's Burden"] = false,
				["Exterminator"] = false,
				["Fisticuffs"] = false,
				["Lifeline"] = false,
				["Dodge"] = false,
				["Quake"] = false,
				["Immunity"] = false,
				["Drowsy"] = false,
				["Money Surge"] = true
			}
		},
		["Auto Modifier"] = {
			["Enable"] = true,
			["Prioritize"] = {
				["Champions"] = 90,
				["Planning Ahead"] = 0,
				["Unit Draw"] = 31,
				["Exploding"] = 4,
				["Immunity"] = 91,
				["Damage"] = 95,
				["Lifeline"] = 0,
				["Evolution"] = 32,
				["Exterminator"] = 0,
				["Press It"] = 94,
				["Nighttime"] = 30,
				["Shielded"] = 0,
				["Cooldown"] = 93,
				["Money Surge"] = 100,
				["Strong"] = 0,
				["Thrice"] = 0,
				["Warding off Evil"] = 0,
				["Quake"] = 0,
				["Fast"] = 0,
				["Dodge"] = 0,
				["Fisticuffs"] = 0,
				["No Trait No Problem"] = 0,
				["Drowsy"] = 0,
				["King's Burden"] = 0,
				["Uncommon Loot"] = 98,
				["Common Loot"] = 97,
				["Harvest"] = 99,
				["Regen"] = 0,
				["Range"] = 96,
				["Revitalize"] = 0,
				["Precise Attack"] = 0,
				["Slayer"] = 92,
				["Wild Card"] = 33
			},
			["Amount"] = {
				["Champions"] = 1,
				["Revitalize"] = 1,
				["Exploding"] = 3,
				["Immunity"] = 1,
				["Press It"] = 3,
				["Money Surge"] = 1,
				["Strong"] = 1,
				["Fast"] = 1,
				["Dodge"] = 1,
				["Drowsy"] = 1,
				["Slayer"] = 4
			}
		}
	},
	["Claimer"] = {
		["Auto Claim Battle Pass"] = true,
		["Auto Claim Quest"] = true,
		["Auto Claim Milestone"] = true,
		["Auto Claim Achievement"] = true,
		["Auto Claim Daily Reward"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Spring Portal Joiner"] = {
		["Tier Cap"] = 10,
		["Auto Next"] = true,
		["Ignore Modifier"] = {
			["Strong"] = false,
			["Thrice"] = false,
			["Regen"] = false,
			["Fast"] = false,
			["Revitalize"] = false,
			["Drowsy"] = false,
			["Exploding"] = false,
			["Dodge"] = false,
			["Quake"] = false,
			["Shielded"] = false,
			["Immunity"] = false,
			["Champions"] = false
		},
		["Teleport Lobby full Iced Box"] = false,
		["Ignore Act"] = {
			["[Land of the Gods] Act2"] = false,
			["[Planet Namak] Act3"] = false,
			["[Planet Namak] Act6"] = false,
			["[Planet Namak] Act5"] = false,
			["[Edge of Heaven] Act2"] = false,
			["[Planet Namak] Act1"] = false,
			["[Edge of Heaven] Act6"] = false,
			["[Land of the Gods] Act3"] = false,
			["[Edge of Heaven] Act3"] = false,
			["[Edge of Heaven] Act1"] = false,
			["[Planet Namak] Act2"] = false,
			["[Planet Namak] Act4"] = false,
			["[Edge of Heaven] Act4"] = false,
			["[Land of the Gods] Act1"] = false,
			["[Edge of Heaven] Act5"] = false
		},
		["Auto Join"] = false,
		["Portal Reward Picker"] = {
			["Enable"] = true,
			["Ignore Modifier"] = {
				["Strong"] = false,
				["Thrice"] = false,
				["Regen"] = false,
				["Fast"] = true,
				["Revitalize"] = false,
				["Drowsy"] = false,
				["Exploding"] = false,
				["Dodge"] = false,
				["Quake"] = false,
				["Immunity"] = false,
				["Shielded"] = true,
				["Champions"] = false
			},
			["Prioritize"] = {
				["Land of the Gods"] = 1,
				["Planet Namak"] = 2,
				["Edge of Heaven"] = 3
			}
		},
		["Teleport Lobby full Wooden Chest"] = false,
		["Buy if out of Portal"] = false
	},
	["Rift Joiner"] = {
		["Hop Server if no Rift Portal"] = false,
		["Join Solo Only"] = false,
		["Auto Join"] = false,
		["Teleport Lobby Rift spawn"] = {
			["Enable"] = false,
			["Force teleport"] = false,
			["Extra Time"] = 60
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(1)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden