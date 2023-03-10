/obj/item/paper_bin/pad
	name = "sticky note pad"
	desc = "A pad of densely packed sticky notes."
	icon = 'icons/obj/stickynotes.dmi'
	icon_state = "pad"
	papertype = /obj/item/paper/sticky
	w_class = WEIGHT_CLASS_SMALL
	holds_pen = FALSE

/obj/item/paper_bin/pad/examine(mob/user)
	. = ..()
	. += span_notice("Write notes on top using a <b>pen</b>.")


/obj/item/paper_bin/pad/Initialize()
	papertype = pick(typesof(/obj/item/paper/sticky))
	. = ..()

/obj/item/paper_bin/pad/attackby(obj/item/thing, mob/user)
	. = ..()
	if(istype(thing, /obj/item/pen))
		var/obj/item/paper/top_paper = papers[papers.len]
		if(top_paper.get_info_length() >= MAX_PAPER_LENGTH)
			to_chat(user, span_warning("There is no room left on \the [top_paper]."))
			return
		var/text = sanitize(input("What would you like to write?", "What's on your mind?") as text|null, MAX_PAPER_LENGTH)
		if((!text || user.get_active_held_item() != thing) || !user.canUseTopic(src, BE_CLOSE))
			return
		top_paper.info += text
		user.visible_message(span_warning("\The [user] jots a note down on \the [src]."), span_notice("You jot a note down on \the [src]."))
		top_paper.update_appearance()
		update_appearance()
		return TRUE

//Sticky notes

/obj/item/paper/sticky
	name = "sticky note"
	desc = "Note to self: buy more sticky notes."
	icon = 'icons/obj/stickynotes.dmi'
	item_flags = NOBLUDGEON
	layer = ABOVE_WINDOW_LAYER
	color = COLOR_YELLOW
	drop_sound = null
	pickup_sound = null
	slot_flags = null
	throw_range = 6
	throw_speed = 3
	embedding = EMBED_HARMLESS

/obj/item/paper/sticky/can_be_pulled()
	return FALSE //no telekinetic paper moving

/obj/item/paper/sticky/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(!proximity)
		return
	if(!user.transferItemToLoc(src, drop_location(), silent = FALSE))
		return

	var/turf/target_turf = get_turf(target)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)

	var/list/modifiers = params2list(params)
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return
	src.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
	if(dir_offset & EAST)
		pixel_x += 32
	else if(dir_offset & WEST)
		pixel_x -= 32
	src.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)
	if(dir_offset & NORTH)
		pixel_y += 32
	else if(dir_offset & SOUTH)
		pixel_y -= 32

/obj/item/paper/sticky/lime
	color = COLOR_LIME

/obj/item/paper/sticky/orange
	color = COLOR_ORANGE

/obj/item/paper/sticky/cyan
	color = COLOR_CYAN

/obj/item/paper/sticky/pink
	color = COLOR_PINK
