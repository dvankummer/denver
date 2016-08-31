*******************************************************
********************************************************
                   LEAP MOBILITY ANALYSIS
                      LONGITUDINAL FILES 
*******************************************************
********************************************************
*******************************************************

COHORT 1 - 1314
/*FIRST MERGE 1314 LEAP FILE WITH 1314 ROSTER AND TERMINATION DATA*/

GET 
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/1314 Recalculated LEAP/LEAP 1314 Master Data Set.sav'. 
DATASET NAME DataSet1 WINDOW=FRONT. 


ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).


GET 
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/1314 Recalculated LEAP/1314 DR TL Roster.sav'. 
DATASET NAME DataSet12 WINDOW=FRONT.


DATASET ACTIVATE DataSet1.
STAR JOIN
  /SELECT t0.TEACHLAST, t0.TEACHFIRST, t0.COUNT_OBS, t0.SGTeacherType, t0.SGTeacherTypeCode, 
    t0.Birth_Date, t0.Age, t0.Age_Bracket, t0.Gender, t0.Ethnicity, t0.TeacherLeader, t0.ProbStatus, 
    t0.ProbCoded, t0.NoviceYear, t0.ContentArea, t0.ClassroomNotes, t0.ISRegion, t0.Division, 
    t0.Classification, t0.@1213_SPFOverall, t0.@1213_SPFGrowthRollUp, t0.@1213_SPFType, t0.ActiveLEAP, 
    t0.OfficialLEAP, t0.LeaderStatus, t0.OptInOut, t0.I, t0.@LE, t0.P1toP6_Mean, t0.SchEdLevel, 
    t0.TeacherEdLevel, t0.N_TeachTotalSurveys, t0.N_Stu4Teach, t0.N_Stu4Sch, t0.OPP, t0.FLPP, t0.HEPP, 
    t0.SPP, t0.I_Pts, t0.LE_Pts, t0.Prof_Pts, t0.P7_Pts, t0.SPS_Pts, t0.PP_Pts_Earned, 
    t0.MathCategoryBand, t0.ReadingCategoryBand, t0.WritingCategoryBand, t0.MathMGP, t0.MathUpperCI, 
    t0.MathLowerCI, t0.MathOriginalNCount, t0.MathFinalNCount, t0.MathCoursesLinked, t0.ReadingMGP, 
    t0.ReadingUpperCI, t0.ReadingLowerCI, t0.ReadingOriginalNCount, t0.ReadingFinalNCount, 
    t0.ReadingCoursesLinked, t0.WritingMGP, t0.WritingUpperCI, t0.WritingLowerCI, 
    t0.WritingOriginal1YearNCount, t0.WritingFinalNCount, t0.WritingCoursesLinked, t0.School_Pts, 
    t0.District_Pts, t0.Math_Pts, t0.Reading_Pts, t0.Writing_Pts, t0.SG_Pts_Earned, t0.PP_Rating, 
    t0.LEAP_Ratin_Code, t0.LEAP_Rating, t0.SCHOOLID, t0.SCHOOLNAME, t0.REGION, t0.SCORED_STATUS, 
    t0.LE1, t0.LE2, t0.LE3, t0.LE4, t0.I1, t0.I2, t0.I3, t0.I4, t0.I5, t0.I6, t0.I7, t0.I8, 
    t0.CREATION_DATE, t0.LEADER_POINT.1, t0.LEADER_POINT.2, t0.LEADER_POINT.3, t0.LEADER_POINT.4, 
    t0.LEADER_POINT.5, t0.LEADER_POINT.6, t0.LEADER_POINT.7, t0.P1_LEADER, t0.P2_LEADER, t0.P3_LEADER, 
    t0.P4_LEADER, t0.P5_LEADER, t0.P6_LEADER, t0.P7_LEADER, t1.SchoolNumber, t1.School, t1.EdLevel, 
    t1.FirstName, t1.LastName, t1.TeacherLeaderRole, t1.Focusifapplicable, t1.Email, 
    t1.TeamLead, t1.ReleaseTime, t1.Resigned, t1.IS1314TEAMLEAD
  /FROM * AS t0
  /JOIN 'DataSet12' AS t1
    ON t0.DPSID=t1.DPSID
  /OUTFILE FILE=*.


SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/1314 Recalculated LEAP/LEAP 1314 Master Data Set.sav'
  /COMPRESSED.



*BEGIN

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/1314 Recalculated LEAP/LEAP 1314 Master Data Set.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).


GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/DPS Data Files/Employee Roster_120108_120115.xlsx'
  /SHEET=name '120113'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet2 WINDOW=FRONT.

ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).






DATASET CLOSE DataSet1.



**ADD TERMINATION DATA

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/DPS Data Files/Terminations '+
    'Report_2011.12_2014.15.xlsx'
  /SHEET=name 'Terms_120213_120114'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.

RENAME VARIABLES EMPLOYEE=DPSID.
ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).



*FIRST DEAL WITH 34 DUPLICATE EMPLOYEE IDS
*FILE WILL NOT MERGE WITH DUPLICATES IN KEYED TABLE BY VARIABLE


*ONLY 100018336 FROM THE TERMINATION FILE IS IN COHORT 1.
 
* Identify Duplicate Cases. 
SORT CASES BY DPSID(A). 
MATCH FILES 
  /FILE=* 
  /BY DPSID 
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
  /DROP=PrimaryFirst InDupGrp MatchSequence. 
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'. 
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'. 
VARIABLE LEVEL  PrimaryLast (ORDINAL). 
FREQUENCIES VARIABLES=PrimaryLast.


DATASET ACTIVATE DataSet3.
DATASET COPY  termtiondupes1314.
DATASET ACTIVATE  termtiondupes1314.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 0).
EXECUTE.
DATASET ACTIVATE  DataSet3.


DATASET ACTIVATE DataSet3.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 0).
EXECUTE.



DELETE VARIABLES  AUDITEFFECTIVEDATE TERMINATIONNOTICEDATE POSITION EMPLOYEENAME ASSIGNMENTORGUNITNAME HROUNAME 
    ASSIGNMENTBUCODE POSITIONPHYSICALLOCATION CLEVELNAME CURRENTRELATIONSHIPTYPE 
    CURRENTRELATIONSHIPSTATUS SUPERVISORNAME POSITIONTITLE JOBCODE JOBCATEGORYNAME JOBSUBCATEGORYCODE 
    JOBSUBCATEGORYNAME HIREORREHIREDATE UNIQUEEMPLOYEE UNIQUEPOSITION AUDITEFFECTIVEMONTH AUDITEFFECTIVEYEAR FISCALYEAR HROUOWNERLASTNAME ISSFESUBSTITUTE 
    ISHRMETRICSTEMP ISHRMETRICSRIB.


STAR JOIN
  /SELECT t0.TEACHLAST, t0.TEACHFIRST, t0.COUNT_OBS, t0.SGTeacherType, t0.SGTeacherTypeCode, 
    t0.Birth_Date, t0.Age, t0.Age_Bracket, t0.Gender, t0.Ethnicity, t0.TeacherLeader, t0.ProbStatus, 
    t0.ProbCoded, t0.NoviceYear, t0.ContentArea, t0.ClassroomNotes, t0.ISRegion, t0.Division, 
    t0.Classification, t0.@1213_SPFOverall, t0.@1213_SPFGrowthRollUp, t0.@1213_SPFType, t0.ActiveLEAP, 
    t0.OfficialLEAP, t0.LeaderStatus, t0.OptInOut, t0.I, t0.@LE, t0.P1toP6_Mean, t0.SchEdLevel, 
    t0.TeacherEdLevel, t0.N_TeachTotalSurveys, t0.N_Stu4Teach, t0.N_Stu4Sch, t0.OPP, t0.FLPP, t0.HEPP, 
    t0.SPP, t0.I_Pts, t0.LE_Pts, t0.Prof_Pts, t0.P7_Pts, t0.SPS_Pts, t0.PP_Pts_Earned, 
    t0.MathCategoryBand, t0.ReadingCategoryBand, t0.WritingCategoryBand, t0.MathMGP, t0.MathUpperCI, 
    t0.MathLowerCI, t0.MathOriginalNCount, t0.MathFinalNCount, t0.MathCoursesLinked, t0.ReadingMGP, 
    t0.ReadingUpperCI, t0.ReadingLowerCI, t0.ReadingOriginalNCount, t0.ReadingFinalNCount, 
    t0.ReadingCoursesLinked, t0.WritingMGP, t0.WritingUpperCI, t0.WritingLowerCI, 
    t0.WritingOriginal1YearNCount, t0.WritingFinalNCount, t0.WritingCoursesLinked, t0.School_Pts, 
    t0.District_Pts, t0.Math_Pts, t0.Reading_Pts, t0.Writing_Pts, t0.SG_Pts_Earned, t0.PP_Rating, 
    t0.LEAP_Ratin_Code, t0.LEAP_Rating, t0.SCHOOLID, t0.SCHOOLNAME, t0.REGION, t0.SCORED_STATUS, 
    t0.LE1, t0.LE2, t0.LE3, t0.LE4, t0.I1, t0.I2, t0.I3, t0.I4, t0.I5, t0.I6, t0.I7, t0.I8, 
    t0.CREATION_DATE, t0.LEADER_POINT.1, t0.LEADER_POINT.2, t0.LEADER_POINT.3, t0.LEADER_POINT.4, 
    t0.LEADER_POINT.5, t0.LEADER_POINT.6, t0.LEADER_POINT.7, t0.P1_LEADER, t0.P2_LEADER, t0.P3_LEADER, 
    t0.P4_LEADER, t0.P5_LEADER, t0.P6_LEADER, t0.P7_LEADER, t0.SchoolNumber, t0.School, t0.EdLevel, 
    t0.FirstName, t0.LastName, t0.TeacherLeaderRole, t0.Focusifapplicable, t0.Email, t0.TeamLead, 
    t0.ReleaseTime, t0.Resigned, t0.IS1314TEAMLEAD, t0.DPSEMAILADDRESS, t0.DOB, t0.CURRENTAGE, 
    t0.CURRENTAGEBRACKET, t0.V9, t0.HISPANICORLATINO, t0.MULTIRACE, t0.NATIVEHAWAIIANORPACIFICISLANDER, 
    t0.ASIAN, t0.AMERICANINDIANORALASKANATIVE, t0.BLACKORAFRICANAMERICAN, t0.WHITE, 
    t0.HIREORREHIREDATE, t0.YEARSWORKSINCEHIREORREHIRE, t0.ADJUSTEDHIREDATE, 
    t0.CURRENTRELATIONSHIPTYPE, t0.CURRENTRELATIONSHIPSTATUS, t0.POSITIONLEVEL, t0.ASSIGNMENTSTARTDATE, 
    t0.POSITIONID, t0.ASSIGNMENTBUCODE, t0.ASSIGNMENTBUDESC, t0.ASSIGNMENTFTE, 
    t0.ASSIGNMENTANNUALIZEDSALARY, t0.PREFERREDTITLE, t0.ASSIGNMENTDAYSPERYEAR, 
    t0.ASSIGNMENTHRPSSCHEDCODE, t0.ASSIGNMENTHRPSPAYGRADE, t0.ASSIGNMENTHRPSPAYSTEP, 
    t0.ASSIGNMENTHRPSGRADENAME, t0.ASSIGNMENTORGUNITCODE, t0.ASSIGNMENTORGUNITNAME, 
    t0.ASSIGNMENTSCHEDULEDESCRIPTION, t0.ASSIGNMENTFTE_A, t0.POSITIONLOCATIONCODE, t0.HROUNAME, 
    t0.POSITIONPHYSICALLOCATION, t0.JOBCODE, t0.JOBTITLE, t0.JOBSUBCATEGORYCODE, t0.JOBCATEGORYCODE, 
    t0.CLEVELNAME, t0.EXECDIRECTORLEVELNAME, t0.IMMEDIATESUPERVISORNAME, t0.V49, 
    t1.ASSIGNMENTLOCATIONTYPE, t1.TEACHERPERSCHOOLSUPPORT, t1.ACTIONREASON, t1.DESCRIPTION, 
    t1.TURNOVERTYPE, t1.PrimaryLast
  /FROM * AS t0
  /JOIN 'DataSet3' AS t1
    ON t0.DPSID=t1.DPSID
  /OUTFILE FILE=*.

DATASET CLOSE termtiondupes1314.
DATASET CLOSE DataSet3.



MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME (FIRSTNAME GENDER LASTNAME = d0 d1 d2) 
  /BY DPSID
  /DROP= d0 d1 d2.
EXECUTE.



SORT CASES BY COUNT_OBS (D).

ALTER TYPE JOBCODE (F4.0).

SORT CASES BY JOBCODE(A).

LIST DPSID JOBCODE JOBTITLE. 

FREQUENCIES VARIABLES=JOBCODE JOBTITLE JOBSUBCATEGORYCODE JOBCATEGORYCODE
  /FORMAT=AFREQ
  /ORDER=ANALYSIS.


SORT CASES BY DPSID(A).


IF  (ActiveLEAP = 1) ISLEAP1314=1.
EXECUTE.

SAVE OUTFILE = '1314MobileTeacher.sav'.


*RENAME ALL VARIABLES IN THIS FILE WITH 1314 TAG/SUFFIX

BEGIN PROGRAM.
import spss, spssaux
spssaux.OpenDataFile('/Users/deborah/1314MobileTeacher.sav')
vdict=spssaux.VariableDict()
mylist=vdict.range(start="TEACHLAST", end="ISLEAP1314")
nvars = len(mylist)

for i in range(nvars):
    myvar = mylist[i]
    mynewvar = myvar+"_1314"
    spss.Submit(r"""
        rename variables ( %s = %s) .
                        """ %(myvar, mynewvar))
END PROGRAM.



SAVE OUTFILE='//Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/1314 LEAP Mobility Teacher.sav'
  /COMPRESSED.

DATASET CLOSE DataSet1.
DATASET CLOSE DataSet2.




*******************************
*******************************
COHORT 2 1415

***NOW MERGE 1415 LEAP FILE WITH 1415 ROSTER AND TERMINATION DATA

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/SPSS '+
    'Data Files/LEAP 2014-15 Master Data Set.sav'.
DATASET NAME DataSet4 WINDOW=FRONT.


ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/SPSS Data Files/2014-15 Team Lead Roster.sav'.
DATASET NAME DataSet41 WINDOW=FRONT.


   
ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).


         DATASET ACTIVATE DataSet41.
         COMPUTE IS1415TEAMLEAD=1.
         EXECUTE.


DATASET ACTIVATE DataSet4.
STAR JOIN
  /SELECT t0.SCHOOLID, t0.FirstName, t0.LastName, t0.Birth_Date, t0.Gender, t0.Ethnicity, 
    t0.TeamLead, t0.TIFEligible, t0.Role, t0.NonTeachingTime, t0.TIFfunded, t0.Schoolfunded, 
    t0.FocusArea, t0.RecordNotesnoaction, t0.Cohort, t0.ImplementationYear1, t0.ProbationaryStatus, 
    t0.ProbationaryYear, t0.EOYContentArea, t0.EOYClassroomDesignation, t0.EOYSchoolName, 
    t0.SchEdLevel, t0.EOYRegion, t0.EOYActive, t0.IsLeapOfficial, t0.OptInOut, t0.RegionName, 
    t0.SchoolNumber, t0.SchoolName, t0.Email_Address, t0.ProbStatus, t0.ProbYear, t0.PrelimStatus, 
    t0.PrelimDecision, t0.PrelimEligibility, t0.FinalRenewalCalcStatus, t0.FinalRenewalCategory, 
    t0.FinalRenewalRecommendation, t0.FinalStatus, t0.FinalRenewalDecision, t0.FinalEligibility, 
    t0.FormCreated, t0.TeacherResigned, t0.ResignedEffectiveDate, t0.DecisionDate, t0.DeciderFirstName, 
    t0.DeciderLastName, t0.DeciderEmail, t0.ISSignor, t0.ISSignDate, t0.ISEmail, t0.SchoolLeaderSignor, 
    t0.SchoolLeaderSignDate, t0.SchoolLeaderEmail, t0.D, t0.E, t0.F, t0.G, t0.MathMedian, 
    t0.Math1YearMedian, t0.MathMGP, t0.Math1YearMGP, t0.MathUpperCI, t0.MathLowerCI, 
    t0.MathOriginalNCount, t0.MathFinalNCount, t0.MathOriginal1YearNCount, t0.Math1YearNCount, 
    t0.MathCoursesLinked, t0.MathCategoryBand, t0.ReadingMedian, t0.Reading1YearMedian, t0.ReadingMGP, 
    t0.Reading1YearMGP, t0.ReadingUpperCI, t0.ReadingLowerCI, t0.ReadingOriginalNCount, 
    t0.ReadingFinalNCount, t0.ReadingOriginal1YearNCount, t0.Reading1YearNCount, 
    t0.ReadingCoursesLinked, t0.ReadingCategoryBand, t0.WritingMedian, t0.Writing1YearMedian, 
    t0.WritingMGP, t0.Writing1YearMGP, t0.WritingUpperCI, t0.WritingLowerCI, t0.WritingOriginalNCount, 
    t0.WritingFinalNCount, t0.WritingOriginal1YearNCount, t0.Writing1YearNCount, 
    t0.WritingCoursesLinked, t0.WritingCategoryBand, t0.SG_SchoolID, t0.SG_School_Percent, 
    t0.SG_School_Score, t0.SG_District_Percent, t0.SG_District_Score, t0.TeacherName, t0.RegionCode, 
    t0.LeaderName, t0.LeaderDPSID, t0.P1Answer, t0.P2Answer, t0.P3Answer, t0.P4Answer, t0.P5Answer, 
    t0.P6Answer, t0.P7Answer, t0.CreatedBy, t0.CreatedDate, t0.UpdatedBy, t0.UpdatedDate, t0.Status, 
    t0.P1, t0.P2, t0.P3, t0.P4, t0.P5, t0.P6, t0.P7score, t0.P7Bonus, t0.LE1, t0.LE2, t0.LE3, t0.LE4, 
    t0.I1, t0.I2, t0.I3, t0.I4, t0.I5, t0.I6, t0.I7, t0.I8, t0.ofObs, t0.LEmean, t0.Imean, 
    t0.TeacherDPSID, t0.RegionNumber, t0.SGRating, t0.PPRating, t0.PointsEarned, t0.SurveyAdminType, 
    t0.TeacherEdLevel, t0.N_TeachTotalSurveys, t0.N_Stu4Teach, t0.N_Stu4Sch, t0.Q01RC, t0.Q02RC, 
    t0.Q03RC, t0.Q04RC, t0.Q05RC, t0.Q06RC, t0.Q07RC, t0.Q08RC, t0.Q09RC, t0.Q10RC, t0.Q11RC, t0.Q12RC, 
    t0.Q13RC, t0.Q14RC, t0.Q16RC, t0.Q17RC, t0.Q18RC, t0.Q19RC, t0.Q20RC, t0.Q21RC, t0.Q23RC, t0.Q24RC, 
    t0.Q25RC, t0.Q26RC, t0.Q27RC, t0.Q28RC, t0.Q29RC, t0.Q30RC, t0.Q01CP, t0.Q02CP, t0.Q03CP, t0.Q04CP, 
    t0.Q05CP, t0.Q06CP, t0.Q07CP, t0.Q08CP, t0.Q09CP, t0.Q10CP, t0.Q11CP, t0.Q12CP, t0.Q13CP, t0.Q14CP, 
    t0.Q16CP, t0.Q17CP, t0.Q18CP, t0.Q19CP, t0.Q20CP, t0.Q21CP, t0.Q23CP, t0.Q24CP, t0.Q25CP, t0.Q26CP, 
    t0.Q27CP, t0.Q28CP, t0.Q29CP, t0.Q30CP, t0.Q01PP, t0.Q02PP, t0.Q03PP, t0.Q04PP, t0.Q05PP, t0.Q06PP, 
    t0.Q07PP, t0.Q08PP, t0.Q09PP, t0.Q10PP, t0.Q11PP, t0.Q12PP, t0.Q13PP, t0.Q14PP, t0.Q16PP, t0.Q17PP, 
    t0.Q18PP, t0.Q19PP, t0.Q20PP, t0.Q21PP, t0.Q23PP, t0.Q24PP, t0.Q25PP, t0.Q26PP, t0.Q27PP, t0.Q28PP, 
    t0.Q29PP, t0.Q30PP, t0.FLPP, t0.HEPP, t0.SPP, t0.OPP, t0.RoP1, t0.RoP2, t0.RoP3, t0.RoP4, 
    t0.DRSTATUS, t0.DRSTATUS_DIFF, t0.Pmean, t0.OverallRating, t0.Rating, t0.Combined_SchPositionCode, 
    t0.SIDCHECK, t0.TIFCAMPUS, t0.@98RECORDS, t0.EMPLOYEENAME, t0.CURRENTSTATUS, t0.OPTINDATE, 
    t0.ASSIGNMENTBUCODE, t0.POS98STARTDATE, t0.HRPSSCHEDULECODE, t0.HRPSPAYGRADE, t0.HRPSPAYSTEP, 
    t0.ADJUSTPOS98STEP, t0.YEARSTO15, t0.POS98STARTYEAR, t0.PROJECTED15YOSDATE, 
    t0.CURRENTTCHR15THYOSDATE, t0.YEARSDIFFERENCE, t0.SALARYORBONUS, t0.ELL_NonELL, 
    t0.EOYContentAreaRecode, t0.SPED_NonSPED, t0.ContentCats, t0.PropationaryYearRecode, 
    t0.ProbationaryDich, t0.SchoolEOYDate, t0.Teacher_Age, t0.Teacher_Age_Dich, t0.Teacher_Age_Cats, 
    t0.YOE, t0.YOEFinal, t0.YOECat, t0.YOECat2, t0.YOEDich, t0.TeamLeadRecode, t0.TeamLead_NotTL, 
    t0.YOE5Cats, t0.Walk_Count_sum, t0.Partial_Count_sum, t0.Full_Count_sum, t0.FullCountRecode, 
    t0.DistinguishedOnlyRating, t0.FullCount1Obs, t1.Field2, t1.Field3, t1.Email, t1.School, 
    t1.SchoolLeaderContact, t1.SLEmail, t1.TLC, t1.IS1415TEAMLEAD, t1.NameChange, t1.RecordNotesnoaction 
    AS RecordNotesnoactionTL
  /FROM * AS t0
  /JOIN 'DataSet41' AS t1
    ON t0.DPSID=t1.DPSID
  /OUTFILE FILE=*.
 

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/DPS Data Files/Employee '+
    'Roster_120108_120115.xlsx'
  /SHEET=name '120114'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet5 WINDOW=FRONT.


ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).




DATASET ACTIVATE DataSet4.
STAR JOIN
  /SELECT t0.SCHOOLID, t0.FirstName, t0.LastName, t0.Birth_Date, t0.Gender, t0.Ethnicity, 
    t0.TeamLead, t0.TIFEligible, t0.Role, t0.NonTeachingTime, t0.TIFfunded, t0.Schoolfunded, 
    t0.FocusArea, t0.RecordNotesnoaction, t0.Cohort, t0.ImplementationYear1, t0.ProbationaryStatus, 
    t0.ProbationaryYear, t0.EOYContentArea, t0.EOYClassroomDesignation, t0.EOYSchoolName, 
    t0.SchEdLevel, t0.EOYRegion, t0.EOYActive, t0.IsLeapOfficial, t0.OptInOut, t0.RegionName, 
    t0.SchoolNumber, t0.SchoolName, t0.Email_Address, t0.ProbStatus, t0.ProbYear, t0.PrelimStatus, 
    t0.PrelimDecision, t0.PrelimEligibility, t0.FinalRenewalCalcStatus, t0.FinalRenewalCategory, 
    t0.FinalRenewalRecommendation, t0.FinalStatus, t0.FinalRenewalDecision, t0.FinalEligibility, 
    t0.FormCreated, t0.TeacherResigned, t0.ResignedEffectiveDate, t0.DecisionDate, t0.DeciderFirstName, 
    t0.DeciderLastName, t0.DeciderEmail, t0.ISSignor, t0.ISSignDate, t0.ISEmail, t0.SchoolLeaderSignor, 
    t0.SchoolLeaderSignDate, t0.SchoolLeaderEmail, t0.D, t0.E, t0.F, t0.G, t0.MathMedian, 
    t0.Math1YearMedian, t0.MathMGP, t0.Math1YearMGP, t0.MathUpperCI, t0.MathLowerCI, 
    t0.MathOriginalNCount, t0.MathFinalNCount, t0.MathOriginal1YearNCount, t0.Math1YearNCount, 
    t0.MathCoursesLinked, t0.MathCategoryBand, t0.ReadingMedian, t0.Reading1YearMedian, t0.ReadingMGP, 
    t0.Reading1YearMGP, t0.ReadingUpperCI, t0.ReadingLowerCI, t0.ReadingOriginalNCount, 
    t0.ReadingFinalNCount, t0.ReadingOriginal1YearNCount, t0.Reading1YearNCount, 
    t0.ReadingCoursesLinked, t0.ReadingCategoryBand, t0.WritingMedian, t0.Writing1YearMedian, 
    t0.WritingMGP, t0.Writing1YearMGP, t0.WritingUpperCI, t0.WritingLowerCI, t0.WritingOriginalNCount, 
    t0.WritingFinalNCount, t0.WritingOriginal1YearNCount, t0.Writing1YearNCount, 
    t0.WritingCoursesLinked, t0.WritingCategoryBand, t0.SG_SchoolID, t0.SG_School_Percent, 
    t0.SG_School_Score, t0.SG_District_Percent, t0.SG_District_Score, t0.TeacherName, t0.RegionCode, 
    t0.LeaderName, t0.LeaderDPSID, t0.P1Answer, t0.P2Answer, t0.P3Answer, t0.P4Answer, t0.P5Answer, 
    t0.P6Answer, t0.P7Answer, t0.CreatedBy, t0.CreatedDate, t0.UpdatedBy, t0.UpdatedDate, t0.Status, 
    t0.P1, t0.P2, t0.P3, t0.P4, t0.P5, t0.P6, t0.P7score, t0.P7Bonus, t0.LE1, t0.LE2, t0.LE3, t0.LE4, 
    t0.I1, t0.I2, t0.I3, t0.I4, t0.I5, t0.I6, t0.I7, t0.I8, t0.ofObs, t0.LEmean, t0.Imean, 
    t0.TeacherDPSID, t0.RegionNumber, t0.SGRating, t0.PPRating, t0.PointsEarned, t0.SurveyAdminType, 
    t0.TeacherEdLevel, t0.N_TeachTotalSurveys, t0.N_Stu4Teach, t0.N_Stu4Sch, t0.Q01RC, t0.Q02RC, 
    t0.Q03RC, t0.Q04RC, t0.Q05RC, t0.Q06RC, t0.Q07RC, t0.Q08RC, t0.Q09RC, t0.Q10RC, t0.Q11RC, t0.Q12RC, 
    t0.Q13RC, t0.Q14RC, t0.Q16RC, t0.Q17RC, t0.Q18RC, t0.Q19RC, t0.Q20RC, t0.Q21RC, t0.Q23RC, t0.Q24RC, 
    t0.Q25RC, t0.Q26RC, t0.Q27RC, t0.Q28RC, t0.Q29RC, t0.Q30RC, t0.Q01CP, t0.Q02CP, t0.Q03CP, t0.Q04CP, 
    t0.Q05CP, t0.Q06CP, t0.Q07CP, t0.Q08CP, t0.Q09CP, t0.Q10CP, t0.Q11CP, t0.Q12CP, t0.Q13CP, t0.Q14CP, 
    t0.Q16CP, t0.Q17CP, t0.Q18CP, t0.Q19CP, t0.Q20CP, t0.Q21CP, t0.Q23CP, t0.Q24CP, t0.Q25CP, t0.Q26CP, 
    t0.Q27CP, t0.Q28CP, t0.Q29CP, t0.Q30CP, t0.Q01PP, t0.Q02PP, t0.Q03PP, t0.Q04PP, t0.Q05PP, t0.Q06PP, 
    t0.Q07PP, t0.Q08PP, t0.Q09PP, t0.Q10PP, t0.Q11PP, t0.Q12PP, t0.Q13PP, t0.Q14PP, t0.Q16PP, t0.Q17PP, 
    t0.Q18PP, t0.Q19PP, t0.Q20PP, t0.Q21PP, t0.Q23PP, t0.Q24PP, t0.Q25PP, t0.Q26PP, t0.Q27PP, t0.Q28PP, 
    t0.Q29PP, t0.Q30PP, t0.FLPP, t0.HEPP, t0.SPP, t0.OPP, t0.RoP1, t0.RoP2, t0.RoP3, t0.RoP4, 
    t0.DRSTATUS, t0.DRSTATUS_DIFF, t0.Pmean, t0.OverallRating, t0.Rating, t0.Combined_SchPositionCode, 
    t0.SIDCHECK, t0.TIFCAMPUS, t0.@98RECORDS, t0.EMPLOYEENAME, t0.CURRENTSTATUS, t0.OPTINDATE, 
    t0.ASSIGNMENTBUCODE, t0.POS98STARTDATE, t0.HRPSSCHEDULECODE, t0.HRPSPAYGRADE, t0.HRPSPAYSTEP, 
    t0.ADJUSTPOS98STEP, t0.YEARSTO15, t0.POS98STARTYEAR, t0.PROJECTED15YOSDATE, 
    t0.CURRENTTCHR15THYOSDATE, t0.YEARSDIFFERENCE, t0.SALARYORBONUS, t0.ELL_NonELL, 
    t0.EOYContentAreaRecode, t0.SPED_NonSPED, t0.ContentCats, t0.PropationaryYearRecode, 
    t0.ProbationaryDich, t0.SchoolEOYDate, t0.Teacher_Age, t0.Teacher_Age_Dich, t0.Teacher_Age_Cats, 
    t0.YOE, t0.YOEFinal, t0.YOECat, t0.YOECat2, t0.YOEDich, t0.TeamLeadRecode, t0.TeamLead_NotTL, 
    t0.YOE5Cats, t0.Walk_Count_sum, t0.Partial_Count_sum, t0.Full_Count_sum, t0.FullCountRecode, 
    t0.DistinguishedOnlyRating, t0.FullCount1Obs, t0.Field2, t0.Field3, t0.Email, t0.School, 
    t0.SchoolLeaderContact, t0.SLEmail, t0.TLC, t0.IS1415TEAMLEAD, t0.NameChange, 
    t0.RecordNotesnoactionTL, t1.DPSEMAILADDRESS, t1.DOB, t1.CURRENTAGE, t1.CURRENTAGEBRACKET, t1.V9, 
    t1.HISPANICORLATINO, t1.MULTIRACE, t1.NATIVEHAWAIIANORPACIFICISLANDER, t1.ASIAN, 
    t1.AMERICANINDIANORALASKANATIVE, t1.BLACKORAFRICANAMERICAN, t1.WHITE, t1.HIREORREHIREDATE, 
    t1.YEARSWORKSINCEHIREORREHIRE, t1.ADJUSTEDHIREDATE, t1.CURRENTRELATIONSHIPTYPE, 
    t1.CURRENTRELATIONSHIPSTATUS, t1.POSITIONLEVEL, t1.ASSIGNMENTSTARTDATE, t1.POSITIONID, 
    t1.ASSIGNMENTBUDESC, t1.ASSIGNMENTFTE, t1.ASSIGNMENTANNUALIZEDSALARY, t1.PREFERREDTITLE, 
    t1.ASSIGNMENTDAYSPERYEAR, t1.ASSIGNMENTHRPSSCHEDCODE, t1.ASSIGNMENTHRPSPAYGRADE, 
    t1.ASSIGNMENTHRPSPAYSTEP, t1.ASSIGNMENTHRPSGRADENAME, t1.ASSIGNMENTORGUNITCODE, 
    t1.ASSIGNMENTORGUNITNAME, t1.ASSIGNMENTSCHEDULEDESCRIPTION, t1.ASSIGNMENTFTE_A, 
    t1.POSITIONLOCATIONCODE, t1.HROUNAME, t1.POSITIONPHYSICALLOCATION, t1.JOBCODE, t1.JOBTITLE, 
    t1.JOBSUBCATEGORYCODE, t1.JOBCATEGORYCODE, t1.CLEVELNAME, t1.EXECDIRECTORLEVELNAME, 
    t1.IMMEDIATESUPERVISORNAME, t1.V49
  /FROM * AS t0
  /JOIN 'DataSet5' AS t1
    ON t0.DPSID=t1.DPSID
  /OUTFILE FILE=*.

DATASET CLOSE DataSet41.

DATASET CLOSE DataSet5.



*VERIFY THE NUMBER OF TEAM LEADS AND THE CORRECT VARIABLE TO USE

FREQUENCIES VARIABLES= TeamLeadRecode TeamLead_NotTL IS1415TEAMLEAD
  /ORDER=ANALYSIS.


USE ALL.
COMPUTE filter_$=(MISSING(IS1415TEAMLEAD)=1  & TeamLead_NotTL = 1).
VARIABLE LABELS filter_$ 'MISSING(IS1415TEAMLEAD)=1  & TeamLead_NotTL = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

**


**ADD TERMINATION DATA

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/DPS Data Files/Terminations '+
    'Report_2011.12_2014.15.xlsx'
  /SHEET=name 'Terms_120214_120115'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet6 WINDOW=FRONT.

RENAME VARIABLES EMPLOYEE=DPSID.
ALTER TYPE DPSID (F9.0).
SORT CASES BY DPSID(A).



*FIRST DEAL WITH 13 DUPLICATE EMPLOYEE IDS
*FILE WILL NOT MERGE WITH DUPLICATES IN KEYED TABLE BY VARIABLE


*ONLY 100191512 FROM THE TERMINATION FILE IS IN COHORT 2.
 
* Identify Duplicate Cases. 
SORT CASES BY DPSID(A). 
MATCH FILES 
  /FILE=* 
  /BY DPSID 
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
  /DROP=PrimaryFirst InDupGrp MatchSequence. 
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'. 
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'. 
VARIABLE LEVEL  PrimaryLast (ORDINAL). 
FREQUENCIES VARIABLES=PrimaryLast.


DATASET ACTIVATE DataSet6.
DATASET COPY  terminationdupes1415.
DATASET ACTIVATE  terminationdupes1415.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 0).
EXECUTE.




DATASET ACTIVATE DataSet6.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.


DELETE VARIABLES  AUDITEFFECTIVEDATE TERMINATIONNOTICEDATE POSITION EMPLOYEENAME ASSIGNMENTORGUNITNAME HROUNAME 
    ASSIGNMENTBUCODE POSITIONPHYSICALLOCATION CLEVELNAME CURRENTRELATIONSHIPTYPE 
    CURRENTRELATIONSHIPSTATUS SUPERVISORNAME POSITIONTITLE JOBCODE JOBCATEGORYNAME JOBSUBCATEGORYCODE 
    JOBSUBCATEGORYNAME HIREORREHIREDATE UNIQUEEMPLOYEE UNIQUEPOSITION AUDITEFFECTIVEMONTH AUDITEFFECTIVEYEAR FISCALYEAR HROUOWNERLASTNAME ISSFESUBSTITUTE 
    ISHRMETRICSTEMP ISHRMETRICSRIB.



DATASET ACTIVATE DataSet4. 

STAR JOIN
  /SELECT t0.SCHOOLID, t0.FirstName, t0.LastName, t0.Birth_Date, t0.Gender, t0.Ethnicity, 
    t0.TeamLead, t0.TIFEligible, t0.Role, t0.NonTeachingTime, t0.TIFfunded, t0.Schoolfunded, 
    t0.FocusArea, t0.RecordNotesnoaction, t0.Cohort, t0.ImplementationYear1, t0.ProbationaryStatus, 
    t0.ProbationaryYear, t0.EOYContentArea, t0.EOYClassroomDesignation, t0.EOYSchoolName, 
    t0.SchEdLevel, t0.EOYRegion, t0.EOYActive, t0.IsLeapOfficial, t0.OptInOut, t0.RegionName, 
    t0.SchoolNumber, t0.SchoolName, t0.Email_Address, t0.ProbStatus, t0.ProbYear, t0.PrelimStatus, 
    t0.PrelimDecision, t0.PrelimEligibility, t0.FinalRenewalCalcStatus, t0.FinalRenewalCategory, 
    t0.FinalRenewalRecommendation, t0.FinalStatus, t0.FinalRenewalDecision, t0.FinalEligibility, 
    t0.FormCreated, t0.TeacherResigned, t0.ResignedEffectiveDate, t0.DecisionDate, t0.DeciderFirstName, 
    t0.DeciderLastName, t0.DeciderEmail, t0.ISSignor, t0.ISSignDate, t0.ISEmail, t0.SchoolLeaderSignor, 
    t0.SchoolLeaderSignDate, t0.SchoolLeaderEmail, t0.D, t0.E, t0.F, t0.G, t0.MathMedian, 
    t0.Math1YearMedian, t0.MathMGP, t0.Math1YearMGP, t0.MathUpperCI, t0.MathLowerCI, 
    t0.MathOriginalNCount, t0.MathFinalNCount, t0.MathOriginal1YearNCount, t0.Math1YearNCount, 
    t0.MathCoursesLinked, t0.MathCategoryBand, t0.ReadingMedian, t0.Reading1YearMedian, t0.ReadingMGP, 
    t0.Reading1YearMGP, t0.ReadingUpperCI, t0.ReadingLowerCI, t0.ReadingOriginalNCount, 
    t0.ReadingFinalNCount, t0.ReadingOriginal1YearNCount, t0.Reading1YearNCount, 
    t0.ReadingCoursesLinked, t0.ReadingCategoryBand, t0.WritingMedian, t0.Writing1YearMedian, 
    t0.WritingMGP, t0.Writing1YearMGP, t0.WritingUpperCI, t0.WritingLowerCI, t0.WritingOriginalNCount, 
    t0.WritingFinalNCount, t0.WritingOriginal1YearNCount, t0.Writing1YearNCount, 
    t0.WritingCoursesLinked, t0.WritingCategoryBand, t0.SG_SchoolID, t0.SG_School_Percent, 
    t0.SG_School_Score, t0.SG_District_Percent, t0.SG_District_Score, t0.TeacherName, t0.RegionCode, 
    t0.LeaderName, t0.LeaderDPSID, t0.P1Answer, t0.P2Answer, t0.P3Answer, t0.P4Answer, t0.P5Answer, 
    t0.P6Answer, t0.P7Answer, t0.CreatedBy, t0.CreatedDate, t0.UpdatedBy, t0.UpdatedDate, t0.Status, 
    t0.P1, t0.P2, t0.P3, t0.P4, t0.P5, t0.P6, t0.P7score, t0.P7Bonus, t0.LE1, t0.LE2, t0.LE3, t0.LE4, 
    t0.I1, t0.I2, t0.I3, t0.I4, t0.I5, t0.I6, t0.I7, t0.I8, t0.ofObs, t0.LEmean, t0.Imean, 
    t0.TeacherDPSID, t0.RegionNumber, t0.SGRating, t0.PPRating, t0.PointsEarned, t0.SurveyAdminType, 
    t0.TeacherEdLevel, t0.N_TeachTotalSurveys, t0.N_Stu4Teach, t0.N_Stu4Sch, t0.Q01RC, t0.Q02RC, 
    t0.Q03RC, t0.Q04RC, t0.Q05RC, t0.Q06RC, t0.Q07RC, t0.Q08RC, t0.Q09RC, t0.Q10RC, t0.Q11RC, t0.Q12RC, 
    t0.Q13RC, t0.Q14RC, t0.Q16RC, t0.Q17RC, t0.Q18RC, t0.Q19RC, t0.Q20RC, t0.Q21RC, t0.Q23RC, t0.Q24RC, 
    t0.Q25RC, t0.Q26RC, t0.Q27RC, t0.Q28RC, t0.Q29RC, t0.Q30RC, t0.Q01CP, t0.Q02CP, t0.Q03CP, t0.Q04CP, 
    t0.Q05CP, t0.Q06CP, t0.Q07CP, t0.Q08CP, t0.Q09CP, t0.Q10CP, t0.Q11CP, t0.Q12CP, t0.Q13CP, t0.Q14CP, 
    t0.Q16CP, t0.Q17CP, t0.Q18CP, t0.Q19CP, t0.Q20CP, t0.Q21CP, t0.Q23CP, t0.Q24CP, t0.Q25CP, t0.Q26CP, 
    t0.Q27CP, t0.Q28CP, t0.Q29CP, t0.Q30CP, t0.Q01PP, t0.Q02PP, t0.Q03PP, t0.Q04PP, t0.Q05PP, t0.Q06PP, 
    t0.Q07PP, t0.Q08PP, t0.Q09PP, t0.Q10PP, t0.Q11PP, t0.Q12PP, t0.Q13PP, t0.Q14PP, t0.Q16PP, t0.Q17PP, 
    t0.Q18PP, t0.Q19PP, t0.Q20PP, t0.Q21PP, t0.Q23PP, t0.Q24PP, t0.Q25PP, t0.Q26PP, t0.Q27PP, t0.Q28PP, 
    t0.Q29PP, t0.Q30PP, t0.FLPP, t0.HEPP, t0.SPP, t0.OPP, t0.RoP1, t0.RoP2, t0.RoP3, t0.RoP4, 
    t0.DRSTATUS, t0.DRSTATUS_DIFF, t0.Pmean, t0.OverallRating, t0.Rating, t0.Combined_SchPositionCode, 
    t0.SIDCHECK, t0.TIFCAMPUS, t0.@98RECORDS, t0.EMPLOYEENAME, t0.CURRENTSTATUS, t0.OPTINDATE, 
    t0.ASSIGNMENTBUCODE, t0.POS98STARTDATE, t0.HRPSSCHEDULECODE, t0.HRPSPAYGRADE, t0.HRPSPAYSTEP, 
    t0.ADJUSTPOS98STEP, t0.YEARSTO15, t0.POS98STARTYEAR, t0.PROJECTED15YOSDATE, 
    t0.CURRENTTCHR15THYOSDATE, t0.YEARSDIFFERENCE, t0.SALARYORBONUS, t0.ELL_NonELL, 
    t0.EOYContentAreaRecode, t0.SPED_NonSPED, t0.ContentCats, t0.PropationaryYearRecode, 
    t0.ProbationaryDich, t0.SchoolEOYDate, t0.Teacher_Age, t0.Teacher_Age_Dich, t0.Teacher_Age_Cats, 
    t0.YOE, t0.YOEFinal, t0.YOECat, t0.YOECat2, t0.YOEDich, t0.TeamLeadRecode, t0.TeamLead_NotTL, 
    t0.YOE5Cats, t0.Walk_Count_sum, t0.Partial_Count_sum, t0.Full_Count_sum, t0.FullCountRecode, 
    t0.DistinguishedOnlyRating, t0.FullCount1Obs, t0.Field2, t0.Field3, t0.Email, t0.School, 
    t0.SchoolLeaderContact, t0.SLEmail, t0.TLC, t0.IS1415TEAMLEAD, t0.NameChange, 
    t0.RecordNotesnoactionTL, t0.DPSEMAILADDRESS, t0.DOB, t0.CURRENTAGE, t0.CURRENTAGEBRACKET, t0.V9, 
    t0.HISPANICORLATINO, t0.MULTIRACE, t0.NATIVEHAWAIIANORPACIFICISLANDER, t0.ASIAN, 
    t0.AMERICANINDIANORALASKANATIVE, t0.BLACKORAFRICANAMERICAN, t0.WHITE, t0.HIREORREHIREDATE, 
    t0.YEARSWORKSINCEHIREORREHIRE, t0.ADJUSTEDHIREDATE, t0.CURRENTRELATIONSHIPTYPE, 
    t0.CURRENTRELATIONSHIPSTATUS, t0.POSITIONLEVEL, t0.ASSIGNMENTSTARTDATE, t0.POSITIONID, 
    t0.ASSIGNMENTBUDESC, t0.ASSIGNMENTFTE, t0.ASSIGNMENTANNUALIZEDSALARY, t0.PREFERREDTITLE, 
    t0.ASSIGNMENTDAYSPERYEAR, t0.ASSIGNMENTHRPSSCHEDCODE, t0.ASSIGNMENTHRPSPAYGRADE, 
    t0.ASSIGNMENTHRPSPAYSTEP, t0.ASSIGNMENTHRPSGRADENAME, t0.ASSIGNMENTORGUNITCODE, 
    t0.ASSIGNMENTORGUNITNAME, t0.ASSIGNMENTSCHEDULEDESCRIPTION, t0.ASSIGNMENTFTE_A, 
    t0.POSITIONLOCATIONCODE, t0.HROUNAME, t0.POSITIONPHYSICALLOCATION, t0.JOBCODE, t0.JOBTITLE, 
    t0.JOBSUBCATEGORYCODE, t0.JOBCATEGORYCODE, t0.CLEVELNAME, t0.EXECDIRECTORLEVELNAME, 
    t0.IMMEDIATESUPERVISORNAME, t0.V49, t1.ASSIGNMENTLOCATIONTYPE, 
    t1.TEACHERPERSCHOOLSUPPORT, t1.ACTIONREASON, t1.DESCRIPTION, t1.TURNOVERTYPE
  /FROM * AS t0
  /JOIN 'DataSet6' AS t1
    ON t0.DPSID=t1.DPSID
  /OUTFILE FILE=*.


IF  (IsLeapOfficial= "True") ISLEAP1415=1.
EXECUTE.

SAVE OUTFILE = '1415MobileTeacher2.sav'.


Title "IS1415 TEAMLEAD VAR".
list DPSID LastName FirstName.


*RENAME ALL VARIABLES IN THIS FILE WITH 1415 TAG/SUFFIX

BEGIN PROGRAM.
import spss, spssaux
spssaux.OpenDataFile('/Users/deborah/1415MobileTeacher2.sav')
vdict=spssaux.VariableDict()
mylist=vdict.range(start="LastName", end="ISLEAP1415")
nvars = len(mylist)

for i in range(nvars):
    myvar = mylist[i]
    mynewvar = myvar+"_1415"
    spss.Submit(r"""
        rename variables ( %s = %s) .
                        """ %(myvar, mynewvar))
END PROGRAM.

SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/1415 LEAP Mobility Teacher2.sav'
  /COMPRESSED.


*******************************************************************
*******************************************************************


**NOW MERGE BOTH COHORTS INTO ONE FILE

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/1314 LEAP Mobility Teacher.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

SORT CASES BY DPSID(A).


GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/Data Files/1415 LEAP Mobility Teacher2.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

SORT CASES BY DPSID(A).


DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY DPSID.
EXECUTE.


SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/LEAP Teacher Mobility 1314-1415 Level 1_1.31.16.sav'
  /COMPRESSED.




DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=ISLEAP1314_1314 ISLEAP1415_1415
  /ORDER=ANALYSIS.





*******************************************************
******************************************************
                   LEAP MOBILITY ANALYSIS
                     RESEARCH QUESTIONS  2
                 1314 1415  SCHOOL LEVEL PANELS
*******************************************************
******************************************************
*******************************************************

COHORT 1
*THIS FILE ONLY CONTAINS DPS CAMPUS IDS
*THESE DIFFERENTIATE BETWEEN ES MS HS
*SPF ID DOES NOT DIFFENTIATE ES MS AND HS WOULD HAVE THE SAME SPF ID

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/DPS Data Files/1314 School Characteristics.xlsx'
  /SHEET=name '1314 School Characteristics'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet20 WINDOW=FRONT.

ALTER TYPE Year schoolnum (F4).
RENAME VARIABLES schoolnum = schoolnum_DPS.

ALTER TYPE schoolnum_DPS (F3).
SORT CASES BY schoolnum_DPS (A).




*THI FILE CONTAINS DPS AND SPF SCHOOL IDS

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2013-14/Data Files/DPS Data Files/1314_SPFResults_041415.xlsx'
  /SHEET=name '1314 SPFResults'  
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet21 WINDOW=FRONT.

ALTER TYPE SPFSchNum DPSSchNum (F3). 

RENAME VARIABLES 
SPFSchNum = schoolnum_SPF
DPSSchNum=schoolnum_DPS. 

SORT CASES BY schoolnum_DPS(A).


DATASET ACTIVATE DataSet21.
* Identify Duplicate Cases.
SORT CASES BY schoolnum_DPS(A).
MATCH FILES
  /FILE=*
  /BY schoolnum_DPS
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
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.



DATASET ACTIVATE  DataSet21.


USE ALL.
COMPUTE filter_$=(schoolnum_DPS= 177|
schoolnum_DPS= 177|
schoolnum_DPS=189|
schoolnum_DPS=190|
schoolnum_DPS=194|
schoolnum_DPS=195|
schoolnum_DPS=196|
schoolnum_DPS=197|
schoolnum_DPS=211|
schoolnum_DPS=212|
schoolnum_DPS=216|
schoolnum_DPS=235|
schoolnum_DPS=258|
schoolnum_DPS=259|
schoolnum_DPS=266|
schoolnum_DPS=279|
schoolnum_DPS=289|
schoolnum_DPS=297|
schoolnum_DPS=328|
schoolnum_DPS=330|
schoolnum_DPS=487).
VARIABLE LABELS filter_$ 'schoolnum_DPS= 177 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.




IF  ( SPFDescription ~= "" & filter_$ = 1) DPSIDPRIMARY=5.
EXECUTE.


DATASET ACTIVATE DataSet21.
USE ALL.
COMPUTE filter_2=(SPFDescription ~= "" & filter_$ = 1).
VARIABLE LABELS filter_2 'SPFDescription ~= "" & filter_$ = 1 (FILTER)'.
VALUE LABELS filter_2 0 'Not Selected' 1 'Selected'.
FORMATS filter_2 (f1.0).
FILTER BY filter_2.
EXECUTE.


DATASET ACTIVATE DataSet21.
IF  (filter_$ = 1 & SYSMIS(DPSIDPRIMARY)=1) delete=1.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (SYSMIS(delete)=1).
EXECUTE.
SORT CASES BY schoolnum_DPS(A).  

DELETE VARIABLES PrimaryLast filter_$ DPSIDPRIMARY delete.

DATASET ACTIVATE DataSet20.
STAR JOIN
  /SELECT t0.Year, t0.name, t0.SchEdLevel, t0.TotalSchoolN, t0.Asian, t0.AmericanIndian, t0.Black, 
    t0.Hispanic, t0.White, t0.NativeHawaiian, t0.TwoorMore, t0.Minority, t0.ELL, t0.Exited, t0.NonELL, 
    t0.FreeorReduced, t0.SPED, t0.@GT, t0.MobilityRate, t0.Female, t0.TitleI, t0.Minority4, 
    t0.Minority5, t0.ELLs4, t0.ELLs5, t0.FRL4, t0.FRL5, t0.SPED4, t0.SPED5, t0.@GT4, t0.@GT5, 
    t0.MOBILITY4, t0.MOBILITY5, t0.FEMALE4, t0.FEMALE5, t1.schoolnum_SPF, t1.SPFSchName, t1.DPSSchName, 
    t1.SPFType, t1.SPOT_Growth_PE, t1.SPOT_Growth_PP, t1.SPOT_Growth_Pct, t1.SPOT_Growth_Color, 
    t1.SPOT_Growth_Description, t1.SA_Status_PE, t1.SA_Status_PP, t1.SA_Status_Pct, t1.SA_Status_Color, 
    t1.SA_Status_Description, t1.SES_PE, t1.SES_PP, t1.SES_Pct, t1.SES_Color, t1.SES_Description, 
    t1.PES_PE, t1.PES_PP, t1.PES_Pct, t1.PES_Color, t1.PES_Description, t1.Enroll_PE, t1.Enroll_PP, 
    t1.Enroll_Pct, t1.Enroll_Color, t1.Enroll_Description, t1.PSR_Growth_PE, t1.PSR_Growth_PP, 
    t1.PSR_Growth_Pct, t1.PSR_Growth_Color, t1.PSR_Growth_Description, t1.PSR_Status_PE, 
    t1.PSR_Status_PP, t1.PSR_Status_Pct, t1.PSR_Status_Color, t1.PSR_Status_Description, t1.PSR_PE, 
    t1.PSR_PP, t1.PSR_Pct, t1.PSR_Color, t1.PSR_Description, t1.SPF_Final_PE, t1.SPF_Final_PP, 
    t1.SPF_Final_Pct, t1.SPFColor, t1.SPFDescription
  /FROM * AS t0
  /JOIN 'DataSet21' AS t1
    ON t0.schoolnum_DPS=t1.schoolnum_DPS
  /OUTFILE FILE=*.


COMPUTE ISCAMP1314=1.
EXECUTE.




SAVE OUTFILE = '1314SchoolLevelMobile.sav'.

SORT CASES BY schoolnum_DPS(A).


SAVE OUTFILE = '1314SchoolLevelMobile.sav'.

*RENAME ALL VARIABLES IN THIS FILE WITH 1314 TAG/SUFFIX

BEGIN PROGRAM.
import spss, spssaux
spssaux.OpenDataFile('/Users/deborah/1314SchoolLevelMobile.sav')
vdict=spssaux.VariableDict()
mylist=vdict.range(start="Year", end="ISCAMP1314")
nvars = len(mylist)

for i in range(nvars):
    myvar = mylist[i]
    mynewvar = myvar+"_1314"
    spss.Submit(r"""
        rename variables ( %s = %s) .
                        """ %(myvar, mynewvar))
END PROGRAM.



SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/1314 School Level Mobility.sav'
  /COMPRESSED.



*********************************************************************************
*********************************************************************************
COHORT 2 1415

***NOW MERGE 1415 LEAP FILE WITH 1415 ROSTER AND TERMINATION DATA
*MERGE SCHOOL CHARACTERISTICS SPF, LEAD, COLLABORTE


GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/DPS Data Files/1415 y_School Characteristics.xlsx'
  /SHEET=name '_1415_y_School_Characteristics'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet30 WINDOW=FRONT.


ALTER TYPE SPFSchNum DPSSchNum (F3). 

RENAME VARIABLES 
SPFSchNum = schoolnum_SPF
DPSSchNum=schoolnum_DPS. 

SORT CASES BY schoolnum_DPS(A).


*GET LEAD DATA 
*LEAD WAS FIRST CONDUCTED IN 1415, SO 1314 DATA DOESN'T EXIST

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/DPS Data Files/1415 LEAD Ratings.xlsx'
  /SHEET=name '_1415_LEAD_Ratings'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet32 WINDOW=FRONT.

*SELECT ONLY THE OFFICIAL PRINCIPALS OF EACH SCHOOL

DATASET ACTIVATE DataSet32.
* Identify Duplicate Cases.
SORT CASES BY SchoolCode(A).
MATCH FILES
  /FILE=*
  /BY SchoolCode
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
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

ALTER TYPE SchoolCode (F3.0).

RENAME VARIABLES SchoolCode =schoolnum_DPS. 

SORT CASES BY schoolnum_DPS. 

USE ALL.
COMPUTE filter_$=(Prin = 1).
VARIABLE LABELS filter_$ 'Prin = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=schoolnum_DPS
  /ORDER=ANALYSIS.




DATASET COPY  LEADleaders.
DATASET ACTIVATE  LEADleaders.
FILTER OFF.
USE ALL.
SELECT IF (Prin = 1).
EXECUTE.
DATASET ACTIVATE  DataSet32.

DATASET ACTIVATE  LEADleaders.


* Identify Duplicate Cases.
SORT CASES BY schoolnum_DPS(A).
MATCH FILES
  /FILE=*
  /BY schoolnum_DPS
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast1.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast1.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast1 InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.


*IF THERE ARE STILL CASES WITH MORE THAN ONE SCHOOL LEADER PER SCHOOL
*AGGREGATE THEIR SCORES. 


DATASET ACTIVATE LEADleaders.
SORT CASES BY schoolnum_DPS.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /PRESORTED
  /BREAK=schoolnum_DPS
  /CEL1num_mean=MEAN(CEL1num) 
  /CEL2num_mean=MEAN(CEL2num) 
  /IL1num_mean=MEAN(IL1num) 
  /IL2num_mean=MEAN(IL2num) 
  /IL3num_mean=MEAN(IL3num) 
  /HRL1num_mean=MEAN(HRL1num) 
  /HRL2num_mean=MEAN(HRL2num) 
  /SL1num_mean=MEAN(SL1num) 
  /SL2num_mean=MEAN(SL2num) 
  /OLnum_mean=MEAN(OLnum) 
  /CLnum_mean=MEAN(CLnum) 
  /PPAverage_mean=MEAN(PPAverage).


FILTER OFF.
USE ALL.
SELECT IF (PrimaryFirst = 1).
EXECUTE.



*RECODE SOME VARIABLES 

ALTER TYPE DPSID (F9.0).



DATASET ACTIVATE DataSet30.
STAR JOIN
  /SELECT t0.CDESchNum, t0.schoolnum_SPF, t0.SchName, t0.SPFSchName, t0.Classification, 
    t0.Schoollevel, t0.GISRegion, t0.ISRegion, t0.CurrentConfig, t0.FinalConfig, t0.SchoolStartDate, 
    t0.Principal, t0.IS, t0.GovType1415, t0.EdLevel1415, t0.SPFRating1314, t0.TNLI1415, 
    t0.HighNeeds1415, t0.PrincipalYRBuilding1415, t0.TNLIDummy1415, t0.TotalSchoolN, t0.Asian, 
    t0.AmericanIndian, t0.Black, t0.Hispanic, t0.White, t0.NativeHawaiian, t0.TwoorMore, t0.Minority, 
    t0.ELL, t0.Exited, t0.NonELL, t0.FreeorReduced, t0.SPED, t0.@GT, t0.MobilityRate, t0.Female, 
    t0.TitleI, t1.DPSID, t1.EmployeeName, t1.Gender, t1.GenderDich, t1.RaceEth, t1.RaceEthDich, t1.Age, 
    t1.Title, t1.Prin, t1.School, t1.Network, t1.Manager, t1.AppraisalForm, t1.OverallRating, 
    t1.OverallDich, t1.StudentGrowth201314, t1.SGCatClean, t1.CEL1, t1.CEL2, t1.IL1, t1.IL2, t1.IL3, 
    t1.HRL1, t1.HRL2, t1.SL1, t1.SL2, t1.OL, t1.CL, t1.PGP1, t1.PGP2, t1.CEL1num, t1.CEL2num, 
    t1.IL1num, t1.IL2num, t1.IL3num, t1.HRL1num, t1.HRL2num, t1.SL1num, t1.SL2num, t1.OLnum, t1.CLnum, 
    t1.PPAverage, t1.PPRecommended, t1.MatrixCat, t1.AppropriateRating, t1.HighorLow, t1.PPenteredPrin, 
    t1.PPEnteredAP, t1.PPEntered, t1.InitialThoughtsPrinOverall, t1.InitialThoughtsMatch, t1.APIL1, 
    t1.APIL3, t1.APHRL1, t1.APSL1, t1.APOL, t1.APIL1Match, t1.APIL3Match, t1.APHRL1Match, 
    t1.APSL1Match, t1.APOLMatch, t1.MYCEL1, t1.MYCEL2, t1.MYIL1, t1.MYIL2, t1.MYIL3, t1.MYHRL1, 
    t1.MYHRL2, t1.MYSL1, t1.MYSL2, t1.MYOL, t1.MYCL, t1.MYPPAvg, t1.MYRecPPRating, t1.MYCEL1Match, 
    t1.MYCEL2Match, t1.MYIL1Match, t1.MYIL2Match, t1.MYIL3Match, t1.MYHRL1Match, t1.MYHRL2Match, 
    t1.MYSL1Match, t1.MYSL2Match, t1.MYOLMatch, t1.MYCLMatch, t1.MYPPAvgMatch, t1.MYPPRecRatingMatch, 
    t1.MYPPRecRatingHighLow, t1.PrimaryLast, t1.filter_$, t1.PrimaryFirst, t1.CEL1num_mean, 
    t1.CEL2num_mean, t1.IL1num_mean, t1.IL2num_mean, t1.IL3num_mean, t1.HRL1num_mean, t1.HRL2num_mean, 
    t1.SL1num_mean, t1.SL2num_mean, t1.OLnum_mean, t1.CLnum_mean, t1.PPAverage_mean
  /FROM * AS t0
  /JOIN 'LEADleaders' AS t1
    ON t0.schoolnum_DPS=t1.schoolnum_DPS
  /OUTFILE FILE=*.


DATASET CLOSE LEADleaders.




*NOW ADD COLLABORATE SURVEY 

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/DPS Data Files/Collaborate results 1415 Prin and AP.xlsx'
  /SHEET=name 'Principals'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet33 WINDOW=FRONT.


FREQUENCIES VARIABLES=Network
  /ORDER=ANALYSIS.



RENAME VARIABLES @1415SPFSchNum = schoolnum_SPF.

DATASET ACTIVATE DataSet33.
FREQUENCIES VARIABLES=schoolnum_SPF
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=schoolnum_SPF School
  /ORDER=ANALYSIS.






DATASET ACTIVATE DataSet33.
DATASET DECLARE LEADcollabRTE.
SORT CASES BY schoolnum_SPF.
AGGREGATE
  /OUTFILE='LEADcollabRTE'
  /PRESORTED
  /BREAK=schoolnum_SPF
  /Change_mean=MEAN(Change) 
  /CommPartnership_mean=MEAN(CommPartnership) 
  /EncouragesParents_mean=MEAN(EncouragesParents) 
  /EngagesParents_mean=MEAN(EngagesParents) 
  /Diversity_mean=MEAN(Diversity) 
  /ModelsValues_mean=MEAN(ModelsValues) 
  /Feedback_mean=MEAN(Feedback) 
  /RemainsPositive_mean=MEAN(RemainsPositive) 
  /Trust_mean=MEAN(Trust) 
  /TrustsMe_mean=MEAN(TrustsMe) 
  /ValuesStudents_mean=MEAN(ValuesStudents) 
  /CelebratesAchievements_mean=MEAN(CelebratesAchievements) 
  /Accessibility_mean=MEAN(Accessibility) 
  /Recognition_mean=MEAN(Recognition) 
  /ValuesMe_mean=MEAN(ValuesMe) 
  /ResolvesConflict_mean=MEAN(ResolvesConflict) 
  /MotivatesMe_mean=MEAN(MotivatesMe) 
  /LeveragesData_mean=MEAN(LeveragesData) 
  /Coaching_mean=MEAN(Coaching) 
  /PromotesTechnology_mean=MEAN(PromotesTechnology) 
  /EnglishAcquisition_mean=MEAN(EnglishAcquisition) 
  /Standards_mean=MEAN(Standards) 
  /PrioritizesInstruction_mean=MEAN(PrioritizesInstruction) 
  /PrioritizesPlanning_mean=MEAN(PrioritizesPlanning) 
  /SolvesProblems_mean=MEAN(SolvesProblems) 
  /SStaffComm_mean=MEAN(SStaffComm) 
  /SupportsDiscipline_mean=MEAN(SupportsDiscipline) 
  /Visibility_mean=MEAN(Visibility) 
  /ChallengeStatusQuo_mean=MEAN(ChallengeStatusQuo) 
  /DifficultDecisions_mean=MEAN(DifficultDecisions) 
  /ManagesPerformance_mean=MEAN(ManagesPerformance) 
  /DistributesResponsibility_mean=MEAN(DistributesResponsibility) 
  /PassionforLearning_mean=MEAN(PassionforLearning) 
  /ClosesGaps_mean=MEAN(ClosesGaps) 
  /Effectiveness_mean=MEAN(Effectiveness) 
  /CommPartnership_A_mean=MEAN(CommPartnership_A) 
  /EncouragesParents_A_mean=MEAN(EncouragesParents_A) 
  /EngagesParents_A_mean=MEAN(EngagesParents_A) 
  /Diversity_A_mean=MEAN(Diversity_A) 
  /ModelsValues_A_mean=MEAN(ModelsValues_A) 
  /Feedback_A_mean=MEAN(Feedback_A) 
  /RemainsPositive_A_mean=MEAN(RemainsPositive_A) 
  /Trust_A_mean=MEAN(Trust_A) 
  /TrustsMe_A_mean=MEAN(TrustsMe_A) 
  /ValuesStudents_A_mean=MEAN(ValuesStudents_A) 
  /CelebratesAchievements_A_mean=MEAN(CelebratesAchievements_A) 
  /Accessibility_A_mean=MEAN(Accessibility_A) 
  /Recognition_A_mean=MEAN(Recognition_A) 
  /ValuesMe_A_mean=MEAN(ValuesMe_A) 
  /ResolvesConflict_A_mean=MEAN(ResolvesConflict_A) 
  /MotivatesMe_A_mean=MEAN(MotivatesMe_A) 
  /LeveragesData_A_mean=MEAN(LeveragesData_A) 
  /Coaching_A_mean=MEAN(Coaching_A) 
  /PromotesTechnology_A_mean=MEAN(PromotesTechnology_A) 
  /EnglishAcquisition_A_mean=MEAN(EnglishAcquisition_A) 
  /Standards_A_mean=MEAN(Standards_A) 
  /PrioritizesInstruction_A_mean=MEAN(PrioritizesInstruction_A) 
  /PrioritizesPlanning_A_mean=MEAN(PrioritizesPlanning_A) 
  /SolvesProblems_A_mean=MEAN(SolvesProblems_A) 
  /SStaffComm_A_mean=MEAN(SStaffComm_A) 
  /SupportsDiscipline_A_mean=MEAN(SupportsDiscipline_A) 
  /Visibility_A_mean=MEAN(Visibility_A) 
  /ChallengeStatusQuo_A_mean=MEAN(ChallengeStatusQuo_A) 
  /DifficultDecisions_A_mean=MEAN(DifficultDecisions_A) 
  /ManagesPerformance_A_mean=MEAN(ManagesPerformance_A) 
  /DistributesResponsibility_A_mean=MEAN(DistributesResponsibility_A) 
  /PassionforLearning_A_mean=MEAN(PassionforLearning_A) 
  /ClosesGaps_A_mean=MEAN(ClosesGaps_A) 
  /Effectiveness_A_mean=MEAN(Effectiveness_A)
  /N_CollabRTE=N.


DATASET ACTIVATE LEADcollabRTE.


DATASET ACTIVATE  DataSet30.

SORT CASES BY schoolnum_SPF(A).



*RENAME ALL VARIABLES IN THIS FILE WITH 1314 TAG/SUFFIX


DATASET ACTIVATE DataSet30.
STAR JOIN
  /SELECT t0.schoolnum_DPS, t0.CDESchNum, t0.SchName, t0.SPFSchName, t0.Classification, 
    t0.Schoollevel, t0.GISRegion, t0.ISRegion, t0.CurrentConfig, t0.FinalConfig, t0.SchoolStartDate, 
    t0.Principal, t0.IS, t0.GovType1415, t0.EdLevel1415, t0.SPFRating1314, t0.TNLI1415, 
    t0.HighNeeds1415, t0.PrincipalYRBuilding1415, t0.TNLIDummy1415, t0.TotalSchoolN, t0.Asian, 
    t0.AmericanIndian, t0.Black, t0.Hispanic, t0.White, t0.NativeHawaiian, t0.TwoorMore, t0.Minority, 
    t0.ELL, t0.Exited, t0.NonELL, t0.FreeorReduced, t0.SPED, t0.@GT, t0.MobilityRate, t0.Female, 
    t0.TitleI, t0.DPSID, t0.EmployeeName, t0.Gender, t0.GenderDich, t0.RaceEth, t0.RaceEthDich, t0.Age, 
    t0.Title, t0.Prin, t0.School, t0.Network, t0.Manager, t0.AppraisalForm, t0.OverallRating, 
    t0.OverallDich, t0.StudentGrowth201314, t0.SGCatClean, t0.CEL1, t0.CEL2, t0.IL1, t0.IL2, t0.IL3, 
    t0.HRL1, t0.HRL2, t0.SL1, t0.SL2, t0.OL, t0.CL, t0.PGP1, t0.PGP2, t0.CEL1num, t0.CEL2num, 
    t0.IL1num, t0.IL2num, t0.IL3num, t0.HRL1num, t0.HRL2num, t0.SL1num, t0.SL2num, t0.OLnum, t0.CLnum, 
    t0.PPAverage, t0.PPRecommended, t0.MatrixCat, t0.AppropriateRating, t0.HighorLow, t0.PPenteredPrin, 
    t0.PPEnteredAP, t0.PPEntered, t0.InitialThoughtsPrinOverall, t0.InitialThoughtsMatch, t0.APIL1, 
    t0.APIL3, t0.APHRL1, t0.APSL1, t0.APOL, t0.APIL1Match, t0.APIL3Match, t0.APHRL1Match, 
    t0.APSL1Match, t0.APOLMatch, t0.MYCEL1, t0.MYCEL2, t0.MYIL1, t0.MYIL2, t0.MYIL3, t0.MYHRL1, 
    t0.MYHRL2, t0.MYSL1, t0.MYSL2, t0.MYOL, t0.MYCL, t0.MYPPAvg, t0.MYRecPPRating, t0.MYCEL1Match, 
    t0.MYCEL2Match, t0.MYIL1Match, t0.MYIL2Match, t0.MYIL3Match, t0.MYHRL1Match, t0.MYHRL2Match, 
    t0.MYSL1Match, t0.MYSL2Match, t0.MYOLMatch, t0.MYCLMatch, t0.MYPPAvgMatch, t0.MYPPRecRatingMatch, 
    t0.MYPPRecRatingHighLow, t0.PrimaryLast, t0.filter_$, t0.PrimaryFirst, t0.CEL1num_mean, 
    t0.CEL2num_mean, t0.IL1num_mean, t0.IL2num_mean, t0.IL3num_mean, t0.HRL1num_mean, t0.HRL2num_mean, 
    t0.SL1num_mean, t0.SL2num_mean, t0.OLnum_mean, t0.CLnum_mean, t0.PPAverage_mean, t1.Change_mean, 
    t1.CommPartnership_mean, t1.EncouragesParents_mean, t1.EngagesParents_mean, t1.Diversity_mean, 
    t1.ModelsValues_mean, t1.Feedback_mean, t1.RemainsPositive_mean, t1.Trust_mean, t1.TrustsMe_mean, 
    t1.ValuesStudents_mean, t1.CelebratesAchievements_mean, t1.Accessibility_mean, t1.Recognition_mean, 
    t1.ValuesMe_mean, t1.ResolvesConflict_mean, t1.MotivatesMe_mean, t1.LeveragesData_mean, 
    t1.Coaching_mean, t1.PromotesTechnology_mean, t1.EnglishAcquisition_mean, t1.Standards_mean, 
    t1.PrioritizesInstruction_mean, t1.PrioritizesPlanning_mean, t1.SolvesProblems_mean, 
    t1.SStaffComm_mean, t1.SupportsDiscipline_mean, t1.Visibility_mean, t1.ChallengeStatusQuo_mean, 
    t1.DifficultDecisions_mean, t1.ManagesPerformance_mean, t1.DistributesResponsibility_mean, 
    t1.PassionforLearning_mean, t1.ClosesGaps_mean, t1.Effectiveness_mean, t1.CommPartnership_A_mean, 
    t1.EncouragesParents_A_mean, t1.EngagesParents_A_mean, t1.Diversity_A_mean, t1.ModelsValues_A_mean, 
    t1.Feedback_A_mean, t1.RemainsPositive_A_mean, t1.Trust_A_mean, t1.TrustsMe_A_mean, 
    t1.ValuesStudents_A_mean, t1.CelebratesAchievements_A_mean, t1.Accessibility_A_mean, 
    t1.Recognition_A_mean, t1.ValuesMe_A_mean, t1.ResolvesConflict_A_mean, t1.MotivatesMe_A_mean, 
    t1.LeveragesData_A_mean, t1.Coaching_A_mean, t1.PromotesTechnology_A_mean, 
    t1.EnglishAcquisition_A_mean, t1.Standards_A_mean, t1.PrioritizesInstruction_A_mean, 
    t1.PrioritizesPlanning_A_mean, t1.SolvesProblems_A_mean, t1.SStaffComm_A_mean, 
    t1.SupportsDiscipline_A_mean, t1.Visibility_A_mean, t1.ChallengeStatusQuo_A_mean, 
    t1.DifficultDecisions_A_mean, t1.ManagesPerformance_A_mean, t1.DistributesResponsibility_A_mean, 
    t1.PassionforLearning_A_mean, t1.ClosesGaps_A_mean, t1.Effectiveness_A_mean, t1.N_CollabRTE
  /FROM * AS t0
  /JOIN 'LEADcollabRTE' AS t1
    ON t0.schoolnum_SPF=t1.schoolnum_SPF
  /OUTFILE FILE=*.


COMPUTE ISCAMP1415=1.
EXECUTE.


SAVE OUTFILE = '1415SchoolLevelMobile.sav'.

*RENAME ALL VARIABLES IN THIS FILE WITH 1415 TAG/SUFFIX

BEGIN PROGRAM.
import spss, spssaux
spssaux.OpenDataFile('/Users/deborah/1415SchoolLevelMobile.sav')
vdict=spssaux.VariableDict()
mylist=vdict.range(start="CDESchNum", end="ISCAMP1415")
nvars = len(mylist)

for i in range(nvars):
    myvar = mylist[i]
    mynewvar = myvar+"_1415"
    spss.Submit(r"""
        rename variables ( %s = %s) .
                        """ %(myvar, mynewvar))
END PROGRAM.



SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/1415 School Level Mobility.sav'
  /COMPRESSED.

****NOW MERGE 1314 AND 1415 SCHOOL LEVEL FILES TOGETHER








GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/1314 School Level Mobility.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.

SORT CASES BY schoolnum_DPS(A).

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/1415 School Level Mobility.sav'.
DATASET NAME DataSet4 WINDOW=FRONT.

SORT CASES BY schoolnum_DPS(A).


DATASET ACTIVATE DataSet3.
STAR JOIN
  /SELECT t0.Year_1314, t0.name_1314, t0.SchEdLevel_1314, t0.TotalSchoolN_1314, t0.Asian_1314, 
    t0.AmericanIndian_1314, t0.Black_1314, t0.Hispanic_1314, t0.White_1314, t0.NativeHawaiian_1314, 
    t0.TwoorMore_1314, t0.Minority_1314, t0.ELL_1314, t0.Exited_1314, t0.NonELL_1314, 
    t0.FreeorReduced_1314, t0.SPED_1314, t0.@GT_1314, t0.MobilityRate_1314, t0.Female_1314, 
    t0.TitleI_1314, t0.Minority4_1314, t0.Minority5_1314, t0.ELLs4_1314, t0.ELLs5_1314, t0.FRL4_1314, 
    t0.FRL5_1314, t0.SPED4_1314, t0.SPED5_1314, t0.@GT4_1314, t0.@GT5_1314, t0.MOBILITY4_1314, 
    t0.MOBILITY5_1314, t0.FEMALE4_1314, t0.FEMALE5_1314, t0.schoolnum_SPF_1314, t0.SPFSchName_1314, 
    t0.DPSSchName_1314, t0.SPFType_1314, t0.SPOT_Growth_PE_1314, t0.SPOT_Growth_PP_1314, 
    t0.SPOT_Growth_Pct_1314, t0.SPOT_Growth_Color_1314, t0.SPOT_Growth_Description_1314, 
    t0.SA_Status_PE_1314, t0.SA_Status_PP_1314, t0.SA_Status_Pct_1314, t0.SA_Status_Color_1314, 
    t0.SA_Status_Description_1314, t0.SES_PE_1314, t0.SES_PP_1314, t0.SES_Pct_1314, t0.SES_Color_1314, 
    t0.SES_Description_1314, t0.PES_PE_1314, t0.PES_PP_1314, t0.PES_Pct_1314, t0.PES_Color_1314, 
    t0.PES_Description_1314, t0.Enroll_PE_1314, t0.Enroll_PP_1314, t0.Enroll_Pct_1314, 
    t0.Enroll_Color_1314, t0.Enroll_Description_1314, t0.PSR_Growth_PE_1314, t0.PSR_Growth_PP_1314, 
    t0.PSR_Growth_Pct_1314, t0.PSR_Growth_Color_1314, t0.PSR_Growth_Description_1314, 
    t0.PSR_Status_PE_1314, t0.PSR_Status_PP_1314, t0.PSR_Status_Pct_1314, t0.PSR_Status_Color_1314, 
    t0.PSR_Status_Description_1314, t0.PSR_PE_1314, t0.PSR_PP_1314, t0.PSR_Pct_1314, t0.PSR_Color_1314, 
    t0.PSR_Description_1314, t0.SPF_Final_PE_1314, t0.SPF_Final_PP_1314, t0.SPF_Final_Pct_1314, 
    t0.SPFColor_1314, t0.SPFDescription_1314, t0.ISCAMP1314_1314, t1.schoolnum_SPF, t1.CDESchNum_1415, 
    t1.SchName_1415, t1.SPFSchName_1415, t1.Classification_1415, t1.Schoollevel_1415, 
    t1.GISRegion_1415, t1.ISRegion_1415, t1.CurrentConfig_1415, t1.FinalConfig_1415, 
    t1.SchoolStartDate_1415, t1.Principal_1415, t1.IS_1415, t1.GovType1415_1415, t1.EdLevel1415_1415, 
    t1.SPFRating1314_1415, t1.TNLI1415_1415, t1.HighNeeds1415_1415, t1.PrincipalYRBuilding1415_1415, 
    t1.TNLIDummy1415_1415, t1.TotalSchoolN_1415, t1.Asian_1415, t1.AmericanIndian_1415, t1.Black_1415, 
    t1.Hispanic_1415, t1.White_1415, t1.NativeHawaiian_1415, t1.TwoorMore_1415, t1.Minority_1415, 
    t1.ELL_1415, t1.Exited_1415, t1.NonELL_1415, t1.FreeorReduced_1415, t1.SPED_1415, t1.@GT_1415, 
    t1.MobilityRate_1415, t1.Female_1415, t1.TitleI_1415, t1.DPSID_1415, t1.EmployeeName_1415, 
    t1.Gender_1415, t1.GenderDich_1415, t1.RaceEth_1415, t1.RaceEthDich_1415, t1.Age_1415, 
    t1.Title_1415, t1.Prin_1415, t1.School_1415, t1.Network_1415, t1.Manager_1415, 
    t1.AppraisalForm_1415, t1.OverallRating_1415, t1.OverallDich_1415, t1.StudentGrowth201314_1415, 
    t1.SGCatClean_1415, t1.CEL1_1415, t1.CEL2_1415, t1.IL1_1415, t1.IL2_1415, t1.IL3_1415, 
    t1.HRL1_1415, t1.HRL2_1415, t1.SL1_1415, t1.SL2_1415, t1.OL_1415, t1.CL_1415, t1.PGP1_1415, 
    t1.PGP2_1415, t1.CEL1num_1415, t1.CEL2num_1415, t1.IL1num_1415, t1.IL2num_1415, t1.IL3num_1415, 
    t1.HRL1num_1415, t1.HRL2num_1415, t1.SL1num_1415, t1.SL2num_1415, t1.OLnum_1415, t1.CLnum_1415, 
    t1.PPAverage_1415, t1.PPRecommended_1415, t1.MatrixCat_1415, t1.AppropriateRating_1415, 
    t1.HighorLow_1415, t1.PPenteredPrin_1415, t1.PPEnteredAP_1415, t1.PPEntered_1415, 
    t1.InitialThoughtsPrinOverall_1415, t1.InitialThoughtsMatch_1415, t1.APIL1_1415, t1.APIL3_1415, 
    t1.APHRL1_1415, t1.APSL1_1415, t1.APOL_1415, t1.APIL1Match_1415, t1.APIL3Match_1415, 
    t1.APHRL1Match_1415, t1.APSL1Match_1415, t1.APOLMatch_1415, t1.MYCEL1_1415, t1.MYCEL2_1415, 
    t1.MYIL1_1415, t1.MYIL2_1415, t1.MYIL3_1415, t1.MYHRL1_1415, t1.MYHRL2_1415, t1.MYSL1_1415, 
    t1.MYSL2_1415, t1.MYOL_1415, t1.MYCL_1415, t1.MYPPAvg_1415, t1.MYRecPPRating_1415, 
    t1.MYCEL1Match_1415, t1.MYCEL2Match_1415, t1.MYIL1Match_1415, t1.MYIL2Match_1415, 
    t1.MYIL3Match_1415, t1.MYHRL1Match_1415, t1.MYHRL2Match_1415, t1.MYSL1Match_1415, 
    t1.MYSL2Match_1415, t1.MYOLMatch_1415, t1.MYCLMatch_1415, t1.MYPPAvgMatch_1415, 
    t1.MYPPRecRatingMatch_1415, t1.MYPPRecRatingHighLow_1415, t1.PrimaryLast_1415, t1.filter_$_1415, 
    t1.PrimaryFirst_1415, t1.CEL1num_mean_1415, t1.CEL2num_mean_1415, t1.IL1num_mean_1415, 
    t1.IL2num_mean_1415, t1.IL3num_mean_1415, t1.HRL1num_mean_1415, t1.HRL2num_mean_1415, 
    t1.SL1num_mean_1415, t1.SL2num_mean_1415, t1.OLnum_mean_1415, t1.CLnum_mean_1415, 
    t1.PPAverage_mean_1415, t1.Change_mean_1415, t1.CommPartnership_mean_1415, 
    t1.EncouragesParents_mean_1415, t1.EngagesParents_mean_1415, t1.Diversity_mean_1415, 
    t1.ModelsValues_mean_1415, t1.Feedback_mean_1415, t1.RemainsPositive_mean_1415, t1.Trust_mean_1415, 
    t1.TrustsMe_mean_1415, t1.ValuesStudents_mean_1415, t1.CelebratesAchievements_mean_1415, 
    t1.Accessibility_mean_1415, t1.Recognition_mean_1415, t1.ValuesMe_mean_1415, 
    t1.ResolvesConflict_mean_1415, t1.MotivatesMe_mean_1415, t1.LeveragesData_mean_1415, 
    t1.Coaching_mean_1415, t1.PromotesTechnology_mean_1415, t1.EnglishAcquisition_mean_1415, 
    t1.Standards_mean_1415, t1.PrioritizesInstruction_mean_1415, t1.PrioritizesPlanning_mean_1415, 
    t1.SolvesProblems_mean_1415, t1.SStaffComm_mean_1415, t1.SupportsDiscipline_mean_1415, 
    t1.Visibility_mean_1415, t1.ChallengeStatusQuo_mean_1415, t1.DifficultDecisions_mean_1415, 
    t1.ManagesPerformance_mean_1415, t1.DistributesResponsibility_mean_1415, 
    t1.PassionforLearning_mean_1415, t1.ClosesGaps_mean_1415, t1.Effectiveness_mean_1415, 
    t1.CommPartnership_A_mean_1415, t1.EncouragesParents_A_mean_1415, t1.EngagesParents_A_mean_1415, 
    t1.Diversity_A_mean_1415, t1.ModelsValues_A_mean_1415, t1.Feedback_A_mean_1415, 
    t1.RemainsPositive_A_mean_1415, t1.Trust_A_mean_1415, t1.TrustsMe_A_mean_1415, 
    t1.ValuesStudents_A_mean_1415, t1.CelebratesAchievements_A_mean_1415, t1.Accessibility_A_mean_1415, 
    t1.Recognition_A_mean_1415, t1.ValuesMe_A_mean_1415, t1.ResolvesConflict_A_mean_1415, 
    t1.MotivatesMe_A_mean_1415, t1.LeveragesData_A_mean_1415, t1.Coaching_A_mean_1415, 
    t1.PromotesTechnology_A_mean_1415, t1.EnglishAcquisition_A_mean_1415, t1.Standards_A_mean_1415, 
    t1.PrioritizesInstruction_A_mean_1415, t1.PrioritizesPlanning_A_mean_1415, 
    t1.SolvesProblems_A_mean_1415, t1.SStaffComm_A_mean_1415, t1.SupportsDiscipline_A_mean_1415, 
    t1.Visibility_A_mean_1415, t1.ChallengeStatusQuo_A_mean_1415, t1.DifficultDecisions_A_mean_1415, 
    t1.ManagesPerformance_A_mean_1415, t1.DistributesResponsibility_A_mean_1415, 
    t1.PassionforLearning_A_mean_1415, t1.ClosesGaps_A_mean_1415, t1.Effectiveness_A_mean_1415, 
    t1.N_CollabRTE_1415, t1.ISCAMP1415_1415
  /FROM * AS t0
  /JOIN 'DataSet4' AS t1
    ON t0.schoolnum_DPS=t1.schoolnum_DPS
  /OUTFILE FILE=*.






SAVE OUTFILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/Mobility Data/LEAP Techer Mobility 1314-1415 Level 2.sav'
  /COMPRESSED.