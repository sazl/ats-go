
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

fun outchan_get_fileref
(x: OUTCHAN)
: FILEref = (
    case+ x of
    | OUTCHANref (filr) => filr
    | OUTCHANptr (filp) => filp
)

typedef cmdstate = @{
  arg0 = cli_argument,
  arg_count = int,
  waitkind = waitkind,
  input_file_count = int,
  out_chan = OUTCHAN,
  error_count = int
}

fun command_state_set_outchan
(state: &command_state >> _, chan_new: OUTCHAN)
: void

fun command_state_set_outchan_basename
(state: &cmdstate >> _, basename: string)
: void

extern fun comarg_warning
(msg: string)
: void

extern fun comarglst_parse
{n:nat}
(argc: int n, argv: !argv(n))
: list (comarg, n)

extern fun comarg_parse (string)
:<> comarg

extern fun go_fileref
(state: &cmdstate >> _, filr: FILEref): void

extern fun go_basename
(state: &cmdstate >> _, fname: string)
: void

extern fun go_basename_
(state: &cmdstate >> _, fname: string)
: void
