/* SAS tutorial */

/* Multi line comment */ 
* Single line comment. Must end with ;

/*
Notes:
	- Every statement must end with ;. Most SYNTAX errors will probably be due to missing ;
	- data vs proc:
		- In sas every step(statement block) is either data step or proc step. 
		  If it beings with data its data step. If it begins with proc its proc step
		- almost all step ends with run. Few proc steps end with quit. 
		- data step: 
			usually data manipulation
			reads data, 
			process, manipulate, filter data,
			derive new variables
			merge two different data sets 
			Save the data as sas table i.e. *.sas7bdat
		- proc step:
			usually to perform SAS predefined functions
	- global statements: defines settings / options for SAS session. Global statements do not need run; at end.
		- TITLE
		- OPTIONS
		- LIBNAME
	- Column types:
		- Numeric:
			+/- integer, float, scientific notation ( Ex: 20E5 )
			Size: 8 byte - 16 signigicant digits
		- Character:
			anything, numbers, text, spaces. 
			Size: 32,767 characters
		- Date:
			Date are stored as number of days since Jan 1, 1960
*/

* data step;
data mydata; 
	set Sashelp.Class;
run;

* proc step;
proc print data=mydata;
run;


* Check file description. # of obs. columns names, type, size. date created etc;
proc contents data=Sashelp.Class;
run;



/*
LIBNAME [libname] [engine] "path",
[libname]:
	- max 8 characters
	- starts with letters or underscore, can be anything afterwards. letters numbers underscores
[engine]:
	- type of data
	- base: SAS data
	- xlsx: excel data

Notes:
	- LIBNAME is global statement. do not need run; at end
	- SAS has many libraries. Usually we use [libname].[data] to load files
		- Sashelp:
			- library that contains sample data files 
		- Work
			- Temporary library. default library that SAS used to store files if library name not specified
			- Everything inside it is deleted when SAS session ends
		- User created libraries
			- Data are preserved even if SAS session is closed.
			- Only library ref is deleted when SAS session is closed.
			- On next SAS session, we can load user defined libraries again to see all previous data 
	- Close LIBNAME reference. close connection to library. Otherwise the connection will remain active until SAS session ends
		Syntax: LIBNAME mylib clear;
*/
libname mylib base "H:/SAS/customlib";
libname mylib "H:/SAS/customlib";
* Both are same. base is default so dont need to include ;
* base engine means files stored in customlib are SAS files. *.sas7bdat;


data mylib.class work.class class1;		* creating 3 new datasets by copying data from Sashelp.class file. All saved as *.sas7dbat file;
	set Sashelp.class;					* mylib.class : a copy is created in custom library "mylib" that was defined earlier;
										* work.class : a copy is created in SAS build in library work, which is a temporary library;
run;									* class1 : a copy is created in SAS buildin work library. By default work library is used if no other library name is specified.	



* Another example of loading different library but with excel file;
* Each excel sheet is loaded as separate data file.;
options validvarname = v7;

libname mylib1 XLSX "H:/SAS/data/Class.xlsx";



proc contents data=mylib1.Sheet1;  * test if we can access the file;
run;


/*
While reading excel files, it is better to specify following options
*/
options validvarname = v7; 	* Force Excel column names to meet SAS column naming standard. ;
							* Replaces " " with "_". Truncates any name longer than 32 characters;


libname mylib1 clear; 	* just deleted reference to mylib1. data are gone from explorer pane but they still exist in harddrive;
						* helpful especially when loading files from other data source. When we load library we maintain active connection to the data file.; 
						* Other connection to the file will not be allowed. So if our peers are also trying to acess same data source, they may be blocked unitl we let go this resource;
						* This will close connection to excel file. Now others will be able to access it.;

libname mylib1 XLSX "H:/SAS/data/Class.xlsx";  * just load library again and the data is back;



/* Another way to import Excel file.*/
proc import datafile="H:/SAS/data/Class.xlsx" dbms=xlsx out=mylib.Class replace;		* dbms: file type.     out: location to store file      replace: option to indicate replace if file with same name already exists in specified library ;
guessingrows = 20;																		* specify how many rows to use to guess column type. value can be numbers of MAX, meaning use all observation to guess column type;
sheet = "Sheet1"; 																		* Sheet: specify which sheet to read from excel file;

run;																					* guessingrows = 20;
																							
proc contents data=mylib.Class;
run;


/*
Difference between these 2 ways of reading excel file: "libname" and "proc import".
	- libname
		- always reads current data when loading SAS program. Even if excel file is updated no problem.
	- proc import
		- creates a copy of excel file when running the file. If excel is updated we need to re run proc import
*/



/* Importing from CSV file */
proc import datafile="H:/SAS/data/ClassCSV.csv" dbms=csv out=mylib.ClassCSV replace;
run;

proc contents data=mylib.ClassCSV;
run;



* Example of proc step ending with quit instead of run;
proc sql;
create table table1 as
Select a.col1, a.col2, a.col3, b.col1, b.col2, b.col3
	from data1 as a, data2 as b
	where a.key = b.key order by a.col desc;
quit;
