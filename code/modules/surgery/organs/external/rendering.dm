GLOBAL_LIST_INIT(bitflag2layer, list(
	"[EXTERNAL_BEHIND]" = BODY_BEHIND_LAYER,
	"[EXTERNAL_ADJACENT]" = BODY_ADJ_LAYER,
	"[EXTERNAL_FRONT]" = BODY_FRONT_LAYER,

))
GLOBAL_LIST_INIT(layer2text, list(
	"[BODY_BEHIND_LAYER]" = "BEHIND",
	"[BODY_ADJ_LAYER]" = "ADJ",
	"[BODY_FRONT_LAYER]" = "FRONT",
))

GLOBAL_LIST_INIT(bitflag2text, list(
	"[EXTERNAL_BEHIND]" = "BEHIND",
	"[EXTERNAL_ADJACENT]" = "ADJ",
	"[EXTERNAL_FRONT]" = "FRONT",

))

///Add the overlays we need to draw on a person. Called from _bodyparts.dm
/obj/item/organ/external/proc/get_overlays(physique, image_dir)
	RETURN_TYPE(/list)
	. = list()
	if(!stored_feature_id)
		return

	set_sprite(stored_feature_id)
	if(!sprite_datum)
		CRASH("No sprite datum found for [type]")

	if(sprite_datum.name == "None")
		return

	var/icon/finished_icon = build_icon(physique)
	for(var/image_layer in all_layers)
		if(!(src.layers & image_layer))
			continue
		var/true_layer = GLOB.bitflag2layer["[image_layer]"]
		var/state = GLOB.layer2text["[true_layer]"]

		var/mutable_appearance/appearance = mutable_appearance(finished_icon, state, layer = -true_layer)
		appearance.dir = image_dir

		if(sprite_datum.center)
			center_image(appearance, sprite_datum.dimension_x, sprite_datum.dimension_y)

		. += appearance
	return .

/obj/item/organ/external/proc/build_icon_state(physique, image_layer)
	var/ender = GLOB.bitflag2text["[image_layer]"]
	var/gender = (physique == FEMALE) ? "f" : "m"
	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	icon_state_builder += render_key ? render_key : feature_key
	icon_state_builder += sprite_datum.icon_state
	icon_state_builder += ender
	return icon_state_builder.Join("_")

/obj/item/organ/external/proc/build_icon(physique)
	RETURN_TYPE(/icon)
	PRIVATE_PROC(TRUE)

	var/dump_error = FALSE

	var/icon/return_icon = icon()
	for(var/image_layer in all_layers)
		if(!(layers & image_layer))
			continue
		var/ender = GLOB.bitflag2text["[image_layer]"]

		var/finished_icon_state = build_icon_state(physique, image_layer)

		if(!icon_exists(sprite_datum.icon, finished_icon_state))
			stack_trace("Organ state [ender] missing from [sprite_datum.type]!")
			dump_error = TRUE

		var/icon/temp_icon = icon(sprite_datum.icon, finished_icon_state)
		if(sprite_datum.color_src && draw_color)
			temp_icon.Blend(draw_color, ICON_MULTIPLY)

		for(var/datum/appearance_modifier/mod as anything in appearance_mods)
			if(mod.eorgan_layers_affected & image_layer)
				mod.BlendOnto(temp_icon)
		return_icon.Insert(temp_icon, ender)

	if(dump_error)
		if(fexists("data/blenddebug/[sprite_datum.name].dmi"))
			fdel("data/blenddebug/[sprite_datum.name].dmi")
		fcopy(return_icon, "data/blenddebug/[sprite_datum.name].dmi")
	return return_icon

///Generate a unique key based on our sprites. So that if we've aleady drawn these sprites, they can be found in the cache and wont have to be drawn again (blessing and curse)
/obj/item/organ/external/proc/generate_icon_cache()
	. = list()
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
