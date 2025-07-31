game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
getgenv().Config = {
	["AutoSave"] = true,
	["Stage Joiner"] = {
		["Act"] = "Infinite",
		["Stage"] = "Shibuya Station",
		["Auto Join"] = true
	},
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
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 5000
		},
		["Auto Sell"] = {
			["Enable"] = true,
			["Wave"] = 30
		},
		["Shibuya Station"] = {
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
			},
			["Upgrade Amount"] = 0,
			["Leave Extra Money"] = 2000,
			["Auto Mohato"] = true
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
		["Auto Use Ability"] = true,
		["Auto Vote Start"] = true,
		["Auto Skip Wave"] = true,
		["Auto Sell Farm"] = {
			["Wave"] = 1
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
	["Modifier"] = {
		["Auto Modifier"] = {
			["Prioritize"] = {
				["Strong"] = 3,
				["Thrice"] = 4,
				["Warding off Evil"] = 24,
				["Champions"] = 12,
				["Fast"] = 1,
				["Revitalize"] = 6,
				["Fisticuffs"] = 25,
				["Exploding"] = 2,
				["Dodge"] = 10,
				["Uncommon Loot"] = 22,
				["Immunity"] = 11,
				["Planning Ahead"] = 15,
				["Harvest"] = 17,
				["Lifeline"] = 29,
				["Precise Attack"] = 13,
				["Drowsy"] = 8,
				["No Trait No Problem"] = 23,
				["Cooldown"] = 19,
				["Exterminator"] = 28,
				["Regen"] = 7,
				["Damage"] = 20,
				["Common Loot"] = 21,
				["King's Burden"] = 27,
				["Range"] = 18,
				["Press It"] = 14,
				["Quake"] = 9,
				["Shielded"] = 5,
				["Slayer"] = 16,
				["Money Surge"] = 26
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
				["Lifeline"] = 0,
				["Precise Attack"] = 0,
				["Drowsy"] = 0,
				["No Trait No Problem"] = 0,
				["Cooldown"] = 0,
				["Exterminator"] = 0,
				["Regen"] = 0,
				["Damage"] = 0,
				["Common Loot"] = 0,
				["King's Burden"] = 0,
				["Range"] = 0,
				["Press It"] = 0,
				["Quake"] = 0,
				["Shielded"] = 0,
				["Slayer"] = 0,
				["Money Surge"] = 0
			}
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
	["Auto Play"] = {
		["Auto Upgrade"] = true,
		["Place Cap"] = {
			["1"] = 0,
			["3"] = 0,
			["2"] = 0,
			["5"] = -1,
			["4"] = 0,
			["6"] = -1
		},
		["Enable"] = true,
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
		["Middle Position"] = {
			["Shibuya Station"] = "-766.9473876953125, 9.356081008911133, -129.8753204345703"
		},
		["Focus on Farm"] = true
	}
}
getgenv().Key = "k7d27caec454d21cbd95104d" -- key main[ElIsfyTzBhioWvdmAjNPUaUaCHtnQvwH , k7d27caec454d21cbd95104d]
repeat wait(2)spawn(function()loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()end)wait(2)until Joebiden