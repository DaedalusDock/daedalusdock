/obj/machinery/computer/cargo/express/government
	name = "government supply console"

	stationcargo = FALSE
	podType = /obj/structure/closet/supplypod/safe
	cargo_account = ACCOUNT_GOV

	can_use_without_beacon = FALSE

/obj/machinery/computer/cargo/express/government/get_buyable_supply_packs()
	. = list()
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack]
		if(!can_purchase_pack(P))
			continue

		if(!.[P.group])
			.[P.group] = list(
				"name" = P.group,
				"packs" = list()
			)

		.[P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name,
			"goody" = P.goody,
			"access" = P.access
		))

	sortTim(., GLOBAL_PROC_REF(cmp_text_asc))

/obj/machinery/computer/cargo/express/government/can_purchase_pack(datum/supply_pack/pack)
	return pack.supply_flags & SUPPLY_PACK_GOVERNMENT

/obj/machinery/computer/cargo/express/government/emag_act(mob/living/user)
	return
