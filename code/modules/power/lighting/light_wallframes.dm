/obj/item/wallframe/light_fixture
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	result_path = /obj/structure/light_construct
	wall_external = TRUE

TYPEINFO_DEF(/obj/item/wallframe/light_fixture/small)
	default_materials = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)

/obj/item/wallframe/light_fixture/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	result_path = /obj/structure/light_construct/small

/obj/item/wallframe/light_fixture/try_build(turf/on_wall, user)
	if(!..())
		return
	var/area/local_area = get_area(user)
	if(local_area.area_lighting != AREA_LIGHTING_DYNAMIC)
		to_chat(user, span_warning("You cannot place [src] in this area!"))
		return
	return TRUE
