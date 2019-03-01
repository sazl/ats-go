#include "share/atspre_staload.hats"

#staload "./../SATS/cli.sats"
#staload "./../SATS/util.sats"

implement outchan_get_fileref
(chan_out) = (
    case+ chan_out of
    | OUTCHANref (filr) => filr
    | OUTCHANptr (filp) => filp
)

implement cli_state_set_outchan
(state, chan_new) =
    let
        val chan_old = state.out_chan
        val () = state.out_chan := chan_new
    in
        case+
        chan_old of
        | OUTCHANref(filr) => ()
        | OUTCHANptr(filp) =>
            let
                val err = $STDIO.fclose0(filp)
            in
            end
    end

implement cli_state_set_outchan_basename
(state, basename) =
    let
        val filp = $STDIO.fopen(basename, file_mode_w)
        val p0 = $STDIO.ptrcast(filp)
        (* val () = println! ("cli_state_set_outchan_basename: p0 = ", p0) *)
    in
        if p0 > 0
        then
            let
                val filp = $UNSAFE.castvwtp0{FILEref}(filp)
            in
                cli_state_set_outchan(state, OUTCHANptr(filp))
            end
        else
            let
                prval () = $STDIO.FILEptr_free_null (filp)
                val () = state.error_count := state.error_count + 1
            in
                cli_state_set_outchan (state, OUTCHANref(stderr_ref))
            end
end

fn isinwait
(state: cli_state)
: bool = (
  case+ state.waitkind of
  | WTKinput () => true
  | _ => false
)

fn isoutwait
(state: cli_state)
: bool = (
  case+ state.waitkind of
  | WTKoutput () => true
  | _ => false
)

implement cli_argument_warning
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
}

fun process_cmdline
(state: &cli_state, arglst: cli_argument_list)
: void =
    let
    in
        case+ arglst of
        | list_nil () =>
            let
                val nif = state.input_file_count
                val wait0 = (
                    case+ 0 of
                    | _ when nif < 0 => true
                    | _ when nif = 0 => isinwait (state)
                    | _ => false
                ) : bool
            in
                if wait0 then (
                    if state.arg_count = 0
                    then go_usage ("atscc2py3")
                    else go_fileref (state, stdin_ref)
                )
            end
        | list_cons (arg, arglst) =>
            let
                val () = state.arg_count := state.arg_count + 1
            in
                process_cmdline2 (state, arg, arglst)
            end
    end
and
    process_cmdline2
    (state: &cli_state, arg: cli_argument, arglst: cli_argument_list)
    : void =
        let
        in
            case+ arg of
            | _ when isinwait(state) =>
                let
                    val nif = state.input_file_count
                in
                    case+ arg of
                    | COMARGkey (1, key) when nif > 0 =>
                        process_cmdline2_COMARGkey1 (state, arglst, key)
                    | COMARGkey (2, key) when nif > 0 =>
                        process_cmdline2_COMARGkey2 (state, arglst, key)
                    | COMARGkey (_, fname) =>
                        let
                            val () = state.input_file_count := nif + 1
                            val () = go_basename (state, fname)
                        in
                            process_cmdline (state, arglst)
                        end
                end
            | _ when isoutwait(state) =>
                let
                    val COMARGkey (_, fname) = arg
                    val () = cli_state_set_outchan_basename (state, fname)
                    val () = state.waitkind := WTKnone ()
                in
                    process_cmdline (state, arglst)
                end
            | COMARGkey (1, key) =>
                process_cmdline2_COMARGkey1 (state, arglst, key)
            | COMARGkey (2, key) =>
                process_cmdline2_COMARGkey2 (state, arglst, key)
            | COMARGkey (_, key) => let
                val () = cli_argument_warning (key)
                val () = state.waitkind := WTKnone ()
            in
                process_cmdline (state, arglst)
            end
        end
and
    process_cmdline2_COMARGkey1
    (state: &cli_state >> _, arglst: cli_argument_list, key: string)
    : void =
        let
            val () = (
                case+ key of
                | "-i" => {
                    val () = state.input_file_count := 0
                    val () = state.waitkind := WTKinput()
                }
                | "-o" => {
                    val () = state.waitkind := WTKoutput ()
                }
                | "-h" => {
                    val () = go_usage ("atscc2py3")
                    val () = state.waitkind := WTKnone
                    val () = if state.input_file_count < 0 then state.input_file_count := 0
                }
                | _ => cli_argument_warning (key)
            ): void
        in
            process_cmdline (state, arglst)
        end
and
    process_cmdline2_COMARGkey2
    (state: &cli_state >> _, arglst: cli_argument_list, key: string)
    : void =
    let
        val () = state.waitkind := WTKnone ()
        val () = (
            case+ key of
            | "--input" => {
                val () = state.input_file_count := 0
                val () = state.waitkind := WTKinput()
            }
            | "--output" => {
                val () = state.waitkind := WTKoutput ()
            }
            | "--help" => {
                val () = go_usage ("atscc2py3")
                val () = state.waitkind := WTKnone
                val () = if state.input_file_count < 0 then state.input_file_count := 0
            }
            | _  => cli_argument_warning (key)
        ) : void
    in
        process_cmdline (state, arglst)
    end

implement cli_argument_parse
(str) =
    let
        fun loop
        {n,i:nat | i <= n} .<n-i>.
        (str: string n, n: int n, i: int i)
        :<> cli_argument = (
            if i < n
            then (
                if (str[i] != '-')
                then COMARGkey (i, str) else loop (str, n, i+1)
            )
            else COMARGkey (n, str)
        )

        val str = g1ofg0(str)
        val len = string_length (str)
    in
        loop (str, sz2i(len), 0)
    end

implement cli_argument_list_parse
{n}(argc, argv) =
    let
        fun loop
        {i,j:nat | i <= n} .<n-i>.
        (argv: !argv(n), i: int(i), res: list_vt(cli_argument, j))
        : list_vt (cli_argument, n-i+j) = (
            if i < argc
            then
                let
                    val res = list_vt_cons (cli_argument_parse (argv[i]), res)
                in
                    loop (argv, i+1, res)
                end
            else res
        )
        val res = loop (argv, 0, list_vt_nil())
    in
        list_vt2t (list_vt_reverse (res))
    end
