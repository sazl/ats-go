#staload "../SATS/cli.sats"

implement command_state_set_outchan
(state, chan_new) =
    let
        val chan_old = state.outchan
        val () = state.outchan := chan_new
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

implement command_state_set_outchan_basename
(state, basename) =
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
: bool = (
  case+ state.waitkind of
  | WTKinput () => true
  | _ => false
)

fn isoutwait
(state: cmdstate)
: bool = (
  case+ state.waitkind of
  | WTKoutput () => true
  | _ => false
)

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
}

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
                    | _ => false
                ) : bool
            in
                if wait0 then (
                    if state.ncomarg = 0
                    then atscc2py3_usage ("atscc2py3")
                    else atscc2py3_fileref (state, stdin_ref)
                )
            end
        | list_cons (arg, arglst) =>
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
            | _ when isinwait(state) =>
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
                            val () = atscc2py3_basename (state, fname)
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
    (state: &cmdstate >> _, arglst: comarglst, key: string)
    : void =
        let
            val () = (
                case+ key of
                | "-i" => {
                    val () = state.ninputfile := 0
                    val () = state.waitkind := WTKinput()
                }
                | "-o" => {
                    val () = state.waitkind := WTKoutput ()
                }
                | "-h" => {
                    val () = atscc2py3_usage ("atscc2py3")
                    val () = state.waitkind := WTKnone
                    val () = if state.ninputfile < 0 then state.ninputfile := 0
                }
                | _ => comarg_warning (key)
            ): void
        in
            process_cmdline (state, arglst)
        end
and
    process_cmdline2_COMARGkey2
    (state: &cmdstate >> _, arglst: comarglst, key: string)
    : void =
    let
        val () = state.waitkind := WTKnone ()
        val () = (
            case+ key of
            | "--input" => {
                val () = state.ninputfile := 0
                val () = state.waitkind := WTKinput()
            }
            | "--output" => {
                val () = state.waitkind := WTKoutput ()
            }
            | "--help" => {
                val () = atscc2py3_usage ("atscc2py3")
                val () = state.waitkind := WTKnone
                val () = if state.ninputfile < 0 then state.ninputfile := 0
            }
            | _  => comarg_warning (key)
        ) : void
    in
        process_cmdline (state, arglst)
    end

implement comarg_parse
(str) =
    let
        fun loop
        {n,i:nat | i <= n} .<n-i>.
        (str: string n, n: int n, i: int i)
        :<> comarg = (
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
        (argv: !argv(n), i: int(i), res: list_vt(comarg, j))
        : list_vt (comarg, n-i+j) = (
            if i < argc
            then
                let
                    val res = list_vt_cons (comarg_parse (argv[i]), res)
                in
                    loop (argv, i+1, res)
                end
            else res
        )
        val res = loop (argv, 0, list_vt_nil())
    in
        list_vt2t (list_vt_reverse (res))
    end
