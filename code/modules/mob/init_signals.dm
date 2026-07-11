/// Called on [/mob/Initialize(mapload)], for the mob to register to relevant signals.
/mob/proc/register_init_signals()
	SHOULD_CALL_PARENT(TRUE)

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_DIAGNOSTIC_HUD), PROC_REF(on_diagnostic_hud_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_DIAGNOSTIC_HUD), PROC_REF(on_diagnostic_hud_loss))

/mob/proc/on_diagnostic_hud_gain(datum/source)
	SIGNAL_HANDLER

	SSpackets.add_packet_viewer(src)

/mob/proc/on_diagnostic_hud_loss(datum/source)
	SIGNAL_HANDLER

	SSpackets.remove_packet_viewer(src)
