unmanaged implementation in class zbp_einv_r_root_document unique;
strict ( 2 );

define behavior for ZEINV_R_ROOT_DOCUMENT alias eInvDocument
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly ) Companycode, Fiscalyear, Accountingdocument;


  action submitInvoice result[1] $self;
  static action extractInvoice;
  event documentCreation parameter ZEINV_DOCUMENT_EVENT;
}