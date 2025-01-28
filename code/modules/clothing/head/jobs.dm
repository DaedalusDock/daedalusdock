//defines the drill hat's yelling setting
#define DRILL_DEFAULT "default"
#define DRILL_SHOUTING "shouting"
#define DRILL_YELLING "yelling"
#define DRILL_CANADIAN "canadian"

//Chef
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	inhand_icon_state = "chef"
	icon_state = "chef"
	desc = "The commander in chef's head wear."
	strip_delay = 10
	equip_delay_other = 10

	dog_fashion = /datum/dog_fashion/head/chef
	///the chance that the movements of a mouse inside of this hat get relayed to the human wearing the hat
	var/mouse_control_probability = 20

/obj/item/clothing/head/chefhat/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/chefhat)

/obj/item/clothing/head/chefhat/i_am_assuming_direct_control
	desc = "The commander in chef's head wear. Upon closer inspection, there seem to be dozens of tiny levers, buttons, dials, and screens inside of this hat. What the hell...?"
	mouse_control_probability = 100

/obj/item/clothing/head/chefhat/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is donning [src]! It looks like [user.p_theyre()] trying to become a chef."))
	user.say("Bork Bork Bork!", forced = "chef hat suicide")
	sleep(20)
	user.visible_message(span_suicide("[user] climbs into an imaginary oven!"))
	user.say("BOOORK!", forced = "chef hat suicide")
	playsound(user, 'sound/machines/ding.ogg', 50, TRUE)
	return(FIRELOSS)

/obj/item/clothing/head/chefhat/relaymove(mob/living/user, direction)
	if(!istype(user, /mob/living/simple_animal/mouse) || !isliving(loc) || !prob(mouse_control_probability))
		return
	var/mob/living/L = loc
	if(L.incapacitated(IGNORE_RESTRAINTS)) //just in case
		return
	step_towards(L, get_step(L, direction))

//Captain
/obj/item/clothing/head/caphat
	name = "captain's hat"
	desc = "It's good being the king."
	icon_state = "captain"
	inhand_icon_state = "that"
	flags_inv = 0
	armor = list(BLUNT = 25, PUNCTURE = 15, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/captain
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

//Captain: This is no longer space-worthy
/obj/item/clothing/head/caphat/parade
	name = "captain's parade cap"
	desc = "Worn only by Captains with an abundance of class."
	icon_state = "capcap"

	dog_fashion = null

/obj/item/clothing/head/caphat/beret
	name = "captain's beret"
	desc = "For the Captains known for their sense of fashion."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#0070B7#FFCE5B"

//Head of Personnel
/obj/item/clothing/head/hopcap
	name = "head of personnel's cap"
	icon_state = "hopcap"
	desc = "The symbol of true bureaucratic micromanagement."
	armor = list(BLUNT = 25, PUNCTURE = 15, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50)
	dog_fashion = /datum/dog_fashion/head/hop

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/bishopmitre
	name = "bishop mitre"
	desc = "An opulent hat that functions as a radio to God. Or as a lightning rod, depending on who you ask."
	icon_state = "bishopmitre"

//Detective
/obj/item/clothing/head/fedora/det_hat
	name = "private investigator's fedora"
	desc = "There's only one man who can sniff out the dirty stench of crime, and he's likely wearing this hat."
	armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 0, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, FIRE = 30, ACID = 50)
	icon_state = "detective"
	var/candy_cooldown = 0
	dog_fashion = /datum/dog_fashion/head/detective

/obj/item/clothing/head/fedora/det_hat/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/small/fedora/detective)

	new /obj/item/reagent_containers/food/drinks/flask/det(src)

/obj/item/clothing/head/fedora/det_hat/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to take a candy corn.")

/obj/item/clothing/head/fedora/det_hat/AltClick(mob/user)
	. = ..()
	if(loc != user || !user.canUseTopic(src, USE_CLOSE|USE_DEXTERITY|USE_IGNORE_TK))
		return
	if(candy_cooldown < world.time)
		var/obj/item/food/candy_corn/CC = new /obj/item/food/candy_corn(src)
		user.put_in_hands(CC)
		to_chat(user, span_notice("You slip a candy corn from your hat."))
		candy_cooldown = world.time+1200
	else
		to_chat(user, span_warning("You just took a candy corn! You should wait a couple minutes, lest you burn through your stash."))


//Mime

/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, a mime's favorite headwear."
	icon_state = "beret"
	dog_fashion = /datum/dog_fashion/head/beret

	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	flags_1 = IS_PLAYER_COLORABLE_1


//Security

//Mars-Exec hats
/obj/item/clothing/head/garrison_cap
	name = "mars garrison cap"
	desc = "A folded garrison cap for Mars-Exec officers. Fancy, but it won't do much to protect your noggin."
	icon_state = "garrison_sec"
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION //need to do these

/obj/item/clothing/head/marshal_hat
	name = "marshal's hat"
	desc = "A wide-brimmed campaign hat with a thin kevlar lining. Don't be a fool, marshal."
	//Only protects from ballistics, and still worse then a helmet.
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 20, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	icon_state = "marshalhat"
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION //need to do these

//old sec hats
/obj/item/clothing/head/hos
	name = "security marshal cap"
	desc = "The robust standard-issue cap of the Security Marshal. For showing the officers who's in charge."
	icon_state = "hoscap"
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION


/obj/item/clothing/head/hos/syndicate
	name = "syndicate cap"
	desc = "A black cap fit for a high ranking syndicate officer."

/obj/item/clothing/head/hos/beret
	name = "security marshal's beret"
	desc = "A robust beret for the Security Marshal, for looking stylish while not sacrificing protection."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3F3C40#FFCE5B"

/obj/item/clothing/head/hos/beret/navyhos
	name = "security marshal's formal beret"
	desc = "A special beret with the Security Marshal's insignia emblazoned on it. A symbol of excellence, a badge of courage, a mark of distinction."
	greyscale_colors = "#3C485A#FFCE5B"

/obj/item/clothing/head/hos/beret/syndicate
	name = "syndicate beret"
	desc = "A black beret with thick armor padding inside. Stylish and robust."

/obj/item/clothing/head/warden
	name = "warden's police hat"
	desc = "It's a special armored hat issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "policehelm"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 30, ACID = 60)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/head/warden/red
	name = "warden's hat"
	desc = "A warden's red hat. Looking at it gives you the feeling of wanting to keep people in cells for as long as possible."
	icon_state = "wardenhat"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 30, ACID = 60)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden_red
	supports_variations_flags = NONE

/obj/item/clothing/head/warden/drill
	name = "warden's campaign hat"
	desc = "A special armored campaign hat with the security insignia emblazoned on it. Uses reinforced fabric to offer sufficient protection."
	icon_state = "wardendrill"
	inhand_icon_state = "wardendrill"
	dog_fashion = null
	supports_variations_flags = NONE
	var/mode = DRILL_DEFAULT

/obj/item/clothing/head/warden/drill/screwdriver_act(mob/living/carbon/human/user, obj/item/I)
	if(..())
		return TRUE
	switch(mode)
		if(DRILL_DEFAULT)
			to_chat(user, span_notice("You set the voice circuit to the middle position."))
			mode = DRILL_SHOUTING
		if(DRILL_SHOUTING)
			to_chat(user, span_notice("You set the voice circuit to the last position."))
			mode = DRILL_YELLING
		if(DRILL_YELLING)
			to_chat(user, span_notice("You set the voice circuit to the first position."))
			mode = DRILL_DEFAULT
		if(DRILL_CANADIAN)
			to_chat(user, span_danger("You adjust voice circuit but nothing happens, probably because it's broken."))
	return TRUE

/obj/item/clothing/head/warden/drill/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(mode != DRILL_CANADIAN)
		to_chat(user, span_danger("You broke the voice circuit!"))
		mode = DRILL_CANADIAN
	return TRUE

/obj/item/clothing/head/warden/drill/equipped(mob/M, slot)
	. = ..()
	if (slot == ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/warden/drill/unequipped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/warden/drill/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		switch (mode)
			if(DRILL_SHOUTING)
				message += "!"
			if(DRILL_YELLING)
				message += "!!"
			if(DRILL_CANADIAN)
				message = "[message]"
				var/list/canadian_words = strings("canadian_replacement.json", "canadian")

				for(var/key in canadian_words)
					var/value = canadian_words[key]
					if(islist(value))
						value = pick(value)

					message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
					message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
					message = replacetextEx(message, " [key]", " [value]")

				if(prob(30))
					message += pick(", eh?", ", EH?")
		speech_args[SPEECH_MESSAGE] = message

/obj/item/clothing/head/beret/sec
	name = "security beret"
	desc = "A robust beret with the security insignia emblazoned on it. Uses reinforced fabric to offer sufficient protection."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#972A2A#F2F2F2"
	dog_fashion = null
	flags_1 = NONE


/obj/item/clothing/head/beret/sec/navywarden
	name = "warden's beret"
	desc = "A special beret with the Warden's insignia emblazoned on it. For wardens with class."
	greyscale_colors = "#3C485A#00AEEF"

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "A special beret with the security insignia emblazoned on it. For officers with class."
	greyscale_colors = "#3C485A#FF0000"


//Science

/obj/item/clothing/head/beret/science
	name = "science beret"
	desc = "A science-themed beret for our hardworking scientists."
	greyscale_colors = "#8D008F"
	flags_1 = NONE

/obj/item/clothing/head/beret/science/fancy
	desc = "A science-themed beret for our hardworking scientists. This one comes with a fancy badge!"
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#8D008F#FFFFFF"


//Medical

/obj/item/clothing/head/beret/medical
	name = "medical beret"
	desc = "A medical-flavored beret for the doctor in you!"
	greyscale_colors = "#FFFFFF"
	flags_1 = NONE

/obj/item/clothing/head/beret/medical/paramedic
	name = "paramedic beret"
	desc = "For finding corpses in style!"
	greyscale_colors = "#16313D"

/obj/item/clothing/head/beret/medical/cmo
	name = "medical director beret"
	desc = "A beret in a distinct surgical turquoise!"
	greyscale_colors = "#5EB8B8"


//Engineering

/obj/item/clothing/head/beret/engi
	name = "engineering beret"
	desc = "Might not protect you from radiation, but definitely will protect you from looking unfashionable!"
	greyscale_colors = "#FFBC30"
	flags_1 = NONE

/obj/item/clothing/head/beret/atmos
	name = "atmospheric beret"
	desc = "While \"pipes\" and \"style\" might not rhyme, this beret sure makes you feel like they should!"
	greyscale_colors = "#FFDE15"
	flags_1 = NONE


//Cargo

/obj/item/clothing/head/beret/cargo
	name = "cargo beret"
	desc = "No need to compensate when you can wear this beret!"
	greyscale_colors = "#ECCA30"
	flags_1 = NONE


//Curator

/obj/item/clothing/head/fedora/curator
	name = "treasure hunter's fedora"
	desc = "You got red text today kid, but it doesn't mean you have to like it."
	icon_state = "curator"


//Miscellaneous

/obj/item/clothing/head/beret/black
	name = "black beret"
	desc = "A black beret, perfect for war veterans and dark, brooding, anti-hero mimes."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#3f3c40"

/obj/item/clothing/head/beret/durathread
	name = "durathread beret"
	desc = "A beret made from durathread, its resilient fibers provide some protection to the wearer."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#C5D4F3#ECF1F8"
	armor = list(BLUNT = 15, PUNCTURE = 5, SLASH = 0, LASER = 15, ENERGY = 25, BOMB = 10, BIO = 0, FIRE = 30, ACID = 5)

/obj/item/clothing/head/beret/highlander
	desc = "That was white fabric. <i>Was.</i>"
	dog_fashion = null //THIS IS FOR SLAUGHTER, NOT PUPPIES

/obj/item/clothing/head/beret/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)


//CentCom

/obj/item/clothing/head/beret/centcom_formal
	name = "\improper CentCom Formal Beret"
	desc = "Sometimes, a compromise between fashion and defense needs to be made. Thanks to Nanotrasen's most recent nano-fabric durability enhancements, this time, it's not the case."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#397F3F#FFCE5B"
	armor = list(BLUNT = 80, PUNCTURE = 80, SLASH = 0, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, FIRE = 100, ACID = 90)
	strip_delay = 10 SECONDS


#undef DRILL_DEFAULT
#undef DRILL_SHOUTING
#undef DRILL_YELLING
#undef DRILL_CANADIAN
