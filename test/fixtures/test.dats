#define LIBATSCC2PY3_targetloc "$PATSHOME/contrib/libatscc2py3/ATS2-0.3.2"
#include "{$LIBATSCC2PY3}/staloadall.hats"

#define ATS_MAINATSFLAG 1
#define ATS_DYNLOADNAME "fact_dynload"

extern fun fact
    : int -> int = "mac#fact"

implement fact (n) =
    if n > 0
    then n * fact(n-1)
    else 1


fun fact2(n: int) =
    let
        val x = if n > 0
        then
            if n > 0
            then n * fact(n-1)
            else 5
        else 5
    in
        if n > 0
        then ()
    end

val N = 10
val () = println! ("fact(", N, ") = ", fact(N))

%{^
import sys
from libatscc2py3_all import *
sys.setrecursionlimit(1000000)
%}

%{$
fact_dynload()
%}
