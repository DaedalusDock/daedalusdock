/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "sadly can't find anybody to give daps to, and daps themself. Shameful."
	message_param = "give daps to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themself."
	message_param = "hugs %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	message_mime = "acts out a scream!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/scream/select_message_type(mob/user, msg, intentional)
	. = ..()
	var/mob/living/carbon/human/human = user
	if(human.dna.species.scream_verb)
		if(human.mind?.miming)
			return "[human.dna.species.scream_verb] silently!"
		else
			return "[human.dna.species.scream_verb]!"

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human = user
	if(human.mind?.miming)
		return
	return human.dna.species.get_scream_sound(human)

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/carbon/human/scream/screech/should_play_sound(mob/user, intentional)
	if(ismonkey(user))
		return TRUE
	return ..()

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/tail/oranges_accessory = user.getorganslot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(oranges_accessory.wag_flags & WAG_WAGGING) //We verified the tail exists in can_run_emote()
		SEND_SIGNAL(user, COMSIG_ORGAN_WAG_TAIL, FALSE)
	else
		SEND_SIGNAL(user, COMSIG_ORGAN_WAG_TAIL, TRUE)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check, intentional)
	var/obj/item/organ/tail/tail = user.getorganslot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(tail?.wag_flags & WAG_ABLE)
		return ..()
	return FALSE
/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/wings/functional/wings = H.getorganslot(ORGAN_SLOT_EXTERNAL_WINGS)
		if(wings && findtext(select_message_type(user,intentional), "open"))
			wings.open_wings()
		else
			wings.close_wings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species.mutant_bodyparts["wings"])
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

//Species emotes
//le epic chimp emotes
/datum/emote/living/carbon/human/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "gnarls and shows its teeth..."
	species_type_whitelist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	hands_use_check = TRUE
	species_type_whitelist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	hands_use_check = TRUE
	species_type_whitelist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/roar
	key = "roar"
	key_third_person = "roars"
	message = "roars."
	emote_type = EMOTE_AUDIBLE
	species_type_whitelist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/tail
	key = "tail"
	message = "waves their tail."
	species_type_whitelist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/monkeysign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	hands_use_check = TRUE
	species_type_whitelist_typecache = list(/datum/species/monkey)


//Moth emotes
/datum/emote/living/mothsqueak
	key = "msqueak"
	key_third_person = "lets out a tiny squeak"
	message = "lets out a tiny squeak!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/mothsqueak.ogg'
	species_type_whitelist_typecache = list(/datum/species/moth)

/datum/emote/living/chitter
	key = "chitter"
	key_third_person = "chitters"
	message = "chitters!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/emotes/mothchitter.ogg'
	species_type_whitelist_typecache = list(/datum/species/moth)

//Felinid emotes
/datum/emote/living/meow
	key = "meow"
	key_third_person = "meows"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/emotes/meow.ogg'
	species_type_whitelist_typecache = list(/datum/species/human/felinid)

/datum/emote/living/purr //Ported from CitRP originally by buffyuwu.
	key = "purr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/feline_purr.ogg'
	species_type_whitelist_typecache = list(/datum/species/human/felinid)

//Shared custody between felinids and lizards
/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/emotes/hiss.ogg'
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)
	species_type_whitelist_typecache = list(/datum/species/lizard, /datum/species/human/felinid)

//Lizard emotes
/datum/emote/living/rpurr
	key = "rpurr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/raptor_purr.ogg'
	species_type_whitelist_typecache = list(/datum/species/lizard)

//Vox emotes
/datum/emote/living/carbon/human/quill
	key = "quill"
	key_third_person = "quills"
	message = "rustles their quills."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	vary = TRUE
	sound = 'sound/emotes/voxrustle.ogg'
	species_type_whitelist_typecache = list(/datum/species/vox)

//Shared custody between skrell and teshari
/datum/emote/living/carbon/human/warble
	key = "warble"
	key_third_person = "warbles!"
	message = "warbles!"
	sound = 'sound/voice/warbles.ogg'
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	species_type_whitelist_typecache = list(/datum/species/skrell, /datum/species/teshari)

/datum/emote/living/carbon/human/warble/get_frequency(mob/living/user) //no regular warbling sound but oh well
	if(isteshari(user))
		return -1
	return 2


/datum/emote/living/carbon/human/trill
	key = "trill"
	key_third_person = "trills"
	message = "trills!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/trills.ogg'
	species_type_whitelist_typecache = list(/datum/species/skrell, /datum/species/teshari)

/datum/emote/living/carbon/human/wurble
	key = "wurble"
	key_third_person = "wurbles"
	message = "wurbles!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/wurble.ogg'
	species_type_whitelist_typecache = list(/datum/species/skrell, /datum/species/teshari)

//Teshari emotes
/datum/emote/living/carbon/human/chirp
	key = "chirp"
	key_third_person = "chirps"
	message = "chirps!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/bird/chirp.ogg'
	species_type_whitelist_typecache = list(/datum/species/teshari)

/datum/emote/living/carbon/human/chirp2
	key = "chirp2"
	key_third_person = "chirps"
	message = "chirps!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/voice/bird/chirp2.ogg'
	species_type_whitelist_typecache = list(/datum/species/teshari)
