/obj/item/stack/spacecash  //Don't use base space cash stacks. Any other space cash stack can merge with them, and could cause potential money duping exploits.
	name = "wad of space cash"
	singular_name = "space cash bill"

	stack_name = "wad"
	multiple_gender = NEUTER

	abstract_type = /obj/item/stack/spacecash

	icon = 'icons/obj/economy.dmi'
	icon_state = null
	amount = 1
	max_amount = 500
	throwforce = 0
	throw_speed = 0.7
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 10)

	dynamically_set_name = TRUE

	/// How much money one "amount" of this is worth. Use get_item_credit_value().
	VAR_PROTECTED/value = 0

/obj/item/stack/spacecash/update_desc()
	. = ..()
	if(amount == 1)
		desc = "It is worth [value]."
	else
		desc = "There are [amount] bills each worth [value]."

/obj/item/stack/spacecash/get_item_credit_value()
	return (amount*value)

/// Like use(), but for financial amounts. use_cash(20) on a stack of 10s will use 2. use_cash(22) on a stack of 10s will use 3.
/obj/item/stack/spacecash/proc/use_cash(value_to_pay)
	var/amt = ceil(value_to_pay / value)
	return use(amt)

/obj/item/stack/spacecash/update_icon_state()
	. = ..()
	switch(amount)
		if(1)
			icon_state = initial(icon_state)
		if(2 to 9)
			icon_state = "[initial(icon_state)]_2"
		if(10 to 24)
			icon_state = "[initial(icon_state)]_3"
		if(25 to INFINITY)
			icon_state = "[initial(icon_state)]_4"

/obj/item/stack/spacecash/c1
	icon_state = "spacecash1"
	singular_name = "one credit bill"
	value = 1
	merge_type = /obj/item/stack/spacecash/c1

/obj/item/stack/spacecash/c1/ten
	amount = 10

/obj/item/stack/spacecash/c1/twenty
	amount = 20

/obj/item/stack/spacecash/c100
	icon_state = "spacecash100"
	singular_name = "one hundred credit bill"
	value = 100
	merge_type = /obj/item/stack/spacecash/c100

/obj/item/stack/spacecash/c1000
	icon_state = "spacecash1000"
	singular_name = "one thousand credit bill"
	value = 1000
	merge_type = /obj/item/stack/spacecash/c1000

/obj/item/stack/spacecash/c1000/ten
	amount = 10
