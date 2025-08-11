/datum/component/hidden_blood
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/obj/item/parent_item
	var/obj/effect/overlay/vis/blood_vis_overlay
	var/obj/effect/overlay/vis/emissive_vis_overlay

	var/hide_timer_id

/datum/component/hidden_blood/Initialize(...)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	parent_item = parent

/datum/component/hidden_blood/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_MOVABLE_FLUORESCENT, ref(src))
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))
	RegisterSignal(parent, COMSIG_MOVABLE_UV_EXPOSE, PROC_REF(on_uv_expose))
	RegisterSignal(parent, COMSIG_MOVABLE_UV_HIDE, PROC_REF(on_uv_hide))

/datum/component/hidden_blood/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_MOVABLE_FLUORESCENT, ref(src))
	UnregisterSignal(parent, list(COMSIG_COMPONENT_CLEAN_ACT, COMSIG_MOVABLE_UV_EXPOSE, COMSIG_MOVABLE_UV_HIDE))
	parent_item.remove_viscontents(blood_vis_overlay)
	parent_item = null

/datum/component/hidden_blood/Destroy(force, silent)
	QDEL_NULL(blood_vis_overlay)
	QDEL_NULL(emissive_vis_overlay)
	deltimer(hide_timer_id)
	return ..()

/datum/component/hidden_blood/proc/on_uv_expose(datum/source, uv_source, animate_time, new_alpha)
	SIGNAL_HANDLER

	var/mutable_appearance/blood_overlay = GLOB.bloody_item_images[BLOODY_OVERLAY_KEY(parent_item)]
	if(isnull(blood_overlay)) // This should be theoretically impossible but fuck you.
		return

	if(hide_timer_id)
		deltimer(hide_timer_id)

	if(!blood_vis_overlay)
		blood_vis_overlay = new()
		blood_vis_overlay.appearance = blood_overlay
		blood_vis_overlay.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
		blood_vis_overlay.color = COLOR_LUMINOL
		blood_vis_overlay.alpha = 0

		emissive_vis_overlay = new()
		emissive_vis_overlay.appearance = emissive_appearance(blood_vis_overlay.icon, blood_overlay.icon_state)
		emissive_vis_overlay.vis_flags = VIS_INHERIT_ID  | VIS_INHERIT_LAYER


	animate(blood_vis_overlay, alpha = new_alpha, time = animate_time)
	animate(emissive_vis_overlay, alpha = new_alpha, time = animate_time)
	parent_item.add_viscontents(blood_vis_overlay)

/datum/component/hidden_blood/proc/on_uv_hide(datum/source, uv_source, animate_time)
	SIGNAL_HANDLER

	if(!blood_vis_overlay)
		return

	if(HAS_TRAIT_NOT_FROM(parent_item, TRAIT_MOVABLE_FLUORESCENCE_REVEALED, uv_source))
		return // It's still being illuminated by something else.

	blood_vis_overlay.alpha = 0

	animate(blood_vis_overlay, alpha = 0, time = animate_time)
	animate(emissive_vis_overlay, alpha = 0, time = animate_time)
	hide_timer_id = addtimer(CALLBACK(parent_item, TYPE_PROC_REF(/atom, remove_viscontents), blood_vis_overlay), animate_time, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/component/hidden_blood/proc/on_wash(datum/source, clean_types)
	SIGNAL_HANDLER

	if(clean_types & CLEAN_TYPE_HIDDEN_BLOOD)
		qdel(src)
		return COMPONENT_CLEANED
