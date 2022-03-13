/proc/get_sfx_pariah(soundin)
	if(istext(soundin))
		switch(soundin)
			if(SFX_KEYBOARD)
				soundin = pick(
					'modular_pariah/modules/aesthetics/computer/sound/keypress1.ogg',
					'modular_pariah/modules/aesthetics/computer/sound/keypress2.ogg',
					'modular_pariah/modules/aesthetics/computer/sound/keypress3.ogg',
					'modular_pariah/modules/aesthetics/computer/sound/keypress4.ogg',
					'modular_pariah/modules/aesthetics/computer/sound/keystroke4.ogg',
				)
	return soundin
