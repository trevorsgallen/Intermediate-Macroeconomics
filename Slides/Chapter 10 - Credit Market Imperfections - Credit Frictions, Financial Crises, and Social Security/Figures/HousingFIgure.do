import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 10 - Credit Market Imperfections - Credit Frictions, Financial Crises, and Social Security/Figures/fredgraph-3.xls", sheet("FRED Graph") cellrange(A12:C203) firstrow clear
rename PCE C
rename USSTHPI p
generate lnC = log(C)
generate lnP = log(p)
generate qofd = qofd(observation_date)
tsset qofd, quarterly
tsfilter hp lnC_HP lnP_HP = lnC lnP
replace lnC_HP = lnC_HP*100
replace lnP_HP = lnP_HP*100
tsline lnP_HP lnC_HP, legend(lab(1 "Housing Prices") lab(2 "Consumption")) title("Housing Price and Consumption") ytitle("Percent Deviation from Trend") graphregion(color(white)) plotregion(color(white))
	graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 10 - Credit Market Imperfections - Credit Frictions, Financial Crises, and Social Security/Figures/H1.png", replace
	
scatter lnP_HP lnC_HP, title("Housing Price and Consumption") ytitle("Housing Price Deviation") xtitle("Consumption Deviation") graphregion(color(white)) plotregion(color(white))
	graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 10 - Credit Market Imperfections - Credit Frictions, Financial Crises, and Social Security/Figures/H2.png", replace
