/client/proc/cmd_ic_spawn(mob/user in GLOB.mob_list)
	set name = "IC Spawn"
	set category = "Admin.Events"

	if(isobserver(user) && check_rights(R_SPAWN))
		var/dresscode
		var/teleport_option = alert(usr, "How would you like to be spawned in?", "IC Quick Spawn", "Bluespace", "Pod", "Cancel")
		if (teleport_option == "Cancel")
			return
		var/character_option = alert(usr, "Which character?", "IC Quick Spawn", "Selected Character", "Randomly Created", "Cancel")
		if (character_option == "Cancel")
			return
		var/initial_outfits = alert(usr, "Select outfit", "Quick Dress", "Bluespace Tech", "Show All", "Cancel")
		if (initial_outfits == "Cancel")
			return

		switch(initial_outfits)
			if("Bluespace Tech")
				dresscode = /datum/outfit/debug
			if("Show All")
				dresscode = robust_dress_shop()
				if (!dresscode)
					return

		// We're spawning someone else
		var/give_return
		if (user != usr)
			give_return = alert(usr, "Do you want to give them the power to return? Not recommended for non-admins.", "Give power?", "Yes", "No")
			if(!give_return)
				return


		var/turf/current_turf = get_turf(user)
		var/mob/living/carbon/human/spawned_player = new(user)

		if (character_option == "Selected Character")
			spawned_player.name = user.name
			spawned_player.real_name = user.real_name

			var/mob/living/carbon/human/H = spawned_player
			user.client?.prefs.safe_transfer_prefs_to(H)
			H.dna.update_dna_identity()

		QDEL_IN(user, 1)

		if (teleport_option == "Bluespace")
			playsound(spawned_player, 'sound/magic/Disable_Tech.ogg', 100, 1)

		if(user.mind && isliving(spawned_player))
			user.mind.transfer_to(spawned_player, 1) // second argument to force key move to new mob
		else
			spawned_player.ckey = user.key

		if(give_return != "No")
			spawned_player.mind.AddSpell(new /obj/effect/proc_holder/spell/self/return_back, FALSE)

		if(dresscode != "Naked")
			spawned_player.equipOutfit(dresscode)

		switch(teleport_option)
			if("Bluespace")
				spawned_player.forceMove(current_turf)

				var/datum/effect_system/spark_spread/quantum/sparks = new
				sparks.set_up(10, 1, spawned_player)
				sparks.attach(get_turf(spawned_player))
				sparks.start()
			if("Pod")
				var/obj/structure/closet/supplypod/empty_pod = new()

				empty_pod.style = STYLE_BLUESPACE
				empty_pod.bluespace = TRUE
				empty_pod.explosionSize = list(0,0,0,0)
				empty_pod.desc = "A sleek, and slightly worn bluespace pod - its probably seen many deliveries..."

				spawned_player.forceMove(empty_pod)

				new /obj/effect/pod_landingzone(current_turf, empty_pod)
