staload UNSAFE = "prelude/SATS/unsafe.sats"
staload STDIO = "libats/libc/SATS/stdio.sats"
staload "./cli.sats"

fun go_fileref
(state: &cli_state >> _, filr: FILEref): void

fun go_basename
(state: &cli_state >> _, fname: string)
: void

fun go_basename_
(state: &cli_state >> _, fname: string)
: void
