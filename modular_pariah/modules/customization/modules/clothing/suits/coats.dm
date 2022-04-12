/obj/item/clothing/suit/hooded/wintercoat/paramedic
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	name = "paramedic winter coat"
	desc = "A winter coat with blue markings. Warm, but probably won't protect from biological agents. For the cozy doctor on the go."
	icon_state = "coatparamed"
	inhand_icon_state = "coatparamed"
	allowed = list(/obj/item/analyzer, /obj/item/stack/medical, /obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer, /obj/item/flashlight/pen, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/beaker, /obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle, /obj/item/paper, /obj/item/melee/baton/telescopic, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 50, "fire" = 0, "acid" = 45, "wound" = 3)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/paramedic

/obj/item/clothing/head/hooded/winterhood/paramedic
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	desc = "A white winter coat hood with blue markings."
	icon_state = "winterhood_paramed"

/obj/item/clothing/suit/hooded/wintercoat/robotics
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	name = "robotics winter coat"
	desc = "A black winter coat with a badass flaming robotic skull for the zipper tab. This one has bright red designs and a few useless buttons."
	icon_state = "coatrobotics"
	inhand_icon_state = "coatrobotics"
	allowed = list(/obj/item/analyzer, /obj/item/stack/medical, /obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer, /obj/item/melee/baton/telescopic, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/screwdriver, /obj/item/crowbar, /obj/item/wrench, /obj/item/stack/cable_coil, /obj/item/weldingtool, /obj/item/multitool)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "fire" = 0, "acid" = 0, "wound" = 0)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/robotics

/obj/item/clothing/head/hooded/winterhood/robotics
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	desc = "A black winter coat hood. You can pull it down over your eyes and pretend that you're an outdated, late 1980s interpretation of a futuristic mechanized police force. They'll fix you. They fix everything."
	icon_state = "winterhood_robotics"


/obj/item/clothing/suit/hooded/wintercoat/aformal
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	name = "assistant's formal winter coat"
	desc = "A black button up winter coat."
	icon_state = "coataformal"
	inhand_icon_state = "coataformal"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter,/obj/item/clothing/gloves/color/yellow)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/aformal

/obj/item/clothing/head/hooded/winterhood/aformal
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	desc = "A black winter coat hood."
	icon_state = "winterhood_aformal"

/obj/item/clothing/suit/hooded/cloak/david
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	name = "red cloak"
	icon_state = "goliath_cloak"
	desc = "Ever wanted to look like a badass without ANY effort? Try this nanotrasen brand red cloak, perfect for kids"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/david
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/hooded/cloakhood/david
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	name = "red cloak hood"
	icon_state = "golhood"
	desc = "conceal your face in shame with this nanotrasen brand hood"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/suit/toggle/deckard
	name = "runner coat"
	desc = "They say you overused reference. Tell them you're eating in this lovely coat, a long flowing brown one."
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "deckard"
	inhand_icon_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(MELEE = 25, BULLET = 10, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, FIRE = 0, ACID = 45)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/toggle/brit/sec
	name = "high vis armored vest"
	desc = "Oi bruv' you got a loicence for that?"
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "hazardbg"
	blood_overlay_type = "coat"
	toggle_noun = "zipper"
	armor = list(MELEE = 10, BULLET = 5, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)


/obj/item/clothing/suit/toggle/lawyer/black/better
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "suitjacket_black"


/obj/item/clothing/suit/toggle/lawyer/white
	name = "white suit jacket"
	desc = "A very versatile part of a suit ensable. Oddly in fashion with mobsters."
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "suitjacket_white"

/obj/item/clothing/suit/hooded/wintercoat/christmas
	name = "red christmas coat"
	desc = "A festive red Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatr"
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas

/obj/item/clothing/head/hooded/winterhood/christmas
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "christmashoodr"

/obj/item/clothing/suit/hooded/wintercoat/christmas/green
	name = "green christmas coat"
	desc = "A festive green Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatg"
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas/green

/obj/item/clothing/head/hooded/winterhood/christmas/green
	icon_state = "christmashoodg"

/obj/item/clothing/suit/hooded/wintercoat/christmas/gamerpc
	name = "red and green christmas coat"
	desc = "A festive red and green Christmas coat! Smells like Candy Cane!"
	icon_state = "christmascoatrg"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/christmas/gamerpc

/obj/item/clothing/head/hooded/winterhood/christmas/gamerpc
	icon_state = "christmashoodrg"

/obj/item/clothing/suit/armor/vest/det_suit/runner
	name = "joyful coat"
	desc = "<i>\"You look like a good Joe.\"</i>"
	icon_state = "bladerunner_neue"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|ARMS|GROIN|LEGS
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "coat"

/obj/item/clothing/suit/croptop
	name = "black crop top turtleneck"
	desc = "A comfy looking turtleneck that exposes your midriff, fashionable but makes the point of a sweater moot."
	icon_state = "croptop_black"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	icon = 'modular_pariah/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/suit.dmi'
