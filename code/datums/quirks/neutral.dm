/datum/quirk/deviant_tastes
	name = "Deviant Tastes"
	desc = "You dislike food that most people enjoy, and find delicious what they don't."
	icon = "grin-tongue-squint"
	quirk_genre = QUIRK_GENRE_NEUTRAL
	gain_text = "<span class='obviousnotice'>You start craving something that tastes strange.</span>"
	lose_text = "<span class='obviousnotice'>You feel like eating normal food again.</span>"
	medical_record_text = "Patient demonstrates irregular nutrition preferences."

/datum/quirk/deviant_tastes/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/deviant_tastes/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	var/liked = new_species.liked_food
	new_species.liked_food = new_species.disliked_food
	new_species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food = initial(species.liked_food)
	species.disliked_food = initial(species.disliked_food)
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/heterochromatic
	name = "Heterochromia Iridum"
	desc = "One of your eyes is a different color than the other."
	icon = "eye-low-vision" // Ignore the icon name, its actually a fairly good representation of different color eyes
	medical_record_text = "Patient posesses dichromatic irises."
	quirk_genre = QUIRK_GENRE_NEUTRAL
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	var/color

/datum/quirk/heterochromatic/add_unique(client/client_source)
	color = client_source?.prefs?.read_preference(/datum/preference/color/heterochromatic)
	if(!color)
		return

	link_to_holder()

/datum/quirk/heterochromatic/post_add()
	if(color)
		return

	color = quirk_holder.client?.prefs?.read_preference(/datum/preference/color/heterochromatic)
	if(!color)
		return

	link_to_holder()

/datum/quirk/heterochromatic/remove()
	UnregisterSignal(quirk_holder, COMSIG_CARBON_LOSE_ORGAN)

/datum/quirk/heterochromatic/proc/link_to_holder()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = TRUE
	human_holder.eye_color_right = color
	// We set override to TRUE as link to holder will be called whenever the preference is applied, given this quirk exists on the mob
	RegisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(check_eye_removal), override=TRUE)

	var/obj/item/organ/eyes/eyes_of_the_holder = quirk_holder.getorgan(/obj/item/organ/eyes)
	if(!eyes_of_the_holder)
		return

	eyes_of_the_holder.eye_color_right = color
	eyes_of_the_holder.old_eye_color_right = color
	human_holder.update_eyes()

/datum/quirk/heterochromatic/proc/check_eye_removal(datum/source, obj/item/organ/eyes/removed)
	SIGNAL_HANDLER

	if(!istype(removed))
		return

	// Eyes were removed, remove heterochromia from the human holder and bid them adieu
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = FALSE
	human_holder.eye_color_right = initial(human_holder.eye_color_right)
	UnregisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN)

/datum/quirk/item_quirk/photographer
	name = "Photographer"
	desc = "You carry your camera and personal photo album everywhere you go."
	icon = "camera"
	quirk_genre = QUIRK_GENRE_NEUTRAL
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = "<span class='obviousnotice'>You know everything about photography.</span>"
	lose_text = "<span class='obviousnotice'>You forget how photo cameras work.</span>"
	medical_record_text = "Patient mentions photography as a stress-relieving hobby."

/datum/quirk/item_quirk/photographer/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/storage/photo_album/personal/photo_album = new(get_turf(human_holder))
	photo_album.persistence_id = "personal_[human_holder.last_mind?.key]" // this is a persistent album, the ID is tied to the account's key to avoid tampering
	photo_album.persistence_load()
	photo_album.name = "[human_holder.real_name]'s photo album"

	give_item_to_holder(photo_album, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(
		/obj/item/camera,
		list(
			LOCATION_NECK = ITEM_SLOT_NECK,
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS
		)
	)

/datum/quirk/item_quirk/colorist
	name = "Colorist"
	desc = "You like carrying around a hair dye spray to quickly apply color patterns to your hair."
	icon = "fill-drip"
	quirk_genre = QUIRK_GENRE_NEUTRAL
	medical_record_text = "Patient enjoys dyeing their hair with pretty colors."

/datum/quirk/item_quirk/colorist/add_unique(client/client_source)
	give_item_to_holder(/obj/item/dyespray, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
