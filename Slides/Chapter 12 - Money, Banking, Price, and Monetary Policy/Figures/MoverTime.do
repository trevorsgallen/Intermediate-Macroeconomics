import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 12 - Money, Banking, Price, and Monetary Policy/Figures/fredgraph-2.xls", sheet("FRED Graph") cellrange(A13:D777) firstrow clear
rename BOG M0
rename M1 M1
rename M2 M2
replace M0 = M0/1000
replace M1 = M1/1000
replace M2 = M2/1000
generate mofd = mofd(observation)
tsset mofd, monthly

tsline M0 M1 M2, graphregion(color(white)) plotregion(color(white)) title("Measures of Money") xtitle("Month") ytitle("Trillions of Dollars") legend(lab(1 "Monetary Base") lab(2 "M1") lab(3 "M2"))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 12 - Money, Banking, Price, and Monetary Policy/Figures/MoneyoverTime.png"
