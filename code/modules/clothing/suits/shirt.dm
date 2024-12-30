/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	inhand_icon_state = "ianshirt"

	equip_delay_self = EQUIP_DELAY_UNDERSUIT
	equip_delay_other = EQUIP_DELAY_UNDERSUIT * 1.5
	strip_delay = EQUIP_DELAY_UNDERSUIT * 1.5

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION
	///How many times has this shirt been washed? (In an ideal world this is just the determinant of the transform matrix.)
	var/wash_count = 0

/obj/item/clothing/suit/ianshirt/machine_wash(obj/machinery/washing_machine/washer)
	. = ..()
	if(wash_count <= 5)
		transform *= TRANSFORM_USING_VARIABLE(0.8, 1)
		washer.visible_message("[src] appears to have shrunken after being washed.")
		wash_count += 1
	else
		washer.visible_message("[src] implodes due to repeated washing.")
		qdel(src)

/obj/item/clothing/suit/nerdshirt
	name = "gamer shirt"
	desc = "A baggy shirt with vintage game character Phanic the Weasel. Why would anyone wear this?"
	icon_state = "nerdshirt"
	inhand_icon_state = "nerdshirt"

