/obj/item/clothing/gloves/color
	dying_key = DYE_REGISTRY_GLOVES

/obj/item/clothing/gloves/color/yellow
	desc = "These gloves provide protection against electric shock. The thickness of the rubber makes your fingers seem bigger."
	name = "insulated gloves"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE
	custom_price = PAYCHECK_ASSISTANT * 11.5
	custom_premium_price = PAYCHECK_ASSISTANT * 13.75
	cut_type = /obj/item/clothing/gloves/cut
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/gloves/color/yellow/heavy
	name = "ceramic-lined insulated gloves"
	desc = "A cheaper make of the standard insulated gloves, using internal ceramic lining to make up for the sub-par rubber material. The extra weight makes them more bulky to use."
	slowdown = 1
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/toy/sprayoncan
	name = "spray-on insulation applicator"
	desc = "What is the number one problem facing our station today?"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "sprayoncan"

/obj/item/toy/sprayoncan/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/atom/target = interacting_with // Yes i am supremely lazy

	if(!iscarbon(target))
		return NONE

	var/mob/living/carbon/C = target
	var/mob/living/carbon/U = user
	var/success = C.equip_to_slot_if_possible(new /obj/item/clothing/gloves/color/yellow/sprayon, ITEM_SLOT_GLOVES, qdel_on_fail = TRUE, disable_warning = TRUE)
	if(success)
		if(C == user)
			C.visible_message(span_notice("[U] sprays their hands with glittery rubber!"))
		else
			C.visible_message(span_warning("[U] sprays glittery rubber on the hands of [C]!"))
		return ITEM_INTERACT_SUCCESS

	C.visible_message(span_warning("The rubber fails to stick to [C]'s hands!"))
	return ITEM_INTERACT_BLOCKING

/obj/item/clothing/gloves/color/yellow/sprayon
	desc = "How're you gonna get 'em off, nerd?"
	name = "spray-on insulated gloves"
	icon_state = "sprayon"
	inhand_icon_state = "sprayon"
	item_flags = DROPDEL
	permeability_coefficient = 0
	resistance_flags = ACID_PROOF
	supports_variations_flags = NONE
	var/charges_remaining = 10

/obj/item/clothing/gloves/color/yellow/sprayon/Initialize(mapload)
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, PROC_REF(use_charge))
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(use_charge))

/obj/item/clothing/gloves/color/yellow/sprayon/proc/use_charge()
	SIGNAL_HANDLER

	charges_remaining--
	if(charges_remaining <= 0)
		var/turf/location = get_turf(src)
		location.visible_message(span_warning("[src] crumble[p_s()] away into nothing.")) // just like my dreams after working with .dm
		qdel(src)

/obj/item/clothing/gloves/color/fyellow //Cheap Chinese Crap
	desc = "These gloves are cheap knockoffs of the coveted ones - no way this can end badly."
	name = "budget insulated gloves"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 1 //Set to a default of 1, gets overridden in Initialize()
	permeability_coefficient = 0.05
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/cut

/obj/item/clothing/gloves/color/fyellow/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/old
	desc = "Old and worn out insulated gloves, hopefully they still work."
	name = "worn out insulated gloves"

/obj/item/clothing/gloves/color/fyellow/old/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/cut
	desc = "These gloves would protect the wearer from electric shock... if the fingers were covered."
	name = "fingerless insulated gloves"
	icon_state = "yellowcut"
	inhand_icon_state = "ygloves"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/cut/heirloom
	desc = "The old gloves your great grandfather stole from Engineering, many moons ago. They've seen some tough times recently."

/obj/item/clothing/gloves/color/black
	desc = "These gloves are fire-resistant."
	name = "black gloves"
	icon_state = "black"
	inhand_icon_state = "blackgloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/fingerless
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	inhand_icon_state = "fingerless"
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = PAYCHECK_ASSISTANT * 1.5
	undyeable = TRUE
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/color/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"
	inhand_icon_state = "orangegloves"

/obj/item/clothing/gloves/color/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"
	inhand_icon_state = "redgloves"


/obj/item/clothing/gloves/color/red/insulated
	name = "insulated gloves"
	desc = "These gloves provide protection against electric shock."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE

/obj/item/clothing/gloves/color/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	inhand_icon_state = "rainbowgloves"

/obj/item/clothing/gloves/color/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"
	inhand_icon_state = "bluegloves"

/obj/item/clothing/gloves/color/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"
	inhand_icon_state = "purplegloves"

/obj/item/clothing/gloves/color/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	inhand_icon_state = "greengloves"

/obj/item/clothing/gloves/color/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"
	inhand_icon_state = "graygloves"

/obj/item/clothing/gloves/color/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	inhand_icon_state = "lightbrowngloves"

/obj/item/clothing/gloves/color/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	inhand_icon_state = "browngloves"

TYPEINFO_DEF(/obj/item/clothing/gloves/color/captain)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 70, ACID = 50)

/obj/item/clothing/gloves/color/captain
	desc = "Regal blue gloves, with a nice gold trim, a diamond anti-shock coating, and an integrated thermal barrier. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	inhand_icon_state = "egloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60
	resistance_flags = NONE
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/gloves/color/chief_engineer
	desc = "These gloves provide excellent heat and electric insulation. They are so thin you can barely feel them."
	name = "advanced insulated gloves"
	icon_state = "ce_insuls"
	inhand_icon_state = "lgloves"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/gloves/color/latex
	name = "latex gloves"
	desc = "Cheap sterile gloves made from latex. Provides quicker carrying from a good grip."
	icon_state = "latex"
	inhand_icon_state = "latex"
	siemens_coefficient = 0.3
	permeability_coefficient = 0.01
	clothing_traits = list(TRAIT_QUICK_CARRY)
	resistance_flags = NONE
	clothing_flags = parent_type::clothing_flags | FIBERLESS
	// Just as the doctor ordered
	germ_level = 0

/obj/item/clothing/gloves/color/latex/nitrile
	name = "nitrile gloves"
	desc = "Pricy sterile gloves that are thicker than latex. Excellent grip ensures very fast carrying of patients along with the faster use time of various chemical related items."
	icon_state = "nitrile"
	inhand_icon_state = "nitrilegloves"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED)
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/gloves/color/infiltrator
	name = "infiltrator gloves"
	desc = "Specialized tactical gloves for carrying people around. Has tactical rubber grips for tactical ease of kidnapping. Tactically."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	siemens_coefficient = 0
	permeability_coefficient = 0.3
	clothing_traits = list(TRAIT_QUICKER_CARRY)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

TYPEINFO_DEF(/obj/item/clothing/gloves/color/latex/engineering)
	default_materials = list(/datum/material/iron=2000, /datum/material/silver=1500, /datum/material/gold = 1000)

/obj/item/clothing/gloves/color/latex/engineering
	name = "tinker's gloves"
	desc = "Overdesigned engineering gloves that have automated construction subrutines dialed in, allowing for faster construction while worn."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "clockwork_gauntlets"
	inhand_icon_state = "clockwork_gauntlets"
	siemens_coefficient = 0.8
	permeability_coefficient = 0.3
	clothing_traits = list(TRAIT_QUICK_BUILD)

/obj/item/clothing/gloves/color/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "white"
	inhand_icon_state = "wgloves"
	custom_price = PAYCHECK_ASSISTANT * 2.5

/obj/item/clothing/gloves/kim
	name = "aerostatic gloves"
	desc = "Breathable red gloves for expert handling of a pen and notebook."
	icon_state = "aerostatic_gloves"
	inhand_icon_state = "aerostatic_gloves"

/obj/item/clothing/gloves/maid
	name = "maid arm covers"
	desc = "Cylindrical looking tubes that go over your arm, weird."
	icon_state = "maid_arms"
