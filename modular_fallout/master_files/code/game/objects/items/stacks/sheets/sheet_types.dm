/*
prewar alloys
*/
/obj/item/stack/sheet/prewar
	name = "pre-war alloys"
	singular_name = "pre war alloy"
	desc = "This sheet was manufactured by using advanced smelting techniques before the war."
	icon_state = "sheet-prewar"
	inhand_icon_state  = "sheet-metal"
	custom_materials = list()
	throwforce = 10
	flags_1 = CONDUCT_1
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 25, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 80)
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/prewar
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/toxin/plasma = 20)

/obj/item/stack/sheet/prewar/twenty
	amount = 20

/obj/item/stack/sheet/prewar/five
	amount = 5

/obj/item/stack/sheet/prewar/fifty
	amount = 50

/obj/item/stack/sheet/hay
	name = "hay"
	desc = "A bundle of hay. Useful for weaving. Hail the Wickerman." //Brahmin can't currently eat this.
	singular_name = "hay stalk"
	icon_state = "sheet-hay"
	inhand_icon_state  = "sheet-hay"
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	max_amount = 50 //reduced from 500, made stacks sprites irrelevant due to scaling.
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 25, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 0)
	resistance_flags = FLAMMABLE
	attack_verb_simple = list("tickled", "poked", "whipped")
	hitsound = 'modular_fallout/master_files/sound/weapons/grenadelaunch.ogg'
	merge_type = /obj/item/stack/sheet/hay

/obj/item/stack/sheet/hay/fifty
	amount = 50

/obj/item/stack/sheet/hay/twenty
	amount = 20

/obj/item/stack/sheet/hay/ten
	amount = 10

/obj/item/stack/sheet/hay/five
	amount = 5

/obj/item/stack/sheet/lead
	name = "lead"
	desc = "Sheets made out of lead."
	singular_name = "lead sheet"
	icon_state = "sheet-lead"
	inhand_icon_state = "sheet-lead"
	custom_materials = list(/datum/material/lead=MINERAL_MATERIAL_AMOUNT)
	throwforce = 10
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/lead
	grind_results = list(/datum/reagent/lead = 20)
	point_value = 2
	//tableVariant = /obj/structure/table
	material_type = /datum/material/lead

/obj/item/stack/sheet/lead/fifty
	amount = 50

/obj/item/stack/sheet/lead/twenty
	amount = 20

/obj/item/stack/sheet/lead/ten
	amount = 10

/obj/item/stack/sheet/lead/five
	amount = 5

// MISC //

/obj/item/stack/sheet/plasteel/five
	amount = 5

/obj/item/stack/sheet/iron/five
	amount = 5

/obj/item/stack/sheet/iron/ten
	amount = 10

/obj/item/stack/sheet/cardboard/twenty
	amount = 20
