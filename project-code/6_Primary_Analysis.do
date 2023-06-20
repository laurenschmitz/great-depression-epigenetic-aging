
*********************************************************************************************************************************************************************************
***STEP 6: PRIMARY ANALYSIS***
	*Project: Early-life Exposures to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
*********************************************************************************************************************************************************************************

use "U:\Duque_and_Schmitz\Data\HRS_Great_Depression_FINAL_JHR.dta"
	
	*MODEL COVARIATES
		*M1: State, year, and YOB fixed effects
		*M2: M1 + Individual covariates 
		*M3: M2 + Birthplace*YOB LTT
		*M4: M3 + State-level covariate linear time trends
		*M5: M4 + Share of manufacturing*YOB fixed effects

			global m1 "i.st_born2 i.birthyr i.year"
			global m2 "ageyrs ageyrs2 female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr i.year"
			global m3 "ageyrs ageyrs2 female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr i.year i.birthplace#c.birthyr"
			global m4 "ageyrs ageyrs2 female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr i.year i.birthplace#c.birthyr c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr"
			global m5 "ageyrs ageyrs2 female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr i.year i.birthplace#c.birthyr c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr"							
			global m_earn "ageyrs ageyrs2 female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr"
					 		
	
*********************************************************************************************************************************************************************************
***TABLE 1: DESCRIPTIVE STATISTICS***
*********************************************************************************************************************************************************************************

	*GENERATE SAMPLE INDICATORS
		reg num_chronic salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if birthyr>=1929 & birthyr<=1940 [aw=rwght], vce(cluster st_born2)
			gen ncsamp=1 if e(sample)==1 //N=62,062 observations (longitudinal)
	
		reg num_chronic salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if birthyr>=1929 & birthyr<=1940 & inw_count==1 [aw=rwght], cl(st_born2)
			gen ncsamp_cs=1 if e(sample) //N=7,425 people 
			
		reg hc_index7_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if birthyr>=1929 & birthyr<=1940 & ageyrs>=50 & ageyrs<=65 & inw_count==1 [aw=rwght], cluster(st_born2)							
			gen hcsamp=1 if e(sample) //N=5,125 people

		reg lntot_earn40 salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf ever_imp $m_earn if birthyr>=1929 & birthyr<=1940 & inw_count==1 & lntot_earn40!=0 [aw=sswghtc_f], cl(st_born2)
			gen earnsamp=1 if e(sample) //N=5,530 people

	*SUMMARY STATISTICS TO CALCULATE FOR SAMPLE
		global vars "salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf emp_index_3f emp_index_iu2f emp_index12f yrseduc gedhsplus somecollplus bachplus hc_index7_std hh_wealth10 arf_min everwork_r iearn10 lniearn10 lprof lwc lbc lserve num_chronictot everpsych everhibp evercancer everlung everdiab everstroke everheart everarthr birthyr year ageyrs white black other_race female meduc_no_deg meduc_hs_plus meduc_md dadnolive_m dadnolive_md veteran rural_m rural_md"
			
	*SUMMARY STATISTICS (ALL)
		eststo sum_all: quietly estpost summarize $vars [aw=rwght] if ncsamp_cs==1 //main summary statistics (N=7,425)

			esttab _all using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\SUM_STATS.csv", replace plain cells("mean sd min max count")
				eststo clear 
	
	*SUMMARY STATS (ECONOMIC INDEX)
		eststo sum_all: quietly estpost summarize $vars [aw=rwght] if hcsamp==1 //summary statistics for economic index and related components (N=5,125)

			esttab _all using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\SUM_STATS_ECON_SAMP.csv", replace plain cells("mean sd min max count")
				eststo clear 
								
	*SUMMARY STATISTICS (LIFETIME EARNINGS, NON-ZERO EARNERS ONLY)
		global earn_vars "lntot_earn40 lntot_earn45 lntot_earn50 lntot_earn55 lntot_earn60 lntot_earn65 lntot_earn70"
		
			eststo sum_all: quietly estpost summarize $earn_vars [aw=sswghtc_f] if earnsamp==1 //summary statistics for accumulated earnings by age (N=5,530)
			
				esttab _all using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EARN_SUM_STATS.csv", replace plain cells("mean sd min max count")
					eststo clear 

					
*********************************************************************************************************************************************************************************
***ECONOMIC INDEX RESULTS: FIGURE 2, APPENDIX FIGURE 2, APPENDIX TABLE 1***
*********************************************************************************************************************************************************************************
	
	***FIGURE 2: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON THE ECONOMIC INDEX***
		
		reg hc_index7_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cluster(st_born2)							
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Economic Index") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
					xlabel(,angle(45)) ylabel(-0.02(0.005)0.015) scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX7_ETS_IU2f_CS.gph", replace
		
	***APPENDIX FIGURE 2: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON THE ECONOMIC INDEX AND ITS COMPONENTS***

		reg hc_index7_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Economic Index") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.02(0.005)0.015) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECONINDEX_ETS.gph", replace

		reg hh_wealth10_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Household Wealth (Standardized)") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.005(0.002)0.007) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\HHWEALTH_ETS.gph", replace
	
		reg lniearn10_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Log Individual Earnings") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.015(0.005)0.015) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\LNIEARN_ETS.gph", replace

		reg everwork_r salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)	
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Working Full or Part Time") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.006(0.002)0.005) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\WORKING_ETS.gph", replace

		reg lprof salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)		
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Longest Held Job in a" "Professional Occupation") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.004(0.0015)0.005) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\LPROF_ETS.gph", replace

		reg arf_min_std salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)		
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Age at Full Retirement") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.008(0.002)0.004) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ARF_ETS.gph", replace

				graph combine "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECONINDEX_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\HHWEALTH_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\LNIEARN_ETS" ///
					"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\WORKING_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\LPROF_ETS" ///
					"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ARF_ETS", com scheme(modern)
	
	***APPENDIX TABLE 1: EFFECT OF WAGE INDEX DECLINES ON THE ECONOMIC INDEX BY MODEL SPECIFICATION***
		
		foreach var of varlist hc_index7_std {	
		
			reg `var' salariesi_3f salaries_iu2f salariesi12_avgf $m1 if hcsamp==1 [aw=rwght], cl(st_born2)   
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX_RESULTS_BY_MODEL_IU2f_CS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf) nocons br dec(5) ctitle(ECON INDEX M1) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X)
			
			reg `var' salariesi_3f salaries_iu2f salariesi12_avgf $m2 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX_RESULTS_BY_MODEL_IU2f_CS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf) nocons br dec(5) ctitle(ECON INDEX M2) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X)
			
			reg `var' salariesi_3f salaries_iu2f salariesi12_avgf $m3 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX_RESULTS_BY_MODEL_IU2f_CS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf) nocons br dec(5) ctitle(ECON INDEX M3) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X)
			
			reg `var' salariesi_3f salaries_iu2f salariesi12_avgf $m4 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX_RESULTS_BY_MODEL_IU2f_CS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf) nocons br dec(5) ctitle(ECON INDEX M4) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X)
			
			reg `var' salariesi_3f salaries_iu2f salariesi12_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\ECON_INDEX_RESULTS_BY_MODEL_IU2f_CS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf) nocons br dec(5) ctitle(ECON INDEX M5) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
			
				}

				
*********************************************************************************************************************************************************************************
***NUMBER OF CHRONIC DISEASE CONDITION RESULTS: FIGURE 3, APPENDIX TABLE 2, APPENDIX FIGURE 3***
*********************************************************************************************************************************************************************************
		
	***FIGURE 3: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON THE NUMBER OF CHRONIC DISEASE CONDITIONS***
		
		reg num_chronictot salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Number of Chronic Conditions") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.015(0.005)0.025) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUMBER_CHRONIC_CONDITIONS_ETS_IU2f.gph", replace
		
	***APPENDIX TABLE 2: EFFECT OF WAGE INDEX DECLINES ON THE NUMBER OF CHRONIC DISEASE CONDITIONS BY MODEL SPECIFICATION***
		
		foreach var of varlist num_chronictot {	
		
			reg `var' salariesi_3f salaries_iu2f $m1 if ncsamp_cs==1 [aw=rwght], cl(st_born2)   
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUM_CHRONIC_RESULTS_BY_MODEL_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NUM CHRONIC M1) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X)
			
			reg `var' salariesi_3f salaries_iu2f $m2 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUM_CHRONIC_RESULTS_BY_MODEL_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NUM CHRONIC M2) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X)
			
			reg `var' salariesi_3f salaries_iu2f $m3 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUM_CHRONIC_RESULTS_BY_MODEL_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NUM CHRONIC M3) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X)
			
			reg `var' salariesi_3f salaries_iu2f $m4 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUM_CHRONIC_RESULTS_BY_MODEL_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NUM CHRONIC M4) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X)
			
			reg `var' salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUM_CHRONIC_RESULTS_BY_MODEL_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NUM CHRONIC M5) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		
				}
		
	***APPENDIX FIGURE 3: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON THE TOTAL NUMBER OF CHRONIC DISEASE CONDITIONS AND CHRONIC DISEASE COMPONENTS***
		reg num_chronictot salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Number of Chronic Conditions") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.025(0.01)0.025) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NCHRONIC_ETS.gph", replace

		reg everdiab salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Diabetes") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.004(0.0022)0.007) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERDIAB_ETS.gph", replace

		reg evercancer salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Cancer") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.005(0.002)0.005) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERCANCER_ETS.gph", replace

		reg everhibp salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with High Blood Pressure") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.002(0.0016)0.006) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERHIBP_ETS.gph", replace

		reg everheart salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Heart Problems") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.003(0.0018)0.006) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERHEART_ETS.gph", replace

		reg everpsych salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Psychiatric Problems") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.005(0.0018)0.004) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERPSYCH_ETS.gph", replace

		reg everarthr salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Arthritis") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.004(0.002)0.006) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERARTHR_ETS.gph", replace

		reg everlung salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with Chronic Lung Disease") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.004(0.0016)0.004) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERLUNG_ETS.gph", replace

		reg everstroke salariesi_32f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_32f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Diagnosed with a Stroke") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
				xlabel(,angle(45)) ylabel(-0.006(0.0022)0.005) scheme(modern)
					graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERSTROKE_ETS.gph", replace

					graph combine "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NCHRONIC_ETS.gph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERDIAB_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERLUNG_ETS" ///
						"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERHIBP_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERSTROKE_ETS" ///
						"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERPSYCH_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERHEART_ETS" ///
						"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERARTHR_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EVERCANCER_ETS", com scheme(modern)

						
*********************************************************************************************************************************************************************************
***CUMULATIVE EARNINGS RESULTS: TABLE 2***
*********************************************************************************************************************************************************************************			
		
	***TABLE 2: EFFECT OF WAGE INDEX DECLINES ON LOG ACCUMULTED EARNINGS BY AGE WITHOUT AND WITH CONTROLS FOR EDUCATION AND OCCUPATIONAL STATUS***
		
		*PANEL A
			foreach i of numlist 40 45 50 55 60 65 70 {
				reg lntot_earn`i' salariesi_3f salaries_iu2f ever_imp $m_earn if earnsamp==1 [aw=sswghtc_f], cl(st_born2)
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EARNINGS_BY_AGE_40_PLUS_IU2f.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(EARN`i') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
				}
										
		*PANEL B (WITH CONTROLS FOR YEARS OF EDUCATION AND OCCUPATIONAL STATUS) 		
			replace yrseduc=17 if yrseduc==.m & earnsamp==1 //1 person missing years of education info but has a law degree

			foreach i of numlist 40 45 50 55 60 65 70 {
				reg lntot_earn`i' salariesi_3f salaries_iu2f yrseduc lbc lserve ever_imp $m_earn if earnsamp==1 [aw=sswghtc_f], cl(st_born2)
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\EARNINGS_BY_AGE_40_PLUS_IU2f_EDUC_OCC.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(EARN`i') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
				}

*********************************************************************************************************************************************************************************
***EDUCATION RESULTS: FIGURE 5***
*********************************************************************************************************************************************************************************

	*FIGURE 5: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON EDUCATIONAL OUTCOMES

		reg yrseduc salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Years of Education") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
					xlabel(,angle(45)) ylabel(-0.04(0.015)0.04) scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\YRSED_ETS.gph", replace
		
		reg gedhsplus salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("GED/HS Degree or Higher") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
					xlabel(,angle(45)) ylabel(-0.008(0.002)0.005) scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\GEDHSPLUS_ETS.gph", replace

		reg somecollplus salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Associate Degree or Higher") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
					xlabel(,angle(45)) ylabel(-0.006(0.002)0.005) scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\SOMECOLLPLUS_ETS.gph", replace

		reg bachplus salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)				
			coefplot, drop(_cons) keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf salariesi56_avgf salariesi78_avgf salariesi910_avgf salariesi1112_avgf salariesi1314_avgf salariesi1516_avgf) vertical yline(0) ///
				title("Bachelor's Degree or Higher") xlabel(1 "Preconception" 2 "In Utero" 3 "Age 1-2" 4 "Age 3-4" 5 "Age 5-6" 6 "Age 7-8" 7 "Age 9-10" 8 "Age 11-12" 9 "Age 13-14" 10 "Age 15-16") ///
					xlabel(,angle(45)) ylabel(-0.006(0.002)0.005) scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\BACHPLUS_ETS.gph", replace

		graph combine "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\YRSED_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\GEDHSPLUS_ETS" ///
			"U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\SOMECOLLPLUS_ETS" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\BACHPLUS_ETS" , com scheme(modern)


*********************************************************************************************************************************************************************************
***RESULTS WITH EMPLOYMENT INDEX: APPENDIX TABLE 7***
*********************************************************************************************************************************************************************************

	*ECONOMIC INDEX
		foreach var of varlist hc_index7_std  {	
			reg `var' salariesi_3f salaries_iu2f $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ECON_INDEX_RESULTS_EMP_INDEX.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(WAGE INDEX) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
			reg `var' emp_index_3f emp_index_iu2f $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ECON_INDEX_RESULTS_EMP_INDEX.xls", append keep(emp_index_3f emp_index_iu2f) nocons br dec(5) ctitle(EMP INDEX) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		}
		
	*NUMBER OF CHRONIC DISEASE CONDITIONS
		foreach var of varlist num_chronictot  {	
			reg `var' salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\NCHRONIC_RESULTS_EMP_INDEX.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(WAGE INDEX) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
			reg `var' emp_index_3f emp_index_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\NCHRONIC_RESULTS_EMP_INDEX.xls", append keep(emp_index_3f emp_index_iu2f) nocons br dec(5) ctitle(EMP INDEX) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		}
		
		
*********************************************************************************************************************************************************************************
***TRAJECTORY RESULTS FOR FRAILTY AND CHRONIC DISEASES: FIGURE 3***
*********************************************************************************************************************************************************************************

	***FIGURE 3: EFFECT OF WAGE INDEX DECLINES IN UTERO ON FRAILTY AND THE NUMBER OF CHRONIC DISEASE CONDITIONS BY AGE***
		
		*GENERATE NUMBER OF CHRONIC DISEASE CONDITIONS FIGURE
			
			*Estimate average chronic diseases by age group
				sort hhidpn year
								
					by hhidpn: egen avgnc60_64=mean(num_chronic) if ageyrs>=60 & ageyrs<=64
						bysort hhidpn avgnc60_64: gen count60=_n 
						
					by hhidpn: egen avgnc65_69=mean(num_chronic) if ageyrs>=65 & ageyrs<=69
						bysort hhidpn avgnc65_69: gen count65=_n 
					
					by hhidpn: egen avgnc70_74=mean(num_chronic) if ageyrs>=70 & ageyrs<=74
						bysort hhidpn avgnc70_74: gen count70=_n 
													
			*Regression covariates
				global mtraj2 "female i.race rural_m rural_md meduc_no_deg meduc_hs meduc_md dadnolive_m dadnolive_md i.st_born2 i.birthyr i.year i.birthplace#c.birthyr c.infmort1k_1928#c.birthyr c.mmrate_1929#c.birthyr c.prop_farm75#c.birthyr c.manf_share75#i.birthyr"

			*Keep respondents who appear across all three age groups 
				reg avgnc60_64 salaries_iu2f salariesi12_avgf $mtraj2 if ncsamp==1 & count60==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					gen samp1=1 if e(sample)
						by hhidpn: egen samp1_r=mean(samp1)
		
				reg avgnc65_69 salaries_iu2f salariesi12_avgf $mtraj2 if ncsamp==1 & count65==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					gen samp2=1 if e(sample)
						by hhidpn: egen samp2_r=mean(samp2)
				
				reg avgnc70_74 salaries_iu2f salariesi12_avgf $mtraj2 if ncsamp==1 & count70==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					gen samp3=1 if e(sample)
						by hhidpn: egen samp3_r=mean(samp3)
				
				gen samp4=1 if samp1_r==1 & samp2_r==1 & samp3_r==1
					by hhidpn: egen samp5=mean(samp4)
				
			*Run regressions and generate figure 
				reg avgnc60_64 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count60==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age60
				reg avgnc65_69 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count65==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age65
				reg avgnc70_74 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count70==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age70
								
				coefplot (Age60, label (Age 60-64)) (Age65, label (Age 65-69)) (Age70, label (Age 70-74)) ///
					, keep(salaries_iu2f) vertical yline(0) ylabel(-0.01(0.006)0.02) ylabel(,angle(0)) xtitle("Wage index in utero coefficient") title("Number of Chronic Conditions by Age") nolabel scheme(modern)
						graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUMBER_CHRONIC_TRAJECTORY_IU2f.gph", replace		
							
				eststo clear

		*GENERATE FRAILTY FIGURE
			
			*Estimate frailty by age group			
				sort hhidpn year
				
				by hhidpn: egen avgfrl60_64=max(prefrail3) if ageyrs>=60 & ageyrs<=64
				by hhidpn: egen avgfrl65_69=max(prefrail3) if ageyrs>=65 & ageyrs<=69			
				by hhidpn: egen avgfrl70_74=max(prefrail3) if ageyrs>=70 & ageyrs<=74
									
			*Run regressions using sample overlap with number of chronic diseases and generate figure (N=3,954)
				reg avgfrl60_64 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count60==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age60
				reg avgfrl65_69 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count65==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age65
				reg avgfrl70_74 salaries_iu2f salariesi12_avgf $mtraj2 if samp5==1 & count70==1 & agedeath>=75 [aw=rwght], cl(st_born2)
					eststo Age70
				
					coefplot (Age60, label (Age 60-64)) (Age65, label (Age 65-69)) (Age70, label (Age 70-74)) ///
						, keep(salaries_iu2f) vertical yline(0) ylabel(-0.005(0.003)0.01) ylabel(,angle(0)) xtitle("Wage index in utero coefficient") title("Frailty Index by Age") nolabel scheme(modern)
							graph save "Graph" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\FRAILTY_TRAJECTORY_IU2f.gph", replace		
				
				eststo clear

		graph combine "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\FRAILTY_TRAJECTORY_IU2f" "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\10-27-22\NUMBER_CHRONIC_CONDITIONS_TRAJECTORY_IU2f", com scheme(modern) 


*********************************************************************************************************************************************************************************
***DUST BOWL RESULTS: APPENDIX TABLE 8 AND 9***
*********************************************************************************************************************************************************************************

	*GENERATE DB STATE DUMMIES
		sort hhidpn year
	
		gen all_db_st=0 //Dustbowl and surrounding states
			replace all_db_st=1 if st_born2==4|st_born2==6|st_born2==15|st_born2==16|st_born2==18|st_born2==23|st_born2==25|st_born2==26|st_born2==27|st_born2==31|st_born2==34|st_born2==36|st_born2==41|st_born2==43|st_born2==50
				*Arkansas, Colorado, Iowa, Kansas, Louisiana, Minnesota, Missouri, Montana, Nebraska, New Mexico, North Dakota, Oklahoma, South Dakota, Texas, Wyoming
		gen db_st=0 //strictly Dustbowl states
				replace db_st=1 if st_born2==6|st_born2==31|st_born2==43|st_born2==36|st_born2==16
				*New Mexico, Colorado, Oklahoma, Kansas, Texas

		*Average wage exposure: in utero through age 2
			gen salariesiu2f=(salaries_iu2f+salariesi12_avgf)/2

	*APPENDIX TABLE 8: EFFECT OF WAGE INDEX DECLINES ON THE ECONOMIC INDEX IN DUST BOWL AND NEIGHBORING STATES
		*Full Sample (All states)
			reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\DB_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*DB and Neighboring DB States Only
			reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf $m5 if hcsamp==1 & all_db_st==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\DB_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf) nocons br dec(5) ctitle(DB & NEIGHBORING STATES) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*Excluding DB and Neighboring DB States 
			reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf $m5 if hcsamp==1 & all_db_st==0 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\DB_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf) nocons br dec(5) ctitle(NON DB STATES) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)

	*APPENDIX TABLE 8: EFFECT OF WAGE INDEX DECLINES ON THE NUMBER OF CHRONIC DISEASE CONDITIONS IN DUST BOWL AND NEIGHBORING STATES
		*Full Sample (All states)
			reg num_chronictot salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\NCHRONIC_DB_RESULTS.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*DB and Neighboring DB States Only
			reg num_chronictot salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 & all_db_st==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\NCHRONIC_DB_RESULTS.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(DB & NEIGHBORING STATES) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*Excluding DB and Neighboring DB States 
			reg num_chronictot salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 & all_db_st==0 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\NCHRONIC_DB_RESULTS.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(NON DB STATES) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)

				
*********************************************************************************************************************************************************************************
***NEW DEAL RESULTS: APPENDIX TABLES 10 AND 11***
*********************************************************************************************************************************************************************************

		*Generate dummy equal to one if state was in the top quartile of New Deal investment spending in the 1930s
			sum total_relief_pc_cs if ncsamp_cs==1, d
				gen nd_75=. //create dummy indicating whether they lived in a state that was in the 75th percentile of ND spending in the 1930s
					replace nd_75=1 if total_relief_pc_cs>=249.9838 & total_relief_pc_cs<.
					replace nd_75=0 if total_relief_pc_cs<249.9838
				
		*Generate interaction variable for outreg
			gen salariesiu2f_75=salariesiu2f*nd_75
			gen salaries_iu2f_75=salaries_iu2f*nd_75
							
		*APPENDIX TABLE 10: EFFECT OF WAGE INDEX DECLINES AND NEW DEAL SPENDING ON THE ECONOMIC INDEX
			*Baseline
				reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ND_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
			*With interaction 
				reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf nd_75 salariesiu2f_75 $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ND_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf salariesiu2f_75 nd_75) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
				
		*APPENDIX TABLE 11: EFFECT OF WAGE INDEX DECLINES AND NEW DEAL SPENDING ON THE NUMBER OF CHRONIC DISEASE CONDITIONS
			*Baseline
				reg num_chronictot salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ND_NCHRONIC_RESULTS.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
			*With interaction 
				reg num_chronictot salariesi_3f salaries_iu2f nd_75 salaries_iu2f_75 $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
					outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\ND_NCHRONIC_RESULTS.xls", append keep(salariesi_3f salaries_iu2f salaries_iu2f_75 nd_75) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)

					
*********************************************************************************************************************************************************************************
***WWII MOBILIZATION RESULTS: APPENDIX TABLES 12 AND 13***
*********************************************************************************************************************************************************************************

	*Generate high state mobilization dummy	equal to one if state had a WWII mobilization rate above the national average	
		gen high_mob=0 //
			replace high_mob=1 if st_born2==7 | st_born2==32 | st_born2==35 | st_born2==16 | st_born2==9 | st_born2==36 | st_born2==48 | st_born2==3 | st_born2==26 | st_born2==28 | st_born2==31 | st_born2==50 | st_born2==5 | st_born2==6 | st_born2==12 | st_born2==13 | st_born2==19 | st_born2==21 | st_born2==29 | st_born2==30 | st_born2==37 | st_born2==38 | st_born2==39 | st_born2==44 | st_born2==47  
				*States with high_mob=1: Connecticut, New York, Ohio, Kansas, Florida, Oklahoma, West Virginia, Arizona, Montana, Nevada, New Mexico, California, Colorado, Idaho, Illinois, Maine, Massachusetts, New Hampshire, New Jersey, Oregon, Pennsylvania, Rhode Island, Utah, Washington, and Wyoming

	*Interaction variable for outreg
		gen salariesiu2f_hm=salariesiu2f*high_mob //average of in utero up to age 2 interacted with high_mob (for econ index)
		gen salaries_iu2f_hm=salaries_iu2f*high_mob //in utero only interacted with high_mob (for nchronic)
			   
	*APPENDIX TABLE 12: EFFECT OF WAGE INDEX DECLINES AND WWII MOBILIZATION RATES ON THE ECONOMIC INDEX
		*Baseline
			reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\WWII_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*With interaction 
			reg hc_index7_std salariesi_3f salariesiu2f salariesi34_avgf high_mob salariesiu2f_hm $m5 if hcsamp==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\WWII_ECON_INDEX_RESULTS.xls", append keep(salariesi_3f salariesiu2f salariesi34_avgf salariesiu2f_hm high_mob) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)

	*APPENDIX TABLE 13: EFFECT OF WAGE INDEX DECLINES AND WWII MOBILIZATION RATES ON THE NUMBER OF CHRONIC DISEASE CONDITIONS
		*Baseline
			reg num_chronictot salariesi_3f salaries_iu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\WWII_NCHRONIC_RESULTS.xls", append keep(salariesi_3f salaries_iu2f) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		*With interaction 
			reg num_chronictot salariesi_3f salaries_iu2f high_mob salaries_iu2f_hm $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)    
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\WWII_NCHRONIC_RESULTS.xls", append keep(salariesi_3f salaries_iu2f salaries_iu2f_hm high_mob) nocons br dec(5) ctitle(ALL STS) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)


*********************************************************************************************************************************************************************************
***CHILDHOOD SELF-REPORTED HEALTH RESULTS: TABLE 5***
*********************************************************************************************************************************************************************************

	*Generate dummy equal to one if childhood self-reported health was fair or poor and zero if excellent, very good, or good
		gen childhealth_r3=.  
			replace childhealth_r3=1 if childhealth>=4 & childhealth<=5
			replace childhealth_r3=0 if childhealth>=1 & childhealth<=3
				bysort hhidpn: egen childhealth_r4=mode(childhealth_r3), maxmode //take highest reported value (i.e., ever report being in fair or poor health)
	
	*TABLE 5: EFFECT OF WAGE INDEX DECLINES ON THE PROBABILITY OF REPORTING FAIR OR POOR HEALTH IN CHILDHOOD
		reg childhealth_r4 salariesi_3f salariesiu2f $m5 if ncsamp_cs==1 [aw=rwght], cluster(st_born2)
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\CHILDHOOD_SRHS_RESULTS.xls", append keep(salariesi_3f salariesiu2f) nocons br dec(5) ctitle(SRHS in Childhood) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)


			
*********************************************************************************************************************************************************************************
***HEIGHT RESULTS: TABLE 6***
*********************************************************************************************************************************************************************************

	*Generate variable equal to max height respondent reported while in HRS panel
		bysort hhidpn: egen height_max=max(height) //max height reported while in HRS
			sort hhidpn year

	*TABLE 6: THE EFFECT OF WAGE INDEX DECLINES ON HEIGHT (IN METERS)
		reg height_max salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\HEIGHT_RESULTS.xls", append keep(salariesi_3f salaries_iu2f salariesi12_avgf salariesi34_avgf) nocons br dec(5) ctitle(Height in Meters) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
	
	
*********************************************************************************************************************************************************************************
***MIGRATION RESULTS: APPENDIX TABLE 5***
*********************************************************************************************************************************************************************************
		
	*Generate interaction variables that interact average wage declines in utero through age 2 with demographic characteristics
		gen female_x_sal12f=female*salariesiu2f
		gen black_x_sal12f=black*salariesiu2f
		gen othrace_x_sal12f=other_race*salariesiu2f
		gen meduc_nodeg_x_sal12f=meduc_no_deg*salariesiu2f
		gen meduc_hs_x_sal12f=meduc_hs*salariesiu2f
		gen meduc_md_x_sal12f=meduc_md*salariesiu2f
		gen dadnolive_x_sal12f=dadnolive_m*salariesiu2f
		gen dadnolive_md_x_sal12f=dadnolive_md*salariesiu2f
		
	*APPENDIX TABLE 5: EFFECT OF WAGE INDEX DECLINES ON THE PROBABILITY OF MIGRATION IN CHILDHOOD
		reg diff_state salariesi_3f salariesiu2f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2)   
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\MIGRATION_RESULTS.xls", append keep(salariesi_3f salariesiu2f) nocons br dec(5) ctitle(diff_state) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)
		
		reg diff_state salariesi_3f salariesiu2f female_x_sal12f black_x_sal12f othrace_x_sal12f meduc_nodeg_x_sal12f meduc_hs_x_sal12f meduc_md_x_sal12f dadnolive_x_sal12f dadnolive_md_x_sal12f $m5 if ncsamp_cs==1 [aw=rwght], cl(st_born2) 
			outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\11-22-22\MIGRATION_RESULTS.xls", append keep(salariesi_3f salariesiu2f female_x_sal12f black_x_sal12f othrace_x_sal12f meduc_nodeg_x_sal12f meduc_hs_x_sal12f meduc_md_x_sal12f dadnolive_x_sal12f dadnolive_md_x_sal12f) nocons br dec(5) ctitle(diff_state) addtext(YOB FE, X, SOB FE, X, Survey Year FE, X, Individual Covariates, X, Birth Region FE*YOB LTT, X, 1928 Infant Mortality LTT, X, 1929 Maternal Mortality LTT, X, Prop Farmland 75th Pecentile LTT, X, Share of Manufacturing*YOB FE, X)


*********************************************************************************************************************************************************************************
***MORTALITY SELECTION RESULTS: TABLE 3***
*********************************************************************************************************************************************************************************

	*TABLE 3: EFFECT OF WAGE INDEX DECLINES IN UTERO ON THE PROBABILITY OF SURVIVAL IN THE HRS
		
		foreach var of varlist surv65 surv75 surv85 {				
									
			reg `var' salaries_iu2f female i.race i.birthyr i.st_born2 if inw_count==1 & birthyr>=1929 & birthyr<=1940 [aw=rwght], cl(st_born2)   
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_Clock_Paper\PNAS_FINAL\MORTALITY_SELECTION_ANALYSIS_FLIPPED.xls", append keep(salaries_iu2f) nocons br dec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X)
				
				}
					
					
*********************************************************************************************************************************************************************************
***CAUSE OF DEATH RESULTS: APPENDIX TABLE 3***
*********************************************************************************************************************************************************************************
									
	*APPENDIX TABLE 3: EFFECT OF WAGE INDEX DECLINES IN UTERO ON CAUSE OF DEATH PROBABILITIES
				
		foreach var of varlist cod_heart cod_met cod_digsys cod_neuro cod_psych {				
										
			reg `var' salaries_iu2f female i.race meduc_no_deg meduc_hs meduc_md i.birthyr i.st_born2 if inw_count==1 & birthyr>=1929 & birthyr<=1940 [aw=rwght], cl(st_born2)   
				outreg2 using "U:\Duque_and_Schmitz\Outreg_Results\GD_JHR_PAPER\6-3-22\MORTALITY_COD.xls", append keep(salaries_iu2f) nocons br dec(5) ctitle(`var') addtext(YOB FE, X, SOB FE, X, Individual Covariates, X)
					
					}
				
*********************************************************************************************************************************************************************************





