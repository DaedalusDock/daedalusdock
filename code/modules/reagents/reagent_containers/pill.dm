/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A tablet or capsule."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill"
	inhand_icon_state = "pill"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	possible_transfer_amounts = list()
	volume = 50
	grind_results = list()
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/rename_with_volume = FALSE
	var/self_delay = 0 //pills are instant, this is because patches inheret their aplication from pills
	var/other_delay = 3 SECONDS
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && rename_with_volume)
		name += " ([reagents.total_volume]u)"

/obj/item/reagent_containers/pill/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		M.visible_message(span_notice("[user] attempts to [apply_method] [src]."))
		if(self_delay)
			if(!do_after(user, M, self_delay))
				return FALSE
		to_chat(M, span_notice("You [apply_method] [src]."))

	else
		M.visible_message(
			span_danger("[user] attempts to force [M] to [apply_method] [src]."),
			span_userdanger("[user] attempts to force you to [apply_method] [src].")
		)

		if(!do_after(user, M, CHEM_INTERACT_DELAY(other_delay, user), DO_PUBLIC, display = src))
			return FALSE

		M.visible_message(
			span_danger("[user] forces [M] to [apply_method] [src]."),
			span_userdanger("[user] forces you to [apply_method] [src].")
		)

	return consume(M, user)

/// Consume the pill.
/obj/item/reagent_containers/pill/proc/consume(mob/M, mob/user)
	. = on_consumption(M, user)
	qdel(src)

///Runs the consumption code, can be overriden for special effects
/obj/item/reagent_containers/pill/proc/on_consumption(mob/M, mob/user)
	M.playsound_local(get_turf(M), 'sound/effects/swallow.ogg', 50)
	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), M	, span_notice("[pick(strings(REDPILL_FILE, "redpill_questions"))]")), 50)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = apply_type)
	return TRUE


/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, span_warning("[target] is empty! There's nothing to dissolve [src] in."))
		return

	if(target.reagents.holder_full())
		to_chat(user, span_warning("[target] is full."))
		return

	user.visible_message(span_warning("[user] slips something into [target]!"), span_notice("You dissolve [src] in [target]."), null, 2)
	reagents.trans_to(target, reagents.total_volume, transfered_by = user)
	qdel(src)

/*
 * On accidental consumption, consume the pill
 */
/obj/item/reagent_containers/pill/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item, discover_after = FALSE)
	to_chat(victim, span_warning("You swallow something small. [source_item ? "Was that in [source_item]?" : ""]"))
	reagents?.trans_to(victim, reagents.total_volume, transfered_by = user, methods = INGEST)
	qdel(src)
	return discover_after

/obj/item/reagent_containers/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/cyanide
	name = "cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin/cyanide = 50)

/obj/item/reagent_containers/pill/adminordrazine
	name = "adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 50)

/obj/item/reagent_containers/pill/morphine
	name = "morphine pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/morphine = 30)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/stimulant
	name = "stimulant pill"
	desc = "Often taken by overworked employees, athletes, and the inebriated. You'll snap to attention immediately!"
	icon_state = "pill19"
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/medicine/antihol = 10, /datum/reagent/consumable/coffee = 30)

/obj/item/reagent_containers/pill/dexalin
	name = "dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/dexalin = 30)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/dylovene
	name = "dylovene pill"
	desc = "Helps counteract nervous system damage induced by toxins."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/dylovene = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/epinephrine
	name = "epinephrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 15)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/alkysine
	name = "alkysine pill"
	desc = "Used to treat brain damage."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/alkysine = 14)
	rename_with_volume = TRUE

//Lower quantity alkysine pills (50u pills heal 250 brain damage, 5u pills heal 25)
/obj/item/reagent_containers/pill/alkysine/braintumor
	desc = "Used to treat symptoms for brain tumors."
	list_reagents = list(/datum/reagent/medicine/alkysine = 5)

/obj/item/reagent_containers/pill/ryetalyn
	name = "ryetalyn pill"
	desc = "Used to treat genetic damage."
	icon_state = "pill20"
	list_reagents = list(/datum/reagent/medicine/ryetalyn = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/insulin
	name = "insulin pill"
	desc = "Handles hyperglycaemic coma."
	icon_state = "pill18"
	list_reagents = list(/datum/reagent/medicine/insulin = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/alkysine
	name = "alkysine pill"
	desc = "Used to treat non-severe mental traumas."
	list_reagents = list(/datum/reagent/medicine/alkysine = 10)
	icon_state = "pill22"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/ipecac
	name = "ipecac pill"
	desc = "Used to purge the stomach of reagents."
	list_reagents = list(/datum/reagent/medicine/ipecac = 5)
	icon_state = "pill22"
	rename_with_volume = TRUE

///////////////////////////////////////// this pill is used only in a legion mob drop
/obj/item/reagent_containers/pill/shadowtoxin
	name = "black pill"
	desc = "I wouldn't eat this if I were you."
	icon_state = "pill9"
	color = "#454545"
	list_reagents = list(/datum/reagent/mutationtoxin/shadow = 5)

///////////////////////////////////////// Psychologist inventory pills

/obj/item/reagent_containers/pill/paxpsych
	name = "pacification pill"
	desc = "Used to temporarily suppress violent, homicidal, or suicidal behavior in patients."
	list_reagents = list(/datum/reagent/pax = 5)
	icon_state = "pill12"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/lsdpsych
	name = "antipsychotic pill"
	desc = "Talk to your healthcare provider immediately if hallucinations worsen or new hallucinations emerge."
	list_reagents = list(/datum/reagent/medicine/chlorpromazine = 5)
	icon_state = "pill14"
	rename_with_volume = TRUE

//////////////////////////////////////// drugs
/obj/item/reagent_containers/pill/zoom
	name = "yellow pill"
	desc = "A poorly made canary-yellow pill; it is slightly crumbly."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 10, /datum/reagent/drug/nicotine = 10, /datum/reagent/drug/methamphetamine = 1)
	icon_state = "pill7"


/obj/item/reagent_containers/pill/happy
	name = "happy pill"
	desc = "They have little happy faces on them, and they smell like marker pens."
	list_reagents = list(/datum/reagent/consumable/sugar = 10, /datum/reagent/drug/space_drugs = 10)
	icon_state = "pill_happy"


/obj/item/reagent_containers/pill/lsd
	name = "sunshine pill"
	desc = "Engraved on this split-coloured pill is a half-sun, half-moon."
	list_reagents = list(/datum/reagent/drug/mushroomhallucinogen = 15, /datum/reagent/toxin/mindbreaker = 15)
	icon_state = "pill14"


/obj/item/reagent_containers/pill/aranesp
	name = "smooth pill"
	desc = "This blue pill feels slightly moist."
	list_reagents = list(/datum/reagent/drug/aranesp = 10)
	icon_state = "pill3"

///Black and white pills that spawn in maintenance and have random reagent contents
/obj/item/reagent_containers/pill/maintenance
	name = "maintenance pill"
	desc = "A strange pill found in the depths of maintenance."
	icon_state = "pill21"
	var/static/list/names = list("maintenance pill", "floor pill", "mystery pill", "suspicious pill", "strange pill", "lucky pill", "ominous pill", "eerie pill")
	var/static/list/descs = list("Your feeling is telling you no, but...","Drugs are expensive, you can't afford not to eat any pills that you find."\
	, "Surely, there's no way this could go bad.", "Winners don't do dr- oh what the heck!", "Free pills? At no cost, how could I lose?")

/obj/item/reagent_containers/pill/maintenance/Initialize(mapload)
	list_reagents = list(get_random_reagent_id() = rand(10,50)) //list_reagents is called before init, because init generates the reagents using list_reagents
	. = ..()
	name = pick(names)
	if(prob(30))
		desc = pick(descs)

/obj/item/reagent_containers/pill/maintenance/achievement/on_consumption(mob/M, mob/user)
	. = ..()

	M.client?.give_award(/datum/award/score/maintenance_pill, M)

/obj/item/reagent_containers/pill/potassiodide
	name = "potassium iodide pill"
	desc = "Used to reduce low radiation damage very effectively."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 15)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/bicaridine
	name = "bicaridine pill"
	desc = "Used to treat minor physical trauma. The carving in the pill says 'Eat before ingesting'."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/bicaridine = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/meralyne
	name = "meralyne pill"
	desc = "Used to treat brute damage of minor and moderate severity. The carving in the pill says 'Eat before ingesting'."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/meralyne = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/kelotane
	name = "kelotane pill"
	desc = "Used to treat minor burns. The carving in the pill says 'Eat before ingesting'."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/kelotane = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/dermaline
	name = "dermaline pill"
	desc = "Used to treat second and third degree burns. The carving in the pill says 'Eat before ingesting'."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/dermaline = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/iron
	name = "iron pill"
	desc = "Used to reduce bloodloss slowly."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/iron = 30)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/haloperidol
	name = "haloperidol pill"
	desc = "Used to treat drug abuse and psychosis."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/haloperidol = 5)
	rename_with_volume = TRUE
