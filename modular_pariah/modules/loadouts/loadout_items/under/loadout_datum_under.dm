
// --- Loadout item datums for under suits ---

/// Underslot - Jumpsuit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_jumpsuits, generate_loadout_items(/datum/loadout_item/under/jumpsuit))

/// Underslot - Formal Suit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_undersuits, generate_loadout_items(/datum/loadout_item/under/formal))

/// Underslot - Misc. Under Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_miscunders, generate_loadout_items(/datum/loadout_item/under/miscellaneous))

/datum/loadout_item/under
	category = LOADOUT_ITEM_UNIFORM

/datum/loadout_item/under/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout uniform was not equipped directly due to your envirosuit.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.uniform = item_path

//////////////////////////////////////////////////////JUMPSUITS
/datum/loadout_item/under/jumpsuit

/datum/loadout_item/under/jumpsuit/greyscale
	name = "Greyscale Jumpsuit"
	item_path = /obj/item/clothing/under/color

/datum/loadout_item/under/jumpsuit/greyscale_skirt
	name = "Greyscale Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt

/datum/loadout_item/under/jumpsuit/random
	name = "Random Jumpsuit"
	item_path = /obj/item/clothing/under/color/random
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/under/jumpsuit/random_skirt
	name = "Random Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/random
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/under/jumpsuit/rainbow
	name = "Rainbow Jumpsuit"
	item_path = /obj/item/clothing/under/color/rainbow

/datum/loadout_item/under/jumpsuit/rainbow_skirt
	name = "Rainbow Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/rainbow

/datum/loadout_item/under/jumpsuit/security_trousers
	name = "Security Trousers"
	item_path = /obj/item/clothing/under/rank/security/trousers/red
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY)

/datum/loadout_item/under/jumpsuit/disco
	name = "Superstar Cop Suit"
	item_path = /obj/item/clothing/under/misc/discounder
	restricted_roles = list(JOB_DETECTIVE)

/datum/loadout_item/under/jumpsuit/mailman
	name = "Mailman's Jumpsuit"
	item_path = /obj/item/clothing/under/misc/mailman
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN)

/datum/loadout_item/under/jumpsuit/utility
	name = "Utility Uniform"
	item_path = /obj/item/clothing/under/utility

/datum/loadout_item/under/jumpsuit/utility_eng
	name = "Engineering Utility Uniform"
	item_path = /obj/item/clothing/under/utility/eng
	restricted_roles = list(JOB_STATION_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN, JOB_CHIEF_ENGINEER)

/datum/loadout_item/under/jumpsuit/utility_med
	name = "Medical Utility Uniform"
	item_path = /obj/item/clothing/under/utility/med
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_PARAMEDIC, JOB_CHEMIST, JOB_VIROLOGIST, JOB_GENETICIST, JOB_CHIEF_MEDICAL_OFFICER, JOB_PSYCHOLOGIST)

/datum/loadout_item/under/jumpsuit/utility_sci
	name = "Science Utility Uniform"
	item_path = /obj/item/clothing/under/utility/sci
	restricted_roles = list(JOB_SCIENTIST, JOB_ROBOTICIST, JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/under/jumpsuit/utility_cargo
	name = "Supply Utility Uniform"
	item_path = /obj/item/clothing/under/utility/cargo
	restricted_roles = list(JOB_CARGO_TECHNICIAN, JOB_SHAFT_MINER, JOB_QUARTERMASTER)

/datum/loadout_item/under/jumpsuit/utility_sec
	name = "Security Utility Uniform"
	item_path = /obj/item/clothing/under/utility/sec
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_DETECTIVE, JOB_WARDEN, JOB_HEAD_OF_SECURITY) //i dunno about the blueshield, they're a weird combo of sec and command, thats why they arent in the loadout pr im making

/datum/loadout_item/under/jumpsuit/utility_com
	name = "Command Utility Uniform"
	item_path = /obj/item/clothing/under/utility/com
	restricted_roles = list(JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_HEAD_OF_SECURITY, JOB_RESEARCH_DIRECTOR, JOB_QUARTERMASTER, JOB_CHIEF_MEDICAL_OFFICER, JOB_CHIEF_ENGINEER)

/////////////////////////////////////////////////////////////MISC UNDERSUITS
/datum/loadout_item/under/miscellaneous/camo
	name = "Camo Pants"
	item_path = /obj/item/clothing/under/pants/camo

/datum/loadout_item/under/miscellaneous/jeans_classic
	name = "Classic Jeans"
	item_path = /obj/item/clothing/under/pants/classicjeans

/datum/loadout_item/under/miscellaneous/jeans_black
	name = "Black Jeans"
	item_path = /obj/item/clothing/under/pants/blackjeans

/datum/loadout_item/under/miscellaneous/black
	name = "Black Pants"
	item_path = /obj/item/clothing/under/pants/black

/datum/loadout_item/under/miscellaneous/black_short
	name = "Black Shorts"
	item_path = /obj/item/clothing/under/shorts/black

/datum/loadout_item/under/miscellaneous/blue_short
	name = "Blue Shorts"
	item_path = /obj/item/clothing/under/shorts/blue

/datum/loadout_item/under/miscellaneous/green_short
	name = "Green Shorts"
	item_path = /obj/item/clothing/under/shorts/green

/datum/loadout_item/under/miscellaneous/grey_short
	name = "Grey Shorts"
	item_path = /obj/item/clothing/under/shorts/grey

/datum/loadout_item/under/miscellaneous/jeans
	name = "Jeans"
	item_path = /obj/item/clothing/under/pants/jeans

/datum/loadout_item/under/miscellaneous/jeansripped
	name = "Ripped Jeans"
	item_path = /obj/item/clothing/under/pants/jeanripped

/datum/loadout_item/under/miscellaneous/khaki
	name = "Khaki Pants"
	item_path = /obj/item/clothing/under/pants/khaki

/datum/loadout_item/under/miscellaneous/jeans_musthang
	name = "Must Hang Jeans"
	item_path = /obj/item/clothing/under/pants/mustangjeans

/datum/loadout_item/under/miscellaneous/pants/blackshorts
	name = "Black ripped shorts"
	item_path = /obj/item/clothing/under/pants/blackshorts

/datum/loadout_item/under/miscellaneous/purple_short
	name = "Purple Shorts"
	item_path = /obj/item/clothing/under/shorts/purple

/datum/loadout_item/under/miscellaneous/red
	name = "Red Pants"
	item_path = /obj/item/clothing/under/pants/red

/datum/loadout_item/under/miscellaneous/red_short
	name = "Red Shorts"
	item_path = /obj/item/clothing/under/shorts/red

/datum/loadout_item/under/miscellaneous/denim_skirt
	name = "Denim Skirt"
	item_path = /obj/item/clothing/under/pants/denimskirt

/datum/loadout_item/under/miscellaneous/jeanshorts
	name = "Jean Shorts"
	item_path = /obj/item/clothing/under/pants/jeanshort

/datum/loadout_item/under/miscellaneous/tam
	name = "Tan Pants"
	item_path = /obj/item/clothing/under/pants/tan

/datum/loadout_item/under/miscellaneous/track
	name = "Track Pants"
	item_path = /obj/item/clothing/under/pants/track

/datum/loadout_item/under/miscellaneous/jeans_youngfolk
	name = "Young Folks Jeans"
	item_path = /obj/item/clothing/under/pants/youngfolksjeans

/datum/loadout_item/under/miscellaneous/white
	name = "White Pants"
	item_path = /obj/item/clothing/under/pants/white

/datum/loadout_item/under/miscellaneous/treasure_hunter
	name = "Treasure Hunter"
	item_path = /obj/item/clothing/under/rank/civilian/curator/treasure_hunter

/datum/loadout_item/under/miscellaneous/overalls
	name = "Overalls"
	item_path = /obj/item/clothing/under/misc/overalls

/datum/loadout_item/under/miscellaneous/vice_officer
	name = "Vice Officer Jumpsuit"
	item_path = /obj/item/clothing/under/misc/vice_officer

/datum/loadout_item/under/miscellaneous/soviet
	name = "Soviet Uniform"
	item_path = /obj/item/clothing/under/costume/soviet

/datum/loadout_item/under/miscellaneous/redcoat
	name = "Redcoat"
	item_path = /obj/item/clothing/under/costume/redcoat

/datum/loadout_item/under/miscellaneous/tactical_hawaiian_orange
	name = "Tactical Hawaiian Outfit - Orange"
	item_path = /obj/item/clothing/under/tachawaiian

/datum/loadout_item/under/miscellaneous/tactical_hawaiian_blue
	name = "Tactical Hawaiian Outfit - Blue"
	item_path = /obj/item/clothing/under/tachawaiian/blue

/datum/loadout_item/under/miscellaneous/tactical_hawaiian_purple
	name = "Tactical Hawaiian Outfit - Purple"
	item_path = /obj/item/clothing/under/tachawaiian/purple

/datum/loadout_item/under/miscellaneous/tactical_hawaiian_green
	name = "Tactical Hawaiian Outfit - Green"
	item_path = /obj/item/clothing/under/tachawaiian/green

/datum/loadout_item/under/miscellaneous/croptop
	name = "Croptop"
	item_path = /obj/item/clothing/under/croptop

/datum/loadout_item/under/miscellaneous/qipao
	name = "Qipao, Black"
	item_path = /obj/item/clothing/under/costume/qipao

/datum/loadout_item/under/miscellaneous/cheongsam
	name = "Cheongsam, Black"
	item_path = /obj/item/clothing/under/costume/cheongsam

/datum/loadout_item/under/miscellaneous/chaps
	name = "Black Chaps"
	item_path = /obj/item/clothing/under/pants/chaps

/datum/loadout_item/under/miscellaneous/tracky
	name = "Blue Tracksuit"
	item_path = /obj/item/clothing/under/misc/bluetracksuit

/datum/loadout_item/under/miscellaneous/cybersleek
	name = "Sleek Modern Coat"
	item_path = /obj/item/clothing/under/costume/cybersleek

/datum/loadout_item/under/miscellaneous/cybersleek_long
	name = "Long Modern Coat"
	item_path = /obj/item/clothing/under/costume/cybersleek/long

/datum/loadout_item/under/miscellaneous/tacticool_turtleneck
	name = "Tactitool Turtleneck"
	item_path = /obj/item/clothing/under/syndicate/tacticool/sensors

/datum/loadout_item/under/miscellaneous/tactical_pants
	name = "Tactical Pants"
	item_path = /obj/item/clothing/under/pants/tactical

//HALLOWEEN
/datum/loadout_item/under/miscellaneous/tactical_skirt
	name = "Tactitool Skirtleneck"
	item_path = /obj/item/clothing/under/syndicate/tacticool/skirt/sensors

/datum/loadout_item/under/miscellaneous/cream_sweater
	name = "Cream Sweater"
	item_path = /obj/item/clothing/under/sweater

/datum/loadout_item/under/miscellaneous/black_sweater
	name = "Black Sweater"
	item_path = /obj/item/clothing/under/sweater/black

/datum/loadout_item/under/miscellaneous/purple_sweater
	name = "Purple Sweater"
	item_path = /obj/item/clothing/under/sweater/purple

/datum/loadout_item/under/miscellaneous/green_sweater
	name = "Green Sweater"
	item_path = /obj/item/clothing/under/sweater/green

/datum/loadout_item/under/miscellaneous/red_sweater
	name = "Red Sweater"
	item_path = /obj/item/clothing/under/sweater/red

/datum/loadout_item/under/miscellaneous/blue_sweater
	name = "Blue Sweater"
	item_path = /obj/item/clothing/under/sweater/blue

/datum/loadout_item/under/miscellaneous/keyhole
	name = "Keyhole Sweater"
	item_path = /obj/item/clothing/under/sweater/keyhole

/datum/loadout_item/under/miscellaneous/blacknwhite
	name = "Classic Prisoner Jumpsuit"
	item_path = /obj/item/clothing/under/rank/prisoner/classic
	restricted_roles = list(JOB_PRISONER)

/datum/loadout_item/under/miscellaneous/redscrubs
	name = "Red Scrubs"
	item_path = /obj/item/clothing/under/rank/medical/doctor/red/unarm
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC)

/datum/loadout_item/under/miscellaneous/bluescrubs
	name = "Blue Scrubs"
	item_path = /obj/item/clothing/under/rank/medical/scrubs/blue
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC)

/datum/loadout_item/under/miscellaneous/greenscrubs
	name = "Green Scrubs"
	item_path = /obj/item/clothing/under/rank/medical/scrubs/green
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC)

/datum/loadout_item/under/miscellaneous/purplescrubs
	name = "Purple Scrubs"
	item_path = /obj/item/clothing/under/rank/medical/scrubs/purple
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC)

/datum/loadout_item/under/miscellaneous/whitescrubs
	name = "White Scrubs"
	item_path = /obj/item/clothing/under/rank/medical/doctor/white
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC)

/datum/loadout_item/under/miscellaneous/swept_skirt
	name = "Swept Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/swept

/datum/loadout_item/under/miscellaneous/kimunder
	name = "Aerostatic Suit"
	item_path = /obj/item/clothing/under/misc/kimunder

/datum/loadout_item/under/miscellaneous/countess
	name = "Countess Dress"
	item_path = /obj/item/clothing/under/misc/countess

/datum/loadout_item/under/miscellaneous/taccas
	name = "Tacticasual Uniform"
	item_path = /obj/item/clothing/under/misc/taccas

/datum/loadout_item/under/miscellaneous/cargo_casual
	name = "Cargo Tech Casual Wear"
	item_path = /obj/item/clothing/under/rank/cargo/casualman
	restricted_roles = list(JOB_CARGO_TECHNICIAN)

/datum/loadout_item/under/miscellaneous/cargo_casual
	name = "Black Cargo Uniform"
	item_path = /obj/item/clothing/under/misc/evilcargo
	restricted_roles = list(JOB_CARGO_TECHNICIAN)

////////////////////////////////////////////////////////////////FORMAL UNDERSUITS
/datum/loadout_item/under/formal

/datum/loadout_item/under/formal/amish_suit
	name = "Amish Suit"
	item_path = /obj/item/clothing/under/suit/sl

/datum/loadout_item/under/formal/formaldressred
	name = "Formal Red Dress"
	item_path = /obj/item/clothing/under/misc/formaldressred

/datum/loadout_item/under/formal/assistant
	name = "Assistant Formal"
	item_path = /obj/item/clothing/under/misc/assistantformal

/datum/loadout_item/under/formal/beige_suit
	name = "Beige Suit"
	item_path = /obj/item/clothing/under/suit/beige

/datum/loadout_item/under/formal/black_suit
	name = "Black Suit"
	item_path = /obj/item/clothing/under/suit/black

/datum/loadout_item/under/formal/black_suitskirt
	name = "Black Suitskirt"
	item_path = /obj/item/clothing/under/suit/black/skirt

/datum/loadout_item/under/formal/black_tango
	name = "Black Tango Dress"
	item_path = /obj/item/clothing/under/dress/blacktango

/datum/loadout_item/under/formal/black_twopiece
	name = "Black Two-Piece Suit"
	item_path = /obj/item/clothing/under/suit/blacktwopiece

/datum/loadout_item/under/formal/black_skirt
	name = "Black Skirt"
	item_path = /obj/item/clothing/under/dress/skirt

/datum/loadout_item/under/formal/black_lawyer_suit
	name = "Black Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black

/datum/loadout_item/under/formal/black_lawyer_skirt
	name = "Black Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black/skirt

/datum/loadout_item/under/formal/blue_suit
	name = "Blue Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit

/datum/loadout_item/under/formal/blue_suitskirt
	name = "Blue Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt

/datum/loadout_item/under/formal/blue_lawyer_suit
	name = "Blue Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/loadout_item/under/formal/blue_lawyer_skirt
	name = "Blue Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue/skirt

/datum/loadout_item/under/formal/blue_skirt
	name = "Blue Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/blue

/datum/loadout_item/under/formal/blue_skirt_plaid
	name = "Blue Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/blue

/datum/loadout_item/under/formal/burgundy_suit
	name = "Burgundy Suit"
	item_path = /obj/item/clothing/under/suit/burgundy

/datum/loadout_item/under/formal/charcoal_suit
	name = "Charcoal Suit"
	item_path = /obj/item/clothing/under/suit/charcoal

/datum/loadout_item/under/formal/checkered_suit
	name = "Checkered Suit"
	item_path = /obj/item/clothing/under/suit/checkered

/datum/loadout_item/under/formal/executive_suit
	name = "Executive Suit"
	item_path = /obj/item/clothing/under/suit/black_really

/datum/loadout_item/under/formal/executive_skirt
	name = "Executive Suitskirt"
	item_path = /obj/item/clothing/under/suit/black_really/skirt

/datum/loadout_item/under/formal/executive_suit_alt
	name = "Executive Suit Alt"
	item_path = /obj/item/clothing/under/suit/black/female/trousers

/datum/loadout_item/under/formal/executive_skirt_alt
	name = "Executive Suitskirt Alt"
	item_path = /obj/item/clothing/under/suit/black/female/skirt

/datum/loadout_item/under/formal/green_suit
	name = "Green Suit"
	item_path = /obj/item/clothing/under/suit/green

/datum/loadout_item/under/formal/green_skirt_plaid
	name = "Green Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/green

/datum/loadout_item/under/formal/navy_suit
	name = "Navy Suit"
	item_path = /obj/item/clothing/under/suit/navy

/datum/loadout_item/under/formal/purple_suit
	name = "Purple Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit

/datum/loadout_item/under/formal/purple_suitskirt
	name = "Purple Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt

/datum/loadout_item/under/formal/purple_skirt_plaid
	name = "Purple Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/purple

/datum/loadout_item/under/formal/red_suit
	name = "Red Suit"
	item_path = /obj/item/clothing/under/suit/red

/datum/loadout_item/under/formal/helltaker
	name = "Red Shirt with White Trousers"
	item_path = /obj/item/clothing/under/suit/helltaker

/datum/loadout_item/under/formal/helltaker/skirt
	name = "Red Shirt with White Skirt"
	item_path = /obj/item/clothing/under/suit/helltaker/skirt

/datum/loadout_item/under/formal/red_lawyer_skirt
	name = "Red Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	name = "Red Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red/skirt

/datum/loadout_item/under/formal/red_gown
	name = "Red Evening Gown"
	item_path = /obj/item/clothing/under/dress/redeveninggown

/datum/loadout_item/under/formal/red_skirt_plaid
	name = "Red Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid

/datum/loadout_item/under/formal/sailor
	name = "Sailor Suit"
	item_path = /obj/item/clothing/under/costume/sailor

/datum/loadout_item/under/formal/sailor_skirt
	name = "Sailor Dress"
	item_path = /obj/item/clothing/under/dress/sailor

/datum/loadout_item/under/formal/striped_skirt
	name = "Striped Dress"
	item_path = /obj/item/clothing/under/dress/striped

/datum/loadout_item/under/formal/sensible_suit
	name = "Sensible Suit"
	item_path = /obj/item/clothing/under/rank/civilian/curator

/datum/loadout_item/under/formal/sensible_skirt
	name = "Sensible Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/curator/skirt

/datum/loadout_item/under/formal/sundress
	name = "Sundress"
	item_path = /obj/item/clothing/under/dress/sundress

/datum/loadout_item/under/formal/sundress/white
	name = "White Sundress"
	item_path = /obj/item/clothing/under/dress/sundress/white

/datum/loadout_item/under/formal/tuxedo
	name = "Tuxedo Suit"
	item_path = /obj/item/clothing/under/suit/tuxedo

/datum/loadout_item/under/formal/waiter
	name = "Waiter's Suit"
	item_path = /obj/item/clothing/under/suit/waiter

/datum/loadout_item/under/formal/white_suit
	name = "White Suit"
	item_path = /obj/item/clothing/under/suit/white

/datum/loadout_item/under/formal/fancy_suit
	name = "Fancy Suit"
	item_path = /obj/item/clothing/under/suit/fancy

/datum/loadout_item/under/formal/formalmed
	name = "Formal Medical Suit"
	item_path = /obj/item/clothing/under/rank/medical/doctor/formal
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST, JOB_PARAMEDIC, JOB_PSYCHOLOGIST)
