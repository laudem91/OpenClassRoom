OPTIONS (SKIP = 1)
LOAD DATA
-- CHARACTERSET UTF8
TRUNCATE
INTO TABLE SAP_TR_EDI
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  EDI_SOURCE, 
  EDI_CIBLE,
  EDI_CIBLE_DESC 
)