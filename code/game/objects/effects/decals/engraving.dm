/obj/effect/decal/writing
	name = "graffiti"
	icon_state = "writing1"
	icon = 'icons/effects/writing.dmi'
	desc = "It looks like someone has scratched something here."
	gender = PLURAL
	plane = GAME_PLANE //makes the graffiti visible over a wall.
	color = "#000000"

	var/message
	var/author = "unknown"

/obj/effect/decal/writing/New(newloc, _message, _author)
	..(newloc)
	message = _message
	if(!isnull(author))
		author = _author

/obj/effect/decal/writing/Initialize()
	var/list/random_icon_states = icon_states(icon)
	for(var/obj/effect/decal/writing/W in loc)
		random_icon_states.Remove(W.icon_state)
	if(length(random_icon_states))
		icon_state = pick(random_icon_states)
	. = ..()


/obj/effect/decal/writing/attackby(obj/item/tool, mob/user, params)
	// Sharp Item - Engrave additional message
	if (tool.sharpness)
		var/turf/target = get_turf(src)
		target.try_graffiti(user, tool)
		return TRUE
	.=..()

/obj/effect/decal/writing/welder_act(mob/living/user, obj/item/tool)
	if(!tool.tool_start_check(user, amount = 0))
		return FALSE
	user.visible_message(
		span_notice("\The [user] starts burning away \the [src] with \a [tool]."),
		span_notice("You start burning away \the [src] with \the [tool].")
	)
	if(!tool.use_tool(src, user, 1 SECONDS, volume = 25))
		return FALSE
	user.visible_message(
		span_notice("\The [user] clears away \the [src] with \a [tool]."),
		span_notice("You clear away \the [src] with \the [tool].")
	)
	qdel(src)
	return TOOL_ACT_TOOLTYPE_SUCCESS


