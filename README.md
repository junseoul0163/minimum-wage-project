# The Effect of Minimum Wage on Employment

An empirical analysis of minimum wage effects on state-level employment using STATA.

## Overview

This project examines whether minimum wage increases affect employment levels using data from the U.S. Census Bureau's County Business Patterns (CBP) and state minimum wage records. The analysis uses panel data methods including fixed effects and difference-in-differences estimation.

## Key Findings

**Minimum wage increases have no statistically significant effect on employment.**

- Simple OLS shows no relationship (coefficient: 0.008, p-value: 0.90)
- Two-way fixed effects (state + year) confirm no effect (coefficient: 0.001, p-value: 0.80)
- Difference-in-differences comparing states that raised minimum wage vs. those that didn't shows no significant difference (coefficient: -0.006, p-value: 0.37)

These findings are consistent with modern minimum wage research.

## Data Sources

1. **County Business Patterns (CBP)** — U.S. Census Bureau
   - Years: 2017, 2020
   - Variables: Employment, establishments, payroll by state
   - Source: https://www.census.gov/programs-surveys/cbp.html

2. **State Minimum Wage Data** — Department of Labor
   - Years: 1968-2020
   - Variables: State and federal minimum wage levels
   - Source: https://github.com/Lislejoem/Minimum-Wage-by-State-1968-to-2020

## Repository Structure

```
minimum-wage-project/
├── README.md
├── code/
│   ├── 00_master.do          # Run this to replicate all analysis
│   ├── 01_explore_data.do    # Data exploration
│   ├── 02_clean_cbp.do       # Data cleaning and merging
│   ├── 05_descriptives.do    # Summary statistics and figures
│   └── 06_regressions.do     # Regression analysis
├── data/
│   ├── raw/                  # Original data files (not tracked)
│   └── clean/                # Processed datasets
└── output/
    ├── tables/               # Regression tables
    └── figures/              # Graphs and visualizations
```

## How to Replicate

1. Clone this repository
2. Download raw data (see `data/raw/README.md` for instructions)
3. Open STATA and run:
   ```stata
   do "code/00_master.do"
   ```

## Methods

### Fixed Effects Regression

Controls for:
- **State fixed effects**: Removes time-invariant state characteristics (size, geography, industry mix)
- **Year fixed effects**: Removes economy-wide shocks affecting all states

### Difference-in-Differences

- **Treatment group**: 27 states that raised minimum wage (2017-2020)
- **Control group**: 24 states that kept minimum wage constant
- Compares employment growth between groups

## Output

### Figures
- Scatter plot: Minimum wage change vs. employment growth
- Bar chart: Minimum wage by state
- Bar chart: Employment growth by state
- Bar chart: High vs. low minimum wage state comparison

### Tables
- Summary statistics
- Summary by year (2017 vs. 2020)
- Regression results (OLS, State FE, State + Year FE, Diff-in-Diff)

## Software

- STATA 17 (or later)
- Required packages: `estout` (install via `ssc install estout`)

## Author

Jun Hwang  
Economics-Mathematics Major, Columbia University  
December 2025

## License

This project is for educational purposes.
