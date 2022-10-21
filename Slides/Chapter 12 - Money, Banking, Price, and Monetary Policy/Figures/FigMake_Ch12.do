import excel "/Users/tgallen/Dropbox/Econ 352/Fall 2022/Slides/Figures/Ch12_Freddata.xls", sheet("FRED Graph") cellrange(A13:D267) firstrow clear
generate qofd = qofd(observation_date)
tsset qofd, quarterly
keep if M1SL ~= .
rename M1SL M
rename TB3MS R
rename GDP PY

generate lnMPY = log(M/PY)


twoway line  R lnMPY if qofd <= quarterly("1980-1","YQ"), xtitle("ln(M/PY)") ytitle("R") lpattern("-") lcolor(red) || line  R lnMPY if qofd >= quarterly("1980-1","YQ") & qofd <= quarterly("2019-4","YQ"),  lcolor(black) || line  R lnMPY if qofd >= quarterly("2019-4","YQ"),  legend(lab(1 "1959-1980") lab(2 "1980-2019") lab(3 "2019-2022")) graphregion(color(white)) plotregion(color(white)) lpattern("_") lcolor(blue) text( 10 -1.5 "Stable Money Demand") text(7.2 -2.25 "Unstable"  "Money" "Demand") text(2 -1 "???")
graph export "~/Dropbox/Econ 352/Fall 2022/Slides/Figures/Fig_12pt14.png", replace



import excel "/Users/tgallen/Dropbox/Econ 352/Fall 2022/Slides/Figures/Ch12_Freddata2.xls", sheet("FRED Graph") cellrange(A13:D248) firstrow clear
rename WSHOSHO All
rename WSHOMCB MBS
rename TREAST TBill
generate mofd = mofd(observation_date)
tsset mofd, monthly
drop if TBill == 0
foreach var of varlist All MBS TBill {
	replace `var' = `var'/1000000
}
local date1 = monthly("2008-8","YM")
local date2 = monthly("2010-8","YM")
local date3 = monthly("2012-8","YM")
local date4 = monthly("2018-10","YM")

format %tmCCYY mofd

tsline TBill MBS All if mofd <= monthly("2016-01","YM") , text(1 `date1' "QE1" 2.4 `date2' "QE2" 3 `date3' "QE3") graphregion(color(white)) plotregion(color(white)) title("Federal Reserve Assets over Time") xtitle("Date") ytitle("Trillions of Dollars") legend(lab(1 "Treasuries") lab(2 "Mortgage-Backed Securities") lab(3 "All"))
graph export "~/Dropbox/Econ 352/Fall 2022/Slides/Figures/Fig_12pt16a.png", replace

tsline TBill MBS All  , text(1 `date1' "QE1" 2.4 `date2' "QE2" 3 `date3' "QE3" 6 `date4' "QE Covid") graphregion(color(white)) plotregion(color(white)) title("Federal Reserve Assets over Time") xtitle("Date") ytitle("Trillions of Dollars") legend(lab(1 "Treasuries") lab(2 "Mortgage-Backed Securities") lab(3 "All"))
graph export "~/Dropbox/Econ 352/Fall 2022/Slides/Figures/Fig_12pt16b.png", replace


*MV=PY
import excel "/Users/tgallen/Dropbox/Econ 352/Fall 2022/Slides/Figures/Ch12_Freddata3.xls", sheet("FRED Graph") cellrange(A13:D315) firstrow clear
rename M1SL M
rename CPIAUCSL P
rename GDPC1 Y
replace M = M*1000000000
replace Y = Y*1000000000
generate qofd = qofd(observation_date)
tsset qofd, quarterly
drop if M == .
drop if Y == .
generate V = P*Y/M
count 
local temp = `r(N)'+20
set obs `temp'
replace qofd = qofd[_n-1]+1 if qofd == .
replace Y = Y[_n-1]*(1.02)^(1/4) if Y == .
replace M = M[_n-1]*0.99 if M == .
sum V if qofd >= quarterly("2019-01","YQ") & qofd <= quarterly("2019-04","YQ")
generate Valt = V
replace Valt = (1-0.995)*`r(mean)'+0.995*Valt[_n-1] if qofd > quarterly("2021-01","YQ")
*replace Valt = Valt[_n-1] if qofd > quarterly("2020-04","YQ")
generate Palt = M*Valt/Y
generate i = 100*(P/P[_n-4]-1)
generate ipred = 100*(Palt/Palt[_n-4]-1)
tsline ipred i

