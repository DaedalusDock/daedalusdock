/proc/get_sfx_pariah(soundin)
	if(istext(soundin))
		switch(soundin)
			if(SFX_GLASS_CRACK)
				soundin = pick(
					'modular_pariah/master_files/sound/effects/glass_crack1.ogg',
					'modular_pariah/master_files/sound/effects/glass_crack2.ogg',
					'modular_pariah/master_files/sound/effects/glass_crack3.ogg',
					'modular_pariah/master_files/sound/effects/glass_crack4.ogg',
				)

	return soundin
