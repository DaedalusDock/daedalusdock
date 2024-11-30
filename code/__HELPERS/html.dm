/proc/button_element(trg, text, action, class, style)
	return "<a href='byond://?src=\ref[trg];[action]' onClick='event.stopPropagation();' [class ? "class='[class]'" : ""] style='cursor:pointer;[style]'>[text]</a>"

/proc/color_button_element(trg, color, action)
	return "<a href='byond://?src=\ref[trg];[action]' onClick='event.stopPropagation();' class='box' style='background-color: [color];cursor: pointer'></a>"

/// Display a DM icon in a a browser.
/proc/icon_element(icon, state, dir, moving, frame, style)
	return "<img class='dmIcon' src='\ref[icon]?state=[state]&dir=[dir]&moving=[moving]&frame=[frame]' style='[style]'>"

#define onclick_callback(trg, arguments) "\"(function(){window.location = 'byond://?src=[ref(trg)];[arguments]'})();\""

/proc/clickable_element(tag, class, style, trg, arguments)
	return "<[tag] onClick=[onclick_callback(trg, arguments)] class='[class]' style='cursor: pointer;[style]'>"

/// Inline script for an animated ellipsis
/proc/ellipsis(number_of_dots = 3, millisecond_delay = 500)
	var/static/unique_id = 0
	unique_id++
	return {"<span id='elip_[unique_id]' style='display: inline-block'></span>
			<script>
			var count = 0;
			document.addEventListener("DOMContentLoaded", function() {
				setInterval(function(){
					count++;
					document.getElementById('[unique_id]').innerHTML = new Array(count % [number_of_dots + 2]).join('.');
				}, [millisecond_delay]);
			});
			</script>
	"}

/// Chat tag image embed, see chat_tags.dm
#define CHAT_TAG(img) "<img class='chat_tag' src='[img]'>"
/// Radio tag image embed, see chat_tags.dm
#define RADIO_TAG(img)"<img class='radio_tag' src='[img]'>"
