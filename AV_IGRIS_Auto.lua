game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Macros"] = {
		["Macro Retry Limit"] = 0,
		["Ignore Macro Timing"] = true,
		["No Ignore Sell Timing"] = true
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
	["Legend Stage Joiner"] = {
		["Stage"] = "Double Dungeon",
		["Auto Join"] = true,
		["Act"] = "Act3"
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
		["Auto Claim Achievement"] = true,
		["Auto Claim Collection"] = true,
		["Auto Claim Enemy Index"] = true,
		["Auto Claim Collection Milestone"] = true
	},
	["Gameplay"] = {
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
			["Leave Extra Money"] = 5000,
			["Upgrade Amount"] = 2
		},
		["Shibuya Station"] = {
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 0
		},
		["Saber Event"] = {
			["Servant"] = "Berserker"
		},
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Enable"] = true,
			["Wave"] = 15
		}
	},
	["Misc"] = {
		["Redeem Code"] = true
	},
	["Performance"] = {
		["Delete Map"] = true,
		["Boost FPS"] = true,
		["Black Screen"] = false,
		["Delete Entities"] = true
	},
	["Match Finished"] = {
		["Replay Amount"] = 0,
		["Auto Replay"] = true
	},
	["AutoExecute"] = true,
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = 0,
			["4"] = -1,
			["6"] = 0
		},
		["Enable"] = true,
		["Upgrade Method"] = "Lowest Level (Spread Upgrade)",
		["Prefer Position"] = {
			["Double Dungeon"] = "Middle",
			["Cavern"] = "Middle",
			["Sand Village"] = "Middle",
			["Shibuya Aftermath"] = "Middle",
			["Mountain Shrine (Natural)"] = "Middle",
			["Kuinshi Palace"] = "Middle",
			["Land of the Gods"] = "Middle",
			["Golden Castle"] = "Middle",
			["Spirit Society"] = "Middle",
			["Ant Island"] = "Middle",
			["Shibuya Station"] = "Middle",
			["Blood-Red Chamber"] = "Middle",
			["Planet Namak"] = "Middle",
			["Tracks at the Edge of the World"] = "Middle",
			["Underground Church"] = "Middle",
			["Spider Forest"] = "Middle",
			["Martial Island"] = "Middle"
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
			["Double Dungeon"] = "-275.53009033203125, 0.10069097578525543, -117.67021179199219"
		}
	},
	["Failsafe"] = {
		["Auto Rejoin"] = true,
		["Disable Auto Teleport AFK Chamber"] = true
	},
	["Secure"] = {
		["Walk Around"] = true,
		["Random Offset"] = true
	},
	["Modifier"] = {
		["Restart Modifier"] = {
			["Enable"] = true,
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
				["Champions"] = 99,
				["Fast"] = 0,
				["Revitalize"] = 0,
				["Fisticuffs"] = 0,
				["Exploding"] = 98,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 100,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["Drowsy"] = 0,
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
				["Fisticuffs"] = 0,
				["Exploding"] = 0,
				["Dodge"] = 0,
				["Uncommon Loot"] = 0,
				["Immunity"] = 0,
				["Planning Ahead"] = 0,
				["Harvest"] = 0,
				["Precise Attack"] = 0,
				["Range"] = 0,
				["Lifeline"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["King's Burden"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["Regen"] = 0,
				["Drowsy"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
		}
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden


