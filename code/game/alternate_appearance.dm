GLOBAL_LIST_EMPTY(active_alternate_appearances)

/atom/proc/get_alt_appearance(key)
	return alternate_appearances?[key]

/atom/proc/remove_alt_appearance(key)
	var/datum/atom_hud/alternate_appearance/AA = alternate_appearances?[key]
	if(AA)
		AA.remove_atom_from_hud(src)

/atom/proc/add_alt_appearance(type, key, ...)
	if(!type || !key)
		return
	if(alternate_appearances?[key])
		return
	if(!ispath(type, /datum/atom_hud/alternate_appearance))
		CRASH("Invalid type passed in: [type]")

	var/list/arguments = args.Copy(2)
	return new type(arglist(arguments))

/datum/atom_hud/alternate_appearance
	var/appearance_key
	var/transfer_overlays = FALSE

/datum/atom_hud/alternate_appearance/New(key)
	// We use hud_icons to register our hud, so we need to do this before the parent call
	appearance_key = key
	hud_icons = list(appearance_key)
	..()
	GLOB.active_alternate_appearances += src
	appearance_key = key

	for(var/mob in GLOB.player_list)
		if(mobShouldSee(mob))
			show_to(mob)

/datum/atom_hud/alternate_appearance/Destroy()
	GLOB.active_alternate_appearances -= src
	return ..()

/datum/atom_hud/alternate_appearance/proc/onNewMob(mob/M)
	if(mobShouldSee(M))
		show_to(M)

/datum/atom_hud/alternate_appearance/proc/mobShouldSee(mob/M)
	return FALSE

/datum/atom_hud/alternate_appearance/add_atom_to_hud(atom/A, image/I)
	. = ..()
	if(.)
		LAZYINITLIST(A.alternate_appearances)
		A.alternate_appearances[appearance_key] = src

/datum/atom_hud/alternate_appearance/remove_atom_from_hud(atom/A)
	. = ..()
	if(.)
		LAZYREMOVE(A.alternate_appearances, appearance_key)

/datum/atom_hud/alternate_appearance/proc/copy_overlays(atom/other, cut_old)
	return

/obj/alt_appearance_tester
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"

/obj/alt_appearance_tester/Initialize(mapload)
	. = ..()
	var/image/I = image('icons/obj/tools.dmi', src, "wrench_brass")
	I.layer = layer
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "gold_wrench", I)

//an alternate appearance that attaches a single image to a single atom
/datum/atom_hud/alternate_appearance/basic
	var/atom/target
	var/image/image
	var/add_ghost_version = FALSE
	var/ghost_appearance
	uses_global_hud_category = FALSE

/datum/atom_hud/alternate_appearance/basic/New(key, image/I, options = AA_TARGET_SEE_APPEARANCE)
	..()
	transfer_overlays = options & AA_MATCH_TARGET_OVERLAYS
	image = I
	target = I.loc
	if(transfer_overlays)
		I.copy_overlays(target)

	add_atom_to_hud(target)
	target.set_hud_image_active(appearance_key, exclusive_hud = src)

	if((options & AA_TARGET_SEE_APPEARANCE) && ismob(target))
		show_to(target)

	if(add_ghost_version)
		var/image/ghost_image = image(icon = I.icon , icon_state = I.icon_state, loc = I.loc)
		ghost_image.override = FALSE
		ghost_image.alpha = 128
		ghost_appearance = new /datum/atom_hud/alternate_appearance/basic/observers(key + "_observer", ghost_image, NONE)

	if(ismovable(target))
		var/atom/movable/AM = target
		if(AM.bound_overlay)
			mimic(AM.bound_overlay)

/datum/atom_hud/alternate_appearance/basic/Destroy()
	. = ..()
	QDEL_NULL(image)
	target = null
	if(ghost_appearance)
		QDEL_NULL(ghost_appearance)

/datum/atom_hud/alternate_appearance/basic/proc/mimic(atom/movable/openspace/mimic/mimic)
	var/image/mimic_image = image(image.icon, mimic, image.icon_state, image.layer)
	mimic_image.plane = image.plane
	var/datum/atom_hud/alternate_appearance/basic/mimic_appearance = new type(appearance_key, mimic_image)
	return mimic_appearance

/datum/atom_hud/alternate_appearance/basic/add_atom_to_hud(atom/A)
	LAZYINITLIST(A.hud_list)
	A.hud_list[appearance_key] = image
	. = ..()

/datum/atom_hud/alternate_appearance/basic/remove_atom_from_hud(atom/A)
	. = ..()
	LAZYREMOVE(A.hud_list, appearance_key)
	A.set_hud_image_inactive(appearance_key)
	if(. && !QDELETED(src))
		qdel(src)

/datum/atom_hud/alternate_appearance/basic/copy_overlays(atom/other, cut_old)
	image.copy_overlays(other, cut_old)

/datum/atom_hud/alternate_appearance/basic/living
	add_ghost_version = TRUE

/datum/atom_hud/alternate_appearance/basic/living/mobShouldSee(mob/M)
	return !isdead(M)

/datum/atom_hud/alternate_appearance/basic/everyone

/datum/atom_hud/alternate_appearance/basic/everyone/mobShouldSee(mob/M)
	return TRUE

/datum/atom_hud/alternate_appearance/basic/silicons

/datum/atom_hud/alternate_appearance/basic/silicons/mobShouldSee(mob/M)
	if(issilicon(M))
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/observers
	add_ghost_version = FALSE //just in case, to prevent infinite loops

/datum/atom_hud/alternate_appearance/basic/observers/mobShouldSee(mob/M)
	return isobserver(M)

/datum/atom_hud/alternate_appearance/basic/noncult

/datum/atom_hud/alternate_appearance/basic/noncult/mobShouldSee(mob/M)
	if(!IS_CULTIST(M))
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/cult

/datum/atom_hud/alternate_appearance/basic/cult/mobShouldSee(mob/M)
	if(IS_CULTIST(M))
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/blessed_aware

/datum/atom_hud/alternate_appearance/basic/blessed_aware/mobShouldSee(mob/M)
	if(M.mind?.holy_role)
		return TRUE
	if (istype(M, /mob/living/simple_animal/hostile/construct/wraith))
		return TRUE
	if(isrevenant(M) || IS_WIZARD(M))
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/one_person
	var/mob/seer

/datum/atom_hud/alternate_appearance/basic/one_person/mobShouldSee(mob/M)
	if(M == seer)
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/one_person/New(key, image/I, mob/living/M)
	..(key, I, FALSE)
	seer = M

/datum/atom_hud/alternate_appearance/basic/one_person/mimic(atom/movable/openspace/mimic/mimic)
	var/datum/atom_hud/alternate_appearance/basic/one_person/alt_appearance = ..()
	alt_appearance.seer = seer

/datum/atom_hud/alternate_appearance/basic/food_demands
