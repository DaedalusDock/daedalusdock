/datum/supply_pack
	var/name = "Crate"
	var/group = ""

	// See cargo.dm
	var/supply_flags = NONE

	/// Cost of the crate. DO NOT GO ANY LOWER THAN X1.4 the "CARGO_CRATE_VALUE" value if using regular crates, or infinite profit will be possible!
	var/cost = CARGO_CRATE_VALUE * 1.4
	var/access = FALSE
	var/access_view = FALSE
	var/access_any = FALSE

	var/list/contains = null
	var/crate_name = "crate"
	var/id
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate

	/// If TRUE, can spawn with missing contents due to MANIFEST_ERROR_ITEM occuring.
	var/can_be_missing_contents = TRUE
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE

	/// If TRUE, will pick random_pick_amount items from the contains list instead of including all of them.
	var/randomized = FALSE
	var/random_pick_amount = 1

	var/special_pod //If this pack comes shipped in a specific pod when launched from the express console
	var/admin_spawned = FALSE

	var/goody = FALSE //Goodies can only be purchased by private accounts and can have coupons apply to them. They also come in a lockbox instead of a full crate, so the 700 min doesn't apply

/datum/supply_pack/New()
	id = type

/datum/supply_pack/proc/generate(atom/A, datum/bank_account/paying_account)
	var/obj/structure/closet/crate/C
	if(paying_account)
		C = new /obj/structure/closet/crate/secure/owned(A, paying_account)
		C.name = "[crate_name] - Purchased by [paying_account.account_holder]"
	else
		C = new crate_type(A)
		C.name = crate_name
	if(access)
		C.req_access = list(access)
	if(access_any)
		C.req_one_access = access_any

	fill(C)
	return C

/datum/supply_pack/proc/get_cost()
	. = cost
	. *= SSeconomy.pack_price_modifier
	return floor(.)

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if(randomized)
		for(var/i in 1 to random_pick_amount)
			var/path = pick(contains)
			var/atom/A = new path(C)
			if(admin_spawned)
				A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/path in contains)
			var/atom/A = new path(C)
			if(admin_spawned)
				A.flags_1 |= ADMIN_SPAWNED_1

/// For generating supply packs at runtime. Returns a list of supply packs to use instead of this one.
/datum/supply_pack/proc/generate_supply_packs()
	return
