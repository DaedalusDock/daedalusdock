/datum/reagent/colorful_reagent
	name = "Colorful Reagent"
	description = "Thoroughly sample the rainbow."
	reagent_state = LIQUID
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")
	color = "#C8A5DC"
	taste_description = "rainbows"
	var/can_colour_mobs = TRUE

	var/datum/callback/color_callback

/datum/reagent/colorful_reagent/New()
	color_callback = CALLBACK(src, PROC_REF(UpdateColor))
	SSticker.OnRoundstart(color_callback)
	return ..()

/datum/reagent/colorful_reagent/Destroy()
	LAZYREMOVE(SSticker.round_start_events, color_callback) //Prevents harddels during roundstart
	color_callback = null //Fly free little callback
	return ..()

/datum/reagent/colorful_reagent/proc/UpdateColor()
	color_callback = null
	color = pick(random_color_list)

/datum/reagent/colorful_reagent/affect_blood(mob/living/carbon/C, removed)
	if(can_colour_mobs)
		C.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/datum/reagent/colorful_reagent/affect_touch(mob/living/carbon/C, removed)
	if(can_colour_mobs)
		C.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/// Colors anything it touches a random color.
/datum/reagent/colorful_reagent/expose_atom(atom/exposed_atom, reac_volume)
	. = ..()
	if(!isliving(exposed_atom) || can_colour_mobs)
		exposed_atom.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/////////////////////////Colorful Powder////////////////////////////
//For colouring in /proc/mix_color_from_reagents

/datum/reagent/colorful_reagent/powder
	name = "Mundane Powder" //the name's a bit similar to the name of colorful reagent, but hey, they're practically the same chem anyway
	var/colorname = "none"
	description = "A powder that is used for coloring things."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 207, 54, 0
	taste_description = "the back of class"

/datum/reagent/colorful_reagent/powder/New()
	if(colorname == "none")
		description = "A rather mundane-looking powder. It doesn't look like it'd color much of anything..."
	else if(colorname == "invisible")
		description = "An invisible powder. Unfortunately, since it's invisible, it doesn't look like it'd color much of anything..."
	else
		description = "\An [colorname] powder, used for coloring things [colorname]."
	return ..()

/datum/reagent/colorful_reagent/powder/red
	name = "Red Powder"
	colorname = "red"
	color = "#DA0000" // red
	random_color_list = list("#FC7474")


/datum/reagent/colorful_reagent/powder/orange
	name = "Orange Powder"
	colorname = "orange"
	color = "#FF9300" // orange
	random_color_list = list("#FF9300")

/datum/reagent/colorful_reagent/powder/yellow
	name = "Yellow Powder"
	colorname = "yellow"
	color = "#FFF200" // yellow
	random_color_list = list("#FFF200")


/datum/reagent/colorful_reagent/powder/green
	name = "Green Powder"
	colorname = "green"
	color = "#A8E61D" // green
	random_color_list = list("#A8E61D")


/datum/reagent/colorful_reagent/powder/blue
	name = "Blue Powder"
	colorname = "blue"
	color = "#00B7EF" // blue
	random_color_list = list("#71CAE5")


/datum/reagent/colorful_reagent/powder/purple
	name = "Purple Powder"
	colorname = "purple"
	color = "#DA00FF" // purple
	random_color_list = list("#BD8FC4")


/datum/reagent/colorful_reagent/powder/invisible
	name = "Invisible Powder"
	colorname = "invisible"
	color = "#FFFFFF00" // white + no alpha
	random_color_list = list("#FFFFFF") //because using the powder color turns things invisible


/datum/reagent/colorful_reagent/powder/black
	name = "Black Powder"
	colorname = "black"
	color = "#1C1C1C" // not quite black
	random_color_list = list("#8D8D8D") //more grey than black, not enough to hide your true colors


/datum/reagent/colorful_reagent/powder/white
	name = "White Powder"
	colorname = "white"
	color = "#FFFFFF" // white
	random_color_list = list("#FFFFFF") //doesn't actually change appearance at all


/* used by crayons, can't color living things but still used for stuff like food recipes */

/datum/reagent/colorful_reagent/powder/red/crayon
	name = "Red Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/orange/crayon
	name = "Orange Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/yellow/crayon
	name = "Yellow Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/green/crayon
	name = "Green Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/blue/crayon
	name = "Blue Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/purple/crayon
	name = "Purple Crayon Powder"
	can_colour_mobs = FALSE


//datum/reagent/colorful_reagent/powder/invisible/crayon

/datum/reagent/colorful_reagent/powder/black/crayon
	name = "Black Crayon Powder"
	can_colour_mobs = FALSE


/datum/reagent/colorful_reagent/powder/white/crayon
	name = "White Crayon Powder"
	can_colour_mobs = FALSE

