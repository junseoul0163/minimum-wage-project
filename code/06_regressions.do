/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       06_regressions.do
    Purpose:    Regression analysis of minimum wage effects
    Author:     Jun
    Created:    December 2024
==============================================================================*/

cd "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"

clear all
set more off

*===============================================================================
* 1. LOAD DATA
*===============================================================================

use "data/clean/panel_final.dta", clear
**# Bookmark #1

describe
summarize

*===============================================================================
* 2. BASIC OLS REGRESSION
*===============================================================================

* Simple regression: log employment on minimum wage
regress ln_emp minwage

*===============================================================================
* 3. FIXED EFFECTS REGRESSION
*===============================================================================

* State fixed effects: control for all state-specific factors
regress ln_emp minwage i.fipstate

*===============================================================================
* 4. TWO-WAY FIXED EFFECTS (STATE + YEAR)
*===============================================================================

* Control for both state AND year effects
regress ln_emp minwage i.fipstate i.year

*===============================================================================
* 5. SAVE REGRESSION RESULTS IN A TABLE
*===============================================================================

* Store each regression for comparison
eststo clear

eststo m1: regress ln_emp minwage
eststo m2: regress ln_emp minwage i.fipstate
eststo m3: regress ln_emp minwage i.fipstate i.year

* Export comparison table
esttab m1 m2 m3 using "output/tables/regression_table.txt", ///
       keep(minwage _cons) ///
       b(4) se(4) ///
       star(* 0.10 ** 0.05 *** 0.01) ///
       title("Effect of Minimum Wage on Log Employment") ///
       mtitles("OLS" "State FE" "State + Year FE") ///
       replace
	   
	   *===============================================================================
* 6. CLUSTERED STANDARD ERRORS
*===============================================================================

* Same regression but with clustered standard errors by state
regress ln_emp minwage i.fipstate i.year, vce(cluster fipstate)

*===============================================================================
* 7. FINAL REGRESSION TABLE (WITH CLUSTERING)
*===============================================================================

eststo clear

eststo m1: regress ln_emp minwage, vce(cluster fipstate)
eststo m2: regress ln_emp minwage i.fipstate, vce(cluster fipstate)
eststo m3: regress ln_emp minwage i.fipstate i.year, vce(cluster fipstate)

esttab m1 m2 m3 using "output/tables/regression_final.txt", ///
       keep(minwage) ///
       b(4) se(4) ///
       star(* 0.10 ** 0.05 *** 0.01) ///
       title("Effect of Minimum Wage on Log Employment") ///
       mtitles("OLS" "State FE" "State + Year FE") ///
       note("Standard errors clustered by state in parentheses") ///
       replace
	   
	   *===============================================================================
* 8. DIFFERENCE-IN-DIFFERENCES
*===============================================================================

* Create treatment variable: states that raised minimum wage
sort fipstate year
by fipstate: gen mw_increase = (minwage[2] > minwage[1]) if year == 2020

* Fill in for 2017 observations too
by fipstate: egen treated = max(mw_increase)

* Check how many states raised MW
tab treated if year == 2020

* Create post-treatment indicator
gen post = (year == 2020)

* Diff-in-diff regression
regress ln_emp treated##post, vce(cluster fipstate)

* Add diff-in-diff to the regression table
eststo m4: regress ln_emp treated##post, vce(cluster fipstate)

esttab m1 m2 m3 m4 using "output/tables/regression_final.txt", ///
       keep(minwage 1.treated#1.post) ///
       b(4) se(4) ///
       star(* 0.10 ** 0.05 *** 0.01) ///
       title("Effect of Minimum Wage on Log Employment") ///
       mtitles("OLS" "State FE" "State + Year FE" "Diff-in-Diff") ///
       note("Standard errors clustered by state in parentheses") ///
       replace
	   
	   