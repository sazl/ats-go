#if defined (CATSPARSEMIT_targetloc)
#then
#else
    #define
    CATSPARSEMIT_targetloc
    "./../../vendor/CATS-parsemit"
#endif


#staload "{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_syntax.sats"
#staload "{$CATSPARSEMIT}/SATS/catsparse_typedef.sats"