/obj/effect/abstract/info_tag
	plane = INFO_TAG_PLANE
	layer = 1
	alpha = 180

	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	vis_flags = VIS_INHERIT_ID

	/// Atom we're displaying over.
	var/atom/parent

	/// Mobs that see us rn.
	var/list/mob/viewing_mobs
	/// Images we're inserting into client.images
	VAR_PRIVATE/image/vis_holder

	/// If set, will allow INSTANCES_OF(atlas_category) to get all instances.
	var/atlas_category = null

/obj/effect/abstract/info_tag/Initialize(mapload)
	. = ..()
	vis_holder = new()
	vis_holder.plane = INFO_TAG_PLANE
	vis_holder.vis_contents += src

	if(atlas_category)
		SET_TRACKING(atlas_category)

/obj/effect/abstract/info_tag/Destroy(force)
	set_parent(null)
	vis_holder = null
	if(atlas_category)
		UNSET_TRACKING(atlas_category)

	for(var/mob/M in viewing_mobs)
		hide_from(M.client)
		LAZYREMOVE(M.seeing_info_tags, src)

	viewing_mobs = null
	return ..()

/obj/effect/abstract/info_tag/proc/set_parent(atom/new_parent)
	parent = new_parent
	vis_holder.loc = parent

/// Update the text.
/obj/effect/abstract/info_tag/proc/set_text(text)
	maptext = "<span class='maptext' style='text-align: center;font-size: 6px'>[text]</span>"

/// Should the given mob be able to see this tag?
/obj/effect/abstract/info_tag/proc/mob_should_see(mob/M)
	return TRUE

/obj/effect/abstract/info_tag/proc/show_to(client/C)
	C?.images |= vis_holder

/obj/effect/abstract/info_tag/proc/hide_from(client/C)
	C?.images -= vis_holder

/obj/effect/abstract/info_tag/flock
	maptext_x = -64
	maptext_y = -6
	maptext_width = 160
	maptext_height = 48

	atlas_category = TRACKING_KEY_FLOCK_INFO_HUDS

/obj/effect/abstract/info_tag/flock/mob_should_see(mob/M)
	return (M != parent) && isflockmob(M)

/obj/effect/abstract/info_tag/flock/info
	maptext_x = -64
	maptext_y = -14
	maptext_width = 160
	maptext_height = 48
