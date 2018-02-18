*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding college-preparation trends at CA public K-12 schools
Dataset Name: cde_2014_analytic_file created in external file
STAT6250-01_w18-team-1_project2_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets cde_2014_analytic_file,
  cde_2014_analytic_file_sort_frpm, and cde_2014_analytic_file_sort_sat;
%include '.\STAT6250-01_w18-team-1_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top three ethnicities that experienced the biggest increase in “Enrollment” between AY1999-2000 and AY2000-2010?'
;

title2
'Rationale: This should help identify the trend of diversity at California schools over the decade, so the school programs should be designed properly with the diversity of race.'
;

footnote1
"I"
;

*
Note: This compares the column "Enrollment" from enr99
to the column of the same name from enr09.
Methodology: When combining enr99 with enr09 during data preparation,
take the difference of values of "Enrollment" for each
school and create a new variable called enroll_change_1999_to_2009. Then,
use proc sort to create a temporary sorted table in descending by
enroll_change_1999_to_2009. Finally, use proc print here to display the
first five rows of the sorted dataset.
Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
        data=enr_dropout_analytic_file_sort_enr(obs=5)
    ;
    id
        CDS_Code
    ;
    var
        enroll_change_1999_to_2009
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top three grades that experienced the biggest increase in Dropouts between AY1999-2000 and AY2000-2010?'
;

title2
'Rationale: This should help identify what grades to consider for new outreach based upon increasing in dropouts.' 
;
footnote1
"I"
;

*
Note: This compares the column "Enrollment" from enr99
to the column of the same name from enr09.
Methodology: When combining enr99 with enr09 during data preparation,
take the difference of values of "Enrollment" for each
school and create a new variable called enroll_change_1999_to_2009. Then,
use proc sort to create a temporary sorted table in descending by
enroll_change_1999_to_2009. Finally, use proc print here to display the
first five rows of the sorted dataset.
Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
        data=enr_dropout_analytic_file_sort_enr(obs=5)
    ;
    id
        CDS_Code
    ;
    var
        enroll_change_1999_to_2009
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How does the proportion of dropouts in terms of gender change between AY1999-2000 and AY2000-2010?'.
;
title2
"Rationale: This should help identify which gender is more likely to drop out schools and thus necessary outreach should be providedr"
;

footnote1
"I"
;


*
Note: This compares the column "Enrollment" from enr99
to the column of the same name from enr09.
Methodology: When combining enr99 with enr09 during data preparation,
take the difference of values of "Enrollment" for each
school and create a new variable called enroll_change_1999_to_2009. Then,
use proc sort to create a temporary sorted table in descending by
enroll_change_1999_to_2009. Finally, use proc print here to display the
first five rows of the sorted dataset.
Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
        data=enr_dropout_analytic_file_sort_enr(obs=5)
    ;
    id
        CDS_Code
    ;
    var
        enroll_change_1999_to_2009
    ;
run;

title;
footnote;
