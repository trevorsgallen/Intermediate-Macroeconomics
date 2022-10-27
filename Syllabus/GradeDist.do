import excel "/Users/tg/Dropbox/Econ 352/Fall 2021/Syllabus/GradeDist.xlsx", sheet("Sheet1") firstrow clear
generate id = _n
local x = 1
foreach var of varlist Spring2015-Fall2018 {
rename `var' v`x'
local x = `x'+1
}
reshape long v, i(id) j(date)
tab v
generate GPA = 4.333 if v == "A+"
replace GPA = 4 if v == "A"
replace GPA = 3.666 if v == "A-"
replace GPA = 3.333 if v == "B+"
replace GPA = 3 if v == "B"
replace GPA = 2.666 if v == "B-"
replace GPA = 2.333 if v == "C+"
replace GPA = 2 if v == "C"
replace GPA = 1.666 if v == "C-"
replace GPA = 1.333 if v == "D+"
replace GPA = 1 if v == "D"
replace GPA = 0.666 if v == "D-"
replace GPA = 0 if v == "F" | v == "FN"
replace GPA = 1.666 if v == "N" | v == "NA"
replace GPA = 0 if v == "W" 
replace GPA = 2 if v == "I" | v == "P"
drop if GPA == .

set obs 1000
generate id2 = (_n-1)/999
generate GPAalt = 4.333 if id2 >= 0 & id2 <0.0326671401034798
replace GPAalt = 4 if id2 >= 0.0326671401034798 & id2 <0.183017145176017
replace GPAalt = 3.666 if id2 >= 0 & id2 <= 0.0322
replace GPAalt = 3.333 if id2 >= 0.183017145176017 & id2 <0.301714517601704
replace GPAalt = 3 if id2 >= 0.301714517601704 & id2 <0.415948057218221
replace GPAalt = 2.666 if id2 >= 0.415948057218221 & id2 <0.626052551486253
replace GPAalt = 2.333 if id2 >= 0.626052551486253 & id2 <0.723648168814041
replace GPAalt = 2 if id2 >= 0.723648168814041 & id2 <0.793243380338846
replace GPAalt = 1.666 if id2 >= 0.793243380338846 & id2 <0.908389976666328
replace GPAalt = 1.333 if id2 >= 0.908389976666328 & id2 <0.944100639139698
replace GPAalt = 1 if id2 >= 0.944100639139698 & id2 <0.955970376382266
replace GPAalt = 0.666 if id2 >= 0.955970376382266 & id2 <0.976057624023537
replace GPAalt = 0 if id2 >= 0.976057624023537 & id2 <=1










