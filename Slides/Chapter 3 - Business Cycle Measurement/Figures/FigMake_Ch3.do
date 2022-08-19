clear
import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/Ch3_Freddata.xls", sheet("FRED Graph") cellrange(A18:I351) firstrow clear
*GDPC1	Real Gross Domestic Product, Billions of Chained 2012 Dollars, Quarterly, Seasonally Adjusted Annual Rate
*IMPGSC1	Real imports of goods and services, Billions of Chained 2012 Dollars, Quarterly, Seasonally Adjusted Annual Rate
*HOUST	New Privately-Owned Housing Units Started: Total Units, Thousands of Units, Quarterly, Seasonally Adjusted Annual Rate
*PCECC96	Real Personal Consumption Expenditures, Billions of Chained 2012 Dollars, Quarterly, Seasonally Adjusted Annual Rate
*GPDIC1	Real Gross Private Domestic Investment, Billions of Chained 2012 Dollars, Quarterly, Seasonally Adjusted Annual Rate
*GDPDEF	Gross Domestic Product: Implicit Price Deflator, Index 2012=100, Quarterly, Seasonally Adjusted
*PAYEMS	All Employees, Total Nonfarm, Thousands of Persons, Quarterly, Seasonally Adjusted
*UNRATE	Unemployment Rate, Percent, Quarterly, Seasonally Adjusted
	
rename GDPC1 Y
rename IMPGSC1 IM
rename HOUST H
rename PCECC96 C 
rename GPDIC1 I
rename GDPDEF P
rename PAYEMS L
rename UNRATE U

generate date = qofd(observation_date)
tsset date, quarterly
generate YoverL = Y/L
foreach var of varlist Y-L YoverL {
	generate ln`var' = log(`var')
	tsfilter hp ln`var'_hp = ln`var'
	regress ln`var' L9.ln`var'  L10.ln`var'  L11.ln`var' L12.ln`var' 
	predict ln`var'_ham , resid
	replace ln`var'_hp = ln`var'_hp*100
	replace ln`var'_ham = ln`var'_ham*100

	generate ln`var'_hptrend = ln`var'-ln`var'_hp
	generate ln`var'_hamtrend = ln`var'-ln`var'_ham
}

generate pi = 100*(P/L4.P-1)
local date1 = quarterly("01-1974","QY")
local date2 = quarterly("01-1981","QY")+4
local date3 = quarterly("01-1990","QY")+3
local date4 = quarterly("01-2001","QY")+3
local date5 = quarterly("01-2008","QY")
local date6 = quarterly("01-2020","QY")-12

sum lnY_ham 
tsline lnY_hp lnY_ham, title("Pct. Deviation from Trend in Real GDP 1947-2021") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "HP Filter") lab(2 "Hamilton Filter")) text( -10 `date1' "1974-1975" -8 `date2'  "1981-1982" -5 `date3'  "1990-1991" -3.5 `date4'  "2001" -8 `date5'  "2008-2009" -10 `date6'  "2020")
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt2.png", replace

tsline lnY_hp lnIM_ham, title("Imports and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Imports")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt5.png", replace

scatter  lnY_ham lnIM_ham, title("Scatter Plot of Imports and GDP") xtitle("Percent Deviation from Trend: GDP") ytitle("Percent Deviation from Trend: Imports") graphregion(color(white)) plotregion(color(white))  legend(off) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt6.png", replace

replace lnH_ham = lnH_ham/10
tsline lnY_ham lnH_ham if lnY_ham ~= . & lnH_ham ~= ., title("Housing and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Housing/10")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt8.png", replace
replace lnH_ham = lnH_ham*10

tsline lnY_ham lnC_ham if lnY_ham ~= . & lnC_ham ~= ., title("Consumption and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Consumption")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt9.png", replace

tsline lnY_ham lnI_ham if lnY_ham ~= . & lnI_ham ~= ., title("Real Investment and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Investment")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt10.png", replace

tsline lnY_ham lnP_ham if lnY_ham ~= . & lnP_ham ~= ., title("Price Level and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Price Index")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt11.png", replace

tsline lnY_ham pi if lnY_ham ~= . & pi ~= ., title("Inflation and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Inflation")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt12.png", replace

tsline lnY_ham lnL_ham if lnY_ham ~= . & lnL_ham ~= ., title("Employment and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Employment")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt13.png", replace
local date1 = quarterly("01-1991","QY")+4
local date2 = quarterly("01-2001","QY")+6
local date3 = quarterly("01-2010","QY")+2

tsline lnL if date>=quarterly("01-1970","QY"), title("Jobless Recoveries") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(off) text( 11.575 `date1' "First"  11.77 `date2' "Second"  11.75 `date3' "Third")
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt14.png", replace


tsline lnY_ham lnYoverL_ham if lnY_ham ~= . & lnYoverL_ham ~= ., title("Productivity and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Average Labor Productivity")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt15.png", replace


preserve
use "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/CRSP_stockreturns.dta", clear
generate stockindex_end = 1*(1+vwretd) if _n == 1
replace stockindex_end = stockindex_end[_n-1]*(1+vwretd)/(1+pi/100) if _n > 1
generate lnstockind = log(stockindex_end)
generate mofd = mofd(date)
generate qofd = qofd(date)
tsset mofd, monthly
regress lnstockind L23.lnstockind L24.lnstockind L25.lnstockind L26.lnstockind
predict lnstockind_ham , resid
keep  lnstockind_ham qofd
collapse (mean) lnstockind_ham , by(qofd)
rename qofd date
tempfile temp
save `temp', replace
restore
merge 1:1 date using `temp'

replace lnstockind_ham = lnstockind_ham*100/5
tsline lnY_ham lnstockind_ham if lnY_ham ~= . & lnstockind_ham ~= ., title("Stock Market and GDP") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "GDP") lab(2 "Stock/5")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/StockvsGDP.png", replace

replace lnstockind_ham = lnstockind_ham*5
corr lnY_ham lnC_ham lnI_ham lnL_ham lnYoverL_ham lnP_ham lnH_ham lnstockind_ham
sum lnY_ham
local temp = `r(sd)'
foreach var of varlist lnC_ham lnI_ham lnL_ham lnYoverL_ham lnP_ham lnH_ham lnstockind_ham {
	qui sum `var'
	qui local temp2 = `r(sd)'/`temp'
	di "`var' `temp2'"
}
asdf
import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/Ch3_FredData2.xls", sheet("FRED Graph") cellrange(A12:C902) firstrow clear
generate date = mofd(observation)
tsset date
tsline UNRATE UNRATENSA if date>= monthly("1990-01","YM"), title("Seasonally Adjusted and Unadjusted Unemployment Rate") xtitle("Quarter") ytitle("Unemployment Rate") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "Adjusted") lab(2 "Unadjusted")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fig_3pt16.png", replace




import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/Ch3_FredData3.xls", sheet("FRED Graph") cellrange(A15:H905) firstrow clear
rename EMRATIO epop_ratio_all
rename LNS12300060 epop_ratio_2554
rename LNS12300002 epop_ratio_women
rename LNS12300001 epop_ratio_men
rename G date_men
rename LREM25MAUSA156S epop_ratio_men_1564
format %tdCY observation 
twoway line epop_ratio_all observation, title("Employment to Population Ratio") xtitle("Quarter") ytitle("Percent") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "All")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/EmPop1.png", replace

twoway line epop_ratio_men observation || line epop_ratio_women observation, title("Employment to Population Ratio") subtitle("by gender") xtitle("Year") ytitle("Percent") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "Men") lab(2 "Women")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/EmPop2.png", replace

twoway line epop_ratio_all epop_ratio_2554 observation , title("Employment to Population Ratio") subtitle("all vs 15-64") xtitle("Year") ytitle("Percent") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "All") lab(2 "Aged 15-64")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/EmPop3.png", replace

