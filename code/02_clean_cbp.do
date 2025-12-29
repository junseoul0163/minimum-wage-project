/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       02_clean_cbp.do
    Purpose:    Clean CBP data and aggregate to state-year level
    Author:     Jun
    Created:    December 2024
==============================================================================*/

* Set working directory
cd "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"

clear all
set more off

*===============================================================================
* 1. LOAD AND CLEAN 2020 CBP DATA
*===============================================================================

* Load raw data
import delimited "data/raw/cbp20co.txt", clear

* Check what we have
describe
count

* Keep only total employment across all industries (naics == "------")
keep if naics == "------"

* How many counties?
count

* Keep only variables we need
keep fipstate fipscty emp est ap

* Check for missing
count if emp == .

*===============================================================================
* 2. COLLAPSE TO STATE LEVEL
*===============================================================================

* Before collapse - see what we have
list fipstate fipscty emp if fipstate == 6 in 1/10

* Collapse: sum employment and establishments by state
collapse (sum) emp est ap, by(fipstate)

* After collapse - one row per state
count
list in 1/10

*===============================================================================
* 3. ADD YEAR AND SAVE
*===============================================================================

* Add year variable
gen year = 2020

* Reorder variables
order fipstate year emp est ap

* Label variables
label variable fipstate "State FIPS code"
label variable year "Year"
label variable emp "Total employment"
label variable est "Total establishments"
label variable ap "Annual payroll ($1,000s)"

* Check final dataset
describe
list in 1/10

* Save
save "data/clean/cbp2020_state.dta", replace

*===============================================================================
* 4. REPEAT FOR 2017
*===============================================================================

import delimited "data/raw/cbp17co.txt", clear
keep if naics == "------"
keep fipstate fipscty emp est ap
collapse (sum) emp est ap, by(fipstate)
gen year = 2017
order fipstate year emp est ap
save "data/clean/cbp2017_state.dta", replace

*===============================================================================
* 5. REPEAT FOR 2023
*===============================================================================

import delimited "data/raw/cbp23co.txt", clear
keep if naics == "------"
keep fipstate fipscty emp est ap
collapse (sum) emp est ap, by(fipstate)
gen year = 2023
order fipstate year emp est ap
save "data/clean/cbp2023_state.dta", replace

*===============================================================================
* 6. COMBINE ALL YEARS INTO ONE PANEL
*===============================================================================

* Start with 2017
use "data/clean/cbp2017_state.dta", clear

* Append 2020 and 2023
append using "data/clean/cbp2020_state.dta"
append using "data/clean/cbp2023_state.dta"

* Sort and check
sort fipstate year
list in 1/15

* How many observations?
count

* Save the panel
save "data/clean/cbp_panel.dta", replace

*===============================================================================
* 7. MERGE WITH MINIMUM WAGE DATA
*===============================================================================

* Load CBP panel
use "data/clean/cbp_panel.dta", clear

* Merge with minimum wage data
merge 1:1 fipstate year using "data/clean/minwage_clean.dta"

* Check merge results
tab _merge

* Keep only matched observations
keep if _merge == 3

* Drop merge variable
drop _merge

* Check what we have
count
list in 1/15
describe

*===============================================================================
* 8. FINALIZE AND SAVE PANEL
*===============================================================================

* Create log employment (useful for regressions)
gen ln_emp = log(emp)

* Create pay per employee
gen pay_per_emp = ap / emp

* Label all variables
label variable fipstate "State FIPS code"
label variable year "Year"
label variable emp "Total employment"
label variable est "Total establishments"  
label variable ap "Annual payroll ($1,000s)"
label variable state "State name"
label variable minwage "Effective minimum wage ($)"
label variable ln_emp "Log employment"
label variable pay_per_emp "Annual pay per employee ($1,000s)"

* Sort and order
sort fipstate year
order fipstate state year minwage emp ln_emp est ap pay_per_emp

* Final check
describe
summarize

* Save final panel
save "data/clean/panel_final.dta", replace
