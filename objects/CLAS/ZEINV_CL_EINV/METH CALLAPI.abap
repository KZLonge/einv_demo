  METHOD callapi.
    CONSTANTS: lc_scenario_id TYPE if_com_management=>ty_cscn_id VALUE 'ZEINV_COMS_SCPI_2',
               lc_service_id  TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'ZEINV_OUTS_SCPI_2_REST'.
    DATA lo_http_handler TYPE REF TO zcl_http_communication_handler.

    " Convert input post to JSON
    DATA(json_post) = xco_cp_json=>data->from_abap( ex_payload )->apply(
      VALUE #( ( xco_cp_json=>transformation->underscore_to_camel_case ) ) )->to_string(  ).

    TRY.
        IF lo_http_handler IS INITIAL.
          CREATE OBJECT lo_http_handler.
        ENDIF.

        IF lo_http_handler IS BOUND.
          DATA(lo_response) = lo_http_handler->send_request_by_arrangement(
                                scenario_id = lc_scenario_id
                                service_id  = lc_service_id
                                query = json_post ).
          result = lo_response->get_status(  ).
        ENDIF.

      CATCH cx_http_dest_provider_error.
      CATCH cx_web_http_client_error.
      CATCH cx_communication_target_error.
      CATCH cx_appdestination.
    ENDTRY.
  ENDMETHOD.