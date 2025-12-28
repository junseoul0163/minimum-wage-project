/*==============================================================================
    Project:    Minimum Wage and Employment
    File:       01_explore_data.do
    Purpose:    Load and explore raw CBP data
    Author:     Jun
    Created:    December 2024
==============================================================================*/

* Set working directory (CHANGE THIS TO YOUR PATH)
cd "/Users/heejunhwang/Documents/GitHub/minimum-wage-project"

* Clear everything
clear all
set more off

/*------------------------------------------------------------------------------
    1. Load one year of data to understand the structure
------------------------------------------------------------------------------*/

* Import 2023 CBP county data
import delimited "data/raw/cbp23co.txt", clear

* First look: what variables do we have?
described

* How many observations?
count

* Look at the first 20 rows
list in 1/20

* What does the data look like?
browse

/*------------------------------------------------------------------------------
    2. Understand key variables
------------------------------------------------------------------------------*/

* Summary statistics for numeric variables
summarize

* What industries are in the data? (NAICS codes)
tab naics in 1/100

* What states are represented?
tab fipstate

* Employment variable - check for missing/suppressed values
summarize emp
tab emp if emp == 0

/*------------------------------------------------------------------------------
    3. Quick data quality checks
------------------------------------------------------------------------------*/

* Are there duplicates at county-industry level?
duplicates report fipstate fipscty naics

* What does a suppressed/missing employment flag look like?
tab empflag

/*------------------------------------------------------------------------------
    4. Save your notes
------------------------------------------------------------------------------*/

* Log your findings (uncomment to use)
* log using "output/01_explore_log.txt", text replace
* [run your commands]
* log close
