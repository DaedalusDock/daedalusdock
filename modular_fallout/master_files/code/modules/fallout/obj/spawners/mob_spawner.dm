/obj/effect/mob_spawner
	name = "mob spawner"
	icon = 'modular_fallout/master_files/icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	invisibility = 100
	var/mob_type

/obj/effect/mob_spawner/gecko
	name = "geckos spawner"
	mob_type = /mob/living/simple_animal/hostile/gecko

/obj/effect/mob_spawner/molerat
	name = "molerats spawner"
	mob_type = /mob/living/simple_animal/hostile/molerat

/obj/effect/mob_spawner/cazador
	name = "cazadors spawner"
	mob_type = /mob/living/simple_animal/hostile/cazador
