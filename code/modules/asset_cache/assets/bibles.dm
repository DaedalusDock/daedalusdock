/datum/asset/spritesheet/bibles
	name = "bibles"

/datum/asset/spritesheet/bibles/create_spritesheets()
	var/obj/item/storage/book/bible/holy_template = /obj/item/storage/book/bible
	//FUN FACT, THIS USED TO BE A CALL TO InsertAll("display", initial(holy_template.icon))
	//IT RESCALED *OVER 300 ICON STATES* AND WAS SINGLEHANDEDLY RESPONSIBLE FOR OVER 3 SECONDS OF ASSET TIME.
	//KNOW WHAT YOU ARE DOING WHEN TOUCHING ASSETS OR YOU WILL BE **FUCKING LIQUIDATED**
	var/cache_for_sanic_speed = initial(holy_template.icon)
	for(var/bibblestate in GLOB.biblestates)
		Insert("display-[bibblestate]", cache_for_sanic_speed, bibblestate, SOUTH)

/datum/asset/spritesheet/bibles/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(224, 224) // Scale up by 7x
	return pre_asset
