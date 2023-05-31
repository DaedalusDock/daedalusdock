#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

st=0

echo -e "${BLUE}Checking for map issues...${NC}"

if grep -El '^\".+\" = \(.+\)' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
    st=1
fi;
if grep -P '//' _maps/**/*.dmm | grep -v '//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE' | grep -Ev 'name|desc'; then
    echo
    echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
    st=1
fi;
if grep -P 'Merge Conflict Marker' _maps/**/*.dmm; then
    echo
    echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
    st=1
fi;
# We check for this as well to ensure people aren't actually using this mapping effect in their maps.
if grep -P '/obj/merge_conflict_marker' _maps/**/*.dmm; then
    echo
    echo -e "${RED}ERROR: Merge conflict markers detected in map, please resolve all merge failures!${NC}"
    st=1
fi;
if grep -P '^\ttag = \"icon' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Tag vars from icon state generation detected in maps, please remove them.${NC}"
    st=1
fi;
if grep -P 'step_[xy]' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: step_x/step_y variables detected in maps, please remove them.${NC}"
    st=1
fi;
if grep -P 'pixel_[^xy]' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: incorrect pixel offset variables detected in maps, please remove them.${NC}"
    st=1
fi;
if grep -P '/obj/structure/cable(/\w+)+\{' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Variable editted cables detected, please remove them.${NC}"
    st=1
fi;
if grep -P '\td[1-2] =' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: d1/d2 cable variables detected in maps, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/cable,\n[^)]*?/obj/structure/cable,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Found multiple cables on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Found multiple lattices on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/machinery/atmospherics/pipe/(?<type>[/\w]*),\n[^)]*?/obj/machinery/atmospherics/pipe/\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
    echo
    echo -e "${RED}ERROR: Found multiple identical pipes on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '/obj/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?[013-9]\d*?[^\d]*?\s*?\},?\n' _maps/**/*.dmm ||
    grep -Pzo '/obj/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d+?[0-46-9][^\d]*?\s*?\},?\n' _maps/**/*.dmm ||
    grep -Pzo '/obj/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d{3,1000}[^\d]*?\s*?\},?\n' _maps/**/*.dmm ;	then
    echo
    echo -e "${RED}ERROR: Found an APC with a manually set pixel_x or pixel_y that is not +-25. Use the directional variants when possible.${NC}"
    st=1
fi;
# I'll reenable this later. -Francinum
# if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/turf/closed/wall[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
#     echo
#     echo -e "${RED}ERROR: Found a lattice stacked with a wall, please remove them.${NC}"
#     st=1
# fi;
# if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/turf/closed[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
# 	echo
#     echo -e "${RED}ERROR: Found a lattice stacked within a wall, please remove them.${NC}"
#     st=1
# fi;
# if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/window[/\w]*?,\n[^)]*?/turf/closed[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
# 	echo
#     echo -e "${RED}ERROR: Found a window stacked within a wall, please remove it.${NC}"
#     st=1
# fi;
if grep -P '^/area/.+[\{]' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Variable editted /area path use detected in a map, please replace with a proper area path.${NC}"
    st=1
fi;
if grep -P '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
	echo
    echo -e "${RED}ERROR: Base /turf path use detected in maps, please replace it with a proper turf path.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/turf/[/\w]*?,\n[^)]*?/turf/[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm; then
	echo
    echo -e "${RED}ERROR: Multiple turfs detected on the same tile! Please choose only one turf!${NC}"
    st=1
fi;

echo -e "${BLUE}Checking for whitespace issues...${NC}"

if grep -P '(^ {2})|(^ [^ * ])|(^    +)' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: Space indentation detected, please use tab indentation.${NC}"
    st=1
fi;
if grep -P '^\t+ [^ *]' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: Mixed <tab><space> indentation detected, please stick to tab indentation.${NC}"
    st=1
fi;
nl='
'
nl=$'\n'
while read f; do
    t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
    if [[ ! ${t%x} =~ $r1 ]]; then
        echo -e "${RED}ERROR: file $f is missing a trailing newline.${NC}"
        st=1
    fi;
done < <(find . -type f -name '*.dm')

echo -e "${BLUE}Checking for common mistakes...${NC}"

if grep -P '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' code/**/*.dm; then
    echo "changed files contains proc argument starting with 'var'"
    st=1
fi;
if grep 'balloon_alert\(".+"\)' code/**/*.dm; then
    echo "ERROR: Balloon alert with improper arguments."
    st=1
fi;
if grep -i 'centcomm' code/**/*.dm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
    st=1
fi;
if grep -i 'centcomm' _maps/**/*.dmm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
    st=1
fi;
if grep -ni 'nanotransen' code/**/*.dm; then
    echo "Misspelling(s) of nanotrasen detected in code, please remove the extra N(s)."
    st=1
fi;
if grep -ni 'nanotransen' _maps/**/*.dmm; then
    echo "Misspelling(s) of nanotrasen detected in maps, please remove the extra N(s)."
    st=1
fi;
if ls _maps/*.json | grep -P "[A-Z]"; then
    echo "Uppercase in a map json detected, these must be all lowercase."
    st=1
fi;
if grep -i '/obj/effect/mapping_helpers/atom_injector/custom_icon' _maps/**/*.dmm; then
    echo "Custom icon helper found. Please include dmis as standard assets instead for built-in maps."
    st=1
fi;
if grep -P '^/*var/' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: Unmanaged global var use detected in code, please use the helpers.${NC}"
    st=1
fi;
if grep -P 'CALLBACK\(GLOBAL_PROC, PROC_REF\(' code/**/*.dm; then
	echo
	echo -e "${RED}ERROR: Global callback with non-global proc ref. This will crash!${NC}"
	st=1
fi;


for json in _maps/*.json
do
    map_path=$(jq -r '.map_path' $json)
    while read map_file; do
        filename="_maps/$map_path/$map_file"
        if [ ! -f $filename ]
        then
            echo "found invalid file reference to $filename in _maps/$json"
            st=1
        fi
    done < <(jq -r '[.map_file] | flatten | .[]' $json)
done

exit $st
