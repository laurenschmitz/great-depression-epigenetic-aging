**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO RURAL ELECTRIFICATION AND CLIMATE DATA***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Climate and Rural Electrification Data

		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_Fishback_Electrification_Climate_Data.dta" 
			*Data source: Fishback, Price, and Kantor, Shawn. New Deal Studies: Weather  Demography  and the New Deal. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2018-11-18. https://doi.org/10.3886/E101199V1-124306

			sort state year
			
			*Aggregate data from the county-year level to the state-year level for analysis
				bysort state year: egen sum_aclrea=sum(aclrea)
				bysort state year: egen avg_tmaxo90=mean(tmaxo90)
				bysort state year: egen avg_tminu0=mean(tminu0)
				bysort state year: egen avg_pcpavg=mean(pcpavg)

					collapse (mean) sum_aclrea avg_tmaxo90 avg_tminu0 avg_pcpavg, by(state year)
								
			*Label states: recode from ICPR state code to state name so we can merge with HRS state of birth variable
				gen st_born_name="."
					replace st_born_name="Alabama" if state==41
					replace st_born_name="Alaska" if state==81
					replace st_born_name="Arizona" if state==61
					replace st_born_name="Arkansas" if state==42
					replace st_born_name="California" if state==71
					replace st_born_name="Colorado" if state==62
					replace st_born_name="Connecticut" if state==1
					replace st_born_name="Delaware" if state==11
					replace st_born_name="Florida" if state==43
					replace st_born_name="Georgia" if state==44
					replace st_born_name="Hawaii" if state==82
					replace st_born_name="Idaho" if state==63
					replace st_born_name="Illinois" if state==21
					replace st_born_name="Indiana" if state==22
					replace st_born_name="Iowa" if state==31
					replace st_born_name="Kansas" if state==32
					replace st_born_name="Kentucky" if state==51
					replace st_born_name="Louisiana" if state==45
					replace st_born_name="Maine" if state==2
					replace st_born_name="Maryland" if state==52
					replace st_born_name="Massachusetts" if state==3
					replace st_born_name="Michigan" if state==23
					replace st_born_name="Minnesota" if state==33
					replace st_born_name="Mississippi" if state==46
					replace st_born_name="Missouri" if state==34
					replace st_born_name="Montana" if state==64
					replace st_born_name="Nebraska" if state==35
					replace st_born_name="Nevada" if state==65
					replace st_born_name="New Hampshire" if state==4
					replace st_born_name="New Jersey" if state==12
					replace st_born_name="New Mexico" if state==66
					replace st_born_name="New York" if state==13
					replace st_born_name="North Carolina" if state==47
					replace st_born_name="North Dakota" if state==36
					replace st_born_name="Ohio" if state==24
					replace st_born_name="Oklahoma" if state==53
					replace st_born_name="Oregon" if state==72
					replace st_born_name="Pennsylvania" if state==14
					replace st_born_name="Rhode Island" if state==5
					replace st_born_name="South Carolina" if state==48
					replace st_born_name="South Dakota" if state==37
					replace st_born_name="Tennessee" if state==54
					replace st_born_name="Texas" if state==49
					replace st_born_name="Utah" if state==67
					replace st_born_name="Vermont" if state==6
					replace st_born_name="Virginia" if state==40
					replace st_born_name="Washington" if state==73
					replace st_born_name="West Virginia" if state==56
					replace st_born_name="Wisconsin" if state==25
					replace st_born_name="Wyoming" if state==68
					replace st_born_name="District of Columbia" if state==55
			
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
				rename year birthyr

			sort st_born2 birthyr 
	
		*Generate natural log of total rural electrification loans
			gen sum_aclrea_r=sum_aclrea
				recode sum_aclrea_r (0=1)
					gen ln_aclrea=ln(sum_aclrea_r)

		*Drop variables not needed
			drop state sum_aclrea_r sum_aclrea

		*Label variables
			label var avg_tminu0 "Average number of days below 0 degrees F (state-level)"
			label var avg_tmaxo90 "Average number of days above 90 degrees F (state-level)"
			label var avg_pcpavg "Average inches of precipitation per year (state-level)"
			label var ln_aclrea "Log of total rural electrification loans (state-level)"
			
			label var birthyr "Year of birth"
			label var st_born_name "State of birth name"
			label var st_born2 "HRS state of birth code"

		sort st_born2 birthyr
		order st_born_name st_born2 birthyr
		
	save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Fishback_Electrification_Climate_Data_FINAL.dta", replace

