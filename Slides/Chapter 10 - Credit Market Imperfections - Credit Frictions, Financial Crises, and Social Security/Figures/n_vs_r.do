clear
import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 10 - Credit Market Imperfections - Credit Frictions, Financial Crises, and Social Security/Figures/fredgraph(1).xls", sheet("FRED Graph") cellrange(A12:C203) firstrow clear
generate mofd = mofd(observation)
tsset mofd, monthly
rename POPTHM pop
generate n = (pop/L12.pop-1)*100
tsline n FEDFUNDS, title("Population Growth vs. Interest Rates") xtitle("Date") ytitle("Interest Rate, Population Growth") legend( lab(1 "Population Growth") lab(2 "Nominal Interest Rate"))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 10 - Credit Market Imperfections - Credit Frictions, Financial Crises, and Social Security/Figures/n_vs_pi.png", replace
