
prompt initialisation des tables du lot 

delete SAP_AR_GD where lot = '&1';
-- delete sap_errors where lot = '&1';
delete sap_ar_bp_roles where lot = '&1' ;
delete sap_ar_gt where lot = '&1' ;
delete sap_ar_sd where lot = '&1' ;
delete sap_ar_cd where lot = '&1' ;
delete sap_ar_i where lot = '&1' ;
delete sap_ar_tc where lot = '&1' ;
delete SAP_AR_TN where lot = '&1' ;
delete sap_ar_in where lot = '&1' ;
delete sap_ar_cp where lot = '&1' ;
delete sap_ar_sp where lot = '&1' ;

