**************************************************************************************************************
***PRE-ANALYSIS ADJUSTMENTS TO DATA ON NEW DEAL SPENDING***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
set more off

	*Import Infant Birth and Death Data from NBER 

		use "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/Raw_New_Deal_Data.dta" 
			*Data source: Fishback, Price, and Kantor, Shawn. New Deal Studies: New Deal Spending. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2018-11-18. https://doi.org/10.3886/E101199V1-24102

				drop state
				rename stname state
				sort state
			
			*Sum observations by state, creating one observation per state
				collapse(sum) pop30 fera cwa wpa pubass pwaf pwanf2 pwanf1 pra pba aaa fca fsarr2 fsalo rea rfc holc ushalc ushah, by(state)				

			*Assign HRS coding for state of birth for merge with HRS data
				generate st_born=.

					replace	st_born	=	1	if state==	"Alabama"
					replace	st_born	=	3	if state==	"Arizona"
					replace	st_born	=	4	if state==	"Arkansas"
					replace	st_born	=	5	if state==	"California"
					replace	st_born	=	6	if state==	"Colorado"
					replace	st_born	=	7	if state==	"Connecticut"
					replace	st_born	=	8	if state==	"Delaware"
					replace	st_born	=	9	if state==	"Florida"
					replace	st_born	=	10	if state==	"Georgia"
					replace	st_born	=	12	if state==	"Idaho"
					replace	st_born	=	13	if state==	"Illinois"
					replace	st_born	=	14	if state==	"Indiana"
					replace	st_born	=	15	if state==	"Iowa"
					replace	st_born	=	16	if state==	"Kansas"
					replace	st_born	=	17	if state==	"Kentucky"
					replace	st_born	=	18	if state==	"Louisiana"
					replace	st_born	=	19	if state==	"Maine"
					replace	st_born	=	20	if state==	"Maryland"
					replace	st_born	=	21	if state==	"Massachusetts"
					replace	st_born	=	22	if state==	"Michigan"
					replace	st_born	=	23	if state==	"Minnesota"
					replace	st_born	=	24	if state==	"Mississippi"
					replace	st_born	=	25	if state==	"Missouri"
					replace	st_born	=	26	if state==	"Montana"
					replace	st_born	=	27	if state==	"Nebraska"
					replace	st_born	=	28	if state==	"Nevada"
					replace	st_born	=	29	if state==	"New Hampshire"
					replace	st_born	=	30	if state==	"New Jersey"
					replace	st_born	=	31	if state==	"New Mexico"
					replace	st_born	=	32	if state==	"New York"
					replace	st_born	=	33	if state==	"North Carolina"
					replace	st_born	=	34	if state==	"North Dakota"
					replace	st_born	=	35	if state==	"Ohio"
					replace	st_born	=	36	if state==	"Oklahoma"
					replace	st_born	=	37	if state==	"Oregon"
					replace	st_born	=	38	if state==	"Pennsylvania"
					replace	st_born	=	39	if state==	"Rhode Island"
					replace	st_born	=	40	if state==	"South Carolina"
					replace	st_born	=	41	if state==	"South Dakota"
					replace	st_born	=	42	if state==	"Tennessee"
					replace	st_born	=	43	if state==	"Texas"
					replace	st_born	=	44	if state==	"Utah"
					replace	st_born	=	45	if state==	"Vermont"
					replace	st_born	=	46	if state==	"Virginia"
					replace	st_born	=	47	if state==	"Washington"
					replace	st_born	=	48	if state==	"West Virginia"
					replace	st_born	=	49	if state==	"Wisconsin"
					replace	st_born	=	50	if state==	"Wyoming"

			rename st_born st_born2
			rename state st_born_name
			
			sort st_born2 	
		
		* Generate a total spending or cross-sectional variable that is the sum of relief spending, public works spending, farm program spending, and housing market spending 
			
			/*Generate relief spending variable that is the sum of the following:
				•	fera = 'Fed. Emergency Relief Admin. grants'
				•	cwa = 'Civil Works Admin. grants'
				•	wpa = 'Works Progress Admin. grants'
				•	pubass = 'Public Assistance Grants--Soc Sec Act.' */
					gen relief_cs = fera + cwa + wpa + pubass

			/* Generate a public works spending variable that is the sum of the following:
				•	pwaf = 'Public Works Admin. federal grants' 
				•	pwanf2= 'Public Works Admin. nonfederal grants'
				•	pwanf1= 'Public Works Admin. nonfederal loans'
				•	pra= 'public roads admin. grants'
				•	pba= 'public buildings admin. grants' */
					gen pubworks_cs = pwaf + pwanf2 + pwanf1 + pra + pba 

			/* Generate a farm programs spending variable that is the sum of the following:
				•	aaa= ‘Agricultural Adjustment Admin. grants’
				•	fca= ‘Farm Credit Admin. loans’
				•	fsarr2= ‘Farm Security Admin. Rural Rehab grants’
				•	fsalo= ‘Farm Security Admin. Rural Rehab loans’
				•	rea= ‘Rural Electrification Admin. loans’ */
					gen farm_cs = aaa + fca + fsarr2 + fsalo + rea 

			/* Generate a housing market spending variable that is the sum of the following:
				•	rfc = 'Reconstruction Finance Corp. loans'
				•	holc = 'Home Owners Loan Corporation loans'
				•	ushalc = 'U.S. Housing Admin. loan contracts'
				•	ushah = 'U.S. Housing Admin. grants' */
					gen housing_cs = rfc + holc + ushalc + ushah

					*Generate a total spending variable, the sum of relief, public works, and housing
						gen total_relief_cs = relief_cs + pubworks_cs + farm_cs + housing_cs

					*Generate a per capita variable for total spending
						gen total_relief_pc_cs = total/pop30
		
	*Drop variables not needed
		keep st_born2 st_born_name total_relief_pc_cs

	*Label variables
		label var st_born_name "State of birth name"
		label var st_born2 "HRS state of birth code"
		label var total_relief_pc_cs "Total per capita New Deal spending on relief, public works, farm programs, and housing"
		
save "/Users/laurenschmitz/Dropbox/2022_ACTIVE_PROJECTS/Duque_&_Schmitz/GD_Epigenetic_Clocks_Project/Data/New_Deal_Spending_Data_FINAL.dta", replace
