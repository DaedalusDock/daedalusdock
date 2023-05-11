
GLOBAL_REAL_VAR(layer2text) = list(
	"[BODY_BEHIND_LAYER]" = "BEHIND",
	"[BODY_ADJ_LAYER]" = "ADJ",
	"[BODY_FRONT_LAYER]" = "FRONT",
)

GLOBAL_LIST_EMPTY(organ_overlays_cache)

/obj/item/organ
	///Sometimes we need multiple layers, for like the back, middle and front of the person
	var/list/layers

	///Defines what kind of 'organ' we're looking at. Sprites have names like 'm_mothwings_firemoth'. 'mothwings' would then be feature_key
	var/feature_key = ""
	///Similar to feature key, but overrides it in the case you need more fine control over the iconstate, like with Tails.
	var/render_key = ""
	///Stores the dna.features[feature_key], used for external organs that can be surgically removed or inserted.
	var/stored_feature_id = ""
	/// The savefile_key of the preference this relates to. Used for the preferences UI.
	var/preference

	///Sprite datum we use to draw on the bodypart
	var/datum/sprite_accessory/sprite_datum

	///With what DNA block do we mutate in mutate_feature() ? For genetics
	var/dna_block

	///Reference to the limb we're inside of
	var/obj/item/bodypart/ownerlimb

	///The color this organ draws with. Updated by bodypart/inherit_color()
	var/draw_color

	///Where does this organ inherit it's color from?
	var/color_source = ORGAN_COLOR_INHERIT

	///Used by ORGAN_COLOR_INHERIT_ALL, allows full control of the owner's mutcolors
	var/list/mutcolors = list()
	///See above
	var/mutcolor_used

	///Does this organ have any bodytypes to pass to it's ownerlimb?
	var/external_bodytypes = NONE

	//A lazylist of this organ's appearance_modifier datums
	var/list/appearance_mods

///Add the overlays we need to draw on a person. Called from _bodyparts.dm
/obj/item/organ/proc/get_overlays(physique, image_dir)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = list()
	if(!stored_feature_id)
		return

	set_sprite(stored_feature_id)
	if(!sprite_datum)
		CRASH("No sprite datum found for [type]")

	if(sprite_datum.name == "None")
		return

	. = build_overlays(physique, image_dir)

	var/cache_key = json_encode(build_cache_key())
	if(GLOB.organ_overlays_cache[cache_key])
		return GLOB.organ_overlays_cache[cache_key]

	GLOB.organ_overlays_cache[cache_key] = .
	return .

/// Build overlays
/obj/item/organ/proc/build_overlays(physique, image_dir)
	RETURN_TYPE(/list)
	. = list()
	var/icon/finished_icon = build_icon(physique)
	for(var/image_layer in layers)

		var/image/overlay = image(finished_icon, global.layer2text["[image_layer]"], layer = -image_layer, dir = image_dir)

		if(sprite_datum.center)
			center_image(overlay, sprite_datum.dimension_x, sprite_datum.dimension_y)

		. += overlay

	return .

/obj/item/organ/proc/build_icon_state(physique, image_layer)
	var/gender = (physique == FEMALE) ? "f" : "m"
	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	icon_state_builder += render_key ? render_key : feature_key
	icon_state_builder += sprite_datum.icon_state
	icon_state_builder += global.layer2text["[image_layer]"]
	return icon_state_builder.Join("_")

/obj/item/organ/proc/build_icon(physique)
	RETURN_TYPE(/icon)
	PRIVATE_PROC(TRUE)

	var/dump_error = FALSE

	var/icon/return_icon = icon()
	for(var/image_layer in layers)
		var/finished_icon_state = build_icon_state(physique, image_layer)
		var/layer_text = global.layer2text["[image_layer]"]

		if(!icon_exists(sprite_datum.icon, finished_icon_state))
			stack_trace("Organ state layer [layer_text] missing from [sprite_datum.type]!")
			dump_error = TRUE

		var/icon/temp_icon = icon(sprite_datum.icon, finished_icon_state)
		if(sprite_datum.color_src && draw_color)
			temp_icon.Blend(draw_color, ICON_MULTIPLY)

		for(var/datum/appearance_modifier/mod as anything in appearance_mods)
			if(image_layer in mod.eorgan_layers_affected)
				mod.BlendOnto(temp_icon)
		return_icon.Insert(temp_icon, layer_text)

	if(dump_error)
		if(fexists("data/blenddebug/[sprite_datum.name].dmi"))
			fdel("data/blenddebug/[sprite_datum.name].dmi")
		fcopy(return_icon, "data/blenddebug/[sprite_datum.name].dmi")
	return return_icon

///Generate a unique key based on our sprites. So that if we've aleady drawn these sprites, they can be found in the cache and wont have to be drawn again (blessing and curse)
/obj/item/organ/proc/build_cache_key()
	. = list()
	if(owner && !can_draw_on_bodypart(owner))
		. += "HIDDEN"
		return .

	. += "[sprite_datum?.icon_state]"
	. += "[render_key ? render_key : feature_key]"
	if(color_source == ORGAN_COLOR_INHERIT_ALL)
		. += "color1:[mutcolors["[mutcolor_used]_1"]]"
		. += "color2:[mutcolors["[mutcolor_used]_2"]]"
		. += "color3:[mutcolors["[mutcolor_used]_3"]]"
	else
		. += "[draw_color]"
	for(var/datum/appearance_modifier/mod as anything in appearance_mods)
		. += mod.key
	return .
