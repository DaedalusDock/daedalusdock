/obj/item/gun/ballistic/revolver
	name = "\improper .357 revolver"
	desc = "A suspicious revolver. Uses .357 ammo."
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	fire_sound_volume = 90
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	rack_sound = 'sound/weapons/gun/revolver/hammer_cock.ogg'
	rack_sound_volume = 15
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt = /datum/gun_bolt/no_bolt

	var/spin_delay = 10
	var/recent_spin = 0
	var/last_fire = 0

/obj/item/gun/ballistic/revolver/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_RMB] = "Spin barrel"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/gun/ballistic/revolver/get_controls_info()
	. = ..()
	. += "Right Click - Spin barrel."

/obj/item/gun/ballistic/revolver/do_fire_gun(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	. = ..()
	last_fire = world.time

/obj/item/gun/ballistic/revolver/chamber_round(keep_bullet, spin_cylinder = TRUE, replace_new_round)
	if(!magazine) //if it mag was qdel'd somehow.
		CRASH("revolver tried to chamber a round without a magazine!")

	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	if(auto_chamber)
		chamber_round(spin_cylinder = TRUE)

/obj/item/gun/ballistic/revolver/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	spin()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/revolver/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	spin()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !M.is_holding(src))
		return

	if (recent_spin > world.time)
		return

	recent_spin = world.time + spin_delay

	if(do_spin())
		playsound(usr, SFX_REVOLVER_SPIN, 30, FALSE)
		usr.visible_message(span_notice("[usr] spins [src]'s chamber."))
		return TRUE
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(spin_cylinder = FALSE)

/obj/item/gun/ballistic/revolver/verb/inspect_cylinder()
	set name = "Inspect Cylinder"
	set category = "Object"
	set desc = "Inspect the contents of the cylinder."
	set waitfor = FALSE

	if(!isliving(usr) || !usr.canUseTopic(src, USE_IGNORE_TK|USE_CLOSE|USE_NEED_HANDS))
		return

	var/mob/living/user = usr
	var/inspected_chamber = 1
	user.visible_message(span_notice("[user] begins inspecting [src]'s cylinder."))

	while(inspected_chamber <= length(magazine.stored_ammo) && user.canUseTopic(src, USE_IGNORE_TK|USE_CLOSE|USE_NEED_HANDS))

		//0.2 seconds at 18 fine motor, 2 seconds at 3
		var/inspect_delay = 1 SECONDS * user.stats.get_skill_as_scalar(/datum/rpg_skill/fine_motor, 5, inverse = TRUE)

		if(!do_after(user, src, inspect_delay, DO_IGNORE_USER_LOC_CHANGE|DO_RESTRICT_CLICKING|DO_PUBLIC, display = src))
			return

		playsound(src, 'sound/weapons/gun/revolver/load_bullet.ogg', 50, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)

		var/obj/item/ammo_casing/casing = magazine.stored_ammo[inspected_chamber]
		if(!casing)
			to_chat(user, span_obviousnotice("The [thtotext(inspected_chamber)] chamber is empty."))
		else
			var/casing_str
			if(!casing.loaded_projectile)
				casing_str = "empty [casing.name]"
			else
				casing_str = "loaded [casing.name]"
			to_chat(user, span_obviousnotice("The [thtotext(inspected_chamber)] chamber has \a [casing_str]."))

		inspected_chamber++

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	if(user == get(loc, /mob) && get_ammo(FALSE, TRUE))
		. += span_info("[live_ammo ? live_ammo : "None"] of them are live rounds.")

/obj/item/gun/ballistic/revolver/ignition_effect(atom/A, mob/user)
	if(last_fire && last_fire + 15 SECONDS > world.time)
		. = span_notice("[user] touches the end of [src] to \the [A], using the residual heat to ignite it in a puff of smoke. What a badass.")

/obj/item/gun/ballistic/revolver/detective
	name = "\improper Colt Detective Special"
	desc = "A revolver with a small horse engraved into it."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	icon_state = "detective"
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	can_modify_ammo = TRUE
	initial_caliber = CALIBER_38
	initial_fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	alternative_caliber = CALIBER_357
	alternative_fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	alternative_ammo_misfires = TRUE
	misfire_probability = 0
	misfire_percentage_increment = 25 //about 1 in 4 rounds, which increases rapidly every shot

/obj/item/gun/ballistic/revolver/detective/examine(mob/user)
	. = ..()
	var/datum/roll_result/result = user.get_examine_result("detgun_examine",)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		. += result.create_tooltip("No mere firearm – a cultural artifact. An all-time classic, chambered in .38 Special and packing six rounds, perfect for six criminals. ", body_only = TRUE)

/obj/item/gun/ballistic/revolver/detective/disco_flavor(mob/living/carbon/human/user, nearby, is_station_level)
	. = ..()
	if(user.mind?.assigned_role?.title != JOB_DETECTIVE)
		return

	var/datum/roll_result/result = user.get_examine_result("detgun_suicide_flavor", /datum/rpg_skill/fourteen_eyes, only_once = TRUE)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		to_chat(
			user,
			result.create_tooltip("You should shoot yourself with it. Preferably in the head."),
		)

/obj/item/gun/ballistic/revolver/syndicate
	name = "\improper Syndicate Revolver"
	desc = "A modernized 7 round revolver manufactured by Waffle Co. Uses .357 ammo."
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/mateba
	name = "\improper Unica 6 auto-revolver"
	desc = "A retro high-powered autorevolver typically used by officers of the New Russia military. Uses .357 ammo."
	icon_state = "mateba"

/obj/item/gun/ballistic/revolver/golden
	name = "\improper Golden revolver"
	desc = "This ain't no game, ain't never been no show, And I'll gladly gun down the oldest lady you know. Uses .357 ammo."
	icon_state = "goldrevolver"
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	recoil = 8
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/nagant
	name = "\improper Nagant revolver"
	desc = "An old model of revolver that originated in Russia. Able to be suppressed. Uses 7.62x38mmR ammo."
	icon_state = "nagant"
	can_suppress = TRUE

	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev762


// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/gun/ballistic/revolver/russian
	name = "\improper Russian revolver"
	desc = "A Russian-made revolver for drinking games. Uses .357 ammo, and has a mechanism requiring you to spin the chamber before each trigger pull."
	icon_state = "russianrevolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = FALSE
	hidden_chambered = TRUE //Cheater.
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/ballistic/revolver/russian/do_spin()
	. = ..()
	if(.)
		spun = TRUE

/obj/item/gun/ballistic/revolver/russian/attackby(obj/item/A, mob/user, params)
	..()
	if(get_ammo() > 0)
		spin()
	update_appearance()
	A.update_appearance()
	return

/obj/item/gun/ballistic/revolver/russian/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/russian/attack_self(mob/user)
	if(!spun)
		spin()
		spun = TRUE
		return
	..()

/obj/item/gun/ballistic/revolver/russian/try_fire_gun(atom/target, mob/living/user, flag, params)
	. = ..(null, user, flag, params)

	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.combat_mode) // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		playsound(src, dry_fire_sound, 30, TRUE)
		user.visible_message(
			span_danger("[user.name] tries to fire \the [src] at the same time, but only succeeds at looking like an idiot."), \
			span_danger("\The [src]'s anti-combat mechanism prevents you from firing it at anyone but yourself!"))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			to_chat(user, span_warning("You need to spin \the [src]'s chamber first!"))
			return

		spun = FALSE

		var/zone = deprecise_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = H.get_bodypart(zone)
		var/is_target_face = zone == BODY_ZONE_HEAD || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire_casing(user, user, params, distro = 0, quiet = 0, zone_override = null, spread = 0, fired_from = src))
				playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
				if(is_target_face)
					shoot_self(user, affecting)
				else
					user.visible_message(span_danger("[user.name] cowardly fires [src] at [user.p_their()] [affecting.name]!"), span_userdanger("You cowardly fire [src] at your [affecting.name]!"), span_hear("You hear a gunshot!"))
				chambered = null
				return

		user.visible_message(span_danger("*click*"))
		playsound(src, dry_fire_sound, 30, TRUE)

/obj/item/gun/ballistic/revolver/russian/proc/shoot_self(mob/living/carbon/human/user, affecting = BODY_ZONE_HEAD)
	user.apply_damage(300, BRUTE, affecting)
	user.visible_message(span_danger("[user.name] fires [src] at [user.p_their()] head!"), span_userdanger("You fire [src] at your head!"), span_hear("You hear a gunshot!"))

/obj/item/gun/ballistic/revolver/russian/soul
	name = "cursed Russian revolver"
	desc = "To play with this revolver requires wagering your very soul."

/obj/item/gun/ballistic/revolver/russian/soul/shoot_self(mob/living/user)
	. = ..()
	var/obj/item/soulstone/anybody/revolver/stone = new /obj/item/soulstone/anybody/revolver(get_turf(src))
	if(!stone.capture_soul(user, forced = TRUE)) //Something went wrong
		qdel(stone)
		return
	user.visible_message(span_danger("[user.name]'s soul is captured by \the [src]!"), span_userdanger("You've lost the gamble! Your soul is forfeit!"))

/obj/item/gun/ballistic/revolver/reverse //Fires directly at its user... unless the user is a clown, of course.
	name = "\improper Syndicate Revolver"
	clumsy_check = FALSE
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/reverse/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_CLUMSY) || is_clown_job(user.mind?.assigned_role))
		return ..()
	if(do_fire_gun(user, user, FALSE, null, BODY_ZONE_HEAD))
		user.visible_message(span_warning("[user] somehow manages to shoot [user.p_them()]self in the face!"), span_userdanger("You somehow shoot yourself in the face! How the hell?!"))
		user.emote("agony")
		user.drop_all_held_items()
		user.Paralyze(80)


/obj/item/gun/ballistic/revolver/single_action
	name = "single action revolver"

	one_hand_rack = TRUE
	auto_chamber = FALSE // SAAs rotate the cylinder when the hammer is cocked.

	var/hammer_cocked = FALSE

/obj/item/gun/ballistic/revolver/single_action/get_controls_info()
	. = ..()
	. += "Activate - Cock hammer."

/obj/item/gun/ballistic/revolver/single_action/update_icon_state()
	icon_state = hammer_cocked ? "[base_icon_state]_cocked" : base_icon_state
	return ..()

/obj/item/gun/ballistic/revolver/single_action/examine(mob/user)
	. = ..()
	if((user in viewers(4, loc)))
		. += span_info("The hammer is [hammer_cocked ? "cocked" : "at rest."]")
	else
		. += span_alert("You can not see if the hammer is cocked.")

/obj/item/gun/ballistic/revolver/single_action/proc/toggle_hammer(mob/user)
	PRIVATE_PROC(TRUE)

	if(hammer_cocked)
		user?.visible_message(span_subtle("[user] decocks the hammer of [src]."), vision_distance = COMBAT_MESSAGE_RANGE)
		hammer_cocked = FALSE
		update_appearance()
		return

	user?.visible_message(span_subtle("[user] cocks the hammer of [src]."), vision_distance = COMBAT_MESSAGE_RANGE)
	hammer_cocked = TRUE
	update_chamber(!chambered, TRUE, TRUE)
	bolt.post_rack()
	update_appearance()

/obj/item/gun/ballistic/revolver/single_action/rack(mob/living/user)
	var/datum/roll_result/result = user.stat_roll(3, /datum/rpg_skill/fine_motor) // You can only fail this if you have fine-motor debuffs or just eat shit on the crit roll.
	switch(result.outcome)
		if(CRIT_FAILURE, FAILURE)
			result.do_skill_sound(user)
			to_chat(user, result.create_tooltip("Your finger slips off the hammer."))
			return FALSE

	toggle_hammer(user)
	user.changeNext_move(CLICK_CD_RAPID)
	return TRUE

/obj/item/gun/ballistic/revolver/single_action/can_fire()
	if(!hammer_cocked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/single_action/shoot_with_empty_chamber(mob/living/user)
	. = ..()
	if(hammer_cocked)
		toggle_hammer()

/obj/item/gun/ballistic/revolver/single_action/do_fire_gun(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	. = ..()
	if(hammer_cocked)
		toggle_hammer()

/obj/item/gun/ballistic/revolver/single_action/dry_fire_feedback(mob/user)
	if(!hammer_cocked)
		to_chat(user, span_warning("The trigger pulls back with no resistance."))
		return
	return ..()

//SEC REVOLVER
/obj/item/gun/ballistic/revolver/single_action/juno
	name = "single action revolver 'Juno'"
	desc = "A mass-produced single-action revolver."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	icon_state = "juno"
	base_icon_state = "juno"
	initial_caliber = CALIBER_38
	alternative_caliber = CALIBER_357
	alternative_ammo_misfires = FALSE
