*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding dropout and enrollment trends at CA public K-12 schools

Dataset Name: enr_dropout_analytic_file created in external file
STAT6250-02_s17-team-1_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets enr_analytic_file,
dropout_analytic_file, enr_dropout_analytic_file, enr_drop_names_eth,
enr_drop_names, enr_drop_agg, enr_drop_pct_min00, enr_drop_pct_min10,
enr_drop_tot_pct, enr_drop_agg_eth, and enr_drop_agg_eth2;
%include '.\STAT6250-01_w18-team-1_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which district has the highest dropout rates among minorities?'
;

title2
'Rationale: This would help us identify districts that might not have the proper educational tools to help minorities to succeed.'
;

footnote1
"From 1999 to 2000, the districts with the highest dropout rates among minorities are California School for the Deaf-Riverside, San Francisco County, Merced County, Sutter County, and Orange County."
;

footnote2
"From 2009 to 2010, the districts with the highest dropout rates among minorities are Inyo County, Lynwood, Nevada County, Golden Plains, and Los Angeles County."
;

footnote3
"Across these two points in time, it seems dropout rate within districts have generally increased."
;

footnote4
"Only districts with over 100 enrollments were examined."
;

*
Note: This compares the total dropout percent by district by year. 

Methodology: Merge additional school information to group schools 
by district. Create dummy variable to flag minority races (non-
White). Aggregate total enrollment and dropouts by year, district,
and minority flag. Compute the percent of minority dropouts out of 
total enrolled. Sort by descending percent of dropouts per year.
Display results with PROC PRINT.

Limitations: Data set does not account for potential re-districting
or addition of new schools in some areas

Followup Steps: For potential next steps, we can take a closer 
examination of select districts and compare the same districts with
high dropout rates over different periods of time.
;

*print first 5 rows of districts in 1999-2000 with over 100 
enrollments and have the highest dropout rate. Add format and labels 
for better readability;
proc print
    data=enr_drop_pct_min00 (obs=5)
        label
    ;
    id
        District 
        year
    ;
    var
        drop_pct
    ;
    format 
        year year_val.
        drop_pct percent10.
    ;
    label
        year="Academic Year"
        district="School District"
        drop_pct="Drop Percentage"
    ;
    where total_enr > 100;
run;

*print first 5 rows of districts in 2009-2010 with over 100 
enrollments and have the highest dropout rate. Add format and labels 
for better readability;
proc print
    data=enr_drop_pct_min10 (obs=5)
        label;
    id
        District 
        year
    ;
    var
        drop_pct
    ;
    format 
        year year_val.
        drop_pct percent10.
    ;
    label
        year="Academic Year"
        district="School District"
        drop_pct="Drop Percentage"
    ;
    where total_enr > 100;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How has enrollment among minorities changed over time? How does this compare to majorities?'
;

title2
'Rationale: This would help identify how educational values are changing over time, and if areas with previously low enrollments rate have improved over time.'
;

footnote1
"Enrollments in 1999 among minorities accounted for 36% of enrollments, and 26% in 2009."
;

footnote2
"Enrollments in 1999 among the White, non-Hispanic ethnicity group accounted for 64% of enrollments, and 74% in 2009."
;

footnote3
"Overall, it seems the share of enrollments among minorities across these two time periods has decreased."
;

*
Note: This looks are enr_pct from the enr_drop_tot_pct data
set.

Methodology: Use PROC SQL to aggregate data by year and ethnic
group. Use DATA step to calculate percentage of enrollments
among ethnicity classes and year. Use PROC PRINT to display
output.

Limitations: This analysis merely examines two points in time.

Followup Steps: Take a look at a more granular level and 
determine whether certain areas have large shifts in 
enrollments among minorities. Can also include more years
of data to look at the trand in enrollment among minorities.
;

*Display aggregated data set that is grouped by ethnic group 
and year to show difference in percentages across these two 
points in time. Add formatting and labels for enhance readability;
proc print 
    data=enr_drop_tot_pct
        label
    ; 
    format 
        year year_val.
        minority minority_val.
	total_enr comma9.
	all comma9.
	enr_pct percent10.
    ;
    label
        year="Academic Year"
        minority="Ethnic Group"
        total_enr="Number Enrolled"
        all="All Students"
        enr_pct="Enrollment Percentage"
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the demographic of the districts/counties with the highest dropout rates in more recent years?'
;

title2
"Rationale: This would help us identify which areas and demographics suffer from the highest dropout rates and could perhaps benefit from additional funding or school programs."
;

footnote1
"Among the districts with the highest droupout rates in 2009-2010, Hispanic or Latino students appear to make up the largest ethnic group."
;

*
Note: Subsetting data from enr_drop_names data set using 
previous output that contains districts with highest dropout
rates for the 2009 to 2010.

Methodology: Format ethnic variable to display actual names.
Use PROC FREQ and information from previous results to 
subset displayed distribution of ethnicity.

Limitations: It appears district level dropout rate might be 
too granular, resulting in low counts.

Followup Steps: Look into aggregating at a higher level, such 
as county.
;

*Display aggregated data set that is grouped by district and 
year to show ethnicity distribution by region. Add formatting
and labels for enhance readability;
proc print 
    data=enr_drop_agg_eth2 
        label
    ;
    format 
        ethnic Race_Ethnicity_bins.
	ethnic_pct percent10.
    ;
    var 
        district 
        ethnic 
        ethnic_pct
    ;
    label
        district="School District"
        ethnic="Ethnicity"
        ethnic_pct="Percent"
    ;
run;

title;
footnote;
