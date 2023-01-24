#!/bin/bash

# bgm123 init script for RetroPie

source #config

mpg123 -Z -@- >/dev/null 2>&1 < <(find "$music_dir" -type f -iname "*.mp3")
