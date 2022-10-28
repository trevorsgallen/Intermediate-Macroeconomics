import excel "/Users/tgallen/Dropbox/Econ 352/Intermediate-Macroeconomics/Slides/Chapter 14 - New Keynesian Economics - Sticky Prices/Figures/fredgraph(1).xls", sheet("FRED Graph") cellrange(A13:D317) firstrow clear
generate qofd = qofd(observation_date)
tsset qofd, quarterly

rename DFF  i
rename GDPDEF P

generate pi = 100*((P/L.P)^(1/4)-1)

rename GDPC1 Y
generate lnY = log(Y)

regress lnY qofd if qofd >= quarterly("1988-01","YQ") & qofd <= quarterly("2007-01","YQ")
predict ybar, xb
tsfilter bk lny_bk = lnY
generate lnyfit = lnY-lny_bk

generate pidev = pi-0.02
generate lndev = lnY-ybar

regress i pidev lndev if qofd >= quarterly("1988-01","YQ") & qofd <= quarterly("2007-01","YQ")
predict ihat, xb
*nl (i - ({b0} + {api}*(pi-0.02)+{ay}*(lnY-ybar))) if qofd >= quarterly("1988-01","YQ") & qofd <= quarterly("2007-01","YQ")
*predict ihat, yhat

tsline i ihat if qofd >= quarterly("1988-01","YQ") & qofd <= quarterly("2016-01","YQ")
