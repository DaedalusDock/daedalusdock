/particles/debris
	icon = 'icons/effects/particles/generic.dmi'
	width = 500
	height = 500
	count = 10
	spawning = 10
	lifespan = 0.7 SECONDS
	fade = 0.4 SECONDS
	drift = generator(GEN_CIRCLE, 0, 7)
	scale = 0.7
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.15)
	spin = generator(GEN_NUM, -20, 20)

/particles/impact_smoke
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 0.7 SECONDS
	fade = 8 SECONDS
	grow = 0.1
	scale = 0.2
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.5)
