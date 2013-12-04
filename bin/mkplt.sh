#!/bin/bash -f
if [ $# != 1 ]; then
   echo "Usage: mkplt filename"
   exit
fi
FILE=$1
rm sunfil.ras
sioseis << eof
procs diskin prout wbt filter avenor gains mix plot end
diskin
   ntodo 4000    #####     BEWARE OF VERY BIG PLOTS    #####
   ipath $FILE  end
end
gains
    subwb no type 5 alpha 5 end
end
avenor
   sets 0 7 addwb yes end
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
display -rotate 270 sunfil.ras &
convert -rotate 270 sunfil.ras $FILE.png
