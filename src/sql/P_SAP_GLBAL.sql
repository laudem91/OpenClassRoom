
create or replace package SAP_TOOLS_GLBAL
as

function transco_compte_gene(   p_in  in varchar2) return varchar2;


end SAP_TOOLS_GLBAL;
/

show error


create or replace package body SAP_TOOLS_GLBAL
as


function transco_compte_gene(   p_in  in varchar2) return varchar2
is
begin

return p_in;

end;

end SAP_TOOLS_GLBAL;
/


show error

