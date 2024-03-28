//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Alcohol Tolerance"
	desc = "You have a high alcohol tolerance."
	icon = "beer"
	quirk_genre = QUIRK_GENRE_BOON
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = "<span class='obviousnotice'>You feel like you could drink a whole keg!</span>"
	lose_text = "<span class='obviousnotice'>You don't feel as resistant to alcohol anymore. Somehow.</span>"

/datum/quirk/item_quirk/musician
	name = "Musician"
	desc = "You can tune handheld musical instruments to play melodies that soothe the soul."
	icon = "guitar"
	quirk_genre = QUIRK_GENRE_BOON
	mob_trait = TRAIT_MUSICIAN
	gain_text = "<span class='obviousnotice'>You know everything about musical instruments.</span>"
	lose_text = "<span class='obviousnotice'>You forget how musical instruments work.</span>"

/datum/quirk/item_quirk/musician/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/music, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/skittish
	name = "Skittish"
	desc = "You're easy to startle, and hide frequently."
	icon = "trash"
	quirk_genre = QUIRK_GENRE_BOON
	mob_trait = TRAIT_SKITTISH

/datum/quirk/item_quirk/spiritual
	name = "Spiritual"
	desc = "You gain comfort from the presence of holy people."
	icon = "bible"
	quirk_genre = QUIRK_GENRE_BOON
	mob_trait = TRAIT_SPIRITUAL
	gain_text = "<span class='obviousnotice'>You have faith in a higher power.</span>"
	lose_text = "<span class='obviousnotice'>You lose faith!</span>"

/datum/quirk/item_quirk/spiritual/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/fancy/candle_box, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/matches, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/tagger
	name = "Graffiti Writer"
	desc = "You are an experienced writer and know how to get the most out of a spraycan."
	icon = "spray-can"
	quirk_genre = QUIRK_GENRE_BOON
	mob_trait = TRAIT_TAGGER
	gain_text = "<span class='obviousnotice'>You know how to tag walls efficiently.</span>"
	lose_text = "<span class='obviousnotice'>You forget how to tag walls properly.</span>"

/datum/quirk/item_quirk/tagger/add_unique(client/client_source)
	give_item_to_holder(/obj/item/toy/crayon/spraycan, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

