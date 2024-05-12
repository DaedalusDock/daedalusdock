/**
 * Udder component; for farm animals to generate milk.
 *
 * Used for cows, goats, gutlunches. neat!
 */
/datum/component/udder
	///abstract item for managing reagents (further down in this file)
	var/obj/item/udder/udder
	///optional proc to callback to when the udder is milked
	var/datum/callback/on_milk_callback

//udder_type and reagent_produced_typepath are typepaths, not reference
/datum/component/udder/Initialize(udder_type = /obj/item/udder, datum/callback/on_milk_callback, datum/callback/on_generate_callback, reagent_produced_typepath = /datum/reagent/consumable/milk)
	if(!isliving(parent)) //technically is possible to drop this on carbons... but you wouldn't do that to me, would you?
		return COMPONENT_INCOMPATIBLE
	udder = new udder_type(null, parent, on_generate_callback, reagent_produced_typepath)
	src.on_milk_callback = on_milk_callback

/datum/component/udder/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))

/datum/component/udder/UnregisterFromParent()
	QDEL_NULL(udder)
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_PARENT_ATTACKBY))

///signal called on parent being examined
/datum/component/udder/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/mob/living/milked = parent
	if(milked.stat != CONSCIOUS)
		return //come on now

	var/udder_filled_percentage = PERCENT(udder.reagents.total_volume / udder.reagents.maximum_volume)
	switch(udder_filled_percentage)
		if(0 to 10)
			examine_list += span_notice("[parent]'s [udder] is dry.")
		if(11 to 99)
			examine_list += span_notice("[parent]'s [udder] can be milked if you have something to contain it.")
		if(100)
			examine_list += span_notice("[parent]'s [udder] is round and full, and can be milked if you have something to contain it.")


///signal called on parent being attacked with an item
/datum/component/udder/proc/on_attackby(datum/source, obj/item/milking_tool, mob/user)
	SIGNAL_HANDLER

	var/mob/living/milked = parent
	if(milked.stat == CONSCIOUS && istype(milking_tool, /obj/item/reagent_containers/glass))
		udder.milk(milking_tool, user)
		if(on_milk_callback)
			on_milk_callback.Invoke(udder.reagents.total_volume, udder.reagents.maximum_volume)
		return COMPONENT_NO_AFTERATTACK

/**
 * # udder item
 *
 * Abstract item that is held in nullspace and manages reagents. Created by udder component.
 * While perhaps reagents created by udder component COULD be managed in the mob, it would be somewhat finnicky and I actually like the abstract udders.
 */
/obj/item/udder
	name = "udder"
	///typepath of reagent produced by the udder
	var/reagent_produced_typepath = /datum/reagent/consumable/milk
	///how much the udder holds
	var/size = 50
	///mob that has the udder component
	var/mob/living/udder_mob
	///optional proc to callback to when the udder generates milk
	var/datum/callback/on_generate_callback

/obj/item/udder/Initialize(mapload, udder_mob, on_generate_callback, reagent_produced_typepath = /datum/reagent/consumable/milk)
	src.udder_mob = udder_mob
	src.on_generate_callback = on_generate_callback
	create_reagents(size)
	src.reagent_produced_typepath = reagent_produced_typepath
	initial_conditions()
	. = ..()

/obj/item/udder/Destroy()
	STOP_PROCESSING(SSobj, src)
	udder_mob = null
	return ..()

/obj/item/udder/process(delta_time)
	if(udder_mob.stat != DEAD)
		generate() //callback is on generate() itself as sometimes generate does not add new reagents, or is not called via process

/**
 * Proc called on creation separate from the reagent datum creation to allow for signalled milk generation instead of processing milk generation
 * also useful for changing initial amounts in reagent holder (cows start with milk, gutlunches start empty)
 */
/obj/item/udder/proc/initial_conditions()
	reagents.add_reagent(reagent_produced_typepath, 20)
	START_PROCESSING(SSobj, src)

/**
 * Proc called every 2 seconds from SSMobs to add whatever reagent the udder is generating.
 */
/obj/item/udder/proc/generate()
	if(prob(5))
		reagents.add_reagent(reagent_produced_typepath, rand(5, 10))
		if(on_generate_callback)
			on_generate_callback.Invoke(reagents.total_volume, reagents.maximum_volume)

/**
 * Proc called from attacking the component parent with the correct item, moves reagents into the glass basically.
 *
 * Arguments:
 * * obj/item/reagent_containers/glass/milk_holder - what we are trying to transfer the reagents to
 * * mob/user - who is trying to do this
 */
/obj/item/udder/proc/milk(obj/item/reagent_containers/glass/milk_holder, mob/user)
	if(milk_holder.reagents.total_volume >= milk_holder.volume)
		to_chat(user, span_warning("[milk_holder] is full."))
		return
	var/transfered = reagents.trans_to(milk_holder, rand(5,10))
	if(transfered)
		user.visible_message(span_notice("[user] milks [src] using \the [milk_holder]."), span_notice("You milk [src] using \the [milk_holder]."))
	else
		to_chat(user, span_warning("The udder is dry. Wait a bit longer..."))

/**
 * Slug "udders". I'm so sorry it has to be this way
*/
/obj/item/udder/slug
	name = "slime gland"

/obj/item/udder/slug/initial_conditions()
	. = ..()
	RegisterSignal(udder_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_slug_move))

/obj/item/udder/slug/proc/on_slug_move()
	SIGNAL_HANDLER

	if (reagents.total_volume <= 0)
		return //no slime :(
	var/turf/slug_turf = get_turf(udder_mob)
	if(!slug_turf)
		return
	slug_turf.wash(CLEAN_SCRUB)
	reagents.expose(slug_turf, TOUCH, 5)
	reagents.remove_all(5)
