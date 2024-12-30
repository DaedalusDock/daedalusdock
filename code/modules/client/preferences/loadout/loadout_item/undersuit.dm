/datum/loadout_item/uniform
	category = LOADOUT_CATEGORY_UNIFORM

/datum/loadout_item/uniform/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.uniform
	outfit.uniform = path

//MISC
/datum/loadout_item/uniform/jumpsuit
	name = "jumpsuit"
	path = /obj/item/clothing/under/color

/datum/loadout_item/uniform/jumpskirt
	name = "jumpskirt"
	path = /obj/item/clothing/under/color/jumpskirt

/datum/loadout_item/uniform/assistantformal
	path = /obj/item/clothing/under/misc/assistantformal

/datum/loadout_item/uniform/henchman
	path = /obj/item/clothing/under/suit/henchmen

/datum/loadout_item/uniform/overalls
	path = /obj/item/clothing/under/misc/overalls

/datum/loadout_item/uniform/maidcostume
	path = /obj/item/clothing/under/costume/maid

/datum/loadout_item/uniform/mailmanuniform
	path = /obj/item/clothing/under/misc/mailman

/datum/loadout_item/uniform/kilt
	path = /obj/item/clothing/under/costume/kilt

/datum/loadout_item/uniform/swag
	path = /obj/item/clothing/under/costume/swagoutfit
	cost = 4

//SUITS
/datum/loadout_item/uniform/suit
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_SUITS

/datum/loadout_item/uniform/suit/suitblack
	path = /obj/item/clothing/under/suit/black

/datum/loadout_item/uniform/suit/suitgreen
	path = /obj/item/clothing/under/suit/green

/datum/loadout_item/uniform/suit/suitred
	path = /obj/item/clothing/under/suit/red

/datum/loadout_item/uniform/suit/suitcharcoal
	path = /obj/item/clothing/under/suit/charcoal

/datum/loadout_item/uniform/suit/suitnavy
	path = /obj/item/clothing/under/suit/navy

/datum/loadout_item/uniform/suit/suitburgundy
	path = /obj/item/clothing/under/suit/burgundy

/datum/loadout_item/uniform/suit/suittan
	path = /obj/item/clothing/under/suit/tan

/datum/loadout_item/uniform/suit/suitwhite
	path = /obj/item/clothing/under/suit/white

/datum/loadout_item/uniform/suit/suitskirtwhite
	path = /obj/item/clothing/under/suit/white/skirt

/datum/loadout_item/uniform/suit/amishsuit
	path = /obj/item/clothing/under/suit/sl

/datum/loadout_item/uniform/suit/tuxedo
	path = /obj/item/clothing/under/suit/tuxedo

/datum/loadout_item/uniform/suit/vicesuit
	path = /obj/item/clothing/under/misc/vice_officer

/datum/loadout_item/uniform/suit/waitersuit
	path = /obj/item/clothing/under/suit/waiter

/datum/loadout_item/uniform/suit/blacktwopiecesuit
	path = /obj/item/clothing/under/suit/blacktwopiece

/datum/loadout_item/uniform/suit/executivesuit
	path = /obj/item/clothing/under/suit/black_really

//SKIRTS
/datum/loadout_item/uniform/skirt
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_SKIRTS

/datum/loadout_item/uniform/skirt/skirtblack
	path = /obj/item/clothing/under/dress/skirt

/datum/loadout_item/uniform/skirt/skirtblue
	path = /obj/item/clothing/under/dress/skirt/blue

/datum/loadout_item/uniform/skirt/skirtred
	path = /obj/item/clothing/under/dress/skirt/red

/datum/loadout_item/uniform/skirt/skirtpurple
	path = /obj/item/clothing/under/dress/skirt/purple

/datum/loadout_item/uniform/skirt/skirtplaid
	path = /obj/item/clothing/under/dress/skirt/plaid

/datum/loadout_item/uniform/skirt/schoolgirlblue
	path = /obj/item/clothing/under/costume/schoolgirl

/datum/loadout_item/uniform/skirt/schoolgirlred
	path = /obj/item/clothing/under/costume/schoolgirl/red

/datum/loadout_item/uniform/skirt/schoolgirlgreen
	path = /obj/item/clothing/under/costume/schoolgirl/green

/datum/loadout_item/uniform/skirt/schoolgirlorange
	path = /obj/item/clothing/under/costume/schoolgirl/orange

//DRESSES
/datum/loadout_item/uniform/dress
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_DRESSES

/datum/loadout_item/uniform/dress/stripeddress
	path = /obj/item/clothing/under/dress/striped

/datum/loadout_item/uniform/dress/blacktangodress
	path = /obj/item/clothing/under/dress/blacktango

/datum/loadout_item/uniform/dress/sundress
	path = /obj/item/clothing/under/dress/sundress

/datum/loadout_item/uniform/dress/sailordress
	path = /obj/item/clothing/under/dress/sailor

/datum/loadout_item/uniform/dress/yellowsinger
	path = /obj/item/clothing/under/costume/singer/yellow

/datum/loadout_item/uniform/dress/redeveninggowndress
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/loadout_item/uniform/dress/draculass
	path = /obj/item/clothing/under/costume/draculass

/datum/loadout_item/uniform/dress/weddingdress
	path = /obj/item/clothing/under/dress/wedding_dress

//PANTS
/datum/loadout_item/uniform/pants
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_PANTS

/datum/loadout_item/uniform/pants/bjeans
	path = /obj/item/clothing/under/pants/blackjeans

/datum/loadout_item/uniform/pants/cjeans
	path = /obj/item/clothing/under/pants/classicjeans

/datum/loadout_item/uniform/pants/khaki
	path = /obj/item/clothing/under/pants/khaki

/datum/loadout_item/uniform/pants/wpants
	path = /obj/item/clothing/under/pants/white

/datum/loadout_item/uniform/pants/rpants
	path = /obj/item/clothing/under/pants/red

/datum/loadout_item/uniform/pants/tpants
	path = /obj/item/clothing/under/pants/tan

/datum/loadout_item/uniform/pants/trpants
	path = /obj/item/clothing/under/pants/track


//SHORTS
/datum/loadout_item/uniform/shorts
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_SHORTS

/datum/loadout_item/uniform/shorts/camoshorts
	path = /obj/item/clothing/under/pants/camo

/datum/loadout_item/uniform/shorts/athleticshorts
	path = /obj/item/clothing/under/shorts/red


//SWEATERS
/datum/loadout_item/uniform/sweater
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_SWEATERS

/datum/loadout_item/uniform/sweater/turtleneck
	path = /obj/item/clothing/under/syndicate/tacticool


