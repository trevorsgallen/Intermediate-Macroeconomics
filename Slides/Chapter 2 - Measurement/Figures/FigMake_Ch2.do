cd "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 2 - Measurement/"
import delimited "Figures/Ch2_Freddata.csv", clear 
drop if cpiaucsl == .
split date, parse("/")
replace date1= "0"+date1 if length(date1)==1
replace date2= "0"+date2 if length(date1)==1
destring date3, replace
replace date3=1900+date3 if date3 >= 47
replace date3=2000+date3 if date3 < 47
tostring date3, replace
generate daydate = date(date1+"-"+date2+"-"+date3,"MDY")
generate quarter = qofd(daydate)
drop date date3 daydate
tsset quarter, quarterly

rename gdpdef P_GDP
rename cpiau P_CPI
rename ppiaco P_PPI

foreach var of varlist P_* {
	generate D_`var' = 100*(`var'/L4.`var'-1) 
}
tsline D_*, lcolor(black red gray) lpattern("" "" "-") xtitle("Quarter") ytitle("Percent Inflation") title("Inflation(s) Over Time")  graphregion(color(white)) plotregion(color(white)) legend(lab(1 "CPI") lab(2 "GDP Deflator") lab(3 "PPI") row(1))
graph export "Figures/Fig_CPIs.png", replace

twoway scatter  D_P_CPI D_P_PPI || lfit  D_P_CPI D_P_PPI , lcolor(red) || lfit  D_P_CPI D_P_CPI, lcolor(black) legend(lab(1 "Data") lab(2 "Fit") lab(3 "45 Degree Line") row(1)) graphregion(color(white)) plotregion(color(white)) xtitle("PPI Inflation") ytitle("CPI Inflation")  title("PPI moves more than CPI") 
graph export "Figures/Fig_CPIvPPI.png", replace
