#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define
    CATSPARSEMIT_targetloc
    "./../../vendor/CATS-parsemit"
#endif

#include "share/atspre_staload.hats"
staload UN = "prelude/SATS/unsafe.sats"

#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_syntax.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_typedef.sats"
