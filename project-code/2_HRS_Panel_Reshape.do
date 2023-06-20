*********************************************************************************************************************************************************************************
***STEP 2: RESHAPE HRS DATA FROM WIDE FORMAT TO PANEL FORMAT***
	*Project: Early-life Exposures to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
*********************************************************************************************************************************************************************************

clear
#delimit ;
set more off;

use "U:\Schmitz_Restricted\HRSJobPanelDatawide_WC_FINAL_JHR.dta";

********************************************************************************
/*DEMOGRAPHIC AND SURVEY VARIABLES*/;

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
	rename ravetrn veteran;

/*respondent weight*/;

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

/*wave status (alive, dead, etc.)*/;

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

/*age at interview in years*/;

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

/*census region currently living in*/;

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

/*census division currently living in*/;

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

/*Number of children--household level*/;

	rename h1child children1;
	rename h2child children2;
	rename h3child children3;
	rename h4child children4;
	rename h5child children5;
	rename h6child children6;
	rename h7child children7;
	rename h8child children8;
	rename h9child children9;
	rename h10child children10;
	rename h11child children11;
	rename h12child children12;
	rename h13child children13;
	rename h14child children14;

/*marital status*/;

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

********************************************************************************
/*FRAILTY INDEX VARIABLES*/;

/*Because of health problems, do you have any difficulty lifting or carrying weights over 10lbs, like a heavy bag of groceries?*/;

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

/*Because of health problems, do you have any difficulty with getting up from a chair after sitting for long periods?*/;

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
	
/*Since we last talked with you in [the last wave], have you had any of the following persistent or troublesome problems: fatigue or exhaustion?*/;

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

/*Have you fallen down in the last two years?*/;

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

********************************************************************************
/*HEALTH VARIABLES*/;

/*Height in meters*/;

	rename r1height height1;
	rename r2height height2;
	rename r3height height3;
	rename r4height height4;
	rename r5height height5;
	rename r6height height6;
	rename r7height height7;
	rename r8height height8;
	rename r9height height9;
	rename r10height height10;
	rename r11height height11;
	rename r12height height12;
	rename r13height height13;
	rename r14height height14;

/*Self-reported weight*/;

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

/*self-reported health status*/;

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

/*BMI*/;

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

/*high blood pressure or hypertension*/;

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

/*diabetes or high blood sugar*/;

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

/*cancer or malignant tumor except skin cancer*/;

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

/*lung disease except chronic asthma*/;

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

/*heart problems*/;

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

/*stroke or transient ischemic attack, TIA*/;

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

/*psyche problems*/;

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

/*arthritis or rheumatism*/;

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


********************************************************************************
/*LABOR MARKET VARIABLES*/

/*currently working for pay*/;

	rename r1work work1;
	rename r2work work2;
	rename r3work work3;
	rename r4work work4;
	rename r5work work5;
	rename r6work work6;
	rename r7work work7;
	rename r8work work8;
	rename r9work work9;
	rename r10work work10;
	rename r11work work11;
	rename r12work work12;
	rename r13work work13;
	rename r14work work14;

/*currently self-employed*/;

	rename r1slfemp selfemp1;
	rename r2slfemp selfemp2;
	rename r3slfemp selfemp3;
	rename r4slfemp selfemp4;
	rename r5slfemp selfemp5;
	rename r6slfemp selfemp6;
	rename r7slfemp selfemp7;
	rename r8slfemp selfemp8;
	rename r9slfemp selfemp9;
	rename r10slfemp selfemp10;
	rename r11slfemp selfemp11;
	rename r12slfemp selfemp12;
	rename r13slfemp selfemp13;
	rename r14slfemp selfemp14;

/*labor force status*/;

	rename r1lbrf lbrforce1;
	rename r2lbrf lbrforce2;
	rename r3lbrf lbrforce3;
	rename r4lbrf lbrforce4;
	rename r5lbrf lbrforce5;
	rename r6lbrf lbrforce6;
	rename r7lbrf lbrforce7;
	rename r8lbrf lbrforce8;
	rename r9lbrf lbrforce9;
	rename r10lbrf lbrforce10;
	rename r11lbrf lbrforce11;
	rename r12lbrf lbrforce12;
	rename r13lbrf lbrforce13;
	rename r14lbrf lbrforce14;

/*whether completely or partially retired*/;

	rename r1sayret sayret1;          
	rename r2sayret sayret2;
	rename r3sayret sayret3;
	rename r4sayret sayret4;
	rename r5sayret sayret5;
	rename r6sayret sayret6;
	rename r7sayret sayret7;
	rename r8sayret sayret8;
	rename r9sayret sayret9;
	rename r10sayret sayret10;
	rename r11sayret sayret11;
	rename r12sayret sayret12;
	rename r13sayret sayret13;
	rename r14sayret sayret14;

/*1980 current job industry code RAND*/;

	rename r1jcind randind1;
	rename r2jcind randind2;
	rename r3jcind randind3;
	rename r4jcind randind4;
	rename r5jcind randind5;
	rename r6jcind randind6;
	rename r7jcind randind7;
	rename r8jcind randind8;
	rename r9jcind randind9;
	rename r10jcind randind10;
	rename r11jcind randind11;
	rename r12jcind randind12;
	rename r13jcind randind13;
	rename r14jcind randind14;

/*2000 current job industry code RAND*/;

	rename r8jcindb randindb8;
	rename r9jcindb randindb9;
	rename r10jcindb randindb10;
	rename r11jcindb randindb11;
	rename r12jcindb randindb12;
	rename r13jcindb randindb13;
	rename r14jcindb randindb14;

/*1980 current job occupation code RAND*/;

	rename r1jcocc randocc1;
	rename r2jcocc randocc2;
	rename r3jcocc randocc3;
	rename r4jcocc randocc4;
	rename r5jcocc randocc5;
	rename r6jcocc randocc6;
	rename r7jcocc randocc7;
	rename r8jcocc randocc8;
	rename r9jcocc randocc9;
	rename r10jcocc randocc10;
	rename r11jcocc randocc11;
	rename r12jcocc randocc12;
	rename r13jcocc randocc13;
	rename r14jcocc randocc14;

/*2000 census occupation code at current job RAND*/;

	rename r8jcoccb randoccb8;
	rename r9jcoccb randoccb9;
	rename r10jcoccb randoccb10;
	rename r11jcoccb randoccb11;
	rename r12jcoccb randoccb12;
	rename r13jcoccb randoccb13;
	rename r14jcoccb randoccb14;

/*individual earnings*/;

	rename r1iearn iearn1;
	rename r2iearn iearn2;
	rename r3iearn iearn3;
	rename r4iearn iearn4;
	rename r5iearn iearn5;
	rename r6iearn iearn6;
	rename r7iearn iearn7;
	rename r8iearn iearn8;
	rename r9iearn iearn9;
	rename r10iearn iearn10;
	rename r11iearn iearn11;
	rename r12iearn iearn12;
	rename r13iearn iearn13;
	rename r14iearn iearn14;

/*total household income*/;

	rename h1itot hinctot1;
	rename h2itot hinctot2;
	rename h3itot hinctot3;
	rename h4itot hinctot4;
	rename h5itot hinctot5;
	rename h6itot hinctot6;
	rename h7itot hinctot7;
	rename h8itot hinctot8;
	rename h9itot hinctot9;
	rename h10itot hinctot10;
	rename h11itot hinctot11;
	rename h12itot hinctot12;
	rename h13itot hinctot13;
	rename h14itot hinctot14;

/*3-digit occupation codes: Current Occupation at new/current job (1980 Census)*/;

	rename v2720 rcurrocc1;
	rename w3609 rcurrocc2;
	rename e2732 rcurrocc3;
	rename f3255 rcurrocc4;
	rename g3505 rcurrocc5;
	rename hj168 rcurrocc6;
	rename jj168 rcurrocc7;
	
/*3-digit occupation codes: Current Occupation at new/current job (2000 Census)*/;

	rename kj168 rcurroccb8;
	rename lj168 rcurroccb9;
	rename mj168_2000 rcurroccb10;
	
/*3-digit occupation codes: Current Occupation at new/current job (2010 Census)*/;

	rename nj168 rcurroccc11;
	rename oj168 rcurroccc12;
	rename pj168 rcurroccc13;

/*3-digit industry codes (1980 Census)*/;

	rename v2719 rcurrind1;
	rename w3608 rcurrind2;
	rename e2730 rcurrind3;
	rename f3253 rcurrind4;
	rename g3503 rcurrind5;
	rename hj166 rcurrind6;
	rename jj166 rcurrind7;
	
/*3-digit industry codes (2000 Census)*/;

	rename kj166 rcurrindb8;
	rename lj166 rcurrindb9;
	rename mj166_2000 rcurrindb10;
	
/*3-digit industry codes (2007 Census)*/;

	rename nj166 rcurrindc11;
	rename oj166 rcurrindc12;
	rename pj166 rcurrindc13;

/*3-Digit LONGEST HELD JOB (1980 Census Occ Codes)*/;

	rename v3606 longocc1;
	rename w7107 longocc2;
	rename f3841 longocc4;
	rename g4103 longocc5;
	rename hl015 longocc6;
	rename jl015 longocc7;
	
/*3-digit LONGEST HELD JOB (2000 Census Occ Codes)*/;

	rename kl015 longoccb8;
	rename ll015 longoccb9;
	rename ml015_2000 longoccb10;
	
/*3-digit LONGEST HELD JOB (2010 Census Occ Codes)*/;

	rename nl015 longoccc11;
	rename ol015 longoccc12;
	rename pl015 longoccc13;

/*3-digit INDUSTRY AT LONGEST HELD JOB (1980 Census Ind Codes)*/;

	rename v3605 longind1;
	rename w7106 longind2;
	rename f3839 longind4;
	rename g4101 longind5;
	rename hl013 longind6;
	rename jl013 longind7;
	
/*3-digit INDUSTRY AT LONGEST HELD JOB (2000 Census Ind Codes)*/;

	rename kl013 longindb8;
	rename ll013 longindb9;
	rename ml013_2000 longindb10;
	
/*3-digit INDUSTRY AT LONGEST HELD JOB (2007 Census Ind Codes)*/;

	rename nl013 longindc11;
	rename ol013 longindc12;
	rename pl013 longindc13;

/*3-digit FATHERS USUAL OCCUPATION (1980 Census Occ Codes)*/;

	rename f997 fatherocc4;
	rename g1084 fatherocc5;
	rename hb024 fatherocc6;
	rename jb024 fatherocc7;

/*LAST JOB INDUSTRY (1980 Census Ind Codes)*/;

	rename v3406 lastind1;
	rename w7006 lastind2;
	rename e3132 lastind3;
	rename f3650 lastind4;
	rename g3960 lastind5;
	rename hk008 lastind6;
	rename jk008 lastind7;
	
/*LAST JOB INDUSTRY (2002 Census Ind Codes)*/;

	rename kk008 lastindb8;
	rename lk008 lastindb9;
	rename mk008_2000 lastindb10;
	
/*LAST JOB INDUSTRY (2007 Census Ind Codes)*/;

	rename nk008 lastindc11;
	rename ok008 lastindc12;

/*LAST JOB INDUSTRY IF SELF-EMPLOYED (1980 Census Occ Codes)*/;

	rename v3431 lastind_se1;

/*After 1992 asked simultaneously with other last job question*/;

/*LAST JOB OCCUPATION IF SELF-EMPLOYED (1980 Census Occ Codes)*/;

	rename v3432 lastocc_se1;

/*After 1992 asked simultaneously with other last job question*/;

/*LAST JOB OCCUPATION (1980 Census Occ Codes)*/;

	rename v3407 lastocc1;
	rename w7007 lastocc2;
	rename e3134 lastocc3;
	rename f3652 lastocc4;
	rename g3962 lastocc5;
	rename hk010 lastocc6;
	rename jk010 lastocc7;

/*LAST JOB OCCUPATION (2000 Census Occ Codes)*/;

	rename kk010 lastoccb8;
	rename lk010 lastoccb9;
	rename mk010_2000 lastoccb10;

/*LAST JOB OCCUPATION (2010 Census Occ Codes)*/;

	rename nk010 lastoccc11;
	rename ok010 lastoccc12;

/*3-digit FATHER'S USUAL OCCUPATION (2000 Census Occ Codes)*/;

	rename kb024 fatheroccb8;
	rename lb024 fatheroccb9;
	rename mb024_2000 fatheroccb10;

/*2-digit FATHERS USUAL OCCUPATION (1980 Census Codes)*/;

	rename e5654m focc3;
	rename f997hm focc4;
	rename g1084m focc5;
	rename hb024m focc6;
	rename jb024m focc7;
	
/*2-digit FATHER'S USUAL OCCUPATION (2000 Census Occ Codes)*/;

	rename kb024m focc8;
	rename lb024m focc9;
	rename mb024m focc10;
	
/*3-digit FATHER'S USUAL OCCUPATION (2010 Census Occ Codes)*/;

	rename nb024 fatheroccc11;
	rename ob024 fatheroccc12;

/*2 digit 1980 occ codes for job with longest tenure*/;

	rename r1jlocc rlongocc1;
	rename r2jlocc rlongocc2;
	rename r3jlocc rlongocc3;
	rename r4jlocc rlongocc4;
	rename r5jlocc rlongocc5;
	rename r6jlocc rlongocc6;
	rename r7jlocc rlongocc7;
	rename r8jlocc rlongocc8;
	rename r9jlocc rlongocc9;
	rename r10jlocc rlongocc10;
	rename r11jlocc rlongocc11;
	rename r12jlocc rlongocc12;
	rename r13jlocc rlongocc13;
	rename r14jlocc rlongocc14;

/*2 digit 1980 ind codes for job with longest tenure*/;

	rename r1jlind rlongind1;
	rename r2jlind rlongind2;
	rename r3jlind rlongind3;
	rename r4jlind rlongind4;
	rename r5jlind rlongind5;
	rename r6jlind rlongind6;
	rename r7jlind rlongind7;
	rename r8jlind rlongind8;
	rename r9jlind rlongind9;
	rename r10jlind rlongind10;
	rename r11jlind rlongind11;
	rename r12jlind rlongind12;
	rename r13jlind rlongind13;
	rename r14jlind rlongind14;

	
********************************************************************************
/*WEALTH VARIABLES*/;

/*total household wealth less IRA*/;

	rename h1atotw hwealthtot1; 
	rename h2atotw hwealthtot2;
	rename h3atotw hwealthtot3;
	rename h4atotw hwealthtot4;
	rename h5atotw hwealthtot5;
	rename h6atotw hwealthtot6;
	rename h7atotw hwealthtot7;
	rename h8atotw hwealthtot8;
	rename h9atotw hwealthtot9;
	rename h10atotw hwealthtot10;
	rename h11atotw hwealthtot11;
	rename h12atotw hwealthtot12;
	rename h13atotw hwealthtot13;
	rename h14atotw hwealthtot14;

/*total household wealth less secondary residence*/;

	rename h1atota hwealthres1;         
	rename h2atota hwealthres2;
	rename h3atota hwealthres3;
	rename h4atota hwealthres4;
	rename h5atota hwealthres5;
	rename h6atota hwealthres6;
	rename h7atota hwealthres7;
	rename h8atota hwealthres8;
	rename h9atota hwealthres9;
	rename h10atota hwealthres10;
	rename h11atota hwealthres11;
	rename h12atota hwealthres12;
	rename h13atota hwealthres13;
	rename h14atota hwealthres14;

/*total household wealth including secondary residence--NOTE: in W3 question about second home not asked*/;

	rename h1atotb hatotb1;
	rename h2atotb hatotb2;
	rename h4atotb hatotb4;
	rename h5atotb hatotb5;
	rename h6atotb hatotb6;
	rename h7atotb hatotb7;
	rename h8atotb hatotb8;
	rename h9atotb hatotb9;
	rename h10atotb hatotb10;
	rename h11atotb hatotb11;
	rename h12atotb hatotb12;
	rename h13atotb hatotb13;
	rename h14atotb hatotb14;

	
********************************************************************************
/*CHILDHOOD VARIABLES*/;

/*self-reported childhood health status*/;

	rename e5648 childhealth3;
	rename f992 childhealth4;
	rename g1079 childhealth5;
	rename hb019 childhealth6;
	rename jb019 childhealth7;
	rename kb019 childhealth8;
	rename lb019 childhealth9;
	rename mb019 childhealth10;

/*region lived in most of the time while in school*/;

	rename e715m regsch3;
	rename f1035m regsch4;
	rename g1122m regsch5;
	rename hb047m regsch6;
	rename jb047m regsch7;
	rename kb047m regsch8;
	rename lb047m regsch9;
	rename mb047m regsch10;

/*years of education: father*/;

	rename rafeduc feduc;

/*years of education: mother*/;

	rename rameduc meduc;

/*born in the US?*/;

	rename bornus born_us; 

/*State born in*/;

	rename staborn st_born;

/*State R lived in most of the time when they were (in grade school/high school/about age 10)?*/;

	rename whrliv10 st_age_ten;

/*Grew up in an urban or rural environment*/;

	rename e718 urb_rural3;
	rename f1038 urb_rural4;
	rename g1125 urb_rural5;
	rename hb049 urb_rural6;
	rename jb049 urb_rural7;
	rename kb049 urb_rural8;
	rename lb049 urb_rural9;
	rename mb049 urb_rural10;
	rename nb049 urb_rural11;
	rename ob049 urb_rural12;
	rename pb049 urb_rural13;
	rename qb049 urb_rural14;

/*father unemployed in childhood*/;

	rename f996 funemp4; 
	rename g1083 funemp5;
	rename hb023 funemp6;
	rename jb023 funemp7;
	rename kb023 funemp8;
	rename lb023 funemp9;
	rename mb023 funemp10;
	
********************************************************************************
/*STATE OF RESIDENCE*/;

/*Current USPS state of residence*/;

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

/*State FIPS for current state of residence*/;

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

	
********************************************************************************
/*EXIT INTERVIEW FILES*/;

/*What was the major illness that led to (his/her) death? Can list two causes*/;

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

	
********************************************************************************
/*SSA DATA WEIGHTS*/;

/*SSA weights: current linkage*/;

	rename r1wtsswr sswghtc1;
	rename r4wtsswr sswghtc4;
	rename sswgtsj_cur sswghtc7;
	rename sswgtsk_cur sswghtc8;
	rename sswgtsl_cur sswghtc9;
	rename sswgtsm_cur sswghtc10;
	rename sswgtsn_cur sswghtc11;

/*SSA weights: ever linked--only available after 2004*/;

	rename sswgtsj_ev sswghte7;
	rename sswgtsk_ev sswghte8;
	rename sswgtsl_ev sswghte9;
	rename sswgtsm_ev sswghte10;
	rename sswgtsn_ev sswghte11;
	
********************************************************************************

/*RESHAPE DATA FROM WIDE TO LONG FORMAT*/;

	reshape long rwght inw wstat ageyrs marry children 
		rcurrocc rcurroccb rcurroccc rcurrind rcurrindb rcurrindc longocc longoccb longoccc longind longindb longindc lastocc lastoccb lastoccc lastocc_se lastind lastindb lastindc fatherocc fatheroccb fatheroccc rlongocc rlongind 
		cenreg cendiv  
		selfhealth height bmi hibp diab cancer lung heart stroke psych arthr  
		work selfemp lbrforce sayret randind randindb randocc randoccb  
		weight weakness slowness fatigue falls
		iearn hinctot hwealthtot hwealthres hatotb 
		childhealth regsch urb_rural focc funemp
		causedeath_a causedeath_b  
		sswghtc sswghte 
		st_live st_live_fips, i(hhid pn hhidpn) j(year);

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

save "U:\Schmitz_Restricted\HRSJobPanel_WC_FINAL_JHR.dta", replace;


