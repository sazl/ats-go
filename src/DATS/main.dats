#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

val () = catsparse_all_dynload() where {
    extern fun
    catsparse_all_dynload(): void = "ext#"
}

#dynload "./util.dats"
#dynload "./cli.dats"
#dynload "./emit.dats"
#dynload "./emit2.dats"

implement main0
(argc, argv) = {
(*
    val () = prerrln!("Hello from atscc2py3!")
    val arglst = comarglst_parse(argc, argv)
    val+ list_cons(arg0, arglst) = arglst

    var state = @{
        arg0 = arg0,
        arg_count = 0,
        waitkind= WTKnone,
        input_file_count = ~1,
        out_chan = OUTCHANref(stdout_ref),
        error_count = 0,
    } : cmdstate

    val () = process_cmdline(state, arglst)
    val () =
        if state.nerror = 1
        then
            let
                val () = println! ("atscc2py3: there is a reported error.")
            in
            end
        else if state.nerror >= 2
        then
            let
                val () = println! ("atscc2py3: there are some reported errors.")
            in
            end
        else
            ()
    val () = prerrln! ("Good-bye from atscc2py3!")
*)
}