*********************************************************************************************************************************************************************************
***STEP 1: HRS DATA MERGE***
	*Project: Early-life Exposures to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
*********************************************************************************************************************************************************************************

clear
#delimit ;
set more off;

	global HRSPanel="U:\Schmitz HRS Data\HRSPanel";
		
	global HRS18="U:\Schmitz HRS Data\HRS2018";
	global HRS16="U:\Schmitz HRS Data\HRS2016";
	global HRS14="U:\Schmitz HRS Data\HRS2014";
	global HRS12="U:\Schmitz HRS Data\HRS2012";
	global HRS10="U:\Schmitz HRS Data\HRS2010";
	global HRS08="U:\Schmitz HRS Data\HRS2008";
	global HRS06="U:\Schmitz HRS Data\HRS2006";
	global HRS04="U:\Schmitz HRS Data\HRS2004";
	global HRS02="U:\Schmitz HRS Data\HRS2002";
	global HRS00="U:\Schmitz HRS Data\HRS2000";
	global HRS98="U:\Schmitz HRS Data\HRS1998";
	global HRS96="U:\Schmitz HRS Data\HRS1996";
	
	global IOXWAVE="U:\Schmitz_Restricted\IOXWAVE";
	global GEOSTATE="U:\Schmitz_Restricted\Geo_Data";
	
	global SSWEIGHTS="U:\Schmitz_Restricted\SSWEIGHTS";
	global SSLTEARN="U:\Schmitz_Restricted\SSLTEARN";
	
	global EXIT02="U:\Schmitz HRS Data\EXIT_2002";
	global EXIT04="U:\Schmitz HRS Data\EXIT_2004";
	global EXIT06="U:\Schmitz HRS Data\EXIT_2006";
	global EXIT08="U:\Schmitz HRS Data\EXIT_2008";
	global EXIT10="U:\Schmitz HRS Data\EXIT_2010";
	global EXIT12="U:\Schmitz HRS Data\EXIT_2012";
	global EXIT14="U:\Schmitz HRS Data\EXIT_2014";
	global EXIT16="U:\Schmitz HRS Data\EXIT_2016";
	global EXIT18="U:\Schmitz HRS Data\EXIT_2018";
	

/*MERGE IN DATA FROM RAND PANEL*/

	use hhid pn hhidpn /*unique identifiers*/

		/*IDENTIFIERS*/
			r1wtresp r2wtresp r3wtresp r4wtresp r5wtresp r6wtresp r7wtresp r8wtresp r9wtresp r10wtresp r11wtresp r12wtresp r13wtresp /*respondent person-level analysis weight; *NOTE: 2018 person-level weight was not available in this version of the HRS RAND HRS Longitudinal File*/				
			rawtsamp /*1992 sampling weight*/
			raestrat /*STRATUM*/ raehsamp /*SECU*/
			inw1 inw2 inw3 inw4 inw5 inw6 inw7 inw8 inw9 inw10 inw11 inw12 inw13 inw14 /*wave response indicator*/
			r1iwstat r2iwstat r3iwstat r4iwstat r5iwstat r6iwstat r7iwstat r8iwstat r9iwstat r10iwstat r11iwstat r12iwstat r13iwstat r14iwstat /*wave status*/

		/*DEMOGRAPHICS*/
			racohbyr /*cohort status by birth year*/
			hacohort /*chort status by sampling*/
			rabyear /*birth year*/
			rabmonth /*birth month*/

			r1agey_b r2agey_b r3agey_b r4agey_b r5agey_b r6agey_b r7agey_b r8agey_b r9agey_b r10agey_b r11agey_b r12agey_b r13agey_b r14agey_b /*age at interview in years*/
			ragender /*gender*/
			raracem rahispan /*race variables*/
			raedyrs /*years of education*/
			raedegrm /*highest degree obtained*/
			r1mstat r2mstat r3mstat r4mstat r5mstat r6mstat r7mstat r8mstat r9mstat r10mstat r11mstat r12mstat r13mstat r14mstat /*marital status*/

		/*HEALTH AND HEALTH BEHAVIORS*/
			r1height r2height r3height r4height r5height r6height r7height r8height r9height r10height r11height r12height r13height r14height /*Height in meters*/
			r1weight r2weight r3weight r4weight r5weight r6weight r7weight r8weight r9weight r10weight r11weight r12weight r13weight r14weight /*Self-reported weight*/
			r1shlt r2shlt r3shlt r4shlt r5shlt r6shlt r7shlt r8shlt r9shlt r10shlt r11shlt r12shlt r13shlt r14shlt /*self-reported health status*/
			r1bmi r2bmi r3bmi r4bmi r5bmi r6bmi r7bmi r8bmi r9bmi r10bmi r11bmi r12bmi r13bmi r14bmi /*BMI*/
			r1hibp r2hibp r3hibp r4hibp r5hibp r6hibp r7hibp r8hibp r9hibp r10hibp r11hibp r12hibp r13hibp r14hibp /*high blood pressure or hypertension*/  
			r1diab r2diab r3diab r4diab r5diab r6diab r7diab r8diab r9diab r10diab r11diab r12diab r13diab r14diab /*diabetes or high blood sugar*/
			r1cancr r2cancr r3cancr r4cancr r5cancr r6cancr r7cancr r8cancr r9cancr r10cancr r11cancr r12cancr r13cancr r14cancr /*cancer or malignant tumor except skin cancer*/
			r1lung r2lung r3lung r4lung r5lung r6lung r7lung r8lung r9lung r10lung r11lung r12lung r13lung r14lung /*lung disease except chronic asthma*/
			r1heart r2heart r3heart r4heart r5heart r6heart r7heart r8heart r9heart r10heart r11heart r12heart r13heart r14heart /*heart problems*/
			r1strok r2strok r3strok r4strok r5strok r6strok r7strok r8strok r9strok r10strok r11strok r12strok r13strok r14strok /*stroke or transient ischemic attack, TIA*/
			r1psych r2psych r3psych r4psych r5psych r6psych r7psych r8psych r9psych r10psych r11psych r12psych r13psych r14psych /*psyche problems*/
			r1arthr r2arthr r3arthr r4arthr r5arthr r6arthr r7arthr r8arthr r9arthr r10arthr r11arthr r12arthr r13arthr r14arthr /*arthritis or rheumatism*/
			
		/*LABOR MARKET INFO*/
			r1work r2work r3work r4work r5work r6work r7work r8work r9work r10work r11work r12work r13work r14work /*currently working for pay-respondent*/
			r1slfemp r2slfemp r3slfemp r4slfemp r5slfemp r6slfemp r7slfemp r8slfemp r9slfemp r10slfemp r11slfemp r12slfemp r13slfemp r14slfemp /*currently self-employed-respondent*/
			r1lbrf r2lbrf r3lbrf r4lbrf r5lbrf r6lbrf r7lbrf r8lbrf r9lbrf r10lbrf r11lbrf r12lbrf r13lbrf r14lbrf /*labor force status-respondent*/
			r1sayret r2sayret r3sayret r4sayret r5sayret r6sayret r7sayret r8sayret r9sayret r10sayret r11sayret r12sayret r13sayret r14sayret /*whether completely or partially retired-respondent*/

			r1jcocc r2jcocc r3jcocc r4jcocc r5jcocc r6jcocc r7jcocc r8jcocc r9jcocc r10jcocc r11jcocc r12jcocc r13jcocc r14jcocc /*1980 census occupation code at current job*/
			r8jcoccb r9jcoccb r10jcoccb r11jcoccb r12jcoccb r13jcoccb r14jcoccb /*2000 census occupation code at current job*/
			r1jcind r2jcind r3jcind r4jcind r5jcind r6jcind r7jcind r8jcind r9jcind r10jcind r11jcind r12jcind r13jcind r14jcind /*1980 census industry code at current job*/
			r8jcindb r9jcindb r10jcindb r11jcindb r12jcindb r13jcindb r14jcindb /*2000 census industry code at current job*/
			r1jlocc r2jlocc r3jlocc r4jlocc r5jlocc r6jlocc r7jlocc r8jlocc r9jlocc r10jlocc r11jlocc r12jlocc r13jlocc r14jlocc /*1980 census occ code for job with longest tenure*/
			r1jlind r2jlind r3jlind r4jlind r5jlind r6jlind r7jlind r8jlind r9jlind r10jlind r11jlind r12jlind r13jlind r14jlind /*1980 census ind code for job with longest tenure*/	
			
		/*INCOME*/
			r1iearn r2iearn r3iearn r4iearn r5iearn r6iearn r7iearn r8iearn r9iearn r10iearn r11iearn r12iearn r13iearn r14iearn /*total individual earnings-respondent*/
			h1itot h2itot h3itot h4itot h5itot h6itot h7itot h8itot h9itot h10itot h11itot h12itot h13itot h14itot /*total household income*/

		/*WEALTH*/
			h1atotw  h2atotw h3atotw h4atotw h5atotw h6atotw h7atotw h8atotw h9atotw h10atotw h11atotw h12atotw h13atotw h14atotw /*total household wealth less IRA*/
			h1atota h2atota h3atota h4atota h5atota h6atota h7atota h8atota h9atota h10atota h11atota h12atota h13atota h14atota /*total household wealth less secondary residence*/
			h1atotb h2atotb h4atotb h5atotb h6atotb h7atotb h8atotb h9atotb h10atotb h11atotb h12atotb h13atotb h14atotb /*total household wealth including secondary residence--NOTE: in W3 question about second home not asked*/

		/*FAMILY INFO*/
			h1child h2child h3child h4child h5child h6child h7child h8child h9child h10child h11child h12child h13child h14child /*number of children in household--NOTE: may need to merge this one to many by household!*/
			rafeduc /*years of education:father*/
			rameduc /*years of education:mother*/

		/*VETEREN STATUS*/
			ravetrn

		/*GEOGRAPHIC INFO*/
			r1cenreg r2cenreg r3cenreg r4cenreg r5cenreg r6cenreg r7cenreg r8cenreg r9cenreg r10cenreg r11cenreg r12cenreg r13cenreg r14cenreg /*census region currently living in*/
			r1cendiv r2cendiv r3cendiv r4cendiv r5cendiv r6cendiv r7cendiv r8cendiv r9cendiv r10cendiv r11cendiv r12cendiv r13cendiv r14cendiv /*census division currently living in*/
			rabplace /*census region born in*/ 

	using "${HRSPanel}\randhrs1992_2018v1", clear;
	sort hhidpn;
	tempfile Panel;
	save "`Panel'", replace;

/*MERGE IN RESTRICTED 3 DIGIT OCC AND IND DATA*/

	use hhid pn hhidpn 

		/*CURRENT OCCUPATION AT NEW/CURRENT JOB (1980 Census Occ Codes)*/
			v2720
			w3609
			e2732 
			f3255
			g3505
			hj168
			jj168
		/*CURRENT OCCUPATION AT NEW/CURRENT JOB (2000 Census Occ Codes)*/
			kj168
			lj168
			mj168_2000
		/*CURRENT OCCUPATION AT NEW/CURRENT JOB (2010 Census Occ Codes)*/
			nj168
			oj168
			pj168

		/*CURRENT INDUSTRY AT NEW/CURRENT JOB (1980 Census Ind Codes)*/
			v2719
			w3608
			e2730
			f3253
			g3503
			hj166
			jj166
		/*CURRENT INDUSTRY AT NEW/CURRENT JOB (2000 Census Ind Codes)*/
			kj166
			lj166
			mj166_2000
		/*CURRENT INDUSTRY AT NEW/CURRENT JOB (2007 Census Ind Codes)*/
			nj166
			oj166
			pj166
			
		/*LONGEST HELD JOB (1980 Census Occ Codes)*/
			v3606
			w7107
			f3841
			g4103
			hl015
			jl015
		/*LONGEST HELD JOB (2000 Census Occ Codes)*/
			kl015
			ll015
			ml015_2000
		/*LONGEST HELD JOB (2010 Census Occ Codes)*/
			nl015
			ol015
			pl015_1
		/*NOTE: not available in 1994*/
		
		/*INDUSTRY AT LONGEST HELD JOB (1980 Census Ind Codes)*/
			v3605
			w7106
			f3839
			g4101
			hl013
			jl013
		/*INDUSTRY AT LONGEST HELD JOB (2000 Census Ind Codes)*/
			kl013
			ll013
			ml013_2000
		/*INDUSTRY AT LONGEST HELD JOB (2007 Census Ind Codes)*/
			nl013
			ol013
			pl013_1
		/*NOTE: not available in 1994*/

		/*LAST JOB INDUSTRY (1980 Census Ind Codes)*/
			v3406
			w7006
			e3132
			f3650
			g3960
			hk008
			jk008
		/*LAST JOB INDUSTRY (2002 Census Ind Codes)*/
			kk008
			lk008
			mk008_2000
		/*LAST JOB INDUSTRY (2007 Census Ind Codes)*/
			nk008
			ok008

		/*LAST JOB OCCUPATION (1980 Census Occ Codes)*/
			v3407
			w7007
			e3134
			f3652
			g3962
			hk010
			jk010
		/*LAST JOB OCCUPATION (2000 Census Occ Codes)*/
			kk010
			lk010
			mk010_2000
		/*LAST JOB OCCUPATION (2010 Census Occ Codes)*/
			nk010
			ok010

		/*LAST JOB INDUSTRY IF SELF-EMPLOYED (1980 Census Occ Codes)*/
			v3431
		/*After 1992 asked simultaneously with other last job question*/

		/*LAST JOB OCCUPATION IF SELF-EMPLOYED (1980 Census Occ Codes)*/
			v3432
		/*After 1992 asked simultaneously with other last job question*/
		
		/*FATHERS USUAL OCCUPATION (1980 Census Occ Codes)*/
			f997
			g1084
			hb024
			jb024
		/*FATHER'S USUAL OCCUPATION (2000 Census Occ Codes)*/
			kb024
			lb024
			mb024_2000
		/*FATHER'S USUAL OCCUPATION (2010 Census Occ Codes)*/
			nb024
			ob024

	using "${IOXWAVE}\ioxwave16", clear;
	sort hhidpn;
	tempfile restrict_occ_ind;
	save "`restrict_occ_ind'", replace;


/*MERGE IN RESTRICTED STATE OF RESIDENCE DATA*/;

	use hhid pn hhidpn 

		/*State of birth*/
			bornus /*born in the US?*/
			staborn /*State born in*/
			whrliv10 /*State R lived in most of the time when they were (in grade school/high school/about age 10)?*/

		/*Current USPS state of residence*/
			stateusps92
			stateusps94
			stateusps96
			stateusps98
			stateusps00
			stateusps02
			stateusps04
			stateusps06
			stateusps08
			stateusps10
			stateusps12
			stateusps14
			stateusps16
			stateusps18

		/*State FIPS for current state of residence*/
			stfips92
			stfips94
			stfips96
			stfips98
			stfips00
			stfips02
			stfips04
			stfips06
			stfips08
			stfips10
			stfips12
			stfips14
			stfips16
			stfips18

	using "${GEOSTATE}\HRSxState18", clear;
	sort hhidpn;
	tempfile restrict_geo_state;
	save "`restrict_geo_state'", replace;
	

/*MERGE IN ADDITIONAL DATA FROM RAND FAT FILES*/

	/*1996*/;

		use hhid pn hhidpn

			/*CHILDHOOD VARIABLES*/
				e5648 /*self-reported childhood health status*/
				e715m /*region lived in most of the time while in school*/
				e718 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				e5654m /*father's occupation-1980 Census categories*/
			
			/*FRAILTY INDEX VARIABLES*/
				e1888 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				e1870 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				e972 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				e878 /*Have you fallen down in the last two years?*/

		using "${HRS96}\h96f4a", clear;
		sort hhidpn;
		tempfile hrs1996;
		save "`hrs1996'", replace;

	/*1998*/;
		use hhid pn hhidpn  

			/*CHILDHOOD VARIABLES*/
				f992 /*self-reported childhood health status*/
				f1035m /*region lived in most of the time while in school*/
				f1038 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				f997hm /*father's occupation-1980 Census categories*/
				f996 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				f2418 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				f2400 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				f1309 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				f1206 /*Have you fallen down in the last two years?*/

		using "${HRS98}\hd98f2b", clear;
		sort hhidpn;
		tempfile hrs1998;
		save "`hrs1998'", replace;

	/*2000*/;

		use hhid pn hhidpn

			/*CHILDHOOD VARIABLES*/
				g1079 /*self-reported childhood health status*/
				g1122m /*region lived in most of the time while in school*/
				g1125 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				g1084m /*father's occupation-1980 Census categories*/
				g1083 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				g2716 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				g2698 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				g1442 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				g1339 /*Have you fallen down in the last two years?*/
				
		using "${HRS00}\h00f1c", clear;
		sort hhidpn;
		tempfile hrs2000;
		save "`hrs2000'", replace;

	/*2002*/;

		use hhid pn hhidpn 

			/*CHILDHOOD VARIABLES*/
				hb019 /*self-reported childhood health status*/
				hb047m /*region lived in most of the time while in school*/
				hb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				hb024m /*father's occupation-1980 Census categories*/
				hb023 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				hg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				hg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				hc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				hc079 /*Have you fallen down in the last two years?*/
				
		using "${HRS02}/h02f2c", clear;
		sort hhidpn;
		tempfile hrs2002;
		save "`hrs2002'", replace;
		
	/*2004*/;

		use hhid pn hhidpn

			/*CHILDHOOD VARIABLES*/
				jb019 /*self-reported childhood health status*/
				jb047m /*region lived in most of the time while in school*/
				jb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				jb024m /*father's occupation-1980 Census categories*/
				jb023 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				jg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				jg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				jc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				jc079 /*Have you fallen down in the last two years?*/
					
			using "${HRS04}\h04f1a", clear;
			sort hhidpn;
			tempfile hrs2004;
			save "`hrs2004'", replace;

	/*2006*/;

		use hhid pn hhidpn 

			/*CHILDHOOD VARIABLES*/
				kb019 /*self-reported childhood health status*/
				kb047m /*region lived in most of the time while in school*/
				kb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				kb024m /*father's occupation-2000 Census categories*/
				kb023 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				kg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				kg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				kc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				kc079 /*Have you fallen down in the last two years?*/
								
		using "${HRS06}\h06f2b", clear;
		sort hhidpn;
		tempfile hrs2006;
		save "`hrs2006'", replace;

	/*2008*/;

		use hhid pn hhidpn 

			/*CHILDHOOD VARIABLES*/
				lb019 /*self-reported childhood health status*/
				lb047m /*region lived in most of the time while in school*/
				lb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				lb024m /*father's occupation-2010 Census categories*/
				lb023 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				lg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				lg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				lc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				lc079 /*Have you fallen down in the last two years?*/
								
		using "${HRS08}\h08f1b", clear;
		sort hhidpn;
		tempfile hrs2008;
		save "`hrs2008'", replace;
	
	/*2010*/;

		use hhid pn hhidpn 

			/*CHILDHOOD VARIABLES*/
				mb019 /*self-reported childhood health status*/
				mb047m /*region lived in most of the time while in school*/
				mb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/
				mb024m /*father's occupation-2000 Census categories*/
				mb023 /*father unemployed in childhood*/

			/*FRAILTY INDEX VARIABLES*/
				mg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				mg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				mc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				mc079 /*Have you fallen down in the last two years?*/
								
		using "${HRS10}\hd10f5b", clear;
		sort hhidpn;
		tempfile hrs2010;
		save "`hrs2010'", replace;
		*NOTE: PRIOR VERSION USED h10e1a;

	/*2012*/;

		use hhid pn hhidpn 
		
			/*CHILDHOOD VARIABLES*/
				nb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/

			/*FRAILTY INDEX VARIABLES*/
				ng011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				ng005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				nc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				nc079 /*Have you fallen down in the last two years?*/
				
		using "${HRS12}\h12f1a", clear;
		sort hhidpn;
		tempfile hrs2012;
		save "`hrs2012'", replace;

	/*2014*/;

		use hhid pn hhidpn 
			
			/*CHILDHOOD VARIABLES*/
				ob049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/

			/*FRAILTY INDEX VARIABLES*/
				og011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				og005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				oc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				oc079 /*Have you fallen down in the last two years?*/
				
		using "${HRS14}\h14f2a", clear;
		sort hhidpn;
		tempfile hrs2014;
		save "`hrs2014'", replace;

	/*2016*/;

		use hhid pn hhidpn 
		
			/*CHILDHOOD VARIABLES*/
				pb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/

			/*FRAILTY INDEX VARIABLES*/
				pg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				pg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				pc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				pc079 /*Have you fallen down in the last two years?*/

		using "${HRS16}\h16f2a", clear;
		sort hhidpn;
		tempfile hrs2016;
		save "`hrs2016'", replace;

	/*2018*/;

		use hhid pn hhidpn 

			/*CHILDHOOD VARIABLES*/
				qb049 /*living in an urban or rural area most of the time when you were in grade school/hs/about age 10*/

			/*FRAILTY INDEX VARIABLES*/
				qg011 /*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
				qg005 /*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
				qc148 /*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
				qc079 /*Have you fallen down in the last two years?*/

		using "${HRS18}\h18e1a", clear;
		sort hhidpn;
		tempfile hrs2018;
		save "`hrs2018'", replace;

/*MERGE IN EXIT INTERVIEW DATA ON HEALTH*/
	
	/*2002*/
		use hhid pn hhidpn

			sa133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			sa133m2m
		
		using "${EXIT02}/x02A_R", clear;
		sort hhidpn;
		tempfile exit2002_A;
		save "`exit2002_A'", replace;


	/*2004*/
		use hhid pn hhidpn

			ta133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			ta133m2m
		
		using "${EXIT04}/x04A_R", clear;
		sort hhidpn;
		tempfile exit2004_A;
		save "`exit2004_A'", replace;


	/*2006*/
		use hhid pn hhidpn

			ua133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			ua133m2m
		
		using "${EXIT06}/x06A_R", clear;
		sort hhidpn;
		tempfile exit2006_A;
		save "`exit2006_A'", replace;
		
	/*2008*/
		use hhid pn hhidpn

			va133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			va133m2m
		
		using "${EXIT08}/x08A_R", clear;
		sort hhidpn;
		tempfile exit2008_A;
		save "`exit2008_A'", replace;

	/*2010*/
		use hhid pn hhidpn

			wa133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			wa133m2m
		
		using "${EXIT10}/x10A_R", clear;
		sort hhidpn;
		tempfile exit2010_A;
		save "`exit2010_A'", replace;

	/*2012*/
		use hhid pn hhidpn

			xa133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			xa133m2m
		
		using "${EXIT12}/x12A_R", clear;
		sort hhidpn;
		tempfile exit2012_A;
		save "`exit2012_A'", replace;
		
	/*2014*/
		use hhid pn hhidpn

			ya133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			ya133m2m
		
		using "${EXIT14}/x14A_R", clear;
		sort hhidpn;
		tempfile exit2014_A;
		save "`exit2014_A'", replace;

	/*2016*/
		use hhid pn hhidpn

			za133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			za133m2m
		
		using "${EXIT16}/x16A_R", clear;
		sort hhidpn;
		tempfile exit2016_A;
		save "`exit2016_A'", replace;

	/*2018*/
		use hhid pn hhidpn

			xqa133m1m /*What was the major illness that led to (his/her) death? Can list two causes*/
			xqa133m2m
		
		using "${EXIT18}/x18A_R", clear;
		sort hhidpn;
		tempfile exit2018_A;
		save "`exit2018_A'", replace;

			
	/*MERGE IN SSA WEIGHTS*/

		/*1992*/
			use hhid pn hhidpn
			
				r1wtsswr /*respondent level weight*/

					using "${SSWEIGHTS}\SSWGTSA_R", clear;
						sort hhidpn;
						tempfile ssweights92;
							save "`ssweights92'", replace;

		/*1998*/
			use hhid pn hhidpn
			
				r4wtsswr /*respondent level weight*/

					using "${SSWEIGHTS}\SSWGTSF_R", clear;
						sort hhidpn;
						tempfile ssweights98;
							save "`ssweights98'", replace;

		/*2004-2012*/
			use hhid pn hhidpn
			
				sswgtsj_cur sswgtsk_cur sswgtsl_cur sswgtsm_cur sswgtsn_cur /*respondent level weight: current linkage in SSA files*/
				sswgtsj_ev sswgtsk_ev sswgtsl_ev sswgtsm_ev sswgtsn_ev /*respondent level weight: ever linked in SSA files*/

					using "${SSWEIGHTS}\SSweights_JN", clear;
						sort hhidpn;
						tempfile ssweights04_12;
							save "`ssweights04_12'", replace;
						
/*MERGE FILES TOGETHER*/

	use "`Panel'", clear;

		merge 1:1 hhidpn using "`hrs1996'";
			drop _merge;
			sort hhid pn hhidpn;

		merge 1:1 hhidpn using "`hrs1998'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2000'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2002'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2004'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2006'";
			drop _merge;
			sort hhidpn;

		merge hhidpn using "`hrs2008'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2010'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2012'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2014'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`hrs2016'";
			drop _merge;
			sort hhidpn;
			
		merge 1:1 hhidpn using "`hrs2018'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`restrict_occ_ind'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`restrict_geo_state'";
			drop _merge;
			sort hhidpn;

	destring hhid, replace; /*needed to merge RAND files with HRS EXIT files*/
	destring pn, replace;
		
		merge 1:1 hhidpn using "`exit2002_A'";
			drop _merge;
			sort hhidpn;
			
		merge 1:1 hhidpn using "`exit2004_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2006_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2008_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2010_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2012_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2014_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2016_A'";
			drop _merge;
			sort hhidpn;

		merge 1:1 hhidpn using "`exit2018_A'";
			drop _merge;
			sort hhidpn;

		merge hhidpn using "`ssweights92'";
			drop _merge;
			sort hhidpn;

		merge hhidpn using "`ssweights98'";
			drop _merge;
			sort hhidpn;

		merge hhidpn using "`ssweights04_12'";
			drop _merge;
			sort hhidpn;
			
	describe, detail;

	
save "U:\Schmitz_Restricted\HRSJobPanelDatawide_WC_FINAL_JHR.dta", replace;
