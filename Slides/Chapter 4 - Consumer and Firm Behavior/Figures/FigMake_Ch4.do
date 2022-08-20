import excel "/Users/tg/Dropbox/Econ 352/Summer 2022/Figures/quarterly_tfp.xlsx", sheet("quarterly") cellrange(A2:AA2000) firstrow clear
split date, parse(":")
generate date_Q = quarterly(date1+"-"+subinstr(date2,"Q","",.),"YQ")
format %tq date_Q 
tsset date_Q
generate tfp = 1
replace tfp = (1+dtfp/100)^(1/4)*tfp[_n-1] if _n > 1
replace tfp = log(tfp)
tsline tfp, title("Total Factor Productivity over Time") xtitle("Quarter") ytitle("Log(TFP) (1947=1)") graphregion(color(white)) plotregion(color(white))  legend(off) 
graph export "~/Dropbox/Econ 352/Summer 2022/Figures/Fernald_TFP.png", replace
