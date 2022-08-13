*****************************************************************************************************************************************************************
***CODE TO CREATE FIGURE 2: EFFECT OF WAGE INDEX DECLINES DURING THE PRECONCEPTION, IN UTERO, CHILDHOOD, AND ADOLESCENT PERIODS ON GRIMAGE EAA AND DUNEDINPOAM***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
*****************************************************************************************************************************************************************

clear
set more off

cd "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Results/Figure_2"

	set scheme modern

		*NOTE: Pearson r effect sizes used below were calculated with respect to the standard deviation (SD) of wage index declines in utero and the SD of the outcome (GrimAge EAA or DunedinPoAm). Please see the Readme.doc file for further information on the calculation of Pearson r effect sizes.		
		
	*Set up coefficient matrix with Pearson r effect sizes for GrimAge EAA

		matrix GA_pr=J(1,10,.)
			matrix colnames GA_pr="Age -3 to -2" "In Utero" "Age 1-2" "Age 3-4" "Age 5-6" "Age 7-8" "Age 9-10" "Age 11-12" "Age 13-14" "Age 15-16"		
				matrix GA_pr[1,1]=-0.0103
				matrix GA_pr[1,2]=0.3388
				matrix GA_pr[1,3]=0.0585
				matrix GA_pr[1,4]=0.0415
				matrix GA_pr[1,5]=0.0348
				matrix GA_pr[1,6]=0.0079
				matrix GA_pr[1,7]=0.0787
				matrix GA_pr[1,8]=-0.0067
				matrix GA_pr[1,9]=-0.0245
				matrix GA_pr[1,10]=-0.0384

			*Set up confidence interval (CI) matrix using Pearson r effect size standard errors for GrimAge EAA

				matrix GA_CI=J(2,10,.)
					matrix colnames GA_CI="Age -3 to -2" "In Utero" "Age 1-2" "Age 3-4" "Age 5-6" "Age 7-8" "Age 9-10" "Age 11-12" "Age 13-14" "Age 15-16"
					matrix rownames GA_CI=ll95 ul95
						matrix GA_CI[1,1]=-0.3892
						matrix GA_CI[1,2]=0.0963
						matrix GA_CI[1,3]=-0.1344
						matrix GA_CI[1,4]=-0.1228
						matrix GA_CI[1,5]=-0.0954
						matrix GA_CI[1,6]=-0.1300
						matrix GA_CI[1,7]=-0.0221
						matrix GA_CI[1,8]=-0.1726
						matrix GA_CI[1,9]=-0.1896
						matrix GA_CI[1,10]=-0.1639
						
						matrix GA_CI[2,1]=0.3687
						matrix GA_CI[2,2]=0.5814
						matrix GA_CI[2,3]=0.2515
						matrix GA_CI[2,4]=0.2058
						matrix GA_CI[2,5]=0.1650
						matrix GA_CI[2,6]=0.1459
						matrix GA_CI[2,7]=0.1794
						matrix GA_CI[2,8]=0.1591
						matrix GA_CI[2,9]=0.1406
						matrix GA_CI[2,10]=0.0872
							
				coefplot (matrix(GA_pr), ci((GA_CI[1] GA_CI[2]))), ///
					vertical ciopts(recast(rcap) color(black) lwidth(vthin)) citop title(GrimAge EAA) yline(0, lcolor(gray) lwidth(vthin)) xlabel(,angle(45))

			graph save GrimAge_EAA_IU, replace

	
	*Set up coefficient matrix with Pearson r effect sizes for DunedinPoAm

		matrix PA_pr=J(1,10,.)
			matrix colnames PA_pr="Age -3 to -2" "In Utero" "Age 1-2" "Age 3-4" "Age 5-6" "Age 7-8" "Age 9-10" "Age 11-12" "Age 13-14" "Age 15-16"		
				matrix PA_pr[1,1]=-0.2857
				matrix PA_pr[1,2]=0.5101
				matrix PA_pr[1,3]=-0.1020
				matrix PA_pr[1,4]=0.1837
				matrix PA_pr[1,5]=-0.0053
				matrix PA_pr[1,6]=0.0204
				matrix PA_pr[1,7]=0.0408
				matrix PA_pr[1,8]=-0.0055
				matrix PA_pr[1,9]=-0.0612
				matrix PA_pr[1,10]=-0.1428
											
			*Set up confidence interval (CI) matrix using Pearson r effect size standard errors for DunedinPoAm
													
				matrix PA_CI=J(2,10,.)
					matrix colnames PA_CI="Age -3 to -2" "In Utero" "Age 1-2" "Age 3-4" "Age 5-6" "Age 7-8" "Age 9-10" "Age 11-12" "Age 13-14" "Age 15-16"
					matrix rownames PA_CI=ll95 ul95
						matrix PA_CI[1,1]=-0.8856
						matrix PA_CI[1,2]=0.2302
						matrix PA_CI[1,3]=-0.3420
						matrix PA_CI[1,4]=-0.0563
						matrix PA_CI[1,5]=-0.1653
						matrix PA_CI[1,6]=-0.1396
						matrix PA_CI[1,7]=-0.1192
						matrix PA_CI[1,8]=-0.2455
						matrix PA_CI[1,9]=-0.3412
						matrix PA_CI[1,10]=-0.3028
										
													
						matrix PA_CI[2,1]=0.3142
						matrix PA_CI[2,2]=0.7901
						matrix PA_CI[2,3]=0.1379
						matrix PA_CI[2,4]=0.4236
						matrix PA_CI[2,5]=0.1547
						matrix PA_CI[2,6]=0.1804
						matrix PA_CI[2,7]=0.2008
						matrix PA_CI[2,8]=0.2345
						matrix PA_CI[2,9]=0.2188
						matrix PA_CI[2,10]=0.0171
																								
				coefplot (matrix(PA_pr), ci((PA_CI[1] PA_CI[2]))), ///
					vertical ciopts(recast(rcap) color(black) lwidth(vthin)) citop title(DunedinPoAM) yline(0, lcolor(gray) lwidth(vthin)) xlabel(,angle(45))

			graph save POAM_IU, replace

	*Combine plots into one figure

		gr combine GrimAge_EAA_IU.gph POAM_IU.gph, scheme(modern) col(2) ycommon
		
			graph save Combined_GrimAge_PoAm_PearsonR_ETS_Plot_IU_FINAL.gph, replace	
