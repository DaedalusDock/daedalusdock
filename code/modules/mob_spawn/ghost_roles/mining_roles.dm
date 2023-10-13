//beach dome

/obj/effect/mob_spawn/ghost_role/human/beach
	prompt_name = "a beach bum"
	name = "beach bum sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	you_are_text = "You're, like, totally a dudebro, bruh."
	flavour_text = "Ch'yea. You came here, like, on spring break, hopin' to pick up some bangin' hot chicks, y'knaw?"
	spawner_job_path = /datum/job/beach_bum
	outfit = /datum/outfit/beachbum

/obj/effect/mob_spawn/ghost_role/human/beach/lifeguard
	you_are_text = "You're a spunky lifeguard!"
	flavour_text = "It's up to you to make sure nobody drowns or gets eaten by sharks and stuff."
	name = "lifeguard sleeper"
	outfit = /datum/outfit/beachbum/lifeguard

/obj/effect/mob_spawn/ghost_role/human/beach/lifeguard/special(mob/living/carbon/human/lifeguard, mob/mob_possessor)
	. = ..()
	lifeguard.gender = FEMALE
	lifeguard.update_body()

/datum/outfit/beachbum
	name = "Beach Bum"
	glasses = /obj/item/clothing/glasses/sunglasses
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/food/pizzaslice/dank
	uniform = /obj/item/clothing/under/pants/youngfolksjeans
	id = /obj/item/card/id/advanced

/datum/outfit/beachbum/post_equip(mob/living/carbon/human/bum, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	bum.dna.add_mutation(/datum/mutation/human/stoner)

/datum/outfit/beachbum/lifeguard
	name = "Beach Lifeguard"
	uniform = /obj/item/clothing/under/shorts/red
	id_trim = /datum/id_trim/lifeguard

/obj/effect/mob_spawn/ghost_role/human/bartender
	name = "bartender sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "a space bartender"
	you_are_text = "You are a space bartender!"
	flavour_text = "Time to mix drinks and change lives. Smoking space drugs makes it easier to understand your patrons' odd dialect."
	spawner_job_path = /datum/job/space_bartender
	outfit = /datum/outfit/spacebartender

/datum/outfit/spacebartender
	name = "Space Bartender"
	uniform = /obj/item/clothing/under/rank/civilian/bartender
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/armor/vest
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/space_bartender

/datum/outfit/spacebartender/post_equip(mob/living/carbon/human/bartender, visualsOnly = FALSE)
	. = ..()
	var/obj/item/card/id/id_card = bartender.wear_id
	if(bartender.age < AGE_MINOR)
		id_card.registered_age = AGE_MINOR
		to_chat(bartender, span_notice("You're not technically old enough to access or serve alcohol, but your ID has been discreetly modified to display your age as [AGE_MINOR]. Try to keep that a secret!"))
