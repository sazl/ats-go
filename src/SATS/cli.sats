
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

typedef cli_state = @{
  arg0 = cli_argument,
  arg_count = int,
  waitkind = waitkind,
  input_file_count = int,
  out_chan = OUTCHAN,
  error_count = int
}

fun cli_state_set_outchan
(state: &cli_state >> _, chan_new: OUTCHAN)
: void

fun cli_state_set_outchan_basename
(state: &cli_state >> _, basename: string)
: void

fun comarg_warning
(msg: string)
: void

fun comarglst_parse
{n:nat}
(argc: int n, argv: !argv(n))
: list (comarg, n)

fun comarg_parse (string)
:<> comarg
