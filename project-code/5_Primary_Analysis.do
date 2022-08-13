**************************************************************************************************************
***STEP FIVE: PRIMARY ANALYSIS***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

use "U:\Duque_and_Schmitz\Data\HRS_Panel_GD_Clock_Cleaned_w_ETS_Vars_FINAL.dta", clear

***MODEL COVARIATES***
		global mclock1 "i.birthyr i.st_born2"
		global mclock2 "female i.race i.birthyr i.st_born2"
		global mclock3 "female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2"
		global mclock4 "female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2 c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr"
		global mclock5 "female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2 c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr i.birthplace#c.birthyr"

***SET SAMPLE SIZE***
	
	*WAGE INDEX MODELS
		reg grimage_eaa salariesi_32 salaries_iu2 salariesi12_avg salariesi34_avg salariesi56_avg salariesi78_avg salariesi910_avg salariesi1112_avg salariesi1314_avg salariesi1516_avg female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2 c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr i.birthyr#i.birthplace if year==2016 & birthyr>=1929 & birthyr<=1940 [aw=vbsi16wgtra], cl(st_born2)    
			gen samp_1940=1 if e(sample) //sample born between 1929-1940 with three years of pretrend data (i.e., sample born between 1932-1940)
	
	*WALLIS & CAR SALES INDEX MODELS
		reg grimage_eaa emp_index_32 emp_index_iu2 emp_index12 female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2 c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr i.birthyr#i.birthplace if year==2016 & birthyr>=1929 & birthyr<=1940 [aw=vbsi16wgtra], cl(st_born2)    
			gen emp_1940=1 if e(sample) //sample born between 1929-1940 with three years of pretrend data and 2 years of childhood data (i.e., sample born between 1932-1938 because Wallis data ends in 1940)

***FLIP SIGN OF EXPOSURE VARIABLES SO INCREASE IS REFLECTING A DECLINE IN WAGES, EMPLOYMENT, AND CAR SALES***
        
	gen salaries_iu2f=salaries_iu2*(-1)
		gen salariesi_32f=salariesi_32*(-1)
		gen salariesi12_avgf=salariesi12_avg*(-1)
		gen salariesi34_avgf=salariesi34_avg*(-1)
		gen salariesi56_avgf=salariesi56_avg*(-1)
		gen salariesi78_avgf=salariesi78_avg*(-1)
		gen salariesi910_avgf=salariesi910_avg*(-1)
		gen salariesi1112_avgf=salariesi1112_avg*(-1)
		gen salariesi1314_avgf=salariesi1314_avg*(-1)
		gen salariesi1516_avgf=salariesi1516_avg*(-1)
	
	gen salaries_iu3f=salaries_iu3*(-1)
	
	gen emp_index_iu2f=emp_index_iu2*(-1)
		gen emp_index_32f=emp_index_32*(-1)
		gen emp_index12f=emp_index12*(-1)
 	
	gen car_sales_iu2f=car_sales_iu2*(-1)
		gen car_salesi_32f=car_salesi_32*(-1)
		gen car_salesi12f=car_salesi12*(-1)
			
			
*********************************************************************************************************************************************************************************
***TABLE 1: EFFECT OF WAGE INDEX DECLINES IN UTERO ON EAA AND PACE OF AGING***
*********************************************************************************************************************************************************************************

	foreach var of varlist horvath_eaa horvath2_eaa hannum_eaa levine_eaa grimage_eaa poam {				
									
		reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
					
			}

*********************************************************************************************************************************************************************************
***TABLE 2: EFFECT OF WAGE INDEX DECLINES IN UTERO ON GRIMAGE EAA AND POAM, INVERSE PROBABILITY WEIGHTED (IPW) ESTIMATES***
*********************************************************************************************************************************************************************************

	***IPW ANALYSIS***
	
		*Generate mother's education dummy that sets missings=no degree for IPW analysis 
			gen meduc_no_deg3=. 
				replace meduc_no_deg3=1 if meduc<12 
				replace meduc_no_deg3=0 if meduc>=12 & meduc<.
				replace meduc_no_deg3=1 if meduc==.
	
			global ipw_a "female i.race i.birthyr i.st_born2"
			global ipw_b "female i.race i.birthyr i.st_born2 meduc_no_deg3 m_no_deg_salaries"
		
		*1) Survival until 2016
			
			sort hhidpn year
			
				gen surv_2016=.
					replace surv_2016=1 if dead==0 & year==2016
					replace surv_2016=0 if dead==1 & year==2016

						*Generate IPW weights without mother's education
							 probit surv_2016 salaries_iu2 $ipw_a if birthyr>=1929 & birthyr<=1940, cl(st_born2) //NOTE: sample size is higher here than other survival regressions in the mortality analysis table because we don't use weights   
								 predict p_surv2016a, pr
									 gen w_2016a=.
										 replace w_2016a=1/p_surv2016a if surv_2016==1
						*Generate IPW weights with mother's education
							 probit surv_2016 salaries_iu2 $ipw_b if birthyr>=1929 & birthyr<=1940, cl(st_born2)   
								 predict p_surv2016b, pr
									 gen w_2016b=.
										 replace w_2016b=1/p_surv2016b if surv_2016==1
							
			*2) Survival until age 75 (minimum age of sample)
				
				*Generate IPW weights without mother's education
					  probit surv75 salaries_iu2 $ipw_a if obs==1 & birthyr>=1929 & birthyr<=1940, cl(st_born2)   
						predict p_surv75a, pr
							gen w_75a=.
								replace w_75a=1/p_surv75a if surv75==1
									by hhidpn: carryforward w_75a, replace
				
				*Generate IPW weights with mother's education
					  probit surv75 salaries_iu2 $ipw_b if obs==1 & birthyr>=1929 & birthyr<=1940, cl(st_born2)   
						predict p_surv75b, pr
							gen w_75b=.
								replace w_75b=1/p_surv75b if surv75==1
									by hhidpn: carryforward w_75b, replace
			
			*IPW Analysis
				
				sort hhidpn year
				
					foreach var of varlist grimage_eaa poam {	
						
						reg `var' salaries_iu2f $mclock5 if samp_1940==1 [pweight=w_2016a], cl(st_born2)   
							outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\IPW_ESTIMATES_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(2016 weights, X)
						
						reg `var' salaries_iu2f $mclock5 if samp_1940==1 [pweight=w_2016b], cl(st_born2)   
							outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\IPW_ESTIMATES_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(2016 weights with meduc, X)

						reg `var' salaries_iu2f $mclock5 if samp_1940==1 [pweight=w_75a], cl(st_born2)   
							outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\IPW_ESTIMATES_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(75 weights, X)
						
						reg `var' salaries_iu2f $mclock5 if samp_1940==1 [pweight=w_75b], cl(st_born2)   
							outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\IPW_ESTIMATES_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(75 weights with meduc, X)

							}

*********************************************************************************************************************************************************************************
***FIGURE 2: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON GRIMAGE EAA AND POAM***
*********************************************************************************************************************************************************************************		
			
	foreach var of varlist grimage_eaa poam {		
	
		reg `var' salariesi_32f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_ETS_IU2_MODEL_FLIPPED_NF.xls", append keep(salariesi_32f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)		
			
			}

*********************************************************************************************************************************************************************************
***TABLE S2: SUMMARY STATISTICS***
*********************************************************************************************************************************************************************************
	
	*SUMMARY STATS FOR SAMPLE
		global vars "salaries_iu2 emp_index_iu2 car_sales_iu2 horvath_eaa horvath2_eaa hannum_eaa levine_eaa grimage_eaa poam birthyr ageyrs female white black other_race hispanic nodeg gedhs somecoll bach meduc_no_deg meduc_hs_plus meduc_md"
		global exposures "salariesi_32f salaries_iu2f salaries_iu3f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf emp_index_32f emp_index_iu2f emp_index12f car_salesi_32f car_sales_iu2f car_salesi12f"
		global other "prefrail met_index4_std selfhealth num_chronic avg_tmaxo90 avg_tminu0 sum_preciptot avg_pcpavg ln_aclrea nsibs famsize nsibs pmono plymp peos pbaso db_st nd_75 high_mob"
		
	*SUMMARY STATS, ETS SAMPLE 
		eststo sum_all: quietly estpost summarize $vars $exposures $other [aw=vbsi16wgtra] if samp_1940==1 

			esttab _all using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\SUM_STATS_FINAL.csv", replace plain cells("mean sd min max count")
				eststo clear 

*********************************************************************************************************************************************************************************
***TABLE S3: EFFECT OF WAGE INDEX DECLINES IN UTERO ON GRIMAGE EAA AND POAM ACROSS EMPIRICAL SPECIFICATIONS***
*********************************************************************************************************************************************************************************

		foreach var of varlist grimage_eaa poam {				
					
			reg `var' salaries_iu2f $mclock1 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_BY_SPECIFICATION_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X)
			
			reg `var' salaries_iu2f $mclock2 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_BY_SPECIFICATION_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X)
			
			reg `var' salaries_iu2f $mclock3 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_BY_SPECIFICATION_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X)
			
			reg `var' salaries_iu2f $mclock4 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_BY_SPECIFICATION_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X)
			
			reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_BASELINE_IU_MODEL_BY_SPECIFICATION_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
					
				}

*********************************************************************************************************************************************************************************
***TABLE S4: EFFECT OF EMPLOYMENT INDEX DECLINES ON GRIMAGE EAA AND POAM***
*********************************************************************************************************************************************************************************		

	foreach var of varlist grimage_eaa poam {	
		
		reg `var' emp_index_32f emp_index_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_EMPLOYMENT_INDEX_MODELS_FLIPPED_NF.xls", append keep(emp_index_32f emp_index_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
		
		reg `var' emp_index_32f emp_index_iu2f $mclock5 if emp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_EMPLOYMENT_INDEX_MODELS_FLIPPED_NF.xls", append keep(emp_index_32f emp_index_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
							
		reg `var' emp_index_32f emp_index_iu2f emp_index12f $mclock5 if emp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_EMPLOYMENT_INDEX_MODELS_FLIPPED_NF.xls", append keep(emp_index_32f emp_index_iu2f emp_index12f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)				
	
			}
	
*********************************************************************************************************************************************************************************
***TABLE S5: EFFECT OF CAR SALE INDEX DECLINES ON GRIMAGE EAA AND POAM***
*********************************************************************************************************************************************************************************				

	foreach var of varlist grimage_eaa poam {	
		
		reg `var' car_salesi_32f car_sales_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_CAR_SALES_INDEX_MODELS_FLIPPED_NF.xls", append keep(car_salesi_32f car_sales_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
		
		reg `var' car_salesi_32f car_sales_iu2f $mclock5 if emp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_CAR_SALES_INDEX_MODELS_FLIPPED_NF.xls", append keep(car_salesi_32f car_sales_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
							
		reg `var' car_salesi_32f car_sales_iu2f car_salesi12f $mclock5 if emp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\CLOCK_EAA_CAR_SALES_INDEX_MODELS_FLIPPED_NF.xls", append keep(car_salesi_32f car_sales_iu2f car_salesi12f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var')  addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)				
	
			}

*********************************************************************************************************************************************************************************
***TABLE S6: WAGE INDEX ESTIMATES THAT ACCOUNT FOR WHITE BLOOD CELL PROPORTIONS***
*********************************************************************************************************************************************************************************
	
	foreach var of varlist grimage_eaa poam {			
			
		reg `var' salaries_iu2f pmono plymp peos pbaso i.birthyr#c.pmono i.birthyr#c.plymp i.birthyr#c.peos i.birthyr#c.pbaso $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\CELL_PROPORTIONS.xls", append keep(salaries_iu2f pmono plymp peos pbaso) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X, Cell Proportions*YOB LTT, X)
	
			}

*********************************************************************************************************************************************************************************
***TABLE S7: WAGE INDEX ESTIMATES THAT OMIT EPIGENETIC AGING OUTLIERS (TOP AND BOTTOM 1%)***
*********************************************************************************************************************************************************************************
	
		foreach var of varlist grimage_eaa {			
	
			reg `var' salaries_iu2f $mclock5 if samp_1940==1 & grimage_eaa>-7.898481 & grimage_eaa<12.42698 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\REMOVING_OUTLIERS.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				}

		foreach var of varlist poam {			
	
			reg `var' salaries_iu2f $mclock5 if samp_1940==1 & poam>.85991 & poam<1.30404 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\REMOVING_OUTLIERS.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				}

*********************************************************************************************************************************************************************************
***TABLE S8: WAGE INDEX ESTIMATES THAT ACCOUNT FOR POPULATION STRATIFICATION***
*********************************************************************************************************************************************************************************

	*ESTIMATED IN EUROPEAN ANCESTRY SUB-SAMPLE
		
		global pcs_ssgac "pc1_ssgac pc2_ssgac pc3_ssgac pc4_ssgac pc5_ssgac pc6_ssgac pc7_ssgac pc8_ssgac pc9_ssgac pc10_ssgac c.pc1_ssgac#c.salaries_iu2 c.pc2_ssgac#c.salaries_iu2 c.pc3_ssgac#c.salaries_iu2 c.pc4_ssgac#c.salaries_iu2 c.pc5_ssgac#c.salaries_iu2 c.pc6_ssgac#c.salaries_iu2 c.pc7_ssgac#c.salaries_iu2 c.pc8_ssgac#c.salaries_iu2 c.pc9_ssgac#c.salaries_iu2 c.pc10_ssgac#c.salaries_iu2"
				
			foreach var of varlist grimage_eaa poam {			
		
				reg `var' salaries_iu2f $mclock5 $pcs_ssgac if samp_1940==1 & race==1 & hispanic==0 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\EUROPEAN_ANCESTRY_PCs.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
			
					}

*********************************************************************************************************************************************************************************
***TABLE S9: EFFECT OF THE WAGE INDEX IN UTERO AND BEING BORN IN A DUST BOWL STATE ON GRIMAGE AND POAM***
*********************************************************************************************************************************************************************************

	*GENERATE DB STATE DUMMIES
		gen db_st=0 //strictly Dustbowl states
			replace db_st=1 if st_born2==6|st_born2==31|st_born2==43|st_born2==36|st_born2==16
				*New Mexico, Colorado, Oklahoma, Kansas, Texas
	
	*GENERATE INTERACTION TERM
		gen db_st_salaries_iu2f=db_st*salaries_iu2f
			
			foreach var of varlist grimage_eaa poam {			
		
				reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\DUST_BOWL_ANALYSIS.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				reg `var' salaries_iu2f db_st db_st_salaries_iu2 $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\DUST_BOWL_ANALYSIS.xls", append keep(salaries_iu2f db_st db_st_salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

					}

*********************************************************************************************************************************************************************************
***TABLE S10: EFFECT OF WAGE INDEX DECLINES IN UTERO AND NEW DEAL SPENDING ON GRIMAGE EAA AND POAM***
*********************************************************************************************************************************************************************************
	
	*NEW DEAL RESULTS USING CROSS-SECTIONAL DATA (TOTAL NEW DEAL INVESTMENT IN THE 1930s)
		sum total_relief_pc_cs if samp_1940==1, d
			gen nd_75=.
				replace nd_75=1 if total_relief_pc_cs>=249.9838 & total_relief_pc_cs<.
				replace nd_75=0 if total_relief_pc_cs<249.9838
					
		*Interaction variable for outreg:
			gen salaries_nd_75f=salaries_iu2f*nd_75 

				foreach var of varlist grimage_eaa poam {			

					reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
						outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\NEW_DEAL_ANALYSIS.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
				
					reg `var' salaries_iu2f nd_75 salaries_nd_75f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
						outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\NEW_DEAL_ANALYSIS.xls", append keep(salaries_iu2f nd_75 salaries_nd_75f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
						
						}
			
*********************************************************************************************************************************************************************************
***TABLE S11: EFFECT OF WAGE INDEX DECLINES IN UTERO AND WWII MOBILIZATION RATES ON GRIMAGE EAA AND POAM***
*********************************************************************************************************************************************************************************

	*Generate high state mobilization dummy		
		gen high_mob=0 //
			replace high_mob=1 if st_born2==7 | st_born2==32 | st_born2==35 | st_born2==16 | st_born2==9 | st_born2==36 | st_born2==48 | st_born2==3 | st_born2==26 | st_born2==28 | st_born2==31 | st_born2==50 | st_born2==5 | st_born2==6 | st_born2==12 | st_born2==13 | st_born2==19 | st_born2==21 | st_born2==29 | st_born2==30 | st_born2==37 | st_born2==38 | st_born2==39 | st_born2==44 | st_born2==47  
			*high_mob=1: state had a mobilization rate above the national average
				*States with high_mob=1: Connecticut, New York, Ohio, Kansas, Florida, Oklahoma, West Virginia, Arizona, Montana, Nevada, New Mexico, California, Colorado, Idaho, Illinois, Maine, Massachusetts, New Hampshire, New Jersey, Oregon, Pennsylvania, Rhode Island, Utah, Washington, and Wyoming
		
	*Generate interaction variables for outreg
		gen highmob_x_sal_iu2f=high_mob*salaries_iu2f
				
			foreach var of varlist grimage_eaa poam {			
		
				reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\WWII_MOBILIZATION_ANALYSIS.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				reg `var' salaries_iu2f high_mob highmob_x_sal_iu2 $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\WWII_MOBILIZATION_ANALYSIS.xls", append keep(salaries_iu2f high_mob highmob_x_sal_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

					}

*********************************************************************************************************************************************************************************
***TABLES S12 & S13: ANALYSIS THAT INCLUDES EXPOSURES TO EXTREME WEATHER AND RURAL ELECTRIFICATION LOANS***
*********************************************************************************************************************************************************************************

	*Merge in data from Fishback that has been aggregated from the county level to the state level for this analysis
		sort st_born2 birthyr
	
		joinby st_born2 birthyr using "U:\Duque_and_Schmitz\Data\Fishback_Electrification_Climate_Data_FINAL.dta", unmatched(master)	
			drop _merge
	
			sort hhidpn year
	
		*Extrapolate 1933 data for 1932 and 1931 if born in Texas 
			replace sum_aclrea=0 if sum_aclrea==. & st_born2==43 & birthyr==1932
			replace st_aclrea_pc=0 if st_aclrea_pc==. & st_born2==43 & birthyr==1932
			replace avg_tmaxo90=113.1575 if avg_tmaxo90==. & st_born2==43 & birthyr==1932
			replace avg_tminu0=1.066929 if avg_tminu0==. & st_born2==43 & birthyr==1932
			replace ln_aclrea=0 if ln_aclrea==. & st_born2==43 & birthyr==1932
			replace avg_pcpavg=2.152408 if avg_pcpavg==. & st_born2==43 & birthyr==1932
			replace sum_preciptot=7027.74 if sum_preciptot==. & st_born2==43 & birthyr==1932
	

		foreach var of varlist grimage_eaa poam {			
		
				reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\TEMP_RURAL_ELECTRIFICATION_FLIPPED.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				reg `var' salaries_iu2f ln_aclrea $mclock5 if samp_1940==1  [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\TEMP_RURAL_ELECTRIFICATION_FLIPPED.xls", append keep(salaries_iu2f ln_aclrea) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				reg `var' salaries_iu2f avg_tmaxo90 $mclock5 if samp_1940==1  [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\TEMP_RURAL_ELECTRIFICATION_FLIPPED.xls", append keep(salaries_iu2f avg_tmaxo90) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

				reg `var' salaries_iu2f avg_tminu0 $mclock5 if samp_1940==1  [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\TEMP_RURAL_ELECTRIFICATION_FLIPPED.xls", append keep(salaries_iu2f avg_tminu0) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
				
				reg `var' salaries_iu2f avg_pcpavg $mclock5 if samp_1940==1  [aw=vbsi16wgtra], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\TEMP_RURAL_ELECTRIFICATION_FLIPPED.xls", append keep(salaries_iu2f avg_pcpavg) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

					}

*********************************************************************************************************************************************************************************
***TABLE S14: EFFECT OF WAGES INDEX DECLINES IN UTERO AND MATERNAL EDUCATION ON THE PROBABILITY OF SURVIVAL***
*********************************************************************************************************************************************************************************
	
	*Generate probability of survival by age 65, 75, and 85 variables
		sort hhidpn year
		
		by hhidpn: egen agedeath=max(death_age)
			replace agedeath=100 if agedeath==. 
				
			sort hhidpn year
				bysort hhidpn: gen obs=_n 
								
				gen surv65=1 if agedeath>=65 & obs==1
					replace surv65=0 if agedeath<65 & obs==1
				
				gen surv75=1 if agedeath>=75 & obs==1
					replace surv75=0 if agedeath<75 & obs==1

				gen surv85=1 if agedeath>=85 & obs==1
					replace surv85=0 if agedeath<85 & obs==1
				
		*Generate interaction variable for analysis
			gen m_no_deg_salariesf=meduc_no_deg3*salaries_iu2f
					
		*Analysis
			foreach var of varlist surv65 surv75 surv85 {				
									
				reg `var' salaries_iu2f $mclock2 if obs==1 & birthyr>=1929 & birthyr<=1940 [aw=rwght], cl(st_born2)   
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\MORTALITY_SELECTION_ANALYSIS.xls", append keep(salaries_iu2f) nocons br dec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X)
				
				reg `var' salaries_iu2f meduc_no_deg3 m_no_deg_salariesf $mclock2 if obs==1 & birthyr>=1929 & birthyr<=1940 [aw=rwght], cl(st_born2)   
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\MORTALITY_SELECTION_ANALYSIS.xls", append keep(salaries_iu2f meduc_no_deg3 m_no_deg_salariesf) nocons br dec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X)

					}
											
*********************************************************************************************************************************************************************************
***TABLE S15: EFFECT OF WAGES INDEX DECLINES IN UTERO ON CAUSE OF DEATH PROBABILITIES***
*********************************************************************************************************************************************************************************
				
	foreach var of varlist cod_heart cod_met cod_digsys cod_neuro cod_psych {				
				
		reg `var' salaries_iu2f $mclock3 if obs==1 & birthyr>=1929 & birthyr<=1940 [aw=rwght], cl(st_born2)   
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\CAUSE_OF_DEATH_ANALYSIS.xls", append keep(salaries_iu2f) nocons br dec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X)

			}
		
*********************************************************************************************************************************************************************************
***TABLE S18: EFFECT OF WAGE INDEX DECLINES IN UTERO ON OTHER AGING OUTCOMES***
*********************************************************************************************************************************************************************************
				
	foreach var of varlist prefrail met_index4_std selfhealth num_chronic {			
	
		reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\OTHER_AGING_MEASURES_FLIPPED_NF.xls", append keep(salaries_iu2f) stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)

			}

*********************************************************************************************************************************************************************************
***TABLE S19: ASSOCIATION BETWEEN AGING MEASURES IN 2016 AND THE PROBABILITY OF DEATH IN 2018***
*********************************************************************************************************************************************************************************
	
	*Generate variable in 2016=1 if died in 2018
		sort hhidpn year
			
			by hhidpn: gen dead_2018=dead[_n+1] 
				
	foreach var of varlist grimage_eaa poam met_index4_std prefrail selfhealth num_chronic {
				
		reg dead_2018 `var' $mclock3 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL_NF\AGING_OUTCOMES_DEATH_2018_NF.xls", append keep(`var') stats(coef se pval) noparen nocons noaster bdec(4) sdec(4) pdec(5) ctitle(dead_2018) addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X)
				
			}
			
*********************************************************************************************************************************************************************************
***TABLE S20: EFFECT OF THE WAGE INDEX USING QUARTER OF BIRTH (QOB) TO DEFINE IN UTERO PERIOD***
*********************************************************************************************************************************************************************************
	
	*salaries_iu2f=weighted average based on month of birth 
	*salaries_iu3f=assigns wage index in t-1 if QOB=1 or 2 and wage index in time t if QOB=3 or 4 

		foreach var of varlist grimage_eaa poam {			
			
			reg `var' salaries_iu2f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\RESULTS_USING_QOB_FLIPPED.xls", append keep(salaries_iu2f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
			
			reg `var' salaries_iu3f $mclock5 if samp_1940==1 [aw=vbsi16wgtra], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\RESULTS_USING_QOB_FLIPPED.xls", append keep(salaries_iu3f) nocons br dec(4) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, Mother's Education, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB LTT, X, YOB*Region of Birth LTT, X)
			
			}


