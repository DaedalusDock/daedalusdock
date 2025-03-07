/**
 * x1, y1, x2, y2 - Represents the bounding box for the ID card's non-transparent portion of its various icon_states.
 * Used to crop the ID card's transparency away when chaching the icon for better use in tgui chat.
 */
#define ID_ICON_BORDERS 1, 9, 32, 24

/// Fallback time if none of the config entries are set for USE_LOW_LIVING_HOUR_INTERN
#define INTERN_THRESHOLD_FALLBACK_HOURS 15


/* Cards
 * Contains:
 * DATA CARD
 * ID CARD
 * FINGERPRINT CARD HOLDER
 * FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */

/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/list/files = list()

/obj/item/card/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to swipe [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/*
 * ID CARDS
 */

/// "Retro" ID card that renders itself as the icon state with no overlays.
/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "card_grey"
	worn_icon_state = "card_retro"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	slot_flags = ITEM_SLOT_ID
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	/// Cached icon that has been built for this card. Intended for use in chat.
	var/icon/cached_flat_icon

	/// How many magical mining Disney Dollars this card has for spending at the mining equipment vendors.
	var/mining_points = 0

	/// Linked bank account.
	var/datum/bank_account/registered_account

	/// The name registered on the card (for example: Dr Bryan See)
	var/registered_name = null
	/// The name used in the ID UI. See update_label()
	var/label = "Unassigned"
	/// Registered owner's age.
	var/registered_age = 30
	/// Registered owner's dna hash.
	var/dna_hash = "UNSET"
	/// Registered owner's fingerprint.
	var/fingerprint = "UNSET"
	/// Registered owner's blood type.
	var/blood_type = "UNSET"
	// Images to store in the ID, based on the datacore.
	var/mutable_appearance/front_image
	var/mutable_appearance/side_image

	/// The job name registered on the card (for example: Assistant). Set by trim usually.
	var/assignment

	/// Trim datum associated with the card. Controls which job icon is displayed on the card and which accesses do not require wildcards.
	var/datum/id_trim/trim

	/// Access levels held by this card.
	var/list/access = list()

	/// List of wildcard slot names as keys with lists of wildcard data as values.
	var/list/wildcard_slots = list()

	/// Boolean value. If TRUE, the [Intern] tag gets prepended to this ID card when the label is updated.
	var/is_intern = FALSE

/obj/item/card/id/Initialize(mapload)
	. = ..()

	var/datum/bank_account/blank_bank_account = new /datum/bank_account("Unassigned", player_account = FALSE)
	registered_account = blank_bank_account
	blank_bank_account.account_job = new /datum/job/unassigned
	registered_account.replaceable = TRUE

	// Applying the trim updates the label and icon, so don't do this twice.
	if(ispath(trim))
		SSid_access.apply_trim_to_card(src, trim)
	else
		update_label()
		update_icon()

	register_context()

/obj/item/card/id/Destroy()
	if (registered_account)
		registered_account.bank_cards -= src
	return ..()

/obj/item/card/id/get_id_examine_strings(mob/user)
	. = ..()
	. += list("[icon2html(get_cached_flat_icon(), user, extra_classes = "bigicon")]")

/obj/item/card/id/update_overlays()
	. = ..()

	cached_flat_icon = null

/// If no cached_flat_icon exists, this proc creates it and crops it. This proc then returns the cached_flat_icon. Intended only for use displaying ID card icons in chat.
/obj/item/card/id/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
		cached_flat_icon.Crop(ID_ICON_BORDERS)
	return cached_flat_icon

/obj/item/card/id/get_examine_string(mob/user, thats = FALSE)
	var/that_string = gender == PLURAL ? "Those are " : "That is "
	return "[icon2html(get_cached_flat_icon(), user)] [thats ? that_string :""][get_examine_name(user)]"

/**
 * Helper proc, checks whether the ID card can hold any given set of wildcards.
 *
 * Returns TRUE if the card can hold the wildcards, FALSE otherwise.
 * Arguments:
 * * wildcard_list - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add wildcards for this wildcard specifically and will return FALSE if the card cannot hold all wildcards in this slot.
 */
/obj/item/card/id/proc/can_add_wildcards(list/wildcard_list, try_wildcard = null)
	if(!length(wildcard_list))
		return TRUE

	var/list/new_wildcard_limits = list()

	for(var/flag_name in wildcard_slots)
		if(try_wildcard && !(flag_name == try_wildcard))
			continue
		var/list/wildcard_info = wildcard_slots[flag_name]
		new_wildcard_limits[flag_name] = wildcard_info["limit"] - length(wildcard_info["usage"])

	if(!length(new_wildcard_limits))
		return FALSE

	var/wildcard_allocated
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in new_wildcard_limits)
			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]
			if(!(wildcard_flag & limit_flags))
				continue
			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(new_wildcard_limits[flag_name] == 0)
				continue
			new_wildcard_limits[flag_name]--
			wildcard_allocated = TRUE
			break
		if(!wildcard_allocated)
			return FALSE

	return TRUE

/**
 * Attempts to add the given wildcards to the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to add.
 * * try_wildcard - If not null, will attempt to add all wildcards to this wildcard slot only.
 * * mode - The method to use when adding wildcards. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_wildcards(list/wildcard_list, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/wildcard_allocated
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to fit it in.
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			if(try_wildcard && !(flag_name == try_wildcard))
				continue

			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]

			if(!(wildcard_flag & limit_flags))
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_limit = wildcard_info["limit"]
			var/list/wildcard_usage = wildcard_info["usage"]

			var/wildcard_count = wildcard_limit - length(wildcard_usage)

			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(wildcard_count == 0)
				continue

			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_allocated = TRUE
			break
		// Fallback for if we couldn't allocate the wildcard for some reason.
		if(!wildcard_allocated)
			if(mode == ERROR_ON_FAIL)
				CRASH("Wildcard ([wildcard]) could not be added to [src].")

			if(mode == TRY_ADD_ALL)
				continue

			// If the card has no info for historic forced wildcards, create the list.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				wildcard_slots[WILDCARD_NAME_FORCED] = list(limit = 0, usage = list())

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/list/wildcard_usage = wildcard_info["usage"]
			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

/**
 * Removes wildcards from the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_wildcards(list/wildcard_list)
	var/wildcard_removed
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to remove it.
	for(var/wildcard in wildcard_list)
		wildcard_removed = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				continue

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_removed = TRUE
			break
		// Fallback to see if this was a force-added wildcard.
		if(!wildcard_removed)
			// If the card has no info for historic forced wildcards, that's an error state.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This card has no forced wildcard data and the wildcard is not in this card's wildcard lists.")

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This access is not a wildcard on this card.")

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

			if(!wildcard_info["limit"])
				wildcard_slots -= WILDCARD_NAME_FORCED

/**
 * Attempts to add the given accesses to the ID card as non-wildcards.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * add_accesses - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add all accesses that require wildcard slots to this wildcard slot only.
 * * mode - The method to use when adding accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_access(list/add_accesses, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(add_accesses, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access, try_wildcard))
			CRASH("Cannot add wildcards from \[[add_accesses.Join(",")]\] to [src]")

	// All clear to add the accesses.
	access |= normal_access
	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, try_wildcard, mode = mode)

	return TRUE

/**
 * Removes the given accesses from the ID Card.
 *
 * Will remove the wildcards if the accesses given are on the card as wildcard accesses.
 * Arguments:
 * * rem_accesses - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_access(list/rem_accesses)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(rem_accesses, normal_access, wildcard_access)

	access -= normal_access
	remove_wildcards(wildcard_access)

/**
 * Attempts to set the card's accesses to the given accesses, clearing all accesses not in the given list.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * new_access_list - List of all accesses that this card should hold exclusively.
 * * mode - The method to use when setting accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/set_access(list/new_access_list, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(new_access_list, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access))
			CRASH("Cannot add wildcards from \[[new_access_list.Join(",")]\] to [src]")

	clear_access()

	access = normal_access.Copy()

	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, mode = mode)

	return TRUE

/// Clears all accesses from the ID card - both wildcard and normal.
/obj/item/card/id/proc/clear_access()
	// Go through the wildcards and reset them.
	for(var/flag_name in wildcard_slots)
		var/list/wildcard_info = wildcard_slots[flag_name]
		var/list/wildcard_usage = wildcard_info["usage"]
		wildcard_usage.Cut()

	// Hard reset access
	access.Cut()

/// Clears the economy account from the ID card.
/obj/item/card/id/proc/clear_account()
	registered_account = null


/**
 * Helper proc. Creates access lists for the access procs.
 *
 * Takes the accesses list and compares it with the trim. Any basic accesses that match the trim are
 * added to basic_access_list and the rest are added to wildcard_access_list.

 * This proc directly modifies the lists passed in as args. It expects these lists to be instantiated.
 * There is no return value.
 * Arguments:
 * * accesses - List of accesses you want to stort into basic_access_list and wildcard_access_list. Should not be null.
 * * basic_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim supports to it.
 * * wildcard_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim does not support to it.
 */
/obj/item/card/id/proc/build_access_lists(list/accesses, list/basic_access_list, list/wildcard_access_list)
	if(!length(accesses) || isnull(basic_access_list) || isnull(wildcard_access_list))
		CRASH("Invalid parameters passed to build_access_lists")

	var/list/trim_accesses = trim?.access

	// Populate the lists.
	for(var/new_access in accesses)
		if(new_access in trim_accesses)
			basic_access_list |= new_access
			continue

		wildcard_access_list |= new_access

/obj/item/card/id/attack_self(mob/user)
	user.visible_message("<b>[user]</b> holds up [src]. <a href='?src=\ref[src];look_at_id=1'>\[Look at ID\]</a>", null, vision_distance = 1)
	show(user)
	add_fingerprint(user)

/obj/item/card/id/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(held_item != src)
		return

	context[SCREENTIP_CONTEXT_LMB] = "Show ID"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, assignment), NAMEOF(src, registered_name), NAMEOF(src, registered_age))
				update_label()
				update_icon()
			if(NAMEOF(src, trim))
				if(ispath(trim))
					SSid_access.apply_trim_to_card(src, trim)

/// Helper proc. Can the user interact with the ID?
/obj/item/card/id/proc/can_use_id(mob/living/user)
	if(!isliving(user))
		return
	if(!user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return

	return TRUE

/// Attempts to set a new bank account on the ID card.
/obj/item/card/id/proc/set_new_account(mob/living/user)
	. = FALSE
	var/datum/bank_account/old_account = registered_account
	if(loc != user)
		to_chat(user, span_warning("You must be holding the ID to continue!"))
		return FALSE

	var/new_bank_id = tgui_input_number(user, "Enter your account ID number", "Account Reclamation", 111111, 999999, 111111)
	if(!new_bank_id || QDELETED(user) || QDELETED(src) || issilicon(user) || !can_use_id(user) || loc != user)
		return FALSE

	if(registered_account?.account_id == new_bank_id)
		to_chat(user, span_warning("The account ID was already assigned to this card."))
		return FALSE

	var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[new_bank_id]"]
	if(isnull(account))
		to_chat(user, span_warning("The account ID number provided is invalid."))
		return FALSE

	if(old_account)
		old_account.bank_cards -= src
		account.account_balance += old_account.account_balance

	account.bank_cards += src
	registered_account = account
	to_chat(user, span_notice("The provided account has been linked to this ID card. It contains [account.account_balance] credits."))
	return TRUE

/obj/item/card/id/examine(mob/user)
	. = ..()
	. += "<a href='?src=\ref[src];look_at_id=1'>\[Look at ID\]</a>"
	if(registered_account)
		. += span_notice("The account linked to the ID belongs to '[registered_account.account_holder]'.")

	if(HAS_TRAIT(user, TRAIT_ID_APPRAISER))
		. += HAS_TRAIT(src, TRAIT_JOB_FIRST_ID_CARD) ? span_boldnotice("Hmm... yes, this ID was issued from Central Command!") : span_boldnotice("This ID was created in this sector, not by Central Command.")

/obj/item/card/id/proc/show(mob/user)
	set waitfor = FALSE

	var/atom/movable/screen/front_container = user.send_appearance(front_image)
	var/atom/movable/screen/side_container = user.send_appearance(side_image)

	var/list/content = list("<table style='width:100%'><tr><td>")
	content += "Name: [registered_name]<br>"
	content += "Age: [registered_age]<br>"
	content += "Assignment: [assignment]<br><br>"
	content += "Blood Type: [blood_type]<br>"
	content += "Fingerprint: [fingerprint]<br>"
	content += "DNA Hash: [dna_hash]<br>"

	if(front_image && side_image)
		content +="<td style='text-align:center; vertical-align:top'>Photo:<br><img src=\ref[front_container.appearance] height=128 width=128 border=4 style='image-rendering: pixelated;-ms-interpolation-mode: nearest-neighbor'><img src=\ref[side_container.appearance] height=128 width=128 border=4 style='image-rendering: pixelated;-ms-interpolation-mode: nearest-neighbor'></td>"
	content += "</tr></table>"
	content = jointext(content, null)

	var/datum/browser/popup = new(user, "idcard", name, 660, 270)
	popup.set_content(content)
	popup.open()
	sleep(1) // I don't know why but for some reason I need to re-send the entire UI to get it to display icons. Yes, I tried sleeping after sending the appearances.
	popup.open()

/obj/item/card/id/GetAccess()
	return access.Copy()

/obj/item/card/id/GetID(bypass_wallet)
	return src

/obj/item/card/id/RemoveID()
	return src

/// Updates the name based on the card's vars and state.
/obj/item/card/id/proc/update_label()
	var/name_string = registered_name ? "[registered_name]'s ID Card" : initial(name)
	var/assignment_string

	if(is_intern)
		if(assignment)
			assignment_string = trim?.intern_alt_name || "Intern [assignment]"
		else
			assignment_string = "Intern"
	else
		assignment_string = assignment

	label = "[name_string], [assignment_string]"

/obj/item/card/id/proc/set_data_by_record(datum/data/record/R, set_access, visual)
	registered_name = R.fields[DATACORE_NAME]
	registered_age = R.fields[DATACORE_AGE] || "UNSET"
	dna_hash = R.fields[DATACORE_DNA_IDENTITY] || "UNSET"
	fingerprint = R.fields[DATACORE_FINGERPRINT] || "UNSET"
	blood_type = R.fields[DATACORE_BLOOD_TYPE] || "UNSET"
	assignment = R.fields[DATACORE_TRIM] || "UNSET"
	for(var/datum/id_trim/trim as anything in SSid_access.trim_singletons_by_path)
		trim = SSid_access.trim_singletons_by_path[trim]
		if(trim.assignment == R.fields[DATACORE_TRIM])
			if(visual)
				SSid_access.apply_trim_to_chameleon_card(src, trim.type)
			else
				SSid_access.apply_trim_to_card(src, trim.type, set_access)
	update_label()
	update_icon()

/obj/item/card/id/proc/datacore_ready(datum/source)
	SIGNAL_HANDLER
	set_icon(SSdatacore.get_record_by_name(registered_name, DATACORE_RECORDS_LOCKED))
	UnregisterSignal(src, COMSIG_GLOB_DATACORE_READY)

/// Sets the UI icon of the ID to their datacore entry, or their current appearance if no record is found.
/obj/item/card/id/proc/set_icon(datum/data/record/R, mutable_appearance/mob_appearance)
	if(ismob(mob_appearance))
		mob_appearance = new(mob_appearance)

	if(R)
		side_image = new(R.fields["character_appearance"])
		side_image.dir = WEST
		front_image = new(side_image)
		front_image.dir = SOUTH

	else
		if(!mob_appearance)
			var/mob/M = src
			while(M && !ismob(M))
				M = M.loc
			if(!M)
				return
			mob_appearance = new(M)

		remove_non_canon_overlays(mob_appearance)

		mob_appearance.dir = SOUTH
		front_image = mob_appearance

		side_image = new(front_image)
		side_image.dir = WEST

/// Returns the trim assignment name.
/obj/item/card/id/proc/get_trim_assignment()
	return trim?.assignment || assignment

/// Returns the trim sechud icon state.
/obj/item/card/id/proc/get_trim_sechud_icon_state()
	return trim?.sechud_icon_state || SECHUD_UNKNOWN

/obj/item/card/id/away
	name = "\proper a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."
	trim = /datum/id_trim/away
	icon_state = "retro"
	registered_age = null

/obj/item/card/id/away/hotel
	name = "Staff ID"
	desc = "A staff ID used to access the hotel's doors."
	trim = /datum/id_trim/away/hotel

/obj/item/card/id/away/hotel/security
	name = "Officer ID"
	trim = /datum/id_trim/away/hotel/security

/obj/item/card/id/away/old
	name = "\proper a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."

/obj/item/card/id/away/old/sec
	name = "Charlie Station Security Officer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Security Officer\"."
	trim = /datum/id_trim/away/old/sec

/obj/item/card/id/away/old/sci
	name = "Charlie Station Scientist's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Scientist\"."
	trim = /datum/id_trim/away/old/sci

/obj/item/card/id/away/old/eng
	name = "Charlie Station Engineer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Station Engineer\"."
	trim = /datum/id_trim/away/old/eng

/obj/item/card/id/away/old/apc
	name = "APC Access ID"
	desc = "A special ID card that allows access to APC terminals."
	trim = /datum/id_trim/away/old/apc

/obj/item/card/id/away/deep_storage //deepstorage.dmm space ruin
	name = "bunker access ID"

/obj/item/card/id/departmental_budget
	name = "departmental card (ERROR)"
	desc = "Provides access to the departmental budget."
	icon_state = "budgetcard"
	var/department_ID = ACCOUNT_STATION_MASTER
	var/department_name = ACCOUNT_STATION_MASTER_NAME
	registered_age = null

/obj/item/card/id/departmental_budget/Initialize(mapload)
	. = ..()
	var/datum/bank_account/B = SSeconomy.department_accounts_by_id[department_ID]
	if(B)
		registered_account = B
		B.bank_cards |= src
		name = "departmental card ([department_name])"
		desc = "Provides access to the [department_name]."
	SSeconomy.dep_cards += src

/obj/item/card/id/departmental_budget/Destroy()
	SSeconomy.dep_cards -= src
	return ..()

/obj/item/card/id/departmental_budget/update_label()
	return

/obj/item/card/id/departmental_budget/car
	department_ID = ACCOUNT_CAR
	department_name = ACCOUNT_CAR_NAME
	icon_state = "car_budget" //saving up for a new tesla

/obj/item/card/id/advanced
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station. Has an integrated digital display and advanced microchips."
	icon_state = "card_grey"
	worn_icon_state = "card_grey"

	wildcard_slots = WILDCARD_LIMIT_GREY

	/// An overlay icon state for when the card is assigned to a name. Usually manifests itself as a little scribble to the right of the job icon.
	var/assigned_icon_state = "assigned"

	/// If this is set, will manually override the icon file for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_icon_override
	/// If this is set, will manually override the icon state for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_state_override
	/// If this is set, will manually override the trim's assignmment as it appears in the crew monitor and elsewhere. Intended for admins to VV edit and chameleon ID cards.
	var/trim_assignment_override
	/// If this is set, will manually override the trim shown for SecHUDs. Intended for admins to VV edit and chameleon ID cards.
	var/sechud_icon_state_override = null

/obj/item/card/id/advanced/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
	RegisterSignal(src, COMSIG_ITEM_UNEQUIPPED, PROC_REF(remove_intern_status))

/obj/item/card/id/advanced/Destroy()
	UnregisterSignal(src, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_UNEQUIPPED))

	return ..()

/obj/item/card/id/advanced/proc/update_intern_status(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!user?.client)
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		return
	if(!CONFIG_GET(flag/use_low_living_hour_intern))
		return
	if(!SSdbcore.Connect())
		return

	var/intern_threshold = (CONFIG_GET(number/use_low_living_hour_intern_hours) * 60) || (CONFIG_GET(number/use_exp_restrictions_heads_hours) * 60) || INTERN_THRESHOLD_FALLBACK_HOURS * 60
	var/playtime = user.client.get_exp_living(pure_numeric = TRUE)

	if((intern_threshold >= playtime) && (user.mind?.assigned_role.job_flags & JOB_CAN_BE_INTERN))
		is_intern = TRUE
		update_label()
		return

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/proc/remove_intern_status(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/proc/on_holding_card_slot_moved(obj/item/computer_hardware/card_slot/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	if(istype(old_loc, /obj/item/modular_computer/tablet))
		UnregisterSignal(old_loc, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_UNEQUIPPED))

	if(istype(source.loc, /obj/item/modular_computer/tablet))
		RegisterSignal(source.loc, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
		RegisterSignal(source.loc, COMSIG_ITEM_UNEQUIPPED, PROC_REF(remove_intern_status))

/obj/item/card/id/advanced/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()

	if(istype(old_loc, /obj/item/storage/wallet))
		UnregisterSignal(old_loc, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_UNEQUIPPED))

	if(istype(old_loc, /obj/item/computer_hardware/card_slot))
		var/obj/item/computer_hardware/card_slot/slot = old_loc

		UnregisterSignal(old_loc, COMSIG_MOVABLE_MOVED)

		if(istype(slot.holder, /obj/item/modular_computer/tablet))
			var/obj/item/modular_computer/tablet/slot_holder = slot.holder
			UnregisterSignal(slot_holder, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_UNEQUIPPED))

	if(istype(loc, /obj/item/storage/wallet))
		RegisterSignal(loc, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
		RegisterSignal(loc, COMSIG_ITEM_UNEQUIPPED, PROC_REF(remove_intern_status))

	if(istype(loc, /obj/item/computer_hardware/card_slot))
		var/obj/item/computer_hardware/card_slot/slot = loc

		RegisterSignal(loc, COMSIG_MOVABLE_MOVED, PROC_REF(on_holding_card_slot_moved))

		if(istype(slot.holder, /obj/item/modular_computer/tablet))
			var/obj/item/modular_computer/tablet/slot_holder = slot.holder
			RegisterSignal(slot_holder, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
			RegisterSignal(slot_holder, COMSIG_ITEM_UNEQUIPPED, PROC_REF(remove_intern_status))

/obj/item/card/id/advanced/update_overlays()
	. = ..()

	if(registered_name && registered_name != "Captain")
		. += mutable_appearance(icon, assigned_icon_state)

	var/trim_icon_file = trim_icon_override ? trim_icon_override : trim?.trim_icon
	var/trim_icon_state = trim_state_override ? trim_state_override : trim?.trim_state

	if(!trim_icon_file || !trim_icon_state)
		return

	. += mutable_appearance(trim_icon_file, trim_icon_state)

/obj/item/card/id/advanced/get_trim_assignment()
	if(trim_assignment_override)
		return trim_assignment_override

	if(ispath(trim))
		var/datum/id_trim/trim_singleton = SSid_access.trim_singletons_by_path[trim]
		return trim_singleton.assignment

	return ..()

/// Returns the trim sechud icon state.
/obj/item/card/id/advanced/get_trim_sechud_icon_state()
	return sechud_icon_state_override || ..()

/obj/item/card/id/advanced/silver
	name = "silver identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "card_silver"
	worn_icon_state = "card_silver"
	inhand_icon_state = "silver_id"
	wildcard_slots = WILDCARD_LIMIT_SILVER

/datum/id_trim/maint_reaper
	access = list(ACCESS_MAINT_TUNNELS)
	trim_state = "trim_janitor"
	assignment = "Reaper"

/obj/item/card/id/advanced/silver/reaper
	name = "Thirteen's ID Card (Reaper)"
	trim = /datum/id_trim/maint_reaper
	registered_name = "Thirteen"

/obj/item/card/id/advanced/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	icon_state = "card_gold"
	worn_icon_state = "card_gold"
	inhand_icon_state = "gold_id"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/gold/captains_spare
	name = "superintendent's spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = JOB_CAPTAIN
	trim = /datum/id_trim/job/captain
	registered_age = null

/obj/item/card/id/advanced/gold/captains_spare/update_label() //so it doesn't change to Captain's ID card (Captain) on a sneeze
	if(registered_name == JOB_CAPTAIN)
		name = "[initial(name)][(!assignment || assignment == JOB_CAPTAIN) ? "" : " ([assignment])"]"
		update_appearance(UPDATE_ICON)
	else
		..()

/obj/item/card/id/advanced/centcom
	name = "\improper CentCom ID"
	desc = "An ID straight from Central Command."
	icon_state = "card_centcom"
	worn_icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	registered_name = JOB_CENTCOM
	registered_age = null
	trim = /datum/id_trim/centcom
	wildcard_slots = WILDCARD_LIMIT_CENTCOM

/obj/item/card/id/advanced/centcom/ert
	name = "\improper CentCom ID"
	desc = "An ERT ID card."
	registered_age = null
	registered_name = "Emergency Response Intern"
	trim = /datum/id_trim/centcom/ert

/obj/item/card/id/advanced/centcom/ert
	registered_name = JOB_ERT_COMMANDER
	trim = /datum/id_trim/centcom/ert/commander

/obj/item/card/id/advanced/centcom/ert/security
	registered_name = JOB_ERT_OFFICER
	trim = /datum/id_trim/centcom/ert/security

/obj/item/card/id/advanced/centcom/ert/engineer
	registered_name = JOB_ERT_ENGINEER
	trim = /datum/id_trim/centcom/ert/engineer

/obj/item/card/id/advanced/centcom/ert/medical
	registered_name = JOB_ERT_MEDICAL_DOCTOR
	trim = /datum/id_trim/centcom/ert/medical

/obj/item/card/id/advanced/centcom/ert/chaplain
	registered_name = JOB_ERT_CHAPLAIN
	trim = /datum/id_trim/centcom/ert/chaplain

/obj/item/card/id/advanced/centcom/ert/janitor
	registered_name = JOB_ERT_JANITOR
	trim = /datum/id_trim/centcom/ert/janitor

/obj/item/card/id/advanced/centcom/ert/clown
	registered_name = JOB_ERT_CLOWN
	trim = /datum/id_trim/centcom/ert/clown

/obj/item/card/id/advanced/black
	name = "black identification card"
	desc = "This card is telling you one thing and one thing alone. The person holding this card is an utter badass."
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/black/deathsquad
	name = "\improper Death Squad ID"
	desc = "A Death Squad ID card."
	registered_name = JOB_ERT_DEATHSQUAD
	trim = /datum/id_trim/centcom/deathsquad
	wildcard_slots = WILDCARD_LIMIT_DEATHSQUAD

/obj/item/card/id/advanced/black/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	registered_age = null
	trim = /datum/id_trim/syndicom
	wildcard_slots = WILDCARD_LIMIT_SYNDICATE

/obj/item/card/id/advanced/black/syndicate_command/crew_id
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	trim = /datum/id_trim/syndicom/crew

/obj/item/card/id/advanced/black/syndicate_command/captain_id
	name = "syndicate captain ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	trim = /datum/id_trim/syndicom/captain


/obj/item/card/id/advanced/black/syndicate_command/captain_id/syndie_spare
	name = "syndicate captain's spare ID"
	desc = "The spare ID of the Dark Lord himself."
	registered_name = "Captain"
	registered_age = null

/obj/item/card/id/advanced/black/syndicate_command/captain_id/syndie_spare/update_label()
	if(registered_name == "Captain")
		name = "[initial(name)][(!assignment || assignment == "Captain") ? "" : " ([assignment])"]"
		update_appearance(UPDATE_ICON)
		return

	return ..()

/obj/item/card/id/advanced/debug
	name = "\improper Debug ID"
	desc = "A debug ID card. Has ALL the all access, you really shouldn't have this."
	icon_state = "card_centcom"
	worn_icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	trim = /datum/id_trim/admin
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/debug/Initialize(mapload)
	. = ..()
	registered_account = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]

/obj/item/card/id/advanced/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "card_prisoner"
	worn_icon_state = "card_prisoner"
	inhand_icon_state = "orange-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	registered_name = "Scum"
	registered_age = null
	trim = /datum/id_trim/job/prisoner

	wildcard_slots = WILDCARD_LIMIT_PRISONER

	/// Number of gulag points required to earn freedom.
	var/goal = 0
	/// Number of gulag points earned.
	var/points = 0
	/// If the card has a timer set on it for temporary stay.
	var/timed = FALSE
	/// Time to assign to the card when they pass through the security gate.
	var/time_to_assign
	/// Time left on a card till they can leave.
	var/time_left = 0

/obj/item/card/id/advanced/prisoner/attackby(obj/item/card/id/C, mob/user)
	..()
	var/list/id_access = C.GetAccess()
	if(!(ACCESS_BRIG in id_access))
		return FALSE
	if(loc != user)
		to_chat(user, span_warning("You must be holding the ID to continue!"))
		return FALSE
	if(timed)
		timed = FALSE
		time_to_assign = initial(time_to_assign)
		registered_name = initial(registered_name)
		STOP_PROCESSING(SSobj, src)
		to_chat(user, "Restating prisoner ID to default parameters.")
		return
	var/choice = tgui_input_number(user, "Sentence time in seconds", "Sentencing")
	if(!choice || QDELETED(user) || QDELETED(src) || !usr.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK) || loc != user)
		return FALSE
	time_to_assign = choice
	to_chat(user, "You set the sentence time to [time_to_assign] seconds.")
	timed = TRUE

/obj/item/card/id/advanced/prisoner/proc/start_timer()
	say("Sentence started, welcome to the corporate rehabilitation center!")
	START_PROCESSING(SSobj, src)

/obj/item/card/id/advanced/prisoner/examine(mob/user)
	. = ..()
	if(timed)
		if(time_left <= 0)
			. += span_notice("The digital timer on the card has zero seconds remaining. You leave a changed man, but a free man nonetheless.")
		else
			. += span_notice("The digital timer on the card has [time_left] seconds remaining. Don't do the crime if you can't do the time.")

/obj/item/card/id/advanced/prisoner/process(delta_time)
	if(!timed)
		return

	time_left -= delta_time
	if(time_left <= 0)
		say("Sentence time has been served. Thank you for your cooperation in our corporate rehabilitation program!")
		return PROCESS_KILL

/obj/item/card/id/advanced/prisoner/attack_self(mob/user)
	to_chat(usr, span_notice("You have accumulated [points] out of the [goal] points you need for freedom."))

/obj/item/card/id/advanced/prisoner/one
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"
	trim = /datum/id_trim/job/prisoner/one

/obj/item/card/id/advanced/prisoner/two
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"
	trim = /datum/id_trim/job/prisoner/two

/obj/item/card/id/advanced/prisoner/three
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"
	trim = /datum/id_trim/job/prisoner/three

/obj/item/card/id/advanced/prisoner/four
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"
	trim = /datum/id_trim/job/prisoner/four

/obj/item/card/id/advanced/prisoner/five
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"
	trim = /datum/id_trim/job/prisoner/five

/obj/item/card/id/advanced/prisoner/six
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"
	trim = /datum/id_trim/job/prisoner/six

/obj/item/card/id/advanced/prisoner/seven
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"
	trim = /datum/id_trim/job/prisoner/seven

/obj/item/card/id/advanced/mining
	name = "mining ID"
	trim = /datum/id_trim/job/shaft_miner/spare

/obj/item/card/id/advanced/highlander
	name = "highlander ID"
	registered_name = "Highlander"
	desc = "There can be only one!"
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	trim = /datum/id_trim/highlander
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/chameleon
	trim = /datum/id_trim/chameleon
	wildcard_slots = WILDCARD_LIMIT_CHAMELEON

	/// Have we set a custom name and job assignment, or will we use what we're given when we chameleon change?
	var/forged = FALSE
	/// Anti-metagaming protections. If TRUE, anyone can change the ID card's details. If FALSE, only syndicate agents can.
	var/anyone = FALSE
	/// Weak ref to the ID card we're currently attempting to steal access from.
	var/datum/weakref/theft_target

/obj/item/card/id/advanced/chameleon/Initialize(mapload)
	. = ..()
	var/datum/action/item_action/chameleon/change/id/chameleon_card_action = new(src)
	chameleon_card_action.chameleon_type = /obj/item/card/id/advanced
	chameleon_card_action.chameleon_name = "ID Card"
	chameleon_card_action.initialize_disguises()
	add_item_action(chameleon_card_action)

/obj/item/card/id/advanced/chameleon/Destroy()
	theft_target = null
	. = ..()

/obj/item/card/id/advanced/chameleon/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target, /obj/item/card/id))
		theft_target = WEAKREF(target)
		ui_interact(user)
		return

	return ..()

/obj/item/card/id/advanced/chameleon/pre_attack_secondary(atom/target, mob/living/user, params)
	// If we're attacking a human, we want it to be covert. We're not ATTACKING them, we're trying
	// to sneakily steal their accesses by swiping our agent ID card near them. As a result, we
	// return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN to cancel any part of the following the attack chain.
	if(istype(target, /mob/living/carbon/human))
		to_chat(user, "<span class='notice'>You covertly start to scan [target] with \the [src], hoping to pick up a wireless ID card signal...</span>")

		if(!do_after(user, target, 2 SECONDS))
			to_chat(user, "<span class='notice'>The scan was interrupted.</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/mob/living/carbon/human/human_target = target

		var/list/target_id_cards = human_target.get_all_contents_type(/obj/item/card/id)

		if(!length(target_id_cards))
			to_chat(user, "<span class='notice'>The scan failed to locate any ID cards.</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/selected_id = pick(target_id_cards)
		to_chat(user, "<span class='notice'>You successfully sync your [src] with \the [selected_id].</span>")
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(istype(target, /obj/item))
		var/obj/item/target_item = target

		to_chat(user, "<span class='notice'>You covertly start to scan [target] with your [src], hoping to pick up a wireless ID card signal...</span>")

		var/list/target_id_cards = target_item.get_all_contents_type(/obj/item/card/id)

		var/target_item_id = target_item.GetID()

		if(target_item_id)
			target_id_cards |= target_item_id

		if(!length(target_id_cards))
			to_chat(user, "<span class='notice'>The scan failed to locate any ID cards.</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/selected_id = pick(target_id_cards)
		to_chat(user, "<span class='notice'>You successfully sync your [src] with \the [selected_id].</span>")
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return ..()

/obj/item/card/id/advanced/chameleon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChameleonCard", name)
		ui.open()

/obj/item/card/id/advanced/chameleon/ui_static_data(mob/user)
	var/list/data = list()
	data["wildcardFlags"] = SSid_access.wildcard_flags_by_wildcard
	data["accessFlagNames"] = SSid_access.access_flag_string_by_flag
	data["accessFlags"] = SSid_access.flags_by_access
	return data

/obj/item/card/id/advanced/chameleon/ui_host(mob/user)
	// Hook our UI to the theft target ID card for UI state checks.
	return theft_target?.resolve()

/obj/item/card/id/advanced/chameleon/ui_state(mob/user)
	return GLOB.always_state

/obj/item/card/id/advanced/chameleon/ui_status(mob/user)
	var/target = theft_target?.resolve()

	if(!target)
		return UI_CLOSE

	var/status = min(
		ui_status_user_strictly_adjacent(user, target),
		ui_status_user_is_advanced_tool_user(user),
		max(
			ui_status_user_is_conscious_and_lying_down(user),
			ui_status_user_is_abled(user, target),
		),
	)

	if(status < UI_INTERACTIVE)
		return UI_CLOSE

	return status

/obj/item/card/id/advanced/chameleon/ui_data(mob/user)
	var/list/data = list()

	data["showBasic"] = FALSE

	var/list/regions = list()

	var/obj/item/card/id/target_card = theft_target.resolve()
	if(target_card)
		var/list/tgui_region_data = SSid_access.all_region_access_tgui
		for(var/region in SSid_access.station_regions)
			regions += tgui_region_data[region]

	data["accesses"] = regions
	data["ourAccess"] = access
	data["ourTrimAccess"] = trim ? trim.access : list()
	data["theftAccess"] = target_card.access.Copy()
	data["wildcardSlots"] = wildcard_slots
	data["selectedList"] = access
	data["trimAccess"] = list()

	return data

/obj/item/card/id/advanced/chameleon/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/obj/item/card/id/target_card = theft_target?.resolve()
	if(QDELETED(target_card))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	// Wireless ID theft!
	var/turf/our_turf = get_turf(src)
	var/turf/target_turf = get_turf(target_card)
	if(!our_turf.Adjacent(target_turf))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	switch(action)
		if("mod_access")
			var/access_type = params["access_target"]
			var/try_wildcard = params["access_wildcard"]
			if(access_type in access)
				remove_access(list(access_type))
				LOG_ID_ACCESS_CHANGE(usr, src, "removed [SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(!(access_type in target_card.access))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!can_add_wildcards(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!add_access(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(access_type in ACCESS_ALERT_ADMINS)
				message_admins("[ADMIN_LOOKUPFLW(usr)] just added [SSid_access.get_access_desc(access_type)] to an ID card [ADMIN_VV(src)] [(registered_name) ? "belonging to [registered_name]." : "with no registered name."]")
			LOG_ID_ACCESS_CHANGE(usr, src, "added [SSid_access.get_access_desc(access_type)]")
			return TRUE

/obj/item/card/id/advanced/chameleon/attack_self(mob/user)
	if(isliving(user) && user.mind)
		var/popup_input = tgui_input_list(user, "Choose Action", "Agent ID", list("Show", "Forge/Reset", "Impersonate Crew", "Change Account ID", "Update Photo"))
		if(user.incapacitated())
			return
		if(!user.is_holding(src))
			return
		switch(popup_input)
			if("Show")
				return ..()
			if("Forge/Reset")
				if(!forged)
					var/input_name = tgui_input_text(user, "What name would you like to put on this card? Leave blank to randomise.", "Agent card name", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name), MAX_NAME_LEN)
					input_name = sanitize_name(input_name)
					if(!input_name)
						// Invalid/blank names give a randomly generated one.
						if(user.gender == MALE)
							input_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
						else if(user.gender == FEMALE)
							input_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
						else
							input_name = "[pick(GLOB.first_names)] [pick(GLOB.last_names)]"

					registered_name = input_name

					var/change_trim = tgui_alert(user, "Adjust the appearance of your card's trim?", "Modify Trim", list("Yes", "No"))
					if(change_trim == "Yes")
						var/list/blacklist = typecacheof(list(
							type,
							/obj/item/card/id/advanced/simple_bot,
						))
						var/list/trim_list = list()
						for(var/trim_path in typesof(/datum/id_trim))
							if(blacklist[trim_path])
								continue

							var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[trim_path]

							if(trim && trim.trim_state && trim.assignment)
								var/fake_trim_name = "[trim.assignment] ([trim.trim_state])"
								trim_list[fake_trim_name] = trim_path

						var/selected_trim_path = tgui_input_list(user, "Select trim to apply to your card.\nNote: This will not grant any trim accesses.", "Forge Trim", sort_list(trim_list, GLOBAL_PROC_REF(cmp_typepaths_asc)))
						if(selected_trim_path)
							SSid_access.apply_trim_to_chameleon_card(src, trim_list[selected_trim_path])

					var/target_occupation = tgui_input_text(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels.", "Agent card job assignment", assignment ? assignment : "Assistant")
					if(target_occupation)
						assignment = target_occupation

					var/new_age = tgui_input_number(user, "Choose the ID's age", "Agent card age", AGE_MIN, AGE_MAX, AGE_MIN)
					if(QDELETED(user) || QDELETED(src) || !user.canUseTopic(user, USE_CLOSE|USE_DEXTERITY|USE_IGNORE_TK))
						return
					if(new_age)
						registered_age = new_age

					if(tgui_alert(user, "Activate wallet ID spoofing, allowing this card to force itself to occupy the visible ID slot in wallets?", "Wallet ID Spoofing", list("Yes", "No")) == "Yes")
						ADD_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)

					if(tgui_alert(user, "Create new DNA, Fingerprints, and Blood Type?", "DNA Spoofing", list("Yes", "No")) == "Yes")
						dna_hash = md5("[rand(1,999)]")
						fingerprint = md5("[rand(1,999)]")
						blood_type = random_blood_type()

					else if(tgui_alert(user, "Use real fingerprint?", "Forge ID", list("Yes", "No")) == "Yes")
						var/mob/living/carbon/human/H = user
						if(istype(H))
							fingerprint = H.get_fingerprints(TRUE)

					update_label()
					update_icon()
					forged = TRUE
					to_chat(user, span_notice("You successfully forge the ID card."))
					log_game("[key_name(user)] has forged \the [initial(name)] with name \"[registered_name]\", occupation \"[assignment]\" and trim \"[trim?.assignment]\".")

					if(!registered_account)
						if(ishuman(user))
							var/mob/living/carbon/human/accountowner = user

							var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[accountowner.account_id]"]
							if(account)
								account.bank_cards += src
								registered_account = account
								to_chat(user, span_notice("Your account number has been automatically assigned."))
					return

				if(forged)
					registered_name = initial(registered_name)
					assignment = initial(assignment)
					SSid_access.remove_trim_from_chameleon_card(src)
					REMOVE_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)
					log_game("[key_name(user)] has reset \the [initial(name)] named \"[src]\" to default.")
					update_label()
					update_icon()
					forged = FALSE
					to_chat(user, span_notice("You successfully reset the ID card."))
					return

			if ("Change Account ID")
				set_new_account(user)
				return

			if("Impersonate Crew")
				var/list/options = list()
				for(var/datum/data/record/R as anything in SSdatacore.get_records(DATACORE_RECORDS_STATION))
					options += R.fields[DATACORE_NAME]
				var/choice = tgui_input_list(user, "Select a crew member", "Impersonate Crew", options)
				if(!choice)
					return
				var/datum/data/record/R = SSdatacore.get_record_by_name(choice, DATACORE_RECORDS_LOCKED)
				set_data_by_record(R, visual = TRUE)
				set_icon(R)
				return

			if("Update Photo")
				set_icon(null, user)
				return

/// A special variant of the classic chameleon ID card which accepts all access.
/obj/item/card/id/advanced/chameleon/black
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/engioutpost
	registered_name = "George 'Plastic' Miller"
	desc = "A card used to provide ID and determine access across the station. There's blood dripping from the corner. Ew."
	trim = /datum/id_trim/engioutpost
	registered_age = 47

/obj/item/card/id/advanced/simple_bot
	name = "simple bot ID card"
	desc = "An internal ID card used by the station's non-sentient bots. You should report this to a coder if you're holding it."
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/red
	name = "Red Team identification card"
	desc = "A card used to identify members of the red team for CTF"
	icon_state = "ctf_red"

/obj/item/card/id/blue
	name = "Blue Team identification card"
	desc = "A card used to identify members of the blue team for CTF"
	icon_state = "ctf_blue"

/obj/item/card/id/yellow
	name = "Yellow Team identification card"
	desc = "A card used to identify members of the yellow team for CTF"
	icon_state = "ctf_yellow"

/obj/item/card/id/green
	name = "Green Team identification card"
	desc = "A card used to identify members of the green team for CTF"
	icon_state = "ctf_green"

#undef INTERN_THRESHOLD_FALLBACK_HOURS
#undef ID_ICON_BORDERS
