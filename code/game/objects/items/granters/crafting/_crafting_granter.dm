
/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/datum/crafting_recipe/crafting_recipe_type as anything in crafting_recipe_types)
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user, span_notice("You learned how to make [initial(crafting_recipe_type.name)]."))
