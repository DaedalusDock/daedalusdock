/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/duffelbag(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet( src )
	new /obj/item/instrument/piano_synth(src)
	new /obj/item/radio/headset( src )

/obj/structure/closet/secure_closet/personal/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/obj/item/card/id/I = tool.GetID()
	if(!istype(I))
		return ..()

	if(broken)
		to_chat(user, span_danger("It appears to be broken."))
		return ITEM_INTERACT_BLOCKING

	if(!I.registered_name)
		return ITEM_INTERACT_BLOCKING

	if(allowed(user) || !registered_name || (registered_name == I.registered_name))
		//they can open all lockers, or nobody owns this, or they own this locker
		locked = !locked
		update_appearance()

		if(!registered_name)
			registered_name = I.registered_name
			desc = "Owned by [I.registered_name]."
		return ITEM_INTERACT_SUCCESS
	else
		to_chat(user, span_danger("Access Denied."))
		return ITEM_INTERACT_BLOCKING

/obj/structure/closet/secure_closet/personal/allowed(mob/mob_to_check)
	. = ..()
	if (. || !ishuman(mob_to_check))
		return
	var/mob/living/carbon/human/human_to_check = mob_to_check
	var/obj/item/card/id/id_card = human_to_check.wear_id?.GetID()
	if (istype(id_card) && id_card.registered_name == registered_name)
		return TRUE
