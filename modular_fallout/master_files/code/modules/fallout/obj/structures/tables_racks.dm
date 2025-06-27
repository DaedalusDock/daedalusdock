//A table that'd be built by players, since their constructions would be... less impressive than their prewar counterparts.

/obj/structure/table/wood/settler
	desc = "A wooden table constructed by a carpentering amateur from various planks.<br>It's the work of wasteland settler."
	icon_state = "settlertable"
	icon = 'modular_fallout/master_files/icons/obj/smooth_structures/wood_table_settler.dmi'
//	icon_type_smooth = "settlertable"
	max_integrity = 50
	canSmoothWith = list(/obj/structure/table/wood/settler)

/obj/structure/table/booth
	name = "booth table"
	desc = "A diner style booth table."
	icon = 'modular_fallout/master_files/icons/obj/smooth_structures/booth_table.dmi'
	icon_state = "boothtable"
	flags_1 = NODECONSTRUCT_1
	canSmoothWith = list(/obj/structure/table/booth)

/obj/structure/table/booth/Initialize()
	canSmoothWith += subtypesof(/turf/closed/wall/f13/wood) + subtypesof(/obj/structure/window/fulltile)
	. = ..()

/obj/structure/table/booth/deconstruction_hints(mob/user)
	return span_notice("The top is panelled together and could likely be taken apart with a crowbar.")

/obj/structure/table/booth/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/crowbar) && deconstruction_ready)
		to_chat(user, span_notice("You start deconstructing [src]..."))
		if(I.use_tool(src, user, 40, volume=50))
			playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
			deconstruct(TRUE)
			return TRUE

	return ..()

/obj/structure/table/snooker
	name = "pool table"
	desc = "A cloth surfaced pool table for that bar themed aesthetic! Bring over the brews! Pool not included."
	icon = 'modular_fallout/master_files/icons/obj/structures.dmi'
	icon_state = "nv_pooltable"
	anchored = TRUE
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/cloth
	smoothing_flags = null

/obj/structure/table/snooker/attackby(obj/item/I, mob/user, params)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(istype(I, /obj/item/screwdriver) && deconstruction_ready)
			to_chat(user, "<span class='notice'>You start disassembling [src]...</span>")
			if(I.use_tool(src, user, 20, volume=50))
				deconstruct(TRUE)
			return
		if(istype(I, /obj/item/wrench))
			to_chat(user, "<span class='notice'>You [anchored ? "unwrench" : "wrench"] the [src].</span>")
			anchored = !anchored
		if(istype(I, /obj/item/crowbar) && deconstruction_ready)
			to_chat(user, "<span class='notice'>You start deconstructing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
				deconstruct(TRUE, 1)

	if(!(I.item_flags & ABSTRACT))
		if(user.transferItemToLoc(I, drop_location()))
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
			return TRUE
	else
		return ..()

/obj/structure/table/snooker/proc/can_be_rotated(mob/user,rotation_type)
	if(anchored)
		to_chat(user, "<span class='warning'>[src] cannot be rotated while the spinning bolts are in place!</span>")
		return FALSE

/obj/structure/table/snooker/Initialize()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_EIGHTDIR)
