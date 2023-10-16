/obj/item/bodypart/head/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC
	can_ingest_reagents = FALSE

/obj/item/bodypart/chest/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC
	is_dimorphic = FALSE

/obj/item/bodypart/arm/left/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC

/obj/item/bodypart/arm/right/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC

/obj/item/bodypart/leg/left/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC

/obj/item/bodypart/leg/right/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC


// Lizard variation
/obj/item/bodypart/head/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE

/obj/item/bodypart/chest/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE

/obj/item/bodypart/arm/right/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE

/obj/item/bodypart/leg/left/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE
	can_be_digitigrade = TRUE
	digitigrade_id = "digifurry"

// This needs to be new() because bodyparts dont immediately initialize, and this needs to render right in prefs
/obj/item/bodypart/leg/left/robot/ipc/saurian/New(loc, ...)
	. = ..()
	set_digitigrade(TRUE)

/obj/item/bodypart/leg/right/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE
	can_be_digitigrade = TRUE
	digitigrade_id = "digifurry"

// This needs to be new() because bodyparts dont immediately initialize, and this needs to render right in prefs
/obj/item/bodypart/leg/right/robot/ipc/saurian/New(loc, ...)
	. = ..()
	set_digitigrade(TRUE)
