import excel "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/fredgraph-3.xls", sheet("FRED Graph") cellrange(A15:F313) firstrow clear
rename observation_date t
generate date_Q = qofd(t)
tsset date_Q, quarterly
rename DSPIC96 DisInc 
rename GDPC1 Y
rename PCEC96 C
rename PCEPI P

foreach var of varlist DisInc-Debt {
generate ln`var' = log(`var')
tsfilter hp hp_ln`var' = ln`var'

}

foreach var of varlist lnY lnC lnDisInc {
	regress `var' L(1/8).`var'
	predict `var'_resid, resid
}
drop if date_Q < quarterly("2002-01","YQ")

tsline lnY lnC , legend(lab(1 "GDP") lab(2 "Consumption") lab(3 "Disposable Income")) graphregion(color(white)) plotregion(color(white)) title("Percent Deviation from Cyclical Trend")  ytitle("Log Billions of Dollars") xtitle("Quarter")
graph export "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/US_1.png", replace
tsline lnY  lnC lnDisInc, legend(lab(1 "GDP") lab(2 "Consumption") lab(3 "Disposable Income")) graphregion(color(white)) plotregion(color(white)) title("Percent Deviation from Cyclical Trend") 
graph export "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/US_2.png", replace

drop if date_Q < quarterly("2006-01","YQ")

tsline hp_lnY  hp_lnC hp_lnDisInc, legend(lab(1 "GDP") lab(2 "Consumption") lab(3 "Disposable Income")) graphregion(color(white)) plotregion(color(white)) title("Percent Deviation from Cyclical Trend") subtitle("HP-fitered") ytitle("Percent Deviation from Trend")
graph export "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/US_3.png", replace

tsline lnY_resid lnC_resid lnDisInc_resid, legend(lab(1 "GDP") lab(2 "Consumption") lab(3 "Disposable Income")) graphregion(color(white)) plotregion(color(white)) title("Percent Deviation from Cyclical Trend")  subtitle("Hamilton-fitered")  ytitle("Percent Deviation from Trend")
graph export "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/US_4.png", replace


import excel "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/PSAVERT.xls", sheet("FRED Graph") cellrange(A11:B762) firstrow clear
generate date_Q = mofd(observation)
tsset date_Q, monthly
tsline PSAVERT, graphregion(color(white)) plotregion(color(white)) title("Personal Savings Rate in US") xtitle("Month") ytitle("Savings Rate")
graph export "/Users/tg/Dropbox/Econ 352/Fall 2021/Covid19/US_5.png", replace
