import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 14 - New Keynesian Economics - Sticky Prices/Figures/fredgraph(2).xls", sheet("FRED Graph") cellrange(A12:E831) firstrow clear

generate t1 = mofd(observation_date)
format %tmCY t1
generate t2 = mofd(D)
format %tmCY t2

twoway line FEDFUNDS t1 if t1 > monthly("1988-01","YM") & t1 < monthly("2016-01","YM") || line GDPPOT t2 if t2 > monthly("1988-01","YM") & t2 < monthly("2016-01","YM"), sort title("Federal Funds and Taylor Rule") xtitle("Date") ytitle("Percent") legend(lab(1 "Federal Funds Rate") lab(2 "Taylor Rule")) graphregion(color(white)) plotregion(color(white))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 14 - New Keynesian Economics - Sticky Prices/Figures/FedFunds1.png", replace

twoway line FEDFUNDS t1 if t1 > monthly("1988-01","YM") & t1 < monthly("2022-12","YM") || line GDPPOT t2 if t2 > monthly("1988-01","YM") & t2 < monthly("2022-12","YM"), sort title("Federal Funds and Taylor Rule") xtitle("Date") ytitle("Percent") legend(lab(1 "Federal Funds Rate") lab(2 "Taylor Rule")) graphregion(color(white)) plotregion(color(white))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 14 - New Keynesian Economics - Sticky Prices/Figures/FedFunds2.png", replace

twoway line FEDFUNDS t1 if t1 > monthly("1954-01","YM") & t1 < monthly("2022-12","YM") || line GDPPOT t2 if t2 > monthly("1954-01","YM") & t2 < monthly("2022-12","YM"), sort title("Federal Funds and Taylor Rule") xtitle("Date") ytitle("Percent") legend(lab(1 "Federal Funds Rate") lab(2 "Taylor Rule")) graphregion(color(white)) plotregion(color(white))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 14 - New Keynesian Economics - Sticky Prices/Figures/FedFunds3.png", replace
