
create or replace package SAP_TOOLS_ARFAC
as

function gkont(   p_customer_trx_id in number) return varchar2;
function type_piece(   p_type in varchar2) return varchar2;
-- function transco_code_tva(   p_in_code_tva in varchar2) return varchar2;
-- function transco_compte_tva(   p_in  in varchar2) return varchar2;
-- function transco_code_terms(   p_customer_trx_id in number) return varchar2;
-- function transco_code_method(   p_customer_trx_id in number) return varchar2;
function transco_code_blocage(   p_customer_trx_id in number) return varchar2;
function boucler_hbkid(   p_customer_trx_id in number) return varchar2;
function boucler_hktid(   p_customer_trx_id in number) return varchar2;
function boucler_bvtyp(   p_customer_trx_id in number) return varchar2;


end SAP_TOOLS_ARFAC;
/

show error


create or replace package body SAP_TOOLS_ARFAC
as

function gkont(   p_customer_trx_id in number) return varchar2
is
begin

return '99999998';

end;

function type_piece(   p_type in varchar2) return varchar2
is
retour varchar2(80);
begin

select decode(p_type, 'CM','CX','INV', 'CY', p_type)
into retour
from dual;

return retour;

end;

/*
function transco_compte_tva(   p_in  in varchar2) return varchar2
is
begin

return p_in;

end;
*/

/*
function transco_code_tva(   p_in_code_tva in varchar2) return varchar2
is
begin

return p_in_code_tva;

end;

*/


/* function transco_code_terms(   p_customer_trx_id in number) return varchar2
is
begin

return 'ZE30';

end;
*/

/*
function transco_code_method(   p_customer_trx_id in number) return varchar2
is
begin

return 'T';

end;
*/


function transco_code_blocage(   p_customer_trx_id in number) return varchar2
is
begin

return 'BLOCAGE';

end;

function boucler_hbkid(   p_customer_trx_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_HBKID';

end;

function boucler_hktid(   p_customer_trx_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_HKTID';

end;

function boucler_bvtyp(   p_customer_trx_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_BVTYP';

end;

end SAP_TOOLS_ARFAC;
/


show error

