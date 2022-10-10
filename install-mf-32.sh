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
# Set PROTON to a Heroic Game Launcher Proton folder just like WINEPREFIX, pass -heroicproton to script. 
# Heroic now includes a "Wine Manager" for managing wine versions. Wine versions installed using the
# "Wine Manager" have a slightly different directory structure different than standard proton wine versions.
if [ "$1" = "-heroicproton" ]; then
    check_env "$PROTON" PROTON
    check_sanity "$PROTON" files/bin

    export PATH="$PROTON/files/bin:$PATH"
    export WINESERVER="$PROTON/files/bin/wineserver"
    export WINELOADER="$PROTON/files/bin/wine"
    export WINEDLLPATH="$PROTON/files/lib/wine:$PROTON/files/lib64/wine"
fi

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

if [ ! -f "windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe" ]; then
    wget "http://download.windowsupdate.com/msdownload/update/software/svpk/2011/02/windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe"
fi

python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe mediafoundation
python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe mf_
python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe mfreadwrite
python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe wmadmod
python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe wmvdecod
python2 installcab.py windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe wmadmod

echo -e "\nNow you need to get mfplat.dll in your application directory"
