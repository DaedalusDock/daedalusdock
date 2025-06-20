/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck.dmi'
	fallback_colors = list(list(15, 19))
	fallback_icon_state = "scarf"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40

/obj/item/clothing/neck/worn_overlays(mob/living/carbon/human/wearer, mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(body_parts_covered & HEAD)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
		var/list/dna = return_blood_DNA()
		if(length(dna))
			if(istype(wearer))
				var/obj/item/bodypart/head = wearer.get_bodypart(BODY_ZONE_HEAD)
				if(!head?.icon_bloodycover)
					return
				var/image/bloody_overlay = image(head.icon_bloodycover, "maskblood")
				bloody_overlay.color = get_blood_dna_color(dna)
				. += bloody_overlay
			else
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	inhand_icon_state = "" //no inhands
	fallback_colors = list(list(16, 20))
	fallback_icon_state = "tie"
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_ASSISTANT * 1.4

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "loose tie"
	desc = "A loosely tied necktie, a perfect accessory for the over-worked detective."
	icon_state = "detective"

/obj/item/clothing/neck/maid
	name = "maid neck cover"
	desc = "A neckpiece for a maid costume, it smells faintly of disappointment."
	icon_state = "maid_neck"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "A tool for auscultation of the body."
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] puts \the [src] to [user.p_their()] chest! It looks like [user.p_they()] won't hear much!"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || !isliving(user))
		return ..()
	if(user.combat_mode)
		return ..()

	var/mob/living/carbon/human/patient = M
	var/obj/item/bodypart/listening_to = M.get_bodypart(user.zone_selected)

	if(!do_after(user, M, 5 SECONDS, DO_RESTRICT_USER_DIR_CHANGE|DO_PUBLIC, display = src))
		return

	user.visible_message(
		span_subtle("[user] places [src] against [patient]'s [listening_to.plaintext_zone]."),
	)

	if(user.can_hear())
		var/list/heard = listening_to.stethoscope_listen()
		to_chat(user, span_hear("You hear [english_list(heard)]."))

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "white scarf"
	icon_state = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	w_class = WEIGHT_CLASS_TINY
	dog_fashion = /datum/dog_fashion/head
	custom_price = PAYCHECK_ASSISTANT * 1.6

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "pink scarf"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "striped red scarf"
	icon_state = "stripedredscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	supports_variations_flags = CLOTHING_TESHARI_VARIATION

/obj/item/clothing/neck/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = "It's for pets."
	icon_state = "petcollar"
	fallback_colors = list(list(16, 21), list(16, 19))
	fallback_icon_state = "collar" //Blame (or thank) Kapu
	var/tagname = null

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = sanitize_name(tgui_input_text(user, "Would you like to change the name on the tag?", "Pet Naming", "Spot", MAX_NAME_LEN))
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = "Damn, it feels good to be a gangster."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/necklace/dope/merchant
	desc = "Don't ask how it works, the proof is in the holochips!"
	/// scales the amount received in case an admin wants to emulate taxes/fees.
	var/profit_scaling = 1
	/// toggles between sell (TRUE) and get price post-fees (FALSE)
	var/selling = FALSE

/obj/item/clothing/neck/necklace/dope/merchant/attack_self(mob/user)
	. = ..()
	selling = !selling
	to_chat(user, span_notice("[src] has been set to [selling ? "'Sell'" : "'Get Price'"] mode."))

/obj/item/clothing/neck/necklace/dope/merchant/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(ATOM_HAS_FIRST_CLASS_INTERACTION(interacting_with))
		return NONE

	var/atom/I = interacting_with // Yes i am supremely lazy

	var/datum/export_report/ex = export_item_and_contents(I, delete_unsold = selling, dry_run = !selling)
	var/price = 0
	for(var/x in ex.total_amount)
		price += ex.total_value[x]

	if(price)
		var/true_price = round(price*profit_scaling)
		to_chat(user, span_notice("[selling ? "Sold" : "Getting the price of"] [I], value: <b>[true_price]</b> marks[I.contents.len ? " (exportable contents included)" : ""].[profit_scaling < 1 && selling ? "<b>[round(price-true_price)]</b> credit\s taken as processing fee\s." : ""]"))
		if(selling)
			SSeconomy.spawn_ones_for_amount(true_price, get_turf(user))
	else
		to_chat(user, span_warning("There is no export value for [I] or any items within it."))

	return ITEM_INTERACT_SUCCESS

TYPEINFO_DEF(/obj/item/clothing/neck/beads)
	default_materials = list(/datum/material/plastic = 500)

/obj/item/clothing/neck/beads
	name = "plastic bead necklace"
	desc = "A cheap, plastic bead necklace. Show team spirit! Collect them! Throw them away! The possibilites are endless!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/beads/Initialize(mapload)
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")

/obj/item/clothing/neck/tie/disco
	name = "horrific necktie"
	icon_state = "eldritch_tie"
	desc = "The necktie is adorned with a garish pattern. It's disturbingly vivid. Somehow you feel as if it would be wrong to ever take it off. It's your friend now. You will betray it if you change it for some boring scarf."
