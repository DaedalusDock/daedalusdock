/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor = list(BLUNT = 42, PUNCTURE = 25, SLASH = 25, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50)
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

	dog_fashion = /datum/dog_fashion/head/helmet

/obj/item/clothing/head/helmet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_HEAD)


/obj/item/clothing/head/helmet/sec

/obj/item/clothing/head/helmet/sec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/sec/attackby(obj/item/attacking_item, mob/user, params)
	if(issignaler(attacking_item))
		var/obj/item/assembly/signaler/attached_signaler = attacking_item
		// There's a flashlight in us. Remove it first, or it'll be lost forever!
		var/obj/item/flashlight/seclite/blocking_us = locate() in src
		if(blocking_us)
			to_chat(user, span_warning("[blocking_us] is in the way, remove it first!"))
			return TRUE

		if(!attached_signaler.secured)
			to_chat(user, span_warning("Secure [attached_signaler] first!"))
			return TRUE
		to_chat(user, span_notice("You add [attached_signaler] to [src]."))
		qdel(attached_signaler)
		var/obj/item/bot_assembly/secbot/secbot_frame = new(loc)

		user.put_in_hands(secbot_frame)
		qdel(src)
		return TRUE
	return ..()

/obj/item/clothing/head/helmet/alt
	name = "bulletproof helmet"
	desc = "A bulletproof combat helmet that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "helmetalt"
	inhand_icon_state = "helmetalt"
	armor = list(BLUNT = 20, PUNCTURE = 60, SLASH = 25, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, FIRE = 50, ACID = 50)
	dog_fashion = null

/obj/item/clothing/head/helmet/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine
	name = "tactical combat helmet"
	desc = "A tactical black helmet, sealed from outside hazards with a plate of glass and not much else."
	icon_state = "marine_command"
	inhand_icon_state = "helmetalt"
	armor = list(BLUNT = 60, PUNCTURE = 50, SLASH = 70, LASER = 30, ENERGY = 25, BOMB = 50, BIO = 100, FIRE = 40, ACID = 50)
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/obj/item/clothing/head/helmet/marine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, starting_light = new /obj/item/flashlight/seclite(src), light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine/security
	name = "marine heavy helmet"
	icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "marine utility helmet"
	icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "marine medic helmet"
	icon_state = "marine_medic"

/obj/item/clothing/head/helmet/old
	name = "degrading helmet"
	desc = "Standard issue security helmet. Due to degradation the helmet's visor obstructs the users ability to see long distances."
	tint = 2

/obj/item/clothing/head/helmet/blueshirt
	name = "blue helmet"
	desc = "A reliable, blue tinted helmet reminding you that you <i>still</i> owe that engineer a beer."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	inhand_icon_state = "helmet"
	toggle_message = "You pull the visor down on"
	alt_toggle_message = "You push the visor up on"
	can_toggle = 1
	armor = list(BLUNT = 60, PUNCTURE = 10, SLASH = 60, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, FIRE = 80, ACID = 80)
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	toggle_cooldown = 0
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	dog_fashion = null
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/head/helmet/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!can_toggle)
		return

	if(user.incapacitated() || world.time <= cooldown + toggle_cooldown)
		return

	cooldown = world.time
	up = !up
	flags_1 ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= visor_flags_cover
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	to_chat(user, span_notice("[up ? alt_toggle_message : toggle_message] \the [src]."))

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.update_slots_for_item(src, user.get_slot_by_item(src), TRUE)

/obj/item/clothing/head/helmet/justice
	name = "helmet of justice"
	desc = "WEEEEOOO. WEEEEEOOO. WEEEEOOOO."
	icon_state = "justice"
	toggle_message = "You turn off the lights on"
	alt_toggle_message = "You turn on the lights on"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	can_toggle = 1
	toggle_cooldown = 20
	dog_fashion = null
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop

/obj/item/clothing/head/helmet/justice/Initialize(mapload)
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/justice/attack_self(mob/user)
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/justice/escape
	name = "alarm helmet"
	desc = "WEEEEOOO. WEEEEEOOO. STOP THAT MONKEY. WEEEOOOO."
	icon_state = "justice2"
	toggle_message = "You turn off the light on"
	alt_toggle_message = "You turn on the light on"

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "An extremely robust, space-worthy helmet in a nefarious red and black stripe pattern."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 90, FIRE = 100, ACID = 100)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	strip_delay = 80
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/head/helmet/police
	name = "police officer's hat"
	desc = "A police officer's Hat. This hat emphasizes that you are THE LAW."
	icon_state = "policehelm"
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION


/obj/item/clothing/head/helmet/constable
	name = "constable helmet"
	desc = "A british looking helmet."
	icon_state = "constable"
	inhand_icon_state = "constable"
	custom_price = PAYCHECK_ASSISTANT * 4.25
	worn_y_offset = 4

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "\improper SWAT helmet"
	desc = "An extremely robust helmet with the Nanotrasen logo emblazoned on the top."
	icon_state = "swat"
	inhand_icon_state = "swat"
	clothing_flags = STACKABLE_HELMET_EXEMPT
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF


/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome"
	armor = list(BLUNT = 80, PUNCTURE = 80, SLASH = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, FIRE = 90, ACID = 90)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80
	dog_fashion = null

/obj/item/clothing/head/helmet/thunderdome/holosuit
	cold_protection = null
	heat_protection = null
	armor = list(BLUNT = 10, PUNCTURE = 10, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/roman
	name = "\improper Roman helmet"
	desc = "An ancient helmet made of bronze and leather."
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor = list(BLUNT = 25, PUNCTURE = 0, SLASH = 0, LASER = 25, ENERGY = 10, BOMB = 10, BIO = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman"
	strip_delay = 100
	dog_fashion = null

/obj/item/clothing/head/helmet/roman/fake
	desc = "An ancient helmet made of plastic and leather."
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "\improper Roman legionnaire helmet"
	desc = "An ancient helmet made of bronze and leather. Has a red crest on top of it."
	icon_state = "roman_c"
	inhand_icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "An ancient helmet made of plastic and leather. Has a red crest on top of it."
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	inhand_icon_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/redtaghelm
	name = "red laser tag helmet"
	desc = "They have chosen their own end."
	icon_state = "redtaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "redtaghelm"
	armor = list(BLUNT = 15, PUNCTURE = 10, SLASH = 0, LASER = 20, ENERGY = 10, BOMB = 20, BIO = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/bluetaghelm
	name = "blue laser tag helmet"
	desc = "They'll need more men."
	icon_state = "bluetaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "bluetaghelm"
	armor = list(BLUNT = 15, PUNCTURE = 10, SLASH = 0, LASER = 20, ENERGY = 10, BOMB = 20, BIO = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/knight
	name = "medieval helmet"
	desc = "A classic metal helmet."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	armor = list(BLUNT = 50, PUNCTURE = 0, SLASH = 50, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, FIRE = 80, ACID = 80) // no wound armor cause getting domed in a bucket head sounds like concussion city
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "knight helmet"
	desc = "A classic medieval helmet, if you hold it upside down you could see that it's actually a bucket."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	armor = list(BLUNT = 35, PUNCTURE = 10, SLASH = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, FIRE = 40, ACID = 40)
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/obj/item/clothing/head/helmet/skull
	name = "skull helmet"
	desc = "An intimidating tribal helmet, it doesn't look very comfortable."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	armor = list(BLUNT = 35, PUNCTURE = 25, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50)
	icon_state = "skull"
	inhand_icon_state = "skull"
	strip_delay = 100

/obj/item/clothing/head/helmet/durathread
	name = "durathread helmet"
	desc = "A helmet made from durathread and leather."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	resistance_flags = FLAMMABLE
	armor = list(BLUNT = 25, PUNCTURE = 0, SLASH = 15, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, FIRE = 40, ACID = 50)
	strip_delay = 60

/obj/item/clothing/head/helmet/rus_helmet
	name = "russian helmet"
	desc = "It can hold a bottle of vodka."
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor = list(BLUNT = 25, PUNCTURE = 30, SLASH = 0, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, FIRE = 20, ACID = 50)

/obj/item/clothing/head/helmet/rus_helmet/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/helmet)

/obj/item/clothing/head/helmet/rus_ushanka
	name = "battle ushanka"
	desc = "100% bear."
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 25, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, FIRE = -10, ACID = 50)

/obj/item/clothing/head/helmet/infiltrator
	name = "infiltrator helmet"
	desc = "The galaxy isn't big enough for the two of us."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flash_protect = FLASH_PROTECTION_WELDER
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	strip_delay = 80
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/head/helmet/elder_atmosian
	name = "\improper Elder Atmosian Helmet"
	desc = "A superb helmet made with the toughest and rarest materials available to man."
	icon_state = "h2helmet"
	inhand_icon_state = "h2helmet"
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 0, LASER = 30, ENERGY = 30, BOMB = 85, BIO = 10, FIRE = 65, ACID = 40)
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

//monkey sentience caps

/obj/item/clothing/head/helmet/monkey_sentience
	name = "monkey mind magnification helmet"
	desc = "A fragile, circuitry embedded helmet for boosting the intelligence of a monkey to a higher level. You see several warning labels..."

	icon_state = "monkeymind"
	inhand_icon_state = "monkeymind"
	strip_delay = 100
	var/mob/living/carbon/human/magnification = null ///if the helmet is on a valid target (just works like a normal helmet if not (cargo please stop))
	var/polling = FALSE///if the helmet is currently polling for targets (special code for removal)
	var/light_colors = 1 ///which icon state color this is (red, blue, yellow)

/obj/item/clothing/head/helmet/monkey_sentience/Initialize(mapload)
	. = ..()
	light_colors = rand(1,3)
	update_appearance()

/obj/item/clothing/head/helmet/monkey_sentience/examine(mob/user)
	. = ..()
	. += span_boldwarning("---WARNING: REMOVAL OF HELMET ON SUBJECT MAY LEAD TO:---")
	. += span_warning("BLOOD RAGE")
	. += span_warning("BRAIN DEATH")
	. += span_warning("PRIMAL GENE ACTIVATION")
	. += span_warning("GENETIC MAKEUP MASS SUSCEPTIBILITY")
	. += span_boldnotice("Ask your CMO if mind magnification is right for you.")

/obj/item/clothing/head/helmet/monkey_sentience/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][light_colors][magnification ? "up" : null]"

/obj/item/clothing/head/helmet/monkey_sentience/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HEAD)
		return
	if(!ismonkey(user) || user.ckey)
		var/mob/living/something = user
		to_chat(something, span_boldnotice("You feel a stabbing pain in the back of your head for a moment."))
		something.apply_damage(5,BRUTE,BODY_ZONE_HEAD,FALSE,FALSE,FALSE) //notably: no damage resist (it's in your helmet), no damage spread (it's in your helmet)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		say("ERROR: Central Command has temporarily outlawed monkey sentience helmets in this sector. NEAREST LAWFUL SECTOR: 2.537 million light years away.")
		return
	magnification = user //this polls ghosts
	visible_message(span_warning("[src] powers up!"))
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	RegisterSignal(magnification, COMSIG_SPECIES_LOSS, PROC_REF(make_fall_off))
	polling = TRUE
	var/list/candidates = poll_candidates_for_mob("Do you want to play as a mind magnified monkey?", ROLE_SENTIENCE, ROLE_SENTIENCE, 5 SECONDS, magnification, POLL_IGNORE_SENTIENCE_POTION)
	polling = FALSE
	if(!magnification)
		return
	if(!candidates.len)
		UnregisterSignal(magnification, COMSIG_SPECIES_LOSS)
		magnification = null
		visible_message(span_notice("[src] falls silent and drops on the floor. Maybe you should try again later?"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		user.dropItemToGround(src)
		return
	var/mob/picked = pick(candidates)
	magnification.key = picked.key
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
	to_chat(magnification, span_notice("You're a mind magnified monkey! Protect your helmet with your life- if you lose it, your sentience goes with it!"))
	var/policy = get_policy(ROLE_MONKEY_HELMET)
	if(policy)
		to_chat(magnification, policy)
	icon_state = "[icon_state]up"

/obj/item/clothing/head/helmet/monkey_sentience/Destroy()
	disconnect()
	return ..()

/obj/item/clothing/head/helmet/monkey_sentience/proc/disconnect()
	if(!magnification) //not put on a viable head
		return
	if(!polling)//put on a viable head, but taken off after polling finished.
		if(magnification.client)
			to_chat(magnification, span_userdanger("You feel your flicker of sentience ripped away from you, as everything becomes dim..."))
			magnification.ghostize(FALSE)
		if(prob(10))
			switch(rand(1,4))
				if(1) //blood rage
					magnification.ai_controller.set_blackboard_key(BB_MONKEY_AGGRESSIVE, TRUE)
				if(2) //brain death
					magnification.apply_damage(500,BRAIN,BODY_ZONE_HEAD,FALSE,FALSE,FALSE)
				if(3) //primal gene (gorilla)
					magnification.gorillize()
				if(4) //genetic mass susceptibility (gib)
					magnification.gib()
	//either used up correctly or taken off before polling finished (punish this by destroying the helmet)
	UnregisterSignal(magnification, COMSIG_SPECIES_LOSS)
	playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
	playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	visible_message(span_warning("[src] fizzles and breaks apart!"))
	magnification = null
	new /obj/effect/decal/cleanable/ash/crematorium(drop_location()) //just in case they're in a locker or other containers it needs to use crematorium ash, see the path itself for an explanation

/obj/item/clothing/head/helmet/monkey_sentience/unequipped(mob/user)
	. = ..()
	if(magnification || polling)
		qdel(src)//runs disconnect code

/obj/item/clothing/head/helmet/monkey_sentience/proc/make_fall_off()
	SIGNAL_HANDLER
	if(magnification)
		visible_message(span_warning("[src] falls off of [magnification]'s head as it changes shape!"))
		magnification.dropItemToGround(src)
