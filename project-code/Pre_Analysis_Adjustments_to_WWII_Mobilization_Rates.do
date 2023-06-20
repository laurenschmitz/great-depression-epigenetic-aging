**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO WWII MOBILIZATION RATES***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Climate and Rural Electrification Data

		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_WWII_Mobilization_Rates.dta" 
			*Data source: D. Acemoglu, D. H. Autor, D. Lyle. Women, War, and Wages: The Effect of Female Labor Supply on the Wage Structure at Midcentury. J. Polit. Econ. 112, 497–551 (2004).

			rename statename st_born_name
			
			*Assign HRS state of birth variable to data according to st_born_name

				generate st_born=.

					replace	st_born=1	if st_born_name==	"Alabama"
					replace	st_born=3	if st_born_name==	"Arizona"
					replace	st_born=4	if st_born_name==	"Arkansas"
					replace	st_born=5	if st_born_name==	"California"
					replace	st_born=6	if st_born_name==	"Colorado"
					replace	st_born=7	if st_born_name==	"Connecticut"
					replace	st_born=8	if st_born_name==	"Delaware"
					replace	st_born=9	if st_born_name==	"Florida"
					replace	st_born=10	if st_born_name==	"Georgia"
					replace	st_born=12	if st_born_name==	"Idaho"
					replace	st_born=13	if st_born_name==	"Illinois"
					replace	st_born=14	if st_born_name==	"Indiana"
					replace	st_born=15	if st_born_name==	"Iowa"
					replace	st_born=16	if st_born_name==	"Kansas"
					replace	st_born=17	if st_born_name==	"Kentucky"
					replace	st_born=18	if st_born_name==	"Louisiana"
					replace	st_born=19	if st_born_name==	"Maine"
					replace	st_born=20	if st_born_name==	"Maryland"
					replace	st_born=21	if st_born_name==	"Massachusetts"
					replace	st_born=22	if st_born_name==	"Michigan"
					replace	st_born=23	if st_born_name==	"Minnesota"
					replace	st_born=24	if st_born_name==	"Mississippi"
					replace	st_born=25	if st_born_name==	"Missouri"
					replace	st_born=26	if st_born_name==	"Montana"
					replace	st_born=27	if st_born_name==	"Nebraska"
					replace	st_born=28	if st_born_name==	"Nevada"
					replace	st_born=29	if st_born_name==	"New Hampshire"
					replace	st_born=30	if st_born_name==	"New Jersey"
					replace	st_born=31	if st_born_name==	"New Mexico"
					replace	st_born=32	if st_born_name==	"New York"
					replace	st_born=33	if st_born_name==	"North Carolina"
					replace	st_born=34	if st_born_name==	"North Dakota"
					replace	st_born=35	if st_born_name==	"Ohio"
					replace	st_born=36	if st_born_name==	"Oklahoma"
					replace	st_born=37	if st_born_name==	"Oregon"
					replace	st_born=38	if st_born_name==	"Pennsylvania"
					replace	st_born=39	if st_born_name==	"Rhode Island"
					replace	st_born=40	if st_born_name==	"South Carolina"
					replace	st_born=41	if st_born_name==	"South Dakota"
					replace	st_born=42	if st_born_name==	"Tennessee"
					replace	st_born=43	if st_born_name==	"Texas"
					replace	st_born=44	if st_born_name==	"Utah"
					replace	st_born=45	if st_born_name==	"Vermont"
					replace	st_born=46	if st_born_name==	"Virginia"
					replace	st_born=47	if st_born_name==	"Washington"
					replace	st_born=48	if st_born_name==	"West Virginia"
					replace	st_born=49	if st_born_name==	"Wisconsin"
					replace	st_born=50	if st_born_name==	"Wyoming"

				rename st_born st_born2

			sort st_born2 
	
		*Label variables
			label var mobrate "WWII mobilization rate (state-level)"
			label var st_born_name "State of birth name"
			label var st_born2 "HRS state of birth code"

		order st_born_name st_born2 
		
	save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/WWII_Mobilization_Rates_FINAL.dta", replace

