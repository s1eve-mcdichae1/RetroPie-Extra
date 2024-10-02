# not really needed but better explicit than implicit
set(CMAKE_SYSTEM_PROCESSOR armv7l)

# the variable is replaced by scriptmodule to point to libdir of GCC version
set(crosslib _crosslib_var)

# for -lgcc -lgcc_s (try_compile)
link_directories(${crosslib})
# for stddef.h
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${crosslib}/include")
# for -lgcc -lgcc_s (ld)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -L${crosslib}")

set(BZIP2_LIBRARY_RELEASE /usr/lib/arm-linux-gnueabihf/libbz2.so)
set(LIBZIP_LIBRARY        /usr/lib/arm-linux-gnueabihf/libzip.so)
set(OPENAL_LIBRARY        /usr/lib/arm-linux-gnueabihf/libopenal.so)
set(SDL2_LIBRARY_TEMP     /usr/lib/arm-linux-gnueabihf/libSDL2.so)
set(ZLIB_LIBRARY          /usr/lib/arm-linux-gnueabihf/libz.so)
set(FREETYPE_LIBRARY      "freetype")
