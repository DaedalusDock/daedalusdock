/obj/item/chalk
	name = "ritual chalk"
	desc = "A stick of chalk."
	icon = 'icons/obj/items/chalk.dmi'
	icon_state = "chalk"

	var/obj/effect/aether_rune/rune_path = /obj/effect/aether_rune/exchange

/obj/item/chalk/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	var/list/options = list()
	for(var/obj/effect/aether_rune/path as anything in subtypesof(/obj/effect/aether_rune))
		options[initial(path.rune_type)] = path

	var/entry = tgui_input_list(user, "Select a new rune", "ritual chalk", options, rune_path)

	if(!options[entry] || !user.is_holding(src))
		return

	rune_path = options[entry]
	to_chat(user, span_notice("You will now draw \a [entry] rune."))

/obj/item/chalk/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!isopenturf(target))
		return

	var/turf/T = target
	for(var/turf/nearby_turf as anything in (RANGE_TURFS(1, target) - target))
		if(isgroundlessturf(nearby_turf) || isclosedturf(nearby_turf) || (locate(/obj/effect/aether_rune) in nearby_turf) || (locate(/obj/structure/low_wall) in nearby_turf))
			to_chat(user, span_warning("There is not enough space there."))
			return

	if(!do_after(user, T, 3 SECONDS, DO_PUBLIC|DO_RESTRICT_CLICKING|DO_RESTRICT_USER_DIR_CHANGE, display = src))
		return

	var/obj/effect/aether_rune/drawn_rune = new rune_path(T)
	user.visible_message(span_notice("[user] draws \a [drawn_rune] with [src]."))
	qdel(src)
	return TRUE
