TYPEINFO_DEF(/obj/item/clothing/head/fedora/det_hat)
	default_armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, FIRE = 30, ACID = 50)

/obj/item/clothing/head/fedora/det_hat
	name = "private investigator's fedora"
	desc = "A fedora with a thin layer of dust caked on. It smells of candycorn."
	icon_state = "detective"
	dog_fashion = /datum/dog_fashion/head/detective

	var/datum/action/item_action/noir_mode/noir_action
	var/candy_cooldown = 0

/obj/item/clothing/head/fedora/det_hat/Initialize(mapload)
	. = ..()

	noir_action = new(src)
	add_item_action(noir_action)

	create_storage(type = /datum/storage/pockets/small/fedora/detective)

	new /obj/item/reagent_containers/cup/glass/flask/det(src)

/obj/item/clothing/head/fedora/det_hat/examine(mob/user)
	. = ..()
	. += span_info("There is a handful of candycorn inside.")

	var/datum/roll_result/result = user.get_examine_result("dethat_examine", trait_succeed = TRAIT_DICK)
	result.do_skill_sound(user)
	if(result?.outcome >= SUCCESS)
		. += result.create_tooltip("A limited edition <i>Perseus Mávros</i> fedora from before the turn of the century, marked by the now fraying \"P.B\" embroidered onto the brim.", body_only = TRUE)
	else
		. += result.create_tooltip("It looks expensive, like one of those fancy high-end brands produced it.", body_only = TRUE)

/obj/item/clothing/head/fedora/disco_flavor(mob/living/carbon/human/user, nearby, is_station_level)
	. = ..()
	var/datum/roll_result/result = user.get_examine_result("dethat_expensive", trait_succeed = TRAIT_DICK, only_once = TRUE)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		to_chat(
			user,
			result.create_tooltip("This is far out of your price range. Whoever bought this is either very wealthy, or very stupid."),
		)

		if(HAS_TRAIT(user.mind, TRAIT_DICK))
			var/datum/roll_result/det_result = user.get_examine_result("dethat_expensive_detective_shame", 16, /datum/rpg_skill/willpower, only_once = TRUE)
			if(det_result?.outcome <= FAILURE)
				to_chat(
					user,
					det_result.create_tooltip("It was not a wise investment, now was it, mister big shot detective?"),
				)
				user.mob_mood.add_mood_event("det_poorf", /datum/mood_event/poor_idiot)

/obj/item/clothing/head/fedora/det_hat/get_item_credit_value()
	return 200 // It's Perseus Black! Of course it's valuable!

/obj/item/clothing/head/fedora/det_hat/AltClick(mob/user)
	. = ..()
	if(loc != user || !user.canUseTopic(src, USE_CLOSE|USE_DEXTERITY|USE_IGNORE_TK))
		return

	if(candy_cooldown < world.time)
		var/obj/item/food/candy_corn/CC = new /obj/item/food/candy_corn(src)
		user.put_in_hands(CC)
		to_chat(user, span_notice("You slip a candy corn from your hat."))
		candy_cooldown = world.time+1200
	else
		to_chat(user, span_warning("You just took a candy corn! You should wait a couple minutes, lest you burn through your stash."))

/obj/item/clothing/head/fedora/det_hat/item_action_slot_check(slot, mob/user)
	return (slot == ITEM_SLOT_HEAD) && (user.mind?.assigned_role.title == JOB_DETECTIVE)

/datum/action/item_action/noir_mode
	name = "Investigate"

	var/area/station/security/detectives_office/noir_area
	var/list/datum/weakref/noired_mobs = list()

	var/investigating = FALSE

/datum/action/item_action/noir_mode/Remove(mob/remove_from)
	. = ..()
	stop_investigating(remove_from)

/datum/action/item_action/noir_mode/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	if(!investigating)
		start_investigating(usr)
	else
		stop_investigating(usr)

/datum/action/item_action/noir_mode/proc/start_investigating(mob/living/user)
	investigating = TRUE
	user.apply_status_effect(/datum/status_effect/noir)
	RegisterSignal(user, COMSIG_ENTER_AREA, PROC_REF(on_enter_area))

	on_enter_area(null, get_area(user))

/datum/action/item_action/noir_mode/proc/stop_investigating(mob/living/user)
	investigating = FALSE
	user.remove_status_effect(/datum/status_effect/noir)
	UnregisterSignal(user, COMSIG_ENTER_AREA)

	if(noir_area)
		UnregisterSignal(noir_area, COMSIG_AREA_ENTERED)
		noir_area = null

	free_noired_mobs()

/datum/action/item_action/noir_mode/proc/free_noired_mobs()
	for(var/datum/weakref/weakref as anything in noired_mobs)
		var/mob/living/carbon/human/H = weakref.resolve()
		if(H)
			H.remove_status_effect(/datum/status_effect/noir_in_area)

/datum/action/item_action/noir_mode/proc/on_enter_area(datum/source, area/entered)
	SIGNAL_HANDLER

	if(istype(entered, /area/station/security/detectives_office))
		noir_area = entered
		RegisterSignal(noir_area, COMSIG_AREA_ENTERED, PROC_REF(noir_area_entered))

		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(get_area(H) != noir_area)
				continue

			noir_mob(H)


	else if(noir_area)
		free_noired_mobs()
		UnregisterSignal(noir_area, COMSIG_AREA_ENTERED)
		noir_area = null

/datum/action/item_action/noir_mode/proc/noir_area_entered(datum/source, atom/movable/arrived, area/old_area)
	SIGNAL_HANDLER

	if(!ishuman(arrived) || arrived == owner)
		return

	noir_mob(arrived)

/datum/action/item_action/noir_mode/proc/noir_mob(mob/living/carbon/human/H)
	if(H == owner)
		return

	if(!H.apply_status_effect(/datum/status_effect/noir_in_area, noir_area))
		return

	noired_mobs |= WEAKREF(H)
