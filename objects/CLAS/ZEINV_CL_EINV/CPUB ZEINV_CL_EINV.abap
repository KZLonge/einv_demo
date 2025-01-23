CLASS zeinv_cl_einv DEFINITION
  PUBLIC
  INHERITING FROM zeinv_cl_einv_journal_event
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF http_status,
        code   TYPE i,
        reason TYPE string,
      END OF http_status .
    DATA: lt_journal_entry TYPE TABLE OF i_journalentry.

    METHODS zeinv_if_einv_handler~handle_journalentry_created_v1
        REDEFINITION .

    METHODS buildxml EXPORTING ex_payload TYPE zeinv_tty_payload
                               ex_string  TYPE string.

    METHODS callapi IMPORTING ex_payload    TYPE zeinv_tty_payload
                              ex_xml        TYPE string OPTIONAL
                    RETURNING VALUE(result) TYPE http_status.

    METHODS:
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.