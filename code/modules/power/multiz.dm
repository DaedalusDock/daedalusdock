/obj/structure/cable/multiz //This bridges powernets betwen Z levels
	name = "multi z layer cable hub"
	desc = "A flexible, superconducting insulated multi Z layer hub for heavy-duty multi Z power transfer."
	icon = 'icons/obj/power.dmi'
	icon_state = "cablerelay-on"
	linked_dirs = CABLE_NORTH|CABLE_SOUTH|CABLE_EAST|CABLE_WEST

/obj/structure/cable/multiz/Initialize(mapload)
	. = ..()
	set_multiz_linked_dirs()

/obj/structure/cable/multiz/set_directions(new_directions)
	set_multiz_linked_dirs()

/obj/structure/cable/multiz/proc/set_multiz_linked_dirs()
	linked_dirs = CABLE_NORTH|CABLE_SOUTH|CABLE_EAST|CABLE_WEST

/obj/structure/cable/multiz/is_knotted()
	return FALSE

/obj/structure/cable/multiz/amount_of_cables_worth()
	return 1

/obj/structure/cable/multiz/update_icon_state()
	. = ..()
	icon_state = "cablerelay-on"

/obj/structure/cable/multiz/get_cable_connections(powernetless_only)
	. = ..()
	var/turf/T = get_turf(src)
	. += locate(/obj/structure/cable/multiz) in (GetBelow(T))
	. += locate(/obj/structure/cable/multiz) in (GetAbove(T))

/obj/structure/cable/multiz/examine(mob/user)
	. += ..()
	var/turf/T = get_turf(src)
	. += span_notice("[locate(/obj/structure/cable/multiz) in (GetBelow(T)) ? "Detected" : "Undetected"] hub UP.")
	. += span_notice("[locate(/obj/structure/cable/multiz) in (GetAbove(T)) ? "Detected" : "Undetected"] hub DOWN.")
