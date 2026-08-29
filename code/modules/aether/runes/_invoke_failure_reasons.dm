// Structs, never actually instanced.
/datum/ritual_failure
	var/desc = ""

/// Graceful failure such as the rune being qdeleted. This has NO SIDE EFFECTS.
/datum/ritual_failure/graceful

/// Invoker became incapacitated.
/datum/ritual_failure/invoker_incap

/// Helper removed their hand.
/datum/ritual_failure/helper_hand_removed
	desc = "a helper removed their hand"

/// The target mob moved.
/datum/ritual_failure/target_mob_moved
	desc = "the subject moved"

/// The target mob stood up.
/datum/ritual_failure/target_mob_getup
	desc = "the subject getting up off the floor"

/// Invoker isn't holding the tome.
/datum/ritual_failure/tome_gone
	desc = "you are not holding the tome"

/// Target item moved out of range.
/datum/ritual_failure/target_item_range
	desc = "a component moved outside of the ring"

/// Not enough helpers
/datum/ritual_failure/few_helpers
	desc = "there are too few helpers"

/// No target mob
/datum/ritual_failure/no_target_mob
	desc = "there is no subject to perform on"

/// Ritual requires blood and there ain't enough
/datum/ritual_failure/not_enough_blood
	desc = "there is not enough blood being sacrificed"

/// Invoker is mute
/datum/ritual_failure/invoker_cannot_speak
	desc = "you are unable to perform the chant"

/// HE'S ALIIIIIVE
/datum/ritual_failure/revival/target_alive
	desc = "the subject is alive"

/// No heart for the revival
/datum/ritual_failure/revival/no_heart
	desc = "there is no heart being sacrificed"

/// Heart is dead
/datum/ritual_failure/revival/dead_heart
	desc = "the heart has no life essence"

/// Woundseal isn't potent enough
/datum/ritual_failure/revival/woundseal_potency
	desc = "the woundseal tincture is not potent enough"

/// Not enough woundseal
/datum/ritual_failure/revival/woundseal_amount
	desc = "there is not enough woundseal being sacrificed"

/// No tinctures found
/datum/ritual_failure/heal/no_tinctures
	desc = "there are no tinctures being sacrificed"

/// No parts found
/datum/ritual_failure/exchange/no_parts
	desc = "there are no organs or parts being exchanged"

/// No reagent containers
/datum/ritual_failure/exanguinate/no_containers
	desc = "there are no vessels to store the blood in"
