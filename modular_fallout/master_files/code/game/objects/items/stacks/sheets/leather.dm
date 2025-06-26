/obj/item/stack/sheet/animalhide/human
	name = "human skin"
	desc = "hopefully it was cut from a feral ghoul."
	icon_state = "sheet-humhide"
	singular_name = "human skin piece"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/human

/*
 * Leather SHeet
 */

/obj/item/stack/sheet/leather/five
	amount = 5

/obj/item/stack/sheet/leather/twenty
	amount = 20

		/*
 * Plates
 */

/obj/item/stack/sheet/animalhide/chitin
	name = "insect chitin"
	desc = "Thick insect chitin, tough but light."
	singular_name = "piece of insect chitin"
	icon_state = "sheet-chitin"
	grind_results = list(/datum/reagent/sodium = 3, /datum/reagent/chlorine = 3)
	merge_type = /obj/item/stack/sheet/animalhide/chitin
