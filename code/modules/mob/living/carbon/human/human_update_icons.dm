#define RESOLVE_ICON_STATE(worn_item) (worn_item.worn_icon_state || worn_item.icon_state)

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/* Keep these comments up-to-date if you -insist- on hurting my code-baby ;_;
This system allows you to update individual mob-overlays, without regenerating them all each time.
When we generate overlays we generate the standing version and then rotate the mob as necessary..

As of the time of writing there are 20 layers within this list. Please try to keep this from increasing. //22 and counting, good job guys
	var/overlays_standing[20]		//For the standing stance

Most of the time we only wish to update one overlay:
	e.g. - we dropped the fireaxe out of our left hand and need to remove its icon from our mob
	e.g.2 - our hair colour has changed, so we need to update our hair icons on our mob
In these cases, instead of updating every overlay using the old behaviour (regenerate_icons), we instead call
the appropriate update_X proc.
	e.g. - update_l_hand()
	e.g.2 - update_body_parts()

Note: Recent changes by aranclanos+carn:
	update_icons() no longer needs to be called.
	the system is easier to use. update_icons() should not be called unless you absolutely -know- you need it.
	IN ALL OTHER CASES it's better to just call the specific update_X procs.

Note: The defines for layer numbers is now kept exclusvely in __DEFINES/misc.dm instead of being defined there,
	then redefined and undefiend everywhere else. If you need to change the layering of sprites (or add a new layer)
	that's where you should start.

All of this means that this code is more maintainable, faster and still fairly easy to use.

There are several things that need to be remembered:
>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src), rather than using the helper procs)
	You will need to call the relevant update_inv_* proc

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_worn_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_damage_overlays()	//handles damage overlays for brute/burn damage
		update_body_parts()			//Handles bodyparts, and everything bodyparts render. (Organs, hair, facial features)
		update_body()				//Calls update_body_parts(), as well as updates mutant bodyparts, the old, not-actually-bodypart system.
*/

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()

	if(!..())
		update_worn_undersuit()
		update_worn_id()
		update_worn_glasses()
		update_worn_gloves()
		update_worn_ears()
		update_worn_shoes()
		update_suit_storage()
		update_worn_mask()
		update_worn_head()
		update_worn_belt()
		update_worn_back()
		update_worn_oversuit()
		update_pockets()
		update_worn_neck()
		update_transform()
		//mutations
		update_mutations_overlay()
		//damage overlays
		update_damage_overlays()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_worn_undersuit()
	remove_overlay(UNIFORM_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_ICLOTHING) + 1]
		inv.update_icon()

	if(istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/uniform = w_uniform
		update_hud_uniform(uniform)

		if(check_obscured_slots() & ITEM_SLOT_ICLOTHING)
			return


		var/target_overlay = uniform.icon_state
		if(uniform.adjusted == ALT_STYLE)
			target_overlay = "[target_overlay]_d"

		var/mutable_appearance/uniform_overlay

		var/handled_by_bodytype = TRUE
		var/icon_file
		var/woman
		if(!uniform_overlay)
			//BEGIN SPECIES HANDLING
			if((dna?.species.bodytype & BODYTYPE_DIGITIGRADE) && (uniform.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
				icon_file = uniform.worn_icon_digitigrade || DIGITIGRADE_UNIFORM_FILE

			if(dna.species.bodytype & BODYTYPE_TESHARI)
				if(uniform.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
					icon_file = TESHARI_UNIFORM_FILE

			if(dna.species.bodytype & BODYTYPE_VOX_LEGS)
				if(uniform.supports_variations_flags & CLOTHING_VOX_VARIATION)
					icon_file = uniform.worn_icon_vox || VOX_UNIFORM_FILE

			//Female sprites have lower priority than digitigrade sprites
			else if(dna.species.sexes && (dna.species.bodytype & BODYTYPE_HUMANOID) && physique == FEMALE && uniform.female_sprite_flags != NO_FEMALE_UNIFORM) //Agggggggghhhhh
				woman = TRUE

			if(!icon_exists(icon_file, RESOLVE_ICON_STATE(uniform)))
				icon_file = DEFAULT_UNIFORM_FILE
				handled_by_bodytype = FALSE
			//END SPECIES HANDLING
			uniform_overlay = uniform.build_worn_icon(
				src,
				default_layer = UNIFORM_LAYER,
				default_icon_file = icon_file,
				isinhands = FALSE,
				female_uniform = woman ? uniform.female_sprite_flags : null,
				override_state = target_overlay,
				override_file = handled_by_bodytype ? icon_file : null,
				fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
			)

		if(!handled_by_bodytype && (OFFSET_UNIFORM in dna.species.offset_features))
			uniform_overlay?.pixel_x += dna.species.offset_features[OFFSET_UNIFORM][1]
			uniform_overlay?.pixel_y += dna.species.offset_features[OFFSET_UNIFORM][2]
		if(uniform.accessory_overlay && (OFFSET_ACCESSORY in dna.species.offset_features))
			uniform.accessory_overlay.pixel_x += dna.species.offset_features[OFFSET_ACCESSORY][1]
			uniform.accessory_overlay.pixel_y += dna.species.offset_features[OFFSET_ACCESSORY][2]
		overlays_standing[UNIFORM_LAYER] = uniform_overlay
		apply_overlay(UNIFORM_LAYER)

/mob/living/carbon/human/update_worn_id()
	remove_overlay(ID_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_ID) + 1]
		inv.update_icon()

	var/mutable_appearance/id_overlay = overlays_standing[ID_LAYER]

	if(wear_id)
		var/obj/item/worn_item = wear_id
		update_hud_id(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_ID)
			return

		var/handled_by_bodytype = TRUE
		var/icon_file

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item)))
			icon_file = 'icons/mob/mob.dmi'
			handled_by_bodytype = FALSE

		id_overlay = wear_id.build_worn_icon(src, default_layer = ID_LAYER, default_icon_file = icon_file)

		if(!id_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_ID in dna.species.offset_features))
			id_overlay.pixel_x += dna.species.offset_features[OFFSET_ID][1]
			id_overlay.pixel_y += dna.species.offset_features[OFFSET_ID][2]
		overlays_standing[ID_LAYER] = id_overlay

	apply_overlay(ID_LAYER)


/mob/living/carbon/human/update_worn_gloves()
	remove_overlay(GLOVES_LAYER)

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_GLOVES) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_GLOVES) + 1]
		inv.update_icon()

	//Bloody hands begin
	var/mutable_appearance/bloody_overlay = mutable_appearance('icons/effects/blood.dmi', "bloodyhands", -GLOVES_LAYER)
	cut_overlay(bloody_overlay)
	if(!gloves && blood_in_hands && (num_hands > 0))
		bloody_overlay = mutable_appearance('icons/effects/blood.dmi', "bloodyhands", -GLOVES_LAYER)
		bloody_overlay.color = get_blood_dna_color(return_blood_DNA()) || COLOR_HUMAN_BLOOD
		if(num_hands < 2)
			if(has_left_hand(FALSE))
				bloody_overlay.icon_state = "bloodyhands_left"
			else if(has_right_hand(FALSE))
				bloody_overlay.icon_state = "bloodyhands_right"

		add_overlay(bloody_overlay)
	//Bloody hands end

	var/mutable_appearance/gloves_overlay
	if(gloves)
		var/obj/item/worn_item = gloves
		update_hud_gloves(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_GLOVES)
			return

		var/icon_file
		var/handled_by_bodytype = TRUE
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(gloves.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_GLOVES_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_OTHER)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_GLOVES_FILE

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item)))
			icon_file = 'icons/mob/clothing/hands.dmi'
			handled_by_bodytype = FALSE

		gloves_overlay = gloves.build_worn_icon(
			src,
			default_layer = GLOVES_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null,
			fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
		)

		if(!gloves_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_GLOVES in dna.species.offset_features))
			gloves_overlay.pixel_x += dna.species.offset_features[OFFSET_GLOVES][1]
			gloves_overlay.pixel_y += dna.species.offset_features[OFFSET_GLOVES][2]
		overlays_standing[GLOVES_LAYER] = gloves_overlay
	apply_overlay(GLOVES_LAYER)


/mob/living/carbon/human/update_worn_glasses()
	remove_overlay(GLASSES_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_EYES) + 1]
		inv.update_icon()

	if(glasses)
		var/obj/item/worn_item = glasses
		var/mutable_appearance/glasses_overlay
		update_hud_glasses(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_EYES)
			return

		var/handled_by_bodytype = TRUE
		var/icon_file
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(glasses.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_EYES_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_OTHER)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_EYES_FILE

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item)))
			icon_file = 'icons/mob/clothing/eyes.dmi'
			handled_by_bodytype = FALSE

		glasses_overlay = glasses.build_worn_icon(
			src,
			default_layer = GLASSES_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null,
			fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
		)

		if(!glasses_overlay)
			return

		if(!handled_by_bodytype && (OFFSET_GLASSES in dna.species.offset_features))
			glasses_overlay.pixel_x += dna.species.offset_features[OFFSET_GLASSES][1]
			glasses_overlay.pixel_y += dna.species.offset_features[OFFSET_GLASSES][2]
		overlays_standing[GLASSES_LAYER] = glasses_overlay
	apply_overlay(GLASSES_LAYER)


/mob/living/carbon/human/update_worn_ears()
	remove_overlay(EARS_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_EARS) + 1]
		inv.update_icon()

	if(ears)
		var/obj/item/worn_item = ears
		var/mutable_appearance/ears_overlay
		update_hud_ears(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_EARS)
			return

		var/handled_by_bodytype = TRUE
		var/icon_file
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(ears.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_EARS_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_OTHER)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_EARS_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = 'icons/mob/clothing/ears.dmi'

		ears_overlay = ears.build_worn_icon(src, default_layer = EARS_LAYER, default_icon_file = icon_file)

		if(!ears_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_EARS in dna.species.offset_features))
			ears_overlay.pixel_x += dna.species.offset_features[OFFSET_EARS][1]
			ears_overlay.pixel_y += dna.species.offset_features[OFFSET_EARS][2]
		overlays_standing[EARS_LAYER] = ears_overlay
	apply_overlay(EARS_LAYER)

/mob/living/carbon/human/update_worn_neck()
	remove_overlay(NECK_LAYER)

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1]
		inv.update_icon()

	if(wear_neck)
		var/obj/item/worn_item = wear_neck
		update_hud_neck(wear_neck)

		if(check_obscured_slots() & ITEM_SLOT_NECK)
			return

		var/mutable_appearance/neck_overlay
		var/icon_file
		var/handled_by_bodytype = TRUE
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_NECK_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = 'icons/mob/clothing/neck.dmi'

		neck_overlay = worn_item.build_worn_icon(
			src,
			default_layer = NECK_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null,
			fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
		)

		if(!neck_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_NECK in dna.species.offset_features))
			neck_overlay.pixel_x += dna.species.offset_features[OFFSET_NECK][1]
			neck_overlay.pixel_y += dna.species.offset_features[OFFSET_NECK][2]
		overlays_standing[NECK_LAYER] = neck_overlay

	apply_overlay(NECK_LAYER)

/mob/living/carbon/human/update_worn_shoes()
	remove_overlay(SHOES_LAYER)

	if(num_legs < 2)
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_FEET) + 1]
		inv.update_icon()

	if(shoes)
		var/obj/item/worn_item = shoes
		var/mutable_appearance/shoes_overlay
		var/icon_file
		update_hud_shoes(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_FEET)
			return

		var/handled_by_bodytype = TRUE

		if((dna.species.bodytype & BODYTYPE_DIGITIGRADE) && (worn_item.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			var/obj/item/bodypart/leg/leg = src.get_bodypart(BODY_ZONE_L_LEG)
			if(leg.limb_id == leg.digitigrade_id)//Snowflakey and bad. But it makes it look consistent.
				icon_file = shoes.worn_icon_digitigrade || DIGITIGRADE_SHOES_FILE

		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_SHOES_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_LEGS)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				var/obj/item/bodypart/leg = src.get_bodypart(BODY_ZONE_L_LEG)
				if(leg.limb_id == "vox_digitigrade")//Snowflakey and bad. But it makes it look consistent.
					icon_file = worn_item.worn_icon_vox || VOX_SHOES_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = DEFAULT_SHOES_FILE

		shoes_overlay = shoes.build_worn_icon(
			src,
			default_layer = SHOES_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null,
			fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
		)

		if(!shoes_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_SHOES in dna.species.offset_features))
			shoes_overlay.pixel_x += dna.species.offset_features[OFFSET_SHOES][1]
			shoes_overlay.pixel_y += dna.species.offset_features[OFFSET_SHOES][2]
		overlays_standing[SHOES_LAYER] = shoes_overlay

	apply_overlay(SHOES_LAYER)


/mob/living/carbon/human/update_suit_storage()
	remove_overlay(SUIT_STORE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_SUITSTORE) + 1]
		inv.update_icon()

	if(s_store)
		var/obj/item/worn_item = s_store
		var/mutable_appearance/s_store_overlay
		update_hud_s_store(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_SUITSTORE)
			return

		s_store_overlay = worn_item.build_worn_icon(src, default_layer = SUIT_STORE_LAYER, default_icon_file = 'icons/mob/clothing/belt_mirror.dmi')

		if(!s_store_overlay)
			return
		if(OFFSET_S_STORE in dna.species.offset_features)
			s_store_overlay.pixel_x += dna.species.offset_features[OFFSET_S_STORE][1]
			s_store_overlay.pixel_y += dna.species.offset_features[OFFSET_S_STORE][2]
		overlays_standing[SUIT_STORE_LAYER] = s_store_overlay
	apply_overlay(SUIT_STORE_LAYER)

/mob/living/carbon/human/update_worn_head()
	remove_overlay(HEAD_LAYER)
	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv.update_icon()

	if(head)
		var/obj/item/worn_item = head
		var/mutable_appearance/head_overlay
		update_hud_head(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_HEAD)
			return

		var/handled_by_bodytype = TRUE //PARIAH EDIT
		var/icon_file

		if(dna.species.bodytype & BODYTYPE_SNOUTED)
			if(worn_item.supports_variations_flags & CLOTHING_SNOUTED_VARIATION)
				icon_file = head.worn_icon_snouted || SNOUTED_HEAD_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_BEAK)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_HEAD_FILE

		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_HEAD_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = 'icons/mob/clothing/head.dmi'

		head_overlay = head.build_worn_icon(
			src,
			default_layer = HEAD_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null
		)

		if(!head_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_HEAD in dna.species.offset_features))
			head_overlay.pixel_x += dna.species.offset_features[OFFSET_HEAD][1]
			head_overlay.pixel_y += dna.species.offset_features[OFFSET_HEAD][2]
		overlays_standing[HEAD_LAYER] = head_overlay

	apply_overlay(HEAD_LAYER)

/mob/living/carbon/human/update_worn_belt()
	remove_overlay(BELT_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BELT) + 1]
		inv.update_icon()

	if(belt)
		var/obj/item/worn_item = belt
		var/mutable_appearance/belt_overlay
		update_hud_belt(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_BELT)
			return

		var/handled_by_bodytype = TRUE
		var/icon_file
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_BELT_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_OTHER)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_BELT_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = 'icons/mob/clothing/belt.dmi'

		belt_overlay = belt.build_worn_icon(
			src,
			default_layer = BELT_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null
		)

		if(!belt_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_BELT in dna.species.offset_features))
			belt_overlay.pixel_x += dna.species.offset_features[OFFSET_BELT][1]
			belt_overlay.pixel_y += dna.species.offset_features[OFFSET_BELT][2]
		overlays_standing[BELT_LAYER] = belt_overlay

	apply_overlay(BELT_LAYER)

/mob/living/carbon/human/update_worn_oversuit()
	remove_overlay(SUIT_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_OCLOTHING) + 1]
		inv.update_icon()

	if(wear_suit)
		var/obj/item/worn_item = wear_suit
		var/mutable_appearance/suit_overlay
		update_hud_wear_suit(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_OCLOTHING)
			return

		var/icon_file
		var/handled_by_bodytype = TRUE

		//PARIAH EDIT
		//More currently unused digitigrade handling
		if(dna.species.bodytype & BODYTYPE_DIGITIGRADE)
			if(worn_item.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION)
				icon_file = wear_suit.worn_icon_digitigrade || DIGITIGRADE_SUIT_FILE

		//PARIAH EDIT END
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_SUIT_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_LEGS)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_SUIT_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			handled_by_bodytype = FALSE
			icon_file = DEFAULT_SUIT_FILE

		suit_overlay = wear_suit.build_worn_icon(
			src,
			default_layer = SUIT_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null,
			fallback = handled_by_bodytype ? null : dna.species.fallback_clothing_path
		)

		if(!suit_overlay)
			return
		if((!handled_by_bodytype) && (OFFSET_SUIT in dna.species.offset_features))
			suit_overlay.pixel_x += dna.species.offset_features[OFFSET_SUIT][1]
			suit_overlay.pixel_y += dna.species.offset_features[OFFSET_SUIT][2]
		overlays_standing[SUIT_LAYER] = suit_overlay

	apply_overlay(SUIT_LAYER)


/mob/living/carbon/human/update_pockets()
	if(client && hud_used)
		var/atom/movable/screen/inventory/inv

		inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_LPOCKET) + 1]
		inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_RPOCKET) + 1]

		inv.update_icon()

		if(l_store)
			l_store.screen_loc = ui_storage1
			if(hud_used.hud_shown)
				client.screen += l_store
			update_observer_view(l_store)

		if(r_store)
			r_store.screen_loc = ui_storage2
			if(hud_used.hud_shown)
				client.screen += r_store
			update_observer_view(r_store)

/mob/living/carbon/human/update_worn_mask()
	remove_overlay(FACEMASK_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1]
		inv.update_icon()

	if(wear_mask)
		var/obj/item/worn_item = wear_mask
		update_hud_wear_mask(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_MASK)
			return

		var/mutable_appearance/mask_overlay
		var/icon_file
		var/handled_by_bodytype = TRUE

		if(dna.species.bodytype & BODYTYPE_SNOUTED)
			if(worn_item.supports_variations_flags & CLOTHING_SNOUTED_VARIATION)
				icon_file = wear_mask.worn_icon_snouted || SNOUTED_MASK_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_BEAK)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_MASK_FILE

		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_MASK_FILE

		if(!(icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item))))
			icon_file = 'icons/mob/clothing/mask.dmi'
			handled_by_bodytype = FALSE

		mask_overlay = wear_mask.build_worn_icon(
			src,
			default_layer = FACEMASK_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null
		)

		if(!mask_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_FACEMASK in dna.species.offset_features))
			mask_overlay.pixel_x += dna.species.offset_features[OFFSET_FACEMASK][1]
			mask_overlay.pixel_y += dna.species.offset_features[OFFSET_FACEMASK][2]

		overlays_standing[FACEMASK_LAYER] = mask_overlay

	apply_overlay(FACEMASK_LAYER)

/mob/living/carbon/human/update_worn_back()
	remove_overlay(BACK_LAYER)

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1]
		inv.update_icon()

	if(back)
		var/obj/item/worn_item = back
		var/mutable_appearance/back_overlay

		update_hud_back(worn_item)

		if(check_obscured_slots() & ITEM_SLOT_BACK)
			return

		var/icon_file
		var/handled_by_bodytype = TRUE
		if(dna.species.bodytype & BODYTYPE_TESHARI)
			if(worn_item.supports_variations_flags & CLOTHING_TESHARI_VARIATION)
				icon_file = TESHARI_BACK_FILE

		if(dna.species.bodytype & BODYTYPE_VOX_OTHER)
			if(worn_item.supports_variations_flags & CLOTHING_VOX_VARIATION)
				icon_file = worn_item.worn_icon_vox || VOX_BACK_FILE


		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(worn_item)))
			icon_file = 'icons/mob/clothing/back.dmi'
			handled_by_bodytype = FALSE

		back_overlay = back.build_worn_icon(
			src,
			default_layer = BACK_LAYER,
			default_icon_file = icon_file,
			override_file = handled_by_bodytype ? icon_file : null
		)

		if(!back_overlay)
			return
		if(!handled_by_bodytype && (OFFSET_BACK in dna.species.offset_features))
			back_overlay.pixel_x += dna.species.offset_features[OFFSET_BACK][1]
			back_overlay.pixel_y += dna.species.offset_features[OFFSET_BACK][2]
		overlays_standing[BACK_LAYER] = back_overlay
	apply_overlay(BACK_LAYER)

/mob/living/carbon/human/update_worn_legcuffs()
	remove_overlay(LEGCUFF_LAYER)
	clear_alert("legcuffed")
	if(legcuffed)
		overlays_standing[LEGCUFF_LAYER] = mutable_appearance('icons/mob/mob.dmi', "legcuff1", -LEGCUFF_LAYER)
		apply_overlay(LEGCUFF_LAYER)
		throw_alert("legcuffed", /atom/movable/screen/alert/restrained/legcuffed, new_master = src.legcuffed)

/mob/living/carbon/human/update_held_items()
	remove_overlay(HANDS_LAYER)
	if (handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	for(var/obj/item/worn_item in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			worn_item.screen_loc = ui_hand_position(get_held_index_of_item(worn_item))
			client.screen += worn_item
			if(LAZYLEN(observers))
				for(var/mob/dead/observe as anything in observers)
					if(observe.client && observe.client.eye == src)
						observe.client.screen += worn_item
					else
						observers -= observe
						if(!length(observers))
							observers = null
							break

		var/t_state = worn_item.inhand_icon_state
		if(!t_state)
			t_state = worn_item.icon_state

		var/icon_file = worn_item.lefthand_file
		var/mutable_appearance/hand_overlay
		if(get_held_index_of_item(worn_item) % 2 == 0)
			icon_file = worn_item.righthand_file
			hand_overlay = worn_item.build_worn_icon(src, default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)
		else
			hand_overlay = worn_item.build_worn_icon(src, default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)

		hands += hand_overlay
	overlays_standing[HANDS_LAYER] = hands
	apply_overlay(HANDS_LAYER)

/proc/wear_female_version(t_color, icon, layer, type, greyscale_colors)
	var/index = "[t_color]-[greyscale_colors]"
	var/icon/female_clothing_icon = GLOB.female_clothing_icons[index]
	if(!female_clothing_icon) 	//Create standing/laying icons if they don't exist
		generate_female_clothing(index, t_color, icon, type)
	return mutable_appearance(GLOB.female_clothing_icons[index], layer = -layer)

/**
 * Override with a fallback sprite for this item.
 *
 * Arguments:
 * * file2use - The normal `icon` for this item.
 * * state2use - The normal `icon_state` for this item.
 * * layer - The layer that the final sprite should be rendered on.
 * * species_file - The [/datum/species/var/fallback_clothing_path] of the species trying to wear this item.
 */
/obj/item/proc/wear_fallback_version(file2use, state2use, layer, species_file)
	return

/**
 * Returns a mutable_appearance of this clothing's fallback sprite.
 *
 * If a sprite for this item hasn't already been generated, a new one is made in [generate_fallback_clothing], and added to `GLOB.fallback_clothing_icons`.
 *
 * Arguments:
 * * file2use - The normal `icon` for this item.
 * * state2use - The normal `icon_state` for this item.
 * * layer - The layer that the final sprite should be rendered on.
 * * species_file - The [/datum/species/var/fallback_clothing_path] of the species trying to wear this item.
 */
/obj/item/clothing/wear_fallback_version(file2use, state2use, layer, species_file)
	LAZYINITLIST(GLOB.fallback_clothing_icons[species_file])

	// Either ["path/to/file.dmi-jumpsuit"] or ["#ffe14d-jumpsuit"]
	var/list_key = "[(greyscale_colors && greyscale_config_worn) ? greyscale_colors : file2use]-[state2use]"

	var/icon/species_clothing_icon = GLOB.fallback_clothing_icons[species_file][list_key]
	if(!species_clothing_icon) // Create standing/laying icons if they don't exist
		generate_fallback_clothing(file2use, state2use, species_file, list_key)
	return mutable_appearance(GLOB.fallback_clothing_icons[species_file][list_key], layer = -layer)

/mob/living/carbon/human/proc/get_overlays_copy(list/unwantedLayers)
	var/list/out = new
	for(var/i in 1 to TOTAL_LAYERS)
		if(overlays_standing[i])
			if(i in unwantedLayers)
				continue
			out += overlays_standing[i]
	return out


//human HUD updates for items in our inventory

/mob/living/carbon/human/proc/update_hud_uniform(obj/item/worn_item)
	worn_item.screen_loc = ui_iclothing
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_id(obj/item/worn_item)
	worn_item.screen_loc = ui_id
	if((client && hud_used?.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item)

/mob/living/carbon/human/proc/update_hud_gloves(obj/item/worn_item)
	worn_item.screen_loc = ui_gloves
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_glasses(obj/item/worn_item)
	worn_item.screen_loc = ui_glasses
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_ears(obj/item/worn_item)
	worn_item.screen_loc = ui_ears
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_shoes(obj/item/worn_item)
	worn_item.screen_loc = ui_shoes
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_s_store(obj/item/worn_item)
	worn_item.screen_loc = ui_sstore1
	if(client && hud_used?.hud_shown)
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_wear_suit(obj/item/worn_item)
	worn_item.screen_loc = ui_oclothing
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/proc/update_hud_belt(obj/item/worn_item)
	belt.screen_loc = ui_belt
	if(client && hud_used?.hud_shown)
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

/mob/living/carbon/human/update_hud_head(obj/item/worn_item)
	worn_item.screen_loc = ui_head
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

//update whether our mask item appears on our hud.
/mob/living/carbon/human/update_hud_wear_mask(obj/item/worn_item)
	worn_item.screen_loc = ui_mask
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

//update whether our neck item appears on our hud.
/mob/living/carbon/human/update_hud_neck(obj/item/worn_item)
	worn_item.screen_loc = ui_neck
	if((client && hud_used) && (hud_used.inventory_shown && hud_used.hud_shown))
		client.screen += worn_item
	update_observer_view(worn_item,TRUE)

//update whether our back item appears on our hud.
/mob/living/carbon/human/update_hud_back(obj/item/worn_item)
	worn_item.screen_loc = ui_back
	if(client && hud_used?.hud_shown)
		client.screen += worn_item
	update_observer_view(worn_item, inventory = TRUE)

/*
Does everything in relation to building the /mutable_appearance used in the mob's overlays list
covers:
Inhands and any other form of worn item
Rentering large appearances
Layering appearances on custom layers
Building appearances from custom icon files

By Remie Richards (yes I'm taking credit because this just removed 90% of the copypaste in update_icons())

state: A string to use as the state, this is FAR too complex to solve in this proc thanks to shitty old code
so it's specified as an argument instead.

default_layer: The layer to draw this on if no other layer is specified

default_icon_file: The icon file to draw states from if no other icon file is specified

isinhands: If true then alternate_worn_icon is skipped so that default_icon_file is used,
in this situation default_icon_file is expected to match either the lefthand_ or righthand_ file var

female_uniform: A value matching a uniform item's female_sprite_flags var, if this is anything but NO_FEMALE_UNIFORM, we
generate/load female uniform sprites matching all previously decided variables


*/
/obj/item/proc/build_worn_icon(mob/living/carbon/wearer, default_layer = 0, default_icon_file = null, isinhands = FALSE, female_uniform = NO_FEMALE_UNIFORM, override_state = null, override_file = null, fallback = null)

	//Find a valid icon_state from variables+arguments
	var/t_state
	if(override_state)
		t_state = override_state
	else
		t_state = !isinhands ? (worn_icon_state ? worn_icon_state : icon_state) : (inhand_icon_state ? inhand_icon_state : icon_state)

	//Find a valid icon file from variables+arguments
	var/file2use
	if(override_file)
		file2use = override_file
	else
		file2use = !isinhands ? (worn_icon ? worn_icon : default_icon_file) : default_icon_file
	//Find a valid layer from variables+arguments
	var/layer2use = alternate_worn_layer ? alternate_worn_layer : default_layer

	var/mutable_appearance/standing
	if(fallback)
		standing = wear_fallback_version(file2use, t_state, layer2use, fallback)
	else if(female_uniform)
		standing = wear_female_version(t_state, file2use, layer2use, female_uniform, greyscale_colors) //should layer2use be in sync with the adjusted value below? needs testing - shiz
	if(!standing)
		standing = mutable_appearance(file2use, t_state, -layer2use)

	//Get the overlays for this item when it's being worn
	//eg: ammo counters, primed grenade flashes, etc.
	var/list/worn_overlays = worn_overlays(wearer, standing, isinhands, file2use)
	if(worn_overlays?.len)
		standing.overlays.Add(worn_overlays)

	standing = center_image(standing, isinhands ? inhand_x_dimension : worn_x_dimension, isinhands ? inhand_y_dimension : worn_y_dimension)

	//Worn offsets
	var/list/offsets = get_worn_offsets(isinhands)
	standing.pixel_x += offsets[1]
	standing.pixel_y += offsets[2]

	standing.alpha = alpha
	standing.color = color

	return standing

/// Returns offsets used for equipped item overlays in list(px_offset,py_offset) form.
/obj/item/proc/get_worn_offsets(isinhands)
	. = list(0,0) //(px,py)
	if(isinhands)
		//Handle held offsets
		var/mob/holder = loc
		if(istype(holder))
			var/list/offsets = holder.get_item_offsets_for_index(holder.get_held_index_of_item(src))
			if(offsets)
				.[1] = offsets["x"]
				.[2] = offsets["y"]
	else
		.[2] = worn_y_offset

//Can't think of a better way to do this, sadly
/mob/proc/get_item_offsets_for_index(i)
	switch(i)
		if(3) //odd = left hands
			return list("x" = 0, "y" = 16)
		if(4) //even = right hands
			return list("x" = 0, "y" = 16)
		else //No offsets or Unwritten number of hands
			return list("x" = 0, "y" = 0)//Handle held offsets

/mob/living/carbon/human/proc/update_observer_view(obj/item/worn_item, inventory)
	if(observers?.len)
		for(var/M in observers)
			var/mob/dead/observe = M
			if(observe.client && observe.client.eye == src)
				if(observe.hud_used)
					if(inventory && !observe.hud_used.inventory_shown)
						continue
					observe.client.screen += worn_item
			else
				observers -= observe
				if(!observers.len)
					observers = null
					break

// Only renders the head of the human
/mob/living/carbon/human/proc/update_body_parts_head_only(update_limb_data)
	if(!dna?.species)
		return

	var/obj/item/bodypart/HD = get_bodypart("head")

	if (!istype(HD))
		return

	HD.update_limb(is_creating = update_limb_data)

	add_overlay(HD.get_limb_overlays())
	update_damage_overlays()

	if(HD && !(HAS_TRAIT(src, TRAIT_HUSK)))
		// lipstick
		if(lip_style && (LIPS in dna.species.species_traits))
			var/mutable_appearance/lip_overlay = mutable_appearance('icons/mob/human_face.dmi', "lips_[lip_style]", -BODY_LAYER)
			lip_overlay.color = lip_color
			if(OFFSET_FACE in dna.species.offset_features)
				lip_overlay.pixel_x += dna.species.offset_features[OFFSET_FACE][1]
				lip_overlay.pixel_y += dna.species.offset_features[OFFSET_FACE][2]
			add_overlay(lip_overlay)

		// eyes
		if(!(NOEYESPRITES in dna.species.species_traits))
			var/obj/item/organ/eyes/parent_eyes = getorganslot(ORGAN_SLOT_EYES)
			if(parent_eyes)
				add_overlay(parent_eyes.generate_body_overlay(src))
			else
				var/mutable_appearance/missing_eyes = mutable_appearance('icons/mob/human_face.dmi', "eyes_missing", -BODY_LAYER)
				if(OFFSET_FACE in dna.species.offset_features)
					missing_eyes.pixel_x += dna.species.offset_features[OFFSET_FACE][1]
					missing_eyes.pixel_y += dna.species.offset_features[OFFSET_FACE][2]
				add_overlay(missing_eyes)

	update_worn_head()
	update_worn_mask()

#undef RESOLVE_ICON_STATE
