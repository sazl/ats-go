
extern fun emit_the_statmpdeclst
(out: FILEref, ind: int)
: void


extern
fun
the_statmpdeclst_get(): d0eclist

extern
fun
the_statmpdeclst_insert(d0ecl): void


extern fun emit_f0arglst_nonlocal
(out : FILEref, f0as : f0arglst)
: void

extern
fun
emit_tmpdeclst_initize
(
out : FILEref
,
tds : tmpdeclst): void

extern
fun
emit_tmpdeclst_nonlocal
(
out: FILEref
,
tds: tmpdeclst) : void



extern
fun
emit_mbranchlst_initize
( out: FILEref
, inss: instrlst): void



extern
fun
emit_mbranchlst_nonlocal
( out: FILEref
, inss: instrlst) : void




extern
fun
funlab_get_index(fl: label): int
extern
fun
tmplab_get_index(lab: label): int



extern
fun
the_f0arglst_get(): f0arglst
extern
fun
the_f0arglst_set(f0as: f0arglst): void



extern
fun
the_tmpdeclst_get(): tmpdeclst
extern
fun
the_tmpdeclst_set(tds: tmpdeclst): void



extern
fun
the_funbodylst_get(): instrlst
extern
fun
the_funbodylst_set(inss: instrlst): void



extern
fun
the_branchlablst_get(): labelist
extern
fun
the_branchlablst_set(tls: labelist): void



extern
fun
the_caseofseqlst_get(): instrlst
extern
fun
the_caseofseqlst_set(inss: instrlst): void




extern
fun
branchmap_get_index
  (ins: instr): int



extern
fun
f0body_collect_caseof
  (fbody: f0body): instrlst

extern
fun
instrlst_collect_caseof
  (inss: instrlst): instrlst



extern
fun
emit2_instr
(out: FILEref, ind: int, ins: instr) : void
extern
fun
emit2_instr_ln
(out: FILEref, ind: int, ins: instr) : void
extern
fun
emit2_instr_newline
(out: FILEref, ind: int, ins: instr) : void
extern
fun
emit2_instrlst
(out: FILEref, ind: int, inss: instrlst) : void



extern
fun
emit2_ATSfunbodyseq
(out: FILEref, ind: int, ins: instr) : void

extern
fun
emit2_ATSINSmove_con1
(out: FILEref, ind: int, ins: instr) : void

extern
fun
emit2_ATSINSmove_boxrec
(out: FILEref, ind: int, ins: instr) : void

extern
fun
emit2_ATSINSmove_delay
(out: FILEref, ind: int, ins: instr) : void
extern
fun
emit2_ATSINSmove_lazyeval
(out: FILEref, ind: int, ins: instr) : void



extern
fun
emit2_ATSINSmove_ldelay
(out: FILEref, ind: int, ins: instr) : void
extern
fun
emit2_ATSINSmove_llazyeval
(out: FILEref, ind: int, ins: instr) : void





extern
fun
emit2_tmpdec
(out: FILEref, ind: int, td: tmpdec) : void
extern
fun
emit2_tmpdeclst
(out: FILEref, ind: int, tds: tmpdeclst) : void

extern
fun
emit_branchseq
  (out: FILEref, ins0: instr): void
extern
fun
emit_branchseqlst
  (out: FILEref, inss: instrlst): void

extern
fun
emit_fundef_nonlocal(out: FILEref): void



extern
fun
emit_caseofseq
  (out: FILEref, ins0: instr): void

extern
fun
emit_caseofseqlst
  (out: FILEref, inss: instrlst): void
extern
fun
emit_f0arg : emit_type (f0arg)
and
emit_f0marg : emit_type (f0marg)
and
emit_f0head : emit_type (f0head)

extern
fun
emit_f0body : emit_type (f0body)
and
emit_f0body_0 : emit_type (f0body)
and
emit_f0body_tlcal : emit_type (f0body)
and
emit_f0body_tlcal2 : emit_type (f0body)



extern
fun
emit_mfundef_initize
(
out: FILEref
,
inss: instrlst): void


extern
fun emit_the_funbodylst
(out: FILEref): void
