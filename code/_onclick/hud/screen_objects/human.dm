/atom/movable/screen/human
	icon = 'icons/hud/screen_midnight.dmi'

/atom/movable/screen/human/toggle
	name = "toggle"
	icon_state = "toggle"
	screen_loc = ui_inventory
	private_screen = FALSE // We handle cases where usr != owner.

/atom/movable/screen/human/toggle/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.screen_groups[HUDGROUP_TOGGLEABLE_INVENTORY]
	else
		usr.hud_used.inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.screen_groups[HUDGROUP_TOGGLEABLE_INVENTORY]

	targetmob.hud_used.hidden_inventory_update(usr)

/atom/movable/screen/human/equip
	name = "equip"
	icon_state = "act_equip"

/atom/movable/screen/human/equip/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(hud_owner)
		screen_loc = ui_equip_position(hud_owner.mymob)

/atom/movable/screen/human/equip/Click()
	. = ..()
	if(.)
		return FALSE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE

	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/atom/movable/screen/ling
	icon = 'icons/hud/screen_changeling.dmi'

/atom/movable/screen/ling/chems
	name = "chemical storage"
	icon_state = "power_display"
	screen_loc = ui_lingchemdisplay

/atom/movable/screen/ling/sting
	name = "current sting"
	screen_loc = ui_lingstingdisplay
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/ling/sting/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/carbon/carbon_user = hud.mymob
	carbon_user.unset_sting()
