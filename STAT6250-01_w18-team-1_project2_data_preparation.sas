*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] enr99
[Dataset Description] School-level enrollment by racial/ethnic designation, 
gender and grade, AY1999-2000
[Experimental Unit Description] California public K-12 schools in AY1999-2000
[Number of Observations] 95,443      
[Number of Features] 20
[Data Source] The file https://www.cde.ca.gov/ds/sd/sd/filesenr.asp
was downloaded and edited to produce file filesenr_1999_2000_edited.xls by 
deleting worksheet "filesenr_1999_2000", reformatting column headers in 
"filesenr_1999_2000" to remove characters disallowed in SAS variable names, 
and setting all cell values to "Text" format
[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsenr98.asp
[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset enr99, 
which is also equivalent to the unique id column CDS_CODE in dataset enr09, 
droppouts00 and droppouts10.
--
[Dataset 2 Name] enr09
[Dataset Description] School-level enrollment by racial/ethnic designation, 
gender and grade, AY2009-2010
[Experimental Unit Description] California public K-12 schools in AY2009-2010
[Number of Observations] 124,715     
[Number of Features] 23
[Data Source] The file https://www.cde.ca.gov/ds/sd/sd/filesenr.asp
was downloaded and edited to produce file filesenr_2009_2010_edited.xls by 
deleting worksheet "filesenr_2009_2010", reformatting column headers in 
"filesenr_1999_2000" to remove characters disallowed in SAS variable names, 
and setting all cell values to "Text" format
[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsenr.asp
[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset enr09, 
which is also equivalent to the unique id column CDS_CODE in dataset enr99, 
droppouts00 and droppouts10.
--
[Dataset 3 Name] droppouts00
[Dataset Description] Dropouts by race/ethnic designation and gender by school,
AY1999-2000
[Experimental Unit Description] California public K-12 schools in AY1999-2000
[Number of Observations] 38,245
[Number of Features] 20
[Data Source] The file https://www.cde.ca.gov/ds/sd/sd/filesdropouts.asp was
downloaded and edited to produce file filesdropouts_1999_2000_edited.xls by 
importing into Excel and setting all cell values to "Text" format
[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsdropouts9808.asp
[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset droppouts00.
--
[Dataset 4 Name] droppouts10
[Dataset Description] Dropouts by race/ethnic designation and gender by school,
AY2009-2010
[Experimental Unit Description] California public K-12 schools in AY2009-2010
[Number of Observations] 55,504
[Number of Features] 20
[Data Source] The file https://www.cde.ca.gov/ds/sd/sd/filesdropouts.asp was
downloaded and edited to produce file filesdropouts_2009_2010_edited.xls by 
importing into Excel and setting all cell values to "Text" format
[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsdropouts.asp
[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset droppouts10.
;


* environmental setup;

* create output formats;

proc format;
    value Race_Ethnicity_bins
        1=" American Indian/Alaska Native"
        2=" Asian"
        3=" Pacific Islander"
        4=" Filipino"
		5=" Hispanic/Latin"
		6=" African American/Not Hispanic"
		7=" White/ Not Hispanic"
		8=" Multiple/No Response"
    ;
    value $Gender_bins
        'F'=" Female"
        'M'=" Male"
    ;
run;


* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesenr_1999_2000_edited.xlsx?raw=true
;
%let inputDataset1Type = XLS;
%let inputDataset1DSN = enr_1999_2000_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesenr_2009_2010_edited.xlsx?raw=true
;
%let inputDataset2Type = XLS;
%let inputDataset2DSN = enr_2009_2010_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesdropouts_1999_2000_edited.xlsx?raw=true
;
%let inputDataset3Type = XLS;
%let inputDataset3DSN = dropout_1999_2000_raw;

%let inputDataset4URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesdropouts_2009_2010_edited.xlsx?raw=true
;
%let inputDataset4Type = XLS;
%let inputDataset4DSN = dropout_2009_2010_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset4DSN.,
    &inputDataset4URL.,
    &inputDataset4Type.
)


* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=enr_1999_2000_raw
        dupout=enr_1999_2000_raw_dups
        out=enr_1999_2000_raw_sorted(where=(not(missing(School_Code))))
    ;
    by
        CDS_CODE
        ETHNIC
        GENDER
    ;
run;
proc sort
        nodupkey
        data=enr_2009_2010_raw
        dupout=enr_2009_2010_raw_dups
        out=enr_2009_2010_raw_sorted
    ;
    by
        CDS_CODE
        ETHNIC
        GENDER
    ;
run;
proc sort
        nodupkey
        data=dropout_1999_2000_raw
        dupout=dropout_1999_2000_raw_dups
        out=dropout_1999_2000_raw_sorted
    ;
    by
        CDS_CODE
		ETHNIC
		GENDER
    ;
run;
proc sort
        nodupkey
        data=dropout_2009_2010_raw
        dupout=dropout_2009_2010_raw_dups
        out=dropout_2009_2010_raw_sorted
    ;
    by
        CDS_CODE
		ETHNIC
		GENDER
    ;
run;


* combine FRPM data vertically, combine composite key values into a primary key
  key, and compute year-over-year change in Percent_Eligible_FRPM_K12,
  retaining all AY2014-15 fields and y-o-y Percent_Eligible_FRPM_K12 change;
data frpm1415_raw_with_yoy_change;
    retain
        CDS_Code
    ;
    length
        CDS_Code $14.
    ;
    set
        frpm1516_raw_sorted(in=ay2015_data_row)
        frpm1415_raw_sorted(in=ay2014_data_row)
    ;
    retain
        Percent_Eligible_FRPM_K12_1516
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
    if
        ay2015_data_row=1
    then
        do;
            Percent_Eligible_FRPM_K12_1516 = Percent_Eligible_FRPM_K12;
        end;
    else if
        ay2014_data_row=1
        and
        Percent_Eligible_FRPM_K12 > 0
        and
        substr(School_Code,1,6) ne "000000"
    then
        do;
            CDS_Code = cats(County_Code,District_Code,School_Code);
            frpm_rate_change_2014_to_2015 =
                Percent_Eligible_FRPM_K12
                -
                Percent_Eligible_FRPM_K12_1516
            ;
            output;
        end;
run;


* build analytic dataset from raw datasets with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data cde_2014_analytic_file;
    retain
        CDS_Code
        School_Name
        Percent_Eligible_FRPM_K12
        frpm_rate_change_2014_to_2015
        PCTGE1500
        excess_sat_takers
    ;
    keep
        CDS_Code
        School_Name
        Percent_Eligible_FRPM_K12
        frpm_rate_change_2014_to_2015
        PCTGE1500
        excess_sat_takers
    ;
    merge
        frpm1415_raw_with_yoy_change
        gradaf15_raw
        sat15_raw(rename=(CDS=CDS_Code PCTGE1500=PCTGE1500_character))
    ;
    by
        CDS_Code
    ;
    if
        not(missing(compress(PCTGE1500_character,'.','kd')))
    then
        do;
            PCTGE1500 = input(PCTGE1500_character,best12.2);
        end;
    else
        do;
            call missing(PCTGE1500);
        end;
    excess_sat_takers = input(NUMTSTTAKR,best12.) - input(TOTAL,best12.);
    if
        not(missing(CDS_Code))
        and
        not(missing(School_Name))
        and
        not(missing(School_Name))
    ;
run;


* use proc sort to create a temporary sorted table in descending by
frpm_rate_change_2014_to_2015;
proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sort_frpm
    ;
    by descending frpm_rate_change_2014_to_2015;
run;


* use proc sort to create a temporary sorted table in descending by
excess_sat_takers;
proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sort_sat
    ;
    by descending excess_sat_takers;
run;
