#!/bin/bash

set -e;

print_help() {
    >&2 echo "Usage: $(basename "${0}") <image 1> ... <image n>";
}

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
    print_help;
    exit 0;
fi

if [ "${#}" -lt 1 ]; then
    print_help;
    exit 1;
fi

FILE_BIN=$(command -v file)
PNGQUANT_BIN=$(command -v pngquant)
ZOPFLIPNG_BIN=$(command -v zopflipng)
AWK_BIN=$(command -v awk)
PNGQUANT_OPTS="--quality=80-98 --force --strip --speed 1"
ZOPFLIPNG_OPTS="-y --filters=0"

args=("$@")
for ((i=0; i < $#; i++)) {
    file=${args[$i]}
    if [ ! -f "${file}" ]; then
        >&2 echo "File \"${file}\" not found.";
        continue;
    fi
    if ! ${FILE_BIN} "${file}" | grep -q "PNG image data"; then
        >&2 echo "File \"${file}\" is not a PNG image.";
        continue;
    fi
    size_orig=$(du "${file}" | cut -f1)
    >&2 echo -n "Optimizing ${file} ... ${size_orig} "
    intermed=$(mktemp)
    ${PNGQUANT_BIN} ${PNGQUANT_OPTS} "${file}" --output "${intermed}"
    if [ "$?" -eq 98 ] || [ "$?" -eq 99 ]; then
	# 98: output is bigger than input
	# 99: quality falls below the min value
        ZOPFLIPNG_OPTS="-y --lossy_transparent";
	cp "${file}" "${intermed}";
    fi
    >&2 echo -n "-> $(du "${intermed}" | cut -f1) "
    ${ZOPFLIPNG_BIN} ${ZOPFLIPNG_OPTS} "${intermed}" "${file}" > /dev/null
    rm "${intermed}"
    size_final=$(du "${file}" | cut -f1)
    >&2 echo -n "-> ${size_final} ("
    ${AWK_BIN} "BEGIN {printf \"%.2f %%)\\n\", (${size_final}/${size_orig})*100}"
}
