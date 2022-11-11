import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/fredgraph-2.xls", sheet("FRED Graph") cellrange(A12:C262) firstrow clear
rename DFF R
rename CPI P
generate mofd = mofd(observation)
tsset mofd, monthly

generate piF = 100*(P/L12.P-1)
local temp = monthly("10-1979","MY")
tsline R piF if mofd >= monthly("01-1973","MY") & mofd <= monthly("12-1987","MY"), tline(`temp') title(`"The Volcker Shock"') graphregion(color(white)) plotregion(color(white)) xtitle("Year") ytitle("Percent") legend(lab(1 "R") lab(2 "i"))
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/VolckerShock.png", replace

twoway scatter piF R , title(`"Inflation vs Nominal Interest Rates"') graphregion(color(white)) plotregion(color(white)) xtitle("Nominal Interest Rates") ytitle("Inflation")  || lfit piF R, legend(off)
graph export "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 15 - Inflation - Phillips Curves and Neo-Fisherism/Figures/NeoFisher.png", replace 
