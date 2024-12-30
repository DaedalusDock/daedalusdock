// see _DEFINES/is_helpers.dm for mob type checks

///Find the mob at the bottom of a buckle chain
/mob/proc/lowest_buckled_mob()
	. = src
	if(buckled && ismob(buckled))
		var/mob/Buckled = buckled
		. = Buckled.lowest_buckled_mob()

///Takes a zone and returns it's "parent" zone, if it has one.
/proc/deprecise_zone(precise_zone)
	switch(precise_zone)
		if(null)
			return BODY_ZONE_CHEST
		if(BODY_ZONE_PRECISE_GROIN)
			return BODY_ZONE_CHEST
		if(BODY_ZONE_PRECISE_EYES)
			return BODY_ZONE_HEAD
		if(BODY_ZONE_PRECISE_MOUTH)
			return BODY_ZONE_HEAD
		if(BODY_ZONE_PRECISE_R_HAND)
			return BODY_ZONE_R_ARM
		if(BODY_ZONE_PRECISE_L_HAND)
			return BODY_ZONE_L_ARM
		if(BODY_ZONE_PRECISE_L_FOOT)
			return BODY_ZONE_L_LEG
		if(BODY_ZONE_PRECISE_R_FOOT)
			return BODY_ZONE_R_LEG
		else
			return precise_zone


GLOBAL_LIST_INIT(bodyzone_accuracy_weights, list(
	BODY_ZONE_HEAD = 20,
	BODY_ZONE_CHEST = 70,
	BODY_ZONE_R_ARM = 25,
	BODY_ZONE_L_ARM = 25,
	BODY_ZONE_R_LEG = 25,
	BODY_ZONE_L_LEG = 25
))

GLOBAL_LIST_INIT(bodyzone_miss_chance, list(
	BODY_ZONE_HEAD = 70,
	BODY_ZONE_CHEST = 5,
	BODY_ZONE_R_ARM = 15,
	BODY_ZONE_L_ARM = 15,
	BODY_ZONE_R_LEG = 15,
	BODY_ZONE_L_LEG = 15
))

GLOBAL_LIST_INIT(bodyzone_gurps_mods, list(
	BODY_ZONE_HEAD = -3,
	BODY_ZONE_CHEST = 0,
	BODY_ZONE_R_ARM = -1,
	BODY_ZONE_L_ARM = -1,
	BODY_ZONE_R_LEG = -1,
	BODY_ZONE_L_LEG = -1
))

/**
 * Return the zone or randomly, another valid zone
 *
 * Do not use this if someone is intentionally trying to hit a specific body part.
 * Use get_zone_with_miss_chance() for that.
 */
/proc/ran_zone(zone, probability = 80, list/weighted_list)
	if(zone)
		zone = deprecise_zone(zone)
		if(prob(probability))
			return zone

	if(weighted_list)
		zone = pick_weight(weighted_list)
	else
		zone = pick_weight(GLOB.bodyzone_accuracy_weights)
	return zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, mob/living/carbon/target, miss_chance_mod = 0, ranged_attack, can_truly_miss = TRUE)
	zone = deprecise_zone(zone)

	if(!ranged_attack)
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.body_position == LYING_DOWN)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/hand_item/grab/G in target.grabbed_by)
			if(G.current_grab.stop_move)
				return zone


	var/miss_chance = GLOB.bodyzone_miss_chance[zone]
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	if(prob(miss_chance))
		if(!can_truly_miss || ranged_attack || !prob(miss_chance)) // Ranged attacks cannot ever fully miss.
			return target.get_random_valid_zone()
		return null
	else
		return zone

/**
 * More or less ran_zone, but only returns bodyzones that the mob /actually/ has.
 *
 * * blacklisted_parts - allows you to specify zones that will not be chosen. eg: list(BODY_ZONE_CHEST, BODY_ZONE_R_LEG)
 * * * !!!! blacklisting BODY_ZONE_CHEST is really risky since it's the only bodypart guarunteed to ALWAYS exists  !!!!
 * * * !!!! Only do that if you're REALLY CERTAIN they have limbs, otherwise we'll CRASH() !!!!
 *
 * * ran_zone has a base prob(80) to return the base_zone (or if null, BODY_ZONE_CHEST) vs something in our generated list of limbs.
 * * this probability is overriden when either blacklisted_parts contains BODY_ZONE_CHEST and we aren't passed a base_zone (since the default fallback for ran_zone would be the chest in that scenario), or if even_weights is enabled.
 * * you can also manually adjust this probability by altering base_probability
 *
 * * even_weights - ran_zone has a 40% chance (after the prob(80) mentioned above) of picking a limb, vs the torso & head which have an additional 10% chance.
 * * Setting even_weight to TRUE will make it just a straight up pick() between all possible bodyparts.
 *
 */
/mob/proc/get_random_valid_zone(base_zone, base_probability = 80, list/blacklisted_parts, even_weights, bypass_warning)
	return BODY_ZONE_CHEST //even though they don't really have a chest, let's just pass the default of check_zone to be safe.

/mob/living/carbon/get_random_valid_zone(base_zone, base_probability = 80, list/blacklisted_parts, even_weights, bypass_warning)
	var/list/limbs = list()
	for(var/obj/item/bodypart/part as anything in bodyparts)
		var/limb_zone = part.body_zone //cache the zone since we're gonna check it a ton.
		if((limb_zone in blacklisted_parts) || part.is_stump)
			continue
		if(even_weights)
			limbs[limb_zone] = 1
			continue
		limbs[limb_zone] = GLOB.bodyzone_accuracy_weights[limb_zone]

	if(base_zone && !(deprecise_zone(base_zone) in limbs))
		base_zone = null //check if the passed zone is infact valid

	var/chest_blacklisted
	if((BODY_ZONE_CHEST in blacklisted_parts))
		chest_blacklisted = TRUE
		if(bypass_warning && !limbs.len)
			CRASH("limbs is empty and the chest is blacklisted. this may not be intended!")
	return (((chest_blacklisted && !base_zone) || even_weights) ? pick_weight(limbs) : ran_zone(base_zone, base_probability, limbs))

///Would this zone be above the neck
/proc/above_neck(zone)
	var/list/zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES)
	if(zones.Find(zone))
		return TRUE
	else
		return FALSE

/**
 * Convert random parts of a passed in message to stars
 *
 * * phrase - the string to convert
 * * probability - probability any character gets changed
 *
 * This proc is dangerously laggy, avoid it or die
 */
/proc/stars(phrase, probability = 25)
	if(length(phrase) == 0)
		return

	var/list/chars = splittext_char(html_decode(phrase), "")
	for(var/i in 1 to length(chars))
		if(!prob(probability) || chars[i] == " ")
			continue
		chars[i] = "*"
	return sanitize(jointext(chars, ""))

/**
 * Turn text into complete gibberish!
 *
 * text is the inputted message, replace_characters will cause original letters to be replaced and chance are the odds that a character gets modified.
 */
/proc/Gibberish(text, replace_characters = FALSE, chance = 50)
	text = html_decode(text)
	. = ""
	var/rawchar = ""
	var/letter = ""
	var/lentext = length(text)
	for(var/i = 1, i <= lentext, i += length(rawchar))
		rawchar = letter = text[i]
		if(prob(chance))
			if(replace_characters)
				letter = ""
			for(var/j in 1 to rand(0, 2))
				letter += pick("#", "@", "*", "&", "%", "$", "/", "<", ">", ";", "*", "*", "*", "*", "*", "*", "*")
		. += letter
	return sanitize(.)

#define TILES_PER_SECOND 0.7
///Shake the camera of the person viewing the mob SO REAL!
///Takes the mob to shake, the time span to shake for, and the amount of tiles we're allowed to shake by in tiles
///Duration isn't taken as a strict limit, since we don't trust our coders to not make things feel shitty. So it's more like a soft cap.
/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || duration < 1)
		return
	var/client/C = M.client
	var/oldx = C.pixel_x
	var/oldy = C.pixel_y
	var/max = strength*world.icon_size
	var/min = -(strength*world.icon_size)

	//How much time to allot for each pixel moved
	var/time_scalar = (1 / world.icon_size) * TILES_PER_SECOND
	var/last_x = oldx
	var/last_y = oldy

	var/time_spent = 0
	while(time_spent < duration)
		//Get a random pos in our box
		var/x_pos = rand(min, max) + oldx
		var/y_pos = rand(min, max) + oldy

		//We take the smaller of our two distances so things still have the propencity to feel somewhat jerky
		var/time = round(max(min(abs(last_x - x_pos), abs(last_y - y_pos)) * time_scalar, 1))

		if (time_spent == 0)
			animate(C, pixel_x=x_pos, pixel_y=y_pos, time=time)
		else
			animate(pixel_x=x_pos, pixel_y=y_pos, time=time)

		last_x = x_pos
		last_y = y_pos
		//We go based on time spent, so there is a chance we'll overshoot our duration. Don't care
		time_spent += time

	animate(pixel_x=oldx, pixel_y=oldy, time=3)

#undef TILES_PER_SECOND

///Find if the message has the real name of any user mob in the mob_list
/proc/findname(msg)
	if(!istext(msg))
		msg = "[msg]"
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		if(M.real_name == msg)
			return M
	return 0

///Find the first name of a mob from the real name with regex
/mob/proc/first_name()
	var/static/regex/firstname = new("^\[^\\s-\]+") //First word before whitespace or "-"
	firstname.Find(real_name)
	return firstname.match

/// Find the last name of a mob from the real name with regex
/mob/proc/last_name()
	var/static/regex/lasttname = new("\[^\\s-\]+$") //First word before whitespace or "-"
	lasttname.Find(real_name)
	return lasttname.match

///Returns a mob's real name between brackets. Useful when you want to display a mob's name alongside their real name
/mob/proc/get_realname_string()
	if(real_name && real_name != name)
		return " \[[real_name]\]"
	return ""

///Checks if the mob is able to see or not. eye_blind is temporary blindness, the trait is if they're permanently blind.
/mob/proc/is_blind()
	SHOULD_BE_PURE(TRUE)
	return eye_blind ? TRUE : HAS_TRAIT(src, TRAIT_BLIND)

///Is the mob hallucinating?
/mob/proc/hallucinating()
	return FALSE


// moved out of admins.dm because things other than admin procs were calling this.
/// Returns TRUE if the game has started and we're either an AI with a 0th law, or we're someone with a special role/antag datum
/proc/is_special_character(mob/M)
	if(!SSticker.HasRoundStarted())
		return FALSE
	if(!istype(M))
		return FALSE
	if(iscyborg(M)) //as a borg you're now beholden to your laws rather than greentext
		return FALSE
	if(isAI(M))
		var/mob/living/silicon/ai/A = M
		return (A.laws?.zeroth && (A.mind?.special_role || !isnull(M.mind?.antag_datums)))
	if(M.mind?.special_role || !isnull(M.mind?.antag_datums)) //they have an antag datum!
		return TRUE
	return FALSE

/**
 * Fancy notifications for ghosts
 *
 * The kitchen sink of notification procs
 *
 * Arguments:
 * * message
 * * ghost_sound sound to play
 * * enter_link Href link to enter the ghost role being notified for
 * * source The source of the notification
 * * alert_overlay The alert overlay to show in the alert message
 * * action What action to take upon the ghost interacting with the notification, defaults to NOTIFY_JUMP
 * * flashwindow Flash the byond client window
 * * ignore_key  Ignore keys if they're in the GLOB.poll_ignore list
 * * header The header of the notifiaction
 * * notify_suiciders If it should notify suiciders (who do not qualify for many ghost roles)
 * * notify_volume How loud the sound should be to spook the user
 */
/proc/notify_ghosts(message, ghost_sound = null, enter_link = null, atom/source = null, mutable_appearance/alert_overlay = null, action = NOTIFY_JUMP, flashwindow = TRUE, ignore_mapload = TRUE, ignore_key, header = null, notify_suiciders = TRUE, notify_volume = 100) //Easy notification of ghosts.
	if(ignore_mapload && SSatoms.initialized != INITIALIZATION_INNEW_REGULAR) //don't notify for objects created during a map load
		return
	for(var/mob/dead/observer/O in GLOB.player_list)
		if(!notify_suiciders && (O in GLOB.suicided_mob_list))
			continue
		if (ignore_key && (O.ckey in GLOB.poll_ignore[ignore_key]))
			continue
		var/orbit_link
		if (source && action == NOTIFY_ORBIT)
			orbit_link = " <a href='?src=[REF(O)];follow=[REF(source)]'>(Orbit)</a>"
		to_chat(O, span_ghostalert("[message][(enter_link) ? " [enter_link]" : ""][orbit_link]"))
		if(ghost_sound)
			SEND_SOUND(O, sound(ghost_sound, volume = notify_volume))
		if(flashwindow)
			window_flash(O.client)
		if(source)
			var/atom/movable/screen/alert/notify_action/A = O.throw_alert("[REF(source)]_notify_action", /atom/movable/screen/alert/notify_action)
			if(A)
				var/ui_style = O.client?.prefs?.read_preference(/datum/preference/choiced/ui_style)
				if(ui_style)
					A.icon = ui_style2icon(ui_style)
				if (header)
					A.name = header
				A.desc = message
				A.action = action
				A.target_ref = WEAKREF(source)
				if(!alert_overlay)
					alert_overlay = new(source)
					var/icon/size_check = icon(source.icon, source.icon_state)
					var/scale = 1
					var/width = size_check.Width()
					var/height = size_check.Height()
					if(width > world.icon_size || height > world.icon_size)
						if(width >= height)
							scale = world.icon_size / width
						else
							scale = world.icon_size / height
					alert_overlay.transform = alert_overlay.transform.Scale(scale)
					alert_overlay.appearance_flags |= TILE_BOUND
				alert_overlay.layer = FLOAT_LAYER
				alert_overlay.plane = FLOAT_PLANE
				A.add_overlay(alert_overlay)

/**
 * Heal a robotic body part on a mob
 */
/proc/item_heal_robotic(mob/living/carbon/human/H, mob/user, brute_heal, burn_heal)
	var/obj/item/bodypart/affecting = H.get_bodypart(deprecise_zone(user.zone_selected))
	if(affecting && !IS_ORGANIC_LIMB(affecting))
		var/dam //changes repair text based on how much brute/burn was supplied
		if(brute_heal > burn_heal)
			dam = 1
		else
			dam = 0
		if((brute_heal > 0 && affecting.brute_dam > 0) || (burn_heal > 0 && affecting.burn_dam > 0))
			if(affecting.heal_damage(brute_heal, burn_heal, BODYTYPE_ROBOTIC))
				H.update_damage_overlays()
			user.visible_message(span_notice("[user] fixes some of the [dam ? "dents on" : "burnt wires in"] [H]'s [affecting.name]."), \
			span_notice("You fix some of the [dam ? "dents on" : "burnt wires in"] [H == user ? "your" : "[H]'s"] [affecting.name]."))
			return 1 //successful heal
		else
			to_chat(user, span_warning("[affecting] is already in good condition!"))

///Is the passed in mob a ghost with admin powers, doesn't check for AI interact like isAdminGhost() used to
/proc/isAdminObserver(mob/user)
	if(!user) //Are they a mob? Auto interface updates call this with a null src
		return
	if(!user.client) // Do they have a client?
		return
	if(!isobserver(user)) // Are they a ghost?
		return
	if(!check_rights_for(user.client, R_ADMIN)) // Are they allowed?
		return
	return TRUE

///Is the passed in mob an admin ghost WITH AI INTERACT enabled
/proc/isAdminGhostAI(mob/user)
	if(!isAdminObserver(user))
		return
	if(!user.client.AI_Interact) // Do they have it enabled?
		return
	return TRUE

/**
 * Offer control of the passed in mob to dead player
 *
 * Automatic logging and uses poll_candidates_for_mob, how convenient
 */
/proc/offer_control(mob/M)
	to_chat(M, "Control of your mob has been offered to dead players.")
	if(usr)
		log_admin("[key_name(usr)] has offered control of ([key_name(M)]) to ghosts.")
		message_admins("[key_name_admin(usr)] has offered control of ([ADMIN_LOOKUPFLW(M)]) to ghosts")
	var/poll_message = "Do you want to play as [M.real_name]?"
	if(M.mind)
		poll_message = "[poll_message] Job: [M.mind.assigned_role.title]."
		if(M.mind.special_role)
			poll_message = "[poll_message] Status: [M.mind.special_role]."
		else
			var/datum/antagonist/A = M.mind.has_antag_datum(/datum/antagonist/)
			if(A)
				poll_message = "[poll_message] Status: [A.name]."
	var/list/mob/dead/observer/candidates = poll_candidates_for_mob(poll_message, ROLE_PAI, FALSE, 10 SECONDS, M)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		to_chat(M, "Your mob has been taken over by a ghost!")
		message_admins("[key_name_admin(C)] has taken control of ([ADMIN_LOOKUPFLW(M)])")
		M.ghostize(0)
		M.key = C.key
		M.client?.init_verbs()
		return TRUE
	else
		to_chat(M, "There were no ghosts willing to take control.")
		message_admins("No ghosts were willing to take control of [ADMIN_LOOKUPFLW(M)])")
		return FALSE

///Clicks a random nearby mob with the source from this mob
/mob/proc/click_random_mob()
	var/list/nearby_mobs = list()
	for(var/mob/living/L in range(1, src))
		if(L!=src)
			nearby_mobs |= L
	if(nearby_mobs.len)
		var/mob/living/T = pick(nearby_mobs)
		ClickOn(T)

/// Logs a message in a mob's individual log, and in the global logs as well if log_globally is true
/mob/log_message(message, message_type, color=null, log_globally = TRUE)
	if(!LAZYLEN(message))
		stack_trace("Empty message")
		return

	// Cannot use the list as a map if the key is a number, so we stringify it (thank you BYOND)
	var/smessage_type = num2text(message_type, MAX_BITFLAG_DIGITS)

	if(client)
		if(!islist(client.player_details.logging[smessage_type]))
			client.player_details.logging[smessage_type] = list()

	if(!islist(logging[smessage_type]))
		logging[smessage_type] = list()

	var/colored_message = message
	if(color)
		if(color[1] == "#")
			colored_message = "<font color=[color]>[message]</font>"
		else
			colored_message = "<font color='[color]'>[message]</font>"

	//This makes readability a bit better for admins.
	switch(message_type)
		if(LOG_WHISPER)
			colored_message = "(WHISPER) [colored_message]"
		if(LOG_OOC)
			colored_message = "(OOC) [colored_message]"
		if(LOG_ASAY)
			colored_message = "(ASAY) [colored_message]"
		if(LOG_EMOTE)
			colored_message = "(EMOTE) [colored_message]"
		if(LOG_RADIO_EMOTE)
			colored_message = "(RADIOEMOTE) [colored_message]"
		if(LOG_HEALTH)
			colored_message = "(HEALTH) [colored_message]"

	var/list/timestamped_message = list("\[[time_stamp(format = "YYYY-MM-DD hh:mm:ss")]\] [key_name(src)] [loc_name(src)] (Event #[LAZYLEN(logging[smessage_type])])" = colored_message)

	logging[smessage_type] += timestamped_message

	if(client)
		client.player_details.logging[smessage_type] += timestamped_message

	..()

///Can the mob hear
/mob/proc/can_hear(ignore_stat)
	. = TRUE

/**
 * Examine text for traits shared by multiple types.
 *
 * I wish examine was less copypasted. (oranges say, be the change you want to see buddy)
 */
/mob/proc/common_trait_examine()
	if(HAS_TRAIT(src,TRAIT_HUSK))
		. += span_warning("This body has been reduced to a grotesque husk.")

/**
 * Get the list of keywords for policy config
 *
 * This gets the type, mind assigned roles and antag datums as a list, these are later used
 * to send the user relevant headadmin policy config
 */
/mob/proc/get_policy_keywords()
	. = list()
	. += "[type]"
	if(mind)
		if(mind.assigned_role.policy_index)
			. += mind.assigned_role.policy_index
		. += mind.special_role //In case there's something special leftover, try to avoid
		for(var/datum/antagonist/antag_datum as anything in mind.antag_datums)
			. += "[antag_datum.type]"

///Can the mob see reagents inside of containers?
/mob/proc/can_see_reagents()
	return stat == DEAD || has_unlimited_silicon_privilege || HAS_TRAIT(src, TRAIT_REAGENT_SCANNER) //Dead guys and silicons can always see reagents

///Can this mob hold items
/mob/proc/can_hold_items(obj/item/I)
	return length(held_items)

/// Returns this mob's default lighting alpha
/mob/proc/default_lighting_alpha()
	if(client?.combo_hud_enabled && client?.prefs?.toggles & COMBOHUD_LIGHTING)
		return LIGHTING_PLANE_ALPHA_INVISIBLE
	return initial(lighting_alpha)

/// Can this mob SMELL THE SMELLY SMELLS?
/mob/proc/can_smell()
	return FALSE

//returns the number of size categories between two mob_sizes, rounded. Positive means A is larger than B
/proc/mob_size_difference(mob_size_A, mob_size_B)
	return round(log(2, mob_size_A/mob_size_B), 1)
