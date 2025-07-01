///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps
	var/select = FALSE
	var/time_per_page = 5 SECONDS

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/effects/pageturn1.ogg','sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'), 30, 1)
	if(do_after(user,50, TRUE, user))
		if(remarks.len)
			to_chat(user, "<span class='notice'>[pick(remarks)]</span>")
		else
			to_chat(user, "<span class='notice'>You keep reading...</span>")
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading [name]...</span>")

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, "<span class='notice'>You stop reading...</span>")

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You finish reading [name]!</span>")

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/user)
	//if(user.special_i<5&&!istype(src,/obj/item/book/granter/trait/selection))//SPECIAL Integration
	//	to_chat(user, "<span class='warning'>You feel like you are too stupid to understand this.</span>")
	//	return
	if(reading)
		to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	if(already_known(user))
		return FALSE
	if(used && oneuse)
		recoil(user)
	else
		on_reading_start(user)
		reading = TRUE
		for(var/i in 1 to pages_to_mastery)
			if(!turn_page(user))
				on_reading_stopped()
				reading = FALSE
				return
		if(do_after(user, time_per_page, TRUE, user))
			on_reading_finished(user)
		reading = FALSE
	return TRUE
///TRAITS///

/obj/item/book/granter/trait
	var/granted_trait
	var/traitname = "being cool"
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/trait/already_known(mob/user)
	if(!granted_trait)
		return TRUE
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, "<span class ='notice'>You already have all the insight you need about [traitname].")
		return TRUE
	return FALSE

/obj/item/book/granter/trait/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about [traitname]...</span>")

/obj/item/book/granter/trait/on_reading_finished(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>You feel like you've got a good handle on [traitname]!</span>")
	ADD_TRAIT(user, granted_trait, BOOK_TRAIT)
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,"<span class='notice'>You learned how to make [initial(R.name)].</span>")
	onlearned(user)

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, "<span class='notice'>You already know all about [actionname].</span>")
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about [actionname]...</span>")

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You feel like you've got a good handle on [actionname]!</span>")
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

/obj/item/book/granter/trait/onlearned(mob/living/user)
	..()
	if(oneuse)
		user.visible_message("<span class='caution'>[src] is useless to you now. You throw the book away.</span>")
		qdel(src)

///SPELLS///

/obj/item/book/granter/spell
	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/action/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			if(user.mind)
				if(iswizard(user))
					to_chat(user,"<span class='notice'>You're already far more versed in this spell than this flimsy how-to book can provide.</span>")
				else
					to_chat(user,"<span class='notice'>You've already read this one.</span>")
			return TRUE
	return FALSE

/obj/item/book/granter/action/spell/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading about casting [spellname]...</span>")

/obj/item/book/granter/action/spell/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You feel like you've experienced enough to cast [spellname]!</span>")
	var/obj/effect/proc_holder/spell/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/action/spell/recoil(mob/user)
	user.visible_message("<span class='warning'>[src] glows in a black light!</span>")

/obj/item/book/granter/action/spell/onlearned(mob/user)
	..()
	if(oneuse)
		user.visible_message("<span class='caution'>[src] glows dark for a second!</span>")

/obj/item/book/granter/action/spell/fireball
	spell = /obj/effect/proc_holder/spell/aimed/fireball
	spellname = "fireball"
	icon_state ="bookfireball"
	desc = "This book feels warm to the touch."
	remarks = list("Aim...AIM, FOOL!", "Just catching them on fire won't do...", "Accounting for crosswinds... really?", "I think I just burned my hand...", "Why the dumb stance? It's just a flick of the hand...", "OMEE... ONI... Ugh...", "What's the difference between a fireball and a pyroblast...")

/obj/item/book/granter/action/spell/fireball/recoil(mob/user)
	..()
	explosion(user.loc, 1, 0, 2, 3, FALSE, FALSE, 2)
	qdel(src)

// MARTIAL ARTS

/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "old manual"
	martialname = "close quarters combat"
	desc = "A small, black manual. There are drawn instructions of tactical hand-to-hand combat."
	greet = "<span class='boldannounce'>You've mastered the basics of CQC.</span>"
	icon_state = "cqcmanual"
	remarks = list("Kick... Slam...", "Lock... Kick...", "Strike their abdomen, neck and back for critical damage...", "Slam... Lock...", "I could probably combine this with some other martial arts!", "Words that kill...", "The last and final moment is yours...")

/obj/item/book/granter/martial/cqc/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		to_chat(user, "<span class='warning'>[src] beeps ominously...</span>")

/obj/item/book/granter/martial/cqc/recoil(mob/living/carbon/user)
	to_chat(user, "<span class='warning'>[src] explodes!</span>")
	playsound(src,'sound/effects/explosion1.ogg',40,1)
	user.flash_act(1, 1)
	user.adjustBruteLoss(6)
	user.adjustFireLoss(6)
	qdel(src)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list() //Use full /datum/crafting_recipe/what_you_craft

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,"<span class='notice'>You learned how to make [initial(R.name)].</span>")
	onlearned(user)

/obj/item/book/granter/crafting_recipe/onlearned(mob/living/user)
	..()
	if(oneuse)
		user.visible_message("<span class='caution'>[src] is useless to you now. You throw it away.</span>")
		qdel(src)

/obj/item/book/granter/crafting_recipe/gunsmith_one
	name = "Guns and Bullets, Part 1"
	desc = "A rare issue of Guns and Bullets detailing the basic manufacture of firearms, allowing the reader to craft firearms. It's barely holding up, and looks like only one person can study the knowledge from it."
	icon_state = "gab1"
	oneuse = TRUE
	remarks = list("Always keep your gun well lubricated...", "Keep your barrel free of grime...", "Perfect fitment is the key to a good firearm...", "Maintain a proper trigger pull length...", "Keep your sights zeroed to proper range...")
	crafting_recipe_types = list(/datum/crafting_recipe/ninemil, /datum/crafting_recipe/huntingrifle)

/obj/item/book/granter/crafting_recipe/gunsmith_two
	name = "Guns and Bullets, Part 2"
	desc = "A rare issue of Guns and Bullets following up Part 1, going further indepth into weapon mechanics, allowing the reader to craft certain firearms. It's barely holding up, and looks like only one person can study the knowledge from it."
	icon_state = "gab2"
	oneuse = TRUE
	remarks = list("Always keep your gun well lubricated...", "Keep your barrel free of grime...", "Perfect fitment is the key to a good firearm...", "Maintain a proper trigger pull length...", "Keep your sights zeroed to proper range...")
	crafting_recipe_types = list(/datum/crafting_recipe/n99, /datum/crafting_recipe/huntingrifle, /datum/crafting_recipe/m1911, /datum/crafting_recipe/varmintrifle, /datum/crafting_recipe/colt6520)

/obj/item/book/granter/crafting_recipe/gunsmith_three
	name = "Guns and Bullets, Part 3"
	desc = "A rare issue of Guns and Bullets following up Part 2, explaining difficult ballistics theory and weapon mechanics, allowing the reader to craft weapon attachments. It's barely holding up, and looks like only one person can study the knowledge from it."
	icon_state = "gab3"
	oneuse = TRUE
	remarks = list("Always keep your gun well lubricated...", "Keep your barrel free of grime...", "Perfect fitment is the key to a good firearm...", "Maintain a proper trigger pull length...", "Keep your sights zeroed to proper range...")
	crafting_recipe_types = list(/datum/crafting_recipe/scope, /datum/crafting_recipe/suppressor, /datum/crafting_recipe/burst_improvement, /datum/crafting_recipe/recoil_decrease)

/obj/item/book/granter/crafting_recipe/gunsmith_four
	name = "Guns and Bullets, Part 4"
	desc = "An extremely rare issue of Guns and Bullets, showing some design flaws of weapons and how to rectify them. It's barely holding up, and looks like only one person can study the knowledge from it."
	icon_state = "gab4"
	oneuse = TRUE
	remarks = list("Always keep your gun well lubricated...", "Keep your barrel free of grime...", "Perfect fitment is the key to a good firearm...", "Maintain a proper trigger pull length...", "Keep your sights zeroed to proper range...")
	//crafting_recipe_types = list(/datum/crafting_recipe/flux, /datum/crafting_recipe/lenses, /datum/crafting_recipe/conductors, /datum/crafting_recipe/receiver, /datum/crafting_recipe/assembly, /datum/crafting_recipe/alloys)

// New Blueprints, yay! -Superballs
/obj/item/book/granter/crafting_recipe/blueprint
	name = "blueprint"
	icon = 'modular_fallout/master_files/icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	desc = "A detailed schematic for crafting an item."
	w_class = WEIGHT_CLASS_TINY
	oneuse = TRUE
	remarks = list()

/obj/item/book/granter/crafting_recipe/blueprint/r82
	name = "r82 heavy service rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/R82)

/obj/item/book/granter/crafting_recipe/blueprint/marksman
	name = "marksman carbine blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/marksmancarbine)

/obj/item/book/granter/crafting_recipe/blueprint/r84
	name = "r84 lmg blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/lmg)

/obj/item/book/granter/crafting_recipe/blueprint/service
	name = "service rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/servicerifle)

/obj/item/book/granter/crafting_recipe/blueprint/aep7
	name = "aep7 blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/AEP7)

/obj/item/book/granter/crafting_recipe/blueprint/leveraction
	name = "lever action shotgun blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/lever_action)

/obj/item/book/granter/crafting_recipe/blueprint/trailcarbine
	name = "trail carbine blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/trail_carbine)

/obj/item/book/granter/crafting_recipe/blueprint/thatgun
	name = ".223 pistol blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/thatgun)

/obj/item/book/granter/crafting_recipe/blueprint/plasmapistol
	name = "plasma pistol blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/plasmapistol)

/obj/item/book/granter/crafting_recipe/blueprint/uzi
	name = "mini uzi blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/uzi)

/obj/item/book/granter/crafting_recipe/blueprint/smg10mm
	name = "10mm smg blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/smg10mm)

/obj/item/book/granter/crafting_recipe/blueprint/greasegun
	name = "m3a1 grease gun blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/grease_gun)

/obj/item/book/granter/crafting_recipe/blueprint/brushgun
	name = "brush gun blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/brush)

/obj/item/book/granter/crafting_recipe/blueprint/r91
	name = "r91 assault rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/r91)

/obj/item/book/granter/crafting_recipe/blueprint/riotshotgun
	name = "riot shotgun blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/riotshotgun)

/obj/item/book/granter/crafting_recipe/blueprint/sniper
	name = "sniper rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/sniper)

/obj/item/book/granter/crafting_recipe/blueprint/deagle
	name = "desert eagle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/deagle)

/obj/item/book/granter/crafting_recipe/blueprint/aer9
	name = "aer9 blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/AER9)

/obj/item/book/granter/crafting_recipe/blueprint/plasmarifle
	name = "plasma rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/plasmarifle)

/obj/item/book/granter/crafting_recipe/blueprint/tribeam
	name = "tribeam laser rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/tribeam)

/obj/item/book/granter/crafting_recipe/blueprint/am_rifle
	name = "anti-materiel rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/am_rifle)

/obj/item/book/granter/crafting_recipe/blueprint/citykiller
	name = "citykiller blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/city_killer)

/obj/item/book/granter/crafting_recipe/blueprint/rangemaster
	name = "colt rangemaster blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/rangemaster)

/obj/item/book/granter/crafting_recipe/blueprint/bozar
	name = "bozar blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/bozar)

/obj/item/book/granter/crafting_recipe/blueprint/m1garand
	name = "battle rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/m1garand)

/obj/item/book/granter/crafting_recipe/blueprint/infiltrator
	name = "infiltrator blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/infiltrator)

/obj/item/book/granter/crafting_recipe/blueprint/lsw
	name = "lsw blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/gun/lsw)

/obj/item/book/granter/crafting_recipe/blueprint/m1carbine
	name = "m1 carbine blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/m1carbine)

/obj/item/book/granter/crafting_recipe/blueprint/pps
	name = "ppsh-41 blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/pps)

/obj/item/book/granter/crafting_recipe/blueprint/commando
	name = "commando carbine blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/commando)

/obj/item/book/granter/crafting_recipe/blueprint/trapper
	name = "guide to minelaying"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/shrapnelmine)

/*
/obj/item/book/granter/crafting_recipe/blueprint/fnfal
	name = "fn fal blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/fnfal)

/obj/item/book/granter/crafting_recipe/blueprint/caws
	name = "h&k caws blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/caws)
*/

/obj/item/book/granter/crafting_recipe/blueprint/scoutcarbine
	name = "scout carbine blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/scoutcarbine)

/obj/item/book/granter/crafting_recipe/blueprint/neostead
	name = "neostead 2000 blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/neostead)

/obj/item/book/granter/crafting_recipe/blueprint/gauss
	name = "gauss rifle blueprint"
	icon_state = "blueprint2"
	crafting_recipe_types = list(/datum/crafting_recipe/gaussrifle)

/obj/item/book/granter/crafting_recipe/manual/denvr
	name = "den vr configuration"
	icon_state = "book"
	remarks = list("Never make dreams...", "Don't pick from an empty list...", "Runtimes are not good for cardio...", "Report an issue to a nearby technician, and expect to be told to post it to their terminal...", "Probably don't adjust the default safety settings.", "Clean up any messes left in the pod before the next use.")
	crafting_recipe_types = list(/datum/crafting_recipe/set_vrboard/den)

/obj/item/book/granter/trait/chemistry
	name = "Big Book of Science"
	desc = "This heavy textbook can teach basic chemistry, but saw more use as a blunt weapon shortly after the Collapse."
	oneuse = TRUE
	granted_trait = TRAIT_CHEMWHIZ
	traitname = "chemistry"
	remarks = list("Always ensure a safe working environment, promptly clean any chemical mess.", "Improperly stored chemicals can quickly lead to safety hazards.", "Do not abuse chemicals for recreational use in the laboratory!", "Labcoats and goggles not only protect you from burns, but give an aura of authority.", "Keep your laboratory clean and organized, utilize cabinets and shelves.", "Potassium and water should not be mixed, or they will react violently.")
	crafting_recipe_types = list(/datum/crafting_recipe/jet, /datum/crafting_recipe/turbo, /datum/crafting_recipe/psycho, /datum/crafting_recipe/medx, /datum/crafting_recipe/buffout)

/obj/item/book/granter/trait/bigleagues
	name = "Grognak the Barbarian"
	desc = "A pulp fiction paperback detailing the adventures of a violent barbarian. Surprisingly, this was sold to children."
	oneuse = TRUE
	granted_trait = TRAIT_BIG_LEAGUES
	traitname = "big_leagues"
	remarks = list("Grognak hit the Death Knight only once, but that was enough.", "Grognak is surprisingly agile, never committing too heavily on an attack, dancing between his enemies.", "Grognak isn't good at talking, but he knows it has its place. He has friends to talk for him.", "Other barbarians might change their weapons, but Grognak could never leave his beloved axe.")

/obj/item/book/granter/trait/lowsurgery
	name = "First Aid Pamphlet"
	desc = "A flimsy collection of vital tips and tricks for the average American with a sudden injury."
	oneuse = TRUE
	granted_trait = TRAIT_SURGERY_LOW
	traitname = "minor surgery"
	remarks = list("Keep your hands and any injuries clean!", "While bandages help to seal a wound, they do not heal a wound.", "Remain calm, focus on the task at hand, stop the bleeding.", "An open wound can lead to easy infection of said wound.", "Keep track of your home's first aid kit, restock used components regularly.", "If a body part has been lost, ice and transport it with the injured to a hospital.",)

/obj/item/book/granter/trait/lowsurgery/already_known(mob/user)
	if(HAS_TRAIT(user, TRAIT_SURGERY_MID) || HAS_TRAIT(user, TRAIT_SURGERY_HIGH))
		to_chat(user, "<span class ='notice'>This book is too basic for you!")
		return TRUE
	return ..()

/obj/item/book/granter/trait/midsurgery
	name = "D.C. Journal of Internal Medicine"
	desc = "A nearly intact guide on surgery for pre-collapse medical students and physicians."
	oneuse = TRUE
	granted_trait = TRAIT_SURGERY_MID
	traitname = "intermediate surgery"
	remarks = list("Sterilization is essential before and after surgery.", "Keep track of all your tools, double check body cavities.", "Ensure complete focus while operating on the patient.", "Cauterize incisions once the operation concludes.", "Spare organs and blood must be kept at a low temperature.", "Most prosthesis come with significant trade-offs, and maintenance costs.",)

/obj/item/book/granter/trait/midsurgery/already_known(mob/user)
	if(HAS_TRAIT(user, TRAIT_SURGERY_HIGH))
		to_chat(user, "<span class ='notice'>This book is too basic for you!")
		return TRUE
	return ..()

/obj/item/book/granter/trait/techno
	name = "Dean's Electronics"
	desc = "A study book on the field of electronics. A note on the cover says that it is for the budding young electrician in everyone!"
	oneuse = TRUE
	granted_trait = TRAIT_TECHNOPHREAK
	traitname = "craftsmanship"
	remarks = list("Troubleshooting is a systematic approach to problem solving, do not skip any steps in the process.", "Ensure you have all the required parts before you begin.", "Always wear personal protective equipment, electric shock can be fatal.", "Combustibles and sparks do not mix, store welding fuel in a safe location.", "Don't lose track of your tools, or you have a new problem to deal with.")

/obj/item/book/granter/trait/trekking
	name = "Wasteland Survival Guide"
	desc = "This indispensable guidebook contains everything that a survivor in the wasteland would need to know."
	oneuse = TRUE
	granted_trait = TRAIT_HARD_YARDS
	traitname = "trekking"
	remarks = list("Tribes and gangs often hide the best loot in the back room.", "Radiation is best avoided entirely, but it helps to carry spare rad-x.", "Whether ancient or recent, landmines are still a threat, and readers should look out for them.", "Injuries and open bleeding make it harder to travel, always carry spare medical supplies.", "Most animals are simple-minded, and can be led into easy lines of fire.")

/obj/item/book/granter/trait/gunslinger
	name = "Tycho: Life of a Lawman"
	desc = "The memoirs of a self-acclaimed companion to a mythical folk hero, between the blustering and tales of Texas Rangers there are snippets of useful information."
	oneuse = TRUE
	granted_trait = TRAIT_NICE_SHOT
	traitname = "gunslinging"
	remarks = list("Engravings offer no tactical advantage whatsoever!", "I love to reload during battle.", "There's nothing like the feeling of slamming a long silver bullet into a well greased chamber.", "It doesn't feel right to shoot an unarmed man, but you get over it.", "He was pretty good, but I was better. At least, so I thought.", "The moment any truth is passed on, it starts turning into fiction. The problem is, fiction inspires people more than facts.")


/*
/obj/item/book/granter/trait/iron_fist
	name = "Brawler's Guide to Fisticuffs"
	desc = "An advanced manual on fistfighting. It has pictures, too!"
	oneuse = TRUE
	granted_trait = TRAIT_IRONFIST
	traitname = "punching"
	remarks = list("Keep your fists up...", "Don't clench your thumb in your fist, or you might break it...", "Turn into your punch, and put your body weight behind it...", "Footwork is everything, make sure to step into your punches...", "Aim for their jaw for an easy K-O...")
*/

/obj/item/book/granter/trait/medical
	name = "Medical Booklet"
	desc = "An instruction manual on basic medicine!"
	granted_trait = null
	pages_to_mastery = 0
	time_per_page = 0

/obj/item/book/granter/trait/medical/attack_self(mob/user)
	var/list/choices = list("Big Book of Science","First Aid Pamphlet")
	if(granted_trait == null)
		var/choice = input("Choose a trait:") in choices
		switch(choice)
			if(null)
				return 0
			if("First Aid Pamphlet")
				granted_trait = TRAIT_SURGERY_LOW
				traitname = "minor surgery"
				remarks = list("Keep your hands and any injuries clean!", "While bandages help to seal a wound, they do not heal a wound.", "Remain calm, focus on the task at hand, stop the bleeding.", "An open wound can lead to easy infection of said wound.", "Keep track of your home's first aid kit, restock used components regularly.", "If a body part has been lost, ice and transport it with the injured to a hospital.",)
			if("Big Book of Science")
				granted_trait = TRAIT_CHEMWHIZ
				traitname = "chemistry"
				remarks = list("Always ensure a safe working environment, promptly clean any chemical mess.", "Improperly stored chemicals can quickly lead to safety hazards.", "Do not abuse chemicals for recreational use in the laboratory!", "Labcoats and goggles not only protect you from burns, but give an aura of authority.", "Keep your laboratory clean and organized, utilize cabinets and shelves.", "Potassium and water should not be mixed, or they will react violently.")
	return ..()


/obj/item/book/granter/trait/medical/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)


/obj/item/book/granter/trait/selection
	name = "Burned Book"
	desc = "Pulled from the ashes of the old world, it feels warm to the touch. It looks to be in poor condition."
	granted_trait = null
	pages_to_mastery = 0
	time_per_page = 0

/obj/item/book/granter/trait/selection/attack_self(mob/user)
	var/list/choices = list("Big Book of Science","Dean's Electronics","Grognak the Barbarian","First Aid Pamphlet","Wasteland Survival Guide")
	if(granted_trait == null)
		var/choice = input("Choose a trait:") in choices
		switch(choice)
			if(null)
				return 0
			if("Wasteland Survival Guide")
				granted_trait = TRAIT_HARD_YARDS
				traitname = "trekking"
				remarks = list("Tribes and gangs often hide the best loot in the back room.", "Radiation is best avoided entirely, but it helps to carry spare rad-x.", "Whether ancient or recent, landmines are still a threat, and readers should look out for them.", "Injuries and open bleeding make it harder to travel, always carry spare medical supplies.", "Most animals are simple-minded, and can be led into easy lines of fire.")
			if("First Aid Pamphlet")
				granted_trait = TRAIT_SURGERY_LOW
				traitname = "minor surgery"
				remarks = list("Keep your hands and any injuries clean!", "While bandages help to seal a wound, they do not heal a wound.", "Remain calm, focus on the task at hand, stop the bleeding.", "An open wound can lead to easy infection of said wound.", "Keep track of your home's first aid kit, restock used components regularly.", "If a body part has been lost, ice and transport it with the injured to a hospital.",)
			if("Big Book of Science")
				granted_trait = TRAIT_CHEMWHIZ
				traitname = "chemistry"
				remarks = list("Always ensure a safe working environment, promptly clean any chemical mess.", "Improperly stored chemicals can quickly lead to safety hazards.", "Do not abuse chemicals for recreational use in the laboratory!", "Labcoats and goggles not only protect you from burns, but give an aura of authority.", "Keep your laboratory clean and organized, utilize cabinets and shelves.", "Potassium and water should not be mixed, or they will react violently.")
			if("Dean's Electronics")
				granted_trait = TRAIT_TECHNOPHREAK
				traitname = "craftsmanship"
				remarks = list("Troubleshooting is a systematic approach to problem solving, do not skip any steps in the process.", "Ensure you have all the required parts before you begin.", "Always wear personal protective equipment, electric shock can be fatal.", "Combustibles and sparks do not mix, store welding fuel in a safe location.", "Don't lose track of your tools, or you have a new problem to deal with.")
			if("Grognak the Barbarian")
				granted_trait = TRAIT_BIG_LEAGUES
				traitname = "hitting things"
				remarks = list("Grognak hit the Death Knight only once, but that was enough.", "Grognak is surprisingly agile, never committing too heavily on an attack, dancing between his enemies.", "Grognak isn't good at talking, but he knows it has its place. He has friends to talk for him.", "Other barbarians might change their weapons, but Grognak could never leave his beloved axe.")
	return ..()


/obj/item/book/granter/trait/selection/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
