/atom/movable/screen/text/screen_text/picture
	maptext_x = 0
	maptext_y = 0
	style_open = "<span class='maptext' style=font-size:20pt;text-align:left valign='top'>"
	style_close = "</span>"

	///image that will display on the left of the screen alert
	var/image_file = 'icons/hud/screen_alerts.dmi'
	var/image_state
	///y offset of image
	var/image_to_play_offset_y = 48
	///x offset of image
	var/image_to_play_offset_x = 32

/atom/movable/screen/text/screen_text/picture/Initialize(mapload)
	. = ..()
	overlays += image(image_file, image_state, pixel_y = image_to_play_offset_y, pixel_x = image_to_play_offset_x)

/atom/movable/screen/text/screen_text/picture/hardsuit_visor
	play_delay = 0.4
	style_open = "<span class='maptext' style=font-size:24pt;text-align:center valign='top'>"
	image_state = "exclamation"
