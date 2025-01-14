projection implementation in class ZBP_C_EINV_RULE unique;
strict ( 2 );
use draft;
define behavior for ZC_EINV_RULE alias eInvRule
use etag

{
  use create;
  use update;
  use delete;

  use action Edit;
  use action Activate;
  use action Discard;
  use action Resume;
  use action Prepare;
}