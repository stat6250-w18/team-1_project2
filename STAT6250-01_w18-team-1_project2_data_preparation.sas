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

[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset 
droppouts00.

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

[Unique ID Schema] The column "CDS_CODE" is the unique id in dataset 
droppouts10.
;


* environmental setup;

* create output formats;

proc format;
    value Race_Ethnicity_bins
        0=" Not reported"
        1=" American Indian/Alaska Native"
        2=" Asian"
        3=" Pacific Islander"
        4=" Filipino"
        5=" Hispanic/Latino"
        6=" African American/Not Hispanic"
        7=" White/ Not Hispanic"
        8=" Multiple/No Response"
        9=" Two or More Races, Not Hispanic"
    ;
    value $Gender_bins
        'F'=" Female"
        'M'=" Male"
    ;
    value Year_Val
        9900=" 1999-2000"
        910=" 2009-2010"
    ;
    value $Dropouts_bins
        'E7'=" Enrollment in grade 7"
        'E8'=" Enrollment in grade 8"
        'E9'=" Enrollment in grade 9"
        'E10'=" Enrollment in grade 10"
        'E11'=" Enrollment in grade 11"
        'E12'=" Enrollment in grade 12"
        'EUS'=" Enrollment in ungraded secondary classes in grades nine through twelve."
        'ETOT'=" Total enrollment for grades nine through twelve."
        'D7'=" Dropout in grade 7"
        'D8'=" Dropout in grade 8"
        'D9'=" Dropout in grade 9"
        'D10'=" Dropout in grade 10"
        'D11'=" Dropout in grade 11"
        'D12'=" Dropout in grade 12"
        'DUS'=" Dropout in ungraded secondary classes in grades nine through twelve."
        'DTOT'=" Total Dropout for grades nine through twelve."
    ;
    value minority_val
        1="Non-White"
        0="White"
    ;
run;


* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesenr_1999_2000_edited.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = enr_1999_2000_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesenr_2009_2010_edited.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = enr_2009_2010_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesdropouts_1999_2000_edited.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = dropout_1999_2000_raw;

%let inputDataset4URL =
https://github.com/stat6250/team-1_project2/blob/master/data/filesdropouts_2009_2010_edited.xlsx?raw=true
;
%let inputDataset4Type = XLSX;
%let inputDataset4DSN = dropout_2009_2010_raw;

%let inputDataset5URL =
https://github.com/stat6250/team-1_project2/blob/master/data/pubschls.xlsx?raw=true
;
%let inputDataset5Type = XLSX;
%let inputDataset5DSN = pubschls_raw;


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
%loadDataIfNotAlreadyAvailable(
    &inputDataset5DSN.,
    &inputDataset5URL.,
    &inputDataset5Type.
)

* sort and check raw datasets for duplicates with respect to their unique ids, 
removing blank rows, if needed;

proc sort
        nodupkey
        data=enr_1999_2000_raw
        dupout=enr_1999_2000_raw_dups
        out=enr_1999_2000_raw_sorted(where=(not(missing(CDS_CODE))))
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
        out=enr_2009_2010_raw_sorted(where=(not(missing(CDS_CODE))))
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
        out=dropout_1999_2000_raw_sorted(where=(not(missing(CDS_CODE))))
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
        out=dropout_2009_2010_raw_sorted(where=(not(missing(CDS_CODE))))
    ;
    by
        CDS_CODE
        ETHNIC
        GENDER
    ;
run;

* combine enr99 and enr09 data vertically;
data enr_analytic_file;
    set
        enr_1999_2000_raw_sorted(in=enr_ay1999_data_row)
        enr_2009_2010_raw_sorted(in=enr_ay2009_data_row)
    ;
        retain
            CDS_CODE
            YEAR
            ETHNIC
            GENDER
            KDGN
            GR_1
            GR_2
            GR_3
            GR_4
            GR_5
            GR_6
            GR_7
            GR_8
            UNGR_ELM
            GR_9
            GR_10
            GR_11
            GR_12
            UNGR_SEC
            ENR_TOTAL
            ADULT
    ;
    by
        CDS_CODE
    ;
    if
        enr_ay1999_data_row=1
    then
        do;
            data_source = enr_1999_2000_raw_sorted;
        end;
    else 
        do;
            data_source = enr_2009_2010_raw_sorted;
        end;
run;


* combine droppouts00 and droppouts10 data vertically;
data dropout_analytic_file;
    set
        dropout_1999_2000_raw_sorted(in=dropout_ay1999_data_row)
        dropout_2009_2010_raw_sorted(in=dropout_ay2009_data_row)
    ;
        retain
            CDS_CODE
            YEAR
            ETHNIC
            GENDER
            E7
            E8
            E9
            E10
            E11
            E12
            EUS
            ETOT
            D7
            D8
            D9
            D10
            D11
            D12
            DUS
            DTOT
    ;
    by
        CDS_CODE
    ;
    if
        dropout_ay1999_data_row=1
    then
        do;
            data_source = dropout_1999_2000_raw_sorted;
        end;
    else 
        do;
            data_source = dropout_2009_2010_raw_sorted;
        end;
run;


* build analytic dataset from raw datasets with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data enr_dropout_analytic_file;
    retain
        CDS_CODE
        YEAR
        ETHNIC
        GENDER	
        ENR_TOTAL
        DTOT
    ;
    keep
        CDS_CODE
        YEAR
        ETHNIC
        GENDER	
        ENR_TOTAL
        DTOT
    ;
    merge
        enr_analytic_file
        dropout_analytic_file
    ;
    by
        CDS_Code
    ;
run;

*CL data manipulation steps;
*Research Question 1;

proc sql; create table enr_drop_names as 
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

data enr_drop_names_eth;
    set enr_drop_names;
    if 
        ethnic ne 7 
    then 
        minority = 1
    ;
    else if 
        ethnic = 7 
    then 
        minority = 0
    ;
run;

proc sql; create table enr_drop_agg as 
    select
        year
        ,district
        ,minority
        ,sum(enr_total) as total_enr
        ,sum(dtot) as total_drop
    from 
        enr_drop_names_eth
    group by 
        year
        ,district
        ,minority
    ;
quit; 

data enr_drop_pct;
    set enr_drop_agg;
    drop_pct = total_drop/total_enr;
run;

proc sort 
    data=enr_drop_pct out=enr_drop_pct_min00;
    by 
        descending drop_pct
    ;
    where minority=1
        and year=9900;
run;

proc sort 
    data=enr_drop_pct out=enr_drop_pct_min10;
    by 
        descending drop_pct
    ;
    where minority=1
        and year=910;
run;

*Research Question 2;
proc sql; create table enr_drop_tot as 
    select 
        year
        ,minority
        ,total_enr
        ,sum(total_enr) as all 
    from 
        (
        select
            year
            ,minority
    	    ,sum(enr_total) as total_enr
        from 
            enr_drop_names_eth
        group by 
            year
            ,minority
        ) 
    group by 
        year
    ;
quit; 

data enr_drop_tot_pct;
    set enr_drop_tot;
    enr_pct = total_enr/all;
run;

*Research Question 3;

proc sql; create table enr_drop_agg_eth as 
    select
        year
        ,district
        ,ethnic
        ,sum(enr_total) as total_enr
        ,sum(dtot) as total_drop 
    from 
        (
        select *
        from enr_drop_names_eth
        where District in (
            'Inyo County Office of Education'
            'Lynwood Unified'
            'Nevada County Office of Education'
            'Golden Plains Unified'
            'Los Angeles County Office of Education')
            and year=910
        )
    group by 
        year
        ,district
        ,ethnic
    ;
quit; 

proc means 
    data=enr_drop_agg_eth 
        noprint
    ;
    var 
        total_enr
    ;
    by 
        district
    ;                                                    
    output 
        out=dist_tot 
            (keep=district total_sum) 
        sum=total_sum
    ;         
run;  

proc sql; create table enr_drop_agg_eth2 as 
    select a.*
        ,b.total_sum
        ,(a.total_enr/b.total_sum) as ethnic_pct
    from enr_drop_agg_eth as a 
    left join dist_tot as b
    on a.district=b.district
    ;
quit;

proc sort 
    data=enr_drop_agg_eth2; 
    by 
        district 
        descending ethnic_pct
    ; 
run;


* Creation of tables and data sets, and PROC SORT steps required in 
analysis file by AA;
proc sql; create table enr_drop_by_gender as 
    select
        year
        ,gender
	    	,sum(enr_total) as total_enr
			,sum(dtot) as total_drop
    from 
        enr_dropout_analytic_file
	group by 
        year
        ,gender
	;
quit;

data enr_drop_rate_gender;
	set enr_drop_by_gender;
	total_enr_rate = total_enr;
	total_drop_rate = total_drop;
	enr_rate = total_enr/total_drop;
	drop_rate = total_drop/total_enr;
run;

proc sort 
    data=enr_drop_rate_gender 
    out=enr_rate_tot_gender_sorted_9900;
    by 
        total_enr_rate
    ;
    where
    	year=9900
    ;
run;

proc sort 
    data=enr_drop_rate_gender 
    out=enr_rate_gender_sorted_9900;
    by 
        enr_rate
    ;
    where
    	year=9900
    ;
run;

proc sort 
    data=enr_drop_rate_gender 
    out=enr_rate_tot_gender_sorted_0910
    ;
    by 
        total_enr_rate
    ;
    where
    	year=910
    ;
run;

proc sort 
    data=enr_drop_rate_gender 
    out=enr_rate_gender_sorted_0910
    ;
    by 
        enr_rate
    ;
    where
    	year=910
    ;
run;

proc sql; create table enr_dropout_by_ethnic as 
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

data enr_rate_ethnic;
    set enr_dropout_by_ethnic;
	total_enr_rate = total_enr;
	enr_rate = total_enr/total_drop;
run;

proc sort 
    data=enr_rate_ethnic 
    out=enr_tot_rate_ethnic_sorted_9900;
    by 
        total_enr_rate
    ;
    where
    	year=9900
    ;
run;
