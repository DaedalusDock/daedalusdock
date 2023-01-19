/obj/item/stack/sticky_tape
	name = "duct tape"
	singular_name = "duct tape"
	desc = "Used for sticking to things for sticking said things to people."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape"
	var/prefix = "sticky"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 5
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	splint_factor = 0.65
	merge_type = /obj/item/stack/sticky_tape
	usesound = 'sound/items/duct_tape_rip.ogg'
	var/list/conferred_embed = EMBED_HARMLESS
	///do_after lengths for handcuff and muzzle attacks
	var/handcuff_delay = 3 SECONDS
	var/muzzle_delay = 2 SECONDS
	///The tape type you get when ripping off a piece of tape.
	var/obj/tape_gag = /obj/item/clothing/mask/muzzle/tape


/obj/item/stack/sticky_tape/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/stack/sticky_tape/examine(mob/user)
	. = ..()
	. += span_notice("<b>Right-click</b> to restrain someone. Target mouth to gag.")

/obj/item/stack/sticky_tape/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
	mob/living/user
)
	switch(user.zone_selected)
		if (BODY_ZONE_PRECISE_MOUTH)
			context[SCREENTIP_CONTEXT_RMB] = "Tape mouth"
		else
			context[SCREENTIP_CONTEXT_RMB] = "Tie hands"

	context[SCREENTIP_CONTEXT_LMB] = "Tape item"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/stack/sticky_tape/attack_secondary(mob/living/carbon/C, mob/living/user)
	if((!istype(C)))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(amount < 5)
		to_chat(user, "<span class='warning'>You don't have enough tape to restrain [C]!</span>")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if((HAS_TRAIT(user, TRAIT_CLUMSY) && prob(25)))
		to_chat(user, "<span class='warning'>Uh... where did the tape edge go?!</span>")
		var/obj/item/restraints/handcuffs/tape/handcuffed = new(user)
		handcuffed.apply_cuffs(user,user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH) //mouth tape
		if(C.is_mouth_covered() || C.is_muzzled())
			to_chat(user, "<span class='warning'>There is something covering [C]s mouth!</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		else
			MuzzleAttack(C, user)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	else if (!C.handcuffed) //tapecuffs
		if(C.canBeHandcuffed())
			CuffAttack(C, user)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/stack/sticky_tape/afterattack(obj/item/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(!istype(target))
		return
	if(target.embedding && target.embedding == conferred_embed)
		to_chat(user, span_warning("[target] is already coated in [src]!"))
		return
	user.visible_message(span_notice("[user] begins wrapping [target] with [src]."), span_notice("You begin wrapping [target] with [src]."))
	playsound(user, usesound, 50, TRUE)
	if(do_after(user, 3 SECONDS, target=target))
		playsound(user, 'sound/items/duct_tape_snap.ogg', 50, TRUE)
		use(1)
		if(istype(target, /obj/item/clothing/gloves/fingerless))
			var/obj/item/clothing/gloves/tackler/offbrand/O = new /obj/item/clothing/gloves/tackler/offbrand
			to_chat(user, span_notice("You turn [target] into [O] with [src]."))
			QDEL_NULL(target)
			user.put_in_hands(O)
			return

		if(target.embedding && target.embedding == conferred_embed)
			to_chat(user, span_warning("[target] is already coated in [src]!"))
			return

		target.embedding = conferred_embed
		target.updateEmbedding()
		to_chat(user, span_notice("You finish wrapping [target] with [src]."))
		target.name = "[prefix] [target.name]"

		if(istype(target, /obj/item/grenade))
			var/obj/item/grenade/sticky_bomb = target
			sticky_bomb.sticky = TRUE

/obj/item/restraints/handcuffs/tape
	name = "length of tape"
	desc = "Seems you are in a sticky situation."
	breakouttime = 15 SECONDS
	item_flags = DROPDEL

/obj/item/stack/sticky_tape/proc/MuzzleAttack(mob/living/carbon/C, mob/living/user)
	if(C.is_mouth_covered() || C.is_muzzled())
		to_chat(user, "<span class='warning'>There is something covering [C]s mouth!</span>")
		return
	else
		playsound(loc, usesound, 30, TRUE, -2)
		C.visible_message(span_danger("[user] tries to cover [C]s mouth with [src]!"), \
						span_userdanger("[user] is trying to cover your mouth with [src]!"))
		if(do_mob(user, C, muzzle_delay))
			if(!C.is_mouth_covered() || !C.is_muzzled())
				use(5)
				C.equip_to_slot_or_del(new tape_gag(C), ITEM_SLOT_MASK)
				C.visible_message("<span class='notice'>[user] tapes [C]s mouth shut.</span>", \
								"<span class='userdanger'>[user] taped your mouth shut!</span>")
				log_combat(user, C, "gags")
				return TRUE
			else
				to_chat(user, "<span class='warning'>There is something covering [C]s mouth!</span>")
		else
			to_chat(user, span_warning("You fail to tape over [C]s mouth."))
			return

/obj/item/stack/sticky_tape/proc/CuffAttack(mob/living/carbon/C, mob/living/user)
	if(!C.handcuffed)
		playsound(loc, usesound, 30, TRUE, -2)
		C.visible_message(span_danger("[user] begins restraining [C] with [src]!"), \
								span_userdanger("[user] begins wrapping [src] around your wrists!"))
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				use(5)
				C.set_handcuffed(new /obj/item/restraints/handcuffs/tape(C))
				C.update_handcuffed()
				to_chat(user, span_notice("You restrain [C]."))
				log_combat(user, C, "tapecuffed")
			else
				to_chat(user, span_warning("[C] is already bound."))
		else
			to_chat(user, span_warning("You fail to restrain [C]."))
	else
		to_chat(user, span_warning("[C] is already bound."))


/obj/item/stack/sticky_tape/super
	name = "super sticky tape"
	singular_name = "super sticky tape"
	desc = "Quite possibly the most mischevious substance in the galaxy. Use with extreme lack of caution."
	icon_state = "tape_y"
	prefix = "super sticky"
	conferred_embed = EMBED_HARMLESS_SUPERIOR
	splint_factor = 0.4
	merge_type = /obj/item/stack/sticky_tape/super
	tape_gag = /obj/item/clothing/mask/muzzle/tape/super

/obj/item/stack/sticky_tape/pointy
	name = "pointy tape"
	singular_name = "pointy tape"
	desc = "Used for sticking to things for sticking said things inside people."
	icon_state = "tape_evil"
	prefix = "pointy"
	conferred_embed = EMBED_POINTY
	merge_type = /obj/item/stack/sticky_tape/pointy
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy

/obj/item/stack/sticky_tape/pointy/super
	name = "super pointy tape"
	singular_name = "super pointy tape"
	desc = "You didn't know tape could look so sinister. Welcome to Space Station 13."
	icon_state = "tape_spikes"
	prefix = "super pointy"
	conferred_embed = EMBED_POINTY_SUPERIOR
	merge_type = /obj/item/stack/sticky_tape/pointy/super
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy/super

/obj/item/stack/sticky_tape/surgical
	name = "surgical tape"
	singular_name = "surgical tape"
	desc = "Made for patching broken bones back together alongside bone gel, not for playing pranks."
	//icon_state = "tape_spikes"
	prefix = "surgical"
	conferred_embed = list("embed_chance" = 30, "pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
	splint_factor = 0.5
	custom_price = PAYCHECK_MEDIUM
	merge_type = /obj/item/stack/sticky_tape/surgical
	tape_gag = /obj/item/clothing/mask/muzzle/tape/surgical
