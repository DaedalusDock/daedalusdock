/obj/item/chalk
	name = "ritual chalk"
	desc = "PLACEHOLDER"

	var/obj/effect/aether_rune/rune_path = /obj/effect/aether_rune/exchange

/obj/item/chalk/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	var/list/options = subtypesof(/obj/effect/aether_rune)
	var/new_path = tgui_input_list(user, "Select a new rune", "ritual chalk", options, rune_path)

	if(!new_path || !user.is_holding(src))
		return

	rune_path = new_path
	to_chat(user, "You will now draw \a [initial(rune_path.name)] rune.")

/obj/item/chalk/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!isopenturf(target))
		return

	var/turf/T = target
	for(var/turf/nearby_turf as anything in (RANGE_TURFS(1, target) - target))
		if(isgroundlessturf(nearby_turf) || isclosedturf(nearby_turf))
			to_chat(user, span_warning("There is not enough space there."))
			return

	var/obj/effect/aether_rune/drawn_rune = new rune_path(T)
	user.visible_message(span_notice("[user] draws \a [drawn_rune] with [src]."))
