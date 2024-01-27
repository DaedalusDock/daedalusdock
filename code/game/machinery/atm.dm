/obj/machinery/atm
	name = "automated teller machine"
	desc = "I LIKE MONEY"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	base_icon_state = "atm"

	resistance_flags = INDESTRUCTIBLE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1

	/// The bank account being interfaced
	var/datum/bank_account/authenticated_account
	/// The card that is currently inserted
	var/obj/item/card/id/inserted_card

	/// Particle system for EMAGging
	var/datum/effect_system/spark_spread/spark_system

	var/entered_pin

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
	. = ..()
	if(.)
		return

	if(!isidcard(I))
		return

	if(machine_stat & NOPOWER)
		to_chat(user, span_warning("You attempt to insert [I] into [src], but nothing happens."))
		return TRUE

	if(!user.transferItemToLoc(I, src))
		return TRUE

	inserted_card = I
	updateUsrDialog()
	to_chat(user, span_notice("You insert [I] into [src]."))
	return TRUE

/// Dispense the given amount of cash and give feedback.
/obj/machinery/atm/proc/dispense_cash(amt)
	if(!amt)
		return

	playsound(src, 'sound/machines/ping.ogg')
	visible_message(span_notice("[src] dispenses a wad of money."), vision_distance = COMBAT_MESSAGE_RANGE)

	SSeconomy.spawn_cash_for_amount(rand(20, 200), drop_location())

/obj/machinery/atm/proc/try_authenticate(pin)
	if((machine_stat & NOPOWER) || !inserted_card?.registered_account)
		return FALSE

	if(inserted_card.registered_account.account_pin != pin)
		return FALSE

	authenticated_account = inserted_card.registered_account
	return TRUE

/obj/machinery/atm/ui_interact(mob/user, datum/tgui/ui)
	var/datum/browser/popup = new(user, "atm", name, 460, 550)
	popup.set_content(jointext(get_content(), ""))
	popup.open()

/obj/machinery/atm/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["eject_id"])
		inserted_card.forceMove(drop_location())
		inserted_card = null
		playsound(src, 'sound/machines/terminal_eject.ogg')
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
					usr << browse(null, "window=atm-pinpad")
					updateUsrDialog()
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

/obj/machinery/atm/proc/get_content()
	. = list()
	. += "<div style='width:100%'>"
	. += "<fieldset class='computerPane'>"
	. += button_element(src, "Enter PIN", "enter_pin=1")
	. += "</fieldset>"
	. += "</div>"

/obj/machinery/atm/proc/open_pinpad_ui(mob/user)
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
