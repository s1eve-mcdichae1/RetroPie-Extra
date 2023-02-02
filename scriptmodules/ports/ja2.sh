#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="ja2"
rp_module_desc="Jagged Alliance 2"
rp_module_licence="GPL https://github.com/ja2-stracciatella/ja2-stracciatella"
rp_module_repo="git https://github.com/ja2-stracciatella/ja2-stracciatella.git v0.18.0"
rp_module_help=" Copy over game data files and folders from your PC to ports/ja2"
rp_module_section="exp"
rp_module_flags="!mali"

function depends_ja2() {
    getDepends libsdl2-dev libboost-filesystem-dev cargo rustc-mozilla xorg libgtest-dev
}

function sources_ja2() {
    gitPullOrClone
}

function build_ja2() {
    mkdir bin && cd bin
    cmake ..
    make -j4
    md_ret_require=()
}

function install_ja2() {
	md_ret_files=(bin/ja2
		bin/externalized
    )
}

function configure_ja2() {
    mkRomDir "ports/ja2"
    moveConfigDir "$home/.ja2" "$md_conf_root/$md_id"

    local script="/home/pi/.ja2/ja2.json"
    cat > "$script" << _EOF_
{
            // Put the directory to your original ja2 installation into the line below.
            "game_dir": "$romdir/ports/ja2"
        }
_EOF_

    addPort "$md_id" "ja2" "Jagged Alliance 2" "$md_inst/ja2"
}