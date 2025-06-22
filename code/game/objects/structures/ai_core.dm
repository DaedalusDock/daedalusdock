/obj/structure/ai_core
	name = "\improper AI core"
	icon = 'goon/icons/obj/96x96.dmi'
	icon_state = "oldai-01"
	desc = "The framework for an artificial intelligence core."

	pixel_x = -32
	pixel_y = -32

	max_integrity = 500
	density = TRUE
	anchored = TRUE

	var/datum/ai_laws/laws
	var/obj/item/circuitboard/aicore/circuit
	var/obj/item/mmi/brain

/obj/structure/ai_core/Initialize(mapload)
	. = ..()
	SET_TRACKING(__TYPE__)
	laws = new
	laws.set_laws_config()
	update_appearance()

/obj/structure/ai_core/Destroy()
	UNSET_TRACKING(__TYPE__)
	return ..()

/obj/structure/ai_core/handle_atom_del(atom/A)
	if(A == circuit)
		circuit = null
		update_appearance()
	if(A == brain)
		brain = null
	return ..()

/obj/structure/ai_core/update_overlays()
	. = ..()
	. += image(icon, "oldai-face_neutral")
	. += emissive_appearance(icon, "oldai-face_neutral", alpha = 70)
	. += image(icon, "oldai-faceoverlay")
	. += emissive_appearance(icon, "oldai-faceoverlay", alpha = 70)

	var/image/light = image(icon, "oldai-light")
	light.plane = ABOVE_LIGHTING_PLANE
	. += light

/obj/structure/ai_core/Destroy()
	QDEL_NULL(circuit)
	QDEL_NULL(brain)
	QDEL_NULL(laws)
	return ..()

/obj/structure/ai_core/deactivated
	name = "inactive AI"
	icon_state = "ai-empty"
	anchored = TRUE

/obj/structure/ai_core/deactivated/Initialize(mapload)
	. = ..()
	circuit = new(src)

/obj/structure/ai_core/latejoin_inactive
	name = "networked AI core"
	desc = "This AI core is connected by bluespace transmitters to NTNet, allowing for an AI personality to be downloaded to it on the fly mid-shift."
	icon_state = "oldai-01"
	anchored = TRUE

	var/available = TRUE

/obj/structure/ai_core/latejoin_inactive/Initialize(mapload)
	. = ..()
	circuit = new(src)
	GLOB.latejoin_ai_cores += src

/obj/structure/ai_core/latejoin_inactive/Destroy()
	GLOB.latejoin_ai_cores -= src
	return ..()

/obj/structure/ai_core/latejoin_inactive/proc/is_available() //If people still manage to use this feature to spawn-kill AI latejoins ahelp them.
	if(!available)
		return FALSE

	var/turf/T = get_turf(src)
	var/area/A = get_area(src)

	if(!(A.area_flags & BLOBS_ALLOWED))
		return FALSE
	if(!A.power_equip)
		return FALSE
	if(!SSmapping.level_trait(T.z,ZTRAIT_STATION))
		return FALSE
	if(!istype(T, /turf/open/floor))
		return FALSE
	return TRUE

/obj/item/circuitboard/aicore
	name = "AI core (AI Core Board)" //Well, duh, but best to be consistent
	var/battery = 200 //backup battery for when the AI loses power. Copied to/from AI mobs when carding, and placed here to avoid recharge via deconning the core

/*
This is a good place for AI-related object verbs so I'm sticking it here.
If adding stuff to this, don't forget that an AI need to cancel_camera() whenever it physically moves to a different location.
That prevents a few funky behaviors.
*/
//The type of interaction, the player performing the operation, the AI itself, and the card object, if any.


/atom/proc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI)
	return TRUE

/obj/structure/ai_core/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI)
	. = ..()
	if(!.)
		return FALSE

	AI.control_disabled = FALSE
	AI.radio_enabled = TRUE
	AI.forceMove(loc) // to replace the terminal.
	to_chat(AI, span_notice("You have been uploaded to a stationary terminal. Remote device connection restored."))
	to_chat(user, "[span_boldnotice("Transfer successful")]: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
	AI.battery = circuit.battery
	qdel(src)
