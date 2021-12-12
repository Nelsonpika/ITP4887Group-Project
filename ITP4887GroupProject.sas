 /* Import Data */
Libname DSA_DATA '/home/u59794030/ITP4887/Data';
Proc Import
	out=DSA_DATA.ITP4887GroupProject
	datafile='/home/u59794030/ITP4887/Data/ITP4887Group Project/Project_Housing.csv'
	dbms=CSV
	replace;
RUN;


/* 1. Generate (5 to 10 rows) processed renting post records. */
proc print data=dsa_data.itp4887groupproject (firstobs=1 obs=10);
	footnote1 h=1.35 "Q1. Generate 10 rows processed renting post records.";
run;
footnote;


/* 2. What kind of property is having the most number of the bathroom on average? */
PROC SQL;
	create table Q2Result as
		select FlatType, AVG(TotalBaths) as AvgBath from dsa_data.itp4887groupproject
		where bath
		Group by FlatType
		order by AvgBath desc;
run;

proc sgplot data=Q2Result;
	title "The most number of the bathroom on average";
	vbar FlatType / response=AvgBath datalabel categoryorder=respdesc;
	footnote1 h=1.35"Q2. The most number of the bathroom on average of property having is detached house. ";
run;
title;
footnote;


/* 3. What is the contribution of house type in the record? What is the most common type of property in the UK? */
PROC SQL;
	create table Q3Result as
		select FlatType, count(FlatType) as FlatCount from dsa_data.itp4887groupproject
		Group by FlatType
		order by FlatCount desc;
run;

proc sgpie data=Q3Result;
	title "The most common type of property";
	pie FlatType / response=FlatCount datalabeldisplay=none;
	footnote1 h=1.35 "Q3. The most common type of property in the UK is flat. ";
run;
title;
footnote;


/* 4. What is the value distribution of the number of Reception between the semi-detached house and terraced house? */
PROC SQL;
	create table Q4Result as
		select FlatType, receptions, TotalReceptions
		from dsa_data.itp4887groupproject
		where FlatType = "semi-detached house" or FlatType = "terraced house"
		ORDER by FlatType, receptions; 
run;

proc boxplot data=Q4Result;
	title "The value distribution of the number of Reception between the semi-detached house and terraced house";
	plot TotalReceptions * FlatType / boxstyle = schematic;
	footnote1 h=1.35 "Q4. As we can see, a maximum, minimum, lower quartile and upper quartile is almost same in each house type.";
	footnote2 h=1.35 "However, a median of the semi-detached house is higher than the terraced house in this box plot.";
	footnote3 h=1.35 "Also, the outliers are shown in each box plot which means their vlaue can ignore.";
run;
title;
footnote;


/* 5. What kind of property is contain the second most turnover? */
PROC SQL;
	create table Q5Result as
		select FlatType, sum(price) as SumPrice from dsa_data.itp4887groupproject
		Group by FlatType
		order by SumPrice desc;
	select * from Q5Result;
run;

proc sgplot data=Q5Result;
	title "The second most turnover of property";
	vbar FlatType / response=SumPrice datalabel categoryorder=respdesc;
	footnote1 h=1.35 "Q5. The second most turnover of property is contain terraced house";
run;
title;
footnote;


/* 6. Is there any relationship between the number of bedrooms, the number of bathrooms and the average price of a different property? */
PROC SQL;
	create table Q6Result as
		select FlatType, avg(price) as AvgPrice, avg(TotalBeds) as AvgBeds, avg(TotalBaths) as AvgBaths	from dsa_data.itp4887groupproject
		group by FlatType;
	select * from Q6Result;
run;

proc sgplot data=Q6Result noautolegend;
   title 'Linear Regression between the average price and the number of bedrooms';
   reg y=AvgPrice x=AvgBeds;
run;

proc sgplot data=Q6Result noautolegend;
   title 'Linear Regression between the average price and the number of bathrooms';
   reg y=AvgPrice x=AvgBaths;
run;

proc sgplot data=Q6Result noautolegend;
   title 'Linear Regression between the number of bedrooms and the number of bathrooms';
   reg y=AvgBeds x=AvgBaths;
   	footnote1 h=1.25 "Q6. In the chart of Linear Regression between the number of bathrooms and the number of bedrooms. we can see that their correlation is strong and positive since the price will be increase when the bathrooms and bedrooms were increased.";
   	footnote2 h=1.25 "Beside, the chart of Linear Regression between the average price and the number of bedrooms and the chart of Linear Regression between the average price and the number of bathrooms had not enough correlation since the price had not be increase.";
   	footnote3 h=1.25 "Also,  that two chart were had some conspicuous outliers.";
   	footnote4 h=1.25 "Conclude that the chart of Linear Regression between the number of bathrooms and the number of bedrooms had a strong and positive correlation.";
run;
title;






