/obj/structure
	icon = 'icons/obj/structures.dmi'
	max_integrity = 300
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	var/climb_time = 20
	var/climb_stun = 20
	var/mob/living/structureclimber
	var/broken = 0 //similar to machinery's stat BROKEN
	var/barricade = TRUE //set to true to allow projectiles to always pass over it, default false (checks vs density)
	var/proj_pass_rate = 65 //if barricade=1, sets how many projectiles will pass the cover. Lower means stronger cover
	layer = BELOW_OBJ_LAYER
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.6

/obj/structure/Destroy()
	GLOB.cameranet.updateVisibility(src)
	if(smooth)
		queue_smooth_neighbors(src)
	return ..()
#warn fix snowflake climbing stuff
/*
/obj/structure/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(structureclimber && structureclimber != user)
		user.DelayNextAction(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		structureclimber.DefaultCombatKnockdown(40)
		structureclimber.visible_message("<span class='warning'>[structureclimber] has been knocked off [src].", "You're knocked off [src]!", "You see [structureclimber] get knocked off [src].</span>")

/obj/structure/ui_act(action, params)
	. = ..()
	add_fingerprint(usr)

/obj/structure/proc/do_climb(atom/movable/A)
	if(climbable)
		density = FALSE
		. = step(A,get_dir(A,src.loc))
		density = TRUE

/obj/structure/proc/climb_structure(mob/living/user)
	src.add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] starts climbing onto [src].</span>", \
								"<span class='notice'>You start climbing onto [src]...</span>")
	var/adjusted_climb_time = climb_time
	if(user.restrained()) //climbing takes twice as long when restrained.
		adjusted_climb_time *= 2
	if(isalien(user))
		adjusted_climb_time *= 0.25 //aliens are terrifyingly fast
	if(HAS_TRAIT(user, TRAIT_FREERUNNING)) //do you have any idea how fast I am???
		adjusted_climb_time *= 0.8
	structureclimber = user
	if(do_mob(user, user, adjusted_climb_time))
		if(src.loc) //Checking if structure has been destroyed
			if(do_climb(user))
				user.visible_message("<span class='warning'>[user] climbs onto [src].</span>", \
									"<span class='notice'>You climb onto [src].</span>")
				log_combat(user, src, "climbed onto")
				if(climb_stun)
					user.Stun(climb_stun)
				. = 1
			else
				to_chat(user, "<span class='warning'>You fail to climb onto [src].</span>")
	structureclimber = null
*/
/obj/structure/CanPass(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	if(istype(mover, /obj/item/projectile)) // Treats especifically projectiles
		var/obj/item/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		else if(prob(proj_pass_rate))
			return 1
		else if(barricade == FALSE)
			return !density
		else if(density == FALSE)
			return 1
		return 0
	else // All other than projectiles should use the regular CanPass inheritance
		return ..()
