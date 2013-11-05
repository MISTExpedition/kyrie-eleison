mkdplt - Make a png depth file from an envelope file.

#!/bin/bash -f
# "Usage: mkdplt filename [SDEPTH EDEPTH]"
#  Arguments SDEPTH and EDEPTH are in units of METERS.
#  e.g.   mkdplt env-2007_171_0706_LF.sgy
#    or   mkdplt env-2007_171_0706_LF.sgy 1000 4000
#
# make a depth plot.  The start depth of each trace changes as the
# deep water delay changes unless optional arguments SDEPTH and
# EDEPTH are given.
#
if [ $# != 1 ]; then
   if [ $# != 3 ]; then
      echo "Usage: mkdplt filename [SDEPTH EDEPTH]"
      exit
   fi
fi
FILE=$1
LINE=" "
if [ $# == 3 ]; then
   LINE="     sdepth $2  edepth $3"
fi
rm sunfil.ras
sioseis << eof
procs diskin prout wbt filter avenor mix gains t2d plot end
diskin
   ntodo 4000   #####   BEWARE OF VERY BIG PLOTS   #####
   ipath $FILE  end
end
t2d
$LINE
   osi 1 vtp 1500 0 end
end
agc
   winlen .001 end
end
header
    fno 0 lno 9999999 swap l16 end
end
gains
    subwb yes type 5 alpha 5 end
end
avenor
   sets 0 .1 addwb yes end
end
wbt
   vel 1500 end
end
mix
   weight 1  1 end
end
filter
    ftype 0 pass 2 500 dbdrop 48 end
end
prout
    fno 0 lno 9999999 noinc 100 end
end
plot
   dir ltr dptr 1 tlines .05 .1 ! chart 5 75
    colors gray opath siofil wiggle 0  ann gmtint anninc 5
    trpin 300 def .02 tlines .05 vscale 5 end
end
end
eof
sio2sun siofil sunfil.ras
convert -rotate 270 sunfil.ras $FILE.png
display -rotate 270 sunfil.ras &
