
#define MOOD_CATEGORY_NUTRITION "nutrition"
#define MOOD_CATEGORY_AREA_BEAUTY "area_beauty"

/**
 * Mood datum
 *
 * Contains the logic for controlling a living mob's mood/
 */
/datum/mood
	/// The parent (living) mob
	var/mob/living/mob_parent

	/// The total combined value of all moodlets for the mob
	var/mood
	/// the total combined value of all visible moodlets for the mob
	var/shown_mood
	/// Moodlet value modifier
	var/mood_modifier = 1
	/// Used to track what stage of moodies they're on (-20 to 20)
	var/mood_level = MOOD_LEVEL_NEUTRAL
	/// The screen object for the current mood level
	var/atom/movable/screen/mood/mood_screen_object

	/// List of mood events currently active on this datum
	var/list/mood_events = list()

/datum/mood/New(mob/living/mob_to_make_moody)
	if (!istype(mob_to_make_moody))
		stack_trace("Tried to apply mood to a non-living atom!")
		qdel(src)
		return

	mob_parent = mob_to_make_moody

	RegisterSignal(mob_to_make_moody, COMSIG_MOB_HUD_CREATED, PROC_REF(modify_hud))
	RegisterSignal(mob_to_make_moody, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
	RegisterSignal(mob_to_make_moody, COMSIG_PARENT_QDELETING, PROC_REF(clear_parent_ref))

	if(mob_to_make_moody.hud_used)
		modify_hud()
		var/datum/hud/hud = mob_to_make_moody.hud_used
		hud.show_hud(hud.hud_version)

/datum/mood/proc/clear_parent_ref()
	SIGNAL_HANDLER

	unmodify_hud()
	UnregisterSignal(mob_parent, list(COMSIG_MOB_HUD_CREATED, COMSIG_ENTER_AREA, COMSIG_EXIT_AREA, COMSIG_LIVING_REVIVE, COMSIG_MOB_STATCHANGE, COMSIG_PARENT_QDELETING))

/datum/mood/Destroy(force)
	QDEL_LIST_ASSOC_VAL(mood_events)
	mob_parent = null
	return ..()

/// Handles mood given by nutrition
/datum/mood/proc/update_nutrition_moodlets()
	if(HAS_TRAIT(mob_parent, TRAIT_NOHUNGER))
		clear_mood_event(MOOD_CATEGORY_NUTRITION)
		return FALSE

	if(HAS_TRAIT(mob_parent, TRAIT_FAT))
		add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/fat)
		return TRUE

	switch(mob_parent.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/too_wellfed)
		if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/wellfed)
		if( NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/fed)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			clear_mood_event(MOOD_CATEGORY_NUTRITION)
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/hungry)
		if(0 to NUTRITION_LEVEL_STARVING)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/starving)

	return TRUE

/**
 * Adds a mood event to the mob
 *
 * Arguments:
 * * category - (text) category of the mood event - see /datum/mood_event for category explanation
 * * type - (path) any /datum/mood_event
 */
/datum/mood/proc/add_mood_event(category, type, ...)
	// we may be passed an instantiated mood datum with a modified timeout
	// it is to be used as a vehicle to copy data from and then cleaned up afterwards.
	// why do it this way? because the params list may contain numbers, and we may not necessarily want those to be interpreted as a timeout modifier.
	// this is only used by the food quality system currently
	var/datum/mood_event/mood_to_copy_from
	if (istype(type, /datum/mood_event))
		mood_to_copy_from = type
		type = mood_to_copy_from.type
	if (!ispath(type, /datum/mood_event))
		CRASH("A non path ([type]), was used to add a mood event. This shouldn't be happening.")
	if (!istext(category))
		category = REF(category)

	var/datum/mood_event/the_event
	if (mood_events[category])
		the_event = mood_events[category]
		if (the_event.type != type)
			clear_mood_event(category)
		else
			if (the_event.timeout)
				if (!isnull(mood_to_copy_from))
					the_event.timeout = mood_to_copy_from.timeout
				addtimer(CALLBACK(src, PROC_REF(clear_mood_event), category), the_event.timeout, (TIMER_UNIQUE|TIMER_OVERRIDE))
			qdel(mood_to_copy_from)
			return // Don't need to update the event.
	var/list/params = args.Copy(3)

	params.Insert(1, mob_parent)
	the_event = new type(arglist(params))
	if (QDELETED(the_event)) // the mood event has been deleted for whatever reason (requires a job, etc)
		return

	the_event.category = category
	if (!isnull(mood_to_copy_from))
		the_event.timeout = mood_to_copy_from.timeout
	qdel(mood_to_copy_from)
	mood_events[category] = the_event
	update_mood()

	if (the_event.timeout)
		addtimer(CALLBACK(src, PROC_REF(clear_mood_event), category), the_event.timeout, (TIMER_UNIQUE|TIMER_OVERRIDE))

/**
 * Removes a mood event from the mob
 *
 * Arguments:
 * * category - (Text) Removes the mood event with the given category
 */
/datum/mood/proc/clear_mood_event(category)
	if (!istext(category))
		category = REF(category)

	var/datum/mood_event/event = mood_events[category]
	if (!event)
		return

	mood_events -= category
	qdel(event)
	update_mood()

/// Updates the mobs mood.
/// Called after mood events have been added/removed.
/datum/mood/proc/update_mood()
	if(QDELETED(mob_parent)) //don't bother updating their mood if they're about to be salty anyway. (in other words, we're about to be destroyed too anyway.)
		return

	if(mob_parent.stat != CONSCIOUS)
		return

	mood = 0
	shown_mood = 0


	for(var/category in mood_events)
		var/datum/mood_event/the_event = mood_events[category]
		mood += the_event.mood_change
		if (!the_event.hidden)
			shown_mood += the_event.mood_change

	mood *= mood_modifier
	shown_mood *= mood_modifier

	var/old_mood_level = mood_level

	switch(mood)
		if (-INFINITY to MOOD_LEVEL_SAD4)
			mood_level = MOOD_LEVEL_SAD4

		if (MOOD_LEVEL_SAD4+1 to MOOD_LEVEL_SAD3)
			mood_level = MOOD_LEVEL_SAD3

		if (MOOD_LEVEL_SAD3+1 to MOOD_LEVEL_SAD2)
			mood_level = MOOD_LEVEL_SAD2

		if (MOOD_LEVEL_SAD2+1 to MOOD_LEVEL_SAD1)
			mood_level = MOOD_LEVEL_SAD1

		if (MOOD_LEVEL_SAD1+1 to MOOD_LEVEL_HAPPY1-1)
			mood_level = MOOD_LEVEL_NEUTRAL

		if (MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2-1)
			mood_level = MOOD_LEVEL_HAPPY1

		if (MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3-1)
			mood_level = MOOD_LEVEL_HAPPY2

		if (MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4-1)
			mood_level = MOOD_LEVEL_HAPPY3

		if (MOOD_LEVEL_HAPPY4 to INFINITY)
			mood_level = MOOD_LEVEL_HAPPY4

	if(mood_level > old_mood_level)
		to_chat(mob_parent, span_notice("I have become less stressed."))
	else
		to_chat(mob_parent, span_warning("I have become more stressed."))

	update_mood_icon()

/// Updates the mob's mood icon
/datum/mood/proc/update_mood_icon()
	if (!(mob_parent.client || mob_parent.hud_used))
		return

	mood_screen_object.cut_overlays()

	if(mob_parent.stat != CONSCIOUS)
		mood_screen_object.color = "#4b96c4"
		mood_screen_object.icon_state = "mood0"
		return

	switch(mood_level)
		if (MOOD_LEVEL_HAPPY4)
			mood_screen_object.color = "#2eeb9a"
		if (MOOD_LEVEL_HAPPY1, MOOD_LEVEL_HAPPY2, MOOD_LEVEL_HAPPY3)
			mood_screen_object.color = "#86d656"
		if (MOOD_LEVEL_NEUTRAL)
			mood_screen_object.color = "#4b96c4"
		if (MOOD_LEVEL_SAD1)
			mood_screen_object.color = "#dfa65b"
		if (MOOD_LEVEL_SAD2, MOOD_LEVEL_SAD3)
			mood_screen_object.color = "#f38943"
		if (MOOD_LEVEL_SAD4)
			mood_screen_object.color = "#f15d36"

	// lets see if we have an special icons to show instead of the normal mood levels
	var/list/conflicting_moodies = list()
	var/highest_absolute_mood = 0
	for (var/category in mood_events)
		var/datum/mood_event/the_event = mood_events[category]
		if (!the_event.special_screen_obj)
			continue
		if (!the_event.special_screen_replace)
			mood_screen_object.add_overlay(the_event.special_screen_obj)
		else
			conflicting_moodies += the_event
			var/absmood = abs(the_event.mood_change)
			highest_absolute_mood = absmood > highest_absolute_mood ? absmood : highest_absolute_mood

	if (!conflicting_moodies.len) // there's no special icons, use the normal icon states
		mood_screen_object.icon_state = "mood[mood_level]"
		return

	for (var/datum/mood_event/conflicting_event as anything in conflicting_moodies)
		if (abs(conflicting_event.mood_change) == highest_absolute_mood)
			mood_screen_object.icon_state = "[conflicting_event.special_screen_obj]"
			break

/// Sets up the mood HUD object
/datum/mood/proc/modify_hud(datum/source)
	SIGNAL_HANDLER

	var/datum/hud/hud = mob_parent.hud_used
	mood_screen_object = new(null, hud)
	hud.infodisplay += mood_screen_object
	RegisterSignal(hud, COMSIG_PARENT_QDELETING, PROC_REF(unmodify_hud))
	RegisterSignal(mood_screen_object, COMSIG_CLICK, PROC_REF(hud_click))

/// Removes the mood HUD object
/datum/mood/proc/unmodify_hud(datum/source)
	SIGNAL_HANDLER

	if(!mood_screen_object)
		return
	var/datum/hud/hud = mob_parent.hud_used
	if(hud?.infodisplay)
		hud.infodisplay -= mood_screen_object
	QDEL_NULL(mood_screen_object)

/// Handles clicking on the mood HUD object
/datum/mood/proc/hud_click(datum/source, location, control, params, mob/user)
	SIGNAL_HANDLER

	if(user != mob_parent)
		return
	print_mood(user)

/// Prints the users mood, sanity, and moodies to chat
/datum/mood/proc/print_mood(mob/user)
	var/list/msg = list("[span_info("<EM>Current feelings:</EM>")]")

	if(mob_parent.stat != CONSCIOUS)
		msg += span_grey("I am asleep.")
		to_chat(user, examine_block(jointext(msg, "<br>")))
		return

	switch(mood_level)
		if(MOOD_LEVEL_SAD4)
			msg += span_alert("<b>I wish I was dead.</b>")
		if(MOOD_LEVEL_SAD2, MOOD_LEVEL_SAD3)
			msg += span_alert("I am stressed out.")
		if(MOOD_LEVEL_NEUTRAL)
			msg += span_grey("I feel indifferent.")
		if(MOOD_LEVEL_HAPPY2, MOOD_LEVEL_HAPPY3)
			msg += span_nicegreen("Everything is going to be okay.")
		if(MOOD_LEVEL_HAPPY4)
			msg += span_boldnicegreen("I love life!")

	if(mood_events.len)
		for(var/category in mood_events)
			var/datum/mood_event/event = mood_events[category]
			switch(event.mood_change)
				if(-INFINITY to MOOD_LEVEL_SAD2)
					msg += span_alert("<b>[event.description]</b>")
				if(MOOD_LEVEL_SAD2+1 to MOOD_LEVEL_SAD1)
					msg += span_alert(event.description)
				if(MOOD_LEVEL_SAD1+1 to MOOD_LEVEL_HAPPY1-1)
					msg += span_grey(event.description)
				if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2-1)
					msg += span_info(event.description)
				if(MOOD_LEVEL_HAPPY2 to INFINITY)
					msg += span_boldnicegreen(event.description)

	to_chat(user, examine_block(jointext(msg, "\n")))

/// Called when parent is ahealed.
/datum/mood/proc/on_revive(datum/source, full_heal)
	SIGNAL_HANDLER

	if (!full_heal)
		return

	remove_temp_moods()

/// Removes all temporary moods
/datum/mood/proc/remove_temp_moods()
	for (var/category in mood_events)
		var/datum/mood_event/moodlet = mood_events[category]
		if (!moodlet || !moodlet.timeout)
			continue
		mood_events -= moodlet.category
		qdel(moodlet)
	update_mood()

/**
 * Returns true if you already have a mood from a provided category.
 * You may think to yourself, why am I trying to get a boolean from a component? Well, this system probably should not be a component.
 *
 * Arguments
 * * category - Mood category to validate against.
 */
/datum/mood/proc/has_mood_of_category(category)
	for(var/i in mood_events)
		var/datum/mood_event/moodlet = mood_events[i]
		if (moodlet.category == category)
			return TRUE
	return FALSE

#undef MOOD_CATEGORY_NUTRITION
#undef MOOD_CATEGORY_AREA_BEAUTY
