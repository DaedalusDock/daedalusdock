//DR2 TOOLS

/obj/item/crowbar/crude
	name = "crude crowbar"
	desc = "A flattened piece of rusted pipe, barely enough to squeeze under most things, but helps get a firm grip."
	icon_state = "crudebar"
	toolspeed = 6

/obj/item/crowbar/basic
	name = "basic crowbar"
	desc = "A flattened and reinforced piece of rebar, bent a to a firm point and pretty flat."
	icon_state = "basicbar"
	toolspeed = 2

/obj/item/crowbar/hightech
	name = "advanced prying device"
	desc = "A mechanically assited prying device, capable of dislodging basically anything."
	icon_state = "advancedbar"
	inhand_icon_state  = "crowbaradvance"
	usesound = 'sound/items/jaws_pry.ogg'
	toolspeed = 0.1

/obj/item/screwdriver/crude
	name = "crude screwdriver"
	desc = "A piece of junk metal sharpened to a point, worthwile as a shiv or crude turning device."
	icon_state = "crudescrew"
	inhand_icon_state  = "crudescrew"
	toolspeed = 6
	random_color = FALSE

/obj/item/screwdriver/basic
	name = "basic screwdriver"
	desc = "A refined tip of a jerry-rigged screwdriver, pretty accurate."
	icon_state = "basicscrew"
	inhand_icon_state  = "basicscrew"
	toolspeed = 2
	random_color = FALSE

/obj/item/screwdriver/hightech
	name = "advanced drill"
	desc = "An extremely precise micro-mechanised saturnite drill, capable of infinite force and pressure."
	icon_state = "advancedscrew"
	inhand_icon_state  = "advancedscrew"
	usesound = 'sound/items/pshoom.ogg'
	toolspeed = 0.1
	random_color = FALSE

/obj/item/weldingtool/crude
	name = "crude flaming tool"
	desc = "A god-awful construction of rusted junk, a blood bag and spirit, salvaged and robust, extremely useless and slow, but EVENTUALLY, it might burn something."
	icon_state = "crudeweld"
	inhand_icon_state  = "crudeweld"
	toolspeed = 10

/obj/item/weldingtool/basic
	name = "basic welding tool"
	desc = "A roughly crafted together welding tool, not perfect but it works."
	icon_state = "basicweld"
	inhand_icon_state  = "basicweld"
	toolspeed = 2

/obj/item/weldingtool/hightech
	name = "advanced welding tool"
	desc = "A high-tech Quantum heated flamer tool, capable of infinitely replenishing itself using Quantum energy."
	icon_state = "advancedweld"
	inhand_icon_state  = "advancedweld"
	light_outer_range = 1
	toolspeed = 0.1
	var/nextrefueltick = 0

/obj/item/weldingtool/hightech/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)

/obj/item/wirecutters/crude
	name = "crude cutters"
	desc = "Literally just a piece of bent and scraped junk metal, enough to cut something, but extremly unwieldly and worthless. Mainly just ripping with weight behind it."
	icon_state = "crudewire"
	toolspeed = 6
	random_color = FALSE

/obj/item/wirecutters/basic
	name = "basic cutters"
	desc = "Almost sharpened cutters, maded of sharpened rusted metal and multiple parts."
	icon_state = "basicwire"
	toolspeed = 2
	random_color = FALSE

/obj/item/wirecutters/hightech
	name = "advanced snapping device"
	desc = "A mechanically assisted snapping device, capable of cutting anything."
	icon_state = "advancedwire"
	toolspeed = 0.1
	sharpness = SHARP_EDGED
	random_color = FALSE

/obj/item/wrench/crude
	name = "crude wrench"
	desc = "A bent bar, finnicky to use and requires a lot of effort for consant adjustments, better than your bare hand though."
	icon_state = "crudewrench"
	toolspeed = 6

/obj/item/wrench/basic
	name = "basic wrench"
	desc = "A pipe with an old, wrench head on it."
	icon_state = "basicwrench"
	toolspeed = 2

/obj/item/wrench/hightech
	name = "advanced locking device"
	desc = "An advanced locking device that uses micro-mechanisms to grasp on and tighten objects with extreme torque accuracy and speed."
	icon_state = "advancedwrench"
	toolspeed = 0.1
