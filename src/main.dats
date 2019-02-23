#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload STDIO = "{$PATSLIBATSLIBC}/SATS/stdio.sats"

#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define CATSPARSEMIT_targetloc "./../CATS-parsemit"
#endif

#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_parsing.sats"

val () = catsparse_all_dynload() where
{
    extern fun
    catsparse_all_dynload(): void = "ext#"
}

#dynload "./emit.dats"
#dynload "./emit2.dats"

datatype cli_argument = COMARGkey of (int, string)
typedef cli_argument_list = List0(cli_argument)

datatype
waitkind =
  | WTKnone of ()
  | WTKinput of ()
  | WTKoutput of () // -o / --output

datatype OUTCHAN =
  | OUTCHANref of (FILEref)
  | OUTCHANptr of (FILEref)

fun outchan_get_fileref
(x: OUTCHAN)
: FILEref =
(
    case+ x of
    | OUTCHANref (filr) => filr
    | OUTCHANptr (filp) => filp
)

typedef
cmdstate = @{
  arg0 = cli_argument,
  arg_count = int,
  waitkind = waitkind,
  input_file_count = int,
  out_chan = OUTCHAN,
  error_count = int
}

fun command_state_set_outchan
(state: &command_state >> _, chan_new: OUTCHAN)
: void = let
    val chan_old = state.outchan
    val () = state.outchan := chan_new
in
    case+
    chan_old of
    | OUTCHANref(filr) => ()
    | OUTCHANptr(filp) => let
        val err = $STDIO.fclose0(filp)
    in
    end
end

extern fun go_fileref
(state: &cmdstate >> _, filr: FILEref): void

implement go_fileref
  (state, inp) = let
    val out = outchan_get_fileref(state.outchan)
    val d0cs = parse_from_fileref(inp)
    val () = emit_time_stamp(out)
    val () = emit_toplevel(out, d0cs)
    val () = emit_text (out, "######\n")
    val () = emit_text (out, "##\n")
    val () = emit_text (out, "## end-of-compilation-unit")
    val () = emit_text (out, "\n##")
    val () = emit_text (out, "\n######")
    val () = emit_newline(out)
in
end

macdef fopen = $STDIO.fopen

extern fun go_basename
(state: &cmdstate >> _, fname: string)
: void

extern fun go_basename_
(state: &cmdstate >> _, fname: string)
: void

implement go_basename
(state, fname) = (
    case+
    fname of
    | "-" => let
        val inp = stdin_ref
    in
        atscc2py3_fileref(state, inp)
    end
    | _ =>
        atscc2py3_basename_(state, fname)
)

implement go_basename_
(state, fname) =
    let
        val inp = fopen(fname, file_mode_r)
        val p_inp = $STDIO.ptrcast(inp)
    in
        if p_inp > 0
        then
            fileref_close(inp) where {
                val inp = $UNSAFE.castvwtp0{FILEref}(inp)
                val () = the_filename_push(filename_make(fname))
                val () = atscc2py3_fileref(state, inp)
            }
        else
            let
                prval () = $STDIO.FILEptr_free_null(inp)
                val () = (state.nerror := state.nerror + 1)
            in
            end
end

fun command_state_set_outchan_basename
(state: &cmdstate >> _, basename: string)
: void =
    let
        val filp = $STDIO.fopen(basename, file_mode_w)
        val p0 = $STDIO.ptrcast(filp)
        (* val () = println! ("cmdstate_set_outchan_basename: p0 = ", p0) *)
    in
        if p0 > 0
        then
            let
                val filp = $UNSAFE.castvwtp0{FILEref}(filp)
            in
                command_state_set_outchan(state, OUTCHANptr(filp))
            end
        else
            let
                prval () = $STDIO.FILEptr_free_null (filp)
                val () = state.nerror := state.nerror + 1
            in
                cmdstate_set_outchan (state, OUTCHANref(stderr_ref))
            end
end

fn isinwait
(state: cmdstate)
: bool =
(
  case+ state.waitkind of
  | WTKinput () => true
  | _ => false
)

fn isoutwait
(state: cmdstate)
: bool =
(
  case+ state.waitkind of
  | WTKoutput () => true
  | _ => false
)

extern fun comarg_warning
(msg: string)
: void

implement comarg_warning
(msg) = {
  val () = prerr ("waring(ATS)")
  val () = prerr (": unrecognized command line argument [")
  val () = prerr (msg)
  val () = prerr ("] is ignored.")
  val () = prerr_newline ()
}

fun go_usage
(cmd: string)
: void = {
    val () = println! ("Usage: ", cmd, " <command> ... <command>\n")
    val () = println! ("where each <command> is of one of the following forms:\n")
    val () = println! ("  -i <filename> : for processing <filename>")
    val () = println! ("  --input <filename> : for processing <filename>")
    val () = println! ("  -o <filename> : output into <filename>")
    val () = println! ("  --output <filename> : output into <filename>")
    val () = println! ("  -h : for printing out this help usage")
    val () = println! ("  --help : for printing out this help usage")
} (* end of [atscc2py3_usage] *)

(* ****** ****** *)

fun process_cmdline
(state: &cmdstate, arglst: comarglst)
: void =
    let
    in
        case+ arglst of
        | list_nil () =>
            let
                val nif = state.ninputfile
                val wait0 = (
                    case+ 0 of
                    | _ when nif < 0 => true
                    | _ when nif = 0 => isinwait (state)
                    | _ (* nif > 0 *) => false
                ) : bool
            in
                if wait0 then (
                    if state.ncomarg = 0
                    then atscc2py3_usage ("atscc2py3")
                    else atscc2py3_fileref (state, stdin_ref)
                )
            end
        | list_cons
            (arg, arglst) =>
                let
                    val () = state.ncomarg := state.ncomarg + 1
                in
                    process_cmdline2 (state, arg, arglst)
                end
    end
and
    process_cmdline2
    (state: &cmdstate, arg: comarg, arglst: comarglst)
    : void =
        let
        in
            case+ arg of
            | _ when
                isinwait(state) =>
                    let
                        val nif = state.ninputfile
                    in
                        case+ arg of
                        | COMARGkey (1, key) when nif > 0 =>
                            process_cmdline2_COMARGkey1 (state, arglst, key)
                        | COMARGkey (2, key) when nif > 0 =>
                            process_cmdline2_COMARGkey2 (state, arglst, key)
                        | COMARGkey (_, fname) =>
                            let
                                val () = state.ninputfile := nif + 1
                                val () = atscc2py3_basename (state, fname(*input*))
                            in
                                process_cmdline (state, arglst)
                            end
                    end
            | _ when isoutwait(state) =>
                let
                    val COMARGkey (_, fname) = arg
                    val () = cmdstate_set_outchan_basename (state, fname)
                    val () = state.waitkind := WTKnone ()
                in
                    process_cmdline (state, arglst)
                end
            | COMARGkey (1, key) =>
                process_cmdline2_COMARGkey1 (state, arglst, key)
            | COMARGkey (2, key) =>
                process_cmdline2_COMARGkey2 (state, arglst, key)
            | COMARGkey (_, key) => let
                val () = comarg_warning (key)
                val () = state.waitkind := WTKnone ()
            in
                process_cmdline (state, arglst)
            end
        end
and
process_cmdline2_COMARGkey1
(
  state: &cmdstate >> _, arglst: comarglst, key: string
) : void = let
//
val () = (
//
case+ key of
//
| "-i" => {
    val () = state.ninputfile := 0
    val () = state.waitkind := WTKinput()
  } (* end of [-i] *)
//
| "-o" => {
    val () = state.waitkind := WTKoutput ()
  } (* end of [-o] *)
//
| "-h" => {
    val () = atscc2py3_usage ("atscc2py3")
    val () = state.waitkind := WTKnone(*void*)
    val () = if state.ninputfile < 0 then state.ninputfile := 0
  } (* end of [-h] *)
//
| _ (*unrecognized*) => comarg_warning (key)
//
) : void // end of [val]
//
in
  process_cmdline (state, arglst)
end // end of [process_cmdline2_COMARGkey1]

and
process_cmdline2_COMARGkey2
(
  state: &cmdstate >> _, arglst: comarglst, key: string
) : void = let
//
val () = state.waitkind := WTKnone ()
//
val () = (
//
case+ key of
//
| "--input" => {
    val () = state.ninputfile := 0
    val () = state.waitkind := WTKinput()
  } (* end of [--input] *)
//
| "--output" => {
    val () = state.waitkind := WTKoutput ()
  } (* end of [--output] *)
//
| "--help" => {
    val () = atscc2py3_usage ("atscc2py3")
    val () = state.waitkind := WTKnone(*void*)
    val () = if state.ninputfile < 0 then state.ninputfile := 0
  } (* end of [--help] *)
//
| _ (*unrecognized*) => comarg_warning (key)
//
) : void // end of [val]
//
in
  process_cmdline (state, arglst)
end // end of [process_cmdline2_COMARGkey2]

(* ****** ****** *)
//
extern
fun
comarg_parse (string):<> comarg
//
extern
fun
comarglst_parse{n:nat}
  (argc: int n, argv: !argv(n)): list (comarg, n)
// end of [comarglst_parse]
//
(* ****** ****** *)

implement
comarg_parse
  (str) = let
//
fun
loop
  {n,i:nat | i <= n} .<n-i>.
(
  str: string n, n: int n, i: int i
) :<> comarg =
(
  if i < n
    then (
    if (str[i] != '-')
      then COMARGkey (i, str) else loop (str, n, i+1)
    ) else COMARGkey (n, str)
) (* end of [if] *)
// end of [loop]
//
val str = g1ofg0(str)
val len = string_length (str)
//
in
  loop (str, sz2i(len), 0)
end // end of [comarg_parse]

(* ****** ****** *)

implement
comarglst_parse
  {n}(argc, argv) = let
//
fun
loop
  {i,j:nat | i <= n} .<n-i>.
(
  argv: !argv(n), i: int(i), res: list_vt(comarg, j)
) : list_vt (comarg, n-i+j) =
(
if i < argc
  then let
    val res = list_vt_cons (comarg_parse (argv[i]), res)
  in
    loop (argv, i+1, res)
  end // end of [then]
  else res // end of [else]
// end of [if]
) (* end of [loop] *)
//
val res =
  loop (argv, 0, list_vt_nil())
//
in
  list_vt2t (list_vt_reverse (res))
end // end of [comarglst_parse]

(* ****** ****** *)

implement
main0
(
argc, argv
) = {
//
val () =
prerrln!
(
  "Hello from atscc2py3!"
) (* end of [val] *)
//
//
val arglst =
  comarglst_parse(argc, argv)
//
val+list_cons(arg0, arglst) = arglst
//
var
state = @{
  comarg0= arg0
, ncomarg= 0
, waitkind= WTKnone
, ninputfile= ~1
, outchan= OUTCHANref(stdout_ref)
, nerror= 0
} : cmdstate
val () = process_cmdline(state, arglst)
val () =
if
state.nerror = 1
then let
  val () =
  println! ("atscc2py3: there is a reported error.")
in
end
else if
state.nerror >= 2
then let
  val () =
  println! ("atscc2py3: there are some reported errors.")
in
end
else ()
(*
val () =
prerrln! ("Good-bye from atscc2py3!")
*)
}