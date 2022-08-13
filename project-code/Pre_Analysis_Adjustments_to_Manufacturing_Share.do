**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO CENSUS MANUFACTURING SHARE DATA in 1929***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Maternal Mortality Rates 

		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_Census_Labor_Force_Data_by_State.dta" 
			*Data source for the numerator of the manufacturing share: U.S. Census Bureau, 1930 Census: Manufacturers, 1929 Volume 3. Reports by States. Statistics for Industrial Areas, Counties, and Cities. (1933). Data were taken from the “Wage earners (average for the year)” column for 1929 for each state. 
			*Data source for the denominator of the manufacturing share: U.S. Census Bureau, 1930 Census: Volume 4. Occupations, by States. Reports by States, Giving Statistics for Cities of 25,000 or More. United States Summary. (1933). Data for each state were taken from Table 5, p. 18, Column 2, “Total gainfully occupied persons”
			
			*Assign HRS coding for state of birth for merge with HRS data
				generate st_born=.

					replace	st_born	=	1	if state==	"Alabama"
					replace	st_born	=	3	if state==	"Arizona"
					replace	st_born	=	4	if state==	"Arkansas"
					replace	st_born	=	5	if state==	"California"
					replace	st_born	=	6	if state==	"Colorado"
					replace	st_born	=	7	if state==	"Connecticut"
					replace	st_born	=	8	if state==	"Delaware"
					replace	st_born	=	9	if state==	"Florida"
					replace	st_born	=	10	if state==	"Georgia"
					replace	st_born	=	12	if state==	"Idaho"
					replace	st_born	=	13	if state==	"Illinois"
					replace	st_born	=	14	if state==	"Indiana"
					replace	st_born	=	15	if state==	"Iowa"
					replace	st_born	=	16	if state==	"Kansas"
					replace	st_born	=	17	if state==	"Kentucky"
					replace	st_born	=	18	if state==	"Louisiana"
					replace	st_born	=	19	if state==	"Maine"
					replace	st_born	=	20	if state==	"Maryland"
					replace	st_born	=	21	if state==	"Massachusetts"
					replace	st_born	=	22	if state==	"Michigan"
					replace	st_born	=	23	if state==	"Minnesota"
					replace	st_born	=	24	if state==	"Mississippi"
					replace	st_born	=	25	if state==	"Missouri"
					replace	st_born	=	26	if state==	"Montana"
					replace	st_born	=	27	if state==	"Nebraska"
					replace	st_born	=	28	if state==	"Nevada"
					replace	st_born	=	29	if state==	"New Hampshire"
					replace	st_born	=	30	if state==	"New Jersey"
					replace	st_born	=	31	if state==	"New Mexico"
					replace	st_born	=	32	if state==	"New York"
					replace	st_born	=	33	if state==	"North Carolina"
					replace	st_born	=	34	if state==	"North Dakota"
					replace	st_born	=	35	if state==	"Ohio"
					replace	st_born	=	36	if state==	"Oklahoma"
					replace	st_born	=	37	if state==	"Oregon"
					replace	st_born	=	38	if state==	"Pennsylvania"
					replace	st_born	=	39	if state==	"Rhode Island"
					replace	st_born	=	40	if state==	"South Carolina"
					replace	st_born	=	41	if state==	"South Dakota"
					replace	st_born	=	42	if state==	"Tennessee"
					replace	st_born	=	43	if state==	"Texas"
					replace	st_born	=	44	if state==	"Utah"
					replace	st_born	=	45	if state==	"Vermont"
					replace	st_born	=	46	if state==	"Virginia"
					replace	st_born	=	47	if state==	"Washington"
					replace	st_born	=	48	if state==	"West Virginia"
					replace	st_born	=	49	if state==	"Wisconsin"
					replace	st_born	=	50	if state==	"Wyoming"

			rename st_born st_born2
			rename state st_born_name
			
			sort st_born2 	

	*Create share of wage earners in manufacturing for 1929
		gen manf_share=manf_wage_earners/total_lf
	
	*Drop variables not needed
		drop manf_wage_earners total_lf
		
	*Label variables
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"
		label var manf_share "Share of wage earners in manufacturing, 1929"

save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Census_Manf_Share_Data_FINAL.dta", replace

