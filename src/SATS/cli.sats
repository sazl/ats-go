
#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define CATSPARSEMIT_targetloc "./../../vendor/CATS-parsemit"
#endif

staload STDIO = "libats/libc/SATS/stdio.sats"

#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_parsing.sats"

datatype cli_argument = COMARGkey of (int, string)
typedef cli_argument_list = List0(cli_argument)

datatype
waitkind =
  | WTKnone of ()
  | WTKinput of ()
  | WTKoutput of ()

datatype OUTCHAN =
  | OUTCHANref of (FILEref)
  | OUTCHANptr of (FILEref)

typedef cli_state = @{
  arg0 = cli_argument,
  arg_count = int,
  waitkind = waitkind,
  input_file_count = int,
  out_chan = OUTCHAN,
  error_count = int
}

fun outchan_get_fileref
(x: OUTCHAN): FILEref

fun cli_state_set_outchan
(state: &cli_state >> _, chan_new: OUTCHAN)
: void

fun cli_state_set_outchan_basename
(state: &cli_state >> _, basename: string)
: void

fun cli_argument_warning
(msg: string)
: void

fun cli_argument_list_parse
{n:nat}
(argc: int n, argv: !argv(n))
: list (cli_argument, n)

fun cli_argument_parse (string)
:<> cli_argument
