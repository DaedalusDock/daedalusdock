/obj/item/clothing/head/flakhelm	//Actually the M1 Helmet
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	name = "flak helmet"
	icon_state = "m1helm"
	inhand_icon_state = "helmet"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0.1, "bio" = 0, "fire" = -10, "acid" = -15, "wound" = 1)
	desc = "A dilapidated helmet used in ancient wars. This one is brittle and essentially useless. An ace of spades is tucked into the band around the outer shell."
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tiny/spacenam	//So you can stuff other things in the elastic band instead of it simply being a fluff thing.
	mutant_variants = NONE

/datum/component/storage/concrete/pockets/tiny/spacenam
	attack_hand_interact = TRUE		//So you can actually see what you stuff in there

/obj/item/clothing/head/cowboyhat
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	name = "cowboy hat"
	desc = "A standard brown cowboy hat, yeehaw."
	icon_state = "cowboyhat"
	inhand_icon_state = "cowboyhat"
	mutant_variants = NONE

/obj/item/clothing/head/cowboyhat/black
	name = "black cowboy hat"
	desc = "A black cowboy hat, perfect for any outlaw"
	icon_state = "cowboyhat_black"
	inhand_icon_state= "cowboyhat_black"

/obj/item/clothing/head/cowboyhat/white
	name = "white cowboy hat"
	desc = "A white cowboy hat, perfect for your every day rancher"
	icon_state = "cowboyhat_white"
	inhand_icon_state= "cowboyhat_white"

/obj/item/clothing/head/cowboyhat/pink
	name = "pink cowboy hat"
	desc = "A pink cowboy? more like cowgirl hat, just don't be a buckle bunny."
	icon_state = "cowboyhat_pink"
	inhand_icon_state= "cowboyhat_pink"

/obj/item/clothing/head/cowboyhat/sec
	name = "security cowboy hat"
	desc = "A security cowboy hat, perfect for any true lawman"
	icon_state = "cowboyhat_sec"
	inhand_icon_state= "cowboyhat_sec"

/obj/item/clothing/head/kepi
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	name = "kepi"
	desc = "A white cap with visor. Oui oui, mon capitane!"
	icon_state = "kepi"
	mutant_variants = NONE

/obj/item/clothing/head/kepi/old
	icon_state = "kepi_old"
	desc = "A flat, white circular cap with a visor, that demands some honor from it's wearer."

/obj/item/clothing/head/maid
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	name = "maid headband"
	desc = "Maid in China."
	icon_state = "maid"
	mutant_variants = NONE


/obj/item/clothing/head/intern/developer
	name = "\improper Intern beancap"

/obj/item/clothing/head/sec/navywarden/syndicate
	name = "master at arms' beret"
	desc = "Surprisingly stylish, if you lived in a silent impressionist film."
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#353535#AAAAAA"
	icon_state = "beret_badge"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 30, ACID = 50, WOUND = 6)
	strip_delay = 60
	mutant_variants = NONE


/obj/item/clothing/head/cowboyhat/blackwide
	name = "wide brimmed black cowboy hat"
	desc = "The Man in Black, he walked the earth but is now six foot under, this hat a stark reminder. Bring your courage, your righteousness... measure it against my resolve, and you will fail."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "cowboy_black"
	inhand_icon_state= "cowboy_black"


/obj/item/clothing/head/cowboyhat/wide
	name = "wide brimmed cowboy hat"
	desc = "A brown cowboy hat for blocking out the sun. Remember: Justice is truth in action. Let that guide you in the coming days."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "cowboy_wide"
	inhand_icon_state= "cowboy_wide"

/obj/item/clothing/head/cowboyhat/widesec
	name = "wide brimmed security cowboy hat"
	desc = "A bandit turned sheriff, his enforcement is brutal but effective - whether out of fear or respect is unclear, though not many bodies hang high. A peaceful land, a quiet people."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "cowboy_black_sec"
	inhand_icon_state= "cowboy_black_sec"


/obj/item/clothing/head/ushanka/sec
	name = "security ushanka"
	desc = "There's more to life than money, with this red ushanka, you can prove it for $19.99."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "ushankared"
	inhand_icon_state = "ushankadown"
	mutant_variants = NONE

/obj/item/clothing/head/ushanka/sec/blue
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "ushankablue"
	inhand_icon_state = "ushankadown"
	mutant_variants = NONE

/obj/item/clothing/head/soft/enclave
	name = "neo american cap"
	desc = "If worn in the battlefield or at a baseball game, it's still a rather scary hat."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "enclavesoft"
	soft_type = "enclave"
	dog_fashion = null

/obj/item/clothing/head/soft/enclaveo
	name = "neo american officer cap"
	desc = "It blocks out the sun and laser bolts from executions."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "enclaveosoft"
	soft_type = "enclaveo"
	dog_fashion = null

/obj/item/clothing/head/whiterussian
	name = "papakha"
	desc = "A big wooly clump of fur designed to go on your head."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "papakha"
	dog_fashion = null
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	mutant_variants = NONE

/obj/item/clothing/head/whiterussian/white
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "papakha_white"
	dog_fashion = null

/obj/item/clothing/head/whiterussian/black
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "papakha_kuban"
	dog_fashion = null

/obj/item/clothing/head/sec/peacekeeper/sol
	name = "sol police cap"
	desc = "Be a proper boy in blue with this cap, comes with a black visor to block out inconvenient truths."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "policeofficercap"
	mutant_variants = NONE

/obj/item/clothing/head/hos/peacekeeper/sol
	name = "sol police chief cap"
	desc = "A blue hat adorned with gold, rumoured to be used to distract Agents with its swag."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "policechiefcap"
	mutant_variants = NONE

/obj/item/clothing/head/soltraffic
	name = "sol traffic cop cap"
	desc = "You think that's Shitcurrity? That's just Civil Shitsputes, I'll show you REAL Shitcurrity."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "policetrafficcap"
	mutant_variants = NONE

/obj/item/clothing/head/colourable_flatcap
	name = "colourable flat cap"
	desc = "You in the computers son? You work the computers?"
	icon_state = "flatcap"
	greyscale_config = /datum/greyscale_config/flatcap
	greyscale_config_worn = /datum/greyscale_config/flatcap/worn
	greyscale_colors = "#79684c"
	flags_1 = IS_PLAYER_COLORABLE_1
	mutant_variants = NONE

/obj/item/clothing/head/flowerpin
	name = "flower pin"
	desc = "A small, colourable flower pin"
	icon_state = "flowerpin"
	greyscale_config = /datum/greyscale_config/flowerpin
	greyscale_config_worn = /datum/greyscale_config/flowerpin/worn
	greyscale_colors = "#FF0000"
	flags_1 = IS_PLAYER_COLORABLE_1
	w_class = WEIGHT_CLASS_SMALL
	mutant_variants = NONE

/obj/item/clothing/head/cowboyhat/sheriff
	name = "winter cowboy hat"
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "sheriff_hat"
	mutant_variants = NONE
	desc = "A dark hat from the cold wastes of the Frosthill mountains. So it was done, all according to the law. There's a small set of antlers embroidered on the inside."
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR

/obj/item/clothing/head/cowboyhat/sheriff/alt
	name = "sheriff hat"
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "sheriff_hat_alt"
	mutant_variants = NONE
	desc = "A dark brown hat with a smell of whiskey. There's a small set of antlers embroidered on the inside."

/obj/item/clothing/head/cowboyhat/deputy
	name = "deputy hat"
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "deputy_hat"
	mutant_variants = NONE
	desc = "A light brown hat with a smell of iron. There's a small set of antlers embroidered on the inside."

/obj/item/clothing/head/soft/yankee
	name = "fashionable baseball cap"
	desc = "Rimmed and brimmed."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "yankeesoft"
	soft_type = "yankee"
	dog_fashion = /datum/dog_fashion/head/yankee
	mutant_variants = NONE

/obj/item/clothing/head/soft/yankee/rimless
	name = "rimless fashionable baseball cap"
	desc = "Rimless for her pleasure."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "yankeenobrimsoft"
	soft_type = "yankeenobrim"

/obj/item/clothing/head/fedora/fedbrown
	name = "brown fedora"
	desc = "A noir-inspired fedora. Covers the eyes. Makes you look menacing, assuming you don't have a neckbeard."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "brfedora"
	mutant_variants = NONE

/obj/item/clothing/head/fedora/fedblack
	name = "black fedora"
	desc = "A matte-black fedora. Looks solid enough. It'll only look good on you if you don't have a neckbeard."
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "blfedora"
	mutant_variants = NONE

/obj/item/clothing/head/christmas
	name = "red christmas hat"
	desc = "A red Christmas Hat! How festive!"
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "christmashat"

/obj/item/clothing/head/christmas/green
	name = "green christmas hat"
	desc = "A green Christmas Hat! How festive!"
	icon = 'modular_pariah/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_pariah/master_files/icons/mob/clothing/head.dmi'
	icon_state = "christmashatg"
