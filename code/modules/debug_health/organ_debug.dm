/obj/item/organ/proc/get_debug_info()
	. = list()

	if(organ_flags & ORGAN_DEAD)
		if(can_recover())
			. += "Decaying"
		else
			. += "Necrotic (unrecoverable)"


/* HEART INFO */
/obj/item/organ/heart/get_debug_info()
	. = ..()
	switch(pulse)
		if(PULSE_NONE)
			. += "Pulse: NONE"
		if(PULSE_SLOW)
			. += "Pulse: SLOW"
		if(PULSE_NORM)
			. += "Pulse: NORMAL"
		if(PULSE_FAST)
			. += "Pulse: FAST"
		if(PULSE_2FAST)
			. += "Pulse: 2FAST"
		if(PULSE_THREADY)
			. += "Pulse: HEARTATTACK READY"

	if(pulse == PULSE_NONE && !(organ_flags & ORGAN_SYNTHETIC))
		. += "Asystole"


/* BRAIN INFO */
/obj/item/organ/brain/get_debug_info()
	. = ..()
	. += "Oxygen Reserve: [oxygen_reserve]"
