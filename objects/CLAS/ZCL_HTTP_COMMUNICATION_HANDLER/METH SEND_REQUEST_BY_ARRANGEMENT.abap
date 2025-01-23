  METHOD send_request_by_arrangement.
    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    TRY.
        " find Communication Arrangement by Communication Scenario
        lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = scenario_id ) ).

        DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
        lo_factory->query_ca(
          EXPORTING
            is_query           = VALUE #( cscn_id_range = lr_cscn )
          IMPORTING
            et_com_arrangement = DATA(lt_ca) ).

        IF lt_ca IS INITIAL.
          RAISE EXCEPTION TYPE cx_web_http_client_error.
        ENDIF.

        " take the first one
        READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

        " get destination based to Communication Arrangement
        TRY.
            DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
                comm_scenario  = scenario_id
                service_id     = service_id
                comm_system_id = lo_ca->get_comm_system_id( ) ).
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

            " execute the request
            DATA(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_text( query ).
            lo_response = lo_http_client->execute( if_web_http_client=>get ).

          CATCH cx_http_dest_provider_error INTO DATA(lx_des_provider).
            RAISE EXCEPTION TYPE cx_http_dest_provider_error.

          CATCH cx_web_http_client_error INTO DATA(lx_app_dest).
            RAISE EXCEPTION TYPE cx_web_http_client_error.
        ENDTRY.

      CATCH cx_appdestination INTO DATA(lx_appdestination).
        RAISE EXCEPTION TYPE cx_appdestination.
      CATCH cx_communication_target_error INTO DATA(lx_communication_target_error).
        RAISE EXCEPTION TYPE cx_communication_target_error.
      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        RAISE EXCEPTION TYPE cx_web_http_client_error.
      CATCH cx_http_dest_provider_error INTO DATA(lx_dest_provider_error).
        RAISE EXCEPTION TYPE cx_http_dest_provider_error.

    ENDTRY.
  ENDMETHOD.