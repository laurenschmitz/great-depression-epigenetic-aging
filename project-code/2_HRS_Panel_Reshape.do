**************************************************************************************************************
***STEP TWO: RESHAPE DATA FROM WIDE FORMAT TO PANEL FORMAT***	
	*Project: In Utero Exposure to the Great Depression is Reflected in Late-Life Epigenetic Aging Signatures
	*Authors: Lauren L. Schmitz and Valentina Duque
	*Analyst: Lauren L. Schmitz
	*Date updated: August 2022
**************************************************************************************************************

clear
#delimit ;
set more off;

use "U:\Schmitz_Restricted\HRS_Wide_Format_GD_Clocks_FINAL.dta";

/*DEMOGRAPHIC DATA*/

	rename racohbyr cohortby; 
	rename rabyear birthyr;
	rename rabmonth birthmonth;
	rename ragender sex;
	rename raracem race;
	rename rahispan hispanic; 
	rename raedyrs yrseduc;
	rename raedegrm degree;
	rename rabplace birthplace;
	rename raestrat stratum;
	rename raehsamp secu;
	rename rawtsamp sampweight92;

	/*respondent weight*/
		rename r1wtresp rwght1;
		rename r2wtresp rwght2;
		rename r3wtresp rwght3;
		rename r4wtresp rwght4;
		rename r5wtresp rwght5;
		rename r6wtresp rwght6;
		rename r7wtresp rwght7;
		rename r8wtresp rwght8;
		rename r9wtresp rwght9;
		rename r10wtresp rwght10;
		rename r11wtresp rwght11;
		rename r12wtresp rwght12;
		rename r13wtresp rwght13;

	/*wave status (alive, dead, etc.)*/
		rename r1iwstat wstat1;
		rename r2iwstat wstat2;
		rename r3iwstat wstat3;
		rename r4iwstat wstat4;
		rename r5iwstat wstat5;
		rename r6iwstat wstat6;
		rename r7iwstat wstat7;
		rename r8iwstat wstat8;
		rename r9iwstat wstat9;
		rename r10iwstat wstat10;
		rename r11iwstat wstat11;
		rename r12iwstat wstat12;
		rename r13iwstat wstat13;
		rename r14iwstat wstat14;

	/*age at interview in years*/
		rename r1agey_b ageyrs1;
		rename r2agey_b ageyrs2;
		rename r3agey_b ageyrs3;
		rename r4agey_b ageyrs4;
		rename r5agey_b ageyrs5;
		rename r6agey_b ageyrs6;
		rename r7agey_b ageyrs7;
		rename r8agey_b ageyrs8;
		rename r9agey_b ageyrs9;
		rename r10agey_b ageyrs10;
		rename r11agey_b ageyrs11;
		rename r12agey_b ageyrs12;
		rename r13agey_b ageyrs13;
		rename r14agey_b ageyrs14;

	/*census region currently living in*/
		rename r1cenreg cenreg1;
		rename r2cenreg cenreg2;
		rename r3cenreg cenreg3;
		rename r4cenreg cenreg4;
		rename r5cenreg cenreg5;
		rename r6cenreg cenreg6;
		rename r7cenreg cenreg7;
		rename r8cenreg cenreg8;
		rename r9cenreg cenreg9;
		rename r10cenreg cenreg10;
		rename r11cenreg cenreg11;
		rename r12cenreg cenreg12;
		rename r13cenreg cenreg13;
		rename r14cenreg cenreg14;

	/*census division currently living in*/
		rename r1cendiv cendiv1;
		rename r2cendiv cendiv2;
		rename r3cendiv cendiv3;
		rename r4cendiv cendiv4;
		rename r5cendiv cendiv5;
		rename r6cendiv cendiv6;
		rename r7cendiv cendiv7;
		rename r8cendiv cendiv8;
		rename r9cendiv cendiv9;
		rename r10cendiv cendiv10;
		rename r11cendiv cendiv11;
		rename r12cendiv cendiv12;
		rename r13cendiv cendiv13;
		rename r14cendiv cendiv14;

	/*marital status*/
		rename r1mstat marry1;
		rename r2mstat marry2;
		rename r3mstat marry3;
		rename r4mstat marry4;
		rename r5mstat marry5;
		rename r6mstat marry6;
		rename r7mstat marry7;
		rename r8mstat marry8;
		rename r9mstat marry9;
		rename r10mstat marry10;
		rename r11mstat marry11;
		rename r12mstat marry12;
		rename r13mstat marry13;
		rename r14mstat marry14;

/*FRAILTY INDEX VARIABLES*/

	/*Self-reported weight*/
		rename r1weight weight1;
		rename r2weight weight2; 
		rename r3weight weight3; 
		rename r4weight weight4; 
		rename r5weight weight5; 
		rename r6weight weight6; 
		rename r7weight weight7; 
		rename r8weight weight8; 
		rename r9weight weight9; 
		rename r10weight weight10; 
		rename r11weight weight11; 
		rename r12weight weight12; 
		rename r13weight weight13; 
		rename r14weight weight14; 

	/*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/
		rename e1888 weakness3;
		rename f2418 weakness4;
		rename g2716 weakness5;
		rename hg011 weakness6;
		rename jg011 weakness7;
		rename kg011 weakness8;
		rename lg011 weakness9;
		rename mg011 weakness10;
		rename ng011 weakness11;
		rename og011 weakness12;
		rename pg011 weakness13;
		rename qg011 weakness14;

	/*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/
		rename e1870 slowness3;
		rename f2400 slowness4;
		rename g2698 slowness5;
		rename hg005 slowness6;
		rename jg005 slowness7;
		rename kg005 slowness8;
		rename lg005 slowness9;
		rename mg005 slowness10; 
		rename ng005 slowness11;
		rename og005 slowness12;
		rename pg005 slowness13;
		rename qg005 slowness14;
		
	/*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/
		rename e972 fatigue3;
		rename f1309 fatigue4;
		rename g1442 fatigue5;
		rename hc148 fatigue6;
		rename jc148 fatigue7;
		rename kc148 fatigue8;
		rename lc148 fatigue9;
		rename mc148 fatigue10;
		rename nc148 fatigue11;
		rename oc148 fatigue12;
		rename pc148 fatigue13;
		rename qc148 fatigue14;

	/*Have you fallen down in the last two years?*/
		rename e878 falls3;
		rename f1206 falls4;
		rename g1339 falls5;
		rename hc079 falls6;
		rename jc079 falls7;
		rename kc079 falls8;
		rename lc079 falls9;
		rename mc079 falls10;
		rename nc079 falls11;
		rename oc079 falls12;
		rename pc079 falls13;
		rename qc079 falls14;

/*OTHER HEALTH VARIABLES*/

	/*self-reported health status*/
		rename r1shlt selfhealth1;
		rename r2shlt selfhealth2;
		rename r3shlt selfhealth3;
		rename r4shlt selfhealth4;
		rename r5shlt selfhealth5;
		rename r6shlt selfhealth6;
		rename r7shlt selfhealth7;
		rename r8shlt selfhealth8;
		rename r9shlt selfhealth9;
		rename r10shlt selfhealth10;
		rename r11shlt selfhealth11;
		rename r12shlt selfhealth12;
		rename r13shlt selfhealth13;
		rename r14shlt selfhealth14;

	/*BMI*/
		rename r1bmi bmi1;
		rename r2bmi bmi2;
		rename r3bmi bmi3;
		rename r4bmi bmi4;
		rename r5bmi bmi5;
		rename r6bmi bmi6;
		rename r7bmi bmi7;
		rename r8bmi bmi8;
		rename r9bmi bmi9;
		rename r10bmi bmi10;
		rename r11bmi bmi11;
		rename r12bmi bmi12;
		rename r13bmi bmi13;
		rename r14bmi bmi14;

	/*high blood pressure or hypertension*/
		rename r1hibp hibp1;
		rename r2hibp hibp2;
		rename r3hibp hibp3;
		rename r4hibp hibp4;
		rename r5hibp hibp5;
		rename r6hibp hibp6;
		rename r7hibp hibp7;
		rename r8hibp hibp8;
		rename r9hibp hibp9;
		rename r10hibp hibp10;
		rename r11hibp hibp11;
		rename r12hibp hibp12;
		rename r13hibp hibp13;
		rename r14hibp hibp14;

	/*diabetes or high blood sugar*/
		rename r1diab diab1;
		rename r2diab diab2;
		rename r3diab diab3;
		rename r4diab diab4;
		rename r5diab diab5;
		rename r6diab diab6;
		rename r7diab diab7;
		rename r8diab diab8;
		rename r9diab diab9;
		rename r10diab diab10;
		rename r11diab diab11;
		rename r12diab diab12;
		rename r13diab diab13;
		rename r14diab diab14;

	/*cancer or malignant tumor except skin cancer*/
		rename r1cancr cancer1;
		rename r2cancr cancer2;
		rename r3cancr cancer3;
		rename r4cancr cancer4;
		rename r5cancr cancer5;
		rename r6cancr cancer6;
		rename r7cancr cancer7;
		rename r8cancr cancer8;
		rename r9cancr cancer9;
		rename r10cancr cancer10;
		rename r11cancr cancer11;
		rename r12cancr cancer12;
		rename r13cancr cancer13;
		rename r14cancr cancer14;

	/*lung disease except chronic asthma*/
		rename r1lung lung1;
		rename r2lung lung2;
		rename r3lung lung3;
		rename r4lung lung4;
		rename r5lung lung5;
		rename r6lung lung6;
		rename r7lung lung7;
		rename r8lung lung8;
		rename r9lung lung9;
		rename r10lung lung10;
		rename r11lung lung11;
		rename r12lung lung12;
		rename r13lung lung13;
		rename r14lung lung14;

	/*heart problems*/
		rename r1heart heart1;
		rename r2heart heart2;
		rename r3heart heart3;
		rename r4heart heart4;
		rename r5heart heart5;
		rename r6heart heart6;
		rename r7heart heart7;
		rename r8heart heart8;
		rename r9heart heart9;
		rename r10heart heart10;
		rename r11heart heart11;
		rename r12heart heart12;
		rename r13heart heart13;
		rename r14heart heart14;

	/*stroke or transient ischemic attack, TIA*/
		rename r1strok stroke1;
		rename r2strok stroke2;
		rename r3strok stroke3;
		rename r4strok stroke4;
		rename r5strok stroke5;
		rename r6strok stroke6;
		rename r7strok stroke7;
		rename r8strok stroke8;
		rename r9strok stroke9;
		rename r10strok stroke10;
		rename r11strok stroke11;
		rename r12strok stroke12;
		rename r13strok stroke13;
		rename r14strok stroke14;

	/*psyche problems*/
		rename r1psych psych1;
		rename r2psych psych2;
		rename r3psych psych3;
		rename r4psych psych4;
		rename r5psych psych5;
		rename r6psych psych6;
		rename r7psych psych7;
		rename r8psych psych8;
		rename r9psych psych9;
		rename r10psych psych10;
		rename r11psych psych11;
		rename r12psych psych12;
		rename r13psych psych13;
		rename r14psych psych14;

	/*arthritis or rheumatism*/
		rename r1arthr arthr1;
		rename r2arthr arthr2;
		rename r3arthr arthr3;
		rename r4arthr arthr4;
		rename r5arthr arthr5;
		rename r6arthr arthr6;
		rename r7arthr arthr7;
		rename r8arthr arthr8;
		rename r9arthr arthr9;
		rename r10arthr arthr10;
		rename r11arthr arthr11;
		rename r12arthr arthr12;
		rename r13arthr arthr13;
		rename r14arthr arthr14;

	/*ADL summary*/
		rename r1adlw adl1;
		rename r2adla adl2;
		rename r3adla adl3;
		rename r4adla adl4;
		rename r5adla adl5;
		rename r6adla adl6;
		rename r7adla adl7;
		rename r8adla adl8;
		rename r9adla adl9;
		rename r10adla adl10;
		rename r11adla adl11;
		rename r12adla adl12;
		rename r13adla adl13;
		rename r14adla adl14;

	/*IADL summary*/
		rename r3iadlza iadl3;
		rename r4iadlza iadl4;
		rename r5iadlza iadl5;
		rename r6iadlza iadl6;
		rename r7iadlza iadl7;
		rename r8iadlza iadl8;
		rename r9iadlza iadl9;
		rename r10iadlza iadl10;
		rename r11iadlza iadl11;
		rename r12iadlza iadl12;
		rename r13iadlza iadl13;
		rename r14iadlza iadl14;

/*PARENTAL EDUCATION*/

	/*years of education: father*/
		rename rafeduc feduc;

	/*years of education: mother*/
		rename rameduc meduc;

/*GEOGRAPHIC VARIABLES*/

	/*born in the US?*/;
		rename bornus born_us; 

	/*State born in*/;
		rename staborn st_born;

	/*State R lived in most of the time when they were (in grade school/high school/about age 10)?*/
		rename whrliv10 st_age_ten;

	/*Current USPS state of residence*/
		rename stateusps92 st_live1;
		rename stateusps94 st_live2;
		rename stateusps96 st_live3;
		rename stateusps98 st_live4;
		rename stateusps00 st_live5;
		rename stateusps02 st_live6;
		rename stateusps04 st_live7;
		rename stateusps06 st_live8;
		rename stateusps08 st_live9;
		rename stateusps10 st_live10;
		rename stateusps12 st_live11;
		rename stateusps14 st_live12;
		rename stateusps16 st_live13;
		rename stateusps18 st_live14;

	/*State FIPS for current state of residence*/
		rename stfips92 st_live_fips1;
		rename stfips94 st_live_fips2;
		rename stfips96 st_live_fips3;
		rename stfips98 st_live_fips4;
		rename stfips00 st_live_fips5;
		rename stfips02 st_live_fips6;
		rename stfips04 st_live_fips7;
		rename stfips06 st_live_fips8;
		rename stfips08 st_live_fips9;
		rename stfips10 st_live_fips10;
		rename stfips12 st_live_fips11;
		rename stfips14 st_live_fips12;
		rename stfips16 st_live_fips13;
		rename stfips18 st_live_fips14;

		
/*CAUSE OF DEATH FROM EXIT INTERVIEW FILES*/

	/*What was the major illness that led to (his/her) death? Can list two causes*/
		rename sa133m1m causedeath_a6;
		rename ta133m1m causedeath_a7;
		rename ua133m1m causedeath_a8;
		rename va133m1m causedeath_a9;
		rename wa133m1m causedeath_a10;
		rename xa133m1m causedeath_a11;
		rename ya133m1m causedeath_a12;
		rename za133m1m causedeath_a13;
		rename xqa133m1m causedeath_a14;

		rename sa133m2m causedeath_b6;
		rename ta133m2m causedeath_b7;
		rename ua133m2m causedeath_b8;
		rename va133m2m causedeath_b9;
		rename wa133m2m causedeath_b10;
		rename xa133m2m causedeath_b11;
		rename ya133m2m causedeath_b12;
		rename za133m2m causedeath_b13;
		rename xqa133m2m causedeath_b14;

		
/*RESHAPE THE DATA FROM WIDE TO PANEL FORMAT*/
	
	reshape long rwght inw wstat ageyrs marry cenreg cendiv selfhealth 
		bmi hibp diab cancer lung heart stroke psych arthr adl iadl   
		weight weakness slowness fatigue falls 
		causedeath_a causedeath_b 
		st_live st_live_fips, i(hhid pn hhidpn) j(year);

	sort hhid pn year;

	gen year2=.;
		replace year2=1992 if year==1;
		replace year2=1994 if year==2;
		replace year2=1996 if year==3;
		replace year2=1998 if year==4;
		replace year2=2000 if year==5;
		replace year2=2002 if year==6;
		replace year2=2004 if year==7;
		replace year2=2006 if year==8;
		replace year2=2008 if year==9;
		replace year2=2010 if year==10;
		replace year2=2012 if year==11;
		replace year2=2014 if year==12;
		replace year2=2016 if year==13;
		replace year2=2018 if year==14;

			drop year;
				rename year2 year;

	order hhid pn hhidpn year;

	sort hhidpn year;

	save "U:\Schmitz_Restricted\HRS_Long_Format_GD_Clocks_FINAL.dta", replace;


