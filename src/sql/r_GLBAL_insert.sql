set timing on

prompt delete sap_glbal_gb;

delete sap_glbal_gb
where lot = '&&1'
and org_id = &&2;

prompt insert into sap_glbal_gb 

insert into sap_glbal_gb 
(
ORG_ID,
lot,
BLART,
BUKRS,
ACC_PRINCIPLE,
XBLNR,
HKONT,
BLDAT,
BUDAT,
BKTXT,
WRBTR,
DMBTR,
WAERS,
HWAER
)
select 
&&2             , -- ORG_ID
'&&1'  , --LOT
sap_tools_cc.cst('sap_glbal_gb','BLART')             , -- BLART
sap_tools_ar.org_id_to_sap_company ( &&2)             , -- BUKRS
sap_tools_cc.cst('SAP_GLBAL_GB','ACC_PRINCIPLE')             , -- ACC_PRINCIPLE
sap_tools_cc.cst('SAP_GLBAL_GB','XBLNR')             , -- XBLNR
sap_tools_glbal.transco_compte_gene(gcc.segment2 )            , -- HKONT
to_date(sap_tools_cc.cst('SAP_GLBAL_GB','BLDAT'))             , -- BLDAT
to_date(sap_tools_cc.cst('SAP_GLBAL_GB','BUDAT'))             , -- BUDAT
sap_tools_cc.cst('SAP_GLBAL_GB','BKTXT')             , -- BKTXT
sum(glb.PERIOD_NET_DR - glb.PERIOD_NET_CR)           , -- WRBTR devise de saisie
sum(glb.PERIOD_NET_DR_BEQ - glb.PERIOD_NET_CR_BEQ)             , -- DMBTR devise societe
glb.currency_code        , -- WAERS
sap_tools_cc.cst('SAP_GLBAL_GB','HWAER')              -- HWAER
from gl_balances glb, gl_code_combinations gcc
where gcc.CODE_COMBINATION_ID = glb.CODE_COMBINATION_ID
and gcc.segment1 = ( select substr(b.name,-3) name
                     from financials_system_params_all a ,  gl_sets_of_books b
                     where a.set_of_books_id = b.SET_OF_BOOKS_ID
                     and a.org_id = &&2 )
and gcc.segment2 between '&&7' and '&&8'
and ( period_year * 100 + period_num ) between   (&&3 * 100) + &&4 and (&&5 * 100) + &&6 
and glb.ACTUAL_FLAG = 'A'
group by gcc.segment1 , gcc.segment2 , glb.currency_code 
order by gcc.segment1 , gcc.segment2 , glb.currency_code;


commit;

