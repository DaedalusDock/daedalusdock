GLOBAL_LIST_EMPTY(bloody_item_images)
/datum/element/decal/blood

/datum/element/decal/blood/Attach(datum/target, _icon, _icon_state, _dir, _plane, _layer, _alpha, _color, _smoothing, _cleanable=CLEAN_TYPE_BLOOD, _description, mutable_appearance/_pic)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	. = ..()
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name), TRUE)

/datum/element/decal/blood/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

/datum/element/decal/blood/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'icons/effects/blood.dmi'
	if(!_icon_state)
		_icon_state = "itemblood"
	if(!_color)
		_color = COLOR_HUMAN_BLOOD

	//try to find a pre-processed blood-splatter. otherwise, make a new one
	var/index = BLOODY_OVERLAY_KEY(I)
	pic = GLOB.bloody_item_images[index]

	if(!pic)
		var/icon/blood_splatter_icon = icon(I.icon, I.icon_state, null, 1)
		blood_splatter_icon.Blend("#fff", ICON_ADD) //fills the icon_state with white (except where it's transparent)
		blood_splatter_icon.Blend(icon(_icon, _icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
		pic = mutable_appearance(blood_splatter_icon, I.icon_state)

	pic.color = _color
	GLOB.bloody_item_images[index] = pic
	return TRUE

/datum/element/decal/blood/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER

	override.Insert(1, "blood-stained")
