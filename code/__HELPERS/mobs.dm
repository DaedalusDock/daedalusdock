//check_target_facings() return defines
/// Two mobs are facing the same direction
#define FACING_SAME_DIR 1
/// Two mobs are facing each others
#define FACING_EACHOTHER 2
/// Two mobs one is facing a person, but the other is perpendicular
#define FACING_INIT_FACING_TARGET_TARGET_FACING_PERPENDICULAR 3 //Do I win the most informative but also most stupid define award?

/proc/random_blood_type()
	RETURN_TYPE(/datum/blood)
	var/datum/blood/path = pick(\
		4;/datum/blood/human/omin, \
		36;/datum/blood/human/opos, \
		3;/datum/blood/human/amin, \
		28;/datum/blood/human/apos, \
		1;/datum/blood/human/bmin, \
		20;/datum/blood/human/bpos, \
		1;/datum/blood/human/abmin, \
		5;/datum/blood/human/abpos\
	)
	return GET_BLOOD_REF(path)

/proc/get_blood_dna_color(list/blood_dna)
	var/datum/blood/blood_type = blood_dna?[blood_dna[length(blood_dna)]]
	return blood_type?.color

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "#663300"
		if("hazel")
			return "#554422"
		if("grey")
			return pick("#666666","#777777","#888888","#999999","#aaaaaa","#bbbbbb","#cccccc")
		if("blue")
			return "#3366cc"
		if("green")
			return "#006600"
		if("amber")
			return "#ffcc00"
		if("albino")
			return "#" + pick("cc","dd","ee","ff") + pick("00","11","22","33","44","55","66","77","88","99") + pick("00","11","22","33","44","55","66","77","88","99")
		else
			return "#000000"

/proc/random_underwear(gender)
	if(!GLOB.underwear_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.underwear_m)
		if(FEMALE)
			return pick(GLOB.underwear_f)
		else
			return pick(GLOB.underwear_list)

/proc/random_undershirt(gender)
	if(!GLOB.undershirt_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.undershirt_m)
		if(FEMALE)
			return pick(GLOB.undershirt_f)
		else
			return pick(GLOB.undershirt_list)

/proc/random_socks()
	if(!GLOB.socks_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	return pick(GLOB.socks_list)

/proc/random_features()
	//For now we will always return none for tail_human and ears. | "For now" he says.
	return(list(
		"ethcolor" = GLOB.color_list_ethereal[pick(GLOB.color_list_ethereal)],
		"tail_cat" = "None",
		"tail_lizard" = "Smooth",
		"wings" = "None",
		"snout" = pick(GLOB.snouts_list),
		"horns" = pick(GLOB.horns_list),
		"ears" = "None",
		"frills" = pick(GLOB.frills_list),
		"spines" = pick(GLOB.spines_list),
		"legs" = "Normal Legs",
		"caps" = pick(GLOB.caps_list),
		"moth_wings" = pick(GLOB.moth_wings_list),
		"moth_antennae" = pick(GLOB.moth_antennae_list),
		"moth_markings" = pick(GLOB.moth_markings_list),
		"tail_monkey" = "None",
		"pod_hair" = pick(GLOB.pod_hair_list),
		"vox_snout" = pick(GLOB.vox_snouts_list),
		"tail_vox" = pick(GLOB.tails_list_vox),
		"vox_hair" = pick(GLOB.vox_hair_list),
		"vox_facial_hair" = pick(GLOB.vox_facial_hair_list),
		"teshari_feathers" = pick(GLOB.teshari_feathers_list),
		"teshari_ears" = pick(GLOB.teshari_ears_list),
		"teshari_body_feathers" = pick(GLOB.teshari_body_feathers_list),
		"tail_teshari" = pick(GLOB.teshari_tails_list),
		"ipc_screen" = pick(GLOB.ipc_screens_list),
		"ipc_antenna" = pick(GLOB.ipc_antenna_list),
		"saurian_screen" = pick(GLOB.saurian_screens_list),
		"saurian_tail" = pick(GLOB.saurian_tails_list),
		"saurian_scutes" = pick(GLOB.saurian_scutes_list),
		"saurian_antenna" = pick(GLOB.saurian_antenna_list),
	))

/proc/random_mutant_colors()
	. = list()
	for(var/key in GLOB.all_mutant_colors_keys)
		.["[key]_1"] = "#[pick("7F","FF")][pick("7F","FF")][pick("7F","FF")]"
		.["[key]_2"] = "#[pick("7F","FF")][pick("7F","FF")][pick("7F","FF")]"
		.["[key]_3"] = "#[pick("7F","FF")][pick("7F","FF")][pick("7F","FF")]"

	return .

/proc/random_hairstyle(gender)
	switch(gender)
		if(MALE)
			return pick(GLOB.hairstyles_male_list)
		if(FEMALE)
			return pick(GLOB.hairstyles_female_list)
		else
			return pick(GLOB.hairstyles_list)

/proc/random_facial_hairstyle(gender)
	switch(gender)
		if(MALE)
			return pick(GLOB.facial_hairstyles_male_list)
		if(FEMALE)
			return pick(GLOB.facial_hairstyles_female_list)
		else
			return pick(GLOB.facial_hairstyles_list)

/proc/random_skin_tone()
	return pick(GLOB.skin_tones)

GLOBAL_LIST_INIT(skin_tones, sort_list(list(
	"albino",
	"caucasian1",
	"caucasian2",
	"caucasian3",
	"latino",
	"mediterranean",
	"asian1",
	"asian2",
	"arab",
	"indian",
	"african1",
	"african2"
	)))

GLOBAL_LIST_INIT(skin_tone_names, list(
	"african1" = "Medium brown",
	"african2" = "Dark brown",
	"albino" = "Albino",
	"arab" = "Light brown",
	"asian1" = "Ivory",
	"asian2" = "Beige",
	"caucasian1" = "Porcelain",
	"caucasian2" = "Light peach",
	"caucasian3" = "Peach",
	"indian" = "Brown",
	"latino" = "Light beige",
	"mediterranean" = "Olive",
))

/// An assoc list of species IDs to type paths
GLOBAL_LIST_EMPTY(species_list)

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)
			return "infant"
		if(1 to 3)
			return "toddler"
		if(3 to 13)
			return "child"
		if(13 to 19)
			return "teenager"
		if(19 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, species_datum))
			. = TRUE

/// Returns if the given target is a human. Like, a REAL human.
/// Not a moth, not a felinid (which are human subtypes), but a human.
/proc/ishumanbasic(target)
	if (!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/human_target = target
	return human_target.dna?.species?.type == /datum/species/human

/proc/spawn_atom_to_turf(spawn_type, target, amount, admin_spawn=FALSE, list/extra_args)
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/new_args = list(T)
	if(extra_args)
		new_args += extra_args
	var/atom/X
	for(var/j in 1 to amount)
		X = new spawn_type(arglist(new_args))
		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1
	return X //return the last mob spawned

/proc/spawn_and_random_walk(spawn_type, target, amount, walk_chance=100, max_walk=3, always_max_walk=FALSE, admin_spawn=FALSE)
	var/turf/T = get_turf(target)
	var/step_count = 0
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/spawned_mobs = new(amount)

	for(var/j in 1 to amount)
		var/atom/movable/X

		if (istype(spawn_type, /list))
			var/mob_type = pick(spawn_type)
			X = new mob_type(T)
		else
			X = new spawn_type(T)

		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1

		spawned_mobs[j] = X

		if(always_max_walk || prob(walk_chance))
			if(always_max_walk)
				step_count = max_walk
			else
				step_count = rand(1, max_walk)

			for(var/i in 1 to step_count)
				step(X, pick(NORTH, SOUTH, EAST, WEST))

	return spawned_mobs

// Displays a message in deadchat, sent by source. source is not linkified, message is, to avoid stuff like character names to be linkified.
// Automatically gives the class deadsay to the whole message (message + source)
/proc/deadchat_broadcast(message, source=null, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR, admin_only=FALSE)
	message = span_deadsay("[source]<span class='linkify'>[message]</span>")

	for(var/mob/M in GLOB.player_list)
		var/chat_toggles = TOGGLES_DEFAULT_CHAT
		var/toggles = TOGGLES_DEFAULT
		var/list/ignoring
		if(M.client?.prefs)
			var/datum/preferences/prefs = M.client?.prefs
			chat_toggles = prefs.chat_toggles
			toggles = prefs.toggles
			ignoring = prefs.ignoring
		if(admin_only)
			if (!M.client?.holder)
				return
			else
				message += span_deadsay(" (This is viewable to admins only).")
		var/override = FALSE
		if(M.client?.holder && (chat_toggles & CHAT_DEAD))
			override = TRUE
		if(HAS_TRAIT(M, TRAIT_SIXTHSENSE) && message_type == DEADCHAT_REGULAR)
			override = TRUE
		if(SSticker.current_state == GAME_STATE_FINISHED)
			override = TRUE
		if(isnewplayer(M) && !override)
			continue
		if(M.stat != DEAD && !override)
			continue
		if(speaker_key && (speaker_key in ignoring))
			continue

		switch(message_type)
			if(DEADCHAT_DEATHRATTLE)
				if(toggles & DISABLE_DEATHRATTLE)
					continue
			if(DEADCHAT_ARRIVALRATTLE)
				if(toggles & DISABLE_ARRIVALRATTLE)
					continue
			if(DEADCHAT_LAWCHANGE)
				if(!(chat_toggles & CHAT_GHOSTLAWS))
					continue
			if(DEADCHAT_LOGIN_LOGOUT)
				if(!(chat_toggles & CHAT_LOGIN_LOGOUT))
					continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
				var/F
				if(turf_target)
					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
				else
					F = FOLLOW_LINK(M, follow_target)
				rendered_message = "[F] [message]"
			else if(turf_target)
				var/turf_link = TURF_LINK(M, turf_target)
				rendered_message = "[turf_link] [message]"

			to_chat(M, rendered_message, avoid_highlighting = speaker_key == M.key)
		else
			to_chat(M, message, avoid_highlighting = speaker_key == M.key)

//Used in chemical_mob_spawn. Generates a random mob based on a given gold_core_spawnable value.
/proc/create_random_mob(spawn_location, mob_class = HOSTILE_SPAWN)
	var/static/list/mob_spawn_meancritters = list() // list of possible hostile mobs
	var/static/list/mob_spawn_nicecritters = list() // and possible friendly mobs

	if(mob_spawn_meancritters.len <= 0 || mob_spawn_nicecritters.len <= 0)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			switch(initial(SA.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += T
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += T
		for(var/mob/living/basic/basic_mob as anything in typesof(/mob/living/basic))
			switch(initial(basic_mob.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += basic_mob
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += basic_mob

	var/chosen
	if(mob_class == FRIENDLY_SPAWN)
		chosen = pick(mob_spawn_nicecritters)
	else
		chosen = pick(mob_spawn_meancritters)
	var/mob/living/spawned_mob = new chosen(spawn_location)
	return spawned_mob

/proc/passtable_on(target, source)
	var/mob/living/L = target
	if (!HAS_TRAIT(L, TRAIT_PASSTABLE) && L.pass_flags & PASSTABLE)
		ADD_TRAIT(L, TRAIT_PASSTABLE, INNATE_TRAIT)
	ADD_TRAIT(L, TRAIT_PASSTABLE, source)
	L.pass_flags |= PASSTABLE

/proc/passtable_off(target, source)
	var/mob/living/L = target
	REMOVE_TRAIT(L, TRAIT_PASSTABLE, source)
	if(!HAS_TRAIT(L, TRAIT_PASSTABLE))
		L.pass_flags &= ~PASSTABLE

/proc/dance_rotate(atom/movable/AM, datum/callback/callperrotate, set_original_dir=FALSE)
	set waitfor = FALSE
	var/originaldir = AM.dir
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!AM)
			return
		AM.setDir(i)
		callperrotate?.Invoke()
		sleep(1)
	if(set_original_dir)
		AM.setDir(originaldir)

///////////////////////
///Silicon Mob Procs///
///////////////////////

//Returns a list of unslaved cyborgs
/proc/active_free_borgs()
	. = list()
	for(var/mob/living/silicon/robot/borg in GLOB.silicon_mobs)
		if(borg.connected_ai || borg.shell)
			continue
		if(borg.stat == DEAD)
			continue
		if(borg.emagged || borg.scrambledcodes)
			continue
		. += borg

//Returns a list of AI's
/proc/active_ais(check_mind=FALSE, z = null)
	. = list()
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.stat == DEAD)
			continue
		if(ai.control_disabled)
			continue
		if(check_mind)
			if(!ai.mind)
				continue
		if(z && !(z == ai.z) && (!is_station_level(z) || !is_station_level(ai.z))) //if a Z level was specified, AND the AI is not on the same level, AND either is off the station...
			continue
		. += ai

//Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs(z)
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais(FALSE, z)
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
			selected = A

	return selected

/proc/select_active_free_borg(mob/user)
	var/list/borgs = active_free_borgs()
	if(borgs.len)
		if(user)
			. = input(user,"Unshackled cyborg signals detected:", "Cyborg Selection", borgs[1]) in sort_list(borgs)
		else
			. = pick(borgs)
	return .

/proc/select_active_ai(mob/user, z = null)
	var/list/ais = active_ais(FALSE, z)
	if(ais.len)
		if(user)
			. = input(user,"AI signals detected:", "AI Selection", ais[1]) in sort_list(ais)
		else
			. = pick(ais)
	return .

/**
 * Used to get the amount of change between two body temperatures
 *
 * When passed the difference between two temperatures returns the amount of change to temperature to apply.
 * The change rate should be kept at a low value tween 0.16 and 0.02 for optimal results.
 * vars:
 * * temp_diff (required) The differance between two temperatures
 * * change_rate (optional)(Default: 0.06) The rate of range multiplyer
 */
/proc/get_temp_change_amount(temp_diff, change_rate = 0.06)
	if(temp_diff < 0)
		return -(BODYTEMP_AUTORECOVERY_DIVISOR / 2) * log(1 - (temp_diff * change_rate))
	return (BODYTEMP_AUTORECOVERY_DIVISOR / 2) * log(1 + (temp_diff * change_rate))

#define ISADVANCEDTOOLUSER(mob) (HAS_TRAIT(mob, TRAIT_ADVANCEDTOOLUSER) && !HAS_TRAIT(mob, TRAIT_DISCOORDINATED_TOOL_USER))

/// If a mob is in hard or soft stasis
#define IS_IN_STASIS(mob) ((mob.stasis_level && (mob.life_ticks % mob.stasis_level)) || mob.has_status_effect(/datum/status_effect/grouped/hard_stasis))

/// If a mob is in hard stasis
#define IS_IN_HARD_STASIS(mob) (mob.has_status_effect(/datum/status_effect/grouped/hard_stasis))

/// Set a stasis level for a specific source.
#define SET_STASIS_LEVEL(mob, source, level) \
	mob.stasis_level -= mob.stasis_sources[source]; \
	mob.stasis_level += level;\
	mob.stasis_sources[source] = level

#define UNSET_STASIS_LEVEL(mob, source) \
	mob.stasis_level -= mob.stasis_sources[source];\
	mob.stasis_sources -= source

/// Gets the client of the mob, allowing for mocking of the client.
/// You only need to use this if you know you're going to be mocking clients somewhere else.
#define GET_CLIENT(mob) (##mob.client || ##mob.mock_client)

///Orders mobs by type then by name. Accepts optional arg to sort a custom list, otherwise copies GLOB.mob_list.
/proc/sort_mobs()
	var/list/moblist = list()
	var/list/sortmob = sort_names(GLOB.mob_list)
	for(var/mob/living/silicon/ai/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/camera/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/silicon/pai/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/silicon/robot/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/carbon/human/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/brain/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/carbon/alien/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/dead/observer/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/dead/new_player/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/simple_animal/slime/mob_to_sort in sortmob)
		moblist += mob_to_sort
	for(var/mob/living/simple_animal/mob_to_sort in sortmob)
		// We've already added slimes.
		if(isslime(mob_to_sort))
			continue
		moblist += mob_to_sort
	for(var/mob/living/basic/mob_to_sort in sortmob)
		moblist += mob_to_sort
	return moblist

///returns a mob type controlled by a specified ckey
/proc/get_mob_by_ckey(key)
	if(!key)
		return

	var/mob/pmob = GLOB.persistent_clients_by_ckey[key]?.mob
	if(pmob)
		return pmob

	var/list/mobs = sort_mobs()
	for(var/mob/mob in mobs)
		if(mob.ckey == key)
			return mob

///Return a string for the specified body zone. Should be used for parsing non-instantiated bodyparts, otherwise use [/obj/item/bodypart/var/plaintext_zone]
/proc/parse_zone(zone)
	switch(zone)
		if(BODY_ZONE_CHEST)
			return "chest"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "right hand"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "left hand"
		if(BODY_ZONE_L_ARM)
			return "left arm"
		if(BODY_ZONE_R_ARM)
			return "right arm"
		if(BODY_ZONE_L_LEG)
			return "left leg"
		if(BODY_ZONE_R_LEG)
			return "right leg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "left foot"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "right foot"
		if(BODY_ZONE_PRECISE_GROIN)
			return "groin"
		else
			return zone

///Returns a list of strings for a given slot flag.
/proc/parse_slot_flags(slot_flags)
	var/list/slot_strings = list()
	if(slot_flags & ITEM_SLOT_BACK)
		slot_strings += "back"
	if(slot_flags & ITEM_SLOT_MASK)
		slot_strings += "mask"
	if(slot_flags & ITEM_SLOT_NECK)
		slot_strings += "neck"
	if(slot_flags & ITEM_SLOT_HANDCUFFED)
		slot_strings += "handcuff"
	if(slot_flags & ITEM_SLOT_LEGCUFFED)
		slot_strings += "legcuff"
	if(slot_flags & ITEM_SLOT_BELT)
		slot_strings += "belt"
	if(slot_flags & ITEM_SLOT_ID)
		slot_strings += "id"
	if(slot_flags & ITEM_SLOT_EARS)
		slot_strings += "ear"
	if(slot_flags & ITEM_SLOT_EYES)
		slot_strings += "glasses"
	if(slot_flags & ITEM_SLOT_GLOVES)
		slot_strings += "glove"
	if(slot_flags & ITEM_SLOT_HEAD)
		slot_strings += "head"
	if(slot_flags & ITEM_SLOT_FEET)
		slot_strings += "shoe"
	if(slot_flags & ITEM_SLOT_OCLOTHING)
		slot_strings += "oversuit"
	if(slot_flags & ITEM_SLOT_ICLOTHING)
		slot_strings += "undersuit"
	if(slot_flags & ITEM_SLOT_SUITSTORE)
		slot_strings += "suit storage"
	if(slot_flags & (ITEM_SLOT_LPOCKET|ITEM_SLOT_RPOCKET))
		slot_strings += "pocket"
	if(slot_flags & ITEM_SLOT_HANDS)
		slot_strings += "hand"
	if(slot_flags & ITEM_SLOT_DEX_STORAGE)
		slot_strings += "dextrous storage"
	if(slot_flags & ITEM_SLOT_BACKPACK)
		slot_strings += "backpack"
	return slot_strings

///Returns the direction that the initiator and the target are facing
/proc/check_target_facings(mob/living/initiator, mob/living/target)
	/*This can be used to add additional effects on interactions between mobs depending on how the mobs are facing each other, such as adding a crit damage to blows to the back of a guy's head.
	Given how click code currently works (Nov '13), the initiating mob will be facing the target mob most of the time
	That said, this proc should not be used if the change facing proc of the click code is overridden at the same time*/
	if(!isliving(target) || target.body_position == LYING_DOWN)
	//Make sure we are not doing this for things that can't have a logical direction to the players given that the target would be on their side
		return FALSE
	if(initiator.dir == target.dir) //mobs are facing the same direction
		return FACING_SAME_DIR
	if(is_source_facing_target(initiator,target) && is_source_facing_target(target,initiator)) //mobs are facing each other
		return FACING_EACHOTHER
	if(initiator.dir + 2 == target.dir || initiator.dir - 2 == target.dir || initiator.dir + 6 == target.dir || initiator.dir - 6 == target.dir) //Initating mob is looking at the target, while the target mob is looking in a direction perpendicular to the 1st
		return FACING_INIT_FACING_TARGET_TARGET_FACING_PERPENDICULAR

///Returns the occupant mob or brain from a specified input
/proc/get_mob_or_brainmob(occupant)
	var/mob/living/mob_occupant

	if(isliving(occupant))
		mob_occupant = occupant

	else if(isbodypart(occupant))
		var/obj/item/bodypart/head/head = occupant

		mob_occupant = head.brainmob

	else if(isorgan(occupant))
		var/obj/item/organ/brain/brain = occupant
		mob_occupant = brain.brainmob

	return mob_occupant

///Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
/mob/proc/apply_pref_name(preference_type, client/requesting_client)
	if(!requesting_client)
		requesting_client = client
	var/oldname = real_name
	var/newname
	var/loop = 1
	var/safety = 0

	var/random = CONFIG_GET(flag/force_random_names) || (requesting_client ? is_banned_from(requesting_client.ckey, "Appearance") : FALSE)

	while(loop && safety < 5)
		if(!safety && !random)
			newname = requesting_client?.prefs?.read_preference(preference_type)
		else
			var/datum/preference/preference = GLOB.preference_entries[preference_type]
			newname = preference.create_informed_default_value(requesting_client.prefs)

		for(var/mob/living/checked_mob in GLOB.player_list)
			if(checked_mob == src)
				continue
			if(!newname || checked_mob.real_name == newname)
				newname = null
				loop++ // name is already taken so we roll again
				break
		loop--
		safety++

	if(newname)
		fully_replace_character_name(oldname, newname)
		return TRUE
	return FALSE

///Returns the amount of currently living players
/proc/living_player_count()
	var/living_player_count = 0
	for(var/mob in GLOB.player_list)
		if(mob in GLOB.alive_mob_list)
			living_player_count += 1
	return living_player_count

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

///Version of view() which ignores darkness, because BYOND doesn't have it (I actually suggested it but it was tagged redundant, BUT HEARERS IS A T- /rant).
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center

	GLOB.dview_mob.see_invisible = invis_flags

	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	name = "INTERNAL DVIEW MOB"
	invisibility = 101
	density = FALSE
	see_in_dark = 1e6
	move_resist = INFINITY
	var/ready_to_die = FALSE

/mob/dview/Initialize(mapload) //Properly prevents this mob from gaining huds or joining any global lists
	SHOULD_CALL_PARENT(FALSE)
	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/mob/dview/Destroy(force = FALSE)
	if(!ready_to_die)
		stack_trace("ALRIGHT WHICH FUCKER TRIED TO DELETE *MY* DVIEW?")

		if (!force)
			return QDEL_HINT_LETMELIVE

		log_world("EVACUATE THE SHITCODE IS TRYING TO STEAL MUH JOBS")
		GLOB.dview_mob = new
	return ..()


#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center;           \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define FOR_DVIEW_END GLOB.dview_mob.loc = null

///Makes a call in the context of a different usr. Use sparingly
/world/proc/push_usr(mob/user_mob, datum/callback/invoked_callback, ...)
	var/temp = usr
	usr = user_mob
	if (length(args) > 2)
		. = invoked_callback.Invoke(arglist(args.Copy(3)))
	else
		. = invoked_callback.Invoke()
	usr = temp

#undef FACING_SAME_DIR
#undef FACING_EACHOTHER
#undef FACING_INIT_FACING_TARGET_TARGET_FACING_PERPENDICULAR
