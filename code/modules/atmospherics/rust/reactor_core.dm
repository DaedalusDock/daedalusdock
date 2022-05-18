#define MAX_FIELD_STR 10000
#define MIN_FIELD_STR 1

/obj/machinery/reactor_core
	name = "\improper R-UST Mk. 10 Tokamak Reactor"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields."
	icon = 'icons/obj/machines/rust/fusion_core.dmi'
	icon_state = "core0"
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 1000 //multiplied by field strength
	anchored = FALSE

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
