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

rp_module_id="gmloader"
rp_module_desc="GMLoader - play GameMaker Studio games for Android on non-Android operating systems"
rp_module_help="ROM Extensions: .apk .APK\n\nIncludes free games Maldita Castilla and Spelunky Classic HD. Use a launch script (e.g. 'Spelunky Classic HD.sh') as template for additional games."
rp_module_repo="git https://github.com/JohnnyonFlame/droidports.git master"
rp_module_licence="GPL3 https://raw.githubusercontent.com/JohnnyonFlame/droidports/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags="!all rpi4 rpi3"

function depends_gmloader() {
    getDepends libopenal-dev libfreetype6-dev zlib1g-dev libbz2-dev libpng-dev libzip-dev libsdl2-image-dev cmake
}

function sources_gmloader() {
    gitPullOrClone
    applyPatch "$md_data/01_sdl_retropie_exit_emu.patch"
    applyPatch "$md_data/02_sdl_disable_mouse_cursor.patch"
}

function build_gmloader() {
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DPLATFORM=linux -DPORT=gmloader ..
    make
    md_ret_require="$md_build/build/gmloader"
}

function install_gmloader() {
    md_ret_files=(
        'build/gmloader'
        'LICENSE.md'
        'README.md'
    )
}

function configure_gmloader() {
    local apk_dir="$romdir/ports/droidports"
    local maldita_url="https://locomalito.com/juegos/Maldita_Castilla_ouya.apk"
    local spelunky_url="https://github.com/yancharkin/SpelunkyClassicHD/releases/download/1.1.7-optimized/spelunky_classic_hd-android-armv7.apk"

    if [[ "$md_mode" == "install" ]]; then
        mkUserDir "$apk_dir"
        local dl_url
        for dl_url in "$maldita_url" "$spelunky_url"; do
            local apk_file="$apk_dir/$(basename ${dl_url})"
            if [[ ! -f "$apk_file" ]]; then
                download "$dl_url" "$apk_dir"
                chown $user:$user "$apk_file"
            fi
        done

        local libcpp_eabi="libc++_shared.so"
        if [[ ! -f "$md_inst/$libcpp_eabi" ]]; then
            downloadAndExtract "https://chromium.googlesource.com/android_ndk.git/+archive/refs/heads/main/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a.tar.gz" "$md_inst" "$libcpp_eabi"
            strip -s "$md_inst/$libcpp_eabi"
        fi

        # Launcher: Change to install folder as failsafe to load libc++_shared.so
        # sibling to gmloader binary for APKs which do not bundle the lib
        cat >"$md_inst/gmlauncher.sh" << _EOF_
#! /usr/bin/env bash
cd "$md_inst"
ROM="\$1"
fn="\${ROM##*/}"
BASENAME="\${fn%.*}"
GMLOADER_SAVEDIR="$home/.config/gmloader/\$BASENAME/" ./gmloader "\$ROM"
_EOF_
        chmod a+x "$md_inst/gmlauncher.sh"
    fi

    local maldita_file="$apk_dir/$(basename ${maldita_url})"
    local spelunky_file="$apk_dir/$(basename ${spelunky_url})"
    addPort "$md_id" "droidports" "Maldita Castilla" "$md_inst/gmlauncher.sh %ROM%" "$maldita_file"
    addPort "$md_id" "droidports" "Spelunky Classic HD" "$md_inst/gmlauncher.sh %ROM%" "$spelunky_file"

    local am2r_file="$apk_dir/am2r_155.apk"
    if [[ -f "$am2r_file" || "$md_mode" == "remove" ]]; then
        addPort "$md_id" "droidports" "AM2R - Another Metroid 2 Remake" "$md_inst/gmlauncher.sh %ROM%" "$am2r_file"
    fi

    moveConfigDir "$home/.config/gmloader" "$md_conf_root/droidports"
}
