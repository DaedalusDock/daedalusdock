/datum/round_event_control/wizard/rpgloot //its time to minmax your shit
	name = "RPG Loot"
	weight = 3
	typepath = /datum/round_event/wizard/rpgloot
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/wizard/rpgloot/start()
	GLOB.rpgloot_controller = new /datum/rpgloot_controller

/obj/item/upgradescroll
	name = "item fortification scroll"
	desc = "Somehow, this piece of paper can be applied to items to make them \"better\". Apparently there's a risk of losing the item if it's already \"too good\". <i>This all feels so arbitrary...</i>"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	worn_icon_state = "scroll"
	w_class = WEIGHT_CLASS_TINY

	var/upgrade_amount = 1
	var/can_backfire = TRUE
	var/uses = 1

/obj/item/upgradescroll/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	interacting_with.AddComponent(/datum/component/fantasy, upgrade_amount, null, null, can_backfire, TRUE)

	uses -= 1
	if(!uses)
		visible_message(span_warning("[src] vanishes, its magic completely consumed from the fortification."))
		qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/upgradescroll/unlimited
	name = "unlimited foolproof item fortification scroll"
	desc = "Somehow, this piece of paper can be applied to items to make them \"better\". This scroll is made from the tongues of dead paper wizards, and can be used an unlimited number of times, with no drawbacks."
	uses = INFINITY
	can_backfire = FALSE

///Holds the global datum for rpgloot, so anywhere may check for its existence (it signals into whatever it needs to modify, so it shouldn't require fetching)
GLOBAL_DATUM(rpgloot_controller, /datum/rpgloot_controller)

/**
 * ## rpgloot controller!
 *
 * Stored in a global datum, and created when rpgloot is turned on via event or VV'ing the GLOB.rpgloot_controller to be a new /datum/rpgloot_controller.
 * Makes every item in the world fantasy, but also hooks into global signals for new items created to also bless them with fantasy.
 *
 * What do I mean by fantasy?
 * * Items will have random qualities assigned to them
 * * Good quality items will have positive buffs/special powers applied to them
 * * Bad quality items will get the opposite!
 * * All of this is reflected in a fitting name for the item
 * * See fantasy.dm and read the component for more information :)
 */
/datum/rpgloot_controller

/datum/rpgloot_controller/New()
	. = ..()
	//second operation takes MUCH longer, so lets set up signals first.
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_ITEM, PROC_REF(on_new_item_in_existence))
	handle_current_items()

///signal sent by a new item being created.
/datum/rpgloot_controller/proc/on_new_item_in_existence(datum/source, obj/item/created_item)
	SIGNAL_HANDLER

	created_item.AddComponent(/datum/component/fantasy)

/**
 * ### handle_current_items
 *
 * Gives every viable item in the world the fantasy component.
 * If the item it is giving fantasy to is a storage item, there's a chance it'll drop in an item fortification scroll. neat!
 */
/datum/rpgloot_controller/proc/handle_current_items()
	var/upgrade_scroll_chance = 0
	for(var/obj/item/fantasy_item in world)
		CHECK_TICK

		if(!fantasy_item.initialized || QDELETED(fantasy_item))
			continue

		fantasy_item.AddComponent(/datum/component/fantasy)

		if(istype(fantasy_item, /obj/item/storage))
			var/obj/item/storage/storage_item = fantasy_item
			var/datum/storage/storage_component = storage_item.atom_storage
			if(prob(upgrade_scroll_chance) && storage_item.contents.len < storage_component.max_slots && !storage_item.invisibility)
				var/obj/item/upgradescroll/scroll = new(get_turf(storage_item))
				storage_item.atom_storage?.attempt_insert(scroll, override = TRUE)
				upgrade_scroll_chance = max(0,upgrade_scroll_chance-100)
				if(isturf(scroll.loc))
					qdel(scroll)

			upgrade_scroll_chance += 25
