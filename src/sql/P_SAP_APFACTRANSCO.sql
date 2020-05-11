create or replace package sap_apfactransco
as

procedure transco_compte_gene_apfac_ti ( p_lot in varchar2 , p_org_id in number);
procedure transco_pay_method_apfac_voi ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_term_apfac_voi ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_tva_apfac_voi ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_tva_apfac_ti ( p_lot in varchar2 , p_org_id in number);
procedure transco_house_bank_apfac ( p_lot in varchar2 , p_org_id in number);
procedure transco_hktid_apfac ( p_lot in varchar2 , p_org_id in number);

-- procedure transco_code_term_arfac ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_code_term_sd_ar ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_code_term_cd_ar ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_house_bank ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_edi ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_agent ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_compte_gene ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_compte_gene_arfac_ti ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_compte_gene_glbal ( p_lot in varchar2 , p_org_id in number);
-- procedure transco_payment_method_coi ( p_lot in varchar2 , p_org_id in number);

end ;
/

show error

create or replace package body sap_apfactransco
as

procedure transco_compte_gene_apfac_ti ( p_lot in varchar2 , p_org_id in number)
is
x number;
si_error varchar2(10);
tab varchar2(30) := 'SAP_APFAC_TI';
col varchar2(30) := 'HKONT';
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_aPfac_ti
set Hkont_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select cpte_cible
                      from sap_tr_comptes_gene
                      where Hkont = cpte_source) Hkont_transco2
             from sap_aPfac_ti a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_aPfac_ti set Hkont_transco = c1.Hkont_transco2
where rowid = c1.fromrowid;
si_error := 'OK';

if c1.hkont_transco2 is null
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.Hkont    , --column_value
c1.Hkont_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_pay_method_apfac_voi  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_VOI';
col varchar2(30) := 'ZLSCH';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_APFAC_VOI
set ZLSCH_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select term_cible 
                      from sap_tr_ap_pay_method b
                      where a.ZLSCH = b.term_SOURCE) transco2
             from sap_APFAC_VOI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_APFAC_VOI set ZLSCH_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.ZLSCH    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_payment_method_coi ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_COI';
col varchar2(30) := 'ZLSCH';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arFAC_COI
set ZLSCH_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select pay_cible 
                      from sap_tr_ar_pay_method b
                      where a.ZLSCH = b.pay_SOURCE) transco2
             from sap_arFAC_COI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arFAC_COI set ZLSCH_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null  and c1.zlsch is not null 
   then
   si_error := 'ERROR';
  elsif c1.transco2 is null and c1.zlsch is null
     then
     si_error := 'WARNING';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.kunnr    , --pk1_origine
'KUNNR' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.ZLSCH    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_code_term_apfac_voi  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_VOI';
col varchar2(30) := 'ZTERM';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_APFAC_VOI
set ZTERM_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select term_cible 
                      from sap_tr_ap_code_term b
                      where a.ZTERM = b.term_SOURCE) transco2
             from sap_APFAC_VOI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_APFAC_VOI set ZTERM_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.ZTERM    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_code_tva_apfac_voi  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_VOI';
col varchar2(30) := 'MWSKZ';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_APFAC_VOI
set MWSKZ_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select tva_cible 
                      from sap_tr_ap_code_tva b
                      where a.MWSKZ = b.tva_SOURCE) transco2
             from sap_APFAC_VOI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_APFAC_VOI set MWSKZ_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.MWSKZ    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_code_tva_apfac_ti  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_TI';
col varchar2(30) := 'MWSKZ';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_aPFAC_TI
set MWSKZ_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select tva_cible 
                      from sap_tr_aP_code_tva b
                      where a.MWSKZ = b.tva_SOURCE) transco2
             from sap_aPFAC_TI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_aPFAC_TI set MWSKZ_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.MWSKZ    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_code_term_arfac  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_COI';
col varchar2(30) := 'ZTERM';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arFAC_coi
set ZTERM_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select term_cible 
                      from sap_tr_ar_code_term b
                      where a.zterm = b.TERM_SOURCE) transco2
             from sap_arFAC_coi a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arFAC_coi set ZTERM_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.kunnr    , --pk1_origine
'KUNNR' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.ZTERM    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_code_term_cd_ar  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_CD';
col varchar2(30) := 'ZTERM';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_ar_cd
set ZTERM_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select term_cible 
                      from sap_tr_ar_code_term b
                      where a.zterm = b.TERM_SOURCE) transco2
             from sap_ar_cd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_cd set ZTERM_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.customer_number    , --pk1_origine
'KUNNR' , --pk1_description
c1.company_code    , --pk2_origine
'VKORG'    , --pk2_description
col    , --column_name
c1.ZTERM    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;
procedure transco_code_term_sd_ar  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_SD';
col varchar2(30) := 'ZTERM';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_ar_sd
set ZTERM_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select term_cible 
                      from sap_tr_ar_code_term b
                      where a.zterm = b.TERM_SOURCE) transco2
             from sap_ar_sd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_sd set ZTERM_transco = c1.transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.kunnr    , --pk1_origine
'KUNNR' , --pk1_description
c1.vkorg    , --pk2_origine
'VKORG'    , --pk2_description
col    , --column_name
c1.ZTERM    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_hktid_apfac  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_VOI';
col varchar2(30) := 'HKTID';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_APFAC_VOI
set HKTID_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.*  , ( select house_bank 
                      from sap_tr_house_bank b
                      where a.bukrs = b.COMPANY_CODE
                      and module_oap = 'AP'  ) HKTID_transco2
             from sap_APFAC_VOI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_APFAC_VOI set HKTID_transco = c1.HKTID_transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.HKTID_transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.HKTID    , --column_value
c1.HKTID_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_house_bank_apfac  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_APFAC_VOI';
col varchar2(30) := 'HBKID';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_APFAC_VOI
set HBKID_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select house_bank 
                      from sap_tr_house_bank b
                      where a.bukrs = b.COMPANY_CODE
                      and module_oap = 'AP'  ) HBKID_transco2
             from sap_APFAC_VOI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_APFAC_VOI set HBKID_transco = c1.HBKID_transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.HBKID_transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.BUKRS    , --pk1_origine
'BUKRS' , --pk1_description
c1.xblnr    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.HBKID    , --column_value
c1.HBKID_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_house_bank  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_CD';
col varchar2(30) := 'HBKID';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_ar_cd
set HBKID_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select house_bank 
                      from sap_tr_house_bank b
                      where a.COMPANY_CODE = b.COMPANY_CODE
                      and module_oap = 'AR'  ) HBKID_transco2
             from sap_ar_cd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_cd set HBKID_transco = c1.HBKID_transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.HBKID_transco2 is null 
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.customer_number    , --pk1_origine
'CUSTOMER_NUMBER' , --pk1_description
c1.company_code    , --pk2_origine
'COMPANY_CODE'    , --pk2_description
'HBKID'    , --column_name
c1.HBKID    , --column_value
c1.HBKID_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_edi  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_SD';
col varchar2(30) := 'KVGR1';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_ar_sd
set KVGR1_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select edi_cible
                      from sap_tr_edi
                      where upper(KVGR1)  = upper(edi_source) ) KVGR1_transco2
             from sap_ar_sd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_sd set KVGR1_transco = c1.KVGR1_transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.KVGR1_transco2 is null and c1.KVGR1 is not null
   then
   si_error := 'WARNING';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.kunnr    , --pk1_origine
'KUNNR' , --pk1_description
c1.vkorg    , --pk2_origine
'VKORG'    , --pk2_description
'KVGR1'    , --column_name
c1.KVGR1    , --column_value
c1.KVGR1_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;



procedure transco_agent  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_CD';
col varchar2(30) := 'BUSAB_D';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;
update sap_ar_cd

set BUSAB_D_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select agent_cible
                      from sap_tr_agent
                      where upper(BUSAB_D)  = upper(agent_source) ) BUSAB_D_transco2
             from sap_ar_cd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_cd set BUSAB_D_transco = c1.BUSAB_D_transco2
where rowid = c1.fromrowid;
si_error := 'OK';

if c1.BUSAB_D_transco2 is null
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.customer_number    , --pk1_origine
'CUSTOMER_NUMBER' , --pk1_description
c1.company_code    , --pk2_origine
'COMPANY_CODE'    , --pk2_description
'BUSAB_D'    , --column_name
c1.BUSAB_D    , --column_value
c1.BUSAB_D_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;


procedure transco_compte_gene ( p_lot in varchar2 , p_org_id in number)
is
x number;
si_error varchar2(10);
tab varchar2(30) := 'SAP_AR_CD';
col varchar2(30) := 'AKONT';
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_ar_cd
set akont_transco = null
where lot = p_lot
and org_id = p_org_id;
for c1 in ( select a.rowid fromrowid , a.* , ( select cpte_cible
                      from sap_tr_comptes_gene
                      where akont = cpte_source) akont_transco2
             from sap_ar_cd a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_ar_cd set akont_transco = c1.akont_transco2
where rowid = c1.fromrowid;
si_error := 'OK';

if c1.akont_transco2 is null
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.customer_number    , --pk1_origine
'CUSTOMER_NUMBER' , --pk1_description
c1.company_code    , --pk2_origine
'COMPANY_CODE'    , --pk2_description
col    , --column_name
c1.akont    , --column_value
c1.akont_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_compte_gene_arfac_ti ( p_lot in varchar2 , p_org_id in number)
is
x number;
si_error varchar2(10);
tab varchar2(30) := 'SAP_ARFAC_TI';
col varchar2(30) := 'HKONT';
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arfac_ti
set Hkont_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select cpte_cible
                      from sap_tr_comptes_gene
                      where Hkont = cpte_source) Hkont_transco2
             from sap_arfac_ti a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arfac_ti set Hkont_transco = c1.Hkont_transco2
where rowid = c1.fromrowid;
si_error := 'OK';

if c1.hkont_transco2 is null
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.kunnr    , --pk1_origine
'KUNNR' , --pk1_description
c1.XBLNR    , --pk2_origine
'XBLNR'    , --pk2_description
col    , --column_name
c1.Hkont    , --column_value
c1.Hkont_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_compte_gene_glbal ( p_lot in varchar2 , p_org_id in number)
is
x number;
si_error varchar2(10);
tab varchar2(30) := 'SAP_GLBAL_GB';
col varchar2(30) := 'HKONT';
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_GLBAL_GB
set Hkont_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select cpte_cible
                      from sap_tr_comptes_gene
                      where Hkont = cpte_source) Hkont_transco2
             from sap_GLBAL_GB a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_GLBAL_GB set Hkont_transco = c1.Hkont_transco2
where rowid = c1.fromrowid;
si_error := 'OK';

if c1.hkont_transco2 is null
   then
   si_error := 'ERROR';
end if;

insert into sap_tr_result (lot,org_id,table_name,pk1_origine,pk1_description,pk2_origine,pk2_description,
                           column_name,column_value,column_value_transco,commentaire,type_error)
values (
c1.lot    , -- lot
c1.org_id    , --org_id
tab    , --table_name
c1.HKONT    , --pk1_origine
'HKONT' , --pk1_description
c1.BUKRS    , --pk2_origine
'BUKRS'    , --pk2_description
col    , --column_name
c1.Hkont    , --column_value
c1.Hkont_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

end;
/


show error

