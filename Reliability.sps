****************************LEAP RELIABILITY ANALYSIS*********************************
****************************INTERNAL CONSISTENCY************************************
***************************************************************************************

*OPEN NEW OUTPUT

GET
  FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/FINAL LEAP_1.sav'.
DATASET NAME DataSet4 WINDOW=FRONT.


****************DESRIPTIVES OF OF ALL INDICATORS**********************
*************************************************************************
*************************************************************************


DESCRIPTIVES VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN 
    I6_MEAN I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
   LEADER_POINT.6 LEADER_POINT.7
  /SAVE
  /STATISTICS=MEAN SUM STDDEV VARIANCE RANGE MIN MAX SEMEAN KURTOSIS SKEWNESS.




*********************INTERNAL CONSISTENCY RELIABILITY********************
****************************************************************************
***************************************************************************

RELIABILITY
  /VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN
  /SCALE('Learning Environment') ALL
  /MODEL=ALPHA
  /STATISTICS=CORR
  /SUMMARY=TOTAL MEANS VARIANCE.


RELIABILITY
  /VARIABLES=I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN I6_MEAN I7_MEAN I8_MEAN
  /SCALE('Instruction') ALL
  /MODEL=ALPHA
  /STATISTICS=CORR
  /SUMMARY=TOTAL MEANS VARIANCE.


RELIABILITY
  /VARIABLES=LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
   LEADER_POINT.6 
  /SCALE('Professionalism (Leader Ratings)') ALL
  /MODEL=ALPHA
  /STATISTICS=CORR
  /SUMMARY=TOTAL MEANS VARIANCE.


RELIABILITY
  /VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN I6_MEAN 
    I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
   LEADER_POINT.6 
  /SCALE('LEAP Observation Scores (Learning Environment, Instruction, & Professionalism)') ALL
  /MODEL=ALPHA
  /STATISTICS=CORR
  /SUMMARY=TOTAL MEANS VARIANCE.



OUTPUT SAVE NAME=Document2
 OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Reliability.spv'
 LOCK=NO.


*OPEN LEAP VALIDITY SYNTAX
*OPEN LEAP BIAS SYNTAX
