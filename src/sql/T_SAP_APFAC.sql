drop table sap_apfac_voi;

create table sap_apfac_voi (
lot varchar2(30) ,
BUKRS	varchar2(	70    ),
XBLNR	varchar2(	80    ),
LIFNR	varchar2(	80    ),
LIFNR_TRANSCO	varchar2(	80    ),
GKONT	varchar2(	80    ),
BLART	varchar2(	80    ),
UMSKZ	varchar2(	80    ),
BLDAT	Date	,
BUDAT	Date	,
BKTXT	varchar2(	25    ),
SGTXT	varchar2(	50    ),
WAERS	varchar2(	80    ),
WRBTR	Number	,
HWAER	varchar2(	80    ),
DMBTR	Number	,
HWAE2	varchar2(	80    ),
DMBE2	Number	,
HWAE3	varchar2(	80    ),
DMBE3	Number	,
MWSKZ	varchar2(	80    ),
MWSKZ_TRANSCO	varchar2(	80    ),
BUPLA	varchar2(	80    ),
ZTERM	varchar2(	80    ),
ZTERM_TRANSCO	varchar2(	80    ),
ZFBDT	Date	,
ZLSCH	varchar2(	80    ),
ZLSCH_TRANSCO	varchar2(	80    ),
ZLSPR	varchar2(	80    ),
ZBD1T	Number	,
ZBD1P	Number	,
ZBD2T	Number	,
ZBD2P	Number	,
ZBD3T	Number	,
SKFBT	Number	,
ACSKT	Number	,
HBKID	varchar2(	80    ),
HBKID_TRANSCO	varchar2(	80    ),
HKTID	varchar2(	80    ),
HKTID_TRANSCO	varchar2(	80    ),
BVTYP	varchar2(	80    ),
DTWS1	varchar2(	80    ),
DTWS2	varchar2(	80    ),
DTWS3	varchar2(	80    ),
DTWS4	varchar2(	80    ),
LZBKZ	varchar2(	80    ),
LANDL	varchar2(	80    ),
PRCTR	varchar2(	80    ),
FKBER	varchar2(	80    ),
ZUONR	varchar2(	18    ),
org_id number,
montant_initial number,
exchange_rate number,
invoice_id number,
vendor_site_id number
);

create or replace view sap_apfac_voi_v
as select 
BUKRS	|| ';' ||
XBLNR	|| ';' ||
LIFNR_TRANSCO	|| ';' ||
GKONT	|| ';' ||
BLART	|| ';' ||
UMSKZ	|| ';' ||
BLDAT	|| ';' ||
BUDAT	|| ';' ||
BKTXT	|| ';' ||
SGTXT	|| ';' ||
WAERS	|| ';' ||
WRBTR	|| ';' ||
HWAER	|| ';' ||
DMBTR	|| ';' ||
HWAE2	|| ';' ||
DMBE2	|| ';' ||
HWAE3	|| ';' ||
DMBE3	|| ';' ||
MWSKZ_TRANSCO	|| ';' ||
BUPLA	|| ';' ||
ZTERM_TRANSCO	|| ';' ||
ZFBDT	|| ';' ||
ZLSCH_TRANSCO	|| ';' ||
ZLSPR	|| ';' ||
ZBD1T	|| ';' ||
ZBD1P	|| ';' ||
ZBD2T	|| ';' ||
ZBD2P	|| ';' ||
ZBD3T	|| ';' ||
SKFBT	|| ';' ||
ACSKT	|| ';' ||
HBKID_TRANSCO	|| ';' ||
HKTID_TRANSCO	|| ';' ||
BVTYP	|| ';' ||
DTWS1	|| ';' ||
DTWS2	|| ';' ||
DTWS3	|| ';' ||
DTWS4	|| ';' ||
LZBKZ	|| ';' ||
LANDL	|| ';' ||
PRCTR	|| ';' ||
FKBER	|| ';' ||
ZUONR	|| ';' LINE ,
org_id ,
lot
from sap_apfac_voi;



drop table sap_apfac_ti;


create table sap_apfac_ti (
lot varchar2(30) ,
org_id number ,
invoice_id number,
line_number number,
vendor_site_id number,
invoice_distribution_id number,
BUKRS	Varchar2(	70    ),
XBLNR	Varchar2(	80    ),
LIFNR	Varchar2(	80    ),
LIFNR_TRANSCO	Varchar2(	80    ),
BUZEI	Number,
HKONT	Varchar2(	80    ),
HKONT_TRANSCO	Varchar2(	80    ),
GKONT2	Varchar2(	80    ),
MWSKZ	Varchar2(	80    ),
MWSKZ_TRANSCO	Varchar2(	80    ),
FWBAS	Number,
FWSTE	Number,
HWBAS	Number,
HWSTE	Number,
H2BAS	Number,
H2STE	Number,
H3BAS	Number,
H3STE	Number )
;

create or replace view sap_apfac_ti_v
as
select lot,org_id,invoice_distribution_id , invoice_id, line_number,
BUKRS || ';'||
XBLNR || ';'||
LIFNR_TRANSCO || ';'||
BUZEI || ';'||
HKONT_TRANSCO || ';'||
GKONT2 || ';'||
MWSKZ_TRANSCO || ';'||
FWBAS || ';'||
FWSTE || ';'||
HWBAS || ';'||
HWSTE || ';'||
H2BAS || ';'||
H2STE || ';'||
H3BAS || ';'||
H3STE || ';' line
from sap_apfac_ti;

