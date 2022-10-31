import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/fredgraph(3).xls", sheet("FRED Graph") cellrange(A13:D353) firstrow clear

rename NROU ustar
rename UNRATE u
rename CPI pi
generate mofd = mofd(observation)
tsset mofd, monthly

*generate pi = 100*(P/L12.P-1)
generate udiff = ustar-u

twoway line pi udiff if mofd >= monthly("2009-02","YM") , title("Phillips Curve") subtitle("2009-2022") graphregion(color(white)) plotregion(color(white)) xtitle("Ustar-U") ytitle("Inflation Rate")
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/PhillipsCurve1.png", replace

twoway line pi udiff , title("Phillips Curve") subtitle("1949-Present") graphregion(color(white)) plotregion(color(white)) xtitle("Ustar-U") ytitle("Inflation Rate")
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/PhillipsCurve2.png", replace
