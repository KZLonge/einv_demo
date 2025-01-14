CLASS lhc_zeinv_r_root_document DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR eInvDocument RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE eInvDocument.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE eInvDocument.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE eInvDocument.

    METHODS read FOR READ
      IMPORTING keys FOR READ eInvDocument RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK eInvDocument.

    METHODS submitinvoice FOR MODIFY
      IMPORTING keys FOR ACTION eInvDocument~submitinvoice.

ENDCLASS.

CLASS lhc_zeinv_r_root_document IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD submitinvoice.
    DATA(lv_message) = |{ 'Submit Button Pressed' }|.
    reported-einvdocument = VALUE #( ( %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-information text = lv_message ) ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zeinv_r_root_document DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zeinv_r_root_document IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.