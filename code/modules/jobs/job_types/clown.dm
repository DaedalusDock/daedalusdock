/datum/job/clown
	title = JOB_CLOWN
	description = "Entertain the crew, make bad jokes, go on a holy quest to find bananium, HONK!"
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/none
	)

	alt_titles = list("Mime")
	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/clown,
			SPECIES_PLASMAMAN = /datum/outfit/job/clown/plasmaman,
		),
		"Mime" = list(
			SPECIES_HUMAN = /datum/outfit/job/mime,
			SPECIES_PLASMAMAN = /datum/outfit/job/mime/plasmaman,
		),
	)

	liver_traits = list(TRAIT_COMEDY_METABOLISM)

	departments_list = list(
		/datum/job_department/service,
	)

	mail_goodies = list(
		/obj/item/food/grown/banana = 100,
		/obj/item/food/pie/cream = 50,
		/obj/item/clothing/shoes/clown_shoes/combat = 10,
		/obj/item/reagent_containers/spray/waterflower/lube = 20, // lube
		/obj/item/reagent_containers/spray/waterflower/superlube = 1 // Superlube, good lord.
	)

	family_heirlooms = list(/obj/item/bikehorn/golden)
	rpg_title = "Jester"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/job/clown/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(!ishuman(spawned))
		return

	spawned.apply_pref_name(/datum/preference/name/clown)

/datum/outfit/job/clown
	name = "Clown"
	jobtype = /datum/job/clown

	id_trim = /datum/id_trim/job/clown
	uniform = /obj/item/clothing/under/rank/civilian/clown
	backpack_contents = list(
		/obj/item/stamp/clown = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/instrument/bikehorn = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/clown
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/bikehorn

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	duffelbag = /obj/item/storage/backpack/duffelbag/clown //strangely has a duffel

	box = /obj/item/storage/box/hug/survival
	chameleon_extras = /obj/item/stamp/clown
	implants = list(/obj/item/implant/sad_trombone)

/datum/outfit/job/clown/plasmaman
	name = "Clown (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/clown
	gloves = /obj/item/clothing/gloves/color/plasmaman/clown
	head = /obj/item/clothing/head/helmet/space/plasmaman/clown
	mask = /obj/item/clothing/mask/gas/clown_hat/plasmaman
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/clown/mod
	name = "Clown (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/cosmohonk
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

/datum/outfit/job/clown/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		backpack_contents[/obj/item/stack/sheet/mineral/bananium/five] = 1

/datum/outfit/job/clown/get_types_to_preload()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		. += /obj/item/stack/sheet/mineral/bananium/five

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	H.fully_replace_character_name(H.real_name, pick(GLOB.clown_names)) //rename the mob AFTER they're equipped so their ID gets updated properly.
	ADD_TRAIT(H, TRAIT_NAIVE, JOB_TRAIT)
	H.dna.add_mutation(/datum/mutation/human/clumsy)

	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.ryetalyn_proof = TRUE

/datum/outfit/job/mime
	name = "Mime"
	jobtype = /datum/job/clown

	id_trim = /datum/id_trim/job/mime
	uniform = /obj/item/clothing/under/rank/civilian/mime
	suit = /obj/item/clothing/suit/toggle/suspenders
	backpack_contents = list(
		/obj/item/book/mimery = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 1,
		/obj/item/stamp/mime = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/mime
	ears = /obj/item/radio/headset/headset_srv
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/frenchberet
	mask = /obj/item/clothing/mask/gas/mime
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack/mime
	satchel = /obj/item/storage/backpack/mime

	chameleon_extras = /obj/item/stamp/mime

/datum/outfit/job/mime/plasmaman
	name = "Mime (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/mime
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/mime
	mask = /obj/item/clothing/mask/gas/mime/plasmaman
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.miming = TRUE

/obj/item/book/mimery
	name = "Guide to Dank Mimery"
	desc = "Teaches one of three classic pantomime routines, allowing a practiced mime to conjure invisible objects into corporeal existence. One use only."
	icon_state = "bookmime"

/obj/item/book/mimery/attack_self(mob/user)
	. = ..()
	if(.)
		return

	var/list/spell_icons = list(
		"Invisible Wall" = image(icon = 'icons/mob/actions/actions_mime.dmi', icon_state = "invisible_wall"),
		"Invisible Chair" = image(icon = 'icons/mob/actions/actions_mime.dmi', icon_state = "invisible_chair"),
		"Invisible Box" = image(icon = 'icons/mob/actions/actions_mime.dmi', icon_state = "invisible_box")
		)
	var/picked_spell = show_radial_menu(user, src, spell_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	var/datum/action/cooldown/spell/picked_spell_type
	switch(picked_spell)
		if("Invisible Wall")
			picked_spell_type = /datum/action/cooldown/spell/conjure/invisible_wall

		if("Invisible Chair")
			picked_spell_type = /datum/action/cooldown/spell/conjure/invisible_chair

		if("Invisible Box")
			picked_spell_type = /datum/action/cooldown/spell/conjure_item/invisible_box

	if(ispath(picked_spell_type))
		// Gives the user a vow ability too, if they don't already have one
		var/datum/action/cooldown/spell/vow_of_silence/vow = locate() in user.actions
		if(!vow && user.mind)
			vow = new(user.mind)
			vow.Grant(user)

		picked_spell_type = new picked_spell_type(user.mind || user)
		picked_spell_type.Grant(user)

		to_chat(user, span_warning("The book disappears into thin air."))
		qdel(src)

	return TRUE

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The human mob interacting with the menu
 */
/obj/item/book/mimery/proc/check_menu(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(!user.is_holding(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!user.mind)
		return FALSE
	return TRUE
