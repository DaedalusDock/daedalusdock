/obj/item/valentine
	name = "valentine"
	desc = "A Valentine's card! Wonder what it says..."
	icon = 'icons/obj/toy.dmi'
	icon_state = "sc_Ace of Hearts_syndicate" // shut up
	var/message = "A generic message of love or whatever."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/valentine/Initialize(mapload)
	message = pick(GLOB.flirts)
	return ..()
#warn note - this is just for old times sake. maybe fix/remove it later.
/*
/obj/item/valentine/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/toy/crayon))
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>You scribble illegibly on [src]!</span>")
			return
		var/recipient = stripped_input(user, "Who is receiving this valentine?", "To:", null , 20)
		var/sender = stripped_input(user, "Who is sending this valentine?", "From:", null , 20)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(recipient && sender)
			name = "valentine - To: [recipient] From: [sender]"

/obj/item/valentine/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if( !(ishuman(user) || isobserver(user) || hasSiliconAccessInArea(user)) )
			user << browse("<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[name]</TITLE></HEAD><BODY>[stars(message)]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
		else
			user << browse("<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[name]</TITLE></HEAD><BODY>[message]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
	else
		. += "<span class='notice'>It is too far away.</span>"

/obj/item/valentine/attack_self(mob/user)
	user.examinate(src)

/obj/item/reagent_containers/food/snacks/candyheart
	name = "candy heart"
	icon = 'icons/obj/holiday_misc.dmi'
	icon_state = "candyheart"
	desc = "A heart-shaped candy that reads: "
	list_reagents = list(/datum/reagent/consumable/sugar = 2)
	junkiness = 5

/obj/item/reagent_containers/food/snacks/candyheart/New()
	..()
	desc = pick("A heart-shaped candy that reads: HONK ME",
				"A heart-shaped candy that reads: ERP",
				"A heart-shaped candy that reads: LEWD",
				"A heart-shaped candy that reads: LUSTY",
				"A heart-shaped candy that reads: SPESS LOVE",
				"A heart-shaped candy that reads: AYY LMAO",
				"A heart-shaped candy that reads: TABLE ME",
				"A heart-shaped candy that reads: HAND CUFFS",
				"A heart-shaped candy that reads: SHAFT MINER",
				"A heart-shaped candy that reads: BANGING DONK",
				"A heart-shaped candy that reads: Y-YOU T-TOO",
				"A heart-shaped candy that reads: GOT WOOD",
				"A heart-shaped candy that reads: TFW NO GF",
				"A heart-shaped candy that reads: WAG MY TAIL",
				"A heart-shaped candy that reads: VALIDTINES",
				"A heart-shaped candy that reads: FACEHUGGER",
				"A heart-shaped candy that reads: BOX OF HUGS",
				"A heart-shaped candy that reads: REEBE MINE",
				"A heart-shaped candy that reads: PET ME",
				"A heart-shaped candy that reads: TO THE DORMS",
				"A heart-shaped candy that reads: DIS MEMBER")
	icon_state = pick("candyheart", "candyheart2", "candyheart3", "candyheart4")

*/