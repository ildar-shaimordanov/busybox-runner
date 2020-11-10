# busybox-runner

Simplify running BusyBox

This script is intended to simplify BusyBox invocation in difeerent ways.

# Installation

* Download the latest version of BusyBox executable from https://frippery.org/busybox/ (either 64-bit or 32-bit, what you want).
* Download from this repository the script `bb.bat`.
* Place both somewhere in your operating system to be visible via `$PATH`.

That's it. Everything is ready. You can enjoy with the cool set of Unix tools and cute envelope for running them.

# Usage

```
Simplify running BusyBox

USAGE
  Print BusyBox help page
    bb --help

  Run a built-in BusyBox function
    bb function [function-options]

  Run an external command or script from within shell
    bb [shell-options] -c "command [command-options]"

  Run a command or script found in $PATH
    bb command [command-options]

SEE ALSO
  Learn more about BusyBox following these links:

  https://busybox.net/
  https://frippery.org/busybox/
  https://github.com/rmyorston/busybox-w32
```

## Run a built-in BusyBox function

Run the internal function and pass options, if necessary:

```
bb function [function-options]
```

In fact, it's the same what BusyBox does:

```
busybox function [function-options]
```

## Run an external command or script from within shell

BusyBox doesn't recognize external commands even when they are in `$PATH`. The BusyBox's internal shell does. The following examples are identical:

```
bb [shell-options] -c "command [command-options]"
```

```
busybox sh [shell-options] -c "command [command-options]"
```

## Run a command or script found in `$PATH`

The previous example could be a bit simpler and more convenient, if the double quotes would have been skipped. This use case is invented for this purpose.

```
bb command [command-options]
```

```
busybox sh -c "command [command-options]"
```

# See Also

* https://busybox.net/
* https://frippery.org/busybox/
* https://github.com/rmyorston/busybox-w32
