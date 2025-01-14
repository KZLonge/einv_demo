managed implementation in class ZBP_R_EINV_RULE unique;
strict ( 2 );
with draft;
define behavior for ZR_EINV_RULE alias eInvRule
persistent table ZEINV_RULE
draft table ZEINV_RULE_D
etag master Locallastchange
lock master total etag Lastchange
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

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

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