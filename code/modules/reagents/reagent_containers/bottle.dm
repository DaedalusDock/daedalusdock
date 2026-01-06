//Not to be confused with /obj/item/reagent_containers/cup/glass/bottle

/obj/item/reagent_containers/cup/bottle
	name = "bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	fill_icon_state = "bottle"
	inhand_icon_state = "atoxinbottle"
	worn_icon_state = "bottle"
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 30
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
	update_appearance()

/obj/item/reagent_containers/cup/bottle/epinephrine
	name = "epinephrine bottle"
	desc = "A small bottle. Contains epinephrine - used to stabilize patients."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30)

/obj/item/reagent_containers/cup/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/cup/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	list_reagents = list(/datum/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/cup/bottle/morphine
	name = "morphine bottle"
	desc = "A small bottle of morphine."
	icon = 'icons/obj/chemical.dmi'
	list_reagents = list(/datum/reagent/medicine/morphine = 30)

/obj/item/reagent_containers/cup/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon_state = "bottle20"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 15)

/obj/item/reagent_containers/cup/bottle/alkysine
	name = "alkysine bottle"
	desc = "A small bottle of Alkysine. Useful for healing brain damage."
	list_reagents = list(/datum/reagent/medicine/alkysine = 30)

/obj/item/reagent_containers/cup/bottle/kelotane
	name = "kelotane bottle"
	desc = "A small bottle of kelotane, which helps the body close physical injuries. All effects scale with the amount of reagents in the patient."
	list_reagents = list(/datum/reagent/medicine/kelotane = 30)

/obj/item/reagent_containers/cup/bottle/bicaridine
	name = "bicaridine bottle"
	desc = "A small bottle of bicaridine, which helps heal burns. All effects scale with the amount of reagents in the patient."
	list_reagents = list(/datum/reagent/medicine/bicaridine = 30)

/obj/item/reagent_containers/cup/bottle/dylovene
	name = "dylovene bottle"
	desc = "A small bottle of dylovene, which removes toxins and other chemicals from the bloodstream but causes shortness of breath. All effects scale with the amount of reagents in the patient."
	list_reagents = list(/datum/reagent/medicine/dylovene = 30)

/obj/item/reagent_containers/cup/bottle/ipecac
	name = "ipecac bottle"
	desc = "A small bottle of ipecac, which rapidly induces vomitting to purge the stomach of reagents."
	list_reagents = list(/datum/reagent/medicine/ipecac = 30)

/obj/item/reagent_containers/cup/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/cup/bottle/plasma
	name = "liquid plasma bottle"
	desc = "A small bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/cup/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "A small bottle of synaptizine."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 30)

/obj/item/reagent_containers/cup/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle of ammonia."
	list_reagents = list(/datum/reagent/ammonia = 30)

/obj/item/reagent_containers/cup/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle of diethylamine."
	list_reagents = list(/datum/reagent/diethylamine = 30)

/obj/item/reagent_containers/cup/bottle/facid
	name = "Fluorosulfuric Acid Bottle"
	desc = "A small bottle. Contains a small amount of fluorosulfuric acid."
	list_reagents = list(/datum/reagent/toxin/acid/fluacid = 30)

/obj/item/reagent_containers/cup/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 30)

/obj/item/reagent_containers/cup/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	list_reagents = list(/datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/cup/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	list_reagents = list(/datum/reagent/consumable/frostoil = 30)

/obj/item/reagent_containers/cup/bottle/traitor
	var/extra_reagent = null

/obj/item/reagent_containers/cup/bottle/traitor/Initialize(mapload)
	. = ..()
	extra_reagent = pick(/datum/reagent/toxin/polonium, /datum/reagent/toxin/histamine, /datum/reagent/toxin/venom, /datum/reagent/toxin/fentanyl, /datum/reagent/toxin/cyanide)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/cup/bottle/polonium
	name = "polonium bottle"
	desc = "A small bottle. Contains Polonium."
	list_reagents = list(/datum/reagent/toxin/polonium = 30)

/obj/item/reagent_containers/cup/bottle/venom
	name = "venom bottle"
	desc = "A small bottle. Contains Venom."
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/cup/bottle/fentanyl
	name = "fentanyl bottle"
	desc = "A small bottle. Contains Fentanyl."
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/cup/bottle/adenosine
	name = "adenosine bottle"
	desc = "A small bottle. Contains adenosine."
	list_reagents = list(/datum/reagent/medicine/adenosine = 30)

/obj/item/reagent_containers/cup/bottle/pancuronium
	name = "pancuronium bottle"
	desc = "A small bottle. Contains pancuronium."
	list_reagents = list(/datum/reagent/toxin/pancuronium = 30)

/obj/item/reagent_containers/cup/bottle/sodium_thiopental
	name = "sodium thiopental bottle"
	desc = "A small bottle. Contains sodium thiopental."
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 30)

/obj/item/reagent_containers/cup/bottle/lexorin
	name = "lexorin bottle"
	desc = "A small bottle. Contains lexorin."
	list_reagents = list(/datum/reagent/toxin/lexorin = 30)

/obj/item/reagent_containers/cup/bottle/curare
	name = "curare bottle"
	desc = "A small bottle. Contains curare."
	list_reagents = list(/datum/reagent/toxin/curare = 30)

/obj/item/reagent_containers/cup/bottle/amanitin
	name = "amanitin bottle"
	desc = "A small bottle. Contains amanitin."
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/cup/bottle/histamine
	name = "histamine bottle"
	desc = "A small bottle. Contains Histamine."
	list_reagents = list(/datum/reagent/toxin/histamine = 30)

/obj/item/reagent_containers/cup/bottle/diphenhydramine
	name = "antihistamine bottle"
	desc = "A small bottle of diphenhydramine."
	list_reagents = list(/datum/reagent/medicine/diphenhydramine = 30)

/obj/item/reagent_containers/cup/bottle/potass_iodide
	name = "anti-radiation bottle"
	desc = "A small bottle of potassium iodide."
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 30)

/obj/item/reagent_containers/cup/bottle/saline_glucose
	name = "saline-glucose solution bottle"
	desc = "A small bottle of saline-glucose solution."
	list_reagents = list(/datum/reagent/medicine/saline_glucose = 30)

/obj/item/reagent_containers/cup/bottle/atropine
	name = "atropine bottle"
	desc = "A small bottle of atropine."
	list_reagents = list(/datum/reagent/medicine/atropine = 30)

/obj/item/reagent_containers/cup/bottle/romerol
	name = "romerol bottle"
	desc = "A small bottle of Romerol. The REAL zombie powder."
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/cup/bottle/random_virus
	name = "Experimental disease culture bottle"
	desc = "A small bottle. Contains an untested viral culture in synthblood medium."
	spawned_disease = /datum/pathogen/advance/random

/obj/item/reagent_containers/cup/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	spawned_disease = /datum/pathogen/pierrot_throat

/obj/item/reagent_containers/cup/bottle/cold
	name = "Rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	spawned_disease = /datum/pathogen/advance/cold

/obj/item/reagent_containers/cup/bottle/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	spawned_disease = /datum/pathogen/advance/flu

/obj/item/reagent_containers/cup/bottle/retrovirus
	name = "Retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	spawned_disease = /datum/pathogen/dna_retrovirus

/obj/item/reagent_containers/cup/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/pathogen/gbs

/obj/item/reagent_containers/cup/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	spawned_disease = /datum/pathogen/fake_gbs

/obj/item/reagent_containers/cup/bottle/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon_state = "bottle3"
	spawned_disease = /datum/pathogen/brainrot

/obj/item/reagent_containers/cup/bottle/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	spawned_disease = /datum/pathogen/magnitis

/obj/item/reagent_containers/cup/bottle/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	spawned_disease = /datum/pathogen/wizarditis

/obj/item/reagent_containers/cup/bottle/anxiety
	name = "Severe Anxiety culture bottle"
	desc = "A small bottle. Contains a sample of Lepidopticides."
	spawned_disease = /datum/pathogen/anxiety

/obj/item/reagent_containers/cup/bottle/beesease
	name = "Beesease culture bottle"
	desc = "A small bottle. Contains a sample of invasive Apidae."
	spawned_disease = /datum/pathogen/beesease

/obj/item/reagent_containers/cup/bottle/fluspanish
	name = "Spanish flu culture bottle"
	desc = "A small bottle. Contains a sample of Inquisitius."
	spawned_disease = /datum/pathogen/fluspanish

/obj/item/reagent_containers/cup/bottle/tuberculosis
	name = "Fungal Tuberculosis culture bottle"
	desc = "A small bottle. Contains a sample of Fungal Tubercle bacillus."
	spawned_disease = /datum/pathogen/tuberculosis

/obj/item/reagent_containers/cup/bottle/tuberculosiscure
	name = "BVAK bottle"
	desc = "A small bottle containing Bio Virus Antidote Kit."
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 30)

//Oldstation.dmm chemical storage bottles

/obj/item/reagent_containers/cup/bottle/hydrogen
	name = "hydrogen bottle"
	list_reagents = list(/datum/reagent/hydrogen = 30)

/obj/item/reagent_containers/cup/bottle/lithium
	name = "lithium bottle"
	list_reagents = list(/datum/reagent/lithium = 30)

/obj/item/reagent_containers/cup/bottle/carbon
	name = "carbon bottle"
	list_reagents = list(/datum/reagent/carbon = 30)

/obj/item/reagent_containers/cup/bottle/nitrogen
	name = "nitrogen bottle"
	list_reagents = list(/datum/reagent/nitrogen = 30)

/obj/item/reagent_containers/cup/bottle/oxygen
	name = "oxygen bottle"
	list_reagents = list(/datum/reagent/oxygen = 30)

/obj/item/reagent_containers/cup/bottle/fluorine
	name = "fluorine bottle"
	list_reagents = list(/datum/reagent/fluorine = 30)

/obj/item/reagent_containers/cup/bottle/sodium
	name = "sodium bottle"
	list_reagents = list(/datum/reagent/sodium = 30)

/obj/item/reagent_containers/cup/bottle/aluminium
	name = "aluminium bottle"
	list_reagents = list(/datum/reagent/aluminium = 30)

/obj/item/reagent_containers/cup/bottle/silicon
	name = "silicon bottle"
	list_reagents = list(/datum/reagent/silicon = 30)

/obj/item/reagent_containers/cup/bottle/phosphorus
	name = "phosphorus bottle"
	list_reagents = list(/datum/reagent/phosphorus = 30)

/obj/item/reagent_containers/cup/bottle/sulfur
	name = "sulfur bottle"
	list_reagents = list(/datum/reagent/sulfur = 30)

/obj/item/reagent_containers/cup/bottle/chlorine
	name = "chlorine bottle"
	list_reagents = list(/datum/reagent/chlorine = 30)

/obj/item/reagent_containers/cup/bottle/potassium
	name = "potassium bottle"
	list_reagents = list(/datum/reagent/potassium = 30)

/obj/item/reagent_containers/cup/bottle/iron
	name = "iron bottle"
	list_reagents = list(/datum/reagent/iron = 30)

/obj/item/reagent_containers/cup/bottle/copper
	name = "copper bottle"
	list_reagents = list(/datum/reagent/copper = 30)

/obj/item/reagent_containers/cup/bottle/mercury
	name = "mercury bottle"
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/cup/bottle/radium
	name = "radium bottle"
	list_reagents = list(/datum/reagent/uranium/radium = 30)

/obj/item/reagent_containers/cup/bottle/water
	name = "water bottle"
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/cup/bottle/ethanol
	name = "ethanol bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/cup/bottle/sugar
	name = "sugar bottle"
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/cup/bottle/sacid
	name = "sulfuric acid bottle"
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/cup/bottle/welding_fuel
	name = "welding fuel bottle"
	list_reagents = list(/datum/reagent/fuel = 30)

/obj/item/reagent_containers/cup/bottle/silver
	name = "silver bottle"
	list_reagents = list(/datum/reagent/silver = 30)

/obj/item/reagent_containers/cup/bottle/iodine
	name = "iodine bottle"
	list_reagents = list(/datum/reagent/iodine = 30)

/obj/item/reagent_containers/cup/bottle/thermite
	name = "thermite bottle"
	list_reagents = list(/datum/reagent/thermite = 30)

// Bottles for mail goodies.

/obj/item/reagent_containers/cup/bottle/clownstears
	name = "bottle of distilled clown misery"
	desc = "A small bottle. Contains a mythical liquid used by sublime bartenders; made from the unhappiness of clowns."
	list_reagents = list(/datum/reagent/consumable/clownstears = 30)

/obj/item/reagent_containers/cup/bottle/saltpetre
	name = "saltpetre bottle"
	desc = "A small bottle. Contains saltpetre."
	list_reagents = list(/datum/reagent/saltpetre = 30)

/obj/item/reagent_containers/cup/bottle/flash_powder
	name = "flash powder bottle"
	desc = "A small bottle. Contains flash powder."
	list_reagents = list(/datum/reagent/flash_powder = 30)

/obj/item/reagent_containers/cup/bottle/leadacetate
	name = "lead acetate bottle"
	desc = "A small bottle. Contains lead acetate."
	list_reagents = list(/datum/reagent/toxin/leadacetate = 30)

/obj/item/reagent_containers/cup/bottle/caramel
	name = "bottle of caramel"
	desc = "A bottle containing caramalized sugar, also known as caramel. Do not lick."
	list_reagents = list(/datum/reagent/consumable/caramel = 30)

/obj/item/reagent_containers/cup/bottle/space_cleaner
	name = "bottle of space cleaner"
	desc = "A small bottle. Contains space cleaner."
	list_reagents = list(/datum/reagent/space_cleaner = 30)
