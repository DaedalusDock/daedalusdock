#define maxCoinIcon 6
#define CASH_CAP 1

/* exchange rates X * CAP*/
#define CASH_AUR 100 /* 100 caps to 1 AUR */
#define CASH_DEN 4 /* 4 caps to 1 DEN */
#define CASH_NCR 0.4 /* $100 to 40 caps */

/* value of coins to spawn, use as-is for caps */
/* LOW_MIN / AUR = amount in AUR */

// A low value cash spawn is on average worth 25
#define LOW_MIN 8
#define LOW_MAX 50

// A medium value cash spawn is on average worth 60ish
#define MED_MIN 40
#define MED_MAX 80

// Bad Pebbles fix to NCR money fudgery
#define TEMP3_MIN 10
#define TEMP3_MAX 65
#define TEMP_MIN 65
#define TEMP_MAX 120
#define TEMP2_MIN 150
#define TEMP2_MAX 600

// A high value cash spawn is on average worth 280
#define HIGH_MIN 120
#define HIGH_MAX 440

// The Bankers Vault-Stash, done like this make it so it only spawns on his person to stop metarushing. Average 8500.
#define BANKER_MIN 2000
#define BANKER_MAX 15000

/obj/item/stack/f13Cash //DO NOT USE THIS
	name = "bottle cap"
	singular_name = "cap"
	icon = 'modular_fallout/master_files/icons/obj/economy.dmi'
	icon_state = "bottle_cap"
	amount = 1
	max_amount = 15000
	throwforce = 0
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/flavor_desc =	"A standard Nuka-Cola bottle cap featuring 21 crimps and ridges,\
					A common unit of exchange, backed by water in the Hub."
	var/value = CASH_CAP
	var/flippable = TRUE
	var/cooldown = 0
	var/coinflip
	var/list/sideslist = list("heads","tails")
	merge_type = /obj/item/stack/f13Cash

/obj/item/stack/f13Cash/attack_self(mob/user)
	if (flippable)
		if(cooldown < world.time)
			coinflip = pick(sideslist)
			cooldown = world.time + 15
			//flick("coin_[cmineral]_flip", src)
			//icon_state = "coin_[cmineral]_[coinflip]"
			playsound(user.loc, 'sound/items/coinflip.ogg', 50, 1)
			var/oldloc = loc
			sleep(15)
			if(loc == oldloc && user && !user.incapacitated())
				user.visible_message("[user] has flipped [src]. It lands on [coinflip].", \
									"<span class='notice'>You flip [src]. It lands on [coinflip].</span>", \
									"<span class='italics'>You hear the clattering of loose change.</span>")
		return TRUE//did the coin flip? useful for suicide_act

/obj/item/stack/f13Cash/caps
	merge_type = /obj/item/stack/f13Cash/caps

/obj/item/stack/f13Cash/caps/fivezerozero
	amount = 500
	merge_type = /obj/item/stack/f13Cash/caps

/obj/item/stack/f13Cash/caps/threefivezero
	amount = 350
	merge_type = /obj/item/stack/f13Cash/caps

/obj/item/stack/f13Cash/Initialize()
	. = ..()
	update_desc()
	update_icon()

/obj/item/stack/f13Cash/update_desc()
	var/total_worth = get_item_credit_value()
	desc = "It's worth [total_worth] [singular_name][ (latin) ? (( amount > 1 ) ? "i" : "us") : (( amount > 1 ) ? "s each" : "")].\n[flavor_desc]"

/obj/item/stack/f13Cash/get_item_credit_value()
	return (amount*value)

/obj/item/stack/f13Cash/merge(obj/item/stack/S)
	. = ..()
	update_desc()
	update_icon()

/obj/item/stack/f13Cash/use(used, transfer = FALSE)
	. = ..()
	update_desc()
	update_icon()

/obj/item/stack/f13Cash/random
	var/money_type = /obj/item/stack/f13Cash/caps
	var/min_qty = LOW_MIN
	var/max_qty = LOW_MAX

/obj/item/stack/f13Cash/random/Initialize()
	..()
	spawn_money()
	return INITIALIZE_HINT_QDEL

/obj/item/stack/f13Cash/random/proc/spawn_money()
	var/obj/item/stack/f13Cash/stack = new money_type
	stack.loc = loc
	stack.amount = round(rand(min_qty, max_qty))
	stack.update_icon()

/* we have 6 icons, so we will use our own, instead of stack's   */
/obj/item/stack/f13Cash/update_icon()
	switch(amount)
		if(1)
			icon_state = "[initial(icon_state)]"
		if(2 to 5)
			icon_state = "[initial(icon_state)]2"
		if(6 to 50)
			icon_state = "[initial(icon_state)]3"
		if(51 to 100)
			icon_state = "[initial(icon_state)]4"
		if(101 to 500)
			icon_state = "[initial(icon_state)]5"
		if(501 to 15000)
			icon_state = "[initial(icon_state)]6"

/obj/item/stack/f13Cash/random/low
	min_qty = LOW_MIN / CASH_CAP
	max_qty = LOW_MAX / CASH_CAP

/obj/item/stack/f13Cash/random/med
	min_qty = MED_MIN / CASH_CAP
	max_qty = MED_MAX / CASH_CAP

/obj/item/stack/f13Cash/random/high
	min_qty = HIGH_MIN / CASH_CAP
	max_qty = HIGH_MAX / CASH_CAP

/obj/item/stack/f13Cash/random/banker
	min_qty = BANKER_MIN / CASH_CAP
	max_qty = BANKER_MAX / CASH_CAP

/obj/item/stack/f13Cash/denarius
	name = "Denarius"
	latin = 1
	singular_name = "Denari" // -us or -i
	icon = 'modular_fallout/master_files/icons/obj/economy.dmi'
	icon_state = "denarius"
	flavor_desc =	"The inscriptions are in Latin,\n\
		'Caesar Dictator' on the front and\n\
		'Magnum Chasma' on the back."
	value = CASH_DEN * CASH_CAP
	merge_type = /obj/item/stack/f13Cash/denarius

/obj/item/stack/f13Cash/random/denarius
	money_type = /obj/item/stack/f13Cash/denarius

/obj/item/stack/f13Cash/random/denarius/low
	min_qty = LOW_MIN / CASH_DEN
	max_qty = LOW_MAX / CASH_DEN

/obj/item/stack/f13Cash/random/denarius/med
	min_qty = MED_MIN / CASH_DEN
	max_qty = MED_MAX / CASH_DEN

/obj/item/stack/f13Cash/random/denarius/high
	min_qty = HIGH_MIN / CASH_DEN
	max_qty = HIGH_MAX / CASH_DEN

/obj/item/stack/f13Cash/random/denarius/legionpay_basic
	min_qty = LOW_MIN / CASH_DEN
	max_qty = LOW_MAX / CASH_DEN

/obj/item/stack/f13Cash/random/denarius/legionpay_veteran
	min_qty = MED_MIN / CASH_DEN
	max_qty = MED_MAX / CASH_DEN

/obj/item/stack/f13Cash/random/denarius/legionpay_officer
	min_qty = HIGH_MIN / CASH_DEN
	max_qty = HIGH_MAX / CASH_DEN

/obj/item/stack/f13Cash/aureus
	name = "Aureus"
	latin = 1
	singular_name = "Aure"// -us or -i
	icon = 'modular_fallout/master_files/icons/obj/economy.dmi'
	icon_state = "aureus"
	flavor_desc = 	"The inscriptions are in Latin,\n\
					'Aeternit Imperi' on the front and\n\
					'Pax Per Bellum' on the back."
	value = CASH_AUR * CASH_CAP
	merge_type = /obj/item/stack/f13Cash/aureus

/obj/item/stack/f13Cash/random/aureus
	money_type = /obj/item/stack/f13Cash/aureus

/obj/item/stack/f13Cash/random/aureus/low
	min_qty = 1
	max_qty = 1

/obj/item/stack/f13Cash/random/aureus/med
	min_qty = 2
	max_qty = 2

/obj/item/stack/f13Cash/random/aureus/high
	min_qty = 2
	max_qty = 5 //uses flat values because aurei are worth so much

/obj/item/stack/f13Cash/ncr
	name = "NCR Dollar"
	singular_name = "NCR Dollar"  /* same for denarius, we can pretend the legion can't latin properly */
	flavor_desc = "Paper money used by the NCR."
	icon = 'modular_fallout/master_files/icons/obj/economy.dmi'
	icon_state = "ncr" /* 10 points to whoever writes flavour text for each bill */
	value = CASH_NCR * CASH_CAP
	flippable = FALSE
	merge_type = /obj/item/stack/f13Cash/ncr

/obj/item/stack/f13Cash/ncr/update_icon()
	switch(amount)
		if(1  to 9)
			icon_state = "[initial(icon_state)]"
		if(10 to 19)
			icon_state = "[initial(icon_state)]10"
		if(20 to 49)
			icon_state = "[initial(icon_state)]20"
		if(50 to 99)
			icon_state = "[initial(icon_state)]50"
		if(100 to 199)
			icon_state = "[initial(icon_state)]100"
		if(200 to 499)
			icon_state = "[initial(icon_state)]200"
		if(500 to 15000)
			icon_state = "[initial(icon_state)]500"

/obj/item/stack/f13Cash/random/ncr
	money_type = /obj/item/stack/f13Cash/ncr

/obj/item/stack/f13Cash/random/ncr/low
	min_qty = TEMP3_MIN / CASH_NCR
	max_qty = TEMP3_MAX / CASH_NCR

/obj/item/stack/f13Cash/random/ncr/med
	min_qty = TEMP_MIN / CASH_NCR
	max_qty = TEMP_MAX / CASH_NCR

/obj/item/stack/f13Cash/random/ncr/high
	min_qty = TEMP2_MIN / CASH_NCR
	max_qty = TEMP2_MAX / CASH_NCR

/obj/item/stack/f13Cash/random/ncr/ncrpay_basic
	min_qty = LOW_MIN / CASH_NCR
	max_qty = LOW_MAX / CASH_NCR

/obj/item/stack/f13Cash/random/ncr/ncrpay_veteran
	min_qty = MED_MIN / CASH_NCR
	max_qty = MED_MAX / CASH_NCR

/obj/item/stack/f13Cash/random/ncr/ncrpay_officer
	min_qty = HIGH_MIN / CASH_NCR
	max_qty = HIGH_MAX / CASH_NCR

#undef maxCoinIcon
#undef CASH_CAP
#undef CASH_AUR
#undef CASH_DEN
#undef CASH_NCR
#undef LOW_MIN
#undef LOW_MAX
#undef MED_MIN
#undef MED_MAX
#undef HIGH_MIN
#undef HIGH_MAX
#undef BANKER_MIN
#undef BANKER_MAX
#undef TEMP3_MIN
#undef TEMP3_MAX
#undef TEMP_MIN
#undef TEMP_MAX
#undef TEMP2_MIN
#undef TEMP2_MAX
