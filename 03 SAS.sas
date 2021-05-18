/* 
Manipulating / Transforming data

Source: SAS® 9.4 Cert Prep: Part 04 Preparing Data
More detail: Look for SAS Programming 2 course.

Manipulaitng data is mosty Date step. So SAS statements will being DATA keyword.

Data step consists of 2 phases: Compilation and Execution.

Compilation: SAS checks for syntax errors; if no errors it looks for columns, data type to be created for  new dataset.

Execution: Read data => Perform data manipulation, calculations etc and write to new dataset. (happens row by row basis)

*/

libname mylib "H:/SAS/customlib";

data mylib.Class;
	set Sashelp.class;	
run;

data mylib.ClassFemale;
	set Sashelp.class;
	Where Sex = "F";		/*Use Where to specify condition to filter data*/
run;

data mylib.ClassMale;
	set Sashelp.class;
	Where Sex = "M";	
run;

data mylib.ClassFemale;
	set Sashelp.class;
	Where Sex = "F";	
	Drop Height Weight;		/*Use drop to remove columns*/
run;

data mylib.ClassFemale;
	set Sashelp.class;
	Where Sex = "F";	
	Keep Name Age;			/*Use keep to keep only selected columns*/
run;


/*Deriving new columns, using static values, existing columns, SAS builtin functions*/
data mylib.ClassNew;
	set Sashelp.class;
	L_Name = "Blah";		*new column with all static value i.e. "Blah";
	Height_cm = Height*2.54;	
	Weight_kg = Weight/2.2;
	format Height_cm 6.2 Weight_kg 4.1;	*Height_cm : 2 decimal places | Weight_kg: 1 decimal place;
run;

data mylib.ClassNew1;
	set Sashelp.class;
	F_Name = upcase(Name);	*Converts to uppercase;
	L_Name = upcase("Blah");
	Full_Name1 = cats(F_Name, L_Name); *Strips beginning and ending white spaces from values and combines them together. Notice no space between first and last name;
	Full_Name2 = catx(" ", F_Name, L_Name); *first argument, which is " ", is used to concat columns. Notice space between first and last name;
	Full_Name3 = propcase(Full_Name2);	*Converts to proper case automatically;
run;

/*
upper() is a function. more about SAS functions

substr( var_name, start_index, end_index)

*/

*TO-DO: PUT MORE EXAMPLES OF DIFFERENT FUNCTIONS LATER;


/*
SAS Dates: 

SAS DATE RAW FORM EXAMPLE: 21056. It actually represents # of days from January 1st, 1960. 

*/


DATA mylib.retail1;
	SET Sashelp.Retail;
	Newdate_Raw = mdy(month, day, year);					*construct long date from year, month, day values;
	Newdate_long1 = Newdate_Raw;
	Newdate_long2 = Newdate_Raw;
	Newdate_long3 = Newdate_Raw;
	Newdate_long4 = Newdate_Raw;
	YearsPassed = yrdif(Newdate_raw, today(), "age");		*calculate year difference between years. today() returns current date;
	YearsPassed1 = yrdif(year, today(), "age");				*passing just year and calculating year diff does not seem to work;
	YearsPassed2 = yrdif(mdy(1,1,year), today(), "age");	*current work around: convert year into long year format and then calculate year diff;
	format YearsPassed 2.0 YearsPassed1 6.3 YearsPassed2 6.3 Newdate_long1 10. Newdate_long2 mmddyy10. Newdate_long3 ddmmyy10. Newdate_long4 monyy7.;
run;



/*
conditional if - else if - else

*/

DATA mylib.Cars;
	SET Sashelp.Cars;
	LENGTH Cost $ 10;	*this is the way to specify length of characters to display. LENGTH col_name $ <length>. Other by default the length will be length of whatever value that is assigned first for first entry. i.e. if "Low" was first value to be evaluated from if conditions then length of Cost column will be 3.;
	IF MSRP > 50000 THEN Cost = "High";	*Need to specify length of variable before any assignment operator happens.;
	ELSE IF MSRP > 30000 THEN Cost = "Medium";
	ELSE Cost = "Low";
	keep Make Model Type Origin MSRP Cost;
run;


/*
When executing multiple statements inside if else statements.

IF ... THEN DO;
	...
	...
	...
END;
ELSE IF ... THEN DO;
	...
	...
	...
END;
ELSE DO;
	...	
	...
	...
END:
*/
DATA mylib.CarsLuxury mylib.CarsCheap;	*Creates 2 datasets: Cheap cars and Luxury cars;
	SET Sashelp.Cars;
	LENGTH Style $ 10;	
	IF MSRP > 50000 THEN DO;		
		Style= "Luxury";	
		output mylib.CarsLuxury;	*Specifying which dataset to put these values to;
	END;
	ELSE DO; 
		Style = "Cheap";
		output mylib.CarsCheap;
	END;
	keep Make Model Type Origin MSRP Style;
run;
