//NCR
/obj/item/clothing/suit/armor/f13/utilityvest
	name = "utility vest"
	desc = "A practical vest with pockets for tools and such."
	icon_state = "vest_utility"
	inhand_icon_state = "vest_utility"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/suits_utility.dmi'
	armor = list(BLUNT = 10, PUNCTURE = 15, SLASH = 25, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 10, RAD = 0, FIRE = 20, ACID = 5)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets

/obj/item/clothing/suit/armor/f13/ncrarmor
	name = "NCR patrol vest"
	desc = "A standard issue NCR Infantry vest."
	icon_state = "ncr_infantry_vest"
	inhand_icon_state = "ncr_infantry_vest"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(BLUNT = 15, PUNCTURE = 30, SLASH = 40, LASER = 5, ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = -50)

/obj/item/clothing/suit/armor/f13/ncrarmor/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/suit/armor/f13/ncrarmor/mantle
	name = "NCR mantle vest"
	desc = "A standard issue NCR Infantry vest with a mantle on the shoulder."
	icon_state = "ncr_standard_mantle"
	inhand_icon_state = "ncr_standard_mantle"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 5, ENERGY = 0, BOMB = 5, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/ncrarmor/reinforced
	name = "NCR reinforced patrol vest"
	desc = "A standard issue NCR Infantry vest reinforced with a groinpad."
	icon_state = "ncr_reinforced_vest"
	inhand_icon_state = "ncr_reinforced_vest"
	armor = list(BLUNT = 25, PUNCTURE = 35, SLASH = 45, LASER = 10, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/ncrarmor/mantle/reinforced
	name = "NCR reinforced mantle vest"
	desc = "A standard issue NCR Infantry vest reinforced with a groinpad and a mantle."
	icon_state = "ncr_reinforced_mantle"
	inhand_icon_state = "ncr_reinforced_mantle"
	armor = list(BLUNT = 30, PUNCTURE = 40, SLASH = 50, LASER = 10, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/ncrarmor/labcoat
	name = "NCR medical labcoat"
	desc = "An armored labcoat typically issued to NCR Medical Officers. It's a standard white labcoat with the Medical Officer's name stitched into the breast and a two headed bear sewn into the shoulder."
	icon_state = "ncr_labcoat"
	inhand_icon_state = "ncr_labcoat"
	armor = list(BLUNT = 10, PUNCTURE = 15, SLASH = 25, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 10, RAD = 0, FIRE = 20, ACID = 5)
	allowed = list(/obj/item/gun, /obj/item/analyzer, /obj/item/stack/medical, /obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer, /obj/item/flashlight/pen, /obj/item/reagent_containers/cup/bottle, /obj/item/reagent_containers/cup/beaker, /obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle, /obj/item/paper, /obj/item/melee/baton/telescopic, /obj/item/soap, /obj/item/sensor_device, /obj/item/tank/internals/emergency_oxygen)

/obj/item/clothing/suit/armor/f13/ncrarmor/captain
	name = "NCR reinforced officer vest"
	desc = "A heavily reinforced set of NCR mantle armour, with large ceramic plating fitted to cover the torso and back, with additional plating on the shoulders and arms. Intended for use by high ranking officers."
	icon_state = "ncr_captain_armour"
	inhand_icon_state = "ncr_captain_armour"
	armor = list(BLUNT = 50, PUNCTURE = 50, SLASH = 60, LASER = 20, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/ncrarmor/lieutenant
	name = "NCR officer vest"
	desc = "A reinforced set of NCR mantle armour, with added padding on the groin, neck and shoulders. Intended for use by the officer class."
	icon_state = "ncr_lt_armour"
	inhand_icon_state = "ncr_lt_armour"
	armor = list(BLUNT = 45, PUNCTURE = 35, SLASH = 55, LASER = 10, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/combat/ncr
	name = "NCR combat armor"
	desc = "An old military grade pre war combat armor and, repainted to the colour scheme of the New California Republic."
	icon_state = "ncr_armor"
	inhand_icon_state = "ncr_armor"

/obj/item/clothing/suit/armor/f13/combat/mk2/ncr
	name = "reinforced NCR combat armor"
	desc = "A reinforced set of bracers, greaves, and torso plating of prewar design. This one is kitted with additional plates and, repainted to the colour scheme of the New California Republic."
	icon_state = "ncr_armor_mk2"
	inhand_icon_state = "ncr_armor_mk2"

/obj/item/clothing/suit/armor/f13/ncrarmor/lieutenant/ncr_officer_coat
	name = "NCR officer vest"
	desc = "A special issue NCR officer's armour with an added thick overcoat for protection from the elements."
	icon_state = "ncr_officer_coat"
	inhand_icon_state = "ncr_officer_coat"

//NCR Ranger
/obj/item/clothing/suit/toggle/armor/f13/rangerrecon
	name = "ranger recon duster"
	desc = "A thicker than average duster worn by NCR recon rangers out in the field. It's not heavily armored by any means, but is easy to move around in and provides excellent protection from the harsh desert environment."
	icon_state = "duster_recon"
	inhand_icon_state = "duster_recon"
	armor = list(BLUNT = 15, PUNCTURE = 30, SLASH = 40, LASER = 0, ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = -50)

/obj/item/clothing/suit/armor/f13/combat/ncr_patrol
	name = "ranger patrol armor"
	desc = "A set of standard issue ranger patrol armor that provides defense similar to a suit of pre-war combat armor. It's got NCR markings, making it clear who it was made by."
	icon_state = "ncr_patrol"
	inhand_icon_state = "ncr_patrol"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 5, ENERGY = 0, BOMB = 5, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armor/f13/combat/ncr_patrol/scout
	name = "ranger scout armor"
	desc = "A refurbished set of NCRA 3rd Scouts armor, now with heavier plating together with arm and leg guards. A two-headed bear has been painted on its chest."
	icon_state = "refurb_scout"
	inhand_icon_state = "refurb_scout"
	armor = list("tier" = 5, ENERGY = 45, BOMB = 55, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/suit/armor/f13/rangercombat
	name = "veteran ranger combat armor"
	desc = "The NCR veteran ranger combat armor, or black armor consists of a pre-war L.A.P.D. riot suit under a duster with rodeo jeans. Considered one of the most prestigious suits of armor to earn and wear while in service of the NCR Rangers."
	icon_state = "ranger"
	inhand_icon_state = "ranger"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	armor = list("tier" = 7, ENERGY = 40, BOMB = 55, BIO = 60, RAD = 60, FIRE = 90, ACID = 20)

/obj/item/clothing/suit/armor/f13/ncrcfjacket
	name = "NCRCF jacket"
	icon_state = "ncrcfjacket"
	inhand_icon_state = "ncrcfjacket"
	desc = "A cheap, standard issue teal canvas jacket issued to poor suckers who find themselves at the butt-end of the NCR's judiciary system."
	armor = list("tier" = 1, ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
