#! /bin/bash
#   mkplt-all
#   Create a png plot file for each envelope file in a directory
#
#   usage:    mkplt-all input-directory output-directory
#   input-directory = the directory of Knudsen envelope file.  Must have
#                    "env-" for a prefix and ".sgy" for a suffix.
#          Assume the input data have been filtered.
#   output-directory = The directory of png files
#
# Knudsen KEB to SGY program has byte swapped water depth
# If so, use procs diskin header .....
#
#
if [ "$#" != "2" ]; then
        echo "*****    mkplt-all ERROR    *****"
        echo "Usage:   mkplt-all  input-pathname output-pathname"
        exit
fi

dir_in="$1"
dir_out="$2"
cd "$dir_in"
for x in env-*.sgy ; do
        extension=${x##*.}
        if [ $extension = sgy ]; then
                y=${x/sgy/png}
                echo "reading file: $dir_in/$x"
                echo "writing file: $dir_out/$y"
                cd "-"
rm sunfil.ras
sioseis << eof
noecho procs diskin prout wbt avenor mix gains plot end
diskin
   ntodo 10000   ! don't let the plot file get too big
   ipath $dir_in/$x end
end
header
    fno 0 lno 99999999 ftr 0 ltr 99 swap l16 end
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
    fno 0 lno 9999999 noinc 500 end
end
plot
   dptr 1 tlines .05 .1 chart 5 75 dir ltr nsecs 1
    colors gray opath siofil wiggle 0  ann gmtint anninc 5
    trpin 300 def .02 tlines .05 vscale 5 end
end
end
eof
sio2sun siofil sunfil.ras
convert -rotate 270 sunfil.ras  $dir_out/$y
                cd "$dir_in"
        fi
done
#rm sioseis_*tmp*
rm siofil sunfil.ras
