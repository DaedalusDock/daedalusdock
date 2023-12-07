/// Have a living mob attempt to do a slapcraft. The mob is using the second item on the first item.
/mob/living/proc/try_slapcraft(obj/item/first_item, obj/item/second_item)
	// We need to find a recipe where the first item corresponds to the first step
	// ..and the second item corresponds to the second step
	var/list/available_recipes = slapcraft_recipes_for_type(first_item.type)
	if(!available_recipes)
		return FALSE

	var/list/recipes = list()
	for(var/datum/slapcraft_recipe/recipe in available_recipes)
		//Always start from step one.
		var/datum/slapcraft_step/step_one = SLAPCRAFT_STEP(recipe.steps[1])
		if(!step_one.perform_check(src, first_item, null))
			continue

		// Get next suitable step that is available after the first one would be performed.
		var/list/pretend_list = list()
		pretend_list[step_one.type] = TRUE
		var/datum/slapcraft_step/next_step = recipe.next_suitable_step(src, second_item, pretend_list)
		if(!next_step)
			continue
		if(!next_step.perform_check(src, second_item, null))
			continue

		recipes += recipe

	if(!length(recipes))
		return FALSE

	var/datum/slapcraft_recipe/target_recipe
	// If we have only one recipe, choose it instantly
	if(recipes.len == 1)
		target_recipe = recipes[1]
	// If we have more recipes, let the user choose one with a radial menu.
	else
		var/list/recipe_choices = list()
		var/list/recipe_choice_translation = list()
		for(var/datum/slapcraft_recipe/recipe as anything in recipes)
			recipe_choices[recipe.name] = recipe.get_radial_image()
			recipe_choice_translation[recipe.name] = recipe

		var/choice = show_radial_menu(src, first_item, recipe_choices, custom_check = FALSE, require_near = TRUE)
		if(choice)
			target_recipe = recipe_choice_translation[choice]
	if(!target_recipe)
		return TRUE

	// We have found the recipe we want to do, make an assembly item where the first item used to be.
	var/obj/item/slapcraft_assembly/assembly = new()
	assembly.set_recipe(target_recipe)

	/// The location to place the assembly or items if the user cannot hold them
	var/atom/fallback_loc = drop_location()

	var/datum/slapcraft_step/step_one = SLAPCRAFT_STEP(target_recipe.steps[1])

	// Instantly and silently perform the first step on the assembly, disassemble it if something went wrong
	if(!step_one.perform(src, first_item, assembly, instant = TRUE, silent = TRUE))
		assembly.forceMove(fallback_loc)
		assembly.disassemble()
		return TRUE

	var/datum/slapcraft_step/step_two = target_recipe.next_suitable_step(src, second_item, assembly.step_states)
	// Perform the second step, also disassemble it if we stopped working on it, because keeping 1 component assembly is futile.
	if(!step_two.perform(src, second_item, assembly))
		assembly.forceMove(fallback_loc)
		assembly.disassemble()
		return TRUE

	if(QDELING(assembly) && assembly.being_finished)
		var/in_hands = FALSE
		if(length(assembly.finished_items) == 1)
			var/obj/item/finished_item = assembly.finished_items[1].resolve()
			if(put_in_hands(finished_item))
				in_hands = TRUE

		if(!in_hands)
			for(var/datum/weakref/W as anything in assembly.finished_items)
				var/obj/item/finished_item = W.resolve()
				finished_item.forceMove(fallback_loc)

		assembly.finished_items = null

	return TRUE
