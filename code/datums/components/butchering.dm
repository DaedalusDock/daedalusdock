/datum/component/butchering
	/// Time in deciseconds taken to butcher something
	var/speed = 8 SECONDS
	/// Percentage effectiveness; numbers above 100 yield extra drops
	var/effectiveness = 100
	/// Percentage increase to bonus item chance
	var/bonus_modifier = 0
	/// Sound played when butchering
	var/butcher_sound = 'sound/effects/butcher.ogg'
	/// Whether or not this component can be used to butcher currently. Used to temporarily disable butchering
	var/butchering_enabled = TRUE
	/// Whether or not this component is compatible with blunt tools.
	var/can_be_blunt = FALSE
	/// Callback for butchering
	var/datum/callback/butcher_callback

/datum/component/butchering/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt, _butcher_callback)
	if(_speed)
		speed = _speed
	if(_effectiveness)
		effectiveness = _effectiveness
	if(_bonus_modifier)
		bonus_modifier = _bonus_modifier
	if(_butcher_sound)
		butcher_sound = _butcher_sound
	if(disabled)
		butchering_enabled = FALSE
	if(_can_be_blunt)
		can_be_blunt = _can_be_blunt
	if(_butcher_callback)
		butcher_callback = _butcher_callback

	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(onItemAttack))

/datum/component/butchering/proc/onItemAttack(obj/item/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(!isliving(interacting_with))
		return NONE

	var/mob/living/M = interacting_with

	if(M.stat == DEAD && (M.butcher_results || M.guaranteed_butcher_results)) //can we butcher it?
		if(butchering_enabled && (can_be_blunt || (source.sharpness & SHARP_EDGED)))
			INVOKE_ASYNC(src, PROC_REF(startButcher), source, M, user)
			return ITEM_INTERACT_SUCCESS

/datum/component/butchering/proc/startButcher(obj/item/source, mob/living/M, mob/living/user)
	to_chat(user, span_notice("You begin to butcher [M]..."))
	playsound(M.loc, butcher_sound, 50, TRUE, -1)
	if(do_after(user, M, speed, DO_PUBLIC, display = parent) && M.Adjacent(source))
		Butcher(user, M)

/**
 * Handles a user butchering a target
 *
 * Arguments:
 * - [butcher][/mob/living]: The mob doing the butchering
 * - [meat][/mob/living]: The mob being butchered
 */
/datum/component/butchering/proc/Butcher(mob/living/butcher, mob/living/meat)
	var/list/results = list()
	var/turf/T = meat.drop_location()
	var/final_effectiveness = effectiveness - meat.butcher_difficulty
	var/bonus_chance = max(0, (final_effectiveness - 100) + bonus_modifier) //so 125 total effectiveness = 25% extra chance
	for(var/V in meat.butcher_results)
		var/obj/bones = V
		var/amount = meat.butcher_results[bones]
		for(var/_i in 1 to amount)
			if(!prob(final_effectiveness))
				if(butcher)
					to_chat(butcher, span_warning("You fail to harvest some of the [initial(bones.name)] from [meat]."))
				continue

			if(prob(bonus_chance))
				if(butcher)
					to_chat(butcher, span_info("You harvest some extra [initial(bones.name)] from [meat]!"))
				results += new bones (T)
			results += new bones (T)

		meat.butcher_results.Remove(bones) //in case you want to, say, have it drop its results on gib

	for(var/V in meat.guaranteed_butcher_results)
		var/obj/sinew = V
		var/amount = meat.guaranteed_butcher_results[sinew]
		for(var/i in 1 to amount)
			results += new sinew (T)
		meat.guaranteed_butcher_results.Remove(sinew)

	for(var/obj/item/carrion in results)
		var/list/meat_mats = carrion.has_material_type(/datum/material/meat)
		if(!length(meat_mats))
			continue
		carrion.set_custom_materials((carrion.custom_materials - meat_mats) + list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, meat) = counterlist_sum(meat_mats)))

	if(butcher)
		butcher.visible_message(span_notice("[butcher] butchers [meat]."), \
								span_notice("You butcher [meat]."))
	butcher_callback?.Invoke(butcher, meat)
	meat.harvest(butcher)
	meat.gib(FALSE, FALSE, TRUE)

///Special snowflake component only used for the recycler.
/datum/component/butchering/recycler


/datum/component/butchering/recycler/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(!istype(parent, /obj/machinery/recycler)) //EWWW
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddComponent(/datum/component/connect_loc_behalf, parent, loc_connections)

/datum/component/butchering/recycler/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(arrived == parent)
		return
	if(!isliving(arrived))
		return
	var/mob/living/victim = arrived
	var/obj/machinery/recycler/eater = parent
	if(eater.safety_mode || (eater.machine_stat & (BROKEN|NOPOWER))) //I'm so sorry.
		return
	if(victim.stat == DEAD && (victim.butcher_results || victim.guaranteed_butcher_results))
		Butcher(parent, victim)
