/obj/effect/spawner/random/medical
	name = "medical loot spawner"
	desc = "Doc, gimmie something good."

/obj/effect/spawner/random/medical/minor_healing
	name = "minor healing spawner"
	icon_state = "gauze"
	loot = list(
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/mesh,
		/obj/item/stack/gauze,
	)

/obj/effect/spawner/random/medical/injector
	name = "injector spawner"
	icon_state = "syringe"
	loot = list(
		/obj/item/implanter,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
	)

/obj/effect/spawner/random/medical/organs
	name = "ayylien organ spawner"
	icon_state = "eyes"
	spawn_loot_count = 3
	loot = list(
		/obj/item/organ/heart/gland/egg = 7,
		/obj/item/organ/heart/gland/plasma = 7,
		/obj/item/organ/heart/gland/chem = 5,
		/obj/item/organ/heart/gland/mindshock = 5,
		/obj/item/organ/heart/gland/transform = 5,
		/obj/item/organ/heart/gland/slime = 4,
		/obj/item/organ/heart/gland/trauma = 4,
		/obj/item/organ/heart/gland/electric = 3,
		/obj/item/organ/regenerative_core = 2,
		/obj/item/organ/heart/gland/ventcrawling = 1,
		/obj/item/organ/body_egg/alien_embryo = 1,
	)

/obj/effect/spawner/random/medical/memeorgans
	name = "meme organ spawner"
	icon_state = "eyes"
	spawn_loot_count = 5
	loot = list(
		/obj/item/organ/ears/penguin,
		/obj/item/organ/ears/cat,
		/obj/item/organ/eyes/moth,
		/obj/item/organ/eyes/snail,
		/obj/item/organ/tongue/bone,
		/obj/item/organ/tongue/fly,
		/obj/item/organ/tongue/snail,
		/obj/item/organ/tongue/lizard,
		/obj/item/organ/tongue/alien,
		/obj/item/organ/tongue/ethereal,
		/obj/item/organ/tongue/robot,
		/obj/item/organ/tongue/zombie,
		/obj/item/organ/appendix,
		/obj/item/organ/liver/fly,
		/obj/item/organ/tail/cat,
		/obj/item/organ/tail/lizard,
	)

/obj/effect/spawner/random/medical/two_percent_xeno_egg_spawner
	name = "2% chance xeno egg spawner"
	icon_state = "xeno_egg"
	loot = list(
		/obj/effect/decal/remains/xeno = 49,
		/obj/effect/spawner/xeno_egg_delivery = 1,
	)

/obj/effect/spawner/random/medical/surgery_tool
	name = "Surgery tool spawner"
	icon_state = "scapel"
	loot = list(
		/obj/item/scalpel,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/cautery,
		/obj/item/bonesetter,
	)

/obj/effect/spawner/random/medical/surgery_tool_advanced
	name = "Advanced surgery tool spawner"
	icon_state = "scapel"
	loot = list( // Mail loot spawner. Drop pool of advanced medical tools typically from research. Not endgame content.
		/obj/item/scalpel/advanced,
		/obj/item/retractor/advanced,
		/obj/item/cautery/advanced,
	)

/obj/effect/spawner/random/medical/surgery_tool_alien
	name = "Rare surgery tool spawner"
	icon_state = "scapel"
	loot = list( // Mail loot spawner. Some sort of random and rare surgical tool. Alien tech found here.
		/obj/item/scalpel/alien,
		/obj/item/hemostat/alien,
		/obj/item/retractor/alien,
		/obj/item/circular_saw/alien,
		/obj/item/surgicaldrill/alien,
		/obj/item/cautery/alien,
	)

/obj/effect/spawner/random/medical/medkit_rare
	name = "rare medkit spawner"
	icon_state = "medkit"
	loot = list(
		/obj/item/storage/medkit/emergency,
		/obj/item/storage/medkit/surgery,
		/obj/item/storage/medkit/advanced,
	)

/obj/effect/spawner/random/medical/medkit
	name = "medkit spawner"
	icon_state = "medkit"
	loot = list(
		/obj/item/storage/medkit/regular = 10,
		/obj/item/storage/medkit/o2 = 10,
		/obj/item/storage/medkit/fire = 10,
		/obj/item/storage/medkit/brute = 10,
		/obj/item/storage/medkit/toxin = 10,
		/obj/effect/spawner/random/medical/medkit_rare = 1,
	)

/obj/effect/spawner/random/medical/patient_stretcher
	name = "patient stretcher spawner"
	icon_state = "rollerbed"
	loot = list(
		/obj/structure/bed/roller,
		/obj/vehicle/ridden/wheelchair,
	)

/obj/effect/spawner/random/medical/supplies
	name = "medical supplies spawner"
	icon_state = "box_small"
	loot = list(
		/obj/item/storage/box/hug,
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/rxglasses,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/syringes,
	)

/obj/effect/spawner/random/medical/chem_cartridge
	name = "random chem cartridge"
	spawn_loot_count = 1

//this is just here for subtypes
/obj/effect/spawner/random/medical/chem_cartridge/proc/get_chem_list()
	return GLOB.cartridge_list_chems

/obj/effect/spawner/random/medical/chem_cartridge/spawn_loot(lootcount_override)
	var/list/spawn_cartridges = get_chem_list()
	var/loot_spawned = 0
	for(var/i in 1 to spawn_loot_count)
		var/datum/reagent/chem_type = pick(spawn_cartridges)
		var/obj/item/reagent_containers/chem_cartridge/chem_cartridge = spawn_cartridges[chem_type]
		chem_cartridge = new chem_cartridge(loc)
		chem_cartridge.reagents.add_reagent(chem_type, chem_cartridge.volume)
		chem_cartridge.setLabel(initial(chem_type.name))
		loot_spawned += 1

/obj/effect/spawner/random/medical/chem_cartridge/three
	name = "3x random chem cartridge"
	spawn_loot_count = 3

/obj/effect/spawner/random/medical/chem_cartridge/booze
	name = "random booze cartridge"
	spawn_loot_count = 1

/obj/effect/spawner/random/medical/chem_cartridge/booze/get_chem_list()
	return GLOB.cartridge_list_booze

/obj/effect/spawner/random/medical/chem_cartridge/booze/three
	name = "3x random booze cartridge"
	spawn_loot_count = 3

/obj/effect/spawner/random/medical/chem_cartridge/drink
	name = "random drink cartridge"
	spawn_loot_count = 1

/obj/effect/spawner/random/medical/chem_cartridge/drink/get_chem_list()
	return GLOB.cartridge_list_drinks

/obj/effect/spawner/random/medical/chem_cartridge/drink/three
	name = "3x random drink cartridge"
	spawn_loot_count = 3
