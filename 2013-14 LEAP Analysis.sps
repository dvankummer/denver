**************************************************************************************
*********************************LEAP DESCRIPTIVE ANALYSIS*************************
*************************************************************************************



GET DATA /TYPE=XLSX
  /FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Observation 13-14 Data (w Observer '+
    'Certification).xlsx'
  /SHEET=name 'LEAP Observations 20132014'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.


FREQUENCIES VARIABLES=observer_code observer_first_name observer_last_name observer_type 
    teacher_code ProbStatus first_name last_name gender ethnicity region institution_code 
    institution_name form_context_id observation_date observation_type Status LE_1 LE_2 LE_3 LE_4 I_1 
    I_2 I_3 I_4 I_5 I_6 I_7 I_8 observation_id ScoredStatus 
  /ORDER=ANALYSIS.



********************************************************SOME RECODING, LABELING & REORDERING VARIABLES************************************************************/
****************************************************************************************************************************************************


***************************OBSERVER INFO**************************

RECODE observer_code (ELSE=Copy) INTO OBSERVERID.
VARIABLE LABELS  OBSERVERID 'Unique Observer_ID'.
EXECUTE.

         ALTER TYPE  OBSERVERID (F10.0).

STRING OBSFIRSTNAME (A30).
RECODE observer_first_name (ELSE=Copy) INTO OBSFIRSTNAME.
VARIABLE LABELS  OBSFIRSTNAME 'Observer First Name'.
EXECUTE.


STRING OBSLASTNAME (A30).
RECODE observer_last_name (ELSE=Copy) INTO OBSLASTNAME.
VARIABLE LABELS  OBSLASTNAME 'Observer Last Name'.
EXECUTE.


RECODE observer_type ('Leadership'=1) ('PeerObserver'=2) ('Team Lead'=3) (ELSE=SYSMIS) INTO OBSERVERTYPE.
VARIABLE LABELS  OBSERVERTYPE 'Type of Observer'.
EXECUTE.


RECODE observation_id (MISSING=SYSMIS) (ELSE=Copy) INTO OBSNO.
VARIABLE LABELS  OBSNO 'Observation ID (Unique)'.
EXECUTE.


RECODE observation_date (ELSE=Copy) INTO DATE.
VARIABLE LABELS  DATE 'Date of Observation'.
EXECUTE.

ALTER TYPE  DATE (DATE11).

RECODE observation_type ('Partial'=0) ('WalkThrough'=1) ('Full'=2) (ELSE=SYSMIS) INTO TYPEOBS.
VARIABLE LABELS  TYPEOBS 'Type of Observation'.
EXECUTE.


       VALUE LABELS OBSERVERTYPE
               1 'Leadership'
               2 'Peer Observer'
               3 'Team Lead'.


      VALUE LABELS TYPEOBS
            0 'Paritial'
            1 'Walkhhrough'
            2 'Full'.


****************************************TEACHER INFO**************************************************

RECODE teacher_code (ELSE=Copy) INTO TEACHERID.
VARIABLE LABELS  TEACHERID 'Teacher ID'.
EXECUTE.

         ALTER TYPE  TEACHERID (F10.0).
        

STRING TEACHFIRST(A20).
RECODE first_name (ELSE=Copy) INTO TEACHFIRST.
VARIABLE LABELS  TeachFirst 'Teacher First Name'.
EXECUTE.

STRING TEACHLAST (A30).
RECODE  last_name (ELSE=Copy) INTO TEACHLAST.
VARIABLE LABELS  TEACHLAST 'Teacher Last Name'.
EXECUTE.

RECODE ProbStatus('Probationary'=1) ('Non-Probationary'=2) ('Team Lead'=3) ('CTE no Status'=4) (ELSE=SYSMIS) INTO PROBATION.
VARIABLE LABELS  PROBATION 'Teacher Probationary Status'.
EXECUTE.
EXECUTE.


RECODE gender ('M'=1) ('F'=2) (ELSE=SYSMIS) INTO SEX.
VARIABLE LABELS  SEX 'Teacher Gender'.
EXECUTE.

RECODE ethnicity ('AN'=1) ('AS'=2) ('B'=3) ('HI'=4) ('WH'=5) (ELSE=SYSMIS) INTO RACE. 
VARIABLE LABELS  RACE 'Teacher Ethnicity'.
EXECUTE.


RECODE institution_code (ELSE=Copy) INTO SCHOOLID.
VARIABLE LABELS  SCHOOLID 'School ID'.
EXECUTE.


STRING SCHOOLNAME (A50).
RECODE institution_name (ELSE=Copy) INTO SCHOOLNAME.
VARIABLE LABELS  SCHOOLNAME 'School Name'.
EXECUTE.

RECODE region  ('Region 1' = 1) ('Region 2'=2)  ('Region 3'= 3) ('Region 4'=4)  ('Region 5'=5)
   ('Denver Summit Schools' =6) ('District'=7) ('Innovation'=8) ('Pathway Schools'=9)
   ('Private Schools/Institutions'=10) ('Secondary Middle'=11) ('Secondary Schools'=12)
   ('West Denver'=13) (ELSE=SYSMIS) INTO REGIONS.
VARIABLE LABELS  REGIONS 'Geographic Region'.
EXECUTE.

RECODE ScoredStatus (0=0) (1=1) (SYSMIS=SYSMIS) INTO SCORED_STATUS.
VARIABLE LABELS  SCORED_STATUS 'Whether or Not Observation is Scored (Unscored indicates all 12 indicators are null)'.
EXECUTE.


         VALUE LABELS PROBATION
                  1 'Probationary'
                  2 'Non-Probationary'
                  3 'No Status'
                  4 'CTE No Status'.

         VALUE LABELS SEX
               1 'Male'
               2 'Female'.

         VALUE LABELS RACE
               1  'Alaskan Native'
               2  'Asian'
               3  'Black'
               4  'Hispanic'
               5 ' White'.

          VALUE LABELS REGIONS
               1 'Region 1'
               2 'Region 2'
               3 'Region 3'
               4 'Region 4'
               5 'Region 5'
               6 'Denver Summit Schools'
               7 'District'
               8  'Innovation'
               9  'Pathway Schools'
               10 'Private Schools/Institutions'
               11 'Secondary Middle'
               12 'Secondary Schools'
               13 'West Denver'.


         VALUE LABELS  SCORED_STATUS
            0  'Not Scored'
            1  'Scored'.




****************************** INDICATORS******************************************


RECODE LE_1 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO LE1.
EXECUTE.
RECODE LE_2 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO LE2.
EXECUTE.
RECODE LE_3 (SYSMIS=SYSMIS) (ELSE=Copy) INTO LE3.
EXECUTE.
RECODE LE_4 (SYSMIS=SYSMIS) (ELSE=Copy) INTO LE4.
EXECUTE.

RECODE I_1 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I1.
EXECUTE.
RECODE I_2 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I2.
EXECUTE.
RECODE I_3 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I3.
EXECUTE.
RECODE I_4 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I4.
EXECUTE.

RECODE I_5 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I5.
EXECUTE.
RECODE I_6 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I6.
EXECUTE.
RECODE I_7 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I7.
EXECUTE.
RECODE I_8 (SYSMIS=SYSMIS) (ELSE=Copy) INTO I8.
EXECUTE.



/**************************ADD SOME MORE VARIABLES LABELS FOR EASY REFERENCE********************/


      VARIABLE LABELS  LE1 'Positve Classroom Culture and Cllimate: Demonstrates Knowledge interest and respect for diverse students communities and cultures'.
      VARIABLE LABELS LE2 'Positve Classroom Culture and Cllimate: Fosters a motivational and respectful classroom environment'. 


      VARIABLE LABELS LE3 'Effective Classoom Managment: Implements highs, clear expectations for students behavior and routines'.
      VARIABLE LABELS LE4 'Effective Classoom Managment: Classroom and physical environment support students and their learning'.

      VARIABLE LABELS I1 'Masterful Content Delivery:Clearly communicates the stands-based content language objective(s) for the lessonk connecting to larger rationale'.
      VARIABLE LABELS I2 'Masterful Content Delivery: Provides rigorous tasks that require critical thinking with appropriate digital and other supports to ensure student success'.
      VARIABLE LABELS I3 'Masterful Content Delivery: Intentionally uses instructional methods and pacing to teach to teach the content-language objective(s)'.
      VARIABLE LABELS I4  'Masterful Content Delivery: Ensures all students active and appropriate use of academic language'.


      VARIABLE LABELS  I5 'High-Impact Instruction Moves: Checks for understanding or content-language objective(s)'.
      VARIABLE LABELS I6 'High-Impact Instruction Moves: Provides differntiation that addresses students instructional needs and supports mastery of content language objectives'.
      VARIABLE LABELS I7 'High-Impact Instruction Moves: Provides students with academically-focused descriptive feedback aligned to content-language objective(s)'.
      VARIABLE LABELS  I8 'High-Impact Instruction Moves: Promotes students communication and collaboration utiliziing appropriate digitial and other resources'.

VALUE LABELS   LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8
1 'Not Meeting'
2 'Not Meeting'
3 'Approaching'
4 'Approaching'
5 'Effective'
6 'Effective'
7 'Distinguished'.



/********************************************************CHECKING FOR DUPLICATES ***************************************************************/
***************************************************************************************************************************************************



/*CHECKING FOR MISKEYED IDS-INDIVIDUAL OBSERVER SHOULD HAVE THE SAME ID FOR ALL OF THEIR RECORDS*/

         STRING  OBSERVER_NAME (A50).
         COMPUTE OBSERVER_NAME=CONCAT(OBSLASTNAME, OBSFIRSTNAME).
         VARIABLE LABELS  OBSERVER_NAME 'Full Name of Observer'.
         EXECUTE.

FREQUENCIES VARIABLES=OBSERVERID OBSERVER_NAME
  /ORDER=ANALYSIS.


****IDENTIFY UNIQUE NUMBER OF OBSERVERS**

         SORT CASES BY OBSERVERID(A) OBSERVER_NAME(A).
         MATCH FILES
           /FILE=*
           /BY OBSERVERID
           /FIRST=PrimaryFirst
           /LAST=PrimaryLast.
         DO IF (PrimaryFirst).
         COMPUTE  MatchSequence=1-PrimaryLast.
         ELSE.
         COMPUTE  MatchSequence=MatchSequence+1.
         END IF.
         LEAVE  MatchSequence.
         FORMATS  MatchSequence (f7).
         COMPUTE  InDupGrp=MatchSequence>0.
         SORT CASES InDupGrp(D).
         MATCH FILES
           /FILE=*
           /DROP=PrimaryFirst InDupGrp.
         VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence 
             'Sequential count of matching cases'.
         VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
         VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
         FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
         EXECUTE.





***********CHECK FOR  MISKEYED TEACHER IDs. TEACHERS SHOULD HAVE THE SAME ID FOR ALL THEIR RECORDS***********

      STRING  TEACHER_NAME (A50).
      COMPUTE TEACHER_NAME=CONCAT(TEACHLAST,TEACHFIRST).
      VARIABLE LABELS  TEACHER_NAME 'Full Name of Teacher'.
      EXECUTE.

*IDENTIFY NUMBER OF UNIQUE TEACHERS

         SORT CASES BY TEACHERID(A) TEACHER_NAME(A).
         MATCH FILES
           /FILE=*
           /BY TEACHERID
          /DROP = PrimaryLast MatchSequence  /FIRST=PrimaryFirst
           /LAST=PrimaryLast.
         DO IF (PrimaryFirst).
         COMPUTE  MatchSequence=1-PrimaryLast.
         ELSE.
         COMPUTE  MatchSequence=MatchSequence+1.
         END IF.
         LEAVE  MatchSequence.
         FORMATS  MatchSequence (f7).
         COMPUTE  InDupGrp=MatchSequence>0.
         SORT CASES InDupGrp(D).
         MATCH FILES
           /FILE=*
           /DROP=PrimaryFirst InDupGrp.
         VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence 
             'Sequential count of matching cases'.
         VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
         VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
         FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
         EXECUTE.



/*NOW REMOVE THE ORIGINAL VARIABLES THAT HAVE NOW BEEN RECODED*/

      DELETE VARIABLES
         observer_code observer_first_name observer_last_name observer_type teacher_code ProbStatus
         first_name last_name gender ethnicity region institution_code institution_name form_context_id
         observation_date observation_type Status LE_1 LE_2 LE_3 LE_4 I_1 I_2 I_3 I_4 I_5 I_6 I_7 I_8
         observation_id ScoredStatus OBSERVER_NAME TEACHER_NAME  PrimaryLast MatchSequence






/*******************************************************RESTRUCTURE:  FROM LONG TO WIDE*******************************************************
***************************************************************************************************************************************************
***************************************************************************************************************************************************

*******************************OBSERVE FILE -LONG TO WIDE****************************************



SORT CASES BY TEACHERID TEACHLAST TEACHFIRST .
CASESTOVARS
  /ID=TEACHERID TEACHLAST TEACHFIRST
  /GROUPBY=INDEX
  /COUNT=COUNT_OBS "Number of Observations".


            ***CONFIRM NUMBER OF CASES:OBSERVER FILE (I AND LE)****

            DESCRIPTIVES VARIABLES=TEACHERID  COUNT_OBS
              /STATISTICS=MIN MAX.



DESCRIPTIVES VARIABLES=COUNT_OBS
  /STATISTICS=MEAN SUM STDDEV VARIANCE MIN MAX.



SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Framework for Effective Teaching.sav'
  /COMPRESSED.




***********************************PROFESSIONALISM FILE- LONG TO WIDE******************************

GET DATA /TYPE=XLSX
  /FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/dbo_LEAP_PROFESSIONALISM_RATINGS.xlsx'
  /SHEET=name 'dbo_LEAP_PROFESSIONALISM_RATING'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet2 WINDOW=FRONT.

       ALTER TYPE DPSID (F10.0).
            RENAME VARIABLES  DPSID = TEACHERID.
           
           
            SORT CASES BY TEACHERID .
            CASESTOVARS
              /ID=TEACHERID
              /GROUPBY=INDEX.



 **DELETE NON-ESSENTIAL VARIABLES***

            DELETE VARIABLES  LEADER_COMMENT TEACHER_COMMENT CREATED_BY UPDATED_BY LAST_UPDATE_DATE   
            INDICATOR_CODE.1 INDICATOR_CODE.2 INDICATOR_CODE.3 INDICATOR_CODE.4 INDICATOR_CODE.5 INDICATOR_CODE.6 
            INDICATOR_CODE.7  LEADER_RATING_DESCRIPTION.1 LEADER_RATING.1 TEACHER_RATING.1 TEACHER_RATING_DESCRIPTION.1
             LEADER_RATING.2 LEADER_RATING_DESCRIPTION.2 TEACHER_RATING.2 TEACHER_RATING_DESCRIPTION.2 LEADER_RATING.3 
             LEADER_RATING_DESCRIPTION.3 TEACHER_RATING.3 TEACHER_RATING_DESCRIPTION.3 LEADER_RATING.4 LEADER_RATING_DESCRIPTION.4 
            TEACHER_RATING.4 TEACHER_RATING_DESCRIPTION.4 LEADER_RATING.5 LEADER_RATING_DESCRIPTION.5 TEACHER_RATING.5 
            TEACHER_RATING_DESCRIPTION.5 LEADER_RATING.6 LEADER_RATING_DESCRIPTION.6 TEACHER_RATING.6 TEACHER_RATING_DESCRIPTION.6 
            LEADER_RATING.7 LEADER_RATING_DESCRIPTION.7 TEACHER_RATING.7 TEACHER_RATING_DESCRIPTION.7.


            RECODE  LEADER_POINT.1 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P1_LEADER.
                 EXECUTE.

            RECODE  TEACHER_POINT.1 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P1_TEACHER. 
                  EXECUTE.

            RECODE  LEADER_POINT.2 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P2_LEADER.  
                  EXECUTE.

            RECODE TEACHER_POINT.2 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P2_TEACHER.
               EXECUTE.

            RECODE  LEADER_POINT.3 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P3_LEADER.
                  EXECUTE.
            RECODE  TEACHER_POINT.3 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P3_TEACHER.
                 EXECUTE.

            RECODE LEADER_POINT.4 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P4_LEADER. 
                  EXECUTE.

            RECODE TEACHER_POINT.4 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P4_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.5 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P5_LEADER.
                  EXECUTE.

            RECODE TEACHER_POINT.5 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P5_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.6 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P6_LEADER.
                  EXECUTE.

            RECODE  TEACHER_POINT.6 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P6_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.7 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P7_LEADER.
                  EXECUTE.

            RECODE TEACHER_POINT.7 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P7_TEACHER.
                  EXECUTE.

   VALUE LABELS  P1_LEADER P1_TEACHER P2_LEADER P2_TEACHER P3_LEADER P3_TEACHER P4_LEADER P4_TEACHER P5_LEADER P5_TEACHER P6_LEADER P6_TEACHER
            1 'Not Meeting'
            2 'Approacing'
            3 'Effective'
            4 'Distinguished'.   

         VARIABLE LABELS  P1_LEADER  'P1 Essential Knowledge of Students and Use of Data: Demonstrates and applies knowledge of students development, needs, interest, and culture to promote equity'.
         VARIABLE LABELS  P1_TEACHER 'P1 Essential Knowledge of Students and Use of Data: Demonstrates and applies knowledge of students development, needs, interest, and culture to promote equity'.
         
         VARIABLE LABELS  P2_LEADER 'P2 Essential Knowledge of Students and Use of Data: Uses students work and data to plan, adjust, and differentiate instruction'.
         VARIABLE LABELS P2_TEACHER 'P2 Essential Knowledge of Students and Use of Data: Uses students work and data to plan, adjust, and differentiate instruction'.


         VARIABLE LABELS P3_LEADER 'P3 Effective Collaboration and Engagement: Collaborates with school teams to positvely impact students' .
         VARIABLE LABELS P3_TEACHER 'P3 Effective Collaboration and Engagement: Collaborates with school teams to positvely impact students' .

         VARIABLE LABELS P4_LEADER 'P4 Effective Collaboration and Engagement:Advppcates for and engages students, families and the community in support of improved students achievment' .
         VARIABLE LABELS P4_TEACHER 'P4 Effective Collaboration and Engagement:Advppcates for and engages students, families and the community in support of improved students achievment' .

          VARIABLE LABELS  P5_LEADER  'P5 Thoughtful Reflection, Learning and Development: Demonstrates self-awareness, reflects on practice with self and others and acts on feedback'.
          VARIABLE LABELS  P5_TEACHER 'P5 Thoughtful Reflection, Learning and Development: Demonstrates self-awareness, reflects on practice with self and others and acts on feedback'.
          

         VARIABLE LABELS  P6_LEADER  'P6 Thoughtful Reflection, Learning and Development: Pursues opportunities for professional growth and contributes to a culture of inquiry'.
         VARIABLE LABELS  P6_TEACHER 'P6 Thoughtful Reflection, Learning and Development: Pursues opportunities for professional growth and contributes to a culture of inquiry'.

          VARIABLE LABELS  P7_LEADER  'P7*** Masterful Teacher Leadership: Builds capacity among colleagues and demonstrates service to students, school, district and the profession'.
           VARIABLE LABELS P7_TEACHER 'P7*** Masterful Teacher Leadership: Builds capacity among colleagues and demonstrates service to students, school, district and the profession'.



            ***CONFIRM NUMBER OF CASES: PROFESSIONALISM (WIDE)****


            RECODE  LEADER_POINT.1 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P1_LEADER.
                 EXECUTE.

            RECODE  TEACHER_POINT.1 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P1_TEACHER. 
                  EXECUTE.

            RECODE  LEADER_POINT.2 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P2_LEADER.  
                  EXECUTE.

            RECODE TEACHER_POINT.2 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P2_TEACHER.
               EXECUTE.

            RECODE  LEADER_POINT.3 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P3_LEADER.
                  EXECUTE.
            RECODE  TEACHER_POINT.3 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P3_TEACHER.
                 EXECUTE.

            RECODE LEADER_POINT.4 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P4_LEADER. 
                  EXECUTE.

            RECODE TEACHER_POINT.4 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P4_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.5 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P5_LEADER.
                  EXECUTE.

            RECODE TEACHER_POINT.5 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P5_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.6 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P6_LEADER.
                  EXECUTE.

            RECODE  TEACHER_POINT.6 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P6_TEACHER.
                  EXECUTE.

            RECODE  LEADER_POINT.7 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P7_LEADER.
                  EXECUTE.

            RECODE TEACHER_POINT.7 (SYSMIS=SYSMIS)  (ELSE=Copy) INTO P7_TEACHER.
                  EXECUTE.

   VALUE LABELS  P1_LEADER P1_TEACHER P2_LEADER P2_TEACHER P3_LEADER P3_TEACHER P4_LEADER P4_TEACHER P5_LEADER P5_TEACHER P6_LEADER P6_TEACHER
            1 'Not Meeting'
            2 'Approacing'
            3 'Effective'
            4 'Distinguished'.   

         VARIABLE LABELS  P1_LEADER  'P1 Essential Knowledge of Students and Use of Data: Demonstrates and applies knowledge of students development, needs, interest, and culture to promote equity'.
         VARIABLE LABELS  P1_TEACHER 'P1 Essential Knowledge of Students and Use of Data: Demonstrates and applies knowledge of students development, needs, interest, and culture to promote equity'.
         
         VARIABLE LABELS  P2_LEADER 'P2 Essential Knowledge of Students and Use of Data: Uses students work and data to plan, adjust, and differentiate instruction'.
         VARIABLE LABELS P2_TEACHER 'P2 Essential Knowledge of Students and Use of Data: Uses students work and data to plan, adjust, and differentiate instruction'.


         VARIABLE LABELS P3_LEADER 'P3 Effective Collaboration and Engagement: Collaborates with school teams to positvely impact students' .
         VARIABLE LABELS P3_TEACHER 'P3 Effective Collaboration and Engagement: Collaborates with school teams to positvely impact students' .

         VARIABLE LABELS P4_LEADER 'P4 Effective Collaboration and Engagement:Advppcates for and engages students, families and the community in support of improved students achievment' .
         VARIABLE LABELS P4_TEACHER 'P4 Effective Collaboration and Engagement:Advppcates for and engages students, families and the community in support of improved students achievment' .

          VARIABLE LABELS  P5_LEADER  'P5 Thoughtful Reflection, Learning and Development: Demonstrates self-awareness, reflects on practice with self and others and acts on feedback'.
          VARIABLE LABELS  P5_TEACHER 'P5 Thoughtful Reflection, Learning and Development: Demonstrates self-awareness, reflects on practice with self and others and acts on feedback'.
          

         VARIABLE LABELS  P6_LEADER  'P6 Thoughtful Reflection, Learning and Development: Pursues opportunities for professional growth and contributes to a culture of inquiry'.
         VARIABLE LABELS  P6_TEACHER 'P6 Thoughtful Reflection, Learning and Development: Pursues opportunities for professional growth and contributes to a culture of inquiry'.

          VARIABLE LABELS  P7_LEADER  'P7*** Masterful Teacher Leadership: Builds capacity among colleagues and demonstrates service to students, school, district and the profession'.
           VARIABLE LABELS P7_TEACHER 'P7*** Masterful Teacher Leadership: Builds capacity among colleagues and demonstrates service to students, school, district and the profession'.



            DESCRIPTIVES VARIABLES=TEACHERID
              /STATISTICS=MIN MAX.


SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Professional.sav'
  /COMPRESSED.



**************************FULL LEAP TEARCHER OVERALL RATING *********************************


          GET DATA /TYPE=XLSX
            /FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Teacher Level LEAP Data 13-14.xlsx'
            /SHEET=name 'Final FULL LEAP Data'
            /CELLRANGE=full
            /READNAMES=on
            /ASSUMEDSTRWIDTH=32767.
          EXECUTE.
          DATASET NAME DataSet3 WINDOW=FRONT.


         ALTER TYPE DPSID (F10.0).
         RENAME VARIABLES DPSID = TEACHERID.



         ****CONFIRM NUMBER OF CASES:ALL TEACHER LEVEL LEAP DATA **

            DESCRIPTIVES VARIABLES=TEACHERID
              /STATISTICS=MIN MAX.


SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Overall LEAP.sav'
  /COMPRESSED.






 *********************************************************************MERGE FILES **********************************************************************
/*FIRST MERGE INDICATOR LEVEL FILES*/



DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Professional.sav'
  /BY TEACHERID.
EXECUTE.



 /*CONFIRM NUMBER OF CASES: MERGED INDICATORS*/

            DESCRIPTIVES VARIABLES=TEACHERID
              /STATISTICS=MIN MAX.


SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/All Indicators.sav'
  /COMPRESSED.




/*NOW MERGE INDICATORS WITH OVERALL RATING FILE*/

MATCH FILES /FILE=*
  /FILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/Overall LEAP.sav'
  /BY TEACHERID.
EXECUTE.



/*FILTER OUT TEACHERS WITH INCOMPLETE OR INACTIVE CASES*/

FILTER OFF.
USE ALL.
SELECT IF (ActiveLEAP = 1 & OfficialLEAP = 1 & LeaderStatus ="Leader submitted").
EXECUTE.


/**CONFIRM NUMBER OF CASES: FULL LEAP*/

            DESCRIPTIVES VARIABLES=TEACHERID 
              /STATISTICS=MIN MAX.


SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/FULL LEAP.sav'
  /COMPRESSED.






*******************OVERALL RATING DESCRIPTIVES**************************************
****************************************************************************************
****************************************************************************************

*AVERAGE NUMBER OF OBSERVATIONS PER TEACHER*

DESCRIPTIVES VARIABLES=COUNT_OBS
  /STATISTICS=MEAN SUM STDDEV MIN MAX.



RECODE Overall_LEAP_Rating ('Not Meeting'=1) ('Approaching'=2) ('Effective'=3) ('Distinguished'=4) 
    INTO OVERALL.
VARIABLE LABELS  OVERALL 'Overall LEAP Rating (NOMINAL)'.
EXECUTE.

VALUE LABELS  OVERALL
1 'Not Meeting'
2 'Approaching'
3 'Effective'
4 'Distinguished'.


FREQUENCIES VARIABLES=OVERALL
  /STATISTICS=STDDEV VARIANCE RANGE MINIMUM MAXIMUM SEMEAN MEAN MEDIAN MODE
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.



******************INDICATOR-LEVEL DESRIPTIVES**************************
*************************************************************************
************************************************************************

*********GET AN AGGREGATED SCORE FOR EACH INDIVIDUAL INDICATOR*
*********LEARNING ENVIRONMENT*

COMPUTE LE1_MEAN=MEAN(LE1.1,LE1.2,LE1.3,LE1.4,LE1.5,LE1.6,LE1.7,LE1.8,LE1.9,LE1.10,LE1.11,LE1.12,LE1.13,LE1.14,LE1.15,LE1.16,LE1.17,LE1.18,LE1.19,LE1.20, LE1.21,LE1.22,LE1.23,LE1.24,LE1.25,LE1.26,LE1.27).
EXECUTE.

COMPUTE LE2_MEAN=MEAN( LE2.1, LE2.2, LE2.3, LE2.4, LE2.5, LE2.6, LE2.7, LE2.8, LE2.9, LE2.10, LE2.11, LE2.12, LE2.13, LE2.14, LE2.15, 
    LE2.16, LE2.17, LE2.18, LE2.19, LE2.20, LE2.21, LE2.22, LE2.23, LE2.24, LE2.25, LE2.26, LE2.27).

COMPUTE LE3_MEAN=MEAN( LE3.1, LE3.2, LE3.3, LE3.4, LE3.5, LE3.6, LE3.7, LE3.8, LE3.9, LE3.10, LE3.11, LE3.12, LE3.13, LE3.14, LE3.15, 
    LE3.16, LE3.17, LE3.18, LE3.19, LE3.20, LE3.21, LE3.22, LE3.23, LE3.24, LE3.25, LE3.26, LE3.27).


 COMPUTE LE4_MEAN=MEAN(LE4.1, LE4.2, LE4.3, LE4.4, LE4.5, LE4.6, LE4.7, LE4.8, LE4.9, LE4.10, LE4.11, LE4.12, LE4.13, LE4.14, LE4.15, 
    LE4.16, LE4.17, LE4.18, LE4.19, LE4.20, LE4.21, LE4.22, LE4.23, LE4.24, LE4.25, LE4.26, LE4.27).


*******INSTRUCTION

COMPUTE I1_MEAN=MEAN( I1.1, I1.2, I1.3, I1.4, I1.5, I1.6, I1.7, I1.8, I1.9, I1.10, I1.11, I1.12, I1.13, I1.14, I1.15, I1.16, I1.17, I1.18, 
    I1.19, I1.20, I1.21, I1.22, I1.23, I1.24, I1.25, I1.26, I1.27).

COMPUTE I2_MEAN=MEAN( I2.1, I2.2, I2.3, I2.4, I2.5, I2.6, I2.7, I2.8, I2.9, I2.10, I2.11, I2.12, I2.13, I2.14, I2.15, I2.16, I2.17, I2.18, 
    I2.19, I2.20, I2.21, I2.22, I2.23, I2.24, I2.25, I2.26, I2.27).

COMPUTE I3_MEAN=MEAN( I3.1, I3.2, I3.3, I3.4, I3.5, I3.6, I3.7, I3.8, I3.9, I3.10, I3.11, I3.12, I3.13, I3.14, I3.15, I3.16, I3.17, I3.18, 
    I3.19, I3.20, I3.21, I3.22, I3.23, I3.24, I3.25, I3.26, I3.27).

COMPUTE I4_MEAN=MEAN( I4.1, I4.2, I4.3, I4.4, I4.5, I4.6, I4.7, I4.8, I4.9, I4.10, I4.11, I4.12, I4.13, I4.14, I4.15, I4.16, I4.17, I4.18, 
    I4.19, I4.20, I4.21, I4.22, I4.23, I4.24, I4.25, I4.26, I4.27).

COMPUTE I5_MEAN=MEAN( I5.1, I5.2, I5.3, I5.4, I5.5, I5.6, I5.7, I5.8, I5.9, I5.10, I5.11, I5.12, I5.13, I5.14, I5.15, I5.16, I5.17, I5.18, 
    I5.19, I5.20, I5.21, I5.22, I5.23, I5.24, I5.25, I5.26, I5.27).

COMPUTE I6_MEAN=MEAN( I6.1, I6.2, I6.3, I6.4, I6.5, I6.6, I6.7, I6.8, I6.9, I6.10, I6.11, I6.12, I6.13, I6.14, I6.15, I6.16, I6.17, I6.18, 
    I6.19, I6.20, I6.21, I6.22, I6.23, I6.24, I6.25, I6.26, I6.27).

COMPUTE I7_MEAN=MEAN( I7.1, I7.2, I7.3, I7.4, I7.5, I7.6, I7.7, I7.8, I7.9, I7.10, I7.11, I7.12, I7.13, I7.14, I7.15, I7.16, I7.17, I7.18, 
    I7.19, I7.20, I7.21, I7.22, I7.23, I7.24, I7.25, I7.26, I7.27).

COMPUTE I8_MEAN=MEAN( I8.1, I8.2, I8.3, I8.4, I8.5, I8.6, I8.7, I8.8, I8.9, I8.10, I8.11, I8.12, I8.13, I8.14, I8.15, I8.16, I8.17, I8.18, 
    I8.19, I8.20, I8.21, I8.22, I8.23, I8.24, I8.25, I8.26, I8.27).
*


********PROFESSIONAL PRACTICE

COMPUTE PMEANBOTH=MEAN( P1_LEADER, P1_TEACHER, P2_LEADER, P2_TEACHER, P3_LEADER, P3_TEACHER, P4_LEADER, P4_TEACHER, P5_LEADER, P5_TEACHER, P6_LEADER, P6_TEACHER).
COMPUTE PMEANTEACH=MEAN( P1_TEACHER, P2_TEACHER, P3_TEACHER, P4_TEACHER, P5_TEACHER, P6_TEACHER).
COMPUTE PMEANLEAD=MEAN( P1_LEADER, P2_LEADER, P3_LEADER, P4_LEADER, P5_LEADER, P6_LEADER).


DESCRIPTIVES VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN 
    I6_MEAN I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
    LEADER_POINT.6
  /STATISTICS=MEAN STDDEV VARIANCE RANGE MIN MAX KURTOSIS SKEWNESS.

FREQUENCIES VARIABLES=LE1_MEAN LE2_MEAN LE3_MEAN LE4_MEAN I1_MEAN I2_MEAN I3_MEAN I4_MEAN I5_MEAN 
    I6_MEAN I7_MEAN I8_MEAN LEADER_POINT.1 LEADER_POINT.2 LEADER_POINT.3 LEADER_POINT.4 LEADER_POINT.5 
    LEADER_POINT.6
  /STATISTICS=STDDEV VARIANCE RANGE MINIMUM MAXIMUM SEMEAN MEAN MEDIAN MODE SKEWNESS SESKEW 
    KURTOSIS SEKURT
  /ORDER=ANALYSIS.



SAVE OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/FINAL LEAP.sav'
  /COMPRESSED.



OUTPUT SAVE NAME=Document1
 OUTFILE='/Volumes/Research/DPS/LEAP Data/LEAP 2013-14/LEAP Descriptives.spv'
 LOCK=NO.


*OPEN RELIABILITY SYNTAX FILE.
*OPEN VALIDITY SYNTAX FILE.
*OPEN OBSERVER BIAS SYNTAX FILE.



