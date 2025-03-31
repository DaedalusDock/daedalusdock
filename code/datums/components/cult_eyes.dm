/**
 * # Cult eyes element
 *
 * Applies and removes the glowing cult eyes
 */
/datum/component/cult_eyes
	dupe_mode = COMPONENT_DUPE_SOURCES
	var/initial_right_color = ""
	var/initial_left_color = ""

/datum/component/cult_eyes/Initialize(initial_delay = 20 SECONDS)
	. = ..()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		initial_right_color = human_parent.eye_color_right
		initial_left_color = human_parent.eye_color_left

	// Register signals for mob transformation to prevent premature halo removal
	RegisterSignal(parent, list(COMSIG_CHANGELING_TRANSFORM, COMSIG_MONKEY_HUMANIZE, COMSIG_HUMAN_MONKEYIZE), PROC_REF(set_eyes))
	addtimer(CALLBACK(src, PROC_REF(set_eyes)), initial_delay)

/**
 * Cult eye setter proc
 *
 * Changes the eye color, and adds the glowing eye trait to the mob.
 */
/datum/component/cult_eyes/proc/set_eyes()
	SIGNAL_HANDLER

	ADD_TRAIT(parent, TRAIT_UNNATURAL_RED_GLOWY_EYES, CULT_TRAIT)
	if (ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		human_parent.eye_color_left = BLOODCULT_EYE
		human_parent.eye_color_right = BLOODCULT_EYE
		human_parent.dna.update_ui_block(DNA_EYE_COLOR_LEFT_BLOCK)
		human_parent.dna.update_ui_block(DNA_EYE_COLOR_RIGHT_BLOCK)
		human_parent.update_eyes()

/**
 * Detach proc
 *
 * Removes the eye color, and trait from the mob
 */
/datum/component/cult_eyes/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_UNNATURAL_RED_GLOWY_EYES, CULT_TRAIT)
	if (ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		human_parent.eye_color_left = initial_left_color
		human_parent.eye_color_right = initial_right_color
		human_parent.dna.update_ui_block(DNA_EYE_COLOR_LEFT_BLOCK)
		human_parent.dna.update_ui_block(DNA_EYE_COLOR_RIGHT_BLOCK)
		human_parent.update_eyes()
	UnregisterSignal(parent, list(COMSIG_CHANGELING_TRANSFORM, COMSIG_HUMAN_MONKEYIZE, COMSIG_MONKEY_HUMANIZE))
