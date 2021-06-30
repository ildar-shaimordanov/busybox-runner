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
	if [ "$1" = "-h" -o "$1" = "--help" ]
	then
		cat <<-HELP
		Usage: [ clp | ] ... [ | clp ]

		Copy data from and/or to the clipboard
		HELP
		return
	fi

	if [ ! -t 0 ]
	then
		# ... | clp
		clip
	else
		# clp | ...
		# or simply output the clipboard
		powershell -NoLogo -NoProfile -Command \
		'Get-Clipboard -Raw | Write-Host -NoNewLine'
	fi

}

# =========================================================================

clp "$@"

# =========================================================================

#EOF
