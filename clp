#!/usr/bin/env sh

# =========================================================================
#
# Simplify handling with the clipboard in BusyBox under Windows
#
# Do something with data taken from the clipboard
# clp | ...
#
# Do something with data and keep in the clipboard
# ... | clp
#
# =========================================================================

clp() {
	if [ "$1" = "-h" ]
	then
		echo "Usage: [ clp | ] ... [ | clp ]"
		return
	fi

	if [ ! -t 0 ]
	then
		# ... | clp
		clip
	else
		# clp | ...
		# or simply output the clipboard
		powershell -NoLogo -NoProfile -Command Get-Clipboard
	fi

}

# =========================================================================

clp "$@"

# =========================================================================

#EOF
