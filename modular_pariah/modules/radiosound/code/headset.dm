/obj/item/radio/headset
	var/radiosound = 'modular_pariah/modules/radiosound/sound/radio/common.ogg'

/obj/item/radio/headset/syndicate //disguised to look like a normal headset for stealth ops
	radiosound = 'modular_pariah/modules/radiosound/sound/radio/syndie.ogg'

/obj/item/radio/headset/headset_sec
	radiosound = 'modular_pariah/modules/radiosound/sound/radio/security.ogg'

/obj/item/radio/headset/talk_into(mob/living/M, message, channel, list/spans, datum/language/language, list/message_mods)
	if(isnull(language))
		language = M?.get_selected_language()

	if(istype(language, /datum/language/visual))
		return

	if(radiosound && listening)
		playsound(M, radiosound, rand(20, 30))
	. = ..()
