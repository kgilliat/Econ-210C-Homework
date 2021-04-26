*------------------------------------------------------------------------------*
*                                  Run All                                     *
*------------------------------------------------------------------------------*
/*
Note: This file runs all the Stata and Matlab code for problem set 2
*/

clear all
set maxvar 32767
set more off

*Local working directory where the data is stored
cd "C:/Users/Kurtis/Documents/Classes/Spring 2021/Macro/Homework 2"

*Run Stata code
do Econ210C_hw2.do

*Runs 'matlab_filename.m' 
shell matlab -noFigureWindows -r "try; run('matlab_filename.m'); catch; end; quit"
di "Finished running matlab"
