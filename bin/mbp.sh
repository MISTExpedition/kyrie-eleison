#!/bin/bash

#
# Cruise  Metadata
#
VESSEL="REVELLE"
INST="edu.ucsd.sio"
PLATFORM="Ship"
SONAR="Simrad - EM122"
SONAR_VER="?"
CRUSE_ID="RR1310"
CRUISE_NAME="Some Seamount Cruise"
PI="Diego Melgar"
PI_INST="edu.ucsd.sio"
CLIENT="edu.ucsd.sio"
	

#
# GMT settings
#
REGION="-75/-71/-38/-32"
PROJ="m80i"

# 
# Filenames and directories
#
OUT_DIR="data"
FILE_LIST="file_list"
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

all_to_59
fastfiles
add_meta
get_svp

