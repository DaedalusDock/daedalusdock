/obj/item/stack/overfloor_catwalk
	name = "catwalk floor covers"
	singular_name = "catwalk floor cover"
	desc = "A cover for plating, permitting access to wires and pipes."

	lefthand_file = 'icons/mob/inhands/misc/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/tiles_righthand.dmi'
	icon = 'icons/obj/tiles.dmi'
	icon_state = "maint_catwalk"
	inhand_icon_state = "tile-catwalk"

	w_class = WEIGHT_CLASS_NORMAL
	force = 6
	throwforce = 15
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	material_flags = MATERIAL_EFFECTS

	mats_per_unit = list(/datum/material/iron=100)
	merge_type = /obj/item/stack/overfloor_catwalk
	dynamically_set_name = TRUE

	var/catwalk_type = /obj/structure/overfloor_catwalk

/**
 * Place our tile on a plating, or replace it.
 *
 * Arguments:
 * * target_plating - Instance of the plating we want to place on. Replaced during sucessful executions.
 * * user - The mob doing the placing.
 */
/obj/item/stack/overfloor_catwalk/proc/place_tile(turf/open/floor/target_floor, mob/user)
	if(!ispath(catwalk_type, /obj/structure/overfloor_catwalk))
		return

	if(!istype(target_floor))
		return

	if(locate(/obj/structure/overfloor_catwalk) in target_floor)
		return

	if(!use(1))
		return

	playsound(target_floor, 'sound/weapons/genhit.ogg', 50, TRUE)
	new catwalk_type (target_floor)
	return target_floor // Most executions should end here.

/obj/item/stack/overfloor_catwalk/sixty
	amount = 60

/obj/item/stack/overfloor_catwalk/iron
	name = "iron catwalk floor covers"
	singular_name = "iron catwalk floor cover"
	icon_state = "iron_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/iron
	catwalk_type = /obj/structure/overfloor_catwalk/iron

/obj/item/stack/overfloor_catwalk/iron_white
	name = "white catwalk floor covers"
	singular_name = "white catwalk floor cover"
	icon_state = "whiteiron_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/iron_white
	catwalk_type = /obj/structure/overfloor_catwalk/iron_white

/obj/item/stack/overfloor_catwalk/iron_dark
	name = "dark catwalk floor covers"
	singular_name = "dark catwalk floor cover"
	icon_state = "darkiron_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/iron_dark
	catwalk_type = /obj/structure/overfloor_catwalk/iron_dark

/obj/item/stack/overfloor_catwalk/flat_white
	name = "flat white catwalk floor covers"
	singular_name = "flat white catwalk floor cover"
	icon_state = "flatwhite_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/flat_white
	catwalk_type = /obj/structure/overfloor_catwalk/flat_white

/obj/item/stack/overfloor_catwalk/titanium
	name = "titanium catwalk floor covers"
	singular_name = "titanium catwalk floor cover"
	icon_state = "titanium_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/titanium
	catwalk_type = /obj/structure/overfloor_catwalk/titanium

/obj/item/stack/overfloor_catwalk/iron_smooth
	name = "iron catwalk floor covers"
	singular_name = "titanium catwalk floor cover"
	icon_state = "smoothiron_catwalk"
	merge_type = /obj/item/stack/overfloor_catwalk/iron_smooth
	catwalk_type = /obj/structure/overfloor_catwalk/iron_smooth
