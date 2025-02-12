///Subtype for any kind of ballistic gun
///This has a shitload of vars on it, and I'm sorry for that, but it does make making new subtypes really easy
/obj/item/gun/ballistic
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason."
	name = "projectile gun"
	icon_state = "debug"
	w_class = WEIGHT_CLASS_NORMAL

	smoking_gun = TRUE
	//Most ballistics can have a bit of recoil, just to feel punchy.
	recoil = 0.5
	unwielded_recoil = 1

	///sound when inserting magazine
	var/load_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg'
	///sound when inserting an empty magazine
	var/load_empty_sound = 'sound/weapons/gun/general/magazine_insert_empty.ogg'
	///volume of loading sound
	var/load_sound_volume = 40
	///whether loading sound should vary
	var/load_sound_vary = FALSE
	///sound of racking
	var/rack_sound = 'sound/weapons/gun/general/bolt_rack.ogg'
	///volume of racking
	var/rack_sound_volume = 60
	///whether racking sound should vary
	var/rack_sound_vary = FALSE
	///sound of when the bolt is locked back manually
	var/lock_back_sound = 'sound/weapons/gun/general/slide_lock_1.ogg'
	///volume of lock back
	var/lock_back_sound_volume = 60
	///whether lock back varies
	var/lock_back_sound_vary = FALSE
	///Sound of ejecting a magazine
	var/eject_sound = 'sound/weapons/gun/general/magazine_remove_full.ogg'
	///sound of ejecting an empty magazine
	var/eject_empty_sound = 'sound/weapons/gun/general/magazine_remove_empty.ogg'
	///volume of ejecting a magazine
	var/eject_sound_volume = 40
	///whether eject sound should vary
	var/eject_sound_vary = FALSE
	///sound of dropping the bolt or releasing a slide
	var/bolt_drop_sound = 'sound/weapons/gun/general/bolt_drop.ogg'
	///volume of bolt drop/slide release
	var/bolt_drop_sound_volume = 60
	///empty alarm sound (if enabled)
	var/empty_alarm_sound = 'sound/weapons/gun/general/empty_alarm.ogg'
	///empty alarm volume sound
	var/empty_alarm_volume = 70
	///whether empty alarm sound varies
	var/empty_alarm_vary = FALSE

	///Whether the gun will spawn loaded with a magazine
	var/spawnwithmagazine = TRUE
	///Compatible magazines with the gun
	var/obj/item/ammo_box/magazine/mag_type = /obj/item/ammo_box/magazine/m10mm //Removes the need for max_ammo and caliber info
	///Whether the sprite has a visible magazine or not
	var/mag_display = TRUE
	///Whether the sprite has a visible ammo display or not
	var/mag_display_ammo = FALSE
	///Whether the sprite has a visible indicator for being empty or not.
	var/empty_indicator = FALSE
	///Whether the gun alarms when empty or not.
	var/empty_alarm = FALSE
	///Whether the gun supports multiple special mag types
	var/special_mags = FALSE


	/**
	* The bolt type controls how the gun functions, and what iconstates you'll need to represent those functions.
	* /datum/gun_bolt - The Slide doesn't lock back.  Clicking on it will only cycle the bolt.  Only 1 sprite.
	* /datum/gun_bolt/open - Same as standard, but it fires directly from the magazine - No need to rack.  Doesn't hold the bullet when you drop the mag.
	* /datum/gun_bolt/locking - This is most handguns and bolt action rifles.  The bolt will lock back when it's empty. You need yourgun_bolt and yourgun_bolt_locked icon states.
	* /datum/gun_bolt/no_bolt - This is shotguns and revolvers.  clicking will dump out all the bullets in the gun, spent or not.
	**/
	var/datum/gun_bolt/bolt = /datum/gun_bolt

	var/show_bolt_icon = TRUE ///Hides the bolt icon.
	///Whether the gun has to be racked each shot or not.
	var/semi_auto = TRUE
	///Actual magazine currently contained within the gun
	var/obj/item/ammo_box/magazine/magazine
	///whether the gun ejects the chambered casing
	var/casing_ejector = TRUE
	///Whether the gun has an internal magazine or a detatchable one. Overridden by /datum/gun_bolt/no_bolt.
	var/internal_magazine = FALSE
	///Phrasing of the bolt in examine and notification messages; ex: bolt, slide, etc.
	var/bolt_wording = "bolt"
	///Phrasing of the magazine in examine and notification messages; ex: magazine, box, etx
	var/magazine_wording = "magazine"
	///Phrasing of the cartridge in examine and notification messages; ex: bullet, shell, dart, etc.
	var/cartridge_wording = "bullet"
	/// If TRUE, will show the caliber name on examine. Set to false for things with fake calibers like bows and the tentacle "gun".
	var/show_caliber_on_examine = TRUE

	///length between individual racks
	var/rack_delay = 5
	/// Can you rack this weapon with one hand?
	var/one_hand_rack = FALSE
	///time of the most recent rack, used for cooldown purposes
	var/recent_rack = 0
	///Whether the gun can be sawn off by sawing tools
	var/can_be_sawn_off = FALSE
	var/flip_cooldown = 0
	var/suppressor_x_offset ///pixel offset for the suppressor overlay on the x axis.
	var/suppressor_y_offset ///pixel offset for the suppressor overlay on the y axis.
	/// Check if you are able to see if a weapon has a bullet loaded in or not.
	var/hidden_chambered = FALSE

	// Gun internal magazine modification and misfiring

	///Can we modify our ammo type in this gun's internal magazine?
	var/can_modify_ammo = FALSE
	///our initial ammo type. Should match initial caliber, but a bit of redundency doesn't hurt.
	var/initial_caliber
	///our alternative ammo type.
	var/alternative_caliber
	///our initial fire sound. same reasons for initial caliber
	var/initial_fire_sound
	///our alternative fire sound, in case we want our gun to be louder or quieter or whatever
	var/alternative_fire_sound
	///If only our alternative ammuntion misfires and not our main ammunition, we set this to TRUE
	var/alternative_ammo_misfires = FALSE

	/// Misfire Variables ///

	/// Whether our ammo misfires now or when it's set by the wrench_act. TRUE means it misfires.
	var/can_misfire = FALSE
	///How likely is our gun to misfire?
	var/misfire_probability = 0
	///How much does shooting the gun increment the misfire probability?
	var/misfire_percentage_increment = 0
	///What is the cap on our misfire probability? Do not set this to 100.
	var/misfire_probability_cap = 25

/obj/item/gun/ballistic/Initialize(mapload)
	. = ..()

	bolt = new bolt(src)

	if (!spawnwithmagazine)
		bolt.is_locked = TRUE
		update_appearance()
		return

	if (!magazine)
		magazine = new mag_type(src)

	initial_caliber = magazine.caliber

	if((bolt.type == /datum/gun_bolt) || internal_magazine) //Internal magazines shouldn't get magazine + 1.
		chamber_round()
	else
		chamber_round(replace_new_round = TRUE)

	update_appearance()
	RegisterSignal(src, COMSIG_ITEM_RECHARGED, PROC_REF(instant_reload))

/obj/item/gun/ballistic/Destroy()
	QDEL_NULL(magazine)
	QDEL_NULL(bolt)
	return ..()

/obj/item/gun/ballistic/vv_edit_var(vname, vval)
	. = ..()
	if(vname in list(NAMEOF(src, suppressor_x_offset), NAMEOF(src, suppressor_y_offset), NAMEOF(src, internal_magazine), NAMEOF(src, magazine), NAMEOF(src, chambered), NAMEOF(src, empty_indicator), NAMEOF(src, sawn_off), NAMEOF(src, bolt)))
		update_appearance()

/obj/item/gun/ballistic/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][sawn_off ? "_sawn" : ""]"
	return ..()

/obj/item/gun/ballistic/update_overlays()
	. = ..()
	if(show_bolt_icon)
		. += bolt?.get_overlays() //update_overlays() can get called during Destroy()

	if(suppressed)
		var/mutable_appearance/MA = mutable_appearance(icon, "[icon_state]_suppressor")
		if(suppressor_x_offset)
			MA.pixel_x = suppressor_x_offset
		if(suppressor_y_offset)
			MA.pixel_y = suppressor_y_offset
		. += MA

	if(!chambered && empty_indicator) //this is duplicated in c20's update_overlayss due to a layering issue with the select fire icon.
		. += "[icon_state]_empty"

	if(gun_flags & TOY_FIREARM_OVERLAY)
		. += "[icon_state]_toy"


	if(!magazine || internal_magazine || !mag_display)
		return

	if(special_mags)
		. += "[icon_state]_mag_[initial(magazine.icon_state)]"
		if(mag_display_ammo && !magazine.ammo_count())
			. += "[icon_state]_mag_empty"
		return

	. += "[icon_state]_mag"
	if(!mag_display_ammo)
		return

	var/capacity_number
	switch(get_ammo() / magazine.max_ammo)
		if(1 to INFINITY) //cause we can have one in the chamber.
			capacity_number = 100
		if(0.8 to 1)
			capacity_number = 80
		if(0.6 to 0.8)
			capacity_number = 60
		if(0.4 to 0.6)
			capacity_number = 40
		if(0.2 to 0.4)
			capacity_number = 20
	if(capacity_number)
		. += "[icon_state]_mag_[capacity_number]"


/obj/item/gun/ballistic/do_chamber_update(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(!semi_auto && from_firing)
		return

	var/obj/item/ammo_casing/casing = chambered //Find chambered round
	if(istype(casing)) //there's a chambered round
		if(QDELING(casing))
			stack_trace("Trying to move a qdeleted casing of type [casing.type]!")
			chambered = null

		else if(casing_ejector || !from_firing)
			casing.forceMove(drop_location()) //Eject casing onto ground.
			casing.bounce_away(TRUE)
			SEND_SIGNAL(casing, COMSIG_CASING_EJECTED)
			chambered = null

		else if(empty_chamber)
			chambered = null

	if (chamber_next_round && (magazine?.max_ammo > 1))
		chamber_round()

///Used to chamber a new round and eject the old one
/obj/item/gun/ballistic/proc/chamber_round(keep_bullet = FALSE, spin_cylinder, replace_new_round)
	if (chambered || !magazine)
		return

	if (!magazine.ammo_count())
		return

	chambered = magazine.get_round(keep_bullet || istype(bolt, /datum/gun_bolt/no_bolt))

	if (!istype(bolt, /datum/gun_bolt/open))
		chambered.forceMove(src)
	if(replace_new_round)
		magazine.give_round(new chambered.type)

///updates a bunch of racking related stuff and also handles the sound effects and the like
/obj/item/gun/ballistic/proc/rack(mob/user = null)
	if(bolt.pre_rack(user))
		return

	if (user)
		to_chat(user, span_notice("You rack the [bolt_wording] of [src]."))

	update_chamber(!chambered, FALSE)

	bolt.post_rack()

	update_appearance()

///Drops the bolt from a locked position
/obj/item/gun/ballistic/proc/drop_bolt(mob/user = null)
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	if (user)
		to_chat(user, span_notice("You drop the [bolt_wording] of [src]."))

	chamber_round()
	bolt.is_locked = FALSE
	update_appearance()

///Handles all the logic needed for magazine insertion
/obj/item/gun/ballistic/proc/insert_magazine(mob/user, obj/item/ammo_box/magazine/AM, display_message = TRUE)
	if(!istype(AM, mag_type))
		to_chat(user, span_warning("[AM] doesn't seem to fit into [src]..."))
		return FALSE

	if(user.transferItemToLoc(AM, src))
		magazine = AM
		if (display_message)
			to_chat(user, span_notice("You load [AM] into [src]."))

		if (magazine.ammo_count())
			playsound(src, load_sound, load_sound_volume, load_sound_vary)
		else
			playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)

		bolt.magazine_inserted()
		update_appearance()
		return TRUE

	else
		to_chat(user, span_warning("You cannot seem to get [src] out of your hands!"))
		return FALSE

///Handles all the logic of magazine ejection, if tac_load is set that magazine will be tacloaded in the place of the old eject
/obj/item/gun/ballistic/proc/eject_magazine(mob/user, display_message = TRUE)
	if(internal_magazine || !magazine)
		return FALSE // fuck off

	bolt.magazine_ejected()

	if (magazine.ammo_count())
		playsound(src, eject_sound, eject_sound_volume, eject_sound_vary)
	else
		playsound(src, eject_empty_sound, eject_sound_volume, eject_sound_vary)

	var/obj/item/ammo_box/old_mag = magazine
	magazine = null

	if(!user.put_in_hands(old_mag))
		old_mag.forceMove(drop_location())
	old_mag.update_appearance()

	if (display_message)
		to_chat(user, span_notice("You pull [old_mag] out of [src]."))
	update_appearance()

	return TRUE

/// Removes the magazine from the weapon, or ejects all of it's ammo, based on the bolt type.
/obj/item/gun/ballistic/proc/unload(mob/user)
	if(bolt.unload(user))
		return

	if(internal_magazine)
		return

	if(!magazine)
		to_chat(user, span_warning("There is no magazine in [src]."))
		return

	unwield(user)
	eject_magazine(user, TRUE)

/obj/item/gun/ballistic/can_fire()
	return chambered?.loaded_projectile

/obj/item/gun/ballistic/attackby(obj/item/A, mob/user, params)
	. = ..()
	if (.)
		return

	if (!internal_magazine && istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine)
			insert_magazine(user, AM)
		else
			to_chat(user, span_warning("There is already a [magazine_wording] in [src]."))
		return

	if (isammocasing(A) || istype(A, /obj/item/ammo_box))
		if (istype(bolt, /datum/gun_bolt/no_bolt) || internal_magazine)
			if (chambered && !chambered.loaded_projectile)
				chambered.forceMove(drop_location())
				chambered = null

			var/num_loaded = magazine?.attempt_load_round(A, user, params, TRUE)
			if (num_loaded)
				to_chat(user, span_notice("You load [num_loaded] [cartridge_wording]\s into [src]."))
				playsound(src, load_sound, load_sound_volume, load_sound_vary)

				bolt.loaded_ammo()

				A.update_appearance()
				update_appearance()
			return

	if(istype(A, /obj/item/suppressor))
		var/obj/item/suppressor/S = A
		if(!can_suppress)
			to_chat(user, span_warning("You can't seem to figure out how to fit [S] on [src]!"))
			return

		if(!user.is_holding(src))
			to_chat(user, span_warning("You need be holding [src] to fit [S] to it!"))
			return

		if(suppressed)
			to_chat(user, span_warning("[src] already has a suppressor!"))
			return

		if(user.transferItemToLoc(A, src))
			to_chat(user, span_notice("You attach [S] to [src]."))
			install_suppressor(A)
			return

	if (can_be_sawn_off)
		if (sawoff(user, A))
			return

	if(can_misfire && istype(A, /obj/item/stack/sheet/cloth))
		if(guncleaning(user, A))
			return

	return FALSE

/obj/item/gun/ballistic/do_fire_gun(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(magazine && chambered?.loaded_projectile && can_misfire && misfire_probability > 0)
		if(prob(misfire_probability))
			if(blow_up(user))
				to_chat(user, span_userdanger("[src] misfires!"))
			return FALSE

	if (sawn_off)
		bonus_spread += SAWN_OFF_ACC_PENALTY
	return ..()

///Installs a new suppressor, assumes that the suppressor is already in the contents of src
/obj/item/gun/ballistic/proc/install_suppressor(obj/item/suppressor/S)
	suppressed = S
	w_class += S.w_class //so pistols do not fit in pockets when suppressed
	update_appearance()
	verbs += /obj/item/gun/proc/user_remove_suppressor

/obj/item/gun/ballistic/clear_suppressor()
	if(!can_unsuppress)
		return
	if(isitem(suppressed))
		var/obj/item/I = suppressed
		w_class -= I.w_class
	return ..()

/obj/item/gun/ballistic/before_firing(atom/target, mob/user)
	. = ..()
	bolt.before_firing()

/obj/item/gun/ballistic/after_firing(mob/living/user, pointblank, atom/pbtarget, message)
	. = ..()
	if(can_misfire)
		misfire_probability += misfire_percentage_increment
		misfire_probability = clamp(misfire_probability, 0, misfire_probability_cap)

	AddComponent(/datum/component/smell, INTENSITY_NORMAL, SCENT_ODOR, "gunpowder", 3, 15 MINUTES)

/obj/item/gun/ballistic/after_chambering(from_firing)
	. = ..()
	if(!from_firing)
		return

	if (!chambered && !get_ammo())
		if (empty_alarm)
			playsound(src, empty_alarm_sound, empty_alarm_volume, empty_alarm_vary)
			update_appearance()

	bolt.after_chambering()

/obj/item/gun/ballistic/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(modifiers?[RIGHT_CLICK] && !internal_magazine && magazine && user.is_holding(src))
		unload(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/AltClick(mob/user)
	if(!isliving(user) || !user.canUseTopic(src, USE_CLOSE|USE_NEED_HANDS|USE_DEXTERITY))
		return

	unload(user)

/obj/item/gun/ballistic/attack_self(mob/living/user)
	// They need two hands on the gun, or a free hand in general.
	if(!one_hand_rack && !(wielded || user.get_empty_held_index()))
		to_chat(user, span_warning("You need a free hand to do that!"))
		return

	if(bolt.attack_self(user))
		return

	if(!COOLDOWN_FINISHED(src, recent_rack))
		return

	COOLDOWN_START(src, recent_rack, rack_delay)
	rack(user)
	return

/obj/item/gun/ballistic/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(.)
		return

	unload(user)
	return TRUE

/obj/item/gun/ballistic/examine(mob/user)
	. = ..()

	if(show_caliber_on_examine)
		. += "It is chambered in [initial_caliber]."

	if(chambered && !hidden_chambered)
		. += "It has a round in the chamber."

	if (bolt.is_locked)
		. += "The [bolt_wording] is locked."

	if (suppressed)
		. += "It has a suppressor attached."

	if(magazine && internal_magazine)
		. += span_notice(magazine.get_ammo_desc())

	if(can_misfire)
		. += span_danger("You get the feeling this might explode if you fire it....")

///Gets the number of bullets in the gun
/obj/item/gun/ballistic/proc/get_ammo(countchambered = TRUE)
	var/bullets = 0 //No silly variable names on my watch.
	if (chambered && countchambered)
		bullets++
	if (magazine)
		bullets += magazine.ammo_count()
	return bullets

///gets a list of every bullet in the gun
/obj/item/gun/ballistic/proc/get_ammo_list(countchambered = TRUE, drop_all = FALSE)
	var/list/rounds = list()
	if(chambered && countchambered)
		rounds.Add(chambered)
		if(drop_all)
			chambered = null
	if(magazine)
		rounds.Add(magazine.ammo_list(drop_all))
	return rounds

#define BRAINS_BLOWN_THROW_RANGE 3
#define BRAINS_BLOWN_THROW_SPEED 1

/obj/item/gun/ballistic/suicide_act(mob/living/user)
	var/obj/item/organ/brain/B = user.getorganslot(ORGAN_SLOT_BRAIN)
	if (B && chambered && chambered.loaded_projectile && can_trigger_gun(user) && !chambered.loaded_projectile.nodamage)
		user.visible_message(span_suicide("[user] is putting the barrel of [src] in [user.p_their()] mouth. It looks like [user.p_theyre()] trying to commit suicide!"))
		sleep(2.5 SECONDS)
		if(user.is_holding(src))
			var/turf/T = get_turf(user)
			do_fire_gun(user, user, FALSE, null, BODY_ZONE_HEAD)
			user.visible_message(span_suicide("[user] blows [user.p_their()] brain[user.p_s()] out with [src]!"))
			var/turf/target = get_ranged_target_turf(user, turn(user.dir, 180), BRAINS_BLOWN_THROW_RANGE)
			B.Remove(user)
			B.forceMove(T)
			var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_atom_to_turf), /obj/effect/gibspawner/generic, B, 1, FALSE, user)
			B.throw_at(target, BRAINS_BLOWN_THROW_RANGE, BRAINS_BLOWN_THROW_SPEED, callback=gibspawner)
			return BRUTELOSS
		else
			user.visible_message(span_suicide("[user] panics and starts choking to death!"))
			return OXYLOSS
	else
		user.visible_message(span_suicide("[user] is pretending to blow [user.p_their()] brain[user.p_s()] out with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b>"))
		playsound(src, dry_fire_sound, 30, TRUE)
		return OXYLOSS

#undef BRAINS_BLOWN_THROW_SPEED
#undef BRAINS_BLOWN_THROW_RANGE

GLOBAL_LIST_INIT(gun_saw_types, typecacheof(list(
	/obj/item/gun/energy/plasmacutter,
	/obj/item/melee/energy,
	/obj/item/dualsaber
	)))

///Handles all the logic of sawing off guns,
/obj/item/gun/ballistic/proc/sawoff(mob/user, obj/item/saw, handle_modifications = TRUE)
	if(!(saw.sharpness & SHARP_EDGED) || (!is_type_in_typecache(saw, GLOB.gun_saw_types) && saw.tool_behaviour != TOOL_SAW)) //needs to be sharp. Otherwise turned off eswords can cut this.
		return
	if(sawn_off)
		to_chat(user, span_warning("[src] is already shortened!"))
		return
	if(bayonet)
		to_chat(user, span_warning("You cannot saw-off [src] with [bayonet] attached!"))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("[user] begins to shorten [src]."), span_notice("You begin to shorten [src]..."))

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message(span_danger("[src] goes off!"), span_danger("[src] goes off in your face!"))
		return

	if(do_after(user, 30, target = src))
		if(sawn_off)
			return
		user.visible_message(span_notice("[user] shortens [src]!"), span_notice("You shorten [src]."))
		sawn_off = TRUE
		if(handle_modifications)
			name = "sawn-off [src.name]"
			desc = sawn_desc
			w_class = WEIGHT_CLASS_NORMAL
			//The file might not have a "gun" icon, let's prepare for this
			lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
			righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
			inhand_x_dimension = 32
			inhand_y_dimension = 32
			inhand_icon_state = "gun"
			worn_icon_state = "gun"
			slot_flags &= ~ITEM_SLOT_BACK //you can't sling it on your back
			slot_flags |= ITEM_SLOT_BELT //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
			recoil = SAWN_OFF_RECOIL
			update_appearance()
		return TRUE

/obj/item/gun/ballistic/proc/guncleaning(mob/user, obj/item/A)
	if(misfire_probability == 0)
		to_chat(user, span_notice("[src] seems to be already clean of fouling."))
		return

	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("[user] begins to cleaning [src]."), span_notice("You begin to clean the internals of [src]."))

	if(do_after(user, 100, target = src))
		var/original_misfire_value = initial(misfire_probability)
		if(misfire_probability > original_misfire_value)
			misfire_probability = original_misfire_value
			user.visible_message(span_notice("[user] cleans [src] of any fouling."), span_notice("You clean [src], removing any fouling, preventing misfire."))
			return TRUE

/obj/item/gun/ballistic/wrench_act(mob/living/user, obj/item/I)
	if(!user.is_holding(src))
		to_chat(user, span_notice("You need to hold [src] to modify it."))
		return TRUE

	if(!can_modify_ammo)
		return

	if(bolt.type == /datum/gun_bolt)
		if(get_ammo())
			to_chat(user, span_notice("You can't get at the internals while the gun has a bullet in it!"))
			return

		else if(!bolt.is_locked)
			to_chat(user, span_notice("You can't get at the internals while the bolt is down!"))
			return

	to_chat(user, span_notice("You begin to tinker with [src]..."))
	I.play_tool_sound(src)
	if(!I.use_tool(src, user, 3 SECONDS))
		return TRUE

	if(blow_up(user))
		user.visible_message(span_danger("[src] goes off!"), span_danger("[src] goes off in your face!"))
		return

	if(alternative_caliber)
		if(magazine.caliber == initial_caliber)
			magazine.caliber = alternative_caliber
			if(alternative_ammo_misfires)
				can_misfire = TRUE
			fire_sound = alternative_fire_sound
			to_chat(user, span_notice("You modify [src]. Now it will fire [alternative_caliber] rounds."))
		else
			magazine.caliber = initial_caliber
			if(alternative_ammo_misfires)
				can_misfire = FALSE
			fire_sound = initial_fire_sound
			to_chat(user, span_notice("You reset [src]. Now it will fire [initial_caliber] rounds."))

///used for sawing guns, causes the gun to fire without the input of the user
/obj/item/gun/ballistic/proc/blow_up(mob/user)
	. = FALSE
	for(var/obj/item/ammo_casing/AC in magazine.stored_ammo)
		if(AC.loaded_projectile)
			do_fire_gun(user, user, FALSE)
			. = TRUE

/obj/item/gun/ballistic/proc/instant_reload()
	SIGNAL_HANDLER
	if(magazine)
		magazine.top_off()
	else
		if(!mag_type)
			return
		magazine = new mag_type(src)
	chamber_round()
	update_appearance()

/obj/item/suppressor
	name = "suppressor"
	desc = "A syndicate small-arms suppressor for maximum espionage."
	icon = 'icons/obj/guns/ballistic.dmi'
	icon_state = "suppressor"
	w_class = WEIGHT_CLASS_TINY


/obj/item/suppressor/specialoffer
	name = "cheap suppressor"
	desc = "A foreign knock-off suppressor, it feels flimsy, cheap, and brittle. Still fits most weapons."
