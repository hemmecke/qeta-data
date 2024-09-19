#!/bin/bash

# Get classical modular polynomials and translate them into
# FriCAS .input files.

# https://math.mit.edu/~drew/ClassicalModPolys.html

function gettxtfiles {
    for n in ${seq 100};
#    for n in 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47\
#             53 57 61 67 71 73 79 83 89 97;
    do
        wget https://math.mit.edu/~drew/modpolys/jfiles/phi_j_$n.txt
    done
}

function txt2input1 {
    sed "s/^[[]/$2 := $2 + phiTerms(/;s/] /,/;s/$/);/" $1
}

if [ $# -gt 0 ]; then
   case $1 in
       --help|-h|-\?)
           echo "Usage: ./txt2input [--web|-w] [--help|-h|-?]" >&2
           exit 0
         ;;
       --web|-w)
           gettxtfiles
           ;;
       *)
           echo "Unknown option '$1'" >&2
           exit 1
           ;;
   esac
fi


for f in $(ls phi_j_*.txt); do
    base=$(basename $f .txt)
    n=$(echo $base | sed 's/.*_//')
    echo "-- clasical modular polynomial phi$n" > phi$n.input
    echo "phiN := 0;" >> phi$n.input
    txt2input1 $f phiN >> phi$n.input
done
