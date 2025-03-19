/obj/item/diagnosis_book
	name = "diagnosis book"
	icon = 'goon/icons/obj/kinginyellow.dmi'
	icon_state = "bookkiy"

	/// Static UI data
	var/static/list/static_data

	/// Data for the selected mob.
	var/list/selected_mob_data = list()
	var/list/selected_symptoms = list()

/obj/item/diagnosis_book/Initialize(mapload)
	. = ..()
	if(isnull(static_data))
		static_data = list()
		var/list/conditions = list()
		static_data["conditions"] = conditions
		var/list/symptoms = list()
		static_data["symptoms"] = symptoms
		var/list/symptom_categories = list()
		static_data["symptom_categories"] = symptom_categories

		for(var/datum/diagnosis_condition/condition_path as anything in subtypesof(/datum/diagnosis_condition))
			if(isabstract(condition_path))
				continue

			var/datum/diagnosis_condition/condition = new condition_path
			var/list/condition_packet = list()
			conditions[++conditions.len] = condition_packet

			condition_packet["name"] = condition.name
			condition_packet["desc"] = condition.desc
			condition_packet["treatment"] = condition.possible_treatment
			condition_packet["path"] = condition.type
			condition_packet["symptoms"] = list()

			for(var/datum/diagnosis_symptom/symptom as anything in condition.symptoms)
				condition_packet["symptoms"] += symptom.name

		for(var/datum/diagnosis_symptom/symptom_path as anything in subtypesof(/datum/diagnosis_symptom))
			if(isabstract(symptom_path))
				continue

			var/datum/diagnosis_symptom/symptom = new symptom_path
			var/list/symptom_packet = list()
			symptoms[++symptoms.len] = symptom_packet
			symptom_packet["name"] = symptom.name
			symptom_packet["desc"] = symptom.desc
			symptom_packet["category"] = symptom.category
			symptom_packet["path"] = symptom.type
			symptom_categories |= symptom.category

/obj/item/diagnosis_book/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiagnosisBook")
		ui.open()

/obj/item/diagnosis_book/ui_static_data(mob/user)
	return static_data

/obj/item/diagnosis_book/ui_data(mob/user)
	return list(
		"mob" = selected_mob_data,
		"selected_symptoms" = selected_symptoms
	)

/obj/item/diagnosis_book/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("cycle_symptom")
			var/datum/diagnosis_symptom/symptom_path = text2path(params["path"])
			if(isnull(symptom_path))
				return

			if(!ispath(symptom_path))
				CRASH("Bad symptom path: [symptom_path]")

			if(symptom_path in selected_symptoms)
				selected_symptoms -= symptom_path
			else
				selected_symptoms += symptom_path
			return TRUE

/obj/item/diagnosis_book/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return

	if(user.combat_mode)
		return

	if(!ishuman(A))
		return

	var/mob/living/carbon/human/target = A
	selected_mob_data = list()
	selected_mob_data["name"] = target.name
	selected_mob_data["time"] = stationtime2text("hh:mm")

	ui_interact(user)
	return TRUE
