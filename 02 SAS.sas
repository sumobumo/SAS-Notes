/*
02 SAS notes - Exploring data

*/


/* 
proc contents:
	- print data summary ( creation date, location, columns names-type-size, etc )

proc print:
	- print all rows and columns of data

proc means:
	- print simple descriptive statistics -  count, mean, standard deviation, minimum and maximum for columns in data 	

proc univariate:
	- print more detailed descreptive statistics.

proc freq:
	- prints frequency, cummulative frequency etc for each column in data

 */

proc contents data=Sashelp.Class;
run;

proc print data=Sashelp.Class;
run;

proc print data=Sashelp.Class (obs = 10);	* limit to top 10 obervation;
run;

proc print data=Sashelp.Class;	
	var Name Age;					* print selected columns. Note to no comma to separate column names;
run;

proc means data=Sashelp.Class;	
	var Age Height;					* mean of age and height;
run;								

proc means data=Sashelp.Class;		* mean of all numerical variables;
run;


proc univariate data=Sashelp.Class;	* more detailed descriptive statistics;	
run;


proc freq data=Sashelp.Class;	* frequency;	
run;

proc freq data=Sashelp.Class;	* frequency of selected columns only; 	
	tables age height;			* Note use of tables instead of vars to select variables;
run;




/* Filtering data */

/*
operators:
	= or EQ
	< or LT
	<= or LE
	> or GT
	>= or GE
	^= or ~= or NE
	AND
	OR
	LIKE ( ... )
	IN ( ... )
	NOT IN ( ... )
	BETWEEN xx AND yy.   (It is inclusive)
	IS MISSING
	IS NOT MISSING
	IS NULL

comapring date:
	- "ddmmmyyy"d  : Example "01Jan2021"d
*/

proc print data=Sashelp.Class;
	WHERE Age > 13;
run;


proc print data=Sashelp.Class;
	WHERE Age BETWEEN 11 AND 15 ;
run;

proc print data=Sashelp.Class;
	WHERE 11 < Age < 15;
run;


proc print data=Sashelp.Class;
	WHERE Name LIKE  "J%";		* % match any number of character;
run;

proc print data=Sashelp.Class;
	WHERE Name LIKE  "Ja___";		* _ match any single character;
run;

proc print data=Sashelp.Class;
	WHERE Name LIKE  "Ja__";		* _ match any single character;
run;


proc print data=Sashelp.Class;
	WHERE Name IN ("Janet", "Henry");		
run;




/* Dates */
proc contents data=Sashelp.Citiday;
run;

proc print data=Sashelp.Citiday;
	WHERE DATE < "01JAN1989"d;
run;



/* MACROS */
/*
	- Macros begin with % symbol.
	- %LET is like variable declaration. Note: String values are not enclosed in "".
			%LET carMake = Acura;
	- *Use "&<variable_name>", enclosed in "", to access this variable in proc step
*/

%LET carMake = Acura;		

proc print data=Sashelp.cars;
	WHERE Make = "&carMake";	*use of macro variable;
run;




%LET carMake = Volvo;	* Only need to change this value and same proc print can be used.;

proc print data=Sashelp.cars;
	WHERE Make = "&carMake";
run;




%LET carMake = Volvo;
%LET carType = SUV;
%LET carmsrp = 40000;

proc print data=Sashelp.cars;
	WHERE Make = "&carMake" AND Type = "&carType" AND MSRP > &carmsrp;
run;




/* FORMATTING VALUES*/
/*
	<$>format_name<w>.<d>
		- <$> : character format
		- format_name : name of format
			- can be nothing
			- COMMA
			- DOLLAR
			- YEN
			- EURO 
			- DATE
			- MMDDYY
			- DDMMYY
			- MONYY
			- MONNAME
			- WEEKDATE

		- <w> :	width of values. Example $4,000.0 is 8 width including $ , . and numbers
		- . : required
		- <d> : number of digits in decimal values 
*/

%LET carMake = Volvo;
%LET carType = SUV;
%LET carmsrp = 40000;
proc print data=Sashelp.cars;
	WHERE Make = "&carMake" AND Type = "&carType" AND MSRP > &carmsrp;
run;

proc print data=Sashelp.cars;
	format MSRP 6.2      Invoice 7.1 ;		* See what happends when width amount is not enough. data format changes;
	WHERE Make = "&carMake" AND Type = "&carType" AND MSRP > &carmsrp;
run;


/* Another example */

proc print data=Sashelp.burrows;
	WHERE ID BETWEEN 500 AND 550;
run;

proc print data=Sashelp.burrows;
	FORMAT X 5.2    Y comma10.2;
	WHERE ID BETWEEN 500 AND 550;
run;

proc print data=Sashelp.burrows;
	FORMAT X dollar20.2    Y comma5.2;
	WHERE ID BETWEEN 500 AND 550;
run;




/* SORTING */
/*
	- Specify OUT=data_name to create a copy of data and sort otherwise it will sort the main data, changing order of data in original data.
	- Ascending is default. To sort column in descending order use descending keyword then column name.
*/

proc sort data=Sashelp.Class OUT=work.temp;
	by descending Name;
run;

proc print data = work.temp;
run;



proc sort data=Sashelp.Class OUT=work.temp;
	by Sex descending Name;			* Sort by sex, then descendingn order name
run;

proc print data = work.temp;
run;



/* Checking for duplicates */

proc sort data=Sashelp.Cars OUT=work.temp NODUPRECS DUPOUT = work.dupes;
	by _ALL_;		*_ALL_ is helpful in checking duplicate rows because it sorts by all columns;
run;

proc print data = work.temp;	* OUT = work.temp. So this contains data with duplicates removed;
run;

proc print data = work.dupes;  	* DUPOUT = work.dupes. So, any duplicates are stored here.;
run;



proc sort data=Sashelp.Cars OUT=work.temp NODUPKEY DUPOUT = work.dupes;	*NODUPKEY : no duplicate entries in specified column name. If duplicates only keeps first encounter.;
	by Make;															*filters unique car make only. ;
run;

proc print data = work.temp;	
run;

proc print data = work.dupes;
run;

