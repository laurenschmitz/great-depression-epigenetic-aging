*********************************************************************************************************************************************************************************
***STEP 4: CLEAN RESTRICTED OCCUPATION DATA***
	*Project: Early-life Exposures to the Great Depression and Long-term Health and Economic Outcomes, Journal of Human Resources
	*Authors: Valentina Duque and Lauren L. Schmitz
	*Analyst: Lauren L. Schmitz
	*Date updated: June 2023
*********************************************************************************************************************************************************************************

clear
#delimit ;
set more off;

use "U:\Schmitz_Restricted\HRSJobPanel_WC_Historical_FINAL_JHR.dta";

*Generate baseline indicator 
sort hhidpn year;	
	by hhidpn: egen inw_count=seq() if inw==1, from(1) to(14); /*generate sequence variable that counts each year R was interviewed*/
		generate baseline=0  if inw_count!=.;
		replace baseline=1 if inw_count==1;

/*Recode Missings*/
recode rcurrocc rcurroccb rcurroccc (999=.) (998=.) (997=.); /*999 (Occ not reported/DK); 998 (DK Occ); 997 (Other)*/
recode longocc longoccb longoccc (999=.) (998=.) (997=.); /*999 (Occ not reported/DK); 998 (DK Occ); 997 (Other)*/
recode lastocc lastoccb lastoccc (999=.) (998=.) (997=.); /*999 (Occ not reported/DK); 998 (DK Occ); 997 (Other)*/
recode lastocc_se (999=.) (998=.) (997=.); /*999 (Occ not reported/DK); 998 (DK Occ); 997 (Other)*/

/*Carryforward 3-digit occupations--Current Job*/
by hhidpn: carryforward rcurrocc if work==1, replace;
by hhidpn: carryforward rcurroccb if work==1, replace; 
by hhidpn: carryforward rcurroccc if work==1, replace; 

rename rcurrocc occ;
rename rcurroccb occb;
rename rcurroccc occc;

/*Set longest held occupation equal to last job if longest held occupation is missing*/
replace longocc = lastocc if longocc==. & lastocc!=.;
replace longocc = lastocc_se if longocc==. & lastocc==. & lastocc_se!=.;

replace longoccb = lastoccb if longoccb==. & lastoccb!=.; /*after 1992 separate self-employmen occ question not asked*/
replace longoccc = lastoccc if longoccc==. & lastoccc!=.;

/*Set longest held occupation equal to occupation at baseline if all other info missing*/
replace longocc = occ if longocc==. & lastocc==. & lastocc_se==. & baseline==1;
replace longoccb = occb if longoccb==. & lastoccb==. & baseline==1;
replace longoccc = occc if longoccc==. & lastoccc==. & baseline==1;

/*Set longest held industry equal to last job if longest held industry is missing*/
replace longind = lastind if longind==. & lastind!=.;

replace longindb = lastindb if longindb==. & lastindb!=.; 
replace longindc = lastindc if longindc==. & lastindc!=.;

/*Set longest held occupation equal to occupation at baseline if all other info missing*/
replace longind = rcurrind if longind==. & lastind==. & baseline==1;
replace longindb = rcurrindb if longindb==. & lastindb==. & baseline==1;
replace longindc = rcurrindc if longindc==. & lastindc==. & baseline==1;


/*Carryforward longest held occupation*/
by hhidpn: carryforward longocc, replace;
by hhidpn: carryforward longoccb, replace;
by hhidpn: carryforward longoccc, replace;

by hhidpn: carryforward longind, replace;
by hhidpn: carryforward longindb, replace;
by hhidpn: carryforward longindc, replace;


by hhidpn: egen fatherocc2=mean(fatherocc);
by hhidpn: egen fatheroccb2=mean(fatheroccb);
by hhidpn: egen fatheroccc2=mean(fatheroccc);

drop fatherocc;
rename fatherocc2 fatherocc;

drop fatheroccb;
rename fatheroccb2 fatheroccb;

drop fatheroccc;
rename fatheroccc2 fatheroccc;

gen mo_occ=.; //Meyer-Osborne Occ code
gen mo_long=.; //Meyer-Osborne Occ code for LHJ
gen mo_father=.; //Meyer-Osborne Occ code for father's occupation

/*NOTE: WE ONLY HAVE MO CODES FOR 1980 and 2000 CENSUS DATA--CAN'T HARMONIZE 2010 CENSUS DATA (2012 and 2014--rcurroccc rcurrindc longoccc longindc)*/
/*Convert 1980 Census Codes to Osborne and Meyer Harmonized Codes*/

replace mo_occ=	3	if occ==	3	;
replace mo_occ=	4	if occ==	4	;
replace mo_occ=	7	if occ==	7	;
replace mo_occ=	8	if occ==	8	;
replace mo_occ=	13	if occ==	13	;
replace mo_occ=	13	if occ==	197	;
replace mo_occ=	14	if occ==	14	;
replace mo_occ=	15	if occ==	15	;
replace mo_occ=	16	if occ==	17	;
replace mo_occ=	18	if occ==	16	;
replace mo_occ=	19	if occ==	18	;
replace mo_occ=	22	if occ==	5	;
replace mo_occ=	22	if occ==	19	;
replace mo_occ=	23	if occ==	23	;
replace mo_occ=	24	if occ==	24	;
replace mo_occ=	25	if occ==	25	;
replace mo_occ=	26	if occ==	26	;
replace mo_occ=	27	if occ==	27	;
replace mo_occ=	28	if occ==	28	;
replace mo_occ=	29	if occ==	29	;
replace mo_occ=	33	if occ==	9	;
replace mo_occ=	33	if occ==	33	;
replace mo_occ=	34	if occ==	34	;
replace mo_occ=	35	if occ==	35	;
replace mo_occ=	36	if occ==	36	;
replace mo_occ=	37	if occ==	37	;
replace mo_occ=	43	if occ==	43	;
replace mo_occ=	44	if occ==	44	;
replace mo_occ=	45	if occ==	45	;
replace mo_occ=	47	if occ==	47	;
replace mo_occ=	48	if occ==	48	;
replace mo_occ=	53	if occ==	53	;
replace mo_occ=	55	if occ==	55	;
replace mo_occ=	56	if occ==	56	;
replace mo_occ=	57	if occ==	57	;
replace mo_occ=	59	if occ==	46	;
replace mo_occ=	59	if occ==	49	;
replace mo_occ=	59	if occ==	54	;
replace mo_occ=	59	if occ==	58	;
replace mo_occ=	59	if occ==	59	;
replace mo_occ=	64	if occ==	64	;
replace mo_occ=	65	if occ==	65	;
replace mo_occ=	66	if occ==	66	;
replace mo_occ=	67	if occ==	67	;
replace mo_occ=	68	if occ==	68	;
replace mo_occ=	69	if occ==	69	;
replace mo_occ=	73	if occ==	73	;
replace mo_occ=	74	if occ==	74	;
replace mo_occ=	75	if occ==	75	;
replace mo_occ=	76	if occ==	76	;
replace mo_occ=	77	if occ==	77	;
replace mo_occ=	78	if occ==	78	;
replace mo_occ=	79	if occ==	79	;
replace mo_occ=	83	if occ==	83	;
replace mo_occ=	84	if occ==	84	;
replace mo_occ=	85	if occ==	85	;
replace mo_occ=	86	if occ==	86	;
replace mo_occ=	87	if occ==	87	;
replace mo_occ=	88	if occ==	88	;
replace mo_occ=	89	if occ==	89	;
replace mo_occ=	95	if occ==	95	;
replace mo_occ=	96	if occ==	96	;
replace mo_occ=	97	if occ==	97	;
replace mo_occ=	98	if occ==	98	;
replace mo_occ=	99	if occ==	99	;
replace mo_occ=	103	if occ==	103	;
replace mo_occ=	104	if occ==	104	;
replace mo_occ=	105	if occ==	105	;
replace mo_occ=	106	if occ==	106	;
replace mo_occ=	113	if occ==	113	;
replace mo_occ=	114	if occ==	114	;
replace mo_occ=	115	if occ==	115	;
replace mo_occ=	116	if occ==	116	;
replace mo_occ=	118	if occ==	118	;
replace mo_occ=	119	if occ==	119	;
replace mo_occ=	123	if occ==	123	;
replace mo_occ=	125	if occ==	125	;
replace mo_occ=	127	if occ==	127	;
replace mo_occ=	128	if occ==	128	;
replace mo_occ=	139	if occ==	139	;
replace mo_occ=	145	if occ==	145	;
replace mo_occ=	147	if occ==	147	;
replace mo_occ=	149	if occ==	149	;
replace mo_occ=	154	if occ==	117	;
replace mo_occ=	154	if occ==	124	;
replace mo_occ=	154	if occ==	126	;
replace mo_occ=	154	if occ==	129	;
replace mo_occ=	154	if occ==	133	;
replace mo_occ=	154	if occ==	134	;
replace mo_occ=	154	if occ==	135	;
replace mo_occ=	154	if occ==	136	;
replace mo_occ=	154	if occ==	137	;
replace mo_occ=	154	if occ==	138	;
replace mo_occ=	154	if occ==	143	;
replace mo_occ=	154	if occ==	144	;
replace mo_occ=	154	if occ==	146	;
replace mo_occ=	154	if occ==	148	;
replace mo_occ=	154	if occ==	153	;
replace mo_occ=	154	if occ==	154	;
replace mo_occ=	155	if occ==	155	;
replace mo_occ=	156	if occ==	156	;
replace mo_occ=	157	if occ==	157	;
replace mo_occ=	158	if occ==	158	;
replace mo_occ=	159	if occ==	159	;
replace mo_occ=	163	if occ==	163	;
replace mo_occ=	164	if occ==	164	;
replace mo_occ=	165	if occ==	165	;
replace mo_occ=	166	if occ==	166	;
replace mo_occ=	167	if occ==	167	;
replace mo_occ=	168	if occ==	168	;
replace mo_occ=	169	if occ==	169	;
replace mo_occ=	173	if occ==	173	;
replace mo_occ=	174	if occ==	174	;
replace mo_occ=	175	if occ==	175	;
replace mo_occ=	176	if occ==	176	;
replace mo_occ=	176	if occ==	177	;
replace mo_occ=	178	if occ==	178	;
replace mo_occ=	179	if occ==	179	;
replace mo_occ=	183	if occ==	183	;
replace mo_occ=	184	if occ==	184	;
replace mo_occ=	185	if occ==	185	;
replace mo_occ=	186	if occ==	186	;
replace mo_occ=	187	if occ==	187	;
replace mo_occ=	188	if occ==	188	;
replace mo_occ=	189	if occ==	189	;
replace mo_occ=	193	if occ==	193	;
replace mo_occ=	194	if occ==	194	;
replace mo_occ=	195	if occ==	195	;
replace mo_occ=	198	if occ==	198	;
replace mo_occ=	199	if occ==	199	;
replace mo_occ=	203	if occ==	203	;
replace mo_occ=	204	if occ==	204	;
replace mo_occ=	205	if occ==	205	;
replace mo_occ=	206	if occ==	206	;
replace mo_occ=	207	if occ==	207	;
replace mo_occ=	208	if occ==	208	;
replace mo_occ=	213	if occ==	213	;
replace mo_occ=	214	if occ==	214	;
replace mo_occ=	214	if occ==	216	;
replace mo_occ=	215	if occ==	215	;
replace mo_occ=	217	if occ==	217	;
replace mo_occ=	218	if occ==	63	;
replace mo_occ=	218	if occ==	218	;
replace mo_occ=	218	if occ==	867	;
replace mo_occ=	223	if occ==	223	;
replace mo_occ=	224	if occ==	224	;
replace mo_occ=	225	if occ==	225	;
replace mo_occ=	226	if occ==	226	;
replace mo_occ=	227	if occ==	227	;
replace mo_occ=	228	if occ==	228	;
replace mo_occ=	229	if occ==	229	;
replace mo_occ=	233	if occ==	233	;
replace mo_occ=	234	if occ==	234	;
replace mo_occ=	235	if occ==	235	;
replace mo_occ=	243	if occ==	243	;
replace mo_occ=	253	if occ==	253	;
replace mo_occ=	254	if occ==	254	;
replace mo_occ=	255	if occ==	255	;
replace mo_occ=	256	if occ==	256	;
replace mo_occ=	258	if occ==	258	;
replace mo_occ=	274	if occ==	257	;
replace mo_occ=	274	if occ==	259	;
replace mo_occ=	274	if occ==	263	;
replace mo_occ=	274	if occ==	264	;
replace mo_occ=	274	if occ==	265	;
replace mo_occ=	274	if occ==	266	;
replace mo_occ=	274	if occ==	267	;
replace mo_occ=	274	if occ==	268	;
replace mo_occ=	274	if occ==	269	;
replace mo_occ=	274	if occ==	274	;
replace mo_occ=	274	if occ==	284	;
replace mo_occ=	274	if occ==	285	;
replace mo_occ=	275	if occ==	275	;
replace mo_occ=	276	if occ==	276	;
replace mo_occ=	277	if occ==	277	;
replace mo_occ=	277	if occ==	278	;
replace mo_occ=	283	if occ==	283	;
replace mo_occ=	303	if occ==	303	;
replace mo_occ=	303	if occ==	305	;
replace mo_occ=	308	if occ==	304	;
replace mo_occ=	308	if occ==	308	;
replace mo_occ=	308	if occ==	309	;
replace mo_occ=	313	if occ==	313	;
replace mo_occ=	314	if occ==	314	;
replace mo_occ=	315	if occ==	315	;
replace mo_occ=	316	if occ==	316	;
replace mo_occ=	317	if occ==	317	;
replace mo_occ=	318	if occ==	318	;
replace mo_occ=	319	if occ==	319	;
replace mo_occ=	323	if occ==	323	;
replace mo_occ=	323	if occ==	325	;
replace mo_occ=	326	if occ==	326	;
replace mo_occ=	326	if occ==	327	;
replace mo_occ=	328	if occ==	328	;
replace mo_occ=	329	if occ==	329	;
replace mo_occ=	335	if occ==	335	;
replace mo_occ=	336	if occ==	336	;
replace mo_occ=	337	if occ==	337	;
replace mo_occ=	338	if occ==	338	;
replace mo_occ=	343	if occ==	343	;
replace mo_occ=	344	if occ==	339	;
replace mo_occ=	344	if occ==	344	;
replace mo_occ=	345	if occ==	345	;
replace mo_occ=	346	if occ==	346	;
replace mo_occ=	347	if occ==	347	;
replace mo_occ=	348	if occ==	306	;
replace mo_occ=	348	if occ==	348	;
replace mo_occ=	349	if occ==	349	;
replace mo_occ=	349	if occ==	353	;
replace mo_occ=	354	if occ==	354	;
replace mo_occ=	355	if occ==	355	;
replace mo_occ=	356	if occ==	356	;
replace mo_occ=	357	if occ==	357	;
replace mo_occ=	359	if occ==	359	;
replace mo_occ=	364	if occ==	307	;
replace mo_occ=	364	if occ==	364	;
replace mo_occ=	365	if occ==	365	;
replace mo_occ=	366	if occ==	366	;
replace mo_occ=	368	if occ==	368	;
replace mo_occ=	373	if occ==	363	;
replace mo_occ=	373	if occ==	373	;
replace mo_occ=	375	if occ==	375	;
replace mo_occ=	376	if occ==	376	;
replace mo_occ=	377	if occ==	377	;
replace mo_occ=	378	if occ==	378	;
replace mo_occ=	379	if occ==	379	;
replace mo_occ=	383	if occ==	383	;
replace mo_occ=	384	if occ==	384	;
replace mo_occ=	385	if occ==	385	;
replace mo_occ=	386	if occ==	386	;
replace mo_occ=	387	if occ==	387	;
replace mo_occ=	389	if occ==	369	;
replace mo_occ=	389	if occ==	374	;
replace mo_occ=	389	if occ==	389	;
replace mo_occ=	405	if occ==	405	;
replace mo_occ=	405	if occ==	449	;
replace mo_occ=	405	if occ==	950	;
replace mo_occ=	407	if occ==	407	;
replace mo_occ=	415	if occ==	415	;
replace mo_occ=	417	if occ==	413	;
replace mo_occ=	417	if occ==	416	;
replace mo_occ=	417	if occ==	417	;
replace mo_occ=	418	if occ==	6	;
replace mo_occ=	418	if occ==	414	;
replace mo_occ=	418	if occ==	418	;
replace mo_occ=	423	if occ==	423	;
replace mo_occ=	423	if occ==	424	;
replace mo_occ=	425	if occ==	425	;
replace mo_occ=	426	if occ==	426	;
replace mo_occ=	427	if occ==	427	;
replace mo_occ=	434	if occ==	434	;
replace mo_occ=	435	if occ==	435	;
replace mo_occ=	436	if occ==	404	;
replace mo_occ=	436	if occ==	433	;
replace mo_occ=	436	if occ==	436	;
replace mo_occ=	436	if occ==	437	;
replace mo_occ=	438	if occ==	438	;
replace mo_occ=	439	if occ==	439	;
replace mo_occ=	443	if occ==	443	;
replace mo_occ=	444	if occ==	444	;
replace mo_occ=	445	if occ==	445	;
replace mo_occ=	446	if occ==	446	;
replace mo_occ=	447	if occ==	447	;
replace mo_occ=	448	if occ==	448	;
replace mo_occ=	453	if occ==	453	;
replace mo_occ=	454	if occ==	454	;
replace mo_occ=	455	if occ==	455	;
replace mo_occ=	456	if occ==	456	;
replace mo_occ=	457	if occ==	457	;
replace mo_occ=	458	if occ==	458	;
replace mo_occ=	459	if occ==	459	;
replace mo_occ=	461	if occ==	463	;
replace mo_occ=	462	if occ==	464	;
replace mo_occ=	463	if occ==	465	;
replace mo_occ=	464	if occ==	466	;
replace mo_occ=	465	if occ==	467	;
replace mo_occ=	468	if occ==	406	;
replace mo_occ=	468	if occ==	468	;
replace mo_occ=	469	if occ==	469	;
replace mo_occ=	473	if occ==	473	;
replace mo_occ=	474	if occ==	474	;
replace mo_occ=	475	if occ==	475	;
replace mo_occ=	476	if occ==	476	;
replace mo_occ=	479	if occ==	477	;
replace mo_occ=	479	if occ==	479	;
replace mo_occ=	483	if occ==	483	;
replace mo_occ=	484	if occ==	484	;
replace mo_occ=	485	if occ==	485	;
replace mo_occ=	486	if occ==	486	;
replace mo_occ=	487	if occ==	487	;
replace mo_occ=	488	if occ==	488	;
replace mo_occ=	489	if occ==	489	;
replace mo_occ=	496	if occ==	494	;
replace mo_occ=	496	if occ==	495	;
replace mo_occ=	496	if occ==	496	;
replace mo_occ=	498	if occ==	498	;
replace mo_occ=	498	if occ==	499	;
replace mo_occ=	503	if occ==	503	;
replace mo_occ=	505	if occ==	505	;
replace mo_occ=	505	if occ==	506	;
replace mo_occ=	507	if occ==	507	;
replace mo_occ=	508	if occ==	508	;
replace mo_occ=	508	if occ==	515	;
replace mo_occ=	509	if occ==	509	;
replace mo_occ=	514	if occ==	514	;
replace mo_occ=	516	if occ==	516	;
replace mo_occ=	516	if occ==	517	;
replace mo_occ=	518	if occ==	518	;
replace mo_occ=	519	if occ==	519	;
replace mo_occ=	523	if occ==	523	;
replace mo_occ=	525	if occ==	525	;
replace mo_occ=	526	if occ==	526	;
replace mo_occ=	527	if occ==	529	;
replace mo_occ=	527	if occ==	529	;
replace mo_occ=	533	if occ==	533	;
replace mo_occ=	534	if occ==	534	;
replace mo_occ=	535	if occ==	647	;
replace mo_occ=	535	if occ==	647	;
replace mo_occ=	536	if occ==	536	;
replace mo_occ=	538	if occ==	538	;
replace mo_occ=	539	if occ==	539	;
replace mo_occ=	543	if occ==	543	;
replace mo_occ=	544	if occ==	544	;
replace mo_occ=	549	if occ==	547	;
replace mo_occ=	549	if occ==	549	;
replace mo_occ=	549	if occ==	864	;
replace mo_occ=	558	if occ==	553	;
replace mo_occ=	558	if occ==	554	;
replace mo_occ=	558	if occ==	555	;
replace mo_occ=	558	if occ==	556	;
replace mo_occ=	558	if occ==	557	;
replace mo_occ=	558	if occ==	558	;
replace mo_occ=	563	if occ==	563	;
replace mo_occ=	563	if occ==	564	;
replace mo_occ=	563	if occ==	565	;
replace mo_occ=	563	if occ==	566	;
replace mo_occ=	567	if occ==	567	;
replace mo_occ=	567	if occ==	569	;
replace mo_occ=	573	if occ==	573	;
replace mo_occ=	575	if occ==	575	;
replace mo_occ=	575	if occ==	576	;
replace mo_occ=	577	if occ==	577	;
replace mo_occ=	579	if occ==	579	;
replace mo_occ=	583	if occ==	583	;
replace mo_occ=	584	if occ==	584	;
replace mo_occ=	585	if occ==	585	;
replace mo_occ=	585	if occ==	587	;
replace mo_occ=	588	if occ==	588	;
replace mo_occ=	589	if occ==	589	;
replace mo_occ=	593	if occ==	593	;
replace mo_occ=	594	if occ==	594	;
replace mo_occ=	594	if occ==	855	;
replace mo_occ=	595	if occ==	595	;
replace mo_occ=	596	if occ==	596	;
replace mo_occ=	597	if occ==	597	;
replace mo_occ=	598	if occ==	598	;
replace mo_occ=	599	if occ==	599	;
replace mo_occ=	614	if occ==	614	;
replace mo_occ=	615	if occ==	615	;
replace mo_occ=	616	if occ==	616	;
replace mo_occ=	617	if occ==	617	;
replace mo_occ=	628	if occ==	613	;
replace mo_occ=	628	if occ==	628	;
replace mo_occ=	628	if occ==	633	;
replace mo_occ=	628	if occ==	863	;
replace mo_occ=	634	if occ==	634	;
replace mo_occ=	634	if occ==	635	;
replace mo_occ=	634	if occ==	655	;
replace mo_occ=	637	if occ==	637	;
replace mo_occ=	637	if occ==	639	;
replace mo_occ=	643	if occ==	643	;
replace mo_occ=	644	if occ==	644	;
replace mo_occ=	645	if occ==	645	;
replace mo_occ=	645	if occ==	656	;
replace mo_occ=	645	if occ==	676	;
replace mo_occ=	646	if occ==	646	;
replace mo_occ=	649	if occ==	649	;
replace mo_occ=	653	if occ==	653	;
replace mo_occ=	653	if occ==	654	;
replace mo_occ=	657	if occ==	657	;
replace mo_occ=	658	if occ==	658	;
replace mo_occ=	659	if occ==	659	;
replace mo_occ=	666	if occ==	666	;
replace mo_occ=	667	if occ==	667	;
replace mo_occ=	668	if occ==	668	;
replace mo_occ=	669	if occ==	669	;
replace mo_occ=	674	if occ==	674	;
replace mo_occ=	675	if occ==	675	;
replace mo_occ=	675	if occ==	786	;
replace mo_occ=	675	if occ==	787	;
replace mo_occ=	675	if occ==	793	;
replace mo_occ=	675	if occ==	794	;
replace mo_occ=	675	if occ==	795	;
replace mo_occ=	677	if occ==	677	;
replace mo_occ=	678	if occ==	678	;
replace mo_occ=	679	if occ==	679	;
replace mo_occ=	684	if occ==	684	;
replace mo_occ=	686	if occ==	686	;
replace mo_occ=	687	if occ==	687	;
replace mo_occ=	688	if occ==	688	;
replace mo_occ=	693	if occ==	693	;
replace mo_occ=	694	if occ==	694	;
replace mo_occ=	695	if occ==	695	;
replace mo_occ=	696	if occ==	696	;
replace mo_occ=	699	if occ==	699	;
replace mo_occ=	703	if occ==	703	;
replace mo_occ=	703	if occ==	704	;
replace mo_occ=	703	if occ==	705	;
replace mo_occ=	706	if occ==	706	;
replace mo_occ=	707	if occ==	707	;
replace mo_occ=	708	if occ==	708	;
replace mo_occ=	709	if occ==	709	;
replace mo_occ=	713	if occ==	713	;
replace mo_occ=	717	if occ==	717	;
replace mo_occ=	719	if occ==	719	;
replace mo_occ=	723	if occ==	723	;
replace mo_occ=	724	if occ==	724	;
replace mo_occ=	726	if occ==	726	;
replace mo_occ=	727	if occ==	727	;
replace mo_occ=	728	if occ==	728	;
replace mo_occ=	729	if occ==	729	;
replace mo_occ=	733	if occ==	733	;
replace mo_occ=	734	if occ==	734	;
replace mo_occ=	734	if occ==	737	;
replace mo_occ=	735	if occ==	735	;
replace mo_occ=	736	if occ==	736	;
replace mo_occ=	738	if occ==	738	;
replace mo_occ=	739	if occ==	739	;
replace mo_occ=	743	if occ==	743	;
replace mo_occ=	744	if occ==	744	;
replace mo_occ=	745	if occ==	745	;
replace mo_occ=	747	if occ==	747	;
replace mo_occ=	748	if occ==	403	;
replace mo_occ=	748	if occ==	748	;
replace mo_occ=	749	if occ==	749	;
replace mo_occ=	753	if occ==	753	;
replace mo_occ=	754	if occ==	754	;
replace mo_occ=	755	if occ==	755	;
replace mo_occ=	755	if occ==	758	;
replace mo_occ=	756	if occ==	756	;
replace mo_occ=	757	if occ==	757	;
replace mo_occ=	759	if occ==	759	;
replace mo_occ=	763	if occ==	763	;
replace mo_occ=	764	if occ==	764	;
replace mo_occ=	765	if occ==	765	;
replace mo_occ=	766	if occ==	766	;
replace mo_occ=	768	if occ==	768	;
replace mo_occ=	769	if occ==	769	;
replace mo_occ=	773	if occ==	773	;
replace mo_occ=	774	if occ==	774	;
replace mo_occ=	779	if occ==	673	;
replace mo_occ=	779	if occ==	714	;
replace mo_occ=	779	if occ==	715	;
replace mo_occ=	779	if occ==	725	;
replace mo_occ=	779	if occ==	777	;
replace mo_occ=	779	if occ==	779	;
replace mo_occ=	779	if occ==	798	;
replace mo_occ=	783	if occ==	783	;
replace mo_occ=	784	if occ==	784	;
replace mo_occ=	785	if occ==	636	;
replace mo_occ=	785	if occ==	683	;
replace mo_occ=	785	if occ==	785	;
replace mo_occ=	789	if occ==	789	;
replace mo_occ=	796	if occ==	689	;
replace mo_occ=	796	if occ==	796	;
replace mo_occ=	796	if occ==	797	;
replace mo_occ=	799	if occ==	799	;
replace mo_occ=	803	if occ==	803	;
replace mo_occ=	804	if occ==	804	;
replace mo_occ=	804	if occ==	805	;
replace mo_occ=	804	if occ==	806	;
replace mo_occ=	804	if occ==	856	;
replace mo_occ=	808	if occ==	808	;
replace mo_occ=	809	if occ==	809	;
replace mo_occ=	809	if occ==	814	;
replace mo_occ=	813	if occ==	813	;
replace mo_occ=	823	if occ==	823	;
replace mo_occ=	824	if occ==	824	;
replace mo_occ=	824	if occ==	826	;
replace mo_occ=	825	if occ==	825	;
replace mo_occ=	829	if occ==	497	;
replace mo_occ=	829	if occ==	828	;
replace mo_occ=	829	if occ==	829	;
replace mo_occ=	829	if occ==	833	;
replace mo_occ=	834	if occ==	834	;
replace mo_occ=	844	if occ==	844	;
replace mo_occ=	848	if occ==	848	;
replace mo_occ=	848	if occ==	849	;
replace mo_occ=	853	if occ==	853	;
replace mo_occ=	859	if occ==	843	;
replace mo_occ=	859	if occ==	859	;
replace mo_occ=	865	if occ==	865	;
replace mo_occ=	866	if occ==	866	;
replace mo_occ=	869	if occ==	869	;
replace mo_occ=	873	if occ==	873	;
replace mo_occ=	875	if occ==	875	;
replace mo_occ=	876	if occ==	845	;
replace mo_occ=	876	if occ==	876	;
replace mo_occ=	877	if occ==	877	;
replace mo_occ=	878	if occ==	878	;
replace mo_occ=	883	if occ==	883	;
replace mo_occ=	885	if occ==	885	;
replace mo_occ=	887	if occ==	887	;
replace mo_occ=	888	if occ==	888	;
replace mo_occ=	889	if occ==	889	;
replace mo_occ=	905	if occ==	905	;

/*Assign 2000 Meyer-Osborne code to 1980 Census codes that do not have a harmonized 2000 Meyer-Osborne Code*/
/*NOTE: because O*NET was converted from SOC to 2000 Census, if MO does not have a code for both 1980 AND 2000 Census, these will be missing because they do not have a 2000 census code*/

replace mo_occ = 4		if occ == 3	;	/* O*NET data missing for 3 (legislators) --> assign 2000 code for chief executives and public administrators	*/
replace mo_occ = 69		if occ == 76;	/* O*NET data missing for 76 (physical scientists n.e.c.) --> assign physicists and astronmers 	*/
replace mo_occ = 154	if occ == 113;	/* earth, environmental, and marine science instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 114;	/* biological science instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 115;	/* chemistry instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 116;	/* physics instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 118;	/* psychology instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 119;	/* economics instructors --> assign to subject instructors, college	*/
replace mo_occ = 154	if occ == 123;	/* history instructors --> assign to subject instructors, college 	*/
replace mo_occ = 154	if occ == 125;	/* sociology instructors --> assign to subject instructors, college 	*/
replace mo_occ = 154	if occ == 127;	/* engineering instructors --> assign to subject instructors, college 	*/
replace mo_occ = 154	if occ == 128;	/* math instructors --> assign to subject instructors, college 	*/
replace mo_occ = 154	if occ == 139;	/* education instructors --> assign to subject instructors, college 	*/
replace mo_occ = 154	if occ == 147;	/*theology instructors --> assign to subject instructors, college 	*/
replace mo_occ = 214	if occ == 213;	/*electrical and electronic engineering technicians --> engineering technicians n.e.c.	*/
replace mo_occ = 214	if occ == 215;	/*mechanical engineering technicians --> engineering technicians n.e.c.	*/
replace mo_occ = 315	if occ == 314;	/* stenographer--> assing to typist	*/
replace mo_occ = 326	if occ == 323;	/*information clerks n.e.c. --> assign to correspondance and order clerks	*/
replace mo_occ = 344	if occ == 343;	/* cost and rate clerks (financial records processing) --> assign to billing clerks and related financial records processing 	*/
replace mo_occ = 347	if occ == 345;	/*duplication machine operators/office machine operators --> assing to office machine operators, n.e.c.	*/
replace mo_occ = 349	if occ == 353;	/*other telecom operators--> assign 2000 code for other telecom operators	*/
replace mo_occ = 389	if occ == 387;	/* teacher's aids --> assign to administrative support jobs, n.e.c. 	*/
replace mo_occ = 405	if occ == 407;	/* private household cleaners and servants --> assign to housekeepers, maids, butlers, stewards, and lodging quarters cleaners	*/
replace mo_occ = 427	if occ == 415;	/* supervisors of guards --> assign to protective services n.e.c. 	*/
replace mo_occ = 444	if occ == 438;	/* food counter and fountain workers --> misc. food prep workers	*/
replace mo_occ = 473	if occ == 474;	/* horticultural specialty farmers --> farmers (owners and tenants)	*/
replace mo_occ = 485	if occ == 476;	/* managers of horticultural specialty farms --> supervisors of agricultural occupations	*/
replace mo_occ = 479	if occ == 484;	/* nursery farming workers --> farm workers	*/
replace mo_occ = 549	if occ == 538;	/* office machine repairers and mechanics --> mechanics and repairers, n.e.c. 	*/
replace mo_occ = 684	if occ == 653;	/* tinsmiths, coppersmiths, and sheet metal workers --> other precision and craft workers	*/
replace mo_occ = 666	if occ == 667;	/* tailors --> dressmakers and seamstresses	*/
replace mo_occ = 628	if occ == 689;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_occ = 699	if occ == 693;	/* adjusters and calibrators --> other plant and system operators 	*/
replace mo_occ = 779	if occ == 717;	/* fabricating machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_occ = 779	if occ == 726;	/* wood lathe, routing, and planing machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_occ = 779	if occ == 733;	/* other woodworking machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_occ = 779	if occ == 735;	/* photo engravers and lithographers --> printing machine operators n.e.c. 	*/
replace mo_occ = 779	if occ == 768;	/* crushing and grinding machine operators --> machine operators n.e.c. 	*/
replace mo_occ = 783	if occ == 784;	/* solderers --> welders and metal cutters	*/
replace mo_occ = 759	if occ == 789;	/* hand painting, coating, and decorating occupations --> painting machine operators	*/
replace mo_occ = 628	if occ == 796;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_occ = 628	if occ == 797;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_occ = 365	if occ == 877;	/* stock handlers --> stock and inventory clerks	*/

/*Convert 1980 Census Codes to Osborne and Meyer Harmonized Codes for LHJ*/

replace mo_long=	3	if longocc==	3	;
replace mo_long=	4	if longocc==	4	;
replace mo_long=	7	if longocc==	7	;
replace mo_long=	8	if longocc==	8	;
replace mo_long=	13	if longocc==	13	;
replace mo_long=	13	if longocc==	197	;
replace mo_long=	14	if longocc==	14	;
replace mo_long=	15	if longocc==	15	;
replace mo_long=	16	if longocc==	17	;
replace mo_long=	18	if longocc==	16	;
replace mo_long=	19	if longocc==	18	;
replace mo_long=	22	if longocc==	5	;
replace mo_long=	22	if longocc==	19	;
replace mo_long=	23	if longocc==	23	;
replace mo_long=	24	if longocc==	24	;
replace mo_long=	25	if longocc==	25	;
replace mo_long=	26	if longocc==	26	;
replace mo_long=	27	if longocc==	27	;
replace mo_long=	28	if longocc==	28	;
replace mo_long=	29	if longocc==	29	;
replace mo_long=	33	if longocc==	9	;
replace mo_long=	33	if longocc==	33	;
replace mo_long=	34	if longocc==	34	;
replace mo_long=	35	if longocc==	35	;
replace mo_long=	36	if longocc==	36	;
replace mo_long=	37	if longocc==	37	;
replace mo_long=	43	if longocc==	43	;
replace mo_long=	44	if longocc==	44	;
replace mo_long=	45	if longocc==	45	;
replace mo_long=	47	if longocc==	47	;
replace mo_long=	48	if longocc==	48	;
replace mo_long=	53	if longocc==	53	;
replace mo_long=	55	if longocc==	55	;
replace mo_long=	56	if longocc==	56	;
replace mo_long=	57	if longocc==	57	;
replace mo_long=	59	if longocc==	46	;
replace mo_long=	59	if longocc==	49	;
replace mo_long=	59	if longocc==	54	;
replace mo_long=	59	if longocc==	58	;
replace mo_long=	59	if longocc==	59	;
replace mo_long=	64	if longocc==	64	;
replace mo_long=	65	if longocc==	65	;
replace mo_long=	66	if longocc==	66	;
replace mo_long=	67	if longocc==	67	;
replace mo_long=	68	if longocc==	68	;
replace mo_long=	69	if longocc==	69	;
replace mo_long=	73	if longocc==	73	;
replace mo_long=	74	if longocc==	74	;
replace mo_long=	75	if longocc==	75	;
replace mo_long=	76	if longocc==	76	;
replace mo_long=	77	if longocc==	77	;
replace mo_long=	78	if longocc==	78	;
replace mo_long=	79	if longocc==	79	;
replace mo_long=	83	if longocc==	83	;
replace mo_long=	84	if longocc==	84	;
replace mo_long=	85	if longocc==	85	;
replace mo_long=	86	if longocc==	86	;
replace mo_long=	87	if longocc==	87	;
replace mo_long=	88	if longocc==	88	;
replace mo_long=	89	if longocc==	89	;
replace mo_long=	95	if longocc==	95	;
replace mo_long=	96	if longocc==	96	;
replace mo_long=	97	if longocc==	97	;
replace mo_long=	98	if longocc==	98	;
replace mo_long=	99	if longocc==	99	;
replace mo_long=	103	if longocc==	103	;
replace mo_long=	104	if longocc==	104	;
replace mo_long=	105	if longocc==	105	;
replace mo_long=	106	if longocc==	106	;
replace mo_long=	113	if longocc==	113	;
replace mo_long=	114	if longocc==	114	;
replace mo_long=	115	if longocc==	115	;
replace mo_long=	116	if longocc==	116	;
replace mo_long=	118	if longocc==	118	;
replace mo_long=	119	if longocc==	119	;
replace mo_long=	123	if longocc==	123	;
replace mo_long=	125	if longocc==	125	;
replace mo_long=	127	if longocc==	127	;
replace mo_long=	128	if longocc==	128	;
replace mo_long=	139	if longocc==	139	;
replace mo_long=	145	if longocc==	145	;
replace mo_long=	147	if longocc==	147	;
replace mo_long=	149	if longocc==	149	;
replace mo_long=	154	if longocc==	117	;
replace mo_long=	154	if longocc==	124	;
replace mo_long=	154	if longocc==	126	;
replace mo_long=	154	if longocc==	129	;
replace mo_long=	154	if longocc==	133	;
replace mo_long=	154	if longocc==	134	;
replace mo_long=	154	if longocc==	135	;
replace mo_long=	154	if longocc==	136	;
replace mo_long=	154	if longocc==	137	;
replace mo_long=	154	if longocc==	138	;
replace mo_long=	154	if longocc==	143	;
replace mo_long=	154	if longocc==	144	;
replace mo_long=	154	if longocc==	146	;
replace mo_long=	154	if longocc==	148	;
replace mo_long=	154	if longocc==	153	;
replace mo_long=	154	if longocc==	154	;
replace mo_long=	155	if longocc==	155	;
replace mo_long=	156	if longocc==	156	;
replace mo_long=	157	if longocc==	157	;
replace mo_long=	158	if longocc==	158	;
replace mo_long=	159	if longocc==	159	;
replace mo_long=	163	if longocc==	163	;
replace mo_long=	164	if longocc==	164	;
replace mo_long=	165	if longocc==	165	;
replace mo_long=	166	if longocc==	166	;
replace mo_long=	167	if longocc==	167	;
replace mo_long=	168	if longocc==	168	;
replace mo_long=	169	if longocc==	169	;
replace mo_long=	173	if longocc==	173	;
replace mo_long=	174	if longocc==	174	;
replace mo_long=	175	if longocc==	175	;
replace mo_long=	176	if longocc==	176	;
replace mo_long=	176	if longocc==	177	;
replace mo_long=	178	if longocc==	178	;
replace mo_long=	179	if longocc==	179	;
replace mo_long=	183	if longocc==	183	;
replace mo_long=	184	if longocc==	184	;
replace mo_long=	185	if longocc==	185	;
replace mo_long=	186	if longocc==	186	;
replace mo_long=	187	if longocc==	187	;
replace mo_long=	188	if longocc==	188	;
replace mo_long=	189	if longocc==	189	;
replace mo_long=	193	if longocc==	193	;
replace mo_long=	194	if longocc==	194	;
replace mo_long=	195	if longocc==	195	;
replace mo_long=	198	if longocc==	198	;
replace mo_long=	199	if longocc==	199	;
replace mo_long=	203	if longocc==	203	;
replace mo_long=	204	if longocc==	204	;
replace mo_long=	205	if longocc==	205	;
replace mo_long=	206	if longocc==	206	;
replace mo_long=	207	if longocc==	207	;
replace mo_long=	208	if longocc==	208	;
replace mo_long=	213	if longocc==	213	;
replace mo_long=	214	if longocc==	214	;
replace mo_long=	214	if longocc==	216	;
replace mo_long=	215	if longocc==	215	;
replace mo_long=	217	if longocc==	217	;
replace mo_long=	218	if longocc==	63	;
replace mo_long=	218	if longocc==	218	;
replace mo_long=	218	if longocc==	867	;
replace mo_long=	223	if longocc==	223	;
replace mo_long=	224	if longocc==	224	;
replace mo_long=	225	if longocc==	225	;
replace mo_long=	226	if longocc==	226	;
replace mo_long=	227	if longocc==	227	;
replace mo_long=	228	if longocc==	228	;
replace mo_long=	229	if longocc==	229	;
replace mo_long=	233	if longocc==	233	;
replace mo_long=	234	if longocc==	234	;
replace mo_long=	235	if longocc==	235	;
replace mo_long=	243	if longocc==	243	;
replace mo_long=	253	if longocc==	253	;
replace mo_long=	254	if longocc==	254	;
replace mo_long=	255	if longocc==	255	;
replace mo_long=	256	if longocc==	256	;
replace mo_long=	258	if longocc==	258	;
replace mo_long=	274	if longocc==	257	;
replace mo_long=	274	if longocc==	259	;
replace mo_long=	274	if longocc==	263	;
replace mo_long=	274	if longocc==	264	;
replace mo_long=	274	if longocc==	265	;
replace mo_long=	274	if longocc==	266	;
replace mo_long=	274	if longocc==	267	;
replace mo_long=	274	if longocc==	268	;
replace mo_long=	274	if longocc==	269	;
replace mo_long=	274	if longocc==	274	;
replace mo_long=	274	if longocc==	284	;
replace mo_long=	274	if longocc==	285	;
replace mo_long=	275	if longocc==	275	;
replace mo_long=	276	if longocc==	276	;
replace mo_long=	277	if longocc==	277	;
replace mo_long=	277	if longocc==	278	;
replace mo_long=	283	if longocc==	283	;
replace mo_long=	303	if longocc==	303	;
replace mo_long=	303	if longocc==	305	;
replace mo_long=	308	if longocc==	304	;
replace mo_long=	308	if longocc==	308	;
replace mo_long=	308	if longocc==	309	;
replace mo_long=	313	if longocc==	313	;
replace mo_long=	314	if longocc==	314	;
replace mo_long=	315	if longocc==	315	;
replace mo_long=	316	if longocc==	316	;
replace mo_long=	317	if longocc==	317	;
replace mo_long=	318	if longocc==	318	;
replace mo_long=	319	if longocc==	319	;
replace mo_long=	323	if longocc==	323	;
replace mo_long=	323	if longocc==	325	;
replace mo_long=	326	if longocc==	326	;
replace mo_long=	326	if longocc==	327	;
replace mo_long=	328	if longocc==	328	;
replace mo_long=	329	if longocc==	329	;
replace mo_long=	335	if longocc==	335	;
replace mo_long=	336	if longocc==	336	;
replace mo_long=	337	if longocc==	337	;
replace mo_long=	338	if longocc==	338	;
replace mo_long=	343	if longocc==	343	;
replace mo_long=	344	if longocc==	339	;
replace mo_long=	344	if longocc==	344	;
replace mo_long=	345	if longocc==	345	;
replace mo_long=	346	if longocc==	346	;
replace mo_long=	347	if longocc==	347	;
replace mo_long=	348	if longocc==	306	;
replace mo_long=	348	if longocc==	348	;
replace mo_long=	349	if longocc==	349	;
replace mo_long=	349	if longocc==	353	;
replace mo_long=	354	if longocc==	354	;
replace mo_long=	355	if longocc==	355	;
replace mo_long=	356	if longocc==	356	;
replace mo_long=	357	if longocc==	357	;
replace mo_long=	359	if longocc==	359	;
replace mo_long=	364	if longocc==	307	;
replace mo_long=	364	if longocc==	364	;
replace mo_long=	365	if longocc==	365	;
replace mo_long=	366	if longocc==	366	;
replace mo_long=	368	if longocc==	368	;
replace mo_long=	373	if longocc==	363	;
replace mo_long=	373	if longocc==	373	;
replace mo_long=	375	if longocc==	375	;
replace mo_long=	376	if longocc==	376	;
replace mo_long=	377	if longocc==	377	;
replace mo_long=	378	if longocc==	378	;
replace mo_long=	379	if longocc==	379	;
replace mo_long=	383	if longocc==	383	;
replace mo_long=	384	if longocc==	384	;
replace mo_long=	385	if longocc==	385	;
replace mo_long=	386	if longocc==	386	;
replace mo_long=	387	if longocc==	387	;
replace mo_long=	389	if longocc==	369	;
replace mo_long=	389	if longocc==	374	;
replace mo_long=	389	if longocc==	389	;
replace mo_long=	405	if longocc==	405	;
replace mo_long=	405	if longocc==	449	;
replace mo_long=	405	if longocc==	950	;
replace mo_long=	407	if longocc==	407	;
replace mo_long=	415	if longocc==	415	;
replace mo_long=	417	if longocc==	413	;
replace mo_long=	417	if longocc==	416	;
replace mo_long=	417	if longocc==	417	;
replace mo_long=	418	if longocc==	6	;
replace mo_long=	418	if longocc==	414	;
replace mo_long=	418	if longocc==	418	;
replace mo_long=	423	if longocc==	423	;
replace mo_long=	423	if longocc==	424	;
replace mo_long=	425	if longocc==	425	;
replace mo_long=	426	if longocc==	426	;
replace mo_long=	427	if longocc==	427	;
replace mo_long=	434	if longocc==	434	;
replace mo_long=	435	if longocc==	435	;
replace mo_long=	436	if longocc==	404	;
replace mo_long=	436	if longocc==	433	;
replace mo_long=	436	if longocc==	436	;
replace mo_long=	436	if longocc==	437	;
replace mo_long=	438	if longocc==	438	;
replace mo_long=	439	if longocc==	439	;
replace mo_long=	443	if longocc==	443	;
replace mo_long=	444	if longocc==	444	;
replace mo_long=	445	if longocc==	445	;
replace mo_long=	446	if longocc==	446	;
replace mo_long=	447	if longocc==	447	;
replace mo_long=	448	if longocc==	448	;
replace mo_long=	453	if longocc==	453	;
replace mo_long=	454	if longocc==	454	;
replace mo_long=	455	if longocc==	455	;
replace mo_long=	456	if longocc==	456	;
replace mo_long=	457	if longocc==	457	;
replace mo_long=	458	if longocc==	458	;
replace mo_long=	459	if longocc==	459	;
replace mo_long=	461	if longocc==	463	;
replace mo_long=	462	if longocc==	464	;
replace mo_long=	463	if longocc==	465	;
replace mo_long=	464	if longocc==	466	;
replace mo_long=	465	if longocc==	467	;
replace mo_long=	468	if longocc==	406	;
replace mo_long=	468	if longocc==	468	;
replace mo_long=	469	if longocc==	469	;
replace mo_long=	473	if longocc==	473	;
replace mo_long=	474	if longocc==	474	;
replace mo_long=	475	if longocc==	475	;
replace mo_long=	476	if longocc==	476	;
replace mo_long=	479	if longocc==	477	;
replace mo_long=	479	if longocc==	479	;
replace mo_long=	483	if longocc==	483	;
replace mo_long=	484	if longocc==	484	;
replace mo_long=	485	if longocc==	485	;
replace mo_long=	486	if longocc==	486	;
replace mo_long=	487	if longocc==	487	;
replace mo_long=	488	if longocc==	488	;
replace mo_long=	489	if longocc==	489	;
replace mo_long=	496	if longocc==	494	;
replace mo_long=	496	if longocc==	495	;
replace mo_long=	496	if longocc==	496	;
replace mo_long=	498	if longocc==	498	;
replace mo_long=	498	if longocc==	499	;
replace mo_long=	503	if longocc==	503	;
replace mo_long=	505	if longocc==	505	;
replace mo_long=	505	if longocc==	506	;
replace mo_long=	507	if longocc==	507	;
replace mo_long=	508	if longocc==	508	;
replace mo_long=	508	if longocc==	515	;
replace mo_long=	509	if longocc==	509	;
replace mo_long=	514	if longocc==	514	;
replace mo_long=	516	if longocc==	516	;
replace mo_long=	516	if longocc==	517	;
replace mo_long=	518	if longocc==	518	;
replace mo_long=	519	if longocc==	519	;
replace mo_long=	523	if longocc==	523	;
replace mo_long=	525	if longocc==	525	;
replace mo_long=	526	if longocc==	526	;
replace mo_long=	527	if longocc==	529	;
replace mo_long=	527	if longocc==	529	;
replace mo_long=	533	if longocc==	533	;
replace mo_long=	534	if longocc==	534	;
replace mo_long=	535	if longocc==	647	;
replace mo_long=	535	if longocc==	647	;
replace mo_long=	536	if longocc==	536	;
replace mo_long=	538	if longocc==	538	;
replace mo_long=	539	if longocc==	539	;
replace mo_long=	543	if longocc==	543	;
replace mo_long=	544	if longocc==	544	;
replace mo_long=	549	if longocc==	547	;
replace mo_long=	549	if longocc==	549	;
replace mo_long=	549	if longocc==	864	;
replace mo_long=	558	if longocc==	553	;
replace mo_long=	558	if longocc==	554	;
replace mo_long=	558	if longocc==	555	;
replace mo_long=	558	if longocc==	556	;
replace mo_long=	558	if longocc==	557	;
replace mo_long=	558	if longocc==	558	;
replace mo_long=	563	if longocc==	563	;
replace mo_long=	563	if longocc==	564	;
replace mo_long=	563	if longocc==	565	;
replace mo_long=	563	if longocc==	566	;
replace mo_long=	567	if longocc==	567	;
replace mo_long=	567	if longocc==	569	;
replace mo_long=	573	if longocc==	573	;
replace mo_long=	575	if longocc==	575	;
replace mo_long=	575	if longocc==	576	;
replace mo_long=	577	if longocc==	577	;
replace mo_long=	579	if longocc==	579	;
replace mo_long=	583	if longocc==	583	;
replace mo_long=	584	if longocc==	584	;
replace mo_long=	585	if longocc==	585	;
replace mo_long=	585	if longocc==	587	;
replace mo_long=	588	if longocc==	588	;
replace mo_long=	589	if longocc==	589	;
replace mo_long=	593	if longocc==	593	;
replace mo_long=	594	if longocc==	594	;
replace mo_long=	594	if longocc==	855	;
replace mo_long=	595	if longocc==	595	;
replace mo_long=	596	if longocc==	596	;
replace mo_long=	597	if longocc==	597	;
replace mo_long=	598	if longocc==	598	;
replace mo_long=	599	if longocc==	599	;
replace mo_long=	614	if longocc==	614	;
replace mo_long=	615	if longocc==	615	;
replace mo_long=	616	if longocc==	616	;
replace mo_long=	617	if longocc==	617	;
replace mo_long=	628	if longocc==	613	;
replace mo_long=	628	if longocc==	628	;
replace mo_long=	628	if longocc==	633	;
replace mo_long=	628	if longocc==	863	;
replace mo_long=	634	if longocc==	634	;
replace mo_long=	634	if longocc==	635	;
replace mo_long=	634	if longocc==	655	;
replace mo_long=	637	if longocc==	637	;
replace mo_long=	637	if longocc==	639	;
replace mo_long=	643	if longocc==	643	;
replace mo_long=	644	if longocc==	644	;
replace mo_long=	645	if longocc==	645	;
replace mo_long=	645	if longocc==	656	;
replace mo_long=	645	if longocc==	676	;
replace mo_long=	646	if longocc==	646	;
replace mo_long=	649	if longocc==	649	;
replace mo_long=	653	if longocc==	653	;
replace mo_long=	653	if longocc==	654	;
replace mo_long=	657	if longocc==	657	;
replace mo_long=	658	if longocc==	658	;
replace mo_long=	659	if longocc==	659	;
replace mo_long=	666	if longocc==	666	;
replace mo_long=	667	if longocc==	667	;
replace mo_long=	668	if longocc==	668	;
replace mo_long=	669	if longocc==	669	;
replace mo_long=	674	if longocc==	674	;
replace mo_long=	675	if longocc==	675	;
replace mo_long=	675	if longocc==	786	;
replace mo_long=	675	if longocc==	787	;
replace mo_long=	675	if longocc==	793	;
replace mo_long=	675	if longocc==	794	;
replace mo_long=	675	if longocc==	795	;
replace mo_long=	677	if longocc==	677	;
replace mo_long=	678	if longocc==	678	;
replace mo_long=	679	if longocc==	679	;
replace mo_long=	684	if longocc==	684	;
replace mo_long=	686	if longocc==	686	;
replace mo_long=	687	if longocc==	687	;
replace mo_long=	688	if longocc==	688	;
replace mo_long=	693	if longocc==	693	;
replace mo_long=	694	if longocc==	694	;
replace mo_long=	695	if longocc==	695	;
replace mo_long=	696	if longocc==	696	;
replace mo_long=	699	if longocc==	699	;
replace mo_long=	703	if longocc==	703	;
replace mo_long=	703	if longocc==	704	;
replace mo_long=	703	if longocc==	705	;
replace mo_long=	706	if longocc==	706	;
replace mo_long=	707	if longocc==	707	;
replace mo_long=	708	if longocc==	708	;
replace mo_long=	709	if longocc==	709	;
replace mo_long=	713	if longocc==	713	;
replace mo_long=	717	if longocc==	717	;
replace mo_long=	719	if longocc==	719	;
replace mo_long=	723	if longocc==	723	;
replace mo_long=	724	if longocc==	724	;
replace mo_long=	726	if longocc==	726	;
replace mo_long=	727	if longocc==	727	;
replace mo_long=	728	if longocc==	728	;
replace mo_long=	729	if longocc==	729	;
replace mo_long=	733	if longocc==	733	;
replace mo_long=	734	if longocc==	734	;
replace mo_long=	734	if longocc==	737	;
replace mo_long=	735	if longocc==	735	;
replace mo_long=	736	if longocc==	736	;
replace mo_long=	738	if longocc==	738	;
replace mo_long=	739	if longocc==	739	;
replace mo_long=	743	if longocc==	743	;
replace mo_long=	744	if longocc==	744	;
replace mo_long=	745	if longocc==	745	;
replace mo_long=	747	if longocc==	747	;
replace mo_long=	748	if longocc==	403	;
replace mo_long=	748	if longocc==	748	;
replace mo_long=	749	if longocc==	749	;
replace mo_long=	753	if longocc==	753	;
replace mo_long=	754	if longocc==	754	;
replace mo_long=	755	if longocc==	755	;
replace mo_long=	755	if longocc==	758	;
replace mo_long=	756	if longocc==	756	;
replace mo_long=	757	if longocc==	757	;
replace mo_long=	759	if longocc==	759	;
replace mo_long=	763	if longocc==	763	;
replace mo_long=	764	if longocc==	764	;
replace mo_long=	765	if longocc==	765	;
replace mo_long=	766	if longocc==	766	;
replace mo_long=	768	if longocc==	768	;
replace mo_long=	769	if longocc==	769	;
replace mo_long=	773	if longocc==	773	;
replace mo_long=	774	if longocc==	774	;
replace mo_long=	779	if longocc==	673	;
replace mo_long=	779	if longocc==	714	;
replace mo_long=	779	if longocc==	715	;
replace mo_long=	779	if longocc==	725	;
replace mo_long=	779	if longocc==	777	;
replace mo_long=	779	if longocc==	779	;
replace mo_long=	779	if longocc==	798	;
replace mo_long=	783	if longocc==	783	;
replace mo_long=	784	if longocc==	784	;
replace mo_long=	785	if longocc==	636	;
replace mo_long=	785	if longocc==	683	;
replace mo_long=	785	if longocc==	785	;
replace mo_long=	789	if longocc==	789	;
replace mo_long=	796	if longocc==	689	;
replace mo_long=	796	if longocc==	796	;
replace mo_long=	796	if longocc==	797	;
replace mo_long=	799	if longocc==	799	;
replace mo_long=	803	if longocc==	803	;
replace mo_long=	804	if longocc==	804	;
replace mo_long=	804	if longocc==	805	;
replace mo_long=	804	if longocc==	806	;
replace mo_long=	804	if longocc==	856	;
replace mo_long=	808	if longocc==	808	;
replace mo_long=	809	if longocc==	809	;
replace mo_long=	809	if longocc==	814	;
replace mo_long=	813	if longocc==	813	;
replace mo_long=	823	if longocc==	823	;
replace mo_long=	824	if longocc==	824	;
replace mo_long=	824	if longocc==	826	;
replace mo_long=	825	if longocc==	825	;
replace mo_long=	829	if longocc==	497	;
replace mo_long=	829	if longocc==	828	;
replace mo_long=	829	if longocc==	829	;
replace mo_long=	829	if longocc==	833	;
replace mo_long=	834	if longocc==	834	;
replace mo_long=	844	if longocc==	844	;
replace mo_long=	848	if longocc==	848	;
replace mo_long=	848	if longocc==	849	;
replace mo_long=	853	if longocc==	853	;
replace mo_long=	859	if longocc==	843	;
replace mo_long=	859	if longocc==	859	;
replace mo_long=	865	if longocc==	865	;
replace mo_long=	866	if longocc==	866	;
replace mo_long=	869	if longocc==	869	;
replace mo_long=	873	if longocc==	873	;
replace mo_long=	875	if longocc==	875	;
replace mo_long=	876	if longocc==	845	;
replace mo_long=	876	if longocc==	876	;
replace mo_long=	877	if longocc==	877	;
replace mo_long=	878	if longocc==	878	;
replace mo_long=	883	if longocc==	883	;
replace mo_long=	885	if longocc==	885	;
replace mo_long=	887	if longocc==	887	;
replace mo_long=	888	if longocc==	888	;
replace mo_long=	889	if longocc==	889	;
replace mo_long=	905	if longocc==	905	;

/*Assign 2000 Meyer-Osborne code to 1980 Census codes that do not have a harmonized 2000 Meyer-Osborne Code*/
/*NOTE: because O*NET was converted from SOC to 2000 Census, if MO does not have a code for both 1980 AND 2000 Census, these will be missing because they do not have a 2000 census code*/

replace mo_long = 4		if longocc == 3	;	/* O*NET data missing for 3 (legislators) --> assign code for chief executives and public administrators	*/
replace mo_long = 69	if longocc == 76;	/* O*NET data missing for 76 (physical scientists n.e.c.) --> assign physicists and astronmers 	*/
replace mo_long = 154	if longocc == 113;	/* earth, environmental, and marine science instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 114;	/* biological science instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 115;	/* chemistry instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 116;	/* physics instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 118;	/* psychology instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 119;	/* economics instructors --> assign to subject instructors, college	*/
replace mo_long = 154	if longocc == 123;	/* history instructors --> assign to subject instructors, college 	*/
replace mo_long = 154	if longocc == 125;	/* sociology instructors --> assign to subject instructors, college 	*/
replace mo_long = 154	if longocc == 127;	/* engineering instructors --> assign to subject instructors, college 	*/
replace mo_long = 154	if longocc == 128;	/* math instructors --> assign to subject instructors, college 	*/
replace mo_long = 154	if longocc == 139;	/* education instructors --> assign to subject instructors, college 	*/
replace mo_long = 154	if longocc == 147;	/*theology instructors --> assign to subject instructors, college 	*/
replace mo_long = 214	if longocc == 213;	/*electrical and electronic engineering technicians --> engineering technicians n.e.c.	*/
replace mo_long = 214	if longocc == 215;	/*mechanical engineering technicians --> engineering technicians n.e.c.	*/
replace mo_long = 315	if longocc == 314;	/* stenographer--> assing to typist	*/
replace mo_long = 326	if longocc == 323;	/*information clerks n.e.c. --> assign to correspondance and order clerks	*/
replace mo_long = 344	if longocc == 343;	/* cost and rate clerks (financial records processing) --> assign to billing clerks and related financial records processing 	*/
replace mo_long = 347	if longocc == 345;	/*duplication machine operators/office machine operators --> assing to office machine operators, n.e.c.	*/
replace mo_long = 349	if longocc == 353;	/*other telecom operators--> assign 2000 code for other telecom operators	*/
replace mo_long = 389	if longocc == 387;	/* teacher's aids --> assign to administrative support jobs, n.e.c. 	*/
replace mo_long = 405	if longocc == 407;	/* private household cleaners and servants --> assign to housekeepers, maids, butlers, stewards, and lodging quarters cleaners	*/
replace mo_long = 427	if longocc == 415;	/* supervisors of guards --> assign to protective services n.e.c. 	*/
replace mo_long = 444	if longocc == 438;	/* food counter and fountain workers --> misc. food prep workers	*/
replace mo_long = 473	if longocc == 474;	/* horticultural specialty farmers --> farmers (owners and tenants)	*/
replace mo_long = 485	if longocc == 476;	/* managers of horticultural specialty farms --> supervisors of agricultural occupations	*/
replace mo_long = 479	if longocc == 484;	/* nursery farming workers --> farm workers	*/
replace mo_long = 549	if longocc == 538;	/* office machine repairers and mechanics --> mechanics and repairers, n.e.c. 	*/
replace mo_long = 684	if longocc == 653;	/* tinsmiths, coppersmiths, and sheet metal workers --> other precision and craft workers	*/
replace mo_long = 666	if longocc == 667;	/* tailors --> dressmakers and seamstresses	*/
replace mo_long = 628	if longocc == 689;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_long = 699	if longocc == 693;	/* adjusters and calibrators --> other plant and system operators 	*/
replace mo_long = 779	if longocc == 717;	/* fabricating machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_long = 779	if longocc == 726;	/* wood lathe, routing, and planing machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_long = 779	if longocc == 733;	/* other woodworking machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_long = 779	if longocc == 735;	/* photo engravers and lithographers --> printing machine operators n.e.c. 	*/
replace mo_long = 779	if longocc == 768;	/* crushing and grinding machine operators --> machine operators n.e.c. 	*/
replace mo_long = 783	if longocc == 784;	/* solderers --> welders and metal cutters	*/
replace mo_long = 759	if longocc == 789;	/* hand painting, coating, and decorating occupations --> painting machine operators	*/
replace mo_long = 628	if longocc == 796;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_long = 628	if longocc == 797;	/* production checkers and inspectors --> production supervisors or foremen	*/
replace mo_long = 365	if longocc == 877;	/* stock handlers --> stock and inventory clerks	*/


/*Convert 2000 Census Codes to Osborne and Meyer Harmonized Codes*/

replace mo_occ=	3	if occb==	3	;
replace mo_occ=	4	if occb==	1	;
replace mo_occ=	7	if occb==	12	;
replace mo_occ=	8	if occb==	13	;
replace mo_occ=	13	if occb==	4	;
replace mo_occ=	13	if occb==	5	;
replace mo_occ=	13	if occb==	6	;
replace mo_occ=	13	if occb==	282	;
replace mo_occ=	14	if occb==	23	;
replace mo_occ=	15	if occb==	35	;
replace mo_occ=	16	if occb==	40	;
replace mo_occ=	17	if occb==	31	;
replace mo_occ=	17	if occb==	34	;
replace mo_occ=	18	if occb==	41	;
replace mo_occ=	19	if occb==	32	;
replace mo_occ=	21	if occb==	33	;
replace mo_occ=	21	if occb==	36	;
replace mo_occ=	21	if occb==	42	;
replace mo_occ=	21	if occb==	72	;
replace mo_occ=	22	if occb==	2	;
replace mo_occ=	22	if occb==	10	;
replace mo_occ=	22	if occb==	11	;
replace mo_occ=	22	if occb==	14	;
replace mo_occ=	22	if occb==	22	;
replace mo_occ=	22	if occb==	30	;
replace mo_occ=	22	if occb==	43	;
replace mo_occ=	22	if occb==	60	;
replace mo_occ=	22	if occb==	430	;
replace mo_occ=	23	if occb==	80	;
replace mo_occ=	23	if occb==	93	;
replace mo_occ=	24	if occb==	86	;
replace mo_occ=	25	if occb==	82	;
replace mo_occ=	25	if occb==	83	;
replace mo_occ=	25	if occb==	84	;
replace mo_occ=	25	if occb==	85	;
replace mo_occ=	25	if occb==	91	;
replace mo_occ=	25	if occb==	94	;
replace mo_occ=	25	if occb==	95	;
replace mo_occ=	26	if occb==	71	;
replace mo_occ=	27	if occb==	62	;
replace mo_occ=	28	if occb==	51	;
replace mo_occ=	29	if occb==	52	;
replace mo_occ=	33	if occb==	15	;
replace mo_occ=	33	if occb==	53	;
replace mo_occ=	34	if occb==	50	;
replace mo_occ=	35	if occb==	666	;
replace mo_occ=	36	if occb==	56	;
replace mo_occ=	36	if occb==	90	;
replace mo_occ=	37	if occb==	73	;
replace mo_occ=	43	if occb==	130	;
replace mo_occ=	44	if occb==	132	;
replace mo_occ=	45	if occb==	145	;
replace mo_occ=	47	if occb==	152	;
replace mo_occ=	48	if occb==	135	;
replace mo_occ=	53	if occb==	136	;
replace mo_occ=	55	if occb==	140	;
replace mo_occ=	55	if occb==	141	;
replace mo_occ=	56	if occb==	143	;
replace mo_occ=	57	if occb==	146	;
replace mo_occ=	59	if occb==	133	;
replace mo_occ=	59	if occb==	134	;
replace mo_occ=	59	if occb==	142	;
replace mo_occ=	59	if occb==	144	;
replace mo_occ=	59	if occb==	150	;
replace mo_occ=	59	if occb==	151	;
replace mo_occ=	59	if occb==	153	;
replace mo_occ=	64	if occb==	100	;
replace mo_occ=	64	if occb==	104	;
replace mo_occ=	64	if occb==	106	;
replace mo_occ=	64	if occb==	110	;
replace mo_occ=	64	if occb==	111	;
replace mo_occ=	65	if occb==	70	;
replace mo_occ=	65	if occb==	122	;
replace mo_occ=	66	if occb==	120	;
replace mo_occ=	67	if occb==	123	;
replace mo_occ=	68	if occb==	121	;
replace mo_occ=	68	if occb==	124	;
replace mo_occ=	69	if occb==	170	;
replace mo_occ=	73	if occb==	172	;
replace mo_occ=	74	if occb==	171	;
replace mo_occ=	75	if occb==	174	;
replace mo_occ=	76	if occb==	176	;
replace mo_occ=	77	if occb==	160	;
replace mo_occ=	78	if occb==	161	;
replace mo_occ=	79	if occb==	164	;
replace mo_occ=	83	if occb==	165	;
replace mo_occ=	84	if occb==	306	;
replace mo_occ=	85	if occb==	301	;
replace mo_occ=	86	if occb==	325	;
replace mo_occ=	87	if occb==	304	;
replace mo_occ=	88	if occb==	312	;
replace mo_occ=	89	if occb==	300	;
replace mo_occ=	89	if occb==	326	;
replace mo_occ=	95	if occb==	313	;
replace mo_occ=	96	if occb==	305	;
replace mo_occ=	97	if occb==	303	;
replace mo_occ=	98	if occb==	322	;
replace mo_occ=	99	if occb==	315	;
replace mo_occ=	99	if occb==	361	;
replace mo_occ=	103	if occb==	316	;
replace mo_occ=	103	if occb==	362	;
replace mo_occ=	104	if occb==	314	;
replace mo_occ=	104	if occb==	323	;
replace mo_occ=	105	if occb==	320	;
replace mo_occ=	105	if occb==	321	;
replace mo_occ=	105	if occb==	324	;
replace mo_occ=	106	if occb==	311	;
replace mo_occ=	154	if occb==	220	;
replace mo_occ=	155	if occb==	230	;
replace mo_occ=	156	if occb==	231	;
replace mo_occ=	157	if occb==	232	;
replace mo_occ=	158	if occb==	233	;
replace mo_occ=	159	if occb==	234	;
replace mo_occ=	159	if occb==	254	;
replace mo_occ=	159	if occb==	255	;
replace mo_occ=	163	if occb==	200	;
replace mo_occ=	164	if occb==	243	;
replace mo_occ=	165	if occb==	240	;
replace mo_occ=	166	if occb==	180	;
replace mo_occ=	166	if occb==	181	;
replace mo_occ=	167	if occb==	182	;
replace mo_occ=	168	if occb==	183	;
replace mo_occ=	169	if occb==	186	;
replace mo_occ=	173	if occb==	184	;
replace mo_occ=	174	if occb==	201	;
replace mo_occ=	175	if occb==	462	;
replace mo_occ=	176	if occb==	204	;
replace mo_occ=	176	if occb==	205	;
replace mo_occ=	176	if occb==	206	;
replace mo_occ=	178	if occb==	210	;
replace mo_occ=	179	if occb==	211	;
replace mo_occ=	183	if occb==	285	;
replace mo_occ=	184	if occb==	284	;
replace mo_occ=	185	if occb==	263	;
replace mo_occ=	186	if occb==	275	;
replace mo_occ=	187	if occb==	270	;
replace mo_occ=	187	if occb==	271	;
replace mo_occ=	188	if occb==	260	;
replace mo_occ=	189	if occb==	291	;
replace mo_occ=	193	if occb==	274	;
replace mo_occ=	194	if occb==	276	;
replace mo_occ=	194	if occb==	286	;
replace mo_occ=	195	if occb==	281	;
replace mo_occ=	195	if occb==	283	;
replace mo_occ=	195	if occb==	292	;
replace mo_occ=	198	if occb==	280	;
replace mo_occ=	199	if occb==	272	;
replace mo_occ=	199	if occb==	752	;
replace mo_occ=	203	if occb==	330	;
replace mo_occ=	204	if occb==	331	;
replace mo_occ=	205	if occb==	351	;
replace mo_occ=	206	if occb==	332	;
replace mo_occ=	207	if occb==	350	;
replace mo_occ=	208	if occb==	340	;
replace mo_occ=	208	if occb==	353	;
replace mo_occ=	208	if occb==	354	;
replace mo_occ=	214	if occb==	155	;
replace mo_occ=	214	if occb==	196	;
replace mo_occ=	217	if occb==	154	;
replace mo_occ=	218	if occb==	131	;
replace mo_occ=	218	if occb==	156	;
replace mo_occ=	223	if occb==	190	;
replace mo_occ=	223	if occb==	191	;
replace mo_occ=	224	if occb==	192	;
replace mo_occ=	225	if occb==	193	;
replace mo_occ=	226	if occb==	903	;
replace mo_occ=	227	if occb==	904	;
replace mo_occ=	228	if occb==	290	;
replace mo_occ=	228	if occb==	296	;
replace mo_occ=	229	if occb==	101	;
replace mo_occ=	229	if occb==	102	;
replace mo_occ=	233	if occb==	790	;
replace mo_occ=	234	if occb==	214	;
replace mo_occ=	234	if occb==	215	;
replace mo_occ=	235	if occb==	194	;
replace mo_occ=	243	if occb==	470	;
replace mo_occ=	243	if occb==	471	;
replace mo_occ=	253	if occb==	481	;
replace mo_occ=	254	if occb==	81	;
replace mo_occ=	254	if occb==	492	;
replace mo_occ=	255	if occb==	482	;
replace mo_occ=	256	if occb==	480	;
replace mo_occ=	258	if occb==	493	;
replace mo_occ=	274	if occb==	474	;
replace mo_occ=	274	if occb==	475	;
replace mo_occ=	274	if occb==	484	;
replace mo_occ=	274	if occb==	485	;
replace mo_occ=	274	if occb==	494	;
replace mo_occ=	274	if occb==	496	;
replace mo_occ=	275	if occb==	476	;
replace mo_occ=	276	if occb==	472	;
replace mo_occ=	276	if occb==	513	;
replace mo_occ=	277	if occb==	495	;
replace mo_occ=	283	if occb==	490	;
replace mo_occ=	303	if occb==	500	;
replace mo_occ=	308	if occb==	580	;
replace mo_occ=	313	if occb==	570	;
replace mo_occ=	315	if occb==	582	;
replace mo_occ=	315	if occb==	583	;
replace mo_occ=	316	if occb==	523	;
replace mo_occ=	316	if occb==	531	;
replace mo_occ=	316	if occb==	534	;
replace mo_occ=	317	if occb==	530	;
replace mo_occ=	318	if occb==	483	;
replace mo_occ=	318	if occb==	541	;
replace mo_occ=	319	if occb==	540	;
replace mo_occ=	326	if occb==	521	;
replace mo_occ=	326	if occb==	535	;
replace mo_occ=	328	if occb==	536	;
replace mo_occ=	329	if occb==	244	;
replace mo_occ=	329	if occb==	532	;
replace mo_occ=	335	if occb==	526	;
replace mo_occ=	336	if occb==	520	;
replace mo_occ=	336	if occb==	542	;
replace mo_occ=	337	if occb==	512	;
replace mo_occ=	338	if occb==	514	;
replace mo_occ=	344	if occb==	511	;
replace mo_occ=	346	if occb==	556	;
replace mo_occ=	347	if occb==	590	;
replace mo_occ=	348	if occb==	501	;
replace mo_occ=	348	if occb==	502	;
replace mo_occ=	349	if occb==	503	;
replace mo_occ=	354	if occb==	554	;
replace mo_occ=	355	if occb==	555	;
replace mo_occ=	356	if occb==	585	;
replace mo_occ=	357	if occb==	551	;
replace mo_occ=	359	if occb==	552	;
replace mo_occ=	364	if occb==	550	;
replace mo_occ=	364	if occb==	561	;
replace mo_occ=	365	if occb==	515	;
replace mo_occ=	365	if occb==	562	;
replace mo_occ=	366	if occb==	553	;
replace mo_occ=	368	if occb==	563	;
replace mo_occ=	373	if occb==	16	;
replace mo_occ=	373	if occb==	560	;
replace mo_occ=	375	if occb==	54	;
replace mo_occ=	375	if occb==	584	;
replace mo_occ=	376	if occb==	524	;
replace mo_occ=	376	if occb==	533	;
replace mo_occ=	377	if occb==	525	;
replace mo_occ=	378	if occb==	510	;
replace mo_occ=	379	if occb==	586	;
replace mo_occ=	383	if occb==	516	;
replace mo_occ=	384	if occb==	591	;
replace mo_occ=	385	if occb==	581	;
replace mo_occ=	386	if occb==	592	;
replace mo_occ=	389	if occb==	522	;
replace mo_occ=	389	if occb==	593	;
replace mo_occ=	405	if occb==	384	;
replace mo_occ=	405	if occb==	423	;
replace mo_occ=	415	if occb==	373	;
replace mo_occ=	417	if occb==	372	;
replace mo_occ=	417	if occb==	374	;
replace mo_occ=	417	if occb==	375	;
replace mo_occ=	418	if occb==	371	;
replace mo_occ=	418	if occb==	382	;
replace mo_occ=	418	if occb==	385	;
replace mo_occ=	418	if occb==	386	;
replace mo_occ=	418	if occb==	391	;
replace mo_occ=	423	if occb==	370	;
replace mo_occ=	423	if occb==	380	;
replace mo_occ=	423	if occb==	383	;
replace mo_occ=	425	if occb==	394	;
replace mo_occ=	426	if occb==	392	;
replace mo_occ=	427	if occb==	390	;
replace mo_occ=	427	if occb==	395	;
replace mo_occ=	434	if occb==	404	;
replace mo_occ=	435	if occb==	411	;
replace mo_occ=	436	if occb==	400	;
replace mo_occ=	436	if occb==	401	;
replace mo_occ=	436	if occb==	402	;
replace mo_occ=	439	if occb==	405	;
replace mo_occ=	443	if occb==	406	;
replace mo_occ=	443	if occb==	412	;
replace mo_occ=	443	if occb==	413	;
replace mo_occ=	444	if occb==	403	;
replace mo_occ=	444	if occb==	414	;
replace mo_occ=	444	if occb==	416	;
replace mo_occ=	445	if occb==	364	;
replace mo_occ=	446	if occb==	365	;
replace mo_occ=	447	if occb==	360	;
replace mo_occ=	447	if occb==	461	;
replace mo_occ=	448	if occb==	420	;
replace mo_occ=	453	if occb==	422	;
replace mo_occ=	454	if occb==	975	;
replace mo_occ=	455	if occb==	424	;
replace mo_occ=	456	if occb==	432	;
replace mo_occ=	457	if occb==	450	;
replace mo_occ=	458	if occb==	451	;
replace mo_occ=	458	if occb==	452	;
replace mo_occ=	459	if occb==	440	;
replace mo_occ=	459	if occb==	443	;
replace mo_occ=	461	if occb==	454	;
replace mo_occ=	462	if occb==	442	;
replace mo_occ=	463	if occb==	455	;
replace mo_occ=	463	if occb==	941	;
replace mo_occ=	464	if occb==	453	;
replace mo_occ=	465	if occb==	202	;
replace mo_occ=	468	if occb==	460	;
replace mo_occ=	468	if occb==	464	;
replace mo_occ=	469	if occb==	363	;
replace mo_occ=	469	if occb==	415	;
replace mo_occ=	469	if occb==	446	;
replace mo_occ=	469	if occb==	465	;
replace mo_occ=	473	if occb==	21	;
replace mo_occ=	475	if occb==	20	;
replace mo_occ=	475	if occb==	602	;
replace mo_occ=	479	if occb==	434	;
replace mo_occ=	479	if occb==	605	;
replace mo_occ=	485	if occb==	421	;
replace mo_occ=	486	if occb==	425	;
replace mo_occ=	487	if occb==	435	;
replace mo_occ=	488	if occb==	604	;
replace mo_occ=	489	if occb==	601	;
replace mo_occ=	496	if occb==	600	;
replace mo_occ=	496	if occb==	612	;
replace mo_occ=	496	if occb==	613	;
replace mo_occ=	498	if occb==	610	;
replace mo_occ=	498	if occb==	611	;
replace mo_occ=	503	if occb==	700	;
replace mo_occ=	505	if occb==	720	;
replace mo_occ=	507	if occb==	721	;
replace mo_occ=	508	if occb==	714	;
replace mo_occ=	509	if occb==	724	;
replace mo_occ=	514	if occb==	715	;
replace mo_occ=	514	if occb==	716	;
replace mo_occ=	516	if occb==	722	;
replace mo_occ=	516	if occb==	726	;
replace mo_occ=	518	if occb==	733	;
replace mo_occ=	519	if occb==	735	;
replace mo_occ=	523	if occb==	710	;
replace mo_occ=	523	if occb==	712	;
replace mo_occ=	525	if occb==	701	;
replace mo_occ=	526	if occb==	732	;
replace mo_occ=	527	if occb==	702	;
replace mo_occ=	527	if occb==	742	;
replace mo_occ=	533	if occb==	703	;
replace mo_occ=	533	if occb==	705	;
replace mo_occ=	533	if occb==	711	;
replace mo_occ=	534	if occb==	731	;
replace mo_occ=	535	if occb==	743	;
replace mo_occ=	535	if occb==	875	;
replace mo_occ=	536	if occb==	754	;
replace mo_occ=	539	if occb==	730	;
replace mo_occ=	543	if occb==	670	;
replace mo_occ=	544	if occb==	736	;
replace mo_occ=	549	if occb==	734	;
replace mo_occ=	549	if occb==	755	;
replace mo_occ=	549	if occb==	756	;
replace mo_occ=	549	if occb==	762	;
replace mo_occ=	558	if occb==	620	;
replace mo_occ=	563	if occb==	622	;
replace mo_occ=	563	if occb==	624	;
replace mo_occ=	567	if occb==	623	;
replace mo_occ=	573	if occb==	633	;
replace mo_occ=	575	if occb==	635	;
replace mo_occ=	575	if occb==	713	;
replace mo_occ=	577	if occb==	704	;
replace mo_occ=	577	if occb==	741	;
replace mo_occ=	577	if occb==	760	;
replace mo_occ=	579	if occb==	642	;
replace mo_occ=	583	if occb==	643	;
replace mo_occ=	584	if occb==	646	;
replace mo_occ=	585	if occb==	644	;
replace mo_occ=	588	if occb==	625	;
replace mo_occ=	589	if occb==	636	;
replace mo_occ=	593	if occb==	640	;
replace mo_occ=	593	if occb==	672	;
replace mo_occ=	594	if occb==	630	;
replace mo_occ=	595	if occb==	651	;
replace mo_occ=	596	if occb==	652	;
replace mo_occ=	597	if occb==	650	;
replace mo_occ=	597	if occb==	653	;
replace mo_occ=	597	if occb==	774	;
replace mo_occ=	598	if occb==	682	;
replace mo_occ=	599	if occb==	631	;
replace mo_occ=	599	if occb==	671	;
replace mo_occ=	599	if occb==	676	;
replace mo_occ=	614	if occb==	680	;
replace mo_occ=	614	if occb==	692	;
replace mo_occ=	615	if occb==	683	;
replace mo_occ=	616	if occb==	684	;
replace mo_occ=	617	if occb==	691	;
replace mo_occ=	617	if occb==	694	;
replace mo_occ=	628	if occb==	770	;
replace mo_occ=	634	if occb==	813	;
replace mo_occ=	637	if occb==	803	;
replace mo_occ=	643	if occb==	621	;
replace mo_occ=	644	if occb==	821	;
replace mo_occ=	645	if occb==	806	;
replace mo_occ=	645	if occb==	844	;
replace mo_occ=	645	if occb==	852	;
replace mo_occ=	646	if occb==	816	;
replace mo_occ=	649	if occb==	891	;
replace mo_occ=	657	if occb==	850	;
replace mo_occ=	658	if occb==	851	;
replace mo_occ=	666	if occb==	835	;
replace mo_occ=	668	if occb==	845	;
replace mo_occ=	669	if occb==	833	;
replace mo_occ=	675	if occb==	892	;
replace mo_occ=	677	if occb==	352	;
replace mo_occ=	678	if occb==	341	;
replace mo_occ=	678	if occb==	876	;
replace mo_occ=	679	if occb==	823	;
replace mo_occ=	684	if occb==	812	;
replace mo_occ=	686	if occb==	781	;
replace mo_occ=	687	if occb==	780	;
replace mo_occ=	688	if occb==	784	;
replace mo_occ=	694	if occb==	862	;
replace mo_occ=	695	if occb==	860	;
replace mo_occ=	696	if occb==	861	;
replace mo_occ=	699	if occb==	863	;
replace mo_occ=	703	if occb==	801	;
replace mo_occ=	703	if occb==	802	;
replace mo_occ=	706	if occb==	795	;
replace mo_occ=	707	if occb==	794	;
replace mo_occ=	708	if occb==	796	;
replace mo_occ=	709	if occb==	800	;
replace mo_occ=	713	if occb==	793	;
replace mo_occ=	719	if occb==	810	;
replace mo_occ=	723	if occb==	820	;
replace mo_occ=	724	if occb==	815	;
replace mo_occ=	726	if occb==	822	;
replace mo_occ=	727	if occb==	853	;
replace mo_occ=	729	if occb==	854	;
replace mo_occ=	733	if occb==	855	;
replace mo_occ=	734	if occb==	824	;
replace mo_occ=	736	if occb==	825	;
replace mo_occ=	736	if occb==	826	;
replace mo_occ=	738	if occb==	842	;
replace mo_occ=	739	if occb==	841	;
replace mo_occ=	743	if occb==	840	;
replace mo_occ=	744	if occb==	832	;
replace mo_occ=	745	if occb==	834	;
replace mo_occ=	747	if occb==	831	;
replace mo_occ=	748	if occb==	830	;
replace mo_occ=	749	if occb==	836	;
replace mo_occ=	749	if occb==	846	;
replace mo_occ=	753	if occb==	885	;
replace mo_occ=	754	if occb==	880	;
replace mo_occ=	755	if occb==	792	;
replace mo_occ=	755	if occb==	843	;
replace mo_occ=	755	if occb==	872	;
replace mo_occ=	756	if occb==	865	;
replace mo_occ=	757	if occb==	864	;
replace mo_occ=	759	if occb==	881	;
replace mo_occ=	763	if occb==	783	;
replace mo_occ=	764	if occb==	886	;
replace mo_occ=	765	if occb==	893	;
replace mo_occ=	766	if occb==	804	;
replace mo_occ=	766	if occb==	873	;
replace mo_occ=	769	if occb==	785	;
replace mo_occ=	769	if occb==	871	;
replace mo_occ=	773	if occb==	441	;
replace mo_occ=	774	if occb==	883	;
replace mo_occ=	779	if occb==	884	;
replace mo_occ=	779	if occb==	890	;
replace mo_occ=	779	if occb==	894	;
replace mo_occ=	779	if occb==	896	;
replace mo_occ=	783	if occb==	814	;
replace mo_occ=	785	if occb==	771	;
replace mo_occ=	785	if occb==	772	;
replace mo_occ=	785	if occb==	773	;
replace mo_occ=	785	if occb==	775	;
replace mo_occ=	799	if occb==	874	;
replace mo_occ=	803	if occb==	900	;
replace mo_occ=	804	if occb==	751	;
replace mo_occ=	804	if occb==	913	;
replace mo_occ=	804	if occb==	960	;
replace mo_occ=	808	if occb==	912	;
replace mo_occ=	809	if occb==	911	;
replace mo_occ=	809	if occb==	914	;
replace mo_occ=	809	if occb==	915	;
replace mo_occ=	813	if occb==	935	;
replace mo_occ=	823	if occb==	924	;
replace mo_occ=	824	if occb==	920	;
replace mo_occ=	824	if occb==	926	;
replace mo_occ=	825	if occb==	923	;
replace mo_occ=	829	if occb==	930	;
replace mo_occ=	829	if occb==	931	;
replace mo_occ=	829	if occb==	933	;
replace mo_occ=	834	if occb==	934	;
replace mo_occ=	844	if occb==	632	;
replace mo_occ=	848	if occb==	951	;
replace mo_occ=	848	if occb==	956	;
replace mo_occ=	853	if occb==	952	;
replace mo_occ=	859	if occb==	965	;
replace mo_occ=	859	if occb==	973	;
replace mo_occ=	865	if occb==	761	;
replace mo_occ=	866	if occb==	660	;
replace mo_occ=	869	if occb==	626	;
replace mo_occ=	869	if occb==	673	;
replace mo_occ=	869	if occb==	693	;
replace mo_occ=	873	if occb==	895	;
replace mo_occ=	875	if occb==	972	;
replace mo_occ=	876	if occb==	950	;
replace mo_occ=	876	if occb==	974	;
replace mo_occ=	878	if occb==	963	;
replace mo_occ=	883	if occb==	942	;
replace mo_occ=	885	if occb==	936	;
replace mo_occ=	887	if occb==	961	;
replace mo_occ=	888	if occb==	964	;
replace mo_occ=	889	if occb==	674	;
replace mo_occ=	889	if occb==	675	;
replace mo_occ=	889	if occb==	962	;
replace mo_occ=	905	if occb==	980	;
replace mo_occ=	905	if occb==	981	;
replace mo_occ=	905	if occb==	982	;
replace mo_occ=	905	if occb==	983	;


/*Assign 2000 Meyer-Osborne codes that have O*NET data to comparable 2000 Census codes that did not have O*NET data */
/*NOTE: because O*NET was converted from SOC to 2000 Census, if MO does not have a code for both 1980 AND 2000 Census, these will be missing because they do not have a 2000 census code*/

replace mo_occ=	779	if occb==	822	;	/* wood lathe, routing, and planing machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_occ=	427	if occb==	373	;	/* supervisors of guards --> assign to protective services n.e.c.	*/
replace mo_occ=	779	if occb==	855	;	/* other woodworking machine operators n.e.c. --> machine operators n.e.c.	*/


/*Convert 2000 Census Codes to Osborne and Meyer Harmonized Codes for LHJ*/

replace mo_long=	3	if longoccb==	3	;
replace mo_long=	4	if longoccb==	1	;
replace mo_long=	7	if longoccb==	12	;
replace mo_long=	8	if longoccb==	13	;
replace mo_long=	13	if longoccb==	4	;
replace mo_long=	13	if longoccb==	5	;
replace mo_long=	13	if longoccb==	6	;
replace mo_long=	13	if longoccb==	282	;
replace mo_long=	14	if longoccb==	23	;
replace mo_long=	15	if longoccb==	35	;
replace mo_long=	16	if longoccb==	40	;
replace mo_long=	17	if longoccb==	31	;
replace mo_long=	17	if longoccb==	34	;
replace mo_long=	18	if longoccb==	41	;
replace mo_long=	19	if longoccb==	32	;
replace mo_long=	21	if longoccb==	33	;
replace mo_long=	21	if longoccb==	36	;
replace mo_long=	21	if longoccb==	42	;
replace mo_long=	21	if longoccb==	72	;
replace mo_long=	22	if longoccb==	2	;
replace mo_long=	22	if longoccb==	10	;
replace mo_long=	22	if longoccb==	11	;
replace mo_long=	22	if longoccb==	14	;
replace mo_long=	22	if longoccb==	22	;
replace mo_long=	22	if longoccb==	30	;
replace mo_long=	22	if longoccb==	43	;
replace mo_long=	22	if longoccb==	60	;
replace mo_long=	22	if longoccb==	430	;
replace mo_long=	23	if longoccb==	80	;
replace mo_long=	23	if longoccb==	93	;
replace mo_long=	24	if longoccb==	86	;
replace mo_long=	25	if longoccb==	82	;
replace mo_long=	25	if longoccb==	83	;
replace mo_long=	25	if longoccb==	84	;
replace mo_long=	25	if longoccb==	85	;
replace mo_long=	25	if longoccb==	91	;
replace mo_long=	25	if longoccb==	94	;
replace mo_long=	25	if longoccb==	95	;
replace mo_long=	26	if longoccb==	71	;
replace mo_long=	27	if longoccb==	62	;
replace mo_long=	28	if longoccb==	51	;
replace mo_long=	29	if longoccb==	52	;
replace mo_long=	33	if longoccb==	15	;
replace mo_long=	33	if longoccb==	53	;
replace mo_long=	34	if longoccb==	50	;
replace mo_long=	35	if longoccb==	666	;
replace mo_long=	36	if longoccb==	56	;
replace mo_long=	36	if longoccb==	90	;
replace mo_long=	37	if longoccb==	73	;
replace mo_long=	43	if longoccb==	130	;
replace mo_long=	44	if longoccb==	132	;
replace mo_long=	45	if longoccb==	145	;
replace mo_long=	47	if longoccb==	152	;
replace mo_long=	48	if longoccb==	135	;
replace mo_long=	53	if longoccb==	136	;
replace mo_long=	55	if longoccb==	140	;
replace mo_long=	55	if longoccb==	141	;
replace mo_long=	56	if longoccb==	143	;
replace mo_long=	57	if longoccb==	146	;
replace mo_long=	59	if longoccb==	133	;
replace mo_long=	59	if longoccb==	134	;
replace mo_long=	59	if longoccb==	142	;
replace mo_long=	59	if longoccb==	144	;
replace mo_long=	59	if longoccb==	150	;
replace mo_long=	59	if longoccb==	151	;
replace mo_long=	59	if longoccb==	153	;
replace mo_long=	64	if longoccb==	100	;
replace mo_long=	64	if longoccb==	104	;
replace mo_long=	64	if longoccb==	106	;
replace mo_long=	64	if longoccb==	110	;
replace mo_long=	64	if longoccb==	111	;
replace mo_long=	65	if longoccb==	70	;
replace mo_long=	65	if longoccb==	122	;
replace mo_long=	66	if longoccb==	120	;
replace mo_long=	67	if longoccb==	123	;
replace mo_long=	68	if longoccb==	121	;
replace mo_long=	68	if longoccb==	124	;
replace mo_long=	69	if longoccb==	170	;
replace mo_long=	73	if longoccb==	172	;
replace mo_long=	74	if longoccb==	171	;
replace mo_long=	75	if longoccb==	174	;
replace mo_long=	76	if longoccb==	176	;
replace mo_long=	77	if longoccb==	160	;
replace mo_long=	78	if longoccb==	161	;
replace mo_long=	79	if longoccb==	164	;
replace mo_long=	83	if longoccb==	165	;
replace mo_long=	84	if longoccb==	306	;
replace mo_long=	85	if longoccb==	301	;
replace mo_long=	86	if longoccb==	325	;
replace mo_long=	87	if longoccb==	304	;
replace mo_long=	88	if longoccb==	312	;
replace mo_long=	89	if longoccb==	300	;
replace mo_long=	89	if longoccb==	326	;
replace mo_long=	95	if longoccb==	313	;
replace mo_long=	96	if longoccb==	305	;
replace mo_long=	97	if longoccb==	303	;
replace mo_long=	98	if longoccb==	322	;
replace mo_long=	99	if longoccb==	315	;
replace mo_long=	99	if longoccb==	361	;
replace mo_long=	103	if longoccb==	316	;
replace mo_long=	103	if longoccb==	362	;
replace mo_long=	104	if longoccb==	314	;
replace mo_long=	104	if longoccb==	323	;
replace mo_long=	105	if longoccb==	320	;
replace mo_long=	105	if longoccb==	321	;
replace mo_long=	105	if longoccb==	324	;
replace mo_long=	106	if longoccb==	311	;
replace mo_long=	154	if longoccb==	220	;
replace mo_long=	155	if longoccb==	230	;
replace mo_long=	156	if longoccb==	231	;
replace mo_long=	157	if longoccb==	232	;
replace mo_long=	158	if longoccb==	233	;
replace mo_long=	159	if longoccb==	234	;
replace mo_long=	159	if longoccb==	254	;
replace mo_long=	159	if longoccb==	255	;
replace mo_long=	163	if longoccb==	200	;
replace mo_long=	164	if longoccb==	243	;
replace mo_long=	165	if longoccb==	240	;
replace mo_long=	166	if longoccb==	180	;
replace mo_long=	166	if longoccb==	181	;
replace mo_long=	167	if longoccb==	182	;
replace mo_long=	168	if longoccb==	183	;
replace mo_long=	169	if longoccb==	186	;
replace mo_long=	173	if longoccb==	184	;
replace mo_long=	174	if longoccb==	201	;
replace mo_long=	175	if longoccb==	462	;
replace mo_long=	176	if longoccb==	204	;
replace mo_long=	176	if longoccb==	205	;
replace mo_long=	176	if longoccb==	206	;
replace mo_long=	178	if longoccb==	210	;
replace mo_long=	179	if longoccb==	211	;
replace mo_long=	183	if longoccb==	285	;
replace mo_long=	184	if longoccb==	284	;
replace mo_long=	185	if longoccb==	263	;
replace mo_long=	186	if longoccb==	275	;
replace mo_long=	187	if longoccb==	270	;
replace mo_long=	187	if longoccb==	271	;
replace mo_long=	188	if longoccb==	260	;
replace mo_long=	189	if longoccb==	291	;
replace mo_long=	193	if longoccb==	274	;
replace mo_long=	194	if longoccb==	276	;
replace mo_long=	194	if longoccb==	286	;
replace mo_long=	195	if longoccb==	281	;
replace mo_long=	195	if longoccb==	283	;
replace mo_long=	195	if longoccb==	292	;
replace mo_long=	198	if longoccb==	280	;
replace mo_long=	199	if longoccb==	272	;
replace mo_long=	199	if longoccb==	752	;
replace mo_long=	203	if longoccb==	330	;
replace mo_long=	204	if longoccb==	331	;
replace mo_long=	205	if longoccb==	351	;
replace mo_long=	206	if longoccb==	332	;
replace mo_long=	207	if longoccb==	350	;
replace mo_long=	208	if longoccb==	340	;
replace mo_long=	208	if longoccb==	353	;
replace mo_long=	208	if longoccb==	354	;
replace mo_long=	214	if longoccb==	155	;
replace mo_long=	214	if longoccb==	196	;
replace mo_long=	217	if longoccb==	154	;
replace mo_long=	218	if longoccb==	131	;
replace mo_long=	218	if longoccb==	156	;
replace mo_long=	223	if longoccb==	190	;
replace mo_long=	223	if longoccb==	191	;
replace mo_long=	224	if longoccb==	192	;
replace mo_long=	225	if longoccb==	193	;
replace mo_long=	226	if longoccb==	903	;
replace mo_long=	227	if longoccb==	904	;
replace mo_long=	228	if longoccb==	290	;
replace mo_long=	228	if longoccb==	296	;
replace mo_long=	229	if longoccb==	101	;
replace mo_long=	229	if longoccb==	102	;
replace mo_long=	233	if longoccb==	790	;
replace mo_long=	234	if longoccb==	214	;
replace mo_long=	234	if longoccb==	215	;
replace mo_long=	235	if longoccb==	194	;
replace mo_long=	243	if longoccb==	470	;
replace mo_long=	243	if longoccb==	471	;
replace mo_long=	253	if longoccb==	481	;
replace mo_long=	254	if longoccb==	81	;
replace mo_long=	254	if longoccb==	492	;
replace mo_long=	255	if longoccb==	482	;
replace mo_long=	256	if longoccb==	480	;
replace mo_long=	258	if longoccb==	493	;
replace mo_long=	274	if longoccb==	474	;
replace mo_long=	274	if longoccb==	475	;
replace mo_long=	274	if longoccb==	484	;
replace mo_long=	274	if longoccb==	485	;
replace mo_long=	274	if longoccb==	494	;
replace mo_long=	274	if longoccb==	496	;
replace mo_long=	275	if longoccb==	476	;
replace mo_long=	276	if longoccb==	472	;
replace mo_long=	276	if longoccb==	513	;
replace mo_long=	277	if longoccb==	495	;
replace mo_long=	283	if longoccb==	490	;
replace mo_long=	303	if longoccb==	500	;
replace mo_long=	308	if longoccb==	580	;
replace mo_long=	313	if longoccb==	570	;
replace mo_long=	315	if longoccb==	582	;
replace mo_long=	315	if longoccb==	583	;
replace mo_long=	316	if longoccb==	523	;
replace mo_long=	316	if longoccb==	531	;
replace mo_long=	316	if longoccb==	534	;
replace mo_long=	317	if longoccb==	530	;
replace mo_long=	318	if longoccb==	483	;
replace mo_long=	318	if longoccb==	541	;
replace mo_long=	319	if longoccb==	540	;
replace mo_long=	326	if longoccb==	521	;
replace mo_long=	326	if longoccb==	535	;
replace mo_long=	328	if longoccb==	536	;
replace mo_long=	329	if longoccb==	244	;
replace mo_long=	329	if longoccb==	532	;
replace mo_long=	335	if longoccb==	526	;
replace mo_long=	336	if longoccb==	520	;
replace mo_long=	336	if longoccb==	542	;
replace mo_long=	337	if longoccb==	512	;
replace mo_long=	338	if longoccb==	514	;
replace mo_long=	344	if longoccb==	511	;
replace mo_long=	346	if longoccb==	556	;
replace mo_long=	347	if longoccb==	590	;
replace mo_long=	348	if longoccb==	501	;
replace mo_long=	348	if longoccb==	502	;
replace mo_long=	349	if longoccb==	503	;
replace mo_long=	354	if longoccb==	554	;
replace mo_long=	355	if longoccb==	555	;
replace mo_long=	356	if longoccb==	585	;
replace mo_long=	357	if longoccb==	551	;
replace mo_long=	359	if longoccb==	552	;
replace mo_long=	364	if longoccb==	550	;
replace mo_long=	364	if longoccb==	561	;
replace mo_long=	365	if longoccb==	515	;
replace mo_long=	365	if longoccb==	562	;
replace mo_long=	366	if longoccb==	553	;
replace mo_long=	368	if longoccb==	563	;
replace mo_long=	373	if longoccb==	16	;
replace mo_long=	373	if longoccb==	560	;
replace mo_long=	375	if longoccb==	54	;
replace mo_long=	375	if longoccb==	584	;
replace mo_long=	376	if longoccb==	524	;
replace mo_long=	376	if longoccb==	533	;
replace mo_long=	377	if longoccb==	525	;
replace mo_long=	378	if longoccb==	510	;
replace mo_long=	379	if longoccb==	586	;
replace mo_long=	383	if longoccb==	516	;
replace mo_long=	384	if longoccb==	591	;
replace mo_long=	385	if longoccb==	581	;
replace mo_long=	386	if longoccb==	592	;
replace mo_long=	389	if longoccb==	522	;
replace mo_long=	389	if longoccb==	593	;
replace mo_long=	405	if longoccb==	384	;
replace mo_long=	405	if longoccb==	423	;
replace mo_long=	415	if longoccb==	373	;
replace mo_long=	417	if longoccb==	372	;
replace mo_long=	417	if longoccb==	374	;
replace mo_long=	417	if longoccb==	375	;
replace mo_long=	418	if longoccb==	371	;
replace mo_long=	418	if longoccb==	382	;
replace mo_long=	418	if longoccb==	385	;
replace mo_long=	418	if longoccb==	386	;
replace mo_long=	418	if longoccb==	391	;
replace mo_long=	423	if longoccb==	370	;
replace mo_long=	423	if longoccb==	380	;
replace mo_long=	423	if longoccb==	383	;
replace mo_long=	425	if longoccb==	394	;
replace mo_long=	426	if longoccb==	392	;
replace mo_long=	427	if longoccb==	390	;
replace mo_long=	427	if longoccb==	395	;
replace mo_long=	434	if longoccb==	404	;
replace mo_long=	435	if longoccb==	411	;
replace mo_long=	436	if longoccb==	400	;
replace mo_long=	436	if longoccb==	401	;
replace mo_long=	436	if longoccb==	402	;
replace mo_long=	439	if longoccb==	405	;
replace mo_long=	443	if longoccb==	406	;
replace mo_long=	443	if longoccb==	412	;
replace mo_long=	443	if longoccb==	413	;
replace mo_long=	444	if longoccb==	403	;
replace mo_long=	444	if longoccb==	414	;
replace mo_long=	444	if longoccb==	416	;
replace mo_long=	445	if longoccb==	364	;
replace mo_long=	446	if longoccb==	365	;
replace mo_long=	447	if longoccb==	360	;
replace mo_long=	447	if longoccb==	461	;
replace mo_long=	448	if longoccb==	420	;
replace mo_long=	453	if longoccb==	422	;
replace mo_long=	454	if longoccb==	975	;
replace mo_long=	455	if longoccb==	424	;
replace mo_long=	456	if longoccb==	432	;
replace mo_long=	457	if longoccb==	450	;
replace mo_long=	458	if longoccb==	451	;
replace mo_long=	458	if longoccb==	452	;
replace mo_long=	459	if longoccb==	440	;
replace mo_long=	459	if longoccb==	443	;
replace mo_long=	461	if longoccb==	454	;
replace mo_long=	462	if longoccb==	442	;
replace mo_long=	463	if longoccb==	455	;
replace mo_long=	463	if longoccb==	941	;
replace mo_long=	464	if longoccb==	453	;
replace mo_long=	465	if longoccb==	202	;
replace mo_long=	468	if longoccb==	460	;
replace mo_long=	468	if longoccb==	464	;
replace mo_long=	469	if longoccb==	363	;
replace mo_long=	469	if longoccb==	415	;
replace mo_long=	469	if longoccb==	446	;
replace mo_long=	469	if longoccb==	465	;
replace mo_long=	473	if longoccb==	21	;
replace mo_long=	475	if longoccb==	20	;
replace mo_long=	475	if longoccb==	602	;
replace mo_long=	479	if longoccb==	434	;
replace mo_long=	479	if longoccb==	605	;
replace mo_long=	485	if longoccb==	421	;
replace mo_long=	486	if longoccb==	425	;
replace mo_long=	487	if longoccb==	435	;
replace mo_long=	488	if longoccb==	604	;
replace mo_long=	489	if longoccb==	601	;
replace mo_long=	496	if longoccb==	600	;
replace mo_long=	496	if longoccb==	612	;
replace mo_long=	496	if longoccb==	613	;
replace mo_long=	498	if longoccb==	610	;
replace mo_long=	498	if longoccb==	611	;
replace mo_long=	503	if longoccb==	700	;
replace mo_long=	505	if longoccb==	720	;
replace mo_long=	507	if longoccb==	721	;
replace mo_long=	508	if longoccb==	714	;
replace mo_long=	509	if longoccb==	724	;
replace mo_long=	514	if longoccb==	715	;
replace mo_long=	514	if longoccb==	716	;
replace mo_long=	516	if longoccb==	722	;
replace mo_long=	516	if longoccb==	726	;
replace mo_long=	518	if longoccb==	733	;
replace mo_long=	519	if longoccb==	735	;
replace mo_long=	523	if longoccb==	710	;
replace mo_long=	523	if longoccb==	712	;
replace mo_long=	525	if longoccb==	701	;
replace mo_long=	526	if longoccb==	732	;
replace mo_long=	527	if longoccb==	702	;
replace mo_long=	527	if longoccb==	742	;
replace mo_long=	533	if longoccb==	703	;
replace mo_long=	533	if longoccb==	705	;
replace mo_long=	533	if longoccb==	711	;
replace mo_long=	534	if longoccb==	731	;
replace mo_long=	535	if longoccb==	743	;
replace mo_long=	535	if longoccb==	875	;
replace mo_long=	536	if longoccb==	754	;
replace mo_long=	539	if longoccb==	730	;
replace mo_long=	543	if longoccb==	670	;
replace mo_long=	544	if longoccb==	736	;
replace mo_long=	549	if longoccb==	734	;
replace mo_long=	549	if longoccb==	755	;
replace mo_long=	549	if longoccb==	756	;
replace mo_long=	549	if longoccb==	762	;
replace mo_long=	558	if longoccb==	620	;
replace mo_long=	563	if longoccb==	622	;
replace mo_long=	563	if longoccb==	624	;
replace mo_long=	567	if longoccb==	623	;
replace mo_long=	573	if longoccb==	633	;
replace mo_long=	575	if longoccb==	635	;
replace mo_long=	575	if longoccb==	713	;
replace mo_long=	577	if longoccb==	704	;
replace mo_long=	577	if longoccb==	741	;
replace mo_long=	577	if longoccb==	760	;
replace mo_long=	579	if longoccb==	642	;
replace mo_long=	583	if longoccb==	643	;
replace mo_long=	584	if longoccb==	646	;
replace mo_long=	585	if longoccb==	644	;
replace mo_long=	588	if longoccb==	625	;
replace mo_long=	589	if longoccb==	636	;
replace mo_long=	593	if longoccb==	640	;
replace mo_long=	593	if longoccb==	672	;
replace mo_long=	594	if longoccb==	630	;
replace mo_long=	595	if longoccb==	651	;
replace mo_long=	596	if longoccb==	652	;
replace mo_long=	597	if longoccb==	650	;
replace mo_long=	597	if longoccb==	653	;
replace mo_long=	597	if longoccb==	774	;
replace mo_long=	598	if longoccb==	682	;
replace mo_long=	599	if longoccb==	631	;
replace mo_long=	599	if longoccb==	671	;
replace mo_long=	599	if longoccb==	676	;
replace mo_long=	614	if longoccb==	680	;
replace mo_long=	614	if longoccb==	692	;
replace mo_long=	615	if longoccb==	683	;
replace mo_long=	616	if longoccb==	684	;
replace mo_long=	617	if longoccb==	691	;
replace mo_long=	617	if longoccb==	694	;
replace mo_long=	628	if longoccb==	770	;
replace mo_long=	634	if longoccb==	813	;
replace mo_long=	637	if longoccb==	803	;
replace mo_long=	643	if longoccb==	621	;
replace mo_long=	644	if longoccb==	821	;
replace mo_long=	645	if longoccb==	806	;
replace mo_long=	645	if longoccb==	844	;
replace mo_long=	645	if longoccb==	852	;
replace mo_long=	646	if longoccb==	816	;
replace mo_long=	649	if longoccb==	891	;
replace mo_long=	657	if longoccb==	850	;
replace mo_long=	658	if longoccb==	851	;
replace mo_long=	666	if longoccb==	835	;
replace mo_long=	668	if longoccb==	845	;
replace mo_long=	669	if longoccb==	833	;
replace mo_long=	675	if longoccb==	892	;
replace mo_long=	677	if longoccb==	352	;
replace mo_long=	678	if longoccb==	341	;
replace mo_long=	678	if longoccb==	876	;
replace mo_long=	679	if longoccb==	823	;
replace mo_long=	684	if longoccb==	812	;
replace mo_long=	686	if longoccb==	781	;
replace mo_long=	687	if longoccb==	780	;
replace mo_long=	688	if longoccb==	784	;
replace mo_long=	694	if longoccb==	862	;
replace mo_long=	695	if longoccb==	860	;
replace mo_long=	696	if longoccb==	861	;
replace mo_long=	699	if longoccb==	863	;
replace mo_long=	703	if longoccb==	801	;
replace mo_long=	703	if longoccb==	802	;
replace mo_long=	706	if longoccb==	795	;
replace mo_long=	707	if longoccb==	794	;
replace mo_long=	708	if longoccb==	796	;
replace mo_long=	709	if longoccb==	800	;
replace mo_long=	713	if longoccb==	793	;
replace mo_long=	719	if longoccb==	810	;
replace mo_long=	723	if longoccb==	820	;
replace mo_long=	724	if longoccb==	815	;
replace mo_long=	726	if longoccb==	822	;
replace mo_long=	727	if longoccb==	853	;
replace mo_long=	729	if longoccb==	854	;
replace mo_long=	733	if longoccb==	855	;
replace mo_long=	734	if longoccb==	824	;
replace mo_long=	736	if longoccb==	825	;
replace mo_long=	736	if longoccb==	826	;
replace mo_long=	738	if longoccb==	842	;
replace mo_long=	739	if longoccb==	841	;
replace mo_long=	743	if longoccb==	840	;
replace mo_long=	744	if longoccb==	832	;
replace mo_long=	745	if longoccb==	834	;
replace mo_long=	747	if longoccb==	831	;
replace mo_long=	748	if longoccb==	830	;
replace mo_long=	749	if longoccb==	836	;
replace mo_long=	749	if longoccb==	846	;
replace mo_long=	753	if longoccb==	885	;
replace mo_long=	754	if longoccb==	880	;
replace mo_long=	755	if longoccb==	792	;
replace mo_long=	755	if longoccb==	843	;
replace mo_long=	755	if longoccb==	872	;
replace mo_long=	756	if longoccb==	865	;
replace mo_long=	757	if longoccb==	864	;
replace mo_long=	759	if longoccb==	881	;
replace mo_long=	763	if longoccb==	783	;
replace mo_long=	764	if longoccb==	886	;
replace mo_long=	765	if longoccb==	893	;
replace mo_long=	766	if longoccb==	804	;
replace mo_long=	766	if longoccb==	873	;
replace mo_long=	769	if longoccb==	785	;
replace mo_long=	769	if longoccb==	871	;
replace mo_long=	773	if longoccb==	441	;
replace mo_long=	774	if longoccb==	883	;
replace mo_long=	779	if longoccb==	884	;
replace mo_long=	779	if longoccb==	890	;
replace mo_long=	779	if longoccb==	894	;
replace mo_long=	779	if longoccb==	896	;
replace mo_long=	783	if longoccb==	814	;
replace mo_long=	785	if longoccb==	771	;
replace mo_long=	785	if longoccb==	772	;
replace mo_long=	785	if longoccb==	773	;
replace mo_long=	785	if longoccb==	775	;
replace mo_long=	799	if longoccb==	874	;
replace mo_long=	803	if longoccb==	900	;
replace mo_long=	804	if longoccb==	751	;
replace mo_long=	804	if longoccb==	913	;
replace mo_long=	804	if longoccb==	960	;
replace mo_long=	808	if longoccb==	912	;
replace mo_long=	809	if longoccb==	911	;
replace mo_long=	809	if longoccb==	914	;
replace mo_long=	809	if longoccb==	915	;
replace mo_long=	813	if longoccb==	935	;
replace mo_long=	823	if longoccb==	924	;
replace mo_long=	824	if longoccb==	920	;
replace mo_long=	824	if longoccb==	926	;
replace mo_long=	825	if longoccb==	923	;
replace mo_long=	829	if longoccb==	930	;
replace mo_long=	829	if longoccb==	931	;
replace mo_long=	829	if longoccb==	933	;
replace mo_long=	834	if longoccb==	934	;
replace mo_long=	844	if longoccb==	632	;
replace mo_long=	848	if longoccb==	951	;
replace mo_long=	848	if longoccb==	956	;
replace mo_long=	853	if longoccb==	952	;
replace mo_long=	859	if longoccb==	965	;
replace mo_long=	859	if longoccb==	973	;
replace mo_long=	865	if longoccb==	761	;
replace mo_long=	866	if longoccb==	660	;
replace mo_long=	869	if longoccb==	626	;
replace mo_long=	869	if longoccb==	673	;
replace mo_long=	869	if longoccb==	693	;
replace mo_long=	873	if longoccb==	895	;
replace mo_long=	875	if longoccb==	972	;
replace mo_long=	876	if longoccb==	950	;
replace mo_long=	876	if longoccb==	974	;
replace mo_long=	878	if longoccb==	963	;
replace mo_long=	883	if longoccb==	942	;
replace mo_long=	885	if longoccb==	936	;
replace mo_long=	887	if longoccb==	961	;
replace mo_long=	888	if longoccb==	964	;
replace mo_long=	889	if longoccb==	674	;
replace mo_long=	889	if longoccb==	675	;
replace mo_long=	889	if longoccb==	962	;
replace mo_long=	905	if longoccb==	980	;
replace mo_long=	905	if longoccb==	981	;
replace mo_long=	905	if longoccb==	982	;
replace mo_long=	905	if longoccb==	983	;


/*Assign 2000 Meyer-Osborne codes that have O*NET data to comparable 2000 Census codes that did not have O*NET data */
/*NOTE: because O*NET was converted from SOC to 2000 Census, if MO does not have a code for both 1980 AND 2000 Census, these will be missing because they do not have a 2000 census code*/

replace mo_long=	779	if longoccb==	822	;	/* wood lathe, routing, and planing machine operators n.e.c. --> machine operators n.e.c.	*/
replace mo_long=	427	if longoccb==	373	;	/* supervisors of guards --> assign to protective services n.e.c.	*/
replace mo_long=	779	if longoccb==	855	;	/* other woodworking machine operators n.e.c. --> machine operators n.e.c.	*/


generate occ_name=".";

/*Osborne and Meyer Occupational Category Names*/
replace occ_name=	"Legislators "	if mo_occ==	3	;
replace occ_name=	"Chief executives and public administrators "	if mo_occ==	4	;
replace occ_name=	"Financial managers "	if mo_occ==	7	;
replace occ_name=	"Human resources and labor relations managers "	if mo_occ==	8	;
replace occ_name=	"Managers and specialists in marketing, advertising, and public relations "	if mo_occ==	13	;
replace occ_name=	"Managers in education and related fields "	if mo_occ==	14	;
replace occ_name=	"Managers of medicine and health occupations "	if mo_occ==	15	;
replace occ_name=	"Postmasters and mail superintendents "	if mo_occ==	16	;
replace occ_name=	"Managers of food-serving and lodging establishments "	if mo_occ==	17	;
replace occ_name=	"Managers of properties and real estate "	if mo_occ==	18	;
replace occ_name=	"Funeral directors "	if mo_occ==	19	;
replace occ_name=	"Managers of service organizations, n.e.c. "	if mo_occ==	21	;
replace occ_name=	"Managers and administrators, n.e.c. "	if mo_occ==	22	;
replace occ_name=	"Accountants and auditors "	if mo_occ==	23	;
replace occ_name=	"Insurance underwriters "	if mo_occ==	24	;
replace occ_name=	"Other financial specialists "	if mo_occ==	25	;
replace occ_name=	"Management analysts "	if mo_occ==	26	;
replace occ_name=	"Personnel, HR, training, and labor relations specialists "	if mo_occ==	27	;
replace occ_name=	"Purchasing agents and buyers, of farm products "	if mo_occ==	28	;
replace occ_name=	"Buyers, wholesale and retail trade "	if mo_occ==	29	;
replace occ_name=	"Purchasing managers, agents and buyers, n.e.c. "	if mo_occ==	33	;
replace occ_name=	"Business and promotion agents "	if mo_occ==	34	;
replace occ_name=	"Construction inspectors "	if mo_occ==	35	;
replace occ_name=	"Inspectors and compliance officers, outside construction "	if mo_occ==	36	;
replace occ_name=	"Management support occupations "	if mo_occ==	37	;
replace occ_name=	"Architects "	if mo_occ==	43	;
replace occ_name=	"Aerospace engineer "	if mo_occ==	44	;
replace occ_name=	"Metallurgical and materials engineers, variously phrased "	if mo_occ==	45	;
replace occ_name=	"Petroleum, mining, and geological engineers "	if mo_occ==	47	;
replace occ_name=	"Chemical engineers "	if mo_occ==	48	;
replace occ_name=	"Civil engineers "	if mo_occ==	53	;
replace occ_name=	"Electrical engineer "	if mo_occ==	55	;
replace occ_name=	"Industrial engineers "	if mo_occ==	56	;
replace occ_name=	"Mechanical engineers "	if mo_occ==	57	;
replace occ_name=	"Engineers not elsewhere classified "	if mo_occ==	59	;
replace occ_name=	"Computer systems analysts and computer scientists "	if mo_occ==	64	;
replace occ_name=	"Operations and systems researchers and analysts "	if mo_occ==	65	;
replace occ_name=	"Actuaries "	if mo_occ==	66	;
replace occ_name=	"Statisticians "	if mo_occ==	67	;
replace occ_name=	"Mathematicians and mathematical scientists "	if mo_occ==	68	;
replace occ_name=	"Physicists and astronomers "	if mo_occ==	69	;
replace occ_name=	"Chemists "	if mo_occ==	73	;
replace occ_name=	"Atmospheric and space scientists "	if mo_occ==	74	;
replace occ_name=	"Geologists "	if mo_occ==	75	;
replace occ_name=	"Physical scientists, n.e.c. "	if mo_occ==	76	;
replace occ_name=	"Agricultural and food scientists "	if mo_occ==	77	;
replace occ_name=	"Biological scientists "	if mo_occ==	78	;
replace occ_name=	"Foresters and conservation scientists "	if mo_occ==	79	;
replace occ_name=	"Medical scientists "	if mo_occ==	83	;
replace occ_name=	"Physicians "	if mo_occ==	84	;
replace occ_name=	"Dentists "	if mo_occ==	85	;
replace occ_name=	"Veterinarians "	if mo_occ==	86	;
replace occ_name=	"Optometrists "	if mo_occ==	87	;
replace occ_name=	"Podiatrists "	if mo_occ==	88	;
replace occ_name=	"Other health and therapy "	if mo_occ==	89	;
replace occ_name=	"Registered nurses "	if mo_occ==	95	;
replace occ_name=	"Pharmacists "	if mo_occ==	96	;
replace occ_name=	"Dietitians and nutritionists "	if mo_occ==	97	;
replace occ_name=	"Respiratory therapists "	if mo_occ==	98	;
replace occ_name=	"Occupational therapists "	if mo_occ==	99	;
replace occ_name=	"Physical therapists "	if mo_occ==	103	;
replace occ_name=	"Speech therapists "	if mo_occ==	104	;
replace occ_name=	"Therapists, n.e.c. "	if mo_occ==	105	;
replace occ_name=	"Physicians' assistants "	if mo_occ==	106	;
replace occ_name=	"Earth, environmental, and marine science instructors "	if mo_occ==	113	;
replace occ_name=	"Biological science instructors "	if mo_occ==	114	;
replace occ_name=	"Chemistry instructors "	if mo_occ==	115	;
replace occ_name=	"Physics instructors "	if mo_occ==	116	;
replace occ_name=	"Psychology instructors "	if mo_occ==	118	;
replace occ_name=	"Economics instructors "	if mo_occ==	119	;
replace occ_name=	"History instructors "	if mo_occ==	123	;
replace occ_name=	"Sociology instructors "	if mo_occ==	125	;
replace occ_name=	"Engineering instructors "	if mo_occ==	127	;
replace occ_name=	"Math instructors "	if mo_occ==	128	;
replace occ_name=	"Education instructors "	if mo_occ==	139	;
replace occ_name=	"Law instructors "	if mo_occ==	145	;
replace occ_name=	"Theology instructors "	if mo_occ==	147	;
replace occ_name=	"Home economics instructors "	if mo_occ==	149	;
replace occ_name=	"Humanities instructors, nec "	if mo_occ==	150	;
replace occ_name=	"Subject instructors, college "	if mo_occ==	154	;
replace occ_name=	"Kindergarten and earlier school teachers "	if mo_occ==	155	;
replace occ_name=	"Primary school teachers "	if mo_occ==	156	;
replace occ_name=	"Secondary school teachers "	if mo_occ==	157	;
replace occ_name=	"Special education teachers "	if mo_occ==	158	;
replace occ_name=	"Teachers , n.e.c. "	if mo_occ==	159	;
replace occ_name=	"Vocational and educational counselors "	if mo_occ==	163	;
replace occ_name=	"Librarians "	if mo_occ==	164	;
replace occ_name=	"Archivists and curators "	if mo_occ==	165	;
replace occ_name=	"Economists, market researchers, and survey researchers "	if mo_occ==	166	;
replace occ_name=	"Psychologists "	if mo_occ==	167	;
replace occ_name=	"Sociologists "	if mo_occ==	168	;
replace occ_name=	"Social scientists, n.e.c. "	if mo_occ==	169	;
replace occ_name=	"Urban and regional planners "	if mo_occ==	173	;
replace occ_name=	"Social workers "	if mo_occ==	174	;
replace occ_name=	"Recreation workers "	if mo_occ==	175	;
replace occ_name=	"Clergy and religious workers "	if mo_occ==	176	;
replace occ_name=	"Lawyers "	if mo_occ==	178	;
replace occ_name=	"Judges "	if mo_occ==	179	;
replace occ_name=	"Writers and authors "	if mo_occ==	183	;
replace occ_name=	"Technical writers "	if mo_occ==	184	;
replace occ_name=	"Designers "	if mo_occ==	185	;
replace occ_name=	"Musician or composer "	if mo_occ==	186	;
replace occ_name=	"Actors, directors, producers "	if mo_occ==	187	;
replace occ_name=	"Art makers: painters, sculptors, craft- artists, and print-makers "	if mo_occ==	188	;
replace occ_name=	"Photographers "	if mo_occ==	189	;
replace occ_name=	"Dancers "	if mo_occ==	193	;
replace occ_name=	"Art/entertainment performers and related "	if mo_occ==	194	;
replace occ_name=	"Editors and reporters "	if mo_occ==	195	;
replace occ_name=	"Announcers "	if mo_occ==	198	;
replace occ_name=	"Athletes, sports instructors, and officials "	if mo_occ==	199	;
replace occ_name=	"Professionals, n.e.c. "	if mo_occ==	200	;
replace occ_name=	"Clinical laboratory technologies and technicians "	if mo_occ==	203	;
replace occ_name=	"Dental hygienists "	if mo_occ==	204	;
replace occ_name=	"Health record tech specialists "	if mo_occ==	205	;
replace occ_name=	"Radiologic tech specialists "	if mo_occ==	206	;
replace occ_name=	"Licensed practical nurses "	if mo_occ==	207	;
replace occ_name=	"Health technologists and technicians, n.e.c. "	if mo_occ==	208	;
replace occ_name=	"Electrical and electronic (engineering) technicians "	if mo_occ==	213	;
replace occ_name=	"Engineering technicians, n.e.c. "	if mo_occ==	214	;
replace occ_name=	"Mechanical engineering technicians "	if mo_occ==	215	;
replace occ_name=	"Drafters "	if mo_occ==	217	;
replace occ_name=	"Surveyors, cartographers, mapping scientists and technicians "	if mo_occ==	218	;
replace occ_name=	"Biological technicians "	if mo_occ==	223	;
replace occ_name=	"Chemical technicians "	if mo_occ==	224	;
replace occ_name=	"Other science technicians "	if mo_occ==	225	;
replace occ_name=	"Airplane pilots and navigators "	if mo_occ==	226	;
replace occ_name=	"Air traffic controllers "	if mo_occ==	227	;
replace occ_name=	"Broadcast equipment operators "	if mo_occ==	228	;
replace occ_name=	"Computer software developers "	if mo_occ==	229	;
replace occ_name=	"Programmers of numerically controlled machine tools "	if mo_occ==	233	;
replace occ_name=	"Legal assistants and paralegals "	if mo_occ==	234	;
replace occ_name=	"Technicians, n.e.c. "	if mo_occ==	235	;
replace occ_name=	"Sales supervisors and proprietors "	if mo_occ==	243	;
replace occ_name=	"Insurance sales occupations "	if mo_occ==	253	;
replace occ_name=	"Real estate sales occupations "	if mo_occ==	254	;
replace occ_name=	"Financial services sales occupations "	if mo_occ==	255	;
replace occ_name=	"Advertising and related sales jobs "	if mo_occ==	256	;
replace occ_name=	"Sales engineers "	if mo_occ==	258	;
replace occ_name=	"Salespersons, n.e.c. "	if mo_occ==	274	;
replace occ_name=	"Retail sales clerks "	if mo_occ==	275	;
replace occ_name=	"Cashiers "	if mo_occ==	276	;
replace occ_name=	"Door-to-door sales, street sales, and news vendors "	if mo_occ==	277	;
replace occ_name=	"Sales demonstrators / promoters / models "	if mo_occ==	283	;
replace occ_name=	"Office supervisors "	if mo_occ==	303	;
replace occ_name=	"Computer and peripheral equipment operators "	if mo_occ==	308	;
replace occ_name=	"Secretaries "	if mo_occ==	313	;
replace occ_name=	"Stenographers "	if mo_occ==	314	;
replace occ_name=	"Typists "	if mo_occ==	315	;
replace occ_name=	"Interviewers, enumerators, and surveyors "	if mo_occ==	316	;
replace occ_name=	"Hotel clerks "	if mo_occ==	317	;
replace occ_name=	"Transportation ticket and reservation agents "	if mo_occ==	318	;
replace occ_name=	"Receptionists "	if mo_occ==	319	;
replace occ_name=	"Information clerks, nec "	if mo_occ==	323	;
replace occ_name=	"Correspondence and order clerks "	if mo_occ==	326	;
replace occ_name=	"Human resources clerks, except payroll and timekeeping "	if mo_occ==	328	;
replace occ_name=	"Library assistants "	if mo_occ==	329	;
replace occ_name=	"File clerks "	if mo_occ==	335	;
replace occ_name=	"Records clerks "	if mo_occ==	336	;
replace occ_name=	"Bookkeepers and accounting and auditing clerks "	if mo_occ==	337	;
replace occ_name=	"Payroll and timekeeping clerks "	if mo_occ==	338	;
replace occ_name=	"Cost and rate clerks (financial records processing) "	if mo_occ==	343	;
replace occ_name=	"Billing clerks and related financial records processing "	if mo_occ==	344	;
replace occ_name=	"Duplication machine operators / office machine operators "	if mo_occ==	345	;
replace occ_name=	"Mail and paper handlers "	if mo_occ==	346	;
replace occ_name=	"Office machine operators, n.e.c. "	if mo_occ==	347	;
replace occ_name=	"Telephone operators "	if mo_occ==	348	;
replace occ_name=	"Other telecom operators "	if mo_occ==	349	;
replace occ_name=	"Postal clerks, excluding mail carriers "	if mo_occ==	354	;
replace occ_name=	"Mail carriers for postal service "	if mo_occ==	355	;
replace occ_name=	"Mail clerks, outside of post office "	if mo_occ==	356	;
replace occ_name=	"Messengers "	if mo_occ==	357	;
replace occ_name=	"Dispatchers "	if mo_occ==	359	;
replace occ_name=	"Inspectors, n.e.c. "	if mo_occ==	361	;
replace occ_name=	"Shipping and receiving clerks "	if mo_occ==	364	;
replace occ_name=	"Stock and inventory clerks "	if mo_occ==	365	;
replace occ_name=	"Meter readers "	if mo_occ==	366	;
replace occ_name=	"Weighers, measurers, and checkers "	if mo_occ==	368	;
replace occ_name=	"Material recording, scheduling, production, planning, and expediting clerks "	if mo_occ==	373	;
replace occ_name=	"Insurance adjusters, examiners, and investigators "	if mo_occ==	375	;
replace occ_name=	"Customer service reps, investigators and adjusters, except insurance "	if mo_occ==	376	;
replace occ_name=	"Eligibility clerks for government programs; social welfare "	if mo_occ==	377	;
replace occ_name=	"Bill and account collectors "	if mo_occ==	378	;
replace occ_name=	"General office clerks "	if mo_occ==	379	;
replace occ_name=	"Bank tellers "	if mo_occ==	383	;
replace occ_name=	"Proofreaders "	if mo_occ==	384	;
replace occ_name=	"Data entry keyers "	if mo_occ==	385	;
replace occ_name=	"Statistical clerks "	if mo_occ==	386	;
replace occ_name=	"Teacher's aides "	if mo_occ==	387	;
replace occ_name=	"Administrative support jobs, n.e.c. "	if mo_occ==	389	;
replace occ_name=	"Housekeepers, maids, butlers, stewards, and lodging quarters cleaners "	if mo_occ==	405	;
replace occ_name=	"Private household cleaners and servants "	if mo_occ==	407	;
replace occ_name=	"Supervisors of guards "	if mo_occ==	415	;
replace occ_name=	"Fire fighting, prevention, and inspection "	if mo_occ==	417	;
replace occ_name=	"Police, detectives, and private investigators "	if mo_occ==	418	;
replace occ_name=	"Other law enforcement: sheriffs, bailiffs, correctional institution officers "	if mo_occ==	423	;
replace occ_name=	"Crossing guards and bridge tenders "	if mo_occ==	425	;
replace occ_name=	"Guards, watchmen, doorkeepers "	if mo_occ==	426	;
replace occ_name=	"Protective services, n.e.c. "	if mo_occ==	427	;
replace occ_name=	"Bartenders "	if mo_occ==	434	;
replace occ_name=	"Waiter/waitress "	if mo_occ==	435	;
replace occ_name=	"Cooks, variously defined "	if mo_occ==	436	;
replace occ_name=	"Food counter and fountain workers "	if mo_occ==	438	;
replace occ_name=	"Kitchen workers "	if mo_occ==	439	;
replace occ_name=	"Waiter's assistant "	if mo_occ==	443	;
replace occ_name=	"Misc food prep workers "	if mo_occ==	444	;
replace occ_name=	"Dental assistants "	if mo_occ==	445	;
replace occ_name=	"Health aides, except nursing "	if mo_occ==	446	;
replace occ_name=	"Nursing aides, orderlies, and attendants "	if mo_occ==	447	;
replace occ_name=	"Supervisors of cleaning and building service "	if mo_occ==	448	;
replace occ_name=	"Janitors "	if mo_occ==	453	;
replace occ_name=	"Elevator operators "	if mo_occ==	454	;
replace occ_name=	"Pest control occupations "	if mo_occ==	455	;
replace occ_name=	"Supervisors of personal service jobs, n.e.c. "	if mo_occ==	456	;
replace occ_name=	"Barbers "	if mo_occ==	457	;
replace occ_name=	"Hairdressers and cosmetologists "	if mo_occ==	458	;
replace occ_name=	"Recreation facility attendants "	if mo_occ==	459	;
replace occ_name=	"Guides "	if mo_occ==	461	;
replace occ_name=	"Ushers "	if mo_occ==	462	;
replace occ_name=	"Public transportation attendants and inspectors "	if mo_occ==	463	;
replace occ_name=	"Baggage porters "	if mo_occ==	464	;
replace occ_name=	"Welfare service aides "	if mo_occ==	465	;
replace occ_name=	"Child care workers "	if mo_occ==	468	;
replace occ_name=	"Personal service occupations, nec "	if mo_occ==	469	;
replace occ_name=	"Farmers (owners and tenants) "	if mo_occ==	473	;
replace occ_name=	"Horticultural specialty farmers "	if mo_occ==	474	;
replace occ_name=	"Farm managers, except for horticultural farms "	if mo_occ==	475	;
replace occ_name=	"Managers of horticultural specialty farms "	if mo_occ==	476	;
replace occ_name=	"Farm workers "	if mo_occ==	479	;
replace occ_name=	"Marine life cultivation workers "	if mo_occ==	483	;
replace occ_name=	"Nursery farming workers "	if mo_occ==	484	;
replace occ_name=	"Supervisors of agricultural occupations "	if mo_occ==	485	;
replace occ_name=	"Gardeners and groundskeepers "	if mo_occ==	486	;
replace occ_name=	"Animal caretakers except on farms "	if mo_occ==	487	;
replace occ_name=	"Graders and sorters of agricultural products "	if mo_occ==	488	;
replace occ_name=	"Inspectors of agricultural products "	if mo_occ==	489	;
replace occ_name=	"Timber, logging, and forestry workers "	if mo_occ==	496	;
replace occ_name=	"Fishers, hunters, and kindred "	if mo_occ==	498	;
replace occ_name=	"Supervisors of mechanics and repairers "	if mo_occ==	503	;
replace occ_name=	"Automobile mechanics "	if mo_occ==	505	;
replace occ_name=	"Bus, truck, and stationary engine mechanics "	if mo_occ==	507	;
replace occ_name=	"Aircraft mechanics "	if mo_occ==	508	;
replace occ_name=	"Small engine repairers "	if mo_occ==	509	;
replace occ_name=	"Auto body repairers "	if mo_occ==	514	;
replace occ_name=	"Heavy equipment and farm equipment mechanics "	if mo_occ==	516	;
replace occ_name=	"Industrial machinery repairers "	if mo_occ==	518	;
replace occ_name=	"Machinery maintenance occupations "	if mo_occ==	519	;
replace occ_name=	"Repairers of industrial electrical equipment "	if mo_occ==	523	;
replace occ_name=	"Repairers of data processing equipment "	if mo_occ==	525	;
replace occ_name=	"Repairers of household appliances and power tools "	if mo_occ==	526	;
replace occ_name=	"Telecom and line installers and repairers "	if mo_occ==	527	;
replace occ_name=	"Repairers of electrical equipment, n.e.c. "	if mo_occ==	533	;
replace occ_name=	"Heating, air conditioning, and refigeration mechanics "	if mo_occ==	534	;
replace occ_name=	"Precision makers, repairers, and smiths "	if mo_occ==	535	;
replace occ_name=	"Locksmiths and safe repairers "	if mo_occ==	536	;
replace occ_name=	"Office machine repairers and mechanics "	if mo_occ==	538	;
replace occ_name=	"Repairers of mechanical controls and valves "	if mo_occ==	539	;
replace occ_name=	"Elevator installers and repairers "	if mo_occ==	543	;
replace occ_name=	"Millwrights "	if mo_occ==	544	;
replace occ_name=	"Mechanics and repairers, n.e.c. "	if mo_occ==	549	;
replace occ_name=	"Supervisors of construction work "	if mo_occ==	558	;
replace occ_name=	"Masons, tilers, and carpet installers "	if mo_occ==	563	;
replace occ_name=	"Carpenters "	if mo_occ==	567	;
replace occ_name=	"Drywall installers "	if mo_occ==	573	;
replace occ_name=	"Electricians "	if mo_occ==	575	;
replace occ_name=	"Electric power installers and repairers "	if mo_occ==	577	;
replace occ_name=	"Painters, construction and maintenance "	if mo_occ==	579	;
replace occ_name=	"Paperhangers "	if mo_occ==	583	;
replace occ_name=	"Plasterers "	if mo_occ==	584	;
replace occ_name=	"Plumbers, pipe fitters, and steamfitters "	if mo_occ==	585	;
replace occ_name=	"Concrete and cement workers "	if mo_occ==	588	;
replace occ_name=	"Glaziers "	if mo_occ==	589	;
replace occ_name=	"Insulation workers "	if mo_occ==	593	;
replace occ_name=	"Paving, surfacing, and tamping equipment operators "	if mo_occ==	594	;
replace occ_name=	"Roofers and slaters "	if mo_occ==	595	;
replace occ_name=	"Sheet metal duct installers "	if mo_occ==	596	;
replace occ_name=	"Structural metal workers "	if mo_occ==	597	;
replace occ_name=	"Drillers of earth "	if mo_occ==	598	;
replace occ_name=	"Construction trades, n.e.c. "	if mo_occ==	599	;
replace occ_name=	"Drillers of oil wells "	if mo_occ==	614	;
replace occ_name=	"Explosives workers "	if mo_occ==	615	;
replace occ_name=	"Miners "	if mo_occ==	616	;
replace occ_name=	"Other mining occupations "	if mo_occ==	617	;
replace occ_name=	"Production supervisors or foremen "	if mo_occ==	628	;
replace occ_name=	"Tool and die makers and die setters "	if mo_occ==	634	;
replace occ_name=	"Machinists "	if mo_occ==	637	;
replace occ_name=	"Boilermakers "	if mo_occ==	643	;
replace occ_name=	"Precision grinders and filers "	if mo_occ==	644	;
replace occ_name=	"Patternmakers and model makers "	if mo_occ==	645	;
replace occ_name=	"Lay-out workers "	if mo_occ==	646	;
replace occ_name=	"Engravers "	if mo_occ==	649	;
replace occ_name=	"Tinsmiths, coppersmiths, and sheet metal workers "	if mo_occ==	653	;
replace occ_name=	"Cabinetmakers and bench carpenters "	if mo_occ==	657	;
replace occ_name=	"Furniture and wood finishers "	if mo_occ==	658	;
replace occ_name=	"Other precision woodworkers "	if mo_occ==	659	;
replace occ_name=	"Dressmakers and seamstresses "	if mo_occ==	666	;
replace occ_name=	"Tailors "	if mo_occ==	667	;
replace occ_name=	"Upholsterers "	if mo_occ==	668	;
replace occ_name=	"Shoe repairers "	if mo_occ==	669	;
replace occ_name=	"Other precision apparel and fabric workers "	if mo_occ==	674	;
replace occ_name=	"Hand molders and shapers, except jewelers "	if mo_occ==	675	;
replace occ_name=	"Optical goods workers "	if mo_occ==	677	;
replace occ_name=	"Dental laboratory and medical appliance technicians "	if mo_occ==	678	;
replace occ_name=	"Bookbinders "	if mo_occ==	679	;
replace occ_name=	"Other precision and craft workers "	if mo_occ==	684	;
replace occ_name=	"Butchers and meat cutters "	if mo_occ==	686	;
replace occ_name=	"Bakers "	if mo_occ==	687	;
replace occ_name=	"Batch food makers "	if mo_occ==	688	;
replace occ_name=	"Adjusters and calibrators "	if mo_occ==	693	;
replace occ_name=	"Water and sewage treatment plant operators "	if mo_occ==	694	;
replace occ_name=	"Power plant operators "	if mo_occ==	695	;
replace occ_name=	"Plant and system operators, stationary engineers "	if mo_occ==	696	;
replace occ_name=	"Other plant and system operators "	if mo_occ==	699	;
replace occ_name=	"Lathe, milling, and turning machine operatives "	if mo_occ==	703	;
replace occ_name=	"Punching and stamping press operatives "	if mo_occ==	706	;
replace occ_name=	"Rollers, roll hands, and finishers of metal "	if mo_occ==	707	;
replace occ_name=	"Drilling and boring machine operators "	if mo_occ==	708	;
replace occ_name=	"Grinding, abrading, buffing, and polishing workers "	if mo_occ==	709	;
replace occ_name=	"Forge and hammer operators "	if mo_occ==	713	;
replace occ_name=	"Fabricating machine operators, n.e.c. "	if mo_occ==	717	;
replace occ_name=	"Molders, and casting machine operators "	if mo_occ==	719	;
replace occ_name=	"Metal platers "	if mo_occ==	723	;
replace occ_name=	"Heat treating equipment operators "	if mo_occ==	724	;
replace occ_name=	"Wood lathe, routing, and planing machine operators "	if mo_occ==	726	;
replace occ_name=	"Sawing machine operators and sawyers "	if mo_occ==	727	;
replace occ_name=	"Shaping and joining machine operator (woodworking) "	if mo_occ==	728	;
replace occ_name=	"Nail and tacking machine operators (woodworking) "	if mo_occ==	729	;
replace occ_name=	"Other woodworking machine operators "	if mo_occ==	733	;
replace occ_name=	"Printing machine operators, n.e.c. "	if mo_occ==	734	;
replace occ_name=	"Photoengravers and lithographers "	if mo_occ==	735	;
replace occ_name=	"Typesetters and compositors "	if mo_occ==	736	;
replace occ_name=	"Winding and twisting textile/apparel operatives "	if mo_occ==	738	;
replace occ_name=	"Knitters, loopers, and toppers textile operatives "	if mo_occ==	739	;
replace occ_name=	"Textile cutting machine operators "	if mo_occ==	743	;
replace occ_name=	"Textile sewing machine operators "	if mo_occ==	744	;
replace occ_name=	"Shoemaking machine operators "	if mo_occ==	745	;
replace occ_name=	"Pressing machine operators (clothing) "	if mo_occ==	747	;
replace occ_name=	"Laundry workers "	if mo_occ==	748	;
replace occ_name=	"Misc textile machine operators "	if mo_occ==	749	;
replace occ_name=	"Cementing and gluing maching operators "	if mo_occ==	753	;
replace occ_name=	"Packers, fillers, and wrappers "	if mo_occ==	754	;
replace occ_name=	"Extruding and forming machine operators "	if mo_occ==	755	;
replace occ_name=	"Mixing and blending machine operatives "	if mo_occ==	756	;
replace occ_name=	"Separating, filtering, and clarifying machine operators "	if mo_occ==	757	;
replace occ_name=	"Painting machine operators "	if mo_occ==	759	;
replace occ_name=	"Roasting and baking machine operators (food) "	if mo_occ==	763	;
replace occ_name=	"Washing, cleaning, and pickling machine operators "	if mo_occ==	764	;
replace occ_name=	"Paper folding machine operators "	if mo_occ==	765	;
replace occ_name=	"Furnace, kiln, and oven operators, apart from food "	if mo_occ==	766	;
replace occ_name=	"Crushing and grinding machine operators "	if mo_occ==	768	;
replace occ_name=	"Slicing and cutting machine operators "	if mo_occ==	769	;
replace occ_name=	"Motion picture projectionists "	if mo_occ==	773	;
replace occ_name=	"Photographic process workers "	if mo_occ==	774	;
replace occ_name=	"Machine operators, n.e.c. "	if mo_occ==	779	;
replace occ_name=	"Welders and metal cutters "	if mo_occ==	783	;
replace occ_name=	"Solderers "	if mo_occ==	784	;
replace occ_name=	"Assemblers of electrical equipment "	if mo_occ==	785	;
replace occ_name=	"Hand painting, coating, and decorating occupations "	if mo_occ==	789	;
replace occ_name=	"Production checkers and inspectors "	if mo_occ==	796	;
replace occ_name=	"Graders and sorters in manufacturing "	if mo_occ==	799	;
replace occ_name=	"Supervisors of motor vehicle transportation "	if mo_occ==	803	;
replace occ_name=	"Truck, delivery, and tractor drivers "	if mo_occ==	804	;
replace occ_name=	"Bus drivers "	if mo_occ==	808	;
replace occ_name=	"Taxi cab drivers and chauffeurs "	if mo_occ==	809	;
replace occ_name=	"Parking lot attendants "	if mo_occ==	813	;
replace occ_name=	"Railroad conductors and yardmasters "	if mo_occ==	823	;
replace occ_name=	"Locomotive operators (engineers and firemen) "	if mo_occ==	824	;
replace occ_name=	"Railroad brake, coupler, and switch operators "	if mo_occ==	825	;
replace occ_name=	"Ship crews and marine engineers "	if mo_occ==	829	;
replace occ_name=	"Water transport infrastructure tenders and crossing guards "	if mo_occ==	834	;
replace occ_name=	"Operating engineers of construction equipment "	if mo_occ==	844	;
replace occ_name=	"Crane, derrick, winch, and hoist operators "	if mo_occ==	848	;
replace occ_name=	"Excavating and loading machine operators "	if mo_occ==	853	;
replace occ_name=	"Misc material moving occupations "	if mo_occ==	859	;
replace occ_name=	"Helpers, constructions "	if mo_occ==	865	;
replace occ_name=	"Helpers, surveyors "	if mo_occ==	866	;
replace occ_name=	"Construction laborers "	if mo_occ==	869	;
replace occ_name=	"Production helpers "	if mo_occ==	873	;
replace occ_name=	"Garbage and recyclable material collectors "	if mo_occ==	875	;
replace occ_name=	"Materials movers: stevedores and longshore workers "	if mo_occ==	876	;
replace occ_name=	"Stock handlers "	if mo_occ==	877	;
replace occ_name=	"Machine feeders and offbearers "	if mo_occ==	878	;
replace occ_name=	"Freight, stock, and materials handlers "	if mo_occ==	883	;
replace occ_name=	"Garage and service station related occupations "	if mo_occ==	885	;
replace occ_name=	"Vehicle washers and equipment cleaners "	if mo_occ==	887	;
replace occ_name=	"Packers and packagers by hand "	if mo_occ==	888	;
replace occ_name=	"Laborers outside construction "	if mo_occ==	889	;
replace occ_name=	"Military "	if mo_occ==	905	;


sort hhidpn year;

drop if hhidpn==.;

label var   mo_occ "Three-digit Meyer & Osborne Occupational Code";
label var   occ_name "Meyer & Osborne Standard Job Title";
label var mo_long "Three-digit Meyer & Osborne Occupational Code for LHJ";


/*Code Industry for Current Job*/

recode rcurrind rcurrindb (999=0) (998=0) (997=0); /*recoding 999=0 (DK,NA,RF), 998=0 (DK ind), 997=0 (Other)*/
by hhidpn (year): carryforward rcurrind if (work==1), gen (rcurrind2);
by hhidpn (year): carryforward rcurrindb if (work==1), gen (rcurrindb2);

drop rcurrind;
rename rcurrind2 rcurrind;
label var rcurrind "3-digit 1980 Census Industry Code";

drop rcurrindb;
rename rcurrindb2 rcurrindb;
label var rcurrindb "3-digit 2000 Census Industry Code";

gen farm=0 if rcurrind!=. | rcurrindb!=.; /*AGRICULTURE, FORESTRY, FISHING, AND HUNTING*/
replace farm=1 if rcurrind>=10 & rcurrind<=31;
replace farm=1 if rcurrindb>=17 & rcurrindb<=29;

gen mine=0 if rcurrind!=. | rcurrindb!=.; /*MINING*/
replace mine=1 if rcurrind>=40 & rcurrind<=50;
replace mine=1 if rcurrindb>=37 & rcurrindb<=49;

gen construct=0 if rcurrind!=. | rcurrindb!=.; /*CONSTRUCTION*/
replace construct=1 if rcurrind==60;
replace construct=1 if rcurrindb==77;

gen utilities=0 if rcurrind!=. | rcurrindb!=.; /*UTILITIES*/
replace utilities=1 if rcurrind>=460 & rcurrind<=472;
replace utilities=1 if rcurrindb>=57 & rcurrindb<=69;

gen manf=0 if rcurrind!=. | rcurrindb!=.; /*MANUFACTURING*/
replace manf=1 if rcurrind>=100 & rcurrind<=392;
replace manf=1 if rcurrindb>=107 & rcurrindb<=399;

gen wtrade=0 if rcurrind!=. | rcurrindb!=.; /*WHOLESALE TRADE*/
replace wtrade=1 if rcurrind>=500 & rcurrind<=571;
replace wtrade=1 if rcurrindb>=407 & rcurrindb<=459;

gen rtrade=0 if rcurrind!=. | rcurrindb!=.; /*RETAIL TRADE*/
replace rtrade=1 if rcurrind>=580 & rcurrind<=691;
replace rtrade=1 if rcurrindb>=467 & rcurrindb<=579;

gen transport=0 if rcurrind!=. | rcurrindb!=.; /*TRANSPORTATION AND WAREHOUSING*/
replace transport=1 if rcurrind>=400 & rcurrind<=432;
replace transport=1 if rcurrindb>=607 & rcurrindb<=639;

gen info=0 if rcurrind!=. | rcurrindb!=.; /*COMMUNICATIONS AND INFORMATION*/
replace info=1 if rcurrind>=440 & rcurrind<=442;
replace info=1 if rcurrindb>=647 & rcurrindb<=649;
replace info=1 if rcurrindb>=667 & rcurrindb<=679;

gen fire=0 if rcurrind!=. | rcurrindb!=.; /*FINANCE, INSURANCE, AND REAL ESTATE*/
replace fire=1 if rcurrind>=700 & rcurrind<=712;
replace fire=1 if rcurrindb>=687 & rcurrindb<=719;

gen brserve=0 if rcurrind!=. | rcurrindb!=.; /*BUSINESS AND REPAIR SERVICES*/
replace brserve=1 if rcurrind>=721 & rcurrind<=760;
replace brserve=1 if rcurrindb>=737 & rcurrindb<=739;
replace brserve=1 if rcurrindb==747;
replace brserve=1 if rcurrindb==749;
replace brserve=1 if rcurrindb==757;
replace brserve=1 if rcurrindb==759;
replace brserve=1 if rcurrindb==769;
replace brserve=1 if rcurrindb==768;
replace brserve=1 if rcurrindb==778;
replace brserve=1 if rcurrindb==877;
replace brserve=1 if rcurrindb==879;
replace brserve=1 if rcurrindb==887;
replace brserve=1 if rcurrindb==888;

gen pserve=0 if rcurrind!=. | rcurrindb!=.; /*PERSONAL SERVICES*/
replace pserve=1 if rcurrind>=761 & rcurrind<=791;
replace pserve=1 if rcurrindb>=866 & rcurrindb<=869;
replace pserve=1 if rcurrindb>=897 & rcurrindb<=899;
replace pserve=1 if rcurrindb>=907 & rcurrindb<=909;
replace pserve=1 if rcurrindb==767;
replace pserve=1 if rcurrindb==878;
replace pserve=1 if rcurrindb==889;
replace pserve=1 if rcurrindb==929;

gen entertain=0 if rcurrind!=. | rcurrindb!=.; /*ENTERTAINMENT AND RECREATION SERVICES*/
replace entertain=1 if rcurrind>=800 & rcurrind<=802;
replace entertain=1 if rcurrindb==856;
replace entertain=1 if rcurrindb==858;
replace entertain=1 if rcurrindb==859;
replace entertain=1 if rcurrindb==657;
replace entertain=1 if rcurrindb==659;

gen profserve=0 if rcurrind!=. | rcurrindb!=.; /*PROFESSIONAL AND RELATED SERVICES*/
replace profserve=1 if rcurrind>=812 & rcurrind<=892;
replace profserve=1 if rcurrindb>=786 & rcurrindb<=789;
replace profserve=1 if rcurrindb>=797 & rcurrindb<=799;
replace profserve=1 if rcurrindb>=807 & rcurrindb<=809;
replace profserve=1 if rcurrindb>=817 & rcurrindb<=819;
replace profserve=1 if rcurrindb>=727 & rcurrindb<=729;
replace profserve=1 if rcurrindb>=837 & rcurrindb<=839;
replace profserve=1 if rcurrindb>=916 & rcurrindb<=919;
replace profserve=1 if rcurrindb==748;
replace profserve=1 if rcurrindb==677;
replace profserve=1 if rcurrindb==829;
replace profserve=1 if rcurrindb==827;
replace profserve=1 if rcurrindb==746;
replace profserve=1 if rcurrindb==777;
replace profserve=1 if rcurrindb==758;
replace profserve=1 if rcurrindb==779;
replace profserve=1 if rcurrindb==847;
replace profserve=1 if rcurrindb==857;

gen pubadmin=0 if rcurrind!=. | rcurrindb!=.; /*PUBLIC ADMINISTRATION*/
replace pubadmin=1 if rcurrind>=900 & rcurrind<=932;
replace pubadmin=1 if rcurrindb>=937 & rcurrindb<=959;

/*Industry Dummies (Using Manf, Public Admin, Construction, and FIRE from above in addition to dummies below*/
gen agrimine=0 if rcurrind!=. | rcurrindb!=.; /*Base category: agriculture, forestry, fishing, hunting, and mining*/
replace agrimine=1 if farm==1;
replace agrimine=1 if mine==1;

gen miserve=0 if rcurrind!=. | rcurrindb!=.; /*Misc. Services*/
replace miserve=1 if brserve==1;
replace miserve=1 if pserve==1;
replace miserve=1 if entertain==1;
replace miserve=1 if profserve==1;

gen trade=0 if rcurrind!=. | rcurrindb!=.;
replace trade=1 if wtrade==1;
replace trade=1 if rtrade==1;

gen pubservices=0 if rcurrind!=. | rcurrindb!=.;
replace pubservices=1 if utilities==1;
replace pubservices=1 if info==1;
replace pubservices=1 if transport==1;

/*Industry dummies for LHJ*/

gen lfarm=0 if longind!=. | longindb!=.; /*AGRICULTURE, FORESTRY, FISHING, AND HUNTING*/
replace lfarm=1 if longind>=10 & longind<=31;
replace lfarm=1 if longindb>=17 & longindb<=29;

gen lmine=0 if longind!=. | longindb!=.; /*MINING*/
replace lmine=1 if longind>=40 & longind<=50;
replace lmine=1 if longindb>=37 & longindb<=49;

gen lconstruct=0 if longind!=. | longindb!=.; /*CONSTRUCTION*/
replace lconstruct=1 if longind==60;
replace lconstruct=1 if longindb==77;

gen lutilities=0 if longind!=. | longindb!=.; /*UTILITIES*/
replace lutilities=1 if longind>=460 & longind<=472;
replace lutilities=1 if longindb>=57 & longindb<=69;

gen lmanf=0 if longind!=. | longindb!=.; /*MANUFACTURING*/
replace lmanf=1 if longind>=100 & longind<=392;
replace lmanf=1 if longindb>=107 & longindb<=399;

gen lwtrade=0 if longind!=. | longindb!=.; /*WHOLESALE TRADE*/
replace lwtrade=1 if longind>=500 & longind<=571;
replace lwtrade=1 if longindb>=407 & longindb<=459;

gen lrtrade=0 if longind!=. | longindb!=.; /*RETAIL TRADE*/
replace lrtrade=1 if longind>=580 & longind<=691;
replace lrtrade=1 if longindb>=467 & longindb<=579;

gen ltransport=0 if longind!=. | longindb!=.; /*TRANSPORTATION AND WAREHOUSING*/
replace ltransport=1 if longind>=400 & longind<=432;
replace ltransport=1 if longindb>=607 & longindb<=639;

gen linfo=0 if longind!=. | longindb!=.; /*COMMUNICATIONS AND INFORMATION*/
replace linfo=1 if longind>=440 & longind<=442;
replace linfo=1 if longindb>=647 & longindb<=649;
replace linfo=1 if longindb>=667 & longindb<=679;

gen lfire=0 if longind!=. | longindb!=.; /*FINANCE, INSURANCE, AND REAL ESTATE*/
replace lfire=1 if longind>=700 & longind<=712;
replace lfire=1 if longindb>=687 & longindb<=719;

gen lbrserve=0 if longind!=. | longindb!=.; /*BUSINESS AND REPAIR SERVICES*/
replace lbrserve=1 if longind>=721 & longind<=760;
replace lbrserve=1 if longindb>=737 & longindb<=739;
replace lbrserve=1 if longindb==747;
replace lbrserve=1 if longindb==749;
replace lbrserve=1 if longindb==757;
replace lbrserve=1 if longindb==759;
replace lbrserve=1 if longindb==769;
replace lbrserve=1 if longindb==768;
replace lbrserve=1 if longindb==778;
replace lbrserve=1 if longindb==877;
replace lbrserve=1 if longindb==879;
replace lbrserve=1 if longindb==887;
replace lbrserve=1 if longindb==888;

gen lpserve=0 if longind!=. | longindb!=.; /*PERSONAL SERVICES*/
replace lpserve=1 if longind>=761 & longind<=791;
replace lpserve=1 if longindb>=866 & longindb<=869;
replace lpserve=1 if longindb>=897 & longindb<=899;
replace lpserve=1 if longindb>=907 & longindb<=909;
replace lpserve=1 if longindb==767;
replace lpserve=1 if longindb==878;
replace lpserve=1 if longindb==889;
replace lpserve=1 if longindb==929;

gen lentertain=0 if longind!=. | longindb!=.; /*ENTERTAINMENT AND RECREATION SERVICES*/
replace lentertain=1 if longind>=800 & longind<=802;
replace lentertain=1 if longindb==856;
replace lentertain=1 if longindb==858;
replace lentertain=1 if longindb==859;
replace lentertain=1 if longindb==657;
replace lentertain=1 if longindb==659;

gen lprofserve=0 if longind!=. | longindb!=.; /*PROFESSIONAL AND RELATED SERVICES*/
replace lprofserve=1 if longind>=812 & longind<=892;
replace lprofserve=1 if longindb>=786 & longindb<=789;
replace lprofserve=1 if longindb>=797 & longindb<=799;
replace lprofserve=1 if longindb>=807 & longindb<=809;
replace lprofserve=1 if longindb>=817 & longindb<=819;
replace lprofserve=1 if longindb>=727 & longindb<=729;
replace lprofserve=1 if longindb>=837 & longindb<=839;
replace lprofserve=1 if longindb>=916 & longindb<=919;
replace lprofserve=1 if longindb==748;
replace lprofserve=1 if longindb==677;
replace lprofserve=1 if longindb==829;
replace lprofserve=1 if longindb==827;
replace lprofserve=1 if longindb==746;
replace lprofserve=1 if longindb==777;
replace lprofserve=1 if longindb==758;
replace lprofserve=1 if longindb==779;
replace lprofserve=1 if longindb==847;
replace lprofserve=1 if longindb==857;

gen lpubadmin=0 if longind!=. | longindb!=.; /*PUBLIC ADMINISTRATION*/
replace lpubadmin=1 if longind>=900 & longind<=932;
replace lpubadmin=1 if longindb>=937 & longindb<=959;

/*Industry Dummies (Using lmanf, Public Admin, lconstruction, and lfire from above in addition to dummies below*/
gen lagrimine=0 if longind!=. | longindb!=.; /*Base category: agriculture, forestry, fishing, hunting, and mining*/
replace lagrimine=1 if lfarm==1;
replace lagrimine=1 if lmine==1;

gen lmiserve=0 if longind!=. | longindb!=.; /*Misc. Services*/
replace lmiserve=1 if lbrserve==1;
replace lmiserve=1 if lpserve==1;
replace lmiserve=1 if lentertain==1;
replace lmiserve=1 if lprofserve==1;

gen ltrade=0 if longind!=. | longindb!=.;
replace ltrade=1 if lwtrade==1;
replace ltrade=1 if lrtrade==1;

gen lpubservices=0 if longind!=. | longindb!=.;
replace lpubservices=1 if lutilities==1;
replace lpubservices=1 if linfo==1;
replace lpubservices=1 if ltransport==1;


/*Classification of Occupation Dummies*/

gen wc=0 if mo_occ!=.; /*White Collar*/
replace wc=1 if mo_occ>=43 & mo_occ<=235;
replace wc=1 if mo_occ>=3 & mo_occ<=37;
replace wc=1 if mo_occ>=243 & mo_occ<=283;
replace wc=1 if mo_occ>=303 & mo_occ<=349;
replace wc=1 if mo_occ>=356 & mo_occ<=389;
replace wc=1 if mo_occ==354;
replace wc=1 if mo_occ==475;
replace wc=1 if mo_occ==415;
replace wc=1 if mo_occ==476;

gen bc=0 if mo_occ!=.; /*Blue Collar*/
replace bc=1 if mo_occ>=503 & mo_occ<=527;
replace bc=1 if mo_occ>=534 & mo_occ<=549;
replace bc=1 if mo_occ>=553 & mo_occ<=653;
replace bc=1 if mo_occ>=657 & mo_occ<=659;
replace bc=1 if mo_occ>=666 & mo_occ<=669;
replace bc=1 if mo_occ>=674 & mo_occ<=699;
replace bc=1 if mo_occ>=703 & mo_occ<=714;
replace bc=1 if mo_occ>=723 & mo_occ<=724;
replace bc=1 if mo_occ>=726 & mo_occ<=729;
replace bc=1 if mo_occ>=734 & mo_occ<=736;
replace bc=1 if mo_occ>=738 & mo_occ<=748;
replace bc=1 if mo_occ>=753 & mo_occ<=779;
replace bc=1 if mo_occ>=783 & mo_occ<=800;
replace bc=1 if mo_occ>=803 & mo_occ<=859;
replace bc=1 if mo_occ>=483 & mo_occ<=487;
replace bc=1 if mo_occ>=864 & mo_occ<=889;
replace bc=1 if mo_occ==473;
replace bc=1 if mo_occ==479;
replace bc=1 if mo_occ==488;
replace bc=1 if mo_occ==533;
replace bc=1 if mo_occ==733;
replace bc=1 if mo_occ==749;
replace bc=1 if mo_occ==489;
replace bc=1 if mo_occ==496;
replace bc=1 if mo_occ==719;
replace bc=1 if mo_occ==498;
replace bc=1 if mo_occ==474;
replace bc=1 if mo_occ==717;

gen serve=0 if mo_occ!=.; /*Service Jobs*/
replace serve=1 if mo_occ>=417 & mo_occ<=469;
replace serve=1 if mo_occ==355;
replace serve=1 if mo_occ==405;
replace serve=1 if mo_occ==407;

/*Classification of more specific occ codes*/
gen prof=0 if mo_occ!=.; /*Professional Specialty & Technical Occs*/
replace prof=1 if mo_occ>=43 & mo_occ<=235;

gen manage=0 if mo_occ!=.; /*Executive, Administrative, & Managerial Occs*/
replace manage=1 if mo_occ>=3 & mo_occ<=37;
replace manage=1 if mo_occ==475;
replace manage=1 if mo_occ==476;
replace manage=1 if mo_occ==415;

gen sales=0 if mo_occ!=.; /*Sales Occupations*/
replace sales=1 if mo_occ>=243 & mo_occ<=283;

gen admin=0 if mo_occ!=.; /*Clerical and Administrative Support Occs*/
replace admin=1 if mo_occ>=303 & mo_occ<=349; 
replace admin=1 if mo_occ>=356 & mo_occ<=389;
replace admin=1 if mo_occ==354;

gen mech=0 if mo_occ!=.; /*Mechanical, Construction, and Precision Production*/
replace mech=1 if mo_occ>=503 & mo_occ<=527;
replace mech=1 if mo_occ==533;
replace mech=1 if mo_occ>=534 & mo_occ<=549;
replace mech=1 if mo_occ>=553 & mo_occ<=653;
replace mech=1 if mo_occ>=657 & mo_occ<=659;
replace mech=1 if mo_occ>=666 & mo_occ<=669;
replace mech=1 if mo_occ>=674 & mo_occ<=699;

gen oprtrs=0 if mo_occ!=.; /*Operators, fabricators, and laborers*/
replace oprtrs=1 if mo_occ>=703 & mo_occ<=714;
replace oprtrs=1 if mo_occ>=723 & mo_occ<=724;
replace oprtrs=1 if mo_occ>=726 & mo_occ<=729;
replace oprtrs=1 if mo_occ>=734 & mo_occ<=736;
replace oprtrs=1 if mo_occ>=738 & mo_occ<=748;
replace oprtrs=1 if mo_occ>=753 & mo_occ<=779;
replace oprtrs=1 if mo_occ>=783 & mo_occ<=800;
replace oprtrs=1 if mo_occ>=803 & mo_occ<=859;
replace oprtrs=1 if mo_occ>=483 & mo_occ<=487;
replace oprtrs=1 if mo_occ==489;
replace oprtrs=1 if mo_occ>=864 & mo_occ<=889;
replace oprtrs=1 if mo_occ==733;
replace oprtrs=1 if mo_occ==749;
replace oprtrs=1 if mo_occ==719;
replace oprtrs=1 if mo_occ==717;

gen farmer=0 if mo_occ!=.; /*Farming, Forestry & Fishing Occs*/
replace farmer=1 if mo_occ==473;
replace farmer=1 if mo_occ==479;
replace farmer=1 if mo_occ==488;
replace farmer=1 if mo_occ==496;
replace farmer=1 if mo_occ==498;
replace farmer=1 if mo_occ==474;

/*Classification of Occupation Dummies for LHJ*/

gen lwc=0 if mo_long!=.; /*White Collar*/
replace lwc=1 if mo_long>=43 & mo_long<=235;
replace lwc=1 if mo_long>=3 & mo_long<=37;
replace lwc=1 if mo_long>=243 & mo_long<=283;
replace lwc=1 if mo_long>=303 & mo_long<=349;
replace lwc=1 if mo_long>=356 & mo_long<=389;
replace lwc=1 if mo_long==354;
replace lwc=1 if mo_long==475;
replace lwc=1 if mo_long==415;
replace lwc=1 if mo_long==476;

gen lbc=0 if mo_long!=.; /*Blue Collar*/
replace lbc=1 if mo_long>=503 & mo_long<=527;
replace lbc=1 if mo_long>=534 & mo_long<=549;
replace lbc=1 if mo_long>=553 & mo_long<=653;
replace lbc=1 if mo_long>=657 & mo_long<=659;
replace lbc=1 if mo_long>=666 & mo_long<=669;
replace lbc=1 if mo_long>=674 & mo_long<=699;
replace lbc=1 if mo_long>=703 & mo_long<=714;
replace lbc=1 if mo_long>=723 & mo_long<=724;
replace lbc=1 if mo_long>=726 & mo_long<=729;
replace lbc=1 if mo_long>=734 & mo_long<=736;
replace lbc=1 if mo_long>=738 & mo_long<=748;
replace lbc=1 if mo_long>=753 & mo_long<=779;
replace lbc=1 if mo_long>=783 & mo_long<=800;
replace lbc=1 if mo_long>=803 & mo_long<=859;
replace lbc=1 if mo_long>=483 & mo_long<=487;
replace lbc=1 if mo_long>=864 & mo_long<=889;
replace lbc=1 if mo_long==473;
replace lbc=1 if mo_long==479;
replace lbc=1 if mo_long==488;
replace lbc=1 if mo_long==533;
replace lbc=1 if mo_long==733;
replace lbc=1 if mo_long==749;
replace lbc=1 if mo_long==489;
replace lbc=1 if mo_long==496;
replace lbc=1 if mo_long==719;
replace lbc=1 if mo_long==498;
replace lbc=1 if mo_long==474;
replace lbc=1 if mo_long==717;

gen lserve=0 if mo_long!=.; /*lservice Jobs*/
replace lserve=1 if mo_long>=417 & mo_long<=469;
replace lserve=1 if mo_long==355;
replace lserve=1 if mo_long==405;
replace lserve=1 if mo_long==407;

/*Classification of more specific occ codes*/
gen lprof=0 if mo_long!=.; /*Professional Specialty & Technical Occs*/
replace lprof=1 if mo_long>=43 & mo_long<=235;

gen lmanage=0 if mo_long!=.;  /*Executive, Administrative, & Managerial Occs*/
replace lmanage=1 if mo_long>=3 & mo_long<=37;
replace lmanage=1 if mo_long==475;
replace lmanage=1 if mo_long==476;
replace lmanage=1 if mo_long==415;

gen lsales=0 if mo_long!=.; /*Sales Occupations*/
replace lsales=1 if mo_long>=243 & mo_long<=283;

gen ladmin=0 if mo_long!=.; /*Clerical and Administrative Support Occs*/
replace ladmin=1 if mo_long>=303 & mo_long<=349; 
replace ladmin=1 if mo_long>=356 & mo_long<=389;
replace ladmin=1 if mo_long==354;

gen lmech=0 if mo_long!=.; /*Mechanical, Construction, and Precision Production*/
replace lmech=1 if mo_long>=503 & mo_long<=527;
replace lmech=1 if mo_long==533;
replace lmech=1 if mo_long>=534 & mo_long<=549;
replace lmech=1 if mo_long>=553 & mo_long<=653;
replace lmech=1 if mo_long>=657 & mo_long<=659;
replace lmech=1 if mo_long>=666 & mo_long<=669;
replace lmech=1 if mo_long>=674 & mo_long<=699;

gen loprtrs=0 if mo_long!=.; /*Operators, fabricators, and laborers*/
replace loprtrs=1 if mo_long>=703 & mo_long<=714;
replace loprtrs=1 if mo_long>=723 & mo_long<=724;
replace loprtrs=1 if mo_long>=726 & mo_long<=729;
replace loprtrs=1 if mo_long>=734 & mo_long<=736;
replace loprtrs=1 if mo_long>=738 & mo_long<=748;
replace loprtrs=1 if mo_long>=753 & mo_long<=779;
replace loprtrs=1 if mo_long>=783 & mo_long<=800;
replace loprtrs=1 if mo_long>=803 & mo_long<=859;
replace loprtrs=1 if mo_long>=483 & mo_long<=487;
replace loprtrs=1 if mo_long==489;
replace loprtrs=1 if mo_long>=864 & mo_long<=889;
replace loprtrs=1 if mo_long==733;
replace loprtrs=1 if mo_long==749;
replace loprtrs=1 if mo_long==719;
replace loprtrs=1 if mo_long==717;

gen lfarmer=0 if mo_long!=.; /*Farming, Forestry & Fishing Occs*/
replace lfarmer=1 if mo_long==473;
replace lfarmer=1 if mo_long==479;
replace lfarmer=1 if mo_long==488;
replace lfarmer=1 if mo_long==496;
replace lfarmer=1 if mo_long==498;
replace lfarmer=1 if mo_long==474;

/*OCCUPATION--FATHER'S OCCUPATION*/

/*Occupational Status Dummies*/

gen fwhitecol=0 if mo_father!=.; /*White Collar*/
replace fwhitecol=1 if mo_father>=43 & mo_father<=235;
replace fwhitecol=1 if mo_father>=3 & mo_father<=37;
replace fwhitecol=1 if mo_father>=243 & mo_father<=283;
replace fwhitecol=1 if mo_father>=303 & mo_father<=349;
replace fwhitecol=1 if mo_father>=356 & mo_father<=389;
replace fwhitecol=1 if mo_father==354;
replace fwhitecol=1 if mo_father==475;
replace fwhitecol=1 if mo_father==415;
replace fwhitecol=1 if mo_father==476;

gen fbluecol=0 if mo_father!=.; /*Blue Collar*/
replace fbluecol=1 if mo_father>=503 & mo_father<=527;
replace fbluecol=1 if mo_father>=534 & mo_father<=549;
replace fbluecol=1 if mo_father>=553 & mo_father<=653;
replace fbluecol=1 if mo_father>=657 & mo_father<=659;
replace fbluecol=1 if mo_father>=666 & mo_father<=669;
replace fbluecol=1 if mo_father>=674 & mo_father<=699;
replace fbluecol=1 if mo_father>=703 & mo_father<=714;
replace fbluecol=1 if mo_father>=723 & mo_father<=724;
replace fbluecol=1 if mo_father>=726 & mo_father<=729;
replace fbluecol=1 if mo_father>=734 & mo_father<=736;
replace fbluecol=1 if mo_father>=738 & mo_father<=748;
replace fbluecol=1 if mo_father>=753 & mo_father<=779;
replace fbluecol=1 if mo_father>=783 & mo_father<=800;
replace fbluecol=1 if mo_father>=803 & mo_father<=859;
replace fbluecol=1 if mo_father>=483 & mo_father<=487;
replace fbluecol=1 if mo_father>=864 & mo_father<=889;
replace fbluecol=1 if mo_father==473;
replace fbluecol=1 if mo_father==479;
replace fbluecol=1 if mo_father==488;
replace fbluecol=1 if mo_father==533;
replace fbluecol=1 if mo_father==733;
replace fbluecol=1 if mo_father==749;
replace fbluecol=1 if mo_father==489;
replace fbluecol=1 if mo_father==496;
replace fbluecol=1 if mo_father==719;
replace fbluecol=1 if mo_father==498;
replace fbluecol=1 if mo_father==474;
replace fbluecol=1 if mo_father==717;

gen fservice=0 if mo_father!=.; /*Service Jobs*/
replace fservice=1 if mo_father>=417 & mo_father<=469;
replace fservice=1 if mo_father==355;
replace fservice=1 if mo_father==405;
replace fservice=1 if mo_father==407;


/*Classification of more specific occ codes*/

gen fprofessional=0 if mo_father!=.; /*Professional Specialty & Technical Occs*/
replace fprofessional=1 if mo_father>=43 & mo_father<=235;

gen fmanagerial=0 if mo_father!=.; /*Executive, Administrative, & Managerial Occs*/
replace fmanagerial=1 if mo_father>=3 & mo_father<=37;
replace fmanagerial=1 if mo_father==475;
replace fmanagerial=1 if mo_father==476;
replace fmanagerial=1 if mo_father==415;

gen fsales=0 if mo_father!=.; /*Sales Occupations*/
replace fsales=1 if mo_father>=243 & mo_father<=283;
replace fsales=1 if mo_father==475;

gen fadmin=0 if mo_father!=.; /*Clerical and Administrative Support Occs*/
replace fadmin=1 if mo_father>=303 & mo_father<=349; 
replace fadmin=1 if mo_father>=356 & mo_father<=389;
replace fadmin=1 if mo_father==354;

gen fmech=0 if mo_father!=.; /*Mechanical, Construction, and Precision Production*/
replace fmech=1 if mo_father>=503 & mo_father<=527;
replace fmech=1 if mo_father==533;
replace fmech=1 if mo_father>=534 & mo_father<=549;
replace fmech=1 if mo_father>=553 & mo_father<=653;
replace fmech=1 if mo_father>=657 & mo_father<=659;
replace fmech=1 if mo_father>=666 & mo_father<=669;
replace fmech=1 if mo_father>=674 & mo_father<=699;

gen foperators=0 if mo_father!=.; /*foperators, fabricators, and laborers*/
replace foperators=1 if mo_father>=703 & mo_father<=714;
replace foperators=1 if mo_father>=723 & mo_father<=724;
replace foperators=1 if mo_father>=726 & mo_father<=729;
replace foperators=1 if mo_father>=734 & mo_father<=736;
replace foperators=1 if mo_father>=738 & mo_father<=748;
replace foperators=1 if mo_father>=753 & mo_father<=779;
replace foperators=1 if mo_father>=783 & mo_father<=800;
replace foperators=1 if mo_father>=803 & mo_father<=859;
replace foperators=1 if mo_father>=483 & mo_father<=487;
replace foperators=1 if mo_father==489;
replace foperators=1 if mo_father>=864 & mo_father<=889;
replace foperators=1 if mo_father==733;
replace foperators=1 if mo_father==749;
replace foperators=1 if mo_father==719;
replace foperators=1 if mo_father==717;

gen ffarmers=0 if mo_father!=.; /*Farming, Forestry & Fishing Occs*/
replace ffarmers=1 if mo_father==473;
replace ffarmers=1 if mo_father==479;
replace ffarmers=1 if mo_father==488;
replace ffarmers=1 if mo_father==496;
replace ffarmers=1 if mo_father==498;
replace ffarmers=1 if mo_father==474;

sort hhidpn year;

save "U:\Schmitz_Restricted\HRS_Occ_Panel_FINAL_JHR.dta", replace;

