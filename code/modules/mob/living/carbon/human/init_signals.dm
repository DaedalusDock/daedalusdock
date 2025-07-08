//Called on /mob/living/carbon/Initialize(mapload), for the carbon mobs to register relevant signals.
/mob/living/carbon/human/register_init_signals()
	. = ..()
	RegisterSignal(src, \
		list(
			SIGNAL_ADDTRAIT(TRAIT_INVISIBLE_MAN),
			SIGNAL_REMOVETRAIT(TRAIT_INVISIBLE_MAN),
			SIGNAL_ADDTRAIT(TRAIT_DISFIGURED),
			SIGNAL_REMOVETRAIT(TRAIT_DISFIGURED),
		),\
		PROC_REF(signal_update_name))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_JAUNDICE_SKIN), PROC_REF(on_jaundice_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_JAUNDICE_SKIN), PROC_REF(on_jaundice_loss))
	RegisterSignal(src, COMSIG_ATOM_CONTENTS_WEIGHT_CLASS_CHANGED, PROC_REF(check_pocket_weight))

/mob/living/carbon/human/proc/signal_update_name(datum/source)
	SIGNAL_HANDLER
	update_appearance(UPDATE_NAME)

/// Called when TRAIT_JAUNDICE_SKIN is gained.
/mob/living/carbon/human/proc/on_jaundice_gain(datum/source)
	SIGNAL_HANDLER

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!BP.can_be_jaundiced())
			continue

		BP.add_color_override("#f4e97f", LIMB_COLOR_JAUNDICE)

	update_body_parts()

/// Called when TRAIT_JAUNDICE_SKIN is lost.
/mob/living/carbon/human/proc/on_jaundice_loss(datum/source)
	SIGNAL_HANDLER


	for(var/obj/item/bodypart/BP as anything in bodyparts)
		BP.remove_color_override(LIMB_COLOR_JAUNDICE)

	update_body_parts()


/// Signal proc for [COMSIG_ATOM_CONTENTS_WEIGHT_CLASS_CHANGED] to check if an item is suddenly too heavy for our pockets
/mob/living/carbon/human/proc/check_pocket_weight(datum/source, obj/item/changed, old_w_class, new_w_class)
	SIGNAL_HANDLER
	if(changed != r_store && changed != l_store)
		return

	if(new_w_class <= POCKET_WEIGHT_CLASS)
		return

	if(!dropItemToGround(changed, force = TRUE))
		return

	visible_message(
		span_warning("[changed] falls out of <b>[src]</b>'s pockets."),
		blind_message = span_hear("You hear an object hit the floor."),
		vision_distance = COMBAT_MESSAGE_RANGE,
	)

	playsound(src, SFX_RUSTLE, 50, TRUE, -5, frequency = 0.8)
