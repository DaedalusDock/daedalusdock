/datum/status_effect/flock_signal
	id = "thesignal"
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

	alert_type = null

	COOLDOWN_DECLARE(next_akira) // LEAVE ME ALOOOOOOONE

	var/list/akira_sounds = list(
		'goon/sounds/flockmind/ArtifactFea1.ogg',
		'goon/sounds/flockmind/ArtifactFea2.ogg',
		'goon/sounds/flockmind/ArtifactFea3.ogg',
		'goon/sounds/flockmind/flockmind_cast.ogg',
		'goon/sounds/flockmind/flockmind_caw.ogg',
		'goon/sounds/flockmind/flockdrone_beep1.ogg',
		'goon/sounds/flockmind/flockdrone_beep2.ogg',
		'goon/sounds/flockmind/flockdrone_beep3.ogg',
		'goon/sounds/flockmind/flockdrone_beep4.ogg',
		'goon/sounds/flockmind/flockdrone_grump1.ogg',
		'goon/sounds/flockmind/flockdrone_grump2.ogg',
		'goon/sounds/flockmind/flockdrone_grump3.ogg',
		'goon/sounds/flockmind/radio_sweep1.ogg',
		'goon/sounds/flockmind/radio_sweep2.ogg',
		'goon/sounds/flockmind/radio_sweep3.ogg',
		'goon/sounds/flockmind/radio_sweep4.ogg',
		'goon/sounds/flockmind/radio_sweep5.ogg'
	)

/datum/status_effect/flock_signal/New(list/arguments)
	. = ..()
	next_akira = rand(3 MINUTES, 7 MINUTES)

/datum/status_effect/flock_signal/on_remove()
	. = ..()
	end_flash()

/datum/status_effect/flock_signal/tick(delta_time, times_fired)
	if(COOLDOWN_FINISHED(src, next_akira))
		COOLDOWN_START(src, next_akira, rand(5 MINUTES, 8 MINUTES))
		flock_flash()

/datum/status_effect/flock_signal/proc/flock_flash()
	var/datum/client_colour/flockcrazy/flock_color = owner.add_client_colour(/datum/client_colour/flockcrazy)
	flock_color.update_colour(flock_color.animated_colour, 20 SECONDS, SINE_EASING)

	owner.playsound_local(get_turf(owner), pick(akira_sounds), 20, TRUE)

	var/message = pick(strings("flock.json", "the_signal"))
	var/flock_text = "<i>... [gradient_text(message, "#3cb5a3", "#124e43")] ...</i>"
	to_chat(owner, flock_text)

	addtimer(CALLBACK(src, PROC_REF(end_flash)), 15 SECONDS)

/datum/status_effect/flock_signal/proc/end_flash()
	owner.remove_client_colour(/datum/client_colour/flockcrazy)
