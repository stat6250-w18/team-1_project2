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
'Research Question:	Which district has the highest enrollment?'
;

title2
'Rationale: This should help identify schools with high enrollment so proper resourcces could be provided.'
;

footnote1
"In ay 1999-2000, Los Angeles Unified got the highest number of Enrollment with 702,770 students in total."
;

footnote2
"In ay 2009-2010, Los Angeles Unified also got the highest number of Enrollment with 673,635 students in total."
;

footnote3
"Based on the output, Los Angeles Unified has always been the district that got highest Enrollment."

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

proc sql; create table enr_drop_dist_names as 
    select 
        a.*
	    ,b.District
    from 
        enr_dropout_analytic_file as a
	left join 
        pubschls_raw as b
	on a.cds_code=input(b.cdscode,30.)
    ;
quit;

proc sql; create table enr_drop_dist_group as 
    select
        year
        ,district
	    ,sum(enr_total) as total_enr
		,sum(dtot) as total_drop
    from 
        enr_drop_dist_names
	group by 
        year
        ,district
	;
quit; 

proc sort 
    data=enr_drop_dist_group
    out=enr_drop_dist_group_9900
    ;
    by 
        descending total_enr
    ;
    where year=9900
    ;
run;

proc print
        data=enr_drop_dist_group_9900(obs=2)
    ;
    id
        District 
        year
    ;
    var
        total_enr
    ;
run;

proc sort 
    data=enr_drop_dist_group
    out=enr_drop_dist_group_0910
    ;
    by 
        descending total_enr
    ;
    where year=910
    ;
run;

proc print
        data=enr_drop_dist_group_0910(obs=2)
    ;
    id
        District 
        year
    ;
    var
        total_enr
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

proc sql; create table enr_drop_by_year as 
    select
        year
	    ,sum(enr_total) as total_enr
		,sum(dtot) as total_drop
    from 
        enr_dropout_analytic_file
	group by 
        year
	;
quit; 

data enr_drop_rate;
	set enr_drop_by_year;
	dropout_rate = total_drop/total_enr;
run;

proc sort
	data=enr_drop_rate
	out=drop_rate_by_year
	;
	by
		descending dropout_rate
	;
run;

proc print
	data= drop_rate_by_year
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
"Rationale: This should help identify which ethnicity is more likely to drop out schools and thus necessary outreach should be providedr"
;

footnote1
"In ay 1999-2000, American Indian/Alaska Native students had the highest dropout rate with 1.2 percent."
;

footnote2
"In ay 2009-2010, African American/Not Hispanic students had the highest dropout rate with nearly 2.1 percent."


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

proc sql; create table enr_drop_by_ethnic as 
    select
        year
        ,ethnic
	    	,sum(enr_total) as total_enr
			,sum(dtot) as total_drop
    from 
        enr_dropout_analytic_file
	group by 
        year
        ,ethnic
	;
quit;

data enr_drop_rate_ethnic;
	set enr_drop_by_ethnic;
	drop_rate = total_drop/total_enr;
run;

proc sort 
    data=enr_drop_rate_ethnic 
    out=enr_drop_rate_ethnic_sorted_9900;
    by 
        descending drop_rate
    ;
    where
    	year=9900
    ;
run;

proc print
        data=enr_drop_rate_ethnic_sorted_9900
    ;
    id
        year ethnic
    ;
    var
        drop_rate
    ;
run;

proc sort 
    data=enr_drop_rate_ethnic 
    out=enr_drop_rate_ethnic_sorted_0910
    ;
    by 
        descending drop_rate
    ;
    where
    	year=910
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
run;

title;
footnote;
