#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="captain_s"
rp_module_desc="Captain 'S' The Remake"
rp_module_help="Controls: Arrow: Move, CTRL: Action, ENTER: Change character when get a sausage or change superpower when you are Captain S."
rp_module_licence="MIT https://raw.githubusercontent.com/jmcerrejon/PiKISS/master/LICENSE.md"
rp_module_repo="file https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/captain_s.tar.gz"
rp_module_section="exp"
rp_module_flags="!armv6 !all rpi4"

function depends_captain_s() {
    getDepends xorg liballegro4.4 libpng12-0
}

function sources_captain_s() {
    downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
}

function install_captain_s() {
    md_ret_files=('data'
		'docs'
		'extra'
		'lang'
		'capitan.cfg'
		'captain'
		'captain.sh'
    )
}

function configure_captain_s() {
     #moveConfigDir "$md_inst/.avp" "$md_conf_root/.avp"
    addPort "$md_id" "captain_s" "Captain 'S' The Remake" "XINIT: pushd $md_inst; $md_inst/captain; popd"
}