  METHOD send_request_by_url.
    DATA: lo_http_destination TYPE REF TO if_http_destination.
    DATA: lo_http_client TYPE REF TO if_web_http_client.
    DATA: lv_response TYPE string.


    TRY.
        " Send JSON of post to server and return the response
        DATA(client) = create_client( url ).
        DATA(req) = client->get_http_request(  ).

        "Set Authentication
        IF username IS NOT INITIAL AND password IS NOT INITIAL.
          req->set_authorization_basic( i_username = username
                                        i_password = password ).
        ENDIF.

        IF content_type = 'JSON' OR content_type IS INITIAL.
          " Convert input post to JSON
          DATA(json_post) = xco_cp_json=>data->from_abap( payload )->apply(
              VALUE #( ( xco_cp_json=>transformation->underscore_to_camel_case ) ) )->to_string(  ).

          "Set Pay load body
          req->set_text( json_post ).

          "Set Header Parameter
          req->set_header_field( i_name = content_type i_value = json_content ).
        ELSEIF content_type = 'XML'.
          "Set Pay load body
          req->set_text( payload ).

          "Set Header Parameter
          req->set_header_field( i_name = content_type i_value = xml_content ).
        ENDIF.

        lo_response = client->execute( if_web_http_client=>post ).

        client->close(  ).

      CATCH cx_static_check.


    ENDTRY.
  ENDMETHOD.