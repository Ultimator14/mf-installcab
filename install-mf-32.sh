#!/bin/sh

check_env() {
    [ -z "$1" ] && echo "$2 is not set" && exit 1
}

check_sanity() {
    [ ! -d "$1/$2" ] && echo "$1 isn't a valid path" && exit 1
}

check_env "$WINEPREFIX" WINEPREFIX
check_sanity "$WINEPREFIX" drive_c

# User instructions:
# Set PROTON to a Proton folder just like WINEPREFIX, pass -proton to script
if [ "$1" = "-proton" ]; then
    check_env "$PROTON" PROTON
    check_sanity "$PROTON" dist/bin

    export PATH="$PROTON/dist/bin:$PATH"
    export WINESERVER="$PROTON/dist/bin/wineserver"
    export WINELOADER="$PROTON/dist/bin/wine"
    export WINEDLLPATH="$PROTON/dist/lib/wine:$PROTON/dist/lib64/wine"
fi

set -e

scriptdir=$(dirname "$0")
cd "$scriptdir"

if [ ! -f "windows6.1-KB976932-X86.exe" ]; then
    wget "https://web.archive.org/web/20200803210804/https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-X64.exe"
fi

python2 installcab.py windows6.1-KB976932-X86.exe mediafoundation
python2 installcab.py windows6.1-KB976932-X86.exe mf_
python2 installcab.py windows6.1-KB976932-X86.exe mfreadwrite
python2 installcab.py windows6.1-KB976932-X86.exe wmadmod
python2 installcab.py windows6.1-KB976932-X86.exe wmvdecod
python2 installcab.py windows6.1-KB976932-X86.exe wmadmod

echo -e "\nNow you need to get mfplat.dll in your application directory"
