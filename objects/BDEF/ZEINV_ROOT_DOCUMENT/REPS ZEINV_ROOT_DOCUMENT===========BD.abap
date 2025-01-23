projection;
strict ( 2 );

define behavior for ZEINV_ROOT_DOCUMENT alias eInvDocument
{
  use create;
  use update;
  use delete;

  use action submitInvoice;
  use action extractInvoice;
}