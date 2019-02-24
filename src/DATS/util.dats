#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define CATSPARSEMIT_targetloc "./../../vendor/CATS-parsemit"
#endif

staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
staload "{$CATSPARSEMIT}/SATS/catsparse_parsing.sats"

staload "./../SATS/util.sats"
staload "./../SATS/cli.sats"

(*
implement go_fileref
  (state, inp) =
    let
        val out = outchan_get_fileref(state.out_chan)
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

implement go_basename
(state, fname) = (
    case+ fname of
    | "-" =>
        let
            val inp = stdin_ref
        in
            go_fileref(state, inp)
        end
    | _ => go_basename_(state, fname)
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
                val () = go_fileref(state, inp)
            }
        else
            let
                prval () = $STDIO.FILEptr_free_null(inp)
                val () = (state.error_count := state.error_count + 1)
            in
            end
end
*)