CLASS LCL_JOURNALENTRY_CREATED_V1 DEFINITION FINAL INHERITING FROM /IWXBE/CL_ABS_CONSUMER_EVENT.
  PUBLIC SECTION.
    INTERFACES:
      ZIF_JOURNALENTRY_CREATED_V1.

ENDCLASS.

CLASS LCL_JOURNALENTRY_CREATED_V1 IMPLEMENTATION.
  METHOD ZIF_JOURNALENTRY_CREATED_V1~GET_BUSINESS_DATA.
      mo_event->get_business_data( IMPORTING es_business_data = rs_business_data ).
  ENDMETHOD.
ENDCLASS.