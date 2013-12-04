plot 
       {dtfile = env-2011_254_0645_70873_CHP3.5_FLT_005.31201.35207.final.sgy;
       dtfile = env-2011_254_0645_70873_CHP3.5_FLT_005.sgy;
       plfile = env-2011_254_0645_70873_CHP3.5_FLT_005.31201.35207.ps;
       srtfile = chirp.sort;
       device = 16; {14; { 16 is lscape xwin, 14 for portrait ps, 15 for lscape ps.
       interact = 1;
{{ PLOT SIZE AND ORIGIN }}
       size = 600, 400; 
       {size = 648, 419;
       reduc = 1.00;
       origin = 30 20;      
{{ PLOT DIRECTION AND POLARITY }}
       {rtl = t;
       negpol= f;
{{ TIME PARAMETERS }}
       cdp = t;
       delt = 0.000392; { get SI value from lsd, convert from microsec to sec.
       {tbi = 0.00;  { for flattening
       {tfi = 0.08;  { for flattening
        tbi = 5.5;  {Time start
        tfi = 6.3;  {Time end
       {timscal = 500; { for flattening              
       timscal = 3000;
       tmark = 0.1; 
       {tmark = -5000; { use this to remove overlay markers
{{ PLOT PARAMETERS }}
       {sort = cdp; { sort by common depth point
       {rpb = 104572; { for flattening
       {rpf = 118473; { for flattening
       shb = 31201;  {first shot
       {shf = 35207;  { DIEGO: use this to get a plot that matches the PNG file.
       shf = 51199; { DIEGO: use this to get the actual whole plot.
       sort = shot; { sort by shot
       ntrab = 1;
       ntraf = 1;
       noinc = 1;
       ntrinc = 1;
       advplt = f;
       {xscale = 1;
       {vred = 3;
{{ TRACE AND RANGE SPACING }}
       prangeix = 3;
{{ PLOT LENGTH }}
       {spa = 0.01;
       leng = 600;
{{ TRACE AMPLITUDE SCALING }} 
       clip = 1.0;
       mxdef = 1.0;
       pscale = 0.015;       
{{ TRACE ANNOTATIOIN }}
       form = I6;
       anninc = 100;
       chgt = 2.0;
       {annix = 3;
       {annb = 1;
{{ PLOT LABELS }}
       labhgt = 3.0;
       {label = 'r' 421111  0.050   0 '\ita\E'; { 100 before last shot
       {label = 'l' 411312  0.050   0 '\ita\W'; { 100 after first shot
       {label = 'c' 416212  0.040   0 '\ita\VE: ~40x';        
       {label = 'r' 421111  0.040   0 '\ita\Processed'; { 100 before last shot
       {label = 'c' 411012  0.120  90 '\ita\TWTT(s)'; { 500 before first shot
       {label = 'l' 411312  0.040   0 '\ita\Goleta Line 24'; { 100 after first shot
       {label = 'r' 35207 6.275 0 '\ita\Processed SEGY - Range 31201 to 35207';
{{ PLOT SHADING }}
       shad = 5;
       {tr_color = 255 0 0;
       level =
     0.007874
     0.015748
     0.023622
     0.031496
      0.03937
     0.047244
     0.055118
     0.062992
     0.070866
      0.07874
     0.086614
     0.094488
      0.10236
      0.11024
      0.11811
      0.12598
      0.13386
      0.14173
      0.14961
      0.15748
      0.16535
      0.17323
       0.1811
      0.18898
      0.19685
      0.20472
       0.2126
      0.22047
      0.22835
      0.23622
      0.24409
      0.25197
      0.25984
      0.26772
      0.27559
      0.28346
      0.29134
      0.29921
      0.30709
      0.31496
      0.32283
      0.33071
      0.33858
      0.34646
      0.35433
       0.3622
      0.37008
      0.37795
      0.38583
       0.3937
      0.40157
      0.40945
      0.41732
       0.4252
      0.43307
      0.44094
      0.44882
      0.45669
      0.46457
      0.47244
      0.48031
      0.48819
      0.49606
      0.50394
      0.51181
      0.51969
      0.52756
      0.53543
      0.54331
      0.55118
      0.55906
      0.56693
       0.5748
      0.58268
      0.59055
      0.59843
       0.6063
      0.61417
      0.62205
      0.62992
       0.6378
      0.64567
      0.65354
      0.66142
      0.66929
      0.67717
      0.68504
      0.69291
      0.70079
      0.70866
      0.71654
      0.72441
      0.73228
      0.74016
      0.74803
      0.75591
      0.76378
      0.77165
      0.77953
       0.7874
      0.79528
      0.80315
      0.81102
       0.8189
      0.82677
      0.83465
      0.84252
      0.85039
      0.85827
      0.86614
      0.87402
      0.88189
      0.88976
      0.89764
      0.90551
      0.91339
      0.92126
      0.92913
      0.93701
      0.94488
      0.95276
      0.96063
       0.9685
      0.97638
      0.98425
      0.99213;
       palette =     
  253.0078  253.0078  253.0078
  251.0156  251.0156  251.0156
  249.0234  249.0234  249.0234
  247.0312  247.0312  247.0312
  245.0391  245.0391  245.0391
  243.0469  243.0469  243.0469
  241.0547  241.0547  241.0547
  239.0625  239.0625  239.0625
  237.0703  237.0703  237.0703
  235.0781  235.0781  235.0781
  233.0859  233.0859  233.0859
  231.0938  231.0938  231.0938
  229.1016  229.1016  229.1016
  227.1094  227.1094  227.1094
  225.1172  225.1172  225.1172
  223.1250  223.1250  223.1250
  221.1328  221.1328  221.1328
  219.1406  219.1406  219.1406
  217.1484  217.1484  217.1484
  215.1562  215.1562  215.1562
  213.1641  213.1641  213.1641
  211.1719  211.1719  211.1719
  209.1797  209.1797  209.1797
  207.1875  207.1875  207.1875
  205.1953  205.1953  205.1953
  203.2031  203.2031  203.2031
  201.2109  201.2109  201.2109
  199.2188  199.2188  199.2188
  197.2266  197.2266  197.2266
  195.2344  195.2344  195.2344
  193.2422  193.2422  193.2422
  191.2500  191.2500  191.2500
  189.2578  189.2578  189.2578
  187.2656  187.2656  187.2656
  185.2734  185.2734  185.2734
  183.2812  183.2812  183.2812
  181.2891  181.2891  181.2891
  179.2969  179.2969  179.2969
  177.3047  177.3047  177.3047
  175.3125  175.3125  175.3125
  173.3203  173.3203  173.3203
  171.3281  171.3281  171.3281
  169.3359  169.3359  169.3359
  167.3438  167.3438  167.3438
  165.3516  165.3516  165.3516
  163.3594  163.3594  163.3594
  161.3672  161.3672  161.3672
  159.3750  159.3750  159.3750
  157.3828  157.3828  157.3828
  155.3906  155.3906  155.3906
  153.3984  153.3984  153.3984
  151.4062  151.4062  151.4062
  149.4141  149.4141  149.4141
  147.4219  147.4219  147.4219
  145.4297  145.4297  145.4297
  143.4375  143.4375  143.4375
  141.4453  141.4453  141.4453
  139.4531  139.4531  139.4531
  137.4609  137.4609  137.4609
  135.4688  135.4688  135.4688
  133.4766  133.4766  133.4766
  131.4844  131.4844  131.4844
  129.4922  129.4922  129.4922
  127.5000  127.5000  127.5000
  125.5078  125.5078  125.5078
  123.5156  123.5156  123.5156
  121.5234  121.5234  121.5234
  119.5312  119.5312  119.5312
  117.5391  117.5391  117.5391
  115.5469  115.5469  115.5469
  113.5547  113.5547  113.5547
  111.5625  111.5625  111.5625
  109.5703  109.5703  109.5703
  107.5781  107.5781  107.5781
  105.5859  105.5859  105.5859
  103.5938  103.5938  103.5938
  101.6016  101.6016  101.6016
   99.6094   99.6094   99.6094
   97.6172   97.6172   97.6172
   95.6250   95.6250   95.6250
   93.6328   93.6328   93.6328
   91.6406   91.6406   91.6406
   89.6484   89.6484   89.6484
   87.6562   87.6562   87.6562
   85.6641   85.6641   85.6641
   83.6719   83.6719   83.6719
   81.6797   81.6797   81.6797
   79.6875   79.6875   79.6875
   77.6953   77.6953   77.6953
   75.7031   75.7031   75.7031
   73.7109   73.7109   73.7109
   71.7188   71.7188   71.7188
   69.7266   69.7266   69.7266
   67.7344   67.7344   67.7344
   65.7422   65.7422   65.7422
   63.7500   63.7500   63.7500
   61.7578   61.7578   61.7578
   59.7656   59.7656   59.7656
   57.7734   57.7734   57.7734
   55.7812   55.7812   55.7812
   53.7891   53.7891   53.7891
   51.7969   51.7969   51.7969
   49.8047   49.8047   49.8047
   47.8125   47.8125   47.8125
   45.8203   45.8203   45.8203
   43.8281   43.8281   43.8281
   41.8359   41.8359   41.8359
   39.8438   39.8438   39.8438
   37.8516   37.8516   37.8516
   35.8594   35.8594   35.8594
   33.8672   33.8672   33.8672
   31.8750   31.8750   31.8750
   29.8828   29.8828   29.8828
   27.8906   27.8906   27.8906
   25.8984   25.8984   25.8984
   23.9062   23.9062   23.9062
   21.9141   21.9141   21.9141
   19.9219   19.9219   19.9219
   17.9297   17.9297   17.9297
   15.9375   15.9375   15.9375
   13.9453   13.9453   13.9453
   11.9531   11.9531   11.9531
    9.9609    9.9609    9.9609
    7.9688    7.9688    7.9688
    5.9766    5.9766    5.9766
    3.9844    3.9844    3.9844
    1.9922    1.9922    1.9922
         0         0         0;              
       
       ifilc = 0;
end$

