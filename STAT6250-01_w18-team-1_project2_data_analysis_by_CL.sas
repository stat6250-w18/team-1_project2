*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding dropout and enrollment trends at CA public K-12 schools

Dataset Name: cde_2014_analytic_file created in external file
STAT6250-02_s17-team-1_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets cde_2014_analytic_file,
cde_2014_analytic_file_sort_frpm, and cde_2014_analytic_file_sort_sat;
%include '.\STAT6250-02_s17-team-1_project2_data_preparation.sas';


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
""
;

footnote2
""
;

footnote3
""
;

*
Note: 

Methodology: 

Limitations: 

Followup Steps: 
;

proc print
        data=cde_2014_analytic_file_sort_frpm(obs=5)
    ;
    id
        School_Name
    ;
    var
        frpm_rate_change_2014_to_2015
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How has the trend in enrollment among minorities changed over time? How does this compare to majorities?'
;

title2
'Rationale: This would help identify how educational values are changing over time, and if areas with previously low enrollments rate have improved over time.'
;

footnote1
""
;

footnote2
""
;

footnote3
""
;

*
Note: 

Methodology: 

Limitations: 

Followup Steps: 
;

proc freq
        data=cde_2014_analytic_file
    ;
    table
             Percent_Eligible_FRPM_K12
            *PCTGE1500
            / missing norow nocol nopercent
    ;
        where
            not(missing(PCTGE1500))
    ;
    format
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
        PCTGE1500 PCTGE1500_bins.
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the demographic of the districts/counties with the highest dropout rates?'
;

title2
"Rationale: This would help us identify which areas and demographics suffer from the highest dropout rates and could perhaps benefit from additional funding or school programs."
;

footnote1
""
;

footnote2
""
;

footnote3
""
;

*
Note: 

Methodology: 

Limitations: 

Followup Steps: 
;

proc print
        data=cde_2014_analytic_file_sort_sat(obs=10)
    ;
    id
        School_Name
    ;
    var
        excess_sat_takers
    ;
run;

title;
footnote;
