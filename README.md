# Subnational Data of Indonesia

This repository documents an ongoing effort to construct a reproducible data infrastructure for empirical research on **subnational public finance in Indonesia**, with a focus on **district- and city-level (kabupaten/kota) DBH SDA data**.

The project is developed as methodological support for a master’s thesis and related academic work, emphasizing transparent data acquisition, structured documentation, and replicable workflows.

---

## Project Status

This repository is **work in progress**.

At the current stage, the project focuses on:
- Programmatic data retrieval
- File organization and documentation
- Preparation for subsequent data cleaning, harmonization, and analysis

Additional datasets and processing stages will be incorporated gradually as the research progresses.

---

## Data Coverage and Scope

The repository currently includes workflows for:
- **Transfer ke Daerah dan Dana Desa (TKDD)** data
- Fiscal years **2017–2025**
- Nationwide coverage at the kabupaten/kota level

Planned extensions include:
- APBD expenditure data
- Functional expenditure classification (education focus)
- Integration with additional socioeconomic indicators

---

## Data Sources

All data used in this project originate from official Indonesian government sources:

- **Directorate General of Fiscal Balance (DJPK), Ministry of Finance**
  - TKDD and APBD datasets  
  - Source: https://djpk.kemenkeu.go.id

---

## Data Access and Publication Notes

Raw fiscal datasets and large output files are **not publicly distributed** through this repository due to **data access limitations and publication considerations**.

In addition, the DJPK portal does not support fully automated bulk downloads for all data types and fiscal years. As a result, data acquisition involves a combination of programmatic retrieval and structured manual steps, which are documented in the notebooks provided.

Researchers interested in replication details or underlying data may **contact the author for further information**.

---

## Repository Structure

subnational-Indonesian_thesis/
│
├── 01_tkdd_data_collection.ipynb
│ └── Data retrieval and initial structuring of TKDD data (2017–2025)
│
└── README.md

The structure is designed to remain modular and expandable as additional datasets and workflows are added.

---

## Reproducibility

All data handling is conducted through script-based workflows to promote transparency and reproducibility. Subsequent stages of data cleaning, variable construction, and econometric analysis will be documented in separate notebooks or scripts as the project develops.

---

## Disclaimer

This repository is intended solely for academic research purposes. While the data originate from official sources, any remaining inconsistencies or processing limitations are the responsibility of the author.

---

## Author

Chairunnisa Yulfianti  
Master’s Program in Economics  
Universitas Indonesia
