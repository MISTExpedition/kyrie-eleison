#!/bin/csh

#goto all259
#goto getlist
#goto fastfiles
#goto addmeta
#goto getsvp

#------------------------------------------------------------
#           Xbt and sound Speed profiles from MB files       
#------------------------------------------------------------
# 3 2011 03 15 22:19 -33.2322 -71.9689  TF_00003.EeF PE 557  Apppears to be a bad cast,use #4 instead. 
# 2 2011 03 16 13:51 -34.547  -73.2743  CTe00002.svp PE 978 
# 4 2011 03 17 14:57 -33.2322 -71.9689  TF_00004.EeF PE 849 
# 5 2011 03 18 19:11 -34.5023 -73.3572  TF_00005.EeF PE 849 
# 6 2011 03 19 18:21 -34.4267 -73.3273  TF_00006.EeF PE 849  
#------------------------------------------------------------
# TODO: add some gnuplot stuff
#goto plot_svp
#------------------------------------------------------------
#          Plot extracted svp profiles in increments of 30 
#          and determine which files use outliers
#------------------------------------------------------------
#0000_20110315_192247_melville.mb59_002.svp_tmp
#0011_20110316_005250_melville.mb59_002.svp_tmp --->
#                   0032_20110316_133318_melville.mb59_001.svp_tmp 
#goto svp_par_set
goto mbclean
#goto svpset
#goto unprocessed_list
#goto processed_list
#goto grid_unprocessed_data
#goto grid_processed_data
#goto color_table
#goto plot_unprocessed_grid
#goto plot_processed_grid
#goto plot_difference_grid
#goto histogram
#------------------------------------------------------------
#Extreme values of the data :       -430.167480469  4154.44433594
#pshistogram: Locations: L2, L1, LMS; Scales: L2, L1, LMS        0.173920677531 0.002197265625   -0.0551035027755        9.45286214624   0.907802929687  0.906247918059
#pshistogram: min/max values are :       -430.167480469  4154.44433594   117    342299




#goto grid_unprocessed_2_files
#goto grid_processed_2_files
#goto difference_grids_2_files
#goto color_table_2_files
#goto plot_unprocessed_grid_2_files
#goto plot_processed_grid_2_files
#goto plot_difference_grid_2_files



all259:

#------ Decompress gzipped files -------#

# gunzip /whelk/CERS/cruise_data/MV1004/multibeam/data/*.gz

#------------------------------------------------------------------------------
#  Grab the *.all files from the cruise data and compile an input list
#------------------------------------------------------------------------------

if(-e file_list) rm -rf file_list
ls *.all >> file_list
set tmp_file = `cat file_list`

#------------------------------------------------------------------------------
#  Convert from *.all to *.59 file
#------------------------------------------------------------------------------

foreach i ($tmp_file)

   set INFILE = $i:t
   set OUTFILE = data/{$INFILE:r}.mb59

   echo Processing ....  $OUTFILE

#------------ -P1 = no ping averaging, -S2 = no data used if ship speed < ~ 1 kts

   mbcopy -P1 -F58/59 -S2 -I$i -O$OUTFILE

end

stop 

getlist:

#------------------------------------------------------------------------------
#  Create the datalist file 
#------------------------------------------------------------------------------

if(-e file_list) rm -rf file_list
ls data/*.mb59 >> file_list
set tmp_file = `cat file_list`

if(-e datalist.raw) rm -rf datalist.raw

foreach i ($tmp_file)

  set INFILE = $i:t
  echo "$INFILE 59" >> datalist.raw
  echo Processing ....  $INFILE

end

stop

fastfiles:

#------------------------------------------------------------------------------
#  Generate the ancillary files "inf", "fbt", and "fnv"
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
ls *.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  echo Processing ....  $i
  mbdatalist -F59 -N -I$i


end

rm file_list

cd ..

stop

addmeta:

#------------------------------------------------------------------------------
#  Add meta data to the "par" file                      
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
ls *.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

   echo Processing ....  $i
   mbset -I $i \
      -PMETAVESSEL:"Melville" \
      -PMETAINSTITUTION:"edu.ucsd.sio" \
      -PMETAPLATFORM:"Ship" \
      -PMETASONAR:"Simrad - EM122" \
      -PMETASONARVERSION:"?" \
      -PMETACRUISEID:"MV1103" \
      -PMETACRUISENAME:"Chilean Earthquake Response Survey (CERS)" \
      -PMETAPI:"C. David Chadwell" \
      -PMETAPIINSTITUTION:"edu.ucsd.sio" \
      -PMETACLIENT:"edu.ucsd.sio" \

end

rm file_list

cd ..

stop
 
getsvp:

#------------------------------------------------------------------------------
#  Extract the sound velocity profiles from the sonar data files.
#------------------------------------------------------------------------------
cd data

if(-e file_list) rm -rf file_list
ls *.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  set OUTFILE = {$i}.svp

  echo Processing ....  $i

  mbsvplist -F59 -P -V -I$i

end

rm file_list

cd ..

stop

plot_svp:

#------------------------------------------------------------------------------
#  Plot of profiles used.
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
if(-e first_svp) rm -rf first_svp
ls *.svp >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  echo Processing ....  $i:r

  cat $i | awk '{if(NR>9) print $0}' - > {$i:r}.svp_tmp
  cat $i | awk '{if(NR==10) print $0}' - >> first_svp 
  
end

paste file_list first_svp > svp_steps

rm file_list
echo Done!

cd ..

stop

svp_par_set:

#------------------------------------------------------------------------------
# Assign user-selected sound velocity profiles to *.par files        
# mbset will replace the current .svp file with a user specified
# file. The angle mode will also be set to 0 which will allow ray-tracing
# during the process step.
#------------------------------------------------------------------------------

cd data

#mbset -F-1 -IQuad_1 -PSVPFILE:/whelk1/CERS/mb_processing/MV1004/SVP/SVP_1A.svp -PANGLEMODE:0 -V

# quad_3 contains list of mb59 file to apply modified SVP to
set tmp_file = `cat Quad_3`

foreach i ($tmp_file)

  echo Processing ....  $i

  set i_file = `echo $i | awk '{printf("%4d \n", substr($1,1,4))}' -`

  echo File counter .... $i_file

#  if (($i_file >= 0)&&($i_file <= 0))then
     set new_svp_file = "\/home\/CERS\/mb_processing\/MV1004\/SVP\/SVP_1A.svp"
     set old_svp_file = `cat $i | awk '/SVPFILE/{print $2}' -`

   echo $new_svp_file   $old_svp_file
     cat $i | sed s/"$old_svp_file"/"$new_svp_file"/g  - > $i.junk

     ls -l $i.junk
     ls -l $i

     mv $i.junk $i

     stop

#  endif

#  if (($i_file >= 11)&&($i_file <= 32))then
#     set new_svp_file = "\/home\/CERS\/mb_processing\/MV1004\/SVP\/SVP_1A.svp"
#     set old_svp_file = `cat $i | awk '/SVPFILE/{print $2}' -`
#     cat $i | sed s/"$old_svp_file"/"$new_svp_file"/g  - > $i.junk
#  endif

end

cd ..

stop 

mbclean:

#------------------------------------------------------------------------------
# mbclean will start with the raw (.mb59) file list. The flags are -M1 mode 1 
# i.e. one beam per outlier slope. -C3.5 ? Jared. -D0.01/0.20 min/max allowed 
# distance between beams e.g. 10 and 200 meters. -G0.80/1.20 range of acceptable# fractional depth values relative to the low and high values of local median 
# depth.
#------------------------------------------------------------------------------

cd data 

mbclean -Idatalist.raw -F-1 -M1 -C3.5 -D0.01/0.20 -G0.80/1.20 -V

cd ..

stop 

svpset:

#------------------------------------------------------------------------------
# Re-run the ray-trace using the svp that was extracted from .mb59
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
ls *.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  echo Processing ....  $i

  mbprocess -F59 -V -I$i 

end

rm file_list

cd ..

stop

unprocessed_list:

#------------------------------------------------------------------------------
# Create a unprocessed datalist for use by mbgrid
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
ls *e.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  echo "$i 59" >> unprocessed_list.mb-1 

end

rm file_list

cd ..

stop

processed_list:

#------------------------------------------------------------------------------
# Create a processed datalist for use by mbgrid
#------------------------------------------------------------------------------

cd data

if(-e file_list) rm -rf file_list
ls *ep.mb59 >> file_list
set tmp_file = `cat file_list`

foreach i ($tmp_file)

  echo "$i 59" >> processed_list.mb-1 

end

rm file_list

cd ..

stop

grid_unprocessed_data:

#------------------------------------------------------------------------------
# Make grid of unprocessed data
#------------------------------------------------------------------------------

cd data

mbgrid -Iunprocessed_list.mb-1 -A2 \
	-C0/1 \
	-E100/100/"meters" \
	-F5 \
	-G3 \
	-N \
	-R-75/-71/-38/-32 \
	-S1 \
	-V \
	-Ounprocessed
cd ..

stop

grid_processed_data:

#------------------------------------------------------------------------------
# Make grid of processed data
#------------------------------------------------------------------------------

cd data

mbgrid -Idatalistp-1 -A2 \
	-C0/1 \
	-E100/100/"meters" \
	-F5 \
	-G3 \
	-N \
	-R-75/-71/-38/-32 \
	-S1 \
	-V \
	-Oprocessed_1
cd ..

stop

grid_unprocessed_2_files:

#------------------------------------------------------------------------------
# Make grid of unprocessed data -- 2 files
#------------------------------------------------------------------------------

cd data

mbgrid -Iunprocessed_2_files_list.mb-1 -A2 \
	-C0/1 \
	-E40/40/"meters" \
	-F5 \
	-G3 \
	-N \
	-R-74.28/-74.06/-36.37/-36.20 \
	-S1 \
	-V \
	-Ounprocessed_2_files
cd ..

stop

grid_processed_2_files:

#------------------------------------------------------------------------------
# Make grid of processed data -- 2 files
#------------------------------------------------------------------------------

cd data

mbgrid -Iprocessed_2_files_list.mb-1 -A2 \
	-C0/1 \
	-E40/40/"meters" \
	-F5 \
	-G3 \
	-N \
	-R-74.28/-74.06/-36.37/-36.20 \
	-S1 \
	-V \
	-Oprocessed_2_files
cd ..

stop

difference_grids_2_files:

#------------------------------------------------------------------------------
# Difference the 2 file grids made from the unprocessed and processed data. 
# Get GRD information.  
#------------------------------------------------------------------------------

cd data

grdmath unprocessed_2_files.grd processed_2_files.grd SUB = difference_2_files.grd

grdinfo difference_2_files.grd -V

cd ..

stop

color_table_2_files:

#------------------------------------------------------------------------------
# Make a color table for depth 
#------------------------------------------------------------------------------

cd data

gmtset COLOR_NAN white

makecpt -Crainbow -T-5200/-3300/10 -Z -V > bathy_2_files.cpt

cd ..

stop

plot_unprocessed_grid_2_files:

#------------------------------------------------------------------------------
# Generate a plot of the unprocessed 2 file grid Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

#gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage unprocessed_2_files.grd -Jm80i -R-74.28/-74.06/-36.37/-36.20 -Cbathy_2_files.cpt -K -V > unprocessed_2_files.ps;

psbasemap -R-74.28/-74.06/-36.37/-36.20 -Jm5i -B0.5g0.5::WeSn -O -K -V >> unprocessed_2_files.ps;

cd ..

stop

plot_processed_grid_2_files:

#------------------------------------------------------------------------------
# Generate a plot of the processed 2 file grid Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

#gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage processed_2_files.grd -Jm80i -R-74.28/-74.06/-36.37/-36.20 -Cbathy_2_files.cpt -K -V > processed_2_files.ps;

psbasemap -R-74.28/-74.06/-36.37/-36.20 -Jm5i -B0.5g0.5::WeSn -O -K -V >> processed_2_files.ps;

cd ..

stop

plot_difference_grid_2_files:

#------------------------------------------------------------------------------
# Generate a plot of the differenced grid file. Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

makecpt -Crainbow -T-5/5/0-.5 -Z -V > diff_2_files.cpt;

#gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage difference_2_files.grd -Jm80i -R-74.28/-74.06/-36.37/-36.20 -Cdiff_2_files.cpt -K -V  > difference_2_files.ps;

psbasemap -R-74.28/-74.06/-36.37/-36.20 -Jm80i -B0.5g0.5::WeSn -O -K -V >> difference_2_files.ps;

psscale -D21c/8c/15c/0.4c -Cdiff.cpt -B1:DepthDifferrence\[m]:/:: -O -V >> difference_2_files.ps;

cd ..

stop

difference_grids:

#------------------------------------------------------------------------------
# Difference the grids made from the unprocessed and processed data. 
# Get GRD information.  
#------------------------------------------------------------------------------

cd data

grdmath unprocessed.grd processed.grd SUB = difference.grd

grdinfo difference.grd -V

cd ..

stop

color_table:

#------------------------------------------------------------------------------
# Make a color table for depth 
#------------------------------------------------------------------------------

cd data

gmtset COLOR_NAN white

makecpt -Crainbow -T-5500/-100/10 -Z -V > bathy.cpt

cd ..

stop

plot_unprocessed_grid:

#------------------------------------------------------------------------------
# Generate a plot of the unprocessed grid file Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage S0_diff_3.grd -Jm5i -R-75/-71/-38/-32 -Cbathy.cpt -K -V -P > S0_diff_3.ps;

psbasemap -R-75/-71/-38/-32 -Jm5i -B0.5g0.5::WeSn -O -K -V -P >> S0_diff_3.ps;

cd ..

stop

plot_processed_grid:
------------------------------------------------------------------------------
# Generate a plot of the processed grid file. Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage processed_1.grd -Jm5i -R-75/-71/-38/-32 -IProcessed_I.grd -Cbathy.cpt -K -V -P > mv1103.ps;

psbasemap -R-75/-71/-38/-32 -Jm5i -B0.5g0.5::WeSn -O -K -V -P >> mv1103.ps;

cd ..

stop

plot_difference_grid:

#------------------------------------------------------------------------------
# Generate a plot of the differenced grid file. Set PAPER_MEDIA size to the correct
# unit/degree defined by -J. Below I used 5 inches per degree.
#------------------------------------------------------------------------------

cd data

makecpt -Crainbow -T-30/30/3 -Z -V > diff.cpt;

gmtset PAPER_MEDIA Custom_21.5ix38i

grdimage MV1102_S0_diff.grd -Jm5i -R-75/-71/-38/-32 -Cdiff.cpt -K -V -P > MV1102_S0_diff.ps;

psbasemap -R-75/-71/-38/-32 -Jm5i -B0.5g0.5::WeSn -O -K -V -P >> MV1102_S0_diff.ps;

#psscale -D6.0i/2.0i/10i/0.25ih -Cdiff.cpt -B1:DepthDifferrence\[m]:/:: -O -V >> difference.ps;

cd ..

stop

histogram:

#------------------------------------------------------------------------------
# Plot histogram of difference grid
#------------------------------------------------------------------------------

cd data

grd2xyz difference.grd > difference.xyz

pshistogram difference.xyz -Jx1c/0.0005c -W1 -T2 -G200 -F -V -B5g5/5000g5000::WeSn -R-10/10/0/35000 > diff_histogram.ps

cd ..

stop




