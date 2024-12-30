/obj/item/organ/ipc_screen
	name = "ipc screen"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "ipc_screen"
	preference = "ipc_screen"

	dna_block = DNA_IPC_SCREEN_BLOCK

	actions_types = list(/datum/action/innate/ipc_screen_change)

/obj/item/organ/ipc_screen/get_global_feature_list()
	return GLOB.ipc_screens_list

/obj/item/organ/ipc_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	return human.is_face_visible()

/datum/action/innate/ipc_screen_change
	name = "Change Screen"
	desc = "Change your display's image."
	var/obj/item/organ/ipc_screen/screen

/datum/action/innate/ipc_screen_change/New(Target)
	. = ..()
	screen = Target

/datum/action/innate/ipc_screen_change/Destroy()
	screen = null
	return ..()

/datum/action/innate/ipc_screen_change/Activate()
	var/mob/living/carbon/C = owner
	if(C.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))
		to_chat(C, span_warning("You can't do that right now."))
		return
	var/input = tgui_input_list(C, "Select Screen", "IPC Screen", screen.get_global_feature_list())
	if(C.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))
		to_chat(C, span_warning("You can't do that right now."))
		return

	screen.set_sprite(input)
	C.update_body_parts()

/obj/item/organ/ipc_antenna
	name = "ipc antenna"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_ANTENNA
	layers = list(BODY_ADJ_LAYER)

	feature_key = "ipc_antenna"
	preference = "ipc_antenna"

	dna_block = DNA_IPC_ANTENNA_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_IPC_ANTENNA

/obj/item/organ/ipc_antenna/get_global_feature_list()
	return GLOB.ipc_antenna_list

/obj/item/organ/ipc_antenna/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/saurian_screen
	name = "saurian ipc screen"
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SAURIAN_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "saurian_screen"
	preference = "saurian_screen"

	dna_block = DNA_SAURIAN_SCREEN_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_GENERIC

/obj/item/organ/saurian_screen/get_global_feature_list()
	return GLOB.saurian_screens_list

/obj/item/organ/saurian_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDESNOUT))
		return TRUE
	return FALSE

/obj/item/organ/saurian_screen/build_overlays(physique, image_dir)
	. = ..()

	for(var/image_layer in layers)
		var/state2use = build_icon_state(physique, image_layer)

		if(!icon_exists(sprite_datum.icon, "[state2use]_secondary", FALSE))
			continue
		var/image/secondary = image(sprite_datum.icon, "[state2use]_secondary")
		secondary.color = mutcolors[MUTCOLORS_GENERIC_2]
		. += secondary

	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	var/image/I = image(sprite_datum.icon, "eyes", layer = -EYE_LAYER)
	I.color = H.eye_color_left
	. += I
	. += emissive_appearance(sprite_datum.icon, "eyes", -EYE_LAYER, alpha = 90)

/obj/item/organ/saurian_tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_TAIL
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	feature_key = "saurian_tail"
	dna_block = DNA_SAURIAN_TAIL_BLOCK

/obj/item/organ/saurian_tail/get_global_feature_list()
	return GLOB.saurian_tails_list

/obj/item/organ/saurian_scutes
	name = "scutes"
	organ_flags = ORGAN_UNREMOVABLE

	visual = TRUE
	cosmetic_only = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SAURIAN_SCUTES
	layers = list(BODY_ADJ_LAYER)
	feature_key = "saurian_scutes"
	dna_block = DNA_SAURIAN_SCUTES_BLOCK

	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_GENERIC
	mutcolor_index = 3

/obj/item/organ/saurian_scutes/get_global_feature_list()
	return GLOB.saurian_scutes_list

/obj/item/organ/saurian_screen
	name = "saurian ipc screen"
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SAURIAN_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "saurian_screen"
	preference = "saurian_screen"

	dna_block = DNA_SAURIAN_SCREEN_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_GENERIC

/obj/item/organ/saurian_screen/get_global_feature_list()
	return GLOB.saurian_screens_list

/obj/item/organ/saurian_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDESNOUT))
		return TRUE
	return FALSE

/obj/item/organ/saurian_screen/build_overlays(physique, image_dir)
	. = ..()

	for(var/image_layer in layers)
		var/state2use = build_icon_state(physique, image_layer)

		if(!icon_exists(sprite_datum.icon, "[state2use]_secondary", FALSE))
			continue
		var/image/secondary = image(sprite_datum.icon, "[state2use]_secondary")
		secondary.color = mutcolors[MUTCOLORS_GENERIC_2]
		. += secondary

	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	var/image/I = image(sprite_datum.icon, "eyes", layer = -EYE_LAYER)
	I.color = H.eye_color_left
	. += I
	. += emissive_appearance(sprite_datum.icon, "eyes", -EYE_LAYER, alpha = 90)


/obj/item/organ/saurian_antenna
	name = "saurian_antenna"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_ANTENNA
	layers = list(BODY_ADJ_LAYER)

	feature_key = "saurian_antenna"
	preference = "saurian_antenna"
	render_key = "ipc_antenna_synth"

	dna_block = DNA_SAURIAN_ANTENNA_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_SAURIAN_ANTENNA

/obj/item/organ/saurian_antenna/get_global_feature_list()
	return GLOB.saurian_antenna_list

/obj/item/organ/saurian_antenna/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/saurian_antenna/build_overlays(physique, image_dir)
	. = ..()

	for(var/image_layer in layers)
		var/state2use = build_icon_state(physique, image_layer)

		if(!icon_exists(sprite_datum.icon, "[state2use]_secondary", FALSE))
			continue
		var/image/secondary = image(sprite_datum.icon, "[state2use]_secondary")
		secondary.color = mutcolors[MUTCOLORS_GENERIC_2]
		. += secondary
