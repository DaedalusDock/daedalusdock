/obj/item/stack/sheet
	name = "sheet"
	lefthand_file = 'icons/mob/inhands/misc/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/sheets_righthand.dmi'
	full_w_class = WEIGHT_CLASS_NORMAL

	abstract_type = /obj/item/stack/sheet

	force = 5
	throwforce = 5
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	stamina_damage = 42
	stamina_cost = 23
	stamina_critical_chance = 10

	attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "smashes")
	attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "smash")
	novariants = FALSE
	material_flags = MATERIAL_EFFECTS

	dynamically_set_name = TRUE

	var/sheettype = null //this is used for girders in the creation of walls/false walls
	var/point_value = 0 //turn-in value for the gulag stacker - loosely relative to its rarity.
	///What type of wall does this sheet spawn
	var/walltype
	var/tram_wall_type
	/// What type of fulltile window this sheet can construct.
	var/window_type

/obj/item/stack/sheet/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)

/**
 * Facilitates sheets being smacked on the floor
 *
 * This is used for crafting by hitting the floor with items.
 * The inital use case is glass sheets breaking in to shards when the floor is hit.
 * Args:
 * * user: The user that did the action
 * * params: paramas passed in from attackby
 */
/obj/item/stack/sheet/proc/on_attack_floor(mob/user, params)
	var/list/shards = list()
	for(var/datum/material/mat in custom_materials)
		if(mat.shard_type)
			var/obj/item/new_shard = new mat.shard_type(user.loc)
			new_shard.add_fingerprint(user)
			shards += "\a [new_shard.name]"
	if(!shards.len)
		return FALSE
	user.do_attack_animation(src, ATTACK_EFFECT_BOOP)
	playsound(src, SFX_SHATTER, 70, TRUE)
	use(1)
	user.visible_message(span_notice("[user] shatters the sheet of [name] on the floor, leaving [english_list(shards)]."), \
		span_notice("You shatter the sheet of [name] on the floor, leaving [english_list(shards)]."))
	return TRUE

/// Mob action to try and install a window if the sheet can do that
/obj/item/stack/sheet/proc/try_install_window(mob/living/user, turf/location, obj/mounted_on)
	/// If we can't create a window out of this type, return FALSE to not affect attack chain.
	if(!window_type)
		return FALSE
	if(get_amount() < SHEETS_FOR_FULLTILE_WINDOW)
		to_chat(user, span_warning("You need at least two sheets of glass for that!"))
		return TRUE
	var/had_mounted_object = FALSE
	if(mounted_on)
		had_mounted_object = TRUE
		if(!mounted_on.anchored)
			to_chat(user, span_warning("[mounted_on] needs to be fastened to the floor first!"))
			return TRUE
	var/obj/structure/window/existing_window = locate() in location
	if(existing_window && existing_window.fulltile)
		to_chat(user, span_warning("There is already a window there!"))
		return TRUE
	/// Dense turf (most likely closed). Why check types of if you can check .density
	if(location.density)
		to_chat(user, span_warning("You can't install the window there!"))
		return TRUE
	to_chat(user, span_notice("You start placing the window..."))
	var/atom/target = mounted_on || location
	if(do_after(user, target, 2 SECONDS))
		/// Something we were mounting the window on was deleted, or unanchored
		if(had_mounted_object && (QDELETED(mounted_on) || !mounted_on.anchored))
			return TRUE
		var/obj/structure/window/window = new window_type(location)
		window.set_anchored(FALSE)
		window.state = 0
		use(SHEETS_FOR_FULLTILE_WINDOW)
		to_chat(user, span_notice("You place \the [window] on \the [target]."))
	return TRUE
