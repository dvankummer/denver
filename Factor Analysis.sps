2014-15 LEAP FACTOR ANALYSIS WITH PRINCIPAL AXIS FACTORING (PAF)


************************************************
*****************PRELIMINARY ANALYSIS*********
************************************************


*FIRST GRAB LEAP MASTERFILE

GET DATA /TYPE=XLSX
  /FILE='/Users/deborah/inSync Share/LEAP Data/LEAP 2014-15/Data Files/Final_Merge_7_28_15.xlsx'
  /SHEET=name '1415 FINAL LEAP'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.



*RENAME SOME VARIABLES HERE

RENAME VARIABLES  
P1Score = P1 
P2Score = P2
P3Score = P3
P4Score = P4
P5Score = P5 
P6Score = P6.



*CHECK DISTRIBUTIONS AND PARAMETERS

DESCRIPTIVES VARIABLES=LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6
  /STATISTICS=MEAN STDDEV VARIANCE RANGE MIN MAX KURTOSIS SKEWNESS.


GRAPH
  /HISTOGRAM(NORMAL)=LE1.

GRAPH
  /HISTOGRAM(NORMAL)=LE2.

GRAPH
  /HISTOGRAM(NORMAL)=LE3.

GRAPH
  /HISTOGRAM(NORMAL)=LE4.



GRAPH
  /HISTOGRAM(NORMAL)= I1.

GRAPH
  /HISTOGRAM(NORMAL)=I2.

GRAPH
  /HISTOGRAM(NORMAL)=I3.

GRAPH
  /HISTOGRAM(NORMAL)=I4.

GRAPH
  /HISTOGRAM(NORMAL)=I5.

GRAPH
  /HISTOGRAM(NORMAL)=I6.

GRAPH
  /HISTOGRAM(NORMAL)=I7.

GRAPH
  /HISTOGRAM(NORMAL)=I8.




GRAPH
  /HISTOGRAM(NORMAL)=P1. 

GRAPH
  /HISTOGRAM(NORMAL)=P2.

GRAPH
  /HISTOGRAM(NORMAL)=P3.

GRAPH
  /HISTOGRAM(NORMAL)=P4.

GRAPH
  /HISTOGRAM(NORMAL)=P5.

GRAPH
  /HISTOGRAM(NORMAL)=P6.



CORRELATIONS
  /VARIABLES=LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.



         CORRELATIONS
           /VARIABLES=LE1 LE2 LE3 LE4 
           /PRINT=TWOTAIL NOSIG
           /MISSING=PAIRWISE.

         CORRELATIONS
           /VARIABLES= I1 I2 I3 I4 I5 I6 I7 I8 
           /PRINT=TWOTAIL NOSIG
           /MISSING=PAIRWISE.


         CORRELATIONS
           /VARIABLES=P1 P2 P3 P4 P5 P6
           /PRINT=TWOTAIL NOSIG
           /MISSING=PAIRWISE.

*CHECK FOR MULTICOLINEARITY VIA THE VARIANCE INFLATION FACTOR VIF


*COMPUTE CASE NUMBER (OR COUNT) VARIALBE TO REGRESS PREDICTORS ON.

COMPUTE caseno=$CASENUM.
FORMAT caseno (F9.0).
EXECUTE. 

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT caseno
  /METHOD=ENTER LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6
  /SAVE LEVER.


*INSPECT THE COLLINEARITY DIAGNOSTICS
*NONE OF THE ITEM VIH EXCEED THE VALUE OF 10, THEREFORE MULTICOLINEARITY IS NOT A CONCERN!!!!








************************************************
*****************PRIMARY ANALYSIS************
USING PRINCIPAL AXIS FACTORING
OBLIQUE ROTATION, DIRECT QUARTIMIN
************************************************
************************************************

FACTOR
  /VARIABLES LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6
  /MISSING LISTWISE 
  /ANALYSIS LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6
  /PRINT INITIAL EXTRACTION ROTATION
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(3) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION QUARTIMAX
  /METHOD=CORRELATION.




************************************
PARALELL ANALYSIS
1/3 CRITERIA USED TO DICATE HOW MANY FACTORS TO EXTRACT
DETERMINES THE STATISTICALLY SIGNIFICANT EIGENVALUES
https://people.ok.ubc.ca/brioconn/nfactors/rawpar.sps
************************************
SEE ALSO THIS CODE IS FROM FABRIGAR AND WEGENER (2012)
BUT THE CODE IS FROM THE SUPPLEMENTAL TEXT
************************************
************************************


* Parallel Analysis Program For Raw Data and Data Permutations.

* To run this program you need to first specify the data
  for analysis and then RUN, all at once, the commands
  from the MATRIX statement to the END MATRIX statement.

* This program conducts parallel analyses on data files in which
  the rows of the data matrix are cases/individuals and the
  columns are variables;  Data are read/entered into the program
  using the GET command (see the GET command below);  The GET 
  command reads an SPSS data file, which can be either the 
  current, active SPSS data file or a previously saved data file;
  A valid filename/location must be specified on the GET command;
  A subset of variables for the analyses can be specified by using
  the "/ VAR =" subcommand with the GET statement;  There can be
  no missing values.

* You must also specify:
  -- the # of parallel data sets for the analyses;
  -- the desired percentile of the distribution and random
     data eigenvalues;
  -- whether principal components analyses or principal axis/common
     factor analysis are to be conducted, and
  -- whether normally distributed random data generation or 
     permutations of the raw data set are to be used in the
     parallel analyses.

* Permutations of the raw data set can be time consuming;
  Each parallel data set is based on column-wise random shufflings
  of the values in the raw data matrix using Castellan's (1992, 
  BRMIC, 24, 72-77) algorithm; The distributions of the original 
  raw variables are exactly preserved in the shuffled versions used
  in the parallel analyses; Permutations of the raw data set are
  thus highly accurate and most relevant, especially in cases where
  the raw data are not normally distributed or when they do not meet
  the assumption of multivariate normality (see Longman & Holden,
  1992, BRMIC, 24, 493, for a Fortran version); If you would
  like to go this route, it is perhaps best to (1) first run a 
  normally distributed random data generation parallel analysis to
  familiarize yourself with the program and to get a ballpark
  reference point for the number of factors/components;
  (2) then run a permutations of the raw data parallel analysis
  using a small number of datasets (e.g., 100), just to see how long
  the program takes to run; then (3) run a permutations of the raw
  data parallel analysis using the number of parallel data sets that
  you would like use for your final analyses; 1000 datasets are 
  usually sufficient, although more datasets should be used if
  there are close calls.


* These next commands generate artificial raw data 
  (500 cases) that can be used for a trial-run of
  the program, instead of using your own raw data; 
  Just select and run this whole file; However, make sure to
  delete the artificial data commands before attempting to
  run your own data.




set mxloops=9000 printback=off width=80  seed = 1953125.
matrix.

* Enter the name/location of the data file for analyses after "FILE =";
  If you specify "FILE = *", then the program will read the current,
  active SPSS data file; Alternatively, enter the name/location
  of a previously saved SPSS data file instead of "*";
  you can use the "/ VAR =" subcommand after "/ missing=omit"
  subcommand to select variables for the analyses.
GET raw / FILE = * / missing=omit / VAR = LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 P1 P2 P3 P4 P5 P6.

* Enter the desired number of parallel data sets here.
compute ndatsets = 1000.

* Enter the desired percentile here.
compute percent  = 95.

* Enter either
  1 for principal components analysis, or
  2 for principal axis/common factor analysis.
compute kind = 2 .

* Enter either
  1 for normally distributed random data generation parallel analysis, or
  2 for permutations of the raw data set.
compute randtype = 2.


****************** End of user specifications. ******************

compute ncases   = nrow(raw). 
compute nvars    = ncol(raw).

* principal components analysis & random normal data generation.
do if (kind = 1 and randtype = 1).
compute nm1 = 1 / (ncases-1).
compute vcv = nm1 * (sscp(raw) - ((t(csum(raw))*csum(raw))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute realeval = eval(d * vcv * d).
compute evals = make(nvars,ndatsets,-9999).
loop #nds = 1 to ndatsets.
compute x = sqrt(2 * (ln(uniform(ncases,nvars)) * -1) ) &*
            cos(6.283185 * uniform(ncases,nvars) ).
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute evals(:,#nds) = eval(d * vcv * d).
end loop.
end if.

* principal components analysis & raw data permutation.
do if (kind = 1 and randtype = 2).
compute nm1 = 1 / (ncases-1).
compute vcv = nm1 * (sscp(raw) - ((t(csum(raw))*csum(raw))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute realeval = eval(d * vcv * d).
compute evals = make(nvars,ndatsets,-9999).
loop #nds = 1 to ndatsets.
compute x = raw.
loop #c = 1 to nvars.
loop #r = 1 to (ncases -1).
compute k = trunc( (ncases - #r + 1) * uniform(1,1) + 1 )  + #r - 1.
compute d = x(#r,#c).
compute x(#r,#c) = x(k,#c).
compute x(k,#c) = d.
end loop.
end loop.
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute evals(:,#nds) = eval(d * vcv * d).
end loop.
end if.

* PAF/common factor analysis & random normal data generation.
do if (kind = 2 and randtype = 1).
compute nm1 = 1 / (ncases-1).
compute vcv = nm1 * (sscp(raw) - ((t(csum(raw))*csum(raw))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute cr = (d * vcv * d).
compute smc = 1 - (1 &/ diag(inv(cr)) ).
call setdiag(cr,smc).
compute realeval = eval(cr).
compute evals = make(nvars,ndatsets,-9999).
compute nm1 = 1 / (ncases-1).
loop #nds = 1 to ndatsets.
compute x = sqrt(2 * (ln(uniform(ncases,nvars)) * -1) ) &*
            cos(6.283185 * uniform(ncases,nvars) ).
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute r = d * vcv * d.
compute smc = 1 - (1 &/ diag(inv(r)) ).
call setdiag(r,smc).
compute evals(:,#nds) = eval(r).
end loop.
end if.

* PAF/common factor analysis & raw data permutation.
do if (kind = 2 and randtype = 2).
compute nm1 = 1 / (ncases-1).
compute vcv = nm1 * (sscp(raw) - ((t(csum(raw))*csum(raw))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute cr = (d * vcv * d).
compute smc = 1 - (1 &/ diag(inv(cr)) ).
call setdiag(cr,smc).
compute realeval = eval(cr).
compute evals = make(nvars,ndatsets,-9999).
compute nm1 = 1 / (ncases-1).
loop #nds = 1 to ndatsets.
compute x = raw.
loop #c = 1 to nvars.
loop #r = 1 to (ncases -1).
compute k = trunc( (ncases - #r + 1) * uniform(1,1) + 1 )  + #r - 1.
compute d = x(#r,#c).
compute x(#r,#c) = x(k,#c).
compute x(k,#c) = d.
end loop.
end loop.
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute r = d * vcv * d.
compute smc = 1 - (1 &/ diag(inv(r)) ).
call setdiag(r,smc).
compute evals(:,#nds) = eval(r).
end loop.
end if.

* identifying the eigenvalues corresponding to the desired percentile.
compute num = rnd((percent*ndatsets)/100).
compute results = { t(1:nvars), realeval, t(1:nvars), t(1:nvars) }.
loop #root = 1 to nvars.
compute ranks = rnkorder(evals(#root,:)).
loop #col = 1 to ndatsets.
do if (ranks(1,#col) = num).
compute results(#root,4) = evals(#root,#col).
break.
end if.
end loop.
end loop.
compute results(:,3) = rsum(evals) / ndatsets.

print /title="PARALLEL ANALYSIS:".
do if (kind = 1 and randtype = 1).
print /title="Principal Components & Random Normal Data Generation".
else if (kind = 1 and randtype = 2).
print /title="Principal Components & Raw Data Permutation".
else if (kind = 2 and randtype = 1).
print /title="PAF/Common Factor Analysis & Random Normal Data Generation".
else if (kind = 2 and randtype = 2).
print /title="PAF/Common Factor Analysis & Raw Data Permutation".
end if.
compute specifs = {ncases; nvars; ndatsets; percent}.
print specifs /title="Specifications for this Run:"
 /rlabels="Ncases" "Nvars" "Ndatsets" "Percent".
print results 
 /title="Raw Data Eigenvalues, & Mean & Percentile Random Data Eigenvalues"
 /clabels="Root" "Raw Data" "Means" "Prcntyle"  /format "f12.6".

do if   (kind = 2).
print / space = 1.
print /title="Warning: Parallel analyses of adjusted correlation matrices".
print /title="eg, with SMCs on the diagonal, tend to indicate more factors".
print /title="than warranted (Buja, A., & Eyuboglu, N., 1992, Remarks on parallel".
print /title="analysis. Multivariate Behavioral Research, 27, 509-540.).".
print /title="The eigenvalues for trivial, negligible factors in the real".
print /title="data commonly surpass corresponding random data eigenvalues".
print /title="for the same roots. The eigenvalues from parallel analyses".
print /title="can be used to determine the real data eigenvalues that are".
print /title="beyond chance, but additional procedures should then be used".
print /title="to trim trivial factors.".
print / space = 2.
print /title="Principal components eigenvalues are often used to determine".
print /title="the number of common factors. This is the default in most".
print /title="statistical software packages, and it is the primary practice".
print /title="in the literature. It is also the method used by many factor".
print /title="analysis experts, including Cattell, who often examined".
print /title="principal components eigenvalues in his scree plots to determine".
print /title="the number of common factors. But others believe this common".
print /title="practice is wrong. Principal components eigenvalues are based".
print /title="on all of the variance in correlation matrices, including both".
print /title="the variance that is shared among variables and the variances".
print /title="that are unique to the variables. In contrast, principal".
print /title="axis eigenvalues are based solely on the shared variance".
print /title="among the variables. The two procedures are qualitatively".
print /title="different. Some therefore claim that the eigenvalues from one".
print /title="extraction method should not be used to determine".
print /title="the number of factors for the other extraction method.".
print /title="The issue remains neglected and unsettled.".
end if.

compute root      = results(:,1).
compute rawdata = results(:,2).
compute percntyl = results(:,4).

save results /outfile= 'screedata.sav' / var=root rawdata means percntyl .

end matrix.

* plots the eigenvalues, by root, for the real/raw data and for the random data;
  This command works in SPSS 12, but not in all earlier versions.
GET file= 'screedata.sav'.
TSPLOT VARIABLES= rawdata means percntyl /ID= root /NOLOG.




*MANUALLY MAP THE SCREE PLOT WITH REDUCED CORRELATION MATRIX

DATASET ACTIVATE screedata.

RENAME VARIABLES rawdata=EIGENVALUE.


COMPUTE FACTOR=$CASENUM.
FORMAT FACTOR (F2.0).
EXECUTE. 



GRAPH
  /SCATTERPLOT(BIVAR)=FACTOR WITH EIGENVALUE
  /MISSING=LISTWISE.





FA WITH DISAGGREGATED LEAP RATING'
************************************************
*****************PRIMARY ANALYSIS************
USING PRINCIPAL AXIS FACTORING
OBLIQUE ROTATION, DIRECT QUARTIMIN
************************************************
************************************************

GET
  FILE='/Users/deborah/inSync Share/Shared Folders/DPS/LEAP Data/LEAP 2014-15/Data Files/SPSS Data Files/OBSERVATIONS.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.




RENAME VARIABLES  
P1Score = P1 
P2Score = P2
P3Score = P3
P4Score = P4
P5Score = P5 
P6Score = P6.



FACTOR
  /VARIABLES LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 
  /MISSING LISTWISE 
  /ANALYSIS LE1 LE2 LE3 LE4 I1 I2 I3 I4 I5 I6 I7 I8 
  /PRINT INITIAL EXTRACTION ROTATION
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(2) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION QUARTIMAX
  /METHOD=CORRELATION.
