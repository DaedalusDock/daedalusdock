/datum/mutation/human/void
	name = "Void Magnet"
	desc = "A rare genome that attracts odd forces not usually observed."
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = "<span class='notice'>You feel a heavy, dull force just beyond the walls watching you.</span>"
	instability = 30
	power_path = /datum/action/cooldown/spell/void
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/void/on_life(delta_time, times_fired)
	// Move this onto the spell itself at some point?
	var/datum/action/cooldown/spell/void/curse = locate(power_path) in owner
	if(!curse)
		remove()
		return

	if(!curse.is_valid_target(owner))
		return

	//very rare, but enough to annoy you hopefully. + 0.5 probability for every 10 points lost in stability
	if(DT_PROB((0.25 + ((100 - dna.stability) / 40)) * GET_MUTATION_SYNCHRONIZER(src), delta_time))
		curse.cast(owner)

/datum/action/cooldown/spell/void
	name = "Convoke Void" //magic the gathering joke here
	desc = "A rare genome that attracts odd forces not usually observed. May sometimes pull you in randomly."
	button_icon_state = "void_magnet"

	school = SCHOOL_EVOCATION
	cooldown_time = 1 MINUTES

	invocation = "DOOOOOOOOOOOOOOOOOOOOM!!!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = NONE

/datum/action/cooldown/spell/void/is_valid_target(atom/cast_on)
	return isturf(cast_on.loc)

/datum/action/cooldown/spell/void/cast(atom/cast_on)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(cast_on), cast_on)

/obj/effect/immortality_talisman
	name = "hole in reality"
	desc = "It's shaped an awful lot like a person."
	icon_state = "blank"
	icon = 'icons/effects/effects.dmi'
	var/vanish_description = "vanishes from reality"
	// Weakref to the user who we're "acting" on
	var/datum/weakref/user_ref

/obj/effect/immortality_talisman/Initialize(mapload, mob/new_user)
	. = ..()
	if(new_user)
		vanish(new_user)

/obj/effect/immortality_talisman/Destroy()
	// If we have a mob, we need to free it before cleanup
	// This is a safety to prevent nuking a human, not so much a good pattern in general
	unvanish()
	return ..()

/obj/effect/immortality_talisman/proc/unvanish()
	var/mob/user = user_ref?.resolve()
	user_ref = null

	if(!user)
		return

	user.status_flags &= ~GODMODE
	user.notransform = FALSE
	user.forceMove(get_turf(src))
	user.visible_message(span_danger("[user] pops back into reality!"))

/obj/effect/immortality_talisman/proc/vanish(mob/user)
	user.visible_message(span_danger("[user] [vanish_description], leaving a hole in [user.p_their()] place!"))

	desc = "It's shaped an awful lot like [user.name]."
	setDir(user.dir)

	user.forceMove(src)
	user.notransform = TRUE
	user.status_flags |= GODMODE

	user_ref = WEAKREF(user)

	addtimer(CALLBACK(src, PROC_REF(dissipate)), 10 SECONDS)

/obj/effect/immortality_talisman/proc/dissipate()
	qdel(src)

/obj/effect/immortality_talisman/attackby()
	return

/obj/effect/immortality_talisman/relaymove(mob/living/user, direction)
	// Won't really come into play since our mob has TRAIT_NO_TRANSFORM and cannot move,
	// but regardless block all relayed moves, because no, you cannot move in the void.
	return

/obj/effect/immortality_talisman/singularity_pull()
	return

/obj/effect/immortality_talisman/void
	vanish_description = "is dragged into the void"
