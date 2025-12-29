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
* 6. EXPORT SUMMARY TABLE
*===============================================================================

* Export using estout (more reliable)
ssc install estout, replace

* Create summary stats table and export
estpost summarize minwage emp ln_emp pay_per_emp if year == 2020

esttab using "output/tables/summary_stats.txt", ///
       cells("count mean sd min max") ///
       tab replace
	   
	   *===============================================================================
* 7. SUMMARY STATS BY YEAR
*===============================================================================

* Compare 2017 vs 2020
estpost tabstat minwage emp pay_per_emp, by(year) statistics(mean sd) columns(statistics)

esttab using "output/tables/summary_by_year.txt", ///
       cells("mean sd") ///
       tab replace
	   
	   *===============================================================================
* 8. BAR CHART: MINIMUM WAGE BY STATE (2020)
*===============================================================================

* Create bar chart of minimum wage by state
graph bar minwage if year == 2020, over(state, sort(1) label(angle(90) labsize(tiny))) ///
       title("Minimum Wage by State (2020)") ///
       ytitle("Minimum Wage ($)")

* Save
graph export "output/figures/fig_minwage_by_state.png", replace

*===============================================================================
* 9. BAR CHART: EMPLOYMENT GROWTH BY STATE
*===============================================================================

graph bar emp_growth if year == 2020, over(state, sort(1) label(angle(90) labsize(tiny))) ///
       title("Employment Growth by State (2017-2020)") ///
       ytitle("Employment Growth (%)")

graph export "output/figures/fig_emp_growth_by_state.png", replace

*===============================================================================
* 10. COMPARE HIGH VS LOW MINIMUM WAGE STATES
*===============================================================================

* Create indicator for high minimum wage states (above median)
summarize minwage if year == 2020, detail
gen high_minwage = (minwage > r(p50)) if year == 2020

* Compare employment growth: high vs low minimum wage states
graph bar emp_growth if year == 2020, over(high_minwage) ///
       title("Employment Growth: Low vs High Minimum Wage States") ///
       ytitle("Employment Growth (%)") ///
       blabel(bar, format(%4.1f)) ///
       legend(off) ///
       b1title("0 = Low MW States, 1 = High MW States")

graph export "output/figures/fig_high_vs_low_minwage.png", replace

*===============================================================================
* 11. SCATTER PLOT WITH STATE LABELS
*===============================================================================

* Create state abbreviation for cleaner labels
gen state_abbrev = substr(state, 1, 2)

* Scatter plot with labels
twoway (scatter emp_growth minwage_change if year == 2020, mlabel(state_abbrev) mlabsize(tiny)) ///
       (lfit emp_growth minwage_change if year == 2020), ///
       title("Minimum Wage Change vs Employment Growth") ///
       xtitle("Change in Minimum Wage ($)") ///
       ytitle("Employment Growth (%)") ///
       legend(off)

graph export "output/figures/fig_scatter_labeled.png", replace
