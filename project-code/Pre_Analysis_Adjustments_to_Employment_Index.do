**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO THE EMPLOYMENT INDEX***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Employment Data (Manufacturing + Non-Manufacturing) by State 
		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_Employment_Index_Data.dta"
			*Data source: J. J. Wallis, Employment in the Great Depression: New data and hypotheses. Explor. Econ. Hist. 26, 45–72 (1989)
			
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
	
	*Create event time study variables
		foreach var of varlist emp_index {

			bysort st_born2: gen `var'_1=`var'[_n-1]
			bysort st_born2: gen `var'_2=`var'[_n-2]
			bysort st_born2: gen `var'_3=`var'[_n-3]
			bysort st_born2: gen `var'1=`var'[_n+1]
			bysort st_born2: gen `var'2=`var'[_n+2]
			bysort st_born2: gen `var'3=`var'[_n+3]
			bysort st_born2: gen `var'4=`var'[_n+4]
			bysort st_born2: gen `var'5=`var'[_n+5]
			bysort st_born2: gen `var'6=`var'[_n+6]

		}

	*Label variables
		label var emp_index "Employment index in the YOB (t)"
		label var emp_index_1 "Employment index at t-1"
		label var emp_index_2 "Employment index at t-2"
		label var emp_index_3 "Employment index at t-3"
		label var emp_index1 "Employment index at t+1"
		label var emp_index2 "Employment index at t+2"
		label var emp_index3 "Employment index at t+3"
		label var emp_index4 "Employment index at t+4"
		label var emp_index5 "Employment index at t+5"
		label var emp_index6 "Employment index at t+6"
		
		label var birthyr "Year of birth"
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"
	
save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Employment_Index_Data_w_ETS_FINAL.dta", replace
