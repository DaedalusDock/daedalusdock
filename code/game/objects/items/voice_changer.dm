/obj/item/voice_changer
	name = "voice changer"
	desc = "This voice-modulation device will dynamically disguise your voice to that of whoever is listed on your identification card, via incredibly complex algorithms. Discretely fits inside most gasmasks, and can be removed with wirecutters."
	icon_state = "voicechanger"
	icon = 'goon/icons/obj/items.dmi'

/datum/component/voice_changer
	var/obj/item/voice_changer/item

/datum/component/voice_changer/Initialize(obj/item/voice_changer/item)
	. = ..()
	src.item = item
	item.moveToNullspace()
	RegisterSignal(item, COMSIG_PARENT_QDELETING, PROC_REF(destroyme))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examined))
	RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_WIRECUTTER), PROC_REF(cut))
	ADD_TRAIT(parent, TRAIT_REPLACES_VOICE, REF(src))

/datum/component/voice_changer/Destroy(force, silent)
	REMOVE_TRAIT(parent, TRAIT_REPLACES_VOICE, REF(src))
	if(!QDELETED(item))
		qdel(item)
	item = null
	return ..()

/datum/component/voice_changer/proc/destroyme()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/voice_changer/proc/examined(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(get_dist(get_turf(parent), get_turf(user)) <= 1)
		examine_list += "<span class='danger'> There's a strange device inside held in place by some <u>wires</u>.</span>"

/datum/component/voice_changer/proc/cut(datum/source, mob/user, obj/item/tool)
	SIGNAL_HANDLER
	if(!user.is_holding(parent))
		return
	var/atom/atom_parent = parent
	to_chat(user, span_notice("You remove [item] from [parent] with [tool]."))
	item.forceMove(atom_parent.drop_location())
	tool.play_tool_sound(tool, 50)
	item = null
	qdel(src)
	return ITEM_INTERACT_SUCCESS
