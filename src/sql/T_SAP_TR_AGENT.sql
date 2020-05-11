create table sap_tr_agent
( agent_source varchar2(80) , 
  agent_source_desc  varchar2(200) , 
  agent_cible  varchar2(80) , 
  agent_cible_desc  varchar2(200) );


create unique index i_sap_tr_agent_uk1 on sap_tr_agent ( upper(agent_source));


