# Syntax

## Location

### File Name Type

```
abstype filename_type = ptr
typedef fil_t = filename_type
```

Implementation: `catsparse_fname.dats`

```ATS
datatype filename =
    FNAME of (string)

assume filename_type = filename
```

### Location Type

```ATS
abstype location_type = ptr
typedef loc_t = location_type
```

Implementation: `catsparse_posloc.dats`

```ATS
assume location_type = '{
    fil= fil_t,
    beg_ntot= int, // beginning char position
    beg_nrow= int,
    beg_ncol= int,
    end_ntot= int, // finishing char position
    end_nrow= int,
    end_ncol= int
}
```

### Symbol Type

```ATS
abstype symbol_type = ptr
typedef symbol = symbol_type
```

Implementation: `catsparse_symbol.dats`

```ATS
datatype symbol = SYMBOL of (
    string, // name
    int     // stamp
)

assume symbol_type = symbol
```

## Node

```ATS
typedef i0de = '{
    i0dex_loc= loc_t,
    i0dex_sym= symbol
}
```

```ATS
typedef label = i0de
typedef labelist = List0 (label)
vtypedef labelist_vt = List0_vt (label)
```

## Symbol Expression

```ATS
datatype
s0exp_node =
    | S0Eide of symbol
    | S0Elist of (s0explst) // temp
    | S0Eappid of (i0de, s0explst)

where
s0exp = '{
    s0exp_loc= loc_t,
    s0exp_node= s0exp_node
}

and s0explst = List0 (s0exp)
and s0expopt = Option (s0exp)
```

## Type Field

```ATS
datatype tyfld_node =
    TYFLD of (i0de, s0exp)

typedef tyfld = '{
  tyfld_loc= loc_t,
  tyfld_node= tyfld_node
}
```

```ATS
typedef tyfldlst = List0 (tyfld)

typedef tyrec = '{
  tyrec_loc= loc_t,
  tyrec_node= tyfldlst
}
```

## Dynamic Expression

```ATS
datatype d0exp_node =
  | D0Eide of (i0de)
  | D0Elist of (d0explst) // temp
  | D0Eappid of (i0de, d0explst)
  | D0Eappexp of (d0exp, d0explst)
  | ATSPMVint of i0nt
  | ATSPMVintrep of i0nt
  | ATSPMVbool of bool
  | ATSPMVfloat of f0loat
  | ATSPMVstring of s0tring
  | ATSPMVi0nt of i0nt
  | ATSPMVf0loat of f0loat
  | ATSPMVempty of (int) // void-value
  | ATSPMVextval of (tokenlst) // external values
  | ATSPMVrefarg0 of (d0exp)
  | ATSPMVrefarg1 of (d0exp)
  | ATSPMVfunlab of (label)
  | ATSPMVcfunlab of (int(*knd*), label, d0explst)
  | ATSPMVcastfn of (i0de(*fun*), s0exp, d0exp(*arg*))
  | ATSCSTSPmyloc of s0tring
  | ATSCKiseqz of (d0exp)
  | ATSCKisneqz of (d0exp)
  | ATSCKptriscons of (d0exp)
  | ATSCKptrisnull of (d0exp)
  | ATSCKpat_int of (d0exp, d0exp)
  | ATSCKpat_bool of (d0exp, d0exp)
  | ATSCKpat_string of (d0exp, d0exp)
  | ATSCKpat_con0 of (d0exp, int(*tag*))
  | ATSCKpat_con1 of (d0exp, int(*tag*))
  | ATSSELcon of (d0exp, s0exp(*tysum*), i0de(*lab*))
  | ATSSELrecsin of (d0exp, s0exp(*tyrec*), i0de(*lab*))
  | ATSSELboxrec of (d0exp, s0exp(*tyrec*), i0de(*lab*))
  | ATSSELfltrec of (d0exp, s0exp(*tyrec*), i0de(*lab*))
  | ATSextfcall of (
      i0de,    // fun
      d0explst // arg
    )
  | ATSextmcall of (
      d0exp,   // obj
      d0exp,   // method
      d0explst // arg
    )
  | ATSfunclo_fun of (
      d0exp,
      s0exp, // arg
      s0exp  // res
    )
  | ATSfunclo_clo of (
      d0exp,
      s0exp, // arg
      s0exp  // res
    )

where
d0exp = '{
  d0exp_loc= loc_t,
  d0exp_node= d0exp_node
}

and d0explst = List0 (d0exp)
and d0expopt = Option (d0exp)
```

## Functions

```ATS
datatype f0arg_node =
  | F0ARGnone of (s0exp)
  | F0ARGsome of (i0de, s0exp)

typedef f0arg = '{
  f0arg_loc= loc_t,
  f0arg_node= f0arg_node
}

typedef f0arglst = List0 (f0arg)

typedef f0marg = '{
  f0marg_loc= loc_t,
  f0marg_node= f0arglst
}

datatype fkind_node =
  | FKextern of ()
  | FKstatic of ()

typedef fkind = '{
  fkind_loc= loc_t,
  fkind_node= fkind_node
}

datatype f0head_node =
    F0HEAD of (i0de, f0marg, s0exp)

typedef f0head = '{
  f0head_loc= loc_t,
  f0head_node= f0head_node
}

typedef f0headopt = Option (f0head)
```

```
datatype f0body_node =
    F0BODY of (tmpdeclst, instrlst)

typedef f0body = '{
  f0body_loc= loc_t,
  f0body_node= f0body_node
}

datatype f0decl_node =
  | F0DECLnone of (f0head)
  | F0DECLsome of (f0head, f0body)

typedef f0decl = '{
  f0decl_loc= loc_t,
  f0decl_node= f0decl_node
}
```

### Temp Declarations

```ATS
datatype tmpdec_node =
    | TMPDECnone of (i0de)
    | TMPDECsome of (i0de, s0exp)

typedef tmpdec = '{
  tmpdec_loc= loc_t,
  tmpdec_node= tmpdec_node
}

typedef tmpdeclst = List0 (tmpdec)
```

## Main

```
datatype instr_node =
  | ATSif of (
        d0exp,       // HX: cond
        instrlst,    // HX: then
        instrlstopt  // HX: else
    )
  | ATSthen of instrlst // temp
  | ATSelse of instrlst // temp
  | ATSifthen of (d0exp, instrlst)
  | ATSifnthen of (d0exp, instrlst)
  | ATSbranchseq of (instrlst)
  | ATScaseofseq of (instrlst(*branches*))
  | ATSfunbodyseq of instrlst
  | ATSreturn of (i0de)
  | ATSreturn_void of (i0de)
  | ATSlinepragma of (token(*line*), token(*file*))
  | ATSINSlab of (label)
  | ATSINSgoto of (label)
  | ATSINSflab of (label)
  | ATSINSfgoto of (label)
  | ATSINSfreeclo of (d0exp)
  | ATSINSfreecon of (d0exp)
  | ATSINSmove of (i0de, d0exp)
  | ATSINSmove_void of (i0de, d0exp)
  | ATSINSmove_nil of (i0de)
  | ATSINSmove_con0 of (i0de, token(*tag*))
  | ATSINSmove_con1 of (instrlst)
  | ATSINSmove_con1_new of (i0de, s0exp)
  | ATSINSstore_con1_tag of (i0de, token(*tag*))
  | ATSINSstore_con1_ofs of (i0de, s0exp, i0de, d0exp)
  | ATSINSmove_boxrec of (instrlst)
  | ATSINSmove_boxrec_new of (i0de, s0exp)
  | ATSINSstore_boxrec_ofs of (i0de, s0exp, i0de, d0exp)
  | ATSINSmove_fltrec of (instrlst)
  | ATSINSstore_fltrec_ofs of (i0de, s0exp, i0de, d0exp)
  | ATSINSmove_delay of (i0de, s0exp, d0exp)
  | ATSINSmove_lazyeval of (i0de, s0exp, d0exp)
  | ATSINSmove_ldelay of (i0de, s0exp, d0exp)
  | ATSINSmove_llazyeval of (i0de, s0exp, d0exp)
  | ATStailcalseq of instrlst
  | ATSINSmove_tlcal of (i0de, d0exp)
  | ATSINSargmove_tlcal of (i0de, i0de)
  | ATSINSextvar_assign of (d0exp, d0exp)
  | ATSINSdyncst_valbind of (i0de, d0exp)
  | ATSINScaseof_fail of (token)
  | ATSINSdeadcode_fail of (token)
  | ATSdynload of int
  | ATSdynloadset of (i0de)
  | ATSdynloadfcall of (i0de)
  | ATSdynloadflag_sta of (i0de)
  | ATSdynloadflag_ext of (i0de)
  | ATSdynloadflag_init of (i0de)
  | ATSdynloadflag_minit of (i0de)
  | ATSdynexn_dec of (i0de)
  | ATSdynexn_extdec of (i0de)
  | ATSdynexn_initize of (i0de, string(*fullname*))

where
instr = '{
    instr_loc= loc_t,
    instr_node= instr_node
}

and instrlst = List0 (instr)
and instropt = Option (instr)
and instrlstopt = Option (instrlst)

vtypedef instrlst_vt = List0_vt (instr)
```

## Declarations

```
datatype d0ecl_node =
  | D0Cinclude of s0tring
  | D0Cifdef of (i0de, d0eclist)
  | D0Cifndef of (i0de, d0eclist)
  | D0Ctypedef of (i0de, tyrec)
  | D0Cassume of i0de // HX: assume ...
  | D0Cdyncst_mac of i0de
  | D0Cdyncst_extfun of (i0de, s0explst, s0exp)
  | D0Cdyncst_valdec of (i0de, s0exp)
  | D0Cdyncst_valimp of (i0de, s0exp)
  | D0Cextcode of (tokenlst)
  | D0Cstatmp of (i0de, s0expopt)
  | D0Cfundecl of (fkind, f0decl)
  | D0Cclosurerize of (
      i0de,
      s0exp, // env
      s0exp, // arg
      s0exp  // res
    )
  | D0Cdynloadflag_init of (i0de)
  | D0Cdynloadflag_minit of (i0de)
  | D0Cdynexn_dec of (i0de(*exn*))
  | D0Cdynexn_extdec of (i0de(*exn*))
  | D0Cdynexn_initize of (i0de(*exn*), s0tring(*fullname*))

where

d0ecl = '{
  d0ecl_loc= loc_t,
  d0ecl_node= d0ecl_node
}

and
d0eclist = List0 (d0ecl)
```