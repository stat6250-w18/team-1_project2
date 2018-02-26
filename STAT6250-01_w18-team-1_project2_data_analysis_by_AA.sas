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


* load external file that generates analytic datasets cde_2014_analytic_file,
  cde_2014_analytic_file_sort_frpm, and cde_2014_analytic_file_sort_sat;
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
"In AY1999-2000, there were 7,010 enrollments for male students and 5950 enrollments for female students"
;

footnote2
"In AY1999-2000, there were 48,557 enrollments for male students and 43,375 enrollments for female students"
;

footnote3
"There has been a significant increase in the number of male and female enrollements in a decade."
;

*
Note: This compares the column "Gender" from enr99
to the column of the same name from enr09.

Methodology: We print the data from enr99 and enr09 using where clause with 
gender=M and gender=F.

Limitations: The enrollment data would require the population demographics in
regards to sex to provide better insights.

Followup Steps: We need to consider the population of males and females for 
better assessment
;

proc sort
    data=enr_dropout_analytic_file
        out=enr_analytic_file_sort_first_M
    ;
    where
        YEAR=9900 and GENDER = 'M'
    ;
    by
        descending ENR_TOTAL
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=enr_analytic_file_sort_first_F
    ;
    where
        YEAR=9900 and GENDER = 'F'
    ;
    by
        descending ENR_TOTAL
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=enr_analytic_file_sort_sec_M
    ;
    where
        YEAR=910 and GENDER = 'M'
    ;
    by
        descending ENR_TOTAL
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=enr_analytic_file_sort_sec_F
    ;
    where
        YEAR=910 and GENDER = 'F'
    ;
    by
        descending ENR_TOTAL
    ;
run;

proc print
    data=enr_analytic_file_sort_first_M(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER ENR_TOTAL
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
    ;
run;

proc print
    data=enr_analytic_file_sort_sec_M(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER ENR_TOTAL 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
    ;
run;

proc print
    data=enr_analytic_file_sort_first_F(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER ENR_TOTAL 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
    ;
run;

proc print
    data=enr_analytic_file_sort_sec_F(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER ENR_TOTAL 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
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
"As can be seen,in AY 1999-2000, the ethnicites having least enrollments are: Asian, American Indian/Alaska Native, Filipino."
;

footnote2
"As can be seen,in AY 1999-2000, the ethnicites having least enrollments are: Asian, American Indian/Alaska Native, Pacific Islander, Filipino."
;

footnote3
"There has been no significant improvement in enrollment in a decade for Asian, American Indian/Alaska Native, Filipino ethnicities."
;

*
Note: This compares the column "ETHNIC" from enr99
to the column of the same name from enr09.

Methodology: We print the data for the top 5 observations with the least 
number of enrollments.

Limitations: The enrollment data would require the population demographics in
regards to ethnicity to provide better insights.
 
Followup Steps: We need to consider the population of various ethnicities 
better assessment
;

proc sort
    data=enr_dropout_analytic_file
        out=enr_drp_analytic_file_sort_first
    ;
    where
        YEAR=9900
    ;
    by
        ENR_TOTAL
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=enr_drp_analytic_file_sort_sec
    ;
    where
        YEAR=910
    ;
    by
        ENR_TOTAL
    ;
run;

proc print
    data=enr_drp_analytic_file_sort_first(obs=5) label
    ; 
    var
        YEAR CDS_CODE ETHNIC ENR_TOTAL
    ; 
    where
        ENR_TOTAL ne . AND ENR_TOTAL ne 0 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. ETHNIC Race_Ethnicity_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
    ;
run;

proc print
    data=enr_drp_analytic_file_sort_sec(obs=5) label
    ; 
    var
        YEAR CDS_CODE ETHNIC ENR_TOTAL 
    ;
    where
        ENR_TOTAL ne . AND ENR_TOTAL ne 0 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. ETHNIC Race_Ethnicity_bins.
    ;
    label
        ENR_TOTAL='Total school enrollment from Kindergarten through grade 12'
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
"In AY1999-2000, there is not much difference between the dropouts between males and female students"
;

footnote2
"In AY2009-2010, the gap of the number of dropouts between males and females increases significantly, with males having higher dropouts in absolute numbers"
;

footnote3
"From AY1999-2000 to AY2009-2010, the dropouts for top 5 observations almost doubles both in case of males and females"
;

footnote4
"We need to further analyze the reasons for increase in dropouts of male students"
;

*
Note: This compares the column "Gender" from droppouts00
to the column of the same name from droppouts10.

Methodology: We print the data from droppouts00 and droppouts10 using 
where clause with gender=M and gender=F.

Limitations: The dropout data would require the population demographics in
regards to sex to provide better insights.

Followup Steps: We need to consider the population of males and females for 
better assessment
;

proc sort
    data=enr_dropout_analytic_file
        out=drp_analytic_file_sort_first_M
    ;
    where
        YEAR=9900 and GENDER = 'M'
    ;
    by
        descending DTOT
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=drp_analytic_file_sort_first_F
    ;
    where
        YEAR=9900 and GENDER = 'F'
    ;
    by
        descending DTOT
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=drp_analytic_file_sort_sec_M
    ;
    where
        YEAR=910 and GENDER = 'M'
    ;
    by
        descending DTOT
    ;
run;

proc sort
    data=enr_dropout_analytic_file
        out=drp_analytic_file_sort_sec_F
    ;
    where
        YEAR=910 and GENDER = 'F'
    ;
    by
        descending DTOT
    ;
run;

proc print
    data=drp_analytic_file_sort_first_M(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER DTOT 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        DTOT='Total dropouts for grades nine through twelve and ungraded secondary'
    ;
run;

proc print
    data=drp_analytic_file_sort_sec_M(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER DTOT 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        DTOT='Total dropouts for grades nine through twelve and ungraded secondary'
    ;
run;

proc print
    data=drp_analytic_file_sort_first_F(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER DTOT 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        DTOT='Total dropouts for grades nine through twelve and ungraded secondary'
    ;
run;

proc print
    data=drp_analytic_file_sort_sec_F(obs=5) label
    ; 
    var
        YEAR CDS_CODE GENDER DTOT 
    ;
    format
        YEAR Year_Val. CDS_CODE BEST30. GENDER $Gender_bins.
    ;
    label
        DTOT='Total dropouts for grades nine through twelve and ungraded secondary'
    ;
run;

title;
footnote;
