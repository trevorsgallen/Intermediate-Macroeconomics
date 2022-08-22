import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/Ch5_Freddata2.xls", sheet("FRED Graph") cellrange(A13:D106) firstrow clear
rename GDPCA Y
rename PCECCA C
rename GCECA G
  generate lnY = log(Y)
generate lnC = log(C)
generate lnG = log(G)
generate yofd = yofd(observation)
tsset yofd, yearly
tsline lnY lnC lnG, title("GDP, Consumption and Government Expenditures") xtitle("Year") ytitle("Natural Log of Real Expenditures") graphregion(color(white)) plotregion(color(white))  legend(lab(1 "Y") lab(2 "C") lab(3 "G"))
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Y_C_G.png", replace


import delimited "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/NIPA_1_1_4.csv", delimiter(comma) stringcols(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114) encoding(ISO-8859-1)clear
keep if table114 == "1" 
local firstdate = quarterly("1947-Q1","YQ")
set trace off
di `firstdate'
foreach var of varlist v3-v302 {
	local firstdate = subinstr("`firstdate'","-","n",.)
	rename `var' data`firstdate'
	local firstdate = subinstr("`firstdate'","n","-",.)
	local ++firstdate
}
drop table
reshape long data, i(v2) j(quarter) str
destring data, replace
replace quarter = subinstr(quarter,"n","-",.)
destring quarter, replace
replace v2 = "P" if strmatch(v2,"*G*")==1
rename data data_
reshape wide data_, i(quarter) j(v2) str
tsset quarter, quarterly
tempfile temp2
save `temp2', replace

import delimited "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/NIPA_1_5_1.csv", delimiter(comma) stringcols(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114) encoding(ISO-8859-1)clear
keep if table115 == "1" | table115 == "22" | table115 == "23" | table115 == "26" | table115 == "24"
local firstdate = quarterly("1947-Q1","YQ")
set trace off
di `firstdate'
foreach var of varlist v3-v302 {
	local firstdate = subinstr("`firstdate'","-","n",.)
	rename `var' data`firstdate'
	local firstdate = subinstr("`firstdate'","n","-",.)
	local ++firstdate
}
drop table
reshape long data, i(v2) j(quarter) str
destring data, replace
replace quarter = subinstr(quarter,"n","-",.)
destring quarter, replace
replace v2 = "Y" if strmatch(v2,"*Gross domestic product*")==1
replace v2 = "GD" if strmatch(v2,"*defense*")==1
replace v2 = "GF" if strmatch(v2,"*Federal*")==1
replace v2 = "GS" if strmatch(v2,"*State*")==1
replace v2 = "G" if strmatch(v2,"*consumption expenditures*")==1
rename data data_
reshape wide data_, i(quarter) j(v2) str
tsset quarter, quarterly
tempfile temp
save `temp', replace

import delimited "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/NIPA_3_1.csv", delimiter(comma) stringcols(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114) encoding(ISO-8859-1)clear
keep if table31 == "1" | table31 == "20" | table31 == "21" | table31 == "22" | table31 == "23" | table31 == "27" | table31 == "30" 
local firstdate = quarterly("1947-Q1","YQ")
set trace off
di `firstdate'
foreach var of varlist v3-v302 {
	local firstdate = subinstr("`firstdate'","-","n",.)
	rename `var' data`firstdate'
	local firstdate = subinstr("`firstdate'","n","-",.)
	local ++firstdate
}
drop table
reshape long data, i(v2) j(quarter) str
destring data, replace
replace quarter = subinstr(quarter,"n","-",.)
destring quarter, replace
replace v2 = "G_expend" if strmatch(v2,"*Current expend*")==1
replace v2 = "G_consumption" if strmatch(v2,"*Consumption expenditures*")==1
replace v2 = "G_receipts" if strmatch(v2,"*Current rec*")==1
replace v2 = "G_transfer" if strmatch(v2,"*Current transfer*")==1
replace v2 = "G_social" if strmatch(v2,"*social*")==1
replace v2 = "G_interest" if strmatch(v2,"*Interest*")==1
replace v2 = "G_subsidies" if strmatch(v2,"*Subsidies*")==1
rename data data_
reshape wide data_, i(quarter) j(v2) str
tsset quarter, quarterly
merge 1:1 quarter using `temp'
drop _merge
merge 1:1 quarter using `temp2'

tsset quarter

generate Gfrac =data_G/data_Y
generate Gfrac2 = data_G_expend/data_Y

generate comp1 = data_G_consumption/data_Y
generate comp2 = data_G_transfer/data_Y
generate comp3 = data_G_interest/data_Y
generate comp4 = data_G_subsidies/data_Y


tsline Gfrac , title("Government Consumption and Investment over GDP") xtitle("Year") ytitle("Percent of GDP") graphregion(color(white)) plotregion(color(white)) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GoverY_1.png", replace

tsline Gfrac2 , title("Total Government Spending over GDP") xtitle("Year") ytitle("Percent of GDP") graphregion(color(white)) plotregion(color(white)) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GoverY_2.png", replace

tsline comp1 comp2 comp3 comp4 , title("Total Government Spending over GDP") xtitle("Year") ytitle("Percent of GDP") graphregion(color(white)) plotregion(color(white)) legend(lab(1 "Government Consumption") lab(2 "Government Transfer")  lab(3 "Government Interest Payments") lab(4 "Government Subsidies")) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GoverY_3.png", replace

generate real_receipts = data_G_receipts/(data_P/100)
generate real_expend = data_G_expend/(data_P/100)

generate receiptsovery =data_G_receipts/data_Y
generate expendovery = data_G_expend/data_Y
tsline real_receipts real_expend, title("Receipts and Expenditures") xtitle("Year") ytitle("Billions of Dollars") graphregion(color(white)) plotregion(color(white)) legend(lab(1 "Receipts") lab(2 "Expenditures")  ) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GoverY_4.png", replace

tsline receiptsovery expendovery, title("Receipts and Expenditures over GDP") xtitle("Year") ytitle("Billions of Dollars") graphregion(color(white)) plotregion(color(white)) legend(lab(1 "Receipts") lab(2 "Expenditures")  ) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GoverY_5.png", replace

generate fracfed = data_GF/data_G


preserve
	import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/quarterly_tfp.xlsx", sheet("quarterly") cellrange(A2:AA2000) firstrow clear
	drop if _n > 301
	split date, parse(":")
	generate date_Q = quarterly(date1+"-"+subinstr(date2,"Q","",.),"YQ")
	format %tq date_Q 
	tsset date_Q, quarterly
	generate tfp = 1
	generate gdp = 1
	replace tfp = (1+dtfp/100)^(1/4)*tfp[_n-1] if _n > 1
	replace gdp = (1+dY_prod/100)^(1/4)*tfp[_n-1] if _n > 1
	generate lngdp = log(gdp)
	generate lntfp = log(tfp)
	
	foreach var of varlist gdp tfp {
		regress ln`var' L9.ln`var'  L10.ln`var'  L11.ln`var' L12.ln`var' 
		predict ln`var'_ham , resid
		replace ln`var'_ham = ln`var'_ham*100

		generate ln`var'_hamtrend = ln`var'-ln`var'_ham
	}
	format %tqCY date_Q
	tsline lngdp_ham lntfp_ham, , title("GDP and TFP over the Business Cycle") xtitle("Quarter") ytitle("Percentage Deviation from Trend") graphregion(color(white)) plotregion(color(white)) legend(lab(1 "GDP") lab(2 "utilization-adjusted TFP")  ) 
	graph export "~/Dropbox/Econ 352/Summer 2022/Figures/GDP_TFP_buscycle.png", replace

	restore
