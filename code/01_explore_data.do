/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       01_explore_data.do
    Purpose:    Load and explore raw CBP data
    Author:     Jun
    Created:    December 2024
==============================================================================*/

* Set working directory (CHANGE THIS TO YOUR ACTUAL PATH)
cd "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"

* Clear everything
clear all
set more off

*===============================================================================
* 1. LOAD DATA
*===============================================================================
import delimited "data/raw/cbp23co.txt", clear

*===============================================================================
* 2. EXPLORE STRUCTURE
*===============================================================================
* What variables do we have?
describe

* How many observations?
count

* Summary statistics
summarize

* Check suppression flags
tab emp_nf

*===============================================================================
* 3. PRACTICE FILTERING
*===============================================================================
* Count by state
count if fipstate == 6
count if fipstate == 36

* Filter with multiple conditions
count if fipstate == 6 & emp > 1000

* Filter on text (industry)
count if substr(naics, 1, 3) == "722"

* Combined filters
summarize emp if fipstate == 6 & substr(naics, 1, 3) == "722"

*===============================================================================
* 4. CREATE NEW VARIABLES
*===============================================================================
* Calculations
gen annual_pay_per_emp = ap / emp
gen ln_emp = log(emp)

* Indicator variables
gen is_restaurant = (substr(naics, 1, 3) == "722")
gen is_california = (fipstate == 6)

* Categorical variable
gen emp_size = .
replace emp_size = 1 if emp > 0 & emp <= 50
replace emp_size = 2 if emp > 50 & emp <= 250
replace emp_size = 3 if emp > 250 & emp <= 1000
replace emp_size = 4 if emp > 1000

* Verify new variables
summarize annual_pay_per_emp ln_emp
tab is_restaurant
tab is_california
tab emp_size
