#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="diablo2"
rp_module_desc="Diablo 2 - Lord of Destruction"
rp_module_help="you will need original all data files from the game install in ports/diablo2
binkw32.dll
d2char.mpq
d2data.mpq
d2exp.mpq
D2.LNG
d2music.mpq
d2sfx.mpq
d2speech.mpq
d2video.mpq
D2xMusic.mpq
d2xtalk.mpq
D2XVIDEO.MPQ
Diablo II.exe
Game.exe
ijl11.dll
Patch_D2.mpq
SmackW32.dll

On winecfg, go to Graphics Tab and set Emulate a virtual desktop to 800x600. Then, run Diablo 2 Lord of Destruction
"
rp_module_licence="MIT https://raw.githubusercontent.com/jmcerrejon/PiKISS/master/LICENSE.md"
rp_module_repo="file https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/diablo2-rpi.tar.gz"
rp_module_section="exp"
rp_module_flags="!armv6 rpi4"

function depends_diablo2() {
    getDepends xorg wine
    local mesa_url="https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/mesa.tar.gz"
    downloadAndExtract  "$mesa_url" "$home"
}

function sources_diablo2() {
    downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
}

function install_diablo2() {
    md_ret_files=('diablo2.sh'
		'diabloII.png'
		'libd2game_sa_arm.exe.so'
    )
}

function configure_diablo2() {
    mkRomDir "ports/diablo2"
    ln -snf "$romdir/ports/diablo2" "$md_inst"
    ln -sf "$md_inst/libd2game_sa_arm.exe.so" "$romdir/ports/diablo2/libd2game_sa_arm.exe.so"   
    moveConfigDir "$romdir/ports/diablo2/save" "$md_conf_root/diablo2/save"

    local script="$md_inst/diablo2r.sh"
    cat > "$script" << _EOF_
#!/bin/bash
pushd "$md_inst/$md_id"
cd $md_inst && ./diablo2.sh
_EOF_

    chmod +x "$script"
    addPort "$md_id" "diablo2" "Diablo 2 Lord of Destruction" "XINIT: $md_inst/diablo2r.sh"
    addPort "$md_id" "winecfg" "WineCFG" "XINIT: winecfg"

}