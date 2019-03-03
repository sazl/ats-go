#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

val () = catsparse_all_dynload() where {
    extern fun
    catsparse_all_dynload(): void = "ext#"
}

#staload "./../SATS/util.sats"
#staload "./../SATS/cli.sats"
#staload "./../SATS/emit.sats"
#staload "./../SATS/emit2.sats"

implement main0
(argc, argv) = {
    val () = prerrln!("ats-go: <version>")
    val arglst = cli_argument_list_parse(argc, argv)
    val+ list_cons(arg0, arglst) = arglst

    var state = @{
        arg0 = arg0,
        arg_count = 0,
        waitkind= WTKnone,
        input_file_count = ~1,
        out_chan = OUTCHANref(stdout_ref),
        error_count = 0
    } : cli_state

    val () = process_cmdline(state, arglst)
    val () =
        if state.error_count = 1
        then
            let
                val () = println! ("atscc2py3: there is a reported error.")
            in
            end
        else if state.error_count >= 2
        then
            let
                val () = println! ("atscc2py3: there are some reported errors.")
            in
            end
        else
            ()
    val () = prerrln! ("Good-bye from atscc2py3!")
}