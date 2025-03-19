* Workspace initialization and data import

clear all 
cls
set more off

cd "C:\Users\lcpri\OneDrive\Documentos\Research_projects\Turkey_Inequality_KC" 

import delimited "C:\Users\lcpri\OneDrive\Documentos\Research_projects\Turkey_Inequality_KC\initial_year.csv", clear

* Labeling variables and initial exploration

label variable lnpopdens_adnk "Population density"
label variable dep_ratio "Dependency ratio"
label variable exp_share "Export share"
label variable tertiary_share "Share of university graduates"
label variable sharegovexp_tot "Share of government expenditure"
label variable ln_gdp_pc "GDP per capita (ln)"
label variable ln_gdp_pc_2 "GDP per capita (ln) (sq)"
label variable agriculture_share "Agriculture share"
label variable industry_share "Industry share"
label variable service_share "Service share"
label variable ln_credit_pc "Total credits pc (ln)"
label variable ln_inv_pc "Total investment pc (ln)"
label variable mortality_rate "Mortality rate"
label variable fertility_rate "Fertility rate"

describe
summarize

graph box ln_gdp_pc, mark(1, mlab(shapename))

graph box agriculture_share industry_share service_share, ///
          mark(1, mcolor(stgreen) mlab(shapename) mlabcolor(black) ///
		  mlabsize(vsmall) mlabposition(3)) ///
		  mark(2, mcolor(styellow) mlab(shapename) mlabcolor(black) ///
		  mlabsize(vsmall) mlabposition(3)) ///
		  mark(3, mcolor(stblue) mlab(shapename) mlabcolor(black) ///
		  mlabsize(vsmall) mlabposition(3)) ///
          box(1, color(stgreen)) ///
		  box(2, color(styellow)) ///
		  box(3, color(stblue))

graph box mortality_rate fertility_rate, ///
          mark(1, mlab(shapename) mlabcolor(black) ///
		  mlabsize(vsmall) mlabposition(3)) ///
		  mark(2, mlab(shapename) mlabcolor(black) ///
		  mlabsize(vsmall) mlabposition(3)) 	
		  

graph box giniw_pop theil_pop gini_area theil_area

histogram giniw_pop

graph box ln_credit_pc ln_inv_pc

twoway (scatter giniw_pop ln_gdp_pc, mcolor(stred)) (qfit giniw_pop ln_gdp_pc)

scatterfit giniw_pop ln_gdp_pc, controls(agriculture_share industry_share ///
 service_share lnpopdens_adnk mortality_rate fertility_rate) fit(quadratic)
 
* Basic OLS

regress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2  ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate 
 
vif
 
regress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate 
 
vif

* BMA modeling

bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate 

bmagraph varmap

bmastats models, cumulative
 
* Evaluating mulicolinearity problem

corr lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate
 
matrix C = r(C)
esttab matrix(C) using "correlaciones.csv"

 
* Strategies to solve multicolinearity promplem
 
summarize ln_gdp_pc
generate ln_gdp_pc_centered = ln_gdp_pc - r(mean)
generate ln_gdp_pc_centered_sq = ln_gdp_pc_centered^2

regress gini_area lnpopdens_adnk exp_share ///
 sharegovexp_tot ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share industry_share service_share ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_exp_share w_sharegovexp_tot ///
 w_agriculture_share w_industry_share w_service_share w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate
 
vif 

regress gini_area exp_share ///
 ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share ///
 ln_inv_pc mortality_rate ///
 w_exp_share ///
 w_agriculture_share w_ln_inv_pc
 
bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate
 
bmastats models, cumulative

bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate, mprior(betabinomial 5 1) 

bmastats models, cumulative
 
bmaregress gini_area exp_share ///
 ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share ///
 ln_inv_pc mortality_rate ///
 w_exp_share ///
 w_agriculture_share w_ln_inv_pc
 
bmagraph varmap

bmastats models, cumulative
 
bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc_centered ln_gdp_pc_centered_sq ///
 agriculture_share industry_share service_share ///
 ln_inv_pc mortality_rate

bmagraph varmap

bmastats models, cumulative