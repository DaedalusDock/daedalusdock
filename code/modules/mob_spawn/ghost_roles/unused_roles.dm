//For ghost bar.
/obj/effect/mob_spawn/ghost_role/human/space_bar_patron
	name = "bar cryogenics"
	uses = INFINITY
	prompt_name = "a space bar patron"
	you_are_text = "You're a patron!"
	flavour_text = "Hang out at the bar and chat with your buddies. Feel free to hop back in the cryogenics when you're done chatting."
	outfit = /datum/outfit/cryobartender
	spawner_job_path = /datum/job/space_bar_patron

/obj/effect/mob_spawn/ghost_role/human/space_bar_patron/attack_hand(mob/user, list/modifiers)
	var/despawn = tgui_alert(usr, "Return to cryosleep? (Warning, Your mob will be deleted!)", null, list("Yes", "No"))
	if(despawn == "No" || !loc || !Adjacent(user))
		return
	user.visible_message(span_notice("[user.name] climbs back into cryosleep..."))
	qdel(user)

/datum/outfit/cryobartender
	name = "Cryogenic Bartender"
	uniform = /obj/item/clothing/under/rank/civilian/bartender
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/armor/vest
	glasses = /obj/item/clothing/glasses/sunglasses/reagent

/obj/effect/mob_spawn/ghost_role/human/nanotrasensoldier
	name = "sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list("nanotrasenprivate")
	prompt_name = "a private security officer"
	you_are_text = "You are a Nanotrasen Private Security Officer!"
	flavour_text = "If higher command has an assignment for you, it's best you follow that. Otherwise, death to The Syndicate."
	outfit = /datum/outfit/nanotrasensoldier

/obj/effect/mob_spawn/ghost_role/human/commander
	name = "sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "a nanotrasen commander"
	you_are_text = "You are a Nanotrasen Commander!"
	flavour_text = "Upper-crusty of Nanotrasen. You should be given the respect you're owed."
	outfit = /datum/outfit/nanotrasencommander
