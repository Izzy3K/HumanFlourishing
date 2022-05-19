********************************************************************************
** Do-file: Merging PCG ids with Main PSID data; Merging Main data with CDS data
** Creator: Ashley Palmer
** Date: Created on 01/08/2021
** Updated: 
********************************************************************************
use "C:\Users\palmera\OneDrive - University of Texas at Arlington\Mental Health\Data\Data for 2020 Flourishing study\Main+PCG2001-02\cleanmain+pcgfile.dta", clear

***Step 1: Merge PCG ids with Main PSID 01 and PCG CDS 02 data***
merge 1:1 persid using idmergefile-pcg
keep if _merge==3
drop _merge

***Step 2: Merge Main PSID 01 and PCG CDS 02 data with CDS02 and TAS11 data***
merge 1:1 persid using "C:\Users\palmera\OneDrive - University of Texas at Arlington\Mental Health\Data\Data for 2020 Flourishing study\Child02+TAS11\clean-childvars.dta"
keep if _merge==3
drop _merge

***Step 3: Save as master file ***
save "C:\Users\palmera\OneDrive - University of Texas at Arlington\Mental Health\Data\Data for 2020 Flourishing study\masterfile.dta", replace 

