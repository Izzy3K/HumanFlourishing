********************************************************************************
** Data from CDS-II & TAS 11 **
** Do-file: Initial cleaning for CDSii & TAS11 variables
** Creator: Ashley Palmer
** Date: Created on 11/06/2020
** Updated: 2/23/2021
** Updated: 6/30/2021
********************************************************************************

use "C:\Users\palmera\OneDrive - University of Texas at Arlington\Flourishing Mental Health\Analysis\Data\Data for Flourishing in YA study1\Child02+TAS11\child02-11vars.dta", clear

***EXPLORE DATA TO LEARN ABOUT SAMPLE COMPOSITION***
tab ER32006
tab ER32006, nolabel

***Results of CDS interview 2001 */
tab ER33638 /* 2,542 interviewed sample children in the CDS 2001 */
tab ER33638, nolabel 
rename (ER33638)(cdsiiresult) /*1=eligible child participated*/

**Participation in CDS-II & TAS 2011**
count if cdsiiresult==1 
count if ER34151==1 
rename ER34151 tas11result
count if cdsiiresult==1 & tas11result==1 
/* 1,687 were in both CDS-II & TAS 11 samples */

***CREATE AGE VARIABLES BASED ON DOB AND INTERVIEW DATES***
gen dob = ym(ER33606,ER33605)
format dob %tm
count if dob > tm(1993m12) /*560 youth */
tab dob, miss /* 48 missing DOB */

gen date_ciw2002 = ym(Q23IWYR,Q23IWMTH)
format date_ciw2002 %tm
tab date_ciw2002 
di 2542-2022 
/*2,022 with a child interview date in 2002 or 2003, ages 8+ interviewed*/

count if dob==. & date_ciw2002~=.
gen mage2002 = date_ciw2002-dob
gen  age2002 = floor(mage2002/12)
tab  age2002 

tab date_ciw2002 age2002
di 2022-(183+213+187+180) /*1,259 ages 12+*/

gen tasdate2011 = ym(TA110009,TA110007)    
format tasdate2011 %tm
tab tasdate2011

gen mage2011 = tasdate2011-dob
gen  age2011 = floor(mage2011/12)
tab age2011

count if tasdate2011~=. & date_ciw2002~=. & (age2002>=12 & age2002!=.)
count if tasdate2011~=. & date_ciw2002~=. & (Q23L37E~=0)

gen eligsecL=.
replace eligsecL=0 if date_ciw2002~=. & (Q23L37E==0)
replace eligsecL=1 if date_ciw2002~=. & (Q23L37E~=0)
tab eligsecL

count if eligsecL==1 & tasdate2011~=. /*1090*/
count if eligsecL==1 & tasdate2011==. /*164*/

//GENERATE VARIABLE TO REFLECT CDS INTERVIEW + SEC L ELIGIBILE + TAS2011 INTERVIEW
gen sample=0
replace sample=1 if eligsecL==1 & tasdate2011~=.
tab sample 

rename (ER31996 ER31997 TA111143) (stratum cluster weight)
order weight, after(cluster)

drop ER30000 ER30001 ER30002

****DEMOGRAPHIC VARIABLES 2002*********************

tab ER32000 if sample==1 /* all have values for biological sex */
rename ER32000 (male)
recode male(2=0)
tab male if sample==1
label define sex 0 "female" 1 "male"
label values male sex

tab1 Q23J37A if sample==1
rename (Q23J37A)(grade_02) /*grade in school at time of child interview*/
tab grade_02 if sample==1 
recode grade_02(98/99=.)(0=.) 
tab grade_02 if sample==1 

tab race1_2011
tab race1_2011, nolabel
count if race2_2011~=.
count if race3_2011~=.
drop race2011

gen race=.
replace race=0 if (race1_2011==1 & race2_2011==.) /*White*/
replace race=1 if (race1_2011==2 & race2_2011==.)/*Black, African American, Negro*/
replace race=2 if (race1_2011>=3 & race1_2011~=.)|(race2_2011~=.|race3_2011~=.) /*Other race, including multi-racial identity*/
tab race 
label define race 0 "white" 1 "black or African American" 2 "other racial identity, including multiracial"
label values race race
label variable race "Self-identified race 2011 TAS"

gen agecat_11=.
replace agecat_11=0 if age2011>=20 & age2011<=24
replace agecat_11=1 if age2011>=25 & age2011<=28
tab agecat_11
label define agecat 0 "20-24" 1 "25-28"
label values agecat_11 agecat 

order male race hisp2011, after(persid)
tab1 race hisp2011

****EXAMINE 2002 CDSII Languishing/Flourishing VARIABLES*************************

/* rename variables for L/F subscale items per page 41 of CDS-II user guide*/
rename (Q23L37A Q23L37B Q23L37C)(ewb1_02 ewb2_02 ewb3_02)
rename (Q23L37D Q23L37E Q23L37F Q23L37G Q23L37H)(swb1_02 swb2_02 swb3_02 swb4_02 swb5_02)
rename (Q23L37K Q23L37L Q23L37M Q23L37N)(pwb1_02 pwb2_02 pwb3_02 pwb4_02)
rename (CONFL02)(flscale_02)
histogram flscale_02 if sample==1, normal

tab1 ewb1_02 ewb2_02 ewb3_02 if sample==1 
di 1553-463 /* 1090 were eligible for ACASI section; of these, about 20 replied NA to these questions */

tab1 swb1_02 swb2_02 swb3_02 swb4_02 swb5_02 if sample==1 
/* 1090 were eligible for ACASI section; of these, about 30 replied NA to these questions */

tab1 pwb1_02 pwb2_02 pwb3_02 pwb4_02 if sample==1 
/* 1090 were eligible for Section L (ACASI); of these, about 25 replied NA to these questions */

tab flscale_02 if sample==1 /* 51 (4.7%) coded 99=Not Ascertained -- set to missing*/
recode flscale_02(99=.)
tab flscale_02 if sample==1 /*n=1,039*/
histogram flscale_02 if sample==1, normal
sum flscale_02 if sample==1, d

tab age2002 if sample==1
tab age2011 if sample==1

/* 
******************EXAMINE OTHER CHILDHOOD VARIABLES 2002************************
****************CLOSENESS TO ADULTS, SIBLINGS, AND PEERS************************
/*self-rated closeness to parents, siblings, or other adults */
tab1 Q23H5A Q23H5B Q23H5C Q23H5D Q23H5E Q23H5F Q23H5G Q23H5H if sample==1
foreach var of varlist Q23H5A-Q23H5H {
replace `var'=. if `var'==7
replace `var'=. if `var'==8
replace `var'=. if `var'==9
replace `var'=. if `var'==0
}

tab1 Q23H5A Q23H5B Q23H5C Q23H5D Q23H5E Q23H5F Q23H5G Q23H5H if sample==1
rename (Q23H5A Q23H5B Q23H5C Q23H5D Q23H5E Q23H5F Q23H5G Q23H5H)(closem_2002 closef_2002 closestf_2002 closestm_2002 closefri_2002 closesib_2002 closeteac_2002 closeoth_2002)
tab1 closem_2002 closef_2002 closestf_2002 closestm_2002 closefri_2002 closesib_2002 closeteac_2002 closeoth_2002 if sample==1

foreach var of varlist closem_2002-closeoth_2002 {
gen `var'_bin=.
replace `var'_bin=0 if `var'==1
replace `var'_bin=1 if (`var'>=2 & `var'~=.)
}

label define close1 0 "not very close" 1 "fairly, quite, or extremely close"

foreach var of varlist closem_2002_bin-closeoth_2002_bin {
label values `var' close1
tab1 `var' if sample==1
}

foreach var of varlist closem_2002_bin-closeoth_2002_bin {
tab1 `var' if sample==1
}

foreach var of varlist closem_2002-closeoth_2002 {
gen `var'_bin2=.
replace `var'_bin2=0 if (`var'==1|`var'==2)
replace `var'_bin2=1 if (`var'>=3 & `var'~=.)
}

label define close2 0 "not very or fairly close" 1 "quite close or extremely close"

foreach var of varlist closem_2002_bin2-closeoth_2002_bin2 {
label values `var' close2
tab1 `var' if sample==1
}

/* if youth mentioned other adults (901 did) these variables capture who;
I do not think we need to use these; drop for now */
/*tab1 Q23H6A Q23H6B Q23H6C Q23H6D Q23H6E Q23H6F Q23H6G Q23H6H Q23H6J Q23H6K if sample==1
recode Q23H6A Q23H6B Q23H6C Q23H6D Q23H6E Q23H6F Q23H6G Q23H6H Q23H6J Q23H6K(0=.)
tab1 Q23H6A Q23H6B Q23H6C Q23H6D Q23H6E Q23H6F Q23H6G Q23H6H Q23H6J Q23H6K if sample==1*/
drop Q23H6A Q23H6B Q23H6C Q23H6D Q23H6E Q23H6F Q23H6G Q23H6H Q23H6J Q23H6K

/* FREQUENCY OF BULLIED BY PEERS */
tab1 Q23H1A Q23H1B Q23H1C Q23H1D if sample==1
recode Q23H1A Q23H1B Q23H1C Q23H1D (8/9=.) /* two items had 1 person with missing data */
rename (Q23H1A Q23H1B Q23H1C Q23H1D)(bully1_2002 bully2_2002 bully3_2002 bully4_2002)
tab1 bully1_2002 bully2_2002 bully3_2002 bully4_2002 if sample==1

/* CDS constructed scale which is the mean of 4 items; data for all youth who did not have missing data on all 4 items */
tab BULLY02 if sample==1

**********************RELIGION & SPIRITUALITY*********************
/* download Q23J2...may not use these...drop but may remove this command */
/*0's reflect question was not asked of child so coding as missing; lots of 0's.
tab1 Q23J3 Q23J3A Q23J3B Q23J4 if sample==1
recode Q23J3 Q23J3A Q23J3B Q23J4(8/9=.)(0=.)
tab1 Q23J3 Q23J3A Q23J3B Q23J4 if sample==1 */
drop Q23J3 Q23J3A Q23J3B Q23J4

**************************COMMUNITY INVOLVEMENT*********************************
/* community or group activity involvement */
tab1 Q23K3 Q23K4 Q23K5 Q23K6 Q23K7 if sample==1
recode Q23K3 Q23K4 Q23K5 Q23K6 Q23K7(9=.) /* 5-6 with missing data for items */
tab1 Q23K3 Q23K4 Q23K5 Q23K6 Q23K7 if sample==1
rename (Q23K3 Q23K4 Q23K5 Q23K6 Q23K7)(sports_2002 schgrps_2002 commgrps_2002 volunteer_2002 summprog_2002)
recode sports_2002 schgrps_2002 commgrps_2002 volunteer_2002 summprog_2002 (5=0)
tab1 sports_2002 schgrps_2002 commgrps_2002 volunteer_2002 summprog_2002 if sample==1
label values sports_2002 schgrps_2002 commgrps_2002 volunteer_2002 summprog_2002 noyes

************************PHYSICAL HEALTH & HEALTH BEHAVIORS**********************
/* overall, self-rated health */
tab Q23K8 if sample==1
recode Q23K8 (9=.) /* 7 have missing data */
rename (Q23K8)(health_2002) 
tab health_2002 if sample==1

/* days with nutrition intake of food groups -- Note: 0's = none here */
tab1 Q23K14A Q23K14B Q23K14C Q23K14D Q23K14E Q23K14F Q23K14G if sample==1
recode Q23K14A Q23K14B Q23K14C Q23K14D Q23K14E Q23K14F Q23K14G(9=.)
tab1 Q23K14A Q23K14B Q23K14C Q23K14D Q23K14E Q23K14F Q23K14G if sample==1
rename (Q23K14A Q23K14B Q23K14C Q23K14D Q23K14E Q23K14F Q23K14G)(nutr_dairy nutr_fruit nutr_veg nutr_grain nutr_sweet nutr_meat nutri_prot)
tab1 nutr_dairy nutr_fruit nutr_veg nutr_grain nutr_sweet nutr_meat nutri_prot if sample==1, nolabel

foreach var of varlist nutr_dairy-nutri_prot {
gen `var'days=.
replace `var'days=1 if (`var'>=4 & `var'~=.)
replace `var'days=0 if (`var'<4)
tab1 `var'days if sample==1
}

label define consumption 0 "0-3 days/wk" 1 "consumed 4-7 days/wk"

foreach var of varlist nutr_dairydays-nutri_protdays {
label values `var' consumption
tab1 `var' if sample==1
}

/* days with physical activity -- Note: 0's = none except for minpe_2002, because only those reporting pe were asked that ?*/
tab1 Q23K15 Q23K16 Q23K17 if sample==1
recode Q23K15 Q23K16 Q23K17(9=.)
recode Q23K16(0=.)

rename (Q23K15 Q23K16 Q23K17)(dayspe_02 minpe_02 daysexerc_02)
label define numberwkdays 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7"
label values dayspe_02 daysexerc_02 numberwkdays
tab1 dayspe_02 minpe_02 daysexerc_02 if sample==1, nolabel
tab1 dayspe_02 minpe_02 daysexerc_02 if sample==1

gen minpe_bin=.
replace minpe_bin=0 if(minpe_02==1|minpe_02==2|minpe_02==3)
replace minpe_bin=1 if(minpe_02==4)
label define actlevel 0 "less than 30 minutes" 1 "30 minutes or more"
label values minpe_bin actlevel
tab minpe_bin if sample==1

/* health interference with activities */
tab1 Q23K18 Q23K19 if sample==1
recode Q23K18 Q23K19(9=.)(0=.)
rename (Q23K18 Q23K19)(hlth_misssoc hlth_missschl)
tab1 hlth_misssoc hlth_missschl if sample==1
tab1 hlth_misssoc hlth_missschl if sample==1, nolabel

gen hlthintfr1_02=.
replace hlthintfr1_02=1 if (hlth_misssoc>=3 & hlth_misssoc~=.)
replace hlthintfr1_02=0 if (hlth_misssoc<=2)
tab hlthintfr1_02 if sample==1

gen hlthintfr2_02=.
replace hlthintfr2_02=1 if (hlth_missschl>=3 & hlth_missschl~=.)
replace hlthintfr2_02=0 if (hlth_missschl<=2)
tab hlthintfr2_02 if sample==1
tab hlthintfr1_02 hlthintfr2_02 if sample==1

/* sleep per night */
tab Q23K21 if sample==1
recode Q23K21(98/99=.)
histogram Q23K21 if sample==1, normal
rename (Q23K21)(avgsleep_2002)
tab avgsleep_2002 if sample==1 /* 8 with missing data */

/* BMI */
tab Q24BMI if sample==1
recode Q24BMI(99=.) /* 18 with missing data */
histogram Q24BMI if sample==1, normal
rename (Q24BMI)(bmi_2002)
tab bmi_2002 if sample==1 /* probably need to make categorical based upon recommended BMI for those 12-18 */

******************************PERSEVERANCE**************************************
tab1 Q23K26A Q23K26B Q23K26C Q23K26D Q23K26E if sample==1
recode Q23K26A Q23K26B Q23K26C Q23K26D Q23K26E(9=.) /* 12-23 youth with missing data on items */
rename (Q23K26A Q23K26B Q23K26C Q23K26D Q23K26E)(stickwith_02 solvediff_02 orderly_02 bestwork_02 finishthings_02)
tab1 stickwith_02 solvediff_02 orderly_02 bestwork_02 finishthings_02 if sample==1

**1 item from the global self-concept scale -- do things as well as others***
/* need to download the other items if we want to use global self-concept */
tab Q23K28 if sample==1
recode Q23K28(9=.) /* 9 youth with missing data */
tab Q23K28 if sample==1 /* 5 = most of the time to 1 = never */

/* CDS-created scale created; mean of all items with nonmissing data */
tab GLBCN02 if sample==1
recode GLBCN02(9=.) /* 10 with missing data on all items comprising scale */
tab GLBCN02 if sample==1

********************************RISKY OR DEVIANT BEHAVIORS**********************
tab1 Q23L11A Q23L11B Q23L11C Q23L11D Q23L11E Q23L11F Q23L11G Q23L11H Q23L11I Q23L11J if sample==1
/* Note: 0's = none; 50+ missing on several items.... */ 
recode Q23L11A Q23L11B Q23L11C Q23L11D Q23L11E Q23L11F Q23L11G Q23L11H Q23L11I Q23L11J(99=.)
tab1 Q23L11A Q23L11B Q23L11C Q23L11D Q23L11E Q23L11F Q23L11G Q23L11H Q23L11I Q23L11J if sample==1
rename (Q23L11A Q23L11B Q23L11C Q23L11D Q23L11E Q23L11F Q23L11G Q23L11H Q23L11I Q23L11J)(pstcurfew_02 hurtoth_02 lied_02 stole_02 damageschl_02 prtschmtg_02 skipsch_02 snuckout_02 police_02 arrest_02)
tab1 pstcurfew_02 hurtoth_02 lied_02 stole_02 damageschl_02 prtschmtg_02 skipsch_02 snuckout_02 police_02 arrest_02 if sample==1

**********SUBSTANCE USE -- need to look at the 0's for these variables**********
/*tab1 Q23L12E Q23L12H if sample==1
recode Q23L12E Q23L12H(99=.)
tab1 Q23L12E Q23L12H if sample==1

tab1 Q23L13C Q23L13E if sample==1
recode Q23L13C Q23L13E(9=.)(0=.)
tab1 Q23L13C Q23L13E if sample==1

tab1 Q23L14A Q23L15A if sample==1
recode Q23L14A Q23L15A(9=.) /*16-19 youth missing data */
rename (Q23L14A Q23L15A)(marijev_02 inhalantev_02)
tab1 marijev_02 inhalantev_02 if sample==1
*/
*******************ROMANTIC PARTNER AND SEXUAL ACTIVITY*************************
tab Q23L20 if sample==1
recode Q23L20(9=.) /*22 with missing data for current romantic partner, gf or bf */
rename (Q23L20)(romanticrl_02)
tab romanticrl_02 if sample==1

tab1 Q23L29 if sample==1
recode Q23L29(9=.)
rename (Q23L29)(sexev_02)
tab sexev_02 if sample==1 /* ever had sexual intercourse, yes/no */
recode sexev_02(5=0) /*change "no" code from 5 to 0 */
label define noyes 0 "no" 1 "yes"
label values sexev_02 noyes
tab sexev_02 if sample==1 /* ever had sexual intercourse, yes/no */

/* these variables only for those who have had intercourse */
tab1 Q23L30A Q23L30B Q23L31 if sample==1
drop Q23L30A Q23L30B /*these do not seem relevant to current analyses*/
recode Q23L31(9=.)(0=.)
rename (Q23L31)(condomuse_02)
tab1 condomuse_02 if sample==1

***********************SCHOOL ENGAGEMENT ***************************************
/* school and teacher engagement or connection */
tab1 Q23L22A Q23L22B Q23L22C Q23L22D Q23L22E if sample==1
/* based on age, the 25 youth coded as 0 should not have been "ineligible" for these questions*/
recode Q23L22A Q23L22B Q23L22C Q23L22D Q23L22E(9=.) /*15-16 with missing data on items */
tab1 Q23L22A Q23L22B Q23L22C Q23L22D Q23L22E if sample==1
/* don't think we should use these items...not confident about inputting given the oddity about "ineligible" 
and not sure what they will add*/
*/

***********************CLEAN TAS 2011 VARIABLES*********************************

****************LIFE SATISFACTION***************************************
tab TA110015 if sample==1
recode TA110015(8/9=.)(0=.)
rename (TA110015)(lifesat_2011)
tab lifesat_2011 if sample==1

***************************COMMUNITY OR SOCIAL GROUP INVOLVEMENT****************
tab1 TA110016 TA110019 TA110034 if sample==1
recode TA110034(6=.) 
/* 8 were coded "6" meaning they said they were not in school;
coding as missing here but should they be "no's" instead? */
tab TA110034 if sample==1
rename (TA110016 TA110019 TA110034)(artact_11 sports_11 schclub_11)
recode artact_11 sports_11 schclub_11(5=0)
label values artact_11 sports_11 schclub_11 noyes
tab1 artact_11 sports_11 schclub_11 if sample==1

******************************CIVIC INVOLVEMENT*********************************
tab1 TA110030 TA110031 TA110036 if sample==1
rename (TA110030 TA110031 TA110036)(voted_2010 socactgrp_2011 volunteer_2011)
recode voted_2010 socactgrp_2011 volunteer_2011(5=0)
label values voted_2010 socactgrp_2011 volunteer_2011 noyes
tab1 voted_2010 socactgrp_2011 volunteer_2011 if sample==1

************************HOBBIES OR LEISURE ACTIVITY*****************************
tab1 TA110021 TA110022 TA110023 if sample==1

/*recode 7 (never) to be 1 (less than once a month)*/
tab TA110021 if sample==1, nolabel 
recode TA110021(7=1)
tab TA110021 if sample==1, nolabel

tab TA110022 if sample==1, nolabel
recode TA110022(8/9=.)
recode TA110022(7=1)
tab TA110022 if sample==1, nolabel

tab TA110023 if sample==1, nolabel
recode TA110023(7=1)
tab TA110023 if sample==1, nolabel

label define likert6 1 "less than once a month or never" 2 "at least once a month" 3 "once a week" 4 "several times a week" 5 "almost every day" 6 "every day"
label values TA110021 TA110022 TA110023 likert6

tab1 TA110021 TA110022 TA110023 if sample==1
rename (TA110021 TA110022 TA110023)(news_2011 read_2011 tv_2011)
tab1 news_2011 read_2011 tv_2011 if sample==1

***INTERNET AND SOCIAL MEDIA USE*****
tab1 TA110024 TA110025 TA110026 TA110027 TA110028 TA110029 if sample==1
rename (TA110024)(internetev_11)
recode internetev_11(5=0)
label values internetev_11 noyes
tab internetev_11 if sample==1

recode TA110025(7=1)(0=.)
rename (TA110025)(email_2011)
tab email_2011 if sample==1

tab TA110026 if sample==1
recode TA110026(0=.)(7=1) 
rename (TA110026)(internetsch_2011)
tab internetsch_2011 if sample==1

tab TA110027 if sample==1
recode TA110027(0=.)(7=1) 
rename (TA110027)(internetshop_2011)
tab internetshop_2011 if sample==1

tab TA110028 if sample==1
recode TA110028(0=.)(7=1) 
rename (TA110028)(internetgame_2011)
tab internetgame_2011 if sample==1

tab TA110029 if sample==1
recode TA110029(0=.)(7=1) 
rename (TA110029)(socialnetwork_2011)
tab socialnetwork_2011 if sample==1

label values email_2011 internetsch_2011 internetshop_2011 internetgame_2011 socialnetwork_2011 likert6 

**************************PLACE OF RESIDENCE LAST YEAR**************************
tab1 TA110044 TA110045 if sample==1 
/*do we want to combine into the following to reflect primary residence past year?
0=lived in parental home/home owned by parent; 1=lived in home rented/owned by self; 
2=residential setting (military base, college campus); 3=other */
tab1 TA110044 TA110045 if sample==1, nolabel
recode TA110044 TA110045(99=.) /*set 99 (na/refused) to missing */
rename (TA110044 TA110045)(fallwintres_11 summerres_11)
tab1 fallwintres_11 summerres_11 if sample==1 

/* the majority lived with parents or in own place they were renting; NOT SURE THIS ADDS ANYTHING */

**************INTERPERSONAL RELATIONSHIPS***************************************
/*married or cohabitating */
tab1 TA111138 if sample==1
tab1 TA111138 if sample==1, nolabel
recode TA111138(1=1)(3=1)(6=1)(2=0)(5=0)(7=0)
rename (TA111138)(marrcohab_2011)
label values marrcohab_2011 noyes
tab marrcohab_2011 if sample==1

/* Romantic relationship and family status */
tab1 TA110088 TA110090 TA110101 if sample==1
/*TA110088 is a romantic relationship other than marriage or cohabitation;
Those coded 0 here are married or cohabitating; recode to reflect married/cohabitating as cat 2*/
recode TA110088(8/9=.)
recode TA110088(0=2)(5=0)
rename (TA110088)(romantic11_3cat)
tab romantic11_3cat if sample==1
label define romantic_cat 0 "not in romantic relationship" 1 "in romantic relationship" 2 "married or cohabitating"
label values romantic11_3cat romantic_cat
tab romantic11_3cat if sample==1 /* use this variable, I think */

tab TA110090 if sample==1
recode TA110090 (8/9=.)(0=.) /*only asked of those in a romantic relationship. all 0's coded as . since they were not asked*/
rename (TA110090)(romsat_2011)
tab romsat_2011 if sample==1

tab1 TA110101 if sample==1
rename (TA110101)(children_2011)
tab1 children_2011 if sample==1, nolabel

gen parent11=.
replace parent11=0 if children_2011==0
replace parent11=1 if children_2011==1
tab parent11

/*closeness to parental figures*/
tab1 TA110127 TA110135 if sample==1
tab1 TA110127 TA110135 if sample==1, nolabel
/* 0 indicates R does not have that parental figure, living or otherwise; 
coding as missing since it does not apply to those without a father or mother figure */
recode TA110127 TA110135(9=.)(0=.)
rename (TA110127 TA110135)(closef_2011 closem_2011)
tab1 closef_2011 closem_2011 if sample==1 /* quite a few missing, mostly dt not having that figure in their life */

/* questions about peer group */
rename (TA111013 TA111014 TA111015 TA111016) (peerjob_2011 peercoll_2011 peerue_2011 peermarried_2011)
rename (TA111017 TA111018 TA111019 TA111020) (peervotech_2011 peerprnt_2011 peerdrunk_2011 peerdrug_2011)
tab1 peerjob_2011 peercoll_2011 peerue_2011 peermarried_2011 peervotech_2011 peerprnt_2011 peerdrunk_2011 peerdrug_2011 if sample==1, nolabel
recode peerjob_2011 peercoll_2011 peerue_2011 peermarried_2011 peervotech_2011 peerprnt_2011 peerdrunk_2011 peerdrug_2011 (8/9=.) /* 4-6 with missing data */
tab1 peerjob_2011 peercoll_2011 peerue_2011 peermarried_2011 peervotech_2011 peerprnt_2011 peerdrunk_2011 peerdrug_2011 if sample==1

***********************ABILITY SELF-CONCEPTS************************************
/* Rating financial responsibility */
rename (TA110046 TA110047 TA110048 TA110049)(earnlvg_2011 payrent_2011 paybills_2011 mangmon_2011)
tab1 earnlvg_2011 payrent_2011 paybills_2011 mangmon_2011 if sample==1, nolabel
recode earnlvg_2011 payrent_2011 paybills_2011 mangmon_2011(8/9=.)
/*payrent_2011 6=no rent and paybills_2011 6=no bills. This seems impossible unless these YA are independently wealthy? */
/* in the PSID-created scale variable, ppl with 6's on those items were counted as missing along with the dk and na/refused */
tab1 earnlvg_2011 payrent_2011 paybills_2011 mangmon_2011 if sample==1

/* TAS-constructed financial responsibility scale, avg of 4 non-missing items */
tab1 TA111118 if sample==1
recode TA111118(9=.) /*9=missing for all 4 items or those coded "6" on the two items I mentioned above*/
rename (TA111118)(finanrespscale)
tab1 finanrespscale if sample==1, nolabel

/* Rating personal abilities */
rename (TA110050 TA110051 TA110052 TA110053)(ownactions probsolve moneymng creditcardmng )	
tab1 ownactions probsolve moneymng creditcardmng if sample==1
recode creditcardmng(9=.)(0=.) /*0 was no credit card; probably don't need it bc money management captures this, I think*/
tab1 ownactions probsolve moneymng creditcardmng if sample==1, nolabel
/*1=somebody does this for me always, 2=somebody does this for me mostly, 3= I do this halftime 4=I do this most time, 5=I do this all time*/

/* Comparing own personal skills and personal traits to others' skills */
rename (TA110054 TA110055 TA110056 TA110057)(supervise_2011 leader_2011 logical_2011 helping_2011)
rename (TA110058 TA110059 TA110060)(intelligence_2011 independence_2011 confidence_2011)
rename (TA110061 TA110062 TA110063)(decisiveness_2011 listening_2011 teaching_2011)
tab1 supervise_2011 leader_2011 logical_2011 helping_2011 intelligence_2011 independence_2011 confidence_2011 decisiveness_2011 listening_2011 teaching_2011 if sample==1, nolabel
recode supervise_2011 leader_2011 logical_2011 helping_2011 intelligence_2011 independence_2011 confidence_2011 decisiveness_2011 listening_2011 teaching_2011 (8=.)
tab1 supervise_2011 leader_2011 logical_2011 helping_2011 intelligence_2011 independence_2011 confidence_2011 decisiveness_2011 listening_2011 teaching_2011 if sample==1, nolabel
/* 1 = not at all well and 7 = extremely well */

***************EMPLOYMENT, EDUCATION, TRAINING & EARNINGS**********************
tab1 TA091008 TA111133 TA111150 TA111141 if sample==1 
rename (TA091008 TA111133 TA111150 TA111141)(highested_09 enrollstat_11 highested_11 yaearnings_10)
tab1 highested_09 highested_11 enrollstat_11 if sample==1
recode enrollstat_11 highested_09 highested_11(99=.)
tab highested_09 highested_11 if sample==1, nolabel

gen higheduc=highested_11
tab1 highested_11 higheduc if sample==1
tab highested_09 if highested_11==96
replace higheduc=highested_09 if highested_11==96
tab1 higheduc if sample==1

recode higheduc(1=0)(2/3=1)(4/5=2)(6/9=3)(11/19=3)
tab higheduc if sample==1, nolabel

label define educ_cat 0 "less than high school" 1 "HS diploma or GED, no college" 2 "some college" 3 "associate's degree or higher"
label values higheduc educ_cat
tab higheduc if sample==1

gen college=.
replace college=1 if (higheduc==2|higheduc==3)
replace college=0 if (higheduc==0|higheduc==1)
label values college noyes
tab college if sample==1

/*employment*/
tab1 TA110137 TA110138 TA110139 if sample==1
recode TA110137 TA110138 TA110139(98/99=.)
rename (TA110137 TA110138 TA110139)(employstat111 employstat211 employstat311)
recode employstat111(1/2=1)(3/8=0)
label values employstat111 noyes
tab employstat111 if sample==1

gen employed=employstat111
replace employed=1 if (employstat211==1|employstat211==2)
replace employed=1 if (employstat311==1|employstat311==2)
tab employed if sample==1

/* TA110464 0=still in armed forces, 1=was in armed forces, 5=never */
tab1 TA110464 TA110742 TA110743 if sample==1

recode TA110464(0=1)(5=0) 
label values TA110464 noyes
tab TA110464 if sample==1
recode TA110742(8/9=.)
recode TA110743(8/9=.)(0=.)
rename (TA110464 TA110742 TA110743)(military nonacadtrng votechnow)
tab1 military nonacadtrng votechnow if sample==1, nolabel
recode nonacadtrng votechnow(5=0)
label values nonacadtrng votechnow noyes
tab1 military nonacadtrng votechnow if sample==1, nolabel

recode yaearnings_10(9999999=.)
tab yaearnings_10 if sample==1 /* 0 means no earnings from labor force in 2010...keep as $0 then? */

/* parent education level*/
tab1 TA111134 TA111136 if sample==1
rename (TA111134 TA111136)(mothered_11 fathered_11)
recode mothered_11 fathered_11(96/99=.)
tab1 mothered_11 fathered_11 if sample==1

*************************HEALTH BEHAVIOR & ACCESS*******************************
tab1 TA110855 if sample==1
rename (TA110855)(doc_pstyr)
tab1 doc_pstyr if sample==1
recode  doc_pstyr (5=0)
label values doc_pstyr noyes
tab1 doc_pstyr if sample==1

tab1 ER34121 ER34128 if sample==1
rename (ER34121 ER34128)(hlthinsur0910 hlthinsur11)
recode hlthinsur0910 hlthinsur11(98/99=.)(8/9=.)
recode hlthinsur11(0=.)
tab1 hlthinsur0910 hlthinsur11 if sample==1
drop hlthinsur0910
recode hlthinsur11(5=0)
label values hlthinsur11 noyes
tab hlthinsur11 if sample==1

/* not using 2011 physical activity variables unless good theoretical reason
tab1 TA110890 TA110891 TA110892 if sample==1 /* variables only for those who were not Head/Wife...*/
recode TA110890 TA110891 TA110892(8/9=.)(0=.)
rename (TA110890 TA110891 TA110892)(vigact litact musact)
tab1 vigact litact musact if sample==1
tab1 TA110893 TA110894 if sample==1
*/

tab1 TA110900 TA110901 TA110902 TA110903 TA110905 if sample==1
recode TA110900(98/99=.)
recode TA110901 TA110902 TA110903(8/9=.)
recode TA110905(998/999=.)
rename (TA110900 TA110901 TA110902 TA110903 TA110905)(sleep11 snack11 bingeeat11 smoke11 cigct11)
tab1 sleep11 snack11 bingeeat11 smoke11 cigct11 if sample==1

tab sleep11 if sample==1, nolabel /* several extreme outliers; mayoclinic suggests 7-9 hrs for adults 18+ */
gen sleeprecomm=.
replace sleeprecomm=0 if (sleep11<=6)|(sleep11>=10 & sleep11~=.)
replace sleeprecomm=1 if (sleep11>=7 & sleep11<=9)
tab sleeprecomm if sample==1, nolabel
di 279+330+71

/* cigct11: 0's are either doesn't smoke or missing on whether they smoke. 
use smoke11 to figure this out */
tab1 smoke11 cigct11 if sample==1
recode smoke11(5=0)
label values smoke11 noyes

recode cigct11(0=.)
replace cigct11=0 if smoke11==0
tab cigct11 if sample==1

tab1 snack11 bingeeat11 if sample==1
gen nutrit11_1=.
replace nutrit11_1=0 if (snack11<=2)
replace nutrit11_1=1 if (snack11>=3 & snack11<=4)
replace nutrit11_1=2 if (snack11>=5 & snack11~=.)
tab nutrit11_1 if sample==1

gen nutrit11_2=.
replace nutrit11_2=0 if (bingeeat11<=2)
replace nutrit11_2=1 if (bingeeat11>=3 & bingeeat11<=4)
replace nutrit11_2=2 if (bingeeat11>=5 & bingeeat11~=.)
tab nutrit11_2 if sample==1

label define nutri_3cat 0 "never or rarely" 1 "occasional  but infrequent" 2 "regularly"
label values nutrit11_1 nutrit11_2 nutri_3cat

tab1 TA110912 TA110913 TA110915 if sample==1 /*2 missing, 3 missing, 11 missing*/
rename (TA110912 TA110913 TA110915)(alcever_11 alcfreq_11 alc45drinks_11)
recode alcever_11 alcfreq_11(8/9=.)  
tab1 alcever_11 alcfreq_11 if sample==1 /* 2 & 3 missing */
recode alc45drinks_11(998/999=.) 
tab alc45drinks_11 if sample==1 /*11 missing*/
recode alcfreq_11(0=.) if alcever_11==.
recode alc45drinks_11(0=.) if alcever_11==.
recode alc45drinks_11(0=.) if alcfreq_11==.
tab alc45drinks_11 alcever_11 if sample==1 
tab alc45drinks_11 alcfreq_11 if sample==1 
tab alc45drinks_11 if sample==1 /*16 obs with missing data*/

recode alcever_11(5=0)
label values alcever_11 noyes
tab1 alcever_11 if sample==1

histogram alc45drinks_11 if sample==1, normal
sum alc45drinks_11 if sample==1, d
tab alc45drinks_11 if sample==1, miss

count if alc45drinks_11>=11 & alc45drinks_11~=. & sample==1 /*160*/
count if alc45drinks_11>=1  & alc45drinks_11<=10 & sample==1 /*347*/
count if alc45drinks_11==0  & sample==1 /*565*/

tab alc45drinks_11 if sample==1
gen bingedrk3=.
replace bingedrk3=0 if alc45drinks_11==0
replace bingedrk3=1 if (alc45drinks_11>=1  & alc45drinks_11<=10)
replace bingedrk3=2 if (alc45drinks_11>=11 & alc45drinks_11~=.)
tab bingedrk3 if sample==1
label define bingedrink 0 "0 days a year" 1 "1-10 days a year" 2 "11 or more days a year"
label values bingedrk3 bingedrink
label variable bingedrk3 "Freq of YA's having 4 or 5 alcoholic drinks in one occasion in the last year"

tab1 TA110916 TA110924 TA110932 TA110945 TA110953 TA110961 if sample==1
recode TA110916 TA110924 TA110932 TA110945 TA110953 TA110961(8/9=.)
label values TA110916 TA110924 TA110932 TA110945 TA110953 TA110961 noyes
tab1 TA110916 TA110924 TA110932 TA110945 TA110953 TA110961 if sample==1
rename (TA110916 TA110924 TA110932 TA110945 TA110953 TA110961)(dtpillev amphetev marijev barbev tranqev sterev)
tab1 dtpillev amphetev marijev barbev tranqev sterev if sample==1
egen subusect=rowtotal(dtpillev amphetev marijev barbev tranqev sterev), missing
tab subusect if sample==1

tab1 TA110969 TA110974 TA110996 if sample==1
recode TA110969(7=1)(8/9=.)(5=0)
tab TA110969 if sample==1
label values TA110969 noyes

****************************HEALTH**********************************************
/* overall self-reported health 5-item Likert*/
tab TA110788 if sample==1
recode TA110788(8/9=.)
rename (TA110788)(health_2011)
tab health_2011 if sample==1, nolabel

gen goodhlth_11=.
replace goodhlth_11=1 if (health_2011<=3)
replace goodhlth_11=0 if (health_2011>3 & health_2011<=5)
tab goodhlth_11 if sample==1
label values goodhlth_11 noyes

/* asthma, diabetets, or high blood pressure */
tab1 TA110794 TA110801 TA110806 if sample==1
/* only 12 people (1%) had ever been dx'd with diabetes; won't use*/
drop TA110801
recode TA110794 TA110806(9=.)(5=0)
rename (TA110794 TA110806)(asthma highbp)
label values asthma highbp noyes
tab1 asthma highbp if sample==1

/*BODY WEIGHT %*/
tab1 TA111132 if sample==1
recode TA111132(9=.)
rename (TA111132)(bmi_2011)
tab bmi_2011 if sample==1

************************PSYCHOLOGICAL HEALTH***********************
/* these are all asking about ever being diagnosed with a psychiatric or emotional disorder */
tab1 TA110825 TA110826 if sample==1, nolabel
recode TA110825(9=.)(5=0)
label values TA110825 noyes
tab1 TA110825 if sample==1, nolabel
rename TA110825 psychdxever

recode TA110826(0=.)(99=.)
tab1 TA110826 if sample==1, nolabel
gen agedx_cat=.
replace agedx_cat=0 if TA110826<=12
replace agedx_cat=1 if TA110826>=13 & TA110826<=18
replace agedx_cat=2 if TA110826>=19 & TA110826<=27
tab agedx_cat if sample==1
label define agedxcat 0 "diagnosed age 12 or younger" 1 "diagnosed between ages 13 and 18" 2 "diagnosed between ages 19 and 27"
label values agedx_cat agedxcat

tab psychdxever agedx_cat if sample==1

tab1 TA110828 TA110829 TA110830 TA110831 TA110834 TA110835 TA110836 if sample==1
recode TA110828 TA110829 TA110830 TA110831 TA110834 TA110835 TA110836(8/9=.)(0=.)
/* it seems like 0 could remain 0 and be relabled as "no"; the codebook indicates 
that this is what people never diagnosed with this (or any) disorder are 0 currently */
tab1 TA110828 TA110829 TA110830 TA110831 TA110834 TA110835 TA110836 if sample==1 /*101 provided type of dx */

tab TA110838 if sample==1
recode TA110838(8/9=.)(0=.)
tab TA110838 if sample==1

/* K6 SCALLE ITEMS*/
tab1 TA110844 TA110845 TA110846 TA110847 TA110848 TA110849 if sample==1
/* no data is missing */
rename (TA110844 TA110845 TA110846 TA110847 TA110848 TA110849)(nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011)
tab1 nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011, nolabel 

egen k6miss=rowmiss(nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011)
tab k6miss if sample==1 /*no one in our sample is missing data on any k6 items */

tab1 nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011, nolabel
/* per scale instructions, items must be reverse coded to sum between 0-24 */
recode nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011(1=4)(2=3)(3=2)(4=1)(5=0)
tab1 nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011
label define k6 0 "none of the time" 1 "A little of the time" 2 "some of the time" 3 "most of the time" 4 "all of the time"
label values nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011 k6
tab1 nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011 if sample==1

egen k6scale=rowtotal(nervous_2011 hopeless_2011 restless_2011 effort_2011 sad_2011 worthless_2011), missing
tab1 k6scale if sample==1

gen spd=.
replace spd=1 if k6scale>=13 & k6scale~=.
replace spd=0 if k6scale<13
tab spd
tab spd if sample==1 /*3.5% (n=38)of sample meet SPD cutoff scores*/

/* extent that SPD interfered with life items */
rename (TA110850 TA110851 TA110852)(k6sxfreq_2011 degreefreq_2011 k6interfere_2011)
tab1 k6sxfreq_2011 degreefreq_2011 k6interfere_2011, nolabel
recode k6sxfreq_2011 degreefreq_2011 k6interfere_2011(8/9=.)(0=.)
/* k6sxfreq_2011 & k6interfere_2011 do not apply to ppl who responded no to all depression indicators;
they were coded as 0. Will leave for now but may recode later to missing or new category*/
/* degreefreq_2011 does not apply to ppl who responded no to all depression indicators;
degreefreq_2011 does not apply to ppl who responded same as usual to k6sxfreq */
tab1 k6sxfreq_2011 degreefreq_2011 k6interfere_2011 if sample==1

/* PHQ 2-items, past 12 months */
rename (TA110853 TA110854)(depress2wks_2011 anhed2wks_2011)
tab1 depress2wks_2011 anhed2wks_2011, nolabel
recode depress2wks_2011 anhed2wks_2011(8/9=.)
recode anhed2wks_2011(0=.) /* no interest in life question only applies to ppl who answered yes to depression >2 weeks */
recode depress2wks_2011 anhed2wks_2011(5=0) /* no's recoded as 0 */
label values depress2wks_2011 anhed2wks_2011 noyes
tab1 depress2wks_2011 anhed2wks_2011 if sample==1, nolabel

gen phq2=.
replace phq2=1 if (depress2wks_2011==1|anhed2wks_2011==1)
replace phq2=0 if (depress2wks_2011==0 & anhed2wks_2011==0)
tab depress2wks_2011
tab depress2wks_2011 if sample==1 
/* 9.8% of sample answered yes for at least one of the 2 phq questions, which 
would prompt a full PHQ-9 and assess for MDD 
https://aidsetc.org/sites/default/files/resources_files/PHQ-2_English.pdf */

/* PSID constructed worry scale: average of all non-missing responses to 3 items */
tab1 TA111119 if sample==1
rename (TA111119)(worryscale_11)

/* social anxiety items */
tab1 TA110064 TA110065 TA110066 TA110070 if sample==1
recode TA110064 TA110065 TA110066 TA110070(8/9=.)
rename (TA110064 TA110065 TA110066 TA110070)(meetppl_11 shy_11 selfcon_11 perform_11)
tab1 meetppl_11 shy_11 selfcon_11 perform_11 if sample==1
/* 1 = never to 7 = always */

/* PSID constructed Social anxiety scale: avg of all non-missing responses to 4 items */
tab1 TA111120 if sample==1
rename (TA111120)(socanxscale_11)
tab1 socanxscale_11 if sample==1, nolabel

*****************DEVIANT BEHAVIOR*******************************************
/* items about risky and/or deviant behavior */
rename (TA111027 TA111028 TA111029 TA111030)(danger_2011 property_2011 fight_2011 dui_2011)
tab1 danger_2011 property_2011 fight_2011 dui_2011 if sample==1, nolabel
recode danger_2011 property_2011 fight_2011 dui_2011 (8/9=.)
tab1 danger_2011 property_2011 fight_2011 dui_2011 if sample==1
/* 1 = never to 7 = 21 or more times */

/* PSID-constructed risky behavior scale -- average of 5 items -- higher score, more risky bx */
tab1 TA111126 if sample==1
rename (TA111126)(riskybxscale_11)
tab riskybxscale_11 if sample==1, nolabel

********************PERCEIVED DISCRIMINATION***********************************
/* EDS items -- freq of unfair treatment, 6-item Likert  */
rename (TA110997 TA110998 TA110999 TA111000 TA111001 TA111002 TA111003)(courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011)
tab1 courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011 if sample==1, nolabel
recode courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011 (8/9=.)
tab1 courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011 if sample==1, nolabel

****************EXPERIENCED VIOLENCE********************************************
tab1 TA111021 TA111022 TA111023 TA111024 TA111025 TA111026 if sample==1
rename (TA111021 TA111024)(sexassault phyassault)
recode sexassault phyassault(8/9=.)
tab1 sexassault phyassault if sample==1

****************RELIGION AND SPIRITUALITY***************************************
tab1 TA111050 TA111053 TA111054 if sample==1
recode TA111053 TA111054(8/9=.)
rename (TA111050 TA111053 TA111054)(relig_pref relig_freq spiritual)
recode relig_pref(98/99=.)
recode spiritual(5=0)
label values spiritual noyes 

tab1 relig_pref relig_freq spiritual if sample==1
  
************FLOURISHING/LANGUISHING 2011****************************************
/* PSID-created L/F scale*/
tab1 TA111121 if sample==1
recode TA111121(99=.) /*5 had missing data on all scale itesm*/
tab1 TA111121 if sample==1 /*1,085*/

/* 2011 TAS L/F subscale items */
rename (TA111061 TA111062 TA111063)(ewb1_2011 ewb2_2011 ewb3_2011)
rename (TA111064 TA111065 TA111066 TA111067 TA111068)(swb1_2011 swb2_2011 swb3_2011 swb4_2011 swb5_2011)
rename (TA111069 TA111070 TA111071 TA111072 TA111073 TA111074)(pwb1_2011 pwb2_2011 pwb3_2011 pwb4_2011 pwb5_2011 pwb6_2011)

****CREATE LANGUISHING, MODERATE, AND FLOURISHING STATUS FOR 2011*****
tab1 ewb1_2011 ewb2_2011 ewb3_2011 if sample==1
tab1 ewb1_2011 ewb2_2011 ewb3_2011 if sample==1, nolabel /* 1=never to 6=everyday */
/* Keyes, C. L. M. (2005). Mental illness and/or mental health?
Investigating axioms of the complete state model of health.
Journal of Consulting and Clinical Psychology, 73, 539–548.
flourishing == >= 1 of 3 emot wb = 5/6 & at least 6 of 11 psy + socwb =5/6 */

***FIRST, CREATE binary variables to reflect each item almost everyday or everyday***
gen ewb1_flr2011=0
replace ewb1_flr2011=1 if (ewb1_2011==5|ewb1_2011==6)
replace ewb1_flr2011=. if (ewb1_2011==.)
tab ewb1_flr2011, miss
count if ewb1_2011==5|ewb1_2011==6

gen ewb2_flr2011=0
replace ewb2_flr2011=1 if (ewb2_2011==5|ewb2_2011==6)
replace ewb2_flr2011=. if (ewb2_2011==.)
tab ewb2_flr2011
count if ewb2_2011==5|ewb2_2011==6

gen ewb3_flr2011=0
replace ewb3_flr2011=1 if (ewb3_2011==5|ewb3_2011==6)
replace ewb3_flr2011=. if (ewb3_2011==.)
tab ewb3_flr2011
count if ewb3_2011==5|ewb3_2011==6

egen avgemot=rowmean(ewb1_2011 ewb2_2011 ewb3_2011)
tab avgemot if sample==1

egen sumemot=rowtotal(ewb1_2011 ewb2_2011 ewb3_2011)
tab sumemot if sample==1

*****************************************************************************
gen swb1_flr2011=0
replace swb1_flr2011=1 if (swb1_2011==5|swb1_2011==6)
replace swb1_flr2011=. if swb1_2011==.
tab swb1_flr2011
count if swb1_2011==5|swb1_2011==6

gen swb2_flr2011=0
replace swb2_flr2011=1 if (swb2_2011==5|swb2_2011==6)
replace swb2_flr2011=. if swb2_2011==.
tab swb2_flr2011
count if swb2_2011==5|swb2_2011==6

gen swb3_flr2011=0
replace swb3_flr2011=1 if (swb3_2011==5|swb3_2011==6)
replace swb3_flr2011=. if swb3_2011==.
tab swb3_flr2011
count if swb3_2011==5|swb3_2011==6

gen swb4_flr2011=0
replace swb4_flr2011=1 if (swb4_2011==5|swb4_2011==6)
replace swb4_flr2011=. if swb4_2011==.
tab swb4_flr2011
count if swb4_2011==5|swb4_2011==6

gen swb5_flr2011=0
replace swb5_flr2011=1 if (swb5_2011==5|swb5_2011==6)
replace swb5_flr2011=. if swb5_2011==.
tab swb5_flr2011
count if swb5_2011==5|swb5_2011==6

egen avgsoc=rowmean(swb1_2011 swb2_2011 swb3_2011 swb4_2011 swb5_2011)
tab avgsoc if sample==1

egen sumsoc=rowtotal(swb1_2011 swb2_2011 swb3_2011 swb4_2011 swb5_2011)
tab sumsoc if sample==1

gen pwb1_flr2011=0
replace pwb1_flr2011=1 if (pwb1_2011==5|pwb1_2011==6)
replace pwb1_flr2011=. if pwb1_2011==.
tab pwb1_flr2011
count if pwb1_2011==5|pwb1_2011==6

gen pwb2_flr2011=0
replace pwb2_flr2011=1 if (pwb2_2011==5|pwb2_2011==6)
replace pwb2_flr2011=. if pwb2_2011==.
tab pwb2_flr2011
count if pwb2_2011==5|pwb2_2011==6

gen pwb3_flr2011=0
replace pwb3_flr2011=1 if (pwb3_2011==5|pwb3_2011==6)
replace pwb3_flr2011=. if pwb3_2011==.
tab pwb3_flr2011
count if pwb3_2011==5|pwb3_2011==6

gen pwb4_flr2011=0
replace pwb4_flr2011=1 if (pwb4_2011==5|pwb4_2011==6)
replace pwb4_flr2011=. if pwb4_2011==.
tab pwb4_flr2011
count if pwb4_2011==5|pwb4_2011==6

gen pwb5_flr2011=0
replace pwb5_flr2011=1 if (pwb5_2011==5|pwb5_2011==6)
replace pwb5_flr2011=. if pwb5_2011==.
tab pwb5_flr2011
count if pwb5_2011==5|pwb5_2011==6

gen pwb6_flr2011=0
replace pwb6_flr2011=1 if (pwb6_2011==5|pwb6_2011==6)
replace pwb6_flr2011=. if pwb6_2011==.
tab pwb6_flr2011
count if pwb6_2011==5|pwb6_2011==6

egen avgpsyc=rowmean(pwb1_2011 pwb2_2011 pwb3_2011 pwb4_2011 pwb5_2011 pwb6_2011)
tab avgpsyc if sample==1

egen sumpsyc=rowtotal(pwb1_2011 pwb2_2011 pwb3_2011 pwb4_2011 pwb5_2011 pwb6_2011)
tab sumpsyc if sample==1

egen flrmiss11=rowmiss(ewb1_flr2011 ewb2_flr2011 ewb3_flr2011 swb1_flr2011 swb2_flr2011 swb3_flr2011 swb4_flr2011 swb5_flr2011 pwb1_flr2011 pwb2_flr2011 pwb3_flr2011 pwb4_flr2011 pwb5_flr2011 pwb6_flr2011)
tab flrmiss11 if sample==1 

egen flr_fxing2011=rowtotal(swb1_flr2011 swb2_flr2011 swb3_flr2011 swb4_flr2011 swb5_flr2011 pwb1_flr2011 pwb2_flr2011 pwb3_flr2011 pwb4_flr2011 pwb5_flr2011 pwb6_flr2011), miss
tab flr_fxing2011 if sample==1 /*rowtotal of 6 or higher indicates that someone met criteria for flourishing psychosocial fxing*/

***********************GENERATE A FLOURISHING DICHOTOMOUS VARIABLE**************
/* Keyes, C. L. M. (2005). Mental illness and/or mental health?
Investigating axioms of the complete state model of health.
Journal of Consulting and Clinical Psychology, 73, 539–548.
flourishing >= 1 of 3 emot wb almost every day or every day & >= 6 of 11 psywb + socwb almost every day or every day */

gen flrsh_bin2011=0
replace flrsh_bin2011=1 if ((ewb1_flr2011==1|ewb2_flr2011==1|ewb3_flr2011==1) & (flr_fxing2011>=6) & (flr_fxing2011~=.))
tab flrsh_bin2011
tab flrsh_bin2011 if sample==1

***SECOND, CREATE binary variables to reflect each item almost NEVER OR one or two days***
gen 	ewb1_lan2011=0
replace ewb1_lan2011=1 if (ewb1_2011==1|ewb1_2011==2)
replace ewb1_lan2011=. if ewb1_2011==.
tab ewb1_lan2011
count if (ewb1_2011==1|ewb1_2011==2)

gen ewb2_lan2011=0
replace ewb2_lan2011=1 if (ewb2_2011==1|ewb2_2011==2)
replace ewb2_lan2011=. if ewb2_2011==.
tab ewb2_lan2011
count if (ewb2_2011==1|ewb2_2011==2)

gen ewb3_lan2011=0
replace ewb3_lan2011=1 if (ewb3_2011==1|ewb3_2011==2)
replace ewb3_lan2011=. if (ewb3_2011==.)
tab ewb3_lan2011
count if ewb3_2011==1|ewb3_2011==2

*******************************************************************************
gen swb1_lan2011=0
replace swb1_lan2011=1 if (swb1_2011==1|swb1_2011==2)
replace swb1_lan2011=. if swb1_2011==.
tab swb1_lan2011
count if (swb1_2011==1|swb1_2011==2)

gen swb2_lan2011=0
replace swb2_lan2011=1 if (swb2_2011==1|swb2_2011==2)
replace swb2_lan2011=. if swb2_2011==.
tab swb2_lan2011
count if (swb2_2011==1|swb2_2011==2)

gen swb3_lan2011=0
replace swb3_lan2011=1 if (swb3_2011==1|swb3_2011==2)
replace swb3_lan2011=. if swb3_2011==.
tab swb3_lan2011
count if (swb3_2011==1|swb3_2011==2)

gen swb4_lan2011=0
replace swb4_lan2011=1 if (swb4_2011==1|swb4_2011==2)
replace swb4_lan2011=. if swb4_2011==.
tab swb4_lan2011
count if (swb4_2011==1|swb4_2011==2)

gen swb5_lan2011=0
replace swb5_lan2011=1 if (swb5_2011==1|swb5_2011==2)
replace swb5_lan2011=. if swb5_2011==.
tab swb5_lan2011
count if (swb5_2011==1|swb5_2011==2)

gen pwb1_lan2011=0
replace pwb1_lan2011=1 if (pwb1_2011==1|pwb1_2011==2)
replace pwb1_lan2011=. if pwb1_2011==.
tab pwb1_lan2011
count if (pwb1_2011==1|pwb1_2011==2)

gen pwb2_lan2011=0
replace pwb2_lan2011=1 if (pwb2_2011==1|pwb2_2011==2)
replace pwb2_lan2011=. if pwb2_2011==.
tab pwb2_lan2011
count if (pwb2_2011==1|pwb2_2011==2)

gen pwb3_lan2011=0
replace pwb3_lan2011=1 if (pwb3_2011==1|pwb3_2011==2)
replace pwb3_lan2011=. if pwb3_2011==.
tab pwb3_lan2011
count if (pwb3_2011==1|pwb3_2011==2)

gen pwb4_lan2011=0
replace pwb4_lan2011=1 if (pwb4_2011==1|pwb4_2011==2)
replace pwb4_lan2011=. if pwb4_2011==.
tab pwb4_lan2011
count if (pwb4_2011==1|pwb4_2011==2)

gen pwb5_lan2011=0
replace pwb5_lan2011=1 if (pwb5_2011==1|pwb5_2011==2)
replace pwb5_lan2011=. if pwb5_2011==.
tab pwb5_lan2011
count if (pwb5_2011==1|pwb5_2011==2)

gen pwb6_lan2011=0
replace pwb6_lan2011=1 if (pwb6_2011==1|pwb6_2011==2)
replace pwb6_lan2011=. if pwb6_2011==.
tab pwb6_lan2011
count if (pwb6_2011==1|pwb6_2011==2)

egen lan_fxing2011=rowtotal(swb1_lan2011 swb2_lan2011 swb3_lan2011 swb4_lan2011 swb5_lan2011 pwb1_lan2011 pwb2_lan2011 pwb3_lan2011 pwb4_lan2011 pwb5_lan2011 pwb6_lan2011), miss
tab lan_fxing2011 if sample==1 /*rowtotal of 6 or higher indicates that someone met criteria for languishing psychosocial fxing*/

**************GENERATE A LANGUISHING DICHOTOMOUS VARIABLE***********************
/* Keyes, C. L. M. (2005). Mental illness and/or mental health?
Investigating axioms of the complete state model of health.
Journal of Consulting and Clinical Psychology, 73, 539–548.
languishing >= 1 of 3 emot wb never or almost never & >= 6 of 11 psywb + socwb never or almost never*/

gen lngsh_bin2011=0
replace lngsh_bin2011=1 if ((ewb1_lan2011==1|ewb2_lan2011==1|ewb3_lan2011==1) & (lan_fxing2011>=6) & (lan_fxing2011~=.))
tab lngsh_bin2011 if sample==1

**************GENERATE A MODERATE MH DICHOTOMOUS VARIABLE***********************
/* Keyes, C. L. M. (2005). Mental illness and/or mental health?
Investigating axioms of the complete state model of health.
Journal of Consulting and Clinical Psychology, 73, 539–548.
if not flourishing or languishing, moderate mh applies */

gen mod_bin2011=0
replace mod_bin2011=1 if lngsh_bin2011==0 & flrsh_bin2011==0
tab mod_bin2011 if sample==1

****************GENERATE A 3-CATEGORY POSITIVE MENTAL HEALTH VARIABLE***********
gen posmh_2011=.
replace posmh_2011=0 if lngsh_bin2011==1
replace posmh_2011=1 if mod_bin2011==1
replace posmh_2011=2 if flrsh_bin2011==1
tab posmh_2011 if sample==1, miss

rename flrsh_bin2011 flourish_2011

********************************************************************************
********************************************************************************
**************CREATE LANGUISHING, MODERATE, AND FLOURISHING STATUS FOR 2002*****
/* Keyes, C. L. M. (2006). flourishing == >= 1 of 3 emot wb = 5/6 & at least 5 of 9 psy + socwb =5/6 */

tab1 ewb1_02 ewb2_02 ewb3_02 if sample==1
tab1 swb1_02 swb2_02 swb3_02 swb4_02 swb5_02 if sample==1
tab1 pwb1_02 pwb2_02 pwb3_02 pwb4_02 if sample==1

recode ewb1_02 ewb2_02 ewb3_02(9=.)
tab1 ewb1_02 ewb2_02 ewb3_02 if sample==1, miss /* 1=never to 6=everyday; ~1.5% had missing data on ewb items */

tab1 swb1_02 swb2_02 swb3_02 swb4_02 swb5_02 if sample==1
recode swb1_02 swb2_02 swb3_02 swb4_02 swb5_02(9=.)
tab1 swb1_02 swb2_02 swb3_02 swb4_02 swb5_02 if sample==1, miss /*2 to 2.5% of sample had missing data on swb items */

tab1 pwb1_02 pwb2_02 pwb3_02 pwb4_02 if sample==1
recode pwb1_02 pwb2_02 pwb3_02 pwb4_02 (9=.)
tab1 pwb1_02 pwb2_02 pwb3_02 pwb4_02 if sample==1, miss /* 2% had missing data on pwb items */

***FIRST, CREATE binary variables to reflect each item almost everyday or everyday***
gen 	ewb1_flr2002=0
replace ewb1_flr2002=1 if (ewb1_02==5|ewb1_02==6)
replace ewb1_flr2002=. if  ewb1_02==.
tab 	ewb1_flr2002 if sample==1
count if (ewb1_02==5|ewb1_02==6) & sample==1

gen 	ewb2_flr2002=0
replace ewb2_flr2002=1 if (ewb2_02==5|ewb2_02==6)
replace ewb2_flr2002=. if  ewb2_02==.
tab 	ewb2_flr2002 if sample==1
count if (ewb2_02==5|ewb2_02==6) & sample==1

gen 	ewb3_flr2002=0
replace ewb3_flr2002=1 if (ewb3_02==5|ewb3_02==6)
replace ewb3_flr2002=. if  ewb3_02==.
tab 	ewb3_flr2002 if sample==1
count if (ewb3_02==5|ewb3_02==6) & sample==1

count if ewb1_flr2002~=. & ewb2_flr2002~=. & ewb3_flr2002~=. & sample==1
***1068 had full data on all 3 ewb items***

*****************************************************************************
gen 	swb1_flr2002=0
replace swb1_flr2002=1 if (swb1_02==5|swb1_02==6)
replace swb1_flr2002=. if  swb1_02==.
tab     swb1_flr2002 if sample==1
count if (swb1_02==5|swb1_02==6) & sample==1

gen 	swb2_flr2002=0
replace swb2_flr2002=1 if (swb2_02==5|swb2_02==6)
replace swb2_flr2002=. if  swb2_02==.
tab 	swb2_flr2002 if sample==1
count if (swb2_02==5|swb2_02==6) &  sample==1

gen 	swb3_flr2002=0
replace swb3_flr2002=1 if (swb3_02==5|swb3_02==6)
replace swb3_flr2002=. if  swb3_02==.
tab 	swb3_flr2002 if sample==1
count if (swb3_02==5|swb3_02==6) &  sample==1

gen		swb4_flr2002=0
replace swb4_flr2002=1 if (swb4_02==5|swb4_02==6)
replace swb4_flr2002=. if  swb4_02==.
tab 	swb4_flr2002 if  sample==1
count if (swb4_02==5|swb4_02==6) &  sample==1

gen 	swb5_flr2002=0
replace swb5_flr2002=1 if (swb5_02==5|swb5_02==6)
replace swb5_flr2002=. if  swb5_02==.
tab 	swb5_flr2002 if sample==1
count if (swb5_02==5|swb5_02==6) & sample==1

count if swb1_flr2002~=. & swb2_flr2002~=. & swb3_flr2002~=. & swb4_flr2002~=. & swb5_flr2002~=. & sample==1
***1,047 had full data on all 3 swb items***

gen 	pwb1_flr2002=0
replace pwb1_flr2002=1 if (pwb1_02==5|pwb1_02==6)
replace pwb1_flr2002=. if  pwb1_02==.
tab 	pwb1_flr2002 if sample==1
count if (pwb1_02==5|pwb1_02==6) & sample==1

gen 	pwb2_flr2002=0
replace pwb2_flr2002=1 if (pwb2_02==5|pwb2_02==6)
replace pwb2_flr2002=. if  pwb2_02==.
tab 	pwb2_flr2002 if sample==1
count if (pwb2_02==5|pwb2_02==6) & sample==1

gen 	pwb3_flr2002=0
replace pwb3_flr2002=1 if (pwb3_02==5|pwb3_02==6)
replace pwb3_flr2002=. if  pwb3_02==.
tab 	pwb3_flr2002 if sample==1
count if (pwb3_02==5|pwb3_02==6) & sample==1

gen 	pwb4_flr2002=0
replace pwb4_flr2002=1 if (pwb4_02==5|pwb4_02==6)
replace pwb4_flr2002=. if  pwb4_02==.
tab 	pwb4_flr2002 if sample==1
count if (pwb4_02==5|pwb4_02==6) & sample==1

count if pwb1_flr2002~=. & pwb2_flr2002~=. & pwb3_flr2002~=. & pwb4_flr2002~=. & sample==1
***1,059 with full data on all pwb items***

tab flscale_02 if sample==1, miss
di 1090-51 /*1039 with full data...should we impute ???? */

egen flourishingfull_02=rownonmiss(ewb1_02 ewb2_02 ewb3_02 swb1_02 swb2_02 swb3_02 swb4_02 swb5_02 pwb1_02 pwb2_02 pwb3_02 pwb4_02)
tab flourishingfull_02 if sample==1, miss
/*1,039 have full data for 2002 CDS flourishing and 2011*/

egen flr_fxing2002=rowtotal(swb1_flr2002 swb2_flr2002 swb3_flr2002 swb4_flr2002 swb5_flr2002 pwb1_flr2002 pwb2_flr2002 pwb3_flr2002 pwb4_flr2002) if flourishingfull_02==12, missing
tab flr_fxing2002 if sample==1
***rowtotal of 5 or higher indicates that someone met criteria for flourishing psychosocial fxing***

******************GENERATE A FLOURISHING DICHOTOMOUS VARIABLE*******************
gen 	flrsh_bin2002=0
replace flrsh_bin2002=1 if ((ewb1_flr2002==1|ewb2_flr2002==1|ewb3_flr2002==1) & (flr_fxing2002>=5) & (flr_fxing2002~=.))
replace flrsh_bin2002=. if flr_fxing2002==.
tab flrsh_bin2002
tab flrsh_bin2002 if sample==1
rename flrsh_bin2002 flourish_2002

***SECOND, CREATE binary variables to reflect each item almost NEVER OR one or two days***
gen 	ewb1_lan2002=0
replace ewb1_lan2002=1 if (ewb1_02==1|ewb1_02==2)
replace ewb1_lan2002=. if (ewb1_02==.)
tab 	ewb1_lan2002
count if (ewb1_02==1|ewb1_02==2)

gen 	ewb2_lan2002=0
replace ewb2_lan2002=1 if (ewb2_02==1|ewb2_02==2)
replace ewb2_lan2002=. if (ewb2_02==.)
tab 	ewb2_lan2002
count if (ewb2_02==1|ewb2_02==2)

gen 	ewb3_lan2002=0
replace ewb3_lan2002=1 if (ewb3_02==1|ewb3_02==2)
replace ewb3_lan2002=. if (ewb3_02==.)
tab		ewb3_lan2002
count if ewb3_02==1|ewb3_02==2

*******************************************************************************
gen 	swb1_lan2002=0
replace swb1_lan2002=1 if (swb1_02==1|swb1_02==2)
replace swb1_lan2002=. if  swb1_02==.
tab 	swb1_lan2002
count if (swb1_02==1|swb1_02==2)

gen 	swb2_lan2002=0
replace swb2_lan2002=1 if (swb2_02==1|swb2_02==2)
replace swb2_lan2002=. if  swb2_02==.
tab 	swb2_lan2002
count if (swb2_02==1|swb2_02==2)

gen 	swb3_lan2002=0
replace swb3_lan2002=1 if (swb3_02==1|swb3_02==2)
replace swb3_lan2002=. if  swb3_02==.
tab 	swb3_lan2002
count if (swb3_02==1|swb3_02==2)

gen 	swb4_lan2002=0
replace swb4_lan2002=1 if (swb4_02==1|swb4_02==2)
replace swb4_lan2002=. if  swb4_02==.
tab 	swb4_lan2002
count if (swb4_02==1|swb4_02==2)

gen 	swb5_lan2002=0
replace swb5_lan2002=1 if (swb5_02==1|swb5_02==2)
replace swb5_lan2002=. if  swb5_02==.
tab 	swb5_lan2002
count if (swb5_02==1|swb5_02==2)

gen 	pwb1_lan2002=0
replace pwb1_lan2002=1 if (pwb1_02==1|pwb1_02==2)
replace pwb1_lan2002=. if  pwb1_02==.
tab 	pwb1_lan2002
count if (pwb1_02==1|pwb1_02==2)

gen	 	pwb2_lan2002=0
replace pwb2_lan2002=1 if (pwb2_02==1|pwb2_02==2)
replace pwb2_lan2002=. if  pwb2_02==.
tab 	pwb2_lan2002
count if (pwb2_02==1|pwb2_02==2)

gen 	pwb3_lan2002=0
replace pwb3_lan2002=1 if (pwb3_02==1|pwb3_02==2)
replace pwb3_lan2002=. if  pwb3_02==.
tab 	pwb3_lan2002
count if (pwb3_02==1|pwb3_02==2)

gen 	pwb4_lan2002=0
replace pwb4_lan2002=1 if (pwb4_02==1|pwb4_02==2)
replace pwb4_lan2002=. if  pwb4_02==.
tab 	pwb4_lan2002
count if (pwb4_02==1|pwb4_02==2)

egen lan_fxing2002=rowtotal(swb1_lan2002 swb2_lan2002 swb3_lan2002 swb4_lan2002 swb5_lan2002 pwb1_lan2002 pwb2_lan2002 pwb3_lan2002 pwb4_lan2002) if flourishingfull_02==12, missing
tab lan_fxing2002 if sample==1
***rowtotal of 5 or higher indicates that someone met criteria for languishing psychosocial fxing***

********************GENERATE A LANGUISHING DICHOTOMOUS VARIABLE*****************
gen lngsh_bin2002=0
replace lngsh_bin2002=1 if ((ewb1_lan2002==1|ewb2_lan2002==1|ewb3_lan2002==1) & (lan_fxing2002>=5) & (lan_fxing2002~=.))
replace lngsh_bin2002=. if lan_fxing2002==.
tab lngsh_bin2002
tab lngsh_bin2002 if sample==1, miss

************************GENERATE A MODERATE MH DICHOTOMOUS VARIABLE*************
gen mod_bin2002=0
replace mod_bin2002=1 if lngsh_bin2002==0 & flourish_2002==0
replace mod_bin2002=. if lngsh_bin2002==. & flourish_2002==.
tab mod_bin2002 if sample==1, miss

********************GENERATE A 3-CATEGORY POSITIVE MENTAL HEALTH VARIABLE*******
gen posmh_2002=.
replace posmh_2002=0 if lngsh_bin2002==1
replace posmh_2002=1 if mod_bin2002==1
replace posmh_2002=2 if flourish_2002==1
tab posmh_2002 if sample==1, miss

label define posmh 0 "languishing" 1 "moderate" 2 "flourishing"
label values posmh_2002 posmh_2011 posmh
label variable posmh_2002 "Positive mental health 2002"
label variable posmh_2011 "Positive mental health 2011"

gen mhstatus=.
replace mhstatus=0 if posmh_2002==0 & posmh_2011==0
replace mhstatus=1 if posmh_2002==0 & posmh_2011==1
replace mhstatus=2 if posmh_2002==0 & posmh_2011==2
replace mhstatus=3 if posmh_2002==1 & posmh_2011==0
replace mhstatus=4 if posmh_2002==1 & posmh_2011==1
replace mhstatus=5 if posmh_2002==1 & posmh_2011==2
replace mhstatus=6 if posmh_2002==2 & posmh_2011==0
replace mhstatus=7 if posmh_2002==2 & posmh_2011==1
replace mhstatus=8 if posmh_2002==2 & posmh_2011==2
tab mhstatus if sample==1, miss

label define change 0 "lang->lang" 1 "lang->mod" 2 "lang->flrsh" 3 "mod->lang" 4 "mod->mod" 5 "mod->flrsh" 6 "flrsh->lang" 7 "flrsh->mod" 8 "flrsh->flrsh"
label values mhstatus change
label variable mhstatus "Change in positive mental health 2002 to 2011"

*****CHANGE VARIABLE -- 3 CATEGORY**********
gen change=.
replace change=0 if mhstatus==4
replace change=1 if mhstatus==6|mhstatus==7|mhstatus==3|mhstatus==0
replace change=2 if mhstatus==1|mhstatus==2|mhstatus==5|mhstatus==8
tab change if sample==1, miss
tab change if sample==1

label define ideal 0 "steady but not ideal state" 1 "undesirable move/state" 2 "desirable move/state" 
label values change ideal
label variable change "3-category change in positive mental health 2002 to 2011"
tab change if sample==1

save "C:\Users\palmera\OneDrive - University of Texas at Arlington\Flourishing Mental Health\Analysis\Data\Data for Flourishing in YA study1\Child02+TAS11\clean-childvarsJune2021.dta", replace 


