/atom/movable/screen/guardian
	icon = 'icons/hud/guardian.dmi'

/atom/movable/screen/guardian/manifest
	icon_state = "manifest"
	name = "Manifest"
	desc = "Spring forth into battle!"

/atom/movable/screen/guardian/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	screen_loc = ui_hand_position(2)

/atom/movable/screen/guardian/manifest/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/simple_animal/hostile/guardian/G = hud.mymob
	G.Manifest()


/atom/movable/screen/guardian/recall
	icon_state = "recall"
	name = "Recall"
	desc = "Return to your user."

/atom/movable/screen/guardian/recall/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	screen_loc = ui_hand_position(1)

/atom/movable/screen/guardian/recall/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/living/simple_animal/hostile/guardian/G = hud.mymob
	G.Recall()

/atom/movable/screen/guardian/toggle_mode
	icon_state = "toggle"
	name = "Toggle Mode"
	desc = "Switch between ability modes."

/atom/movable/screen/guardian/toggle_mode/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/simple_animal/hostile/guardian/G = hud.mymob
	G.ToggleMode()

/atom/movable/screen/guardian/toggle_mode/inactive
	icon_state = "notoggle" //greyed out so it doesn't look like it'll work

/atom/movable/screen/guardian/toggle_mode/assassin
	icon_state = "stealth"
	name = "Toggle Stealth"
	desc = "Enter or exit stealth."

/atom/movable/screen/guardian/communicate
	icon_state = "communicate"
	name = "Communicate"
	desc = "Communicate telepathically with your user."
	screen_loc = ui_back

/atom/movable/screen/guardian/communicate/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/living/simple_animal/hostile/guardian/G = hud.mymob
	G.Communicate()


/atom/movable/screen/guardian/toggle_light
	icon_state = "light"
	name = "Toggle Light"
	desc = "Glow like star dust."
	screen_loc = ui_inventory

/atom/movable/screen/guardian/toggle_light/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/simple_animal/hostile/guardian/G = hud.mymob
	G.ToggleLight()
