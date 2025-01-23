CLASS zcl_http_communication_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: content_type TYPE string VALUE 'Content-type',
               json_content TYPE string VALUE 'application/json; charset=UTF-8',
               xml_content  TYPE string VALUE 'application/xml; charset=UTF-8'.

    METHODS: create_client IMPORTING url           TYPE string
                           RETURNING VALUE(result) TYPE REF TO if_web_http_client
                           RAISING   cx_static_check.


    """ HTTP Communication via URL """
    METHODS: send_request_by_url IMPORTING url                TYPE string
                                           payload            TYPE string
                                           payload_format     TYPE string OPTIONAL "JSON or XML
                                           username           TYPE string OPTIONAL
                                           password           TYPE string OPTIONAL
                                 RETURNING VALUE(lo_response) TYPE REF TO if_web_http_response
                                 RAISING   cx_web_http_client_error.

    """ HTTP Communication via Communication Arrangement """
    METHODS: send_request_by_arrangement IMPORTING scenario_id        TYPE if_com_management=>ty_cscn_id
                                                   service_id         TYPE if_com_management=>ty_cscn_outb_srv_id OPTIONAL
                                                   url_path           TYPE string OPTIONAL
                                                   query              TYPE string OPTIONAL
                                         RETURNING VALUE(lo_response) TYPE REF TO if_web_http_response
                                         RAISING   cx_http_dest_provider_error cx_web_http_client_error
                                                   cx_communication_target_error cx_appdestination.