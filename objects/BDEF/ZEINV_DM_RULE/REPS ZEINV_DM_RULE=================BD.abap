managed implementation in class ZEINV_BP_R_EINV_RULE unique;
strict ( 2 );
define behavior for ZEINV_DM_RULE alias EinvRuleTable
persistent table ZEINV_RULE
etag master Locallastchange
lock master
authorization master( global )

{
  field ( mandatory : create )
   Companycode,
   Accountingdocumenttype;

  field ( readonly )
   Locallastchange,
   Lastchange,
   Createdby,
   Changedby;

  field ( readonly : update )
   Companycode,
   Accountingdocumenttype;


  create;
  update;
  delete;

  mapping for ZEINV_RULE
  {
    Companycode = companycode;
    Accountingdocumenttype = accountingdocumenttype;
    Validfromdate = validfromdate;
    Validtodate = validtodate;
    Locallastchange = locallastchange;
    Lastchange = lastchange;
    Createdby = createdby;
    Changedby = changedby;
  }
}