/datum/appearance_modifier
	var/name = "You shouldn't see this!"

	///The icon that gets blended onto the base appearance. Generated in new()
	var/icon/my_icon = null
	var/icon2use = ""
	var/state2use = ""
	var/color = ""
	///The cache key for this icon
	var/key = ""
	///The Blend() function used by this appearance.
	var/blend_func = ICON_OVERLAY
	///The blend mode used to apply a color
	var/color_blend_func = ICON_OVERLAY
	///The priority of this appearance. Higher priorities are blended before other ones.
	var/priority = 0

	var/bodytypes_affected = ALL
	var/list/bodyzones_affected = list()
	//Does this apply to hands? Hate hand code.
	var/affects_hands = FALSE

	var/list/eorgan_slots_affected = null
	var/eorgan_layers_affected = ALL_EXTERNAL_OVERLAYS

	var/list/affecting_bodyparts = list()
	var/list/affecting_organs = list()

/datum/appearance_modifier/New(color, priority)
	my_icon = icon(icon(icon2use, state2use))
	if(color)
		src.color = color
		my_icon.Blend(color, color_blend_func)
	if(priority)
		src.priority = priority

	key = json_encode(list(icon2use, state2use, priority, color, blend_func, color_blend_func))


/datum/appearance_modifier/Destroy(force, ...)
	if(!force)
		stack_trace("Someone is trying to delete an appearance modifier!")
		return
	for(var/obj/item/bodypart/BP as anything in affecting_bodyparts)
		BP.appearance_mods -= src
		sortTim(BP.appearance_mods, /proc/cmp_numeric_asc, TRUE)

	for(var/obj/item/organ/external/O as anything in affecting_bodyparts)
		O.appearance_mods -= src
		sortTim(O.appearance_mods, /proc/cmp_numeric_asc, TRUE)

	affecting_bodyparts = null
	affecting_organs = null

	return ..()

/datum/appearance_modifier/proc/BlendOnto(icon/I)
	var/icon/masked_icon = icon(my_icon)
	var/icon/masker = icon(I)
	var/i = 0
	masker.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1)
	masked_icon.Blend(masker, ICON_MULTIPLY)
	I.Blend(masked_icon, ICON_OVERLAY)
	if(i)
		fcopy(masked_icon, "data/blenddebug/masked.dmi")
		fcopy(I, "data/blenddebug/final.dmi")

/datum/appearance_modifier/proc/applyToMob(mob/living/carbon/C)
	if(bodytypes_affected && length(bodyzones_affected))
		applyToBodyparts(C.bodyparts)
	if(length(eorgan_slots_affected))
		applyToOrgans(C.external_organs)
	C.update_body_parts()

/datum/appearance_modifier/proc/applyToBodyparts(list/bodyparts)
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!(BP.bodytype & bodytypes_affected))
			continue
		if(!(BP.body_zone in bodyzones_affected))
			continue

		affecting_bodyparts += BP
		RegisterSignal(BP, COMSIG_PARENT_QDELETING, .proc/bodypart_deleted)
		LAZYADDASSOC(BP.appearance_mods, src, priority)
		sortTim(BP.appearance_mods, /proc/cmp_numeric_asc, TRUE)

/datum/appearance_modifier/proc/applyToOrgans(list/organs)
	for(var/obj/item/organ/external/O as anything in organs)
		if(!(O.slot in eorgan_slots_affected))
			continue
		affecting_organs += O
		RegisterSignal(O, COMSIG_PARENT_QDELETING, .proc/organ_deleted)
		LAZYADDASSOC(O.appearance_mods, src, priority)
		sortTim(O.appearance_mods, /proc/cmp_numeric_asc, TRUE)

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

	bodytypes_affected = BODYTYPE_HUMANOID
	bodyzones_affected = list(BODY_ZONE_HEAD)
	eorgan_slots_affected = list(ORGAN_SLOT_EXTERNAL_SNOUT)


/datum/appearance_modifier/goonlizardbody
	name = "Highlight - Underside"
	icon2use = 'goon/icons/mob/appearancemods/lizardmarks.dmi'
	state2use = "lightunderside"

	bodytypes_affected = BODYTYPE_HUMANOID
	bodyzones_affected = list(BODY_ZONE_CHEST)

	eorgan_slots_affected = list(ORGAN_SLOT_EXTERNAL_TAIL)
	eorgan_layers_affected = EXTERNAL_BEHIND

/mob/living/carbon/proc/goonify()
	var/datum/appearance_modifier/goonlizardhead/head = new
	head.applyToMob(src)

	var/datum/appearance_modifier/goonlizardbody/body = new
	body.applyToMob(src)
