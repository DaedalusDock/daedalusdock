//generic procs copied from obj/effect/alien
/obj/structure/spider
	name = "web"
	icon = 'icons/effects/effects.dmi'
	desc = "It's stringy and sticky."
	anchored = TRUE
	density = FALSE
	max_integrity = 15

/obj/structure/spider/Initialize(mapload)
	. = ..()
	become_atmos_sensitive()

/obj/structure/spider/Destroy()
	lose_atmos_sensitivity()
	return ..()


/obj/structure/spider/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BURN)//the stickiness of the web mutes all attack sounds except fire damage type
		playsound(loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/spider/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == BLUNT)
		switch(damage_type)
			if(BURN)
				damage_amount *= 2
			if(BRUTE)
				damage_amount *= 0.25
	. = ..()

/obj/structure/spider/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature > 300)
		take_damage(5, BURN, 0, 0)

/obj/structure/spider/stickyweb
	///Whether or not the web is from the genetics power
	var/genetic = FALSE
	///Whether or not the web is a sealed web
	var/sealed = FALSE
	icon_state = "stickyweb1"

/obj/structure/spider/stickyweb/attack_hand(mob/user, list/modifiers)
	.= ..()
	if(.)
		return
	if(!HAS_TRAIT(user,TRAIT_WEB_WEAVER))
		return
	user.visible_message(span_notice("[user] begins weaving [src] into cloth."), span_notice("You begin weaving [src] into cloth."))
	if(!do_after(user, time = 2 SECONDS))
		return
	qdel(src)
	var/obj/item/stack/sheet/cloth/woven_cloth = new /obj/item/stack/sheet/cloth
	user.put_in_hands(woven_cloth)

/obj/structure/spider/stickyweb/Initialize(mapload)
	if(!sealed && prob(50))
		icon_state = "stickyweb2"
	. = ..()

/obj/structure/spider/stickyweb/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(genetic)
		return
	if(sealed)
		return FALSE
	else if(isliving(mover))
		if(prob(50))
			to_chat(mover, span_danger("You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/spider/stickyweb/sealed
	name = "sealed web"
	desc = "A solid thick wall of web, airtight enough to block air flow."
	icon_state = "sealedweb"
	sealed = TRUE
	can_atmos_pass = CANPASS_NEVER

/obj/structure/spider/stickyweb/genetic //for the spider genes in genetics
	genetic = TRUE
	var/mob/living/allowed_mob

/obj/structure/spider/stickyweb/genetic/Initialize(mapload, allowedmob)
	allowed_mob = allowedmob
	. = ..()

/obj/structure/spider/stickyweb/genetic/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..() //this is the normal spider web return aka a spider would make this TRUE
	if(mover == allowed_mob)
		return TRUE
	else if(isliving(mover)) //we change the spider to not be able to go through here
		if(allowed_mob.is_grabbing(mover))
			return TRUE
		if(prob(50))
			to_chat(mover, span_danger("You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)
