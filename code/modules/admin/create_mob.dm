
/datum/admins/proc/create_mob(mob/user)
	var/static/create_mob_html
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "Create Object", "Create Mob")
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(create_panel_helper(create_mob_html), "window=create_mob;size=425x475")

/proc/randomize_human(mob/living/carbon/human/H)
	H.gender = pick(MALE, FEMALE)
	H.physique = H.gender
	H.set_real_name(random_unique_name(H.gender))
	H.name = H.real_name
	H.underwear = random_underwear(H.gender)
	H.underwear_color = "#[random_color()]"
	H.skin_tone = random_skin_tone()

	var/obj/item/bodypart/head/myhead = H.get_bodypart(BODY_ZONE_HEAD)
	if(!myhead)
		H.hairstyle = "Bald"
	else if (myhead.legal_hairstyles == GLOB.hairstyles_list)
		H.hairstyle = random_hairstyle(H.gender)
	else
		H.hairstyle = pick(myhead.legal_hairstyles)

	H.facial_hairstyle = random_facial_hairstyle(H.gender)
	H.hair_color = "#[random_color()]"
	H.facial_hair_color = H.hair_color

	var/random_eye_color = random_eye_color()
	H.eye_color_left = random_eye_color
	H.eye_color_right = random_eye_color

	H.dna.blood_type = H.dna.species.get_random_blood_type()

	// Mutant randomizing, doesn't affect the mob appearance unless it's the specific mutant.
	H.dna.mutant_colors = random_mutant_colors()
	H.dna.features = random_features()

	H.update_body(is_creating = TRUE)
