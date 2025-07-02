/datum/quirk/bigleagues
	name = "Big Leagues"
	desc = "Swing for the fences! You deal additional damage with melee weapons."
	value = 3
	mob_trait = TRAIT_BIG_LEAGUES
	gain_text = "<span class='notice'>You feel like swinging for the fences!</span>"
	lose_text = "<span class='danger'>You feel like bunting.</span>"

/datum/quirk/trapper
	name = "Trapper"
	desc = "As an experienced hunter and trapper you know your way around butchering animals for their products, and are able to get twice the usable materials by eliminating waste."
	value = 3
	mob_trait = TRAIT_TRAPPER
	gain_text = "<span class='notice'>You learn the secrets of butchering!</span>"
	lose_text = "<span class='danger'>You forget how to slaughter animals.</span>"

/datum/quirk/bigleagues
	name = "Big Leagues"
	desc = "Swing for the fences! You deal additional damage with melee weapons."
	value = 3
	mob_trait = TRAIT_BIG_LEAGUES
	gain_text = "<span class='notice'>You feel like swinging for the fences!</span>"
	lose_text = "<span class='danger'>You feel like bunting.</span>"

/datum/quirk/chemwhiz
	name = "Chem Whiz"
	desc = "You've been playing around with chemicals all your life. You know how to use chemistry machinery."
	value = 3
	mob_trait = TRAIT_CHEMWHIZ
	gain_text = "<span class='notice'>The mysteries of chemistry are revealed to you.</span>"
	lose_text = "<span class='danger'>You forget how the periodic table works.</span>"

/datum/quirk/hard_yards
	name = "Hard Yards"
	desc = "You've put them in, now reap the rewards."
	value = 3
	mob_trait = TRAIT_HARD_YARDS
	gain_text = "<span class='notice'>Rain or shine, nothing slows you down.</span>"
	lose_text = "<span class='danger'>You walk with a less sure gait, the ground seeming less firm somehow.</span>"

/datum/quirk/iron_fist
	name = "Iron Fist"
	desc = "You have fists of kung-fury! Increases unarmed damage."
	value = 3
	mob_trait = TRAIT_IRONFIST
	gain_text = "<span class='notice'>Your fists feel furious!</span>"
	lose_text = "<span class='danger'>Your fists feel calm again.</span>"

/datum/quirk/iron_fist/on_spawn()
	var/mob/living/carbon/human/mob_tar = quirk_holder
	mob_tar.dna.species.punchdamagelow = 4
	mob_tar.dna.species.punchdamagehigh = 11

/datum/quirk/light_step
	name = "Light Step"
	desc = "You walk with a gentle step, making stepping on sharp objects quieter and less painful."
	value = 3
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = "<span class='notice'>You walk with a little more litheness.</span>"
	lose_text = "<span class='danger'>You start tromping around like a barbarian.</span>"

/datum/quirk/surgerylow
	name = "Minor Surgery"
	desc = "You are a somewhat adequate medical practicioner, capable of performing minor surgery."
	value = 5
	mob_trait = TRAIT_SURGERY_LOW
	gain_text = "<span class='notice'>You feel yourself discovering the basics of the human body.</span>"
	lose_text = "<span class='danger'>You forget how to perform even the simplest surgery.</span>"

/datum/quirk/surgerymid
	name = "Intermediate Surgery"
	desc = "You are a skilled medical practicioner, capable of performing most surgery."
	value = 7
	mob_trait = TRAIT_SURGERY_MID
	gain_text = "<span class='notice'>You feel yourself discovering most of the details of the human body.</span>"
	lose_text = "<span class='danger'>You forget how to perform surgery.</span>"

/datum/quirk/surgeryhigh
	name = "Complex Surgery"
	desc = "You are an expert practicioner, capable of performing almost all surgery."
	value = 10
	mob_trait = TRAIT_SURGERY_HIGH
	gain_text = "<span class='notice'>You feel yourself discovering the most intricate secrets of the human body.</span>"
	lose_text = "<span class='danger'>You forget your advanced surgical knowledge.</span>"
