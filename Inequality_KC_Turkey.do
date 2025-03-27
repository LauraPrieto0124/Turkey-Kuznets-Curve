* Workspace initialization and data import

clear all 
cls
set more off

cd "C:\Users\lcpri\OneDrive\Documentos\Research_projects\Turkey_Inequality_KC" 

import delimited "C:\Users\lcpri\OneDrive\Documentos\Research_projects\Turkey_Inequality_KC\initial_year.csv", clear

* Creating spatial interactions

gen lnpopdens_int= lnpopdens_adnk * w_lnpopdens_adnk 
gen dep_ratio_int = dep_ratio * w_dep_ratio
gen exp_share_int = exp_share * w_exp_share
gen tertiary_share_int = tertiary_share * w_tertiary_share
gen sharegovexp_tot_int= sharegovexp_tot * w_sharegovexp_tot
gen ln_gdp_pc_int= ln_gdp_pc * w_ln_gdp_pc
gen ln_gdp_pc_2_int = ln_gdp_pc_2 * w_ln_gdp_pc_2
gen agriculture_share_int = agriculture_share * w_agriculture_share
gen industry_share_int = industry_share * w_industry_share
gen service_share_int= service_share * w_service_share
gen ln_credit_pc_int = ln_credit_pc * w_ln_credit_pc
gen ln_inv_pc_int = ln_inv_pc * w_ln_inv_pc
gen mortality_rate_int = mortality_rate * w_mortality_rate
gen fertility_rate_int = fertility_rate * w_fertility_rate

* Labeling variables and initial exploration

label variable lnpopdens_adnk "Population density"
label variable dep_ratio "Dependency ratio"
label variable exp_share "Export share"
label variable tertiary_share "Tertiary share"
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

label variable lnpopdens_int "Population density spatial lag interaction"
label variable dep_ratio_int "Dependency ratio spatial lag interaction"
label variable exp_share_int "Export share spatial lag interaction"
label variable tertiary_share_int "Tertiary share spatial lag interaction"
label variable sharegovexp_tot_int "Share of government expenditure spatial lag interaction"
label variable ln_gdp_pc_int "GDP per capita (ln) spatial lag interaction"
label variable ln_gdp_pc_2_int "GDP per capita (ln) (sq) spatial lag interaction"
label variable agriculture_share_int "Agriculture share spatial lag interaction"
label variable industry_share_int "Industry share spatial lag interaction"
label variable service_share_int "Service share spatial lag interaction"
label variable ln_credit_pc_int "Total credits pc (ln) spatial lag interaction"
label variable ln_inv_pc_int "Total investment pc (ln) spatial lag interaction"
label variable mortality_rate_int "Mortality rate spatial lag interaction"
label variable fertility_rate_int "Fertility rate spatial lag interaction"


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
 
* Basic OLS using gini_area

regress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2  ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate 
 
estimates store Basic_OLS 
 
vif
 
regress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate 
 
estimates store SLX
 
vif

regress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate ///
 lnpopdens_int dep_ratio_int exp_share_int tertiary_share_int ///
 sharegovexp_tot_int ln_gdp_pc_int ln_gdp_pc_2_int agriculture_share_int ///
 industry_share_int service_share_int ln_credit_pc_int ln_inv_pc_int ///
 mortality_rate_int fertility_rate_int
 
estimates store SLX_interactions

vif

esttab Basic_OLS SLX SLX_interactions using OLS_models_gini_area.csv, replace stats(N r2 r2_a) star(* 0.05 ** 0.01 *** 0.001) label

* Basic OLS using gini_area

regress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2  ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate 
 
estimates store Basic_OLS
 
vif
 
regress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate 
 
estimates store SLX
 
vif

regress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate ///
 lnpopdens_int dep_ratio_int exp_share_int tertiary_share_int ///
 sharegovexp_tot_int ln_gdp_pc_int ln_gdp_pc_2_int agriculture_share_int ///
 industry_share_int service_share_int ln_credit_pc_int ln_inv_pc_int ///
 mortality_rate_int fertility_rate_int
 
estimates store SLX_interactions

vif

esttab Basic_OLS SLX SLX_interactions using OLS_models_theil_area.csv, replace stats(N r2 r2_a) star(* 0.05 ** 0.01 *** 0.001) label

* BMA modeling gini_area

bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate

bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate
 
 
bmaregress gini_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate ///
 lnpopdens_int dep_ratio_int exp_share_int tertiary_share_int ///
 sharegovexp_tot_int ln_gdp_pc_int ln_gdp_pc_2_int agriculture_share_int ///
 industry_share_int service_share_int ln_credit_pc_int ln_inv_pc_int ///
 mortality_rate_int fertility_rate_int
 
bmagraph varmap

bmastats models, cumulative

* BMA modeling gini_area

bmaregress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate

bmaregress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate
 
 
bmaregress theil_area lnpopdens_adnk dep_ratio exp_share tertiary_share ///
 sharegovexp_tot ln_gdp_pc ln_gdp_pc_2 ///
 agriculture_share industry_share service_share ln_credit_pc ///
 ln_inv_pc mortality_rate fertility_rate ///
 w_lnpopdens_adnk w_dep_ratio w_exp_share w_tertiary_share w_sharegovexp_tot ///
 w_ln_gdp_pc w_ln_gdp_pc_2 ///
 w_agriculture_share w_industry_share w_service_share w_ln_credit_pc w_ln_inv_pc ///
 w_mortality_rate w_fertility_rate ///
 lnpopdens_int dep_ratio_int exp_share_int tertiary_share_int ///
 sharegovexp_tot_int ln_gdp_pc_int ln_gdp_pc_2_int agriculture_share_int ///
 industry_share_int service_share_int ln_credit_pc_int ln_inv_pc_int ///
 mortality_rate_int fertility_rate_int
 
bmagraph varmap

bmastats models, cumulative
 
* Evaluating mulicolinearity problem

regress ln_gdp_pc_2 exp_share ///
 sharegovexp_tot ln_gdp_pc

regress ln_gdp_pc ln_gdp_pc_2 


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



























