/obj/item/clothing/head/helmet/space/hardsuit/engine
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	inhand_icon_state = "eng_helm"
	armor = list(BLUNT = 15, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75)
	hardsuit_type = "engineering"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/radiation_protected_clothing)

/obj/item/clothing/suit/space/hardsuit/engine
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	inhand_icon_state = "eng_hardsuit"
	armor = list(BLUNT = 15, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/radiation_protected_clothing)

/obj/item/clothing/suit/space/hardsuit/engine/equipped(mob/user, slot)
	. = ..()
	AddComponent(/datum/component/geiger_sound)

/obj/item/clothing/suit/space/hardsuit/engine/unequipped()
	. = ..()
	var/datum/component/geiger_sound/GS = GetComponent(/datum/component/geiger_sound)
	if(GS)
		qdel(GS)

/////////////////////////////////// ATMOSPHERICS /////////////////////////////////////////////

/obj/item/clothing/head/helmet/space/hardsuit/atmos
	name = "atmospherics hardsuit helmet"
	desc = "A modified engineering hardsuit for work in a hazardous, low pressure environment. The radiation shielding plates were removed to allow for improved thermal protection instead."
	icon_state = "hardsuit0-atmos"
	inhand_icon_state = "atmo_helm"
	hardsuit_type = "atmos"
	armor = list(BLUNT = 30, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75)
	heat_protection = HEAD //Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/atmos
	name = "atmospherics hardsuit"
	desc = "A modified engineering hardsuit for work in a hazardous, low pressure environment. The radiation shielding plates were removed to allow for improved thermal protection instead."
	icon_state = "hardsuit-atmos"
	inhand_icon_state = "atmo_hardsuit"
	armor = list(BLUNT = 30, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS //Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/atmos

/obj/item/clothing/suit/space/hardsuit/atmos/equipped(mob/user, slot)
	. = ..()
	AddComponent(/datum/component/geiger_sound)

/obj/item/clothing/suit/space/hardsuit/atmos/unequipped()
	. = ..()
	var/datum/component/geiger_sound/GS = GetComponent(/datum/component/geiger_sound)
	if(GS)
		qdel(GS)
