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

* Load 2023 county data
import delimited "data/raw/cbp23co.txt", clear

* What variables do we have?
describe

* How many observations?
count

* Look at first 10 rows
list in 1/10

* Summary statistics
summarize
