/obj/machinery/atm
	name = "automated teller machine"
	desc = "An age-old technology for managing one's wealth."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	base_icon_state = "atm"

	layer = ABOVE_OBJ_LAYER + 0.001
	pixel_y = 32
	base_pixel_y = 32

	resistance_flags = INDESTRUCTIBLE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1

	/// The bank account being interfaced
	var/datum/bank_account/authenticated_account
	/// The card that is currently inserted
	var/obj/item/card/id/inserted_card

	/// Particle system for EMAGging
	var/datum/effect_system/spark_spread/spark_system

	var/entered_pin
	var/reject_topic = FALSE

/obj/machinery/atm/Initialize(mapload)
	. = ..()
	var/static/count = 1
	name = "[station_name()] A.T.M #[count]"
	count++

	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/Destroy()
	QDEL_NULL(inserted_card)
	authenticated_account = null
	QDEL_NULL(spark_system)
	return ..()

/obj/machinery/atm/examine(mob/user)
	. = ..()
	if(inserted_card)
		. += span_notice("There is a card in the card slot.")

/obj/machinery/atm/update_icon_state()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]_off"
	else
		icon_state = base_icon_state

	return ..()

/obj/machinery/atm/process()
	if(machine_stat & NOPOWER)
		return

	use_power(IDLE_POWER_USE)

/obj/machinery/atm/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("This machine has already been hacked."))
		return

	obj_flags |= EMAGGED
	spark_system.start()
	dispense_cash(rand(20, 200))

/obj/machinery/atm/attackby(obj/item/I, mob/user, params)
	if(!isidcard(I) && !iscash(I))
		return ..()

	if(machine_stat & NOPOWER)
		to_chat(user, span_warning("You attempt to insert [I] into [src], but nothing happens."))
		return TRUE

	if(isidcard(I))
		if(inserted_card)
			to_chat(user, span_warning("You attempt to insert [I] into [src], but there's already something in the slot."))
			return TRUE
		if(!user.transferItemToLoc(I, src))
			return TRUE

		inserted_card = I
		updateUsrDialog()
		playsound(loc, 'sound/machines/cardreader_insert.ogg', 50)
		to_chat(user, span_notice("You insert [I] into [src]."))
		return TRUE

	if(iscash(I))
		if(!authenticated_account)
			to_chat(user, span_warning("You attempt to insert [I] into [src], but nothing happens."))
			return TRUE

		if(!user.transferItemToLoc(I, src))
			return TRUE

		var/value = I.get_item_credit_value()
		qdel(I)
		authenticated_account.adjust_money(value)

		to_chat(user, span_notice("You deposit [value] into [src]."))
		updateUsrDialog()
		playsound(loc, 'sound/machines/cash_insert.ogg', 50)
		return TRUE

/// Dispense the given amount of cash and give feedback.
/obj/machinery/atm/proc/dispense_cash(amt)
	if(!amt)
		return

	playsound(loc, 'sound/machines/cash_desert.ogg', 50)
	reject_topic = TRUE
	sleep(1 SECONDS)
	reject_topic = FALSE
	visible_message(span_notice("[src] dispenses a wad of money."), vision_distance = COMBAT_MESSAGE_RANGE)

	SSeconomy.spawn_ones_for_amount(amt, drop_location())

/obj/machinery/atm/proc/try_authenticate(pin)
	if((machine_stat & NOPOWER) || !inserted_card?.registered_account)
		return FALSE

	if(inserted_card.registered_account.account_pin != pin)
		return FALSE

	authenticated_account = inserted_card.registered_account
	return TRUE

/obj/machinery/atm/ui_interact(mob/user, datum/tgui/ui)
	var/datum/browser/popup = new(user, "atm", name, 460, 270)
	popup.set_content(jointext(get_content(), ""))
	popup.open()

/obj/machinery/atm/Topic(href, href_list)
	. = ..()
	if(. || reject_topic)
		return

	if(href_list["eject_id"])
		if(isnull(inserted_card))
			return TRUE
		if(!usr.put_in_hands(inserted_card))
			inserted_card.forceMove(drop_location())
		inserted_card = null
		playsound(loc, 'sound/machines/cardreader_desert.ogg', 50)
		updateUsrDialog()
		return TRUE

	if(href_list["enter_pin"])
		open_pinpad_ui(usr)
		return TRUE

	if(href_list["type"])
		var/key = href_list["type"]
		switch(key)
			if("E")
				if(try_authenticate(entered_pin))
					entered_pin = ""
					playsound(loc, 'sound/machines/cardreader_read.ogg', 50)
					updateUsrDialog()
					sleep(world.tick_lag)
					usr << browse(null, "window=atm-pinpad")
				else
					entered_pin = "ERROR"
					open_pinpad_ui(usr)

			if("C")
				entered_pin = ""
				open_pinpad_ui(usr)

			else
				if(!sanitize_text(key))
					return TRUE
				if(length(entered_pin) >= 5)
					return TRUE

				entered_pin = "[entered_pin][key]"
				open_pinpad_ui(usr)

		return TRUE

	if(href_list["logout"])
		authenticated_account = null
		updateUsrDialog()
		return TRUE

	if(href_list["withdraw"])
		var/amt = tgui_input_number(usr, "Enter amount (1-100)", "Withdraw", 0, 100, 0)
		if(!amt)
			return TRUE

		amt = min(amt, authenticated_account.account_balance)
		authenticated_account.adjust_money(-amt)
		dispense_cash(amt)
		updateUsrDialog()
		return TRUE

/obj/machinery/atm/proc/get_content()
	PRIVATE_PROC(TRUE)
	. = list()
	. += "<div style='width:100%;height: 100%'>"
	. += "<fieldset class='computerPane' style='height: 100%'>"
	. += {"
		<legend class='computerLegend'>
			<b>Automated Teller Machine</b>
		</legend>
	"}

	. += "<div class='computerLegend' style='margin: auto; width:70%; height: 70px'>"
	if(authenticated_account)
		. += {"
				Welcome, <b>[authenticated_account.account_holder]</b>.<br><br>
				Your balance is: <b>[authenticated_account.account_balance]</b>
		"}

	. += "</div>"
	. += jointext(buttons(), "")
	. += "</fieldset>"
	. += "</div>"

/obj/machinery/atm/proc/buttons()
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	. = list()

	. += "<div style = 'text-align: center'>[button_element(src, "Eject Card", "eject_id=1")]</div>"

	if(!authenticated_account)
		. += "<div style = 'text-align: center'>[button_element(src, "Enter PIN", "enter_pin=1")]</div><br>"
	else
		. += "<div style = 'text-align: center'>[button_element(src, "Withdraw", "withdraw=1")]</div>"
		. += "<div style = 'text-align: center'>[button_element(src, "Logout", "logout=1")]</div>"

/obj/machinery/atm/proc/open_pinpad_ui(mob/user)
	PRIVATE_PROC(TRUE)
	var/datum/browser/popup = new(user, "atm-pinpad", "Enter Pin", 300, 280)
	var/dat = "<TT><B>[src]</B><BR>\n\n"
	dat += {"
<HR>\n>[entered_pin]<BR>\n<A href='?src=[REF(src)];type=1'>1</A>
-<A href='?src=[REF(src)];type=2'>2</A>
-<A href='?src=[REF(src)];type=3'>3</A><BR>\n
<A href='?src=[REF(src)];type=4'>4</A>
-<A href='?src=[REF(src)];type=5'>5</A>
-<A href='?src=[REF(src)];type=6'>6</A><BR>\n
<A href='?src=[REF(src)];type=7'>7</A>
-<A href='?src=[REF(src)];type=8'>8</A>
-<A href='?src=[REF(src)];type=9'>9</A><BR>\n
<A href='?src=[REF(src)];type=C'>C</A>
-<A href='?src=[REF(src)];type=0'>0</A>
-<A href='?src=[REF(src)];type=E'>E</A><BR>\n</TT>"}

	popup.set_content(dat)
	popup.open()
