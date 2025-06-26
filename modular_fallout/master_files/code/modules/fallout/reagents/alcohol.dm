/datum/reagent/consumable/ethanol/wastemead
	name = "Waster Mead"
	description = "A true Wastelander's drink."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 50
	taste_description = "crispy sweetness"
	glass_icon_state = "meadglass"
	glass_name = "waster mead"
	glass_desc = "A true Wastelander's drink."

/datum/reagent/consumable/ethanol/tatovodka
	name = "Tato Vodka"
	description = "A extremely powerful and disgusting spirit."
	color = "#706A58"
	boozepwr = 100
	taste_description = "extremely powerful dirt"
	glass_icon_state = "glass_brown"
	glass_name = "glass of tato vodka"
	glass_desc = "The glass contains actual swill tato vodka."

/datum/reagent/consumable/ethanol/tatovodka/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		M.vomit(10)
	M.radiation = max(M.radiation-3,0)
	return ..()

/datum/reagent/consumable/ethanol/pungajuice
	name = "punga juice"
	description = "The fermented juice of the punga fruit, used to treat radiation sickness"
	color = "#1B2E24"
	boozepwr = 80
	taste_description = "acidic slime"
	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of punga juice"
	glass_desc = "The glass contain punga juice, used to treat radiation sickness"

/datum/reagent/consumable/ethanol/pungajuice/on_mob_life(mob/living/carbon/M)
	M.radiation = max(M.radiation-14,0)
	//M.hallucination += 5
	return ..()

/datum/reagent/consumable/ethanol/purplecider
	name = "Purple Cider"
	description = "Refined and pressurised mutfruit cider."
	color = "#570197"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "sweetness and nuclear winter"
	glass_icon_state = "mutfruitglass"
	glass_name = "purple cider"
	glass_desc = "Refined and pressurised mutfruit cider."

/datum/reagent/consumable/ethanol/purplecider/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(10))
		M.heal_bodypart_damage(1)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/brocbrew
	name = "Broc Brew"
	description = "A potent healing beverage brewed from the Broc flower."
	color = "#DFA866"
	boozepwr = 50
	taste_description = "dirt and roses"
	glass_icon_state = "cognacglass"
	glass_name = "broc brew"
	glass_desc = "A potent healing beverage brewed from the Broc flower."
	var/last_added = 0
	var/maximum_reachable = BLOOD_VOLUME_NORMAL - 10

/datum/reagent/consumable/ethanol/brocbrew/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(-5*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/brocbrew/on_mob_life(mob/living/carbon/M)
	if(last_added)
		M.blood_volume -= last_added
		last_added = 0
	if(M.blood_volume < maximum_reachable)	//Can only up to double your effective blood level.
		var/amount_to_add = min(M.blood_volume, volume*5)
		var/new_blood_level = min(M.blood_volume + amount_to_add, maximum_reachable)
		last_added = new_blood_level - M.blood_volume
		M.blood_volume = new_blood_level
	if(prob(33))
		M.adjustBruteLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/yellowpulque
	name = "Yellow pulque"
	description = "An awful smelling yellow, thick pulque."
	color = "#fdff73"
	boozepwr = 50
	taste_description = "puke and dirt"
	glass_icon_state = "cognacglass"
	glass_name = "yellow pulque"
	glass_desc = "An awful smelling yellow, thick pulque."
	var/last_added = 0
	var/maximum_reachable = BLOOD_VOLUME_NORMAL - 10

/datum/reagent/consumable/ethanol/yellowpulque/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(-5*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/yellowpulque/on_mob_life(mob/living/carbon/M)
	if(last_added)
		M.blood_volume -= last_added
		last_added = 0
	if(M.blood_volume < maximum_reachable)	//Can only up to double your effective blood level.
		var/amount_to_add = min(M.blood_volume, volume*5)
		var/new_blood_level = min(M.blood_volume + amount_to_add, maximum_reachable)
		last_added = new_blood_level - M.blood_volume
		M.blood_volume = new_blood_level
	if(prob(33))
		M.adjustBruteLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/deathroach
	name = "Deathroach"
	description = "Distilled tobacco, for that two-in-one cancer blast!"
	color = "#0C0704"
	boozepwr = 100
	taste_description = "tobacco and hatred"
	glass_icon_state = "irishcarbomb"
	glass_name = "death roach"
	glass_desc = "Distilled tobacco, for that two-in-one cancer blast!"

/datum/reagent/consumable/ethanol/deathroach/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		var/drink_message = pick("You feel rugged.", "You feel manly.","You feel western.","You feel like a madman.")
		to_chat(M, "<span class='notice'>[drink_message]</span>")
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/daturatea
	name = "Datura Tea"
	description = "A potent tea used for rites of passage rituals and ceremonies."
	color = "#E5E2D4"
	boozepwr = 10
	taste_description = "divine intervention"
	glass_icon_state = "daturatea"
	glass_name = "datura tea"
	glass_desc = "A potent tea used for rites of passage rituals and ceremonies."

/datum/reagent/consumable/ethanol/daturatea/on_mob_add(mob/living/M) //spiritual shizzle, also admemes getting booled on
	ADD_TRAIT(M, TRAIT_SPIRITUAL, "[type]")
	M.set_drugginess(15)
	M.hallucination += 20
	..()

/datum/reagent/consumable/ethanol/daturatea/on_mob_delete(mob/living/M)
	ADD_TRAIT(M, TRAIT_SPIRITUAL, "[type]")
	M.set_drugginess(0)
	M.hallucination += 0
	..()

/datum/reagent/consumable/ethanol/pinkpulque
	name = "Pink Pulque"
	description = "An alcholic spirit made from prickly pear cactus mash."
	color = "#D0007C"
	boozepwr = 30
	taste_description = "sweetness and pulp"
	glass_icon_state = "pinkpulqueglass"
	glass_name = "pink pulque"
	glass_desc = "An alcholic spirit made from prickly pear cactus mash."

/datum/reagent/consumable/ethanol/pinkpulque/on_mob_life(mob/living/carbon/M)
	if(prob(33))
		M.Dizzy(2)
		M.Jitter(2)
	..()

/datum/reagent/consumable/ethanol/yellowpulque
	name = "Yellow Pulque"
	description = "A sobering and extremely bitter spirit made from barrel cactus mash."
	color = "#FEFCE7"
	boozepwr = -10
	taste_description = "sweetness and pulp"
	glass_icon_state = "yellowpulqueglass"
	glass_name = "yellow pulque"
	glass_desc = "A sobering and extremely bitter spirit made from barrel cactus mash."

/datum/reagent/consumable/ethanol/yellowpulque/on_mob_life(mob/living/carbon/M)
	if(prob(80))
		M.Dizzy(-2)
		M.Jitter(-2)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type,2.5)
	if(M.health > 20)
		M.adjustToxLoss(0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		. = TRUE
	M.radiation += 0.1
	return ..()

/datum/reagent/consumable/ethanol/salgam
	name = "Şalgam"
	description = "A powerful spirit brewed from xander roots."
	color = "#591F24"
	boozepwr = 80
	taste_description = "sour turnips"
	glass_icon_state = "salgamglass"
	glass_name = "şalgam"
	glass_desc = "A powerful spirit brewed from the xander root."

/datum/reagent/consumable/ethanol/salgam/on_mob_life(mob/living/carbon/M)
	if(prob(33))
		M.adjustBruteLoss(-1*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-1*REAGENTS_EFFECT_MULTIPLIER, 0)
		. = TRUE
	M.adjustToxLoss(-2*REAGENTS_EFFECT_MULTIPLIER, 0)
	for(var/datum/reagent/toxin/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type,1)
	..()

//nuka

/datum/reagent/consumable/ethanol/nukadark
	name = "Nuka Dark"
	description = "Nuka Cola with a alcoholic twist."
	color = "#1C2118"
	boozepwr = 80
	taste_description = "bitter and toxic cola"
	glass_icon_state = "nukadarkglass"
	glass_name = "Nuka Dark"
	glass_desc = "Nuka Cola with a alcoholic twist."

/datum/reagent/consumable/ethanol/nukadark/on_mob_life(mob/living/carbon/M)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukavictory
	name = "Nuka Victory"
	description = "Nuka Cola with an <BIG>AMERICAN<BIG> twist."
	color = "#FAEBD7"
	boozepwr = 45
	taste_description = "freedom"
	glass_icon_state = "nukavictoryglass"
	glass_name = "Nuka Victory"
	glass_desc = "Nuka Cola with an AMERICAN twist."

/datum/reagent/consumable/ethanol/nukavictory/on_mob_life(mob/living/carbon/M)
	ADD_TRAIT(M, TRAIT_BIG_LEAGUES, "[type]")
	M.adjustBruteLoss(-2.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukavictory/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_BIG_LEAGUES, "[type]")
	..()

/datum/reagent/consumable/ethanol/nukabomb
	name = "Nuka Bombdrop"
	description = "More spirit than Nuka at this Rate."
	color = "#FAEBD7"
	boozepwr = 200
	taste_description = "pure alcohol"
	glass_icon_state = "nukabombglass"
	glass_name = "Nuka Bombdrop"
	glass_desc = "More spirit than Nuka at this Rate."

/datum/reagent/consumable/ethanol/nukabomb/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>You hear the /SIRENS BLAZING/</b></font>, <br><font color='#FF0000'><b>You feel the /RADIOACTIVE HELLFIRE/</b></font>")
	if(prob(50))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustBruteLoss(-6*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukabomb/on_mob_delete(mob/living/M)
	M.playsound_local(M, 'sound/f13effects/explosion_2.ogg', 100, 0)
	M.Knockdown(10, 0)
	..()

/datum/reagent/consumable/ethanol/nukacide
	name = "Nukacide"
	description = "The drink of a goddamn madman, say your sorrows when you drink this."
	color = "#000000"
	boozepwr = 300
	taste_description = "nuclear annihilation"
	glass_icon_state = "nukacideglass"
	glass_name = "Nukacide"
	glass_desc = "The drink of a goddamn madman, say your sorrows when you drink this."

/datum/reagent/consumable/ethanol/nukacide/on_mob_life(mob/living/carbon/M)
	if(prob(30))
		M.vomit(100)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukafancy
	name = "Nuka Fancy"
	description = "The Refined mans Soda, Fit for soda royalty."
	color = "#11111E"
	boozepwr = 30
	taste_description = "refined soda"
	glass_icon_state = "nukafancyglass"
	glass_name = "Nuka Fancy"
	glass_desc = "The Refined mans Soda, Fit for soda royalty."

/datum/reagent/consumable/ethanol/nukafancy/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br>Maybe I too need some Slaves?</b>","<br>Mutfruit for All!</b>","<br>Time to Glorify my Wasteland Castle!</b>","<brNuked, not stirred.</b>")
	if(prob(20))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustBruteLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukalove
	name = "Nuka Love"
	description = "A Nuka-Cola twist on a passionate classic."
	color = "#8F4096"
	boozepwr = 60
	taste_description = "passion and bliss"
	glass_icon_state = "nukaloveglass"
	glass_name = "Nuka Love"
	glass_desc = "A Nuka-Cola twist on a passionate classic."

/datum/reagent/consumable/ethanol/nukalove/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-2*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukapunch
	name = "Nuka Punch"
	description = "The drink of a Madman."
	color = "#4A261B"
	boozepwr = 150
	taste_description = "pain"
	glass_icon_state = "nukapunchglass"
	glass_name = "Nuka Punch"
	glass_desc = "The drink of a Madman."

/datum/reagent/consumable/ethanol/nukapunch/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustOxyLoss(-4*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustToxLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustStaminaLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	if(prob(10))
		M.vomit(20)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukasunrise
	name = "Nuka Sunrise"
	description = "A Nuka-Cola original drink, totally original and first of its kind!"
	color = "#D82E04"
	boozepwr = 30
	taste_description = "sweetness and funshine"
	glass_icon_state = "nukasunriseglass"
	glass_name = "Nuka Sunrise"
	glass_desc = "A Nuka-Cola original drink, totally original and first of its kind!"

/datum/reagent/consumable/ethanol/nukasunrise/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-2.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukaquantum
	name = "Nuka Quantum"
	description = "An extremely blue and glowing combination of Nuka-Cola and (REDACTED)."
	color = "#6AFFFF"
	boozepwr = 10
	taste_description = "the eighteenth flavour"
	glass_icon_state = "nukaquantumglass"
	glass_name = "Nuka Quantum"
	glass_desc = "An extremely blue and glowing combination of Nuka-Cola and (REDACTED)"
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/nukaquantum/on_mob_life(mob/living/carbon/M)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1,0))
	M.AdjustStun(-20, 0)
	M.adjustToxLoss(1, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 20
	M.Jitter(2)
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukaquantum/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
	if(L)
		L.damage += 1
	if(rage)
		QDEL_NULL(rage)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.cure_trauma_type(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/nukaxtreme //this is hell
	name = "Nuka X-Treme"
	description = "Like Quantum, but <BIG>EXTREME<BIG>."
	color = "#72E070"
	boozepwr = 50
	taste_description = "THE EXTREME"
	glass_icon_state = "nukaxtremeglass"
	glass_name = "Nuka X-Treme"
	glass_desc = "Like Quantum, but <BIG>EXTREME<BIG>."
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/nukaxtreme/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>EXTREME</b></font>", "<br><font color='#FF0000'><b>RAAAAR!</b></font>", "<br><font color='#FF0000'><b>BRING IT!</b></font>")
	if(prob(100))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3,0)
	M.adjustToxLoss(2, 0)
	M.AdjustStun(-30, 0)
	M.AdjustKnockdown(-30, 0)
	M.AdjustUnconscious(-30, 0)
	M.adjustStaminaLoss(-5, 0)
	ADD_TRAIT(M, TRAIT_IRONFIST, "[type]")
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/nukaxtreme/on_mob_life(mob/living/carbon/M)
	if(M.hud_used)
		if(current_cycle >= 5 && current_cycle % 3 == 0)
			var/list/screens = list(M.hud_used.plane_masters["[FLOOR_PLANE]"], M.hud_used.plane_masters["[GAME_PLANE]"])
			var/matrix/skew = matrix()
			var/intensity = 8
			skew.set_skew(rand(-intensity,intensity), rand(-intensity,intensity))
			var/matrix/newmatrix = skew

			for(var/whole_screen in screens)
				animate(whole_screen, transform = newmatrix, time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = -newmatrix, time = 5, easing = QUAD_EASING)
	return ..()

/datum/reagent/consumable/ethanol/nukaxtreme/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_IRONFIST, "[type]")
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	if(M && M.hud_used)
		var/list/screens = list(M.hud_used.plane_masters["[FLOOR_PLANE]"], M.hud_used.plane_masters["[GAME_PLANE]"], M.hud_used.plane_masters["[LIGHTING_PLANE]"])
		for(var/whole_screen in screens)
			animate(whole_screen, transform = matrix(), time = 5, easing = QUAD_EASING)
	if(rage)
		QDEL_NULL(rage)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.cure_trauma_type(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

//vim

/datum/reagent/consumable/ethanol/vimcap
	name = "Vim Captains Blend"
	description = "The taste of the sea, Far from here."
	color = "#52849A"
	boozepwr = 30
	taste_description = "the sea"
	glass_icon_state = "vimcapglass"
	glass_name = "Vim Captains Blend"
	glass_desc = "A glass of special vim holding the taste of the sea, Far from here."

/datum/reagent/consumable/ethanol/vimcap/on_mob_life(mob/living/carbon/M)
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1,0))
	M.adjustBruteLoss(-2*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(-2*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustOxyLoss(2*REAGENTS_EFFECT_MULTIPLIER)
	M.adjustStaminaLoss(-0.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.AdjustStun(-20, 0)
	M.adjustToxLoss(-3, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/vimcap/on_mob_delete(mob/living/M)
	var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
	if(L)
		L.damage += 50
	..()

//fallout cocktails - or "canon drinks i guess doe"

/datum/reagent/consumable/ethanol/alcoholz
	name = "Alcohol-Z"
	description = "An potent generic spirit, distilled through tacky radiation and intense stirring."
	color = "#ECE7E5"
	boozepwr = 120
	taste_description = "spirit"
	glass_icon_state = "alcoholzglass"
	glass_name = "Alcohol-Z"
	glass_desc = "An potent generic spirit, distilled through tacky radiation and intense stirring."

/datum/reagent/consumable/ethanol/bbock
	name = "Ballistic Bock"
	description = "An explosive cocktail that probably shouldnt be ingested, fills you with <BIG>BALLISTIC RAGE<BIG>."
	color = "#333333"
	boozepwr = 50
	taste_description = "rioting"
	glass_icon_state = "bbockglass"
	glass_name = "Ballistic Bock"
	glass_desc = "An explosive cocktail that probably shouldnt be ingested, fills you with <BIG>BALLISTIC RAGE<BIG>."
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/bbock/on_mob_life(mob/living/carbon/M)
	if(prob(80))
		M.playsound_local(M, 'sound/f13effects/explosion_2.ogg', 100, 0)
	var/high_message = pick("<br><font color='#FF0000'><b><BIG>FUCKING KILL!<BIG></b></font>", "<br><font color='#FF0000'><b><BIG>RAAAAR!<BIG></b></font>", "<br><font color='#FF0000'><b><BIG>BRING IT!<BIG></b></font>")
	if(prob(50))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.hallucination += 40
	M.Jitter(2)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/bbrew/on_mob_delete(mob/living/M)
	if(rage)
		QDEL_NULL(rage)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.cure_trauma_type(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/bbrew
	name = "Battle Brew"
	description = "A drink fit for a warrior."
	color = "#CB686B"
	boozepwr = 100
	taste_description = "war"
	glass_icon_state = "bbrewglass"
	glass_name = "Battle Brew"
	glass_desc = "A drink fit for a warrior."
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/bbrew/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>WAR</b></font>", "<br><font color='#FF0000'><b>GLORY</b></font>", "<br><font color='#FF0000'><b>OOORAH</b></font>")
	if(prob(10))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustKnockdown(-40, 0)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/bbrew/on_mob_delete(mob/living/M)
	if(rage)
		QDEL_NULL(rage)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.cure_trauma_type(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/bbrew2
	name = "Blackwater Brew"
	description = "Underground river wine, stewed from logs and food poisoning."
	color = "#B2B2B2"
	boozepwr = 40
	taste_description = "a cess pool and sweetness"
	glass_icon_state = "bbrew2glass"
	glass_name = "Blackwater Brew"
	glass_desc = "Underground river wine, stewed from logs and food poisoning."

/datum/reagent/consumable/ethanol/bbrew2/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/dwastelander
	name = "Dirty Wastelander"
	description = "A wastelanders second favourite."
	color = "#6E597B"
	boozepwr = 80
	taste_description = "scavenging air"
	glass_icon_state = "dwastelanderglass"
	glass_name = "Dirty Wastelander"
	glass_desc = "A wastelanders second favourite."

/datum/reagent/consumable/ethanol/dwastelander/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-3*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/firebelly
	name = "Fire Belly"
	description = "The spiciest drink in the West."
	color = "#673542"
	boozepwr = 160
	taste_description = "heartburn"
	glass_icon_state = "firebellyglass"
	glass_name = "Fire Belly"
	glass_desc = "The spiciest drink in the West."

/datum/reagent/consumable/ethanol/firebelly/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(100 * TEMPERATURE_DAMAGE_COEFFICIENT, 0 ,BODYTEMP_HEAT_DAMAGE_LIMIT)
	var/heating = 0
	switch(current_cycle)
		if(1 to 15)
			heating = 5 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(holder.has_reagent(/datum/reagent/cryostylane))
				holder.remove_reagent(/datum/reagent/cryostylane, 5)
			if(isslime(M))
				heating = rand(5,20)
		if(15 to 25)
			heating = 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				heating = rand(10,20)
		if(25 to 35)
			heating = 15 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				heating = rand(15,20)
		if(35 to INFINITY)
			heating = 20 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				heating = rand(20,25)
	M.adjust_bodytemperature(heating)
	M.adjustBruteLoss(-1*REAGENTS_EFFECT_MULTIPLIER, 0)
	if(prob(50))
		M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>")
	..()

/datum/reagent/consumable/ethanol/firecracker
	name = "Firecracker"
	description = "An warming mixture of wasteland homebrews."
	color = "#612B2F"
	boozepwr = 40
	taste_description = "country roads"
	glass_icon_state = "firecrackerglass"
	glass_name = "Firecracker"
	glass_desc = "An warming mixture of wasteland homebrews."

/datum/reagent/consumable/ethanol/firecracker/on_mob_life(mob/living/carbon/M)
	if(prob(33))
		M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/hardlemonade
	name = "Hard Lemonade"
	description = "Lemonade, but FOR MEN."
	color = "#D2FE6B"
	boozepwr = 60
	taste_description = "lemonade and vodka"
	glass_icon_state = "hardlemonadeglass"
	glass_name = "Hard Lemonade"
	glass_desc = "Lemonade, but FOR MEN."

/datum/reagent/consumable/ethanol/hardlemonade/on_mob_life(mob/living/carbon/M)
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 20
	M.Jitter(2)
	..()

/datum/reagent/consumable/ethanol/jakejuice
	name = "Jake Juice"
	description = "Who is Jake, why is this his Juice?"
	color = "#8EC577"
	boozepwr = 50
	taste_description = "patented juice"
	glass_icon_state = "greenbeerglass"
	glass_name = "Jake Juice"
	glass_desc = "Patented Jake Juice, Mixable at users own legal discretion."

/datum/reagent/consumable/ethanol/jakejuice/on_mob_life(mob/living/carbon/M)
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 20
	M.Jitter(2)
	..()

/datum/reagent/consumable/ethanol/wastetequila
	name = "Wasteland Tequila"
	description = "For the Real Hombres."
	color = "#CC99FF"
	boozepwr = 100
	taste_description = "old world blues and luchadors"
	glass_icon_state = "wastetequilaglass"
	glass_name = "Wasteland Tequila"
	glass_desc = "Brewed and distributed through the illusive Rad-Hombres."

/datum/reagent/consumable/ethanol/wastetequila/on_mob_life(mob/living/carbon/M)
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 20
	M.Jitter(2)
	..()

/datum/reagent/consumable/ethanol/nukashine
	name = "Nukashine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night. Stronger than the normal stuff, whooboy."
	color = "#706A58"
	boozepwr = 150
	taste_description = "sweetness and liverpain"
	glass_icon_state = "glass_brown"
	glass_name = "Nukashine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night. Stronger than the normal stuff, whooboy."

/datum/reagent/consumable/ethanol/olflakey
	name = "Ol' Flakey"
	description = "So smooth its flakey, leaves your throat confused and your body numb."
	color = "#DEE05E"
	boozepwr = 80
	taste_description = "dryness and warmth"
	glass_icon_state = "olflakeyglass"
	glass_name = "Ol' Flakey"
	glass_desc = "So smooth its flakey, leaves your throat confused and your body numb."

/datum/reagent/consumable/ethanol/olflakey/on_mob_life(mob/living/carbon/M)
	M.emote("laugh")
	M.emote("cough")
	..()

/datum/reagent/consumable/ethanol/oldpossum
	name = "Old Possum"
	description = "Unrelated to Poppy."
	color = "#C4BA71"
	boozepwr = 1
	taste_description = "possum"
	glass_icon_state = "oldpossumglass"
	glass_name = "Old Possum"
	glass_desc = "A ratmans classic, chalky and privelaged."

/datum/reagent/consumable/ethanol/oldpossum/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>eat the possum</b></font>")
	if(prob(0.1))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 20
	M.Jitter(2)
	..()

/datum/reagent/consumable/ethanol/sludge
	name = "Resilient Sludge"
	description = "A Ghoulies classical brew."
	color = "#C8F085"
	boozepwr = 100
	taste_description = "toxic waste"
	glass_icon_state = "sludgeglass"
	glass_name = "Resilient Sludge"
	glass_desc = "A Ghoulies classical brew."

/datum/reagent/consumable/ethanol/sludge/on_mob_life(mob/living/carbon/M)
	if(isghoul(M))
		M.adjustFireLoss(-2.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustBruteLoss(-2.5*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustToxLoss(-2.5*REAGENTS_EFFECT_MULTIPLIER, 0)
	else
		if(ishuman(M))
			if(prob(80))
				M.vomit(10)
				M.adjustToxLoss(4*REAGENTS_EFFECT_MULTIPLIER, 0)
			..()

/datum/reagent/consumable/ethanol/strongsludge
	name = "Strong Sludge"
	description = "Not for Human Consumption."
	color = "#027F02"
	boozepwr = 200
	taste_description = "toxic waste and death"
	glass_icon_state = "strongsludgeglass"
	glass_name = "Strong Sludge"
	glass_desc = "Not for Human Consumption."

/datum/reagent/consumable/ethanol/strongsludge/on_mob_life(mob/living/carbon/M)
	if(isghoul(M))
		M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustToxLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	else
		if(ishuman(M))
			if(prob(98))
				M.vomit(50)
				M.adjustToxLoss(10*REAGENTS_EFFECT_MULTIPLIER, 0)
		..()

/datum/reagent/consumable/ethanol/sweetwater
	name = "Sweet Water"
	description = "For those hot irradiated days on the ranch."
	color = "#BAC488"
	boozepwr = 40
	taste_description = "sweetness and relaxation"
	glass_icon_state = "sweetwaterglass"
	glass_name = "Sweet Water"
	glass_desc = "For those hot irradiated days on the ranch."

/datum/reagent/consumable/ethanol/sweetwater/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/ethanol/xbeer
	name = "XXXXXXBeer"
	description = "Beer, but strong."
	color = "#A6868F"
	boozepwr = 80
	taste_description = "strong piss water"
	glass_icon_state = "xbeerglass"
	glass_name = "XXXXXXBeer"
	glass_desc = "Beer, but strong."

//fallout cocktails - not canon, from the mind o scar

/datum/reagent/consumable/ethanol/atombomb //metadrink :flushed:
	name = "Atom Bomb"
	description = "War, War never changes."
	color = "#6A8216"
	boozepwr = 150
	taste_description = "fallout"
	glass_icon_state = "atombombglass"
	glass_name = "Atom Bomb"
	glass_desc = "War, War never changes."

/datum/reagent/consumable/ethanol/atombomb/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>You hear the /SIRENS BLAZING/</b></font>, <br><font color='#FF0000'><b>You feel the /RADIOACTIVE HELLFIRE/</b></font>")
	if(prob(50))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	if(prob(50))
		M.playsound_local(M, 'sound/f13effects/explosion_fire.ogg', 100, 0)
	if(prob(50))
		M.playsound_local(M, 'sound/f13effects/alarm.ogg', 100, 0)
	M.Jitter(100)
	M.adjustBruteLoss(-3*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.dizziness +=1.5
	M.drowsyness = 0
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/henessey
	name = "Henessey"
	description = "For the truly robust."
	color = "#CB686B"
	boozepwr = 100
	taste_description = "robust"
	glass_icon_state = "henesseyglass"
	glass_name = "Henessey"
	glass_desc = "For the truly robust."
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/consumable/ethanol/henessey/on_mob_life(mob/living/carbon/M)
	M.Jitter(40)
	M.dizziness +=1.5
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(2,0))
	M.AdjustStun(-20, 0)
	M.adjustToxLoss(1, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.hallucination += 100
	M.Jitter(2)
	switch(current_cycle)
		if(1 to 10)
			M.adjustToxLoss(1*REAGENTS_EFFECT_MULTIPLIER, 0)
		if(11 to 25)
			M.adjustToxLoss(2*REAGENTS_EFFECT_MULTIPLIER, 0)
		if(26 to 40)
			M.adjustToxLoss(3*REAGENTS_EFFECT_MULTIPLIER, 0)
		if(41 to INFINITY)
			M.adjustToxLoss(4*REAGENTS_EFFECT_MULTIPLIER, 0)
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	ADD_TRAIT(M, TRAIT_IRONFIST, "[type]")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/henessey/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "[type]")
	REMOVE_TRAIT(M, TRAIT_IRONFIST, "[type]")
	to_chat(M, "<span class='danger'>You feel light-headed as you start to return to your senses.</span>")
	M.Dizzy(5)
	M.blur_eyes(5)
	if(rage)
		QDEL_NULL(rage)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.cure_trauma_type(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/vaulttech
	name = "Vault-Tech Special"
	description = "The only brew, Certified to be drank on duty!"
	color = "#315585"
	boozepwr = 30
	taste_description = "blue and yellow"
	glass_icon_state = "vaulttechglass"
	glass_name = "Vault-Tech Special"
	glass_desc = "The only brew, Certified to be drank on duty!"

/datum/reagent/consumable/ethanol/vaulttech/on_mob_life(mob/living/carbon/M)
	M.dizziness = max(0,M.dizziness-5)
	M.adjustToxLoss(-3, 0)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/vaultboy //yeah this turns you into vault boy if you OD, very HRP
	name = "Vault Boy"
	description = "The beloved mascot of the Vault-Tech corporation in brew form!"
	color = "#315585"
	boozepwr = 40
	taste_description = "your intelligience stat decreasing"
	overdose_threshold = 60
	glass_icon_state = "vaultboyglass"
	glass_name = "Vault Boy"
	glass_desc = "The beloved mascot of the Vault-Tech corporation in brew form!"

/datum/reagent/consumable/ethanol/vaultboy/on_mob_life(mob/living/carbon/M)
	M.dizziness = max(0,M.dizziness-5)
	M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustToxLoss(-2, 0)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/vaultboy/overdose_process(mob/living/M)
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.hair_style = "Business Hair 4"
		H.facial_hair_style = "Shaved"
		H.facial_hair_color = "#FFFF99"
		H.hair_color = "#FFFF99"
		H.update_hair()
		..()
		. = TRUE

/datum/reagent/consumable/ethanol/vaultgirl //praying to god this dosent become "femboy juice"
	name = "Vault Girl"
	description = "Gender equality! You have no idea what this is supposed to represent."
	color = "#315585"
	boozepwr = 40
	taste_description = "your charisma stat increasing"
	overdose_threshold = 60
	glass_icon_state = "vaultgirlglass"
	glass_name = "Vault Girl"
	glass_desc = "Gender equality! You have no idea what this is supposed to represent."

/datum/reagent/consumable/ethanol/vaultgirl/on_mob_life(mob/living/carbon/M)
	M.dizziness = max(0,M.dizziness-5)
	M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustToxLoss(-2, 0)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/vaultboy/overdose_process(mob/living/M)
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.hair_style = "Over Eye"
		H.facial_hair_style = "Shaved"
		H.facial_hair_color = "#FFFF99"
		H.hair_color = "#FFFF99"
		H.update_hair()
		..()
		. = TRUE

/datum/reagent/consumable/ethanol/fernet_cola
	name = "Fernet Cola"
	description = "A very popular and bittersweet digestif, ideal after a heavy meal. Best served on a sawed-off cola bottle as per tradition."
	color = "#390600"
	boozepwr = 30
	taste_description = "smooth caramel, fizzy cola, and bitter herbs"
	glass_icon_state = "godlyblend"
	glass_name = "glass of fernet cola"
	glass_desc = "A sawed-off cola bottle filled with Fernet Cola. Nothing better after eating like a lardass."

/datum/reagent/consumable/ethanol/fernetcola/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.nutrition = max(M.nutrition - 5, 0)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/moonshinez
	name = "Moonshine-Z"
	description = "Extreme moonshine, a lethal mix of moonshine and the most potent spirit known to man."
	color = "#ECE7E5"
	boozepwr = 300
	taste_description = "death"
	glass_icon_state = "moonshinezglass"
	glass_name = "Moonshine-Z"
	glass_desc = "Extreme moonshine, a lethal mix of moonshine and the most potent spirit known to man."

/datum/reagent/consumable/ethanol/corporate
	name = "Corporate"
	description = "The ultimate brand mix of every soda."
	color = "#85785B"
	boozepwr = 10
	taste_description = "brand loyalty"
	glass_icon_state = "corporateglass"
	glass_name = "Corporate"
	glass_desc = "The ultimate brand mix of every soda."

/datum/reagent/consumable/ethanol/corporate/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#006600'><b>Business!</b></font>, <br><font color='#006600'><b>Sales!</b></font>, <br><font color='#006600'><b>Profit!</b></font>")
	if(prob(50))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.Jitter(100)
	M.dizziness +=5
	M.drowsyness = 0
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/ranchwhiskey
	name = "Ranchers Whiskey"
	description = "For them /hard days/ on the ranch."
	color = "#9C5C3A"
	boozepwr = 80
	taste_description = "cowboys"
	glass_icon_state = "rancherwhiskeyglass"
	glass_name = "Ranchers Whiskey"
	glass_desc = "For them /hard days/ on the ranch."

/datum/reagent/consumable/ethanol/ranchwhiskey/on_mob_life(mob/living/carbon/M)
	if(prob(50))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(M, "<span class='notice'>[smoke_message]</span>")
	M.adjustBruteLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustFireLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	M.emote("sigh")
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/spiritcleanser
	name = "Spirit Cleanser"
	description = "Purges your Body and Soul, returning your filth, UNTO GOD."
	color = "#C0DDBC"
	boozepwr = 100
	taste_description = "redemption"
	glass_icon_state = "spiritcleanserglass"
	glass_name = "Spirit Cleanser"
	glass_desc = "Purges your Body and Soul, returning your filth, UNTO GOD."

/datum/reagent/consumable/ethanol/spiritcleanser/on_mob_add(mob/living/M) //spiritual shizzle, also admemes getting booled on
	ADD_TRAIT(M, TRAIT_SPIRITUAL, "[type]")
	if(prob(50))
		M.playsound_local(M, 'sound/f13ambience/bird_6.ogg', 100, 0)
	if(prob(50))
		M.playsound_local(M, 'sound/effects/his_grace_awaken.ogg', 100, 0)
	M.radiation = max(M.radiation-5,0)
	M.adjustToxLoss(-4*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.set_drugginess(100)
	M.hallucination += 100
	..()

/datum/reagent/consumable/ethanol/spiritcleanser/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_SPIRITUAL, "[type]")
	M.set_drugginess(0)
	M.hallucination += 0
	..()
