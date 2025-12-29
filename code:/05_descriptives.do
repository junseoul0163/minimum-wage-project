/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       05_descriptives.do
    Purpose:    Summary statistics and visualization
    Author:     Jun
    Created:    December 2024
==============================================================================*/

* Set working directory
cd "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"

clear all
set more off

*===============================================================================
* 1. LOAD DATA
*===============================================================================

use "data/clean/panel_final.dta", clear

* Quick look
describe
summarize

*===============================================================================
* 2. SCATTER PLOT: MINIMUM WAGE VS EMPLOYMENT
*===============================================================================

* Basic scatter plot
twoway scatter ln_emp minwage if year == 2020

*===============================================================================
* 3. CREATE EMPLOYMENT CHANGE VARIABLE
*===============================================================================

* Sort by state and year
sort fipstate year

* Create employment change (% change from 2017 to 2020)
by fipstate: gen emp_growth = (emp[2] - emp[1]) / emp[1] * 100 if year == 2020

* Create minimum wage change
by fipstate: gen minwage_change = minwage[2] - minwage[1] if year == 2020

* Look at the new variables
list state minwage_change emp_growth if year == 2020, clean

*===============================================================================
* 4. SCATTER PLOT: MINIMUM WAGE CHANGE VS EMPLOYMENT GROWTH
*===============================================================================

* Scatter plot with fitted line
twoway (scatter emp_growth minwage_change if year == 2020) ///
       (lfit emp_growth minwage_change if year == 2020), ///
       title("Minimum Wage Change vs Employment Growth (2017-2020)") ///
       xtitle("Change in Minimum Wage ($)") ///
       ytitle("Employment Growth (%)") ///
       legend(off)
	   
	   * Save the graph
graph export "output/figures/fig_minwage_emp_growth.png", replace

*===============================================================================
* 5. SUMMARY STATISTICS TABLE
*===============================================================================

* Basic summary stats
summarize minwage emp ln_emp est ap pay_per_emp if year == 2020

* More detailed stats
tabstat minwage emp ln_emp pay_per_emp if year == 2020, ///
        statistics(n mean sd min max) columns(statistics)
		
		*===============================================================================
* 6. EXPORT SUMMARY TABLE TO EXCEL
*===============================================================================

* Create summary stats and export
putexcel set "output/tables/summary_stats.xlsx", replace

* Add header row
putexcel A1 = "Variable" B1 = "N" C1 = "Mean" D1 = "SD" E1 = "Min" F1 = "Max"

* Add data rows
putexcel A2 = "Minimum Wage ($)"
putexcel A3 = "Employment"
putexcel A4 = "Log Employment"
putexcel A5 = "Pay per Employee ($1000s)"

* Calculate and add statistics
summarize minwage if year == 2020
putexcel B2 = (r(N)) C2 = (r(mean)) D2 = (r(sd)) E2 = (r(min)) F2 = (r(max))

summarize emp if year == 2020
putexcel B3 = (r(N)) C3 = (r(mean)) D3 = (r(sd)) E3 = (r(min)) F3 = (r(max))

summarize ln_emp if year == 2020
putexcel B4 = (r(N)) C4 = (r(mean)) D4 = (r(sd)) E4 = (r(min)) F4 = (r(max))

summarize pay_per_emp if year == 2020
putexcel B5 = (r(N)) C5 = (r(mean)) D5 = (r(sd)) E5 = (r(min)) F5 = (r(max))
