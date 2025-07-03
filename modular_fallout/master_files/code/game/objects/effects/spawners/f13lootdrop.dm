/*	-------------------------------------------------
	---------F13 SPAWNERS, READABLE EDITION----------
	-old ported spawners read level is kevcode level-
	--so i just made this new one, based on tg one---
	--oh and, if it rutines about "not enough shit---
	-----------to spawn", it is fine(tm)-------------
 */

//Stop using lootspawners in dungeons improperly. If you put guns in a dungeon, people will want to use them, which will result in them shooting people. You'll have to put in nests or something to constantly give people stuff to shoot at. - Nappist

/obj/effect/spawner/lootdrop/f13
	name = "f13 spawners - DO NOT USE THIS"
	lootdoubles = FALSE	//making sure it will /not/ double

/*	------------------------------------------------
	----------------ARMOR SPAWNERS------------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/armor
	name = "armor spawners - DO NOT USE THIS"
	icon_state = "armor_loot"

/obj/effect/spawner/lootdrop/f13/armor/clothes
	name = "pre-war clothes spawner"
	loot = list(
				/obj/effect/spawner/bundle/f13/worker,
				/obj/effect/spawner/bundle/f13/plaidskirt,
				/obj/item/clothing/under/dress/blacktango,
				/obj/item/clothing/under/dress/redeveninggown,
				/obj/item/clothing/under/rank/civilian/janitor/maid,
				/obj/effect/spawner/bundle/f13/badass,
				/obj/effect/spawner/bundle/f13/puffer,
				/obj/effect/spawner/bundle/f13/that,
				/obj/effect/spawner/bundle/f13/benny,
				/obj/effect/spawner/bundle/f13/hoodie,
				/obj/item/clothing/under/pants/camo,
				/obj/effect/spawner/bundle/f13/bartender_purple,
				/obj/effect/spawner/bundle/f13/plaidskirt/bluered,
				/obj/effect/spawner/bundle/f13/navysuit,
				/obj/effect/spawner/bundle/f13/femsuit,
	)

/obj/effect/spawner/bundle/f13/worker
	name = "overalls and flat cap"
	items = list(
				/obj/item/clothing/under/misc/overalls,
				/obj/item/clothing/head/flatcap
				)

/obj/effect/spawner/bundle/f13/plaidskirt
	name = "green and purple plaid skirt"
	items = list(
				/obj/item/clothing/under/dress/skirt/plaid/green,
				/obj/item/clothing/under/dress/skirt/plaid/purple
				)

/obj/effect/spawner/bundle/f13/badass
	name = "leather jacket and fingerless gloves"
	items = list(
				/obj/item/clothing/suit/jacket/leather,
				/obj/item/clothing/gloves/fingerless
				)

/obj/effect/spawner/bundle/f13/puffer
	name = "puffer vest, jeans, and grey cloak"
	items = list(
		/obj/item/clothing/suit/jacket/puffer/vest,
		/obj/item/clothing/under/pants/jeans,
		/obj/item/clothing/neck/mantle/gray,
	)

/obj/effect/spawner/bundle/f13/that
	name = "charcoal suit and hat"
	items = list(
				/obj/item/clothing/under/suit/charcoal,
				/obj/item/clothing/head/that
				)

/obj/effect/spawner/bundle/f13/benny
	name = "checkered suit and shoes"
	items = list(
				/obj/item/clothing/under/suit/checkered, // It's Benny time!
				/obj/item/clothing/shoes/laceup
				)

/obj/effect/spawner/bundle/f13/hoodie
	name = "hoodie"
	items = list(
				/obj/item/clothing/head/beanie/black,
				/obj/item/clothing/suit/hooded/chaplain_hoodie
				)

/obj/effect/spawner/bundle/f13/bartender_purple
	name = "purple bartender's outfit spawner"
	items = list(
				/obj/item/clothing/neck/apron/bartender,
				/obj/item/clothing/under/rank/civilian/bartender/purple,
				)

/obj/effect/spawner/bundle/f13/plaidskirt/bluered
	name = "blue and red plaid skirts"
	items = list(
				/obj/item/clothing/under/dress/skirt/plaid/blue,
				/obj/item/clothing/under/dress/skirt/plaid
				)

/obj/effect/spawner/bundle/f13/navysuit
	name = "navy suit and shoes"
	items = list(
				/obj/item/clothing/under/suit/navy,
				/obj/item/clothing/shoes/laceup
				)

/obj/effect/spawner/bundle/f13/femsuit
	name = "female executive suit and shoes"
	items = list(
				/obj/item/clothing/under/suit/female,
				/obj/item/clothing/shoes/laceup
				)



/obj/effect/spawner/lootdrop/f13/armor/costumes
	name = "pre-war costumes spawner"
	loot = list(
				/obj/effect/spawner/bundle/f13/soviet,
				/obj/effect/spawner/bundle/f13/geisha,
				/obj/item/clothing/under/dress/blacktango,
				/obj/item/clothing/under/dress/redeveninggown,
				/obj/effect/spawner/bundle/f13/mexican,
				/obj/item/clothing/under/dress/sailor,
				/obj/effect/spawner/bundle/f13/jabroni,
				/obj/effect/spawner/bundle/f13/romeaboo,
				/obj/item/clothing/under/costume/maid,
				/obj/effect/spawner/bundle/f13/vampire,
				/obj/item/clothing/under/costume/kilt,
				/obj/effect/spawner/bundle/f13/pirate
	)

/obj/effect/spawner/bundle/f13/soviet
	name = "soviet costume"
	items = list(
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/under/costume/soviet,
		/obj/item/clothing/neck/mantle/gray,
	)

/obj/effect/spawner/bundle/f13/geisha
	name = "geisha costume"
	items = list(
				/obj/item/clothing/under/costume/geisha,
				/obj/item/clothing/shoes/sandal
				)

/obj/effect/spawner/bundle/f13/mexican
	name = "sombrero and poncho"
	items = list(
				/obj/item/clothing/head/sombrero,
				/obj/item/clothing/neck/mantle/poncho
				)

/obj/effect/spawner/bundle/f13/jabroni
	name = "jabroni outfit spawner"
	items = list(
				/obj/item/clothing/under/costume/jabroni,
				/obj/item/clothing/glasses/blindfold
				)

/obj/effect/spawner/bundle/f13/romeaboo
	name = "roman gladiator outfit spawner"
	items = list(
				/obj/item/clothing/under/costume/gladiator,
				/obj/item/clothing/shoes/roman
				)

/obj/effect/spawner/bundle/f13/vampire
	name = "vampire outfit spawner"
	items = list(
		/obj/item/clothing/under/costume/draculass,
		/obj/item/clothing/neck/mantle/gray,
	)

/obj/effect/spawner/bundle/f13/pirate
	name = "pirate outfit spawner"
	items = list(
				/obj/item/clothing/under/costume/pirate,
				/obj/item/clothing/suit/pirate
				)


/obj/effect/spawner/lootdrop/f13/armor/tier1 //TIER 1 ARMOR
	name = "tier 1 armor"
	loot = list(
				/obj/item/clothing/suit/armored/light/leather_jacket,
				/obj/effect/spawner/bundle/f13/armor/supafly,
				/obj/effect/spawner/bundle/f13/armor/sadist,
				/obj/effect/spawner/bundle/f13/armor/blastmaster,
				/obj/effect/spawner/bundle/f13/armor/yankee,
				/obj/effect/spawner/bundle/f13/armor/badlands,
				/obj/effect/spawner/bundle/f13/armor/psycho,
				/obj/item/clothing/suit/f13/duster,
				/obj/effect/spawner/bundle/f13/armor/combatduster,
				/obj/item/clothing/suit/armor/f13/medium/iconoclast
	)

/obj/effect/spawner/bundle/f13/armor/supafly
	name = "supafly raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/medium/supafly,
				/obj/item/clothing/head/helmet/f13/raider/supafly
				)

/obj/effect/spawner/bundle/f13/armor/sadist
	name = "blastmaster raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/medium/sadist,
				/obj/item/clothing/head/helmet/f13/raider/arclight
				)

/obj/effect/spawner/bundle/f13/armor/blastmaster
	name = "blastmaster raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/medium/blastmaster,
				/obj/item/clothing/head/helmet/f13/raider/blastmaster
				)

/obj/effect/spawner/bundle/f13/armor/yankee
	name = "yankee raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/medium/yankee,
				/obj/item/clothing/head/helmet/f13/raider/yankee
				)

/obj/effect/spawner/bundle/f13/armor/badlands
	name = "badlands raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/light/badlands,
				/obj/item/clothing/head/helmet/f13/fiend
				)

/obj/effect/spawner/bundle/f13/armor/combatduster
	name = "combat duster raider armor spawner"
	items = list(
				/obj/item/clothing/suit/f13/medium/duster_renegade,
				/obj/item/clothing/head/helmet/f13/raidercombathelmet
				)

/obj/effect/spawner/bundle/f13/armor/psycho
	name = "knight armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/medium/painspike,
				/obj/item/clothing/head/helmet/f13/raider/psychotic
				)

/obj/effect/spawner/lootdrop/f13/armor/tier2 //TIER 2 ARMOR
	name = "tier 2 armor"
	loot = list(
				/obj/effect/spawner/bundle/f13/armor/knight,
				/obj/effect/spawner/bundle/f13/armor/metal,
				/obj/item/clothing/suit/armored/light/leather,
				/obj/item/clothing/suit/armored/light/leathermk2
				)

/obj/effect/spawner/bundle/f13/armor/knight
	name = "knight armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/metal,
				/obj/item/clothing/head/helmet/knight/f13/metal
				)

/obj/effect/spawner/bundle/f13/armor/metal
	name = "metal armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/metal,
				/obj/item/clothing/head/helmet/f13/metalmask
				)

/obj/effect/spawner/lootdrop/f13/armor/tier3 //TIER 3 ARMOR
	name = "tier 3 armor"
	loot = list(
				/obj/effect/spawner/bundle/f13/armor/metal/reinforced,
				/obj/effect/spawner/bundle/f13/armor/swat,
				/obj/effect/spawner/bundle/f13/armor/combat,
				/obj/effect/spawner/bundle/f13/armor/bulletproof,
				/obj/effect/spawner/bundle/f13/armor/combat/dark,
				/obj/effect/spawner/bundle/f13/armor/sulphite
				)

/obj/effect/spawner/bundle/f13/armor/metal/reinforced
	items = list(
				/obj/item/clothing/suit/armored/heavy/recycled_power,
				/obj/item/clothing/head/helmet/f13/metalmask/mk2
				)

/obj/effect/spawner/bundle/f13/armor/swat
	items = list(
				/obj/item/clothing/head/helmet/f13/combat/swat,
				/obj/item/clothing/suit/f13/medium/combat/swat
				)

/obj/effect/spawner/bundle/f13/armor/combat
	name = "combat armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/combat,
				/obj/item/clothing/head/helmet/f13/combat
				)

/obj/effect/spawner/bundle/f13/armor/bulletproof
	name = "bulletproof armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/bulletproof,
				/obj/item/clothing/head/helmet/alt
				)

/obj/effect/spawner/bundle/f13/armor/combat/dark
	name = "dark combat armor spawner"
	items = list(
				/obj/item/clothing/suit/f13/medium/combat/dark,
				/obj/item/clothing/head/helmet/f13/combat/dark
				)

/obj/effect/spawner/bundle/f13/armor/sulphite
	name = "sulphite raider armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/sulphite,
				/obj/item/clothing/head/helmet/f13/sulphitehelm
				)

/obj/effect/spawner/lootdrop/f13/armor/tier4 //TIER 4 ARMOR
	name = "tier 4 armor"
	loot = list(
				/obj/effect/spawner/bundle/f13/armor/t45b,
				/obj/effect/spawner/bundle/f13/armor/riot,
				/obj/effect/spawner/bundle/f13/armor/combat/mk2,
				/obj/effect/spawner/bundle/f13/armor/combat/mk2/dark
				)

/obj/effect/spawner/bundle/f13/armor/t45b
	name = "t45b power armor spawner"
	items = list(
				/obj/item/clothing/head/helmet/f13/power_armor/t45b,
				/obj/item/clothing/suit/armor/f13/power_armor/t45b
				)

/obj/effect/spawner/bundle/f13/armor/riot
	name = "riot armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/riotpolice,
				/obj/item/clothing/head/helmet/f13/rangerbroken
				)

/obj/effect/spawner/bundle/f13/armor/combat/mk2
	name = "MkII combat armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/combat/mk2,
				/obj/item/clothing/head/helmet/f13/combat/mk2
				)

/obj/effect/spawner/bundle/f13/armor/combat/mk2/dark
	name = "dark MkII combat armor spawner"
	items = list(
				/obj/item/clothing/suit/f13/medium/combat/mk2/dark,
				/obj/item/clothing/head/helmet/f13/combat/mk2/dark
				)

/obj/effect/spawner/bundle/f13/armor/raiderpa
	name = "salvaged raider power armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/salvaged_raider,
				/obj/item/clothing/head/helmet/f13/power_armor/raiderpa_helm
				)
#warn correct this
/obj/effect/spawner/bundle/f13/armor/hotrodpa
	name = "salvaged hotrod power armor spawner"
	items = list(
				/obj/item/clothing/suit/armored/heavy/salvaged_t45,
				/obj/item/clothing/head/helmet/f13/power_armor/hotrod
				)


/obj/effect/spawner/lootdrop/f13/armor/tier5 //TIER 5 ARMOR
	name = "tier 5 armor"
	loot = list(
				/obj/effect/spawner/bundle/f13/armor/t45d,
				/obj/effect/spawner/bundle/f13/armor/t51b,
				)

/obj/effect/spawner/bundle/f13/armor/t45d
	name = "t45d power armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/power_armor/t45d,
				/obj/item/clothing/head/helmet/f13/power_armor/t45d,
				)

/obj/effect/spawner/bundle/f13/armor/t51b
	name = "t51b power armor spawner"
	items = list(
				/obj/item/clothing/suit/armor/f13/power_armor/t51b,
				/obj/item/clothing/head/helmet/f13/power_armor/t51b,
				)


/obj/effect/spawner/lootdrop/f13/armor/random
	name = "random armor loot"
	lootcount = 1

	loot = list(
			/obj/effect/spawner/lootdrop/f13/armor/tier1 = 90,
			/obj/effect/spawner/lootdrop/f13/armor/tier2 = 9,
			/obj/effect/spawner/lootdrop/f13/armor/tier3 = 1,
			)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/mid
	name = "high tier random armor loot"
	lootcount = 1

	loot = list(
			/obj/effect/spawner/lootdrop/f13/armor/tier2 = 70,
			/obj/effect/spawner/lootdrop/f13/armor/tier3 = 35,
			/obj/effect/spawner/lootdrop/f13/armor/tier4 = 10
			///obj/item/traumapack = 1 //one ring to rule them all
			)

/*	------------------------------------------------
	---------------MEDICAL SPAWNERS-----------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/medical
	name = "medical spawners - DO NOT USE THIS"

/obj/effect/spawner/lootdrop/f13/medical/surgical
	name = "surgical item spawner"
	lootcount = 1

	loot = list(
				/obj/item/hemostat,
				/obj/item/surgicaldrill,
				/obj/item/retractor,
				/obj/item/cautery,
				/obj/item/scalpel,
				/obj/item/clothing/gloves/color/latex,
				/obj/item/clothing/mask/surgical,
				/obj/item/circular_saw
				)

/obj/effect/spawner/lootdrop/f13/medical/surgical/blood
	name = "blood spawner"
	lootcount = 1

	loot = list(
				/obj/item/reagent_containers/blood/random
				)

/obj/effect/spawner/lootdrop/f13/medical/vault
	name = "vault medical spawner - DO NOT USE"

/obj/effect/spawner/lootdrop/f13/medical/vault/equipment
	name = "vault medical equipment spawner"
	lootcount = 1

	loot = list(
				/obj/item/defibrillator/compact/combat/loaded,
				/obj/item/reagent_containers/hypospray/combat,
				/obj/item/clothing/glasses/hud/health/night,
				///obj/item/disk/surgery/revival
				)

/obj/effect/spawner/lootdrop/f13/medical/vault/meds  //no drugs, didn't add
	name = "vault medical meds spawner"
	lootcount = 1

	loot = list(
				/obj/item/reagent_containers/hypospray/medipen/stimpak,
				/obj/item/storage/pill_bottle/chem_tin/radx,
				/obj/item/reagent_containers/blood/radaway,
				/obj/item/storage/pill_bottle/chem_tin/mentats
				)

/obj/effect/spawner/lootdrop/f13/medical/wasteland
	name = "wasteland medical spawner - DO NOT USE"

/obj/effect/spawner/lootdrop/f13/medical/wasteland/meds //remove equipment, has nothing on it
	name = "wasteland meds spawner"
	lootcount = 1

	loot = list(/obj/item/reagent_containers/pill/patch/healingpowder,
				/obj/item/storage/pill_bottle/chem_tin/radx,
				/obj/item/reagent_containers/blood/radaway,
				/obj/item/storage/pill_bottle/chem_tin/mentats,
				/obj/item/reagent_containers/hypospray/medipen/stimpak
				)

/obj/effect/spawner/lootdrop/f13/medical/wasteland/meds/drug //remove equipment, has nothing on it
	name = "wasteland drugs spawner"
	lootcount = 1

	loot = list(
				/obj/item/reagent_containers/pill/patch/jet,
				/obj/item/reagent_containers/pill/patch/turbo,
				/obj/item/reagent_containers/pill/patch/healingpowder,
				/obj/item/reagent_containers/pill/stimulant,
				/obj/item/reagent_containers/hypospray/medipen/medx,
				/obj/item/storage/pill_bottle/chem_tin/buffout
				)
/*	------------------------------------------------
	--------------WEAPON SPAWNERS-------------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/weapon
	name = "weapon spawners - DO NOT USE THIS"
	icon_state = "gun_loot"

/*	------------------------------------------------
	-----------MELEE WEAPON SPAWNERS----------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/weapon/melee
	name = "melee spawners - DO NOT USE THIS"
	icon_state = "melee_loot"

/obj/effect/spawner/lootdrop/f13/weapon/melee/tier1 //TIER 1 MELEE WEAPON
	name = "tier 1 melee"
	lootcount = 1

	loot = list(
				/obj/item/crowbar,
				/obj/item/extinguisher,
				/obj/item/hatchet,
				/obj/item/pickaxe/mini,
				/obj/item/wrench,
				/obj/item/knife/kitchen,
				/obj/item/kitchen/rollingpin,
				)


/obj/effect/spawner/lootdrop/f13/weapon/melee/tier2 //TIER 2 MELEE WEAPON
	name = "tier 2 melee"
	lootcount = 1

	loot = list(
				/obj/item/gavelhammer,
				/obj/item/oar,
				/obj/item/pickaxe,
				/obj/item/shovel,
				/obj/item/melee/onehanded/knife/switchblade,
				/obj/item/throwing_star/spear,
				/obj/item/surgicaldrill,
				/obj/item/melee/onehanded/knife/hunting,
				/obj/item/melee/onehanded/knife/survival,
				/obj/item/melee/onehanded/knife/bone,
				/obj/item/instrument/guitar,
				/obj/item/twohanded/spear/scrapspear,
				/obj/item/melee/onehanded/club,
				/obj/item/melee/onehanded/knife/cosmicdirty,
//				/obj/item/melee/unarmed/brass,
//				/obj/item/melee/unarmed/brass/spiked
				)
#warn remember to fix unarmred and re add to loot tables!
/obj/effect/spawner/lootdrop/f13/weapon/melee/tier3 //TIER 3 MELEE WEAPON
	name = "tier 3 melee"
	lootcount = 1

	loot = list(
				/obj/item/weldingtool,
				/obj/item/twohanded/spear,
				/obj/item/twohanded/baseball,
				/obj/item/knife/butcher,
				/obj/item/twohanded/baseball/golfclub,
				/obj/item/melee/onehanded/machete,
				/obj/item/melee/onehanded/machete/forgedmachete,
				/obj/item/shield/riot/buckler,
//				/obj/item/melee/unarmed/tigerclaw,
//				/obj/item/melee/unarmed/sappers
				)

/obj/effect/spawner/lootdrop/f13/weapon/melee/tier4 //TIER 4 MELEE WEAPON
	name = "tier 4 melee"
	lootcount = 1

	loot = list(
				/obj/item/twohanded/fireaxe,
				/obj/item/twohanded/sledgehammer,
				/obj/item/twohanded/fireaxe/bmprsword,
//				/obj/item/melee/unarmed/lacerator,
//				/obj/item/melee/unarmed/maceglove,
//				/obj/item/melee/unarmed/punchdagger,
				/obj/item/twohanded/baseball/louisville,
				/obj/item/shield/riot
				)

/obj/effect/spawner/lootdrop/f13/weapon/melee/tier5 //TIER 5 MELEE WEAPON
	name = "tier 5 melee"
	lootcount = 1

	loot = list(
				/obj/item/melee/energy/thermic_lance,
				/obj/item/twohanded/chainsaw,
				/obj/item/twohanded/sledgehammer/rockethammer,
				/obj/item/melee/powered/ripper,
				/obj/item/melee/powerfist,
				/obj/item/melee/energy/axe/protonaxe,
//				/obj/item/gun/ballistic/revolver/ballisticfist,
				/obj/item/twohanded/sledgehammer/supersledge,
				/obj/item/shishkebabpack,
//				/obj/item/melee/unarmed/deathclawgauntlet,
//				/obj/item/melee/powerfist/moleminer
				)

/obj/effect/spawner/lootdrop/f13/weapon/melee/random
	name = "random melee loot"
	lootcount = 1

	loot = list(
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier1 = 40,
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier2 = 30,
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier3 = 20,
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier4 = 10
			)

/obj/effect/spawner/lootdrop/f13/weapon/melee/random_high
	name = "high tier random melee loot"
	lootcount = 1

	loot = list(
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier3 = 45,
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier4 = 35,
			/obj/effect/spawner/lootdrop/f13/weapon/melee/tier5 = 20
			)

/*	------------------------------------------------
	-------------GUN WEAPON SPAWNERS----------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/weapon/gun
	name = "gun spawners - DO NOT USE THIS"
	icon_state = "gun_loot"

//Energy Weapon Spawners
/obj/effect/spawner/lootdrop/f13/weapon/gun/energy/low
	name = "low tier energy gun"
	loot = list(/obj/effect/spawner/bundle/f13/wattz = 40,
				/obj/effect/spawner/bundle/f13/wattzm = 25,
				/obj/effect/spawner/bundle/f13/laserpistol = 35
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/energy/mid
	name = "mid tier energy gun"
	loot = list(/obj/effect/spawner/bundle/f13/aer9 = 30,
				/obj/effect/spawner/bundle/f13/aer12 = 12,
				/obj/effect/spawner/bundle/f13/wattz2k = 12,
				/obj/effect/spawner/bundle/f13/wattz2kext = 8,
				/obj/effect/spawner/bundle/f13/plasmapistol = 18,
				/obj/effect/spawner/bundle/f13/ionrifle = 5
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/energy/high
	name = "high tier energy gun"
	loot = list(/obj/effect/spawner/bundle/f13/plasmarifle = 25,
				/obj/effect/spawner/bundle/f13/tribeam = 10,
				/obj/effect/spawner/bundle/f13/rcw = 20,
				/obj/effect/spawner/bundle/f13/aer14 = 20,
				/obj/effect/spawner/bundle/f13/plasmaglock = 25
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/energy/superhigh
	name = "superhigh tier energy gun"
	loot = list(/obj/effect/spawner/bundle/f13/multiplas,
				/obj/item/gun/energy/laser/plasma/pistol/alien
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/energy/unique
	name = "unique tier energy gun"
	lootcount = 1

	loot = list(/obj/item/gun/energy/laser/solar
				)

//Ballistic Weapon Spawners
/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/hobo
	name = "hobo tier ballistic gun"
	loot = list(/obj/effect/spawner/bundle/f13/piperifle,
				/obj/effect/spawner/bundle/weapon/piperifle,
				/obj/effect/spawner/bundle/f13/zipgun,
				/obj/item/gun/ballistic/revolver/hobo/knifegun,
				/obj/item/gun/ballistic/revolver/hobo/knucklegun,
				/obj/effect/spawner/bundle/f13/autopipe,
				/obj/effect/spawner/bundle/f13/caravan_shotgun,
				/obj/effect/spawner/bundle/f13/mosin,
				/obj/effect/spawner/bundle/f13/remington,
				/obj/item/gun/ballistic/revolver/winchesterrebored,
				/obj/effect/spawner/bundle/f13/widowmaker,
				/obj/effect/spawner/bundle/f13/varmint
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/low
	name = "low tier ballistic gun"
	loot = list(/obj/effect/spawner/bundle/f13/m1911,
				/obj/effect/spawner/bundle/f13/m1911c,
				/obj/effect/spawner/bundle/f13/ninemil,
				/obj/effect/spawner/bundle/f13/n99,
				/obj/effect/spawner/bundle/f13/pistol22,
				/obj/effect/spawner/bundle/f13/colt6520,
				/obj/effect/spawner/bundle/f13/colt357,
				/obj/effect/spawner/bundle/f13/beretta,
				/obj/effect/spawner/bundle/f13/mk23,
				/obj/effect/spawner/bundle/f13/sig,
				/obj/effect/spawner/bundle/f13/huntingshotgun,
				/obj/effect/spawner/bundle/f13/police_pistol,
				/obj/effect/spawner/bundle/f13/guns/commando,
				/obj/effect/spawner/bundle/f13/m1carbine
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/mid
	name = "mid tier ballistic gun"
	loot = list(/obj/effect/spawner/bundle/f13/trail,
				/obj/effect/spawner/bundle/f13/cowboy,
				/obj/effect/spawner/bundle/f13/service,
				/obj/effect/spawner/bundle/f13/miniuzi,
				/obj/effect/spawner/bundle/f13/smg10mm,
				/obj/effect/spawner/bundle/f13/guns/rockwell,
				/obj/effect/spawner/bundle/f13/mp5,
				/obj/effect/spawner/bundle/f13/revolver44,
				/obj/effect/spawner/bundle/f13/revolverm29,
				/obj/effect/spawner/bundle/f13/revolverm29alt,
				/obj/effect/spawner/bundle/f13/needler,
				/obj/effect/spawner/bundle/f13/deagle,
				/obj/effect/spawner/bundle/f13/automag,
				/obj/effect/spawner/bundle/f13/beretta/select,
				/obj/effect/spawner/bundle/f13/shotgunlever,
				/obj/effect/spawner/bundle/f13/auto5,
				/obj/effect/spawner/bundle/f13/trenchshotgun,
				/obj/effect/spawner/bundle/f13/revolver45,
				/obj/effect/spawner/bundle/f13/thatgun,
				/obj/item/gun/ballistic/automatic/smg/american180
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/high
	name = "high tier ballistic gun"
	loot = list(/obj/effect/spawner/bundle/f13/marksman = 15,
				/obj/effect/spawner/bundle/f13/assault_rifle = 20,
				/obj/effect/spawner/bundle/f13/r84 = 5,
				/obj/effect/spawner/bundle/f13/guns/tommygun = 10,
				/obj/effect/spawner/bundle/f13/brushgun = 10,
				/obj/effect/spawner/bundle/f13/hunting = 5,
				/obj/effect/spawner/bundle/f13/pistol14 = 10,
				/obj/effect/spawner/bundle/f13/m1garand = 5,
				/obj/effect/spawner/bundle/f13/dkssniper = 10
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/superhigh
	name = "superhigh tier ballistic gun"
	loot = list(/obj/effect/spawner/bundle/f13/citykiller = 15,
				/obj/effect/spawner/bundle/f13/riotshotgun = 23,
				/obj/effect/spawner/bundle/f13/bozar = 8,
				/obj/effect/spawner/bundle/f13/amr = 16,
				/obj/effect/spawner/bundle/f13/rangemaster = 20,
				/obj/effect/spawner/bundle/f13/gauss = 10,
				/obj/effect/spawner/bundle/f13/fnfal = 8
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/unique
	name = "unique tier ballistic gun"
	lootcount = 1

	loot = list(
				/obj/item/gun/ballistic/automatic/pistol/ninemil/maria,
				/obj/item/gun/ballistic/rifle/hunting/paciencia,
				/obj/item/gun/ballistic/automatic/varmint/ratslayer,
				/obj/item/gun/ballistic/automatic/assault_rifle/infiltrator,
				/obj/item/gun/ballistic/revolver/colt357/lucky,
				/obj/item/gun/ballistic/automatic/m1garand/oldglory,
				/obj/item/gun/ballistic/automatic/marksman/sniper/gold,
				/obj/item/gun/ballistic/automatic/pistol/pistol14/lildevil
				)

//Gun Bundles
/obj/effect/spawner/bundle/f13/zipgun
	name = "zip gun spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/hobo/zipgun,
				/obj/item/ammo_box/magazine/zipgun
				)

/obj/effect/spawner/bundle/f13/single_shotgun
	name = "shotgun bat and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/single_shotgun,
				/obj/item/ammo_box/shotgun/improvised
				)

/obj/effect/spawner/bundle/f13/caravan_shotgun
	name = "caravan shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/caravan_shotgun,
				/obj/item/ammo_box/shotgun/improvised
				)

/obj/effect/spawner/bundle/f13/mosin
	name = "mosin nagant and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/mosin,
				/obj/item/ammo_box/a762
				)

/obj/effect/spawner/bundle/f13/remington
	name = "remington rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/hunting,
				/obj/item/ammo_box/a308
				)

/obj/effect/spawner/bundle/f13/n99
	name = "10mm pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/n99,
				/obj/item/ammo_box/magazine/m10mm_adv/simple/
				)

/obj/effect/spawner/bundle/f13/m1911
	name = "m1911 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/m1911,
				/obj/item/ammo_box/magazine/m45
				)

/obj/effect/spawner/bundle/f13/ninemil
	name = "9mm pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/ninemil,
				/obj/item/ammo_box/magazine/m9mm
				)

/obj/effect/spawner/bundle/f13/colt6520
	name = "Colt 6520 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/colt6520,
				/obj/item/ammo_box/l10mm
				)

/obj/effect/spawner/bundle/f13/varmint
	name = "varmint rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/varmint,
				/obj/item/ammo_box/magazine/m556/rifle
				)

/obj/effect/spawner/bundle/f13/pistol22
	name = ".22 pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/pistol22,
				/obj/item/ammo_box/magazine/m22
				)

/obj/effect/spawner/bundle/f13/m1911c
	name = "compact m1911 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/m1911/compact,
				/obj/item/ammo_box/magazine/m45/
				)

/obj/effect/spawner/bundle/f13/beretta
	name = "beretta pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/beretta,
				/obj/item/ammo_box/magazine/m9mmds/
				)

/obj/effect/spawner/bundle/f13/sig
	name = "sig p220 pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/sig,
				/obj/item/ammo_box/magazine/m9mm/
				)

/obj/effect/spawner/bundle/f13/piperifle
	name = "pepperbox gun spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/hobo/pepperbox,
				/obj/item/ammo_box/c10mm/improvised,
				)

/obj/effect/spawner/bundle/f13/huntingshotgun
	name = "hunting shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/hunting,
				/obj/item/ammo_box/shotgun/buck
				)

/obj/effect/spawner/bundle/f13/shotgunlever
	name = "lever action shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/automatic/combat/shotgunlever,
				/obj/item/ammo_box/shotgun/buck
	)

/obj/effect/spawner/bundle/f13/revolverm29
	name = "m29 revolver and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/m29,
				/obj/item/ammo_box/m44/
				)

/obj/effect/spawner/bundle/f13/revolverm29alt
	name = "alt m29 revolver and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/m29/alt,
				/obj/item/ammo_box/m44
	)

/obj/effect/spawner/bundle/f13/automag
	name = "automag and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/automag,
				/obj/item/ammo_box/magazine/automag
	)

/obj/effect/spawner/bundle/f13/revolver45
	name = "s&w revolver and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/revolver45,
				/obj/item/ammo_box/c45rev
	)

/obj/effect/spawner/bundle/f13/cowboy
	name = "cowboy repeater and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/repeater/cowboy,
				/obj/item/ammo_box/tube/a357/
				)

/obj/effect/spawner/bundle/f13/colt357
	name = "colt 357 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/colt357,
				/obj/item/ammo_box/a357
				)

/obj/effect/spawner/bundle/f13/service
	name = "NCR service rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/service,
				/obj/item/ammo_box/magazine/m556/rifle
				)

/obj/effect/spawner/bundle/f13/police_pistol
	name = "police revolver and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/police,
				/obj/item/ammo_box/a357
	)

/obj/effect/spawner/bundle/f13/laserpistol
	name = "AEP7 laser pistol and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/pistol,
				/obj/item/stock_parts/cell/ammo/ec
	)

/obj/effect/spawner/bundle/f13/m1carbine
	name = "m1 carbine and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/m1carbine,
				/obj/item/ammo_box/magazine/m10mm_adv/simple
	)

/obj/effect/spawner/bundle/f13/guns/commando
	name = "de lisle carbine and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/delisle,
				/obj/item/ammo_box/magazine/m9mmds
	)

/obj/effect/spawner/bundle/f13/mk23
	name = "mk23 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/mk23,
				/obj/item/ammo_box/magazine/m45exp/
	)

/obj/effect/spawner/bundle/f13/thatgun
	name = "223 pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/thatgun,
				/obj/item/ammo_box/magazine/m556/rifle/small
	)

/obj/effect/spawner/bundle/f13/widowmaker
	name = "widowmaker spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/widowmaker
				)

/obj/effect/spawner/bundle/f13/autopipe
	name = "auto pipe rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/autopipe,
				/obj/item/ammo_box/magazine/autopipe
				)

/obj/effect/spawner/bundle/f13/miniuzi
	name = "mini uzi and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/mini_uzi,
				/obj/item/ammo_box/magazine/uzim9mm/
				)

/obj/effect/spawner/bundle/f13/guns/rockwell
	name = "rockwell gun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/rockwell,
				/obj/item/ammo_box/magazine/uzim9mm/rockwell/
				)

/obj/effect/spawner/bundle/f13/smg10mm
	name = "10mm SMG and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/smg10mm,
				/obj/item/ammo_box/magazine/m10mm_adv/ext/
				)

/obj/effect/spawner/bundle/f13/greasegun
	name = "m3a1 grease gun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/greasegun,
				/obj/item/ammo_box/magazine/greasegun/
				)

/obj/effect/spawner/bundle/f13/guns/auto5
	name = "auto-5 shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/automatic/combat/auto5,
				/obj/item/ammo_box/shotgun/buck,
				)

/obj/effect/spawner/bundle/f13/trenchshotgun
	name = "trench shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/trench,
				/obj/item/ammo_box/shotgun/buck,
				)

/obj/effect/spawner/bundle/f13/wattz
	name = "Wattz laser rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/wattz,
				/obj/item/stock_parts/cell/ammo/ec
				)

/obj/effect/spawner/bundle/f13/wattzm
	name = "Wattz magneto pistol and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/wattz/magneto,
				/obj/item/stock_parts/cell/ammo/ec
	)

/obj/effect/spawner/bundle/f13/needler
	name = "needler and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/needler,
				/obj/item/ammo_box/needle
				)

/obj/effect/spawner/bundle/f13/trail
	name = "trail carbine and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/repeater/trail,
				/obj/item/ammo_box/tube/m44/
				)

/obj/effect/spawner/bundle/f13/revolver44
	name = ".44 revolver and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/revolver44,
				/obj/item/ammo_box/m44/
				)

/obj/effect/spawner/bundle/f13/beretta/select
	name = "select-fire beretta pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/beretta/automatic,
				/obj/item/ammo_box/magazine/m9mmds/
				)

/obj/effect/spawner/bundle/f13/deagle
	name = "Desert Eagle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/deagle,
				/obj/item/ammo_box/magazine/m44/
				)

/obj/effect/spawner/bundle/f13/pistol14
	name = "14mm pistol and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/pistol/pistol14,
				/obj/item/ammo_box/magazine/m14mm
	)

/obj/effect/spawner/bundle/f13/neostead
	name = "Neostead 2000 shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/automatic/combat/neostead,
				/obj/item/ammo_box/shotgun/slug,
				/obj/item/ammo_box/shotgun/buck
	)

/obj/effect/spawner/bundle/f13/auto5
	name = "Auto 5 shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/shotgun/automatic/combat/auto5,
				/obj/item/ammo_box/shotgun/buck,
				/obj/item/ammo_box/shotgun/slug
	)

// Obsolete
/obj/effect/spawner/bundle/f13/smg22
	name = "american 180 spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/american180
				)

/obj/effect/spawner/bundle/f13/assault_rifle
	name = "assault rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/assault_rifle,
				/obj/item/ammo_box/magazine/m556/rifle/assault/
				)

/obj/effect/spawner/bundle/f13/marksman
	name = "marksman rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/marksman,
				/obj/item/ammo_box/magazine/m556/rifle/
				)

/obj/effect/spawner/bundle/f13/rcw
	name = "laser RCW and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/rcw,
				/obj/item/stock_parts/cell/ammo/ecp
				)

/obj/effect/spawner/bundle/f13/plasmapistol
	name = "plasma pistol and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/plasma/pistol,
				/obj/item/stock_parts/cell/ammo/ec
				)

/obj/effect/spawner/bundle/f13/aer9
	name = "AER9 laser rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/aer9,
				/obj/item/stock_parts/cell/ammo/mfc
				)

/obj/effect/spawner/bundle/f13/infiltrator
	name = "infiltrator rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/assault_rifle/infiltrator,
				/obj/item/ammo_box/magazine/m556/rifle/
				)

/obj/effect/spawner/bundle/f13/brushgun
	name = "brush gun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/repeater/brush,
				/obj/item/ammo_box/tube/c4570/
				)

/obj/effect/spawner/bundle/f13/m1garand
	name = "m1 garand and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/m1garand,
				/obj/item/ammo_box/magazine/garand308
	)

/obj/effect/spawner/bundle/f13/dkssniper
	name = "dks sniper and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/marksman/sniper,
				/obj/item/ammo_box/magazine/w308
	)

/obj/effect/spawner/bundle/f13/rangemaster
	name = "rangemaster rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/rangemaster,
				/obj/item/ammo_box/magazine/m762/
				)

/obj/effect/spawner/bundle/f13/riotshotgun
	name = "riot shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/shotgun/riot,
				/obj/item/ammo_box/magazine/d12g/
				)

/obj/effect/spawner/bundle/f13/ionrifle
	name = "ion rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/ionrifle,
				/obj/item/stock_parts/cell/ammo/mfc
				)

/obj/effect/spawner/bundle/f13/plasmaglock
	name = "plasma glock and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/plasma/glock,
				/obj/item/stock_parts/cell/ammo/ec
				)

/obj/effect/spawner/bundle/f13/wattz2k
	name = "Wattz 2000 laser rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/wattz2k,
				/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/wattz2kext
	name = "Wattz 2000 laser extended laser rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/wattz2k/extended,
				/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/mp5
	name = "mp5 and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/mp5,
				/obj/item/ammo_box/magazine/uzim9mm/
	)

/obj/effect/spawner/bundle/f13/citykiller
	name = "citykiller and ammo spawner"
	items = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat/citykiller,
		/obj/item/ammo_box/shotgun/buck
	)

/obj/effect/spawner/bundle/f13/guns/p90
	name = "P90 SMG spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/p90,
				/obj/item/ammo_box/magazine/m10mm_p90/
	)

/obj/effect/spawner/bundle/f13/hunting
	name = "hunting revolver spawner"
	items = list(
				/obj/item/gun/ballistic/revolver/hunting,
				/obj/item/ammo_box/c4570/
	)

/obj/effect/spawner/bundle/f13/riotshotgun
	name = "riot shotgun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/shotgun/riot,
				/obj/item/ammo_box/magazine/d12g/
	)

/obj/effect/spawner/bundle/f13/aer12
	name = "aer12 and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/aer12,
				/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/r84
	name = "r84 spawner"
	items = list(
		/obj/item/gun/ballistic/automatic/r84,
		/obj/item/ammo_box/magazine/m556/rifle/extended/
	)

/obj/effect/spawner/bundle/f13/bozar
	name = "bozar and ammo spawner"
	items = list(
			/obj/item/gun/ballistic/automatic/bozar,
			/obj/item/ammo_box/magazine/m556/rifle/extended/
	)

/obj/effect/spawner/bundle/f13/plasmarifle
	name = "plasma rifle and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/plasma,
				/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/guns/tommygun
	name = "tommygun and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/smg/tommygun,
				/obj/item/ammo_box/magazine/tommygunm45/
	)

/obj/effect/spawner/bundle/f13/aer14
	name = "aer14 and ammo spawner"
	items = list(
		/obj/item/gun/energy/laser/aer14,
		/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/amr
	name = "amr and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/rifle/mag/antimateriel,
				/obj/item/ammo_box/magazine/amr/
	)

/obj/effect/spawner/bundle/f13/tribeam
	name = "tribeam and ammo spawner"
	items = list(
		/obj/item/gun/energy/laser/scatter,
		/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/multiplas
	name = "multiplas and ammo spawner"
	items = list(
				/obj/item/gun/energy/laser/plasma/scatter,
				/obj/item/stock_parts/cell/ammo/mfc
	)

/obj/effect/spawner/bundle/f13/gauss
	name = "gauss rifle and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/m72,
				/obj/item/ammo_box/magazine/m2mm
	)

/obj/effect/spawner/bundle/f13/fnfal
	name = "fn fal and ammo spawner"
	items = list(
				/obj/item/gun/ballistic/automatic/fnfal,
				/obj/item/ammo_box/magazine/m762/ext
	)



/*	------------------------------------------------
	------------WEAPON AMMO SPAWNERS----------------
	------------------------------------------------ */

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo
	name = "ammo spawners - DO NOT USE THIS"
	icon_state = "ammo_loot"

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier1
	name = "tier 1 ammo"
	lootcount = 2 //2 random ammo
	lootdoubles = TRUE

	loot = list(
				/obj/item/ammo_box/magazine/m9mm,
				/obj/item/ammo_box/shotgun/buck,
				/obj/item/ammo_box/shotgun/slug,
				/obj/item/ammo_box/c38,
				/obj/item/ammo_box/magazine/m10mm_adv/simple,
				/obj/item/ammo_box/magazine/m556/rifle/small
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier2
	name = "tier 2 ammo"
	lootdoubles = TRUE

	loot = list(
				/obj/item/ammo_box/magazine/m45,
				/obj/item/ammo_box/a762,
				/obj/item/ammo_box/a308,
				/obj/item/ammo_box/magazine/m10mm_adv/simple,
				/obj/item/ammo_box/magazine/m556/rifle,
				/obj/item/ammo_box/c38,
				/obj/item/ammo_box/magazine/m9mm,
				/obj/item/ammo_box/m44,
				/obj/item/ammo_box/tube/a357,
				/obj/item/ammo_box/a357,
				/obj/item/ammo_box/magazine/m556/rifle/small
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier2/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(2, 3)
	. = ..()

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier3
	name = "tier 3 ammo"
	lootdoubles = TRUE

	loot = list(
				/obj/item/ammo_box/shotgun/buck,
				/obj/item/ammo_box/magazine/uzim9mm,
				/obj/item/ammo_box/magazine/m10mm_adv/simple,
				/obj/item/ammo_box/magazine/greasegun,
				/obj/item/ammo_box/needle,
				/obj/item/ammo_box/magazine/tommygunm45,
				/obj/item/ammo_box/tube/m44,
				/obj/item/ammo_box/magazine/m10mm_adv/ext,
				/obj/item/stock_parts/cell/ammo/ec
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier3/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(2, 3)
	. = ..()

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier4
	name = "tier 4 ammo"
	lootdoubles = TRUE

	loot = list(
				/obj/item/ammo_box/magazine/d12g,
				/obj/item/ammo_box/magazine/m44,
				/obj/item/ammo_box/magazine/m556/rifle,
				/obj/item/ammo_box/c4570,
				/obj/item/ammo_box/tube/c4570,
				/obj/item/ammo_box/a50MG,
				/obj/item/ammo_box/a762/doublestacked,
				/obj/item/stock_parts/cell/ammo/mfc
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier4/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(2, 3)
	. = ..()

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier5
	name = "tier 5 ammo"
	lootdoubles = TRUE

	loot = list(
				/obj/item/ammo_box/a50MG,
				/obj/item/ammo_box/magazine/m556/rifle/extended,
				/obj/item/ammo_box/magazine/m762/ext,
				/obj/item/ammo_box/magazine/d12g
				)

/obj/effect/spawner/lootdrop/f13/weapon/gun/ammo/tier5/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(1, 2, 3, 4)
	. = ..()


/obj/effect/spawner/lootdrop/f13/junkspawners //TIER 4 GARBAGE
	name = "garbage spawner"
	lootcount = 2
	fan_out_items = TRUE

	loot = list(
				/obj/item/broken_bottle,
				/obj/item/poster/random_official,
				/obj/item/multitool,
				/obj/item/cigbutt/cigarbutt,
				/obj/item/razor,
				/obj/item/candle,
				/obj/item/rollingpaper,
				/obj/item/stack/sheet/mineral/coal,
				/obj/item/soap/homemade,
				/obj/item/stack/cable_coil/random,
				/obj/item/stack/medical/bruise_pack,
				/obj/item/trash/popcorn,
				/obj/item/valentine,
				/obj/item/taperecorder,
				/obj/item/tape/random,
				/obj/item/stack/gauze,
				/obj/item/plate,
				/obj/item/storage/box/snappops,
				/obj/item/trash/f13/rotten,
				/obj/item/trash/f13/tin,
				/obj/item/trash/f13/dog,
				/obj/item/trash/f13/dandyapples,
				/obj/item/storage/crayons,
				/obj/item/stack/package_wrap,
				/obj/item/storage/box/matches,
				/obj/item/food/deadmouse,
				/obj/item/toner,
				/obj/item/tank/internals/oxygen,
				/obj/item/storage/box/papersack,
				/obj/item/storage/box/lights/mixed,
				/obj/item/reagent_containers/cup/glass/sillycup,
				/obj/item/restraints/handcuffs/cable/zipties,
				/obj/item/storage/pill_bottle,
				/obj/item/storage/belt/fannypack/black,
				/obj/item/camera,
				/obj/item/bodypart/arm/left,
				/obj/item/toy/dummy,
				/obj/item/toy/eightball,
				/obj/item/toy/cards/deck,
				/obj/item/trash/tray,
				/obj/item/toy/xmas_cracker,
				/obj/item/reagent_containers/cup/bowl,
				/obj/item/reagent_containers/spray/cleaner,
				/obj/item/reagent_containers/bucket,
				/obj/item/poster/random_contraband
				)

/obj/effect/spawner/lootdrop/f13/seedspawner
	name = "seed spawner"
	lootdoubles = TRUE
	fan_out_items = TRUE
	lootcount = 4

/obj/effect/spawner/lootdrop/f13/seedspawner/Initialize(mapload) // This will spawn gatfruit sometimes.
	loot = list(/obj/item/seeds/ambrosia,
					/obj/item/seeds/apple,
					/obj/item/seeds/banana,
					/obj/item/seeds/cotton,
					/obj/item/seeds/berry,
					/obj/item/seeds/poppy/broc,
					/obj/item/seeds/cabbage,
					/obj/item/seeds/carrot,
					/obj/item/seeds/carrot/parsnip,
					/obj/item/seeds/cherry,
					/obj/item/seeds/chanter,
					/obj/item/seeds/chili,
					/obj/item/seeds/cocoapod,
					/obj/item/seeds/coffee,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/grape,
					/obj/item/seeds/grass,
					/obj/item/seeds/lemon,
					/obj/item/seeds/lime,
					/obj/item/seeds/onion,
					/obj/item/seeds/orange,
					/obj/item/seeds/rainbow_bunch,
					/obj/item/seeds/pineapple,
					/obj/item/seeds/potato,
					/obj/item/seeds/poppy,
					/obj/item/seeds/pumpkin,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/soya,
					/obj/item/seeds/sugarcane,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/tea,
					/obj/item/seeds/tobacco,
					/obj/item/seeds/tomato,
					/obj/item/seeds/tower,
					/obj/item/seeds/watermelon,
					/obj/item/seeds/wheat,
					/obj/item/seeds/whitebeet,
					/obj/item/seeds/xander,
					/obj/item/seeds/mutfruit,
					/obj/item/seeds/amanita,
					/obj/item/seeds/glowshroom,
					/obj/item/seeds/liberty,
					/obj/item/seeds/nettle,
					/obj/item/seeds/plump,
					/obj/item/seeds/reishi,
					/obj/item/seeds/cannabis,
					/obj/item/seeds/starthistle,
					/obj/item/seeds/random)
	. = ..()

/obj/effect/spawner/lootdrop/f13/foodspawner
	name = "food spawner"
	lootdoubles = TRUE
	fan_out_items = TRUE

	loot = list(
				/obj/item/storage/box/ingredients/american,
				/obj/item/food/f13/crisps,
				/obj/item/food/f13/crisps,
				/obj/item/food/f13/bubblegum,
				/obj/item/food/f13/cram,
				/obj/item/food/f13/yumyum,
				/obj/item/food/f13/fancylads,
				/obj/item/food/f13/sugarbombs,
				/obj/item/food/cheesiehonkers,
				/obj/item/food/f13/steak,
				/obj/item/food/f13/dandyapples,
				/obj/item/food/f13/blamco,
				/obj/item/food/f13/instamash ,
				/obj/item/food/f13/canned/porknbeans,
				/obj/item/storage/box/ingredients/carnivore,
				/obj/item/storage/box/ingredients/delights,
				/obj/item/storage/box/ingredients/exotic,
				/obj/item/storage/box/ingredients/fiesta,
				/obj/item/storage/box/ingredients/fruity,
				/obj/item/storage/box/ingredients/grains,
				/obj/item/storage/box/ingredients/italian,
				/obj/item/storage/box/ingredients/sweets,
				/obj/item/storage/box/ingredients/vegetarian,
				/obj/item/storage/box/ingredients/wildcard,
				/obj/item/reagent_containers/condiment/flour,
				/obj/item/reagent_containers/condiment/rice,
				/obj/item/reagent_containers/condiment/yeast,
				/obj/item/reagent_containers/condiment/soymilk,
				/obj/item/reagent_containers/condiment/ketchup,
				/obj/item/reagent_containers/condiment/sugar,
				/obj/item/reagent_containers/condiment/milk,
				/obj/item/reagent_containers/condiment/saltshaker,
				/obj/item/reagent_containers/condiment/peppermill,
				/obj/item/reagent_containers/condiment/soysauce,
				/obj/item/food/beans,
				/obj/item/food/cracker,
				/obj/item/food/lollipop,
				"" // a chance to spawn nothing
				)


/obj/effect/spawner/lootdrop/f13/foodspawner/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(1, 2)
	. = ..()

/obj/effect/spawner/lootdrop/f13/crafting
	name = "crafting spawner"
	lootdoubles = TRUE
	fan_out_items = TRUE

	loot = list(
				/obj/item/crafting/abraxo,
				/obj/item/stack/crafting/metalparts/three,
				/obj/item/stack/crafting/metalparts/five,
				/obj/item/stack/crafting/goodparts/three,
				/obj/item/stack/crafting/goodparts/five,
				/obj/item/stack/crafting/electronicparts/three,
				/obj/item/stack/crafting/electronicparts/five,
				/obj/item/reagent_containers/glass/bottle/blackpowder,
				/obj/item/crafting/timer,
				/obj/item/crafting/wonderglue,
				/obj/item/crafting/duct_tape)

/obj/effect/spawner/lootdrop/f13/crafting/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(1, 2)
	. = ..()


/obj/effect/spawner/lootdrop/f13/alcoholspawner //TIER 7 ALCOHOL
	name = "alcoholspawner"
	lootdoubles = TRUE
	fan_out_items = TRUE

	loot = list(
				/obj/item/reagent_containers/cup/glass/bottle/beer,
				/obj/item/reagent_containers/cup/glass/bottle/ale,
				/obj/item/reagent_containers/cup/glass/bottle/gin,
				/obj/item/reagent_containers/cup/glass/bottle/hcider,
				/obj/item/reagent_containers/cup/glass/bottle/whiskey,
				/obj/item/reagent_containers/cup/glass/bottle/vodka,
				/obj/item/reagent_containers/cup/glass/bottle/tequila,
				/obj/item/reagent_containers/cup/glass/bottle/rum,
				/obj/item/reagent_containers/cup/glass/bottle/vermouth,
				/obj/item/reagent_containers/cup/glass/bottle/kahlua,
				/obj/item/reagent_containers/cup/glass/bottle/cognac,
				/obj/item/reagent_containers/cup/glass/bottle/wine,
				/obj/item/reagent_containers/cup/glass/bottle/absinthe,
				/obj/item/reagent_containers/cup/glass/bottle/hcider,
				/obj/item/reagent_containers/cup/glass/bottle/grappa,
				/obj/item/reagent_containers/cup/glass/bottle/sake,
				/obj/item/reagent_containers/cup/glass/bottle/fernet
				)

/obj/effect/spawner/lootdrop/f13/alcoholspawner/Initialize(mapload) //on mapload, pick how many shit to spawn
	lootcount = pick(1, 2)
	. = ..()

/obj/effect/spawner/lootdrop/f13/resourcespawner //now include R N G (TM) (higher number means it has a bigger spawn chance)
	name = "resource spawner"
	lootcount = 2

	loot = list(
				/obj/item/stack/rods/ten = 3,
				/obj/item/stack/sheet/iron/ten = 5,
				/obj/item/stack/sheet/cardboard/twenty = 1,
//				/obj/item/stack/sheet/glass/ten = 2,
				/obj/item/stack/sheet/iron/five = 2,
				/obj/item/stack/sheet/plasteel/five = 1,
				/obj/item/stack/sheet/plastic/five = 4,
				/obj/item/stack/sheet/cloth/ten = 1,
				/obj/item/stack/crafting/metalparts/five = 4,
				/obj/item/stack/crafting/goodparts/three = 2
				)

/obj/effect/spawner/lootdrop/f13/cash_random_low
	name = "low value cash spawner"
	lootcount = 1

	loot = list(
				/obj/item/stack/f13Cash/random/low = 50,
				/obj/item/stack/f13Cash/random/ncr/low = 30,
				/obj/item/stack/f13Cash/random/denarius/low = 30,
				/obj/item/stack/f13Cash/random/aureus/low = 10
				)

/obj/effect/spawner/lootdrop/f13/cash_random_med
	name = "medium value cash spawner"
	lootcount = 1

	loot = list(
				/obj/item/stack/f13Cash/random/med = 43,
				/obj/item/stack/f13Cash/random/ncr/med = 35,
				/obj/item/stack/f13Cash/random/denarius/med = 30,
				/obj/item/stack/f13Cash/random/aureus/med = 5,
				/obj/item/stack/f13Cash/random/low = 40,
				/obj/item/stack/f13Cash/random/ncr/low = 19,
				/obj/item/stack/f13Cash/random/denarius/low = 19,
				/obj/item/stack/f13Cash/random/aureus/low = 5,
				/obj/item/stack/f13Cash/random/high = 2,
				/obj/item/stack/f13Cash/random/ncr/high = 1,
				/obj/item/stack/f13Cash/random/denarius/high = 1,
				/obj/item/stack/f13Cash/random/aureus/high = 1,
				)

/obj/effect/spawner/lootdrop/f13/cash_random_high
	name = "high value cash spawner"
	lootcount = 1

	loot = list(
				/obj/item/stack/f13Cash/random/high = 25,
				/obj/item/stack/f13Cash/random/ncr/high = 30,
				/obj/item/stack/f13Cash/random/denarius/high = 30,
				/obj/item/stack/f13Cash/random/aureus/high = 10,
				/obj/item/stack/f13Cash/random/med = 50,
				/obj/item/stack/f13Cash/random/ncr/med = 15,
				/obj/item/stack/f13Cash/random/denarius/med = 15,
				/obj/item/stack/f13Cash/random/aureus/med = 5,
				/obj/item/stack/f13Cash/random/low = 10,
				/obj/item/stack/f13Cash/random/ncr/low = 5,
				/obj/item/stack/f13Cash/random/denarius/low = 5,
				/obj/item/stack/f13Cash/random/aureus/low = 1,
				)

/obj/effect/spawner/lootdrop/f13/cash_legion_low
	name = "low value legion cash spawner"
	lootcount = 1
	loot = list(
			/obj/item/stack/f13Cash/random/denarius/low = 50,
			/obj/item/stack/f13Cash/random/aureus/low = 30,
			/obj/item/stack/f13Cash/random/low = 10,
			/obj/item/stack/f13Cash/random/denarius/med = 10,
			/obj/item/stack/f13Cash/random/aureus/med = 5,
			/obj/item/stack/f13Cash/random/med = 1,
			)

/obj/effect/spawner/lootdrop/f13/cash_legion_med
	name = "medium value legion cash spawner"
	lootcount = 1
	loot = list(
			/obj/item/stack/f13Cash/random/denarius/med = 50,
			/obj/item/stack/f13Cash/random/aureus/med = 30,
			/obj/item/stack/f13Cash/random/med = 10,
			/obj/item/stack/f13Cash/random/denarius/high = 10,
			/obj/item/stack/f13Cash/random/aureus/high = 5,
			/obj/item/stack/f13Cash/random/high = 1,
			/obj/item/stack/f13Cash/random/denarius/low = 10,
			/obj/item/stack/f13Cash/random/aureus/low = 5,
			/obj/item/stack/f13Cash/random/low = 1,
			)

/obj/effect/spawner/lootdrop/f13/cash_legion_high
	name = "high value legion cash spawner"
	lootcount = 1
	loot = list(
		/obj/item/stack/f13Cash/random/denarius/high = 50,
		/obj/item/stack/f13Cash/random/aureus/high = 30,
		/obj/item/stack/f13Cash/random/high = 10,
		/obj/item/stack/f13Cash/random/denarius/med = 10,
		/obj/item/stack/f13Cash/random/aureus/med = 5,
		/obj/item/stack/f13Cash/random/med = 1,
		)


/obj/effect/spawner/lootdrop/f13/cash_ncr_low
	name = "low value ncr cash spawner"
	lootcount = 1
	loot = list(
			/obj/item/stack/f13Cash/random/ncr/low = 50,
			/obj/item/stack/f13Cash/random/low = 10,
			/obj/item/stack/f13Cash/random/ncr/med = 25,
			/obj/item/stack/f13Cash/random/med = 5,
			)

/obj/effect/spawner/lootdrop/f13/cash_ncr_med
	name = "medium value ncr cash spawner"
	lootcount = 1
	loot = list(
			/obj/item/stack/f13Cash/random/ncr/med = 50,
			/obj/item/stack/f13Cash/random/med = 10,
			/obj/item/stack/f13Cash/random/ncr/high = 25,
			/obj/item/stack/f13Cash/random/high = 5,
			)

/obj/effect/spawner/lootdrop/f13/cash_ncr_high
	name = "high value ncr cash spawner"
	lootcount = 1
	loot = list(
			/obj/item/stack/f13Cash/random/ncr/high = 50,
			/obj/item/stack/f13Cash/random/high = 10,
			/obj/item/stack/f13Cash/random/ncr/med = 25,
			/obj/item/stack/f13Cash/random/med = 5,
			)

/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk
	name = "100% chance of deceased rodent"
	loot = list(
		/obj/item/food/deadmouse = 50)

/obj/effect/spawner/lootdrop/f13/traitbooks
	name = "trait book spawner"
	lootcount = 1
	loot = list(/obj/item/book/granter/trait/lowsurgery = 10,
				/obj/item/book/granter/trait/chemistry = 10,
				/obj/item/book/granter/trait/trekking = 10,
				/obj/item/book/granter/crafting_recipe/gunsmith_one = 50,
				/obj/item/book/granter/crafting_recipe/gunsmith_two = 20,
				/obj/item/book/granter/crafting_recipe/gunsmith_three = 10,
				/obj/item/book/granter/crafting_recipe/gunsmith_four = 10
				)

/obj/effect/spawner/lootdrop/f13/blueprintLow
	name = "gun comps spawner"
	icon_state = "blueprint_loot"
	lootcount = 1
	loot = list(
		/obj/item/advanced_crafting_components/flux,
		/obj/item/advanced_crafting_components/lenses,
		/obj/item/advanced_crafting_components/conductors,
		/obj/item/advanced_crafting_components/receiver,
		/obj/item/advanced_crafting_components/assembly,
		/obj/item/advanced_crafting_components/alloys,
		/obj/item/attachments/scope,
		/obj/item/attachments/burst_improvement,
		/obj/item/attachments/recoil_decrease,
		/obj/item/attachments/auto_sear
	)

/obj/effect/spawner/lootdrop/f13/blueprintMid
	name = "blueprint-tier(Mid) item spawner"
	icon_state = "blueprint_loot"
	lootcount = 1
	loot = list(
		/obj/item/book/granter/crafting_recipe/blueprint/marksman,
		/obj/item/book/granter/crafting_recipe/blueprint/plasmapistol,
		/obj/item/book/granter/crafting_recipe/blueprint/brushgun,
		/obj/item/book/granter/crafting_recipe/blueprint/greasegun,
		/obj/item/book/granter/crafting_recipe/blueprint/r82,
		/obj/item/book/granter/crafting_recipe/blueprint/service,
		/obj/item/book/granter/crafting_recipe/blueprint/trailcarbine,
		/obj/item/book/granter/crafting_recipe/blueprint/thatgun,
		/obj/item/book/granter/crafting_recipe/blueprint/uzi,
		/obj/item/book/granter/crafting_recipe/blueprint/smg10mm,
		/obj/item/book/granter/crafting_recipe/blueprint/m1carbine,
		/obj/item/book/granter/crafting_recipe/blueprint/scoutcarbine
	)

/obj/effect/spawner/lootdrop/f13/blueprintHigh
	name = "blueprint-tier(High) item spawner"
	icon_state = "blueprint_loot"
	lootcount = 1
	loot = list(
		/obj/item/book/granter/crafting_recipe/blueprint/r91,
		/obj/item/book/granter/crafting_recipe/blueprint/sniper,
		/obj/item/book/granter/crafting_recipe/blueprint/riotshotgun,
		/obj/item/book/granter/crafting_recipe/blueprint/r84,
		/obj/item/book/granter/crafting_recipe/blueprint/deagle,
		/obj/item/book/granter/crafting_recipe/blueprint/commando,
		/obj/item/book/granter/crafting_recipe/blueprint/pps,
		/obj/item/book/granter/crafting_recipe/blueprint/leveraction,
		/obj/item/book/granter/crafting_recipe/blueprint/aep7
	)

/obj/effect/spawner/lootdrop/f13/blueprintVHigh
	name = "blueprint-tier(VHigh) item spawner"
	icon_state = "blueprint_loot"
	lootcount = 1
	loot = list(
		/obj/item/book/granter/crafting_recipe/blueprint/am_rifle,
		/obj/item/book/granter/crafting_recipe/blueprint/citykiller,
		/obj/item/book/granter/crafting_recipe/blueprint/rangemaster,
		/obj/item/book/granter/crafting_recipe/blueprint/neostead,
		/obj/item/book/granter/crafting_recipe/blueprint/aer9,
		/obj/item/book/granter/crafting_recipe/blueprint/gauss
	)

/obj/effect/spawner/lootdrop/f13/blueprintVHighBallistics
	name = "blueprint-tier(VHighBallistics) item spawner"
	icon_state = "blueprint_loot"
	lootcount = 1
	loot = list(
		/obj/item/book/granter/crafting_recipe/blueprint/plasmarifle,
		/obj/item/book/granter/crafting_recipe/blueprint/am_rifle,
		/obj/item/book/granter/crafting_recipe/blueprint/citykiller,
		/obj/item/book/granter/crafting_recipe/blueprint/rangemaster,
		/obj/item/book/granter/crafting_recipe/blueprint/bozar
	)

/obj/effect/spawner/lootdrop/f13/advcrafting
	name = "advanced_crafting"
	lootcount = 1
	lootdoubles = FALSE
	loot = list(
		/obj/item/advanced_crafting_components/flux,
		/obj/item/advanced_crafting_components/lenses,
		/obj/item/advanced_crafting_components/conductors,
		/obj/item/advanced_crafting_components/receiver,
		/obj/item/advanced_crafting_components/assembly,
		/obj/item/advanced_crafting_components/alloys,
	)

/obj/effect/spawner/lootdrop/f13/attachments
	name = "attachments"
	lootcount = 1
	lootdoubles = FALSE
	loot = list(
		/obj/item/attachments/scope,
		/obj/item/attachments/burst_improvement,
		/obj/item/attachments/recoil_decrease,
		/obj/item/attachments/auto_sear
	)

/obj/effect/spawner/lootdrop/f13/npc_raider
	name = "loot drop"
	lootcount = 1
	lootdoubles = FALSE
	loot = list(
		/obj/effect/spawner/bundle/f13/sig,
		/obj/effect/spawner/bundle/f13/beretta,
		/obj/effect/spawner/bundle/f13/ninemil
	)

/obj/effect/spawner/lootdrop/f13/ncr_c_ration
	name = "c-ration spawner"
	icon = 'icons/obj/storage.dmi'
	icon_state = "c-ration"
	lootcount = 1
	loot = list(
			/obj/item/storage/box/ration/menu_one,
			/obj/item/storage/box/ration/menu_two,
			/obj/item/storage/box/ration/menu_three,
			/obj/item/storage/box/ration/menu_four,
			/obj/item/storage/box/ration/menu_five,
			/obj/item/storage/box/ration/menu_six,
			/obj/item/storage/box/ration/menu_seven,
			/obj/item/storage/box/ration/menu_eight,
			/obj/item/storage/box/ration/menu_nine,
			/obj/item/storage/box/ration/menu_ten,
			/obj/item/storage/box/ration/menu_eleven,
			)

/obj/effect/spawner/lootdrop/f13/ncr_k_ration
	name = "c-ration spawner"
	icon = 'icons/obj/storage.dmi'
	icon_state = "k-ration"
	lootcount = 1
	loot = list(
			/obj/item/storage/box/ration/ranger_breakfast,
			/obj/item/storage/box/ration/ranger_lunch,
			/obj/item/storage/box/ration/ranger_dinner,
			)
