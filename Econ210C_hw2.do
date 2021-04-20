*------------------------------------------------------------------------------*
*                               Homework 2                                     *
*------------------------------------------------------------------------------*


clear all
set maxvar 32767
set more off

*Local working directory where the data is stored
cd "C:/Users/Kurtis/Documents/Classes/Spring 2021/Macro/Homework 2"

*-------------------------------Problem 1: VARs -------------------------------*

***Clean and plot data***
freduse UNRATE DFF GDPDEF // download data from FRED

gen quarter = qofd(daten) // create quarter variable
format quarter %tq

collapse (mean) UNRATE DFF GDPDEF, by(quarter) // transform into quarterly data

tsset quarter 

gen pi_def = 100*((GDPDEF - l4.GDPDEF)/l4.GDPDEF) // inflation rate

lab var UNRATE "Unemployment Rate"
lab var DFF "Federal Funds Rate"
lab var pi_def "Y/Y Inflation (GDP Deflator)"

tsline UNRATE DFF pi_def, // plot time series
graph export "timeseries.png", replace

***Vector Auto-Regression***
gen R = DFF - pi_def // real interest rate

gen insample = quarter < yq(2008,1) & quarter >= yq(1960,1) // end sample before 2008

var pi_def UNRATE R if insample, lag(1/4) // estimate VAR with 4 lags

***Estimate structural monetary shocks and plot***
predict e1, resid equation(pi_def) // extract residuals
predict e2, resid equation(UNRATE)
predict e3, resid equation(R)

mat omega = e(Sigma) // Cholesky decomposition
mat S = cholesky(omega)
mat invS = inv(S)

gen epsilon1 = invS[1,1]*e1 // Use cholesky decomposition to get structural shocks
gen epsilon2 = invS[2,1]*e1 + invS[2,2]*e2
gen epsilon3 = invS[3,1]*e1 + invS[3,2]*e2 + invS[3,3]*e3 

lab var epsilon1 "Shock to Inflation"
lab var epsilon2 "Shock to Unemployment Rate"
lab var epsilon3 "Shock to Federal Funds Rate"

tsline epsilon3 if insample // plot timeseries
graph export "monetaryshocks.png", replace

***Impulse response functions***
cap irf drop v1, set(irf_simple)
irf create v1, step(20) set(irf_simple) replace
irf graph oirf, impulse(pi_def UNRATE R) response(pi_def UNRATE R) yline(0,lcolor(black)) xlabel(0(4)20) byopts(yrescale)
graph export "irf.png", replace









