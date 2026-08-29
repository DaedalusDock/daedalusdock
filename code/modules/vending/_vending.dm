/*
 * Vending machine types - Can be found under /code/modules/vending/
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	products = list()
	contraband = list()
	premium = list()
*/
#define MAX_VENDING_INPUT_AMOUNT 30
/**
 * # vending record datum
 *
 * A datum that represents a product that is vendable
 */
/datum/data/vending_product
	name = "generic"
	///Typepath of the product that is created when this record "sells"
	var/atom/movable/product_path = null
	///How many of this product we currently have
	var/amount = 0
	///How many we can store at maximum
	var/max_amount = 0
	///Does the item have a custom price override
	var/custom_price
	///Does the item have a custom premium price override
	var/custom_premium_price
	///Whether spessmen with an ID with an age below AGE_MINOR (20 by default) can buy this item
	var/age_restricted = FALSE
	///Whether the product can be recolored by the GAGS system
	var/colorable
	///List of items that have been returned to the vending machine.
	var/list/returned_products

DEFINE_INTERACTABLE(/obj/machinery/vending)
/**
 * # vending machines
 *
 * Captalism in the year 2525, everything in a vending machine, even love
 */
TYPEINFO_DEF(/obj/machinery/vending)
	default_armor = list(BLUNT = 20, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 70)

/obj/machinery/vending
	name = "\improper Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	max_integrity = 300
	integrity_failure = 0.33
	circuit = /obj/item/circuitboard/machine/vendor
	payment_department = ACCOUNT_STATION_MASTER
	light_power = 0.5
	light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	zmm_flags = ZMM_MANGLE_PLANES

	/// Is the machine active (No sales pitches if off)!
	var/active = 1
	///Are we ready to vend?? Is it time??
	var/vend_ready = TRUE

	///Next world time to send a purchase message
	var/purchase_message_cooldown
	///The ref of the last mob to shop with us
	var/last_shopper
	var/tilted = FALSE
	var/tiltable = TRUE
	var/squish_damage = 75
	var/forcecrit = 0
	var/num_shards = 7
	var/list/pinned_mobs = list()
	///Icon for the maintenance panel overlay
	var/panel_type = "panel1"

	/**
	  * List of products this machine sells
	  *
	  * form should be list(/type/path = amount, /type/path2 = amount2)
	  */
	var/list/products = list()

	/**
	  * List of products this machine sells when you hack it
	  *
	  * form should be list(/type/path = amount, /type/path2 = amount2)
	  */
	var/list/contraband = list()

	/**
	  * List of premium products this machine sells
	  *
	  * form should be list(/type/path, /type/path2) as there is only ever one in stock
	  */
	var/list/premium = list()

	///String of slogans separated by semicolons, optional
	var/product_slogans = ""
	///String of small ad messages in the vending screen - random chance
	var/product_ads = ""

	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()
	var/list/slogan_list = list()
	///Small ad messages in the vending screen - random chance of popping up whenever you open it
	var/list/small_ads = list()
	///Message sent post vend (Thank you for shopping!)
	var/vend_reply
	///Last world tick we sent a vent reply
	var/last_reply = 0
	///Last world tick we sent a slogan message out
	var/last_slogan = 0
	///How many ticks until we can send another
	var/slogan_delay = 6000
	///Icon when vending an item to the user
	var/icon_vend
	///Icon to flash when user is denied a vend
	var/icon_deny
	///World ticks the machine is electified for
	var/seconds_electrified = MACHINE_NOT_ELECTRIFIED
	///When this is TRUE, we fire items at customers! We're broken!
	var/shoot_inventory = 0
	///How likely this is to happen (prob 100) per second
	var/shoot_inventory_chance = 1
	//Stop spouting those godawful pitches!
	var/shut_up = 0
	///can we access the hidden inventory?
	var/extended_inventory = 0
	///Are we checking the users ID
	var/scan_id = 1
	///Default price of items if not overridden
	var/default_price = PAYCHECK_ASSISTANT * 0.4
	/// Default price ADDED to the default price of premium items if they don't have one set.
	var/extra_price = PAYCHECK_ASSISTANT * 1.5
	///Whether our age check is currently functional
	var/age_restrictions = TRUE
	/**
	  * Is this item on station or not
	  *
	  * if it doesn't originate from off-station during mapload, everything is free
	  */
	var/onstation = TRUE //if it doesn't originate from off-station during mapload, everything is free
	///A variable to change on a per instance basis on the map that allows the instance to force cost and ID requirements
	var/onstation_override = FALSE //change this on the object on the map to override the onstation check. DO NOT APPLY THIS GLOBALLY.

	///ID's that can load this vending machine wtih refills
	var/list/canload_access_list

	///Access that gets the non-premium content for free
	var/list/discount_access = null

	var/list/vending_machine_input = list()
	///Display header on the input view
	var/input_display_header = "Custom Vendor"

	//The type of refill canisters used by this machine.
	var/obj/item/vending_refill/refill_canister = null

	/// how many items have been inserted in a vendor
	var/loaded_items = 0

	///Name of lighting mask for the vending machine
	var/light_mask

	/// Money inside us.
	var/obj/item/stack/spacecash/contained_cash

/**
 * Initialize the vending machine
 *
 * Builds the vending machine inventory, sets up slogans and other such misc work
 *
 * This also sets the onstation var to:
 * * FALSE - if the machine was maploaded on a zlevel that doesn't pass the is_station_level check
 * * TRUE - all other cases
 */
/obj/machinery/vending/Initialize(mapload)
	SET_TRACKING(__TYPE__)
	var/build_inv = FALSE
	if(!refill_canister)
		circuit = null
		build_inv = TRUE
	. = ..()
	wires = new /datum/wires/vending(src)
	if(build_inv) //non-constructable vending machine
		build_inventory(products, product_records)
		build_inventory(contraband, hidden_records)
		build_inventory(premium, coin_records)

	slogan_list = splittext(product_slogans, ";")
	// So not all machines speak at the exact same time.
	// The first time this machine says something will be at slogantime + this random value,
	// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
	last_slogan = world.time + rand(0, slogan_delay)
	power_change()

	if(onstation_override) //overrides the checks if true.
		onstation = TRUE
		return
	if(mapload) //check if it was initially created off station during mapload.
		if(!is_station_level(z))
			onstation = FALSE
			if(circuit)
				circuit.onstation = onstation //sync up the circuit so the pricing schema is carried over if it's reconstructed.
	else if(circuit && (circuit.onstation != onstation)) //check if they're not the same to minimize the amount of edited values.
		onstation = circuit.onstation //if it was constructed outside mapload, sync the vendor up with the circuit's var so you can't bypass price requirements by moving / reconstructing it off station.

/obj/machinery/vending/Destroy()
	UNSET_TRACKING(__TYPE__)
	QDEL_NULL(wires)
	QDEL_NULL(contained_cash)
	return ..()

/obj/machinery/vending/can_speak()
	return !shut_up

/obj/machinery/vending/RefreshParts()         //Better would be to make constructable child
	SHOULD_CALL_PARENT(FALSE)
	if(!component_parts)
		return

	product_records = list()
	hidden_records = list()
	coin_records = list()
	build_inventory(products, product_records, start_empty = TRUE)
	build_inventory(contraband, hidden_records, start_empty = TRUE)
	build_inventory(premium, coin_records, start_empty = TRUE)
	for(var/obj/item/vending_refill/VR in component_parts)
		restock(VR)

/obj/machinery/vending/deconstruct(disassembled = TRUE)
	if(!refill_canister) //the non constructable vendors drop metal instead of a machine frame.
		if(!(flags_1 & NODECONSTRUCT_1))
			new /obj/item/stack/sheet/iron(loc, 3)
		qdel(src)
	else
		..()

/obj/machinery/vending/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & BROKEN)
		set_light(0)
		return
	set_light(powered() ? MINIMUM_USEFUL_LIGHT_RANGE : 0)


/obj/machinery/vending/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return ..()
	icon_state = "[initial(icon_state)][powered() ? null : "-off"]"
	return ..()


/obj/machinery/vending/update_overlays()
	. = ..()
	if(panel_open)
		. += panel_type
	if(light_mask && !(machine_stat & BROKEN) && powered())
		. += emissive_appearance(icon, light_mask, alpha = 90)

/obj/machinery/vending/atom_break(damage_flag)
	. = ..()
	if(!.)
		return

	var/dump_amount = 0
	var/found_anything = TRUE
	while (found_anything)
		found_anything = FALSE
		for(var/record in shuffle(product_records))
			var/datum/data/vending_product/R = record

			//first dump any of the items that have been returned, in case they contain the nuke disk or something
			for(var/obj/returned_obj_to_dump in R.returned_products)
				LAZYREMOVE(R.returned_products, returned_obj_to_dump)
				returned_obj_to_dump.forceMove(get_turf(src))
				step(returned_obj_to_dump, pick(GLOB.alldirs))
				R.amount--

			if(R.amount <= 0) //Try to use a record that actually has something to dump.
				continue
			var/dump_path = R.product_path
			if(!dump_path)
				continue
			R.amount--
			// busting open a vendor will destroy some of the contents
			if(found_anything && prob(80))
				continue

			var/obj/obj_to_dump = new dump_path(loc)
			step(obj_to_dump, pick(GLOB.alldirs))
			found_anything = TRUE
			dump_amount++
			if (dump_amount >= 16)
				return

GLOBAL_LIST_EMPTY(vending_products)
/**
 * Build the inventory of the vending machine from it's product and record lists
 *
 * This builds up a full set of /datum/data/vending_products from the product list of the vending machine type
 * Arguments:
 * * productlist - the list of products that need to be converted
 * * recordlist - the list containing /datum/data/vending_product datums
 * * startempty - should we set vending_product record amount from the product list (so it's prefilled at roundstart)
 */
/obj/machinery/vending/proc/build_inventory(list/productlist, list/recordlist, start_empty = FALSE)
	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		if(isnull(amount))
			amount = 0

		var/obj/item/temp = typepath
		var/datum/data/vending_product/R = new /datum/data/vending_product()
		GLOB.vending_products[typepath] = 1
		R.name = initial(temp.name)
		R.product_path = typepath
		if(!start_empty)
			R.amount = amount
		R.max_amount = amount
		///Prices of vending machines are all increased uniformly.
		R.custom_price = round(initial(temp.custom_price))
		R.custom_premium_price = round(initial(temp.custom_premium_price))
		R.age_restricted = initial(temp.age_restricted)
		R.colorable = !!(initial(temp.greyscale_config) && initial(temp.greyscale_colors) && (initial(temp.flags_1) & IS_PLAYER_COLORABLE_1))
		recordlist += R

/**
 * Reassign the prices of the vending machine using the multiplier argument
 *
 * This rebuilds both /datum/data/vending_products lists for premium and standard products based on their most relevant pricing values.
 * Arguments:
 * * recordlist - the list of standard product datums in the vendor to refresh their prices.
 * * premiumlist - the list of premium product datums in the vendor to refresh their prices.
 */
/obj/machinery/vending/proc/reset_prices(list/recordlist, list/premiumlist, multiplier)
	default_price = round(initial(default_price) * multiplier)
	extra_price = round(initial(extra_price) * multiplier)
	for(var/R in recordlist)
		var/datum/data/vending_product/record = R
		var/obj/item/potential_product = record.product_path
		record.custom_price = round(initial(potential_product.custom_price) * multiplier)
	for(var/R in premiumlist)
		var/datum/data/vending_product/record = R
		var/obj/item/potential_product = record.product_path
		var/premium_sanity = round(initial(potential_product.custom_premium_price))
		if(premium_sanity)
			record.custom_premium_price = round(premium_sanity * multiplier)
			continue
		//For some ungodly reason, some premium only items only have a custom_price
		record.custom_premium_price = round(extra_price + (initial(potential_product.custom_price) * (multiplier)))

/**
 * Refill a vending machine from a refill canister
 *
 * This takes the products from the refill canister and then fills the products,contraband and premium product categories
 *
 * Arguments:
 * * canister - the vending canister we are refilling from
 */
/obj/machinery/vending/proc/restock(obj/item/vending_refill/canister)
	if (!canister.products)
		canister.products = products.Copy()
	if (!canister.contraband)
		canister.contraband = contraband.Copy()
	if (!canister.premium)
		canister.premium = premium.Copy()
	. = 0
	. += refill_inventory(canister.products, product_records)
	. += refill_inventory(canister.contraband, hidden_records)
	. += refill_inventory(canister.premium, coin_records)
/**
 * Refill our inventory from the passed in product list into the record list
 *
 * Arguments:
 * * productlist - list of types -> amount
 * * recordlist - existing record datums
 */
/obj/machinery/vending/proc/refill_inventory(list/productlist, list/recordlist)
	. = 0
	for(var/R in recordlist)
		var/datum/data/vending_product/record = R
		var/diff = min(record.max_amount - record.amount, productlist[record.product_path])
		if (diff)
			productlist[record.product_path] -= diff
			record.amount += diff
			. += diff
/**
 * Set up a refill canister that matches this machines products
 *
 * This is used when the machine is deconstructed, so the items aren't "lost"
 */
/obj/machinery/vending/proc/update_canister()
	if (!component_parts)
		return

	var/obj/item/vending_refill/R = locate() in component_parts
	if (!R)
		CRASH("Constructible vending machine did not have a refill canister")

	R.products = unbuild_inventory(product_records)
	R.contraband = unbuild_inventory(hidden_records)
	R.premium = unbuild_inventory(coin_records)

/**
 * Given a record list, go through and and return a list of type -> amount
 */
/obj/machinery/vending/proc/unbuild_inventory(list/recordlist)
	. = list()
	for(var/R in recordlist)
		var/datum/data/vending_product/record = R
		.[record.product_path] += record.amount

/obj/machinery/vending/crowbar_act(mob/living/user, obj/item/I)
	if(!component_parts)
		return FALSE
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/vending/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!panel_open)
		return FALSE
	if(default_unfasten_wrench(user, tool, time = 6 SECONDS))
		unbuckle_all_mobs(TRUE)
		return ITEM_INTERACT_SUCCESS
	return FALSE

/obj/machinery/vending/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(anchored)
		default_deconstruction_screwdriver(user, icon_state, icon_state, I)
		update_appearance()
	else
		to_chat(user, span_warning("You must first secure [src]."))
	return TRUE

/obj/machinery/vending/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return

	if(istype(tool, /obj/item/stack/spacecash))
		var/obj/item/stack/spacecash/user_money = tool
		if(!user.canUnequipItem(user_money))
			return ITEM_INTERACT_BLOCKING

		if(!istype(user_money, /obj/item/stack/spacecash/c1) || (contained_cash && contained_cash.amount == contained_cash.max_amount)) // pain
			to_chat(user, span_warning("[src] rejects [user_money]."))
			playsound(src, 'sound/machines/buzz-two.ogg', 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
			return ITEM_INTERACT_BLOCKING

		if(!contained_cash)
			user.transferItemToLoc(user_money, src)
			set_contained_cash(user_money)
		else
			var/space_remaining = initial(user_money.max_amount) - contained_cash.amount
			var/insert_amount = min(space_remaining, user_money.amount)
			user_money.do_pickup_animation(src, get_turf(user))
			user_money.use(insert_amount, TRUE)
			contained_cash.add(insert_amount)

		playsound(src, 'sound/machines/cash_insert.ogg', 20, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		user.visible_message(span_notice("[user] inserts [tool] into [src]."))
		return ITEM_INTERACT_SUCCESS

/obj/machinery/vending/attackby(obj/item/I, mob/living/user, params)
	if(panel_open && is_wire_tool(I))
		wires.interact(user)
		return

	if(refill_canister && istype(I, refill_canister))
		if (!panel_open)
			to_chat(user, span_warning("You should probably unscrew the service panel first!"))
		else if (machine_stat & (BROKEN|NOPOWER))
			to_chat(user, span_notice("[src] does not respond."))
		else
			//if the panel is open we attempt to refill the machine
			var/obj/item/vending_refill/canister = I
			if(canister.get_part_rating() == 0)
				to_chat(user, span_warning("[canister] is empty!"))
			else
				// instantiate canister if needed
				var/transferred = restock(canister)
				if(transferred)
					to_chat(user, span_notice("You loaded [transferred] items in [src]."))
				else
					to_chat(user, span_warning("There's nothing to restock!"))
			return
	if(compartmentLoadAccessCheck(user) && !user.combat_mode)
		if(canLoadItem(I))
			loadingAttempt(I,user)

		if(istype(I, /obj/item/storage/bag)) //trays USUALLY
			var/obj/item/storage/T = I
			var/loaded = 0
			var/denied_items = 0
			for(var/obj/item/the_item in T.contents)
				if(contents.len >= MAX_VENDING_INPUT_AMOUNT) // no more than 30 item can fit inside, legacy from snack vending although not sure why it exists
					to_chat(user, span_warning("[src]'s compartment is full."))
					break
				if(canLoadItem(the_item) && loadingAttempt(the_item,user))
					T.atom_storage?.attempt_remove(the_item, src)
					loaded++
				else
					denied_items++
			if(denied_items)
				to_chat(user, span_warning("[src] refuses some items!"))
			if(loaded)
				to_chat(user, span_notice("You insert [loaded] dishes into [src]'s compartment."))
	else
		. = ..()
		if(tiltable && !tilted && I.force)
			switch(rand(1, 100))
				if(1 to 5)
					freebie(user, 3)
				if(6 to 15)
					freebie(user, 2)
				if(16 to 25)
					freebie(user, 1)
				if(26 to 75)
					return
				if(76 to 90)
					tilt(user)
				if(91 to 100)
					tilt(user, crit=TRUE)

/obj/machinery/vending/proc/freebie(mob/fatty, freebies)
	visible_message(span_notice("[src] yields [freebies > 1 ? "several free goodies" : "a free goody"]!"))

	for(var/i in 1 to freebies)
		playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)
		for(var/datum/data/vending_product/R in shuffle(product_records))

			if(R.amount <= 0) //Try to use a record that actually has something to dump.
				continue
			var/dump_path = R.product_path
			if(!dump_path)
				continue
			if(R.amount > LAZYLEN(R.returned_products)) //always give out new stuff that costs before free returned stuff, because of the risk getting gibbed involved
				new dump_path(get_turf(src))
			else
				var/obj/returned_obj_to_dump = LAZYACCESS(R.returned_products, LAZYLEN(R.returned_products)) //first in, last out
				LAZYREMOVE(R.returned_products, returned_obj_to_dump)
				returned_obj_to_dump.forceMove(get_turf(src))
			R.amount--
			break

///Tilts ontop of the atom supplied, if crit is true some extra shit can happen. Returns TRUE if it dealt damage to something.
/obj/machinery/vending/proc/tilt(atom/fatty, crit=FALSE)
	if(QDELETED(src) || !has_gravity(src))
		return
	visible_message(span_danger("[src] tips over!"))
	tilted = TRUE
	layer = ABOVE_MOB_LAYER

	var/crit_case
	if(crit)
		crit_case = rand(1,6)

	if(forcecrit)
		crit_case = forcecrit

	. = FALSE

	if(in_range(fatty, src))
		for(var/mob/living/L in get_turf(fatty))
			var/mob/living/carbon/C = L

			SEND_SIGNAL(L, COMSIG_ON_VENDOR_CRUSH)


			if(istype(C))
				var/crit_rebate = 0 // lessen the normal damage we deal for some of the crits

				if(crit_case < 5) // the body/head asplode case has its own description
					C.visible_message(span_danger("[C] is crushed by [src]!"), \
						span_userdanger("You are crushed by [src]!"))

				switch(crit_case) // only carbons can have the fun crits
					if(1) // shatter their legs and bleed 'em
						crit_rebate = 60
						C.bleed(150)
						var/obj/item/bodypart/leg/left/l = C.get_bodypart(BODY_ZONE_L_LEG)
						if(l)
							l.receive_damage(brute=200)
						var/obj/item/bodypart/leg/right/r = C.get_bodypart(BODY_ZONE_R_LEG)
						if(r)
							r.receive_damage(brute=200)
						if(l || r)
							C.visible_message(span_danger("[C]'s legs shatter with a sickening crunch!"), \
								span_userdanger("Your legs shatter with a sickening crunch!"))
					if(2) // pin them beneath the machine until someone untilts it
						forceMove(get_turf(C))
						buckle_mob(C, force=TRUE)
						C.visible_message(span_danger("[C] is pinned underneath [src]!"), \
							span_userdanger("You are pinned down by [src]!"))
					if(3) // glass candy
						crit_rebate = 50
						for(var/i in 1 to num_shards)
							var/obj/item/shard/shard = new /obj/item/shard(get_turf(C))
							shard.embedding = list(embed_chance = 100, ignore_throwspeed_threshold = TRUE, impact_pain_mult=1, pain_chance=5)
							shard.updateEmbedding()
							C.hitby(shard, skipcatch = TRUE, hitpush = FALSE)
							shard.embedding = list()
							shard.updateEmbedding()
					if(4) // paralyze this binch
						// the new paraplegic gets like 4 lines of losing their legs so skip them
						visible_message(span_danger("[C]'s spinal cord is obliterated with a sickening crunch!"), ignored_mobs = list(C))
						C.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic)
					if(5) // limb squish!
						for(var/obj/item/bodypart/squish_part as anything in C.bodyparts)
							squish_part.receive_damage(brute=40)
						C.visible_message(span_danger("[C]'s body is maimed underneath the mass of [src]!"), \
							span_userdanger("Your body is maimed underneath the mass of [src]!"))
					if(6) // skull squish!
						var/obj/item/bodypart/head/O = C.get_bodypart(BODY_ZONE_HEAD)
						if(O)
							C.visible_message(span_danger("[O] explodes in a shower of gore beneath [src]!"), \
								span_userdanger("Oh f-"))
							O.dismember()
							O.drop_contents()
							qdel(O)
							new /obj/effect/gibspawner/human/bodypartless(get_turf(C))

				if(prob(30))
					C.apply_damage(max(0, squish_damage - crit_rebate), forced=TRUE, spread_damage=TRUE) // the 30% chance to spread the damage means you escape breaking any bones
				else
					C.take_bodypart_damage((squish_damage - crit_rebate)*0.5) // otherwise, deal it to 2 random limbs (or the same one) which will likely shatter something
					C.take_bodypart_damage((squish_damage - crit_rebate)*0.5)
				C.AddElement(/datum/element/squish, 80 SECONDS)
			else
				L.visible_message(span_danger("[L] is crushed by [src]!"), \
				span_userdanger("You are crushed by [src]!"))
				L.apply_damage(squish_damage, forced=TRUE)
				if(crit_case)
					L.apply_damage(squish_damage, forced=TRUE)

			L.Paralyze(60)
			L.emote("agony")
			. = TRUE
			playsound(L, 'sound/effects/blobattack.ogg', 40, TRUE)
			playsound(L, 'sound/effects/splat.ogg', 50, TRUE)

	var/matrix/M = matrix()
	M.Turn(pick(90, 270))
	transform = M

	if(get_turf(fatty) != get_turf(src))
		throw_at(get_turf(fatty), 1, 1, spin=FALSE, quickstart=FALSE)

/obj/machinery/vending/proc/untilt(mob/user)
	if(user)
		user.visible_message(span_notice("[user] rights [src]."), \
			span_notice("You right [src]."))

	unbuckle_all_mobs(TRUE)

	tilted = FALSE
	layer = initial(layer)

	var/matrix/M = matrix()
	M.Turn(0)
	transform = M

/obj/machinery/vending/proc/loadingAttempt(obj/item/I, mob/user)
	. = TRUE
	if(!user.transferItemToLoc(I, src))
		return FALSE
	to_chat(user, span_notice("You insert [I] into [src]'s input compartment."))

	for(var/datum/data/vending_product/product_datum in product_records + coin_records + hidden_records)
		if(ispath(I.type, product_datum.product_path))
			product_datum.amount++
			LAZYADD(product_datum.returned_products, I)
			return

	if(vending_machine_input[format_text(I.name)])
		vending_machine_input[format_text(I.name)]++
	else
		vending_machine_input[format_text(I.name)] = 1
	loaded_items++

/obj/machinery/vending/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	if(!force)
		return
	. = ..()

/**
 * Is the passed in user allowed to load this vending machines compartments
 *
 * Arguments:
 * * user - mob that is doing the loading of the vending machine
 */
/obj/machinery/vending/proc/compartmentLoadAccessCheck(mob/user)
	if(!canload_access_list)
		return TRUE

	var/do_you_have_access = FALSE
	var/req_access_txt_holder = req_access_txt
	for(var/i in canload_access_list)
		req_access_txt = i
		if(!allowed(user) && !(obj_flags & EMAGGED) && scan_id)
			continue
		else
			do_you_have_access = TRUE
			break //you passed don't bother looping anymore

	req_access_txt = req_access_txt_holder // revert to normal (before the proc ran)

	if(do_you_have_access)
		return TRUE

	to_chat(user, span_warning("[src]'s input compartment blinks red: Access denied."))
	return FALSE

/obj/machinery/vending/exchange_parts(mob/user, obj/item/storage/part_replacer/W)
	if(!istype(W))
		return FALSE
	if((flags_1 & NODECONSTRUCT_1) && !W.works_from_distance)
		return FALSE
	if(!component_parts || !refill_canister)
		return FALSE

	var/moved = 0
	if(panel_open || W.works_from_distance)
		if(W.works_from_distance)
			display_parts(user)
		for(var/I in W)
			if(istype(I, refill_canister))
				moved += restock(I)
	else
		display_parts(user)
	if(moved)
		to_chat(user, span_notice("[moved] items restocked."))
		W.play_rped_sound()
	return TRUE

/obj/machinery/vending/on_deconstruction()
	update_canister()
	contained_cash.forceMove(drop_location())
	. = ..()

/obj/machinery/vending/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_notice("You short out the product lock on [src]."))

/obj/machinery/vending/_try_interact(mob/user)
	if(seconds_electrified && !(machine_stat & NOPOWER))
		if(shock(user, 100))
			return

	if(tilted && !user.buckled && !isAI(user))
		to_chat(user, span_notice("You begin righting [src]."))
		if(do_after(user, src, 50))
			untilt(user)
		return

	return ..()

/obj/machinery/vending/attack_robot_secondary(mob/user, list/modifiers)
	. = ..()
	if (!Adjacent(user, src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// /obj/machinery/vending/ui_assets(mob/user)
// 	return list(
// 		get_asset_datum(/datum/asset/spritesheet/vending),
// 	)

/obj/machinery/vending/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vending", name)
		ui.open()

/obj/machinery/vending/ui_static_data(mob/user)
	. = list()
	.["onstation"] = onstation
	.["department"] = payment_department
	.["jobDiscount"] = VENDING_DISCOUNT
	.["product_records"] = list()
	for (var/datum/data/vending_product/R in product_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_price || default_price,
			max_amount = R.max_amount,
			ref = REF(R),
			icon = initial(R.product_path.icon),
			icon_state = initial(R.product_path.icon_state)
		)
		.["product_records"] += list(data)
	.["coin_records"] = list()
	for (var/datum/data/vending_product/R in coin_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_premium_price || extra_price,
			max_amount = R.max_amount,
			ref = REF(R),
			premium = TRUE,
			icon = initial(R.product_path.icon),
			icon_state = initial(R.product_path.icon_state)
		)
		.["coin_records"] += list(data)
	.["hidden_records"] = list()
	for (var/datum/data/vending_product/R in hidden_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_premium_price || extra_price,
			max_amount = R.max_amount,
			ref = REF(R),
			premium = TRUE,
			icon = initial(R.product_path.icon),
			icon_state = initial(R.product_path.icon_state)
		)
		.["hidden_records"] += list(data)

/obj/machinery/vending/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/C
	if(isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)

	if(C?.registered_account)
		.["user"] = list()
		.["user"]["name"] = C.registered_account.account_holder
		.["user"]["account_balance"] = C.registered_account.account_balance

	if(discount_access && (discount_access in C?.access))
		.["access"] = TRUE

	.["stock"] = list()
	for (var/datum/data/vending_product/R in product_records + coin_records + hidden_records)
		var/list/product_data = list(
			name = R.name,
			amount = R.amount,
			colorable = R.colorable,
		)
		.["stock"][R.name] = product_data

	.["extended_inventory"] = extended_inventory
	.["inserted_cash"] = contained_cash?.get_item_credit_value() || 0

/obj/machinery/vending/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("vend")
			. = vend(ui.user, TRUE, locate(params["ref"]))
			ui.user.changeNext_move(CLICK_CD_RAPID) // chat spam from "insufficient funds"
		if("select_colors")
			. = select_colors(params)
		if("dispense_cash")
			. = dispense_cash(ui.user)

/// Dispense all contained cash to the user.
/obj/machinery/vending/proc/dispense_cash(mob/user)
	if(!contained_cash)
		return FALSE

	playsound(src, 'sound/machines/cash_desert.ogg', 20, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	var/obj/item/old_cash = contained_cash
	if(user?.put_in_hands(contained_cash))
		old_cash.do_pickup_animation(user, get_turf(src))
	else
		contained_cash.forceMove(drop_location())

	set_contained_cash(null)
	return TRUE

/obj/machinery/vending/proc/set_contained_cash(obj/item/stack/spacecash/cash)
	if(contained_cash)
		UnregisterSignal(contained_cash, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

	contained_cash = cash

	if(cash)
		contained_cash = cash
		RegisterSignal(contained_cash, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_cash_moved))

/// Checks if the user can purchase an item from this machine.
/obj/machinery/vending/proc/can_user_vend(user, silent=FALSE)
	. = FALSE
	if(!vend_ready)
		to_chat(user, span_warning("The vending machine is busy."))
		return
	if(panel_open)
		to_chat(user, span_warning("The vending machine cannot dispense products while its service panel is open."))
		return
	return TRUE

/obj/machinery/vending/proc/select_colors(list/params)
	. = TRUE
	if(!can_user_vend(usr))
		return

	var/datum/data/vending_product/product = locate(params["ref"])
	var/atom/fake_atom = product.product_path

	var/list/allowed_configs = list()
	var/config = initial(fake_atom.greyscale_config)
	if(!config)
		return

	allowed_configs += "[config]"
	if(ispath(fake_atom, /obj/item))
		var/obj/item/item = fake_atom
		if(initial(item.greyscale_config_worn))
			allowed_configs += "[initial(item.greyscale_config_worn)]"
		if(initial(item.greyscale_config_inhand_left))
			allowed_configs += "[initial(item.greyscale_config_inhand_left)]"
		if(initial(item.greyscale_config_inhand_right))
			allowed_configs += "[initial(item.greyscale_config_inhand_right)]"

	var/datum/greyscale_modify_menu/menu = new(
		src, usr, allowed_configs, CALLBACK(src, PROC_REF(vend_greyscale), locate(params["ref"])),
		starting_icon_state=initial(fake_atom.icon_state),
		starting_config=initial(fake_atom.greyscale_config),
		starting_colors=initial(fake_atom.greyscale_colors)
	)
	menu.ui_interact(usr)

/obj/machinery/vending/proc/vend_greyscale(datum/data/vending_product/vend_datum, datum/greyscale_modify_menu/menu)
	if(usr != menu.user)
		return
	if(!menu.target.can_interact(usr))
		return

	vend(usr, TRUE, vend_datum, menu.split_colors)

/// The core vend proc used by normal vendors.
/obj/machinery/vending/proc/vend(mob/user, delayed = FALSE, datum/data/vending_product/vend_datum, list/greyscale_colors)
	if(!can_user_vend(user))
		return

	if(!sanitize_vend(user, vend_datum))
		return

	usr?.animate_interact(src)
	playsound(src, 'goon/sounds/button.ogg', 50, extrarange = SILENCED_SOUND_EXTRARANGE)

	if (vend_datum.amount <= 0)
		speak("Sold out.")
		z_flick(icon_deny,src)
		return

	if(onstation && (pay_for_vend(user, vend_datum) == -1))
		return

	if(delayed)
		vend_ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(complete_vend), user, vend_datum, greyscale_colors), vend_delay_animation(), TIMER_DELETE_ME)
	else
		complete_vend(user, vend_datum, greyscale_colors)
	return TRUE

/// Complete the vend.
/obj/machinery/vending/proc/complete_vend(mob/user, datum/data/vending_product/vend_datum, list/greyscale_colors)
	SHOULD_NOT_SLEEP(TRUE)

	vend_ready = TRUE
	if(!is_operational)
		return FALSE // Lol sucks to suck!

	thank_shopper(user)

	use_power(active_power_usage)

	if(icon_vend) //Show the vending animation if needed
		z_flick(icon_vend,src)

	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)

	dispense_item(usr, vend_datum)

	SSblackbox.record_feedback("nested tally", "vending_machine_usage", 1, list("[type]", "[vend_datum.product_path]"))

/// Sanitizes the input of vend().
/obj/machinery/vending/proc/sanitize_vend(mob/user, datum/data/vending_product/vend_datum)
	if(!istype(vend_datum) || !vend_datum.product_path)
		return

	var/list/record_to_check = product_records + coin_records
	if(extended_inventory)
		record_to_check = product_records + coin_records + hidden_records

	if(vend_datum in hidden_records)
		if(!extended_inventory)
			return

	else if (!(vend_datum in record_to_check))
		message_admins("Vending machine exploit attempted by [ADMIN_LOOKUPFLW(user)]!")
		return FALSE

	return TRUE

/// Thank our patron.
/obj/machinery/vending/proc/thank_shopper(mob/shopper)
	if(last_shopper != REF(shopper) || purchase_message_cooldown < world.time)
		speak("Thank you for shopping with [src]!")
		purchase_message_cooldown = world.time + 5 SECONDS
		last_shopper = REF(shopper)

/// Dispense the item to the user.
/obj/machinery/vending/proc/dispense_item(mob/user, datum/data/vending_product/vend_datum)
	PROTECTED_PROC(TRUE)

	var/obj/item/vended_item
	if(!LAZYLEN(vend_datum.returned_products)) //always give out free returned stuff first, e.g. to avoid walling a traitor objective in a bag behind paid items
		vended_item = new vend_datum.product_path(get_turf(src))
	else
		vended_item = LAZYACCESS(vend_datum.returned_products, LAZYLEN(vend_datum.returned_products)) //first in, last out
		LAZYREMOVE(vend_datum.returned_products, vended_item)
		vended_item.forceMove(get_turf(src))

	if(greyscale_colors)
		vended_item.set_greyscale(colors=greyscale_colors)

	vend_datum.amount--

	give_or_drop_dispensed_item(user, vended_item)
	return vended_item

/// It's in the name.
/obj/machinery/vending/proc/give_or_drop_dispensed_item(mob/user, obj/item/vended_item)
	PROTECTED_PROC(TRUE)
	if(IsReachableBy(user) && usr.put_in_hands(vended_item, drop_on_fail = FALSE))
		to_chat(user, span_notice("You take [vended_item] out of the slot."))
		vended_item.do_pickup_animation(user, get_turf(src))
	else
		vended_item.do_drop_animation(src)
		to_chat(user, span_notice("[vended_item] falls onto the floor."))

/// Animation/effects to play while doing a delayed vend. Returns the duration of the animation in deciseconds.
/obj/machinery/vending/proc/vend_delay_animation() as num
	SHOULD_NOT_SLEEP(TRUE)

	if(prob(95))
		return 1.5 SECONDS

	// Sometimes you want to deliberately write stupid code.
	var/pixel_x = src.pixel_x
	var/pixel_y = src.pixel_y
	var/offset_x_1 = pixel_x + pick(-3, -2, -1, 1, 2, 3)
	var/offset_y_1 = pixel_y + pick(-3, -2, -1, 1, 2, 3)

	var/offset_x_2 = pixel_x + pick(-3, -2, -1, 1, 2, 3)
	var/offset_y_2 = pixel_y + pick(-3, -2, -1, 1, 2, 3)

	var/matrix/original_transform = transform
	var/transform_direction_1 = pick(1, -1)
	var/matrix/target_transform_1 = transform.Turn(rand(5, 15) * (transform_direction_1))
	var/matrix/target_transform_2 = transform.Turn(rand(5, 15) * (transform_direction_1 * -1))

	var/transform_total_duration = 0.4 SECONDS
	var/wait_duration = 0.8 SECONDS
	var/shake_out_time_1 = rand(0.2 SECONDS, 0.4 SECONDS)
	var/shake_out_time_2 = rand(0.2 SECONDS, 0.4 SECONDS)

	var/shake_in_time = 0.2 SECONDS

	// Wait takes 0.8 seconds
	spawn(wait_duration)
		if(!is_operational)
			return

		z_animate(src, transform = target_transform_1, time = transform_total_duration * 0.5, flags = ANIMATION_PARALLEL)
		z_animate(src, transform = original_transform, time = transform_total_duration * 0.5, flags = ANIMATION_CONTINUE)

		z_animate(src, pixel_x = offset_x_1, pixel_y = offset_y_1, time = shake_out_time_1, flags = ANIMATION_PARALLEL)
		z_animate(src, pixel_x = pixel_x, pixel_y = pixel_y, time = shake_in_time, flags = ANIMATION_CONTINUE)

		playsound(src, 'sound/weapons/smash.ogg', 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

		spawn(wait_duration)
			if(!is_operational)
				return
			z_animate(src, transform = target_transform_2, transform_total_duration * 0.5, flags = ANIMATION_PARALLEL)
			z_animate(src, transform = original_transform, transform_total_duration * 0.5, flags = ANIMATION_CONTINUE)

			z_animate(src, pixel_x = offset_x_2, pixel_y = offset_y_2, time = shake_out_time_2, flags = ANIMATION_PARALLEL)
			z_animate(src, pixel_x = pixel_x, pixel_y = pixel_y, time = shake_in_time, flags = ANIMATION_CONTINUE)

			playsound(src, 'sound/weapons/smash.ogg', 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	// An extra wait_duration is tacked on intentionally.
	return (transform_total_duration * 2) + (shake_out_time_1 + shake_in_time) + (shake_out_time_2 + shake_in_time) + (wait_duration * 3)

/obj/machinery/vending/process(delta_time)
	if(machine_stat & (BROKEN|NOPOWER))
		return PROCESS_KILL
	if(!active)
		return

	if(seconds_electrified > MACHINE_NOT_ELECTRIFIED)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(last_slogan + slogan_delay <= world.time && slogan_list.len > 0 && !shut_up && DT_PROB(2.5, delta_time))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && DT_PROB(shoot_inventory_chance, delta_time))
		throw_item()

/// Pay for the fuckin' item. Returns -1 if the item was unable to be purchased. Otherwise, returns the amount of money spent.
/obj/machinery/vending/proc/pay_for_vend(mob/vendor, datum/data/vending_product/vend_datum)
	var/obj/item/card/id/C = astype(vendor, /mob/living)?.get_idcard(TRUE)
	var/datum/bank_account/account = C?.registered_account
	var/price_to_use = vend_datum.custom_price || default_price
	var/deduct_cash = 0
	var/deduct_card = 0

	// Calculate price.
	if(LAZYLEN(vend_datum.returned_products))
		price_to_use = 0 //returned items are free
	else
		if(C && (length(C.access & req_access) || (discount_access in C.access)) && !(vend_datum in premium))
			price_to_use = round(price_to_use * VENDING_DISCOUNT)

		if(coin_records.Find(vend_datum) || hidden_records.Find(vend_datum))
			price_to_use = vend_datum.custom_premium_price ? vend_datum.custom_premium_price : extra_price

	// It's free, record and return.
	if(!price_to_use)
		if(account)
			SSeconomy.track_purchase(account, price_to_use, name)
		log_econ("[key_name(vendor)] paid [price_to_use] marks to purchase [vend_datum].")
		return 0

	deduct_cash = min(contained_cash?.amount || 0, price_to_use)
	if(deduct_cash < price_to_use)
		if(!C)
			speak("Insufficient funds.")
			z_flick(icon_deny,src)
			return -1

		else if (!C.registered_account)
			speak("No account found.")
			z_flick(icon_deny,src)
			return -1

		deduct_card = price_to_use - deduct_cash
		if(!account.has_money(deduct_card))
			speak("Insufficient funds.")
			z_flick(icon_deny,src)
			return -1

	if(deduct_cash + deduct_card < price_to_use)
		speak("Insufficient funds.")
		z_flick(icon_deny,src)
		return -1

	// Deduct money from payment sources.
	contained_cash?.use(deduct_cash)
	account?.adjust_money(-deduct_card)

	// Pay out to owning account, and log to audit log.
	var/datum/bank_account/owning_account = SSeconomy.department_accounts_by_id[payment_department]
	if(owning_account)
		owning_account.adjust_money(price_to_use)
		if(account)
			SSeconomy.track_purchase(account, price_to_use, name)

	// Log to administrator logs.
	log_econ("[key_name(vendor)] paid [price_to_use] marks to purchase [vend_datum].")
	SSblackbox.record_feedback("amount", "vending_spent", price_to_use)
	return price_to_use

/**
 * Speak the given message verbally
 *
 * Checks if the machine is powered and the message exists
 *
 * Arguments:
 * * message - the message to speak
 */
/obj/machinery/vending/proc/speak(message)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(!message)
		return

	say(message)

/obj/machinery/vending/power_change()
	. = ..()
	if(powered())
		START_PROCESSING(SSmachines, src)

//Somebody cut an important wire and now we're following a new definition of "pitch."
/**
 * Throw an item from our internal inventory out in front of us
 *
 * This is called when we are hacked, it selects a random product from the records that has an amount > 0
 * This item is then created and tossed out in front of us with a visible message
 */
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return FALSE

	for(var/datum/data/vending_product/R in shuffle(product_records))
		if(R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if(!dump_path)
			continue
		if(R.amount > LAZYLEN(R.returned_products)) //always throw new stuff that costs before free returned stuff, because of the hacking effort and time between throws involved
			throw_item = new dump_path(loc)
		else
			throw_item = LAZYACCESS(R.returned_products, LAZYLEN(R.returned_products)) //first in, last out
			throw_item.forceMove(loc)
			LAZYREMOVE(R.returned_products, throw_item)
		R.amount--
		break
	if(!throw_item)
		return FALSE

	pre_throw(throw_item)

	throw_item.throw_at(target, 16, 3)
	visible_message(span_danger("[src] launches [throw_item] at [target]."))
	return TRUE
/**
 * A callback called before an item is tossed out
 *
 * Override this if you need to do any special case handling
 *
 * Arguments:
 * * I - obj/item being thrown
 */
/obj/machinery/vending/proc/pre_throw(obj/item/I)
	return
/**
 * Shock the passed in user
 *
 * This checks we have power and that the passed in prob is passed, then generates some sparks
 * and calls electrocute_mob on the user
 *
 * Arguments:
 * * user - the user to shock
 * * prb - probability the shock happens
 */
/obj/machinery/vending/proc/shock(mob/living/user, prb)
	if(!istype(user) || machine_stat & (BROKEN|NOPOWER)) // unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE
	do_sparks(5, TRUE, src)
	var/check_range = TRUE
	if(electrocute_mob(user, get_area(src), src, 0.7, check_range))
		return TRUE
	else
		return FALSE
/**
 * Are we able to load the item passed in
 *
 * Arguments:
 * * I - the item being loaded
 * * user - the user doing the loading
 */
/obj/machinery/vending/proc/canLoadItem(obj/item/I, mob/user)
	if((I.type in products) || (I.type in premium) || (I.type in contraband))
		return TRUE
	to_chat(user, span_warning("[src] does not accept [I]!"))
	return FALSE

/obj/machinery/vending/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	var/mob/living/L = AM
	if(tilted || !istype(L) || !prob(20 * (throwingdatum.speed - L.throw_speed))) // hulk throw = +20%, neckgrab throw = +20%
		return

	tilt(L)


/// Called when contained_cash moves.
/obj/machinery/vending/proc/on_cash_moved(datum/source)
	SIGNAL_HANDLER

	set_contained_cash(null)

/obj/machinery/vending/attack_tk_grab(mob/user)
	to_chat(user, span_warning("[src] seems to resist your mental grasp!"))

///Crush the mob that the vending machine got thrown at
/obj/machinery/vending/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		tilt(fatty=hit_atom)
	return ..()

/obj/item/price_tagger
	name = "price tagger"
	desc = "This tool is used to set a price for items used in custom vendors."
	icon = 'icons/obj/device.dmi'
	icon_state = "pricetagger"
	custom_premium_price = PAYCHECK_ASSISTANT * 0.5
	///the price of the item
	var/price = 1

/obj/item/price_tagger/attack_self(mob/user)
	if(loc != user)
		to_chat(user, span_warning("You must be holding the price tagger to continue!"))
		return
	var/chosen_price = tgui_input_number(user, "Set price", "Price", price)
	if(!chosen_price || QDELETED(user) || QDELETED(src) || !user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK) || loc != user)
		return
	price = chosen_price
	to_chat(user, span_notice(" The [src] will now give things a [price] FM tag."))

/obj/item/price_tagger/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isitem(interacting_with))
		var/obj/item/I = interacting_with
		I.custom_price = price
		to_chat(user, span_notice("You set the price of [I] to [price] FM."))
		return ITEM_INTERACT_SUCCESS

