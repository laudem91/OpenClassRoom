drop table sap_arfac_coi;

create table sap_arfac_coi (
lot varchar2(30) ,
BUKRS VARCHAR2( 70    ),
XBLNR VARCHAR2( 80    ),
KUNNR VARCHAR2( 80    ),
KUNNR_TRANSCO VARCHAR2( 80    ),
GKONT VARCHAR2( 80    ),
BLART VARCHAR2( 80    ),
UMSKZ VARCHAR2( 80    ),
BLDAT Date,
BUDAT Date ,
BKTXT VARCHAR2( 25    ),
SGTXT VARCHAR2( 50    ),
WAERS VARCHAR2( 80    ),
WRBTR Number,
HWAER VARCHAR2( 80    ),
DMBTR Number,
HWAE2 VARCHAR2( 80    ),
DMBE2 Number,
HWAE3 VARCHAR2( 80    ),
DMBE3 Number,
MWSKZ VARCHAR2( 80    ),
MWSKZ_TRANSCO VARCHAR2( 80    ),
BUPLA VARCHAR2( 80    ),
ZTERM VARCHAR2( 80    ),
ZTERM_TRANSCO VARCHAR2( 80    ),
ZFBDT Date ,
ZLSCH VARCHAR2( 80    ),
ZLSCH_TRANSCO VARCHAR2( 80    ),
ZLSPR VARCHAR2( 80    ),
MSCHL VARCHAR2( 80    ),
ZBD1T Number,
ZBD1P Number,
ZBD2T Number,
ZBD2P Number,
ZBD3T Number,
SKFBT Number,
ACSKT Number,
HBKID VARCHAR2( 80    ),
HBKID_TRANSCO VARCHAR2( 80    ),
HKTID VARCHAR2( 80    ),
HKTID_TRANSCO VARCHAR2( 80    ),
BVTYP VARCHAR2( 80    ),
KKBER VARCHAR2( 80    ),
LZBKZ VARCHAR2( 80    ),
LANDL VARCHAR2( 80    ),
PRCTR VARCHAR2( 80    ),
FKBER VARCHAR2( 80    ),
ZUONR VARCHAR2( 18    ),
customer_trx_id number ,
ORG_ID number,
montant_initial number,
exchange_rate number,
cust_acct_site_id number not null,
coeff_payment number 
);

COMMENT ON TABLE sap_arfac_coi  IS 'PNS CLIENT : entete de facture : onglet Customer Open Items';

create or replace view  sap_arfac_coi_v
as 
select 
lot,
org_id ,
BUKRS || ';' ||
XBLNR || ';' ||
KUNNR_TRANSCO || ';' ||
GKONT || ';' ||
BLART || ';' ||
UMSKZ || ';' ||
BLDAT || ';' ||
BUDAT || ';' ||
BKTXT || ';' ||
SGTXT || ';' ||
WAERS || ';' ||
WRBTR || ';' ||
HWAER || ';' ||
DMBTR || ';' ||
HWAE2 || ';' ||
DMBE2 || ';' ||
HWAE3 || ';' ||
DMBE3 || ';' ||
MWSKZ_TRANSCO || ';' ||
BUPLA || ';' ||
ZTERM_TRANSCO || ';' ||
ZFBDT || ';' ||
ZLSCH_TRANSCO || ';' ||
ZLSPR || ';' ||
MSCHL || ';' ||
ZBD1T || ';' ||
ZBD1P || ';' ||
ZBD2T || ';' ||
ZBD2P || ';' ||
ZBD3T || ';' ||
SKFBT || ';' ||
ACSKT || ';' ||
HBKID_TRANSCO || ';' ||
HKTID_TRANSCO || ';' ||
BVTYP || ';' ||
KKBER || ';' ||
LZBKZ || ';' ||
LANDL || ';' ||
PRCTR || ';' ||
FKBER || ';' ||
ZUONR || ';' LINE  
from sap_arfac_coi;



drop table sap_arfac_ti;


create table sap_arfac_ti (
lot varchar2(30) ,
BUKRS VARCHAR2( 70    ),
XBLNR VARCHAR2( 80    ),
KUNNR VARCHAR2( 80    ),
KUNNR_TRANSCO VARCHAR2( 80    ),
BUZEI Number,
HKONT VARCHAR2( 80    ),
HKONT_TRANSCO VARCHAR2( 80    ),
GKONT2 VARCHAR2( 80    ),
MWSKZ VARCHAR2( 80    ),
MWSKZ_TRANSCO VARCHAR2( 80    ),
FWBAS Number( 13,2    ),
FWBAS_CALC Number( 13,2    ),
FWSTE Number( 13 ,2   ),
FWSTE_CALC Number( 13 ,2   ),
HWBAS Number( 13 ,2   ),
HWBAS_CALC Number( 13 ,2   ),
HWSTE Number( 13  ,2  ),
HWSTE_CALC Number( 13  ,2  ),
H2BAS Number( 13  ,2  ),
H2STE Number( 13  ,2  ),
H3BAS Number( 13  ,2  ),
H3STE Number( 13  ,2  ),
org_id number ,
customer_trx_id number,
customer_trx_line_id number,
cust_acct_site_id number ,
coeff_payment number
);

COMMENT ON TABLE sap_arfac_ti  IS 'PNS CLIENT :ligne de facture : onglet Tax Items';


create or replace view sap_arfac_ti_v 
as select
lot,
org_id,
BUKRS || ';' ||
XBLNR || ';' ||
KUNNR_TRANSCO || ';' ||
BUZEI || ';' ||
HKONT_TRANSCO || ';' ||
GKONT2 || ';' ||
MWSKZ_TRANSCO || ';' ||
FWBAS_CALC || ';' ||
FWSTE_CALC || ';' ||
HWBAS_CALC || ';' ||
HWSTE_CALC || ';' ||
H2BAS || ';' ||
H2STE || ';' ||
H3BAS || ';' ||
H3STE || ';' LINE
from sap_arfac_ti
;
