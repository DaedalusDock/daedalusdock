/datum/appearance_modifier
	var/name = "You shouldn't see this!"

	///If you don't want an appearance mod to be usable, use this.
	var/abstract_type = /datum/appearance_modifier
	///The icon that gets blended onto the base appearance. Generated in new()
	var/icon/my_icon = null
	var/icon2use = ""
	var/state2use = ""
	var/color = ""

	///The blend mode used to apply a color
	var/color_blend_func = ICON_MULTIPLY
	///A boolean value that determines if this mod is colorable or not.
	var/colorable = TRUE
	///The priority of this appearance. Higher priorities are blended before other ones. Set by client prefs.
	VAR_FINAL/priority = 0
	///The cache key for this icon. Dynamically generated on SetValues() call.
	VAR_FINAL/key = ""

	///A list of species that can equip this appearance mod in character creation
	var/list/species_can_use = list(
		SPECIES_HUMAN,
	)

	//The bodytypes this applies to. Generally BODYTYPE_HUMANOID
	var/bodytypes_affected = ALL
	//The bodyzones this applies to, BODY_ZONE_HEAD, etc.
	var/list/bodyzones_affected = list()
	//Does this apply to hands? Hate hand code.
	var/affects_hands = FALSE
	///The external organ slots this applies to. ORGAN_SLOT_EXTERNAL_TAIL, etc.
	var/list/eorgan_slots_affected = null
	var/eorgan_layers_affected = list(BODY_ADJ_LAYER, BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

	//Do not touch.
	VAR_FINAL/list/affecting_bodyparts = list()
	VAR_FINAL/list/affecting_organs = list()

	VAR_FINAL/setup_complete = FALSE

/datum/appearance_modifier/proc/SetValues(color, priority)
	my_icon = icon(icon(icon2use, state2use))
	if(color && colorable)
		src.color = color
		my_icon.Blend(color, color_blend_func)
	if(priority)
		src.priority = priority

	key = json_encode(list(icon2use, state2use, priority, color, color_blend_func))
	setup_complete = TRUE

/datum/appearance_modifier/Destroy(force, ...)
	for(var/obj/item/bodypart/BP as anything in affecting_bodyparts)
		BP.appearance_mods -= src
		sortTim(BP.appearance_mods, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

	for(var/obj/item/organ/O as anything in affecting_organs)
		O.appearance_mods -= src
		sortTim(O.appearance_mods, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

	affecting_bodyparts = null
	affecting_organs = null

	return ..()

///Blend our icon onto the target. This acts like BLEND_INSET_OVERLAY.
/datum/appearance_modifier/proc/BlendOnto(icon/I)
	var/icon/masked_icon = icon(my_icon)
	var/icon/masker = icon(I)
	masker.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1)
	masked_icon.Blend(masker, ICON_MULTIPLY)
	I.Blend(masked_icon, ICON_OVERLAY)

/datum/appearance_modifier/proc/ApplyToMob(mob/living/carbon/C)
	if(!setup_complete)
		CRASH("Tried to apply an incomplete appearance modifier!")

	if(bodytypes_affected && length(bodyzones_affected))
		ApplyToBodyparts(C.bodyparts)
	if(length(eorgan_slots_affected))
		ApplyToOrgans(C.cosmetic_organs)

/datum/appearance_modifier/proc/ApplyToBodyparts(list/bodyparts)
	if(!setup_complete)
		CRASH("Tried to apply an incomplete appearance modifier!")

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!(BP.bodytype & bodytypes_affected))
			continue
		if(!(BP.body_zone in bodyzones_affected))
			continue

		affecting_bodyparts += BP
		RegisterSignal(BP, COMSIG_PARENT_QDELETING, PROC_REF(bodypart_deleted))
		LAZYADDASSOC(BP.appearance_mods, src, priority)
		sortTim(BP.appearance_mods, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

/datum/appearance_modifier/proc/ApplyToOrgans(list/organs)
	if(!setup_complete)
		CRASH("Tried to apply an incomplete appearance modifier!")

	for(var/obj/item/organ/O as anything in organs)
		if(!(O.slot in eorgan_slots_affected))
			continue
		affecting_organs += O
		RegisterSignal(O, COMSIG_PARENT_QDELETING, PROC_REF(organ_deleted))
		LAZYADDASSOC(O.appearance_mods, src, priority)
		sortTim(O.appearance_mods, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

/datum/appearance_modifier/proc/bodypart_deleted(datum/source)
	SIGNAL_HANDLER
	affecting_bodyparts -= source

/datum/appearance_modifier/proc/organ_deleted(datum/source)
	SIGNAL_HANDLER
	affecting_organs -= source

/datum/appearance_modifier/goonlizardhead
	name = "Highlight - Goonhead"
	icon2use = 'goon/icons/mob/appearancemods/lizardmarks.dmi'
	state2use = "lighthead"

	species_can_use = list(SPECIES_LIZARD)
	bodytypes_affected = BODYTYPE_HUMANOID
	bodyzones_affected = list(BODY_ZONE_HEAD)
	eorgan_slots_affected = list(ORGAN_SLOT_EXTERNAL_SNOUT)

/datum/appearance_modifier/goonlizardbody
	name = "Highlight - Underside"
	icon2use = 'goon/icons/mob/appearancemods/lizardmarks.dmi'
	state2use = "lightunderside"

	species_can_use = list(SPECIES_LIZARD)
	bodytypes_affected = BODYTYPE_HUMANOID
	bodyzones_affected = list(BODY_ZONE_CHEST)

	eorgan_slots_affected = list(ORGAN_SLOT_EXTERNAL_TAIL)
	eorgan_layers_affected = list(BODY_BEHIND_LAYER)

/mob/living/carbon/proc/goonify()
	var/datum/appearance_modifier/goonlizardhead/head = new
	head.ApplyToMob(src)

	var/datum/appearance_modifier/goonlizardbody/body = new
	body.ApplyToMob(src)
