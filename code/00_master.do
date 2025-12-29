/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       00_master.do
    Purpose:    Master file - runs all analysis in order
    Author:     Jun
    Created:    December 2024
    
    Description:
    This project analyzes the effect of minimum wage on employment using
    County Business Patterns data (2017, 2020) and state minimum wage data.
    
    To replicate:
    1. Set the file path below to your project folder
    2. Run this file
==============================================================================*/

* SET YOUR FILE PATH HERE
global path "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"
cd "$path"

clear all
set more off

*===============================================================================
* RUN ALL DO-FILES IN ORDER
*===============================================================================

* Step 1: Explore raw data
do "code/01_explore_data.do"

* Step 2: Clean and merge data
do "code/02_clean_cbp.do"

* Step 3: Descriptive statistics and figures
do "code/05_descriptives.do"

* Step 4: Regression analysis
do "code/06_regressions.do"

*===============================================================================
* DONE
*===============================================================================

display "====================================="
display "All analysis complete!"
display "Check output/ folder for results"
display "====================================="
