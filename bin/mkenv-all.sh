#! /bin/bash
#   mkenv-all
#   Convert all the files in arg1 from correlates to envelope.
#
#   usage:    mkenv-all input-directory output-directory
#   input-directoy = the directory of Knudsen correlate files that end in .sgy
#   output-directoy = The directory of envelope files 
#   (the output file names will be the input file name with   env-  as a prefix).
#
#   The envelope files will be have permissions changed to read only.
#
#   Files "info" and "info-sorted" will be created in the output
#   directory.  File info will contain an ASCII line for each file containing
#   the file name, the beginning and ending dates of the data within the file,
#   and the minimum and maximum data times.
#
#   File "info-sorted" is a version of file "info" that is sorted by date.
#
if [ "$#" != "2" ]; then
        echo "*****    mkenv-all ERROR    *****"
        echo "Usage:   mkenv-all  input-pathname output-pathname"
        exit
fi
if [ "$1" == "$2" ]; then
        echo "*****     mkenv-all ERROR    *****"
        echo "Do not use the same directory for output as input (it causes a loop)."
        exit
fi
dir_in="$1"
dir_out="$2"
cd "$dir_in"
for x in *sgy ; do 
	extension=${x##*.}
	if [ $extension = sgy ]; then
		echo "reading file: $dir_in/$x"
		echo "writing file: $dir_out/env-$x"
		cd "-"
		echo "do sioseis"
sioseis << eof
noecho procs diskin header t2f f2t gains header2 filter prout diskoa end
diskin
        ipath $dir_in/$x end
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
   fno 0 lno 999999 noinc 500 end    ! print every 500th trace
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
filter
    ftype 0 pass 2 500 dbdrop 48 end
end
diskoa
    decimf 8
    opath $dir_out/env-$x end
end
end
eof
chmod 444 $dir_out/env-$x
lsh $dir_out/env-$x >> $dir_out/info
sort -k 4,5 $dir_out/info > $dir_out/info-sorted
		cd "$dir_in"
	fi
done
