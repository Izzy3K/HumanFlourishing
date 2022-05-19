********************************************************************************
** Data from Main PSID 01, PCG CDS 02, Child CDS 02 & TAS 11 **
** Do-file: Cleaning and Exploring
** Creator: Ashley Palmer
** Date Created: 1/08/2021
** Updated: 6/30/2021
********************************************************************************

use "C:\Users\palmera\OneDrive - University of Texas at Arlington\Flourishing Mental Health\Analysis\Data\Data for Flourishing in YA study1\masterfile.dta", clear

svyset cluster, strata(stratum) weight(weight) vce(linearized) singleunit(certainty)

tab sample
tab posmh_2002
tab posmh_2011
browse sample posmh_2002 flourish_2002 age2002 posmh_2011 flourish_2011 age2011 ewb1_2011 ewb2_2011 ewb3_2011 swb1_2011 swb2_2011 swb3_2011 swb4_2011 swb5_2011 pwb1_2011 pwb2_2011 pwb3_2011 pwb4_2011 pwb5_2011 pwb6_2011 flr_fxing2011 lan_fxing2011 if ((posmh_2002~=.) & (posmh_2011~=.) & (age2002>=12 & age2002~=.))

replace posmh_2011=. if age2011==.
replace flourish_2011=. if age2011==.

tab posmh_2011
tab flourish_2011

tab posmh_2011 if sample==1
tab flourish_2011 if sample==1

save "C:\Users\palmera\OneDrive - University of Texas at Arlington\Flourishing Mental Health\Analysis\Data\Data for Flourishing in YA study1\masterfile.dta", replace 

//Bivariate tests of association between participating in both vs only CDS-II

use "C:\Users\palmera\OneDrive - University of Texas at Arlington\Flourishing Mental Health\Analysis\Data\Data for Flourishing in YA study1\masterfile.dta", clear 

svyset cluster, strata(stratum) weight(weight) vce(linearized) singleunit(certainty)

tab sample

svy: logit sample age2011, or
svy: logit sample male, or
svy: logit sample race, or
svy: logit sample hisp2011, or 
svy: logit sample i.higheduc, or 
svy: logit sample college, or 
svy: logit sample employed, or 
svy: logit sample flourish_2002, or 
svy: logit sample flourish_2011, or 
svy: logit sample k6scale, or /* not stat sig related */
svy: logit sample goodhlth_11, or

svy, subpop(sample): prop posmh_2011
svy, subpop(sample): prop posmh_2002


*******************************************************************************


