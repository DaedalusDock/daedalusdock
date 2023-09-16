
/proc/button_element(trg, text, action, class, style)
	return "<a href='?src=\ref[trg];[action]'[class ? "class='[class]'" : ""][style ? "style='[style]'" : ""]>[text]</a>"

/proc/color_button_element(trg, color, action)
	return "<a href='?src=\ref[trg];[action]' class='box' style='background-color: [color]'></a>"

/datum/preferences/proc/update_html()
	usr << output(url_encode(html_create_window()), "preferences_window.preferences_browser:update_content")
