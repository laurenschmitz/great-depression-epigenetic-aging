**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO THE WAGE INDEX***	
	*Project: Early-life Exposure to the Great Depression and Long-term Health and Economic Outcomes
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
**************************************************************************************************************

clear
set more off

	*Import Farm and Non-Farm Wage Data by State 

		use "/Users/laurenschmitz/Dropbox/2023_ACTIVE_PROJECTS/Duque_&_Schmitz/Data/Raw_BEA_Salary_Data" 
			*Data source: U.S. Bureau of Economic Analysis, SAINC7H Wages and Salaries by Industry (Historical) 1929-1957
			*URL to data on BEA website: https://apps.bea.gov/iTable/iTable.cfm?reqid=70&step=30&isuri=1&year_end=-1&classification=sic&state=0&yearbegin=-1&unit_of_measure=index&major_area=0&area=xx&year=-1&tableid=16&category=429&area_type=0&statistic=50&selected_income_data=0

			*Assign HRS coding for state of birth for merge with HRS data
				generate st_born=.

					replace	st_born	=	2	if state==	"AK"
					replace	st_born	=	1	if state==	"AL"
					replace	st_born	=	3	if state==	"AZ"
					replace	st_born	=	4	if state==	"AR"
					replace	st_born	=	5	if state==	"CA"
					replace	st_born	=	6	if state==	"CO"
					replace	st_born	=	7	if state==	"CT"
					replace	st_born	=	8	if state==	"DE"
					replace	st_born	=	9	if state==	"FL"
					replace	st_born	=	10	if state==	"GA"
					replace	st_born	=	11	if state==	"HI"
					replace	st_born	=	12	if state==	"ID"
					replace	st_born	=	13	if state==	"IL"
					replace	st_born	=	14	if state==	"IN"
					replace	st_born	=	15	if state==	"IA"
					replace	st_born	=	16	if state==	"KS"
					replace	st_born	=	17	if state==	"KY"
					replace	st_born	=	18	if state==	"LA"
					replace	st_born	=	19	if state==	"ME"
					replace	st_born	=	20	if state==	"MD"
					replace	st_born	=	21	if state==	"MA"
					replace	st_born	=	22	if state==	"MI"
					replace	st_born	=	23	if state==	"MN"
					replace	st_born	=	24	if state==	"MS"
					replace	st_born	=	25	if state==	"MO"
					replace	st_born	=	26	if state==	"MT"
					replace	st_born	=	27	if state==	"NE"
					replace	st_born	=	28	if state==	"NV"
					replace	st_born	=	29	if state==	"NH"
					replace	st_born	=	30	if state==	"NJ"
					replace	st_born	=	31	if state==	"NM"
					replace	st_born	=	32	if state==	"NY"
					replace	st_born	=	33	if state==	"NC"
					replace	st_born	=	34	if state==	"ND"
					replace	st_born	=	35	if state==	"OH"
					replace	st_born	=	36	if state==	"OK"
					replace	st_born	=	37	if state==	"OR"
					replace	st_born	=	38	if state==	"PA"
					replace	st_born	=	39	if state==	"RI"
					replace	st_born	=	40	if state==	"SC"
					replace	st_born	=	41	if state==	"SD"
					replace	st_born	=	42	if state==	"TN"
					replace	st_born	=	43	if state==	"TX"
					replace	st_born	=	44	if state==	"UT"
					replace	st_born	=	45	if state==	"VT"
					replace	st_born	=	46	if state==	"VA"
					replace	st_born	=	47	if state==	"WA"
					replace	st_born	=	48	if state==	"WV"
					replace	st_born	=	49	if state==	"WI"
					replace	st_born	=	50	if state==	"WY"
					replace	st_born	=	51	if state==	"DC"

			*Harmonize state labeling across sources
				replace	state=	"Alaska"	if state==	"AK"
				replace	state=	"Alabama"	if state==	"AL"
				replace	state=	"Arizona"	if state==	"AZ"
				replace	state=	"Arkansas"	if state==	"AR"
				replace	state=	"California"	if state==	"CA"
				replace	state=	"Colorado"	if state==	"CO"
				replace	state=	"Connecticut"	if state==	"CT"
				replace	state=	"Delaware"	if state==	"DE"
				replace	state=	"Florida"	if state==	"FL"
				replace	state=	"Georgia"	if state==	"GA"
				replace	state=	"Hawaii"	if state==	"HI"
				replace	state=	"Idaho"	if state==	"ID"
				replace	state=	"Illinois"	if state==	"IL"
				replace	state=	"Indiana"	if state==	"IN"
				replace	state=	"Iowa"	if state==	"IA"
				replace	state=	"Kansas"	if state==	"KS"
				replace	state=	"Kentucky"	if state==	"KY"
				replace	state=	"Louisiana"	if state==	"LA"
				replace	state=	"Maine"	if state==	"ME"
				replace	state=	"Maryland"	if state==	"MD"
				replace	state=	"Massachusetts"	if state==	"MA"
				replace	state=	"Michigan"	if state==	"MI"
				replace	state=	"Minnesota"	if state==	"MN"
				replace	state=	"Mississippi"	if state==	"MS"
				replace	state=	"Missouri"	if state==	"MO"
				replace	state=	"Montana"	if state==	"MT"
				replace	state=	"Nebraska"	if state==	"NE"
				replace	state=	"Nevada"	if state==	"NV"
				replace	state=	"New Hampshire"	if state==	"NH"
				replace	state=	"New Jersey"	if state==	"NJ"
				replace	state=	"New Mexico"	if state==	"NM"
				replace	state=	"New York"	if state==	"NY"
				replace	state=	"North Carolina"	if state==	"NC"
				replace	state=	"North Dakota"	if state==	"ND"
				replace	state=	"Ohio"	if state==	"OH"
				replace	state=	"Oklahoma"	if state==	"OK"
				replace	state=	"Oregon"	if state==	"OR"
				replace	state=	"Pennsylvania"	if state==	"PA"
				replace	state=	"Rhode Island"	if state==	"RI"
				replace	state=	"South Carolina"	if state==	"SC"
				replace	state=	"South Dakota"	if state==	"SD"
				replace	state=	"Tennessee"	if state==	"TN"
				replace	state=	"Texas"	if state==	"TX"
				replace	state=	"Utah"	if state==	"UT"
				replace	state=	"Vermont"	if state==	"VT"
				replace	state=	"Virginia"	if state==	"VA"
				replace	state=	"Washington"	if state==	"WA"
				replace	state=	"West Virginia"	if state==	"WV"
				replace	state=	"Wisconsin"	if state==	"WI"
				replace	state=	"Wyoming"	if state==	"WY"
				replace	state=	"DC"	if state==	"DC"

			rename state st_born_name
			rename year birthyr
			rename st_born st_born2
			
			sort st_born2 birthyr	

	*Create real wage index using CPI

		gen salaries_cpi=salaries //salaries adjusted for CPI 

			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.7 if birthyr==1926
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.4 if birthyr==1927
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.2 if birthyr==1928
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.2 if birthyr==1929
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/16.7 if birthyr==1930
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/15.2 if birthyr==1931
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/13.6 if birthyr==1932
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/12.9 if birthyr==1933
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/13.4 if birthyr==1934
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/13.7 if birthyr==1935
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/13.9 if birthyr==1936
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/14.4 if birthyr==1937
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/14.1 if birthyr==1938
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/13.9 if birthyr==1939
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/14.0 if birthyr==1940
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/14.7 if birthyr==1941
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/16.3 if birthyr==1942
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.3 if birthyr==1943
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/17.6 if birthyr==1944
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/18.0 if birthyr==1945
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/19.5 if birthyr==1946
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/22.3 if birthyr==1947
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/24.0 if birthyr==1948
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/23.8 if birthyr==1949
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/24.1 if birthyr==1950
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/26.0 if birthyr==1951
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/26.6 if birthyr==1952
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/26.8 if birthyr==1953
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/26.9 if birthyr==1954
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/26.8 if birthyr==1955
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/27.2 if birthyr==1956
			}
			foreach var of varlist salaries_cpi {
			 replace `var'=`var'/28.1 if birthyr==1957
			}

	*Recenter indices on 1929 & multiply by 100
		gen salaries_adj=salaries_cpi/5.8139534 //Divide by salaries_cpi in 1929--i.e., index adjusted for inflation in 1929 (100/17.2, where 17.2 is the CPI in 1929)
			gen salariesi=salaries_adj*100
		
	*Generate event time study variables

		sort st_born2 birthyr
		
		foreach var of varlist salariesi {

			bysort st_born2: gen `var'_1=`var'[_n-1]
			bysort st_born2: gen `var'_2=`var'[_n-2]
			bysort st_born2: gen `var'_3=`var'[_n-3]
			bysort st_born2: gen `var'1=`var'[_n+1]
			bysort st_born2: gen `var'2=`var'[_n+2]
			bysort st_born2: gen `var'3=`var'[_n+3]
			bysort st_born2: gen `var'4=`var'[_n+4]
			bysort st_born2: gen `var'5=`var'[_n+5]
			bysort st_born2: gen `var'6=`var'[_n+6]
			bysort st_born2: gen `var'7=`var'[_n+7]
			bysort st_born2: gen `var'8=`var'[_n+8]
			bysort st_born2: gen `var'9=`var'[_n+9]
			bysort st_born2: gen `var'10=`var'[_n+10]
			bysort st_born2: gen `var'11=`var'[_n+11]
			bysort st_born2: gen `var'12=`var'[_n+12]
			bysort st_born2: gen `var'13=`var'[_n+13]
			bysort st_born2: gen `var'14=`var'[_n+14]
			bysort st_born2: gen `var'15=`var'[_n+15]
			bysort st_born2: gen `var'16=`var'[_n+16]
			bysort st_born2: gen `var'17=`var'[_n+17]

		}

	*Drop variables not needed
		drop *_adj 
		drop salaries_cpi 

	*Label variables
		label var salariesi "CPI adjusted farm and nonfarm wage index in the YOB (t)"
		label var salariesi_1 "CPI adjusted farm and nonfarm wage index at t-1"
		label var salariesi_2 "CPI adjusted farm and nonfarm wage index at t-2"
		label var salariesi_3 "CPI adjusted farm and nonfarm wage index at t-3"
		label var salariesi1 "CPI adjusted farm and nonfarm wage index at t+1"
		label var salariesi2 "CPI adjusted farm and nonfarm wage index at t+2"
		label var salariesi3 "CPI adjusted farm and nonfarm wage index at t+3"
		label var salariesi4 "CPI adjusted farm and nonfarm wage index at t+4"
		label var salariesi5 "CPI adjusted farm and nonfarm wage index at t+5"
		label var salariesi6 "CPI adjusted farm and nonfarm wage index at t+6"
		label var salariesi7 "CPI adjusted farm and nonfarm wage index at t+7"
		label var salariesi8 "CPI adjusted farm and nonfarm wage index at t+8"
		label var salariesi9 "CPI adjusted farm and nonfarm wage index at t+9"
		label var salariesi10 "CPI adjusted farm and nonfarm wage index at t+10"
		label var salariesi11 "CPI adjusted farm and nonfarm wage index at t+11"
		label var salariesi12 "CPI adjusted farm and nonfarm wage index at t+12"
		label var salariesi13 "CPI adjusted farm and nonfarm wage index at t+13"
		label var salariesi14 "CPI adjusted farm and nonfarm wage index at t+14"
		label var salariesi15 "CPI adjusted farm and nonfarm wage index at t+15"
		label var salariesi16 "CPI adjusted farm and nonfarm wage index at t+16"
		label var salariesi17 "CPI adjusted farm and nonfarm wage index at t+17"

		label var birthyr "Year of birth"
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"

save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Salary_Data_w_ETS_FINAL.dta", replace

