CLASS lcl_buffer DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer.

    METHODS get_data EXPORTING et_einv_document TYPE zeinv_tty_einv_document.

    METHODS put_data IMPORTING it_einv_document TYPE zeinv_tty_einv_document.

  PRIVATE SECTION.
    CLASS-DATA: go_instance TYPE REF TO lcl_buffer.
    DATA: gt_einv_document TYPE zeinv_tty_einv_document.
ENDCLASS.

CLASS lcl_buffer IMPLEMENTATION.
  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD get_data.
    et_einv_document[] = gt_einv_document[].
  ENDMETHOD.

  METHOD put_data.
    gt_einv_document[] = it_einv_document[].
  ENDMETHOD.
ENDCLASS.

CLASS lhc_zeinv_r_root_document DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF http_status,
        code   TYPE i,
        reason TYPE string,
      END OF http_status .

    DATA: lt_journal_entry TYPE TABLE OF i_journalentry.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR einvdocument RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE einvdocument.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE einvdocument.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE einvdocument.

    METHODS read FOR READ
      IMPORTING keys FOR READ einvdocument RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK einvdocument.

    METHODS submitinvoice FOR MODIFY
      IMPORTING keys   FOR ACTION einvdocument~submitinvoice
      RESULT    result.

    METHODS extractinvoice FOR MODIFY
      IMPORTING keys FOR ACTION einvdocument~extractinvoice.

    METHODS buildxml EXPORTING ex_payload TYPE zeinv_tty_payload
                               ex_string  TYPE string.

    METHODS callapi IMPORTING ex_payload    TYPE zeinv_tty_payload
                              ex_xml        TYPE string OPTIONAL
                    RETURNING VALUE(result) TYPE http_status.

    METHODS modify_einv_doc IMPORTING im_status TYPE http_status.

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
    DATA: lv_string TYPE string.
    DATA: lt_einv_update TYPE TABLE OF zeinv_document,
          ls_einv_update TYPE zeinv_document.

    READ TABLE keys INTO DATA(lw_keys) INDEX 1.
    IF sy-subrc = 0.

    ENDIF.

    SELECT *
        FROM i_journalentry WITH PRIVILEGED ACCESS
        WHERE companycode = @lw_keys-companycode
          AND fiscalyear = @lw_keys-fiscalyear
          AND accountingdocument = @lw_keys-accountingdocument
        INTO TABLE @lt_journal_entry.
    IF sy-subrc = 0.
      "Build XML
      me->buildxml( IMPORTING ex_payload = DATA(ls_payload)
                              ex_string = DATA(lv_xml_string) ).

      me->callapi(
        EXPORTING
          ex_payload = ls_payload
          ex_xml     = lv_xml_string
        RECEIVING
          result     = DATA(lv_status)
      ).

      DATA(lv_message) = |{ 'API Response Status: ' }{ '(' }{ lv_status-code }{ ')' }{ lv_status-reason }|.
      reported-einvdocument = VALUE #( ( %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-information text = lv_message ) ) ).

      modify_einv_doc( EXPORTING im_status = lv_status ).

      READ ENTITIES OF zc_einv_r_root_document ENTITY einvdocument
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_read)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

    ENDIF.
  ENDMETHOD.

  METHOD extractinvoice.
    DATA(lv_message) = |{ 'Extract Button Pressed' }|.
    reported-einvdocument = VALUE #( ( %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-information text = lv_message ) ) ).
  ENDMETHOD.

  METHOD buildxml.
    DATA: lv_body TYPE string.
    DATA: lw_structure_line TYPE zeinv_st_payload.

    LOOP AT lt_journal_entry INTO DATA(lwa_journal_entry).
      lw_structure_line-eivheader = CORRESPONDING #( lwa_journal_entry ).

      lw_structure_line-eivitem = VALUE #( ( lineid = '1' descprodserv = 'Item 1' unitprice = '1.00' eivcurrency = 'MYR' taxamount = '0.06' )
                                           ( lineid = '2' descprodserv = 'Item 2' unitprice = '2.00' eivcurrency = 'MYR' taxamount = '0.12' ) ).

      APPEND lw_structure_line TO ex_payload.
    ENDLOOP.
    IF sy-subrc = 0.
      ex_string = 'No Table Entries'.
    ENDIF.

    CALL TRANSFORMATION ztrans_einv_xml
    SOURCE invoices = ex_payload
    RESULT XML lv_body
    OPTIONS xml_header     = 'no'
            value_handling = 'move'.
    IF sy-subrc = 0.
      ex_string = lv_body.
    ENDIF.

  ENDMETHOD.

  METHOD callapi.
    CONSTANTS: lc_scenario_id TYPE if_com_management=>ty_cscn_id VALUE 'ZEINV_COMS_SCPI_2',
               lc_service_id  TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'ZEINV_OUTS_SCPI_2_REST'.
    DATA lo_http_handler TYPE REF TO zcl_http_communication_handler.

    TRY.
        IF lo_http_handler IS INITIAL.
          CREATE OBJECT lo_http_handler.
        ENDIF.

        IF lo_http_handler IS BOUND.
          DATA(lo_response) = lo_http_handler->send_request_by_arrangement(
                                scenario_id = lc_scenario_id
                                service_id  = lc_service_id
                                query = ex_xml ).
          result = lo_response->get_status(  ).
        ENDIF.

      CATCH cx_http_dest_provider_error.
      CATCH cx_web_http_client_error.
      CATCH cx_communication_target_error.
      CATCH cx_appdestination.
    ENDTRY.
  ENDMETHOD.

  METHOD modify_einv_doc.
    DATA: lt_einv_update TYPE TABLE OF zeinv_document,
          ls_einv_update TYPE zeinv_document.

    LOOP AT lt_journal_entry INTO DATA(ls_journal_entry).
      ls_einv_update = CORRESPONDING #( ls_journal_entry ).
      ls_einv_update-status = COND #( WHEN im_status-code EQ '200' THEN 'Accepted'
                                      ELSE 'Rejected' ).

      APPEND ls_einv_update TO lt_einv_update[].
    ENDLOOP.

    DATA(lv_count) = lines( lt_einv_update ).

*    APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
*                                                   text = lv_message ) )
*                                                   TO reported-einvdocument.

    IF lt_einv_update[] IS NOT INITIAL.
      DATA(lo_buffer) = lcl_buffer=>get_instance( ).
      lo_buffer->put_data( it_einv_document = lt_einv_update[] ).
    ENDIF.


  ENDMETHOD.


ENDCLASS.

CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA: lt_einv_update TYPE TABLE OF zeinv_document,
          ls_einv_update TYPE zeinv_document.

*    reported-einvdocument = VALUE #( ( %msg = new_message_with_text(
*          severity = if_abap_behv_message=>severity-information text = 'Start read table' ) ) ).

    DATA(lo_buffer) = lcl_buffer=>get_instance(  ).
    lo_buffer->get_data( IMPORTING et_einv_document = lt_einv_update[] ).

    IF lt_einv_update[] IS NOT INITIAL.
      MODIFY zeinv_document FROM TABLE @lt_einv_update.

      IF sy-subrc = 0.
        DATA(lv_message) = |{ 'Table Modify Success' }|.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                     text = lv_message ) )
                                                     TO reported-einvdocument.

        "Raise documentCreated event
        RAISE ENTITY EVENT zeinv_r_root_document~documentcreation
            FROM VALUE #( FOR ls_zeinv_document IN lt_einv_update (
              companycode        = ls_zeinv_document-companycode
              fiscalyear        = ls_zeinv_document-fiscalyear
              accountingdocumenttype          = ls_zeinv_document-accountingdocumenttype
              accountingdocument  = ls_zeinv_document-accountingdocument ) )..
      ELSE.
        lv_message = |{ 'Table Modify Failed' }|.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                     text = lv_message ) )
                                                     TO reported-einvdocument.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.