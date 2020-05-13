create or replace package sap_artransco
as

procedure transco_konzs ( p_lot in varchar2 );
procedure transco_ktgrd ( p_lot in varchar2 , p_org_id in number);
procedure transco_payment_method_coi ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_tva_arfac_coi ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_tva_arfac_ti ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_term_arfac ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_term_sd_ar ( p_lot in varchar2 , p_org_id in number);
procedure transco_code_term_cd_ar ( p_lot in varchar2 , p_org_id in number);
procedure transco_house_bank_arfac ( p_lot in varchar2 , p_org_id in number);
procedure transco_hktid_arfac ( p_lot in varchar2 , p_org_id in number);
procedure transco_house_bank ( p_lot in varchar2 , p_org_id in number);
procedure transco_edi ( p_lot in varchar2 , p_org_id in number);
procedure transco_agent ( p_lot in varchar2 , p_org_id in number);
procedure transco_compte_gene ( p_lot in varchar2 , p_org_id in number);
procedure transco_compte_gene_arfac_ti ( p_lot in varchar2 , p_org_id in number);
procedure transco_compte_gene_glbal ( p_lot in varchar2 , p_org_id in number);

end ;
/

show error

create or replace package body sap_artransco
as

procedure transco_konzs  ( p_lot in varchar2 )
-- transco unique pour les clients , pas de contact ( ZCP1)
is
x number;
tab varchar2(30) := 'SAP_AR_GD';
col varchar2(30) := 'KONZS';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot );

delete sap_tr_result where lot = p_lot and table_name = tab and column_name = col;

update sap_ar_gd
set KONZS_transco = null
where lot = p_lot
and bp_grouping != 'ZCP1';

for c1 in ( select a.rowid fromrowid , a.* , ( select grp_cible
                      from sap_tr_ar_grp_client b
                      where a.KONZS = b.GRP_SOURCE
                        ) KONZS_transco2
             from sap_ar_gd a
            where lot = p_lot
            and bp_grouping != 'ZCP1'
            for update of lot
            )
loop
null;
update sap_ar_gd set KONZS_transco = c1.KONZS_transco2
where rowid = c1.fromrowid;

si_error := 'OK';

if c1.konzs is null
then
   si_error := 'WARNING';
elsif c1.KONZS_transco2 is null 
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
c1.org_id    , --pk2_origine
'ORG_ID'    , --pk2_description
'KONZS'    , --column_name
c1.KONZS    , --column_value
c1.KONZS_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_ktgrd ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_AR_SD';
col varchar2(30) := 'KTGRD';
val_transco varchar2(10);

si_error varchar2(10);

begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_AR_SD
set KTGRD_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.lot , a.org_id , a.rowid fromrowid , a.vkorg,a.kunnr , b.bp_grouping , b.country1 , 
            ( select intra from sap_tr_pays where code2 = b.country1 ) intra
             from sap_ar_SD a , sap_ar_gd b
            where a.lot = p_lot
            and a.org_id = p_org_id
            and a.kunnr = b.customer_number
            and a.lot = b.lot
            for update of a.lot

            )
loop
null;
-- Z1  National DOM-TOM
-- Z2  National DOM-TOM groupe
-- Z3  Intracommunautaire
-- Z4  Intracomm. Grp
-- Z5  International
-- Z6  International Grp

val_transco := null;

if sap_tools_ar.is_pays_dependance( c1.country1) = 'FR' 
   then
   if c1.bp_grouping like 'ZGR%' then val_transco := 'Z2'; else val_transco := 'Z1'; end if;
end if;

if sap_tools_ar.is_pays_dependance( c1.country1) != 'FR' and c1.intra = 1
   then
   if c1.bp_grouping like 'ZGR%' then val_transco := 'Z4'; else val_transco := 'Z3'; end if;
end if;

if sap_tools_ar.is_pays_dependance( c1.country1) != 'FR' and nvl(c1.intra,0) != 1
   then
   if c1.bp_grouping like 'ZGR%' then val_transco := 'Z6'; else val_transco := 'Z5'; end if;
end if;

update sap_ar_SD 
set KTGRD_transco = val_transco ,
    KTGRD = c1.bp_grouping || ' ' || c1.country1
where rowid = c1.fromrowid;

si_error := 'OK';

if val_transco is null  
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
c1.bp_grouping || ' ' || c1.country1    , --column_value
val_transco    , --column_value_transco
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

procedure transco_code_tva_arfac_coi  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_COI';
col varchar2(30) := 'MWSKZ';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arFAC_COI
set MWSKZ_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select tva_cible 
                      from sap_tr_ar_code_tva b
                      where a.MWSKZ = b.tva_SOURCE) transco2
             from sap_arFAC_COI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arFAC_COI set MWSKZ_transco = c1.transco2
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
c1.MWSKZ    , --column_value
c1.transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_code_tva_arfac_ti  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_TI';
col varchar2(30) := 'MWSKZ';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arFAC_TI
set MWSKZ_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select tva_cible 
                      from sap_tr_ar_code_tva b
                      where a.MWSKZ = b.tva_SOURCE) transco2
             from sap_arFAC_TI a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arFAC_TI set MWSKZ_transco = c1.transco2
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


procedure transco_house_bank_arfac  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_COI';
col varchar2(30) := 'HBKID';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arfac_coi
set HBKID_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select house_bank 
                      from sap_tr_house_bank b
                      where a.bukrs = b.COMPANY_CODE
                      and module_oap = 'AR'  ) HBKID_transco2
             from sap_arfac_coi a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arfac_coi set HBKID_transco = c1.HBKID_transco2
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
c1.xblnr || '+' || c1.kunnr     , --pk1_origine
'XBLNR+KUNNR' , --pk1_description
c1.bukrs    , --pk2_origine
'BUKRS'    , --pk2_description
col    , --column_name
c1.HBKID    , --column_value
c1.HBKID_transco2    , --column_value_transco
null    , --commentaire
si_error );     --type_error
end loop;
null;
end;

procedure transco_hktid_arfac  ( p_lot in varchar2 , p_org_id in number)
is
x number;
tab varchar2(30) := 'SAP_ARFAC_COI';
col varchar2(30) := 'HKTID';

si_error varchar2(10);
begin

dbms_output.put_line('Transco : ' || tab ||'.' || col ||  '    Lot='|| p_lot || '   Org_id=' || p_org_id );

delete sap_tr_result where lot = p_lot and org_id = p_org_id and table_name = tab and column_name = col;

update sap_arfac_coi
set HKTID_transco = null
where lot = p_lot
and org_id = p_org_id;

for c1 in ( select a.rowid fromrowid , a.* , ( select house_bank 
                      from sap_tr_house_bank b
                      where a.bukrs = b.COMPANY_CODE
                      and module_oap = 'AR'  ) HKTID_transco2
             from sap_arfac_coi a
            where lot = p_lot
            and org_id = p_org_id 
            for update of lot
            )
loop
null;
update sap_arfac_coi set HKTID_transco = c1.HKTID_transco2
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
c1.xblnr || '+' || c1.kunnr     , --pk1_origine
'XBLNR+KUNNR' , --pk1_description
c1.bukrs    , --pk2_origine
'BUKRS'    , --pk2_description
col    , --column_name
c1.HKTID    , --column_value
c1.HKTID_transco2    , --column_value_transco
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

