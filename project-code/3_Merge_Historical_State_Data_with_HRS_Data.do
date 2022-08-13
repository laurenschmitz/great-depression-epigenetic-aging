**************************************************************************************************************
***STEP THREE: MERGE IN STATE LEVEL HISTORICAL DATA***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off
				
	use "U:\Schmitz_Restricted\HRS_Long_Format_GD_Clocks_FINAL.dta"

		*Destring state variables for merge
			destring st_born, replace 
			destring st_age_ten, replace 
		
	**RECODE STATE BORN VARIABLE
		
		gen st_born2=st_born
			recode st_born2 (52=.) (53=.) (59=.) (97=.) (999=.)
			recode st_born2 (4=24) //Historical data missing for Arkansas; births in Arkansas were assigned to neighboring state (Mississippi) to avoid dropping these individuals
			replace st_born2=st_age_ten if st_born==999 | st_born==. //assign state lived in at age 10 if state of birth is missing
	
		rename st_age_ten child_state_id
			recode child_state_id (52=.) (53=.) (59=.) (97=.) (999=.)

	**MERGE IN EVENT TIME STUDY (ETS) DATA (NOTE: NEED TO RUN ETS DATA CREATION FILES BEFORE MERGING THESE IN)
		sort st_born2 birthyr
		
			joinby st_born2 birthyr using "U:\Duque_and_Schmitz\Data\Car_Sale_Index_Data_w_ETS_FINAL.dta", unmatched(master)   
				drop _merge
			
			joinby st_born2 birthyr using "U:\Duque_and_Schmitz\Data\Salary_Data_w_ETS_FINAL.dta", unmatched(master)		
				drop _merge
				
			joinby st_born2 birthyr using "U:\Duque_and_Schmitz\Data\Employment_Data_w_ETS_FINAL.dta", unmatched(master)
				drop _merge
								
	*MERGE IN ADDITIONAL STATE LEVEL DATA
		sort st_born2
		
			joinby st_born2 using "U:\Duque_and_Schmitz\Data\Maternal_Mortality_Rate_Data_FINAL.dta", unmatched(master)
				drop _merge
				sort st_born2 

			joinby st_born2 using "U:\Duque_and_Schmitz\Data\Census_Manf_Share_Data_FINAL.dta", unmatched(master)
				drop _merge
				sort st_born2 

			joinby st_born2 using "U:\Duque_and_Schmitz\Data\NBER_Infant_Mortality_Data_FINAL.dta", unmatched(master)   
				drop _merge
				sort st_born2	
			
			joinby st_born2 using "U:\Duque_and_Schmitz\Data\WWII_Mobilization_Rates_FINAL.dta", unmatched(master)
				drop _merge
				sort st_born2
			
			joinby st_born2 using "U:\Duque_and_Schmitz\Data\Proportion_Farmland_Census_of_Agriculture_FINAL.dta", unmatched(master)
				drop _merge	
				sort st_born2
			
			joinby st_born2 using "U:\Duque_and_Schmitz\Data\New_Deal_Spending_Data_FINAL.dta", unmatched(master)
				drop _merge
						
		sort hhidpn year

	save "U:\Schmitz_Restricted\HRS_Panel_GD_Clock_FINAL.dta", replace

