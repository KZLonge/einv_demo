CLASS LTC_CONSUMER DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    DATA:
      MO_CUT TYPE REF TO ZEINV_CL_EINV.

    METHODS:
      SETUP,
      HANDLE_JOURNALENTRY_CREATED_V1 FOR TESTING
        RAISING
          CX_STATIC_CHECK.
ENDCLASS.

CLASS LTC_CONSUMER IMPLEMENTATION.
  METHOD SETUP.
  mo_cut = NEW #( ).
  ENDMETHOD.
  METHOD HANDLE_JOURNALENTRY_CREATED_V1.
*    DATA: lo_event_dbl TYPE REF TO ZIF_JOURNALENTRY_CREATED_V1.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZIF_JOURNALENTRY_CREATED_V1' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZIF_JOURNALENTRY_CREATED_V1=>ty_s_journalentry_created_v1( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_journalentry_created_v1 is called
*    mo_cut->ZEINV_IF_EINV_HANDLER~handle_journalentry_created_v1( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
ENDCLASS.