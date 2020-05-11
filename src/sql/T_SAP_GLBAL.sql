prompt drop table sap_glbal_gb;

drop table sap_glbal_gb;

prompt create table sap_glbal_gb 

create table sap_glbal_gb (
lot varchar2(30) ,
org_id number,
BLART	varchar2(	30    ),
BUKRS	varchar2(	30    ),
ACC_PRINCIPLE	varchar2(	30    ),
XBLNR	varchar2(	16    ),
DOCLN	Number	,
HKONT	varchar2(	30    ),
HKONT_TRANSCO	varchar2(	30    ),
GKONT	varchar2(	80    ),
BLDAT	Date	,
BUDAT	Date	,
BKTXT	varchar2(	25    ),
SGTXT	varchar2(	50    ),
WRBTR	Number	,
DMBTR	Number	,
DMBE2	Number	,
DMBE3	Number	,
FWBAS	Number	,
HWBAS	Number	,
WAERS	varchar2(	80    ),
HWAER	varchar2(	80    ),
HWAE2	varchar2(	80    ),
HWAE3	varchar2(	80    ),
MWSKZ	varchar2(	80    ),
TXJCD	varchar2(	15    ),
KOSTL	varchar2(	80    ),
PRCTR	varchar2(	80    ),
AUFNR	varchar2(	80    ),
NPLNR	varchar2(	80    ),
FB_SEGMENT	varchar2(	80    ),
PSPNR	varchar2(	80    ),
PROFITSEG	varchar2(	1     ),
RASSC	varchar2(	80    ),
ZUONR	varchar2(	18    ),
RMVCT	varchar2(	80    ),
PERNR	varchar2(	80    ),
VALUT	Date	,
HBKID	varchar2(	80    ),
HKTID	varchar2(	80    )
)
;

prompt create or replace view sap_glbal_gb_v

create or replace view sap_glbal_gb_v
as select
lot,
org_id ,
BLART	|| ';' ||
BUKRS	|| ';' ||
ACC_PRINCIPLE	|| ';' ||
XBLNR	|| ';' ||
DOCLN	|| ';' ||
HKONT_TRANSCO	|| ';' ||
GKONT	|| ';' ||
BLDAT	|| ';' ||
BUDAT	|| ';' ||
BKTXT	|| ';' ||
SGTXT	|| ';' ||
WRBTR	|| ';' ||
DMBTR	|| ';' ||
DMBE2	|| ';' ||
DMBE3	|| ';' ||
FWBAS	|| ';' ||
HWBAS	|| ';' ||
WAERS	|| ';' ||
HWAER	|| ';' ||
HWAE2	|| ';' ||
HWAE3	|| ';' ||
MWSKZ	|| ';' ||
TXJCD	|| ';' ||
KOSTL	|| ';' ||
PRCTR	|| ';' ||
AUFNR	|| ';' ||
NPLNR	|| ';' ||
FB_SEGMENT	|| ';' ||
PSPNR	|| ';' ||
PROFITSEG	|| ';' ||
RASSC	|| ';' ||
ZUONR	|| ';' ||
RMVCT	|| ';' ||
PERNR	|| ';' ||
VALUT	|| ';' ||
HBKID	|| ';' ||
HKTID	line
from sap_glbal_gb
;

create or replace view sap_glbal_gb_v_sum
as select
lot,
org_id ,
BLART   || ';' ||
BUKRS   || ';' ||
ACC_PRINCIPLE   || ';' ||
XBLNR   || ';' ||
DOCLN   || ';' ||
HKONT_TRANSCO   || ';' ||
GKONT   || ';' ||
BLDAT   || ';' ||
BUDAT   || ';' ||
BKTXT   || ';' ||
SGTXT   || ';' ||
sum(WRBTR)   || ';' ||
sum(DMBTR)   || ';' ||
DMBE2   || ';' ||
DMBE3   || ';' ||
FWBAS   || ';' ||
HWBAS   || ';' ||
WAERS   || ';' ||
HWAER   || ';' ||
HWAE2   || ';' ||
HWAE3   || ';' ||
MWSKZ   || ';' ||
TXJCD   || ';' ||
KOSTL   || ';' ||
PRCTR   || ';' ||
AUFNR   || ';' ||
NPLNR   || ';' ||
FB_SEGMENT      || ';' ||
PSPNR   || ';' ||
PROFITSEG       || ';' ||
RASSC   || ';' ||
ZUONR   || ';' ||
RMVCT   || ';' ||
PERNR   || ';' ||
VALUT   || ';' ||
HBKID   || ';' ||
HKTID   line
from sap_glbal_gb
group by lot,
org_id ,
BLART  ,
BUKRS   ,
ACC_PRINCIPLE  ,
XBLNR   ,
DOCLN   ,
HKONT_TRANSCO   ,
GKONT  ,
BLDAT   ,
BUDAT  ,
BKTXT  ,
SGTXT   ,
DMBE2   ,
DMBE3  ,
FWBAS   ,
HWBAS   ,
WAERS   ,
HWAER   ,
HWAE2   ,
HWAE3   ,
MWSKZ   ,
TXJCD   ,
KOSTL   ,
PRCTR  ,
AUFNR  ,
NPLNR   ,
FB_SEGMENT     ,
PSPNR   ,
PROFITSEG      ,
RASSC   ,
ZUONR   ,
RMVCT   ,
PERNR   ,
VALUT  ,
HBKID   ,
HKTID  
;

prompt delete table parametrage de SAP_GLBAL_GB 

delete sap_CC_CST where table_name='SAP_GLBAL_GB';


insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','XBLNR',  'SO','',''   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','BLART',  'Reprise soldes','',''   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','ACC_PRINCIPLE',  'Locale','',''   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','BLDAT',  '','',to_date('01/01/2020','dd/mm/yyyy')   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','BUDAT',  '','',to_date('01/01/2020','dd/mm/yyyy')   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','BKTXT',  'Solde d''ouverture','',''   );

insert into sap_CC_CST ( table_name,column_name , valchar,valnum,valdate)
values ('SAP_GLBAL_GB','HWAER',  'EUR','',''   );


