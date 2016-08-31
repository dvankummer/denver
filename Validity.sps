SET WIDTH 140.
*******************************FACTOR ANALYSIS************************************
*************************************************************************************
*************************************************************************************

GET
  FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/FINAL LEAP_1.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

/*CHECK DISTRIBUTIONS OF INDICATOR SCORES AND OUTLIERS*/

DESCRIPTIVES VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN 
      I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN  I6_MEAN I7_MEAN I8_MEAN 
      LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
    LEADER_POINT.6 LEADER_POINT.7
  /STATISTICS=MEAN STDDEV VARIANCE RANGE MIN MAX KURTOSIS SKEWNESS.


GRAPH
  /HISTOGRAM(NORMAL)=LE1_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=LE2_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=LE3_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=LE4_MEAN.



GRAPH
  /HISTOGRAM(NORMAL)= I2_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I2_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I3_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I4_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I5_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I6_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I7_MEAN.

GRAPH
  /HISTOGRAM(NORMAL)=I8_MEAN.




GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.1. 

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.2.

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.3.

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.4.

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.5.

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.6.

GRAPH
  /HISTOGRAM(NORMAL)=LEADER_POINT.7.



FACTOR
  /VARIABLES LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN I6_MEAN 
    I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
    LEADER_POINT.6
  /MISSING LISTWISE 
  /ANALYSIS LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN I6_MEAN 
    I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
    LEADER_POINT.6
  /PRINT UNIVARIATE INITIAL CORRELATION SIG DET KMO INV REPR AIC EXTRACTION ROTATION FSCORE
  /FORMAT SORT
  /PLOT EIGEN ROTATION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25) DELTA(0)
  /ROTATION OBLIMIN
  /SAVE REG(ALL)
  /METHOD=CORRELATION.


OUTPUT SAVE NAME=Document3
 OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Factor Analysis with PC Extraction.spv'
 LOCK=NO.
