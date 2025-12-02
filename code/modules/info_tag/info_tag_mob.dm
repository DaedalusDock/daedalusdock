/mob
	var/list/obj/effect/abstract/info_tag/seeing_info_tags

/// Returns all the info tags this mob should try to render.
/mob/proc/get_info_tags()
	return null

/mob/living/simple_animal/flock/get_info_tags()
	return INSTANCES_OF(TRACKING_KEY_FLOCK_INFO_HUDS)

/mob/camera/flock/get_info_tags()
	return INSTANCES_OF(TRACKING_KEY_FLOCK_INFO_HUDS)

/mob/proc/update_info_tags()
	var/list/info_tags = get_info_tags()

	if(!length(info_tags))
		return

	for(var/obj/effect/abstract/info_tag/tag as anything in seeing_info_tags)
		if(!tag.mob_should_see(src))
			tag.hide_from(client)
			LAZYREMOVE(tag.viewing_mobs, src)
			LAZYREMOVE(seeing_info_tags, tag)

	for(var/obj/effect/abstract/info_tag/tag as anything in info_tags - seeing_info_tags)
		if(tag.mob_should_see(src))
			LAZYADD(seeing_info_tags, tag)
			LAZYADD(tag.viewing_mobs, src)

	if(client)
		var/showing = client.keys_held["Shift"]
		for(var/obj/effect/abstract/info_tag/tag as anything in seeing_info_tags)
			if(showing)
				tag.show_to(client)
			else
				tag.hide_from(client)
