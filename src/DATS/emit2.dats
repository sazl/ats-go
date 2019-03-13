#include "share/atspre_staload.hats"
staload UN = "prelude/SATS/unsafe.sats"

#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define CATSPARSEMIT_targetloc "./../../vendor/CATS-parsemit"
#endif

#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_syntax.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_typedef.sats"

staload "./../SATS/emit2.sats"

local
    val the_statmps = ref<d0eclist> (list_nil)
in
    implement the_statmpdeclst_get
    () =
        list_vt2t(list_reverse(!the_statmps))

    implement the_statmpdeclst_insert
    (d0c) =
        let
            val d0cs = !the_statmps
        in
            !the_statmps := list_cons (d0c, d0cs)
        end
end

implement emit_the_statmpdeclst
(out, ind) =
    let
        fun auxlst
        (out: FILEref, xs: d0eclist)
        : void = (
            case+ xs of
            | list_nil() => ()
            | list_cons(x, xs) =>
                let
                    val- D0Cstatmp (tmp, opt) = x.d0ecl_node
                in
                    case+ opt of
                    | None _ => auxlst(out, xs)
                    | Some _ => auxlst(out, xs) where {
                        val () = emit_ENDL(out)
                        val () = emit_nspc(out, ind)
                        val () = (
                            emit_text(out, "global ");
                            emit_tmpvar(out, tmp)
                        )
                    }
                end
        )
    in
        auxlst(out, the_statmpdeclst_get())
    end

implement emit_f0arglst_nonlocal
(out, f0as) =
    let

        fun auxlst
        (out: FILEref, f0as: f0arglst, i: int)
        : void = (
            case+ f0as of
            | list_nil () => ()
            | list_cons (f0a, f0as) => (
                case- f0a.f0arg_node of
                | F0ARGsome (arg, _) =>
                    let
                        val () = if i > 0 then emit_text(out, ", ")
                        val () = emit_tmpvar(out, arg)
                    in
                        auxlst(out, f0as, i+1)
                    end
            )
        )
    in
        case+ f0as of
        | list_nil() => { }
        | list_cons _ => {
            val () = emit_nspc(out, 4)
            val () = emit_text(out, "nonlocal ")
            val () = auxlst(out, f0as, 0)
            val () = emit_ENDL(out)
        }
    end

implement emit_tmpdeclst_initize
(out, tds) =
    let
        fun auxlst
        (out: FILEref, tds: tmpdeclst)
        : void = (
            case+ tds of
            | list_nil() => ()
            | list_cons(td, tds) => (
                case+
                td.tmpdec_node
                of
                | TMPDECnone(tmp) =>
                (
                    auxlst(out, tds)
                )
                | TMPDECsome(tmp, _) =>
                    auxlst(out, tds) where
                {
                    val () =
                    emit_nspc(out, 2)

                    val () = emit_tmpvar(out, tmp)
                    val () = emit_text(out, " = None\n")
                }
            )
        )
    in
        auxlst(out, tds)
    end

implement emit_tmpdeclst_nonlocal
(out, tds) =
    let
        fun auxlst
        (out: FILEref, tds: tmpdeclst, i: int)
        : void = (
            case+ tds of
            | list_nil() => ()
            | list_cons(td, tds) =>
            (
                case+
                td.tmpdec_node
                of
                | TMPDECnone(tmp) =>
                (
                    auxlst(out, tds, i)
                )
                | TMPDECsome(tmp, _) =>
                auxlst(out, tds, i+1) where {
                    val () = if i > 0 then emit_text(out, ", ")
                    val () = emit_tmpvar(out, tmp)
                }
            )
        )
    in
        case+ tds of
        | list_nil() => ()
        | list_cons _ => () where {
            val () = emit_nspc(out, 4)
            val () = emit_text(out, "nonlocal")
            val () = emit_SPACE(out)
            val () = auxlst(out, tds, 0)
            val () = emit_newline(out)
        }
    end

implement emit_mbranchlst_initize
(out, inss) =
    let
        fun auxlst
        (out: FILEref, inss: instrlst, i: int)
        : void = (
            case+ inss of
            | list_nil() => ()
            | list_cons (_, inss) => () where {
                val () = emit_nspc(out, 2)
                val () = (
                    emit_text(out, "mbranch_");
                    emit_int(out, i);
                    emit_text(out, " = None\n")
                )
                val () = auxlst(out, inss, i+1)
            }
        )
    in
        auxlst(out, inss, 1)
    end

implement
emit_mbranchlst_nonlocal
(out, inss) =
    let
        fun auxlst
        (out: FILEref, inss: instrlst, i: int)
        : void = (
            case+ inss of
            | list_nil() => ()
            | list_cons(_, inss) =>
                let
                    val () = if i >= 2 then emit_text(out, ", ")
                    val () = (
                        emit_text(out, "mbranch_");
                        emit_int(out, i)
                    )
                in
                    auxlst(out, inss, i+1)
                end
        )
    in
        case+ inss of
        | list_nil() => ()
        | list_cons _ => () where {
            val () = emit_nspc(out, 4)
            val () = emit_text(out, "nonlocal ")
            val () = auxlst(out, inss, 1)
            val () = emit_ENDL(out)
        }
    end

local
    val the_f0arglst = ref<f0arglst>(list_nil)
    val the_tmpdeclst = ref<tmpdeclst>(list_nil)
    val the_funbodylst = ref<instrlst>(list_nil)
    val the_branchlablst = ref<labelist>(list_nil)
    val the_caseofseqlst = ref<instrlst>(list_nil)
in
    implement the_f0arglst_get
    () = !the_f0arglst

    implement the_f0arglst_set
    (xs) = !the_f0arglst := xs

    implement the_tmpdeclst_get
    () = !the_tmpdeclst

    implement the_tmpdeclst_set
    (xs) = !the_tmpdeclst := xs

    implement the_funbodylst_get
    () = !the_funbodylst

    implement the_funbodylst_set
    (xs) = !the_funbodylst := xs

    implement the_branchlablst_get
    () = !the_branchlablst

    implement the_branchlablst_set
    (tls) = !the_branchlablst := tls

    implement the_caseofseqlst_get
    () = !the_caseofseqlst

    implement the_caseofseqlst_set
    (xs) = !the_caseofseqlst := xs
end



implement funlab_get_index
(fl0) =
let
    val n0 = fl0.i0dex_sym

    fun auxlst
    (xs: instrlst, i: int)
    : int = (
        case+ xs of
        | list_nil () => ~1
        | list_cons (x, xs) => (
            case+ x.instr_node of
            | ATSfunbodyseq _ =>
                let
                    val fl = funbodyseq_get_funlab(x)
                in
                    if n0 = fl.i0dex_sym then i else auxlst(xs, i+1)
                end
            | _  => auxlst(xs, i)
        )
    )
in
    auxlst(the_funbodylst_get(), 1)
end


implement tmplab_get_index
(lab0) =
let
    val n0 = lab0.i0dex_sym

    fun auxlst
    (xs: labelist, i: int)
    : int = (
        case+ xs of
        | list_nil () => ~1
        | list_cons(x, xs) =>
            if n0 = x.i0dex_sym then i else auxlst (xs, i+1)
    )
in
    auxlst(the_branchlablst_get(), 1)
end

fun emit_funlab_index
(out: FILEref, fl: label): void =
    emit_int(out, funlab_get_index(fl))

fun emit_tmplab_index
(out: FILEref, lab: label): void =
    emit_int(out, tmplab_get_index(lab))

implement branchmap_get_index
(x0) =
    let
        val p0 = $UN.cast2ptr(x0)

        fun auxlst
        (xs: instrlst, i: int) : int = (
            case xs of
            | list_nil() => ~1
            | list_cons(x, xs) =>
                if $UN.cast2ptr(x) = p0 then i else auxlst(xs, i+1)
        )
    in
        auxlst(the_caseofseqlst_get(), 1)
    end

fun
emit_branchmap_index
(out: FILEref, ins: instr): void =
    emit_int(out, branchmap_get_index(ins))

fun emit_branchmap
(out: FILEref, ins0: instr)
: void =
    let
        fun auxlst
        (out: FILEref, xs: instrlst, i: int)
        : int = (
            case+ xs of
            | list_nil() => i
            | list_cons(x, xs) => (
                case+ x.instr_node of
                | ATSINSlab (lab) =>
                    let
                        val () = if i >= 2 then emit_text(out, ", ")
                        val () = emit_int (out, i)
                        val () = emit_text (out, ": ")
                        val () = emit_label (out, lab)
                    in
                        auxlst (out, xs, i+1)
                    end
                | _ => auxlst (out, xs, i)
            )
        )

        fun auxlst2
        (out: FILEref, xs: instrlst, i: int)
        : void = (
            case+ xs of
            | list_nil() => ()
            | list_cons(x, xs) =>
                let
                    val-ATSbranchseq(inss) = x.instr_node
                in
                    auxlst2 (out, xs, auxlst (out, inss, i))
                end
        )

        val- ATScaseofseq(inss) = ins0.instr_node
        val () = emit_nspc(out, 2)
        val () = emit_text(out, "mbranch_")
        val () = emit_branchmap_index(out, ins0)
        val () = emit_text(out, " = ")
        val () = emit_text(out, "{ ")
        val () = auxlst2(out, inss, 1)
        val () = emit_text(out, " }\n")
    in
    end

fun emit_branchmaplst
(out: FILEref, inss: instrlst)
: void = (
    case+ inss of
    | list_nil () => ()
    | list_cons (ins, inss) => {
        val () = emit_branchmap (out, ins)
        val () = emit_branchmaplst (out, inss)
    }
)

implement f0body_collect_caseof
(fbody) =
    let
    in
        case+ fbody.f0body_node of
        | F0BODY(tds, inss) => instrlst_collect_caseof(inss)
    end

implement instrlst_collect_caseof
(inss) =
    let
        vtypedef res = instrlst_vt

        fun aux
        (ins: instr, res: res)
        : res = (
            case+ ins.instr_node of
            | ATScaseofseq (inss) => auxlst(inss, cons_vt(ins, res))
            | ATSbranchseq(inss) => auxlst(inss, res)
            | ATSif (d0e, inss, inssopt) =>
                let
                    val res = auxlst(inss, res)
                in
                    case+ inssopt of
                    | None() => res
                    | Some(inss) => auxlst(inss, res)
                end
            | ATSifthen(d0e, inss) => auxlst(inss, res)
            | ATSifnthen(d0e, inss) => auxlst(inss, res)
            | ATSfunbodyseq(inss) => auxlst(inss, res)
            | _  => res
        )
        and
            auxlst
            (inss: instrlst, res: res)
            : res = (
                case+ inss of
                | list_cons (ins, inss) =>
                let
                    val res = aux (ins, res)
                in
                    auxlst(inss, res)
                end
                | list_nil() => res
            )

        val res = auxlst(inss, list_vt_nil)
    in
        list_vt2t(list_vt_reverse(res))
    end

implement emit_instr
(out, ins) = emit2_instr (out, 0, ins)

implement emit2_instr
(out, ind, ins0) =
    let
    in
        case+ ins0.instr_node of
        | ATSif (d0e, inss, inssopt) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "if ")
            val () = emit_d0exp (out, d0e)
            val () = emit_text (out, " {\n")
            val () = emit2_instrlst (out, ind+2, inss)
            val () = (
                case+ inssopt of
                | None() => ()
                | Some(inss) => (
                    case+ inss of
                    | list_nil _ => ()
                    | list_cons _ => {
                        val () = emit_nspc (out, ind)
                        val () = emit_text (out, "} else {\n")
                        val () = emit2_instrlst (out, ind+2, inss)
                    }
                )
            )

            val () = emit_nspc (out, ind)
            val () = emit_text (out, "}\n")
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "// endif")

        }

        | ATSifthen (d0e, inss) => {
            val- list_sing(ins) = inss
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "if ")
            val () = emit_d0exp (out, d0e)
            val () = emit_text (out, " {\n")
            val () = emit_instr (out, ins)
            val () = emit_text (out, "}\n")
        }
        | ATSifnthen (d0e, inss) => {
            val-list_sing(ins) = inss
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "if !(")
            val () = emit_d0exp (out, d0e)
            val () = emit_text (out, ") {\n")
            val () = emit_instr (out, ins)
            val () = emit_text (out, "}\n")
        }
        | ATSbranchseq (inss) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "#ATSbranch")
        }
        | ATScaseofseq (inss) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "#ATScaseofseq_beg")
            val () = emit_ENDL (out)
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "tmplab_py = 1\n")
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "while(1):\n")
            val () = emit_nspc (out, ind+2)
            val () = emit_text (out, "mbranch_")
            val () = emit_branchmap_index (out, ins0)
            val () = emit_text (out, ".get(tmplab_py)()\n")
            val () = emit_nspc (out, ind+2)
            val () = emit_text (out, "if (tmplab_py == 0): break\n")
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "#ATScaseofseq_end")
        }
        | ATSreturn (tmp) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "return ")
            val () = emit_tmpvar (out, tmp)
        }
        | ATSreturn_void (tmp) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "return#_void")
        }
        | ATSlinepragma (line, file) => {
            val () = emit_text (out, "#line ")
            val () = emit_PMVint (out, line)
            val () = emit_SPACE (out)
            val () = emit_PMVstring (out, file)
        }
        | ATSINSlab (lab) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "#")
            val () = emit_label (out, lab)
        }
        | ATSINSgoto (lab) => {
            val () = emit_nspc (out, ind)
            val () = emit_text (out, "tmplab_py = ")
            val () = emit_tmplab_index (out, lab)
            val () = (
                emit_SPACE (out);
                emit_text (out, "; return");
                emit_SHARP (out); emit_label (out, lab)
            )
        }
        | ATSINSflab (flab) => {
            val () = emit_nspc (out, ind)
            val () = emit_SHARP (out)
            val () = emit_label (out, flab)
        }
        | ATSINSfgoto (flab) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "funlab_py = ")
            val () = emit_funlab_index(out, flab)
            val () =  (
                emit_SPACE(out);
                emit_SHARP(out);
                emit_label(out, flab)
            )
        }
        | ATSINSfreeclo(d0e) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSINSfreeclo")
            val () = emit_LPAREN(out)
            val () = emit_d0exp(out, d0e)
            val () = emit_RPAREN(out)
            val () = emit_SEMICOLON(out)
        }
        | ATSINSfreecon (d0e) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSINSfreecon")
            val () = emit_LPAREN(out)
            val () = emit_d0exp(out, d0e)
            val () = emit_RPAREN(out)
            val () = emit_SEMICOLON(out)
        }
        | ATSINSmove(tmp, d0e) => {
            val () = emit_nspc(out, ind)
            val () = emit_tmpvar(out, tmp)
            val () = (
                emit_text(out, " = ");
                emit_d0exp(out, d0e)
            )
        }
        | ATSINSmove_void(tmp, d0e) => {
            val () = emit_nspc(out, ind)
            val () = (
                case+ d0e.d0exp_node of
                | ATSPMVempty _ => emit_text(out, "None#ATSINSmove_void")
                | _  => emit_d0exp(out, d0e)
            ) : void
        }
        | ATSINSmove_nil(tmp) => {
            val () = emit_nspc(out, ind)
            val () = emit_tmpvar(out, tmp)
            val () = emit_text(out, " = ")
            val () = emit_text(out, "None")
        }
        | ATSINSmove_con0(tmp, tag) => {
            val () = emit_nspc(out, ind)
            val () = emit_tmpvar(out, tmp)
            val () = (
                emit_text(out, " = ");
                emit_PMVint(out, tag)
            )
        }
        | ATSINSmove_con1 _ => emit2_ATSINSmove_con1(out, ind, ins0)
        | ATSINSmove_boxrec _ => emit2_ATSINSmove_boxrec(out, ind, ins0)
        | ATSINSmove_delay _ => emit2_ATSINSmove_delay(out, ind, ins0)
        | ATSINSmove_lazyeval _ => emit2_ATSINSmove_lazyeval(out, ind, ins0)
        | ATSINSmove_ldelay _ => emit2_ATSINSmove_ldelay(out, ind, ins0)
        | ATSINSmove_llazyeval _ => emit2_ATSINSmove_llazyeval(out, ind, ins0)
        | ATStailcalseq(inss) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATStailcalseq_beg")
            val () = emit_ENDL(out)
            val () = emit2_instrlst(out, ind, inss)
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATStailcalseq_end")
        }
        | ATSINSmove_tlcal(tmp, d0e) => {
            val () = emit_nspc(out, ind)
            val () = emit_tmpvar(out, tmp)
            val () = emit_text(out, " = ")
            val () = emit_d0exp(out, d0e)
        }
        | ATSINSargmove_tlcal(tmp1, tmp2) => {
            val () = emit_nspc(out, ind)
            val () = emit_tmpvar(out, tmp1)
            val () = emit_text(out, " = ")
            val () = emit_tmpvar(out, tmp2)
        }
        | ATSINSextvar_assign(ext, d0e_r) => {
            val () = emit_nspc(out, ind)
            val () = emit_d0exp(out, ext)
            val () = emit_text(out, " = ")
            val () = emit_d0exp(out, d0e_r)
            val () = emit_SEMICOLON(out)
        }
        | ATSINSdyncst_valbind(d2c, d0e_r) => {
            val () = emit_nspc(out, ind)
            val () = emit_i0de(out, d2c)
            val () = emit_text(out, " = ")
            val () = emit_d0exp(out, d0e_r)
            val () = emit_SEMICOLON(out)
        }
        | ATSINScaseof_fail(errmsg) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "ATSINScaseof_fail")
            val () = emit_LPAREN(out)
            val () = emit_PMVstring(out, errmsg)
            val () = emit_RPAREN(out)
            val () = emit_SEMICOLON(out)
        }
        | ATSINSdeadcode_fail(__tok__) => {
            val () = emit_nspc(out, ind)
            val () =
            emit_text(out, "ATSINSdeadcode_fail()")
            val () = emit_SEMICOLON(out)
        }
        | ATSdynload(dummy) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSdynload()")
            val () = emit_the_statmpdeclst(out, ind)
        }
        | ATSdynloadset(flag) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSdynloadset\n")
            val () = emit_nspc(out, ind)
            val () = (
                emit_tmpvar(out, flag);
                emit_text(out, " = 1")
            )
        }
        | ATSdynloadfcall(fcall) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSdynloadfcall\n")
            val () = emit_nspc(out, ind)
            val () = (
                emit_tmpvar(out, fcall);
                emit_text(out, "()")
            )
        }
        | ATSdynloadflag_sta(flag) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSdynloadflag_sta\n")
            val () = emit_nspc(out, ind)
            val () = (
                emit_text(out, "global ");
                emit_tmpvar(out, flag)
            )
        }
        | ATSdynloadflag_ext(flag) => {
            val () = emit_nspc(out, ind)
            val () = emit_text(out, "#ATSdynloadflag_ext\n")
            val () = emit_nspc(out, ind)
            val () = (
                emit_text(out, "global ");
                emit_tmpvar(out, flag)
            )
        }
        | _  => {
            val () = emit_nspc(out, ind)
            val () =
            fprint!(out, "ERROR: UNRECOGNIZED-INSTRUCTION: ", ins0)
        }
    end


implement emit2_instr_ln
(out, ind, ins) = (
    emit2_instr(out, ind, ins);
    emit_ENDL(out)
)

implement emit2_instr_newline
(out, ind, ins) = (
    emit2_instr(out, ind, ins);
    emit_newline(out)
)

implement emit2_instrlst
(out, ind, inss) = (
    case+ inss of
    | list_nil() => ()
    | list_cons (ins, inss) =>
        let
            val () = emit2_instr(out, ind, ins)
        in
            emit_ENDL(out); emit2_instrlst(out, ind, inss)
        end
)

implement emit2_ATSfunbodyseq
(out, ind, ins) =
    let
        val- ATSfunbodyseq (inss) = ins.instr_node
    in
        emit2_instrlst(out, ind, inss)
    end

implement emit2_ATSINSmove_con1
(out, ind, ins0) =
    let
        fun getarglst
        (inss: instrlst)
        : d0explst = (
            case+ inss of
            | list_nil() => list_nil()
            | list_cons (ins, inss) =>
                let
                    val- ATSINSstore_con1_ofs (_, _, _, d0e) = ins.instr_node
                    val d0es = getarglst(inss)
                in
                    list_cons(d0e, d0es)
                end
        )

        val- ATSINSmove_con1 (inss) = ins0.instr_node
        val- list_cons (ins, inss) = inss
        val- ATSINSmove_con1_new (tmp, _) = ins.instr_node
        var opt: tokenopt = None()

        val inss = (
            case+ inss of
            | list_nil
                () => inss

            | list_cons
                (ins, inss2) =>
            (
                case+
                ins.instr_node
                of
                | ATSINSstore_con1_tag
                    (tmp, tag) => let
                    val () = opt := Some(tag) in inss2
                end
                | _  => inss
            )
        ) : instrlst

        val d0es = getarglst(inss)

        val () = emit_nspc(out, ind)
        val () = emit_tmpvar(out, tmp)
        val () = emit_text(out, " = ")
        val () = emit_LPAREN(out)

        val () = (
            case+ opt of
            | None() => ()
            | Some(tag) => emit_PMVint(out, tag)
        ) : void

        val () = (
            case+ opt of
            | None _ => emit_d0explst(out, d0es)
            | Some _ => emit_d0explst_1(out, d0es)
        ) : void

        val ntup = (
            case+ opt of
            | None _ => list_length<d0exp>(d0es)
            | Some _ => list_length<d0exp>(d0es) + 1
        ) : int

        val () = (
            if ntup = 1
            then emit_text(out, ", )") else emit_RPAREN(out)
        ) : void
    in

    end

implement emit2_ATSINSmove_boxrec
(out, ind, ins0) =
    let
        fun getarglst
        (inss: instrlst)
        : d0explst = (
            case+ inss of
            | list_nil () => list_nil()
            | list_cons (ins, inss) =>
                let
                    val- ATSINSstore_boxrec_ofs (_, _, _, d0e) = ins.instr_node
                    val d0es = getarglst(inss)
                in
                    list_cons( d0e, d0es )
                end
        )

        val- ATSINSmove_boxrec (inss) = ins0.instr_node
        val- list_cons (ins, inss) = inss
        val- ATSINSmove_boxrec_new (tmp, _) = ins.instr_node

        val d0es = getarglst (inss)

        val () = emit_nspc(out, ind)
        val () = emit_tmpvar(out, tmp)
        val () = emit_text(out, " = ")
        val () = emit_LPAREN(out)
        val () = emit_d0explst(out, d0es)

        val () = (
            if list_is_sing(d0es)
            then emit_text(out, ", )")
            else emit_RPAREN(out)
        ) : void
    in
    end

implement emit2_ATSINSmove_delay
(out, ind, ins0) =
    let
        val- ATSINSmove_delay (tmp, s0e, thunk) = ins0.instr_node
        val () = emit_nspc(out, ind)
        val () = emit_tmpvar(out, tmp)
        val () = emit_text(out, " = [")
        val () = (
          emit_int(out, 0);
          emit_text(out, ", ");
          emit_d0exp(out, thunk)
        )
        val () = emit_text(out, "]")
    in
    end

implement emit2_ATSINSmove_lazyeval
(out, ind, ins0) =
    let
        val- ATSINSmove_lazyeval (tmp, s0e, lazyval) = ins0.instr_node
        val () = emit_nspc(out, ind)

        val () = (
           emit_tmpvar(out, tmp);
           emit_text(out, " = ")
        )
        val () = (
            emit_text(out, "ATSPMVlazyval_eval(");
            emit_d0exp(out, lazyval);
            emit_text(out, "); ")
        )
    in
    end

implement emit2_ATSINSmove_ldelay
(out, ind, ins0) =
    let
        val- ATSINSmove_ldelay (tmp, s0e, thunk) = ins0.instr_node
        val () = emit_nspc (out, ind)

        val () = (
            emit_tmpvar(out, tmp);
            emit_text(out, " = ");
            emit_d0exp(out, thunk)
        )
    in
    end

implement emit2_ATSINSmove_llazyeval
(out, ind, ins0) =
    let
        val- ATSINSmove_llazyeval (tmp, s0e, lazyval) = ins0.instr_node
        val () = emit_nspc(out, ind)

        val () = (
            emit_tmpvar(out, tmp);
            emit_text(out, " = ")
        )

        val () = (
            emit_text(out, "ATSPMVllazyval_eval(");
            emit_d0exp (out, lazyval);
            emit_text (out, ")")
        )
    in
    end


#define ATSEXTCODE_BEG "######\n#ATSextcode_beg()\n######"
#define ATSEXTCODE_END "######\n#ATSextcode_end()\n######"

implement emit_d0ecl
(out, d0c0) =
    let
    in
        case+ d0c0.d0ecl_node of
        | D0Cinclude _ => ()
        | D0Cifdef _ => ()
        | D0Cifndef _ => ()
        | D0Ctypedef (id, def) => typedef_insert (id.i0dex_sym, def)
        | D0Cassume (id) => {
            val () = emit_ENDL (out)
            val () = emit_text (out, "#ATSassume(")
            val () = (
                emit_i0de (out, id);
                emit_text (out, ")\n")
            )
        }
        | D0Cdyncst_mac _ => ()
        | D0Cdyncst_extfun _ => ()
        | D0Cdyncst_valdec _ => ()
        | D0Cdyncst_valimp _ => ()
        | D0Cstatmp (tmp, opt) => {
            val () = emit_ENDL(out)
            val () = the_statmpdeclst_insert(d0c0)
            val () = (
                case+ opt of
                | Some _ => ()
                | None () => emit_text(out, "#")
            )
            val () = (
                emit_tmpvar(out, tmp);
                emit_text(out, " := nil\n")
            )
        }

        | D0Cextcode (toks) => {
            val () = emit_ENDL(out)
            val () = emit_text(out, ATSEXTCODE_BEG)
            val () = emit_extcode(out, toks)
            val () = emit_text(out, ATSEXTCODE_END)
            val () = emit_newline(out)
        }

        | D0Cfundecl (fk, f0d) => emit_f0decl(out, f0d)
        | D0Cclosurerize (fl, env, arg, res) => emit_closurerize(out, fl, env, arg, res)
        | D0Cdynloadflag_init (flag) => ()
        | D0Cdynloadflag_minit (flag) => () where {
            val () = emit_ENDL(out)
            val () = (
                emit_tmpvar(out, flag);
                emit_text(out, " = 0\n")
            )
        }
        | D0Cdynexn_dec(idexn) => (
            emit_text(out, "## dynexn_dec(");
            emit_i0de(out, idexn);
            emit_text(out, ")\n")
        )
        | D0Cdynexn_extdec(idexn) => (
            emit_text(out, "## dynexn_extdec(");
            emit_i0de(out, idexn);
            emit_text(out, ")\n")
        )
        | D0Cdynexn_initize(idexn, fullname) => (
            emit_text(out, "## dynexn_initize(");
            emit_i0de(out, idexn);
            emit_text(out, ")\n")
        )
    end

implement emit_tmpdec
(out, td) = emit2_tmpdec(out, 0, td)

implement emit2_tmpdec
(out, ind, td) =
    let
    in
        case+ td.tmpdec_node of
        | TMPDECnone(tmp) => {
            val () = emit_nspc(out, ind)
            val () = (emit_SHARP(out); emit_tmpvar(out, tmp))
        }
        | TMPDECsome(tmp, s0e) => {
            val () = emit_nspc(out, ind)
            val () = (emit_tmpvar(out, tmp); emit_text(out, " := nil"))
        }
    end

implement emit2_tmpdeclst
(out, ind, tds) = (
    case+ tds of
    | list_nil() => ()
    | list_cons(td, tds) => {
            val () = (
                emit2_tmpdec(out, ind, td);
                emit_ENDL(out)
            )
            val () = emit2_tmpdeclst(out, ind, tds)
        }
)

local
    fun auxlst
    (out: FILEref, inss: instrlst)
    : void =
        let
            val inss = instrlst_skip_linepragma(inss)
            val-list_cons(ins, inss) = inss
            val-ATSINSlab(lab) = ins.instr_node

            val () = emit_nspc(out, 2)
            val () = emit_text(out, "def")
            val () = emit_SPACE(out)
            val () = emit_label(out, lab)
            val () = emit_text(out, "():\n")

            val () = emit_fundef_nonlocal (out)

            val () = emit_nspc(out, 4)
            val () = emit_text(out, "tmplab_py = 0\n")
        in
            auxlst2( out, lab, inss )
        end

    and
        auxlst2
        (out: FILEref, lab: label, inss: instrlst)
        : void =
            let
            in
                case+ inss of
                | list_nil () => {
                    val () = emit_nspc(out, 4)
                    val () = emit_text(out, "return\n")
                }

                | list_cons (ins1, inss2) => (
                    case+ ins1.instr_node of
                    | ATSINSlab(lab) => auxlst(out, inss) where {
                        val () = emit_nspc(out, 4)
                        val () = emit_label(out, lab)
                        val () = emit_text(out, "()\n")
                        val () = emit_nspc(out, 4)
                        val () = emit_text(out, "return\n")
                    }
                    | _  => auxlst2(out, lab, inss2) where {
                        val () = (
                            emit2_instr(out, 4, ins1);
                            emit_ENDL(out)
                        )
                    }
                )
                end
in
    implement emit_branchseq
    (out, ins0) =
        let
            val-ATSbranchseq (inss) = ins0.instr_node
        in
            auxlst (out, inss)
        end
end

fun emit_branchseqlst
(out: FILEref, inss: instrlst)
: void = (
    case+ inss of
    | list_nil() => ()
    | list_cons(ins, inss) => {
        val () = emit_branchseq(out, ins)
        val () = emit_branchseqlst(out, inss)
    }
)

implement
emit_fundef_nonlocal
  (out) = () where {
    val f0as = the_f0arglst_get()
    val () = emit_f0arglst_nonlocal(out, f0as)

    val tmpdecs = the_tmpdeclst_get()
    val () = emit_tmpdeclst_nonlocal(out, tmpdecs)

    val () = emit_nspc(out, 4)
    val () = emit_text(out, "nonlocal funlab_py, tmplab_py\n")

    val inss_caseof = the_caseofseqlst_get()
    val () = emit_mbranchlst_nonlocal(out, inss_caseof)
}

fun emit_caseofseq
(out: FILEref, ins0: instr)
: void =
    let
        val- ATScaseofseq(inss) = ins0.instr_node
        val tls = caseofseq_get_tmplablst(ins0)
        val () = the_branchlablst_set(tls)
    in
        emit_branchseqlst(out, inss)
    end

fun emit_caseofseqlst
(out: FILEref, inss: instrlst)
: void = (
    case+ inss of
    | list_nil() => ()
    | list_cons(ins, inss) => {
        val () = emit_caseofseq(out, ins)
        val () = emit_caseofseqlst(out, inss)
    }
)

implement emit_f0arg
(out, f0a) = let
in
    case+ f0a.f0arg_node of
    | F0ARGnone _ => emit_text(out, "__NONE__")
    | F0ARGsome(arg, s0e) => emit_tmpvar(out, arg)
end

implement emit_f0marg
(out, f0ma) =
let
    fun loop
    (out: FILEref, f0as: f0arglst, i: int)
    : void = (
        case+ f0as of
        | list_nil() => ()
        | list_cons(f0a, f0as) => let
            val () =
            if i > 0 then emit_text(out, ", ")
        in
            emit_f0arg(out, f0a);
            loop(out, f0as, i+1)
        end
    )
in
    loop(out, f0ma.f0marg_node, 0)
end


implement emit_f0head
(out, fhd) =
    let
        val f0as = f0head_get_f0arglst(fhd)
        val () = the_f0arglst_set(f0as)
    in
        case+
        fhd.f0head_node of
        | F0HEAD (fid, f0ma, res) => {
            val () = emit_tmpvar(out, fid)
            val () = emit_LPAREN(out)
            val () = emit_f0marg(out, f0ma)
            val () = emit_RPAREN(out)
            val () = emit_text(out, ":")
        }
    end

implement emit_f0body
(out, fbody) =
    let
        val knd = f0body_classify (fbody)
        (*
        val () = println! ("emit_f0body: knd = ", knd)
        *)

        val tmpdecs = f0body_get_tmpdeclst(fbody)
        val inss_body = f0body_get_bdinstrlst(fbody)
        val inss_caseof = f0body_collect_caseof(fbody)

        val () = the_tmpdeclst_set(tmpdecs)
        val () = the_funbodylst_set(inss_body)
        val () = the_caseofseqlst_set(inss_caseof)

        val () = emit_tmpdeclst_initize(out, tmpdecs)

        val () = emit_nspc(out, 2)
        val () = emit_text(out, "funlab_py = None\n")
        val () = emit_nspc(out, 2)
        val () = emit_text(out, "tmplab_py = None\n")

        val () = emit_mbranchlst_initize(out, inss_caseof)
        val () = emit_caseofseqlst (out, inss_caseof)
        val () = emit_branchmaplst (out, inss_caseof)
    in
        case+ knd of
        | 0 => emit_f0body_0(out, fbody)
        | 1 => emit_f0body_tlcal(out, fbody)
        | 2 => emit_f0body_tlcal2(out, fbody)
        | _ => let val () = assertloc(false) in  end
    end

implement emit_f0body_0
(out, fbody) =
  let
    fun auxlst
    (out: FILEref, inss: instrlst)
    : void = (
        case+ inss of
        | list_nil () => ()
        | list_cons (ins0, inss1) =>
            let

                val- list_cons(ins1, inss2) = inss1
                val () = emit2_ATSfunbodyseq(out, 2, ins0)
                val () = emit2_instr_ln(out, 2, ins1)
            in
                auxlst(out, inss2)
            end
    )
    in
        case+
        fbody.f0body_node of
        | F0BODY (tds, inss) => auxlst (out, inss)
    end

implement emit_f0body_tlcal
(out, fbody) =
let
    fun auxlst
    (out: FILEref, inss: instrlst)
    : void = (
        case+ inss of
        | list_nil() => ()
        | list_cons (ins0, inss1) =>
            let
                val- list_cons(ins1, inss2) = inss1
                val () = emit2_ATSfunbodyseq(out, 4, ins0)
                val () = emit_nspc(out, 4)
                val () = emit_text(out, "if (funlab_py == 0): break\n")
                val () = emit2_instr_ln(out, 2, ins1)
            in
                auxlst (out, inss2)
            end
    )

    val () = emit_nspc(out, 2)
    val () = emit_text(out, "while(1):\n")
    val () = emit_nspc(out, 4)
    val () = emit_text(out, "funlab_py = 0\n")
    val () = (
        case+ fbody.f0body_node of
        | F0BODY(tds, inss) => auxlst(out, inss)
    )
in

end

implement
emit_mfundef_initize
(out, inss) =
    let
        fun auxlst
        (out: FILEref, xs: instrlst, i: int)
        : void = (
            case+ xs of
            | list_nil() => ()
            | list_cons(x, xs) =>
                let
                    val fl = funbodyseq_get_funlab(x)
                    val () = if i >= 2 then emit_text(out, ", ")
                    val () = emit_int(out, i)
                    val () = emit_text(out, ": ")
                    val () = emit_label(out, fl)
                in
                    let
                        val-list_cons(_, xs) = xs
                    in
                        auxlst(out, xs, i+1)
                    end
                end
        )

        val () = emit_nspc(out, 2)
        val () = emit_text(out, "mfundef = { ")
        val () = auxlst (out, inss, 1)
        val () = emit_text (out, " }\n")
    in
    end

implement emit_the_funbodylst
(out) =
    let
        fun auxfun
        (out: FILEref, ins0: instr)
        : void =
            let
                val- ATSfunbodyseq (inss) = ins0.instr_node
                val- list_cons(ins1, inss) = inss
                val- ATSINSflab(fl) = ins1.instr_node

                val () = emit_nspc(out, 2)
                val () = emit_text(out, "def")
                val () = emit_SPACE(out)
                val () = emit_label(out, fl)
                val () = emit_text(out, "():\n")
                val () = emit_fundef_nonlocal(out)
                val () = emit_nspc(out, 4)
                val () = emit_text(out, "funlab_py = 0\n")
                val () = emit2_instrlst(out, 4, inss)
            in
            end

        fun auxlst
        (out: FILEref, inss: instrlst)
        : void = (
            case+ inss of
            | list_nil () => ()
            | list_cons _ => let
                val- list_cons(ins0, inss) = inss
                val- list_cons(ins1, inss) = inss
                val () = auxfun(out, ins0)
                val () = emit2_instr_newline(out, 4, ins1)
            in
                auxlst(out, inss)
            end
        )

        val inss_body = the_funbodylst_get()
        val () = auxlst(out, inss_body)
        val () = emit_mfundef_initize(out, inss_body)
    in
    end

implement emit_f0body_tlcal2
(out, fbody) = let
    val () = emit_nspc(out, 2)
    val () = emit_text(out, "tmpret_py = None\n")
    val () = emit_the_funbodylst(out)
    val () = emit_nspc(out, 2)
    val () = emit_text(out, "funlab_py = 1\n")
    val () = emit_nspc(out, 2)
    val () = emit_text(out, "while(1):\n")
    val () = emit_nspc(out, 4)
    val () = emit_text(out, "tmpret_py = mfundef.get(funlab_py)()\n")
    val () = emit_nspc(out, 4)
    val () = emit_text(out, "if (funlab_py == 0): break\n")
    val () = emit_nspc(out, 2)
    val () = emit_text(out, "return tmpret_py\n")
in
end

implement emit_f0decl
(out, fdec) =
    let
    in
        case+ fdec.f0decl_node of
        | F0DECLnone (fhd) => ()
        | F0DECLsome (fhd, fbody) => {
            val () = emit_ENDL(out)
            val () = emit_text(out, "fun")
            val () = emit_SPACE(out)
            val () = emit_f0head(out, fhd)
            val () = emit_ENDL(out)
            val () = emit_f0body(out, fbody)
            val () = emit_newline(out)
        }
    end

implement emit_toplevel
(out, d0cs) =
    let
        fun loop
        (out: FILEref, d0cs: d0eclist)
        : void = (
            case+ d0cs of
            | list_nil () => ()
            | list_cons (d0c, d0cs) =>
                let
                    val () = emit_d0ecl(out, d0c)
                in
                    loop(out, d0cs)
                end
        )
    in
        loop(out, d0cs)
    end
