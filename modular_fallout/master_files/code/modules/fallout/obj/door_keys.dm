/obj/item/door_key
	name = "unusable key"
	desc = "A small grey key."
	icon = 'modular_fallout/master_files/icons/fallout/objects/keys.dmi'
	icon_state = "empty_key"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	var/id = null
	var/static/list/used_ids = list()

/obj/item/door_key/New()
	..()
	if(id)
		attach_id(id)

/obj/item/door_key/attack_self(mob/user as mob)
	if(!id)
		return
	src.name = input("Choose key label.",,copytext(src.name,0, length(src.name) - 3)) + " key"
	return

/obj/item/door_key/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/door_key))
		var/obj/item/door_key/K = W
		if((!src.id && !K.id) || (src.id && K.id))
			return 0
		if(alert(user,"You want to make copy of key?",,"Yes","No") == "No")
			return 0
		if(src.id && !K.id)
			K.attach_id(src.id)
		else
			src.attach_id(K.id)
		return 1
	. = ..()

/obj/item/door_key/proc/attach_id(id)
	src.id = id
	src.name = "key"
	src.icon_state = "key"
	if(!overlays_cache || !overlays_cache["usable_key"])
		var/icon/O = icon('modular_fallout/master_files/icons/fallout/objects/keys.dmi', "key_overlay")
		if(!used_ids[num2text(id)])
			var/color = rgb(rand(50,255), rand(50,255), rand(50,255))
			O.ColorTone(color)
			used_ids[num2text(id)] = color
		else
			O.ColorTone(used_ids[num2text(id)])
		add_cached_overlay("usable_key", O)

/obj/item/door_key/proc/random_id()
	var/try_id = 1
	if(used_ids.len)
		try_id = text2num(used_ids[used_ids.len]) + 1
	while(used_ids[num2text(try_id)])
		try_id++
	return try_id++

/obj/item/storage/keys_set
	name       = "key chain"
	desc       = "Put your keys here and make using doors comfortable!"
	icon       = 'modular_fallout/master_files/icons/fallout/objects/keys.dmi'
	icon_state = "keychain_0"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_BELT

/obj/item/storage/keys_set/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.can_hold = typecacheof(list(/obj/item/key))
	STR.max_combined_w_class = 35

/obj/item/storage/keys_set/update_icon()
	if(contents.len <= 4)
		icon_state = "keychain_[contents.len]"
	else
		icon_state = "keychain_4"

/obj/item/storage/keys_set/proc/get_key_with_id(id)
	for(var/obj/item/door_key/K in contents)
		if(K.id == id)
			return K
	return null

/obj/item/lock
	name = "unusable padlock"
	desc = "A small grey lock."
	icon = 'modular_fallout/master_files/icons/fallout/objects/keys.dmi'
	icon_state = "closed_lock"
	w_class = WEIGHT_CLASS_TINY
	layer = 100
	var/open = FALSE
	var/id = null

/obj/item/lock/New(location)
	..()
	layer = OBJ_LAYER
	if(id)
		attach_id(id)
		var/obj/structure/simple_door/D = locate(/obj/structure/simple_door) in loc
		if(istype(D) && D.can_hold_padlock)
			D.attach_padlock(src, TRUE)

/obj/item/lock/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/storage/keys_set))
		var/obj/item/storage/keys_set/S = W
		var/obj/item/door_key/K = S.get_key_with_id(id)
		if(istype(K))
			W = K

	if(istype(W,/obj/item/door_key))
		var/obj/item/door_key/K = W
		if(id)
			if(id == K.id)
				to_chat(user, "<span class='notice'>You begin [open ? "locking" : "unlocking"] padlock.</span>")
				if(do_after(user, 15, target = loc))
					toggle()
			else
				to_chat(user, "<span class='warning'>Wrong key!</span>")
		else
			if(K.id)
				attach_id(K.id)
				to_chat(user, "<span class='notice'>[src] is attached by [K].</span>")
			else
				var/new_id
				new_id = K.random_id()
				K.attach_id(new_id)
				src.attach_id(new_id)
				to_chat(user, "<span class='notice'>[K] sets for [src] now.</span>")
		return 1
	. = ..()

/obj/item/lock/proc/attach_id(id)
	src.id = id
	src.name = "padlock"

/obj/item/lock/proc/toggle()
	open = !open
	update_icon()

/obj/item/lock/update_icon()
	icon_state = open ? "opened_lock" : "closed_lock"
