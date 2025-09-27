/datum/chemical_reaction/reagent_explosion
	var/strengthdiv = 10
	var/modifier = 0
	reaction_flags = REACTION_INSTANT
	required_temp = 0 //Prevent impromptu RPGs

/datum/chemical_reaction/reagent_explosion/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	default_explode(holder, created_volume, modifier, strengthdiv)

/datum/chemical_reaction/reagent_explosion/nitroglycerin
	results = list(/datum/reagent/nitroglycerin = 2)
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/toxin/acid/nitracid = 1, /datum/reagent/toxin/acid = 1)
	strengthdiv = 2

/datum/chemical_reaction/reagent_explosion/nitroglycerin/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.remove_reagent(/datum/reagent/nitroglycerin, created_volume*2)
	..()

/datum/chemical_reaction/reagent_explosion/nitroglycerin_explosion
	required_reagents = list(/datum/reagent/nitroglycerin = 1)
	required_temp = 474
	strengthdiv = 2

/datum/chemical_reaction/reagent_explosion/rdx
	results = list(/datum/reagent/rdx = 2)
	required_reagents = list(/datum/reagent/phenol = 2, /datum/reagent/toxin/acid/nitracid = 1, /datum/reagent/acetone = 1, /datum/reagent/oxygen = 1)
	required_catalysts = list(/datum/reagent/gold) //royal explosive
	required_temp = 404
	strengthdiv = 8

/datum/chemical_reaction/reagent_explosion/rdx/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/rdx, created_volume*2)
	..()

/datum/chemical_reaction/reagent_explosion/rdx_explosion
	required_reagents = list(/datum/reagent/rdx = 1)
	required_temp = 474
	strengthdiv = 7
	modifier = 2

/datum/chemical_reaction/reagent_explosion/rdx_explosion2 //makes rdx unique , on its own it is a good bomb, but when combined with liquid electricity it becomes truly destructive
	required_reagents = list(/datum/reagent/rdx = 1 , /datum/reagent/consumable/liquidelectricity = 1)
	strengthdiv = 3.5 //actually a decrease of 1 becaused of how explosions are calculated. This is due to the fact we require 2 reagents
	modifier = 4

/datum/chemical_reaction/reagent_explosion/rdx_explosion2/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/fire_range = round(created_volume/30)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/target as anything in RANGE_TURFS(fire_range,T))
		//new /obj/effect/hotspot(target)
		target.create_fire(1, 10)
	holder.chem_temp = 500
	..()

/datum/chemical_reaction/reagent_explosion/rdx_explosion3/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/fire_range = round(created_volume/20)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf as anything in RANGE_TURFS(fire_range,T))
		turf.create_fire(1, 10)
	holder.chem_temp = 750
	..()

/datum/chemical_reaction/reagent_explosion/tatp
	results = list(/datum/reagent/tatp= 1)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/oxygen = 1, /datum/reagent/toxin/acid/nitracid = 1, /datum/reagent/consumable/ethanol = 1 )
	required_temp = 450
	strengthdiv = 3

/datum/chemical_reaction/reagent_explosion/tatp/update_info()
	required_temp = 450 + rand(-49,49)  //this gets loaded only on round start

/datum/chemical_reaction/reagent_explosion/tatp/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.remove_reagent(/datum/reagent/tatp, created_volume)
	..()

/datum/chemical_reaction/reagent_explosion/tatp_explosion
	required_reagents = list(/datum/reagent/tatp = 1)
	required_temp = 550 // this makes making tatp before pyro nades, and extreme pain in the ass to make
	strengthdiv = 3

/datum/chemical_reaction/reagent_explosion/tatp_explosion/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/strengthdiv_adjust = created_volume / ( 2100 / initial(strengthdiv))
	strengthdiv = max(initial(strengthdiv) - strengthdiv_adjust + 1.5 ,1.5) //Slightly better than nitroglycerin
	. = ..()
	return

/datum/chemical_reaction/reagent_explosion/tatp_explosion/update_info()
	required_temp = 550 + rand(-49,49)

/datum/chemical_reaction/reagent_explosion/potassium_explosion
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	strengthdiv = 20

/datum/chemical_reaction/reagent_explosion/holyboom
	required_reagents = list(/datum/reagent/water/holywater = 1, /datum/reagent/potassium = 1)
	strengthdiv = 20

/datum/chemical_reaction/reagent_explosion/holyboom/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(created_volume >= 150)
		strengthdiv = 8
		///turf where to play sound
		var/turf/T = get_turf(holder.my_atom)
		///special size for anti cult effect
		var/effective_size = round(created_volume/48)
		playsound(T, 'sound/effects/pray.ogg', 80, FALSE, effective_size)
		for(var/mob/living/simple_animal/revenant/R in get_hearers_in_view(7,T))
			var/deity
			if(GLOB.deity)
				deity = GLOB.deity
			else
				deity = "Christ"
			to_chat(R, span_userdanger("The power of [deity] compels you!"))
			R.stun(20)
			R.reveal(100)
			R.adjustHealth(50)
		for(var/mob/living/carbon/C in get_hearers_in_view(effective_size,T))
			if(IS_CULTIST(C))
				to_chat(C, span_userdanger("The divine explosion sears you!"))
				C.Paralyze(40)
				C.adjust_fire_stacks(5)
				C.ignite_mob()
	..()

/datum/chemical_reaction/gunpowder
	results = list(/datum/reagent/gunpowder = 3)
	required_reagents = list(/datum/reagent/saltpetre = 1, /datum/reagent/sulfur = 1)

/datum/chemical_reaction/reagent_explosion/gunpowder_explosion
	required_reagents = list(/datum/reagent/gunpowder = 1)
	required_temp = 474
	strengthdiv = 10
	modifier = 5
	mix_message = "<span class='boldnotice'>Sparks start flying around the gunpowder!</span>"

/datum/chemical_reaction/reagent_explosion/gunpowder_explosion/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	addtimer(CALLBACK(src, PROC_REF(default_explode), holder, created_volume, modifier, strengthdiv), rand(5,10) SECONDS)

/datum/chemical_reaction/thermite
	results = list(/datum/reagent/thermite = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/emp_pulse
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense

/datum/chemical_reaction/emp_pulse/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 12), round(created_volume / 7), 1)
	holder.clear_reagents()


/datum/chemical_reaction/beesplosion
	required_reagents = list(/datum/reagent/consumable/honey = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/uranium/radium = 1)

/datum/chemical_reaction/beesplosion/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = holder.my_atom.drop_location()
	if(created_volume < 5)
		playsound(location,'sound/effects/sparks1.ogg', 100, TRUE)
	else
		playsound(location,'sound/creatures/bee.ogg', 100, TRUE)
		var/list/beeagents = list()
		for(var/R in holder.reagent_list)
			if(required_reagents[R])
				continue
			beeagents += R
		var/bee_amount = round(created_volume * 0.2)
		for(var/i in 1 to bee_amount)
			var/mob/living/simple_animal/hostile/bee/short/new_bee = new(location)
			if(LAZYLEN(beeagents))
				new_bee.assign_reagent(pick(beeagents))


/datum/chemical_reaction/stabilizing_agent
	results = list(/datum/reagent/stabilizing_agent = 3)
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/oxygen = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/clf3
	results = list(/datum/reagent/clf3 = 4)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/fluorine = 3)
	required_temp = 424
	overheat_temp = 1050

/datum/chemical_reaction/clf3/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/target as anything in RANGE_TURFS(1,T))
		//new /obj/effect/hotspot(target)
		target.create_fire(1, 10)
	holder.chem_temp = 1000 // hot as shit

/datum/chemical_reaction/reagent_explosion/methsplosion
	required_temp = 380 //slightly above the meth mix time.
	required_reagents = list(/datum/reagent/drug/methamphetamine = 1)
	strengthdiv = 12
	modifier = 5
	mob_react = FALSE

/datum/chemical_reaction/reagent_explosion/methsplosion/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/target in RANGE_TURFS(1,T))
		//new /obj/effect/hotspot(target)
		target.create_fire(1, 10)
	holder.chem_temp = 1000 // hot as shit
	..()

/datum/chemical_reaction/reagent_explosion/methsplosion/methboom2
	required_reagents = list(/datum/reagent/diethylamine = 1, /datum/reagent/iodine = 1, /datum/reagent/phosphorus = 1, /datum/reagent/hydrogen = 1) //diethylamine is often left over from mixing the ephedrine.
	required_temp = 300 //room temperature, chilling it even a little will prevent the explosion

/datum/chemical_reaction/sorium
	results = list(/datum/reagent/sorium = 4)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/nitrogen = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/sorium/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sorium, created_volume*4)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume*4), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/sorium_vortex
	required_reagents = list(/datum/reagent/sorium = 1)
	required_temp = 474

/datum/chemical_reaction/sorium_vortex/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/liquid_dark_matter
	results = list(/datum/reagent/liquid_dark_matter = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/liquid_dark_matter/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/liquid_dark_matter, created_volume*3)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume*3), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/ldm_vortex
	required_reagents = list(/datum/reagent/liquid_dark_matter = 1)
	required_temp = 474

/datum/chemical_reaction/ldm_vortex/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume/2), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/flash_powder
	results = list(/datum/reagent/flash_powder = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/flash_powder/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = created_volume/3
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2))
	for(var/mob/living/C in get_hearers_in_view(range, location))
		if(C.flash_act(affect_silicon = TRUE))
			if(get_dist(C, location) < 4)
				C.Paralyze(60)
			else
				C.Stun(100)
	holder.remove_reagent(/datum/reagent/flash_powder, created_volume*3)

/datum/chemical_reaction/flash_powder_flash
	required_reagents = list(/datum/reagent/flash_powder = 1)
	required_temp = 374

/datum/chemical_reaction/flash_powder_flash/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = created_volume/10
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2))
	for(var/mob/living/C in get_hearers_in_view(range, location))
		if(C.flash_act(affect_silicon = TRUE))
			if(get_dist(C, location) < 4)
				C.Paralyze(60)
			else
				C.Stun(100)

/datum/chemical_reaction/smoke_powder
	results = list(/datum/reagent/smoke_powder = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/smoke_powder/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/smoke_powder, created_volume*3)
	var/smoke_radius = round(sqrt(created_volume * 1.5), 1)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/fluid_spread/smoke/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, TRUE, -3)
	if(S)
		S.set_up(smoke_radius, location = location, carry = holder, silent = FALSE)
		S.start()
	if(holder?.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/smoke_powder_smoke
	required_reagents = list(/datum/reagent/smoke_powder = 1)
	required_temp = 374
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/smoke_powder_smoke/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	var/smoke_radius = round(sqrt(created_volume / 2), 1)
	var/datum/effect_system/fluid_spread/smoke/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, TRUE, -3)
	if(S)
		S.set_up(smoke_radius, location = location, carry = holder, silent = FALSE)
		S.start()
	if(holder?.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/sonic_powder
	results = list(/datum/reagent/sonic_powder = 3)
	required_reagents = list(/datum/reagent/oxygen = 1, /datum/reagent/consumable/space_cola = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/sonic_powder/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sonic_powder, created_volume*3)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, TRUE)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/3, location))
		C.soundbang_act(1, 100, rand(0, 5))

/datum/chemical_reaction/sonic_powder_deafen
	required_reagents = list(/datum/reagent/sonic_powder = 1)
	required_temp = 374

/datum/chemical_reaction/sonic_powder_deafen/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, TRUE)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		C.soundbang_act(1, 100, rand(0, 5))

/datum/chemical_reaction/phlogiston
	results = list(/datum/reagent/phlogiston = 3)
	required_reagents = list(/datum/reagent/phosphorus = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/stable_plasma = 1)

/datum/chemical_reaction/phlogiston/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/turf/open/T = get_turf(holder.my_atom)
	if(istype(T))
		T.atmos_spawn_air(GAS_PLASMA, created_volume, 1000)
	holder.clear_reagents()
	return

/datum/chemical_reaction/napalm
	results = list(/datum/reagent/napalm = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/consumable/ethanol = 1 )

/datum/chemical_reaction/pyrosium_oxygen
	results = list(/datum/reagent/pyrosium = 1)
	required_reagents = list(/datum/reagent/pyrosium = 1, /datum/reagent/oxygen = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/pyrosium_oxygen/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.expose_temperature(holder.chem_temp + (10 * created_volume), 1)

/datum/chemical_reaction/pyrosium
	results = list(/datum/reagent/pyrosium = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/phosphorus = 1)
	required_temp = 0
	optimal_temp = 20
	overheat_temp = NO_OVERHEAT
	temp_exponent_factor = 10
	thermic_constant = 0

/datum/chemical_reaction/pyrosium/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.expose_temperature(20, 1) // also cools the fuck down

/datum/chemical_reaction/reagent_explosion/nitrous_oxide
	required_reagents = list(/datum/reagent/nitrous_oxide = 1)
	strengthdiv = 9
	required_temp = 575
	modifier = 1

/datum/chemical_reaction/reagent_explosion/nitrous_oxide/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.remove_reagent(/datum/reagent/sorium, created_volume*2)
	var/turf/turfie = get_turf(holder.my_atom)
	//generally half as strong as sorium.
	var/range = clamp(sqrt(created_volume*2), 1, 6)
	//This first throws people away and then it explodes
	goonchem_vortex(turfie, 1, range)
	turfie.atmos_spawn_air(GAS_OXYGEN, created_volume/2, 575)
	turfie.atmos_spawn_air(GAS_NITROGEN, created_volume/2, 575)
	return ..()

/datum/chemical_reaction/firefighting_foam
	results = list(/datum/reagent/firefighting_foam = 3)
	required_reagents = list(/datum/reagent/stabilizing_agent = 1,/datum/reagent/fluorosurfactant = 1,/datum/reagent/carbon = 1)
	required_temp = 200
	is_cold_recipe = 1
	optimal_temp = 50
	overheat_temp = 5
	thermic_constant= -1

/datum/chemical_reaction/reagent_explosion/patriotism_overload
	required_reagents = list(/datum/reagent/consumable/ethanol/planet_cracker = 1, /datum/reagent/consumable/ethanol/triumphal_arch = 1)
	strengthdiv = 20
	mix_message = "<span class='boldannounce'>The two patriotic drinks instantly reject each other!</span>"
