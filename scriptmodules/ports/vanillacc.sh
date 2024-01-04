#!/usr/bin/env bash

# Installation scriptmodule for RetroPie. This file is a work-in-progress.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="vanillacc"
rp_module_desc="Vanilla Command and Conquer"
rp_module_help="Demo versions will be downloaded automatically. Alternatively, files may be extracted from the retail CD's or freeware ISO's. See [insert link here]"
rp_module_licence="GNU https://raw.githubusercontent.com/TheAssemblyArmada/Vanilla-Conquer/vanilla/License.txt"
rp_module_repo="git https://github.com/TheAssemblyArmada/Vanilla-Conquer.git vanilla"
rp_module_section="exp"
rp_module_flags=""

function depends_vanillacc() {
    getDepends cmake libsdl2-dev libopenal-dev
}

function sources_vanillacc() {
    gitPullOrClone
}

function build_vanillacc() {
    mkdir build
    cd build
    CXXFLAGS=-fpermissive cmake ..
    make
    md_ret_require=(
        "$md_build/build/vanillara"
        "$md_build/build/vanillatd"
    )
}

function install_vanillacc() {
    mkdir -p "$md_inst/redalert" "$md_inst/tiberiandawn"
    cp -vf "$md_build/build/vanillara" "$md_inst/redalert"
    cp -vf "$md_build/build/vanillatd" "$md_inst/tiberiandawn"
}

function game_data_vanillacc() {
    if [[ ! -f "$romdir/ports/tiberiandawn/CONQUER.MIX" && ! -f "$romdir/ports/tiberiandawn/DEMO.MIX" ]]; then
        downloadAndExtract "https://raw.githubusercontent.com/Exarkuniv/game-data/main/cctd.zip" "$romdir/ports/tiberiandawn"
        chown -R $user:$user "$romdir/ports/tiberiandawn"
    fi
    if [[ ! -f "$romdir/ports/redalert/REDALERT.MIX" ]]; then
        downloadAndExtract "https://raw.githubusercontent.com/Exarkuniv/game-data/main/ccra.zip" "$romdir/ports/redalert"
        chown -R $user:$user "$romdir/ports/redalert"
    fi
}

function configure_vanillacc() {
    local script="$md_inst/vanillacc.sh"

    addPort "$md_id" "vanillacc" "Command and Conquer - Red Alert" "$script %ROM%" "ra"
    addPort "$md_id" "vanillacc" "Command and Conquer - Tiberian Dawn" "$script %ROM%" "td"
    moveConfigDir "$home/.config/vanilla-conquer" "$md_conf_root/vanillacc"

    [[ "$md_mode" == "remove" ]] && return

    mkRomDir "ports/redalert"
    mkRomDir "ports/tiberiandawn"

    cat > "$script" << _EOF_
#!/bin/bash
mode="\$1"
shift

case "\$mode" in
    ra) launcher="$md_inst/redalert/vanillara" ;;
    td) launcher="$md_inst/tiberiandawn/vanillatd" ;;
esac

if [[ -n "\$launcher" ]]; then
    pushd "\$(dirname "\$launcher")"
    "\$launcher" "\$@"
    popd
fi
_EOF_
    chmod +x "$script"

    game_data_vanillacc

    ## Link game files to bin dir

    local ra_files=(
        allied
        soviet
        REDALERT.MIX
    )

    # RA demo
    ra_files+=(
        MAIN.MIX
    )

    local td_files=(
        gdi
        nod
        CONQUER.MIX
        DESERT.MIX
        TEMPERAT.MIX
        WINTER.MIX
        CCLOCAL.MIX
        TRANSIT.MIX
        SPEECH.MIX
        UPDATE.MIX
        UPDATEC.MIX
        DESEICNH.MIX
        TEMPICNH.MIX
        WINTICNH.MIX
    )

    # TD demo
    td_files+=(
        DEMO.MIX
        DEMOL.MIX
        DEMOM.MIX
        SOUNDS.MIX
    )

    local file
    for file in "${ra_files[@]}"; do
        ln -snf "$romdir/ports/redalert/$file" "$md_inst/redalert/$file"
    done

    for file in "${td_files[@]}"; do
        ln -snf "$romdir/ports/tiberiandawn/$file" "$md_inst/tiberiandawn/$file"
    done
}
