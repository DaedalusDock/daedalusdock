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
