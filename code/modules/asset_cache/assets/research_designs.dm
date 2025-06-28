// Representative icons for each research design
/datum/asset/spritesheet/biogenerator_designs
	name = "design"

/datum/asset/spritesheet/biogenerator_designs/create_spritesheets()
	for (var/datum/design/D as anything in subtypesof(/datum/design))
		if(!(initial(D.build_type) & BIOGENERATOR))
			continue

		var/icon/I
		var/icon_state
		var/icon_file

		// construct the icon and slap it into the resource cache
		var/atom/item = initial(D.build_path)
		if (!ispath(item, /atom))
			item = /obj/item/reagent_containers/cup/beaker/large

		// Check for GAGS support where necessary
		var/greyscale_config = initial(item.greyscale_config)
		var/greyscale_colors = initial(item.greyscale_colors)
		if (greyscale_config && greyscale_colors)
			icon_file = SSgreyscale.GetColoredIconByType(greyscale_config, greyscale_colors)
		else
			icon_file = initial(item.icon)

		icon_state = initial(item.icon_state)
		#ifdef UNIT_TESTS
		if(!icon_exists(icon_file, icon_state, FALSE))
			warning("design [D] with icon '[icon_file]' missing state '[icon_state]'")
			continue
		#endif
		I = icon(icon_file, icon_state, SOUTH)

		Insert(initial(D.id), I)
