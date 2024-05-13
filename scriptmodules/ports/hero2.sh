#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="fheroes2"
rp_module_desc="Heroes of Might and Magic II"
rp_module_help="Copy the subdirectories ANIM, DATA, MAPS and MUSIC (some of them may be missing depending on the version of the original game) to ports/hero2"
rp_module_licence="MIT https://raw.githubusercontent.com/jmcerrejon/PiKISS/master/LICENSE.md"
rp_module_repo="file https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/fheroes2_0.83_rpi.tar.gz"
rp_module_section="exp"
rp_module_flags="!armv6 !all rpi4 rpi3"

function depends_fheroes2() {
    getDepends xorg fluidr3mono-gm-soundfont fluid-soundfont-gm libsdl2-mixer-2.0-0 libsdl2-image-2.0-0 libsdl2-ttf-2.0-0
}

function sources_fheroes2() {
    downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
}

function install_fheroes2() {
    md_ret_files=('fheroes2'
		'fheroes2_64'
		'fheroes2.key'
		'changelog.txt'
		'README.txt'
    )
}

function configure_fheroes2() {
    mkRomDir "ports/hero2"
    ln -snf "$romdir/ports/hero2" "$md_inst"
    ln -sf "$md_inst/fheroes2" "$romdir/ports/hero2/fheroes2" 
    ln -sf "$md_inst/fheroes2.key" "$romdir/ports/hero2/fheroes2.key"
    moveConfigDir "$romdir/ports/hero2/files/save" "$md_conf_root/hero2/save"

    addPort "$md_id" "fheroes2" "Heroes of Might and Magic II" "XINIT: $romdir/ports/hero2/fheroes2"
}