/obj/item/aether_tome
	name = "\improper Biblion tou Hema"
	desc = "An old, worn-out book with a peculiar symbol embossed with a strange symbol. The cover reads \"Ho Biblion tou Hema\"."
	icon = 'goon/icons/obj/kinginyellow.dmi'
	icon_state = "bookkiy"

	actions_types = list(
		/datum/action/cooldown/spell/touch/showstopper,
		/datum/action/cooldown/spell/vanishing_act,
	)

/obj/item/aether_tome/examine(mob/user)
	. = ..()

	var/datum/roll_result/result = user.get_examine_result("aether_tome", trait_succeed = TRAIT_AETHERITE)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		. += result.create_tooltip("Biblion tou Hema. The Book of Blood. The Augur is awfully protective of it.", body_only = TRUE)
