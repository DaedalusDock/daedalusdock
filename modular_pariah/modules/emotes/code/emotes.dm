
#define EMOTE_DELAY 5 SECONDS //To prevent spam emotes.

/mob
	var/nextsoundemote = 1 //Time at which the next emote can be played

/datum/emote
	cooldown = EMOTE_DELAY

//Disables the custom emote blacklist from TG that normally applies to slimes.
/datum/emote/living/custom
	mob_type_blacklist_typecache = list(/mob/living/brain)
	cooldown = 0

//me-verb emotes should not have a cooldown check
/datum/emote/living/custom/check_cooldown(mob/user, intentional)
	return TRUE

/datum/emote/living/quill
	key = "quill"
	key_third_person = "quills"
	message = "rustles their quills."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/voxrustle.ogg'

/datum/emote/living/sneeze
	vary = TRUE

/datum/emote/living/snap
	key = "snap"
	key_third_person = "snaps"
	message = "snaps their fingers."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/snap.ogg'

/datum/emote/living/snap2
	key = "snap2"
	key_third_person = "snaps twice"
	message = "snaps twice."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/snap2.ogg'

/datum/emote/living/snap3
	key = "snap3"
	key_third_person = "snaps thrice"
	message = "snaps thrice."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/snap3.ogg'

/datum/emote/living/mothsqueak
	key = "msqueak"
	key_third_person = "lets out a tiny squeak"
	message = "lets out a tiny squeak!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/mothsqueak.ogg'

/datum/emote/living/bark
	key = "bark"
	key_third_person = "barks"
	message = "barks!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/bark2.ogg'

/datum/emote/living/meow
	key = "meow"
	key_third_person = "meows"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/meow.ogg'

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/hiss.ogg'

/datum/emote/living/chitter
	key = "chitter"
	key_third_person = "chitters"
	message = "chitters!"
	emote_type = EMOTE_AUDIBLE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/mothchitter.ogg'

/datum/emote/living/sigh/get_sound(mob/living/user)
	if(iscarbon(user))
		if(user.gender == MALE)
			return 'modular_pariah/modules/emotes/sound/emotes/male/male_sigh.ogg'
		return 'modular_pariah/modules/emotes/sound/emotes/female/female_sigh.ogg'
	return

/datum/emote/living/sniff
	vary = TRUE

/datum/emote/living/sniff/get_sound(mob/living/user)
	if(iscarbon(user))
		if(user.gender == MALE)
			return 'modular_pariah/modules/emotes/sound/emotes/male/male_sniff.ogg'
		return 'modular_pariah/modules/emotes/sound/emotes/female/female_sniff.ogg'
	return

/datum/emote/living/gasp/get_sound(mob/living/user)
	if(iscarbon(user))
		if(user.gender == MALE)
			return pick('modular_pariah/modules/emotes/sound/emotes/male/gasp_m1.ogg',
						'modular_pariah/modules/emotes/sound/emotes/male/gasp_m2.ogg',
						'modular_pariah/modules/emotes/sound/emotes/male/gasp_m3.ogg',
						'modular_pariah/modules/emotes/sound/emotes/male/gasp_m4.ogg',
						'modular_pariah/modules/emotes/sound/emotes/male/gasp_m5.ogg',
						'modular_pariah/modules/emotes/sound/emotes/male/gasp_m6.ogg')
		return pick('modular_pariah/modules/emotes/sound/emotes/female/gasp_f1.ogg',
					'modular_pariah/modules/emotes/sound/emotes/female/gasp_f2.ogg',
					'modular_pariah/modules/emotes/sound/emotes/female/gasp_f3.ogg',
					'modular_pariah/modules/emotes/sound/emotes/female/gasp_f4.ogg',
					'modular_pariah/modules/emotes/sound/emotes/female/gasp_f5.ogg',
					'modular_pariah/modules/emotes/sound/emotes/female/gasp_f6.ogg')
	return

/datum/emote/living/snore
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/snore.ogg'

/datum/emote/living/burp
	vary = TRUE

/datum/emote/living/burp/get_sound(mob/living/user)
	if(iscarbon(user))
		if(user.gender == MALE)
			return 'modular_pariah/modules/emotes/sound/emotes/male/burp_m.ogg'
		return 'modular_pariah/modules/emotes/sound/emotes/female/burp_f.ogg'
	return

/datum/emote/living/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE
	audio_cooldown = 5 SECONDS
	vary = TRUE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)

/datum/emote/living/clap/get_sound(mob/living/user)
	return pick('modular_pariah/modules/emotes/sound/emotes/clap1.ogg',
				'modular_pariah/modules/emotes/sound/emotes/clap2.ogg',
				'modular_pariah/modules/emotes/sound/emotes/clap3.ogg',
				'modular_pariah/modules/emotes/sound/emotes/clap4.ogg')

/datum/emote/living/clap/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	if(user.usable_hands < 2)
		return FALSE
	return ..()

/datum/emote/living/clap1
	key = "clap1"
	key_third_person = "claps once"
	message = "claps once."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	vary = TRUE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)

/datum/emote/living/clap1/get_sound(mob/living/user)
	return pick('modular_pariah/modules/emotes/sound/emotes/claponce2.ogg')

/datum/emote/living/clap1/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	if(user.usable_hands < 2)
		return FALSE
	return ..()

/datum/emote/living/headtilt
	key = "tilt"
	key_third_person = "tilts"
	message = "tilts their head."
	message_AI = "tilts the image on their display."

/datum/emote/beep
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/emotes/twobeep.ogg'
	mob_type_allowed_typecache = list(/mob/living) //Beep already exists on brains and silicons

/datum/emote/living/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "whistles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls"
	message = "lets out a growl."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/growl.ogg'

/datum/emote/living/woof
	key = "woof"
	key_third_person = "woofs"
	message = "lets out a woof."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/wurble
	key = "wurble"
	key_third_person = "wurbles"
	message = "lets out a wurble."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/wurble.ogg'

/datum/emote/living/cackle
	key = "cackle"
	key_third_person = "cackles"
	message = "cackles hysterically!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/cackle_yeen.ogg'

//Froggie Revolution
/datum/emote/living/warble
	key = "warble"
	key_third_person = "warbles"
	message = "warbles!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/warbles.ogg'

/datum/emote/living/trills
	key = "trills"
	key_third_person = "trills!"
	message = "trills!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/trills.ogg'

/datum/emote/living/rpurr
	key = "rpurr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/raptor_purr.ogg'

/datum/emote/living/purr //Ported from CitRP originally by buffyuwu.
	key = "purr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_pariah/modules/emotes/sound/voice/feline_purr.ogg'
