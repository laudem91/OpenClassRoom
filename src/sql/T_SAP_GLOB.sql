create table sap_glob_perimetre (
org_id number not null ,
lot varchar2(80) not null );

create unique index i_sap_glob_idx1 on sap_glob_perimetre ( org_id,lot);


insert into sap_glob_perimetre (org_id,lot ) values(189,'LOT1') ;
insert into sap_glob_perimetre (org_id,lot ) values(5726,'LOT1') ;
insert into sap_glob_perimetre (org_id,lot ) values(189,'189') ;
insert into sap_glob_perimetre (org_id,lot ) values(5726,'5726') ;
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('83','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('86','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('144','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('186','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('187','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('188','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('191','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4225','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4585','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4905','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7110','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7330','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7450','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('10770','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11070','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11090','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11270','LOT2');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11273','LOT2');

insert into sap_glob_perimetre (org_id,lot ) values(189,'LOT3') ;
insert into sap_glob_perimetre (org_id,lot ) values(5726,'LOT3') ;
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('83','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('86','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('144','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('186','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('187','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('188','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('191','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4225','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4585','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('4905','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7110','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7330','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('7450','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('10770','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11070','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11090','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11270','LOT3');
Insert into SAP_GLOB_PERIMETRE (ORG_ID,LOT) values ('11273','LOT3');

create table sap_glob_ordre (
ordre number,
org_id number,
societe varchar2(10) );

create unique index i_sap_glob_ordre_pk1 on sap_glob_ordre (ordre );
create unique index i_sap_glob_ordre_pk2 on sap_glob_ordre (org_id );
create unique index i_sap_glob_ordre_pk3 on sap_glob_ordre (societe );




insert into sap_glob_ordre values ( '1','83','100');
insert into sap_glob_ordre values ( '2','86','410');
insert into sap_glob_ordre values ( '3','187','418');
insert into sap_glob_ordre values ( '4','189','504');
insert into sap_glob_ordre values ( '5','186','415');
insert into sap_glob_ordre values ( '6','7110','505');
insert into sap_glob_ordre values ( '7','5726','437');
insert into sap_glob_ordre values ( '8','7450','439');
insert into sap_glob_ordre values ( '9','144','118');
insert into sap_glob_ordre values ( '10','4225','404');
insert into sap_glob_ordre values ( '11','4585','405');
insert into sap_glob_ordre values ( '12','4905','406');
insert into sap_glob_ordre values ( '13','11070','428');
insert into sap_glob_ordre values ( '14','11090','429');
insert into sap_glob_ordre values ( '15','11273','430');
insert into sap_glob_ordre values ( '16','188','471');
insert into sap_glob_ordre values ( '17','10770','662');
insert into sap_glob_ordre values ( '18','7330','701');
insert into sap_glob_ordre values ( '19','191','800');
insert into sap_glob_ordre values ( '20','11270','971');

