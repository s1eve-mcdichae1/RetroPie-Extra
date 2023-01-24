#!/bin/bash

# bgm123 kill script for RetroPie

source #config

pkill "$music_player"

# if killed while stopped (music paused), process will not terminate correctly.
# restart the stopped process to terminate it:
[[ "$(ps -ostate= -C $music_player)" == "T" ]] && pkill -CONT "$music_player"
