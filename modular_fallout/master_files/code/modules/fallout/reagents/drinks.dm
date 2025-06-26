/datum/reagent/consumable/nuka_cola
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "the future"
	glass_icon_state = "nukacolaglass"
	glass_name = "Nuka Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/sunset
	name = "Sunset Sarsaparilla"
	description = "Build Mass With Sass!"
	color = "#994C00" // rgb: 153, 76, 0
	taste_description = "root beer, vanilla and caramel"
	glass_icon_state = "sunsetglass"
	glass_name = "glass of Sunset Sarsaparilla"
	glass_desc = "Beverage of the West Coast."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/vim
	name = "Vim"
	description = "You've Got Vim!"
	color = "#946B4A"
	taste_description = "off-brand nuka-cola"
	glass_icon_state = "vimglass"
	glass_name = "glass of Vim"
	glass_desc = "Unrelated to Nuka-Cola, Vim trademark Circa 2077."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustToxLoss(-0.5, 0)
	C.adjustOxyLoss(0.5, 0)
	C.drowsyness = max(0,C.drowsyness-3)
	C.AdjustSleeping(-40, FALSE)
	//310.15 is the normal bodytemp.
	C.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder?.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/vimquartz
	name = "Vim Quartz"
	description = "You've Got Vim! Quartz edition, worse than the Imitation."
	color = "#946B4A"
	taste_description = "off-brand nuka-cola but fucking worse"
	glass_icon_state = "vimquartzglass"
	glass_name = "Vim Quartz"
	glass_desc = "You've Got Vim! Quartz edition, worse than the Imitation."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.vomit(10)
	C.adjustToxLoss(-2, 0)
	C.adjustOxyLoss(4, 0)
	C.adjust_timed_status_effect(-5 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-3)
	C.AdjustSleeping(-40, FALSE)
	//310.15 is the normal bodytemp.
	C.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder?.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/vimrefresh
	name = "Vim Refresh"
	description = "You've Got Vim Refresh! Ooooh!"
	color = "#BFAC9C"
	taste_description = "off-brand nuka-cola and refreshment"
	glass_icon_state = "grasshopper"
	glass_name = "Vim Refresh"
	glass_desc = "You've Got Vim Refresh! Ooooh!"

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustFireLoss(-1.5*removed, 0)
	C.adjustToxLoss(-1.5, 0)
	C.adjustOxyLoss(1, 0)
	C.adjust_timed_status_effect(-5 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-3)
	C.AdjustSleeping(-40, FALSE)
	//310.15 is the normal bodytemp.
	C.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder?.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/vimice
	name = "Vim Ice"
	description = "You've Got Vim! Cold as the East."
	color = "#DFECED"
	taste_description = "cold off-brand nuka-cola"
	glass_icon_state = "vimiceglass"
	glass_name = "Iced Vim"
	glass_desc = "You've Got Vim! Cold as the East."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C)
	C.adjustFireLoss(-2*removed, 0)
	C.adjustOxyLoss(1, 0)
	C.adjust_timed_status_effect(-5 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-3)
	C.AdjustSleeping(-40, FALSE)
	//310.15 is the normal bodytemp.

	..()
	. = TRUE

//nuka bases

/datum/reagent/consumable/nukacherry
	name = "Nuka Cherry"
	description = "Nuka-Cola with a Cherry Aftertaste."
	color = "#9C1512"
	taste_description = "fizzy cherry soda"
	glass_icon_state = "nukacherryglass"
	glass_name = "Nuka Cherry"
	glass_desc = "Nuka-Cola with a Cherry Aftertaste."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustFireLoss(-1*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukagrape
	name = "Nuka Grape"
	description = "Nuka-Cola with a Grape Aftertaste."
	color = "#643B65"
	taste_description = "fizzy grape soda"
	glass_icon_state = "nukagrapeglass"
	glass_name = "Nuka Grape"
	glass_desc = "Nuka-Cola with a Grape Aftertaste."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustBruteLoss(-1*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukaorange
	name = "Nuka Orange"
	description = "Nuka-Cola with a Orange Aftertaste."
	color = "#FF7F00"
	taste_description = "fizzy orange soda"
	glass_icon_state = "nukaorangeglass"
	glass_name = "Nuka Orange"
	glass_desc = "Nuka-Cola with a Orange Aftertaste."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustToxLoss(-1*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukaquartz
	name = "Nuka Quartz"
	description = "An abomination of Americas favourite soda."
	color = "#FFFFFF"
	taste_description = "clear"
	glass_icon_state = "nukaquartzglass"
	glass_name = "Nuka Quartz"
	glass_desc = "An abomination of Americas favourite soda."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-1*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukaice
	name = "Iced Nuka"
	description = "Nuka. Stay frosty."
	color = "#646A7B"
	taste_description = "cold Nuka-Cola"
	glass_icon_state = "nukaiceglass"
	glass_name = "Iced Nuka"
	glass_desc = "Nuka. Stay frosty."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-20 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C) //310.15 is the normal bodytemp.
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukawild
	name = "Nuka Wild"
	description = "A totally original concept of Nuka-Cola!"
	color = "#734517"
	taste_description = "Nuka and root-beer"
	glass_icon_state = "nukawildglass"
	glass_name = "Nuka Wild"
	glass_desc = "A totally original concept of Nuka-Cola!"

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.AdjustStun(-5, 0)
	C.AdjustKnockdown(-5, 0)
	C.AdjustUnconscious(-5, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

//nuka mixes

/datum/reagent/consumable/nukanew
	name = "Newka Cola"
	description = "The tastiest Hybridisation of Nuka-Colas."
	color = "#75E11D"
	taste_description = "impossibly tasty Nuka"
	glass_icon_state = "nukanewglass"
	glass_name = "Newka Cola"
	glass_desc = "The tastiest Hybridisation of Nuka-Colas."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustFireLoss(-2*removed, 0)
	C.AdjustStun(-15, 0)
	C.AdjustKnockdown(-15, 0)
	C.AdjustUnconscious(-15, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukaberry
	name = "Nuka Berry"
	description = "Nuka-Cola with a Berry Aftertaste."
	color = "#753453"
	taste_description = "berry Nuka-Cola"
	glass_icon_state = "nukaberryglass"
	glass_name = "Nuka Berry"
	glass_desc = "Nuka-Cola with a Berry Aftertaste."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustFireLoss(-2*removed, 0)
	C.adjustBruteLoss(-2*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukacooler
	name = "Nuka Cooler"
	description = "Insanely cold Nuka-Cola, Freezing the air that surrounds it."
	color = "#B2B2B2"
	taste_description = "insanely cold Nuka-Cola"
	glass_icon_state = "nukacoolerglass"
	glass_name = "Nuka Cooler"
	glass_desc = "Insanely cold Nuka-Cola, Freezing the air that surrounds it."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-60 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C) //310.15 is the normal bodytemp.
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukafree
	name = "Diet Nuka"
	description = "Nuka-Cola with no added sugars!"
	color = "#663300"
	taste_description = "watered down Nuka"
	glass_icon_state = "nukafreeglass"
	glass_name = "Diet Nuka"
	glass_desc = "Nuka-Cola with no added sugars!"

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	if(C.nutrition <= NUTRITION_LEVEL_STARVING)
		C.adjustToxLoss(1*removed, 0)
	C.nutrition = max(C.nutrition - 3, 0)
	C.overeatduration = 0
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/nukafrutti
	name = "Nuka Frutti"
	description = "The frutiest of Nukas."
	color = "#FF9ABF"
	taste_description = "fruity Nuka"
	glass_icon_state = "nukafruttiglass"
	glass_name = "Nuka Frutti"
	glass_desc = "The frutiest of Nukas."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustToxLoss(-3*removed, 0)
	C.adjustFireLoss(-3*removed, 0)
	C.adjustBruteLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

//shake shack royal rumble

/datum/reagent/consumable/nukafloat
	name = "Nuka Float"
	description = "A delicious blend of ice-cream and classic Nuka-Cola!"
	color = "#11111E"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	taste_description = "creamy Nuka"
	glass_icon_state = "nukafloatglass"
	glass_name = "Nuka Float"
	glass_desc = "A delicious blend of ice-cream and classic Nuka-Cola!"

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/sunsetfloat
	name = "Sunset Float"
	description = "A delicious blend of ice-cream and classic Sunset Sass!"
	color = "#734517"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	taste_description = "creamy root beer"
	glass_icon_state = "sunsetfloatglass"
	glass_name = "Sunset Float"
	glass_desc = "A delicious blend of ice-cream and classic Sunset Sass!"

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/bawlsshake
	name = "Bawls Shake"
	description = "A blended shake consumed by those on high energy blitz-lifestyles."
	color = "#0070E1"
	nutriment_factor = 10
	taste_description = "creamy sugar"
	glass_icon_state = "bawlsshakeglass"
	glass_name = "Bawls Shake"
	glass_desc = "A blended shake consumed by those on high energy blitz-lifestyles."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/jakeshake
	name = "Jake Shake"
	description = "Jakes patented shake of Jake."
	color = "#7ABB5F"
	nutriment_factor = 10
	taste_description = "creamy patented juice"
	glass_icon_state = "jakeshakeglass"
	glass_name = "Jake Shake"
	glass_desc ="Jakes patented shake of Jake."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/sweetwaterfloat
	name = "Sweetwater Float"
	description = "The sweetest water."
	color = "#FAFAF8"
	nutriment_factor = 10
	taste_description = "the sweetest water"
	glass_icon_state = "sweetwaterfloatglass"
	glass_name = "Sweetwater Float"
	glass_desc = "The sweetest water."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/sunsetter
	name = "Sunsetter"
	description = "For when the days dawn, lest brings a brighter tommorrow."
	color = "#B06A24"
	nutriment_factor = 10
	taste_description = "days gone by"
	glass_icon_state = "sunsetterglass"
	glass_name = "Sunsetter"
	glass_desc = "For when the days dawn, lest brings a brighter tommorrow."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/yuccashake
	name = "Yucca Shake"
	description = "A blended shake consisting of yucca and creamy goodness."
	color = "#FFD24A"
	nutriment_factor = 10
	taste_description = "bannanas and cream"
	glass_icon_state = "yuccashakeglass"
	glass_name = "Yucca Shake"
	glass_desc = "A blended shake consisting of yucca and creamy goodness."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed, 0)
	C.drowsyness = 0
	C.AdjustSleeping(-40, FALSE)
	C.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/bawls
	name = "Balls Guarana"
	description = "For that Guarana Bounce!"
	color = "#494A82"
	taste_description = "insanely sweet coffee"
	glass_icon_state = "bawlsglass"
	glass_name = "glass of Balls Guarana"
	glass_desc = "Beverage of the Balls Guarana Company."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-5 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-3)
	C.AdjustSleeping(-40, FALSE)
	//310.15 is the normal bodytemp.
	C.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder?.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = 1
