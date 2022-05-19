***UPDATED: 6/15/2021***

use masterfile.dta, clear

gen fight11_bin=0
replace fight11_bin=1 if fight_2011>=2 & fight_2011~=.
replace fight11_bin=. if fight_2011==.
tab1 fight_2011 fight11_bin

gen respactions=.
replace respactions=1 if (ownactions==6|ownactions==7)
replace respactions=0 if ownactions<=5
tab1 ownactions respactions

gen damageprop=0
replace damageprop=1 if (property_2011>=2 & property_2011~=.)
replace damageprop=. if property_2011==.
tab1 property_2011 damageprop

gen dui_bin=0
replace dui_bin=1 if (dui_2011>=2 & dui_2011~=.)
replace dui_bin=. if dui_2011==.
tab1 dui_2011 dui_bin

gen closef_bin=0
replace closef_bin=1 if (closef_2011==6|closef_2011==7)
replace closef_bin=. if closef_2011==.
tab1 closef_2011 closef_bin

gen closem_bin=0
replace closem_bin=1 if (closem_2011==6|closem_2011==7)
replace closem_bin=. if closem_2011==.
tab1 closem_2011 closem_bin

** perceived everyday discrimination**
tab1 courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011 if sample==1
egen edsscore=rowtotal(courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011), missing
tab edsscore if sample==1

***create binary variable reflecting closeness to at least one parent figure***
gen closep_bin=0
replace closep_bin=1 if (closef_bin==1|closem_bin==1)
replace closep_bin=. if (closef_bin==. & closem_bin==.)
tab1 closef_bin closem_bin closep_bin

gen frienddrunk=.
replace frienddrunk=0 if peerdrunk_2011<=3
replace frienddrunk=1 if peerdrunk_2011>=4 & peerdrunk_2011~=.
tab1 peerdrunk_2011 frienddrunk

gen frienddrugs=.
replace frienddrugs=0 if peerdrug_2011<=3
replace frienddrugs=1 if peerdrug_2011>=4 & peerdrug_2011~=.
tab1 peerdrug_2011 frienddrugs

gen friendprod=0
replace friendprod=1 if ((peerjob_2011>=4 & peerjob_2011~=.)|(peercoll_2011>=4 & peercoll_2011~=.)|(peervotech_2011>=4 & peervotech_2011~=.))
replace friendprod=. if ((peerjob_2011==. & peercoll_2011==. & peervotech_2011==.))
tab1 peerjob_2011 peercoll_2011 peervotech_2011 friendprod

gen resplvg_bin=.
replace resplvg_bin=1 if earnlvg_2011==5
replace resplvg_bin=0 if earnlvg_2011<=4
tab1 earnlvg_2011 resplvg_bin

gen respmon_bin=.
replace respmon_bin=1 if mangmon_2011==5
replace respmon_bin=0 if mangmon_2011<=4
tab1 mangmon_2011 respmon_bin

gen probsolv_bin=0
replace probsolv_bin=1 if (probsolve==6|probsolve==7)
replace probsolv_bin=. if probsolve==.
tab1 probsolve probsolv_bin

gen moneymng_bin=0
replace moneymng_bin=1 if (moneymng==6|moneymng==7)
replace moneymng_bin=. if moneymng==.
tab1 moneymng moneymng_bin

gen agecat_02=.
replace agecat_02=0 if age2002<=14
replace agecat_02=1 if age2002>=15 & age2002<=19
tab age2002 agecat_02

tab1 artact_11 sports_11 schclub_11 voted_2010 volunteer_2011 socactgrp_2011

tab lifesat_2011
tab lifesat_2011, nolabel
gen lifesat2011_bin=.
replace lifesat2011_bin=1 if (lifesat_2011==1|lifesat_2011==2)
replace lifesat2011_bin=0 if (lifesat_2011>=3 & lifesat_2011<=5)
tab lifesat_2011 lifesat2011_bin

tab1 avgemot avgsoc avgpsyc
egen mhscale11=rowtotal(avgemot avgpsyc avgsoc), missing
tab mhscale11
gen contmh11=round(mhscale11,1.0)

order persid sample flourish_2011 posmh_2011 male race hisp2011 age2011 agecat_11
order k6scale lifesat_2011 lifesat2011_bin socactgrp_2011 voted_2010 volunteer_2011 schclub_11 artact_11 sports_11, after(agecat_11)
order goodhlth_11 smoke11 fight11_bin doc_pstyr closep_bin edsscore friendprod, after(sports_11)
order probsolv_bin moneymng_bin dui_bin respactions higheduc college employed, after(friendprod) 
order posmh_2002 flourish_2002 age2002 agecat_02, after(employed)

***sample descriptives***
tab male 
svy, subpop(sample): proportion male

tab race 
svy, subpop(sample): proportion race

tab hisp2011 
svy, subpop(sample): proportion hisp2011

tab age2011 
svy, subpop(sample): prop agecat_11

sum age2011 
svy, subpop(sample): mean age2011
estat sd

//Psychological or emotional well-being
svy, subpop(sample): prop lifesat2011_bin

//Physical health characteristics
svy, subpop(sample): prop goodhlth_11 
svy, subpop(sample): prop doc_pstyr
svy, subpop(sample): prop smoke11
svy, subpop(sample): prop fight11_bin

//Civic engagement factors
svy, subpop(sample): prop voted_2010
svy, subpop(sample): prop volunteer_2011

//Healthy family and social relationships factors
svy, subpop(sample): prop artact_11
svy, subpop(sample): prop schclub_11
svy, subpop(sample): prop sports_11
svy, subpop(sample): prop closep_bin
svy, subpop(sample): prop friendprod
svy, subpop(sample): mean edsscore
estat sd

//Life skills factors
svy, subpop(sample): prop probsolv_bin
svy, subpop(sample): prop moneymng_bin

//Ethical behavior factors
svy, subpop(sample): prop respactions
svy, subpop(sample): prop dui_bin

//Constructive engagmeent in education, training, or occupation factors
svy, subpop(sample): prop higheduc
svy, subpop(sample): prop employed

gen higheduc2=.
replace higheduc2=0 if (higheduc==0|higheduc==1)
replace higheduc2=1 if higheduc==2
replace higheduc2=2 if higheduc==3
tab higheduc2

svy, subpop(sample): prop higheduc2

//Adolescent flourishing
svy, subpop(sample): prop flourish_2002

***univariate and measures of central tendency for RQ1***
sum contmh11, d /*unweighted*/
svy, subpop(sample): mean contmh11
estat sd

tabulate posmh_2011 /*unweighted*/
svy, subpop(sample): proportion flourish_2011
svy, subpop(sample): proportion posmh_2011 

svy, subpop(sample): proportion posmh_2011 if agecat_11==0
svy, subpop(sample): proportion posmh_2011 if agecat_11==1

tabulate posmh_2002 /*unweighted*/
svy, subpop(sample): proportion posmh_2002

tabulate flourish_2002 /*unweighted*/
svy, subpop(sample): proportion flourish_2002

svy, subpop(sample): proportion posmh_2002 if agecat_02==0
svy, subpop(sample): proportion posmh_2002 if agecat_02==1

tabulate change /*unweighted*/
svy, subpop(sample): proportion change
svy, subpop(sample): proportion mhstatus

***********BIVARIATE CORRELATES OF POSITIVE MENTAL HEALTH IN YA*****************

/*svy, subpop(sample): tabulate flourish_2011 male, obs pearson
svy, subpop(sample): logit flourish_2011 male, or*/ 

/*svy, subpop(sample): mean age2011, over(flourish_2011) 
mat li e(b)
test _b[c.age2011@0.flourish_2011] = _b[c.age2011@1.flourish_2011]
svy, subpop(sample): logit flourish_2011 age2011, or*/ 

svy, subpop(sample): logit flourish_2011 age2011, or 
svy, subpop(sample): logit flourish_2011 i.race, or 
svy, subpop(sample): logit flourish_2011 male, or 
svy, subpop(sample): logit flourish_2011 hisp2011, or 

//Psychological or emotional well-being characteristics
correlate contmh11 revlifesat_2011 if sample==1 /*r=.3602*/
correlate avgemot revlifesat_2011 if sample==1 /*r=.3978*/
correlate avgpsyc revlifesat_2011 if sample==1 /*r=.2830*/

svy, subpop(sample): logit flourish_2011 lifesat2011_bin, or

//Physical health characteristics
svy, subpop(sample): logit flourish_2011 goodhlth_11, or 
svy, subpop(sample): logit flourish_2011 doc_pstyr, or
svy, subpop(sample): logit flourish_2011 smoke11, or
svy, subpop(sample): logit flourish_2011 fight11_bin, or

//Civic engagement factors
tab1 voted_2010 volunteer_2011 
svy, subpop(sample): logit flourish_2011 voted_2010, or
svy, subpop(sample): logit flourish_2011 volunteer_2011, or

//Healthy family and social relationships factors
alpha courtesy_2011 service_2011 stupid_2011 afraid_2011 dishonest_2011 superior_2011 respect_2011 if sample==1, std

svy, subpop(sample): logit flourish_2011 artact_11, or
svy, subpop(sample): logit flourish_2011 schclub_11, or
svy, subpop(sample): logit flourish_2011 sports_11, or
svy, subpop(sample): logit flourish_2011 closep_bin, or
svy, subpop(sample): logit flourish_2011 friendprod, or
svy, subpop(sample): logit flourish_2011 edsscore, or

//Life skills factors
svy, subpop(sample): logit flourish_2011 probsolv_bin, or
svy, subpop(sample): logit flourish_2011 moneymng_bin, or

//Ethical behavior factors
svy, subpop(sample): logit flourish_2011 respactions, or
svy, subpop(sample): logit flourish_2011 dui_bin, or

//Constructive engagmeent in education, training, or occupation factors
svy, subpop(sample): logit flourish_2011 i.higheduc, or
svy, subpop(sample): logit flourish_2011 ib1.higheduc2, or /*using some college as reference*/
svy, subpop(sample): logit flourish_2011 employed, or

//Adolescent flourishing
svy, subpop(sample): logit flourish_2011 flourish_2002, or

//MULTIVARIABLE MODEL
svy, subpop(sample): logit flourish_2011 age2011 i.race male hisp2011 lifesat2011_bin goodhlth_11 doc_pstyr smoke11 fight11_bin voted_2010 volunteer_2011 artact_11 schclub_11 sports_11 closep_bin friendprod edsscore probsolv_bin moneymng_bin respactions dui_bin ib1.higheduc2 employed flourish_2002, or

***Without adolescent flourishing to see if similar results with and without the 51 who had missing data in 2002***
svy, subpop(sample): logit fflourish_2011 age2011 i.race male hisp2011 lifesat2011_bin goodhlth_11 doc_pstyr smoke11 fight11_bin voted_2010 volunteer_2011 artact_11 schclub_11 sports_11 closep_bin friendprod edsscore probsolv_bin moneymng_bin respactions dui_bin i.higheduc employed, or
