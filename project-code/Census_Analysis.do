*****************************************************************************************************************************************************************
***CODE FOR CENSUS DATA ANALYSIS***	
	*Project: Early-life Exposure to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz 
	*Analyst: Vikas Gawai
	*Date updated: June 2023
*****************************************************************************************************************************************************************


*****************************************************************************************************************************************************************
***APPENDIX TABLE 14: ASSOCIATION BETWEEN WAGE INDEX DECLINES AND FEMALE FERTILITY IN THE 1930s***	
*****************************************************************************************************************************************************************

clear

clear mata 
clear matrix
set maxvar 30000


	*SET PROJECT DIRECTORIES
		*Project Directory *
			global projectdir "/Users/vikasgawai/Dropbox/Intergenerational_GD_Paper/GD"

		*Table Directory*
			global tabledir "$projectdir/analysis_vikas/table"

			cd "$projectdir"
			cd "$tabledir"
	
	*MERGE WAGE DATA WITH 1% 1940 CENSUS BY YEAR AND STATE OF BIRTH
		use "$projectdir/analysis_vikas/data/raw/Census_1940_with_GD_variables.dta"  

			joinby bstate year using "/Users/vikasgawai/Dropbox/Intergenerational_GD_Paper/GD/Salaries.dta", unmatched(master)  

		*CLEAN THE VARIABLES
		
			*Infant Mortality in '29 *
				gen temp = imort_tot if birthyr==1929
					bysort bstate : egen imort_tot29 = max(temp)
						drop temp  

			*Mother's mortality*
				gen temp = mmrate if birthyr==1929
					bysort bstate : egen mmrate29 = max(temp)
						drop temp  

			*Mother has high school education or above*
				gen meduc_hs=1 if meduc>=6 & meduc<.
					replace meduc_hs=0 if meduc<6 & meduc!= .


			*Reverse the sign of the wage index variable so it reflects declines in the wage index
				gen salaries_32f = salaries_32 * -1
				gen salaries_1f = salaries_1 * -1  

			*Generate missing variable dummies for age and marital status*

				replace hhmage_30=0 if hhmage_30==.
					gen hhmage_30_mis=(hhmage_30==.)

				replace hhmage_31_39=0 if hhmage_31_39==.
					gen hhmage_31_39_mis=(hhmage_31_39==.)

				replace hhmmarried=0 if hhmmarried==.
					gen hhmmarried_mis=(hhmmarried==.) 

			*Label Variables*
				label var salaries_1f "Wage Decline In-utero"  
				label var salaries_32f "Wage Decline Age -3 to -2"
				label var female "Female" 
				label var age "Age" 
				label var white "White"
				label var black "Black"
				label var hh_urban "Urban"
				label var hh_size "Hh Size"  
				label var hh_income "HH Income" 
				label var lhh_income "HH Log Income"  
				label var hhmage_30 "Mother Age <= 30"
				label var hhmage_31_39 "Mother Age 31-39"
				label var hhmmarried "Mother is Married"
				label var meduc_lths "Mother Edu < HS"
				label var meduc_hs "Mother Edu HS"  
				label var fpresent  "Father Present"
				label var fsiblings "Fertility Post GD Child"  

	*REGRESSION ANALYSIS
	
		*Outcome Varible*
			global outcomevars "fsiblings"  

		*Covariates*
			global covr "female white hhmage_30 hhmage_31_39 hhmmarried meduc_lths meduc_hs hh_urban"

		*Fixed Effects*
			global fixed_cov1 "i.year i.bstate i.region#i.year c.man75#i.year c.imort_tot29#i.year c.mmrate29#i.year"

		*Interaction with control variables*
			global treatcov_interct "c.salaries_1f##i.female c.salaries_1f##i.white c.salaries_1f##i.hhmage_30 c.salaries_1f##i.hhmage_30_mis c.salaries_1f##i.hhmage_31_39 c.salaries_1f##i.hhmage_31_39_mis c.salaries_1f##i.hhmmarried c.salaries_1f##i.hhmmarried_mis c.salaries_1f##i.meduc_lths c.salaries_1f##i.meduc_hs c.salaries_1f##i.hh_urban"

		*Regression analysis
			foreach var of varlist $outcomevars {

					*without interactions*

						reg `var' salaries_32f salaries_1f $fixed_cov1 if year > 1928 & year < 1941 & fsiblings<11, cl(bstate) 

							outreg2 using "$tabledir/fertilitypnas.xls", excel keep(salaries_32f salaries_1f) alpha(.01 , .05 , .1) addtext(Birth year FE, YES, Birth State FE, YES, Region FE X Birth Year FE, YES, Manuf.75 X Birth Year Trend, YES, Infant Mort. X Birth Year Trend, YES, Maternal Mort. X Birth Year Trend, YES) label br dec(5) nocons append 


					*with interactions*

						reg `var' salaries_32f salaries_1f $treatcov_interct $fixed_cov1 if year > 1928 & year < 1941 & fsiblings<11, cl(bstate) 

							outreg2 using "$tabledir/fertilitypnas.xls", excel keep(salaries_32f salaries_1f c.salaries_1f#1.female c.salaries_1f#1.white c.salaries_1f#1.black c.salaries_1f#1.hhmage_30 c.salaries_1f#1.hhmage_31_39 c.salaries_1f#1.hhmmarried c.salaries_1f#1.meduc_lths c.salaries_1f#1.meduc_hs c.salaries_1f#1.hh_urban) alpha(.01 , .05 , .1) addtext(Birth year FE, YES, Birth State FE, YES, Region FE X Birth Year FE, YES, Manuf.75 X Birth Year Trend, YES, Infant Mort. X Birth Year Trend, YES, Maternal Mort. X Birth Year Trend, YES ) label br dec(5) nocons append
							
							}

							
*****************************************************************************************************************************************************************
***APPENDIX TABLE 15: ASSOCIATION BETWEEN WAGE INDEX DECLINES AND SELECTIVE SURVIVAL AT BIRTH***	
*****************************************************************************************************************************************************************

 clear all
  set mem 300m
  set trace off
  set more off
  
	*OPEN DATA (1% representative sample of the 1940 Census)
		clear
			global mypath "$mipath\Census_1940"

		*Path Tree
			global Salaries "$mypath\Data\Salary_Data_w_ETS_FINAL.dta"  	
			global Mortality_mortality "$mypath\Data\Maternal_Mortality_Rate_Data_FINAL.dta" 
			global Manufacture_1929 "$mypath\Data\Census_Manf_Share_Data_FINAL.dta" 
			global Infant_mortality "$mypath\Data\NBER_Infant_Mortality_Data_FINAL.dta" 

	*GENERATE NEEDED VARIABLES
	
		drop year
		gen year=1940-age
		drop if year<1925
		sum year

		*Create Cohort Size
			gen female=(sex==2)
				bysort bstate year: egen cohort_size=count(female) 


		*Create Sex Ratio
			bysort bstate year: egen tot_fem=total(female) 
				gen male=(female==0)
			bysort bstate year: egen tot_male=total(male) 
				gen sex_ratio=tot_male/tot_fem


		*Collapse the data at the birth state and birth year level
			collapse (mean) sex_ratio  cohort_size , by (bstate year)


		*Create log(cohort_size) and log(sex_ratio)
			gen lcohort_size=log(cohort_size)
			gen lsex_ratio=log(sex_ratio)

	*MERGE DATA WITH WAGE INDEX AND STATE-LEVEL COVARIATES

		*Wage index data
			joinby bstate year using "Salaries" , unmatched(master)
				drop if bstate>56
				gen salaries_32=(salaries_3 + salaries_2)/2
				gen salaries_iu=(salaries_1 + salaries)/2
				gen salaries12=(salaries1 + salaries2)/2
				gen salaries34=(salaries3 + salaries4)/2
				gen salaries56=(salaries5 + salaries6)/2

		*Maternal mortality data
			drop _merge 
			joinby bstate year using "Mortality_mortality" , unmatched(master)
				gen mmrate_29= mmrate if year==1929
					bysort bstate: egen mmrate29=max(mmrate_29)
						drop mmrate_29



		*Merge with share of manufacturing data 
			drop _merge
			joinby bstate year using "Manufacture_1929" , unmatched(master)
			count
			bysort bstate: egen max_manf_share=max(manf_share) if year>1920&year<1950
				gen man75 =1 if max_manf_share>=.2750076&max_manf_share!=. 
					replace man75 =0 if max_manf_share<.2750076&max_manf_share!=. 

		*Drop duplicates 
			sort bstate year
				gen x=1 if bstate==45&bstate[_n-1]==45&year==year[_n-1]
					tab x,m
					drop if x==1

		*Create region of birth variables
			*New England: Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island, Vermont
			*Middle Atlantic: Delaware, Maryland, New Jersey, New York, Pennsylvania
			*South: Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, Missouri, North Carolina, South Carolina, Tennessee, Virginia, West Virginia
			*Midwest: Illinois, Indiana, Iowa, Kansas, Michigan, Minnesota, Nebraska, North Dakota, Ohio, South Dakota, Wisconsin
			*Southwest:	Arizona, New Mexico, Oklahoma, Texas
			*West: Alaska, California, Colorado, Hawaii, Idaho, Montana, Nevada, Oregon, Utah, Washington, Wyoming
				gen bregion=1 if bstate==9|bstate==23|bstate==25|bstate==33|bstate==44|bstate==50
					replace bregion=2 if bstate==10|bstate==24|bstate==34|bstate==36|bstate==42
					replace bregion=3 if bstate==1| bstate==5|bstate==12|bstate==13|bstate==21|bstate==22|bstate==28|bstate==29|bstate==37|bstate==45|bstate==47|bstate==51|bstate==54
					replace bregion=4 if bstate==17|bstate==18|bstate==19|bstate==20|bstate==26|bstate==27|bstate==31|bstate==38|bstate==39|bstate==45|bstate==55
					replace bregion=5 if bstate==4|bstate==35|bstate==40|bstate==48
					replace bregion=6 if bstate==6|bstate==8|bstate==16|bstate==30|bstate==32|bstate==41|bstate==49|bstate==53|bstate==56

	*RUN EMPIRICAL MODELS

		reghdfe lcohort_size salaries_32 salaries_iu , absorb(year bstate i.bregion#i.year) cl(bstate)

		reghdfe lsex_ratio salaries_32 salaries_iu , absorb(year bstate i.bregion#i.year) cl(bstate)


