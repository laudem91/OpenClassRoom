OPTIONS (SKIP = 1)
LOAD DATA
-- CHARACTERSET UTF8
TRUNCATE
INTO TABLE SAP_TR_AR_CODE_TVA
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  TVA_SOURCE, 
  TVA_SOURCE_DESC,
  TVA_SOURCE_COM,
  TVA_CIBLE,
  TVA_CIBLE_DESC 
)

