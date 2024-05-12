/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = FALSE
	armor_flag = PUNCTURE
	hitsound_wall = SFX_RICOCHET
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=20, fall_chance=0, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	embed_adjustment_tile = 3

	light_system = OVERLAY_LIGHT
	light_outer_range = 1.5
	light_power = 2
	light_color = COLOR_VERY_SOFT_YELLOW
	light_on = TRUE

/obj/projectile/bullet/smite
	name = "divine retribution"
	damage = 10
