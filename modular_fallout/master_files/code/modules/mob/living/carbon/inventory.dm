/mob/living/carbon/update_slots_for_item(obj/item/I, equipped_slot = null, force_obscurity_update)
	.=..()
	if(ITEM_SLOT_HEAD)
		if(isclothing(I))
			var/obj/item/clothing/clothing_item = I
			if(clothing_item.tint || initial(clothing_item.tint) || clothing_item.vision_flags || clothing_item.darkness_view || clothing_item.invis_override || clothing_item.invis_view || !isnull(clothing_item.lighting_alpha))
				update_tint()
				update_sight()
	return ..()
