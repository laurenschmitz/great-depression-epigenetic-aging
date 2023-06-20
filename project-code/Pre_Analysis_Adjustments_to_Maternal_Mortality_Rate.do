**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO MATERNAL MORTALITY RATE DATA in 1929***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Maternal Mortality Rates 

		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_Maternal_Mortality_Data.dta" 
			*Data source: 

			rename state st_born_name
			rename state_pc state
			keep state st_born_name year mmrate
			
			*Assign HRS coding for state of birth for merge with HRS data
				generate st_born=.

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

			rename st_born st_born2
			
			sort st_born2 	

	*Interpolate missing data for South Dakota and Texas in 1929 (use 1932 and 1933 rates, respectively)
		gen mmrate_1929=mmrate if year==1929
			replace mmrate_1929=70.67001 if st_born_name=="South Dakota" 
			replace mmrate_1929=138.6 if st_born_name=="Texas" 
	
	*Drop variables and years not needed
		collapse st_born2 mmrate_1929, by("st_born_name")

	*Label variables
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"
		label var mmrate_1929 "Maternal mortality rate in 1929"

save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Maternal_Mortality_Rate_Data_FINAL.dta", replace

