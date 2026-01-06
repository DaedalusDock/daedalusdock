//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/hooded
	equip_self_flags = EQUIP_ALLOW_MOVEMENT | EQUIP_SLOWDOWN
	equip_delay_self = EQUIP_DELAY_COAT
	equip_delay_other = EQUIP_DELAY_COAT * 1.5
	strip_delay = EQUIP_DELAY_COAT * 1.5

	var/hoodtype = /obj/item/clothing/head/hooded/winterhood //so the chaplain hoodie or other hoodies can override this
	///Alternative mode for hiding the hood, instead of storing the hood in the suit it qdels it, useful for when you deal with hooded suit with storage.
	var/alternative_mode = FALSE
	///Whether the hood is flipped up
	var/hood_up = FALSE
	var/icon_suffix = "_t"

/obj/item/clothing/suit/hooded/Initialize(mapload)
	. = ..()
	AddComponent(
		/datum/component/hooded, \
		hoodtype, \
		icon_suffix, \
		alternative_mode, \
		CALLBACK(src, PROC_REF(pre_hood_equip)), \
		CALLBACK(src, PROC_REF(on_hood_creation)), \
		CALLBACK(src, PROC_REF(on_hood_unequip)), \
		CALLBACK(src, PROC_REF(on_hood_equip)), \
	)

/obj/item/clothing/suit/hooded/proc/pre_hood_equip(mob/living/wearer, obj/item/clothing/hood)
	return TRUE

/obj/item/clothing/suit/hooded/proc/on_hood_creation(obj/item/clothing/hood)
	return

/obj/item/clothing/suit/hooded/proc/on_hood_unequip(obj/item/clothing/hood)
	return

/obj/item/clothing/suit/hooded/proc/on_hood_equip(mob/living/wearer, obj/item/clothing/hood)
	return

// Old now unused type from when hoods were a hardcoded concept and not a component.
/obj/item/clothing/head/hooded

// Toggle exosuits for different aesthetic styles (hoodies, suit jacket buttons, etc)
// Pretty much just a holder for `/datum/component/toggle_icon`.

/obj/item/clothing/suit/toggle
	/// The noun that is displayed to the user on toggle. EX: "Toggles the suit's [buttons]".
	var/toggle_noun = "buttons"

/obj/item/clothing/suit/toggle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, toggle_noun)
