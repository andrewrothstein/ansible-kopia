#!/usr/bin/env bash
set -e
DIR=~/Downloads
APP=kopia
MIRROR=https://github.com/kopia/${APP}/releases/download

# https://github.com/kopia/kopia/releases/download/v0.14.1/checksums.txt
# https://github.com/kopia/kopia/releases/download/v0.14.1/kopia-0.14.1-linux-arm64.tar.gz

dl()
{
    local ver=$1
    local checksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}-${arch}"
    local file="${APP}-${ver}-${platform}.${archive_type}"
    local url="${MIRROR}/v${ver}/${file}"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(fgrep $file $checksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local mirror=$MIRROR/v${ver}

    local lchecksums="${DIR}/${APP}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $mirror/checksums.txt
    fi

    printf "  # %s\n" $mirror/checksums.txt
    printf "  '%s':\n" $ver

    dl $ver $lchecksums linux arm
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums linux x64
    dl $ver $lchecksums macOS arm64
    dl $ver $lchecksums macOS x64
    dl $ver $lchecksums windows x64 zip
}

dl_ver ${1:-0.17.0}
