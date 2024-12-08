// Sound testing object. Plays a sound repeatedly
/obj/sound_test
	name = "test"

	var/time = 3 SECONDS
	var/sound_vol = 50
	var/sound_file = 'sound/weapons/gun/pistol/shot.ogg'

/obj/sound_test/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(test)), time, TIMER_LOOP)

/obj/sound_test/proc/test()
	set waitfor = FALSE
	playsound(src, sound_file, sound_vol, FALSE, ignore_walls = sound_file)

/obj/sound_test/defib
	time = 6 SECONDS

/obj/sound_test/defib/test()
	playsound(src, 'sound/machines/defib_charge.ogg', 75, FALSE, ignore_walls = 'sound/machines/defib_charge.ogg')
	sleep(2 SECONDS)
	playsound(src, SFX_BODYFALL, 50, FALSE, ignore_walls = SFX_BODYFALL)
	playsound(src, 'sound/machines/defib_zap.ogg', 75, FALSE, -1, ignore_walls = 'sound/machines/defib_zap.ogg')
	sleep(1.2 SECONDS)
	playsound(src, 'sound/machines/defib_success.ogg', 50, FALSE, -1, ignore_walls = 'sound/machines/defib_success.ogg')

/obj/sound_test/pistol
	time = 3 SECONDS
	sound_vol = 50
	sound_file = 'sound/weapons/gun/pistol/shot.ogg'

/obj/sound_test/pistol/test()
	playsound(src, sound_file, sound_vol, FALSE, falloff_exponent = 1.5, falloff_distance = 7, ignore_walls = sound_file)

/obj/sound_test/punch

/obj/sound_test/punch/test()
	playsound(src, SFX_PUNCH, 25, FALSE, -1, ignore_walls = SFX_PUNCH)

/obj/sound_test/femalescream
	sound_file = 'sound/voice/human/femalescream_2.ogg'
	sound_vol = 50
	time = 5 SECONDS

/obj/sound_test/flashbang
	sound_file = 'sound/weapons/flashbang.ogg'
	sound_vol = 100
	time = 5 SECONDS
