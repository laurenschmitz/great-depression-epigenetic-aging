**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO THE 1928 INFANT MORTALITY RATE DATA***	
	*Project: Early-life Exposure to the Great Depression and Long-term Health and Economic Outcomes
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
**************************************************************************************************************

clear
set more off

	*Import Infant Birth and Death Data from NBER 

		use "/Users/laurenschmitz/Dropbox/2023_ACTIVE_PROJECTS/Duque_&_Schmitz/Data/Raw_NBER_Infant_Birth_Death_Data.dta" 
			*Data source: D. Norton, Data on Infant Mortality and Births, 1920-1945. Natl. Bur. Econ. Res. (2007).
			*URL to data on NBER website: https://www.nber.org/research/data/vital-statistics-births-and-infant-mortality-1920-1945

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
			rename st_born st_born2
			
			sort st_born2 	

	*Interpolate 1929 infant deaths and births for Nevada, New Mexico, South Dakota, and Texas (missing values in 1928)
		replace infant_deaths_1928=86 if st_born_name=="Nevada"
		replace infant_deaths_1928=1651 if st_born_name=="New Mexico"
		replace infant_deaths_1928=813 if st_born_name=="South Dakota"
		replace infant_deaths_1928=8374 if st_born_name=="Texas"

		replace births_1928=1280 if st_born_name=="Nevada"
		replace births_1928=11348 if st_born_name=="New Mexico"
		replace births_1928=14111 if st_born_name=="South Dakota"
		replace births_1928=98429 if st_born_name=="Texas"

	*Create infant mortality per 1000 live births

		gen infmort1k_1928=(infant_deaths_1928/births_1928)*1000 

	*Drop variables not needed
		drop infant_deaths_1928 births_1928

	*Label variables
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"
		label var infmort1k_1928 "Infant mortality per 1000 births, 1928"
		
save "/Users/laurenschmitz/Dropbox/2023_ACTIVE_PROJECTS/Duque_&_Schmitz/NBER_Infant_Mortality_Data_FINAL.dta", replace

