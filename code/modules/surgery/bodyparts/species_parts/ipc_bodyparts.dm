/obj/item/bodypart/head/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC

/obj/item/bodypart/chest/robot/ipc
	icon = 'icons/mob/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/species/ipc/bodyparts.dmi'
	limb_id = SPECIES_IPC

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

/obj/item/bodypart/leg/left/robot/ipc/saurian/Initialize(mapload)
	. = ..()
	set_digitigrade(TRUE)

/obj/item/bodypart/leg/right/robot/ipc/saurian
	icon = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	icon_greyscale = 'icons/mob/species/ipc/saurian/saurian_bodyparts.dmi'
	should_draw_greyscale = TRUE
	can_be_digitigrade = TRUE
	digitigrade_id = "digifurry"

/obj/item/bodypart/leg/right/robot/ipc/saurian/Initialize(mapload)
	. = ..()
	set_digitigrade(TRUE)
