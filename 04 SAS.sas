/*
04 - Analyzing and Reporting on Data

Source: SAS® 9.4 Cert Prep: Part 05 Analyzing and Reporting on Data
*/

libname mylib "H:/SAS/customlib";

TITLE1 "This is a title. There can be up to 10 title. Title1 Title2 ... Title10";
FOOTNOTE1 "This is a footnote. There can be up to 10 footnote. Footnote1 Footnote2 ... Footnote10";

Proc print data = Sashelp.Class;
	var Name Sex;
run;

TITLE; FOOTNOTE; *Clearing title and footnote;



%let age = 13;

Title "Age=&age"; *Title == Title1;
Proc print data = Sashelp.Class;
	var Name Sex Age;
	Where Age = &age;
run;
TITLE; FOOTNOTE; *Clearing title and footnote;



proc means data = Sashelp.Cars;
	where type = "Sedan";
	var MSRP MPG_Highway;
	label MSRP = "Manufacturer Suggested Retail Price"
		MPG_Highway = "Highway Miles per Gallon";
run;


proc print data = Sashelp.cars;		*Notice labels do not show;
	where type = "Sedan";
	var Make Model MSRP MPG_Highway MPG_City;
	label MSRP = "Manufacturer Suggested Retail Price"
		MPG_Highway = "Highway Miles per Gallon"
		MPG_City = "City Miles per Gallon";
run;


proc print data = Sashelp.cars label;		*Proc print in special case. We need to specity label in statement manually;
	where type = "Sedan";
	var Make Model MSRP MPG_Highway MPG_City;
	label MSRP = "Manufacturer Suggested Retail Price"
		MPG_Highway = "Highway Miles per Gallon"
		MPG_City = "City Miles per Gallon";
run;


/*
BY :
	- Same as grouping dataset
	- First we need to sort the data by the column we will be grouping by
	- then group data using that column.
*/

proc sort data = Sashelp.cars out=mylib.cars_sorted;
	by Origin;
run;

proc freq data = mylib.cars_sorted;
	by Origin;
	tables Type;
run;





proc sort data = Sashelp.cars out=mylib.cars_luxury;
	by Origin descending MSRP;
	where MSRP > 50000;
run;

Title1 "USA Luxury cars";
Footnote1 "USA Luxury cars";

proc print data = mylib.cars_luxury label;
	by Origin;
	label MSRP = "Manufacturer Suggested Retail Price"
		MPG_Highway = "Highway Miles per Gallon"
		MPG_City = "City Miles per Gallon";
run;


proc print data = mylib.cars_luxury label noobs;	*noobs: Removes observation indexes. Numering of output;
	by Origin;
	label MSRP = "Manufacturer Suggested Retail Price"
		MPG_Highway = "Highway Miles per Gallon"
		MPG_City = "City Miles per Gallon";
run;


/*
If we use label option in data step. The label descriptions are added as a new column when printing contents.
*/

data out = mylib.cars_update;
	set Sashelp.Cars;
	keep Make Model Type MSRP AvgMPG;
	AvgMPG = mean(MPG_City, MPG_Highway);
	label MSRP = "Manufacturer Suggested Retail Price"
		AvgMPG = "Average Miles per Gallon"
run;

proc contents data = mylib.cars_update;
run;



/*
proc freq examples

ODS GRAPHICS ON;
PROC  FREQ DATA = input_table <proc-options>
	TABLES col_names / options;
RUN;


PROC FREQ statement options:
	ORDER = FREQ|FORMATTED|DATA
	NLEVELS
TABLES statement options:
	NOCUM
	NOPERCENT
	PLOTS = FREQPLOT	(Need to turn on ODS GRAPHICS for this)
	OUT = output-table

*/

proc freq data = Sashelp.heart;
	tables Chol_Status;
run;


proc freq data = Sashelp.heart;
	tables Chol_Status Sex;
run;


proc freq data = Sashelp.heart order = freq;	*Notice for Chol_Status, Code block before sorted based in name values (Borderline->Desirable->High). This statement sorts based on frequency counts (Borderline->High->Desirable);
	tables Chol_Status Sex;
run;



proc freq data = Sashelp.heart order = freq nlevels; *nlevels adds a table showing how many levels are in each variables we are printing. Null / Missing values are also considered as 1 level;
	tables Chol_Status Sex;
run;


proc freq data = Sashelp.heart order = freq nlevels;	
	tables Chol_Status Sex / nocum;						*NOCUM removes cummulative frequency columns;
run;



proc freq data = Sashelp.Air order = freq nlevels;	
	tables Date / nocum;						*Horrible results right? ;
run;


proc freq data = Sashelp.Air order = freq nlevels;	
	tables Date / nocum;						
	format Date monname.;						*Formats data values to be represented by month names and then groups the data based on month. Don't forget . after monname, otherwise month is changed to some numbers;
run;



ODS GRAPHICS ON;
proc freq data = Sashelp.Air order = freq nlevels;	
	tables Date / nocum plots=freqplot;						
	format Date monname.;						
run;
ODS GRAPHICS OFF; *turn off graphics;

	
ODS GRAPHICS ON;	*once on, will be on for SAS session;
ods noproctitle;
proc freq data = Sashelp.Air order = freq nlevels;	
	tables Date / nocum plots=freqplot(orient = horizontal scale=percent);						
	format Date monname.;						
run;
ods proctitle;


proc freq data=Sashelp.Heart;
	tables BP_Status * Chol_Status;
run;


/*
Cross tabs

PROC  FREQ DATA = input_table
	TABLES col_name * col_name / options;
RUN;


PROC FREQ statement options:
	NOPRINT
TABLES statement options:
	NOROW, NOCOL, NOPERCENT
	CROSSLIST, LIST
	OUT = output-table

*/

proc freq data=Sashelp.Heart;
	tables BP_Status * Chol_Status / NOROW NOCOL NOPERCENT;		*Removed row, col and percentage counts;
run;


proc freq data=Sashelp.Heart;
	tables BP_Status * Chol_Status / CROSSLIST;		*Row by row cross tab;
run;


proc freq data=Sashelp.Heart;
	tables BP_Status * Chol_Status / LIST;				*Everything in one line at a time;
run;


proc freq data=Sashelp.Heart;
	tables BP_Status * Chol_Status / OUT = mylib.counts;	*To save the crosstabs generated as dataset;
run;

proc freq data=Sashelp.Heart noprint;	*To supress printing resilts in ResultViewer;
	tables BP_Status * Chol_Status / OUT = mylib.counts;
run;



/*
PROC MEANS DATA = input-table <Statistics-list>;
	VAR col-names;
	CLASS col-names;	*variables to group the data by;
	WAYS n;				*When more than 1 CLASS columns defined, we can use WAYS to control combination of values of the class columns;
RUN;

*/


PROC MEANS data = Sashelp.Heart;
	var Height;
run;

PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;		*We can specify what statistics to calculate manually. msxdec = 0 will round numbers to whole number. 1 = round to tenth place;
	var Height;
run;


PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;	
	var Height;
	CLASS Chol_Status;	*group data by Chol_Status and find means for each category;
run;


PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;	
	var Height;
	CLASS Chol_Status Weight_Status;	*group data by Chol_Status then by Weight_Status and find means for each category;
run;


PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;	
	var Height;
	CLASS Chol_Status Weight_Status;	*group data by Chol_Status and find means for each category. Next group data by Weight_Status and find means for each category.;
	WAYS 1;
run;

PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;	
	var Height;
	CLASS Chol_Status Weight_Status;
	WAYS 0 1 2;			*0: calculate mean for all data, 1 : group data by column and calculate mean each columns separately, 2: group data by col1 then col2 then find means;
run;


PROC MEANS data = Sashelp.Heart mean median min max maxdec = 0;	
	var Height;
	CLASS Chol_Status Weight_Status;	
	WAYS 1;
	OUTPUT out= mylib.Heart_Stats mean = AverageCholestrol;
run;
