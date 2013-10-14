#! /bin/csh -f
#
# Modified by hand by ADS 2010-04-06
# Modified by hand by CDC 2010-11-19
#
# Shellscript to create Postscript plot of swath sonar data
# Created by macro mbm_plot
#
# This shellscript created by following command line:
# mbm_plot -F-1 -I datalistp.mb-1 -R-75/-71:30/-38/-32:50 -Jm3.5 -MTDf -MTIa -MTGlightbrown -N0.5/5/5 -B0.5g0.5::WeSn -X2.4c -Y4.4c -V
#
# Define shell variables used in this script:
set PS_FILE         = JC23_navtrack_1.ps
set CPT_FILE        = datalistp.mb-1.cpt
set MAP_PROJECTION  = m
set MAP_SCALE       = 4.8
set MAP_REGION      = -75/-71:30/-38/-32:50
set X_OFFSET        = 2.5  
set Y_OFFSET        = 1.5  
set INPUT_FILE      =  JC23_track_1_list
set INPUT_FORMAT    = -1
#
# Save existing GMT defaults
echo Saving GMT defaults...
gmtdefaults -L > gmtdefaults4$$
#
# Set new GMT defaults
echo Setting new GMT defaults...
gmtset PAPER_MEDIA legal
gmtset PLOT_DEGREE_FORMAT ddd:mm
#
# Run mbcontour
echo Running mbcontour...

mbcontour -f-1 -I$INPUT_FILE \
	-J$MAP_PROJECTION$MAP_SCALE \
	-R$MAP_REGION \
	-D0.5/1/6/0.08 \
	-p1 \
	-P -X$X_OFFSET -Y$Y_OFFSET -K -V >! $PS_FILE

# Make coastline data plot
echo Running pscoast...
pscoast \
	-J$MAP_PROJECTION$MAP_SCALE \
	-R$MAP_REGION \
	-Df \
	-Glightbrown \
	-Ia \
	-P -K -O -V >> $PS_FILE
#
# Make basemap
echo Running psbasemap...
psbasemap -J$MAP_PROJECTION$MAP_SCALE \
	-R$MAP_REGION \
	-B0.5g0.5::WeSn:."JC23_track_1": \
	-P -O -V >> $PS_FILE
#
# Delete surplus files
echo Deleting surplus files...
/bin/rm -f $CPT_FILE
#
# Reset GMT default fonts
echo Resetting GMT fonts...
/bin/mv gmtdefaults4$$ .gmtdefaults4
#
# All done!
echo All done!

