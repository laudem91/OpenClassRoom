OPTIONS (SKIP = 1)
LOAD DATA
-- CHARACTERSET UTF8
TRUNCATE
INTO TABLE SAP_TR_AR_CODE_TERM
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  TERM_SOURCE, 
  TERM_SOURCE_DESC,
  TERM_CIBLE,
  TERM_CIBLE_DESC 
)

