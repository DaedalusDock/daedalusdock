/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Must be attached to an IV drip."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200

	reagent_flags = INJECTABLE | DRAWABLE | TRANSPARENT
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

	/// /datum/blood typepath or a string for the label.
	var/blood_type = null
	/// Reagent type to use instead of /datum/reagent/blood
	var/unique_blood = null

/obj/item/reagent_containers/blood/Initialize(mapload)
	. = ..()
	var/datum/blood/blood_ref = GET_BLOOD_REF(blood_type)
	if(blood_ref)
		reagents.add_reagent(unique_blood || /datum/reagent/blood, 200, list("viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))

	else if(unique_blood)
		reagents.add_reagent(unique_blood, 200, list("viruses"=null,"blood_DNA"=null,"resistances"=null,"trace_chem"=null))

	if(blood_ref)
		name = "blood pack - [blood_ref.name]"
	else
		name = "blood pack[blood_type ? " - [blood_type]" : null]"

/obj/item/reagent_containers/blood/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (istype(tool, /obj/item/pen) || istype(tool, /obj/item/toy/crayon))
		if(!user.is_literate())
			to_chat(user, span_notice("You scribble illegibly on the label of [src]."))
			return ITEM_INTERACT_BLOCKING

		var/custom_label = tgui_input_text(user, "What would you like to label the blood pack?", "Blood Pack", name, MAX_NAME_LEN)
		if(!user.canUseTopic(src, USE_CLOSE) || user.get_active_held_item() != tool)
			return ITEM_INTERACT_BLOCKING

		if(!do_after(user, src, 2 SECONDS, DO_IGNORE_SLOWDOWNS|DO_IGNORE_USER_LOC_CHANGE|DO_PUBLIC, display = tool))
			return ITEM_INTERACT_BLOCKING

		if(!user.canUseTopic(src, USE_CLOSE) || user.get_active_held_item() != tool)
			return ITEM_INTERACT_BLOCKING

		if(custom_label)
			name = "blood pack - [custom_label]"
		return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/blood/random
	icon_state = "random_bloodpack"

/obj/item/reagent_containers/blood/random/Initialize(mapload)
	icon_state = "bloodpack"
	blood_type = astype(pick(GLOB.blood_datums), /datum/blood)
	return ..()

/obj/item/reagent_containers/blood/a_plus
	blood_type = /datum/blood/human/apos

/obj/item/reagent_containers/blood/a_minus
	blood_type = /datum/blood/human/amin

/obj/item/reagent_containers/blood/b_plus
	blood_type = /datum/blood/human/bpos

/obj/item/reagent_containers/blood/b_minus
	blood_type = /datum/blood/human/bmin

/obj/item/reagent_containers/blood/o_plus
	blood_type = /datum/blood/human/opos

/obj/item/reagent_containers/blood/o_minus
	blood_type = /datum/blood/human/omin

/obj/item/reagent_containers/blood/lizard
	blood_type = /datum/blood/lizard

/obj/item/reagent_containers/blood/ethereal
	blood_type = "LE"
	unique_blood = /datum/reagent/consumable/liquidelectricity

/obj/item/reagent_containers/blood/universal
	blood_type = /datum/blood/universal
