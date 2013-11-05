#!/bin/bash -f
#  "Usage: mkenv filename "
#  Create an envelope file from a correlate file
#  The output correlate filename is the same as the input filename with
#  the prefix "env-".   e.g.   env-filename.
#
#  This script must be run in the same directory as the input file.
#
#  Note that no filter or decimation is done here.
if [ $# != 1 ]; then
    echo "Usage: mkenv filename "
    exit 1
fi
FILE=$1
sioseis << eof
procs diskin header t2f f2t gains header2 prout diskoa end
diskin
  ipath $FILE end
end
header
    i120 = i58    ! save the original trace length
    fno 0 lno 9999999 ftr 0 ltr 999 end
end
header2
    i58 = i120    ! restore the original trace length
    fno 0 lno 9999999 ftr 0 ltr 999 end
end
prout
  info 1      ! print plotting info
   fno 0 lno 999999 noinc 50 end    ! print every 50th trace
end
gains
   type 7 end  ! complex modulus - make envelope from analytic
end
t2f
   end     ! number of sample is the next power of two larger than the input
end
f2t
   type analytic end   ! create the complex trace
end
diskoa
   opath env-$FILE  end
end
end
eof
