//Biosuit complete with shoes (in the item sprite)
TYPEINFO_DEF(/obj/item/clothing/head/bio_hood)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 30, ACID = 100)

/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	desc = "A hood that protects the head and face from biological contaminants."
	permeability_coefficient = 0.01
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS | FIBERLESS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	resistance_flags = ACID_PROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

TYPEINFO_DEF(/obj/item/clothing/suit/bio_suit)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 30, ACID = 100)

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	inhand_icon_state = "bio_suit"
	w_class = WEIGHT_CLASS_BULKY
	permeability_coefficient = 0.01
	clothing_flags = THICKMATERIAL | FIBERLESS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 0.5
	allowed = list(/obj/item/tank/internals, /obj/item/reagent_containers/dropper, /obj/item/flashlight/pen, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/cup/beaker, /obj/item/gun/syringe)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	resistance_flags = ACID_PROOF
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"


//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"


//Security biosuit, grey with red stripe across the chest
TYPEINFO_DEF(/obj/item/clothing/head/bio_hood/security)
	default_armor = list(BLUNT = 25, PUNCTURE = 15, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 100, FIRE = 30, ACID = 100)

/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

TYPEINFO_DEF(/obj/item/clothing/suit/bio_suit/security)
	default_armor = list(BLUNT = 25, PUNCTURE = 15, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 100, FIRE = 30, ACID = 100)

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/bag/trash, /obj/item/reagent_containers/spray)

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"

//CMO's biosuit, blue stripe
/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo/Initialize(mapload)
	. = ..()
	allowed += /obj/item/assembly/flash/handheld

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	inhand_icon_state = "bio_suit"
	strip_delay = 40
	equip_delay_other = 20
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/bio_suit/plaguedoctorsuit/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/cane)
