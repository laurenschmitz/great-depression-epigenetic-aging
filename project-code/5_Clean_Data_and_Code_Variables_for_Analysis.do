*********************************************************************************************************************************************************************************
***STEP 5: CODE VARIABLES AND CLEAN DATA FOR ANALYSIS***
	*Project: Early-life Exposures to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
*********************************************************************************************************************************************************************************

clear
set more off

use "U:\Schmitz_Restricted\HRS_Occ_Panel_FINAL_JHR.dta"

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

********************************************************************************
*CHILDHOOD VARIABLES
********************************************************************************
*LIVING IN A RURAL AREA MOST OF THE TIME IN GRADE SCHOOL/HS/ageyrs 10
	recode urb_rural (5=0) (7/9=.), gen(rural_r)
		by hhidpn: egen rural_r2=mode(rural_r), maxmode
	
	gen rural_m=rural_r2
		replace rural_m=0 if rural_r2==.
	gen rural_md=.
		replace rural_md=1 if rural_r2==.
		replace rural_md=0 if rural_r2!=.

*DIDN'T LIVE WITH FATHER
	recode funemp (7=1) (1/6=0) (8/9=.), gen(dadnolive) //this variable is generated from father unemployment variable=7
		by hhidpn: egen dadnolive_r=mode(dadnolive), maxmode

	*Missing father not present dummy
		gen dadnolive_m=dadnolive_r
			replace dadnolive_m=0 if dadnolive_r==.
		gen dadnolive_md=0
			replace dadnolive_md=1 if dadnolive_r==.

*SELF-REPORTED HEALTH STATUS AS A CHILD
	recode childhealth (2=1) (3/5=0) (8/9=.), gen(childhealth_r) //1=excellent; 2=very good; 3=good; 4=fair; 5=poor
		by hhidpn: egen childhealth_r2=mode(childhealth_r), minmode //take lowest reported value (=0)

*FATHER'S OCCUPATION
	*3 digit restricted data
		*fwhitecol fbluecol fservice (coded using 3 digit occupation codes)
		*fprofessional fmanageyrsrial fsales fadmin fmech foperators ffarmers fservice (coded using 3 digit occupation codes)

		*Missing father's occupation dummy (3 digit codes)
			gen focc3_md=0
				replace focc3_md=1 if fwhitecol==0 & fbluecol==0 & fservice==0 //missings were coded as zero 

	*2 digit public data
		*focc (2 digit public use data; 1996-2004: 1980 Census codes-17; 2004-2010: 2000 Census codes-25)
			recode focc (98/99=.), gen(focc_r)
				by hhidpn: egen focc_r2=mode(focc_r) if year<=2004, maxmode //constrain to the years Cutler had the data and Census occ coding is 1980
			
		*Father was a farmer dummy
			gen ffarmer=.
				replace ffarmer=1 if focc_r2==10
				replace ffarmer=0 if (focc_r2<10 | focc_r2>10) | focc_r2==.
		
			gen ffarmer2=.
				replace ffarmer2=1 if focc_r2==10
				replace ffarmer2=0 if (focc_r2<10 | focc_r2>10) &  focc_r2!=.

		*Set missing father's occ to zero
			recode focc_r2 (.=0), gen(focc_m)
			
		*Missing father's occupation dummy (2 digit codes)
			gen focc_md=.
				replace focc_md=1 if focc_r2==. 
				replace focc_md=0 if focc_r2!=.
				
*PARENTS EDUCATION
	*meduc feduc
		recode meduc (.d=.) (.m=.) (.r=.)
		recode feduc (.d=.) (.m=.) (.r=.)
	
	*meduc and feduc (missing set equal to zero)

		gen meduc_m=meduc
			recode meduc_m (.=0) 
		
		gen feduc_m=feduc
			recode feduc_m (.=0) 

	*Missing dummies
		gen meduc_md=.
			replace meduc_md=1 if meduc==.
			replace meduc_md=0 if meduc!=.

		gen feduc_md=.
			replace feduc_md=1 if feduc==.
			replace feduc_md=0 if feduc!=.

*PARENTAL EDUCATION DUMMIES
	gen meduc_no_deg=.
		replace meduc_no_deg=1 if meduc<12 
		replace meduc_no_deg=0 if meduc>=12 & meduc<.
		replace meduc_no_deg=0 if meduc==.

	gen meduc_no_deg2=.
		replace meduc_no_deg2=1 if meduc<12 
		replace meduc_no_deg2=0 if meduc>=12 & meduc<.
		replace meduc_no_deg2=. if meduc==.

	gen meduc_no_deg_m=. // x < hs -> includes missings
		replace meduc_no_deg_m=1 if meduc<12 
		replace meduc_no_deg_m=0 if meduc>=12 & meduc<.
		replace meduc_no_deg_m=1 if meduc==.

	gen meduc_no_deg_no_m=. //sets missings equal to missing so they're dropped from analyses
		replace meduc_no_deg_no_m=1 if meduc<12 
		replace meduc_no_deg_no_m=0 if meduc>=12 & meduc<.
		replace meduc_no_deg_no_m=. if meduc==.
		
	gen meduc_hs=.
		replace meduc_hs=1 if meduc==12
		replace meduc_hs=0 if meduc!=12
		replace meduc_hs=0 if meduc==.

	gen meduc_hs_plus=.
		replace meduc_hs_plus=1 if meduc>=12 & meduc<.
		replace meduc_hs_plus=0 if meduc<12
		replace meduc_hs_plus=0 if meduc==.

	gen meduc_hs_plus2=.
		replace meduc_hs_plus2=1 if meduc>=12 & meduc<.
		replace meduc_hs_plus2=0 if meduc<12
		replace meduc_hs_plus2=. if meduc==.

	gen meduc_coll=.
		replace meduc_coll=1 if meduc>12 & meduc<.
		replace meduc_coll=0 if meduc<=12
		replace meduc_coll=0 if meduc==.

	gen feduc_no_deg=.
		replace feduc_no_deg=1 if feduc<12 
		replace feduc_no_deg=0 if feduc>=12 & feduc<.
		replace feduc_no_deg=0 if feduc==.

	gen feduc_no_deg_m=. // x < hs -> includes missings
		replace feduc_no_deg_m=1 if feduc<12 
		replace feduc_no_deg_m=0 if feduc>=12 & feduc<.
		replace feduc_no_deg_m=1 if feduc==.

	gen feduc_no_deg_no_m=. //excludes missings
		replace feduc_no_deg_no_m=1 if feduc<12 
		replace feduc_no_deg_no_m=0 if feduc>=12 & feduc<.
		replace feduc_no_deg_no_m=. if feduc==.

	gen feduc_hs=.
		replace feduc_hs=1 if feduc==12
		replace feduc_hs=0 if feduc!=12
		replace feduc_hs=0 if feduc==.

	gen feduc_hs_plus=.
		replace feduc_hs_plus=1 if feduc>=12 & feduc<.
		replace feduc_hs_plus=0 if feduc<12
		replace feduc_hs_plus=0 if feduc==.

	gen feduc_coll=.
		replace feduc_coll=1 if feduc>12 & feduc<.
		replace feduc_coll=0 if feduc<=12
		replace feduc_coll=0 if feduc==.

	
********************************************************************************
***ECONOMIC VARIABLES***
********************************************************************************

*DEGREE VARIABLES

	*No degree
		by hhidpn: gen nodeg=.
			replace nodeg=1 if degree==0
			replace nodeg=0 if degree>=1 & degree<=8

	*At least a GED (GED plus vs no degree)
		by hhidpn: gen gedplus=.
			replace gedplus=1 if degree>=1 & degree<=8
			replace gedplus=0 if degree==0

	*At least a HS degree (HS plus vs GED)
		by hhidpn: gen hsplus=.
			replace hsplus=1 if degree>=2 & degree<=8
			replace hsplus=0 if degree==1 
			replace hsplus=. if degree==0

	*At least a GED/HS degree (GED/HS plus vs no degree)
		by hhidpn: gen gedhsplus=.
			replace gedhsplus=1 if degree>=1 & degree<=8
			replace gedhsplus=0 if degree==0 
			
	*Some college or more 
		by hhidpn: gen somecollplus=.
			replace somecollplus=1 if degree>=4 & degree<=8
			replace somecollplus=0 if degree>=0 & degree<=3

	*Some college or more (dropping missings)
		by hhidpn: gen somecollplus2=.
			replace somecollplus2=1 if degree>=4 & degree<=8
			replace somecollplus2=0 if degree>=1 & degree<=3
			replace somecollplus2=. if degree==0

	*Bachelors plus (Bachelors or more vs Some college)
		by hhidpn: gen bachplus=.
			replace bachplus=1 if degree>=5 & degree<=8
			replace bachplus=0 if degree>=0 & degree<=4

	*MA, MBA plus (MA plus vs BA)
		by hhidpn: gen advplus=.
			replace advplus=1 if degree>=6 & degree<=8
			replace advplus=0 if degree==5
			replace advplus=. if degree<=4

	*COLLEGE VS. NO COLLEGE
		gen college=.
			replace college=1 if degree>=4 & degree<=8
			replace college=0 if degree<4
		

*HH WEALTH (excluding secondary residence) (RAND)
	*hwealthres
	*Inflate HH Wealth to $2010
	gen hh_wealth10=hwealthres

	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.554212402 if year==1992
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.4713630229157 if year==1994
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.38977692795479 if year==1996
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.33776687114176 if year==1998
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.26629500578459 if year==2000
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.21209560864984 if year==2002
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.15434621490792 if year==2004
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.08162698410767 if year==2006
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'* 1.012786630916 if year==2008
	}
	foreach var of varlist hh_wealth10 {
	by hhidpn: replace `var'=`var'*1 if year==2010
	}

	gen hh_wealth100=hh_wealth10/100000
	gen ln_hh_wealth10=ln(hh_wealth10) if hh_wealth10>0

	*INDIVIDUAL EARNINGS (RAND)
	*iearn
	*Inflate Earnings to $2010
		gen iearn10=iearn

			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.554212402 if year==1992
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.4713630229157 if year==1994
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.38977692795479 if year==1996
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.33776687114176 if year==1998
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.26629500578459 if year==2000
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.21209560864984 if year==2002
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.15434621490792 if year==2004
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.08162698410767 if year==2006
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'* 1.012786630916 if year==2008
				}
			foreach var of varlist iearn10 {
			by hhidpn: replace `var'=`var'*1 if year==2010
				}

		gen iearn10_2=iearn10
			recode iearn10_2 (0=1)
		gen lniearn10=ln(iearn10_2)


*HH INCOME (RAND)
	*hinctot
		gen hinctot10=hinctot

			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.554212402 if year==1992
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.4713630229157 if year==1994
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.38977692795479 if year==1996
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.33776687114176 if year==1998
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.26629500578459 if year==2000
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.21209560864984 if year==2002
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.15434621490792 if year==2004
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.08162698410767 if year==2006
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'* 1.012786630916 if year==2008
					}
			foreach var of varlist hinctot10 {
				by hhidpn: replace `var'=`var'*1 if year==2010
					}

	gen hinctot10_2=hinctot10
		recode hinctot10_2 (0=1)
	gen lnhinctot10=ln(hinctot10_2)

	
*LONGEST HELD OCCUPATION
	*lwhitecol lbluecol lservice //Occupational status
	*lprofessional lmanageyrsrial lsales ladmin lmech loperators lfamerms lservice //2 digit categories

*CURRENT OCCUPATION
	*whitecol bluecol service //Occupational status
	*professional manageyrsrial sales admin mech operators famerms service //2 digit categories


*LABOR FORCE STATUS
	recode lbrforce (.q=.) (.a=.) (.t=.), gen(lbrforce_r)

*Not unemployed
	gen no_unemp=.
		replace no_unemp=1 if lbrforce!=3 & lbrforce!=.
		replace no_unemp=0 if lbrforce==3

*Disabled
	gen disabled=.
		replace disabled=1 if lbrforce_r==6
		replace disabled=0 if lbrforce_r!=6 & lbrforce_r!=.

*Working
	gen working=.
		replace working=1 if lbrforce==1 | lbrforce==2
		replace working=0 if lbrforce>=3 & lbrforce<=7

*Working or Retired
	gen work_ret=.
		replace work_ret=1 if lbrforce==1 | lbrforce==2 | lbrforce==4 | lbrforce==5
		replace work_ret=0 if lbrforce==3 | lbrforce==6 | lbrforce==7 


********************************************************************************
***HEALTH AND HEALTH BEHAVIORS***
********************************************************************************

	*HEIGHT
		recode height (.d=.) (.r=.) (.m=.)

	*SRHS
		recode selfhealth (5=1) (1=5) (4=2) (2=4), gen(selfhealth2) //Recode self-reported health variable so that 1=poor, 2=fair, 3=good, 4=very good, 5=excellent

		gen srhs=.  //split SRHS into two categories
			replace srhs=1 if (selfhealth2==4 | selfhealth2==5) //1=excellent or very good health
			replace srhs=0 if (selfhealth2==3 | selfhealth2==2 | selfhealth==1) //0=good, fair, or poor health

		gen srhs2=.  //split SRHS into two categories
			replace srhs2=0 if (selfhealth2==3 | selfhealth2==4 | selfhealth2==5) //0=excellent, very good, or good health
			replace srhs2=1 if (selfhealth2==2 | selfhealth==1) //1=fair or poor health

	*HIBP
		recode hibp (.d=.) (.m=.) (.p=.) (.r=.) (.y=.) (3=1) (4=0) (5=.)
			by hhidpn: carryforward hibp if inw==1 & hibp==., replace

	*OBESITY
		recode bmi (.d=.) (.m=.) (.r=.)
			gen obese=.
				replace obese=1 if bmi>=30 & bmi<.
				replace obese=0 if bmi<30

	*DIABETES
		recode diab (.d=.) (.m=.) (.p=.) (.r=.) (.y=.) (3=1) (4=0) (5=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward diab if inw==1 & diab==., replace

	*HEART DISEASE
		recode heart (.d=.) (.m=.) (.r=.) (3=1) (4=0) (5=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward heart if inw==1 & heart==., replace

	*STROKE
		recode stroke (.d=.) (.m=.) (.r=.) (.y=.) (2=1) (3=1) (4=0) (5=.) //recode disputes previous record and has condition as =1, recode disputes previous record and doesn't have condition=0
			by hhidpn: carryforward stroke if inw==1 & stroke==., replace

	*PSYCH
		recode psych (.t=.) (.y=.) (3=1) (4=0) (5=.)

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

				
	*GENERATE VARIABLE THAT INDICATES AGE OF SURVIVAL
		by hhidpn: egen agedeath=max(death_age)
			replace agedeath=100 if agedeath==.
				
			sort hhidpn year
			
				bysort hhidpn: gen obs=_n
				
				gen surv65=1 if agedeath>=65 & obs==1
					replace surv65=0 if agedeath<65 & obs==1
				
				gen surv70=1 if agedeath>=70 & obs==1
					replace surv70=0 if agedeath<70 & obs==1

				gen surv75=1 if agedeath>=75 & obs==1
					replace surv75=0 if agedeath<75 & obs==1
		
			sort hhidpn year

********************************************************************************
****MORTALITY VARIABLES****
********************************************************************************

*Code COD Variables
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

				
*********************************************************************************************
***CREATE OUTCOME VARIABLES: ECONOMIC INDEX, NUMBER OF CHRONIC DISEASES, AND FRAILTY INDEX***
*********************************************************************************************

	*GENERATE ECONOMIC INDEX 
		sort hhidpn year
			gen ageret=ageyrs if lbrforce==4 | lbrforce==5 //4=partially retired; 5=fully retired
			gen ageret_full=ageyrs if lbrforce==5
				by hhidpn: egen ar_min=min(ageret)
				by hhidpn: egen arf_min=min(ageret_full)
					sort hhidpn year
				
				by hhidpn: egen everwork=max(working) if ageyrs>=50 & ageyrs<=65
					by hhidpn: egen everwork_r=max(working) //equal to one for all waves if they worked part or full time between ages 50 and 65
						sort hhidpn year
				
					foreach var of varlist lniearn10 hh_wealth10 lprof arf_min everwork_r {
						egen `var'_std=std(`var')
					}
			
			gen hc_index7=(hh_wealth10_std+lniearn10_std+everwork_r_std+lprof_std+arf_min_std)/5 
				egen hc_index7_std=std(hc_index7)

		sort hhidpn year

	*NUMBER OF CHRONIC DISEASES
		sort hhidpn year
			recode cancer (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.), gen(cancer_r)
			recode heart (6=0) (.j=.), gen(heart_r)
			recode psych (.d=.) (.j=.) (.m=.) (.r=.), gen(psych_r)
			recode hibp (.j=.), gen(hibp_r)
			recode stroke (.j=.), gen(stroke_r)
			recode lung (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.), gen(lung_r)
			recode arthr (3=1) (4=0) (5=.) (.d=.) (.j=.) (.m=.) (.r=.) (.t=.) (.y=.), gen(arthr_r)

		by hhidpn: egen everpsych=max(psych_r)
		by hhidpn: egen everhibp=max(hibp_r)
		by hhidpn: egen evercancer=max(cancer_r)
		by hhidpn: egen everlung=max(lung_r)
		by hhidpn: egen everdiab=max(diab)
		by hhidpn: egen everstroke=max(stroke_r)
		by hhidpn: egen everheart=max(heart_r)
		by hhidpn: egen everarthr=max(arthr_r)
		
		*TOTAL NUMBER OF CHRONIC CONDITIONS EVER DIAGNOSED IN PANEL
			gen num_chronictot=.
				replace num_chronictot=everpsych+everhibp+evercancer+everlung+everdiab+everstroke+everheart+everarthr

		*NUMBER OF CHRONIC CONDITIONS AT EACH WAVE (PANEL VARYING MEASURE)
			gen num_chronic=.
				replace num_chronic=psych_r+hibp_r+stroke_r+lung_r+diab+stroke_r+heart_r+arthr_r

	*FRAILTY INDEX
		*Code component variables
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

		*Generate frailty index
			egen frailsum2=rowtotal(weak slow fatigued fell) if year>=1996 & year<=2018, missing //sets equal to missing if all are missing
			
			gen prefrail3=.
				replace prefrail3=1 if frailsum2>=2 & frailsum2<. 
				replace prefrail3=0 if frailsum2<2

				
********************************************************************************
***GENERATE LINEAR TIME TREND COVARIATES AND MIGRATION VARIABLE***
********************************************************************************

	*ASSIGN BIRTHPLACE TO HHIDPN FROM MO (BIRTHPLACE MISSING)
		recode birthplace (.m=4) if birthplace==.m & st_born2==25

	*RECODE STATE BORN
		recode st_born2 (999=.)

	*GENERATE LINEAR TIME TRENDS FOR 75th PERCENTILE OF WAGE EARNERS IN MANUFACTURING (IMPT ADDITION!)
		bysort st_born2: egen manf_share2=max(manf_share)
		
		gen manf_share75=0 if manf_share2!=0
			replace manf_share75=1 if manf_share2>=.2583532 & manf_share2<. //0.25=75% tile in manufacturing share

	*GENERATE LINEAR TIME TRENDS FOR 75th PERCENTILE OF PROPORTION FARMLAND 
		bysort st_born2: egen prop_farm2=max(prop_farm)
		
		gen prop_farm75=0 if prop_farm2!=0
			replace prop_farm75=1 if prop_farm2>=.695 & prop_farm2<. //0.695=75% tile in proportion farmland

	*GENERATE MIGRATION VARIABLES
		gen same_state=.
			replace same_state=1 if st_born2==child_state_id
			replace same_state=0 if st_born2!=child_state_id

		gen diff_state=.
			replace diff_state=1 if st_born2!=child_state_id
			replace diff_state=0 if st_born2==child_state_id

				tab same_state if white==1 //84.69% live in the same state			

********************************************************************************
***MERGE IN LIFETIME EARNINGS DATA***
********************************************************************************

	sort hhidpn year
		
		joinby hhidpn year using "U:\Duque_and_Schmitz\Data\SSA_Life_Course_Earnings_Measures.dta", unmatched(master)
			drop _merge
			
	sort hhidpn year
				
		*Generate natural log of imputed lifetime earnings vars
			foreach var of varlist tot_earn* {
				recode `var'(0=1), gen(`var'_2)
					by hhidpn: gen ln`var'=ln(`var'_2)  
			}

	*SSA WEIGHTS FOR EARNINGS ANALYSIS
		*Construct wave sequence indicator for ssa weights
			sort hhidpn year
				by hhidpn: egen ssa_count=seq() if sswghtc!=. //sswghtc: weight that considers whether you have SSA linkage in that wave (1992, 1998, 2004-2012)
		
		*Populate first year survey weight (current linkage weight)
			by hhidpn: egen fssw_count=min(ssa_count) 
				gen fssw_val=sswghtc if fssw_count==ssa_count
					by hhidpn: egen sswghtc_f=mean(fssw_val)

			sort hhidpn year

			
********************************************************************************
***GENERATE EXPOSURE VARIABLES: WAGE AND EMPLOYMENT INDICES***
********************************************************************************

	*GENERATE WAGE INDEX EXPOSURE VARIABLE (2 YEAR AVERAGES)
		gen salariesi12_avg=(salariesi1+salariesi2)/2
		gen salariesi34_avg=(salariesi3+salariesi4)/2
		gen salariesi56_avg=(salariesi5+salariesi6)/2
		gen salariesi78_avg=(salariesi7+salariesi8)/2
		gen salariesi910_avg=(salariesi9+salariesi10)/2
		gen salariesi1112_avg=(salariesi11+salariesi12)/2
		gen salariesi1314_avg=(salariesi13+salariesi14)/2
		gen salariesi1516_avg=(salariesi15+salariesi16)/2

	*GENERATE EMPLOYMENT INDEX EXPOSURE VARIABLE (2 YEAR AVERAGES)
		*Assign people born in Arkansas (st_born=4) to Mississippi (st_born=24) (Arkansas missing Wallis data)
			gen emp_index_mi=emp_index if st_born2==24
				bysort birthyr: egen emp_index_mi2=max(emp_index_mi)

			replace emp_index=emp_index_mi2 if emp_index==. & st_born==4 
		
			gen emp_index_32=(emp_index_3+emp_index_2)/2
			gen emp_index12=(emp_index1+emp_index2)/2
				
	*GENERATE IN UTERO VARIABLE THAT IS A WEIGHTED AVERAGE OF PROPORTION TIME SPENT IN t-1 and t
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

	*FLIP SIGN OF EXPOSURE VARIABLES SO INCREASE IS REFLECTING A DECLINE IN WAGES AND EMPLOYMENT
		gen salaries_iu2f=salaries_iu2*(-1)
		gen salariesi_3f=salariesi_3*(-1)
		gen salariesi12_avgf=salariesi12_avg*(-1)
		gen salariesi34_avgf=salariesi34_avg*(-1)
		gen salariesi56_avgf=salariesi56_avg*(-1)
		gen salariesi78_avgf=salariesi78_avg*(-1)
		gen salariesi910_avgf=salariesi910_avg*(-1)
		gen salariesi1112_avgf=salariesi1112_avg*(-1)
		gen salariesi1314_avgf=salariesi1314_avg*(-1)
		gen salariesi1516_avgf=salariesi1516_avg*(-1)
		
		gen emp_index_iu2f=emp_index_iu2*(-1)
		gen emp_index_32f=emp_index_32*(-1)
		gen emp_index_3f=emp_index_3*(-1)
		gen emp_index12f=emp_index12*(-1)

********************************************************************************
sort hhidpn year

save "U:\Duque_and_Schmitz\Data\HRS_Great_Depression_FINAL_JHR.dta", replace	
	

