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
'Research Question: Which district of California K-12 Schools has the highest enrollment?'
;

title2
'Rationale: This should help identify schools with high number of enrollment so proper resourcces could be provided.'
;

footnote1
"In ay 1999-2000, the districts with the highest number of enrollment are Los Angeles and San Diego."
;

footnote2
"In ay 2009-2010, the districts with the highest number of enrollment are also Los Angeles and San Diego."
;

footnote3
"Across these two points in time, it seems enrollment within Los Angeles district has decreased but enrollment within San Diego has increased slightly."
;

*
Note: This compares the total enrollment by district by year.

Methodology: Merge additional school information to group schools by district. 
Aggregate total enrollment and dropouts by year and district. Use PROC SORT
to create a temporary sorted table in descending by total enrollment.
Finally, use proc print to display the first two rows of the sorted dataset.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
    data=enr_drop_dist_group_9900(obs=2)
		label;
    ;
    id
        District 
        year
    ;
    var
        total_enr
    ;
    format 
		year year_val.
		total_enr comma8.
    ;
	label
		district="School District"
		year="Academic Year"
		total_enr="Total Enrollment"
	;
run;

proc print
    data=enr_drop_dist_group_0910(obs=2)
		label;
    ;
    id
        District 
        year
    ;
    var
        total_enr
    ;
    format 
		year year_val.
		total_enr comma8.
    ;
	label
		district="School District"
		year="Academic Year"
		total_enr="Total Enrollment"
	;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which year has the higher dropout rate?'
;

title2
'Rationale: This should help identify the gap between the two academic year in dropouts, and understand the trend.' 
;

footnote1
"In ay 2009-2010, the dropout rate was 1.4 percent."
;

footnote2
"In ay 1999-2000, the dropout rate was 0.8 percent."
;

footnote3
"The dropout rate of ay 2009-2010 was almost two times higher than the one of ay 1999-2000."
;

footnote4
"Across these two points in time, it seems dropout rate has increased generally."
;

*
Note: This compares the dropout rate by year.

Methodology: Aggregate total enrollment and dropouts by year. Compute the 
dropout rate out of total enrollment. Use PROC SORT to create a temporary 
sorted table in descending by dropout rate and year. Finally, use proc print to display
the results.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
	data= drop_rate_by_year
		label
	;
	format 
		year year_val.
		total_enr comma9.
		total_drop comma8.
		dropout_rate percent10.2
    ;
	label
		district="School District"
		year="Academic Year"
		total_enr="Total Enrollment"
		total_drop="Total Dropout"
		dropout_rate="Dropout Rate"
	;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which ethnicity has the highest dropout rate?'.
;
title2
"Rationale: This should help identify which ethnicity is more likely to drop out schools and thus necessary outreach should be provided."
;

footnote1
"In ay 1999-2000, American Indian/Alaska Native students had the highest dropout rate with nearly 1.2 percent."
;

footnote2
"In ay 2009-2010, African American/Not Hispanic students had the highest dropout rate with nearly 2.1 percent."
;

*
Note: This compares the dropout rate by ethnicity.

Methodology: Aggregate total enrollment and dropouts by year and ethnic. 
Compute the dropout rate out of total enrollment. Use PROC SORT to create a 
temporary sorted table in descending by dropout rate and year. Finally, use 
proc print to display the results by year and ethnic.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
	data=enr_drop_rate_ethnic_sorted_9900
		label
    ;
    id
        year ethnic
    ;
    var
        drop_rate
    ;
    format
        year year_val. 
		ethnic Race_Ethnicity_bins.
		drop_rate percent10.2
	;
	label
		year="Academic Year"
		ethnic="Ethnicity"
		drop_rate="Dropout Rate"
	;
run;

proc print
    data=enr_drop_rate_ethnic_sorted_0910
    ;
    id
        year ethnic
    ;
    var
        drop_rate
    ;
    format
        year year_val. 
		ethnic Race_Ethnicity_bins.
		drop_rate percent10.2
	;
	label
		year="Academic Year"
		ethnic="Ethnicity"
		drop_rate="Dropout Rate"
	;
run;

title;
footnote;
