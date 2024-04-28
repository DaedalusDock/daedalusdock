/**
 * # engraved component!
 *
 * MUST be a component, though it doesn't look like it. SSPersistence demandeth
 */
/datum/component/engraved
	///the generated string
	var/engraved_description
	///whether this is a new engraving, or a persistence loaded one.
	var/persistent_save
	///what random icon state should the engraving have
	var/icon_state_append

/datum/component/engraved/Initialize(engraved_description, persistent_save)
	. = ..()
	var/turf/engraved_turf = parent

	src.engraved_description = engraved_description
	src.persistent_save = persistent_save

	icon_state_append = rand(1, 4)
	//must be here to allow overlays to be updated
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	engraved_turf.update_appearance()

/datum/component/engraved/Destroy(force, silent)
	if(!parent)
		return ..()
	parent.RemoveElement(/datum/element/art)
	//must be here to allow overlays to be updated
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS)
	if(!QDELING(parent))
		var/atom/parent_atom = parent
		parent_atom.update_appearance()
	return ..() //call this after since we null out the parent

/datum/component/engraved/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_WELDER), PROC_REF(on_tool_act))
	//supporting component transfer means putting these here instead of initialize
	SSpersistence.wall_engravings += src
	ADD_TRAIT(parent, TRAIT_NOT_ENGRAVABLE, TRAIT_GENERIC)

/datum/component/engraved/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_WELDER))
	//supporting component transfer means putting these here instead of destroy
	SSpersistence.wall_engravings -= src
	REMOVE_TRAIT(parent, TRAIT_NOT_ENGRAVABLE, TRAIT_GENERIC)

/// Used to maintain the acid overlay on the parent [/atom].
/datum/component/engraved/proc/on_update_overlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER

	overlays += mutable_appearance('icons/effects/writing.dmi', "writing[icon_state_append]")

///signal called on parent being examined
/datum/component/engraved/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_boldnotice(engraved_description)
	examine_list += span_notice("You can probably get this out with a <b>welding tool</b>.")

/datum/component/engraved/proc/on_tool_act(datum/source, mob/user, obj/item/tool)
	SIGNAL_HANDLER
	set waitfor = FALSE //Do not remove without removing the UNLINT below

	. = COMPONENT_BLOCK_TOOL_ATTACK
	to_chat(user, span_notice("You begin to remove the engraving on [parent]."))
	if(UNLINT(do_after(user, parent, 4 SECONDS, DO_PUBLIC, display = tool)))
		to_chat(user, span_notice("You remove the engraving on [parent]."))
		qdel(src)

///returns all the information SSpersistence needs in a list to load up this engraving on a future round!
/datum/component/engraved/proc/save_persistent()
	var/list/saved_data = list()
	saved_data["story"] = engraved_description

	return list(saved_data)

