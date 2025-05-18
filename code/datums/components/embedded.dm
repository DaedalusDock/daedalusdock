/*
	This component is responsible for handling individual instances of embedded objects. The embeddable element is what allows an item to be embeddable and stores its embedding stats,
	and when it impacts and meets the requirements to stick into something, it instantiates an embedded component. Once the item falls out, the component is destroyed, while the
	element survives to embed another day.

		- Carbon embedding has all the classical embedding behavior, and tracks more events and signals. The main behaviors and hooks to look for are:
			-- Every process tick, there is a chance to randomly proc pain, controlled by pain_chance. There may also be a chance for the object to fall out randomly, per fall_chance
			-- Every time the mob moves, there is a chance to proc jostling pain, controlled by jostle_chance (and only 50% as likely if the mob is walking or crawling)
			-- Various signals hooking into carbon topic() and the embed removal surgery in order to handle removals.


	In addition, there are 2 cases of embedding: embedding, and sticking

		- Embedding involves harmful and dangerous embeds, whether they cause brute damage, stamina damage, or a mix. This is the default behavior for embeddings, for when something is "pointy"

		- Sticking occurs when an item should not cause any harm while embedding (imagine throwing a sticky ball of tape at someone, rather than a shuriken). An item is considered "sticky"
			when it has 0 for both pain multiplier and jostle pain multiplier. It's a bit arbitrary, but fairly straightforward.

		Stickables differ from embeds in the following ways:
			-- Text descriptors use phrasing like "X is stuck to Y" rather than "X is embedded in Y"
			-- There is no slicing sound on impact
			-- All damage checks and bloodloss are skipped

*/

/datum/component/embedded
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mob/living/carbon/human/limb_owner

	var/obj/item/weapon

	// all of this stuff is explained in _DEFINES/combat.dm
	var/embed_chance // not like we really need it once we're already stuck in but hey
	var/fall_chance
	var/pain_chance
	var/pain_mult
	var/impact_pain_mult
	var/remove_pain_mult
	var/rip_time
	var/ignore_throwspeed_threshold
	var/jostle_chance
	var/jostle_pain_mult
	var/pain_stam_pct

	///if both our pain multiplier and jostle pain multiplier are 0, we're harmless and can omit most of the damage related stuff
	var/harmful

/datum/component/embedded/Initialize(obj/item/I,
			datum/thrownthing/throwingdatum,
			obj/item/bodypart/part,
			embed_chance = EMBED_CHANCE,
			fall_chance = EMBEDDED_ITEM_FALLOUT,
			pain_chance = EMBEDDED_PAIN_CHANCE,
			pain_mult = EMBEDDED_PAIN_MULTIPLIER,
			remove_pain_mult = EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER,
			impact_pain_mult = EMBEDDED_IMPACT_PAIN_MULTIPLIER,
			rip_time = EMBEDDED_UNSAFE_REMOVAL_TIME,
			ignore_throwspeed_threshold = FALSE,
			jostle_chance = EMBEDDED_JOSTLE_CHANCE,
			jostle_pain_mult = EMBEDDED_JOSTLE_PAIN_MULTIPLIER,
			pain_stam_pct = EMBEDDED_PAIN_STAM_PCT)

	if(!istype(parent, /obj/item/bodypart) || !isitem(I))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/bodypart/limb = parent
	if(limb.owner)
		register_to_mob(limb.owner)

	src.embed_chance = embed_chance
	src.fall_chance = fall_chance
	src.pain_chance = pain_chance
	src.pain_mult = pain_mult
	src.remove_pain_mult = remove_pain_mult
	src.rip_time = rip_time
	src.impact_pain_mult = impact_pain_mult
	src.ignore_throwspeed_threshold = ignore_throwspeed_threshold
	src.jostle_chance = jostle_chance
	src.jostle_pain_mult = jostle_pain_mult
	src.pain_stam_pct = pain_stam_pct
	src.weapon = I

	if(!weapon.isEmbedHarmless())
		harmful = TRUE

	var/datum/wound/W

	if(harmful)
		var/damage = weapon.throwforce
		playsound(parent,'sound/weapons/bladeslice.ogg', 40)
		damage += weapon.w_class * impact_pain_mult
		var/post_armor_damage = damage
		if(limb_owner)
			var/armor = limb_owner.run_armor_check(limb.body_zone, PUNCTURE, "Your armor has protected your [limb.plaintext_zone].", "Your armor has softened a hit to your [limb.plaintext_zone].",I.armor_penetration, weak_against_armor = I.weak_against_armor)
			post_armor_damage = damage * ((100-armor)/100)

		if(post_armor_damage <= 0)
			return COMPONENT_INCOMPATIBLE

		if(limb_owner)
			weapon.add_mob_blood(limb_owner)//it embedded itself in you, of course it's bloody!
			limb_owner.stamina.adjust(-(pain_stam_pct * damage))

		W = limb.create_wound(WOUND_PIERCE, damage)
		LAZYADD(W.embedded_objects, weapon)

	weapon.embedded(parent, part)

	START_PROCESSING(SSembeds, src)

	limb_owner?.visible_message(
		span_danger("[weapon] [harmful ? "embeds" : "sticks"] itself [harmful ? "in" : "to"] [limb_owner]'s [limb.plaintext_zone]!"),
	)

	limb._embed_object(weapon) // on the inside... on the inside...
	weapon.forceMove(limb)

	if(W)
		W.RegisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), TYPE_PROC_REF(/datum/wound, item_gone))
	RegisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(weaponDeleted))

/datum/component/embedded/Destroy()
	if(limb_owner)
		unregister_from_mob(limb_owner)

	weapon = null
	return ..()

/datum/component/embedded/proc/register_to_mob(mob/living/carbon/human/H)
	limb_owner = H
	H.throw_alert(ALERT_EMBEDDED_OBJECT, /atom/movable/screen/alert/embeddedobject)
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(jostleCheck))
	RegisterSignal(H, COMSIG_CARBON_EMBED_REMOVAL, PROC_REF(safeRemove))
	RegisterSignal(H, COMSIG_LIVING_HEALTHSCAN, PROC_REF(on_healthscan))

/datum/component/embedded/proc/unregister_from_mob(mob/living/carbon/human/H)
	if(!H.has_embedded_objects())
		H.clear_alert(ALERT_EMBEDDED_OBJECT)
	UnregisterSignal(H, list(COMSIG_MOVABLE_MOVED, COMSIG_CARBON_EMBED_REMOVAL))
	limb_owner = null

/datum/component/embedded/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIMB_REMOVE, PROC_REF(limb_removed))
	RegisterSignal(parent, COMSIG_LIMB_ATTACH, PROC_REF(limb_attached))
	RegisterSignal(parent, COMSIG_LIMB_EMBED_RIP, PROC_REF(ripOut))

/datum/component/embedded/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIMB_REMOVE)
	UnregisterSignal(parent, COMSIG_LIMB_ATTACH)
	UnregisterSignal(parent, COMSIG_LIMB_EMBED_RIP)

/datum/component/embedded/proc/limb_removed(obj/item/bodypart/source, mob/living/carbon/human/owner, special)
	SIGNAL_HANDLER
	unregister_from_mob(limb_owner)

/datum/component/embedded/proc/limb_attached(obj/item/bodypart/source, mob/living/carbon/human/owner, special)
	SIGNAL_HANDLER
	register_to_mob(owner)

/datum/component/embedded/process(delta_time)
	if(!limb_owner)
		return

	if(limb_owner.stat == DEAD)
		return

	var/fall_chance_current = DT_PROB_RATE(fall_chance / 100, delta_time) * 100
	if(limb_owner.body_position == LYING_DOWN)
		fall_chance_current *= 0.2

	if(prob(fall_chance_current))
		fallOut()

////////////////////////////////////////
////////////BEHAVIOR PROCS//////////////
////////////////////////////////////////


/// Called every time a carbon with a harmful embed moves, rolling a chance for the item to cause pain. The chance is halved if the carbon is crawling or walking.
/datum/component/embedded/proc/jostleCheck()
	SIGNAL_HANDLER

	var/obj/item/bodypart/limb = parent

	var/chance = jostle_chance
	if(limb_owner.m_intent == MOVE_INTENT_WALK || limb_owner.body_position == LYING_DOWN)
		chance *= 0.5

	if(harmful && prob(chance))
		var/damage = weapon.w_class * jostle_pain_mult
		limb.receive_damage(brute=(1-pain_stam_pct) * damage, modifiers = DAMAGE_CAN_JOSTLE_BONES)
		limb_owner.stamina.adjust(-(pain_stam_pct * damage))
		var/msg = pick( \
			"A spike of pain jolts your [limb.plaintext_zone] as you bump [weapon] inside.",\
			"Your movement jostles [weapon] in your [limb.plaintext_zone] painfully.",\
			"Your movement jostles [weapon] in your [limb.plaintext_zone] painfully."\
		)
		to_chat(limb_owner, span_danger(msg))


/// Called when then item randomly falls out of a carbon. This handles the damage and descriptors, then calls safe_remove()
/datum/component/embedded/proc/fallOut()
	var/obj/item/bodypart/limb = parent
	if(harmful)
		var/damage = weapon.w_class * remove_pain_mult
		limb.receive_damage(brute=(1-pain_stam_pct) * damage, modifiers = DAMAGE_CAN_JOSTLE_BONES)
		if(limb_owner)
			limb_owner.stamina.adjust(-(pain_stam_pct * damage))

	limb_owner?.visible_message(
		span_danger("[weapon] falls [harmful ? "out" : "off"] of [limb_owner.name]'s [limb.plaintext_zone]!"),
	)

	safeRemove()

/// Called when a carbon with an object embedded/stuck to them inspects themselves and clicks the appropriate link to begin ripping the item out. This handles the ripping attempt, descriptors, and dealing damage, then calls safe_remove()
/datum/component/embedded/proc/ripOut(obj/item/bodypart/source, obj/item/I, mob/living/carbon/user)
	SIGNAL_HANDLER

	if(I != weapon || source != parent)
		return

	var/time_taken = rip_time * weapon.w_class
	INVOKE_ASYNC(src, PROC_REF(complete_rip_out), user, I, parent, time_taken)

/// everything async that ripOut used to do
/datum/component/embedded/proc/complete_rip_out(mob/living/carbon/user, obj/item/I, obj/item/bodypart/limb, time_taken)

	if(user == limb_owner)
		user.visible_message(
			span_warning("[user] attempts to remove [weapon] from [user.p_their()] [limb.plaintext_zone]."),
		)
	else
		user.visible_message(
			span_warning("[user] attempts to remove [weapon] from [limb_owner]'s [limb.plaintext_zone].")
		)

	if(harmful && user.stats.cooldown_finished("ripout_embed_check"))
		user.stats.set_cooldown("ripout_embed_check", INFINITY)
		var/datum/roll_result/result = user.stat_roll(12, /datum/rpg_skill/handicraft)
		result.do_skill_sound(user)
		switch(result.outcome)
			if(CRIT_SUCCESS)
				harmful = FALSE
				time_taken = 0
				to_chat(user, result.create_tooltip("Many hours spent on delicate projects has prepared you for this moment."))

			if(SUCCESS)
				time_taken = time_taken * 0.2
				to_chat(user, result.create_tooltip("Your hands are more than accustomed to careful tasks."))

			if(CRIT_FAILURE)
				to_chat(user, result.create_tooltip("At a crucial moment, you second guess yourself, pressing the object deeper into your flesh."))
				user.stats.set_cooldown("ripout_embed_check", 5 MINUTES)
				rip_out_damage(limb)
				return

	if(!do_after(user, limb_owner, time = time_taken, timed_action_flags = DO_PUBLIC, display = image('icons/hud/do_after.dmi', "help")))
		return

	user.stats.set_cooldown("ripout_embed_check", 0)

	if(!weapon || !limb || weapon.loc != limb || !(weapon in limb.embedded_objects))
		qdel(src)
		return

	if(harmful)
		rip_out_damage(limb)

	if(user == limb_owner)
		user.visible_message(
			span_warning("[user] successfully rips [weapon] [harmful ? "out" : "off"] of [user.p_their()] [limb.plaintext_zone]!"),
		)
	else
		user.visible_message(
			span_warning("[user] successfully rips [weapon] [harmful ? "out" : "off"] of [limb_owner]'s [limb.plaintext_zone]!"),
		)

	safeRemove(user)

/datum/component/embedded/proc/rip_out_damage(obj/item/bodypart/limb)
	var/damage = weapon.w_class * remove_pain_mult
	for(var/datum/wound/W as anything in limb.wounds)
		if(weapon in W.embedded_objects)
			W.open_wound((1-pain_stam_pct) * damage)
			break

	if(limb_owner)
		limb_owner.stamina.adjust(-(pain_stam_pct * damage))
		limb_owner.emote("pain")

		if(!IS_ORGANIC_LIMB(limb))
			limb_owner.visible_message(
				span_warning("The damage to \the [limb_owner]'s [limb.plaintext_zone] worsens."),\
				span_warning("The damage to your [limb.plaintext_zone] worsens."),\
				span_hear("You hear the screech of abused metal.")
			)
		else
			limb_owner.visible_message(
				span_warning("The wound on \the [limb_owner]'s [limb.plaintext_zone] widens with a nasty ripping noise."),\
				span_warning("The wound on your [limb.plaintext_zone] widens with a nasty ripping noise."),\
				span_hear("You hear a nasty ripping noise, as if flesh is being torn apart.")
			)

/// This proc handles the final step and actual removal of an embedded/stuck item from a carbon, whether or not it was actually removed safely.
/// If you want the thing to go into someone's hands rather than the floor, pass them in to_hands
/datum/component/embedded/proc/safeRemove(mob/to_hands)
	SIGNAL_HANDLER

	var/obj/item/bodypart/limb = parent
	limb._unembed_object(weapon)
	UnregisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING)) // have to do it here otherwise we trigger weaponDeleted()

	if(!weapon.unembedded()) // if it hasn't deleted itself due to drop del
		UnregisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
		if(to_hands)
			INVOKE_ASYNC(to_hands, TYPE_PROC_REF(/mob, put_in_hands), weapon)
		else
			weapon.forceMove(get_turf(limb_owner || parent))

	qdel(src)

/// Something deleted or moved our weapon while it was embedded, how rude!
/datum/component/embedded/proc/weaponDeleted()
	SIGNAL_HANDLER

	var/obj/item/bodypart/limb = parent
	limb._unembed_object(weapon)

	if(limb_owner)
		to_chat(limb_owner, span_userdanger("\The [weapon] that was embedded in your [limb.plaintext_zone] disappears!"))

	qdel(src)

/// The signal for listening to see if someone is using a hemostat on us to pluck out this object
/datum/component/embedded/proc/checkTweeze(obj/item/bodypart/source, obj/item/possible_tweezers, mob/user)
	SIGNAL_HANDLER

	var/obj/item/bodypart/limb = parent
	if(possible_tweezers.tool_behaviour != TOOL_HEMOSTAT || user.zone_selected != limb.body_zone)
		return

	if(weapon != limb.embedded_objects[1]) // just pluck the first one, since we can't easily coordinate with other embedded components affecting this limb who is highest priority
		return

	if(limb_owner) // check to see if the limb is actually exposed
		if(limb_owner.try_inject(user, limb.body_zone, INJECT_CHECK_IGNORE_SPECIES | INJECT_TRY_SHOW_ERROR_MESSAGE))
			return TRUE

	INVOKE_ASYNC(src, PROC_REF(tweezePluck), possible_tweezers, user)
	return COMPONENT_NO_AFTERATTACK

/// The actual action for pulling out an embedded object with a hemostat
/datum/component/embedded/proc/tweezePluck(obj/item/possible_tweezers, mob/user)
	var/self_pluck = (user == limb_owner)
	var/obj/item/bodypart/limb = parent
	var/target = limb_owner || limb

	if(self_pluck)
		user.visible_message(
			span_notice("[user] begins plucking [weapon] from [user.p_their()] [limb.plaintext_zone]"),
			vision_distance=COMBAT_MESSAGE_RANGE,
		)
	else
		user.visible_message(
			span_notice("[user] begins plucking [weapon] from [target]'s [limb.plaintext_zone]"),
			vision_distance=COMBAT_MESSAGE_RANGE,
		)

	var/pluck_time = 2.5 SECONDS * weapon.w_class * (self_pluck ? 2 : 1)
	if(!do_after(user, target, pluck_time, DO_PUBLIC, display = possible_tweezers))
		if(self_pluck)
			to_chat(user, span_warning("You fail to pluck [weapon] from your [limb.plaintext_zone]."))
		else
			if(limb_owner)
				to_chat(user, span_warning("You fail to pluck [weapon] from [limb_owner]'s [limb.plaintext_zone]."))
				to_chat(limb_owner, span_warning("[user] fails to pluck [weapon] from your [limb.plaintext_zone]."))
			else
				to_chat(to_chat(user, span_warning("You fail to pluck [weapon] from [limb].")))
		return

	if(self_pluck)
		user.visible_message(user, span_notice("[user] successfully plucks [weapon] from [user.p_their()] [limb.plaintext_zone]."))
	else
		if(limb_owner)
			user.visible_message(user, span_notice("[user] successfully plucks [weapon] from [limb_owner]'s [limb.plaintext_zone]."))
		else
			user.visible_message(user, span_notice("[user] successfully plucks [weapon] from [limb]."))

	safeRemove(user)

/// Called whenever the limb owner is health scanned
/datum/component/embedded/proc/on_healthscan(datum/source, list/render_string, mob/user, mode, advanced)
	SIGNAL_HANDLER

	var/obj/obj_parent = parent
	if(advanced)
		render_string += "<span style='font-weight: bold; color: [COLOR_MEDICAL_EMBEDDED]'>Foreign body detected in subject's [obj_parent.name].</span>\n"
	else
		render_string += "<span style='font-weight: bold; color: [COLOR_MEDICAL_EMBEDDED]'>Foreign body detected. Advanced scanner required for location.</span>\n"

/obj/item/shard/embed_tester
	name = "extra extra sharp glass"
	embedding = list("embed_chance" = 100, "ignore_throwspeed_threshold" = TRUE)
