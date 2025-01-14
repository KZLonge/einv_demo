projection;
strict ( 2 );

define behavior for ZC_EINV_R_ROOT_DOCUMENT alias eInvDocument
{
  use create;
  use update;
//  use delete;

  use action submitInvoice;
}