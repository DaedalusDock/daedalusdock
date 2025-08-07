/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * Contains:
 * Donut Box
 * Egg Box
 * Candle Box
 * Cigarette Box
 * Rolling Paper Pack
 * Cigar Case
 * Heart Shaped Box w/ Chocolates
 */

TYPEINFO_DEF(/obj/item/storage/fancy)
	default_materials = list(/datum/material/cardboard = 2000)

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox"
	base_icon_state = "donutbox"
	resistance_flags = FLAMMABLE
	/// Used by examine to report what this thing is holding.
	var/contents_tag = "errors"
	/// What type of thing to fill this storage with.
	var/spawn_type = null
	/// How many of the things to fill this storage with.
	var/spawn_count = 0
	/// Whether the container is open or not
	var/is_open = FALSE
	/// What this container folds up into when it's empty.
	var/obj/fold_result = /obj/item/stack/sheet/cardboard

/obj/item/storage/fancy/Initialize()
	. = ..()

	atom_storage.max_slots = spawn_count

/obj/item/storage/fancy/PopulateContents()
	if(!spawn_type)
		return
	for(var/i = 1 to spawn_count)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	icon_state = "[base_icon_state][is_open ? contents.len : null]"
	return ..()

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(!is_open)
		return
	if(length(contents) == 1)
		. += span_notice("There is one [contents_tag] left.")
	else
		. += span_notice("There are [contents.len <= 0 ? "no" : "[contents.len]"] [contents_tag]s left.")

/obj/item/storage/fancy/attack_self(mob/user)
	is_open = !is_open
	update_appearance()
	. = ..()
	if(contents.len)
		return
	new fold_result(user.drop_location())
	to_chat(user, span_notice("You fold the [src] into [initial(fold_result.name)]."))
	user.put_in_active_hand(fold_result)
	qdel(src)

/obj/item/storage/fancy/Exited(atom/movable/gone, direction)
	. = ..()
	is_open = TRUE
	update_appearance()

/obj/item/storage/fancy/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	is_open = TRUE
	update_appearance()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "donut box"
	desc = "Mmm. Donuts."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_open" //composite image used for mapping
	base_icon_state = "donutbox"
	spawn_type = /obj/item/food/donut/plain
	spawn_count = 6
	is_open = TRUE
	appearance_flags = KEEP_TOGETHER|LONG_GLIDE
	custom_premium_price = PAYCHECK_ASSISTANT * 6.5
	contents_tag = "donut"

/obj/item/storage/fancy/donut_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/donut))

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_appearance()

/obj/item/storage/fancy/donut_box/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][is_open ? "_inner" : null]"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()
	if(!is_open)
		return

	var/donuts = 0
	for(var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "[base_icon_state]_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	base_icon_state = "eggbox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "egg box"
	desc = "A carton for containing eggs."
	spawn_type = /obj/item/food/egg
	spawn_count = 12
	contents_tag = "egg"

/obj/item/storage/fancy/egg_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	base_icon_state = "candlebox"
	inhand_icon_state = "candlebox5"
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	spawn_count = 5
	is_open = TRUE
	contents_tag = "candle"

/obj/item/storage/fancy/candle_box/attack_self(mob/user)
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, span_notice("You fold the [src] into [initial(fold_result.name)]."))
		user.put_in_active_hand(fold_result)
		qdel(src)

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "cigarette box \"Spess\""
	desc = "The working man's cigarettes."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	inhand_icon_state = "cigpacket"
	worn_icon_state = "cigpack"
	base_icon_state = "cig"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	custom_price = PAYCHECK_ASSISTANT
	spawn_count = 6
	age_restricted = TRUE
	contents_tag = "cigarette"
	storage_type = /datum/storage/cigarette_box

	///for cigarette overlay
	var/candy = FALSE
	///Do we not have our own handling for cig overlays?
	var/display_cigs = TRUE

/obj/item/storage/fancy/cigarettes/Initialize()
	. = ..()
	atom_storage.quickdraw = TRUE
	atom_storage.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][contents.len ? null : "_empty"]"

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!is_open || !contents.len)
		return

	. += "[icon_state]_open"

	if(!display_cigs)
		return

	var/cig_position = 1
	for(var/C in contents)
		var/use_icon_state = ""

		if(istype(C, /obj/item/lighter/greyscale))
			use_icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			use_icon_state = "zippo_in"
		else if(candy)
			use_icon_state = "candy"
		else
			use_icon_state = "cigarette"

		. += "[use_icon_state]_[cig_position]"
		cig_position++

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "cigarette box \"Unda\""
	desc = "A refreshing brand of cigarettes."
	icon_state = "dromedary"
	base_icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_astro
	name = "cigarette box \"Astro\""
	desc = "The unemployed man's cigarettes."
	icon_state = "astro"
	base_icon_state = "astro"
	spawn_type = /obj/item/clothing/mask/cigarette/astro
	custom_price = PAYCHECK_ASSISTANT * 0.5 // These suck

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "cigarette box \"Robust\""
	desc = "Smoked by the robust."
	icon_state = "robust"
	base_icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "cigarette box \"Robust Gold\""
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	base_icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "cigarette box \"Carp\""
	desc = "Since '09."
	icon_state = "carp"
	base_icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette box"
	desc = "The branding has faded away."
	icon_state = "syndie"
	base_icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "cigarette box \"Midori\""
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_candy
	name = "\improper Timmy's First Candy Smokes"
	desc = "Unsure about smoking? Want to bring your children safely into the family tradition? Look no more with this special packet! Includes 100%* Nicotine-Free candy ."
	icon_state = "candy"
	base_icon_state = "candy"
	contents_tag = "candy cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/candy
	candy = TRUE
	age_restricted = FALSE

/obj/item/storage/fancy/cigarettes/cigpack_candy/Initialize(mapload)
	. = ..()
	if(prob(7))
		spawn_type = /obj/item/clothing/mask/cigarette/candy/nicotine //uh oh!

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	base_icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "cigarette box \"Xeno\""
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	base_icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of Nanotrasen brand rolling papers."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
	base_icon_state = "cig_paper_pack"
	contents_tag = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	spawn_count = 10
	custom_price = PAYCHECK_ASSISTANT * 0.4

/obj/item/storage/fancy/rollingpapers/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/rollingpaper))

///Overrides to do nothing because fancy boxes are fucking insane.
/obj/item/storage/fancy/rollingpapers/update_icon_state()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[base_icon_state]_empty"

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	base_icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	contents_tag = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_count = 5
	display_cigs = FALSE

/obj/item/storage/fancy/cigarettes/cigars/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	. = ..()
	//reset any changes the parent call may have made
	icon_state = base_icon_state

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(!is_open)
		return
	var/cigar_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
		. += "[smokes.icon_off]_[cigar_position]"
		cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "cigar case \"Cohiba Robusto\""
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "cigar case \"Havanian\""
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "chocolatebox"
	icon_state = "chocolatebox"
	base_icon_state = "chocolatebox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	contents_tag = "chocolate"
	spawn_type = /obj/item/food/tinychocolate
	spawn_count = 8

/obj/item/storage/fancy/heart_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/tinychocolate))


/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	base_icon_state = "nuggetbox"
	contents_tag = "nugget"
	spawn_type = /obj/item/food/nugget
	spawn_count = 6

/obj/item/storage/fancy/nugget_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/nugget))
