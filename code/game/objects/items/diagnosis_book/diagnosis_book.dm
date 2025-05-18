/obj/item/diagnosis_book
	name = "Codex Infirmitas"
	desc = "A book containing information on diseases and disabilities."
	icon = 'icons/obj/library.dmi'
	icon_state ="bookdiagnosis"
	worn_icon_state = "book"

	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_NORMAL

	throw_range = 5

	/// Number of pages, just so you can't make infinite paper.
	var/pages_remaining = 20

	/// Static UI data
	var/static/list/static_data

	/// Byond UI screen object used by the interface
	var/atom/movable/screen/map_view/byondui/byondui_screen

	/// Data for the selected mob.
	var/list/selected_mob_data = list()
	var/list/selected_symptoms = list()

/obj/item/diagnosis_book/Initialize(mapload)
	. = ..()
	byondui_screen = new
	byondui_screen.generate_view("byondui_diagnosisbook_[ref(src)]")
	wipe_byondui()

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

/obj/item/diagnosis_book/Destroy(force)
	QDEL_NULL(byondui_screen)
	return ..()

/obj/item/diagnosis_book/ui_interact(mob/user, datum/tgui/ui)
	if(pages_remaining <= 0)
		to_chat(user, span_warning("There are no pages left."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiagnosisBook")
		ui.open()
		byondui_screen.render_to_tgui(user.client, ui.window)

/obj/item/diagnosis_book/ui_status(mob/user)
	// Even harder to read if your blind...braile? humm
	// .. or if you cannot read
	if(!user.can_read(src))
		return UI_CLOSE
	if(pages_remaining <= 0)
		return UI_CLOSE
	return ..()

/obj/item/diagnosis_book/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/diagnosis_book/ui_static_data(mob/user)
	return static_data

/obj/item/diagnosis_book/ui_data(mob/user)
	return list(
		"mob" = selected_mob_data,
		"selected_symptoms" = selected_symptoms,
		"map_ref" = byondui_screen.assigned_map,
	)

/obj/item/diagnosis_book/ui_close(mob/user)
	. = ..()
	byondui_screen?.hide_from_client(user.client)

/obj/item/diagnosis_book/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	if(pages_remaining <= 0)
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

		if("update_mob")
			if(params["name"])
				var/new_name = params["name"]
				if(length(new_name) > 32)
					return

				selected_mob_data["name"] = new_name
				return TRUE

			if(params["time"])
				var/new_time = params["time"]
				if(length(new_time) > 32)
					return

				selected_mob_data["time"] = new_time
				return TRUE

			if(params["occupation"])
				var/new_occupation = params["occupation"]
				if(length(new_occupation) > 32)
					return

				selected_mob_data["occupation"] = new_occupation
				return TRUE

			if(params["diagnosis"])
				var/new_diagnosis = params["diagnosis"]
				if(length(new_diagnosis) > 32)
					return

				selected_mob_data["diagnosis"] = new_diagnosis
				return TRUE

		if("diagnose")
			var/diagnosis = params["diagnosis"]
			if(!istext(diagnosis) || length(diagnosis) > 32)
				return

			if(!diagnose(ui.user, diagnosis))
				return FALSE

			selected_mob_data = list()
			selected_symptoms = list()
			wipe_byondui()
			return TRUE

/obj/item/diagnosis_book/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return

	if(user.combat_mode)
		return

	if(!ishuman(A))
		return

	if(pages_remaining <= 0)
		return

	var/mob/living/carbon/human/target = A
	selected_mob_data = list()
	selected_mob_data["name"] = target.name
	selected_mob_data["time"] = stationtime2text("hh:mm")

	var/obj/item/card/id/id_card = target.get_idcard()
	if(id_card)
		selected_mob_data["occupation"] = id_card.assignment

	var/mutable_appearance/character_appearance = new(A.appearance)
	remove_non_canon_overlays(character_appearance)

	var/matrix/new_transform = matrix()
	new_transform.Scale(2, 2)
	new_transform.Translate(1, -16)

	character_appearance.transform = new_transform
	character_appearance.dir = SOUTH

	byondui_screen.rendered_atom.appearance = character_appearance.appearance

	ui_interact(user)
	return TRUE

/// Set the byondui appearance to a "No Image" icon.
/obj/item/diagnosis_book/proc/wipe_byondui()
	var/image/I = image('icons/hud/noimg.dmi', "png")
	var/matrix/new_transform = matrix()
	new_transform.Scale(2, 2)
	new_transform.Translate(1, -16)

	I.transform = new_transform
	I.color = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))

	byondui_screen.rendered_atom.appearance = I.appearance

/obj/item/diagnosis_book/proc/diagnose(mob/user, diagnosis)
	if(!user.get_empty_held_index())
		to_chat(user, span_warning("You require a free hand to tear out a page."))
		return FALSE

	var/list/symptom_text = list()
	for(var/datum/diagnosis_symptom/symptom_path as anything in selected_symptoms)
		symptom_text += "<li>[initial(symptom_path.name)]</li>"

	symptom_text = jointext(symptom_text, "") || "<li>N/A</li>"

	var/info = {"
		<span style="color: #000000; font-family: 'Verdana';">
		<p>
			Patient Name = \[<input disabled="" id="paperfield_1" style="color: rgb(0, 0, 0); font-family: Verdana; min-width: 180px; max-width: 180px;" type="text" size="15" maxlength="15" value="[selected_mob_data["name"]]" />\]<br />
			Patient Occupation = \[<input disabled="" id="paperfield_2" style="color: rgb(0, 0, 0); font-family: Verdana; min-width: 180px; max-width: 180px;" type="text" size="15" maxlength="15" value="[selected_mob_data["occupation"]]" />\]<br />
			Time of Day = \[<input disabled="" id="paperfield_3" style="color: rgb(0, 0, 0); font-family: Verdana; min-width: 180px; max-width: 180px;" type="text" size="15" maxlength="15" value="[selected_mob_data["time"]]" />\]
		</p>
		<p>Symptoms:</p>
		<ul>
			[symptom_text]
		</ul>
		<p>Diagnosis: \[<input disabled="" id="paperfield_4" style="color: rgb(0, 0, 0); font-family: Verdana; min-width: 180px; max-width: 180px;" type="text" size="15" maxlength="15" value="[diagnosis]" />\]</p>
		<p>Physician: \[<input disabled="" id="paperfield_5" style="color: rgb(0, 0, 0); font-family: Times New Roman; font-style: italic; font-weight: bold; min-width: 116px; max-width: 116px;" type="text" size="15" maxlength="15" value="[user.real_name]" />\]</p>
		</span>
	"}

	pages_remaining--
	var/obj/item/paper/page = new()
	page.setText(info)

	if(!user.put_in_hands(page))
		page.forceMove(drop_location())

	playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)
	user.visible_message(span_notice("[user] tears a page out of [src]."))
	return TRUE
