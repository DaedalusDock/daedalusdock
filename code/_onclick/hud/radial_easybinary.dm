GLOBAL_REAL_VAR(list/binary_radial_defaults) = list(
	SIMPLE_RADIAL_ACTIVATE = new /image{
		icon = 'icons/hud/radial.dmi';
		icon_state = "green";
		maptext = "<span class='maptext'>Activate</span>";
		maptext_y = 30;
		maptext_x = -1;
		maptext_width = 40;
	},
	SIMPLE_RADIAL_DEACTIVATE = new /image{
		icon = 'icons/hud/radial.dmi';
		icon_state = "red";
		maptext = "<span class='maptext'>Deactivate</span>";
		maptext_y = -8;
		maptext_x = -6;
		maptext_width = 45;
	}
)


/* Simple binary radials are an optional feature clients can disable in prefs
/ * The purpose of them is to guard against packet loss, providing a spam-click safe option for binary toggles.
/ * Will return SIMPLE_RADIAL_DOESNT_USE if the user does not have the pref enabled.
*/
/mob/proc/simple_binary_radial(atom/target, list/custom_options)
	if(!client?.prefs.read_preference(/datum/preference/toggle/binary_radials))
		return SIMPLE_RADIAL_DOESNT_USE

	return show_radial_menu(src, target, custom_options || global.binary_radial_defaults, radius = 21, require_near = !isAI(src))

