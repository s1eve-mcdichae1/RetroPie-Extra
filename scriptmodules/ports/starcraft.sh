#!/usr/bin/env bash

# This file is a work-in-progress.
#
# Installation scriptmodule for RetroPie. For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="starcraft"
rp_module_desc="ARM recompiled exe of StarCraft"
rp_module_help="Thanks to PI Labs, Notaz, and Blizzard for release free this game in 2017.\n\nCopy an installed Starcraft (v1.16.1 with Brood War) folder into $romdir/ports/Starcraft\n\nFrom the Starcraft CD or ISO, copy 'install.exe' and rename it 'StarCraft.mpq'\n\nFrom the Brood War CD or ISO, copy 'install.exe' and rename it 'BroodWar.mpq'"
rp_module_repo="file https://notaz.gp2x.de/misc/starec/libscr.tar.xz"
rp_module_section="exp"
rp_module_flags="!all arm"
# (?) rp_module_flags="!all arm !armv6"

function depends_starcraft() {
    getDepends xorg wine matchbox
}

function install_bin_starcraft() {
    rmDirExists "$md_inst"
    mkdir -p "$md_inst"
    downloadAndExtract "$md_repo_url" "$md_inst"
}

function configure_starcraft() {
    addPort "$md_id" "starcraft" "Starcraft" "XINIT:$md_inst/starcraftr.sh"

    [[ "$md_mode" == "remove" ]] && return

    mkRomDir "ports/Starcraft"

    local file
    local files=(
        'BrooDat.mpq'
        'BroodWar.mpq'
        'Local.dll'
        'patch_rt.mpq'
        'StarCraft.mpq'
        'StarDat.mpq'
    )
    for file in "${files[@]}"; do
        ln -sf "$romdir/ports/Starcraft/$file" "$md_inst/$file"
    done

    local dir
    local dirs=(
        'characters'
        'Errors'
        'maps'
        'save'
    )
    for dir in "${dirs[@]}"; do
        ln -snf "$romdir/ports/Starcraft/$dir" "$md_inst/$dir"
    done

    local script="$md_inst/starcraftr.sh"
    cat > "$script" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
cd "$md_inst"
LD_LIBRARY_PATH=. setarch linux32 -L wine libscr_sa_arm.exe.so
_EOF_

    chmod +x "$md_inst/starcraftr.sh"
}
