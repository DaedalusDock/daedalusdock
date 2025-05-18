/obj/item/stack/sticky_tape
	name = "roll of duct tape"
	singular_name = "piece"
	stack_name = "roll"
	multiple_gender = NEUTER

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
	splint_slowdown = 4
	merge_type = /obj/item/stack/sticky_tape
	usesound = 'sound/items/duct_tape_rip.ogg'
	var/list/conferred_embed = EMBED_HARMLESS
	///do_after lengths for handcuff and muzzle attacks
	var/handcuff_delay = 4 SECONDS
	var/muzzle_delay = 2 SECONDS
	///The tape type you get when ripping off a piece of tape.
	var/obj/tape_gag = /obj/item/clothing/mask/muzzle/tape


/obj/item/stack/sticky_tape/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/stack/sticky_tape/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
	mob/living/user
)
	if(isitem(target))
		context[SCREENTIP_CONTEXT_LMB] = "Tape item"
	else if(iscarbon(target))
		switch(user.zone_selected)
			if (BODY_ZONE_PRECISE_MOUTH)
				context[SCREENTIP_CONTEXT_LMB] = "Tape mouth"
			else
				context[SCREENTIP_CONTEXT_LMB] = "Tie hands"
	else
		return NONE
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/stack/sticky_tape/attack(mob/living/carbon/victim, mob/living/user)
	if((!istype(victim)))
		return
	if(is_zero_amount(delete_if_zero = TRUE))
		return
	if((HAS_TRAIT(user, TRAIT_CLUMSY) && prob(25)))
		to_chat(user, "<span class='warning'>Uh... where did the tape edge go?!</span>")
		var/obj/item/restraints/handcuffs/tape/handcuffed = new(user)
		handcuffed.apply_cuffs(user,user)
		return
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(victim.wear_mask)
			to_chat(user, span_notice("[victim] is already wearing somthing on their face."))
			return
		MuzzleAttack(victim, user)
	else if (!victim.handcuffed)
		if(victim.canBeHandcuffed())
			CuffAttack(victim, user)
			return

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
	if(do_after(user, target, 3 SECONDS, DO_PUBLIC, display = src))
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

/obj/item/stack/sticky_tape/proc/MuzzleAttack(mob/living/carbon/victim, mob/living/user)
	playsound(loc, usesound, 30, TRUE, -2)
	victim.visible_message(span_danger("[user] is trying to cover [victim]s mouth with [src]!"), \
						span_userdanger("[user] is trying to cover your mouth with [src]!"))
	if(do_after(user, victim, muzzle_delay, DO_PUBLIC, display = src))
		if(!victim.wear_mask)
			use(1)
			victim.equip_to_slot_or_del(new tape_gag(victim), ITEM_SLOT_MASK)
			victim.visible_message("<span class='notice'>[user] tapes [victim]'s mouth shut.</span>", \
								"<span class='userdanger'>[user] taped your mouth shut!</span>")
			log_combat(user, victim, "gags")
			return TRUE
	else
		to_chat(user, span_warning("You fail to tape over [victim]'s mouth."))
		return

/obj/item/stack/sticky_tape/proc/CuffAttack(mob/living/carbon/victim, mob/living/user)
	playsound(loc, usesound, 30, TRUE, -2)
	victim.visible_message(span_danger("[user] is trying to restrain [victim] with [src]!"), \
							span_userdanger("[user] begins wrapping [src] around your wrists!"))
	if(do_after(user, victim, handcuff_delay, DO_PUBLIC, display = src))
		if(victim.equip_to_slot_if_possible(new /obj/item/restraints/handcuffs/tape(victim), ITEM_SLOT_HANDCUFFED, TRUE, TRUE, null, TRUE))
			use(1)
			victim.visible_message("<span class='notice'>[user] binds [victim]'s hands.</span>", \
								"<span class='userdanger'>[user] handcuffs you.</span>")
			log_combat(user, victim, "tapecuffed")
		else
			to_chat(user, span_warning("[victim] is already bound."))
	else
		to_chat(user, span_warning("You fail to restrain [victim]."))

/obj/item/stack/sticky_tape/super
	name = "super sticky tape"
	singular_name = "super sticky tape"
	desc = "Quite possibly the most mischevious substance in the galaxy. Use with extreme lack of caution."
	icon_state = "tape_y"
	prefix = "super sticky"
	conferred_embed = EMBED_HARMLESS_SUPERIOR
	splint_slowdown = 6
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
	icon_state = "tape_w"
	prefix = "surgical"
	conferred_embed = list("embed_chance" = 30, "pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
	splint_slowdown = 3
	custom_price = PAYCHECK_ASSISTANT * 0.4
	merge_type = /obj/item/stack/sticky_tape/surgical
	tape_gag = /obj/item/clothing/mask/muzzle/tape/surgical
