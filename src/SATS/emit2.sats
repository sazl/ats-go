#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define CATSPARSEMIT_targetloc "./../../vendor/CATS-parsemit"
#endif

#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_syntax.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_typedef.sats"

fun emit_the_statmpdeclst
(out: FILEref, ind: int): void

fun the_statmpdeclst_get
(): d0eclist

fun the_statmpdeclst_insert
(d0ecl): void

fun emit_f0arglst_nonlocal
(out : FILEref, f0as : f0arglst): void

fun emit_tmpdeclst_initize
(out : FILEref, tds : tmpdeclst): void

fun emit_tmpdeclst_nonlocal
(out: FILEref, tds: tmpdeclst) : void

fun emit_mbranchlst_initize
(out: FILEref, inss: instrlst): void

fun emit_mbranchlst_nonlocal
(out: FILEref, inss: instrlst) : void

fun funlab_get_index
(fl: label): int

fun tmplab_get_index
(lab: label): int

fun the_f0arglst_get
(): f0arglst

fun the_f0arglst_set
(f0as: f0arglst): void

fun the_tmpdeclst_get
(): tmpdeclst

fun the_tmpdeclst_set
(tds: tmpdeclst): void

fun the_funbodylst_get
(): instrlst

fun the_funbodylst_set
(inss: instrlst): void

fun the_branchlablst_get
(): labelist

fun the_branchlablst_set
(tls: labelist): void

fun the_caseofseqlst_get
(): instrlst

fun the_caseofseqlst_set
(inss: instrlst): void

fun branchmap_get_index
(ins: instr): int

fun f0body_collect_caseof
(fbody: f0body): instrlst

fun instrlst_collect_caseof
(inss: instrlst): instrlst

fun emit2_instr
(out: FILEref, ind: int, ins: instr) : void

fun emit2_instr_ln
(out: FILEref, ind: int, ins: instr) : void

fun emit2_instr_newline
(out: FILEref, ind: int, ins: instr) : void

fun emit2_instrlst
(out: FILEref, ind: int, inss: instrlst) : void

fun emit2_ATSfunbodyseq
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_con1
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_boxrec
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_delay
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_lazyeval
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_ldelay
(out: FILEref, ind: int, ins: instr) : void

fun emit2_ATSINSmove_llazyeval
(out: FILEref, ind: int, ins: instr) : void

fun emit2_tmpdec
(out: FILEref, ind: int, td: tmpdec) : void

fun emit2_tmpdeclst
(out: FILEref, ind: int, tds: tmpdeclst) : void

fun emit_branchseq
(out: FILEref, ins0: instr): void

fun emit_branchseqlst
(out: FILEref, inss: instrlst): void

fun emit_fundef_nonlocal
(out: FILEref): void

fun emit_caseofseq
(out: FILEref, ins0: instr): void

fun emit_caseofseqlst
(out: FILEref, inss: instrlst): void

fun emit_f0arg : emit_type (f0arg)
and
    emit_f0marg : emit_type (f0marg)
and
    emit_f0head : emit_type (f0head)

fun emit_f0body : emit_type (f0body)
and
    emit_f0body_0 : emit_type (f0body)
and
    emit_f0body_tlcal : emit_type (f0body)
and
    emit_f0body_tlcal2 : emit_type (f0body)

fun emit_mfundef_initize
(out: FILEref, inss: instrlst): void

fun emit_the_funbodylst
(out: FILEref): void
