  METHOD if_oo_adt_classrun~main.
    DATA lo_cota TYPE REF TO zeinv_comt_scpi_cota.
    DATA lt_output TYPE STANDARD TABLE OF string.
    DATA lv_appl_dest TYPE sappdestname.
    DATA lo_com_handler TYPE REF TO zcl_http_communication_handler.

    IF lo_com_handler IS INITIAL.
      CREATE OBJECT lo_com_handler.
    ENDIF.

    out->write( 'Start RUN API' ).
    TRY.
        lo_com_handler->send_request_by_arrangement(
          EXPORTING
            scenario_id = 'SAP_COM_0092'
            service_id  = 'SAP_COM_0092_0001_REST'
*            url_path    =
*            query       =
          RECEIVING
            lo_response = DATA(lo_response)
        ).

        out->write( lo_response->get_status(  )-code ).
        out->write( lo_response->get_text(  ) ).
      CATCH cx_http_dest_provider_error.
      CATCH cx_web_http_client_error.
      CATCH cx_communication_target_error.
      CATCH cx_appdestination.
    ENDTRY.

  ENDMETHOD.