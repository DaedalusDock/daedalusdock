//Bulletproof riot shield
obj/item/shield/riot
	var/repair_material = null

#warn add repair material!

obj/item/shield/riot/bullet_proof
	name = "bullet resistant shield"
	desc = "Kevlar coated surface makes this riot shield a lot better for blocking projectiles."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/shields.dmi'
	icon_state = "shield_bulletproof"
	inhand_icon_state = "shield_bulletproof"
	max_integrity = 400
	block_chance = 50
	custom_materials = list(/datum/material/plastic=8000, /datum/material/titanium=1000)
	repair_material = /obj/item/stack/sheet/mineral/titanium

TYPEINFO_DEF(/obj/item/shield/riot/bullet_proof)
	default_armor = list(BLUNT = 20, PUNCTURE = 35, SLASH = 50, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

//Buckler. Cheapest shield, also the worst.
/obj/item/shield/riot/buckler
	name = "wooden buckler"
	desc = "A small wooden shield."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/shields.dmi'
	icon_state = "shield_buckler"
	inhand_icon_state = "shield_buckler"
	block_chance = 25
	max_integrity = 200
	custom_materials = list(/datum/material/wood = 18000)
	resistance_flags = FLAMMABLE
	repair_material = /obj/item/stack/sheet/mineral/wood

/obj/item/shield/riot/buckler/shatter(mob/living/carbon/human/owner)
	playsound(owner, 'sound/effects/bang.ogg', 50)
	new /obj/item/stack/sheet/mineral/wood(get_turf(src))

TYPEINFO_DEF(/obj/item/shield/riot/buckler)
	default_armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 50, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

// Stop sign shield.
/obj/item/shield/riot/buckler/stop
	name = "stop sign buckler"
	desc = "Made from a ancient roadsign, with handles made of rope."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/shields.dmi'
	icon_state = "shield_stop"
	inhand_icon_state = "shield_stop"
	resistance_flags = null
	repair_material = /obj/item/stack/sheet/iron

//Legion shield
/obj/item/shield/riot/legion
	name = "legion shield"
	desc = "Heavy shield with metal pieces bolted to a wood backing, with a painted yellow bull insignia in the centre."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/shields.dmi'
	icon_state = "shield_legion"
	inhand_icon_state = "shield_legion"
	force = 15
	max_integrity = 300
	block_chance = 50
	custom_materials = list(/datum/material/wood = 16000, /datum/material/iron= 16000)
	repair_material = /obj/item/stack/sheet/mineral/wood


TYPEINFO_DEF(/obj/item/shield/riot/legion)
	default_armor = list(BLUNT = 50, PUNCTURE = 50, SLASH = 75, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)


/obj/item/shield/riot/legion/shatter(mob/living/carbon/human/owner)
	playsound(owner, 'sound/effects/grillehit.ogg', 100)
	new /obj/item/stack/sheet/iron(get_turf(src))

//Scrap shield. Somewhat cheaper, simpler and worse than Legion shield but basically similar.
/obj/item/shield/riot/scrapshield
	name = "scrap shield"
	desc = "A large shield made of glued and welded sheets of metal. Heavy and clumsy, but at least its handle is wrapped in some cloth."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/shields.dmi'
	icon_state = "shield_scrap"
	inhand_icon_state = "shield_scrap"
	max_integrity = 250
	block_chance = 35
	force = 15
	custom_materials = list(/datum/material/iron = 16000)
	repair_material = /obj/item/stack/sheet/iron


TYPEINFO_DEF(/obj/item/shield/riot/scrapshield)
	default_armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 60, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
