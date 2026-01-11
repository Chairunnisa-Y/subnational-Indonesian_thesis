/*==============================================================================
Author			: Chairunnisa Yulfianti
Assignment		: Thesis's Data Process
Last modified	: January 11th, 2026
Detailed		: 
11/1 clean the rapbd, the point is changing the long shape into the wide shape
==============================================================================*/

***Preparation***
clear all
set more off

cd "D:\Chairunnisa Yulfianti\Universitas Indonesia\Thesis_Progress\Data"

***import the csv file using the delimited command, not use as this is not .dta***
import delimited ///
"rapbd_2017-2024.csv", ///
clear

describe

***indicating some of duplicates data***
duplicates tag district_id year variable, gen(dup) /////could be run again after collapsing the duplicate, could be dropped later/////

ta dup
list district_id year variable value if dup > 0

***delete the duplication***
collapse (sum) value, by(district_id year variable)
isid district_id year variable /////ensure the district id are unique

***to ensure that the long shape still contains of four variables***
bys district_id year: gen n=_N
ta n

***reshape from the long shape into the wide shape***
tab variable
reshape wide value, i(district_id year) j(variable) string
rename valuebelanja_pegawai      belanja_pegawai
rename valuebelanja_barang_jasa  belanja_barang_jasa
rename valuebelanja_modal        belanja_modal
rename valuebelanja_lainnya      belanja_lainnya

***transform into panel data***
xtset district_id year
drop n

