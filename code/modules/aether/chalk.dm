/obj/item/chalk
	name = "ritual chalk"
	desc = "A stick of chalk."
	icon = 'icons/obj/items/chalk.dmi'
	icon_state = "chalk"

	var/obj/effect/aether_rune/rune_path = /obj/effect/aether_rune/exchange

/obj/item/chalk/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/chalk/add_item_context(obj/item/source, list/context, atom/target, mob/living/user)
	if(isturf(target))
		context[SCREENTIP_CONTEXT_LMB] = "Draw sigil"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/chalk/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	if(!HAS_TRAIT(user, TRAIT_AETHERITE))
		to_chat(src, span_warning("You are not sure what to do with this."))
		return

	var/list/options = list()
	for(var/obj/effect/aether_rune/path as anything in subtypesof(/obj/effect/aether_rune))
		options[initial(path.rune_type)] = path

	var/entry = tgui_input_list(user, "Select a new rune", "ritual chalk", options, rune_path)

	if(!options[entry] || !user.is_holding(src))
		return

	rune_path = options[entry]
	to_chat(user, span_notice("You will now draw \a [entry] rune."))

/obj/item/chalk/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isopenturf(interacting_with))
		return NONE

	if(!HAS_TRAIT(user, TRAIT_AETHERITE))
		to_chat(src, span_warning("You are not sure what to do with this."))
		return ITEM_INTERACT_BLOCKING

	var/turf/T = interacting_with
	for(var/turf/nearby_turf as anything in (RANGE_TURFS(1, interacting_with) - interacting_with))
		if(isgroundlessturf(nearby_turf) || isclosedturf(nearby_turf) || (locate(/obj/effect/aether_rune) in nearby_turf) || (locate(/obj/structure/low_wall) in nearby_turf))
			to_chat(user, span_warning("There is not enough space there."))
			return ITEM_INTERACT_BLOCKING

	if(!do_after(user, T, 3 SECONDS, DO_PUBLIC|DO_RESTRICT_CLICKING|DO_RESTRICT_USER_DIR_CHANGE, display = src))
		return ITEM_INTERACT_BLOCKING

	var/obj/effect/aether_rune/drawn_rune = new rune_path(T)
	user.visible_message(span_notice("[user] draws \a [drawn_rune] with [src]."))
	qdel(src)
	return ITEM_INTERACT_SUCCESS
