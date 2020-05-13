drop table SAP_AR;

CREATE TABLE SAP_AR 
   (	Lot varchar2(30) ,
        ORG_ID_SOURCE NUMBER(15,0), 
	PARTY_ID_SOURCE NUMBER(15,0) NOT NULL ENABLE, 
	PARTY_SITE_ID_SOURCE NUMBER(15,0) NOT NULL ENABLE, 
	CUST_ACCOUNT_ID_SOURCE NUMBER(15,0) NOT NULL ENABLE, 
	CUST_ACCT_SITE_ID_SOURCE NUMBER(15,0) NOT NULL ENABLE, 
	ACCOUNT_NUMBER_SOURCE VARCHAR2(4000 ), 
	SOLDE_SOURCE NUMBER, 
	DERNIERE_ECRITURE_SITE_SOURCE DATE, 
        SITE_A_DESACTIVER varchar2(1) ,
        SITE_FACTURATION varchar2(1), 
	GROUPE_SOURCE VARCHAR2(4000 ), 
	ATTRIBUTE4 VARCHAR2(150 ), 
	ORG_ID_ATTRIBUTE4 NUMBER, 
	PARTY_ID_ATTRIBUTE4 NUMBER, 
	PARTY_SITE_ID_ATTRIBUTE4 NUMBER, 
	CUST_ACCOUNT_ID_ATTRIBUTE4 NUMBER, 
	CUST_ACCT_SITE_ID_ATTRIBUTE4 NUMBER, 
	ATTRIBUTE5 VARCHAR2(150), 
	ORG_ID_ATTRIBUTE5 NUMBER, 
	PARTY_ID_ATTRIBUTE5 NUMBER, 
	PARTY_SITE_ID_ATTRIBUTE5 NUMBER, 
	CUST_ACCOUNT_ID_ATTRIBUTE5 NUMBER, 
	CUST_ACCT_SITE_ID_ATTRIBUTE5 NUMBER ,
        ELIGIBLE  varchar2(1) )
;


create or replace view sap_ar_v
as select * from sap_ar 
where eligible = 'Y' and ( nvl(attribute4,'HP') != 'HP' or nvl(attribute5,'HP') != 'HP') ;



-- drop table sap_filtre_Customer_Number;

-- create table sap_filtre_Customer_Number (
-- Customer_Number varchar2(80) not null );

drop table sap_errors; 

create table sap_errors (
lot varchar2(30) ,
org_id number ,
table_name varchar2(30) not null ,
cle1   varchar2(80) ,
libelle varchar2(2000),
groupesearch  varchar2(200),
datec date );

CREATE OR REPLACE  TRIGGER SAP_ERRORS_INS
BEFORE INSERT
   ON SAP_ERRORS
    FOR EACH ROW 

DECLARE
   -- variable declarations

BEGIN
:new.DATEC := sysdate;
END;
/


drop table sap_ar_gd;

create table sap_ar_gd (
lot varchar2(30) ,
Customer_Number varchar2(80) ,    
BP_Grouping   varchar2(80) ,    
KTOKD  varchar2(80) ,    
Name  varchar2( 45) ,    
Name_2  varchar2( 45) ,    
Name_3  varchar2( 45) ,    
Name_4  varchar2( 45) ,    
Title  varchar2( 80) ,    
First_name  varchar2( 240) ,    
Last_name  varchar2(40) ,    
Middle_name   varchar2(40) ,    
Birth_name  varchar2(40) ,    
Search_Term_1  varchar2(40),    
Search_Term_2  varchar2(20),    
Supplier  varchar2(80) ,    
KONZS  varchar2(100),
KONZS_TRANSCO  varchar2(11),
Natural_Person_Under_the_Tax varchar2( 1     ),
Trading_Partner  varchar2( 80) ,    
Suppress_Tax_Jurisdiction_Code  varchar2( 1     ),
Legal_form  varchar2( 80) ,    
Legal_Entity  varchar2( 80) ,    
Date_founded  Date, 
Liquidation_date  Date, 
International_location_number1  Number ,
International_location_number2  Number ,
Check_digit_for_the_intern_loc  Number ,
DME_indicator  varchar2( 80) ,    
Instructuion_Key  varchar2( 80) ,    
Alternative_Payer  varchar2( 80) ,    
Nielsen_Indicator  varchar2( 80) ,    
Regional_market  varchar2( 5     ),
KUKLA  varchar2( 80) ,    
Hierarchy_assignment  Number ,
Industry_Code_1  varchar2( 80) ,    
Industry_Code_2  varchar2( 80) ,    
Industry_Code_3  varchar2( 80) ,    
Industry_Code_4  varchar2( 80) ,    
Industry_Code_5  varchar2( 80) ,    
Suframa_Code  varchar2( 9     ),
RG_Number  varchar2( 11    ),
Issued_by  varchar2( 3     ),
State1 varchar2( 2     ),
RG_Issuing_Date  Date, 
RIC_Number  Number ,
Foreign_National_Registration  varchar2( 10    ),
RNE_Issuing_Date  Date, 
CNAE  varchar2( 80) ,    
Legal_Nature  varchar2( 80) ,    
CRT_Number  varchar2( 80) ,    
ICMS_Taxpayer  varchar2( 80) ,    
Industry_Main_Type  varchar2( 80) ,    
Tax_Declaration_Type  varchar2( 80) ,    
Company_Size  varchar2( 80) ,    
Declaration_Regimen  varchar2( 80) ,    
External_Address_Number  varchar2( 20),    
Street  varchar2( 60    ),
House_Number  varchar2( 10    ),
District  varchar2( 40) ,    
Different_City  varchar2( 40) ,    
Postal_Code1 varchar2( 80 ),
City1 varchar2( 40) ,    
Country1 varchar2( 80) ,    
State2 varchar2( 80) ,    
Time_Zone2 varchar2( 80) ,    
Transportation_Zone  varchar2( 80) ,    
Building  varchar2( 20),    
Room  varchar2( 10    ),
Floor  varchar2( 10    ),
CO_Name  varchar2( 40) ,    
Street_2  varchar2( 40) ,    
Street_3  varchar2( 40) ,    
Supplement  varchar2( 10    ),
Street_4  varchar2( 40) ,    
Street_5  varchar2( 40) ,    
Tax_Jurisdiction_Code  varchar2( 15    ),
PO_Box  varchar2( 10 ),
Postal_Code2 varchar2( 10    ),
PO_Box_City  varchar2( 40) ,    
PO_Box_Country  varchar2( 80) ,    
PO_Box_State  varchar2( 80) ,    
Company_Postal_Code  varchar2( 10    ),
Language varchar2( 80) ,    
Telephone  varchar2( 240    ),
Telephone_transco  varchar2( 240    ),
Additional_Telephone_2  varchar2( 30    ),
Additional_Telephone_3  varchar2( 30    ),
Mobile  varchar2( 30    ),
Additional_Mobile_2  varchar2( 30    ),
Additional_Mobile_3  varchar2( 30    ),
Fax  varchar2( 30    ),
Additional_Fax_2  varchar2( 30    ),
Additional_Fax_3  varchar2( 30    ),
Email  varchar2( 241   ),
Additional_Email_2  varchar2( 241   ),
Additional_Email_3  varchar2( 241   ),
Communication_Type  varchar2( 80) ,    
Web_Site  varchar2( 132   ),
Central_Posting_Block  varchar2( 1     ),
Collection_Management_Active  varchar2( 1),
org_id number not null ,
solde_site number ,
derniere_ecriture_site date,
party_name varchar2(400),
actif varchar2(40) ,
party_id number ,
party_site_id number,
cust_account_id number,
cust_acct_site_id number ,
BPEE_Customer_Number varchar2(80)     -- Origine pour contact BPEE
)
;

-- drop table sap_ar_gd_exclus;

-- create table sap_ar_gd_exclus
-- as select * from sap_ar_gd
-- where 1=2;

create or replace view sap_ar_gd_v 
as select 
lot,
org_id,
'"' || Customer_Number || '";"' ||
BP_Grouping   || '";"' ||
KTOKD  || '";"' ||
Name  || '";"' ||
Name_2  || '";"' ||
Name_3  || '";"' ||
Name_4  || '";"' ||
Title  || '";"' ||
First_name  || '";"' ||
Last_name  || '";"' ||
Middle_name   || '";"' ||
Birth_name  || '";"' ||
Search_Term_1  || '";"' ||
Search_Term_2  || '";"' ||
Supplier  || '";"' ||
KONZS_TRANSCO  || '";"' ||
Natural_Person_Under_the_Tax || '";"' ||
Trading_Partner  || '";"' ||
Suppress_Tax_Jurisdiction_Code  || '";"' ||
Legal_form  || '";"' ||
Legal_Entity  || '";"' ||
Date_founded  || '";"' ||
Liquidation_date  || '";"' ||
International_location_number1  || '";"' ||
International_location_number2  || '";"' ||
Check_digit_for_the_intern_loc  || '";"' ||
DME_indicator  || '";"' ||
Instructuion_Key  || '";"' ||
Alternative_Payer  || '";"' ||
Nielsen_Indicator  || '";"' ||
Regional_market  || '";"' ||
KUKLA  || '";"' ||
Hierarchy_assignment  || '";"' ||
Industry_Code_1  || '";"' ||
Industry_Code_2  || '";"' ||
Industry_Code_3  || '";"' ||
Industry_Code_4  || '";"' ||
Industry_Code_5  || '";"' ||
Suframa_Code  || '";"' ||
RG_Number  || '";"' ||
Issued_by  || '";"' ||
State1 || '";"' ||
RG_Issuing_Date  || '";"' ||
RIC_Number  || '";"' ||
Foreign_National_Registration  || '";"' ||
RNE_Issuing_Date  || '";"' ||
CNAE  || '";"' ||
Legal_Nature  || '";"' ||
CRT_Number  || '";"' ||
ICMS_Taxpayer  || '";"' ||
Industry_Main_Type  || '";"' ||
Tax_Declaration_Type  || '";"' ||
Company_Size  || '";"' ||
Declaration_Regimen  || '";"' ||
External_Address_Number  || '";"' ||
Street  || '";"' ||
House_Number  || '";"' ||
District  || '";"' ||
Different_City  || '";"' ||
Postal_Code1 || '";"' ||
City1 || '";"' ||
Country1 || '";"' ||
State2 || '";"' ||
Time_Zone2 || '";"' ||
Transportation_Zone  || '";"' ||
Building  || '";"' ||
Room  || '";"' ||
Floor  || '";"' ||
CO_Name  || '";"' ||
Street_2  || '";"' ||
Street_3  || '";"' ||
Supplement  || '";"' ||
Street_4  || '";"' ||
Street_5  || '";"' ||
Tax_Jurisdiction_Code  || '";"' ||
PO_Box  || '";"' ||
Postal_Code2 || '";"' ||
PO_Box_City  || '";"' ||
PO_Box_Country  || '";"' ||
PO_Box_State  || '";"' ||
Company_Postal_Code  || '";"' ||
Language || '";"' ||
Telephone_transco  || '";"' ||
Additional_Telephone_2  || '";"' ||
Additional_Telephone_3  || '";"' ||
Mobile  || '";"' ||
Additional_Mobile_2  || '";"' ||
Additional_Mobile_3  || '";"' ||
Fax  || '";"' ||
Additional_Fax_2  || '";"' ||
Additional_Fax_3  || '";"' ||
Email  || '";"' ||
Additional_Email_2  || '";"' ||
Additional_Email_3  || '";"' ||
Communication_Type  || '";"' ||
Web_Site  || '";"' ||
Central_Posting_Block  || '";"' ||
Collection_Management_Active || '";'     "LINE"
from sap_ar_gd
;

create or replace view sap_ar_gd_v_csv 
as select 
lot,
org_id,
'="' || Customer_Number || '";="' ||
BP_Grouping   || '";="' ||
KTOKD  || '";="' ||
Name  || '";="' ||
Name_2  || '";="' ||
Name_3  || '";="' ||
Name_4  || '";="' ||
Title  || '";="' ||
First_name  || '";="' ||
Last_name  || '";="' ||
Middle_name   || '";="' ||
Birth_name  || '";="' ||
Search_Term_1  || '";="' ||
Search_Term_2  || '";="' ||
Supplier  || '";="' ||
KONZS_TRANSCO  || '";="' ||
Natural_Person_Under_the_Tax || '";="' ||
Trading_Partner  || '";="' ||
Suppress_Tax_Jurisdiction_Code  || '";="' ||
Legal_form  || '";="' ||
Legal_Entity  || '";="' ||
Date_founded  || '";="' ||
Liquidation_date  || '";="' ||
International_location_number1  || '";="' ||
International_location_number2  || '";="' ||
Check_digit_for_the_intern_loc  || '";="' ||
DME_indicator  || '";="' ||
Instructuion_Key  || '";="' ||
Alternative_Payer  || '";="' ||
Nielsen_Indicator  || '";="' ||
Regional_market  || '";="' ||
KUKLA  || '";="' ||
Hierarchy_assignment  || '";="' ||
Industry_Code_1  || '";="' ||
Industry_Code_2  || '";="' ||
Industry_Code_3  || '";="' ||
Industry_Code_4  || '";="' ||
Industry_Code_5  || '";="' ||
Suframa_Code  || '";="' ||
RG_Number  || '";="' ||
Issued_by  || '";="' ||
State1 || '";="' ||
RG_Issuing_Date  || '";="' ||
RIC_Number  || '";="' ||
Foreign_National_Registration  || '";="' ||
RNE_Issuing_Date  || '";="' ||
CNAE  || '";="' ||
Legal_Nature  || '";="' ||
CRT_Number  || '";="' ||
ICMS_Taxpayer  || '";="' ||
Industry_Main_Type  || '";="' ||
Tax_Declaration_Type  || '";="' ||
Company_Size  || '";="' ||
Declaration_Regimen  || '";="' ||
External_Address_Number  || '";="' ||
Street  || '";="' ||
House_Number  || '";="' ||
District  || '";="' ||
Different_City  || '";="' ||
Postal_Code1 || '";="' ||
City1 || '";="' ||
Country1 || '";="' ||
State2 || '";="' ||
Time_Zone2 || '";="' ||
Transportation_Zone  || '";="' ||
Building  || '";="' ||
Room  || '";="' ||
Floor  || '";="' ||
CO_Name  || '";="' ||
Street_2  || '";="' ||
Street_3  || '";="' ||
Supplement  || '";="' ||
Street_4  || '";="' ||
Street_5  || '";="' ||
Tax_Jurisdiction_Code  || '";="' ||
PO_Box  || '";="' ||
Postal_Code2 || '";="' ||
PO_Box_City  || '";="' ||
PO_Box_Country  || '";="' ||
PO_Box_State  || '";="' ||
Company_Postal_Code  || '";="' ||
Language || '";="' ||
Telephone_transco  || '";="' ||
Additional_Telephone_2  || '";="' ||
Additional_Telephone_3  || '";="' ||
Mobile  || '";="' ||
Additional_Mobile_2  || '";="' ||
Additional_Mobile_3  || '";="' ||
Fax  || '";="' ||
Additional_Fax_2  || '";="' ||
Additional_Fax_3  || '";="' ||
Email  || '";="' ||
Additional_Email_2  || '";="' ||
Additional_Email_3  || '";="' ||
Communication_Type  || '";="' ||
Web_Site  || '";="' ||
Central_Posting_Block  || '";="' ||
Collection_Management_Active || '";'     "LINE"
from sap_ar_gd
;



drop table sap_ar_bp_roles;
create table sap_ar_bp_roles (
lot varchar2(30) ,
Customer_Number varchar2(80) ,    
bp_role varchar2(80),
org_id number );


create or replace view sap_ar_bp_roles_v
as select lot,org_id , '"' || Customer_Number || '";"' || bp_role|| '";' "LINE"
from sap_ar_bp_roles;


drop table sap_ar_gt;

create table sap_ar_gt (
lot varchar2(30) ,
Customer_Number varchar2(80) ,
Text_ID varchar2(80),
Language_Key varchar2(80),
Text varchar2(4000),
org_id number );


drop table sap_ar_sp;

create table sap_ar_sp (
lot varchar2(30) ,
KUNNR varchar2(80),
VKORG varchar2(80),
VTWEG varchar2(80),
SPART varchar2(80),
PARVW varchar2(80),
KUNN2 varchar2(80),
LIFNR varchar2(80),
PERNR varchar2(8),
PARNR varchar2(10),
DEFPA varchar2(1),
KNREF varchar2(30),
org_id number);

create or replace view sap_ar_sp_v
as
select
lot,
org_id ,
'"' || KUNNR || '";"' ||
VKORG || '";"' ||
VTWEG || '";"' ||
SPART || '";"' ||
PARVW || '";"' ||
KUNN2 || '";"' ||
LIFNR || '";"' ||
PERNR || '";"' ||
PARNR || '";"' ||
DEFPA || '";"' ||
KNREF || '";' line
from sap_ar_sp;

create or replace view sap_ar_gt_v
as select 
lot,
org_id , 
'"' || Customer_Number || '";"' ||
Text_ID || '";"' ||
Language_Key || '";"' ||
Text || '";'  "LINE"
from sap_ar_gt;

drop table sap_ar_cd;

create table sap_ar_cd (
lot varchar2(30) ,
Customer_Number varchar2(80),
Company_Code varchar2(80),
Posting_Block varchar2(80),
Payment_Block varchar2(80),
Previous_Accout_Number varchar2(10),
Dunning_Procedure varchar2(80),
Dunning_Block varchar2(80),
Dunning_Recipient varchar2(80),
Last_Dunning_Notice date,
Date_of_Legal_Dunning date,
Dunning_Level  number(1),
BUSAB_D  varchar2(80),
BUSAB_D_TRANSCO  varchar2(80),
Accounting_Clerk varchar2(80),
Account_at_Customer varchar2(12),
Phone varchar2(30),
Fax varchar2(31),
Decentralized_Processing varchar2(1),
Account_Memo varchar2(80),
Collective_Invoice_Variant varchar2(80),
ZTERM varchar2(80),
ZTERM_TRANSCO varchar2(80),
Payment_Method_1 varchar2(80),
Payment_Method_2 varchar2(80),
Payment_Method_3 varchar2(80),
Payment_Method_4 varchar2(80),
Payment_Method_5 varchar2(80),
Payment_Method_6 varchar2(80),
Payment_Method_7 varchar2(80),
Payment_Method_8 varchar2(80),
Payment_Method_9 varchar2(80),
Payment_Method_10 varchar2(80),
HBKID varchar2(80),
HBKID_TRANSCO varchar2(80),
Tolerance_Group varchar2(4),
Clearing_with_Vendor varchar2(1),
Payment_History_Record varchar2(1),
Individual_Payment varchar2(1),
Payment_Advice_by_EDI varchar2(1),
Alternative_Payer varchar2(10),
akont varchar2(80),
akont_transco varchar2(80),
Head_Office varchar2(10),
Key_for_sorting_according varchar2(3),
Planning_Group varchar2(80),
org_id number );
 
create or replace view sap_ar_cd_v
as select
lot,
org_id, 
'"' || Customer_Number || '";"' ||
Company_Code || '";"' ||
Posting_Block || '";"' ||
Payment_Block|| '";"' ||
Previous_Accout_Number || '";"' ||
Dunning_Procedure || '";"' ||
Dunning_Block || '";"' ||
Dunning_Recipient || '";"' ||
Last_Dunning_Notice || '";"' ||
Date_of_Legal_Dunning || '";"' ||
Dunning_Level  || '";"' ||
busab_d_transco || '";"' ||
Accounting_Clerk || '";"' ||
Account_at_Customer || '";"' ||
Phone || '";"' ||
Fax || '";"' ||
Decentralized_Processing || '";"' ||
Account_Memo || '";"' ||
Collective_Invoice_Variant || '";"' ||
ZTERM_TRANSCO || '";"' ||
Payment_Method_1 || '";"' ||
Payment_Method_2 || '";"' ||
Payment_Method_3 || '";"' ||
Payment_Method_4 || '";"' ||
Payment_Method_5 || '";"' ||
Payment_Method_6 || '";"' ||
Payment_Method_7 || '";"' ||
Payment_Method_8 || '";"' ||
Payment_Method_9 || '";"' ||
Payment_Method_10 || '";"' ||
HBKID_TRANSCO || '";"' ||
Tolerance_Group || '";"' ||
Clearing_with_Vendor || '";"' ||
Payment_History_Record || '";"' ||
Individual_Payment || '";"' ||
Payment_Advice_by_EDI || '";"' ||
Alternative_Payer || '";"' ||
akont_transco || '";"' ||
Head_Office || '";"' ||
Key_for_sorting_according || '";"' ||
Planning_Group || '";'  "LINE"
from sap_ar_cd
;

drop table sap_ar_aa;

create table sap_ar_aa (
lot varchar2(30) ,
KUNNR varchar2(132),
BU_ADEXT varchar2(132),
STREET varchar2(132),
HOUSE_NUM1 varchar2(132),
CITY2 varchar2(132),
HOME_CITY varchar2(132),
POST_CODE1 varchar2(132),
CITY1 varchar2(132),
COUNTRY varchar2(132),
REGION varchar2(132),
TIMEZON varchar2(132),
LZONE varchar2(132),
BUILDING varchar2(132),
ROOM varchar2(132),
FLOOR varchar2(132),
CO_NAME varchar2(132),
STR_SUPPL1 varchar2(132),
STR_SUPPL2 varchar2(132),
HOUSE_NO2 varchar2(132),
STR_SUPPL3 varchar2(132),
LOCATION varchar2(132),
TXJCD varchar2(132),
PO_BOX varchar2(132),
POST_CODE2 varchar2(132),
PO_BOX_LOC varchar2(132),
POBOX_CTRY varchar2(132),
PO_BOX_REG varchar2(132),
POST_CODE3 varchar2(132),
LANGU_CORR varchar2(132),
TELNR_LONG varchar2(132),
TELNR_LONG_2 varchar2(132),
TELNR_LONG_3 varchar2(132),
MOBILE_LONG varchar2(132),
MOBILE_LONG_2 varchar2(132),
MOBILE_LONG_3 varchar2(132),
FAXNR_LONG varchar2(132),
FAXNR_LONG_2 varchar2(132),
FAXNR_LONG_3 varchar2(132),
SMTP_ADDR varchar2(132),
SMTP_ADDR_2 varchar2(132),
SMTP_ADDR_3 varchar2(132),
URI_TYP varchar2(132),
URI_ADDR varchar2(132),
ORG_ID number );

create or replace view sap_ar_aa_v
as
select
lot,
org_id ,
'"' || KUNNR || '";"' ||
BU_ADEXT || '";"' ||
STREET || '";"' ||
HOUSE_NUM1 || '";"' ||
CITY2 || '";"' ||
HOME_CITY || '";"' ||
POST_CODE1 || '";"' ||
CITY1 || '";"' ||
COUNTRY || '";"' ||
REGION || '";"' ||
TIMEZON || '";"' ||
LZONE || '";"' ||
BUILDING || '";"' ||
ROOM || '";"' ||
FLOOR || '";"' ||
CO_NAME || '";"' ||
STR_SUPPL1 || '";"' ||
STR_SUPPL2 || '";"' ||
HOUSE_NO2 || '";"' ||
STR_SUPPL3 || '";"' ||
LOCATION || '";"' ||
TXJCD || '";"' ||
PO_BOX || '";"' ||
POST_CODE2 || '";"' ||
PO_BOX_LOC || '";"' ||
POBOX_CTRY || '";"' ||
PO_BOX_REG || '";"' ||
POST_CODE3 || '";"' ||
LANGU_CORR || '";"' ||
TELNR_LONG || '";"' ||
TELNR_LONG_2 || '";"' ||
TELNR_LONG_3 || '";"' ||
MOBILE_LONG || '";"' ||
MOBILE_LONG_2 || '";"' ||
MOBILE_LONG_3 || '";"' ||
FAXNR_LONG || '";"' ||
FAXNR_LONG_2 || '";"' ||
FAXNR_LONG_3 || '";"' ||
SMTP_ADDR || '";"' ||
SMTP_ADDR_2 || '";"' ||
SMTP_ADDR_3 || '";"' ||
URI_TYP || '";"' ||
URI_ADDR || '";' LINE
from sap_ar_aa;

drop table sap_ar_I;

create table sap_ar_I (
lot varchar2(30) ,
KUNNR varchar2(80) ,
IND_SECTOR varchar2(80),
ISDEF varchar2(1),
org_id number );

create or replace view SAP_AR_I_V
as select
lot,
ORG_ID,
'"' || KUNNR || '";"' ||
IND_SECTOR || '";"' ||
ISDEF|| '";' LINE
from SAP_AR_I;

drop table SAP_AR_TC;

create table SAP_AR_TC (
lot varchar2(30) ,
KUNNR varchar2(80) ,
ALAND varchar2(80) ,
TATYP varchar2(80) ,
TAXKD varchar2(80) ,
ORG_ID NUMBER);

create or replace view SAP_AR_TC_V
as 
select 
lot,
org_id ,
'"' || KUNNR || '";"' ||
ALAND || '";"' ||
TATYP || '";"' ||
TAXKD || '";'  LINE 
from sap_ar_tc;

drop table SAP_AR_TN;

create table SAP_AR_TN (
lot varchar2(30) ,
KUNNR varchar2(80) ,
TAXTYPE varchar2(80) ,
TAXNUM varchar2(60) ,
ORG_ID NUMBER);

create or replace view SAP_AR_TN_V
as 
select 
lot,
org_id ,
'"' || KUNNR || '";"' ||
TAXTYPE || '";"' ||
TAXNUM || '";' 
 LINE 
from sap_ar_tn;

drop table SAP_AR_IN;

create table SAP_AR_IN (
lot varchar2(30) ,
KUNNR varchar2(80) ,
TTYPE varchar2(80) ,
IDNUMBER varchar2(60) ,
ORG_ID NUMBER);

create or replace view SAP_AR_IN_V
as select 
lot,
org_id ,
'"' || KUNNR || '";"' ||
TTYPE || '";"' ||
IDNUMBER || '";' LINE
from sap_ar_in;


drop table sap_ar_cp;

create table sap_ar_cp (
lot varchar2(30) ,
KUNNR VARCHAR2(80) ,
PARNR VARCHAR2(10) ,
TITLE VARCHAR2(80) ,
VNAME VARCHAR2(40) ,
LNAME VARCHAR2(400) ,
LANGUCORR VARCHAR2(80) ,
ABTNR VARCHAR2(80) ,
PAFKT VARCHAR2(80) ,
PAVIP VARCHAR2(80) ,
COUNTRY VARCHAR2(80) ,
REGION VARCHAR2(80) ,
POSTLCD VARCHAR2(10) ,
CITY VARCHAR2(40) ,
STREET VARCHAR2(60) ,
HOUSE_NO VARCHAR2(10) ,
TXJCD VARCHAR2(10) ,
TEL_NO VARCHAR2(30) ,
TEL_NO_TRANSCO VARCHAR2(30) ,
MOBILE_NO VARCHAR2(30) ,
FAX_NO VARCHAR2(30) ,
E_MAIL VARCHAR2(241) ,
ORG_ID number);

create or replace view sap_ar_cp_v 
as select 
lot,
ORG_ID ,
'"' || KUNNR  || '";"' ||
PARNR  || '";"' ||
TITLE  || '";"' ||
VNAME  || '";"' ||
LNAME  || '";"' ||
LANGUCORR  || '";"' ||
ABTNR  || '";"' ||
PAFKT  || '";"' ||
PAVIP  || '";"' ||
COUNTRY  || '";"' ||
REGION  || '";"' ||
POSTLCD  || '";"' ||
CITY  || '";"' ||
STREET  || '";"' ||
HOUSE_NO  || '";"' ||
TXJCD  || '";"' ||
TEL_NO_TRANSCO  || '";"' ||
MOBILE_NO  || '";"' ||
FAX_NO  || '";"' ||
E_MAIL || '";'  LINE
from sap_ar_cp;


create or replace view sap_org 
as 
select distinct org_id from sap_ar_gd;

prompt ne plus utiliser la vue SAP_ORG

drop view sap_org;

drop table sap_ar_sd;


create table sap_ar_sd (
lot varchar2(30) ,
KUNNR		varchar2(	80    ),
VKORG		varchar2(	80    ),
VTWEG		varchar2(	80    ),
SPART		varchar2(	80    ),
KDGRP		varchar2(	80    ),
BZIRK		varchar2(	80    ),
VKBUR		varchar2(	80    ),
VKGRP		varchar2(	80    ),
EIKTO		varchar2(	12    ),
AWAHR		Number	( 3     ),
KLABC		varchar2(	2     ),
PVKSM		varchar2(	80    ),
WAERS		varchar2(	80    ),
KURST		varchar2(	80    ),
KONDA		varchar2(	80    ),
PLTYP		varchar2(	80    ),
KALKS		varchar2(	80    ),
VERSG		varchar2(	80    ),
LPRIO		varchar2(	80    ),
KZAZU		varchar2(	1     ),
VSBED		varchar2(	80    ),
PODKZ		varchar2(	1     ),
PODTG		Number	( 6     ),
VWERK		varchar2(	80    ),
AUTLF		varchar2(	1     ),
ANTLF		Number	( 1     ),
KZTLF		varchar2(	80    ),
UEBTK		varchar2(	1     ),
UNTTO		Number	( 3     ),
UEBTO		Number	( 3     ),
MRNKZ		varchar2(	1     ),
BOKRE		varchar2(	1     ),
PRFRE		varchar2(	1     ),
PERFK		varchar2(	80    ),
PERRL		varchar2(	80    ),
INCOV		varchar2(	80    ),
INCO1		varchar2(	80    ),
INCO2		varchar2(	70    ),
INCO3_L		varchar2(	70    ),
ZTERM		varchar2(	80    ),
ZTERM_TRANSCO		varchar2(	80    ),
KABSS		varchar2(	80    ),
KTGRD		varchar2(	80    ),
KTGRD_TRANSCO		varchar2(	80    ),
KVGR1		varchar2(	80    ),
KVGR1_TRANSCO 	varchar2(	80    ),
KVGR2		varchar2(	80    ),
KVGR3		varchar2(	80    ),
KVGR4		varchar2(	80    ),
KVGR5		varchar2(	80    ),
AUFSD		varchar2(	80    ),
LIFSD		varchar2(	80    ),
FAKSD		varchar2(	80    ),
ORG_ID Number
);

create or replace view sap_ar_sd_v 
as select 
lot,
org_id , 
'"' || KUNNR		|| '";"' ||
VKORG		|| '";"' ||
VTWEG		|| '";"' ||
SPART		|| '";"' ||
KDGRP		|| '";"' ||
BZIRK		|| '";"' ||
VKBUR		|| '";"' ||
VKGRP		|| '";"' ||
EIKTO		|| '";"' ||
AWAHR		|| '";"' ||
KLABC		|| '";"' ||
PVKSM		|| '";"' ||
WAERS		|| '";"' ||
KURST		|| '";"' ||
KONDA		|| '";"' ||
PLTYP		|| '";"' ||
KALKS		|| '";"' ||
VERSG		|| '";"' ||
LPRIO		|| '";"' ||
KZAZU		|| '";"' ||
VSBED		|| '";"' ||
PODKZ		|| '";"' ||
PODTG		|| '";"' ||
VWERK		|| '";"' ||
AUTLF		|| '";"' ||
ANTLF		|| '";"' ||
KZTLF		|| '";"' ||
UEBTK		|| '";"' ||
UNTTO		|| '";"' ||
UEBTO		|| '";"' ||
MRNKZ		|| '";"' ||
BOKRE		|| '";"' ||
PRFRE		|| '";"' ||
PERFK		|| '";"' ||
PERRL		|| '";"' ||
INCOV		|| '";"' ||
INCO1		|| '";"' ||
INCO2		|| '";"' ||
INCO3_L		|| '";"' ||
ZTERM_TRANSCO		|| '";"' ||
KABSS		|| '";"' ||
KTGRD_TRANSCO		|| '";"' ||
KVGR1_TRANSCO		|| '";"' ||
KVGR2		|| '";"' ||
KVGR3		|| '";"' ||
KVGR4		|| '";"' ||
KVGR5		|| '";"' ||
AUFSD		|| '";"' ||
LIFSD		|| '";"' ||
FAKSD		|| '";'   LINE
from sap_ar_sd
;

