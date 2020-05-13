create  TABLE SAP_TR_AR_GRP_CLIENT
(
  GRP_SOURCE varchar2(80),
  GRP_SOURCE_DESC varchar2(200),
  GRP_CIBLE varchar2(11),
  GRP_CIBLE_DESC varchar2(200)
);


create unique index i_SAP_TR_GRP_CLI_PK1 on SAP_TR_AR_GRP_CLIENT (GRP_SOURCE);
