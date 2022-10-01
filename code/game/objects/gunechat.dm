/obj/gunechat_container
	plane = RUNECHAT_PLANE
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/list/image/gunechat_line/lines = list()

/obj/gunechat_container/Destroy(force)
	for(var/image/gunechat_line/line in lines)
		line.Destroy() //We don't want to qdel it because we don't want images filling the garbage queue

	lines = null
	return ..()

/image/gunechat_line
	icon = null
	icon_state = null
	plane = RUNECHAT_PLANE
	appearance_flags = PIXEL_SCALE
	alpha = 0
	maptext_x = -64
	maptext_y = 30
	maptext_width = 160
	maptext_height = 50
	///Which container object owns this line
	var/obj/gunechat_container/parent
	///All clients that can see or will see this image
	var/list/client/show_to = list()
	var/id
	///The height of the text, used for bumping messages. Measured by measuretextsuckslmao()
	var/vertical_pixels = 8

/image/gunechat_line/Destroy()
	SHOULD_CALL_PARENT(FALSE) //Don't flood SSgarbage with our image garbage. Wait...

	parent?.lines -= src

	for(var/client/viewer in show_to)
		viewer.images -= src

	loc = null //Should be all the refs cleared, so byond can GC it cleanly.

/image/gunechat_line/proc/add_viewer(client/C)
	if(isnull(C))
		return

	show_to += C
	C << src

/image/gunechat_line/proc/measuretextsuckslmao()
	return (1 + (round(length(maptext_width) / 32))) * 8

/image/gunechat_line/proc/bump(amt = 8)
	animate(src, maptext_y = (maptext_y + amt), time = 4)

/atom/proc/create_overhead_text(treated_msg as text, raw_msg as text, lifetime = 4 SECONDS, list/message_spans)
	var/image/gunechat_line/new_line = new

	treated_msg = copytext(msg, 1, 256)
	var/lines = CEILING(length(message)/256)
	var/raw_lines = CEILING(length(raw_msg)/256)
	new_line.maptext = MAPTEXT(treated_msg)

	//We have no "tom" type, so we have to deal with this for maximum speak. Cope.
	if(gunechat_holder)
		new_line.loc = gunechat_holder
		new_line.parent = gunechat_holder
		gunechat_holder.lines += new_line
	else
		new_line.loc = speaker

	animate(new_line, maptext_y = 34, time = 4, flags = ANIMATION_END_NOW)
	addtimer(CALLBACK(new_line, /datum/proc/Destroy), lifetime, , SSgunechat)
	return new_line


/atom/proc/create_overhead_text(atom/speaker, msg, lifetime)

/*proc/make_chat_maptext(atom/target, msg, style = "", alpha = 255, force = 0, time = 40)
	var/image/chat_maptext/text = new /image/chat_maptext
	animate(text, maptext_y = 28, time = 0.01) // this shouldn't be necessary but it keeps breaking without it
	if (!force)
		msg = copytext(msg, 1, 256) // 4 lines, seems fine to me
		text.maptext = "<span class='pixel c ol' style=\"[style]\">[msg]</span>"
	else
		// force whatever it is to be shown. for not chat tings. honk.
		text.maptext = msg
	if(istype(target, /atom/movable) && target.chat_text)
		var/atom/movable/L = target
		text.loc = L.chat_text
		if(length(L.chat_text.lines) && L.chat_text.lines[length(L.chat_text.lines)].maptext == text.maptext)
			L.chat_text.lines[length(L.chat_text.lines)].transform *= 1.05
			qdel(text)
			return null
		L.chat_text.lines.Add(text)
	else // hmm?
		text.loc = target
	animate(text, alpha = alpha, maptext_y = 34, time = 4, flags = ANIMATION_END_NOW)
	var/text_id = text.unique_id
	SPAWN(time)
		if(text_id == text.unique_id)
			text.bump_up(invis=1)
			sleep(0.5 SECONDS)
			qdel(text)
	return text
*/
