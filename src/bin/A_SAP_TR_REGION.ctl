OPTIONS (SKIP = 1)
LOAD DATA
CHARACTERSET UTF8
TRUNCATE
INTO TABLE SAP_TR_REGION
FIELDS TERMINATED BY ";"
TRAILING NULLCOLS
(
  LANGUE, 
  PAYS,
  REGION,
  DESCRIPTION 
)
