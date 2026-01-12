/*==============================================================================
Author			: Chairunnisa Yulfianti
Assignment		: Thesis's Data Process
Last modified	: January 11th, 2026
Detailed		: 
11/1 clean the rapbd, the point is changing the long shape into the wide shape
12/1 after merging, doing some OLS Baseline Model, find out that DBH SDA is not random and districts rich in natural resources ≠ regencies without natural resources. Also, there is time-invariant heterogeneity (institutions, politics, fiscal capacity).
For FE Model found that DBH Gas Bumi partially affected the educational spending. Also, DBH Minyak Bumi partially and simultanly affected the educational spending.
==============================================================================*/

***Preparation***
clear all
set more off

cd "D:\Chairunnisa Yulfianti\Universitas Indonesia\Thesis_Progress\Data"

***import the csv file using the delimited command, not use as this is not .dta. Importing the rapbd data***
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

save "rapbd_pend_panel.dta", replace
clear

***import the tkdd data***
cd "D:\Chairunnisa Yulfianti\Universitas Indonesia\Thesis_Progress\Data"
import delimited "tkdd_2017-2025.csv", clear
describe

list in 1/10
replace component = "Singular" if component == "Total"
ta component

***summarise the value each component into each variable***
collapse (sum) value, by(district_id year variable)
list district_id year variable value in 1/20
isid district_id year variable 

***reshape from the long shape into the wide shape***
reshape wide value, i(district_id year) j(variable) string
rename valueminyak_bumi   dbh_minyak_bumi
rename valuegas_bumi      dbh_gas_bumi
rename valuepanas_bumi    dbh_panas_bumi
rename valueminerba       dbh_minerba
label var dbh_minyak_bumi "DBH Minyak Bumi (total components)"
label var dbh_gas_bumi    "DBH Gas Bumi (total components)"
label var dbh_panas_bumi  "DBH Panas Bumi (total components)"
label var dbh_minerba     "DBH Minerba (total components)"

save "tkdd_dbh_panel.dta", replace

***merging process***
merge 1:1 district_id year using "rapbd_pend_panel.dta"
ta _merge

/*===========================================================================Explaining Merging Output (Temporary)
Matched (3): 3.986 (87.18%) ✅
➜ Still okay for regression
➜ Districts-year that have RAPBD (Y) dan TKDD/DBH SDA

Master only (1): 505 (11.05%)
➜ Exist in RAPBD, not in TKDD
➜ Reason:
non-SDA districts, Bali is not exist in TKDD, but exist in RAPBD

Using only (2): 81 (1.77%)
➜ Exist in TKDD, not in RAPBD
➜ Reason:
Not-overlap years. TKDD data until 2025, but RAPBD only until 2024.
=============================================================================*/

***drop the unmatched data (still thinking how it will be later)***
keep if _merge == 3
drop _merge

***clean the variables***
gen belanja_total = belanja_pegawai + belanja_barang_jasa + belanja_modal + belanja_lainnya
label var belanja_total "Total Belanja Pendidikan (APBD)"

gen ln_belanja_total = ln(belanja_total)
label var ln_belanja_total "Log Total Belanja Pendidikan"

foreach v in belanja_pegawai belanja_barang_jasa belanja_modal belanja_lainnya {
    gen ln_`v' = ln(`v')
}
la var ln_belanja_pegawai "Log Belanja Pegawai"
la var ln_belanja_barang_jasa "Log Belanja Barang dan Jasa"
la var ln_belanja_modal "Log Belanja Modal"
la var ln_belanja_lainnya "Log Belanja Lainnya"

gen dbh_sda_total = dbh_minyak_bumi + dbh_gas_bumi + dbh_minerba + dbh_panas_bumi
label var dbh_sda_total "Total DBH SDA"

gen ln_dbhsda_total = ln(dbh_sda_total)
label var ln_dbhsda_total "Log Total DBH SDA"

foreach v in dbh_gas_bumi dbh_minerba dbh_minyak_bumi dbh_panas_bumi {
    gen ln_`v' = ln(`v')
}
la var ln_dbh_gas_bumi "Log DBH SDA Gas Bumi"
la var ln_dbh_minerba "Log DBH SDA Minerba"
la var ln_dbh_minyak_bumi "Log DBH SDA Minyak Bumi"
la var ln_dbh_panas_bumi "Log DBH SDA Panas Bumi"

summ ln_belanja_total, detail
summ ln_dbhsda_total, detail

save "tkdd_rapbd_thesis.dta", replace

***process the data***
///***OLS Baseline Model***///

reg ln_belanja_total ln_dbhsda_total i.year, robust
reg ln_belanja_total ln_dbhsda_total, vce(cluster district_id)

///***FE Model***///
xtreg ln_belanja_total ln_dbhsda_total, fe vce(cluster district_id)

xtreg ln_belanja_total ln_dbh_gas_bumi , fe vce(cluster district_id)
xtreg ln_belanja_total ln_dbh_minerba, fe vce(cluster district_id)
xtreg ln_belanja_total ln_dbh_minyak_bumi, fe vce(cluster district_id)
xtreg ln_belanja_total ln_dbh_panas_bumi, fe vce(cluster district_id)
