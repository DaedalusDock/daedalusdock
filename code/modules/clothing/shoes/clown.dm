/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge! Ctrl-click to toggle waddle dampeners."
	name = "clown shoes"
	icon_state = "clown"
	inhand_icon_state = "clown_shoes"
	slowdown = parent_type::slowdown + 1 // Slower than normal
	var/enabled_waddle = TRUE
	lace_time = 20 SECONDS // how the hell do these laces even work??
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/shoes/clown_shoes/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes/clown)
	LoadComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50, falloff_exponent = 20) //die off quick please

/obj/item/clothing/shoes/clown_shoes/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		if(enabled_waddle)
			ADD_WADDLE(user, WADDLE_SOURCE_CLOWNSHOES)

/obj/item/clothing/shoes/clown_shoes/unequipped(mob/user)
	. = ..()
	REMOVE_WADDLE(user, WADDLE_SOURCE_CLOWNSHOES)

/obj/item/clothing/shoes/clown_shoes/CtrlClick(mob/living/user)
	if(!isliving(user))
		return
	if(user.get_active_held_item() != src)
		to_chat(user, span_warning("You must hold the [src] in your hand to do this!"))
		return
	if (!enabled_waddle)
		to_chat(user, span_notice("You switch off the waddle dampeners!"))
		enabled_waddle = TRUE
	else
		to_chat(user, span_notice("You switch on the waddle dampeners!"))
		enabled_waddle = FALSE

/obj/item/clothing/shoes/clown_shoes/jester
	name = "jester shoes"
	desc = "A court jester's shoes, updated with modern squeaking technology."
	icon_state = "jester_shoes"
