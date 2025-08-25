
/obj/item/instrument/piano_synth
	name = "synthesizer"
	desc = "An advanced electronic synthesizer that can be used as various instruments."
	icon_state = "synth"
	inhand_icon_state = "synth"
	allowed_instrument_ids = "piano"

/obj/item/instrument/piano_synth/Initialize(mapload)
	. = ..()
	song.allowed_instrument_ids = SSinstruments.synthesizer_instrument_ids

/obj/item/instrument/piano_synth/headphones
	name = "headphones"
	desc = "Unce unce unce unce. Boop!"
	icon = 'icons/obj/clothing/accessories.dmi'
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	icon_state = "headphones"
	inhand_icon_state = "headphones"
	slot_flags = ITEM_SLOT_EARS | ITEM_SLOT_HEAD | ITEM_SLOT_NECK
	force = 0
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_ASSISTANT * 2.5
	instrument_range = 1
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/instrument/piano_synth/headphones/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	RegisterSignal(src, COMSIG_INSTRUMENT_START, PROC_REF(start_playing))
	RegisterSignal(src, COMSIG_INSTRUMENT_END, PROC_REF(stop_playing))

/**
 * Called by a component signal when our song starts playing.
 */
/obj/item/instrument/piano_synth/headphones/proc/start_playing()
	SIGNAL_HANDLER
	icon_state = "[initial(icon_state)]_on"
	update_appearance()

/**
 * Called by a component signal when our song stops playing.
 */
/obj/item/instrument/piano_synth/headphones/proc/stop_playing()
	SIGNAL_HANDLER
	icon_state = "[initial(icon_state)]"
	update_appearance()

/obj/item/instrument/piano_synth/headphones/spacepods
	name = "\improper Nanotrasen space pods"
	desc = "Flex your money, AND ignore what everyone else says, all at once!"
	icon_state = "spacepods"
	inhand_icon_state = "spacepods"
	slot_flags = ITEM_SLOT_EARS
	strip_delay = 100 //air pods don't fall out
	instrument_range = 0 //you're paying for quality here
	custom_premium_price = PAYCHECK_ASSISTANT * 36 //Save up 5 shifts worth of pay just to lose it down a drainpipe on the sidewalk
	supports_variations_flags = NONE
