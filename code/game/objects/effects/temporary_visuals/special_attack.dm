/obj/effect/temp_visual/special_attack
	icon = 'goon/icons/items/meleeeffects.dmi'
	icon_state = ""
	pixel_x = -32
	pixel_y = -32

	duration = 3 SECONDS

/obj/effect/temp_visual/special_attack/Initialize(mapload)
	. = ..()
	flick(icon_state, src)

/obj/effect/temp_visual/special_attack/swipe
	icon_state = "sabre"

/obj/effect/temp_visual/special_attack/stab
	icon_state = "dagger"
