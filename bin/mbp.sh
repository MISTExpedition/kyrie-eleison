#!/bin/bash

# 
# Filenames and directories
#
OUT_DIR="${PWD}/data"
FILE_LIST="file_list"
DATA_LIST="datalist.raw"
UNPROCESSED_LIST="unprocessed_list.mb-1"
PROCESSED_LIST="processed_list.mb-1"
DIFF_CPT="diff_2_files.cpt"
DIFF_GRD="difference_2_files.grd"
DIFF_PS="difference_2_files.ps"

all_to_59() {
	mkdir -p ${OUT_DIR}
	for in_file in $( ls *.all ); do
		out_file=${OUT_DIR}/${in_file%.*}.mb59
		echo Converting ${in_file} to ${out_file} ...
		# P1 = no ping averaging, -S2 = no data used if ship speed < ~ 1 kts
		mbcopy -P1 -F58/59 -S2 -I${in_file} -O${out_file}
	done
}

#------------------------------------------------------------------------------
#  Generate the ancillary files "inf", "fbt", and "fnv"
#------------------------------------------------------------------------------

fastfiles() {
	cd ${OUT_DIR}
	for in_file in $( ls *.mb59 ); do
		echo Generating fast files ${in_file} ...
		mbdatalist -F59 -N -I${in_file}
	done
	cd ..
}

add_meta() {
	cd ${OUT_DIR}
	for in_file in $( ls *.mb59 ); do
   		echo Applying metadata ${in_file} ...
   		mbset -I ${in_file} \
		      -PMETAVESSEL:${VESSEL}\
		      -PMETAINSTITUTION:${INST}\
		      -PMETAPLATFORM:${PLATFORM} \
		      -PMETASONAR:${SONAR} \
		      -PMETASONARVERSION:${SONAR_VER}\
		      -PMETACRUISEID:${CRUISE_ID} \
		      -PMETACRUISENAME:${CRUISE_NAME}\
		      -PMETAPI:${PI} \
		      -PMETAPIINSTITUTION:${PI_INST} \
		      -PMETACLIENT:${CLIENT}
	done
	cd ..
}

get_svp() {
	cd ${OUT_DIR}
	for in_file in $( ls *.mb59 ); do
		echo Getting SVP ${in_file} ...
	  	mbsvplist -F59 -P -V -I${in_file}
	done
	cd ..
}

get_list() {
	cd ${OUT_DIR}
	rm ${DATA_LIST}
	for i in $( ls *.mb59 ); do
		echo "${i} 59" >> ${DATA_LIST}
	done
	cd ..
}

mb_clean() {
	cd ${OUT_DIR}
	if [ ! -f ${DATA_LIST} ]; then
		get_list
	fi
	mbclean -I${DATA_LIST} -F-1 -M1 -C3.5 -D0.01/0.20 -G0.80/1.20 -V
	cd ..
}

svp_set() {
	cd ${OUT_DIR}
	for i in $( ls *.mb59 ); do
		echo Processing ${i} ...
		mvprocess -F59 -V -I${i}
	done
	cd ..
}

unprocessed_list() {
	cd ${OUT_DIR}
	for i in $( ls *e.mb59); do
		echo "$i 59" >> ${UNPROCESSED_LIST}
	done
	cd ..
}

processed_list() {
	cd ${OUT_DIR}
	for i in $( ls *ep.mb59); do
		echo "$i 59" >> ${PROCESSED_LIST}
	done
	cd ..
}

grid_unprocessed_data() {
	cd ${OUT_DIR}
		if [ ! -f ${UNPROCESSED_LIST} ]; then
			unprocessed_list
		fi

		mbgrid -I${UNPROCESSED_LIST} -A2 \
			-C0/1 \
			-E100/100/"meters" \
			-F5 \
			-G3 \
			-N \
			-R${REGION} \
			-S1 \
			-V \
			-Ounprocessed
	cd ..
}

grid_processed_data() {
mbgrid -I${PROCESSED_LIST} -A2 \
	-C0/1 \
	-E100/100/"meters" \
	-F5 \
	-G3 \
	-N \
	-R${REGION} \
	-S1 \
	-V \
	-Oprocessed
}

plot_difference() {
	makecpt -Crainbow -T-5/5/0-.5 -Z -V > ${DIFF_CPT};
	grdimage ${DIFF_GRD} -J${PROJ} -R${REGION} -C${DIFF_CPT} -K -V  > ${DIFF_PS}
	psbasemap -R${REGION} -J${PROJ} -B0.5g0.5::WeSn -O -K -V >> ${DIFF_PS}
	psscale -D21c/8c/15c/0.4c -C${DIFF_CPT} -B1:DepthDifferrence\[m]:/:: -O -V >> ${DIFF_PS}
}

difference_grids() {
	grdmath unprocessed.grd processed.grd SUB = difference.grd
	grdinfo difference.grd -V
}

batch() {
	for cmd in $BATCH_COMMANDS; do
		echo Processing command:$cmd ...
		$cmd
	done
}
	
usage() {
	echo "mbp.sh - A shell script for processing multibeam data using MB-System."
	echo "         http://www.ldeo.columbia.edu/res/pi/MB-System/"
	echo 
	echo "usage: mbp.sh [-h] [COMMAND]..."
	echo
	echo "  -h     display this help message"
	echo
	echo "  [COMMAND] is one of:"
	echo "  all_to_59 : convert .all to .mb59, uses mbcopy"
	echo "  fastfiles : extracts fast bayhymetry and navigation, uses mbdatalist"
	echo "  add_meta  : applies metadata, uses mbset"
	echo "  get_svp   : extracts sound velocity profile, uses mbsvplist"
	echo "  get_list  : generates the list of data files (needed for mb_clean)"
	echo "  mb_clean  : processes automated quality check, uses mbclean"
	echo "  batch     : batch processes these commands : " ${BATCH_COMMANDS}
	echo
	echo "examples:"
	echo
	echo "  mbp.sh all_to_59 fastfiles add_metadata    (converts, extracts fastfiles and applied metadata)"
	echo "  mbp.sh batch                               (batch process all data)"
	exit 1
}

if [ -f cruise.info ]; then 
	source cruise.info
else
	echo "Cruise parameter file 'cruise.info' not found"
	exit 1
fi

if [ "$#" == "0" ] || [ "$1" == "-h" ]; then
	usage
fi


while (( "$#" )); do
	$1
	if [ $? -ne 0 ]; then
        	echo "error with $1"
		exit $?
	fi
	shift
done

