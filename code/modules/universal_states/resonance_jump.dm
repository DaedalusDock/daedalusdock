/datum/universal_state/resonance_jump
	name = "Resonance Jump"
	desc = "Everything's all blue..."

	var/list/mob/affected_mobs = list()
	var/list/mob/affected_ghosts = list()
	var/list/echos = list()

/datum/universal_state/resonance_jump/OnEnter()
	. = ..()
	for(var/z_level in affecting_zlevels)
		for(var/mob/dead/observer/O as anything in GLOB.dead_player_list)
			O.mouse_opacity = 0	//can't let you click that Dave
			O.set_invisibility(SEE_INVISIBLE_LIVING)
			O.alpha = 255
			affected_ghosts += O

		for(var/mob/living/L as anything in GLOB.mob_living_list)
			if((L.z != z_level) || (L.stat == DEAD))
				continue

			apply_bluespaced(L)
			CHECK_TICK

/datum/universal_state/resonance_jump/OnExit()
	. = ..()
	for(var/mob/dead/observer/ghost as anything in affected_ghosts)
		ghost.mouse_opacity = initial(ghost.mouse_opacity)
		ghost.set_invisibility(initial(ghost.invisibility))
		ghost.alpha = initial(ghost.alpha)

	for(var/mob/living/L as anything in affected_mobs)
		if(QDELETED(L))
			continue

		clear_bluespaced(L)
		CHECK_TICK

	QDEL_LIST(echos)

/datum/universal_state/resonance_jump/proc/apply_bluespaced(mob/living/M)
	affected_mobs += M
	if(M.client)
		to_chat(M,"<span class='notice'>You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly.</span>")
		M.overlay_fullscreen("bluespace", /atom/movable/screen/fullscreen/bluespace_overlay)

	M.adjust_timed_status_effect(2 SECONDS, /datum/status_effect/confusion)

	echos += new/obj/effect/abstract/blueecho(get_turf(M), M)

/datum/universal_state/resonance_jump/proc/clear_bluespaced(mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		M.clear_fullscreen("bluespace")

/obj/effect/abstract/blueecho
	name = "bluespace echo"
	desc = "It's not going to punch you, is it?"

	speech_span = null
	var/mob/living/carbon/human/daddy
	var/atom/movable/virtualspeaker/voice
	var/reality = 0

/obj/effect/abstract/blueecho/Initialize(loc, mob/living/parent)
	. = ..()
	if(!istype(parent))
		return INITIALIZE_HINT_QDEL
	daddy = parent
	setDir(daddy.dir)
	appearance = daddy.appearance
	RegisterSignal(daddy, COMSIG_MOVABLE_MOVED, PROC_REF(mirror))
	RegisterSignal(daddy, COMSIG_ATOM_DIR_CHANGE, PROC_REF(mirror_dir))
	RegisterSignal(daddy, COMSIG_PARENT_QDELETING, PROC_REF(kill_me))
	RegisterSignal(daddy, COMSIG_MOB_SAY, PROC_REF(mimic_speech))

	verb_ask = daddy.verb_ask
	verb_say = daddy.verb_say
	verb_exclaim = daddy.verb_exclaim
	verb_yell = daddy.verb_yell
	verb_whisper = daddy.verb_whisper
	verb_sing = daddy.verb_sing

/obj/effect/abstract/blueecho/Destroy()
	daddy = null
	return ..()

/obj/effect/abstract/blueecho/proc/mirror(datum/source, old_loc, ndir)
	var/new_loc = get_turf(source)
	ndir = REVERSE_DIR(ndir)
	appearance = daddy.appearance
	var/nloc = get_step(src, ndir)
	if(nloc)
		forceMove(nloc)
	if(nloc == new_loc)
		reality++
		if(reality > 5)
			to_chat(daddy, "<span class='notice'>Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended...</span>")
			blackmirror()
		else if(reality > 3)
			to_chat(daddy, "<span class='danger'>Something is definitely wrong. Why do you think YOU are the original?</span>")
		else
			to_chat(daddy, "<span class='warning'>You feel a bit less real. Which one of you two was original again?..</span>")

/obj/effect/abstract/blueecho/proc/mirror_dir(datum/source, ld_dir, new_dir)
	setDir(REVERSE_DIR(new_dir))

/obj/effect/abstract/blueecho/examine(mob/user)
	return daddy?.examine(user)

/obj/effect/abstract/blueecho/proc/mimic_speech(datum/source, list/arguments)
	var/speech_args = arguments.Copy()
	speech_args[1] = html_decode(speech_args[1])
	say(arglist(speech_args))

/obj/effect/abstract/blueecho/proc/kill_me()
	qdel(src)

/obj/effect/abstract/blueecho/proc/blackmirror()
	var/mob/living/carbon/human/H
	if(ishuman(daddy))
		H = new
		H.forceMove(get_turf(src))
		daddy.dna.copy_dna(H.dna)
		H.set_species(daddy.dna.species.type)
		for(var/obj/item/entry as anything in daddy.get_equipped_items(TRUE))
			entry.forceMove(H.loc) //steals instead of copies so we don't end up with duplicates
			H.equip_to_appropriate_slot(entry)
	else
		H = new daddy.type(get_turf(src))
		H.appearance = daddy.appearance

	H.real_name = daddy.real_name
	daddy.dust(TRUE)
	qdel(src)

/mob/living/proc/echo(turf/location)
	location ||= get_turf(src)
	new /obj/effect/abstract/blueecho(location, src)
