**************************************************************************************************************
***STEP FOUR: CLEAN DATA AND CODE VARIABLES FOR ANALYSIS***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

use "U:\Schmitz_Restricted\HRS_Panel_GD_Clock_FINAL.dta"

********************************************************************************
***DEMOGRAPHIC VARIABLES***
********************************************************************************

*FEMALE DUMMY
	recode sex (1=0) (2=1), gen(female)

*MALE DUMMY
	gen male=1 if sex==1
	replace male=0 if sex==2

*AGE SQUARED
	gen ageyrs2=ageyrs*ageyrs

*BLACK/OTHER RACE DUMMY 
	recode race (.m=.) (1=0) (2/3=1), gen(nonwhite) //recode black and other race as 1
	recode race (.m=.) (2/3=0), gen(white)
	recode race (.m=.) (1=0) (3=0) (2=1), gen(black) //recode black 
	recode race (.m=.) (1=0) (2=0) (3=1), gen(other_race) //recode other race
		
*MOTHER'S EDUCATION
		recode meduc (.d=.) (.m=.) (.r=.)
	
	*meduc missing set equal to zero

		gen meduc_m=meduc
			recode meduc_m (.=0) 
		
	*Missing dummies
		gen meduc_md=.
			replace meduc_md=1 if meduc==.
			replace meduc_md=0 if meduc!=.

*MATERNAL EDUCATION DUMMIES
	gen meduc_no_deg=.
		replace meduc_no_deg=1 if meduc<12 
		replace meduc_no_deg=0 if meduc>=12 & meduc<.
		replace meduc_no_deg=0 if meduc==.
		
	gen meduc_hs=.
		replace meduc_hs=1 if meduc==12
		replace meduc_hs=0 if meduc!=12
		replace meduc_hs=0 if meduc==.

	gen meduc_coll=. //excluded category in analysis
		replace meduc_coll=1 if meduc>12 & meduc<.
		replace meduc_coll=0 if meduc<=12
		replace meduc_coll=0 if meduc==.
	
	gen meduc_hs_plus=.
		replace meduc_hs_plus=1 if meduc>=12 & meduc<.
		replace meduc_hs_plus=0 if meduc<12
		replace meduc_hs_plus=0 if meduc==.

*ASSIGN BIRTHPLACE TO HHIDPN FROM MO (BIRTHPLACE MISSING)
	recode birthplace (.m=4) if birthplace==.m & st_born2==25

********************************************************************************
***ECONOMIC VARIABLES***
********************************************************************************

*DEGREE VARIABLES

	*No degree
		gen nodeg=.
			replace nodeg=1 if degree==0
			replace nodeg=0 if degree>=1 & degree<=8
	*GED/HS degree
		gen gedhs=.
			replace gedhs=1 if degree>=1 & degree<=3
			replace gedhs=0 if degree==0
			replace gedhs=0 if degree>=4 & degree<.
	*Some college
		gen somecoll=.
			replace somecoll=1 if degree==4
			replace somecoll=0 if degree!=4
	*Bachelors 
		gen bach=.
			replace bach=1 if degree>=5 & degree<=8
			replace bach=0 if degree<5
			

********************************************************************************
***HEALTH AND HEALTH BEHAVIORS***
********************************************************************************

	*HIBP
		recode hibp (.d=.) (.m=.) (.p=.) (.r=.) (.y=.) (.j=.) (3=1) (4=0) (5=.)
			by hhidpn: carryforward hibp if inw==1 & hibp==., replace

		
	*CANCER
		recode cancer (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.)
			by hhidpn: carryforward cancer if inw==1 & cancer==., replace

	*LUNG
		recode lung (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.)
		
	*ARTHRITIS
		recode arthr (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.)

	*DIABETES
		recode diab (.d=.) (.m=.) (.p=.) (.r=.) (.y=.) (3=1) (4=0) (5=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward diab if inw==1 & diab==., replace

	*HEART DISEASE
		recode heart (.d=.) (.m=.) (.r=.) (3=1) (4=0) (5=.) (6=0) (.j=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward heart if inw==1 & heart==., replace

	*STROKE
		recode stroke (.d=.) (.m=.) (.r=.) (.y=.) (.j=.) (2=1) (3=1) (4=0) (5=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward stroke if inw==1 & stroke==., replace

	*PSYCH
		recode psych (.t=.) (.y=.) (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.)

	*FUNCTIONAL LIMITATIONS
		recode adl (.m=.)
		recode iadl (.m=.)

	*METABOLIC SYNDROME INDEX
		*Z-SCORE VARIABLES 
			foreach var of varlist diab heart stroke hibp {
				egen `var'_std=std(`var')
			}
			
				gen met_index4=(diab_std + heart_std + stroke_std + hibp_std)/4
					egen met_index4_std=std(met_index4)
					
	*FRAILTY INDEX
		*WASTING: Generate dummy indicating at least 10% loss of body weight over a 2 year period
			gen weight_change=weight[_n]-weight[_n-1]
			gen per_weight_change=((weight[_n]-weight[_n-1])/weight[_n-1])*100
				
				gen wasting=. //lost 10% or more of their body weight over a 2 year period
					replace wasting=1 if per_weight_change<=-10
					replace wasting=0 if per_weight_change>-10 & per_weight_change<.
					
		*WEAKNESS: Generate dummy indicates R has difficulty lifting/carrying weights over 10lbs because of health problems
				gen weak=.
					replace weak=1 if (weakness==1 | weakness==6) //yes or can't do
					replace weak=0 if weakness==5 //no

		*SLOWNESS: Generate dummy indicates R has difficulty getting up out of a chair after sitting for long periods because of health problems
				gen slow=.
					replace slow=1 if (slowness==1 | slowness==6) //yes or can't do
					replace slow=0 if slowness==5 //no

		*FATIGUE: Generate dummy indicates R has fatigue or exhaustion
				gen fatigued=.
					replace fatigued=1 if fatigue==1  //yes 
					replace fatigued=0 if fatigue==5 //no

		*FALLS: Generate dummy indicates R has fallen down in the last 2 years
				gen fell=.
					replace fell=1 if falls==1  //yes 
					replace fell=0 if falls==5 //no

			egen frailsum=rowtotal(wasting weak slow fatigued fell) if year>=1996 & year<=2018, missing //sets equal to missing if all are missing
		
				gen frail=.
					replace frail=1 if frailsum>=3 & frailsum<.
					replace frail=0 if frailsum<3
				
				gen prefrail=.
					replace prefrail=1 if frailsum>=1 & frailsum<. //prefrail: R meets at least one of the criteria
					replace prefrail=0 if frailsum<1

			
	*NUMBER OF CHRONIC DISEASES
		sort hhidpn year
					
			by hhidpn: egen everpsych=max(psych)
			by hhidpn: egen everhibp=max(hibp)
			by hhidpn: egen evercancer=max(cancer)
			by hhidpn: egen everlung=max(lung)
			by hhidpn: egen everdiab=max(diab)
			by hhidpn: egen everstroke=max(stroke)
			by hhidpn: egen everheart=max(heart)
			by hhidpn: egen everarthr=max(arthr)
			
			gen num_chronic=.
				replace num_chronic=everpsych+everhibp+evercancer+everlung+everdiab+everstroke+everheart+everarthr
				
	*MORTALITY
		*wstat==5 or 6
			gen dead=.
				replace dead=1 if wstat==5 | wstat==6 //died this wave or the previous wave
				replace dead=0 if wstat>=0 & wstat<=4 //inap. alive (resp) or alive (nr)
				replace dead=. if wstat==7 //dropped from sample

			by hhidpn: egen everdead=max(dead)

		*Create ageyrs at death variable
			sort hhidpn year
				
				by hhidpn: gen ageyrs_cf=ageyrs[_n-1]+2 if ageyrs==. & wstat==4 & wstat[_n-1]==1 //alive but nonresponsive in t+2
				by hhidpn: replace ageyrs_cf=ageyrs[_n-2]+4 if ageyrs==. & wstat==4 & wstat[_n-1]==4 //alive but nonresponsive in t+4
				by hhidpn: replace ageyrs_cf=ageyrs[_n-3]+6 if ageyrs==. & wstat==4 & wstat[_n-2]==4 //alive but nonresponsive in t+6
				by hhidpn: replace ageyrs_cf=ageyrs[_n-4]+8 if ageyrs==. & wstat==4 & wstat[_n-3]==4 //alive but nonresponsive in t+6
				by hhidpn: replace ageyrs_cf=ageyrs[_n-5]+10 if ageyrs==. & wstat==4 & wstat[_n-4]==4 //alive but nonresponsive in t+6
			
				by hhidpn: replace ageyrs_cf=ageyrs[_n-1]+2 if ageyrs==. & wstat==5 & wstat[_n-1]==1 //report dying in previous wave
				by hhidpn: replace ageyrs_cf=ageyrs_cf[_n-1]+2 if ageyrs==. & wstat==5 & wstat[_n-1]==4 //report dying in previous wave but previous wave did not respond
				
				gen age_death=ageyrs_cf if wstat==5 //set age at death equal to age reported dead in panel
			
				by hhidpn: egen death_age=max(age_death) //create death age panel variable

********************************************************************************
****CAUSE OF DEATH VARIABLES****
********************************************************************************

recode causedeath_a causedeath_b (990/999=.)

	*Heart, circulatory, and blood conditions
		gen dead_hearta=.
			replace dead_hearta=1 if (causedeath_a>=121 & causedeath_a<=129) 
			replace dead_hearta=0 if causedeath_a<121 | (causedeath_a>129 & causedeath_a<.)
		gen dead_heartb=.
			replace dead_heartb=1 if (causedeath_b>=121 & causedeath_b<=129)
			replace dead_heartb=0 if causedeath_b<121 | (causedeath_b>129 & causedeath_b<.)
		gen dead_heart=.
			replace dead_heart=1 if dead_hearta==1 | dead_heartb==1
			replace dead_heart=0 if dead_hearta==0 & dead_heartb==0
			replace dead_heart=0 if dead_hearta==0 & dead_heartb==.
			replace dead_heart=0 if dead_hearta==. & dead_heartb==0
		
			bysort hhidpn: egen cod_heart=max(dead_heart) 

	*Endocrine, metabolic and nutritional conditions
		gen dead_meta=.
			replace dead_meta=1 if (causedeath_a>=141 & causedeath_a<=149) 
			replace dead_meta=0 if causedeath_a<141 | (causedeath_a>149 & causedeath_a<.)
		gen dead_metb=.
			replace dead_metb=1 if (causedeath_b>=141 & causedeath_b<=149)
			replace dead_metb=0 if causedeath_b<141 | (causedeath_b>149 & causedeath_b<.)
		gen dead_met=.
			replace dead_met=1 if dead_meta==1 | dead_metb==1
			replace dead_met=0 if dead_meta==0 & dead_metb==0
			replace dead_met=0 if dead_meta==0 & dead_metb==.
			replace dead_met=0 if dead_meta==. & dead_metb==0
		
			bysort hhidpn: egen cod_met=max(dead_met) 

		*Heart or endocrine, metabolic, and nutritional conditions
			gen cod_heart_met=0 
				replace cod_heart_met=1 if cod_heart==1 | cod_met==1
			
		*Digestive system (stomach, liver, gallblader, kidney, bladder)
			gen dead_digsysa=.
				replace dead_digsysa=1 if (causedeath_a>=151 & causedeath_a<=159) 
				replace dead_digsysa=0 if causedeath_a<151 | (causedeath_a>159 & causedeath_a<.)
			gen dead_digsysb=.
				replace dead_digsysb=1 if (causedeath_b>=151 & causedeath_b<=159)
				replace dead_digsysb=0 if causedeath_b<151 | (causedeath_b>159 & causedeath_b<.)
			gen dead_digsys=.
				replace dead_digsys=1 if dead_digsysa==1 | dead_digsysb==1
				replace dead_digsys=0 if dead_digsysa==0 & dead_digsysb==0
				replace dead_digsys=0 if dead_digsysa==0 & dead_digsysb==.
				replace dead_digsys=0 if dead_digsysa==. & dead_digsysb==0

				bysort hhidpn: egen cod_digsys=max(dead_digsys) 

		*Neurological and sensory conditions 
			gen dead_neuroa=.
				replace dead_neuroa=1 if (causedeath_a>=161 & causedeath_a<=169) 
				replace dead_neuroa=0 if causedeath_a<161 | (causedeath_a>169 & causedeath_a<.)
			gen dead_neurob=.
				replace dead_neurob=1 if (causedeath_b>=161 & causedeath_b<=169)
				replace dead_neurob=0 if causedeath_b<161 | (causedeath_b>169 & causedeath_b<.)
			gen dead_neuro=.
				replace dead_neuro=1 if dead_neuroa==1 | dead_neurob==1
				replace dead_neuro=0 if dead_neuroa==0 & dead_neurob==0
				replace dead_neuro=0 if dead_neuroa==0 & dead_neurob==.
				replace dead_neuro=0 if dead_neuroa==. & dead_neurob==0
			
				bysort hhidpn: egen cod_neuro=max(dead_neuro) 
			
		*Emotional and psychological conditions
			gen dead_psycha=.
				replace dead_psycha=1 if (causedeath_a>=181 & causedeath_a<=189) 
				replace dead_psycha=0 if causedeath_a<181 | (causedeath_a>189 & causedeath_a<.)
			gen dead_psychb=.
				replace dead_psychb=1 if (causedeath_b>=181 & causedeath_b<=189)
				replace dead_psychb=0 if causedeath_b<181 | (causedeath_b>189 & causedeath_b<.)
			gen dead_psych=.
				replace dead_psych=1 if dead_psycha==1 | dead_psychb==1
				replace dead_psych=0 if dead_psycha==0 & dead_psychb==0
				replace dead_psych=0 if dead_psycha==0 & dead_psychb==.
				replace dead_psych=0 if dead_psycha==. & dead_psychb==0
			
				bysort hhidpn: egen cod_psych=max(dead_psych) 

********************************************************************************
***STATE-LEVEL CONTROLS****
********************************************************************************
	sort st_born2
	
	*GENERATE 75th PERCENTILE OF EARNERS IN MANUFACTURING 
		bysort st_born2: egen manf_share2=max(manf_share)		
			gen manf_share75=0 if manf_share2!=0
				replace manf_share75=1 if manf_share2>=.2583532 & manf_share2<. //0.25=75% tile in manufacturing share

	*GENERATE 75th PERCENTILE OF PROPORTION FARMLAND 
		bysort st_born2: egen prop_farm2=max(prop_farm)		
			gen prop_farm75=0 if prop_farm2!=0
				replace prop_farm75=1 if prop_farm2>=.695 & prop_farm2<. //0.695=75% tile in proportion farmland

********************************************************************************
****MERGE EPIGENETIC AGING MEASURES, CELL PROPORTIONS, AND GENETIC PCs****
********************************************************************************

sort hhidpn 

*MERGE IN CLOCK DATA	
	
	joinby hhidpn using "R:\SharedProjects\SharedLSCM\SES_DNAm_Project\Data\epi_clocks_for_merge.dta", unmatched(master)
		drop _merge
		sort hhidpn year

		rename horvath_dnamage horvath
		rename horvathskin_dnamage horvath2
		rename hannum_dnamage hannum
		rename levine_dnamage levine
		rename lin_dnamage lin
		rename yang_dnamage yang
		rename dnamgrimage grimage
		rename mpoa poam
		rename zhang_dnamage zhang

	global clocks "horvath horvath2 hannum levine lin yang zhang grimage poam"

		foreach var of varlist horvath horvath2 hannum levine lin yang zhang grimage poam {
			reg `var' ageyrs if year==2016
				predict `var'_eaa if year==2016, residuals		
		}

*MERGE IN WEIGHT FOR DNAm SAMPLE FROM 2016 TRACKER FILE
	sort hhidpn
	
		merge m:1 hhidpn using "R:\SharedProjects\SharedLSCM\SES_DNAm_Project\Data\HRS_Tracker_File.dta", keepusing(vbsi16wgtra pvbswgtr)
			drop _merge
			
			*From VBS documentation: "VBSI16WGTRA should be used for analyses including DNA methylation and epigenetic clocks"; "PVBSWGTR should be used for full VBS sample"

*MERGE IN CENSUS 1940 LINK VARIABLE FROM 2018 TRACKER FILE
	sort hhidpn
	
		merge m:1 hhidpn using "U:\Duque_and_Schmitz\Data\HRS_Tracker_File_2018.dta", keepusing(census1940)
			drop _merge
			
*MERGE IN CELL PROPORTIONS FROM VBS DATA
	sort hhidpn 
	
	merge m:1 hhidpn using "R:\SharedProjects\SharedLSCM\SES_DNAm_Project\Data\HRS_VBS_Data_2016.dta", keepusing(pneut pmono plymp peos pbaso)
		drop _merge

*MERGE IN PCs AND PGSs FROM SSGAC REPOSITORY
	sort hhidpn
	
	joinby hhidpn using "U:\School_Quality\Data\hrs_pgirepo_v1.dta", unmatched(master) //Version 1 release of SSGAC PGI repository data
		drop _merge

	*Rename SSGAC PCs
		rename pc1_5a pc1_ssgac
		rename pc1_5b pc2_ssgac
		rename pc1_5c pc3_ssgac
		rename pc1_5d pc4_ssgac
		rename pc1_5e pc5_ssgac
		rename pc6_10a pc6_ssgac
		rename pc6_10b pc7_ssgac
		rename pc6_10c pc8_ssgac
		rename pc6_10d pc9_ssgac
		rename pc6_10e pc10_ssgac
		
			global pcs_ssgac "pc1_ssgac pc2_ssgac pc3_ssgac pc4_ssgac pc5_ssgac pc6_ssgac pc7_ssgac pc8_ssgac pc9_ssgac pc10_ssgac"

********************************************************************************
***CREATE 2-YEAR EXPOSURE AVERAGES FOR EVENT STUDY***
********************************************************************************
	sort hhidpn year
	
	*WAGE INDEX
		*Generate 2 year averages (without year 0)
			gen salariesi_32=(salariesi_3+salariesi_2)/2
			gen salariesi12_avg=(salariesi1+salariesi2)/2
			gen salariesi34_avg=(salariesi3+salariesi4)/2
			gen salariesi56_avg=(salariesi5+salariesi6)/2
			gen salariesi78_avg=(salariesi7+salariesi8)/2
			gen salariesi910_avg=(salariesi9+salariesi10)/2
			gen salariesi1112_avg=(salariesi11+salariesi12)/2
			gen salariesi1314_avg=(salariesi13+salariesi14)/2
			gen salariesi1516_avg=(salariesi15+salariesi16)/2
			
	*EMPLOYMENT INDEX		
		*Generate employment averages
			gen emp_index_32=(emp_index_3+emp_index_2)/2
			gen emp_index12=(emp_index1+emp_index2)/2
		
	*CAR SALES INDEX	
		*Multiply index by 100 so it's in the same units as the wage index
			foreach var of varlist car_salesi car_salesi_3 car_salesi_2 car_salesi_1 car_salesi1 car_salesi2 car_salesi3 car_salesi4 car_salesi5 car_salesi6 {
				gen `var'_r=`var'*100
			}
		*Generate car sales averages
			gen car_salesi_32=(car_salesi_3_r+car_salesi_2_r)/2
			gen car_salesi12=(car_salesi1_r+car_salesi2_r)/2
			gen car_salesi34=(car_salesi3_r+car_salesi4_r)/2
			gen car_salesi56=(car_salesi5_r+car_salesi6_r)/2

		
********************************************************************************
***GENERATE IN UTERO EXPOSURE MEASURES***
********************************************************************************

*In utero exposure measure based on weighted average of t-1 and t based on month of birth
	sort hhidpn year
	
	gen salaries_iu2=.
		replace salaries_iu2=salariesi_1 if birthmonth==1
		replace salaries_iu2=(salariesi_1*(8/9)+salariesi*(1/9)) if birthmonth==2
		replace salaries_iu2=(salariesi_1*(7/9)+salariesi*(2/9)) if birthmonth==3
		replace salaries_iu2=(salariesi_1*(6/9)+salariesi*(3/9)) if birthmonth==4
		replace salaries_iu2=(salariesi_1*(5/9)+salariesi*(4/9)) if birthmonth==5
		replace salaries_iu2=(salariesi_1*(4/9)+salariesi*(5/9)) if birthmonth==6
		replace salaries_iu2=(salariesi_1*(3/9)+salariesi*(6/9)) if birthmonth==7
		replace salaries_iu2=(salariesi_1*(2/9)+salariesi*(7/9)) if birthmonth==8
		replace salaries_iu2=(salariesi_1*(1/9)+salariesi*(8/9)) if birthmonth==9
		replace salaries_iu2=salariesi if birthmonth==10
		replace salaries_iu2=salariesi if birthmonth==11
		replace salaries_iu2=salariesi if birthmonth==12

	gen emp_index_iu2=.
		replace emp_index_iu2=emp_index_1 if birthmonth==1
		replace emp_index_iu2=(emp_index_1*(8/9)+emp_index*(1/9)) if birthmonth==2
		replace emp_index_iu2=(emp_index_1*(7/9)+emp_index*(2/9)) if birthmonth==3
		replace emp_index_iu2=(emp_index_1*(6/9)+emp_index*(3/9)) if birthmonth==4
		replace emp_index_iu2=(emp_index_1*(5/9)+emp_index*(4/9)) if birthmonth==5
		replace emp_index_iu2=(emp_index_1*(4/9)+emp_index*(5/9)) if birthmonth==6
		replace emp_index_iu2=(emp_index_1*(3/9)+emp_index*(6/9)) if birthmonth==7
		replace emp_index_iu2=(emp_index_1*(2/9)+emp_index*(7/9)) if birthmonth==8
		replace emp_index_iu2=(emp_index_1*(1/9)+emp_index*(8/9)) if birthmonth==9
		replace emp_index_iu2=emp_index if birthmonth==10
		replace emp_index_iu2=emp_index if birthmonth==11
		replace emp_index_iu2=emp_index if birthmonth==12

	gen car_sales_iu2=.
		replace car_sales_iu2=car_salesi_1_r if birthmonth==1
		replace car_sales_iu2=(car_salesi_1_r*(8/9)+car_salesi_r*(1/9)) if birthmonth==2
		replace car_sales_iu2=(car_salesi_1_r*(7/9)+car_salesi_r*(2/9)) if birthmonth==3
		replace car_sales_iu2=(car_salesi_1_r*(6/9)+car_salesi_r*(3/9)) if birthmonth==4
		replace car_sales_iu2=(car_salesi_1_r*(5/9)+car_salesi_r*(4/9)) if birthmonth==5
		replace car_sales_iu2=(car_salesi_1_r*(4/9)+car_salesi_r*(5/9)) if birthmonth==6
		replace car_sales_iu2=(car_salesi_1_r*(3/9)+car_salesi_r*(6/9)) if birthmonth==7
		replace car_sales_iu2=(car_salesi_1_r*(2/9)+car_salesi_r*(7/9)) if birthmonth==8
		replace car_sales_iu2=(car_salesi_1_r*(1/9)+car_salesi_r*(8/9)) if birthmonth==9
		replace car_sales_iu2=car_salesi_r if birthmonth==10
		replace car_sales_iu2=car_salesi_r if birthmonth==11
		replace car_sales_iu2=car_salesi_r if birthmonth==12
		
*In utero exposure measure based on quarter of birth

	*Quarter of birth dummies
		gen qob1=0
			replace qob1=1 if birthmonth>=1 & birthmonth<=3
		gen qob2=0
			replace qob2=1 if birthmonth>=4 & birthmonth<=6
		gen qob3=0
			replace qob3=1 if birthmonth>=7 & birthmonth<=9
		gen qob4=0
			replace qob4=1 if birthmonth>=10 & birthmonth<=12

			gen salaries_iu3=salariesi if (qob3==1 | qob4==1) //assign salariesi if born in second half of the year
				replace salaries_iu3=salariesi_1 if (qob1==1 | qob2==1) //assign salariesi_1 if born in first half of the year

	sort hhidpn year
				
save "U:\Duque_and_Schmitz\Data\HRS_Panel_GD_Clock_Cleaned_w_ETS_Vars_FINAL.dta", replace	

