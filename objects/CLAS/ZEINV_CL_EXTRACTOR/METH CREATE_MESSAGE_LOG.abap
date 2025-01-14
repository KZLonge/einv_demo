  METHOD create_message_log.
    DATA: lv_message(200) TYPE c.

    lv_message = im_message.

    CASE im_status.
      WHEN 'S'.
        DATA(lv_status) = if_bali_constants=>c_severity_default.
      WHEN 'E'.
        lv_status = if_bali_constants=>c_severity_error.
      WHEN 'W'.
        lv_status = if_bali_constants=>c_severity_warning.
    ENDCASE.
    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object = 'ZEINV_APPL_LOG_OBJ'
                                                                                      subobject = 'ZEINV_APPL_LOG_SUB' ) ).

*        "Add a message as item to the log
*        DATA(l_message) = cl_bali_message_setter=>create( severity = if_bali_constants=>c_severity_error
*                                                          id = 'PO'
*                                                          number = '000' ).
*        l_log->add_item( item = l_message ).
*
*        l_log->add_item( item = cl_bali_message_setter=>create_from_sy( ) ).

        "Add a free text to the log

        DATA(l_free_text) = cl_bali_free_text_setter=>create( severity = lv_status
                                                                  text = lv_message ).

        l_log->add_item( item = l_free_text ).

*        " Add an exception to the log
*        DATA: i TYPE i.
*        TRY.
*            i = 1 / 0.
*          CATCH cx_sy_zerodivide INTO DATA(l_ref).
*        ENDTRY.
*
*        DATA(l_exception) = cl_bali_exception_setter=>create( severity =
*                                   if_bali_constants=>c_severity_error
*                                   exception = l_ref ).
*        l_log->add_item( item = l_exception ).

        "Save the log into the database
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).

    ENDTRY.
  ENDMETHOD.