*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding enrollment and dropout trends at CA public K-12 schools

Dataset Name: enr_dropout_analytic_file created in external file
STAT6250-01_w18-team-1_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets enr_analytic_file,
  dropout_analytic_file, and enr_dropout_analytic_file;
%include '.\STAT6250-01_w18-team-1_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the distribution of enrollment in terms of gender? How is the trend in enrollment in terms of gender?'
;

title2
'Rationale: This would help indentify if there is any large bias in enrollment in terms of gender.'
;

footnote1
"From AY1999-2000 to AY2009-2010, the total enrollments for both male and female students increases in absolute numbers."
;

footnote2
"From AY1999-2000 to AY2009-2010, the enrollment rate of male students decreases from 112.28% to 61%"
;

footnote3
"From AY1999-2000 to AY2009-2010, the enrollment rate of female students decreases from 132.96% to 82.60%."
;

footnote4
"The enrollment rate for both genders decrease within the decade, the decrease in enrollment rate for male students is higher than female students."
;

footnote5
"Although total enrollment for both genders increase in absolute numbers within the decade, hence it requires further analysis for reasons for decrease in enrollment rate."
;

*
Note: This compares the column "Gender" from enr99
to the column of the same name from enr09.

Methodology: Aggregate total enrollment and dropouts by year and gender. 
Compute the total enrollment, enrollment rate, total droput,dropout rate out
of total enrollment. Use PROC SORT to create a temporary sorted table in 
ascending by total enrollment, enrollment rate and year. Finally, use 
proc print to display the results by year and gender.

Limitations: The enrollment data would require the population demographics in
regards to sex to provide better insights.

Followup Steps: We need to further analyze the reasons for decrease in 
enrollment rate for both male and female gender within the decade.
;

proc print
        data=enr_rate_tot_gender_sorted_9900
    ;
    id
        year gender
    ;
    var
        total_enr_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
    data=enr_rate_tot_gender_sorted_0910
    ;
    id
        year gender
    ;
    var
        total_enr_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
        data=enr_rate_gender_sorted_9900
    ;
    id
        year gender
    ;
    var
        enr_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
    data=enr_rate_gender_sorted_0910
    ;
    id
        year gender
    ;
    var
        enr_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which ethnicity has the lowest enrollment in California K-12 schools? How is the trend when one compares the enrollment in regards to ethnicity for in 2009-2010? Is there any significant improvement?'
;

title2
'Rationale: This would help in designing outreach programs for enrollmnent targeted at particular ethnicities.'
;

footnote1
"From AY 1999-2000 to AY 2009-2010, the two ethnicites having least enrollments in absolute numbers are: Pacific Islander and American Indian/Alaska Native. Although there has been an increase in enrollment in absolute numbers for both these ethnicities over the decade."
;

footnote2
"As can be seen,in AY 1999-2000, the two ethnicites having least enrollments are: American Indian/Alaska Native, African American/Not Hispanic."
;

footnote3
"As can be seen,in AY 2009-2010, the two ethnicites having least enrollments are: African American/Not Hispanic, Hispanic/Latin."
;

footnote4
"From AY 1999-2000 to AY 2009-2010, for African American/Not Hispanic ethnicity, the enrollment rate has dropped from 90.79 to 48.33"
;

*
Note: This compares the column "ETHNIC" from enr99
to the column of the same name from enr09.

Methodology: Aggregate total enrollment and dropouts by year and ethnic. 
Compute the dropout rate out of total enrollment. Use PROC SORT to create a 
temporary sorted table in ascending by total enrollment and enrollmentrate and 
year. Finally, use proc print to display the results by year and ethnic.

Limitations: The enrollment data would require the population demographics in
regards to ethnicity to provide better insights.

Followup Steps: We need to further analyze why although the enrollment in 
absolute numbers have increased for various ethnicities, what are the possible
reasons for higher dropouts which results in low enrollment rates.
;

proc print
        data=enr_tot_rate_ethnic_sorted_9900
    ;
    id
        year ethnic
    ;
    var
        total_enr_rate
    ;
    format
        YEAR Year_Val. ETHNIC Race_Ethnicity_bins.
	;
run;

proc print
        data=enr_tot_rate_ethnic_sorted_0910
    ;
    id
        year ethnic
    ;
    var
        total_enr_rate
    ;
    format
        YEAR Year_Val. ETHNIC Race_Ethnicity_bins.
	;
run;

proc print
        data=enr_rate_ethnic_sorted_9900
    ;
    id
        year ethnic
    ;
    var
        enr_rate
    ;
    format
        YEAR Year_Val. ETHNIC Race_Ethnicity_bins.
	;
run;

proc print
        data=enr_rate_ethnic_sorted_0910
    ;
    id
        year ethnic
    ;
    var
        enr_rate
    ;
    format
        YEAR Year_Val. ETHNIC Race_Ethnicity_bins.
	;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the distribution of dropouts in terms of gender? How is the trend in dropouts in terms of gender?'
;

title2
"Rationale: This would help indentify if there is any large bias in dropouts in terms of gender"
;

footnote1
"From AY1999-2000 to AY2009-2010, the gap between dropouts for male and female students increases significantly in absolute numbers."
;

footnote2
"From AY1999-2000 to AY2009-2010, the dropout rate of male students increases from 0.89% to 1.65%."
;

footnote3
"From AY1999-2000 to AY2009-2010, the dropout rate of female students increases from 0.75% to 1.21%."
;

footnote4
"The dropout rate for both genders increase within the decade, hence it requires further analysis for reasons for increase in dropouts, especially of male students"
;

*
Note: This compares the column "Gender" from droppouts00
to the column of the same name from droppouts10.

Methodology: Aggregate total enrollment and dropouts by year and gender. 
Compute the total enrollment, enrollment rate, total droput,dropout rate out
of total enrollment. Use PROC SORT to create a temporary sorted table in 
descending by total dropout, dropout rate and year. Finally, use 
proc print to display the results by year and gender.

Limitations: The dropout data would require the population demographics in
regards to sex to provide better insights.

Followup Steps: We need to further analyze the reasons for increase in dropout 
rate for both male and female gender within the decade.
;

proc print
        data=drop_rate_tot_gender_sorted_9900
    ;
    id
        year gender
    ;
    var
        total_drop_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
    data=drop_rate_tot_gender_sorted_0910
    ;
    id
        year gender
    ;
    var
        total_drop_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
        data=drop_rate_gender_sorted_9900
    ;
    id
        year gender
    ;
    var
        drop_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

proc print
    data=drop_rate_gender_sorted_0910
    ;
    id
        year gender
    ;
    var
        drop_rate
    ;
    format
        YEAR Year_Val. GENDER $Gender_bins.
	;
run;

title;
footnote;
